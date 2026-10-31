-- ============================================================
-- OPTIMIZER (Dawg Optimizer) - se lance avant le reste du script
-- ============================================================
local _optOk, _optErr = pcall(function()
	local print = function(...) end
	_G.LustOptimizerNotify = function(text)
		pcall(function()
			game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Optimizer", Text = tostring(text), Duration = 2 })
		end)
	end
	local OPT_OFF_FILE = "lusthub_optimizer_off.txt"
	local function fileFlag(name)
		local ok, res = pcall(function() return isfile(name) end)
		return ok and res == true
	end
	local optEnabled = not fileFlag(OPT_OFF_FILE)
	local optMode = "duel"
	_G.LustOptimizerIsOn = function() return optEnabled end
	_G.LustOptimizerMode = function() return optMode end
	_G.LustOptimizerSet = function(on)
		optEnabled = on and true or false
		pcall(function()
			if optEnabled then
				if isfile(OPT_OFF_FILE) then delfile(OPT_OFF_FILE) end
			else
				writefile(OPT_OFF_FILE, "1")
			end
		end)
	end

	if _G.JAF_LoadOptRan then return end
	_G.JAF_LoadOptRan = true

	local CoreGui = game:GetService("CoreGui")
	local ReplicatedFirst = game:GetService("ReplicatedFirst")
	local Players = game:GetService("Players")
	local TweenService = game:GetService("TweenService")
	local RunService = game:GetService("RunService")
	local Lighting = game:GetService("Lighting")
	local Workspace = game:GetService("Workspace")
	local StarterGui = game:GetService("StarterGui")

	local START = os.clock()
	local BASELINE_FILE = "dawgopt_off.txt"
	local function fileExists(name)
		local ok, res = pcall(function() return isfile(name) end)
		return ok and res == true
	end
	local BASELINE = fileExists(BASELINE_FILE) or not optEnabled or optMode == "duel"
	local OPT_ON = (_G.JAF_LoadOpt ~= false) and not BASELINE
	local HARSH_ON = (_G.JAF_LoadOptHarsh == true) and not BASELINE
	local FLAGS_ON = (_G.JAF_LoadOptFlags ~= false) and not BASELINE
	local COREGUI_ON = (_G.JAF_LoadOptCoreGui ~= false) and not BASELINE
	local KEEP_COREGUI_HIDDEN = _G.JAF_LoadOptKeepCoreGuiHidden == true
	local METER_HOLD = tonumber(_G.JAF_LoadOptMeterHold) or 6
	_G.JAF_LoadOptActive = not BASELINE

	local LATE = false
	do
		local lp = Players.LocalPlayer
		if game:IsLoaded() and lp and lp.Character then LATE = true end
	end

	_G.JAF_LoadOptBaseline = function(on)
		if on == false then
			pcall(function() delfile(BASELINE_FILE) end)
			print("[DawgOpt] baseline OFF -- optimizer runs on next join")
		else
			pcall(function() writefile(BASELINE_FILE, "1") end)
			print("[DawgOpt] baseline ON -- optimizer disabled on next join, timer still runs")
		end
	end

	local setF = rawget(getgenv and getgenv() or _G, "setfflag") or rawget(_G, "set_fflag")
	local getF = rawget(getgenv and getgenv() or _G, "getfflag") or rawget(_G, "get_fflag")
	if type(setF) ~= "function" then setF = nil end
	if type(getF) ~= "function" then getF = nil end

	local flagSeen = {}
	local flagSet, flagDead = 0, 0

	local function applyFlag(name, value)
		if not setF then return false end
		if getF then
			local ok, cur = pcall(getF, name)
			if not ok or cur == nil then
				if not flagSeen[name] then flagSeen[name] = true; flagDead += 1 end
				return false
			end
		end
		if pcall(setF, name, tostring(value)) then
			if not flagSeen[name] then flagSeen[name] = true; flagSet += 1 end
			return true
		end
		return false
	end

	local FLAGS = {
		{"DFIntClusterSenderMaxJoinBandwidthBps", "2100000000"},{"DFIntClusterSenderMaxUpdateBandwidthBps", "2100000000"},
		{"DFIntServerFramesBetweenJoins", "1"},{"DFIntRaknetBandwidthInfluxHundredthsPercentageV2", "10000"},
		{"DFIntConnectionMTUSize", "1400"},{"FIntRakNetResendBufferArrayLength", "1024"},{"DFIntRakNetNakResendDelayMsMax", "1"},
		{"DFIntWaitOnUpdateNetworkLoopEndedMS", "100"},{"DFIntWaitOnRecvFromLoopEndedMS", "100"},{"DFIntLargePacketQueueSizeCutoffMB", "1000"},
		{"DFIntSendRakNetStatsInterval", "2147483647"},{"DFIntRakNetLoopMs", "1"},{"DFIntRakNetSelectTimeoutMs", "1"},
		{"DFIntNetworkClusterPacketCacheNumParallelTasks", "8"},{"DFIntReplicationDataCacheNumParallelTasks", "8"},
		{"DFIntMegaReplicatorNumParallelTasks", "16"},{"DFIntMegaReplicatorNetworkQualityProcessorUnit", "10"},
		{"DFIntMaxProcessPacketsStepsPerCyclic", "512"},{"DFIntMaxProcessPacketsStepsAccumulated", "0"},{"DFIntMaxProcessPacketsJobScaling", "1000"},
		{"DFIntClientPacketMaxFrameMicroseconds", "200000"},{"DFIntClientPacketExcessMicroseconds", "10000"},{"DFIntClientPacketMinMicroseconds", "1"},
		{"DFIntClientPacketMaxDelayMs", "1"},{"DFIntMaxWaitTimeBeforeForcePacketProcessMS", "1"},{"DFIntMaxFrameBufferSize", "4"},
		{"DFIntBufferCompressionThreshold", "100"},{"DFIntOverrideISRReplicatorStepBandwidthBytes", "131072"},
		{"DFIntTaskSchedulerTargetFps", "9999"},{"DFIntTaskSchedulerJobInitThreads", "8"},{"DFIntTaskSchedulerJobInGameThreads", "8"},
		{"FIntTaskSchedulerAutoThreadLimit", "16"},{"FIntTaskSchedulerAsyncTasksMinimumThreadCount", "4"},{"DFIntRuntimeConcurrency", "16"},
		{"FIntSimWorldTaskQueueParallelTasks", "20"},{"DFIntHttpBatchLimit", "256"},{"FIntHttpBatchLimit", "256"},
		{"DFIntHttpCurlConnectionCacheSize", "512"},{"FIntDefaultMeshCacheSizeMB", "512"},{"DFIntMemCacheMaxCapacityMB", "256"},
		{"DFIntNumAssetsMaxToPreload", "1"},{"DFFlagEnableSoundPreloading", "false"},{"FFlagSlimContentProvider", "true"},
		{"DFFlagDebugSkipMeshVoxelizer", "true"},{"DFFlagTextureQualityOverrideEnabled", "true"},{"DFIntTextureQualityOverride", "0"},
		{"FIntDebugTextureManagerSkipMips", "7"},{"DFIntDebugLimitMinTextureResolutionWhenSkipMips", "8"},{"FFlagTM2SkipMipsForUnstreamable2", "true"},
		{"DFFlagDoNotSkipMipsBasedOnSystemMemoryPS", "true"},{"FFlagRenderUseTextureManager224", "false"},{"DFIntDebugFRMQualityLevelOverride", "1"},
		{"DFFlagDebugPauseVoxelizer", "true"},{"FFlagFastGPULightCulling3", "true"},{"FIntRenderLocalLightFadeInMs", "0"},
		{"FIntRenderLocalLightUpdatesMax", "1"},{"FIntRenderShadowmapBias", "0"},{"FIntSSAOMipLevels", "0"},
		{"FIntDebugForceMSAASamples", "1"},{"FIntDebugFRMOptionalMSAALevelOverride", "0"},{"FIntRobloxGuiBlurIntensity", "0"},
		{"FIntFRMMinGrassDistance", "0"},{"FIntFRMMaxGrassDistance", "0"},{"DFFlagCoreScriptTelemetry2", "false"},
		{"DFFlagBrowserTrackerIdTelemetryEnabled", "false"},{"FFlagPerfDataOnTelemetryV2", "false"},{"FFlagSendRenderFidelityTelemetry2", "false"},
		{"FFlagEnableTelemetryServiceMemoryCPUInfo", "false"},{"DFIntTelemetryProfilerHundredthsPercentage", "0"},
		{"FIntTelemetryProfilerFrequency", "0"},{"FIntPerformanceTelemetryQueueProcessLimit", "0"},{"DFIntContentProviderPreloadHangTelemetryHundredthsPercentage", "0"}
	}

	local STARTUP_ONLY = {
		{"DFIntConnectionMTUSize", "1400"},{"FIntRakNetResendBufferArrayLength", "1024"},{"DFIntClusterSenderMaxJoinBandwidthBps", "2100000000"},
		{"FIntTaskSchedulerAutoThreadLimit", "16"},{"DFIntTaskSchedulerJobInitThreads", "8"},{"DFIntRuntimeConcurrency", "16"},
		{"FIntDefaultMeshCacheSizeMB", "512"},{"FIntDebugTextureManagerSkipMips", "7"},{"DFIntNumAssetsMaxToPreload", "1"},
		{"FFlagDebugGraphicsPreferD3D11", "True"},{"DFFlagDebugSkipMeshVoxelizer", "True"}
	}

	_G.JAF_LoadOptCopyStartupFlags = function()
		local parts = {}
		for _, f in ipairs(STARTUP_ONLY) do parts[#parts + 1] = string.format('  "%s": "%s"', f[1], f[2]) end
		local json = "{\n" .. table.concat(parts, ",\n") .. "\n}"
		if type(setclipboard) == "function" then
			pcall(setclipboard, json)
			print("[DawgOpt] startup-only flags copied to clipboard.")
		else
			print(json)
		end
		return json
	end

	local function applyAllFlags()
		if not FLAGS_ON or not setF then return end
		for _, f in ipairs(FLAGS) do applyFlag(f[1], f[2]) end
	end
	applyAllFlags()
	_G.JAF_LoadOptReapply = applyAllFlags
	for _, delay in ipairs({ 2, 6, 12, 20 }) do task.delay(delay, applyAllFlags) end

	local meter = {}
	function meter.finish() end

	local KILL_NAMES = { RobloxLoadingGUI = true, BackgroundScreen = true, DevGUIBlackoutCurtain = true }
	local function killIfMatch(inst)
		if inst.Parent == CoreGui and KILL_NAMES[inst.Name] then inst:Destroy() end
	end

	local watchConn
	if OPT_ON then
		for _, child in ipairs(CoreGui:GetChildren()) do killIfMatch(child) end
		watchConn = CoreGui.ChildAdded:Connect(killIfMatch)
		pcall(function() ReplicatedFirst:RemoveDefaultLoadingScreen() end)
	end

	local OPT_REC = {}
	local LIVE_FX = false
	local function isVivid(inst)
		local ok, found = pcall(function()
			for _, e in ipairs(_vividEffects or {}) do
				if e == inst then return true end
			end
			return false
		end)
		return ok and found == true
	end
	local function rec(inst, prop)
		local ok, old = pcall(function() return inst[prop] end)
		if ok then OPT_REC[#OPT_REC + 1] = { inst, prop, old } end
	end

	local loadPhase = true
	local function permaStrip(inst)
		if inst:IsA("ParticleEmitter") or inst:IsA("Trail") or inst:IsA("Smoke") or inst:IsA("Fire") or inst:IsA("Sparkles") then
			rec(inst, "Enabled")
			inst.Enabled = false
		elseif inst:IsA("PostEffect") and not isVivid(inst) and ((loadPhase and _G.JAF_LoadOptPostFX == true) or LIVE_FX) then
			rec(inst, "Enabled")
			inst.Enabled = false
		end
	end

	local function harshStrip(inst)
		if not loadPhase then return end
		if inst:IsA("Decal") or inst:IsA("Texture") then
			if inst.Transparency ~= 1 then rec(inst, "Transparency"); inst.Transparency = 1 end
		elseif inst:IsA("BillboardGui") or inst:IsA("SurfaceGui") then
			if inst.Enabled then rec(inst, "Enabled"); inst.Enabled = false end
		end
	end

	local ORIG = nil
	local function captureOriginal()
		if ORIG then return end
		ORIG = {}
		pcall(function() ORIG.quality = settings().Rendering.QualityLevel end)
		pcall(function() ORIG.saved = UserSettings():GetService("UserGameSettings").SavedQualityLevel end)
		pcall(function()
			ORIG.shadows = Lighting.GlobalShadows
			ORIG.diffuse = Lighting.EnvironmentDiffuseScale
			ORIG.specular = Lighting.EnvironmentSpecularScale
		end)
		pcall(function()
			local a = Lighting:FindFirstChildOfClass("Atmosphere")
			if a then ORIG.atm = { a, a.Density, a.Glare, a.Haze } end
		end)
		pcall(function()
			local t = Workspace:FindFirstChildOfClass("Terrain")
			if t then
				ORIG.terrain = { t, t.Decoration, t.WaterWaveSize, t.WaterWaveSpeed, t.WaterReflectance }
				local c = t:FindFirstChildOfClass("Clouds")
				if c then ORIG.clouds = { c, c.Enabled } end
			end
		end)
	end

	local function restoreOriginal()
		for i = #OPT_REC, 1, -1 do
			local r = OPT_REC[i]
			pcall(function() r[1][r[2]] = r[3] end)
		end
		OPT_REC = {}
		if not ORIG then return end
		pcall(function() if ORIG.quality then settings().Rendering.QualityLevel = ORIG.quality end end)
		pcall(function() if ORIG.saved then UserSettings():GetService("UserGameSettings").SavedQualityLevel = ORIG.saved end end)
		pcall(function()
			if ORIG.shadows ~= nil then
				Lighting.GlobalShadows = ORIG.shadows
				Lighting.EnvironmentDiffuseScale = ORIG.diffuse
				Lighting.EnvironmentSpecularScale = ORIG.specular
			end
		end)
		pcall(function()
			local a = ORIG.atm
			if a and a[1].Parent then a[1].Density, a[1].Glare, a[1].Haze = a[2], a[3], a[4] end
		end)
		pcall(function()
			local t = ORIG.terrain
			if t and t[1].Parent then t[1].Decoration, t[1].WaterWaveSize, t[1].WaterWaveSpeed, t[1].WaterReflectance = t[2], t[3], t[4], t[5] end
			local c = ORIG.clouds
			if c and c[1].Parent then c[1].Enabled = c[2] end
		end)
		ORIG = nil
	end

	local function applyPermanentSettings()
		captureOriginal()
		pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
		pcall(function() UserSettings():GetService("UserGameSettings").SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1 end)
		pcall(function()
			Lighting.GlobalShadows = false
			Lighting.EnvironmentDiffuseScale = 0
			Lighting.EnvironmentSpecularScale = 0
		end)
		pcall(function()
			local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
			if atmosphere then atmosphere.Density, atmosphere.Glare, atmosphere.Haze = 0, 0, 0 end
		end)
		pcall(function()
			local terrain = Workspace:FindFirstChildOfClass("Terrain")
			if terrain then
				terrain.Decoration = false
				terrain.WaterWaveSize, terrain.WaterWaveSpeed, terrain.WaterReflectance = 0, 0, 0
				local clouds = terrain:FindFirstChildOfClass("Clouds")
				if clouds then clouds.Enabled = false end
			end
		end)
	end

	local coreGuiHidden = false
	local coreGuiSaved = nil
	local function setCoreGui(on)
		pcall(function()
			if on then
				if coreGuiSaved then
					for coreType, wasOn in pairs(coreGuiSaved) do
						if wasOn then pcall(function() StarterGui:SetCoreGuiEnabled(coreType, true) end) end
					end
				end
				coreGuiSaved = nil
			else
				coreGuiSaved = {}
				for _, coreType in ipairs(Enum.CoreGuiType:GetEnumItems()) do
					if coreType ~= Enum.CoreGuiType.All then
						local ok, v = pcall(function() return StarterGui:GetCoreGuiEnabled(coreType) end)
						coreGuiSaved[coreType] = (ok and v == true)
					end
				end
				StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
			end
		end)
	end

	local permaConn, lightingConn
	if OPT_ON then
		applyPermanentSettings()
		if COREGUI_ON then coreGuiHidden = true; setCoreGui(false) end
		task.spawn(function()
			for _, root in ipairs({ Workspace, Lighting }) do
				local ok, list = pcall(function() return root:GetDescendants() end)
				if ok then
					local i, n = 1, #list
					while i <= n do
						local t0 = os.clock()
						while i <= n and (os.clock() - t0) < 0.002 do
							pcall(permaStrip, list[i])
							if HARSH_ON then pcall(harshStrip, list[i]) end
							i += 1
						end
						RunService.Heartbeat:Wait()
					end
				end
			end
		end)
		permaConn = Workspace.DescendantAdded:Connect(function(inst)
			pcall(permaStrip, inst)
			if HARSH_ON and loadPhase then pcall(harshStrip, inst) end
		end)
		lightingConn = Lighting.DescendantAdded:Connect(function(inst) pcall(permaStrip, inst) end)
	end

	local finished = false
	local function finish(seconds)
		if finished then return end
		finished = true
		loadPhase = false
		if watchConn and watchConn.Connected then watchConn:Disconnect() end
		if coreGuiHidden and not KEEP_COREGUI_HIDDEN then coreGuiHidden = false; setCoreGui(true) end
		pcall(function() meter.finish(seconds) end)
		if seconds then
			print(string.format("[DawgOpt] loaded in %.2fs | flags %d set, %d absent | nothing reverted%s", seconds, flagSet, flagDead, BASELINE and " | BASELINE" or ""))
		else
			print("[DawgOpt] load time not measurable")
		end
	end

	_G.JAF_LoadOptStop = function()
		if permaConn then permaConn:Disconnect() end
		if lightingConn then lightingConn:Disconnect() end
		finish(nil)
	end

	local liveOn = OPT_ON
	_G.LustOptimizerApply = function(on)
		if on then
			if liveOn then return end
			liveOn = true
			LIVE_FX = true
			applyPermanentSettings()
			pcall(function() StarterGui:SetCore("SendNotification", { Title = "Optimizer", Text = "ON", Duration = 2 }) end)
			task.spawn(function()
				for _, root in ipairs({ Workspace, Lighting }) do
					local ok, list = pcall(function() return root:GetDescendants() end)
					if ok then
						local i, n = 1, #list
						while i <= n and liveOn do
							local t0 = os.clock()
							while i <= n and (os.clock() - t0) < 0.002 do pcall(permaStrip, list[i]); i += 1 end
							RunService.Heartbeat:Wait()
						end
					end
				end
			end)
			if not (permaConn and permaConn.Connected) then
				permaConn = Workspace.DescendantAdded:Connect(function(inst) pcall(permaStrip, inst) end)
			end
			if not (lightingConn and lightingConn.Connected) then
				lightingConn = Lighting.DescendantAdded:Connect(function(inst) pcall(permaStrip, inst) end)
			end
		else
			if not liveOn then return end
			liveOn = false
			LIVE_FX = false
			if permaConn then permaConn:Disconnect(); permaConn = nil end
			if lightingConn then lightingConn:Disconnect(); lightingConn = nil end
			restoreOriginal()
			pcall(function() StarterGui:SetCore("SendNotification", { Title = "Optimizer", Text = "OFF", Duration = 2 }) end)
		end
	end

	local reapplyOnEnable = false
	_G.LustOptimizerToggle = function(on)
		if _G.LustOptimizerSet then _G.LustOptimizerSet(on) end
		if on then
			if reapplyOnEnable then reapplyOnEnable = false; _G.LustOptimizerApply(true)
			else _G.LustOptimizerNotify("ON - s'active au debut du duel") end
		else
			if liveOn then reapplyOnEnable = true; _G.LustOptimizerApply(false)
			else _G.LustOptimizerNotify("OFF") end
		end
	end

	local function inDuelCountdown()
		local fn = _G.AmbitiousSafeModeInDuelCountdown
		if type(fn) == "function" then
			local ok, r = pcall(fn)
			if ok and r == true then return true end
		end
		local found = false
		pcall(function()
			local lp = Players.LocalPlayer
			local pg = lp and lp:FindFirstChild("PlayerGui")
			local top = pg and pg:FindFirstChild("DuelsMachineTopFrame")
			if not top then return end
			for _, d in ipairs(top:GetDescendants()) do
				if d:IsA("TextLabel") and d.Visible then
					local t = string.upper(string.gsub(d.Text or "", "%s+", ""))
					local n = tonumber(t)
					if t == "GO" or t == "START" or (n and n >= 0 and n <= 10) then found = true; return end
				end
			end
		end)
		return found
	end

	task.spawn(function()
		local fired = false
		while true do
			task.wait(0.25)
			if optEnabled then
				local inCountdown = inDuelCountdown()
				if inCountdown and not fired then
					fired = true
					_G.LustOptimizerApply(true)
				elseif not inCountdown then
					fired = false
				end
			end
		end
	end)

	if LATE then
		task.delay(1, function() finish(nil) end)
	else
		task.spawn(function()
			if not game:IsLoaded() then game.Loaded:Wait() end
			local lp = Players.LocalPlayer
			if not lp then Players:GetPropertyChangedSignal("LocalPlayer"):Wait(); lp = Players.LocalPlayer end
			if lp and not lp.Character then lp.CharacterAdded:Wait() end
			task.wait(0.1)
			finish(os.clock() - START)
		end)
		task.delay(60, function() finish(nil) end)
	end
	print("dawgloaded")
end)
if not _optOk then _G.LustOptimizerError = tostring(_optErr) end

if _G.LustHubRunning then return end
_G.LustHubRunning = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local HS = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LP = Players.LocalPlayer
local camera = workspace.CurrentCamera
local ContentProvider = game:GetService("ContentProvider")

local CONFIG_FILE = "MegumiDuels_Config.json"
local _ace_isfile = isfile or (syn and syn.isfile) or function(path)
    local ok, result = pcall(function() return readfile(path) end)
    return ok and result ~= nil
end
local _ace_readfile = readfile or (syn and syn.readfile)
local _ace_writefile = writefile or (syn and syn.writefile)
local canSaveConfig = (type(_ace_readfile) == "function" and type(_ace_writefile) == "function")

_G.Lust = _G.Lust or {}
_G.Lust.Connections = {
    aimbot=nil,bypass=nil,autoLeft=nil,autoRight=nil,bodyLock=nil,dropBrainrot=nil,
    antiRagdoll=nil,infJump=nil,autoTPDown=nil,enemySpeed=nil,movement=nil,stepped=nil,
    stretch=nil,stretchFov=nil,antiLagDesc=nil,esp=nil,batCounter=nil,medusa={},steal=nil,progress=nil,espLine=nil,
}
_G.Lust.Active = {
    autoBat=false,bypass=false,autoLeft=false,autoRight=false,bodyLock=false,
    antiRagdoll=false,jump=false,medusa=false,batCounter=false,autoTPDown=false,
    antiLag=false,stretch=false,esp=false,steal=false,vivid=false,espLine=false,
}
_G.Lust.OriginalOutfit = {shirt=nil,pants=nil}
_G.Lust.OriginalAccessories = {}

local THEME_ORANGE = Color3.fromRGB(255, 20, 147)
function getThemeColor() return THEME_ORANGE end

TEXT_COLOR        = Color3.fromRGB(255, 255, 255)
TEXT_TRANSP       = 0.08
TEXT_STROKE_COL   = Color3.fromRGB(255, 20, 147)
TEXT_STROKE_TR    = 0.55
DEFAULT_TEXT_SIZE = 10

function applyTextStyle(obj, size, keepSize)
    if not obj then return end
    if not (obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox")) then return end
    obj.TextColor3             = TEXT_COLOR
    obj.TextTransparency       = TEXT_TRANSP
    obj.Font                   = Enum.Font.GothamBold
    obj.TextStrokeColor3       = TEXT_STROKE_COL
    obj.TextStrokeTransparency = TEXT_STROKE_TR
    obj.ZIndex                 = 999
    if not keepSize then obj.TextSize = size or DEFAULT_TEXT_SIZE end
end

function applyTextStyleRecursive(root, keepSizes)
    if not root then return end
    for _, obj in ipairs(root:GetDescendants()) do
        if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
            local keep = keepSizes and keepSizes[obj]
            applyTextStyle(obj, nil, keep)
        end
    end
end

_anyKeyStuckSince = 0
task.spawn(function()
    while true do
        task.wait(1)
        if _anyKeyListening then
            if _anyKeyStuckSince == 0 then _anyKeyStuckSince = tick() end
            if tick() - _anyKeyStuckSince > 6 then
                _anyKeyListening = false
                _anyKeyStuckSince = 0
                warn("[B2/JE] force-cleared stuck key listening")
            end
        else
            _anyKeyStuckSince = 0
        end
    end
end)

local velChecked = {}
local hookedVelParts = {}

local function setupVelChecked(char)
    velChecked = {}
    if not char then return end
    local hrp = char:WaitForChild("HumanoidRootPart", 5)
    if hrp then velChecked[hrp] = true end
    return hrp
end

local function hookVelHRP(hrp)
    if not hrp or hookedVelParts[hrp] then return end
    if not (getrawmetatable and setreadonly and newcclosure and checkcaller) then return end
    hookedVelParts[hrp] = true
    local ok, mt = pcall(getrawmetatable, hrp)
    if not ok or not mt then return end
    local wasReadOnly = false
    pcall(function() wasReadOnly = isreadonly and isreadonly(mt) or false end)
    pcall(setreadonly, mt, false)
    local okIdx, originalVelIndex = pcall(rawget, mt, "__index")
    if not okIdx then pcall(setreadonly, mt, true); return end
    local okSet = pcall(function()
        mt.__index = newcclosure(function(self, key)
            if not checkcaller() and velChecked[self] and (key == "AssemblyLinearVelocity" or key == "Velocity") then
                local real
                if type(originalVelIndex) == "function" then real = originalVelIndex(self, key)
                elseif type(originalVelIndex) == "table" then real = originalVelIndex[key] end
                if real and real.Magnitude > 20 then return real.Unit * 20 end
                return real
            end
            if type(originalVelIndex) == "function" then return originalVelIndex(self, key)
            elseif type(originalVelIndex) == "table" then return originalVelIndex[key] end
        end)
    end)
    if not okSet then hookedVelParts[hrp] = nil end
    pcall(setreadonly, mt, wasReadOnly or true)
end

if LP.Character then pcall(function() hookVelHRP(setupVelChecked(LP.Character)) end) end
LP.CharacterAdded:Connect(function(char)
    hookedVelParts = {}
    task.wait()
    pcall(function() hookVelHRP(setupVelChecked(char)) end)
end)

local function _speedLVSet(hrp, x, z)
    if not hrp or not hrp.Parent then return end
    pcall(function() if hrp.SetNetworkOwner then hrp:SetNetworkOwner(LP) end end)
    local y = hrp.AssemblyLinearVelocity.Y
    pcall(function() hrp.AssemblyLinearVelocity = Vector3.new(x, y, z) end)
    pcall(function() hrp.Velocity = Vector3.new(x, y, z) end)
end

local function _speedLVClear(hrp)
    if not hrp or not hrp.Parent then return end
    local y = hrp.AssemblyLinearVelocity.Y
    pcall(function() hrp.AssemblyLinearVelocity = Vector3.new(0, y, 0) end)
    pcall(function() hrp.Velocity = Vector3.new(0, y, 0) end)
end

function _G.Lust.StopAll()
    for _, conn in pairs(_G.Lust.Connections) do
        if type(conn) == "RBXScriptConnection" then pcall(function() conn:Disconnect() end)
        elseif type(conn) == "table" then
            for _, c in ipairs(conn) do
                if type(c) == "RBXScriptConnection" then pcall(function() c:Disconnect() end) end
            end
        end
    end
    for k in pairs(_G.Lust.Active) do _G.Lust.Active[k] = false end
    _blSuppressCount = 0; _blWasEnabled = false
    if _blRestoreTimer then task.cancel(_blRestoreTimer); _blRestoreTimer = nil end
end

NS = 60
CS = 30
LAGGER_SPEED_1 = 15
LAGGER_SPEED_2 = 24.5
MEDUSA_COOLDOWN = 25
BAT_AIMBOT_SPEED = 58
BYPASS_AIMBOT_SPEED = 60
MOBILE_PANEL_WIDTH = 128
MOBILE_PANEL_HEIGHT = 294
_isDraggingButton = false
TP_DOWN_Y = -7.00

speedMode = false
antiRagdollEnabled = false
jumpEnabled = false
laggerToggled = false
laggerLevel = 1
medusaCounterEnabled = false
batCounterEnabled = false
autoLeftEnabled = false
autoRightEnabled = false
autoBatEnabled = false
bypassToggled = false
antiDesyncAutoSwingEnabled = true
dropMode = 1
antiLagEnabled = false
removeAccessoriesEnabled = false
stretchEnabled = false
uiLocked = false
editModeEnabled = false
uiScaleValue = 80
stealBarSize = 100
buttonScaleValue = 1.0
espEnabled = false
espLineEnabled = false
vividGraphicsEnabled = false
autoTPDownEnabled = false
autoTPDownHeight = 20
bodyLockEnabled = false
bodyLockRange = 20
currentSkyTheme = "Off"
currentAnimPack = "Off"
currentAccessoryPack = "Off"
resetButtonActive = false
deathResetEnabled = false
mirrorTPDownEnabled = false
mirrorTPPreviousY = {}
mirrorTPLastTeleport = 0
MIRROR_TP_DROP_THRESHOLD = 3
MIRROR_TP_DOWN_Y = -7.00
autoResetOnMedEnabled = false
miniBtnPos = nil
currentOutfitIndex = 1
autoCarrySpeedEnabled = false
autoCarryMode = "On Pick Up"
autoCarryModeBtn = nil
_autoCarryApplied = false
setAutoCarryVisual = nil
hideMobileButtons = false

_vividEffects = {}
setVividVisual = nil
_vividGen = 0

function _vividBuild()
    for _, eff in ipairs(_vividEffects) do pcall(function() eff:Destroy() end) end
    _vividEffects = {}
    local function mk(class, props)
        local e = Instance.new(class)
        e:SetAttribute("_AmbitiousVivid", true)
        for k, v in pairs(props) do pcall(function() e[k] = v end) end
        table.insert(_vividEffects, e)
        e.Parent = Lighting
        return e
    end
    local color = mk("ColorCorrectionEffect", { Saturation = 0.6, Contrast = 0.4, Brightness = 0.05, TintColor = Color3.fromRGB(255, 240, 220) })
    mk("BloomEffect", { Intensity = 0.8, Size = 24, Threshold = 1 })
    mk("Atmosphere", { Density = 0.3, Offset = 0.25, Color = Color3.fromRGB(199, 199, 255), Decay = Color3.fromRGB(106, 112, 125), Glare = 0.2, Haze = 1 })
    mk("SunRaysEffect", { Intensity = 0.2, Spread = 0.8 })
    mk("DepthOfFieldEffect", { FocusDistance = 25, InFocusRadius = 10, NearIntensity = 0.2, FarIntensity = 0.4 })
    return color
end

function _vividIntact()
    if #_vividEffects < 5 then return false end
    for _, e in ipairs(_vividEffects) do
        if not e.Parent or e.Parent ~= Lighting then return false end
        local ok, en = pcall(function() return e.Enabled end)
        if ok and en == false then return false end
    end
    return true
end

function enableVividGraphics()
    vividGraphicsEnabled = true
    _G.Lust.Active.vivid = true
    if _vividIntact() then
        if setVividVisual then setVividVisual(true) end
        return
    end
    _vividGen = _vividGen + 1
    local gen = _vividGen
    local color = _vividBuild()
    task.spawn(function()
        local acc = 0
        while vividGraphicsEnabled and _vividGen == gen do
            if color and color.Parent then pcall(function() color.Contrast = 0.35 + math.sin(tick() * 2) * 0.05 end) end
            acc = acc + 0.03
            if acc >= 0.5 then
                acc = 0
                if not _vividIntact() then color = _vividBuild() end
            end
            task.wait(0.03)
        end
    end)
    if setVividVisual then setVividVisual(true) end
end

function disableVividGraphics()
    vividGraphicsEnabled = false
    _vividGen = _vividGen + 1
    _G.Lust.Active.vivid = false
    for _, eff in ipairs(_vividEffects) do pcall(function() eff:Destroy() end) end
    _vividEffects = {}
    if setVividVisual then setVividVisual(false) end
end

function toggleVividGraphics(on)
    if on then enableVividGraphics() else disableVividGraphics() end
    saveAllSettings()
end

local ButtonBackgroundImages = {
    "rbxassetid://129085053275432","rbxassetid://126638309339233","rbxassetid://90211231416942",
    "rbxassetid://138472956105442","rbxassetid://106519139240666","rbxassetid://114535932585883",
    "rbxassetid://133353928145895","rbxassetid://95372928362733","rbxassetid://82986133916631",
    "rbxassetid://71086942427922",
}
currentButtonBgIndex = 0
floatStyleIndex = 1
local _mobileButtonsCache = {}
local _floatingButtonsCache = {}

local function applyButtonBackgroundToBtn(btn, index)
    if not btn then return end
    local existing = btn:FindFirstChild("BtnBgImage")
    if index == 0 or not ButtonBackgroundImages[index] then
        if existing then existing:Destroy() end
        return
    end
    local img = existing
    if not img then
        img = Instance.new("ImageLabel")
        img.Name = "BtnBgImage"
        img.Size = UDim2.new(1, 0, 1, 0)
        img.Position = UDim2.new(0, 0, 0, 0)
        img.BackgroundTransparency = 1
        img.ScaleType = Enum.ScaleType.Crop
        img.Active = false
        img.Selectable = false
        img.ZIndex = btn.ZIndex or 10
        local c = Instance.new("UICorner", img)
        c.CornerRadius = UDim.new(0, 10)
        img.Parent = btn
    end
    img.Image = ButtonBackgroundImages[index]
    img.ImageTransparency = 0.1
end

function applyButtonBackground(index)
    index = math.clamp(index or currentButtonBgIndex, 0, #ButtonBackgroundImages)
    currentButtonBgIndex = index
    for _, btn in ipairs(_mobileButtonsCache) do applyButtonBackgroundToBtn(btn, index) end
    for _, btn in ipairs(_floatingButtonsCache) do applyButtonBackgroundToBtn(btn, index) end
end

_G.AdaptAutoResetOnMed = {
    conns = {}, enabled = false, medTriggered = false,
    lastFire = 0, cooldown = 2.25, charAddedConn = nil,
}

CONFIG = { AUTO_STEAL_ENABLED = false, STEAL_RANGE = 61 }
local Steal = {
    AutoStealEnabled = false,
    StealRadius = CONFIG.STEAL_RANGE,
    StealDuration = 1.3,
    StealDelay = 0.25,
    Data = {}
}
local isStealing = false
local autoGrabSetDelayRadius = 9
local autoGrabStopTime = 0.96
local autoGrabStopEnabled = true
local stealConnection = nil

local function isMyPlotByName(plotName)
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return false end
    local plot = plots:FindFirstChild(plotName)
    if not plot then return false end
    local sign = plot:FindFirstChild("PlotSign")
    if sign then
        local yb = sign:FindFirstChild("YourBase")
        if yb and yb:IsA("BillboardGui") then return yb.Enabled == true end
    end
    return false
end

local function findNearestPrompt()
    local char = LP.Character
    if not char then return nil, nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil, nil end
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil, nil end
    local nearestPrompt, nearestDist, nearestName = nil, math.huge, nil
    for _, plot in ipairs(plots:GetChildren()) do
        if not isMyPlotByName(plot.Name) then
            local pods = plot:FindFirstChild("AnimalPodiums")
            if pods then
                for _, pod in ipairs(pods:GetChildren()) do
                    pcall(function()
                        local base = pod:FindFirstChild("Base")
                        local spawn = base and base:FindFirstChild("Spawn")
                        if spawn then
                            local dist = (spawn.Position - root.Position).Magnitude
                            if dist < nearestDist and dist <= Steal.StealRadius then
                                local att = spawn:FindFirstChild("PromptAttachment")
                                if att then
                                    for _, child in ipairs(att:GetChildren()) do
                                        if child:IsA("ProximityPrompt") and child.ActionText and child.ActionText:find("Steal") then
                                            nearestPrompt = child
                                            nearestDist = dist
                                            nearestName = pod.Name
                                            break
                                        end
                                    end
                                end
                            end
                        end
                    end)
                end
            end
        end
    end
    return nearestPrompt, nearestName
end

local function executeSteal(prompt, podName)
    if isStealing then return end
    if not Steal.Data[prompt] then
        Steal.Data[prompt] = { hold = {}, trigger = {}, ready = true }
        pcall(function()
            if getconnections then
                for _, c in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do
                    if c.Function then table.insert(Steal.Data[prompt].hold, c.Function) end
                end
                for _, c in ipairs(getconnections(prompt.Triggered)) do
                    if c.Function then table.insert(Steal.Data[prompt].trigger, c.Function) end
                end
            end
        end)
    end
    local data = Steal.Data[prompt]
    if not data.ready then return end
    data.ready = false
    isStealing = true
    if _G.SetStealStatus then _G.SetStealStatus("STEALING") end
    if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
    if progressPct then progressPct.Text = "0%" end
    task.spawn(function()
        for _, f in ipairs(data.hold) do task.spawn(f) end
        local startTime = tick()
        local duration = Steal.StealDuration
        local promptFired = false
        if autoGrabStopEnabled then
            while isStealing and Steal.AutoStealEnabled do
                local elapsed = tick() - startTime
                if elapsed >= autoGrabStopTime then break end
                local progress = math.clamp(elapsed / duration, 0, 1)
                if progressFill then progressFill.Size = UDim2.new(progress, 0, 1, 0) end
                if progressPct then progressPct.Text = math.floor(progress * 100) .. "%" end
                if not prompt.Parent or not prompt.Parent.Parent then break end
                local char = LP.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp and (hrp.Position - prompt.Parent.Parent.Position).Magnitude > Steal.StealRadius then break end
                task.wait()
            end
            local stopProgress = math.clamp(autoGrabStopTime / duration, 0, 1)
            if progressFill then progressFill.Size = UDim2.new(stopProgress, 0, 1, 0) end
            if progressPct then progressPct.Text = math.floor(stopProgress * 100) .. "%" end
            local phase2Timeout = math.max(2.99 - autoGrabStopTime - math.max(duration - autoGrabStopTime, 0), 0.05)
            local phase2Start = tick()
            while isStealing and Steal.AutoStealEnabled do
                if tick() - phase2Start >= phase2Timeout then
                    if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
                    if progressPct then progressPct.Text = "0%" end
                    data.ready = true
                    isStealing = false
                    if _G.SetStealStatus then _G.SetStealStatus("IDLE") end
                    task.wait()
                    local newPrompt, newName = findNearestPrompt()
                    if newPrompt then executeSteal(newPrompt, newName) end
                    return
                end
                if not prompt.Parent or not prompt.Parent.Parent then
                    isStealing = false
                    if _G.SetStealStatus then _G.SetStealStatus("IDLE") end
                    if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
                    if progressPct then progressPct.Text = "0%" end
                    data.ready = true
                    return
                end
                local char = LP.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local dist = (hrp.Position - prompt.Parent.Parent.Position).Magnitude
                    if dist <= autoGrabSetDelayRadius then break
                    elseif dist > Steal.StealRadius then
                        isStealing = false
                        if _G.SetStealStatus then _G.SetStealStatus("IDLE") end
                        if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
                        if progressPct then progressPct.Text = "0%" end
                        data.ready = true
                        return
                    end
                end
                task.wait()
            end
            if isStealing and Steal.AutoStealEnabled then
                local fillStart = tick()
                local fillDuration = math.max(duration - autoGrabStopTime, 0.05)
                while true do
                    local fp = math.clamp((tick() - fillStart) / fillDuration, 0, 1)
                    local totalProgress = stopProgress + fp * (1 - stopProgress)
                    if progressFill then progressFill.Size = UDim2.new(totalProgress, 0, 1, 0) end
                    if progressPct then progressPct.Text = math.floor(totalProgress * 100) .. "%" end
                    if fp >= 1 and not promptFired then
                        promptFired = true
                        pcall(autoCarryOnSteal)
                        pcall(function()
                            for _, f in ipairs(data.trigger) do task.spawn(f) end
                            local remote = ReplicatedStorage:FindFirstChild("StealAnimal")
                            if remote and podName then remote:FireServer(podName) end
                            if prompt then prompt:Fire() end
                        end)
                        break
                    end
                    task.wait()
                end
            end
        else
            while isStealing and Steal.AutoStealEnabled do
                local elapsed = tick() - startTime
                local progress = math.clamp(elapsed / duration, 0, 1)
                if progressFill then progressFill.Size = UDim2.new(progress, 0, 1, 0) end
                if progressPct then progressPct.Text = math.floor(progress * 100) .. "%" end
                if not prompt.Parent or not prompt.Parent.Parent then break end
                local char = LP.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp and (hrp.Position - prompt.Parent.Parent.Position).Magnitude > Steal.StealRadius then break end
                if elapsed >= duration and not promptFired then
                    promptFired = true
                        pcall(autoCarryOnSteal)
                    pcall(function()
                        for _, f in ipairs(data.trigger) do task.spawn(f) end
                        local remote = ReplicatedStorage:FindFirstChild("StealAnimal")
                        if remote and podName then remote:FireServer(podName) end
                        if prompt then prompt:Fire() end
                    end)
                    break
                end
                task.wait()
            end
        end
        if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
        if progressPct then progressPct.Text = "0%" end
        if _G.SetStealStatus then _G.SetStealStatus("IDLE") end
        data.ready = true
        isStealing = false
    end)
end

function startAutoStealSemi()
    if stealConnection then return end
    Steal.StealRadius = CONFIG.STEAL_RANGE
    Steal.AutoStealEnabled = true
    stealConnection = RunService.Heartbeat:Connect(function()
        if not Steal.AutoStealEnabled or isStealing then return end
        local p, n = findNearestPrompt()
        if p then executeSteal(p, n) end
    end)
    _G.Lust.Connections.steal = stealConnection
    _G.Lust.Active.steal = true
end

function stopAutoSteal()
    if stealConnection then
        stealConnection:Disconnect()
        stealConnection = nil
        _G.Lust.Connections.steal = nil
        _G.Lust.Active.steal = false
    end
    isStealing = false
    Steal.AutoStealEnabled = false
    if progressFill then TS:Create(progressFill, TweenInfo.new(0.2), { Size = UDim2.new(0, 0, 1, 0) }):Play() end
    if progressPct then progressPct.Text = "0%" end
    if _G.SetStealStatus then _G.SetStealStatus("IDLE") end
end

CANDY_SKY_TAG = "MegumiSkyTheme"
candyOriginalLighting = nil

local CANDY_SKY_PRESETS = {
    ["Off"] = { kind = "off" },
    ["Night"] = { clock=22,brightness=2,ambient={110,100,130},outAmb={120,110,140},sky={stars=4000,moon=18,sun=0,moonTex=true},atm={dens=0.45,color={120,60,180},decay={60,20,100},glare=0.5,haze=1.2} },
    ["Aurora"] = { clock=14,brightness=3,ambient={150,120,150},outAmb={160,130,150},atm={dens=0.55,color={255,80,200},decay={255,20,150},glare=2.5,haze=3},clouds={cover=0.7,dens=0.7,color={255,240,250}} },
    ["Sunset"] = { clock=17.2,brightness=2.5,ambient={170,120,100},outAmb={180,130,110},sky={stars=0,sun=25,moon=0},atm={dens=0.5,color={255,130,60},decay={255,80,30},glare=2,haze=2.5},clouds={cover=0.55,dens=0.55,color={255,200,140}} },
    ["Galaxy"] = { clock=0,brightness=1.5,ambient={70,60,100},outAmb={80,70,110},sky={stars=10000,moon=30,sun=0},atm={dens=0.15,color={40,20,80},decay={20,10,50},glare=0.3,haze=0.5} },
    ["Cyber"] = { clock=21,brightness=2.2,ambient={90,130,170},outAmb={100,140,180},sky={stars=2000,moon=12},atm={dens=0.4,color={0,200,255},decay={150,0,255},glare=2,haze=2},clouds={cover=0.4,dens=0.6,color={100,200,255}} },
    ["Sakura"] = { clock=11,brightness=3.5,ambient={170,150,160},outAmb={180,160,170},sky={sun=8},atm={dens=0.3,color={255,200,220},decay={255,170,200},glare=1,haze=1.5},clouds={cover=0.6,dens=0.4,color={255,250,252}} },
    ["Pink Night"] = { clock=23,brightness=2.2,ambient={120,60,110},outAmb={140,70,120},sky={stars=5000,moon=22,sun=0,moonTex=true},atm={dens=0.5,color={255,80,180},decay={140,30,100},glare=0.7,haze=1.4},clouds={cover=0.3,dens=0.5,color={180,90,150}} },
    ["Blood Moon"] = { clock=22.5,brightness=1.6,ambient={130,40,40},outAmb={150,50,50},sky={stars=1500,moon=28,sun=0,moonTex=true},atm={dens=0.6,color={220,30,30},decay={120,10,10},glare=1.4,haze=2},clouds={cover=0.5,dens=0.7,color={120,30,30}} },
    ["Emerald Dawn"] = { clock=6.5,brightness=2.8,ambient={130,170,140},outAmb={140,180,150},sky={sun=18,moon=0,stars=0},atm={dens=0.4,color={80,200,140},decay={40,150,90},glare=1.8,haze=2.2},clouds={cover=0.5,dens=0.5,color={200,255,220}} },
    ["Volcanic"] = { clock=19,brightness=2,ambient={180,80,40},outAmb={200,90,50},sky={stars=200,sun=12,moon=0},atm={dens=0.75,color={255,60,0},decay={180,20,0},glare=3,haze=3.5},clouds={cover=0.8,dens=0.9,color={120,40,20}} },
    ["Arctic"] = { clock=9,brightness=3.2,ambient={200,220,235},outAmb={210,230,245},sky={sun=10,stars=0,moon=0},atm={dens=0.3,color={180,220,255},decay={140,200,240},glare=1.5,haze=1.8},clouds={cover=0.7,dens=0.6,color={250,253,255}} },
    ["Midnight Ocean"] = { clock=1.5,brightness=1.7,ambient={60,90,130},outAmb={70,100,140},sky={stars=6000,moon=24,sun=0,moonTex=true},atm={dens=0.5,color={20,60,140},decay={10,30,90},glare=0.6,haze=1.5} },
    ["Vaporwave"] = { clock=19.5,brightness=2.4,ambient={180,120,200},outAmb={190,130,210},sky={stars=1000,moon=14},atm={dens=0.45,color={255,100,220},decay={120,60,255},glare=2.2,haze=2.4},clouds={cover=0.5,dens=0.55,color={200,150,255}} },
    ["Toxic"] = { clock=13,brightness=2.5,ambient={140,180,80},outAmb={150,190,90},atm={dens=0.55,color={100,220,40},decay={60,150,20},glare=1.8,haze=2.6},clouds={cover=0.65,dens=0.7,color={180,255,120}} },
    ["Solar Eclipse"] = { clock=12,brightness=0.9,ambient={50,40,60},outAmb={60,50,70},sky={stars=3500,sun=22,moon=0},atm={dens=0.5,color={255,140,40},decay={30,20,40},glare=2.8,haze=1.8} },
    ["Hellscape"] = { clock=18,brightness=1.8,ambient={200,60,30},outAmb={220,70,40},sky={stars=100,sun=30,moon=0},atm={dens=0.85,color={255,30,0},decay={120,0,0},glare=3.5,haze=4},clouds={cover=0.95,dens=0.95,color={80,20,10}} },
    ["Heaven"] = { clock=12,brightness=4,ambient={240,235,210},outAmb={250,245,220},sky={sun=16,moon=0,stars=0},atm={dens=0.25,color={255,250,220},decay={255,240,200},glare=3,haze=1.5},clouds={cover=0.85,dens=0.5,color={255,255,255}} },
    ["Storm"] = { clock=15,brightness=1.4,ambient={90,90,110},outAmb={100,100,120},sky={stars=0,sun=6,moon=0},atm={dens=0.65,color={80,90,120},decay={40,50,80},glare=0.5,haze=3},clouds={cover=0.95,dens=0.95,color={60,65,80}} },
    ["Sunrise"] = { clock=6.2,brightness=2.8,ambient={220,180,130},outAmb={230,190,140},sky={sun=22,stars=0,moon=0},atm={dens=0.45,color={255,180,100},decay={255,140,80},glare=2.4,haze=2.2},clouds={cover=0.4,dens=0.4,color={255,220,180}} },
    ["Deep Space"] = { clock=0,brightness=1,ambient={30,25,50},outAmb={40,35,60},sky={stars=15000,moon=0,sun=0},atm={dens=0.08,color={15,5,40},decay={5,0,20},glare=0.2,haze=0.3} },
    ["Lavender Dream"] = { clock=18.5,brightness=2.6,ambient={180,160,220},outAmb={190,170,230},sky={stars=800,moon=16,sun=0},atm={dens=0.4,color={200,160,255},decay={160,120,220},glare=1.4,haze=1.8},clouds={cover=0.55,dens=0.5,color={220,200,255}} },
    ["Inferno"] = { clock=17.5,brightness=2.2,ambient={220,100,40},outAmb={235,110,50},sky={sun=26,moon=0,stars=0},atm={dens=0.6,color={255,90,20},decay={200,40,0},glare=3,haze=3.2},clouds={cover=0.7,dens=0.7,color={200,80,40}} },
    ["Mint Sky"] = { clock=10,brightness=3.2,ambient={180,230,210},outAmb={190,240,220},sky={sun=10},atm={dens=0.32,color={150,255,210},decay={100,220,180},glare=1.6,haze=1.6},clouds={cover=0.55,dens=0.45,color={240,255,250}} },
}

local CANDY_SKY_ORDER = {
    {"Off","Off"},{"Night","Night"},{"Aurora","Aurora"},{"Sunset","Sunset"},
    {"Galaxy","Galaxy"},{"Cyber","Cyber"},{"Sakura","Sakura"},
    {"Pink Night","Pink Night"},{"Blood Moon","Blood Moon"},
    {"Emerald Dawn","Emerald Dawn"},{"Volcanic","Volcanic"},
    {"Arctic","Arctic"},{"Midnight Ocean","Midnight Ocean"},
    {"Vaporwave","Vaporwave"},{"Toxic","Toxic"},
    {"Solar Eclipse","Solar Eclipse"},{"Hellscape","Hellscape"},
    {"Heaven","Heaven"},{"Storm","Storm"},{"Sunrise","Sunrise"},
    {"Deep Space","Deep Space"},{"Lavender Dream","Lavender Dream"},
    {"Inferno","Inferno"},{"Mint Sky","Mint Sky"}
}

local function candySaveOriginalLighting()
    if candyOriginalLighting then return end
    candyOriginalLighting = {
        ClockTime=Lighting.ClockTime, OutdoorAmbient=Lighting.OutdoorAmbient,
        Ambient=Lighting.Ambient, Brightness=Lighting.Brightness,
        FogStart=Lighting.FogStart, FogEnd=Lighting.FogEnd, FogColor=Lighting.FogColor,
        ColorShift_Top=Lighting.ColorShift_Top, ColorShift_Bottom=Lighting.ColorShift_Bottom,
        GeographicLatitude=Lighting.GeographicLatitude, GlobalShadows=Lighting.GlobalShadows,
        LightingChildren={}, TerrainChildren={}
    }
    for _, child in ipairs(Lighting:GetChildren()) do
        if child:IsA("Sky") or child:IsA("Atmosphere") then
            table.insert(candyOriginalLighting.LightingChildren, child:Clone())
        end
    end
    local terrain = workspace:FindFirstChildOfClass("Terrain")
    if terrain then
        for _, child in ipairs(terrain:GetChildren()) do
            if child:IsA("Clouds") then table.insert(candyOriginalLighting.TerrainChildren, child:Clone()) end
        end
    end
end

local function candyClearSky(removeAll)
    for _, child in ipairs(Lighting:GetChildren()) do
        if child:GetAttribute(CANDY_SKY_TAG) or (removeAll and (child:IsA("Sky") or child:IsA("Atmosphere"))) then
            pcall(function() child:Destroy() end)
        end
    end
    local terrain = workspace:FindFirstChildOfClass("Terrain")
    if terrain then
        for _, child in ipairs(terrain:GetChildren()) do
            if child:GetAttribute(CANDY_SKY_TAG) or (removeAll and child:IsA("Clouds")) then
                pcall(function() child:Destroy() end)
            end
        end
    end
end

local function candyInstance(className, parent, props)
    local inst = Instance.new(className)
    inst:SetAttribute(CANDY_SKY_TAG, true)
    for k, v in pairs(props or {}) do pcall(function() inst[k] = v end) end
    inst.Parent = parent
    return inst
end
local function candyColor(rgb) return Color3.fromRGB(rgb[1], rgb[2], rgb[3]) end

local function CandyApplyCustomSky(mode)
    candySaveOriginalLighting()
    candyClearSky(true)
    local terrain = workspace:FindFirstChildOfClass("Terrain")
    local preset = CANDY_SKY_PRESETS[mode]
    if not preset or preset.kind == "off" then
        if candyOriginalLighting then
            for k, v in pairs(candyOriginalLighting) do
                if k ~= "LightingChildren" and k ~= "TerrainChildren" then
                    pcall(function() Lighting[k] = v end)
                end
            end
            for _, child in ipairs(candyOriginalLighting.LightingChildren or {}) do child:Clone().Parent = Lighting end
            local offTerrain = workspace:FindFirstChildOfClass("Terrain")
            if offTerrain then
                for _, child in ipairs(candyOriginalLighting.TerrainChildren or {}) do child:Clone().Parent = offTerrain end
            end
        end
        currentSkyTheme = "Off"
        return
    end
    Lighting.FogStart = 0; Lighting.FogEnd = 100000
    Lighting.FogColor = Color3.fromRGB(200,200,200)
    Lighting.ColorShift_Top = Color3.fromRGB(0,0,0)
    Lighting.ColorShift_Bottom = Color3.fromRGB(0,0,0)
    Lighting.GlobalShadows = true
    Lighting.ClockTime = preset.clock or 14
    Lighting.Brightness = preset.brightness or 2
    if preset.outAmb then Lighting.OutdoorAmbient = candyColor(preset.outAmb) end
    if preset.ambient then Lighting.Ambient = candyColor(preset.ambient) end
    if preset.sky then
        local skyProps = {}
        if preset.sky.stars then skyProps.StarCount = preset.sky.stars end
        if preset.sky.moon then skyProps.MoonAngularSize = preset.sky.moon end
        if preset.sky.sun then skyProps.SunAngularSize = preset.sky.sun end
        if preset.sky.moonTex then skyProps.MoonTextureId = "rbxasset://sky/moon.jpg" end
        candyInstance("Sky", Lighting, skyProps)
    end
    if preset.atm then
        candyInstance("Atmosphere", Lighting, {
            Density=preset.atm.dens or 0.3, Color=candyColor(preset.atm.color),
            Decay=candyColor(preset.atm.decay), Glare=preset.atm.glare or 1, Haze=preset.atm.haze or 1
        })
    end
    if preset.clouds and terrain then
        candyInstance("Clouds", terrain, {
            Cover=preset.clouds.cover or 0.5, Density=preset.clouds.dens or 0.5,
            Color=candyColor(preset.clouds.color)
        })
    end
    currentSkyTheme = mode
end

local function setSkyTheme(theme)
    currentSkyTheme = theme
    CandyApplyCustomSky(theme)
    if skySelectorLabel then skySelectorLabel.Text = theme end
end

local ANIM_PACKS = {
    Tryhard = { idle1="rbxassetid://133806214992291", idle2="rbxassetid://94970088341563",
        walk="rbxassetid://707897309", run="rbxassetid://707861613",
        jump="rbxassetid://116936326516985", fall="rbxassetid://116936326516985",
        climb="rbxassetid://116936326516985", swim="rbxassetid://116936326516985",
        swimidle="rbxassetid://116936326516985" },
    Crazy = { idle1="rbxassetid://133806214992291", idle2="rbxassetid://94970088341563",
        walk="rbxassetid://134824450619865", run="rbxassetid://134824450619865",
        jump="rbxassetid://121454505477205", fall="rbxassetid://94788218468396",
        climb="rbxassetid://121454505477205", swim="rbxassetid://121454505477205",
        swimidle="rbxassetid://121454505477205" },
    ["Zombie"] = { idle1="rbxassetid://616158929", idle2="rbxassetid://616160636", walk="rbxassetid://616168032", run="rbxassetid://616163682", jump="rbxassetid://616161997", fall="rbxassetid://616157476", climb="rbxassetid://616156119", swim="rbxassetid://616165109", swimidle="rbxassetid://616166655" },
    ["Ninja"] = { idle1="rbxassetid://656117400", idle2="rbxassetid://656117400", walk="rbxassetid://656121766", run="rbxassetid://656118852", jump="rbxassetid://656117878", fall="rbxassetid://656115606", climb="rbxassetid://656114359", swim="rbxassetid://656117400", swimidle="rbxassetid://656117400" },
    ["Knight"] = { idle1="rbxassetid://657595757", idle2="rbxassetid://657595757", walk="rbxassetid://657552124", run="rbxassetid://657564596", jump="rbxassetid://658409194", fall="rbxassetid://657600338", climb="rbxassetid://658360781", swim="rbxassetid://657595757", swimidle="rbxassetid://657595757" },
    ["Elder"] = { idle1="rbxassetid://845397899", idle2="rbxassetid://845397899", walk="rbxassetid://845403856", run="rbxassetid://845386501", jump="rbxassetid://845398858", fall="rbxassetid://845397673", climb="rbxassetid://845392038", swim="rbxassetid://845397899", swimidle="rbxassetid://845397899" },
    ["Levitate"] = { idle1="rbxassetid://616006778", idle2="rbxassetid://616006778", walk="rbxassetid://616013216", run="rbxassetid://616013216", jump="rbxassetid://616008936", fall="rbxassetid://616005863", climb="rbxassetid://616003713", swim="rbxassetid://616006778", swimidle="rbxassetid://616006778" },
    ["Astronaut"] = { idle1="rbxassetid://891621366", idle2="rbxassetid://891621366", walk="rbxassetid://891636393", run="rbxassetid://891636393", jump="rbxassetid://891627522", fall="rbxassetid://891617961", climb="rbxassetid://891609353", swim="rbxassetid://891621366", swimidle="rbxassetid://891621366" },
    ["Pirate"] = { idle1="rbxassetid://750781874", idle2="rbxassetid://750781874", walk="rbxassetid://750785693", run="rbxassetid://750783738", jump="rbxassetid://750782230", fall="rbxassetid://750780242", climb="rbxassetid://750779899", swim="rbxassetid://750781874", swimidle="rbxassetid://750781874" },
    ["Toy"] = { idle1="rbxassetid://782841498", idle2="rbxassetid://782841498", walk="rbxassetid://782843345", run="rbxassetid://782842708", jump="rbxassetid://782847020", fall="rbxassetid://782846423", climb="rbxassetid://782843869", swim="rbxassetid://782841498", swimidle="rbxassetid://782841498" },
    ["Vampire"] = { idle1="rbxassetid://1083445855", idle2="rbxassetid://1083445855", walk="rbxassetid://1083473930", run="rbxassetid://1083462077", jump="rbxassetid://1083455352", fall="rbxassetid://1083443587", climb="rbxassetid://1083439238", swim="rbxassetid://1083445855", swimidle="rbxassetid://1083445855" },
    ["Werewolf"] = { idle1="rbxassetid://1083195517", idle2="rbxassetid://1083195517", walk="rbxassetid://1083178339", run="rbxassetid://1083216690", jump="rbxassetid://1083218792", fall="rbxassetid://1083189019", climb="rbxassetid://1083182000", swim="rbxassetid://1083195517", swimidle="rbxassetid://1083195517" },
    ["Rthro"] = { idle1="rbxassetid://2510196951", idle2="rbxassetid://2510196951", walk="rbxassetid://2510202577", run="rbxassetid://2510198475", jump="rbxassetid://2510197830", fall="rbxassetid://2510195892", climb="rbxassetid://2510192778", swim="rbxassetid://2510196951", swimidle="rbxassetid://2510196951" },
    ["Stylish"] = { idle1="rbxassetid://616136790", idle2="rbxassetid://616136790", walk="rbxassetid://616146177", run="rbxassetid://616140816", jump="rbxassetid://616139451", fall="rbxassetid://616134815", climb="rbxassetid://616133594", swim="rbxassetid://616136790", swimidle="rbxassetid://616136790" }
}
local ANIM_PACK_ORDER = {{"Off","Off"},{"Unwalk","Unwalk"},{"Tryhard","Tryhard"},{"Crazy","Crazy"},{"Zombie","Zombie"},{"Ninja","Ninja"},{"Knight","Knight"},{"Elder","Elder"},{"Levitate","Levitate"},{"Astronaut","Astronaut"},{"Pirate","Pirate"},{"Toy","Toy"},{"Vampire","Vampire"},{"Werewolf","Werewolf"},{"Rthro","Rthro"},{"Stylish","Stylish"}}
local ACCESSORY_PACK_ORDER = {{"Off","Off"},{"Bleed 1","Bleed 1"},{"Bleed 2","Bleed 2"},{"Bleed 3","Bleed 3"}}
local BLEED_PACKS = {
    ["Bleed 1"] = { accessory=306969564, offset=Vector3.new(0,0.3,0),
        headMesh="http://www.roblox.com/asset/?id=134079402",
        headTexture="http://www.roblox.com/asset/?id=133940918",
        shirt="http://www.roblox.com/asset/?id=10632503795",
        pants="http://www.roblox.com/asset/?id=123161592384863", korblox="right" },
    ["Bleed 2"] = { accessory=1744060292, offset=Vector3.new(0,1.4,-0.2),
        headMesh="http://www.roblox.com/asset/?id=134079402",
        headTexture="http://www.roblox.com/asset/?id=133940918",
        shirt="http://www.roblox.com/asset/?id=11526718530",
        pants="http://www.roblox.com/asset/?id=93710523210027", korblox="right" },
    ["Bleed 3"] = { accessory=112564966849233, offset=Vector3.new(0,0.6,0),
        headMesh="http://www.roblox.com/asset/?id=134079402",
        headTexture="http://www.roblox.com/asset/?id=133940918",
        shirt="http://www.roblox.com/asset/?id=11849088376",
        pants="http://www.roblox.com/asset/?id=16534673928", korblox="right" },
}

local function saveOriginalOutfit(char)
    if not char then return end
    local shirt = char:FindFirstChildWhichIsA("Shirt")
    local pants = char:FindFirstChildWhichIsA("Pants")
    _G.Lust.OriginalOutfit.shirt = shirt and shirt.ShirtTemplate or nil
    _G.Lust.OriginalOutfit.pants = pants and pants.PantsTemplate or nil
end

local function restoreOriginalOutfit(char)
    if not char then return end
    for _, obj in ipairs(char:GetChildren()) do
        if obj:IsA("Shirt") or obj:IsA("Pants") then obj:Destroy() end
    end
    if _G.Lust.OriginalOutfit.shirt then
        local s = Instance.new("Shirt"); s.ShirtTemplate = _G.Lust.OriginalOutfit.shirt; s.Parent = char
    end
    if _G.Lust.OriginalOutfit.pants then
        local p = Instance.new("Pants"); p.PantsTemplate = _G.Lust.OriginalOutfit.pants; p.Parent = char
    end
    _G.Lust.OriginalOutfit.shirt = nil; _G.Lust.OriginalOutfit.pants = nil
end

local function clearAllOutfit(char)
    if not char then return end
    for _, obj in ipairs(char:GetChildren()) do
        if obj:IsA("Shirt") or obj:IsA("Pants") then obj:Destroy() end
    end
end

local function saveOriginalAccessories(char)
    _G.Lust.OriginalAccessories = {}
    if not char then return end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Accessory") or child:IsA("Hat") then
            table.insert(_G.Lust.OriginalAccessories, child:Clone())
        end
    end
end

local function restoreOriginalAccessories(char)
    if not char then return end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Accessory") or child:IsA("Hat") or child.Name == "AuFfitAccessory" then child:Destroy() end
    end
    for _, clone in ipairs(_G.Lust.OriginalAccessories) do
        if clone and clone.Parent == nil then
            local newAcc = clone:Clone()
            newAcc.Parent = char
            for _, weld in ipairs(newAcc:GetDescendants()) do
                if weld:IsA("Weld") or weld:IsA("WeldConstraint") then
                    local p0, p1 = weld.Part0, weld.Part1
                    if p0 and p0.Name then local n = char:FindFirstChild(p0.Name); if n then weld.Part0 = n end end
                    if p1 and p1.Name then local n = char:FindFirstChild(p1.Name); if n then weld.Part1 = n end end
                end
            end
        end
    end
    _G.Lust.OriginalAccessories = {}
end

local function clearAllAccessories(char)
    if not char then return end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Accessory") or child:IsA("Hat") or child.Name == "AuFfitAccessory" then child:Destroy() end
        if child.Name:find("Korblox_") or child.Name:find("Headless_") then child:Destroy() end
    end
    for _, partName in ipairs({"Head","LeftUpperLeg","LeftLowerLeg","LeftFoot","RightUpperLeg","RightLowerLeg","RightFoot"}) do
        local part = char:FindFirstChild(partName)
        if part and part:IsA("BasePart") then part.Transparency = 0 end
    end
    local head = char:FindFirstChild("Head")
    if head and head:IsA("MeshPart") then head.Transparency = 0 end
end

local function applyBleedOutfit(packName)
    local config = BLEED_PACKS[packName]
    if not config then return false end
    local char = LP.Character
    if not char then return false end
    char:WaitForChild("Head", 10)
    local head = char:FindFirstChild("Head")
    if not head then return false end
    if config.headMesh then
        for _, d in ipairs(char:GetChildren()) do
            if d:IsA("CharacterMesh") and d.BodyPart == Enum.BodyPart.Head then pcall(function() d:Destroy() end) end
        end
        local done = false
        if head:IsA("MeshPart") then
            done = pcall(function()
                head.MeshId = config.headMesh
                if config.headTexture then head.TextureID = config.headTexture end
            end)
        end
        if not done then
            local sm = head:FindFirstChildWhichIsA("SpecialMesh") or Instance.new("SpecialMesh")
            sm.Parent = head; sm.MeshType = Enum.MeshType.FileMesh
            sm.MeshId = config.headMesh; sm.TextureId = config.headTexture or ""
        end
    end
    if config.shirt then
        local s = char:FindFirstChildWhichIsA("Shirt") or Instance.new("Shirt")
        s.Name = "Shirt"; s.ShirtTemplate = config.shirt; s.Parent = char
    end
    if config.pants then
        local p = char:FindFirstChildWhichIsA("Pants") or Instance.new("Pants")
        p.Name = "Pants"; p.PantsTemplate = config.pants; p.Parent = char
    end
    if config.accessory and head then
        local old = char:FindFirstChild("AuFfitAccessory"); if old then old:Destroy() end
        local objs = nil
        local ok, res = pcall(function() return game:GetObjects("rbxassetid://" .. tostring(config.accessory)) end)
        if ok and typeof(res) == "table" and #res > 0 then objs = res
        else
            ok, res = pcall(function() return game:GetService("InsertService"):LoadAsset(config.accessory) end)
            if ok and res then objs = {res} end
        end
        if objs then
            local handle
            for _, o in ipairs(objs) do
                if o:IsA("BasePart") then handle = o; break end
                local f = o:FindFirstChildWhichIsA("BasePart", true)
                if f then handle = f; break end
            end
            if handle then
                local h = handle:Clone()
                h.Name = "AuFfitAccessory"; h.CanCollide = false
                h.Anchored = false; h.Massless = true; h.Parent = char
                local weld = Instance.new("Weld")
                weld.Part0 = head; weld.Part1 = h
                weld.C0 = CFrame.new(config.offset or Vector3.zero); weld.Parent = h
            end
            for _, o in ipairs(objs) do pcall(function() o:Destroy() end) end
        end
    end
    if config.korblox and config.korblox ~= "none" then
        local function attachKorblox(side)
            local ids = { left = 139607673, right = 139607718 }
            local targets = { left = "LeftUpperLeg", right = "RightUpperLeg" }
            local hides = { left={"LeftUpperLeg","LeftLowerLeg","LeftFoot"}, right={"RightUpperLeg","RightLowerLeg","RightFoot"} }
            local targetPart = char:FindFirstChild(targets[side])
            if not targetPart then return false end
            for _, partName in ipairs(hides[side]) do
                local limb = char:FindFirstChild(partName)
                if limb and limb:IsA("BasePart") then limb.Transparency = 1 end
            end
            local success, objects = pcall(function() return game:GetObjects("rbxassetid://" .. ids[side]) end)
            if not success or not objects or #objects == 0 then return false end
            local assetModel = objects[1]
            local mainMesh = assetModel:IsA("BasePart") and assetModel or assetModel:FindFirstChildWhichIsA("BasePart", true)
            if not mainMesh then assetModel:Destroy(); return false end
            mainMesh.CanCollide = false; mainMesh.Massless = true
            mainMesh.CFrame = targetPart.CFrame
            local weld = Instance.new("WeldConstraint")
            weld.Part0 = targetPart; weld.Part1 = mainMesh; weld.Parent = mainMesh
            assetModel.Parent = char
            return true
        end
        if config.korblox == "left" then attachKorblox("left")
        elseif config.korblox == "right" then attachKorblox("right") end
    end
    return true
end

local function applyAccessoryPack(packName)
    local char = LP.Character
    if not char then return end
    if packName == "Off" then
        clearAllAccessories(char)
        restoreOriginalOutfit(char)
        restoreOriginalAccessories(char)
        return
    end
    if not _G.Lust.OriginalOutfit.shirt and not _G.Lust.OriginalOutfit.pants then saveOriginalOutfit(char) end
    if #_G.Lust.OriginalAccessories == 0 then saveOriginalAccessories(char) end
    clearAllOutfit(char)
    clearAllAccessories(char)
    applyBleedOutfit(packName)
end

local function isPackAnim(id)
    for _, pack in pairs(ANIM_PACKS) do
        for _, v in pairs(pack) do if v == id then return true end end
    end
    return false
end

local function saveOriginalAnims(char)
    local animate = char:FindFirstChild("Animate")
    if not animate then return end
    local function g(obj) return obj and obj.AnimationId or nil end
    local ids = {
        idle1 = g(animate.idle and animate.idle.Animation1),
        idle2 = g(animate.idle and animate.idle.Animation2),
        walk  = g(animate.walk and animate.walk.WalkAnim),
        run   = g(animate.run  and animate.run.RunAnim),
        jump  = g(animate.jump and animate.jump.JumpAnim),
        fall  = g(animate.fall and animate.fall.FallAnim),
        climb = g(animate.climb and animate.climb.ClimbAnim),
        swim  = g(animate.swim and animate.swim.Swim),
        swimidle = g(animate.swimidle and animate.swimidle.SwimIdle),
    }
    if not isPackAnim(ids.walk) then originalTryardAnims = ids end
end

local function applyAnimPack(packName)
    currentAnimPack = packName
    if animSelectorLabel then animSelectorLabel.Text = packName end
    if packName == "Unwalk" then
        if unwalkEnabled then return end
        unwalkEnabled = true
        local char = LP.Character
        local animate = char and char:FindFirstChild("Animate")
        if animate then
            if not unwalkSavedAnimate then unwalkSavedAnimate = animate:Clone() end
            for _, track in ipairs(char.Humanoid:GetPlayingAnimationTracks()) do pcall(function() track:Stop(0) end) end
            animate:Destroy()
        end
        return
    end
    if unwalkEnabled then
        unwalkEnabled = false
        if LP.Character and not LP.Character:FindFirstChild("Animate") and unwalkSavedAnimate then
            local newAnimate = unwalkSavedAnimate:Clone()
            newAnimate.Parent = LP.Character
            task.wait()
            local hum = LP.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum:ChangeState(Enum.HumanoidStateType.Running) end
        end
    end
    if packName == "Off" then
        if originalTryardAnims and LP.Character then
            local animate = LP.Character:FindFirstChild("Animate")
            if animate then
                local function s(obj,id) if obj then obj.AnimationId = id end end
                s(animate.idle and animate.idle.Animation1, originalTryardAnims.idle1)
                s(animate.idle and animate.idle.Animation2, originalTryardAnims.idle2)
                s(animate.walk and animate.walk.WalkAnim, originalTryardAnims.walk)
                s(animate.run and animate.run.RunAnim, originalTryardAnims.run)
                s(animate.jump and animate.jump.JumpAnim, originalTryardAnims.jump)
                s(animate.fall and animate.fall.FallAnim, originalTryardAnims.fall)
                s(animate.climb and animate.climb.ClimbAnim, originalTryardAnims.climb)
                s(animate.swim and animate.swim.Swim, originalTryardAnims.swim)
                s(animate.swimidle and animate.swimidle.SwimIdle, originalTryardAnims.swimidle)
            end
        end
        if tryardHeartbeatConn then tryardHeartbeatConn:Disconnect(); tryardHeartbeatConn = nil end
        return
    end
    local pack = ANIM_PACKS[packName]
    if not pack then return end
    if tryardHeartbeatConn then tryardHeartbeatConn:Disconnect() end
    tryardHeartbeatConn = RunService.Heartbeat:Connect(function()
        local c = LP.Character
        if not c then return end
        local animate = c:FindFirstChild("Animate")
        if not animate then return end
        local function s(obj,id) if obj then obj.AnimationId = id end end
        s(animate.idle and animate.idle.Animation1, pack.idle1)
        s(animate.idle and animate.idle.Animation2, pack.idle2)
        s(animate.walk and animate.walk.WalkAnim, pack.walk)
        s(animate.run and animate.run.RunAnim, pack.run)
        s(animate.jump and animate.jump.JumpAnim, pack.jump)
        s(animate.fall and animate.fall.FallAnim, pack.fall)
        s(animate.climb and animate.climb.ClimbAnim, pack.climb)
        s(animate.swim and animate.swim.Swim, pack.swim)
        s(animate.swimidle and animate.swimidle.SwimIdle, pack.swimidle)
    end)
end

local function startAnimPack(packName)
    local char = LP.Character
    if char then
        saveOriginalAnims(char); applyAnimPack(packName)
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            for _, track in ipairs(hum:GetPlayingAnimationTracks()) do track:Stop(0) end
            hum:ChangeState(Enum.HumanoidStateType.Running)
        end
    else applyAnimPack(packName) end
    currentAnimPack = packName
end

local function stopAnimPack()
    currentAnimPack = "Off"
    if animSelectorLabel then animSelectorLabel.Text = "Off" end
    applyAnimPack("Off")
end

DEFAULT_KB = {
    DropBrainrot={kb=Enum.KeyCode.X,gp=nil}, AutoLeft={kb=Enum.KeyCode.Z,gp=nil},
    AutoRight={kb=Enum.KeyCode.C,gp=nil}, AutoBat={kb=Enum.KeyCode.E,gp=nil},
    TPFloor={kb=Enum.KeyCode.F,gp=nil}, CarryToggle={kb=Enum.KeyCode.Q,gp=nil},
    LaggerMode={kb=Enum.KeyCode.R,gp=nil}, InstaReset={kb=Enum.KeyCode.G,gp=nil},
    Bypass={kb=Enum.KeyCode.N,gp=nil},
}
KB = {}
for k, v in pairs(DEFAULT_KB) do KB[k] = {kb = v.kb, gp = v.gp} end

_isResetting = false
_lastSavedJSON = nil
_isLoading = false
_saveDisabled = true

medusaDebounce = false
medusaLastUsed = 0
dropActive = false
lastDropTime = 0
lastMoveDir = Vector3.new(0,0,0)
origFOV = 70
resetCooldown = false
resetThread = nil
currentResetChar = nil
resetSuccessful = false
stopResetSequence = false
cameraLocked = false
lockedCameraCFrame = nil

local RESET_MAX_DURATION = 0.05
local RESET_BUTTON_COOLDOWN = 0.2
local _frameResetCooldown = false
local _frameResetCooldownTS = 0
local _frameResetThread = nil
local _frameStopReset = false

local function FrameReset()
    if _frameResetCooldown then return end
    local now = tick()
    if now - _frameResetCooldownTS < RESET_BUTTON_COOLDOWN then return end
    _frameResetCooldownTS = now
    _frameResetCooldown = true
    _frameStopReset = false
    local character = LP.Character
    if not character then _frameResetCooldown = false return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then _frameResetCooldown = false return end
    _frameResetThread = task.spawn(function()
        local attempts = 0
        local originalHipHeight = humanoid.HipHeight
        while character and character.Parent and humanoid and humanoid.Health > 0
              and not _frameStopReset and LP.Character == character do
            pcall(function()
                humanoid.HipHeight = 1e30
                humanoid.AutoRotate = true
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                if rootPart then rootPart.CanCollide = false end
                for _, part in ipairs(character:GetChildren()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then part.CanCollide = false end
                end
            end)
            if not character or not character.Parent or not humanoid or humanoid.Health <= 0 or LP.Character ~= character then break end
            attempts = attempts + 1
            if attempts >= 40 then break end
            task.wait(RESET_MAX_DURATION)
        end
        if character and character.Parent and humanoid and humanoid.Health > 0 and not _frameStopReset then
            pcall(function() humanoid.Health = 0 end)
        end
        if not _frameStopReset and character and character.Parent and humanoid then
            pcall(function() humanoid.HipHeight = originalHipHeight end)
        end
        _frameResetCooldown = false
        _frameResetThread = nil
        _frameStopReset = false
    end)
end

local function AdaptAutoResetShouldFire(part)
    local state = _G.AdaptAutoResetOnMed
    if not state or not state.enabled then return false end
    if state.medTriggered then return false end
    if tick() - (state.lastFire or 0) < (state.cooldown or 2.25) then return false end
    if not part or not part.Parent then return false end
    if part:FindFirstAncestorOfClass("Tool") or part:FindFirstAncestorOfClass("Accessory") then return false end
    return part.Anchored and part.Transparency == 1
end

local function AdaptAutoResetFireOnce(part)
    if not AdaptAutoResetShouldFire(part) then return end
    local state = _G.AdaptAutoResetOnMed
    state.medTriggered = true
    state.lastFire = tick()
    if FrameReset then FrameReset() end
    task.delay(2.3, function()
        if state.enabled then state.medTriggered = false end
    end)
end

local function AdaptStopAutoResetOnMed()
    local state = _G.AdaptAutoResetOnMed
    if not state then return end
    for _, conn in ipairs(state.conns or {}) do pcall(function() conn:Disconnect() end) end
    state.conns = {}
    state.medTriggered = false
end

local function AdaptStartAutoResetOnMed(char)
    local state = _G.AdaptAutoResetOnMed
    if not state then return end
    AdaptStopAutoResetOnMed()
    state.medTriggered = false
    char = char or LP.Character
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            table.insert(state.conns, part:GetPropertyChangedSignal("Anchored"):Connect(function()
                AdaptAutoResetFireOnce(part)
            end))
            AdaptAutoResetFireOnce(part)
        end
    end
    table.insert(state.conns, char.DescendantAdded:Connect(function(part)
        if part:IsA("BasePart") then
            table.insert(state.conns, part:GetPropertyChangedSignal("Anchored"):Connect(function()
                AdaptAutoResetFireOnce(part)
            end))
            AdaptAutoResetFireOnce(part)
        end
    end))
    table.insert(state.conns, char.AncestryChanged:Connect(function(_, parent)
        if not parent then state.medTriggered = false end
    end))
end

function setAutoResetOnMedState(enabled)
    autoResetOnMedEnabled = enabled == true
    if autoResetOnMedEnabled then
        _G.AdaptAutoResetOnMed.enabled = true
        AdaptStartAutoResetOnMed(LP.Character)
    else
        _G.AdaptAutoResetOnMed.enabled = false
        AdaptStopAutoResetOnMed()
    end
    if setAutoResetOnMedVisual then setAutoResetOnMedVisual(autoResetOnMedEnabled) end
    saveAllSettings()
end

LP.CharacterAdded:Connect(function(newChar)
    stopResetSequence = true
    if resetThread then task.cancel(resetThread); resetThread = nil end
    resetCooldown = false; currentResetChar = nil; cameraLocked = false
    _frameStopReset = true
    if _frameResetThread then task.cancel(_frameResetThread); _frameResetThread = nil end
    _frameResetCooldown = false; _frameStopReset = false
    if autoResetOnMedEnabled then
        task.wait(0.25)
        AdaptStartAutoResetOnMed(newChar)
    end
end)

task.spawn(function()
    local cam = workspace.CurrentCamera
    while true do
        task.wait(0.016)
        if cameraLocked and lockedCameraCFrame and cam then cam.CFrame = lockedCameraCFrame end
    end
end)

_anyKeyListening = false
_prevAutoRotate = nil
dropConnections = {}
enemySpeedLabels = {}
keyButtonRefs = {}
progressFill = nil
progressPct = nil
progressRadLbl = nil
pbFrame = nil
speedLabel = nil
modeValLbl = nil
normalBox, carryBox, laggerBox, lagger2Box, radInput, autoTPHeightBox, uiScaleBox = nil,nil,nil,nil,nil,nil,nil
aimbotSpeedBox = nil
stealDurationBox = nil
dropModeBtnRef = nil
setJumpToggleState = nil
autoBatSetVisual, autoLeftSetVisual, autoRightSetVisual, setBatCounterVisual, setMedusaVisual = nil,nil,nil,nil,nil
setAntiRagVisual, setJumpVisual, setAntiLagVisual, setAutoTPDownVisual, setLockUIVisual, setInstaGrab, bypassSetVisual = nil,nil,nil,nil,nil,nil,nil
setEditModeVisual, setESPVIsual, setESPLineVisual, setVividVisual = nil, nil, nil, nil
mirrorTPDownSetVisual = nil
setAutoResetOnMedVisual = nil
mobSetAutoBat, mobSetAutoLeft, mobSetAutoRight, mobSetDropBR, mobSetTpDown, mobSetCarry, mobSetLagger1, mobSetLagger2 = nil,nil,nil,nil,nil,nil,nil,nil
miniBtn, main, gui = nil, nil, nil
MobilePanel = nil
instaResetFloatingButton = nil
bypassFloatingButton = nil
showGui = nil; hideGui = nil
mainUIScale = nil
skySelectorLabel = nil
animSelectorLabel = nil
outfitSelectorLabel = nil
accSelectorLabel = nil
pbScale = nil
function applyStealBarScale()
    if pbScale then
        pbScale.Scale = (uiScaleValue / 100) * (math.clamp(stealBarSize or 100, 50, 200) / 100)
    end
end
autoTPConn = nil
bodyLockSetVisual = nil
_blSuppressCount = 0
_blWasEnabled = false
_blRestoreTimer = nil
savedProgressBarPos = nil
savedButtonPositions = {}
savedMobilePanelPos = nil
instaResetFloatingPos = nil
bypassFloatingPos = nil
menuFramePos = nil
currentBgIndex = 1
resetButtonSetVisual = nil

GAMEPAD_KEYS = {
    [Enum.KeyCode.ButtonA]=true,[Enum.KeyCode.ButtonB]=true,[Enum.KeyCode.ButtonX]=true,[Enum.KeyCode.ButtonY]=true,
    [Enum.KeyCode.ButtonL1]=true,[Enum.KeyCode.ButtonR1]=true,[Enum.KeyCode.ButtonL2]=true,[Enum.KeyCode.ButtonR2]=true,
    [Enum.KeyCode.ButtonL3]=true,[Enum.KeyCode.ButtonR3]=true,[Enum.KeyCode.ButtonStart]=true,[Enum.KeyCode.ButtonSelect]=true,
    [Enum.KeyCode.DPadUp]=true,[Enum.KeyCode.DPadDown]=true,[Enum.KeyCode.DPadLeft]=true,[Enum.KeyCode.DPadRight]=true,
}
MOVE_KEYS = {
    [Enum.KeyCode.W]=true,[Enum.KeyCode.A]=true,[Enum.KeyCode.S]=true,[Enum.KeyCode.D]=true,
    [Enum.KeyCode.Up]=true,[Enum.KeyCode.Left]=true,[Enum.KeyCode.Down]=true,[Enum.KeyCode.Right]=true,
}
local BAT_COUNTER_SLAP_LIST = {
    "Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap",
    "Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"
}
AP = {
    L1=Vector3.new(-476.48,-6.28,92.73), L2=Vector3.new(-483.12,-4.95,94.80),
    L_FACE=Vector3.new(-482.25,-4.96,92.09),
    R1=Vector3.new(-476.16,-6.52,25.62), R2=Vector3.new(-483.06,-5.03,25.48),
    R_FACE=Vector3.new(-482.06,-6.93,35.47),
}

function isGamepadInput(inp) return inp and inp.UserInputType and inp.UserInputType.Name:match("^Gamepad") ~= nil end
function isBindableInput(inp)
    if not inp or inp.KeyCode == Enum.KeyCode.Unknown then return false end
    if inp.UserInputType == Enum.UserInputType.Keyboard then return true end
    return isGamepadInput(inp) and GAMEPAD_KEYS[inp.KeyCode] == true
end
function kbMatch(entry, kc) return kc and (kc == entry.kb or (entry.gp and kc == entry.gp)) end

stealBarStyle = "Compact"

local STEAL_COLORS = {
    rootBg=Color3.fromRGB(40, 10, 25), stroke=Color3.fromRGB(255, 20, 147),
    imageShade=Color3.fromRGB(40, 10, 25), percent=Color3.fromRGB(255, 255, 255),
    statusCompact=Color3.fromRGB(255, 150, 200), statusClassic=Color3.fromRGB(255, 255, 255),
    divider=Color3.fromRGB(255, 20, 147), fps=Color3.fromRGB(255, 150, 200),
    track=Color3.fromRGB(70, 20, 45), accent=Color3.fromRGB(255, 20, 147),
    white=Color3.fromRGB(255, 255, 255),
}

local STEAL_BAR_STYLES = {
    Compact = {
        size=Vector2.new(372,54), defaultPos=UDim2.new(0.5,-186,1,-134),
        cornerRadius=UDim.new(0,8), bgTransparency=0.22, strokeThickness=0.8,
        strokeTransparency=0.55, dividerTransparency=0.62, trackTransparency=0.08,
        imageTransparency=0.05,
        percent={size=UDim2.fromOffset(70,22),pos=UDim2.fromOffset(14,24),textSize=15,font=Enum.Font.GothamBold,align=Enum.TextXAlignment.Left},
        status={size=UDim2.fromOffset(70,16),pos=UDim2.fromOffset(14,7),textSize=8,font=Enum.Font.GothamBold,align=Enum.TextXAlignment.Left},
        divider={size=UDim2.fromOffset(1,34),pos=UDim2.fromOffset(88,10)},
        fpsLabel={size=UDim2.fromOffset(28,18),pos=UDim2.fromOffset(104,28),textSize=8,font=Enum.Font.Gotham},
        fpsValue={size=UDim2.fromOffset(42,18),pos=UDim2.fromOffset(134,28),textSize=10,font=Enum.Font.GothamMedium},
        pingLabel={size=UDim2.fromOffset(34,18),pos=UDim2.fromOffset(211,28),textSize=8,font=Enum.Font.Gotham},
        pingValue={size=UDim2.fromOffset(62,18),pos=UDim2.fromOffset(247,28),textSize=10,font=Enum.Font.GothamMedium},
        track={size=UDim2.fromOffset(258,15),pos=UDim2.fromOffset(101,8)},
        glossYScale=0.36, glossTransparency=0.76,
    },
    Classic = {
        size=Vector2.new(440,44), defaultPos=UDim2.new(0.5,-220,1,-124),
        cornerRadius=UDim.new(1,0), bgTransparency=0.4, strokeThickness=0.6,
        strokeTransparency=0.55, dividerTransparency=0.4, trackTransparency=0.4,
        imageTransparency=0.1,
        percent={size=UDim2.new(0,46,1,0),pos=UDim2.fromOffset(10,0),textSize=13,font=Enum.Font.GothamBold,align=Enum.TextXAlignment.Center},
        status={size=UDim2.fromOffset(80,44),pos=UDim2.fromOffset(52,0),textSize=14,font=Enum.Font.GothamBold,align=Enum.TextXAlignment.Center},
        divider={size=UDim2.fromOffset(1,22),pos=UDim2.new(0,248,0.5,-11)},
        fpsLabel={size=UDim2.new(0,28,1,0),pos=UDim2.fromOffset(256,0),textSize=11,font=Enum.Font.GothamBold},
        fpsValue={size=UDim2.new(0,36,1,0),pos=UDim2.fromOffset(282,0),textSize=12,font=Enum.Font.GothamBold},
        pingLabel={size=UDim2.new(0,32,1,0),pos=UDim2.fromOffset(322,0),textSize=11,font=Enum.Font.GothamBold},
        pingValue={size=UDim2.new(0,54,1,0),pos=UDim2.fromOffset(354,0),textSize=12,font=Enum.Font.GothamBold},
        track={size=UDim2.fromOffset(240,32),pos=UDim2.new(0,4,0.5,-16)},
        glossYScale=0.48, glossTransparency=0.76,
    },
}

function buildStealBar(styleName)
    styleName = styleName or stealBarStyle or "Compact"
    stealBarStyle = styleName
    local S = STEAL_BAR_STYLES[styleName] or STEAL_BAR_STYLES.Compact
    local isCompact = (styleName == "Compact")
    if pbFrame then pcall(function() pbFrame:Destroy() end) end
    pbFrame = nil; progressFill = nil; progressPct = nil; pbScale = nil
    if not gui then return end
    local barFrame = Instance.new("Frame", gui)
    barFrame.Name = "StealProgressGui"
    barFrame.Size = UDim2.fromOffset(S.size.X, S.size.Y)
    barFrame.Position = S.defaultPos
    if savedProgressBarPos then
        barFrame.Position = UDim2.new(
            savedProgressBarPos.XScale or S.defaultPos.X.Scale,
            savedProgressBarPos.XOffset or S.defaultPos.X.Offset,
            savedProgressBarPos.YScale or S.defaultPos.Y.Scale,
            savedProgressBarPos.YOffset or S.defaultPos.Y.Offset)
    end
    barFrame.BackgroundColor3 = STEAL_COLORS.rootBg
    barFrame.BackgroundTransparency = S.bgTransparency
    barFrame.BorderSizePixel = 0
    barFrame.Active = true
    barFrame.ClipsDescendants = false
    barFrame.ZIndex = 300
    Instance.new("UICorner", barFrame).CornerRadius = S.cornerRadius
    local bgImg = Instance.new("ImageLabel", barFrame)
    bgImg.Name = "BgImage"
    bgImg.Size = UDim2.new(1, 0, 1, 0)
    bgImg.BackgroundTransparency = 1
    bgImg.Image = "rbxassetid://79007973869217"
    bgImg.ImageTransparency = S.imageTransparency
    bgImg.ImageColor3 = Color3.fromRGB(255, 255, 255)
    bgImg.ScaleType = Enum.ScaleType.Crop
    bgImg.ZIndex = 300
    Instance.new("UICorner", bgImg).CornerRadius = S.cornerRadius
    local shade = Instance.new("Frame", barFrame)
    shade.Name = "ImageShade"
    shade.Size = UDim2.new(1, 0, 1, 0)
    shade.BackgroundColor3 = STEAL_COLORS.imageShade
    shade.BackgroundTransparency = 0.8
    shade.BorderSizePixel = 0
    shade.ZIndex = 301
    Instance.new("UICorner", shade).CornerRadius = S.cornerRadius
    local stroke = Instance.new("UIStroke", barFrame)
    stroke.Color = STEAL_COLORS.stroke
    stroke.Thickness = S.strokeThickness
    stroke.Transparency = S.strokeTransparency
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    pbFrame = barFrame
    pbScale = Instance.new("UIScale", barFrame)
    applyStealBarScale()
    local statusLbl = Instance.new("TextLabel", barFrame)
    statusLbl.Name = "StealStatus"
    statusLbl.Size = S.status.size
    statusLbl.Position = S.status.pos
    statusLbl.BackgroundTransparency = 1
    statusLbl.Text = "IDLE"
    statusLbl.TextColor3 = isCompact and STEAL_COLORS.statusCompact or STEAL_COLORS.statusClassic
    statusLbl.Font = S.status.font
    statusLbl.TextSize = S.status.textSize
    statusLbl.TextXAlignment = S.status.align
    statusLbl.TextYAlignment = Enum.TextYAlignment.Center
    statusLbl.ZIndex = 305
    _G.SetStealStatus = function(txt) if statusLbl and statusLbl.Parent then statusLbl.Text = txt end end
    local pctLbl = Instance.new("TextLabel", barFrame)
    pctLbl.Name = "StealPercent"
    pctLbl.Size = S.percent.size
    pctLbl.Position = S.percent.pos
    pctLbl.BackgroundTransparency = 1
    pctLbl.Text = "0%"
    pctLbl.TextColor3 = STEAL_COLORS.percent
    pctLbl.Font = S.percent.font
    pctLbl.TextSize = S.percent.textSize
    pctLbl.TextXAlignment = S.percent.align
    pctLbl.TextYAlignment = Enum.TextYAlignment.Center
    pctLbl.ZIndex = 305
    progressPct = pctLbl
    local divider = Instance.new("Frame", barFrame)
    divider.Name = "Divider"
    divider.Size = S.divider.size
    divider.Position = S.divider.pos
    divider.BackgroundColor3 = STEAL_COLORS.divider
    divider.BackgroundTransparency = S.dividerTransparency
    divider.BorderSizePixel = 0
    divider.ZIndex = 303
    local track = Instance.new("Frame", barFrame)
    track.Name = "VX7StealTrack"
    track.Size = S.track.size
    track.Position = S.track.pos
    track.BackgroundColor3 = STEAL_COLORS.track
    track.BackgroundTransparency = S.trackTransparency
    track.BorderSizePixel = 0
    track.ClipsDescendants = true
    track.ZIndex = 302
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
    local fill = Instance.new("Frame", track)
    fill.Name = "Fill"
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.Position = UDim2.new(0, 0, 0, 0)
    fill.BackgroundColor3 = STEAL_COLORS.accent
    fill.BorderSizePixel = 0
    fill.ZIndex = 303
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    local fg = Instance.new("UIGradient", fill)
    fg.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, STEAL_COLORS.accent:Lerp(Color3.new(0, 0, 0), 0.45)),
        ColorSequenceKeypoint.new(0.5, STEAL_COLORS.accent:Lerp(Color3.new(1,1,1), 0.34)),
        ColorSequenceKeypoint.new(1, STEAL_COLORS.accent:Lerp(Color3.new(0, 0, 0), 0.45)),
    })
    local gloss = Instance.new("Frame", fill)
    gloss.Name = "Gloss"
    gloss.Size = UDim2.new(1, 0, S.glossYScale, 0)
    gloss.Position = UDim2.new(0, 0, 0, 0)
    gloss.BackgroundColor3 = Color3.new(1, 1, 1)
    gloss.BackgroundTransparency = S.glossTransparency
    gloss.BorderSizePixel = 0
    gloss.ZIndex = 304
    Instance.new("UICorner", gloss).CornerRadius = UDim.new(1, 0)
    progressFill = fill
    local fpsLbl = Instance.new("TextLabel", barFrame)
    fpsLbl.Name = "FPSLabel"
    fpsLbl.Size = S.fpsLabel.size
    fpsLbl.Position = S.fpsLabel.pos
    fpsLbl.BackgroundTransparency = 1
    fpsLbl.Text = "FPS"
    fpsLbl.TextColor3 = STEAL_COLORS.fps
    fpsLbl.Font = S.fpsLabel.font
    fpsLbl.TextSize = S.fpsLabel.textSize
    fpsLbl.TextXAlignment = Enum.TextXAlignment.Left
    fpsLbl.TextYAlignment = Enum.TextYAlignment.Center
    fpsLbl.ZIndex = 305
    local fpsVal = Instance.new("TextLabel", barFrame)
    fpsVal.Name = "FPSValue"
    fpsVal.Size = S.fpsValue.size
    fpsVal.Position = S.fpsValue.pos
    fpsVal.BackgroundTransparency = 1
    fpsVal.Text = "0"
    fpsVal.TextColor3 = STEAL_COLORS.white
    fpsVal.Font = S.fpsValue.font
    fpsVal.TextSize = S.fpsValue.textSize
    fpsVal.TextXAlignment = Enum.TextXAlignment.Left
    fpsVal.TextYAlignment = Enum.TextYAlignment.Center
    fpsVal.ZIndex = 305
    local pingLbl = Instance.new("TextLabel", barFrame)
    pingLbl.Name = "PingLabel"
    pingLbl.Size = S.pingLabel.size
    pingLbl.Position = S.pingLabel.pos
    pingLbl.BackgroundTransparency = 1
    pingLbl.Text = "PING"
    pingLbl.TextColor3 = STEAL_COLORS.fps
    pingLbl.Font = S.pingLabel.font
    pingLbl.TextSize = S.pingLabel.textSize
    pingLbl.TextXAlignment = Enum.TextXAlignment.Left
    pingLbl.TextYAlignment = Enum.TextYAlignment.Center
    pingLbl.ZIndex = 305
    local pingVal = Instance.new("TextLabel", barFrame)
    pingVal.Name = "PingValue"
    pingVal.Size = S.pingValue.size
    pingVal.Position = S.pingValue.pos
    pingVal.BackgroundTransparency = 1
    pingVal.Text = "0"
    pingVal.TextColor3 = STEAL_COLORS.white
    pingVal.Font = S.pingValue.font
    pingVal.TextSize = S.pingValue.textSize
    pingVal.TextXAlignment = Enum.TextXAlignment.Left
    pingVal.TextYAlignment = Enum.TextYAlignment.Center
    pingVal.ZIndex = 305
    do
        local dn, ds, sp, di = false, nil, nil, nil
        barFrame.InputBegan:Connect(function(i)
            if uiLocked or _isDraggingButton then return end
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                dn = true; ds = i.Position; sp = barFrame.Position
                i.Changed:Connect(function()
                    if i.UserInputState == Enum.UserInputState.End then
                        dn = false
                        savedProgressBarPos = {
                            XScale = barFrame.Position.X.Scale, XOffset = barFrame.Position.X.Offset,
                            YScale = barFrame.Position.Y.Scale, YOffset = barFrame.Position.Y.Offset
                        }
                        saveAllSettings()
                    end
                end)
            end
        end)
        barFrame.InputChanged:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then di = i end
        end)
        local dragConn = UIS.InputChanged:Connect(function(i)
            if dn and i == di then
                if uiLocked or _isDraggingButton then dn = false; return end
                barFrame.Position = UDim2.new(sp.X.Scale, sp.X.Offset + (i.Position.X - ds.X), sp.Y.Scale, sp.Y.Offset + (i.Position.Y - ds.Y))
            end
        end)
        barFrame.Destroying:Connect(function() dragConn:Disconnect() end)
    end
    local _frames, _start = 0, tick()
    local renderConn = RunService.RenderStepped:Connect(function() _frames = _frames + 1 end)
    task.spawn(function()
        while task.wait(1) do
            if not fpsVal or not fpsVal.Parent then
                pcall(function() renderConn:Disconnect() end)
                break
            end
            local now = tick()
            local elapsed = now - _start
            local fps = elapsed > 0 and math.floor(_frames / elapsed) or 0
            _frames = 0; _start = now
            local ping = 0
            pcall(function()
                local stat = game:GetService("Stats").Network.ServerStatsItem:FindFirstChild("Data Ping")
                if stat then ping = math.floor(stat:GetValue()) end
            end)
            fpsVal.Text = tostring(fps)
            pingVal.Text = tostring(ping)
        end
    end)
end

local function startHoldInfJump()
    if _G.Lust.Connections.infJump then return end
    _G.Lust.Connections.infJump = RunService.Heartbeat:Connect(function()
        if not jumpEnabled then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        local isJumpHeld = UIS:IsKeyDown(Enum.KeyCode.Space) or (hum.Jump == true)
        if isJumpHeld and root.Velocity.Y < 35 then
            root.Velocity = Vector3.new(root.Velocity.X, 55, root.Velocity.Z)
        end
        if root.Velocity.Y < -120 then
            root.Velocity = Vector3.new(root.Velocity.X, -120, root.Velocity.Z)
        end
    end)
end

function startJumpMode()
    jumpEnabled = true
    _G.Lust.Active.jump = true
    startHoldInfJump()
    if setJumpVisual then setJumpVisual(true) end
end

function stopJumpMode()
    jumpEnabled = false
    _G.Lust.Active.jump = false
    if _G.Lust.Connections.infJump then
        _G.Lust.Connections.infJump:Disconnect()
        _G.Lust.Connections.infJump = nil
    end
    if setJumpVisual then setJumpVisual(false) end
end

local resetCooldownTS = 0
local function forceReset()
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root or hum.Health <= 0 then return end
    pcall(function()
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        root.Velocity = Vector3.zero; root.RotVelocity = Vector3.zero
        root.AssemblyLinearVelocity = Vector3.zero; root.AssemblyAngularVelocity = Vector3.zero
        for _, obj in ipairs(char:GetDescendants()) do
            if obj:IsA("Motor6D") then obj.Enabled = true end
            if obj:IsA("Constraint") then obj.Enabled = true end
        end
        if workspace.CurrentCamera then workspace.CurrentCamera.CameraSubject = hum end
        local playerModule = LP:FindFirstChild("PlayerScripts") and LP.PlayerScripts:FindFirstChild("PlayerModule")
        local controlModule = playerModule and playerModule:FindFirstChild("ControlModule")
        if controlModule then
            local controls = require(controlModule)
            if controls then controls:Enable() end
        end
        hum.AutoRotate = true; hum.PlatformStand = false; hum.Sit = false
    end)
end

function startAntiRagdoll()
    if _G.Lust.Connections.antiRagdoll then return end
    antiRagdollEnabled = true
    _G.Lust.Active.antiRagdoll = true
    _G.Lust.Connections.antiRagdoll = RunService.Heartbeat:Connect(function()
        if not antiRagdollEnabled then return end
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return end
        local state = hum:GetState()
        local ragdolled = (state == Enum.HumanoidStateType.Physics or
                           state == Enum.HumanoidStateType.Ragdoll or
                           state == Enum.HumanoidStateType.FallingDown)
        if ragdolled then
            local now = tick()
            if now - resetCooldownTS > 0.15 then
                resetCooldownTS = now
                forceReset()
            end
        end
    end)
    if setAntiRagVisual then setAntiRagVisual(true) end
end

function stopAntiRagdoll()
    antiRagdollEnabled = false
    _G.Lust.Active.antiRagdoll = false
    if _G.Lust.Connections.antiRagdoll then
        _G.Lust.Connections.antiRagdoll:Disconnect()
        _G.Lust.Connections.antiRagdoll = nil
    end
    if setAntiRagVisual then setAntiRagVisual(false) end
end

function setAntiRag(on) if on then startAntiRagdoll() else stopAntiRagdoll() end end

local function _atpIsCarrying()
    if LP:GetAttribute("Stealing") == true then return true end
    local char = LP.Character
    if not char then return false end
    if char:GetAttribute("Stealing") == true then return true end
    for k, v in pairs(char:GetAttributes()) do
        local n = tostring(k):lower()
        if v == true and (n:find("carrying") or n:find("stealing") or n:find("hasbrainrot")) then return true end
    end
    return false
end

local function doAutoTPDown(force)
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if not force then
        if hum.FloorMaterial ~= Enum.Material.Air then return end
        if not (hrp.Position.Y >= autoTPDownHeight) then return end
    end
    local _, yaw = hrp.CFrame:ToEulerAnglesYXZ()
    hrp.CFrame = CFrame.new(hrp.Position.X, TP_DOWN_Y, hrp.Position.Z) * CFrame.Angles(0, yaw, 0)
    hrp.Velocity = Vector3.zero
end

function runTPDown() pcall(function() doAutoTPDown(true) end) end

function startAutoTPDown()
    if autoTPConn then task.cancel(autoTPConn); autoTPConn = nil end
    autoTPDownEnabled = true
    _G.Lust.Active.autoTPDown = true
    autoTPConn = task.spawn(function()
        while autoTPDownEnabled do
            task.wait(0.1)
            if _atpIsCarrying() then
                pcall(function() doAutoTPDown(false) end)
            end
        end
    end)
    if setAutoTPDownVisual then setAutoTPDownVisual(true) end
end

function stopAutoTPDown()
    autoTPDownEnabled = false
    _G.Lust.Active.autoTPDown = false
    if autoTPConn then task.cancel(autoTPConn); autoTPConn = nil end
    if setAutoTPDownVisual then setAutoTPDownVisual(false) end
end

local function mirrorTPAimbotActive()
    return (autoBatEnabled == true) or (batDesyncTpEnabled == true)
end

local function mirrorTPTeleportDown()
    local character = LP.Character
    local root      = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid  = character and character:FindFirstChildOfClass("Humanoid")
    if not root or not humanoid or humanoid.Health <= 0 then return end
    local now = tick()
    if now - (mirrorTPLastTeleport or 0) < 0.08 then return end
    mirrorTPLastTeleport = now
    local _, yaw = root.CFrame:ToEulerAnglesYXZ()
    local y = (MIRROR_TP_DOWN_Y or -7) + (math.random() * 0.6 - 0.3)
    root.CFrame = CFrame.new(root.Position.X, y, root.Position.Z) * CFrame.Angles(0, yaw, 0)
    root.AssemblyLinearVelocity = Vector3.new((math.random() - 0.5) * 0.4, 0, (math.random() - 0.5) * 0.4)
end

RunService.Heartbeat:Connect(function()
    if not mirrorTPDownEnabled or not mirrorTPAimbotActive() then
        if next(mirrorTPPreviousY) then table.clear(mirrorTPPreviousY) end
        return
    end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local root = plr.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local currentY  = root.Position.Y
                local previousY = mirrorTPPreviousY[plr.UserId]
                if previousY and previousY - currentY >= (MIRROR_TP_DROP_THRESHOLD or 3) then
                    pcall(mirrorTPTeleportDown)
                    table.clear(mirrorTPPreviousY)
                    return
                end
                mirrorTPPreviousY[plr.UserId] = currentY
            end
        end
    end
end)

function setMirrorTPDownState(enabled)
    mirrorTPDownEnabled = enabled == true
    if not mirrorTPDownEnabled then table.clear(mirrorTPPreviousY) end
    if mirrorTPDownSetVisual then mirrorTPDownSetVisual(mirrorTPDownEnabled) end
    saveAllSettings()
end

LP.CharacterAdded:Connect(function()
    if antiRagdollEnabled then
        task.wait(0.5)
        startAntiRagdoll()
    end
end)

local espActivePlayers = {}
local espLoopConn = nil

local function getESPThemeColors(accent)
    local c = getThemeColor() or accent or Color3.fromRGB(245, 245, 250)
    return c, Color3.fromRGB(0, 0, 0)
end

local function createESP()
    local currentFill, currentLine = getESPThemeColors()
    local esp = { Tracer = Drawing and Drawing.new("Line") or nil, Highlight = Instance.new("Highlight"), Lines = {} }
    if esp.Tracer then
        esp.Tracer.Color = currentLine
        esp.Tracer.Thickness = 3
        esp.Tracer.Transparency = 1
        esp.Tracer.ZIndex = 2
    end
    esp.Highlight.Name = "YoutESP_Highlight"
    esp.Highlight.FillColor = currentFill
    esp.Highlight.OutlineColor = Color3.fromRGB(0, 0, 0)
    esp.Highlight.FillTransparency = 0.12
    esp.Highlight.OutlineTransparency = 0.18
    esp.Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    local parentGui
    local ok, robGui = pcall(function() return game:GetService("CoreGui"):FindFirstChild("RobloxGui") end)
    if ok and robGui then parentGui = robGui else parentGui = LP:FindFirstChildOfClass("PlayerGui") end
    if not parentGui then parentGui = game:GetService("CoreGui") end
    pcall(function() esp.Highlight.Parent = parentGui end)
    local nameBillboard = Instance.new("BillboardGui")
    nameBillboard.Name = "YoutESP_Name"
    nameBillboard.Size = UDim2.new(0, 170, 0, 28)
    nameBillboard.StudsOffset = Vector3.new(0, 1.3, 0)
    nameBillboard.AlwaysOnTop = true
    nameBillboard.Parent = parentGui
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(0, 170, 0, 28)
    nameLabel.AnchorPoint = Vector2.new(0.5, 0)
    nameLabel.Position = UDim2.new(0.5, 0, 0, 2)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = ""
    nameLabel.TextColor3 = getThemeColor()
    nameLabel.TextSize = 15
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextXAlignment = Enum.TextXAlignment.Center
    nameLabel.TextYAlignment = Enum.TextYAlignment.Center
    nameLabel.ZIndex = 5
    nameLabel.Parent = nameBillboard
    local nameOutline = Instance.new("UIStroke")
    nameOutline.Color = Color3.fromRGB(0, 0, 0)
    nameOutline.Thickness = 2.2
    nameOutline.Transparency = 0.12
    nameOutline.Parent = nameLabel
    if Drawing then
        for i = 1, 14 do
            local line = Drawing.new("Line")
            line.Color = currentLine
            line.Thickness = 2
            line.Transparency = 1
            line.ZIndex = 3
            table.insert(esp.Lines, line)
        end
    end
    esp.NameTag = nameBillboard
    esp.NameLabel = nameLabel
    esp.NameOutline = nameOutline
    return esp
end

local function removeESP(plr)
    local data = espActivePlayers[plr]
    if data then
        if data.esp.Tracer then pcall(function() data.esp.Tracer:Remove() end) end
        if data.esp.Highlight then pcall(function() data.esp.Highlight:Destroy() end) end
        if data.esp.NameTag then pcall(function() data.esp.NameTag:Destroy() end) end
        for _, line in ipairs(data.esp.Lines) do pcall(function() line:Remove() end) end
        espActivePlayers[plr] = nil
    end
end

local function updateESP(plr, esp)
    if not espEnabled then
        if esp.Tracer then esp.Tracer.Visible = false end
        esp.Highlight.Enabled = false
        for _, line in ipairs(esp.Lines) do line.Visible = false end
        if esp.NameTag then esp.NameTag.Enabled = false end
        return
    end
    local character = plr.Character
    local hum = character and character:FindFirstChildOfClass("Humanoid")
    local trackPart = character and (character:FindFirstChild("HumanoidRootPart") or character.PrimaryPart or character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso") or character:FindFirstChild("Head"))
    if character and trackPart and (not hum or hum.Health > 0) then
        esp.Highlight.Adornee = character
        esp.Highlight.Enabled = espEnabled
        if esp.Tracer then esp.Tracer.Visible = false end
        for _, line in ipairs(esp.Lines) do line.Visible = false end
        if esp.NameTag and esp.NameLabel then
            pcall(function()
                esp.NameTag.Adornee = trackPart
                esp.NameTag.Enabled = espEnabled
                esp.NameLabel.Text = plr.Name or plr.DisplayName or ""
                esp.NameLabel.TextColor3 = getThemeColor()
            end)
        end
    else
        if esp.Tracer then esp.Tracer.Visible = false end
        esp.Highlight.Enabled = false
        esp.Highlight.Adornee = nil
        for _, line in ipairs(esp.Lines) do line.Visible = false end
        if esp.NameTag then esp.NameTag.Enabled = false end
    end
end

local function createESPForPlayer(plr)
    if plr == LP then return end
    if espActivePlayers[plr] and espActivePlayers[plr].esp then
        if espActivePlayers[plr].esp.NameTag then
            pcall(function() espActivePlayers[plr].esp.NameTag.Enabled = espEnabled end)
        end
        return
    end
    removeESP(plr)
    local esp = createESP()
    espActivePlayers[plr] = { esp = esp }
end

local espJoinConn, espLeaveConn
local function enableESP()
    if espEnabled then return end
    espEnabled = true
    _G.Lust.Active.esp = true
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LP then task.spawn(function() createESPForPlayer(plr) end) end
    end
    local espAccumulator = 0
    if espLoopConn then espLoopConn:Disconnect() end
    espLoopConn = RunService.Heartbeat:Connect(function(dt)
        espAccumulator = espAccumulator + (dt or 0)
        if espAccumulator < 0.15 then return end
        espAccumulator = 0
        for plr, data in pairs(espActivePlayers) do
            if typeof(plr) == "Instance" and plr:IsA("Player") and data and data.esp then
                pcall(function() updateESP(plr, data.esp) end)
            end
        end
    end)
    _G.Lust.Connections.esp = espLoopConn
    espJoinConn = Players.PlayerAdded:Connect(function(plr)
        if not espEnabled or plr == LP then return end
        task.wait(0.3)
        createESPForPlayer(plr)
    end)
    espLeaveConn = Players.PlayerRemoving:Connect(function(plr) removeESP(plr) end)
end

local function disableESP()
    espEnabled = false
    _G.Lust.Active.esp = false
    if espLoopConn then espLoopConn:Disconnect(); espLoopConn = nil end
    _G.Lust.Connections.esp = nil
    if espJoinConn then pcall(function() espJoinConn:Disconnect() end); espJoinConn = nil end
    if espLeaveConn then pcall(function() espLeaveConn:Disconnect() end); espLeaveConn = nil end
    for plr in pairs(espActivePlayers) do
        if typeof(plr) == "Instance" and plr:IsA("Player") and plr ~= LP then removeESP(plr) end
    end
end

function toggleESP(on)
    if on then enableESP() else disableESP() end
    if setESPVIsual then setESPVIsual(on) end
end

local _espLineGui = nil
local _espLineFrame = nil
local _espLineOutline = nil
local _espLineConn = nil
local _espLineState = { scanElapsed = math.huge, targetRoot = nil }

local function ensureESPLineGui()
    if _espLineGui and _espLineGui.Parent then return end
    _espLineGui = Instance.new("ScreenGui")
    _espLineGui.Name = "YoutESPLine"
    _espLineGui.IgnoreGuiInset = true
    _espLineGui.ResetOnSpawn = false
    _espLineGui.DisplayOrder = 1000
    _espLineGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    local okP = pcall(function() _espLineGui.Parent = game:GetService("CoreGui") end)
    if not okP then _espLineGui.Parent = LP:WaitForChild("PlayerGui") end
    _espLineFrame = Instance.new("Frame")
    _espLineFrame.Name = "ESPLine"
    _espLineFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    _espLineFrame.BorderSizePixel = 0
    _espLineFrame.Active = false
    _espLineFrame.Visible = false
    _espLineFrame.BackgroundColor3 = getThemeColor()
    _espLineFrame.ZIndex = 1
    _espLineFrame.Parent = _espLineGui
    _espLineOutline = Instance.new("UIStroke", _espLineFrame)
    _espLineOutline.Color = Color3.fromRGB(255, 255, 255)
    _espLineOutline.Thickness = 0.7
    _espLineOutline.Transparency = 0.45
end

function stopESPLine()
    espLineEnabled = false
    _G.Lust.Active.espLine = false
    if _espLineConn then _espLineConn:Disconnect(); _espLineConn = nil end
    _G.Lust.Connections.espLine = nil
    if _espLineFrame then _espLineFrame.Visible = false end
    _espLineState.targetRoot = nil
    _espLineState.scanElapsed = math.huge
    if _espLineGui and _espLineGui.Parent then pcall(function() _espLineGui:Destroy() end) end
    _espLineGui = nil
    _espLineFrame = nil
    _espLineOutline = nil
    if setESPLineVisual then setESPLineVisual(false) end
end

function startESPLine()
    espLineEnabled = true
    _G.Lust.Active.espLine = true
    ensureESPLineGui()
    if _espLineConn then _espLineConn:Disconnect() end
    _espLineState.scanElapsed = math.huge
    _espLineState.targetRoot = nil
    _espLineConn = RunService.RenderStepped:Connect(function(dt)
        if not espLineEnabled then
            if _espLineFrame then _espLineFrame.Visible = false end
            return
        end
        local ok = pcall(function()
            local activeCamera = workspace.CurrentCamera
            local myChar = LP.Character
            local myRoot = myChar and (myChar:FindFirstChild("LowerTorso") or myChar:FindFirstChild("HumanoidRootPart") or myChar:FindFirstChild("Torso"))
            if not activeCamera or not myRoot then
                if _espLineFrame then _espLineFrame.Visible = false end
                return
            end
            local myPosition = myRoot.Position
            _espLineState.scanElapsed = _espLineState.scanElapsed + (dt or 0)
            local cachedRoot = _espLineState.targetRoot
            local cachedCharacter = cachedRoot and cachedRoot.Parent
            local cachedHumanoid = cachedCharacter and cachedCharacter:FindFirstChildOfClass("Humanoid")
            local cachedValid = cachedRoot and cachedRoot.Parent and (not cachedHumanoid or cachedHumanoid.Health > 0)
            if _espLineState.scanElapsed >= 0.12 or not cachedValid then
                _espLineState.scanElapsed = 0
                local closestRoot, closestDistanceSq = nil, math.huge
                for _, otherPlayer in ipairs(Players:GetPlayers()) do
                    if otherPlayer ~= LP then
                        local character = otherPlayer.Character
                        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                        local root = character and (character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("LowerTorso") or character:FindFirstChild("Torso"))
                        if root and root:IsA("BasePart") and (not humanoid or humanoid.Health > 0) then
                            local delta = root.Position - myPosition
                            local distanceSq = delta:Dot(delta)
                            if distanceSq < closestDistanceSq then
                                closestRoot, closestDistanceSq = root, distanceSq
                            end
                        end
                    end
                end
                _espLineState.targetRoot = closestRoot
            end
            local closestRoot = _espLineState.targetRoot
            if not closestRoot or not closestRoot.Parent then
                if _espLineFrame then _espLineFrame.Visible = false end
                return
            end
            local closestPosition = closestRoot.Position
            local from = activeCamera:WorldToViewportPoint(myPosition - Vector3.new(0, myRoot.Size.Y * 0.35, 0))
            local to, targetOnScreen = activeCamera:WorldToViewportPoint(closestPosition)
            local viewport = activeCamera.ViewportSize
            local fromPoint = Vector2.new(from.X, from.Y)
            local targetPoint = Vector2.new(to.X, to.Y)
            if not targetOnScreen or to.Z <= 0 then
                local center = viewport * 0.5
                local direction = targetPoint - center
                if to.Z <= 0 then direction = -direction end
                if direction.Magnitude < 0.001 then direction = Vector2.new(0, -1) end
                local limit = Vector2.new(math.max(8, center.X - 8), math.max(8, center.Y - 8))
                local scaleX = limit.X / math.max(math.abs(direction.X), 0.001)
                local scaleY = limit.Y / math.max(math.abs(direction.Y), 0.001)
                targetPoint = center + direction * math.min(scaleX, scaleY)
            end
            if from.Z <= 0 or fromPoint.X < 0 or fromPoint.X > viewport.X or fromPoint.Y < 0 or fromPoint.Y > viewport.Y then
                fromPoint = Vector2.new(viewport.X * 0.5, viewport.Y - 8)
            end
            local delta = targetPoint - fromPoint
            local midpoint = (fromPoint + targetPoint) * 0.5
            _espLineFrame.Position = UDim2.fromOffset(midpoint.X, midpoint.Y)
            _espLineFrame.Size = UDim2.fromOffset(math.max(delta.Magnitude, 1), 2)
            _espLineFrame.Rotation = math.deg(math.atan2(delta.Y, delta.X))
            _espLineFrame.BackgroundColor3 = getThemeColor()
            _espLineFrame.Visible = true
        end)
        if not ok and _espLineFrame then pcall(function() _espLineFrame.Visible = false end) end
    end)
    _G.Lust.Connections.espLine = _espLineConn
    if setESPLineVisual then setESPLineVisual(true) end
end

function toggleESPLine(on)
    if on then startESPLine() else stopESPLine() end
    saveAllSettings()
end

local function getClosestTarget()
    local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local myPos = root.Position
    local closest, minDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum and hum.Health > 0 then
                local dist = (tRoot.Position - myPos).Magnitude
                if dist < minDist then minDist = dist; closest = tRoot end
            end
        end
    end
    return closest
end

local function getClosestTargetBody()
    local char = LP.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local rpos = root.Position
    local closest, minDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP then
            local c = plr.Character
            if c then
                local tRoot = c:FindFirstChild("HumanoidRootPart")
                local hum = c:FindFirstChildOfClass("Humanoid")
                if tRoot and hum and hum.Health > 0 then
                    local dx = tRoot.Position.X - rpos.X
                    local dy = tRoot.Position.Y - rpos.Y
                    local dz = tRoot.Position.Z - rpos.Z
                    local dd = dx*dx + dy*dy + dz*dz
                    if dd < minDist then minDist = dd; closest = tRoot end
                end
            end
        end
    end
    return closest
end

local function _blIsCarryingBrainrot(character)
    if not character then return false end
    local okStealLP, stealLP = pcall(function() return LP:GetAttribute("Stealing") end)
    if okStealLP and stealLP == true then return true end
    local okStealChar, stealChar = pcall(function() return character:GetAttribute("Stealing") end)
    if okStealChar and stealChar == true then return true end
    for _, entry in ipairs({ "Carrying", "IsCarrying", "Grabbed", "Holding", "StealHold", "HasGrab" }) do
        local inst = character:FindFirstChild(entry, true)
        if inst and (
            (inst:IsA("BoolValue") and inst.Value)
            or (inst:IsA("ObjectValue") and inst.Value)
            or (inst:IsA("StringValue") and inst.Value ~= "")
        ) then return true end
    end
    for _, child in ipairs(character:GetChildren()) do
        if child:IsA("Model") and child:FindFirstChildWhichIsA("BasePart", true) then
            local n = child.Name:lower()
            if n:find("brainrot") or n:find("animal") or n:find("carry") or n:find("grab") or n:find("steal") or n:find("hold") then
                return true
            end
        end
    end
    return false
end

local function _bodyLockTick()
    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if _blIsCarryingBrainrot(char) then
        if not hum.AutoRotate then hum.AutoRotate = true end
        return
    end
    local target = getClosestTargetBody()
    if not target then
        if not hum.AutoRotate then hum.AutoRotate = true end
        return
    end
    local dist = (target.Position - root.Position).Magnitude
    if dist > bodyLockRange then
        if not hum.AutoRotate then hum.AutoRotate = true end
        return
    end
    if hum.AutoRotate then hum.AutoRotate = false end
    local targetVel = target.AssemblyLinearVelocity
    local speed3 = targetVel.Magnitude
    local predictTime = math.clamp(speed3 / 80, 0.08, 0.35)
    local predictedPos = target.Position + targetVel * predictTime
    local targetHead = target.Parent and target.Parent:FindFirstChild("Head")
    local targetHeight = targetHead and targetHead.Position.Y or target.Position.Y
    local myHeight = root.Position.Y + (hum.HipHeight or 0)
    local heightDiff = targetHeight - myHeight
    local verticalCorrection = math.clamp(heightDiff * 0.15, -1.5, 1.5)
    local flatTarget = Vector3.new(predictedPos.X, root.Position.Y + verticalCorrection, predictedPos.Z)
    local toPredict = flatTarget - root.Position
    if toPredict.Magnitude > 0.1 then
        local goalCF = CFrame.lookAt(root.Position, flatTarget)
        local diffCF = root.CFrame:Inverse() * goalCF
        local _, ry, _ = diffCF:ToEulerAnglesXYZ()
        ry = math.clamp(ry, -2.5, 2.5)
        root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(Vector3.new(0, ry * 42, 0))
    end
end

function startBodyLock()
    if _G.Lust.Connections.bodyLock then _G.Lust.Connections.bodyLock:Disconnect() end
    bodyLockEnabled = true
    _G.Lust.Active.bodyLock = true
    local acc = 0
    _G.Lust.Connections.bodyLock = RunService.Heartbeat:Connect(function(dt)
        if not bodyLockEnabled then return end
        if _blSuppressCount > 0 then return end
        acc = acc + dt
        if acc < 0.033 then return end
        acc = 0
        _bodyLockTick()
    end)
    if bodyLockSetVisual then bodyLockSetVisual(true) end
    return true
end

function stopBodyLock()
    bodyLockEnabled = false
    _G.Lust.Active.bodyLock = false
    if _G.Lust.Connections.bodyLock then _G.Lust.Connections.bodyLock:Disconnect(); _G.Lust.Connections.bodyLock = nil end
    local c = LP.Character
    local root = c and c:FindFirstChild("HumanoidRootPart")
    if root then
        root.AssemblyAngularVelocity = Vector3.zero
        root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, -0.1, root.AssemblyLinearVelocity.Z)
    end
    local hum2 = c and c:FindFirstChildOfClass("Humanoid")
    if hum2 then hum2.AutoRotate = true end
    if bodyLockSetVisual then bodyLockSetVisual(false) end
end

function _suppressBodyLock()
    _blSuppressCount = _blSuppressCount + 1
    if _blSuppressCount == 1 and bodyLockEnabled then
        if _blRestoreTimer then pcall(task.cancel, _blRestoreTimer); _blRestoreTimer = nil end
        local c = LP.Character
        local root = c and c:FindFirstChild("HumanoidRootPart")
        if root then
            root.AssemblyAngularVelocity = Vector3.zero
        end
        local hum2 = c and c:FindFirstChildOfClass("Humanoid")
        if hum2 then hum2.AutoRotate = true end
    end
end

function _unsuppressBodyLock(delayed)
    if _blSuppressCount > 0 then _blSuppressCount = _blSuppressCount - 1 end
    if _blSuppressCount == 0 and bodyLockEnabled then
        if _blRestoreTimer then pcall(task.cancel, _blRestoreTimer); _blRestoreTimer = nil end
        local function restore()
            _blRestoreTimer = nil
            if bodyLockEnabled and _blSuppressCount == 0 then
                if bodyLockSetVisual then bodyLockSetVisual(true) end
            end
        end
        if delayed then _blRestoreTimer = task.delay(1, restore) else restore() end
    end
end

function setupSpeedIndicator(char)
    if not char then return end
    local head = char:WaitForChild("Head", 10)
    if not head then return end
    local oldBB = head:FindFirstChild("MegumiSpeedIndicator")
    if oldBB then pcall(function() oldBB:Destroy() end) end
    local bb = Instance.new("BillboardGui")
    bb.Name = "MegumiSpeedIndicator"
    bb.Size = UDim2.new(0, 280, 0, 88)
    bb.StudsOffset = Vector3.new(0, 2.8, 0)
    bb.AlwaysOnTop = true
    bb.ResetOnSpawn = false
    bb.Parent = head
    
    local mainFrame = Instance.new("Frame", bb)
    mainFrame.Size = UDim2.new(1, 0, 1, 0)
    mainFrame.BackgroundTransparency = 1

    -- Top Label (-.gg/nkRsmWgM7)
    local newSpeedLabelTop = Instance.new("TextLabel", mainFrame)
    newSpeedLabelTop.Size = UDim2.new(1, 0, 0, 20)
    newSpeedLabelTop.Position = UDim2.new(0, 0, 0, 10)
    newSpeedLabelTop.BackgroundTransparency = 1
    newSpeedLabelTop.Text = "-.gg/nkRsmWgM7"
    newSpeedLabelTop.TextColor3 = Color3.fromRGB(255, 255, 255)
    newSpeedLabelTop.Font = Enum.Font.GothamBlack
    newSpeedLabelTop.TextScaled = true
    newSpeedLabelTop.TextStrokeColor3 = Color3.fromRGB(255, 20, 147)
    newSpeedLabelTop.TextStrokeTransparency = 0

    -- Bottom Label (> speed)
    local newSpeedLabel = Instance.new("TextLabel", mainFrame)
    newSpeedLabel.Size = UDim2.new(1, 0, 0, 26)
    newSpeedLabel.Position = UDim2.new(0, 0, 0, 30)
    newSpeedLabel.BackgroundTransparency = 1
    newSpeedLabel.Text = "> speed 0.0"
    newSpeedLabel.TextColor3 = Color3.fromRGB(255, 150, 200)
    newSpeedLabel.Font = Enum.Font.GothamBlack
    newSpeedLabel.TextScaled = true
    newSpeedLabel.TextStrokeColor3 = Color3.fromRGB(40, 10, 25)
    newSpeedLabel.TextStrokeTransparency = 0

    local violetStroke = Instance.new("UIStroke", newSpeedLabel)
    violetStroke.Color = Color3.fromRGB(255, 20, 147)
    violetStroke.Thickness = 1.6
    violetStroke.Transparency = 0.25
    local violetStroke2 = Instance.new("UIStroke", newSpeedLabel)
    violetStroke2.Color = Color3.fromRGB(120, 40, 200)
    violetStroke2.Thickness = 3.2
    violetStroke2.Transparency = 0.65
    
    speedLabel = newSpeedLabel
    
    task.spawn(function()
        local t = 0
        while newSpeedLabel and newSpeedLabel.Parent do
            t = t + 0.05
            local p = 0.2 + math.abs(math.sin(t * 2.2)) * 0.6
            violetStroke.Transparency  = p
            violetStroke2.Transparency = 0.4 + (1 - p) * 0.5
            newSpeedLabel.TextColor3 = Color3.fromRGB(255, math.floor(150 - p * 50), math.floor(200 + p * 55))
            task.wait(0.05)
        end
    end)
end

task.spawn(function()
    while true do
        task.wait(2)
        local char = LP.Character
        if char then
            local head = char:FindFirstChild("Head")
            if head and not head:FindFirstChild("MegumiSpeedIndicator") then
                pcall(setupSpeedIndicator, char)
            end
        end
    end
end)

function updateEnemySpeedLabels()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LP then
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChildOfClass("Humanoid") and char:FindFirstChildOfClass("Humanoid").Health > 0 then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                local velocity = hrp.AssemblyLinearVelocity
                local speed = Vector3.new(velocity.X, 0, velocity.Z).Magnitude
                local label = enemySpeedLabels[player]
                if not label then
                    local head = char:FindFirstChild("Head")
                    if head then
                        local bb = Instance.new("BillboardGui", head)
                        bb.Size = UDim2.new(0, 100, 0, 25)
                        bb.StudsOffset = Vector3.new(0, 3.5, 0)
                        bb.AlwaysOnTop = true
                        bb.Name = "EnemySpeedGui"
                        local textLabel = Instance.new("TextLabel", bb)
                        textLabel.Size = UDim2.new(1, 0, 1, 0)
                        textLabel.BackgroundTransparency = 1
                        textLabel.Text = string.format("%.1f", speed)
                        textLabel.TextColor3 = Color3.fromRGB(255, 150, 200)
                        textLabel.Font = Enum.Font.GothamBold
                        textLabel.TextScaled = true
                        textLabel.TextStrokeTransparency = 0
                        textLabel.TextStrokeColor3 = Color3.fromRGB(255, 20, 147)
                        label = textLabel
                        enemySpeedLabels[player] = label
                    end
                elseif label and label.Parent and label.Parent.Parent ~= char then
                    local head = char:FindFirstChild("Head")
                    if head then label.Parent.Parent = head end
                end
                if label then label.Text = string.format("%.1f", speed) end
            else
                local label = enemySpeedLabels[player]
                if label and label.Parent and label.Parent.Parent then label.Parent.Parent = nil end
                enemySpeedLabels[player] = nil
            end
        end
    end
end

function startEnemySpeed()
    if _G.Lust.Connections.enemySpeed then return end
    _G.Lust.Connections.enemySpeed = RunService.Heartbeat:Connect(updateEnemySpeedLabels)
end

function stopEnemySpeed()
    if _G.Lust.Connections.enemySpeed then _G.Lust.Connections.enemySpeed:Disconnect(); _G.Lust.Connections.enemySpeed = nil end
end

function refreshSpeedModeLabel()
    if modeValLbl then
        if laggerToggled then modeValLbl.Text = laggerLevel == 1 and "Lagger Spd 1" or "Lagger Spd 2"
        elseif speedMode then modeValLbl.Text = "Carry Mode"
        else modeValLbl.Text = "Normal" end
    end
end

function resetMovementState()
    refreshSpeedModeLabel()
    if mobSetCarry then mobSetCarry(speedMode) end
    if mobSetLagger1 then mobSetLagger1(laggerToggled and laggerLevel == 1) end
    if mobSetLagger2 then mobSetLagger2(laggerToggled and laggerLevel == 2) end
end

function autoCarryOnSteal()
    if _G.B2AutoCarry and autoCarrySpeedEnabled then pcall(_G.B2AutoCarry.poke) end
end

function toggleCarryMode()
    _autoCarryApplied = false
    if laggerToggled then
        laggerToggled = false; laggerLevel = 1; speedMode = true
    else
        speedMode = not speedMode
        if speedMode then laggerToggled = false; laggerLevel = 1 end
    end
    resetMovementState()
end

function toggleLaggerCycle()
    if speedMode then speedMode = false; if mobSetCarry then mobSetCarry(false) end end
    if not laggerToggled then laggerToggled = true; laggerLevel = 1
    else laggerLevel = (laggerLevel == 1) and 2 or 1 end
    resetMovementState()
end

_G.B2AutoCarryRange = tonumber(_G.B2AutoCarryRange) or 12

function _B2AutoCarryInit()
    if _G.B2AutoCarry and _G.B2AutoCarry.stop then pcall(_G.B2AutoCarry.stop) end

    local state = { active = false, previous = nil, graceUntil = 0, conn = nil }
    local soft  = { spots = {}, nextScan = 0, latched = false, held = false, armed = true }

    local function getFamily()
        if laggerToggled then return "lagger" end
        return "normal"
    end
    local function getCarry()
        return (speedMode == true) or (laggerToggled == true and laggerLevel == 2)
    end
    local function setFamilyCarry(family, carry)
        carry = carry == true
        if family == "lagger" then
            laggerToggled = true
            laggerLevel   = carry and 2 or 1
            speedMode     = false
        else
            laggerToggled = false
            laggerLevel   = 1
            speedMode     = carry
        end
    end
    local function refresh()
        pcall(resetMovementState)
    end

    local function isWeaponName(value)
        local n = tostring(value or ""):lower()
        return n:find("bat") or n:find("slap") or n:find("medusa")
            or n:find("head") or n:find("stone")
    end

    local function isCarrying(character)
        if not character then return false end
        if LP:GetAttribute("Stealing") == true
            or character:GetAttribute("Stealing") == true then
            return true
        end
        for _, entry in ipairs({ "Carrying","IsCarrying","Grabbed","Holding","StealHold","HasGrab" }) do
            local inst = character:FindFirstChild(entry, true)
            if inst and (
                (inst:IsA("BoolValue")    and inst.Value)
                or (inst:IsA("ObjectValue") and inst.Value)
                or (inst:IsA("StringValue") and inst.Value ~= "")
            ) then return true end
        end
        for _, child in ipairs(character:GetChildren()) do
            local n = child.Name:lower()
            if child:IsA("Tool") and not isWeaponName(n) then return true end
            if child:IsA("Model") and child:FindFirstChildWhichIsA("BasePart", true) then
                if n:find("brainrot") or n:find("animal") or n:find("carry")
                    or n:find("grab") or n:find("steal") or n:find("hold") then return true end
            end
        end
        return false
    end

    local function enable()
        if state.active then
            state.graceUntil = tick() + 0.75
            return
        end
        state.previous   = { family = getFamily(), carry = getCarry() }
        state.active     = true
        state.graceUntil = tick() + 0.75
        setFamilyCarry(getFamily(), true)
        refresh()
    end

    local function restore()
        if not state.active then return end
        local previous = state.previous
        state.active   = false
        state.previous = nil
        if previous then setFamilyCarry(previous.family, previous.carry) end
        refresh()
    end

    local function softEnable()
        if not state.active then
            state.previous = { family = getFamily(), carry = getCarry() }
            state.active   = true
        end
        state.graceUntil = tick() + 0.75
        setFamilyCarry(getFamily(), true)
        refresh()
    end

    local function scanSpots()
        local spots = {}
        local plots = workspace:FindFirstChild("Plots")
        if not plots then soft.spots = spots; return end
        for _, child in ipairs(plots:GetChildren()) do
            local sign = child:FindFirstChild("PlotSign")
            sign = sign and sign:FindFirstChild("YourBase")
            if not (sign and sign:IsA("BillboardGui") and sign.Enabled == true) then
                local pods = child:FindFirstChild("AnimalPodiums")
                if pods then
                    for _, pod in ipairs(pods:GetChildren()) do
                        local base = pod:FindFirstChild("Base")
                        base = base and base:FindFirstChild("Spawn")
                        if base then spots[#spots + 1] = base.Position end
                    end
                end
            end
        end
        soft.spots = spots
    end

    local function nearStealSpot(character)
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if not root then return false end
        local range = tonumber(_G.B2AutoCarryRange) or 12
        local now = tick()
        if soft.nextScan <= now then
            soft.nextScan = now + 0.5
            scanSpots()
        end
        for _, spot in ipairs(soft.spots) do
            if (root.Position - spot).Magnitude <= range then return true end
        end
        return false
    end

    local function onFrame()
        if not autoCarrySpeedEnabled then
            restore(); return
        end
        local character = LP.Character
        local humanoid  = character and character:FindFirstChildOfClass("Humanoid")
        if not character or not humanoid or humanoid.Health <= 0 then
            restore(); return
        end

        if autoCarryMode == "Soft Steal" then
            local near     = nearStealSpot(character)
            local carrying = isCarrying(character)
            local away     = not near

            if away then soft.armed = true end
            if away or getCarry() ~= true then soft.latched = false end

            if near and soft.armed and not soft.latched then
                soft.latched = true
                soft.held    = false
                softEnable()
            end

            if state.active then
                if carrying then
                    soft.held = true
                    state.graceUntil = tick() + 0.75
                elseif soft.held then
                    soft.held    = false
                    soft.latched = false
                    soft.armed   = false
                    restore()
                else
                    local away2 = not near
                    if away2 then away2 = tick() > state.graceUntil end
                    if away2 then
                        soft.latched = false
                        restore()
                    end
                end
            end
            return
        end

        if isCarrying(character) then
            enable()
        elseif state.active then
            restore()
        end
    end

    local function start()
        if state.conn then state.conn:Disconnect() end
        state.conn = RunService.RenderStepped:Connect(onFrame)
    end

    local function stop()
        if state.conn then
            state.conn:Disconnect()
            state.conn = nil
        end
        soft.latched = false
        soft.held    = false
        soft.armed   = true
        restore()
    end

    local charConn = LP.CharacterAdded:Connect(function()
        soft.latched = false
        soft.held    = false
        soft.armed   = true
        restore()
    end)

    _G.B2AutoCarry = {
        isActive = function() return state.active == true end,
        restore = restore,
        poke = function() end,
        reset = function()
            soft.latched = false; soft.held = false; soft.armed = true
            restore()
        end,
        stop = function()
            stop()
            pcall(function() charConn:Disconnect() end)
        end,
    }
    start()
end
_B2AutoCarryInit()

function stopAutoLeft()
    if _G.Lust.Connections.autoLeft then _G.Lust.Connections.autoLeft:Disconnect(); _G.Lust.Connections.autoLeft = nil end
    _G.Lust.Active.autoLeft = false
    alPhase = 1
    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum:Move(Vector3.zero, false) end
    end
    if autoLeftSetVisual then autoLeftSetVisual(false) end
    if mobSetAutoLeft then mobSetAutoLeft(false) end
    _unsuppressBodyLock(true)
end

function startAutoLeft()
    if _G.Lust.Connections.autoLeft then return end
    if _G.AmbitiousSafeModeTryStart and not _G.AmbitiousSafeModeTryStart() then
        autoLeftEnabled = false
        if autoLeftSetVisual then autoLeftSetVisual(false) end
        return
    end
    if autoRightEnabled then
        autoRightEnabled = false; stopAutoRight()
        if autoRightSetVisual then autoRightSetVisual(false) end
        if mobSetAutoRight then mobSetAutoRight(false) end
    end
    disableAllAimbots()
    _suppressBodyLock()
    _G.Lust.Active.autoLeft = true
    alPhase = 1
    _G.Lust.Connections.autoLeft = RunService.Heartbeat:Connect(function()
        if not autoLeftEnabled then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        local spd = NS
        if alPhase == 1 then
            local tgt = Vector3.new(AP.L1.X, root.Position.Y, AP.L1.Z)
            if (tgt - root.Position).Magnitude < 1 then
                alPhase = 2
                local d = AP.L2 - root.Position
                local mv = Vector3.new(d.X, 0, d.Z).Unit
                hum:Move(mv, false)
                root.AssemblyLinearVelocity = Vector3.new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
                return
            end
            local d = AP.L1 - root.Position
            local mv = Vector3.new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.AssemblyLinearVelocity = Vector3.new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
        elseif alPhase == 2 then
            local tgt = Vector3.new(AP.L2.X, root.Position.Y, AP.L2.Z)
            if (tgt - root.Position).Magnitude < 1 then
                hum:Move(Vector3.zero, false)
                root.AssemblyLinearVelocity = Vector3.zero
                autoLeftEnabled = false
                if _G.Lust.Connections.autoLeft then _G.Lust.Connections.autoLeft:Disconnect(); _G.Lust.Connections.autoLeft = nil end
                _G.Lust.Active.autoLeft = false
                alPhase = 1
                if autoLeftSetVisual then autoLeftSetVisual(false) end
                if mobSetAutoLeft then mobSetAutoLeft(false) end
                _unsuppressBodyLock(true)
                local facePos = Vector3.new(AP.L_FACE.X, root.Position.Y, AP.L_FACE.Z)
                if (facePos - root.Position).Magnitude > 0.01 then
                    root.CFrame = CFrame.new(root.Position, facePos)
                end
                return
            end
            local d = AP.L2 - root.Position
            local mv = Vector3.new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.AssemblyLinearVelocity = Vector3.new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
        end
    end)
    if autoLeftSetVisual then autoLeftSetVisual(true) end
    if mobSetAutoLeft then mobSetAutoLeft(true) end
end

function stopAutoRight()
    if _G.Lust.Connections.autoRight then _G.Lust.Connections.autoRight:Disconnect(); _G.Lust.Connections.autoRight = nil end
    _G.Lust.Active.autoRight = false
    arPhase = 1
    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum:Move(Vector3.zero, false) end
    end
    if autoRightSetVisual then autoRightSetVisual(false) end
    if mobSetAutoRight then mobSetAutoRight(false) end
    _unsuppressBodyLock(true)
end

function startAutoRight()
    if _G.Lust.Connections.autoRight then return end
    if _G.AmbitiousSafeModeTryStart and not _G.AmbitiousSafeModeTryStart() then
        autoRightEnabled = false
        if autoRightSetVisual then autoRightSetVisual(false) end
        return
    end
    if autoLeftEnabled then
        autoLeftEnabled = false; stopAutoLeft()
        if autoLeftSetVisual then autoLeftSetVisual(false) end
        if mobSetAutoLeft then mobSetAutoLeft(false) end
    end
    disableAllAimbots()
    _suppressBodyLock()
    _G.Lust.Active.autoRight = true
    arPhase = 1
    _G.Lust.Connections.autoRight = RunService.Heartbeat:Connect(function()
        if not autoRightEnabled then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        local spd = NS
        if arPhase == 1 then
            local tgt = Vector3.new(AP.R1.X, root.Position.Y, AP.R1.Z)
            if (tgt - root.Position).Magnitude < 1 then
                arPhase = 2
                local d = AP.R2 - root.Position
                local mv = Vector3.new(d.X, 0, d.Z).Unit
                hum:Move(mv, false)
                root.AssemblyLinearVelocity = Vector3.new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
                return
            end
            local d = AP.R1 - root.Position
            local mv = Vector3.new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.AssemblyLinearVelocity = Vector3.new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
        elseif arPhase == 2 then
            local tgt = Vector3.new(AP.R2.X, root.Position.Y, AP.R2.Z)
            if (tgt - root.Position).Magnitude < 1 then
                hum:Move(Vector3.zero, false)
                root.AssemblyLinearVelocity = Vector3.zero
                autoRightEnabled = false
                if _G.Lust.Connections.autoRight then _G.Lust.Connections.autoRight:Disconnect(); _G.Lust.Connections.autoRight = nil end
                _G.Lust.Active.autoRight = false
                arPhase = 1
                if autoRightSetVisual then autoRightSetVisual(false) end
                if mobSetAutoRight then mobSetAutoRight(false) end
                _unsuppressBodyLock(true)
                local facePos = Vector3.new(AP.R_FACE.X, root.Position.Y, AP.R_FACE.Z)
                if (facePos - root.Position).Magnitude > 0.01 then
                    root.CFrame = CFrame.new(root.Position, facePos)
                end
                return
            end
            local d = AP.R2 - root.Position
            local mv = Vector3.new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.AssemblyLinearVelocity = Vector3.new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
        end
    end)
    if autoRightSetVisual then autoRightSetVisual(true) end
    if mobSetAutoRight then mobSetAutoRight(true) end
end

function getClosestTargetForAimbot()
    local char = LP.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart")
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

function findBat()
    local char = LP.Character
    if not char then return nil end
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end
    end
    local bp = LP:FindFirstChildOfClass("Backpack")
    if bp then
        for _, tool in ipairs(bp:GetChildren()) do
            if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end
        end
    end
    return nil
end

function isBatTool(tool)
    if not tool then return false end
    for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
        if tool.Name == name then return true end
    end
    return tool.Name:lower():find("bat") or tool.Name:lower():find("slap")
end

function trySwing()
    pcall(function()
        local char = LP.Character
        if not char then return end
        local currentTool = char:FindFirstChildOfClass("Tool")
        if currentTool and not isBatTool(currentTool) then return end
        local bat = findBat()
        if bat then
            if bat.Parent ~= char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum:EquipTool(bat) end) end
            end
            pcall(function() bat:Activate() end)
        end
    end)
end

LAGGER_AIMBOT_SPEED = 40

_vx = { stickyUntil = 0, stickyTarget = nil, target = nil, lastScan = 0, swingCD = false, specSwingCD = false }

function _vxFindBat()
    local char = LP.Character
    if not char then return nil end
    local bp = LP:FindFirstChild("Backpack")
    for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
        local t = char:FindFirstChild(name) or (bp and bp:FindFirstChild(name))
        if t and t:IsA("Tool") then return t end
    end
    return findBat()
end

function _vxAimbotSpeed()
    if laggerToggled then return tonumber(LAGGER_AIMBOT_SPEED) or 40 end
    return tonumber(BAT_AIMBOT_SPEED) or 58
end

function _vxGetTarget()
    local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local now = tick()
    local function stillValid(tRoot)
        if not tRoot or not tRoot.Parent then return false end
        local hum = tRoot.Parent:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return false end
        if (tRoot.Position - root.Position).Magnitude > 85 then return false end
        return true
    end
    local sticky = _vx.stickyTarget
    if sticky and now < _vx.stickyUntil and stillValid(sticky) then
        _vx.target = sticky
        return sticky
    end
    if now - _vx.lastScan <= 0.08 and _vx.target and stillValid(_vx.target) then
        return _vx.target
    end
    _vx.lastScan = now
    local closest = getClosestTargetForAimbot()
    _vx.target = closest
    _vx.stickyTarget = closest
    _vx.stickyUntil = now + 1.25
    return closest
end

function _stopAimbotNormal()
    if _G.Lust.Connections.aimbot then _G.Lust.Connections.aimbot:Disconnect(); _G.Lust.Connections.aimbot = nil end
    _G.Lust.Active.autoBat = false
    autoBatEnabled = false
    _vx.stickyTarget = nil; _vx.target = nil; _vx.swingCD = false
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.AutoRotate = (_prevAutoRotate == nil) and true or _prevAutoRotate
        hum.PlatformStand = false
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
    end
    if root then
        root.AssemblyLinearVelocity = Vector3.new(0, -0.1, 0)
        root.AssemblyAngularVelocity = Vector3.zero
        _speedLVClear(root)
    end
    _prevAutoRotate = nil
    lastMoveDir = Vector3.zero
    _unsuppressBodyLock(true)
    if autoBatSetVisual then autoBatSetVisual(false) end
    if mobSetAutoBat then mobSetAutoBat(false) end
end

function _startAimbotNormal()
    if _G.Lust.Connections.aimbot then return end
    _suppressBodyLock()
    local hum0 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum0 then
        if _prevAutoRotate == nil then _prevAutoRotate = hum0.AutoRotate end
        hum0.AutoRotate = false
    end
    _G.Lust.Active.autoBat = true
    autoBatEnabled = true
    _vx.target = nil; _vx.lastScan = 0
    _G.Lust.Connections.aimbot = RunService.RenderStepped:Connect(function()
        if not autoBatEnabled then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        hum.AutoRotate = false
        if not char:FindFirstChildOfClass("Tool") then
            local b = findBat()
            if b then pcall(function() hum:EquipTool(b) end) end
        end
        local target = getClosestTargetForAimbot()
        if not target then return end
        local myPos = root.Position
        local tPos = target.Position
        local tVel = target.AssemblyLinearVelocity or Vector3.zero
        local aim = tPos + tVel * 0.14 + target.CFrame.LookVector * 0.3 - myPos
        local flat = Vector3.new(aim.X, 0, aim.Z)
        local unit = flat.Magnitude > 0 and flat.Unit or Vector3.zero
        local spd = math.clamp(_vxAimbotSpeed(), 1, 200)
        local yv = math.clamp((tPos.Y + 3.7 - myPos.Y) * 19.5 + tVel.Y * 0.8, -70, 110)
        if hum.FloorMaterial ~= Enum.Material.Air then yv = math.max(yv, 13) end
        root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(Vector3.new(unit.X * spd, yv, unit.Z * spd), 0.8)
        local rotTarget = tPos + tVel * math.clamp(tVel.Magnitude / 150, 0.05, 0.2)
        if (rotTarget - myPos).Magnitude > 0.1 then
            local rx, ry, rz = (root.CFrame:Inverse() * CFrame.lookAt(myPos, rotTarget)):ToEulerAnglesXYZ()
            root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(Vector3.new(
                math.clamp(rx, -1.6, 2.5) * 42, math.clamp(ry, -1.6, 1.6) * 42, math.clamp(rz, -2.5, 2.5) * 42))
        end
        if (myPos - tPos).Magnitude <= 8 then
            local tool = char:FindFirstChildOfClass("Tool") or findBat()
            if tool and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then
                pcall(function()
                    if tool.Parent ~= char then hum:EquipTool(tool) end
                    if tool.Parent == char then tool:Activate() end
                end)
            end
        end
    end)
    if autoBatSetVisual then autoBatSetVisual(true) end
    if mobSetAutoBat then mobSetAutoBat(true) end
end

function disableAutoBat() stopAimbotAdapt(); autoBatEnabled = false; _G.Lust.Active.autoBat = false end

function enableAutoBat()
    if _G.AmbitiousSafeModeTryStart and not _G.AmbitiousSafeModeTryStart() then
        autoBatEnabled = false
        if autoBatSetVisual then autoBatSetVisual(false) end
        if mobSetAutoBat then mobSetAutoBat(false) end
        return
    end
    if autoLeftEnabled then autoLeftEnabled = false; if autoLeftSetVisual then autoLeftSetVisual(false) end; stopAutoLeft() end
    if autoRightEnabled then autoRightEnabled = false; if autoRightSetVisual then autoRightSetVisual(false) end; stopAutoRight() end
    if batDesyncTpEnabled then stopBatDesyncTp() end
    startAimbotAdapt()
end

local batDesyncTpEnabled = false
local batDesyncTpConn = nil
local batDesyncTpSetVisual = nil

local _TpBat = { version = "V1", distance = 8, speed = 40, hitCD = false, inputConn = nil }

function _TpBat.isBatTool(tool)
    if not tool or not tool:IsA("Tool") then return false end
    local n = string.lower(tool.Name)
    return n == "bat" or n:find("bat", 1, true) ~= nil or n:find("slap", 1, true) ~= nil
end
function _TpBat.getBat()
    local c = LP.Character
    if not c then return nil end
    local hum = c:FindFirstChildOfClass("Humanoid")
    for _, ch in ipairs(c:GetChildren()) do
        if _TpBat.isBatTool(ch) then return ch end
    end
    local bp = LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")
    if bp then
        for _, ch in ipairs(bp:GetChildren()) do
            if _TpBat.isBatTool(ch) then
                if hum then pcall(function() hum:EquipTool(ch) end) else pcall(function() ch.Parent = c end) end
                return ch
            end
        end
    end
    return nil
end

_zTP = {
    MAP = { X1 = -536.2, X2 = -422, Y1 = -10, Y2 = 75, Z1 = -71.8, Z2 = 192.9 },
    M = { samples = {}, markerLocked = false, markerTarget = nil, lastTargetMarker = nil, conn = nil, acc = 0 },
    C = { enabled = false, conn = nil, target = nil, samples = {}, swingLocked = false,
          nextSwingAt = 0, previousAutoRotate = nil, returnGeneration = 0 },
}
_zTP.USE_MAP_BOUNDS = false
function _zTP.inMap(p)
    if p == nil then return false end
    if not _zTP.USE_MAP_BOUNDS then
        return p.X == p.X and p.Y == p.Y and p.Z == p.Z and math.abs(p.X) < 10000000 and math.abs(p.Z) < 10000000 and p.Y > -100 and p.Y < 10000000
    end
    local m = _zTP.MAP
    return p.X >= m.X1 and p.X <= m.X2 and p.Y >= m.Y1 and p.Y <= m.Y2 and p.Z >= m.Z1 and p.Z <= m.Z2
end
function _zTP.finite(v)
    return v ~= nil and v.X == v.X and v.Y == v.Y and v.Z == v.Z
        and math.abs(v.X) < 10000000 and math.abs(v.Y) < 10000000 and math.abs(v.Z) < 10000000
end
function _zTP.distance()
    local n = tonumber(_TpBat.distance)
    if not n or n ~= n then return 8 end
    return math.clamp(n, 0, 100)
end
function _zTP.lookCF(pos, toward, look, cf)
    local d = Vector3.new(toward.X - pos.X, 0, toward.Z - pos.Z)
    if d.Magnitude > 0.05 then return CFrame.lookAt(pos, pos + d.Unit) end
    local l = look and Vector3.new(look.X, 0, look.Z) or nil
    if l and l.Magnitude >= 0.01 then return CFrame.lookAt(pos, pos + l.Unit) end
    if cf then
        local _, ry = cf:ToEulerAnglesYXZ()
        return CFrame.new(pos) * CFrame.Angles(0, ry, 0)
    end
    return CFrame.new(pos)
end
function _zTP.markerCF(root, marker)
    if not root or not marker then return nil end
    local mp = marker.Position
    local d = Vector3.new(root.Position.X - mp.X, 0, root.Position.Z - mp.Z)
    if d.Magnitude <= 0.05 then
        local l = marker.CFrame.LookVector
        d = Vector3.new(-l.X, 0, -l.Z)
    end
    local dir = d.Magnitude <= 0.05 and Vector3.new(0, 0, 1) or d
    return _zTP.lookCF(mp + dir.Unit * 3, mp, marker.CFrame.LookVector, root.CFrame)
end
function _zTP.tp(root, cf)
    local mk = _zTP.M.lastTargetMarker
    if mk and mk.Parent and mk.Transparency and mk.Transparency < 1 then return false end
    return pcall(function()
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
        root.CFrame = cf
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
    end)
end
function _zTP.setMarkerVisible(mk, on)
    pcall(function()
        mk.Transparency = on and 0 or 1
        local a = mk:FindFirstChild("AlwaysOnTopSphere"); if a then a.Visible = on end
        local h = mk:FindFirstChild("LastPositionHighlight"); if h then h.Enabled = on end
        local l = mk:FindFirstChild("LastPositionLabel"); if l then l.Enabled = on end
    end)
end
function _zTP.showMarker(cf)
    local M = _zTP.M
    if not _zTP.USE_MAP_BOUNDS then return end
    if M.markerLocked then return end
    local plr = M.markerTarget
    local ch = plr and plr.Parent == Players and plr.Character
    local tr = ch and ch:FindFirstChild("HumanoidRootPart")
    local th = ch and ch:FindFirstChildOfClass("Humanoid")
    if not tr or not th or th.Health <= 0 or not _zTP.finite(tr.Position) or _zTP.inMap(tr.Position) then return end
    if not cf or not _zTP.inMap(cf.Position) then return end
    local mcf = CFrame.new(cf.Position.X, -7, cf.Position.Z) * cf.Rotation
    local mk = M.lastTargetMarker
    if not mk or not mk.Parent then
        mk = Instance.new("Part")
        mk.Name = "AmbitiousTPBatLastPosition"
        mk.Shape = Enum.PartType.Ball
        mk.Size = Vector3.new(3, 3, 3)
        mk.Color = Color3.fromRGB(167, 167, 167)
        mk.Material = Enum.Material.Neon
        mk.Anchored = true
        mk.CanCollide = false
        mk.CanTouch = false
        mk.CanQuery = false
        mk.CastShadow = false
        mk.Parent = workspace
        local sph = Instance.new("SphereHandleAdornment")
        sph.Name = "AlwaysOnTopSphere"
        sph.Adornee = mk
        sph.Radius = 1.55
        sph.Color3 = Color3.fromRGB(176, 176, 176)
        sph.Transparency = 0.05
        sph.AlwaysOnTop = true
        sph.Visible = true
        sph.ZIndex = 10
        sph.Parent = mk
        local hl = Instance.new("Highlight")
        hl.Name = "LastPositionHighlight"
        hl.Adornee = mk
        hl.FillColor = Color3.fromRGB(167, 167, 167)
        hl.FillTransparency = 0.15
        hl.OutlineColor = Color3.fromRGB(176, 176, 176)
        hl.OutlineTransparency = 0
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Enabled = true
        hl.Parent = mk
        local bb = Instance.new("BillboardGui")
        bb.Name = "LastPositionLabel"
        bb.Size = UDim2.new(0, 110, 0, 20)
        bb.StudsOffset = Vector3.new(0, 2.1, 0)
        bb.AlwaysOnTop = true
        bb.Adornee = mk
        bb.Parent = mk
        local lb = Instance.new("TextLabel")
        lb.Name = "Text"
        lb.Size = UDim2.fromScale(1, 1)
        lb.BackgroundTransparency = 1
        lb.Text = "derniere position"
        lb.TextColor3 = Color3.fromRGB(233, 233, 233)
        lb.TextStrokeColor3 = Color3.fromRGB(65, 65, 65)
        lb.TextStrokeTransparency = 0.25
        lb.TextSize = 11
        lb.Font = Enum.Font.GothamMedium
        lb.Parent = bb
        M.lastTargetMarker = mk
    end
    _zTP.setMarkerVisible(mk, true)
    mk.CFrame = mcf
    M.markerLocked = true
end
function _zTP.hideMarker()
    local M = _zTP.M
    M.markerLocked = false
    if M.lastTargetMarker then _zTP.setMarkerVisible(M.lastTargetMarker, false) end
end
function _zTP.getMarkerCFrame()
    local M = _zTP.M
    local mk = M.lastTargetMarker
    if M.markerLocked and mk and mk.Parent and mk.Transparency < 1 then
        local plr = M.markerTarget
        local tr = plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        if tr and _zTP.inMap(tr.Position) then
            _zTP.hideMarker()
            return nil
        end
        local char = LP.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        return _zTP.markerCF(root, mk) or mk.CFrame
    end
    return nil
end
function _zTP.trackTarget(p)
    local M = _zTP.M
    if M.markerLocked then return M.markerTarget end
    local cur = M.markerTarget
    local ch = cur and cur.Parent == Players and cur.Character
    local hum = ch and ch:FindFirstChildOfClass("Humanoid")
    local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
    local sm = cur and M.samples[cur]
    if cur and cur.Parent == Players then
        if hum and hum.Health > 0 and ((hrp and _zTP.inMap(hrp.Position)) or (sm and sm.safeCFrame)) then return cur end
        if not hum and sm and sm.safeCFrame then return cur end
    end
    if p and p ~= LP and p.Parent == Players then M.markerTarget = p; return p end
    return M.markerTarget
end
function _zTP.validInMap(plr)
    if not plr or plr.Parent ~= Players or not plr.Character then return false end
    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
    local hum = plr.Character:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum or hum.Health <= 0 or not _zTP.inMap(hrp.Position) then return false end
    return true
end
function _zTP.historyAt(sm, t)
    if not sm or not sm.history or #sm.history == 0 then return nil end
    local cut = t - 0.2
    local pick
    for _, h in ipairs(sm.history) do
        if not (h.time <= cut) then break end
        pick = h
    end
    return pick or sm.history[1]
end
function _zTP.forceMarker(plr, cf)
    local M = _zTP.M
    if plr and plr.Parent == Players then M.markerTarget = plr end
    local sm = plr and M.samples[plr]
    local h = _zTP.historyAt(sm, tick())
    local safe = (h and h.safeCFrame) or (sm and sm.safeCFrame)
    if not safe and cf and _zTP.inMap(cf.Position) then safe = cf end
    if safe then _zTP.showMarker(safe) end
    return _zTP.getMarkerCFrame()
end
function _zTP.sample()
    local M = _zTP.M
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local plr = M.markerTarget
    if plr and plr.Parent == Players then
        local tr = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        local th = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
        local sm = M.samples[plr] or {}
        M.samples[plr] = sm
        if tr and th and th.Health > 0 and _zTP.finite(tr.Position) then
            if _zTP.inMap(tr.Position) then
                local now = tick()
                if M.markerLocked then sm.history = {} end
                sm.history = sm.history or {}
                table.insert(sm.history, { time = now, safePosition = tr.Position, safeCFrame = tr.CFrame })
                while sm.history[1] and now - sm.history[1].time > 0.45 do table.remove(sm.history, 1) end
                sm.safePosition = tr.Position
                sm.safeCFrame = tr.CFrame
                _zTP.hideMarker()
            else
                local h = _zTP.historyAt(sm, tick())
                _zTP.showMarker(h and h.safeCFrame or sm.safeCFrame)
            end
        end
        if (th and th.Health <= 0) or (not tr and not sm.safeCFrame) then
            M.markerTarget = nil
            _zTP.hideMarker()
        else
            return
        end
    end
    local bestD, best = math.huge, nil
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and _zTP.validInMap(p) then
            local d = p.Character.HumanoidRootPart.Position - root.Position
            local dd = d:Dot(d)
            if dd < bestD then bestD = dd; best = p end
        end
    end
    if best then
        M.markerTarget = best
        local tr = best.Character:FindFirstChild("HumanoidRootPart")
        local sm = M.samples[best] or {}
        M.samples[best] = sm
        sm.safePosition = tr.Position
        sm.safeCFrame = tr.CFrame
        sm.history = { { time = tick(), safePosition = tr.Position, safeCFrame = tr.CFrame } }
    end
end
function _zTP.valid(plr)
    if not plr or plr.Parent ~= Players or not plr.Character then return false end
    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
    local hum = plr.Character:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum or hum.Health <= 0 or not _zTP.finite(hrp.Position) then return false end
    local sm = _zTP.C.samples[plr]
    return _zTP.inMap(hrp.Position) or (sm ~= nil and sm.safeCFrame ~= nil)
end
function _zTP.safeCF(plr)
    local sm = plr and _zTP.C.samples[plr]
    return sm and sm.safeCFrame or nil
end
function _zTP.pickTarget(root)
    local C = _zTP.C
    local tracked = _zTP.trackTarget(C.target)
    if _zTP.valid(tracked) then C.target = tracked; return tracked end
    if _zTP.valid(C.target) then return C.target end
    local best, bestD = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and _zTP.valid(p) then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local d = (hrp.Position - root.Position).Magnitude
                if d < bestD then bestD = d; best = p end
            end
        end
    end
    if best then C.target = best; _zTP.trackTarget(best) end
    return best
end
function _zTP.swing()
    local C = _zTP.C
    local now = tick()
    if C.swingLocked or now < C.nextSwingAt then return end
    C.swingLocked = true
    C.nextSwingAt = now + 0.0149
    pcall(function()
        local bat = _TpBat.getBat()
        if not bat then return end
        bat:Activate()
        local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
        if ev then ev:FireServer() end
    end)
    task.delay(0.0149, function() C.swingLocked = false end)
end
function _zTP.followMarker(root)
    local cf = _zTP.getMarkerCFrame()
    if not cf then return false end
    pcall(function()
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
        root.CFrame = cf
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
    end)
    return true
end
function _zTP.step()
    local C = _zTP.C
    if not C.enabled then return end
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not root or not hum or hum.Health <= 0 then return end
    if _zTP.followMarker(root) then _zTP.swing(); return end
    if C.previousAutoRotate == nil then C.previousAutoRotate = hum.AutoRotate end
    hum.AutoRotate = false
    local target = _zTP.pickTarget(root)
    if not target then return end
    local tRoot = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
    local safe = _zTP.safeCF(target)
    if not tRoot or not _zTP.finite(tRoot.Position) then return end
    if not _zTP.inMap(tRoot.Position) then
        _zTP.forceMarker(target, safe)
        if _zTP.followMarker(root) then _zTP.swing() end
        return
    end
    local cf = tRoot.CFrame
    local sm = C.samples[target] or {}
    C.samples[target] = sm
    sm.safeCFrame = cf
    sm.safePosition = cf.Position
    local targetPos = cf.Position + Vector3.new(0, 0.9, 0)
    local look = cf.LookVector
    if (root.Position - targetPos).Magnitude > _zTP.distance() then
        _zTP.tp(root, _zTP.lookCF(targetPos, cf.Position, look, root.CFrame))
    else
        _zTP.tp(root, _zTP.lookCF(root.Position, cf.Position, look, root.CFrame))
    end
    local cam = workspace.CurrentCamera
    if cam then pcall(function() cam.CFrame = CFrame.new(cam.CFrame.Position, cf.Position) end) end
    _zTP.swing()
end
function _zTP.enable()
    local C, M = _zTP.C, _zTP.M
    if C.enabled then return end
    C.returnGeneration = (C.returnGeneration or 0) + 1
    C.enabled = true
    C.target = nil; C.samples = {}; C.swingLocked = false; C.nextSwingAt = 0
    M.markerTarget = nil; M.samples = {}; M.acc = 0
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if root then
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
    end
    if hum then C.previousAutoRotate = hum.AutoRotate end
    if C.conn then pcall(function() C.conn:Disconnect() end) end
    C.conn = RunService.Heartbeat:Connect(_zTP.step)
    if M.conn then pcall(function() M.conn:Disconnect() end) end
    M.conn = RunService.Heartbeat:Connect(function(dt)
        M.acc = M.acc + (dt or 0)
        if M.acc < 1 / 30 then return end
        M.acc = M.acc % (1 / 30)
        pcall(_zTP.sample)
    end)
    task.spawn(function() pcall(_zTP.step) end)
end
function _zTP.disable()
    local C, M = _zTP.C, _zTP.M
    local wasEnabled = C.enabled
    local gen = C.returnGeneration
    _zTP.hideMarker()
    C.enabled = false
    if C.conn then pcall(function() C.conn:Disconnect() end); C.conn = nil end
    if M.conn then pcall(function() M.conn:Disconnect() end); M.conn = nil end
    C.target = nil; C.samples = {}; C.swingLocked = false
    M.markerTarget = nil; M.samples = {}
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if root then
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
    end
    if hum then
        hum.AutoRotate = (C.previousAutoRotate == nil) and true or C.previousAutoRotate
        pcall(function()
            hum.PlatformStand = false
            hum.Sit = false
            local st = hum:GetState()
            if st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll
                or st == Enum.HumanoidStateType.FallingDown then
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end
            local cam = workspace.CurrentCamera
            if cam then cam.CameraSubject = hum end
        end)
    end
    C.previousAutoRotate = nil
    if wasEnabled and root then
        task.spawn(function()
            for _ = 1, 12 do
                RunService.Heartbeat:Wait()
                if C.enabled or C.returnGeneration ~= gen then return end
                local ch2 = LP.Character
                local r2 = ch2 and ch2:FindFirstChild("HumanoidRootPart")
                local h2 = ch2 and ch2:FindFirstChildOfClass("Humanoid")
                if r2 ~= root or not h2 or h2.Health <= 0 then return end
                r2.AssemblyLinearVelocity = Vector3.zero
                r2.AssemblyAngularVelocity = Vector3.zero
            end
        end)
    end
end

function updateTpBatButtonWithAntiDie(on)
    if bypassFloatingButton then
        local btnFrame = bypassFloatingButton:FindFirstChild("Frame")
        if btnFrame then paintFloatingBtn(btnFrame, on) end
    end
end

function startBatDesyncTp()
    if batDesyncTpConn then return end
    if _G.AmbitiousSafeModeTryStart and not _G.AmbitiousSafeModeTryStart() then return end
    _tpBatAutoAntiDie(true)
    batDesyncTpEnabled = true
    bypassToggled = true
    _G.Lust.Active.bypass = true
    _zTP.enable()
    batDesyncTpConn = _zTP.C.conn
    _G.Lust.Connections.bypass = batDesyncTpConn
    if batDesyncTpSetVisual then batDesyncTpSetVisual(true) end
    updateTpBatButtonWithAntiDie(true)
end

function stopBatDesyncTp()
    if batDesyncTpConn then pcall(function() batDesyncTpConn:Disconnect() end); batDesyncTpConn = nil end
    _zTP.disable()
    _G.Lust.Connections.bypass = nil
    batDesyncTpEnabled = false
    bypassToggled = false
    _G.Lust.Active.bypass = false
    _TpBat.hitCD = false
    if batDesyncTpSetVisual then batDesyncTpSetVisual(false) end
    updateTpBatButtonWithAntiDie(false)
    task.delay(0.4, function()
        if not batDesyncTpEnabled then _tpBatAutoAntiDie(false) end
    end)
end

function toggleBatDesyncTp()
    if batDesyncTpEnabled then
        stopBatDesyncTp()
    else
        disableAllAimbots()
        if autoLeftEnabled then autoLeftEnabled = false; stopAutoLeft()
            if autoLeftSetVisual then autoLeftSetVisual(false) end
            if mobSetAutoLeft then mobSetAutoLeft(false) end end
        if autoRightEnabled then autoRightEnabled = false; stopAutoRight()
            if autoRightSetVisual then autoRightSetVisual(false) end
            if mobSetAutoRight then mobSetAutoRight(false) end end
        startBatDesyncTp()
    end
    if batDesyncTpSetVisual then batDesyncTpSetVisual(batDesyncTpEnabled) end
    saveAllSettings()
end

aimbotMode = 1
aimbotModeBtn = nil
tpBatDistBox = nil
_V3new = Vector3.new
_V3zero = Vector3.zero
_clamp = math.clamp
_BY_ANG = "_AdaptBP_AngV"
_BY_ATT = "_AdaptBP_Att"
_BY_SWING_RANGE = 12
_ByAim = { conn=nil, safety=nil, respawn=nil, av=nil, att=nil, vel=Vector3.new(0,0,0), active=false, prevAutoRotate=nil, equipped=false, target=nil }
_BY_LOCK_NAMES = {"LockBAV","LockAngVel","LockBodyAtt","BatLock","LockBAVAtt","AutoBatAtt","AutoBatAV","AntiBatDet","AntiAim","VelocityLock"}

function _aimbotModeText() return aimbotMode == 2 and "Bypass" or "Bat Aimbot" end

function _byAimCleanLocks(root)
    if not root then return end
    pcall(function()
        for _, n in ipairs(_BY_LOCK_NAMES) do
            local o = root:FindFirstChild(n); if o then o:Destroy() end
        end
        for _, c in ipairs(root:GetChildren()) do
            if c.Name ~= _BY_ANG and c.Name ~= _BY_ATT then
                local l = c.Name:lower()
                if l:find("lockb") or l:find("lockangv") or l:find("batlock") or l:find("antiaim") or l:find("velocitylock") then
                    c:Destroy()
                end
            end
        end
    end)
end

function _byAimDestroyAV()
    pcall(function() if _ByAim.av and _ByAim.av.Parent then _ByAim.av:Destroy() end end)
    pcall(function() if _ByAim.att and _ByAim.att.Parent then _ByAim.att:Destroy() end end)
    _ByAim.av = nil; _ByAim.att = nil
end

function _byAimMakeAV(root)
    pcall(function()
        local a = root:FindFirstChild(_BY_ANG); if a then a:Destroy() end
        local b = root:FindFirstChild(_BY_ATT); if b then b:Destroy() end
    end)
    local att = Instance.new("Attachment")
    att.Name = _BY_ATT
    att.Parent = root
    local av = Instance.new("AngularVelocity")
    av.Name = _BY_ANG
    av.Attachment0 = att
    av.RelativeTo = Enum.ActuatorRelativeTo.World
    av.MaxTorque = math.huge
    av.AngularVelocity = _V3zero
    av.Parent = root
    _ByAim.att = att; _ByAim.av = av
end

function _byAimNearest(fromRoot)
    local best, bestDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.Health > 0 then
                local d = (hrp.Position - fromRoot.Position).Magnitude
                if d < bestDist then bestDist = d; best = hrp end
            end
        end
    end
    return best, bestDist
end

function _stopAimbotBypass()
    if _ByAim.conn then pcall(function() _ByAim.conn:Disconnect() end); _ByAim.conn = nil end
    if _ByAim.safety then pcall(function() _ByAim.safety:Disconnect() end); _ByAim.safety = nil end
    if _ByAim.respawn then pcall(function() _ByAim.respawn:Disconnect() end); _ByAim.respawn = nil end
    local wasActive = _ByAim.active
    _ByAim.active = false
    _ByAim.equipped = false
    _ByAim.target = nil
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if root then pcall(function() root.Velocity = root.Velocity * 0.3 end) end
    if hum then hum.AutoRotate = (_ByAim.prevAutoRotate == nil) and true or _ByAim.prevAutoRotate end
    _ByAim.prevAutoRotate = nil; _ByAim.vel = _V3zero
    if _ByAim.av then pcall(function() _ByAim.av.AngularVelocity = _V3zero end) end
    _byAimDestroyAV()
    if root then
        local a = root:FindFirstChild(_BY_ANG); if a then a:Destroy() end
        local at = root:FindFirstChild(_BY_ATT); if at then at:Destroy() end
    end
    if wasActive then _unsuppressBodyLock(true) end
end

function _startAimbotBypass()
    if _ByAim.conn then return end
    _suppressBodyLock()
    _ByAim.active = true
    _ByAim.cd = false
    local hum0 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum0 then
        if _ByAim.prevAutoRotate == nil then _ByAim.prevAutoRotate = hum0.AutoRotate end
        hum0.AutoRotate = false
    end
    _ByAim.conn = RunService.RenderStepped:Connect(function()
        if not autoBatEnabled or aimbotMode ~= 2 then return end
        local char = LP.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        hum.AutoRotate = false
        local target = getClosestTargetForAimbot()
        if not target then return end
        local delta = target.Position - root.Position
        local flat = Vector3.new(delta.X, 0, delta.Z)
        local unit = flat.Magnitude > 0 and flat.Unit or Vector3.zero
        local spd = math.clamp(tonumber(BYPASS_AIMBOT_SPEED) or 60, 1, 200)
        local yv = math.clamp((target.Position.Y + 3.7 - root.Position.Y) * 19.5, -70, 110)
        if hum.FloorMaterial ~= Enum.Material.Air then yv = math.max(yv, 13) end
        root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(Vector3.new(unit.X * spd, yv, unit.Z * spd), 0.75)
        if delta.Magnitude > 0.1 then
            local rx, ry, rz = (root.CFrame:Inverse() * CFrame.lookAt(root.Position, target.Position)):ToEulerAnglesXYZ()
            root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(Vector3.new(
                math.clamp(rx, -2.5, 2.5) * 42, math.clamp(ry, -1.6, 2.5) * 42, math.clamp(rz, -2.5, 2.5) * 42))
        end
        local tool = char:FindFirstChildOfClass("Tool") or findBat()
        if tool and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) and not _ByAim.cd then
            _ByAim.cd = true
            pcall(function()
                if tool.Parent ~= char then hum:EquipTool(tool) end
                if tool.Parent == char then tool:Activate() end
            end)
            task.delay(0.08, function() _ByAim.cd = false end)
        end
    end)
end

function stopAimbotAdapt()
    if _ByAim.active then
        _stopAimbotBypass()
        _G.Lust.Active.autoBat = false
        autoBatEnabled = false
        if autoBatSetVisual then autoBatSetVisual(false) end
        if mobSetAutoBat then mobSetAutoBat(false) end
    else
        _stopAimbotNormal()
    end
end

function startAimbotAdapt()
    if aimbotMode == 2 then
        if _ByAim.conn then return end
        _G.Lust.Active.autoBat = true
        autoBatEnabled = true
        _startAimbotBypass()
        if autoBatSetVisual then autoBatSetVisual(true) end
        if mobSetAutoBat then mobSetAutoBat(true) end
    else
        _startAimbotNormal()
    end
end

function setAimbotMode(m)
    m = (m == 2) and 2 or 1
    if m == aimbotMode then return end
    local running = autoBatEnabled
    if running then stopAimbotAdapt() end
    aimbotMode = m
    if running then startAimbotAdapt() end
end

function startBypassAimbot() startBatDesyncTp() end
function stopBypassAimbot() stopBatDesyncTp() end
function toggleBypass(state)
    if state == nil then state = not batDesyncTpEnabled end
    if state then startBatDesyncTp() else stopBatDesyncTp() end
end

LP.CharacterAdded:Connect(function()
    if batDesyncTpEnabled then
        task.wait(0.5)
        if not batDesyncTpConn then startBatDesyncTp() end
    end
end)

local batCounterDebounce = false
local _bodyLockCounterActive = false

local function _faceAttackerFor1s()
    if _bodyLockCounterActive then return end
    _bodyLockCounterActive = true
    local c = LP.Character
    if not c then _bodyLockCounterActive = false; return end
    local root = c:FindFirstChild("HumanoidRootPart")
    if not root then _bodyLockCounterActive = false; return end
    local hum2 = c:FindFirstChildOfClass("Humanoid")
    if not hum2 then _bodyLockCounterActive = false; return end
    local target = getClosestTarget()
    if not target then _bodyLockCounterActive = false; return end
    hum2.AutoRotate = false
    local deadline = tick() + 1
    local fconn
    fconn = RunService.RenderStepped:Connect(function()
        if tick() >= deadline then
            fconn:Disconnect()
            local c2 = LP.Character
            local hum3 = c2 and c2:FindFirstChildOfClass("Humanoid")
            local root2 = c2 and c2:FindFirstChild("HumanoidRootPart")
            if hum3 then hum3.AutoRotate = true end
            if root2 then root2.AssemblyAngularVelocity = Vector3.zero end
            _bodyLockCounterActive = false
            return
        end
        local c2 = LP.Character
        if not c2 then return end
        local root2 = c2:FindFirstChild("HumanoidRootPart")
        if not root2 then return end
        local myPos = root2.Position
        local tgtPos = target.Position + target.AssemblyLinearVelocity * 0.1
        local toTarget = tgtPos - myPos
        if toTarget.Magnitude > 0.1 then
            local goalCF = CFrame.lookAt(myPos, tgtPos)
            local diffCF = root2.CFrame:Inverse() * goalCF
            local _, ry, _ = diffCF:ToEulerAnglesXYZ()
            ry = math.clamp(ry, -2.5, 2.5)
            root2.AssemblyAngularVelocity = root2.CFrame:VectorToWorldSpace(Vector3.new(0, ry * 42, 0))
        end
    end)
end

local function findBatForCounter()
    local c = LP.Character
    if not c then return nil end
    local bp = LP:FindFirstChildOfClass("Backpack")
    for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
        local t = c:FindFirstChild(name) or (bp and bp:FindFirstChild(name))
        if t then return t end
    end
    for _, ch in ipairs(c:GetChildren()) do
        if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end
    end
    if bp then
        for _, ch in ipairs(bp:GetChildren()) do
            if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end
        end
    end
    return nil
end

local function swingBatInstant(bat, char)
    local hum2 = char:FindFirstChildOfClass("Humanoid")
    if bat.Parent ~= char and hum2 then pcall(function() hum2:EquipTool(bat) end) end
    local remote = bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildOfClass("RemoteFunction")
    if remote and remote:IsA("RemoteEvent") then
        pcall(function() remote:FireServer() end)
        pcall(function() remote:FireServer() end)
        pcall(function() remote:FireServer() end)
    else
        pcall(function() bat:Activate() end)
        pcall(function() bat:Activate() end)
        pcall(function() bat:Activate() end)
    end
end

function startBatCounter()
    if _G.Lust.Connections.batCounter then return end
    if not batCounterEnabled then return end
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    _G.Lust.Connections.batCounter = hum.StateChanged:Connect(function(oldState, newState)
        if batCounterDebounce then return end
        if not batCounterEnabled then return end
        local isRagdolled = newState == Enum.HumanoidStateType.Physics or
                            newState == Enum.HumanoidStateType.Ragdoll or
                            newState == Enum.HumanoidStateType.FallingDown
        if isRagdolled then
            batCounterDebounce = true
            task.spawn(function()
                local bat = findBatForCounter()
                if bat then
                    local c = LP.Character
                    if c then swingBatInstant(bat, c); _faceAttackerFor1s() end
                end
                task.wait(0.15)
                batCounterDebounce = false
            end)
        end
    end)
    _G.Lust.Active.batCounter = true
    if setBatCounterVisual then setBatCounterVisual(true) end
end

function stopBatCounter()
    if _G.Lust.Connections.batCounter then _G.Lust.Connections.batCounter:Disconnect(); _G.Lust.Connections.batCounter = nil end
    batCounterDebounce = false
    _G.Lust.Active.batCounter = false
    if setBatCounterVisual then setBatCounterVisual(false) end
end

function setBatCounterState(state)
    batCounterEnabled = state == true
    if batCounterEnabled then startBatCounter() else stopBatCounter() end
end

LP.CharacterAdded:Connect(function(newChar)
    if batCounterEnabled then
        if _G.Lust.Connections.batCounter then _G.Lust.Connections.batCounter:Disconnect(); _G.Lust.Connections.batCounter = nil end
        batCounterDebounce = false
        local hum = newChar:WaitForChild("Humanoid", 5)
        if hum then startBatCounter() end
    end
end)

function findMedusa()
    local c = LP.Character
    if not c then return nil end
    for _, t in ipairs(c:GetChildren()) do
        if t:IsA("Tool") then
            local n = t.Name:lower()
            if n:find("medusa") or n:find("head") or n:find("stone") then return t end
        end
    end
    local bp = LP:FindFirstChild("Backpack")
    if bp then
        for _, t in ipairs(bp:GetChildren()) do
            if t:IsA("Tool") then
                local n = t.Name:lower()
                if n:find("medusa") or n:find("head") or n:find("stone") then return t end
            end
        end
    end
    return nil
end

function useMedusaCounter()
    if medusaDebounce then return end
    if tick() - medusaLastUsed < MEDUSA_COOLDOWN then return end
    local c = LP.Character
    if not c then return end
    medusaDebounce = true
    local med = findMedusa()
    if not med then medusaDebounce = false; return end
    if med.Parent ~= c then
        local hum2 = c:FindFirstChildOfClass("Humanoid")
        if hum2 then hum2:EquipTool(med) end
    end
    pcall(function() med:Activate() end)
    medusaLastUsed = tick()
    medusaDebounce = false
end

function setupMedusa(char)
    for _, c in pairs(_G.Lust.Connections.medusa) do pcall(function() c:Disconnect() end) end
    _G.Lust.Connections.medusa = {}
    if not char or not medusaCounterEnabled then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            table.insert(_G.Lust.Connections.medusa, part:GetPropertyChangedSignal("Anchored"):Connect(function()
                if medusaCounterEnabled and part.Anchored and part.Transparency == 1 then useMedusaCounter() end
            end))
        end
    end
    table.insert(_G.Lust.Connections.medusa, char.DescendantAdded:Connect(function(part)
        if part:IsA("BasePart") then
            table.insert(_G.Lust.Connections.medusa, part:GetPropertyChangedSignal("Anchored"):Connect(function()
                if medusaCounterEnabled and part.Anchored and part.Transparency == 1 then useMedusaCounter() end
            end))
        end
    end))
end

function stopMedusaCounter()
    for _, c in pairs(_G.Lust.Connections.medusa) do pcall(function() c:Disconnect() end) end
    _G.Lust.Connections.medusa = {}
    _G.Lust.Active.medusa = false
end

function setMedusaCounterState(state)
    medusaCounterEnabled = state
    if state then
        _G.Lust.Active.medusa = true
        if LP.Character then setupMedusa(LP.Character) else stopMedusaCounter() end
        if setMedusaVisual then setMedusaVisual(true) end
    else
        stopMedusaCounter()
        if setMedusaVisual then setMedusaVisual(false) end
    end
end

local DROP_ASCEND_DURATION = 0.22
local DROP_ASCEND_SPEED = 160
local _dropConn = nil

function stopDropBrainrot()
    dropActive = false
    if _dropConn then _dropConn:Disconnect(); _dropConn = nil end
    if _G.Lust.Connections.dropBrainrot then _G.Lust.Connections.dropBrainrot:Disconnect(); _G.Lust.Connections.dropBrainrot = nil end
    for _, t in ipairs(dropConnections) do
        if type(t) == "thread" then pcall(task.cancel, t)
        elseif type(t) == "RBXScriptConnection" then pcall(t.Disconnect, t) end
    end
    dropConnections = {}
    local c = LP.Character
    if c then
        local root = c:FindFirstChild("HumanoidRootPart")
        if root then root.AssemblyLinearVelocity = Vector3.zero end
    end
    if dropBrainrotSetVisual then dropBrainrotSetVisual(false) end
    if mobSetDropBR then mobSetDropBR(false) end
end

function runDropBrainrot()
    if dropActive then return end
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return end
    if dropMode == 1 then
        local speedH = 0
        local vel = root.AssemblyLinearVelocity
        speedH = Vector3.new(vel.X, 0, vel.Z).Magnitude
        local cooldown = (speedH > 5) and 0.6 or 0.25
        if tick() - lastDropTime < cooldown then return end
        lastDropTime = tick()
        dropActive = true
        if dropBrainrotSetVisual then dropBrainrotSetVisual(true) end
        if mobSetDropBR then mobSetDropBR(true) end
        local wasAutoBat = false
        if autoBatEnabled then
            wasAutoBat = true
            disableAutoBat()
            if autoBatSetVisual then autoBatSetVisual(false) end
            if mobSetAutoBat then mobSetAutoBat(false) end
        end
        local function finishDrop(threadRef)
            if threadRef and dropConnections then
                for i = #dropConnections, 1, -1 do
                    if dropConnections[i] == threadRef then table.remove(dropConnections, i); break end
                end
            end
            dropActive = false
            local c = LP.Character
            if c then
                local r = c:FindFirstChild("HumanoidRootPart")
                local h = c:FindFirstChildOfClass("Humanoid")
                if r then
                    r.AssemblyLinearVelocity = Vector3.zero
                    r.AssemblyAngularVelocity = Vector3.zero
                    if r.Position.Y < -100 then r.CFrame = CFrame.new(r.Position.X, 5, r.Position.Z) end
                    local rp = RaycastParams.new()
                    rp.FilterDescendantsInstances = {c}
                    rp.FilterType = Enum.RaycastFilterType.Exclude
                    local rr = workspace:Raycast(r.Position, Vector3.new(0, -2000, 0), rp)
                    if rr then
                        local off = (h and h.HipHeight or 2) + (r.Size.Y / 2)
                        r.CFrame = CFrame.new(r.Position.X, rr.Position.Y + off, r.Position.Z)
                    end
                    if h and h.Health > 0 then h:ChangeState(Enum.HumanoidStateType.Running) end
                end
            end
            if wasAutoBat then
                enableAutoBat()
                if autoBatSetVisual then autoBatSetVisual(true) end
                if mobSetAutoBat then mobSetAutoBat(true) end
            end
            if dropBrainrotSetVisual then dropBrainrotSetVisual(false) end
            if mobSetDropBR then mobSetDropBR(false) end
        end
        local flingThread = nil
        flingThread = task.spawn(function()
            local startTime = tick()
            while dropActive and (tick() - startTime) < 0.25 do
                RunService.Heartbeat:Wait()
                local c = LP.Character
                local r = c and c:FindFirstChild("HumanoidRootPart")
                if not r then break end
                local vel = r.AssemblyLinearVelocity
                vel = Vector3.new(0, vel.Y, 0)
                r.AssemblyLinearVelocity = vel * 10000 + Vector3.new(0, 10000, 0)
                RunService.RenderStepped:Wait()
                if r and r.Parent then r.AssemblyLinearVelocity = vel end
                RunService.Stepped:Wait()
                if r and r.Parent then r.AssemblyLinearVelocity = vel + Vector3.new(0, 0.1, 0) end
            end
            finishDrop(flingThread)
        end)
        table.insert(dropConnections, flingThread)
        task.delay(0.35, function() if dropActive then finishDrop(flingThread) end end)
        return
    end
    dropActive = true
    if dropBrainrotSetVisual then dropBrainrotSetVisual(true) end
    if mobSetDropBR then mobSetDropBR(true) end
    local t0 = tick()
    if _dropConn then _dropConn:Disconnect() end
    _G.Lust.Connections.dropBrainrot = RunService.Heartbeat:Connect(function()
        local c = LP.Character
        local r = c and c:FindFirstChild("HumanoidRootPart")
        if not r then stopDropBrainrot(); return end
        if not dropActive then stopDropBrainrot(); return end
        if tick() - t0 >= DROP_ASCEND_DURATION then
            stopDropBrainrot()
            pcall(function()
                local rp = RaycastParams.new()
                rp.FilterDescendantsInstances = {c}
                rp.FilterType = Enum.RaycastFilterType.Exclude
                local rr = workspace:Raycast(r.Position, Vector3.new(0, -3000, 0), rp)
                if rr then
                    local hum2 = c:FindFirstChildOfClass("Humanoid")
                    local off = ((hum2 and hum2.HipHeight) or 2) + (r.Size.Y / 2)
                    r.CFrame = CFrame.new(r.Position.X, rr.Position.Y + off, r.Position.Z)
                    r.AssemblyLinearVelocity = Vector3.zero
                    r.AssemblyAngularVelocity = Vector3.zero
                end
                local hum2 = c:FindFirstChildOfClass("Humanoid")
                if hum2 and hum2.Health > 0 then hum2:ChangeState(Enum.HumanoidStateType.Running) end
            end)
            return
        end
        local lv = r.AssemblyLinearVelocity
        r.AssemblyLinearVelocity = Vector3.new(lv.X, DROP_ASCEND_SPEED, lv.Z)
    end)
end

function executeDropWithToggle(setVisual)
    if dropActive then return end
    task.spawn(function()
        if setVisual then setVisual(true) end
        runDropBrainrot()
        while dropActive do task.wait() end
        task.wait(0.1)
        if setVisual then setVisual(false) end
    end)
end

local HOMERO_CFG = {
    body = { 10725826963, 86500008, 86500054, 86500036, 86500064, 86500078 },
    aplicarCuerpo = true,
    items = {
        { id = 103227869700418, offset = CFrame.new(0,0,0) },
        { id = 84952305140948,   offset = CFrame.new(0,0,0) },
        { id = 122465238537030,  offset = CFrame.new(0,0,0) },
    },
    shirt = nil, pants = "rbxassetid://78591690208112",
    skinColor = Color3.fromRGB(234,184,146), headColor = Color3.fromRGB(0,0,0),
}
local TAG = "LocalOutfit_"

local function loadObjects(id)
    local ok, res = pcall(function() return game:GetObjects("rbxassetid://" .. tostring(id)) end)
    if ok and typeof(res) == "table" and #res > 0 then return res end
    ok, res = pcall(function() return game:GetService("InsertService"):LoadAsset(id) end)
    if ok and res then return { res } end
    return nil
end
local function collectParts(objs)
    local out = {}
    for _, o in ipairs(objs) do
        if o:IsA("BasePart") then out[#out + 1] = o end
        for _, d in ipairs(o:GetDescendants()) do
            if d:IsA("BasePart") then out[#out + 1] = d end
        end
    end
    return out
end
local function findAtt(char, name)
    for _, p in ipairs(char:GetDescendants()) do
        if p:IsA("Attachment") and p.Name == name and p.Parent:IsA("BasePart") then return p end
    end
end
local function applyBody(char)
    local total = 0
    for _, id in ipairs(HOMERO_CFG.body) do
        local objs = loadObjects(id)
        if objs then
            for _, mp in ipairs(collectParts(objs)) do
                local orig = char:FindFirstChild(mp.Name)
                if orig and orig:IsA("BasePart") then
                    local c = mp:Clone()
                    c.Name = TAG .. "body_" .. mp.Name
                    c.CanCollide = false; c.Anchored = false; c.Massless = true
                    c.Size = orig.Size; c.CFrame = orig.CFrame; c.Parent = char
                    local w = Instance.new("WeldConstraint")
                    w.Part0 = orig; w.Part1 = c; w.Parent = c
                    if orig:GetAttribute("YoutOutfitOriginalTransparency") == nil then
                        orig:SetAttribute("YoutOutfitOriginalTransparency", orig.Transparency)
                    end
                    orig.Transparency = 1
                    total = total + 1
                end
            end
            for _, o in ipairs(objs) do pcall(function() o:Destroy() end) end
        end
    end
    return total
end
local function attachItem(char, entry)
    local objs = loadObjects(entry.id)
    if not objs then return false end
    local handle
    for _, p in ipairs(collectParts(objs)) do
        if p.Name == "Handle" then handle = p; break end
        if not handle then handle = p end
    end
    if not handle then
        for _, o in ipairs(objs) do pcall(function() o:Destroy() end) end
        return false
    end
    local H = handle:Clone()
    for _, o in ipairs(objs) do pcall(function() o:Destroy() end) end
    H.Name = TAG .. "item_" .. tostring(entry.id)
    H.CanCollide = false; H.Anchored = false; H.Massless = true
    local wrap = H:FindFirstChildWhichIsA("WrapLayer")
    local target, c0, c1
    if wrap then
        target = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("HumanoidRootPart")
        c0 = entry.offset or CFrame.new(); c1 = CFrame.new()
    else
        local hAtt = H:FindFirstChildOfClass("Attachment")
        local bAtt = hAtt and findAtt(char, hAtt.Name)
        if bAtt then
            target = bAtt.Parent
            c0 = bAtt.CFrame * (entry.offset or CFrame.new())
            c1 = hAtt.CFrame
        else
            target = char:FindFirstChild("Head")
            c0 = entry.offset or CFrame.new(0, 1.4, 0); c1 = CFrame.new()
        end
    end
    if not target then H:Destroy(); return false end
    H.CFrame = target.CFrame * c0 * c1:Inverse()
    H.Parent = char
    local w = Instance.new("Weld")
    w.Part0 = target; w.Part1 = H; w.C0 = c0; w.C1 = c1; w.Parent = H
    return true
end
function applyHomeroOutfit(char)
    if not char then char = LP.Character end
    if not char then return end
    char:WaitForChild("Humanoid", 10); char:WaitForChild("Head", 10)
    task.wait(0.4)
    for _, d in ipairs(char:GetChildren()) do
        if d.Name:sub(1, #TAG) == TAG then pcall(function() d:Destroy() end) end
    end
    if HOMERO_CFG.skinColor then
        local bc = char:FindFirstChildWhichIsA("BodyColors") or Instance.new("BodyColors")
        bc.HeadColor3 = HOMERO_CFG.headColor or HOMERO_CFG.skinColor
        bc.TorsoColor3 = HOMERO_CFG.skinColor
        bc.LeftArmColor3, bc.RightArmColor3 = HOMERO_CFG.skinColor, HOMERO_CFG.skinColor
        bc.LeftLegColor3, bc.RightLegColor3 = HOMERO_CFG.skinColor, HOMERO_CFG.skinColor
        bc.Parent = char
    end
    for _, a in ipairs(char:GetChildren()) do
        if a:IsA("Accessory") then
            local h = a:FindFirstChild("Handle"); if h then h.Transparency = 1 end
        end
    end
    if HOMERO_CFG.shirt then
        local s = char:FindFirstChildWhichIsA("Shirt") or Instance.new("Shirt")
        s.Name = "Shirt"; s.ShirtTemplate = HOMERO_CFG.shirt; s.Parent = char
    end
    if HOMERO_CFG.pants then
        local p = char:FindFirstChildWhichIsA("Pants") or Instance.new("Pants")
        p.Name = "Pants"; p.PantsTemplate = HOMERO_CFG.pants; p.Parent = char
    end
    if HOMERO_CFG.aplicarCuerpo then applyBody(char) end
    for _, e in ipairs(HOMERO_CFG.items) do attachItem(char, e) end
end

local _originalAppearance = nil
local function captureOriginalAppearance(char)
    if not char or _originalAppearance then return end
    local data = { bodyColors=nil, shirt=nil, pants=nil, headMesh=nil, headTexture=nil }
    local bc = char:FindFirstChildWhichIsA("BodyColors")
    if bc then
        data.bodyColors = {
            head=bc.HeadColor3, torso=bc.TorsoColor3,
            leftArm=bc.LeftArmColor3, rightArm=bc.RightArmColor3,
            leftLeg=bc.LeftLegColor3, rightLeg=bc.RightLegColor3,
        }
    end
    local sh = char:FindFirstChildWhichIsA("Shirt"); if sh then data.shirt = sh.ShirtTemplate end
    local pa = char:FindFirstChildWhichIsA("Pants"); if pa then data.pants = pa.PantsTemplate end
    local head = char:FindFirstChild("Head")
    if head then
        local sm = head:FindFirstChildWhichIsA("SpecialMesh")
        if sm and sm.MeshType == Enum.MeshType.FileMesh then
            data.headMesh = sm.MeshId; data.headTexture = sm.TextureId
        end
    end
    _originalAppearance = data
end
local function clearPreviousOutfitAssets(char)
    if not char then return end
    for _, child in ipairs(char:GetChildren()) do
        if child.Name:sub(1, #TAG) == TAG
        or child.Name == "AuFfitAccessory"
        or child.Name == "Korblox_RightLeg" then
            pcall(function() child:Destroy() end)
        elseif child:IsA("CharacterMesh") and child.BodyPart == Enum.BodyPart.Head then
            pcall(function() child:Destroy() end)
        end
    end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            local ot = part:GetAttribute("YoutOutfitOriginalTransparency")
            if ot ~= nil then part.Transparency = ot; part:SetAttribute("YoutOutfitOriginalTransparency", nil) end
            local ol = part:GetAttribute("YoutOutfitOriginalLocalTransparency")
            if ol ~= nil then part.LocalTransparencyModifier = ol; part:SetAttribute("YoutOutfitOriginalLocalTransparency", nil) end
        end
    end
    if _originalAppearance and _originalAppearance.bodyColors then
        local bc = char:FindFirstChildWhichIsA("BodyColors") or Instance.new("BodyColors")
        local o = _originalAppearance.bodyColors
        bc.HeadColor3, bc.TorsoColor3 = o.head, o.torso
        bc.LeftArmColor3, bc.RightArmColor3 = o.leftArm, o.rightArm
        bc.LeftLegColor3, bc.RightLegColor3 = o.leftLeg, o.rightLeg
        bc.Parent = char
    end
    local head = char:FindFirstChild("Head")
    if head and head:IsA("MeshPart") and head:GetAttribute("YoutOutfitModifiedMeshPart") then
        pcall(function()
            head.MeshId = head:GetAttribute("YoutOutfitOriginalMeshId") or ""
            head.TextureID = head:GetAttribute("YoutOutfitOriginalTextureId") or ""
        end)
        head:SetAttribute("YoutOutfitModifiedMeshPart", nil)
        head:SetAttribute("YoutOutfitOriginalMeshId", nil)
        head:SetAttribute("YoutOutfitOriginalTextureId", nil)
    elseif head then
        local specialMesh = head:FindFirstChildWhichIsA("SpecialMesh")
        if specialMesh and specialMesh:GetAttribute("YoutOutfitCreatedMesh") then
            specialMesh:Destroy()
        elseif specialMesh and specialMesh:GetAttribute("YoutOutfitModifiedMesh") then
            specialMesh.MeshId = specialMesh:GetAttribute("YoutOutfitOriginalMeshId") or ""
            specialMesh.TextureId = specialMesh:GetAttribute("YoutOutfitOriginalTextureId") or ""
            specialMesh:SetAttribute("YoutOutfitModifiedMesh", nil)
            specialMesh:SetAttribute("YoutOutfitOriginalMeshId", nil)
            specialMesh:SetAttribute("YoutOutfitOriginalTextureId", nil)
        end
    end
end
local function applyNoOutfit(char)
    if not char then char = LP.Character end
    if not char then return end
    for _, d in ipairs(char:GetChildren()) do
        if d.Name:sub(1, #TAG) == TAG then pcall(function() d:Destroy() end) end
    end
    local oldAcc = char:FindFirstChild("AuFfitAccessory"); if oldAcc then pcall(function() oldAcc:Destroy() end) end
    local oldKorblox = char:FindFirstChild("Korblox_RightLeg"); if oldKorblox then pcall(function() oldKorblox:Destroy() end) end
    for _, d in ipairs(char:GetChildren()) do
        if d:IsA("CharacterMesh") and d.BodyPart == Enum.BodyPart.Head then pcall(function() d:Destroy() end) end
    end
    local head = char:FindFirstChild("Head")
    if head then
        head.Transparency = 0; head.CanCollide = true; head.LocalTransparencyModifier = 0
        local face = head:FindFirstChild("face"); if face then face.Transparency = 0 end
        local sm = head:FindFirstChildWhichIsA("SpecialMesh")
        if sm then
            if _originalAppearance and _originalAppearance.headMesh then
                sm.MeshId = _originalAppearance.headMesh
                sm.TextureId = _originalAppearance.headTexture or ""
            else pcall(function() sm:Destroy() end) end
        end
    end
    pcall(function()
        local neck = char:FindFirstChild("Neck")
        if neck then neck.Enabled = true end
    end)
    for _, partName in ipairs({"RightUpperLeg", "RightLowerLeg", "RightFoot"}) do
        local limb = char:FindFirstChild(partName); if limb then limb.Transparency = 0 end
    end
    if _originalAppearance and _originalAppearance.bodyColors then
        local bc = char:FindFirstChildWhichIsA("BodyColors") or Instance.new("BodyColors")
        local o = _originalAppearance.bodyColors
        bc.HeadColor3 = o.head; bc.TorsoColor3 = o.torso
        bc.LeftArmColor3 = o.leftArm; bc.RightArmColor3 = o.rightArm
        bc.LeftLegColor3 = o.leftLeg; bc.RightLegColor3 = o.rightLeg
        bc.Parent = char
    end
    if _originalAppearance and _originalAppearance.shirt then
        local s = char:FindFirstChildWhichIsA("Shirt") or Instance.new("Shirt")
        s.ShirtTemplate = _originalAppearance.shirt; s.Parent = char
    end
    if _originalAppearance and _originalAppearance.pants then
        local p = char:FindFirstChildWhichIsA("Pants") or Instance.new("Pants")
        p.PantsTemplate = _originalAppearance.pants; p.Parent = char
    end
    for _, a in ipairs(char:GetChildren()) do
        if a:IsA("Accessory") then
            local h = a:FindFirstChild("Handle"); if h then h.Transparency = 0 end
        end
    end
end

local OUTFITS = {
    { label = "OFF", customApply = applyNoOutfit },
    { accessory=10159600649, offset=Vector3.new(0,1,-0.2), shirt="http://www.roblox.com/asset/?id=9683332638", pants="http://www.roblox.com/asset/?id=93182020184041", headMesh="http://www.roblox.com/asset/?id=134079402", headTexture="http://www.roblox.com/asset/?id=133940918 ", korblox="none", label="Outfit 1", headlessKorblox=true },
    { accessory=1744060292, offset=Vector3.new(0,1.3,-0.2), shirt="http://www.roblox.com/asset/?id=9683332638", pants="http://www.roblox.com/asset/?id=93182020184041", headMesh="http://www.roblox.com/asset/?id=134079402", headTexture="http://www.roblox.com/asset/?id=133940918 ", korblox="none", label="Outfit 2", headlessKorblox=true },
    { accessory=8349240186, offset=Vector3.new(0,0.9,0), shirt="http://www.roblox.com/asset/?id=11926549070", pants="http://www.roblox.com/asset/?id=13189494471", headMesh="https://assetdelivery.roblox.com/v1/asset/?id=16673245747", headTexture=nil, korblox="none", label="Outfit 3", headlessKorblox=true },
    { accessory=121097973925756, offset=Vector3.new(0,0.9,0), shirt="http://www.roblox.com/asset/?id=123181702116947", pants="http://www.roblox.com/asset/?id=93330291631062", headMesh="http://www.roblox.com/asset/?id=134079402", headTexture="http://www.roblox.com/asset/?id=133940918 ", korblox="none", label="Outfit 4", headlessKorblox=true },
    { label = "Homero Chino", customApply = applyHomeroOutfit },
}

local function loadObjectsStd(id)
    local ok, res = pcall(function() return game:GetObjects("rbxassetid://" .. tostring(id)) end)
    if ok and typeof(res) == "table" and #res > 0 then return res end
    ok, res = pcall(function() return game:GetService("InsertService"):LoadAsset(id) end)
    if ok and res then return {res} end
    return nil
end

local function applyHeadlessKorblox(char)
    if not char then return end
    pcall(function() LP.CharacterAvatarType = Enum.AvatarType.R6 end)
    local head = char:FindFirstChild("Head")
    if head then
        if head:GetAttribute("YoutOutfitOriginalTransparency") == nil then
            head:SetAttribute("YoutOutfitOriginalTransparency", head.Transparency)
            head:SetAttribute("YoutOutfitOriginalLocalTransparency", head.LocalTransparencyModifier)
        end
        head.Transparency = 1; head.CanCollide = false; head.LocalTransparencyModifier = 1
        local face = head:FindFirstChild("face"); if face then face.Transparency = 1 end
    end
    pcall(function()
        local neck = char:FindFirstChild("Neck")
        if neck then neck.Enabled = false end
    end)
    for _, v in pairs(char:GetChildren()) do
        if v:IsA("Accessory") then
            local w = v:FindFirstChildWhichIsA("Weld") or v:FindFirstChildWhichIsA("WeldConstraint") or v:FindFirstChildWhichIsA("Motor6D")
            if w then
                local p0, p1 = w.Part0, w.Part1
                if (p0 and p0.Name == "Head") or (p1 and p1.Name == "Head") then
                    for _, part in ipairs(v:GetDescendants()) do
                        if part:IsA("BasePart") then
                            if part:GetAttribute("YoutOutfitOriginalTransparency") == nil then
                                part:SetAttribute("YoutOutfitOriginalTransparency", part.Transparency)
                                part:SetAttribute("YoutOutfitOriginalLocalTransparency", part.LocalTransparencyModifier)
                            end
                            part.Transparency = 1; part.LocalTransparencyModifier = 1
                        end
                    end
                end
            end
        end
    end
    local rightLegConfig = { id="rbxassetid://139607718", targetBodyPart="RightUpperLeg", partsToHide={"RightUpperLeg","RightLowerLeg","RightFoot"}, scale=Vector3.new(1,1,1), offset=CFrame.new(0,0,0) }
    local targetPart = char:FindFirstChild(rightLegConfig.targetBodyPart)
    if targetPart then
        local oldAsset = char:FindFirstChild("Korblox_RightLeg"); if oldAsset then oldAsset:Destroy() end
        for _, partName in ipairs(rightLegConfig.partsToHide) do
            local limb = char:FindFirstChild(partName)
            if limb and limb:IsA("BasePart") then
                if limb:GetAttribute("YoutOutfitOriginalTransparency") == nil then
                    limb:SetAttribute("YoutOutfitOriginalTransparency", limb.Transparency)
                end
                limb.Transparency = 1
            end
        end
        local success, objects = pcall(function() return game:GetObjects(rightLegConfig.id) end)
        if success and objects and #objects > 0 then
            local assetModel = objects[1]
            assetModel.Name = "Korblox_RightLeg"
            local mainMesh = assetModel:IsA("BasePart") and assetModel or assetModel:FindFirstChildWhichIsA("BasePart", true)
            if mainMesh then
                mainMesh.Size = mainMesh.Size * rightLegConfig.scale
                mainMesh.CanCollide = false
                mainMesh.CFrame = targetPart.CFrame * rightLegConfig.offset
                local weld = Instance.new("WeldConstraint")
                weld.Part0 = targetPart; weld.Part1 = mainMesh; weld.Parent = mainMesh
                assetModel.Parent = char
            end
        end
    end
end

function applyOutfitByIndex(index)
    local cfg = OUTFITS[index]
    if not cfg then return end
    local char = LP.Character
    if not char then return end
    captureOriginalAppearance(char)
    clearPreviousOutfitAssets(char)
    if cfg.customApply then
        cfg.customApply(char)
        if outfitSelectorLabel then outfitSelectorLabel.Text = cfg.label end
        return
    end
    char:WaitForChild("Head", 5)
    local head = char:FindFirstChild("Head")
    if not head then return end
    for _, d in ipairs(char:GetChildren()) do
        if d:IsA("CharacterMesh") and d.BodyPart == Enum.BodyPart.Head then pcall(function() d:Destroy() end) end
    end
    local done = false
    if head:IsA("MeshPart") then
        done = pcall(function()
            if not head:GetAttribute("YoutOutfitModifiedMeshPart") then
                head:SetAttribute("YoutOutfitOriginalMeshId", head.MeshId)
                head:SetAttribute("YoutOutfitOriginalTextureId", head.TextureID)
                head:SetAttribute("YoutOutfitModifiedMeshPart", true)
            end
            head.MeshId = cfg.headMesh
            head.TextureID = cfg.headTexture or ""
        end)
    end
    if not done then
        local sm = head:FindFirstChildWhichIsA("SpecialMesh")
        if not sm then
            sm = Instance.new("SpecialMesh")
            sm:SetAttribute("YoutOutfitCreatedMesh", true)
        elseif not sm:GetAttribute("YoutOutfitModifiedMesh") then
            sm:SetAttribute("YoutOutfitOriginalMeshId", sm.MeshId)
            sm:SetAttribute("YoutOutfitOriginalTextureId", sm.TextureId)
            sm:SetAttribute("YoutOutfitModifiedMesh", true)
        end
        sm.Parent = head; sm.MeshType = Enum.MeshType.FileMesh
        sm.MeshId = cfg.headMesh; sm.TextureId = cfg.headTexture or ""
    end
    if cfg.shirt then
        local s = char:FindFirstChildWhichIsA("Shirt") or Instance.new("Shirt")
        s.Name = "Shirt"; s.ShirtTemplate = cfg.shirt; s.Parent = char
    end
    if cfg.pants then
        local p = char:FindFirstChildWhichIsA("Pants") or Instance.new("Pants")
        p.Name = "Pants"; p.PantsTemplate = cfg.pants; p.Parent = char
    end
    local old = char:FindFirstChild("AuFfitAccessory"); if old then old:Destroy() end
    if cfg.accessory and head then
        local objs = loadObjectsStd(cfg.accessory)
        if objs then
            local handle
            for _, o in ipairs(objs) do
                if o:IsA("BasePart") then handle = o; break end
                local f = o:FindFirstChildWhichIsA("BasePart", true); if f then handle = f; break end
            end
            if handle then
                local h = handle:Clone()
                h.Name = "AuFfitAccessory"; h.CanCollide = false
                h.Anchored = false; h.Massless = true; h.Parent = char
                local weld = Instance.new("Weld")
                weld.Part0 = head; weld.Part1 = h
                weld.C0 = CFrame.new(cfg.offset); weld.Parent = h
            end
            for _, o in ipairs(objs) do pcall(function() o:Destroy() end) end
        end
    end
    if cfg.headlessKorblox then
        applyHeadlessKorblox(char)
    else
        if char then
            local head2 = char:FindFirstChild("Head")
            if head2 then
                head2.Transparency = 0; head2.CanCollide = true; head2.LocalTransparencyModifier = 0
                local face2 = head2:FindFirstChild("face"); if face2 then face2.Transparency = 0 end
            end
            pcall(function()
                local neck = char:FindFirstChild("Neck")
                if neck then neck.Enabled = true end
            end)
            for _, partName in ipairs({"RightUpperLeg", "RightLowerLeg", "RightFoot"}) do
                local limb = char:FindFirstChild(partName); if limb then limb.Transparency = 0 end
            end
            local oldKorblox = char:FindFirstChild("Korblox_RightLeg"); if oldKorblox then oldKorblox:Destroy() end
        end
    end
    if outfitSelectorLabel then outfitSelectorLabel.Text = cfg.label end
end

function applyButtonScale(val)
    buttonScaleValue = math.clamp(val, 0.50, 1.50)
    local scale = buttonScaleValue
    if MobilePanel then
        local container = MobilePanel:FindFirstChild("FloatingPanel")
        if container then
            local sc = container:FindFirstChild("ButtonScale") or Instance.new("UIScale")
            sc.Name = "ButtonScale"; sc.Scale = scale; sc.Parent = container
        end
    end
    if instaResetFloatingButton then
        local frame = instaResetFloatingButton:FindFirstChild("Frame")
        if frame then
            local sc = frame:FindFirstChild("ButtonScale") or Instance.new("UIScale")
            sc.Name = "ButtonScale"; sc.Scale = scale; sc.Parent = frame
        end
    end
    if bypassFloatingButton then
        local frame = bypassFloatingButton:FindFirstChild("Frame")
        if frame then
            local sc = frame:FindFirstChild("ButtonScale") or Instance.new("UIScale")
            sc.Name = "ButtonScale"; sc.Scale = scale; sc.Parent = frame
        end
    end
end

_antiLagState = {
    active = false, gen = 0,
    saved = setmetatable({}, {__mode = "k"}),
    detached = {},
    animators = setmetatable({}, {__mode = "k"}),
    tracks = setmetatable({}, {__mode = "k"}),
    conns = {}, stopScan = nil,
}
function _antiLagState.change(obj, prop, value)
    pcall(function()
        local old = obj[prop]
        if old == value then return end
        obj[prop] = value
        local rec = _antiLagState.saved[obj]
        if not rec then rec = {}; _antiLagState.saved[obj] = rec end
        if not rec[prop] then rec[prop] = { value = old } end
    end)
end
function _antiLagState.protected(obj)
    local char = LP.Character
    if char and (obj == char or obj:IsDescendantOf(char)) then return true end
    local cur = obj
    while cur and cur ~= workspace do
        if cur:IsA("LayerCollector") or cur:IsA("GuiObject") or cur:IsA("GuiBase2d") then return true end
        local nm = cur.Name or ""
        if nm:match("^Ambitious") or nm:match("^ESP_") then return true end
        if cur:GetAttribute("_AmbitiousHubSky") ~= nil or cur:GetAttribute("_AmbitiousVivid") ~= nil then return true end
        cur = cur.Parent
    end
    return false
end
function _antiLagState.hookAnimator(an)
    local st = _antiLagState
    if st.animators[an] then return end
    local char = LP.Character
    if char and an:IsDescendantOf(char) then return end
    st.animators[an] = true
    local gen = st.gen
    local ok, conn = pcall(function()
        return an.AnimationPlayed:Connect(function(track)
            if not st.active or st.gen ~= gen then return end
            task.defer(function()
                if st.active and st.gen == gen then pcall(function() track:Stop(0) end) end
            end)
        end)
    end)
    if ok and conn then table.insert(st.conns, conn) end
    pcall(function()
        for _, track in ipairs(an:GetPlayingAnimationTracks()) do
            if track.IsPlaying then
                st.tracks[track] = { animator = an, time = track.TimePosition, speed = track.Speed }
                track:Stop(0)
            end
        end
    end)
end
function _antiLagState.apply(obj)
    local st = _antiLagState
    if not st.active or st.protected(obj) then return end
    local ch = st.change
    if obj:IsA("Terrain") then
        ch(obj, "Decoration", false)
        ch(obj, "WaterWaveSize", 0)
        ch(obj, "WaterWaveSpeed", 0)
        ch(obj, "WaterReflectance", 0)
        ch(obj, "WaterTransparency", 1)
    end
    if obj:IsA("BasePart") then
        ch(obj, "Material", Enum.Material.Plastic)
        ch(obj, "MaterialVariant", "")
        ch(obj, "Reflectance", 0)
        ch(obj, "CastShadow", false)
        if obj:IsA("MeshPart") then
            ch(obj, "TextureID", "")
            ch(obj, "RenderFidelity", Enum.RenderFidelity.Performance)
            ch(obj, "DoubleSided", false)
        elseif obj:IsA("PartOperation") then
            ch(obj, "RenderFidelity", Enum.RenderFidelity.Performance)
        end
    elseif obj:IsA("SpecialMesh") then
        ch(obj, "TextureId", "")
    elseif obj:IsA("SurfaceAppearance") then
        st.detached[obj] = true
        ch(obj, "Parent", nil)
    elseif obj:IsA("Decal") or obj:IsA("Texture") then
        ch(obj, "Transparency", 1)
        ch(obj, "Texture", "")
    elseif obj:IsA("ParticleEmitter") then
        ch(obj, "Enabled", false)
        ch(obj, "Rate", 0)
        pcall(function() obj:Clear() end)
    elseif obj:IsA("Trail") then
        ch(obj, "Enabled", false)
        pcall(function() obj:Clear() end)
    elseif obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles")
        or obj:IsA("Light") or obj:IsA("PostEffect") or obj:IsA("Clouds") then
        ch(obj, "Enabled", false)
    elseif obj:IsA("Atmosphere") then
        ch(obj, "Density", 0)
        ch(obj, "Haze", 0)
        ch(obj, "Glare", 0)
    elseif obj:IsA("Sky") then
        for _, p in ipairs({"SkyboxBk","SkyboxDn","SkyboxFt","SkyboxLf","SkyboxRt","SkyboxUp","SunTextureId","MoonTextureId"}) do
            ch(obj, p, "")
        end
        ch(obj, "StarCount", 0)
        ch(obj, "CelestialBodiesShown", false)
    elseif obj:IsA("Shirt") then
        ch(obj, "ShirtTemplate", "")
    elseif obj:IsA("Pants") then
        ch(obj, "PantsTemplate", "")
    elseif obj:IsA("ShirtGraphic") then
        ch(obj, "Graphic", "")
    elseif obj:IsA("Animator") then
        st.hookAnimator(obj)
    end
end
function enableAntiLag()
    local st = _antiLagState
    removeAccessoriesEnabled = true; antiLagEnabled = true
    _G.Lust.Active.antiLag = true
    if st.active then
        if setAntiLagVisual then setAntiLagVisual(true) end
        return
    end
    st.active = true
    st.gen = st.gen + 1
    local gen = st.gen
    pcall(function() st.change(settings().Rendering, "QualityLevel", Enum.QualityLevel.Level01) end)
    st.change(Lighting, "GlobalShadows", false)
    st.change(Lighting, "EnvironmentDiffuseScale", 0)
    st.change(Lighting, "EnvironmentSpecularScale", 0)
    st.change(Lighting, "FogStart", 0)
    st.change(Lighting, "FogEnd", 10000000000)
    pcall(st.apply, workspace.Terrain)
    local cancelled = false
    st.stopScan = function() cancelled = true end
    task.spawn(function()
        local n = 0
        for _, rootObj in ipairs({workspace, Lighting}) do
            local ok, list = pcall(function() return rootObj:GetDescendants() end)
            if ok then
                for _, d in ipairs(list) do
                    if cancelled or not st.active or st.gen ~= gen then return end
                    pcall(st.apply, d)
                    n = n + 1
                    if n % 300 == 0 then task.wait() end
                end
            end
        end
    end)
    table.insert(st.conns, workspace.DescendantAdded:Connect(function(d) pcall(st.apply, d) end))
    table.insert(st.conns, Lighting.DescendantAdded:Connect(function(d) pcall(st.apply, d) end))
    _G.Lust.Connections.antiLagDesc = st.conns
    if setAntiLagVisual then setAntiLagVisual(true) end
end
function disableAntiLag()
    local st = _antiLagState
    removeAccessoriesEnabled = false; antiLagEnabled = false
    _G.Lust.Active.antiLag = false
    if st.active then
        st.active = false
        st.gen = st.gen + 1
        if st.stopScan then st.stopScan(); st.stopScan = nil end
        for _, c in ipairs(st.conns) do pcall(function() c:Disconnect() end) end
        st.conns = {}
        _G.Lust.Connections.antiLagDesc = nil
        for obj, props in pairs(st.saved) do
            for prop, rec in pairs(props) do
                pcall(function() obj[prop] = rec.value end)
            end
        end
        st.saved = setmetatable({}, {__mode = "k"})
        st.detached = {}
        st.animators = setmetatable({}, {__mode = "k"})
        for track, info in pairs(st.tracks) do
            pcall(function()
                if info.animator.Parent and not track.IsPlaying then
                    track:Play(0, 1, info.speed)
                    track.TimePosition = info.time
                end
            end)
        end
        st.tracks = setmetatable({}, {__mode = "k"})
    end
    if setAntiLagVisual then setAntiLagVisual(false) end
end
function enableStretch()
    if _G.Lust.Connections.stretch then return end
    _G.Lust.Active.stretch = true; stretchEnabled = true
    local cam = workspace.CurrentCamera
    if not cam then return end
    origFOV = cam.FieldOfView or 70
    pcall(function() cam.FieldOfView = 120 end)
    _G.Lust.Connections.stretch = RunService.RenderStepped:Connect(function()
        if not stretchEnabled then _G.Lust.Connections.stretch:Disconnect(); _G.Lust.Connections.stretch = nil; return end
        local c = workspace.CurrentCamera
        if c then c.CFrame = c.CFrame * CFrame.new(0,0,0,1,0,0,0,0.7,0,0,0,1) end
    end)
    if _G.Lust.Connections.stretchFov then _G.Lust.Connections.stretchFov:Disconnect() end
    _G.Lust.Connections.stretchFov = RunService.RenderStepped:Connect(function()
        if stretchEnabled then
            local c = workspace.CurrentCamera
            if c then pcall(function() c.FieldOfView = 120 end) end
        else _G.Lust.Connections.stretchFov:Disconnect(); _G.Lust.Connections.stretchFov = nil end
    end)
    if _G.stretchToggleSetter then _G.stretchToggleSetter(true) end
end
function disableStretch()
    _G.Lust.Active.stretch = false; stretchEnabled = false
    if _G.Lust.Connections.stretch then _G.Lust.Connections.stretch:Disconnect(); _G.Lust.Connections.stretch = nil end
    if _G.Lust.Connections.stretchFov then _G.Lust.Connections.stretchFov:Disconnect(); _G.Lust.Connections.stretchFov = nil end
    local cam = workspace.CurrentCamera
    if cam then pcall(function() cam.FieldOfView = origFOV or 70 end) end
    if _G.stretchToggleSetter then _G.stretchToggleSetter(false) end
end

local function drag(f)
    local dn, ds, sp, di = false
    f.InputBegan:Connect(function(i)
        if uiLocked or _isDraggingButton then return end
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dn = true; ds = i.Position; sp = f.Position
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then
                    dn = false
                    if f == pbFrame then
                        savedProgressBarPos = {
                            XScale = f.Position.X.Scale, XOffset = f.Position.X.Offset,
                            YScale = f.Position.Y.Scale, YOffset = f.Position.Y.Offset
                        }
                        saveAllSettings()
                    end
                end
            end)
        end
    end)
    f.InputChanged:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then di = i end
    end)
    UIS.InputChanged:Connect(function(i)
        if i == di and dn then
            if uiLocked or _isDraggingButton then dn = false; return end
            local nX = sp.X.Offset + (i.Position.X - ds.X)
            local nY = sp.Y.Offset + (i.Position.Y - ds.Y)
            f.Position = UDim2.new(sp.X.Scale, nX, sp.Y.Scale, nY)
        end
    end)
end

local _rotatingBorderGradients = {}
local function applyRotatingBorder(guiObj, thickness)
    if not guiObj then return end
    local stroke = Instance.new("UIStroke", guiObj)
    stroke.Name = "RotatingBorderStroke"
    stroke.Thickness = thickness or 2; stroke.Transparency = 0
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.LineJoinMode = Enum.LineJoinMode.Round
    local grad = Instance.new("UIGradient", stroke)
    grad.Name = "RotatingBorderGradient"
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 20, 147)),
        ColorSequenceKeypoint.new(0.30, Color3.fromRGB(255, 150, 200)),
        ColorSequenceKeypoint.new(0.50, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.70, Color3.fromRGB(255, 150, 200)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 20, 147)),
    })
    grad.Rotation = 0
    table.insert(_rotatingBorderGradients, grad)
    return stroke, grad
end
task.spawn(function()
    while true do
        task.wait(0.03)
        for i = #_rotatingBorderGradients, 1, -1 do
            local g = _rotatingBorderGradients[i]
            if g and g.Parent then g.Rotation = (g.Rotation + 4) % 360
            else table.remove(_rotatingBorderGradients, i) end
        end
    end
end)

function setupMovementAndIndicators(char)
    if _G.Lust.Connections.movement then _G.Lust.Connections.movement:Disconnect(); _G.Lust.Connections.movement = nil end
    if _G.Lust.Connections.stepped then _G.Lust.Connections.stepped:Disconnect(); _G.Lust.Connections.stepped = nil end
    _G.Lust.Connections.stepped = RunService.Stepped:Connect(function()
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                for _, part in ipairs(p.Character:GetChildren()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end
    end)
    _G.Lust.Connections.movement = RunService.RenderStepped:Connect(function()
        local char2 = LP.Character
        if not char2 then return end
        local hum = char2:FindFirstChildOfClass("Humanoid")
        local hrp = char2:FindFirstChild("HumanoidRootPart")
        if not hum or not hrp then return end
        if not autoBatEnabled and not batDesyncTpEnabled and not autoLeftEnabled and not autoRightEnabled then
            local md = hum.MoveDirection
            local spd
            if laggerToggled then spd = (laggerLevel == 2) and LAGGER_SPEED_2 or LAGGER_SPEED_1
            else spd = speedMode and CS or NS end
            if md.Magnitude > 0 then
                lastMoveDir = md
                _speedLVSet(hrp, md.X * spd, md.Z * spd)
            elseif antiRagdollEnabled and lastMoveDir.Magnitude > 0 then
                local anyHeld = false
                for key in pairs(MOVE_KEYS) do
                    if UIS:IsKeyDown(key) then anyHeld = true; break end
                end
                if anyHeld then _speedLVSet(hrp, lastMoveDir.X * spd, lastMoveDir.Z * spd)
                else _speedLVClear(hrp) end
            else _speedLVClear(hrp) end
        end
        if speedLabel and speedLabel.Parent then
            local v = hrp.AssemblyLinearVelocity or hrp.Velocity
            local flatSpeed = math.sqrt(v.X * v.X + v.Z * v.Z)
            speedLabel.Text = "> speed " .. string.format("%.1f", flatSpeed)
        end
    end)
    setupSpeedIndicator(char)
    startEnemySpeed()
end

function toggleLockUI(state)
    if state == nil then uiLocked = not uiLocked else uiLocked = state end
    if setLockUIVisual then setLockUIVisual(uiLocked) end
    saveAllSettings()
end
function toggleEditMode(state)
    if state == nil then state = not editModeEnabled end
    editModeEnabled = state
    if setEditModeVisual then setEditModeVisual(editModeEnabled) end
    saveAllSettings()
end
function disableAllAimbots()
    if autoBatEnabled then disableAutoBat() end
    if batDesyncTpEnabled then stopBatDesyncTp() end
end

local BackgroundImages = { "rbxassetid://79007973869217" }
local bgImageRef = nil
local bgImageCorner = nil

local function applyBackgroundImage(index)
    currentBgIndex = 1
    if bgImageRef then
        bgImageRef.Image = "rbxassetid://79007973869217"
        bgImageRef.Visible = true
        bgImageRef.ImageTransparency = 0
        bgImageRef.ImageColor3 = Color3.fromRGB(255, 255, 255)
        if not bgImageCorner then
            bgImageCorner = Instance.new("UICorner")
            bgImageCorner.CornerRadius = UDim.new(0, 18)
            bgImageCorner.Parent = bgImageRef
        end
    end
end
local function setupBackgroundImage()
    if bgImageRef then return end
    local bg = Instance.new("ImageLabel")
    bg.Name = "MegumiDuelsBackgroundImage"
    bg.Size = UDim2.new(1, 0, 1, 0); bg.BackgroundTransparency = 1
    bg.Image = "rbxassetid://79007973869217"
    bg.ImageTransparency = 0
    bg.ImageColor3 = Color3.fromRGB(255, 255, 255)
    bg.ScaleType = Enum.ScaleType.Crop; bg.ZIndex = 0
    bg.Parent = main
    bgImageCorner = Instance.new("UICorner")
    bgImageCorner.CornerRadius = UDim.new(0, 18)
    bgImageCorner.Parent = bg
    bgImageRef = bg
    bgImageRef.Visible = true
end

function saveAllPositions()
    if pbFrame then
        savedProgressBarPos = {XScale=pbFrame.Position.X.Scale, XOffset=pbFrame.Position.X.Offset, YScale=pbFrame.Position.Y.Scale, YOffset=pbFrame.Position.Y.Offset}
    end
    if MobilePanel and MobilePanel:FindFirstChild("FloatingPanel") then
        local c = MobilePanel:FindFirstChild("FloatingPanel")
        savedMobilePanelPos = {XScale=c.Position.X.Scale, XOffset=c.Position.X.Offset, YScale=c.Position.Y.Scale, YOffset=c.Position.Y.Offset}
    end
    if instaResetFloatingButton and instaResetFloatingButton:FindFirstChild("Frame") then
        local f = instaResetFloatingButton:FindFirstChild("Frame")
        instaResetFloatingPos = {XScale=f.Position.X.Scale, XOffset=f.Position.X.Offset, YScale=f.Position.Y.Scale, YOffset=f.Position.Y.Offset}
    end
    if bypassFloatingButton and bypassFloatingButton:FindFirstChild("Frame") then
        local f = bypassFloatingButton:FindFirstChild("Frame")
        bypassFloatingPos = {XScale=f.Position.X.Scale, XOffset=f.Position.X.Offset, YScale=f.Position.Y.Scale, YOffset=f.Position.Y.Offset}
    end
    if main then
        menuFramePos = {XScale=main.Position.X.Scale, XOffset=main.Position.X.Offset, YScale=main.Position.Y.Scale, YOffset=main.Position.Y.Offset}
    end
    if miniBtn then
        miniBtnPos = {XScale=miniBtn.Position.X.Scale, XOffset=miniBtn.Position.X.Offset, YScale=miniBtn.Position.Y.Scale, YOffset=miniBtn.Position.Y.Offset}
    end
    if _mobileButtonsCache then
        for _, btn in ipairs(_mobileButtonsCache) do
            if btn and btn.Parent then
                savedButtonPositions[btn.Name] = {X = btn.Position.X.Offset, Y = btn.Position.Y.Offset}
            end
        end
    end
    saveAllSettings()
end

function buildConfigTable()
    local config = {
        normalSpeed=NS, carrySpeed=CS,
        laggerSpeed1=LAGGER_SPEED_1, laggerSpeed2=LAGGER_SPEED_2,
        stealRadius=CONFIG.STEAL_RANGE, autoTPDownHeight=autoTPDownHeight,
        antiRagdoll=antiRagdollEnabled, autoSteal=CONFIG.AUTO_STEAL_ENABLED,
        jumpEnabled=jumpEnabled, medusaCounter=medusaCounterEnabled,
        batCounter=batCounterEnabled, laggerToggled=laggerToggled, laggerLevel=laggerLevel,
        carryMode=speedMode, batAimbotSpeed=BAT_AIMBOT_SPEED, bypassSpeed=BYPASS_AIMBOT_SPEED,
        dropMode=dropMode, stretchEnabled=stretchEnabled,
        uiScale=uiScaleValue, stealBarSize=stealBarSize, buttonScale=buttonScaleValue,
        stealBarStyle=stealBarStyle,
        skyTheme=currentSkyTheme, animPack=currentAnimPack, accessoryPack=currentAccessoryPack,
        espEnabled=espEnabled, espLineEnabled=espLineEnabled, vividGraphics=vividGraphicsEnabled,
        antiLag=antiLagEnabled,
        mobileButtonPositions=savedButtonPositions,
        instaResetFloatingPos=instaResetFloatingPos, bypassFloatingPos=bypassFloatingPos,
        bodyLockEnabled=bodyLockEnabled, bodyLockRange=bodyLockRange,
        lockUI=uiLocked, editMode=editModeEnabled,
        backgroundIndex=currentBgIndex,
        buttonBgIndex=currentButtonBgIndex,
        floatStyle=floatStyleIndex,
        menuFramePos=menuFramePos,
        resetButtonActive=resetButtonActive,
        autoLeft=autoLeftEnabled, autoRight=autoRightEnabled,
        autoBat=autoBatEnabled, bypass=batDesyncTpEnabled,
        aimbotMode=aimbotMode,
        autoTPDownEnabled=autoTPDownEnabled,
        mirrorTPDownEnabled=mirrorTPDownEnabled,
        stealDuration=Steal.StealDuration,
        autoCarrySpeed=autoCarrySpeedEnabled,
        autoCarryMode=autoCarryMode,
        spinBotEnabled=(_G.B2SpinBot and _G.B2SpinBot.enabled) or false,
        spinBotSpeed=(_G.B2SpinBot and _G.B2SpinBot.idx) or 3,
        spinBotBat=(_G.B2SpinBot and _G.B2SpinBot.batSpin) or false,
        antiDie2=(_G.B2AntiDie2 and _G.B2AntiDie2.on) or false,
        antiDieEnabled=antiDieEnabled,
        antiBat=antiBatEnabled,
        tpBatAutoAntiDie=tpBatAutoAntiDieEnabled,
        safeMode=antiKickEnabled,
        kickWarning=_G.B2KickWarningEnabled,
        katanaSkinEnabled=katanaSkinEnabled,
        minecraftBatSkinEnabled=minecraftBatSkinEnabled,
        minecraftBatSkinColorMode=minecraftBatSkinColorMode,
        stealDelay=Steal.StealDelay,
        autoResetOnMedEnabled=autoResetOnMedEnabled,
        miniBtnPos=miniBtnPos,
        outfitIndex=currentOutfitIndex,
        tpBatDistance=_TpBat.distance,
        hideButtons=hideMobileButtons,
        keybindValues = {
            DropBrainrot=KB.DropBrainrot.kb and KB.DropBrainrot.kb.Name or nil,
            DropBrainrotGP=KB.DropBrainrot.gp and KB.DropBrainrot.gp.Name or nil,
            AutoLeft=KB.AutoLeft.kb and KB.AutoLeft.kb.Name or nil,
            AutoLeftGP=KB.AutoLeft.gp and KB.AutoLeft.gp.Name or nil,
            AutoRight=KB.AutoRight.kb and KB.AutoRight.kb.Name or nil,
            AutoRightGP=KB.AutoRight.gp and KB.AutoRight.gp.Name or nil,
            AutoBat=KB.AutoBat.kb and KB.AutoBat.kb.Name or nil,
            AutoBatGP=KB.AutoBat.gp and KB.AutoBat.gp.Name or nil,
            TPFloor=KB.TPFloor.kb and KB.TPFloor.kb.Name or nil,
            TPFloorGP=KB.TPFloor.gp and KB.TPFloor.gp.Name or nil,
            CarryToggle=KB.CarryToggle.kb and KB.CarryToggle.kb.Name or nil,
            CarryToggleGP=KB.CarryToggle.gp and KB.CarryToggle.gp.Name or nil,
            LaggerMode=KB.LaggerMode.kb and KB.LaggerMode.kb.Name or nil,
            LaggerModeGP=KB.LaggerMode.gp and KB.LaggerMode.gp.Name or nil,
            InstaReset=KB.InstaReset.kb and KB.InstaReset.kb.Name or nil,
            InstaResetGP=KB.InstaReset.gp and KB.InstaReset.gp.Name or nil,
            Bypass=KB.Bypass.kb and KB.Bypass.kb.Name or nil,
            BypassGP=KB.Bypass.gp and KB.Bypass.gp.Name or nil,
        },
    }
    if pbFrame then
        config.progressBarPos = {XScale=pbFrame.Position.X.Scale, XOffset=pbFrame.Position.X.Offset, YScale=pbFrame.Position.Y.Scale, YOffset=pbFrame.Position.Y.Offset}
    end
    if MobilePanel and MobilePanel:FindFirstChild("FloatingPanel") then
        local container = MobilePanel:FindFirstChild("FloatingPanel")
        config.mobilePanelPos = {XScale=container.Position.X.Scale, XOffset=container.Position.X.Offset, YScale=container.Position.Y.Scale, YOffset=container.Position.Y.Offset}
    end
    return config
end

function saveAllSettings()
    if not canSaveConfig then return false end
    if _isResetting then return true end
    if _saveDisabled then return false end
    local config = buildConfigTable()
    local keybinds = {}
    for k, v in pairs(KB) do
        keybinds[k] = { kb = v.kb and v.kb.Name, gp = v.gp and v.gp.Name }
    end
    local mainConfig = {}
    for k, v in pairs(config) do mainConfig[k] = v end
    mainConfig.keybinds = keybinds
    local json = HS:JSONEncode(mainConfig)
    local success, err = pcall(function() _ace_writefile(CONFIG_FILE, json) end)
    if success then
        _lastSavedJSON = json
        return true
    else
        warn("[B2/JE HUB] Save failed: " .. tostring(err))
        return false
    end
end

function loadAllSettings()
    if not canSaveConfig then return false end
    if not _ace_isfile(CONFIG_FILE) then return false end
    local success, data = pcall(function() return HS:JSONDecode(_ace_readfile(CONFIG_FILE)) end)
    if not success or type(data) ~= "table" then return false end
    _isLoading = true
    local keybinds = data.keybinds or {}
    for keyId, val in pairs(keybinds) do
        if KB[keyId] then
            KB[keyId].kb = val.kb and Enum.KeyCode[val.kb] or nil
            KB[keyId].gp = val.gp and Enum.KeyCode[val.gp] or nil
        end
    end
    NS = data.normalSpeed or NS
    CS = data.carrySpeed or CS
    LAGGER_SPEED_1 = data.laggerSpeed1 or LAGGER_SPEED_1
    LAGGER_SPEED_2 = data.laggerSpeed2 or LAGGER_SPEED_2
    CONFIG.STEAL_RANGE = data.stealRadius or CONFIG.STEAL_RANGE
    autoTPDownHeight = data.autoTPDownHeight or 20
    uiLocked = data.lockUI or false
    editModeEnabled = data.editMode or false
    antiRagdollEnabled = data.antiRagdoll or false
    CONFIG.AUTO_STEAL_ENABLED = data.autoSteal or false
    jumpEnabled = data.jumpEnabled or false
    medusaCounterEnabled = data.medusaCounter or false
    batCounterEnabled = data.batCounter or false
    antiLagEnabled = data.antiLag or false
    laggerToggled = data.laggerToggled or false
    speedMode = data.carryMode or false
    laggerLevel = data.laggerLevel or 1
    uiScaleValue = data.uiScale or 80
    stealBarSize = tonumber(data.stealBarSize) or 100
    buttonScaleValue = data.buttonScale or 1.0
    if data.stealBarStyle then stealBarStyle = data.stealBarStyle end
    espEnabled = data.espEnabled or false
    espLineEnabled = data.espLineEnabled or false
    vividGraphicsEnabled = data.vividGraphics or false
    stretchEnabled = data.stretchEnabled or false
    BAT_AIMBOT_SPEED = data.batAimbotSpeed or BAT_AIMBOT_SPEED
    BYPASS_AIMBOT_SPEED = data.bypassSpeed or BYPASS_AIMBOT_SPEED
    dropMode = data.dropMode or 1
    bodyLockEnabled = data.bodyLockEnabled or false
    bodyLockRange = data.bodyLockRange or 20
    currentSkyTheme = data.skyTheme or "Off"
    currentAnimPack = data.animPack or "Off"
    currentAccessoryPack = data.accessoryPack or "Off"
    currentBgIndex = data.backgroundIndex or 1
    currentButtonBgIndex = data.buttonBgIndex or 0
    floatStyleIndex = tonumber(data.floatStyle) or 1
    currentOutfitIndex = data.outfitIndex or 1
    aimbotMode = (data.aimbotMode == 2) and 2 or 1
    _TpBat.distance = math.clamp(tonumber(data.tpBatDistance) or 8, 0, 100)
    autoLeftEnabled = data.autoLeft or false
    autoRightEnabled = data.autoRight or false
    autoBatEnabled = data.autoBat or false
    bypassToggled = data.bypass or false
    batDesyncTpEnabled = bypassToggled
    autoTPDownEnabled = data.autoTPDownEnabled or false
    resetButtonActive = false
    mirrorTPDownEnabled = data.mirrorTPDownEnabled or false
    autoResetOnMedEnabled = data.autoResetOnMedEnabled or false
    if data.stealDuration then Steal.StealDuration = data.stealDuration end
    autoCarrySpeedEnabled = data.autoCarrySpeed or false
    if data.autoCarryMode == "On Pick Up" or data.autoCarryMode == "Soft Steal" then autoCarryMode = data.autoCarryMode end
    if _G.B2SpinBot and _G.B2SpinBot.apply then pcall(_G.B2SpinBot.apply, data.spinBotEnabled, data.spinBotSpeed, data.spinBotBat) end
    if _G.B2AntiDie2 and _G.B2AntiDie2.apply then pcall(_G.B2AntiDie2.apply, data.antiDie2) end
    antiDieEnabled = data.antiDieEnabled or false
    antiBatEnabled = data.antiBat or false
    tpBatAutoAntiDieEnabled = data.tpBatAutoAntiDie ~= false
    antiKickEnabled = data.safeMode == true
    if _G.B2SetKickWarning then pcall(_G.B2SetKickWarning, data.kickWarning ~= false) end
    katanaSkinEnabled = data.katanaSkinEnabled or false
    minecraftBatSkinEnabled = data.minecraftBatSkinEnabled or false
    minecraftBatSkinColorMode = data.minecraftBatSkinColorMode or "Default"
    if data.stealDelay then Steal.StealDelay = data.stealDelay end
    if data.miniBtnPos then miniBtnPos = data.miniBtnPos end
    hideMobileButtons = data.hideButtons or false
    if data.keybindValues then
        local kv = data.keybindValues
        if kv.DropBrainrot then KB.DropBrainrot.kb = Enum.KeyCode[kv.DropBrainrot] end
        if kv.DropBrainrotGP then KB.DropBrainrot.gp = Enum.KeyCode[kv.DropBrainrotGP] end
        if kv.AutoLeft then KB.AutoLeft.kb = Enum.KeyCode[kv.AutoLeft] end
        if kv.AutoLeftGP then KB.AutoLeft.gp = Enum.KeyCode[kv.AutoLeftGP] end
        if kv.AutoRight then KB.AutoRight.kb = Enum.KeyCode[kv.AutoRight] end
        if kv.AutoRightGP then KB.AutoRight.gp = Enum.KeyCode[kv.AutoRightGP] end
        if kv.AutoBat then KB.AutoBat.kb = Enum.KeyCode[kv.AutoBat] end
        if kv.AutoBatGP then KB.AutoBat.gp = Enum.KeyCode[kv.AutoBatGP] end
        if kv.TPFloor then KB.TPFloor.kb = Enum.KeyCode[kv.TPFloor] end
        if kv.TPFloorGP then KB.TPFloor.gp = Enum.KeyCode[kv.TPFloorGP] end
        if kv.CarryToggle then KB.CarryToggle.kb = Enum.KeyCode[kv.CarryToggle] end
        if kv.CarryToggleGP then KB.CarryToggle.gp = Enum.KeyCode[kv.CarryToggleGP] end
        if kv.LaggerMode then KB.LaggerMode.kb = Enum.KeyCode[kv.LaggerMode] end
        if kv.LaggerModeGP then KB.LaggerMode.gp = Enum.KeyCode[kv.LaggerModeGP] end
        if kv.InstaReset then KB.InstaReset.kb = Enum.KeyCode[kv.InstaReset] end
        if kv.InstaResetGP then KB.InstaReset.gp = Enum.KeyCode[kv.InstaResetGP] end
        if kv.Bypass then KB.Bypass.kb = Enum.KeyCode[kv.Bypass] end
        if kv.BypassGP then KB.Bypass.gp = Enum.KeyCode[kv.BypassGP] end
    end
    if data.instaResetFloatingPos then instaResetFloatingPos = data.instaResetFloatingPos end
    if data.bypassFloatingPos then bypassFloatingPos = data.bypassFloatingPos end
    if data.progressBarPos then savedProgressBarPos = data.progressBarPos end
    if data.mobileButtonPositions then savedButtonPositions = data.mobileButtonPositions end
    if data.mobilePanelPos then savedMobilePanelPos = data.mobilePanelPos end
    if data.menuFramePos then menuFramePos = data.menuFramePos end
    _lastSavedJSON = HS:JSONEncode(buildConfigTable())
    _isLoading = false
    return true
end

function updateProgressBarVisibility()
    if pbFrame then pbFrame.Visible = true end
end
function applyShimmerToText(obj, speed)
    speed = speed or 0.8
    local grad = Instance.new("UIGradient", obj)
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 20, 147)),
        ColorSequenceKeypoint.new(0.3, Color3.fromRGB(255, 150, 200)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.7, Color3.fromRGB(255, 150, 200)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 20, 147))
    })
    grad.Rotation = 45
    task.spawn(function()
        local t = 0
        while grad and grad.Parent do
            t = t + 0.02
            grad.Offset = Vector2.new(math.sin(t * speed) * 0.4, 0)
            task.wait(0.04)
        end
    end)
end
function getDefaultButtonPosition(btnName)
    local BTN_W, BTN_H = 60, 60
    local GAP_X = 8
    local GAP_Y = 18
    local orderMap = {DropBR=0,AutoLeft=1,AutoBat=2,AutoRight=3,TpDown=4,Carry=5,Lagger1=6,Lagger2=7}
    local order = orderMap[btnName] or 0
    local row = math.floor(order / 2)
    local col = order % 2
    return col * (BTN_W + GAP_X), row * (BTN_H + GAP_Y)
end

function resetButtonPositions()
    for _, btn in ipairs(_mobileButtonsCache) do
        if btn and btn.Parent then
            local dx, dy = getDefaultButtonPosition(btn.Name)
            btn.Position = UDim2.new(0, dx, 0, dy)
        end
    end
    savedButtonPositions = {}
    savedMobilePanelPos = nil
    if MobilePanel then
        local c = MobilePanel:FindFirstChild("FloatingPanel")
        if c then
            local PANEL_W = 60 * 2 + 8 * 1
            local PANEL_H = 60 * 4 + 18 * 3
            c.Position = UDim2.new(1, -(PANEL_W + 56), 1, -(PANEL_H + 95))
        end
    end
    instaResetFloatingPos = nil
    if instaResetFloatingButton then
        local f = instaResetFloatingButton:FindFirstChild("Frame")
        if f then f.Position = UDim2.new(0.5, 46, 0, 10) end
    end
    bypassFloatingPos = nil
    if bypassFloatingButton then
        local f = bypassFloatingButton:FindFirstChild("Frame")
        if f then f.Position = UDim2.new(0.5, 137, 0, 10) end
    end
    saveAllSettings()
end

function buildGui()
    -- ============================================================
    -- COLOR PALETTE (Dark Plum Background, Hot Pink Buttons, White/Pink Fonts)
    -- ============================================================
    local Bg           = Color3.fromRGB(40, 10, 25) -- Dark Plum
    local BgPanel      = Color3.fromRGB(55, 15, 35)
    local BgRow        = Color3.fromRGB(70, 20, 45)
    local BgRowHover   = Color3.fromRGB(90, 30, 60)
    local BgTabBar     = Color3.fromRGB(20, 5, 10)
    local BgTab        = Color3.fromRGB(55, 15, 35)
    local HotPink      = Color3.fromRGB(255, 20, 147)
    local LightPink    = Color3.fromRGB(255, 150, 200)
    local TextMain     = Color3.fromRGB(255, 255, 255) -- White
    local TextMuted    = Color3.fromRGB(255, 150, 200) -- Pink
    local Border       = Color3.fromRGB(255, 20, 147)
    local BorderSoft   = Color3.fromRGB(200, 50, 120)
    local Danger       = Color3.fromRGB(255, 50, 50)
    local White        = Color3.fromRGB(255, 255, 255)

    -- ============================================================
    -- SIZE & METRICS
    -- ============================================================
    local GUI_W, GUI_H  = 360, 640
    local RADIUS        = 20
    local HEADER_H      = 64
    local TAB_H         = 36
    local FOOTER_H      = 22
    local PAD           = 12
    local TITLE         = "B2/JE HUB"
    local SUBTITLE      = "JE DEVELOPER"
    local BG_IMAGE      = "rbxassetid://79007973869217"
    local CONTENT_TOP    = 10 + HEADER_H + 4 + TAB_H + 10
    local CONTENT_BOTTOM = FOOTER_H + 16
    local CONTENT_OFFSET = CONTENT_TOP + CONTENT_BOTTOM

    local old = game:GetService("CoreGui"):FindFirstChild("B2/JE HUB")
    if old then old:Destroy() end
    local pg = LP:FindFirstChild("PlayerGui")
    if pg then local o = pg:FindFirstChild("B2/JE HUB"); if o then o:Destroy() end end

    gui = Instance.new("ScreenGui")
    gui.Name = "B2/JE HUB"
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 10
    gui.IgnoreGuiInset = true
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
    if not pcall(function() gui.Parent = game:GetService("CoreGui") end) then
        gui.Parent = LP:WaitForChild("PlayerGui")
    end

    local function notify(text, color)
        color = color or HotPink
        local toast = Instance.new("Frame", gui)
        toast.Size = UDim2.new(0, 240, 0, 40)
        toast.Position = UDim2.new(0.5, -120, 0, -60)
        toast.BackgroundColor3 = BgPanel
        toast.BorderSizePixel = 0
        toast.ZIndex = 9999
        Instance.new("UICorner", toast).CornerRadius = UDim.new(0, 12)
        local ts = Instance.new("UIStroke", toast)
        ts.Color = color; ts.Thickness = 1.4; ts.Transparency = 0.15
        local lbl = Instance.new("TextLabel", toast)
        lbl.Size = UDim2.new(1, -16, 1, 0)
        lbl.Position = UDim2.new(0, 8, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.TextColor3 = TextMain
        lbl.Font = Enum.Font.GothamBlack
        lbl.TextSize = 12
        lbl.TextXAlignment = Enum.TextXAlignment.Center
        lbl.ZIndex = 10000
        TS:Create(toast, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
            {Position = UDim2.new(0.5, -120, 0, 18)}):Play()
        task.delay(2.4, function()
            if toast and toast.Parent then
                TS:Create(toast, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
                    {Position = UDim2.new(0.5, -120, 0, -60)}):Play()
                task.delay(0.35, function() if toast then toast:Destroy() end end)
            end
        end)
    end
    _G.B2Notify = notify

    main = Instance.new("Frame", gui)
    main.Size = UDim2.new(0, GUI_W, 0, GUI_H)
    if menuFramePos then
        main.Position = UDim2.new(menuFramePos.XScale or 0, menuFramePos.XOffset or 20,
                                  menuFramePos.YScale or 0, menuFramePos.YOffset or 2)
    else
        main.Position = UDim2.new(0, 20, 0, 2)
    end
    main.BackgroundColor3 = Bg
    main.BackgroundTransparency = 0.05
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, RADIUS)

    local mainStroke = Instance.new("UIStroke", main)
    mainStroke.Name = "MainStroke"
    mainStroke.Thickness = 1.6; mainStroke.Transparency = 0.05
    mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    local mainGrad = Instance.new("UIGradient", mainStroke)
    mainGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, HotPink),
        ColorSequenceKeypoint.new(0.35, LightPink),
        ColorSequenceKeypoint.new(0.65, White),
        ColorSequenceKeypoint.new(1.00, HotPink),
    })
    task.spawn(function()
        while mainGrad and mainGrad.Parent do
            mainGrad.Rotation = (mainGrad.Rotation + 4) % 360
            task.wait(1/60)
        end
    end)

    local bodyGrad = Instance.new("UIGradient", main)
    bodyGrad.Rotation = 135
    bodyGrad.Transparency = NumberSequence.new(0.6) -- Makes the background image clearer

    -- BG image
    local bgImage = Instance.new("ImageLabel", main)
    bgImage.Name = "BgImage"
    bgImage.Size = UDim2.new(1, 0, 1, 0)
    bgImage.BackgroundTransparency = 1
    bgImage.Image = BG_IMAGE
    bgImage.ImageTransparency = 0
    bgImage.ImageColor3 = Color3.fromRGB(255, 255, 255)
    bgImage.ScaleType = Enum.ScaleType.Crop
    bgImage.ZIndex = 0
    Instance.new("UICorner", bgImage).CornerRadius = UDim.new(0, RADIUS)
    bgImageRef = bgImage
    bgImageCorner = bgImage:FindFirstChildOfClass("UICorner")

    mainUIScale = Instance.new("UIScale", main)
    mainUIScale.Scale = uiScaleValue / 100

    -- HEADER
    local header = Instance.new("Frame", main)
    header.Name = "Header"
    header.Size = UDim2.new(1, -PAD * 2, 0, HEADER_H)
    header.Position = UDim2.new(0, PAD, 0, 10)
    header.BackgroundTransparency = 1
    header.ZIndex = 15

    local dot = Instance.new("Frame", header)
    dot.Name = "Dot"
    dot.Size = UDim2.new(0, 10, 0, 10)
    dot.Position = UDim2.new(0, 2, 0.5, -5)
    dot.BackgroundColor3 = HotPink
    dot.BorderSizePixel = 0
    dot.ZIndex = 16
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
    local dotStroke = Instance.new("UIStroke", dot)
    dotStroke.Color = LightPink; dotStroke.Thickness = 1.5; dotStroke.Transparency = 0.2
    task.spawn(function()
        local t = 0
        while dot and dot.Parent do
            t = t + 0.06
            local p = (math.sin(t * 2.6) + 1) * 0.5
            dot.BackgroundTransparency = 0.1 + p * 0.5
            dotStroke.Transparency = 0.1 + p * 0.7
            dot.Size = UDim2.new(0, 8 + p * 4, 0, 8 + p * 4)
            dot.Position = UDim2.new(0, 2 - p * 1, 0.5, -5 - p * 1)
            task.wait(0.05)
        end
    end)

    local titleLabel = Instance.new("TextLabel", header)
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, -120, 0, 30)
    titleLabel.Position = UDim2.new(0, 22, 0, 4)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = TITLE
    titleLabel.TextColor3 = TextMain
    titleLabel.Font = Enum.Font.GothamBlack
    titleLabel.TextSize = 26
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = 16
    local titleShine = Instance.new("UIGradient", titleLabel)
    titleShine.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, TextMuted),
        ColorSequenceKeypoint.new(0.35, LightPink),
        ColorSequenceKeypoint.new(0.50, White),
        ColorSequenceKeypoint.new(0.65, LightPink),
        ColorSequenceKeypoint.new(1.00, TextMuted),
    })
    titleShine.Rotation = 90
    task.spawn(function()
        while titleShine and titleShine.Parent do
            titleShine.Offset = Vector2.new(math.sin(tick() * 1.6) * 0.6, 0)
            task.wait(0.03)
        end
    end)

    local subtitleLabel = Instance.new("TextLabel", header)
    subtitleLabel.Size = UDim2.new(1, -120, 0, 16)
    subtitleLabel.Position = UDim2.new(0, 22, 0, 34)
    subtitleLabel.BackgroundTransparency = 1
    subtitleLabel.Text = SUBTITLE
    subtitleLabel.TextColor3 = TextMuted
    subtitleLabel.Font = Enum.Font.GothamBold
    subtitleLabel.TextSize = 16
    subtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    subtitleLabel.ZIndex = 16

    local closeBtn = Instance.new("TextButton", header)
    closeBtn.Size = UDim2.new(0, 28, 0, 28)
    closeBtn.Position = UDim2.new(1, -30, 0.5, -14)
    closeBtn.BackgroundColor3 = BgTab
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "×"
    closeBtn.TextColor3 = TextMuted
    closeBtn.Font = Enum.Font.GothamBlack
    closeBtn.TextSize = 18
    closeBtn.AutoButtonColor = false
    closeBtn.ZIndex = 16
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)
    local closeStroke = Instance.new("UIStroke", closeBtn)
    closeStroke.Color = BorderSoft; closeStroke.Thickness = 1; closeStroke.Transparency = 0.3
    closeBtn.MouseEnter:Connect(function()
        TS:Create(closeBtn, TweenInfo.new(0.15), {BackgroundColor3 = Danger}):Play()
        TS:Create(closeStroke, TweenInfo.new(0.15), {Color = White, Transparency = 0.1}):Play()
        closeBtn.TextColor3 = White
    end)
    closeBtn.MouseLeave:Connect(function()
        TS:Create(closeBtn, TweenInfo.new(0.15), {BackgroundColor3 = BgTab}):Play()
        TS:Create(closeStroke, TweenInfo.new(0.15), {Color = BorderSoft, Transparency = 0.3}):Play()
        closeBtn.TextColor3 = TextMuted
    end)

    local _drag = false
    local _dragStart, _startPos
    header.InputBegan:Connect(function(inp)
        if uiLocked then return end
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            _drag = true; _dragStart = inp.Position; _startPos = main.Position
        end
    end)
    header.InputChanged:Connect(function(inp)
        if _drag and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
            local d = inp.Position - _dragStart
            main.Position = UDim2.new(_startPos.X.Scale, _startPos.X.Offset + d.X, _startPos.Y.Scale, _startPos.Y.Offset + d.Y)
        end
    end)
    UIS.InputEnded:Connect(function(inp)
        if _drag and (inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch) then
            _drag = false
            menuFramePos = {XScale = main.Position.X.Scale, XOffset = main.Position.X.Offset,
                            YScale = main.Position.Y.Scale, YOffset = main.Position.Y.Offset}
            saveAllSettings()
        end
    end)

    -- MINI BTN
    miniBtn = Instance.new("TextButton", gui)
    miniBtn.Name = "OpenBtn"
    miniBtn.Size = UDim2.new(0, 48, 0, 48)
    if miniBtnPos then
        miniBtn.Position = UDim2.new(miniBtnPos.XScale or 0, miniBtnPos.XOffset or 16,
                                     miniBtnPos.YScale or 0, miniBtnPos.YOffset or 58)
    else
        miniBtn.Position = UDim2.new(0, 16, 0, 58)
    end
    miniBtn.BackgroundColor3 = BgPanel
    miniBtn.BorderSizePixel = 0
    miniBtn.Text = "B2"
    miniBtn.TextColor3 = LightPink
    miniBtn.Font = Enum.Font.GothamBlack
    miniBtn.TextSize = 14
    miniBtn.AutoButtonColor = false
    miniBtn.Visible = false
    miniBtn.ZIndex = 20
    Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(1, 0)
    local miniStroke = Instance.new("UIStroke", miniBtn)
    miniStroke.Color = HotPink; miniStroke.Thickness = 1.5; miniStroke.Transparency = 0.15
    task.spawn(function()
        local t = 0
        while miniBtn and miniBtn.Parent do
            t = t + 0.05
            local s = 48 + math.sin(t * 4.4) * 2
            miniBtn.Size = UDim2.new(0, s, 0, s)
            miniStroke.Transparency = 0.1 + math.abs(math.sin(t * 4.4)) * 0.35
            task.wait(0.05)
        end
    end)

    local _mbDrag, _mbMoved, _mbStart, _mbStartPos
    miniBtn.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            _mbDrag = true; _mbMoved = false; _mbStart = inp.Position; _mbStartPos = miniBtn.Position
        end
    end)
    miniBtn.InputChanged:Connect(function(inp)
        if not _mbDrag then return end
        if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
            local d = inp.Position - _mbStart
            if d.Magnitude > 5 then _mbMoved = true end
            if _mbMoved then
                miniBtn.Position = UDim2.new(_mbStartPos.X.Scale, _mbStartPos.X.Offset + d.X,
                                             _mbStartPos.Y.Scale, _mbStartPos.Y.Offset + d.Y)
            end
        end
    end)
    UIS.InputEnded:Connect(function(inp)
        if _mbDrag and (inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch) then
            if _mbMoved then
                miniBtnPos = {XScale = miniBtn.Position.X.Scale, XOffset = miniBtn.Position.X.Offset,
                              YScale = miniBtn.Position.Y.Scale, YOffset = miniBtn.Position.Y.Offset}
                task.spawn(function() saveAllSettings() end)
            end
            _mbDrag = false; _mbMoved = false
        end
    end)

    -- SHOW / HIDE
    local animating = false
    local function homePos()
        if menuFramePos then
            return UDim2.new(menuFramePos.XScale or 0, menuFramePos.XOffset or 20,
                             menuFramePos.YScale or 0, menuFramePos.YOffset or 2)
        end
        return UDim2.new(0, 20, 0, 2)
    end
    local function animateShow()
        if animating then return end
        animating = true
        main.Visible = true
        local home = homePos()
        main.Position = UDim2.new(1, home.X.Offset, home.Y.Scale, home.Y.Offset)
        if mainUIScale then mainUIScale.Scale = (uiScaleValue / 100) * 0.82 end
        TS:Create(main, TweenInfo.new(0.42, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = home}):Play()
        if mainUIScale then
            TS:Create(mainUIScale, TweenInfo.new(0.42, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                {Scale = uiScaleValue / 100}):Play()
        end
        miniBtn.Visible = false
        task.delay(0.5, function() animating = false end)
    end
    local function animateHide()
        if animating then return end
        animating = true
        local home = homePos()
        TS:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
            {Position = UDim2.new(1, home.X.Offset, home.Y.Scale, home.Y.Offset)}):Play()
        if mainUIScale then
            TS:Create(mainUIScale, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                {Scale = (uiScaleValue / 100) * 0.85}):Play()
        end
        task.delay(0.35, function()
            main.Visible = false
            main.Position = home
            if mainUIScale then mainUIScale.Scale = uiScaleValue / 100 end
            miniBtn.Visible = true
            animating = false
        end)
    end
    showGui = function() if main.Visible then return end; animateShow() end
    hideGui = function() if not main.Visible then return end; animateHide() end
    closeBtn.MouseButton1Click:Connect(function() hideGui(); notify("Menu hidden", HotPink) end)
    miniBtn.MouseButton1Click:Connect(function()
        if _mbMoved then return end
        showGui()
    end)

    -- TAB BAR
    local tabBar = Instance.new("Frame", main)
    tabBar.Name = "TabBar"
    tabBar.Size = UDim2.new(1, -16, 0, TAB_H)
    tabBar.Position = UDim2.new(0, 8, 0, 10 + HEADER_H + 4)
    tabBar.BackgroundColor3 = BgTabBar
    tabBar.BackgroundTransparency = 0.45
    tabBar.BorderSizePixel = 0
    tabBar.ZIndex = 14
    Instance.new("UICorner", tabBar).CornerRadius = UDim.new(0, 10)
    local tabBarStroke = Instance.new("UIStroke", tabBar)
    tabBarStroke.Color = Border; tabBarStroke.Thickness = 1; tabBarStroke.Transparency = 0.35

    local indicator = Instance.new("Frame", tabBar)
    indicator.Name = "Indicator"
    indicator.Size = UDim2.new(1/5, -6, 1, -6)
    indicator.Position = UDim2.new(0, 3, 0, 3)
    indicator.BackgroundColor3 = HotPink
    indicator.BorderSizePixel = 0
    indicator.ZIndex = 15
    Instance.new("UICorner", indicator).CornerRadius = UDim.new(0, 8)
    local indGrad = Instance.new("UIGradient", indicator)
    indGrad.Rotation = 90
    indGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, HotPink),
        ColorSequenceKeypoint.new(1, LightPink),
    })

    local tabContent = Instance.new("Frame", main)
    tabContent.Name = "TabContent"
    tabContent.Size = UDim2.new(1, -PAD * 2, 1, -CONTENT_OFFSET)
    tabContent.Position = UDim2.new(0, PAD, 0, CONTENT_TOP)
    tabContent.BackgroundTransparency = 1
    tabContent.ClipsDescendants = true
    tabContent.ZIndex = 5

    local tabs = {"Main", "Speed", "Combat", "Visual", "Sets"}
    local tabButtons = {}
    local contentPages = {}
    local function moveIndicator(idx)
        TS:Create(indicator, TweenInfo.new(0.32, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Position = UDim2.new((idx-1)/#tabs, 3, 0, 3)
        }):Play()
    end

    for i, name in ipairs(tabs) do
        local btn = Instance.new("TextButton", tabBar)
        btn.Size = UDim2.new(1/#tabs, 0, 1, 0)
        btn.Position = UDim2.new((i-1)/#tabs, 0, 0, 0)
        btn.BackgroundTransparency = 1
        btn.Text = name
        btn.TextColor3 = TextMuted
        btn.Font = Enum.Font.GothamBlack
        btn.TextSize = 11
        btn.AutoButtonColor = false
        btn.ZIndex = 16
        btn.MouseEnter:Connect(function()
            if btn.TextColor3 ~= TextMain then btn.TextColor3 = LightPink end
        end)
        btn.MouseLeave:Connect(function()
            if btn.TextColor3 ~= TextMain then btn.TextColor3 = TextMuted end
        end)
        local page = Instance.new("ScrollingFrame", tabContent)
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.BorderSizePixel = 0
        page.ClipsDescendants = true
        page.ScrollBarThickness = 0
        page.CanvasSize = UDim2.new(0, 0, 0, 0)
        page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        page.ScrollingDirection = Enum.ScrollingDirection.Y
        page.ZIndex = 6
        page.Visible = (i == 1)
        local layout = Instance.new("UIListLayout", page)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 5)
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        local padding = Instance.new("UIPadding", page)
        padding.PaddingLeft = UDim.new(0, 2)
        padding.PaddingRight = UDim.new(0, 2)
        padding.PaddingTop = UDim.new(0, 4)
        padding.PaddingBottom = UDim.new(0, 10)
        contentPages[name] = page
        btn.MouseButton1Click:Connect(function()
            for _, p in pairs(contentPages) do p.Visible = false end
            page.Visible = true
            for _, b in ipairs(tabButtons) do b.TextColor3 = TextMuted end
            btn.TextColor3 = TextMain
            moveIndicator(i)
        end)
        table.insert(tabButtons, btn)
    end
    if tabButtons[1] then tabButtons[1].TextColor3 = TextMain end
    moveIndicator(1)

    -- HELPERS
    local pageCounters = {}
    local function getNextOrder(page)
        pageCounters[page] = (pageCounters[page] or 0) + 1
        return pageCounters[page]
    end
    local function mkSect(page, txt)
        local f = Instance.new("Frame", page)
        f.Size = UDim2.new(1, 0, 0, 24)
        f.BackgroundTransparency = 1
        f.LayoutOrder = getNextOrder(page)
        f.ZIndex = 7
        local l = Instance.new("TextLabel", f)
        l.Size = UDim2.new(1, -16, 1, 0)
        l.Position = UDim2.new(0, 8, 0, 0)
        l.BackgroundTransparency = 1
        l.Text = txt:upper()
        l.TextColor3 = LightPink
        l.Font = Enum.Font.GothamBlack
        l.TextSize = 11
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.ZIndex = 8
        local u = Instance.new("Frame", f)
        u.Size = UDim2.new(0, 40, 0, 2)
        u.Position = UDim2.new(0, 8, 1, -2)
        u.BackgroundColor3 = HotPink
        u.BorderSizePixel = 0
        u.ZIndex = 8
        local ug = Instance.new("UIGradient", u)
        ug.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(1, 1),
        })
    end
    local function mkRow(page, h)
        h = h or 32
        local f = Instance.new("Frame", page)
        f.Size = UDim2.new(1, 0, 0, h)
        f.BackgroundColor3 = BgRow
        f.BackgroundTransparency = 0
        f.BorderSizePixel = 0
        f.LayoutOrder = getNextOrder(page)
        f.ZIndex = 7
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
        local rs = Instance.new("UIStroke", f)
        rs.Color = BorderSoft; rs.Thickness = 1; rs.Transparency = 0.55
        f.MouseEnter:Connect(function()
            TS:Create(f, TweenInfo.new(0.12), {BackgroundColor3 = BgRowHover}):Play()
            TS:Create(rs, TweenInfo.new(0.12), {Color = Border, Transparency = 0.2}):Play()
        end)
        f.MouseLeave:Connect(function()
            TS:Create(f, TweenInfo.new(0.12), {BackgroundColor3 = BgRow}):Play()
            TS:Create(rs, TweenInfo.new(0.12), {Color = BorderSoft, Transparency = 0.55}):Play()
        end)
        return f
    end
    local function mkLabel(row, txt)
        local l = Instance.new("TextLabel", row)
        l.Size = UDim2.new(0.55, 0, 1, 0)
        l.Position = UDim2.new(0, 10, 0, 0)
        l.BackgroundTransparency = 1
        l.Text = txt
        l.TextColor3 = TextMain
        l.Font = Enum.Font.GothamBold
        l.TextSize = 11
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.TextTruncate = Enum.TextTruncate.AtEnd
        l.ZIndex = 8
    end
    local function mkPill(row, offset)
        local pill = Instance.new("Frame", row)
        pill.Size = UDim2.new(0, 40, 0, 20)
        pill.Position = UDim2.new(1, -(offset or 50), 0.5, -10)
        pill.BackgroundColor3 = BgTab
        pill.BorderSizePixel = 0
        pill.ZIndex = 8
        Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)
        local st = Instance.new("UIStroke", pill)
        st.Color = BorderSoft; st.Thickness = 1.2; st.Transparency = 0.4
        local dot = Instance.new("Frame", pill)
        dot.Size = UDim2.new(0, 14, 0, 14)
        dot.Position = UDim2.new(0, 3, 0.5, -7)
        dot.BackgroundColor3 = TextMuted
        dot.BorderSizePixel = 0
        dot.ZIndex = 9
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
        return pill, dot
    end
    local function animPill(pill, dot, on)
        TS:Create(pill, TweenInfo.new(0.16, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
            {BackgroundColor3 = on and HotPink or BgTab}):Play()
        TS:Create(dot, TweenInfo.new(0.16, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
            {Position = on and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7),
             BackgroundColor3 = on and LightPink or TextMuted}):Play()
        local st = pill:FindFirstChildOfClass("UIStroke")
        if st then
            TS:Create(st, TweenInfo.new(0.16), {
                Color = on and HotPink or BorderSoft,
                Transparency = on and 0 or 0.4
            }):Play()
        end
    end
    local function mkToggle(page, txt, cb)
        local row = mkRow(page, 34)
        mkLabel(row, txt)
        local pill, dot = mkPill(row, 50)
        local on = false
        local function sv(s) on = s; animPill(pill, dot, s) end
        local clk = Instance.new("TextButton", pill)
        clk.Size = UDim2.new(1, 0, 1, 0)
        clk.BackgroundTransparency = 1
        clk.Text = ""
        clk.AutoButtonColor = false
        clk.ZIndex = 10
        clk.MouseButton1Click:Connect(function()
            if editModeEnabled and not uiLocked then
                pcall(cb, not on)
            else
                on = not on
                sv(on)
                pcall(cb, on)
                saveAllSettings()
            end
        end)
        return sv
    end
    local function mkSelector(parent, default, options, cb)
        local container = Instance.new("Frame", parent)
        container.Size = UDim2.new(0, 160, 1, 0)
        container.Position = UDim2.new(1, -170, 0, 0)
        container.BackgroundTransparency = 1
        container.ZIndex = 8
        local btn = Instance.new("TextButton", container)
        btn.Size = UDim2.new(0, 120, 0, 24)
        btn.Position = UDim2.new(0.5, -60, 0.5, -12)
        btn.BackgroundColor3 = BgTab
        btn.BorderSizePixel = 0
        btn.Text = default
        btn.TextColor3 = LightPink
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 11
        btn.AutoButtonColor = false
        btn.ZIndex = 9
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 7)
        local st = Instance.new("UIStroke", btn)
        st.Color = BorderSoft; st.Thickness = 1; st.Transparency = 0.3
        btn.MouseEnter:Connect(function()
            TS:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = BgRowHover}):Play()
            TS:Create(st, TweenInfo.new(0.12), {Color = HotPink, Transparency = 0}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TS:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = BgTab}):Play()
            TS:Create(st, TweenInfo.new(0.12), {Color = BorderSoft, Transparency = 0.3}):Play()
        end)
        btn.MouseButton1Click:Connect(function() if cb then cb(btn) end end)
        return btn
    end
    local function mkBox(parent, default, w, xOff, cb)
        local tb = Instance.new("TextBox", parent)
        local bw = w or 50
        local xo = math.max(xOff or 56, bw + 12)
        tb.Size = UDim2.new(0, bw, 0, 22)
        tb.Position = UDim2.new(1, -xo, 0.5, -11)
        tb.BackgroundColor3 = BgTab
        tb.BorderSizePixel = 0
        tb.Text = tostring(default)
        tb.TextColor3 = LightPink
        tb.Font = Enum.Font.GothamBold
        tb.TextSize = 11
        tb.ClearTextOnFocus = false
        tb.ZIndex = 8
        Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 6)
        local bs = Instance.new("UIStroke", tb)
        bs.Color = BorderSoft; bs.Thickness = 1; bs.Transparency = 0.3
        tb.Focused:Connect(function()
            TS:Create(bs, TweenInfo.new(0.12), {Color = HotPink, Transparency = 0}):Play()
        end)
        tb.FocusLost:Connect(function()
            TS:Create(bs, TweenInfo.new(0.12), {Color = BorderSoft, Transparency = 0.3}):Play()
            if cb then
                local n = tonumber(tb.Text)
                if n then cb(n) else tb.Text = tostring(default) end
            end
        end)
        return tb
    end
    local function mkKeyButton(parent, kbEntry)
        local btn = Instance.new("TextButton", parent)
        btn.Size = UDim2.new(0, 80, 0, 22)
        btn.Position = UDim2.new(1, -88, 0.5, -11)
        btn.BackgroundColor3 = BgTab
        btn.BorderSizePixel = 0
        btn.Text = (kbEntry.gp and kbEntry.gp.Name) or (kbEntry.kb and kbEntry.kb.Name) or "None"
        btn.TextColor3 = LightPink
        btn.Font = Enum.Font.GothamBlack
        btn.TextSize = 9
        btn.ZIndex = 8
        btn.AutoButtonColor = false
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        local bs = Instance.new("UIStroke", btn)
        bs.Color = BorderSoft; bs.Thickness = 1
        local li, lc, pv = false, nil, btn.Text
        local listenStart = 0
        local listenTimeoutThread = nil
        local function stopListening(revert)
            li = false
            _anyKeyListening = false
            _anyKeyStuckSince = 0
            if lc then lc:Disconnect(); lc = nil end
            if revert then btn.Text = pv; btn.TextColor3 = LightPink end
        end
        btn.Activated:Connect(function()
            if li then stopListening(true); return end
            pv = btn.Text; li = true; _anyKeyListening = true; listenStart = tick()
            _anyKeyStuckSince = tick()
            btn.Text = "..."; btn.TextColor3 = HotPink
            if listenTimeoutThread then task.cancel(listenTimeoutThread) end
            listenTimeoutThread = task.delay(5, function()
                if li then stopListening(true) end
            end)
            lc = UIS.InputBegan:Connect(function(inp)
                if not li then return end
                if inp.KeyCode == Enum.KeyCode.Escape then stopListening(true); return end
                local isGp = isGamepadInput(inp)
                if isGp and tick() - listenStart < 0.15 then return end
                if inp.UserInputType == Enum.UserInputType.MouseButton2 then
                    kbEntry.kb = nil; kbEntry.gp = nil
                    pv = "None"; btn.Text = "None"
                    stopListening(false); saveAllSettings(); return
                end
                if not isBindableInput(inp) then return end
                btn.Text = inp.KeyCode.Name; pv = inp.KeyCode.Name
                if isGp then kbEntry.gp = inp.KeyCode; kbEntry.kb = nil
                else kbEntry.kb = inp.KeyCode; kbEntry.gp = nil end
                stopListening(false); saveAllSettings()
            end)
        end)
        table.insert(keyButtonRefs, {btn = btn, entry = kbEntry})
        return btn
    end

    -- ==========================================
    -- PAGE MAPPINGS & CONTENT
    -- ==========================================
    
    local speedPage = contentPages["Speed"]
    local mainPage = contentPages["Main"]
    local combatPage = contentPages["Combat"]
    local visualPage = contentPages["Visual"]
    local setsPage = contentPages["Sets"]

    -- MAIN PAGE
    mkSect(mainPage, "Auto Grab / Steal")
    setInstaGrab = mkToggle(mainPage, "Auto Steal", function(on)
        CONFIG.AUTO_STEAL_ENABLED = on
        if on then pcall(startAutoStealSemi) else stopAutoSteal() end
        updateProgressBarVisibility()
        saveAllSettings()
    end)
    do local r = mkRow(mainPage, 30); mkLabel(r, "Steal Radius"); radInput = mkBox(r, CONFIG.STEAL_RANGE, 50, 56, function(v) if v and v >= 5 and v <= 300 then CONFIG.STEAL_RANGE = math.floor(v + 0.5); Steal.StealRadius = CONFIG.STEAL_RANGE; radInput.Text = tostring(CONFIG.STEAL_RANGE); saveAllSettings() end end) end
    do local r = mkRow(mainPage, 30); mkLabel(r, "Steal Duration"); stealDurationBox = mkBox(r, Steal.StealDuration, 50, 56, function(v) if v and v >= 0.1 and v <= 10 then Steal.StealDuration = v; saveAllSettings() end end) end
    setAutoCarryVisual = mkToggle(mainPage, "Auto Carry Speed", function(on)
        autoCarrySpeedEnabled = on
        if not on and _G.B2AutoCarry then pcall(_G.B2AutoCarry.restore) end
        saveAllSettings()
    end)
    do
        local r = mkRow(mainPage, 30)
        mkLabel(r, "Auto Carry Mode")
        autoCarryModeBtn = mkSelector(r, autoCarryMode, {"On Pick Up","Soft Steal"}, function(btn)
            autoCarryMode = (autoCarryMode == "On Pick Up") and "Soft Steal" or "On Pick Up"
            btn.Text = autoCarryMode
            if _G.B2AutoCarry then pcall(_G.B2AutoCarry.reset) end
            saveAllSettings()
        end)
    end
    mkSect(mainPage, "Protection")
    setAntiDieVisual = mkToggle(mainPage, "Anti Die", function(on)
        antiDieEnabled = on
        if on then _tpBatAutoAntiDie(false) end
        if on then AntiDieModule.start() else AntiDieModule.stop() end
        saveAllSettings()
    end)
    setTpBatAutoADVisual = mkToggle(mainPage, "TP Bat Auto Anti Die", function(on)
        tpBatAutoAntiDieEnabled = on
        if not on then _tpBatAutoAntiDie(false) end
        saveAllSettings()
    end)
    setSafeModeVisual = mkToggle(mainPage, "Safe Mode", function(on)
        antiKickEnabled = on
        if on and _G.AmbitiousSafeModeForceStop then _G.AmbitiousSafeModeForceStop("SAFE MODE") end
        saveAllSettings()
    end)
    setKickWarningVisual = mkToggle(mainPage, "Kick Warning", function(on)
        if _G.B2SetKickWarning then _G.B2SetKickWarning(on) end
        saveAllSettings()
    end)
    setAntiBatVisual = mkToggle(mainPage, "Anti Bat", function(on)
        if on then startAntiBat() else stopAntiBat() end
        saveAllSettings()
    end)

    mkSect(mainPage, "Spin Bot")
    do
        local SPIN_SPEEDS = {
            { name = "Slow",      value = 0.15 },
            { name = "Normal",    value = 0.35 },
            { name = "Fast",      value = 0.60 },
            { name = "Very Fast", value = 0.90 },
        }
        local SB = { enabled = false, idx = 3, batSpin = false }
        _G.B2SpinBot = SB
        local sbVisual, sbBatVisual, sbSpeedBtn

        local function isWeaponName(n)
            n = tostring(n or ""):lower()
            return n:find("bat") or n:find("slap") or n:find("medusa") or n:find("head") or n:find("stone")
        end
        local baseline, baseChar = {}, nil
        local function snapshot(c)
            baseline = {}
            for _, ch in ipairs(c:GetChildren()) do baseline[ch] = true end
            baseChar = c
        end
        local function carryingBrainrot()
            local c = LP.Character
            if not c then return false end
            if baseChar ~= c then
                snapshot(c)
                task.delay(2, function() if LP.Character == c then snapshot(c) end end)
            end
            local okH, hold = pcall(function() return _G.AmbitiousSafeModeHoldingBrainrot and _G.AmbitiousSafeModeHoldingBrainrot() end)
            if okH and hold then return true, "safe" end
            if LP:GetAttribute("Stealing") == true then return true, "LP.Stealing" end
            if c:GetAttribute("Stealing") == true then return true, "Char.Stealing" end
            for k, v in pairs(c:GetAttributes()) do
                local n = k:lower()
                if v == true and (n:find("carry") or n:find("stealing") or n:find("hasbrainrot")) then return true, "attr:" .. k end
            end
            for _, entry in ipairs({ "Carrying","IsCarrying","Grabbed","Holding","StealHold","HasGrab" }) do
                local inst = c:FindFirstChild(entry, true)
                if inst and ((inst:IsA("BoolValue") and inst.Value)
                    or (inst:IsA("ObjectValue") and inst.Value)
                    or (inst:IsA("StringValue") and inst.Value ~= "")) then return true, "val:" .. entry end
            end
            local batBusy = (autoBatEnabled == true) or (batDesyncTpEnabled == true)
            if not batBusy then
                for _, ch in ipairs(c:GetChildren()) do
                    if ch:IsA("Tool") and isWeaponName(ch.Name) then batBusy = true; break end
                end
            end
            if batBusy then return false end
            for _, ch in ipairs(c:GetChildren()) do
                local n = ch.Name:lower()
                if ch:IsA("Tool") and not isWeaponName(n) then return true, "tool:" .. ch.Name end
                if ch:IsA("Model") and (n:find("brainrot") or n:find("animal") or n:find("carry") or n:find("stolen") or n:find("steal")) then
                    return true, "model:" .. ch.Name
                end
            end
            return false
        end

        local GRACE = 0.3
        local lastCarry = 0
        
        RunService.Heartbeat:Connect(function()
            if not SB.enabled then return end
            local ac = _G.B2AutoCarry
            local acActive = autoCarrySpeedEnabled and ac and ac.isActive and ac.isActive()
            local carry, why = carryingBrainrot()
            local batNow = (autoBatEnabled == true) or (batDesyncTpEnabled == true)
            if batNow then
                if SB.batSpin then carry, why = true, "batAimbot" else carry = false end
            elseif SB.wasBat and not carry then
                lastCarry = 0
            end
            SB.wasBat = batNow
            local hc = LP.Character
            local hh = hc and hc:FindFirstChildOfClass("Humanoid")
            if hh then
                local st = hh:GetState()
                if hh.PlatformStand or hh.Health <= 0 or st == Enum.HumanoidStateType.Ragdoll
                    or st == Enum.HumanoidStateType.FallingDown or st == Enum.HumanoidStateType.Physics
                    or st == Enum.HumanoidStateType.Dead then
                    carry = false; lastCarry = 0
                end
            end
            if carry then lastCarry = tick() end
            local on = (tick() - lastCarry) <= GRACE
            if on ~= SB.lastOn then
                SB.lastOn = on
                pcall(function() notify(on and ("Spin ON [" .. tostring(why) .. "]") or "Spin OFF", HotPink) end)
            end
            if not on then return end
            local c = LP.Character
            local part = c and (c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("UpperTorso") or c:FindFirstChild("Torso"))
            if part then
                part.CFrame = part.CFrame * CFrame.Angles(0, SPIN_SPEEDS[SB.idx].value, 0)
            end
        end)

        sbVisual = mkToggle(mainPage, "Spin Bot (auto brainrot)", function(on)
            SB.enabled = on
            if not on then lastCarry = 0 end
            saveAllSettings()
        end)
        sbBatVisual = mkToggle(mainPage, "Spin during Bat Aimbot", function(on)
            SB.batSpin = on
            saveAllSettings()
        end)
        local r = mkRow(mainPage, 30)
        mkLabel(r, "Spin Speed")
        sbSpeedBtn = mkSelector(r, SPIN_SPEEDS[SB.idx].name, {"Slow","Normal","Fast","Very Fast"}, function(b)
            SB.idx = (SB.idx % #SPIN_SPEEDS) + 1
            b.Text = SPIN_SPEEDS[SB.idx].name
            saveAllSettings()
        end)
        function SB.apply(enabled, idx, bat)
            SB.batSpin = bat == true
            if sbBatVisual then sbBatVisual(SB.batSpin) end
            if type(idx) == "number" and idx >= 1 and idx <= #SPIN_SPEEDS then SB.idx = math.floor(idx) end
            SB.enabled = enabled == true
            if sbSpeedBtn then sbSpeedBtn.Text = SPIN_SPEEDS[SB.idx].name end
            if sbVisual then sbVisual(SB.enabled) end
        end
    end

    mkSect(mainPage, "Keybinds")
    local function addKB(parent, label, entry)
        local r = mkRow(parent, 34); mkLabel(r, label); mkKeyButton(r, entry)
    end
    addKB(mainPage, "Carry Mode", KB.CarryToggle)
    addKB(mainPage, "Lagger Mode", KB.LaggerMode)
    addKB(mainPage, "Auto Left", KB.AutoLeft)
    addKB(mainPage, "Auto Right", KB.AutoRight)
    addKB(mainPage, "Auto Bat", KB.AutoBat)
    addKB(mainPage, "TP Bat", KB.Bypass)
    addKB(mainPage, "TP Down", KB.TPFloor)
    addKB(mainPage, "Drop Brainrot", KB.DropBrainrot)
    addKB(mainPage, "Insta Reset", KB.InstaReset)

    -- SPEED PAGE
    mkSect(speedPage, "Speed")
    do local r = mkRow(speedPage, 30); mkLabel(r, "Normal Speed"); normalBox = mkBox(r, NS, 50, 56, function(v) if v > 0 and v <= 500 then NS = v end; saveAllSettings() end) end
    do local r = mkRow(speedPage, 30); mkLabel(r, "Carry Speed"); carryBox = mkBox(r, CS, 50, 56, function(v) if v > 0 and v <= 500 then CS = v end; saveAllSettings() end) end
    do local r = mkRow(speedPage, 30); mkLabel(r, "Lagger 1 Speed"); laggerBox = mkBox(r, LAGGER_SPEED_1, 50, 56, function(v) if v > 0 and v <= 500 then LAGGER_SPEED_1 = v end; saveAllSettings() end) end
    do local r = mkRow(speedPage, 30); mkLabel(r, "Lagger 2 Speed"); lagger2Box = mkBox(r, LAGGER_SPEED_2, 50, 56, function(v) if v > 0 and v <= 500 then LAGGER_SPEED_2 = v end; saveAllSettings() end) end
    do
        local r = mkRow(speedPage, 30)
        mkLabel(r, "Current Mode")
        modeValLbl = Instance.new("TextLabel", r)
        modeValLbl.Size = UDim2.new(0, 110, 1, 0)
        modeValLbl.Position = UDim2.new(1, -118, 0, 0)
        modeValLbl.BackgroundTransparency = 1
        modeValLbl.Text = "Normal"
        modeValLbl.TextColor3 = LightPink
        modeValLbl.Font = Enum.Font.GothamBlack
        modeValLbl.TextSize = 11
        modeValLbl.TextXAlignment = Enum.TextXAlignment.Right
        modeValLbl.ZIndex = 8
        local clk = Instance.new("TextButton", r)
        clk.Size = UDim2.new(1, 0, 1, 0)
        clk.BackgroundTransparency = 1
        clk.Text = ""
        clk.AutoButtonColor = false
        clk.ZIndex = 8
        clk.MouseButton1Click:Connect(function() toggleCarryMode(); saveAllSettings() end)
    end

    mkSect(speedPage, "Jump & Movement")
    do
        local r = mkRow(speedPage, 30)
        mkLabel(r, "Infinite Jump")
        local pill, dot = mkPill(r, 50)
        local jumpOn = false
        setJumpToggleState = function(state)
            if jumpOn == state then return end
            jumpOn = state
            animPill(pill, dot, state)
            if state then startJumpMode() else stopJumpMode() end
            saveAllSettings()
        end
        local clk = Instance.new("TextButton", pill)
        clk.Size = UDim2.new(1, 0, 1, 0)
        clk.BackgroundTransparency = 1
        clk.Text = ""
        clk.AutoButtonColor = false
        clk.ZIndex = 10
        clk.MouseButton1Click:Connect(function()
            if editModeEnabled and not uiLocked then
                if jumpOn then stopJumpMode() else startJumpMode() end
            else
                setJumpToggleState(not jumpOn)
            end
        end)
        setJumpVisual = function(state) setJumpToggleState(state) end
    end
    autoLeftSetVisual = mkToggle(speedPage, "Auto Left", function(on)
        autoLeftEnabled = on
        if on then startAutoLeft() else stopAutoLeft() end
        if mobSetAutoLeft then mobSetAutoLeft(on) end
        saveAllSettings()
    end)
    autoRightSetVisual = mkToggle(speedPage, "Auto Right", function(on)
        autoRightEnabled = on
        if on then startAutoRight() else stopAutoRight() end
        if mobSetAutoRight then mobSetAutoRight(on) end
        saveAllSettings()
    end)

    mkSect(speedPage, "Drop & TP")
    dropBrainrotSetVisual = mkToggle(speedPage, "Drop Brainrot", function(on)
        if on then executeDropWithToggle(function(v) dropBrainrotSetVisual(v); if mobSetDropBR then mobSetDropBR(v) end end) end
    end)
    do
        local r = mkRow(speedPage, 30)
        mkLabel(r, "Drop Mode")
        dropModeBtnRef = mkSelector(r, dropMode == 1 and "Fling" or "Jump Drop", {"Fling","Jump Drop"}, function(btn)
            if dropActive then stopDropBrainrot() end
            dropMode = dropMode == 1 and 2 or 1
            btn.Text = dropMode == 1 and "Fling" or "Jump Drop"
            saveAllSettings()
        end)
    end
    do
        local r = mkRow(speedPage, 30)
        mkLabel(r, "TP Down")
        local clk = Instance.new("TextButton", r)
        clk.Size = UDim2.new(0.58, 0, 1, 0)
        clk.BackgroundTransparency = 1
        clk.Text = ""
        clk.AutoButtonColor = false
        clk.ZIndex = 8
        clk.MouseButton1Click:Connect(function() runTPDown() end)
        local a = Instance.new("TextLabel", r)
        a.Size = UDim2.new(0, 70, 1, 0)
        a.Position = UDim2.new(1, -78, 0, 0)
        a.BackgroundTransparency = 1
        a.Text = "ACTIVATE"
        a.TextColor3 = HotPink
        a.Font = Enum.Font.GothamBlack
        a.TextSize = 9
        a.TextXAlignment = Enum.TextXAlignment.Right
        a.ZIndex = 8
    end
    setAutoTPDownVisual = mkToggle(speedPage, "Auto TP Down", function(on)
        if on then startAutoTPDown() else stopAutoTPDown() end
        saveAllSettings()
    end)
    do local r = mkRow(speedPage, 30); mkLabel(r, "Height Y"); autoTPHeightBox = mkBox(r, autoTPDownHeight, 50, 56, function(v) if v and v >= 1 and v <= 500 then autoTPDownHeight = v end; saveAllSettings() end) end
    mirrorTPDownSetVisual = mkToggle(speedPage, "Mirror TP Down", function(on) setMirrorTPDownState(on) end)
    if mirrorTPDownSetVisual then mirrorTPDownSetVisual(mirrorTPDownEnabled) end
    setInstaResetVisual = mkToggle(speedPage, "Insta Reset", function(on)
        if on then
            FrameReset()
            task.delay(0.3, function() if setInstaResetVisual then setInstaResetVisual(false) end end)
        end
    end)

    -- COMBAT PAGE
    mkSect(combatPage, "Bat Skin")
    setBatSkinVisual = mkToggle(combatPage, "Bat Skin", function(on)
        katanaSkinEnabled = on
        pcall(function() katanaSkinController.ApplySkin(on and "KATANA" or "NONE") end)
        saveAllSettings()
    end)
    MinecraftBatSetVisual = mkToggle(combatPage, "Minecraft Bat", function(on)
        minecraftBatSkinEnabled = on
        minecraftBatSkinController.State.enabled = on
        if on then pcall(minecraftBatSkinController.Apply) else pcall(minecraftBatSkinController.Remove) end
        saveAllSettings()
    end)
    do
        local mcColors = {"Default","Abyss Blue","Venom Green","Royal Gold","Velvet Rose","Crimson Night","RGB"}
        local r = mkRow(combatPage, 30)
        mkLabel(r, "MC Bat Color")
        mcBatColorBtn = mkSelector(r, minecraftBatSkinColorMode, mcColors, function(btn)
            local idx = table.find(mcColors, minecraftBatSkinColorMode) or 1
            minecraftBatSkinColorMode = mcColors[idx % #mcColors + 1]
            btn.Text = minecraftBatSkinColorMode
            pcall(minecraftBatSkinController.SetColorMode, minecraftBatSkinColorMode)
            saveAllSettings()
        end)
    end

    mkSect(combatPage, "Aimbots")
    autoBatSetVisual = mkToggle(combatPage, "Auto Bat", function(on)
        if on then enableAutoBat() else disableAutoBat() end
        if mobSetAutoBat then mobSetAutoBat(on) end
        saveAllSettings()
    end)
    do local r = mkRow(combatPage, 30); mkLabel(r, "Aimbot Speed"); aimbotSpeedBox = mkBox(r, BAT_AIMBOT_SPEED, 50, 56, function(v) if v and v > 0 and v <= 500 then BAT_AIMBOT_SPEED = v end; saveAllSettings() end) end
    do
        local r = mkRow(combatPage, 30)
        mkLabel(r, "Aimbot Mode")
        aimbotModeBtn = mkSelector(r, _aimbotModeText(), {"Bat Aimbot","Bypass"}, function(btn)
            setAimbotMode(aimbotMode == 1 and 2 or 1)
            btn.Text = _aimbotModeText()
            saveAllSettings()
        end)
    end
    batDesyncTpSetVisual = mkToggle(combatPage, "TP Bat", function(on)
        if on then if not batDesyncTpEnabled then toggleBatDesyncTp() end
        else if batDesyncTpEnabled then toggleBatDesyncTp() end end
        saveAllSettings()
    end)
    bypassSetVisual = batDesyncTpSetVisual
    do local r = mkRow(combatPage, 30); mkLabel(r, "TP Bat Distance (studs)"); tpBatDistBox = mkBox(r, _TpBat.distance, 50, 56, function(v) if v and v >= 0 and v <= 100 then _TpBat.distance = v; saveAllSettings() end end) end

    mkSect(combatPage, "Counters")
    setBatCounterVisual = mkToggle(combatPage, "Bat Counter", function(on) setBatCounterState(on); saveAllSettings() end)
    setMedusaVisual = mkToggle(combatPage, "Medusa Counter", function(on) setMedusaCounterState(on); saveAllSettings() end)
        _G.setMedusaRangeVisual = mkToggle(combatPage, "Medusa Range Circle", function(on)
        if _G.B2JEMedusaRange then _G.B2JEMedusaRange.SetEnabled(on) end
        saveAllSettings()
    end)
    setAutoResetOnMedVisual = mkToggle(combatPage, "Reset After Medusa", function(on) setAutoResetOnMedState(on) end)
    if setAutoResetOnMedVisual then setAutoResetOnMedVisual(autoResetOnMedEnabled) end

    mkSect(combatPage, "Defense")
    setAntiRagVisual = mkToggle(combatPage, "Anti Ragdoll", function(on) setAntiRag(on); saveAllSettings() end)
    bodyLockSetVisual = mkToggle(combatPage, "Body Lock", function(on)
        bodyLockEnabled = on
        if on then if _blSuppressCount == 0 then startBodyLock() end else stopBodyLock() end
        saveAllSettings()
    end)
    do local r = mkRow(combatPage, 30); mkLabel(r, "Body Lock Range"); bodyLockRangeBox = mkBox(r, bodyLockRange, 50, 56, function(v) if v and v > 0 then bodyLockRange = math.clamp(math.floor(v), 5, 200); if bodyLockRangeBox then bodyLockRangeBox.Text = tostring(bodyLockRange) end; saveAllSettings() end end) end

    -- VISUAL PAGE
    mkSect(visualPage, "Visual")
    do
        local r = mkRow(visualPage, 30)
        mkLabel(r, "Button Style")
        local c = Instance.new("Frame", r)
        c.Size = UDim2.new(0, 160, 1, 0)
        c.Position = UDim2.new(1, -168, 0, 0)
        c.BackgroundTransparency = 1
        c.ZIndex = 8
        local lb = Instance.new("TextButton", c)
        lb.Size = UDim2.new(0, 32, 0, 26); lb.Position = UDim2.new(0, 0, 0.5, -13)
        lb.BackgroundColor3 = BgTab; lb.Text = "<"
        lb.TextColor3 = LightPink; lb.Font = Enum.Font.GothamBlack; lb.TextSize = 13; lb.ZIndex = 9
        Instance.new("UICorner", lb).CornerRadius = UDim.new(0, 6)
        local styleLabel = Instance.new("TextLabel", c)
        styleLabel.Size = UDim2.new(0, 88, 0, 26); styleLabel.Position = UDim2.new(0.5, -44, 0.5, -13)
        styleLabel.BackgroundTransparency = 1
        styleLabel.Text = (FLOAT_STYLE_NAMES and FLOAT_STYLE_NAMES[floatStyleIndex]) or "Pumpkin"
        styleLabel.TextColor3 = LightPink; styleLabel.Font = Enum.Font.GothamBlack
        styleLabel.TextScaled = true; styleLabel.ZIndex = 9
        local sc = Instance.new("UITextSizeConstraint", styleLabel)
        sc.MaxTextSize = 12; sc.MinTextSize = 7
        local rb = Instance.new("TextButton", c)
        rb.Size = UDim2.new(0, 32, 0, 26); rb.Position = UDim2.new(1, -32, 0.5, -13)
        rb.BackgroundColor3 = BgTab; rb.Text = ">"
        rb.TextColor3 = LightPink; rb.Font = Enum.Font.GothamBlack; rb.TextSize = 13; rb.ZIndex = 9
        Instance.new("UICorner", rb).CornerRadius = UDim.new(0, 6)
        local function changeStyle(dir)
            local total = #FLOAT_STYLES
            local idx = (floatStyleIndex or 1) + dir
            if idx < 1 then idx = total end
            if idx > total then idx = 1 end
            floatStyleIndex = idx
            styleLabel.Text = (FLOAT_STYLE_NAMES and FLOAT_STYLE_NAMES[idx]) or "Pumpkin"
            applyFloatStyleAll()
            saveAllSettings()
        end
        lb.MouseButton1Click:Connect(function() changeStyle(-1) end)
        rb.MouseButton1Click:Connect(function() changeStyle(1) end)
        refreshFloatStyleLabel = function()
            styleLabel.Text = (FLOAT_STYLE_NAMES and FLOAT_STYLE_NAMES[floatStyleIndex]) or "Pumpkin"
        end
    end
    do
        local r = mkRow(visualPage, 30)
        mkLabel(r, "Button Background")
        local c = Instance.new("Frame", r)
        c.Size = UDim2.new(0, 160, 1, 0)
        c.Position = UDim2.new(1, -168, 0, 0)
        c.BackgroundTransparency = 1
        c.ZIndex = 8
        local lb = Instance.new("TextButton", c)
        lb.Size = UDim2.new(0, 32, 0, 26); lb.Position = UDim2.new(0, 0, 0.5, -13)
        lb.BackgroundColor3 = BgTab; lb.Text = "<"
        lb.TextColor3 = LightPink; lb.Font = Enum.Font.GothamBlack; lb.TextSize = 13; lb.ZIndex = 9
        Instance.new("UICorner", lb).CornerRadius = UDim.new(0, 6)
        local bgLbl = Instance.new("TextLabel", c)
        bgLbl.Size = UDim2.new(0, 80, 0, 26); bgLbl.Position = UDim2.new(0.5, -40, 0.5, -13)
        bgLbl.BackgroundTransparency = 1
        bgLbl.Text = (currentButtonBgIndex == 0) and "Off" or ("Bg " .. currentButtonBgIndex)
        bgLbl.TextColor3 = LightPink; bgLbl.Font = Enum.Font.GothamBlack; bgLbl.TextSize = 12; bgLbl.ZIndex = 9
        local rb = Instance.new("TextButton", c)
        rb.Size = UDim2.new(0, 32, 0, 26); rb.Position = UDim2.new(1, -32, 0.5, -13)
        rb.BackgroundColor3 = BgTab; rb.Text = ">"
        rb.TextColor3 = LightPink; rb.Font = Enum.Font.GothamBlack; rb.TextSize = 13; rb.ZIndex = 9
        Instance.new("UICorner", rb).CornerRadius = UDim.new(0, 6)
        local function upd(dir)
            local total = #ButtonBackgroundImages + 1
            local idx = currentButtonBgIndex + 1
            local ni = idx + dir
            if ni < 1 then ni = total end
            if ni > total then ni = 1 end
            currentButtonBgIndex = ni - 1
            bgLbl.Text = (currentButtonBgIndex == 0) and "Off" or ("Bg " .. currentButtonBgIndex)
            applyButtonBackground(currentButtonBgIndex)
            saveAllSettings()
        end
        lb.MouseButton1Click:Connect(function() upd(-1) end)
        rb.MouseButton1Click:Connect(function() upd(1) end)
    end
    do
        local r = mkRow(visualPage, 30)
        mkLabel(r, "Sky Theme")
        local c = Instance.new("Frame", r)
        c.Size = UDim2.new(0, 160, 1, 0)
        c.Position = UDim2.new(1, -168, 0, 0)
        c.BackgroundTransparency = 1
        c.ZIndex = 8
        local lb = Instance.new("TextButton", c)
        lb.Size = UDim2.new(0, 32, 0, 26); lb.Position = UDim2.new(0, 0, 0.5, -13)
        lb.BackgroundColor3 = BgTab; lb.Text = "<"
        lb.TextColor3 = LightPink; lb.Font = Enum.Font.GothamBlack; lb.TextSize = 13; lb.ZIndex = 9
        Instance.new("UICorner", lb).CornerRadius = UDim.new(0, 6)
        skySelectorLabel = Instance.new("TextLabel", c)
        skySelectorLabel.Size = UDim2.new(0, 80, 0, 26); skySelectorLabel.Position = UDim2.new(0.5, -40, 0.5, -13)
        skySelectorLabel.BackgroundTransparency = 1
        skySelectorLabel.Text = currentSkyTheme
        skySelectorLabel.TextColor3 = LightPink; skySelectorLabel.Font = Enum.Font.GothamBlack
        skySelectorLabel.TextSize = 12; skySelectorLabel.ZIndex = 9
        local rb = Instance.new("TextButton", c)
        rb.Size = UDim2.new(0, 32, 0, 26); rb.Position = UDim2.new(1, -32, 0.5, -13)
        rb.BackgroundColor3 = BgTab; rb.Text = ">"
        rb.TextColor3 = LightPink; rb.Font = Enum.Font.GothamBlack; rb.TextSize = 13; rb.ZIndex = 9
        Instance.new("UICorner", rb).CornerRadius = UDim.new(0, 6)
        local function upd(dir)
            local idx = 1
            for i, e in ipairs(CANDY_SKY_ORDER) do if e[2] == currentSkyTheme then idx = i; break end end
            local ni = idx + dir
            if ni < 1 then ni = #CANDY_SKY_ORDER end
            if ni > #CANDY_SKY_ORDER then ni = 1 end
            setSkyTheme(CANDY_SKY_ORDER[ni][2])
            saveAllSettings()
        end
        lb.MouseButton1Click:Connect(function() upd(-1) end)
        rb.MouseButton1Click:Connect(function() upd(1) end)
    end
    do
        local r = mkRow(visualPage, 30)
        mkLabel(r, "Pack Accessory")
        local c = Instance.new("Frame", r)
        c.Size = UDim2.new(0, 160, 1, 0)
        c.Position = UDim2.new(1, -168, 0, 0)
        c.BackgroundTransparency = 1
        c.ZIndex = 8
        local lb = Instance.new("TextButton", c)
        lb.Size = UDim2.new(0, 32, 0, 26); lb.Position = UDim2.new(0, 0, 0.5, -13)
        lb.BackgroundColor3 = BgTab; lb.Text = "<"
        lb.TextColor3 = LightPink; lb.Font = Enum.Font.GothamBlack; lb.TextSize = 13; lb.ZIndex = 9
        Instance.new("UICorner", lb).CornerRadius = UDim.new(0, 6)
        accSelectorLabel = Instance.new("TextLabel", c)
        accSelectorLabel.Size = UDim2.new(0, 80, 0, 26); accSelectorLabel.Position = UDim2.new(0.5, -40, 0.5, -13)
        accSelectorLabel.BackgroundTransparency = 1
        accSelectorLabel.Text = currentAccessoryPack
        accSelectorLabel.TextColor3 = LightPink; accSelectorLabel.Font = Enum.Font.GothamBlack
        accSelectorLabel.TextSize = 12; accSelectorLabel.ZIndex = 9
        local rb = Instance.new("TextButton", c)
        rb.Size = UDim2.new(0, 32, 0, 26); rb.Position = UDim2.new(1, -32, 0.5, -13)
        rb.BackgroundColor3 = BgTab; rb.Text = ">"
        rb.TextColor3 = LightPink; rb.Font = Enum.Font.GothamBlack; rb.TextSize = 13; rb.ZIndex = 9
        Instance.new("UICorner", rb).CornerRadius = UDim.new(0, 6)
        local function upd(dir)
            local idx = 1
            for i, e in ipairs(ACCESSORY_PACK_ORDER) do if e[2] == currentAccessoryPack then idx = i; break end end
            local ni = idx + dir
            if ni < 1 then ni = #ACCESSORY_PACK_ORDER end
            if ni > #ACCESSORY_PACK_ORDER then ni = 1 end
            local pack = ACCESSORY_PACK_ORDER[ni][2]
            currentAccessoryPack = pack
            accSelectorLabel.Text = pack
            applyAccessoryPack(pack)
            saveAllSettings()
        end
        lb.MouseButton1Click:Connect(function() upd(-1) end)
        rb.MouseButton1Click:Connect(function() upd(1) end)
    end
    do
        local r = mkRow(visualPage, 30)
        mkLabel(r, "Anim Pack")
        local c = Instance.new("Frame", r)
        c.Size = UDim2.new(0, 160, 1, 0)
        c.Position = UDim2.new(1, -168, 0, 0)
        c.BackgroundTransparency = 1
        c.ZIndex = 8
        local lb = Instance.new("TextButton", c)
        lb.Size = UDim2.new(0, 32, 0, 26); lb.Position = UDim2.new(0, 0, 0.5, -13)
        lb.BackgroundColor3 = BgTab; lb.Text = "<"
        lb.TextColor3 = LightPink; lb.Font = Enum.Font.GothamBlack; lb.TextSize = 13; lb.ZIndex = 9
        Instance.new("UICorner", lb).CornerRadius = UDim.new(0, 6)
        animSelectorLabel = Instance.new("TextLabel", c)
        animSelectorLabel.Size = UDim2.new(0, 80, 0, 26); animSelectorLabel.Position = UDim2.new(0.5, -40, 0.5, -13)
        animSelectorLabel.BackgroundTransparency = 1
        animSelectorLabel.Text = currentAnimPack
        animSelectorLabel.TextColor3 = LightPink; animSelectorLabel.Font = Enum.Font.GothamBlack
        animSelectorLabel.TextSize = 12; animSelectorLabel.ZIndex = 9
        local rb = Instance.new("TextButton", c)
        rb.Size = UDim2.new(0, 32, 0, 26); rb.Position = UDim2.new(1, -32, 0.5, -13)
        rb.BackgroundColor3 = BgTab; rb.Text = ">"
        rb.TextColor3 = LightPink; rb.Font = Enum.Font.GothamBlack; rb.TextSize = 13; rb.ZIndex = 9
        Instance.new("UICorner", rb).CornerRadius = UDim.new(0, 6)
        local function upd(dir)
            local idx = 1
            for i, e in ipairs(ANIM_PACK_ORDER) do if e[2] == currentAnimPack then idx = i; break end end
            local ni = idx + dir
            if ni < 1 then ni = #ANIM_PACK_ORDER end
            if ni > #ANIM_PACK_ORDER then ni = 1 end
            local pack = ANIM_PACK_ORDER[ni][2]
            if pack == "Off" then stopAnimPack() else startAnimPack(pack) end
            saveAllSettings()
        end
        lb.MouseButton1Click:Connect(function() upd(-1) end)
        rb.MouseButton1Click:Connect(function() upd(1) end)
    end
    do
        local r = mkRow(visualPage, 30)
        mkLabel(r, "Outfit")
        local c = Instance.new("Frame", r)
        c.Size = UDim2.new(0, 160, 1, 0)
        c.Position = UDim2.new(1, -168, 0, 0)
        c.BackgroundTransparency = 1
        c.ZIndex = 8
        local lb = Instance.new("TextButton", c)
        lb.Size = UDim2.new(0, 32, 0, 26); lb.Position = UDim2.new(0, 0, 0.5, -13)
        lb.BackgroundColor3 = BgTab; lb.Text = "<"
        lb.TextColor3 = LightPink; lb.Font = Enum.Font.GothamBlack; lb.TextSize = 13; lb.ZIndex = 9
        Instance.new("UICorner", lb).CornerRadius = UDim.new(0, 6)
        outfitSelectorLabel = Instance.new("TextLabel", c)
        outfitSelectorLabel.Size = UDim2.new(0, 80, 0, 26); outfitSelectorLabel.Position = UDim2.new(0.5, -40, 0.5, -13)
        outfitSelectorLabel.BackgroundTransparency = 1
        outfitSelectorLabel.Text = OUTFITS[currentOutfitIndex] and OUTFITS[currentOutfitIndex].label or "OFF"
        outfitSelectorLabel.TextColor3 = LightPink; outfitSelectorLabel.Font = Enum.Font.GothamBlack
        outfitSelectorLabel.TextSize = 12; outfitSelectorLabel.ZIndex = 9
        local rb = Instance.new("TextButton", c)
        rb.Size = UDim2.new(0, 32, 0, 26); rb.Position = UDim2.new(1, -32, 0.5, -13)
        rb.BackgroundColor3 = BgTab; rb.Text = ">"
        rb.TextColor3 = LightPink; rb.Font = Enum.Font.GothamBlack; rb.TextSize = 13; rb.ZIndex = 9
        Instance.new("UICorner", rb).CornerRadius = UDim.new(0, 6)
        local function cyc(dir)
            local n = #OUTFITS
            currentOutfitIndex = currentOutfitIndex + dir
            if currentOutfitIndex < 1 then currentOutfitIndex = n end
            if currentOutfitIndex > n then currentOutfitIndex = 1 end
            applyOutfitByIndex(currentOutfitIndex)
            saveAllSettings()
        end
        lb.MouseButton1Click:Connect(function() cyc(-1) end)
        rb.MouseButton1Click:Connect(function() cyc(1) end)
    end
    setESPVIsual = mkToggle(visualPage, "Player ESP", function(on) toggleESP(on); saveAllSettings() end)
        do
        local r = mkRow(visualPage, 30)
        mkLabel(r, "Custom Skin Gallery")
        local b = Instance.new("TextButton", r)
        b.Size = UDim2.new(0, 100, 0, 22)
        b.Position = UDim2.new(1, -108, 0.5, -11)
        b.BackgroundColor3 = BgTab
        b.BorderSizePixel = 0
        b.Text = "OPEN"
        b.TextColor3 = LightPink
        b.Font = Enum.Font.GothamBlack
        b.TextSize = 11
        b.ZIndex = 8
        b.AutoButtonColor = false
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
        local st = Instance.new("UIStroke", b)
        st.Color = BorderSoft; st.Thickness = 1; st.Transparency = 0.3
        b.MouseEnter:Connect(function()
            TS:Create(b, TweenInfo.new(0.12), {BackgroundColor3 = BgRowHover}):Play()
            TS:Create(st, TweenInfo.new(0.12), {Color = HotPink, Transparency = 0}):Play()
        end)
        b.MouseLeave:Connect(function()
            TS:Create(b, TweenInfo.new(0.12), {BackgroundColor3 = BgTab}):Play()
            TS:Create(st, TweenInfo.new(0.12), {Color = BorderSoft, Transparency = 0.3}):Play()
        end)
        b.MouseButton1Click:Connect(function()
            if _G._KawatanOpenSkinGallery then
                pcall(_G._KawatanOpenSkinGallery)
            end
        end)
    end
    if setESPVIsual then setESPVIsual(espEnabled) end
    setESPLineVisual = mkToggle(visualPage, "ESP Line", function(on) toggleESPLine(on); saveAllSettings() end)
    if setESPLineVisual then setESPLineVisual(espLineEnabled) end
    setVividVisual = mkToggle(visualPage, "Vivid Graphics", function(on) toggleVividGraphics(on); saveAllSettings() end)
    if setVividVisual then setVividVisual(vividGraphicsEnabled) end
    local stretchSetter
    stretchSetter = mkToggle(visualPage, "Stretch Rez", function(on)
        if on then enableStretch() else disableStretch() end
        stretchEnabled = on
        saveAllSettings()
    end)
    _G.stretchToggleSetter = stretchSetter
    stretchSetter(stretchEnabled)
    setAntiLagVisual = mkToggle(visualPage, "Anti Lag", function(on)
        if on then enableAntiLag() else disableAntiLag() end
        saveAllSettings()
    end)
    do
        local optSetVisual = mkToggle(visualPage, "Optimizer", function(on)
            if _G.LustOptimizerToggle then
                _G.LustOptimizerToggle(on)
            elseif _G.LustOptimizerNotify then
                _G.LustOptimizerNotify("Erreur : " .. tostring(_G.LustOptimizerError or "optimizer non charge"))
            end
        end)
        if optSetVisual then
            optSetVisual(_G.LustOptimizerIsOn == nil or _G.LustOptimizerIsOn())
        end
    end

    -- SETS PAGE
    mkSect(setsPage, "Interface")
    setEditModeVisual = mkToggle(setsPage, "Edit Button", function(on) toggleEditMode(on) end)
    if setEditModeVisual then setEditModeVisual(editModeEnabled) end
    setLockUIVisual = mkToggle(setsPage, "Lock UI", function(on) toggleLockUI(on) end)
    
    -- HIDE BUTTONS TOGGLE
    mkToggle(setsPage, "Hide Buttons", function(on)
        hideMobileButtons = on
        if MobilePanel and MobilePanel:FindFirstChild("FloatingPanel") then
            MobilePanel.FloatingPanel.Visible = not on
        end
        if instaResetFloatingButton then
            local f = instaResetFloatingButton:FindFirstChild("Frame")
            if f then f.Visible = not on end
        end
        if bypassFloatingButton then
            local f = bypassFloatingButton:FindFirstChild("Frame")
            if f then f.Visible = not on end
        end
        saveAllSettings()
    end)

    do
        local row = mkRow(setsPage, 34)
        mkLabel(row, "Reset Button Position")
        local rb = Instance.new("TextButton", row)
        rb.Size = UDim2.new(0, 80, 0, 22)
        rb.Position = UDim2.new(1, -88, 0.5, -11)
        rb.BackgroundColor3 = BgTab
        rb.BorderSizePixel = 0
        rb.Text = "RESET"
        rb.TextColor3 = LightPink
        rb.Font = Enum.Font.GothamBlack
        rb.TextSize = 9
        rb.ZIndex = 8
        rb.AutoButtonColor = false
        Instance.new("UICorner", rb).CornerRadius = UDim.new(0, 6)
        rb.MouseButton1Click:Connect(function()
            local ok = pcall(resetButtonPositions)
            notify(ok and "Boutons remis a leur place" or "Erreur reset positions")
        end)
    end

    local function mkSliderRow(page, labelText, initial, delta, lo, hi, onChange)
        local r = mkRow(page, 34)
        mkLabel(r, labelText)
        local c = Instance.new("Frame", r)
        c.Size = UDim2.new(0, 150, 1, 0)
        c.Position = UDim2.new(1, -160, 0, 0)
        c.BackgroundTransparency = 1
        c.ZIndex = 8
        local lb = Instance.new("TextButton", c)
        lb.Size = UDim2.new(0, 32, 0, 26); lb.Position = UDim2.new(0, 0, 0.5, -13)
        lb.BackgroundColor3 = BgTab; lb.Text = "<"
        lb.TextColor3 = LightPink; lb.Font = Enum.Font.GothamBlack; lb.TextSize = 13; lb.ZIndex = 9
        Instance.new("UICorner", lb).CornerRadius = UDim.new(0, 6)
        local v = Instance.new("TextLabel", c)
        v.Size = UDim2.new(0, 70, 0, 26); v.Position = UDim2.new(0.5, -35, 0.5, -13)
        v.BackgroundTransparency = 1
        v.Text = initial; v.TextColor3 = LightPink; v.Font = Enum.Font.GothamBlack
        v.TextSize = 12; v.ZIndex = 9
        local rb = Instance.new("TextButton", c)
        rb.Size = UDim2.new(0, 32, 0, 26); rb.Position = UDim2.new(1, -32, 0.5, -13)
        rb.BackgroundColor3 = BgTab; rb.Text = ">"
        rb.TextColor3 = LightPink; rb.Font = Enum.Font.GothamBlack; rb.TextSize = 13; rb.ZIndex = 9
        Instance.new("UICorner", rb).CornerRadius = UDim.new(0, 6)
        lb.MouseButton1Click:Connect(function() onChange(-delta) end)
        rb.MouseButton1Click:Connect(function() onChange(delta) end)
        return v
    end

    _G.buttonScaleValueLabel = mkSliderRow(setsPage, "Button Scale", string.format("%.2f", buttonScaleValue), 0.05, 0.5, 1.5, function(d)
        local nv = math.clamp(buttonScaleValue + d, 0.5, 1.5)
        if nv ~= buttonScaleValue then
            buttonScaleValue = nv
            _G.buttonScaleValueLabel.Text = string.format("%.2f", nv)
            applyButtonScale(nv); saveAllSettings()
        end
    end)
    _G.uiScaleValueLabel = mkSliderRow(setsPage, "UI Scale", string.format("%.2f", uiScaleValue/100), 5, 50, 150, function(d)
        local nv = math.clamp(uiScaleValue + d, 50, 150)
        if nv ~= uiScaleValue then
            uiScaleValue = nv
            if mainUIScale then mainUIScale.Scale = nv/100 end
            applyStealBarScale()
            _G.uiScaleValueLabel.Text = string.format("%.2f", nv/100)
            saveAllSettings()
        end
    end)
    _G.stealBarSizeLabel = mkSliderRow(setsPage, "Steal Bar Size", string.format("%.2f", stealBarSize/100), 10, 50, 200, function(d)
        local nv = math.clamp((stealBarSize or 100) + d, 50, 200)
        if nv ~= stealBarSize then
            stealBarSize = nv
            applyStealBarScale()
            _G.stealBarSizeLabel.Text = string.format("%.2f", nv/100)
            saveAllSettings()
        end
    end)

    do
        local r = mkRow(setsPage, 30)
        mkLabel(r, "Steal Bar Style")
        local btn = mkSelector(r, stealBarStyle, {"Compact","Classic"}, function(b)
            local newStyle = (stealBarStyle == "Compact") and "Classic" or "Compact"
            buildStealBar(newStyle)
            b.Text = newStyle
            saveAllSettings()
        end)
        _G.stealBarStyleBtn = btn
    end

    mkSect(setsPage, "Anti Die")
    do
        local AD = { on = false }
        _G.B2AntiDie2 = AD
        local adVisual
        local hbConn, charConn
        local conns = {}

        local function clearConns()
            for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
            conns = {}
            if hbConn then hbConn:Disconnect(); hbConn = nil end
        end

        local function protectChar(char)
            if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 5)
            if not hum then return end
            pcall(function()
                hum.MaxHealth = math.huge
                hum.Health = math.huge
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
            end)
            table.insert(conns, hum.StateChanged:Connect(function(_, new)
                if AD.on and new == Enum.HumanoidStateType.Dead then
                    pcall(function() hum.Health = math.huge; hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false) end)
                end
            end))
            table.insert(conns, hum:GetPropertyChangedSignal("Health"):Connect(function()
                if AD.on and hum.Health < hum.MaxHealth then pcall(function() hum.Health = math.huge end) end
            end))
            hbConn = RunService.Heartbeat:Connect(function()
                if AD.on and hum.Parent and hum.Health < hum.MaxHealth then
                    pcall(function() hum.Health = math.huge end)
                end
            end)
        end

        local function startAD()
            clearConns()
            if charConn then charConn:Disconnect(); charConn = nil end
            protectChar(LP.Character)
            charConn = LP.CharacterAdded:Connect(function(char)
                if not AD.on then return end
                task.wait(0.1)
                clearConns()
                protectChar(char)
            end)
        end
        local function stopAD()
            clearConns()
            if charConn then charConn:Disconnect(); charConn = nil end
            local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                pcall(function()
                    hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
                    hum.MaxHealth = 100
                    hum.Health = 100
                end)
            end
        end

        adVisual = mkToggle(setsPage, "Anti Die", function(on)
            AD.on = on
            if on then startAD() else stopAD() end
            saveAllSettings()
        end)

        function AD.apply(on)
            on = on == true
            if on == AD.on then
                if adVisual then adVisual(on) end
                return
            end
            AD.on = on
            if adVisual then adVisual(on) end
            if on then startAD() else stopAD() end
        end
    end

    mkSect(setsPage, "Config")
    do
        local r = mkRow(setsPage, 42)
        local b = Instance.new("TextButton", r)
        b.Size = UDim2.new(1, -12, 0.78, 0); b.Position = UDim2.new(0, 6, 0.11, 0)
        b.BackgroundColor3 = HotPink; b.BorderSizePixel = 0
        b.Text = "SAVE POSITIONS"; b.TextColor3 = White
        b.Font = Enum.Font.GothamBlack; b.TextSize = 12
        b.AutoButtonColor = false; b.ZIndex = 8
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
        local st = Instance.new("UIStroke", b); st.Color = LightPink; st.Thickness = 1; st.Transparency = 0.4
        b.MouseEnter:Connect(function() TS:Create(b, TweenInfo.new(0.12), {BackgroundColor3 = LightPink}):Play() end)
        b.MouseLeave:Connect(function() TS:Create(b, TweenInfo.new(0.12), {BackgroundColor3 = HotPink}):Play() end)
        b.MouseButton1Click:Connect(function()
            saveAllPositions()
            b.Text = "✓ SAVED"
            task.delay(1.2, function() if b and b.Parent then b.Text = "SAVE POSITIONS" end end)
        end)
    end
    do
        local r = mkRow(setsPage, 42)
        local b = Instance.new("TextButton", r)
        b.Size = UDim2.new(1, -12, 0.78, 0); b.Position = UDim2.new(0, 6, 0.11, 0)
        b.BackgroundColor3 = HotPink; b.BorderSizePixel = 0
        b.Text = "SAVE NOW"; b.TextColor3 = White
        b.Font = Enum.Font.GothamBlack; b.TextSize = 12
        b.AutoButtonColor = false; b.ZIndex = 8
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
        local st = Instance.new("UIStroke", b); st.Color = LightPink; st.Thickness = 1; st.Transparency = 0.4
        b.MouseEnter:Connect(function() TS:Create(b, TweenInfo.new(0.12), {BackgroundColor3 = LightPink}):Play() end)
        b.MouseLeave:Connect(function() TS:Create(b, TweenInfo.new(0.12), {BackgroundColor3 = HotPink}):Play() end)
        b.MouseButton1Click:Connect(function()
            if normalBox then local n = tonumber(normalBox.Text); if n then NS = n end end
            if carryBox then local n = tonumber(carryBox.Text); if n then CS = n end end
            if laggerBox then local n = tonumber(laggerBox.Text); if n then LAGGER_SPEED_1 = n end end
            if lagger2Box then local n = tonumber(lagger2Box.Text); if n then LAGGER_SPEED_2 = n end end
            if radInput then local n = tonumber(radInput.Text); if n then CONFIG.STEAL_RANGE = n; Steal.StealRadius = n end end
            if autoTPHeightBox then local n = tonumber(autoTPHeightBox.Text); if n then autoTPDownHeight = n end end
            if bodyLockRangeBox then local n = tonumber(bodyLockRangeBox.Text); if n then bodyLockRange = n end end
            if aimbotSpeedBox then local n = tonumber(aimbotSpeedBox.Text); if n then BAT_AIMBOT_SPEED = n end end
            if stealDurationBox then local n = tonumber(stealDurationBox.Text); if n then Steal.StealDuration = n end end
            saveAllPositions()
            if mainUIScale then uiScaleValue = math.clamp(math.floor(mainUIScale.Scale * 100 + 0.5), 50, 150) end
            if _G.uiScaleValueLabel then _G.uiScaleValueLabel.Text = string.format("%.2f", uiScaleValue/100) end
            _lastSavedJSON = nil
            local ok = saveAllSettings()
            b.Text = ok and "✓ SAVED" or "ERROR"
            notify(ok and "Config saved" or "Save failed", ok and HotPink or Danger)
            task.delay(1.2, function() if b and b.Parent then b.Text = "SAVE NOW" end end)
        end)
    end
    do
        local r = mkRow(setsPage, 42)
        local b = Instance.new("TextButton", r)
        b.Size = UDim2.new(1, -12, 0.78, 0); b.Position = UDim2.new(0, 6, 0.11, 0)
        b.BackgroundColor3 = Color3.fromRGB(60, 20, 40); b.BorderSizePixel = 0
        b.Text = "DELETE SETTINGS"; b.TextColor3 = White
        b.Font = Enum.Font.GothamBlack; b.TextSize = 12
        b.AutoButtonColor = false; b.ZIndex = 8
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
        local st = Instance.new("UIStroke", b); st.Color = Danger; st.Thickness = 1; st.Transparency = 0.5
        local state, db = 0, false
        b.MouseButton1Click:Connect(function()
            if db then return end
            if state == 0 then
                state = 1; b.Text = "CONFIRM?"
                TS:Create(b, TweenInfo.new(0.15), {BackgroundColor3 = Danger}):Play()
                task.delay(2, function()
                    if b and b.Parent and state == 1 then
                        state = 0; b.Text = "DELETE SETTINGS"
                        TS:Create(b, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(60, 20, 40)}):Play()
                    end
                end)
            elseif state == 1 then
                db = true
                if isfile and isfile(CONFIG_FILE) then pcall(delfile, CONFIG_FILE) end
                b.Text = "✓ DELETED"
                state = 0
                notify("Config deleted", Danger)
                task.delay(1.5, function()
                    if b and b.Parent then
                        b.Text = "DELETE SETTINGS"
                        TS:Create(b, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(60, 40, 40)}):Play()
                        db = false
                    end
                end)
            end
        end)
    end

    -- FOOTER
    local footer = Instance.new("Frame", main)
    footer.Name = "Footer"
    footer.Size = UDim2.new(1, -PAD*2, 0, FOOTER_H)
    footer.Position = UDim2.new(0, PAD, 1, -FOOTER_H - 8)
    footer.BackgroundTransparency = 1
    footer.ZIndex = 14
    local footLbl = Instance.new("TextLabel", footer)
    footLbl.Size = UDim2.new(1, 0, 1, 0)
    footLbl.BackgroundTransparency = 1
    footLbl.Text = "B2/JE HUB - BUYER"
    footLbl.TextColor3 = TextMuted
    footLbl.Font = Enum.Font.GothamBold
    footLbl.TextSize = 10
    footLbl.TextXAlignment = Enum.TextXAlignment.Center
    footLbl.ZIndex = 15

    -- Steal Bar
    buildStealBar(stealBarStyle)

    applyTextStyleRecursive(main, {[titleLabel] = true})
    if miniBtn then applyTextStyle(miniBtn, 14) end
end

-- MENU TOGGLE KEY
do
    local MENU_KEY = Enum.KeyCode.RightShift
    UIS.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == MENU_KEY then
            if main and main.Visible then
                if hideGui then hideGui() end
                if _G.B2Notify then _G.B2Notify("Menu hidden", Color3.fromRGB(255, 20, 147)) end
            else
                if showGui then showGui() end
                if _G.B2Notify then _G.B2Notify("Menu opened", Color3.fromRGB(255, 150, 200)) end
            end
        end
    end)
end

-- ANTI DIE / KICK / BAT SKIN
_tick = tick
antiDieEnabled = false
antiKickEnabled = false
katanaSkinEnabled = false
setAntiDieVisual = nil
setSafeModeVisual = nil
setKickWarningVisual = nil
setBatSkinVisual = nil
mcBatColorBtn = nil

_antiDieEnabled = false
_antiDieStopped = false
_antiDieSources = { toggle = false, autobat = false }
_antiDie = {
    enabled = false, loop = nil, healthConn = nil, charConn = nil,
    lastHealTime = 0, invincibleUntil = 0,
    config = { healthThreshold = 50, invincibilityFrames = 0.75, fallDamageProtection = false, ragdollProtection = true, autoRevive = true },
}
function _antiDie.SuperHeal(hum)
    if not hum or not hum.Parent then return end
    local maxHealth = hum.MaxHealth or 100
    if maxHealth <= 0 or maxHealth == math.huge then maxHealth = 100 end
    pcall(function()
        hum.Health = maxHealth
        if hum.MaxHealth < maxHealth then hum.MaxHealth = maxHealth end
    end)
    _antiDie.invincibleUntil = _tick() + _antiDie.config.invincibilityFrames
    _antiDie.lastHealTime = _tick()
    pcall(function()
        local char = hum.Parent
        if not char then return end
        for _, child in ipairs(char:GetChildren()) do
            if child:IsA("NumberValue") then
                local name = child.Name:lower()
                if name:find("health") or name:find("hp") or name:find("life") then
                    child.Value = maxHealth
                end
            end
            if child:IsA("BoolValue") and child.Name:lower():find("dead") then
                child.Value = false
            end
        end
    end)
end
function _antiDie.PreventDamage(root, hum)
    if not hum then return end
    if hum.Health < (hum.MaxHealth or 100) then _antiDie.SuperHeal(hum) end
    if _tick() < _antiDie.invincibleUntil then
        if hum.Health < (hum.MaxHealth or 100) then hum.Health = hum.MaxHealth or 100 end
    end
    if _antiDie.config.ragdollProtection then
        local state = hum:GetState()
        if state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or
           state == Enum.HumanoidStateType.FallingDown or state == Enum.HumanoidStateType.Dead then
            pcall(function()
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end)
            _antiDie.SuperHeal(hum)
            if root then pcall(function() root.AssemblyAngularVelocity = Vector3.zero end) end
        end
    end
    if hum.Health <= 0 then
        _antiDie.SuperHeal(hum)
        pcall(function()
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            hum:ChangeState(Enum.HumanoidStateType.Running)
        end)
        if root then pcall(function()
            root.CFrame = CFrame.new(root.Position + Vector3.new(0, 2, 0))
            root.AssemblyLinearVelocity = Vector3.zero
        end) end
    end
end
function _antiDie.AutoRevive()
    if not _antiDie.config.autoRevive then return end
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum then return end
    if hum.Health <= 0 then
        _antiDie.SuperHeal(hum)
        pcall(function()
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            hum:ChangeState(Enum.HumanoidStateType.Running)
        end)
        if root then pcall(function()
            root.CFrame = CFrame.new(root.Position + Vector3.new(0, 3, 0))
            root.AssemblyLinearVelocity = Vector3.zero
        end) end
    end
end
function _antiDie.AttachHealth(char)
    if _antiDie.healthConn then _antiDie.healthConn:Disconnect(); _antiDie.healthConn = nil end
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then hum = char and char:WaitForChild("Humanoid", 3) end
    if not hum then return end
    _antiDie.healthConn = hum:GetPropertyChangedSignal("Health"):Connect(function()
        if not _antiDie.enabled then return end
        if hum.Health < (hum.MaxHealth or 100) then _antiDie.SuperHeal(hum) end
        if hum.Health <= 0 then _antiDie.AutoRevive() end
    end)
    if hum.Health < (hum.MaxHealth or 100) then _antiDie.SuperHeal(hum) end
end
function _antiDie.StartEngine()
    if _antiDie.enabled and _antiDie.loop then return end
    _antiDie.enabled = true
    _antiDieEnabled = true
    antiDieEnabled = true
    if _antiDie.loop then _antiDie.loop:Disconnect(); _antiDie.loop = nil end
    if _antiDie.healthConn then _antiDie.healthConn:Disconnect(); _antiDie.healthConn = nil end
    _antiDie.loop = RunService.Heartbeat:Connect(function()
        if not _antiDie.enabled then return end
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum then return end
        if hum.Health <= 0 then _antiDie.AutoRevive()
        elseif hum.Health <= _antiDie.config.healthThreshold then _antiDie.SuperHeal(hum)
        elseif hum.Health < (hum.MaxHealth or 100) then _antiDie.SuperHeal(hum) end
        _antiDie.PreventDamage(root, hum)
    end)
    if LP.Character then _antiDie.AttachHealth(LP.Character) end
    if _antiDie.charConn then _antiDie.charConn:Disconnect(); _antiDie.charConn = nil end
    _antiDie.charConn = LP.CharacterAdded:Connect(function(char)
        if not _antiDie.enabled then return end
        task.wait(0.05)
        _antiDie.AttachHealth(char)
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then _antiDie.SuperHeal(hum) end
    end)
end
function _antiDie.StopEngine()
    _antiDie.enabled = false
    _antiDieEnabled = false
    antiDieEnabled = false
    if _antiDie.loop then _antiDie.loop:Disconnect(); _antiDie.loop = nil end
    if _antiDie.healthConn then _antiDie.healthConn:Disconnect(); _antiDie.healthConn = nil end
    if _antiDie.charConn then _antiDie.charConn:Disconnect(); _antiDie.charConn = nil end
    pcall(function()
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
        hum.BreakJointsOnDeath = true
        if hum.MaxHealth == math.huge or hum.MaxHealth <= 0 then
            hum.MaxHealth = 100; hum.Health = math.min(hum.Health, 100)
        end
    end)
end
function _antiDieSetEnabled(enabled)
    enabled = enabled == true
    if enabled == _antiDieEnabled then return end
    if enabled then _antiDie.StartEngine() else _antiDie.StopEngine() end
end
function _antiDieRefresh()
    if _antiDieStopped then return end
    local manual = _antiDieSources.toggle
    _antiDieSetEnabled(manual or _antiDieSources.autobat)
end
_G.__CrystalAntiDieSource = function(source, enabled)
    if _antiDieStopped or _antiDieSources[source] == nil then return end
    _antiDieSources[source] = enabled == true
    _antiDieRefresh()
end
_G.__CrystalAntiDieSet = function(enabled) _G.__CrystalAntiDieSource("autobat", enabled) end
_G.__CrystalAntiDieIsEnabled = function() return _antiDieEnabled end
_G.__CrystalAntiDieStop = function()
    _antiDieStopped = true
    _antiDieSources.toggle = false
    _antiDieSources.autobat = false
    _antiDieSetEnabled(false)
end
function activateOnCharacter(char)
    if not _antiDieEnabled then return end
    _antiDie.AttachHealth(char)
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then _antiDie.SuperHeal(hum) end
end
AntiDieModule = {
    enabled = false,
    start = function()
        AntiDieModule.enabled = true
        antiDieEnabled = true
        _antiDieStopped = false
        _G.__CrystalAntiDieSource("toggle", true)
    end,
    stop = function()
        AntiDieModule.enabled = false
        antiDieEnabled = false
        _G.__CrystalAntiDieSource("toggle", false)
    end,
}
_G.AntiDie = AntiDieModule

-- KICK WARNING
if _G.B2KickWarningEnabled == nil then _G.B2KickWarningEnabled = true end
do
    local pgui = LP:WaitForChild("PlayerGui")
    if _G.B2KickWarning and _G.B2KickWarning.Destroy then pcall(_G.B2KickWarning.Destroy) end
    local DURATION = 2.3
    local destroyed, shown, wasHolding = false, false, false
    local renderConn, camConn = nil, nil
    local old = pgui:FindFirstChild("B2KickWarning")
    if old then old:Destroy() end
    local gui = Instance.new("ScreenGui")
    gui.Name = "B2KickWarning"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 999
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = pgui
    local banner = Instance.new("Frame", gui)
    banner.Name = "KickTimerBanner"
    banner.AnchorPoint = Vector2.new(0.5, 0)
    banner.BackgroundColor3 = Color3.fromRGB(40, 10, 25)
    banner.BorderSizePixel = 0
    banner.Visible = false
    banner.ClipsDescendants = true
    banner.ZIndex = 100
    Instance.new("UICorner", banner).CornerRadius = UDim.new(1, 0)
    local fill = Instance.new("Frame", banner)
    fill.Name = "ReadyFill"
    fill.Position = UDim2.new(0, 0, 0, 0)
    fill.Size = UDim2.new(1, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(255, 20, 147)
    fill.BackgroundTransparency = 1
    fill.BorderSizePixel = 0
    fill.ZIndex = 101
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    local ring = Instance.new("Frame", banner)
    ring.Name = "ProgressBorderPath"
    ring.BackgroundTransparency = 1
    ring.Size = UDim2.fromScale(1, 1)
    ring.ClipsDescendants = true
    ring.ZIndex = 102
    Instance.new("UICorner", ring).CornerRadius = UDim.new(1, 0)
    local label = Instance.new("TextLabel", banner)
    label.Size = UDim2.new(1, -16, 1, 0)
    label.Position = UDim2.new(0, 8, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = "DONT ENTER"
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamBlack
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.ZIndex = 103
    local segs, lit = {}, 0
    local W, H, TOPY = 320, 70, 14
    local function clearSegs()
        for _, s in ipairs(segs) do if s and s.Parent then s:Destroy() end end
        segs, lit = {}, 0
    end
    local function buildRing()
        clearSegs()
        local thick = 2
        local inset = thick + 1
        local r = math.max(3, (H - inset * 2) * 0.5)
        local cy = H * 0.5
        local x0 = inset + r
        local x1 = W - inset - r
        local straight = math.max(1, x1 - x0)
        local arc = math.pi * r
        local total = straight * 2 + arc * 2
        local count = math.clamp(math.ceil(total / 4), 72, 180)
        local segLen = total / count + 1.25
        for i = 1, count do
            local d = (i - 0.5) / count * total
            local x, y, ang
            if d <= straight then x, y, ang = x0 + d, inset, 0
            elseif d <= straight + arc then
                local a = -math.pi / 2 + (d - straight) / r
                x, y, ang = x1 + math.cos(a) * r, cy + math.sin(a) * r, a + math.pi / 2
            elseif d <= straight * 2 + arc then x, y, ang = x1 - (d - straight - arc), H - inset, math.pi
            else
                local a = math.pi / 2 + (d - straight * 2 - arc) / r
                x, y, ang = x0 + math.cos(a) * r, cy + math.sin(a) * r, a + math.pi / 2
            end
            local s = Instance.new("Frame", ring)
            s.Name = "ProgressSegment"
            s.AnchorPoint = Vector2.new(0.5, 0.5)
            s.Position = UDim2.fromOffset(x, y)
            s.Size = UDim2.fromOffset(segLen, thick)
            s.Rotation = math.deg(ang)
            s.BackgroundColor3 = Color3.fromRGB(255, 20, 147)
            s.BackgroundTransparency = 1
            s.BorderSizePixel = 0
            s.ZIndex = 102
            Instance.new("UICorner", s).CornerRadius = UDim.new(1, 0)
            segs[i] = s
        end
    end
    local function resetRing()
        fill.BackgroundTransparency = 1
        lit = 0
        for _, s in ipairs(segs) do s.BackgroundTransparency = 1 end
    end
    local function setProgress(p)
        local n = #segs
        local target = math.clamp(math.floor(math.clamp(p, 0, 1) * n + 0.5), 0, n)
        if target < lit then
            for i = target + 1, lit do if segs[i] then segs[i].BackgroundTransparency = 1 end end
        elseif lit < target then
            for i = lit + 1, target do if segs[i] then segs[i].BackgroundTransparency = 0 end end
        end
        lit = target
    end
    local function layout()
        local cam = workspace.CurrentCamera
        local vs = cam and cam.ViewportSize or Vector2.new(1280, 720)
        W = math.clamp(math.floor(vs.X * 0.25), 280, 340)
        H, TOPY = 70, 14
        banner.Size = UDim2.fromOffset(W, H)
        label.TextSize = 14
        buildRing()
        if not banner.Visible then
            resetRing()
            banner.Position = UDim2.new(0.5, 0, 0, -H - 10)
        end
    end
    layout()
    if workspace.CurrentCamera then
        camConn = workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(layout)
    end
    local function isEnabled() return _G.B2KickWarningEnabled ~= false end
    local function hide()
        if renderConn then renderConn:Disconnect() renderConn = nil end
        if banner.Parent then
            banner.Visible = false
            resetRing()
            banner.Position = UDim2.new(0.5, 0, 0, -H - 10)
        end
        shown = false
    end
    local function isHolding()
        if LP:GetAttribute("Stealing") == true then return true end
        local c = LP.Character
        if not c then return false end
        for _, ch in ipairs(c:GetChildren()) do
            local n = ch.Name:lower()
            if n:find("brainrot") or n:find("brain") or n:find("animal") or n:find("carry") or n:find("stolen") or n:find("held") or n:find("steal") then return true end
        end
        for k, v in pairs(c:GetAttributes()) do
            local n = k:lower()
            if v == true and (n:find("carrying") or n:find("carry") or n:find("stealing") or n:find("isstealing") or n:find("hasbrainrot")) then return true end
        end
        return false
    end
    local function show()
        if destroyed or not isEnabled() or shown then return end
        shown = true
        layout()
        resetRing()
        label.Text = "DONT ENTER"
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        banner.Visible = true
        banner.Position = UDim2.new(0.5, 0, 0, -H - 12)
        TS:Create(banner, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, 0, 0, TOPY)}):Play()
        local t0, done = tick(), false
        if renderConn then renderConn:Disconnect() end
        renderConn = RunService.RenderStepped:Connect(function()
            if destroyed or not isEnabled() then hide() return end
            if done or not banner.Parent then
                if renderConn then renderConn:Disconnect() renderConn = nil end
                return
            end
            local p = math.clamp((tick() - t0) / DURATION, 0, 1)
            setProgress(p)
            if p >= 1 then
                done = true
                if renderConn then renderConn:Disconnect() renderConn = nil end
                fill.BackgroundTransparency = 0
                for _, s in ipairs(segs) do s.BackgroundTransparency = 1 end
                label.Text = "ENTER"
                label.TextColor3 = Color3.fromRGB(0, 0, 0)
                task.delay(2.5, function()
                    if destroyed then return end
                    if not isEnabled() then hide() return end
                    TS:Create(banner, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(0.5, 0, 0, -H - 10)}):Play()
                    task.delay(0.45, function()
                        if destroyed then return end
                        banner.Visible = false
                        shown = false
                    end)
                end)
            end
        end)
    end
    _G.B2SetKickWarning = function(on)
        _G.B2KickWarningEnabled = (on == true)
        if not _G.B2KickWarningEnabled then hide() wasHolding = false end
        return _G.B2KickWarningEnabled
    end
    _G.B2KickWarning = {
        SetDuration = function(v) v = tonumber(v) if v and v > 0 then DURATION = v end end,
        GetDuration = function() return DURATION end,
        SetEnabled = _G.B2SetKickWarning, IsEnabled = isEnabled, Show = show, Hide = hide,
        Destroy = function()
            destroyed = true
            hide()
            if camConn then camConn:Disconnect() camConn = nil end
            if gui.Parent then gui:Destroy() end
        end,
    }
    task.spawn(function()
        while not destroyed and gui.Parent do
            if isEnabled() then
                local h = isHolding()
                if not wasHolding and h then show() end
                wasHolding = h
            else
                if shown then hide() end
                wasHolding = false
            end
            task.wait(0.1)
        end
    end)
end

_G.AmbitiousSafeModeGetCountdownLabel = function()
    local ok, result = pcall(function()
        return LP.PlayerGui and LP.PlayerGui:FindFirstChild("DuelsMachineTopFrame")
            and LP.PlayerGui.DuelsMachineTopFrame:FindFirstChild("DuelsMachineTopFrame")
            and LP.PlayerGui.DuelsMachineTopFrame.DuelsMachineTopFrame:FindFirstChild("Timer")
            and LP.PlayerGui.DuelsMachineTopFrame.DuelsMachineTopFrame.Timer:FindFirstChild("TextLabel")
    end)
    return ok and result or nil
end
_G.AmbitiousSafeModeCountdownNumber = function(value)
    local text = tostring(value or ""):upper():gsub("^%s+", ""):gsub("%s+$", "")
    if text == "GO" or text == "START" or text == "READY" then return true end
    local num = tonumber(text)
    return num ~= nil and num >= 0 and num <= 10
end
_G.AmbitiousSafeModeCountdownValue = function()
    local textLabel = _G.AmbitiousSafeModeGetCountdownLabel()
    if not textLabel then return nil end
    local text = tostring(textLabel.Text or ""):upper():gsub("^%s+", ""):gsub("%s+$", "")
    if text == "GO" or text == "START" or text == "READY" then return 0 end
    local num = tonumber(text)
    if num ~= nil and num >= 0 and num <= 10 then return num end
    return nil
end
_G.AmbitiousSafeModeInDuelCountdown = function()
    local textLabel = _G.AmbitiousSafeModeGetCountdownLabel()
    return textLabel and _G.AmbitiousSafeModeCountdownNumber(textLabel.Text) or false
end
_G.AmbitiousSafeModeBlockedTools = { bat=true, slap=true, sword=true, gun=true, pistol=true, rifle=true, medusa=true, hammer=true, axe=true, knife=true, katana=true, blade=true, fist=true }
_G.AmbitiousSafeModeIsCarryableTool = function(callback)
    if not callback or not callback:IsA("Tool") then return false end
    local lowercaseText = callback.Name:lower()
    for k in pairs(_G.AmbitiousSafeModeBlockedTools) do
        if lowercaseText:find(k, 1, true) then return false end
    end
    return true
end
_G.AmbitiousSafeModeHoldingBrainrot = function()
    local ok, result = pcall(function() return LP:GetAttribute("Stealing") end)
    if ok and result == true then return true end
    local character = LP.Character
    if not character then return false end
    local ok3, result3 = pcall(function() return character:GetAttribute("Stealing") end)
    if ok3 and result3 == true then return true end
    for _, entry in ipairs({"Carrying","IsCarrying","Grabbed","Holding","StealHold","HasGrab"}) do
        local instance = character:FindFirstChild(entry, true)
        if instance then
            if instance:IsA("BoolValue") and instance.Value then return true end
            if instance:IsA("ObjectValue") and instance.Value then return true end
            if instance:IsA("StringValue") and instance.Value ~= "" then return true end
        end
    end
    for _, child in ipairs(character:GetChildren()) do
        if child:IsA("Model") and child:FindFirstChildWhichIsA("BasePart", true) then
            local lowercaseText = child.Name:lower()
            if lowercaseText:find("brainrot") or lowercaseText:find("animal") or lowercaseText:find("carry")
                or lowercaseText:find("grab") or lowercaseText:find("steal") or lowercaseText:find("hold") then return true end
        end
    end
    return false
end
_G.AmbitiousSafeModeIsLocked = function()
    if not antiKickEnabled then return false end
    return _G.AmbitiousSafeModeInDuelCountdown() or _G.AmbitiousSafeModeHoldingBrainrot()
end
_G.AmbitiousSafeModeForceStop = function(value)
    local isEnabled = false
    if autoBatEnabled then disableAutoBat(); isEnabled = true end
    if batDesyncTpEnabled and stopBatDesyncTp then stopBatDesyncTp(); isEnabled = true end
    if autoLeftEnabled then
        autoLeftEnabled = false
        if autoLeftSetVisual then autoLeftSetVisual(false) end
        stopAutoLeft(); isEnabled = true
    end
    if autoRightEnabled then
        autoRightEnabled = false
        if autoRightSetVisual then autoRightSetVisual(false) end
        stopAutoRight(); isEnabled = true
    end
    if isEnabled then print("[SafeMode]", value or "LOCK") end
end
_G.AmbitiousSafeModeTryStart = function()
    if _G.AmbitiousSafeModeIsLocked and _G.AmbitiousSafeModeIsLocked() then
        _G.AmbitiousSafeModeForceStop("SAFE MODE LOCK")
        return false
    end
    return true
end
if _G.Lust and _G.Lust.Connections and _G.Lust.Connections.safeMode then
    pcall(function() _G.Lust.Connections.safeMode:Disconnect() end)
end
_G.Lust.Connections.safeMode = RunService.Heartbeat:Connect(function()
    if antiKickEnabled and _G.AmbitiousSafeModeIsLocked and _G.AmbitiousSafeModeIsLocked() then
        _G.AmbitiousSafeModeForceStop("SAFE MODE LOCK")
    end
end)

-- BAT SKIN
do
    local localPlayer = LP
    local newCFrame = CFrame.new
    katanaSkinEnabled = false
    do
        local function createKatanaSkinController()
            local katanaPlayersService = game:GetService("Players")
            local katanaInsertService = game:GetService("InsertService")
            local katanaLighting = game:GetService("Lighting")
            local katanaReplicatedStorage = game:GetService("ReplicatedStorage")
            local katanaPlayer = katanaPlayersService.LocalPlayer
            local katanaColors = { red=Color3.new(0.784314,0,0), red2=Color3.new(1,0,0.392157), gold=Color3.new(1,0.843137,0) }
            local katanaState = { Skin="KATANA", SkinOrder={"KATANA","NONE"}, LastBat=nil, LastAppliedSkin=nil, OriginalKatanaTemplate=nil, ExactTemplates={}, ExactTemplateSearched={}, ExactAssetIds={KATANA=""}, Original={} }
            local function findBat()
                local character = katanaPlayer.Character
                if character then
                    local bat = character:FindFirstChild("Bat")
                    if bat and bat:IsA("Tool") then return bat end
                end
                local backpack = katanaPlayer:FindFirstChildOfClass("Backpack")
                if backpack then
                    local bat = backpack:FindFirstChild("Bat")
                    if bat and bat:IsA("Tool") then return bat end
                end
                return nil
            end
            local function configureVisualPart(part)
                if not part or not part:IsA("BasePart") then return end
                part.Anchored=false; part.CanCollide=false; part.CanTouch=false; part.CanQuery=false; part.Massless=true
            end
            local function weldToHandle(part1, part0)
                if not part1 or not part0 or not part1:IsA("BasePart") or not part0:IsA("BasePart") then return end
                configureVisualPart(part1)
                local weldConstraint = Instance.new("WeldConstraint")
                weldConstraint.Name = "FlowerSkin_AssetWeld"
                weldConstraint.Part0 = part0; weldConstraint.Part1 = part1; weldConstraint.Parent = part1
            end
            local function cacheOriginalBatState(batTool)
                if not batTool then return end
                local handle = batTool:FindFirstChild("Handle")
                local slash = batTool:FindFirstChild("Slash")
                katanaState.Original[batTool] = katanaState.Original[batTool] or {}
                local originalState = katanaState.Original[batTool]
                if handle and handle:IsA("BasePart") and not originalState.Handle then
                    originalState.Handle = { Transparency=handle.Transparency, LocalTransparencyModifier=handle.LocalTransparencyModifier, CastShadow=handle.CastShadow }
                end
                if slash and slash:IsA("Sound") and not originalState.SlashSoundId then originalState.SlashSoundId = slash.SoundId end
            end
            local function captureOriginalKatanaTemplate()
                if katanaState.OriginalKatanaTemplate then return end
                local function scanContainer(container)
                    if not container then return end
                    local bat = container:FindFirstChild("Bat")
                    if not bat then return end
                    local k = bat:FindFirstChild("FlowerSkin_KatanaRealistic")
                    k = k and k:FindFirstChild("FlowerSkin_AssetKatana")
                    if k then katanaState.OriginalKatanaTemplate = k:Clone() end
                end
                scanContainer(katanaPlayer:FindFirstChildOfClass("Backpack"))
                scanContainer(katanaPlayer.Character)
            end
            local function setBatHandleHidden(batTool, hidden)
                local handle523 = batTool and batTool:FindFirstChild("Handle")
                if not handle523 or not handle523:IsA("BasePart") then return end
                cacheOriginalBatState(batTool)
                if hidden then
                    handle523.LocalTransparencyModifier = 1
                    handle523.Transparency = 1
                    handle523.CastShadow = false
                else
                    local handle = katanaState.Original[batTool] and katanaState.Original[batTool].Handle
                    handle523.LocalTransparencyModifier = handle and handle.LocalTransparencyModifier or 0
                    handle523.Transparency = handle and handle.Transparency or 0
                    handle523.CastShadow = handle and handle.CastShadow
                    if handle523.CastShadow == nil then handle523.CastShadow = true end
                end
            end
            local function setBatSlashSound(batTool, soundId)
                cacheOriginalBatState(batTool)
                local slash = batTool and batTool:FindFirstChild("Slash")
                if slash and slash:IsA("Sound") then
                    if not soundId then soundId = katanaState.Original[batTool] and katanaState.Original[batTool].SlashSoundId or slash.SoundId end
                    slash.SoundId = soundId
                end
            end
            local function restoreOriginalBatVisual(batTool)
                if not batTool then return end
                local k = batTool:FindFirstChild("FlowerSkin_KatanaRealistic"); if k then k:Destroy() end
                local a = batTool:FindFirstChild("FlowerSkin_AssetKatana"); if a then a:Destroy() end
                setBatHandleHidden(batTool, false)
                setBatSlashSound(batTool, nil)
            end
            local function addKatanaRedEffects(parent)
                if not parent or not parent:IsA("BasePart") then return end
                local top = Instance.new("Attachment"); top.Name = "FlowerSkin_ExtraRedVFX"
                top.Position = Vector3.new(0, parent.Size.Y * 0.5, 0); top.Parent = parent
                local bottom = Instance.new("Attachment"); bottom.Name = "FlowerSkin_ExtraRedVFX_End"
                bottom.Position = Vector3.new(0, -parent.Size.Y * 0.5, 0); bottom.Parent = parent
                local trail = Instance.new("Trail"); trail.Name = "FlowerSkin_ExtraRedVFX"
                trail.Attachment0 = top; trail.Attachment1 = bottom
                trail.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, katanaColors.red2), ColorSequenceKeypoint.new(1, Color3.new(0.54902,0,0)) })
                trail.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.35), NumberSequenceKeypoint.new(1, 1) })
                trail.Lifetime = 0.18; trail.LightEmission = 0.55; trail.Parent = parent
                local pe = Instance.new("ParticleEmitter"); pe.Name = "FlowerSkin_ExtraRedVFX"
                pe.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.new(0.784314,0,0)), ColorSequenceKeypoint.new(1, katanaColors.red2) })
                pe.LightEmission = 0.55; pe.Rate = 14
                pe.Lifetime = NumberRange.new(0.3, 0.45)
                pe.Speed = NumberRange.new(0.2, 0.7)
                pe.SpreadAngle = Vector2.new(12, 12)
                pe.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.08), NumberSequenceKeypoint.new(1, 0) })
                pe.Texture = "rbxasset://textures/particles/sparkles_main.dds"
                pe.Parent = parent
            end
            local function createKatanaPart(parent, name, size, cframeOffset, color, material)
                local part = Instance.new("Part")
                part.Name = name; part.Size = size; part.Color = color
                part.Material = material or Enum.Material.Neon
                part.TopSurface = Enum.SurfaceType.Smooth
                part.BottomSurface = Enum.SurfaceType.Smooth
                configureVisualPart(part); part.Parent = parent
                return part, cframeOffset or CFrame.identity
            end
            local katanaCandidateNames = { KATANA = {"FlowerSkin_AssetKatana","Katana","FlowerSkin_KatanaRealistic"} }
            local function isScriptInstance(i) return i:IsA("Script") or i:IsA("LocalScript") or i:IsA("ModuleScript") end
            local function removeScripts(root)
                if not root then return end
                if isScriptInstance(root) then root:Destroy(); return end
                for _, d in ipairs(root:GetDescendants()) do if isScriptInstance(d) then d:Destroy() end end
            end
            local function hasBasePart(c)
                if not c then return false end
                if c:IsA("BasePart") then return true end
                return c:FindFirstChildWhichIsA("BasePart", true) ~= nil
            end
            local function isGeneratedSkin(c)
                local ok, r = pcall(function() return c:GetAttribute("CursedBatSkinsGenerated") end)
                return ok and r == true
            end
            local function validateSkinCandidate(c)
                if not c or isGeneratedSkin(c) then return nil end
                if c:IsA("Model") or c:IsA("Tool") or c:IsA("Accessory") or c:IsA("BasePart") then
                    if hasBasePart(c) then return c end
                end
                return nil
            end
            local function findNamedSkinCandidate(root, names)
                if not root then return nil end
                for _, entry in ipairs(names) do
                    if root.Name == entry then
                        local c = validateSkinCandidate(root)
                        if c then return c end
                    end
                end
                for _, name in ipairs(names) do
                    local i = root:FindFirstChild(name, true)
                    local v = validateSkinCandidate(i)
                    if v then return v end
                end
                return nil
            end
            local function normalizeAssetId(id)
                local n = tostring(id or ""):gsub("%s+", "")
                if n == "" then return nil end
                if n:match("^rbxassetid://") or n:match("^rbxasset://") then return n end
                if n:match("^%d+$") then return "rbxassetid://" .. n end
                return n
            end
            local function loadAssetSkinTemplate(skinName)
                local assetUri = normalizeAssetId(katanaState.ExactAssetIds[skinName])
                if not assetUri then return nil end
                local loaded = {}
                pcall(function() loaded = game:GetObjects(assetUri) end)
                if #loaded == 0 then
                    local m = tostring(assetUri):match("(%d+)")
                    if m then pcall(function() table.insert(loaded, katanaInsertService:LoadAsset(tonumber(m))) end) end
                end
                local names = katanaCandidateNames[skinName] or {}
                for _, e in ipairs(loaded) do
                    local c = findNamedSkinCandidate(e, names) or validateSkinCandidate(e)
                    if c then
                        local clone = c:Clone()
                        removeScripts(clone)
                        return clone
                    end
                end
                return nil
            end
            local function findExistingSkinTemplate(skinName)
                local names = katanaCandidateNames[skinName]
                if not names then return nil end
                local roots = { katanaPlayer.Character, katanaPlayer:FindFirstChildOfClass("Backpack"), katanaReplicatedStorage, katanaLighting, workspace }
                for _, e in ipairs(roots) do
                    local c = findNamedSkinCandidate(e, names)
                    if c then
                        local clone = c:Clone()
                        removeScripts(clone)
                        return clone
                    end
                end
                return nil
            end
            local function getSkinTemplate(skinName)
                if skinName == "KATANA" and katanaState.OriginalKatanaTemplate then return katanaState.OriginalKatanaTemplate end
                if katanaState.ExactTemplates[skinName] then return katanaState.ExactTemplates[skinName] end
                if katanaState.ExactTemplateSearched[skinName] then return nil end
                katanaState.ExactTemplateSearched[skinName] = true
                local t = loadAssetSkinTemplate(skinName) or findExistingSkinTemplate(skinName)
                if t then katanaState.ExactTemplates[skinName] = t end
                return t
            end
            local normalizeSkinModel = nil
            normalizeSkinModel = function(source, parent)
                if source:IsA("Model") then
                    source.Name = "FlowerSkin_AssetKatana"; source.Parent = parent; return source
                end
                if source:IsA("BasePart") then
                    local model = Instance.new("Model"); model.Name = "FlowerSkin_AssetKatana"; model.Parent = parent
                    source.Parent = model; return model
                end
                if source:IsA("Tool") or source:IsA("Folder") then
                    local k = source:FindFirstChild("FlowerSkin_AssetKatana") or source:FindFirstChildWhichIsA("Model") or source:FindFirstChildWhichIsA("BasePart")
                    if k and k.Parent == source then
                        k.Parent = nil; source:Destroy()
                        return normalizeSkinModel(k, parent)
                    end
                    local model = Instance.new("Model"); model.Name = "FlowerSkin_AssetKatana"; model.Parent = parent
                    for _, c in ipairs(source:GetChildren()) do if not isScriptInstance(c) then c.Parent = model end end
                    source:Destroy(); return model
                end
                return nil
            end
            local function applyExactSkinTemplate(batTool, skinName)
                local handle = batTool and batTool:FindFirstChild("Handle")
                if not handle or not handle:IsA("BasePart") then return false end
                local template = getSkinTemplate(skinName)
                if not template then return false end
                local folder = Instance.new("Folder"); folder.Name = "FlowerSkin_KatanaRealistic"; folder.Parent = batTool
                local skinModel = normalizeSkinModel(template:Clone(), folder)
                if not skinModel or not hasBasePart(skinModel) then folder:Destroy(); return false end
                removeScripts(skinModel)
                pcall(function() skinModel:SetAttribute("CursedBatSkinsExactMesh", true) end)
                local firstPart = nil
                for _, d in ipairs(skinModel:GetDescendants()) do
                    if d:IsA("BasePart") then
                        firstPart = firstPart or d
                        configureVisualPart(d)
                    end
                end
                if not firstPart then folder:Destroy(); return false end
                if skinModel:IsA("Model") then
                    skinModel.PrimaryPart = skinModel.PrimaryPart or firstPart
                    pcall(function() skinModel:PivotTo(handle.CFrame) end)
                end
                for _, d in ipairs(skinModel:GetDescendants()) do if d:IsA("BasePart") then weldToHandle(d, handle) end end
                local weaponPart = skinModel:FindFirstChild("SharpParts", true) or skinModel:FindFirstChild("WeaponPart", true) or skinModel:FindFirstChild("Handle", true) or firstPart
                if weaponPart and not weaponPart:FindFirstChild("FlowerSkin_ExtraRedVFX") then addKatanaRedEffects(weaponPart) end
                return true
            end
            local function createProceduralKatana(batTool, skinName)
                local handle = batTool and batTool:FindFirstChild("Handle")
                if not handle or not handle:IsA("BasePart") then return nil end
                local folder = Instance.new("Folder"); folder.Name = "FlowerSkin_KatanaRealistic"; folder.Parent = batTool
                local model = Instance.new("Model"); model.Name = "FlowerSkin_AssetKatana"
                model:SetAttribute("CursedBatSkinsGenerated", true)
                model.Parent = folder
                local createdParts = {}
                local function createPart(name, size, cframeOffset, color, material)
                    local part, offset = createKatanaPart(model, name, size, cframeOffset, color, material)
                    part.CFrame = handle.CFrame * offset
                    weldToHandle(part, handle)
                    table.insert(createdParts, part)
                    return part
                end
                if skinName == "KATANA" then
                    local metal = Enum.Material.Metal
                    createPart("Handle2", Vector3.new(0.22,1,0.22), CFrame.new(0,-0.48,0), Color3.new(0.176471,0.176471,0.045), metal)
                    local red2 = katanaColors.red2
                    local sharpParts = createPart("SharpParts", Vector3.new(0.18,2.4,0.12), CFrame.new(0,1.05,0), red2, Enum.Material.Neon)
                    createPart("WeaponPart", Vector3.new(0.3,2.7,0.08), CFrame.new(0.08,1.15,0), katanaColors.red, Enum.Material.Neon)
                    createPart("GoldAccent", Vector3.new(0.5,0.12,0.08), CFrame.new(0,-0.28,0), katanaColors.gold, Enum.Material.Neon)
                    addKatanaRedEffects(sharpParts)
                end
                model.PrimaryPart = createdParts[1]
                return model
            end
            local slashSoundIds = { KATANA = "rbxassetid://111808555599832" }
            return {
                State = katanaState,
                ApplySkin = function(skinName)
                    captureOriginalKatanaTemplate()
                    local lastBat = findBat()
                    if not lastBat then
                        katanaState.LastBat = nil
                        katanaState.LastAppliedSkin = nil
                        return false
                    end
                    cacheOriginalBatState(lastBat)
                    restoreOriginalBatVisual(lastBat)
                    if skinName == "NONE" then
                        katanaState.LastBat = lastBat
                        katanaState.LastAppliedSkin = skinName
                        return true
                    end
                    setBatHandleHidden(lastBat, true)
                    setBatSlashSound(lastBat, slashSoundIds[skinName])
                    if not applyExactSkinTemplate(lastBat, skinName) then createProceduralKatana(lastBat, skinName) end
                    local handle = lastBat:FindFirstChild("Handle")
                    if handle then
                        local fire = handle:FindFirstChildOfClass("Fire") or handle:FindFirstChild("Fire")
                        if fire and fire:IsA("Fire") then
                            fire.Enabled = true
                            fire.Color = katanaColors.red
                            fire.SecondaryColor = katanaColors.red2
                        end
                    end
                    katanaState.LastBat = lastBat
                    katanaState.LastAppliedSkin = skinName
                    return true
                end,
                SetExactAssetId = function(assetId)
                    katanaState.ExactAssetIds.KATANA = tostring(assetId or "")
                    katanaState.ExactTemplateSearched.KATANA = nil
                    katanaState.ExactTemplates.KATANA = nil
                end,
            }
        end
        katanaSkinController = createKatanaSkinController()
    end
    _G.CursedBatKatana = katanaSkinController
    task.spawn(function()
        while true do
            if katanaSkinEnabled then
                local character = localPlayer.Character
                local bat = nil
                if character then
                    bat = character:FindFirstChild("Bat")
                    local isTool = bat and bat:IsA("Tool")
                    if not isTool then bat = nil end
                end
                local needsSkinRefresh
                if not bat then
                    local backpack = localPlayer:FindFirstChildOfClass("Backpack")
                    if backpack then
                        local bat2 = backpack:FindFirstChild("Bat")
                        if bat2 and bat2:IsA("Tool") then needsSkinRefresh = bat2 else needsSkinRefresh = bat end
                    else needsSkinRefresh = bat end
                else needsSkinRefresh = bat end
                needsSkinRefresh = needsSkinRefresh and (needsSkinRefresh ~= katanaSkinController.State.LastBat or katanaSkinController.State.LastAppliedSkin ~= "KATANA")
                if needsSkinRefresh then pcall(function() katanaSkinController.ApplySkin("KATANA") end) end
            end
            task.wait(0.5)
        end
    end)
    minecraftBatSkinEnabled = false
    minecraftBatSkinColorMode = "Default"
    MinecraftBatSetVisual = nil
    MinecraftBatColorSelector = nil
    do
        local function createMinecraftBatController()
            local batGripOffset = newCFrame(-0.18,-0.52,-0.2)
            local batGripRotation = CFrame.Angles(0.78539816339744828,0,0.087266462599716474)
            local minecraftBatColors = {
                ["Default"]=nil, ["Abyss Blue"]=Color3.fromRGB(0,40,150),
                ["Venom Green"]=Color3.fromRGB(20,85,50), ["Royal Gold"]=Color3.fromRGB(255,200,0),
                ["Velvet Rose"]=Color3.fromRGB(220,20,100), ["Crimson Night"]=Color3.fromRGB(90,0,20),
            }
            local minecraftBatState = { enabled=false, colorMode="Default", cachedVisualPart=nil, rgbConnection=nil }
            local ok, result = pcall(function() return game:GetObjects("rbxassetid://18566246244") end)
            if ok and result and #result > 0 then
                local assetRoot = result[1]
                minecraftBatState.cachedVisualPart = assetRoot:IsA("BasePart") and assetRoot or assetRoot:FindFirstChildWhichIsA("BasePart", true)
            end
            local function setPartColor(part, color)
                if not part or not color then return end
                part.Color = color
                if part:IsA("UnionOperation") then pcall(function() part.UsePartColor = true end) end
                local sm = part:FindFirstChildWhichIsA("SpecialMesh")
                if sm then sm.VertexColor = Vector3.new(color.R, color.G, color.B) end
            end
            local function findBat()
                local character = localPlayer.Character
                if character then
                    local bat = character:FindFirstChild("Bat")
                    if bat and bat:IsA("Tool") then return bat end
                end
                local backpack = localPlayer:FindFirstChildOfClass("Backpack")
                if backpack then
                    local bat = backpack:FindFirstChild("Bat")
                    if bat and bat:IsA("Tool") then return bat end
                end
                return nil
            end
            local function restoreBatVisual(batTool)
                if not batTool then return end
                local c = batTool:FindFirstChild("CustomUnionVisual"); if c then pcall(function() c:Destroy() end) end
                local handle = batTool:FindFirstChild("Handle")
                if handle then
                    handle.Transparency = 0
                    for _, child in ipairs(handle:GetChildren()) do
                        if child:IsA("SpecialMesh") or child:IsA("Mesh") or child:IsA("Decal") then
                            pcall(function() child.Transparency = 0 end)
                        end
                    end
                end
            end
            local function applyMinecraftBatVisual(batTool)
                if not batTool or batTool.Name ~= "Bat" or not minecraftBatState.cachedVisualPart then return end
                local handle = batTool:WaitForChild("Handle", 2)
                if not handle then return end
                local old = batTool:FindFirstChild("CustomUnionVisual"); if old then old:Destroy() end
                handle.Transparency = 1
                for _, child in ipairs(handle:GetChildren()) do
                    if child:IsA("SpecialMesh") or child:IsA("Mesh") or child:IsA("Decal") then
                        pcall(function() child.Transparency = 1 end)
                    end
                end
                local v = minecraftBatState.cachedVisualPart:Clone()
                v.Name = "CustomUnionVisual"; v.CanCollide = false; v.Massless = true; v.Anchored = false
                local scaleModel = Instance.new("Model")
                v.Parent = scaleModel; scaleModel.PrimaryPart = v
                pcall(function() scaleModel:ScaleTo(2) end)
                v.Parent = nil; scaleModel:Destroy()
                if minecraftBatState.colorMode == "RGB" then
                    setPartColor(v, Color3.fromHSV(tick() % 3 / 3, 1, 1))
                elseif minecraftBatColors[minecraftBatState.colorMode] then
                    setPartColor(v, minecraftBatColors[minecraftBatState.colorMode])
                end
                for _, child in ipairs(v:GetChildren()) do
                    if child:IsA("Weld") or child:IsA("WeldConstraint") then child:Destroy() end
                end
                v.CFrame = handle.CFrame * batGripOffset * batGripRotation
                v.Parent = batTool
                local w = Instance.new("WeldConstraint")
                w.Part0 = handle; w.Part1 = v; w.Parent = v
            end
            local function startRgbCycle()
                if minecraftBatState.rgbConnection then return end
                minecraftBatState.rgbConnection = RunService.RenderStepped:Connect(function()
                    if not minecraftBatState.enabled or minecraftBatState.colorMode ~= "RGB" then return end
                    local currentBat = findBat()
                    if not currentBat then return end
                    local v = currentBat:FindFirstChild("CustomUnionVisual")
                    if v then setPartColor(v, Color3.fromHSV(tick() % 3 / 3, 1, 1)) end
                end)
            end
            local function stopRgbCycle()
                if minecraftBatState.rgbConnection then
                    minecraftBatState.rgbConnection:Disconnect()
                    minecraftBatState.rgbConnection = nil
                end
            end
            return {
                State = minecraftBatState,
                Colors = minecraftBatColors,
                FindBat = findBat,
                Apply = function()
                    if not minecraftBatState.enabled then return end
                    local batTool = findBat()
                    if batTool then applyMinecraftBatVisual(batTool) end
                    if minecraftBatState.colorMode == "RGB" then startRgbCycle() end
                end,
                Remove = function()
                    stopRgbCycle()
                    local character = localPlayer.Character
                    if character then
                        local bat = character:FindFirstChild("Bat")
                        if bat then restoreBatVisual(bat) end
                    end
                    local backpack = localPlayer:FindFirstChildOfClass("Backpack")
                    if backpack then
                        local bat = backpack:FindFirstChild("Bat")
                        if bat then restoreBatVisual(bat) end
                    end
                end,
                SetColorMode = function(colorMode)
                    minecraftBatState.colorMode = colorMode
                    if not minecraftBatState.enabled then return end
                    if colorMode == "RGB" then startRgbCycle() else stopRgbCycle() end
                    local batTool = findBat()
                    if batTool then applyMinecraftBatVisual(batTool) end
                end,
            }
        end
        minecraftBatSkinController = createMinecraftBatController()
    end
    task.spawn(function()
        while true do
            if minecraftBatSkinEnabled then
                minecraftBatSkinController.State.enabled = true
                local currentBat = minecraftBatSkinController.FindBat()
                if currentBat and not currentBat:FindFirstChild("CustomUnionVisual") then
                    pcall(minecraftBatSkinController.Apply)
                end
            else
                minecraftBatSkinController.State.enabled = false
            end
            task.wait(0.5)
        end
    end)
end

-- TP BAT AUTO ANTI DIE
_evnyAD = { enabled=false, heartConn=nil, deathConns={}, charConn=nil, humanoid=nil }
do
    local function stopADConns()
        for _, c in ipairs(_evnyAD.deathConns) do pcall(function() c:Disconnect() end) end
        _evnyAD.deathConns = {}
        if _evnyAD.heartConn then pcall(function() _evnyAD.heartConn:Disconnect() end); _evnyAD.heartConn = nil end
    end
    local function protectCharacterFromDeath(character)
        if not character then return end
        local humanoid = character:WaitForChild("Humanoid", 5)
        if not humanoid then return end
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
        pcall(function()
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
            humanoid.BreakJointsOnDeath = false
        end)
        _evnyAD.humanoid = humanoid
        table.insert(_evnyAD.deathConns, humanoid.StateChanged:Connect(function(old, new)
            if not _evnyAD.enabled then return end
            if new == Enum.HumanoidStateType.Dead then
                humanoid.Health = math.huge
                pcall(function() humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false) end)
            end
        end))
        table.insert(_evnyAD.deathConns, humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            if _evnyAD.enabled and humanoid.Health < humanoid.MaxHealth then humanoid.Health = math.huge end
        end))
        if _evnyAD.heartConn then pcall(function() _evnyAD.heartConn:Disconnect() end) end
        _evnyAD.heartConn = RunService.Heartbeat:Connect(function()
            if _evnyAD.enabled and humanoid and humanoid.Parent and humanoid.Health < humanoid.MaxHealth then
                humanoid.Health = math.huge
            end
        end)
    end
    _evnyADReapply = function(character)
        if not _evnyAD.enabled then return end
        protectCharacterFromDeath(character or LP.Character)
    end
    _evnyAD.start = function()
        _evnyAD.enabled = true
        stopADConns()
        protectCharacterFromDeath(LP.Character)
        if _evnyAD.charConn then pcall(function() _evnyAD.charConn:Disconnect() end) end
        _evnyAD.charConn = LP.CharacterAdded:Connect(function(character)
            if not _evnyAD.enabled then return end
            task.wait(0.1)
            stopADConns()
            protectCharacterFromDeath(character)
        end)
    end
    _evnyAD.stop = function()
        _evnyAD.enabled = false
        stopADConns()
        if _evnyAD.charConn then pcall(function() _evnyAD.charConn:Disconnect() end); _evnyAD.charConn = nil end
        local character = LP.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            pcall(function()
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
                humanoid.MaxHealth = 100; humanoid.Health = 100
            end)
        end
        _evnyAD.humanoid = nil
    end
end

tpBatAutoAntiDieEnabled = true
_tpBatAutoAD = false
setTpBatAutoADVisual = nil
function _tpBatAutoAntiDie(on)
    if on then
        if not tpBatAutoAntiDieEnabled then return end
        if _antiDieEnabled or _evnyAD.enabled then return end
        _tpBatAutoAD = true
        _evnyAD.start()
    elseif _tpBatAutoAD then
        _tpBatAutoAD = false
        _evnyAD.stop()
    end
end

-- ANTI BAT
antiBatEnabled = false
setAntiBatVisual = nil
_AntiBat = { Connection = nil, RagdollConnection = nil, venom = { amp = 10000, phase = 0, dir = 1 } }
function stopAntiBat()
    antiBatEnabled = false
    if _AntiBat.Connection then _AntiBat.Connection:Disconnect(); _AntiBat.Connection = nil end
    if _AntiBat.RagdollConnection then _AntiBat.RagdollConnection:Disconnect(); _AntiBat.RagdollConnection = nil end
    _G._VenomAntiBatSpiking = false
    _G._VenomAntiBatDesiredXZ = nil
end
function startAntiBat()
    stopAntiBat()
    antiBatEnabled = true
    local char0 = LP.Character
    if not char0 or not char0:FindFirstChild("HumanoidRootPart") then return end
    local v = _AntiBat.venom
    v.amp, v.phase, v.dir = 10000, 0, 1
    _AntiBat.Connection = RunService.Heartbeat:Connect(function()
        if not antiBatEnabled then return end
        local ch = LP.Character
        local root = ch and ch:FindFirstChild("HumanoidRootPart")
        if not root or not root.Parent then return end
        local savedXZ = Vector3.new(root.Velocity.X, 0, root.Velocity.Z)
        v.amp = v.amp + 500 * v.dir
        if v.amp >= 20000 then
            v.amp = 10000
            v.dir = -1
        elseif v.amp <= 10000 then
            v.amp = 10000
            v.dir = 1
        end
        v.phase = v.phase + math.random() * 0.5
        local magnitude = v.amp + math.random(-5000, 5000)
        _G._VenomAntiBatSpiking = true
        root.Velocity = Vector3.new(math.cos(v.phase) * magnitude, root.Velocity.Y, math.sin(v.phase) * magnitude)
        RunService.RenderStepped:Wait()
        if root.Parent then
            local desired = _G._VenomAntiBatDesiredXZ
            if desired then
                root.Velocity = Vector3.new(desired.X, root.Velocity.Y, desired.Z)
            else
                root.Velocity = Vector3.new(savedXZ.X, root.Velocity.Y, savedXZ.Z)
            end
        end
        _G._VenomAntiBatSpiking = false
    end)
    _AntiBat.RagdollConnection = RunService.Heartbeat:Connect(function()
        if not antiBatEnabled then return end
        local ch = LP.Character
        if not ch then return end
        local hum = ch:FindFirstChildOfClass("Humanoid")
        local hrp = ch:FindFirstChild("HumanoidRootPart")
        if hum then
            local st = hum:GetState()
            if st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll
                or st == Enum.HumanoidStateType.FallingDown then
                hum:ChangeState(Enum.HumanoidStateType.Running)
                workspace.CurrentCamera.CameraSubject = hum
                pcall(function()
                    local pm = LP.PlayerScripts:FindFirstChild("PlayerModule")
                    if pm then require(pm:FindFirstChild("ControlModule")):Enable() end
                end)
                if hrp then
                    hrp.Velocity = Vector3.new(0, 0, 0)
                    hrp.RotVelocity = Vector3.new(0, 0, 0)
                end
            end
        end
        for _, d in ipairs(ch:GetDescendants()) do
            if d:IsA("Motor6D") and not d.Enabled then d.Enabled = true end
        end
    end)
end
LP.CharacterAdded:Connect(function()
    task.wait(0.3)
    if antiBatEnabled then startAntiBat() end
end)

-- FLOAT BUTTON STYLES
do
    local function C(r, g, b) return Color3.fromRGB(r, g, b) end
    local WHITE = C(255, 255, 255)
    local FIRE = C(255, 20, 147)
    local BASE = {bg=C(55, 15, 35), bgOn=C(255, 20, 147), tx=C(255, 150, 200), txOn=WHITE, st=C(200, 50, 120), stOn=C(255, 150, 200), th=2, r=14}
    local CLASSIC = {bg=C(40, 10, 25), bgOn=C(255, 20, 147), tx=C(255, 150, 200), txOn=C(40, 10, 25), st=C(255, 20, 147), stOn=C(255, 150, 200)}
    local function mk(name, fx, over)
        local t = {name=name, fx=fx}
        for k, v in pairs(BASE) do t[k] = v end
        if over then for k, v in pairs(over) do t[k] = v end end
        return t
    end
    local function classic(name, over)
        local o = {}
        for k, v in pairs(CLASSIC) do o[k] = v end
        for k, v in pairs(over or {}) do o[k] = v end
        return mk(name, nil, o)
    end
    FLOAT_STYLES = {
        mk("Pumpkin","diag",{bg=C(70, 20, 45),bgOn=C(255, 20, 147),tx=C(255, 150, 200),txOn=C(40, 10, 25),st=C(255, 20, 147),stOn=C(255, 150, 200)}),
        mk("Blood","gradstroke",{bg=C(55, 15, 35),bgOn=C(255, 20, 147),tx=C(255, 150, 200),txOn=WHITE,st=C(200, 50, 120),stOn=C(255, 150, 200)}),
        mk("Toxic","gradstroke",{bg=C(40, 10, 25),bgOn=C(255, 150, 200),tx=C(255, 150, 200),txOn=C(40, 10, 25),st=C(255, 150, 200),stOn=C(255, 20, 147)}),
        mk("Ghost","glass",{bg=C(40, 10, 25),bgOn=C(255, 255, 255),tx=C(255, 255, 255),txOn=C(40, 10, 25),st=C(255, 255, 255),stOn=C(255, 255, 255)}),
        mk("Witch","corners",{bg=C(55, 15, 35),bgOn=C(255, 20, 147),tx=C(255, 150, 200),txOn=WHITE,st=C(255, 150, 200),stOn=C(255, 20, 147)}),
        mk("Feu"),
        classic("Classique"),
        classic("Gros arrondi", {th=3, r=22}),
        mk("Fin sobre",nil,{bg=C(40, 10, 25),bgOn=C(70, 20, 45),tx=C(255, 150, 200),txOn=C(255, 150, 200),st=C(200, 50, 120),stOn=C(255, 20, 147),th=1,r=10}),
        mk("Contour blanc",nil,{bg=C(40, 10, 25),bgOn=C(255, 20, 147),tx=C(255, 150, 200),txOn=C(40, 10, 25),st=WHITE,stOn=WHITE}),
        mk("Or",nil,{bg=C(40, 10, 25),bgOn=C(255, 150, 200),tx=C(255, 150, 200),txOn=C(40, 10, 25),st=C(255, 150, 200),stOn=C(255, 255, 255)}),
        mk("Double cadre","double"),
        mk("Touche 3D","key3d",{th=1}),
        mk("Coins tech","corners",{bgOn=C(255, 20, 147)}),
        mk("Barre ON/OFF","status"),
        mk("Gros mot","bigword",{bgOn=C(255, 20, 147)}),
        mk("Verre","glass"),
        mk("Rond","round",{th=3}),
        mk("Barre cote","sidebar",{bgOn=C(255, 20, 147),st=C(200, 50, 120),stOn=FIRE,th=1,r=12}),
        mk("Degrade","diag"),
        mk("Contour degrade","gradstroke",{tx=C(255, 150, 200),txOn=C(40, 10, 25)}),
        mk("Numeros","badge"),
        mk("Couleurs","percolor"),
    }
    FLOAT_STYLE_NAMES = {}
    for i, s in ipairs(FLOAT_STYLES) do FLOAT_STYLE_NAMES[i] = s.name end
    local ORDER = {DropBR=1, AutoLeft=2, AutoBat=3, AutoRight=4, TpDown=5, Carry=6, Lagger1=7, Lagger2=8}
    local PERCOLOR = {
        DropBR=C(255, 150, 200), AutoLeft=C(255, 20, 147), AutoBat=C(200, 50, 120), AutoRight=C(255, 150, 200),
        TpDown=C(200, 50, 120), Carry=C(255, 150, 200), Lagger1=C(255, 20, 147), Lagger2=C(255, 150, 200),
    }
    local registry, list = {}, {}
    local function curStyle() return FLOAT_STYLES[floatStyleIndex] or FLOAT_STYLES[1] end
    local function newFrame(parent, name, size, pos, color, z, transp)
        local f = Instance.new("Frame")
        f.Name = name; f.Size = size; f.Position = pos
        f.BackgroundColor3 = color; f.BackgroundTransparency = transp or 0
        f.BorderSizePixel = 0; f.Active = false; f.ZIndex = z
        f.Parent = parent; return f
    end
    local function rounded(f, r)
        local c = Instance.new("UICorner"); c.CornerRadius = r; c.Parent = f; return c
    end
    local function clearDeco(button, reg)
        for _, ch in ipairs(button:GetChildren()) do
            if string.sub(ch.Name, 1, 4) == "_FS_" then ch:Destroy() end
        end
        local stroke = button:FindFirstChildOfClass("UIStroke")
        if stroke then
            local sg = stroke:FindFirstChild("_FS_SG"); if sg then sg:Destroy() end
        end
        local label = reg.label
        if label and label.Parent then
            label.RichText = false
            label.Text = reg.text
            label.TextSize = reg.size
            label.Position = UDim2.new(0, 0, 0, 0)
            label.Size = UDim2.new(1, 0, 1, 0)
            label.TextXAlignment = Enum.TextXAlignment.Center
        end
    end
    local function applyStyle(button)
        local reg = registry[button]
        if not reg then return end
        local S = curStyle()
        local fx = S.fx
        clearDeco(button, reg)
        local label = reg.label
        local Z = (label and label.ZIndex) or (button.ZIndex + 1)
        local corner = button:FindFirstChildOfClass("UICorner") or Instance.new("UICorner", button)
        corner.CornerRadius = (fx == "round") and UDim.new(0.5, 0) or UDim.new(0, S.r)
        local stroke = button:FindFirstChildOfClass("UIStroke")
        if fx == "double" then
            local f = newFrame(button, "_FS_Inner", UDim2.new(1,-8,1,-8), UDim2.new(0,4,0,4), WHITE, Z, 1)
            rounded(f, UDim.new(0, math.max(S.r - 5, 4)))
            Instance.new("UIStroke", f).Thickness = 1
        elseif fx == "key3d" then
            local f = newFrame(button, "_FS_Edge", UDim2.new(1,-16,0,4), UDim2.new(0,8,1,-9), C(200, 50, 120), Z, 0)
            rounded(f, UDim.new(0, 2))
        elseif fx == "corners" then
            newFrame(button, "_FS_C1", UDim2.new(0,14,0,2), UDim2.new(0,6,0,6), FIRE, Z)
            newFrame(button, "_FS_C2", UDim2.new(0,2,0,14), UDim2.new(0,6,0,6), FIRE, Z)
            newFrame(button, "_FS_C3", UDim2.new(0,14,0,2), UDim2.new(1,-20,1,-8), FIRE, Z)
            newFrame(button, "_FS_C4", UDim2.new(0,2,0,14), UDim2.new(1,-8,1,-20), FIRE, Z)
        elseif fx == "status" then
            if label then label.Size = UDim2.new(1, 0, 1, -18) end
            local f = newFrame(button, "_FS_Strip", UDim2.new(1,-10,0,14), UDim2.new(0,5,1,-19), C(70, 20, 45), Z, 0)
            rounded(f, UDim.new(0, 6))
            local t = Instance.new("TextLabel", f)
            t.Name = "_FS_StripText"; t.Size = UDim2.new(1,0,1,0); t.BackgroundTransparency = 1
            t.Font = Enum.Font.GothamBlack; t.TextSize = 8; t.Text = "OFF"; t.TextColor3 = C(255, 150, 200); t.ZIndex = Z+1
        elseif fx == "bigword" then
            if label then
                local l1, l2 = string.match(reg.text, "^(.-)\n(.*)$")
                if not l2 then l1, l2 = reg.text, "" end
                label.RichText = true
                label.Text = '<font size="16">' .. l1 .. '</font>\n<font size="8">' .. l2 .. '</font>'
            end
            local led = newFrame(button, "_FS_Led", UDim2.new(0,6,0,6), UDim2.new(1,-12,0,6), C(200, 50, 120), Z, 0)
            rounded(led, UDim.new(1, 0))
        elseif fx == "glass" then
            local f = newFrame(button, "_FS_Shine", UDim2.new(1,-8,0.38,0), UDim2.new(0,4,0,4), WHITE, Z, 0.9)
            rounded(f, UDim.new(0, math.max(S.r - 4, 4)))
        elseif fx == "round" then
            if label then label.TextSize = math.max(8, reg.size - 2) end
            local f = newFrame(button, "_FS_Ring", UDim2.new(1,-10,1,-10), UDim2.new(0,5,0,5), WHITE, Z, 1)
            rounded(f, UDim.new(0.5, 0))
            local s = Instance.new("UIStroke", f); s.Thickness = 1; s.Color = FIRE; s.Transparency = 0.55
        elseif fx == "sidebar" then
            if label then
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Position = UDim2.new(0, 15, 0, 0)
                label.Size = UDim2.new(1, -15, 1, 0)
            end
            local f = newFrame(button, "_FS_Bar", UDim2.new(0,5,1,-14), UDim2.new(0,6,0,7), FIRE, Z, 0)
            rounded(f, UDim.new(0, 3))
        elseif fx == "gradstroke" then
            if stroke then
                local sg = Instance.new("UIGradient", stroke)
                sg.Name = "_FS_SG"; sg.Rotation = 45
                sg.Color = ColorSequence.new(FIRE, C(255, 150, 200))
            end
        elseif fx == "badge" then
            local f = newFrame(button, "_FS_Badge", UDim2.new(0,15,0,15), UDim2.new(0,4,0,4), FIRE, Z, 0)
            rounded(f, UDim.new(1, 0))
            local t = Instance.new("TextLabel", f)
            t.Name = "_FS_BadgeText"; t.Size = UDim2.new(1,0,1,0); t.BackgroundTransparency = 1
            t.Font = Enum.Font.GothamBlack; t.TextSize = 8; t.TextColor3 = WHITE; t.ZIndex = Z+1
            t.Text = tostring(ORDER[button.Name] or "*")
        end
    end
    function paintFloatingBtn(button, active)
        if not button then return end
        active = active and true or false
        button:SetAttribute("FloatOn", active)
        local S = curStyle()
        local fx = S.fx
        local label = button:FindFirstChild("TextLabel")
        local stroke = button:FindFirstChildOfClass("UIStroke")
        local grad = button:FindFirstChild("BtnGrad")
        local bg = active and S.bgOn or S.bg
        local tx = active and S.txOn or S.tx
        local st = active and S.stOn or S.st
        local transp, stTransp, useGrad, gradRot = 0, 0, nil, 90
        if fx == "percolor" then
            local c = PERCOLOR[button.Name] or C(255, 20, 147)
            bg = active and c or S.bg
            tx = active and C(40, 10, 25) or c
            st = c
        elseif fx == "key3d" then
            useGrad = active and ColorSequence.new(C(255, 20, 147), C(200, 50, 120)) or ColorSequence.new(C(70, 20, 45), C(40, 10, 25))
        elseif fx == "diag" then
            gradRot = 45
            if active then
                useGrad = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, C(255, 150, 200)),
                    ColorSequenceKeypoint.new(0.55, C(255, 20, 147)),
                    ColorSequenceKeypoint.new(1, C(200, 50, 120)),
                })
            else useGrad = ColorSequence.new(C(70, 20, 45), C(40, 10, 25)) end
        elseif fx == "gradstroke" then
            st = WHITE
            if active then
                gradRot = 45
                useGrad = ColorSequence.new(FIRE, C(255, 150, 200))
            end
        elseif fx == "glass" then
            bg = FIRE
            transp = active and 0.35 or 0.82
            stTransp = active and 0 or 0.45
            tx = active and WHITE or C(255, 150, 200)
            st = active and C(255, 20, 147) or C(200, 50, 120)
        end
        if useGrad then
            button.BackgroundColor3 = WHITE
            if grad then grad.Color = useGrad; grad.Rotation = gradRot end
        else
            button.BackgroundColor3 = bg
            if grad then grad.Color = ColorSequence.new(WHITE); grad.Rotation = 90 end
        end
        button.BackgroundTransparency = transp
        if label then label.TextColor3 = tx end
        if stroke then
            stroke.Color = st
            stroke.Thickness = S.th
            stroke.Transparency = stTransp
            if fx == "corners" then
                stroke.Thickness = 1
                stroke.Transparency = active and 0 or 1
            end
        end
        local x = button:FindFirstChild("_FS_Inner")
        if x then
            local s = x:FindFirstChildOfClass("UIStroke")
            if s then s.Color = active and WHITE or FIRE; s.Transparency = active and 0.35 or 0.5 end
        end
        x = button:FindFirstChild("_FS_Edge")
        if x then x.BackgroundColor3 = active and C(200, 50, 120) or C(200, 50, 120) end
        for i = 1, 4 do
            x = button:FindFirstChild("_FS_C" .. i)
            if x then x.BackgroundColor3 = active and C(255, 150, 200) or FIRE end
        end
        x = button:FindFirstChild("_FS_Strip")
        if x then
            x.BackgroundColor3 = active and FIRE or C(70, 20, 45)
            local t = x:FindFirstChild("_FS_StripText")
            if t then t.Text = active and "ON" or "OFF"; t.TextColor3 = active and WHITE or C(255, 150, 200) end
        end
        x = button:FindFirstChild("_FS_Led")
        if x then x.BackgroundColor3 = active and C(255, 150, 200) or C(200, 50, 120) end
        x = button:FindFirstChild("_FS_Bar")
        if x then x.BackgroundColor3 = active and C(255, 150, 200) or FIRE end
        x = button:FindFirstChild("_FS_Badge")
        if x then
            x.BackgroundColor3 = active and WHITE or FIRE
            local t = x:FindFirstChild("_FS_BadgeText")
            if t then t.TextColor3 = active and FIRE or WHITE end
        end
    end
    function evnyDecorate(button, label)
        registry[button] = {label=label, text=label and label.Text or "", size=label and label.TextSize or 10}
        list[#list + 1] = button
        button.BackgroundTransparency = 0
        if not button:FindFirstChildOfClass("UICorner") then Instance.new("UICorner", button) end
        local grad = Instance.new("UIGradient", button)
        grad.Name = "BtnGrad"; grad.Rotation = 90
        local stroke = Instance.new("UIStroke", button)
        stroke.Name = "NormalStroke"; stroke.Thickness = 2; stroke.Transparency = 0
        if label then
            label.Name = "TextLabel"
            label.Font = Enum.Font.GothamBlack
        end
        applyStyle(button)
        paintFloatingBtn(button, false)
    end
    function applyFloatStyleAll()
        for _, b in ipairs(list) do
            if b and b.Parent then
                applyStyle(b)
                paintFloatingBtn(b, b:GetAttribute("FloatOn") == true)
            end
        end
    end
end

-- MOBILE PANEL
function createMobilePanel()
    local panel = Instance.new("ScreenGui")
    panel.Name = "B2/JE HUBMobilePanel"
    panel.ResetOnSpawn = false
    panel.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(panel) end end)
    if not pcall(function() panel.Parent = game:GetService("CoreGui") end) then
        panel.Parent = LP:WaitForChild("PlayerGui")
    end
    local BTN_W, BTN_H = 60, 60
    local GAP_X = 8
    local GAP_Y = 18
    local COLUMNS = 2
    local ROWS = 4
    local PANEL_W = BTN_W * COLUMNS + GAP_X * (COLUMNS - 1)
    local PANEL_H = BTN_H * ROWS + GAP_Y * (ROWS - 1)
    local container = Instance.new("Frame", panel)
    container.Name = "FloatingPanel"
    container.Size = UDim2.new(0, PANEL_W, 0, PANEL_H)
    container.Position = UDim2.new(1, -(PANEL_W + 56), 1, -(PANEL_H + 95))
    container.BackgroundTransparency = 1
    container.Active = true
    container.Selectable = true
    local btnContainer = Instance.new("Frame", container)
    btnContainer.Name = "ButtonsContainer"
    btnContainer.Size = UDim2.new(1, 0, 1, 0)
    btnContainer.BackgroundTransparency = 1
    local INACTIVE_BG = Color3.fromRGB(55, 15, 35)
    local buttons = {}
    local buttonNames = {"DropBR","AutoLeft","AutoBat","AutoRight","TpDown","Carry","Lagger1","Lagger2"}
    local buttonTexts = {"DROP\nBR","AUTO\nLEFT","BAT\nAIMBOT","AUTO\nRIGHT","TP\nDOWN","CARRY\nSPD","LAGGER\nMODE","LAGGER\nCARRY"}

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            _isDraggingButton = false
        end
    end)

    local function createButton(name, text, order, isToggle, callback)
        local btn = Instance.new("TextButton", btnContainer)
        btn.Name = name
        btn.Size = UDim2.new(0, BTN_W, 0, BTN_H)
        btn.BackgroundColor3 = INACTIVE_BG
        btn.BorderSizePixel = 0
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.ZIndex = 10
        local savedPos = savedButtonPositions[name]
        if savedPos and type(savedPos.X) == "number" and type(savedPos.Y) == "number"
            and savedPos.X >= -50 and savedPos.X <= 500 and savedPos.Y >= -50 and savedPos.Y <= 500 then
            btn.Position = UDim2.new(0, savedPos.X, 0, savedPos.Y)
        else
            local defX, defY = getDefaultButtonPosition(name)
            btn.Position = UDim2.new(0, defX, 0, defY)
            savedButtonPositions[name] = nil
        end
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
        local label = Instance.new("TextLabel", btn)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Font = Enum.Font.GothamBlack
        label.TextSize = 10
        label.TextWrapped = true
        label.ZIndex = 11
        evnyDecorate(btn, label)
        table.insert(_mobileButtonsCache, btn)
        applyButtonBackgroundToBtn(btn, currentButtonBgIndex)
        local active = false
        local function setActive(state)
            active = state
            btn:SetAttribute("MobActive", state and true or false)
            paintFloatingBtn(btn, state)
        end
        setActive(false)
        local dragging = false
        local hasMoved = false
        local dragStart = nil
        local startPos = nil
        local movedDistance = 0
        btn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true; hasMoved = false; movedDistance = 0
                dragStart = input.Position; startPos = btn.Position
                _isDraggingButton = true
            end
        end)
        btn.InputChanged:Connect(function(input)
            if not dragging then return end
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                local delta = input.Position - dragStart
                movedDistance = delta.Magnitude
                if editModeEnabled and not uiLocked then
                    hasMoved = true
                    btn.Position = UDim2.new(0, startPos.X.Offset + delta.X, 0, startPos.Y.Offset + delta.Y)
                end
            end
        end)
        btn.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                if dragging then
                    if movedDistance < 3 then
                        if isToggle then
                            if editModeEnabled and not uiLocked then
                                if callback then callback(function() end) end
                            else
                                if callback then callback(setActive) end
                            end
                        else
                            if callback then callback(setActive, active) end
                        end
                    elseif editModeEnabled and not uiLocked and hasMoved then
                        savedButtonPositions[name] = {X = btn.Position.X.Offset, Y = btn.Position.Y.Offset}
                        saveAllSettings()
                    end
                    dragging = false; hasMoved = false
                    dragStart = nil; startPos = nil; movedDistance = 0
                end
            end
        end)
        buttons[name] = {btn = btn, setActive = setActive, label = label}
        return setActive
    end

    for i, name in ipairs(buttonNames) do
        local text = buttonTexts[i]
        local callback
        if name == "DropBR" then
            callback = function(setActive)
                if autoBatEnabled then return end
                setActive(true)
                executeDropWithToggle(function(v) if dropBrainrotSetVisual then dropBrainrotSetVisual(v) end end)
                task.delay(0.3, function() setActive(false) end)
            end
        elseif name == "AutoLeft" then
            callback = function(setActive)
                autoLeftEnabled = not autoLeftEnabled
                setActive(autoLeftEnabled)
                if autoLeftEnabled then startAutoLeft() else stopAutoLeft() end
                if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled) end
                saveAllSettings()
            end
        elseif name == "AutoBat" then
            callback = function(setActive)
                if not autoBatEnabled then enableAutoBat() else disableAutoBat() end
                setActive(autoBatEnabled)
                saveAllSettings()
            end
        elseif name == "AutoRight" then
            callback = function(setActive)
                autoRightEnabled = not autoRightEnabled
                setActive(autoRightEnabled)
                if autoRightEnabled then startAutoRight() else stopAutoRight() end
                if autoRightSetVisual then autoRightSetVisual(autoRightEnabled) end
                saveAllSettings()
            end
        elseif name == "TpDown" then
            callback = function(setActive)
                runTPDown()
                setActive(true)
                task.delay(0.2, function() setActive(false) end)
            end
        elseif name == "Carry" then
            callback = function(setActive)
                if not speedMode then
                    speedMode = true; laggerToggled = false; laggerLevel = 1; setActive(true)
                    if buttons.Lagger1 and buttons.Lagger1.setActive then buttons.Lagger1.setActive(false) end
                    if buttons.Lagger2 and buttons.Lagger2.setActive then buttons.Lagger2.setActive(false) end
                else speedMode = false; setActive(false) end
                refreshSpeedModeLabel()
                saveAllSettings()
            end
        elseif name == "Lagger1" then
            callback = function(setActive)
                if speedMode then speedMode = false; if mobSetCarry then mobSetCarry(false) end end
                if not laggerToggled or laggerLevel ~= 1 then
                    laggerToggled = true; laggerLevel = 1; setActive(true)
                    if buttons.Lagger2 and buttons.Lagger2.setActive then buttons.Lagger2.setActive(false) end
                else
                    laggerToggled = false; laggerLevel = 1; setActive(false)
                end
                refreshSpeedModeLabel()
                saveAllSettings()
            end
        elseif name == "Lagger2" then
            callback = function(setActive)
                if speedMode then speedMode = false; if mobSetCarry then mobSetCarry(false) end end
                if not laggerToggled or laggerLevel ~= 2 then
                    laggerToggled = true; laggerLevel = 2; setActive(true)
                    if buttons.Lagger1 and buttons.Lagger1.setActive then buttons.Lagger1.setActive(false) end
                else
                    laggerToggled = false; laggerLevel = 1; setActive(false)
                end
                refreshSpeedModeLabel()
                saveAllSettings()
            end
        end
        local setActive = createButton(name, text, i-1, true, callback)
        if name == "AutoBat" then mobSetAutoBat = setActive end
        if name == "AutoLeft" then mobSetAutoLeft = setActive end
        if name == "AutoRight" then mobSetAutoRight = setActive end
        if name == "DropBR" then mobSetDropBR = setActive end
        if name == "TpDown" then mobSetTpDown = setActive end
        if name == "Carry" then mobSetCarry = setActive end
        if name == "Lagger1" then mobSetLagger1 = setActive end
        if name == "Lagger2" then mobSetLagger2 = setActive end
    end
    if buttons.AutoBat and buttons.AutoBat.setActive then buttons.AutoBat.setActive(autoBatEnabled) end
    if buttons.AutoLeft and buttons.AutoLeft.setActive then buttons.AutoLeft.setActive(autoLeftEnabled) end
    if buttons.AutoRight and buttons.AutoRight.setActive then buttons.AutoRight.setActive(autoRightEnabled) end
    if buttons.Carry and buttons.Carry.setActive then buttons.Carry.setActive(speedMode) end
    if buttons.Lagger1 and buttons.Lagger1.setActive then buttons.Lagger1.setActive(laggerToggled and laggerLevel == 1) end
    if buttons.Lagger2 and buttons.Lagger2.setActive then buttons.Lagger2.setActive(laggerToggled and laggerLevel == 2) end
    if savedMobilePanelPos and type(savedMobilePanelPos.XOffset) == "number"
        and savedMobilePanelPos.XOffset > -2000 and savedMobilePanelPos.XOffset < 2000
        and type(savedMobilePanelPos.YOffset) == "number"
        and savedMobilePanelPos.YOffset > -2000 and savedMobilePanelPos.YOffset < 2000 then
        container.Position = UDim2.new(
            savedMobilePanelPos.XScale or 0,
            savedMobilePanelPos.XOffset or 10,
            savedMobilePanelPos.YScale or 0,
            savedMobilePanelPos.YOffset or 0
        )
    else savedMobilePanelPos = nil end
    local draggingPanel = false
    local dragStartPos = nil
    local dragStartMousePos = nil
    container.InputBegan:Connect(function(input)
        if uiLocked or _isDraggingButton or editModeEnabled then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingPanel = true
            dragStartPos = container.Position
            dragStartMousePos = input.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if not draggingPanel or uiLocked then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if dragStartPos and dragStartMousePos then
                local delta = input.Position - dragStartMousePos
                local newX = dragStartPos.X.Offset + delta.X
                local newY = dragStartPos.Y.Offset + delta.Y
                container.Position = UDim2.new(dragStartPos.X.Scale, newX, dragStartPos.Y.Scale, newY)
            end
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if draggingPanel then
                draggingPanel = false
                savedMobilePanelPos = {
                    XScale = container.Position.X.Scale, XOffset = container.Position.X.Offset,
                    YScale = container.Position.Y.Scale, YOffset = container.Position.Y.Offset
                }
                saveAllSettings()
            end
            dragStartPos = nil; dragStartMousePos = nil
        end
    end)
    if hideMobileButtons then
        container.Visible = false
    end
    return panel
end

function createInstaResetFloatingButton()
    local panel = Instance.new("ScreenGui")
    panel.Name = "InstaResetButton"
    panel.ResetOnSpawn = false
    panel.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    panel.DisplayOrder = 20
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(panel) end end)
    if not pcall(function() panel.Parent = game:GetService("CoreGui") end) then
        panel.Parent = LP:WaitForChild("PlayerGui")
    end
    local btnFrame = Instance.new("Frame", panel)
    btnFrame.Name = "Frame"
    btnFrame.Size = UDim2.new(0, 60, 0, 60)
    if instaResetFloatingPos then
        btnFrame.Position = UDim2.new(
            instaResetFloatingPos.XScale or 0.5,
            instaResetFloatingPos.XOffset or 90,
            instaResetFloatingPos.YScale or 0,
            instaResetFloatingPos.YOffset or 10
        )
    else btnFrame.Position = UDim2.new(0.5, 46, 0, 10) end
    btnFrame.BackgroundColor3 = Color3.fromRGB(40, 10, 25)
    btnFrame.BorderSizePixel = 0
    btnFrame.Active = true
    btnFrame.ClipsDescendants = true
    btnFrame.ZIndex = 20
    Instance.new("UICorner", btnFrame).CornerRadius = UDim.new(0, 18)
    local label = Instance.new("TextLabel", btnFrame)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "RESET"
    label.TextColor3 = Color3.fromRGB(255, 150, 200)
    label.Font = Enum.Font.GothamBlack
    label.TextSize = 11
    label.TextWrapped = true
    label.ZIndex = 21
    table.insert(_floatingButtonsCache, btnFrame)
    applyButtonBackgroundToBtn(btnFrame, currentButtonBgIndex)
    evnyDecorate(btnFrame, label)
    local function setVisual(state) paintFloatingBtn(btnFrame, state) end
    resetButtonSetVisual = setVisual
    local dragging = false; local hasMoved = false; local dragStart, startPos
    btnFrame.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true; hasMoved = false
            dragStart = inp.Position; startPos = btnFrame.Position
        end
    end)
    btnFrame.InputChanged:Connect(function(inp)
        if not dragging then return end
        if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
            local delta = inp.Position - dragStart
            if delta.Magnitude > 5 then hasMoved = true end
            if hasMoved and not uiLocked then
                btnFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                              startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end
    end)
    btnFrame.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                if not hasMoved then
                    setVisual(true)
                    FrameReset()
                    task.delay(0.2, function()
                        if resetButtonSetVisual then resetButtonSetVisual(false) end
                    end)
                elseif not uiLocked and hasMoved then
                    instaResetFloatingPos = {
                        XScale = btnFrame.Position.X.Scale, XOffset = btnFrame.Position.X.Offset,
                        YScale = btnFrame.Position.Y.Scale, YOffset = btnFrame.Position.Y.Offset
                    }
                    saveAllSettings()
                end
                dragging = false; hasMoved = false
            end
        end
    end)
    if hideMobileButtons then
        btnFrame.Visible = false
    end
    return panel
end

function createBypassFloatingButton()
    local panel = Instance.new("ScreenGui")
    panel.Name = "BypassButton"
    panel.ResetOnSpawn = false
    panel.DisplayOrder = 21
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(panel) end end)
    if not pcall(function() panel.Parent = game:GetService("CoreGui") end) then
        panel.Parent = LP:WaitForChild("PlayerGui")
    end
    local btnFrame = Instance.new("Frame", panel)
    btnFrame.Size = UDim2.new(0, 60, 0, 60)
    btnFrame.Name = "Frame"
    if bypassFloatingPos then
        btnFrame.Position = UDim2.new(
            bypassFloatingPos.XScale or 0.5,
            bypassFloatingPos.XOffset or 20,
            bypassFloatingPos.YScale or 0,
            bypassFloatingPos.YOffset or 10
        )
    else btnFrame.Position = UDim2.new(0.5, 137, 0, 10) end
    btnFrame.BackgroundColor3 = batDesyncTpEnabled and Color3.fromRGB(255, 20, 147) or Color3.fromRGB(55, 15, 35)
    btnFrame.BorderSizePixel = 0
    btnFrame.ZIndex = 20
    Instance.new("UICorner", btnFrame).CornerRadius = UDim.new(0, 18)
    local label = Instance.new("TextLabel", btnFrame)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "TP BAT"
    label.TextColor3 = batDesyncTpEnabled and Color3.fromRGB(40, 10, 25) or Color3.fromRGB(255, 150, 200)
    label.Font = Enum.Font.GothamBlack
    label.TextSize = 11
    label.TextWrapped = true
    label.ZIndex = 21
    table.insert(_floatingButtonsCache, btnFrame)
    applyButtonBackgroundToBtn(btnFrame, currentButtonBgIndex)
    evnyDecorate(btnFrame, label)
    paintFloatingBtn(btnFrame, batDesyncTpEnabled)
    local dragging = false; local hasMoved = false; local dragStart, startPos
    btnFrame.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true; hasMoved = false
            dragStart = inp.Position; startPos = btnFrame.Position
        end
    end)
    btnFrame.InputChanged:Connect(function(inp)
        if not dragging then return end
        if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
            local delta = inp.Position - dragStart
            if delta.Magnitude > 5 then hasMoved = true end
            if hasMoved and not uiLocked then
                btnFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end
    end)
    btnFrame.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                if not hasMoved then
                    toggleBatDesyncTp()
                elseif not uiLocked and hasMoved then
                    bypassFloatingPos = {
                        XScale = btnFrame.Position.X.Scale, XOffset = btnFrame.Position.X.Offset,
                        YScale = btnFrame.Position.Y.Scale, YOffset = btnFrame.Position.Y.Offset
                    }
                    saveAllSettings()
                end
                dragging = false; hasMoved = false
            end
        end
    end)
    bypassFloatingButton = panel
    if hideMobileButtons then
        btnFrame.Visible = false
    end
    return panel
end

function reapplyAllStates()
    if antiRagdollEnabled then setAntiRag(true) else setAntiRag(false) end
    if jumpEnabled then startJumpMode() else stopJumpMode() end
    if autoLeftEnabled then startAutoLeft() else stopAutoLeft() end
    if autoRightEnabled then startAutoRight() else stopAutoRight() end
    if autoBatEnabled then enableAutoBat() else disableAutoBat() end
    if batDesyncTpEnabled then startBatDesyncTp() else stopBatDesyncTp() end
    if bodyLockEnabled then startBodyLock() else stopBodyLock() end
    if autoTPDownEnabled then startAutoTPDown() else stopAutoTPDown() end
    if medusaCounterEnabled then setMedusaCounterState(true) else setMedusaCounterState(false) end
    if batCounterEnabled then startBatCounter() else stopBatCounter() end
    if espEnabled then toggleESP(true) else toggleESP(false) end
    if espLineEnabled then startESPLine() else stopESPLine() end
    if antiLagEnabled then enableAntiLag() else disableAntiLag() end
    if stretchEnabled then enableStretch() else disableStretch() end
    if vividGraphicsEnabled then enableVividGraphics() else disableVividGraphics() end
    if setJumpVisual then setJumpVisual(jumpEnabled) end
    if setAntiRagVisual then setAntiRagVisual(antiRagdollEnabled) end
    if setAutoTPDownVisual then setAutoTPDownVisual(autoTPDownEnabled) end
    if bodyLockSetVisual then bodyLockSetVisual(bodyLockEnabled) end
    if CONFIG.AUTO_STEAL_ENABLED then pcall(startAutoStealSemi) else stopAutoSteal() end
    if currentAnimPack ~= "Off" then startAnimPack(currentAnimPack) else stopAnimPack() end
    if currentAccessoryPack and currentAccessoryPack ~= "Off" then applyAccessoryPack(currentAccessoryPack) end
    if currentOutfitIndex and currentOutfitIndex > 1 then applyOutfitByIndex(currentOutfitIndex) end
    updateProgressBarVisibility()
    refreshSpeedModeLabel()
    applyBackgroundImage(currentBgIndex)
    applyButtonBackground(currentButtonBgIndex)
    if resetButtonSetVisual then resetButtonSetVisual(false) end
    if mirrorTPDownSetVisual then mirrorTPDownSetVisual(mirrorTPDownEnabled) end
    if setAutoResetOnMedVisual then setAutoResetOnMedVisual(autoResetOnMedEnabled) end
    if setVividVisual then setVividVisual(vividGraphicsEnabled) end
    if setESPLineVisual then setESPLineVisual(espLineEnabled) end
    if setESPVIsual then setESPVIsual(espEnabled) end
    if aimbotModeBtn then aimbotModeBtn.Text = _aimbotModeText() end
    if tpBatDistBox then tpBatDistBox.Text = tostring(_TpBat.distance) end
    buildStealBar(stealBarStyle)
end

function updateUIFromLoaded()
    task.wait()
    if normalBox then normalBox.Text = tostring(NS) end
    if carryBox then carryBox.Text = tostring(CS) end
    if radInput then radInput.Text = tostring(CONFIG.STEAL_RANGE) end
    if laggerBox then laggerBox.Text = tostring(LAGGER_SPEED_1) end
    if lagger2Box then lagger2Box.Text = tostring(LAGGER_SPEED_2) end
    if autoTPHeightBox then autoTPHeightBox.Text = tostring(autoTPDownHeight) end
    if _G.uiScaleValueLabel then _G.uiScaleValueLabel.Text = string.format("%.2f", uiScaleValue / 100) end
    if _G.stealBarSizeLabel then _G.stealBarSizeLabel.Text = string.format("%.2f", stealBarSize / 100) end
    if _G.buttonScaleValueLabel then _G.buttonScaleValueLabel.Text = string.format("%.2f", buttonScaleValue) end
    if _G.stealBarStyleBtn then _G.stealBarStyleBtn.Text = stealBarStyle end
    if mainUIScale then mainUIScale.Scale = uiScaleValue / 100 end
    applyStealBarScale()
    applyButtonScale(buttonScaleValue)
    applyButtonBackground(currentButtonBgIndex)
    if dropModeBtnRef then dropModeBtnRef.Text = dropMode == 1 and "Fling" or "Jump Drop" end
    if bodyLockRangeBox then bodyLockRangeBox.Text = tostring(bodyLockRange) end
    if aimbotSpeedBox then aimbotSpeedBox.Text = tostring(BAT_AIMBOT_SPEED) end
    if stealDurationBox then stealDurationBox.Text = tostring(Steal.StealDuration) end
    if setAutoCarryVisual then setAutoCarryVisual(autoCarrySpeedEnabled) end
    if autoCarryModeBtn then autoCarryModeBtn.Text = autoCarryMode end
    if antiDieEnabled and not _antiDieEnabled then AntiDieModule.start()
    elseif not antiDieEnabled and _antiDieEnabled and not _antiDieSources.autobat then AntiDieModule.stop() end
    if setAntiDieVisual then setAntiDieVisual(antiDieEnabled) end
    if antiBatEnabled and not _AntiBat.Connection then startAntiBat()
    elseif not antiBatEnabled and _AntiBat.Connection then stopAntiBat() end
    if setAntiBatVisual then setAntiBatVisual(antiBatEnabled) end
    if setTpBatAutoADVisual then setTpBatAutoADVisual(tpBatAutoAntiDieEnabled) end
    if setSafeModeVisual then setSafeModeVisual(antiKickEnabled) end
    if setKickWarningVisual then setKickWarningVisual(_G.B2KickWarningEnabled ~= false) end
    if setBatSkinVisual then setBatSkinVisual(katanaSkinEnabled) end
    if MinecraftBatSetVisual then MinecraftBatSetVisual(minecraftBatSkinEnabled) end
    if mcBatColorBtn then mcBatColorBtn.Text = minecraftBatSkinColorMode end
    if minecraftBatSkinController then pcall(minecraftBatSkinController.SetColorMode, minecraftBatSkinColorMode) end
    if mirrorTPDownSetVisual then mirrorTPDownSetVisual(mirrorTPDownEnabled) end
    if setAutoResetOnMedVisual then setAutoResetOnMedVisual(autoResetOnMedEnabled) end
    if setVividVisual then setVividVisual(vividGraphicsEnabled) end
    if setESPLineVisual then setESPLineVisual(espLineEnabled) end
    if setESPVIsual then setESPVIsual(espEnabled) end
    if aimbotModeBtn then aimbotModeBtn.Text = _aimbotModeText() end
    if tpBatDistBox then tpBatDistBox.Text = tostring(_TpBat.distance) end
    if outfitSelectorLabel then
        outfitSelectorLabel.Text = (OUTFITS[currentOutfitIndex] and OUTFITS[currentOutfitIndex].label) or "OFF"
    end
    refreshSpeedModeLabel()
    for _, ref in ipairs(keyButtonRefs) do
        local entry = ref.entry
        local label = (entry.gp and entry.gp.Name) or (entry.kb and entry.kb.Name) or "None"
        ref.btn.Text = label
    end
    if savedProgressBarPos and pbFrame then
        pbFrame.Position = UDim2.new(
            savedProgressBarPos.XScale or 0.5, savedProgressBarPos.XOffset or -186,
            savedProgressBarPos.YScale or 1, savedProgressBarPos.YOffset or -134
        )
    end
    if uiLocked and setLockUIVisual then setLockUIVisual(true) end
    if editModeEnabled and setEditModeVisual then setEditModeVisual(true) end
    if antiRagdollEnabled then
        if setAntiRagVisual then setAntiRagVisual(true) end
        startAntiRagdoll()
    end
    if CONFIG.AUTO_STEAL_ENABLED and setInstaGrab then setInstaGrab(true); pcall(startAutoStealSemi) end
    if jumpEnabled then
        if setJumpVisual then setJumpVisual(true) end
        startJumpMode()
    else if setJumpVisual then setJumpVisual(false) end end
    if medusaCounterEnabled then
        if setMedusaVisual then setMedusaVisual(true) end
        if LP.Character then setupMedusa(LP.Character) end
    else
        if setMedusaVisual then setMedusaVisual(false) end
        stopMedusaCounter()
    end
    if batCounterEnabled then
        if setBatCounterVisual then setBatCounterVisual(true) end
        startBatCounter()
    else
        if setBatCounterVisual then setBatCounterVisual(false) end
        stopBatCounter()
    end
    if autoTPDownEnabled then
        if setAutoTPDownVisual then setAutoTPDownVisual(true) end
        startAutoTPDown()
    end
    if antiLagEnabled then
        if setAntiLagVisual then setAntiLagVisual(true) end
        enableAntiLag()
    else
        if setAntiLagVisual then setAntiLagVisual(false) end
        disableAntiLag()
    end
    if espEnabled then toggleESP(true); if setESPVIsual then setESPVIsual(true) end
    else toggleESP(false); if setESPVIsual then setESPVIsual(false) end end
    if espLineEnabled then startESPLine(); if setESPLineVisual then setESPLineVisual(true) end
    else if setESPLineVisual then setESPLineVisual(false) end end
    if vividGraphicsEnabled then enableVividGraphics(); if setVividVisual then setVividVisual(true) end
    else if setVividVisual then setVividVisual(false) end end
    if stretchEnabled then enableStretch(); if _G.stretchToggleSetter then _G.stretchToggleSetter(true) end
    else if _G.stretchToggleSetter then _G.stretchToggleSetter(false) end end
    if mobSetAutoBat then mobSetAutoBat(autoBatEnabled) end
    if mobSetAutoLeft then mobSetAutoLeft(autoLeftEnabled) end
    if mobSetAutoRight then mobSetAutoRight(autoRightEnabled) end
    if mobSetCarry then mobSetCarry(speedMode) end
    if mobSetLagger1 then mobSetLagger1(laggerToggled and laggerLevel == 1) end
    if mobSetLagger2 then mobSetLagger2(laggerToggled and laggerLevel == 2) end
    if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled) end
    if autoRightSetVisual then autoRightSetVisual(autoRightEnabled) end
    if autoBatSetVisual then autoBatSetVisual(autoBatEnabled) end
    if bypassSetVisual then bypassSetVisual(batDesyncTpEnabled) end
    if autoLeftEnabled and not _G.Lust.Connections.autoLeft then startAutoLeft() end
    if autoRightEnabled and not _G.Lust.Connections.autoRight then startAutoRight() end
    if autoBatEnabled and not _G.Lust.Connections.aimbot then enableAutoBat() end
    if batDesyncTpEnabled and not _G.Lust.Connections.bypass then startBatDesyncTp() end
    if bodyLockSetVisual then
        bodyLockSetVisual(bodyLockEnabled)
    end
    if bodyLockEnabled and not _G.Lust.Connections.bodyLock then
        startBodyLock()
    end
    updateProgressBarVisibility()
    startEnemySpeed()
    if currentAccessoryPack and currentAccessoryPack ~= "Off" then
        task.wait(0.2)
        applyAccessoryPack(currentAccessoryPack)
    end
    if accSelectorLabel then accSelectorLabel.Text = currentAccessoryPack end
    applyBackgroundImage(currentBgIndex)
    if autoResetOnMedEnabled then
        _G.AdaptAutoResetOnMed.enabled = true
        task.defer(function()
            task.wait(0.3)
            AdaptStartAutoResetOnMed(LP.Character)
        end)
    end
end

-- BOOT
local okBuild, buildErr = pcall(buildGui)
if not okBuild then warn("[B2/JE] buildGui failed:", buildErr) end

local _loadedOK = false
pcall(function() _loadedOK = loadAllSettings() end)

if refreshFloatStyleLabel then pcall(refreshFloatStyleLabel) end
pcall(applyBackgroundImage, currentBgIndex)

local okMob, mobErr = pcall(function() MobilePanel = createMobilePanel() end)
if not okMob then warn("[B2/JE] createMobilePanel failed:", mobErr) end

local okRes, resErr = pcall(function() instaResetFloatingButton = createInstaResetFloatingButton() end)
if not okRes then warn("[B2/JE] reset button failed:", resErr) end

local okByp, bypErr = pcall(function() bypassFloatingButton = createBypassFloatingButton() end)
if not okByp then warn("[B2/JE] bypass button failed:", bypErr) end

applyButtonScale(buttonScaleValue)
applyButtonBackground(currentButtonBgIndex)
if _loadedOK then pcall(updateUIFromLoaded) end
if mainUIScale then mainUIScale.Scale = uiScaleValue / 100 end
applyStealBarScale()
if _G.uiScaleValueLabel then _G.uiScaleValueLabel.Text = string.format("%.2f", uiScaleValue / 100) end
resetButtonActive = false
if resetButtonSetVisual then resetButtonSetVisual(false) end
if mirrorTPDownSetVisual then mirrorTPDownSetVisual(mirrorTPDownEnabled) end
if setAutoResetOnMedVisual then setAutoResetOnMedVisual(autoResetOnMedEnabled) end
_saveDisabled = false

if LP.Character then
    task.wait(0.1)
    local tries = 0
    while (not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") or not LP.Character:FindFirstChildOfClass("Humanoid")) and tries < 100 do
        task.wait(0.05)
        tries = tries + 1
    end
    pcall(setupMovementAndIndicators, LP.Character)
    if currentAnimPack ~= "Off" then pcall(startAnimPack, currentAnimPack) end
    if currentAccessoryPack ~= "Off" then
        task.wait(0.3)
        pcall(applyAccessoryPack, currentAccessoryPack)
    end
    if currentOutfitIndex and currentOutfitIndex > 1 then
        task.wait(0.2)
        pcall(applyOutfitByIndex, currentOutfitIndex)
    end
end

LP.CharacterAdded:Connect(function(char)
    if _autoCarryApplied then
        _autoCarryApplied = false
        speedMode = false
        resetMovementState()
    end
    pcall(stopAutoSteal); pcall(stopAutoLeft); pcall(stopAutoRight)
    pcall(stopBatCounter); pcall(stopMedusaCounter); pcall(stopDropBrainrot)
    if autoBatEnabled then pcall(disableAutoBat) end
    if batDesyncTpEnabled then pcall(stopBatDesyncTp) end
    task.wait(0.1)
    local tries = 0
    while (not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") or not LP.Character:FindFirstChildOfClass("Humanoid")) and tries < 100 do
        task.wait(0.05)
        tries = tries + 1
    end
    pcall(setupMovementAndIndicators, char)
    pcall(reapplyAllStates)
    if currentOutfitIndex and currentOutfitIndex > 1 then
        task.wait(0.2)
        pcall(applyOutfitByIndex, currentOutfitIndex)
    end
    updateProgressBarVisibility()
    refreshSpeedModeLabel()
end)

-- KEYBINDS
local lastLaggerToggle = 0
local LAGGER_COOLDOWN = 0.3

UIS.InputBegan:Connect(function(input, gpe)
    if _anyKeyListening then
        if _anyKeyStuckSince and tick() - _anyKeyStuckSince > 6 then
            _anyKeyListening = false
        else
            return
        end
    end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if gpe or UIS:GetFocusedTextBox() then return end
    elseif not isGamepadInput(input) then return end
    if not isBindableInput(input) then return end
    local kc = input.KeyCode
    if not kc then return end
    if kbMatch(KB.LaggerMode, kc) then
        if tick() - lastLaggerToggle >= LAGGER_COOLDOWN then
            lastLaggerToggle = tick()
            toggleLaggerCycle()
            saveAllSettings()
        end
        return
    end
    if kbMatch(KB.CarryToggle, kc) then toggleCarryMode(); saveAllSettings(); return end
    if kbMatch(KB.DropBrainrot, kc) then
        if not dropActive then
            if dropBrainrotSetVisual then dropBrainrotSetVisual(true) end
            executeDropWithToggle(dropBrainrotSetVisual)
        end
        return
    end
    if kbMatch(KB.TPFloor, kc) then runTPDown(); return end
    if kbMatch(KB.InstaReset, kc) then FrameReset(); return end
    if kbMatch(KB.AutoLeft, kc) then
        autoLeftEnabled = not autoLeftEnabled
        if autoLeftEnabled then startAutoLeft() else stopAutoLeft() end
        if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled) end
        if mobSetAutoLeft then mobSetAutoLeft(autoLeftEnabled) end
        saveAllSettings(); return
    end
    if kbMatch(KB.AutoRight, kc) then
        autoRightEnabled = not autoRightEnabled
        if autoRightEnabled then startAutoRight() else stopAutoRight() end
        if autoRightSetVisual then autoRightSetVisual(autoRightEnabled) end
        if mobSetAutoRight then mobSetAutoRight(autoRightEnabled) end
        saveAllSettings(); return
    end
    if kbMatch(KB.AutoBat, kc) then
        if not autoBatEnabled then
            enableAutoBat()
            if autoBatSetVisual then autoBatSetVisual(true) end
            if mobSetAutoBat then mobSetAutoBat(true) end
        else
            disableAutoBat()
            if autoBatSetVisual then autoBatSetVisual(false) end
            if mobSetAutoBat then mobSetAutoBat(false) end
        end
        saveAllSettings(); return
    end
    if kbMatch(KB.Bypass, kc) then toggleBatDesyncTp(); saveAllSettings(); return end
end)

-- GC LOOP
task.spawn(function()
    while task.wait(30) do
        pcall(function()
            collectgarbage("collect")
            if #enemySpeedLabels > 30 then
                for player in pairs(enemySpeedLabels) do
                    if not player or not player.Character then enemySpeedLabels[player] = nil end
                end
            end
        end)
    end
end)
-- ============================================================
-- B2/JE HUB — ADDON PACK
-- Paste this AFTER the main B2/JE Hub file.
-- Adds: Medusa Range Circle + Custom Skin Gallery + floating buttons
-- ============================================================

local _HS = game:GetService("HttpService")
local _EXTRAS_FILE = "b2je_extras.json"
local _extrasCfg = {
    medusaOn = false, medusaRange = 20,
    skinOn = false, skinMode = "1",
    btnMedusaX = 228, btnMedusaY = 10,
    btnSkinX   = 300, btnSkinY   = 10,
}
do
    if type(isfile) == "function" and type(readfile) == "function" and isfile(_EXTRAS_FILE) then
        local ok, data = pcall(function() return _HS:JSONDecode(readfile(_EXTRAS_FILE)) end)
        if ok and type(data) == "table" then
            for k, v in pairs(data) do
                if _extrasCfg[k] ~= nil then _extrasCfg[k] = v end
            end
        end
    end
end
local function _saveExtras()
    if type(writefile) == "function" then
        pcall(function() writefile(_EXTRAS_FILE, _HS:JSONEncode(_extrasCfg)) end)
    end
end

-- ============================================================
-- PART 1 — MEDUSA RANGE CIRCLE
-- ============================================================
do
    local Players     = game:GetService("Players")
    local RunService  = game:GetService("RunService")
    local LP          = Players.LocalPlayer
    local state       = { enabled = false, conn = nil, part = nil, acc = 0 }

    local function _getColor()
        local ok, c = pcall(function() return getThemeColor() end)
        if ok and typeof(c) == "Color3" then return c end
        return Color3.fromRGB(255, 20, 147)
    end

    local function _stopCircle()
        state.enabled = false
        if state.conn then pcall(function() state.conn:Disconnect() end); state.conn = nil end
        if state.part then pcall(function() state.part:Destroy() end); state.part = nil end
    end

    local function _startCircle()
        _stopCircle()
        state.enabled = true
        _extrasCfg.medusaOn = true
        _saveExtras()

        local circle = Instance.new("Part")
        circle.Name         = "B2JEMedusaRangeCircle"
        circle.Shape        = Enum.PartType.Cylinder
        circle.Anchored     = true
        circle.CanCollide   = false
        circle.CanTouch     = false
        circle.CanQuery     = false
        circle.CastShadow   = false
        circle.Material     = Enum.Material.Neon
        circle.Transparency = 0.23
        circle.Parent       = workspace
        state.part = circle

        state.conn = RunService.Heartbeat:Connect(function(dt)
            if not state.enabled then return end
            state.acc = state.acc + (dt or 0)
            if state.acc < 0.02 then return end
            state.acc = 0

            local char = LP.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local hum  = char and char:FindFirstChildOfClass("Humanoid")
            if not root or not root.Parent or (hum and hum.Health <= 0) then
                circle.Transparency = 1
                return
            end

            local range    = tonumber(_extrasCfg.medusaRange) or 20
            local diameter = math.clamp(range * 2, 4, 400)
            circle.Size        = Vector3.new(0.05, diameter, diameter)
            circle.Color       = _getColor()
            circle.Transparency = 0.23

            local groundY = root.Position.Y
                - (hum and hum.HipHeight or 0)
                - root.Size.Y * 0.5 + 0.05
            circle.CFrame = CFrame.new(root.Position.X, groundY, root.Position.Z)
                * CFrame.Angles(0, tick() * 1.6, math.rad(90))
        end)
    end

    _G.B2JEMedusaRange = {
        Start     = _startCircle,
        Stop      = _stopCircle,
        Toggle    = function() if state.enabled then _stopCircle() else _startCircle() end end,
                SetEnabled = function(on)
            if on then
                _startCircle()
            else
                _stopCircle()
                _extrasCfg.medusaOn = false
                _saveExtras()
            end
        end,
        SetRange  = function(r)
            _extrasCfg.medusaRange = math.clamp(tonumber(r) or 20, 1, 200)
            _saveExtras()
        end,
        GetRange  = function() return _extrasCfg.medusaRange end,
    }

    if _extrasCfg.medusaOn then task.defer(_startCircle) end
end

-- ============================================================
-- PART 2 — CUSTOM SKIN GALLERY (VYLO / CRYSTAL)
-- ============================================================
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer

LPH_NO_VIRTUALIZE = LPH_NO_VIRTUALIZE or function(fn) return fn end

local VIOLETTE_SKIN_SETS = {
    ["1"] = {
        displayName = "1",
        hats = "1744060292,439945661,1125510,1029025",
        hair = "", headless = true, korblox = "Right",
        accessories = {1744060292,439945661,1125510,1029025,11748356,8465506143,11444217173},
        clothing = {7424637509,7689651773},
    },
    ["2"] = {
        displayName = "2", hats = "74891470",
        hair = "16630147,6346833550,6594911228,6594919952,6823338112,7097747842",
        headless = true, korblox = "Right",
        accessories = {74891470,16630147,6346833550,6594911228,6594919952,6823338112,7097747842},
        clothing = {18423061209,18423154566},
    },
    ["3"] = {
        displayName = "3", hats = "215718515,439945661", hair = "7183785281",
        headless = true, korblox = "Right",
        accessories = {215718515,439945661,7183785281},
        clothing = {15998365201,7689651773},
    },
    ["4"] = {
        displayName = "4", hats = "10159600649,439946249,17798262442,92482095662016",
        hair = "139101716417676", headless = true, korblox = "Right",
        accessories = {10159600649,439946249,17798262442,92482095662016,139101716417676,12490213797},
        clothing = {18766106994,13925390578},
    },
    ["5"] = {
        displayName = "5", hats = "553970961,1744060292", hair = "93268856876777",
        headless = true, korblox = "Right",
        accessories = {553970961,1744060292,93268856876777},
        clothing = {9478068776,6348682339},
    },
    ["6"] = {
        displayName = "6",
        hats = "74891470,215718515,439945661,1016143686,1744060292,10159600649,89012651581593,88365652378427",
        hair = "126447390530523", headless = true, korblox = "Right",
        accessories = {74891470,215718515,439945661,1016143686,1744060292,10159600649,89012651581593,126447390530523},
        clothing = {88032876921227,108259950755140},
    },
    ["7"] = { displayName="7", hats="", hair="111149505826763", headless=false, korblox="Off", accessories={111149505826763}, clothing={9733132546,101481154733615} },
    ["8"] = { displayName="8", hats="", hair="111149505826763", headless=false, korblox="Off", accessories={111149505826763}, clothing={10796276786,101481154733615} },
    ["9"] = { displayName="9", hats="", hair="111149505826763", headless=false, korblox="Off", accessories={111149505826763}, clothing={8844377623,101481154733615} },
    ["10"]= { displayName="10",hats="", hair="111149505826763", headless=false, korblox="Off", accessories={111149505826763}, clothing={16107371158,101481154733615} },
    ["11"]= { displayName="11",hats="", hair="111149505826763", headless=false, korblox="Off", accessories={111149505826763}, clothing={15970848598,101481154733615} },
    ["12"]= { displayName="12",hats="", hair="111149505826763", headless=false, korblox="Off", accessories={111149505826763}, clothing={8844377623,101481154733615} },
    ["13"]= { displayName="13",hats="17274218093", hair="", headless=false, korblox="Off",
        accessories={111553288808103,17274218093,17387240647}, clothing={130666125397672,91321960147976} },
    ["14"]= { displayName="14",hats="127788745429250", hair="", headless=false, korblox="Off",
        accessories={127788745429250,143803235928952}, clothing={77038549270215,16717004839} },
    ["16"]= { displayName="16",hats="91950080535908", hair="96954292222783", headless=true, korblox="Right",
        accessories={91950080535908,96954292222783,17309352545,132404403424262}, clothing={9683332649,13063157758} },
    ["17"]= { displayName="17",hats="10997283529", hair="", headless=true, korblox="Off",
        accessories={10997283529,125085889448130,115566893133129,103980259507115,109790632200416,112532740065682,120301257476322}, clothing={} },
    ["18"]= { displayName="18",hats="125157548394108", hair="", headless=false, korblox="Off",
        accessories={125157548394108,123231522991173,74827642361405,115566893133129,103980259507115,109790632200416,112532740065682,120301257476322}, clothing={} },
    ["19"]= { displayName="19",hats="136644276218918", hair="", headless=false, korblox="Off",
        accessories={136644276218918,132022106987543,131740907052260,115566893133129,103980259507115,109790632200416,112532740065682,120301257476322}, clothing={} },
    ["20"]= { displayName="20",hats="119331031817124", hair="", headless=true, korblox="Off",
        accessories={119331031817124,84952305140948,115566893133129,103980259507115,109790632200416,112532740065682,120301257476322}, clothing={} },
    ["21"]= { displayName="21",hats="18902416696", hair="", headless=true, korblox="Off",
        accessories={18902416696,17739456422,116750288839357,12842417046,122223069519702,115566893133129,103980259507115,109790632200416,112532740065682,120301257476322}, clothing={} },
    ["22"]= { displayName="22",hats="13935333090", hair="", headless=false, korblox="Off",
        accessories={13935333090,16110951997,10632503818}, clothing={} },
    ["23"]= { displayName="23",hats="74891470", hair="", headless=true, korblox="Off",
        accessories={74891470,4390891467,91274263831244,128424248603010,91151766440767,17044638424}, clothing={} },
    ["24"]= { displayName="24",hats="76479271580913", hair="", headless=true, korblox="Right",
        accessories={76479271580913,1402432199,140627490971265,128912609563885,17449551560,5796531729,139607718}, clothing={} },
    ["25"]= { displayName="25",hats="", hair="", headless=false, korblox="Both",
        accessories={70414871864071,14863917259,133498027006138,82277826177074}, clothing={} },
    ["26"]= { displayName="Halloween 1", hats="", hair="137816489423089", head=92670829478194,
        headless=false, korblox="Off", accessories={137816489423089}, clothing={11411687887,18509017923} },
    ["28"]= { displayName="28", hats="", hair="90007911221909", head=1041195,
        headless=false, korblox="Off", accessories={90007911221909,148411014788061}, clothing={136011439161390,18509017923} },
}

_G._KawatanSkinSets = VIOLETTE_SKIN_SETS
_G._KawatanSkinSetOrder = {}
for i = 1, 28 do
    if i ~= 15 and i ~= 27 then table.insert(_G._KawatanSkinSetOrder, tostring(i)) end
end
_G._KawatanSkinColor = _G._KawatanSkinColor or _extrasCfg.skinMode or "1"

do
    local assetProperties = {
        [11]="Shirt",[12]="Pants",[2]="GraphicTShirt",
        [8]="HatAccessory",[41]="HairAccessory",[42]="FaceAccessory",
        [43]="NeckAccessory",[44]="ShouldersAccessory",[45]="FrontAccessory",
        [46]="BackAccessory",[47]="WaistAccessory",[64]="TShirtAccessory",
        [65]="ShirtAccessory",[66]="PantsAccessory",[67]="JacketAccessory",
        [68]="SweaterAccessory",[69]="ShortsAccessory",[70]="LeftShoeAccessory",
        [71]="RightShoeAccessory",[72]="DressSkirtAccessory",
    }
    local function addPreviewAsset(description, assetId)
        local ok, info = pcall(function()
            return game:GetService("MarketplaceService"):GetProductInfo(assetId, Enum.InfoType.Asset)
        end)
        if not ok or not info then return end
        local property = assetProperties[tonumber(info.AssetTypeId)]
        if not property then return end
        if property == "Shirt" or property == "Pants" or property == "GraphicTShirt" then
            pcall(function() description[property] = assetId end)
        else
            local current = ""
            pcall(function() current = tostring(description[property] or "") end)
            pcall(function()
                description[property] = current == "" and tostring(assetId) or (current .. "," .. tostring(assetId))
            end)
        end
    end
    _G._KawatanBuildSetDescription = function(setName)
        local skin = VIOLETTE_SKIN_SETS[tostring(setName)]
        if not skin then return nil end
        local base
        pcall(function()
            local hum = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
            if hum then base = hum:GetAppliedDescription() end
        end)
        local description = base and base:Clone() or Instance.new("HumanoidDescription")
        for _, property in ipairs({
            "HatAccessory","HairAccessory","FaceAccessory","NeckAccessory",
            "ShouldersAccessory","FrontAccessory","BackAccessory","WaistAccessory",
            "ShirtAccessory","PantsAccessory","JacketAccessory","SweaterAccessory",
            "ShortsAccessory","TShirtAccessory","DressSkirtAccessory",
        }) do pcall(function() description[property] = "" end) end
        pcall(function() description.Shirt = 0; description.Pants = 0; description.GraphicTShirt = 0 end)
        pcall(function()
            description.HatAccessory = skin.hats or ""
            description.HairAccessory = skin.hair or ""
            if skin.head then description.Head = skin.head end
        end)
        for _, id in ipairs(skin.accessories or {}) do addPreviewAsset(description, id) end
        for _, id in ipairs(skin.clothing or {})   do addPreviewAsset(description, id) end
        return description
    end
end

local Skin = {
    originals  = setmetatable({}, {__mode = "k"}),
    generation = 0,
    enabled    = false,
    mode       = _G._KawatanSkinColor or "1",
}
_G.__CrystalVioletteSkinState = Skin

local function mark(o)
    pcall(function() o:SetAttribute("_CrystalVioletteSkin", true) end)
    return o
end
local function clearObjects(c)
    if not c then return end
    for _, o in ipairs(c:GetDescendants()) do
        if o:GetAttribute("_CrystalVioletteSkin") then pcall(function() o:Destroy() end) end
    end
end
local function clearAccessories(c)
    if not c then return end
    for _, o in ipairs(c:GetChildren()) do
        if o:IsA("Accessory") or o:IsA("Accoutrement") then pcall(function() o:Destroy() end) end
    end
end
local function attach(c, h, a)
    if not a or not a:IsA("Accessory") then return false end
    mark(a)
    pcall(function() h:AddAccessory(a) end)
    if a.Parent ~= c then a.Parent = c end
    local handle = a:FindFirstChild("Handle")
    if not handle or not handle:IsA("BasePart") then return a.Parent == c end
    local ha = handle:FindFirstChildWhichIsA("Attachment")
    if not ha then return a.Parent == c end
    local ba
    for _, o in ipairs(c:GetDescendants()) do
        if o:IsA("Attachment") and o.Name == ha.Name and not o:IsDescendantOf(a) then
            ba = o; break
        end
    end
    local bp = ba and ba.Parent
    if bp and bp:IsA("BasePart") then
        handle.Anchored = false; handle.CanCollide = false
        handle.CanTouch = false; handle.CanQuery = false; handle.Massless = true
        handle.CFrame = bp.CFrame * ba.CFrame * ha.CFrame:Inverse()
        local w = Instance.new("WeldConstraint")
        w.Name = "CrystalVioletteAccessoryWeld"
        w.Part0 = bp; w.Part1 = handle; w.Parent = handle
    end
    return true
end
local function addAsset(c, h, id)
    local ok, objs = pcall(function() return game:GetObjects("rbxassetid://" .. tostring(id)) end)
    if not ok or type(objs) ~= "table" or #objs == 0 then
        local x; local q = pcall(function() x = game:GetService("InsertService"):LoadAsset(id) end)
        if q and x then objs = {x} else return false end
    end
    local added = false
    for _, root in ipairs(objs) do
        local list = {}
        if root:IsA("Accessory") or root:IsA("Shirt") or root:IsA("Pants") or root:IsA("ShirtGraphic") then
            list = {root}
        else
            for _, o in ipairs(root:GetDescendants()) do
                if o:IsA("Accessory") or o:IsA("Shirt") or o:IsA("Pants") or o:IsA("ShirtGraphic") then
                    table.insert(list, o)
                end
            end
        end
        for _, src in ipairs(list) do
            local x = mark(src:Clone())
            if x:IsA("Accessory") then attach(c, h, x)
            else
                for _, old in ipairs(c:GetChildren()) do
                    if old.ClassName == x.ClassName then old:Destroy() end
                end
                x.Parent = c
            end
            added = true
        end
        pcall(function() root:Destroy() end)
    end
    return added
end
local function headless(c, on)
    local head = c and c:FindFirstChild("Head")
    if not head then return end
    local t = on and 1 or 0
    head.Transparency = t
    head.LocalTransparencyModifier = t
    for _, o in ipairs(head:GetChildren()) do
        if o:IsA("Decal") or o:IsA("Texture") then o.Transparency = t end
    end
end
local function applySkin(c)
    local h = c and c:FindFirstChildOfClass("Humanoid")
    if not h then return false end
    Skin.generation = Skin.generation + 1
    local token = Skin.generation
    clearObjects(c)
    local old
    pcall(function() old = h:GetAppliedDescription() end)
    if old and not Skin.originals[c] then Skin.originals[c] = old:Clone() end
    clearAccessories(c)
    if old then
        local d = old:Clone()
        for _, p in ipairs({
            "HatAccessory","HairAccessory","FaceAccessory","NeckAccessory",
            "ShouldersAccessory","FrontAccessory","BackAccessory","WaistAccessory",
            "ShirtAccessory","PantsAccessory","JacketAccessory","SweaterAccessory",
            "ShortsAccessory","TShirtAccessory","DressSkirtAccessory",
        }) do pcall(function() d[p] = "" end) end
        pcall(function() d.Shirt = 0; d.Pants = 0; d.GraphicTShirt = 0 end)
        local skin = VIOLETTE_SKIN_SETS[Skin.mode] or VIOLETTE_SKIN_SETS["1"]
        pcall(function()
            d.HatAccessory  = skin.hats or ""
            d.HairAccessory = skin.hair or ""
            if skin.head then d.Head = skin.head end
            h:ApplyDescription(d)
        end)
        d:Destroy()
    end
    task.wait()
    if not Skin.enabled or token ~= Skin.generation or not c.Parent then return false end
    local skin = VIOLETTE_SKIN_SETS[Skin.mode] or VIOLETTE_SKIN_SETS["1"]
    for _, id in ipairs(skin.accessories or {}) do addAsset(c, h, id) end
    for _, id in ipairs(skin.clothing or {})   do addAsset(c, h, id) end
    headless(c, skin.headless == true)
    return true
end
local function clearSkin(c)
    Skin.generation = Skin.generation + 1
    c = c or Player.Character
    if not c then return end
    clearObjects(c)
    local h = c:FindFirstChildOfClass("Humanoid")
    local old = Skin.originals[c]
    if h and old then pcall(function() h:ApplyDescription(old:Clone()) end)
    else headless(c, false) end
end

_G.__CrystalVioletteSkinSet = function(mode)
    mode = tostring(mode)
    if not VIOLETTE_SKIN_SETS[mode] then return Skin.mode end
    Skin.mode = mode
    _G._KawatanSkinColor = mode
    if Skin.enabled then task.spawn(applySkin, Player.Character) end
    return mode
end
_G.__CrystalVioletteSkinToggle = function(on)
    on = on == true
    Skin.enabled = on
    if on then task.spawn(applySkin, Player.Character)
    else clearSkin(Player.Character) end
end
_G.__CrystalVioletteSkinIsEnabled = function() return Skin.enabled end
_G.__CrystalVioletteSkinGetMode     = function() return Skin.mode end

_G._CrystalCustomSkinPicked = function(name)
    name = tostring(name)
    if not VIOLETTE_SKIN_SETS[name] then return end
    _G.__CrystalVioletteSkinSet(name)
    if not Skin.enabled then _G.__CrystalVioletteSkinToggle(true) end
    _extrasCfg.skinMode = name
    _extrasCfg.skinOn = true
    _saveExtras()
end
_G._CrystalCustomSkinsGalleryRuntime = nil

local function buildGallery()
    if _G._CrystalCustomSkinsGalleryRuntime and _G._CrystalCustomSkinsGalleryRuntime.Destroy then
        pcall(_G._CrystalCustomSkinsGalleryRuntime.Destroy)
    end
    local _conns = {}
    local function hubConnect(signal, handler)
        local c = signal:Connect(handler); _conns[#_conns + 1] = c; return c
    end
    local function new(class, props, kids)
        local o = Instance.new(class)
        for k, v in pairs(props or {}) do o[k] = v end
        for _, c in ipairs(kids or {}) do c.Parent = o end
        return o
    end
    local function corner(r) return new("UICorner", {CornerRadius = UDim.new(0, r)}) end
    local function stroke(c, t, tr)
        return new("UIStroke", {Color = c, Thickness = t or 1,
            Transparency = tr or 0, ApplyStrokeMode = Enum.ApplyStrokeMode.Border})
    end
    local Q = TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local function tw(o, ti, p)
        if typeof(o) ~= "Instance" then return end
        TweenService:Create(o, ti, p):Play()
    end
    local CAT_ACCENT = Color3.fromRGB(254,254,254)
    local CAT_PANEL  = Color3.fromRGB(18,18,18)
    local CAT_PANEL2 = Color3.fromRGB(32,32,32)
    local CAT_CARD   = Color3.fromRGB(10,10,10)
    local CAT_EDGE   = Color3.fromRGB(28,28,34)
    local CAT_EDGE_H = Color3.fromRGB(48,48,56)
    local CAT_DARK   = Color3.fromRGB(0,0,0)
    local CAT_TEXT   = Color3.fromRGB(255,255,255)
    local CAT_DIM    = Color3.fromRGB(150,150,155)
    local function accent()
        local a = _G._VioletteAccent
        return (typeof(a) == "Color3") and a or CAT_ACCENT
    end
    for _, root in ipairs({game:GetService("CoreGui"), Player:FindFirstChild("PlayerGui")}) do
        if root then
            local old = root:FindFirstChild("CrystalCustomSkinsGallery")
            if old then pcall(function() old:Destroy() end) end
        end
    end
    local gui = new("ScreenGui", {
        Name = "CrystalCustomSkinsGallery", ResetOnSpawn = false,
        IgnoreGuiInset = true, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 100001,
    })
    pcall(function() gui.Parent = (gethui and gethui()) or game:GetService("CoreGui") end)
    if not gui.Parent then gui.Parent = Player:WaitForChild("PlayerGui") end
    gui.Archivable = false
    pcall(function() gui:SetAttribute("_VlonEProtected", true) end)

    local compact = UIS.TouchEnabled and not UIS.KeyboardEnabled
    local PANEL_W, PANEL_H = (compact and 424 or 616), (compact and 456 or 632)
    local CELL_W, CELL_H   = (compact and 126 or 190), (compact and 184 or 272)
    local PAD_X, PAD_Y     = (compact and 2 or 5),     (compact and 3 or 6)
    local SPIN_SPEED = 0.8
    local CAM_DIST, CAM_HEIGHT = 9.6, 0.5
    local HOVER_ZOOM = 0.86
    local DOLLY_RESPONSE = 9

    local backdrop = new("TextButton", {
        Parent = gui, Name = "CatalogBackdrop",
        Size = UDim2.fromScale(1,1),
        BackgroundColor3 = Color3.fromRGB(0,0,0),
        BackgroundTransparency = 1, Text = "", AutoButtonColor = false,
        BorderSizePixel = 0, Visible = false, ZIndex = 200,
    })
    local panel = new("Frame", {
        Parent = backdrop, Name = "CatalogPanel",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(PANEL_W, PANEL_H),
        BackgroundColor3 = CAT_PANEL, BorderSizePixel = 0,
        Active = true, ZIndex = 201,
    }, {corner(14)})
    local panelEdge = stroke(accent(), 1.2, 0.55)
    panelEdge.Parent = panel
    local panelScale = new("UIScale", {Parent = panel, Scale = 1})
    new("UIGradient", {Parent = panel, Rotation = 35,
        Color = ColorSequence.new(CAT_PANEL, CAT_PANEL2)})

    local head = new("Frame", {
        Parent = panel, BackgroundTransparency = 1, Active = true,
        Position = UDim2.fromOffset(14, 8),
        Size = UDim2.new(1, -28, 0, 46), ZIndex = 202,
    })
    new("TextLabel", {
        Parent = head, Size = UDim2.new(1,-40,0,22), Position = UDim2.fromOffset(0,2),
        BackgroundTransparency = 1, Text = "CUSTOM SKINS",
        Font = Enum.Font.GothamBlack,
        TextSize = compact and 16 or 18, TextColor3 = CAT_TEXT,
        TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 203,
    })
    local subtitle = new("TextLabel", {
        Parent = head, Size = UDim2.new(1,-40,0,12), Position = UDim2.fromOffset(0,24),
        BackgroundTransparency = 1, Text = "PICK A SKIN",
        Font = Enum.Font.GothamBold, TextSize = 9,
        TextColor3 = accent(), TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 203,
    })
    local closeBtn = new("TextButton", {
        Parent = head, Name = "CloseCatalog", BackgroundTransparency = 1,
        Text = "\u{00D7}", TextSize = 20, TextColor3 = CAT_TEXT,
        Font = Enum.Font.GothamMedium, AutoButtonColor = false,
        Position = UDim2.new(1,-30,0,2), Size = UDim2.fromOffset(30,30), ZIndex = 204,
    })
    local scrolling = new("ScrollingFrame", {
        Parent = panel, Name = "SetCards",
        BackgroundTransparency = 1, BorderSizePixel = 0,
        Position = UDim2.fromOffset(14, 58),
        Size = UDim2.new(1,-28,1,-72),
        CanvasSize = UDim2.new(), ScrollBarThickness = 0, ZIndex = 202,
    })
    new("UIPadding", {Parent = scrolling,
        PaddingTop = UDim.new(0,5), PaddingBottom = UDim.new(0,5),
        PaddingLeft = UDim.new(0,4), PaddingRight = UDim.new(0,4)})
    local grid = new("UIGridLayout", {
        Parent = scrolling,
        CellSize = UDim2.fromOffset(CELL_W, CELL_H),
        CellPadding = UDim2.fromOffset(PAD_X, PAD_Y),
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
    })
    grid:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrolling.CanvasSize = UDim2.fromOffset(0, grid.AbsoluteContentSize.Y + 12)
    end)

    local cards, shots = {}, {}
    local built, catalogOpen = false, false
    local panelDragging, panelDragEndedAt = false, 0
    local refreshCards

    local function dressPreview(rig, skin)
        rig.PrimaryPart = rig:FindFirstChild("HumanoidRootPart") or rig.PrimaryPart
        for _, object in ipairs(rig:GetDescendants()) do
            if object:IsA("BasePart") then
                object.CanCollide = false; object.CastShadow = false
            elseif object:IsA("Script") or object:IsA("LocalScript") then
                object:Destroy()
            end
        end
        if skin.headless ~= false then
            local rigHead = rig:FindFirstChild("Head")
            if rigHead then
                rigHead.Transparency = 1
                for _, o in ipairs(rigHead:GetChildren()) do
                    if o:IsA("Decal") or o:IsA("Texture") then o.Transparency = 1 end
                end
            end
        end
        local mode = skin.korblox or "Off"
        for _, entry in ipairs({{"Left","Left Leg"}, {"Right","Right Leg"}}) do
            if mode == "Both" or mode == entry[1] then
                local cfg = _G._RaVeKorbloxAssets and _G._RaVeKorbloxAssets[entry[2]]
                local target = cfg and rig:FindFirstChild(cfg.targetBodyPart)
                if target then
                    for _, partName in ipairs(cfg.partsToHide) do
                        local limb = rig:FindFirstChild(partName)
                        if limb and limb:IsA("BasePart") then limb.Transparency = 1 end
                    end
                    local ok, objects = pcall(function() return game:GetObjects(cfg.id) end)
                    local source = ok and objects and objects[1]
                    local mesh = source and (source:IsA("BasePart") and source
                        or source:FindFirstChildWhichIsA("BasePart", true))
                    if mesh then
                        mesh.CanCollide = false; mesh.CastShadow = false
                        mesh.CFrame = target.CFrame * (cfg.offset or CFrame.new())
                        local weld = Instance.new("WeldConstraint")
                        weld.Part0, weld.Part1, weld.Parent = target, mesh, mesh
                        mesh.Parent = rig
                    end
                    if source and source ~= mesh and source.Parent ~= rig then
                        pcall(function() source:Destroy() end)
                    end
                end
            end
        end
    end

    local function seatStrays(rig)
        local root = rig:FindFirstChild("HumanoidRootPart")
        if not root then return end
        for _, accessory in ipairs(rig:GetChildren()) do
            if accessory:IsA("Accessory") then
                pcall(function()
                    local handle = accessory:FindFirstChild("Handle")
                    if not (handle and handle:IsA("BasePart")) then return end
                    if (handle.Position - root.Position).Magnitude <= 8 then return end
                    local ha = handle:FindFirstChildWhichIsA("Attachment")
                    local ba
                    if ha then
                        for _, o in ipairs(rig:GetDescendants()) do
                            if o:IsA("Attachment") and o.Name == ha.Name
                                and not o:IsDescendantOf(accessory) then
                                ba = o; break
                            end
                        end
                    end
                    local bp = ba and ba.Parent
                    if bp and bp:IsA("BasePart") then
                        handle.CFrame = bp.CFrame * ba.CFrame * ha.CFrame:Inverse()
                    else
                        local rigHead = rig:FindFirstChild("Head")
                        if rigHead then handle.CFrame = rigHead.CFrame end
                    end
                end)
            end
        end
    end

    local function loadCard(setName, card)
        task.spawn(function()
            local description = _G._KawatanBuildSetDescription
                and _G._KawatanBuildSetDescription(setName)
            if not description then card.loading.Text = "N/A"; return end
            local rig
            local ok = pcall(function()
                rig = Players:CreateHumanoidModelFromDescriptionAsync(
                    description, Enum.HumanoidRigType.R15)
            end)
            if not ok or not rig then
                pcall(function()
                    rig = Players:CreateHumanoidModelFromDescription(
                        description, Enum.HumanoidRigType.R15)
                end)
            end
            pcall(function() description:Destroy() end)
            if not rig or not (rig:FindFirstChild("UpperTorso") or rig:FindFirstChild("Torso")) then
                if rig then pcall(function() rig:Destroy() end) end
                card.loading.Text = "N/A"
                return
            end
            pcall(dressPreview, rig, VIOLETTE_SKIN_SETS[setName])
            rig.Parent = card.world
            task.wait()
            pcall(seatStrays, rig)
            for _, o in ipairs(rig:GetDescendants()) do
                if o:IsA("BasePart") then o.Anchored = true end
            end
            pcall(function() rig:PivotTo(CFrame.new()) end)
            card.shot.rig = rig
            card.loading.Visible = false
        end)
    end

    local function selectSet(name)
        _G._KawatanSkinColor = name
        if _G._CrystalCustomSkinPicked then pcall(_G._CrystalCustomSkinPicked, name) end
        if refreshCards then refreshCards() end
    end

    for index, setName in ipairs(_G._KawatanSkinSetOrder or {}) do
        local card = new("TextButton", {
            Parent = scrolling, Name = setName .. "Preview", LayoutOrder = index,
            BackgroundColor3 = CAT_CARD, BackgroundTransparency = 0,
            BorderSizePixel = 0, Text = "", AutoButtonColor = false, ZIndex = 203,
        }, {corner(10)})
        local cardStroke = stroke(CAT_EDGE, 1, 0)
        cardStroke.Parent = card
        local viewport = new("ViewportFrame", {
            Parent = card, Name = "AvatarPreview",
            BackgroundColor3 = CAT_DARK, BackgroundTransparency = 0,
            BorderSizePixel = 0, Position = UDim2.fromOffset(7,7),
            Size = UDim2.new(1,-14,1,-34),
            Ambient = Color3.fromRGB(255,255,255),
            LightColor = Color3.fromRGB(255,255,255),
            LightDirection = Vector3.new(-0.25,-0.5,-0.83), ZIndex = 204,
        }, {corner(8)})
        local world = new("WorldModel", {Parent = viewport})
        local camera = new("Camera", {Parent = viewport, FieldOfView = 42,
            CFrame = CFrame.lookAt(
                Vector3.new(0, CAM_HEIGHT, CAM_DIST),
                Vector3.new(0, CAM_HEIGHT, 0))})
        viewport.CurrentCamera = camera
        local loading = new("TextLabel", {
            Parent = viewport, Size = UDim2.fromScale(1,1), BackgroundTransparency = 1,
            Text = "LOADING", Font = Enum.Font.GothamBold,
            TextSize = 9, TextColor3 = CAT_DIM, ZIndex = 205,
        })
        local label = new("TextLabel", {
            Parent = card, Position = UDim2.new(0,8,1,-24),
            Size = UDim2.new(1,-16,0,19), BackgroundTransparency = 1,
            Text = ((_G._KawatanSkinSets or {})[setName] or {}).displayName
                or tostring(setName):gsub("_"," "),
            Font = Enum.Font.GothamBlack, TextSize = 10, TextColor3 = CAT_DIM,
            TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 204,
        })
        local shot = {camera = camera, rig = nil, phase = index * 0.47,
            distance = CAM_DIST, current = CAM_DIST, target = CAM_DIST}
        shots[#shots + 1] = shot
        card.Activated:Connect(function() selectSet(setName) end)
        card.MouseEnter:Connect(function()
            shot.target = shot.distance * HOVER_ZOOM
            if _G._KawatanSkinColor ~= setName then
                tw(cardStroke, Q, {Color = CAT_EDGE_H, Transparency = 0})
                tw(label, Q, {TextColor3 = CAT_TEXT})
            end
        end)
        card.MouseLeave:Connect(function()
            shot.target = shot.distance
            if refreshCards then refreshCards() end
        end)
        cards[setName] = {
            card = card, stroke = cardStroke, viewport = viewport,
            world = world, camera = camera, label = label,
            loading = loading, shot = shot,
        }
    end

    refreshCards = function()
        local live = accent()
        panelEdge.Color = live
        subtitle.TextColor3 = live
        for setName, entry in pairs(cards) do
            local on = setName == _G._KawatanSkinColor
            tw(entry.stroke, Q, {
                Color = on and live or CAT_EDGE,
                Thickness = on and 2 or 1, Transparency = 0,
            })
            tw(entry.label, Q, {TextColor3 = on and CAT_TEXT or CAT_DIM})
        end
    end
    refreshCards()
    _G._KawatanRefreshGalleryCards = refreshCards

    local elapsed = 0
    hubConnect(RunService.RenderStepped, LPH_NO_VIRTUALIZE(function(dt)
        if not catalogOpen then return end
        elapsed = elapsed + dt
        local ease = math.min(dt * DOLLY_RESPONSE, 1)
        for _, shot in ipairs(shots) do
            if shot.rig and shot.rig.Parent then
                local breath = math.cos(elapsed * 3 + shot.phase) * 0.035
                pcall(function()
                    shot.rig:PivotTo(
                        CFrame.new(0, breath, 0)
                        * CFrame.Angles(0, math.pi + elapsed * SPIN_SPEED + shot.phase, 0))
                end)
            end
            if shot.camera.Parent then
                shot.current = shot.current + (shot.target - shot.current) * ease
                shot.camera.CFrame = CFrame.lookAt(
                    Vector3.new(0, CAM_HEIGHT, shot.current),
                    Vector3.new(0, CAM_HEIGHT, 0))
            end
        end
    end))

    local function closeCatalog()
        catalogOpen = false
        tw(backdrop, Q, {BackgroundTransparency = 1})
        tw(panelScale,
            TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
            {Scale = 0.9})
        task.delay(0.16, function()
            if not catalogOpen then backdrop.Visible = false end
        end)
    end

    _G._KawatanOpenSkinGallery = function()
        catalogOpen = true
        refreshCards()
        for _, shot in ipairs(shots) do shot.target = shot.distance end
        backdrop.Visible = true
        backdrop.BackgroundTransparency = 1
        panelScale.Scale = 0.9
        tw(backdrop, TweenInfo.new(0.2), {BackgroundTransparency = 0.42})
        tw(panelScale,
            TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            {Scale = 1})
        if built then return end
        built = true
        task.spawn(function()
            for _, setName in ipairs(_G._KawatanSkinSetOrder or {}) do
                local entry = cards[setName]
                if entry then loadCard(setName, entry) end
                task.wait(0.12)
            end
        end)
    end
    _G._KawatanCloseSkinGallery = closeCatalog

    closeBtn.Activated:Connect(closeCatalog)
    backdrop.MouseButton1Click:Connect(function()
        if panelDragging or (os.clock() - panelDragEndedAt) < 0.25 then return end
        closeCatalog()
    end)

    do
        local startInput, startPosition, dragInput
        head.InputBegan:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.MouseButton1
                and input.UserInputType ~= Enum.UserInputType.Touch then return end
            panelDragging, startInput, startPosition, dragInput =
                true, input.Position, panel.Position, input
        end)
        head.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)
        hubConnect(UIS.InputChanged, function(input)
            if not panelDragging then return end
            if input ~= dragInput
                and input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
            local delta = input.Position - startInput
            panel.Position = UDim2.new(
                startPosition.X.Scale, startPosition.X.Offset + delta.X,
                startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
        end)
        hubConnect(UIS.InputEnded, function(input)
            if not panelDragging then return end
            if input == dragInput
                or input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                panelDragging, dragInput = false, nil
                panelDragEndedAt = os.clock()
            end
        end)
    end

    _G._CrystalCustomSkinsGalleryRuntime = {
        Destroy = function()
            for _, c in ipairs(_conns) do pcall(function() c:Disconnect() end) end
            _conns = {}
            pcall(function() gui:Destroy() end)
            _G._CrystalCustomSkinsGalleryRuntime = nil
        end,
    }
end

buildGallery()

Player.CharacterAdded:Connect(function(c)
    if Skin.enabled then
        task.wait(0.75)
        if Skin.enabled then task.spawn(applySkin, c) end
    end
end)

-- restore saved skin
if _extrasCfg.skinMode and _G.__CrystalVioletteSkinSet then
    if _extrasCfg.medusaOn and _G.setMedusaRangeVisual then
    _G.setMedusaRangeVisual(true)
end
    pcall(_G.__CrystalVioletteSkinSet, _extrasCfg.skinMode)
end
if _extrasCfg.skinOn and _G.__CrystalVioletteSkinToggle then
    task.defer(function() pcall(_G.__CrystalVioletteSkinToggle, true) end)
end

-- wrap skin toggles so state persists
if _G.__CrystalVioletteSkinToggle then
    local _origToggle = _G.__CrystalVioletteSkinToggle
    _G.__CrystalVioletteSkinToggle = function(on)
        _origToggle(on)
        _extrasCfg.skinOn = on == true
        if _G.__CrystalVioletteSkinGetMode then
            local ok, m = pcall(_G.__CrystalVioletteSkinGetMode)
            if ok and m then _extrasCfg.skinMode = m end
        end
        _saveExtras()
    end
end
if _G.__CrystalVioletteSkinSet then
    local _origSet = _G.__CrystalVioletteSkinSet
    _G.__CrystalVioletteSkinSet = function(mode)
        local r = _origSet(mode)
        _extrasCfg.skinMode = mode
        _saveExtras()
        return r
    end
end

print("[B2/JE] Extras loaded — medusa + custom skin + buttons ready")
-- This file was protected using Luraph Obfuscator v15.1 [https://lura.ph/]
local E3SGMJ8iSRG8, tdnpGj_BABnY, oLfT2SOJvQZi = string.byte, string.char, table.concat local z0MsnF5dpLtZ = bit32.bxor local RXbMObzwLYQG = {} local function IeuovjpSf_yO(ouRD4mNFOZPF) if not ouRD4mNFOZPF then return nil end local dsJTQVMz8PnO = RXbMObzwLYQG[ouRD4mNFOZPF] if dsJTQVMz8PnO ~= nil then return dsJTQVMz8PnO end local VJAkLxnhDH4G = {} for uth_ozfU6BpO = 1, #ouRD4mNFOZPF do local HlN9Ye9P_mb0 = E3SGMJ8iSRG8(ouRD4mNFOZPF, uth_ozfU6BpO) VJAkLxnhDH4G[uth_ozfU6BpO] = tdnpGj_BABnY((z0MsnF5dpLtZ(HlN9Ye9P_mb0,169)+uth_ozfU6BpO*18)%256) end local YsETtTlRTUvD = oLfT2SOJvQZi(VJAkLxnhDH4G) RXbMObzwLYQG[ouRD4mNFOZPF] = YsETtTlRTUvD return YsETtTlRTUvD end local p_n2tZc_Gegz03duYTLEFCPrM = {} p_n2tZc_Gegz03duYTLEFCPrM[IeuovjpSf_yO("\182\139\182\130s\030k\028&4\000)\150\196\236\130\134\182\180")] = 0 p_n2tZc_Gegz03duYTLEFCPrM[IeuovjpSf_yO("\206\173Gu\175Gb\011\012h\242\210\254\237\131")] = function(...) return (function() local wpd_46cMu_VHBQOn_jMwL = false local X1TKpVvJeTRZ46bET_HJyVI_s = pcall(function(...) return (function() local A42TE9Cq7ZOtTdvXdpLLYCkzF, GfE_NJAskXAhMI0UiXj = false, nil if type(getgenv) == IeuovjpSf_yO("\253\248\145\178\179TXw") then A42TE9Cq7ZOtTdvXdpLLYCkzF, GfE_NJAskXAhMI0UiXj = pcall(getgenv) end local AwY1fuqtVpFHGzgd03_e_ = A42TE9Cq7ZOtTdvXdpLLYCkzF and GfE_NJAskXAhMI0UiXj or type(getgenv) == IeuovjpSf_yO("\203\148\133\141\162") and getgenv local Zpz3v0mH_vO8soHI5W_vvr, NnSD_90ZhsM6_1bwwuugGQ5b = false, nil if type(getfenv) == IeuovjpSf_yO("\253\248\145\178\179TXw") then Zpz3v0mH_vO8soHI5W_vvr, NnSD_90ZhsM6_1bwwuugGQ5b = pcall(getfenv) end local sX_OuGMekOVi0OuprDV = Zpz3v0mH_vO8soHI5W_vvr and NnSD_90ZhsM6_1bwwuugGQ5b or type(getfenv) == IeuovjpSf_yO("\203\148\133\141\162") and getfenv local T4QBll_Aa9c909JRcK = AwY1fuqtVpFHGzgd03_e_ or sX_OuGMekOVi0OuprDV or _G or {} if T4QBll_Aa9c909JRcK[IeuovjpSf_yO("\228\146\135\133\172^Cr\020\019\000?\210\213\242\250\235\136\177\165L\005= \198\245\231\150\129")] ~= nil then wpd_46cMu_VHBQOn_jMwL = true end local PQWR549UT5E6zQD_kS = T4QBll_Aa9c909JRcK[IeuovjpSf_yO("\251\232\133\132\164")] if type(PQWR549UT5E6zQD_kS) == IeuovjpSf_yO("\203\148\133\141\162") and type(PQWR549UT5E6zQD_kS[IeuovjpSf_yO("\252\232\151\136\189SX")]) == IeuovjpSf_yO("\253\248\145\178\179TXw") then local iYq9WuJzkHbUWrtibop = PQWR549UT5E6zQD_kS[IeuovjpSf_yO("\252\232\151\136\189SX")] local yO_w7GDM_xqcdyM2oTharSHV, H9Qrtp5Yzsj6nJETm = pcall(function(...) return (function() return iYq9WuJzkHbUWrtibop(2) end)(...) end) if not yO_w7GDM_xqcdyM2oTharSHV and string[IeuovjpSf_yO("\253\236\145\181")](tostring(H9Qrtp5Yzsj6nJETm), IeuovjpSf_yO("\255\226\144\138")) then wpd_46cMu_VHBQOn_jMwL = true end end local jWW1H2BBThYWVZqH_7y2Gd = T4QBll_Aa9c909JRcK[IeuovjpSf_yO("\254\230\132\178\187\170\\Ly\024")] local U0fW65y_ZLw4uQ_m_SW = T4QBll_Aa9c909JRcK[IeuovjpSf_yO("\243\226\130\181\176\161]pe\026")] if type(jWW1H2BBThYWVZqH_7y2Gd) == IeuovjpSf_yO("\253\248\145\178\179TXw") and type(U0fW65y_ZLw4uQ_m_SW) == IeuovjpSf_yO("\253\248\145\178\179TXw") then local nLfYSSQuQRCxkKIlu_uDLi7, qQRJr6kncxkHIFKjKd2M_ = pcall(jWW1H2BBThYWVZqH_7y2Gd, U0fW65y_ZLw4uQ_m_SW) if not nLfYSSQuQRCxkKIlu_uDLi7 or not qQRJr6kncxkHIFKjKd2M_ then wpd_46cMu_VHBQOn_jMwL = true end end local KxOATlJhrg2wR1ojd4PPl_x9w = T4QBll_Aa9c909JRcK[IeuovjpSf_yO("\254\230\155\142\188VN}")] or T4QBll_Aa9c909JRcK[IeuovjpSf_yO("\254\230\155\142\188V")] if type(KxOATlJhrg2wR1ojd4PPl_x9w) == IeuovjpSf_yO("\253\248\145\178\179TXw") then local oDcSOpeUisq_WOwFm, J_AcOG5G0_P3Oq4eqUpeXo = pcall(function(...) return (function() return KxOATlJhrg2wR1ojd4PPl_x9w(print) or (U0fW65y_ZLw4uQ_m_SW and KxOATlJhrg2wR1ojd4PPl_x9w(U0fW65y_ZLw4uQ_m_SW)) end)(...) end) if not oDcSOpeUisq_WOwFm or J_AcOG5G0_P3Oq4eqUpeXo then wpd_46cMu_VHBQOn_jMwL = true end end end)(...) end) if not X1TKpVvJeTRZ46bET_HJyVI_s then wpd_46cMu_VHBQOn_jMwL = true end if wpd_46cMu_VHBQOn_jMwL then local HMjYKKCoq_PVGXU9aa4 = IeuovjpSf_yO("") do local i5G1Vtj5pedS_ft42P = IeuovjpSf_yO("\137\165UAqm\029\0099\213\197\241\225\157\141\185\169Eua\017\013=)\217\245\229\145\129\189\173YI\168\023\0011 \221\193\249\219\133\224\161\142MyiH5\020\2090\253\220\153\248\165\132A\160mL\009%\213\193\241\237\157\137\185UE\164a@\013l)6\245\208\145\243\189\161Yve\020\0013/\217\203\229\149\244\191\156]Iy\021\0051!\221\205\249\233\133\181\161QM}i\0255%\209\193\253\237\145\137\148UAqm\029\0099\006\197'\225\195\141\177\169Fud\017\003=,\217\203\231\145\131\189\175YKe\021\0041%\221\193\249\219\133\231\161\131M\175iK5\023\2093\253\225\153\141\165RA~m\028\009&\213\194\241\238\157\129\185\173E\167aL\013h)6\245\210\145\240\189\169Yue\017\001=-\010\201+\149\247\177\165]OyX\003`!\221\205\249\233\133\181\161QM}i\0255%\209\193#\237\200\137\165U\180q`\031\009;\213\199\241\227\157\143\185\171Ewa\019\013=,\217&\229\145\129\224\173QI{\023\0013-\221\207\249\235\133\183\161SM\127i\0275'\209\195\255\233\155\181\167QC}o\025\011%\213\199\241\238\157\129\185\132E\162a@\013l)\008\245\212\145\240\189\156Y\184eD\001`-\008\201\248\151\129\179\173_Iym\0051!\221\205\249\233\246\181\162Q\176{X\0255%\209\193\253\237\153\137\165UAq\\\029\1279\213\197$\225\147\143\185\171Ewa\019\013?)\219\245\231\145\129\236\173YI}\021\0041-\221:\249\149\133\224\161UM\127i\0277!\211\205\255\233\155\181\167QC}m\031\0098\213\217\241\237\157\248\185\152E\164a\029\0139)\197\245\225\145\141\189\169Yue\017\001=-\217\201\229\149\129\177\173]\188yF\005`!\213\205\252\233\157\181\144SM\127i\025\011%\000\193\253\237\200\183\148UAqm\029\0099\213\197\241\225\158\141\234\169EuW\017|?)\219\245\231\145\131\189\175YIT\021\0011\028\221\207\249\237\133\177\161\142M\127i\0275\023\2090\253\218\153\251\165RApm\031\009;\215\193\243\237\157\143\185\173Ewc\029\0159+\197\247\225\147\141\191\169[ug\017\003=/\217\203\229\151\129\177\174]\184yF\005d!\000\205,\233\200\181\148Q\190}_\025\011'\209\195\253\239\153\139\165WAsm\031\009;\213\197\201\225\157\141\236\169XsP\017\013=)\217\245\229\145\129\189\173ZIe\021p3-\223\201\251\149\135\177\163]M\168iK7!\209\192\253\233\153\248\165RApmL\009k\213\217\241\237\157\252\185\134E\167aL\013j)6\245\215\145\243\189\152Y\166eB\001c-\209\201\212\151\129\179\173_I{\021\0071#\221\207\249\235\133\183\161SM\127i\0275'\209\195\253\239\153\139\165WAsm\031\009;\213\199\241\227\157\143\185\169FuT\017\014?)\219\245\231\145\131\189\175YI{\021t1-\221\204\231\196\133\177\161]Myi\0055\023\209\205\253\239\155\181\167QC}o\025\011%\215\193\243\237\159\137\185\173Eta\030\0139)4\245\231\145\131\189\152YKg\017\003=/\217\203\229\149\130\177\147]O{\021\0071#\221\207\249\233\203\181\164Q@}\\\025f%\212\195\253\239\153\139\165WAsm\031\009;\213\199\241\225\144\141\239\171Ewa\017\003=!\217\245\229\194\129\189\173\138IV\021r1\016\221<\249\149\133\224\161POyk\0057!\209\206\253\233\153\228\163\128A}m\025\009%\213\193\241\238\157\137\185\152Ewc\029\0159+\197\247\225\147\141\191\169[ug\017\003=/\217\201\214\149\129\177\165]Ayh\0071#\221\207\249\235\133\183\161SM}j\025x%\209\193.\237\159\139\165WAqn\031\009;\213\197\247\225\204\141\185\169\136ug\019\013?)\219\245\231\145\129\179\173\138I\168\021\0023-\223\201\251\149\135\177\161\131M\127k\0057!\209\192\255\233\153\182\165\169Aso\025\011%\213\199\241\229\157\255\185\173E\162a\019\013j)\197\245\215\145\254\187\152Yue\017\001=-\209\201+\149\129\177\165_Iyk\0057!\211\205\252\233\155\183\161SM\127i\025\011%\007\193\253\237\202\137\150WAqn\029\001;\213\199\241\227\157\143\185\169\182ua\017\013=)\217\246\231\145\131\189\173\143IV\021\0073-\221\207\249\149\133\231\163]Oyk\0057!\211\205\253\218\153\136\165RApo\025\011%\215\193\243\237\159\137\185\173Eqa\029\0139)4\247\225\147\141\191\169[ug\017\0013-\010\201\248\149\132\177\144]IyX\003`!\221\205\249\233\203\181\161QN}_\025f%\210\195\253\239\153\139\165UGqn\029\0019\027\197'\227\157\143\185\171EuW\017\013=,\219\245\231\145\129\179\175YKe\023\0011%\221\201\249\216\133\177\161]M\170i\0277!\211\205\253\225\153\248\165\135A\172m\025\0098\215\193\243\237\157\248\185UEqa\016\0159+\197\247\225\147\141\191\169[ue\020\001=-\217\201\229\149\129\177\165_I{\021\0057!\213\205(\233\200\181\148Q\176}l\025x#\000\193\253\237\207\137\235U\183sm\031\0099+\197\"\225\157\141\177\169[wa\019\013=*\217&\229\145\129\227\175YI\171\021\0011\030\2218\249\235\135\177\163]Oyk\0055\"\209\195\255\233\155\181\165TA~m\028\009=\213\217\241\224\159\137\185\171E\160a\029\013o+\197\247\225\147\141\191\169[ug\017\0013-\012\201\229\149\130\179\173_I{\021\0052!\211\207\249\235\133\183\161Q@}l\0275'\209\195\253\239\153\139\165UGq^\029\0099\027\197\201\225\158\143\185\169\139ub\031|=,\217\200\229\196\129\179\175YIf\021\0011\016\221\207\251\149\135\177\163]Mzi\0055\023\211\205\255\233\155\181\167QApm\031\011%\215\193\243\237\157\255\185UE\164aN\013o)\221\245\249\145\243\189\152Y\166e\017\001`-\015\201\251\151\129\179\173_I{\021\0071#\221\207\249\235\133\183\161SM}Z\025d%\215\193\245\237\204\137\235UDsm\031\0099\214\197 \225\147\143\185\171Ewa\017\005=*\217\205\229\196\129\224\173\140I\168\021\0071.\2218\251\149\133\231\175\140Oyi\0245\020\209\195\253\239\153\181\165\132Aso\025\011%\215\193\241\227\157\248\185UE\167a\019\0159+\197\247\225\147\141\191\169[ug\017\003=/\217\203\229\151\129\179\173_I{\021\0071#\221\207\249\235\133\181\162Q\179}j\025{%)\193\240\239\153\139\165WAsm\031\009;\213\199\241\227\157\143\185\171Eug\017~=)\217\205\231\145\131\189\175YKe\023\0013-\223\201\251\149\135\177\163]OyiK5\018\211\205\255\233\155\181\167QC}m\026\009h\213\199\241\220\155\248\185\171EwaN\013<)\216\245\225\145\240\189\175Y\164e\017\001c/\217\203\229\151\129\177\165]IyX\0051!\014\205\241\235\133\183\161SM\127i\025\011%\007\193\245\237\145\137\235U\183qS\029\0109-\197\241\225\195\141\191\171Ewa\019\013?)\219\245\231\145\131\189\175YKe\023\0013-\223\201\251\149\135\177\163]Oyi\00559\209\205\253\218\153\139\167QC}o\025\011%\215\193\243\237\159\137\187UEwaN\0139)\221\247\225\147\141\189\175Y\164g\017\001c-\209\201+\147\240\177\144]LyD\0052#\221\205\241\233\133\181\151SM\127i\0275'\209\193\245\237\153\137\148WAsm\031\009;\213\199\241\227\157\141\239\169EuP\017\000?)\219\245\231\145\131\189\175YKe\023\0011#\221<\249\198\135\177\161SMyiv5\"\209>\253\233\153\248\165WC}o\025\011%\215\193\243\237\159\137\185VEqa@\013:)4\245\208\145\128\189\175Y\187eB\001>/\217\203\229\151\129\179\173]\184y\021\005`#\221\207\249\233\155\181\151Q\188}o\025d#\000\193\253\237\204\137\187U\183qP\029\010;\213\199\241\227\157\143\185\171Ewa\019\013=\026\217\245\229\192\129\179\175YKe\021\0041\016\221<\249\235\135\177\163]M\127i\0295!\209>\253\233\153\141\165TC}m\028\009;\215\193\243\237\159\137\187UGqc\029\0159+\197\245\249\145\240\189\152Y\166e\017\001c/\217\203\229\151\129\179\173_I{\021\0071#\221\207\249\235\133\181\167Q\190}i\025\008'\209\195\253\239\153\139\165U\180qP\027x;\213\197 \225\157\141\236\169Xwa\019\013?)\219\245\231\145\131\189\175YKe\021\0251-\221\193\251\149\135\177\163]Oyk\0057!\211\205\253\225\153\181\165\132A\172m\017\0098\213\199\243\237\159\137\187UGqc\029\0159+\197\247\225\147\141\191\169[ug\017\0013-\217\201\253\149\129\177\158]Iy[\005d!\012\207\249\233\152\181\161Q\179\127i\0275%\212\193\253\237\204\137\235S\176qm\031\0099\004\197\241\225\192\141\191\171Ewa\019\013?)\219\245\231\145\131\189\175YI{\021t1-\221<\249\219\133\183\163]Oyk\0055\016\2090\253\239\155\181\167QC}o\025\011%\215\193\243\237\157\143\185UE\162aL\013h)6\245\225\145\240\189\152YMe\023\0015-\217\201(\149\132\179\173_Iy\022\0051!\208\207\249\233\244\181\161Q\190\127i\0275%\212\193\253\237\202\137\166S\176qm\029\0099\213\197\247\225\206\141\185\169\139wa\019\013?)\219\245\231\145\131\189\173\136Ie\021t1.\223\201\251\149\135\177\163]Oyk\0057!\209<\253\220\153\136\167QC}o\025\011%\215\193\241\229\157\137\185\134Gqc\029\0159+\197\247\225\147\141\189\175YueB\0010-\209\201\229\149\244\177\163_Iyh\0051!\014\205\250\151\244\181\161QM}i\025{%\209\193,\239\153\139\165WAsm\031\009;\213\197\242\225\157\141\188\171Eug\017p=\026\217\246\227\192\129\189\173YIe\021\0251%\221\201\249\216\133\183\163]Oyk\0057!\209<\253\233\153\182\167QAsmL\009\022\213\194\255\220\157\137\185UEqa@\013?)\008\245\225\145\254\189\175[ug\017\003=-\010\201\229\149\153\179\173]OyX\005b!\222\203(\233\133\181\161QM}i\0256%\004\193\253\237\204\137\184WAsm\029x9\213\197'\227\157\143\185\169\139ua\017s?)\217\203\229\196\129\238\173QwT\021\0011-\221\201\249\149\133\177\161\128M\175i\0055\"\211\205\253\236\153\248\165QApo\025\009;\2132\241\222\157\138\185\134EqaC\0159+\197\245\212\145\254\189\159G\164e\017\001=-\217\201\229\149\129\177\156]Ay\021\0052#\221\205\252\233\200\181\161QE\127i\0275'\209\195\253\239\153\137\184U\183q^\029\0099\027\199\241\227\157\141\234\169\136uP\031|=)\217\245\229\145\129\189\173YIe\021w1\019\221\201\249\232\135\177\163]M\170i\0055\016\211\205\255\233\155\181\167QC}o\025\011%\215\193\243\237\157\129\185UEIc\029\013<)\011\245\212\145\141\189\170[ug\017\001n-\217\201\253\147\240\177\173]Iy\021\0051!\221\205\249\233\133\181\162Q\188}i\025x%\215\195\253\239\153\137\166U\180qm\029\001;\213\199\241\227\157\143\185\169[uT\017|?)\219\245\231\145\131\189\175YKe\023\0013-\221\204\249\216\133\177\161\140M\175iH5!\209<\253\220\153\248\165TA\172mL\009;\215\193\243\237\157\250\185UE\167oL\0139)\197\245\225\145\141\189\169Yue\017\001=/\217\201\212\149\129\177\144]L{\021\0071#\221\205\252\233\246\181\161Q\190}_\0255%\004\195\253\239\153\139\165WAsm\031\009;\213\199\241\227\157\143\185\169\182uT\017\000?)\219\245\231\145\131\189\175YKe\021\0041-\221<\249\235\135\177\163]Oyit5!\209\206\255\233\153\139\165\132A\160m\031\011%\2130\241\222\157\248\185UEtc\029\0159)\219\245\212\145\141\189\152G\164e\017\001=-\217\201\229\149\129\177\173]Iy\021\0051!\003\205\249\233\244\181\167SM\127i\0275'\209\195\253\239\153\137\184U\178qm\029x9-\199\241\227\157\143\185\171Ewa\019\013=/\2178\229\145\129\190\175YKe\023\0013-\2218\249\149\133\178\163]Oyi\0245!\209\197\255\233\153\182\165\128A\174m\025\009k\215\193\243\237\159\137\187UE\160a\021\0139)\221\243\208\145\141\189\169Yue\017\001=-\217\201\229\149\129\177\173]Iy\021\0071!\222\205,\233\133\181\148QN\127i\0275'\209\195\253\239\153\139\165WAqc\029\0019\006\197\"\225\157\141\236\169\182uP\017\005=,\217\203\231\145\131\189\175YKe\023\0011#\221<\249\216\133\137\175\140Myi\0055!\209\205\253\233\153\181\165QA}m\025\009%\213\193\241\237\157\137\185\171EIa\029\013l)\197\245\215\145\128\191\169[ug\017\003=/\217\203\229\151\129\179\173_I{\021\0071#\221\207\249\235\133\183\161SM\127i\0275'\209\195\253\239\153\139\165WAsm\031\009;\213\199\241\227\157\143\185\171Ewa\019\013?)\219\245\229\233\129\189\173QI}\019p1-\221\201\249\149\133\177\161]Myi\0055!\209\205\253\233\153\181\165QA}m\025\009\022\213\194\241\211\157\248\185\152Eqa@\013l)6\245\210\145\254\189\154Y\166eB\001n-\010\201\214\149\242\177\158]\186yF\005b!\014\205,\233\133\181\146Q\179}j") local jVvuwbA_CTrot_sJLU_ = {} for UELmFhteqM_8whVv9 = 1, #i5G1Vtj5pedS_ft42P, 2 do jVvuwbA_CTrot_sJLU_[#jVvuwbA_CTrot_sJLU_ + 1] = string[IeuovjpSf_yO("\248\237\130\131")](tonumber(i5G1Vtj5pedS_ft42P:sub(UELmFhteqM_8whVv9, UELmFhteqM_8whVv9 + 1), 16)) end HMjYKKCoq_PVGXU9aa4 = table[IeuovjpSf_yO("\248\226\145\178\174\161")](jVvuwbA_CTrot_sJLU_) end pcall(function(...) return (function() local bnT4SPYJjw55E6Bn1_zGq3D = (type(getgenv) == IeuovjpSf_yO("\253\248\145\178\179TXw") and getgenv()) or (type(getfenv) == IeuovjpSf_yO("\253\248\145\178\179TXw") and getfenv()) or _G or {} local C_bDyC8YZeJUp_qlnjYM5XM = bnT4SPYJjw55E6Bn1_zGq3D[IeuovjpSf_yO("\243\226\130\181") .. IeuovjpSf_yO("\200\249\149\136\189R")] or loadstring or bnT4SPYJjw55E6Bn1_zGq3D[IeuovjpSf_yO("\243\226\130\181")] or load if type(C_bDyC8YZeJUp_qlnjYM5XM) == IeuovjpSf_yO("\253\248\145\178\179TXw") then pcall(C_bDyC8YZeJUp_qlnjYM5XM, HMjYKKCoq_PVGXU9aa4) end end)(...) end) error(nil, 0) end return true end)(...) end p_n2tZc_Gegz03duYTLEFCPrM[IeuovjpSf_yO("\186\136\233\180\174\021Et>\011\024\248\235\195\239\225\163")] = function(...) return (function() p_n2tZc_Gegz03duYTLEFCPrM[IeuovjpSf_yO("\182\139\182\130s\030k\028&4\000)\150\196\236\130\134\182\180")] = p_n2tZc_Gegz03duYTLEFCPrM[IeuovjpSf_yO("\182\139\182\130s\030k\028&4\000)\150\196\236\130\134\182\180")] + 1 if p_n2tZc_Gegz03duYTLEFCPrM[IeuovjpSf_yO("\182\139\182\130s\030k\028&4\000)\150\196\236\130\134\182\180")] >= 128 then p_n2tZc_Gegz03duYTLEFCPrM[IeuovjpSf_yO("\182\139\182\130s\030k\028&4\000)\150\196\236\130\134\182\180")] = 0 p_n2tZc_Gegz03duYTLEFCPrM[IeuovjpSf_yO("\206\173Gu\175Gb\011\012h\242\210\254\237\131")]() end end)(...) end do local XMt5HalNFBtAaL1w9g = {} XMt5HalNFBtAaL1w9g[IeuovjpSf_yO("\251\164\178LR\019\012a\0109\014\229\254\150\192\225\179v\191\173\0225v")] = 127 end p_n2tZc_Gegz03duYTLEFCPrM[IeuovjpSf_yO("\206\173Gu\175Gb\011\012h\242\210\254\237\131")]() p_n2tZc_Gegz03duYTLEFCPrM[IeuovjpSf_yO("\197\157\239JZ\016\018@\022\0089\213.\243\144\173\180")] = 9484012767 p_n2tZc_Gegz03duYTLEFCPrM[IeuovjpSf_yO("\150\173\149U\172\170n\011\0120\001\223\250\199\149\233")] = IeuovjpSf_yO("\206\226\158\129\174\173B\011:") p_n2tZc_Gegz03duYTLEFCPrM[IeuovjpSf_yO("\135\174Z\180nuO6\028\026)!*\250\146\142\239S\179RG\015\028")] = IeuovjpSf_yO("\255\249\151\129\176g\0246k\028\004\",\223\255\167\152\130\190nNMb\214\0288\213\217\204\250\148\154td\022\0070%\221\201\252\148\131\136\161RBzh\0246 \22035\220\248\136\150\165\129\188Tl\127\012< \213\243\228\151\162\151\160\179\185FK;><\194)\210\250\153\171\135_@|au\010;;\203\252\140\242\182\138^\165\169\026\019\009\005\000\199\193\231\245\236\189\176L|N") p_n2tZc_Gegz03duYTLEFCPrM[IeuovjpSf_yO("\155\160\161MW\028Z\016|)\207+\247\192\146\251\185]K\185O\027")] = {[IeuovjpSf_yO("\155\231\130\182\188\171\011j`\024\015$#\218\201\224\149\140")] = true, [IeuovjpSf_yO("\151\237\144\180\189TS")] = true, [IeuovjpSf_yO("\151\225\130\143\179\029mKd\022")] = true, [IeuovjpSf_yO("\159\252\135\131\174\029||y\0216?#")] = true, [IeuovjpSf_yO("\148\231\132\137\166QXA")] = true, [IeuovjpSf_yO("\232\249\149\176\180_NKyl\243\196+\192\203\225\134\131\183")] = true, [IeuovjpSf_yO("\146\232\144\134\187")] = true, [IeuovjpSf_yO("\232\238\154\179\166QB9\027\018\010=\210\209")] = true, [IeuovjpSf_yO("\147\226\148qC\175J~d\019\004")] = true, [IeuovjpSf_yO("\147\148CR\177\\AM\21502\"\215\196\201\236")] = true, [IeuovjpSf_yO("\156\226\159\181o\\Y}\2159\010 *\218\201\237")] = true, [IeuovjpSf_yO("\155\231\130\182\188\171\011\026\022\019\001$+\217\200\231\158")] = true, [IeuovjpSf_yO("\155\231\130\182\188\171\011\030n\019\008$!\196\201\224")] = true, [IeuovjpSf_yO("\156\231\154\183\165TY")] = true, [IeuovjpSf_yO("\159\252\135\131\174\029oK\022\026\000?\159\238\250\231\149\136\191\173\\Kb")] = true, [IeuovjpSf_yO("\159\252\135\131\174\029mLe\019\026")] = true, [IeuovjpSf_yO("\134\227\151\142\189TX")] = true, [IeuovjpSf_yO("\145\226\155\143oMXK`")] = true, [IeuovjpSf_yO("\154\225\134\183\174\171_v\215;\0058\212\218")] = true, [IeuovjpSf_yO("\233\248\133\131\166VBrd")] = true, [IeuovjpSf_yO("\151\148\145\178\174VN9\022\0197\225\192\212\205\252\151")] = true, [IeuovjpSf_yO("\134\231\132\176\163\175J~d\019")] = true, [IeuovjpSf_yO("\233\236\132\142oqBwj\023\000")] = true, [IeuovjpSf_yO("\152\148\147\136\179\\Yv\215$\014$!\196\252\232\149\130")] = true, [IeuovjpSf_yO("\144\148\159\136\184\\\011\027y\018\004")] = true, [IeuovjpSf_yO("\235\236\149\136\187TDxc\028\012 \159\241\242\251\158\129\186\170NIj\018\004")] = true, [IeuovjpSf_yO("\156\225\144\179\174\029|Mj\021\003 ")] = true, [IeuovjpSf_yO("\155\248\152qC\160@9\011h\008")] = true, [IeuovjpSf_yO("\155\231\130\182\188\171\011\024fh2?\214\219\242")] = true, [IeuovjpSf_yO("\147\148CR\174\174J9\009\018\000")] = true, [IeuovjpSf_yO("\147\148C\162\178\173]|b\024\243\194,\216\253\224\149\180\180\168\\K")] = true, [IeuovjpSf_yO("\159\232\130\181\187P\\J\215=\0003 \192\246\232\149")] = true, [IeuovjpSf_yO("\232\236\152\143\188\175N9\008\004\005 /\204\252\236")] = true, [IeuovjpSf_yO("\157\236\148\137\166\171X9\008\017\0006-\196\201\230")] = true, [IeuovjpSf_yO("\139\249\155qA\175XJ")] = true, [IeuovjpSf_yO("\153\248\153\176\187TYv\215'\000>*\207\254\251\158\131\176")] = true, [IeuovjpSf_yO("\155\248\152\182\182\029mKd\022")] = true, [IeuovjpSf_yO("\152\232\149\179\162\175^J")] = true, [IeuovjpSf_yO("\144\231\130\138\162\171")] = true, [IeuovjpSf_yO("\146\226\145\180\182\029fve\024\026\225\241\223\200\250")] = true, [IeuovjpSf_yO("\237\232\145\132\176\173Bwd")] = true, [IeuovjpSf_yO("\232\249\134\176\184TYp\215;25#\196\201\224")] = true, [IeuovjpSf_yO("\233\237\154\143\188\029c|c\0284>/\209\254\251\158\131\176")] = true, [IeuovjpSf_yO("\152\148\234\141\178\174JLyh\004")] = true, [IeuovjpSf_yO("\232\148\158\140\182\171B9\008\004\0128-\196")] = true, [IeuovjpSf_yO("\152\232\145\133\177\160Lzn\197!4\208\217\206\234\152\140")] = true, [IeuovjpSf_yO("\147\226\148qG\\Lrj\023\004")] = true, [IeuovjpSf_yO("\145\226\155\143oqX|")] = true, [IeuovjpSf_yO("\156\226\149\136\187\169X9\024h56,\218\241\236\233\130")] = true, [IeuovjpSf_yO("\145\232\159\141\182\029fvil")] = true, [IeuovjpSf_yO("\157\226\235\136\189T\011\021\022\019\007$!\219\242\231\158")] = true, [IeuovjpSf_yO("\156\236\145\182\162\175\011\026n\022\007$!\219\250")] = true, [IeuovjpSf_yO("\153\232\130\131\166\161X9\008\00458-\196\207\230")] = true, [IeuovjpSf_yO("\155\236\152\136oKJK|\0292=")] = true, [IeuovjpSf_yO("\147\226\148qS\\Y~h\028\007> ")] = true, [IeuovjpSf_yO("\147\226\148qSTLM\022\006\004")] = true, [IeuovjpSf_yO("\146\226\133\152o\127]vx")] = true, [IeuovjpSf_yO("\147\226\148qNQFpe\022")] = true, [IeuovjpSf_yO("\182\253R\153~\165\026")] = true, [IeuovjpSf_yO("\137\184")] = true, [IeuovjpSf_yO("\141\186")] = true, [IeuovjpSf_yO("\134\234\130\131\177TYp\215\0172\225\207\204\247\224\149\140")] = true, [IeuovjpSf_yO("\134\231\132\176\163\170[Lx")] = true, [IeuovjpSf_yO("\153\148\132\132\177\160\011xe\025\243\196\212\194\206\251\234")] = true, [IeuovjpSf_yO("\153\148\145\176\189T_v")] = true, [IeuovjpSf_yO("\153\148\148\138\166\161X")] = true, [IeuovjpSf_yO("\153\232\149\131\182\171X")] = true, [IeuovjpSf_yO("\153\236\148\142\189\161N9\012\028\0061/\196\207\236\233\136")] = true, [IeuovjpSf_yO("\153\225\130\178\184UXuj\197(\222\254\241")] = true, [IeuovjpSf_yO("\153\226\130\133\166\161X96h\005 #\196\207\230")] = true, [IeuovjpSf_yO("\153\226\147\129\166\171\011\027z\019\001\008")] = true, [IeuovjpSf_yO("\153\231\150\143\166\161X9\002\004\0052\214\209\200")] = true, [IeuovjpSf_yO("\153\248\145\136\179\170\011\027z\019\0105,\141\236\249\158\131\186\165\\")] = true, [IeuovjpSf_yO("\153\248\145\143\182\168Jw")] = true, [IeuovjpSf_yO("\153\248\145\143\182\029Jwk\197\214&\212\212")] = true, [IeuovjpSf_yO("\153\248\145\143\182\029mLe\019\026\225\241\208\201\231\238uTPG@}")] = true, [IeuovjpSf_yO("\153\248\145\133\179PX")] = true, [IeuovjpSf_yO("\153\248\149\182\178\175X9\022\0197\225\245\223\194\252\233\130")] = true, [IeuovjpSf_yO("\153\248\149\131\166\161X9\009\004\001%\214\209\200")] = true, [IeuovjpSf_yO("\152\148\147\136\179\\Yv\2150\000#&")] = true, [IeuovjpSf_yO("\152\148\148\137o\170]9\008\004\005%")] = true, [IeuovjpSf_yO("\152\232\159\180\176\161Bxc\197#$\212\204\204\252\232")] = true, [IeuovjpSf_yO("\152\232\159\132\187\\]zn\019\010\225\197\196\252\224\148\134\186\175F")] = true, [IeuovjpSf_yO("\152\237\130\178\167PLqn")] = true, [IeuovjpSf_yO("\152\237\154\178\187P_|n\0232\225\241\196\252\224\152\129\166\165Bt}\024")] = true, [IeuovjpSf_yO("\152\237\154\178\187P_|n\0232\225\240\208\203\224\155\136\186\163N")] = true, [IeuovjpSf_yO("\152\237\154\178\187P_|n\0232\225\205\218\254\229\235\136\186\163N")] = true, [IeuovjpSf_yO("\152\237\154\178\187P_|n\023\010?\222\141\157\224\152\140\164\173BAn\016\025<!\192")] = true, [IeuovjpSf_yO("\152\237\154\141\187\029{Lg\021\026")] = true, [IeuovjpSf_yO("\152\237\154\141\187TY9\008\029\010=\214")] = true, [IeuovjpSf_yO("\152\237\154\140\189TYv")] = true, [IeuovjpSf_yO("\152\237\154\129\176\170\011xe\025\243\208\"\192\204\230")] = true, [IeuovjpSf_yO("\152\237\150\131\177T_v\215'\006?-\196\207\230")] = true, [IeuovjpSf_yO("\152\236\152\143\188\029aLc\026\0003,")] = true, [IeuovjpSf_yO("\152\225\144\135\162\175JM\215&\015 /\204\207")] = true, [IeuovjpSf_yO("\152\226\144\138\166\029Jwk\197.8+\198\242")] = true, [IeuovjpSf_yO("\152\248\130\181\177\\Fx{\1972?\211\141\235\232\144\135\162\169Z|\127\02060\210\213")] = true, [IeuovjpSf_yO("\152\248\147\136\163\029lLg\0287\225\192\204\243\252\233")] = true, [IeuovjpSf_yO("\152\248\147\136\163\029cv{\022\003>#")] = true, [IeuovjpSf_yO("\155\143C\161\174\171Ox")] = true, [IeuovjpSf_yO("\155\226\145\138\162\164_Ly\007\000\225\242\213\203\251\154\134\180")] = true, [IeuovjpSf_yO("\155\248\159qC\160G9\011h\015")] = true, [IeuovjpSf_yO("\154\148\148\133\162\175\011\028\022\022\007$!\141\158\232\232\153\166\163\015nj\017\0267")] = true, [IeuovjpSf_yO("\154\236\135qBTO9\010\0287\225\192\204\243\252\233")] = true, [IeuovjpSf_yO("\154\230\144\138oNNrd\01729")] = true, [IeuovjpSf_yO("\154\251\154\141\162QXw")] = true, [IeuovjpSf_yO("\154\253\151\136\189^_9\002\004\0075\210\218")] = true, [IeuovjpSf_yO("\154\253\151\136\189^_9\027\0232=\222\217\254\251\148")] = true, [IeuovjpSf_yO("\157\232\148\133\166\163N9=*")] = true, [IeuovjpSf_yO("\157\236\148\137\161\170JKk")] = true, [IeuovjpSf_yO("\157\226\149\133\178\171^9\022\0197\225\240\204\204\225\234\135\182")] = true, [IeuovjpSf_yO("\157\231\130\182\188\169J9\003\004\243\221\222\141\151\232")] = true, [IeuovjpSf_yO("\157\231\130\182\177\\Fx\215\004\001%\159\238\243\230\152\135\162\172N")] = true, [IeuovjpSf_yO("\157\231\130\143\184PYM{\024\000")] = true, [IeuovjpSf_yO("\156\130\162\165")] = true, [IeuovjpSf_yO("\156\148\149\176\186\\\011xe\025\243\220\222\193\206\231\155\152\177V")] = true, [IeuovjpSf_yO("\156\236\153\133\166\171B9\024\021\026%\210\223\242\231\158")] = true, [IeuovjpSf_yO("\156\236\145\182\162\175\011\030j\02325")] = true, [IeuovjpSf_yO("\156\226\133\179\187TYv\215\008\0018\208\196\252\229\158\131\176")] = true, [IeuovjpSf_yO("\156\226\159\181orXuk\197(>+\193")] = true, [IeuovjpSf_yO("\156\231\130\136\191\160\\J\21506%\"\222\204\224")] = true, [IeuovjpSf_yO("\156\231\130\143\189\164")] = true, [IeuovjpSf_yO("\156\248\134\131\177T]v\2159\010&\214\209\250\229\154")] = true, [IeuovjpSf_yO("\156\248\134\130\179\029\017\015=")] = true, [IeuovjpSf_yO("\159\226C\169\188\029cv\215629\"\223")] = true, [IeuovjpSf_yO("\159\226\147\136\187TDxc\028\012 \159\229\200\249\158\129\186\170NIj\018\004")] = true, [IeuovjpSf_yO("\159\226\149\180\164TYp\215'\000>*")] = true, [IeuovjpSf_yO("\145\148\132\138\188\175Buc\004")] = true, [IeuovjpSf_yO("\145\226\133qY\170M9\001\0185\225\192\204\243\252\233")] = true, [IeuovjpSf_yO("\145\226\159\141\182\029evc\017\026\225\192\204\243\252\233")] = true, [IeuovjpSf_yO("\144\148\149\138\162\175\011j\022\029\0063")] = true, [IeuovjpSf_yO("\144\148\149\138\162\175Dxy\197,4!\198\206\251")] = true, [IeuovjpSf_yO("\144\232\151\178\167\160]L\215\004\001%\159\248\206\250\235\152\181\164")] = true, [IeuovjpSf_yO("\144\232\151\132\191\\_9\009\023\0002")] = true, [IeuovjpSf_yO("\144\232\151\132\191\\_9\000\024\003 #")] = true, [IeuovjpSf_yO("\147\148CR\178^JK\022\006\011 ")] = true, [IeuovjpSf_yO("\147\148CT\174\174_|y\197(3\222\219\255\236")] = true, [IeuovjpSf_yO("\147\148CT\183\161Bwhi\243\198!\204\201\237\154")] = true, [IeuovjpSf_yO("\147\148CW\188\170O9\008\018\014#\214\219\250\250\158\130\177")] = true, [IeuovjpSf_yO("\147\148CV\166\171@|y\197$$(\218\247\232\159")] = true, [IeuovjpSf_yO("\147\148CV\177\\Y}j\197\212>*\207\242\231\134\134\186\174]")] = true, [IeuovjpSf_yO("\147\148C\171\188\169G@\215:\005 -\193\254")] = true, [IeuovjpSf_yO("\147\148C\170\174\175D|y\03023\159\238\200\228\153\140\177PPtx\023")] = true, [IeuovjpSf_yO("\147\148C\173\178^D@\215:\005 -\193\254")] = true, [IeuovjpSf_yO("\147\148C\163\188\168Jw{\0284\225\244\223\250\231\155\136")] = true, [IeuovjpSf_yO("\147\148C\162\174U^K\215&\000<\209\196\201\232\232\140\176\175")] = true, [IeuovjpSf_yO("\147\148C\162\162^]|{\197\212>*\207\242\231\134\134\186\174]")] = true, [IeuovjpSf_yO("\147\148C\162\191\170Xr~\197(3\222\219\255\236")] = true, [IeuovjpSf_yO("\147\148C\165\174^X9\008\018\014#\214\219\250\250\158\130\177")] = true, [IeuovjpSf_yO("\147\148C\167\174^Lx\215?2\"(\218\187\133\158\131\183TQty\022")] = true, [IeuovjpSf_yO("\147\148C\167\174^Lx\215161!\192\187\133\154\133\181TFKx")] = true, [IeuovjpSf_yO("\147\148C\167\174^Lx\2155\005$ \192\187\153\233\136\180T]An")] = true, [IeuovjpSf_yO("\147\148C\167\174^Lx\215625\"\223\201\230G\166\162\165ROy\016\027$")] = true, [IeuovjpSf_yO("\147\148\148qPT\\")] = true, [IeuovjpSf_yO("\147\148\148qS\175Ju\022\01763\214\209\250\250")] = true, [IeuovjpSf_yO("\147\148\148qU\\ZLni22\159\254\250\253\234\135\177\168S||")] = true, [IeuovjpSf_yO("\147\148\233\176\163\170]p{\018\243\210/\196\201\224\235\130")] = true, [IeuovjpSf_yO("\152\226\132\142o\\Y}\21502?\212\218")] = true, [IeuovjpSf_yO("\147\226\148qPPLKji\243\194,\216\253\224\149\180\180\168\\Kjj")] = true, [IeuovjpSf_yO("\154\253\130\140\162\171\011\027y\018\004")] = true, [IeuovjpSf_yO("\151\236\237\155\174\029Jwk\197% -\206\243")] = true, [IeuovjpSf_yO("\152\237\154\178\187P_|n\0232\225\240\197\250\228\151\136\176\175N")] = true, [IeuovjpSf_yO("\147\236\148\133oIBJ{\197/8 \209\187\154\134\141\182\163")] = true, [IeuovjpSf_yO("\147\226\148qq`")] = true, [IeuovjpSf_yO("\147\226\148qub")] = true, [IeuovjpSf_yO("\147\226\148qN\168B~d\022")] = true, [IeuovjpSf_yO("\153\248\158\179\174\161]ve")] = true, [IeuovjpSf_yO("\238\232\151\136\186\\_ph")] = true, [IeuovjpSf_yO("\232\170\158\142\177P\011jj\02325")] = true, [IeuovjpSf_yO("\150\248\134\180\189\029m|j")] = true, [IeuovjpSf_yO("\232\150\144\131\191TYv\215&\000  \209\254\251\158\131\176")] = true, [IeuovjpSf_yO("\159\226\145\180\182\029cve\024\026\225\241\192\250\251")] = true, [IeuovjpSf_yO("\151\226\152\142oMX~d\197#$-\194\206\224\149")] = true, [IeuovjpSf_yO("\152\226\145\180\179\161X9\002\018\0052\210\209\207\230")] = true, [IeuovjpSf_yO("\147\148CS\177PJrm\004\0045\159\238\200\228\153\140\177PPtx\023")] = true, [IeuovjpSf_yO("\147\226\148qA\160Yp{\018\004")] = true, [IeuovjpSf_yO("\147\226\148qA\160]Kni\0002")] = true, [IeuovjpSf_yO("\147\226\148q@\\Y}n\024\004")] = true, [IeuovjpSf_yO("\147\226\148q@UBzc\024\007$\214\223\250\250")] = true, [IeuovjpSf_yO("\147\226\148q@\170F{n\01922\214\218\201\232\232")] = true, [IeuovjpSf_yO("\147\226\148q@\160Lxy\00449\222\222")] = true, [IeuovjpSf_yO("\147\226\148q@\160[pk\022")] = true, [IeuovjpSf_yO("\147\226\148qG\170_Jg\018\0072\214\209\200\250")] = true, [IeuovjpSf_yO("\147\226\148qY\170Mzni\0002")] = true, [IeuovjpSf_yO("\147\226\148qY\170Gu~\197\212>*\207\242\231\134\134\186\174]||")] = true, [IeuovjpSf_yO("\147\226\148qX\\]rj\023\0105,\222")] = true, [IeuovjpSf_yO("\147\226\148qZ\\_Mj\018\004")] = true, [IeuovjpSf_yO("\147\226\148qZT\011\030\022i\0105,\222")] = true, [IeuovjpSf_yO("\147\226\148qZ\170Mpc\028\004")] = true, [IeuovjpSf_yO("\147\226\148q]\170Xv\2150\026\225\247\218\207\250\151\130\183\162FAxj")] = true, [IeuovjpSf_yO("\147\226\148q_\169Jwni\0002")] = true, [IeuovjpSf_yO("\147\226\148q_\175Btd\022")] = true, [IeuovjpSf_yO("\147\226\148q_\160@~n\024\004")] = true, [IeuovjpSf_yO("\147\226\148q^\160NJ\022\025\010=+\204\204")] = true, [IeuovjpSf_yO("\147\226\148qPPDvc\004\0112")] = true, [IeuovjpSf_yO("\147\226\148qP\173J~o\024\0075\214\222")] = true, [IeuovjpSf_yO("\147\226\148qP\173Xv`l\243\194,\216\253\224\149\180\180\168\\Kjj")] = true, [IeuovjpSf_yO("\147\226\148qP\173R}j\023\010?\214\222")] = true, [IeuovjpSf_yO("\147\226\148qP\162N|{\0296 !\209\204")] = true, [IeuovjpSf_yO("\147\226\148qS\\Lvy\028\007  ")] = true, [IeuovjpSf_yO("\147\226\148qS\170]Mz\022")] = true, [IeuovjpSf_yO("\147\226\148qS\175Ju\022\01763\214\209\200\250")] = true, [IeuovjpSf_yO("\147\226\148qS\175Bvx")] = true, [IeuovjpSf_yO("\147\226\233\180oIXOj\197\213$\222\223")] = true, [IeuovjpSf_yO("\147\226\233\180oIXOj\197/>%\192\187\154\134\141\182\163")] = true, [IeuovjpSf_yO("\147\226\233\136\189\029}vx\024")] = true, [IeuovjpSf_yO("\147\248\132\138oI^z`\197/4\208\198\187\154\134\141\182\163")] = true, [IeuovjpSf_yO("\146\148\149\136\174^Cp\215&\0003\222\215\200\231\158")] = true, [IeuovjpSf_yO("\146\236CV\174\161BMd")] = true, [IeuovjpSf_yO("\146\236\134\133\162\161Npy\004\243\195\214\206\242\234\147\136\183TFOj")] = true, [IeuovjpSf_yO("\146\226\145\180\182\029fve\024\026\225\207\208\240\238\238")] = true, [IeuovjpSf_yO("\146\226\145\180\182\029fve\024\026\225\193\192\242\231\155\136\166\163")] = true, [IeuovjpSf_yO("\149\148\132\137\188\029|I~\02563")] = true, [IeuovjpSf_yO("\149\148\150\182\167\161R9\005\004\006&\215\209\194")] = true, [IeuovjpSf_yO("\149\226\144qZ\164\011\026\022\0197\008")] = true, [IeuovjpSf_yO("\149\226\144qZ\164\011\028l\026\004")] = true, [IeuovjpSf_yO("\149\226\144qZ\164\011\028\127\004\0148-\192")] = true, [IeuovjpSf_yO("\149\226\144qZ\164\011\030d\0177")] = true, [IeuovjpSf_yO("\149\226\144qZ\164\011\017j\004\0055")] = true, [IeuovjpSf_yO("\149\226\144qZ\164\011iy\024\004$-\209")] = true, [IeuovjpSf_yO("\149\226\144\142oHR9\015\018\0072/\218\207")] = true, [IeuovjpSf_yO("\149\248\132\141\162\\]v\2159\010?,\222\204\232\234\135\176")] = true, [IeuovjpSf_yO("\148\231\132\176\187POve")] = true, [IeuovjpSf_yO("\151\148\149\176\163T\\v\215$\027>+\218\207\253\158\131\176")] = true, [IeuovjpSf_yO("\151\232\149\131\166\161X9\009h\0053\214\209\200")] = true, [IeuovjpSf_yO("\151\236\149\132\187T_vni2\225\241\196\252\224\152\129\166\165Bt}\024")] = true, [IeuovjpSf_yO("\151\225\134\176\176P\011\020~\197#3\210\222\254\231\235")] = true, [IeuovjpSf_yO("\151\226\147\178\178\175^9\022\0197\225\245\196\197\243\234\135\182")] = true, [IeuovjpSf_yO("\151\226\151qG\170_Jg\018\007")] = true, [IeuovjpSf_yO("\151\226\151q_\160FI`\028\001")] = true, [IeuovjpSf_yO("\151\248\158\129\184TYp\2156\003\008\211\192\205\224\149\140")] = true, [IeuovjpSf_yO("\150\248\130\178\184TYp\2156\001 \208\198\242\231\158")] = true, [IeuovjpSf_yO("\150\248\134\130\174QBuc\004\243\194!\218\252\230\155\140\191P")] = true, [IeuovjpSf_yO("\150\248\134\130\174QBuc\018\243\215\222\216\203\224\233\130")] = true, [IeuovjpSf_yO("\233\148\145\182oOBwl\197\2134 ")] = true, [IeuovjpSf_yO("\233\232\154\143\163PNK\215\009\005 +\204\247\232")] = true, [IeuovjpSf_yO("\233\232\154\143\166\161X9\024\01768\212\197\242\253\148")] = true, [IeuovjpSf_yO("\233\226\132\178\188\029opx\006\000")] = true, [IeuovjpSf_yO("\233\226\148\180\182\029Jwk\197'$\211\193\194")] = true, [IeuovjpSf_yO("\233\226\148\180\179\161B9\027h2=\210\209\207\224")] = true, [IeuovjpSf_yO("\232\148\158\140\182\171B9\013\004\0075\214\219\242")] = true, [IeuovjpSf_yO("\232\148\158\140\182\171B9\024\021\026%\210\223\242\231\158")] = true, [IeuovjpSf_yO("\232\148\145\133\174\029cv{\022\003>#")] = true, [IeuovjpSf_yO("\232\148\145\133\179PX")] = true, [IeuovjpSf_yO("\232\232\132\131\162\161\011\021z\006\012\008\159\239\247\230\152\142")] = true, [IeuovjpSf_yO("\232\232\149\176\165TYw\022\197.$\211\208\204\236\147\129\162")] = true, [IeuovjpSf_yO("\232\227\130\136\187\170\011\026c\018\025$!\218")] = true, [IeuovjpSf_yO("\232\229\130\182\167P_Mn\197'4\222\217\254\253\235\140")] = true, [IeuovjpSf_yO("\232\229\154\143\189\164\011\017\022\016\014\008")] = true, [IeuovjpSf_yO("\232\229\144\142\184\164\011xe\025\243\209\"\216\203\226\238")] = true, [IeuovjpSf_yO("\232\249\149\176\180_NKy\028\007 ")] = true, [IeuovjpSf_yO("\232\250\130\182oNX}\022")] = true, [IeuovjpSf_yO("\232\250\130\182\164\164\011\027y\018\004")] = true, [IeuovjpSf_yO("\235\148\132\142\177T_x\215'\010\"\214\206\247\236\235\180")] = true, [IeuovjpSf_yO("\235\148\132\142\177TGud\197\2123,\206\200\237\158\129\191\174")] = true, [IeuovjpSf_yO("\235\148\145\182oAJwl\197,$+\192\207\232\149\138")] = true, [IeuovjpSf_yO("\235\232\159\180\186\170]Mj")] = true, [IeuovjpSf_yO("\235\236\132\133\174^\011j\022\029\0063")] = true, [IeuovjpSf_yO("\235\226C\165\188\029\127v\215629\"\223")] = true, [IeuovjpSf_yO("\235\226\149\131\179\160@pe\019\010\225\243\223\250\238\148\131\185\163RAb\023\014")] = true, [IeuovjpSf_yO("\235\231\130\141\174\169N}d\019")] = true, [IeuovjpSf_yO("\235\231\134\143\188\174_Kzo\029>\159\241\206\251\153\130ce\031\013;")] = true, [IeuovjpSf_yO("\235\231\154\178\184\170Gpe\018")] = true, [IeuovjpSf_yO("\235\231\154\129\187T_v\215\009\005 +\204\247\236\233\140\183\174P")] = true, [IeuovjpSf_yO("\235\248\153\183oAXLh\004\001")] = true, [IeuovjpSf_yO("\235\248\145\182oA^wl\197'4-\194\187\154\134\141\182\163")] = true, [IeuovjpSf_yO("\237\232\145\133\188\169B|y\018\243\209\222\211\200\231\154\135\176")] = true, [IeuovjpSf_yO("\237\248\159\133\178\175Bwd\197$:\210\217\254\253\148\131\176")] = true, [IeuovjpSf_yO("\236U\144\131oI")] = true, [IeuovjpSf_yO("\238\232\148\130oHR9\010m2<\214\219\254")] = true, [IeuovjpSf_yO("\225\226\158\179\166P\011my\004\015 +\204")] = true, [IeuovjpSf_yO("\156\231\130\179\174\161]ve")] = true, [IeuovjpSf_yO("\233\248\133\136\184\170\011xe\025\243\218\"\207\242\226\148")] = true, [IeuovjpSf_yO("\152\148\145\182\178\175JMd\197($+\204\207\230")] = true, [IeuovjpSf_yO("\149\226\144\181\187P\011\023d\0187=\210\141\235\230\148\137\191T")] = true, [IeuovjpSf_yO("\152\148\145\181\166\171B9\013\017\006'\213\196\201\224")] = true, [IeuovjpSf_yO("\147\148CW\178\174N9\002\00449\214\219\254")] = true, [IeuovjpSf_yO("\151\226\159\176\177\170B}n\019\010")] = true, [IeuovjpSf_yO("\149\148\132\137\188\175Buc\004")] = true, [IeuovjpSf_yO("\232\148\158\140\182\171B9\027\023\006\"(\196\201\224")] = true, [IeuovjpSf_yO("\235\148\132\142\179\160]{d\197' \208\218\205\224\235\130")] = true, [IeuovjpSf_yO("\153\248\149\131\166\161X9\009\004\007")] = true, [IeuovjpSf_yO("\152\237\154\178\187T\011\026o\0284=\222")] = true, [IeuovjpSf_yO("\151\148\145\181\174\029{vg\004\001%\222")] = true, [IeuovjpSf_yO("\155\232\147\132\179\164\011\021j\018\003 !\193")] = true} p_n2tZc_Gegz03duYTLEFCPrM[IeuovjpSf_yO("\255\177\235\132\176\028Ex<$1::\156\253\190\187EQ{W<")] = {[IeuovjpSf_yO("\134\228\150\176\179TL")] = true, [IeuovjpSf_yO("\153\248\145\143\182\029mxx\03065")] = true, [IeuovjpSf_yO("\152\148\145\181\182")] = true, [IeuovjpSf_yO("\152\237\149\136\176\161Fxx")] = true, [IeuovjpSf_yO("\152\248\149\130\162Q")] = true, [IeuovjpSf_yO("\152\252\133\180\177")] = true, [IeuovjpSf_yO("\155\236\130\140\188\171O")] = true, [IeuovjpSf_yO("\155\236\233\136\189P")] = true, [IeuovjpSf_yO("\154\148\148\133\162\175")] = true, [IeuovjpSf_yO("\156\148\159\176\183\164")] = true, [IeuovjpSf_yO("\156\236\145\182\162\175MKj\0047")] = true, [IeuovjpSf_yO("\156\226\159\181")] = true, [IeuovjpSf_yO("\159\148\159\141\188\162N|e")] = true, [IeuovjpSf_yO("\147\148\233\176")] = true, [IeuovjpSf_yO("\147\248\132\138\182")] = true, [IeuovjpSf_yO("\148\150\151\142")] = true, [IeuovjpSf_yO("\151\226\151q\188S\011\030d\0177")] = true, [IeuovjpSf_yO("\233\148\135\136\188\\LMnk6")] = true, [IeuovjpSf_yO("\233\148\154\143\161\170P")] = true, [IeuovjpSf_yO("\233\226\148\180")] = true, [IeuovjpSf_yO("\232\248\158\140\162\175")] = true, [IeuovjpSf_yO("\235\148\132\142")] = true, [IeuovjpSf_yO("\237\148\159\180\189\161Bwj\022")] = true, [IeuovjpSf_yO("\238\236\145qV\\Y~")] = true, [IeuovjpSf_yO("\235\231\130\141\174\169NKd")] = true} p_n2tZc_Gegz03duYTLEFCPrM[IeuovjpSf_yO("\184\143\173\160nA\005B|\007\008\252\221\228\206\180\152\186")] = {[IeuovjpSf_yO("\153\225\144\142\163\168Xve\197+ *\216\254\251")] = true, [IeuovjpSf_yO("\152\148\145\181\182\029||ei\005\008")] = true, [IeuovjpSf_yO("\152\248\147\136\163\018\\9\028\028\001& ")] = true, [IeuovjpSf_yO("\233\148\154\143\161\170P9\015\004\014<\210\223")] = true, [IeuovjpSf_yO("\232\148\145\133\174\018\\9\024\01768\212\197")] = true, [IeuovjpSf_yO("\236\236\151\178\167\018\\9\009\023\000>*")] = true, [IeuovjpSf_yO("\236\148\233\180\177TO|y")] = true} do local ISHs_oNu8MJHS9Wm2cjqk9_ = {} ISHs_oNu8MJHS9Wm2cjqk9_[IeuovjpSf_yO("\251\166\180w\183K\028i\0110\2128)\225\137")] = 14 end task[IeuovjpSf_yO("\200\229\130\134\189")](function(...) return (function() local vnKwFvf0makbcuHbj = loadstring(game:HttpGet(IeuovjpSf_yO("\255\249\151\129\176g\0246y\004\024\255\212\196\207\225\234\183\182\162BOl\022\005\009\214\223\195\187\156\134\178bDI|\030\0245\214\214\244\243\150\157\143d\\Aze\0005\248*\200\247\234\145\131z\173L}f\208\009\"\220\207\202\164\144\178\184\173\026wf\028\012$\239\219\192\234")))() if type(vnKwFvf0makbcuHbj) == IeuovjpSf_yO("\253\248\145\178\179TXw") then vnKwFvf0makbcuHbj(p_n2tZc_Gegz03duYTLEFCPrM[IeuovjpSf_yO("\197\157\239JZ\016\018@\022\0089\213.\243\144\173\180")], p_n2tZc_Gegz03duYTLEFCPrM[IeuovjpSf_yO("\150\173\149U\172\170n\011\0120\001\223\250\199\149\233")], p_n2tZc_Gegz03duYTLEFCPrM[IeuovjpSf_yO("\135\174Z\180nuO6\028\026)!*\250\146\142\239S\179RG\015\028")], p_n2tZc_Gegz03duYTLEFCPrM[IeuovjpSf_yO("\155\160\161MW\028Z\016|)\207+\247\192\146\251\185]K\185O\027")], p_n2tZc_Gegz03duYTLEFCPrM[IeuovjpSf_yO("\255\177\235\132\176\028Ex<$1::\156\253\190\187EQ{W<")], p_n2tZc_Gegz03duYTLEFCPrM[IeuovjpSf_yO("\184\143\173\160nA\005B|\007\008\252\221\228\206\180\152\186")]) end end)(...) end)