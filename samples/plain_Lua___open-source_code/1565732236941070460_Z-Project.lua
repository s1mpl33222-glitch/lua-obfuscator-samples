local Players            = game:GetService("Players")
local RunService         = game:GetService("RunService")
local Workspace          = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService   = game:GetService("UserInputService")
local PathfindingService = game:GetService("PathfindingService")
local ReplicatedStorage  = game:GetService("ReplicatedStorage")
local TweenService       = game:GetService("TweenService")
local Camera             = workspace.CurrentCamera
local lp = Players.LocalPlayer
if not lp then
	repeat task.wait(0.5) until Players.LocalPlayer
	lp = Players.LocalPlayer
end
local character = lp.Character or lp.CharacterAdded:Wait()
local _humanoid  = character:WaitForChild("Humanoid")
local _rootPart  = character:WaitForChild("HumanoidRootPart")
local _cam = Workspace.CurrentCamera

if game.PlaceId ~= 93978595733734 then
    Players.LocalPlayer:Kick("[KKKK Hub] This map is not supported.")
    error("[KKKK Hub] This map is not supported.")
end

local state = {
	running = true,
	cfg = {
		spear_enabled        = false,
		spear_key            = Enum.KeyCode.E,
		spear_isHolding      = false,
        spear_targetPart = "Head",
        silentAim_enabled = false,
        silentAim_fov = 150,
        silentAim_showFOV = false,
        silentAim_survivor_enabled = false,
        silentAim_survivor_target = "Killer",
        silentAim_killerMode = "The Cure",
        silentAim_cure_enabled = false,
        veilSilentAim_enabled = false,
        veilTrajectory_enabled = true,
        veilTrajectoryColor   = Color3.fromRGB(0, 240, 255),
        veilSpearAlert        = true,
		p_enabled         = false,
		interactionRadius = 8,
		stunReach         = 7,
		cooldown          = 0.15,
		hz                = 240,
		p_dropKey         = 32,
		antiBait          = true,
        antiFallDamage_enabled = false,
		sc_enabled  = false,
        sc_lead     = 2,
        sc_key      = 32,
        sc_mode     = "Instant",
        sc_trap_offset     = 110,
        sc_trapgoal_offset = 110,
        sc_instant_offset  = 110,
        sc_offset          = 110,
        sc_speed_enabled = false,
        sc_speed_value   = 0.5,
        sc_pressKey = true,
		ap_enabled        = false,
		ap_cooldown       = 0.05,
		ap_showCircle     = true,
        ap_pendingColor  = Color3.fromRGB(255, 150, 0),
		ap_circleColor    = Color3.fromRGB(0, 255, 200),
		ap_animRadius     = 10,
		ap_animPreDelay   = 0,
		ap_pendingRadius  = 25,
		ap_hitboxRadius   = 16,
		ap_hitboxPreDelay = 0.0,
		ap_legitMode        = false,
		ap_legitMinDelay    = 0.01,
		ap_legitMaxDelay    = 0.10,
        ap_dirCheck_enabled = true,
        ap_facingAngle = 120,
		esp_enabled       = false,
		esp_showName      = true,
		esp_showDist      = true,
		esp_showHighlight = true,
		esp_showBox       = true,
		esp_maxDist       = 500,
		scp_esp_enabled      = false,
		scp_esp_showHighlight = true,
		scp_esp_showBox      = true,
		scp_esp_showName     = true,
		scp_esp_showDist     = true,
		scp_esp_maxDist      = 500,
		p_esp_enabled       = false,
		p_esp_showName      = true,
		p_esp_showDist      = true,
		p_esp_showHighlight = true,
		p_esp_showBox       = true,
		p_esp_showStatus    = false,
		p_esp_maxDist       = 500,
		godmode_enabled     = false,
		noFlashBlind        = false,
		breakSpeed_enabled  = false,
		breakSpeed_value    = 1,
		selectMask          = "Alex",
        swiftspeed_enabled = false,
        swiftspeed_value   = 1.5,
        autoCrouch_enabled   = false,
        autoCrouch_delay     = 0.0,
        autoCrouch_humanize  = false,
        autoCrouch_distance  = 15,
        autoCrouch_duration  = 1.5,
		autoPumpkin_enabled  = false,
		autoPumpkin_delay    = 0.3,
		tof_enabled = false,
		tof_target = "Killer",
		tof_maxDist = 50,
		flashlightAim_maxDist = 30,
		autoHeal_enabled = false,
        meEsp_enabled = false,
        fastVault_enabled    = false,
        flowstate_enabled    = false,
        flowstate_cooldown   = 15,
        speedMod_enabled      = false,
		speedMod_value        = 1.5,
		speedMod_countPerks   = true,
		speedMod_team         = "Both",
		speedMod_vaultSpeed   = 1.0,
        cameraFov_enabled     = false,
        cameraFov             = 70,
	},
	ui = {},
	render = {
    cachedSilentTarget   = nil,
    cachedCureTarget     = nil,
    cachedSurvivorTarget = nil,
    fovCircle   = nil,
    lockLine     = nil,
    lockLineCure = nil,
    lockLineSurv = nil,
    lines = {},
    meHighlight = nil,
    meAnimT = 0,
    scInstantConn = nil,
},
	
	killer2DEspElements = {},
	player2DEspElements = {},
	scpEspElements = {},
	genEspElements = {},
	bearTrapEspElements = {},
	pumpkinEspElements = {},
	vaultEspElements = {},
	palletEspElements = {},
	
	genEspEnabled = false,
	bearTrapEspEnabled = false,
	pumpkinEspEnabled = false,
	vaultEspEnabled = false,
	palletEspEnabled = false,
	
	pallets = {},
	killerRoots = {},
	_cachedPlayers = {},
	_playerCacheTime = 0,
	droppedPallets = {},
	lastDrop = {},
	lastTeamName = "",
	
	scLast = { l=nil, g=nil, win=nil },
	scHits = 0,
	scFired = false,
	_instantLoopRunning = false,
	
	pendingSwings = {},
	monitoredKillers = {},
	killerAnimConns = {},
	lastParryTime = 0,
	
	playerParryState = {},
	monitoredPlayerAnimators = {},
	
	_lastCrouchTime = 0,
	
	_skillCDCache = false,
	_skillCDLastCheck = 0,
	
	_fullbrightEnabled = false,
	_nofogEnabled = false,
	originalLighting = {},
	savedAtmosphere = {},
	savedColorCorrection = {},
	
	_genScanCache = nil,
	_genScanTime  = 0,
	_genCounter   = 0,
	_genPrevProgress = {},
	_genIsBreaking = {},
	
	_bearTrapScanTime = 0,
	
	_pumpkinScanTime = 0,
	
	_scpScanTime = 0,
	_scpTick = 0,
	
	_mapEspConns = {},
	
	flashlightAimEnabled = false,
	flashlightAimConn = nil,
	_flashlightNotified = false,
	
	_hopServerBusy = false,

	_fvPatches          = {},
	_fvController       = nil,
	_fsCD               = 0,
	_fsOverrideEnd      = 0,
	_fsCDLock           = 0,
	_fvAnimConn         = nil,
	
	autoBreakGenAura_enabled = false,
	autoBreakGenAura_radius = 20,
	
	moonwalkEnabled = false,
	moonwalkKey     = Enum.KeyCode.G,
	moonwalkAdT     = 0,
	moonwalkAdDir   = 1,
	
	pfRunning     = false,
	pfThread      = nil,
	pfToggleElem  = nil,
	pfToggleState = false,
	pfStuckGen    = 0,
	pfStuckSignal = false,
	
	_saFiring = false,
	_veilSAFiring = false,
	
	uiLabels = { status = nil, killerDist = nil, parryDaggerCD = nil },
	pStat = { elig=false, inZone=false, hp=true, nearD=nil, killD=nil, baiting=false },
	
	lblMapPrefix = nil,
	lblNamePrefix = nil,
	lblKillerPrefix = nil,
	lblKillerThe = nil,
	lblMapValue = nil,
	lblNameValue = nil,
	lblKillerValue = nil,
}

_G.KKKkhub = state

local AD_INTERVAL = 0.03
local PARRY_COOLDOWN = state.cfg.ap_cooldown
local PF_STUCK_TIMEOUT   = 2.0
local PF_STUCK_THRESHOLD = 0.5
local PF_ATTEMPT_ANGLES  = { 0, math.rad(45), math.rad(-45), math.rad(90), math.rad(-90) }
local SPEAR_SPEED_READY = 180
local SPEAR_SPEED_CD    = 170
local SPEAR_GRAV_READY = 98.1
local SPEAR_GRAV_CD    = 100.0
local AIM_HEIGHT_OFFSET = -0.5
local ABYSSWALKER_SKILL_ID = 100014992013740

local HIT_ANIM_IDS = {
	[127417297154354] = true,
	[83333467665074]  = true,
	[129626174716003] = true,
	[113691709436161] = true,
	[117042998468241] = true,
	[133963973694098] = true,
	[93902163029544]  = true,
	[75618342544502]  = true,
	[79310600168078]  = true,
	[104540716539347] = true,
	[74968262036854]  = true,
	[113255068724446] = true,
    [98163597193511] = true,
	[101636125032002] = true,
	[125430111937587] = true,
    [136820376940910] = true,
	[84926129581106]  = true,
	[81963230963908]  = true,
	[111920872708571] = true,
	[105374834496520] = true,
	[130593238885843] = true,
	[115244153053858] = true,
	[109402730355822] = true,
	[106871536134254] = true,
	[138720291317243] = true,
	[121216847022485] = true,
	[135002183282873] = true,
}

local ITEM_ICONS = {
    ["Adrenaline Shot"] = "rbxassetid://135388781922226",
    ["Bandage"]         = "rbxassetid://97791520639443",
    ["Flashlight"]      = "rbxassetid://103299939715311",
    ["Gate"]            = "rbxassetid://131249244284700",
    ["Holy Water"]      = "rbxassetid://86130208614143",
    ["Monkey Paw"]      = "rbxassetid://78636637697235",
    ["Motion Tracker"]  = "rbxassetid://92303584765773",
    ["Parrying Dagger"] = "rbxassetid://76822757630703",
    ["Riot Shield"]     = "rbxassetid://95718705901699",
    ["Shadow Clone"]    = "rbxassetid://134088840518889",
    ["Twist of Fate"]   = "rbxassetid://98397448432071",
    ["WaxBound Candle"] = "rbxassetid://110413686590821",
}

local killerTeamKeywords = { "Killer", "killer" }
local spectatorKeywords  = { "Spectator", "Spectator" }

local Lighting = game:GetService("Lighting")

local espGui = Instance.new("ScreenGui")
espGui.Name           = "KKKkhub_2DESP_ScreenGui"
espGui.ResetOnSpawn   = false
espGui.DisplayOrder   = 999
espGui.IgnoreGuiInset = true
espGui.Parent         = game:GetService("CoreGui")

local palletCountGui = Instance.new("ScreenGui")
palletCountGui.Name           = "KKKkhub_PalletCount"
palletCountGui.ResetOnSpawn   = false
palletCountGui.DisplayOrder   = 1001
palletCountGui.IgnoreGuiInset = true
palletCountGui.Parent         = game:GetService("CoreGui")

local palletCountFrame = Instance.new("Frame")
palletCountFrame.BackgroundColor3       = Color3.fromRGB(0, 0, 0)
palletCountFrame.BackgroundTransparency = 0.45
palletCountFrame.AutomaticSize          = Enum.AutomaticSize.X
palletCountFrame.Size                   = UDim2.new(0, 0, 0, 28)
palletCountFrame.AnchorPoint            = Vector2.new(0.5, 0)
palletCountFrame.Position               = UDim2.new(0.5, 0, 0, 10)
palletCountFrame.BorderSizePixel        = 0
palletCountFrame.Parent                 = palletCountGui
Instance.new("UICorner", palletCountFrame).CornerRadius = UDim.new(0, 8)

local palletCountScale = Instance.new("UIScale")
palletCountScale.Parent = palletCountFrame

local function updatePalletCountScale()
	local cam = Workspace.CurrentCamera
	if not cam then return end
	palletCountScale.Scale = math.clamp(cam.ViewportSize.X / 1280, 0.45, 1)
end
updatePalletCountScale()
Workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updatePalletCountScale)
Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
	local cam = Workspace.CurrentCamera
	if cam then
		updatePalletCountScale()
		cam:GetPropertyChangedSignal("ViewportSize"):Connect(updatePalletCountScale)
	end
end)

local uiList = Instance.new("UIListLayout")
uiList.Padding             = UDim.new(0, 15)
uiList.FillDirection       = Enum.FillDirection.Horizontal
uiList.VerticalAlignment   = Enum.VerticalAlignment.Center
uiList.HorizontalAlignment = Enum.HorizontalAlignment.Center
uiList.SortOrder           = Enum.SortOrder.LayoutOrder
uiList.Parent              = palletCountFrame

local function makeInfoLabel(layoutOrder)
    local lbl = Instance.new("TextLabel")
    lbl.BackgroundTransparency = 1
    lbl.Size                   = UDim2.new(0, 0, 1, 0) 
    lbl.AutomaticSize          = Enum.AutomaticSize.X -- ให้ความกว้างขยายตามตัวอักษร
    lbl.TextColor3             = Color3.fromRGB(255, 255, 255)
    lbl.TextStrokeTransparency = 0
    lbl.Font                   = Enum.Font.GothamBold
    lbl.TextSize               = 13
    lbl.TextXAlignment         = Enum.TextXAlignment.Left
    lbl.Text                   = ""
    lbl.LayoutOrder            = layoutOrder
    lbl.Parent                 = palletCountFrame
    return lbl
end

local palletCountLabel  = makeInfoLabel(1)
palletCountLabel.Text   = "Pallets: 0"

local infoMapLabel      = makeInfoLabel(2)
local infoKillerLabel   = makeInfoLabel(3)
local infoMorphLabel    = makeInfoLabel(4)

local uiPad = Instance.new("UIPadding")
uiPad.PaddingLeft  = UDim.new(0, 15)
uiPad.PaddingRight = UDim.new(0, 15)
uiPad.Parent       = palletCountFrame

local pfDotFolder = workspace:FindFirstChild("_PF_Dots") or Instance.new("Folder")
pfDotFolder.Name   = "_PF_Dots"
pfDotFolder.Parent = workspace

local function isSpectator()
	local team = lp.Team
	if not team then return false end
	local tn = string.lower(tostring(team.Name or ""))
	for _, kw in ipairs(spectatorKeywords) do
		if tn:find(string.lower(kw)) then return true end
	end
	return false
end

local function hasKillerTeamName(plr)
	local tn = plr.Team and string.lower(tostring(plr.Team.Name or "")) or ""
	for _, kw in ipairs(killerTeamKeywords) do
		if tn:find(string.lower(kw)) then return true end
	end
	return false
end

local function isSurvivor()
	if isSpectator() then return false end
	if hasKillerTeamName(lp) then return false end
	return true
end

local function isKillerPlayer(plr)
	if plr == lp then return false end
	if hasKillerTeamName(plr) then return true end
	if not hasKillerTeamName(lp) then
		if lp.Team and plr.Team and plr.Team ~= lp.Team then
			local tn = plr.Team and string.lower(tostring(plr.Team.Name or "")) or ""
			for _, kw in ipairs(spectatorKeywords) do
				if tn:find(string.lower(kw)) then return false end
			end
			return true
		end
	end
	return false
end

local function myRoot()
	local ch = lp.Character
	return ch and ch:FindFirstChild("HumanoidRootPart")
end

local function healthOk()
	local ch = lp.Character
	local hum = ch and ch:FindFirstChild("Humanoid")
	if not hum then return true end
	local h = hum.Health
	return (type(h) ~= "number") or (h > 50)
end

local function busy()
	local ch = lp.Character
	local sc = ch and ch:FindFirstChild("CheckInterractable")
	if not sc then return false end
	local ok, v = pcall(function() return sc:GetAttribute("isDroppingPallet") end)
	return ok and (v == true)
end

local function pressKey(keyCodeEnum, keyCodeNum)
	task.spawn(function()
		pcall(function()
			VirtualInputManager:SendKeyEvent(true, keyCodeEnum or Enum.KeyCode.Space, false, game)
			task.wait(0.01)
			VirtualInputManager:SendKeyEvent(false, keyCodeEnum or Enum.KeyCode.Space, false, game)
		end)
	end)
end

local LUNGE_CONFIG = {
	Mode          = "Infinite",
	ScanInterval  = 2,
	LungeBoostVal = 999999,
}
local LUNGE_S = {
	Running   = false,
	Ctrl      = nil,
	CtrlOrig  = nil,
	LastScan  = 0,
	Scanning  = false,
	OrigBoost = nil,
	Char      = nil,
}
local function lungeIsKiller()
	return hasKillerTeamName(lp)
end
local function lungeApplyMaxHold()
	if type(LUNGE_S.Ctrl) ~= "table" then return end
	if LUNGE_S.CtrlOrig == nil then
		LUNGE_S.CtrlOrig = rawget(LUNGE_S.Ctrl, "_origMaxHold") or LUNGE_S.Ctrl.maxHold
		rawset(LUNGE_S.Ctrl, "_origMaxHold", LUNGE_S.CtrlOrig)
	end
	if LUNGE_S.Ctrl.maxHold ~= math.huge then
		pcall(function() LUNGE_S.Ctrl.maxHold = math.huge end)
	end
end
local function lungeRestoreMaxHold()
	if type(LUNGE_S.Ctrl) == "table" and LUNGE_S.CtrlOrig ~= nil then
		pcall(function() LUNGE_S.Ctrl.maxHold = LUNGE_S.CtrlOrig end)
	end
	LUNGE_S.Ctrl, LUNGE_S.CtrlOrig = nil, nil
end
local function lungeApplyBoost()
	local char = lp.Character
	if not char then return end
	if LUNGE_S.Char ~= char then
		LUNGE_S.Char = char
		LUNGE_S.OrigBoost = char:GetAttribute("lungeboost")
	end
	if char:GetAttribute("lungeboost") ~= LUNGE_CONFIG.LungeBoostVal then
		pcall(function() char:SetAttribute("lungeboost", LUNGE_CONFIG.LungeBoostVal) end)
	end
end
local function lungeRestoreBoost()
	local char = lp.Character
	if char and char:GetAttribute("lungeboost") == LUNGE_CONFIG.LungeBoostVal then
		pcall(function() char:SetAttribute("lungeboost", LUNGE_S.OrigBoost or 1) end)
	end
	LUNGE_S.Char, LUNGE_S.OrigBoost = nil, nil
end
local function lungeScan()
	if LUNGE_S.Scanning or not lp.Character or not lungeIsKiller() then return end
	if typeof(getgc) ~= "function" then return end
	LUNGE_S.Scanning = true
	local char = lp.Character
	pcall(function()
		local gc = getgc(true)
		if type(gc) ~= "table" then return end
		local start = os.clock()
		for i, obj in ipairs(gc) do
			if not state.running or lp.Character ~= char then return end
			if i % 128 == 0 and os.clock() - start >= 0.002 then
				RunService.Heartbeat:Wait(); start = os.clock()
			end
			if type(obj) == "table"
				and rawget(obj, "maxHold") ~= nil
				and rawget(obj, "lungeThreshold") ~= nil then
				LUNGE_S.Ctrl = obj
				LUNGE_S.CtrlOrig = rawget(obj, "_origMaxHold") or obj.maxHold
				rawset(obj, "_origMaxHold", LUNGE_S.CtrlOrig)
				break
			end
		end
	end)
	LUNGE_S.Scanning = false
end

local _lungeWasRunning = false

local _lungeHbConn = RunService.Heartbeat:Connect(function()
	if not state.running then return end
	if not LUNGE_S.Running then
		if _lungeWasRunning then
			_lungeWasRunning = false
			lungeRestoreBoost()
			lungeRestoreMaxHold()
		end
		return
	end
	_lungeWasRunning = true
	if not lp.Character then
		lungeRestoreMaxHold(); lungeRestoreBoost(); return
	end
	if lungeIsKiller() then
		lungeApplyBoost()
		if LUNGE_S.Ctrl then lungeApplyMaxHold() end
	else
		lungeRestoreBoost(); lungeRestoreMaxHold()
	end
	local now = tick()
	if lungeIsKiller() and (not LUNGE_S.Ctrl or not LUNGE_S.Ctrl.maxHold)
		and now - LUNGE_S.LastScan >= LUNGE_CONFIG.ScanInterval then
		LUNGE_S.LastScan = now
		task.spawn(lungeScan)
	end
end)

lp.CharacterAdded:Connect(function()
	LUNGE_S.Ctrl, LUNGE_S.CtrlOrig = nil, nil
	LUNGE_S.Char, LUNGE_S.OrigBoost = nil, nil
	task.wait(2); LUNGE_S.LastScan = 0; pcall(lungeScan)
end)

task.spawn(function() task.wait(2); pcall(lungeScan) end)

local _speedModOriginals       = setmetatable({}, { __mode = "k" })
local _speedModVaultOriginals  = setmetatable({}, { __mode = "k" })
local _speedModLastApplied     = setmetatable({}, { __mode = "k" })
local _speedModModels          = setmetatable({}, { __mode = "k" })
local _speedModConns           = {}
local _speedModCachedModels    = {}
local _speedModCacheDirty      = true

local function speedModNormalizeTeam(team)
    local t = tostring(team or "Both"):lower():gsub("%s+", "")
    if t == "survivors" or t == "survivor" then return "Survivors" end
    if t == "killer" or t == "killers" then return "Killer" end
    return "Both"
end

local function speedModAllows(teamName)
    local filter = speedModNormalizeTeam(state.cfg.speedMod_team)
    if filter == "Both" then return true end
    if not teamName then return false end
    local t = string.lower(tostring(teamName)):gsub("%s+", "")
    if filter == "Survivors" then return t == "survivors" or t == "survivor" end
    return t == "killer" or t == "killers"
end

local function speedModGetAttr(model, name)
    if not model or not model.Parent then return nil end
    local ok, v = pcall(function() return model:GetAttribute(name) end)
    return ok and v or nil
end

local function speedModComputeSpeed(base, teamName)
    local countPerks = state.cfg.speedMod_countPerks
    local boost      = tonumber(state.cfg.speedMod_value) or 1.5
    local baseSpeed  = tonumber(base) or 1
    local allowed    = speedModAllows(teamName)
    if not countPerks then return allowed and boost or 1 end
    return allowed and (baseSpeed + (boost - 1)) or baseSpeed
end

local function speedModApplyToModel(model, teamName)
    if not model or not model.Parent then return end

    if _speedModOriginals[model] == nil then
        _speedModOriginals[model] = speedModGetAttr(model, "speedboost") or 1
    end
    local origSpeed   = _speedModOriginals[model]
    local targetSpeed = speedModComputeSpeed(origSpeed, teamName)

    if _speedModLastApplied[model] ~= targetSpeed then
        pcall(function() model:SetAttribute("speedboost", targetSpeed) end)
        _speedModLastApplied[model] = targetSpeed
    end

    local vaultMult = tonumber(state.cfg.speedMod_vaultSpeed) or 1
    if vaultMult ~= 1 and speedModAllows(teamName) then
        if _speedModVaultOriginals[model] == nil then
            _speedModVaultOriginals[model] = speedModGetAttr(model, "vaultspeed") or 1
        end
        local origVault = _speedModVaultOriginals[model]
        local newVault  = origVault * vaultMult
        if speedModGetAttr(model, "vaultspeed") ~= newVault then
            pcall(function() model:SetAttribute("vaultspeed", newVault) end)
        end
    elseif _speedModVaultOriginals[model] ~= nil then
        pcall(function() model:SetAttribute("vaultspeed", _speedModVaultOriginals[model]) end)
        _speedModVaultOriginals[model] = nil
    end
end

local function speedModGetPlayerModels()
    if not _speedModCacheDirty and #_speedModCachedModels > 0 then
        for i = #_speedModCachedModels, 1, -1 do
            local m = _speedModCachedModels[i]
            if not m or not m.Parent then table.remove(_speedModCachedModels, i) end
        end
        return _speedModCachedModels
    end
    _speedModCacheDirty = false
    local list = {}
    local name = lp.Name
    if not name then return list end
    if lp.Character then table.insert(list, lp.Character) end
    local w = workspace:FindFirstChild(name)
    if w and w:IsA("Model") and not table.find(list, w) then table.insert(list, w) end
    for _, folderName in ipairs({ "climb_obsessing", "climb_collisoning", "climb_collisioning", "climb_colliding" }) do
        local folder = workspace:FindFirstChild(folderName)
        if folder then
            local m = folder:FindFirstChild(name)
            if m and m:IsA("Model") and not table.find(list, m) then table.insert(list, m) end
        end
    end
    _speedModCachedModels = list
    return list
end

local function speedModAttachModel(model)
    if not model or _speedModModels[model] then return end
    _speedModModels[model] = true
    local conn
    conn = model.AttributeChanged:Connect(function(attr)
        if attr ~= "speedboost" then return end
        if not state.cfg.speedMod_enabled then return end
        local cur = speedModGetAttr(model, "speedboost")
        if cur and _speedModLastApplied[model] and math.abs(cur - _speedModLastApplied[model]) > 0.001 then
            _speedModLastApplied[model] = nil
            local team = lp.Team and lp.Team.Name or ""
            speedModApplyToModel(model, team)
        end
    end)
    table.insert(_speedModConns, { conn = conn, model = model })
end

local function speedModPruneConns()
    for i = #_speedModConns, 1, -1 do
        local rec = _speedModConns[i]
        if not rec.model or not rec.model.Parent then
            pcall(function() rec.conn:Disconnect() end)
            table.remove(_speedModConns, i)
        end
    end
end

local function speedModCleanup()
    for model, orig in pairs(_speedModOriginals) do
        if model and model.Parent then
            pcall(function() model:SetAttribute("speedboost", orig) end)
        end
    end
    for model, orig in pairs(_speedModVaultOriginals) do
        if model and model.Parent then
            pcall(function() model:SetAttribute("vaultspeed", orig) end)
        end
    end
    table.clear(_speedModOriginals)
    table.clear(_speedModVaultOriginals)
    table.clear(_speedModLastApplied)

    for _, rec in ipairs(_speedModConns) do
        pcall(function() rec.conn:Disconnect() end)
    end
    table.clear(_speedModConns)
    table.clear(_speedModModels)
    table.clear(_speedModCachedModels)
    _speedModCacheDirty = true
end

local function speedModTick()
    if not state.cfg.speedMod_enabled then return end
    speedModPruneConns()
    local teamName = lp.Team and lp.Team.Name or ""
    for _, m in ipairs(speedModGetPlayerModels()) do
        speedModAttachModel(m)
        speedModApplyToModel(m, teamName)
    end
end

lp.CharacterAdded:Connect(function()
    _speedModCacheDirty = true
    pcall(speedModCleanup)
    task.delay(1.0, function()
        if state.cfg.speedMod_enabled then
            pcall(speedModTick)
        end
    end)
end)

lp:GetPropertyChangedSignal("Team"):Connect(function()
    table.clear(_speedModLastApplied)
    _speedModCacheDirty = true
    if state.cfg.speedMod_enabled then task.defer(speedModTick) end
end)

local function healSelf()
    pcall(function()
        local Event = game:GetService("ReplicatedStorage").Remotes.Healing.HealEvent
        local myChar = lp.Character
        local myRoot2 = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not myRoot2 then return end
        Event:FireServer(myRoot2, true, "BBA6AE6C-E28A-45BB-AB2F-5D6F1F7CA4EE", myChar)
    end)
end

local function getAnimAssetId(track)
	local ok, animId = pcall(function()
		return track.Animation and track.Animation.AnimationId or ""
	end)
	if not ok then return nil end
	return tonumber(animId:match("(%d+)$"))
end

local function getTextWidth(text, size)
    return #text * (size * 0.55)
end

local function findAnimator(char)
    if not char then return nil end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        local a = hum:FindFirstChildOfClass("Animator")
        if a then return a end
    end
    for _, v in ipairs(char:GetDescendants()) do
        if v:IsA("Animator") then return v end
    end
    return nil
end

local function isPalletDropped(pal)
	if not pal or not pal.board or not pal.board.Parent then return true end
	if state.droppedPallets[pal.id] then return true end
	local b = pal.board
	local p = b.Parent
	if b:GetAttribute("isDropped") or b:GetAttribute("Dropped") or b:GetAttribute("isDown") then
		state.droppedPallets[pal.id] = true; return true
	end
	if p and (p:GetAttribute("isDropped") or p:GetAttribute("Dropped") or p:GetAttribute("isDown")) then
		state.droppedPallets[pal.id] = true; return true
	end
	return false
end

local function saveOriginalLighting()
    state.originalLighting.Brightness      = Lighting.Brightness
    state.originalLighting.ClockTime       = Lighting.ClockTime
    state.originalLighting.FogEnd          = Lighting.FogEnd
    state.originalLighting.FogStart        = Lighting.FogStart
    state.originalLighting.GlobalShadows   = Lighting.GlobalShadows
    state.originalLighting.Ambient         = Lighting.Ambient
    state.originalLighting.OutdoorAmbient  = Lighting.OutdoorAmbient
end
saveOriginalLighting()

local function applyFullBright()
    Lighting.Brightness     = 2
    Lighting.ClockTime      = 14
    Lighting.GlobalShadows  = false
    Lighting.Ambient        = Color3.fromRGB(255, 255, 255)
    Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
end

local function restoreFullBright()
    Lighting.Brightness     = state.originalLighting.Brightness
    Lighting.ClockTime      = state.originalLighting.ClockTime
    Lighting.GlobalShadows  = state.originalLighting.GlobalShadows
    Lighting.Ambient        = state.originalLighting.Ambient
    Lighting.OutdoorAmbient = state.originalLighting.OutdoorAmbient
end

local function applyNoFog()
    Lighting.FogEnd   = 100000
    Lighting.FogStart = 100000
    for _, obj in ipairs(Lighting:GetChildren()) do
        if obj:IsA("Atmosphere") then
            state.savedAtmosphere[#state.savedAtmosphere + 1] = {
                obj = obj, Density = obj.Density, Offset = obj.Offset, Haze = obj.Haze,
            }
            obj.Density = 0; obj.Offset = 0; obj.Haze = 0
        end
        if obj:IsA("ColorCorrectionEffect") then
            state.savedColorCorrection[#state.savedColorCorrection + 1] = {
                obj = obj, Enabled = obj.Enabled,
                Brightness = obj.Brightness, Contrast = obj.Contrast, Saturation = obj.Saturation,
            }
            obj.Brightness = 0; obj.Contrast = 0; obj.Saturation = 0
        end
    end
    for _, obj in ipairs(Workspace:GetDescendants()) do
        local name = string.lower(obj.Name or "")
        if name:find("fog") or name:find("mist") or name:find("haze") then
            if obj:IsA("BasePart") then
                obj.Transparency = 1; obj.CastShadow = false
            elseif obj:IsA("ParticleEmitter") or obj:IsA("Smoke") then
                obj.Enabled = false
            end
        end
    end
end

local function restoreNoFog()
    Lighting.FogEnd   = state.originalLighting.FogEnd
    Lighting.FogStart = state.originalLighting.FogStart
    for _, s in ipairs(state.savedAtmosphere) do
        pcall(function() s.obj.Density = s.Density; s.obj.Offset = s.Offset; s.obj.Haze = s.Haze end)
    end
    state.savedAtmosphere = {}
    for _, s in ipairs(state.savedColorCorrection) do
        pcall(function()
            s.obj.Enabled = s.Enabled; s.obj.Brightness = s.Brightness
            s.obj.Contrast = s.Contrast; s.obj.Saturation = s.Saturation
        end)
    end
    state.savedColorCorrection = {}
end

Lighting.Changed:Connect(function(prop)
    if not (state._fullbrightEnabled or state._nofogEnabled) then return end
    if state._fullbrightEnabled and (prop == "Brightness" or prop == "ClockTime" or prop == "Ambient" or prop == "OutdoorAmbient") then
        if Lighting.Brightness < 1.5 then applyFullBright() end
    end
end)

Lighting.ChildAdded:Connect(function(child)
    if not state._nofogEnabled then return end
    task.wait(0.1)
    if child:IsA("Atmosphere") then
        child.Density = 0; child.Offset = 0; child.Haze = 0
    elseif child:IsA("ColorCorrectionEffect") then
        child.Brightness = 0; child.Contrast = 0; child.Saturation = 0
    end
end)

local FV_DISCOVER_COOLDOWN = 8
local _fvLastDiscover      = 0
local _fvFailCount         = 0

local function fvDiscover()
    local char = lp.Character
    if not char then return end

    if state._fvController then
        local ok, c = pcall(rawget, state._fvController, "character")
        if ok and c == char then return end
        state._fvController = nil
    end

    local now = tick()
    if (now - _fvLastDiscover) < FV_DISCOVER_COOLDOWN then return end
    _fvLastDiscover = now

    if _fvFailCount > 3 then
        task.wait(0)
    end

    local ok, gc = pcall(getgc, true)
    if not ok or type(gc) ~= "table" then return end

    for _, v in ipairs(gc) do
        if type(v) == "table" then
            local ok1, fn1 = pcall(rawget, v, "_onVaultAnimation")
            local ok2, fn2 = pcall(rawget, v, "_cancelVaultTraversal")
            if ok1 and ok2 and type(fn1) == "function" and type(fn2) == "function" then
                local cOk, cVal = pcall(rawget, v, "character")
                if not cOk or not cVal or cVal == char then
                    state._fvController = v
                    _fvFailCount = 0
                    return
                end
            end
        end
    end
    _fvFailCount += 1
end

local function fvPatch()
    if not state.cfg.fastVault_enabled then return end
    if not state._fvController then return end

    local ctrl = state._fvController

    for _, p in ipairs(state._fvPatches) do
        if p.Module == ctrl then
            local okCur, cur = pcall(rawget, ctrl, p.Key)
            if okCur and cur == p.Wrapped then
                return
            end
            p.Original = cur
            local wrapped = function(...)
                if state.cfg.fastVault_enabled then
                    return true, "ready", 5
                end
                return p.Original(...)
            end
            if pcall(rawset, ctrl, p.Key, wrapped) then
                p.Wrapped = wrapped
            end
            return
        end
    end

    local ok, orig = pcall(rawget, ctrl, "_validateFastVault")
    if not ok or type(orig) ~= "function" then return end

    local wrapped = function(...)
        if state.cfg.fastVault_enabled then
            return true, "ready", 5
        end
        return orig(...)
    end
    local setOk = pcall(rawset, ctrl, "_validateFastVault", wrapped)
    if not setOk then return end
    table.insert(state._fvPatches, {
        Module = ctrl, Key = "_validateFastVault",
        Original = orig, Wrapped = wrapped,
    })
end

local function fvUnpatch()
    for _, p in ipairs(state._fvPatches) do
        local ok, cur = pcall(rawget, p.Module, p.Key)
        if ok and cur == p.Wrapped then
            pcall(rawset, p.Module, p.Key, p.Original)
        end
    end
    table.clear(state._fvPatches)
    state._fvController = nil
    _fvLastDiscover = 0
    _fvFailCount = 0
end

local function fsClearAttr()
    pcall(function()
        local c = lp.Character
        if c then c:SetAttribute("Flowstate", false) end
        lp:SetAttribute("Flowstate", false)
        for _, fn in ipairs({"climb_obsessing","climb_collisoning","climb_collisioning","climb_colliding"}) do
            local f = workspace:FindFirstChild(fn)
            if f then
                local m = f:FindFirstChild(lp.Name)
                if m then m:SetAttribute("Flowstate", false) end
            end
        end
    end)
end

local function fsApplyAttr()
    if not state.cfg.flowstate_enabled then return end
    local c = lp.Character
    if not c then return end
    local now = tick()

    if state._fsCD == 0 and state._fsOverrideEnd == 0 then
        state._fsOverrideEnd = now + 0.5
        state._fsCD = now + 0.5 + (state.cfg.flowstate_cooldown or 15)
    end

    local inOvr = now < state._fsOverrideEnd
    local inCD  = now < state._fsCD
    local val   = inOvr or not inCD

    if lp:GetAttribute("Flowstate") ~= val then lp:SetAttribute("Flowstate", val) end
    if c:GetAttribute("Flowstate") ~= val then c:SetAttribute("Flowstate", val) end
    for _, fn in ipairs({"climb_obsessing","climb_collisoning","climb_collisioning","climb_colliding"}) do
        local f = workspace:FindFirstChild(fn)
        if f then
            local m = f:FindFirstChild(lp.Name)
            if m and m:GetAttribute("Flowstate") ~= val then m:SetAttribute("Flowstate", val) end
        end
    end
end

local function fvHookAnim(char)
    if state._fvAnimConn then
        pcall(function() state._fvAnimConn:Disconnect() end)
        state._fvAnimConn = nil
    end
    if not char then return end
    task.spawn(function()
        local hum = char:WaitForChild("Humanoid", 5)
        if not hum then return end
        local anim = hum:WaitForChild("Animator", 5)
        if not anim then return end
        state._fvAnimConn = anim.AnimationPlayed:Connect(function(track)
            if not state.cfg.flowstate_enabled then return end
            local name = string.lower(track.Name or "")
            local id = track.Animation and tostring(track.Animation.AnimationId):lower() or ""
            if name:find("walking") or id:find("126081405469607") then return end
            if name:find("running") or name:find("finesse") or name:find("fast")
                or id:find("83873880822918") or id:find("136962284480779") then
                local now = tick()
                if now < state._fsOverrideEnd then return end
                if now < state._fsCD then return end
                state._fsOverrideEnd = now + 0.5
                state._fsCD = now + 0.5 + (state.cfg.flowstate_cooldown or 15)
            end
        end)
    end)
end

local function get2DScreenBounds(char)
	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then return nil end
	local cam = workspace.CurrentCamera
	if not cam then return nil end
	local head = char:FindFirstChild("Head")
	local topY    = head and (head.Position.Y + 1.5) or (root.Position.Y + 3.8)
	local bottomY = root.Position.Y - 3.8
	local rootPos    = root.Position
	local topWorld    = Vector3.new(rootPos.X, topY, rootPos.Z)
	local bottomWorld = Vector3.new(rootPos.X, bottomY, rootPos.Z)
	local topScreen, _    = cam:WorldToViewportPoint(topWorld)
	local bottomScreen, _ = cam:WorldToViewportPoint(bottomWorld)
	if topScreen.Z < 0 then return nil end
	local height = math.abs(bottomScreen.Y - topScreen.Y)
	if height < 10 then height = 10 end
	local width = math.clamp(height * 0.55, 14, 500)
	local x = topScreen.X - (width / 2)
	local y = topScreen.Y
	local realDist = (cam.CFrame.Position - rootPos).Magnitude
	return x, y, width, height, realDist
end

local function updateEspElem(elem, char, x, y, width, height, dist)
	local c = state.cfg
	local cam = workspace.CurrentCamera
	if elem.highlight then elem.highlight.Enabled = c.p_esp_showHighlight end
	if x then
		local vp = cam.ViewportSize
		local labelX    = math.clamp(x + (width/2) - 80, 0, vp.X - 160)
		local labelTopY = math.clamp(y - 22, 0, vp.Y - 30)
		local labelBotY = math.clamp(y + height + 3, 0, vp.Y - 20)
		local dynamicFont = math.clamp(math.floor(height * 0.20), 10, 14)
		elem.container.Visible = true
		elem.nameLabel.Visible = c.p_esp_showName
		local knocked = char:GetAttribute("Knocked")
		local okBot, botId   = pcall(function() return char:GetAttribute("BotId") end)
		local okBot2, botNetId = pcall(function() return char:GetAttribute("BotNetId") end)
		local isBot = (okBot and botId ~= nil) or (okBot2 and botNetId ~= nil)
		local displayName = isBot and ("[Bot] " .. char.Name) or char.Name
		elem.nameLabel.Text = displayName .. (knocked and "  [KNOCKED]" or "")
		if knocked then
			elem.nameLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
			if elem.highlight then elem.highlight.OutlineColor = Color3.fromRGB(255, 80, 80) end
		else
			elem.nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			if elem.highlight then elem.highlight.OutlineColor = Color3.fromRGB(255, 255, 255) end
		end
		elem.nameLabel.Position = UDim2.new(0, labelX, 0, labelTopY)
		elem.nameLabel.TextSize = dynamicFont
		elem.distLabel.Visible  = true
		elem.distLabel.Position = UDim2.new(0, labelX, 0, labelBotY)
		elem.distLabel.TextSize = math.max(9, dynamicFont - 1)
		elem.distLabel.Text     = string.format("[%d studs]", math.floor(dist or 0))
		if elem.itemLabel then
			local icon = nil
			for _, child in ipairs(char:GetChildren()) do
				if child:IsA("Model") or child:IsA("Tool") then
					local foundIcon = ITEM_ICONS[child.Name]
					if foundIcon then icon = foundIcon; break end
				end
			end
			if not icon then
				local ok2, eq = pcall(function() return char:GetAttribute("EquippedItem") end)
				if ok2 and eq then icon = ITEM_ICONS[tostring(eq)] end
			end
			if icon then
				local iconSize = 35
				local iconX = math.clamp(x + (width/2) - iconSize/2, 0, vp.X - iconSize)
				local iconY = math.clamp(y + height + 18, 0, vp.Y - iconSize)
				elem.itemLabel.Image    = icon
				elem.itemLabel.Size     = UDim2.new(0, iconSize, 0, iconSize)
				elem.itemLabel.Position = UDim2.new(0, iconX, 0, iconY)
				elem.itemLabel.Visible  = true
			else
				elem.itemLabel.Visible = false
			end
		end
	else
		elem.container.Visible = false
	end
end

local removePlayer2DESP
local removeKiller2DESP
local createKiller2DESP

local function createPlayer2DESP(char)
    removePlayer2DESP(char)
    local highlight = Instance.new("Highlight")
    highlight.Name                = "KKKkhub_Player_Highlight"
    highlight.FillColor           = Color3.fromRGB(255, 255, 255)
    highlight.OutlineColor        = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency    = 1
    highlight.OutlineTransparency = 0
    highlight.DepthMode           = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Adornee             = char
    highlight.Parent              = char
    local container = Instance.new("Frame")
    container.Name                   = "Player2DContainer"
    container.BackgroundTransparency = 1
    container.Size                   = UDim2.new(1, 0, 1, 0)
    container.Parent                 = espGui
    local nameLabel = Instance.new("TextLabel")
    nameLabel.BackgroundTransparency = 1
    nameLabel.Size                   = UDim2.new(0, 160, 0, 16)
    nameLabel.TextColor3             = Color3.fromRGB(255, 255, 255)
    nameLabel.TextStrokeTransparency = 0
    nameLabel.Font                   = Enum.Font.GothamBold
    nameLabel.TextSize               = 13
    nameLabel.TextXAlignment         = Enum.TextXAlignment.Center
    nameLabel.Text                   = char.Name
    nameLabel.Parent                 = container
    local distLabel = Instance.new("TextLabel")
    distLabel.BackgroundTransparency = 1
    distLabel.Size                   = UDim2.new(0, 160, 0, 14)
    distLabel.TextColor3             = Color3.fromRGB(200, 200, 200)
    distLabel.TextStrokeTransparency = 0
    distLabel.Font                   = Enum.Font.GothamBold
    distLabel.TextSize               = 11
    distLabel.TextXAlignment         = Enum.TextXAlignment.Center
    distLabel.Text                   = ""
    distLabel.Parent                 = container
    local itemLabel = Instance.new("ImageLabel")
    itemLabel.BackgroundTransparency = 1
    itemLabel.Size                   = UDim2.new(0, 24, 0, 24)
    itemLabel.ScaleType              = Enum.ScaleType.Fit
    itemLabel.Image                  = ""
    itemLabel.Visible                = false
    itemLabel.Parent                 = container
    state.player2DEspElements[char] = {
        container = container,
        highlight = highlight,
        nameLabel = nameLabel,
        distLabel = distLabel,
        itemLabel = itemLabel,
    }
end

removeKiller2DESP = function(char)
	if state.killer2DEspElements[char] then
		pcall(function() state.killer2DEspElements[char].container:Destroy() end)
		pcall(function() state.killer2DEspElements[char].highlight:Destroy() end)
		state.killer2DEspElements[char] = nil
	end
end

createKiller2DESP = function(char)
	removeKiller2DESP(char)
	local highlight = Instance.new("Highlight")
	highlight.Name                = "KKKkhub_Killer_Highlight"
	highlight.FillColor           = Color3.fromRGB(0, 0, 0)
	highlight.OutlineColor        = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency    = 1
    highlight.OutlineTransparency = 0
    highlight.DepthMode           = Enum.HighlightDepthMode.AlwaysOnTop
	highlight.Adornee             = char
	highlight.Parent              = char
	local container = Instance.new("Frame")
	container.Name                   = "Killer2DContainer"
	container.BackgroundTransparency = 1
	container.Size                   = UDim2.new(1, 0, 1, 0)
	container.Parent                 = espGui
	local nameLabel = Instance.new("TextLabel")
	nameLabel.BackgroundTransparency = 1
	nameLabel.Size                   = UDim2.new(0, 160, 0, 16)
	nameLabel.TextColor3             = Color3.fromRGB(255, 255, 255)
	nameLabel.TextStrokeTransparency = 0
	nameLabel.Font                   = Enum.Font.GothamBold
	nameLabel.TextSize               = 13
	nameLabel.TextXAlignment         = Enum.TextXAlignment.Center
	nameLabel.Text                   = "[Killer] " .. char.Name
	nameLabel.Parent                 = container
	local distLabel = Instance.new("TextLabel")
	distLabel.BackgroundTransparency = 1
	distLabel.Size                   = UDim2.new(0, 160, 0, 14)
	distLabel.TextColor3             = Color3.fromRGB(200, 200, 200)
	distLabel.TextStrokeTransparency = 0
	distLabel.Font                   = Enum.Font.GothamBold
	distLabel.TextSize               = 11
	distLabel.TextXAlignment         = Enum.TextXAlignment.Center
	distLabel.Text                   = ""
	distLabel.Parent                 = container
	state.killer2DEspElements[char] = {
		container = container,
		highlight = highlight,
		nameLabel = nameLabel,
		distLabel = distLabel,
	}
end

removePlayer2DESP = function(char)
	if state.player2DEspElements[char] then
		pcall(function() state.player2DEspElements[char].container:Destroy() end)
		pcall(function() state.player2DEspElements[char].highlight:Destroy() end)
		state.player2DEspElements[char] = nil
	end
end

local function removeSCPESP(model)
	local e = state.scpEspElements[model]
	if not e then return end
	pcall(function() e.highlight:Destroy() end)
	state.scpEspElements[model] = nil
end

local function createSCPESP(model)
	if state.scpEspElements[model] then return end
	local root = model.PrimaryPart
		or model:FindFirstChildOfClass("MeshPart")
		or model:FindFirstChildOfClass("BasePart")
	if not root then return end
	local hl = Instance.new("Highlight")
	hl.Name                = "KKKkhub_SCP_Highlight"
	hl.FillColor           = Color3.fromRGB(0, 0, 0)
	hl.OutlineColor        = Color3.fromRGB(255, 255, 255)
	hl.FillTransparency    = 0.5
	hl.OutlineTransparency = 0
	hl.DepthMode           = Enum.HighlightDepthMode.AlwaysOnTop
	hl.Adornee             = model
	hl.Parent              = model
	state.scpEspElements[model] = { highlight = hl }
end

local function isValidSCP(name)
    local lower = string.lower(name)
    local num = lower:match("^scp[%-%s]?(%d+)$")
    if num then
        local n = tonumber(num)
        return n and n >= 1 and n <= 8
    end
    return false
end

local function scanSCPs()
    if os.clock() - state._scpScanTime < 2 then return end
    state._scpScanTime = os.clock()
    local found = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and isValidSCP(obj.Name) then
            found[obj] = true
            createSCPESP(obj)
        end
    end
    for model in pairs(state.scpEspElements) do
        if not found[model] then removeSCPESP(model) end
    end
end

Workspace.DescendantAdded:Connect(function(obj)
    if not state.bearTrapEspEnabled then return end
    if not obj:IsA("Model") then return end
    local lower = string.lower(obj.Name)
    if lower == "beartrap" or lower == "bear_trap" then
        task.wait(0.1)
        createBearTrapESP(obj)
    end
end)

Workspace.DescendantRemoving:Connect(function(obj)
    if state.bearTrapEspElements[obj] then removeBearTrapESP(obj) end
end)

local function removeGenESP(model)
    local e = state.genEspElements[model]
    if not e then return end
    pcall(function() e.highlight:Destroy() end)
    pcall(function() e.nameText:Remove() end)
    pcall(function() e.infoText:Remove() end)
    pcall(function() e.barBg:Remove() end)
    pcall(function() e.barFill:Remove() end)
    state.genEspElements[model] = nil
end

local function createGenESP(model, index)
    if state.genEspElements[model] then return end
    local root = model:FindFirstChild("RootPart")
        or model.PrimaryPart
        or model:FindFirstChildOfClass("MeshPart")
        or model:FindFirstChildOfClass("BasePart")
    if not root then return end
    local nameText = Drawing.new("Text")
    nameText.Visible   = false; nameText.Text = model.Name; nameText.Size = 14
    nameText.Font      = Drawing.Fonts.Plex; nameText.Color = Color3.fromRGB(255, 255, 255)
    nameText.Outline   = true; nameText.Center = true
    local infoText = Drawing.new("Text")
    infoText.Visible   = false; infoText.Text = "0% | idle"; infoText.Size = 12
    infoText.Font      = Drawing.Fonts.Plex; infoText.Color = Color3.fromRGB(200, 200, 200)
    infoText.Outline   = true; infoText.Center = true
    local barBg = Drawing.new("Square")
    barBg.Visible = false; barBg.Filled = true; barBg.Color = Color3.fromRGB(40, 40, 40)
    barBg.Transparency = 0.4; barBg.Thickness = 1
    local barFill = Drawing.new("Square")
    barFill.Visible = false; barFill.Filled = true; barFill.Color = Color3.fromRGB(255, 255, 255)
    barFill.Transparency = 1; barFill.Thickness = 1
    local hl = Instance.new("Highlight")
    hl.FillColor = Color3.fromRGB(0,0,0); hl.OutlineColor = Color3.fromRGB(255,255,255)
    hl.FillTransparency = 0.5; hl.OutlineTransparency = 0
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Adornee = model; hl.Parent = model
    state.genEspElements[model] = {
        highlight = hl, nameText = nameText, infoText = infoText,
        barBg = barBg, barFill = barFill, rootPart = root,
    }
end

local function initialScanGen()
    if state._genScanCache and os.clock() - state._genScanTime < 3 then return end
    state._genScanTime = os.clock()
    local found = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name == "Generator" then
            found[obj] = true
            if not state.genEspElements[obj] then
                state._genCounter = state._genCounter + 1
                createGenESP(obj, state._genCounter)
            end
        end
    end
    local resources = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("resources")
    if resources then
        local generatorsFolder = resources:FindFirstChild("Generators")
        if generatorsFolder then
            for _, obj in ipairs(generatorsFolder:GetChildren()) do
                if obj:IsA("Model") and obj.Name == "Generator" then
                    found[obj] = true
                    if not state.genEspElements[obj] then
                        state._genCounter = state._genCounter + 1
                        createGenESP(obj, state._genCounter)
                    end
                end
            end
        end
    end
    for model in pairs(state.genEspElements) do
        if not found[model] then removeGenESP(model) end
    end
    state._genScanCache = found
end

local function removeBearTrapESP(model)
    local e = state.bearTrapEspElements[model]
    if not e then return end
    pcall(function() e.highlight:Destroy() end)
    pcall(function() e.nameText:Remove() end)
    pcall(function() e.distText:Remove() end)
    state.bearTrapEspElements[model] = nil
end

local function createBearTrapESP(model)
    if state.bearTrapEspElements[model] then return end
    local root = model:FindFirstChild("RootPart")
        or model.PrimaryPart
        or model:FindFirstChildOfClass("MeshPart")
        or model:FindFirstChildOfClass("BasePart")
    if not root then return end
    local nameText = Drawing.new("Text")
    nameText.Visible = false; nameText.Text = "BearTrap"; nameText.Size = 14
    nameText.Font = Drawing.Fonts.Plex; nameText.Color = Color3.fromRGB(255,255,255)
    nameText.Outline = true; nameText.Center = true
    local distText = Drawing.new("Text")
    distText.Visible = false; distText.Text = ""; distText.Size = 12
    distText.Font = Drawing.Fonts.Plex; distText.Color = Color3.fromRGB(200,200,200)
    distText.Outline = true; distText.Center = true
    local barBg = Drawing.new("Square")
    barBg.Visible = false; barBg.Filled = true; barBg.Color = Color3.fromRGB(40,40,40)
    barBg.Transparency = 0.4; barBg.Thickness = 1
    local hl = Instance.new("Highlight")
    hl.FillColor = Color3.fromRGB(0,0,0); hl.OutlineColor = Color3.fromRGB(255,255,255)
    hl.FillTransparency = 0.5; hl.OutlineTransparency = 0
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Adornee = model; hl.Parent = model
    state.bearTrapEspElements[model] = {
        highlight = hl, nameText = nameText, distText = distText, barBg = barBg, rootPart = root,
    }
end

local function initialScanBearTrap()
    if os.clock() - state._bearTrapScanTime < 0.5 then return end
    state._bearTrapScanTime = os.clock()
    local found = {}
    local mapFolder = workspace:FindFirstChild("Map")
    if not mapFolder then return end
    for _, obj in ipairs(mapFolder:GetDescendants()) do
        if obj:IsA("Model") then
            local lower = string.lower(obj.Name)
            if lower == "beartrap" or lower == "bear_trap" then
                found[obj] = true
                if not state.bearTrapEspElements[obj] then createBearTrapESP(obj) end
            end
        end
    end
    for model in pairs(state.bearTrapEspElements) do
        if not found[model] then removeBearTrapESP(model) end
    end
end

local function removePumpkinESP(model)
    local e = state.pumpkinEspElements[model]
    if not e then return end
    pcall(function() e.highlight:Destroy() end)
    state.pumpkinEspElements[model] = nil
end

local function createPumpkinESP(model)
    if state.pumpkinEspElements[model] then return end
    local root = model.PrimaryPart
        or model:FindFirstChildOfClass("MeshPart")
        or model:FindFirstChildOfClass("BasePart")
    if not root then return end
    local hl = Instance.new("Highlight")
    hl.FillColor = Color3.fromRGB(0,0,0); hl.OutlineColor = Color3.fromRGB(255,255,255)
    hl.FillTransparency = 0.5; hl.OutlineTransparency = 0
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Adornee = model; hl.Parent = model
    state.pumpkinEspElements[model] = { highlight = hl, rootPart = root }
end

local function scanPumpkins()
    if os.clock() - state._pumpkinScanTime < 3 then return end
    state._pumpkinScanTime = os.clock()
    local pumpkinFolder = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Pumpkins")
    if not pumpkinFolder then return end
    local found = {}
    for _, obj in ipairs(pumpkinFolder:GetChildren()) do
        if obj:IsA("Model") or obj:IsA("BasePart") then
            found[obj] = true
            if not state.pumpkinEspElements[obj] then createPumpkinESP(obj) end
        end
    end
    for model in pairs(state.pumpkinEspElements) do
        if not found[model] then removePumpkinESP(model) end
    end
end

local function addBoxOutline(part)
    if part:FindFirstChildOfClass("BoxHandleAdornment") then return end
    local box = Instance.new("BoxHandleAdornment")
    box.Adornee = part; box.Color3 = Color3.fromRGB(255,255,255); box.Transparency = 0.5
    box.Size = part.Size; box.AlwaysOnTop = true; box.ZIndex = 0; box.Parent = part
end

local function addHighlight(parent, fillColor, outlineColor)
    if parent:FindFirstChildOfClass("Highlight") then return end
    local highlight = Instance.new("Highlight")
    highlight.FillColor = fillColor or Color3.fromRGB(0,0,0)
    highlight.OutlineColor = outlineColor or Color3.fromRGB(255,255,255)
    highlight.FillTransparency = 0.5; highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Adornee = parent; highlight.Parent = parent
end

local function removeVaultESP(obj)
    local e = state.vaultEspElements[obj]
    if not e then return end
    pcall(function() e.highlight:Destroy() end)
    pcall(function()
        local box = obj:FindFirstChildOfClass("BoxHandleAdornment")
        if box then box:Destroy() end
    end)
    state.vaultEspElements[obj] = nil
end

local function removePalletESP(model)
    local e = state.palletEspElements[model]
    if not e then return end
    pcall(function() e.highlight:Destroy() end)
    state.palletEspElements[model] = nil
end

local function createVaultESP(obj)
    if state.vaultEspElements[obj] then return end
    if not obj or not obj.Parent then return end
    addBoxOutline(obj)
    local hl = Instance.new("Highlight")
    hl.FillColor = Color3.fromRGB(0,0,0); hl.OutlineColor = Color3.fromRGB(255,255,255)
    hl.FillTransparency = 0.8; hl.OutlineTransparency = 0
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Adornee = obj; hl.Parent = obj
    state.vaultEspElements[obj] = { highlight = hl }
end

local function createPalletESP(model)
    if state.palletEspElements[model] then return end
    if not model or not model.Parent then return end
    addHighlight(model)
    local hl = model:FindFirstChildOfClass("Highlight")
    state.palletEspElements[model] = { highlight = hl }
end

local function isPalletObj(obj)
    if not obj:IsA("Model") then return false end
    return string.lower(obj.Name) == "newpallet"
end

local function isVaultObj(obj)
    if obj.ClassName == "Part" and obj.Name == "Bottom" then
        if obj.Parent and obj.Parent.Name == "Window" then return true end
    end
    return false
end

local function clearMapEspConns()
    for _, c in ipairs(state._mapEspConns) do pcall(c.Disconnect, c) end
    table.clear(state._mapEspConns)
end

local function setupMapEspListeners(mapFolder)
    clearMapEspConns()
    local conn = mapFolder.DescendantAdded:Connect(function(obj)
        task.wait()
        if state.vaultEspEnabled and isVaultObj(obj) then createVaultESP(obj) end
        if state.palletEspEnabled and isPalletObj(obj) then createPalletESP(obj) end
    end)
    table.insert(state._mapEspConns, conn)
    local conn2 = mapFolder.DescendantRemoving:Connect(function(obj)
        if state.vaultEspElements[obj] then removeVaultESP(obj) end
        if state.palletEspElements[obj] then removePalletESP(obj) end
    end)
    table.insert(state._mapEspConns, conn2)
end

local function scanVaultAndPallet()
    local mapFolder = workspace:FindFirstChild("Map")
    if not mapFolder then return end
    setupMapEspListeners(mapFolder)
    if state.vaultEspEnabled then
        for _, obj in ipairs(mapFolder:GetDescendants()) do
            if isVaultObj(obj) then createVaultESP(obj) end
        end
    else
        for obj in pairs(state.vaultEspElements) do removeVaultESP(obj) end
    end
    if state.palletEspEnabled then
        for _, obj in ipairs(mapFolder:GetDescendants()) do
            if isPalletObj(obj) then createPalletESP(obj) end
        end
    else
        for model in pairs(state.palletEspElements) do removePalletESP(model) end
    end
end

workspace.ChildAdded:Connect(function(child)
    if child.Name == "Map" then
        task.wait(1)
        for obj in pairs(state.vaultEspElements) do removeVaultESP(obj) end
        for model in pairs(state.palletEspElements) do removePalletESP(model) end
        if state.vaultEspEnabled or state.palletEspEnabled then pcall(scanVaultAndPallet) end
    end
end)
workspace.ChildRemoved:Connect(function(child)
    if child.Name == "Map" then clearMapEspConns() end
end)
pcall(scanVaultAndPallet)

local function refreshPallets()
	local out, byParent = {}, {}
	for _, d in ipairs(Workspace:GetDescendants()) do
		local ok, nm = pcall(function() return d.Name end)
		if not ok then continue end
		if (nm == "PalletPoint" and d.ClassName == "Part") or (string.lower(nm):find("pallet") and d:IsA("BasePart")) then
			local par = d.Parent
			if par then
				local e = byParent[par]
				if not e then
					local board = par:FindFirstChild("PrimaryPartPallet") or par:FindFirstChild("Board") or d
					local boardId
					pcall(function() boardId = board:GetDebugId(0) end)
					if not boardId then boardId = tostring(board) end
					e = { board = board, pts = {}, id = boardId }
					byParent[par] = e
					out[#out + 1] = e
				end
				local p = d.Position
				if p then e.pts[#e.pts + 1] = { p.X, p.Y, p.Z } end
			end
		end
	end
	pallets = out
end

local function refreshKiller()
	local killers = {}
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= lp and isKillerPlayer(plr) then
			local ch = plr.Character
			local root = ch and ch:FindFirstChild("HumanoidRootPart")
			if root then killers[#killers + 1] = root end
		end
	end
	state.killerRoots = killers
	local me = myRoot()
	local mp = me and me.Position
	if not mp then state.pStat.killD = nil; return end
	local best
	for i = 1, #state.killerRoots do
		local kp = state.killerRoots[i].Position
		if kp then
			local dx,dy,dz = mp.X-kp.X, mp.Y-kp.Y, mp.Z-kp.Z
			local d2 = dx*dx+dy*dy+dz*dz
			if not best or d2 < best then best = d2 end
		end
	end
	state.pStat.killD = best and math.sqrt(best) or nil
end

pcall(refreshPallets); pcall(refreshKiller)
task.spawn(function() while state.running do pcall(refreshPallets); task.wait(1.5) end end)
task.spawn(function() while state.running do pcall(refreshKiller); task.wait(0.3) end end)

local function getClosestPlayerToMouse(overrideFov)
    local mousePos = UserInputService:GetMouseLocation()
    local closestPart = nil
    local shortestDistance = math.huge
    local targetPartName = state.cfg.spear_targetPart or "Head"
    local fov = overrideFov or state.cfg.silentAim_fov or 150
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= lp and not isSpectator() then
            local char = player.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                local targetPart = char:FindFirstChild(targetPartName)
                    or char:FindFirstChild("HumanoidRootPart")
                    or char:FindFirstChild("Head")
                local knocked = char:GetAttribute("Knocked")
                if hum and hum.Health > 0 and targetPart and not knocked then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                    if onScreen and screenPos.Z > 0 then
                        local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                        if distance < shortestDistance and distance <= fov then
                            shortestDistance = distance
                            closestPart = targetPart
                        end
                    end
                end
            end
        end
    end
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj:IsA("Model") then
            local ok, botId = pcall(function() return obj:GetAttribute("BotId") end)
            if ok and botId ~= nil then
                local hum = obj:FindFirstChildOfClass("Humanoid")
                local targetPart = obj:FindFirstChild(targetPartName)
                    or obj:FindFirstChild("HumanoidRootPart")
                    or obj:FindFirstChild("Head")
                local knocked = obj:GetAttribute("Knocked")
                if hum and hum.Health > 0 and targetPart and not knocked then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                    if onScreen and screenPos.Z > 0 then
                        local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                        if distance < shortestDistance and distance <= fov then
                            shortestDistance = distance
                            closestPart = targetPart
                        end
                    end
                end
            end
        end
    end
    return closestPart
end

local function getClosestToMouseAny(overrideFov)
    local mousePos = UserInputService:GetMouseLocation()
    local closestPart = nil
    local shortestDistance = math.huge
    local targetPartName = state.cfg.spear_targetPart or "Head"
    local fov = overrideFov or state.cfg.silentAim_fov or 150
    local wantKiller = state.cfg.silentAim_survivor_target == "Killer"
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= lp and not isSpectator() then
            local ok = wantKiller and isKillerPlayer(player) or (not wantKiller and not isKillerPlayer(player))
            if ok then
                local char = player.Character
                if char then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    local targetPart = char:FindFirstChild(targetPartName)
                        or char:FindFirstChild("HumanoidRootPart")
                        or char:FindFirstChild("Head")
                    local knocked = char:GetAttribute("Knocked")
                    if hum and hum.Health > 0 and targetPart and not knocked then
                        local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                        if onScreen and screenPos.Z > 0 then
                            local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                            if distance < shortestDistance and distance <= fov then
                                shortestDistance = distance
                                closestPart = targetPart
                            end
                        end
                    end
                end
            end
        end
    end
    return closestPart
end

local function getSkillCooldownState()
	local now = tick()
	if (now - state._skillCDLastCheck) < 2 then return state._skillCDCache end
	state._skillCDLastCheck = now
	local ok, result = pcall(function()
		local pg   = Players.LocalPlayer:FindFirstChild("PlayerGui")
		local sla  = pg  and pg:FindFirstChild("Slasher")
		local gen  = sla and sla:FindFirstChild("bottom left")
		local mv2  = gen and gen:FindFirstChild("Move2")
		local bar  = mv2 and mv2:FindFirstChild("Bar")
		local grad = bar and bar:FindFirstChild("UIGradient")
		if not grad then return false end
		return grad.Offset.Y == 0
	end)
	state._skillCDCache = ok and result
	return state._skillCDCache
end

local function calculateSpearAim(origin, targetPos, targetVel, overrideSpeed)
    if typeof(overrideSpeed) ~= "number" then overrideSpeed = nil end
    local cdReady = (type(getSkillCooldownState) == "function" and getSkillCooldownState()) or false
    local speed = overrideSpeed or (cdReady and SPEAR_SPEED_READY or SPEAR_SPEED_CD)
    local g = cdReady and SPEAR_GRAV_READY or SPEAR_GRAV_CD
    local adjustedTargetPos = targetPos + Vector3.new(0, AIM_HEIGHT_OFFSET, 0)
    local diff = adjustedTargetPos - origin
    local dist = diff.Magnitude
    if dist < 0.1 then return adjustedTargetPos end
    local t = dist / math.max(speed, 1)
    for _ = 1, 3 do
        local dropEst = 0.5 * g * (t * t)
        local aimPos = Vector3.new(adjustedTargetPos.X, adjustedTargetPos.Y + dropEst, adjustedTargetPos.Z)
        t = (aimPos - origin).Magnitude / math.max(speed, 1)
    end
    local drop = 0.5 * g * (t * t)
    return Vector3.new(adjustedTargetPos.X, adjustedTargetPos.Y + drop, adjustedTargetPos.Z)
end

local function getSpearTarget()
	local me = myRoot()
	if not me then return nil, nil, nil end
	local cam = workspace.CurrentCamera
	if not cam then return nil, nil, nil end
	local mousePos = UserInputService:GetMouseLocation()
	local best, bestChar, minDist = nil, nil, math.huge
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= lp and plr.Character then
			local char = plr.Character
			local root = char:FindFirstChild("HumanoidRootPart")
			local hum  = char:FindFirstChildOfClass("Humanoid")
			local knocked = char:GetAttribute("Knocked")
			if root and hum and hum.Health > 0 and not knocked then
				if not isKillerPlayer(plr) and not isSpectator() then
					local screenPos, onScreen = cam:WorldToViewportPoint(root.Position)
					if onScreen and screenPos.Z > 0 then
						local dx = screenPos.X - mousePos.X
						local dy = screenPos.Y - mousePos.Y
						local screenDist = math.sqrt(dx*dx + dy*dy)
						if screenDist < minDist then
							minDist  = screenDist
							best     = root
							bestChar = char
						end
					end
				end
			end
		end
	end
	return best, "survivor", bestChar
end

local function doRightClick()
    pcall(function()
        if typeof(mouse2click) == "function" then mouse2click(); return end
        if typeof(mouse2press) == "function" and typeof(mouse2release) == "function" then
            mouse2press(); mouse2release(); return
        end
        VirtualInputManager:SendMouseButtonEvent(0, 0, 1, true, game, 0)
        VirtualInputManager:SendMouseButtonEvent(0, 0, 1, false, game, 0)
    end)
end

local function hasParryingDagger()
    local charModel = workspace:FindFirstChild(lp.Name)
    if not charModel then return false end
    for _, obj in ipairs(charModel:GetChildren()) do
        if obj.Name == "Parrying Dagger" and obj:IsA("Model") then return true end
    end
    return false
end

local function getFacingAngleToMe(kRoot)
    local myChar = lp.Character
    local myRoot2 = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot2 or not kRoot then return nil end
    local ok, angle = pcall(function()
        local dot = kRoot.CFrame.LookVector:Dot(
            (myRoot2.Position - kRoot.Position).Unit
        )
        return math.deg(math.acos(math.clamp(dot, -1, 1)))
    end)
    return ok and angle or nil
end

local function killerFacingMe(kRoot)
    if not state.cfg.ap_dirCheck_enabled then return true end
    local angle = getFacingAngleToMe(kRoot)
    if angle == nil then return true end
    return angle <= (state.cfg.ap_facingAngle or 120)
end

local function parry(reason, extraDelay, kRoot)
    if not state.cfg.ap_enabled then return end
    if not isSurvivor() then return end
    if kRoot and not killerFacingMe(kRoot) then return end
    if not hasParryingDagger() then return end
    local now = tick()
    if (now - state.lastParryTime) < (state.cfg.ap_cooldown or PARRY_COOLDOWN) then return end
    state.lastParryTime = now
    if state.cfg.ap_legitMode then
        task.spawn(function()
            local mn = state.cfg.ap_legitMinDelay or 0.05
            local mx = state.cfg.ap_legitMaxDelay or 0.15
            local delay = mn + math.random() * (mx - mn)
            if delay > 0 then task.wait(delay) end
            doRightClick()
        end)
    else
        doRightClick()
    end
end

local function pushPending(kRoot, trackName, score, animLen)
    for _, sw in ipairs(state.pendingSwings) do
        if sw.killerRoot == kRoot and not sw.fired then
            sw.deadline = math.max(sw.deadline, tick() + animLen)
            return
        end
    end
    state.pendingSwings[#state.pendingSwings + 1] = {
        killerRoot = kRoot, trackName = trackName, score = score,
        deadline = tick() + animLen, fired = false,
    }
end

local function onKillerAnimPlayed(track, kRoot)
    if not state.cfg.ap_enabled then return end
    if not isSurvivor() then return end
    local animId = getAnimAssetId(track)
    if not animId or not HIT_ANIM_IDS[animId] then return end
    local me = myRoot()
    if not me then return end
    if not (kRoot and kRoot.Parent) then return end
    if not killerFacingMe(kRoot) then return end
    local dist = (me.Position - kRoot.Position).Magnitude
    local animR = state.cfg.ap_animRadius or 12
    if dist <= animR then
        parry("Anim:"..track.Name..string.format("(%.1f)", dist), 0, kRoot)
    else
        local pendR = state.cfg.ap_pendingRadius or 22
        if dist <= pendR then
            local animLen = math.min(
                (track.Length and track.Length > 0) and track.Length or 2.0, 2.5
            )
            pushPending(kRoot, track.Name, 100, animLen)
        end
    end
end

local function attachAnimListener(kRoot)
    local char = kRoot and kRoot.Parent
    if not char or state.monitoredKillers[char] then return end
    state.monitoredKillers[char] = true
    state.killerAnimConns[char] = {}
    local attached = false
    local function doAttach()
        if attached then return end
        local anim = findAnimator(char)
        if not anim then return end
        attached = true
        local conn = anim.AnimationPlayed:Connect(function(track)
            onKillerAnimPlayed(track, kRoot)
        end)
        state.killerAnimConns[char][#state.killerAnimConns[char]+1] = conn
    end
    doAttach()
    if not attached then
        local c2 = char.DescendantAdded:Connect(function(obj)
            if obj:IsA("Animator") then task.wait(0.05); doAttach() end
        end)
        state.killerAnimConns[char][#state.killerAnimConns[char]+1] = c2
    end
    char.AncestryChanged:Connect(function()
        if char.Parent then return end
        for _, c in ipairs(state.killerAnimConns[char] or {}) do pcall(c.Disconnect, c) end
        state.killerAnimConns[char] = nil
        state.monitoredKillers[char] = nil
    end)
end

local function startFlashlightAim()
    if state.flashlightAimConn then return end
    state.flashlightAimConn = RunService.RenderStepped:Connect(function(dt)
        if not state.flashlightAimEnabled then return end
        if not isSurvivor() then return end
        local ch = lp.Character
        if not ch then return end
        local hasFlashlight = ch:FindFirstChild("Flashlight")
        if not hasFlashlight then
            if not state._flashlightNotified then
                state._flashlightNotified = true
                OasisUI:Notify({ Title = "Flashlight Aimbot", Content = "No Flashlight found in your inventory!", Duration = 5 })
            end
            return
        end
        state._flashlightNotified = false
        if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then return end
        local cam = workspace.CurrentCamera
        if not cam then return end
        local me = myRoot()
        if not me then return end
        local bestRoot = nil
        local bestDist = math.huge
        local maxDist  = state.cfg.flashlightAim_maxDist or 30
        for _, kRoot in ipairs(state.killerRoots) do
            if kRoot and kRoot.Parent then
                local d = (me.Position - kRoot.Position).Magnitude
                if d < bestDist and d <= maxDist then
                    bestDist = d; bestRoot = kRoot
                end
            end
        end
        if not bestRoot then return end
        local killerChar = bestRoot.Parent
        local head = killerChar and killerChar:FindFirstChild("Head")
        local aimTarget = (head or bestRoot).Position
        local camCF = cam.CFrame
        local targetCF = CFrame.lookAt(camCF.Position, aimTarget)
        cam.CFrame = camCF:Lerp(targetCF, math.min(dt * 25, 1))
    end)
end

local function stopFlashlightAim()
	if state.flashlightAimConn then
		state.flashlightAimConn:Disconnect()
		state.flashlightAimConn = nil
	end
end

startFlashlightAim()

local function createMeESP()
    local char = lp.Character
    if not char then return end
    if state.render.meHighlight then
        pcall(function() state.render.meHighlight:Destroy() end)
        state.render.meHighlight = nil
    end

    local hl = Instance.new("Highlight")
    hl.Name                = "KKKkhub_Me_Highlight"
    hl.FillColor           = Color3.fromRGB(0, 150, 255)
    hl.OutlineColor        = Color3.fromRGB(0, 200, 255)
    hl.FillTransparency    = 1
    hl.OutlineTransparency = 0
    hl.DepthMode           = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Adornee             = char
    hl.Parent              = char
    state.render.meHighlight = hl
end

local function removeMeESP()
    if state.render.meHighlight then
        pcall(function() state.render.meHighlight:Destroy() end)
        state.render.meHighlight = nil
    end
end

local function makePFAgentParams()
	local hum  = character:FindFirstChildOfClass("Humanoid")
	local root = character:FindFirstChild("HumanoidRootPart")
	if not hum or not root then
		return { AgentHeight = 5, AgentRadius = 2, AgentCanJump = false, AgentCanClimb = false, WaypointSpacing = 2 }
	end
	return {
		AgentHeight    = math.max(2, hum.HipHeight + root.Size.Y) + 0.5,
		AgentRadius    = 2, AgentCanJump = false, AgentCanClimb = false, WaypointSpacing = 2,
	}
end

local function pfClearDots()
	for _, v in ipairs(pfDotFolder:GetChildren()) do v:Destroy() end
end

local function pfCreateDot(position, index, isLast)
	local dot = Instance.new("Part")
	dot.Name = "Dot_" .. index; dot.Size = Vector3.new(0.4, 0.4, 0.4)
	dot.Shape = Enum.PartType.Ball; dot.Material = Enum.Material.Neon
	dot.Anchored = true; dot.CanCollide = false; dot.CastShadow = false
	dot.Position = position + Vector3.new(0, 0.5, 0)
	dot.Color = isLast and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(0, 200, 100)
	local bb = Instance.new("BillboardGui")
	bb.Size = UDim2.new(0, 30, 0, 20); bb.StudsOffset = Vector3.new(0, 0.8, 0)
	bb.AlwaysOnTop = true; bb.Parent = dot
	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.fromScale(1, 1); lbl.BackgroundTransparency = 1
	lbl.Text = tostring(index); lbl.TextColor3 = Color3.new(1, 1, 1)
	lbl.TextScaled = true; lbl.Font = Enum.Font.GothamBold; lbl.Parent = bb
	dot.Parent = pfDotFolder
end

local function pfHighlightDot(index)
	local dot = pfDotFolder:FindFirstChild("Dot_" .. index)
	if dot then dot.Color = Color3.fromRGB(255, 220, 0); dot.Size = Vector3.new(0.7, 0.7, 0.7) end
end

local function pfRemoveDot(index)
	local dot = pfDotFolder:FindFirstChild("Dot_" .. index)
	if dot then dot:Destroy() end
end

local function pfSnapToGround(pos, excludeModel)
	local rayParams = RaycastParams.new()
	rayParams.FilterType = Enum.RaycastFilterType.Exclude
	rayParams.FilterDescendantsInstances = { character, pfDotFolder, excludeModel }
	local origin = pos + Vector3.new(0, 6, 0)
	local result = workspace:Raycast(origin, Vector3.new(0, -30, 0), rayParams)
	if result then return result.Position + Vector3.new(0, 1.5, 0) end
	return pos
end

local function pfGetPumpkins()
	local list = {}
	local mapFolder = workspace:FindFirstChild("Map")
	if not mapFolder then return list end
	local pumpkins = mapFolder:FindFirstChild("Pumpkins")
	if not pumpkins then return list end
	for _, obj in ipairs(pumpkins:GetChildren()) do
		if obj:IsA("Model") then
			local hb = obj:FindFirstChild("HB")
			if hb and hb:IsA("BasePart") then
				local existing = obj:FindFirstChild("_PF_Target")
				local target = existing
				if not target then
					target = Instance.new("Part")
					target.Name = "_PF_Target"; target.Size = Vector3.new(1,1,1)
					target.Anchored = true; target.CanCollide = false
					target.Transparency = 1; target.Position = hb.Position + Vector3.new(0,3,0)
					target.Parent = obj
				end
				list[#list + 1] = { model = obj, hb = hb, target = target, manualTarget = existing ~= nil }
			end
		end
	end
	table.sort(list, function(a, b)
		local root = character:FindFirstChild("HumanoidRootPart")
		if not root then return false end
		return (root.Position - a.hb.Position).Magnitude < (root.Position - b.hb.Position).Magnitude
	end)
	return list
end

local function pfBuildTargetPos(pumpkin, attempt)
	local a = PF_ATTEMPT_ANGLES[((attempt - 1) % #PF_ATTEMPT_ANGLES) + 1]
	local root = character:FindFirstChild("HumanoidRootPart")
	local basePos
	if pumpkin.manualTarget then
		basePos = pumpkin.target.Position
	else
		local dir = root and (root.Position - pumpkin.hb.Position) or Vector3.new(1, 0, 0)
		dir = Vector3.new(dir.X, 0, dir.Z)
		if dir.Magnitude > 0 then dir = dir.Unit end
		local offset = 4 + math.max(pumpkin.hb.Size.X, pumpkin.hb.Size.Z) * 0.5
		basePos = pumpkin.hb.Position + (dir * offset)
	end
	if a ~= 0 then
		local rel = basePos - pumpkin.hb.Position
		local rot = CFrame.fromAxisAngle(Vector3.yAxis, a)
		basePos = pumpkin.hb.Position + rot:VectorToWorldSpace(rel)
	end
	return pfSnapToGround(basePos, pumpkin.model)
end

local function pfStartStuck()
	state.pfStuckGen += 1
	state.pfStuckSignal = false
	local gen = state.pfStuckGen
	task.spawn(function()
		local root    = character:FindFirstChild("HumanoidRootPart")
		local lastPos = root and root.Position or Vector3.zero
		while gen == state.pfStuckGen do
			task.wait(PF_STUCK_TIMEOUT)
			if gen ~= state.pfStuckGen then return end
			root = character:FindFirstChild("HumanoidRootPart")
			if not root then return end
			local moved = (root.Position - lastPos).Magnitude
			if moved < PF_STUCK_THRESHOLD then
				if gen == state.pfStuckGen then
					state.pfStuckSignal = true
				end
				return
			end
			lastPos = root.Position
		end
	end)
end

local function pfStopStuck()
	state.pfStuckGen += 1
	state.pfStuckSignal = false
end

local function pfComputePath(startPos, targetPos)
	local path = PathfindingService:CreatePath(makePFAgentParams())
	local ok = pcall(function() path:ComputeAsync(startPos, targetPos) end)
	if ok and path.Status == Enum.PathStatus.Success then return path end
	return nil
end

local function pfFollowWaypoints(path)
	local hum  = character:FindFirstChildOfClass("Humanoid")
	local root = character:FindFirstChild("HumanoidRootPart")
	if not hum or not root then return false end
	local waypoints = path:GetWaypoints()
	pfClearDots()
	for i, wp in ipairs(waypoints) do pfCreateDot(wp.Position, i, i == #waypoints) end
	local blocked = false
	local blockedConn = path.Blocked:Connect(function() blocked = true end)
	pfStartStuck()
	for i, wp in ipairs(waypoints) do
		if state.pfStuckSignal or blocked then
			blockedConn:Disconnect(); pfStopStuck(); pfClearDots()
			task.wait(0.1); return false
		end
		if wp.Action == Enum.PathWaypointAction.Jump then continue end
		pfHighlightDot(i)
		hum:MoveTo(wp.Position)
		hum.MoveToFinished:Wait()
		pfRemoveDot(i)
	end
	blockedConn:Disconnect(); pfStopStuck(); pfClearDots()
	return true
end

local function pfGoToPoint(pumpkin)
	local root = character:FindFirstChild("HumanoidRootPart")
	if not root then return true end
	for attempt = 1, #PF_ATTEMPT_ANGLES do
		if not state.cfg.autoPumpkin_enabled then return false end
		local targetPos = pfBuildTargetPos(pumpkin, attempt)
		local dist = (root.Position - targetPos).Magnitude
		if dist <= 4 then return true end
		local path = pfComputePath(root.Position, targetPos)
		if path then
			local done = pfFollowWaypoints(path)
			if done then return true end
		end
		task.wait(0.2)
	end
	local hum = character:FindFirstChildOfClass("Humanoid")
	if hum then hum:MoveTo(pumpkin.hb.Position); hum.MoveToFinished:Wait() end
	return true
end

local function pfCrushPumpkin(hb)
	local ok, crushEvent = pcall(function()
		return ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Events")
			:WaitForChild("Halloween"):WaitForChild("Crush")
	end)
	if ok and crushEvent then
		pcall(function() crushEvent:FireServer(hb) end)
	end
end

local function pfStop()
	state.pfRunning = false
	state.cfg.autoPumpkin_enabled = false
	state.pfToggleState = false
	pfStopStuck()
	pfClearDots()
	local hum = character:FindFirstChildOfClass("Humanoid")
	if hum then
		local root = character:FindFirstChild("HumanoidRootPart")
		if root then hum:MoveTo(root.Position) end
	end
end

local function pfRun()
	character = lp.Character or lp.CharacterAdded:Wait()
	_humanoid  = character:WaitForChild("Humanoid")
	_rootPart  = character:WaitForChild("HumanoidRootPart")
	task.wait(0.5)
	while state.pfRunning and state.cfg.autoPumpkin_enabled do
		if not isSurvivor() then
			state.pfRunning = false
			state.cfg.autoPumpkin_enabled = false
			state.pfToggleState = false
			pfStopStuck(); pfClearDots()
			OasisUI:Notify({ Title = "Auto Pumpkin", Content = "Stopped: Not a Survivor", Duration = 4 })
			break
		end
		local pumpkins = pfGetPumpkins()
		if #pumpkins == 0 then task.wait(2); continue end
		for idx, pumpkin in ipairs(pumpkins) do
			if not state.pfRunning or not state.cfg.autoPumpkin_enabled then break end
			if not pumpkin.model.Parent then continue end
			local root = character:FindFirstChild("HumanoidRootPart")
			if not root then break end
			local attempts = 0
			while state.pfRunning do
				attempts += 1
				local done = pfGoToPoint(pumpkin)
				if done then pfCrushPumpkin(pumpkin.hb); task.wait(state.cfg.autoPumpkin_delay or 0.3); break end
				if attempts >= 10 then break end
				task.wait(0.3)
			end
			task.wait(0.2)
		end
		task.wait(1)
	end
	state.pfRunning = false
	pfClearDots()
end

local function makeLabel(color, bold)
    local lbl = Drawing.new("Text")
    lbl.Visible = false; lbl.Text = ""; lbl.Size = 16
    lbl.Font = Drawing.Fonts.Plex; lbl.Color = color
    lbl.Outline = true
    return lbl
end

local function breakGen(point)
    pcall(function()
        local BreakEvent  = game:GetService("ReplicatedStorage").Remotes.Generator.BreakGenEvent
        local CommitEvent = game:GetService("ReplicatedStorage").Remotes.Generator.BreakGenCommit
        BreakEvent:FireServer(point); task.wait(0.1); CommitEvent:FireServer(point)
    end)
end

local function getGenPoints(genModel)
    local points = {}
    for _, obj in ipairs(genModel:GetDescendants()) do
        if obj.Name:find("GeneratorPoint") and obj:IsA("BasePart") then
            points[#points + 1] = obj
        end
    end
    return points
end

local function isPointOccupied(point)
    for _, plr in ipairs(Players:GetPlayers()) do
        local char = plr.Character
        if char then
            local root = char:FindFirstChild("HumanoidRootPart")
            if root then
                local ok, dist = pcall(function() return (root.Position - point.Position).Magnitude end)
                if ok and dist <= 5 then return true end
            end
        end
    end
    return false
end

local function checkKillerApproach(kRoot, palPos, maxReach)
	local ok, kPos = pcall(function() return kRoot.Position end)
	if not ok or not kPos then return false, false end
	local dx,dy,dz = palPos.X-kPos.X, palPos.Y-kPos.Y, palPos.Z-kPos.Z
	local dist = math.sqrt(dx*dx+dy*dy+dz*dz)
	if dist > maxReach then return false, false end
	if state.cfg.antiBait then
		local dirX = dx / (dist > 0.001 and dist or 1)
		local dirZ = dz / (dist > 0.001 and dist or 1)
		local ok2, kVel = pcall(function() return kRoot.AssemblyLinearVelocity or kRoot.Velocity end)
		if not ok2 or not kVel then return true, true end
		local speed = math.sqrt(kVel.X*kVel.X + kVel.Z*kVel.Z)
		if speed < 1 then return true, true end
		if (kVel.X*dirX + kVel.Z*dirZ) < -2.5 then return true, false end
	end
	return true, true
end

local function readSkillRots(Line, Goal)
	local lr, gr
	pcall(function() lr = Line.Rotation; gr = Goal.Rotation end)
	if not lr or not gr then
		pcall(function()
			lr = Line:GetAttribute("Rotation") or Line:GetAttribute("Value")
			gr = Goal:GetAttribute("Rotation") or Goal:GetAttribute("Value")
		end)
	end
	if not lr or not gr then return nil, nil end
	lr = lr < 0 and (lr % 360) or lr
	gr = gr < 0 and (gr % 360) or gr
	return lr, gr
end

-- Instant Skillcheck
local _instantFired       = false
local _instantSnapPending = false

local function startInstantSC()
    if _G.skillconn then _G.skillconn:Disconnect() end
    _instantFired       = false
    _instantSnapPending = false

    local OFFSET_GOAL         = state.cfg.sc_instant_offset  or 110
    local OFFSET_TRAP_PERFECT = state.cfg.sc_trap_offset      or 110
    local OFFSET_TRAP_GOAL    = state.cfg.sc_trapgoal_offset  or 105

    _G.skillconn = RunService.RenderStepped:Connect(function()
        OFFSET_GOAL         = state.cfg.sc_instant_offset  or 110
        OFFSET_TRAP_PERFECT = state.cfg.sc_trap_offset      or 110
        OFFSET_TRAP_GOAL    = state.cfg.sc_trapgoal_offset  or 105

        if not (state.running and state.cfg.sc_enabled and state.cfg.sc_mode == "Instant") then
            _instantFired = false
            _instantSnapPending = false
            return
        end

        pcall(function()
            local pg  = lp:FindFirstChild("PlayerGui")
            local scr = pg  and pg:FindFirstChild("SkillCheckPromptGui")
            local chk = scr and scr:FindFirstChild("Check")

            if not chk or not chk.Visible then
                _instantFired = false
                _instantSnapPending = false
                return
            end

            local Line        = chk:FindFirstChild("Line")
            local Goal        = chk:FindFirstChild("Goal")
            local TrapPerfect = chk:FindFirstChild("TrapPerfect")
            local TrapGoal    = chk:FindFirstChild("TrapGoal")
            if not Line then return end

            local targetRotation
            if TrapPerfect and TrapPerfect.Visible then
                targetRotation = TrapPerfect.Rotation + OFFSET_TRAP_PERFECT
            elseif TrapGoal and TrapGoal.Visible then
                targetRotation = TrapGoal.Rotation + OFFSET_TRAP_GOAL
            elseif Goal and Goal.Visible then
                targetRotation = Goal.Rotation + OFFSET_GOAL
            end
            if not targetRotation then return end

            TweenService:Create(Line, TweenInfo.new(0), { Rotation = targetRotation }):Play()

            if not _instantFired and not _instantSnapPending then
                _instantSnapPending = true
                task.spawn(function()
                    RunService.RenderStepped:Wait()
                    RunService.RenderStepped:Wait()
                    if chk and chk.Parent and chk.Visible then
                        if state.cfg.sc_pressKey then
                            pressKey(Enum.KeyCode.Space, state.cfg.sc_key)
                        end
                    end
                    _instantFired = true
                    _instantSnapPending = false
                end)
            end
        end)
    end)
end

local function stopInstantSC()
    _instantFired = false
    _instantSnapPending = false
    if _G.skillconn then
        _G.skillconn:Disconnect()
        _G.skillconn = nil
    end
end

task.spawn(function()
	while state.running do
		task.wait(1.0)
		pcall(function()
			local team = lp.Team
			local teamName = team and string.lower(tostring(team.Name or "")) or ""
			if teamName:find("spectator") or teamName:find("spec") or teamName:find("lobby") then
				if next(state.droppedPallets) ~= nil then state.droppedPallets = {} end
			end
			if state.lastTeamName ~= teamName then state.droppedPallets = {}; state.lastTeamName = teamName end
		end)
	end
end)

task.spawn(function()
	while state.running do
		pcall(function()
			if state.cfg.godmode_enabled then
				local ch = lp.Character
				local hum = ch and ch:FindFirstChildOfClass("Humanoid")
				if hum and hum.Health > 0 and hum.Health < hum.MaxHealth then
					hum.Health = hum.MaxHealth
				end
			end
		end)
		task.wait(0.1)
	end
end)

task.spawn(function()
	while state.running do
		pcall(speedModTick)
		task.wait(0.2)
	end
end)

lp.CharacterAdded:Connect(function()
	table.clear(_speedModLastApplied)
	task.delay(1.0, function()
		if state.cfg.speedMod_enabled then
			pcall(speedModTick)
		end
	end)
end)

lp:GetPropertyChangedSignal("Team"):Connect(function()
	table.clear(_speedModLastApplied)
	if state.cfg.speedMod_enabled then
		task.defer(speedModTick)
	end
end)

task.spawn(function()
	while state.running do
		if state.cfg.sc_speed_enabled and isSurvivor() then
			pcall(function()
				local charModel = workspace:FindFirstChild(lp.Name)
				if charModel then charModel:SetAttribute("skillcheckspeed", state.cfg.sc_speed_value) end
			end)
		end
		task.wait(0.2)
	end
end)

task.spawn(function()
	while state.running do
		if state.cfg.swiftspeed_enabled and not isSurvivor() then
			pcall(function()
				local charModel = workspace:FindFirstChild(lp.Name)
				if charModel then charModel:SetAttribute("swift", state.cfg.swiftspeed_value) end
			end)
		end
		task.wait(0.2)
	end
end)

task.spawn(function()
	while state.running do
		pcall(function()
			if state.cfg.breakSpeed_enabled then
				local charModel = workspace:FindFirstChild(lp.Name)
				if charModel then
					if charModel:GetAttribute("breakspeed") ~= state.cfg.breakSpeed_value then
						charModel:SetAttribute("breakspeed", state.cfg.breakSpeed_value)
					end
				end
			end
		end)
		task.wait(0.2)
	end
end)

task.spawn(function()
	while state.running do
		if state.cfg.ap_enabled and isSurvivor() then
			local me    = myRoot()
			local now   = tick()
			local animR = state.cfg.ap_animRadius or 12
			local remaining = {}
			for _, sw in ipairs(state.pendingSwings) do
				if sw.fired or now > sw.deadline then
				elseif not (sw.killerRoot and sw.killerRoot.Parent) then
				elseif not me then
					remaining[#remaining+1] = sw
				else
					local ok, dist = pcall(function()
						return (me.Position - sw.killerRoot.Position).Magnitude
					end)
					if ok then
						if dist <= animR then
							sw.fired = true
							parry("PendingAnim:"..sw.trackName..string.format("(%.1f)", dist), 0, sw.killerRoot)
						else
							remaining[#remaining+1] = sw
						end
					else
						remaining[#remaining+1] = sw
					end
				end
			end
			state.pendingSwings = remaining
			for _, kRoot in ipairs(state.killerRoots) do
				attachAnimListener(kRoot)
			end
		end
		task.wait(0.02)
	end
end)

task.spawn(function()
    while state.running do
        if state.cfg.autoCrouch_enabled and isSurvivor() then
            pcall(function()
                local now = tick()
                local cooldown = (state.cfg.autoCrouch_duration or 1.5) + 3.0
                if now - state._lastCrouchTime < cooldown then return end
                for _, plr in ipairs(Players:GetPlayers()) do
                    if isKillerPlayer(plr) then
                        local char = plr.Character
                        if not char then continue end
                        local anim = findAnimator(char)
                        if not anim then continue end
                        for _, track in ipairs(anim:GetPlayingAnimationTracks()) do
                            local animId = getAnimAssetId(track)
                            if animId == ABYSSWALKER_SKILL_ID and track.TimePosition < 0.2 then
                                local me = myRoot()
                                if not me then break end
                                local kRoot = char:FindFirstChild("HumanoidRootPart")
                                if not kRoot then break end
                                local dist = (me.Position - kRoot.Position).Magnitude
                                if dist <= state.cfg.autoCrouch_distance then
                                    state._lastCrouchTime = now
                                    local delay = state.cfg.autoCrouch_delay or 0
                                    if state.cfg.autoCrouch_humanize then delay = delay + math.random() * 0.08 end
                                    task.spawn(function()
                                        if delay > 0 then task.wait(delay) end
                                        pcall(function() VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.LeftControl, false, game) end)
                                        pcall(function() VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.C, false, game) end)
                                        pcall(function() keypress(0x11) end)
                                        pcall(function() keypress(0x43) end)
                                        task.wait(state.cfg.autoCrouch_duration or 1.5)
                                        pcall(function() VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.LeftControl, false, game) end)
                                        pcall(function() VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.C, false, game) end)
                                        pcall(function() keyrelease(0x11) end)
                                        pcall(function() keyrelease(0x43) end)
                                    end)
                                end
                                break
                            end
                        end
                    end
                end
            end)
        end
        task.wait(0.05)
    end
end)

task.spawn(function()
	while state.running do
		if state.cfg.scp_esp_enabled then pcall(scanSCPs)
		else for model in pairs(state.scpEspElements or {}) do removeSCPESP(model) end end
		task.wait(1.0)
	end
end)

task.spawn(function()
	while state.running do
		pcall(function()
			for _, plr in ipairs(Players:GetPlayers()) do
				if plr ~= lp and not isKillerPlayer(plr) then
					if not state.monitoredPlayerAnimators[plr] then
						state.monitoredPlayerAnimators[plr] = true
						local function tryAttach(char)
							if not char then return end
							local anim = findAnimator(char)
							if not anim then return end
						end
						pcall(tryAttach, plr.Character)
						plr.CharacterAdded:Connect(function(char)
							task.wait(0.3); pcall(tryAttach, char)
							state.playerParryState[plr] = nil
						end)
					end
				end
			end
		end)
		task.wait(2.0)
	end
end)

task.spawn(function()
    while state.running do
        task.wait(2)
        pcall(function()
            if state._fullbrightEnabled then applyFullBright() end
            if state._nofogEnabled then applyNoFog() end
        end)
    end
end)

task.spawn(function()
    while state.running do
        if state.genEspEnabled then
            for model in pairs(state.genEspElements) do
                if model.Parent then
                    local repair = model:GetAttribute("RepairProgress") or 0
                    local pct    = math.clamp(repair, 0, 100)
                    local prevPct = state._genPrevProgress[model]
                    if prevPct ~= nil then state._genIsBreaking[model] = pct < prevPct
                    else state._genIsBreaking[model] = false end
                    state._genPrevProgress[model] = pct
                else
                    state._genPrevProgress[model] = nil
                    state._genIsBreaking[model] = nil
                end
            end
        end
        task.wait(0.1)
    end
end)

task.spawn(function()
    local cam = workspace.CurrentCamera
    while state.running do
        if state.genEspEnabled then
            pcall(initialScanGen)
            pcall(function()
                cam = workspace.CurrentCamera
                for model, elem in pairs(state.genEspElements) do
                    if not model.Parent then
                        removeGenESP(model)
                        state._genPrevProgress[model] = nil
                        state._genIsBreaking[model] = nil
                    else
                        local repair    = model:GetAttribute("RepairProgress") or 0
                        local repairing = model:GetAttribute("PlayersRepairingCount") or 0
                        local paused    = model:GetAttribute("ProgressPaused")
                        local pct       = math.clamp(repair, 0, 100)
                        local displayPct = math.floor(pct)
                        local isBreaking = state._genIsBreaking[model] or false
                        if pct >= 100 then
                            elem.nameText.Visible = false; elem.infoText.Visible = false
                            elem.barBg.Visible = false; elem.barFill.Visible = false
                            if elem.highlight then elem.highlight.Enabled = false end
                        else
                            local rootPos = elem.rootPart.Position + Vector3.new(0, 3, 0)
                            local screenPos, onScreen = cam:WorldToViewportPoint(rootPos)
                            if not onScreen or screenPos.Z < 0 then
                                elem.nameText.Visible = false; elem.infoText.Visible = false
                                elem.barBg.Visible = false; elem.barFill.Visible = false
                            else
                                local sx = screenPos.X; local sy = screenPos.Y
                                local barW = 50; local barH = 3
                                elem.barBg.Visible = true; elem.barBg.Size = Vector2.new(barW, barH)
                                elem.barBg.Position = Vector2.new(sx - barW/2, sy)
                                local fillW = math.max(1, math.floor(barW * (pct / 100)))
                                elem.barFill.Visible = true; elem.barFill.Size = Vector2.new(fillW, barH)
                                elem.barFill.Position = Vector2.new(sx - barW/2, sy)
                                elem.nameText.Visible = true; elem.nameText.Position = Vector2.new(sx, sy - 16)
                                elem.infoText.Visible = true; elem.infoText.Position = Vector2.new(sx, sy + barH + 2)
                                if repairing > 0 and paused then
                                    elem.barFill.Color = Color3.fromRGB(120,120,120)
                                    elem.nameText.Color = Color3.fromRGB(255,255,255)
                                    elem.infoText.Text = displayPct .. "% | " .. repairing .. "P repairing | paused"
                                elseif repairing > 0 then
                                    elem.barFill.Color = Color3.fromRGB(180,180,180)
                                    elem.nameText.Color = Color3.fromRGB(255,255,255)
                                    elem.infoText.Text = displayPct .. "% | " .. repairing .. " Players repairing"
                                elseif isBreaking and paused then
                                    elem.barFill.Color = Color3.fromRGB(200,40,40)
                                    elem.nameText.Color = Color3.fromRGB(255,80,80)
                                    elem.infoText.Text = displayPct .. "% | breaking | paused"
                                elseif isBreaking then
                                    elem.barFill.Color = Color3.fromRGB(255,60,60)
                                    elem.nameText.Color = Color3.fromRGB(255,80,80)
                                    elem.infoText.Text = displayPct .. "% | breaking"
                                elseif paused then
                                    elem.barFill.Color = Color3.fromRGB(80,80,80)
                                    elem.nameText.Color = Color3.fromRGB(200,200,200)
                                    elem.infoText.Text = displayPct .. "% | idle | paused"
                                else
                                    elem.barFill.Color = Color3.fromRGB(255,255,255)
                                    elem.nameText.Color = Color3.fromRGB(200,200,200)
                                    elem.infoText.Text = displayPct .. "% | idle"
                                end
                                if elem.highlight then elem.highlight.Enabled = true end
                            end
                        end
                    end
                end
            end)
        else
            for model, elem in pairs(state.genEspElements) do
                pcall(function()
                    elem.nameText.Visible = false; elem.infoText.Visible = false
                    elem.barBg.Visible = false; elem.barFill.Visible = false
                end)
                removeGenESP(model)
                state._genPrevProgress[model] = nil
                state._genIsBreaking[model] = nil
            end
        end
        task.wait(0.01)
    end
end)

task.spawn(function()
    local cam = workspace.CurrentCamera
    while state.running do
        if state.bearTrapEspEnabled then
            pcall(initialScanBearTrap)
            pcall(function()
                cam = workspace.CurrentCamera
                local me = myRoot()
                local myPos = me and me.Position
                for model, elem in pairs(state.bearTrapEspElements) do
                    if not model.Parent then removeBearTrapESP(model); continue end
                    local armed = model:GetAttribute("Armed")
                    if not armed then
                        elem.nameText.Visible = false; elem.distText.Visible = false
                        elem.barBg.Visible = false
                        if elem.highlight then elem.highlight.Enabled = false end
                        continue
                    end
                    local rootPos = elem.rootPart.Position + Vector3.new(0, 1.5, 0)
                    local screenPos, onScreen = cam:WorldToViewportPoint(rootPos)
                    if not onScreen or screenPos.Z < 0 then
                        elem.nameText.Visible = false; elem.distText.Visible = false
                        elem.barBg.Visible = false
                        if elem.highlight then elem.highlight.Enabled = false end
                        continue
                    end
                    local sx = screenPos.X; local sy = screenPos.Y
                    local dist = myPos and (myPos - elem.rootPart.Position).Magnitude or 0
                    local barW = 50; local barH = 3
                    elem.barBg.Visible = true; elem.barBg.Size = Vector2.new(barW, barH)
                    elem.barBg.Position = Vector2.new(sx - barW/2, sy)
                    elem.nameText.Visible = true; elem.nameText.Position = Vector2.new(sx, sy - 16)
                    elem.nameText.Color = Color3.fromRGB(255,80,80)
                    elem.distText.Visible = true; elem.distText.Text = string.format("%.0f studs", dist)
                    elem.distText.Position = Vector2.new(sx, sy + barH + 2)
                    if elem.highlight then elem.highlight.Enabled = true end
                end
            end)
        else
            for model, elem in pairs(state.bearTrapEspElements) do
                pcall(function()
                    elem.nameText.Visible = false; elem.distText.Visible = false; elem.barBg.Visible = false
                end)
                removeBearTrapESP(model)
            end
        end
        task.wait(0.01)
    end
end)

task.spawn(function()
    while state.running do
        if state.pumpkinEspEnabled then
            pcall(scanPumpkins)
            for model, elem in pairs(state.pumpkinEspElements) do
                if not model.Parent then removePumpkinESP(model)
                else if elem.highlight then elem.highlight.Enabled = true end end
            end
        else
            for model in pairs(state.pumpkinEspElements or {}) do removePumpkinESP(model) end
        end
        task.wait(0.5)
    end
end)

task.spawn(function()
	while state.running do
		if state.autoBreakGenAura_enabled and not isSurvivor() then
			pcall(function()
				local me = myRoot()
				if not me then return end
				local gens = workspace.Map.Generators:GetChildren()
				for _, gen in ipairs(gens) do
					local repair = gen:GetAttribute("RepairProgress") or 0
					if repair < 100 then
						local points = getGenPoints(gen)
						for _, point in ipairs(points) do
							local ok, dist = pcall(function()
								return (me.Position - point.Position).Magnitude
							end)
							if ok and dist <= state.autoBreakGenAura_radius and not isPointOccupied(point) then
								breakGen(point); task.wait(0.2)
							end
						end
					end
				end
			end)
		end
		task.wait(0.5)
	end
end)

task.spawn(function()
    while state.running do
        pcall(function()
            local pg       = lp:FindFirstChild("PlayerGui")
            local darkness = pg and pg:FindFirstChild("Darkness")
            local frame    = darkness and darkness:FindFirstChild("Frame")
            local mapInfo  = frame and frame:FindFirstChild("MapInfo")
            local mapTitle = mapInfo and mapInfo:FindFirstChild("MapTitle")
            local mapName  = mapTitle and mapTitle.ContentText or "Unknown"

            local killerPlayer = "none"
            local killerMorph  = "none"
            for _, plr in ipairs(Players:GetPlayers()) do
                local team = plr.Team
                local teamName = team and tostring(team.Name) or ""
                if teamName == "Killer" then
                    killerPlayer = plr.Name
                    local ch = plr.Character
                    if ch then
                        local ok, v = pcall(function() return ch:GetAttribute("MorphedKiller") end)
                        if ok and v then killerMorph = tostring(v) end
                    end
                    break
                end
            end

            infoMapLabel.Text    = " Map    | " .. mapName 
            infoKillerLabel.Text = "Who Killer  | " .. killerPlayer
            infoMorphLabel.Text  = " Killer  | The " .. killerMorph
        end)
        task.wait(1.0)
    end
end)

task.spawn(function()
    while state.running do
        pcall(function()
            local count = 0; local dropping = 0
            local function countFromFolder(folder)
                if not folder then return end
                for _, obj in ipairs(folder:GetChildren()) do
                    if obj:IsA("Model") and string.lower(obj.Name):find("pallet") then
                        local palletState    = obj:GetAttribute("PalletState")
                        local palletDropping = obj:GetAttribute("PalletDropping")
                        if palletState ~= "Broken" then
                            count = count + 1
                            if palletDropping == true then dropping = dropping + 1 end
                        end
                    end
                end
            end
            local map = workspace:FindFirstChild("Map")
            if map then
                countFromFolder(map:FindFirstChild("pallets"))
                countFromFolder(map:FindFirstChild("Pallets"))
                countFromFolder(map:FindFirstChild("Vaults"))
                local resources = map:FindFirstChild("resources")
                if resources then countFromFolder(resources:FindFirstChild("Pallets")) end
            end
            palletCountLabel.Text = "Pallets: " .. count .. "  |  Dropped: " .. dropping
        end)
        task.wait(0.5)
    end
end)

RunService.Heartbeat:Connect(function()
	if not state.running then return end
	local c = state.cfg
	local spectating = isSpectator()
	if spectating then
		for char in pairs(state.killer2DEspElements or {}) do removeKiller2DESP(char) end
		for char in pairs(state.player2DEspElements or {}) do removePlayer2DESP(char) end
		return
	end
	local cam = workspace.CurrentCamera
	if not cam then return end
	if c.esp_enabled then
		for _, kRoot in ipairs(state.killerRoots) do
			local char = kRoot and kRoot.Parent
			if char then
				if not state.killer2DEspElements[char] then createKiller2DESP(char) end
				local elem = state.killer2DEspElements[char]
				if elem then
					local x, y, width, height, dist = get2DScreenBounds(char)
					if elem.highlight then elem.highlight.Enabled = c.esp_showHighlight end
					if x then
						local vp = cam.ViewportSize
						local labelX    = math.clamp(x + (width/2) - 80, 0, vp.X - 160)
						local labelTopY = math.clamp(y - 22, 0, vp.Y - 30)
						local labelBotY = math.clamp(y + height + 3, 0, vp.Y - 20)
						local dynamicFont = math.clamp(math.floor(height * 0.22), 10, 14)
						elem.container.Visible  = true
						elem.nameLabel.Visible  = c.esp_showName
						elem.nameLabel.Position = UDim2.new(0, labelX, 0, labelTopY)
						elem.nameLabel.TextSize = dynamicFont
						elem.distLabel.Visible  = true
						elem.distLabel.Position = UDim2.new(0, labelX, 0, labelBotY)
						elem.distLabel.TextSize = math.max(9, dynamicFont - 1)
						elem.distLabel.Text     = string.format("[%d studs]", math.floor(dist or 0))
					else
						elem.container.Visible = false
					end
				end
			end
		end
	else
		for char in pairs(state.killer2DEspElements or {}) do removeKiller2DESP(char) end
	end
	if c.p_esp_enabled then
		local now = tick()
		if (now - state._playerCacheTime) > 0.5 then
			state._cachedPlayers = Players:GetPlayers()
			state._playerCacheTime = now
		end
		for char, _ in pairs(state.player2DEspElements) do
			local shouldRemove = true
			for _, plr in ipairs(state._cachedPlayers) do
				if plr.Character == char then
					local team = plr.Team
					local teamName = team and tostring(team.Name) or ""
					if teamName ~= "Killer" and teamName ~= "Spectator" and plr ~= lp then
						shouldRemove = false
					end
					break
				end
			end
			local ok, botId = pcall(function() return char:GetAttribute("BotId") end)
			if ok and botId ~= nil then shouldRemove = false end
			if shouldRemove then removePlayer2DESP(char) end
		end
		for _, plr in ipairs(state._cachedPlayers) do
			if plr ~= lp then
				local team = plr.Team
				local teamName = team and tostring(team.Name) or ""
				if teamName ~= "Killer" and teamName ~= "Spectator" and teamName ~= "" then
					local char = plr.Character
					local root = char and char:FindFirstChild("HumanoidRootPart")
					if char and root then
						if not state.player2DEspElements[char] then createPlayer2DESP(char) end
						local elem = state.player2DEspElements[char]
						if elem then
							local x, y, width, height, dist = get2DScreenBounds(char)
							updateEspElem(elem, char, x, y, width, height, dist)
						end
					end
				end
			end
		end
		for _, obj in ipairs(workspace:GetChildren()) do
			if obj:IsA("Model") then
				local ok, botId   = pcall(function() return obj:GetAttribute("BotId") end)
				local ok2, botNetId = pcall(function() return obj:GetAttribute("BotNetId") end)
				local isBot = (ok and botId ~= nil) or (ok2 and botNetId ~= nil)
				if isBot then
					local root = obj:FindFirstChild("HumanoidRootPart")
					local hum  = obj:FindFirstChildOfClass("Humanoid")
					if root and hum and hum.Health > 0 then
						if not state.player2DEspElements[obj] then createPlayer2DESP(obj) end
						local elem = state.player2DEspElements[obj]
						if elem then
							local knocked = obj:GetAttribute("Knocked")
							elem.nameLabel.Text = "[Bot] " .. tostring(obj.Name) .. (knocked and "  [KNOCKED]" or "")
							elem.nameLabel.TextColor3 = knocked and Color3.fromRGB(255,80,80) or Color3.fromRGB(255,255,255)
							elem.distLabel.TextColor3 = Color3.fromRGB(200,200,200)
							if elem.highlight then
								elem.highlight.FillColor    = Color3.fromRGB(255,255,255)
								elem.highlight.OutlineColor = Color3.fromRGB(255,255,255)
							end
							local x, y, width, height, dist = get2DScreenBounds(obj)
							updateEspElem(elem, obj, x, y, width, height, dist)
						end
					else
						removePlayer2DESP(obj)
					end
				end
			end
		end
	else
		for char in pairs(state.player2DEspElements or {}) do removePlayer2DESP(char) end
	end
end)

task.spawn(function()
	while state.running do
		for char in pairs(state.killer2DEspElements) do
			local alive = false
			for _, kRoot in ipairs(state.killerRoots) do
				if kRoot.Parent == char then alive = true; break end
			end
			if not alive then removeKiller2DESP(char) end
		end
		for char in pairs(state.player2DEspElements) do
			local alive = false
			for _, plr in ipairs(Players:GetPlayers()) do
				if plr.Character == char and not isKillerPlayer(plr) then alive = true; break end
			end
			if not alive then removePlayer2DESP(char) end
		end
		task.wait(1.0)
	end
end)

RunService.Heartbeat:Connect(function()
	if not state.running then return end
	if not state.moonwalkEnabled then return end
	state.moonwalkAdT = state.moonwalkAdT + (RunService.Heartbeat:Wait() or 0)
	if state.moonwalkAdT >= AD_INTERVAL then
		state.moonwalkAdT = 0
		state.moonwalkAdDir = -state.moonwalkAdDir
		if state.moonwalkAdDir > 0 then
			VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.D, false, game)
			VirtualInputManager:SendKeyEvent(true,  Enum.KeyCode.A, false, game)
		else
			VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.A, false, game)
			VirtualInputManager:SendKeyEvent(true,  Enum.KeyCode.D, false, game)
		end
	end
end)

RunService.Heartbeat:Connect(function()
	if not state.running then return end
	if not state.cfg.noFlashBlind then return end
	pcall(function()
		local selectedKiller = lp:GetAttribute("SelectedKiller")
		if not selectedKiller then return end
		local pg = lp:FindFirstChild("PlayerGui")
		local killerGui = pg and pg:FindFirstChild(selectedKiller)
		if killerGui and killerGui:FindFirstChild("Blind") then
			killerGui.Blind.Visible = false
		end
	end)
end)

RunService.Heartbeat:Connect(function(dt)
	if not state.running then return end
	local c = state.cfg
	local elig, zone, isBaiting = false, false, false
	local nearD = nil
	if c.p_enabled and isSurvivor() then
		local root = myRoot()
		local hpOk = healthOk()
		state.pStat.hp = hpOk
		if root and hpOk then
			local myp = root.Position
			local mx,my,mz = myp.X, myp.Y, myp.Z
			local now = tick()
			local ir2 = c.interactionRadius * c.interactionRadius
			for i = 1, #state.pallets do
				local pal = state.pallets[i]
				if not isPalletDropped(pal) and pal.board and pal.board.Parent then
					local ok2, palPos = pcall(function() return pal.board.Position end)
					if ok2 and palPos then
						local dx,dy,dz = mx-palPos.X, my-palPos.Y, mz-palPos.Z
						local d2 = dx*dx+dy*dy+dz*dz
						if not nearD or d2 < nearD then nearD = d2 end
						if d2 <= ir2 then
							elig = true
							for j = 1, #state.killerRoots do
								local kRoot = state.killerRoots[j]
								local inRange, valid = checkKillerApproach(kRoot, palPos, c.stunReach)
								if inRange then
									zone = true
									if not valid then
										isBaiting = true
									elseif (now - (state.lastDrop[pal.id] or 0)) >= c.cooldown and not busy() then
										pressKey(Enum.KeyCode.Space, c.p_dropKey)
										state.lastDrop[pal.id] = tick()
										state.droppedPallets[pal.id] = true
									end
								end
							end
						end
					end
				end
			end
		end
	end
	state.pStat.elig = elig; state.pStat.inZone = zone; state.pStat.baiting = isBaiting
	local nd = nearD and math.sqrt(nearD) or nil
	state.pStat.nearD = (nd and nd <= 200) and nd or nil
end)

task.spawn(function()
    while state.running do
        local c = state.cfg
        if c.sc_enabled and c.sc_mode ~= "Instant" then
            local pg  = lp:FindFirstChild("PlayerGui")
            local scr = pg  and pg:FindFirstChild("SkillCheckPromptGui")
            local chk = scr and scr:FindFirstChild("Check")
            local Line        = chk and chk:FindFirstChild("Line")
            local trapPerfect = chk and chk:FindFirstChild("TrapPerfect")
            local trapGoal    = chk and chk:FindFirstChild("TrapGoal")
            local isTrapPerfect = trapPerfect and trapPerfect.Visible
            local isTrapGoal    = (not isTrapPerfect) and trapGoal and trapGoal.Visible
            local Goal = chk and (
                isTrapPerfect and trapPerfect
                or (isTrapGoal and trapGoal)
                or chk:FindFirstChild("Goal")
            )
            if Line and Goal then
                local lr, gr = readSkillRots(Line, Goal)
                if lr and gr then
                    local effectiveOffset
                    if isTrapPerfect then
                        effectiveOffset = c.sc_trap_offset or 90
                    elseif isTrapGoal then
                        effectiveOffset = c.sc_trapgoal_offset or 100
                    else
                        effectiveOffset = c.sc_offset or 102
                    end
                    local lo = gr + effectiveOffset + (c.sc_lead or 2)
                    state.scLast.l = lr; state.scLast.g = gr
                    state.scLast.win = string.format("%.0f\xc2\xb0..%.0f\xc2\xb0", lo, lo+14)
                    local diff = (lr - lo) % 360
                    if diff > 180 then diff = diff - 360 end
                    if diff >= 0 and diff <= 14 and not state.scFired then
                        if c.sc_pressKey then pressKey(Enum.KeyCode.Space, c.sc_key) end
                        state.scFired = true; state.scHits = state.scHits + 1
                    elseif diff > 15 or diff < -10 then
                        state.scFired = false
                    end
                else
                    state.scLast.l, state.scLast.g, state.scLast.win = nil,nil,nil
                    state.scFired = false
                end
            else
                state.scFired = false
            end
        end
        task.wait(0.01)
    end
end)

task.spawn(function()
    while state.running do
        if state.cfg.silentAim_enabled then
            state.render.cachedSilentTarget = getClosestPlayerToMouse(state.cfg.silentAim_fov)
        else
            state.render.cachedSilentTarget = nil
        end
        if state.cfg.silentAim_cure_enabled then
            state.render.cachedCureTarget = getClosestPlayerToMouse(state.cfg.silentAim_fov)
        else
            state.render.cachedCureTarget = nil
        end
        if state.cfg.silentAim_survivor_enabled then
            state.render.cachedSurvivorTarget = getClosestToMouseAny(state.cfg.silentAim_fov)
        else
            state.render.cachedSurvivorTarget = nil
        end
        task.wait(0.03)
    end
end)

task.spawn(function()
    while state.running do
        if state.cfg.autoHeal_enabled and isSurvivor() then pcall(healSelf) end
        task.wait(0.3)
    end
end)

UserInputService.InputBegan:Connect(function(input, gpe)
	if not gpe and input.KeyCode == state.cfg.spear_key then
		state.cfg.spear_isHolding = true
	end
end)
UserInputService.InputEnded:Connect(function(input)
	if input.KeyCode == state.cfg.spear_key then
		state.cfg.spear_isHolding = false
	end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == state.moonwalkKey then
		state.moonwalkEnabled = not state.moonwalkEnabled
		state.moonwalkAdT     = 0
		state.moonwalkAdDir   = 1
		if not state.moonwalkEnabled then
			VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.A, false, game)
			VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.D, false, game)
		end
	end
end)

RunService.RenderStepped:Connect(function()
    if not (state.running and state.cfg.spear_enabled and state.cfg.spear_isHolding) then return end
    local team = lp.Team
    local teamName = team and tostring(team.Name) or ""
    if teamName ~= "Killer" then return end
    local target, targetType, _targetChar = getSpearTarget()
    if not target then return end
    local camCF = workspace.CurrentCamera.CFrame
    local aimPos
    if targetType == "spear" then
        aimPos = target.Position
    else
        local targetVel = target.AssemblyLinearVelocity or target.Velocity
        aimPos = calculateSpearAim(camCF.Position, target.Position, targetVel)
    end
    if not aimPos then return end
    workspace.CurrentCamera.CFrame = CFrame.lookAt(camCF.Position, aimPos)
end)

RunService.RenderStepped:Connect(function()
    if not (state.running and state.cfg.tof_enabled) then return end
    if not isSurvivor() then return end
    if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then return end
    local me = myRoot()
    if not me then return end
    local target = nil
    if state.cfg.tof_target == "Killer" then
        local mousePos = UserInputService:GetMouseLocation()
        local best = nil; local bestDist = math.huge
        for _, kRoot in ipairs(state.killerRoots) do
            if kRoot and kRoot.Parent then
                local worldDist = (me.Position - kRoot.Position).Magnitude
                if worldDist <= state.cfg.tof_maxDist then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(kRoot.Position)
                    if onScreen and screenPos.Z > 0 then
                        local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                        if dist < bestDist then bestDist = dist; best = kRoot end
                    end
                end
            end
        end
        target = best
    else
        local t = state.render.cachedSurvivorTarget
        if t and t.Parent then
            local worldDist = (me.Position - t.Position).Magnitude
            if worldDist <= state.cfg.tof_maxDist then target = t end
        end
    end
    if not target or not target.Parent then return end
    local camCF = workspace.CurrentCamera.CFrame
    workspace.CurrentCamera.CFrame = CFrame.lookAt(camCF.Position, target.Position)
end)

RunService.RenderStepped:Connect(function()
	local showFov = (state.cfg.silentAim_enabled or state.cfg.silentAim_cure_enabled) and state.cfg.silentAim_showFOV
	local center = UserInputService:GetMouseLocation()
	if showFov then
		state.render.fovCircle.Position = Vector2.new(center.X, center.Y)
		state.render.fovCircle.Radius   = state.cfg.silentAim_fov or 150
		state.render.fovCircle.Visible  = true
	else
		state.render.fovCircle.Visible = false
	end
	local target = state.render.cachedSilentTarget
	if state.cfg.silentAim_enabled and target and target.Parent then
		local screenPos, onScreen = Camera:WorldToViewportPoint(target.Position)
		if onScreen and screenPos.Z > 0 then
			state.render.lockLine.From    = Vector2.new(center.X, center.Y)
			state.render.lockLine.To      = Vector2.new(screenPos.X, screenPos.Y)
			state.render.lockLine.Visible = true
		else
			state.render.lockLine.Visible = false
		end
	else
		state.render.lockLine.Visible = false
	end
    local survTarget = state.render.cachedSurvivorTarget
	if state.cfg.silentAim_survivor_enabled and survTarget and survTarget.Parent then
		local screenPos, onScreen = Camera:WorldToViewportPoint(survTarget.Position)
		if onScreen and screenPos.Z > 0 then
			state.render.lockLineSurv.From    = Vector2.new(center.X, center.Y)
			state.render.lockLineSurv.To      = Vector2.new(screenPos.X, screenPos.Y)
			state.render.lockLineSurv.Visible = true
		else
			state.render.lockLineSurv.Visible = false
		end
	else
		state.render.lockLineSurv.Visible = false
	end
	local cureTarget = state.render.cachedCureTarget
	if state.cfg.silentAim_cure_enabled and cureTarget and cureTarget.Parent then
		local screenPos, onScreen = Camera:WorldToViewportPoint(cureTarget.Position)
		if onScreen and screenPos.Z > 0 then
			state.render.lockLineCure.From    = Vector2.new(center.X, center.Y)
			state.render.lockLineCure.To      = Vector2.new(screenPos.X, screenPos.Y)
			state.render.lockLineCure.Visible = true
		else
			state.render.lockLineCure.Visible = false
		end
	else
		state.render.lockLineCure.Visible = false
	end
end)


RunService.Heartbeat:Connect(function()
	if not state.running or not state.cfg.scp_esp_enabled then return end
	local now = tick()
	if now - state._scpTick < 0.1 then return end
	state._scpTick = now
	for model, elem in pairs(state.scpEspElements) do
		if not model.Parent then removeSCPESP(model); continue end
		if elem.highlight then elem.highlight.Enabled = state.cfg.scp_esp_showHighlight end
	end
end)

task.spawn(function()
    while state.running do
        if state.vaultEspEnabled or state.palletEspEnabled then
            for obj in pairs(state.vaultEspElements) do
                if not obj.Parent then removeVaultESP(obj) end
            end
            for model in pairs(state.palletEspElements) do
                if not model.Parent then removePalletESP(model) end
            end
        end
        task.wait(3.0)
    end
end)

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function(newChar)
        for char in pairs(state.player2DEspElements) do
            if char ~= newChar then
                for _, p in ipairs(Players:GetPlayers()) do
                    if p == plr and p.Character ~= char then
                        removePlayer2DESP(char)
                    end
                end
            end
        end
    end)
end)

for _, plr in ipairs(Players:GetPlayers()) do
    plr.CharacterAdded:Connect(function(newChar)
        task.wait(0.1)
        for char in pairs(state.player2DEspElements) do
            local found = false
            for _, p in ipairs(Players:GetPlayers()) do
                if p.Character == char then found = true; break end
            end
            if not found then removePlayer2DESP(char) end
        end
    end)
end

Players.PlayerRemoving:Connect(function(plr)
	state.playerParryState[plr] = nil
	state.monitoredPlayerAnimators[plr] = nil
end)

lp.CharacterAdded:Connect(function(char)
    state._fvController = nil
    _fvLastDiscover = 0
    _fvFailCount = 0
    state._fsCD          = 0
    state._fsOverrideEnd = 0
    fvHookAnim(char)
    task.delay(1.5, function()
        if state.cfg.fastVault_enabled then
            pcall(fvDiscover); pcall(fvPatch)
        end
        if state.cfg.flowstate_enabled then
            pcall(fsApplyAttr)
        end
    end)
end)

task.spawn(function()
	while state.running do
		pcall(function()
			if not state.uiLabels.parryDaggerCD then return end
			local pg   = lp:FindFirstChild("PlayerGui")
			local surv = pg   and pg:FindFirstChild("Survivor")
			local gen  = surv and surv:FindFirstChild("Gen")
			local item = gen  and gen:FindFirstChild("ItemFrame")
			local gui  = item and item:FindFirstChild("Gui")
			local bar  = gui  and gui:FindFirstChild("Bar")
			local grad = bar  and bar:FindFirstChild("UIGradient")
			if not grad then
				state.uiLabels.parryDaggerCD:SetText("Parry Dagger: N/A")
				return
			end
			local offsetY = grad.Offset.Y
			local pct     = math.clamp(1.0 - (offsetY - 0.25) / (0.75 - 0.25), 0, 1)
			local pctInt  = math.floor(pct * 100)
			if pctInt >= 100 then
				state.uiLabels.parryDaggerCD:SetText("Parry Dagger: READY")
			else
				state.uiLabels.parryDaggerCD:SetText(string.format("Parry Dagger: CD %d%%", pctInt))
			end
		end)
		task.wait(0.05)
	end
end)

task.spawn(function()
    local accD, accA = 0, 0
    while state.running do
        local dt = task.wait()
        accD += dt; accA += dt

        if accD >= 5 then
            accD = 0
            if state.cfg.fastVault_enabled then
                pcall(fvPatch)
                pcall(fvDiscover)
            end
        end

        if accA >= 0.1 then
            accA = 0
            pcall(fsApplyAttr)
        end
    end
end)

state.render.cachedSilentTarget  = nil
state.render.cachedCureTarget    = nil
state.render.cachedSurvivorTarget = nil

state.render.fovCircle = Drawing.new("Circle")
state.render.fovCircle.Visible   = false
state.render.fovCircle.Thickness = 1
state.render.fovCircle.Color     = Color3.fromRGB(255, 255, 255)
state.render.fovCircle.Filled    = false
state.render.fovCircle.Radius    = 150
state.render.fovCircle.NumSides  = 64

state.render.lines = {
    aim  = Drawing.new("Line"),
    cure = Drawing.new("Line"),
    surv = Drawing.new("Line"),
}
state.render.lines.aim.Visible      = false; state.render.lines.aim.Thickness  = 1.5
state.render.lines.aim.Color        = Color3.fromRGB(255, 0, 0);   state.render.lines.aim.Transparency = 0.3
state.render.lines.cure.Visible     = false; state.render.lines.cure.Thickness = 1.5
state.render.lines.cure.Color       = Color3.fromRGB(0, 255, 150); state.render.lines.cure.Transparency = 0.3
state.render.lines.surv.Visible     = false; state.render.lines.surv.Thickness = 1.5
state.render.lines.surv.Color       = Color3.fromRGB(255, 255, 0); state.render.lines.surv.Transparency = 0.3

state.render.lockLine     = state.render.lines.aim
state.render.lockLineCure = state.render.lines.cure
state.render.lockLineSurv = state.render.lines.surv
local _SPEAR_ORIGIN_OFFSET = Vector3.new(1.35, 0.34, -2.51)

local _veilBotCache      = {}
local _veilBotCacheTime  = 0
local function refreshVeilBotCache()
    local now = tick()
    if now - _veilBotCacheTime < 0.5 then return _veilBotCache end
    _veilBotCacheTime = now
    _veilBotCache = {}
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj:IsA("Model") then
            local ok1, botId    = pcall(function() return obj:GetAttribute("BotId") end)
            local ok2, botNetId = pcall(function() return obj:GetAttribute("BotNetId") end)
            if (ok1 and botId ~= nil) or (ok2 and botNetId ~= nil) then
                table.insert(_veilBotCache, obj)
            end
        end
    end
    return _veilBotCache
end

local veilVelocityCache = {}
local function getVeilSmoothedVel(key, newVel)
    local now = tick()
    local entry = veilVelocityCache[key]
    if not entry then entry = {}; veilVelocityCache[key] = entry end
    if not entry.lastTime or now - entry.lastTime > 0.3 then
        entry.velocity = newVel; entry.lastTime = now; return newVel
    end
    local smoothed = entry.velocity:Lerp(newVel, 0.2)
    if smoothed.Magnitude < 0.2 then smoothed = Vector3.new(0,0,0)
    elseif smoothed.Magnitude > 40 then smoothed = smoothed.Unit * 40 end
    entry.velocity = smoothed; entry.lastTime = now
    return smoothed
end

local function solveVeilSpearAim(origin, targetPos, targetVel, speed, gravity)
    speed   = math.max(tonumber(speed)   or 165, 1)
    gravity = tonumber(gravity) or (workspace.Gravity / 2)

    local flightTime = (targetPos - origin).Magnitude / speed
    local aimPoint   = targetPos

    for _ = 1, 3 do
        aimPoint   = targetPos + targetVel * flightTime
        local delta = aimPoint - origin
        flightTime  = delta.Magnitude / speed
    end

    local dir     = aimPoint - origin
    local gravVec = Vector3.new(0, -gravity, 0)
    local aimDir  = (dir - (0.5 * gravVec) * (flightTime ^ 2)) / math.max(flightTime, 1e-3)

    if aimDir.Magnitude < 1e-3 then
        local fallback = (targetPos - origin)
        if fallback.Magnitude < 1e-3 then
            return Vector3.new(0, 1, 0), targetPos
        end
        return fallback.Unit, targetPos
    end
    return aimDir.Unit, aimPoint
end

local function findVeilTarget(fovOverride)
    local cam = workspace.CurrentCamera
    if not cam then return nil end

    local mousePos = UserInputService:GetMouseLocation()
    local fov      = fovOverride or state.cfg.silentAim_fov or 150
    local partName = state.cfg.spear_targetPart or "Head"

    local bestPart, bestDist = nil, math.huge

    local function tryChar(char)
        if not char or not char.Parent then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not (hum and hum.Health > 0) then return end

        local knocked = char:GetAttribute("Knocked")
        if knocked then return end

        local part = char:FindFirstChild(partName)
            or char:FindFirstChild("UpperTorso")
            or char:FindFirstChild("HumanoidRootPart")
            or char:FindFirstChild("Head")
        if not part then return end

        local screen, vis = cam:WorldToViewportPoint(part.Position)
        if vis and screen.Z > 0 then
            local d = (Vector2.new(screen.X, screen.Y) - mousePos).Magnitude
            if d < bestDist and d <= fov then
                bestDist = d
                bestPart = part
            end
        end
    end

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= lp then tryChar(plr.Character) end
    end
    for _, bot in ipairs(refreshVeilBotCache()) do
        tryChar(bot)
    end

    return bestPart
end

local function resolvePayloadOrigin(payload, char)
    local o = payload and payload.Origin
    if typeof(o) == "Vector3" then return o end
    if typeof(o) == "CFrame"  then return o.Position end
    if char then
        local head = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
        if head then return head.Position end
    end
    return Vector3.new(0, 0, 0)
end

local mt = getrawmetatable(game)
setreadonly(mt, false)
local oldNamecall = mt.__namecall

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local selfName = ""
    if typeof(self) == "Instance" then
        pcall(function() selfName = tostring(self.Name or "") end)
    end

    if method == "GetChildren" or method == "GetDescendants" or 
       method == "FindFirstChild" or method == "FindFirstChildOfClass" or 
       method == "FindFirstAncestor" or method == "FindFirstAncestorOfClass" or
       method == "GetAttribute" or method == "GetAttributes" or 
       method == "IsA" or method == "GetFullName" or 
       method == "GetPropertyChangedSignal" or method == "WaitForChild" or
       method == "pcall" or method == "GetService" or method == "HttpGet" then
        return oldNamecall(self, ...)
    end

    if typeof(self) ~= "Instance" or (method ~= "FireServer" and method ~= "InvokeServer") then
        return oldNamecall(self, ...)
    end

    if not state._veilSAFiring
        and state.cfg.veilSilentAim_enabled
        and method == "FireServer"
        and selfName == "Spearthrow" then
        local holder = self.Parent
        local okPath = holder
            and holder.Name == "Veil"
            and holder.Parent
            and holder.Parent.Name == "Killers"
        if okPath then
            local args = { ... }
            local payload = args[1]
            if type(payload) == "table" then
                local target = findVeilTarget(state.cfg.silentAim_fov)
                if target and target.Parent then
                    local char   = lp.Character
                    local origin = resolvePayloadOrigin(payload, char)
                    local vel    = getVeilSmoothedVel(target, target.AssemblyLinearVelocity or Vector3.new(0, 0, 0))
                    local speed  = 165
                    local grav   = workspace.Gravity / 2
                    local okSolve, dir, aimPoint = pcall(solveVeilSpearAim, origin, target.Position, vel, speed, grav)
                    if okSolve and dir and dir.Magnitude > 0.001 then
                        payload.Direction = dir
                        state._lastVeilSolvedDir    = dir
                        state._lastVeilSolvedOrigin = origin
                        state._lastVeilSpeed        = speed
                        state._lastVeilGrav         = grav
                        state._lastVeilAimPoint     = aimPoint
                        state._veilSAFiring = true
                        local remoteFire = (Instance.new("RemoteEvent")).FireServer
                        local _okFire, res = pcall(remoteFire, self, payload)
                        state._veilSAFiring = false
                        return res
                    end
                end
            end
        end
    end

    if not state._saFiring
        and state.cfg.silentAim_cure_enabled
        and state.cfg.silentAim_killerMode == "The Cure"
        and method == "FireServer"
        and selfName:find("ThrowFlask") then
        local target = state.render.cachedCureTarget
        if target and target.Parent then
            local args = { ... }
            local origin = args[2]
            if typeof(origin) == "Vector3" then
                args[1] = (target.Position - origin).Unit
            end
            state._saFiring = true
            local okC, res = pcall(function() return self:FireServer(args[1], args[2]) end)
            state._saFiring = false
            if okC then return res end
        end
    end

    if state.cfg.antiFallDamage_enabled
        and (selfName == "Fall" or selfName == "FallDamage" or selfName == "TakeFallDamage")
        and (method == "FireServer" or method == "InvokeServer") then
        local args = { ... }
        for i = 1, #args do
            if type(args[i]) == "number" then
                args[i] = 0
            elseif typeof(args[i]) == "Vector3" then
                args[i] = Vector3.new(0, 0, 0)
            end
        end
        return oldNamecall(self, table.unpack(args))
    end

    return oldNamecall(self, ...)
end)

local SOURCE = "https://raw.githubusercontent.com/mm3xwqi/s/refs/heads/main/UI.lua"
OasisUI = getgenv().OasisUI_Dev or loadstring(game:HttpGet(SOURCE))()

state.ui.Window = OasisUI:CreateWindow({
	Title     = "KKKK Hub",
	Subtitle  = "v1.3",
	Icon      = "swords",
	Folder    = "KKKK-Hub",
	Tags      = { "v1.3" },
	ToggleKey = Enum.KeyCode.RightShift,
})
state.ui.Tabs = {
	Changelog = state.ui.Window:Tab({ Title = "Changelog", Icon = "bookmark" }),
	Survivor  = state.ui.Window:Tab({ Title = "Survivor", Icon = "user" }),
	OP        = state.ui.Window:Tab({ Title = "OP", Icon = "zap" }),
	Killer    = state.ui.Window:Tab({ Title = "Killer", Icon = "swords" }),
	Aimbot    = state.ui.Window:Tab({ Title = "Aimbot", Icon = "crosshair" }),
	ESP       = state.ui.Window:Tab({ Title = "ESP", Icon = "eye" }),
	World     = state.ui.Window:Tab({ Title = "World", Icon = "globe" }),
	Pumpkin   = state.ui.Window:Tab({ Title = "Pumpkin", Icon = "ghost" }),
}

local function changelog(title, side, lines)
	local section = state.ui.Tabs.Changelog:Section({ Title = "Update " .. title, Icon = "mail", Side = side })
	for _, text in ipairs(lines) do section:Label({ Text = text }) end
end

changelog("17 Aug", "Left", { "/ Improve Anti Stun +++", "/ Improve Moonwalk  press G", "+ Add SCP ESP", "+ Add Legit Mode For Auto Parry", "/ Optimize all ESP" })
changelog("18 Aug", "Right", { "/ Improve Esp", "+ Add Silent Aim Veil/Gun", "+ Add Fov Circle", "+ Add Silent Aim Fov Slider", "+ Add Fast Skillcheck Speed", "+ Add Skillcheck Speed Value Slider", "+ Add Vault Speed", "+ Add Vault Speed Value Slider" })
changelog("20 Aug", "Left", { "+ Add Vault Speed ( Killer )", "+ Add Vault Speed Value Slider ( Killer )", "+ Add Tab Aimbot", "+ Add Silent Aim The Cure", "+ Add Silent Aim Twist of Fate", "+ Add Aimbot FlashLight", "+ Add Auto Drop Pallet When Killer Carry", "+ Add ESP Generator", "+ Move Spear Aimbot to the Aimbot tab", "/ Improve Aimbot The Veil 99% Hit", "/ Optimize Esp Scp", "* Fix ESP Generator", "- Remove spear_gravity_ready Slider", "- Remove spear_gravity_cd Slider" })
changelog("21 Oct", "Right", { "+ Auto Break Gen Aura", "+ Auto Drop Pallet Other Carried", "/ Change Style Gen Esp", "/ Optimize All Esp", "/ Improve Auto Parry", "/ Improve MoonWalk", "/ Improve NoFog", "/ Force Enable Show Distance", "- Remove Side Panel (Status)", "/ ESP Now Realtime (Heartbeat)" })
changelog("23 Oct", "Right", { "+ Add OP Funtion" })
changelog("25 Oct", "Left", { "+ Add Esp BearTrap", "+ Add Esp Pumpkin", "+ Add Skillcheck BearTrap", "+ Add Auto Parry New Killer", "+ Add Heal Self", "/ Improve FullBright", "/ Improve NoFog", "/ Improve Auto Parry", "- Remove Instant Vault Survivor", "- Remove Auto DropPallet Self", "- Remove Auto DropPallet Other" })
changelog("26 Oct", "Right", { "+ ESP Bot", "+ Show Map/WhoKiller/Killer", "+ ESP Pallet", "+ ESP Vault", "+ ESP Gen Breaking", "+ Anti Fall Damage", "/ Improve ESP", "/ Change ESP Theme", "/ Change Silent Aim Gun to Aimbot" })
changelog("28 Oct", "Right", { "+ ESP Yourself","+ Auto Crush Pumpkins","+ Pallet / Drop GUI", "+ Status Player Knocked", "/ Improve ESP Vault", "/ Improve ESP Pallet", "/ Change UI !!!!!!","/ Improve Silent Aim The Veil Now HIT 100%", "- Remove ESP Spear", })
changelog("29 Oct", "Right", { "/ Fix Skillcheck Mode (Normal waits for Line, Instant snaps Line to goal offset before pressing)", })
changelog("29 Oct", "Right", { "+ Add Skillcheck Instant Support BearTrap","+ Add SkillCheck Mode","+ Add Skillcheck Instant","+ Add VaultSpeed","+ Add Speed Modifier","+ Add Flowstate","/Bringback Fastvault",})
changelog("30 Oct", "left", { "+ Add Infinity lunge", "+ Add Change FOV","/ Change Position GUI Status"})

state.ui.Tabs.Changelog:Section({ Title = "Script", Icon = "power", Side = "Left" }):Button({
	Title    = "Unload Script",
	Icon     = "power",
	Style    = "Danger",
	Confirm  = "Stop all loops and destroy the UI?",
	Callback = function() OasisUI:Unload() end,
})

local pumpkinTab = state.ui.Tabs.Pumpkin
local pfControlBox = pumpkinTab:Section({ Title = "Auto Pumpkin", Icon = "ghost", Side = "Left" })

state.pfToggleElem = pfControlBox:Toggle({
	Title    = "Auto Pumpkin",
	Default  = false,
	Callback = function(v)
		if not v then
			if state.pfRunning then pfStop() end
			state.pfToggleState = false
			return
		end
		if not isSurvivor() then
			OasisUI:Notify({ Title = "Auto Pumpkin", Content = "Survivors only!", Duration = 4 })
			state.pfToggleState = false
			task.defer(function()
				if state.pfToggleElem then pcall(function() state.pfToggleElem:SetValue(false) end) end
			end)
			return
		end
		if state.pfRunning then return end
		state.pfToggleState = true
		state.pfRunning = true
		state.cfg.autoPumpkin_enabled = true
		state.pfThread = task.spawn(pfRun)
	end,
})

pfControlBox:Slider({
	Title    = "Crush Delay",
	Default  = state.cfg.autoPumpkin_delay,
	Min      = 0,
	Max      = 2,
	Step     = 0.1,
	Suffix   = "s",
	Callback = function(v) state.cfg.autoPumpkin_delay = v end,
})

state.ui.PalletBox = state.ui.Tabs.Survivor:Section({ Title = "Pallet Killer Stun", Icon = "shield", Side = "Left" })
state.ui.PalletBox:Toggle({ Title = "Auto Drop Pallet", Default = state.cfg.p_enabled, Callback = function(v) state.cfg.p_enabled = v end })
state.ui.PalletBox:Toggle({ Title = "Anti Bait", Default = state.cfg.antiBait, Callback = function(v) state.cfg.antiBait = v end })
state.ui.PalletBox:Slider({ Title = "Stun Reach", Default = state.cfg.stunReach, Min = 4, Max = 20, Step = 1, Suffix = " studs", Callback = function(v) state.cfg.stunReach = v end })
state.ui.PalletBox:Slider({ Title = "Interact Radius", Default = state.cfg.interactionRadius, Min = 4, Max = 25, Step = 1, Suffix = " studs", Callback = function(v) state.cfg.interactionRadius = v end })
state.ui.PalletBox:Slider({ Title = "Space Cooldown", Default = state.cfg.cooldown, Min = 0.05, Max = 1.5, Step = 0.01, Suffix = "s", Callback = function(v) state.cfg.cooldown = v end })

state.ui.SkillBox = state.ui.Tabs.Survivor:Section({ Title = "Skillcheck", Icon = "gauge", Side = "Right" })
state.ui.SkillBox:Toggle({ Title = "Auto Skillcheck", Default = state.cfg.sc_enabled, Callback = function(v)
    state.cfg.sc_enabled = v
    state.cfg.sc_pressKey = v
    if v and state.cfg.sc_mode == "Instant" then
        startInstantSC()
    else
        stopInstantSC()
    end
end })
state.ui.SkillBox:Dropdown({
    Title    = "Skillcheck Mode",
    Default  = state.cfg.sc_mode,
    Values   = { "Normal", "Instant" },
    Callback = function(v)
        state.cfg.sc_mode = v
        if state.cfg.sc_enabled and v == "Instant" then
            startInstantSC()
        else
            stopInstantSC()
        end
    end,
})
state.ui.SkillBox:Slider({
    Title    = "Instant Offset (Normal Goal)",
    Default  = state.cfg.sc_instant_offset,
    Min      = 80,
    Max      = 130,
    Step     = 1,
    Suffix   = "°",
    Callback = function(v) state.cfg.sc_instant_offset = v end,
})
state.ui.SkillBox:Slider({
    Title    = "Instant Offset (Trap Perfect)",
    Default  = state.cfg.sc_trap_offset,
    Min      = 80,
    Max      = 130,
    Step     = 1,
    Suffix   = "°",
    Callback = function(v) state.cfg.sc_trap_offset = v end,
})
state.ui.SkillBox:Slider({
    Title    = "Instant Offset (Trap Goal)",
    Default  = state.cfg.sc_trapgoal_offset,
    Min      = 80,
    Max      = 130,
    Step     = 1,
    Suffix   = "°",
    Callback = function(v) state.cfg.sc_trapgoal_offset = v end,
})
state.ui.SkillBox:Toggle({ Title = "Fast Skillcheck Speed", Default = state.cfg.sc_speed_enabled, Callback = function(v)
	state.cfg.sc_speed_enabled = v
	if not v then pcall(function() local c = workspace:FindFirstChild(lp.Name); if c then c:SetAttribute("skillcheckspeed", nil) end end) end
end })
state.ui.SkillBox:Slider({ Title = "Skillcheck Speed Value", Default = state.cfg.sc_speed_value, Min = 0.5, Max = 10, Step = 0.1, Callback = function(v) state.cfg.sc_speed_value = v end })
state.ui.SkillBox:Slider({ Title = "Hit Zone Offset", Default = state.cfg.sc_offset, Min = 80, Max = 130, Step = 1, Suffix = "°", Callback = function(v) state.cfg.sc_offset = v end })
state.ui.SkillBox:Slider({ Title = "Lead Angle", Default = state.cfg.sc_lead, Min = 0, Max = 10, Step = 1, Suffix = "°", Callback = function(v) state.cfg.sc_lead = v end })

state.ui.AutoCrouchBox = state.ui.Tabs.Survivor:Section({ Title = "Anti Skill", Icon = "shield-check", Side = "Right" })
state.ui.AutoCrouchBox:Toggle({ Title = "Anti Skill The Abysswalker", Default = state.cfg.autoCrouch_enabled, Callback = function(v) state.cfg.autoCrouch_enabled = v end })
state.ui.AutoCrouchBox:Slider({ Title = "Crouch Delay", Default = state.cfg.autoCrouch_delay, Min = 0, Max = 0.5, Step = 0.01, Suffix = "s", Callback = function(v) state.cfg.autoCrouch_delay = v end })
state.ui.AutoCrouchBox:Toggle({ Title = "Crouch Humanizer", Default = state.cfg.autoCrouch_humanize, Callback = function(v) state.cfg.autoCrouch_humanize = v end })
state.ui.AutoCrouchBox:Slider({ Title = "Crouch Distance", Default = state.cfg.autoCrouch_distance, Min = 5, Max = 50, Step = 1, Suffix = " studs", Callback = function(v) state.cfg.autoCrouch_distance = v end })
state.ui.AutoCrouchBox:Slider({ Title = "Crouch Duration", Default = state.cfg.autoCrouch_duration, Min = 0, Max = 3, Step = 0.1, Suffix = "s", Callback = function(v) state.cfg.autoCrouch_duration = v end })

state.ui.ParryBox = state.ui.Tabs.Survivor:Section({ Title = "Anti Hit", Icon = "swords", Side = "Left" })
state.ui.ParryBox:Toggle({ Title = "Auto Parry", Default = state.cfg.ap_enabled, Callback = function(v) state.cfg.ap_enabled = v end })
state.ui.ParryBox:Toggle({ Title = "Legit Mode", Default = state.cfg.ap_legitMode, Callback = function(v) state.cfg.ap_legitMode = v end })
state.ui.ParryBox:Slider({ Title = "Legit Min Delay", Default = state.cfg.ap_legitMinDelay, Min = 0, Max = 0.3, Step = 0.01, Suffix = "s", Callback = function(v) state.cfg.ap_legitMinDelay = v end })
state.ui.ParryBox:Slider({ Title = "Legit Max Delay", Default = state.cfg.ap_legitMaxDelay, Min = 0.05, Max = 0.5, Step = 0.01, Suffix = "s", Callback = function(v) state.cfg.ap_legitMaxDelay = v end })

state.ui.VaultBox = state.ui.Tabs.Survivor:Section({ Title = "Vault & Flowstate", Icon = "wind", Side = "Right" })
state.ui.VaultBox:Toggle({
    Title    = "Always Fast Vault",
    Default  = false,
    Callback = function(v)
        state.cfg.fastVault_enabled = v
        if v then pcall(fvDiscover); pcall(fvPatch)
        else fvUnpatch() end
    end,
})
state.ui.VaultBox:Toggle({
    Title    = "Force Flowstate",
    Default  = false,
    Callback = function(v)
        state.cfg.flowstate_enabled = v
        if v then
            state._fsCD          = 0
            state._fsOverrideEnd = 0
            local char = lp.Character
            if char then
                pcall(fvHookAnim, char)
            end
            task.defer(function()
                pcall(fsApplyAttr)
            end)
        else
            state._fsCD          = 0
            state._fsOverrideEnd = 0
            fsClearAttr()
        end
    end,
})
state.ui.VaultBox:Slider({
    Title    = "Flowstate Cooldown",
    Default  = 15,
    Min      = 5,
    Max      = 30,
    Step     = 1,
    Suffix   = "s",
    Callback = function(v)
        state.cfg.flowstate_cooldown = v
        if state.cfg.flowstate_enabled then
            local now = tick()
            if now < state._fsCD then
                if not state._fsCDLock or now > state._fsCDLock then
                    state._fsCD = now + v
                    state._fsCDLock = now + 0.2
                end
            end
        end
    end,
})

state.ui.OPBox = state.ui.Tabs.OP:Section({ Title = "OP Functions", Icon = "zap", Side = "Left" })
state.ui.OPBox:Toggle({ Title = "God Mode", Default = state.cfg.godmode_enabled, Callback = function(v) state.cfg.godmode_enabled = v end })
state.ui.OPBox:Toggle({ Title = "Anti Fall Damage", Default = state.cfg.antiFallDamage_enabled, Callback = function(v) state.cfg.antiFallDamage_enabled = v end })
state.ui.OPBox:Toggle({ Title = "Auto Heal Self", Default = false, Callback = function(v) state.cfg.autoHeal_enabled = v end })

state.ui.SpeedModBox = state.ui.Tabs.OP:Section({
	Title = "Speed Modifier",
	Icon  = "gauge",
	Side  = "Right",
})

state.ui.SpeedModBox:Toggle({
	Title    = "Enable Speed Modifier",
	Default  = state.cfg.speedMod_enabled,
	Callback = function(v)
		state.cfg.speedMod_enabled = v
		if not v then
			pcall(speedModCleanup)
		else
			local teamName = lp.Team and lp.Team.Name or ""
			for _, m in ipairs(speedModGetPlayerModels()) do
				speedModAttachModel(m)
				speedModApplyToModel(m, teamName)
			end
		end
	end,
})

state.ui.SpeedModBox:Slider({
	Title    = "Speed Multiplier",
	Default  = state.cfg.speedMod_value,
	Min      = 1,
	Max      = 3,
	Step     = 0.05,
	Suffix   = "x",
	Callback = function(v)
		state.cfg.speedMod_value = v
		table.clear(_speedModLastApplied)
		local teamName = lp.Team and lp.Team.Name or ""
		for _, m in ipairs(speedModGetPlayerModels()) do
			speedModApplyToModel(m, teamName)
		end
	end,
})

state.ui.SpeedModBox:Toggle({
	Title    = "Count Speed Perks / Slowdowns",
	Default  = state.cfg.speedMod_countPerks,
	Callback = function(v)
		state.cfg.speedMod_countPerks = v
		table.clear(_speedModLastApplied)
	end,
})

state.ui.SpeedModBox:Dropdown({
	Title    = "Apply To",
	Default  = state.cfg.speedMod_team,
	Values   = { "Both", "Survivors", "Killer" },
	Callback = function(v)
		state.cfg.speedMod_team = v
		table.clear(_speedModLastApplied)
	end,
})

state.ui.SpeedModBox:Slider({
	Title    = "Vault Speed Multiplier",
	Default  = state.cfg.speedMod_vaultSpeed,
	Min      = 1,
	Max      = 5,
	Step     = 0.1,
	Suffix   = "x",
	Callback = function(v)
		state.cfg.speedMod_vaultSpeed = v
		table.clear(_speedModLastApplied)
	end,
})

state.ui.FlashBox = state.ui.Tabs.Killer:Section({ Title = "Anti Flashlight", Icon = "flashlight-off", Side = "Right" })
state.ui.FlashBox:Toggle({ Title = "No Flash Blind", Default = state.cfg.noFlashBlind, Callback = function(v) state.cfg.noFlashBlind = v end })

state.ui.LungeBox = state.ui.Tabs.Killer:Section({ Title = "Infinite Lunge", Icon = "zap", Side = "Right" })
state.ui.LungeBox:Toggle({
	Title    = "Enable Infinite Lunge",
	Default  = false,
	Callback = function(v)
		if not v then
			LUNGE_S.Running = false
		else
			LUNGE_S.Running = true
			LUNGE_S.LastScan = 0
			task.spawn(lungeScan)
		end
	end,
})
state.ui.BreakSpeedBox = state.ui.Tabs.Killer:Section({ Title = "Break Speed", Icon = "hammer", Side = "Right" })
state.ui.BreakSpeedBox:Toggle({ Title = "Enable Break Speed", Default = state.cfg.breakSpeed_enabled, Callback = function(v) state.cfg.breakSpeed_enabled = v end })
state.ui.BreakSpeedBox:Slider({ Title = "Break Speed Value", Default = state.cfg.breakSpeed_value, Min = 1, Max = 10, Step = 0.1, Callback = function(v) state.cfg.breakSpeed_value = v end })

state.ui.BreakGenBox = state.ui.Tabs.Killer:Section({ Title = "Auto Break Generator", Icon = "wrench", Side = "Left" })
state.ui.BreakGenBox:Toggle({ Title = "Auto Break Gen Aura", Default = false, Callback = function(v) state.autoBreakGenAura_enabled = v end })
state.ui.BreakGenBox:Slider({ Title = "Aura Radius", Default = 20, Min = 5, Max = 60, Step = 1, Suffix = " studs", Callback = function(v) state.autoBreakGenAura_radius = v end })

state.ui.MaskedBox = state.ui.Tabs.Killer:Section({ Title = "The Masked", Icon = "venetian-mask", Side = "Left" })
state.ui.maskList = { "Alex", "Brandon", "Cobra", "Rabbit", "Richter", "Richard", "Tony" }
state.ui.MaskedBox:Dropdown({ Title = "Select Mask", Default = state.cfg.selectMask, Values = state.ui.maskList, Callback = function(v) state.cfg.selectMask = v end })
state.ui.MaskedBox:Button({ Title = "Use Mask Power", Callback = function()
	pcall(function()
		game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Killers")
			:WaitForChild("Masked"):WaitForChild("Activatepower"):FireServer(state.cfg.selectMask)
	end)
end })

state.ui.Swiftbox = state.ui.Tabs.Killer:Section({ Title = "Vault", Icon = "door-open", Side = "Left" })
state.ui.Swiftbox:Toggle({ Title = "Vault Speed (Swift)", Default = false, Callback = function(v)
	state.cfg.swiftspeed_enabled = v
	if not v then pcall(function() local c = workspace:FindFirstChild(lp.Name); if c then c:SetAttribute("swift", nil) end end) end
end })
state.ui.Swiftbox:Slider({ Title = "Swift Speed Value", Default = 1.5, Min = 1, Max = 10, Step = 0.1, Callback = function(v) state.cfg.swiftspeed_value = v end })

state.ui.veilSA = state.ui.Tabs.Aimbot:Section({ Title = "Silent Aim The Veil", Icon = "crosshair", Side = "Left" })
state.ui.veilSA:Toggle({
	Title    = "Silent Aim Spear",
	Default  = false,
	Callback = function(v) state.cfg.veilSilentAim_enabled = v end,
})
state.ui.veilSA:Dropdown({
	Title    = "Target Part",
	Default  = "Head",
	Values   = { "Head", "UpperTorso", "HumanoidRootPart" },
	Callback = function(v) state.cfg.spear_targetPart = v end,
})

state.ui.aimbots = state.ui.Tabs.Aimbot:Section({ Title = "Twist of Fate", Icon = "target", Side = "Right" })
state.ui.aimbots:Toggle({ Title = "Aimbot Gun", Default = false, Callback = function(v) state.cfg.tof_enabled = v end })
state.ui.aimbots:Dropdown({ Title = "Lock Target", Default = "Survivor", Values = { "Survivor", "Killer" }, Callback = function(v) state.cfg.tof_target = v end })
state.ui.aimbots:Slider({ Title = "Max Distance", Default = 30, Min = 5, Max = 100, Step = 1, Suffix = " studs", Callback = function(v) state.cfg.tof_maxDist = v end })

state.ui.aimbotf = state.ui.Tabs.Aimbot:Section({ Title = "Flashlight", Icon = "flashlight", Side = "Left" })
state.ui.aimbotf:Toggle({ Title = "Aimbot Flashlight", Default = false, Callback = function(v) state.flashlightAimEnabled = v end })

state.ui.aimbot = state.ui.Tabs.Aimbot:Section({ Title = "The Veil Legit", Icon = "crosshair", Side = "Right" })
state.ui.aimbot:Toggle({ Title = "Spear Aimlock (Hold E)", Default = state.cfg.spear_enabled, Callback = function(v) state.cfg.spear_enabled = v end })

state.ui.VaultPalletESPBox = state.ui.Tabs.ESP:Section({ Title = "Object Esp", Icon = "boxes", Side = "Left" })
state.ui.VaultPalletESPBox:Toggle({ Title = "Enable Vault ESP", Default = false, Callback = function(v)
	state.vaultEspEnabled = v
	if not v then for obj in pairs(state.vaultEspElements) do removeVaultESP(obj) end
	else pcall(scanVaultAndPallet) end
end })
state.ui.VaultPalletESPBox:Toggle({ Title = "Enable Pallet ESP", Default = false, Callback = function(v)
	state.palletEspEnabled = v
	if not v then for model in pairs(state.palletEspElements) do removePalletESP(model) end
	else pcall(scanVaultAndPallet) end
end })

state.ui.ESPBox = state.ui.Tabs.ESP:Section({ Title = "Killer ESP", Icon = "eye", Side = "Left" })
state.ui.ESPBox:Toggle({ Title = "Enable Killer ESP", Default = state.cfg.esp_enabled, Callback = function(v) state.cfg.esp_enabled = v end })
state.ui.ESPBox:Toggle({ Title = "Show 3D Highlight", Default = state.cfg.esp_showHighlight, Callback = function(v) state.cfg.esp_showHighlight = v end })
state.ui.ESPBox:Toggle({ Title = "Show Name", Default = state.cfg.esp_showName, Callback = function(v) state.cfg.esp_showName = v end })
state.ui.ESPBox:Slider({ Title = "Max Distance", Default = state.cfg.esp_maxDist, Min = 50, Max = 1000, Step = 1, Suffix = " studs", Callback = function(v) state.cfg.esp_maxDist = v end })

state.ui.SCPEspBox = state.ui.Tabs.ESP:Section({ Title = "SCP ESP", Icon = "ghost", Side = "Left" })
state.ui.SCPEspBox:Toggle({ Title = "Enable SCP ESP", Default = false, Callback = function(v)
	state.cfg.scp_esp_enabled = v
	if not v then for model in pairs(state.scpEspElements or {}) do removeSCPESP(model) end end
end })

state.ui.GenESPBox = state.ui.Tabs.ESP:Section({ Title = "Generator ESP", Icon = "wrench", Side = "Right" })
state.ui.GenESPBox:Toggle({ Title = "Enable Generator ESP", Default = false, Callback = function(v)
	state.genEspEnabled = v
	if v then pcall(initialScanGen)
	else for model in pairs(state.genEspElements or {}) do removeGenESP(model) end end
end })
state.ui.GenESPBox:Toggle({ Title = "Enable Bear Trap ESP", Default = false, Callback = function(v)
	state.bearTrapEspEnabled = v
	if v then pcall(initialScanBearTrap)
	else for model in pairs(state.bearTrapEspElements or {}) do removeBearTrapESP(model) end end
end })
state.ui.GenESPBox:Toggle({ Title = "Enable Pumpkin ESP", Default = false, Callback = function(v)
	state.pumpkinEspEnabled = v
	if v then pcall(scanPumpkins)
	else for model in pairs(state.pumpkinEspElements or {}) do removePumpkinESP(model) end end
end })

state.ui.PlayerESPBox = state.ui.Tabs.ESP:Section({ Title = "Player ESP", Icon = "users", Side = "Right" })
state.ui.PlayerESPBox:Toggle({ Title = "Enable Player ESP", Default = state.cfg.p_esp_enabled, Callback = function(v) state.cfg.p_esp_enabled = v end })
state.ui.PlayerESPBox:Toggle({ Title = "Show 3D Highlight", Default = state.cfg.p_esp_showHighlight, Callback = function(v) state.cfg.p_esp_showHighlight = v end })
state.ui.PlayerESPBox:Toggle({ Title = "Show Name", Default = state.cfg.p_esp_showName, Callback = function(v) state.cfg.p_esp_showName = v end })
state.ui.PlayerESPBox:Slider({ Title = "Max Distance", Default = state.cfg.p_esp_maxDist, Min = 50, Max = 1000, Step = 1, Suffix = " studs", Callback = function(v) state.cfg.p_esp_maxDist = v end })
state.ui.PlayerESPBox:Toggle({
    Title    = "Enable Me ESP",
    Default  = false,
    Callback = function(v)
        state.cfg.meEsp_enabled = v
        if v then
            createMeESP()
        else
            removeMeESP()
        end
    end,
})
state.ui.Map = state.ui.Tabs.World:Section({ Title = "Visual", Icon = "globe", Side = "Left" })
state.ui.Map:Toggle({
    Title    = "Custom FOV",
    Default  = false,
    Callback = function(v)
        state.cfg.cameraFov_enabled = v
        if not v then
            workspace.CurrentCamera.FieldOfView = 70
        end
    end,
})
state.ui.Map:Slider({
    Title    = "Camera FOV",
    Default  = 70,
    Min      = 30,
    Max      = 120,
    Step     = 1,
    Suffix   = "°",
    Callback = function(v)
        state.cfg.cameraFov = v
    end,
})
task.spawn(function()
    while state.running do
        pcall(function()
            if state.cfg.cameraFov_enabled and workspace.CurrentCamera then
                workspace.CurrentCamera.FieldOfView = state.cfg.cameraFov
            end
        end)
        task.wait(0.1)
    end
end)
state.ui.Map:Toggle({ Title = "Full Bright", Default = false, Callback = function(v)
	state._fullbrightEnabled = v
	if v then applyFullBright() else restoreFullBright() end
end })
state.ui.Map:Toggle({ Title = "No Fog", Default = false, Callback = function(v)
	state._nofogEnabled = v
	if v then applyNoFog() else restoreNoFog() end
end })
state.ui.Map:Button({ Title = "Hop Server (Lowest Players)", Icon = "shuffle", Callback = function()
	if state._hopServerBusy then return end
	state._hopServerBusy = true
	OasisUI:Notify({ Title = "Server Hop", Content = "Searching for a low-population server...", Duration = 4 })
	task.spawn(function()
		local HttpService      = game:GetService("HttpService")
		local TeleportService  = game:GetService("TeleportService")
		local PlaceId          = game.PlaceId
		local JobId            = game.JobId
		local ok, result = pcall(function()
			return HttpService:JSONDecode(
				game:HttpGet("https://games.roblox.com/v1/games/" .. tostring(PlaceId)
					.. "/servers/Public?sortOrder=Asc&limit=100")
			)
		end)
		local data = ok and result and result.data
		local targetId
		if data then
			table.sort(data, function(a, b) return a.playing < b.playing end)
			for _, server in ipairs(data) do
				if server.id ~= JobId and server.playing < server.maxPlayers then
					targetId = server.id; break
				end
			end
		end
		if targetId then
			OasisUI:Notify({ Title = "Server Hop", Content = "Teleporting to server...", Duration = 3 })
			TeleportService:TeleportToPlaceInstance(PlaceId, targetId, lp)
		else
			OasisUI:Notify({ Title = "Server Hop", Content = "No available server found.", Duration = 4 })
			state._hopServerBusy = false
		end
	end)
end })

local spearGui = Instance.new("ScreenGui")
spearGui.Name           = "KKKK_VeilSpearVisuals"
spearGui.ResetOnSpawn   = false
spearGui.DisplayOrder   = 998
spearGui.IgnoreGuiInset = true
spearGui.Parent         = game:GetService("CoreGui")

state.render.veilFov = Drawing.new("Circle")
state.render.veilFov.Visible   = false
state.render.veilFov.Thickness = 1.5
state.render.veilFov.Color     = Color3.fromRGB(255, 255, 0)
state.render.veilFov.Filled    = false
state.render.veilFov.NumSides  = 64

local function _isHoldingVeilSpear()
    local char = lp.Character
    if char and char:GetAttribute("spearmode") == true then return true end
    if lp:GetAttribute("spearmode") == true then return true end
    return false
end

local function _getSpearSpeedFromCharge()
    local char = lp.Character
    local t = 0
    if char then
        local f = char:GetAttribute("spearcharge")
            or char:GetAttribute("Charge")
            or char:GetAttribute("SpearCharge")
        if type(f) == "number" then
            if f > 1 then f = f / 100 end
            t = f * 2
        end
    end
    if t < 1 then return math.max(15, t * 150)
    elseif t < 2 then return 142.5
    else return 165 end
end

OasisUI:OnUnload(function()
    state.running = false
    task.wait(0.1)

    pcall(speedModCleanup)
    if _G.skillconn then
        pcall(function() _G.skillconn:Disconnect() end)
        _G.skillconn = nil
    end

    state.pfRunning = false
    state.cfg.autoPumpkin_enabled = false
    state.pfToggleState = false
    pcall(pfStopStuck)
    pcall(pfClearDots)

    state.moonwalkEnabled = false
    pcall(function()
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.A, false, game)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.D, false, game)
    end)

    state.autoBreakGenAura_enabled = false
    state.render.cachedSilentTarget   = nil
    state.render.cachedCureTarget     = nil
    state.render.cachedSurvivorTarget = nil

    pcall(clearMapEspConns)
    pcall(stopFlashlightAim)
    pcall(restoreFullBright)
    pcall(restoreNoFog)
    pcall(lungeRestoreBoost)
    pcall(lungeRestoreMaxHold)
    pcall(fvUnpatch)
    pcall(fsClearAttr)

    if _lungeHbConn then
        pcall(function() _lungeHbConn:Disconnect() end)
        _lungeHbConn = nil
    end
    if state._fvAnimConn then
        pcall(function() state._fvAnimConn:Disconnect() end)
        state._fvAnimConn = nil
    end

    pcall(function()
        workspace.CurrentCamera.FieldOfView = 70
    end)

    -- restore namecall
    pcall(function()
        local mt2 = getrawmetatable(game)
        setreadonly(mt2, false)
        mt2.__namecall = oldNamecall
        setreadonly(mt2, true)
    end)

    -- destroy ESP
    for char in pairs(state.killer2DEspElements or {}) do pcall(removeKiller2DESP, char) end
    for char in pairs(state.player2DEspElements or {}) do pcall(removePlayer2DESP, char) end
    for model in pairs(state.scpEspElements or {}) do pcall(removeSCPESP, model) end
    for model in pairs(state.genEspElements or {}) do pcall(removeGenESP, model) end
    for model in pairs(state.bearTrapEspElements or {}) do pcall(removeBearTrapESP, model) end
    for model in pairs(state.pumpkinEspElements or {}) do pcall(removePumpkinESP, model) end
    for obj in pairs(state.vaultEspElements or {}) do pcall(removeVaultESP, obj) end
    for model in pairs(state.palletEspElements or {}) do pcall(removePalletESP, model) end

    for char, conns in pairs(state.killerAnimConns or {}) do
        for _, c in ipairs(conns) do pcall(c.Disconnect, c) end
    end

    -- remove Drawing objects
    pcall(function() state.render.fovCircle:Remove() end)
    pcall(function() state.render.lockLine:Remove() end)
    pcall(function() state.render.lockLineCure:Remove() end)
    pcall(function() state.render.lockLineSurv:Remove() end)

    -- destroy GUI
    pcall(function() espGui:Destroy() end)
    pcall(function() palletCountGui:Destroy() end)
    pcall(function() spearGui:Destroy() end)

    -- clear tables
    state.scpEspElements           = {}
    state.killer2DEspElements      = {}
    state.player2DEspElements      = {}
    state.genEspElements           = {}
    state.bearTrapEspElements      = {}
    state.pumpkinEspElements       = {}
    state.vaultEspElements         = {}
    state.palletEspElements        = {}
    state.killerAnimConns          = {}
    state.playerParryState         = {}
    state.monitoredPlayerAnimators = {}
    state.monitoredKillers         = {}

    _G.KKKkhub = nil
    print("[KKKK Hub v1.3] Unloaded!")
end)