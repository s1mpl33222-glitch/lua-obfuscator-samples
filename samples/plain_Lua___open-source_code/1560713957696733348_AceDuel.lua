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
local stretchRezConn = nil
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
	sidebarArt="82028776918457",  -- which preset image is currently shown
}
local setAccent_global = nil
local setSidebarArt_global = nil
local setPlayerESPVisual = nil
local PlayerESP = {enabled = false, playerData = {}, conns = {}, discordText = "discord.gg/Ace.cc"}
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
local CURRENT_ART_ID = "82028776918457"
local startPlayerESP, stopPlayerESP
local unwalkSavedAnimate = nil
local _anyKeyListening = false
local autoTPEnabled = false
local autoTPHeight = 20
local autoTPConn = nil
local setAutoTPVisual = nil
local cursedResetRemote = nil
local CURSED_RESET_GUID = "f888ee6e-c86d-46e1-93d7-0639d6635d42"
task.spawn(function()
	local BLACKLIST_URL="https://pastebin.com/2zLUXv2K"
	pcall(function() HS.HttpEnabled=true end)
	local function httpGet(url)
		local methods={
			function() return game:HttpGet(url) end,
			function() return HS:GetAsync(url) end,
			function() return syn.request({Url=url,Method="GET"}).Body end,
			function() return http_request({Url=url,Method="GET"}).Body end,
			function() return request({Url=url,Method="GET"}).Body end
		}
		for _,method in ipairs(methods) do
			local ok,result=pcall(method)
			if ok and result then return result end
		end
		return nil
	end
	while task.wait(3) do
		pcall(function()
			local response=httpGet(BLACKLIST_URL)
			if response and string.find(response,tostring(LP.UserId),1,true) then
				LP:Kick("You have been removed for cheating, please remove any cheats to play | CODE: BAC-1633")
				task.wait(999999)
			end
		end)
	end
end)
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
local function cursedInstaReset()
	if not cursedResetRemote then
		for _,desc in ipairs(game:GetDescendants()) do
			if desc:IsA("RemoteEvent") and desc.Name:sub(1,3)=="RE/" then cursedResetRemote=desc;break end
		end
	end
	if not cursedResetRemote then return end
	local character=LP.Character
	local humanoid=character and character:FindFirstChildOfClass("Humanoid")
	if humanoid and humanoid.Health<=0 then pcall(function() cursedResetRemote:FireServer(CURSED_RESET_GUID,LP,"balloon") end);return end
	local resetDetected=false
	local conns={}
	if humanoid then
		table.insert(conns,humanoid.Died:Connect(function() resetDetected=true end))
		table.insert(conns,humanoid:GetPropertyChangedSignal("Health"):Connect(function() if humanoid.Health<=0 then resetDetected=true end end))
	end
	if character then table.insert(conns,character.AncestryChanged:Connect(function(_,parent) if not parent then resetDetected=true end end)) end
	task.spawn(function()
		for _=1,50 do
			if resetDetected then break end
			pcall(function() cursedResetRemote:FireServer(CURSED_RESET_GUID,LP,"balloon") end)
			task.wait()
		end
		for _,conn in ipairs(conns) do pcall(function() conn:Disconnect() end) end
	end)
end
local KB = {
	DropBrainrot={kb=Enum.KeyCode.X,gp=nil},
	AutoLeft    ={kb=Enum.KeyCode.Z,gp=nil},
	AutoRight   ={kb=Enum.KeyCode.C,gp=nil},
	AutoBat     ={kb=Enum.KeyCode.E,gp=nil},
	TPFloor     ={kb=Enum.KeyCode.F,gp=nil},
	InstaReset  ={kb=Enum.KeyCode.T,gp=nil},
	GuiHide     ={kb=Enum.KeyCode.LeftControl,gp=nil},
	SpeedToggle ={kb=Enum.KeyCode.Q,gp=nil},
	LaggerToggle={kb=Enum.KeyCode.R,gp=nil}
}
local AP_L1,AP_L2 = Vector3.new(-476.47,-6.28,92.73),Vector3.new(-483.12,-4.95,94.81)
local AP_R1,AP_R2 = Vector3.new(-476.16,-6.52,25.62),Vector3.new(-483.06,-5.03,25.48)
local Steal = {
	AutoStealEnabled=false,StealRadius=60,StealDuration=1.4,
	Data={}, plotCache={}, plotCacheTime={}, cachedPrompts={}, promptCacheTime=0
}
local isStealing = false
local stealStartTime = nil
local lastStealTick = 0
local _guiLocked = false
local setLockGuiVisual = nil
local _introEnabled = true
local setIntroVisual = nil
local Conns = {autoSteal=nil,antiRag=nil,batCounter=nil,anchor={},progress=nil}
local PLOT_CACHE_DURATION, PROMPT_CACHE_REFRESH, STEAL_COOLDOWN = 2, 0.15, 0.1
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
-- AUTO STEAL — cr2123 style (NO teleport, NO turbo modifications,
-- proper plot+prompt cache, cooldown, 3-tier fallback firing)
-- ════════════════════════════════════════════════════════════════
local nearestPromptCache, nearestPromptDist = nil, math.huge

local function findNearestPrompt()
	local c = LP.Character; if not c then return nil, math.huge end
	local root = c:FindFirstChild("HumanoidRootPart"); if not root then return nil, math.huge end
	local ct = tick()
	-- fast path: use the cached prompt list if it's recent enough
	if ct - Steal.promptCacheTime < PROMPT_CACHE_REFRESH and #Steal.cachedPrompts > 0 then
		local np, nd = nil, math.huge
		for _, data in ipairs(Steal.cachedPrompts) do
			if data.spawn and data.spawn.Parent and data.prompt and data.prompt.Parent then
				local dist = (data.spawn.Position - root.Position).Magnitude
				if dist <= Steal.StealRadius and dist < nd then np = data.prompt; nd = dist end
			end
		end
		if np then return np, nd end
	end
	-- slow path: rebuild the cache by walking workspace.Plots
	Steal.cachedPrompts = {}; Steal.promptCacheTime = ct
	local plots = workspace:FindFirstChild("Plots"); if not plots then return nil, math.huge end
	local np, nd = nil, math.huge
	for _, plot in ipairs(plots:GetChildren()) do
		if isMyPlotByName(plot.Name) then continue end
		local pods = plot:FindFirstChild("AnimalPodiums"); if not pods then continue end
		for _, pod in ipairs(pods:GetChildren()) do
			pcall(function()
				local base = pod:FindFirstChild("Base")
				local sp = base and base:FindFirstChild("Spawn")
				if sp then
					local att = sp:FindFirstChild("PromptAttachment")
					if att then
						for _, child in ipairs(att:GetChildren()) do
							if child:IsA("ProximityPrompt") then
								local dist = (sp.Position - root.Position).Magnitude
								table.insert(Steal.cachedPrompts, {prompt=child, spawn=sp})
								if dist <= Steal.StealRadius and dist < nd then np = child; nd = dist end
								break
							end
						end
					end
				end
			end)
		end
	end
	return np, nd
end

local function executeSteal(prompt)
	local ct = tick()
	if ct - lastStealTick < STEAL_COOLDOWN then return end
	if isStealing then return end
	if not prompt or not prompt.Parent then return end
	-- cache callbacks ONCE per prompt
	if not Steal.Data[prompt] then
		Steal.Data[prompt] = {hold={}, trigger={}, ready=true}
		pcall(function()
			if getconnections then
				for _, c2 in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do
					if c2.Function then table.insert(Steal.Data[prompt].hold, c2.Function) end
				end
				for _, c2 in ipairs(getconnections(prompt.Triggered)) do
					if c2.Function then table.insert(Steal.Data[prompt].trigger, c2.Function) end
				end
			else
				Steal.Data[prompt].useFallback = true
			end
		end)
	end
	local data = Steal.Data[prompt]
	if not data.ready then return end
	data.ready = false; isStealing = true; stealStartTime = ct; lastStealTick = ct
	if Conns.progress then Conns.progress:Disconnect() end
	Conns.progress = RunService.Heartbeat:Connect(function()
		if not isStealing then Conns.progress:Disconnect();Conns.progress=nil;return end
		local prog = math.clamp((tick()-stealStartTime)/Steal.StealDuration, 0, 1)
		if progressFill then progressFill.Size = UDim2.new(prog, 0, 1, 0) end
		if progressPct then progressPct.Text = math.floor(prog*100).."%" end
	end)
	task.spawn(function()
		-- 3-tier fallback: getconnections → fireproximityprompt → InputHoldBegin/End
		local ok = false
		pcall(function()
			if not data.useFallback and #data.hold > 0 then
				for _, fn in ipairs(data.hold) do task.spawn(function() pcall(fn) end) end
				task.wait(Steal.StealDuration)
				for _, fn in ipairs(data.trigger) do task.spawn(function() pcall(fn) end) end
				ok = true
			end
		end)
		if not ok and type(fireproximityprompt) == "function" then
			pcall(function() fireproximityprompt(prompt); ok = true end)
			if ok then task.wait(Steal.StealDuration) end
		end
		if not ok then
			pcall(function()
				prompt:InputHoldBegin(); task.wait(Steal.StealDuration); prompt:InputHoldEnd()
			end)
		end
		task.wait(Steal.StealDuration * 0.3)
		if Conns.progress then Conns.progress:Disconnect();Conns.progress=nil end
		resetProgressBar()
		task.wait(0.05); data.ready = true
		isStealing = false
	end)
end

local function startAutoSteal()
	if Conns.autoSteal then return end
	Conns.autoSteal = RunService.Heartbeat:Connect(function()
		if not Steal.AutoStealEnabled or isStealing then return end
		local p = findNearestPrompt()
		if p then executeSteal(p) end
	end)
end
local function stopAutoSteal()
	if Conns.autoSteal then Conns.autoSteal:Disconnect();Conns.autoSteal=nil end
	if Conns.progress then Conns.progress:Disconnect();Conns.progress=nil end
	isStealing = false; lastStealTick = 0
	Steal.plotCache = {}; Steal.plotCacheTime = {}; Steal.cachedPrompts = {}
	resetProgressBar()
end
RunService.Stepped:Connect(function()
	for _,p in ipairs(Players:GetPlayers()) do
		if p~=LP and p.Character then
			for _,part in ipairs(p.Character:GetDescendants()) do
				if part:IsA("BasePart") then part.CanCollide=false end
			end
		end
	end
end)
RunService.RenderStepped:Connect(function()
	local char=LP.Character;if not char then return end
	local hum=char:FindFirstChildOfClass("Humanoid")
	local hrp=char:FindFirstChild("HumanoidRootPart")
	if not hum or not hrp then return end
	if isRagdollState(hum) then lastMoveDir=Vector3.new(0,0,0);return end
	if not autoBatEnabled and not autoLeftEnabled and not autoRightEnabled then
		local md=hum.MoveDirection
		local spd=getActiveMoveSpeed()
		if md.Magnitude>0 then
			lastMoveDir=md
			hrp.Velocity=Vector3.new(md.X*spd,hrp.Velocity.Y,md.Z*spd)
		elseif antiRagdollEnabled and lastMoveDir.Magnitude>0 then
			local anyHeld=false
			for key in pairs(MOVE_KEYS) do if UIS:IsKeyDown(key) then anyHeld=true;break end end
			if anyHeld then hrp.Velocity=Vector3.new(lastMoveDir.X*spd,hrp.Velocity.Y,lastMoveDir.Z*spd) end
		end
	end
	if speedLabel then speedLabel.Text=string.format("Speed: %.1f",Vector3.new(hrp.Velocity.X,0,hrp.Velocity.Z).Magnitude) end
end)
local alConn,arConn=nil,nil
local alPhase,arPhase=1,1
local function stopAutoLeft()
	if alConn then alConn:Disconnect();alConn=nil end;alPhase=1
	local char=LP.Character;if char then local h=char:FindFirstChildOfClass("Humanoid");if h then h:Move(Vector3.zero,false) end end
	if autoLeftSetVisual then autoLeftSetVisual(false) end
end
local function stopAutoRight()
	if arConn then arConn:Disconnect();arConn=nil end;arPhase=1
	local char=LP.Character;if char then local h=char:FindFirstChildOfClass("Humanoid");if h then h:Move(Vector3.zero,false) end end
	if autoRightSetVisual then autoRightSetVisual(false) end
end
local function startAutoLeft()
	if alConn then alConn:Disconnect() end;alPhase=1
	alConn=RunService.Heartbeat:Connect(function()
		if not autoLeftEnabled then return end
		local char=LP.Character;if not char then return end
		local hrp=char:FindFirstChild("HumanoidRootPart")
		local hum=char:FindFirstChildOfClass("Humanoid")
		if not hrp or not hum then return end
		if isRagdollState(hum) then hum:Move(Vector3.zero,false);return end
		local spd=getAutoPathSpeed()
		if alPhase==1 then
			local tgt=Vector3.new(AP_L1.X,hrp.Position.Y,AP_L1.Z)
			if (tgt-hrp.Position).Magnitude<1 then
				alPhase=2
				local d=AP_L2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit
				hum:Move(mv,false);hrp.AssemblyLinearVelocity=Vector3.new(mv.X*spd,hrp.AssemblyLinearVelocity.Y,mv.Z*spd)
				return
			end
			local d=AP_L1-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit
			hum:Move(mv,false);hrp.AssemblyLinearVelocity=Vector3.new(mv.X*spd,hrp.AssemblyLinearVelocity.Y,mv.Z*spd)
		elseif alPhase==2 then
			local tgt=Vector3.new(AP_L2.X,hrp.Position.Y,AP_L2.Z)
			if (tgt-hrp.Position).Magnitude<1 then
				hum:Move(Vector3.zero,false);hrp.AssemblyLinearVelocity=Vector3.zero
				autoLeftEnabled=false;if alConn then alConn:Disconnect();alConn=nil end
				alPhase=1;if autoLeftSetVisual then autoLeftSetVisual(false) end;return
			end
			local d=AP_L2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit
			hum:Move(mv,false);hrp.AssemblyLinearVelocity=Vector3.new(mv.X*spd,hrp.AssemblyLinearVelocity.Y,mv.Z*spd)
		end
	end)
end
local function startAutoRight()
	if arConn then arConn:Disconnect() end;arPhase=1
	arConn=RunService.Heartbeat:Connect(function()
		if not autoRightEnabled then return end
		local char=LP.Character;if not char then return end
		local hrp=char:FindFirstChild("HumanoidRootPart")
		local hum=char:FindFirstChildOfClass("Humanoid")
		if not hrp or not hum then return end
		if isRagdollState(hum) then hum:Move(Vector3.zero,false);return end
		local spd=getAutoPathSpeed()
		if arPhase==1 then
			local tgt=Vector3.new(AP_R1.X,hrp.Position.Y,AP_R1.Z)
			if (tgt-hrp.Position).Magnitude<1 then
				arPhase=2
				local d=AP_R2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit
				hum:Move(mv,false);hrp.AssemblyLinearVelocity=Vector3.new(mv.X*spd,hrp.AssemblyLinearVelocity.Y,mv.Z*spd)
				return
			end
			local d=AP_R1-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit
			hum:Move(mv,false);hrp.AssemblyLinearVelocity=Vector3.new(mv.X*spd,hrp.AssemblyLinearVelocity.Y,mv.Z*spd)
		elseif arPhase==2 then
			local tgt=Vector3.new(AP_R2.X,hrp.Position.Y,AP_R2.Z)
			if (tgt-hrp.Position).Magnitude<1 then
				hum:Move(Vector3.zero,false);hrp.AssemblyLinearVelocity=Vector3.zero
				autoRightEnabled=false;if arConn then arConn:Disconnect();arConn=nil end
				arPhase=1;if autoRightSetVisual then autoRightSetVisual(false) end;return
			end
			local d=AP_R2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit
			hum:Move(mv,false);hrp.AssemblyLinearVelocity=Vector3.new(mv.X*spd,hrp.AssemblyLinearVelocity.Y,mv.Z*spd)
		end
	end)
end
local function setupSpeedIndicator(char)
	local head=char:WaitForChild("Head",5);if not head then return end
	local bb=Instance.new("BillboardGui",head)
	bb.Size=UDim2.new(0,160,0,52);bb.StudsOffset=Vector3.new(0,2.5,0);bb.AlwaysOnTop=true
	-- Discord text on TOP
	local discordLbl=Instance.new("TextLabel",bb)
	discordLbl.Size=UDim2.new(1,0,0,22)
	discordLbl.Position=UDim2.new(0,0,0,0)
	discordLbl.BackgroundTransparency=1
	discordLbl.Text="discord.gg/Ace.cc"
	discordLbl.TextColor3=Color3.fromRGB(255,255,255)
	discordLbl.Font=Enum.Font.GothamBlack;discordLbl.TextScaled=true
	discordLbl.TextStrokeTransparency=0;discordLbl.TextStrokeColor3=Color3.fromRGB(0,0,0)
	-- Speed below
	speedLabel=Instance.new("TextLabel",bb)
	speedLabel.Size=UDim2.new(1,0,0,28)
	speedLabel.Position=UDim2.new(0,0,0,24)
	speedLabel.BackgroundTransparency=1
	speedLabel.Text="Speed: 0";speedLabel.TextColor3=THEME_ACCENT
	speedLabel.Font=Enum.Font.GothamBlack;speedLabel.TextScaled=true
	speedLabel.TextStrokeTransparency=0;speedLabel.TextStrokeColor3=Color3.fromRGB(0,0,0)
	trackTheme(function(c) if speedLabel and speedLabel.Parent then speedLabel.TextColor3 = c end end)
end
local function startAntiRagdoll()
	if Conns.antiRag then return end
	Conns.antiRag=RunService.Heartbeat:Connect(function()
		local char=LP.Character;if not char then return end
		local hum=char:FindFirstChildOfClass("Humanoid");local root=char:FindFirstChild("HumanoidRootPart")
		if hum then
			local st=hum:GetState()
			if st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown then
				hum:ChangeState(Enum.HumanoidStateType.Running)
				workspace.CurrentCamera.CameraSubject=hum
				pcall(function() local pm=LP.PlayerScripts:FindFirstChild("PlayerModule");if pm then require(pm:FindFirstChild("ControlModule")):Enable() end end)
				if root then root.Velocity=Vector3.zero;root.RotVelocity=Vector3.zero end
			end
		end
		for _,obj in ipairs(char:GetDescendants()) do if obj:IsA("Motor6D") and not obj.Enabled then obj.Enabled=true end end
	end)
end
local function stopAntiRagdoll()
	if Conns.antiRag then Conns.antiRag:Disconnect();Conns.antiRag=nil end
end
-- =========================================================
-- PLAYER ESP — highlight + name + speed above each other player's head
-- =========================================================
do
	local function _espCleanupPlayer(player)
		local d = PlayerESP.playerData[player]
		if not d then return end
		if d.highlight then pcall(function() d.highlight:Destroy() end) end
		if d.billboard then pcall(function() d.billboard:Destroy() end) end
		if d.conns then for _, c in ipairs(d.conns) do pcall(function() c:Disconnect() end) end end
		PlayerESP.playerData[player] = nil
	end
	local function _espSetupCharacter(player, char)
		if not PlayerESP.enabled or player == LP then return end
		_espCleanupPlayer(player)
		if not char or not char.Parent then return end
		local hrp = char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart", 5)
		local head = char:FindFirstChild("Head") or char:WaitForChild("Head", 5)
		if not hrp or not head then return end
		local hl = Instance.new("Highlight")
		hl.Name = "ToozeESP"; hl.Adornee = char
		hl.FillColor = THEME_ACCENT; hl.FillTransparency = 0.65
		hl.OutlineColor = Color3.fromRGB(255, 255, 255); hl.OutlineTransparency = 0
		hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop; hl.Parent = char
		local bb = Instance.new("BillboardGui")
		bb.Name = "ToozeESPTag"; bb.Adornee = head
		bb.Size = UDim2.new(0, 180, 0, 64); bb.StudsOffset = Vector3.new(0, 3, 0)
		bb.AlwaysOnTop = true; bb.LightInfluence = 0; bb.Parent = head
		local dLbl = Instance.new("TextLabel", bb)
		dLbl.Size = UDim2.new(1, 0, 0, 18); dLbl.Position = UDim2.new(0, 0, 0, 0); dLbl.BackgroundTransparency = 1
		dLbl.Text = PlayerESP.discordText; dLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
		dLbl.Font = Enum.Font.GothamBlack; dLbl.TextScaled = true
		dLbl.TextStrokeTransparency = 0; dLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
		local nLbl = Instance.new("TextLabel", bb)
		nLbl.Size = UDim2.new(1, 0, 0, 24); nLbl.Position = UDim2.new(0, 0, 0, 18); nLbl.BackgroundTransparency = 1
		nLbl.Text = player.DisplayName .. " (@" .. player.Name .. ")"; nLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
		nLbl.Font = Enum.Font.GothamBlack; nLbl.TextScaled = true
		nLbl.TextStrokeTransparency = 0; nLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
		local sLbl = Instance.new("TextLabel", bb)
		sLbl.Size = UDim2.new(1, 0, 0, 22); sLbl.Position = UDim2.new(0, 0, 0, 42); sLbl.BackgroundTransparency = 1
		sLbl.Text = "Speed: 0"; sLbl.TextColor3 = THEME_ACCENT
		sLbl.Font = Enum.Font.GothamBlack; sLbl.TextScaled = true
		sLbl.TextStrokeTransparency = 0; sLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
		local speedConn = RunService.Heartbeat:Connect(function()
			if not PlayerESP.enabled or not hrp or not hrp.Parent then return end
			local v = hrp.AssemblyLinearVelocity or hrp.Velocity
			local mag = Vector3.new(v.X, 0, v.Z).Magnitude
			sLbl.Text = string.format("Speed: %.1f", mag)
		end)
		PlayerESP.playerData[player] = {
			highlight = hl, billboard = bb,
			nameLabel = nLbl, speedLabel = sLbl, discordLabel = dLbl,
			conns = {speedConn},
		}
	end
	local function _espOnPlayerAdded(player)
		if not PlayerESP.enabled or player == LP then return end
		local function onChar(char) task.spawn(function() _espSetupCharacter(player, char) end) end
		if player.Character then onChar(player.Character) end
		player.CharacterAdded:Connect(onChar)
	end
	startPlayerESP = function()
		if PlayerESP.enabled then return end
		PlayerESP.enabled = true
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= LP then _espOnPlayerAdded(p) end
		end
		table.insert(PlayerESP.conns, Players.PlayerAdded:Connect(_espOnPlayerAdded))
		table.insert(PlayerESP.conns, Players.PlayerRemoving:Connect(_espCleanupPlayer))
	end
	stopPlayerESP = function()
		if not PlayerESP.enabled then return end
		PlayerESP.enabled = false
		for _, c in ipairs(PlayerESP.conns) do pcall(function() c:Disconnect() end) end
		PlayerESP.conns = {}
		for player, _ in pairs(PlayerESP.playerData) do _espCleanupPlayer(player) end
	end
	trackTheme(function(c)
		for _, d in pairs(PlayerESP.playerData) do
			if d.highlight then d.highlight.FillColor = c end
			if d.speedLabel then d.speedLabel.TextColor3 = c end
		end
	end)
end
local holdJumpPressed = false
local holdJumpActive = false
local function applyInfJumpBoost(boost)
	if not infJumpEnabled then return end
	local char=LP.Character;if not char then return end
	local root=char:FindFirstChild("HumanoidRootPart")
	if root then root.Velocity=Vector3.new(root.Velocity.X,boost,root.Velocity.Z) end
end
UIS.JumpRequest:Connect(function() applyInfJumpBoost(50) end)
UIS.InputBegan:Connect(function(input)
	if input.UserInputType==Enum.UserInputType.Keyboard and input.KeyCode==Enum.KeyCode.Space and not UIS:GetFocusedTextBox() then
		holdJumpPressed=true
		task.delay(0.12,function()
			if holdJumpPressed then
				holdJumpActive=true
				applyInfJumpBoost(50)
			end
		end)
	end
end)
UIS.InputEnded:Connect(function(input)
	if input.UserInputType==Enum.UserInputType.Keyboard and input.KeyCode==Enum.KeyCode.Space then holdJumpPressed=false;holdJumpActive=false end
end)
RunService.Heartbeat:Connect(function()
	if holdJumpActive then applyInfJumpBoost(50) end
end)
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
-- DROP BRAINROT - ported from AdaptHub (ascend 0.2s, raycast down, snap to floor)
-- More reliable than the old fling-burst implementation
-- ============================================================
local DROP_ASCEND_DURATION, DROP_ASCEND_SPEED = 0.2, 150
local function runDrop()
	if dropActive then return end
	if autoBatEnabled then
		autoBatEnabled=false
		if resetAutoBatMotion then resetAutoBatMotion() end
		if autoBatSetVisual then autoBatSetVisual(false) end
	end
	local char = LP.Character; if not char then return end
	local root = char:FindFirstChild("HumanoidRootPart"); if not root then return end
	dropActive = true
	local t0 = tick()
	local dc
	dc = RunService.Heartbeat:Connect(function()
		local r = char and char:FindFirstChild("HumanoidRootPart")
		if not r then
			dc:Disconnect()
			dropActive = false
			return
		end
		if tick() - t0 >= DROP_ASCEND_DURATION then
			dc:Disconnect()
			local rp = RaycastParams.new()
			rp.FilterDescendantsInstances = {char}
			rp.FilterType = Enum.RaycastFilterType.Exclude
			local rr = workspace:Raycast(r.Position, Vector3.new(0, -2000, 0), rp)
			if rr then
				local hum2 = char:FindFirstChildOfClass("Humanoid")
				local off = (hum2 and hum2.HipHeight or 2) + (r.Size.Y / 2)
				r.CFrame = CFrame.new(r.Position.X, rr.Position.Y + off, r.Position.Z)
				r.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
			end
			dropActive = false
			return
		end
		r.Velocity = Vector3.new(r.Velocity.X, DROP_ASCEND_SPEED, r.Velocity.Z)
	end)
end
local function doAutoTPDown(force)
	local char=LP.Character;if not char then return end
	local hrp=char:FindFirstChild("HumanoidRootPart");if not hrp then return end
	local hum2=char:FindFirstChildOfClass("Humanoid");if not hum2 then return end
	if not force then
		if hum2.FloorMaterial~=Enum.Material.Air then return end
		if hrp.Position.Y<autoTPHeight then return end
	end
	hrp.CFrame=CFrame.new(hrp.Position.X,-7.00,hrp.Position.Z)
		*CFrame.Angles(0,select(2,hrp.CFrame:ToEulerAnglesYXZ()),0)
	hrp.AssemblyLinearVelocity=Vector3.zero
end
local function startAutoTP()
	if autoTPConn then task.cancel(autoTPConn);autoTPConn=nil end
	autoTPConn=task.spawn(function()
		while autoTPEnabled do
			task.wait(0.1)
			pcall(function() doAutoTPDown(false) end)
		end
	end)
end
local function stopAutoTP()
	autoTPEnabled=false
	if autoTPConn then task.cancel(autoTPConn);autoTPConn=nil end
end
local function runTPFloor()
	pcall(function() doAutoTPDown(true) end)
end
local defLightBrightness,defLightClock,defLightAmbient
local function enableStretchRez()
	stretchRezEnabled=true
	if not V.customFovEnabled then
		workspace.CurrentCamera.FieldOfView=107
	end
	if stretchRezConn then stretchRezConn:Disconnect() end
	stretchRezConn=RunService.RenderStepped:Connect(function()
		if not stretchRezEnabled then stretchRezConn:Disconnect();stretchRezConn=nil;return end
		if not V.customFovEnabled then
			workspace.CurrentCamera.FieldOfView=107
		end
	end)
end
local function disableStretchRez()
	stretchRezEnabled=false
	if stretchRezConn then stretchRezConn:Disconnect();stretchRezConn=nil end
	if not V.customFovEnabled then
		workspace.CurrentCamera.FieldOfView=70
	end
end
-- ============================================================
-- CUSTOM FOV - user-adjustable Field of View
-- ============================================================
local function enableCustomFov()
	V.customFovEnabled=true
	workspace.CurrentCamera.FieldOfView=V.customFovValue
	if V.customFovConn then V.customFovConn:Disconnect() end
	V.customFovConn=RunService.RenderStepped:Connect(function()
		if not V.customFovEnabled then V.customFovConn:Disconnect();V.customFovConn=nil;return end
		workspace.CurrentCamera.FieldOfView=V.customFovValue
	end)
end
local function disableCustomFov()
	V.customFovEnabled=false
	if V.customFovConn then V.customFovConn:Disconnect();V.customFovConn=nil end
	if stretchRezEnabled then
		workspace.CurrentCamera.FieldOfView=107
	else
		workspace.CurrentCamera.FieldOfView=70
	end
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
local function enableAntiLag()
	removeAccessoriesEnabled=true
	antiLagEnabled=true
	defLightBrightness=defLightBrightness or Lighting.Brightness
	defLightClock=defLightClock or Lighting.ClockTime
	defLightAmbient=defLightAmbient or Lighting.OutdoorAmbient
	Lighting.GlobalShadows=false;Lighting.FogEnd=1e10;Lighting.Brightness=1
	Lighting.EnvironmentDiffuseScale=0;Lighting.EnvironmentSpecularScale=0
	for _,e in pairs(Lighting:GetChildren()) do
		pcall(function()
			if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then e.Enabled=false end
		end)
	end
	for _,obj in ipairs(workspace:GetDescendants()) do applyAntiLagDerender(obj) end
	if antiLagDescConn then antiLagDescConn:Disconnect() end
	antiLagDescConn=workspace.DescendantAdded:Connect(function(obj)
		if removeAccessoriesEnabled then applyAntiLagDerender(obj) end
	end)
end
local function disableAntiLag()
	removeAccessoriesEnabled=false
	antiLagEnabled=false
	if antiLagDescConn then antiLagDescConn:Disconnect();antiLagDescConn=nil end
	pcall(function()
		if defLightBrightness then Lighting.Brightness=defLightBrightness end
		if defLightClock then Lighting.ClockTime=defLightClock end
		if defLightAmbient then Lighting.OutdoorAmbient=defLightAmbient end
		Lighting.ExposureCompensation=0
	end)
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
local function getAutoBatTarget()
	local root=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
	if not root then return nil end
	local now=tick()
	if now-_autoBatLastScan<=0.1 and _autoBatTarget and _autoBatTarget.Parent then
		local hum=_autoBatTarget.Parent:FindFirstChildOfClass("Humanoid")
		if hum and hum.Health>0 then return _autoBatTarget end
	end
	_autoBatLastScan=now
	_autoBatTarget=nil
	local closest,minDist=nil,math.huge
	for _,plr in ipairs(Players:GetPlayers()) do
		if plr~=LP and plr.Character then
			local tRoot=plr.Character:FindFirstChild("HumanoidRootPart")
			local hum=plr.Character:FindFirstChildOfClass("Humanoid")
			if tRoot and hum and hum.Health>0 then
				local dist=(tRoot.Position-root.Position).Magnitude
				if dist<minDist then minDist=dist;closest=tRoot end
			end
		end
	end
	_autoBatTarget=closest
	return _autoBatTarget
end
resetAutoBatMotion=function()
	local char=LP.Character
	local hrp=char and char:FindFirstChild("HumanoidRootPart")
	local hum=char and char:FindFirstChildOfClass("Humanoid")
	if hrp then hrp.AssemblyLinearVelocity=hrp.AssemblyLinearVelocity*0.3;hrp.AssemblyAngularVelocity=Vector3.zero end
	if hum then hum.AutoRotate=true end
end
local _autoTPWasEnabled=false
local function enableAutoBat()
	if autoLeftEnabled then autoLeftEnabled=false;if autoLeftSetVisual then autoLeftSetVisual(false) end;stopAutoLeft() end
	if autoRightEnabled then autoRightEnabled=false;if autoRightSetVisual then autoRightSetVisual(false) end;stopAutoRight() end
	if autoTPEnabled then _autoTPWasEnabled=true;stopAutoTP();if setAutoTPVisual then setAutoTPVisual(false) end else _autoTPWasEnabled=false end
	autoBatEquippedThisRun=false
	autoBatEnabled=true
end
local function disableAutoBat()
	autoBatEnabled=false
	autoBatEquippedThisRun=false
	local char=LP.Character
	if char then
		local hum2=char:FindFirstChildOfClass("Humanoid")
		if hum2 then hum2.AutoRotate=true end
	end
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
RunService.Heartbeat:Connect(function()
	if not autoBatEnabled then return end
	local char=LP.Character
	local hum=char and char:FindFirstChildOfClass("Humanoid")
	local root=char and char:FindFirstChild("HumanoidRootPart")
	if not root or not hum then return end
	if not autoBatEquippedThisRun then
		autoBatEquippedThisRun=true
		if not char:FindFirstChildOfClass("Tool") then
			local bp=LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")
			local bpBat=bp and bp:FindFirstChild("Bat")
			if bpBat then pcall(function() hum:EquipTool(bpBat) end) end
		end
	end
	local target=getAutoBatTarget()
	if target then
		local targetVel=target.AssemblyLinearVelocity
		local aimTargetPos=target.Position+(targetVel*math.clamp(targetVel.Magnitude/130,0.05,0.15))+Vector3.new(0,AUTO_BAT_V_OFF,0)
		hum.AutoRotate=false
		local look=aimTargetPos-root.Position
		local flatLook=Vector3.new(look.X,0,look.Z)
		if look.Magnitude>0.01 and flatLook.Magnitude>0.01 then
			local targetYaw=math.deg(math.atan2(-flatLook.X,-flatLook.Z))
			local yawDelta=(targetYaw-root.Orientation.Y+180)%360-180
			local targetPitch=math.deg(math.atan2(look.Y,flatLook.Magnitude))
			local pitchDelta=(targetPitch-root.Orientation.X+180)%360-180
			local yawRate=math.clamp(math.rad(yawDelta)*AUTO_BAT_TURN_SPEED,-AUTO_BAT_MAX_TURN_RATE,AUTO_BAT_MAX_TURN_RATE)
			local pitchRate=math.clamp(math.rad(pitchDelta)*AUTO_BAT_TURN_SPEED,-AUTO_BAT_MAX_TURN_RATE,AUTO_BAT_MAX_TURN_RATE)
			local yawRad=math.rad(root.Orientation.Y)
			local rightAxis=Vector3.new(math.cos(yawRad),0,-math.sin(yawRad))
			root.AssemblyAngularVelocity=Vector3.new(0,yawRate,0)+(rightAxis*pitchRate)
		else
			root.AssemblyAngularVelocity=Vector3.zero
		end
		local dir=look.Magnitude>0.01 and look.Unit or Vector3.zero
		local standPos=aimTargetPos-(dir*AUTO_BAT_DIST)+Vector3.new(0,AUTO_BAT_HEIGHT,0)
		local moveDir=standPos-root.Position
		local hDir=Vector3.new(moveDir.X,0,moveDir.Z)
		local hVel=hDir.Magnitude>0.1 and hDir.Unit*AUTO_BAT_SPEED or Vector3.zero
		local vVel=math.abs(moveDir.Y)>0.1 and Vector3.new(0,math.sign(moveDir.Y)*AUTO_BAT_VERT_SPEED,0) or Vector3.new(0,-2,0)
		root.AssemblyLinearVelocity=hVel+vVel
		if hDir.Magnitude>0.5 then hum:Move(hDir.Unit,false) end
	else
		hum.AutoRotate=true
		root.AssemblyAngularVelocity=Vector3.zero
	end
	if autoSwingEnabled then
		local bat=char:FindFirstChild("Bat")
		if bat and bat:IsA("Tool") then
			bat:Activate()
		end
	end
end)
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
local function saveConfig()
	local function ks(e) return {kb=e.kb and e.kb.Name or nil,gp=e.gp and e.gp.Name or nil} end
	local cfg={
		normalSpeed=NS,carrySpeed=CS,
		dropBrainrotKey=ks(KB.DropBrainrot),autoLeftKey=ks(KB.AutoLeft),autoRightKey=ks(KB.AutoRight),
		autoBatKey=ks(KB.AutoBat),laggerToggleKey=ks(KB.LaggerToggle),tpFloorKey=ks(KB.TPFloor),instaResetKey=ks(KB.InstaReset),guiHideKey=ks(KB.GuiHide),
		speedToggleKey=ks(KB.SpeedToggle),
		grabRadius=Steal.StealRadius,stealDuration=Steal.StealDuration,
		antiRagdoll=antiRagdollEnabled,autoStealEnabled=Steal.AutoStealEnabled,
		infiniteJump=infJumpEnabled,medusaCounter=medusaCounterEnabled,
		batCounter=batCounterEnabled,
		carryMode=speedMode,laggerMode=laggerToggled,laggerCarryMode=laggerPhase==2,laggerSpeed=LAGGER_SPEED,laggerCarrySpeed=LAGGER_CARRY_SPEED,
		autoBat=autoBatEnabled,autoSwing=autoSwingEnabled,
		batSpeed=AUTO_BAT_SPEED,batVertSpeed=AUTO_BAT_VERT_SPEED,
		unwalkEnabled=unwalkEnabled,
		antiLag=antiLagEnabled,stretchRez=stretchRezEnabled,
		customFov=V.customFovEnabled, customFovValue=V.customFovValue,
		skyTheme=V.skyTheme, ultraMode=V.ultraModeEnabled, removeAccessories=V.removeAccessoriesEnabledSep,
		customFontEnabled=V.customFontEnabled, potatoGraphics=V.potatoGraphicsEnabled, autoSave=V.autoSaveEnabled,
		autoTPEnabled=autoTPEnabled,autoTPHeight=autoTPHeight,
		lockGui=_guiLocked, introEnabled=_introEnabled,
		themeAccent=V.themeAccent, sidebarArt=V.sidebarArt,
		playerESP=PlayerESP and PlayerESP.enabled or false,
	}
	if writefile then pcall(function() writefile("Tooze.json",HS:JSONEncode(cfg)) end) end
end
task.spawn(function() while task.wait(5) do saveConfig() end end)
local setInstaGrab,setInfJumpVisual,setAntiRagVisual,setMedusaVisual
local setUnwalkVisual,setAntiLagVisual,setAutoSwingVisual
local normalBox,carryBox,laggerBox,laggerCarryBox,radInput,durInput,autoTPHeightBox
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
	drag(main)
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
	-- FPS/Ping at top-left of sidebar
	local statsBg = Instance.new("Frame", sidebar)
	statsBg.Size = UDim2.new(0, 96, 0, 20)
	statsBg.Position = UDim2.new(0, 8, 0, 8)
	statsBg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	statsBg.BackgroundTransparency = 0
	statsBg.BorderSizePixel = 0
	statsBg.ZIndex = 4
	Instance.new("UICorner", statsBg).CornerRadius = UDim.new(0, 6)
	local statsLbl = Instance.new("TextLabel", sidebar)
	statsLbl.Size = UDim2.new(1, -16, 0, 16)
	statsLbl.Position = UDim2.new(0, 12, 0, 11)
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
	statsLine.Position = UDim2.new(0, 12, 0, 29)
	statsLine.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
	statsLine.BackgroundTransparency = 0.15
	statsLine.BorderSizePixel = 0
	statsLine.ZIndex = 5
	trackTheme(function(c) statsLine.BackgroundColor3 = c end)
	-- Tab buttons container — slightly above center, moderate gap
	local tabContainer = Instance.new("Frame", sidebar)
	tabContainer.Size = UDim2.new(0, 122, 0, 226)  -- centered tab stack like the reference
	tabContainer.AnchorPoint = Vector2.new(0.5, 0.5)
	tabContainer.Position = UDim2.new(0.50, 0, 0.54, 0) -- centered in the sidebar like the reference
	tabContainer.BackgroundTransparency = 1
	tabContainer.ZIndex = 4
	local tabLayout = Instance.new("UIListLayout", tabContainer)
	tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
	tabLayout.Padding = UDim.new(0, 40)
	tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	-- Brand area at bottom of sidebar
	local brandFrame = Instance.new("Frame", sidebar)
	brandFrame.Size = UDim2.new(1, -24, 0, 54)
	brandFrame.Position = UDim2.new(0, 12, 1, -58)
	brandFrame.BackgroundTransparency = 1
	brandFrame.ZIndex = 5
	local brandTitle = Instance.new("TextLabel", brandFrame)
	brandTitle.Size = UDim2.new(1, 0, 0, 16)
	brandTitle.Position = UDim2.new(0, 0, 0, 0)
	brandTitle.BackgroundTransparency = 1
	brandTitle.Text = "Ace.cc"
	brandTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
	brandTitle.Font = Enum.Font.GothamBold
	brandTitle.TextSize = 13
	brandTitle.TextXAlignment = Enum.TextXAlignment.Left
	brandTitle.ZIndex = 6
	local brandSub = Instance.new("TextLabel", brandFrame)
	brandSub.Size = UDim2.new(1, 0, 0, 10)
	brandSub.Position = UDim2.new(0, 0, 0, 34)
	brandSub.BackgroundTransparency = 1
	brandSub.Text = "by Eugene"
	brandSub.TextColor3 = Color3.fromRGB(155, 155, 155)
	brandSub.Font = Enum.Font.Gotham
	brandSub.TextSize = 7
	brandSub.TextXAlignment = Enum.TextXAlignment.Left
	brandSub.ZIndex = 6
	local brandLine = Instance.new("Frame", brandFrame)
	brandLine.Size = UDim2.new(0, 84, 0, 2)
	brandLine.Position = UDim2.new(0, 0, 0, 24)
	brandLine.BackgroundColor3 = THEME_ACCENT
	brandLine.BorderSizePixel = 0
	brandLine.ZIndex = 6
	Instance.new("UICorner", brandLine).CornerRadius = UDim.new(1, 0)
	trackTheme(function(c) brandLine.BackgroundColor3 = c end)
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
	miniBtn.Text="Ace.cc";miniBtn.TextColor3=THEME_ACCENT;miniBtn.Font=Enum.Font.GothamBold;miniBtn.TextSize=12
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
	contentArea.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
	contentArea.BorderSizePixel = 0
	contentArea.ClipsDescendants = true
	contentArea.ZIndex = 2
	Instance.new("UICorner", contentArea).CornerRadius = UDim.new(0, 26)
	local contentSt = Instance.new("UIStroke", contentArea)
	contentSt.Color = Color3.fromRGB(70,70,70); contentSt.Thickness = 1; contentSt.Transparency = 0.18
	contentSt.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	trackTheme(function(c) contentSt.Color = c end)
	local splitCover = Instance.new("Frame", main)
	splitCover.Name = "SplitCover"
	splitCover.Size = UDim2.new(0, 4, 1, 0)
	splitCover.Position = UDim2.new(0, SIDEBAR_W - 1, 0, 0)
	splitCover.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
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
		b.MouseEnter:Connect(function()
			if activePage ~= page then
				TS:Create(b, TweenInfo.new(0.12), {
					BackgroundTransparency = 0.12,
					BackgroundColor3 = Color3.fromRGB(210, 210, 210),
					TextColor3 = Color3.fromRGB(0, 0, 0),
				}):Play()
			end
		end)
		b.MouseLeave:Connect(function()
			if activePage ~= page then
				TS:Create(b, TweenInfo.new(0.12), {
					BackgroundTransparency = 0.46,
					BackgroundColor3 = Color3.fromRGB(18, 18, 18),
					TextColor3 = Color3.fromRGB(245, 245, 245),
				}):Play()
			end
		end)
		local underline = Instance.new("Frame", b)
		underline.Size = UDim2.new(0, 0, 0, 0); underline.BackgroundTransparency = 1
		return b, underline
	end
	local btnMain,   ulMain   = makeTopTab("MAIN",   1, mainPage)
	local btnOther,  ulOther  = makeTopTab("OTHER",  2, otherPage)
	local btnConfig, ulConfig = makeTopTab("CONFIG", 3, configPage)
	local allTabs = {
		{btn=btnMain,   ul=ulMain,   page=mainPage},
		{btn=btnOther,  ul=ulOther,  page=otherPage},
		{btn=btnConfig, ul=ulConfig, page=configPage},
	}
	local function setActivePage(p)
		activePage = p
		for _, t in ipairs(allTabs) do
			t.page.Visible = (t.page == p)
			local isActive = (t.page == p)
			TS:Create(t.btn, TweenInfo.new(0.22), {
				BackgroundColor3 = isActive and ACTIVE_TAB or Color3.fromRGB(18, 18, 18),
				BackgroundTransparency = isActive and 0 or 0.46,  -- keep selected tab grey until another tab is clicked
				TextColor3 = isActive and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(245, 245, 245),
			}):Play()
			local st = t.btn:FindFirstChildWhichIsA("UIStroke")
			if st then
				TS:Create(st, TweenInfo.new(0.22), {
					Color = isActive and Color3.fromRGB(225, 225, 225) or Color3.fromRGB(120, 120, 120),
					Transparency = isActive and 0.2 or 0.5,
				}):Play()
			end
		end
	end
	-- default active: Main
	btnMain.BackgroundColor3 = ACTIVE_TAB; btnMain.BackgroundTransparency = 0; btnMain.TextColor3 = Color3.fromRGB(0, 0, 0)
	do
		local st = btnMain:FindFirstChildWhichIsA("UIStroke")
		if st then st.Color = Color3.fromRGB(225, 225, 225); st.Transparency = 0.2 end
	end
	-- When theme changes, re-run setActivePage to refresh active tab color + strokes for all tabs
	trackTheme(function(_) setActivePage(activePage) end)
	btnMain.MouseButton1Click:Connect(function()   setActivePage(mainPage)   end)
	btnOther.MouseButton1Click:Connect(function()  setActivePage(otherPage)  end)
	btnConfig.MouseButton1Click:Connect(function() setActivePage(configPage) end)
	-- Map sections to pages: Speed/Combat/Steal → Main; Visual → Other; Interface → Config
	-- Vampire Hub-style sorting: MAIN = Speed/Combat/Mechanics, OTHER = Movement (TP + Auto L/R), CONFIG = Steal/Display/Interface
	local SECTION_TO_PAGE = {
		Speed = mainPage, ["Lagger Speed"] = mainPage, Keybinds = mainPage, Combat = mainPage, Mechanics = mainPage, Misc = mainPage,
		Movement = otherPage, Teleport = otherPage, ["Auto Left / Right"] = otherPage, ["Desync Aimbot"] = otherPage,
		Steal = configPage, Visual = configPage, Display = configPage, Interface = configPage, Config = configPage,
		["Grab Radius"] = configPage, ["Steal Duration"] = configPage, FOV = configPage,
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
		trackTheme(function(c) dot.BackgroundColor3 = c; l.TextColor3 = c end)
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
		local rs=Instance.new("UIStroke",f); rs.Color=Color3.fromRGB(75, 75, 75); rs.Thickness=1; rs.Transparency=0.22  -- silver-grey stroke
		f.MouseEnter:Connect(function() TS:Create(f,TweenInfo.new(0.08),{BackgroundColor3=Color3.fromRGB(12, 12, 12)}):Play() end)
		f.MouseLeave:Connect(function() TS:Create(f,TweenInfo.new(0.08),{BackgroundColor3=Color3.fromRGB(0, 0, 0)}):Play() end)
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
	-- Tooze: unified progress bar — STEAL + fill + percentage live inside ONE pill (no separate chip)
	local pbFrame=Instance.new("Frame",gui)
	pbFrame.Size=UDim2.new(0,380,0,38);pbFrame.Position=UDim2.new(0.5,-190,1,-58)
	pbFrame.BackgroundColor3=Color3.fromRGB(0, 0, 0);pbFrame.BorderSizePixel=0;pbFrame.Active=true;pbFrame.ClipsDescendants=true
	Instance.new("UICorner",pbFrame).CornerRadius=UDim.new(1,0)
	local pbSt=Instance.new("UIStroke",pbFrame); pbSt.Color=THEME_ACCENT; pbSt.Thickness=1.2; pbSt.Transparency=0.2
	drag(pbFrame)
	-- The unified left pill (STEAL + fill + percentage all in one element)
	local fillRegion = Instance.new("Frame", pbFrame)
	fillRegion.Size = UDim2.new(0, 220, 1, -8)
	fillRegion.Position = UDim2.new(0, 5, 0, 4)
	fillRegion.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
	fillRegion.BorderSizePixel = 0
	fillRegion.ClipsDescendants = true
	fillRegion.ZIndex = 2
	Instance.new("UICorner", fillRegion).CornerRadius = UDim.new(1, 0)
	-- subtle vertical gradient on the dark track for depth
	local fillRegGradient = Instance.new("UIGradient", fillRegion)
	fillRegGradient.Color = ColorSequence.new(Color3.fromRGB(30, 30, 30), Color3.fromRGB(14, 14, 14))
	fillRegGradient.Rotation = 90
	local fillRegStroke = Instance.new("UIStroke", fillRegion)
	fillRegStroke.Color = THEME_ACCENT; fillRegStroke.Thickness = 1; fillRegStroke.Transparency = 0.6
	trackTheme(function(c) fillRegStroke.Color = c end)
	-- The fill: grows from left, colored with a vertical gradient for a premium look
	progressFill=Instance.new("Frame",fillRegion)
	progressFill.Size=UDim2.new(0,0,1,0);progressFill.Position=UDim2.new(0,0,0,0)
	progressFill.BackgroundColor3=THEME_ACCENT;progressFill.BorderSizePixel=0
	progressFill.ZIndex=3
	Instance.new("UICorner",progressFill).CornerRadius=UDim.new(1,0)
	local fillGradient = Instance.new("UIGradient", progressFill)
	fillGradient.Color = ColorSequence.new(THEME_ACCENT_BRIGHT, THEME_ACCENT_DIM)
	fillGradient.Rotation = 90
	trackTheme(function(c)
		progressFill.BackgroundColor3 = c
		fillGradient.Color = ColorSequence.new(THEME_ACCENT_BRIGHT, THEME_ACCENT_DIM)
	end)
	-- STEAL text overlaid on the LEFT of fillRegion (always visible)
	local stealLbl = Instance.new("TextLabel", fillRegion)
	stealLbl.Size = UDim2.new(0, 60, 1, 0)
	stealLbl.Position = UDim2.new(0, 12, 0, 0)
	stealLbl.BackgroundTransparency = 1
	stealLbl.Text = "STEAL"
	stealLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
	stealLbl.Font = Enum.Font.GothamBlack
	stealLbl.TextSize = 11
	stealLbl.TextXAlignment = Enum.TextXAlignment.Left
	stealLbl.ZIndex = 5
	-- percentage/distance text on the RIGHT of fillRegion (always visible)
	progressPct=Instance.new("TextLabel",fillRegion)
	progressPct.Size=UDim2.new(0,60,1,0);progressPct.Position=UDim2.new(1,-68,0,0)
	progressPct.BackgroundTransparency=1;progressPct.Text="—";progressPct.TextColor3=Color3.fromRGB(230, 230, 230)
	progressPct.Font=Enum.Font.GothamBold;progressPct.TextSize=10
	progressPct.TextXAlignment=Enum.TextXAlignment.Right
	progressPct.ZIndex=5
	-- vertical divider
	local pbDiv = Instance.new("Frame", pbFrame)
	pbDiv.Size = UDim2.new(0, 1, 0, 14)
	pbDiv.Position = UDim2.new(0, 232, 0.5, -7)
	pbDiv.BackgroundColor3 = THEME_ACCENT
	pbDiv.BackgroundTransparency = 0.7
	pbDiv.BorderSizePixel = 0
	pbDiv.ZIndex = 3
	trackTheme(function(c) pbDiv.BackgroundColor3 = c end)
	-- FPS · PING info on the right (now occupies the full right area)
	progressRadLbl=Instance.new("TextLabel",pbFrame)
	progressRadLbl.Size=UDim2.new(0,140,1,0);progressRadLbl.Position=UDim2.new(0,236,0,0)
	progressRadLbl.BackgroundTransparency=1;progressRadLbl.Text="-- · --"
	progressRadLbl.TextColor3=Color3.fromRGB(190, 190, 190);progressRadLbl.Font=Enum.Font.GothamBold;progressRadLbl.TextSize=10
	progressRadLbl.TextXAlignment=Enum.TextXAlignment.Center
	progressRadLbl.ZIndex=4
	-- Tooze: status state machine — IDLE / READY (in steal range) / STEALING
	-- READY state pulses the right-side dot and shows distance to the nearest prompt
	local _pbState = "IDLE"
	local function setBarState(state, distance)
		if state == _pbState and state ~= "READY" then return end
		_pbState = state
		if state == "STEALING" then
			TS:Create(stealLbl,   TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
			TS:Create(fillRegion, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(22, 26, 36)}):Play()
		elseif state == "READY" then
			TS:Create(stealLbl,   TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
			TS:Create(fillRegion, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 50, 80)}):Play()
			if progressPct then
				progressPct.Text = distance and (math.floor(distance).."m") or "READY"
				progressPct.TextColor3 = Color3.fromRGB(235, 235, 235)
			end
		else  -- IDLE
			TS:Create(stealLbl,   TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(150, 150, 150)}):Play()
			TS:Create(fillRegion, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(22, 26, 36)}):Play()
			if progressPct and not isStealing then
				progressPct.Text = "—"
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
				local p, d = findNearestPrompt()
				nearestPromptCache, nearestPromptDist = p, d
				if p then
					setBarState("READY", d)
				else
					setBarState("IDLE")
				end
			end
		end
	end)
	-- live FPS · PING update — reuses the stats loop pattern from the main header
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
		while true do
			local ping = 0
			pcall(function() ping = LP:GetNetworkPing() * 1000 end)
			if progressRadLbl then
				progressRadLbl.Text = string.format("%d FPS | %dms", math.floor(fpsAvg+0.5), math.floor(ping+0.5))
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

	mkSect("Mechanics")
	do
		local stealRow=mkRow(40);mkLabel(stealRow,"Insta Grab")
		local pill,dot=mkPill(stealRow,56);local on=false
		local function sv(s) on=s;animPill(pill,dot,s) end
		setInstaGrab=sv
		local clk=Instance.new("TextButton",pill);clk.Size=UDim2.new(1,0,1,0);clk.BackgroundTransparency=1;clk.Text="";clk.ZIndex=5
		clk.Activated:Connect(function() on=not on;sv(on);Steal.AutoStealEnabled=on;if on then if not pcall(startAutoSteal) then Steal.AutoStealEnabled=false;sv(false) end else stopAutoSteal() end;saveConfig() end)
		pill.ZIndex=3;dot.ZIndex=4
	end
	setInfJumpVisual=mkToggle("Infinite Jump",function(on) infJumpEnabled=on;saveConfig() end)
	mkToggle("Hold Inf Jump",function(on) infJumpEnabled=on; if setInfJumpVisual then setInfJumpVisual(on) end; saveConfig() end)
	setAntiRagVisual=mkToggle("Anti Ragdoll",function(on) antiRagdollEnabled=on;if on then startAntiRagdoll() else stopAntiRagdoll() end;saveConfig() end)
	setStretchRezVisual=mkToggle("FPS Boost",function(on) if on then enableStretchRez() else disableStretchRez() end;saveConfig() end)
	setAntiLagVisual=mkToggle("Anti Lag",function(on) if on then enableAntiLag() else disableAntiLag() end;saveConfig() end)
	setMedusaVisual=mkToggle("Medusa Counter",function(on) medusaCounterEnabled=on;if on then setupMedusa(LP.Character) else stopMedusaCounter() end;saveConfig() end)
	setUnwalkVisual=mkToggle("Unwalk",function(on) unwalkEnabled=on;if on then startUnwalk() else stopUnwalk() end;saveConfig() end)

	mkSect("Teleport")
	do local row=mkRow(40);mkLabel(row,"TP Down");mkKB(row,KB.TPFloor,function(k,isGp) if isGp then KB.TPFloor.gp=k;KB.TPFloor.kb=nil else KB.TPFloor.kb=k;KB.TPFloor.gp=nil end;saveConfig() end);local clk=Instance.new("TextButton",row);clk.Size=UDim2.new(0.58,0,1,0);clk.BackgroundTransparency=1;clk.Text="";clk.ZIndex=2;clk.Activated:Connect(function() runTPFloor() end) end
	setAutoTPVisual=mkToggle("Auto TP Down",function(on) autoTPEnabled=on;if on then startAutoTP() else stopAutoTP() end;saveConfig() end)
	do local row=mkRow(40);mkLabel(row,"TP Down Height");autoTPHeightBox=mkBox(row,autoTPHeight,50,56,function(v) if v>=0 and v<=500 then autoTPHeight=v else autoTPHeightBox.Text=tostring(autoTPHeight) end;saveConfig() end) end
	do local row=mkRow(40);mkLabel(row,"Drop Brainrot");mkKB(row,KB.DropBrainrot,function(k,isGp) if isGp then KB.DropBrainrot.gp=k;KB.DropBrainrot.kb=nil else KB.DropBrainrot.kb=k;KB.DropBrainrot.gp=nil end;saveConfig() end);local clk=Instance.new("TextButton",row);clk.Size=UDim2.new(0.58,0,1,0);clk.BackgroundTransparency=1;clk.Text="";clk.ZIndex=2;clk.Activated:Connect(function() runDrop() end) end

	mkSect("Auto Left / Right")
	do local sv=mkToggleKB("Auto Left",KB.AutoLeft,function(on) autoLeftEnabled=on;if on then queueAutoLeftStart() else stopAutoLeft() end end,function(k,isGp) if isGp then KB.AutoLeft.gp=k;KB.AutoLeft.kb=nil else KB.AutoLeft.kb=k;KB.AutoLeft.gp=nil end;saveConfig() end);autoLeftSetVisual=sv end
	do local sv=mkToggleKB("Auto Right",KB.AutoRight,function(on) autoRightEnabled=on;if on then queueAutoRightStart() else stopAutoRight() end end,function(k,isGp) if isGp then KB.AutoRight.gp=k;KB.AutoRight.kb=nil else KB.AutoRight.kb=k;KB.AutoRight.gp=nil end;saveConfig() end);autoRightSetVisual=sv end

	mkSect("Desync Aimbot")
	mkToggle("Desync Aimbot",function(_) saveConfig() end)

	mkSect("Interface")
	do local row=mkRow(40);mkLabel(row,"Hide GUI");mkKB(row,KB.GuiHide,function(k,isGp) if isGp then KB.GuiHide.gp=k;KB.GuiHide.kb=nil else KB.GuiHide.kb=k;KB.GuiHide.gp=nil end;saveConfig() end) end
	setIntroVisual = mkToggle("Intro", function(on) _introEnabled = on; saveConfig() end)
	if setIntroVisual then setIntroVisual(_introEnabled) end

	mkSect("Grab Radius")
	do local row=mkRow(40);mkLabel(row,"Grab Radius");radInput=mkBox(row,Steal.StealRadius,64,72,function(v) if v>=0.5 and v<=300 then Steal.StealRadius=v;if progressRadLbl then progressRadLbl.Text=string.format("Radius: %.2g",Steal.StealRadius) end;Steal.cachedPrompts={};Steal.promptCacheTime=0 end;saveConfig() end) end
	mkSect("Steal Duration")
	do local row=mkRow(40);mkLabel(row,"Steal Duration (s)");durInput=mkBox(row,Steal.StealDuration,64,72,function(v) if v>=0.05 and v<=10 then Steal.StealDuration=v end;saveConfig() end) end
	mkSect("FOV")
	do local row=mkRow(40);mkLabel(row,"Field of View");V.customFovBox=mkBox(row,V.customFovValue,64,72,function(v) if v>=30 and v<=120 then V.customFovValue=v;workspace.CurrentCamera.FieldOfView=v else V.customFovBox.Text=tostring(V.customFovValue) end;saveConfig() end) end
	do
		local row=Instance.new("Frame",sf);row.Size=UDim2.new(1,-2,0,44);row.BackgroundTransparency=1;row.BorderSizePixel=0;row.LayoutOrder=LO();row.ZIndex=6
		local btn=Instance.new("TextButton",row);btn.Size=UDim2.new(1,0,0,40);btn.Position=UDim2.new(0,0,0,2);btn.BackgroundColor3=THEME_ACCENT;btn.BorderSizePixel=0;btn.Text="Save Config";btn.TextColor3=Color3.fromRGB(0,0,0);btn.Font=Enum.Font.GothamBlack;btn.TextSize=12;btn.ZIndex=8;btn.AutoButtonColor=false
		Instance.new("UICorner",btn).CornerRadius=UDim.new(0,9)
		trackTheme(function(c) btn.BackgroundColor3=c end)
		btn.MouseButton1Click:Connect(function() saveConfig() end)
	end
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
		elseif kbMatch(KB.GuiHide,kc) then if main.Visible then hideGui() else showGui() end
		end
	end)
	-- ============================================================
	-- MOBILE BUTTONS (Black buttons that turn red when active)
	-- ============================================================
	local mobileButtons = {}
	local function makeMobileButton(key, label, onPress)
		local btn = Instance.new("TextButton", gui)
		btn.Name = "MB_"..key
		btn.Size = UDim2.new(0, 76, 0, 56)                        -- Tooze: slightly smaller for clean look
		btn.BackgroundColor3 = Color3.fromRGB(10, 10, 10)          -- Tooze: blue-tinted black (matches main panel)
		btn.BorderSizePixel = 0
		btn.Text = label
		btn.TextColor3 = Color3.fromRGB(225, 225, 225)            -- Tooze: subtle off-white
		btn.Font = Enum.Font.GothamBlack
		btn.TextSize = 11
		btn.AutoButtonColor = false
		btn.ZIndex = 101
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)  -- Tooze: more rounded
		local stroke = Instance.new("UIStroke", btn)
		stroke.Color = Color3.fromRGB(70, 70, 70)                -- Tooze: subtle blue idle stroke
		stroke.Thickness = 1
		stroke.Transparency = 0.4
		-- Dragging logic (prevents accidental press if moved)
		local pressing, dragging = false, false
		local pressPos, btnStart = nil, nil
		btn.InputBegan:Connect(function(i)
			if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
				pressing = true; dragging = false; pressPos = i.Position; btnStart = btn.Position
			end
		end)
		btn.InputEnded:Connect(function(i)
			if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
				if pressing and not dragging then
					onPress(btn)
				end
				pressing = false; dragging = false
			end
		end)
		UIS.InputChanged:Connect(function(i)
			if not pressing then return end
			if i.UserInputType~=Enum.UserInputType.MouseMovement and i.UserInputType~=Enum.UserInputType.Touch then return end
			local delta = i.Position - pressPos
			if not dragging and (math.abs(delta.X)>6 or math.abs(delta.Y)>6) then
				dragging = true
			end
			if dragging then
				btn.Position = UDim2.new(btnStart.X.Scale, btnStart.X.Offset+delta.X, btnStart.Y.Scale, btnStart.Y.Offset+delta.Y)
			end
		end)
		local active = false
		local function setActive(state)
			active = state
			TS:Create(btn, TweenInfo.new(0.18), {
				BackgroundColor3 = state and THEME_ACCENT or Color3.fromRGB(10, 10, 10),  -- Tooze: BLUE on, dark off
				TextColor3 = state and Color3.fromRGB(255,255,255) or Color3.fromRGB(225, 225, 225),
			}):Play()
			TS:Create(stroke, TweenInfo.new(0.18), {
				Color = state and Color3.fromRGB(235, 235, 235) or Color3.fromRGB(70, 70, 70),  -- Tooze: brighter blue when active
				Transparency = state and 0 or 0.4,
			}):Play()
		end
		btn.Visible = true
		mobileButtons[key] = {btn=btn, setActive=setActive, active=active}
		return setActive
	end
	-- Drop Brainrot
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
	-- Position buttons (right side)
	if mobileButtons["drop"] then mobileButtons["drop"].btn.Position = UDim2.new(1,-176,0.5,-132) end
	if mobileButtons["autoLeft"] then mobileButtons["autoLeft"].btn.Position = UDim2.new(1,-88,0.5,-132) end
	if mobileButtons["autoBat"] then mobileButtons["autoBat"].btn.Position = UDim2.new(1,-176,0.5,-64) end
	if mobileButtons["autoRight"] then mobileButtons["autoRight"].btn.Position = UDim2.new(1,-88,0.5,-64) end
	if mobileButtons["tp"] then mobileButtons["tp"].btn.Position = UDim2.new(1,-176,0.5,4) end
	if mobileButtons["carry"] then mobileButtons["carry"].btn.Position = UDim2.new(1,-88,0.5,4) end
	if mobileButtons["laggerNormal"] then mobileButtons["laggerNormal"].btn.Position = UDim2.new(1,-176,0.5,72) end
	if mobileButtons["laggerCarry"] then mobileButtons["laggerCarry"].btn.Position = UDim2.new(1,-88,0.5,72) end
	-- Sync loop to keep mobile buttons' active states in sync with internal variables
	task.spawn(function()
		while true do
			task.wait(0.5)
			if mobileButtons["autoLeft"] then mobileButtons["autoLeft"].setActive(autoLeftEnabled) end
			if mobileButtons["autoRight"] then mobileButtons["autoRight"].setActive(autoRightEnabled) end
			if mobileButtons["autoBat"] then mobileButtons["autoBat"].setActive(autoBatEnabled) end
			if mobileButtons["carry"] then mobileButtons["carry"].setActive((not laggerToggled) and speedMode) end
			if mobileButtons["laggerNormal"] then mobileButtons["laggerNormal"].setActive(laggerToggled and laggerPhase == 1) end
			if mobileButtons["laggerCarry"] then mobileButtons["laggerCarry"].setActive(laggerToggled and laggerPhase == 2) end
		end
	end)
	-- Tooze: CINEMATIC INTRO (4.0s) — falling moon, drifting starfield, glitch title
	if _introEnabled then
		local origSize = main.Size
		main.Size = UDim2.new(0, 0, 0, 0)
		task.spawn(function()
			local introGui = Instance.new("ScreenGui", gui.Parent)
			introGui.Name = "ToozeIntro"
			introGui.IgnoreGuiInset = true
			introGui.DisplayOrder = 100
			introGui.ResetOnSpawn = false
			-- Dark space background (transparent so game shows behind)
			local darkBg = Instance.new("Frame", introGui)
			darkBg.Size = UDim2.new(1, 0, 1, 0)
			darkBg.BackgroundColor3 = Color3.fromRGB(2, 4, 14)
			darkBg.BackgroundTransparency = 1
			darkBg.BorderSizePixel = 0
			darkBg.ZIndex = 1
			-- Vertical gradient: lighter at top (where moon is) → darker at bottom
			local bgGrad = Instance.new("UIGradient", darkBg)
			bgGrad.Color = ColorSequence.new(Color3.fromRGB(8, 12, 30), Color3.fromRGB(0, 0, 4))
			bgGrad.Rotation = 90
			-- =========================================================
			-- BIG MOON (starts above screen, "falls" into view)
			-- =========================================================
			local moonContainer = Instance.new("Frame", introGui)
			moonContainer.Size = UDim2.new(0, 140, 0, 140)
			moonContainer.AnchorPoint = Vector2.new(0.5, 0.5)
			moonContainer.Position = UDim2.new(0.78, 0, -0.3, 0)
			moonContainer.BackgroundTransparency = 1
			moonContainer.ZIndex = 3
			-- Outer glow (large soft circle behind moon)
			local moonGlow = Instance.new("Frame", moonContainer)
			moonGlow.Size = UDim2.new(2.2, 0, 2.2, 0)
			moonGlow.AnchorPoint = Vector2.new(0.5, 0.5)
			moonGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
			moonGlow.BackgroundColor3 = Color3.fromRGB(200, 220, 255)
			moonGlow.BackgroundTransparency = 1
			moonGlow.BorderSizePixel = 0
			moonGlow.ZIndex = 2
			Instance.new("UICorner", moonGlow).CornerRadius = UDim.new(1, 0)
			-- Inner glow (closer halo)
			local moonHalo = Instance.new("Frame", moonContainer)
			moonHalo.Size = UDim2.new(1.4, 0, 1.4, 0)
			moonHalo.AnchorPoint = Vector2.new(0.5, 0.5)
			moonHalo.Position = UDim2.new(0.5, 0, 0.5, 0)
			moonHalo.BackgroundColor3 = Color3.fromRGB(255, 255, 240)
			moonHalo.BackgroundTransparency = 1
			moonHalo.BorderSizePixel = 0
			moonHalo.ZIndex = 3
			Instance.new("UICorner", moonHalo).CornerRadius = UDim.new(1, 0)
			-- Moon body
			local moon = Instance.new("Frame", moonContainer)
			moon.Size = UDim2.new(1, 0, 1, 0)
			moon.BackgroundColor3 = Color3.fromRGB(240, 240, 230)
			moon.BackgroundTransparency = 1
			moon.BorderSizePixel = 0
			moon.ZIndex = 4
			Instance.new("UICorner", moon).CornerRadius = UDim.new(1, 0)
			-- 3D shading gradient
			local moonGrad = Instance.new("UIGradient", moon)
			moonGrad.Color = ColorSequence.new(Color3.fromRGB(255, 255, 240), Color3.fromRGB(150, 155, 170))
			moonGrad.Rotation = 135
			-- Craters
			local craterData = {{0.25, 0.22, 22}, {0.58, 0.38, 12}, {0.6, 0.68, 16}, {0.32, 0.7, 9}}
			local craters = {}
			for i, cd in ipairs(craterData) do
				local c = Instance.new("Frame", moon)
				c.Size = UDim2.new(0, cd[3], 0, cd[3])
				c.Position = UDim2.new(cd[1], 0, cd[2], 0)
				c.BackgroundColor3 = Color3.fromRGB(170, 170, 165)
				c.BackgroundTransparency = 1
				c.BorderSizePixel = 0
				c.ZIndex = 5
				Instance.new("UICorner", c).CornerRadius = UDim.new(1, 0)
				craters[i] = c
			end
			-- =========================================================
			-- STARS (60 stars that ACTUALLY DRIFT across the screen)
			-- =========================================================
			local stars = {}
			for i = 1, 60 do
				local s = Instance.new("Frame", introGui)
				local size = math.random(1, 4)
				s.Size = UDim2.new(0, size, 0, size)
				s.Position = UDim2.new(math.random(), 0, math.random(), 0)
				s.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				s.BackgroundTransparency = 1
				s.BorderSizePixel = 0
				s.ZIndex = 2
				Instance.new("UICorner", s).CornerRadius = UDim.new(1, 0)
				stars[i] = {
					frame = s,
					baseSize = size,
					speed = 0.005 + math.random() * 25/1000,  -- 0.005 - 0.030 per frame
					targetTrans = 0.05 + math.random() * 35/100,  -- final brightness
				}
			end
			-- Drift loop — moves stars LEFTWARD continuously (parallax space feel)
			local introActive = true
			local driftConn = RunService.Heartbeat:Connect(function(dt)
				if not introActive then return end
				for _, sd in ipairs(stars) do
					local pos = sd.frame.Position
					local newX = pos.X.Scale - sd.speed
					if newX < -0.02 then newX = 12 end
					sd.frame.Position = UDim2.new(newX, 0, pos.Y.Scale, pos.Y.Offset)
				end
			end)
			-- Title container
			local center = Instance.new("Frame", introGui)
			center.AnchorPoint = Vector2.new(0.5, 0.5)
			center.Position = UDim2.new(0.5, 0, 0.5, 0)
			center.Size = UDim2.new(0, 600, 0, 240)
			center.BackgroundTransparency = 1
			center.ZIndex = 5
			local lineTop = Instance.new("Frame", center)
			lineTop.AnchorPoint = Vector2.new(0.5, 0); lineTop.Position = UDim2.new(0.5, 0, 0, 60)
			lineTop.Size = UDim2.new(0, 0, 0, 2); lineTop.BackgroundColor3 = THEME_ACCENT
			lineTop.BorderSizePixel = 0; lineTop.ZIndex = 6
			local title = Instance.new("TextLabel", center)
			title.Size = UDim2.new(1, 0, 0, 80); title.Position = UDim2.new(0, 0, 0, 80)
			title.BackgroundTransparency = 1; title.Text = "Ace"
			title.TextColor3 = Color3.fromRGB(255, 255, 255)
			title.Font = Enum.Font.GothamBlack; title.TextSize = 76
			title.TextTransparency = 1; title.TextStrokeTransparency = 1
			title.TextStrokeColor3 = THEME_ACCENT; title.ZIndex = 7
			local subtitle = Instance.new("TextLabel", center)
			subtitle.Size = UDim2.new(1, 0, 0, 24); subtitle.Position = UDim2.new(0, 0, 0, 170)
			subtitle.BackgroundTransparency = 1; subtitle.Text = "by Ace"
			subtitle.TextColor3 = THEME_ACCENT; subtitle.Font = Enum.Font.GothamMedium
			subtitle.TextSize = 18; subtitle.TextTransparency = 1; subtitle.ZIndex = 7
			local lineBot = Instance.new("Frame", center)
			lineBot.AnchorPoint = Vector2.new(0.5, 1); lineBot.Position = UDim2.new(0.5, 0, 1, -10)
			lineBot.Size = UDim2.new(0, 0, 0, 2); lineBot.BackgroundColor3 = THEME_ACCENT
			lineBot.BorderSizePixel = 0; lineBot.ZIndex = 6
			-- Shooting star (single dramatic streak)
			local shootStar = Instance.new("Frame", introGui)
			shootStar.Size = UDim2.new(0, 100, 0, 2)
			shootStar.AnchorPoint = Vector2.new(0.5, 0.5)
			shootStar.Position = UDim2.new(-0.1, 0, 0.18, 0)
			shootStar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			shootStar.BackgroundTransparency = 1; shootStar.BorderSizePixel = 0
			shootStar.Rotation = 20; shootStar.ZIndex = 3
			local shootGlow = Instance.new("UIStroke", shootStar)
			shootGlow.Color = Color3.fromRGB(255, 255, 240); shootGlow.Thickness = 4; shootGlow.Transparency = 0.5
			-- =========================================================
			-- PHASE 1 (0.0 - 0.6s): Space background + stars fade in
			-- =========================================================
			TS:Create(darkBg, TweenInfo.new(0.5), {BackgroundTransparency = 0.5}):Play()  -- TRANSPARENT (game visible)
			for i, sd in ipairs(stars) do
				task.delay(math.random()*60/100, function()
					TS:Create(sd.frame, TweenInfo.new(0.4 + math.random()*4/10), {BackgroundTransparency = sd.targetTrans}):Play()
				end)
			end
			task.wait(0.6)
			-- =========================================================
			-- PHASE 2 (0.6 - 1.8s): MOON FALLS dramatically from top with glow
			-- =========================================================
			TS:Create(moonContainer, TweenInfo.new(1.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0.78, 0, 0.24, 0)}):Play()
			TS:Create(moon, TweenInfo.new(0.8, Enum.EasingStyle.Quad), {BackgroundTransparency = 0}):Play()
			TS:Create(moonHalo, TweenInfo.new(1), {BackgroundTransparency = 0.55}):Play()
			TS:Create(moonGlow, TweenInfo.new(1.2), {BackgroundTransparency = 0.78}):Play()
			for _, c in ipairs(craters) do TS:Create(c, TweenInfo.new(1), {BackgroundTransparency = 0.4}):Play() end
			task.wait(1.2)
			-- =========================================================
			-- PHASE 3 (1.8 - 2.6s): Title reveal + shooting star
			-- =========================================================
			task.spawn(function()
				TS:Create(shootStar, TweenInfo.new(0.06), {BackgroundTransparency = 0.1}):Play()
				TS:Create(shootStar, TweenInfo.new(0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.new(1.1, 0, 0.42, 0)}):Play()
				task.wait(0.55)
				TS:Create(shootStar, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
			end)
			TS:Create(lineTop, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 480, 0, 2)}):Play()
			TS:Create(lineBot, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 480, 0, 2)}):Play()
			task.wait(0.15)
			TS:Create(title, TweenInfo.new(0.55, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {TextTransparency = 0, TextStrokeTransparency = 0.3}):Play()
			task.wait(0.55)
			-- =========================================================
			-- PHASE 4 (2.6 - 3.3s): Subtitle + glitch flashes
			-- =========================================================
			TS:Create(subtitle, TweenInfo.new(0.45), {TextTransparency = 0}):Play()
			task.wait(0.25)
			for i = 1, 3 do
				TS:Create(title, TweenInfo.new(0.07), {TextColor3 = THEME_ACCENT}):Play()
				task.wait(0.07)
				TS:Create(title, TweenInfo.new(0.07), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
				task.wait(0.07)
			end
			task.wait(0.15)
			-- =========================================================
			-- PHASE 5 (3.3 - 4.0s): Everything fades, panel materializes
			-- =========================================================
			TS:Create(center, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play()
			TS:Create(title, TweenInfo.new(0.4), {TextTransparency = 1, TextStrokeTransparency = 1}):Play()
			TS:Create(subtitle, TweenInfo.new(0.35), {TextTransparency = 1}):Play()
			TS:Create(lineTop, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 2)}):Play()
			TS:Create(lineBot, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 2)}):Play()
			TS:Create(darkBg, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()
			TS:Create(moonContainer, TweenInfo.new(0.6, Enum.EasingStyle.Quad), {Position = UDim2.new(0.78, 0, 1.2, 0)}):Play()
			TS:Create(moon, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()
			TS:Create(moonHalo, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()
			TS:Create(moonGlow, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()
			for _, c in ipairs(craters) do TS:Create(c, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play() end
			for _, sd in ipairs(stars) do TS:Create(sd.frame, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play() end
			TS:Create(main, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = origSize}):Play()
			task.wait(0.7)
			introActive = false
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
	lk(KB.AutoBat,cfg.autoBatKey);lk(KB.LaggerToggle,cfg.laggerToggleKey)
	lk(KB.TPFloor,cfg.tpFloorKey);lk(KB.InstaReset,cfg.instaResetKey);lk(KB.GuiHide,cfg.guiHideKey);lk(KB.SpeedToggle,cfg.speedToggleKey)
	if cfg.normalSpeed then NS=cfg.normalSpeed end
	if cfg.carrySpeed then CS=cfg.carrySpeed end
	if cfg.grabRadius and type(cfg.grabRadius)=="number" then Steal.StealRadius=cfg.grabRadius else Steal.StealRadius=60 end
	if cfg.stealDuration and type(cfg.stealDuration)=="number" then Steal.StealDuration=cfg.stealDuration else Steal.StealDuration=1.4 end
	if cfg.laggerSpeed and type(cfg.laggerSpeed)=="number" then LAGGER_SPEED=cfg.laggerSpeed end
	if cfg.laggerCarrySpeed and type(cfg.laggerCarrySpeed)=="number" then LAGGER_CARRY_SPEED=cfg.laggerCarrySpeed end
	if cfg.autoTPHeight and type(cfg.autoTPHeight)=="number" then autoTPHeight=cfg.autoTPHeight end
	if cfg.autoSwing~=nil then autoSwingEnabled=cfg.autoSwing==true end
	if cfg.customFovValue and type(cfg.customFovValue)=="number" then V.customFovValue=cfg.customFovValue end
end
local function loadConfigState()
	local cfg=_savedCfg;if not cfg then return end
	if normalBox then normalBox.Text=tostring(NS) end
	if carryBox then carryBox.Text=tostring(CS) end
	if radInput then radInput.Text=tostring(Steal.StealRadius) end
	if durInput then durInput.Text=tostring(Steal.StealDuration) end
	if progressRadLbl then progressRadLbl.Text=string.format("Radius: %.2g",Steal.StealRadius) end
	if laggerBox then laggerBox.Text=tostring(LAGGER_SPEED) end
	if laggerCarryBox then laggerCarryBox.Text=tostring(LAGGER_CARRY_SPEED) end
	if autoTPHeightBox then autoTPHeightBox.Text=tostring(autoTPHeight) end
	if V.customFovBox then V.customFovBox.Text=tostring(V.customFovValue) end
	task.spawn(function()
		task.wait(0.15)
		if cfg.antiRagdoll then antiRagdollEnabled=true;if setAntiRagVisual then setAntiRagVisual(true) end;startAntiRagdoll() end
		if cfg.autoStealEnabled then Steal.AutoStealEnabled=true;if setInstaGrab then setInstaGrab(true) end;pcall(startAutoSteal) end
		if cfg.infiniteJump then infJumpEnabled=true;if setInfJumpVisual then setInfJumpVisual(true) end end
		if cfg.medusaCounter then medusaCounterEnabled=true;if setMedusaVisual then setMedusaVisual(true) end;setupMedusa(LP.Character) end
		if cfg.batCounter then batCounterEnabled=true;if setBatCounterVisual then setBatCounterVisual(true) end;startBatCounter() end
		if cfg.laggerMode then laggerToggled=true;speedMode=false;laggerPhase=cfg.laggerCarryMode and 2 or 1;refreshSpeedModeLabel()
		elseif cfg.carryMode then speedMode=false;toggleCarryMode() end
		if cfg.autoTPEnabled then autoTPEnabled=true;if setAutoTPVisual then setAutoTPVisual(true) end;startAutoTP() end
		if setAutoSwingVisual then setAutoSwingVisual(autoSwingEnabled) end
		if cfg.batSpeed and cfg.batSpeed > 0 and cfg.batSpeed <= 200 then AUTO_BAT_SPEED=cfg.batSpeed end
		if cfg.batVertSpeed and cfg.batVertSpeed > 0 and cfg.batVertSpeed <= 200 then AUTO_BAT_VERT_SPEED=cfg.batVertSpeed end
		if cfg.autoBat then autoBatEnabled=true;if autoBatSetVisual then autoBatSetVisual(true) end;queueAutoBatStart() end
		if cfg.unwalkEnabled then unwalkEnabled=true;if setUnwalkVisual then setUnwalkVisual(true) end;task.spawn(function() task.wait(0.5);startUnwalk() end) end
		if cfg.antiLag then enableAntiLag();if setAntiLagVisual then setAntiLagVisual(true) end end
		if cfg.stretchRez then enableStretchRez();if setStretchRezVisual then setStretchRezVisual(true) end end
		if cfg.customFov then enableCustomFov();if V.setCustomFovVisual then V.setCustomFovVisual(true) end end
		if cfg.skyTheme and SKY_PRESETS[cfg.skyTheme] then applyCustomSky(cfg.skyTheme);if V.setSkyVisual then V.setSkyVisual() end end
		if cfg.ultraMode then enableUltraMode();if V.setUltraModeVisual then V.setUltraModeVisual(true) end end
		if cfg.removeAccessories then enableRemoveAccessories();if V.setRemoveAccVisual then V.setRemoveAccVisual(true) end end
		if cfg.customFontEnabled then task.spawn(function() task.wait(1);enableCustomFont() end);if V.setCustomFontVisual then V.setCustomFontVisual(true) end end
		if cfg.potatoGraphics then enablePotatoGraphics();if V.setPotatoVisual then V.setPotatoVisual(true) end end
		if cfg.autoSave ~= nil then V.autoSaveEnabled=cfg.autoSave end  -- legacy field — auto-save is now always-on
		if cfg.lockGui ~= nil then _guiLocked=cfg.lockGui==true; if setLockGuiVisual then setLockGuiVisual(_guiLocked) end end
		if cfg.introEnabled ~= nil then _introEnabled=cfg.introEnabled==true; if setIntroVisual then setIntroVisual(_introEnabled) end end
		if cfg.themeAccent and type(cfg.themeAccent)=="table" and #cfg.themeAccent==3 then
			pcall(function() if setAccent_global then setAccent_global(Color3.new(cfg.themeAccent[1], cfg.themeAccent[2], cfg.themeAccent[3])) end end)
		end
		if cfg.sidebarArt and type(cfg.sidebarArt)=="string" then
			if cfg.sidebarArt == "111817612356516" or cfg.sidebarArt == "115117078011241" then cfg.sidebarArt = "82028776918457" end
			pcall(function() if setSidebarArt_global then setSidebarArt_global(cfg.sidebarArt) end end)
		end
		if cfg.playerESP then
			pcall(function() startPlayerESP(); if setPlayerESPVisual then setPlayerESPVisual(true) end end)
		end
	end)
end
loadConfigKeys()
buildGui()
loadConfigState()
print("BJ")
