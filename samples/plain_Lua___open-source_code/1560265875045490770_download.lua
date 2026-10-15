--ARXHub - unified local GUI

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
local AutoGrab = nil

if Env.ARXHubCleanup then
	pcall(Env.ARXHubCleanup)
end

Env.ARXHubSettings = Env.ARXHubSettings or {
	Position = UDim2.new(0, 20, 0.5, -175),
	RegularSpeed = 28.5,
	GiantSpeed = 34.8,
	CarpetSpeed = 140,
	RegularKey = Enum.KeyCode.B,
	GiantKey = Enum.KeyCode.C,
	JumpKey = Enum.KeyCode.J,
	CarpetKey = Enum.KeyCode.Q,
	AntiRagdollKey = Enum.KeyCode.R,
	TradeRegionKey = Enum.KeyCode.U,
	TradePlazaKey = Enum.KeyCode.P,
		BrainrotESPKey = Enum.KeyCode.N,
		CloneESPKey = Enum.KeyCode.M,
		MineESPKey = Enum.KeyCode.H,
		AntiTurretKey = Enum.KeyCode.G,
	LeaveKey = Enum.KeyCode.L,
	RagdollTechKey = Enum.KeyCode.T,
	InstantResetKey = Enum.KeyCode.K,
	RagdollSelfKey = Enum.KeyCode.Y,
	ShawnPosition = UDim2.new(0, 20, 0.5, 130),
	BannerPosition = UDim2.new(0.5, 0, 0, 16),
	BoosterMiniPosition = UDim2.new(0, 105, 0.5, 130),
	GlobalGuiLocked = false,
	QuickPanelPosition = UDim2.new(0, 12, 0, 60),
	CooldownPanelPosition = UDim2.new(0, 425, 0, 60),
	APSpamPosition = UDim2.new(0.5, -202, 0.25, 0),
	APConfigPosition = UDim2.new(0.08, 0, 0.12, 0),
	APConfigBubblePosition = UDim2.new(0.04, 0, 0.40, 0),
	DefensePosition = UDim2.new(0.5, -145, 0.5, -60),
	ActionsPosition = UDim2.new(0.5, 155, 0.5, -100),
	ActionsWidth = 270,
	ActionsHeight = 200,
	PanelScales = {},
	PanelSizes = {},
	AutoPotion = false,
	ESP = false,
	Regular = false,
	Giant = false,
	Jump = false,
	Carpet = false,
	BaseESP = false,
	AntiRagdoll = false,
	AntiDrop = false,
	TradeRegionBlock = false,
	TradePlazaBlock = false,
	Aimbot = false,
	QuickPanel = true,
	CooldownPanel = false,
	APSpam = false,
	DefensePanel = false,
	ActionsPanel = false,
	AutoDefense = false,
	AntiIntruder = false,
	BrainrotESP = false,
	CloneESP = false,
	MineESP = false,
	AntiTurret = false,
}

local Settings = Env.ARXHubSettings
Settings.QuickPanelPosition = Settings.QuickPanelPosition or UDim2.new(0, 12, 0, 60)
Settings.BannerPosition = Settings.BannerPosition or UDim2.new(0.5, 0, 0, 16)
Settings.CooldownPanelPosition = Settings.CooldownPanelPosition or UDim2.new(0, 425, 0, 60)
Settings.APSpamPosition = Settings.APSpamPosition or UDim2.new(0.5, -202, 0.25, 0)
Settings.APConfigPosition = Settings.APConfigPosition or UDim2.new(0.08, 0, 0.12, 0)
Settings.APConfigBubblePosition = Settings.APConfigBubblePosition or UDim2.new(0.04, 0, 0.40, 0)
Settings.DefensePosition = Settings.DefensePosition or UDim2.new(0.5, -145, 0.5, -60)
Settings.ActionsPosition = Settings.ActionsPosition or UDim2.new(0.5, 155, 0.5, -100)
Settings.ActionsWidth = math.clamp(tonumber(Settings.ActionsWidth) or 270, 230, 420)
Settings.ActionsHeight = math.clamp(tonumber(Settings.ActionsHeight) or 250, 220, 420)
Settings.PanelScales = type(Settings.PanelScales) == "table" and Settings.PanelScales or {}
Settings.PanelSizes = type(Settings.PanelSizes) == "table" and Settings.PanelSizes or {}
Settings.BoosterMiniPosition = Settings.BoosterMiniPosition or UDim2.new(0, 105, 0.5, 130)
Settings.GlobalGuiLocked = Settings.GlobalGuiLocked == true
local SETTINGS_FILE = "ARXHub_Settings.json"

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
	return key == Enum.KeyCode.Unknown and "" or key.Name
end

-- Executor file storage survives teleports/rejoins when file APIs are available.
if typeof(isfile) == "function" and typeof(readfile) == "function" and isfile(SETTINGS_FILE) then
	pcall(function()
		local saved = HttpService:JSONDecode(readfile(SETTINGS_FILE))
		if type(saved.PanelScales) == "table" then Settings.PanelScales = saved.PanelScales end
		if type(saved.PanelSizes) == "table" then Settings.PanelSizes = saved.PanelSizes end
		Settings.RegularSpeed = saved.RegularSpeed or Settings.RegularSpeed
		Settings.GiantSpeed = saved.GiantSpeed or Settings.GiantSpeed
		Settings.CarpetSpeed = saved.CarpetSpeed or Settings.CarpetSpeed
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
		Settings.AntiTurretKey = keyFromName(saved.AntiTurretKey, Settings.AntiTurretKey)
		Settings.LeaveKey = keyFromName(saved.LeaveKey, Settings.LeaveKey)
		Settings.RagdollTechKey = keyFromName(saved.RagdollTechKey, Settings.RagdollTechKey)
		Settings.InstantResetKey = keyFromName(saved.InstantResetKey or saved.ResetCharacterKey,
			Settings.InstantResetKey or Settings.ResetCharacterKey or Enum.KeyCode.K)
		Settings.RagdollSelfKey = keyFromName(saved.RagdollSelfKey, Settings.RagdollSelfKey)
		Settings.Position = arrayToPosition(saved.Position, Settings.Position)
		Settings.ShawnPosition = arrayToPosition(saved.ShawnPosition, Settings.ShawnPosition)
		Settings.BannerPosition = arrayToPosition(saved.BannerPosition, Settings.BannerPosition)
		Settings.BoosterMiniPosition = arrayToPosition(saved.BoosterMiniPosition, Settings.BoosterMiniPosition)
		Settings.GlobalGuiLocked = saved.GlobalGuiLocked == true
		Settings.QuickPanelPosition = arrayToPosition(saved.QuickPanelPosition, Settings.QuickPanelPosition)
		Settings.CooldownPanelPosition = arrayToPosition(saved.CooldownPanelPosition, Settings.CooldownPanelPosition)
		Settings.APSpamPosition = arrayToPosition(saved.APSpamPosition, Settings.APSpamPosition)
		Settings.APConfigPosition = arrayToPosition(saved.APConfigPosition, Settings.APConfigPosition)
		Settings.APConfigBubblePosition = arrayToPosition(saved.APConfigBubblePosition, Settings.APConfigBubblePosition)
		Settings.DefensePosition = arrayToPosition(saved.DefensePosition, Settings.DefensePosition)
		Settings.ActionsPosition = arrayToPosition(saved.ActionsPosition, Settings.ActionsPosition)
		Settings.ActionsWidth = math.clamp(tonumber(saved.ActionsWidth) or Settings.ActionsWidth or 270, 230, 420)
		Settings.ActionsHeight = math.clamp(tonumber(saved.ActionsHeight) or Settings.ActionsHeight or 250, 220, 420)
		Settings.AutoPotion = saved.AutoPotion == true
		Settings.ESP = saved.ESP == true
		Settings.Regular = saved.Regular == true
		Settings.Giant = saved.Giant == true
		Settings.Jump = saved.Jump == true
		Settings.Carpet = saved.Carpet == true
		Settings.BaseESP = saved.BaseESP == true
		Settings.AntiRagdoll = saved.AntiRagdoll == true
		Settings.AntiDrop = saved.AntiDrop == true
		Settings.TradeRegionBlock = saved.TradeRegionBlock == true
		Settings.TradePlazaBlock = saved.TradePlazaBlock == true
		Settings.Aimbot = saved.Aimbot == true
		Settings.QuickPanel = saved.QuickPanel ~= false
		Settings.CooldownPanel = saved.CooldownPanel == true
		Settings.APSpam = saved.APSpam == true
		Settings.DefensePanel = saved.DefensePanel == true
		Settings.ActionsPanel = saved.ActionsPanel == true
		Settings.AutoDefense = saved.AutoDefense == true
		Settings.AntiIntruder = saved.AntiIntruder == true
		Settings.BrainrotESP = saved.BrainrotESP == true
		Settings.CloneESP = saved.CloneESP == true
		Settings.MineESP = saved.MineESP == true
		Settings.AntiTurret = saved.AntiTurret == true
		Settings.APSelectedCommands = type(saved.APSelectedCommands) == "table" and saved.APSelectedCommands or Settings.APSelectedCommands
	end)
end
local MAX_SPEED = 40
local MAX_CARPET_SPEED = 180
local RegularSpeed = math.clamp(tonumber(Settings.RegularSpeed) or 28.5, 0, MAX_SPEED)
local GiantSpeed = math.clamp(tonumber(Settings.GiantSpeed) or 34.8, 0, MAX_SPEED)
local CarpetSpeed = math.clamp(tonumber(Settings.CarpetSpeed) or 140, 0, MAX_CARPET_SPEED)
local RegularKey = Settings.RegularKey or Enum.KeyCode.B
local GiantKey = Settings.GiantKey or Enum.KeyCode.C
local JumpKey = Settings.JumpKey or Enum.KeyCode.J
local CarpetKey = Settings.CarpetKey or Enum.KeyCode.V
local AntiRagdollKey = Settings.AntiRagdollKey or Enum.KeyCode.R
local TradeRegionKey = Settings.TradeRegionKey or Enum.KeyCode.U
local TradePlazaKey = Settings.TradePlazaKey or Enum.KeyCode.P
local LeaveKey = Settings.LeaveKey or Enum.KeyCode.L
local ActionControls = {
	RagdollTechKey = Settings.RagdollTechKey or Enum.KeyCode.T,
	InstantResetKey = Settings.InstantResetKey or Enum.KeyCode.K,
	RagdollSelfKey = Settings.RagdollSelfKey or Enum.KeyCode.Y,
	Buttons = {},
	Run = {},
}

local State = {
	AutoPotion = Settings.AutoPotion == true,
	ESP = Settings.ESP == true,
	Regular = Settings.Regular == true,
	Giant = Settings.Giant == true,
	Jump = Settings.Jump == true,
	Carpet = Settings.Carpet == true,
	BaseESP = Settings.BaseESP == true,
	AntiRagdoll = Settings.AntiRagdoll == true,
	AntiDrop = Settings.AntiDrop == true,
	TradeRegionBlock = Settings.TradeRegionBlock == true,
	TradePlazaBlock = Settings.TradePlazaBlock == true,
	Aimbot = Settings.Aimbot == true,
	QuickPanel = Settings.QuickPanel ~= false,
	CooldownPanel = Settings.CooldownPanel == true,
	APSpam = Settings.APSpam == true,
	DefensePanel = Settings.DefensePanel == true,
	ActionsPanel = Settings.ActionsPanel == true,
	AutoDefense = Settings.AutoDefense == true,
	AntiIntruder = Settings.AntiIntruder == true,
	BrainrotESP = Settings.BrainrotESP == true,
	CloneESP = Settings.CloneESP == true,
	MineESP = Settings.MineESP == true,
	AntiTurret = Settings.AntiTurret == true,
	WaitingForKey = nil,
}

-- Bridge saved Anti Drop into standalone module
Env.ARXAntiDropDesired = State.AntiDrop == true


local Main, ShawnButton, HubBanner, BoosterMini, QuickPanel, CooldownPanel, APSpamPanel, APConfigFrame, APConfigBubble, DefensePanel, ActionsPanel
local GlobalLockButton

local function applyGlobalGuiLock()

-- Mobile scale-step button (shrink/expand panel on tap)
do
	local isMobScale = UIS.TouchEnabled and not UIS.KeyboardEnabled
	if isMobScale then
		local ScaleBtn = Instance.new("TextButton")
		ScaleBtn.Name = "ARXScaleToggle"
		ScaleBtn.Size = UDim2.fromOffset(62, 24)
		ScaleBtn.Position = UDim2.new(1, -160, 0, 8)
		ScaleBtn.BackgroundColor3 = Color3.fromRGB(16, 28, 50)
		ScaleBtn.TextColor3 = Color3.fromRGB(0, 200, 255)
		ScaleBtn.TextSize = 9
		ScaleBtn.Font = Enum.Font.GothamBold
		ScaleBtn.Text = "⊟ SMALL"
		ScaleBtn.AutoButtonColor = false
		ScaleBtn.ZIndex = 500
		ScaleBtn.Parent = Main
		Instance.new("UICorner", ScaleBtn).CornerRadius = UDim.new(0, 6)
		local scaleBtnStroke = Instance.new("UIStroke", ScaleBtn)
		scaleBtnStroke.Color = Color3.fromRGB(0, 140, 200)
		scaleBtnStroke.Thickness = 0.8
		local compact = false
		connect(ScaleBtn.MouseButton1Click, function()
			compact = not compact
			if compact then
				-- Compact: 70% scale, repositioned
				TweenService:Create(MainScale,
					TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
					{Scale = 0.68}):Play()
				ScaleBtn.Text = "⊞ BIG"
			else
				-- Full: restore auto scale
				local cam = workspace.CurrentCamera
				local vp = cam and cam.ViewportSize or Vector2.new(800, 600)
				local shortEdge = math.min(vp.X, vp.Y)
				local s = math.clamp((shortEdge - 20) / 390, 0.55, 1.0)
				TweenService:Create(MainScale,
					TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
					{Scale = s}):Play()
				ScaleBtn.Text = "⊟ SMALL"
			end
		end)
		connect(ScaleBtn.TouchTap, function()
			ScaleBtn.MouseButton1Click:Fire()
		end)
	end
end
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
	apply(DefensePanel)
	apply(ActionsPanel)
	Env.ARXGlobalGuiLocked = locked
	if type(Env.ARXPriorityApplyGlobalLock) == "function" then
		pcall(Env.ARXPriorityApplyGlobalLock)
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
	Settings.RagdollTechKey = ActionControls.RagdollTechKey
	Settings.InstantResetKey = ActionControls.InstantResetKey
	Settings.RagdollSelfKey = ActionControls.RagdollSelfKey
	Settings.AutoPotion = State.AutoPotion
	Settings.ESP = State.ESP
	Settings.Regular = State.Regular
	Settings.Giant = State.Giant
	Settings.Jump = State.Jump
	Settings.Carpet = State.Carpet
	Settings.BaseESP = State.BaseESP
	Settings.AntiRagdoll = State.AntiRagdoll
	Settings.AntiDrop = State.AntiDrop
	Settings.TradeRegionBlock = State.TradeRegionBlock
	Settings.TradePlazaBlock = State.TradePlazaBlock
	Settings.Aimbot = State.Aimbot
	Settings.QuickPanel = State.QuickPanel
	Settings.CooldownPanel = State.CooldownPanel
	Settings.APSpam = State.APSpam
	Settings.DefensePanel = State.DefensePanel
	Settings.ActionsPanel = State.ActionsPanel
	Settings.AutoDefense = State.AutoDefense
	Settings.AntiIntruder = State.AntiIntruder
	Settings.BrainrotESP = State.BrainrotESP
	Settings.CloneESP = State.CloneESP
	Settings.MineESP = State.MineESP
	Settings.AntiTurret = State.AntiTurret
	if Main then Settings.Position = Main.Position end
	if ShawnButton then Settings.ShawnPosition = ShawnButton.Position end
	if HubBanner then Settings.BannerPosition = HubBanner.Position end
	if BoosterMini then Settings.BoosterMiniPosition = BoosterMini.Position end
	if QuickPanel then Settings.QuickPanelPosition = QuickPanel.Position end
	if CooldownPanel then Settings.CooldownPanelPosition = CooldownPanel.Position end
	if APSpamPanel then Settings.APSpamPosition = APSpamPanel.Position end
	if APConfigFrame then Settings.APConfigPosition = APConfigFrame.Position end
	if APConfigBubble then Settings.APConfigBubblePosition = APConfigBubble.Position end
	if DefensePanel then Settings.DefensePosition = DefensePanel.Position end
	if ActionsPanel then
		Settings.ActionsPosition = ActionsPanel.Position
		Settings.ActionsWidth = math.clamp(ActionsPanel.Size.X.Offset, 230, 420)
		Settings.ActionsHeight = math.clamp(ActionsPanel.Size.Y.Offset, 195, 360)
	end

	if typeof(writefile) == "function" then
		local payload = {
			RegularSpeed = RegularSpeed,
			GiantSpeed = GiantSpeed,
			CarpetSpeed = CarpetSpeed,
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
			AntiTurretKey = Settings.AntiTurretKey.Name,
			LeaveKey = LeaveKey.Name,
			RagdollTechKey = ActionControls.RagdollTechKey.Name,
			InstantResetKey = ActionControls.InstantResetKey.Name,
			RagdollSelfKey = ActionControls.RagdollSelfKey.Name,
			Position = positionToArray(Settings.Position),
			ShawnPosition = positionToArray(Settings.ShawnPosition),
			BannerPosition = positionToArray(Settings.BannerPosition),
			BoosterMiniPosition = positionToArray(Settings.BoosterMiniPosition),
			GlobalGuiLocked = Settings.GlobalGuiLocked,
			QuickPanelPosition = positionToArray(Settings.QuickPanelPosition),
			CooldownPanelPosition = positionToArray(Settings.CooldownPanelPosition),
			APSpamPosition = positionToArray(Settings.APSpamPosition),
			APConfigPosition = positionToArray(Settings.APConfigPosition),
			APConfigBubblePosition = positionToArray(Settings.APConfigBubblePosition),
			DefensePosition = positionToArray(Settings.DefensePosition),
			ActionsPosition = positionToArray(Settings.ActionsPosition),
			ActionsWidth = Settings.ActionsWidth,
			ActionsHeight = Settings.ActionsHeight,
			PanelScales = Settings.PanelScales,
			PanelSizes = Settings.PanelSizes,
			AutoPotion = State.AutoPotion,
			ESP = State.ESP,
			Regular = State.Regular,
			Giant = State.Giant,
			Jump = State.Jump,
			Carpet = State.Carpet,
			BaseESP = State.BaseESP,
			AntiRagdoll = State.AntiRagdoll,
			AntiDrop = State.AntiDrop,
			TradeRegionBlock = State.TradeRegionBlock,
			TradePlazaBlock = State.TradePlazaBlock,
			Aimbot = State.Aimbot,
			QuickPanel = State.QuickPanel,
			CooldownPanel = State.CooldownPanel,
			APSpam = State.APSpam,
			DefensePanel = State.DefensePanel,
			ActionsPanel = State.ActionsPanel,
			AutoDefense = State.AutoDefense,
			AntiIntruder = State.AntiIntruder,
			BrainrotESP = State.BrainrotESP,
			CloneESP = State.CloneESP,
			MineESP = State.MineESP,
			AntiTurret = State.AntiTurret,
			APSelectedCommands = Settings.APSelectedCommands,
		}
		pcall(writefile, SETTINGS_FILE, HttpService:JSONEncode(payload))
	end
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

-- Speed booster (replaced with the implementation from the second source).
local SpeedForce, SpeedAttachment, SpeedRoot

local function removeSpeedForce()
	if SpeedForce then SpeedForce:Destroy(); SpeedForce = nil end
	if SpeedAttachment then SpeedAttachment:Destroy(); SpeedAttachment = nil end
	SpeedRoot = nil
end

local function buildSpeedForce(root)
	if SpeedForce and SpeedAttachment and SpeedRoot == root then return end
	removeSpeedForce()
	SpeedRoot = root
	SpeedAttachment = Instance.new("Attachment")
	SpeedAttachment.Name = "ARXSpeedAttachment"
	SpeedAttachment.Parent = root
	SpeedForce = Instance.new("LinearVelocity")
	SpeedForce.Name = "ARXSpeedForce"
	SpeedForce.Attachment0 = SpeedAttachment
	SpeedForce.RelativeTo = Enum.ActuatorRelativeTo.World
	SpeedForce.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
	SpeedForce.ForceLimitMode = Enum.ForceLimitMode.PerAxis
	SpeedForce.MaxAxesForce = Vector3.new(math.huge, 0, math.huge)
	SpeedForce.VectorVelocity = Vector3.zero
	SpeedForce.Enabled = false
	SpeedForce.Parent = root
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
	return nil
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
local AutoBigPotionBridge = {
	enabled = true,
	activate = function()
		return activatePotion(true, true)
	end,
}
Env.AutoBigPotion = AutoBigPotionBridge
_G.AutoBigPotion = AutoBigPotionBridge

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
	return nil
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
	highlight.FillColor = Color3.fromRGB(255, 20, 80)
	highlight.FillTransparency = 0.55
	highlight.OutlineColor = Color3.fromRGB(0, 230, 255)
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
	label.Font = Enum.Font.GothamBold
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
	if not data then
		local billboard = Instance.new("BillboardGui")
		billboard.Name = "ARXTimerESP"
		billboard.Size = UDim2.fromOffset(140, 36)
		billboard.StudsOffset = Vector3.new(0, 2.2, 0)
		billboard.AlwaysOnTop = true
		billboard.LightInfluence = 0
		billboard.MaxDistance = math.huge
		billboard.Parent = PlayerGui
		local label = Instance.new("TextLabel")
		label.Size = UDim2.fromScale(1, 1)
		label.BackgroundTransparency = 1
		label.Font = Enum.Font.GothamBold
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
	if not data then
		local billboard = Instance.new("BillboardGui")
		billboard.Name = "ARXBaseAllowESP"
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
		label.Font = Enum.Font.SourceSansBold
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

-- Anti Ragdoll (adapted from the supplied source)
local AntiRagdollConnection
local RagdollRecoveryUntil = 0
local LastUsableWalkSpeed = 16
local LastUsableJumpPower = 50

local function setRagdollStates(enabled)
	local humanoid = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
	if not humanoid then return end
	pcall(function()
		humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, enabled)
		humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, enabled)
	end)
end

local function resetFromRagdoll(character)
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	local root = character and character:FindFirstChild("HumanoidRootPart")
	if not humanoid or not root or humanoid.Health <= 0 then return end

	pcall(function()
		root.Anchored = false
		root.RotVelocity = Vector3.zero
		humanoid.PlatformStand = false
		humanoid.Sit = false
		humanoid.AutoRotate = true
		if humanoid.WalkSpeed <= 0 then humanoid.WalkSpeed = LastUsableWalkSpeed end
		if humanoid.UseJumpPower and humanoid.JumpPower <= 0 then humanoid.JumpPower = LastUsableJumpPower end

		for _, object in ipairs(character:GetDescendants()) do
			if object:IsA("Motor6D") then
				object.Enabled = true
			elseif object:IsA("BallSocketConstraint") or object:IsA("HingeConstraint")
				or (object:IsA("Constraint") and object.Name:lower():find("ragdoll", 1, true)) then
				object.Enabled = false
			end
		end

		for _, object in ipairs({LP, character, humanoid}) do
			for _, attribute in ipairs({"Ragdoll", "Ragdolled", "IsRagdolled", "isRagdolled", "PlatformStand"}) do
				if object:GetAttribute(attribute) ~= nil then object:SetAttribute(attribute, false) end
			end
		end

		humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
		workspace.CurrentCamera.CameraSubject = humanoid
		humanoid:ChangeState(Enum.HumanoidStateType.Running)

		local playerModule = LP:FindFirstChild("PlayerScripts") and LP.PlayerScripts:FindFirstChild("PlayerModule")
		if playerModule then
			local ok, module = pcall(require, playerModule)
			if ok and module and type(module.GetControls) == "function" then
				local controls = module:GetControls()
				if controls and type(controls.Enable) == "function" then controls:Enable() end
			end
		end
	end)
end

local function stopAntiRagdoll()
	if AntiRagdollConnection then
		AntiRagdollConnection:Disconnect()
		AntiRagdollConnection = nil
	end
	setRagdollStates(true)
end

local function startAntiRagdoll()
	if AntiRagdollConnection or not State.AntiRagdoll then return end
	setRagdollStates(false)
	AntiRagdollConnection = RunService.Heartbeat:Connect(function()
		if not State.AntiRagdoll or Env._FH_LAUNCHING then return end
		local character = LP.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		local root = character and character:FindFirstChild("HumanoidRootPart")
		if not humanoid or not root then return end

		local state = humanoid:GetState()
		local jumping = State.Jump and UIS:IsKeyDown(Enum.KeyCode.Space)
		local ragdollAttribute = false
		for _, object in ipairs({LP, character, humanoid}) do
			for _, attribute in ipairs({"Ragdoll", "Ragdolled", "IsRagdolled", "isRagdolled"}) do
				local value = object:GetAttribute(attribute)
				if value == true or value == 1 then ragdollAttribute = true; break end
			end
			if ragdollAttribute then break end
		end
		local rigBroken = false
		for _, object in ipairs(character:GetDescendants()) do
			if (object:IsA("Motor6D") and not object.Enabled)
				or ((object:IsA("BallSocketConstraint") or object:IsA("HingeConstraint")) and object.Enabled) then
				rigBroken = true
				break
			end
		end
		local ragdolling =
			state == Enum.HumanoidStateType.Physics
			or state == Enum.HumanoidStateType.Ragdoll
			or (state == Enum.HumanoidStateType.FallingDown and not jumping)
			or state == Enum.HumanoidStateType.GettingUp
			or humanoid.PlatformStand == true
			or humanoid.Sit == true
			or root.Anchored == true
			or ragdollAttribute
			or rigBroken

		if not ragdolling and humanoid.WalkSpeed > 0 then
			LastUsableWalkSpeed = humanoid.WalkSpeed
			if humanoid.UseJumpPower and humanoid.JumpPower > 0 then LastUsableJumpPower = humanoid.JumpPower end
		end
		if ragdolling and not jumping then RagdollRecoveryUntil = os.clock() + 0.65 end
		if not jumping and os.clock() < RagdollRecoveryUntil then
			resetFromRagdoll(character)
		end
	end)
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
		blocker.Name = "ARXTradeRegionBlocker"
		blocker.Size = UDim2.fromScale(1, 1)
		blocker.BackgroundTransparency = 1
		blocker.Text = ""
		blocker.Active = true
		blocker.AutoButtonColor = false
		blocker.ZIndex = buttonObject.ZIndex + 50
		blocker.Parent = buttonObject
		data.blocker = blocker
		local note = Instance.new("TextLabel")
		note.Name = "ARXRegionNote"
		note.AnchorPoint = Vector2.new(0.5, 0)
		note.Position = UDim2.new(0.5, 0, 1, 2)
		note.Size = UDim2.new(1, -4, 0, 12)
		note.BackgroundTransparency = 1
		note.Text = NOTE
		note.TextColor3 = Color3.fromRGB(140, 140, 150)
		note.TextSize = 10
		note.Font = Enum.Font.Gotham
		note.TextTruncate = Enum.TextTruncate.AtEnd
		note.ZIndex = buttonObject.ZIndex + 5
		note.Parent = buttonObject
		data.note = note
		if confirmation then
			local prompt = buttonObject.Parent
			while prompt and prompt.Name ~= "Prompt" do prompt = prompt.Parent end
			if prompt then
				local banner = Instance.new("TextLabel")
				banner.Name = "ARXRegionWarning"
				banner.Size = UDim2.new(1, -16, 0, 50)
				banner.Position = UDim2.new(0, 8, 0, 8)
				banner.BackgroundColor3 = Color3.fromRGB(28, 29, 34)
				banner.Text = "⚠  Trade Unavailable\nTrading is unavailable in your region due to local restrictions. (Error Code: 280)"
				banner.TextColor3 = Color3.fromRGB(225, 226, 232)
				banner.TextSize = 11
				banner.TextWrapped = true
				banner.Font = Enum.Font.GothamMedium
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
							badge.Name = "ARXRegionLockBadge"
							badge.Size = UDim2.fromOffset(116, 18)
							badge.Position = UDim2.new(1, 4, 0.5, -9)
							badge.BackgroundColor3 = Color3.fromRGB(42, 45, 54)
							badge.Text = "Region Restricted"
							badge.TextColor3 = Color3.fromRGB(190, 194, 205)
							badge.TextSize = 10
							badge.Font = Enum.Font.GothamMedium
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
local old = PlayerGui:FindFirstChild("ARXHubGUI")
if old then
	local oldMain = old:FindFirstChild("Main")
	if oldMain then Settings.Position = oldMain.Position end
	old:Destroy()
end

local GUI = Instance.new("ScreenGui")
GUI.Name = "ARXHubGUI"
GUI.ResetOnSpawn = false
GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
GUI.DisplayOrder = 999999
GUI.IgnoreGuiInset = true
GUI.Enabled = true
pcall(function()
	if gethui then
		GUI.Parent = gethui()
	else
		GUI.Parent = game:GetService("CoreGui")
	end
end)
if not GUI.Parent then
	GUI.Parent = PlayerGui
end

-- ARX hub banner, adapted from the supplied Faded Hub banner.
HubBanner = Instance.new("Frame")
HubBanner.Name = "ARXsHubBanner"
HubBanner.AnchorPoint = Vector2.new(0.5, 0)
HubBanner.Size = UDim2.fromOffset(280, 96)
HubBanner.Position = (Settings.BannerPosition) or UDim2.new(0.5, 0, 0, 16)
HubBanner.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
HubBanner.BackgroundTransparency = 0.45
HubBanner.BorderSizePixel = 0
HubBanner.Active = true
HubBanner.Draggable = not Settings.GlobalGuiLocked
HubBanner.ZIndex = 100000
HubBanner.Parent = GUI
Instance.new("UICorner", HubBanner).CornerRadius = UDim.new(0, 10)
local bannerStroke = Instance.new("UIStroke", HubBanner)
bannerStroke.Color = Color3.fromRGB(110, 145, 255)
bannerStroke.Thickness = 2
local bannerGradient = Instance.new("UIGradient", bannerStroke)
bannerGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 180, 255)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(160, 0, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 140, 0)),
	})
bannerGradient.Rotation = 90

local BannerTitle = Instance.new("TextLabel")
BannerTitle.Size = UDim2.new(1, 0, 0, 26)
BannerTitle.Position = UDim2.fromOffset(0, 8)
BannerTitle.BackgroundTransparency = 1
BannerTitle.Text = "ARX HUB"
BannerTitle.TextColor3 = Color3.new(1, 1, 1)
BannerTitle.TextSize = 22
BannerTitle.Font = Enum.Font.GothamBlack
BannerTitle.TextXAlignment = Enum.TextXAlignment.Center
BannerTitle.TextYAlignment = Enum.TextYAlignment.Center
BannerTitle.ZIndex = 100001
BannerTitle.Active = true
BannerTitle.Parent = HubBanner

local BannerDev = Instance.new("TextLabel")
BannerDev.Size = UDim2.new(1, 0, 0, 18)
BannerDev.Position = UDim2.fromOffset(0, 34)
BannerDev.BackgroundTransparency = 1
BannerDev.Text = "@arx  •  Steal a Brainrot"
BannerDev.TextColor3 = Color3.fromRGB(180, 180, 180)
BannerDev.TextSize = 11
BannerDev.Font = Enum.Font.GothamMedium
BannerDev.TextXAlignment = Enum.TextXAlignment.Center
BannerDev.TextYAlignment = Enum.TextYAlignment.Center
BannerDev.ZIndex = 100001
BannerDev.Active = true
BannerDev.Parent = HubBanner

local BannerDiscord = Instance.new("TextLabel")
BannerDiscord.Size = UDim2.new(1, 0, 0, 16)
BannerDiscord.Position = UDim2.fromOffset(0, 52)
BannerDiscord.BackgroundTransparency = 1
BannerDiscord.Text = "discord.gg/arxtp"
BannerDiscord.TextColor3 = Color3.fromRGB(88, 150, 255)
BannerDiscord.TextSize = 10
BannerDiscord.Font = Enum.Font.GothamMedium
BannerDiscord.TextXAlignment = Enum.TextXAlignment.Center
BannerDiscord.TextYAlignment = Enum.TextYAlignment.Center
BannerDiscord.ZIndex = 100001
BannerDiscord.Active = true
BannerDiscord.Parent = HubBanner

local BannerStats = Instance.new("TextLabel")
BannerStats.Size = UDim2.new(1, 0, 0, 18)
BannerStats.Position = UDim2.fromOffset(0, 68)
BannerStats.BackgroundTransparency = 1
BannerStats.Text = "FPS: --   PING: --ms"
BannerStats.TextColor3 = Color3.fromRGB(245, 245, 245)
BannerStats.TextSize = 12
BannerStats.Font = Enum.Font.GothamBold
BannerStats.TextXAlignment = Enum.TextXAlignment.Center
BannerStats.TextYAlignment = Enum.TextYAlignment.Center
BannerStats.ZIndex = 100001
BannerStats.Active = true
BannerStats.Parent = HubBanner

-- Drag hub name banner (PC + mobile touch)
do
	local dragging, dragStart, startPos = false, nil, nil
	local function onBegin(input)
		if Settings.GlobalGuiLocked then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = HubBanner.Position
		end
	end
	local function onChange(input)
		if not dragging or not dragStart or not startPos then return end
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			local d = input.Position - dragStart
			HubBanner.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
		end
	end
	local function onEnd(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			if dragging then
				dragging = false
				Settings.BannerPosition = HubBanner.Position
				queuePositionSave()
			end
		end
	end
	HubBanner.InputBegan:Connect(onBegin)
	BannerTitle.InputBegan:Connect(onBegin)
	BannerDev.InputBegan:Connect(onBegin)
	BannerStats.InputBegan:Connect(onBegin)
	connect(UIS.InputChanged, onChange)
	connect(UIS.InputEnded, onEnd)
	connect(HubBanner:GetPropertyChangedSignal("Position"), queuePositionSave)
end

local bannerFrameCount = 0
local bannerFrameTime = 0
connect(RunService.Heartbeat, function(dt)
	bannerFrameCount += 1
	bannerFrameTime += dt
	bannerGradient.Rotation = (bannerGradient.Rotation + dt * 35) % 360
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
Main.BackgroundColor3 = Color3.fromRGB(8, 9, 14)
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
	mainStrokeGradient.Rotation = (mainStrokeGradient.Rotation + dt * 28) % 360
end)
local MainScale = Instance.new("UIScale", Main)
-- Mobile-friendly scale for whole GUI
do
	local isMob = UIS.TouchEnabled and not UIS.KeyboardEnabled
	local function applyMobileScale()
		local cam = workspace.CurrentCamera
		local vp = cam and cam.ViewportSize or Vector2.new(800, 600)
		local shortEdge = math.min(vp.X, vp.Y)
		local longEdge  = math.max(vp.X, vp.Y)
		local s
		if isMob then
			-- phone: scale so main panel (390px) fits with 10px margin each side
			s = math.clamp((shortEdge - 20) / 390, 0.55, 1.0)
			-- very small screens (old phones ~360px) go even smaller
			if shortEdge < 380 then s = math.clamp(s * 0.92, 0.50, 0.80) end
		else
			-- tablet / PC: clamp to viewport
			s = math.clamp(math.min(vp.X / 420, vp.Y / 700), 0.75, 1.0)
		end
		MainScale.Scale = s
		if HubBanner then
			local bs = HubBanner:FindFirstChildOfClass("UIScale") or Instance.new("UIScale", HubBanner)
			bs.Name = "ARXMobileScale"
			bs.Scale = isMob and math.clamp(s, 0.85, 1.0) or 1
		end
	end
	applyMobileScale()
	pcall(function()
		workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(applyMobileScale)
	end)
end
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
ShawnButton.Size = UDim2.fromOffset(80, 34)
ShawnButton.Position = Settings.ShawnPosition or UDim2.new(0, 20, 0.5, 130)
ShawnButton.BackgroundColor3 = Color3.fromRGB(20, 18, 38)
ShawnButton.Text = "ARX"
ShawnButton.TextColor3 = Color3.new(1, 1, 1)
ShawnButton.TextSize = 13
ShawnButton.Font = Enum.Font.GothamBold
ShawnButton.AutoButtonColor = false
ShawnButton.Active = true
ShawnButton.Draggable = not Settings.GlobalGuiLocked
ShawnButton.Parent = GUI
Instance.new("UICorner", ShawnButton).CornerRadius = UDim.new(0, 9)
local shawnStroke = Instance.new("UIStroke", ShawnButton)
shawnStroke.Color = Color3.fromRGB(80, 200, 255)
shawnStroke.Thickness = 1.2

connect(ShawnButton:GetPropertyChangedSignal("Position"), function()
	Settings.ShawnPosition = ShawnButton.Position
	queuePositionSave()
end)

-- Mobile: enlarge launcher tap target + add touch handler
do
	local isMobBtn = UIS.TouchEnabled and not UIS.KeyboardEnabled
	if isMobBtn then
		ShawnButton.Size = UDim2.fromOffset(90, 42)
		ShawnButton.TextSize = 14
		ShawnButton.Text = "☰ ARX"
	end
end

connect(ShawnButton.MouseButton1Click, function()
	toggleMainPanel()
end)
-- Touch fallback for mobile
connect(ShawnButton.TouchTap, function()
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
GlobalLockButton.Font = Enum.Font.GothamBold
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
	if type(Env.ARXNotify) == "function" then
		Env.ARXNotify("All GUIs: " .. (Settings.GlobalGuiLocked and "LOCKED" or "MOVABLE"), not Settings.GlobalGuiLocked)
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
local function notify(message, enabled, customColor)
	NotificationOrder += 1
	local card = Instance.new("TextLabel")
	card.LayoutOrder = NotificationOrder
	card.Size = UDim2.fromOffset(248, 36)
	card.BackgroundColor3 = customColor or (enabled and Color3.fromRGB(30, 145, 78) or Color3.fromRGB(170, 48, 55))
	card.BackgroundTransparency = 0.08
	card.Text = "  " .. message
	card.TextColor3 = Color3.new(1, 1, 1)
	card.TextSize = 12
	card.Font = Enum.Font.GothamBold
	card.TextXAlignment = Enum.TextXAlignment.Left
	card.Parent = NotificationHolder
	Instance.new("UICorner", card).CornerRadius = UDim.new(0, 7)

	task.delay(2.4, function()
		if not card.Parent then return end
		local tween = game:GetService("TweenService"):Create(card, TweenInfo.new(0.25), {
			BackgroundTransparency = 1,
			TextTransparency = 1,
		})
		tween:Play()
		tween.Completed:Wait()
		card:Destroy()
	end)
end
Env.ARXNotify = notify

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
	return nil
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
	return nil
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
			local minuteNumber = tonumber(minutes) or 0
			local secondNumber = tonumber(seconds) or 0
			remoteRemaining = minutes
				and (minuteNumber * 60 + secondNumber)
				or (tonumber(text:match("%d+")) or 1)
		end
	end
	local usedAt = QuickLastCommandUse[commandName]
	local localRemaining = usedAt and math.max(0, (QuickCommandCooldowns[commandName] or 0) - (os.clock() - usedAt)) or 0
	return math.max(remoteRemaining, localRemaining)
end

Env.ARXCommandCooldownRemaining = quickCooldownRemaining
Env.ARXIsCommandOnCooldown = function(commandName)
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
QuickPanel.Name = "QuickPanel"
QuickPanel.Size = UDim2.fromOffset(404, 100)
QuickPanel.Position = Settings.QuickPanelPosition
QuickPanel.BackgroundColor3 = Color3.fromRGB(9, 13, 24)
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
QuickTitle.Size = UDim2.new(1, 0, 0, 38)
QuickTitle.BackgroundTransparency = 1
QuickTitle.Text = "QUICK PANEL"
QuickTitle.TextColor3 = Color3.fromRGB(245, 248, 255)
QuickTitle.TextSize = 15
QuickTitle.Font = Enum.Font.GothamBold
QuickTitle.Parent = QuickPanel

local CooldownButton = Instance.new("TextButton")
CooldownButton.Size = UDim2.fromOffset(86, 24)
CooldownButton.Position = UDim2.new(1, -94, 0, 7)
CooldownButton.BackgroundColor3 = Color3.fromRGB(34, 48, 78)
CooldownButton.Text = "COOLDOWNS"
CooldownButton.TextColor3 = Color3.fromRGB(225, 235, 255)
CooldownButton.TextSize = 9
CooldownButton.Font = Enum.Font.GothamBold
CooldownButton.AutoButtonColor = false
CooldownButton.Parent = QuickPanel
Instance.new("UICorner", CooldownButton).CornerRadius = UDim.new(0, 6)

CooldownPanel = Instance.new("Frame")
CooldownPanel.Name = "CommandCooldowns"
CooldownPanel.Size = UDim2.fromOffset(210, 286)
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
CooldownTitle.Size = UDim2.new(1, -48, 0, 32)
CooldownTitle.Position = UDim2.fromOffset(10, 0)
CooldownTitle.BackgroundTransparency = 1
CooldownTitle.Text = "COMMAND COOLDOWNS"
CooldownTitle.TextColor3 = Color3.fromRGB(240, 244, 255)
CooldownTitle.TextSize = 10
CooldownTitle.Font = Enum.Font.GothamBold
CooldownTitle.TextXAlignment = Enum.TextXAlignment.Left
CooldownTitle.TextTruncate = Enum.TextTruncate.AtEnd
CooldownTitle.ZIndex = 121
CooldownTitle.Parent = CooldownPanel

local CooldownClose = Instance.new("TextButton")
CooldownClose.Size = UDim2.fromOffset(22, 22)
CooldownClose.Position = UDim2.new(1, -28, 0, 5)
CooldownClose.BackgroundColor3 = Color3.fromRGB(42, 46, 60)
CooldownClose.Text = "×"
CooldownClose.TextColor3 = Color3.fromRGB(235, 235, 245)
CooldownClose.TextSize = 15
CooldownClose.Font = Enum.Font.GothamBold
CooldownClose.ZIndex = 122
CooldownClose.Parent = CooldownPanel
Instance.new("UICorner", CooldownClose).CornerRadius = UDim.new(0, 6)

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
	row.BackgroundColor3 = Color3.fromRGB(16, 18, 32)
	row.BorderSizePixel = 0
	row.ZIndex = 122
	row.Parent = CooldownBody
	Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)
	local bar = Instance.new("Frame")
	bar.Size = UDim2.fromOffset(3, 17)
	bar.Position = UDim2.fromOffset(4, 4)
	bar.BackgroundColor3 = Color3.fromRGB(0, 220, 180)
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
	label.Font = Enum.Font.GothamBold
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
	status.Font = Enum.Font.GothamBold
	status.TextXAlignment = Enum.TextXAlignment.Right
	status.ZIndex = 123
	status.Parent = row
	CooldownRows[command.Name] = {Status = status, Bar = bar}
end

connect(CooldownPanel:GetPropertyChangedSignal("Position"), function()
	Settings.CooldownPanelPosition = CooldownPanel.Position
	queuePositionSave()
end)
connect(CooldownButton.MouseButton1Click, function()
	State.CooldownPanel = not State.CooldownPanel
	CooldownPanel.Visible = State.CooldownPanel
	saveSettings()
	notify("Command Cooldowns: " .. (State.CooldownPanel and "OPEN" or "CLOSED"), State.CooldownPanel)
end)
connect(CooldownClose.MouseButton1Click, function()
	State.CooldownPanel = false
	CooldownPanel.Visible = false
	saveSettings()
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
QuickLine.Position = UDim2.fromOffset(12, 37)
QuickLine.BackgroundColor3 = Color3.fromRGB(0, 190, 255)
QuickLine.BorderSizePixel = 0
QuickLine.Parent = QuickPanel

local QuickBody = Instance.new("ScrollingFrame")
QuickBody.Position = UDim2.fromOffset(8, 45)
QuickBody.Size = UDim2.new(1, -16, 1, -51)
QuickBody.BackgroundTransparency = 1
QuickBody.BorderSizePixel = 0
QuickBody.ScrollBarThickness = 4
QuickBody.ScrollBarImageColor3 = Color3.fromRGB(0, 190, 255)
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
			row.BackgroundColor3 = Color3.fromRGB(10, 14, 28)
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
			playerName.Font = Enum.Font.GothamBold
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
				commandButton.BackgroundColor3 = Color3.fromRGB(18, 32, 60)
				commandButton.Text = command.Emoji
				commandButton.TextSize = 15
				commandButton.Font = Enum.Font.GothamBold
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
		empty.Font = Enum.Font.Gotham
		empty.Parent = QuickBody
	end
	local visibleRows = math.min(math.max(count, 1), 8)
	local autoWidth = 404
	local autoHeight = 51 + visibleRows * 50 + math.max(visibleRows - 1, 0) * 6 + 8
	if not Settings.PanelSizes.QuickPanel then
		QuickPanel.Size = UDim2.fromOffset(autoWidth, autoHeight)
	else
		local saved = Settings.PanelSizes.QuickPanel
		QuickPanel.Size = UDim2.fromOffset(
			math.clamp(tonumber(saved[1]) or autoWidth, 300, 620),
			math.clamp(tonumber(saved[2]) or autoHeight, 80, 620)
		)
	end
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
					or Color3.fromRGB(18, 32, 60)
			end
		end
		task.wait(0.15)
	end
end)

-- ARX AP SPAM uses the exact same command/player dispatcher as QUICK PANEL.
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
		if used > 0 then
			notify(string.format("AP %s → %s (%d)", mode:upper(), targetPlayer.DisplayName, used), true)
		else
			notify(string.format("AP %s → %s (%d)", mode:upper(), targetPlayer.DisplayName, used), false, Color3.fromRGB(190, 125, 35))
		end
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
APSpamPanel.Name = "ARXAPSpam"
APSpamPanel.Size = UDim2.fromScale(0.18, 0.36)
APSpamPanel.Position = Settings.APSpamPosition
APSpamPanel.BackgroundColor3 = Color3.fromRGB(18, 6, 22)
APSpamPanel.BorderSizePixel = 0
APSpamPanel.Active = true
APSpamPanel.Draggable = not Settings.GlobalGuiLocked
APSpamPanel.ClipsDescendants = true
APSpamPanel.Visible = State.APSpam
APSpamPanel.Parent = GUI
APSpamPanel.ZIndex = 10
Instance.new("UICorner", APSpamPanel).CornerRadius = UDim.new(0, 24)
local apStroke = Instance.new("UIStroke", APSpamPanel)
apStroke.Color = Color3.fromRGB(255, 60, 200)
apStroke.Thickness = 1.5
local apGradient = Instance.new("UIGradient", APSpamPanel)
apGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 8, 25)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(105, 20, 70)),
})
applyAPSnow(APSpamPanel)

connect(APSpamPanel:GetPropertyChangedSignal("Position"), function()
	Settings.APSpamPosition = APSpamPanel.Position
	queuePositionSave()
end)

local APTitle = Instance.new("TextLabel")
APTitle.Size = UDim2.new(1, 0, 0, 32)
APTitle.BackgroundTransparency = 1
APTitle.Text = "ARX AP Spam"
APTitle.TextColor3 = Color3.fromRGB(255, 225, 245)
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
			row.BackgroundColor3 = Color3.fromRGB(62, 18, 45)
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
			username.Font = Enum.Font.Gotham
			username.TextScaled = true
			username.TextXAlignment = Enum.TextXAlignment.Left
			username.TextColor3 = Color3.fromRGB(180, 180, 180)
			username.TextTruncate = Enum.TextTruncate.AtEnd
			username.ZIndex = 13
			username.Parent = nameHolder

			local semi = Instance.new("TextButton")
			semi.Size = UDim2.new(0.24, 0, 0.65, 0)
			semi.Position = UDim2.new(0.50, 0, 0.18, 0)
			semi.BackgroundColor3 = Color3.fromRGB(125, 35, 90)
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
			full.BackgroundColor3 = Color3.fromRGB(155, 45, 105)
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
		empty.Font = Enum.Font.Gotham
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
APConfigFrame.BackgroundColor3 = Color3.fromRGB(42, 12, 30)
APConfigFrame.BackgroundTransparency = 0.05
APConfigFrame.BorderSizePixel = 0
APConfigFrame.Active = true
APConfigFrame.Draggable = not Settings.GlobalGuiLocked
APConfigFrame.Visible = false
APConfigFrame.ZIndex = 80
APConfigFrame.Parent = GUI
Instance.new("UICorner", APConfigFrame).CornerRadius = UDim.new(0, 18)
local configStroke = Instance.new("UIStroke", APConfigFrame)
configStroke.Color = Color3.fromRGB(255, 105, 190)
configStroke.Thickness = 1
local configGradient = Instance.new("UIGradient", APConfigFrame)
configGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 8, 25)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(105, 20, 70)),
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
ConfigTitle.TextColor3 = Color3.fromRGB(255, 225, 245)
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
		configButton.BackgroundColor3 = APSelectedCommands[mode][commandName]
			and Color3.fromRGB(50, 90, 50)
			or Color3.fromRGB(55, 55, 55)
	end
	refresh()
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
APConfigBubble.Name = "ARXAPConfigBubble"
APConfigBubble.Size = UDim2.fromOffset(84, 30)
APConfigBubble.Position = Settings.APConfigBubblePosition
APConfigBubble.BackgroundColor3 = Color3.fromRGB(42, 12, 30)
APConfigBubble.BackgroundTransparency = 0
APConfigBubble.AutoButtonColor = false
APConfigBubble.Font = Enum.Font.FredokaOne
APConfigBubble.Text = "ARX"
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
	bubbleDragStart = nil
end)

local function setupDefensePanel()
	local function getMyPlot()
		local plots = workspace:FindFirstChild("Plots")
		if not plots then return nil end
		for _, plot in ipairs(plots:GetChildren()) do
			local sign = plot:FindFirstChild("PlotSign")
			local yourBase = sign and sign:FindFirstChild("YourBase")
			if yourBase and yourBase.Enabled == true then return plot end
		end
		return nil
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
	DefensePanel.Name = "DefensePanel"
	DefensePanel.Size = UDim2.fromOffset(286, 124)
	DefensePanel.Position = Settings.DefensePosition
	DefensePanel.BackgroundColor3 = Color3.fromRGB(9, 13, 24)
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
	title.Size = UDim2.new(1, -20, 0, 34)
	title.Position = UDim2.fromOffset(10, 0)
	title.BackgroundTransparency = 1
	title.Text = "AUTO DEFENSE"
	title.TextColor3 = Color3.fromRGB(248, 245, 255)
	title.TextSize = 14
	title.Font = Enum.Font.GothamBold
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = DefensePanel

	local line = Instance.new("Frame")
	line.Size = UDim2.new(1, -20, 0, 2)
	line.Position = UDim2.fromOffset(10, 33)
	line.BackgroundColor3 = Color3.fromRGB(225, 65, 85)
	line.BorderSizePixel = 0
	line.Parent = DefensePanel

	local function makeRow(text, y)
		local row = Instance.new("Frame")
		row.Size = UDim2.new(1, -20, 0, 33)
		row.Position = UDim2.fromOffset(10, y)
		row.BackgroundColor3 = Color3.fromRGB(67, 18, 52)
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
		label.Font = Enum.Font.GothamBold
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Parent = row
		local toggle = Instance.new("TextButton")
		toggle.Size = UDim2.fromOffset(54, 23)
		toggle.Position = UDim2.new(1, -60, 0.5, -11)
		toggle.TextColor3 = Color3.new(1, 1, 1)
		toggle.TextSize = 10
		toggle.Font = Enum.Font.GothamBold
		toggle.AutoButtonColor = false
		toggle.Parent = row
		Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 6)
		return toggle
	end

	local defenseToggle = makeRow("Auto Defense", 43)
	local intruderToggle = makeRow("Anti Intruder", 82)
	local function paint()
		for button, enabled in pairs({
			[defenseToggle] = State.AutoDefense,
			[intruderToggle] = State.AntiIntruder,
		}) do
			button.Text = enabled and "ON" or "OFF"
			button.BackgroundColor3 = enabled and Color3.fromRGB(40, 180, 95) or Color3.fromRGB(185, 50, 55)
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

	local intruderCooldowns = {}
	local defenseStealState = {}
	local defenseNextCommand = "balloon"
	local defenseWasEnabled = State.AutoDefense
	local accumulator = 0
	local defenseScanBusy = false
	connect(Players.PlayerRemoving, function(player)
		intruderCooldowns[player.UserId] = nil
		defenseStealState[player.UserId] = nil
	end)
	connect(RunService.Heartbeat, function(dt)
		accumulator += dt
		if accumulator < 0.02 then return end
		accumulator = 0
		if State.AutoDefense ~= defenseWasEnabled then
			defenseWasEnabled = State.AutoDefense
			if not State.AutoDefense then table.clear(defenseStealState) end
		end
		if not State.AutoDefense and not State.AntiIntruder then return end
		local plot = getMyPlot()
		if not plot then return end
		if defenseScanBusy then return end
		defenseScanBusy = true
		local hitbox = getStealHitbox(plot)
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

				local lastIntruder = intruderCooldowns[userId] or 0
				if State.AntiIntruder and insideHitbox(player, hitbox)
					and now - lastIntruder >= 0.15 then
						local jail = runQuickCommand(player, "jail", true)
						local balloon = runQuickCommand(player, "balloon", true)
						local punished = jail or balloon
						if punished then notify("INTRUDER → " .. player.DisplayName, true, Color3.fromRGB(205, 55, 70)) end
						if punished then intruderCooldowns[userId] = now end
				end
			end
		end
		defenseScanBusy = false
	end)
end
setupDefensePanel()

local function setupActionsPanel()
	ActionsPanel = Instance.new("Frame")
	ActionsPanel.Name = "ActionsPanel"
	ActionsPanel.Size = UDim2.fromOffset(Settings.ActionsWidth, Settings.ActionsHeight)
	ActionsPanel.Position = Settings.ActionsPosition
	ActionsPanel.BackgroundColor3 = Color3.fromRGB(45, 12, 35)
	ActionsPanel.BackgroundTransparency = 0.06
	ActionsPanel.BorderSizePixel = 0
	ActionsPanel.Active = true
	ActionsPanel.Draggable = not Settings.GlobalGuiLocked
	ActionsPanel.Visible = State.ActionsPanel
	ActionsPanel.Parent = GUI
	Instance.new("UICorner", ActionsPanel).CornerRadius = UDim.new(0, 12)
	local stroke = Instance.new("UIStroke", ActionsPanel)
	stroke.Color = Color3.fromRGB(255, 85, 180)
	stroke.Thickness = 1.6
	connect(ActionsPanel:GetPropertyChangedSignal("Position"), queuePositionSave)
	connect(ActionsPanel:GetPropertyChangedSignal("Size"), queuePositionSave)

	-- Resize grip: drag the bottom-right corner to customize the panel size.
	local resizeGrip = Instance.new("TextButton")
	resizeGrip.Name = "ResizeGrip"
	resizeGrip.Size = UDim2.fromOffset(18, 18)
	resizeGrip.AnchorPoint = Vector2.new(1, 1)
	resizeGrip.Position = UDim2.new(1, -3, 1, -3)
	resizeGrip.BackgroundTransparency = 1
	resizeGrip.Text = "↘"
	resizeGrip.TextColor3 = Color3.fromRGB(255, 135, 210)
	resizeGrip.TextTransparency = 0.15
	resizeGrip.TextSize = 13
	resizeGrip.Font = Enum.Font.GothamBold
	resizeGrip.AutoButtonColor = false
	resizeGrip.ZIndex = 20
	resizeGrip.Parent = ActionsPanel

	local resizing = false
	local resizeStartMouse = nil
	local resizeStartSize = nil
	connect(resizeGrip.InputBegan, function(input)
		if Settings.GlobalGuiLocked then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			resizing = true
			resizeStartMouse = input.Position
			resizeStartSize = ActionsPanel.AbsoluteSize
		end
	end)
	connect(UIS.InputChanged, function(input)
		if not resizing or not resizeStartMouse or not resizeStartSize then return end
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - resizeStartMouse
			local width = math.clamp(resizeStartSize.X + delta.X, 230, 420)
			local height = math.clamp(resizeStartSize.Y + delta.Y, 195, 360)
			ActionsPanel.Size = UDim2.fromOffset(width, height)
		end
	end)
	connect(UIS.InputEnded, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			local wasResizing = resizing
			resizing = false
			resizeStartMouse = nil
			resizeStartSize = nil
			if wasResizing then queuePositionSave() end
		end
	end)

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -20, 0, 34)
	title.Position = UDim2.fromOffset(10, 0)
	title.BackgroundTransparency = 1
	title.Text = "ACTIONS PANEL"
	title.TextColor3 = Color3.fromRGB(248, 245, 255)
	title.TextSize = 14
	title.Font = Enum.Font.GothamBold
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = ActionsPanel
	local line = Instance.new("Frame")
	line.Size = UDim2.new(1, -20, 0, 2)
	line.Position = UDim2.fromOffset(10, 33)
	line.BackgroundColor3 = Color3.fromRGB(255, 85, 180)
	line.BorderSizePixel = 0
	line.Parent = ActionsPanel


	local function makeActionRow(name, y, keyCode, color)
		local row = Instance.new("Frame")
		row.Size = UDim2.new(1, -20, 0, 34)
		row.Position = UDim2.fromOffset(10, y)
		row.BackgroundColor3 = Color3.fromRGB(67, 18, 52)
		row.BorderSizePixel = 0
		row.Parent = ActionsPanel
		Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, -130, 0, 34)
		label.Position = UDim2.fromOffset(9, 0)
		label.BackgroundTransparency = 1
		label.Text = name
		label.TextColor3 = Color3.fromRGB(238, 242, 255)
		label.TextSize = 10
		label.Font = Enum.Font.GothamBold
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Parent = row
		local keyButton = Instance.new("TextButton")
		keyButton.Size = UDim2.fromOffset(45, 24)
		keyButton.Position = UDim2.new(1, -120, 0, 5)
		keyButton.BackgroundColor3 = Color3.fromRGB(185, 55, 140)
		keyButton.Text = keyCode.Name
		keyButton.TextColor3 = Color3.new(1, 1, 1)
		keyButton.TextSize = 9
		keyButton.Font = Enum.Font.GothamBold
		keyButton.AutoButtonColor = false
		keyButton.Parent = row
		Instance.new("UICorner", keyButton).CornerRadius = UDim.new(0, 6)
		local useButton = Instance.new("TextButton")
		useButton.Size = UDim2.fromOffset(69, 24)
		useButton.Position = UDim2.new(1, -75, 0, 5)
		useButton.BackgroundColor3 = color or Color3.fromRGB(225, 65, 155)
		useButton.Text = "USE"
		useButton.TextColor3 = Color3.new(1, 1, 1)
		useButton.TextSize = 9
		useButton.Font = Enum.Font.GothamBold
		useButton.AutoButtonColor = false
		useButton.Parent = row
		Instance.new("UICorner", useButton).CornerRadius = UDim.new(0, 6)
		return keyButton, useButton
	end

	local techUse, selfUse, leaveUse, resetUse
	ActionControls.Buttons.RagdollTech, techUse = makeActionRow("Ragdoll Tech", 42, ActionControls.RagdollTechKey)
	ActionControls.Buttons.RagdollSelf, selfUse = makeActionRow("Ragdoll Self", 78, ActionControls.RagdollSelfKey)
	ActionControls.Buttons.Leave, leaveUse = makeActionRow("Leave Game", 114, LeaveKey, Color3.fromRGB(205, 55, 85))
	ActionControls.Buttons.InstantReset, resetUse = makeActionRow("Instant Reset", 150, ActionControls.InstantResetKey, Color3.fromRGB(235, 70, 105))

	local techBusy = false
	local resetBusy = false
	ActionControls.Run.RagdollSelf = function()
		local worked = runQuickCommand(LP, "ragdoll", true)
		notify(worked and "Ragdoll Self used" or "Ragdoll Self unavailable", worked)
	end
	ActionControls.Run.RagdollTech = function()
		if techBusy then return end
		techBusy = true
		task.spawn(function()
			local AutoBigPotion = rawget(_G, "AutoBigPotion")
			local Actions = {
				ragdollSelf = ActionControls.Run.RagdollSelf,
			}

			if AutoBigPotion and AutoBigPotion.activate then
				pcall(AutoBigPotion.activate)
			end

			task.wait(0.1)
			Actions.ragdollSelf()
			techBusy = false
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
			-- Semi TP style Instant Reset (void TP up until death/respawn)
			local dead = false
			local conns = {}
			table.insert(conns, humanoid.Died:Connect(function() dead = true end))
			table.insert(conns, character.AncestryChanged:Connect(function(_, parent)
				if not parent then dead = true end
			end))
			table.insert(conns, humanoid:GetPropertyChangedSignal("Health"):Connect(function()
				if humanoid.Health <= 0 then dead = true end
			end))

			local camera = workspace.CurrentCamera
			local frozen = camera and camera.CFrame
			local oldType = camera and camera.CameraType
			local bindName = "ARXInstantResetCamera"
			local newCharacter
			local respawnConnection = LP.CharacterAdded:Connect(function(newChar)
				newCharacter = newChar
				dead = true
			end)

			-- freeze cam so it doesn't swing during void launch
			pcall(function()
				if camera and frozen then
					camera.CameraType = Enum.CameraType.Scriptable
					RunService:BindToRenderStep(bindName, Enum.RenderPriority.Camera.Value + 1, function()
						if camera and frozen then camera.CFrame = frozen end
					end)
				end
			end)

			-- hide local body
			local function hide(object)
				if object:IsA("BasePart") or object:IsA("Decal") then
					object.LocalTransparencyModifier = 1
				end
			end
			local addedConnection
			pcall(function()
				for _, object in ipairs(character:GetDescendants()) do hide(object) end
				addedConnection = character.DescendantAdded:Connect(hide)
			end)

			-- VOID TP: spam far above map until character dies / is replaced (Semi TP method)
			local n = 0
			while not dead and n < 500 and character and character.Parent and humanoid.Health > 0 do
				n = n + 1
				pcall(function()
					if root and root.Parent then
						root.Anchored = false
						root.CFrame = root.CFrame * CFrame.new(0, 1e6, 0)
						root.AssemblyLinearVelocity = Vector3.new(0, 1e5, 0)
					end
					-- clear giant scale so respawn isn't huge
					if humanoid:FindFirstChild("BodyHeightScale") then humanoid.BodyHeightScale.Value = 1 end
					if humanoid:FindFirstChild("BodyWidthScale") then humanoid.BodyWidthScale.Value = 1 end
					if humanoid:FindFirstChild("BodyDepthScale") then humanoid.BodyDepthScale.Value = 1 end
					if humanoid:FindFirstChild("HeadScale") then humanoid.HeadScale.Value = 1 end
				end)
				task.wait(0.05)
			end

			-- fallback kill if still alive
			if not dead and humanoid and humanoid.Parent and humanoid.Health > 0 then
				pcall(function() humanoid.Health = 0 end)
				local t0 = os.clock()
				while not newCharacter and os.clock() - t0 < 3 do
					task.wait(0.05)
				end
			end

			for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
			pcall(function() respawnConnection:Disconnect() end)
			if addedConnection then pcall(function() addedConnection:Disconnect() end) end
			pcall(function() RunService:UnbindFromRenderStep(bindName) end)
			pcall(function()
				if camera then
					camera.CameraType = (oldType == Enum.CameraType.Scriptable) and Enum.CameraType.Custom or (oldType or Enum.CameraType.Custom)
					local waitChar = newCharacter or LP.Character
					local newHumanoid = waitChar and (waitChar:FindFirstChildOfClass("Humanoid") or waitChar:WaitForChild("Humanoid", 4))
					if newHumanoid then camera.CameraSubject = newHumanoid end
				end
			end)

			Env._FH_LAUNCHING = false
			resetBusy = false

			-- re-apply ESP / base timer after respawn
			task.defer(function()
				task.wait(0.2)
				if State.ESP then pcall(enableESP) end
				if State.BaseESP then
					pcall(clearBaseESP)
					pcall(refreshBaseESP)
				end
				for _ = 1, 5 do
					task.wait(0.3)
					if State.ESP then pcall(enableESP) end
					if State.BaseESP then pcall(refreshBaseESP) end
				end
			end)
		end)
	end

	for kind, button in pairs(ActionControls.Buttons) do
		connect(button.MouseButton1Click, function()
			State.WaitingForKey = kind
			button.Text = "..."
			button.BackgroundColor3 = Color3.fromRGB(190, 135, 35)
		end)
	end
	connect(techUse.MouseButton1Click, function() ActionControls.Run.RagdollTech() end)
	connect(selfUse.MouseButton1Click, function() ActionControls.Run.RagdollSelf() end)
	connect(leaveUse.MouseButton1Click, function() ActionControls.Run.Leave() end)
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
	label.Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham
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
	b.Font = Enum.Font.GothamBold
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
	box.Font = Enum.Font.GothamMedium
	box.ClearTextOnFocus = false
	box.Parent = Main
	Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
	return box
end

local HubTitle = textLabel("ARX Hub", UDim2.fromOffset(16, 8), UDim2.fromOffset(250, 27), 18, true)
local OldFeatureHeader = textLabel("Feature", UDim2.fromOffset(14, 38), UDim2.fromOffset(130, 18), 9, true)
local OldValueHeader = textLabel("Value", UDim2.fromOffset(158, 38), UDim2.fromOffset(58, 18), 9, true)
local OldKeyHeader = textLabel("Key", UDim2.fromOffset(221, 38), UDim2.fromOffset(50, 18), 9, true)

local AutoPotionToggle = button("OFF", UDim2.fromOffset(265, 60), UDim2.fromOffset(51, 28))
local AutoPotionLabel = textLabel("Auto Giant Potion", UDim2.fromOffset(14, 60), UDim2.fromOffset(220, 28), 11, true)

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

local APSpamLabel = textLabel("ARX AP SPAM", UDim2.fromOffset(14, 489), UDim2.fromOffset(245, 28), 11, true)
local APSpamToggle = button("OFF", UDim2.fromOffset(265, 489), UDim2.fromOffset(51, 28))

local DefensePanelLabel = textLabel("Auto Defense Panel", UDim2.fromOffset(14, 528), UDim2.fromOffset(245, 28), 11, true)
local DefensePanelToggle = button("OFF", UDim2.fromOffset(265, 528), UDim2.fromOffset(51, 28))

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
	local page = Instance.new(name == "Utils" and "ScrollingFrame" or "Frame")
	page.Name = name .. "Page"
	page.Size = UDim2.fromScale(1, 1)
	page.BackgroundTransparency = 1
	if name == "Utils" then
		page.CanvasSize = UDim2.fromOffset(0, 510)
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
Env.ARXFeatureControls = {}
do
local FC = Env.ARXFeatureControls
local FeatureESPFolder = Instance.new("Folder")
FeatureESPFolder.Name = "ARXFeatureESP"
FeatureESPFolder.Parent = GUI
local featureMarks = {Brainrot = {}, Clone = {}, Mine = {}}

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
	highlight.Name = "ARX" .. kind .. "Highlight"
	highlight.Adornee = adornee
	highlight.FillColor = color
	highlight.OutlineColor = (kind == "Clone" or kind == "Mine") and Color3.fromRGB(255, 255, 255) or Color3.new(0, 0, 0)
	highlight.FillTransparency = (kind == "Clone" or kind == "Mine") and 0.08 or 0.42
	highlight.OutlineTransparency = 0
	highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	highlight.Parent = FeatureESPFolder
	local label = Instance.new("BillboardGui")
	label.Name = "ARX" .. kind .. "Label"
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
	txt.Font = Enum.Font.GothamBold
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

local function selectedPrioritySignature()
	local ag = rawget(_G, "AutoGrab") or rawget(_G, "_FH_AutoGrab") or AutoGrab
	if not ag then return nil end
	if ag.currentTargetSig then return ag.currentTargetSig end
	if type(ag.priority) == "table" then
		local k = next(ag.priority)
		if k then return k end
	end
	return nil
end

local function brainrotSignature(rec)
	return tostring(rec.plotName or "") .. "::" .. tostring(rec.pod or 0) .. "::" .. tostring(rec.name or rec.displayName or "")
end

local function sigMatches(selected, rec)
	if not selected or not rec then return false end
	local full = brainrotSignature(rec)
	if full == selected then return true end
	-- unique podium slot only (never name-only — duplicates share names)
	local slot = tostring(rec.plotName or "") .. "::" .. tostring(rec.pod or 0)
	local selSlot = tostring(selected):match("^(.-::.-)::") or tostring(selected)
	return selSlot == slot
end

-- Dedicated world highlights for the currently selected Auto Steal Priority target.
local selectedPodiumHighlight = nil
local selectedAnimalHighlight = nil
local selectedPodiumAdorneeLast = nil
local selectedAnimalAdorneeLast = nil
local function resolvePodium(rec)
	if not rec then return nil end
	if rec.podiumInst and rec.podiumInst.Parent then
		return rec.podiumInst
	end
	local plot = rec.plot
	if not plot or not plot.Parent then
		local plots = workspace:FindFirstChild("Plots")
		plot = plots and plots:FindFirstChild(tostring(rec.plotName or ""))
	end
	if not plot then return nil end
	local pods = plot:FindFirstChild("AnimalPodiums") or plot:FindFirstChild("Podiums") or plot:FindFirstChild("Pods")
	if not pods then
		for _, d in ipairs(plot:GetDescendants()) do
			if d.Name == "AnimalPodiums" then
				pods = d
				break
			end
		end
	end
	if not pods then return nil end
	local podNum = tonumber(rec.pod)
	local podKey = tostring(rec.pod or "")
	local direct = pods:FindFirstChild(podKey)
	if not direct and podNum then direct = pods:FindFirstChild(tostring(podNum)) end
	if direct then return direct end
	for _, ch in ipairs(pods:GetChildren()) do
		local n = tonumber(ch.Name) or tonumber((tostring(ch.Name):match("%d+") or ""))
		if podNum and n == podNum then return ch end
		if tostring(ch.Name) == podKey then return ch end
	end
	return nil
end

local function setRedHighlight(current, lastAdornee, adornee, name)
	if current and lastAdornee == adornee and current.Parent and current.Adornee == adornee then
		return current, lastAdornee
	end
	if current then pcall(function() current:Destroy() end) end
	if not adornee or not adornee.Parent then
		return nil, nil
	end
	local h = Instance.new("Highlight")
	h.Name = name
	h.Adornee = adornee
	h.FillColor = Color3.fromRGB(255, 0, 0)
	h.FillTransparency = 0.15
	h.OutlineColor = Color3.fromRGB(255, 40, 40)
	h.OutlineTransparency = 0
	h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	h.Parent = workspace
	return h, adornee
end

-- Instant force-refresh when priority selection changes (same frame)
Env.ARXForcePriorityHighlight = function()
	_G._FH_ESPNeedList = true
	_G._FH_GammaNeedList = true
	local ag = rawget(_G, "AutoGrab") or rawget(_G, "_FH_AutoGrab") or AutoGrab
	local selected = selectedPrioritySignature()
	if not selected or not ag or type(ag.animalList) ~= "table" then
		if selectedPodiumHighlight then pcall(function() selectedPodiumHighlight:Destroy() end) end
		if selectedAnimalHighlight then pcall(function() selectedAnimalHighlight:Destroy() end) end
		selectedPodiumHighlight, selectedAnimalHighlight = nil, nil
		selectedPodiumAdorneeLast, selectedAnimalAdorneeLast = nil, nil
		return
	end
	local podAd, aniAd = nil, nil
	for _, rec in ipairs(ag.animalList) do
		if sigMatches(selected, rec) then
			podAd = resolvePodium(rec)
			aniAd = rec.modelInst
			break
		end
	end
	selectedPodiumHighlight, selectedPodiumAdorneeLast = setRedHighlight(
		selectedPodiumHighlight, selectedPodiumAdorneeLast, podAd, "ARXSelectedPodiumHighlight"
	)
	selectedAnimalHighlight, selectedAnimalAdorneeLast = setRedHighlight(
		selectedAnimalHighlight, selectedAnimalAdorneeLast, aniAd, "ARXSelectedAnimalHighlight"
	)
end

task.spawn(function()
	while GUI.Parent do
		local ag = rawget(_G, "AutoGrab") or rawget(_G, "_FH_AutoGrab") or AutoGrab
		local selected = selectedPrioritySignature()
		local brainrotWanted = State.BrainrotESP or selected ~= nil
		if selected then
			_G._FH_ESPNeedList = true
			_G._FH_GammaNeedList = true
		end
		if brainrotWanted and ag and type(ag.animalList) == "table" then
			_G._FH_ESPNeedList = true
			local present = {}
			local selectedPodiumAdornee = nil
			local selectedAnimalAdornee = nil
			for _, rec in ipairs(ag.animalList) do
				local isSel = selected and sigMatches(selected, rec)
				if not selected or isSel then
					local model = rec.modelInst
					if model and model.Parent then
						present[model] = true
						if isSel then
							local oldMark = featureMarks.Brainrot[model]
							if oldMark then
								if oldMark.highlight then oldMark.highlight:Destroy() end
								if oldMark.label then oldMark.label:Destroy() end
								featureMarks.Brainrot[model] = nil
							end
							selectedAnimalAdornee = model
						else
							markFeature("Brainrot", model, tostring(rec.name or "Brainrot"), Color3.fromRGB(255, 205, 65))
						end
					end
					if isSel then
						selectedPodiumAdornee = resolvePodium(rec)
						if not selectedAnimalAdornee and rec.modelInst then
							selectedAnimalAdornee = rec.modelInst
						end
					end
				end
			end
			if selected then
				selectedPodiumHighlight, selectedPodiumAdorneeLast = setRedHighlight(
					selectedPodiumHighlight, selectedPodiumAdorneeLast, selectedPodiumAdornee, "ARXSelectedPodiumHighlight"
				)
				selectedAnimalHighlight, selectedAnimalAdorneeLast = setRedHighlight(
					selectedAnimalHighlight, selectedAnimalAdorneeLast, selectedAnimalAdornee, "ARXSelectedAnimalHighlight"
				)
			else
				if selectedPodiumHighlight then pcall(function() selectedPodiumHighlight:Destroy() end) end
				if selectedAnimalHighlight then pcall(function() selectedAnimalHighlight:Destroy() end) end
				selectedPodiumHighlight, selectedAnimalHighlight = nil, nil
				selectedPodiumAdorneeLast, selectedAnimalAdorneeLast = nil, nil
			end
			for obj, data in pairs(featureMarks.Brainrot) do
				if not present[obj] or not obj.Parent then
					if data.highlight then data.highlight:Destroy() end
					if data.label then data.label:Destroy() end
					featureMarks.Brainrot[obj] = nil
				end
			end
		else
			clearFeatureMarks("Brainrot")
			if selectedPodiumHighlight then pcall(function() selectedPodiumHighlight:Destroy() end) end
			if selectedAnimalHighlight then pcall(function() selectedAnimalHighlight:Destroy() end) end
			selectedPodiumHighlight, selectedAnimalHighlight = nil, nil
			selectedPodiumAdorneeLast, selectedAnimalAdorneeLast = nil, nil
		end

		if State.CloneESP then
			for _, obj in ipairs(workspace:GetChildren()) do
				if obj:IsA("Model") and obj.Name:find("_Clone", 1, true) then
					markFeature("Clone", obj, cloneOwnerText(obj), Color3.fromRGB(255, 255, 255))
				end
			end
		else
			clearFeatureMarks("Clone")
		end

		if State.MineESP then
			local folder = workspace:FindFirstChild("ToolsAdds")
			if folder then
				for _, obj in ipairs(folder:GetChildren()) do
					if obj:IsA("BasePart") and obj.Name:match("^SubspaceTripmine") then
						markFeature("Mine", obj, mineOwnerText(obj), Color3.fromRGB(255, 255, 255))
					end
				end
			end
		else
			clearFeatureMarks("Mine")
		end

		if State.AntiTurret then
			local character = LP.Character
			local root = character and character:FindFirstChild("HumanoidRootPart")
			if root then
				for _, obj in ipairs(workspace:GetDescendants()) do
					if obj:IsA("ProximityPrompt") then
						local at = string.lower(tostring(obj.ActionText or "") .. " " .. tostring(obj.ObjectText or ""))
						if at:find("turret", 1, true) or at:find("cannon", 1, true) then
							local part = obj.Parent
							if part and part:IsA("BasePart") and (part.Position - root.Position).Magnitude < 18 then
								pcall(function()
									obj.HoldDuration = 0
									if fireproximityprompt then fireproximityprompt(obj) end
								end)
							end
						end
					end
				end
			end
		end

		task.wait(selected and 0.08 or 0.25)
	end
end)

-- Feature control widgets for Visual / Utils tabs
local function fcLabel(text)
	local l = Instance.new("TextLabel")
	l.BackgroundTransparency = 1
	l.Text = text
	l.TextColor3 = Color3.fromRGB(230, 230, 240)
	l.TextSize = 11
	l.Font = Enum.Font.GothamBold
	l.TextXAlignment = Enum.TextXAlignment.Left
	return l
end
local function fcToggle()
	local b = Instance.new("TextButton")
	b.BackgroundColor3 = Color3.fromRGB(185, 50, 55)
	b.Text = "OFF"
	b.TextColor3 = Color3.new(1, 1, 1)
	b.TextSize = 10
	b.Font = Enum.Font.GothamBold
	b.AutoButtonColor = false
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
	return b
end
local function fcKey()
	local b = Instance.new("TextButton")
	b.BackgroundColor3 = Color3.fromRGB(55, 90, 170)
	b.Text = "KEY"
	b.TextColor3 = Color3.new(1, 1, 1)
	b.TextSize = 9
	b.Font = Enum.Font.GothamBold
	b.AutoButtonColor = false
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
	return b
end
FC.BrainrotESPLabel = fcLabel("Brainrot ESP")
FC.BrainrotESPToggle = fcToggle()
FC.BrainrotESPKeyButton = fcKey()
FC.CloneESPLabel = fcLabel("Clone ESP")
FC.CloneESPToggle = fcToggle()
FC.CloneESPKeyButton = fcKey()
FC.MineESPLabel = fcLabel("Mine ESP")
FC.MineESPToggle = fcToggle()
FC.MineESPKeyButton = fcKey()
FC.AntiTurretLabel = fcLabel("Anti Turret")
FC.AntiTurretToggle = fcToggle()
FC.AntiTurretKeyButton = fcKey()
end -- FeatureControls do

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
placeHubRow(MainPage, 46, RegularLabel, RegularBox, RegularKeyButton, RegularToggle)
placeHubRow(MainPage, 92, GiantLabel, GiantBox, GiantKeyButton, GiantToggle)
placeHubRow(MainPage, 138, CarpetLabel, CarpetBox, CarpetKeyButton, CarpetToggle)
placeHubRow(MainPage, 184, JumpLabel, nil, JumpKeyButton, JumpToggle)

placeHubRow(VisualPage, 0, ESPLabel, nil, nil, ESPToggle)
placeHubRow(VisualPage, 46, BaseESPLabel, nil, nil, BaseESPToggle)
placeHubRow(VisualPage, 92, Env.ARXFeatureControls.BrainrotESPLabel, nil, Env.ARXFeatureControls.BrainrotESPKeyButton, Env.ARXFeatureControls.BrainrotESPToggle)
placeHubRow(VisualPage, 138, Env.ARXFeatureControls.CloneESPLabel, nil, Env.ARXFeatureControls.CloneESPKeyButton, Env.ARXFeatureControls.CloneESPToggle)
placeHubRow(VisualPage, 184, Env.ARXFeatureControls.MineESPLabel, nil, Env.ARXFeatureControls.MineESPKeyButton, Env.ARXFeatureControls.MineESPToggle)

placeHubRow(PlayerPage, 0, AimbotLabel, nil, nil, AimbotToggle)
placeHubRow(PlayerPage, 46, AntiRagdollLabel, nil, AntiRagdollKeyButton, AntiRagdollToggle)
placeHubRow(UtilsPage, 0, Env.ARXFeatureControls.AntiTurretLabel, nil, Env.ARXFeatureControls.AntiTurretKeyButton, Env.ARXFeatureControls.AntiTurretToggle)
placeHubRow(UtilsPage, 46, TradeRegionLabel, nil, TradeRegionKeyButton, TradeRegionToggle)
placeHubRow(UtilsPage, 92, TradePlazaLabel, nil, TradePlazaKeyButton, TradePlazaToggle)
placeHubRow(UtilsPage, 138, ActionsPanelLabel, nil, nil, ActionsPanelToggle)
placeHubRow(UtilsPage, 184, QuickPanelLabel, nil, nil, QuickPanelToggle)
placeHubRow(UtilsPage, 230, APSpamLabel, nil, nil, APSpamToggle)
placeHubRow(UtilsPage, 276, DefensePanelLabel, nil, nil, DefensePanelToggle)
placeHubRow(UtilsPage, 322, CooldownPanelLabel, nil, nil, CooldownPanelToggle)

local function selectHubTab(name)
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

for _, tabName in ipairs({"Main", "Visual", "Player", "Utils"}) do
	local selectedTabName = tabName
	local tab = Instance.new("TextButton")
	tab.Size = UDim2.fromOffset(86, 32)
	tab.BackgroundColor3 = Color3.fromRGB(30, 32, 43)
	tab.Text = tabName:upper()
	tab.TextColor3 = Color3.fromRGB(155, 160, 180)
	tab.TextSize = 10
	tab.Font = Enum.Font.GothamBold
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
BoosterMini.Size = UDim2.fromOffset(220, 92)
BoosterMini.Position = Settings.BoosterMiniPosition
BoosterMini.BackgroundColor3 = Color3.fromRGB(16, 17, 23)
BoosterMini.BorderSizePixel = 0
BoosterMini.Active = true
BoosterMini.Draggable = not Settings.GlobalGuiLocked
BoosterMini.Parent = GUI
Instance.new("UICorner", BoosterMini).CornerRadius = UDim.new(0, 10)
local boosterStroke = Instance.new("UIStroke", BoosterMini)
boosterStroke.Color = Color3.fromRGB(105, 85, 225)
boosterStroke.Thickness = 1.2

local BoosterTitle = Instance.new("TextLabel")
BoosterTitle.Size = UDim2.new(1, -52, 0, 24)
BoosterTitle.Position = UDim2.fromOffset(8, 2)
BoosterTitle.BackgroundTransparency = 1
BoosterTitle.Text = "BOOSTERS"
BoosterTitle.TextColor3 = Color3.fromRGB(235, 235, 245)
BoosterTitle.TextSize = 11
BoosterTitle.Font = Enum.Font.GothamBold
BoosterTitle.TextXAlignment = Enum.TextXAlignment.Left
BoosterTitle.Parent = BoosterMini

local function boosterMiniButton(text, position, size)
	local object = Instance.new("TextButton")
	object.Size = size
	object.Position = position
	object.BackgroundColor3 = Color3.fromRGB(45, 47, 58)
	object.Text = text
	object.TextColor3 = Color3.fromRGB(240, 240, 248)
	object.TextSize = 9
	object.Font = Enum.Font.GothamBold
	object.Parent = BoosterMini
	Instance.new("UICorner", object).CornerRadius = UDim.new(0, 5)
	return object
end

local BoosterRegularToggle = boosterMiniButton("REG OFF", UDim2.fromOffset(8, 30), UDim2.fromOffset(142, 24))
local BoosterRegularKey = boosterMiniButton(RegularKey.Name, UDim2.fromOffset(156, 30), UDim2.fromOffset(56, 24))
local BoosterGiantToggle = boosterMiniButton("GIANT OFF", UDim2.fromOffset(8, 60), UDim2.fromOffset(142, 24))
local BoosterGiantKey = boosterMiniButton(GiantKey.Name, UDim2.fromOffset(156, 60), UDim2.fromOffset(56, 24))

local function updateBoosterMini()
	BoosterRegularToggle.Text = State.Regular and "REG ON" or "REG OFF"
	BoosterRegularToggle.BackgroundColor3 = State.Regular and Color3.fromRGB(38, 150, 88) or Color3.fromRGB(75, 48, 52)
	BoosterGiantToggle.Text = State.Giant and "GIANT ON" or "GIANT OFF"
	BoosterGiantToggle.BackgroundColor3 = State.Giant and Color3.fromRGB(125, 62, 180) or Color3.fromRGB(75, 48, 52)
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
	object.Text = enabled and "ON" or "OFF"
	object.BackgroundColor3 = enabled and (activeColor or Color3.fromRGB(40, 180, 95)) or Color3.fromRGB(185, 50, 55)
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
	paintToggle(DefensePanelToggle, State.DefensePanel, Color3.fromRGB(205, 65, 85))
	paintToggle(CooldownPanelToggle, State.CooldownPanel, Color3.fromRGB(65, 115, 205))
	paintToggle(Env.ARXFeatureControls.BrainrotESPToggle, State.BrainrotESP, Color3.fromRGB(215, 165, 45))
	paintToggle(Env.ARXFeatureControls.CloneESPToggle, State.CloneESP, Color3.fromRGB(210, 65, 65))
	paintToggle(Env.ARXFeatureControls.MineESPToggle, State.MineESP, Color3.fromRGB(210, 65, 65))
	paintToggle(Env.ARXFeatureControls.AntiTurretToggle, State.AntiTurret, Color3.fromRGB(205, 65, 85))
	if State.WaitingForKey ~= "BrainrotESP" then Env.ARXFeatureControls.BrainrotESPKeyButton.Text = keyDisplay(Settings.BrainrotESPKey) end
	if State.WaitingForKey ~= "CloneESP" then Env.ARXFeatureControls.CloneESPKeyButton.Text = keyDisplay(Settings.CloneESPKey) end
	if State.WaitingForKey ~= "MineESP" then Env.ARXFeatureControls.MineESPKeyButton.Text = keyDisplay(Settings.MineESPKey) end
	if State.WaitingForKey ~= "AntiTurret" then Env.ARXFeatureControls.AntiTurretKeyButton.Text = keyDisplay(Settings.AntiTurretKey) end
	if QuickPanel then QuickPanel.Visible = State.QuickPanel end
	if APSpamPanel then APSpamPanel.Visible = State.APSpam end
	if CooldownPanel then CooldownPanel.Visible = State.CooldownPanel end
	if APConfigBubble then APConfigBubble.Visible = State.APSpam end
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
	if ActionControls.Buttons.RagdollTech and State.WaitingForKey ~= "RagdollTech" then ActionControls.Buttons.RagdollTech.Text = keyDisplay(ActionControls.RagdollTechKey); ActionControls.Buttons.RagdollTech.BackgroundColor3 = Color3.fromRGB(55, 90, 170) end
	if ActionControls.Buttons.InstantReset and State.WaitingForKey ~= "InstantReset" then ActionControls.Buttons.InstantReset.Text = keyDisplay(ActionControls.InstantResetKey); ActionControls.Buttons.InstantReset.BackgroundColor3 = Color3.fromRGB(55, 90, 170) end
	if ActionControls.Buttons.RagdollSelf and State.WaitingForKey ~= "RagdollSelf" then ActionControls.Buttons.RagdollSelf.Text = keyDisplay(ActionControls.RagdollSelfKey); ActionControls.Buttons.RagdollSelf.BackgroundColor3 = Color3.fromRGB(55, 90, 170) end
	if ActionControls.Buttons.Leave and State.WaitingForKey ~= "Leave" then ActionControls.Buttons.Leave.Text = keyDisplay(LeaveKey); ActionControls.Buttons.Leave.BackgroundColor3 = Color3.fromRGB(55, 90, 170) end
	if State.Carpet then
		Status.Text = "Active: CARPET booster at " .. tostring(CarpetSpeed)
	elseif isStealActive() then
		if isGiant() and State.Giant then Status.Text = "Active: GIANT booster at " .. tostring(GiantSpeed)
		elseif not isGiant() and State.Regular then Status.Text = "Active: REGULAR booster at " .. tostring(RegularSpeed)
		else Status.Text = "Carrying — matching booster is OFF" end
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
	Env.CarpetSpeedDesired = State.Carpet
	if type(Env.SabcomSetCarpetSpeed) == "function" then Env.SabcomSetCarpetSpeed(CarpetSpeed) end
	if type(Env.SabcomSetCarpetKeybind) == "function" then Env.SabcomSetCarpetKeybind(CarpetKey) end
	if type(Env.Sabcom_SetCarpetSpeed) == "function" then Env.Sabcom_SetCarpetSpeed(State.Carpet) end
	saveSettings()
	updateGUI()
	notify("Carpet Booster: " .. (enabled and "ON" or "OFF"), enabled)
end

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
	if not State.APSpam then APConfigFrame.Visible = false end
	saveSettings(); updateGUI()
	notify("ARX AP SPAM: " .. (State.APSpam and "ON" or "OFF"), State.APSpam)
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
connect(Env.ARXFeatureControls.BrainrotESPToggle.MouseButton1Click, function() State.BrainrotESP = not State.BrainrotESP; saveSettings(); updateGUI(); notify("Brainrot ESP: " .. (State.BrainrotESP and "ON" or "OFF"), State.BrainrotESP) end)
connect(Env.ARXFeatureControls.CloneESPToggle.MouseButton1Click, function() State.CloneESP = not State.CloneESP; saveSettings(); updateGUI(); notify("Clone ESP: " .. (State.CloneESP and "ON" or "OFF"), State.CloneESP) end)
connect(Env.ARXFeatureControls.MineESPToggle.MouseButton1Click, function() State.MineESP = not State.MineESP; saveSettings(); updateGUI(); notify("Mine ESP: " .. (State.MineESP and "ON" or "OFF"), State.MineESP) end)
connect(Env.ARXFeatureControls.AntiTurretToggle.MouseButton1Click, function() State.AntiTurret = not State.AntiTurret; saveSettings(); updateGUI(); notify("Anti Turret: " .. (State.AntiTurret and "ON" or "OFF"), State.AntiTurret) end)
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
connect(CarpetToggle.MouseButton1Click, function() setCarpetEnabled(not State.Carpet) end)
connect(BaseESPToggle.MouseButton1Click, function()
	State.BaseESP = not State.BaseESP
	local detected = State.BaseESP and refreshBaseESP() or 0
	if not State.BaseESP then clearBaseESP() end
	saveSettings()
	updateGUI()
	if State.BaseESP then
		if detected > 0 then
			notify("Base ESP ON — " .. detected .. " base(s)", true)
		else
			notify("Base ESP ON — no bases found", false, Color3.fromRGB(190, 125, 35))
		end
	else
		notify("Base Allow + Timer ESP: OFF", false)
	end
end)
connect(AimbotToggle.MouseButton1Click, function()
	State.Aimbot = not State.Aimbot
	Env.ARXAimbotDesired = State.Aimbot
	if type(Env.ARXAimbotSet) == "function" then
		Env.ARXAimbotSet(State.Aimbot)
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
connect(JumpToggle.MouseButton1Click, function()
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
connect(Env.ARXFeatureControls.BrainrotESPKeyButton.MouseButton1Click, function() beginKeyChoice("BrainrotESP", Env.ARXFeatureControls.BrainrotESPKeyButton) end)
connect(Env.ARXFeatureControls.CloneESPKeyButton.MouseButton1Click, function() beginKeyChoice("CloneESP", Env.ARXFeatureControls.CloneESPKeyButton) end)
connect(Env.ARXFeatureControls.MineESPKeyButton.MouseButton1Click, function() beginKeyChoice("MineESP", Env.ARXFeatureControls.MineESPKeyButton) end)
connect(Env.ARXFeatureControls.AntiTurretKeyButton.MouseButton1Click, function() beginKeyChoice("AntiTurret", Env.ARXFeatureControls.AntiTurretKeyButton) end)

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
			elseif kind == "AntiTurret" then Settings.AntiTurretKey = chosenKey
			elseif kind == "RagdollTech" then ActionControls.RagdollTechKey = chosenKey; Settings.RagdollTechKey = chosenKey
			elseif kind == "InstantReset" then ActionControls.InstantResetKey = chosenKey; Settings.InstantResetKey = chosenKey
			elseif kind == "RagdollSelf" then ActionControls.RagdollSelfKey = chosenKey; Settings.RagdollSelfKey = chosenKey
			elseif kind == "Leave" then LeaveKey = chosenKey; Settings.LeaveKey = LeaveKey end
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
	if Settings.AntiTurretKey ~= Enum.KeyCode.Unknown and input.KeyCode == Settings.AntiTurretKey then State.AntiTurret = not State.AntiTurret; saveSettings(); updateGUI(); notify("Anti Turret: " .. (State.AntiTurret and "ON" or "OFF"), State.AntiTurret); return end
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
	if ActionControls.RagdollTechKey ~= Enum.KeyCode.Unknown and input.KeyCode == ActionControls.RagdollTechKey and ActionControls.Run.RagdollTech then ActionControls.Run.RagdollTech(); return end
	if ActionControls.InstantResetKey ~= Enum.KeyCode.Unknown and input.KeyCode == ActionControls.InstantResetKey and ActionControls.Run.InstantReset then ActionControls.Run.InstantReset(); return end
	if ActionControls.RagdollSelfKey ~= Enum.KeyCode.Unknown and input.KeyCode == ActionControls.RagdollSelfKey and ActionControls.Run.RagdollSelf then ActionControls.Run.RagdollSelf(); return end
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
	if player ~= LP or not State.AutoPotion or prompt.ActionText ~= "Steal" or isGiant() or isStealActive() then return end
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

local function clearPrompt(prompt, player)
	if player == LP then ActiveSteals[promptKey(prompt)] = nil end
end
connect(ProximityPromptService.PromptButtonHoldEnded, clearPrompt)
connect(ProximityPromptService.PromptTriggered, clearPrompt)

connect(Players.PlayerAdded, function(player) if State.ESP then setupESPPlayer(player) end end)

local refreshClock = 0
local baseRefreshClock = 0
connect(RunService.Heartbeat, function(dt)
	local character = LP.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	local root = character and character:FindFirstChild("HumanoidRootPart")

	-- Regular/Giant carry boosters only. Carpet Speed is owned exclusively by
	-- the replacement standalone Carpet module below.
	local chosenSpeed
	if isStealActive() then
		if isGiant() and State.Giant then chosenSpeed = GiantSpeed
		elseif not isGiant() and State.Regular then chosenSpeed = RegularSpeed end
	end
	if chosenSpeed and humanoid and root and humanoid.Health > 0 then
		buildSpeedForce(root)
		SpeedForce.MaxAxesForce = Vector3.new(math.huge, 0, math.huge)
		local flat = Vector3.new(humanoid.MoveDirection.X, 0, humanoid.MoveDirection.Z)
		if flat.Magnitude > 0.001 then
			local direction = flat.Unit
			SpeedForce.VectorVelocity = Vector3.new(direction.X * chosenSpeed, 0, direction.Z * chosenSpeed)
			SpeedForce.Enabled = true
		else
			SpeedForce.Enabled = false
		end
	elseif SpeedForce then SpeedForce.Enabled = false end

	-- Refresh ESP text twice per second
	refreshClock += dt
	if State.ESP and refreshClock >= 0.5 then
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
	if State.BaseESP and baseRefreshClock >= 0.75 then
		baseRefreshClock = 0
		refreshBaseESP()
	end
end)

connect(LP.CharacterAdded, function()
	removeSpeedForce(); task.wait(0.25)
	if State.AntiRagdoll then setRagdollStates(false) end
	if State.ESP then pcall(enableESP) end
	if State.BaseESP then
		task.defer(function()
			pcall(clearBaseESP)
			pcall(refreshBaseESP)
			for _ = 1, 5 do
				task.wait(0.4)
				if State.BaseESP then pcall(refreshBaseESP) end
			end
		end)
	end
	updateGUI()
end)

Env.ARXHubCleanup = function()
	Env._FH_LAUNCHING = false
	pcall(function() RunService:UnbindFromRenderStep("ARXInstantResetCamera") end)
	for _, connection in ipairs(Connections) do pcall(function() connection:Disconnect() end) end
	table.clear(Connections)
	disableESP()
	clearBaseESP()
	stopAntiRagdoll()
	TradeRegionBlock.cleanup()
	TradePlazaBlock.cleanup()
	removeSpeedForce()
	if type(Env.ARXAimbotCleanup) == "function" then pcall(Env.ARXAimbotCleanup) end
	if type(Env.CarpetSpeedCleanup) == "function" then pcall(Env.CarpetSpeedCleanup) end
	if type(Env.InfiniteJumpCleanup) == "function" then pcall(Env.InfiniteJumpCleanup) end
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

if State.TradePlazaBlock then
	task.defer(function() TradePlazaBlock.set(true) end)
end


-- Universal panel resizer: same direct width/height behavior as the Actions Panel.
-- Drag the bottom-right corner.  The panel itself changes size instead of using UIScale,
-- so the UI does not become blurry, compressed, or oddly spaced while resizing.
local function makePanelResizable(panel, key, minWidth, maxWidth, minHeight, maxHeight)
	if not panel or panel:FindFirstChild("UniversalResizeGrip") then return end

	minWidth = minWidth or 180
	maxWidth = maxWidth or 520
	minHeight = minHeight or 70
	maxHeight = maxHeight or 500

	-- Restore a previously saved direct size, if one exists.
	local sizeConstraint = panel:FindFirstChild("UniversalSizeConstraint")
	if not sizeConstraint then
		sizeConstraint = Instance.new("UISizeConstraint")
		sizeConstraint.Name = "UniversalSizeConstraint"
		sizeConstraint.MinSize = Vector2.new(minWidth, minHeight)
		sizeConstraint.MaxSize = Vector2.new(maxWidth, maxHeight)
		sizeConstraint.Parent = panel
	else
		sizeConstraint.MinSize = Vector2.new(minWidth, minHeight)
		sizeConstraint.MaxSize = Vector2.new(maxWidth, maxHeight)
	end

	local savedSize = Settings.PanelSizes[key]
	if type(savedSize) == "table" then
		local savedW = tonumber(savedSize[1])
		local savedH = tonumber(savedSize[2])
		if savedW and savedH then
			panel.Size = UDim2.fromOffset(
				math.clamp(savedW, minWidth, maxWidth),
				math.clamp(savedH, minHeight, maxHeight)
			)
		end
	end

	local grip = Instance.new("TextButton")
	grip.Name = "UniversalResizeGrip"
	grip.Size = UDim2.fromOffset(18, 18)
	grip.AnchorPoint = Vector2.new(1, 1)
	grip.Position = UDim2.new(1, -3, 1, -3)
	grip.BackgroundTransparency = 1
	grip.Text = "↘"
	grip.TextColor3 = Color3.fromRGB(145, 120, 230)
	grip.TextTransparency = 0.15
	grip.TextSize = 13
	grip.Font = Enum.Font.GothamBold
	grip.AutoButtonColor = false
	grip.ZIndex = math.max(panel.ZIndex + 5, 20)
	grip.Parent = panel

	local resizing = false
	local resizeStartMouse = nil
	local resizeStartSize = nil

	connect(grip.InputBegan, function(input)
		if Settings.GlobalGuiLocked then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			resizing = true
			resizeStartMouse = input.Position
			resizeStartSize = panel.AbsoluteSize
		end
	end)

	connect(UIS.InputChanged, function(input)
		if not resizing or not resizeStartMouse or not resizeStartSize then return end
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - resizeStartMouse
			local width = math.clamp(resizeStartSize.X + delta.X, minWidth, maxWidth)
			local height = math.clamp(resizeStartSize.Y + delta.Y, minHeight, maxHeight)
			panel.Size = UDim2.fromOffset(width, height)
			Settings.PanelSizes[key] = {width, height}
		end
	end)

	connect(UIS.InputEnded, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			local wasResizing = resizing
			resizing = false
			resizeStartMouse = nil
			resizeStartSize = nil
			if wasResizing then
				local size = panel.AbsoluteSize
				Settings.PanelSizes[key] = {size.X, size.Y}
				queuePositionSave()
			end
		end
	end)
end

local function setupUniversalPanelResizers()
	-- Same direct resizing style as ActionsPanel. Limits are chosen per panel so
	-- a panel can be pulled smaller without collapsing its controls completely.
	makePanelResizable(Main, "Main", 300, 650, 300, 650)
	makePanelResizable(HubBanner, "Banner", 220, 460, 60, 150)
	makePanelResizable(BoosterMini, "Boosters", 170, 400, 70, 220)
	makePanelResizable(QuickPanel, "QuickPanel", 300, 620, 80, 620)
	makePanelResizable(CooldownPanel, "CooldownPanel", 210, 360, 286, 520)
	makePanelResizable(APSpamPanel, "APSpam", 280, 620, 220, 620)
	makePanelResizable(APConfigFrame, "APConfig", 190, 420, 180, 500)
	makePanelResizable(APConfigBubble, "APConfigBubble", 70, 220, 28, 100)
	makePanelResizable(DefensePanel, "DefensePanel", 230, 500, 90, 300)
	-- ActionsPanel already has this exact direct width/height resizer.
end

setupUniversalPanelResizers()


updateGUI()
Env.ARXAimbotDesired = State.Aimbot
Env.CarpetSpeedDesired = State.Carpet
Env.CarpetSpeedValueDesired = CarpetSpeed
Env.CarpetSpeedKeyDesired = CarpetKey
Env.InfiniteJumpDesired = State.Jump
Env.ARXCarpetStateChanged = function(enabled)
	State.Carpet = enabled == true
	saveSettings()
	updateGUI()
end
Env.ARXInfiniteJumpStateChanged = function(enabled)
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
    return SharedEnv.ARXGlobalGuiLocked == true
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
local Theme = {c1 = Color3.fromRGB(120, 200, 255), c2 = Color3.fromRGB(255, 120, 220)}
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
    label.Font = font or Enum.Font.Gotham
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

local PRIORITY_SETTINGS_FILE = "ARX_PriorityGUI_Settings.json"
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
local function NotifySetting(name, enabled, stateText)
    local shared = getgenv and getgenv() or _G
    if type(shared.ARXNotify) == "function" then
        shared.ARXNotify(name .. ": " .. (stateText or (enabled and "ON" or "OFF")), enabled)
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
    local titleLabel = Lbl(header, title, 12, T.Text, Enum.Font.GothamBold)
    titleLabel.Size = UDim2.new(1, -38, 1, 0)
    titleLabel.Position = UDim2.fromOffset(10, 0)
    titleLabel.TextYAlignment = Enum.TextYAlignment.Center
    titleLabel.ZIndex = 52
    local close = Instance.new("TextButton")
    close.Size = UDim2.fromOffset(20, 20)
    close.Position = UDim2.new(1, -26, 0, 5)
    close.BackgroundColor3 = T.Soft
    close.Text = "×"
    close.TextColor3 = T.Text
    close.Font = Enum.Font.GothamBold
    close.TextSize = 14
    close.ZIndex = 53
    close.Parent = header
    Corner(close, 6)
    close.Activated:Connect(function() panel.Visible = false end)
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
Main.scroll.Size = UDim2.fromOffset(220, 280)
Main.scroll.AutomaticSize = Enum.AutomaticSize.Y
local launcherPosition = Config.get("panelpos:PriorityLauncher")
Main.scroll.Position = type(launcherPosition) == "table" and #launcherPosition == 4
    and UDim2.new(table.unpack(launcherPosition)) or UDim2.fromOffset(14, 60)
Main.scroll.BackgroundColor3 = T.Bg
Main.scroll.BackgroundTransparency = 0.05
Main.scroll.BorderSizePixel = 0
Main.scroll.Active = true
Main.scroll.Draggable = not IsGlobalGuiLocked()
Main.scroll.ClipsDescendants = true
Main.scroll.ZIndex = 40
Main.scroll.Parent = GUI
Corner(Main.scroll, 14)
local launcherStroke = Instance.new("UIStroke", Main.scroll)
launcherStroke.Color = Theme.c1 or Color3.fromRGB(255, 100, 180)
launcherStroke.Thickness = 1.6
pcall(function() Grad(launcherStroke, nil, nil, 135) end)

-- header bar
local launcherHeader = Instance.new("Frame")
launcherHeader.Name = "Header"
launcherHeader.Size = UDim2.new(1, 0, 0, 32)
launcherHeader.BackgroundColor3 = T.BgDeep or Color3.fromRGB(18, 14, 28)
launcherHeader.BorderSizePixel = 0
launcherHeader.ZIndex = 41
launcherHeader.Parent = Main.scroll
Corner(launcherHeader, 14)
local launcherTitle = Lbl(launcherHeader, "AUTO GRAB", 13, T.Text, Enum.Font.GothamBold)
launcherTitle.Size = UDim2.new(1, -12, 1, 0)
launcherTitle.Position = UDim2.fromOffset(12, 0)
launcherTitle.TextXAlignment = Enum.TextXAlignment.Left
launcherTitle.TextYAlignment = Enum.TextYAlignment.Center
launcherTitle.ZIndex = 42

local launcherLayout = Instance.new("UIListLayout", Main.scroll)
launcherLayout.Padding = UDim.new(0, 5)
launcherLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
launcherLayout.SortOrder = Enum.SortOrder.LayoutOrder
local launcherPad = Instance.new("UIPadding", Main.scroll)
launcherPad.PaddingTop = UDim.new(0, 6)
launcherPad.PaddingBottom = UDim.new(0, 10)
launcherPad.PaddingLeft = UDim.new(0, 8)
launcherPad.PaddingRight = UDim.new(0, 8)
launcherHeader.LayoutOrder = 0
SharedEnv.ARXPriorityApplyGlobalLock = function()
    Main.scroll.Draggable = not IsGlobalGuiLocked()
end
SharedEnv.ARXPriorityApplyGlobalLock()
Main.scroll:GetPropertyChangedSignal("Position"):Connect(function()
    local p = Main.scroll.Position
    Config.set("panelpos:PriorityLauncher", {p.X.Scale, p.X.Offset, p.Y.Scale, p.Y.Offset})
end)
local function Section() end
local function Toggle(parent, name, _, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -4, 0, 34)
    row.BackgroundColor3 = T.Card
    row.BackgroundTransparency = 0.08
    row.BorderSizePixel = 0
    row.Parent = parent
    Corner(row, 10)
    local stroke = Instance.new("UIStroke", row)
    stroke.Color = Color3.fromRGB(70, 60, 90)
    stroke.Thickness = 1
    stroke.Transparency = 0.45

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -70, 1, 0)
    label.Position = UDim2.fromOffset(10, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = T.Text
    label.Font = Enum.Font.GothamBold
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row

    local pill = Instance.new("TextButton")
    pill.Size = UDim2.fromOffset(52, 24)
    pill.Position = UDim2.new(1, -60, 0.5, -12)
    pill.BackgroundColor3 = Color3.fromRGB(55, 45, 70)
    pill.Text = "OFF"
    pill.TextColor3 = Color3.fromRGB(230, 220, 240)
    pill.Font = Enum.Font.GothamBold
    pill.TextSize = 11
    pill.AutoButtonColor = false
    pill.Parent = row
    Corner(pill, 8)

    local control = {value = false}
    function control.set(value)
        local nextValue = value and true or false
        local changed = control.value ~= nextValue
        control.value = nextValue
        if control.value then
            pill.Text = "ON"
            pill.BackgroundColor3 = Color3.fromRGB(34, 150, 90)
            row.BackgroundColor3 = Color3.fromRGB(28, 55, 42)
            stroke.Color = Color3.fromRGB(50, 180, 110)
            stroke.Transparency = 0.25
        else
            pill.Text = "OFF"
            pill.BackgroundColor3 = Color3.fromRGB(55, 45, 70)
            row.BackgroundColor3 = T.Card
            stroke.Color = Color3.fromRGB(70, 60, 90)
            stroke.Transparency = 0.45
        end
        callback(control.value)
        if changed then NotifySetting(name, control.value) end
    end
    local function toggle() control.set(not control.value) end
    pill.Activated:Connect(toggle)
    row.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            -- allow click on row body too (not when dragging panel)
        end
    end)
    local hit = Instance.new("TextButton")
    hit.Size = UDim2.new(1, -64, 1, 0)
    hit.BackgroundTransparency = 1
    hit.Text = ""
    hit.Parent = row
    hit.Activated:Connect(toggle)
    return control
end

local _panelsReady = true
local AutoBigPotion = rawget(_G, "AutoBigPotion")
local BackpackLock = rawget(_G, "BackpackLock")

grabNearestToggle, grabBestToggle, grabPriorityToggle, grabFastToggle = nil, nil, nil, nil
_clearOtherGrabs = nil; _clearOtherGrabs = LPH_NO_VIRTUALIZE(function(keep)
    if keep ~= "n"  and grabNearestToggle  then grabNearestToggle.set(false)  end
    if keep ~= "b"  and grabBestToggle     then grabBestToggle.set(false)     end
    if keep ~= "p"  and grabPriorityToggle then grabPriorityToggle.set(false) end
    if keep ~= "f"  and grabFastToggle     then grabFastToggle.set(false)     end
end)
priorityPanel = MiniPanel("Steal Priority", 220, 40, 260, isMobile and 0.88 or 1)
pcall(function()
    priorityPanel.panel.Size = UDim2.fromOffset(260, 360)
end)
do
    local saved = Config.get("priority_set", nil)
    if type(saved) == "table" then
        for name, v in pairs(saved) do
            if v and AutoGrab and AutoGrab.priority then AutoGrab.priority[name] = true; break end
        end
    end
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
    -- hint removed: player tabs are the UI
    local _priFilter = ""
    local _lastPriFilterApplied = false
    local applyFilter
    local selectedBaseKey = nil  -- one player tab selected; animals show for this only

    -- FADED STYLE: player chips go STRAIGHT RIGHT (horizontal), not down
    local playerTabs = Instance.new("ScrollingFrame")
    playerTabs.Name = "PlayerTabs"
    playerTabs.Size = UDim2.new(1, -4, 0, 34)
    playerTabs.BackgroundTransparency = 1
    playerTabs.BorderSizePixel = 0
    playerTabs.ScrollBarThickness = 2
    playerTabs.ScrollBarImageColor3 = T.White
    playerTabs.ScrollingDirection = Enum.ScrollingDirection.X
    playerTabs.CanvasSize = UDim2.new(0, 0, 0, 0)
    playerTabs.AutomaticCanvasSize = Enum.AutomaticSize.X
    playerTabs.ZIndex = 52
    playerTabs.Parent = priorityPanel.body
    local tabsLayout = Instance.new("UIListLayout")
    tabsLayout.FillDirection = Enum.FillDirection.Horizontal
    tabsLayout.Padding = UDim.new(0, 6)
    tabsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    tabsLayout.Parent = playerTabs
    local tabsPad = Instance.new("UIPadding")
    tabsPad.PaddingLeft = UDim.new(0, 2)
    tabsPad.PaddingRight = UDim.new(0, 2)
    tabsPad.Parent = playerTabs

    local searchBox = Instance.new("TextBox")
    searchBox.Size                   = UDim2.new(1, -4, 0, 24)
    searchBox.BackgroundColor3       = T.Card
    searchBox.BackgroundTransparency = 0.1
    searchBox.BorderSizePixel        = 0
    searchBox.Text                   = ""
    searchBox.PlaceholderText        = "search brainrots..."
    searchBox.PlaceholderColor3      = T.TextMute
    searchBox.TextColor3             = T.Text
    searchBox.Font                   = Enum.Font.Gotham
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
        local ic = Lbl(searchBox, "\u{1F50D}", 11, T.TextMute, Enum.Font.Gotham)
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
                chip.Font                   = Enum.Font.GothamBold
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

    local baseHeaders = {}
    local baseExpanded = {}
    local function getBaseOwnerLabel(rec)
        local plot = rec and rec.plot
        local plotName = tostring(rec and rec.plotName or (plot and plot.Name) or "Unknown Base")
        -- Prefer a real player name when the plot name matches a player.
        local direct = Players:FindFirstChild(plotName)
        if direct then
            return direct.DisplayName .. " (@" .. direct.Name .. ")"
        end
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.Name == plotName or plr.DisplayName == plotName then
                return plr.DisplayName .. " (@" .. plr.Name .. ")"
            end
        end
        -- Some games expose the owner on a sign as a TextLabel/TextButton.
        if plot then
            for _, obj in ipairs(_FH_GetDesc(plot)) do
                if obj:IsA("TextLabel") or obj:IsA("TextButton") then
                    local txt = tostring(obj.Text or "")
                    if txt ~= "" and #txt < 80 then
                        for _, plr in ipairs(Players:GetPlayers()) do
                            if txt == plr.Name or txt == plr.DisplayName or txt:find(plr.Name, 1, true) or txt:find(plr.DisplayName, 1, true) then
                                return plr.DisplayName .. " (@" .. plr.Name .. ")"
                            end
                        end
                    end
                end
            end
        end
        return plotName
    end
    local function ensureBaseHeader(rec)
        local key = tostring(rec and rec.plotName or "")
        if key == "" then key = "Unknown Base" end
        local existing = baseHeaders[key]
        if existing and existing.Parent then
            return existing
        end

        local ownerLabel = getBaseOwnerLabel(rec)
        -- short chip text: DisplayName only when possible
        local chipText = ownerLabel
        local dn, un = ownerLabel:match("^(.-)%s*%(@(.-)%)$")
        if dn and dn ~= "" then chipText = dn end

        local header = Instance.new("TextButton")
        header.Name = "BaseTab_" .. key:gsub("[^%w_]", "_")
        header.AutomaticSize = Enum.AutomaticSize.X
        header.Size = UDim2.fromOffset(0, 28)
        header.BackgroundColor3 = Color3.fromRGB(40, 48, 68)
        header.BackgroundTransparency = 0.05
        header.BorderSizePixel = 0
        header.AutoButtonColor = false
        header.Text = ""
        header.ZIndex = 53
        header.LayoutOrder = baseNumFor(key)
        header.Parent = playerTabs
        Corner(header, 8)
        local line = Stroke(header, Color3.fromRGB(80, 160, 255), 1)
        line.Transparency = 0.4

        local pad = Instance.new("UIPadding")
        pad.PaddingLeft = UDim.new(0, 10)
        pad.PaddingRight = UDim.new(0, 10)
        pad.Parent = header

        local label = Lbl(header, chipText, 11, Color3.fromRGB(200, 220, 255), Enum.Font.GothamBold)
        label.Size = UDim2.fromOffset(0, 28)
        label.AutomaticSize = Enum.AutomaticSize.X
        label.TextXAlignment = Enum.TextXAlignment.Center
        label.TextYAlignment = Enum.TextYAlignment.Center
        label.ZIndex = 54

        local function paintTab()
            local on = selectedBaseKey == key
            if on then
                header.BackgroundColor3 = Color3.fromRGB(55, 145, 255)
                header.BackgroundTransparency = 0
                label.TextColor3 = Color3.new(1, 1, 1)
                line.Transparency = 0.5
                line.Color = Color3.fromRGB(140, 200, 255)
            else
                header.BackgroundColor3 = Color3.fromRGB(40, 48, 68)
                header.BackgroundTransparency = 0.05
                label.TextColor3 = Color3.fromRGB(180, 205, 240)
                line.Transparency = 0.4
                line.Color = Color3.fromRGB(80, 160, 255)
            end
        end
        header:SetAttribute("BaseKey", key)
        header.Activated:Connect(LPH_NO_VIRTUALIZE(function()
            selectedBaseKey = key
            for _, h in pairs(baseHeaders) do
                if h and h.Parent then
                    -- repaint all tabs
                end
            end
            for k, h in pairs(baseHeaders) do
                if h and h.Parent then
                    local on = (k == selectedBaseKey)
                    h.BackgroundColor3 = on and Color3.fromRGB(55, 145, 255) or Color3.fromRGB(40, 48, 68)
                    h.BackgroundTransparency = on and 0 or 0.05
                    local lb = h:FindFirstChildWhichIsA("TextLabel")
                    if lb then lb.TextColor3 = on and Color3.new(1,1,1) or Color3.fromRGB(180, 205, 240) end
                end
            end
            if applyFilter then applyFilter() end
        end))
        paintTab()

        -- auto-select first tab
        if selectedBaseKey == nil then
            selectedBaseKey = key
            paintTab()
        end

        baseHeaders[key] = header
        return header
    end

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
            local _spinConn; _spinConn = RunService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function(dt)
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
        local baseKey = tostring(rec.plotName or "Unknown Base")
        ensureBaseHeader(rec)
        local card = Instance.new("TextButton")
        card.Size             = UDim2.new(1, -6, 0, 84)
        card.BackgroundColor3 = T.Card
        card.AutoButtonColor  = false
        card.Text             = ""
        card.BorderSizePixel  = 0
        card.ZIndex           = 53
        local podOrder = tonumber(rec.pod) or 0
        card.LayoutOrder      = baseNumFor(baseKey) * 1000 + math.clamp(podOrder, 1, 999)
        card.Parent           = scroll
        Corner(card, 8)
        local baseStroke = Stroke(card, T.Line, 1)
        local gradStroke = GradStroke(card, 1.6, 1, 0)
        makeModelViewport(card, rec)
        local nameLbl = Lbl(card, name, 10, T.Text, Enum.Font.GothamBold)
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
        local mutLbl = Lbl(card, rawMut, 9, _initMutC, Enum.Font.GothamBold)
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
        -- Clear BLUE selection indicator shown on the GUI card itself.
        -- This is intentionally separate from the in-world animal/podium highlights.
        local selectedMark = Lbl(card, "✓", 16, Color3.fromRGB(110, 205, 255), Enum.Font.GothamBold)
        selectedMark.Size = UDim2.fromOffset(24, 24)
        selectedMark.Position = UDim2.new(1, -30, 0, 5)
        selectedMark.TextXAlignment = Enum.TextXAlignment.Center
        selectedMark.TextYAlignment = Enum.TextYAlignment.Center
        selectedMark.ZIndex = 60
        selectedMark.Visible = false

        local genLbl = Lbl(card, "", 10, Color3.fromRGB(130, 255, 140), Enum.Font.GothamBold)
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
            -- GUI selection: ONLY the selected Steal Priority card turns BLUE.
            -- This makes it obvious which Brainrot you selected without changing
            -- the rest of the cards. The world highlights are handled separately.
            card.BackgroundColor3   = on and Color3.fromRGB(25, 95, 175) or T.Card
            baseStroke.Color        = on and Color3.fromRGB(70, 195, 255) or T.Line
            baseStroke.Transparency = 0
            gradStroke.Transparency = on and 0 or 1
            selectedMark.Visible    = on
            selectedMark.TextColor3 = on and Color3.fromRGB(115, 220, 255) or Color3.fromRGB(110, 205, 255)
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
            if not wasOn then
                AutoGrab.priority[sig] = true
            end
            -- also set currentTargetSig so steal + highlight lock this slot only
            AutoGrab.currentTargetSig = (not wasOn) and sig or nil
            Config.set("priority_set", AutoGrab.priority)
            for _, r in pairs(rows) do r.paint() end
            _G._FH_ESPNeedList = true
            _G._FH_GammaNeedList = true
            -- INSTANT red on the exact podium/animal for this card
            if type(Env.ARXForcePriorityHighlight) == "function" then
                pcall(Env.ARXForcePriorityHighlight)
            end
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
        rows[sig] = { card = card, paint = paint, update = update, name = name, baseKey = baseKey, baseLabel = getBaseOwnerLabel(rec) }
    end
    applyFilter = LPH_NO_VIRTUALIZE(function()
        -- if selected left the game, pick another tab
        if selectedBaseKey and not baseHeaders[selectedBaseKey] then
            selectedBaseKey = nil
        end
        if selectedBaseKey == nil then
            for k, h in pairs(baseHeaders) do
                if h and h.Parent then selectedBaseKey = k; break end
            end
        end
        for _, r in pairs(rows) do
            if r.card then
                local n = string.lower(tostring(r.name or ""))
                local matches = (_priFilter == "" or n:find(_priFilter, 1, true) ~= nil)
                local show = matches and (r.baseKey == selectedBaseKey)
                r.card.Visible = show
            end
        end
        for k, h in pairs(baseHeaders) do
            if h and h.Parent then
                local on = (k == selectedBaseKey)
                h.BackgroundColor3 = on and Color3.fromRGB(55, 145, 255) or Color3.fromRGB(40, 48, 68)
                h.BackgroundTransparency = on and 0 or 0.05
                local lb = h:FindFirstChildWhichIsA("TextLabel")
                if lb then lb.TextColor3 = on and Color3.new(1,1,1) or Color3.fromRGB(180, 205, 240) end
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
    local indArrow = Lbl(indicator, "▼", 11, T.Accent or T.White, Enum.Font.GothamBold)
    indArrow.Size           = UDim2.new(0, 16, 1, 0)
    indArrow.Position       = UDim2.new(0, 8, 0, 0)
    indArrow.TextXAlignment = Enum.TextXAlignment.Center
    indArrow.ZIndex         = 61
    local indName = Lbl(indicator, "", 10, T.Text, Enum.Font.GothamMedium)
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
    RunService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function(dt)
        if not priorityPanel.panel.Visible then indicator.Visible = false return end
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
                        r.card.LayoutOrder = grp * 10000 + i
                    end
                end
                for sig, r in pairs(rows) do
                    if not present[sig] then
                        if r.card then r.card:Destroy() end
                        rows[sig] = nil
                    else
                        r.paint()
                    end
                end
                -- drop player tabs when that base has zero animals left (player left / empty)
                local basesAlive = {}
                for _, r in pairs(rows) do
                    if r.baseKey then basesAlive[r.baseKey] = true end
                end
                for key, header in pairs(baseHeaders) do
                    if not basesAlive[key] then
                        if header and header.Parent then header:Destroy() end
                        baseHeaders[key] = nil
                        if selectedBaseKey == key then selectedBaseKey = nil end
                    end
                end
                if applyFilter then applyFilter() end
                task.wait(0.3)
            else
                task.wait(1)
            end
        end
    end))
end
AutoGrab = (function()
    local M = { nearest = false, best = false, priorityGrab = false, fast = false, fastGrab = false, _oneShot = false, progress = 0, hasTarget = false, priority = {}, currentTargetSig = nil }
    M.setFast = LPH_NO_VIRTUALIZE(function(v) M.fast = v and true or false end)
    M.setFastGrab = LPH_NO_VIRTUALIZE(function(v) M.fastGrab = v and true or false; if not M.fastGrab then M._fastHoldStart = nil end end)
    M.setNearest = LPH_NO_VIRTUALIZE(function(v)      M.nearest      = v and true or false end)
    M.setBest = LPH_NO_VIRTUALIZE(function(v)         M.best         = v and true or false end)
    M.setPriorityGrab = LPH_NO_VIRTUALIZE(function(v) M.priorityGrab = v and true or false end)
    M.togglePriority = LPH_NO_VIRTUALIZE(function(name)
        if M.priority[name] then M.priority[name] = nil else M.priority[name] = true end
        return M.priority[name] == true
    end)
    M.isPriority = LPH_NO_VIRTUALIZE(function(name) return M.priority[name] == true end)
    M.hasPriority = LPH_NO_VIRTUALIZE(function()    return next(M.priority) ~= nil end)
    M.animalList = {}
    task.spawn(function()
        local ok, err = pcall(function()
            local cloneref  = cloneref or LPH_NO_VIRTUALIZE(function(o) return o end)
            local Players   = cloneref(game:GetService("Players"))
            local Workspace = cloneref(game:GetService("Workspace"))
            local player    = Players.LocalPlayer or Players.PlayerAdded:Wait()
            local isMyPlot; isMyPlot = LPH_NO_VIRTUALIZE(function(plot)
                if not plot or not plot:IsA("Model") then return false end
                local sign = plot:FindFirstChild("PlotSign")
                return sign and sign:FindFirstChild("YourBase") and sign.YourBase.Enabled
            end)
            local _scIsJunk; _scIsJunk = LPH_NO_VIRTUALIZE(function(s)
                if not s or s == "" or #s < 3 then return true end
                if s == "Model" then return true end
                if s:match("^%d+$") then return true end
                if s:match("^%d+%.%d") then return true end
                if not s:match("%a") then return true end
                if s:lower():find("podium") then return true end
                if s:match("^%x%x%x%x%x%x%x%x%-%x+%-%x+%-%x+%-%x+$") then return true end
                if #s > 20 and s:match("^[%x%-]+$") then return true end
                return false
            end)
            local scanAllPlots; scanAllPlots = LPH_NO_VIRTUALIZE(function()
                local result = {}
                local _scanYield = 0
                local plots = Workspace:FindFirstChild("Plots")
                if not plots then return result end
                for _, plot in ipairs(plots:GetChildren()) do
                    if not isMyPlot(plot) then
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
                                            local lower = string.lower(petName)
                                            local matchModel; matchModel = LPH_NO_VIRTUALIZE(function(root)
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
                                            end)

                                            -- Match the actual Brainrot model by name first.
                                            -- Never use a player's character as the selected animal fallback.
                                            modelInst = matchModel(plot)
                                            if not modelInst and pos then
                                                local bestModel, bestDist = nil, math.huge
                                                for _, ch in ipairs(plot:GetChildren()) do
                                                    if ch:IsA("Model") and ch ~= podium then
                                                        local isPlayerCharacter = Players:GetPlayerFromCharacter(ch) ~= nil
                                                        if not isPlayerCharacter then
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
                                                    end
                                                end
                                                modelInst = bestModel
                                            end
                                        end
                                        local _agGenVal, _agMut, _agTr = 0, nil, nil
                                        pcall(function()
                                            local _fetchFn = _G._FH_FetchPlotData or _G._FH_PlotData
                                            local _agSh    = _G._FH_AnimalsShared
                                            if _fetchFn and podNum then
                                                local _cache = _fetchFn(plot.Name)
                                                local _al    = _cache and _cache.AnimalList
                                                if typeof(_al) == "table" then
                                                    local _d = _al[podNum] or _al[tostring(podNum)]
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
                                            podiumInst  = podium,
                                            mutation    = _agMut,
                                            traits      = _agTr,
                                            plot        = plot,
                                        })
                                    end))
                                end
                            end
                        end))
                    end
                end
                return result
            end)
            local CachedBrainrots = {}
            local _agScanBusy = false
            task.spawn(LPH_NO_VIRTUALIZE(function()
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
                                    local list = {}
                                    for _, br in ipairs(fresh) do
                                        list[#list + 1] = {
                                            name     = br.displayName, modelName = br.modelName,
                                            modelInst = br.modelInst,
                                            podiumInst = br.podiumInst,
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
                        task.wait(0.3)
                    end
                end
            end))
            local getNearest; getNearest = LPH_NO_VIRTUALIZE(function()
                local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if not hrp then return nil end
                local best, bestDist = nil, math.huge
                for _, br in ipairs(CachedBrainrots) do
                    local d = (br.pos - hrp.Position).Magnitude
                    if d < bestDist then bestDist = d; best = br end
                end
                return best
            end)
            local getBest; getBest = LPH_NO_VIRTUALIZE(function()
                return CachedBrainrots[1]
            end)
            local getPriorityTarget; getPriorityTarget = LPH_NO_VIRTUALIZE(function()
                if not M.hasPriority() then return nil end
                local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if not hrp then return nil end
                local best, bestDist = nil, math.huge
                for _, br in ipairs(CachedBrainrots) do
                    local brsig = br.sig
                    if M.priority[brsig] then
                        local d = (br.pos - hrp.Position).Magnitude
                        if d < bestDist then bestDist = d; best = br end
                    end
                end
                return best
            end)
            local isActive; isActive = LPH_NO_VIRTUALIZE(function() return M.nearest or M.best or M.priorityGrab or M.fastGrab or M._oneShot end)
            local _harvestCache = {}
            local harvest; harvest = LPH_NO_VIRTUALIZE(function(prompt)
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
            end)
            local MIN_HOLD  = 1.3
            -- MIN_HOLD fills the bar; the additional two seconds are the full
            -- 100%-progress grab window.
            local WAIT_STOP = MIN_HOLD + 2.0
            M.waitUntil = 0
            local grabActive = {}
            local _potNextOk = 0
            local shouldPopPotion; shouldPopPotion = LPH_NO_VIRTUALIZE(function(prompt)
                if not (AutoBigPotion and AutoBigPotion.activate and AutoBigPotion.enabled) then return false end
                if not prompt or not prompt.Parent then return false end
                if prompt.ActionText ~= "Steal" then return false end
                if os.clock() < _potNextOk then return false end
                if not (M.nearest or M.best or M.priorityGrab) and not isInEnemyPlot() then return false end
                _potNextOk = os.clock() + 5
                return true
            end)
            local _fastLastFire = {}
            local fireFastSteal; fireFastSteal = LPH_NO_VIRTUALIZE(function(prompt, sig)
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
                    pcall(AutoBigPotion.activate)
                end
                for i = 1, 25 do
                    if not prompt.Parent then break end
                    pcall(fireproximityprompt, prompt, 0)
                end
                M.progress  = 0
                M.hasTarget = false
                return true
            end)
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
                    pcall(LPH_NO_VIRTUALIZE(function() prompt.MaxActivationDistance = 9e9 end))
                    pcall(LPH_NO_VIRTUALIZE(function() prompt.RequiresLineOfSight = false end))
                    for _, fn in ipairs(hold) do task.spawn(fn) end
                    M._fastHoldStart = tick()
                    M.progress = 0.5
                    local remain = MIN_HOLD - (tick() - M._fastHoldStart)
                    if remain > 0 then task.wait(remain) end
                    if not prompt or not prompt.Parent then
                        pcall(LPH_NO_VIRTUALIZE(function() prompt.MaxActivationDistance = origDist end))
                        grabActive[prompt] = nil
                        M._fastHoldStart = nil
                        M.progress = 0
                        return false
                    end
                    M.progress = 1
                    if shouldPopPotion(prompt) then pcall(AutoBigPotion.activate) end
                    local fired = false
                    if #trigger > 0 then
                        for _, fn in ipairs(trigger) do task.spawn(fn) end
                        fired = true
                    elseif type(fireproximityprompt) == "function" then
                        pcall(fireproximityprompt, prompt)
                        fired = true
                    end
                    for _, fn in ipairs(holdEnd) do task.spawn(fn) end
                    pcall(LPH_NO_VIRTUALIZE(function() prompt.MaxActivationDistance = origDist end))
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
                pcall(LPH_NO_VIRTUALIZE(function() prompt.MaxActivationDistance = 9e9 end))
                pcall(LPH_NO_VIRTUALIZE(function() prompt.RequiresLineOfSight = false end))
                for _, fn in ipairs(hold) do task.spawn(fn) end
                local startedAt = tick()
                while tick() - startedAt < MIN_HOLD do
                    if not isActive() then break end
                    if nearestSig then
                        local nn = getNearest()
                        local ns = nn and (nn.sig)
                        if ns ~= nearestSig then
                            pcall(LPH_NO_VIRTUALIZE(function() prompt.MaxActivationDistance = origDist end))
                            grabActive[prompt] = nil
                            M.progress = 0
                            return false
                        end
                    end
                    M.progress = math.clamp((tick() - startedAt) / MIN_HOLD, 0, 1)
                    RunService.RenderStepped:Wait()
                end
                M.progress = 1
                local dist; dist = LPH_NO_VIRTUALIZE(function()
                    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                    if not hrp or not prompt.Parent then return math.huge end
                    local pp  = prompt.Parent
                    local pos = pp:IsA("Attachment") and pp.WorldPosition or (pp:IsA("BasePart") and pp.Position) or nil
                    if not pos then return math.huge end
                    return (hrp.Position - pos).Magnitude
                end)
                local alreadyInRange = dist() <= 10
                local fired = false
                M.waitUntil = startedAt + WAIT_STOP
                while isActive() do
                    local elapsed = tick() - startedAt
                    if elapsed > WAIT_STOP then break end
                    if not prompt.Parent then break end
                    if nearestSig then
                        local nn = getNearest()
                        local ns = nn and (nn.sig)
                        if ns ~= nearestSig then
                            pcall(LPH_NO_VIRTUALIZE(function() prompt.MaxActivationDistance = origDist end))
                            grabActive[prompt] = nil
                            M.waitUntil = 0
                            M.progress  = 0
                            return false
                        end
                    end
                    if dist() <= 10 then
                        if not alreadyInRange and not M.fast and not M.fastGrab then task.wait(0.3) end
                        -- Progress is already 100% here and the player is within
                        -- grab range. Drink at the start of the final 2s window.
                        if (M.nearest or M.priorityGrab) and shouldPopPotion(prompt) then
                            pcall(AutoBigPotion.activate)
                        end
                        if prompt.Parent and #trigger > 0 then
                            for _, fn in ipairs(trigger) do task.spawn(fn) end
                            fired = true
                        end
                        break
                    end
                    RunService.RenderStepped:Wait()
                end
                M.waitUntil = 0
                if prompt and prompt.Parent then
                    pcall(LPH_NO_VIRTUALIZE(function() prompt.MaxActivationDistance = origDist end))
                end
                grabActive[prompt] = nil
                M.progress = 0
                return fired
            end
            M.findBySig = LPH_NO_VIRTUALIZE(function(sig)
                for _, br in ipairs(CachedBrainrots) do
                    local s = br.sig
                    if s == sig then return br end
                end
                return nil
            end)
            M.posOfSig = LPH_NO_VIRTUALIZE(function(sig)
                local br = M.findBySig(sig)
                return br and br.pos or nil
            end)
            function M.stealSigOnce(sig)
                local br = M.findBySig(sig)
                if not (br and br.prompt and br.prompt.Parent) then return false end
                local prompt = br.prompt
                if grabActive[prompt] then return false end
                grabActive[prompt] = true
                local origDist = prompt.MaxActivationDistance
                pcall(LPH_NO_VIRTUALIZE(function() prompt.MaxActivationDistance = 9e9 end))
                pcall(LPH_NO_VIRTUALIZE(function() prompt.RequiresLineOfSight   = false end))
                local hold, trigger = harvest(prompt)
                if BackpackLock and BackpackLock.suspend then pcall(LPH_NO_VIRTUALIZE(function() BackpackLock.suspend(MIN_HOLD + 8) end)) end
                for _, fn in ipairs(hold) do task.spawn(fn) end
                task.wait(MIN_HOLD)
                local dist; dist = LPH_NO_VIRTUALIZE(function()
                    local c = player.Character
                    local h = c and c:FindFirstChild("HumanoidRootPart")
                    if not h or not prompt.Parent then return math.huge end
                    local pp  = prompt.Parent
                    local pos = pp:IsA("Attachment") and pp.WorldPosition
                        or (pp:IsA("BasePart") and pp.Position) or nil
                    if not pos then return math.huge end
                    return (h.Position - pos).Magnitude
                end)
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
                    pcall(LPH_NO_VIRTUALIZE(function() prompt.MaxActivationDistance = origDist end))
                end
                grabActive[prompt] = nil
                return fired
            end
            M.MIN_HOLD = MIN_HOLD
            local loop; loop = LPH_NO_VIRTUALIZE(function()
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
                            M.currentTargetSig = target.sig
                            local _nearSig = (M.nearest or M.fastGrab) and M.currentTargetSig or nil
                            firePatchedSteal(prompt, _nearSig)
                            if M.fast then RunService.Heartbeat:Wait() end
                        end
                    else
                        M.hasTarget = false
                        M.progress  = 0
                        M.currentTargetSig = nil
                        M.targetPodium = nil
                        task.wait(0.05)
                    end
                end
                M.progress  = 0
                M.hasTarget = false
                M.currentTargetSig = nil
                M.targetPodium = nil
                M.waitUntil = 0
                M._fastHoldStart = nil
            end)
            while true do
                if isActive() then loop() end
                task.wait(0.2)
            end
        end)
    end)
    _G._FH_AutoGrab = M
    _G.AutoGrab = M
    return M
end)()
_G._FH_AutoGrab = AutoGrab
_G.AutoGrab = AutoGrab
do
    local bar = Instance.new("Frame")
    bar.Name                   = "AutoGrabBar"
    bar.Size                   = UDim2.new(0, 210, 0, 44)
    bar.Position               = UDim2.new(0.5, -105, 0.5, -22)
    bar.BackgroundColor3       = T.Bg
    bar.BackgroundTransparency = 0.18
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
    local title = Lbl(bar, "AUTO GRAB", 11, T.Text, Enum.Font.GothamBold)
    title.Size     = UDim2.new(0, 66, 0, 14)
    title.Position = UDim2.new(0, 24, 0, 7)
    title.ZIndex   = 61
    local nameMid = Lbl(bar, "", 11, T.White, Enum.Font.GothamBold)
    nameMid.Size           = UDim2.new(1, -116, 0, 14)
    nameMid.Position       = UDim2.new(0, 92, 0, 7)
    nameMid.TextTruncate   = Enum.TextTruncate.AtEnd
    nameMid.ZIndex         = 61
    local pct = Lbl(bar, "0%", 11, T.TextDim, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
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
    local pctMid = Lbl(bar, "0%", 9, T.White, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
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
local _restoringGrab = false
grabNearestToggle = Toggle(Main.scroll, "Auto Grab Nearest", "", LPH_NO_VIRTUALIZE(function(on)
    AutoGrab.setNearest(on)
    if not on then AutoGrab.setFast(false) end
    if on then _clearOtherGrabs("n"); AutoGrab.setFast(false) end
    if not _restoringGrab then
        Config.set("grab_nearest", on and true or false)
        if on then
            Config.set("grab_best", false)
            Config.set("grab_priority", false)
        end
    end
end))
grabBestToggle = Toggle(Main.scroll, "Auto Grab Best", "", LPH_NO_VIRTUALIZE(function(on)
    AutoGrab.setBest(on)
    if not on then AutoGrab.setFast(false) end
    if on then _clearOtherGrabs("b"); AutoGrab.setFast(false) end
    if not _restoringGrab then
        Config.set("grab_best", on and true or false)
        if on then
            Config.set("grab_nearest", false)
            Config.set("grab_priority", false)
        end
    end
end))
grabPriorityToggle = Toggle(Main.scroll, "Auto Steal Priority", "", LPH_NO_VIRTUALIZE(function(on)
    AutoGrab.setPriorityGrab(on)
    if _panelsReady then priorityPanel.panel.Visible = on end
    if not on then AutoGrab.setFast(false) end
    if on then _clearOtherGrabs("p"); AutoGrab.setFast(false) end
    if not _restoringGrab then
        Config.set("grab_priority", on and true or false)
        if on then
            Config.set("grab_nearest", false)
            Config.set("grab_best", false)
        end
    end
end))

-- Restore last Auto Grab mode after rejoin / re-execute
task.defer(function()
    task.wait(0.15)
    if not grabNearestToggle then return end
    local wantN = Config.get("grab_nearest", false) == true
    local wantB = Config.get("grab_best", false) == true
    local wantP = Config.get("grab_priority", false) == true
    if not (wantN or wantB or wantP) then return end
    _restoringGrab = true
    pcall(function()
        if wantP then
            grabPriorityToggle.set(true)
        elseif wantN then
            grabNearestToggle.set(true)
        elseif wantB then
            grabBestToggle.set(true)
        end
    end)
    _restoringGrab = false
end)

-- Individual keybinds for Nearest, Best, and Steal Priority.
local autoGrabKeyNames = {
    nearest = tostring(Config.get("nearest_key", "N")),
    best = tostring(Config.get("best_key", "B")),
    priority = tostring(Config.get("priority_key", "G")),
}
local autoGrabKeys = {
    nearest = Enum.KeyCode[autoGrabKeyNames.nearest] or Enum.KeyCode.N,
    best = Enum.KeyCode[autoGrabKeyNames.best] or Enum.KeyCode.B,
    priority = Enum.KeyCode[autoGrabKeyNames.priority] or Enum.KeyCode.G,
}
local choosingGrabKey = nil
local grabKeyButtons = {}

local function makeGrabKeyButton(label, mode, fallback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -4, 0, 32)
    button.BackgroundColor3 = T.Card
    button.BackgroundTransparency = 0.08
    button.TextColor3 = T.Text
    button.Font = Enum.Font.GothamBold
    button.TextSize = 11
    button.AutoButtonColor = false
    button.Parent = Main.scroll
    Corner(button, 10)
    local ks = Instance.new("UIStroke", button)
    ks.Color = Color3.fromRGB(70, 60, 90)
    ks.Thickness = 1
    ks.Transparency = 0.45

    local function refresh()
        button.Text = label .. " Keybind: " .. autoGrabKeys[mode].Name
        button.BackgroundColor3 = choosingGrabKey == mode and Color3.fromRGB(150, 105, 35) or T.Card
        ks.Color = choosingGrabKey == mode and Color3.fromRGB(220, 160, 50) or Color3.fromRGB(70, 60, 90)
    end
    refresh()
    button.Activated:Connect(function()
        choosingGrabKey = mode
        refresh()
        for otherMode, otherButton in pairs(grabKeyButtons) do
            if otherMode ~= mode then
                otherButton.refresh()
            end
        end
    end)
    grabKeyButtons[mode] = {button = button, refresh = refresh}
    return button
end

makeGrabKeyButton("Nearest", "nearest", Enum.KeyCode.N)
makeGrabKeyButton("Best", "best", Enum.KeyCode.B)
makeGrabKeyButton("Priority", "priority", Enum.KeyCode.G)

UserInputService.InputBegan:Connect(function(input, processed)
    if _GEN ~= _G._FH_GAMMA_GEN then return end
    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end

    if choosingGrabKey then
        if input.KeyCode ~= Enum.KeyCode.Unknown then
            local mode = choosingGrabKey
            autoGrabKeys[mode] = input.KeyCode
            Config.set(mode .. "_key", input.KeyCode.Name)
            NotifySetting((mode == "nearest" and "Nearest Keybind") or (mode == "best" and "Best Keybind") or "Priority Keybind", true, input.KeyCode.Name)
        end
        choosingGrabKey = nil
        for _, entry in pairs(grabKeyButtons) do entry.refresh() end
        return
    end

    if processed or UserInputService:GetFocusedTextBox() then return end
    if input.KeyCode == autoGrabKeys.nearest and grabNearestToggle then
        grabNearestToggle.set(not grabNearestToggle.value)
    elseif input.KeyCode == autoGrabKeys.best and grabBestToggle then
        grabBestToggle.set(not grabBestToggle.value)
    elseif input.KeyCode == autoGrabKeys.priority and grabPriorityToggle then
        grabPriorityToggle.set(not grabPriorityToggle.value)
    end
end)

-- Starts OFF. Use the toggles or the saved custom keybinds to enable them.
]====]))()

-- AIMBOT IMPLEMENTATION (isolated chunk)
;(loadstring([====[
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LP = Players.LocalPlayer
local Env = getgenv and getgenv() or _G

if type(Env.ARXAimbotCleanup) == "function" then
    pcall(Env.ARXAimbotCleanup)
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
    Generation = (tonumber(Env.ARXAimbotGeneration) or 0) + 1,
}
Env.ARXAimbotGeneration = Aim.Generation

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
        while Aim.Active and Env.ARXAimbotGeneration == Aim.Generation do
            updateTarget()
            task.wait(0.1)
        end
    end)
end

Env.ARXAimbotSet = function(enabled)
    if enabled then start() else stop() end
end
Env.ARXAimbotCleanup = function()
    stop()
    if Env.ARXAimbotGeneration == Aim.Generation then
        Env.ARXAimbotGeneration = Aim.Generation + 1
    end
end

Env.ARXAimbotSet(Env.ARXAimbotDesired == true)
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
    Tool = "Flying Carpet",
    Keybind = (typeof(Env.CarpetSpeedKeyDesired) == "EnumItem" and Env.CarpetSpeedKeyDesired) or Enum.KeyCode.Q,
    TickRate = 0.03,
}

local CARPET_NAMES = {
    "Flying Carpet", "FlyingCarpet", "Witch's Broom", "Witch'sBroom", "WitchBroom",
    "Cupid's Wings", "Cupid'sWings", "CupidWings", "Santa's Sleigh", "Santa'sSleigh",
    "SantaSleigh", "Waverider", "Magic Carpet", "Carpet",
}

local carpetConnection
local inputConnection

local function findCarpetTool(container)
    if not container then return nil end
    for _, name in ipairs(CARPET_NAMES) do
        local t = container:FindFirstChild(name)
        if t and t:IsA("Tool") then return t end
    end
    -- fuzzy: any tool with carpet/broom/sleigh/waverider in name
    for _, t in ipairs(container:GetChildren()) do
        if t:IsA("Tool") then
            local n = string.lower(t.Name)
            if n:find("carpet", 1, true) or n:find("broom", 1, true)
                or n:find("sleigh", 1, true) or n:find("waverider", 1, true)
                or n:find("wing", 1, true) then
                return t
            end
        end
    end
    return nil
end

local function equippedCarpet(character)
    if not character then return nil end
    return findCarpetTool(character)
end

local function equipCarpetOnce()
    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return false end
    if equippedCarpet(character) then return true end
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    local tool = findCarpetTool(backpack)
    if tool then
        pcall(function() humanoid:EquipTool(tool) end)
        task.wait(0.15)
        return equippedCarpet(character) ~= nil
    end
    return false
end

local function stopVelocity()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root then
        pcall(function()
            root.AssemblyLinearVelocity = Vector3.new(0, root.AssemblyLinearVelocity.Y, 0)
        end)
        pcall(function()
            root.Velocity = Vector3.new(0, root.Velocity.Y, 0)
        end)
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
        if type(Env.ARXCarpetStateChanged) == "function" then Env.ARXCarpetStateChanged(false) end
        return false
    end

    local lastTick = 0
    -- one-shot equip attempt when turning ON (not every frame)
    task.defer(function()
        pcall(equipCarpetOnce)
    end)
    carpetConnection = RunService.Heartbeat:Connect(function()
        -- only pause during real TP flags that still matter; do NOT block on AntiDrop spoof
        if Env.SabcomPostTPCooldown and os.clock() < Env.SabcomPostTPCooldown then return end

        local now = tick()
        if now - lastTick < Config.TickRate then return end
        lastTick = now

        local character = LocalPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if not humanoid or not root or humanoid.Health <= 0 then return end

        -- must have carpet (or broom/sleigh) equipped — no spam re-equip every tick
        if not equippedCarpet(character) then return end

        local direction = humanoid.MoveDirection
        local spd = tonumber(Config.Speed) or 140
        if direction.Magnitude > 0.05 then
            local vx = direction.X * spd
            local vz = direction.Z * spd
            local vy = root.AssemblyLinearVelocity.Y
            pcall(function()
                root.AssemblyLinearVelocity = Vector3.new(vx, vy, vz)
            end)
            pcall(function()
                root.Velocity = Vector3.new(vx, root.Velocity.Y, vz)
            end)
        else
            stopVelocity()
        end
    end)
    if type(Env.ARXCarpetStateChanged) == "function" then Env.ARXCarpetStateChanged(true) end
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
    if input.KeyCode == Config.Keybind then
        local enabled = toggleCarpetSpeed()
        if type(Env.ARXNotify) == "function" then
            Env.ARXNotify("Carpet Booster: " .. (enabled and "ON" or "OFF"), enabled)
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

local function setInfiniteJumpEnabled(enabled)
    Config.Enabled = enabled == true
    if type(Env.ARXInfiniteJumpStateChanged) == "function" then
        Env.ARXInfiniteJumpStateChanged(Config.Enabled)
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

local holdingJump = false
local jumpConn

local function doJumpPulse()
    if not Config.Enabled then return end
    local now = tick()
    if now - lastJump < Config.Interval then return end
    local character = LocalPlayer.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not root or not humanoid or humanoid.Health <= 0 or humanoid.Sit then return end
    lastJump = now
    root.AssemblyLinearVelocity = Vector3.new(
        root.AssemblyLinearVelocity.X,
        Config.RiseVelocity,
        root.AssemblyLinearVelocity.Z
    )
end

-- PC: hold Space
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Space then holdingJump = true end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Space then holdingJump = false end
end)

-- Mobile: JumpRequest fires while jump is held/tapped
pcall(function()
    local hum
    local function hookHum(h)
        if jumpConn then jumpConn:Disconnect() jumpConn = nil end
        if not h then return end
        jumpConn = h.JumpRequest:Connect(function()
            if Config.Enabled then
                holdingJump = true
                doJumpPulse()
            end
        end)
    end
    LocalPlayer.CharacterAdded:Connect(function(c)
        task.wait(0.2)
        hookHum(c:FindFirstChildOfClass("Humanoid") or c:WaitForChild("Humanoid", 5))
    end)
    if LocalPlayer.Character then
        hookHum(LocalPlayer.Character:FindFirstChildOfClass("Humanoid"))
    end
end)

heartbeatConnection = RunService.Heartbeat:Connect(function()
    if not Config.Enabled then return end
    -- Space held (PC) or recent JumpRequest (mobile)
    local space = false
    pcall(function() space = UserInputService:IsKeyDown(Enum.KeyCode.Space) end)
    if space or holdingJump then
        doJumpPulse()
    end
    -- mobile: clear hold shortly after JumpRequest so it does not stuck-fly forever
    if holdingJump and not space then
        -- keep pulsing only while JumpRequest keeps coming; decay handled by interval
    end
end)

Env.SetInfiniteJump = setInfiniteJumpEnabled
Env.ToggleInfiniteJump = toggleInfiniteJump
Env.SetInfiniteJumpPower = setInfiniteJumpPower
Env.SetInfiniteJumpInterval = setInfiniteJumpInterval
Env.GetInfiniteJumpState = function() return Config.Enabled end
Env.InfiniteJumpCleanup = function()
    Config.Enabled = false
    if heartbeatConnection then heartbeatConnection:Disconnect(); heartbeatConnection = nil end
end
]====]))()

-- ============================================================================
-- GAMMA NETWORK DETECTION LAYER (Enhanced Capabilities)
-- ============================================================================

if not _G._FH_NET then
    _G._FH_NET = {}
    task.spawn(function()
        local ok0, _ = pcall(function()
            local cloneref       = cloneref or function(o) return o end
            local RS             = cloneref(game:GetService("ReplicatedStorage"))
            local getconstants   = (debug and debug.getconstants) or getconstants

            local ok1, netFolder = pcall(function()
                return RS:WaitForChild("Packages", 20):WaitForChild("Net", 20)
            end)
            if not ok1 or not netFolder then return end

            pcall(function()
                if not (getconnections and getconstants) then return end
                for _, r in ipairs(netFolder:GetChildren()) do
                    if r:IsA("RemoteEvent") then
                        local okC, conns = pcall(getconnections, r.OnClientEvent)
                        if okC then
                            for _, c in ipairs(conns) do
                                if type(c.Function) == "function" then
                                    local okK, consts = pcall(getconstants, c.Function)
                                    if okK and consts then
                                        for _, k in ipairs(consts) do
                                            if k == "PaintballHitted" then _G._FH_NET.UseItem = r; break end
                                        end
                                    end
                                end
                                if _G._FH_NET.UseItem then break end
                            end
                        end
                    end
                    if _G._FH_NET.UseItem then break end
                end
            end)

        end)
    end)
end

pcall(function()
	if GUI then GUI.Enabled = true end
	if ShawnButton then ShawnButton.Visible = true end
	if HubBanner then HubBanner.Visible = true end
end)

-- ============================================================
-- ANTI DROP + LINEAR VELOCITY ENGINE (Orvyn-style, no remote load)
-- ============================================================
;(loadstring([====[
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer
local Env = getgenv and getgenv() or _G

if type(Env.ARXAntiDropCleanup) == "function" then
	pcall(Env.ARXAntiDropCleanup)
end

local Master = Env.ARXAntiDropDesired == true
local Active = false -- Master on AND currently applying engine
local NS = 30
local CS = 30
local spoofedVelocity = Vector3.zero
local _linVel, _linVelAtt0, _linVelAtt1, _linVelChar = nil, nil, nil, nil
local lastMoveDir = Vector3.zero
local renderConn, heartConn, charConn = nil, nil, nil
local mtHooked = false

local MOVE_KEYS = {
	[Enum.KeyCode.W] = true, [Enum.KeyCode.A] = true,
	[Enum.KeyCode.S] = true, [Enum.KeyCode.D] = true,
	[Enum.KeyCode.Up] = true, [Enum.KeyCode.Left] = true,
	[Enum.KeyCode.Down] = true, [Enum.KeyCode.Right] = true,
}

local STEAL_ATTRS = {
	"Stealing", "steal", "stolen", "isStealing", "IsSteal", "issteal", "Steal", "HoldingBrainrot",
}

local function isCarrying()
	if not LP then return false end
	for _, name in ipairs(STEAL_ATTRS) do
		local v = LP:GetAttribute(name)
		if v ~= nil and v ~= false and v ~= 0 then return true end
	end
	local char = LP.Character
	if typeof(char) == "Instance" then
		for _, name in ipairs(STEAL_ATTRS) do
			local v = char:GetAttribute(name)
			if v ~= nil and v ~= false and v ~= 0 then return true end
		end
	end
	return false
end

local function isRagdollState(hum)
	if not hum then return true end
	local st = hum:GetState()
	return hum.PlatformStand == true
		or st == Enum.HumanoidStateType.Physics
		or st == Enum.HumanoidStateType.Ragdoll
end

local function destroyLinVel()
	if _linVel then pcall(function() _linVel:Destroy() end) end
	if _linVelAtt0 then pcall(function() _linVelAtt0:Destroy() end) end
	if _linVelAtt1 then pcall(function() _linVelAtt1:Destroy() end) end
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
	local att0 = Instance.new("Attachment")
	att0.Name = "ARXLinVelAtt0"
	att0.Parent = hrp
	local att1 = Instance.new("Attachment")
	att1.Name = "ARXLinVelAtt1"
	att1.Parent = hrp
	local lv = Instance.new("LinearVelocity")
	lv.Name = "ARXLinVel"
	lv.Attachment0 = att0
	lv.Attachment1 = att1
	lv.VelocityConstraintMode = Enum.VelocityConstraintMode.Plane
	lv.PrimaryTangentAxis = Vector3.new(1, 0, 0)
	lv.SecondaryTangentAxis = Vector3.new(0, 0, 1)
	lv.RelativeTo = Enum.ActuatorRelativeTo.World
	lv.MaxForce = 1e6
	lv.PlaneVelocity = Vector2.new(0, 0)
	lv.Parent = hrp
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
	local char = LP.Character
	if not char then return false end
	if _linVel and _linVel.Parent and _linVelChar == char then
		return true
	end
	setupLinearVelocity(char)
	return _linVel ~= nil and _linVel.Parent ~= nil
end

local function ensureMtHook()
	if mtHooked then return true end
	local ok = pcall(function()
		if not (getrawmetatable and setreadonly and newcclosure) then
			-- fallback hookmetamethod
			if type(hookmetamethod) == "function" and type(newcclosure) == "function" then
				local check = checkcaller or function() return false end
				local oldIndex
				oldIndex = hookmetamethod(game, "__index", newcclosure(function(self, key)
					if Active and not check() and (key == "AssemblyLinearVelocity" or key == "Velocity") then
						if typeof(self) == "Instance" and self:IsA("BasePart")
							and self.Name == "HumanoidRootPart"
							and LP.Character and self:IsDescendantOf(LP.Character) then
							return spoofedVelocity
						end
					end
					return oldIndex(self, key)
				end))
				local oldNewIndex
				oldNewIndex = hookmetamethod(game, "__newindex", newcclosure(function(self, key, value)
					if Active and not check() and (key == "AssemblyLinearVelocity" or key == "Velocity") then
						if typeof(self) == "Instance" and self:IsA("BasePart")
							and self.Name == "HumanoidRootPart"
							and LP.Character and self:IsDescendantOf(LP.Character) then
							return
						end
					end
					return oldNewIndex(self, key, value)
				end))
				return
			end
			return
		end
		local mt = getrawmetatable(game)
		setreadonly(mt, false)
		local oldIndex = mt.__index
		mt.__index = newcclosure(function(self, key)
			if Active and (key == "AssemblyLinearVelocity" or key == "Velocity") then
				if typeof(self) == "Instance" and self:IsA("BasePart")
					and self.Name == "HumanoidRootPart"
					and LP.Character and self:IsDescendantOf(LP.Character) then
					return spoofedVelocity
				end
			end
			return oldIndex(self, key)
		end)
		local oldNewIndex = mt.__newindex
		mt.__newindex = newcclosure(function(self, key, value)
			if Active and (key == "AssemblyLinearVelocity" or key == "Velocity") then
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
	mtHooked = ok and true or false
	return mtHooked
end

local function setActive(on)
	on = on and true or false
	if Active == on then return end
	Active = on
	if Active then
		ensureMtHook()
		ensureLinVel()
		spoofedVelocity = Vector3.zero
		Env.SabcomIsTeleporting = true -- pause other speed systems
	else
		clearLinVel()
		destroyLinVel()
		spoofedVelocity = Vector3.zero
		Env.SabcomIsTeleporting = false
		lastMoveDir = Vector3.zero
	end
	if type(Env.ARXAntiDropStateChanged) == "function" then
		pcall(Env.ARXAntiDropStateChanged, Master, Active)
	end
end

local function setMaster(on)
	Master = on and true or false
	Env.ARXAntiDropDesired = Master
	if not Master then
		setActive(false)
	end
	if type(Env.ARXAntiDropStateChanged) == "function" then
		pcall(Env.ARXAntiDropStateChanged, Master, Active)
	end
	return Master
end

local function tickEngine()
	if not Master then
		setActive(false)
		return
	end
	-- Active only while carrying (same idea as before: less detect when not holding)
	local carry = isCarrying()
	setActive(carry)
	if not Active then return end

	local char = LP.Character
	if not char then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hum or not hrp then return end

	if isRagdollState(hum) then
		lastMoveDir = Vector3.zero
		clearLinVel()
		return
	end

	ensureLinVel()
	spoofedVelocity = Vector3.zero

	local md = hum.MoveDirection
	local spd = carry and CS or NS
	if md.Magnitude > 0 then
		lastMoveDir = md
		setLinVelXZ(md.X * spd, md.Z * spd)
	else
		local anyHeld = false
		for key in pairs(MOVE_KEYS) do
			if UIS:IsKeyDown(key) then
				anyHeld = true
				break
			end
		end
		if anyHeld and lastMoveDir.Magnitude > 0 then
			setLinVelXZ(lastMoveDir.X * spd, lastMoveDir.Z * spd)
		else
			clearLinVel()
		end
	end
end

local function startLoops()
	if renderConn then renderConn:Disconnect() end
	if heartConn then heartConn:Disconnect() end
	renderConn = RunService.RenderStepped:Connect(function()
		pcall(tickEngine)
	end)
	heartConn = RunService.Heartbeat:Connect(function()
		if Active then
			spoofedVelocity = Vector3.zero
		end
	end)
	if charConn then charConn:Disconnect() end
	charConn = LP.CharacterAdded:Connect(function(char)
		task.wait(0.4)
		if Active then
			pcall(setupLinearVelocity, char)
		end
	end)
	pcall(function()
		LP:GetAttributeChangedSignal("Stealing"):Connect(function()
			pcall(tickEngine)
		end)
	end)
end

Env.ARXAntiDropSet = setMaster
Env.ARXAntiDropGet = function() return Master end
Env.ARXAntiDropIsActive = function() return Active end
Env.ARXAntiDropCleanup = function()
	Master = false
	Active = false
	Env.SabcomIsTeleporting = false
	clearLinVel()
	destroyLinVel()
	if renderConn then renderConn:Disconnect() renderConn = nil end
	if heartConn then heartConn:Disconnect() heartConn = nil end
	if charConn then charConn:Disconnect() charConn = nil end
end

startLoops()
if Master then
	ensureMtHook()
end
print("[ARX] Anti Drop (LinearVelocity + zero spoof) ready")
]====]))()

-- Anti Drop mini button
task.defer(function()
	local ok, err = pcall(function()
		local Env = getgenv and getgenv() or _G
		local gui = nil
		pcall(function()
			if type(gethui) == "function" then
				local h = gethui()
				if h then gui = h:FindFirstChild("ARXHubGUI") end
			end
		end)
		if not gui then
			local players = game:GetService("Players")
			local lp = players.LocalPlayer
			if lp then
				local pg = lp:FindFirstChild("PlayerGui") or lp:WaitForChild("PlayerGui", 3)
				if pg then gui = pg:FindFirstChild("ARXHubGUI") end
			end
		end
		if not gui then
			pcall(function()
				gui = game:GetService("CoreGui"):FindFirstChild("ARXHubGUI")
			end)
		end
		if not gui then return end

		local existing = gui:FindFirstChild("AntiDropMini")
		if existing then existing:Destroy() end

		local btn = Instance.new("TextButton")
		btn.Name = "AntiDropMini"
		btn.Size = UDim2.fromOffset(130, 28)
		btn.Position = UDim2.new(0, 12, 1, -40)
		btn.BackgroundColor3 = Color3.fromRGB(185, 50, 55)
		btn.Text = "ANTI DROP OFF"
		btn.TextColor3 = Color3.new(1, 1, 1)
		btn.TextSize = 11
		btn.Font = Enum.Font.GothamBold
		btn.AutoButtonColor = false
		btn.Parent = gui
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

		local function paint(master, active)
			if not btn or not btn.Parent then return end
			if not master then
				btn.Text = "ANTI DROP OFF"
				btn.BackgroundColor3 = Color3.fromRGB(185, 50, 55)
			elseif active then
				btn.Text = "ANTI DROP ACTIVE"
				btn.BackgroundColor3 = Color3.fromRGB(40, 180, 95)
			else
				btn.Text = "ANTI DROP READY"
				btn.BackgroundColor3 = Color3.fromRGB(200, 150, 40)
			end
		end

		local masterOn = Env.ARXAntiDropDesired == true
		local activeOn = type(Env.ARXAntiDropIsActive) == "function" and Env.ARXAntiDropIsActive() == true
		paint(masterOn, activeOn)

		Env.ARXAntiDropStateChanged = function(master, active)
			paint(master == true, active == true)
		end

		btn.MouseButton1Click:Connect(function()
			local currentlyOn = type(Env.ARXAntiDropGet) == "function" and Env.ARXAntiDropGet() == true
			local newOn = not currentlyOn
			if type(Env.ARXAntiDropSet) == "function" then
				Env.ARXAntiDropSet(newOn)
			end
			local isActive = type(Env.ARXAntiDropIsActive) == "function" and Env.ARXAntiDropIsActive() == true
			paint(newOn, isActive)
		end)
	end)
	if not ok then
		warn("[ARX] Anti Drop UI wire failed:", err)
	end
end)

print("[ARX] GUI ready - click SHAWN button to open hub")
print("[ARX + Gamma Merged] All features loaded!")


-- ============================================================
-- BASE TIMER + IN-BASE PLAYERS (no Semi TP)
-- ============================================================
;(loadstring([====[
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer
local Env = getgenv and getgenv() or _G
local Workspace = game:GetService("Workspace")

local parentGui = LP:FindFirstChildOfClass("PlayerGui")
pcall(function()
	if gethui then parentGui = gethui() end
end)
if not parentGui then parentGui = LP:WaitForChild("PlayerGui", 5) end

local function findMyBase()
	local plots = Workspace:FindFirstChild("Plots")
	if not plots then return nil end
	-- Preferred: PlotSign / YourBase (exact SAB)
	for _, plot in ipairs(plots:GetChildren()) do
		local sign = plot:FindFirstChild("PlotSign")
		local yb = sign and sign:FindFirstChild("YourBase")
		if yb and (yb:IsA("BillboardGui") or yb:IsA("GuiObject")) then
			local on = true
			pcall(function() on = yb.Enabled ~= false end)
			if on then return plot end
		end
	end
	-- Fallback: owner name on sign text
	for _, plot in ipairs(plots:GetChildren()) do
		local sign = plot:FindFirstChild("PlotSign")
		if sign then
			for _, d in ipairs(sign:GetDescendants()) do
				if d:IsA("TextLabel") or d:IsA("TextButton") then
					local tx = tostring(d.Text or "")
					if tx ~= "" and (string.find(tx, LP.Name, 1, true) or string.find(tx, LP.DisplayName, 1, true)) then
						return plot
					end
				end
			end
		end
	end
	return nil
end

local function readPlotRemainingTime(plot)
	if not plot then return nil, nil end
	-- Exact same source as Base Timer ESP
	for _, object in ipairs(plot:GetDescendants()) do
		if object.Name == "RemainingTime" and (object:IsA("TextLabel") or object:IsA("TextBox")) then
			local text = (object.ContentText ~= "" and object.ContentText)
				or (object.Text ~= "" and object.Text)
				or nil
			if text and text ~= "" then
				local mm, ss = tostring(text):match("(%d+):(%d+)")
				local sec = nil
				if mm and ss then sec = tonumber(mm) * 60 + tonumber(ss) end
				return tostring(text), sec
			end
		end
	end
	local attr = plot:GetAttribute("LockTime") or plot:GetAttribute("Timer") or plot:GetAttribute("BaseTimer")
	if attr ~= nil then
		local sec = tonumber(attr)
		if sec then
			return string.format("%d:%02d", math.floor(sec / 60), sec % 60), sec
		end
	end
	return nil, nil
end

-- Base timer HUD (top center)
do
	local oldT = parentGui and parentGui:FindFirstChild("ARXBaseTimer")
	if oldT then oldT:Destroy() end
	local TGui = Instance.new("ScreenGui")
	TGui.Name = "ARXBaseTimer"
	TGui.ResetOnSpawn = false
	TGui.IgnoreGuiInset = true
	TGui.DisplayOrder = 60
	TGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	TGui.Parent = parentGui
	local frame = Instance.new("Frame")
	frame.Name = "BaseTimerFrame"
	frame.Size = UDim2.fromOffset(160, 34)
	frame.Position = UDim2.new(0.5, -80, 0, 8)
	frame.BackgroundColor3 = Color3.fromRGB(16, 12, 22)
	frame.BorderSizePixel = 0
	frame.Parent = TGui
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)
	local stroke = Instance.new("UIStroke", frame)
	stroke.Color = Color3.fromRGB(0, 200, 255)
	stroke.Thickness = 1.3
	local lbl = Instance.new("TextLabel")
	lbl.Name = "TimerText"
	lbl.Size = UDim2.new(1, -10, 1, 0)
	lbl.Position = UDim2.fromOffset(5, 0)
	lbl.BackgroundTransparency = 1
	lbl.Font = Enum.Font.GothamBold
	lbl.TextSize = 13
	lbl.TextColor3 = Color3.fromRGB(240, 230, 255)
	lbl.Text = "ARX · BASE ---"
	lbl.Parent = frame

	task.spawn(function()
		while TGui.Parent do
			pcall(function()
				TGui.Enabled = true
				frame.Visible = true
			end)
			local text, sec = readPlotRemainingTime(findMyBase())
			if text then
				lbl.Text = "BASE · " .. text
				if sec and sec <= 15 then
					lbl.TextColor3 = Color3.fromRGB(255, 120, 120)
					stroke.Color = Color3.fromRGB(255, 90, 110)
				elseif sec and sec <= 60 then
					lbl.TextColor3 = Color3.fromRGB(255, 210, 120)
					stroke.Color = Color3.fromRGB(255, 160, 80)
				else
					lbl.TextColor3 = Color3.fromRGB(240, 230, 255)
					stroke.Color = Color3.fromRGB(0, 200, 255)
				end
			else
				lbl.Text = "BASE · OPEN"
				lbl.TextColor3 = Color3.fromRGB(120, 220, 150)
				stroke.Color = Color3.fromRGB(80, 200, 120)
			end
			task.wait(0.25)
		end
	end)

	-- Keep visible after respawn / instant reset
	LP.CharacterAdded:Connect(function()
		task.defer(function()
			pcall(function()
				TGui.Enabled = true
				frame.Visible = true
			end)
		end)
	end)
end

-- In-base players (floating cards)
do
	local oldIB = parentGui and parentGui:FindFirstChild("ARXInBaseAlert")
	if oldIB then oldIB:Destroy() end
	local ibGui = Instance.new("ScreenGui")
	ibGui.Name = "ARXInBaseAlert"
	ibGui.ResetOnSpawn = false
	ibGui.IgnoreGuiInset = true
	ibGui.DisplayOrder = 80
	ibGui.Parent = parentGui

	local list = Instance.new("Frame")
	list.Size = UDim2.fromOffset(210, 0)
	list.AutomaticSize = Enum.AutomaticSize.Y
	list.Position = UDim2.new(0.5, -105, 1, -160)
	list.BackgroundTransparency = 1
	list.Parent = ibGui
	local layout = Instance.new("UIListLayout", list)
	layout.Padding = UDim.new(0, 6)
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

	local cards = {}
	local function makeCard(player)
		local row = Instance.new("Frame")
		row.Size = UDim2.fromOffset(200, 42)
		row.BackgroundColor3 = Color3.fromRGB(18, 16, 28)
		row.BackgroundTransparency = 0.08
		row.BorderSizePixel = 0
		row.Parent = list
		Instance.new("UICorner", row).CornerRadius = UDim.new(0, 10)
		local st = Instance.new("UIStroke", row)
		st.Color = Color3.fromRGB(255, 190, 0)
		st.Thickness = 1.2
		local img = Instance.new("ImageLabel")
		img.Size = UDim2.fromOffset(30, 30)
		img.Position = UDim2.fromOffset(8, 6)
		img.BackgroundColor3 = Color3.fromRGB(40, 35, 55)
		img.BorderSizePixel = 0
		img.Parent = row
		Instance.new("UICorner", img).CornerRadius = UDim.new(1, 0)
		pcall(function()
			img.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
		end)
		local dn = Instance.new("TextLabel")
		dn.Size = UDim2.new(1, -48, 0, 18)
		dn.Position = UDim2.fromOffset(44, 4)
		dn.BackgroundTransparency = 1
		dn.Font = Enum.Font.GothamBold
		dn.TextSize = 13
		dn.TextColor3 = Color3.fromRGB(255, 230, 235)
		dn.TextXAlignment = Enum.TextXAlignment.Left
		dn.Text = player.DisplayName
		dn.TextTruncate = Enum.TextTruncate.AtEnd
		dn.Parent = row
		local un = Instance.new("TextLabel")
		un.Size = UDim2.new(1, -48, 0, 14)
		un.Position = UDim2.fromOffset(44, 22)
		un.BackgroundTransparency = 1
		un.Font = Enum.Font.Gotham
		un.TextSize = 11
		un.TextColor3 = Color3.fromRGB(170, 160, 180)
		un.TextXAlignment = Enum.TextXAlignment.Left
		un.Text = "@" .. player.Name
		un.TextTruncate = Enum.TextTruncate.AtEnd
		un.Parent = row
		return row
	end

	local function playerInMyBase(player)
		if player == LP then return false end
		local plot = findMyBase()
		if not plot then return false end
		local char = player.Character
		local hrp = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
		if not hrp then return false end
		local ok, cf, size = pcall(function() return plot:GetBoundingBox() end)
		if ok and cf and size then
			local rel = cf:PointToObjectSpace(hrp.Position)
			local half = size * 0.5
			return math.abs(rel.X) <= half.X + 4 and math.abs(rel.Y) <= half.Y + 20 and math.abs(rel.Z) <= half.Z + 4
		end
		return false
	end

	task.spawn(function()
		while ibGui.Parent do
			local seen = {}
			for _, plr in ipairs(Players:GetPlayers()) do
				if playerInMyBase(plr) then
					seen[plr.UserId] = true
					if not cards[plr.UserId] then
						cards[plr.UserId] = makeCard(plr)
					end
				end
			end
			for uid, card in pairs(cards) do
				if not seen[uid] then
					if card and card.Parent then card:Destroy() end
					cards[uid] = nil
				end
			end
			task.wait(0.35)
		end
	end)
end

print("[ARX] Base Timer + In-Base alerts ready")
]====]))()

-- ============================================================
-- SEMI TP LARP MODULE (ARX Hub entegrasyonu)
-- ============================================================
;(loadstring([=====[
local CURRENT_SLOT = 1
local MAX_SLOTS = 18
local TELEPORT_AT = 0.98

local COMMON1 = Vector3.new(-352.76, -7.18, 114.06)
local COMMON2 = Vector3.new(-352.59, -7.12, 13.95)

local BASES = {
    b1 = { refVec = Vector3.new(-337, -5, 100) },
    b2 = { refVec = Vector3.new(-335, -5, 20) },
}

local SLOTS = {
    [1]={left={PATH={{pos=COMMON1,START_MOVE_AT=0},{pos=COMMON2,START_MOVE_AT=0},{pos=Vector3.new(-336.71,-5.37,20.00),START_MOVE_AT=0},{pos=Vector3.new(-348.43,-7.27,35.76),START_MOVE_AT=0}},GRAB_POS=Vector3.new(-331.62,-4.76,24.35)},right={PATH={{pos=Vector3.new(-352.76,-7.18,7.06),START_MOVE_AT=0},{pos=Vector3.new(-353.03,-7.18,113.20),START_MOVE_AT=0},{pos=Vector3.new(-334.61,-5.37,102.26),START_MOVE_AT=0},{pos=Vector3.new(-349.83,-7.27,83.00),START_MOVE_AT=0}},GRAB_POS=Vector3.new(-331.19,-4.87,95.89)}},
    [2]={left={PATH={{pos=COMMON1,START_MOVE_AT=0},{pos=COMMON2,START_MOVE_AT=0},{pos=Vector3.new(-327.74,-5.26,23.78),START_MOVE_AT=0},{pos=Vector3.new(-344.99,-7.16,26.28),START_MOVE_AT=0}},GRAB_POS=Vector3.new(-323.81,-4.76,24.58)},right={PATH={{pos=Vector3.new(-352.76,-7.18,7.06),START_MOVE_AT=0},{pos=Vector3.new(-353.03,-7.18,113.20),START_MOVE_AT=0},{pos=Vector3.new(-327.32,-5.37,95.53),START_MOVE_AT=0},{pos=Vector3.new(-347.00,-7.27,96.85),START_MOVE_AT=0}},GRAB_POS=Vector3.new(-323.62,-4.87,94.83)}},
    [3]={left={PATH={{pos=COMMON1,START_MOVE_AT=-0.2},{pos=COMMON2,START_MOVE_AT=0},{pos=Vector3.new(-320.21,-5.26,25.92),START_MOVE_AT=0},{pos=Vector3.new(-344.24,-7.16,25.56),START_MOVE_AT=0}},GRAB_POS=Vector3.new(-316.46,-4.76,24.50)},right={PATH={{pos=Vector3.new(-352.76,-7.18,7.06),START_MOVE_AT=-0.3},{pos=Vector3.new(-353.03,-7.18,113.20),START_MOVE_AT=0},{pos=Vector3.new(-319.46,-5.37,95.90),START_MOVE_AT=0},{pos=Vector3.new(-344.07,-7.27,96.09),START_MOVE_AT=0}},GRAB_POS=Vector3.new(-316.14,-4.87,95.43)}},
    [4]={left={PATH={{pos=COMMON1,START_MOVE_AT=-0.3},{pos=COMMON2,START_MOVE_AT=0},{pos=Vector3.new(-314.33,-5.01,25.02),START_MOVE_AT=0},{pos=Vector3.new(-330.23,-4.76,24.76),START_MOVE_AT=0}},GRAB_POS=Vector3.new(-308.51,-4.76,25.15)},right={PATH={{pos=Vector3.new(-352.76,-7.18,7.06),START_MOVE_AT=-0.4},{pos=Vector3.new(-353.03,-7.18,113.20),START_MOVE_AT=0},{pos=Vector3.new(-312.19,-5.37,95.87),START_MOVE_AT=0},{pos=Vector3.new(-331.44,-4.87,95.84),START_MOVE_AT=0}},GRAB_POS=Vector3.new(-308.57,-4.87,95.52)}},
    [5]={left={PATH={{pos=COMMON1,START_MOVE_AT=-0.5},{pos=COMMON2,START_MOVE_AT=0},{pos=Vector3.new(-306.47,-5.01,24.41),START_MOVE_AT=0},{pos=Vector3.new(-321.33,-5.01,24.49),START_MOVE_AT=0}},GRAB_POS=Vector3.new(-301.35,-4.76,25.16)},right={PATH={{pos=Vector3.new(-352.76,-7.18,7.06),START_MOVE_AT=-0.5},{pos=Vector3.new(-353.03,-7.18,113.20),START_MOVE_AT=0},{pos=Vector3.new(-304.77,-5.37,95.34),START_MOVE_AT=0},{pos=Vector3.new(-321.80,-5.12,95.54),START_MOVE_AT=0}},GRAB_POS=Vector3.new(-301.11,-4.87,95.61)}},
    [6]={left={PATH={{pos=COMMON1,START_MOVE_AT=-0.2},{pos=COMMON2,START_MOVE_AT=0},{pos=Vector3.new(-335.76,-5.26,-9.52),START_MOVE_AT=0},{pos=Vector3.new(-345.10,-6.86,-0.77),START_MOVE_AT=0}},GRAB_POS=Vector3.new(-331.58,-4.76,-11.37)},right={PATH={{pos=Vector3.new(-352.76,-7.18,7.06),START_MOVE_AT=-0.2},{pos=Vector3.new(-353.03,-7.18,113.20),START_MOVE_AT=0},{pos=Vector3.new(-301.45,-5.12,126.61),START_MOVE_AT=0},{pos=Vector3.new(-311.91,-5.37,116.65),START_MOVE_AT=0}},GRAB_POS=Vector3.new(-301.05,-4.87,131.80)}},
    [7]={left={PATH={{pos=COMMON1,START_MOVE_AT=-0.3},{pos=COMMON2,START_MOVE_AT=0},{pos=Vector3.new(-326.93,-5.26,-7.11),START_MOVE_AT=0},{pos=Vector3.new(-330.14,-5.26,3.02),START_MOVE_AT=0}},GRAB_POS=Vector3.new(-324.12,-4.76,-10.94)},right={PATH={{pos=Vector3.new(-352.76,-7.18,7.06),START_MOVE_AT=-0.4},{pos=Vector3.new(-353.03,-7.18,113.20),START_MOVE_AT=0},{pos=Vector3.new(-310.69,-5.12,126.77),START_MOVE_AT=0},{pos=Vector3.new(-318.30,-5.37,117.26),START_MOVE_AT=0}},GRAB_POS=Vector3.new(-308.95,-4.87,132.27)}},
    [8]={left={PATH={{pos=COMMON1,START_MOVE_AT=-0.4},{pos=COMMON2,START_MOVE_AT=0},{pos=Vector3.new(-316.66,-5.06,-5.03),START_MOVE_AT=0},{pos=Vector3.new(-323.05,-5.26,4.12),START_MOVE_AT=0}},GRAB_POS=Vector3.new(-316.07,-4.76,-11.31)},right={PATH={{pos=Vector3.new(-352.76,-7.18,7.06),START_MOVE_AT=-0.4},{pos=Vector3.new(-353.03,-7.18,113.20),START_MOVE_AT=0},{pos=Vector3.new(-318.12,-5.12,125.58),START_MOVE_AT=0},{pos=Vector3.new(-325.05,-5.37,117.70),START_MOVE_AT=0}},GRAB_POS=Vector3.new(-316.43,-4.87,131.69)}},
    [9]={left={PATH={{pos=COMMON1,START_MOVE_AT=-0.4},{pos=COMMON2,START_MOVE_AT=0},{pos=Vector3.new(-310.28,-5.01,-5.47),START_MOVE_AT=0},{pos=Vector3.new(-316.93,-5.26,1.19),START_MOVE_AT=0}},GRAB_POS=Vector3.new(-308.89,-4.76,-11.27)},right={PATH={{pos=Vector3.new(-352.76,-7.18,7.06),START_MOVE_AT=-0.4},{pos=Vector3.new(-353.03,-7.18,113.20),START_MOVE_AT=0},{pos=Vector3.new(-325.46,-5.12,125.92),START_MOVE_AT=0},{pos=Vector3.new(-335.57,-5.37,116.43),START_MOVE_AT=0}},GRAB_POS=Vector3.new(-323.99,-4.87,131.62)}},
    [10]={left={PATH={{pos=COMMON1,START_MOVE_AT=-0.5},{pos=COMMON2,START_MOVE_AT=0},{pos=Vector3.new(-303.55,-5.11,-5.47),START_MOVE_AT=0},{pos=Vector3.new(-310.47,-5.26,0.60),START_MOVE_AT=0}},GRAB_POS=Vector3.new(-301.45,-4.76,-11.07)},right={PATH={{pos=Vector3.new(-352.76,-7.18,7.06),START_MOVE_AT=-0.5},{pos=Vector3.new(-353.03,-7.18,113.20),START_MOVE_AT=0},{pos=Vector3.new(-333.38,-5.12,126.12),START_MOVE_AT=0},{pos=Vector3.new(-345.51,-6.87,118.15),START_MOVE_AT=0}},GRAB_POS=Vector3.new(-331.34,-4.87,131.85)}},
    [11]={left={PATH={{pos=COMMON1,START_MOVE_AT=-0.2},{pos=COMMON2,START_MOVE_AT=0},{pos=Vector3.new(-331.92,5.24,-15.30),START_MOVE_AT=0},{pos=Vector3.new(-344.39,-7.16,-15.11),START_MOVE_AT=0}},GRAB_POS=Vector3.new(-331.29,13.24,-10.88)},right={PATH={{pos=Vector3.new(-352.76,-7.18,7.06),START_MOVE_AT=-0.2},{pos=Vector3.new(-353.03,-7.18,113.20),START_MOVE_AT=0},{pos=Vector3.new(-330.78,6,94.89),START_MOVE_AT=0},{pos=Vector3.new(-343.47,-7.27,97.07),START_MOVE_AT=0}},GRAB_POS=Vector3.new(-331.20,13.13,95.86)}},
    [12]={left={PATH={{pos=COMMON1,START_MOVE_AT=-0.3},{pos=COMMON2,START_MOVE_AT=0},{pos=Vector3.new(-324.16,5.24,-15.10),START_MOVE_AT=0},{pos=Vector3.new(-345.10,-7.16,-10.35),START_MOVE_AT=0}},GRAB_POS=Vector3.new(-323.97,13.24,-10.87)},right={PATH={{pos=Vector3.new(-352.76,-7.18,7.06),START_MOVE_AT=-0.3},{pos=Vector3.new(-353.03,-7.18,113.20),START_MOVE_AT=0},{pos=Vector3.new(-323.71,6,94.51),START_MOVE_AT=0},{pos=Vector3.new(-344.05,-7.27,98.61),START_MOVE_AT=0}},GRAB_POS=Vector3.new(-331.20,13.13,95.86)}},
    [13]={left={PATH={{pos=COMMON1,START_MOVE_AT=-0.3},{pos=COMMON2,START_MOVE_AT=0},{pos=Vector3.new(-317.35,5.24,-14.98),START_MOVE_AT=0},{pos=Vector3.new(-328.77,-5.01,-12.06),START_MOVE_AT=0}},GRAB_POS=Vector3.new(-316.60,13.24,-10.95)},right={PATH={{pos=Vector3.new(-352.76,-7.18,7.06),START_MOVE_AT=-0.3},{pos=Vector3.new(-353.03,-7.18,113.20),START_MOVE_AT=0},{pos=Vector3.new(-316.75,6,96.26),START_MOVE_AT=0},{pos=Vector3.new(-325.61,-4.87,96.06),START_MOVE_AT=0}},GRAB_POS=Vector3.new(-316.21,13.13,96.09)}},
    [14]={left={PATH={{pos=COMMON1,START_MOVE_AT=-0.4},{pos=COMMON2,START_MOVE_AT=0},{pos=Vector3.new(-309.42,5.24,-15.15),START_MOVE_AT=0},{pos=Vector3.new(-319.79,-5.26,-11.06),START_MOVE_AT=0}},GRAB_POS=Vector3.new(-308.94,13.24,-11.24)},right={PATH={{pos=Vector3.new(-352.76,-7.18,7.06),START_MOVE_AT=-0.4},{pos=Vector3.new(-353.03,-7.18,113.20),START_MOVE_AT=0},{pos=Vector3.new(-312.86,5.24,97.53),START_MOVE_AT=0},{pos=Vector3.new(-328.82,-5.12,96.22),START_MOVE_AT=0}},GRAB_POS=Vector3.new(-309.03,13.13,95.84)}},
    [15]={left={PATH={{pos=COMMON1,START_MOVE_AT=-0.5},{pos=COMMON2,START_MOVE_AT=0},{pos=Vector3.new(-302.82,5.24,-14.83),START_MOVE_AT=0},{pos=Vector3.new(-314.20,-5.01,-11.40),START_MOVE_AT=0}},GRAB_POS=Vector3.new(-301.38,13.24,-11.37)},right={PATH={{pos=Vector3.new(-352.76,-7.18,7.06),START_MOVE_AT=-0.5},{pos=Vector3.new(-353.03,-7.18,113.20),START_MOVE_AT=0},{pos=Vector3.new(-301.73,6,99.70),START_MOVE_AT=0},{pos=Vector3.new(-314.93,-4.87,96.29),START_MOVE_AT=0}},GRAB_POS=Vector3.new(-301.03,13.13,95.45)}},
    [16]={left={PATH={{pos=COMMON1,START_MOVE_AT=0},{pos=COMMON2,START_MOVE_AT=0},{pos=Vector3.new(-331.34,5.24,28.39),START_MOVE_AT=0},{pos=Vector3.new(-345.52,-7.16,24.30),START_MOVE_AT=0}},GRAB_POS=Vector3.new(-331.39,13.19,23.74)},right={PATH={{pos=Vector3.new(-352.76,-7.18,7.06),START_MOVE_AT=0},{pos=Vector3.new(-353.03,-7.18,113.20),START_MOVE_AT=0},{pos=Vector3.new(-331.48,6,129.46),START_MOVE_AT=0},{pos=Vector3.new(-344.41,-7.27,131.44),START_MOVE_AT=0}},GRAB_POS=Vector3.new(-331.54,13.08,130.61)}},
    [17]={left={PATH={{pos=COMMON1,START_MOVE_AT=0},{pos=COMMON2,START_MOVE_AT=0},{pos=Vector3.new(-323.28,5.24,28.10),START_MOVE_AT=0},{pos=Vector3.new(-337.32,-5.26,24.37),START_MOVE_AT=0}},GRAB_POS=Vector3.new(-323.67,13.24,24.91)},right={PATH={{pos=Vector3.new(-352.76,-7.18,7.06),START_MOVE_AT=0},{pos=Vector3.new(-353.03,-7.18,113.20),START_MOVE_AT=0},{pos=Vector3.new(-323.83,6,129.60),START_MOVE_AT=0},{pos=Vector3.new(-343.86,-7.27,132.08),START_MOVE_AT=0}},GRAB_POS=Vector3.new(-324.14,13.13,130.98)}},
    [18]={left={PATH={{pos=COMMON1,START_MOVE_AT=0},{pos=COMMON2,START_MOVE_AT=0},{pos=Vector3.new(-316.85,5.24,27.92),START_MOVE_AT=0},{pos=Vector3.new(-328.71,-5.01,24.78),START_MOVE_AT=0}},GRAB_POS=Vector3.new(-316.54,13.24,24.40)},right={PATH={{pos=Vector3.new(-352.76,-7.18,7.06),START_MOVE_AT=0},{pos=Vector3.new(-353.03,-7.18,113.20),START_MOVE_AT=0},{pos=Vector3.new(-315.83,6,132.49),START_MOVE_AT=0},{pos=Vector3.new(-331.34,-4.87,132.05),START_MOVE_AT=0}},GRAB_POS=Vector3.new(-316.62,13.13,131.50)}},
}

-- ---- Services ----
local Players        = game:GetService("Players")
local RunService     = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService   = game:GetService("TweenService")
local Workspace      = game:GetService("Workspace")
local LocalPlayer    = Players.LocalPlayer
local PlayerGui      = LocalPlayer:WaitForChild("PlayerGui")
local SharedEnv      = getgenv and getgenv() or _G

local Character  = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid   = Character:WaitForChild("Humanoid")
local Root       = Character:WaitForChild("HumanoidRootPart")

-- ---- State ----
local autoGrabEnabled    = false
local autoGrabStealing   = false
local isMoving           = false
local currentMovement    = nil
local currentProgress    = 0
local waitingOnSecondLast = false
local hasStartedMoving   = false
local currentPathIndex   = 1
local activeStartMoveAt  = 0
local activateTime       = 0
local grabDelayUntil     = 0
local currentTargetPos   = nil
local currentSkipTeleport = false
local useGiantPotion     = false
local currentSide        = "left"
local currentGrabPos     = nil
local autoTPOnUnlock     = false
local autoTPOnAllowed    = false
local autoTPCooldownUntil = 0

local updateHotbarProgress

-- ---- Config persist ----
local CONFIG_FILE = "arx_semitp_config.json"
local function loadConfig()
    pcall(function()
        if readfile then
            local data = game:GetService("HttpService"):JSONDecode(readfile(CONFIG_FILE))
            if data then
                CURRENT_SLOT     = data.currentSlot or 1
                useGiantPotion   = data.useGiantPotion or false
                autoTPOnUnlock   = data.autoTPOnUnlock or false
                autoTPOnAllowed  = data.autoTPOnAllowed or false
            end
        end
    end)
end
local function saveConfig()
    pcall(function()
        if writefile then
            writefile(CONFIG_FILE, game:GetService("HttpService"):JSONEncode({
                currentSlot=CURRENT_SLOT,useGiantPotion=useGiantPotion,
                autoTPOnUnlock=autoTPOnUnlock,autoTPOnAllowed=autoTPOnAllowed
            }))
        end
    end)
end
loadConfig()

-- ---- Marker (target dot) ----
local markerPart = Instance.new("Part")
markerPart.Name="ARXSemiTPMarker" markerPart.Anchored=true markerPart.CanCollide=false
markerPart.CanQuery=false markerPart.CanTouch=false markerPart.Transparency=1
markerPart.Size=Vector3.new(0.2,0.2,0.2) markerPart.Parent=Workspace
local bb=Instance.new("BillboardGui") bb.Name="Dot" bb.AlwaysOnTop=true
bb.Size=UDim2.new(0,22,0,22) bb.MaxDistance=10000 bb.Parent=markerPart
local dotF=Instance.new("Frame") dotF.Size=UDim2.new(1,0,1,0)
dotF.BackgroundColor3=Color3.fromRGB(0,180,255) dotF.BorderSizePixel=0 dotF.Parent=bb
Instance.new("UICorner",dotF).CornerRadius=UDim.new(1,0)
local dotStroke=Instance.new("UIStroke") dotStroke.Color=Color3.new(1,1,1)
dotStroke.Thickness=1.5 dotStroke.Parent=dotF
local function setMarker(pos)
    if pos then markerPart.Position=pos markerPart.Parent=Workspace bb.Enabled=true
    else bb.Enabled=false end
end
setMarker(nil)

-- ---- Character reset ----
LocalPlayer.CharacterAdded:Connect(function(newChar)
    if currentMovement then pcall(function() currentMovement:Disconnect() end) currentMovement=nil end
    Character=newChar Humanoid=newChar:WaitForChild("Humanoid") Root=newChar:WaitForChild("HumanoidRootPart")
    isMoving=false autoGrabStealing=false currentProgress=0 waitingOnSecondLast=false
    hasStartedMoving=false currentPathIndex=1 activeStartMoveAt=0 activateTime=0
    grabDelayUntil=0 currentTargetPos=nil currentSkipTeleport=false currentGrabPos=nil
    setMarker(nil)
    task.wait()
    if Root then
        local oldV=Root:FindFirstChild("LinearVelocity") if oldV then oldV:Destroy() end
        local oldA=Root:FindFirstChild("Attachment") if oldA then oldA:Destroy() end
    end
end)

-- ---- Helpers ----
local function findTool(name)
    if not Character then return nil end
    for _,tool in ipairs(Character:GetChildren()) do
        if tool:IsA("Tool") and tool.Name:lower():find(name:lower()) then return tool end
    end
    for _,tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") and tool.Name:lower():find(name:lower()) then return tool end
    end
    return nil
end
local function isMyPlot(plot)
    if not plot then return false end
    local sign=plot:FindFirstChild("PlotSign")
    if sign then local yb=sign:FindFirstChild("YourBase") if yb and yb:IsA("BillboardGui") and yb.Enabled then return true end end
    return false
end
local function isValidStealPrompt(prompt)
    if not prompt or not prompt.Parent or not prompt.Enabled then return false end
    local state=prompt:GetAttribute("State") local at=prompt.ActionText
    return state=="Steal" or state=="Grab" or at=="Steal" or at=="Grab"
end
local function isEnemyPlot(plot)
    if not plot or not plot:IsA("Model") then return false end
    local sign=plot:FindFirstChild("PlotSign")
    local sg=sign and sign:FindFirstChild("SurfaceGui")
    local frame=sg and sg:FindFirstChild("Frame")
    local label=frame and frame:FindFirstChild("TextLabel")
    if not label then return false end
    if label.Text=="Empty Base" then return false end
    local owner=label.Text:gsub("'s [Bb]ase$",""):gsub("%s+$","")
    return owner~=LocalPlayer.Name and owner~=LocalPlayer.DisplayName
end
local function getClosestEnemyPlot()
    local plots=Workspace:FindFirstChild("Plots") if not plots then return nil end
    local myPos=Root and Root.Position or Vector3.zero
    local best,bestDist=nil,math.huge
    for _,plot in ipairs(plots:GetChildren()) do
        if isEnemyPlot(plot) then
            local pos=plot:GetPivot().Position
            local d=(pos-myPos).Magnitude
            if d<bestDist then bestDist=d best=plot end
        end
    end
    return best
end
local function getBaseSide(plot)
    if not plot then return "left" end
    local plotPos=plot:GetPivot().Position
    local dL=(plotPos-BASES.b2.refVec).Magnitude
    local dR=(plotPos-BASES.b1.refVec).Magnitude
    return (dL<dR) and "left" or "right"
end

-- ---- Auto Grab ----
local STEAL_DURATION=1.4
local AutoGrabData={}
local function findNearestAutoGrabPrompt()
    local slot=SLOTS[CURRENT_SLOT] if not slot then return nil end
    local config=slot[currentSide] if not config or not config.GRAB_POS then return nil end
    local targetPos=config.GRAB_POS currentGrabPos=targetPos
    local plots=Workspace:FindFirstChild("Plots") if not plots then return nil end
    local nearest,dist=nil,math.huge
    for _,plot in ipairs(plots:GetChildren()) do
        if not isMyPlot(plot) then
            local pods=plot:FindFirstChild("AnimalPodiums")
            if pods then
                for _,pod in ipairs(pods:GetChildren()) do
                    local base=pod:FindFirstChild("Base")
                    if base then
                        local sp=base:FindFirstChild("Spawn")
                        if sp then
                            local d=(sp.Position-targetPos).Magnitude
                            if d<=15 and d<dist then
                                local att=sp:FindFirstChild("PromptAttachment")
                                if att then
                                    for _,p in ipairs(att:GetChildren()) do
                                        if p:IsA("ProximityPrompt") and isValidStealPrompt(p) then
                                            nearest,dist=p,d
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return nearest
end
local function executeAutoGrab(prompt)
    if autoGrabStealing then return end
    if not AutoGrabData[prompt] then
        AutoGrabData[prompt]={hold={},trigger={},ready=true}
        if getconnections then
            for _,c in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do
                if c.Function then table.insert(AutoGrabData[prompt].hold,c.Function) end
            end
            for _,c in ipairs(getconnections(prompt.Triggered)) do
                if c.Function then table.insert(AutoGrabData[prompt].trigger,c.Function) end
            end
        end
    end
    local data=AutoGrabData[prompt]
    if not data.ready then return end
    data.ready=false autoGrabStealing=true
    local startTime=tick()
    task.spawn(function()
        for _,f in ipairs(data.hold) do pcall(f) end
        while tick()-startTime<STEAL_DURATION do
            local progress=math.clamp((tick()-startTime)/STEAL_DURATION,0,1)
            currentProgress=progress
            if updateHotbarProgress then updateHotbarProgress(progress) end
            task.wait()
        end
        for _,f in ipairs(data.trigger) do pcall(f) end
        task.wait(0.05)
        currentProgress=0
        if updateHotbarProgress then updateHotbarProgress(0) end
        data.ready=true autoGrabStealing=false
    end)
end
RunService.Heartbeat:Connect(function()
    if not autoGrabEnabled or autoGrabStealing then return end
    if tick()<grabDelayUntil then return end
    local ok,prompt=pcall(findNearestAutoGrabPrompt)
    if ok and prompt then pcall(executeAutoGrab,prompt) end
end)

-- ---- Stop ----
local function stopEverything(onBtnRef)
    isMoving=false autoGrabEnabled=false currentProgress=0
    waitingOnSecondLast=false hasStartedMoving=false currentPathIndex=1
    activeStartMoveAt=0 activateTime=0 grabDelayUntil=0
    currentTargetPos=nil currentSkipTeleport=false currentGrabPos=nil
    setMarker(nil)
    if updateHotbarProgress then updateHotbarProgress(0) end
    autoTPCooldownUntil=tick()+3
    if currentMovement then pcall(function() currentMovement:Disconnect() end) currentMovement=nil end
    if Root then
        local v=Root:FindFirstChild("LinearVelocity") if v then v:Destroy() end
        local a=Root:FindFirstChild("Attachment") if a then a:Destroy() end
        Root.AssemblyLinearVelocity=Vector3.zero
    end
    if Humanoid then Humanoid:UnequipTools() end
    -- notify ARX hub
    if type(SharedEnv.ARXNotify)=="function" then
        SharedEnv.ARXNotify("Semi TP: Stopped",false)
    end
    if onBtnRef then
        onBtnRef.Text="▶ EXECUTE"
        onBtnRef.BackgroundColor3=Color3.fromRGB(35,145,85)
    end
end

-- ---- Start Path ----
local CLOSE_THRESHOLD=10
local function startPath(execBtnRef)
    if isMoving or not Root or not Humanoid then return end
    local slot=SLOTS[CURRENT_SLOT]
    if not slot then return end
    local enemyPlot=getClosestEnemyPlot()
    currentSide=getBaseSide(enemyPlot)
    local config=slot[currentSide]
    if not config or not config.PATH then return end
    isMoving=true autoGrabEnabled=true currentProgress=0
    waitingOnSecondLast=false hasStartedMoving=false
    activateTime=tick() currentSkipTeleport=false
    local SPEED=160
    local PATH=config.PATH
    currentGrabPos=config.GRAB_POS
    setMarker(currentGrabPos)
    if updateHotbarProgress then updateHotbarProgress(0) end
    if type(SharedEnv.ARXNotify)=="function" then
        SharedEnv.ARXNotify("Semi TP Slot "..CURRENT_SLOT.." ("..currentSide..")",true)
    end
    if execBtnRef then
        execBtnRef.Text="■ STOP"
        execBtnRef.BackgroundColor3=Color3.fromRGB(185,50,55)
    end
    -- find closest path index
    local closestIndex=1 local closestDist=math.huge
    for i,point in ipairs(PATH) do
        local d=(point.pos-Root.Position).Magnitude
        if d<closestDist then closestDist=d closestIndex=i end
    end
    local thirdLastIndex=math.max(1,#PATH-2)
    local distToThirdLast=(PATH[thirdLastIndex].pos-Root.Position).Magnitude
    currentPathIndex=closestIndex
    if closestIndex>thirdLastIndex and distToThirdLast>CLOSE_THRESHOLD then
        currentPathIndex=thirdLastIndex
    elseif closestIndex==#PATH then
        currentPathIndex=math.max(1,#PATH-1)
    end
    activeStartMoveAt=PATH[currentPathIndex].START_MOVE_AT or 0
    if activeStartMoveAt<0 then grabDelayUntil=activateTime+math.abs(activeStartMoveAt) else grabDelayUntil=0 end
    local Attachment,Velocity
    local STOP_DIST=3.5 local PRECISE_DIST=1.6
    if currentMovement then pcall(function() currentMovement:Disconnect() end) end
    currentMovement=RunService.Heartbeat:Connect(function()
        if not Root or not Humanoid or Humanoid.Health<=0 then stopEverything(execBtnRef) return end
        if currentGrabPos then setMarker(currentGrabPos) end
        if waitingOnSecondLast and currentProgress>=TELEPORT_AT then
            if not currentSkipTeleport then
                local lastPos=PATH[#PATH].pos
                Root.CFrame=CFrame.new(lastPos)
                Root.AssemblyLinearVelocity=Vector3.zero
                if Velocity then Velocity.VectorVelocity=Vector3.zero end
                if useGiantPotion then
                    task.spawn(function()
                        local potion=findTool("giant potion") or findTool("giant")
                        if potion then
                            Humanoid:UnequipTools() task.wait(0.03)
                            Humanoid:EquipTool(potion) task.wait(0.05)
                            pcall(function() potion:Activate() end)
                        end
                    end)
                end
            end
            stopEverything(execBtnRef) return
        end
        if waitingOnSecondLast then
            if Velocity then Velocity.VectorVelocity=Vector3.zero end
            Root.AssemblyLinearVelocity=Vector3.zero return
        end
        if not hasStartedMoving then
            local elapsed=tick()-activateTime
            local canStart=(activeStartMoveAt<=0) or (elapsed>=activeStartMoveAt)
            if canStart then
                hasStartedMoving=true
                local carpet=findTool("flying carpet") or findTool("carpet")
                if carpet then Humanoid:UnequipTools() task.wait(0.03) Humanoid:EquipTool(carpet) end
                if Root:FindFirstChild("LinearVelocity") then Root.LinearVelocity:Destroy() end
                if Root:FindFirstChild("Attachment") then Root.Attachment:Destroy() end
                Attachment=Instance.new("Attachment") Attachment.Parent=Root
                Velocity=Instance.new("LinearVelocity") Velocity.Attachment0=Attachment
                Velocity.RelativeTo=Enum.ActuatorRelativeTo.World Velocity.MaxForce=50000 Velocity.Parent=Root
            else return end
        end
        if not Velocity or not Velocity.Parent then return end
        local targetEntry=PATH[currentPathIndex]
        if not targetEntry then stopEverything(execBtnRef) return end
        local target=targetEntry.pos
        local dir=target-Root.Position
        local dist=dir.Magnitude
        local stopDist=(currentPathIndex>=#PATH-1) and PRECISE_DIST or STOP_DIST
        if dist<=stopDist then
            Velocity.VectorVelocity=Vector3.zero Root.AssemblyLinearVelocity=Vector3.zero
            Root.CFrame=CFrame.new(target)
            if currentPathIndex>=#PATH-1 then waitingOnSecondLast=true return end
            currentPathIndex=currentPathIndex+1
            if currentPathIndex>#PATH then stopEverything(execBtnRef) return end
            return
        end
        local speedMult=dist<12 and math.max(0.15,dist/12) or 1
        Velocity.VectorVelocity=dir.Unit*SPEED*speedMult
    end)
end

-- ---- FFlags ----
local function applyFFlags()
    task.spawn(function()
        pcall(function()
            setfflag('GameNetPVHeaderRotationalVelocityZeroCutoffExponent','-5000')
            setfflag('LargeReplicatorWrite5','true') setfflag('LargeReplicatorEnabled9','true')
            setfflag('AngularVelociryLimit','360') setfflag('TimestepArbiterVelocityCriteriaThresholdTwoDt','2147483646')
            setfflag('S2PhysicsSenderRate','15000') setfflag('DisableDPIScale','true')
            setfflag('MaxDataPacketPerSend','2147483647') setfflag('ServerMaxBandwith','52')
            setfflag('PhysicsSenderMaxBandwidthBps','20000') setfflag('MaxTimestepMultiplierBuoyancy','2147483647')
            setfflag('SimOwnedNOUCountThresholdMillionth','2147483647') setfflag('MaxMissedWorldStepsRemembered','-2147483648')
            setfflag('CheckPVDifferencesForInterpolationMinVelThresholdStudsPerSecHundredth','1')
            setfflag('StreamJobNOUVolumeLengthCap','2147483647') setfflag('DebugSendDistInSteps','-2147483648')
            setfflag('MaxTimestepMultiplierAcceleration','2147483647') setfflag('LargeReplicatorRead5','true')
            setfflag('SimExplicitlyCappedTimestepMultiplier','2147483646') setfflag('GameNetDontSendRedundantNumTimes','1')
            setfflag('CheckPVLinearVelocityIntegrateVsDeltaPositionThresholdPercent','1')
            setfflag('CheckPVCachedRotVelThresholdPercent','10') setfflag('LargeReplicatorSerializeRead3','true')
            setfflag('ReplicationFocusNouExtentsSizeCutoffForPauseStuds','2147483647')
            setfflag('NextGenReplicatorEnabledWrite4','true')
            setfflag('CheckPVDifferencesForInterpolationMinRotVelThresholdRadsPerSecHundredth','1')
            setfflag('GameNetDontSendRedundantDeltaPositionMillionth','1')
            setfflag('InterpolationFrameVelocityThresholdMillionth','5')
            setfflag('StreamJobNOUVolumeCap','2147483647') setfflag('InterpolationFrameRotVelocityThresholdMillionth','5')
            setfflag('WorldStepMax','30') setfflag('TimestepArbiterHumanoidLinearVelThreshold','1')
            setfflag('InterpolationFramePositionThresholdMillionth','5')
            setfflag('TimestepArbiterHumanoidTurningVelThreshold','1')
            setfflag('MaxTimestepMultiplierContstraint','2147483647')
            setfflag('GameNetPVHeaderLinearVelocityZeroCutoffExponent','-5000')
            setfflag('CheckPVCachedVelThresholdPercent','10') setfflag('TimestepArbiterOmegaThou','1073741823')
            setfflag('MaxAcceptableUpdateDelay','1') setfflag('LargeReplicatorSerializeWrite4','true')
        end)
        local char=LocalPlayer.Character
        if char then
            local hum=char:FindFirstChildWhichIsA("Humanoid")
            if hum then hum:ChangeState(Enum.HumanoidStateType.Dead) end
            char:ClearAllChildren()
            local fake=Instance.new("Model") fake.Parent=workspace
            LocalPlayer.Character=fake
        end
    end)
end

-- ---- Auto TP triggers ----
local function checkTimerForAutoTP()
    if not autoTPOnUnlock or isMoving then return end
    if tick()<autoTPCooldownUntil then return end
    local plots=Workspace:FindFirstChild("Plots") if not plots then return end
    for _,plot in ipairs(plots:GetChildren()) do
        if isEnemyPlot(plot) then
            for _,d in ipairs(plot:GetDescendants()) do
                if d.Name=="RemainingTime" and (d:IsA("TextLabel") or d:IsA("TextBox")) then
                    local txt=(d.ContentText~="" and d.ContentText) or (d.Text~="" and d.Text) or nil
                    if txt then
                        local mins,secs=txt:match("(%d+):(%d+)")
                        local totalSeconds
                        if mins and secs then totalSeconds=tonumber(mins)*60+tonumber(secs) else totalSeconds=tonumber(txt) end
                        if totalSeconds and totalSeconds<=1 then startPath(nil) autoTPCooldownUntil=tick()+3 return end
                    end
                end
            end
        end
    end
end
local function checkAllowedForAutoTP()
    if not autoTPOnAllowed or isMoving then return end
    if tick()<autoTPCooldownUntil then return end
    local plots=Workspace:FindFirstChild("Plots") if not plots then return end
    for _,plot in ipairs(plots:GetChildren()) do
        if isEnemyPlot(plot) then
            for _,obj in ipairs(plot:GetDescendants()) do
                if obj:IsA("ProximityPrompt") then
                    local text=string.lower(obj.ObjectText or "")
                    if string.find(text,"friends") and string.find(text,"disallow") then
                        startPath(nil) autoTPCooldownUntil=tick()+3 return
                    end
                end
            end
        end
    end
end
RunService.Heartbeat:Connect(function()
    if autoTPOnUnlock then checkTimerForAutoTP() end
    if autoTPOnAllowed then checkAllowedForAutoTP() end
end)

-- ================================================================
-- ARX THEMED GUI
-- ================================================================
local old = PlayerGui:FindFirstChild("ARXSemiTPGui")
if old then old:Destroy() end

local SemiGui = Instance.new("ScreenGui")
SemiGui.Name = "ARXSemiTPGui"
SemiGui.ResetOnSpawn = false
SemiGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SemiGui.DisplayOrder = 999998
SemiGui.IgnoreGuiInset = true
pcall(function()
    if gethui then SemiGui.Parent = gethui()
    else SemiGui.Parent = game:GetService("CoreGui") end
end)
if not SemiGui.Parent then SemiGui.Parent = PlayerGui end

-- Progress bar (bottom center, ARX style)
local PBarGui = Instance.new("ScreenGui")
PBarGui.Name = "ARXSemiTPProgress"
PBarGui.ResetOnSpawn = false
PBarGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
PBarGui.DisplayOrder = 999997
PBarGui.IgnoreGuiInset = true
pcall(function()
    if gethui then PBarGui.Parent = gethui()
    else PBarGui.Parent = game:GetService("CoreGui") end
end)
if not PBarGui.Parent then PBarGui.Parent = PlayerGui end

local GrabLabel = Instance.new("TextLabel")
GrabLabel.Name = "GrabLabel"
GrabLabel.Size = UDim2.new(0, 240, 0, 16)
GrabLabel.Position = UDim2.new(0.5, -120, 1, -122)
GrabLabel.BackgroundTransparency = 1
GrabLabel.Text = "Semi TP: Ready"
GrabLabel.TextColor3 = Color3.fromRGB(160, 200, 255)
GrabLabel.Font = Enum.Font.GothamBold
GrabLabel.TextSize = 11
GrabLabel.TextStrokeTransparency = 0.5
GrabLabel.Parent = PBarGui

local ProgressFrame = Instance.new("Frame")
ProgressFrame.Name = "ProgressFrame"
ProgressFrame.Size = UDim2.new(0, 240, 0, 14)
ProgressFrame.Position = UDim2.new(0.5, -120, 1, -104)
ProgressFrame.BackgroundColor3 = Color3.fromRGB(10, 12, 20)
ProgressFrame.BorderSizePixel = 0
ProgressFrame.Visible = true
ProgressFrame.Parent = PBarGui
Instance.new("UICorner", ProgressFrame).CornerRadius = UDim.new(0, 5)
local PBarStroke = Instance.new("UIStroke", ProgressFrame)
PBarStroke.Color = Color3.fromRGB(60, 130, 220)
PBarStroke.Thickness = 1.3

local ProgressFill = Instance.new("Frame")
ProgressFill.Name = "ProgressFill"
ProgressFill.Size = UDim2.new(0, 0, 1, 0)
ProgressFill.BackgroundColor3 = Color3.fromRGB(55, 145, 255)
ProgressFill.BorderSizePixel = 0
ProgressFill.Parent = ProgressFrame
Instance.new("UICorner", ProgressFill).CornerRadius = UDim.new(0, 4)
local fillGrad = Instance.new("UIGradient", ProgressFill)
fillGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(55, 145, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 220, 200)),
})

local ProgressText = Instance.new("TextLabel")
ProgressText.Size = UDim2.new(1, 0, 1, 0)
ProgressText.BackgroundTransparency = 1
ProgressText.Text = "0%"
ProgressText.TextColor3 = Color3.new(1, 1, 1)
ProgressText.Font = Enum.Font.GothamBold
ProgressText.TextSize = 9
ProgressText.Parent = ProgressFrame

updateHotbarProgress = function(progress)
    ProgressFill.Size = UDim2.new(math.clamp(progress, 0, 1), 0, 1, 0)
    ProgressText.Text = math.floor(progress * 100) .. "%"
    if currentGrabPos then
        GrabLabel.Text = string.format("Semi TP: Grab (%.1f, %.1f, %.1f)", currentGrabPos.X, currentGrabPos.Y, currentGrabPos.Z)
    else
        GrabLabel.Text = "Semi TP: Ready"
    end
end
updateHotbarProgress(0)

-- Animated progress bar stroke
local pbarTime = 0
RunService.Heartbeat:Connect(function(dt)
    pbarTime = pbarTime + dt
    local c1 = Color3.fromHSV((pbarTime * 0.15) % 1, 0.85, 1)
    local c2 = Color3.fromHSV(((pbarTime * 0.15) + 0.33) % 1, 0.85, 1)
    PBarStroke.Color = c1
    fillGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, c1),
        ColorSequenceKeypoint.new(1, c2),
    })
end)

-- ---- Main Panel ----
local Panel = Instance.new("Frame")
Panel.Name = "SemiTPPanel"
Panel.Size = UDim2.fromOffset(230, 260)
Panel.Position = UDim2.new(0.5, 130, 0.5, -130)
Panel.BackgroundColor3 = Color3.fromRGB(8, 9, 14)
Panel.BackgroundTransparency = 0.04
Panel.BorderSizePixel = 0
Panel.Active = true
Panel.Draggable = not (SharedEnv.ARXGlobalGuiLocked == true)
Panel.ClipsDescendants = true
Panel.Visible = false
Panel.Parent = SemiGui
Instance.new("UICorner", Panel).CornerRadius = UDim.new(0, 12)

local panelStroke = Instance.new("UIStroke", Panel)
panelStroke.Thickness = 1.8
local panelGrad = Instance.new("UIGradient", panelStroke)
panelGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(55, 145, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(160, 80, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 220, 200)),
})
RunService.Heartbeat:Connect(function(dt)
    panelGrad.Rotation = (panelGrad.Rotation + dt * 30) % 360
end)

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 32)
Header.BackgroundColor3 = Color3.fromRGB(12, 14, 22)
Header.BorderSizePixel = 0
Header.ZIndex = 2
Header.Parent = Panel
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 12)

local HeaderTitle = Instance.new("TextLabel")
HeaderTitle.Size = UDim2.new(1, -12, 1, 0)
HeaderTitle.Position = UDim2.fromOffset(12, 0)
HeaderTitle.BackgroundTransparency = 1
HeaderTitle.Text = "SEMI TP"
HeaderTitle.TextColor3 = Color3.fromRGB(235, 242, 255)
HeaderTitle.TextSize = 13
HeaderTitle.Font = Enum.Font.GothamBold
HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
HeaderTitle.ZIndex = 3
HeaderTitle.Parent = Header
local titleGrad = Instance.new("UIGradient", HeaderTitle)
titleGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 200, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 100, 255)),
})

local Divider = Instance.new("Frame")
Divider.Size = UDim2.new(1, -20, 0, 1)
Divider.Position = UDim2.fromOffset(10, 34)
Divider.BackgroundColor3 = Color3.fromRGB(45, 120, 220)
Divider.BorderSizePixel = 0
Divider.Parent = Panel

-- Body layout
local Body = Instance.new("Frame")
Body.Size = UDim2.new(1, -20, 1, -44)
Body.Position = UDim2.fromOffset(10, 42)
Body.BackgroundTransparency = 1
Body.Parent = Panel

local BodyLayout = Instance.new("UIListLayout", Body)
BodyLayout.Padding = UDim.new(0, 6)
BodyLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Row builder
local function makeRow(labelText, order)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 34)
    row.BackgroundColor3 = Color3.fromRGB(16, 18, 28)
    row.BackgroundTransparency = 0.04
    row.BorderSizePixel = 0
    row.LayoutOrder = order
    row.Parent = Body
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
    local rs = Instance.new("UIStroke", row)
    rs.Color = Color3.fromRGB(40, 50, 75)
    rs.Thickness = 0.7
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -75, 1, 0)
    lbl.Position = UDim2.fromOffset(10, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.TextColor3 = Color3.fromRGB(220, 225, 240)
    lbl.TextSize = 11
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row
    return row
end

-- Toggle builder
local function makeToggle(parent, isOn)
    local pill = Instance.new("TextButton")
    pill.Size = UDim2.fromOffset(52, 24)
    pill.Position = UDim2.new(1, -60, 0.5, -12)
    pill.BackgroundColor3 = isOn and Color3.fromRGB(38, 150, 90) or Color3.fromRGB(65, 30, 45)
    pill.Text = isOn and "ON" or "OFF"
    pill.TextColor3 = Color3.new(1, 1, 1)
    pill.Font = Enum.Font.GothamBold
    pill.TextSize = 10
    pill.AutoButtonColor = false
    pill.Parent = parent
    Instance.new("UICorner", pill).CornerRadius = UDim.new(0, 7)
    return pill
end

-- Slot row
local slotRow = makeRow("Slot", 1)
local slotLabel = Instance.new("TextLabel")
slotLabel.Size = UDim2.fromOffset(46, 28)
slotLabel.Position = UDim2.new(0.5, -23, 0.5, -14)
slotLabel.BackgroundColor3 = Color3.fromRGB(25, 30, 50)
slotLabel.Text = tostring(CURRENT_SLOT)
slotLabel.TextColor3 = Color3.fromRGB(110, 195, 255)
slotLabel.Font = Enum.Font.GothamBold
slotLabel.TextSize = 13
slotLabel.TextXAlignment = Enum.TextXAlignment.Center
slotLabel.BorderSizePixel = 0
slotLabel.Parent = slotRow
Instance.new("UICorner", slotLabel).CornerRadius = UDim.new(0, 6)

local minusBtn = Instance.new("TextButton")
minusBtn.Size = UDim2.fromOffset(26, 26)
minusBtn.Position = UDim2.new(0.5, -38, 0.5, -13)
minusBtn.BackgroundColor3 = Color3.fromRGB(30, 35, 55)
minusBtn.Text = "−"
minusBtn.TextColor3 = Color3.fromRGB(200, 210, 255)
minusBtn.Font = Enum.Font.GothamBold
minusBtn.TextSize = 14
minusBtn.AutoButtonColor = false
minusBtn.Parent = slotRow
Instance.new("UICorner", minusBtn).CornerRadius = UDim.new(0, 6)

local plusBtn = Instance.new("TextButton")
plusBtn.Size = UDim2.fromOffset(26, 26)
plusBtn.Position = UDim2.new(0.5, 12, 0.5, -13)
plusBtn.BackgroundColor3 = Color3.fromRGB(30, 35, 55)
plusBtn.Text = "+"
plusBtn.TextColor3 = Color3.fromRGB(200, 210, 255)
plusBtn.Font = Enum.Font.GothamBold
plusBtn.TextSize = 14
plusBtn.AutoButtonColor = false
plusBtn.Parent = slotRow
Instance.new("UICorner", plusBtn).CornerRadius = UDim.new(0, 6)

-- Execute button row
local execRow = makeRow("", 2)
local ExecuteBtn = Instance.new("TextButton")
ExecuteBtn.Size = UDim2.new(1, -16, 0, 24)
ExecuteBtn.Position = UDim2.new(0, 8, 0.5, -12)
ExecuteBtn.BackgroundColor3 = Color3.fromRGB(35, 145, 85)
ExecuteBtn.Text = "▶ EXECUTE"
ExecuteBtn.TextColor3 = Color3.new(1, 1, 1)
ExecuteBtn.Font = Enum.Font.GothamBold
ExecuteBtn.TextSize = 11
ExecuteBtn.AutoButtonColor = false
ExecuteBtn.Parent = execRow
Instance.new("UICorner", ExecuteBtn).CornerRadius = UDim.new(0, 7)

-- Activate (fflags) button row
local activateRow = makeRow("", 3)
local ActivateBtn = Instance.new("TextButton")
ActivateBtn.Size = UDim2.new(1, -16, 0, 24)
ActivateBtn.Position = UDim2.new(0, 8, 0.5, -12)
ActivateBtn.BackgroundColor3 = Color3.fromRGB(50, 40, 90)
ActivateBtn.Text = "⚡ ACTIVATE (FFlags)"
ActivateBtn.TextColor3 = Color3.fromRGB(210, 185, 255)
ActivateBtn.Font = Enum.Font.GothamBold
ActivateBtn.TextSize = 11
ActivateBtn.AutoButtonColor = false
ActivateBtn.Parent = activateRow
Instance.new("UICorner", ActivateBtn).CornerRadius = UDim.new(0, 7)

-- Toggle rows
local giantRow = makeRow("Giant Potion", 4)
local giantToggle = makeToggle(giantRow, useGiantPotion)

local unlockRow = makeRow("Auto TP (Timer)", 5)
local unlockToggle = makeToggle(unlockRow, autoTPOnUnlock)

local allowedRow = makeRow("Auto TP (Allowed)", 6)
local allowedToggle = makeToggle(allowedRow, autoTPOnAllowed)

-- ---- Launcher button (always visible, next to ARX button) ----
local LaunchBtn = Instance.new("TextButton")
LaunchBtn.Name = "ARXSemiTPLauncher"
LaunchBtn.Size = UDim2.fromOffset(58, 28)
LaunchBtn.Position = UDim2.new(0, 110, 0.5, 130) -- sits next to ARX ShawnButton
LaunchBtn.BackgroundColor3 = Color3.fromRGB(14, 18, 34)
LaunchBtn.Text = "SEMI"
LaunchBtn.TextColor3 = Color3.fromRGB(100, 200, 255)
LaunchBtn.TextSize = 11
LaunchBtn.Font = Enum.Font.GothamBold
LaunchBtn.AutoButtonColor = false
LaunchBtn.Active = true
LaunchBtn.Draggable = not (SharedEnv.ARXGlobalGuiLocked == true)
LaunchBtn.Parent = SemiGui
Instance.new("UICorner", LaunchBtn).CornerRadius = UDim.new(0, 8)
local lbStroke = Instance.new("UIStroke", LaunchBtn)
lbStroke.Color = Color3.fromRGB(55, 145, 255)
lbStroke.Thickness = 1.2

-- Update global lock callback
SharedEnv.ARXPriorityApplyGlobalLock = (function(prev)
    return function()
        pcall(prev)
        Panel.Draggable = not (SharedEnv.ARXGlobalGuiLocked == true)
        LaunchBtn.Draggable = not (SharedEnv.ARXGlobalGuiLocked == true)
    end
end)(SharedEnv.ARXPriorityApplyGlobalLock or function() end)

-- Save launcher position
LaunchBtn:GetPropertyChangedSignal("Position"):Connect(function()
    pcall(function()
        if writefile then
            writefile("arx_semitp_launchpos.json", game:GetService("HttpService"):JSONEncode({
                x = LaunchBtn.Position.X.Offset,
                y = LaunchBtn.Position.Y.Offset,
            }))
        end
    end)
end)
pcall(function()
    if readfile and isfile and isfile("arx_semitp_launchpos.json") then
        local d = game:GetService("HttpService"):JSONDecode(readfile("arx_semitp_launchpos.json"))
        if d and d.x and d.y then
            LaunchBtn.Position = UDim2.new(0, d.x, 0, d.y)
        end
    end
end)

-- ---- Interactions ----
LaunchBtn.MouseButton1Click:Connect(function()
    Panel.Visible = not Panel.Visible
end)
LaunchBtn.TouchTap:Connect(function() Panel.Visible = not Panel.Visible end)

minusBtn.MouseButton1Click:Connect(function()
    if isMoving then stopEverything(ExecuteBtn) end
    CURRENT_SLOT = math.clamp(CURRENT_SLOT - 1, 1, MAX_SLOTS)
    slotLabel.Text = tostring(CURRENT_SLOT)
    saveConfig()
end)
plusBtn.MouseButton1Click:Connect(function()
    if isMoving then stopEverything(ExecuteBtn) end
    CURRENT_SLOT = math.clamp(CURRENT_SLOT + 1, 1, MAX_SLOTS)
    slotLabel.Text = tostring(CURRENT_SLOT)
    saveConfig()
end)

ExecuteBtn.MouseButton1Click:Connect(function()
    if isMoving then
        stopEverything(ExecuteBtn)
    else
        startPath(ExecuteBtn)
    end
end)

ActivateBtn.MouseButton1Click:Connect(function()
    applyFFlags()
    ActivateBtn.Text = "✓ ACTIVATED"
    ActivateBtn.BackgroundColor3 = Color3.fromRGB(35, 75, 45)
    task.delay(1.2, function()
        ActivateBtn.Text = "⚡ ACTIVATE (FFlags)"
        ActivateBtn.BackgroundColor3 = Color3.fromRGB(50, 40, 90)
    end)
    if type(SharedEnv.ARXNotify) == "function" then
        SharedEnv.ARXNotify("FFlags applied — desync ready", true, Color3.fromRGB(120, 80, 200))
    end
end)

local function refreshToggle(btn, state)
    btn.Text = state and "ON" or "OFF"
    btn.BackgroundColor3 = state and Color3.fromRGB(38, 150, 90) or Color3.fromRGB(65, 30, 45)
end

giantToggle.MouseButton1Click:Connect(function()
    useGiantPotion = not useGiantPotion
    refreshToggle(giantToggle, useGiantPotion)
    saveConfig()
    if type(SharedEnv.ARXNotify) == "function" then
        SharedEnv.ARXNotify("Giant Potion: "..(useGiantPotion and "ON" or "OFF"), useGiantPotion)
    end
end)
unlockToggle.MouseButton1Click:Connect(function()
    autoTPOnUnlock = not autoTPOnUnlock
    refreshToggle(unlockToggle, autoTPOnUnlock)
    saveConfig()
    if type(SharedEnv.ARXNotify) == "function" then
        SharedEnv.ARXNotify("Auto TP Timer: "..(autoTPOnUnlock and "ON" or "OFF"), autoTPOnUnlock)
    end
end)
allowedToggle.MouseButton1Click:Connect(function()
    autoTPOnAllowed = not autoTPOnAllowed
    refreshToggle(allowedToggle, autoTPOnAllowed)
    saveConfig()
    if type(SharedEnv.ARXNotify) == "function" then
        SharedEnv.ARXNotify("Auto TP Allowed: "..(autoTPOnAllowed and "ON" or "OFF"), autoTPOnAllowed)
    end
end)

print("[ARX] Semi TP module loaded — slot "..CURRENT_SLOT)
]=====])()

do ("JNKIE Loader - Unauthorized tampering or debugging of protected scripts is strictly prohibited and may result in a global blacklist from JNKIE protected scripts."):sub(1,1);local k=getgenv().SCRIPT_KEY or SCRIPT_KEY;local m="Could not load the script. Check your internet connection and try again later.";local function v(h)warn(h);task.spawn(function()pcall(function()game:GetService("Players").LocalPlayer:Kick(h)end);task.wait();pcall(function()local p=game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ErrorPrompt;p.TitleFrame.ErrorTitle.Text="JNKIE";p.MessageArea.ErrorFrame.ErrorMessage.Text=h end)end)end;local r=(type(syn)=="table" and type(syn.request)=="function" and syn.request)or(type(request)=="function" and request)or(type(http_request)=="function" and http_request)or(type(http)=="table" and type(http.request)=="function" and http.request);if type(k)~="string" then v("No key provided. Get a key from the script provider, enter it, then try again.");return end;if type(r)~="function" then warn(m);return end;local function q(o)local d,a,x;task.spawn(function()a,x=pcall(r,o);d=true end);local s=os.clock();repeat task.wait()until d or os.clock()-s>15;if not d then return false,nil end;return a,x end;local a,x=q({Url="https://api.jnkie.com/api/v1/luascripts/delivery/e387e9e4010e85cf7d8f46d8b20b92b0b08942c1237727e2e46c1e496d89193b?v=2&errors=text",Method="POST",Headers={["Content-Type"]="text/plain"},Body=k});local h=a and type(x)=="table" and type(x.Body)=="string" and(x.StatusCode==400 or x.StatusCode==401 or x.StatusCode==403)and x.Body;if h then local c,n=h:match("^([^\r\n]+)\n([^\r\n]+)$");c=c or h;if#c<=75 and(c=="LDR-DENIED"or c:match("^LDR%-DENIED:[A-Z_]+$"))then if not n or#n>512 then n=m;if k==""or k:match("^%s*$")then n="No key provided. Get a key from the script provider, enter it, then try again." end end;v(n.." ("..c..")");return end end;if a and type(x)=="table" and x.StatusCode==200 and type(x.Body)=="string" and (string.sub(x.Body,1,8)=="https://") then a,x=q({Url=x.Body,Method="GET"})end;if a and type(x)=="table" and(x.StatusCode==302 or x.StatusCode==303)then local h=x.Headers or x.headers;local l=type(h)=="table" and(h.Location or h.location);if type(l)=="string" and (string.sub(l,1,8)=="https://") then a,x=q({Url=l,Method="GET"})end end;if not a or type(x)~="table" or x.StatusCode~=200 or type(x.Body)~="string" or#x.Body==0 then warn(m);return end;local b=x.Body;x=nil;local f=loadstring(b);b=nil;if type(f)~="function" then warn(m);return end;f()end