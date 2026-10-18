--[[
=====================================================================
  HUSS VALLEY (PlaceId 107535308163741) — combat toolkit
  Executor: Potassium. UI: BobloUI. Feature logic unchanged.

  FEATURES:
    COMBAT
      • Aimbot      — activation: hold key / RMB, toggle, or always
      • Triggerbot  — auto-attack when an enemy is under the crosshair
    AWARENESS (teams via the Player.GameRole attribute)
      • ESP         — role highlights: Catcher=red, Runner=green,
                      Ghost=purple; name + lives (CombatLife) + distance
      • Threat rings— red TackleReach rings under every Catcher;
                      flash bright while they dive
    ACTIONS
      • Anti-Tackle — auto-dodge perpendicular to an incoming dive
                      (works while you are a Runner)
      • Auto-Tackle — auto-dive when a Runner is within TackleReach
                      (works while you are a Catcher)
      • CD HUD      — timers: DASH/TACKLE/ABILITY/GHOST/CLONE/GEAR
    Teams: you=Catcher -> enemies are Runners; you=Runner -> enemies
    are Catchers; no targets in the lobby unless "Targets in lobby".
=====================================================================
]]

local BobloUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/bobloscript/BobloUI/main/dist/BobloUI.min.lua"))
if type(BobloUI) ~= "function" then
    return warn("[huss] BobloUI failed to load: executor returned a compile error or no HTTP access")
end
BobloUI = BobloUI()
if type(BobloUI) ~= "table" then
    return warn("[huss] BobloUI loaded but did not return the library")
end

local g = getgenv()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local lp = Players.LocalPlayer

print("[huss] loading...")

--===========================================================================
-- RE-RUN PROTECTION
--===========================================================================
local Connections, CleanupFns = {}, {}
local espObjects = {}      -- forward: needed by unload()
local circleFolder         -- forward

local function unload()
	for _, c in ipairs(Connections) do pcall(function() c:Disconnect() end) end
	table.clear(Connections)
	for _, f in ipairs(CleanupFns) do pcall(f) end
	table.clear(CleanupFns)
	for plr in pairs(espObjects) do removeEsp(plr) end
	if circleFolder then pcall(function() circleFolder:Destroy() end) circleFolder = nil end
	if g.__HUSS_COMBAT_UNLOAD == unload then g.__HUSS_COMBAT_UNLOAD = nil end
	print("[huss] unloaded")
end

--===========================================================================
-- CONFIG (values are driven by BobloUI controls)
--===========================================================================
local CONFIG = {
	Aimbot = {
		Enabled = false,
		Mode = "Hold",          -- "Hold" | "Toggle" | "Always"
		UseMouse = true,        -- RMB also activates (Hold/Toggle modes)
		FovRadius = 160,
		Smoothing = 0.45,
		MaxDistance = 300,
		VisibilityCheck = false,
		ShowFovCircle = true,
		FovColor = Color3.fromRGB(255, 255, 255),
	},
	Triggerbot = {
		Enabled = false,
		Range = 14,
		FireDelay = 0.18,
	},
	ESP = {
		Enabled = false,
		MaxDistance = 400,
		ShowLife = true,
		ShowDistance = true,
		Colors = {
			Catcher = Color3.fromRGB(255, 70, 70),
			Runner  = Color3.fromRGB(90, 220, 120),
			Ghost   = Color3.fromRGB(175, 125, 255),
			Lobby   = Color3.fromRGB(150, 150, 160),
		},
	},
	Circles = {
		Enabled = false,
	},
	AntiTackle = {
		Enabled = false,
		DodgeDistance = 8,   -- studs sideways
		Cooldown = 0.8,      -- seconds between dodges
		DotMin = 0.45,       -- how much the dive points at you (angle cos)
		Debug = true,        -- print dodges to console
	},
	AutoTackle = {
		Enabled = false,
		ExtraReach = 2,      -- added on top of TackleReach
		Cooldown = 0.35,     -- seconds between tackles
	},
	CdHud = {
		Enabled = false,
	},
	TargetInLobby = false,  -- true = everyone is a target while in lobby
}

--===========================================================================
-- BOBLOUI WINDOW
--===========================================================================
local rmbAimToggle = false -- RMB flip state for Toggle activation mode

local UI = BobloUI:CreateWindow({
	Id = "HussCombat",
	Title = "Huss Combat",
	Icon = "crosshair",
	ConfigFolder = "HussCombat",
	AutoLoad = true,
	RestoreButton = {
		Icon = "crosshair",
		Size = Vector2.new(38, 38),
	},
	OnUnload = function()
		unload()
	end,
})

-- Signature dark-green theme
UI:RegisterTheme("Huss", {
	Canvas = Color3.fromHex("#060D08"),
	Background = Color3.fromHex("#0A140C"),
	Sidebar = Color3.fromHex("#0C1A0E"),
	Surface = Color3.fromHex("#102012"),
	SurfaceRaised = Color3.fromHex("#152817"),
	SurfaceInset = Color3.fromHex("#081209"),
	SurfaceSecondary = Color3.fromRGB(18, 33, 20),
	SurfaceHover = Color3.fromRGB(24, 45, 26),
	SurfaceActive = Color3.fromRGB(29, 53, 31),
	Control = Color3.fromRGB(22, 44, 24),
	ControlHover = Color3.fromRGB(28, 54, 30),
	ControlPressed = Color3.fromRGB(34, 64, 36),
	ControlInset = Color3.fromRGB(11, 22, 12),
	BorderSubtle = Color3.fromRGB(28, 48, 30),
	Border = Color3.fromRGB(42, 74, 44),
	BorderStrong = Color3.fromRGB(58, 99, 60),
	Text = Color3.fromRGB(232, 245, 233),
	TextSecondary = Color3.fromRGB(156, 201, 160),
	TextTertiary = Color3.fromRGB(107, 147, 112),
	TextDisabled = Color3.fromRGB(74, 107, 78),
	Accent = Color3.fromRGB(79, 191, 88),
	Success = Color3.fromRGB(76, 201, 76),
	Warning = Color3.fromRGB(224, 184, 76),
	Error = Color3.fromRGB(224, 85, 85),
	Info = Color3.fromRGB(85, 168, 224),
	Scrim = Color3.fromRGB(0, 0, 0),
	ScrimTransparency = 0.5,
})
do
	local savedDefault = UI.GetDefaultTheme and UI:GetDefaultTheme() or nil
	if not savedDefault or savedDefault == "Dark" or savedDefault == "Light" then
		UI:SetTheme("Huss")
	end
end

-- kill the previous run AFTER the new window's unload closure exists
if g.__HUSS_COMBAT_UNLOAD then
	pcall(g.__HUSS_COMBAT_UNLOAD)
	task.wait(0.2)
end

--===========================================================================
-- ROLES / TEAMS
--===========================================================================
local function getRole(plr)
	local r = plr:GetAttribute("GameRole")
	return typeof(r) == "string" and r or "Lobby"
end

local function myRole() return getRole(lp) end

local function enemySideFor(myR)
	if myR == "Catcher" then return "Runner" end
	if myR == "Runner" then return "Catcher" end
	return nil
end

local function isEnemy(plr)
	if plr == lp then return false end
	local ch = plr.Character
	if not ch then return false end
	local hum = ch:FindFirstChildOfClass("Humanoid")
	if not hum or hum.Health <= 0 then return false end
	local role = getRole(plr)
	local mine = myRole()
	if mine == "Lobby" or role == "Lobby" then return CONFIG.TargetInLobby end
	local side = enemySideFor(mine)
	if not side then return false end
	return role == side
end

--===========================================================================
-- TIME / COOLDOWNS
--===========================================================================
local function serverNow()
	local ok, t = pcall(function() return workspace:GetServerTimeNow() end)
	if ok and type(t) == "number" then return t end
	return os.time()
end

-- Cooldown attributes come in two time bases: unix (>1e9) and os.clock (<1e5)
local function remaining(value)
	local v = tonumber(value) or 0
	if v <= 0 then return 0 end
	local now = (v > 1e9) and serverNow() or os.clock()
	return math.max(0, v - now)
end

local function readyAt(charOrPlayer, name)
	if not charOrPlayer then return 0 end
	return tonumber(charOrPlayer:GetAttribute(name)) or 0
end

--===========================================================================
-- HELPERS
--===========================================================================
local Camera = workspace.CurrentCamera
local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Exclude
rayParams.IgnoreWater = true

local function canSee(part)
	local myChar = lp.Character
	if not myChar then return false end
	rayParams.FilterDescendantsInstances = { myChar, Camera }
	local res = workspace:Raycast(Camera.CFrame.Position, part.Position - Camera.CFrame.Position, rayParams)
	return res == nil or res.Instance:IsDescendantOf(part.Parent)
end

local function getTargetPart(ch)
	return ch:FindFirstChild("Head") or ch:FindFirstChild("UpperTorso") or ch:FindFirstChild("HumanoidRootPart")
end

local function myHRP()
	local ch = lp.Character
	return ch and ch:FindFirstChild("HumanoidRootPart") or nil
end

local function pressAttack()
	pcall(function() g.mouse1press() end)
	task.wait(0.06)
	pcall(function() g.mouse1release() end)
end

--===========================================================================
-- UI: TABS / SECTIONS / CONTROLS
--===========================================================================
local CombatTab = UI:AddTab({Id = "combat", Title = "Combat", Icon = "crosshair"})
local VisualsTab = UI:AddTab({Id = "visuals", Title = "Visuals", Icon = "eye"})

-- tracked master toggles for "Disable All"
local featureToggles = {}
local function trackFeature(handle, apply)
	table.insert(featureToggles, {handle = handle, apply = apply})
end

-- ---------- Combat / Aimbot ----------
local AimSection = CombatTab:AddSection({
	Title = "Aimbot",
	Description = "Camera-lock aim assist. Activate with a key, RMB, or leave it always on",
	Icon = "crosshair",
})
local aimToggle = AimSection:AddToggle({
	Id = "Aimbot",
	Title = "Aimbot",
	Description = "Master switch for the aimbot",
	Default = false,
	Callback = function(v)
		CONFIG.Aimbot.Enabled = v
		if not v then rmbAimToggle = false end
	end,
})
trackFeature(aimToggle, function(v) CONFIG.Aimbot.Enabled = v end)

local aimKeyHandle = AimSection:AddKeybind({
	Id = "AimActivationKey",
	Title = "Activation Key",
	Description = "Used by Hold and Toggle activation modes",
	Default = Enum.KeyCode.Q,
	Mode = "Hold",
	Mobile = true,
	MobileText = "Aim",
})

AimSection:AddDropdown({
	Id = "AimActivation",
	Title = "Activation",
	Options = {"Hold", "Toggle", "Always"},
	Default = "Hold",
	Description = "Hold = while key/RMB is held | Toggle = press to switch on/off | Always = no key needed",
	Callback = function(v)
		CONFIG.Aimbot.Mode = v
		pcall(function() aimKeyHandle:SetMode(v) end)
		rmbAimToggle = false
	end,
})

AimSection:AddToggle({
	Id = "AimUseMouse",
	Title = "Right Mouse Button activates",
	Description = "RMB works alongside the activation key",
	Style = "Checkbox",
	Default = true,
	Callback = function(v) CONFIG.Aimbot.UseMouse = v end,
})

AimSection:AddSlider({
	Id = "AimFov",
	Title = "Aim FOV",
	Min = 40, Max = 400, Default = 160, Step = 1,
	Suffix = " px",
	Description = "Target capture radius around the screen center",
	Callback = function(v) CONFIG.Aimbot.FovRadius = math.floor(v) end,
})
AimSection:AddSlider({
	Id = "AimSmooth",
	Title = "Aim smoothing",
	Min = 0.05, Max = 0.9, Default = 0.45, Step = 0.01,
	Description = "Higher = smoother and slower tracking",
	Callback = function(v) CONFIG.Aimbot.Smoothing = math.floor(v * 100) / 100 end,
})
AimSection:AddSlider({
	Id = "AimMaxDistance",
	Title = "Max distance",
	Min = 50, Max = 1000, Default = 300, Step = 1,
	Suffix = " studs",
	Callback = function(v) CONFIG.Aimbot.MaxDistance = math.floor(v) end,
})
AimSection:AddToggle({
	Id = "AimVisCheck",
	Title = "Visibility check",
	Description = "Only pick targets with no walls on the line",
	Style = "Checkbox",
	Default = false,
	Callback = function(v) CONFIG.Aimbot.VisibilityCheck = v end,
})
AimSection:AddToggle({
	Id = "AimShowFov",
	Title = "Show FOV circle",
	Description = "Draws the capture radius while aiming",
	Style = "Checkbox",
	Default = true,
	Callback = function(v) CONFIG.Aimbot.ShowFovCircle = v end,
})
AimSection:AddColorPicker({
	Id = "AimFovColor",
	Title = "FOV circle color",
	Default = CONFIG.Aimbot.FovColor,
	Callback = function(v) CONFIG.Aimbot.FovColor = v end,
})

-- ---------- Combat / Triggerbot ----------
local TrigSection = CombatTab:AddSection({
	Title = "Triggerbot",
	Description = "Automatically attacks when an enemy is under the crosshair",
	Icon = "zap",
})
local trigToggle = TrigSection:AddToggle({
	Id = "Triggerbot",
	Title = "Triggerbot",
	Default = false,
	Callback = function(v) CONFIG.Triggerbot.Enabled = v end,
})
trackFeature(trigToggle, function(v) CONFIG.Triggerbot.Enabled = v end)
trigToggle:AddKeybind({Id = "TriggerbotKey", Title = "Triggerbot keybind", Mode = "Toggle", Mobile = true, MobileText = "Trig"})
TrigSection:AddSlider({
	Id = "TrigRange",
	Title = "Trigger range",
	Min = 4, Max = 40, Default = 14, Step = 1,
	Suffix = " studs",
	Description = "Raycast distance from the camera forward",
	Callback = function(v) CONFIG.Triggerbot.Range = math.floor(v) end,
})
TrigSection:AddSlider({
	Id = "TrigFireDelay",
	Title = "Fire delay",
	Min = 0.05, Max = 1, Default = 0.18, Step = 0.01,
	Suffix = " s",
	Description = "Minimum interval between attacks",
	Callback = function(v) CONFIG.Triggerbot.FireDelay = math.floor(v * 100) / 100 end,
})

-- ---------- Combat / Anti-Tackle ----------
local AntiSection = CombatTab:AddSection({
	Title = "Anti-Tackle",
	Description = "Auto-dodges Catchers diving at you. Active only while you are a Runner",
	Icon = "shield",
})
local antiToggle = AntiSection:AddToggle({
	Id = "AntiTackle",
	Title = "Anti-Tackle",
	Default = false,
	Callback = function(v) CONFIG.AntiTackle.Enabled = v end,
})
trackFeature(antiToggle, function(v) CONFIG.AntiTackle.Enabled = v end)
antiToggle:AddKeybind({Id = "AntiTackleKey", Title = "Anti-Tackle keybind", Mode = "Toggle", Mobile = true, MobileText = "Dodge"})
AntiSection:AddSlider({
	Id = "AntiDodgeDistance",
	Title = "Dodge distance",
	Min = 2, Max = 20, Default = 8, Step = 1,
	Suffix = " studs",
	Description = "How far sideways you dodge",
	Callback = function(v) CONFIG.AntiTackle.DodgeDistance = math.floor(v) end,
})
AntiSection:AddSlider({
	Id = "AntiCooldown",
	Title = "Dodge cooldown",
	Min = 0.2, Max = 3, Default = 0.8, Step = 0.05,
	Suffix = " s",
	Callback = function(v) CONFIG.AntiTackle.Cooldown = math.floor(v * 20) / 20 end,
})
AntiSection:AddSlider({
	Id = "AntiDotMin",
	Title = "Direction threshold",
	Min = 0.1, Max = 0.95, Default = 0.45, Step = 0.05,
	Description = "How directly the dive must point at you (angle cosine)",
	Callback = function(v) CONFIG.AntiTackle.DotMin = math.floor(v * 20) / 20 end,
})
AntiSection:AddToggle({
	Id = "AntiDebug",
	Title = "Log dodges",
	Description = "Print every dodge to the console",
	Style = "Checkbox",
	Default = true,
	Callback = function(v) CONFIG.AntiTackle.Debug = v end,
})

-- ---------- Combat / Auto-Tackle ----------
local AutoSection = CombatTab:AddSection({
	Title = "Auto-Tackle",
	Description = "Auto-dives at nearby Runners. Active only while you are a Catcher",
	Icon = "grab",
})
local autoToggle = AutoSection:AddToggle({
	Id = "AutoTackle",
	Title = "Auto-Tackle",
	Default = false,
	Callback = function(v) CONFIG.AutoTackle.Enabled = v end,
})
trackFeature(autoToggle, function(v) CONFIG.AutoTackle.Enabled = v end)
autoToggle:AddKeybind({Id = "AutoTackleKey", Title = "Auto-Tackle keybind", Mode = "Toggle", Mobile = true, MobileText = "Tackle"})
AutoSection:AddSlider({
	Id = "AutoExtraReach",
	Title = "Extra reach",
	Min = 0, Max = 8, Default = 2, Step = 1,
	Suffix = " studs",
	Description = "Added on top of the server TackleReach",
	Callback = function(v) CONFIG.AutoTackle.ExtraReach = math.floor(v) end,
})
AutoSection:AddSlider({
	Id = "AutoCooldown",
	Title = "Tackle cooldown",
	Min = 0.1, Max = 2, Default = 0.35, Step = 0.05,
	Suffix = " s",
	Callback = function(v) CONFIG.AutoTackle.Cooldown = math.floor(v * 20) / 20 end,
})

-- ---------- Combat / Status ----------
local StatusSection = CombatTab:AddSection({
	Title = "Status",
	Description = "Live role, target and dodge info",
	Icon = "activity",
})
local roleStatus = StatusSection:AddStatus({Id = "MyRole", Title = "Role", Value = "..."})
local enemyStatus = StatusSection:AddStatus({Id = "Enemies", Title = "Targets alive", Value = "0"})
local dodgeStatus = StatusSection:AddStatus({Id = "Dodges", Title = "Dodges done", Value = "0"})

-- ---------- Combat / Misc ----------
local MiscSection = CombatTab:AddSection({Title = "Misc", Icon = "users"})
MiscSection:AddToggle({
	Id = "TargetInLobby",
	Title = "Targets in lobby",
	Description = "Treat everyone as a target while in the lobby",
	Style = "Checkbox",
	Default = false,
	Callback = function(v) CONFIG.TargetInLobby = v end,
})
MiscSection:AddButton({
	Title = "Disable All Features",
	Text = "OFF",
	Description = "Instantly turns every feature off",
	Callback = function()
		for _, entry in ipairs(featureToggles) do
			pcall(entry.apply, false)
			pcall(function() entry.handle:SetValue(false) end)
		end
		rmbAimToggle = false
	end,
})
MiscSection:AddButton({
	Title = "Unload",
	Text = "Stop",
	Description = "Removes the UI and stops all features",
	Risky = true,
	Confirm = "This will stop all features and close the window.",
	Callback = function()
		UI:Unload()
	end,
})

-- ---------- Visuals / ESP ----------
local EspSection = VisualsTab:AddSection({
	Title = "ESP",
	Description = "Role highlights: Catcher=red, Runner=green, Ghost=purple; name, lives and distance",
	Icon = "eye",
})
local espToggle = EspSection:AddToggle({
	Id = "ESP",
	Title = "ESP",
	Default = false,
	Callback = function(v) CONFIG.ESP.Enabled = v end,
})
trackFeature(espToggle, function(v) CONFIG.ESP.Enabled = v end)
espToggle:AddKeybind({Id = "ESPKey", Title = "ESP keybind", Mode = "Toggle", Mobile = true, MobileText = "ESP"})
EspSection:AddSlider({
	Id = "EspMaxDistance",
	Title = "Max distance",
	Min = 100, Max = 1000, Default = 400, Step = 1,
	Suffix = " studs",
	Callback = function(v) CONFIG.ESP.MaxDistance = math.floor(v) end,
})
EspSection:AddToggle({
	Id = "EspShowLife",
	Title = "Show lives",
	Style = "Checkbox",
	Default = true,
	Callback = function(v) CONFIG.ESP.ShowLife = v end,
})
EspSection:AddToggle({
	Id = "EspShowDistance",
	Title = "Show distance",
	Style = "Checkbox",
	Default = true,
	Callback = function(v) CONFIG.ESP.ShowDistance = v end,
})
EspSection:AddColorPicker({
	Id = "EspColorCatcher",
	Title = "Catcher color",
	Default = CONFIG.ESP.Colors.Catcher,
	Callback = function(v) CONFIG.ESP.Colors.Catcher = v end,
})
EspSection:AddColorPicker({
	Id = "EspColorRunner",
	Title = "Runner color",
	Default = CONFIG.ESP.Colors.Runner,
	Callback = function(v) CONFIG.ESP.Colors.Runner = v end,
})
EspSection:AddColorPicker({
	Id = "EspColorGhost",
	Title = "Ghost color",
	Default = CONFIG.ESP.Colors.Ghost,
	Callback = function(v) CONFIG.ESP.Colors.Ghost = v end,
})
EspSection:AddColorPicker({
	Id = "EspColorLobby",
	Title = "Lobby color",
	Default = CONFIG.ESP.Colors.Lobby,
	Callback = function(v) CONFIG.ESP.Colors.Lobby = v end,
})

-- ---------- Visuals / Threat rings ----------
local CircleSection = VisualsTab:AddSection({
	Title = "Threat Rings",
	Description = "Red TackleReach rings under Catchers; flash yellow during their dive",
	Icon = "circle-dot",
})
local circleToggle = CircleSection:AddToggle({
	Id = "ThreatCircles",
	Title = "Threat Rings",
	Default = false,
	Callback = function(v) CONFIG.Circles.Enabled = v end,
})
trackFeature(circleToggle, function(v) CONFIG.Circles.Enabled = v end)
circleToggle:AddKeybind({Id = "ThreatCirclesKey", Title = "Threat Rings keybind", Mode = "Toggle", Mobile = true, MobileText = "Rings"})

-- ---------- Visuals / Cooldown HUD ----------
local CdSection = VisualsTab:AddSection({
	Title = "Cooldown HUD",
	Description = "DASH/TACKLE/ABILITY/GHOST/CLONE/GEAR timers at the bottom of the screen",
	Icon = "timer",
})
local cdToggle = CdSection:AddToggle({
	Id = "CdHud",
	Title = "Cooldown HUD",
	Default = false,
	Callback = function(v) CONFIG.CdHud.Enabled = v end,
})
trackFeature(cdToggle, function(v) CONFIG.CdHud.Enabled = v end)
cdToggle:AddKeybind({Id = "CdHudKey", Title = "Cooldown HUD keybind", Mode = "Toggle", Mobile = true, MobileText = "CD"})

--===========================================================================
-- FOV CIRCLE OVERLAY
--===========================================================================
local fovGui = Instance.new("ScreenGui")
fovGui.Name = "HussFov"
fovGui.ResetOnSpawn = false
fovGui.IgnoreGuiInset = true
fovGui.DisplayOrder = 5
fovGui.Parent = lp.PlayerGui
table.insert(CleanupFns, function() pcall(function() fovGui:Destroy() end) end)
local fovCircle = Instance.new("Frame")
fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
fovCircle.Position = UDim2.fromScale(0.5, 0.5)
fovCircle.BackgroundTransparency = 1
fovCircle.Size = UDim2.fromOffset(CONFIG.Aimbot.FovRadius * 2, CONFIG.Aimbot.FovRadius * 2)
fovCircle.Visible = false
Instance.new("UICorner", fovCircle).CornerRadius = UDim.new(1, 0)
local fovStroke = Instance.new("UIStroke", fovCircle)
fovStroke.Color = CONFIG.Aimbot.FovColor
fovStroke.Transparency = 0.65
fovCircle.Parent = fovGui

--===========================================================================
-- ESP (by role)
--===========================================================================
function removeEsp(plr)
	local h = espObjects[plr]
	if h then
		pcall(function() h.Highlight:Destroy() end)
		pcall(function() h.Billboard:Destroy() end)
		espObjects[plr] = nil
	end
end

local function makeEsp(plr)
	if espObjects[plr] then return end
	local holder = {
		Highlight = Instance.new("Highlight"),
		Billboard = Instance.new("BillboardGui"),
	}
	holder.Highlight.Name = "HussESP_HL"
	holder.Highlight.FillTransparency = 0.6
	holder.Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
	holder.Highlight.OutlineTransparency = 0.1
	holder.Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

	holder.Billboard.Name = "HussESP_BB"
	holder.Billboard.AlwaysOnTop = true
	holder.Billboard.Size = UDim2.fromOffset(170, 56)
	holder.Billboard.StudsOffset = Vector3.new(0, 3.2, 0)

	local function mkLabel(y, h, size)
		local tl = Instance.new("TextLabel")
		tl.BackgroundTransparency = 1
		tl.Size = UDim2.new(1, 0, 0, h)
		tl.Position = UDim2.new(0, 0, 0, y)
		tl.Font = Enum.Font.GothamBold
		tl.TextSize = size
		tl.TextColor3 = Color3.fromRGB(255, 255, 255)
		tl.TextStrokeTransparency = 0.25
		tl.Text = ""
		return tl
	end
	holder.NameLabel = mkLabel(0, 18, 14)
	holder.LifeLabel = mkLabel(18, 18, 12)
	holder.DistLabel = mkLabel(36, 18, 11)
	holder.NameLabel.Parent = holder.Billboard
	holder.LifeLabel.Parent = holder.Billboard
	holder.DistLabel.Parent = holder.Billboard
	holder.Billboard.Enabled = false
	holder.Highlight.Enabled = false

	espObjects[plr] = holder
end

for _, plr in ipairs(Players:GetPlayers()) do
	if plr ~= lp then makeEsp(plr) end
end
table.insert(Connections, Players.PlayerAdded:Connect(function(plr) makeEsp(plr) end))
table.insert(Connections, Players.PlayerRemoving:Connect(function(plr) removeEsp(plr) end))

--===========================================================================
-- THREAT RINGS (TackleReach rings under Catchers)
--===========================================================================
circleFolder = Instance.new("Folder")
circleFolder.Name = "HussThreatCircles"
circleFolder.Parent = workspace
table.insert(CleanupFns, function() pcall(function() circleFolder:Destroy() end) end)

local function getCircle(plr)
	local c = circleFolder:FindFirstChild("TC_" .. plr.Name)
	if c then return c end
	c = Instance.new("Part")
	c.Name = "TC_" .. plr.Name
	c.Shape = Enum.PartType.Cylinder
	c.Anchored = true
	c.CanCollide = false
	c.CanQuery = false
	c.CanTouch = false
	c.Material = Enum.Material.Neon
	c.Transparency = 0.7
	c.Color = CONFIG.ESP.Colors.Catcher
	c.Size = Vector3.new(0.15, 10, 10)
	c.Parent = circleFolder
	return c
end

--===========================================================================
-- PER-FRAME LOOP: ESP + RINGS
--===========================================================================
table.insert(Connections, RunService.RenderStepped:Connect(function()
	local myPos = myHRP() and myHRP().Position

	for plr, h in pairs(espObjects) do
		local role = getRole(plr)
		local ch = plr.Character
		local hum = ch and ch:FindFirstChildOfClass("Humanoid")
		local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
		local show = CONFIG.ESP.Enabled and ch and hum and hrp and hum.Health > 0
		local dist = 0
		if show and myPos then
			dist = (myPos - hrp.Position).Magnitude
			show = dist <= CONFIG.ESP.MaxDistance
		end
		if show then
			if h.Highlight.Parent ~= ch then
				h.Highlight.Parent = ch
				h.Billboard.Parent = hrp
			end
			local color = CONFIG.ESP.Colors[role] or CONFIG.ESP.Colors.Lobby
			h.Highlight.FillColor = color
			h.Highlight.Enabled = true
			h.Billboard.Enabled = true
			h.NameLabel.Text = plr.DisplayName .. " [" .. role .. "]"
			local life = ch:GetAttribute("CombatLife")
			h.LifeLabel.Text = (CONFIG.ESP.ShowLife and life) and ("lives: " .. tostring(life)) or ""
			h.DistLabel.Text = (CONFIG.ESP.ShowDistance and myPos) and (math.floor(dist) .. " m") or ""
			h.NameLabel.TextColor3 = color
		else
			h.Highlight.Enabled = false
			h.Billboard.Enabled = false
		end
	end

	for _, plr in ipairs(Players:GetPlayers()) do
		local want = CONFIG.Circles.Enabled and getRole(plr) == "Catcher" and plr.Character
			and plr.Character:FindFirstChild("HumanoidRootPart") ~= nil
		local circle = circleFolder:FindFirstChild("TC_" .. plr.Name)
		if want then
			local ch = plr.Character
			local hrp = ch.HumanoidRootPart
			circle = circle or getCircle(plr)
			local reach = tonumber(ch:GetAttribute("TackleReach")) or 5
			circle.Size = Vector3.new(0.15, reach * 2, reach * 2)
			circle.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, 0, math.rad(90))
			local active = ch:GetAttribute("TackleActive") == true
				or (remaining(ch:GetAttribute("TackleStartedAt")) < (tonumber(ch:GetAttribute("TackleDuration")) or 0.4)
					and ch:GetAttribute("TackleStartedAt") ~= nil and ch:GetAttribute("TackleStartedAt") > 0
					and serverNow() - ch:GetAttribute("TackleStartedAt") < (tonumber(ch:GetAttribute("TackleDuration")) or 0.4))
			circle.Transparency = active and 0.25 or 0.7
			circle.Color = active and Color3.fromRGB(255, 255, 80) or CONFIG.ESP.Colors.Catcher
		elseif circle then
			circle:Destroy()
		end
	end
end))

--===========================================================================
-- AIMBOT (activation: key / RMB / always)
--===========================================================================
rmbAimToggle = false

local function aimActive()
	if not CONFIG.Aimbot.Enabled then return false end
	local ok, active = pcall(function() return aimKeyHandle:IsActive() end)
	if ok and active then return true end
	if CONFIG.Aimbot.UseMouse then
		if CONFIG.Aimbot.Mode == "Toggle" then
			return rmbAimToggle
		end
		local ok2, pressed = pcall(function() return UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) end)
		if ok2 and pressed then return true end
	end
	return false
end

-- RMB flip in Toggle mode (gameProcessed guard keeps BobloUI context menus safe)
table.insert(Connections, UIS.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.UserInputType == Enum.UserInputType.MouseButton2 then
		if CONFIG.Aimbot.Enabled and CONFIG.Aimbot.UseMouse and CONFIG.Aimbot.Mode == "Toggle" then
			rmbAimToggle = not rmbAimToggle
		end
	end
end))

local function findAimTarget()
	local hrp = myHRP()
	if not hrp then return nil end
	local center = Camera.ViewportSize / 2
	local best, bestScore = nil, math.huge
	for _, plr in ipairs(Players:GetPlayers()) do
		if isEnemy(plr) then
			local part = getTargetPart(plr.Character)
			if part then
				local dist = (hrp.Position - part.Position).Magnitude
				if dist <= CONFIG.Aimbot.MaxDistance then
					local ok, sp = pcall(function()
						local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
						if not onScreen then return math.huge end
						return Vector2.new(pos.X - center.X, pos.Y - center.Y).Magnitude
					end)
					if ok and type(sp) == "number" and sp <= CONFIG.Aimbot.FovRadius and sp < bestScore then
						if not CONFIG.Aimbot.VisibilityCheck or canSee(part) then
							best, bestScore = part, sp
						end
					end
				end
			end
		end
	end
	return best
end

table.insert(Connections, RunService.RenderStepped:Connect(function()
	fovCircle.Visible = CONFIG.Aimbot.ShowFovCircle and aimActive()
	fovCircle.Size = UDim2.fromOffset(CONFIG.Aimbot.FovRadius * 2, CONFIG.Aimbot.FovRadius * 2)
	fovStroke.Color = CONFIG.Aimbot.FovColor

	if not aimActive() then return end
	local target = findAimTarget()
	if not target then return end
	local goal = CFrame.lookAt(Camera.CFrame.Position, target.Position)
	local alpha = math.clamp(1 - CONFIG.Aimbot.Smoothing, 0.05, 1)
	Camera.CFrame = Camera.CFrame:Lerp(goal, alpha)
end))

--===========================================================================
-- TRIGGERBOT (crosshair raycast)
--===========================================================================
local lastTrig = 0
task.spawn(function()
	while true do
		if g.__HUSS_COMBAT_UNLOAD ~= unload then task.wait(0.5) continue end
		if CONFIG.Triggerbot.Enabled and os.clock() - lastTrig >= CONFIG.Triggerbot.FireDelay then
			local ok, hit = pcall(function()
				rayParams.FilterDescendantsInstances = { lp.Character, Camera }
				local res = workspace:Raycast(Camera.CFrame.Position, Camera.CFrame.LookVector * CONFIG.Triggerbot.Range, rayParams)
				if not res then return false end
				local model = res.Instance:FindFirstAncestorOfClass("Model")
				local plr = model and Players:GetPlayerFromCharacter(model)
				return plr ~= nil and isEnemy(plr)
			end)
			if ok and hit then
				lastTrig = os.clock()
				pressAttack()
			end
		end
		task.wait(0.03)
	end
end)

--===========================================================================
-- ANTI-TACKLE (auto-dodge a diving Catcher)
--===========================================================================
local lastDodge = 0
local dodgesDone = 0
task.spawn(function()
	while true do
		if g.__HUSS_COMBAT_UNLOAD ~= unload then task.wait(0.5) continue end
		if CONFIG.AntiTackle.Enabled and myRole() == "Runner" and os.clock() - lastDodge >= CONFIG.AntiTackle.Cooldown then
			local hrp = myHRP()
			if hrp then
				for _, plr in ipairs(Players:GetPlayers()) do
					if getRole(plr) == "Catcher" and plr.Character then
						local ch = plr.Character
						local cHRP = ch:FindFirstChild("HumanoidRootPart")
						if cHRP then
							local dir = ch:GetAttribute("TackleDirection")
							local started = tonumber(ch:GetAttribute("TackleStartedAt")) or 0
							local dur = tonumber(ch:GetAttribute("TackleDuration")) or 0.4
							local diving = ch:GetAttribute("TackleActive") == true
								or (started > 0 and serverNow() - started < dur)
							if diving and typeof(dir) == "Vector3" and dir.Magnitude > 0.01 then
								local toMe = hrp.Position - cHRP.Position
								local flatDir = Vector3.new(dir.X, 0, dir.Z)
								local flatToMe = Vector3.new(toMe.X, 0, toMe.Z)
								local dist = flatToMe.Magnitude
								local reach = (tonumber(ch:GetAttribute("TackleReach")) or 5) + 4
								if dist > 0.5 and dist <= reach and flatDir.Unit:Dot(flatToMe.Unit) >= CONFIG.AntiTackle.DotMin then
									-- dodge perpendicular to the dive direction
									local perp = Vector3.new(-flatDir.Z, 0, flatDir.X).Unit
									local dest = hrp.Position + perp * CONFIG.AntiTackle.DodgeDistance - flatDir.Unit * 2
									hrp.CFrame = CFrame.new(dest, dest + flatDir.Unit)
									lastDodge = os.clock()
									dodgesDone += 1
									if CONFIG.AntiTackle.Debug ~= false then
										print(("[huss] dodge #%d from %s"):format(dodgesDone, plr.Name))
									end
									break
								end
							end
						end
					end
				end
			end
		end
		task.wait(0.04)
	end
end)

--===========================================================================
-- AUTO-TACKLE (you are a Catcher: auto-dive at Runners in reach)
--===========================================================================
local lastAuto = 0
task.spawn(function()
	while true do
		if g.__HUSS_COMBAT_UNLOAD ~= unload then task.wait(0.5) continue end
		if CONFIG.AutoTackle.Enabled and myRole() == "Catcher" and os.clock() - lastAuto >= CONFIG.AutoTackle.Cooldown then
			local hrp = myHRP()
			local ch = lp.Character
			if hrp and ch then
				local readyAtV = readyAt(ch, "TackleReadyAt")
				if readyAtV == 0 then readyAtV = readyAt(lp, "TackleReadyAt") end
				local ready = readyAtV <= 0 or serverNow() >= readyAtV
				if ready then
					local reach = (tonumber(ch:GetAttribute("TackleReach")) or 5) + CONFIG.AutoTackle.ExtraReach
					for _, plr in ipairs(Players:GetPlayers()) do
						if isEnemy(plr) then
							local t = getTargetPart(plr.Character)
							if t then
								local d = (hrp.Position - t.Position).Magnitude
								if d <= reach then
									lastAuto = os.clock()
									pressAttack()
									break
								end
							end
						end
					end
				end
			end
		end
		task.wait(0.05)
	end
end)

--===========================================================================
-- COOLDOWN HUD (bottom center)
--===========================================================================
local cdGui = Instance.new("ScreenGui")
cdGui.Name = "HussCdHud"
cdGui.ResetOnSpawn = false
cdGui.IgnoreGuiInset = true
cdGui.DisplayOrder = 6
cdGui.Parent = lp.PlayerGui
table.insert(CleanupFns, function() pcall(function() cdGui:Destroy() end) end)

local cdRow = Instance.new("Frame")
cdRow.AnchorPoint = Vector2.new(0.5, 1)
cdRow.Position = UDim2.new(0.5, 0, 1, -70)
cdRow.Size = UDim2.fromOffset(430, 34)
cdRow.BackgroundTransparency = 1
cdRow.Parent = cdGui
local cdLayout = Instance.new("UIListLayout", cdRow)
cdLayout.FillDirection = Enum.FillDirection.Horizontal
cdLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
cdLayout.VerticalAlignment = Enum.VerticalAlignment.Center
cdLayout.Padding = UDim.new(0, 8)

local cdCells = {}
for _, name in ipairs({ "DASH", "TACKLE", "ABILITY", "GHOST", "CLONE", "GEAR" }) do
	local cell = Instance.new("Frame")
	cell.Size = UDim2.fromOffset(62, 32)
	cell.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
	cell.BackgroundTransparency = 0.35
	cell.Parent = cdRow
	Instance.new("UICorner", cell).CornerRadius = UDim.new(0, 8)
	local cap = Instance.new("TextLabel")
	cap.Size = UDim2.new(1, 0, 0, 13)
	cap.BackgroundTransparency = 1
	cap.Font = Enum.Font.Gotham
	cap.TextSize = 9
	cap.TextColor3 = Color3.fromRGB(170, 170, 185)
	cap.Text = name
	cap.Parent = cell
	local val = Instance.new("TextLabel")
	val.Size = UDim2.new(1, 0, 0, 18)
	val.Position = UDim2.new(0, 0, 0, 13)
	val.BackgroundTransparency = 1
	val.Font = Enum.Font.GothamBold
	val.TextSize = 13
	val.TextColor3 = Color3.fromRGB(120, 220, 130)
	val.Text = "OK"
	val.Parent = cell
	cdCells[name] = val
end

local CD_ATTRS = {
	DASH = { "DashCooldownUntil" },
	TACKLE = { "TackleReadyAt" },
	ABILITY = { "AbilityReadyAt" },
	GHOST = { "GhostAbilityReadyAt" },
	CLONE = { "CloneAbilityReadyAt" },
	GEAR = { "GearReadyAt" },
}

task.spawn(function()
	while true do
		if g.__HUSS_COMBAT_UNLOAD ~= unload then return end
		cdRow.Visible = CONFIG.CdHud.Enabled
		if CONFIG.CdHud.Enabled then
			local ch = lp.Character
			for name, val in pairs(cdCells) do
				local rem = math.huge
				if ch then
					for _, attr in ipairs(CD_ATTRS[name]) do
						local src = ch:GetAttribute(attr)
						if src == nil then src = lp:GetAttribute(attr) end
						rem = math.min(rem, remaining(src))
					end
				end
				if rem <= 0 then
					val.Text = "OK"
					val.TextColor3 = Color3.fromRGB(120, 220, 130)
				else
					val.Text = string.format("%.1f", rem)
					val.TextColor3 = Color3.fromRGB(255, 120, 110)
				end
			end
		end
		task.wait(0.1)
	end
end)

--===========================================================================
-- STATUS + ROLE-CHANGE NOTIFICATIONS
--===========================================================================
local lastRole = nil
task.spawn(function()
	while true do
		if g.__HUSS_COMBAT_UNLOAD ~= unload then return end
		local mine = myRole()
		local side = enemySideFor(mine)
		local threat = tonumber(lp:GetAttribute("CatcherThreatIntensity")) or 0
		local threatTxt = ("  |  threat: %d%%"):format(math.floor(threat * 100 + 0.5))
		if side then
			roleStatus:SetValue(("Role: %s -> targets: %s%s"):format(mine, side, threatTxt))
			roleStatus:SetStatus("Success")
		else
			roleStatus:SetValue(("Role: %s -> no targets%s"):format(mine, threatTxt))
			roleStatus:SetStatus("Warning")
		end

		local enemies = 0
		for _, plr in ipairs(Players:GetPlayers()) do
			if isEnemy(plr) then enemies += 1 end
		end
		enemyStatus:SetValue(tostring(enemies))
		enemyStatus:SetStatus(enemies > 0 and "Success" or "Neutral")

		dodgeStatus:SetValue(tostring(dodgesDone))

		if mine ~= lastRole then
			if lastRole ~= nil then
				pcall(function()
					UI.Notify:Push({
						Title = "Huss Combat",
						Content = "Role changed: " .. mine .. (side and (" — targets: " .. side) or " (no targets)"),
						Duration = 3,
					})
				end)
			end
			lastRole = mine
		end
		task.wait(0.4)
	end
end)

g.__HUSS_COMBAT_UNLOAD = unload

print("[huss] ready: Aimbot (Hold/Toggle/Always) / Triggerbot / ESP / Threat rings / Anti-Tackle / Auto-Tackle / CD HUD.")
print("[huss]TEST_OK")

return {
	CONFIG = CONFIG,
	unload = unload,
	stats = { getDodges = function() return dodgesDone end },
}
