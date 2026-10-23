repeat task.wait() until game:IsLoaded()
local Players,RunService,UIS,TS,Lighting,HS = game:GetService("Players"),game:GetService("RunService"),game:GetService("UserInputService"),game:GetService("TweenService"),game:GetService("Lighting"),game:GetService("HttpService")
local LP = Players.LocalPlayer
local NS,CS = 60,30
local LAGGER_SPEED = 15
local LAGGER_CARRY_SPEED = 24.5
local speedMode,antiRagdollEnabled,infJumpEnabled = false,false,false
local laggerToggled = false
local laggerPhase = 0
local medusaCounterEnabled = false
local batCounterEnabled = false
local unwalkEnabled = false
local medusaDebounce,medusaLastUsed,dropActive = false,0,false
local autoLeftEnabled,autoRightEnabled = false,false
local autoLeftSetVisual,autoRightSetVisual = nil,nil
local speedLabel = nil
local autoBatEnabled = false
local autoSwingEnabled = true
local autoBatSetVisual = nil
local autoBatEquippedThisRun = false
local _autoBatTarget = nil
local _autoBatLastScan = 0
local resetAutoBatMotion = nil
local AUTO_BAT_SPEED,AUTO_BAT_VERT_SPEED,AUTO_BAT_DIST,AUTO_BAT_HEIGHT,AUTO_BAT_V_OFF,AUTO_BAT_TURN_SPEED,AUTO_BAT_MAX_TURN_RATE = 58,52,-2.8,4.75,1,285,28
local setBatCounterVisual = nil
local startBatCounter,stopBatCounter
local antiLagEnabled = false
local removeAccessoriesEnabled = false
local antiLagDescConn = nil
local stretchRezEnabled = false
local setStretchRezVisual = nil
-- All extra Tooze state lives in a single table to save local registers
local V = {
	customFovEnabled=false, customFovValue=70, customFovConn=nil, setCustomFovVisual=nil, customFovBox=nil,
	skyTheme="Off", setSkyVisual=nil, skyValLbl=nil,
	ultraModeEnabled=false, setUltraModeVisual=nil,
	removeAccessoriesEnabledSep=false, setRemoveAccVisual=nil, removeAccConn=nil,
	customFontEnabled=false, setCustomFontVisual=nil,
	potatoGraphicsEnabled=false, setPotatoVisual=nil, potatoConn=nil,
	autoSaveEnabled=true, setAutoSaveVisual=nil,
	themeAccent=nil,  -- {R,G,B} 0-1 floats; nil = default blue
	sidebarArt="83597321089055",  -- which preset image is currently shown
	hideMobileButtons=false, lockMobileButtons=false, mobileBtnPos={},
	MOBILE_LAYOUT_VER=4, mobileMoveAll=false,
	mobileBtnScale=0.80, mobileScaleObjs={},
	stealBarScale=1, uiScale=1, stealBarPos=nil, mainPos=nil,
	introSong=1, setIntroSongVisual=nil,
}
local setAccent_global = nil
local setSidebarArt_global = nil
local setPlayerESPVisual = nil
local PlayerESP = {enabled = false, playerData = {}, conns = {}, conn = nil, gui = nil, discordText = "discord.gg/NrJaxfK54d"}
local THEME_ACCENT = Color3.fromRGB(192, 192, 192)
local THEME_ACCENT_DIM = Color3.fromRGB(125, 125, 125)
local THEME_ACCENT_BRIGHT = Color3.fromRGB(230, 230, 230)
local _themedCallbacks = {}
local function trackTheme(fn)
	table.insert(_themedCallbacks, fn)
	pcall(fn, THEME_ACCENT)
end
local function setAccent(c)
	THEME_ACCENT = c
	THEME_ACCENT_DIM = Color3.new(c.R * 0.65, c.G * 0.65, c.B * 0.65)
	THEME_ACCENT_BRIGHT = Color3.new(math.min(1, c.R + 0.3), math.min(1, c.G + 0.3), math.min(1, c.B + 0.3))
	for _, fn in ipairs(_themedCallbacks) do pcall(fn, c) end
end
setAccent_global = setAccent
local SIDEBAR_ART_PRESETS = {
	{name = "Anime", id = "82028776918457"},
	{name = "Dark",  id = "115117078011241"},
}
local CURRENT_ART_ID = "83597321089055"
local startPlayerESP, stopPlayerESP
local unwalkSavedAnimate = nil
local _anyKeyListening = false
local autoTPEnabled = false
local autoTPHeight = 20
local autoTPConn = nil
local startAutoTP, stopAutoTP, doAutoTPDown
local setAutoTPVisual = nil
local cursedResetRemote = nil
local cursedInstaReset
local CURSED_RESET_GUID = "f888ee6e-c86d-46e1-93d7-0639d6635d42"
pcall(function()
	if hookfunction and newcclosure then
		local oldFire
		oldFire=hookfunction(Instance.new("RemoteEvent").FireServer,newcclosure(function(self,...)
			if not cursedResetRemote and typeof(self)=="Instance" and self:IsA("RemoteEvent") and self.Name:sub(1,3)=="RE/" then cursedResetRemote=self end
			return oldFire(self,...)
		end))
	end
end)
task.spawn(function()
	task.wait(2)
	if cursedResetRemote then return end
	for _,desc in ipairs(game:GetDescendants()) do
		if desc:IsA("RemoteEvent") and desc.Name:sub(1,3)=="RE/" then cursedResetRemote=desc;break end
	end
end)
-- ============================================================
-- INSTANT RESET — sistema COMPLETO portado do CURSED HUB
--   1) _hasBrainrot(): detecta se voce esta segurando um brainrot
--   2) cooldown de 0.5s (anti spam / anti kick)
--   3) metodo principal do Cursed: joga o HRP pra cima com
--      AssemblyLinearVelocity.Y = 10000000 (morte instantanea)
--   4) fallback do Vexus: spam do remote "RE/" com o GUID, caso o
--      metodo de velocidade esteja patchado no jogo
-- Locais ficam num do...end pra nao estourar o limite de 200.
-- ============================================================
do
	local _resetCooldownActive = false
	local function _hasBrainrot()
		local c = LP.Character
		if not c then return false end
		for _, t in ipairs(c:GetChildren()) do
			if t:IsA("Tool") and string.find(string.lower(t.Name), "brain", 1, true) then return true end
		end
		return false
	end
	V.hasBrainrot = _hasBrainrot
	-- fallback: remote do jogo (metodo antigo do Vexus)
	local function _resetViaRemote()
		if not cursedResetRemote then
			for _, desc in ipairs(game:GetDescendants()) do
				if desc:IsA("RemoteEvent") and desc.Name:sub(1, 3) == "RE/" then cursedResetRemote = desc; break end
			end
		end
		if not cursedResetRemote then return false end
		local character = LP.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		if humanoid and humanoid.Health <= 0 then
			pcall(function() cursedResetRemote:FireServer(CURSED_RESET_GUID, LP, "balloon") end)
			return true
		end
		local resetDetected = false
		local conns = {}
		if humanoid then
			table.insert(conns, humanoid.Died:Connect(function() resetDetected = true end))
			table.insert(conns, humanoid:GetPropertyChangedSignal("Health"):Connect(function()
				if humanoid.Health <= 0 then resetDetected = true end
			end))
		end
		if character then
			table.insert(conns, character.AncestryChanged:Connect(function(_, parent)
				if not parent then resetDetected = true end
			end))
		end
		task.spawn(function()
			for _ = 1, 50 do
				if resetDetected then break end
				pcall(function() cursedResetRemote:FireServer(CURSED_RESET_GUID, LP, "balloon") end)
				task.wait()
			end
			for _, conn in ipairs(conns) do pcall(function() conn:Disconnect() end) end
		end)
		return true
	end
	function cursedInstaReset()
		if _resetCooldownActive then return end
		_resetCooldownActive = true
		task.delay(0.5, function() _resetCooldownActive = false end)
		local character = LP.Character
		if not character then _resetCooldownActive = false; return end
		local hrp = character:FindFirstChild("HumanoidRootPart")
		if not hrp then _resetCooldownActive = false; return end
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid and humanoid.Health <= 0 then
			_resetViaRemote()
			return
		end
		-- guarda se estava com brainrot na mao (pro drop automatico)
		local hadBrainrot = _hasBrainrot()
		-- METODO CURSED: velocidade absurda no eixo Y = reset instantaneo.
		-- rawSetVel passa por dentro do spoof do motor de speed (Haze),
		-- senao a escrita seria engolida e o reset nao funcionaria.
		local ok = pcall(function()
			local cur = V.rawGetVel and V.rawGetVel(hrp) or hrp.AssemblyLinearVelocity
			local newVel = Vector3.new(cur.X, 10000000, cur.Z)
			if V.rawSetVel then V.rawSetVel(hrp, newVel) else hrp.AssemblyLinearVelocity = newVel end
		end)
		-- confere se morreu mesmo; se nao, usa o remote como fallback
		task.delay(0.35, function()
			local c2 = LP.Character
			local h2 = c2 and c2:FindFirstChildOfClass("Humanoid")
			if (not ok) or (h2 and h2.Health > 0 and c2 == character) then
				_resetViaRemote()
			end
		end)
		if hadBrainrot then V.lastResetHadBrainrot = true end
	end
	V.instaReset = cursedInstaReset
end
local KB = {
	DropBrainrot={kb=Enum.KeyCode.X,gp=nil},
	AutoLeft    ={kb=Enum.KeyCode.Z,gp=nil},
	AutoRight   ={kb=Enum.KeyCode.C,gp=nil},
	AutoBat     ={kb=Enum.KeyCode.E,gp=nil},
	BatTp       ={kb=Enum.KeyCode.B,gp=nil},
	TPFloor     ={kb=Enum.KeyCode.F,gp=nil},
	InstaReset  ={kb=Enum.KeyCode.T,gp=nil},
	GuiHide     ={kb=Enum.KeyCode.LeftControl,gp=nil},
	SpeedToggle ={kb=Enum.KeyCode.Q,gp=nil},
	LaggerToggle={kb=Enum.KeyCode.R,gp=nil},
	AntiTpBat   ={kb=Enum.KeyCode.Delete,gp=nil}
}
local AP_L1,AP_L2 = Vector3.new(-476.47,-6.28,92.73),Vector3.new(-483.12,-4.95,94.81)
local AP_R1,AP_R2 = Vector3.new(-476.16,-6.52,25.62),Vector3.new(-483.06,-5.03,25.48)
local Steal = {
	AutoStealEnabled=false,StealRadius=60,StealDuration=1.4,
	Data={}
}
local isStealing = false
local autoGrabStopEnabled = false
local autoGrabStopTime = 1.29
local autoGrabDelayRadius = 8
local _guiLocked = false
local setLockGuiVisual = nil
local _introEnabled = true
local setIntroVisual = nil
-- ===== PORTED FROM MISERY DUELS (state stored in V table to save local registers) =====
V.antiDieEnabled = false
V.noCollideEnabled = false
V.headlessEnabled = false
V.korbloxEnabled = false
V.noCamCollisionEnabled = false
V.ragdollCountdownEnabled = false
V.animationPack = "OFF"
V.setAntiDieVisual = nil
V.setNoCollideVisual = nil
V.setHeadlessVisual = nil
V.setKorbloxVisual = nil
V.setNoCamCollisionVisual = nil
V.setRagdollCountdownVisual = nil
V.animPackValLbl = nil
local Conns = {autoSteal=nil,antiRag=nil,batCounter=nil,anchor={},progress=nil}
local MEDUSA_COOLDOWN = 25
local batCounterDebounce = false
local progressRadLbl,progressFill,progressPct
local modeValLbl
local lastMoveDir = Vector3.new(0,0,0)
local MOVE_KEYS={[Enum.KeyCode.W]=true,[Enum.KeyCode.A]=true,[Enum.KeyCode.S]=true,[Enum.KeyCode.D]=true,
	[Enum.KeyCode.Up]=true,[Enum.KeyCode.Left]=true,[Enum.KeyCode.Down]=true,[Enum.KeyCode.Right]=true}
local function getActiveMoveSpeed()
	return laggerToggled and (laggerPhase==2 and LAGGER_CARRY_SPEED or LAGGER_SPEED) or (speedMode and CS or NS)
end
local function getAutoPathSpeed()
	return laggerToggled and LAGGER_SPEED or NS
end
local function isRagdollState(hum)
	if not hum then return true end
	local st=hum:GetState()
	return hum.PlatformStand or st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown
end

local function isMyPlotByName(plotName)
	local plots=workspace:FindFirstChild("Plots")
	if not plots then return false end
	local plot=plots:FindFirstChild(plotName)
	if not plot then return false end
	local sign=plot:FindFirstChild("PlotSign")
	if sign then
		local yb=sign:FindFirstChild("YourBase")
		if yb and yb:IsA("BillboardGui") then
			return yb.Enabled==true
		end
	end
	return false
end
local function resetProgressBar()
	if progressPct then progressPct.Text="0%" end
	if progressFill then progressFill.Size=UDim2.new(0,0,1,0) end
end
-- ════════════════════════════════════════════════════════════════
-- AUTO STEAL (ported from Sky Hub: two-phase "Stop Time" delayed steal)
-- ════════════════════════════════════════════════════════════════
local function findNearestStealPrompt()
	local character = LP.Character
	if not character then return nil, nil end
	local root = character:FindFirstChild("HumanoidRootPart")
	if not root then return nil, nil end
	local plots = workspace:FindFirstChild("Plots")
	if not plots then return nil, nil end
	local nearestPrompt = nil
	local nearestDistance = math.huge
	local nearestPodName = nil
	for _, plot in ipairs(plots:GetChildren()) do
		if isMyPlotByName(plot.Name) then continue end
		local pods = plot:FindFirstChild("AnimalPodiums")
		if not pods then continue end
		for _, pod in ipairs(pods:GetChildren()) do
			pcall(function()
				local base = pod:FindFirstChild("Base")
				local spawnPart = base and base:FindFirstChild("Spawn")
				if spawnPart then
					local distance = (spawnPart.Position - root.Position).Magnitude
					if distance < nearestDistance and distance <= Steal.StealRadius then
						local attachment = spawnPart:FindFirstChild("PromptAttachment")
						if attachment then
							for _, child in ipairs(attachment:GetChildren()) do
								if child:IsA("ProximityPrompt") and child.ActionText and child.ActionText:find("Steal") then
									nearestPrompt = child
									nearestDistance = distance
									nearestPodName = pod.Name
									break
								end
							end
						end
					end
				end
			end)
		end
	end
	return nearestPrompt, nearestPodName
end

Steal.updateProgress = function(elapsed, duration)
	if progressFill then
		local progress = math.clamp(elapsed / duration, 0, 1)
		progressFill.Size = UDim2.new(progress, 0, 1, 0)
	end
	if progressPct then
		progressPct.Text = string.format("%d%%", math.floor(math.clamp(elapsed / duration, 0, 1) * 100))
	end
end

Steal.checkCancelled = function(prompt)
	local char = LP.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not prompt.Parent or not prompt.Parent.Parent then return true end
	if hrp and (hrp.Position - prompt.Parent.Parent.Position).Magnitude > Steal.StealRadius then return true end
	return false
end

Steal.runPhase1 = function(data, prompt, duration, startTime)
	while isStealing and Steal.AutoStealEnabled do
		local elapsed = tick() - startTime
		if elapsed >= autoGrabStopTime then break end
		Steal.updateProgress(elapsed, duration)
		if Steal.checkCancelled(prompt) then break end
		task.wait()
	end
	return math.clamp(autoGrabStopTime / duration, 0, 1)
end

Steal.runPhase2 = function(data, prompt, stopProgress, duration, startTime)
	local phase2Timeout = math.max(2.99 - autoGrabStopTime - math.max(duration - autoGrabStopTime, 0), 0.05)
	local phase2Start = tick()
	while isStealing and Steal.AutoStealEnabled do
		if tick() - phase2Start >= phase2Timeout then
			return "restart"
		end
		if Steal.checkCancelled(prompt) then
			return "cancel"
		end
		local char = LP.Character
		local hrp = char and char:FindFirstChild("HumanoidRootPart")
		if hrp then
			local dist = (hrp.Position - prompt.Parent.Parent.Position).Magnitude
			if dist <= autoGrabDelayRadius then
				if progressPct then
					progressPct.Text = string.format("%d%%", math.floor(stopProgress * 100))
				end
				break
			elseif dist > Steal.StealRadius then
				return "cancel"
			end
		end
		task.wait()
	end
	return "continue"
end

Steal.finish = function(data, stopProgress, duration)
	local fillStart = tick()
	local fillDuration = math.max(duration - autoGrabStopTime, 0.05)
	while true do
		local fp = math.clamp((tick() - fillStart) / fillDuration, 0, 1)
		if progressFill then
			progressFill.Size = UDim2.new(stopProgress + fp * (1 - stopProgress), 0, 1, 0)
		end
		if progressPct then
			progressPct.Text = string.format("%d%%", math.floor((stopProgress + fp * (1 - stopProgress)) * 100))
		end
		if fp >= 1 then break end
		task.wait()
	end
	for _, func in ipairs(data.TriggerConnections) do
		task.spawn(func)
	end
end

Steal.runNormal = function(data, prompt, duration, startTime)
	while isStealing and Steal.AutoStealEnabled do
		local elapsed = tick() - startTime
		local progress = math.clamp(elapsed / duration, 0, 1)
		if progressFill then
			progressFill.Size = UDim2.new(progress, 0, 1, 0)
		end
		if progressPct then
			progressPct.Text = string.format("%d%%", math.floor(progress * 100))
		end
		if Steal.checkCancelled(prompt) then break end
		if elapsed >= duration then
			for _, func in ipairs(data.TriggerConnections) do
				task.spawn(func)
			end
			break
		end
		task.wait()
	end
end

Steal.resetAfter = function(data)
	if progressFill then
		TS:Create(progressFill, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
			Size = UDim2.new(0, 0, 1, 0)
		}):Play()
	end
	resetProgressBar()
	data.Ready = true
	isStealing = false
end

local function executeSteal(prompt, podName)
	if isStealing then return end
	if not Steal.Data[prompt] then
		Steal.Data[prompt] = {
			HoldConnections = {},
			TriggerConnections = {},
			Ready = true
		}
		pcall(function()
			if getconnections then
				for _, conn in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do
					if conn.Function then
						table.insert(Steal.Data[prompt].HoldConnections, conn.Function)
					end
				end
				for _, conn in ipairs(getconnections(prompt.Triggered)) do
					if conn.Function then
						table.insert(Steal.Data[prompt].TriggerConnections, conn.Function)
					end
				end
			end
		end)
	end
	local data = Steal.Data[prompt]
	if not data.Ready then return end
	data.Ready = false
	isStealing = true
	resetProgressBar()
	if progressFill then
		progressFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	end
	task.spawn(function()
		for _, func in ipairs(data.HoldConnections) do
			task.spawn(func)
		end
		local startTime = tick()
		local duration = Steal.StealDuration
		if autoGrabStopEnabled then
			local stopProgress = Steal.runPhase1(data, prompt, duration, startTime)
			if progressFill then
				progressFill.Size = UDim2.new(stopProgress, 0, 1, 0)
			end
			if progressPct then
				progressPct.Text = "Ready"
			end
			local phase2Result = Steal.runPhase2(data, prompt, stopProgress, duration, startTime)
			if phase2Result == "restart" then
				resetProgressBar()
				data.Ready = true
				isStealing = false
				task.wait()
				executeSteal(prompt, podName)
				return
			elseif phase2Result == "cancel" then
				Steal.resetAfter(data)
				return
			end
			if isStealing and Steal.AutoStealEnabled then
				Steal.finish(data, stopProgress, duration)
			end
		else
			Steal.runNormal(data, prompt, duration, startTime)
		end
		Steal.resetAfter(data)
	end)
end

local function startAutoSteal()
	if Conns.autoSteal then return end
	local _lastScan = 0
	Conns.autoSteal = RunService.Heartbeat:Connect(function()
		if not Steal.AutoStealEnabled or isStealing then return end
		local now = tick()
		if now - _lastScan < 0.2 then return end  -- throttle: only scan ~5x/sec instead of every frame
		_lastScan = now
		local prompt, podName = findNearestStealPrompt()
		if prompt then
			executeSteal(prompt, podName)
		end
	end)
end
local function stopAutoSteal()
	if Conns.autoSteal then
		Conns.autoSteal:Disconnect()
		Conns.autoSteal = nil
	end
	isStealing = false
	if progressFill then
		TS:Create(progressFill, TweenInfo.new(0.2), {
			Size = UDim2.new(0, 0, 1, 0)
		}):Play()
	end
		resetProgressBar()
end
-- ============================================================
-- SPEED ENGINE — "unpatched no drop speed" (by Haze)
-- Substitui 100% o sistema antigo (AssemblyLinearVelocity direto).
-- Usa LinearVelocity em modo Plane + spoof de leitura/escrita de
-- Velocity no HumanoidRootPart => sem drop de velocidade.
-- ============================================================
do -- ==== bloco isolado: nao consome os 200 registros de locais do topo ====
	local _linVel, _linVelAtt0, _linVelAtt1, _linVelChar = nil, nil, nil, nil
	local spoofedVelocity = Vector3.zero
	V.speedLVClear = function(hrp)
		local lv = hrp and hrp:FindFirstChild("OrvynLinVel")
		if lv then pcall(function() lv:Destroy() end) end
	end
	local function destroyLinVel()
		if _linVel then pcall(_linVel.Destroy, _linVel) end
		if _linVelAtt0 then pcall(_linVelAtt0.Destroy, _linVelAtt0) end
		if _linVelAtt1 then pcall(_linVelAtt1.Destroy, _linVelAtt1) end
		_linVel, _linVelAtt0, _linVelAtt1, _linVelChar = nil, nil, nil, nil
	end
	local function setupLinearVelocity(char)
		destroyLinVel()
		if not char then return end
		local hrp = char:FindFirstChild("HumanoidRootPart")
		if not hrp then
			local ok, res = pcall(function() return char:WaitForChild("HumanoidRootPart", 5) end)
			if ok then hrp = res end
		end
		if not hrp then return end
		local att0 = Instance.new("Attachment"); att0.Name = "OrvynLinVelAtt0"; att0.Parent = hrp
		local att1 = Instance.new("Attachment"); att1.Name = "OrvynLinVelAtt1"; att1.Parent = hrp
		local lv = Instance.new("LinearVelocity")
		lv.Name = "OrvynLinVel"
		lv.Attachment0 = att0
		lv.Attachment1 = att1
		lv.VelocityConstraintMode = Enum.VelocityConstraintMode.Plane
		lv.PrimaryTangentAxis = Vector3.new(1, 0, 0)
		lv.SecondaryTangentAxis = Vector3.new(0, 0, 1)
		lv.RelativeTo = Enum.ActuatorRelativeTo.World
		lv.MaxForce = 1e6
		lv.PlaneVelocity = Vector2.new(0, 0)
		lv.Parent = hrp
		_linVel, _linVelAtt0, _linVelAtt1, _linVelChar = lv, att0, att1, char
	end
	local function setLinVelXZ(x, z)
		if _linVel and _linVel.Parent then
			pcall(function() _linVel.PlaneVelocity = Vector2.new(x, z) end)
		end
	end
	V.setLinVelXZ = setLinVelXZ
	local function clearLinVel()
		if _linVel and _linVel.Parent then
			pcall(function() _linVel.PlaneVelocity = Vector2.new(0, 0) end)
		end
	end
	V.clearLinVel = clearLinVel
	local function ensureLinVel()
		local char = LP.Character
		if not char then return false end
		if _linVel and _linVel.Parent and _linVelChar == char then return true end
		setupLinearVelocity(char)
		return _linVel ~= nil and _linVel.Parent ~= nil
	end
	V.ensureLinVel = ensureLinVel
	-- SUSPENDE o motor de speed: nao basta zerar o PlaneVelocity, porque o
	-- LinearVelocity continua ATIVO com MaxForce 1e6 e FORCA a velocidade XZ
	-- em zero — era isso que travava o aimbot e o auto left/right no lugar.
	-- Aqui o constraint eh destruido de vez (modelo do Cursed Hub: escrita
	-- direta de AssemblyLinearVelocity, sem constraint nenhum brigando).
	V.suspendSpeedEngine = function()
		if _linVel then destroyLinVel() end
		local char = LP.Character
		local hrp = char and char:FindFirstChild("HumanoidRootPart")
		if hrp then V.speedLVClear(hrp) end
	end
	-- ===== SPOOF: leitura/escrita de AssemblyLinearVelocity do HRP =====
	-- fallback: se o executor nao suportar hook, rawGet/rawSet viram acesso normal
	V.rawGetVel = function(part) return part.AssemblyLinearVelocity end
	V.rawSetVel = function(part, v) part.AssemblyLinearVelocity = v end
	pcall(function()
		if not (getrawmetatable and setreadonly and newcclosure) then return end
		local mt = getrawmetatable(game)
		setreadonly(mt, false)
		local oldIndex = mt.__index
		mt.__index = newcclosure(function(self, key)
			if key == "AssemblyLinearVelocity" or key == "Velocity" then
				if typeof(self) == "Instance" and self:IsA("BasePart")
					and self.Name == "HumanoidRootPart"
					and LP.Character and self:IsDescendantOf(LP.Character) then
					return spoofedVelocity
				end
			end
			return oldIndex(self, key)
		end)
		local oldNewIndex = mt.__newindex
		-- acesso "cru" pros outros sistemas (auto left/right, drop, jump, tp) que
		-- ainda precisam mexer na velocidade de verdade
		V.rawGetVel = function(part) return oldIndex(part, "AssemblyLinearVelocity") end
		V.rawSetVel = function(part, v) return oldNewIndex(part, "AssemblyLinearVelocity", v) end
		mt.__newindex = newcclosure(function(self, key, value)
			if key == "AssemblyLinearVelocity" or key == "Velocity" then
				if typeof(self) == "Instance" and self:IsA("BasePart")
					and self.Name == "HumanoidRootPart"
					and LP.Character and self:IsDescendantOf(LP.Character) then
					return
				end
			end
			return oldNewIndex(self, key, value)
		end)
		setreadonly(mt, true)
	end)
	RunService.Heartbeat:Connect(function()
		spoofedVelocity = Vector3.zero
	end)
	-- ===== LOOP PRINCIPAL DE MOVIMENTO =====
	local _curDisplaySpeed = 0
	RunService.RenderStepped:Connect(function()
		local char = LP.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		local hrp = char and char:FindFirstChild("HumanoidRootPart")
		if not char or not hum or not hrp or hum.Health <= 0 then
			_curDisplaySpeed = 0
		elseif isRagdollState(hum) then
			lastMoveDir = Vector3.zero
			clearLinVel()
			_curDisplaySpeed = 0
		elseif autoBatEnabled or autoLeftEnabled or autoRightEnabled or V.batTpEnabled then
			-- esses sistemas controlam o movimento por conta propria:
			-- o constraint precisa SAIR do HRP, senao segura o personagem
			V.suspendSpeedEngine()
			_curDisplaySpeed = 0
		else
			ensureLinVel()
			local md = hum.MoveDirection
			local spd = getActiveMoveSpeed()
			if md.Magnitude > 0.05 then
				lastMoveDir = md
				local u = md.Unit
				setLinVelXZ(u.X * spd, u.Z * spd)
				_curDisplaySpeed = spd
			elseif antiRagdollEnabled and lastMoveDir and lastMoveDir.Magnitude > 0 then
				local held = false
				for k in pairs(MOVE_KEYS) do
					if UIS:IsKeyDown(k) then held = true; break end
				end
				if held then
					local u = lastMoveDir.Unit
					setLinVelXZ(u.X * spd, u.Z * spd)
					_curDisplaySpeed = spd
				else
					clearLinVel(); _curDisplaySpeed = 0
				end
			else
				clearLinVel(); _curDisplaySpeed = 0
			end
		end
		-- indicador de velocidade acima da cabeca (usa a velocidade real aplicada,
		-- ja que a leitura do HRP esta spoofada em zero)
		if speedLabel then
			local shown = _curDisplaySpeed
			if _linVel and _linVel.Parent then
				local pv = _linVel.PlaneVelocity
				shown = math.sqrt(pv.X * pv.X + pv.Y * pv.Y)
			end
			speedLabel.Text = string.format("%.1f", shown)
		end
	end)
	-- re-cria o LinearVelocity quando o char renasce
	LP.CharacterAdded:Connect(function(char)
		task.wait(0.5)
		pcall(setupLinearVelocity, char)
	end)
	task.defer(function()
		if LP.Character then
			task.wait(0.3)
			pcall(setupLinearVelocity, LP.Character)
		end
	end)
end
local alConn,arConn=nil,nil
local alPhase,arPhase=1,1
local function stopAutoLeft()
	if alConn then alConn:Disconnect();alConn=nil end;alPhase=1
	autoLeftEnabled=false
	local char=LP.Character;if char then local h=char:FindFirstChildOfClass("Humanoid");if h then h:Move(Vector3.zero,false) end end
	-- devolve o controle pro motor de speed (foi suspenso durante o trajeto)
	if V.ensureLinVel then pcall(V.ensureLinVel) end
	if autoLeftSetVisual then autoLeftSetVisual(false) end
end
local function stopAutoRight()
	if arConn then arConn:Disconnect();arConn=nil end;arPhase=1
	autoRightEnabled=false
	local char=LP.Character;if char then local h=char:FindFirstChildOfClass("Humanoid");if h then h:Move(Vector3.zero,false) end end
	-- devolve o controle pro motor de speed (foi suspenso durante o trajeto)
	if V.ensureLinVel then pcall(V.ensureLinVel) end
	if autoRightSetVisual then autoRightSetVisual(false) end
end
local function startAutoLeft()
	if alConn then alConn:Disconnect() end;alPhase=1
	alConn=RunService.Heartbeat:Connect(function()
		if not autoLeftEnabled then return end
		if V.suspendSpeedEngine then V.suspendSpeedEngine() end
		local char=LP.Character;if not char then return end
		local hrp=char:FindFirstChild("HumanoidRootPart")
		local hum=char:FindFirstChildOfClass("Humanoid")
		if not hrp or not hum then return end
		-- morreu: cancela o trajeto e devolve o motor de speed
		if hum.Health <= 0 then
			autoLeftEnabled=false
			if alConn then alConn:Disconnect();alConn=nil end
			alPhase=1
			if V.ensureLinVel then pcall(V.ensureLinVel) end
			if autoLeftSetVisual then autoLeftSetVisual(false) end
			return
		end
		if isRagdollState(hum) then hum:Move(Vector3.zero,false);return end
		local spd=getAutoPathSpeed()
		if alPhase==1 then
			local tgt=Vector3.new(AP_L1.X,hrp.Position.Y,AP_L1.Z)
			if (tgt-hrp.Position).Magnitude<1 then
				alPhase=2
				local d=AP_L2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit
				hum:Move(mv,false);V.rawSetVel(hrp, Vector3.new(mv.X*spd,V.rawGetVel(hrp).Y,mv.Z*spd))
				return
			end
			local d=AP_L1-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit
			hum:Move(mv,false);V.rawSetVel(hrp, Vector3.new(mv.X*spd,V.rawGetVel(hrp).Y,mv.Z*spd))
		elseif alPhase==2 then
			local tgt=Vector3.new(AP_L2.X,hrp.Position.Y,AP_L2.Z)
			if (tgt-hrp.Position).Magnitude<1 then
				hum:Move(Vector3.zero,false);V.rawSetVel(hrp, Vector3.zero)
				autoLeftEnabled=false;if alConn then alConn:Disconnect();alConn=nil end
				alPhase=1
				if V.ensureLinVel then pcall(V.ensureLinVel) end
				if autoLeftSetVisual then autoLeftSetVisual(false) end;return
			end
			local d=AP_L2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit
			hum:Move(mv,false);V.rawSetVel(hrp, Vector3.new(mv.X*spd,V.rawGetVel(hrp).Y,mv.Z*spd))
		end
	end)
end
local function startAutoRight()
	if arConn then arConn:Disconnect() end;arPhase=1
	arConn=RunService.Heartbeat:Connect(function()
		if not autoRightEnabled then return end
		if V.suspendSpeedEngine then V.suspendSpeedEngine() end
		local char=LP.Character;if not char then return end
		local hrp=char:FindFirstChild("HumanoidRootPart")
		local hum=char:FindFirstChildOfClass("Humanoid")
		if not hrp or not hum then return end
		-- morreu: cancela o trajeto e devolve o motor de speed
		if hum.Health <= 0 then
			autoRightEnabled=false
			if arConn then arConn:Disconnect();arConn=nil end
			arPhase=1
			if V.ensureLinVel then pcall(V.ensureLinVel) end
			if autoRightSetVisual then autoRightSetVisual(false) end
			return
		end
		if isRagdollState(hum) then hum:Move(Vector3.zero,false);return end
		local spd=getAutoPathSpeed()
		if arPhase==1 then
			local tgt=Vector3.new(AP_R1.X,hrp.Position.Y,AP_R1.Z)
			if (tgt-hrp.Position).Magnitude<1 then
				arPhase=2
				local d=AP_R2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit
				hum:Move(mv,false);V.rawSetVel(hrp, Vector3.new(mv.X*spd,V.rawGetVel(hrp).Y,mv.Z*spd))
				return
			end
			local d=AP_R1-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit
			hum:Move(mv,false);V.rawSetVel(hrp, Vector3.new(mv.X*spd,V.rawGetVel(hrp).Y,mv.Z*spd))
		elseif arPhase==2 then
			local tgt=Vector3.new(AP_R2.X,hrp.Position.Y,AP_R2.Z)
			if (tgt-hrp.Position).Magnitude<1 then
				hum:Move(Vector3.zero,false);V.rawSetVel(hrp, Vector3.zero)
				autoRightEnabled=false;if arConn then arConn:Disconnect();arConn=nil end
				arPhase=1
				if V.ensureLinVel then pcall(V.ensureLinVel) end
				if autoRightSetVisual then autoRightSetVisual(false) end;return
			end
			local d=AP_R2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit
			hum:Move(mv,false);V.rawSetVel(hrp, Vector3.new(mv.X*spd,V.rawGetVel(hrp).Y,mv.Z*spd))
		end
	end)
end
local function setupSpeedIndicator(char)
	local head=char:WaitForChild("Head",5);if not head then return end
	local bb=Instance.new("BillboardGui",head)
	bb.Size=UDim2.new(0,190,0,56);bb.StudsOffset=Vector3.new(0,2.5,0);bb.AlwaysOnTop=true
	-- Discord text on TOP
	local discordLbl=Instance.new("TextLabel",bb)
	discordLbl.Size=UDim2.new(1,0,0,22)
	discordLbl.Position=UDim2.new(0,0,0,0)
	discordLbl.BackgroundTransparency=1
	discordLbl.Text="discord.gg/NrJaxfK54d"
	discordLbl.TextColor3=Color3.fromRGB(255,255,255)
	discordLbl.Font=Enum.Font.GothamBlack;discordLbl.TextScaled=true
	discordLbl.TextStrokeTransparency=0;discordLbl.TextStrokeColor3=Color3.fromRGB(0,0,0)
	-- Linha divisoria branca entre o discord e a velocidade
	local divider=Instance.new("Frame",bb)
	divider.Name="Divider"
	divider.AnchorPoint=Vector2.new(0.5,0)
	divider.Position=UDim2.new(0.5,0,0,23)
	divider.Size=UDim2.new(1,12,0,3)
	divider.BackgroundColor3=Color3.fromRGB(255,255,255)
	divider.BorderSizePixel=0
	-- Speed below
	speedLabel=Instance.new("TextLabel",bb)
	speedLabel.Size=UDim2.new(1,0,0,28)
	speedLabel.Position=UDim2.new(0,0,0,28)
	speedLabel.BackgroundTransparency=1
	speedLabel.Text="0.0";speedLabel.TextColor3=THEME_ACCENT
	speedLabel.Font=Enum.Font.GothamBlack;speedLabel.TextScaled=true
	speedLabel.TextStrokeTransparency=0;speedLabel.TextStrokeColor3=Color3.fromRGB(0,0,0)
	trackTheme(function(c) if speedLabel and speedLabel.Parent then speedLabel.TextColor3 = c end end)
	-- ===== EFEITO GRADIENTE (shimmer) nos textos e na linha =====
	-- Discord + linha: gradiente na cor do tema (escura -> clara -> escura).
	local dGrad=Instance.new("UIGradient",discordLbl)
	local lGrad=Instance.new("UIGradient",divider)
	local function refreshDiscordGrad()
		local seq=ColorSequence.new({
			ColorSequenceKeypoint.new(0.00,THEME_ACCENT_DIM),
			ColorSequenceKeypoint.new(0.45,THEME_ACCENT_BRIGHT),
			ColorSequenceKeypoint.new(0.55,THEME_ACCENT_BRIGHT),
			ColorSequenceKeypoint.new(1.00,THEME_ACCENT_DIM),
		})
		dGrad.Color=seq
		lGrad.Color=seq
	end
	refreshDiscordGrad()
	trackTheme(function(_) if discordLbl and discordLbl.Parent then refreshDiscordGrad() end end)
	-- Speed: gradiente na cor do tema (claro -> escuro -> claro).
	local sGrad=Instance.new("UIGradient",speedLabel)
	local function refreshSpeedGrad()
		sGrad.Color=ColorSequence.new({
			ColorSequenceKeypoint.new(0.00,THEME_ACCENT_BRIGHT),
			ColorSequenceKeypoint.new(0.50,THEME_ACCENT),
			ColorSequenceKeypoint.new(1.00,THEME_ACCENT_BRIGHT),
		})
	end
	refreshSpeedGrad()
	trackTheme(function(_) if speedLabel and speedLabel.Parent then refreshSpeedGrad() end end)
	-- anima o offset dos tres gradientes (efeito de brilho passando)
	task.spawn(function()
		while bb and bb.Parent do
			for i=-1,1,0.02 do
				if not (bb and bb.Parent) then break end
				local o=Vector2.new(i,0)
				dGrad.Offset=o; lGrad.Offset=o; sGrad.Offset=o
				task.wait(0.03)
			end
		end
	end)
end
-- Anti Ragdoll (versao robusta "undetected/unpatched" portada do hub):
-- cache do char, remove constraints de ragdoll, forca saida do estado e
-- zera velocidade. Helpers ficam dentro de `do...end` pra nao consumir
-- locais do topo (limite de 200 registros do Luau).
-- ============================================================
-- ANTI RAGDOLL — portado do VYNX DUEL, com DOIS modos:
--   "Splatter"     : remove constraints, seta RagdollEndTime,
--                    re-liga Motor6Ds e força Running (completo)
--   "No Splatter"  : GettingUp + zera velocidade + re-liga tudo,
--                    sem remover o ragdoll visual (mais leve/rápido)
-- Modo escolhido por V.antiRagdollMode ("Splatter" / "No Splatter")
-- ============================================================
V.antiRagdollMode = V.antiRagdollMode or "Splatter"
V.antiRagNoSplatterCd = 0
local startAntiRagdoll, stopAntiRagdoll
do
	-- NO SPLATTER: reset suave (Vynx forceNoSplatterReset)
	local function forceNoSplatterReset()
		local char = LP.Character
		if not char then return end
		local hum = char:FindFirstChildOfClass("Humanoid")
		local root = char:FindFirstChild("HumanoidRootPart")
		if not hum or not root or hum.Health <= 0 then return end
		pcall(function()
			hum:ChangeState(Enum.HumanoidStateType.GettingUp)
			root.Velocity = Vector3.zero
			root.RotVelocity = Vector3.zero
			V.rawSetVel(root, Vector3.zero)
			root.AssemblyAngularVelocity = Vector3.zero
			for _, obj in ipairs(char:GetDescendants()) do
				if obj:IsA("Motor6D") then obj.Enabled = true end
				if obj:IsA("Constraint") then obj.Enabled = true end
			end
			workspace.CurrentCamera.CameraSubject = hum
			local PM = LP.PlayerScripts and LP.PlayerScripts:FindFirstChild("PlayerModule")
			if PM then
				local CM = PM:FindFirstChild("ControlModule")
				if CM then require(CM):Enable() end
			end
			hum.AutoRotate = true
			hum.PlatformStand = false
			hum.Sit = false
		end)
	end
	function startAntiRagdoll()
		if Conns.antiRag then return end
		Conns.antiRag = RunService.Heartbeat:Connect(function()
			if not antiRagdollEnabled then return end
			local char = LP.Character
			if not char then return end
			local hum = char:FindFirstChildOfClass("Humanoid")
			local root = char:FindFirstChild("HumanoidRootPart")
			if not hum or hum.Health <= 0 then return end
			local state = hum:GetState()
			local ragdolled = (state == Enum.HumanoidStateType.Physics
				or state == Enum.HumanoidStateType.Ragdoll
				or state == Enum.HumanoidStateType.FallingDown)
			if V.antiRagdollMode == "No Splatter" then
				if ragdolled then
					local now = tick()
					if now - V.antiRagNoSplatterCd > 0.15 then
						V.antiRagNoSplatterCd = now
						forceNoSplatterReset()
					end
				end
				return
			end
			-- ===== SPLATTER (completo, Vynx) =====
			if not root then return end
			local endTime = LP:GetAttribute("RagdollEndTime")
			if endTime then
				local ok, now = pcall(function() return workspace:GetServerTimeNow() end)
				if ok and (endTime - now) > 0 then ragdolled = true end
			end
			if ragdolled then
				pcall(function() LP:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow()) end)
				for _, d in ipairs(char:GetDescendants()) do
					if d:IsA("BallSocketConstraint") or
					   (d:IsA("Attachment") and d.Name:find("RagdollAttachment")) then
						pcall(function() d:Destroy() end)
					end
				end
				for _, obj in ipairs(char:GetDescendants()) do
					if obj:IsA("Motor6D") and obj.Enabled == false then
						pcall(function() obj.Enabled = true end)
					end
				end
				if hum.Health > 0 then
					pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
				end
				pcall(function() workspace.CurrentCamera.CameraSubject = hum end)
				root.Anchored = false
				V.rawSetVel(root, Vector3.zero)
				root.AssemblyAngularVelocity = Vector3.zero
			end
		end)
	end
	function stopAntiRagdoll()
		if Conns.antiRag then Conns.antiRag:Disconnect(); Conns.antiRag = nil end
	end
end
-- =========================================================
-- ESP — sistema COMPLETO portado do FLOW HUB (Blody / Water Hub)
--   * Box 2D com moldura fina + 8 cantos destacados
--   * Barra de vida vertical a esquerda do box (verde->azul)
--   * Foto de perfil (AvatarHeadShot) redonda acima do box
--   * Nome (@usuario) + info "distancia + %vida" embaixo
--   * Highlight (chams) no personagem
--   * Tracer da base da tela ate o alvo
--   * Speed ESP: velocidade horizontal acima da cabeca
-- Dois modos: V.espMode = "noLine" (sem tracer) / "withLine" (com tracer)
-- Tudo em Frames/ScreenGui — nao depende da Drawing API.
-- =========================================================
V.espMode = V.espMode or "noLine"
do
	local ESP_LOW    = Color3.fromRGB(18, 18, 22)
	local ESP_TEXT   = Color3.fromRGB(255, 255, 255)
	local ESP_SHADOW = Color3.fromRGB(6, 6, 10)
	local function accent() return THEME_ACCENT end

	local function espLayer()
		if PlayerESP.gui and PlayerESP.gui.Parent then return PlayerESP.gui end
		local parent
		pcall(function() parent = (gethui and gethui()) or game:GetService("CoreGui") end)
		if not parent then parent = LP:WaitForChild("PlayerGui") end
		pcall(function()
			local old = parent:FindFirstChild("VexusFlowESP")
			if old then old:Destroy() end
		end)
		local g = Instance.new("ScreenGui")
		g.Name = "VexusFlowESP"
		g.ResetOnSpawn = false
		g.IgnoreGuiInset = true
		g.DisplayOrder = 10000
		pcall(function() g.ZIndexBehavior = Enum.ZIndexBehavior.Sibling end)
		g.Parent = parent
		PlayerESP.gui = g
		return g
	end

	local function espLine(parent, thick, z)
		local f = Instance.new("Frame")
		f.BorderSizePixel = 0
		f.BackgroundColor3 = accent()
		f.Size = UDim2.new(0, thick, 0, thick)
		f.ZIndex = z or 2
		f.Parent = parent
		return f
	end

	-- monta todos os elementos de um jogador
	local function espBuild(plr)
		local layer = espLayer()
		local holder = Instance.new("Frame")
		holder.Name = "ESP_" .. tostring(plr.UserId)
		holder.BackgroundTransparency = 1
		holder.BorderSizePixel = 0
		holder.Size = UDim2.new(0, 0, 0, 0)
		holder.Visible = false
		holder.ZIndex = 2
		holder.Parent = layer

		local box = Instance.new("Frame", holder)
		box.Name = "Box"
		box.BackgroundTransparency = 1
		box.BorderSizePixel = 0
		box.Size = UDim2.new(1, 0, 1, 0)
		box.ZIndex = 2
		local edge = Instance.new("UIStroke", box)
		edge.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		edge.Color = accent()
		edge.Thickness = 1
		edge.Transparency = 0.45

		local corners = {}
		for i = 1, 8 do corners[i] = espLine(holder, 2, 3) end

		local track = Instance.new("Frame", holder)
		track.Name = "HealthTrack"
		track.AnchorPoint = Vector2.new(1, 0)
		track.Position = UDim2.new(0, -4, 0, 0)
		track.Size = UDim2.new(0, 3, 1, 0)
		track.BackgroundColor3 = ESP_SHADOW
		track.BackgroundTransparency = 0.35
		track.BorderSizePixel = 0
		track.ZIndex = 2
		local fill = Instance.new("Frame", track)
		fill.Name = "HealthFill"
		fill.AnchorPoint = Vector2.new(0, 1)
		fill.Position = UDim2.new(0, 0, 1, 0)
		fill.Size = UDim2.new(1, 0, 1, 0)
		fill.BackgroundColor3 = accent()
		fill.BorderSizePixel = 0
		fill.ZIndex = 3

		local avatar = Instance.new("ImageLabel", holder)
		avatar.Name = "Avatar"
		avatar.AnchorPoint = Vector2.new(0.5, 1)
		avatar.Position = UDim2.new(0.5, 0, 0, -21)
		avatar.Size = UDim2.new(0, 46, 0, 46)
		avatar.BackgroundColor3 = ESP_SHADOW
		avatar.BackgroundTransparency = 0.25
		avatar.BorderSizePixel = 0
		avatar.ScaleType = Enum.ScaleType.Fit
		avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(plr.UserId) .. "&w=48&h=48"
		avatar.ZIndex = 4
		Instance.new("UICorner", avatar).CornerRadius = UDim.new(1, 0)
		local avStroke = Instance.new("UIStroke", avatar)
		avStroke.Color = accent()
		avStroke.Thickness = 1.5
		avStroke.Transparency = 0.2

		local tag = Instance.new("TextLabel", holder)
		tag.Name = "SpeedTag"
		tag.AnchorPoint = Vector2.new(0.5, 1)
		tag.Position = UDim2.new(0.5, 0, 0, -5)
		tag.Size = UDim2.new(0, 200, 0, 14)
		tag.BackgroundTransparency = 1
		tag.Text = "0.0 spd"
		tag.TextColor3 = accent()
		tag.TextStrokeColor3 = ESP_SHADOW
		tag.TextStrokeTransparency = 0.25
		tag.TextSize = 13
		tag.Font = Enum.Font.GothamBlack
		tag.ZIndex = 4

		local info = Instance.new("TextLabel", holder)
		info.Name = "Info"
		info.AnchorPoint = Vector2.new(0.5, 0)
		info.Position = UDim2.new(0.5, 0, 1, 4)
		info.Size = UDim2.new(0, 200, 0, 12)
		info.BackgroundTransparency = 1
		info.Text = ""
		info.TextColor3 = accent()
		info.TextStrokeColor3 = ESP_SHADOW
		info.TextStrokeTransparency = 0.35
		info.TextSize = 11
		info.Font = Enum.Font.GothamSemibold
		info.ZIndex = 4

		local tracer = Instance.new("Frame", layer)
		tracer.Name = "Tracer_" .. tostring(plr.UserId)
		tracer.AnchorPoint = Vector2.new(0.5, 0.5)
		tracer.BackgroundColor3 = accent()
		tracer.BackgroundTransparency = 0.25
		tracer.BorderSizePixel = 0
		tracer.Size = UDim2.new(0, 0, 0, 1)
		tracer.Visible = false
		tracer.ZIndex = 1

		local glow = Instance.new("Highlight")
		glow.Name = "VexusESPGlow"
		glow.FillColor = accent()
		glow.FillTransparency = 0.72
		glow.OutlineColor = accent()
		glow.OutlineTransparency = 0.15
		glow.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		glow.Enabled = false
		glow.Parent = layer

		local entry = {
			holder = holder, box = box, edge = edge, corners = corners,
			track = track, fill = fill, tag = tag, avatar = avatar,
			avStroke = avStroke, info = info, tracer = tracer, glow = glow,
		}
		PlayerESP.playerData[plr] = entry
		return entry
	end

	local function espClear(plr)
		local e = PlayerESP.playerData[plr]
		if not e then return end
		pcall(function() if e.holder then e.holder:Destroy() end end)
		pcall(function() if e.tracer then e.tracer:Destroy() end end)
		pcall(function() if e.glow then e.glow:Destroy() end end)
		PlayerESP.playerData[plr] = nil
	end

	local function espPaint(e, c)
		if e.edge then e.edge.Color = c end
		if e.corners then for _, x in ipairs(e.corners) do x.BackgroundColor3 = c end end
		if e.tracer then e.tracer.BackgroundColor3 = c end
		if e.avStroke then e.avStroke.Color = c end
		if e.info then e.info.TextColor3 = c end
		if e.tag then e.tag.TextColor3 = c end
		if e.glow then e.glow.FillColor = c; e.glow.OutlineColor = c end
	end

	local function espPlaceCorners(e, w, h)
		local t = 2
		local len = math.max(8, math.floor(math.min(w, h) * 0.22))
		local c = e.corners
		if not c or #c < 8 then return end
		c[1].Size = UDim2.new(0, len, 0, t); c[1].Position = UDim2.new(0, 0, 0, 0)
		c[2].Size = UDim2.new(0, t, 0, len); c[2].Position = UDim2.new(0, 0, 0, 0)
		c[3].Size = UDim2.new(0, len, 0, t); c[3].Position = UDim2.new(0, w - len, 0, 0)
		c[4].Size = UDim2.new(0, t, 0, len); c[4].Position = UDim2.new(0, w - t, 0, 0)
		c[5].Size = UDim2.new(0, len, 0, t); c[5].Position = UDim2.new(0, 0, 0, h - t)
		c[6].Size = UDim2.new(0, t, 0, len); c[6].Position = UDim2.new(0, 0, 0, h - len)
		c[7].Size = UDim2.new(0, len, 0, t); c[7].Position = UDim2.new(0, w - len, 0, h - t)
		c[8].Size = UDim2.new(0, t, 0, len); c[8].Position = UDim2.new(0, w - t, 0, h - len)
	end

	local function espHide(e)
		if not e then return end
		if e.holder then e.holder.Visible = false end
		if e.tracer then e.tracer.Visible = false end
		if e.glow then e.glow.Enabled = false end
	end

	local function espSpeedOf(root)
		local v
		pcall(function() v = root.AssemblyLinearVelocity end)
		if not v then pcall(function() v = root.Velocity end) end
		if not v then return 0 end
		return Vector3.new(v.X, 0, v.Z).Magnitude
	end

	local function espUpdate()
		if not PlayerESP.enabled then return end
		local cam = workspace.CurrentCamera
		if not cam then return end
		local myChar = LP.Character
		local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
		local viewport = cam.ViewportSize
		local c = accent()
		local showTracer = (V.espMode == "withLine")

		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= LP then
				local char = plr.Character
				local e = PlayerESP.playerData[plr]
				if char then
					local root = char:FindFirstChild("HumanoidRootPart")
					local hum = char:FindFirstChildOfClass("Humanoid")
					local head = char:FindFirstChild("Head")
					if root and hum and head and hum.Health > 0 then
						if not e then e = espBuild(plr) end
						espPaint(e, c)
						local top, on1 = cam:WorldToViewportPoint(head.Position + Vector3.new(0, 1.0, 0))
						local bottom, on2 = cam:WorldToViewportPoint(root.Position - Vector3.new(0, 3.0, 0))
						if on1 and on2 and top.Z > 0 and bottom.Z > 0 then
							local h = math.abs(bottom.Y - top.Y)
							local w = h * 0.58
							e.holder.Size = UDim2.new(0, w, 0, h)
							e.holder.Position = UDim2.new(0, top.X - w / 2, 0, top.Y)
							e.holder.Visible = true
							espPlaceCorners(e, w, h)
							local pct = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
							e.fill.Size = UDim2.new(1, 0, pct, 0)
							e.fill.BackgroundColor3 = ESP_LOW:Lerp(c, pct)
							local dist = myRoot and math.floor((root.Position - myRoot.Position).Magnitude + 0.5) or 0
							e.info.Text = string.format("%dm  %d%%", dist, math.floor(pct * 100 + 0.5))
							if e.glow then
								e.glow.Adornee = char
								e.glow.Enabled = true
							end
							e.tag.Text = string.format("%.1f spd", espSpeedOf(root))
							if showTracer then
								local ox, oy = viewport.X / 2, viewport.Y
								local dx, dy = top.X - ox, (top.Y + h) - oy
								local len = math.sqrt(dx * dx + dy * dy)
								e.tracer.Size = UDim2.new(0, len, 0, 1)
								e.tracer.Position = UDim2.new(0, ox + dx / 2, 0, oy + dy / 2)
								e.tracer.Rotation = math.deg(math.atan2(dy, dx))
								e.tracer.Visible = true
							else
								e.tracer.Visible = false
							end
						else
							espHide(e)
						end
					elseif e then
						espHide(e)
					end
				elseif e then
					espHide(e)
				end
			end
		end
	end

	V.espRebuild = function()
		for plr, _ in pairs(PlayerESP.playerData) do espClear(plr) end
		PlayerESP.playerData = {}
		-- recria a layer limpa (evita sobras de tracer/glow orfaos)
		if PlayerESP.gui then pcall(function() PlayerESP.gui:Destroy() end); PlayerESP.gui = nil end
		if PlayerESP.enabled then espLayer() end
	end

	startPlayerESP = function()
		if PlayerESP.enabled then return end
		PlayerESP.enabled = true
		espLayer()
		if PlayerESP.conn then pcall(function() PlayerESP.conn:Disconnect() end) end
		PlayerESP.conn = RunService.RenderStepped:Connect(espUpdate)
		-- limpa conexoes antigas antes de criar novas (senao empilha a cada toggle)
		for _, cn in ipairs(PlayerESP.conns) do pcall(function() cn:Disconnect() end) end
		PlayerESP.conns = {}
		table.insert(PlayerESP.conns, Players.PlayerRemoving:Connect(espClear))
	end

	stopPlayerESP = function()
		if not PlayerESP.enabled then return end
		PlayerESP.enabled = false
		if PlayerESP.conn then pcall(function() PlayerESP.conn:Disconnect() end); PlayerESP.conn = nil end
		for _, cn in ipairs(PlayerESP.conns) do pcall(function() cn:Disconnect() end) end
		PlayerESP.conns = {}
		for plr, _ in pairs(PlayerESP.playerData) do espClear(plr) end
		PlayerESP.playerData = {}
		if PlayerESP.gui then pcall(function() PlayerESP.gui:Destroy() end); PlayerESP.gui = nil end
	end

	trackTheme(function(col)
		for _, e in pairs(PlayerESP.playerData) do espPaint(e, col) end
	end)
end
-- ============================================================
-- INFINITE JUMP — portado do MISERY DUELS (sistema do Night Hub):
-- impulso via LinearVelocity temporario (destruido em 0.08s) em vez de
-- setar AssemblyLinearVelocity direto. Modo "hold": segurando o pulo
-- (espaco / gamepad ButtonA / toque) empurra Y=52 sempre que a velocidade
-- vertical cai abaixo de 30, e amortece a queda em -120.
V.jumpHeld = false
V.infJumpConn = nil
V._lastInfJump = 0
V._gamepadBtnHeld = false
V._activeTouches = {}
V._lastTouchStart = nil
V._holdTouch = nil
-- Segurando um brainrot? Se sim o inf jump NAO pode forcar hum.Jump,
-- senao o jogo derruba o brainrot da mao sozinho.
V.infJumpHoldingBR = function(char)
	if V.brainrotDetected then return true end
	local ok, res = pcall(function() return LP:GetAttribute("Stealing") end)
	if ok and res == true then return true end
	for _, t in ipairs(char:GetChildren()) do
		if t:IsA("Tool") then
			local n = string.lower(t.Name)
			if string.find(n, "brainrot") or string.find(n, "skibidi")
				or string.find(n, "toilet") or string.find(n, "animal") then
				return true
			end
		end
	end
	return false
end
V.infJumpImpulse = function(root, yVel)
	local att = root:FindFirstChild("InfJumpAttachment") or Instance.new("Attachment")
	att.Name = "InfJumpAttachment"
	att.Parent = root
	local cx = V.rawGetVel(root).X
	local cz = V.rawGetVel(root).Z
	local lv = Instance.new("LinearVelocity")
	lv.Name = "InfJumpVelocity"
	lv.MaxForce = 999999
	-- se o motor de speed (OrvynLinVel, modo Plane) esta ativo, ele ja manda
	-- no XZ; mexer no XZ aqui faria os dois brigarem
	if root:FindFirstChild("OrvynLinVel") or autoLeftEnabled or autoRightEnabled then
		lv.VectorVelocity = Vector3.new(0, yVel or 50, 0)
		lv.VelocityConstraintMode = Enum.VelocityConstraintMode.Line
		lv.LineDirection = Vector3.new(0, 1, 0)
		lv.LineVelocity = yVel or 50
	else
		lv.VectorVelocity = Vector3.new(cx, yVel or 50, cz)
	end
	lv.RelativeTo = Enum.ActuatorRelativeTo.World
	lv.Attachment0 = att
	lv.Parent = root
	task.delay(0.08, function()
		if lv then pcall(function() lv:Destroy() end) end
		if att then pcall(function() att:Destroy() end) end
	end)
end
V.doInfJump = function()
	local now = os.clock()
	if now - V._lastInfJump < 0.1 then return end
	V._lastInfJump = now
	local c = LP.Character; if not c then return end
	local hum = c:FindFirstChildOfClass("Humanoid"); if not hum or hum.Health <= 0 then return end
	local root = c:FindFirstChild("HumanoidRootPart"); if not root then return end
	if not V.infJumpHoldingBR(c) then hum.Jump = true end
	V.infJumpImpulse(root)
end
V.isGamepadInp = function(input)
	local u = input.UserInputType
	return u == Enum.UserInputType.Gamepad1 or u == Enum.UserInputType.Gamepad2
		or u == Enum.UserInputType.Gamepad3 or u == Enum.UserInputType.Gamepad4
end
-- O inf jump so considera "pulo segurado" o botao de pulo de verdade
-- (JumpButton no mobile, Espaco no teclado, ButtonA no controle).
-- Antes qualquer toque na tela virava pulo: andando com o dedo na tela
-- o personagem entrava em inf jump sozinho.
UIS.JumpRequest:Connect(function() end)
UIS.InputBegan:Connect(function(inp, gpe)
	if inp.KeyCode == Enum.KeyCode.ButtonA and V.isGamepadInp(inp) then
		V._gamepadBtnHeld = true
		return
	end
	if gpe then return end
	if inp.UserInputType == Enum.UserInputType.Keyboard and inp.KeyCode == Enum.KeyCode.Space then
		V.jumpHeld = true
	end
end)
UIS.InputEnded:Connect(function(inp)
	if inp.KeyCode == Enum.KeyCode.ButtonA and V.isGamepadInp(inp) then
		V._gamepadBtnHeld = false
		return
	end
	if inp.UserInputType == Enum.UserInputType.Keyboard and inp.KeyCode == Enum.KeyCode.Space then
		V.jumpHeld = false
	end
end)
-- (o rastreio generico de toques foi removido: era a origem do inf jump
--  disparando sozinho enquanto o jogador andava)
UIS.TouchEnded:Connect(function(touch)
	V._activeTouches[touch] = nil
	if V._lastTouchStart == touch then V._lastTouchStart = nil end
	if V._holdTouch == touch then V._holdTouch = nil end
end)
V.infJumpLoop = function()
	if V.infJumpConn then V.infJumpConn:Disconnect(); V.infJumpConn = nil end
	V.infJumpConn = RunService.Heartbeat:Connect(function()
		if not infJumpEnabled then return end
		local c = LP.Character; if not c then return end
		local root = c:FindFirstChild("HumanoidRootPart"); if not root then return end
		local hum = c:FindFirstChildOfClass("Humanoid"); if not hum or hum.Health <= 0 then return end
		-- so o aimbot precisa do controle exclusivo (ele manda no eixo Y).
		-- Auto Left/Right so mexem no XZ, entao o inf jump funciona junto.
		if autoBatEnabled then return end
		local jumpHeld = UIS:IsKeyDown(Enum.KeyCode.Space) or V.jumpHeld
			or V._gamepadBtnHeld or (V._holdTouch ~= nil)
		local holdingBR = V.infJumpHoldingBR(c)
		if jumpHeld and V.rawGetVel(root).Y < 30 then
			-- so forca hum.Jump se NAO estiver com brainrot na mao
			if not holdingBR then hum.Jump = true end
			V.infJumpImpulse(root, 52)
		end
		if V.rawGetVel(root).Y < -120 then
			V.infJumpImpulse(root, -120)
		end
	end)
end
-- mobile jump button hook
task.spawn(function()
	local pg = LP:WaitForChild("PlayerGui", 10)
	if not pg then return end
	local function hookJumpButton(btn)
		if btn:IsA("GuiButton") and btn.Name == "JumpButton" and not btn:GetAttribute("InfJumpHooked") then
			btn:SetAttribute("InfJumpHooked", true)
			btn.MouseButton1Down:Connect(function() if infJumpEnabled then V.jumpHeld = true end end)
			btn.MouseButton1Up:Connect(function() V.jumpHeld = false end)
			btn.MouseLeave:Connect(function() V.jumpHeld = false end)
		end
	end
	for _, d in ipairs(pg:GetDescendants()) do hookJumpButton(d) end
	pg.DescendantAdded:Connect(hookJumpButton)
end)
V.refreshInfJump = function()
	if infJumpEnabled then V.infJumpLoop() else V._holdTouch = nil end
	if not infJumpEnabled then V.jumpHeld = false; V._gamepadBtnHeld = false end
end
-- destrava o pulo se a janela perder o foco ou o personagem respawnar
-- (senao o Space/toque ficava "preso" e o inf jump continuava sozinho)
UIS.WindowFocusReleased:Connect(function()
	V.jumpHeld = false; V._gamepadBtnHeld = false; V._holdTouch = nil
	V._activeTouches = {}
end)
LP.CharacterAdded:Connect(function()
	V.jumpHeld = false; V._gamepadBtnHeld = false; V._holdTouch = nil
	V._activeTouches = {}
end)
V.infJumpLoop()
local function startUnwalk()
	local c=LP.Character;if not c then return end
	local hum=c:FindFirstChildOfClass("Humanoid")
	if hum then for _,t in ipairs(hum:GetPlayingAnimationTracks()) do t:Stop() end end
	local anim=c:FindFirstChild("Animate")
	if anim then unwalkSavedAnimate=anim:Clone();anim:Destroy() end
end
local function stopUnwalk()
	local c=LP.Character
	if c and unwalkSavedAnimate then unwalkSavedAnimate:Clone().Parent=c;unwalkSavedAnimate=nil end
end
-- ============================================================
-- DROP BRAINROT — portado do MISERY DUELS ("Jump Drop Mode" do Night Hub):
-- sobe por 0.22s a 160 de velocidade vertical, depois faz raycast (3000
-- studs) e gruda no chao, zerando velocidades e forcando estado Running.
-- ============================================================
local DROP_ASCEND_DURATION, DROP_ASCEND_SPEED = 0.22, 160
V.stopAutoTPForDropAction=function()
	if autoTPEnabled then
		stopAutoTP()
		pcall(function() if setAutoTPVisual then setAutoTPVisual(false) end end)
	end
end
local function runDrop()
	if dropActive then return end
	V.stopAutoTPForDropAction()
	if autoBatEnabled then
		autoBatEnabled=false
		if resetAutoBatMotion then resetAutoBatMotion() end
		if autoBatSetVisual then autoBatSetVisual(false) end
	end
	local char = LP.Character; if not char then return end
	local root = char:FindFirstChild("HumanoidRootPart"); if not root then return end
	local hum0 = char:FindFirstChildOfClass("Humanoid"); if not hum0 then return end
	dropActive = true
	-- o motor de speed nao pode disputar o HRP durante o drop
	if V.suspendSpeedEngine then V.suspendSpeedEngine() end
	local t0 = tick()
	local dc
	dc = RunService.Heartbeat:Connect(function()
		local c = LP.Character
		local r = c and c:FindFirstChild("HumanoidRootPart")
		if not c or not r then
			if dc then dc:Disconnect() end
			dropActive = false
			if V.ensureLinVel then pcall(V.ensureLinVel) end
			return
		end
		-- trava de seguranca: nunca deixa o drop preso mais de 3s
		if tick() - t0 > 3 then
			if dc then dc:Disconnect() end
			dropActive = false
			if V.ensureLinVel then pcall(V.ensureLinVel) end
			return
		end
		if not dropActive then
			if dc then dc:Disconnect() end
			return
		end
		if tick() - t0 >= DROP_ASCEND_DURATION then
			if dc then dc:Disconnect() end
			pcall(function()
				local hum2 = c:FindFirstChildOfClass("Humanoid")
				local rp = RaycastParams.new()
				rp.FilterDescendantsInstances = {c}
				rp.FilterType = Enum.RaycastFilterType.Exclude
				local rr = workspace:Raycast(r.Position, Vector3.new(0, -3000, 0), rp)
				if rr then
					local off = ((hum2 and hum2.HipHeight) or 2) + (r.Size.Y / 2)
					r.CFrame = CFrame.new(r.Position.X, rr.Position.Y + off, r.Position.Z)
					V.rawSetVel(r, Vector3.zero)
					r.AssemblyAngularVelocity = Vector3.zero
				end
				if hum2 and hum2.Health > 0 then hum2:ChangeState(Enum.HumanoidStateType.Running) end
			end)
			dropActive = false
			-- devolve o controle pro motor de speed
			if V.ensureLinVel then pcall(V.ensureLinVel) end
			return
		end
		local lv = V.rawGetVel(r)
		V.rawSetVel(r, Vector3.new(lv.X, DROP_ASCEND_SPEED, lv.Z))
	end)
end
-- TP DOWN — portado do MISERY DUELS: teleporta direto pro Y=-7 fixo,
-- preservando a rotacao (yaw) e zerando a velocidade. Simples e direto.
doAutoTPDown = function(force)
	local char=LP.Character;if not char then return end
	local hrp=char:FindFirstChild("HumanoidRootPart");if not hrp then return end
	local hum2=char:FindFirstChildOfClass("Humanoid");if not hum2 then return end
	if not force then
		if hum2.FloorMaterial~=Enum.Material.Air then return end
		if not (hrp.Position.Y >= autoTPHeight) then return end
	end
	pcall(function()
		hrp.CFrame = CFrame.new(hrp.Position.X, -7, hrp.Position.Z)
			* CFrame.Angles(0, select(2, hrp.CFrame:ToEulerAnglesYXZ()), 0)
		-- rawSetVel: escrita direta eh engolida pelo spoof do motor de speed
		if V.rawSetVel then V.rawSetVel(hrp, Vector3.zero) else hrp.Velocity = Vector3.zero end
		hrp.AssemblyAngularVelocity = Vector3.zero
		-- zera tambem o motor de speed, senao ele reempurra no mesmo frame
		if V.clearLinVel then V.clearLinVel() end
	end)
end
startAutoTP = function()
	if autoTPConn then task.cancel(autoTPConn);autoTPConn=nil end
	autoTPConn=task.spawn(function()
		while autoTPEnabled do
			task.wait(0.1)
			pcall(function() doAutoTPDown(false) end)
		end
	end)
end
stopAutoTP = function()
	autoTPEnabled=false
	if autoTPConn then task.cancel(autoTPConn);autoTPConn=nil end
end
local function runTPFloor()
	pcall(function() doAutoTPDown(true) end)
end
local defLightBrightness,defLightClock,defLightAmbient
-- intensidade do Stretch Rez: 1.0 = sem esticar, quanto MENOR mais esticado.
-- (o valor original fixo era 0.8) — ajustavel pelos botoes +/- na aba Main.
V.stretchRezAmount = tonumber(V.stretchRezAmount) or 0.8
V.setStretchRezAmount = function(v)
	v = math.clamp(tonumber(v) or 0.8, 0.3, 1)
	v = math.floor(v * 100 + 0.5) / 100
	V.stretchRezAmount = v
	if V.stretchAmtLbl and V.stretchAmtLbl.Parent then
		-- mostra como "intensidade": 0% = normal, 100% = maximo esticado
		V.stretchAmtLbl.Text = string.format("%d%%", math.floor((1 - v) / 0.7 * 100 + 0.5))
	end
end
local function enableStretchRez()
	stretchRezEnabled=true
	pcall(function() RunService:UnbindFromRenderStep("Vexus_Stretch") end)
	pcall(function()
		RunService:BindToRenderStep("Vexus_Stretch", Enum.RenderPriority.Last.Value - 1, function()
			local cam = workspace.CurrentCamera
			if cam then
				local a = tonumber(V.stretchRezAmount) or 0.8
				cam.CFrame = cam.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, a, 0, 0, 0, 1)
			end
		end)
	end)
end
local function disableStretchRez()
	stretchRezEnabled=false
	pcall(function() RunService:UnbindFromRenderStep("Vexus_Stretch") end)
end
-- ============================================================
-- CUSTOM FOV - user-adjustable Field of View
-- ============================================================
-- Uses BindToRenderStep at a priority AFTER the camera (Camera+1) so the
-- game's own camera code can't reset the FOV right after we set it.
local function enableCustomFov()
	V.customFovEnabled=true
	pcall(function() RunService:UnbindFromRenderStep("Vexus_Fov") end)
	local cam = workspace.CurrentCamera
	if cam then cam.FieldOfView=V.customFovValue end
	RunService:BindToRenderStep("Vexus_Fov", Enum.RenderPriority.Camera.Value + 1, function()
		local c = workspace.CurrentCamera
		if c then c.FieldOfView = V.customFovValue end
	end)
end
local function disableCustomFov()
	V.customFovEnabled=false
	pcall(function() RunService:UnbindFromRenderStep("Vexus_Fov") end)
	local cam = workspace.CurrentCamera
	if cam then cam.FieldOfView=70 end
end
local function applyAntiLagDerender(obj)
	pcall(function()
		if obj:IsA("Accessory") or obj:IsA("Hat") then obj:Destroy()
		elseif obj:IsA("BasePart") then obj.Material=Enum.Material.Plastic;obj.Reflectance=0;obj.CastShadow=false
		elseif obj:IsA("Decal") or obj:IsA("Texture") then obj.Transparency=1
		elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then obj.Enabled=false
		elseif obj:IsA("AnimationController") or obj:IsA("Animator") then
			for _,t in ipairs(obj:GetPlayingAnimationTracks()) do pcall(function() t:Stop(0) end) end
		end
	end)
end
-- ============================================================
-- ANTI LAG (NIGHT ANTI LAG) — reversivel: guarda o valor original
-- de cada propriedade que altera e devolve tudo ao desligar.
-- ============================================================
V.AL = { conn=nil, def={}, effects={}, restore=setmetatable({}, {__mode="k"}) }
V.alRemember = function(obj, prop)
	local t = V.AL.restore[obj]
	if not t then t = {}; V.AL.restore[obj] = t end
	if t[prop] == nil then t[prop] = obj[prop] end
end
V.applyAntiLagObj = function(obj)
	pcall(function()
		if obj:IsA("BasePart") then
			V.alRemember(obj, "Material"); V.alRemember(obj, "Reflectance"); V.alRemember(obj, "CastShadow")
			obj.Material = Enum.Material.Plastic
			obj.Reflectance = 0
			obj.CastShadow = false
		elseif obj:IsA("Decal") or obj:IsA("Texture") then
			V.alRemember(obj, "Transparency")
			obj.Transparency = 1
		elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam")
			or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
			V.alRemember(obj, "Enabled")
			obj.Enabled = false
		elseif obj:IsA("AnimationController") or obj:IsA("Animator") then
			for _, tr in ipairs(obj:GetPlayingAnimationTracks()) do pcall(function() tr:Stop(0) end) end
		end
	end)
end
local function enableAntiLag()
	if antiLagEnabled then return end
	antiLagEnabled = true
	local AL = V.AL
	AL.def.GlobalShadows = Lighting.GlobalShadows
	AL.def.Brightness    = Lighting.Brightness
	AL.def.FogEnd        = Lighting.FogEnd
	AL.def.EnvDiffuse    = Lighting.EnvironmentDiffuseScale
	AL.def.EnvSpecular   = Lighting.EnvironmentSpecularScale
	pcall(function()
		Lighting.GlobalShadows = false
		Lighting.FogEnd = 1e10
		Lighting.EnvironmentDiffuseScale = 0
		Lighting.EnvironmentSpecularScale = 0
	end)
	AL.effects = {}
	for _, e in ipairs(Lighting:GetChildren()) do
		pcall(function()
			if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect")
				or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then
				if e.Enabled then table.insert(AL.effects, e) end
				e.Enabled = false
			end
		end)
	end
	for _, obj in ipairs(workspace:GetDescendants()) do V.applyAntiLagObj(obj) end
	if AL.conn then AL.conn:Disconnect() end
	AL.conn = workspace.DescendantAdded:Connect(function(obj)
		if antiLagEnabled then V.applyAntiLagObj(obj) end
	end)
end
local function disableAntiLag()
	if not antiLagEnabled then return end
	antiLagEnabled = false
	local AL = V.AL
	if AL.conn then AL.conn:Disconnect(); AL.conn = nil end
	pcall(function()
		if AL.def.GlobalShadows ~= nil then Lighting.GlobalShadows = AL.def.GlobalShadows end
		if AL.def.Brightness ~= nil then Lighting.Brightness = AL.def.Brightness end
		if AL.def.FogEnd ~= nil then Lighting.FogEnd = AL.def.FogEnd end
		if AL.def.EnvDiffuse ~= nil then Lighting.EnvironmentDiffuseScale = AL.def.EnvDiffuse end
		if AL.def.EnvSpecular ~= nil then Lighting.EnvironmentSpecularScale = AL.def.EnvSpecular end
		for _, e in ipairs(AL.effects) do if e and e.Parent then e.Enabled = true end end
	end)
	AL.effects = {}
	AL.def = {}
	task.spawn(function()  -- devolve em blocos pra nao travar
		local n = 0
		for obj, props in pairs(AL.restore) do
			n = n + 1
			pcall(function() for k, v in pairs(props) do obj[k] = v end end)
			AL.restore[obj] = nil
			if n % 400 == 0 then task.wait() end
		end
		AL.restore = setmetatable({}, {__mode = "k"})
	end)
end
-- ============================================================
-- NUKE OPTIMISER (NIGHT ANTI LAG) — DESTRUTIVO. Destroi
-- particulas, luzes, roupas e partes fora do alcance. Manter a
-- aparencia do jogo (KeepGameLook) evita o mapa virar uma cor so.
-- ============================================================
V.NUKE = { on=false, conns={}, threads={}, defQuality=nil, defMesh=nil, def={}, effects={}, hidden=setmetatable({}, {__mode="k"}) }
V.NCFG = {
	FpsCap = 999, RangeCull = true, XMin = -560, XMax = -240,
	KeepGameLook = true, GreySky = false, LowQuality = false,
	ClearMaterialVariant = false, DestroySurfaceAppearance = false,
	DestroyMeshes = false, BlankMeshTex = false, DestroyDecals = false,
	StripParticles = true, StripLights = true, StripClothing = true, TerrainTweak = true,
}
do
	local NUKE, CFG = V.NUKE, V.NCFG
	local CLOTHING = {"Shirt","Pants","ShirtGraphic","Accessory","Hat","HairAccessory",
		"FaceAccessory","NeckAccessory","ShoulderAccessory","FrontAccessory","BackAccessory","WaistAccessory"}
	local BASE_NAMES = {"baseplate","spawnlocation","spawn location","spawn"}
	local function SafeDestroy(obj)
		if obj and obj.Name == "Overhead" then return end
		pcall(function() obj:Destroy() end)
	end
	local function hideDecal(obj)
		pcall(function()
			if CFG.DestroyDecals then SafeDestroy(obj); return end
			if NUKE.hidden[obj] == nil then NUKE.hidden[obj] = obj.Transparency end
			obj.Transparency = 1
		end)
	end
	local function showDecals()
		local n = 0
		for obj, v in pairs(NUKE.hidden) do
			n = n + 1
			pcall(function() obj.Transparency = v end)
			NUKE.hidden[obj] = nil
			if n % 400 == 0 then task.wait() end
		end
	end
	local function IsClothing(obj)
		for _, cn in ipairs(CLOTHING) do if obj:IsA(cn) then return true end end
		return false
	end
	local function IsCharacterPart(obj)
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr.Character and obj:IsDescendantOf(plr.Character) then return true end
		end
		return false
	end
	local function IsOutOfRange(obj)
		if obj:IsA("BasePart") then
			local x = obj.Position.X
			return x < CFG.XMin or x > CFG.XMax
		end
		return false
	end
	local function IsBase(obj)
		if not obj:IsA("BasePart") then return false end
		local nl = string.lower(obj.Name)
		for _, n in ipairs(BASE_NAMES) do if string.find(nl, n, 1, true) then return true end end
		return false
	end
	local function IsInBase(obj)
		local pp = obj.Parent
		while pp and pp ~= workspace do
			if IsBase(pp) then return true end
			pp = pp.Parent
		end
		return false
	end
	local function MakeTransparent(obj)
		pcall(function()
			if IsBase(obj) and not IsCharacterPart(obj) then
				obj.Transparency = 1
				obj.CastShadow = false
			end
		end)
	end
	local function CleanObject(obj)
		pcall(function()
			if CFG.DestroySurfaceAppearance and obj:IsA("SurfaceAppearance") then SafeDestroy(obj)
			elseif CFG.DestroyMeshes and obj:IsA("SpecialMesh") then SafeDestroy(obj)
			elseif CFG.BlankMeshTex and obj:IsA("SpecialMesh") then obj.TextureId = ""
			elseif obj:IsA("Decal") or obj:IsA("Texture") then
				if not (obj.Name == "face" and obj.Parent and obj.Parent.Name == "Head") then hideDecal(obj) end
			elseif CFG.StripParticles and (obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam")) then SafeDestroy(obj)
			elseif CFG.StripLights and (obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight")) then SafeDestroy(obj)
			elseif CFG.StripParticles and (obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") or obj:IsA("Explosion")) then SafeDestroy(obj)
			elseif obj:IsA("BasePart") then
				obj.CastShadow = false
				obj.Material = Enum.Material.Plastic
				obj.Reflectance = 0
				if CFG.ClearMaterialVariant then obj.MaterialVariant = "" end
			end
		end)
	end
	local function OptimizeLighting()
		pcall(function()
			NUKE.def.GlobalShadows = Lighting.GlobalShadows
			NUKE.def.FogStart = Lighting.FogStart
			NUKE.def.FogEnd = Lighting.FogEnd
			NUKE.def.EnvDiffuse = Lighting.EnvironmentDiffuseScale
			NUKE.def.EnvSpecular = Lighting.EnvironmentSpecularScale
			NUKE.def.Brightness = Lighting.Brightness
			NUKE.def.Ambient = Lighting.Ambient
			NUKE.effects = {}
			Lighting.GlobalShadows = false
			Lighting.EnvironmentDiffuseScale = 0
			Lighting.EnvironmentSpecularScale = 0
			if CFG.KeepGameLook then
				Lighting.FogStart = 0
				Lighting.FogEnd = 1e10
				for _, v in ipairs(Lighting:GetChildren()) do
					if v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("ColorCorrectionEffect")
						or v:IsA("SunRaysEffect") or v:IsA("DepthOfFieldEffect") then
						if v.Enabled then table.insert(NUKE.effects, v) end
						pcall(function() v.Enabled = false end)
					end
				end
			else
				Lighting.FogEnd = 9e9; Lighting.FogStart = 9e9
				Lighting.Brightness = 1.5
				Lighting.Ambient = Color3.fromRGB(60, 60, 60)
				for _, v in ipairs(Lighting:GetChildren()) do
					if v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("ColorCorrectionEffect")
						or v:IsA("SunRaysEffect") or v:IsA("DepthOfFieldEffect")
						or v:IsA("Atmosphere") or v:IsA("Clouds") then
						pcall(function() v:Destroy() end)
					end
				end
			end
		end)
	end
	local function ApplyTerrain()
		pcall(function()
			local terrain = workspace:FindFirstChildOfClass("Terrain")
			if terrain and CFG.TerrainTweak then
				terrain.Decoration = false
				terrain.WaterWaveSize = 0
				terrain.WaterWaveSpeed = 0
				terrain.WaterReflectance = 0
				terrain.WaterTransparency = 1
			end
		end)
	end
	local function OptimizeCharacter(char)
		if not char then return end
		task.spawn(function()
			task.wait(0.3)
			if not NUKE.on then return end
			for _, obj in ipairs(char:GetDescendants()) do
				if CFG.StripClothing and IsClothing(obj) then SafeDestroy(obj) else CleanObject(obj) end
			end
		end)
	end
	local function NukeApplyFps()
		pcall(function() if type(setfpscap) == "function" then setfpscap(CFG.FpsCap) end end)
	end
	V.enableNuke = function()
		if NUKE.on then return end
		NUKE.on = true
		if CFG.LowQuality then
			pcall(function()
				NUKE.defQuality = settings().Rendering.QualityLevel
				NUKE.defMesh = settings().Rendering.MeshPartDetailLevel
				settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
				settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01
			end)
		end
		NukeApplyFps()
		table.insert(NUKE.threads, task.spawn(function()
			if not game:IsLoaded() then game.Loaded:Wait() end
			OptimizeLighting()
			ApplyTerrain()
			for _, obj in ipairs(workspace:GetDescendants()) do
				if not NUKE.on then return end
				if IsBase(obj) then MakeTransparent(obj)
				elseif IsClothing(obj) then SafeDestroy(obj)
				elseif IsInBase(obj) then
				elseif IsCharacterPart(obj) then
				elseif CFG.RangeCull and IsOutOfRange(obj) then SafeDestroy(obj)
				else CleanObject(obj) end
			end
			for _, obj in ipairs(workspace:GetDescendants()) do MakeTransparent(obj) end
		end))
		table.insert(NUKE.conns, workspace.DescendantAdded:Connect(function(obj)
			if not NUKE.on then return end
			task.defer(function()
				if not NUKE.on then return end
				if IsBase(obj) then MakeTransparent(obj); return end
				if IsClothing(obj) then SafeDestroy(obj)
				elseif IsInBase(obj) then
				elseif IsCharacterPart(obj) then
				elseif CFG.RangeCull and IsOutOfRange(obj) then SafeDestroy(obj)
				else CleanObject(obj) end
			end)
		end))
		table.insert(NUKE.conns, Lighting.DescendantAdded:Connect(function(obj)
			if not NUKE.on then return end
			if obj:IsA("Atmosphere") or obj:IsA("Clouds") or obj:IsA("PostEffect") then SafeDestroy(obj) end
		end))
		for _, plr in ipairs(Players:GetPlayers()) do
			OptimizeCharacter(plr.Character)
			table.insert(NUKE.conns, plr.CharacterAdded:Connect(OptimizeCharacter))
		end
		table.insert(NUKE.conns, Players.PlayerAdded:Connect(function(plr)
			table.insert(NUKE.conns, plr.CharacterAdded:Connect(OptimizeCharacter))
		end))
		table.insert(NUKE.threads, task.spawn(function()
			while NUKE.on do task.wait(5); NukeApplyFps() end
		end))
		table.insert(NUKE.threads, task.spawn(function()
			while NUKE.on do task.wait(15); pcall(function() collectgarbage("collect") end) end
		end))
	end
	V.disableNuke = function()
		NUKE.on = false
		for _, c in ipairs(NUKE.conns) do pcall(function() c:Disconnect() end) end
		NUKE.conns = {}
		NUKE.threads = {}
		pcall(function()
			if NUKE.defQuality then settings().Rendering.QualityLevel = NUKE.defQuality end
			if NUKE.defMesh then settings().Rendering.MeshPartDetailLevel = NUKE.defMesh end
		end)
		NUKE.defQuality = nil
		NUKE.defMesh = nil
		pcall(function()
			local d = NUKE.def
			if d.GlobalShadows ~= nil then Lighting.GlobalShadows = d.GlobalShadows end
			if d.FogStart ~= nil then Lighting.FogStart = d.FogStart end
			if d.FogEnd ~= nil then Lighting.FogEnd = d.FogEnd end
			if d.EnvDiffuse ~= nil then Lighting.EnvironmentDiffuseScale = d.EnvDiffuse end
			if d.EnvSpecular ~= nil then Lighting.EnvironmentSpecularScale = d.EnvSpecular end
			if d.Brightness ~= nil then Lighting.Brightness = d.Brightness end
			if d.Ambient ~= nil then Lighting.Ambient = d.Ambient end
			for _, e in ipairs(NUKE.effects) do
				if e and e.Parent then pcall(function() e.Enabled = true end) end
			end
		end)
		NUKE.def = {}
		NUKE.effects = {}
		if CFG.DestroyDecals == false then task.spawn(showDecals) end
	end
	-- =========================================================
	-- X-RAY BRAINROT (sistema proprio, independente do Nuke Optimizer)
	-- Versao OTIMIZADA: o script original varria workspace inteiro e
	-- reaplicava a transparencia em TODAS as partes a cada Heartbeat
	-- (60x/s) — era isso que travava. Aqui:
	--   * cache dos modelos de brainrot (nao varre workspace toda hora)
	--   * scan incremental, em pedacos, sem travar o frame
	--   * reaplica so a cada 0.35s e SO nas partes que sairam do valor
	--   * ignora partes muito longe (nao adianta ver atraves da parede
	--     de algo a 500 studs) — configuravel em V.xrayRange
	-- =========================================================
	V.xrayTransparency = tonumber(V.xrayTransparency) or 0.5
	V.xrayRange = tonumber(V.xrayRange) or 260
	local XR = { on = false, parts = {}, conns = {}, thread = nil }
	V.XR = XR
	local function xrIsBrainrotModel(model)
		if not model or not model:IsA("Model") then return false end
		if not model:FindFirstChildOfClass("Humanoid") then return false end
		-- personagem de jogador nao conta
		if Players:GetPlayerFromCharacter(model) then return false end
		return true
	end
	local function xrAddModel(model)
		if not xrIsBrainrotModel(model) then return end
		for _, obj in ipairs(model:GetDescendants()) do
			if obj:IsA("BasePart") then XR.parts[obj] = true end
		end
	end
	local function xrApply(part)
		if part.LocalTransparencyModifier ~= V.xrayTransparency then
			part.LocalTransparencyModifier = V.xrayTransparency
		end
	end
	V.xrayStart = function()
		if XR.on then return end
		XR.on = true
		XR.parts = {}
		-- scan inicial em pedacos (nao trava o jogo em mapas grandes)
		table.insert(XR.conns, {Disconnect = function() end})
		task.spawn(function()
			local n = 0
			for _, m in ipairs(workspace:GetDescendants()) do
				if not XR.on then return end
				if m:IsA("Model") then
					xrAddModel(m)
					n = n + 1
					if n % 40 == 0 then task.wait() end
				end
			end
		end)
		-- modelos novos entram no cache sem re-scan geral
		table.insert(XR.conns, workspace.DescendantAdded:Connect(function(obj)
			if not XR.on then return end
			if obj:IsA("Model") then
				task.defer(function()
					if XR.on then xrAddModel(obj) end
				end)
			elseif obj:IsA("BasePart") then
				local m = obj:FindFirstAncestorOfClass("Model")
				if m and xrIsBrainrotModel(m) then XR.parts[obj] = true end
			end
		end))
		-- reaplica periodicamente (nao a cada frame) e limpa o cache
		XR.thread = task.spawn(function()
			while XR.on do
				local myRoot = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
				local myPos = myRoot and myRoot.Position
				local rng = V.xrayRange
				local i = 0
				for part in pairs(XR.parts) do
					if not XR.on then return end
					if not part.Parent then
						XR.parts[part] = nil
					else
						if myPos then
							local ok, d = pcall(function() return (part.Position - myPos).Magnitude end)
							if ok and d <= rng then xrApply(part) end
						else
							xrApply(part)
						end
					end
					i = i + 1
					if i % 150 == 0 then task.wait() end
				end
				task.wait(0.35)
			end
		end)
	end
	V.xrayStop = function()
		XR.on = false
		for _, c in ipairs(XR.conns) do pcall(function() c:Disconnect() end) end
		XR.conns = {}
		XR.thread = nil
		for part in pairs(XR.parts) do
			if part and part.Parent then
				pcall(function() part.LocalTransparencyModifier = 0 end)
			end
		end
		XR.parts = {}
	end
	V.setXrayTransparency = function(v)
		v = math.clamp(tonumber(v) or 0.5, 0, 0.8)
		v = math.floor(v * 100 + 0.5) / 100
		V.xrayTransparency = v
		if V.xrayLbl and V.xrayLbl.Parent then
			V.xrayLbl.Text = string.format("%d%%", math.floor(v * 100 + 0.5))
		end
		-- some com o "+" ao bater no teto (80%) e com o "-" no piso (0%)
		if V.xrayPlusBtn and V.xrayPlusBtn.Parent then
			V.xrayPlusBtn.Visible = v < 0.8 - 0.0001
		end
		if V.xrayMinusBtn and V.xrayMinusBtn.Parent then
			V.xrayMinusBtn.Visible = v > 0.0001
		end
	end
end
local function findMedusa()
	local c=LP.Character;if not c then return nil end
	for _,t in ipairs(c:GetChildren()) do if t:IsA("Tool") then local n=t.Name:lower();if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end
	local bp=LP:FindFirstChild("Backpack")
	if bp then for _,t in ipairs(bp:GetChildren()) do if t:IsA("Tool") then local n=t.Name:lower();if n:find("medusa") or n:find("head") or n:find("stone") then return t end end end end
	return nil
end
local function useMedusaCounter()
	if medusaDebounce then return end;if tick()-medusaLastUsed<MEDUSA_COOLDOWN then return end
	local c=LP.Character;if not c then return end;medusaDebounce=true
	local med=findMedusa();if not med then medusaDebounce=false;return end
	if med.Parent~=c then local hum2=c:FindFirstChildOfClass("Humanoid");if hum2 then hum2:EquipTool(med) end end
	pcall(function() med:Activate() end);medusaLastUsed=tick();medusaDebounce=false
end
local function onAnchorChanged(part)
	return part:GetPropertyChangedSignal("Anchored"):Connect(function()
		if part.Anchored and part.Transparency==1 then useMedusaCounter() end
	end)
end
local function setupMedusa(char)
	for _,c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end;Conns.anchor={}
	if not char then return end
	for _,part in ipairs(char:GetDescendants()) do if part:IsA("BasePart") then table.insert(Conns.anchor,onAnchorChanged(part)) end end
	table.insert(Conns.anchor,char.DescendantAdded:Connect(function(part)
		if part:IsA("BasePart") then table.insert(Conns.anchor,onAnchorChanged(part)) end
	end))
end
local function stopMedusaCounter()
	for _,c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end;Conns.anchor={}
end
local BAT_COUNTER_SLAP_LIST={"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"}
local function findBatForCounter()
	local c=LP.Character;if not c then return nil end
	local bp=LP:FindFirstChildOfClass("Backpack")
	for _,name in ipairs(BAT_COUNTER_SLAP_LIST) do
		local t=c:FindFirstChild(name) or (bp and bp:FindFirstChild(name));if t then return t end
	end
	for _,ch in ipairs(c:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end
	if bp then for _,ch in ipairs(bp:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end end
	return nil
end
local function swingBatForCounter(bat,char)
	local hum2=char:FindFirstChildOfClass("Humanoid")
	if bat.Parent~=char then if hum2 then pcall(function() hum2:EquipTool(bat) end) end;task.wait(0.05) end
	local remote=bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildOfClass("RemoteFunction")
	if remote and remote:IsA("RemoteEvent") then
		pcall(function() remote:FireServer() end);task.wait(0.15);pcall(function() remote:FireServer() end)
	else pcall(function() bat:Activate() end);task.wait(0.15);pcall(function() bat:Activate() end) end
end
startBatCounter=function()
	if Conns.batCounter then return end
	Conns.batCounter=RunService.Heartbeat:Connect(function()
		if not batCounterEnabled then return end
		if batCounterDebounce then return end
		local char=LP.Character;if not char then return end
		local hum2=char:FindFirstChildOfClass("Humanoid");if not hum2 then return end
		local st=hum2:GetState()
		if st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown then
			batCounterDebounce=true
			task.spawn(function()
				local bat=findBatForCounter()
				if bat then swingBatForCounter(bat,char) end
				task.wait(0.5);batCounterDebounce=false
			end)
		end
	end)
end
stopBatCounter=function()
	if Conns.batCounter then Conns.batCounter:Disconnect();Conns.batCounter=nil end
	batCounterDebounce=false
end
-- ============================================================
-- BAT TP (portado do Sky Hub: "Tp Bat" / Vision Bat)
-- Trava no jogador mais proximo, teleporta pra cima dele,
-- aponta a camera e acerta o taco automaticamente.
-- Estado e funcoes vivendo na tabela V (nao usa locais do topo).
-- ============================================================
do
	V.batTpEnabled = false
	V.batTpConn = nil
	V.batTpCooldown = false
	V.batTpMode = 1   -- 1 = V1 (Vexus/Sky vision bat), 2 = V2 (CZ BAT TP)
	local BAT_TP_LIST = BAT_COUNTER_SLAP_LIST
	-- V2 (CZ): procura SO a ferramenta "Bat" (igual ao CZ BAT TP)
	local function czGetBat()
		local char = LP.Character
		if not char then return nil end
		local tool = char:FindFirstChild("Bat")
		if tool and tool:IsA("Tool") then return tool end
		local bp = LP:FindFirstChild("Backpack")
		if bp then
			tool = bp:FindFirstChild("Bat")
			if tool and tool:IsA("Tool") then
				tool.Parent = char  -- equipa jogando direto pro char (estilo CZ)
				return tool
			end
		end
		return nil
	end
	local function batTpFindTool()
		local char = LP.Character
		if not char then return nil end
		local bp = LP:FindFirstChildOfClass("Backpack")
		for _, name in ipairs(BAT_TP_LIST) do
			local t = char:FindFirstChild(name)
			if t and t:IsA("Tool") then return t end
		end
		if bp then
			for _, name in ipairs(BAT_TP_LIST) do
				local t = bp:FindFirstChild(name)
				if t and t:IsA("Tool") then return t end
			end
		end
		for _, ch in ipairs(char:GetChildren()) do
			if ch:IsA("Tool") and (ch.Name:lower():find("bat") or ch.Name:lower():find("slap")) then return ch end
		end
		if bp then
			for _, ch in ipairs(bp:GetChildren()) do
				if ch:IsA("Tool") and (ch.Name:lower():find("bat") or ch.Name:lower():find("slap")) then return ch end
			end
		end
		return nil
	end
	local function batTpClosest()
		local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
		if not hrp then return nil end
		local closest, cd = nil, math.huge
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= LP and plr.Character then
				local hum = plr.Character:FindFirstChildOfClass("Humanoid")
				local tr = plr.Character:FindFirstChild("HumanoidRootPart")
				if tr and hum and hum.Health > 0 then
					local d = (hrp.Position - tr.Position).Magnitude
					if d < cd then cd = d; closest = plr end
				end
			end
		end
		return closest, cd
	end
	local function batTpHit()
		if V.batTpCooldown then return end
		V.batTpCooldown = true
		pcall(function()
			local char = LP.Character
			if not char then return end
			local hum = char:FindFirstChildOfClass("Humanoid")
			local tool
			if V.batTpMode == 2 then
				-- ===== V2 (CZ BAT TP): so a ferramenta "Bat", Activate() depois FireServer =====
				tool = czGetBat()
				if tool then
					pcall(function() tool:Activate() end)
					local ev = tool:FindFirstChildWhichIsA("RemoteEvent")
					if ev then pcall(function() ev:FireServer() end) end
				end
			else
				-- ===== V1 (Vexus/Sky): qualquer bat/slap, FireServer senao Activate =====
				tool = batTpFindTool()
				if tool then
					if tool.Parent ~= char and hum then pcall(function() hum:EquipTool(tool) end) end
					local ev = tool:FindFirstChildWhichIsA("RemoteEvent")
					if ev then pcall(function() ev:FireServer() end)
					else pcall(function() tool:Activate() end) end
				end
			end
		end)
		task.delay(0.08, function() V.batTpCooldown = false end)
	end
	function V.startBatTp()
		if V.batTpConn then return end
		V.batTpConn = RunService.Heartbeat:Connect(function()
			if not V.batTpEnabled then return end
			local char = LP.Character
			local hrp = char and char:FindFirstChild("HumanoidRootPart")
			if not hrp then return end
			local target = batTpClosest()
			if target and target.Character then
				local tr = target.Character:FindFirstChild("HumanoidRootPart")
				if tr then
					if sethiddenproperty then pcall(function() sethiddenproperty(hrp, "PhysicsRepRootPart", tr) end) end
					local targetPos = tr.Position + Vector3.new(0, 0.9, 0)
					if (hrp.Position - targetPos).Magnitude > 8 then
						hrp.CFrame = CFrame.new(targetPos)
					end
					local cam = workspace.CurrentCamera
					if cam then cam.CFrame = CFrame.new(cam.CFrame.Position, tr.Position) end
					batTpHit()
				end
			end
		end)
	end
	function V.stopBatTp()
		if V.batTpConn then V.batTpConn:Disconnect(); V.batTpConn = nil end
	end
end
-- Misery stopBatAimbot(): zera velocidade/rotacao e devolve o AutoRotate
-- Ao respawnar com o aimbot ligado, o Humanoid novo nasce com AutoRotate
-- ligado; sem isso a rotacao automatica briga com a mira do aimbot e o
-- personagem fica girando/tremendo.
LP.CharacterAdded:Connect(function(char)
	task.defer(function()
		if not autoBatEnabled then return end
		local h = char:WaitForChild("Humanoid", 8)
		if h then h.AutoRotate = false end
		autoBatEquippedThisRun = false
		_autoBatTarget = nil
	end)
end)
resetAutoBatMotion=function()
	local char=LP.Character
	local hrp=char and char:FindFirstChild("HumanoidRootPart")
	local hum=char and char:FindFirstChildOfClass("Humanoid")
	_autoBatTarget=nil
	if hrp then
		V.rawSetVel(hrp, Vector3.zero)
		hrp.AssemblyAngularVelocity=Vector3.zero
	end
	if hum then hum.AutoRotate=true end
end
local _autoTPWasEnabled=false
local function enableAutoBat()
	if autoLeftEnabled then autoLeftEnabled=false;if autoLeftSetVisual then autoLeftSetVisual(false) end;stopAutoLeft() end
	if autoRightEnabled then autoRightEnabled=false;if autoRightSetVisual then autoRightSetVisual(false) end;stopAutoRight() end
	if autoTPEnabled then _autoTPWasEnabled=true;stopAutoTP();if setAutoTPVisual then setAutoTPVisual(false) end else _autoTPWasEnabled=false end
	autoBatEquippedThisRun=false
	autoBatEnabled=true
	-- Misery startBatAimbot(): trava a rotacao automatica do humanoide
	local hum0 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
	if hum0 then hum0.AutoRotate = false end
end
local function disableAutoBat()
	autoBatEnabled=false
	autoBatEquippedThisRun=false
	local char=LP.Character
	if char then
		local hum2=char:FindFirstChildOfClass("Humanoid")
		if hum2 then hum2.AutoRotate=true; pcall(function() hum2:Move(Vector3.zero,false) end) end
	end
	-- devolve o controle pro motor de speed (LinearVelocity) no proximo frame
	if V.ensureLinVel then pcall(V.ensureLinVel) end
	if resetAutoBatMotion then resetAutoBatMotion() end
	if _autoTPWasEnabled then
		_autoTPWasEnabled=false;autoTPEnabled=true
		if setAutoTPVisual then setAutoTPVisual(true) end;startAutoTP()
	end
end
local function queueAutoLeftStart()
	autoLeftEnabled=true
	if autoRightEnabled then autoRightEnabled=false;if autoRightSetVisual then autoRightSetVisual(false) end;stopAutoRight() end
	if autoBatEnabled then disableAutoBat();if autoBatSetVisual then autoBatSetVisual(false) end end
	startAutoLeft()
end
local function queueAutoRightStart()
	autoRightEnabled=true
	if autoLeftEnabled then autoLeftEnabled=false;if autoLeftSetVisual then autoLeftSetVisual(false) end;stopAutoLeft() end
	if autoBatEnabled then disableAutoBat();if autoBatSetVisual then autoBatSetVisual(false) end end
	startAutoRight()
end
local function queueAutoBatStart()
	if autoLeftEnabled then autoLeftEnabled=false;if autoLeftSetVisual then autoLeftSetVisual(false) end;stopAutoLeft() end
	if autoRightEnabled then autoRightEnabled=false;if autoRightSetVisual then autoRightSetVisual(false) end;stopAutoRight() end
	enableAutoBat()
end
-- ============================================================
-- AIMBOT — sistema COMPLETO portado do MISERY DUELS
--   V.aimbotMode 1 = "Normal" (Envy/Opium: predicao + tilt 3D, NAO equipa)
--   V.aimbotMode 2 = "Bypass" (Spectrum/Anti Bat Bypass: equipa a bat,
--                              mira direto no alvo, sem predicao)
-- Diferencas do Misery preservadas:
--   * findBat() com a lista completa de bats/slaps
--   * tryHitBat() usa RemoteEvent da tool (fallback :Activate())
--   * swing cooldown configuravel (V.swingCooldown)
--   * hit distance configuravel (V.hitDistance)
--   * alvo recalculado TODO frame (sem cache) — era o cache de 0.1s
--     do Vexus que fazia o aimbot travar/perder o alvo
-- Adaptado ao motor de speed do Haze: toda escrita de velocidade passa
-- por V.rawSetVel, senao o spoof engole e o aimbot nao sai do lugar.
-- ============================================================
V.aimbotMode = V.aimbotMode or 1
V.hittingCooldown = false
V.swingCooldown = tonumber(V.swingCooldown) or 0.08
V.hitDistance = tonumber(V.hitDistance) or 12
do
	local BAT_SLAP_LIST = {"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap",
		"Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"}
	local function findAnyTool()
		local c = LP.Character
		if c then for _, v in ipairs(c:GetChildren()) do if v:IsA("Tool") then return v end end end
		local bp = LP:FindFirstChildOfClass("Backpack")
		if bp then for _, v in ipairs(bp:GetChildren()) do if v:IsA("Tool") then return v end end end
		return nil
	end
	local function findBat()
		local char = LP.Character; if not char then return nil end
		for _, name in ipairs(BAT_SLAP_LIST) do
			local t = char:FindFirstChild(name)
			if t and t:IsA("Tool") then return t end
		end
		local bp = LP:FindFirstChildOfClass("Backpack")
		if bp then
			for _, name in ipairs(BAT_SLAP_LIST) do
				local t = bp:FindFirstChild(name)
				if t and t:IsA("Tool") then return t end
			end
		end
		for _, ch in ipairs(char:GetChildren()) do
			if ch:IsA("Tool") and (ch.Name:lower():find("bat") or ch.Name:lower():find("slap")) then return ch end
		end
		return nil
	end
	V.aimbotFindBat = findBat
	-- swing simples (modo Bypass): so ativa a bat que ja esta na mao
	local function trySwing()
		if not autoSwingEnabled then return end
		local bat = findBat()
		if bat and bat.Parent == LP.Character and bat:IsA("Tool") then
			pcall(function() bat:Activate() end)
		end
	end
	-- swing completo (modo Normal): equipa se precisar e dispara o remote
	local function tryHitBat()
		if V.hittingCooldown then return end
		-- sem personagem vivo nao adianta bater (evita spam de remote)
		local ch = LP.Character
		local hm = ch and ch:FindFirstChildOfClass("Humanoid")
		if not hm or hm.Health <= 0 then return end
		V.hittingCooldown = true
		pcall(function()
			local c = LP.Character; if not c then return end
			local hum2 = c:FindFirstChildOfClass("Humanoid")
			local tool = findAnyTool()
			if tool then
				if tool.Parent ~= c and hum2 then pcall(function() hum2:EquipTool(tool) end) end
				local remote = tool:FindFirstChildOfClass("RemoteEvent")
				if remote then pcall(function() remote:FireServer() end)
				else pcall(function() tool:Activate() end) end
			end
		end)
		local cd = tonumber(V.swingCooldown) or 0.08
		if cd < 0.03 then cd = 0.03 end   -- piso de seguranca contra spam
		task.delay(cd, function() V.hittingCooldown = false end)
	end
	V.aimbotSwing = tryHitBat
	-- alvo mais proximo, recalculado a cada frame (igual Misery)
	V.aimbotRange = tonumber(V.aimbotRange) or 250
	local function getClosestTarget()
		local myChar = LP.Character
		local root = myChar and myChar:FindFirstChild("HumanoidRootPart")
		if not root then return nil, math.huge end
		-- eu proprio em ragdoll: nao ha o que perseguir
		local myHum = myChar:FindFirstChildOfClass("Humanoid")
		if not myHum or myHum.Health <= 0 then return nil, math.huge end
		local closest, minDist = nil, math.huge
		local range = V.aimbotRange
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= LP and plr.Character then
				local tChar = plr.Character
				local tRoot = tChar:FindFirstChild("HumanoidRootPart")
				local hum = tChar:FindFirstChildOfClass("Humanoid")
				-- ignora quem esta morto, em ragdoll (PlatformStand/Physics) ou
				-- sentado num veiculo — sao alvos que nao dao hit
				local ok = tRoot and hum and hum.Health > 0
					and not hum.PlatformStand
					and not hum.Sit
					and hum:GetState() ~= Enum.HumanoidStateType.Physics
					and hum:GetState() ~= Enum.HumanoidStateType.Dead
				-- respeita o Anti Die / times, se existirem
				if ok and V.aimbotIgnore and V.aimbotIgnore[plr] then ok = false end
				if ok then
					local dist = (tRoot.Position - root.Position).Magnitude
					if dist < minDist and dist <= range then minDist = dist; closest = tRoot end
				end
			end
		end
		return closest, minDist
	end
	V.aimbotGetTarget = getClosestTarget
	RunService.RenderStepped:Connect(function()
		if not autoBatEnabled then return end
		if V.safeModeEnabled and V.safeModeIsLocked and V.safeModeIsLocked() then return end
		local char = LP.Character; if not char then return end
		local root = char:FindFirstChild("HumanoidRootPart"); if not root then return end
		local hum = char:FindFirstChildOfClass("Humanoid"); if not hum then return end
		-- morto ou em ragdoll: para de empurrar o corpo
		if hum.Health <= 0 or hum.PlatformStand
			or hum:GetState() == Enum.HumanoidStateType.Physics then
			root.AssemblyAngularVelocity = Vector3.zero
			return
		end
		-- o motor de speed nao pode brigar com o aimbot pelo controle:
		-- destroi o LinearVelocity (zerar o PlaneVelocity nao basta — ele
		-- continuaria forcando a velocidade XZ em zero)
		if V.suspendSpeedEngine then V.suspendSpeedEngine() end
		if V.aimbotMode == 1 then
			-- ===== MODO NORMAL (Envy/Opium) — com predicao, NAO equipa =====
			local target, dist = getClosestTarget()
			if not target then
				-- sem alvo: devolve o controle em vez de deixar o corpo girando
				_autoBatTarget = nil
				root.AssemblyAngularVelocity = Vector3.zero
				hum.AutoRotate = true
				return
			end
			hum.AutoRotate = false
			_autoBatTarget = target
			local targetVel = target.AssemblyLinearVelocity
			local myPos = root.Position
			local targetPos = target.Position
			local predictPos = targetPos + targetVel * 0.14
			predictPos = predictPos + target.CFrame.LookVector * 0.3
			local direction = predictPos - myPos
			local flatDir = Vector3.new(direction.X, 0, direction.Z)
			-- margem maior que 0: .Unit de um vetor quase-zero devolve NaN
			-- e o NaN se espalha pra velocidade, jogando o personagem fora do mapa
			if flatDir.Magnitude > 0.05 then flatDir = flatDir.Unit else flatDir = Vector3.zero end
			local chaseSpeed = AUTO_BAT_SPEED
			local desiredHeight = targetPos.Y + 3.7
			local yVel = (desiredHeight - myPos.Y) * 19.5 + targetVel.Y * 0.8
			if hum.FloorMaterial ~= Enum.Material.Air then yVel = math.max(yVel, 13) end
			yVel = math.clamp(yVel, -70, 110)
			local desiredVel = Vector3.new(flatDir.X * chaseSpeed, yVel, flatDir.Z * chaseSpeed)
			V.rawSetVel(root, V.rawGetVel(root):Lerp(desiredVel, 0.8))
			-- Cursed Hub: empurra o humanoide junto, senao o servidor puxa de volta
			if flatDir.Magnitude > 0.1 then hum:Move(flatDir, false) end
			-- tilt 3D: olha pra posicao prevista (incluindo o Y)
			local speed3 = targetVel.Magnitude
			local predictTime = math.clamp(speed3 / 150, 0.05, 0.2)
			local predictedPos = targetPos + targetVel * predictTime
			local toPredict = predictedPos - myPos
			if toPredict.Magnitude > 0.1 then
				local goalCF = CFrame.lookAt(myPos, predictedPos)
				local diffCF = root.CFrame:Inverse() * goalCF
				local rx, ry, rz = diffCF:ToEulerAnglesXYZ()
				rx = math.clamp(rx, -2.5, 2.5)
				ry = math.clamp(ry, -2.5, 2.5)
				rz = math.clamp(rz, -2.5, 2.5)
				root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(Vector3.new(rx*42, ry*42, rz*42))
			end
			if dist <= (V.hitDistance or 12) and autoSwingEnabled then tryHitBat() end
		else
			-- ===== MODO BYPASS (Spectrum / Anti Bat Bypass) =====
			-- reequipa a bat: se nao tem Tool na mao OU o que esta na mao
			-- nao e uma bat/slap (ex: pegou um brainrot sem querer)
			local held = char:FindFirstChildOfClass("Tool")
			local needBat = (not held)
			if held then
				local hn = held.Name:lower()
				needBat = not (hn:find("bat") or hn:find("slap"))
			end
			if needBat then
				local bat = findBat()
				if bat and bat.Parent ~= char then pcall(function() hum:EquipTool(bat) end) end
			end
			local target, targetDist = getClosestTarget()
			if not target then
				_autoBatTarget = nil
				root.AssemblyAngularVelocity = Vector3.zero
				hum.AutoRotate = true
				trySwing()
				return
			end
			hum.AutoRotate = false
			_autoBatTarget = target
			local myPos = root.Position
			local targetPos = target.Position
			local direction = targetPos - myPos
			local flatDir = Vector3.new(direction.X, 0, direction.Z)
			if flatDir.Magnitude > 0.05 then flatDir = flatDir.Unit else flatDir = Vector3.zero end
			local chaseSpeed = AUTO_BAT_SPEED
			local desiredHeight = targetPos.Y + 3.7
			local yVel = (desiredHeight - myPos.Y) * 19.5
			if hum.FloorMaterial ~= Enum.Material.Air then yVel = math.max(yVel, 13) end
			yVel = math.clamp(yVel, -70, 110)
			local desiredVel = Vector3.new(flatDir.X * chaseSpeed, yVel, flatDir.Z * chaseSpeed)
			V.rawSetVel(root, V.rawGetVel(root):Lerp(desiredVel, 0.8))
			if flatDir.Magnitude > 0.1 then hum:Move(flatDir, false) end
			local toTarget = targetPos - myPos
			if toTarget.Magnitude > 0.1 then
				local goalCF = CFrame.lookAt(myPos, targetPos)
				local diffCF = root.CFrame:Inverse() * goalCF
				local rx, ry, rz = diffCF:ToEulerAnglesXYZ()
				rx = math.clamp(rx, -2.5, 2.5)
				ry = math.clamp(ry, -2.5, 2.5)
				rz = math.clamp(rz, -2.5, 2.5)
				root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(Vector3.new(rx*42, ry*42, rz*42))
			end
			if targetDist <= 8 then trySwing() end
		end
	end)
end
LP.CharacterAdded:Connect(function(char)
	task.wait(0.5)
	setupSpeedIndicator(char)
	if medusaCounterEnabled then setupMedusa(char) end
	if batCounterEnabled then startBatCounter() end
	if unwalkEnabled then task.wait(0.5);startUnwalk() end
end)
if LP.Character then setupSpeedIndicator(LP.Character) end
local SKY_PRESETS_LIST = {"Off","Night","Aurora","Sunset","Galaxy","Cyber","Sakura","Pink Night",
    "Blood Moon","Emerald Dawn","Volcanic","Arctic","Midnight Ocean","Vaporwave","Toxic","Solar Eclipse",
    "Hellscape","Heaven","Storm","Sunrise","Deep Space","Lavender Dream","Inferno","Mint Sky"}
local SKY_PRESETS = {
    ["Off"] = {kind = "off"},
    ["Night"] = {clock=22,brightness=2,ambient={110,100,130},outAmb={120,110,140},sky={stars=4000,moon=18,sun=0,moonTex=true},atm={dens=0.45,color={120,60,180},decay={60,20,100},glare=0.5,haze=1.2}},
    ["Aurora"] = {clock=14,brightness=3,ambient={150,120,150},outAmb={160,130,150},atm={dens=0.55,color={255,80,200},decay={255,20,150},glare=2.5,haze=3},clouds={cover=0.7,dens=0.7,color={255,240,250}}},
    ["Sunset"] = {clock=17.2,brightness=2.5,ambient={170,120,100},outAmb={180,130,110},sky={stars=0,sun=25,moon=0},atm={dens=0.5,color={255,130,60},decay={255,80,30},glare=2,haze=2.5},clouds={cover=0.55,dens=0.55,color={255,200,140}}},
    ["Galaxy"] = {clock=0,brightness=1.5,ambient={70,60,100},outAmb={80,70,110},sky={stars=10000,moon=30,sun=0},atm={dens=0.15,color={40,20,80},decay={20,10,50},glare=0.3,haze=0.5}},
    ["Cyber"] = {clock=21,brightness=2.2,ambient={90,130,170},outAmb={100,140,180},sky={stars=2000,moon=12},atm={dens=0.4,color={0,200,255},decay={150,0,255},glare=2,haze=2},clouds={cover=0.4,dens=0.6,color={100,200,255}}},
    ["Sakura"] = {clock=11,brightness=3.5,ambient={170,150,160},outAmb={180,160,170},sky={sun=8},atm={dens=0.3,color={255,200,220},decay={255,170,200},glare=1,haze=1.5},clouds={cover=0.6,dens=0.4,color={255,250,252}}},
    ["Pink Night"] = {clock=23,brightness=2.2,ambient={120,60,110},outAmb={140,70,120},sky={stars=5000,moon=22,sun=0,moonTex=true},atm={dens=0.5,color={255,80,180},decay={140,30,100},glare=0.7,haze=1.4},clouds={cover=0.3,dens=0.5,color={180,90,150}}},
    ["Blood Moon"] = {clock=22.5,brightness=1.6,ambient={130,40,40},outAmb={150,50,50},sky={stars=1500,moon=28,sun=0,moonTex=true},atm={dens=0.6,color={220,30,30},decay={120,10,10},glare=1.4,haze=2},clouds={cover=0.5,dens=0.7,color={120,30,30}}},
    ["Emerald Dawn"] = {clock=6.5,brightness=2.8,ambient={130,170,140},outAmb={140,180,150},sky={sun=18,moon=0,stars=0},atm={dens=0.4,color={80,200,140},decay={40,150,90},glare=1.8,haze=2.2},clouds={cover=0.5,dens=0.5,color={200,255,220}}},
    ["Volcanic"] = {clock=19,brightness=2,ambient={180,80,40},outAmb={200,90,50},sky={stars=200,sun=12,moon=0},atm={dens=0.75,color={255,60,0},decay={180,20,0},glare=3,haze=3.5},clouds={cover=0.8,dens=0.9,color={120,40,20}}},
    ["Arctic"] = {clock=9,brightness=3.2,ambient={200,220,235},outAmb={210,230,245},sky={sun=10,stars=0,moon=0},atm={dens=0.3,color={180,220,255},decay={140,200,240},glare=1.5,haze=1.8},clouds={cover=0.7,dens=0.6,color={250,253,255}}},
    ["Midnight Ocean"] = {clock=1.5,brightness=1.7,ambient={60,90,130},outAmb={70,100,140},sky={stars=6000,moon=24,sun=0,moonTex=true},atm={dens=0.5,color={20,60,140},decay={10,30,90},glare=0.6,haze=1.5}},
    ["Vaporwave"] = {clock=19.5,brightness=2.4,ambient={180,120,200},outAmb={190,130,210},sky={stars=1000,moon=14},atm={dens=0.45,color={255,100,220},decay={120,60,255},glare=2.2,haze=2.4},clouds={cover=0.5,dens=0.55,color={200,150,255}}},
    ["Toxic"] = {clock=13,brightness=2.5,ambient={140,180,80},outAmb={150,190,90},atm={dens=0.55,color={100,220,40},decay={60,150,20},glare=1.8,haze=2.6},clouds={cover=0.65,dens=0.7,color={180,255,120}}},
    ["Solar Eclipse"] = {clock=12,brightness=0.9,ambient={50,40,60},outAmb={60,50,70},sky={stars=3500,sun=22,moon=0},atm={dens=0.5,color={255,140,40},decay={30,20,40},glare=2.8,haze=1.8}},
    ["Hellscape"] = {clock=18,brightness=1.8,ambient={200,60,30},outAmb={220,70,40},sky={stars=100,sun=30,moon=0},atm={dens=0.85,color={255,30,0},decay={120,0,0},glare=3.5,haze=4},clouds={cover=0.95,dens=0.95,color={80,20,10}}},
    ["Heaven"] = {clock=12,brightness=4,ambient={240,235,210},outAmb={250,245,220},sky={sun=16,moon=0,stars=0},atm={dens=0.25,color={255,250,220},decay={255,240,200},glare=3,haze=1.5},clouds={cover=0.85,dens=0.5,color={255,255,255}}},
    ["Storm"] = {clock=15,brightness=1.4,ambient={90,90,110},outAmb={100,100,120},sky={stars=0,sun=6,moon=0},atm={dens=0.65,color={80,90,120},decay={40,50,80},glare=0.5,haze=3},clouds={cover=0.95,dens=0.95,color={60,65,80}}},
    ["Sunrise"] = {clock=6.2,brightness=2.8,ambient={220,180,130},outAmb={230,190,140},sky={sun=22,stars=0,moon=0},atm={dens=0.45,color={255,180,100},decay={255,140,80},glare=2.4,haze=2.2},clouds={cover=0.4,dens=0.4,color={255,220,180}}},
    ["Deep Space"] = {clock=0,brightness=1,ambient={30,25,50},outAmb={40,35,60},sky={stars=15000,moon=0,sun=0},atm={dens=0.08,color={15,5,40},decay={5,0,20},glare=0.2,haze=0.3}},
    ["Lavender Dream"] = {clock=18.5,brightness=2.6,ambient={180,160,220},outAmb={190,170,230},sky={stars=800,moon=16,sun=0},atm={dens=0.4,color={200,160,255},decay={160,120,220},glare=1.4,haze=1.8},clouds={cover=0.55,dens=0.5,color={220,200,255}}},
    ["Inferno"] = {clock=17.5,brightness=2.2,ambient={220,100,40},outAmb={235,110,50},sky={sun=26,moon=0,stars=0},atm={dens=0.6,color={255,90,20},decay={200,40,0},glare=3,haze=3.2},clouds={cover=0.7,dens=0.7,color={200,80,40}}},
    ["Mint Sky"] = {clock=10,brightness=3.2,ambient={180,230,210},outAmb={190,240,220},sky={sun=10},atm={dens=0.32,color={150,255,210},decay={100,220,180},glare=1.6,haze=1.6},clouds={cover=0.55,dens=0.45,color={240,255,250}}},
}
local function _vC3(t) return Color3.fromRGB(t[1], t[2], t[3]) end
local function _v4mpClearSky()
    for _, v in ipairs(Lighting:GetChildren()) do
        if v:GetAttribute("_ToozeSky") then pcall(function() v:Destroy() end) end
    end
    local terrain = workspace:FindFirstChildOfClass("Terrain")
    if terrain then
        for _, v in ipairs(terrain:GetChildren()) do
            if v:GetAttribute("_ToozeSky") then pcall(function() v:Destroy() end) end
        end
    end
end
local function applyCustomSky(mode)
    _v4mpClearSky()
    local preset = SKY_PRESETS[mode]
    if not preset or preset.kind == "off" then
        Lighting.FogEnd = 100000; Lighting.FogStart = 0
        Lighting.FogColor = Color3.fromRGB(192,192,192)
        Lighting.Brightness = 2; Lighting.ClockTime = 14; Lighting.GlobalShadows = true
        V.skyTheme = "Off"
        return
    end
    Lighting.FogEnd = 100000; Lighting.FogStart = 0
    Lighting.FogColor = Color3.fromRGB(200,200,200)
    Lighting.GlobalShadows = true
    Lighting.ClockTime = preset.clock or 14
    Lighting.Brightness = preset.brightness or 2
    if preset.outAmb then Lighting.OutdoorAmbient = _vC3(preset.outAmb) end
    if preset.ambient then Lighting.Ambient = _vC3(preset.ambient) end
    if preset.sky then
        local sky = Instance.new("Sky")
        sky:SetAttribute("_ToozeSky", true)
        if preset.sky.stars then sky.StarCount = preset.sky.stars end
        if preset.sky.moon then sky.MoonAngularSize = preset.sky.moon end
        if preset.sky.sun then sky.SunAngularSize = preset.sky.sun end
        if preset.sky.moonTex then sky.MoonTextureId = "rbxasset://sky/moon.jpg" end
        sky.Parent = Lighting
    end
    if preset.atm then
        local atm = Instance.new("Atmosphere")
        atm:SetAttribute("_ToozeSky", true)
        atm.Density = preset.atm.dens or 0.3
        atm.Color = _vC3(preset.atm.color)
        atm.Decay = _vC3(preset.atm.decay)
        atm.Glare = preset.atm.glare or 1
        atm.Haze = preset.atm.haze or 1
        atm.Parent = Lighting
    end
    local terrain = workspace:FindFirstChildOfClass("Terrain")
    if preset.clouds and terrain then
        local clouds = Instance.new("Clouds")
        clouds:SetAttribute("_ToozeSky", true)
        clouds.Cover = preset.clouds.cover or 0.5
        clouds.Density = preset.clouds.dens or 0.5
        clouds.Color = _vC3(preset.clouds.color)
        clouds.Parent = terrain
    end
    V.skyTheme = mode
end
local function enableUltraMode()
    V.ultraModeEnabled = true
    if not antiLagEnabled then enableAntiLag() end
    pcall(function()
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 1e10
        Lighting.Brightness = 1
        Lighting.EnvironmentDiffuseScale = 0
        Lighting.EnvironmentSpecularScale = 0
        local terrain = workspace:FindFirstChildOfClass("Terrain")
        if terrain then
            terrain.WaterWaveSize = 0
            terrain.WaterWaveSpeed = 0
            terrain.WaterReflectance = 0
            terrain.WaterTransparency = 1
            terrain.Decoration = false
        end
    end)
    for _,obj in ipairs(workspace:GetDescendants()) do
        pcall(function()
            if obj:IsA("BasePart") then
                obj.Material = Enum.Material.SmoothPlastic
                obj.Reflectance = 0
                obj.CastShadow = false
            elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam")
                or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
                obj.Enabled = false
            elseif obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
                obj.Enabled = false
            elseif obj:IsA("Decal") or obj:IsA("Texture") then
                obj.Transparency = 1
            end
        end)
    end
end
local function disableUltraMode()
    V.ultraModeEnabled = false
end
local function enableRemoveAccessories()
    V.removeAccessoriesEnabledSep = true
    local function strip(char)
        for _,obj in ipairs(char:GetDescendants()) do
            if obj:IsA("Accessory") or obj:IsA("Hat") then pcall(function() obj:Destroy() end) end
        end
    end
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr.Character then strip(plr.Character) end
    end
    if V.removeAccConn then V.removeAccConn:Disconnect() end
    V.removeAccConn = workspace.DescendantAdded:Connect(function(obj)
        if V.removeAccessoriesEnabledSep and (obj:IsA("Accessory") or obj:IsA("Hat")) then
            pcall(function() obj:Destroy() end)
        end
    end)
end
local function disableRemoveAccessories()
    V.removeAccessoriesEnabledSep = false
    if V.removeAccConn then V.removeAccConn:Disconnect(); V.removeAccConn = nil end
end
-- ============================================================
-- ANTI-KICK (Vynx): segura brainrot -> desliga auto bat/left/right
-- pra nao tomar kick. SAFE MODE: bloqueia combate durante o
-- countdown do duelo / enquanto segura brainrot. Estado na tabela V.
-- ============================================================
do
	V.antiKickEnabled = false
	V.safeModeEnabled = false
	V.brainrotDetected = false
	V.antiKickThread = nil
	V.safeModeMonitorStarted = false
	local function hasBrainrotInHand()
		local char = LP.Character
		if not char then return false end
		for _, tool in ipairs(char:GetChildren()) do
			if tool:IsA("Tool") then
				local n = tool.Name:lower()
				if n:find("brainrot") or n:find("skibidi") or n:find("toilet") or n:find("animal") or n:find("carry") or n:find("grab") or n:find("steal") then
					return true
				end
			end
		end
		return false
	end
	local function stopCombat()
		if autoBatEnabled then autoBatEnabled=false; if resetAutoBatMotion then resetAutoBatMotion() end; if autoBatSetVisual then autoBatSetVisual(false) end end
		if V.batTpEnabled then V.batTpEnabled=false; if V.setBatTpVisual then V.setBatTpVisual(false) end end
		if autoLeftEnabled then autoLeftEnabled=false;if autoLeftSetVisual then autoLeftSetVisual(false) end end
		if autoRightEnabled then autoRightEnabled=false;if autoRightSetVisual then autoRightSetVisual(false) end end
	end
	-- ANTI KICK
	V.enableAntiKick = function()
		V.antiKickEnabled = true
		if V.antiKickThread then return end
		V.antiKickThread = task.spawn(function()
			while V.antiKickEnabled do
				task.wait(0.5)
				local char = LP.Character
				local found = false
				if char then
					for _, tool in ipairs(char:GetChildren()) do
						if tool:IsA("Tool") then
							local n = tool.Name:lower()
							if n:find("brainrot") or n:find("skibidi") or n:find("toilet") then found = true; break end
						end
					end
				end
				V.brainrotDetected = found
				if found then stopCombat() end
			end
		end)
	end
	V.disableAntiKick = function()
		V.antiKickEnabled = false
		V.brainrotDetected = false
	end
	-- SAFE MODE
	local function safeGetCountdownLabel()
		local ok, label = pcall(function()
			local pg = LP:FindFirstChild("PlayerGui")
			if not pg then return nil end
			local top = pg:FindFirstChild("DuelsMachineTopFrame")
			if not top then return nil end
			local inner = top:FindFirstChild("DuelsMachineTopFrame")
			if not inner then return nil end
			local timer = inner:FindFirstChild("Timer")
			if not timer then return nil end
			return timer:FindFirstChild("Label")
		end)
		return (ok and label) or nil
	end
	local function safeCountdownNumber(text)
		local t = tostring(text or ""):upper():gsub("^%s+",""):gsub("%s+$","")
		if t == "GO" or t == "START" or t == "READY" then return true end
		local n = tonumber(t)
		return n ~= nil and n >= 0 and n <= 10
	end
	local function safeInDuelCountdown()
		local label = safeGetCountdownLabel()
		return label and safeCountdownNumber(label.Text) or false
	end
	local function safeHoldingBrainrot()
		local ok, val = pcall(function() return LP:GetAttribute("Stealing") end)
		if ok and val == true then return true end
		local ok2, val2 = pcall(function() return LP:GetAttribute("AntiKick") end)
		if ok2 and val2 == true then return true end
		local char = LP.Character
		if char then
			local ok3, val3 = pcall(function() return char:GetAttribute("Stealing") end)
			if ok3 and val3 == true then return true end
		end
		if V.brainrotDetected then return true end
		if hasBrainrotInHand() then return true end
		if char then
			for _, name in ipairs({"Carrying","IsCarrying","Grabbed","Holding","StealHold","HasGrab"}) do
				local v = char:FindFirstChild(name, true)
				if v then
					if v:IsA("BoolValue") and v.Value then return true end
					if v:IsA("ObjectValue") and v.Value then return true end
					if v:IsA("StringValue") and v.Value ~= "" then return true end
				end
			end
			for _, child in ipairs(char:GetChildren()) do
				if child:IsA("Model") and child:FindFirstChildWhichIsA("BasePart", true) then
					local n = child.Name:lower()
					if n:find("brainrot") or n:find("animal") or n:find("carry") or n:find("grab") or n:find("steal") or n:find("hold") then
						return true
					end
				end
			end
		end
		return false
	end
	V.safeModeIsLocked = function()
		if not V.safeModeEnabled then return false end
		return safeInDuelCountdown() or safeHoldingBrainrot()
	end
	V.enableSafeMode = function() V.safeModeEnabled = true end
	V.disableSafeMode = function() V.safeModeEnabled = false end
	if not V.safeModeMonitorStarted then
		V.safeModeMonitorStarted = true
		RunService.Heartbeat:Connect(function()
			if V.safeModeEnabled and V.safeModeIsLocked() then stopCombat() end
		end)
	end
end
local _v4mpFontMy = nil
local _v4mpFontBad = nil
local _v4mpFontConn = nil
local _v4mpFontOrig = {}
local function _v4mpFontTouch(this)
    if this:IsA("TextLabel") or this:IsA("TextButton") or this:IsA("TextBox") then
        if this.TextStrokeTransparency ~= 1 then return false end
        local cur = tostring(this.FontFace)
        return cur == _v4mpFontBad or string.find(cur, "BuilderIcons")
    end
    return true
end
local function _v4mpFontChange(txt)
    if (txt:IsA("TextLabel") or txt:IsA("TextButton") or txt:IsA("TextBox")) and not _v4mpFontTouch(txt) then
        if not _v4mpFontOrig[txt] then _v4mpFontOrig[txt] = txt.FontFace end
        pcall(function() txt.FontFace = _v4mpFontMy end)
    end
end
local function _v4mpFontSetup()
    if _v4mpFontMy then return true end
    local ok = pcall(function()
        if isfile and writefile and getcustomasset then
            if not isfile("v4mp_starborn.ttf") then
                writefile("v4mp_starborn.ttf", game:HttpGet("https://granny.anondrop.net/uploads/6c2505542959f371/Starborn.ttf"))
            end
            writefile("v4mp_starborn.json", HS:JSONEncode({
                name = "Starborn",
                faces = {{name="Regular",weight=400,style="normal",assetId=getcustomasset("v4mp_starborn.ttf")}}
            }))
            _v4mpFontMy = Font.new(getcustomasset("v4mp_starborn.json"))
            _v4mpFontBad = tostring(Font.new("rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json"))
        end
    end)
    return ok and _v4mpFontMy ~= nil
end
local function enableCustomFont()
    if V.customFontEnabled then return end
    if not _v4mpFontSetup() then return end
    V.customFontEnabled = true
    for _, v in pairs(game:GetDescendants()) do _v4mpFontChange(v) end
    _v4mpFontConn = game.DescendantAdded:Connect(function(obj)
        if V.customFontEnabled then _v4mpFontChange(obj) end
    end)
end
local function disableCustomFont()
    V.customFontEnabled = false
    if _v4mpFontConn then _v4mpFontConn:Disconnect(); _v4mpFontConn = nil end
    for obj, origFont in pairs(_v4mpFontOrig) do
        pcall(function() if obj and obj.Parent then obj.FontFace = origFont end end)
    end
    _v4mpFontOrig = {}
end
local function enablePotatoGraphics()
    V.potatoGraphicsEnabled = true
    pcall(function()
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 1e10
        Lighting.Brightness = 0.5
        Lighting.EnvironmentDiffuseScale = 0
        Lighting.EnvironmentSpecularScale = 0
        Lighting.ExposureCompensation = 0
        for _,e in ipairs(Lighting:GetChildren()) do
            if e:IsA("PostEffect") or e:IsA("BlurEffect") or e:IsA("SunRaysEffect")
                or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then
                e.Enabled = false
            end
        end
        for _,o in ipairs(Lighting:GetChildren()) do
            if o:IsA("Sky") then o:Destroy() end
        end
        local sky = Instance.new("Sky"); sky.Name = "_ToozePotato"
        sky.CelestialBodiesShown = false
        sky.Parent = Lighting
        local terrain = workspace:FindFirstChildOfClass("Terrain")
        if terrain then
            terrain.Decoration = false
            terrain.WaterWaveSize = 0
            terrain.WaterWaveSpeed = 0
            terrain.WaterReflectance = 0
        end
    end)
    local function isCharPart(obj)
        for _,plr in ipairs(Players:GetPlayers()) do
            if plr.Character and obj:IsDescendantOf(plr.Character) then return true end
        end
        return false
    end
    local function potato(obj)
        if isCharPart(obj) then return end
        pcall(function()
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam")
                or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
                obj.Enabled = false
            elseif obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
                obj.Enabled = false
            elseif obj:IsA("BasePart") then
                obj.Material = Enum.Material.Plastic
                obj.Reflectance = 0
                obj.CastShadow = false
                obj.MaterialVariant = ""
            end
        end)
    end
    for _,obj in ipairs(workspace:GetDescendants()) do potato(obj) end
    if V.potatoConn then V.potatoConn:Disconnect() end
    V.potatoConn = workspace.DescendantAdded:Connect(function(obj)
        if V.potatoGraphicsEnabled then potato(obj) end
    end)
end
local function disablePotatoGraphics()
    V.potatoGraphicsEnabled = false
    if V.potatoConn then V.potatoConn:Disconnect(); V.potatoConn = nil end
    pcall(function()
        local s = Lighting:FindFirstChild("_ToozePotato")
        if s then s:Destroy() end
    end)
end
-- ============================================================
-- PORTED FROM MISERY DUELS (Anti Die / No Collision / Headless / Korblox / No Cam Collision / Ragdoll Countdown / Animation Pack)
-- ============================================================
-- All feature state & functions live in the V table (no extra top-level locals, to stay under the 200-local limit)
-- ANTI DIE
V.antiDieConnections = {}
V.antiDieHeartConn = nil
V.antiDieDisconnectCharacter = function()
	for _, connection in ipairs(V.antiDieConnections) do
		pcall(function() connection:Disconnect() end)
	end
	V.antiDieConnections = {}
	if V.antiDieHeartConn then
		pcall(function() V.antiDieHeartConn:Disconnect() end)
		V.antiDieHeartConn = nil
	end
end
V.antiDieProtectCharacter = function(character)
	if not character then return end
	local humanoid = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid", 5)
	if not humanoid then return end
	pcall(function()
		humanoid.MaxHealth = math.huge
		humanoid.Health = math.huge
		humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
	end)
	local stateConn = humanoid.StateChanged:Connect(function(_, newState)
		if not V.antiDieEnabled then return end
		if newState == Enum.HumanoidStateType.Dead then
			pcall(function()
				humanoid.Health = math.huge
				humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
			end)
		end
	end)
	local healthConn = humanoid:GetPropertyChangedSignal("Health"):Connect(function()
		if not V.antiDieEnabled then return end
		if humanoid.Health < humanoid.MaxHealth then
			pcall(function() humanoid.Health = math.huge end)
		end
	end)
	table.insert(V.antiDieConnections, stateConn)
	table.insert(V.antiDieConnections, healthConn)
	V.antiDieHeartConn = RunService.Heartbeat:Connect(function()
		if not V.antiDieEnabled then return end
		if humanoid and humanoid.Parent and humanoid.Health < humanoid.MaxHealth then
			pcall(function() humanoid.Health = math.huge end)
		end
	end)
end
V.setAntiDie = function(on)
	V.antiDieEnabled = on == true
	if Conns.antiDieCharAdded then pcall(function() Conns.antiDieCharAdded:Disconnect() end); Conns.antiDieCharAdded = nil end
	V.antiDieDisconnectCharacter()
	if V.antiDieEnabled then
		V.antiDieProtectCharacter(LP.Character)
		Conns.antiDieCharAdded = LP.CharacterAdded:Connect(function(character)
			if not V.antiDieEnabled then return end
			task.wait(0.1)
			V.antiDieDisconnectCharacter()
			V.antiDieProtectCharacter(character)
		end)
	else
		local character = LP.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			pcall(function()
				humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
				humanoid.MaxHealth = 100
				humanoid.Health = 100
			end)
		end
	end
end

-- NO COLLISION
V.startNoCollide = function()
	if Conns.noCollideLoop then return end
	Conns.noCollideLoop = RunService.Stepped:Connect(function()
		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= LP and player.Character then
				for _, part in ipairs(player.Character:GetDescendants()) do
					if part:IsA("BasePart") then part.CanCollide = false end
				end
			end
		end
	end)
end
V.stopNoCollide = function()
	if Conns.noCollideLoop then
		Conns.noCollideLoop:Disconnect()
		Conns.noCollideLoop = nil
	end
end

-- HEADLESS / KORBLOX (sistema do ADAPT: troca de Mesh via SpecialMesh, leve,
-- sem GetObjects/download, suporta R6 e R15). Asset IDs do proprio Adapt.
V.hiddenAccessories = {}
V.adaptHeadlessMeshId = "rbxassetid://1095708"
V.adaptKorbloxMeshId  = "rbxassetid://101851696"
V.adaptKorbloxTexId   = "rbxassetid://101851254"

V.applyHeadless = function(char)
	char = char or LP.Character
	if not char then return end
	local head = char:FindFirstChild("Head")
	if not head then return end
	pcall(function()
		head.Transparency = 1
		head.CanCollide = false
		pcall(function() head.Massless = true end)
		pcall(function() head.LocalTransparencyModifier = 1 end)
		-- remove a face (igual ao Adapt)
		local face = head:FindFirstChild("face") or head:FindFirstChild("Face")
		if face and face:IsA("Decal") then face:Destroy() end
		for _, d in ipairs(head:GetChildren()) do
			if d:IsA("Decal") then pcall(function() d.Transparency = 1 end) end
		end
		-- mesh invisivel/minuscula (metodo do Adapt)
		local old = head:FindFirstChild("AdaptHeadlessMesh")
		if old then old:Destroy() end
		local mesh = Instance.new("SpecialMesh")
		mesh.Name = "AdaptHeadlessMesh"
		mesh.MeshType = Enum.MeshType.FileMesh
		mesh.MeshId = V.adaptHeadlessMeshId
		mesh.Scale = Vector3.new(0.001, 0.001, 0.001)
		mesh.Parent = head
	end)
	-- esconde acessorios soldados na cabeca (extra util, mantido do Vexus)
	for _, v in ipairs(char:GetChildren()) do
		if v:IsA("Accessory") then
			local weldedToHead = false
			pcall(function()
				local w = v:FindFirstChildWhichIsA("Weld", true) or v:FindFirstChildWhichIsA("WeldConstraint", true) or v:FindFirstChildWhichIsA("Motor6D", true)
				if w then
					local p0, p1 = w.Part0, w.Part1
					if (p0 and p0.Name == "Head") or (p1 and p1.Name == "Head") then weldedToHead = true end
				end
				local handle = v:FindFirstChild("Handle")
				if handle and handle:FindFirstChild("AccessoryWeld") then
					local aw = handle.AccessoryWeld
					if (aw.Part0 and aw.Part0.Name == "Head") or (aw.Part1 and aw.Part1.Name == "Head") then weldedToHead = true end
				end
			end)
			if weldedToHead then
				v.Parent = nil
				table.insert(V.hiddenAccessories, v)
			end
		end
	end
end
V.stopHeadless = function(char)
	char = char or LP.Character
	if not char then return end
	pcall(function()
		local head = char:FindFirstChild("Head")
		if head then
			head.Transparency = 0
			head.CanCollide = true
			pcall(function() head.LocalTransparencyModifier = 0 end)
			local old = head:FindFirstChild("AdaptHeadlessMesh")
			if old then old:Destroy() end
		end
	end)
	for _, acc in ipairs(V.hiddenAccessories) do
		pcall(function() if acc and acc.Parent == nil then acc.Parent = char end end)
	end
	V.hiddenAccessories = {}
end

V.applyKorblox = function(char)
	char = char or LP.Character
	if not char then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum then return end
	pcall(function()
		if hum.RigType == Enum.HumanoidRigType.R6 then
			local leg = char:FindFirstChild("Right Leg")
			if not leg then return end
			local old = leg:FindFirstChild("AdaptKorbloxMesh")
			if old then old:Destroy() end
			leg.Color = Color3.fromRGB(64, 64, 64)
			local mesh = Instance.new("SpecialMesh")
			mesh.Name = "AdaptKorbloxMesh"
			mesh.MeshType = Enum.MeshType.FileMesh
			mesh.MeshId = V.adaptKorbloxMeshId
			mesh.TextureId = V.adaptKorbloxTexId
			mesh.Scale = Vector3.new(1, 1, 1)
			mesh.Parent = leg
		else
			local upper = char:FindFirstChild("RightUpperLeg")
			local lower = char:FindFirstChild("RightLowerLeg")
			local foot  = char:FindFirstChild("RightFoot")
			if not upper then return end
			local oldLeg = char:FindFirstChild("AdaptKorbloxLeg")
			if oldLeg then oldLeg:Destroy() end
			upper.Transparency = 1
			if lower then lower.Transparency = 1 end
			if foot then foot.Transparency = 1 end
			local kleg = Instance.new("Part")
			kleg.Name = "AdaptKorbloxLeg"
			kleg.Size = Vector3.new(1, 2, 1)
			kleg.Anchored = false
			kleg.CanCollide = false
			kleg.Massless = true
			kleg.Color = Color3.fromRGB(64, 64, 64)
			kleg.Parent = char
			local mesh = Instance.new("SpecialMesh")
			mesh.Name = "AdaptKorbloxMesh"
			mesh.MeshType = Enum.MeshType.FileMesh
			mesh.MeshId = V.adaptKorbloxMeshId
			mesh.TextureId = V.adaptKorbloxTexId
			mesh.Scale = Vector3.new(1, 1, 1)
			mesh.Parent = kleg
			local weld = Instance.new("Weld")
			weld.Name = "AdaptKorbloxWeld"
			weld.Part0 = upper
			weld.Part1 = kleg
			weld.C0 = CFrame.new(0, -0.8, 0)
			weld.Parent = kleg
		end
	end)
end
V.stopKorblox = function(char)
	char = char or LP.Character
	if not char then return end
	pcall(function()
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum and hum.RigType == Enum.HumanoidRigType.R6 then
			local leg = char:FindFirstChild("Right Leg")
			if leg then
				leg.Color = Color3.fromRGB(255, 255, 255)
				local old = leg:FindFirstChild("AdaptKorbloxMesh")
				if old then old:Destroy() end
			end
		else
			local upper = char:FindFirstChild("RightUpperLeg")
			local lower = char:FindFirstChild("RightLowerLeg")
			local foot  = char:FindFirstChild("RightFoot")
			if upper then upper.Transparency = 0 end
			if lower then lower.Transparency = 0 end
			if foot then foot.Transparency = 0 end
			local oldLeg = char:FindFirstChild("AdaptKorbloxLeg")
			if oldLeg then oldLeg:Destroy() end
		end
	end)
end

-- NO CAM COLLISION
V.camCollConn = nil
V.camTransparencyTracker = {}
V.applyNoCamCollision = function(on)
	pcall(function()
		if V.camCollConn then V.camCollConn:Disconnect(); V.camCollConn = nil end
		for part, originalTransp in pairs(V.camTransparencyTracker) do
			pcall(function()
				if part and part.Parent then part.LocalTransparencyModifier = originalTransp end
			end)
		end
		V.camTransparencyTracker = {}
		if not on then return end
		V.camCollConn = RunService.RenderStepped:Connect(function()
			if not V.noCamCollisionEnabled then return end
			local char = LP.Character
			if not char then return end
			local hrp = char:FindFirstChild("HumanoidRootPart")
			local cam = workspace.CurrentCamera
			if not hrp or not cam then return end
			local camPos = cam.CFrame.Position
			local charPos = hrp.Position + Vector3.new(0, 1.5, 0)
			local toChar = charPos - camPos
			if toChar.Magnitude < 0.3 then return end
			local rp = RaycastParams.new()
			rp.FilterType = Enum.RaycastFilterType.Exclude
			rp.FilterDescendantsInstances = {char}
			rp.IgnoreWater = true
			local hitThisFrame = {}
			local origin = camPos
			local remaining = toChar
			for _ = 1, 12 do
				if remaining.Magnitude < 0.2 then break end
				local res = workspace:Raycast(origin, remaining, rp)
				if not res then break end
				local part = res.Instance
				if part and part:IsA("BasePart") and not part:IsDescendantOf(char) then
					hitThisFrame[part] = true
					if V.camTransparencyTracker[part] == nil then
						V.camTransparencyTracker[part] = part.LocalTransparencyModifier
					end
					part.LocalTransparencyModifier = 1
				end
				origin = res.Position + remaining.Unit * 0.02
				remaining = charPos - origin
			end
			for part, orig in pairs(V.camTransparencyTracker) do
				if not hitThisFrame[part] then
					pcall(function()
						if part and part.Parent then part.LocalTransparencyModifier = orig end
					end)
					V.camTransparencyTracker[part] = nil
				end
			end
		end)
	end)
end

-- RAGDOLL COUNTDOWN
V.handleRagdollCountdown = function(char)
	local hum = char:WaitForChild("Humanoid", 5)
	local head = char:WaitForChild("Head", 5)
	if not hum or not head then return end
	local countdownActive = false
	local function showCountdown()
		if countdownActive or not V.ragdollCountdownEnabled then return end
		countdownActive = true
		local bb = Instance.new("BillboardGui", head)
		bb.Name = "RagdollCountdownBB"
		bb.Size = UDim2.new(0, 80, 0, 80)
		bb.StudsOffset = Vector3.new(0, 4.5, 0)
		bb.AlwaysOnTop = true
		local lbl = Instance.new("TextLabel", bb)
		lbl.Size = UDim2.new(1, 0, 1, 0)
		lbl.BackgroundTransparency = 1
		lbl.Text = "2.6"
		lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
		lbl.Font = Enum.Font.GothamBlack
		lbl.TextSize = 45
		lbl.TextStrokeTransparency = 0.5
		local timeLeft = 2.6
		while timeLeft > 0 do
			lbl.Text = string.format("%.1f", timeLeft)
			task.wait(0.1)
			timeLeft = timeLeft - 0.1
			if not bb or not bb.Parent then break end
		end
		if bb then bb:Destroy() end
		countdownActive = false
	end
	hum.StateChanged:Connect(function(_, newState)
		if newState == Enum.HumanoidStateType.Physics or newState == Enum.HumanoidStateType.Ragdoll or newState == Enum.HumanoidStateType.FallingDown then
			task.spawn(showCountdown)
		end
	end)
end

-- ANIMATION PACK
V.animationPacks = {
	["Hit Harder"] = { idle1="rbxassetid://133806214992291", idle2="rbxassetid://94970088341563", walk="rbxassetid://707897309", run="rbxassetid://707861613", jump="rbxassetid://116936326516985", fall="rbxassetid://116936326516985", climb="rbxassetid://507765644" },
	["Crazy"] = { idle1="rbxassetid://133806214992291", idle2="rbxassetid://94970088341563", walk="rbxassetid://134824450619865", run="rbxassetid://134824450619865", jump="rbxassetid://121454505477205", fall="rbxassetid://94788218468396", swimIdle="rbxassetid://121454505477205", swim="rbxassetid://121454505477205", climb="rbxassetid://121454505477205" },
	["Zombie"] = { idle1="rbxassetid://616158929", idle2="rbxassetid://616158929", walk="rbxassetid://616168032", run="rbxassetid://616163682", jump="rbxassetid://616161997", fall="rbxassetid://616157476", climb="rbxassetid://616156119" },
	["Ninja"] = { idle1="rbxassetid://656117400", idle2="rbxassetid://656117400", walk="rbxassetid://656121766", run="rbxassetid://656118852", jump="rbxassetid://656117878", fall="rbxassetid://656115606", climb="rbxassetid://656114359" },
	["Knight"] = { idle1="rbxassetid://657595757", idle2="rbxassetid://657595757", walk="rbxassetid://657552124", run="rbxassetid://657564596", jump="rbxassetid://658409194", fall="rbxassetid://657600338", climb="rbxassetid://658360781" },
	["Elder"] = { idle1="rbxassetid://845397899", idle2="rbxassetid://845397899", walk="rbxassetid://845403856", run="rbxassetid://845386501", jump="rbxassetid://845398858", fall="rbxassetid://845397673", climb="rbxassetid://845392038" },
	["Levitate"] = { idle1="rbxassetid://616006778", idle2="rbxassetid://616006778", walk="rbxassetid://616013216", run="rbxassetid://616013216", jump="rbxassetid://616008936", fall="rbxassetid://616005863", climb="rbxassetid://616003713" },
	["Astronaut"] = { idle1="rbxassetid://891621366", idle2="rbxassetid://891621366", walk="rbxassetid://891636393", run="rbxassetid://891636393", jump="rbxassetid://891627522", fall="rbxassetid://891617961", climb="rbxassetid://891609353" },
	["Pirate"] = { idle1="rbxassetid://750781874", idle2="rbxassetid://750781874", walk="rbxassetid://750785693", run="rbxassetid://750783738", jump="rbxassetid://750782230", fall="rbxassetid://750780242", climb="rbxassetid://750779899" },
	["Toy"] = { idle1="rbxassetid://782841498", idle2="rbxassetid://782841498", walk="rbxassetid://782843345", run="rbxassetid://782842708", jump="rbxassetid://782847020", fall="rbxassetid://782846423", climb="rbxassetid://782843869" },
	["Vampire"] = { idle1="rbxassetid://1083445855", idle2="rbxassetid://1083445855", walk="rbxassetid://1083473930", run="rbxassetid://1083462077", jump="rbxassetid://1083455352", fall="rbxassetid://1083443587", climb="rbxassetid://1083439238" },
	["Werewolf"] = { idle1="rbxassetid://1083195517", idle2="rbxassetid://1083195517", walk="rbxassetid://1083178339", run="rbxassetid://1083216690", jump="rbxassetid://1083218792", fall="rbxassetid://1083189019", climb="rbxassetid://1083182000" },
	["Rthro"] = { idle1="rbxassetid://2510196951", idle2="rbxassetid://2510196951", walk="rbxassetid://2510202577", run="rbxassetid://2510198475", jump="rbxassetid://2510197830", fall="rbxassetid://2510195892", climb="rbxassetid://2510192778" },
	["Stylish"] = { idle1="rbxassetid://616136790", idle2="rbxassetid://616136790", walk="rbxassetid://616146177", run="rbxassetid://616140816", jump="rbxassetid://616139451", fall="rbxassetid://616134815", climb="rbxassetid://616133594" },
}
V.animationPackList = { "OFF", "Unwalk", "Hit Harder", "Crazy", "Zombie", "Ninja", "Knight", "Elder", "Levitate", "Astronaut", "Pirate", "Toy", "Vampire", "Werewolf", "Rthro", "Stylish" }
V.animPackState = { character = nil, original = nil }
V.animGetAnimate = function(char)
	char = char or LP.Character
	return char and char:FindFirstChild("Animate") or nil
end
V.animGetAnimation = function(animate, folderName, animationName)
	local folder = animate and animate:FindFirstChild(folderName)
	return folder and folder:FindFirstChild(animationName) or nil
end
V.animSetAnimationId = function(object, id)
	if object and id then pcall(function() object.AnimationId = id end) end
end
V.animStopPlaying = function(char)
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not hum then return end
	local animator = hum:FindFirstChildOfClass("Animator")
	local tracks = animator and animator:GetPlayingAnimationTracks() or hum:GetPlayingAnimationTracks()
	for _, track in ipairs(tracks) do pcall(function() track:Stop(0) end) end
end
V.animReloadAnimate = function(animate)
	if not animate then return end
	pcall(function()
		animate.Disabled = true
		task.wait()
		animate.Disabled = false
	end)
end
V.animBackupOriginal = function(char, animate)
	if V.animPackState.character ~= char then
		V.animPackState.character = char
		V.animPackState.original = nil
	end
	if V.animPackState.original then return end
	local function id(folder, object)
		local anim = V.animGetAnimation(animate, folder, object)
		return anim and anim.AnimationId or nil
	end
	V.animPackState.original = {
		idle1 = id("idle", "Animation1"), idle2 = id("idle", "Animation2"),
		walk = id("walk", "WalkAnim"), run = id("run", "RunAnim"),
		jump = id("jump", "JumpAnim"), fall = id("fall", "FallAnim"),
		swim = id("swim", "Swim"), swimIdle = id("swimidle", "SwimIdle"),
		climb = id("climb", "ClimbAnim"),
	}
end
V.animApplyIds = function(char, animate, pack)
	if not pack then return end
	V.animStopPlaying(char)
	V.animSetAnimationId(V.animGetAnimation(animate, "idle", "Animation1"), pack.idle1)
	V.animSetAnimationId(V.animGetAnimation(animate, "idle", "Animation2"), pack.idle2)
	V.animSetAnimationId(V.animGetAnimation(animate, "walk", "WalkAnim"), pack.walk)
	V.animSetAnimationId(V.animGetAnimation(animate, "run", "RunAnim"), pack.run)
	V.animSetAnimationId(V.animGetAnimation(animate, "jump", "JumpAnim"), pack.jump)
	V.animSetAnimationId(V.animGetAnimation(animate, "fall", "FallAnim"), pack.fall)
	V.animSetAnimationId(V.animGetAnimation(animate, "swim", "Swim"), pack.swim)
	V.animSetAnimationId(V.animGetAnimation(animate, "swimidle", "SwimIdle"), pack.swimIdle)
	V.animSetAnimationId(V.animGetAnimation(animate, "climb", "ClimbAnim"), pack.climb)
	V.animReloadAnimate(animate)
end
V.animValidPack = function(name)
	for _, packName in ipairs(V.animationPackList) do
		if packName == name then return true end
	end
	return false
end
V.animGetIndex = function(name)
	for index, packName in ipairs(V.animationPackList) do
		if packName == name then return index end
	end
	return 1
end
V.applyAnimationPack = function(name)
	name = V.animValidPack(name) and name or "OFF"
	if name ~= "OFF" and name ~= "Unwalk" and unwalkEnabled then
		unwalkEnabled = false
		stopUnwalk()
		if setUnwalkVisual then setUnwalkVisual(false) end
	end
	V.animationPack = name
	local char = LP.Character
	if not char then return end
	local animate = V.animGetAnimate(char) or char:WaitForChild("Animate", 6)
	if not animate then return end
	V.animBackupOriginal(char, animate)
	if name == "Unwalk" then
		V.animApplyIds(char, animate, V.animPackState.original)
		unwalkEnabled = true
		startUnwalk()
		if setUnwalkVisual then setUnwalkVisual(true) end
		return
	end
	if name == "OFF" then
		V.animApplyIds(char, animate, V.animPackState.original)
		return
	end
	V.animApplyIds(char, animate, V.animationPacks[name])
end

-- Character re-application hooks (headless / korblox / animation / ragdoll countdown)
LP.CharacterAdded:Connect(function(char)
	V.hiddenAccessories = {}
	task.spawn(function()
		char:WaitForChild("Head", 8)
		task.wait(0.8)
		if V.headlessEnabled then V.applyHeadless(char) end
		if V.korbloxEnabled then V.applyKorblox(char) end
	end)
	task.spawn(V.handleRagdollCountdown, char)
	task.spawn(function()
		task.wait(0.65)
		V.animPackState.character = nil
		V.animPackState.original = nil
		if V.animationPack and V.animationPack ~= "OFF" then V.applyAnimationPack(V.animationPack) end
	end)
end)
if LP.Character then
	task.spawn(V.handleRagdollCountdown, LP.Character)
end
-- Periodic headless/korblox re-apply (leve: so reaplica se o marcador sumiu;
-- compativel com R6 e R15 no sistema do Adapt)
task.spawn(function()
	while task.wait(1) do
		local char = LP.Character
		if char then
			if V.headlessEnabled then
				pcall(function()
					local head = char:FindFirstChild("Head")
					if head and not head:FindFirstChild("AdaptHeadlessMesh") then
						V.applyHeadless(char)
					end
				end)
			end
			if V.korbloxEnabled then
				pcall(function()
					local hum = char:FindFirstChildOfClass("Humanoid")
					local isR6 = hum and hum.RigType == Enum.HumanoidRigType.R6
					local present
					if isR6 then
						local leg = char:FindFirstChild("Right Leg")
						present = leg and leg:FindFirstChild("AdaptKorbloxMesh")
					else
						present = char:FindFirstChild("AdaptKorbloxLeg")
					end
					if not present then V.applyKorblox(char) end
				end)
			end
		end
	end
end)


-- ============================================================
-- ANTI TP BAT (port do "Vynx Anti Anti TP")
-- Desync de replicacao (PhysicsRepRootPart falso) + anti-bat
-- (dodge circular), freeze dos inimigos e fling de contato.
-- Tudo dentro de do...end pra nao gastar locais do escopo.
-- ============================================================
V.antiTpBatEnabled = false
V.antiTpBatRange = 5
do
	local ATB = {
		enabled = false,
		character = nil,
		rootPart = nil,
		fakeRoot = nil,
		repRootOwner = nil,
		stepConn = nil,
		batConn = nil,
		freezeConn = nil,
		flingConn = nil,
		lastSafeCF = nil,
		lastCheck = 0,
		physicsDone = false,
	}
	V.ATB = ATB

	local FAKE_ROOT_NAME = "DavidDesyncRoot"
	local FAKE_ROOT_Y = -1000
	local FAKE_ROOT_VEL = Vector3.new(0, -1000, 0)

	local function isBasePart(inst)
		if not inst then return false end
		local ok, r = pcall(function() return inst:IsA("BasePart") end)
		return ok and r == true
	end

	local function findGlobalFn(...)
		local env = (getgenv and getgenv()) or _G
		for i = 1, select("#", ...) do
			local v = rawget(env, (select(i, ...)))
			if type(v) == "function" then return v end
		end
		return nil
	end

	local function setHidden(inst, prop, value)
		if not inst then return false end
		local setter = findGlobalFn("sethiddenproperty","set_hidden_property","sethiddenprop","set_hidden_prop")
		if setter then
			local ok = pcall(setter, inst, prop, value)
			if ok then return true end
		end
		return (pcall(function() inst[prop] = value end))
	end

	local function getHidden(inst, prop)
		if not inst then return false, nil end
		local getter = findGlobalFn("gethiddenproperty","get_hidden_property","gethiddenprop","get_hidden_prop")
		if getter then
			local ok, v = pcall(getter, inst, prop)
			if ok then return true, v end
		end
		local ok, v = pcall(function() return inst[prop] end)
		return ok, v
	end

	local function currentRoot(char)
		char = char or LP.Character
		if not char then return nil end
		local ok, r = pcall(function() return char:FindFirstChild("HumanoidRootPart") end)
		if ok and isBasePart(r) then return r end
		return nil
	end

	-- so roda uma vez: raio de simulacao + throttles de rede/fisica
	local function configurePhysics()
		if ATB.physicsDone then return end
		ATB.physicsDone = true
		setHidden(LP, "MaximumSimulationRadius", math.huge)
		setHidden(LP, "SimulationRadius", math.huge)
		pcall(function()
			settings().Network.InterpolationThrottling = Enum.InterpolationThrottlingMode.Disabled
		end)
		pcall(function()
			local ps = settings().Physics
			ps.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.Disabled
			ps.AllowSleep = false
		end)
		pcall(function()
			game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge)
		end)
	end

	local function fakeRootUsable()
		local f = ATB.fakeRoot
		if not isBasePart(f) then return false end
		local ok, par = pcall(function() return f.Parent end)
		return ok and par ~= nil
	end

	local function destroyFakeRoot()
		local f = ATB.fakeRoot
		ATB.fakeRoot = nil
		if f then pcall(function() f:Destroy() end) end
	end

	local function restoreRepRoot()
		local owner = ATB.repRootOwner or ATB.rootPart
		if isBasePart(owner) then setHidden(owner, "PhysicsRepRootPart", owner) end
		ATB.repRootOwner = nil
	end

	local function createFakeRoot(root)
		destroyFakeRoot()
		local f = Instance.new("Part")
		f.Name = FAKE_ROOT_NAME
		f.Size = Vector3.new(2, 2, 1)
		f.Anchored = true
		f.CanCollide = false
		f.CanTouch = false
		f.CanQuery = false
		f.Transparency = 1
		f.CFrame = CFrame.new(0, FAKE_ROOT_Y, 0)
		f.AssemblyLinearVelocity = FAKE_ROOT_VEL
		f.Parent = workspace
		local ok, pos = pcall(function() return root.Position end)
		if ok then f.CFrame = CFrame.new(pos.X, FAKE_ROOT_Y, pos.Z) end
		ATB.fakeRoot = f
		return f
	end

	local function assignFakeRep(root, fake)
		if not isBasePart(root) or not isBasePart(fake) then return false end
		setHidden(root, "PhysicsRepRootPart", root)
		ATB.repRootOwner = root
		return setHidden(root, "PhysicsRepRootPart", fake)
	end

	local function stepDesync()
		if not ATB.enabled then return end
		-- Com o aimbot ligado o desync tem que sair: o servidor veria o
		-- jogador a -1000 studs e nenhum golpe registraria.
		if autoBatEnabled then
			if ATB.fakeRoot then restoreRepRoot(); destroyFakeRoot() end
			return
		end
		local root = ATB.rootPart
		if not isBasePart(root) then
			root = currentRoot(ATB.character)
			ATB.rootPart = root
		end
		if not root then return end
		if not fakeRootUsable() then
			local f = createFakeRoot(root)
			assignFakeRep(root, f)
			return
		end
		local fake = ATB.fakeRoot
		local ok, rp, fp = pcall(function() return root.Position, fake.Position end)
		if ok and (math.abs(rp.X - fp.X) > 0.01 or math.abs(rp.Z - fp.Z) > 0.01
			or math.abs(fp.Y - FAKE_ROOT_Y) > 0.01) then
			pcall(function() fake.CFrame = CFrame.new(rp.X, FAKE_ROOT_Y, rp.Z) end)
		end
		pcall(function()
			fake.Anchored = true
			fake.AssemblyLinearVelocity = FAKE_ROOT_VEL
		end)
		local got, cur = getHidden(root, "PhysicsRepRootPart")
		if not got or cur ~= fake then setHidden(root, "PhysicsRepRootPart", fake) end
	end

	local function disc(c) if c then pcall(function() c:Disconnect() end) end end

	local function stopAll()
		disc(ATB.stepConn); ATB.stepConn = nil
		disc(ATB.batConn); ATB.batConn = nil
		disc(ATB.freezeConn); ATB.freezeConn = nil
		disc(ATB.flingConn); ATB.flingConn = nil
		ATB.lastSafeCF = nil
	end

	local function startLoops()
		stopAll()
		ATB.lastSafeCF, ATB.lastCheck = nil, 0
		ATB.stepConn = RunService.Stepped:Connect(stepDesync)

		-- anti-bat: rollback se for arremessado + dodge circular perto de bat
		ATB.batConn = RunService.Heartbeat:Connect(function()
			if not ATB.enabled then return end
			local char = LP.Character
			if not char then return end
			local hrp = char:FindFirstChild("HumanoidRootPart")
			local hum = char:FindFirstChildOfClass("Humanoid")
			if not hrp or not hum or hum.Health <= 0 then return end
			local now = tick()
			-- usa leitura crua (o spoof de speed engole a normal)
			local vel = (V.rawGetVel and V.rawGetVel(hrp)) or hrp.AssemblyLinearVelocity
			local mag = vel.Magnitude
			-- nao faz rollback do movimento do proprio aimbot/auto paths
			if autoBatEnabled or autoLeftEnabled or autoRightEnabled then
				ATB.lastSafeCF = hrp.CFrame
				ATB.lastCheck = now
				return
			end
			if mag < 70 then
				ATB.lastSafeCF = hrp.CFrame
				ATB.lastCheck = now
			elseif mag > 110 and ATB.lastSafeCF and (now - ATB.lastCheck) < 1.5 then
				hrp.CFrame = ATB.lastSafeCF * CFrame.new(0, 0.1, 0)
			end
			local range = V.antiTpBatRange or 5
			for _, plr in ipairs(Players:GetPlayers()) do
				if plr ~= LP and plr.Character then
					local eHrp = plr.Character:FindFirstChild("HumanoidRootPart")
					local tool = plr.Character:FindFirstChildWhichIsA("Tool")
					if eHrp and tool and tool.Name:lower():find("bat") then
						if (hrp.Position - eHrp.Position).Magnitude < range then
							local ang = math.rad(tick() * 500)
							hrp.CFrame = hrp.CFrame * CFrame.new(math.sin(ang) * 3, 0, math.cos(ang) * 3)
						end
					end
				end
			end
		end)

		-- freeze: zera a velocidade dos outros players
		-- (desligado enquanto o aimbot esta ativo, senao congela o alvo
		--  e empurra ele pra longe, fazendo o aimbot nunca acertar)
		ATB.freezeConn = RunService.Heartbeat:Connect(function()
			if not ATB.enabled or autoBatEnabled then return end
			for _, plr in ipairs(Players:GetPlayers()) do
				if plr ~= LP and plr.Character then
					local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
					if hrp then
						pcall(function()
							hrp.AssemblyLinearVelocity = Vector3.zero
							hrp.AssemblyAngularVelocity = Vector3.zero
						end)
					end
				end
			end
		end)

		-- fling: quem encostar leva empurrao
		ATB.flingConn = RunService.Heartbeat:Connect(function()
			if not ATB.enabled or autoBatEnabled then return end
			local char = LP.Character
			if not char then return end
			local myHrp = char:FindFirstChild("HumanoidRootPart")
			if not myHrp then return end
			local range = V.antiTpBatRange or 5
			for _, plr in ipairs(Players:GetPlayers()) do
				if plr ~= LP and plr.Character then
					local eHrp = plr.Character:FindFirstChild("HumanoidRootPart")
					if eHrp then
						local delta = eHrp.Position - myHrp.Position
						if delta.Magnitude < range and delta.Magnitude > 0.05 then
							pcall(function()
								eHrp.AssemblyLinearVelocity = delta.Unit * 150 + Vector3.new(0, 80, 0)
							end)
						end
					end
				end
			end
		end)
	end

	V.startAntiTpBat = function()
		local root = currentRoot(ATB.character)
		ATB.character = LP.Character
		ATB.rootPart = root
		if not root then
			V.antiTpBatEnabled = false
			ATB.enabled = false
			if V.setAntiTpBatVisual then V.setAntiTpBatVisual(false) end
			return false
		end
		configurePhysics()
		ATB.enabled = true
		V.antiTpBatEnabled = true
		local fake = createFakeRoot(root)
		assignFakeRep(root, fake)
		startLoops()
		return true
	end

	V.stopAntiTpBat = function()
		ATB.enabled = false
		V.antiTpBatEnabled = false
		stopAll()
		restoreRepRoot()
		destroyFakeRoot()
	end

	V.toggleAntiTpBat = function()
		if V.antiTpBatEnabled then V.stopAntiTpBat() else V.startAntiTpBat() end
		if V.setAntiTpBatVisual then V.setAntiTpBatVisual(V.antiTpBatEnabled) end
		if V.mobileButtons and V.mobileButtons["antiTpBat"] then
			V.mobileButtons["antiTpBat"].setActive(V.antiTpBatEnabled)
		end
		return V.antiTpBatEnabled
	end

	-- reaplica o desync quando o personagem respawna
	LP.CharacterAdded:Connect(function(char)
		task.defer(function()
			local old = ATB.rootPart
			ATB.character = char
			ATB.rootPart = currentRoot(char)
			if not ATB.enabled then return end
			if isBasePart(old) and old ~= ATB.rootPart then
				setHidden(old, "PhysicsRepRootPart", old)
			end
			destroyFakeRoot()
			local root = ATB.rootPart
			if not root then
				local ok, waited = pcall(function() return char:WaitForChild("HumanoidRootPart", 8) end)
				if ok and isBasePart(waited) then root = waited; ATB.rootPart = root end
			end
			if root then
				local fake = createFakeRoot(root)
				assignFakeRep(root, fake)
			end
			startLoops()
		end)
	end)
end


local function saveConfig()
	local function ks(e) return {kb=e.kb and e.kb.Name or nil,gp=e.gp and e.gp.Name or nil} end
	local cfg={
		normalSpeed=NS,carrySpeed=CS,
		dropBrainrotKey=ks(KB.DropBrainrot),autoLeftKey=ks(KB.AutoLeft),autoRightKey=ks(KB.AutoRight),
		autoBatKey=ks(KB.AutoBat),batTpKey=ks(KB.BatTp),laggerToggleKey=ks(KB.LaggerToggle),tpFloorKey=ks(KB.TPFloor),instaResetKey=ks(KB.InstaReset),guiHideKey=ks(KB.GuiHide),
		speedToggleKey=ks(KB.SpeedToggle),antiTpBatKey=ks(KB.AntiTpBat),
		grabRadius=Steal.StealRadius,stealDuration=Steal.StealDuration,
		autoGrabStopEnabled=autoGrabStopEnabled, autoGrabStopTime=autoGrabStopTime, autoGrabDelayRadius=autoGrabDelayRadius,
		antiRagdoll=antiRagdollEnabled,antiRagdollMode=V.antiRagdollMode,autoStealEnabled=Steal.AutoStealEnabled,
		infiniteJump=infJumpEnabled,medusaCounter=medusaCounterEnabled,
		batCounter=batCounterEnabled,
		carryMode=speedMode,laggerMode=laggerToggled,laggerCarryMode=laggerPhase==2,laggerSpeed=LAGGER_SPEED,laggerCarrySpeed=LAGGER_CARRY_SPEED,
		autoBat=autoBatEnabled,autoSwing=autoSwingEnabled,batTp=V.batTpEnabled,batTpMode=V.batTpMode,
		batSpeed=AUTO_BAT_SPEED,batVertSpeed=AUTO_BAT_VERT_SPEED,aimbotMode=V.aimbotMode,
		hitDistance=V.hitDistance,swingCooldown=V.swingCooldown,
		unwalkEnabled=unwalkEnabled,
		antiLag=antiLagEnabled,stretchRez=stretchRezEnabled,stretchRezAmount=V.stretchRezAmount,
		customFov=V.customFovEnabled, customFovValue=V.customFovValue,
		skyTheme=V.skyTheme, ultraMode=V.ultraModeEnabled, removeAccessories=V.removeAccessoriesEnabledSep,
		antiKick=V.antiKickEnabled, safeMode=V.safeModeEnabled,
		customFontEnabled=V.customFontEnabled, potatoGraphics=V.potatoGraphicsEnabled, autoSave=V.autoSaveEnabled,
		autoTPEnabled=autoTPEnabled,autoTPHeight=autoTPHeight,
		lockGui=_guiLocked, introEnabled=_introEnabled, introSong=V.introSong,
		hideMobileButtons=V.hideMobileButtons, lockMobileButtons=V.lockMobileButtons, mobileBtnOn=V.mobileBtnOn,
		stealBarScale=V.stealBarScale, uiScale=V.uiScale, stealBarPos=V.stealBarPos, mainPos=V.mainPos,
		mobileBtnPos=V.mobileBtnPos, mobileBtnScale=V.mobileBtnScale, mobileBtnLayout=V.MOBILE_LAYOUT_VER, mobileMoveAll=V.mobileMoveAll,
		themeAccent=V.themeAccent, sidebarArt=V.sidebarArt, nukeEnabled=V.nukeEnabled,
		xrayEnabled=V.xrayEnabled, xrayTransparency=V.xrayTransparency,
		antiTpBat=V.antiTpBatEnabled,
		playerESP=PlayerESP and PlayerESP.enabled or false, espMode=V.espMode,
		antiDie=V.antiDieEnabled, noCollide=V.noCollideEnabled, headless=V.headlessEnabled, korblox=V.korbloxEnabled,
		noCamCollision=V.noCamCollisionEnabled, ragdollCountdown=V.ragdollCountdownEnabled, animationPack=V.animationPack,
	}
	if writefile then pcall(function() writefile("Tooze.json",HS:JSONEncode(cfg)) end) end
end
task.spawn(function() while task.wait(5) do saveConfig() end end)
local setInstaGrab,setInfJumpVisual,setAntiRagVisual,setMedusaVisual,setAutoGrabStopVisual
local setUnwalkVisual,setAntiLagVisual,setAutoSwingVisual
local normalBox,carryBox,laggerBox,laggerCarryBox,radInput,durInput,autoTPHeightBox,stopTimeBox,delayRadiusBox
local function refreshSpeedModeLabel()
	if modeValLbl then modeValLbl.Text=laggerToggled and (laggerPhase==2 and "Lagger Carry" or "Lagger Normal") or (speedMode and "Carry" or "Normal") end
end
local function toggleCarryMode()
	if laggerToggled then
		laggerToggled=false
		laggerPhase=0
		speedMode=true
	else
		speedMode=not speedMode
	end
	refreshSpeedModeLabel()
end
local function toggleLaggerMode()
	if not laggerToggled then
		speedMode=false
		laggerToggled=true
		laggerPhase=2
	elseif laggerPhase==2 then
		laggerPhase=1
	else
		laggerPhase=2
	end
	refreshSpeedModeLabel()
end
local function buildGui()
	local BG    = Color3.fromRGB(8, 8, 8)
	local BG2   = Color3.fromRGB(14, 14, 14)
	local CARD  = Color3.fromRGB(20, 20, 20)
	local HOV   = Color3.fromRGB(50, 50, 50)
	-- THEME_ACCENT / trackTheme / setAccent are now defined at module scope (see top of file)
	-- Keep legacy refs working — RED/REDDIM now read current THEME at access via metatables not needed,
	-- but the old code paths use these locals. We'll update them at theme change too.
	local RED   = THEME_ACCENT
	local REDDIM= THEME_ACCENT_DIM
	local STROKE= Color3.fromRGB(80, 80, 80)
	local W     = Color3.fromRGB(250, 250, 250)
	local DIM   = Color3.fromRGB(160, 160, 160)
	local ACTIVE_TAB = Color3.fromRGB(185, 185, 185)
	local INP   = Color3.fromRGB(12, 12, 12)
	local OFF   = Color3.fromRGB(34, 34, 34)
	local old=game:GetService("CoreGui"):FindFirstChild("Tooze");if old then old:Destroy() end
	local pg=LP:FindFirstChild("PlayerGui");if pg then local o=pg:FindFirstChild("Tooze");if o then o:Destroy() end end
	local gui=Instance.new("ScreenGui")
	gui.Name="Tooze";gui.ResetOnSpawn=false;gui.DisplayOrder=10;gui.IgnoreGuiInset=true
	gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling  -- Tooze FIX: per-parent stacking so nested rows/labels aren't hidden by ancestors
	pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
	if not pcall(function() gui.Parent=game:GetService("CoreGui") end) then gui.Parent=LP:WaitForChild("PlayerGui") end
	local main=Instance.new("Frame",gui)
	main.AnchorPoint=Vector2.new(0.5, 0.5)  -- Tooze: centered like Green Duels
	main.Size=UDim2.new(0, 480, 0, 520)     -- 1:1 Vampire Hub frame size
	main.Position=UDim2.new(0.5, 0, 0.5, 0)
	main.BackgroundColor3=Color3.fromRGB(0, 0, 0);main.BorderSizePixel=0;main.ClipsDescendants=true
	Instance.new("UICorner",main).CornerRadius=UDim.new(0,30)
	-- panelBg = full unified panel background
	local panelBg = Instance.new("Frame", main)
	panelBg.Name = "PanelBg"
	panelBg.Size = UDim2.new(1, 0, 1, 0)
	panelBg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	panelBg.BorderSizePixel = 0
	panelBg.ZIndex = 1
	Instance.new("UICorner", panelBg).CornerRadius = UDim.new(0, 30)
	local panelScrim = Instance.new("Frame", main)
	panelScrim.Name = "PanelScrim";panelScrim.Size=UDim2.new(1,0,1,0);panelScrim.BackgroundTransparency=1;panelScrim.ZIndex=2
	-- escala ajustavel da UI principal (botoes +/- na aba Customization)
	local mainScale=Instance.new("UIScale",main)
	mainScale.Scale=tonumber(V.uiScale) or 1
	V.mainScaleObj=mainScale
	V.setUIScale=function(v)
		v=math.clamp(tonumber(v) or 1, 0.5, 2)
		v=math.floor(v*100+0.5)/100
		V.uiScale=v
		mainScale.Scale=v
		if V.uiScaleLbl and V.uiScaleLbl.Parent then V.uiScaleLbl.Text=string.format("%d%%", math.floor(v*100+0.5)) end
	end
	local mainStroke=Instance.new("UIStroke",main)
	mainStroke.Color=THEME_ACCENT;mainStroke.Thickness=1.2;mainStroke.Transparency=0.55
	mainStroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
	trackTheme(function(c) mainStroke.Color = c end)
	local function drag(f)
		local dn,ds,sp,di=false
		f.InputBegan:Connect(function(i)
			if _guiLocked then return end
			if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
				dn=true;ds=i.Position;sp=f.Position
				i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then dn=false end end)
			end
		end)
		f.InputChanged:Connect(function(i)
			if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then di=i end
		end)
		UIS.InputChanged:Connect(function(i)
			if i==di and dn then
				local nX=sp.X.Offset+(i.Position.X-ds.X)
				local nY=sp.Y.Offset+(i.Position.Y-ds.Y)
				f.Position=UDim2.new(sp.X.Scale,nX,sp.Y.Scale,nY)
			end
		end)
	end
	-- posicao salva do painel principal
	if type(V.mainPos)=="table" and #V.mainPos==4 then
		main.Position=UDim2.new(V.mainPos[1],V.mainPos[2],V.mainPos[3],V.mainPos[4])
	end
	V.mainFrame=main
	drag(main)
	-- auto-save da posicao (debounce de 0.5s pra nao gravar durante o arrasto)
	main:GetPropertyChangedSignal("Position"):Connect(function()
		if V._mainPosSaveT then task.cancel(V._mainPosSaveT) end
		V._mainPosSaveT=task.delay(0.5,function()
			local pp=main.Position
			V.mainPos={pp.X.Scale,pp.X.Offset,pp.Y.Scale,pp.Y.Offset}
			V._mainPosSaveT=nil
			saveConfig()
		end)
	end)
	-- =========================================================
	-- SIDEBAR area (LEFT side of unified panel) — transparent, holds image+tabs+brand
	-- =========================================================
	local SIDEBAR_W = 195
	local MENU_GAP = 0 -- clean split like Vampire Hub; no dark filtered gap between image and content
	local CONTENT_OVERLAP = 8  -- small overlap — clean separation, no text covering
	local sidebar = Instance.new("Frame", main)
	sidebar.Size = UDim2.new(0, SIDEBAR_W, 1, 0)
	sidebar.Position = UDim2.new(0, 0, 0, 0)
	sidebar.BackgroundTransparency = 1
	sidebar.BorderSizePixel = 0
	sidebar.ZIndex = 3
	sidebar.ClipsDescendants = true
	-- FIX: Sidebar gets its OWN UICorner matching main panel's radius (30).
	-- In modern Roblox, ClipsDescendants + UICorner DOES clip children to the rounded shape.
	-- The right-side rounded corners get hidden by contentArea (which overlaps from x=SIDEBAR_W-CONTENT_OVERLAP).
	Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 30)

	-- CanvasGroup: actually clips children to UICorner shape (unlike regular Frame's ClipsDescendants).
	-- Solid black background fills any sub-pixel gaps at the rounded corner edges.
	local sidebarCanvas = Instance.new("CanvasGroup", sidebar)
	sidebarCanvas.Name = "SidebarCanvas"
	sidebarCanvas.Size = UDim2.new(1, 60, 1, 0)
	sidebarCanvas.Position = UDim2.new(0, 0, 0, 0)
	sidebarCanvas.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	sidebarCanvas.BackgroundTransparency = 0
	sidebarCanvas.BorderSizePixel = 0
	sidebarCanvas.ZIndex = 1
	Instance.new("UICorner", sidebarCanvas).CornerRadius = UDim.new(0, 30)

	-- Photo inside the canvas — gets clipped to the rounded shape automatically.
	local sidebarImg = Instance.new("ImageLabel", sidebarCanvas)
	sidebarImg.Name = "SidebarArt"
	sidebarImg.Size = UDim2.new(1, 0, 1, 0)
	sidebarImg.Position = UDim2.new(0, 0, 0, 0)
	sidebarImg.BackgroundTransparency = 1
	sidebarImg.Image = "rbxassetid://" .. CURRENT_ART_ID
	sidebarImg.ScaleType = Enum.ScaleType.Crop
	sidebarImg.ImageTransparency = 0
	sidebarImg.ZIndex = 2
	-- Function to swap the sidebar art at runtime
	local function setSidebarArt(id)
		CURRENT_ART_ID = id
		sidebarImg.Image = "rbxassetid://" .. tostring(id)
		V.sidebarArt = tostring(id)
		if V.refreshMobileBg then V.refreshMobileBg(id) end
	end
	setSidebarArt_global = setSidebarArt
	-- Dark scrim on top of image — also inside canvas, gets clipped properly.
	local sidebarScrim = Instance.new("Frame", sidebarCanvas)
	sidebarScrim.Name = "SidebarScrim"
	sidebarScrim.Size = UDim2.new(1, 0, 1, 0)
	sidebarScrim.Position = UDim2.new(0, 0, 0, 0)
	sidebarScrim.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
	sidebarScrim.BackgroundTransparency = 0.92
	sidebarScrim.BorderSizePixel = 0
	sidebarScrim.ZIndex = 3
	-- (no divider line — the content panel's own rounded border + lighter bg creates the visual separation)
	local sidebarDiv = Instance.new("Frame", main); sidebarDiv.Size=UDim2.new(0,0,0,0); sidebarDiv.Visible=false; sidebarDiv.ZIndex=0
	-- FPS/Ping no rodape da sidebar
	local statsBg = Instance.new("Frame", sidebar)
	statsBg.Size = UDim2.new(0, 96, 0, 20)
	statsBg.Position = UDim2.new(0, 8, 1, -30)
	statsBg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	statsBg.BackgroundTransparency = 0
	statsBg.BorderSizePixel = 0
	statsBg.ZIndex = 4
	Instance.new("UICorner", statsBg).CornerRadius = UDim.new(0, 6)
	local statsLbl = Instance.new("TextLabel", sidebar)
	statsLbl.Size = UDim2.new(1, -16, 0, 16)
	statsLbl.Position = UDim2.new(0, 12, 1, -27)
	statsLbl.BackgroundTransparency = 1
	statsLbl.Text = "FPS: -- | PING: --"
	statsLbl.TextColor3 = THEME_ACCENT
	statsLbl.Font = Enum.Font.GothamBold
	statsLbl.TextSize = 10
	statsLbl.TextXAlignment = Enum.TextXAlignment.Left
	statsLbl.ZIndex = 5
	statsLbl.BackgroundTransparency = 1
	trackTheme(function(c) statsLbl.TextColor3 = c end)
	-- Small accent underline under FPS/PING so it is not floating by itself
	local statsLine = Instance.new("Frame", sidebar)
	statsLine.Size = UDim2.new(0, 42, 0, 1)
	statsLine.Position = UDim2.new(0, 12, 1, -9)
	statsLine.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
	statsLine.BackgroundTransparency = 0.15
	statsLine.BorderSizePixel = 0
	statsLine.ZIndex = 5
	trackTheme(function(c) statsLine.BackgroundColor3 = c end)
	-- Tab buttons container — slightly above center, moderate gap
	local tabContainer = Instance.new("Frame", sidebar)
	tabContainer.Size = UDim2.new(0, 122, 0, 310)  -- centered tab stack like the reference (4 tabs)
	tabContainer.AnchorPoint = Vector2.new(0.5, 0.5)
	tabContainer.Position = UDim2.new(0.50, 0, 0.54, 0) -- centered in the sidebar like the reference
	tabContainer.BackgroundTransparency = 1
	tabContainer.ZIndex = 4
	local tabLayout = Instance.new("UIListLayout", tabContainer)
	tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
	tabLayout.Padding = UDim.new(0, 26)
	tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	-- Brand card no topo da sidebar: avatar + @ à esquerda, nome do hub à direita
	local brandFrame = Instance.new("Frame", sidebar)
	brandFrame.Size = UDim2.new(1, -20, 0, 78)
	brandFrame.Position = UDim2.new(0, 10, 0, 10)
	brandFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
	brandFrame.BackgroundTransparency = 0.28
	brandFrame.BorderSizePixel = 0
	brandFrame.ZIndex = 5
	Instance.new("UICorner", brandFrame).CornerRadius = UDim.new(0, 12)
	local brandStroke = Instance.new("UIStroke", brandFrame)
	brandStroke.Color = Color3.fromRGB(255, 255, 255)
	brandStroke.Thickness = 1
	brandStroke.Transparency = 0.82
	-- coluna esquerda: foto de perfil + @
	local pfpHold = Instance.new("Frame", brandFrame)
	pfpHold.Size = UDim2.new(0, 46, 0, 46)
	pfpHold.Position = UDim2.new(0, 10, 0, 9)
	pfpHold.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
	pfpHold.BorderSizePixel = 0
	pfpHold.ZIndex = 6
	Instance.new("UICorner", pfpHold).CornerRadius = UDim.new(1, 0)
	local pfpImg = Instance.new("ImageLabel", pfpHold)
	pfpImg.Size = UDim2.new(1, -4, 1, -4)
	pfpImg.Position = UDim2.new(0, 2, 0, 2)
	pfpImg.BackgroundTransparency = 1
	pfpImg.ZIndex = 7
	pfpImg.Image = ""
	Instance.new("UICorner", pfpImg).CornerRadius = UDim.new(1, 0)
	local pfpStroke = Instance.new("UIStroke", pfpHold)
	pfpStroke.Color = THEME_ACCENT; pfpStroke.Thickness = 1.6; pfpStroke.Transparency = 0.1
	trackTheme(function(c) pfpStroke.Color = c end)
	task.spawn(function()
		pcall(function()
			local content = Players:GetUserThumbnailAsync(LP.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
			if content then pfpImg.Image = content end
		end)
	end)
	local pfpName = Instance.new("TextLabel", brandFrame)
	pfpName.Size = UDim2.new(0, 62, 0, 12)
	pfpName.Position = UDim2.new(0, 2, 0, 58)
	pfpName.BackgroundTransparency = 1
	pfpName.Text = "@" .. LP.Name
	pfpName.TextColor3 = Color3.fromRGB(190, 190, 190)
	pfpName.Font = Enum.Font.GothamMedium
	pfpName.TextSize = 9
	pfpName.TextTruncate = Enum.TextTruncate.AtEnd
	pfpName.TextXAlignment = Enum.TextXAlignment.Center
	pfpName.ZIndex = 7
	-- coluna direita: titulo + linha + autor (bloco centralizado na altura do avatar)
	local brandTitle = Instance.new("TextLabel", brandFrame)
	brandTitle.Size = UDim2.new(1, -74, 0, 18)
	brandTitle.Position = UDim2.new(0, 66, 0, 14)
	brandTitle.BackgroundTransparency = 1
	brandTitle.Text = "Vexus Hub"
	brandTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
	brandTitle.Font = Enum.Font.GothamBlack
	brandTitle.TextSize = 15
	brandTitle.TextXAlignment = Enum.TextXAlignment.Left
	brandTitle.ZIndex = 6
	local brandLine = Instance.new("Frame", brandFrame)
	brandLine.Size = UDim2.new(0, 44, 0, 2)
	brandLine.Position = UDim2.new(0, 66, 0, 34)
	brandLine.BackgroundColor3 = THEME_ACCENT
	brandLine.BorderSizePixel = 0
	brandLine.ZIndex = 6
	Instance.new("UICorner", brandLine).CornerRadius = UDim.new(1, 0)
	trackTheme(function(c) brandLine.BackgroundColor3 = c end)
	local brandSub = Instance.new("TextLabel", brandFrame)
	brandSub.Size = UDim2.new(1, -74, 0, 12)
	brandSub.Position = UDim2.new(0, 66, 0, 40)
	brandSub.BackgroundTransparency = 1
	brandSub.Text = "by Lkzz"
	brandSub.TextColor3 = Color3.fromRGB(150, 150, 150)
	brandSub.Font = Enum.Font.Gotham
	brandSub.TextSize = 9
	brandSub.TextXAlignment = Enum.TextXAlignment.Left
	brandSub.ZIndex = 6
	-- =========================================================
	-- Right CONTENT AREA
	-- =========================================================
	local closeBtn = Instance.new("TextButton", main)
	closeBtn.Size = UDim2.new(0, 24, 0, 24)
	closeBtn.Position = UDim2.new(1, -34, 0, 16)  -- top-right minimize box
	closeBtn.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
	closeBtn.BackgroundTransparency = 0.15
	closeBtn.BorderSizePixel = 0
	closeBtn.Text = "-";closeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
	closeBtn.Font = Enum.Font.GothamBold;closeBtn.TextSize = 18
	closeBtn.AutoButtonColor = false
	closeBtn.ZIndex = 10
	Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 7)
	local closeStroke = Instance.new("UIStroke", closeBtn)
	closeStroke.Color = THEME_ACCENT; closeStroke.Thickness = 1; closeStroke.Transparency = 0.45
	trackTheme(function(c) closeStroke.Color = c end)
	closeBtn.MouseEnter:Connect(function()
		TS:Create(closeBtn,TweenInfo.new(0.1),{TextColor3=Color3.fromRGB(0,0,0),BackgroundColor3=THEME_ACCENT_BRIGHT,BackgroundTransparency=0}):Play()
		TS:Create(closeStroke,TweenInfo.new(0.1),{Transparency=0.15}):Play()
	end)
	closeBtn.MouseLeave:Connect(function()
		TS:Create(closeBtn,TweenInfo.new(0.1),{TextColor3=Color3.fromRGB(200,200,200),BackgroundColor3=Color3.fromRGB(14,14,14),BackgroundTransparency=0.15}):Play()
		TS:Create(closeStroke,TweenInfo.new(0.1),{Transparency=0.45}):Play()
	end)
	-- FPS/Ping live update
	task.spawn(function()
		local lastFrame = tick()
		local fpsSamples = {}; local fpsAvg = 60
		RunService.RenderStepped:Connect(function()
			local now = tick(); local dt = now - lastFrame; lastFrame = now
			if dt > 0 then
				table.insert(fpsSamples, 1/dt)
				if #fpsSamples > 30 then table.remove(fpsSamples, 1) end
				local sum = 0; for _,v in ipairs(fpsSamples) do sum = sum + v end
				fpsAvg = sum / #fpsSamples
			end
		end)
		while statsLbl.Parent do
			local ping = 0
			pcall(function()
				local stat = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]
				if stat then ping = math.floor(stat:GetValue() or 0) end
			end)
			statsLbl.Text = string.format("FPS: %d | PING: %dms", math.floor(fpsAvg+0.5), ping)
			task.wait(0.5)
		end
	end)
	-- mini button (when GUI hidden)
	local miniBtn=Instance.new("TextButton",gui)
	miniBtn.Size=UDim2.new(0,118,0,30);miniBtn.Position=UDim2.new(1,-144,0,26)
	miniBtn.BackgroundColor3=Color3.fromRGB(14, 14, 14);miniBtn.BorderSizePixel=0
	miniBtn.Text="Vexus Hub";miniBtn.TextColor3=THEME_ACCENT;miniBtn.Font=Enum.Font.GothamBold;miniBtn.TextSize=12
	miniBtn.ZIndex=20;miniBtn.Visible=false
	Instance.new("UICorner",miniBtn).CornerRadius=UDim.new(0,8)
	local miniStroke=Instance.new("UIStroke",miniBtn);miniStroke.Color=THEME_ACCENT;miniStroke.Thickness=1.2;miniStroke.Transparency=0.4
	trackTheme(function(c) miniBtn.TextColor3 = c; miniStroke.Color = c end)
	drag(miniBtn)
	miniBtn.MouseEnter:Connect(function() TS:Create(miniBtn,TweenInfo.new(0.1),{BackgroundColor3=Color3.fromRGB(24, 24, 24)}):Play() end)
	miniBtn.MouseLeave:Connect(function() TS:Create(miniBtn,TweenInfo.new(0.1),{BackgroundColor3=Color3.fromRGB(14, 14, 14)}):Play() end)
	local function showGui() main.Visible=true;miniBtn.Visible=false end
	local function hideGui() main.Visible=false;miniBtn.Visible=true end
	closeBtn.MouseButton1Click:Connect(hideGui)
	miniBtn.MouseButton1Click:Connect(showGui)
	local contentArea = Instance.new("Frame", main)
	contentArea.Size = UDim2.new(1, -((SIDEBAR_W - CONTENT_OVERLAP) + MENU_GAP), 1, 0)
	contentArea.Position = UDim2.new(0, (SIDEBAR_W - CONTENT_OVERLAP) + MENU_GAP, 0, 0)  -- right panel sits over the sidebar edge like the reference
	contentArea.BackgroundColor3 = THEME_ACCENT:Lerp(Color3.fromRGB(16,16,18), 0.86)
	trackTheme(function(c)
		local bgc = c:Lerp(Color3.fromRGB(16,16,18), 0.86)
		contentArea.BackgroundColor3 = bgc
		if V.leftSquare then V.leftSquare.BackgroundColor3 = bgc end
		if V.splitCover then V.splitCover.BackgroundColor3 = bgc end
	end)
	contentArea.BorderSizePixel = 0
	contentArea.ClipsDescendants = true
	contentArea.ZIndex = 2
	Instance.new("UICorner", contentArea).CornerRadius = UDim.new(0, 26)
	-- Lado ESQUERDO reto: um retangulo do mesmo cinza ATRAS do painel (ZIndex menor),
	-- preenchendo apenas a faixa das curvas esquerdas. Nao cobre o conteudo.
	local leftSquare = Instance.new("Frame", main)
	leftSquare.Name = "ContentLeftSquare"
	leftSquare.Size = UDim2.new(0, 28, 1, 0)
	leftSquare.Position = UDim2.new(0, (SIDEBAR_W - CONTENT_OVERLAP) + MENU_GAP, 0, 0)
	leftSquare.BackgroundColor3 = contentArea.BackgroundColor3
	V.leftSquare = leftSquare
	leftSquare.BorderSizePixel = 0
	leftSquare.ZIndex = 1
	local contentSt = Instance.new("UIStroke", contentArea)
	contentSt.Color = Color3.fromRGB(70,70,70); contentSt.Thickness = 1; contentSt.Transparency = 0.18
	contentSt.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	trackTheme(function(c) contentSt.Color = c end)
	local splitCover = Instance.new("Frame", main)
	splitCover.Name = "SplitCover"
	splitCover.Size = UDim2.new(0, 4, 1, 0)
	splitCover.Position = UDim2.new(0, SIDEBAR_W - 1, 0, 0)
	splitCover.BackgroundColor3 = contentArea.BackgroundColor3
	V.splitCover = splitCover
	splitCover.BorderSizePixel = 0
	splitCover.ZIndex = 1
	local topTabs = tabContainer  -- alias for backwards compatibility with makeTopTab
	-- legacy table refs kept for any old callers
	local tabBar = Instance.new("Frame", main)
	tabBar.Visible = false; tabBar.Size = UDim2.new(0, 0, 0, 0); tabBar.BorderSizePixel = 0; tabBar.ZIndex = 1
	local sf = contentArea
	local tabButtons = {}
	local tabPages = {}
	local currentTab = nil
	local function switchTab(name)
		currentTab = name
		for tn, pg in pairs(tabPages) do pg.Visible = (tn == name) end
	end
	-- pageHolder fills the contentArea (no top tab bar — tabs are in the sidebar)
	local pageHolder = Instance.new("Frame", contentArea)
	-- Inset the scrolling pages so the scrollbar stays inside the rounded content corners.
	pageHolder.Size = UDim2.new(1, -10, 1, -18)
	pageHolder.Position = UDim2.new(0, 5, 0, 9)
	pageHolder.BackgroundTransparency = 1
	pageHolder.BorderSizePixel = 0
	pageHolder.ZIndex = 3
	local topTabsLine = Instance.new("Frame", contentArea)  -- unused but kept for legacy refs
	topTabsLine.Visible = false; topTabsLine.Size = UDim2.new(0, 0, 0, 0); topTabsLine.ZIndex = 1
	-- Three pages with their own ScrollingFrames
	local function buildPage()
		local p = Instance.new("ScrollingFrame", pageHolder)
		p.Size = UDim2.new(1, -2, 1, 0)
		p.Position = UDim2.new(0, 0, 0, 0)
		p.BackgroundTransparency = 1
		p.BorderSizePixel = 0
		p.ClipsDescendants = true
		p.ScrollBarThickness = 0
		p.ScrollBarImageColor3 = THEME_ACCENT
		p.ScrollBarImageTransparency = 0.5
		p.CanvasSize = UDim2.new(0, 0, 0, 0)
		p.AutomaticCanvasSize = Enum.AutomaticSize.Y
		p.ZIndex = 4
		trackTheme(function(c) p.ScrollBarImageColor3 = c end)
		local ll = Instance.new("UIListLayout", p); ll.SortOrder = Enum.SortOrder.LayoutOrder; ll.Padding = UDim.new(0, 7)
		local pd = Instance.new("UIPadding", p)
		pd.PaddingLeft = UDim.new(0, 8); pd.PaddingRight = UDim.new(0, 8)
		pd.PaddingTop = UDim.new(0, 8); pd.PaddingBottom = UDim.new(0, 16)
		return p
	end
	local mainPage = buildPage()
	local otherPage = buildPage(); otherPage.Visible = false
	local customPage = buildPage(); customPage.Visible = false
	local configPage = buildPage(); configPage.Visible = false
	sf = mainPage  -- default; mkSect/mkSectMerge can override
	-- Tab buttons
	local activePage = mainPage
	local function makeTopTab(label, idx, page)
		local b = Instance.new("TextButton", tabContainer)
		b.Size = UDim2.new(1, 0, 0, 43)
		b.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
		b.BackgroundTransparency = 0.46  -- transparent dark buttons over the sidebar art
		b.BorderSizePixel = 0
		b.Text = label:sub(1,1) .. label:sub(2):lower()
		b.TextColor3 = Color3.fromRGB(245, 245, 245)
		b.Font = Enum.Font.GothamBold
		b.TextSize = 12
		b.AutoButtonColor = false
		b.LayoutOrder = idx
		b.ZIndex = 5
		Instance.new("UICorner", b).CornerRadius = UDim.new(0, 14)
		local s = Instance.new("UIStroke", b)
		s.Color = Color3.fromRGB(88,88,88); s.Thickness = 1; s.Transparency = 0.35
		s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		-- gradiente sutil no fundo da aba (escurece pra baixo, da profundidade)
		local bg = Instance.new("UIGradient", b)
		bg.Rotation = 90
		bg.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(170,170,170)),
		})
		-- barrinha na cor do tema, aparece quando a aba esta ativa
		local pip = Instance.new("Frame", b)
		pip.Name = "Pip"
		pip.AnchorPoint = Vector2.new(0, 0.5)
		pip.Position = UDim2.new(0, 6, 0.5, 0)
		pip.Size = UDim2.new(0, 3, 0, 0)
		pip.BackgroundColor3 = THEME_ACCENT
		pip.BorderSizePixel = 0
		pip.ZIndex = 7
		Instance.new("UICorner", pip).CornerRadius = UDim.new(1, 0)
		trackTheme(function(c) pip.BackgroundColor3 = c end)
		b.MouseEnter:Connect(function()
			if activePage ~= page then
				TS:Create(b, TweenInfo.new(0.14), {
					BackgroundTransparency = 0.06,
					BackgroundColor3 = THEME_ACCENT_DIM,
					TextColor3 = Color3.fromRGB(255, 255, 255),
				}):Play()
				TS:Create(s, TweenInfo.new(0.14), {Color = THEME_ACCENT, Transparency = 0.1}):Play()
				TS:Create(pip, TweenInfo.new(0.14), {Size = UDim2.new(0, 3, 0, 14)}):Play()
			end
		end)
		b.MouseLeave:Connect(function()
			if activePage ~= page then
				TS:Create(b, TweenInfo.new(0.14), {
					BackgroundTransparency = 0.46,
					BackgroundColor3 = Color3.fromRGB(18, 18, 18),
					TextColor3 = Color3.fromRGB(245, 245, 245),
				}):Play()
				TS:Create(s, TweenInfo.new(0.14), {Color = Color3.fromRGB(120,120,120), Transparency = 0.5}):Play()
				TS:Create(pip, TweenInfo.new(0.14), {Size = UDim2.new(0, 3, 0, 0)}):Play()
			end
		end)
		local underline = Instance.new("Frame", b)
		underline.Size = UDim2.new(0, 0, 0, 0); underline.BackgroundTransparency = 1
		return b, underline
	end
	local btnMain,   ulMain   = makeTopTab("MAIN",   1, mainPage)
	local btnOther,  ulOther  = makeTopTab("OTHER",  2, otherPage)
	local btnCustom, ulCustom = makeTopTab("CUSTOMIZATION", 3, customPage)
	local btnConfig, ulConfig = makeTopTab("CONFIG", 4, configPage)
	local allTabs = {
		{btn=btnMain,   ul=ulMain,   page=mainPage},
		{btn=btnOther,  ul=ulOther,  page=otherPage},
		{btn=btnCustom, ul=ulCustom, page=customPage},
		{btn=btnConfig, ul=ulConfig, page=configPage},
	}
	local function setActivePage(p)
		activePage = p
		for _, t in ipairs(allTabs) do
			t.page.Visible = (t.page == p)
			local isActive = (t.page == p)
			-- aba ativa = cor do tema; inativa = escura translucida
			TS:Create(t.btn, TweenInfo.new(0.22), {
				BackgroundColor3 = isActive and THEME_ACCENT or Color3.fromRGB(18, 18, 18),
				BackgroundTransparency = isActive and 0 or 0.46,
				TextColor3 = isActive and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(245, 245, 245),
			}):Play()
			local st = t.btn:FindFirstChildWhichIsA("UIStroke")
			if st then
				TS:Create(st, TweenInfo.new(0.22), {
					Color = isActive and THEME_ACCENT_BRIGHT or Color3.fromRGB(120, 120, 120),
					Transparency = isActive and 0 or 0.5,
					Thickness = isActive and 1.6 or 1,
				}):Play()
			end
			local pip = t.btn:FindFirstChild("Pip")
			if pip then
				TS:Create(pip, TweenInfo.new(0.22), {
					Size = isActive and UDim2.new(0, 3, 0, 22) or UDim2.new(0, 3, 0, 0),
					BackgroundColor3 = isActive and Color3.fromRGB(0,0,0) or THEME_ACCENT,
				}):Play()
			end
		end
	end
	-- default active: Main
	btnMain.BackgroundColor3 = THEME_ACCENT; btnMain.BackgroundTransparency = 0; btnMain.TextColor3 = Color3.fromRGB(0, 0, 0)
	do
		local st = btnMain:FindFirstChildWhichIsA("UIStroke")
		if st then st.Color = THEME_ACCENT_BRIGHT; st.Transparency = 0; st.Thickness = 1.6 end
		local pip = btnMain:FindFirstChild("Pip")
		if pip then pip.Size = UDim2.new(0, 3, 0, 22); pip.BackgroundColor3 = Color3.fromRGB(0,0,0) end
	end
	-- When theme changes, re-run setActivePage to refresh active tab color + strokes for all tabs
	trackTheme(function(_) setActivePage(activePage) end)
	btnMain.MouseButton1Click:Connect(function()   setActivePage(mainPage)   end)
	btnOther.MouseButton1Click:Connect(function()  setActivePage(otherPage)  end)
	btnCustom.MouseButton1Click:Connect(function() setActivePage(customPage) end)
	btnConfig.MouseButton1Click:Connect(function() setActivePage(configPage) end)
	-- Map sections to pages: Speed/Combat/Steal → Main; Visual → Other; Interface → Config
	-- Vampire Hub-style sorting: MAIN = Speed/Combat/Mechanics, OTHER = Movement (TP + Auto L/R), CONFIG = Steal/Display/Interface
	local SECTION_TO_PAGE = {
		Speed = mainPage, ["Lagger Speed"] = mainPage, Keybinds = mainPage, Combat = mainPage, Mechanics = mainPage, Misc = mainPage,
		Movement = otherPage, Teleport = otherPage, ["Auto Left / Right"] = otherPage,
		Steal = configPage, ["Auto Steal"] = configPage, Config = configPage, Protection = configPage,
		Interface = customPage, Visual = customPage, Display = customPage, Background = customPage,
		["Theme Color"] = customPage,
		FOV = customPage, Avatar = customPage, ["Animation Pack"] = customPage,
		["Anti Die"] = otherPage, ["No Collision"] = otherPage, ESP = otherPage,
		["No Cam Collision"] = configPage, ["Ragdoll Countdown"] = configPage,
	}
	local tabOrder = 0
	local lo = 0
	local function LO() lo = lo + 1; return lo end
	local function mkSect(txt)
		tabOrder = tabOrder + 1
		local targetPage = SECTION_TO_PAGE[txt] or mainPage
		sf = targetPage
		tabPages[txt] = targetPage
		local f = Instance.new("Frame", targetPage)
		f.Size = UDim2.new(1, 0, 0, 26); f.BackgroundTransparency = 1
		f.BorderSizePixel = 0; f.LayoutOrder = LO(); f.ZIndex = 6
		local dot = Instance.new("Frame", f)
		dot.Size = UDim2.new(0, 3, 0, 22); dot.Position = UDim2.new(0, 5, 0.5, -11)
		dot.BackgroundColor3 = THEME_ACCENT; dot.BorderSizePixel = 0; dot.ZIndex = 8
		Instance.new("UICorner", dot).CornerRadius = UDim.new(0, 3)
		local l = Instance.new("TextLabel", f)
		l.Size = UDim2.new(1, -22, 1, 0); l.Position = UDim2.new(0, 19, 0, 0)
		l.BackgroundTransparency = 1; l.Text = txt:upper(); l.TextColor3 = THEME_ACCENT
		l.Font = Enum.Font.GothamBold; l.TextSize = 11
		l.TextXAlignment = Enum.TextXAlignment.Left
		l.ZIndex = 9
		-- linha degrade sob o titulo da secao
		local ul = Instance.new("Frame", f)
		ul.AnchorPoint = Vector2.new(0, 1)
		ul.Position = UDim2.new(0, 19, 1, -1)
		ul.Size = UDim2.new(1, -40, 0, 1)
		ul.BackgroundColor3 = THEME_ACCENT
		ul.BorderSizePixel = 0
		ul.ZIndex = 7
		local ug = Instance.new("UIGradient", ul)
		ug.Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.35),
			NumberSequenceKeypoint.new(1, 1),
		})
		trackTheme(function(c) dot.BackgroundColor3 = c; l.TextColor3 = c; ul.BackgroundColor3 = c end)
	end
	local function mkSectMerge(txt)
		local sp=Instance.new("Frame",sf);sp.Size=UDim2.new(1,0,0,6);sp.BackgroundTransparency=1;sp.BorderSizePixel=0;sp.LayoutOrder=LO();sp.ZIndex=6
		local f=Instance.new("Frame",sf);f.Size=UDim2.new(1,0,0,18);f.BackgroundTransparency=1;f.BorderSizePixel=0;f.LayoutOrder=LO();f.ZIndex=6
		local dot=Instance.new("Frame",f);dot.Size=UDim2.new(0,4,0,4);dot.Position=UDim2.new(0,8,0.5,-2)
		dot.BackgroundColor3=THEME_ACCENT;dot.BorderSizePixel=0;dot.ZIndex=8
		Instance.new("UICorner",dot).CornerRadius=UDim.new(1,0)
		local l=Instance.new("TextLabel",f);l.Size=UDim2.new(1,-22,1,0);l.Position=UDim2.new(0,18,0,0)
		l.BackgroundTransparency=1;l.Text=txt:upper();l.TextColor3=THEME_ACCENT
		l.Font=Enum.Font.GothamBold;l.TextSize=9;l.TextXAlignment=Enum.TextXAlignment.Left
		l.ZIndex=9
		trackTheme(function(c) dot.BackgroundColor3 = c end)
	end
	local function mkRow(h)
		local f=Instance.new("Frame",sf);f.Size=UDim2.new(1,-2,0,h or 40)  -- 1:1 Vampire Hub row size
		f.BackgroundColor3=Color3.fromRGB(0, 0, 0);f.BorderSizePixel=0;f.LayoutOrder=LO()  -- Vampire-style black cards
		f.ZIndex=6
		Instance.new("UICorner",f).CornerRadius=UDim.new(0,10)  -- Vampire Hub rounded card
		-- borda na cor do tema (bem discreta) em vez do cinza chapado
		local rs=Instance.new("UIStroke",f)
		rs.Color=THEME_ACCENT_DIM; rs.Thickness=1; rs.Transparency=0.55
		trackTheme(function(_) rs.Color=THEME_ACCENT_DIM end)
		-- gradiente sutil no card: sai de um tom escuro do tema pro preto
		local rg=Instance.new("UIGradient",f)
		rg.Rotation=90
		local function refreshRowGrad()
			rg.Color=ColorSequence.new({
				ColorSequenceKeypoint.new(0.00,Color3.fromRGB(255,255,255)),
				ColorSequenceKeypoint.new(1.00,Color3.fromRGB(120,120,120)),
			})
		end
		refreshRowGrad()
		-- barrinha lateral do tema que aparece no hover
		local edge=Instance.new("Frame",f)
		edge.Name="Edge"
		edge.AnchorPoint=Vector2.new(0,0.5)
		edge.Position=UDim2.new(0,0,0.5,0)
		edge.Size=UDim2.new(0,0,0,0)
		edge.BackgroundColor3=THEME_ACCENT
		edge.BorderSizePixel=0
		edge.ZIndex=7
		Instance.new("UICorner",edge).CornerRadius=UDim.new(1,0)
		trackTheme(function(c) edge.BackgroundColor3=c end)
		f.MouseEnter:Connect(function()
			TS:Create(f,TweenInfo.new(0.12),{BackgroundColor3=Color3.fromRGB(16,16,18)}):Play()
			TS:Create(rs,TweenInfo.new(0.12),{Color=THEME_ACCENT,Transparency=0.15}):Play()
			TS:Create(edge,TweenInfo.new(0.12),{Size=UDim2.new(0,3,0,22)}):Play()
		end)
		f.MouseLeave:Connect(function()
			TS:Create(f,TweenInfo.new(0.12),{BackgroundColor3=Color3.fromRGB(0,0,0)}):Play()
			TS:Create(rs,TweenInfo.new(0.12),{Color=THEME_ACCENT_DIM,Transparency=0.55}):Play()
			TS:Create(edge,TweenInfo.new(0.12),{Size=UDim2.new(0,0,0,0)}):Play()
		end)
		return f
	end
	local function mkLabel(row,txt)
		local l=Instance.new("TextLabel",row);l.Size=UDim2.new(0.58,0,1,0);l.Position=UDim2.new(0,11,0,0)
		l.BackgroundTransparency=1;l.Text=txt;l.TextColor3=W
		l.Font=Enum.Font.GothamBold;l.TextSize=11;l.TextXAlignment=Enum.TextXAlignment.Left
		l.ZIndex=8
	end
	local function mkPill(row,offset)
		local pill=Instance.new("Frame",row);pill.Size=UDim2.new(0,46,0,24)
		pill.Position=UDim2.new(1,-(offset or 56),0.5,-12)
		pill.BackgroundColor3=Color3.fromRGB(42, 42, 42);pill.BorderSizePixel=0;pill.ZIndex=3
		Instance.new("UICorner",pill).CornerRadius=UDim.new(1,0)
		local dot=Instance.new("Frame",pill);dot.Size=UDim2.new(0,18,0,18);dot.Position=UDim2.new(0,3,0.5,-9)
		dot.BackgroundColor3=Color3.fromRGB(130, 130, 130);dot.BorderSizePixel=0;dot.ZIndex=4
		Instance.new("UICorner",dot).CornerRadius=UDim.new(1,0)
		return pill,dot
	end
	local function animPill(pill,dot,on)
		TS:Create(pill,TweenInfo.new(0.18,Enum.EasingStyle.Quad),{BackgroundColor3=on and THEME_ACCENT or Color3.fromRGB(34, 34, 34)}):Play()
		TS:Create(dot,TweenInfo.new(0.18,Enum.EasingStyle.Back),{
			Position=on and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9),
			BackgroundColor3=on and Color3.fromRGB(255,255,255) or Color3.fromRGB(130, 130, 130)
		}):Play()
	end
	local _trackedPills = {}  -- {pill, dot, getState fn}
	trackTheme(function(_) for _,t in ipairs(_trackedPills) do if t.getState() then animPill(t.pill, t.dot, true) end end end)
	local function mkToggle(txt,cb)
		local row=mkRow(40);mkLabel(row,txt)
		local pill,dot=mkPill(row,56)
		local on=false
		local function sv(s) on=s;animPill(pill,dot,s) end
		table.insert(_trackedPills, {pill=pill, dot=dot, getState=function() return on end})
		local clk=Instance.new("TextButton",pill);clk.Size=UDim2.new(1,0,1,0);clk.BackgroundTransparency=1;clk.Text="";clk.ZIndex=5
		clk.Activated:Connect(function()
			on=not on;sv(on)
			pcall(cb, on)
			pcall(saveConfig)  -- AUTO-SAVE every toggle change, regardless of cb
		end)
		pill.ZIndex=3;dot.ZIndex=4
		return sv
	end
	local function mkBox(parent,default,w,xOff,cb)
		local tb=Instance.new("TextBox",parent)
		local bw = w or 74
		local xo = math.max(xOff or 78, bw + 8)
		tb.Size=UDim2.new(0,bw,0,26);tb.Position=UDim2.new(1,-xo,0.5,-13)
		tb.BackgroundColor3=Color3.fromRGB(12, 12, 12);tb.BorderSizePixel=0;tb.Text=tostring(default);tb.TextColor3=THEME_ACCENT
		tb.Font=Enum.Font.GothamBold;tb.TextSize=11;tb.ClearTextOnFocus=false;tb.ZIndex=5
		Instance.new("UICorner",tb).CornerRadius=UDim.new(0,7)
		local bs=Instance.new("UIStroke",tb);bs.Color=Color3.fromRGB(80, 80, 80);bs.Thickness=1;bs.Transparency=0.28
		tb.Focused:Connect(function() TS:Create(bs,TweenInfo.new(0.12),{Color=THEME_ACCENT,Transparency=0}):Play() end)
		tb.FocusLost:Connect(function()
			TS:Create(bs,TweenInfo.new(0.12),{Color=Color3.fromRGB(80, 80, 80),Transparency=0.28}):Play()
			if cb then local n=tonumber(tb.Text);if n then cb(n) else tb.Text=tostring(default) end end
			pcall(saveConfig)  -- AUTO-SAVE on every value commit
		end)
		return tb
	end
	local GAMEPAD_KEYS={
		[Enum.KeyCode.ButtonA]=true,[Enum.KeyCode.ButtonB]=true,[Enum.KeyCode.ButtonX]=true,[Enum.KeyCode.ButtonY]=true,
		[Enum.KeyCode.ButtonL1]=true,[Enum.KeyCode.ButtonR1]=true,[Enum.KeyCode.ButtonL2]=true,[Enum.KeyCode.ButtonR2]=true,
		[Enum.KeyCode.ButtonL3]=true,[Enum.KeyCode.ButtonR3]=true,[Enum.KeyCode.ButtonStart]=true,[Enum.KeyCode.ButtonSelect]=true,
		[Enum.KeyCode.DPadUp]=true,[Enum.KeyCode.DPadDown]=true,[Enum.KeyCode.DPadLeft]=true,[Enum.KeyCode.DPadRight]=true
	}
	local function isGamepadInput(inp) return inp and inp.UserInputType and inp.UserInputType.Name:match("^Gamepad")~=nil end
	local function isBindableInput(inp)
		if not inp or inp.KeyCode==Enum.KeyCode.Unknown then return false end
		if inp.UserInputType==Enum.UserInputType.Keyboard then return true end
		return isGamepadInput(inp) and GAMEPAD_KEYS[inp.KeyCode]==true
	end
	local function kbMatch(entry,kc) return kc and (kc==entry.kb or (entry.gp and kc==entry.gp)) end
	local function mkKB(parent,kbEntry,cb)
		local btn=Instance.new("TextButton",parent)
		btn.Size=UDim2.new(0,70,0,26);btn.Position=UDim2.new(1,-78,0.5,-13)
		btn.BackgroundColor3=Color3.fromRGB(12, 12, 12);btn.BorderSizePixel=0
		local function getLabel() return (kbEntry.gp and kbEntry.gp.Name) or (kbEntry.kb and kbEntry.kb.Name) or "None" end
		btn.Text=getLabel();btn.TextColor3=THEME_ACCENT
		btn.Font=Enum.Font.GothamBold;btn.TextSize=11;btn.ZIndex=5
		Instance.new("UICorner",btn).CornerRadius=UDim.new(0,7)
		local kbSt=Instance.new("UIStroke",btn);kbSt.Color=Color3.fromRGB(80, 80, 80);kbSt.Thickness=1;kbSt.Transparency=0.28  -- silver-grey stroke
		local li=false;local lc;local pv=btn.Text;local listenStart=0
		btn.Activated:Connect(function()
			if li then li=false;_anyKeyListening=false;if lc then lc:Disconnect();lc=nil end;btn.Text=pv;btn.TextColor3=W;return end
			pv=btn.Text;li=true;_anyKeyListening=true;listenStart=tick();btn.Text="...";btn.TextColor3=W
			lc=UIS.InputBegan:Connect(function(inp)
				if not li then return end
				if inp.KeyCode==Enum.KeyCode.Escape then li=false;_anyKeyListening=false;if lc then lc:Disconnect();lc=nil end;btn.Text=pv;btn.TextColor3=W;return end
				local isGp=isGamepadInput(inp)
				if isGp and tick()-listenStart<0.15 then return end
				if not isBindableInput(inp) then return end
				btn.Text=inp.KeyCode.Name;pv=inp.KeyCode.Name;btn.TextColor3=W
				li=false;_anyKeyListening=false;if lc then lc:Disconnect();lc=nil end
				if cb then cb(inp.KeyCode,isGp) end
			end)
		end)
		return btn
	end
	local function mkToggleKB(txt,kbEntry,onToggle,onKB)
		local row=mkRow(40);mkLabel(row,txt)  -- Tooze: 40px row
		if kbEntry then mkKB(row,kbEntry,function(k,isGp)
			if isGp then kbEntry.gp=k;kbEntry.kb=nil else kbEntry.kb=k;kbEntry.gp=nil end
			if onKB then onKB(k,isGp) end
		end) end
		local pill,dot=mkPill(row,kbEntry and 134 or 56)  -- Tooze: pill at -134 from right when keybind (58 KB width + 12 gap + 56 = 126ish, give 134 for safety)
		local on=false
		local function sv(s) on=s;animPill(pill,dot,s) end
		local clk=Instance.new("TextButton",pill);clk.Size=UDim2.new(1,0,1,0);clk.BackgroundTransparency=1;clk.Text="";clk.ZIndex=5
		clk.Activated:Connect(function() if _anyKeyListening then return end;on=not on;sv(on);if onToggle then onToggle(on) end end)
		pill.ZIndex=3;dot.ZIndex=4
		return sv
	end
	-- ============================================================
	-- STEAL BAR — layout novo (avatar + info + barra de progresso)
	-- Topo: RADIUS: ? | FPS: ? MS: ? | EXECUTOR ...   + % a direita
	-- Baixo: barra de progresso (mesmo efeito/gradiente do Vexus)
	-- ============================================================
	local pbFrame=Instance.new("Frame",gui)
	pbFrame.Size=UDim2.new(0,360,0,58);pbFrame.Position=UDim2.new(0.5,-180,1,-80)
	pbFrame.BackgroundColor3=Color3.fromRGB(10,10,10);pbFrame.BorderSizePixel=0;pbFrame.Active=true
	Instance.new("UICorner",pbFrame).CornerRadius=UDim.new(0,14)
	local pbSt=Instance.new("UIStroke",pbFrame); pbSt.Color=THEME_ACCENT; pbSt.Thickness=1.6; pbSt.Transparency=0.1
	trackTheme(function(c) pbSt.Color=c end)
	-- escala ajustavel (botoes +/- na aba Customization)
	local pbScale=Instance.new("UIScale",pbFrame)
	pbScale.Scale=tonumber(V.stealBarScale) or 1
	V.stealBarScaleObj=pbScale
	V.setStealBarScale=function(v)
		v=math.clamp(tonumber(v) or 1, 0.5, 2)
		V.stealBarScale=v
		pbScale.Scale=v
		if V.stealScaleLbl then V.stealScaleLbl.Text=string.format("%d%%", math.floor(v*100+0.5)) end
	end
	-- posicao salva
	if type(V.stealBarPos)=="table" and #V.stealBarPos==4 then
		pbFrame.Position=UDim2.new(V.stealBarPos[1],V.stealBarPos[2],V.stealBarPos[3],V.stealBarPos[4])
	end
	V.stealBarFrame=pbFrame
	drag(pbFrame)
	-- auto-save da posicao ao terminar de arrastar
	pbFrame:GetPropertyChangedSignal("Position"):Connect(function()
		if V._stealPosSaveT then task.cancel(V._stealPosSaveT) end
		V._stealPosSaveT=task.delay(0.5,function()
			local pp=pbFrame.Position
			V.stealBarPos={pp.X.Scale,pp.X.Offset,pp.Y.Scale,pp.Y.Offset}
			V._stealPosSaveT=nil
			saveConfig()
		end)
	end)
	-- avatar redondo do jogador (esquerda)
	local avatarHold=Instance.new("Frame",pbFrame)
	avatarHold.Size=UDim2.new(0,40,0,40);avatarHold.Position=UDim2.new(0,9,0.5,-20)
	avatarHold.BackgroundColor3=Color3.fromRGB(24,24,24);avatarHold.BorderSizePixel=0
	avatarHold.ZIndex=3
	Instance.new("UICorner",avatarHold).CornerRadius=UDim.new(1,0)
	local avatarImg=Instance.new("ImageLabel",avatarHold)
	avatarImg.Size=UDim2.new(1,-4,1,-4);avatarImg.Position=UDim2.new(0,2,0,2)
	avatarImg.BackgroundTransparency=1;avatarImg.ZIndex=4;avatarImg.Image=""
	Instance.new("UICorner",avatarImg).CornerRadius=UDim.new(1,0)
	local avStroke=Instance.new("UIStroke",avatarHold)
	avStroke.Color=THEME_ACCENT;avStroke.Thickness=2;avStroke.Transparency=0
	avStroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
	trackTheme(function(c) avStroke.Color=c end)
	task.spawn(function()
		pcall(function()
			local content=Players:GetUserThumbnailAsync(LP.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size150x150)
			if content then avatarImg.Image=content end
		end)
	end)
	-- linha de informacoes no topo
	progressRadLbl=Instance.new("TextLabel",pbFrame)
	progressRadLbl.Size=UDim2.new(1,-128,0,20);progressRadLbl.Position=UDim2.new(0,57,0,7)
	progressRadLbl.BackgroundTransparency=1
	progressRadLbl.Text="RADIUS: -- | FPS: -- --ms | --"
	progressRadLbl.TextColor3=Color3.fromRGB(240,240,240)
	progressRadLbl.Font=Enum.Font.GothamBold;progressRadLbl.TextSize=11
	progressRadLbl.TextXAlignment=Enum.TextXAlignment.Left
	progressRadLbl.TextTruncate=Enum.TextTruncate.AtEnd
	progressRadLbl.ZIndex=4
	-- porcentagem a direita
	progressPct=Instance.new("TextLabel",pbFrame)
	progressPct.Size=UDim2.new(0,56,0,20);progressPct.Position=UDim2.new(1,-64,0,7)
	progressPct.BackgroundTransparency=1;progressPct.Text="0%"
	progressPct.TextColor3=Color3.fromRGB(255,255,255)
	progressPct.Font=Enum.Font.GothamBlack;progressPct.TextSize=12
	progressPct.TextXAlignment=Enum.TextXAlignment.Right
	progressPct.ZIndex=4
	-- trilho da barra (parte de baixo)
	local fillRegion=Instance.new("Frame",pbFrame)
	fillRegion.Size=UDim2.new(1,-68,0,16);fillRegion.Position=UDim2.new(0,57,0,32)
	fillRegion.BackgroundColor3=Color3.fromRGB(22,22,22)
	fillRegion.BorderSizePixel=0;fillRegion.ClipsDescendants=true;fillRegion.ZIndex=2
	Instance.new("UICorner",fillRegion).CornerRadius=UDim.new(1,0)
	local fillRegGradient=Instance.new("UIGradient",fillRegion)
	fillRegGradient.Color=ColorSequence.new(Color3.fromRGB(32,32,32),Color3.fromRGB(16,16,16))
	fillRegGradient.Rotation=90
	local fillRegStroke=Instance.new("UIStroke",fillRegion)
	fillRegStroke.Color=THEME_ACCENT;fillRegStroke.Thickness=1;fillRegStroke.Transparency=0.6
	trackTheme(function(c) fillRegStroke.Color=c end)
	-- preenchimento: MESMO efeito do Vexus (cor do tema + gradiente vertical)
	progressFill=Instance.new("Frame",fillRegion)
	progressFill.Size=UDim2.new(0,0,1,0);progressFill.Position=UDim2.new(0,0,0,0)
	progressFill.BackgroundColor3=THEME_ACCENT;progressFill.BorderSizePixel=0
	progressFill.ZIndex=3
	Instance.new("UICorner",progressFill).CornerRadius=UDim.new(1,0)
	local fillGradient=Instance.new("UIGradient",progressFill)
	fillGradient.Color=ColorSequence.new(THEME_ACCENT_BRIGHT,THEME_ACCENT_DIM)
	fillGradient.Rotation=90
	trackTheme(function(c)
		progressFill.BackgroundColor3=c
		fillGradient.Color=ColorSequence.new(THEME_ACCENT_BRIGHT,THEME_ACCENT_DIM)
	end)
	-- estados da barra
	local _pbState = "IDLE"
	local function setBarState(state, distance)
		if state == _pbState and state ~= "READY" then return end
		_pbState = state
		if state == "STEALING" then
			TS:Create(fillRegion, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(22, 26, 36)}):Play()
		elseif state == "READY" then
			TS:Create(fillRegion, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 50, 80)}):Play()
			if progressPct then
				progressPct.Text = distance and (math.floor(distance).."m") or "READY"
				progressPct.TextColor3 = Color3.fromRGB(235, 235, 235)
			end
		else  -- IDLE
			TS:Create(fillRegion, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(22, 26, 36)}):Play()
			if progressPct and not isStealing then
				progressPct.Text = "0%"
				progressPct.TextColor3 = Color3.fromRGB(150, 150, 150)
			end
		end
	end
	-- scan loop: detects nearby steal prompts and switches the bar between IDLE / READY (always running, independent of auto-steal toggle)
	task.spawn(function()
		while task.wait(0.25) do
			if isStealing then
				setBarState("STEALING")
			else
				local p, d = findNearestStealPrompt()
				if p then
					setBarState("READY", d)
				else
					setBarState("IDLE")
				end
			end
		end
	end)
	-- live RADIUS | FPS | MS | EXECUTOR
	task.spawn(function()
		local lastFrame = tick()
		local fpsSamples = {}; local fpsAvg = 60
		local exeName = "UNKNOWN"
		pcall(function()
			local ok, n = pcall(function() return identifyexecutor and identifyexecutor() end)
			if ok and type(n)=="string" and #n>0 then exeName=n end
			if exeName=="UNKNOWN" then
				local ok2, n2 = pcall(function() return getexecutorname and getexecutorname() end)
				if ok2 and type(n2)=="string" and #n2>0 then exeName=n2 end
			end
		end)
		exeName = (string.split(exeName," ")[1]) or exeName
		exeName = string.upper(string.sub(exeName,1,1))..string.lower(string.sub(exeName,2))
		RunService.RenderStepped:Connect(function()
			local now = tick(); local dt = now - lastFrame; lastFrame = now
			if dt > 0 then
				table.insert(fpsSamples, 1/dt)
				if #fpsSamples > 30 then table.remove(fpsSamples, 1) end
				local sum = 0; for _,v in ipairs(fpsSamples) do sum = sum + v end
				fpsAvg = sum / #fpsSamples
			end
		end)
		while true do
			local ping = 0
			pcall(function() ping = LP:GetNetworkPing() * 1000 end)
			if progressRadLbl then
				progressRadLbl.Text = string.format("RADIUS: %.4g  |  FPS: %d  %dms  |  %s",
					Steal.StealRadius, math.floor(fpsAvg+0.5), math.floor(ping+0.5), exeName)
			end
			task.wait(0.5)
		end
	end)
	mkSect("Speed")
	do local row=mkRow(40);mkLabel(row,"Normal Speed");normalBox=mkBox(row,NS,50,48,function(v) if v>0 and v<=500 then NS=v end;saveConfig() end) end
	do local row=mkRow(40);mkLabel(row,"Carry Speed");carryBox=mkBox(row,CS,50,48,function(v) if v>0 and v<=500 then CS=v end;saveConfig() end) end
	do local row=mkRow(40);mkLabel(row,"Speed Key");mkKB(row,KB.SpeedToggle,function(k,isGp) if isGp then KB.SpeedToggle.gp=k;KB.SpeedToggle.kb=nil else KB.SpeedToggle.kb=k;KB.SpeedToggle.gp=nil end;saveConfig() end) end
	do
		local row=mkRow(40);mkLabel(row,"Mode")
		modeValLbl=Instance.new("TextLabel",row)
		modeValLbl.Size=UDim2.new(0,100,1,0);modeValLbl.Position=UDim2.new(1,-104,0,0)
		modeValLbl.BackgroundTransparency=1;modeValLbl.Text="Normal";modeValLbl.TextColor3=THEME_ACCENT
		modeValLbl.Font=Enum.Font.GothamBlack;modeValLbl.TextSize=12;modeValLbl.TextXAlignment=Enum.TextXAlignment.Right;modeValLbl.ZIndex=8
		do local _modeLbl=modeValLbl; trackTheme(function(c) if _modeLbl and _modeLbl.Parent then _modeLbl.TextColor3 = c end end) end
		local clk=Instance.new("TextButton",row);clk.Size=UDim2.new(1,0,1,0);clk.BackgroundTransparency=1;clk.Text="";clk.ZIndex=2
		clk.Activated:Connect(function() if _anyKeyListening then return end; toggleCarryMode(); saveConfig() end)
	end

	mkSect("Lagger Speed")
	do local row=mkRow(40);mkLabel(row,"Lagger Normal");laggerBox=mkBox(row,LAGGER_SPEED,50,48,function(v) if v>0 and v<=500 then LAGGER_SPEED=v end;saveConfig() end) end
	do local row=mkRow(40);mkLabel(row,"Lagger Carry");laggerCarryBox=mkBox(row,LAGGER_CARRY_SPEED,50,48,function(v) if v>0 and v<=500 then LAGGER_CARRY_SPEED=v end;saveConfig() end) end
	do local row=mkRow(40);mkLabel(row,"Lagger Key");mkKB(row,KB.LaggerToggle,function(k,isGp) if isGp then KB.LaggerToggle.gp=k;KB.LaggerToggle.kb=nil else KB.LaggerToggle.kb=k;KB.LaggerToggle.gp=nil end;saveConfig() end) end
	do
		local row=mkRow(40);mkLabel(row,"Mode")
		local laggerModeLbl=Instance.new("TextLabel",row)
		laggerModeLbl.Size=UDim2.new(0,100,1,0);laggerModeLbl.Position=UDim2.new(1,-104,0,0)
		laggerModeLbl.BackgroundTransparency=1;laggerModeLbl.Text="Normal";laggerModeLbl.TextColor3=THEME_ACCENT
		laggerModeLbl.Font=Enum.Font.GothamBlack;laggerModeLbl.TextSize=12;laggerModeLbl.TextXAlignment=Enum.TextXAlignment.Right;laggerModeLbl.ZIndex=8
		trackTheme(function(c) if laggerModeLbl and laggerModeLbl.Parent then laggerModeLbl.TextColor3 = c end end)
		local clk=Instance.new("TextButton",row);clk.Size=UDim2.new(1,0,1,0);clk.BackgroundTransparency=1;clk.Text="";clk.ZIndex=2
		clk.Activated:Connect(function() if _anyKeyListening then return end; toggleLaggerMode(); laggerModeLbl.Text=laggerToggled and "Lagger" or "Normal"; saveConfig() end)
	end

	mkSect("Combat")
	do
		local abRow=mkRow(40);mkLabel(abRow,"Auto Bat")
		mkKB(abRow,KB.AutoBat,function(k,isGp) if isGp then KB.AutoBat.gp=k;KB.AutoBat.kb=nil else KB.AutoBat.kb=k;KB.AutoBat.gp=nil end;saveConfig() end)
		local abPill,abDot=mkPill(abRow,134);abPill.ZIndex=3;abDot.ZIndex=4
		local abOn=false
		local function svAutoBat(s) abOn=s;animPill(abPill,abDot,s) end
		autoBatSetVisual=svAutoBat
		local abClk=Instance.new("TextButton",abPill);abClk.Size=UDim2.new(1,0,1,0);abClk.BackgroundTransparency=1;abClk.Text="";abClk.ZIndex=5
		abClk.Activated:Connect(function() if _anyKeyListening then return end; abOn=not abOn;svAutoBat(abOn); if abOn then queueAutoBatStart() else autoBatEnabled=false;disableAutoBat() end; saveConfig() end)
	end
	do local row=mkRow(40);mkLabel(row,"Aimbot Speed");mkBox(row,AUTO_BAT_SPEED,50,48,function(v) if v>0 and v<=200 then AUTO_BAT_SPEED=v end;saveConfig() end) end
	-- Aimbot mode selector (Sky Hub): Normal <-> Bypass
	do
		local row = mkRow(40); mkLabel(row, "Aimbot Mode")
		local modeBtn = Instance.new("TextButton", row)
		modeBtn.Size = UDim2.new(0, 118, 0, 28)
		modeBtn.Position = UDim2.new(1, -128, 0.5, -14)
		modeBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
		modeBtn.BackgroundTransparency = 0.2
		modeBtn.BorderSizePixel = 0
		modeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		modeBtn.Font = Enum.Font.GothamBold
		modeBtn.TextSize = 12
		modeBtn.AutoButtonColor = false
		modeBtn.ZIndex = 8
		Instance.new("UICorner", modeBtn).CornerRadius = UDim.new(0, 8)
		local mSt = Instance.new("UIStroke", modeBtn)
		mSt.Color = THEME_ACCENT; mSt.Thickness = 1; mSt.Transparency = 0.35
		trackTheme(function(c) mSt.Color = c end)
		V.setAimbotModeVisual = function()
			modeBtn.Text = (V.aimbotMode == 2) and "Bypass" or "Normal"
		end
		V.setAimbotModeVisual()
		modeBtn.MouseButton1Click:Connect(function()
			if _anyKeyListening then return end
			V.aimbotMode = (V.aimbotMode == 2) and 1 or 2
			V.setAimbotModeVisual()
			-- reinicia o movimento pra nao herdar velocidade do modo anterior
			if resetAutoBatMotion then resetAutoBatMotion() end
			saveConfig()
		end)
	end
	do
		local row=mkRow(40);mkLabel(row,"Prediction")
		local active=Instance.new("TextLabel",row);active.Size=UDim2.new(0,90,1,0);active.Position=UDim2.new(1,-98,0,0);active.BackgroundTransparency=1
		active.Text="ACTIVE";active.TextColor3=THEME_ACCENT;active.Font=Enum.Font.GothamBlack;active.TextSize=12;active.TextXAlignment=Enum.TextXAlignment.Right;active.ZIndex=8
		trackTheme(function(c) active.TextColor3=c end)
	end
	mkToggle("Disable at 180+",function(_) saveConfig() end)
	do setBatCounterVisual=mkToggle("Bat Counter",function(on) batCounterEnabled=on;if on then startBatCounter() else stopBatCounter() end;saveConfig() end) end
	setAutoSwingVisual=mkToggle("Auto Swing",function(on) autoSwingEnabled=on;saveConfig() end)
	if setAutoSwingVisual then setAutoSwingVisual(autoSwingEnabled) end
	do V.setBatTpVisual = mkToggleKB("Bat TP", KB.BatTp,
		function(on) V.batTpEnabled = on; if on then V.startBatTp() else V.stopBatTp() end; saveConfig() end,
		function(k,isGp) if isGp then KB.BatTp.gp=k;KB.BatTp.kb=nil else KB.BatTp.kb=k;KB.BatTp.gp=nil end;saveConfig() end)
	end
	if V.setBatTpVisual then V.setBatTpVisual(V.batTpEnabled) end
	-- Bat TP mode selector: V1 (Vexus/Sky vision bat) <-> V2 (CZ BAT TP)
	do
		local row = mkRow(40); mkLabel(row, "Bat TP Mode")
		local modeBtn = Instance.new("TextButton", row)
		modeBtn.Size = UDim2.new(0, 118, 0, 28)
		modeBtn.Position = UDim2.new(1, -128, 0.5, -14)
		modeBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
		modeBtn.BackgroundTransparency = 0.2
		modeBtn.BorderSizePixel = 0
		modeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		modeBtn.Font = Enum.Font.GothamBold
		modeBtn.TextSize = 12
		modeBtn.AutoButtonColor = false
		modeBtn.ZIndex = 6
		Instance.new("UICorner", modeBtn).CornerRadius = UDim.new(0, 8)
		V.setBatTpModeVisual = function()
			if modeBtn and modeBtn.Parent then
				modeBtn.Text = (V.batTpMode == 2) and "V2" or "V1"
			end
		end
		V.setBatTpModeVisual()
		modeBtn.MouseButton1Click:Connect(function()
			if _anyKeyListening then return end
			V.batTpMode = (V.batTpMode == 2) and 1 or 2
			V.setBatTpModeVisual()
			saveConfig()
		end)
	end

	mkSect("Mechanics")
	setInfJumpVisual=mkToggle("Infinite Jump",function(on) infJumpEnabled=on; if V.refreshInfJump then V.refreshInfJump() end; saveConfig() end)
	-- Anti Ragdoll mode selector (Splatter / No Splatter) — Vynx
	do
		local row=mkRow(40);mkLabel(row,"Anti Rag Mode")
		local modeBtn=Instance.new("TextButton",row)
		modeBtn.Size=UDim2.new(0,118,0,28);modeBtn.Position=UDim2.new(1,-128,0.5,-14)
		modeBtn.BackgroundColor3=Color3.fromRGB(20,20,22);modeBtn.BackgroundTransparency=0.2;modeBtn.BorderSizePixel=0
		modeBtn.TextColor3=Color3.fromRGB(255,255,255);modeBtn.Font=Enum.Font.GothamBold;modeBtn.TextSize=12
		modeBtn.AutoButtonColor=false;modeBtn.ZIndex=6
		Instance.new("UICorner",modeBtn).CornerRadius=UDim.new(0,8)
		V.setAntiRagModeVisual=function() if modeBtn and modeBtn.Parent then modeBtn.Text=(V.antiRagdollMode=="No Splatter") and "No Splatter" or "Splatter" end end
		V.setAntiRagModeVisual()
		modeBtn.MouseButton1Click:Connect(function()
			if _anyKeyListening then return end
			V.antiRagdollMode=(V.antiRagdollMode=="No Splatter") and "Splatter" or "No Splatter"
			V.setAntiRagModeVisual()
			if antiRagdollEnabled and Conns.antiRag then stopAntiRagdoll();startAntiRagdoll() end
			saveConfig()
		end)
	end
	setAntiRagVisual=mkToggle("Anti Ragdoll",function(on) antiRagdollEnabled=on;if on then startAntiRagdoll() else stopAntiRagdoll() end;saveConfig() end)
	setStretchRezVisual=mkToggle("Stretch Rez",function(on) if on then enableStretchRez() else disableStretchRez() end;saveConfig() end)
	-- intensidade do Stretch Rez (-/+)
	do
		local row=mkRow(42);mkLabel(row,"Stretch Intensity")
		local minus=Instance.new("TextButton",row)
		minus.Size=UDim2.new(0,34,0,28);minus.Position=UDim2.new(1,-140,0.5,-14)
		minus.BackgroundColor3=Color3.fromRGB(12,12,12);minus.BorderSizePixel=0
		minus.Text="-";minus.TextColor3=THEME_ACCENT;minus.Font=Enum.Font.GothamBold
		minus.TextSize=16;minus.AutoButtonColor=false;minus.ZIndex=8
		Instance.new("UICorner",minus).CornerRadius=UDim.new(0,8)
		local val=Instance.new("TextLabel",row)
		val.Size=UDim2.new(0,58,1,0);val.Position=UDim2.new(1,-102,0,0)
		val.BackgroundTransparency=1
		val.TextColor3=Color3.fromRGB(255,255,255);val.Font=Enum.Font.GothamBold;val.TextSize=12
		val.TextXAlignment=Enum.TextXAlignment.Center;val.ZIndex=8
		V.stretchAmtLbl=val
		local plus=Instance.new("TextButton",row)
		plus.Size=UDim2.new(0,34,0,28);plus.Position=UDim2.new(1,-42,0.5,-14)
		plus.BackgroundColor3=Color3.fromRGB(12,12,12);plus.BorderSizePixel=0
		plus.Text="+";plus.TextColor3=THEME_ACCENT;plus.Font=Enum.Font.GothamBold
		plus.TextSize=16;plus.AutoButtonColor=false;plus.ZIndex=8
		Instance.new("UICorner",plus).CornerRadius=UDim.new(0,8)
		trackTheme(function(c) minus.TextColor3=c;plus.TextColor3=c end)
		if V.setStretchRezAmount then V.setStretchRezAmount(V.stretchRezAmount) end
		local function step(d)
			if _anyKeyListening then return end
			if V.setStretchRezAmount then V.setStretchRezAmount((tonumber(V.stretchRezAmount) or 0.8)+d) end
			saveConfig()
		end
		-- "+" = mais esticado (diminui o fator), "-" = menos esticado
		minus.Activated:Connect(function() step(0.05) end)
		plus.Activated:Connect(function() step(-0.05) end)
	end
	setAntiLagVisual=mkToggle("Anti Lag",function(on) if on then enableAntiLag() else disableAntiLag() end;saveConfig() end)
	-- ===== NUKE OPTIMIZER (toggle simples) =====
	do V.setNukeVisual = mkToggle("Nuke Optimizer", function(on)
		V.nukeEnabled = on
		if on then V.enableNuke() else V.disableNuke() end
		saveConfig()
	end) end
	-- ===== X-RAY BRAINROT (toggle proprio + flecha com a transparencia) =====
	do
		local row = mkRow(40)
		mkLabel(row, "X-Ray Brainrot")
		local pill, dot = mkPill(row, 56)
		local on = false
		local function sv(st2) on = st2; animPill(pill, dot, st2) end
		table.insert(_trackedPills, {pill=pill, dot=dot, getState=function() return on end})
		local clk = Instance.new("TextButton", pill)
		clk.Size = UDim2.new(1,0,1,0); clk.BackgroundTransparency = 1; clk.Text = ""; clk.ZIndex = 5
		clk.Activated:Connect(function()
			if _anyKeyListening then return end
			on = not on; sv(on)
			V.xrayEnabled = on
			if on then V.xrayStart() else V.xrayStop() end
			saveConfig()
		end)
		pill.ZIndex = 3; dot.ZIndex = 4
		V.setXrayVisual = function(v) on = v == true; sv(on) end
		-- flecha a esquerda do pill
		local arrow = Instance.new("TextButton", row)
		arrow.Size = UDim2.new(0, 26, 0, 26)
		arrow.Position = UDim2.new(1, -88, 0.5, -13)
		arrow.BackgroundColor3 = Color3.fromRGB(12,12,12)
		arrow.BorderSizePixel = 0
		arrow.Text = "v"
		arrow.TextColor3 = THEME_ACCENT
		arrow.Font = Enum.Font.GothamBold
		arrow.TextSize = 13
		arrow.AutoButtonColor = false
		arrow.ZIndex = 8
		Instance.new("UICorner", arrow).CornerRadius = UDim.new(0, 7)
		local aSt = Instance.new("UIStroke", arrow)
		aSt.Color = THEME_ACCENT_DIM; aSt.Thickness = 1; aSt.Transparency = 0.4
		trackTheme(function(c) arrow.TextColor3 = c; aSt.Color = THEME_ACCENT_DIM end)
		local panel = Instance.new("Frame", sf)
		panel.Size = UDim2.new(1, -2, 0, 0)
		panel.BackgroundColor3 = Color3.fromRGB(8,8,8)
		panel.BorderSizePixel = 0
		panel.ClipsDescendants = true
		panel.LayoutOrder = LO()
		panel.ZIndex = 6
		panel.Visible = false
		Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 10)
		local pSt = Instance.new("UIStroke", panel)
		pSt.Color = THEME_ACCENT_DIM; pSt.Thickness = 1; pSt.Transparency = 0.5
		trackTheme(function(_) pSt.Color = THEME_ACCENT_DIM end)
		local plist = Instance.new("UIListLayout", panel)
		plist.SortOrder = Enum.SortOrder.LayoutOrder
		plist.Padding = UDim.new(0, 2)
		local ppad = Instance.new("UIPadding", panel)
		ppad.PaddingTop = UDim.new(0, 6); ppad.PaddingBottom = UDim.new(0, 6)
		ppad.PaddingLeft = UDim.new(0, 8); ppad.PaddingRight = UDim.new(0, 8)
		-- unico item: intensidade da transparencia (-/+)
		local item2 = Instance.new("Frame", panel)
		item2.Size = UDim2.new(1, 0, 0, 30)
		item2.BackgroundColor3 = Color3.fromRGB(0,0,0)
		item2.BorderSizePixel = 0; item2.LayoutOrder = 1; item2.ZIndex = 7
		Instance.new("UICorner", item2).CornerRadius = UDim.new(0, 8)
		local nm2 = Instance.new("TextLabel", item2)
		nm2.Size = UDim2.new(1, -120, 1, 0); nm2.Position = UDim2.new(0, 10, 0, 0)
		nm2.BackgroundTransparency = 1
		nm2.Text = "Transparency"
		nm2.TextColor3 = Color3.fromRGB(235,235,240)
		nm2.Font = Enum.Font.GothamBold; nm2.TextSize = 11
		nm2.TextXAlignment = Enum.TextXAlignment.Left
		nm2.ZIndex = 8
		local xminus = Instance.new("TextButton", item2)
		xminus.Size = UDim2.new(0, 24, 0, 22); xminus.Position = UDim2.new(1, -110, 0.5, -11)
		xminus.BackgroundColor3 = Color3.fromRGB(14,14,14); xminus.BorderSizePixel = 0
		xminus.Text = "-"; xminus.TextColor3 = THEME_ACCENT; xminus.Font = Enum.Font.GothamBold
		xminus.TextSize = 14; xminus.AutoButtonColor = false; xminus.ZIndex = 9
		Instance.new("UICorner", xminus).CornerRadius = UDim.new(0, 6)
		local xval = Instance.new("TextLabel", item2)
		xval.Size = UDim2.new(0, 46, 1, 0); xval.Position = UDim2.new(1, -84, 0, 0)
		xval.BackgroundTransparency = 1
		xval.TextColor3 = Color3.fromRGB(255,255,255)
		xval.Font = Enum.Font.GothamBold; xval.TextSize = 11
		xval.TextXAlignment = Enum.TextXAlignment.Center; xval.ZIndex = 9
		V.xrayLbl = xval
		local xplus = Instance.new("TextButton", item2)
		xplus.Size = UDim2.new(0, 24, 0, 22); xplus.Position = UDim2.new(1, -34, 0.5, -11)
		xplus.BackgroundColor3 = Color3.fromRGB(14,14,14); xplus.BorderSizePixel = 0
		xplus.Text = "+"; xplus.TextColor3 = THEME_ACCENT; xplus.Font = Enum.Font.GothamBold
		xplus.TextSize = 14; xplus.AutoButtonColor = false; xplus.ZIndex = 9
		Instance.new("UICorner", xplus).CornerRadius = UDim.new(0, 6)
		V.xrayPlusBtn = xplus
		V.xrayMinusBtn = xminus
		trackTheme(function(c) xminus.TextColor3 = c; xplus.TextColor3 = c end)
		if V.setXrayTransparency then V.setXrayTransparency(V.xrayTransparency) end
		local function xstep(d)
			if _anyKeyListening then return end
			if V.setXrayTransparency then V.setXrayTransparency((tonumber(V.xrayTransparency) or 0.5) + d) end
			saveConfig()
		end
		xminus.Activated:Connect(function() xstep(-0.05) end)
		xplus.Activated:Connect(function() xstep(0.05) end)
		local expanded = false
		local function setExpanded(v)
			expanded = v
			panel.Visible = true
			TS:Create(arrow, TweenInfo.new(0.18), {Rotation = v and 180 or 0}):Play()
			local tw = TS:Create(panel, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Size = UDim2.new(1, -2, 0, v and 44 or 0),
			})
			tw:Play()
			if not v then
				tw.Completed:Connect(function()
					if not expanded then panel.Visible = false end
				end)
			end
		end
		arrow.Activated:Connect(function()
			if _anyKeyListening then return end
			setExpanded(not expanded)
		end)
	end
	setMedusaVisual=mkToggle("Medusa Counter",function(on) medusaCounterEnabled=on;if on then setupMedusa(LP.Character) else stopMedusaCounter() end;saveConfig() end)
	setUnwalkVisual=mkToggle("Unwalk",function(on) unwalkEnabled=on;if on then startUnwalk() else stopUnwalk() end;saveConfig() end)

	mkSect("Teleport")
	do local row=mkRow(40);mkLabel(row,"TP Down");mkKB(row,KB.TPFloor,function(k,isGp) if isGp then KB.TPFloor.gp=k;KB.TPFloor.kb=nil else KB.TPFloor.kb=k;KB.TPFloor.gp=nil end;saveConfig() end);local clk=Instance.new("TextButton",row);clk.Size=UDim2.new(0.58,0,1,0);clk.BackgroundTransparency=1;clk.Text="";clk.ZIndex=2;clk.Activated:Connect(function() runTPFloor() end) end
	do local row=mkRow(40);mkLabel(row,"Instant Reset");mkKB(row,KB.InstaReset,function(k,isGp) if isGp then KB.InstaReset.gp=k;KB.InstaReset.kb=nil else KB.InstaReset.kb=k;KB.InstaReset.gp=nil end;saveConfig() end);local clk=Instance.new("TextButton",row);clk.Size=UDim2.new(0.58,0,1,0);clk.BackgroundTransparency=1;clk.Text="";clk.ZIndex=2;clk.Activated:Connect(function() if _anyKeyListening then return end;cursedInstaReset() end) end
	setAutoTPVisual=mkToggle("Auto TP Down",function(on) autoTPEnabled=on;if on then startAutoTP() else stopAutoTP() end;saveConfig() end)
	do local row=mkRow(40);mkLabel(row,"TP Down Height");autoTPHeightBox=mkBox(row,autoTPHeight,50,56,function(v) if v>=0 and v<=500 then autoTPHeight=v else autoTPHeightBox.Text=tostring(autoTPHeight) end;saveConfig() end) end
	do local row=mkRow(40);mkLabel(row,"Drop Brainrot");mkKB(row,KB.DropBrainrot,function(k,isGp) if isGp then KB.DropBrainrot.gp=k;KB.DropBrainrot.kb=nil else KB.DropBrainrot.kb=k;KB.DropBrainrot.gp=nil end;saveConfig() end);local clk=Instance.new("TextButton",row);clk.Size=UDim2.new(0.58,0,1,0);clk.BackgroundTransparency=1;clk.Text="";clk.ZIndex=2;clk.Activated:Connect(function() runDrop() end) end

	mkSect("Auto Left / Right")
	do local sv=mkToggleKB("Auto Left",KB.AutoLeft,function(on) autoLeftEnabled=on;if on then queueAutoLeftStart() else stopAutoLeft() end end,function(k,isGp) if isGp then KB.AutoLeft.gp=k;KB.AutoLeft.kb=nil else KB.AutoLeft.kb=k;KB.AutoLeft.gp=nil end;saveConfig() end);autoLeftSetVisual=sv end
	do local sv=mkToggleKB("Auto Right",KB.AutoRight,function(on) autoRightEnabled=on;if on then queueAutoRightStart() else stopAutoRight() end end,function(k,isGp) if isGp then KB.AutoRight.gp=k;KB.AutoRight.kb=nil else KB.AutoRight.kb=k;KB.AutoRight.gp=nil end;saveConfig() end);autoRightSetVisual=sv end

	-- ===== INTRO MUSIC (Misery Duels songs, portado) =====
	local INTRO_SONGS = {
		{name="Song 1", url="https://files.catbox.moe/s30d11.mp3", file="VexusHub_Song1.mp3", startTime=70},
		{name="Song 2", url="https://files.catbox.moe/2a7jyx.mp3", file="VexusHub_Song2.mp3"},
		{name="Song 3", url="https://files.catbox.moe/rcgr9f.mp3", file="VexusHub_Song3.mp3"},
		{name="Song 4", assetId="rbxassetid://126109522605598"},
		{name="Song 5", url="https://files.catbox.moe/6eigoh.mp3", file="VexusHub_Song5.mp3"},
		{name="Song 6", assetId="rbxassetid://125971808485513"},
		{name="Song 7", url="https://files.catbox.moe/iyw1cb.mp3", file="VexusHub_Song7.mp3"},
		{name="Song 8", assetId="rbxassetid://76650356472656", startTime=3, volume=1},
		{name="Song 9", url="https://files.catbox.moe/mzvrir.mp3", file="VexusHub_Song9.mp3"},
		{name="Song 10", assetId="rbxassetid://126081283261720"},
	}
	local introSongCache = {}
	local introMusic = nil
	local function getIntroSongName()
		local opt = INTRO_SONGS[V.introSong]
		return opt and opt.name or "No Song"
	end
	local function isMp3(data)
		if type(data) ~= "string" or #data < 64 then return false end
		return data:sub(1,3) == "ID3" or data:byte(1) == 0xFF
	end
	local function getIntroSongAsset(opt)
		if opt.assetId then return opt.assetId end
		if not (opt and opt.url and writefile and getcustomasset and isfile) then return nil end
		local fn = opt.file or ("VexusIntro_" .. tostring(opt.name) .. ".mp3")
		if introSongCache[fn] and introSongCache[fn] ~= "" then return introSongCache[fn] end
		-- try cached file (must be a valid custom asset, not a stale/broken one)
		local has = false
		pcall(function() has = isfile(fn) end)
		if has then
			local ok = pcall(function() introSongCache[fn] = getcustomasset(fn) end)
			if ok and introSongCache[fn] and introSongCache[fn] ~= "" then return introSongCache[fn] end
		end
		-- (re)download and cache, validating it's real audio before saving
		local ok = pcall(function()
			local data = game:HttpGet(opt.url)
			if isMp3(data) then
				writefile(fn, data)
				introSongCache[fn] = getcustomasset(fn)
			end
		end)
		if ok and introSongCache[fn] and introSongCache[fn] ~= "" then return introSongCache[fn] end
		return nil
	end
	local function stopIntroMusic()
		if introMusic then
			pcall(function() introMusic:Stop() end)
			pcall(function() introMusic:Destroy() end)
			introMusic = nil
		end
	end
	local function startIntroMusic()
		stopIntroMusic()
		local opt = INTRO_SONGS[V.introSong]
		if not opt then return end
		task.spawn(function()
			local id = getIntroSongAsset(opt)
			if not id then return end
			local s = Instance.new("Sound")
			s.Volume = opt.volume or 0.65
			s.Looped = false
			s.SoundId = id
			s.Parent = game:GetService("SoundService")
			introMusic = s
			local st = tick()
			while s and not s.IsLoaded and tick() - st < 10 do task.wait(0.05) end
			if s and opt.startTime then s.TimePosition = opt.startTime end
			pcall(function() s:Play() end)
		end)
	end

	mkSect("Interface")
	do local row=mkRow(40);mkLabel(row,"Hide GUI");mkKB(row,KB.GuiHide,function(k,isGp) if isGp then KB.GuiHide.gp=k;KB.GuiHide.kb=nil else KB.GuiHide.kb=k;KB.GuiHide.gp=nil end;saveConfig() end) end
	setIntroVisual = mkToggle("Intro", function(on) _introEnabled = on; saveConfig() end)
	if setIntroVisual then setIntroVisual(_introEnabled) end
	-- ===== LOCK UI + MOBILE BUTTONS (portado do MISERY DUELS) =====
	setLockGuiVisual = mkToggle("Lock UI", function(on) _guiLocked = on; saveConfig() end)
	if setLockGuiVisual then setLockGuiVisual(_guiLocked) end
	-- ===== UI SCALE (+/-) — redimensiona o painel inteiro =====
	do
		local row=mkRow(42);mkLabel(row,"UI Scale")
		local minus=Instance.new("TextButton",row)
		minus.Size=UDim2.new(0,34,0,28);minus.Position=UDim2.new(1,-140,0.5,-14)
		minus.BackgroundColor3=Color3.fromRGB(12,12,12);minus.BorderSizePixel=0
		minus.Text="-";minus.TextColor3=THEME_ACCENT;minus.Font=Enum.Font.GothamBold
		minus.TextSize=16;minus.AutoButtonColor=false;minus.ZIndex=8
		Instance.new("UICorner",minus).CornerRadius=UDim.new(0,8)
		local val=Instance.new("TextLabel",row)
		val.Size=UDim2.new(0,58,1,0);val.Position=UDim2.new(1,-102,0,0)
		val.BackgroundTransparency=1
		val.Text=string.format("%d%%", math.floor((tonumber(V.uiScale) or 1)*100+0.5))
		val.TextColor3=Color3.fromRGB(255,255,255);val.Font=Enum.Font.GothamBold;val.TextSize=12
		val.TextXAlignment=Enum.TextXAlignment.Center;val.ZIndex=8
		V.uiScaleLbl=val
		local plus=Instance.new("TextButton",row)
		plus.Size=UDim2.new(0,34,0,28);plus.Position=UDim2.new(1,-42,0.5,-14)
		plus.BackgroundColor3=Color3.fromRGB(12,12,12);plus.BorderSizePixel=0
		plus.Text="+";plus.TextColor3=THEME_ACCENT;plus.Font=Enum.Font.GothamBold
		plus.TextSize=16;plus.AutoButtonColor=false;plus.ZIndex=8
		Instance.new("UICorner",plus).CornerRadius=UDim.new(0,8)
		trackTheme(function(c) minus.TextColor3=c;plus.TextColor3=c end)
		local function step(d)
			if _anyKeyListening then return end
			local cur=tonumber(V.uiScale) or 1
			if V.setUIScale then V.setUIScale(cur+d) end
			saveConfig()
		end
		minus.Activated:Connect(function() step(-0.05) end)
		plus.Activated:Connect(function() step(0.05) end)
		-- clique no valor reseta pra 100%
		local reset=Instance.new("TextButton",row)
		reset.Size=UDim2.new(0,58,1,0);reset.Position=UDim2.new(1,-102,0,0)
		reset.BackgroundTransparency=1;reset.Text="";reset.ZIndex=9
		reset.Activated:Connect(function()
			if _anyKeyListening then return end
			if V.setUIScale then V.setUIScale(1) end
			saveConfig()
		end)
	end
	-- ===== MOBILE BUTTONS (toggle + flecha que abre a lista) =====
	do
		local row = mkRow(40)
		mkLabel(row, "Mobile Buttons")
		-- pill do toggle, deslocado pra abrir espaco pra flecha
		local pill, dot = mkPill(row, 56)
		local on = false
		local function sv(st) on = st; animPill(pill, dot, st) end
		table.insert(_trackedPills, {pill=pill, dot=dot, getState=function() return on end})
		local clk = Instance.new("TextButton", pill)
		clk.Size = UDim2.new(1,0,1,0); clk.BackgroundTransparency = 1; clk.Text = ""; clk.ZIndex = 5
		clk.Activated:Connect(function()
			on = not on; sv(on)
			if V.setMobileButtonsVisible then V.setMobileButtonsVisible(on) end
			saveConfig()
		end)
		pill.ZIndex = 3; dot.ZIndex = 4
		V.setMobileBtnsVisual = sv
		-- FLECHA: abre/fecha a lista de quais botoes aparecem
		local arrow = Instance.new("TextButton", row)
		arrow.Size = UDim2.new(0, 26, 0, 26)
		-- fica a ESQUERDA do pill (pill ocupa de -56 a -10)
		arrow.Position = UDim2.new(1, -88, 0.5, -13)
		arrow.BackgroundColor3 = Color3.fromRGB(12,12,12)
		arrow.BorderSizePixel = 0
		arrow.Text = "v"
		arrow.TextColor3 = THEME_ACCENT
		arrow.Font = Enum.Font.GothamBold
		arrow.TextSize = 13
		arrow.AutoButtonColor = false
		arrow.ZIndex = 8
		Instance.new("UICorner", arrow).CornerRadius = UDim.new(0, 7)
		local aSt = Instance.new("UIStroke", arrow)
		aSt.Color = THEME_ACCENT_DIM; aSt.Thickness = 1; aSt.Transparency = 0.4
		trackTheme(function(c) arrow.TextColor3 = c; aSt.Color = THEME_ACCENT_DIM end)
		-- painel expansivel com um item por botao mobile
		local panel = Instance.new("Frame", sf)
		panel.Size = UDim2.new(1, -2, 0, 0)
		panel.BackgroundColor3 = Color3.fromRGB(8,8,8)
		panel.BorderSizePixel = 0
		panel.ClipsDescendants = true
		panel.LayoutOrder = LO()
		panel.ZIndex = 6
		panel.Visible = false
		Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 10)
		local pSt = Instance.new("UIStroke", panel)
		pSt.Color = THEME_ACCENT_DIM; pSt.Thickness = 1; pSt.Transparency = 0.5
		trackTheme(function(_) pSt.Color = THEME_ACCENT_DIM end)
		local plist = Instance.new("UIListLayout", panel)
		plist.SortOrder = Enum.SortOrder.LayoutOrder
		plist.Padding = UDim.new(0, 2)
		local ppad = Instance.new("UIPadding", panel)
		ppad.PaddingTop = UDim.new(0, 6); ppad.PaddingBottom = UDim.new(0, 6)
		ppad.PaddingLeft = UDim.new(0, 8); ppad.PaddingRight = UDim.new(0, 8)
		local expanded = false
		local built = false
		-- monta um item (nome + pill) pra cada mobile button existente
		V.buildMobileBtnList = function()
			if built then return end
			built = true
			local order = V.mobileBtnOrder or {}
			for i, key in ipairs(order) do
				local item = Instance.new("Frame", panel)
				item.Size = UDim2.new(1, 0, 0, 30)
				item.BackgroundColor3 = Color3.fromRGB(0,0,0)
				item.BorderSizePixel = 0
				item.LayoutOrder = i
				item.ZIndex = 7
				Instance.new("UICorner", item).CornerRadius = UDim.new(0, 8)
				local nm = Instance.new("TextLabel", item)
				nm.Size = UDim2.new(1, -70, 1, 0); nm.Position = UDim2.new(0, 10, 0, 0)
				nm.BackgroundTransparency = 1
				nm.Text = (V.mobileBtnLabels and V.mobileBtnLabels[key]) or key
				nm.TextColor3 = Color3.fromRGB(235,235,240)
				nm.Font = Enum.Font.GothamBold; nm.TextSize = 11
				nm.TextXAlignment = Enum.TextXAlignment.Left
				nm.ZIndex = 8
				-- pill menor, mesmo estilo do resto da UI
				local ip = Instance.new("Frame", item)
				ip.Size = UDim2.new(0, 38, 0, 20); ip.Position = UDim2.new(1, -46, 0.5, -10)
				ip.BackgroundColor3 = Color3.fromRGB(42,42,42); ip.BorderSizePixel = 0; ip.ZIndex = 8
				Instance.new("UICorner", ip).CornerRadius = UDim.new(1, 0)
				local idot = Instance.new("Frame", ip)
				idot.Size = UDim2.new(0, 14, 0, 14); idot.Position = UDim2.new(0, 3, 0.5, -7)
				idot.BackgroundColor3 = Color3.fromRGB(130,130,130); idot.BorderSizePixel = 0; idot.ZIndex = 9
				Instance.new("UICorner", idot).CornerRadius = UDim.new(1, 0)
				local st = V.isMobileBtnOn(key)
				local function paint(v)
					TS:Create(ip, TweenInfo.new(0.16), {BackgroundColor3 = v and THEME_ACCENT or Color3.fromRGB(34,34,34)}):Play()
					TS:Create(idot, TweenInfo.new(0.16, Enum.EasingStyle.Back), {
						Position = v and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7),
						BackgroundColor3 = v and Color3.fromRGB(255,255,255) or Color3.fromRGB(130,130,130),
					}):Play()
				end
				paint(st)
				trackTheme(function(_) paint(st) end)
				local ic = Instance.new("TextButton", item)
				ic.Size = UDim2.new(1,0,1,0); ic.BackgroundTransparency = 1; ic.Text = ""; ic.ZIndex = 10
				ic.Activated:Connect(function()
					if _anyKeyListening then return end
					st = not st
					paint(st)
					if V.setMobileButtonEnabled then V.setMobileButtonEnabled(key, st) end
					saveConfig()
				end)
			end
		end
		local function setExpanded(v)
			expanded = v
			if v then V.buildMobileBtnList() end
			local count = #(V.mobileBtnOrder or {})
			local h = (count * 32) + 12
			panel.Visible = true
			TS:Create(arrow, TweenInfo.new(0.18), {Rotation = v and 180 or 0}):Play()
			local tw = TS:Create(panel, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Size = UDim2.new(1, -2, 0, v and h or 0),
			})
			tw:Play()
			if not v then
				tw.Completed:Connect(function()
					if not expanded then panel.Visible = false end
				end)
			end
		end
		arrow.Activated:Connect(function()
			if _anyKeyListening then return end
			setExpanded(not expanded)
		end)
	end
	if V.setMobileBtnsVisual then V.setMobileBtnsVisual(not V.hideMobileButtons) end
	V.setLockMobileVisual = mkToggle("Lock Mobile Buttons", function(on)
		V.lockMobileButtons = on
		saveConfig()
	end)
	if V.setLockMobileVisual then V.setLockMobileVisual(V.lockMobileButtons == true) end
	V.setMoveAllVisual = mkToggle("Move All Together", function(on)
		V.mobileMoveAll = on
		saveConfig()
	end)
	if V.setMoveAllVisual then V.setMoveAllVisual(V.mobileMoveAll == true) end
	-- tamanho dos mobile buttons (-/+)
	do
		local row = mkRow(42); mkLabel(row, "Mobile Buttons Size")
		local minus = Instance.new("TextButton", row)
		minus.Size = UDim2.new(0, 34, 0, 28); minus.Position = UDim2.new(1, -140, 0.5, -14)
		minus.BackgroundColor3 = Color3.fromRGB(12,12,12); minus.BorderSizePixel = 0
		minus.Text = "-"; minus.TextColor3 = THEME_ACCENT; minus.Font = Enum.Font.GothamBold
		minus.TextSize = 16; minus.AutoButtonColor = false; minus.ZIndex = 8
		Instance.new("UICorner", minus).CornerRadius = UDim.new(0, 8)
		local val = Instance.new("TextLabel", row)
		val.Size = UDim2.new(0, 58, 1, 0); val.Position = UDim2.new(1, -102, 0, 0)
		val.BackgroundTransparency = 1
		val.TextColor3 = Color3.fromRGB(255,255,255); val.Font = Enum.Font.GothamBold; val.TextSize = 12
		val.TextXAlignment = Enum.TextXAlignment.Center; val.ZIndex = 8
		local plus = Instance.new("TextButton", row)
		plus.Size = UDim2.new(0, 34, 0, 28); plus.Position = UDim2.new(1, -42, 0.5, -14)
		plus.BackgroundColor3 = Color3.fromRGB(12,12,12); plus.BorderSizePixel = 0
		plus.Text = "+"; plus.TextColor3 = THEME_ACCENT; plus.Font = Enum.Font.GothamBold
		plus.TextSize = 16; plus.AutoButtonColor = false; plus.ZIndex = 8
		Instance.new("UICorner", plus).CornerRadius = UDim.new(0, 8)
		trackTheme(function(c) minus.TextColor3 = c; plus.TextColor3 = c end)
		V.mobileScaleLbl = val
		V.mobileScalePlus = plus
		V.mobileScaleMinus = minus
		if V.setMobileBtnScale then V.setMobileBtnScale(V.mobileBtnScale) end
		local function step(d)
			if _anyKeyListening then return end
			if V.setMobileBtnScale then V.setMobileBtnScale((tonumber(V.mobileBtnScale) or 0.80) + d) end
			saveConfig()
		end
		minus.Activated:Connect(function() step(-0.05) end)
		plus.Activated:Connect(function() step(0.05) end)
	end
	do
		local row = mkRow(40)
		mkLabel(row, "Intro Song")
		local songBtn = Instance.new("TextButton", row)
		songBtn.Size = UDim2.new(0, 118, 0, 28)
		songBtn.Position = UDim2.new(1, -128, 0.5, -14)
		songBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
		songBtn.BackgroundTransparency = 0.2
		songBtn.BorderSizePixel = 0
		songBtn.Text = getIntroSongName()
		songBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		songBtn.Font = Enum.Font.GothamBold
		songBtn.TextSize = 12
		songBtn.AutoButtonColor = false
		songBtn.ZIndex = 6
		Instance.new("UICorner", songBtn).CornerRadius = UDim.new(0, 8)
		V.setIntroSongVisual = function()
			if songBtn and songBtn.Parent then songBtn.Text = getIntroSongName() end
		end
		songBtn.MouseButton1Click:Connect(function()
			V.introSong = V.introSong + 1
			if V.introSong > #INTRO_SONGS then V.introSong = 1 end
			if V.setIntroSongVisual then V.setIntroSongVisual() end
			startIntroMusic()
			saveConfig()
		end)
	end
	-- Discord — card estilo Violet (icone + nome + convite)
	V.DISCORD_URL = "discord.gg/NrJaxfK54d"
	V.DISCORD_NAME = "VEXUS HUB"
	V.DISCORD_ICON = "rbxassetid://119636995633491"
	PlayerESP.discordText = V.DISCORD_URL
	do
		local card = Instance.new("Frame", customPage)
		card.Size = UDim2.new(1, 0, 0, 66)
		card.BackgroundColor3 = Color3.fromRGB(14,14,14)
		card.BorderSizePixel = 0
		card.LayoutOrder = -1  -- sempre no topo da aba Customization
		card.ZIndex = 6
		Instance.new("UICorner", card).CornerRadius = UDim.new(0, 14)
		local cSt = Instance.new("UIStroke", card)
		cSt.Color = THEME_ACCENT; cSt.Thickness = 1.4; cSt.Transparency = 0.15
		trackTheme(function(c) cSt.Color = c end)
		-- brilho de fundo na cor do tema (esquerda -> transparente)
		local cGrad = Instance.new("UIGradient", card)
		cGrad.Rotation = 0
		local function refreshCardGrad()
			cGrad.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0.00, THEME_ACCENT_DIM),
				ColorSequenceKeypoint.new(0.55, Color3.fromRGB(255,255,255)),
				ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255,255,255)),
			})
		end
		refreshCardGrad()
		trackTheme(function(_) refreshCardGrad() end)
		-- icone quadrado arredondado
		local iconHold = Instance.new("Frame", card)
		iconHold.Size = UDim2.new(0, 46, 0, 46)
		iconHold.Position = UDim2.new(0, 10, 0.5, -23)
		iconHold.BackgroundColor3 = Color3.fromRGB(26,26,26)
		iconHold.BorderSizePixel = 0; iconHold.ZIndex = 7
		Instance.new("UICorner", iconHold).CornerRadius = UDim.new(0, 12)
		local iconImg = Instance.new("ImageLabel", iconHold)
		iconImg.Size = UDim2.new(1,-4,1,-4); iconImg.Position = UDim2.new(0,2,0,2)
		iconImg.BackgroundTransparency = 1; iconImg.ZIndex = 8
		iconImg.Image = V.DISCORD_ICON
		iconImg.ScaleType = Enum.ScaleType.Crop
		-- tinge a imagem do icone com a cor do tema
		iconImg.ImageColor3 = THEME_ACCENT_BRIGHT
		trackTheme(function(_) iconImg.ImageColor3 = THEME_ACCENT_BRIGHT end)
		Instance.new("UICorner", iconImg).CornerRadius = UDim.new(0, 10)
		local iSt = Instance.new("UIStroke", iconHold)
		iSt.Color = THEME_ACCENT; iSt.Thickness = 1.4; iSt.Transparency = 0.1
		trackTheme(function(c) iSt.Color = c end)
		V.discordIconImg = iconImg
		-- nome do servidor
		local nameLbl = Instance.new("TextLabel", card)
		nameLbl.Size = UDim2.new(1, -74, 0, 22)
		nameLbl.Position = UDim2.new(0, 66, 0, 12)
		nameLbl.BackgroundTransparency = 1
		nameLbl.Text = V.DISCORD_NAME
		nameLbl.TextColor3 = Color3.fromRGB(255,255,255)
		nameLbl.Font = Enum.Font.GothamBlack; nameLbl.TextSize = 16
		nameLbl.TextXAlignment = Enum.TextXAlignment.Left
		nameLbl.ZIndex = 8
		-- gradiente animado no nome (mesmo efeito do texto do Discord)
		local nGrad = Instance.new("UIGradient", nameLbl)
		local function refreshNameGrad()
			nGrad.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0.00, THEME_ACCENT_DIM),
				ColorSequenceKeypoint.new(0.45, THEME_ACCENT_BRIGHT),
				ColorSequenceKeypoint.new(0.55, THEME_ACCENT_BRIGHT),
				ColorSequenceKeypoint.new(1.00, THEME_ACCENT_DIM),
			})
		end
		refreshNameGrad()
		trackTheme(function(_) refreshNameGrad() end)
		task.spawn(function()
			while nameLbl and nameLbl.Parent do
				for i = -1, 1, 0.02 do
					if not (nameLbl and nameLbl.Parent) then break end
					nGrad.Offset = Vector2.new(i, 0)
					task.wait(0.03)
				end
			end
		end)
		-- link do convite
		local dcBtn = Instance.new("TextButton", card)
		dcBtn.Size = UDim2.new(1, -74, 0, 20)
		dcBtn.Position = UDim2.new(0, 66, 0, 34)
		dcBtn.BackgroundTransparency = 1
		dcBtn.AutoButtonColor = false
		dcBtn.Text = V.DISCORD_URL
		dcBtn.TextColor3 = THEME_ACCENT_BRIGHT
		trackTheme(function(_) if dcBtn.Text == V.DISCORD_URL then dcBtn.TextColor3 = THEME_ACCENT_BRIGHT end end)
		dcBtn.Font = Enum.Font.GothamMedium; dcBtn.TextSize = 13
		dcBtn.TextXAlignment = Enum.TextXAlignment.Left
		dcBtn.ZIndex = 8
		dcBtn.MouseButton1Click:Connect(function()
			local ok=false
			pcall(function()
				if setclipboard then setclipboard(V.DISCORD_URL);ok=true
				elseif toclipboard then toclipboard(V.DISCORD_URL);ok=true end
			end)
			dcBtn.Text = ok and "copiado!" or "sem suporte"
			dcBtn.TextColor3 = ok and Color3.fromRGB(120,220,150) or Color3.fromRGB(230,110,110)
			task.delay(1.2,function()
				if dcBtn and dcBtn.Parent then dcBtn.Text=V.DISCORD_URL; dcBtn.TextColor3=THEME_ACCENT_BRIGHT end
			end)
		end)
	end

	-- ============================================================
	-- BACKGROUND PICKER — portado do MISERY DUELS
	-- Grade de miniaturas que troca a arte da sidebar do Vexus.
	-- ============================================================
	-- ===== COR DA UI (paleta de bolinhas) =====
	mkSect("Theme Color")
	do
		local COLORS = {
			{name="Default", c=Color3.fromRGB(192,192,192)},
			{name="Red",     c=Color3.fromRGB(230, 45, 45)},
			{name="Green",   c=Color3.fromRGB(45, 210, 90)},
			{name="Blue",    c=Color3.fromRGB(50, 130, 255)},
			{name="Purple",  c=Color3.fromRGB(160, 70, 255)},
			{name="Pink",    c=Color3.fromRGB(255, 90, 190)},
			{name="Yellow",  c=Color3.fromRGB(255, 205, 40)},
		}
		local box = Instance.new("Frame", sf)
		box.Size = UDim2.new(1, 0, 0, 56)
		box.BackgroundColor3 = Color3.fromRGB(14,14,14)
		box.BorderSizePixel = 0
		box.LayoutOrder = LO()
		box.ZIndex = 6
		Instance.new("UICorner", box).CornerRadius = UDim.new(0, 10)
		local bp2 = Instance.new("UIPadding", box)
		bp2.PaddingLeft = UDim.new(0,10); bp2.PaddingRight = UDim.new(0,10)
		bp2.PaddingTop = UDim.new(0,10); bp2.PaddingBottom = UDim.new(0,10)
		local bl = Instance.new("UIListLayout", box)
		bl.FillDirection = Enum.FillDirection.Horizontal
		bl.SortOrder = Enum.SortOrder.LayoutOrder
		bl.Padding = UDim.new(0, 8)
		bl.VerticalAlignment = Enum.VerticalAlignment.Center
		local swatches = {}
		local function refreshSwatches()
			for _, d in ipairs(swatches) do
				local sel = (math.abs(d.col.R-THEME_ACCENT.R)<0.02
					and math.abs(d.col.G-THEME_ACCENT.G)<0.02
					and math.abs(d.col.B-THEME_ACCENT.B)<0.02)
				local st = d.btn:FindFirstChildOfClass("UIStroke")
				if st then
					st.Color = sel and Color3.fromRGB(255,255,255) or Color3.fromRGB(80,80,80)
					st.Thickness = sel and 2.4 or 1
					st.Transparency = sel and 0 or 0.5
				end
			end
		end
		V.refreshSwatches = refreshSwatches
		for i, entry in ipairs(COLORS) do
			local col = entry.c
			local b = Instance.new("TextButton", box)
			b.Name = "Swatch"..entry.name
			b.Size = UDim2.new(0, 32, 0, 32)
			b.BackgroundColor3 = col
			b.BorderSizePixel = 0
			b.Text = ""
			b.AutoButtonColor = false
			b.LayoutOrder = i
			b.ZIndex = 8
			Instance.new("UICorner", b).CornerRadius = UDim.new(1, 0)
			local bs = Instance.new("UIStroke", b)
			bs.Color = Color3.fromRGB(80,80,80); bs.Thickness = 1; bs.Transparency = 0.5
			table.insert(swatches, {btn=b, col=col})
			-- cores com background proprio
			local pairedBg = nil
			if entry.name == "Default" then pairedBg = "83597321089055"
			elseif entry.name == "Purple" then pairedBg = "117895477843367"
			elseif entry.name == "Green" then pairedBg = "74213154247849"
			elseif entry.name == "Pink" then pairedBg = "86521770218266"
			elseif entry.name == "Yellow" then pairedBg = "79656748193298"
			elseif entry.name == "Red" then pairedBg = "100302943529322"
			elseif entry.name == "Blue" then pairedBg = "136063326735393" end
			b.MouseButton1Click:Connect(function()
				if _anyKeyListening then return end
				if setAccent_global then setAccent_global(col) end
				V.themeAccent = {col.R, col.G, col.B}
				if pairedBg then
					if setSidebarArt_global then setSidebarArt_global(pairedBg) end
					if V.refreshMobileBg then V.refreshMobileBg(pairedBg) end
					if V.refreshBgPicker then V.refreshBgPicker() end
				end
				refreshSwatches()
				saveConfig()
			end)
		end
		refreshSwatches()
	end

	-- Tamanho da UI do Auto Grab (barra de steal)
	do
		local row=mkRow(42);mkLabel(row,"Steal Bar Size")
		local minus=Instance.new("TextButton",row)
		minus.Size=UDim2.new(0,34,0,28);minus.Position=UDim2.new(1,-140,0.5,-14)
		minus.BackgroundColor3=Color3.fromRGB(12,12,12);minus.BorderSizePixel=0
		minus.Text="-";minus.TextColor3=THEME_ACCENT;minus.Font=Enum.Font.GothamBold
		minus.TextSize=16;minus.AutoButtonColor=false;minus.ZIndex=8
		Instance.new("UICorner",minus).CornerRadius=UDim.new(0,8)
		local val=Instance.new("TextLabel",row)
		val.Size=UDim2.new(0,58,1,0);val.Position=UDim2.new(1,-102,0,0)
		val.BackgroundTransparency=1
		val.Text=string.format("%d%%", math.floor((tonumber(V.stealBarScale) or 1)*100+0.5))
		val.TextColor3=W;val.Font=Enum.Font.GothamBold;val.TextSize=12
		val.TextXAlignment=Enum.TextXAlignment.Center;val.ZIndex=8
		V.stealScaleLbl=val
		local plus=Instance.new("TextButton",row)
		plus.Size=UDim2.new(0,34,0,28);plus.Position=UDim2.new(1,-42,0.5,-14)
		plus.BackgroundColor3=Color3.fromRGB(12,12,12);plus.BorderSizePixel=0
		plus.Text="+";plus.TextColor3=THEME_ACCENT;plus.Font=Enum.Font.GothamBold
		plus.TextSize=16;plus.AutoButtonColor=false;plus.ZIndex=8
		Instance.new("UICorner",plus).CornerRadius=UDim.new(0,8)
		do
			local _m,_p=minus,plus
			trackTheme(function(c) _m.TextColor3=c;_p.TextColor3=c end)
		end
		local function step(d)
			if _anyKeyListening then return end
			local cur=tonumber(V.stealBarScale) or 1
			if V.setStealBarScale then V.setStealBarScale(cur+d) end
			saveConfig()
		end
		minus.Activated:Connect(function() step(-0.1) end)
		plus.Activated:Connect(function() step(0.1) end)
	end

	mkSect("Background")
	do
		local BG_IDS = {
			"83597321089055",
			"86521770218266",
			"79656748193298",
			"117895477843367",
			"74213154247849",
			"100302943529322",
			"136063326735393",
		}
		local grid = Instance.new("Frame", sf)
		grid.Size = UDim2.new(1, 0, 0, 138)
		grid.BackgroundColor3 = Color3.fromRGB(14,14,14)
		grid.BorderSizePixel = 0
		grid.LayoutOrder = LO()
		grid.ZIndex = 6
		Instance.new("UICorner", grid).CornerRadius = UDim.new(0, 10)
		local gp = Instance.new("UIPadding", grid)
		gp.PaddingLeft = UDim.new(0,8); gp.PaddingRight = UDim.new(0,8)
		gp.PaddingTop = UDim.new(0,8); gp.PaddingBottom = UDim.new(0,8)
		local gl = Instance.new("UIGridLayout", grid)
		gl.CellSize = UDim2.new(0, 62, 0, 36)
		gl.CellPadding = UDim2.new(0, 6, 0, 6)
		gl.SortOrder = Enum.SortOrder.LayoutOrder
		gl.HorizontalAlignment = Enum.HorizontalAlignment.Left
		local bgButtons = {}
		local function refreshBgPicker()
			for id, b in pairs(bgButtons) do
				local sel = (tostring(id) == tostring(V.sidebarArt))
				local st = b:FindFirstChildOfClass("UIStroke")
				if st then
					st.Color = sel and Color3.fromRGB(255,255,255) or Color3.fromRGB(90,90,90)
					st.Transparency = sel and 0.05 or 0.5
					st.Thickness = sel and 2 or 1
				end
				b.BackgroundTransparency = sel and 0 or 0.35
			end
		end
		V.refreshBgPicker = refreshBgPicker
		for i, imageId in ipairs(BG_IDS) do
			local thisId = imageId
			local b = Instance.new("ImageButton", grid)
			b.Name = "Bg"..tostring(i)
			b.BackgroundColor3 = Color3.fromRGB(24,24,24)
			b.BackgroundTransparency = 0.35
			b.BorderSizePixel = 0
			b.Image = "rbxassetid://"..thisId
			b.ScaleType = Enum.ScaleType.Crop
			b.AutoButtonColor = false
			b.LayoutOrder = i
			b.ZIndex = 8
			b.ClipsDescendants = true
			Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)
			local bs = Instance.new("UIStroke", b)
			bs.Color = Color3.fromRGB(90,90,90); bs.Thickness = 1; bs.Transparency = 0.5
			bgButtons[thisId] = b
			b.MouseButton1Click:Connect(function()
				if _anyKeyListening then return end
				if setSidebarArt_global then setSidebarArt_global(thisId) end
				if V.refreshMobileBg then V.refreshMobileBg(thisId) end
				refreshBgPicker()
				saveConfig()
			end)
		end
		refreshBgPicker()
	end

	mkSect("ESP")
	-- ===== ESP (toggle + flecha que abre o modo No Line / Line) =====
	do
		local row = mkRow(40)
		mkLabel(row, "ESP")
		local pill, dot = mkPill(row, 56)
		local on = false
		local function sv(st2) on = st2; animPill(pill, dot, st2) end
		table.insert(_trackedPills, {pill=pill, dot=dot, getState=function() return on end})
		local clk = Instance.new("TextButton", pill)
		clk.Size = UDim2.new(1,0,1,0); clk.BackgroundTransparency = 1; clk.Text = ""; clk.ZIndex = 5
		clk.Activated:Connect(function()
			on = not on; sv(on)
			if on then startPlayerESP() else stopPlayerESP() end
			saveConfig()
		end)
		pill.ZIndex = 3; dot.ZIndex = 4
		setPlayerESPVisual = sv
		-- FLECHA a esquerda do pill (igual Mobile Buttons)
		local arrow = Instance.new("TextButton", row)
		arrow.Size = UDim2.new(0, 26, 0, 26)
		arrow.Position = UDim2.new(1, -88, 0.5, -13)
		arrow.BackgroundColor3 = Color3.fromRGB(12,12,12)
		arrow.BorderSizePixel = 0
		arrow.Text = "v"
		arrow.TextColor3 = THEME_ACCENT
		arrow.Font = Enum.Font.GothamBold
		arrow.TextSize = 13
		arrow.AutoButtonColor = false
		arrow.ZIndex = 8
		Instance.new("UICorner", arrow).CornerRadius = UDim.new(0, 7)
		local aSt = Instance.new("UIStroke", arrow)
		aSt.Color = THEME_ACCENT_DIM; aSt.Thickness = 1; aSt.Transparency = 0.4
		trackTheme(function(c) arrow.TextColor3 = c; aSt.Color = THEME_ACCENT_DIM end)
		-- painel expansivel com as opcoes de modo
		local panel = Instance.new("Frame", sf)
		panel.Size = UDim2.new(1, -2, 0, 0)
		panel.BackgroundColor3 = Color3.fromRGB(8,8,8)
		panel.BorderSizePixel = 0
		panel.ClipsDescendants = true
		panel.LayoutOrder = LO()
		panel.ZIndex = 6
		panel.Visible = false
		Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 10)
		local pSt = Instance.new("UIStroke", panel)
		pSt.Color = THEME_ACCENT_DIM; pSt.Thickness = 1; pSt.Transparency = 0.5
		trackTheme(function(_) pSt.Color = THEME_ACCENT_DIM end)
		local ppad = Instance.new("UIPadding", panel)
		ppad.PaddingTop = UDim.new(0, 6); ppad.PaddingBottom = UDim.new(0, 6)
		ppad.PaddingLeft = UDim.new(0, 8); ppad.PaddingRight = UDim.new(0, 8)
		local item = Instance.new("Frame", panel)
		item.Size = UDim2.new(1, 0, 0, 30)
		item.BackgroundColor3 = Color3.fromRGB(0,0,0)
		item.BorderSizePixel = 0
		item.ZIndex = 7
		Instance.new("UICorner", item).CornerRadius = UDim.new(0, 8)
		local nm = Instance.new("TextLabel", item)
		nm.Size = UDim2.new(1, -140, 1, 0); nm.Position = UDim2.new(0, 10, 0, 0)
		nm.BackgroundTransparency = 1
		nm.Text = "ESP Mode"
		nm.TextColor3 = Color3.fromRGB(235,235,240)
		nm.Font = Enum.Font.GothamBold; nm.TextSize = 11
		nm.TextXAlignment = Enum.TextXAlignment.Left
		nm.ZIndex = 8
		local noLineBtn = Instance.new("TextButton", item)
		noLineBtn.Size = UDim2.new(0, 58, 0, 22)
		noLineBtn.Position = UDim2.new(1, -126, 0.5, -11)
		noLineBtn.BorderSizePixel = 0
		noLineBtn.Text = "No Line"
		noLineBtn.Font = Enum.Font.GothamBold
		noLineBtn.TextSize = 10
		noLineBtn.AutoButtonColor = false
		noLineBtn.ZIndex = 9
		Instance.new("UICorner", noLineBtn).CornerRadius = UDim.new(0, 7)
		local lineBtn = Instance.new("TextButton", item)
		lineBtn.Size = UDim2.new(0, 58, 0, 22)
		lineBtn.Position = UDim2.new(1, -64, 0.5, -11)
		lineBtn.BorderSizePixel = 0
		lineBtn.Text = "Line"
		lineBtn.Font = Enum.Font.GothamBold
		lineBtn.TextSize = 10
		lineBtn.AutoButtonColor = false
		lineBtn.ZIndex = 9
		Instance.new("UICorner", lineBtn).CornerRadius = UDim.new(0, 7)
		local function paint()
			local nl = V.espMode ~= "withLine"
			noLineBtn.BackgroundColor3 = nl and THEME_ACCENT or Color3.fromRGB(30,30,30)
			noLineBtn.TextColor3 = nl and Color3.fromRGB(0,0,0) or Color3.fromRGB(220,220,220)
			lineBtn.BackgroundColor3 = (not nl) and THEME_ACCENT or Color3.fromRGB(30,30,30)
			lineBtn.TextColor3 = (not nl) and Color3.fromRGB(0,0,0) or Color3.fromRGB(220,220,220)
		end
		paint()
		trackTheme(function(_) paint() end)
		local function setMode(m)
			if _anyKeyListening then return end
			V.espMode = m
			paint()
			-- recria o ESP pra criar/remover as linhas
			if PlayerESP.enabled and V.espRebuild then V.espRebuild() end
			saveConfig()
		end
		noLineBtn.Activated:Connect(function() setMode("noLine") end)
		lineBtn.Activated:Connect(function() setMode("withLine") end)
		local expanded = false
		local function setExpanded(v)
			expanded = v
			panel.Visible = true
			TS:Create(arrow, TweenInfo.new(0.18), {Rotation = v and 180 or 0}):Play()
			local tw = TS:Create(panel, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Size = UDim2.new(1, -2, 0, v and 42 or 0),
			})
			tw:Play()
			if not v then
				tw.Completed:Connect(function()
					if not expanded then panel.Visible = false end
				end)
			end
		end
		arrow.Activated:Connect(function()
			if _anyKeyListening then return end
			setExpanded(not expanded)
		end)
	end
	mkSect("Config")
	-- botao pra devolver os mobile buttons pro lugar original
	do
		local row = mkRow(42); mkLabel(row, "Reset Buttons Position")
		local btn = Instance.new("TextButton", row)
		btn.Size = UDim2.new(0, 96, 0, 28)
		btn.Position = UDim2.new(1, -108, 0.5, -14)
		btn.BackgroundColor3 = Color3.fromRGB(12,12,12)
		btn.BorderSizePixel = 0
		btn.Text = "Reset"
		btn.TextColor3 = THEME_ACCENT
		btn.Font = Enum.Font.GothamBold
		btn.TextSize = 12
		btn.AutoButtonColor = false
		btn.ZIndex = 8
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
		local bs = Instance.new("UIStroke", btn)
		bs.Color = THEME_ACCENT_DIM; bs.Thickness = 1; bs.Transparency = 0.4
		trackTheme(function(c) btn.TextColor3 = c; bs.Color = THEME_ACCENT_DIM end)
		btn.Activated:Connect(function()
			if _anyKeyListening then return end
			if V.resetMobileBtnPos and V.resetMobileBtnPos() then
				btn.Text = "Done!"
				task.delay(0.9, function() if btn and btn.Parent then btn.Text = "Reset" end end)
				saveConfig()
			end
		end)
	end
	mkSect("Protection")
	do V.setAntiTpBatVisual = mkToggleKB("Anti Tp Bat", KB.AntiTpBat,
		function(on)
			if on then V.startAntiTpBat() else V.stopAntiTpBat() end
			if V.mobileButtons and V.mobileButtons["antiTpBat"] then
				V.mobileButtons["antiTpBat"].setActive(V.antiTpBatEnabled)
			end
			saveConfig()
		end,
		function(k,isGp) if isGp then KB.AntiTpBat.gp=k;KB.AntiTpBat.kb=nil else KB.AntiTpBat.kb=k;KB.AntiTpBat.gp=nil end;saveConfig() end)
	end
	V.setRemoveAccVisual = mkToggle("Remove Accessories", function(on) if on then enableRemoveAccessories() else disableRemoveAccessories() end; saveConfig() end)
	V.setAntiKickVisual = mkToggle("Anti-Kick", function(on) V.antiKickEnabled=on; if on then V.enableAntiKick() else V.disableAntiKick() end; saveConfig() end)
	V.setSafeModeVisual = mkToggle("Safe Mode", function(on) V.safeModeEnabled=on; if on then V.enableSafeMode() else V.disableSafeMode() end; saveConfig() end)
	mkSect("Auto Steal")
	setInstaGrab=mkToggle("Auto Steal",function(on)
		Steal.AutoStealEnabled=on
		if on then
			if not pcall(startAutoSteal) then Steal.AutoStealEnabled=false;if setInstaGrab then setInstaGrab(false) end end
		else stopAutoSteal() end
	end)
	do local row=mkRow(40);mkLabel(row,"Steal Radius");radInput=mkBox(row,Steal.StealRadius,64,72,function(v) if v>=0.5 and v<=300 then Steal.StealRadius=v end;saveConfig() end) end
	do local row=mkRow(40);mkLabel(row,"Steal Duration (s)");durInput=mkBox(row,Steal.StealDuration,64,72,function(v) if v>=0.05 and v<=10 then Steal.StealDuration=v end;saveConfig() end) end
	setAutoGrabStopVisual=mkToggle("Stop Time",function(on) autoGrabStopEnabled=on;saveConfig() end)
	do local row=mkRow(40);mkLabel(row,"Stop Time (s)");stopTimeBox=mkBox(row,autoGrabStopTime,64,72,function(v) if v>=0.5 and v<=3 then autoGrabStopTime=v end;saveConfig() end) end
	do local row=mkRow(40);mkLabel(row,"Delay Radius");delayRadiusBox=mkBox(row,autoGrabDelayRadius,64,72,function(v) if v>=2 and v<=20 then autoGrabDelayRadius=v end;saveConfig() end) end
	mkSect("FOV")
	V.setCustomFovVisual = mkToggle("FOV", function(on) if on then enableCustomFov() else disableCustomFov() end end)
	do local row=mkRow(40);mkLabel(row,"Field of View");V.customFovBox=mkBox(row,V.customFovValue,64,72,function(v) if v>=30 and v<=120 then V.customFovValue=v;if V.customFovEnabled then enableCustomFov() end else V.customFovBox.Text=tostring(V.customFovValue) end;saveConfig() end) end
	-- ===== PORTED FROM MISERY DUELS =====
	mkSect("Anti Die")
	V.setAntiDieVisual = mkToggle("Anti Die", function(on) V.setAntiDie(on) end)
	mkSect("No Collision")
	V.setNoCollideVisual = mkToggle("No Collision", function(on) V.noCollideEnabled=on;if on then V.startNoCollide() else V.stopNoCollide() end end)
	mkSect("Avatar")
	V.setHeadlessVisual = mkToggle("Headless", function(on) V.headlessEnabled=on;if on then V.applyHeadless() else V.stopHeadless() end end)
	V.setKorbloxVisual = mkToggle("Korblox", function(on) V.korbloxEnabled=on;if on then V.applyKorblox() else V.stopKorblox() end end)
	mkSect("Animation Pack")
	do
		local row=mkRow(42);mkLabel(row,"Animation Pack")
		local left=Instance.new("TextButton",row);left.Size=UDim2.new(0,40,0,28);left.Position=UDim2.new(1,-150,0.5,-14);left.BackgroundColor3=Color3.fromRGB(12,12,12);left.BorderSizePixel=0;left.Text="<";left.TextColor3=THEME_ACCENT;left.Font=Enum.Font.GothamBold;left.TextSize=14;left.AutoButtonColor=false;left.ZIndex=8
		Instance.new("UICorner",left).CornerRadius=UDim.new(0,8)
		local val=Instance.new("TextLabel",row);val.Size=UDim2.new(0,60,1,0);val.Position=UDim2.new(1,-106,0,0);val.BackgroundTransparency=1;val.Text=V.animationPack;val.TextColor3=W;val.Font=Enum.Font.GothamBold;val.TextSize=11;val.TextXAlignment=Enum.TextXAlignment.Center;val.ZIndex=8
		V.animPackValLbl=val
		local right=Instance.new("TextButton",row);right.Size=UDim2.new(0,40,0,28);right.Position=UDim2.new(1,-46,0.5,-14);right.BackgroundColor3=Color3.fromRGB(12,12,12);right.BorderSizePixel=0;right.Text=">";right.TextColor3=THEME_ACCENT;right.Font=Enum.Font.GothamBold;right.TextSize=14;right.AutoButtonColor=false;right.ZIndex=8
		Instance.new("UICorner",right).CornerRadius=UDim.new(0,8)
		local function setPackIndex(nextIndex)
			if nextIndex<1 then nextIndex=#V.animationPackList end
			if nextIndex>#V.animationPackList then nextIndex=1 end
			V.applyAnimationPack(V.animationPackList[nextIndex])
			val.Text=V.animationPack
			saveConfig()
		end
		left.Activated:Connect(function() setPackIndex(V.animGetIndex(V.animationPack)-1) end)
		right.Activated:Connect(function() setPackIndex(V.animGetIndex(V.animationPack)+1) end)
	end
	mkSect("No Cam Collision")
	V.setNoCamCollisionVisual = mkToggle("No Cam Collision", function(on) V.noCamCollisionEnabled=on;V.applyNoCamCollision(on) end)
	mkSect("Ragdoll Countdown")
	V.setRagdollCountdownVisual = mkToggle("Ragdoll Countdown", function(on) V.ragdollCountdownEnabled=on end)
	UIS.InputBegan:Connect(function(input,gpe)
		if _anyKeyListening then return end
		if input.UserInputType==Enum.UserInputType.Keyboard then
			if gpe or UIS:GetFocusedTextBox() then return end
		elseif not isGamepadInput(input) then return end
		if not isBindableInput(input) then return end
		local kc=input.KeyCode
		if kbMatch(KB.LaggerToggle,kc) then
			toggleLaggerMode()
			saveConfig()
		elseif kbMatch(KB.SpeedToggle,kc) then
			toggleCarryMode()
			saveConfig()
		elseif kbMatch(KB.DropBrainrot,kc) then runDrop()
		elseif kbMatch(KB.TPFloor,kc) then runTPFloor()
		elseif kbMatch(KB.InstaReset,kc) then cursedInstaReset()
		elseif kbMatch(KB.AutoLeft,kc) then
			autoLeftEnabled=not autoLeftEnabled
			if autoLeftEnabled then
				queueAutoLeftStart()
			else stopAutoLeft() end
			if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled) end
		elseif kbMatch(KB.AutoRight,kc) then
			autoRightEnabled=not autoRightEnabled
			if autoRightEnabled then
				queueAutoRightStart()
			else stopAutoRight() end
			if autoRightSetVisual then autoRightSetVisual(autoRightEnabled) end
		elseif kbMatch(KB.AutoBat,kc) then
			if not autoBatEnabled then
				queueAutoBatStart()
				if autoBatSetVisual then autoBatSetVisual(true) end
			else
				autoBatEnabled=false;disableAutoBat()
				if autoBatSetVisual then autoBatSetVisual(false) end
			end
		elseif kbMatch(KB.BatTp,kc) then
			V.batTpEnabled = not V.batTpEnabled
			if V.batTpEnabled then V.startBatTp() else V.stopBatTp() end
			if V.setBatTpVisual then V.setBatTpVisual(V.batTpEnabled) end
			saveConfig()
		elseif kbMatch(KB.AntiTpBat,kc) then
			if V.toggleAntiTpBat then V.toggleAntiTpBat() end
		elseif kbMatch(KB.GuiHide,kc) then if main.Visible then hideGui() else showGui() end
		end
	end)
	-- ============================================================
	-- MOBILE BUTTONS (Black buttons that turn red when active)
	-- ============================================================
	local mobileButtons = {}
	-- Mobile buttons no estilo MISERY DUELS: holder + botao com imagem de
	-- fundo (o background escolhido), sombra, texto com contorno, animacao
	-- de "afundar" ao pressionar e posicao arrastavel salva na config.
	-- V.lockMobileButtons trava o arrasto (Lock Mobile Buttons).
	local function makeMobileButton(key, label, onPress)
		local holder = Instance.new("Frame", gui)
		holder.Name = "MBH_"..key
		holder.Size = UDim2.new(0, 72, 0, 66)
		holder.BackgroundTransparency = 1
		holder.BorderSizePixel = 0
		holder.ZIndex = 100
		holder.Active = true
		holder.Visible = not V.hideMobileButtons
		-- Misery: UIScale 0.80 no holder (por isso os botoes nao se encostam
		-- mesmo com o grid de 64x48 de espacamento)
		local holderScale = Instance.new("UIScale", holder)
		holderScale.Name = "MobileButtonScale"
		holderScale.Scale = tonumber(V.mobileBtnScale) or 0.80
		V.mobileScaleObjs = V.mobileScaleObjs or {}
		table.insert(V.mobileScaleObjs, holderScale)
		-- Glow do Misery (fica invisivel no estado normal)
		local glow = Instance.new("Frame", holder)
		glow.Name = "Glow"
		glow.Size = UDim2.new(1, 4, 1, 4)
		glow.Position = UDim2.new(0, -2, 0, -2)
		glow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		glow.BackgroundTransparency = 1
		glow.BorderSizePixel = 0
		glow.ZIndex = 100
		Instance.new("UICorner", glow).CornerRadius = UDim.new(0, 19)
		local glowStroke = Instance.new("UIStroke", glow)
		glowStroke.Color = THEME_ACCENT
		glowStroke.Thickness = 0.8
		glowStroke.Transparency = 1
		glowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		trackTheme(function(c) glowStroke.Color = c end)
		local btn = Instance.new("TextButton", holder)
		btn.Name = "MB_"..key
		btn.Size = UDim2.new(1, 0, 1, 0)
		btn.Position = UDim2.new(0, 0, 0, 0)
		btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		btn.BackgroundTransparency = 0
		btn.BorderSizePixel = 0
		btn.Text = ""
		btn.AutoButtonColor = false
		btn.ZIndex = 102
		btn.Active = true
		btn.ClipsDescendants = true
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 16)
		-- imagem de fundo (usa o background selecionado na aba Customization)
		local bgPic = Instance.new("ImageLabel", btn)
		bgPic.Name = "BackgroundPicture"
		bgPic.Size = UDim2.new(1, 0, 1, 0)
		bgPic.BackgroundTransparency = 1
		bgPic.BorderSizePixel = 0
		bgPic.Image = "rbxassetid://"..tostring(V.sidebarArt or CURRENT_ART_ID)
		bgPic.ImageTransparency = 1   -- sem fundo: visual liso
		bgPic.Visible = false
		bgPic.ScaleType = Enum.ScaleType.Crop
		bgPic.ZIndex = 102
		bgPic.Active = false
		Instance.new("UICorner", bgPic).CornerRadius = UDim.new(0, 16)
		local shade = Instance.new("Frame", btn)
		shade.Name = "BackgroundShade"
		shade.Size = UDim2.new(1, 0, 1, 0)
		shade.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		shade.BackgroundTransparency = 1
		shade.BorderSizePixel = 0
		shade.ZIndex = 103
		shade.Active = false
		Instance.new("UICorner", shade).CornerRadius = UDim.new(0, 16)
		local txt = Instance.new("TextLabel", btn)
		txt.Name = "ButtonText"
		txt.Size = UDim2.new(1, -8, 1, -6)
		txt.Position = UDim2.new(0, 4, 0, 3)
		txt.BackgroundTransparency = 1
		txt.Text = label
		txt.TextColor3 = Color3.fromRGB(245, 245, 250)
		txt.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
		txt.TextStrokeTransparency = 1
		txt.Font = Enum.Font.GothamBold
		txt.TextSize = 11
		txt.TextWrapped = true
		txt.ZIndex = 104
		txt.Active = false
		local stroke = Instance.new("UIStroke", btn)
		stroke.Thickness = 1
		stroke.Transparency = 1
		stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		stroke.Color = THEME_ACCENT:Lerp(Color3.new(0,0,0), 0.62)
		V.mobileBgPics = V.mobileBgPics or {}
		table.insert(V.mobileBgPics, bgPic)
		local active = false
		local function setActive(state)
			active = state == true
			local st = active
			-- ativo = cor do tema (em vez do branco fixo do Misery)
			TS:Create(btn, TweenInfo.new(0.18), {
				BackgroundColor3 = st and THEME_ACCENT or Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 0,
			}):Play()
			TS:Create(txt, TweenInfo.new(0.18), {
				TextColor3 = st and Color3.fromRGB(255,255,255) or Color3.fromRGB(235,235,240),
			}):Play()
		end
		trackTheme(function(_) setActive(active) end)
		-- press + drag (Misery): afunda ao pressionar, arrasta se mover >6px
		local pressing, dragging = false, false
		local pressPos, holderStart = nil, nil
		btn.InputBegan:Connect(function(i)
			if i.UserInputType~=Enum.UserInputType.MouseButton1 and i.UserInputType~=Enum.UserInputType.Touch then return end
			pressing = true; dragging = false
			pressPos = i.Position; holderStart = holder.Position
			setActive(true)
			pcall(function()
				TS:Create(btn, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					Position = UDim2.new(0, 0, 0, 4),
					Size = UDim2.new(1, 0, 1, -4),
				}):Play()
			end)
		end)
		btn.InputEnded:Connect(function(i)
			if i.UserInputType~=Enum.UserInputType.MouseButton1 and i.UserInputType~=Enum.UserInputType.Touch then return end
			local wasDragging = dragging
			if pressing and not dragging and onPress then pcall(onPress, btn) end
			pressing = false; dragging = false
			if wasDragging then
				V.mobileBtnPos = V.mobileBtnPos or {}
				if V.mobileMoveAll then
					-- salva a posicao de todos (o grupo inteiro se moveu)
					for k2, d2 in pairs(mobileButtons) do
						if d2.holder then
							local pp = d2.holder.Position
							V.mobileBtnPos[k2] = {pp.X.Scale, pp.X.Offset, pp.Y.Scale, pp.Y.Offset}
						end
					end
					V._moveAllStart = nil
				else
					V.mobileBtnPos[key] = {holder.Position.X.Scale, holder.Position.X.Offset, holder.Position.Y.Scale, holder.Position.Y.Offset}
				end
				saveConfig()
			end
			pcall(function()
				TS:Create(btn, TweenInfo.new(0.10, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					Position = UDim2.new(0, 0, 0, 0),
					Size = UDim2.new(1, 0, 1, 0),
				}):Play()
			end)
			task.delay(0.08, function()
				if btn and btn.Parent then setActive(mobileButtons[key] and mobileButtons[key].active) end
			end)
		end)
		UIS.InputChanged:Connect(function(i)
			if V.lockMobileButtons or not pressing then return end
			if i.UserInputType~=Enum.UserInputType.MouseMovement and i.UserInputType~=Enum.UserInputType.Touch then return end
			local delta = i.Position - pressPos
			if not dragging and (math.abs(delta.X)>6 or math.abs(delta.Y)>6) then
				dragging = true
				-- "Move All": guarda a posicao inicial de TODOS os botoes
				if V.mobileMoveAll then
					V._moveAllStart = {}
					for k2, d2 in pairs(mobileButtons) do
						if d2.holder then V._moveAllStart[k2] = d2.holder.Position end
					end
				end
			end
			if dragging then
				if V.mobileMoveAll and V._moveAllStart then
					-- arrasta o grupo inteiro mantendo o espacamento
					for k2, st2 in pairs(V._moveAllStart) do
						local d2 = mobileButtons[k2]
						if d2 and d2.holder then
							d2.holder.Position = UDim2.new(st2.X.Scale, st2.X.Offset+delta.X, st2.Y.Scale, st2.Y.Offset+delta.Y)
						end
					end
				else
					holder.Position = UDim2.new(holderStart.X.Scale, holderStart.X.Offset+delta.X, holderStart.Y.Scale, holderStart.Y.Offset+delta.Y)
				end
			end
		end)
		V.mobileBtnLabels = V.mobileBtnLabels or {}
		V.mobileBtnLabels[key] = (label:gsub("\n", " "))
		V.mobileBtnOrder = V.mobileBtnOrder or {}
		table.insert(V.mobileBtnOrder, key)
		holder.Visible = (not V.hideMobileButtons) and V.isMobileBtnOn(key)
		mobileButtons[key] = {holder=holder, btn=btn, stroke=stroke, setActive=function(st)
			if mobileButtons[key] then mobileButtons[key].active = st == true end
			setActive(st)
		end, active=false}
		return mobileButtons[key].setActive
	end
	V.mobileButtons = mobileButtons
	-- liga/desliga todos os mobile buttons
	-- cada botao tem seu proprio "ligado/desligado" (V.mobileBtnOn[key]).
	-- Um botao so aparece se os mobile buttons estiverem ligados E ele
	-- estiver ativado na lista do menu (flecha do "Mobile Buttons").
	V.mobileBtnOn = V.mobileBtnOn or {}
	V.isMobileBtnOn = function(key)
		local v = V.mobileBtnOn[key]
		if v == nil then return true end
		return v == true
	end
	V.refreshMobileButtonsVisible = function()
		local master = not V.hideMobileButtons
		for k, d in pairs(mobileButtons) do
			if d.holder then d.holder.Visible = master and V.isMobileBtnOn(k) end
		end
	end
	V.setMobileButtonEnabled = function(key, on)
		V.mobileBtnOn[key] = on == true
		if V.refreshMobileButtonsVisible then V.refreshMobileButtonsVisible() end
	end
	-- volta todos os mobile buttons pras posicoes padrao do grid
	V.resetMobileBtnPos = function()
		V.mobileBtnPos = {}
		if V.rebuildMobileGrid then pcall(V.rebuildMobileGrid) end
		local defs = V.mobileDefaults
		if not defs then return false end
		for key, d in pairs(V.mobileButtons or {}) do
			if d.holder and d.holder.Parent and defs[key] then
				d.holder.Position = defs[key]
			end
		end
		V.mobileBtnPos = {}
		return true
	end
	-- tamanho dos mobile buttons (UIScale de cada holder)
	V.setMobileBtnScale = function(v)
		v = math.clamp(tonumber(v) or 0.80, 0.50, 1.60)
		v = math.floor(v * 100 + 0.5) / 100
		V.mobileBtnScale = v
		-- varre de tras pra frente removendo os que ja morreram
		local list = V.mobileScaleObjs or {}
		for i = #list, 1, -1 do
			local sc = list[i]
			if sc and sc.Parent then sc.Scale = v else table.remove(list, i) end
		end
		if V.mobileScaleLbl and V.mobileScaleLbl.Parent then
			V.mobileScaleLbl.Text = string.format("%d%%", math.floor(v * 100 + 0.5))
		end
		-- o passo do grid depende da escala: recalcula pra continuar alinhado
		if V.rebuildMobileGrid then pcall(V.rebuildMobileGrid) end
		if V.mobileScalePlus and V.mobileScalePlus.Parent then
			V.mobileScalePlus.Visible = v < 1.60 - 0.0001
		end
		if V.mobileScaleMinus and V.mobileScaleMinus.Parent then
			V.mobileScaleMinus.Visible = v > 0.50 + 0.0001
		end
	end
	V.setMobileButtonsVisible = function(on)
		V.hideMobileButtons = not on
		if V.refreshMobileButtonsVisible then V.refreshMobileButtonsVisible() end
	end
	-- troca a imagem de fundo dos mobile buttons junto com o background da UI
	V.refreshMobileBg = function(id)
		for _, pic in ipairs(V.mobileBgPics or {}) do
			if pic and pic.Parent then pic.Image = "rbxassetid://"..tostring(id) end
		end
	end
	-- Drop Brainrot
	makeMobileButton("tpBat", "TP\nBAT", function()
		V.batTpEnabled = not V.batTpEnabled
		if V.batTpEnabled then V.startBatTp() else V.stopBatTp() end
		if V.setBatTpVisual then V.setBatTpVisual(V.batTpEnabled) end
		if mobileButtons["tpBat"] then mobileButtons["tpBat"].setActive(V.batTpEnabled) end
		saveConfig()
	end)
	makeMobileButton("drop", "DROP\nBR", function()
		runDrop()
		local act = mobileButtons["drop"].setActive
		act(true)
		task.delay(0.2, function() act(false) end)
	end)
	-- Auto Left
	makeMobileButton("autoLeft", "AUTO\nLEFT", function()
		if autoLeftEnabled then
			autoLeftEnabled = false; stopAutoLeft(); if autoLeftSetVisual then autoLeftSetVisual(false) end
			mobileButtons["autoLeft"].setActive(false)
		else
			if autoRightEnabled then autoRightEnabled=false; stopAutoRight(); if autoRightSetVisual then autoRightSetVisual(false) end; mobileButtons["autoRight"].setActive(false) end
			if autoBatEnabled then autoBatEnabled=false; disableAutoBat(); if autoBatSetVisual then autoBatSetVisual(false) end; mobileButtons["autoBat"].setActive(false) end
			autoLeftEnabled = true; queueAutoLeftStart(); if autoLeftSetVisual then autoLeftSetVisual(true) end
			mobileButtons["autoLeft"].setActive(true)
		end
		saveConfig()
	end)
	-- Auto Bat
	makeMobileButton("autoBat", "BAT\nBOT", function()
		if autoBatEnabled then
			autoBatEnabled = false; disableAutoBat(); if autoBatSetVisual then autoBatSetVisual(false) end
			mobileButtons["autoBat"].setActive(false)
		else
			if autoLeftEnabled then autoLeftEnabled=false; stopAutoLeft(); if autoLeftSetVisual then autoLeftSetVisual(false) end; mobileButtons["autoLeft"].setActive(false) end
			if autoRightEnabled then autoRightEnabled=false; stopAutoRight(); if autoRightSetVisual then autoRightSetVisual(false) end; mobileButtons["autoRight"].setActive(false) end
			autoBatEnabled = true; queueAutoBatStart(); if autoBatSetVisual then autoBatSetVisual(true) end
			mobileButtons["autoBat"].setActive(true)
		end
		saveConfig()
	end)
	-- Auto Right
	makeMobileButton("autoRight", "AUTO\nRIGHT", function()
		if autoRightEnabled then
			autoRightEnabled = false; stopAutoRight(); if autoRightSetVisual then autoRightSetVisual(false) end
			mobileButtons["autoRight"].setActive(false)
		else
			if autoLeftEnabled then autoLeftEnabled=false; stopAutoLeft(); if autoLeftSetVisual then autoLeftSetVisual(false) end; mobileButtons["autoLeft"].setActive(false) end
			if autoBatEnabled then autoBatEnabled=false; disableAutoBat(); if autoBatSetVisual then autoBatSetVisual(false) end; mobileButtons["autoBat"].setActive(false) end
			autoRightEnabled = true; queueAutoRightStart(); if autoRightSetVisual then autoRightSetVisual(true) end
			mobileButtons["autoRight"].setActive(true)
		end
		saveConfig()
	end)
	-- TP Down
	-- Instant Reset (portado do Cursed Hub) — botao de acao (nao fica ligado)
	makeMobileButton("instaReset", "INSTANT\nRESET", function()
		cursedInstaReset()
		-- feedback visual: acende e apaga (nao e um toggle)
		if mobileButtons["instaReset"] then
			mobileButtons["instaReset"].setActive(true)
			task.delay(0.25, function()
				if mobileButtons["instaReset"] then mobileButtons["instaReset"].setActive(false) end
			end)
		end
	end)
	makeMobileButton("antiTpBat", "ANTI\nTP BAT", function()
		if V.toggleAntiTpBat then V.toggleAntiTpBat() end
	end)
	makeMobileButton("tp", "TP\nDOWN", function()
		runTPFloor()
		local act = mobileButtons["tp"].setActive
		act(true)
		task.delay(0.2, function() act(false) end)
	end)
	-- Tooze: 3 speed buttons — radio behavior (only one active at a time)
	local function _refreshSpeedRadios()
		local isCarry       = (not laggerToggled) and speedMode
		local isLaggerNorm  = laggerToggled and laggerPhase == 1
		local isLaggerCarry = laggerToggled and laggerPhase == 2
		if mobileButtons["carry"]        then mobileButtons["carry"].setActive(isCarry) end
		if mobileButtons["laggerNormal"] then mobileButtons["laggerNormal"].setActive(isLaggerNorm) end
		if mobileButtons["laggerCarry"]  then mobileButtons["laggerCarry"].setActive(isLaggerCarry) end
	end
	makeMobileButton("carry", "CARRY\nSPEED", function()
		if speedMode and not laggerToggled then
			speedMode = false  -- toggle off → normal walk
		else
			speedMode = true; laggerToggled = false; laggerPhase = 0
		end
		refreshSpeedModeLabel()
		_refreshSpeedRadios()
		saveConfig()
	end)
	makeMobileButton("laggerNormal", "LAGGER\nNORMAL", function()
		if laggerToggled and laggerPhase == 1 then
			laggerToggled = false; laggerPhase = 0
		else
			speedMode = false; laggerToggled = true; laggerPhase = 1
		end
		refreshSpeedModeLabel()
		_refreshSpeedRadios()
		saveConfig()
	end)
	makeMobileButton("laggerCarry", "LAGGER\nCARRY", function()
		if laggerToggled and laggerPhase == 2 then
			laggerToggled = false; laggerPhase = 0
		else
			speedMode = false; laggerToggled = true; laggerPhase = 2
		end
		refreshSpeedModeLabel()
		_refreshSpeedRadios()
		saveConfig()
	end)
	-- Posicoes padrao (grade do Misery) + restauracao das posicoes salvas
	V.rebuildMobileGrid = function()
		-- Grid alinhado: o holder e 72x66 mas o UIScale encolhe o que aparece
		-- na tela, entao o passo tem que sair do tamanho RENDERIZADO, senao
		-- a folga horizontal e a vertical ficam diferentes (desalinhado).
		local sc = tonumber(V.mobileBtnScale) or 0.80
		local gap = 8                       -- mesma folga nos dois eixos
		local stepX = math.floor(72 * sc + gap + 0.5)
		local stepY = math.floor(66 * sc + gap + 0.5)
		local x3 = -(math.floor(72 * sc + 0.5) + 12)   -- coluna da direita
		local x2 = x3 - stepX
		local x1 = x2 - stepX
		local y1 = -math.floor(stepY * 1.5 + 0.5) - 40   -- 4 linhas, subidas 40px
		local y2 = y1 + stepY
		local y3 = y2 + stepY
		local y4 = y3 + stepY
		local defaults = {
			tpBat        = UDim2.new(1, x1, 0.5, y1),
			drop         = UDim2.new(1, x2, 0.5, y1),
			autoLeft     = UDim2.new(1, x3, 0.5, y1),
			autoBat      = UDim2.new(1, x2, 0.5, y2),
			autoRight    = UDim2.new(1, x3, 0.5, y2),
			tp           = UDim2.new(1, x2, 0.5, y3),
			instaReset   = UDim2.new(1, x1, 0.5, y2),
			antiTpBat    = UDim2.new(1, x1, 0.5, y3),
			carry        = UDim2.new(1, x3, 0.5, y3),
			laggerNormal = UDim2.new(1, x2, 0.5, y4),
			laggerCarry  = UDim2.new(1, x3, 0.5, y4),
		}
		V.mobileDefaults = defaults
		V.mobileBtnPos = V.mobileBtnPos or {}
		for key, d in pairs(mobileButtons) do
			local saved = V.mobileBtnPos[key]
			if type(saved) == "table" and #saved == 4 then
				d.holder.Position = UDim2.new(saved[1], saved[2], saved[3], saved[4])
			else
				d.holder.Position = defaults[key] or UDim2.new(1, x3, 0.5, 0)
			end
		end
	end
	V.rebuildMobileGrid()
	if V.refreshMobileButtonsVisible then V.refreshMobileButtonsVisible() end
	if V.buildMobileBtnList then V.buildMobileBtnList() end
	-- Sync loop to keep mobile buttons' active states in sync with internal variables
	task.spawn(function()
		while true do
			task.wait(0.5)
			if mobileButtons["autoLeft"] then mobileButtons["autoLeft"].setActive(autoLeftEnabled) end
			if mobileButtons["autoRight"] then mobileButtons["autoRight"].setActive(autoRightEnabled) end
			if mobileButtons["autoBat"] then mobileButtons["autoBat"].setActive(autoBatEnabled) end
			if mobileButtons["tpBat"] then mobileButtons["tpBat"].setActive(V.batTpEnabled == true) end
			if mobileButtons["carry"] then mobileButtons["carry"].setActive((not laggerToggled) and speedMode) end
			if mobileButtons["laggerNormal"] then mobileButtons["laggerNormal"].setActive(laggerToggled and laggerPhase == 1) end
			if mobileButtons["laggerCarry"] then mobileButtons["laggerCarry"].setActive(laggerToggled and laggerPhase == 2) end
		end
	end)
	-- Carrega cor + background ANTES da intro, senao ela sempre roda
	-- na cor padrao (o loadConfig completo so acontece depois da UI).
	pcall(function()
		if not (isfile and isfile("Tooze.json")) then return end
		local ok, cfg = pcall(function() return HS:JSONDecode(readfile("Tooze.json")) end)
		if not ok or not cfg then return end
		if type(cfg.themeAccent) == "table" and #cfg.themeAccent == 3 then
			V.themeAccent = cfg.themeAccent
			if setAccent_global then
				setAccent_global(Color3.new(cfg.themeAccent[1], cfg.themeAccent[2], cfg.themeAccent[3]))
			end
			if V.refreshSwatches then V.refreshSwatches() end
		end
		if type(cfg.sidebarArt) == "string" and #cfg.sidebarArt > 6 then
			if setSidebarArt_global then setSidebarArt_global(cfg.sidebarArt) end
			if V.refreshMobileBg then V.refreshMobileBg(cfg.sidebarArt) end
			if V.refreshBgPicker then V.refreshBgPicker() end
		end
		if cfg.introEnabled ~= nil then _introEnabled = cfg.introEnabled == true end
	end)
	-- Tooze: CINEMATIC INTRO (15s) — electric aura: god rays, energy core, lightning, embers, gradient title, tap to skip
	if _introEnabled then
		local origSize = main.Size
		main.Size = UDim2.new(0, 0, 0, 0)
		task.spawn(function()
			local introStartedAt = tick()
			local introGui = Instance.new("ScreenGui", gui.Parent)
			introGui.Name = "ToozeIntro"
			introGui.IgnoreGuiInset = true
			introGui.DisplayOrder = 100
			introGui.ResetOnSpawn = false
			-- Dark background
			local darkBg = Instance.new("Frame", introGui)
			darkBg.Size = UDim2.new(1, 0, 1, 0)
			darkBg.BackgroundColor3 = Color3.fromRGB(4, 6, 16)
			darkBg.BackgroundTransparency = 1
			darkBg.BorderSizePixel = 0
			darkBg.ZIndex = 1
			local bgGrad = Instance.new("UIGradient", darkBg)
			bgGrad.Color = ColorSequence.new(THEME_ACCENT_DIM:Lerp(Color3.new(0,0,0), 0.72), Color3.fromRGB(2, 3, 10))
			bgGrad.Rotation = 90
			-- Vignette (dark corners)
			local vignette = Instance.new("Frame", introGui)
			vignette.Size = UDim2.new(1, 0, 1, 0)
			vignette.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			vignette.BackgroundTransparency = 1
			vignette.BorderSizePixel = 0
			vignette.ZIndex = 2
			local vigGrad = Instance.new("UIGradient", vignette)
			vigGrad.Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0.1),
				NumberSequenceKeypoint.new(0.5, 0.85),
				NumberSequenceKeypoint.new(1, 0.1),
			})
			-- =========================================================
			-- EMBERS (floating particles drifting upward)
			-- =========================================================
			local embers = {}
			for i = 1, 40 do
				local s = Instance.new("Frame", introGui)
				local size = math.random(2, 5)
				s.Size = UDim2.new(0, size, 0, size)
				s.Position = UDim2.new(math.random(), 0, math.random(), 0)
				s.BackgroundColor3 = THEME_ACCENT_BRIGHT
				s.BackgroundTransparency = 1
				s.BorderSizePixel = 0
				s.ZIndex = 2
				Instance.new("UICorner", s).CornerRadius = UDim.new(1, 0)
				embers[i] = {
					frame = s,
					speed = 0.002 + math.random() * 0.006,
					sway = math.random() * 6.28,
					targetTrans = 0.1 + math.random() * 0.5,
				}
			end
			-- Master animation loop (embers drift)
			local introActive = true
			local animTime = 0
			local driftConn = RunService.Heartbeat:Connect(function(dt)
				if not introActive then return end
				animTime = animTime + dt
				for _, e in ipairs(embers) do
					local pos = e.frame.Position
					local newY = pos.Y.Scale - e.speed
					if newY < -0.03 then newY = 1.03 end
					local newX = pos.X.Scale + math.sin(animTime * 1.5 + e.sway) * 0.0006
					e.frame.Position = UDim2.new(math.clamp(newX, 0, 1), 0, newY, 0)
				end
			end)
			-- Lightning helper: jagged bolt + screen flash
			local function flashLightning(xScale)
				if not introActive then return end
				local y = 0.05
				local x = xScale or 0.5
				local segs = {}
				while y < 0.95 do
					local s = Instance.new("Frame", introGui)
					s.Size = UDim2.new(0, 3, 0.055, 0)
					s.Position = UDim2.new(x, 0, y, 0)
					s.BackgroundColor3 = THEME_ACCENT_BRIGHT
					s.BackgroundTransparency = 0
					s.BorderSizePixel = 0
					s.ZIndex = 20
					local st = Instance.new("UIStroke", s)
					st.Color = THEME_ACCENT
					st.Thickness = 2
					st.Transparency = 0.2
					segs[#segs + 1] = s
					x = math.clamp(x + (math.random() - 0.5) * 0.09, 0.02, 0.98)
					y = y + 0.055
				end
				local flash = Instance.new("Frame", introGui)
				flash.Size = UDim2.new(1, 0, 1, 0)
				flash.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				flash.BackgroundTransparency = 1
				flash.BorderSizePixel = 0
				flash.ZIndex = 19
				TS:Create(flash, TweenInfo.new(0.05), {BackgroundTransparency = 0.32}):Play()
				task.delay(0.05, function()
					if flash.Parent then TS:Create(flash, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play() end
				end)
				task.delay(0.16, function()
					for _, sg in ipairs(segs) do pcall(function() sg:Destroy() end) end
					pcall(function() flash:Destroy() end)
				end)
			end
			-- Skip infrastructure: tap anywhere / click the label to skip
			local function finishIntro()
				if not introActive then return end
				introActive = false
				stopIntroMusic()
				pcall(function() driftConn:Disconnect() end)
				pcall(function() main.Size = origSize end)
				pcall(function() introGui:Destroy() end)
			end
			local function w(t)
				local steps = math.max(1, math.ceil(t / 0.05))
				for _ = 1, steps do
					if not introActive then return true end
					task.wait(0.05)
				end
				return not introActive
			end
			-- Full-screen invisible tap catcher (skips on any click)
			local tapSkip = Instance.new("TextButton", introGui)
			tapSkip.Size = UDim2.new(1, 0, 1, 0)
			tapSkip.BackgroundTransparency = 1
			tapSkip.BorderSizePixel = 0
			tapSkip.Text = ""
			tapSkip.AutoButtonColor = false
			tapSkip.ZIndex = 90
			tapSkip.MouseButton1Click:Connect(finishIntro)
			-- "TAP TO SKIP INTRO" label at the bottom
			local skipLabel = Instance.new("TextLabel", introGui)
			skipLabel.AnchorPoint = Vector2.new(0.5, 1)
			skipLabel.Position = UDim2.new(0.5, 0, 1, -28)
			skipLabel.Size = UDim2.new(0, 420, 0, 24)
			skipLabel.BackgroundTransparency = 1
			skipLabel.Text = "TAP TO SKIP INTRO"
			skipLabel.TextColor3 = THEME_ACCENT_BRIGHT
			skipLabel.TextTransparency = 1
			skipLabel.Font = Enum.Font.GothamBold
			skipLabel.TextSize = 14
			skipLabel.ZIndex = 91
			task.delay(0.8, function()
				if not introActive or not skipLabel.Parent then return end
				TS:Create(skipLabel, TweenInfo.new(0.4), {TextTransparency = 0.15}):Play()
			end)
			startIntroMusic()
			-- Title container
			local center = Instance.new("Frame", introGui)
			center.AnchorPoint = Vector2.new(0.5, 0.5)
			center.Position = UDim2.new(0.5, 0, 0.5, 0)
			center.Size = UDim2.new(0, 600, 0, 240)
			center.BackgroundTransparency = 1
			center.ZIndex = 5
			-- Scale controller for the title entrance/exit animation
			local centerScale = Instance.new("UIScale", center)
			centerScale.Scale = 0.9
			-- (linha de cima removida — agora existe UMA linha unica entre titulo e subtitulo)
			local lineTop = Instance.new("Frame", center)
			lineTop.Size = UDim2.new(0, 0, 0, 0); lineTop.BackgroundTransparency = 1
			lineTop.Visible = false; lineTop.BorderSizePixel = 0; lineTop.ZIndex = 1
			-- GRADIENT TITLE (single label + UIGradient: white → gray → white)
			local title = Instance.new("TextLabel", center)
			title.Size = UDim2.new(1, 0, 0, 90); title.Position = UDim2.new(0, 0, 0, 70)
			title.BackgroundTransparency = 1
			title.Text = "VEXUS HUB"
			title.Font = Enum.Font.GothamBlack; title.TextSize = 76
			title.TextColor3 = Color3.fromRGB(255, 255, 255)
			title.TextXAlignment = Enum.TextXAlignment.Center
			title.TextTransparency = 1; title.TextStrokeTransparency = 1
			title.TextStrokeColor3 = THEME_ACCENT; title.ZIndex = 7
			-- GRADIENTE igual ao do texto acima da cabeca, SEGUINDO O TEMA selecionado
			local function introSeq()
				return ColorSequence.new({
					ColorSequenceKeypoint.new(0.00, THEME_ACCENT_DIM),
					ColorSequenceKeypoint.new(0.45, THEME_ACCENT_BRIGHT),
					ColorSequenceKeypoint.new(0.55, THEME_ACCENT_BRIGHT),
					ColorSequenceKeypoint.new(1.00, THEME_ACCENT_DIM),
				})
			end
			local titleGrad = Instance.new("UIGradient", title)
			titleGrad.Color = introSeq()
			local subtitle = Instance.new("TextLabel", center)
			subtitle.Size = UDim2.new(1, 0, 0, 24); subtitle.Position = UDim2.new(0, 0, 0, 182)
			subtitle.BackgroundTransparency = 1; subtitle.Text = "by LKZZ"
			subtitle.TextColor3 = THEME_ACCENT; subtitle.Font = Enum.Font.GothamMedium
			subtitle.TextSize = 18; subtitle.TextTransparency = 1; subtitle.ZIndex = 7
			subtitle.TextColor3 = Color3.fromRGB(255,255,255)
			local subGrad = Instance.new("UIGradient", subtitle)
			subGrad.Color = introSeq()
			-- LINHA UNICA no meio, entre o titulo e o subtitulo
			local lineBot = Instance.new("Frame", center)
			lineBot.AnchorPoint = Vector2.new(0.5, 0.5); lineBot.Position = UDim2.new(0.5, 0, 0, 168)
			lineBot.Size = UDim2.new(0, 0, 0, 2); lineBot.BackgroundColor3 = Color3.fromRGB(255,255,255)
			lineBot.BorderSizePixel = 0; lineBot.ZIndex = 6
			Instance.new("UICorner", lineBot).CornerRadius = UDim.new(1, 0)
			-- gradiente da linha: some nas pontas e brilha no meio (mesmo estilo do texto da cabeca)
			local lineGrad = Instance.new("UIGradient", lineBot)
			lineGrad.Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.15, 0.15),
				NumberSequenceKeypoint.new(0.5, 0), NumberSequenceKeypoint.new(0.85, 0.15),
				NumberSequenceKeypoint.new(1, 1),
			})
			lineGrad.Color = introSeq()
			lineGrad.Offset = Vector2.new(0, 0) -- FIXA: gradiente parado, sem shimmer correndo
			-- troca de tema no meio da intro: atualiza os 3 gradientes na hora
			trackTheme(function(_)
				local sq = introSeq()
				if titleGrad.Parent then titleGrad.Color = sq end
				if subGrad.Parent then subGrad.Color = sq end
				if lineGrad.Parent then lineGrad.Color = sq end
				if skipLabel and skipLabel.Parent then skipLabel.TextColor3 = THEME_ACCENT_BRIGHT end
				if title.Parent then title.TextStrokeColor3 = THEME_ACCENT end
				for _, d in ipairs(center:GetDescendants()) do
					if d:IsA("UIGradient") and d ~= lineGrad then d.Color = sq end
				end
			end)
			-- =========================================================
			-- TITULO LETRA POR LETRA: cada letra e um label proprio que
			-- flutua suavemente (onda senoidal defasada) — bem sutil.
			-- =========================================================
			local letterHolder = Instance.new("Frame", center)
			letterHolder.BackgroundTransparency = 1
			letterHolder.Position = title.Position
			letterHolder.Size = title.Size
			letterHolder.ZIndex = title.ZIndex
			letterHolder.Visible = false
			local letters = {}
			do
				local txt = title.Text
				local chars = {}
				for c in txt:gmatch(".") do table.insert(chars, c) end
				-- mede cada caractere pra posicionar tudo centralizado de verdade
				local widths, total = {}, 0
				for idx, c in ipairs(chars) do
					local wpx = 0
					if c == " " then
						wpx = title.TextSize * 0.32
					else
						local ok, sz = pcall(function()
							return game:GetService("TextService"):GetTextSize(c, title.TextSize, title.Font, Vector2.new(9999, 9999))
						end)
						wpx = (ok and sz and sz.X) or (title.TextSize * 0.6)
					end
					widths[idx] = wpx
					total = total + wpx
				end
				local x = -total / 2
				for idx, c in ipairs(chars) do
					local wpx = widths[idx]
					if c ~= " " then
						local l = Instance.new("TextLabel", letterHolder)
						l.AnchorPoint = Vector2.new(0.5, 0.5)
						l.BackgroundTransparency = 1
						l.Size = UDim2.new(0, wpx + 8, 1, 0)
						l.Position = UDim2.new(0.5, x + wpx / 2, 0.5, 0)
						l.Text = c
						l.Font = title.Font
						l.TextSize = title.TextSize
						l.TextColor3 = Color3.fromRGB(255, 255, 255)
						l.TextStrokeColor3 = THEME_ACCENT
						l.TextStrokeTransparency = 0.25
						l.ZIndex = title.ZIndex
						local lg = Instance.new("UIGradient", l)
						lg.Color = introSeq()
						local ls = Instance.new("UIScale", l)
						table.insert(letters, {
							lbl = l, grad = lg, scale = ls,
							baseX = x + wpx / 2, phase = (#letters) * 0.55,
						})
					end
					x = x + wpx
				end
			end
			-- movimento suave: cada letra sobe/desce e gira de leve, defasada
			task.spawn(function()
				local t0 = tick()
				while introActive and letterHolder.Parent do
					local t = tick() - t0
					for idx, L in ipairs(letters) do
						if not L.lbl.Parent then break end
						local ph = t * 1.7 + L.phase
						local yoff = math.sin(ph) * 5             -- flutua ~5px
						L.lbl.Position = UDim2.new(0.5, L.baseX or L.lbl.Position.X.Offset, 0.5, yoff)
						L.lbl.Rotation = math.sin(ph + 0.6) * 2.5  -- inclina ~2.5 graus
						L.scale.Scale = 1 + math.sin(ph * 0.8) * 0.035
					end
					task.wait()
				end
			end)
			-- shimmer: brilho correndo pelas letras (defasado = onda de luz) e no subtitulo
			task.spawn(function()
				local t0 = tick()
				while introActive and center.Parent do
					local base = ((tick() - t0) * 0.55) % 2 - 1
					local o = Vector2.new(base, 0)
					titleGrad.Offset = o; subGrad.Offset = o
					for idx, L in ipairs(letters) do
						if L.grad.Parent then
							local v = ((base + 1 - (idx - 1) * 0.09) % 2) - 1
							L.grad.Offset = Vector2.new(v, 0)
						end
					end
					task.wait(0.03)
				end
			end)
			-- =========================================================
			-- FRAGMENTOS: usados na CONSTRUCAO (entrada) e na
			-- QUEBRA (saida) do titulo e do subtitulo.
			-- Cada fragmento e uma copia do label recortada por um
			-- ClipsDescendants, entao a soma deles forma o texto inteiro.
			-- =========================================================
			local function makeShards(label, cols, rows)
				local holder = Instance.new("Frame", center)
				holder.BackgroundTransparency = 1
				holder.Position = label.Position
				holder.Size = label.Size
				holder.ZIndex = label.ZIndex
				holder.Visible = false
				local shards = {}
				for cx = 0, cols - 1 do
					for cy = 0, rows - 1 do
						local cell = Instance.new("Frame", holder)
						cell.BackgroundTransparency = 1
						cell.BorderSizePixel = 0
						cell.ClipsDescendants = true
						cell.Size = UDim2.new(1 / cols, 0, 1 / rows, 0)
						cell.Position = UDim2.new(cx / cols, 0, cy / rows, 0)
						cell.ZIndex = label.ZIndex
						local piece = label:Clone()
						piece:ClearAllChildren()
						for _, ch in ipairs(label:GetChildren()) do
							if ch:IsA("UIGradient") then ch:Clone().Parent = piece end
						end
						piece.Parent = cell
						piece.Size = UDim2.new(cols, 0, rows, 0)
						piece.Position = UDim2.new(-cx, 0, -cy, 0)
						piece.TextTransparency = 1
						piece.TextStrokeTransparency = 1
						piece.ZIndex = label.ZIndex
						table.insert(shards, {cell = cell, piece = piece, cx = cx, cy = cy})
					end
				end
				return holder, shards
			end
			local titleShardHolder, titleShards = makeShards(title, 9, 2)
			local subShardHolder, subShards = makeShards(subtitle, 6, 1)
			-- ENTRADA: cada fragmento voa de fora e se encaixa no lugar
			local function buildIn(holder, shards, dur)
				holder.Visible = true
				for _, sh in ipairs(shards) do
					local base = sh.cell.Position
					local ang = math.random() * math.pi * 2
					local dist = 90 + math.random() * 130
					sh.cell.Position = base + UDim2.new(0, math.cos(ang) * dist, 0, math.sin(ang) * dist)
					sh.cell.Rotation = (math.random() - 0.5) * 90
					task.delay(math.random() * dur * 0.55, function()
						if not introActive then return end
						local ti = TweenInfo.new(dur * 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
						TS:Create(sh.cell, ti, {Position = base, Rotation = 0}):Play()
						TS:Create(sh.piece, TweenInfo.new(dur * 0.35), {
							TextTransparency = 0, TextStrokeTransparency = 0.4,
						}):Play()
					end)
				end
			end
			-- SAIDA: os fragmentos se soltam e caem girando
			local function shatterOut(holder, shards, dur)
				holder.Visible = true
				for _, sh in ipairs(shards) do
					local base = sh.cell.Position
					local ang = (math.random() - 0.5) * 2.2
					task.delay(math.random() * dur * 0.3, function()
						local ti = TweenInfo.new(dur, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
						TS:Create(sh.cell, ti, {
							Position = base + UDim2.new(0, math.sin(ang) * 200, 0, 180 + math.random() * 160),
							Rotation = (math.random() - 0.5) * 160,
						}):Play()
						TS:Create(sh.piece, TweenInfo.new(dur * 0.9), {
							TextTransparency = 1, TextStrokeTransparency = 1,
						}):Play()
					end)
				end
			end
			-- =========================================================
			-- PHASE 1 (0.0 - 0.6s): background, vignette, rays + embers fade in
			-- =========================================================
			TS:Create(darkBg, TweenInfo.new(0.5), {BackgroundTransparency = 0.55}):Play()
			TS:Create(vignette, TweenInfo.new(0.6), {BackgroundTransparency = 0.15}):Play()
			for _, e in ipairs(embers) do
				task.delay(math.random() * 0.6, function()
					TS:Create(e.frame, TweenInfo.new(0.6), {BackgroundTransparency = e.targetTrans}):Play()
				end)
			end
			if w(0.6) then return end
			-- =========================================================
			-- PHASE 2 (0.6 - 1.8s): energy core ignites + first lightning
			-- =========================================================
			task.delay(0.4, function() flashLightning(0.25) end)
			if w(1.2) then return end
			-- =========================================================
			-- PHASE 3 (1.8 - 2.6s): title letters reveal (staggered) + lightning
			-- =========================================================
			TS:Create(lineBot, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 420, 0, 3)}):Play()
			TS:Create(centerScale, TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
			if w(0.15) then return end
			-- CONSTRUCAO: os fragmentos voam e montam o titulo
			buildIn(titleShardHolder, titleShards, 0.9)
			task.delay(0.5, function() flashLightning(0.72) end)
			if w(0.95) then return end
			-- troca os fragmentos pelas LETRAS animadas (cada uma se mexendo suave)
			title.TextTransparency = 1
			title.TextStrokeTransparency = 1
			letterHolder.Visible = true
			titleShardHolder.Visible = false
			if w(0.1) then return end
			-- =========================================================
			-- PHASE 4 (2.6 - 3.3s): subtitle + title glow pulse + lightning
			-- =========================================================
			buildIn(subShardHolder, subShards, 0.6)
			if w(0.65) then return end
			subtitle.TextTransparency = 0
			subShardHolder.Visible = false
			if w(0.1) then return end
			for i = 1, 3 do
				for _, L in ipairs(letters) do TS:Create(L.lbl, TweenInfo.new(0.09), {TextStrokeTransparency = 0}):Play() end
				task.wait(0.09)
				for _, L in ipairs(letters) do TS:Create(L.lbl, TweenInfo.new(0.09), {TextStrokeTransparency = 0.3}):Play() end
				task.wait(0.09)
			end
			task.delay(0.3, function() flashLightning(0.5) end)
			if w(0.15) then return end
			-- =========================================================
			-- HOLD: everything keeps animating until 15s total (music plays)
			-- =========================================================
			while introActive and tick() - introStartedAt < 15 - 0.8 do
				task.wait(0.1)
			end
			if not introActive then return end
			-- =========================================================
			-- PHASE 5: Everything fades, panel materializes
			-- =========================================================
			-- QUEBRA: esconde os labels e estilhaca os fragmentos
			for _, sh in ipairs(titleShards) do
				sh.piece.TextTransparency = 0
				sh.piece.TextStrokeTransparency = 0.4
			end
			for _, sh in ipairs(subShards) do sh.piece.TextTransparency = 0 end
			title.TextTransparency = 1
			title.TextStrokeTransparency = 1
			subtitle.TextTransparency = 1
			letterHolder.Visible = false
			shatterOut(titleShardHolder, titleShards, 0.75)
			shatterOut(subShardHolder, subShards, 0.65)
			flashLightning(0.5)
			TS:Create(lineBot, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 3)}):Play()
			TS:Create(darkBg, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()
			TS:Create(vignette, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()
			for _, e in ipairs(embers) do TS:Create(e.frame, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play() end
			task.wait(0.5)
			TS:Create(main, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = origSize}):Play()
			task.wait(0.7)
			introActive = false
			stopIntroMusic()
			pcall(function() driftConn:Disconnect() end)
			pcall(function() introGui:Destroy() end)
		end)
	end
end
local _savedCfg = nil
local function loadConfigKeys()
	if not(isfile and isfile("Tooze.json")) then return end
	local ok,cfg=pcall(function() return HS:JSONDecode(readfile("Tooze.json")) end)
	if not ok or not cfg then return end
	_savedCfg=cfg
	local function lk(e,d) if type(d)~="table" then return end;if d.kb and Enum.KeyCode[d.kb] then e.kb=Enum.KeyCode[d.kb] end;if d.gp and Enum.KeyCode[d.gp] then e.gp=Enum.KeyCode[d.gp] end end
	lk(KB.DropBrainrot,cfg.dropBrainrotKey);lk(KB.AutoLeft,cfg.autoLeftKey);lk(KB.AutoRight,cfg.autoRightKey)
	lk(KB.AutoBat,cfg.autoBatKey);lk(KB.BatTp,cfg.batTpKey);lk(KB.LaggerToggle,cfg.laggerToggleKey)
	lk(KB.TPFloor,cfg.tpFloorKey);lk(KB.InstaReset,cfg.instaResetKey);lk(KB.GuiHide,cfg.guiHideKey);lk(KB.SpeedToggle,cfg.speedToggleKey);lk(KB.AntiTpBat,cfg.antiTpBatKey)
	if cfg.normalSpeed then NS=cfg.normalSpeed end
	if cfg.carrySpeed then CS=cfg.carrySpeed end
	if cfg.grabRadius and type(cfg.grabRadius)=="number" then Steal.StealRadius=cfg.grabRadius else Steal.StealRadius=60 end
	if cfg.stealDuration and type(cfg.stealDuration)=="number" then Steal.StealDuration=cfg.stealDuration else Steal.StealDuration=1.4 end
	if cfg.autoGrabStopEnabled ~= nil then autoGrabStopEnabled = cfg.autoGrabStopEnabled end
	if cfg.autoGrabStopTime and type(cfg.autoGrabStopTime)=="number" then autoGrabStopTime = cfg.autoGrabStopTime end
	if cfg.autoGrabDelayRadius and type(cfg.autoGrabDelayRadius)=="number" then autoGrabDelayRadius = cfg.autoGrabDelayRadius end
	if cfg.laggerSpeed and type(cfg.laggerSpeed)=="number" then LAGGER_SPEED=cfg.laggerSpeed end
	if cfg.laggerCarrySpeed and type(cfg.laggerCarrySpeed)=="number" then LAGGER_CARRY_SPEED=cfg.laggerCarrySpeed end
	if cfg.autoTPHeight and type(cfg.autoTPHeight)=="number" then autoTPHeight=cfg.autoTPHeight end
	if cfg.autoSwing~=nil then autoSwingEnabled=cfg.autoSwing==true end
	if cfg.batTp~=nil then V.batTpEnabled=cfg.batTp==true end
	if cfg.batTpMode==1 or cfg.batTpMode==2 then V.batTpMode=cfg.batTpMode end
	if cfg.customFovValue and type(cfg.customFovValue)=="number" then V.customFovValue=cfg.customFovValue end
end
local function loadConfigState()
	local cfg=_savedCfg;if not cfg then return end
	if normalBox then normalBox.Text=tostring(NS) end
	if carryBox then carryBox.Text=tostring(CS) end
	if radInput then radInput.Text=tostring(Steal.StealRadius) end
	if durInput then durInput.Text=tostring(Steal.StealDuration) end
	if stopTimeBox then stopTimeBox.Text=tostring(autoGrabStopTime) end
	if delayRadiusBox then delayRadiusBox.Text=tostring(autoGrabDelayRadius) end
	if setAutoGrabStopVisual then setAutoGrabStopVisual(autoGrabStopEnabled) end
	if laggerBox then laggerBox.Text=tostring(LAGGER_SPEED) end
	if laggerCarryBox then laggerCarryBox.Text=tostring(LAGGER_CARRY_SPEED) end
	if autoTPHeightBox then autoTPHeightBox.Text=tostring(autoTPHeight) end
	if V.customFovBox then V.customFovBox.Text=tostring(V.customFovValue) end
	task.spawn(function()
		task.wait(0.15)
		if cfg.antiRagdoll then antiRagdollEnabled=true;if setAntiRagVisual then setAntiRagVisual(true) end;startAntiRagdoll() end
		if type(cfg.antiRagdollMode)=="string" and (cfg.antiRagdollMode=="Splatter" or cfg.antiRagdollMode=="No Splatter") then V.antiRagdollMode=cfg.antiRagdollMode;if V.setAntiRagModeVisual then V.setAntiRagModeVisual() end end
		if cfg.autoStealEnabled then Steal.AutoStealEnabled=true;if setInstaGrab then setInstaGrab(true) end;pcall(startAutoSteal) end
		if cfg.infiniteJump then infJumpEnabled=true;if setInfJumpVisual then setInfJumpVisual(true) end end
		if infJumpEnabled and V.refreshInfJump then V.refreshInfJump() end
		if cfg.medusaCounter then medusaCounterEnabled=true;if setMedusaVisual then setMedusaVisual(true) end;setupMedusa(LP.Character) end
		if cfg.batCounter then batCounterEnabled=true;if setBatCounterVisual then setBatCounterVisual(true) end;startBatCounter() end
		if cfg.laggerMode then laggerToggled=true;speedMode=false;laggerPhase=cfg.laggerCarryMode and 2 or 1;refreshSpeedModeLabel()
		elseif cfg.carryMode then speedMode=false;toggleCarryMode() end
		if cfg.autoTPEnabled then autoTPEnabled=true;if setAutoTPVisual then setAutoTPVisual(true) end;startAutoTP() end
		if setAutoSwingVisual then setAutoSwingVisual(autoSwingEnabled) end
		if cfg.batSpeed and cfg.batSpeed > 0 and cfg.batSpeed <= 200 then AUTO_BAT_SPEED=cfg.batSpeed end
		if type(cfg.hitDistance)=="number" and cfg.hitDistance>0 then V.hitDistance=cfg.hitDistance end
		if type(cfg.swingCooldown)=="number" and cfg.swingCooldown>0 then V.swingCooldown=cfg.swingCooldown end
		if cfg.aimbotMode == 1 or cfg.aimbotMode == 2 then
			V.aimbotMode = cfg.aimbotMode
			if V.setAimbotModeVisual then V.setAimbotModeVisual() end
		end
		if cfg.batVertSpeed and cfg.batVertSpeed > 0 and cfg.batVertSpeed <= 200 then AUTO_BAT_VERT_SPEED=cfg.batVertSpeed end
		if cfg.autoBat then autoBatEnabled=true;if autoBatSetVisual then autoBatSetVisual(true) end;queueAutoBatStart() end
		if V.batTpEnabled then if V.setBatTpVisual then V.setBatTpVisual(true) end;V.startBatTp() end
		if cfg.unwalkEnabled then unwalkEnabled=true;if setUnwalkVisual then setUnwalkVisual(true) end;task.spawn(function() task.wait(0.5);startUnwalk() end) end
		if cfg.antiLag then enableAntiLag();if setAntiLagVisual then setAntiLagVisual(true) end end
		if cfg.nukeEnabled then V.nukeEnabled=true; pcall(V.enableNuke); if V.setNukeVisual then V.setNukeVisual(true) end end
		if type(cfg.xrayTransparency)=="number" and V.setXrayTransparency then V.setXrayTransparency(cfg.xrayTransparency) end
		if cfg.xrayEnabled then V.xrayEnabled=true; pcall(V.xrayStart); if V.setXrayVisual then V.setXrayVisual(true) end end
		if type(cfg.stretchRezAmount)=="number" and V.setStretchRezAmount then V.setStretchRezAmount(cfg.stretchRezAmount) end
		if cfg.stretchRez then enableStretchRez();if setStretchRezVisual then setStretchRezVisual(true) end end
		if cfg.customFov then enableCustomFov();if V.setCustomFovVisual then V.setCustomFovVisual(true) end end
		if cfg.skyTheme and SKY_PRESETS[cfg.skyTheme] then applyCustomSky(cfg.skyTheme);if V.setSkyVisual then V.setSkyVisual() end end
		if cfg.ultraMode then enableUltraMode();if V.setUltraModeVisual then V.setUltraModeVisual(true) end end
		if cfg.removeAccessories then enableRemoveAccessories();if V.setRemoveAccVisual then V.setRemoveAccVisual(true) end end
		if cfg.antiKick then V.antiKickEnabled=true;V.enableAntiKick();if V.setAntiKickVisual then V.setAntiKickVisual(true) end end
		if cfg.safeMode then V.safeModeEnabled=true;V.enableSafeMode();if V.setSafeModeVisual then V.setSafeModeVisual(true) end end
		if cfg.customFontEnabled then task.spawn(function() task.wait(1);enableCustomFont() end);if V.setCustomFontVisual then V.setCustomFontVisual(true) end end
		if cfg.potatoGraphics then enablePotatoGraphics();if V.setPotatoVisual then V.setPotatoVisual(true) end end
		if cfg.autoSave ~= nil then V.autoSaveEnabled=cfg.autoSave end  -- legacy field — auto-save is now always-on
		if cfg.lockGui ~= nil then _guiLocked=cfg.lockGui==true; if setLockGuiVisual then setLockGuiVisual(_guiLocked) end end
		if cfg.hideMobileButtons ~= nil then
			V.hideMobileButtons = cfg.hideMobileButtons == true
			if V.setMobileButtonsVisible then V.setMobileButtonsVisible(not V.hideMobileButtons) end
			if V.setMobileBtnsVisual then V.setMobileBtnsVisual(not V.hideMobileButtons) end
		end
		if cfg.lockMobileButtons ~= nil then
			V.lockMobileButtons = cfg.lockMobileButtons == true
			if V.setLockMobileVisual then V.setLockMobileVisual(V.lockMobileButtons) end
		end
		if type(cfg.uiScale)=="number" then
			V.uiScale=cfg.uiScale
			if V.setUIScale then V.setUIScale(cfg.uiScale) end
		end
		if type(cfg.stealBarScale)=="number" then
			V.stealBarScale=cfg.stealBarScale
			if V.setStealBarScale then V.setStealBarScale(cfg.stealBarScale) end
		end
		if type(cfg.mainPos)=="table" and #cfg.mainPos==4 then
			V.mainPos=cfg.mainPos
			if V.mainFrame then
				V.mainFrame.Position=UDim2.new(cfg.mainPos[1],cfg.mainPos[2],cfg.mainPos[3],cfg.mainPos[4])
			end
		end
		if type(cfg.stealBarPos)=="table" and #cfg.stealBarPos==4 then
			V.stealBarPos=cfg.stealBarPos
			if V.stealBarFrame then
				V.stealBarFrame.Position=UDim2.new(cfg.stealBarPos[1],cfg.stealBarPos[2],cfg.stealBarPos[3],cfg.stealBarPos[4])
			end
		end
		if cfg.antiTpBat == true then
			task.spawn(function()
				task.wait(1.2)
				if V.startAntiTpBat then V.startAntiTpBat() end
				if V.setAntiTpBatVisual then V.setAntiTpBatVisual(V.antiTpBatEnabled) end
				if V.mobileButtons and V.mobileButtons["antiTpBat"] then
					V.mobileButtons["antiTpBat"].setActive(V.antiTpBatEnabled)
				end
			end)
		end
		if type(cfg.mobileBtnOn) == "table" then
			V.mobileBtnOn = cfg.mobileBtnOn
			if V.refreshMobileButtonsVisible then V.refreshMobileButtonsVisible() end
		end
		if cfg.mobileMoveAll ~= nil then
			V.mobileMoveAll = cfg.mobileMoveAll == true
			if V.setMoveAllVisual then V.setMoveAllVisual(V.mobileMoveAll) end
		end
		if type(cfg.mobileBtnScale) == "number" and V.setMobileBtnScale then V.setMobileBtnScale(cfg.mobileBtnScale) end
		-- So restaura posicoes salvas se forem do layout ATUAL. Posicoes de
		-- um tamanho/grid antigo deixariam os botoes sobrepostos.
		if type(cfg.mobileBtnPos) == "table" and cfg.mobileBtnLayout == V.MOBILE_LAYOUT_VER then
			V.mobileBtnPos = cfg.mobileBtnPos
			for key, d in pairs(V.mobileButtons or {}) do
				local sv = cfg.mobileBtnPos[key]
				if type(sv) == "table" and #sv == 4 and d.holder then
					d.holder.Position = UDim2.new(sv[1], sv[2], sv[3], sv[4])
				end
			end
		else
			V.mobileBtnPos = {}
			if V.rebuildMobileGrid then pcall(V.rebuildMobileGrid) end
		end
		if cfg.introEnabled ~= nil then _introEnabled=cfg.introEnabled==true; if setIntroVisual then setIntroVisual(_introEnabled) end end
		if cfg.introSong and type(cfg.introSong)=="number" and cfg.introSong>=1 and cfg.introSong<=10 then V.introSong=cfg.introSong; if V.setIntroSongVisual then V.setIntroSongVisual() end end
		if cfg.themeAccent and type(cfg.themeAccent)=="table" and #cfg.themeAccent==3 then
			pcall(function() if setAccent_global then setAccent_global(Color3.new(cfg.themeAccent[1], cfg.themeAccent[2], cfg.themeAccent[3])) end end)
			V.themeAccent = cfg.themeAccent
			pcall(function() if V.refreshSwatches then V.refreshSwatches() end end)
		end
		if cfg.sidebarArt and type(cfg.sidebarArt)=="string" then
			if cfg.sidebarArt == "111817612356516" or cfg.sidebarArt == "115117078011241" or cfg.sidebarArt == "82028776918457" or cfg.sidebarArt == "90280869222992" or cfg.sidebarArt == "98746506757032" or cfg.sidebarArt == "120792937680328" or cfg.sidebarArt == "83020463279031" or cfg.sidebarArt == "91006645127009" then cfg.sidebarArt = "83597321089055" end
			pcall(function() if setSidebarArt_global then setSidebarArt_global(cfg.sidebarArt) end end)
			pcall(function() if V.refreshMobileBg then V.refreshMobileBg(cfg.sidebarArt) end end)
			pcall(function() if V.refreshBgPicker then V.refreshBgPicker() end end)
		end
		if cfg.espMode == "withLine" or cfg.espMode == "noLine" then V.espMode = cfg.espMode end
		if cfg.playerESP then
			pcall(function() startPlayerESP(); if setPlayerESPVisual then setPlayerESPVisual(true) end end)
		end
		if cfg.antiDie then V.antiDieEnabled=true;V.setAntiDie(true);if V.setAntiDieVisual then V.setAntiDieVisual(true) end end
		if cfg.noCollide then V.noCollideEnabled=true;V.startNoCollide();if V.setNoCollideVisual then V.setNoCollideVisual(true) end end
		if cfg.headless then V.headlessEnabled=true;task.spawn(function() task.wait(0.8);V.applyHeadless() end);if V.setHeadlessVisual then V.setHeadlessVisual(true) end end
		if cfg.korblox then V.korbloxEnabled=true;task.spawn(function() task.wait(0.8);V.applyKorblox() end);if V.setKorbloxVisual then V.setKorbloxVisual(true) end end
		if cfg.noCamCollision then V.noCamCollisionEnabled=true;V.applyNoCamCollision(true);if V.setNoCamCollisionVisual then V.setNoCamCollisionVisual(true) end end
		if cfg.ragdollCountdown then V.ragdollCountdownEnabled=true;if V.setRagdollCountdownVisual then V.setRagdollCountdownVisual(true) end end
		if cfg.animationPack and type(cfg.animationPack)=="string" and cfg.animationPack ~= "OFF" then
			V.animationPack=cfg.animationPack
			if V.animPackValLbl then V.animPackValLbl.Text=V.animationPack end
			task.spawn(function() task.wait(1);V.applyAnimationPack(V.animationPack) end)
		end
	end)
end
loadConfigKeys()
buildGui()
loadConfigState()
print("by LKZZ")
