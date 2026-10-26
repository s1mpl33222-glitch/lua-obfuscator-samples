-- This file was generated at discord.gg/syncrypt

local unpack_ = unpack or table.unpack

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local getgenv_ = getgenv

if getgenv_ then
	getgenv_ = getgenv().MalaphasUnload
end

if getgenv_ then
	pcall(getgenv().MalaphasUnload)
end

local t1 = {
	value1 = game:GetService("Players"),
	value2 = game:GetService("Workspace")
}

getgenv_ = game:GetService("RunService")

local game_ = game

t1.value3 = game_.GetService(game_, "UserInputService")
game_ = game
t1.value4 = game_.GetService(game_, "ContextActionService")
t1.value5 = game:GetService("TweenService")
t1.value6 = game:GetService("ReplicatedStorage")
t1.value7 = game:GetService("HttpService")
t1.value8 = game:GetService("TeleportService")
game_ = game
t1.value9 = game_.GetService(game_, "Lighting")
t1.value10 = game:GetService("SoundService")
t1.value11 = game:GetService("CoreGui")
t1.value12 = game:GetService("PathfindingService")
t1.value13 = t1.value1.LocalPlayer
t1.value14 = t1.value2.CurrentCamera
t1.value15 = true
t1.value16 = {}
t1.value17 = {}
t1.value18 = nil
t1.value19 = nil
game_ = function(p1)
	local setstackhidden_

	if typeof(p1) == "function" then
		setstackhidden_ = setstackhidden
	else
		setstackhidden_ = false
	end

	if not setstackhidden_ then
		return
	end

	pcall(setstackhidden, p1, true)
end
t1.value20 = "    task.spawn(function()\n        repeat task.wait(0.5) until game:IsLoaded()\n        local Players = game:GetService(\"Players\")\n        local lp = Players.LocalPlayer or Players:GetPropertyChangedSignal(\"LocalPlayer\"):Wait()\n        repeat task.wait(0.5) until lp.Character and lp.Character:FindFirstChild(\"HumanoidRootPart\")\n        task.wait(1.5)\n        local success, err = pcall(function()\n            if loadfile then\n                local f = loadfile(\"malaphas.luau\") or loadfile(\"Malaphas.luau\") or loadfile(\"rivals.luau\")\n                if f then f() end\n            end\n        end)\n    end)\n"

if queue_on_teleport then
	pcall(function()
		queue_on_teleport(t1.value20)
	end)
else
	v365 = syn

	if v365 then
		v365 = syn.queue_on_teleport
	end

	if v365 then
		pcall(function()
			syn.queue_on_teleport(t1.value20)
		end)
	end
end

t1.value13.OnTeleport:Connect(function(p2)
	if not (p2 == Enum.TeleportState.Started and true or p2 == Enum.TeleportState.InProgress) then
		return
	end

	if queue_on_teleport then
		pcall(function()
			queue_on_teleport(t1.value20)
		end)

		return
	end

	local syn_ = syn

	if syn_ then
		syn_ = syn.queue_on_teleport
	end

	if not syn_ then
		return
	end

	local function v7()
		syn.queue_on_teleport(t1.value20)
	end

	pcall(v7)
end)
t1.value21 = {
	Aimbot = false,
	TeamCheck = true,
	AimbotKey = Enum.UserInputType.MouseButton2,
	AimbotKeyMode = "Hold",
	AimbotPart = "Closest",
	AimbotSmoothing = 0.28,
	AimbotFOV = 120,
	AimbotVisibleOnly = true,
	AimbotScopeOnly = false,
	AimbotDisableReloading = true,
	ContinuousTargeting = true,
	InstantCameraLock = false,
	TrackThroughWalls = true,
	CorrectLockedShots = true,
	SilentAim = true,
	SilentKey = Enum.KeyCode.C,
	SilentKeyMode = "Always",
	SilentTargetPart = "Head",
	SilentFOV = 242,
	SilentHitChance = 78,
	SilentHeadChance = 59,
	SilentVisibleOnly = true,
	SilentVulnerableOnly = true,
	SilentIgnoreDeflecting = true,
	SilentIgnoreShielded = true,
	AutoRespawn = false,
	AutoQueue = false,
	QueueMode = "1v1",
	AutoVoteMaps = false,
	MapPriority = "Arena, Onyx, Crossroads",
	AutoBanWeapons = false,
	WeaponBanPriority = "Grenade Launcher, Minigun, RPG",
	SecondBanPriority = "Grenade Launcher, Minigun, RPG",
	AutoLoadout = true,
	LoadoutOnlySelected = false,
	EnabledMaps = "Arena, Crossroads",
	AntiAim = false,
	AntiAimMode = "Jitter",
	AntiAimSpeed = 10,
	HackerDetector = true,
	NotifyHackers = true,
	HackerAutoLoad = true,
	HackerProfile = "rage",
	SpeedThreshold = 180,
	SpeedDuration = 0.75,
	ModDetector = true,
	NotifyMods = true,
	MinGroupRank = 200,
	ModUsernames = "name1, name2",
	ModFriendList = "name1, name2",
	AutoPickup = false,
	PickupRadius = 25,
	ESP_Master = true,
	ESP_EnemyOnly = true,
	ESP_Lobby = true,
	ESP_MaxDistance = 500,
	ESP_Boxes = true,
	ESP_Names = true,
	ESP_Distance = true,
	ESP_HealthBar = true,
	ESP_Weapon = true,
	ESP_Tracers = false,
	ESP_Chams = false,
	ESP_Skeleton = true,
	ESP_HeadDot = true,
	ESP_Tripmines = true,
	ESP_FOV = true,
	TargetVisualizer = true,
	TargetVisualizerHUD = true,
	TargetVisualizerPath = true,
	VisualizerArrowSpacing = 10,
	VisualizerArrowSpeed = 14,
	SpeedHack = false,
	SpeedValue = 49,
	FlyHack = false,
	FlySpeed = 50,
	InfiniteJump = false,
	BunnyHop = false,
	Noclip = false,
	NoRecoil = true,
	NoSpread = true,
	FastReload = false,
	RapidFire = false,
	InstantEquip = false,
	AutomaticGuns = false,
	InfiniteAmmo = false,
	RainbowGunSkin = false,
	WeaponChams = false,
	CustomViewModelFOV = false,
	ViewModelFOVValue = 70,
	ViewModelXOffset = 0,
	ViewModelYOffset = 0,
	ViewModelZOffset = 0,
	HideViewModel = false,
	Fullbright = false,
	NoFog = true,
	CustomFOV = false,
	FOVValue = 90,
	BulletTracers = false,
	HitSound = "Skeet",
	ThirdPerson = false,
	ThirdPersonDist = 12,
	Freecam = false,
	FreecamSpeed = 40,
	MenuKey = Enum.KeyCode.RightControl,
	MobileToggle = false
}
t1.value22 = {
	OuterBorder = Color3.fromRGB(196, 28, 36),
	BorderPink = Color3.fromRGB(196, 28, 36),
	BorderPinkDark = Color3.fromRGB(128, 16, 22),
	WindowBg = Color3.fromRGB(11, 11, 12),
	WindowBgTop = Color3.fromRGB(18, 18, 20),
	WindowBgBottom = Color3.fromRGB(7, 7, 8),
	InnerCanvasBg = Color3.fromRGB(9, 9, 10),
	HeaderBg = Color3.fromRGB(15, 15, 17),
	CardBg = Color3.fromRGB(20, 20, 22),
	CardBgTop = Color3.fromRGB(29, 29, 32),
	CardBgBottom = Color3.fromRGB(13, 13, 15),
	BorderDark = Color3.fromRGB(38, 38, 42),
	BorderCard = Color3.fromRGB(47, 47, 52),
	AccentPink = Color3.fromRGB(216, 30, 38),
	AccentPinkLight = Color3.fromRGB(240, 70, 76),
	AccentPinkDark = Color3.fromRGB(160, 20, 26),
	AccentPinkDim = Color3.fromRGB(90, 14, 18),
	TextWhite = Color3.fromRGB(244, 243, 243),
	TextMuted = Color3.fromRGB(150, 150, 156),
	TextDark = Color3.fromRGB(100, 100, 106),
	ControlBg = Color3.fromRGB(9, 9, 10),
	ButtonBg = Color3.fromRGB(19, 19, 21),
	ButtonHoverBg = Color3.fromRGB(31, 31, 34),
	ButtonBorder = Color3.fromRGB(49, 49, 54),
	Red = Color3.fromRGB(216, 30, 38),
	Yellow = Color3.fromRGB(245, 195, 65),
	AccentGreen = Color3.fromRGB(216, 30, 38),
	AccentGreenLight = Color3.fromRGB(240, 70, 76),
	AccentGreenDark = Color3.fromRGB(160, 20, 26),
	AccentGreenDim = Color3.fromRGB(90, 14, 18)
}
t1.value23 = Enum.Font.RobotoMono
t1.value24 = Vector3.new(109, -680, 1184)

local function v8()
	local Character = t1.value13.Character

	if Character then
	elseif Character then
		return (Character.Position - t1.value24).Magnitude < 450
	else
		return false
	end

	Character = Character:FindFirstChild("HumanoidRootPart")

	if Character then
		return (Character.Position - t1.value24).Magnitude < 450
	else
		return false
	end
end

function t1.value25(p3)
	if not p3 then
		return false
	end

	if p3 == t1.value13 then
		return true
	end

	if t1.value21.TeamCheck == false then
		return false
	end

	local isPlayer, playerFromCharacter

	if typeof(p3) == "Instance" then
		isPlayer = p3:IsA("Player")

		if isPlayer then
			isPlayer = p3
			playerFromCharacter = isPlayer

			local v12 = isPlayer

			isPlayer = playerFromCharacter
			v12 = playerFromCharacter
		else
			local Character = t1.value13.Character

			if Character then
				Character = p3 == t1.value13.Character or p3:IsDescendantOf(t1.value13.Character)
			end

			if Character then
				return true
			end

			playerFromCharacter = t1.value1:GetPlayerFromCharacter(p3:IsA("Model") and p3 or p3:FindFirstAncestorOfClass("Model"))
		end
	else
		playerFromCharacter = nil
		isPlayer = nil
	end

	local Team

	if playerFromCharacter then
		Team = t1.value13.Team

		if Team then
			Team = playerFromCharacter.Team

			if Team then
				Team = t1.value13.Team == playerFromCharacter.Team
			end
		end
	else
		Team = playerFromCharacter
	end

	if Team then
		return true
	end

	if playerFromCharacter then
		local attribute = t1.value13:GetAttribute("TeamID") or t1.value13:GetAttribute("Team")
		local attribute2 = playerFromCharacter:GetAttribute("TeamID") or playerFromCharacter:GetAttribute("Team")
		local v17 = attribute ~= nil

		if v17 then
			v17 = attribute2 ~= nil

			if v17 then
				v17 = attribute == attribute2
			end
		end

		if v17 then
			return true
		end
	end

	if playerFromCharacter then
		playerFromCharacter = playerFromCharacter.Character
	end

	if not playerFromCharacter then
		playerFromCharacter = typeof(p3) == "Instance"

		if playerFromCharacter then
			playerFromCharacter = p3:IsA("Model") and p3 and p3 or p3:FindFirstAncestorOfClass("Model")
		end
	end

	local Character = t1.value13.Character

	if not (playerFromCharacter and Character) then
		return false
	end

	local attribute = Character:GetAttribute("TeamID") or Character:GetAttribute("Team")
	local attribute2 = playerFromCharacter.GetAttribute(playerFromCharacter, "TeamID") or playerFromCharacter:GetAttribute("Team")
	local v21 = attribute ~= nil

	if v21 then
	elseif v21 then
		return true
	elseif playerFromCharacter:FindFirstChild("TeammateLabel", true) or playerFromCharacter:FindFirstChild("AllyLabel", true) then
		return true
	else
		return false
	end

	v21 = attribute2 ~= nil

	if v21 then
	elseif v21 then
		return true
	elseif playerFromCharacter:FindFirstChild("TeammateLabel", true) or playerFromCharacter:FindFirstChild("AllyLabel", true) then
		return true
	else
		return false
	end

	v21 = attribute == attribute2

	if v21 then
		return true
	elseif playerFromCharacter:FindFirstChild("TeammateLabel", true) or playerFromCharacter:FindFirstChild("AllyLabel", true) then
		return true
	else
		return false
	end
end

game_(t1.value25)

local function v22(p4)
	if not p4 or p4 == t1.value13 then
		return false
	end

	local Character = t1.value13.Character

	if Character then
		Character = Character:FindFirstChild("HumanoidRootPart")
	end

	local v24

	if Character then
		v24 = (Character.Position - t1.value24).Magnitude < 450
	else
		v24 = false
	end

	if v24 then
		return t1.value21.ESP_Lobby == true
	end

	if t1.value25(p4) then
		return false
	end

	local ESP_EnemyOnly = t1.value21.ESP_EnemyOnly

	if not ESP_EnemyOnly then
		return not ESP_EnemyOnly
	end

	ESP_EnemyOnly = t1.value13.Team

	if not ESP_EnemyOnly then
		return not ESP_EnemyOnly
	end

	ESP_EnemyOnly = p4.Team

	if not ESP_EnemyOnly then
		return not ESP_EnemyOnly
	end

	ESP_EnemyOnly = t1.value13.Team == p4.Team

	return not ESP_EnemyOnly
end

game_(v22)
t1.value26 = Instance.new("ScreenGui")
t1.value26.Name = "MalaphasUI"
t1.value26.ResetOnSpawn = false
t1.value26.IgnoreGuiInset = true
t1.value26.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
t1.value26.DisplayOrder = 999
t1.value26.Parent = (function()
	if gethui then
		local ok, result = pcall(gethui)

		if ok and result then
			return result
		end
	end

	local function v28()
		return t1.value11
	end

	local ok, result = pcall(v28)

	return ok and result and result or (t1.value13:WaitForChild("PlayerGui", 5) or t1.value13:FindFirstChild("PlayerGui"))
end)()

local value17 = t1.value17
local value26 = t1.value26

table.insert(value17, value26)
value26 = function()
	t1.value15 = false

	local v33, v34, v35 = ipairs(t1.value16)

	while true do
		local v36

		v35, v36 = v33(v34, v35)

		if not v35 then
			break
		end

		pcall(function()
			v36:Disconnect()
		end)
	end

	table.clear(t1.value16)

	for _, v in ipairs(t1.value17) do
		pcall(function()
			v:Destroy()
		end)
	end

	table.clear(t1.value17)

	if t1.value19 then
		pcall(function()
			require(t1.value6.Modules.Utility).Raycast = t1.value19
		end)
	end

	pcall(function()
		t1.value4:UnbindAction("MalaphasMenuFreeze")
	end)

	local function v39()
		local PlayerScripts = t1.value13:FindFirstChild("PlayerScripts")

		if PlayerScripts then
			PlayerScripts = PlayerScripts:FindFirstChild("PlayerModule")
		end

		local controls = PlayerScripts and require(PlayerScripts):GetControls()

		if not controls then
			return
		end

		controls:Enable()
	end

	pcall(v39)
	pcall(function()
		t1.value3.MouseBehavior = Enum.MouseBehavior.Default

		local Character = t1.value13.Character

		if Character then
			Character = t1.value13.Character:FindFirstChild("HumanoidRootPart")
		end

		if not Character then
			return
		end

		t1.value13.Character.HumanoidRootPart.Anchored = false
	end)

	if not getgenv then
		return
	end

	getgenv().MalaphasUnload = nil
end

if getgenv then
	getgenv().MalaphasUnload = value26
end

t1.value27 = {}

function t1.value28()
	if not t1.value15 then
		return
	end

	local function v43()
		local ReplicatedStorage = game:GetService("ReplicatedStorage")
		local Modules = ReplicatedStorage:FindFirstChild("Modules")

		if Modules then
			Modules = ReplicatedStorage.Modules:FindFirstChild("ItemLibrary")
		end

		if not Modules then
			return
		end

		local module = require(Modules)
		local Items

		if module then
			Items = module.Items
		else
			Items = module
		end

		if not Items then
			return
		end

		for k, item in pairs(module.Items) do
			local v50

			if type(item) == "table" then
				v50 = item.ShootRecoil ~= nil
			else
				v50 = false
			end

			if v50 then
				if not t1.value27[k] then
					t1.value27[k] = {
						ShootRecoil = item.ShootRecoil,
						ShootSpread = item.ShootSpread,
						AimSpreadMultiplier = item.AimSpreadMultiplier,
						ShootSpreadPerVelocityUnit = item.ShootSpreadPerVelocityUnit,
						ShootSpreadPerVelocityLimit = item.ShootSpreadPerVelocityLimit,
						EquipCooldown = item.EquipCooldown,
						ReloadLength = item.ReloadLength,
						EmptyReloadLength = item.EmptyReloadLength,
						ReloadActionTimestamp = item.ReloadActionTimestamp,
						EmptyReloadActionTimestamp = item.EmptyReloadActionTimestamp,
						ShootCooldown = item.ShootCooldown,
						MaxAmmo = item.MaxAmmo,
						MaxAmmoReserve = item.MaxAmmoReserve
					}
				end

				local v51 = t1.value27[k]

				item.ShootRecoil = t1.value21.NoRecoil and 0 or v51.ShootRecoil
				item.ShootSpread = t1.value21.NoSpread and 0 or v51.ShootSpread
				item.AimSpreadMultiplier = t1.value21.NoSpread and 0 or v51.AimSpreadMultiplier
				item.ShootSpreadPerVelocityUnit = t1.value21.NoSpread and 0 or v51.ShootSpreadPerVelocityUnit
				item.ShootSpreadPerVelocityLimit = t1.value21.NoSpread and 0 or v51.ShootSpreadPerVelocityLimit
				item.EquipCooldown = t1.value21.InstantEquip and 0.01 or v51.EquipCooldown
				item.ReloadLength = t1.value21.FastReload and 0.05 or v51.ReloadLength
				item.EmptyReloadLength = t1.value21.FastReload and 0.05 or v51.EmptyReloadLength
				item.ReloadActionTimestamp = t1.value21.FastReload and 0.01 or v51.ReloadActionTimestamp
				item.EmptyReloadActionTimestamp = t1.value21.FastReload and 0.01 or v51.EmptyReloadActionTimestamp

				local s1 = "ShootCooldown"
				local RapidFire = t1.value21.RapidFire

				if RapidFire then
					RapidFire = v51.ShootCooldown * 0.4
				end

				item[s1] = RapidFire or v51.ShootCooldown

				if v51.MaxAmmo then
					item.MaxAmmo = t1.value21.InfiniteAmmo and 9999 or v51.MaxAmmo
				end

				if v51.MaxAmmoReserve then
					item.MaxAmmoReserve = t1.value21.InfiniteAmmo and 9999 or v51.MaxAmmoReserve
				end
			end
		end
	end

	pcall(v43)
end

t1.value29 = Instance.new("Frame")
t1.value29.Name = "DropdownOverlay"
t1.value29.Size = UDim2.new(1, 0, 1, 0)
t1.value29.BackgroundTransparency = 1
t1.value29.ZIndex = 1000
t1.value29.Parent = t1.value26
value17 = t1.value17

local value29 = t1.value29

table.insert(value17, value29)
t1.value30 = nil
value29 = t1.value3.InputBegan
value29.Connect(value29, function(p5)
	if not ((p5.UserInputType == Enum.UserInputType.MouseButton1 and true or p5.UserInputType == Enum.UserInputType.Touch) and t1.value30) then
		return
	end

	t1.value30(p5.Position)
end)
value29 = Instance.new("Frame")
value29.Name = "MalaphasWatermark"
value29.Size = UDim2.new(0, 275, 0, 22)
value29.Position = UDim2.new(1, -285, 0, 8)
value29.BackgroundColor3 = t1.value22.CardBg
value29.BorderSizePixel = 0
value29.ZIndex = 90
value29.Parent = t1.value26
value17 = t1.value17
table.insert(value17, value29)
value17 = Instance.new("UIGradient")
value17.Rotation = 90
value17.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, t1.value22.CardBgTop), ColorSequenceKeypoint.new(1, t1.value22.CardBgBottom) })
value17.Parent = value29
value17 = Instance.new("UIStroke")
value17.Color = t1.value22.BorderCard
value17.Thickness = 1
value17.Parent = value29
value17 = Instance.new("Frame")
value17.Size = UDim2.new(1, 0, 0, 1.5)
value17.BackgroundColor3 = t1.value22.AccentPink
value17.BorderSizePixel = 0
value17.ZIndex = 91
value17.Parent = value29

local UIGradient = Instance.new("UIGradient")

UIGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, t1.value22.AccentPinkLight), ColorSequenceKeypoint.new(1, t1.value22.AccentPinkDark) })
UIGradient.Parent = value17
t1.value31 = Instance.new("TextLabel")
t1.value31.Size = UDim2.new(1, -12, 1, -2)
t1.value31.Position = UDim2.new(0, 8, 0, 2)
t1.value31.BackgroundTransparency = 1
t1.value31.Font = t1.value23
t1.value31.RichText = true
t1.value31.Text = "<b>M</b>  |  <font color=\"#d81e26\">malaphas</font>  |  60 fps  |  0 ms"
t1.value31.TextColor3 = t1.value22.TextWhite
t1.value31.TextSize = 10.5
t1.value31.TextXAlignment = Enum.TextXAlignment.Left
t1.value31.ZIndex = 92
t1.value31.Parent = value29
t1.value32 = Instance.new("Frame")
t1.value32.Name = "NotifContainer"
t1.value32.Size = UDim2.new(0, 260, 1, -40)
t1.value32.Position = UDim2.new(1, -275, 0, 36)
t1.value32.BackgroundTransparency = 1
t1.value32.ZIndex = 100
t1.value32.Parent = t1.value26
UIGradient = t1.value17
value29 = t1.value32
table.insert(UIGradient, value29)
UIGradient = Instance.new("UIListLayout")
UIGradient.SortOrder = Enum.SortOrder.LayoutOrder
UIGradient.VerticalAlignment = Enum.VerticalAlignment.Bottom
UIGradient.Padding = UDim.new(0, 5)
UIGradient.Parent = t1.value32

function t1.value33(p6, p7, p8, p9)
	if not t1.value15 then
		return
	end

	local function v56()
		if not (t1.value32 and t1.value32.Parent) then
			return
		end

		p9 = p9 or 3.5
		p8 = p8 or "INFO"

		local AccentGreen = t1.value22.AccentGreen

		if p8 == "SUCCESS" then
			AccentGreen = t1.value22.AccentGreenLight
		elseif p8 == "WARN" then
			AccentGreen = t1.value22.Yellow
		elseif p8 == "ERROR" then
			AccentGreen = t1.value22.Red
		end

		local Frame = Instance.new("Frame")

		Frame.Size = UDim2.new(1, 0, 0, 0)
		Frame.BackgroundColor3 = t1.value22.CardBg
		Frame.BorderSizePixel = 0
		Frame.ClipsDescendants = true
		Frame.ZIndex = 101
		Frame.Parent = t1.value32

		local UIStroke = Instance.new("UIStroke")

		UIStroke.Color = t1.value22.BorderDark
		UIStroke.Thickness = 1
		UIStroke.Parent = Frame

		local Frame2 = Instance.new("Frame")

		Frame2.Size = UDim2.new(1, 0, 0, 1.5)
		Frame2.BackgroundColor3 = AccentGreen
		Frame2.BorderSizePixel = 0
		Frame2.ZIndex = 102
		Frame2.Parent = Frame

		local TextLabel = Instance.new("TextLabel")

		TextLabel.Size = UDim2.new(1, -14, 0, 15)
		TextLabel.Position = UDim2.new(0, 8, 0, 3)
		TextLabel.BackgroundTransparency = 1
		TextLabel.Font = t1.value23
		TextLabel.Text = p6
		TextLabel.TextColor3 = t1.value22.AccentGreen
		TextLabel.TextSize = 11.5
		TextLabel.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel.ZIndex = 102
		TextLabel.Parent = Frame

		local TextLabel2 = Instance.new("TextLabel")

		TextLabel2.Size = UDim2.new(1, -14, 0, 22)
		TextLabel2.Position = UDim2.new(0, 8, 0, 18)
		TextLabel2.BackgroundTransparency = 1
		TextLabel2.Font = t1.value23
		TextLabel2.Text = p7
		TextLabel2.TextColor3 = t1.value22.TextWhite
		TextLabel2.TextSize = 10
		TextLabel2.TextWrapped = true
		TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel2.ZIndex = 102
		TextLabel2.Parent = Frame

		local value5 = t1.value5
		local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

		value5.Create(value5, Frame, tweenInfo, {
			Size = UDim2.new(1, 0, 0, 46)
		}):Play()
		task.delay(p9, function()
			local Parent = Frame

			if Parent then
				Parent = Frame.Parent
			end

			if not Parent then
				return
			end

			local value52 = t1.value5
			local v67 = Frame
			local tweenInfoNew = TweenInfo.new
			local Quart = Enum.EasingStyle.Quart
			local EasingDirection = Enum.EasingDirection
			local v71 = value52.Create(value52, v67, tweenInfoNew(0.18, Quart, EasingDirection.In), {
				Size = UDim2.new(1, 0, 0, 0)
			})

			v71:Play()
			v71.Completed:Connect(function()
				Frame:Destroy()
			end)
		end)
	end

	pcall(v56)
end

t1.value34 = {
	hudFrame = nil,
	hudTitle = nil,
	hudAvatar = nil,
	hudName = nil,
	hudHpFill = nil,
	visualizerFolder = nil,
	poolLines = {},
	poolChevrons = {},
	cachedWaypoints = {},
	lastTargetUserId = nil,
	activeRoot = nil,
	activeChar = nil,
	activeHum = nil,
	activePlayer = nil,
	cachedEnemies = {},
	lastEnemyUpdateTime = 0,
	targetCache = {},
	staticRayParams = nil,
	lastFullbrightCheck = 0,
	lastNoFogCheck = 0,
	lastPathMyPos = nil,
	lastPathActPos = nil
}
(function()
	local Frame = Instance.new("Frame")

	Frame.Name = "TargetHUD"
	Frame.Size = UDim2.new(0, 310, 0, 72)
	Frame.Position = UDim2.new(0.5, -155, 1, -125)
	Frame.BackgroundColor3 = Color3.fromRGB(15, 18, 15)
	Frame.BorderSizePixel = 0
	Frame.Visible = false
	Frame.ZIndex = 80
	Frame.Parent = t1.value26

	local value172 = t1.value17

	table.insert(value172, Frame)
	t1.value34.hudFrame = Frame

	local UIStroke = Instance.new("UIStroke")

	UIStroke.Color = Color3.fromRGB(45, 55, 45)
	UIStroke.Thickness = 1.2
	UIStroke.Parent = Frame

	local Frame2 = Instance.new("Frame")

	Frame2.Size = UDim2.new(1, 0, 0, 2.5)
	Frame2.BackgroundColor3 = Color3.fromRGB(195, 255, 30)
	Frame2.BorderSizePixel = 0
	Frame2.ZIndex = 81
	Frame2.Parent = Frame

	local TextLabel = Instance.new("TextLabel")

	TextLabel.Size = UDim2.new(1, -20, 0, 18)
	TextLabel.Position = UDim2.new(0, 10, 0, 4)
	TextLabel.BackgroundTransparency = 1
	TextLabel.Font = t1.value23
	TextLabel.Text = "Target  -  150/150"
	TextLabel.TextColor3 = t1.value22.TextWhite
	TextLabel.TextSize = 14
	TextLabel.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel.ZIndex = 82
	TextLabel.Parent = Frame
	t1.value34.hudTitle = TextLabel

	local ImageLabel = Instance.new("ImageLabel")

	ImageLabel.Size = UDim2.new(0, 42, 0, 42)
	ImageLabel.Position = UDim2.new(0, 10, 0, 24)
	ImageLabel.BackgroundColor3 = Color3.fromRGB(20, 24, 20)
	ImageLabel.BorderSizePixel = 0
	ImageLabel.ZIndex = 82
	ImageLabel.Parent = Frame
	t1.value34.hudAvatar = ImageLabel

	local UIStroke2 = Instance.new("UIStroke")

	UIStroke2.Color = Color3.fromRGB(195, 255, 30)
	UIStroke2.Thickness = 1.2
	UIStroke2.Parent = ImageLabel

	local TextLabel2 = Instance.new("TextLabel")

	TextLabel2.Size = UDim2.new(1, -68, 0, 18)
	TextLabel2.Position = UDim2.new(0, 60, 0, 24)
	TextLabel2.BackgroundTransparency = 1
	TextLabel2.Font = t1.value23
	TextLabel2.Text = "Player (@username)"
	TextLabel2.TextColor3 = t1.value22.TextWhite
	TextLabel2.TextSize = 13
	TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel2.TextTruncate = Enum.TextTruncate.AtEnd
	TextLabel2.ZIndex = 82
	TextLabel2.Parent = Frame
	t1.value34.hudName = TextLabel2

	local Frame3 = Instance.new("Frame")

	Frame3.Size = UDim2.new(1, -68, 0, 8)
	Frame3.Position = UDim2.new(0, 60, 0, 48)
	Frame3.BackgroundColor3 = Color3.fromRGB(28, 34, 28)
	Frame3.BorderSizePixel = 0
	Frame3.ZIndex = 82
	Frame3.Parent = Frame

	local UICorner = Instance.new("UICorner")

	UICorner.CornerRadius = UDim.new(0, 2)
	UICorner.Parent = Frame3

	local Frame4 = Instance.new("Frame")

	Frame4.Size = UDim2.new(1, 0, 1, 0)
	Frame4.BackgroundColor3 = Color3.fromRGB(195, 255, 30)
	Frame4.BorderSizePixel = 0
	Frame4.ZIndex = 83
	Frame4.Parent = Frame3
	t1.value34.hudHpFill = Frame4

	local UICorner2 = Instance.new("UICorner")

	UICorner2.CornerRadius = UDim.new(0, 2)
	UICorner2.Parent = Frame4

	local Folder = Instance.new("Folder")

	Folder.Name = "MalaphasTargetVisualizer"
	Folder.Parent = t1.value2

	local value173 = t1.value17

	table.insert(value173, Folder)
	t1.value34.visualizerFolder = Folder

	for i = 1, 40 do
		local Part = Instance.new("Part")

		Part.Name = "VisLine_" .. i
		Part.Anchored = true
		Part.CanCollide = false
		Part.CanTouch = false
		Part.CanQuery = false
		Part.CastShadow = false
		Part.Material = Enum.Material.Neon
		Part.Color = Color3.fromRGB(195, 255, 30)
		Part.Transparency = 1
		Part.Size = Vector3.new(0.18, 0.06, 1)
		Part.Parent = Folder

		local poolLines = t1.value34.poolLines

		table.insert(poolLines, Part)
	end

	for i = 1, 30 do
		local Part = Instance.new("Part")

		Part.Name = "ChevL_" .. i
		Part.Anchored = true
		Part.CanCollide = false
		Part.CanTouch = false
		Part.CanQuery = false
		Part.CastShadow = false
		Part.Material = Enum.Material.Neon
		Part.Color = Color3.fromRGB(195, 255, 30)
		Part.Transparency = 1
		Part.Size = Vector3.new(0.22, 0.08, 1.2)
		Part.Parent = Folder

		local Part2 = Instance.new("Part")

		Part2.Name = "ChevR_" .. i
		Part2.Anchored = true
		Part2.CanCollide = false
		Part2.CanTouch = false
		Part2.CanQuery = false
		Part2.CastShadow = false
		Part2.Material = Enum.Material.Neon
		Part2.Color = Color3.fromRGB(195, 255, 30)
		Part2.Transparency = 1
		Part2.Size = Vector3.new(0.22, 0.08, 1.2)
		Part2.Parent = Folder

		local poolChevrons = t1.value34.poolChevrons

		table.insert(poolChevrons, {
			Left = Part,
			Right = Part2
		})
	end
end)()
t1.value35 = Instance.new("Frame")
t1.value35.Name = "MainWindow"
t1.value35.Size = UDim2.new(0, 480, 0, 500)
t1.value35.Position = UDim2.new(0.5, -240, 0.5, -250)
t1.value35.BackgroundColor3 = t1.value22.WindowBg
t1.value35.BorderSizePixel = 0
t1.value35.ClipsDescendants = false
t1.value35.Active = true
t1.value35.ZIndex = 10
t1.value35.Parent = t1.value26
UIGradient = t1.value17
value29 = t1.value35
table.insert(UIGradient, value29)
t1.value36 = nil
t1.value37 = nil
t1.value38 = {
	enabled = false,
	rotX = 0,
	rotY = 0,
	pos = Vector3.zero
}
t1.value39 = 0
t1.value40 = 0

function t1.value41()
	local Character = t1.value13.Character

	if not Character then
		return false
	end

	local v94, v95, v96 = ipairs(Character:GetChildren())

	while true do
		local v97

		v96, v97 = v94(v95, v96)

		if not v96 then
			break
		end

		if v97:IsA("Tool") then
			return true
		end
	end

	local ViewModels = t1.value2:FindFirstChild("ViewModels")

	if ViewModels then
		ViewModels = ViewModels:FindFirstChild("FirstPerson")
	end

	local v99

	if ViewModels then
		v99 = #ViewModels:GetChildren() > 0
	else
		v99 = ViewModels
	end

	if not v99 then
		return false
	end

	for _, child in ipairs(ViewModels.GetChildren(ViewModels)) do
		if child:IsA("Model") or child:IsA("BasePart") then
			return true
		end
	end

	return false
end
function t1.value42(p10)
	pcall(function()
		local PlayerScripts = t1.value13:FindFirstChild("PlayerScripts")

		if PlayerScripts then
			PlayerScripts = PlayerScripts:FindFirstChild("PlayerModule")
		end

		local controls = PlayerScripts and require(PlayerScripts):GetControls()

		if not controls then
			return
		end

		if p10 then
			controls:Enable()

			return
		end

		controls:Disable()
	end)
end
function t1.value43(p11)
	t1.value35.Visible = p11

	if p11 then
		t1.value36 = t1.value14.CFrame
		t1.value37 = t1.value14.FieldOfView
		t1.value3.MouseBehavior = Enum.MouseBehavior.Default
		t1.value3.MouseIconEnabled = true
		t1.value42(false)

		local Character = t1.value13.Character

		if Character then
			Character = Character:FindFirstChild("HumanoidRootPart")
		end

		if Character then
			local vector3New = Vector3.new
			local Y = Character.AssemblyLinearVelocity.Y

			Character.AssemblyLinearVelocity = vector3New(0, math.min(Y, 0), 0)
		end

		local function v107()
			t1.value4:BindActionAtPriority("MalaphasMenuFreeze", function()
				return Enum.ContextActionResult.Sink
			end, false, Enum.ContextActionPriority.High.Value + 5000, Enum.UserInputType.MouseMovement, Enum.UserInputType.Touch, Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D, Enum.KeyCode.Space, Enum.KeyCode.LeftShift, Enum.KeyCode.LeftControl, Enum.KeyCode.Up, Enum.KeyCode.Down, Enum.KeyCode.Left, Enum.KeyCode.Right)
		end

		pcall(v107)
	else
		t1.value36 = nil
		t1.value37 = nil
		t1.value42(true)
		pcall(function()
			t1.value4:UnbindAction("MalaphasMenuFreeze")
		end)
	end
end

UIGradient = Instance.new("UIStroke")
UIGradient.Color = t1.value22.OuterBorder
UIGradient.Thickness = 1
UIGradient.Parent = t1.value35
UIGradient = Instance.new("UIGradient")
UIGradient.Rotation = 90
UIGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, t1.value22.WindowBgTop), ColorSequenceKeypoint.new(1, t1.value22.WindowBgBottom) })
UIGradient.Parent = t1.value35
UIGradient = Instance.new("Frame")
UIGradient.Name = "TopBar"
UIGradient.Size = UDim2.new(1, 0, 0, 32)
UIGradient.BackgroundColor3 = t1.value22.HeaderBg
UIGradient.BorderSizePixel = 0
UIGradient.ZIndex = 11
UIGradient.Parent = t1.value35
t1.value44 = false
t1.value45 = nil
t1.value46 = nil
UIGradient.InputBegan:Connect(function(input)
	if not (input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch) then
		return
	end

	t1.value44 = true
	t1.value45 = input.Position
	t1.value46 = t1.value35.Position
	input.Changed:Connect(function()
		if input.UserInputState ~= Enum.UserInputState.End then
			return
		end

		t1.value44 = false
	end)
end)
t1.value3.InputChanged:Connect(function(input)
	local value44 = t1.value44

	if value44 then
		value44 = input.UserInputType == Enum.UserInputType.MouseMovement and true or input.UserInputType == Enum.UserInputType.Touch
	end

	if not value44 then
		return
	end

	local v109 = input.Position - t1.value45

	t1.value35.Position = UDim2.new(t1.value46.X.Scale, t1.value46.X.Offset + v109.X, t1.value46.Y.Scale, t1.value46.Y.Offset + v109.Y)
end)
t1.value47 = Instance.new("Frame")
t1.value47.Name = "MalaphasLogo"
t1.value47.Size = UDim2.new(0, 16, 0, 18)
t1.value47.Position = UDim2.new(0, 10, 0.5, -9)
t1.value47.BackgroundTransparency = 1
t1.value47.ZIndex = 12
t1.value47.Parent = UIGradient
value29 = function(p12, p13, p14, p15)
	local Frame = Instance.new("Frame")

	Frame.Size = p12
	Frame.Position = p13
	Frame.BackgroundColor3 = p14
	Frame.BorderSizePixel = 0
	Frame.ZIndex = p15
	Frame.Parent = t1.value47

	return Frame
end
value29(UDim2.new(0, 3, 0, 17), UDim2.new(0, 0, 0, 1), t1.value22.AccentPinkLight, 13)
value29(UDim2.new(0, 3, 0, 17), UDim2.new(0, 13, 0, 1), t1.value22.AccentPinkLight, 13)
value29(UDim2.new(0, 3, 0, 10), UDim2.new(0, 3, 0, 1), t1.value22.AccentPink, 14)
value29(UDim2.new(0, 3, 0, 10), UDim2.new(0, 10, 0, 1), t1.value22.AccentPink, 14)
value29(UDim2.new(0, 2, 0, 8), UDim2.new(0, 7, 0, 9), t1.value22.AccentPinkDark, 14)
value29 = Instance.new("TextLabel")
value29.Size = UDim2.new(0, 220, 1, 0)
value29.Position = UDim2.new(0, 34, 0, 0)
value29.BackgroundTransparency = 1
value29.Font = t1.value23
value29.RichText = true
value29.Text = "<font color=\"#ffffff\">MALAPHAS</font> <font color=\"#d81e26\">RIVALS</font>"
value29.TextSize = 14
value29.TextXAlignment = Enum.TextXAlignment.Left
value29.ZIndex = 13
value29.Parent = UIGradient
t1.value48 = Instance.new("TextBox")
t1.value48.Size = UDim2.new(0, 105, 0, 19)
t1.value48.Position = UDim2.new(1, -135, 0.5, -9.5)
t1.value48.BackgroundColor3 = t1.value22.ControlBg
t1.value48.BorderSizePixel = 0
t1.value48.Font = t1.value23
t1.value48.PlaceholderText = "Search..."
t1.value48.PlaceholderColor3 = t1.value22.TextDark
t1.value48.Text = ""
t1.value48.TextColor3 = t1.value22.TextWhite
t1.value48.TextSize = 11
t1.value48.ZIndex = 12
t1.value48.Parent = UIGradient
value29 = Instance.new("UIPadding")
value29.PaddingLeft = UDim.new(0, 6)
value29.Parent = t1.value48
t1.value49 = Instance.new("UIStroke")
t1.value49.Color = t1.value22.BorderDark
t1.value49.Thickness = 1
t1.value49.Parent = t1.value48
t1.value48.Focused:Connect(function()
	t1.value49.Color = t1.value22.BorderPink
end)
t1.value48.FocusLost:Connect(function()
	t1.value49.Color = t1.value22.BorderDark
end)
t1.value50 = Instance.new("TextButton")
t1.value50.Name = "CloseButton"
t1.value50.Size = UDim2.new(0, 20, 0, 19)
t1.value50.Position = UDim2.new(1, -26, 0.5, -9.5)
t1.value50.BackgroundColor3 = t1.value22.ControlBg
t1.value50.BorderSizePixel = 0
t1.value50.Font = t1.value23
t1.value50.Text = "×"
t1.value50.TextColor3 = t1.value22.TextMuted
t1.value50.TextSize = 14
t1.value50.ZIndex = 12
t1.value50.Parent = UIGradient
t1.value51 = Instance.new("UIStroke")
t1.value51.Color = t1.value22.BorderDark
t1.value51.Thickness = 1
t1.value51.Parent = t1.value50
t1.value50.MouseEnter:Connect(function()
	t1.value50.TextColor3 = t1.value22.AccentPinkLight
	t1.value51.Color = t1.value22.BorderPink
end)
t1.value50.MouseLeave:Connect(function()
	t1.value50.TextColor3 = t1.value22.TextMuted
	t1.value51.Color = t1.value22.BorderDark
end)
t1.value50.MouseButton1Click:Connect(function()
	t1.value43(false)
end)
UIGradient = Instance.new("Frame")
UIGradient.Name = "InnerCanvas"
UIGradient.Size = UDim2.new(1, -14, 1, -40)
UIGradient.Position = UDim2.new(0, 7, 0, 33)
UIGradient.BackgroundColor3 = t1.value22.InnerCanvasBg
UIGradient.BorderSizePixel = 0
UIGradient.ZIndex = 11
UIGradient.Parent = t1.value35
value29 = Instance.new("UIStroke")
value29.Color = t1.value22.BorderDark
value29.Thickness = 1
value29.Parent = UIGradient
value29 = Instance.new("Frame")
value29.Name = "TabNavFrame"
value29.Size = UDim2.new(1, -12, 0, 22)
value29.Position = UDim2.new(0, 6, 0, 4)
value29.BackgroundTransparency = 1
value29.ZIndex = 12
value29.Parent = UIGradient
value17 = Instance.new("UIListLayout")
value17.FillDirection = Enum.FillDirection.Horizontal
value17.HorizontalAlignment = Enum.HorizontalAlignment.Left
value17.VerticalAlignment = Enum.VerticalAlignment.Center
value17.SortOrder = Enum.SortOrder.LayoutOrder
value17.Padding = UDim.new(0, 8)
value17.Parent = value29
value17 = Instance.new("UIPadding")
value17.PaddingLeft = UDim.new(0, 4)
value17.Parent = value29
value17 = Instance.new("Frame")
value17.Name = "TabContentFrame"
value17.Size = UDim2.new(1, -12, 1, -54)
value17.Position = UDim2.new(0, 6, 0, 30)
value17.BackgroundTransparency = 1
value17.ZIndex = 12
value17.Parent = UIGradient

local Frame = Instance.new("Frame")

Frame.Name = "StatusBar"
Frame.Size = UDim2.new(1, -12, 0, 18)
Frame.Position = UDim2.new(0, 6, 1, -20)
Frame.BackgroundTransparency = 1
Frame.ZIndex = 12
Frame.Parent = UIGradient
UIGradient = Instance.new("Frame")
UIGradient.Size = UDim2.new(1, 0, 0, 1)
UIGradient.Position = UDim2.new(0, 0, 0, 0)
UIGradient.BackgroundColor3 = t1.value22.BorderDark
UIGradient.BorderSizePixel = 0
UIGradient.ZIndex = 12
UIGradient.Parent = Frame
UIGradient = Instance.new("TextLabel")
UIGradient.Size = UDim2.new(0.6, 0, 1, -2)
UIGradient.Position = UDim2.new(0, 2, 0, 2)
UIGradient.BackgroundTransparency = 1
UIGradient.Font = t1.value23
UIGradient.RichText = true
UIGradient.Text = "welcome back, <font color=\"#d81e26\">" .. t1.value13.DisplayName .. "</font>"
UIGradient.TextColor3 = t1.value22.TextMuted
UIGradient.TextSize = 10.5
UIGradient.TextXAlignment = Enum.TextXAlignment.Left
UIGradient.ZIndex = 13
UIGradient.Parent = Frame
UIGradient = Instance.new("TextLabel")
UIGradient.Size = UDim2.new(0.4, -2, 1, -2)
UIGradient.Position = UDim2.new(0.6, 0, 0, 2)
UIGradient.BackgroundTransparency = 1
UIGradient.Font = t1.value23
UIGradient.RichText = true
UIGradient.Text = "<font color=\"#d81e26\">[</font> <font color=\"#888894\">rivals</font> <font color=\"#d81e26\">]</font>"
UIGradient.TextColor3 = t1.value22.TextMuted
UIGradient.TextSize = 10.5
UIGradient.TextXAlignment = Enum.TextXAlignment.Right
UIGradient.ZIndex = 13
UIGradient.Parent = Frame
t1.value52 = {
	"home",
	"aim",
	"auto",
	"esp",
	"move",
	"guns",
	"world",
	"view",
	"config"
}
t1.value53 = {}
t1.value54 = {}
t1.value55 = "home"

function t1.value56(p16)
	t1.value55 = p16

	local v112, v113, v114 = pairs(t1.value53)
	local _ = p16

	while true do
		local v116

		v114, v116 = v112(v113, v114)

		if not v114 then
			break
		end

		v116.Visible = v114 == p16
	end

	for _, v in ipairs(t1.value54) do
		local visible = v.name == p16
		local btn = v.btn
		local s2 = "TextColor3"
		local AccentPinkLight

		if visible then
			AccentPinkLight = t1.value22.AccentPinkLight
		else
			AccentPinkLight = visible
		end

		btn[s2] = AccentPinkLight or t1.value22.TextMuted

		if v.indicator then
			v.indicator.Visible = visible
		end
	end
end

for i, v in ipairs(t1.value52) do
	local TextButton = Instance.new("TextButton")

	TextButton.Name = "TabBtn_" .. v
	TextButton.LayoutOrder = i
	TextButton.Size = UDim2.new(0, 0, 1, 0)
	TextButton.AutomaticSize = Enum.AutomaticSize.X
	TextButton.BackgroundTransparency = 1
	TextButton.Font = t1.value23
	TextButton.Text = v:sub(1, 1):upper() .. v:sub(2)
	i = "TextColor3"

	if v == t1.value55 then
		v170 = t1.value22.AccentPinkLight
	else
		v170 = false
	end

	TextButton[i] = v170 or t1.value22.TextMuted
	TextButton.TextSize = 12
	TextButton.AutoButtonColor = false
	TextButton.ZIndex = 13
	TextButton.Parent = value29
	v170 = Instance.new("UIPadding")
	v170.PaddingLeft = UDim.new(0, 4)
	v170.PaddingRight = UDim.new(0, 4)
	v170.Parent = TextButton
	v170 = Instance.new("Frame")
	v170.Size = UDim2.new(1, -4, 0, 1.5)
	v170.Position = UDim2.new(0, 2, 1, -1)
	v170.BackgroundColor3 = t1.value22.AccentPink
	v170.BorderSizePixel = 0
	v170.Visible = v == t1.value55
	v170.ZIndex = 14
	v170.Parent = TextButton
	i = Instance.new("UIGradient")
	i.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, t1.value22.AccentPinkLight), ColorSequenceKeypoint.new(1, t1.value22.AccentPinkDark) })
	i.Parent = v170
	TextButton.MouseEnter:Connect(function()
		if v == t1.value55 then
			return
		end

		TextButton.TextColor3 = t1.value22.TextWhite
	end)
	TextButton.MouseLeave:Connect(function()
		if v == t1.value55 then
			return
		end

		TextButton.TextColor3 = t1.value22.TextMuted
	end)
	TextButton.MouseButton1Click:Connect(function()
		t1.value56(v)
	end)
	table.insert(t1.value54, {
		name = v,
		btn = TextButton,
		indicator = v170
	})
	v170 = Instance.new("Frame")
	v170.Name = "Page_" .. v
	v170.Size = UDim2.new(1, 0, 1, 0)
	v170.BackgroundTransparency = 1
	v170.Visible = v == t1.value55
	v170.ZIndex = 13
	v170.Parent = value17
	i = Instance.new("ScrollingFrame")
	i.Name = "LeftCol"
	i.Size = UDim2.new(0.49, 0, 1, 0)
	i.Position = UDim2.new(0, 0, 0, 0)
	i.BackgroundTransparency = 1
	i.BorderSizePixel = 0
	i.ScrollBarThickness = 0
	i.AutomaticCanvasSize = Enum.AutomaticSize.Y
	i.ZIndex = 14
	i.Parent = v170
	v781 = Instance.new("UIListLayout")
	v781.Padding = UDim.new(0, 7)
	v781.Parent = i
	v781 = Instance.new("ScrollingFrame")
	v781.Name = "RightCol"
	v781.Size = UDim2.new(0.49, 0, 1, 0)
	v781.Position = UDim2.new(0.51, 0, 0, 0)
	v781.BackgroundTransparency = 1
	v781.BorderSizePixel = 0
	v781.ScrollBarThickness = 0
	v781.AutomaticCanvasSize = Enum.AutomaticSize.Y
	v781.ZIndex = 14
	v781.Parent = v170
	i = Instance.new("UIListLayout")
	i.Padding = UDim.new(0, 7)
	i.Parent = v781
	t1.value53[v] = v170
end

local function v126(p17, p18, p19, p20, p21)
	local Frame2 = Instance.new("Frame")

	Frame2.Size = UDim2.new(1, 0, 0, 33)
	Frame2.BackgroundTransparency = 1
	Frame2.ZIndex = 16
	Frame2.Parent = p17

	local TextLabel = Instance.new("TextLabel")

	TextLabel.Size = UDim2.new(1, 0, 0, 12)
	TextLabel.BackgroundTransparency = 1
	TextLabel.Font = t1.value23
	TextLabel.Text = p18
	TextLabel.TextColor3 = t1.value22.TextMuted
	TextLabel.TextSize = 11.5
	TextLabel.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel.ZIndex = 17
	TextLabel.Parent = Frame2

	local TextBox = Instance.new("TextBox")

	TextBox.Size = UDim2.new(1, 0, 0, 19)
	TextBox.Position = UDim2.new(0, 0, 0, 13)
	TextBox.BackgroundColor3 = t1.value22.ControlBg
	TextBox.BorderSizePixel = 0
	TextBox.Font = t1.value23
	TextBox.PlaceholderText = p20 or ""
	TextBox.PlaceholderColor3 = t1.value22.TextDark
	TextBox.Text = p19 or ""
	TextBox.TextColor3 = t1.value22.TextWhite
	TextBox.TextSize = 12
	TextBox.TextXAlignment = Enum.TextXAlignment.Left
	TextBox.ZIndex = 17
	TextBox.Parent = Frame2

	local UIPadding = Instance.new("UIPadding")

	UIPadding.PaddingLeft = UDim.new(0, 6)
	UIPadding.Parent = TextBox

	local UIStroke = Instance.new("UIStroke")

	UIStroke.Color = t1.value22.BorderDark
	UIStroke.Thickness = 1
	UIStroke.Parent = TextBox
	TextBox.Focused:Connect(function()
		UIStroke.Color = t1.value22.BorderPink
	end)
	TextBox.FocusLost:Connect(function()
		UIStroke.Color = t1.value22.BorderDark

		local v132 = p21

		if type(v132) ~= "function" then
			return
		end

		p21(TextBox.Text)
	end)

	return {
		Set = function(p22)
			TextBox.Text = tostring(p22)

			local v133 = p21

			if type(v133) ~= "function" then
				return
			end

			p21(TextBox.Text)
		end,
		Get = function()
			return TextBox.Text
		end
	}
end
local function createFrame(p23, p24, p25, p26)
	local Frame2 = Instance.new("Frame")

	Frame2.Size = UDim2.new(1, -2, 0, 0)
	Frame2.AutomaticSize = Enum.AutomaticSize.Y
	Frame2.BackgroundColor3 = t1.value22.CardBg
	Frame2.BorderSizePixel = 0
	Frame2.ZIndex = 15
	Frame2.Parent = p23

	local UIGradient2 = Instance.new("UIGradient")

	UIGradient2.Rotation = 90
	UIGradient2.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, t1.value22.CardBgTop), ColorSequenceKeypoint.new(1, t1.value22.CardBgBottom) })
	UIGradient2.Parent = Frame2

	local UIStroke = Instance.new("UIStroke")

	UIStroke.Color = t1.value22.BorderCard
	UIStroke.Thickness = 1
	UIStroke.Parent = Frame2

	local Frame3 = Instance.new("Frame")

	Frame3.Name = "TopAccentLine"
	Frame3.Size = UDim2.new(1, 0, 0, 1.5)
	Frame3.Position = UDim2.new(0, 0, 0, 0)
	Frame3.BackgroundColor3 = t1.value22.AccentPink
	Frame3.BorderSizePixel = 0
	Frame3.ZIndex = 16
	Frame3.Parent = Frame2

	local UIGradient3 = Instance.new("UIGradient")

	UIGradient3.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, t1.value22.AccentPinkLight), ColorSequenceKeypoint.new(1, t1.value22.AccentPinkDark) })
	UIGradient3.Parent = Frame3

	local Frame4 = Instance.new("Frame")

	Frame4.Name = "Header"
	Frame4.Size = UDim2.new(1, 0, 0, p25 and 32 or 20)
	Frame4.Position = UDim2.new(0, 0, 0, 1)
	Frame4.BackgroundTransparency = 1
	Frame4.ZIndex = 16
	Frame4.Parent = Frame2

	local TextLabel = Instance.new("TextLabel")

	TextLabel.Name = "TitleLabel"
	TextLabel.Size = UDim2.new(1, -12, 0, 16)
	TextLabel.Position = UDim2.new(0, 6, 0, 2)
	TextLabel.BackgroundTransparency = 1
	TextLabel.Font = t1.value23
	TextLabel.Text = p24
	TextLabel.TextColor3 = t1.value22.TextWhite
	TextLabel.TextSize = 12.5
	TextLabel.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel.ZIndex = 17
	TextLabel.Parent = Frame4

	if p25 then
		local TextLabel2 = Instance.new("TextLabel")

		TextLabel2.Size = UDim2.new(1, -12, 0, 14)
		TextLabel2.Position = UDim2.new(0, 6, 0, 17)
		TextLabel2.BackgroundTransparency = 1
		TextLabel2.Font = t1.value23
		TextLabel2.Text = p25
		TextLabel2.TextColor3 = t1.value22.TextMuted
		TextLabel2.TextSize = 10.5
		TextLabel2.TextWrapped = true
		TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel2.ZIndex = 17
		TextLabel2.Parent = Frame4
	end

	local Frame5 = Instance.new("Frame")

	Frame5.Name = "Content"
	Frame5.Size = UDim2.new(1, -12, 0, 0)
	Frame5.Position = UDim2.new(0, 6, 0, p25 and 34 or 22)
	Frame5.AutomaticSize = Enum.AutomaticSize.Y
	Frame5.BackgroundTransparency = 1
	Frame5.ZIndex = 16
	Frame5.Parent = Frame2

	local UIListLayout = Instance.new("UIListLayout")

	UIListLayout.Padding = UDim.new(0, 6)
	UIListLayout.Parent = Frame5

	local UIPadding = Instance.new("UIPadding")

	UIPadding.PaddingBottom = UDim.new(0, p26 and 3 or 7)
	UIPadding.Parent = Frame5

	if not p26 then
		return Frame5
	end

	local TextLabel2 = Instance.new("TextLabel")

	TextLabel2.Size = UDim2.new(1, 0, 0, 22)
	TextLabel2.BackgroundTransparency = 1
	TextLabel2.Font = t1.value23
	TextLabel2.Text = p26
	TextLabel2.TextColor3 = t1.value22.TextDark
	TextLabel2.TextSize = 10
	TextLabel2.TextWrapped = true
	TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel2.ZIndex = 17
	TextLabel2.Parent = Frame5

	return Frame5
end
local function v147(p27, p28, p29, p30)
	local u148 = p29 or false
	local Frame2 = Instance.new("Frame")

	Frame2.Size = UDim2.new(1, 0, 0, 16)
	Frame2.BackgroundTransparency = 1
	Frame2.ZIndex = 16
	Frame2.Parent = p27

	local TextButton = Instance.new("TextButton")

	TextButton.Size = UDim2.new(0, 13, 0, 13)
	TextButton.Position = UDim2.new(0, 0, 0.5, -6.5)

	if u148 then
		local AccentPink = t1.value22.AccentPink
	end

	TextButton.BackgroundColor3 = v178 or t1.value22.ControlBg
	TextButton.BorderSizePixel = 0
	TextButton.Text = ""
	TextButton.ZIndex = 17
	TextButton.Parent = Frame2

	local UIStroke = Instance.new("UIStroke")

	if u148 then
		local AccentPinkLight = t1.value22.AccentPinkLight
	end

	UIStroke.Color = v180 or t1.value22.BorderDark
	UIStroke.Thickness = 1
	UIStroke.Parent = TextButton

	local TextLabel = Instance.new("TextLabel")

	TextLabel.Size = UDim2.new(1, -20, 1, 0)
	TextLabel.Position = UDim2.new(0, 20, 0, 0)
	TextLabel.BackgroundTransparency = 1
	TextLabel.Font = t1.value23
	TextLabel.Text = p28
	TextLabel.TextColor3 = t1.value22.TextWhite
	TextLabel.TextSize = 12
	TextLabel.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel.ZIndex = 17
	TextLabel.Parent = Frame2

	local function v155(p31)
		u148 = p31
		TextButton.BackgroundColor3 = u148 and t1.value22.AccentPink or t1.value22.ControlBg

		local v156 = UIStroke
		local AccentPinkLight = u148

		if AccentPinkLight then
			AccentPinkLight = t1.value22.AccentPinkLight
		end

		v156.Color = AccentPinkLight or t1.value22.BorderDark

		local v158 = p30

		if type(v158) ~= "function" then
			return
		end

		p30(u148)
	end

	TextButton.MouseButton1Click:Connect(function()
		v155(not u148)
	end)

	return {
		Set = v155,
		Get = function()
			return u148
		end
	}
end

t1.value57 = nil
Frame = function(p32, p33, p34, p35, p36)
	local u159 = p34
	local u160 = p35 or 1
	local u161 = false
	local Frame2 = Instance.new("Frame")

	Frame2.Size = UDim2.new(1, 0, 0, 34)
	Frame2.BackgroundTransparency = 1
	Frame2.ZIndex = 16
	Frame2.Parent = p32

	local TextLabel = Instance.new("TextLabel")

	TextLabel.Size = UDim2.new(1, 0, 0, 13)
	TextLabel.BackgroundTransparency = 1
	TextLabel.Font = t1.value23
	TextLabel.Text = p33
	TextLabel.TextColor3 = t1.value22.TextMuted
	TextLabel.TextSize = 11.5
	TextLabel.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel.ZIndex = 17
	TextLabel.Parent = Frame2

	local TextButton = Instance.new("TextButton")

	TextButton.Size = UDim2.new(1, 0, 0, 20)
	TextButton.Position = UDim2.new(0, 0, 0, 14)
	TextButton.BackgroundColor3 = t1.value22.ControlBg
	TextButton.BorderSizePixel = 0
	TextButton.Font = t1.value23
	TextButton.Text = "  " .. u159[u160]
	TextButton.TextColor3 = t1.value22.TextWhite
	TextButton.TextSize = 11.5
	TextButton.TextXAlignment = Enum.TextXAlignment.Left
	TextButton.ZIndex = 17
	TextButton.Parent = Frame2

	local UIStroke = Instance.new("UIStroke")

	UIStroke.Color = t1.value22.BorderDark
	UIStroke.Thickness = 1
	UIStroke.Parent = TextButton

	local TextLabel2 = Instance.new("TextLabel")

	TextLabel2.Size = UDim2.new(0, 14, 1, 0)
	TextLabel2.Position = UDim2.new(1, -16, 0, 0)
	TextLabel2.BackgroundTransparency = 1
	TextLabel2.Font = Enum.Font.GothamBold
	TextLabel2.Text = "▼"
	TextLabel2.TextColor3 = t1.value22.AccentPink
	TextLabel2.TextSize = 8.5
	TextLabel2.ZIndex = 18
	TextLabel2.Parent = TextButton

	local ScrollingFrame = Instance.new("ScrollingFrame")

	ScrollingFrame.Name = "DropdownMenu_" .. p33:gsub("%s+", "")
	ScrollingFrame.BackgroundColor3 = t1.value22.CardBg
	ScrollingFrame.BorderSizePixel = 0
	ScrollingFrame.ScrollBarThickness = 2.5
	ScrollingFrame.ScrollBarImageColor3 = t1.value22.AccentPink
	ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	ScrollingFrame.ZIndex = 1001
	ScrollingFrame.Visible = false
	ScrollingFrame.Parent = t1.value29

	local UIStroke2 = Instance.new("UIStroke")

	UIStroke2.Color = t1.value22.BorderPinkDark
	UIStroke2.Thickness = 1
	UIStroke2.Parent = ScrollingFrame

	local UIGradient2 = Instance.new("UIGradient")

	UIGradient2.Rotation = 90
	UIGradient2.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, t1.value22.CardBgTop), ColorSequenceKeypoint.new(1, t1.value22.CardBgBottom) })
	UIGradient2.Parent = ScrollingFrame

	local UIListLayout = Instance.new("UIListLayout")

	UIListLayout.Padding = UDim.new(0, 1)
	UIListLayout.Parent = ScrollingFrame

	local function v171()
		u161 = false
		ScrollingFrame.Visible = false
		TextLabel2.Text = "▼"
		UIStroke.Color = t1.value22.BorderDark

		if t1.value30 ~= v171 then
			return
		end

		t1.value30 = nil
	end
	local function v172()
		local v173 = ScrollingFrame
		local v174, v175, v176 = ipairs(v173.GetChildren(v173))

		while true do
			local v177

			v176, v177 = v174(v175, v176)

			if not v176 then
				break
			end

			if v177:IsA("TextButton") then
				v177:Destroy()
			end
		end

		for i, v in ipairs(u159) do
			local TextButton2 = Instance.new("TextButton")

			TextButton2.Size = UDim2.new(1, 0, 0, 20)

			local s3 = "BackgroundColor3"
			local ButtonBg

			if i == u160 then
				ButtonBg = t1.value22.ButtonBg
			else
				ButtonBg = false
			end

			TextButton2[s3] = ButtonBg or Color3.fromRGB(0, 0, 0)
			TextButton2.BackgroundTransparency = i == u160 and 0 or 1
			TextButton2.BorderSizePixel = 0
			TextButton2.Font = t1.value23
			TextButton2.Text = "  " .. v

			local s4 = "TextColor3"
			local AccentPinkLight

			if i == u160 then
				AccentPinkLight = t1.value22.AccentPinkLight
			else
				AccentPinkLight = false
			end

			TextButton2[s4] = AccentPinkLight or t1.value22.TextWhite
			TextButton2.TextSize = 11.5
			TextButton2.TextXAlignment = Enum.TextXAlignment.Left
			TextButton2.ZIndex = 1002
			TextButton2.Parent = ScrollingFrame
			TextButton2.MouseEnter:Connect(function()
				if i == u160 then
					return
				end

				TextButton2.BackgroundTransparency = 0.5
				TextButton2.BackgroundColor3 = t1.value22.ButtonHoverBg
			end)
			TextButton2.MouseLeave:Connect(function()
				if i == u160 then
					return
				end

				TextButton2.BackgroundTransparency = 1
			end)
			TextButton2.MouseButton1Click:Connect(function()
				u160 = i
				TextButton.Text = "  " .. v
				v171()

				local v185 = p36

				if type(v185) ~= "function" then
					return
				end

				p36(v, i)
			end)
		end
	end
	local function v186()
		local value30 = t1.value30

		if value30 then
			value30 = t1.value30 ~= v171
		end

		if not value30 then
			v172()
			v221 = TextButton.AbsolutePosition
			v222 = TextButton.AbsoluteSize
			v223 = #u159 * 21
			v224 = math.min(v223, 140)
			ScrollingFrame.Position = UDim2.new(0, v221.X, 0, v221.Y + v222.Y + 2)
			ScrollingFrame.Size = UDim2.new(0, v222.X, 0, v224)
			ScrollingFrame.Visible = true
			u161 = true
			TextLabel2.Text = "▲"
			UIStroke.Color = t1.value22.BorderPink

			return
		end

		t1.value30()
		v172()

		local AbsolutePosition = TextButton.AbsolutePosition
		local AbsoluteSize = TextButton.AbsoluteSize
		local v190 = #u159 * 21
		local v191 = math.min(v190, 140)

		ScrollingFrame.Position = UDim2.new(0, AbsolutePosition.X, 0, AbsolutePosition.Y + AbsoluteSize.Y + 2)
		ScrollingFrame.Size = UDim2.new(0, AbsoluteSize.X, 0, v191)
		ScrollingFrame.Visible = true
		u161 = true
		TextLabel2.Text = "▲"
		UIStroke.Color = t1.value22.BorderPink
	end

	TextButton.MouseButton1Click:Connect(function()
		if u161 then
			v171()
		else
			v186()
		end
	end)

	return {
		Set = function(p37)
			local n1 = 1

			if type(p37) == "number" then
				local v193 = #u159

				n1 = math.clamp(p37, 1, v193)
			else
				if type(p37) ~= "string" then
					u160 = n1
					TextButton.Text = "  " .. u159[u160]
					v231 = p36

					if type(v231) ~= "function" then
						return
					end

					p36(u159[u160], u160)

					return
				end

				for i, v in ipairs(u159) do
					if v == p37 then
						n1 = i

						break
					end
				end
			end

			u160 = n1
			TextButton.Text = "  " .. u159[u160]

			local v196 = p36

			if type(v196) ~= "function" then
				return
			end

			p36(u159[u160], u160)
		end,
		SetOptions = function(p38, p39)
			u159 = p38

			local n2 = 1

			if type(p39) == "number" then
				local v198 = #u159

				n2 = math.clamp(p39, 1, v198)
			else
				if type(p39) ~= "string" then
					u160 = n2
					TextButton.Text = "  " .. (u159[u160] or "None")

					return
				end

				for i, v in ipairs(u159) do
					if v == p39 then
						n2 = i

						break
					end
				end
			end

			u160 = n2
			TextButton.Text = "  " .. (u159[u160] or "None")
		end,
		Get = function()
			return u159[u160]
		end
	}
end
UIGradient = function(p40, p41, p42, p43, p44, p45, p46)
	local u201 = p44 or p42
	local Frame2 = Instance.new("Frame")

	Frame2.Size = UDim2.new(1, 0, 0, 28)
	Frame2.BackgroundTransparency = 1
	Frame2.ZIndex = 16
	Frame2.Parent = p40

	local TextLabel = Instance.new("TextLabel")

	TextLabel.Size = UDim2.new(1, 0, 0, 12)
	TextLabel.BackgroundTransparency = 1
	TextLabel.Font = t1.value23
	TextLabel.Text = p41
	TextLabel.TextColor3 = t1.value22.TextMuted
	TextLabel.TextSize = 11.5
	TextLabel.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel.ZIndex = 17
	TextLabel.Parent = Frame2

	local TextButton = Instance.new("TextButton")

	TextButton.Size = UDim2.new(1, 0, 0, 14)
	TextButton.Position = UDim2.new(0, 0, 0, 13)
	TextButton.BackgroundColor3 = t1.value22.ControlBg
	TextButton.BorderSizePixel = 0
	TextButton.Text = ""
	TextButton.AutoButtonColor = false
	TextButton.ZIndex = 17
	TextButton.Parent = Frame2

	local UIStroke = Instance.new("UIStroke")

	UIStroke.Color = t1.value22.BorderDark
	UIStroke.Thickness = 1
	UIStroke.Parent = TextButton

	local Frame3 = Instance.new("Frame")
	local v207 = (u201 - p42) / (p43 - p42)
	local v208 = math.clamp(v207, 0, 1)

	Frame3.Size = UDim2.new(v208, 0, 1, 0)
	Frame3.BackgroundColor3 = t1.value22.AccentPink
	Frame3.BorderSizePixel = 0
	Frame3.ZIndex = 18
	Frame3.Parent = TextButton

	local UIGradient2 = Instance.new("UIGradient")

	UIGradient2.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, t1.value22.AccentPinkLight), ColorSequenceKeypoint.new(1, t1.value22.AccentPinkDark) })
	UIGradient2.Parent = Frame3

	local n3 = 0
	local v211

	if p45 then
		local match = p45:match("%%%.(%d+)f")

		if match then
			v211 = tonumber(match)
		else
			v211 = p45:find("%%f") and 2 or n3
		end
	else
		v211 = (p42 % 1 ~= 0 or p43 % 1 ~= 0 or u201 % 1 ~= 0) and 2 or n3
	end

	local function v213(p47)
		if v211 > 0 then
			local math_ = math
			local v215 = 10 ^ v211
			local clamp = math_.clamp
			local v217 = p47 * v215 + 0.5

			return clamp(math.floor(v217) / v215, p42, p43)
		else
			local clamp = math.clamp
			local v219 = p47 + 0.5

			return clamp(math.floor(v219), p42, p43)
		end
	end

	local TextLabel2 = Instance.new("TextLabel")

	TextLabel2.Size = UDim2.new(1, 0, 1, 0)
	TextLabel2.BackgroundTransparency = 1
	TextLabel2.Font = t1.value23

	local text

	if p45 then
		text = string.format(p45, u201, p43)
	else
		text = tostring(u201)
	end

	TextLabel2.Text = text
	TextLabel2.TextColor3 = t1.value22.TextWhite
	TextLabel2.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	TextLabel2.TextStrokeTransparency = 0.3
	TextLabel2.TextSize = 10.5
	TextLabel2.ZIndex = 19
	TextLabel2.Parent = TextButton

	local u222 = false

	local function v225(p48)
		local v226 = (p48.Position.X - TextButton.AbsolutePosition.X) / TextButton.AbsoluteSize.X
		local v227 = math.clamp(v226, 0, 1)

		u201 = v213(p42 + (p43 - p42) * v227)

		local v228 = (u201 - p42) / (p43 - p42)
		local v229 = math.clamp(v228, 0, 1)

		Frame3.Size = UDim2.new(v229, 0, 1, 0)

		local v230 = TextLabel2
		local v232 = u201
		local text2

		if p45 then
			text2 = string.format(p45, v232, p43)
		else
			text2 = tostring(v232)
		end

		v230.Text = text2

		local v233 = p46

		if type(v233) ~= "function" then
			return
		end

		p46(u201)
	end

	TextButton.InputBegan:Connect(function(input)
		if not (input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		u222 = true
		v225(input)
	end)
	t1.value3.InputEnded:Connect(function(input)
		if not (input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		u222 = false
	end)
	t1.value3.InputChanged:Connect(function(input)
		local v234 = u222

		if v234 then
			v234 = input.UserInputType == Enum.UserInputType.MouseMovement and true or input.UserInputType == Enum.UserInputType.Touch
		end

		if not v234 then
			return
		end

		v225(input)
	end)

	return {
		Set = function(p49)
			u201 = v213(tonumber(p49) or u201)

			local v235 = (u201 - p42) / (p43 - p42)
			local v236 = math.clamp(v235, 0, 1)

			Frame3.Size = UDim2.new(v236, 0, 1, 0)

			local v237 = TextLabel2
			local v238 = u201
			local text2

			if p45 then
				text2 = string.format(p45, v238, p43)
			else
				text2 = tostring(v238)
			end

			v237.Text = text2

			local v239 = p46

			if type(v239) ~= "function" then
				return
			end

			p46(u201)
		end
	}
end

function t1.value58()
	if mouse1click then
		pcall(mouse1click)

		return
	end

	local mouse1press_ = mouse1press

	if mouse1press_ then
		mouse1press_ = mouse1release
	end

	if mouse1press_ then
		pcall(function()
			mouse1press()
			task.wait(0.01)
			mouse1release()
		end)
	else
		local VirtualInputManager = game:GetService("VirtualInputManager")

		if not VirtualInputManager then
			return
		end

		local ViewportSize = t1.value14 and t1.value14.ViewportSize or Vector2.new(1280, 720)
		local v242 = ViewportSize.X * 0.5
		local v243 = math.floor(v242)
		local v244 = math.floor(ViewportSize.Y * 0.5)
		local TouchEnabled = t1.value3.TouchEnabled

		if TouchEnabled then
			TouchEnabled = not t1.value3.MouseEnabled

			if TouchEnabled then
				TouchEnabled = VirtualInputManager.SendTouchEvent
			end
		end

		if TouchEnabled then
			pcall(function()
				VirtualInputManager:SendTouchEvent(0, 0, v243, v244)
				task.wait(0.01)
				VirtualInputManager:SendTouchEvent(0, 2, v243, v244)
			end)
		else
			if not VirtualInputManager.SendMouseButtonEvent then
				return
			end

			pcall(function()
				VirtualInputManager:SendMouseButtonEvent(v243, v244, 0, true, t1.value2, 0)
				task.wait(0.01)
				VirtualInputManager:SendMouseButtonEvent(v243, v244, 0, false, t1.value2, 0)
			end)
		end
	end
end

game_(t1.value58)
t1.value59 = nil
t1.value59 = {}
t1.value57 = false

function t1.value60(p50)
	if t1.value57 then
		return
	end

	t1.value21.TeamCheck = p50

	for _, v in ipairs({ "AimbotTeamCheck", "SilentTeamCheck" }) do
		local Set = t1.value59[v]

		if Set then
			Set = t1.value59[v].Set

			if Set then
				Set = t1.value59[v].Get() ~= p50
			end
		end

		if Set then
			local function v249()
				t1.value59[v].Set(p50)
			end

			pcall(v249)
		end
	end

	t1.value57 = false
end

game_(t1.value60)
value29 = function(p51, p52, p53)
	local TextButton = Instance.new("TextButton")

	TextButton.Size = UDim2.new(1, 0, 0, 22)
	TextButton.BackgroundColor3 = t1.value22.ButtonBg
	TextButton.BorderSizePixel = 0
	TextButton.Font = t1.value23
	TextButton.Text = p52
	TextButton.TextColor3 = t1.value22.TextWhite
	TextButton.TextSize = 12
	TextButton.AutoButtonColor = false
	TextButton.ZIndex = 17
	TextButton.Parent = p51

	local UIStroke = Instance.new("UIStroke")

	UIStroke.Color = t1.value22.ButtonBorder
	UIStroke.Thickness = 1
	UIStroke.Parent = TextButton
	TextButton.MouseEnter:Connect(function()
		TextButton.BackgroundColor3 = t1.value22.ButtonHoverBg
		UIStroke.Color = t1.value22.BorderPinkDark
	end)
	TextButton.MouseLeave:Connect(function()
		TextButton.BackgroundColor3 = t1.value22.ButtonBg
		UIStroke.Color = t1.value22.ButtonBorder
	end)
	TextButton.MouseButton1Click:Connect(function()
		local v252 = p53

		if type(v252) ~= "function" then
			return
		end

		p53()
	end)

	return TextButton
end

function t1.value61()
	local now = tick()
	local v254

	if now - t1.value34.lastEnemyUpdateTime < 0.15 then
		v254 = #t1.value34.cachedEnemies > 0
	else
		v254 = false
	end

	if v254 then
		return t1.value34.cachedEnemies
	end

	table.clear(t1.value34.cachedEnemies)

	local Character = t1.value13.Character
	local v256, v257, cachedEnemies, cachedEnemies2

	if not Character then
		if Character then
			v256 = (Character.Position - t1.value24).Magnitude < 450
		else
			v256 = false
		end

		v315 = ipairs
		v316 = t1.value1

		for _, player in v315(v316.GetPlayers(v316)) do
			if player == t1.value13 then
				v257 = false
			else
				v257 = player.Character
			end

			if v257 then
				if v256 then
					if t1.value21.ESP_Lobby or t1.value21.TargetVisualizer then
						cachedEnemies = t1.value34.cachedEnemies
						table.insert(cachedEnemies, player)
					end
				elseif v22(player) then
					cachedEnemies2 = t1.value34.cachedEnemies
					table.insert(cachedEnemies2, player)
				end
			end
		end

		t1.value34.lastEnemyUpdateTime = now

		return t1.value34.cachedEnemies
	end

	Character = Character:FindFirstChild("HumanoidRootPart")

	if Character then
		v256 = (Character.Position - t1.value24).Magnitude < 450
	else
		v256 = false
	end

	local ipairs_ = ipairs
	local value1 = t1.value1

	for _, player in ipairs_(value1.GetPlayers(value1)) do
		if player == t1.value13 then
			v257 = false
		else
			v257 = player.Character
		end

		if v257 then
			if v256 then
				if t1.value21.ESP_Lobby or t1.value21.TargetVisualizer then
					cachedEnemies = t1.value34.cachedEnemies
					table.insert(cachedEnemies, player)
				end
			elseif v22(player) then
				cachedEnemies2 = t1.value34.cachedEnemies
				table.insert(cachedEnemies2, player)
			end
		end
	end

	t1.value34.lastEnemyUpdateTime = now

	return t1.value34.cachedEnemies
end
function t1.value62(p54, p55, p56, p57)
	local now = tick()
	local v267 = tostring(p54) .. "_" .. tostring(p55) .. "_" .. tostring(p56) .. "_" .. tostring(p57)
	local v268 = t1.value34.targetCache[v267]
	local v269

	if v268 then
		v269 = now - v268.time < 0.06

		if v269 then
			v269 = v268.target

			if v269 then
				v269 = v268.target.Parent
			end
		end
	else
		v269 = v268
	end

	if v269 then
		return v268.target
	end

	if not t1.value34.staticRayParams then
		local raycastParams = RaycastParams.new()

		raycastParams.FilterType = Enum.RaycastFilterType.Exclude
		raycastParams.IgnoreWater = true
		t1.value34.staticRayParams = raycastParams
	end

	local v271 = nil
	local huge = math.huge
	local mouseLocation = t1.value3:GetMouseLocation()
	local Character = t1.value13.Character
	local HumanoidRootPart

	if Character then
		HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
	else
		HumanoidRootPart = Character
	end

	local Position = t1.value14.CFrame.Position
	local LookVector = t1.value14.CFrame.LookVector
	local v278 = p54 == nil or p54 >= 999

	t1.value34.staticRayParams.FilterDescendantsInstances = { Character, t1.value14 }

	for _, v in ipairs(t1.value61()) do
		local Character2 = v.Character
		local Humanoid

		if Character2 then
			Humanoid = Character2:FindFirstChildOfClass("Humanoid")
		else
			Humanoid = Character2
		end

		local HumanoidRootPart2

		if Character2 then
			HumanoidRootPart2 = Character2:FindFirstChild("HumanoidRootPart")
		else
			HumanoidRootPart2 = Character2
		end

		local v284

		if Character2 then
			if Humanoid then
				if Humanoid.Health > 0 then
					v284 = HumanoidRootPart2
				else
					v284 = false
				end
			else
				v284 = Humanoid
			end
		else
			v284 = Character2
		end

		if v284 and (v278 or (HumanoidRootPart2.Position - Position):Dot(LookVector) > -5) then
			local attribute = Character2:GetAttribute("Deflecting") or (Character2:FindFirstChild("Deflect") or Character2:FindFirstChild("KatanaDeflect"))
			local attribute2 = Character2:GetAttribute("Shielded") or (Character2.FindFirstChild(Character2, "Shield") or Character2:FindFirstChild("EnergyShield"))
			local attribute3 = Character2:GetAttribute("SpawnImmunity") or Character2:FindFirstChildOfClass("ForceField")
			local v288, v289

			if t1.value25(v) or t1.value25(Character2) then
				v288 = true
				v289 = true
			else
				v288 = false
				v289 = false
			end

			local v290 = t1.value21.SilentIgnoreDeflecting and attribute and true or v288
			local v291 = t1.value21.SilentIgnoreShielded and attribute2 and true or v290

			if not (t1.value21.SilentVulnerableOnly and attribute3 or v291) then
				local HitboxHead = Character2.FindFirstChild(Character2, "Head") or Character2:FindFirstChild("HitboxHead")
				local UpperTorso = Character2:FindFirstChild("UpperTorso") or HumanoidRootPart2

				if p56 == "Head" then
					HitboxHead = HitboxHead or UpperTorso
				elseif p56 == "Body" then
					HitboxHead = UpperTorso or HitboxHead
				elseif p56 == "Closest" and (HitboxHead and UpperTorso) then
					local v294, v295 = t1.value14:WorldToViewportPoint(HitboxHead.Position)
					local v296, v297 = t1.value14:WorldToViewportPoint(UpperTorso.Position)

					if v295 and v297 then
						local v298 = (Vector2.new(v294.X, v294.Y) - mouseLocation).Magnitude <= (Vector2.new(v296.X, v296.Y) - mouseLocation).Magnitude

						HitboxHead = v298 and HitboxHead or UpperTorso
					elseif not v295 then
						if v297 then
							HitboxHead = UpperTorso
						end
					end
				else
					HitboxHead = HitboxHead or UpperTorso
				end

				if HitboxHead then
					local v299 = false
					local huge2 = math.huge
					local Magnitude

					if v278 then
						local Magnitude2

						if HumanoidRootPart then
							Magnitude2 = (HitboxHead.Position - HumanoidRootPart.Position).Magnitude
						else
							Magnitude2 = HumanoidRootPart
						end

						Magnitude = Magnitude2 or (HitboxHead.Position - Position).Magnitude

						if Magnitude <= (p54 or math.huge) then
							v299 = true

							if p57 == "Health" then
								Magnitude = Humanoid.Health
							end
						else
							Magnitude = huge2
						end
					else
						local v303, v304 = t1.value14:WorldToViewportPoint(HitboxHead.Position)

						if v304 then
							v304 = v303.Z > 0
						end

						if v304 then
							Magnitude = (Vector2.new(v303.X, v303.Y) - mouseLocation).Magnitude

							if Magnitude <= (p54 or math.huge) then
								v299 = true

								if p57 == "Health" then
									Magnitude = Humanoid.Health
								else
									local v305

									if p57 == "Distance" then
										v305 = HumanoidRootPart
									else
										v305 = false
									end

									if v305 then
										Magnitude = (HitboxHead.Position - HumanoidRootPart.Position).Magnitude
									end
								end
							else
								Magnitude = huge2
							end
						else
							Magnitude = huge2
						end
					end

					if v299 then
						v299 = Magnitude < huge
					end

					if v299 then
						if p55 then
							local v306 = HitboxHead.Position - Position
							local hit = t1.value2:Raycast(Position, v306, t1.value34.staticRayParams)

							if not hit or hit.Instance:IsDescendantOf(Character2) then
								v271 = HitboxHead
								huge = Magnitude
							end
						else
							v271 = HitboxHead
							huge = Magnitude
						end
					end
				end
			end
		end
	end

	t1.value34.targetCache[v267] = {
		target = v271,
		time = now
	}

	return v271
end

value17 = t1.value53.home
game_ = value17:FindFirstChild("LeftCol")
value17 = value17:FindFirstChild("RightCol")

local account = createFrame(game_, "Account")
local TextLabel = Instance.new("TextLabel")

TextLabel.Size = UDim2.new(1, 0, 0, 16)
TextLabel.BackgroundTransparency = 1
TextLabel.Font = t1.value23
TextLabel.Text = t1.value13.Name
TextLabel.TextColor3 = t1.value22.TextWhite
TextLabel.TextSize = 12.5
TextLabel.TextXAlignment = Enum.TextXAlignment.Left
TextLabel.ZIndex = 17
TextLabel.Parent = account
TextLabel = Instance.new("TextLabel")
TextLabel.Size = UDim2.new(1, 0, 0, 16)
TextLabel.BackgroundTransparency = 1
TextLabel.Font = t1.value23
TextLabel.Text = "(@" .. t1.value13.DisplayName .. ")"
TextLabel.TextColor3 = t1.value22.TextMuted
TextLabel.TextSize = 12
TextLabel.TextXAlignment = Enum.TextXAlignment.Left
TextLabel.ZIndex = 17
TextLabel.Parent = account
TextLabel = createFrame(game_, "Build")
account = Instance.new("TextLabel")
account.Size = UDim2.new(1, 0, 0, 16)
account.BackgroundTransparency = 1
account.Font = t1.value23
account.Text = "MALAPHAS v1.0 build"
account.TextColor3 = t1.value22.TextWhite
account.TextSize = 12.5
account.TextXAlignment = Enum.TextXAlignment.Left
account.ZIndex = 17
account.Parent = TextLabel
TextLabel = createFrame(value17, "Current Session")
account = Instance.new("TextLabel")
account.Size = UDim2.new(1, 0, 0, 16)
account.BackgroundTransparency = 1
account.Font = t1.value23
account.Text = "Player: " .. t1.value13.Name
account.TextColor3 = t1.value22.TextWhite
account.TextSize = 12.5
account.TextXAlignment = Enum.TextXAlignment.Left
account.ZIndex = 17
account.Parent = TextLabel
t1.value63 = Instance.new("TextLabel")
t1.value63.Size = UDim2.new(1, 0, 0, 16)
t1.value63.BackgroundTransparency = 1
t1.value63.Font = t1.value23
t1.value63.Text = "0 ms - " .. #t1.value1:GetPlayers() .. " players"
t1.value63.TextColor3 = t1.value22.TextWhite
t1.value63.TextSize = 12.5
t1.value63.TextXAlignment = Enum.TextXAlignment.Left
t1.value63.ZIndex = 17
t1.value63.Parent = TextLabel
TextLabel = createFrame(value17, "Session")
value29(TextLabel, "Rejoin server", function()
	t1.value33("MALAPHAS", "Reconnecting to experience...", "INFO", 3)
	task.spawn(function()
		task.wait(0.5)

		local function v310()
			t1.value8:Teleport(17625359962, t1.value13)
		end

		pcall(v310)
	end)
end)
value29(TextLabel, "Join lowest-ping server", function()
	t1.value33("MALAPHAS", "Searching for lowest-ping public server...", "INFO", 3)
	task.spawn(function()
		local n4 = 17625359962
		local HttpService = game:GetService("HttpService")
		local v313 = string.format("https://games.roblox.com/v1/games/%d/servers/0?sortOrder=2&excludeFullGames=true&limit=25", n4)
		local ok, result = pcall(function()
			return game:HttpGet(v313)
		end)
		local v317 = nil

		if ok and result then
			local ok2, result2 = pcall(function()
				return HttpService:JSONDecode(result)
			end)

			if ok2 then
				if result2 then
					ok2 = result2.data
				else
					ok2 = result2
				end
			end

			if ok2 then
				local ipairs_ = ipairs

				for _, v in ipairs_(result2.data) do
					local v322 = v.id ~= game.JobId

					if v322 then
						v322 = v.playing

						if v322 then
							v322 = v.maxPlayers

							if v322 then
								v322 = v.playing < v.maxPlayers
							end
						end
					end

					if v322 then
						local v323 = not v317

						if not v323 then
							local ping = v.ping

							if ping then
								ping = v317.ping

								if ping then
									ping = v.ping < v317.ping
								end
							end

							v323 = not ping and v.ping

							if v323 then
								v323 = not v317.ping
							end
						end

						if v323 then
							v317 = v
							ipairs_ = v317

							local v325 = v317

							v317 = ipairs_
							v325 = ipairs_
						end
					end
				end
			end
		end

		if v317 then
			t1.value33("MALAPHAS", string.format("Joining server (%d ms ping)...", v317.ping or 0), "SUCCESS", 3)
			task.wait(0.5)

			local function v326()
				t1.value8:TeleportToPlaceInstance(n4, v317.id, t1.value13)
			end

			pcall(v326)
		else
			t1.value33("MALAPHAS", "Connecting to optimal regional server...", "INFO", 3)
			task.wait(0.5)
			pcall(function()
				t1.value8:Teleport(n4, t1.value13)
			end)
		end
	end)
end)
TextLabel = t1.value53.auto
account = TextLabel:FindFirstChild("LeftCol")
TextLabel = TextLabel:FindFirstChild("RightCol")
value17 = createFrame(account, "Match Automation")
t1.value59.AutoRespawn = v147(value17, "Auto respawn", t1.value21.AutoRespawn, function(p58)
	t1.value21.AutoRespawn = p58
end)
t1.value59.AutoQueue = v147(value17, "Auto queue", t1.value21.AutoQueue, function(p59)
	t1.value21.AutoQueue = p59
end)
t1.value59.QueueMode = Frame(value17, "Queue", {
	"1v1",
	"2v2",
	"3v3",
	"4v4",
	"5v5"
}, 1, function(p60)
	t1.value21.QueueMode = p60
end)
value17 = createFrame(account, "Automatic Voting")
t1.value59.AutoVoteMaps = v147(value17, "Auto vote maps", t1.value21.AutoVoteMaps, function(p61)
	t1.value21.AutoVoteMaps = p61
end)
t1.value59.MapPriority = Frame(value17, "Map priority", { "Arena, Onyx, Crossroads", "Onyx, Arena, Crossroads", "Crossroads, Arena, Onyx" }, 1, function(p62)
	t1.value21.MapPriority = p62
end)
t1.value59.AutoBanWeapons = v147(value17, "Auto ban weapons", t1.value21.AutoBanWeapons, function(p63)
	t1.value21.AutoBanWeapons = p63
end)
t1.value59.WeaponBanPriority = Frame(value17, "Weapon ban priority", { "Grenade Launcher, Minigun, RPG", "RPG, Grenade Launcher, Sniper", "Minigun, RPG, Shotgun" }, 1, function(p64)
	t1.value21.WeaponBanPriority = p64
end)
t1.value59.SecondBanPriority = Frame(value17, "Second ban priority", { "Grenade Launcher, Minigun, RPG", "Sniper, Katana, Bow" }, 1, function(p65)
	t1.value21.SecondBanPriority = p65
end)
account = createFrame(account, "Automatic Loadout")
t1.value59.AutoLoadout = v147(account, "Auto loadout", t1.value21.AutoLoadout, function(p66)
	t1.value21.AutoLoadout = p66
end)
t1.value59.LoadoutOnlySelected = v147(account, "Only on selected maps", t1.value21.LoadoutOnlySelected, function(p67)
	t1.value21.LoadoutOnlySelected = p67
end)
t1.value59.EnabledMaps = Frame(account, "Enabled maps", { "Arena, Crossroads", "Onyx, Crossroads", "All Maps" }, 1, function(p68)
	t1.value21.EnabledMaps = p68
end)
account = createFrame(TextLabel, "Anti-Aim", "Changes the replicated pose only;\nyour camera and aim stay normal.")
t1.value59.AntiAim = v147(account, "Enable anti-aim", t1.value21.AntiAim, function(p69)
	t1.value21.AntiAim = p69
end)
t1.value59.AntiAimMode = Frame(account, "Mode", { "Spin", "Jitter", "Backwards" }, 1, function(p70)
	t1.value21.AntiAimMode = p70
end)
t1.value59.AntiAimSpeed = UIGradient(account, "Spin speed", 10, 100, t1.value21.AntiAimSpeed, "%d spd", function(p71)
	t1.value21.AntiAimSpeed = p71
end)
account = createFrame(TextLabel, "Detectors", nil, "Hacker attributes reported by the game feed the player list and notifications.")
t1.value59.HackerDetector = v147(account, "Hacker detector", t1.value21.HackerDetector, function(p72)
	t1.value21.HackerDetector = p72
end)
t1.value59.NotifyHackers = v147(account, "Notify detected hackers", t1.value21.NotifyHackers, function(p73)
	t1.value21.NotifyHackers = p73
end)
t1.value59.HackerAutoLoad = v147(account, "Auto load config on detect", t1.value21.HackerAutoLoad, function(p74)
	t1.value21.HackerAutoLoad = p74
end)
t1.value59.HackerProfile = v126(account, "Profile to auto load", t1.value21.HackerProfile, "profile name (e.g. rage)", function(p75)
	t1.value21.HackerProfile = p75
end)
t1.value59.SpeedThreshold = UIGradient(account, "Speed threshold", 50, 400, t1.value21.SpeedThreshold, "%d studs/s/%d studs/s", function(p76)
	t1.value21.SpeedThreshold = p76
end)
t1.value59.SpeedDuration = UIGradient(account, "Required duration", 0.1, 3, t1.value21.SpeedDuration, "%.2f s/%.0f s", function(p77)
	t1.value21.SpeedDuration = p77
end)
t1.value59.ModDetector = v147(account, "Moderator detector", t1.value21.ModDetector, function(p78)
	t1.value21.ModDetector = p78
end)
t1.value59.NotifyMods = v147(account, "Notify moderators", t1.value21.NotifyMods, function(p79)
	t1.value21.NotifyMods = p79
end)
t1.value59.MinGroupRank = UIGradient(account, "Minimum group rank", 1, 255, t1.value21.MinGroupRank, "%d/%d", function(p80)
	t1.value21.MinGroupRank = p80
end)
t1.value59.ModUsernames = v126(account, "Moderator usernames", t1.value21.ModUsernames, "name1, name2", function(p81)
	t1.value21.ModUsernames = p81
end)
t1.value59.ModFriendList = v126(account, "Moderator friend list", t1.value21.ModFriendList, "name1, name2", function(p82)
	t1.value21.ModFriendList = p82
end)
TextLabel = createFrame(TextLabel, "Pickups & Tripmines")
t1.value59.AutoPickup = v147(TextLabel, "Auto pickup nearby drops", t1.value21.AutoPickup, function(p83)
	t1.value21.AutoPickup = p83
end)
t1.value59.PickupRadius = UIGradient(TextLabel, "Pickup radius", 10, 60, t1.value21.PickupRadius, "%d studs/%d studs", function(p84)
	t1.value21.PickupRadius = p84
end)
TextLabel = t1.value53.aim
account = TextLabel:FindFirstChild("LeftCol")
TextLabel = TextLabel:FindFirstChild("RightCol")
account = createFrame(account, "Aimbot")
t1.value59.Aimbot = v147(account, "Enable aimbot", t1.value21.Aimbot, function(p85)
	t1.value21.Aimbot = p85
end)
t1.value59.AimbotTeamCheck = v147(account, "Team check", t1.value21.TeamCheck, function(p86)
	t1.value60(p86)
end)
t1.value59.ContinuousTargeting = v147(account, "Continuous targeting", t1.value21.ContinuousTargeting, function(p87)
	t1.value21.ContinuousTargeting = p87
end)
t1.value59.AimbotKeyMode = Frame(account, "Key mode", { "Hold", "Toggle", "Always" }, 1, function(p88)
	t1.value21.AimbotKeyMode = p88
end)
t1.value59.AimbotScopeOnly = v147(account, "Scope only", t1.value21.AimbotScopeOnly, function(p89)
	t1.value21.AimbotScopeOnly = p89
end)
t1.value59.AimbotDisableReloading = v147(account, "Disable while reloading", t1.value21.AimbotDisableReloading, function(p90)
	t1.value21.AimbotDisableReloading = p90
end)
t1.value59.AimbotSmoothing = UIGradient(account, "Smoothing speed", 0.05, 1, t1.value21.AimbotSmoothing, "%.2f", function(p91)
	t1.value21.AimbotSmoothing = p91
end)
t1.value59.InstantCameraLock = v147(account, "Instant camera lock", t1.value21.InstantCameraLock, function(p92)
	t1.value21.InstantCameraLock = p92
end)
t1.value59.TrackThroughWalls = v147(account, "Track lock through walls", t1.value21.TrackThroughWalls, function(p93)
	t1.value21.TrackThroughWalls = p93
end)
t1.value59.AimbotPart = Frame(account, "Persistent lock part", { "Head", "Body", "Closest" }, 1, function(p94)
	t1.value21.AimbotPart = p94
end)
t1.value59.CorrectLockedShots = v147(account, "Correct locked shots", t1.value21.CorrectLockedShots, function(p95)
	t1.value21.CorrectLockedShots = p95
end)
TextLabel = createFrame(TextLabel, "Silent Aim", "Redirects valid gun shots inside the FOV without moving your camera.")
t1.value59.SilentAim = v147(TextLabel, "Enable silent aim", t1.value21.SilentAim, function(p96)
	t1.value21.SilentAim = p96
end)
t1.value59.SilentTeamCheck = v147(TextLabel, "Team check", t1.value21.TeamCheck, function(p97)
	t1.value60(p97)
end)
t1.value59.SilentKeyMode = Frame(TextLabel, "Key mode", { "Always", "Hold", "Toggle" }, 1, function(p98)
	t1.value21.SilentKeyMode = p98
end)
t1.value59.SilentVisibleOnly = v147(TextLabel, "Visible targets only", t1.value21.SilentVisibleOnly, function(p99)
	t1.value21.SilentVisibleOnly = p99
end)
t1.value59.SilentVulnerableOnly = v147(TextLabel, "Vulnerable targets only", t1.value21.SilentVulnerableOnly, function(p100)
	t1.value21.SilentVulnerableOnly = p100
end)
t1.value59.SilentIgnoreDeflecting = v147(TextLabel, "Ignore deflecting", t1.value21.SilentIgnoreDeflecting, function(p101)
	t1.value21.SilentIgnoreDeflecting = p101
end)
t1.value59.SilentIgnoreShielded = v147(TextLabel, "Ignore shielded", t1.value21.SilentIgnoreShielded, function(p102)
	t1.value21.SilentIgnoreShielded = p102
end)
t1.value59.SilentTargetPart = Frame(TextLabel, "Target part", { "Head", "Body", "Closest" }, 1, function(p103)
	t1.value21.SilentTargetPart = p103
end)
t1.value59.SilentHeadChance = UIGradient(TextLabel, "Random head percentage", 0, 100, t1.value21.SilentHeadChance, "%d%%", function(p104)
	t1.value21.SilentHeadChance = p104
end)
t1.value59.SilentHitChance = UIGradient(TextLabel, "Hit chance", 0, 100, t1.value21.SilentHitChance, "%d%%", function(p105)
	t1.value21.SilentHitChance = p105
end)
t1.value59.SilentFOV = UIGradient(TextLabel, "FOV Radius", 30, 400, t1.value21.SilentFOV, "%d px", function(p106)
	t1.value21.SilentFOV = p106
end)
TextLabel = t1.value53.esp
account = TextLabel:FindFirstChild("LeftCol")
TextLabel = TextLabel:FindFirstChild("RightCol")
account = createFrame(account, "Player ESP")
t1.value59.ESP_Master = v147(account, "Enable ESP", t1.value21.ESP_Master, function(p107)
	t1.value21.ESP_Master = p107
end)
t1.value59.ESP_EnemyOnly = v147(account, "Enemy only", t1.value21.ESP_EnemyOnly, function(p108)
	t1.value21.ESP_EnemyOnly = p108
end)
t1.value59.ESP_Lobby = v147(account, "Show in lobby", t1.value21.ESP_Lobby, function(p109)
	t1.value21.ESP_Lobby = p109
end)
t1.value59.ESP_MaxDistance = UIGradient(account, "Max distance", 100, 1000, t1.value21.ESP_MaxDistance, "%d studs", function(p110)
	t1.value21.ESP_MaxDistance = p110
end)
t1.value59.ESP_Boxes = v147(account, "Box ESP", t1.value21.ESP_Boxes, function(p111)
	t1.value21.ESP_Boxes = p111
end)
t1.value59.ESP_Names = v147(account, "Name ESP", t1.value21.ESP_Names, function(p112)
	t1.value21.ESP_Names = p112
end)
t1.value59.ESP_HealthBar = v147(account, "Health bar", t1.value21.ESP_HealthBar, function(p113)
	t1.value21.ESP_HealthBar = p113
end)
t1.value59.ESP_Distance = v147(account, "Distance ESP", t1.value21.ESP_Distance, function(p114)
	t1.value21.ESP_Distance = p114
end)
t1.value59.ESP_Weapon = v147(account, "Weapon ESP", t1.value21.ESP_Weapon, function(p115)
	t1.value21.ESP_Weapon = p115
end)
account = createFrame(TextLabel, "Render & Chams")
t1.value59.ESP_Chams = v147(account, "Chams / Highlight", t1.value21.ESP_Chams, function(p116)
	t1.value21.ESP_Chams = p116
end)
t1.value59.ESP_HeadDot = v147(account, "Head dot", t1.value21.ESP_HeadDot, function(p117)
	t1.value21.ESP_HeadDot = p117
end)
t1.value59.ESP_Tracers = v147(account, "Tracers", t1.value21.ESP_Tracers, function(p118)
	t1.value21.ESP_Tracers = p118
end)
t1.value59.ESP_Skeleton = v147(account, "Skeleton ESP", t1.value21.ESP_Skeleton, function(p119)
	t1.value21.ESP_Skeleton = p119
end)
t1.value59.ESP_Tripmines = v147(account, "Tripmines ESP", t1.value21.ESP_Tripmines, function(p120)
	t1.value21.ESP_Tripmines = p120
end)
t1.value59.ESP_FOV = v147(account, "Draw FOV Circle", t1.value21.ESP_FOV, function(p121)
	t1.value21.ESP_FOV = p121
end)
TextLabel = createFrame(TextLabel, "Target Visualizer", "Renders an animated ground path and\nlive HUD card for active target.")
t1.value59.TargetVisualizer = v147(TextLabel, "Enable target visualizer", t1.value21.TargetVisualizer, function(p122)
	t1.value21.TargetVisualizer = p122
end)
t1.value59.TargetVisualizerHUD = v147(TextLabel, "Target HUD card", t1.value21.TargetVisualizerHUD, function(p123)
	t1.value21.TargetVisualizerHUD = p123
end)
t1.value59.TargetVisualizerPath = v147(TextLabel, "Ground path & arrows", t1.value21.TargetVisualizerPath, function(p124)
	t1.value21.TargetVisualizerPath = p124
end)
t1.value59.VisualizerArrowSpacing = UIGradient(TextLabel, "Arrow spacing", 5, 25, t1.value21.VisualizerArrowSpacing, "%d studs", function(p125)
	t1.value21.VisualizerArrowSpacing = p125
end)
t1.value59.VisualizerArrowSpeed = UIGradient(TextLabel, "Arrow speed", 5, 30, t1.value21.VisualizerArrowSpeed, "%d spd", function(p126)
	t1.value21.VisualizerArrowSpeed = p126
end)
TextLabel = t1.value53.move
account = TextLabel:FindFirstChild("LeftCol")
TextLabel = TextLabel:FindFirstChild("RightCol")
account = createFrame(account, "Ground Movement")
t1.value59.SpeedHack = v147(account, "Speed hack", t1.value21.SpeedHack, function(p127)
	t1.value21.SpeedHack = p127
end)
t1.value59.SpeedValue = UIGradient(account, "WalkSpeed", 16, 120, t1.value21.SpeedValue, "%d ws", function(p128)
	t1.value21.SpeedValue = p128
end)
t1.value59.InfiniteJump = v147(account, "Infinite jump", t1.value21.InfiniteJump, function(p129)
	t1.value21.InfiniteJump = p129
end)
t1.value59.BunnyHop = v147(account, "Bunny hop", t1.value21.BunnyHop, function(p130)
	t1.value21.BunnyHop = p130
end)
TextLabel = createFrame(TextLabel, "Flight & Collision")
t1.value59.FlyHack = v147(TextLabel, "Fly hack", t1.value21.FlyHack, function(p131)
	t1.value21.FlyHack = p131
end)
t1.value59.FlySpeed = UIGradient(TextLabel, "Fly speed", 20, 150, t1.value21.FlySpeed, "%d spd", function(p132)
	t1.value21.FlySpeed = p132
end)
t1.value59.Noclip = v147(TextLabel, "Noclip", t1.value21.Noclip, function(p133)
	t1.value21.Noclip = p133
end)
TextLabel = t1.value53.guns
account = TextLabel:FindFirstChild("LeftCol")
TextLabel = TextLabel:FindFirstChild("RightCol")
account = createFrame(account, "Weapon Mechanics")
t1.value59.NoRecoil = v147(account, "No recoil", t1.value21.NoRecoil, function(p134)
	t1.value21.NoRecoil = p134
	t1.value28()
end)
t1.value59.NoSpread = v147(account, "No spread", t1.value21.NoSpread, function(p135)
	t1.value21.NoSpread = p135
	t1.value28()
end)
t1.value59.FastReload = v147(account, "Fast reload", t1.value21.FastReload, function(p136)
	t1.value21.FastReload = p136
	t1.value28()
end)
t1.value59.RapidFire = v147(account, "Rapid fire", t1.value21.RapidFire, function(p137)
	t1.value21.RapidFire = p137
	t1.value28()
end)
t1.value59.InstantEquip = v147(account, "Instant weapon equip", t1.value21.InstantEquip, function(p138)
	t1.value21.InstantEquip = p138
	t1.value28()
end)
account = createFrame(TextLabel, "Weapon Features")
t1.value59.AutomaticGuns = v147(account, "Automatic mode", t1.value21.AutomaticGuns, function(p139)
	t1.value21.AutomaticGuns = p139
end)
t1.value59.InfiniteAmmo = v147(account, "Infinite ammo", t1.value21.InfiniteAmmo, function(p140)
	t1.value21.InfiniteAmmo = p140
	t1.value28()
end)
value17 = Instance.new("TextLabel")
value17.Size = UDim2.new(1, 0, 0, 32)
value17.BackgroundTransparency = 1
value17.Font = t1.value23
value17.Text = "Note: Fast reload, automatic mode, & infinite ammo are client-sided and may be clamped by server authority in ranked matches."
value17.TextColor3 = t1.value22.TextMuted
value17.TextSize = 10
value17.TextWrapped = true
value17.TextXAlignment = Enum.TextXAlignment.Left
value17.ZIndex = 17
value17.Parent = account
TextLabel = createFrame(TextLabel, "Viewmodel & Render")
t1.value59.RainbowGunSkin = v147(TextLabel, "Rainbow gun skin", t1.value21.RainbowGunSkin, function(p141)
	t1.value21.RainbowGunSkin = p141
end)
t1.value59.WeaponChams = v147(TextLabel, "Weapon chams & glow", t1.value21.WeaponChams, function(p142)
	t1.value21.WeaponChams = p142
end)
t1.value59.CustomViewModelFOV = v147(TextLabel, "Custom Viewmodel FOV", t1.value21.CustomViewModelFOV, function(p143)
	t1.value21.CustomViewModelFOV = p143
end)
t1.value59.ViewModelFOVValue = UIGradient(TextLabel, "Viewmodel FOV", 50, 110, t1.value21.ViewModelFOVValue, "%d°", function(p144)
	t1.value21.ViewModelFOVValue = p144
end)
t1.value59.ViewModelXOffset = UIGradient(TextLabel, "Viewmodel X offset", -30, 30, t1.value21.ViewModelXOffset, "%d/30", function(p145)
	t1.value21.ViewModelXOffset = p145
end)
t1.value59.ViewModelYOffset = UIGradient(TextLabel, "Viewmodel Y offset", -30, 30, t1.value21.ViewModelYOffset, "%d/30", function(p146)
	t1.value21.ViewModelYOffset = p146
end)
t1.value59.ViewModelZOffset = UIGradient(TextLabel, "Viewmodel Z offset", -30, 30, t1.value21.ViewModelZOffset, "%d/30", function(p147)
	t1.value21.ViewModelZOffset = p147
end)
t1.value59.HideViewModel = v147(TextLabel, "Hide viewmodel", t1.value21.HideViewModel, function(p148)
	t1.value21.HideViewModel = p148
end)
TextLabel = t1.value53.world
account = TextLabel:FindFirstChild("LeftCol")
TextLabel = TextLabel:FindFirstChild("RightCol")
account = createFrame(account, "World & Visuals")
t1.value59.Fullbright = v147(account, "Fullbright", t1.value21.Fullbright, function(p149)
	t1.value21.Fullbright = p149

	if p149 then
		t1.value9.Brightness = 2
		t1.value9.ClockTime = 14
		t1.value9.GlobalShadows = false
		t1.value9.OutdoorAmbient = Color3.fromRGB(150, 150, 150)
	else
		t1.value9.Brightness = 1
		t1.value9.GlobalShadows = true
	end
end)
t1.value59.NoFog = v147(account, "No fog", t1.value21.NoFog, function(p150)
	t1.value21.NoFog = p150

	if p150 then
		t1.value9.FogEnd = 1000000
	else
		t1.value9.FogEnd = 1000
	end
end)
t1.value59.CustomFOV = v147(account, "Custom FOV", t1.value21.CustomFOV, function(p151)
	t1.value21.CustomFOV = p151

	if not p151 then
		return
	end

	t1.value14.FieldOfView = t1.value21.FOVValue
end)
t1.value59.FOVValue = UIGradient(account, "FOV Angle", 70, 120, t1.value21.FOVValue, "%d°", function(p152)
	t1.value21.FOVValue = p152

	if not t1.value21.CustomFOV then
		return
	end

	t1.value14.FieldOfView = p152
end)
TextLabel = createFrame(TextLabel, "Effects & Sounds")
t1.value59.BulletTracers = v147(TextLabel, "Bullet tracers", t1.value21.BulletTracers, function(p153)
	t1.value21.BulletTracers = p153
end)
t1.value59.HitSound = Frame(TextLabel, "Hit sound", { "Skeet", "Rust", "Ding" }, 1, function(p154)
	t1.value21.HitSound = p154
end)
TextLabel = t1.value53.view
account = TextLabel:FindFirstChild("LeftCol")
TextLabel = TextLabel:FindFirstChild("RightCol")
account = createFrame(account, "Third-Person")
t1.value59.ThirdPerson = v147(account, "Third-person mode", t1.value21.ThirdPerson, function(p155)
	t1.value21.ThirdPerson = p155
end)
t1.value59.ThirdPersonDist = UIGradient(account, "Third-person distance", 5, 30, t1.value21.ThirdPersonDist, "%d studs", function(p156)
	t1.value21.ThirdPersonDist = p156
end)
TextLabel = createFrame(TextLabel, "Freecam")
t1.value59.Freecam = v147(TextLabel, "Freecam mode", t1.value21.Freecam, function(p157)
	t1.value21.Freecam = p157
end)
t1.value59.FreecamSpeed = UIGradient(TextLabel, "Freecam speed", 10, 100, t1.value21.FreecamSpeed, "%d spd", function(p158)
	t1.value21.FreecamSpeed = p158
end)

function t1.value64()
	local t2 = {}

	for k, v in pairs(t1.value21) do
		if typeof(v) == "EnumItem" then
			local EnumType = v.EnumType

			t2[k] = {
				__type = "EnumItem",
				enumType = tostring(EnumType),
				name = v.Name
			}
		elseif typeof(v) == "Color3" then
			t2[k] = {
				__type = "Color3",
				r = v.R,
				g = v.G,
				b = v.B
			}
		elseif typeof(v) == "Vector3" then
			t2[k] = {
				__type = "Vector3",
				x = v.X,
				y = v.Y,
				z = v.Z
			}
		else
			t2[k] = v
		end
	end

	return t2
end
function t1.value65(p159)
	local t3 = {}

	for k, v in pairs(p159) do
		local v334

		if type(v) == "table" then
			v334 = v.__type == "EnumItem"
		else
			v334 = false
		end

		if v334 then
			local v335 = Enum[v.enumType]
			local v336

			if v335 then
				v336 = v335[v.name]
			else
				v336 = v335
			end

			if v336 then
				t3[k] = v335[v.name]
			end
		else
			local v337

			if type(v) == "table" then
				v337 = v.__type == "Color3"
			else
				v337 = false
			end

			if v337 then
				t3[k] = Color3.new(v.r, v.g, v.b)
			else
				local v338

				if type(v) == "table" then
					v338 = v.__type == "Vector3"
				else
					v338 = false
				end

				if v338 then
					t3[k] = Vector3.new(v.x, v.y, v.z)
				else
					t3[k] = v
				end
			end
		end
	end

	return t3
end

t1.value66 = {
	current = "default",
	autoload = "default",
	names = { "default", "rage" },
	profiles = {},
	nameInput = nil,
	dropdown = nil,
	autoLoadLabel = nil,
	defaultProfiles = {
		default = {
			Aimbot = false,
			TeamCheck = true,
			AimbotDisableReloading = true,
			AimbotFOV = 120,
			AimbotKey = Enum.UserInputType.MouseButton2,
			AimbotKeyMode = "Hold",
			AimbotPart = "Closest",
			AimbotScopeOnly = false,
			AimbotSmoothing = 0.28,
			AimbotVisibleOnly = true,
			AntiAim = false,
			AntiAimMode = "Jitter",
			AntiAimSpeed = 10,
			AutoBanWeapons = false,
			AutoLoadout = true,
			AutoPickup = false,
			AutoQueue = false,
			AutoRespawn = false,
			AutoVoteMaps = false,
			AutomaticGuns = false,
			BulletTracers = false,
			BunnyHop = false,
			CorrectLockedShots = true,
			ContinuousTargeting = true,
			CustomFOV = false,
			CustomViewModelFOV = false,
			ESP_Boxes = true,
			ESP_Chams = false,
			ESP_Distance = true,
			ESP_EnemyOnly = true,
			ESP_FOV = true,
			ESP_HeadDot = true,
			ESP_HealthBar = true,
			ESP_Lobby = true,
			ESP_Master = true,
			ESP_MaxDistance = 500,
			ESP_Names = true,
			ESP_Skeleton = true,
			ESP_Tracers = false,
			ESP_Tripmines = true,
			ESP_Weapon = true,
			EnabledMaps = "Arena, Crossroads",
			FastReload = false,
			FlyHack = false,
			FlySpeed = 50,
			FOVValue = 90,
			Freecam = false,
			FreecamSpeed = 40,
			Fullbright = false,
			HackerAutoLoad = true,
			HackerDetector = true,
			HackerProfile = "rage",
			HideViewModel = false,
			HitSound = "Skeet",
			InfiniteAmmo = false,
			InfiniteJump = false,
			InstantCameraLock = false,
			InstantEquip = false,
			LoadoutOnlySelected = false,
			MapPriority = "Arena, Onyx, Crossroads",
			MenuKey = Enum.KeyCode.RightControl,
			MinGroupRank = 200,
			ModDetector = true,
			ModFriendList = "name1, name2",
			ModUsernames = "name1, name2",
			NoFog = true,
			NoRecoil = true,
			NoSpread = true,
			Noclip = false,
			NotifyHackers = true,
			NotifyMods = true,
			PickupRadius = 25,
			QueueMode = "1v1",
			RainbowGunSkin = false,
			RapidFire = false,
			SecondBanPriority = "Grenade Launcher, Minigun, RPG",
			SilentAim = true,
			SilentFOV = 242,
			SilentHeadChance = 59,
			SilentHitChance = 78,
			SilentIgnoreDeflecting = true,
			SilentIgnoreShielded = true,
			SilentKey = Enum.KeyCode.C,
			SilentKeyMode = "Always",
			SilentTargetPart = "Head",
			SilentVisibleOnly = true,
			SilentVulnerableOnly = true,
			SpeedDuration = 0.75,
			SpeedHack = false,
			SpeedThreshold = 180,
			SpeedValue = 49,
			TargetVisualizer = true,
			TargetVisualizerHUD = true,
			TargetVisualizerPath = true,
			ThirdPerson = false,
			ThirdPersonDist = 12,
			TrackThroughWalls = true,
			ViewModelFOVValue = 70,
			ViewModelXOffset = 0,
			ViewModelYOffset = 0,
			ViewModelZOffset = 0,
			VisualizerArrowSpacing = 10,
			VisualizerArrowSpeed = 14,
			WeaponBanPriority = "Grenade Launcher, Minigun, RPG",
			WeaponChams = false
		},
		rage = {
			Aimbot = false,
			TeamCheck = true,
			AimbotDisableReloading = true,
			AimbotFOV = 120,
			AimbotKey = Enum.UserInputType.MouseButton2,
			AimbotKeyMode = "Hold",
			AimbotPart = "Closest",
			AimbotScopeOnly = false,
			AimbotSmoothing = 0.28,
			AimbotVisibleOnly = true,
			AntiAim = false,
			AntiAimMode = "Jitter",
			AntiAimSpeed = 10,
			AutoBanWeapons = false,
			AutoLoadout = false,
			AutoPickup = false,
			AutoQueue = false,
			AutoRespawn = false,
			AutoVoteMaps = false,
			AutomaticGuns = false,
			BulletTracers = true,
			BunnyHop = true,
			CorrectLockedShots = true,
			ContinuousTargeting = true,
			CustomFOV = false,
			CustomViewModelFOV = false,
			ESP_Boxes = true,
			ESP_Chams = true,
			ESP_Distance = true,
			ESP_EnemyOnly = true,
			ESP_FOV = true,
			ESP_HeadDot = true,
			ESP_HealthBar = true,
			ESP_Lobby = true,
			ESP_Master = true,
			ESP_MaxDistance = 500,
			ESP_Names = true,
			ESP_Skeleton = true,
			ESP_Tracers = false,
			ESP_Tripmines = true,
			ESP_Weapon = true,
			EnabledMaps = "Arena, Crossroads",
			FastReload = false,
			FlyHack = false,
			FlySpeed = 50,
			FOVValue = 90,
			Freecam = false,
			FreecamSpeed = 40,
			Fullbright = false,
			HackerAutoLoad = true,
			HackerDetector = true,
			HackerProfile = "rage",
			HideViewModel = false,
			HitSound = "Skeet",
			InfiniteAmmo = false,
			InfiniteJump = false,
			InstantCameraLock = false,
			InstantEquip = false,
			LoadoutOnlySelected = false,
			MapPriority = "Arena, Onyx, Crossroads",
			MenuKey = Enum.KeyCode.RightControl,
			MinGroupRank = 200,
			ModDetector = true,
			ModFriendList = "name1, name2",
			ModUsernames = "name1, name2",
			NoFog = true,
			NoRecoil = true,
			NoSpread = true,
			Noclip = false,
			NotifyHackers = true,
			NotifyMods = true,
			PickupRadius = 25,
			QueueMode = "1v1",
			RainbowGunSkin = false,
			RapidFire = false,
			SecondBanPriority = "Grenade Launcher, Minigun, RPG",
			SilentAim = true,
			SilentFOV = 400,
			SilentHeadChance = 100,
			SilentHitChance = 100,
			SilentIgnoreDeflecting = true,
			SilentIgnoreShielded = true,
			SilentKey = Enum.KeyCode.C,
			SilentKeyMode = "Always",
			SilentTargetPart = "Head",
			SilentVisibleOnly = true,
			SilentVulnerableOnly = true,
			SpeedDuration = 0.75,
			SpeedHack = true,
			SpeedThreshold = 180,
			SpeedValue = 49,
			TargetVisualizer = true,
			TargetVisualizerHUD = true,
			TargetVisualizerPath = true,
			ThirdPerson = false,
			ThirdPersonDist = 12,
			TrackThroughWalls = true,
			ViewModelFOVValue = 70,
			ViewModelXOffset = 0,
			ViewModelYOffset = 0,
			ViewModelZOffset = 0,
			VisualizerArrowSpacing = 10,
			VisualizerArrowSpeed = 14,
			WeaponBanPriority = "Grenade Launcher, Minigun, RPG",
			WeaponChams = false
		}
	}
}

function t1.value66.readStore()
	local function v339()
		local readfile_ = readfile
		local json, value7

		if readfile_ then
		elseif readfile_ then
			json = readfile("malaphas_config.json")
			value7 = t1.value7

			return value7.JSONDecode(value7, json)
		else
			return nil
		end

		readfile_ = isfile

		if readfile_ then
		elseif readfile_ then
			json = readfile("malaphas_config.json")
			value7 = t1.value7

			return value7.JSONDecode(value7, json)
		else
			return nil
		end

		readfile_ = isfile("malaphas_config.json")

		if readfile_ then
			json = readfile("malaphas_config.json")
			value7 = t1.value7

			return value7.JSONDecode(value7, json)
		else
			return nil
		end
	end

	local ok, result = pcall(v339)

	if ok then
		ok = type(result) == "table"
	end

	if ok then
		local profiles = result.profiles

		if type(profiles) == "table" then
			t1.value66.profiles = result.profiles
			t1.value66.autoload = tostring(result.autoload or "default")
		else
			t1.value66.profiles = {
				default = result
			}
			t1.value66.autoload = "default"
		end
	else
		t1.value66.profiles = {}
		t1.value66.autoload = "default"
	end

	for k, defaultProfile in pairs(t1.value66.defaultProfiles) do
		if not t1.value66.profiles[k] then
			local t4 = {}

			for k2, v in pairs(defaultProfile) do
				t4[k2] = v
			end

			t1.value66.profiles[k] = t4
		end
	end

	local names = {}

	for k, _ in pairs(t1.value66.profiles) do
		local v354 = tostring(k)

		table.insert(names, v354)
	end

	local sort = table.sort

	sort(names)

	if #names == 0 then
		names = { "default", "rage" }
		sort = names
	end

	t1.value66.names = names

	local v356 = false

	for _, name in ipairs(t1.value66.names) do
		if name == t1.value66.autoload then
			v356 = true

			break
		end
	end

	if not v356 then
		t1.value66.autoload = "default"
	end

	t1.value66.current = t1.value66.autoload

	local isfile_ = isfile

	if isfile_ then
		isfile_ = isfile("malaphas_config.json")
	end

	if isfile_ then
		return
	end

	t1.value66.writeStore()
end
function t1.value66.writeStore()
	if not writefile then
		return false
	end

	local t5 = {
		autoload = t1.value66.autoload or "default",
		profiles = t1.value66.profiles
	}
	local v361 = nil

	local function v362()
		local json = t1.value7:JSONEncode(v361)

		writefile("malaphas_config.json", json)
	end

	v361 = t5

	return pcall(v362)
end
function t1.value66.applyProfile(p160, p161)
	local loadedProfile = tostring(p160 or (t1.value66.current or "default"))
	local v366 = t1.value66.profiles[loadedProfile]

	if v366 then
		local v367 = t1.value65(v366)

		for k, v in pairs(v367) do
			t1.value21[k] = v

			local Set = t1.value59[k]

			if Set then
				Set = t1.value59[k].Set
			end

			if Set then
				local function v370()
					t1.value59[k].Set(v)
				end

				pcall(v370)
			end
		end

		t1.value28()
		t1.value66.current = loadedProfile

		local nameInput = t1.value66.nameInput

		if nameInput then
			nameInput = t1.value66.nameInput.Set
		end

		if nameInput then
			t1.value66.nameInput.Set(loadedProfile)
		end

		local dropdown = t1.value66.dropdown

		if dropdown then
			dropdown = t1.value66.dropdown.Set
		end

		if dropdown then
			t1.value66.dropdown.Set(loadedProfile)
		end

		if not p161 then
			return true
		end

		t1.value33("MALAPHAS", "Loaded profile: " .. loadedProfile, "SUCCESS", 2.5)

		return true
	end

	if not p161 then
		return false
	end

	t1.value33("MALAPHAS", "Profile not found: " .. loadedProfile, "WARN", 2.5)

	return false
end
function t1.value66.saveProfile(p162)
	local v373

	if p162 then
		v538 = ((not p162 or p162:gsub("%s+", "") == "") and (t1.value66.current or "default") or p162):match("^%s*(.-)%s*$")
		t1.value66.profiles[v538] = t1.value64()
		t1.value66.current = v538
		v539 = {}

		for k, profile in pairs(t1.value66.profiles) do
			v373 = tostring(k)
			table.insert(v539, v373)
		end

		table.sort(v539)
		t1.value66.names = v539
		t1.value66.writeStore()
		v542 = t1.value66.dropdown

		if v542 then
			v542 = t1.value66.dropdown.SetOptions
		end

		if v542 then
			t1.value66.dropdown.SetOptions(t1.value66.names, v538)
		end

		v543 = t1.value66.nameInput

		if v543 then
			v543 = t1.value66.nameInput.Set
		end

		if not v543 then
			t1.value33("MALAPHAS", "Saved profile: " .. v538, "SUCCESS", 2.5)

			return
		end

		t1.value66.nameInput.Set(v538)
		t1.value33("MALAPHAS", "Saved profile: " .. v538, "SUCCESS", 2.5)

		return
	end

	p162 = t1.value66.nameInput

	if not p162 then
		v538 = ((not p162 or p162:gsub("%s+", "") == "") and (t1.value66.current or "default") or p162):match("^%s*(.-)%s*$")
		t1.value66.profiles[v538] = t1.value64()
		t1.value66.current = v538
		v539 = {}

		for k, profile in pairs(t1.value66.profiles) do
			v373 = tostring(k)
			table.insert(v539, v373)
		end

		table.sort(v539)
		t1.value66.names = v539
		t1.value66.writeStore()
		v542 = t1.value66.dropdown

		if v542 then
			v542 = t1.value66.dropdown.SetOptions
		end

		if v542 then
			t1.value66.dropdown.SetOptions(t1.value66.names, v538)
		end

		v543 = t1.value66.nameInput

		if v543 then
			v543 = t1.value66.nameInput.Set
		end

		if not v543 then
			t1.value33("MALAPHAS", "Saved profile: " .. v538, "SUCCESS", 2.5)

			return
		end

		t1.value66.nameInput.Set(v538)
		t1.value33("MALAPHAS", "Saved profile: " .. v538, "SUCCESS", 2.5)

		return
	end

	p162 = t1.value66.nameInput.Get

	if not p162 then
		v538 = ((not p162 or p162:gsub("%s+", "") == "") and (t1.value66.current or "default") or p162):match("^%s*(.-)%s*$")
		t1.value66.profiles[v538] = t1.value64()
		t1.value66.current = v538
		v539 = {}

		for k, profile in pairs(t1.value66.profiles) do
			v373 = tostring(k)
			table.insert(v539, v373)
		end

		table.sort(v539)
		t1.value66.names = v539
		t1.value66.writeStore()
		v542 = t1.value66.dropdown

		if v542 then
			v542 = t1.value66.dropdown.SetOptions
		end

		if v542 then
			t1.value66.dropdown.SetOptions(t1.value66.names, v538)
		end

		v543 = t1.value66.nameInput

		if v543 then
			v543 = t1.value66.nameInput.Set
		end

		if not v543 then
			t1.value33("MALAPHAS", "Saved profile: " .. v538, "SUCCESS", 2.5)

			return
		end

		t1.value66.nameInput.Set(v538)
		t1.value33("MALAPHAS", "Saved profile: " .. v538, "SUCCESS", 2.5)

		return
	end

	p162 = t1.value66.nameInput.Get()

	local match = ((not p162 or p162:gsub("%s+", "") == "") and (t1.value66.current or "default") or p162):match("^%s*(.-)%s*$")

	t1.value66.profiles[match] = t1.value64()
	t1.value66.current = match

	local names = {}

	for k, profile in pairs(t1.value66.profiles) do
		v373 = tostring(k)
		table.insert(names, v373)
	end

	table.sort(names)
	t1.value66.names = names
	t1.value66.writeStore()

	local dropdown = t1.value66.dropdown

	if dropdown then
		dropdown = t1.value66.dropdown.SetOptions
	end

	if dropdown then
		t1.value66.dropdown.SetOptions(t1.value66.names, match)
	end

	local nameInput = t1.value66.nameInput

	if nameInput then
		nameInput = t1.value66.nameInput.Set
	end

	if not nameInput then
		t1.value33("MALAPHAS", "Saved profile: " .. match, "SUCCESS", 2.5)

		return
	end

	t1.value66.nameInput.Set(match)
	t1.value33("MALAPHAS", "Saved profile: " .. match, "SUCCESS", 2.5)
end
function t1.value66.setAutoload(p163)
	local current = p163 or (t1.value66.current or "default")

	if not t1.value66.profiles[current] then
		t1.value66.profiles[current] = t1.value64()
	end

	t1.value66.autoload = current
	t1.value66.writeStore()

	if not t1.value66.autoLoadLabel then
		t1.value33("MALAPHAS", "Auto-load set to: " .. current, "SUCCESS", 2.5)

		return
	end

	t1.value66.autoLoadLabel.Text = "Auto-load on start: " .. current
	t1.value33("MALAPHAS", "Auto-load set to: " .. current, "SUCCESS", 2.5)
end
function t1.value66.deleteProfile(p164)
	local current = p164 or t1.value66.current

	if #t1.value66.names <= 1 then
		t1.value33("MALAPHAS", "Cannot delete only remaining profile.", "WARN", 2.5)
	else
		t1.value66.profiles[current] = nil

		local names = {}

		for k, _ in pairs(t1.value66.profiles) do
			local v391 = tostring(k)

			table.insert(names, v391)
		end

		table.sort(names)
		t1.value66.names = names

		if t1.value66.autoload == current then
			t1.value66.autoload = t1.value66.names[1]
		end

		t1.value66.current = t1.value66.names[1]
		t1.value66.writeStore()

		local dropdown = t1.value66.dropdown

		if dropdown then
			dropdown = t1.value66.dropdown.SetOptions
		end

		if dropdown then
			t1.value66.dropdown.SetOptions(t1.value66.names, t1.value66.current)
		end

		local nameInput = t1.value66.nameInput

		if nameInput then
			nameInput = t1.value66.nameInput.Set
		end

		if nameInput then
			t1.value66.nameInput.Set(t1.value66.current)
		end

		if not t1.value66.autoLoadLabel then
			t1.value66.applyProfile(t1.value66.current, false)
			t1.value33("MALAPHAS", "Deleted profile: " .. current, "INFO", 2.5)

			return
		end

		t1.value66.autoLoadLabel.Text = "Auto-load on start: " .. t1.value66.autoload
		t1.value66.applyProfile(t1.value66.current, false)
		t1.value33("MALAPHAS", "Deleted profile: " .. current, "INFO", 2.5)
	end
end

t1.value66.readStore()
TextLabel = t1.value53.config
account = TextLabel:FindFirstChild("LeftCol")
TextLabel = TextLabel:FindFirstChild("RightCol")
account = createFrame(account, "Profiles")
t1.value66.nameInput = v126(account, "Profile name", t1.value66.current, "Profile name...", function(p165)
	t1.value66.current = p165
end)
t1.value66.dropdown = Frame(account, "Select profile", t1.value66.names, 1, function(p166)
	t1.value66.current = p166

	local nameInput = t1.value66.nameInput

	if nameInput then
		nameInput = t1.value66.nameInput.Set
	end

	if not nameInput then
		return
	end

	t1.value66.nameInput.Set(p166)
end)
value29(account, "Save profile", function()
	t1.value66.saveProfile()
end)
value29(account, "Load profile", function()
	t1.value66.applyProfile(t1.value66.current, true)
end)
value29(account, "Set as auto-load", function()
	t1.value66.setAutoload(t1.value66.current)
end)
value29(account, "Delete profile", function()
	t1.value66.deleteProfile(t1.value66.current)
end)
t1.value66.autoLoadLabel = Instance.new("TextLabel")
t1.value66.autoLoadLabel.Size = UDim2.new(1, 0, 0, 16)
t1.value66.autoLoadLabel.BackgroundTransparency = 1
t1.value66.autoLoadLabel.Font = t1.value23
t1.value66.autoLoadLabel.Text = "Auto-load on start: " .. t1.value66.autoload
t1.value66.autoLoadLabel.TextColor3 = t1.value22.AccentPinkLight
t1.value66.autoLoadLabel.TextSize = 11.5
t1.value66.autoLoadLabel.TextXAlignment = Enum.TextXAlignment.Left
t1.value66.autoLoadLabel.ZIndex = 17
t1.value66.autoLoadLabel.Parent = account
value29(account, "Unload script", value26)
TextLabel = createFrame(TextLabel, "Keybinds & Info")
account = Instance.new("TextLabel")
account.Size = UDim2.new(1, 0, 0, 16)
account.BackgroundTransparency = 1
account.Font = t1.value23
account.Text = "Menu Toggle: RightControl"
account.TextColor3 = t1.value22.TextWhite
account.TextSize = 12
account.TextXAlignment = Enum.TextXAlignment.Left
account.ZIndex = 17
account.Parent = TextLabel
t1.value59.MobileToggle = v147(TextLabel, "Mobile toggle button", t1.value21.MobileToggle, function(p167)
	t1.value21.MobileToggle = p167

	local MalaphasMobileToggle = t1.value26:FindFirstChild("MalaphasMobileToggle")

	if not MalaphasMobileToggle then
		return
	end

	MalaphasMobileToggle.Visible = p167
end)
pcall(function()
	t1.value66.applyProfile(t1.value66.autoload, false)
end);
(function()
	local t6 = {}

	for k, v in pairs(t1.value53) do
		for _, v2 in ipairs({ "LeftCol", "RightCol" }) do
			local v401 = v:FindFirstChild(v2)

			if v401 then
				for _, child in ipairs(v401.GetChildren(v401)) do
					if child:IsA("Frame") then
						local Header = child:FindFirstChild("Header")

						if Header then
							Header = Header:FindFirstChild("TitleLabel") or Header:FindFirstChildWhichIsA("TextLabel")
						end

						if Header then
							Header = Header.Text
						end

						local v405 = Header or ""
						local Content = child:FindFirstChild("Content")
						local t7 = {}

						if Content then
							local ipairs_ = ipairs

							for _, child2 in ipairs_(Content.GetChildren(Content)) do
								if child2:IsA("Frame") or child2:IsA("TextButton") then
									local TextLabel2 = child2:FindFirstChildWhichIsA("TextLabel") or child2:IsA("TextButton") and child2
									local Text = TextLabel2 and TextLabel2.Text or ""

									if Text ~= "" then
										ipairs_ = table.insert
										ipairs_(t7, {
											element = child2,
											name = Text
										})
									end
								end
							end
						end

						table.insert(t6, {
							tab = k,
							page = v,
							card = child,
							cardTitle = v405,
							controls = t7
						})
					end
				end
			end
		end
	end

	local ScrollingFrame = Instance.new("ScrollingFrame")

	ScrollingFrame.Name = "SearchDropdown"
	ScrollingFrame.Size = UDim2.new(0, 180, 0, 0)
	ScrollingFrame.Position = UDim2.new(1, -210, 0, 26)
	ScrollingFrame.BackgroundColor3 = t1.value22.CardBg
	ScrollingFrame.BorderSizePixel = 0
	ScrollingFrame.ScrollBarThickness = 2
	ScrollingFrame.ScrollBarImageColor3 = t1.value22.AccentPink
	ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	ScrollingFrame.ZIndex = 1005
	ScrollingFrame.Visible = false
	ScrollingFrame.Parent = t1.value29

	local UIStroke = Instance.new("UIStroke")

	UIStroke.Color = t1.value22.BorderPink
	UIStroke.Thickness = 1
	UIStroke.Parent = ScrollingFrame

	local UIListLayout = Instance.new("UIListLayout")

	UIListLayout.Padding = UDim.new(0, 1)
	UIListLayout.Parent = ScrollingFrame

	local function v416(p168)
		local match = p168:lower():match("^%s*(.-)%s*$")

		if not match or match == "" then
			ScrollingFrame.Visible = false

			local v418, v419, v420 = ipairs(t6)

			while true do
				local v421

				v420, v421 = v418(v419, v420)

				if not v420 then
					break
				end

				v421.card.Visible = true

				for _, control in ipairs(v421.controls) do
					control.element.Visible = true
				end
			end

			for _, v in ipairs(t1.value54) do
				local v426 = v.name == t1.value55
				local btn = v.btn
				local s5 = "TextColor3"

				if v426 then
					v426 = t1.value22.AccentPinkLight
				end

				btn[s5] = v426 or t1.value22.TextMuted
			end

			return
		end

		local v429, v430, v431 = ipairs(ScrollingFrame:GetChildren())

		while true do
			local v432

			v431, v432 = v429(v430, v431)

			if not v431 then
				break
			end

			if v432:IsA("TextButton") then
				v432:Destroy()
			end
		end

		local n5 = 0
		local t8 = {}

		for _, v in ipairs(t6) do
			local visible = v.cardTitle:lower():find(match, 1, true) ~= nil
			local ipairs_ = ipairs
			local v439 = false

			for _, control in ipairs_(v.controls) do
				local visible2 = visible or control.name:lower():find(match, 1, true) ~= nil

				ipairs_ = control.element
				ipairs_.Visible = visible2

				if visible2 then
					ipairs_ = true
					v439 = true

					local v443

					if n5 < 8 then
						v443 = control.name:lower():find(match, 1, true) ~= nil
					else
						v443 = false
					end

					if v443 then
						n5 = n5 + 1

						local TextButton = Instance.new("TextButton")

						TextButton.Size = UDim2.new(1, 0, 0, 22)
						TextButton.BackgroundColor3 = t1.value22.ControlBg
						TextButton.BackgroundTransparency = 0.5
						TextButton.BorderSizePixel = 0
						TextButton.Font = t1.value23
						TextButton.Text = "  " .. control.name .. "  [" .. v.tab:upper() .. "]"
						TextButton.TextColor3 = t1.value22.TextWhite
						TextButton.TextSize = 10.5
						TextButton.TextXAlignment = Enum.TextXAlignment.Left
						TextButton.ZIndex = 1006
						TextButton.Parent = ScrollingFrame
						TextButton.MouseEnter:Connect(function()
							TextButton.BackgroundColor3 = t1.value22.ButtonHoverBg
							TextButton.TextColor3 = t1.value22.AccentPinkLight
						end)
						TextButton.MouseLeave:Connect(function()
							TextButton.BackgroundColor3 = t1.value22.ControlBg
							TextButton.TextColor3 = t1.value22.TextWhite
						end)
						TextButton.MouseButton1Click:Connect(function()
							t1.value56(v.tab)
							ScrollingFrame.Visible = false
						end)
					end
				end
			end

			v.card.Visible = visible or v439

			if visible or v439 then
				t8[v.tab] = true
			end
		end

		local v445, v446, v447 = ipairs(t1.value54)

		while true do
			local v448

			v447, v448 = v445(v446, v447)

			if not v447 then
				break
			end

			if t8[v448.name] then
				v448.btn.TextColor3 = t1.value22.AccentPinkLight
			else
				v448.btn.TextColor3 = Color3.fromRGB(60, 60, 65)
			end
		end

		local AbsolutePosition, AbsoluteSize, v451, uDim2New, v453

		if t8[t1.value55] then
			if n5 > 0 then
				AbsolutePosition = t1.value48.AbsolutePosition
				AbsoluteSize = t1.value48.AbsoluteSize
				ScrollingFrame.Position = UDim2.new(0, AbsolutePosition.X - 50, 0, AbsolutePosition.Y + AbsoluteSize.Y + 3)
				v451 = ScrollingFrame
				uDim2New = UDim2.new
				v453 = n5 * 23
				v451.Size = uDim2New(0, 210, 0, (math.min(v453, 140)))
				ScrollingFrame.Visible = true
			else
				ScrollingFrame.Visible = false
			end

			return
		end

		for _, v in ipairs(t1.value52) do
			if t8[v] then
				t1.value56(v)

				break
			end
		end

		if n5 > 0 then
			AbsolutePosition = t1.value48.AbsolutePosition
			AbsoluteSize = t1.value48.AbsoluteSize
			ScrollingFrame.Position = UDim2.new(0, AbsolutePosition.X - 50, 0, AbsolutePosition.Y + AbsoluteSize.Y + 3)
			v451 = ScrollingFrame
			uDim2New = UDim2.new
			v453 = n5 * 23
			v451.Size = uDim2New(0, 210, 0, (math.min(v453, 140)))
			ScrollingFrame.Visible = true
		else
			ScrollingFrame.Visible = false
		end
	end

	t1.value48:GetPropertyChangedSignal("Text"):Connect(function()
		v416(t1.value48.Text)
	end)
end)()
TextLabel = Instance.new("Frame")
TextLabel.Name = "CornerGrip"
TextLabel.Size = UDim2.new(0, 14, 0, 14)
TextLabel.Position = UDim2.new(1, -15, 1, -15)
TextLabel.BackgroundTransparency = 1
TextLabel.BorderSizePixel = 0
TextLabel.ZIndex = 25
TextLabel.Parent = t1.value35

for i = 1, 14 do
	v147 = Instance.new("Frame")
	v147.Name = "Slice_" .. i
	v147.Size = UDim2.new(0, 1, 0, i)
	v147.Position = UDim2.new(0, i - 1, 1, -i)
	v147.BackgroundColor3 = t1.value22.AccentGreen
	v147.BorderSizePixel = 0
	v147.ZIndex = 26
	v147.Parent = TextLabel
end

t1.value67 = Instance.new("Frame")
t1.value67.Name = "FOVCircle"
t1.value67.Size = UDim2.new(0, t1.value21.SilentFOV * 2, 0, t1.value21.SilentFOV * 2)
t1.value67.Position = UDim2.new(0.5, -t1.value21.SilentFOV, 0.5, -t1.value21.SilentFOV)
t1.value67.BackgroundTransparency = 1
t1.value67.Visible = t1.value21.ESP_FOV
t1.value67.ZIndex = 1
t1.value67.Parent = t1.value26
TextLabel = t1.value17
account = t1.value67
table.insert(TextLabel, account)
Instance.new("UICorner", t1.value67).CornerRadius = UDim.new(1, 0)
TextLabel = Instance.new("UIStroke")
TextLabel.Color = t1.value22.AccentGreen
TextLabel.Transparency = 0.5
TextLabel.Thickness = 1.2
TextLabel.Parent = t1.value67
t1.value68 = Instance.new("TextButton")
t1.value68.Name = "MalaphasMobileToggle"
t1.value68.Size = UDim2.new(0, 36, 0, 36)
t1.value68.Position = UDim2.new(0, 16, 0, 50)
t1.value68.BackgroundColor3 = t1.value22.ButtonBg
t1.value68.BorderSizePixel = 0
t1.value68.Font = t1.value23
t1.value68.Text = "M"
t1.value68.TextColor3 = t1.value22.AccentPinkLight
t1.value68.TextSize = 16
t1.value68.ZIndex = 50
TextLabel = t1.value68
account = t1.value21.MobileToggle == true

if not account then
	if t1.value21.MobileToggle == nil then
		account = t1.value3.TouchEnabled
	else
		account = false
	end
end

TextLabel.Visible = account
t1.value68.Parent = t1.value26
TextLabel = t1.value17
account = t1.value68
table.insert(TextLabel, account)
Instance.new("UICorner", t1.value68).CornerRadius = UDim.new(0, 8)
TextLabel = Instance.new("UIStroke")
TextLabel.Color = t1.value22.AccentPink
TextLabel.Thickness = 1.2
TextLabel.Parent = t1.value68
t1.value69 = false
t1.value70 = nil
t1.value71 = nil
t1.value68.InputBegan:Connect(function(input)
	if not (input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch) then
		return
	end

	t1.value69 = true
	t1.value70 = input.Position
	t1.value71 = t1.value68.Position
	input.Changed:Connect(function()
		if input.UserInputState ~= Enum.UserInputState.End then
			return
		end

		t1.value69 = false
	end)
end)
t1.value3.InputChanged:Connect(function(input)
	local value69 = t1.value69

	if value69 then
		value69 = input.UserInputType == Enum.UserInputType.MouseMovement and true or input.UserInputType == Enum.UserInputType.Touch
	end

	if not value69 then
		return
	end

	local v458 = input.Position - t1.value70

	t1.value68.Position = UDim2.new(t1.value71.X.Scale, t1.value71.X.Offset + v458.X, t1.value71.Y.Scale, t1.value71.Y.Offset + v458.Y)
end)
TextLabel = t1.value68.MouseButton1Click
account = TextLabel.Connect
t1.value72 = nil
account(TextLabel, function()
	t1.value43(not t1.value35.Visible)
end)
t1.value72 = false

function t1.value73(_, p169, _)
	if not (t1.value15 and t1.value21.SilentAim) then
		return p169
	end

	local v459

	if t1.value21.SilentKeyMode == "Hold" then
		v459 = not t1.value72
	else
		v459 = false
	end

	if v459 then
		return p169
	end

	local v460 = t1.value62(t1.value21.SilentFOV, t1.value21.SilentVisibleOnly, t1.value21.SilentTargetPart)

	if not v460 then
		return p169
	end

	if t1.value25(v460) then
		return p169
	end

	if not (math.random(1, 100) <= t1.value21.SilentHitChance) then
		return p169
	end

	local Position = v460.Position

	if not (math.random(1, 100) <= t1.value21.SilentHeadChance) then
		return Position
	end

	local isModel = v460:IsA("Model") and v460 or v460:FindFirstAncestorOfClass("Model")
	local Head = isModel and isModel:FindFirstChild("Head") or isModel:FindFirstChild("HitboxHead")

	if not Head then
		return Position
	end

	Position = Head.Position

	return Position
end

t1.value74 = {
	Skeet = "rbxassetid://4817809188",
	Rust = "rbxassetid://1255040462",
	Ding = "rbxassetid://9114223175"
}
t1.value75 = 0

local function v464()
	if tick() - t1.value75 < 0.04 then
		return
	end

	local function v465()
		local Skeet = t1.value74[t1.value21.HitSound] or t1.value74.Skeet
		local Sound = Instance.new("Sound")

		Sound.SoundId = Skeet
		Sound.Volume = 1.2
		Sound.Parent = t1.value10
		Sound:Play()

		local Debris = game:GetService("Debris")

		if Debris then
			Debris:AddItem(Sound, 1.5)

			return
		end

		task.delay(1.5, function()
			local Parent = Sound

			if Parent then
				Parent = Sound.Parent
			end

			if not Parent then
				return
			end

			Sound:Destroy()
		end)
	end

	pcall(v465)
end

function t1.value76(p170, p171)
	if not (t1.value21.BulletTracers and t1.value15) then
		return
	end

	local function v470()
		local v471 = p170
		local v472

		if typeof(v471) == "Vector3" then
			local v473 = p171

			v472 = typeof(v473) ~= "Vector3"
		else
			v472 = true
		end

		if v472 then
			return
		end

		local Magnitude = (p171 - p170).Magnitude

		if Magnitude < 3 and true or Magnitude > 1500 then
			return
		end

		local Attachment = Instance.new("Attachment")

		Attachment.Position = p170
		Attachment.Parent = t1.value2.Terrain

		local Attachment2 = Instance.new("Attachment")

		Attachment2.Position = p171
		Attachment2.Parent = t1.value2.Terrain

		local Beam = Instance.new("Beam")

		Beam.Name = "MalaphasBulletTracer"
		Beam.Attachment0 = Attachment
		Beam.Attachment1 = Attachment2
		Beam.Width0 = 0.06
		Beam.Width1 = 0.06
		Beam.FaceCamera = true
		Beam.LightEmission = 1
		Beam.LightInfluence = 0
		Beam.Color = ColorSequence.new(t1.value22.AccentPinkLight)
		Beam.Transparency = NumberSequence.new(0)
		Beam.Parent = t1.value2.Terrain

		local value172 = t1.value17

		table.insert(value172, Attachment)

		local value173 = t1.value17

		table.insert(value173, Attachment2)

		local value174 = t1.value17

		table.insert(value174, Beam)
		task.spawn(function()
			local now = tick()
			local n6 = 0.35

			while true do
				local value15 = t1.value15

				if value15 then
					value15 = tick() - now < n6
				end

				if not value15 then
					break
				end

				local v484 = (tick() - now) / n6
				local v485 = math.clamp(v484, 0, 1)

				Beam.Transparency = NumberSequence.new(v485)
				task.wait(0.03)
			end

			if Attachment.Parent then
				Attachment:Destroy()
			end

			if Attachment2.Parent then
				Attachment2:Destroy()
			end

			if not Beam.Parent then
				return
			end

			Beam:Destroy()
		end)
	end

	pcall(v470)
end

pcall(function()
	local Modules = t1.value13.PlayerScripts:FindFirstChild("Modules")

	if Modules then
		Modules = t1.value13.PlayerScripts.Modules:FindFirstChild("ClientReplicatedClasses")
	end

	if Modules then
		Modules = Modules:FindFirstChild("ClientFighter")
	end

	if Modules then
		Modules = Modules:FindFirstChild("ClientItem")
	end

	if not Modules then
		return
	end

	local module = require(Modules)
	local v488

	if module then
		local _PlayHitmarkerQueue = module._PlayHitmarkerQueue

		v488 = type(_PlayHitmarkerQueue) == "function"
	else
		v488 = module
	end

	if v488 then
		local _PlayHitmarkerQueue = module._PlayHitmarkerQueue

		function module._PlayHitmarkerQueue(p172, ...)
			local v491 = nil

			local function v492()
				local Fighter = v491

				if Fighter then
					Fighter = v491.Fighter or (v491._fighter or v491.Player)
				end

				local v494 = Fighter == t1.value13

				if not v494 then
					v494 = v491

					if v494 then
						v494 = v491.Character == t1.value13.Character
					end
				end

				if not v494 then
					return
				end

				if tick() - t1.value75 < 0.04 then
					return
				end

				local function v495()
					local Skeet = t1.value74[t1.value21.HitSound] or t1.value74.Skeet
					local Sound = Instance.new("Sound")

					Sound.SoundId = Skeet
					Sound.Volume = 1.2
					Sound.Parent = t1.value10
					Sound:Play()

					local Debris = game:GetService("Debris")

					if Debris then
						Debris:AddItem(Sound, 1.5)

						return
					end

					task.delay(1.5, function()
						local Parent = Sound

						if Parent then
							Parent = Sound.Parent
						end

						if not Parent then
							return
						end

						Sound:Destroy()
					end)
				end

				pcall(v495)
			end

			v491 = p172
			pcall(v492)

			return _PlayHitmarkerQueue(v491, ...)
		end
	end

	local ItemInterface = Modules:FindFirstChild("ItemInterface")

	if ItemInterface then
		ItemInterface = ItemInterface:FindFirstChild("Mouse")
	end

	if ItemInterface then
		ItemInterface = ItemInterface:FindFirstChild("MouseCrosshair")
	end

	if not ItemInterface then
		return
	end

	local module2 = require(ItemInterface)
	local v502

	if module2 then
		local DamageEffect = module2.DamageEffect

		v502 = type(DamageEffect) == "function"
	else
		v502 = module2
	end

	if not v502 then
		return
	end

	local DamageEffect = module2.DamageEffect

	function module2.DamageEffect(p173, ...)
		pcall(v464)

		return DamageEffect(p173, ...)
	end
end)
pcall(function()
	local Modules = t1.value13.PlayerScripts:FindFirstChild("Modules")

	if Modules then
		Modules = t1.value13.PlayerScripts.Modules:FindFirstChild("ItemTypes")

		if Modules then
			Modules = t1.value13.PlayerScripts.Modules.ItemTypes:FindFirstChild("Gun")
		end
	end

	if not Modules then
		return
	end

	local module = require(Modules)
	local v507

	if module then
		local _LocalTracers = module._LocalTracers

		v507 = type(_LocalTracers) == "function"
	else
		v507 = module
	end

	if not v507 then
		return
	end

	local _LocalTracers = module._LocalTracers

	function module._LocalTracers(p174, ...)
		local BulletTracers = t1.value21.BulletTracers

		if BulletTracers then
			BulletTracers = t1.value15
		end

		if not BulletTracers then
			return _LocalTracers(p174, ...)
		end

		local function v511()
			local CurrentCamera = t1.value2.CurrentCamera
			local mouseLocation = t1.value3:GetMouseLocation()
			local v514 = CurrentCamera:ViewportPointToRay(mouseLocation.X, mouseLocation.Y)
			local v515 = CurrentCamera.CFrame.Position - Vector3.new(0, 0.4, 0)
			local v516 = v515 + v514.Direction * 350
			local raycastParams = RaycastParams.new()

			raycastParams.FilterType = Enum.RaycastFilterType.Exclude
			raycastParams.FilterDescendantsInstances = { t1.value13.Character, CurrentCamera }

			local hit = t1.value2:Raycast(v515, v514.Direction * 350, raycastParams)

			if not hit then
				t1.value76(v515, v516)

				return
			end

			v516 = hit.Position
			t1.value76(v515, v516)
		end

		pcall(v511)

		return _LocalTracers(p174, ...)
	end
end)
pcall(function()
	local Modules = t1.value6:FindFirstChild("Modules")

	if Modules then
		Modules = t1.value6.Modules:FindFirstChild("Utility")
	end

	if not Modules then
		return
	end

	local module = require(Modules)
	local v521

	if module then
		local Raycast = module.Raycast

		v521 = type(Raycast) == "function"
	else
		v521 = module
	end

	if not v521 then
		return
	end

	t1.value19 = module.Raycast

	function module.Raycast(...)
		local value = select("#", ...)
		local t9 = { ... }
		local n7 = 0
		local v526

		if typeof(t9[1]) == "table" then
			v526 = true
		else
			local v527 = t9[1]

			v526 = typeof(v527) == "Instance"
		end

		local v528 = v526 and 1 or n7
		local v529 = t9[v528 + 1]
		local v530 = t9[v528 + 2]
		local v531 = t9[v528 + 3]
		local value15 = t1.value15

		if value15 then
			value15 = t1.value21.SilentAim
		end

		if not value15 then
			return t1.value19(unpack(t9, 1, value))
		end

		pcall(function()
			local v533 = v529
			local v534

			if typeof(v533) == "Vector3" then
				local v535 = v530

				v534 = typeof(v535) == "Vector3"
			else
				v534 = false
			end

			if not v534 then
				return
			end

			local v536 = t1.value73(v529, v530, v531)
			local v537

			if v536 then
				if typeof(v536) == "Vector3" then
					v537 = v536 ~= v530
				else
					v537 = false
				end
			else
				v537 = v536
			end

			if not v537 then
				return
			end

			local v540 = v536 - v529

			if not (v540.Magnitude > 0.05) then
				return
			end

			local v541 = v540.Unit * (v531 or 1000)

			t9[v528 + 2] = v529 + v541
		end)

		return t1.value19(unpack(t9, 1, value))
	end
end)
TextLabel = hookmetamethod

if TextLabel then
	TextLabel = newcclosure

	if TextLabel then
		TextLabel = checkcaller
	end
end

if TextLabel then
	t1.value18 = hookmetamethod(game, "__namecall", newcclosure(function(p175, ...)
		local v544 = getnamecallmethod()

		if not t1.value15 or (checkcaller() or not v544) then
			if not setnamecallmethod then
				return t1.value18(p175, ...)
			end

			setnamecallmethod(v544)

			return t1.value18(p175, ...)
		end

		local v545 = v544:lower()
		local v546

		if v545 == "fireserver" then
			v546 = false
		else
			v546 = v545 ~= "invokeserver"
		end

		if v546 then
			if not setnamecallmethod then
				return t1.value18(p175, ...)
			end

			setnamecallmethod(v544)

			return t1.value18(p175, ...)
		else
			local t10 = { ... }
			local SilentAim = t1.value21.SilentAim

			if SilentAim then
				SilentAim = typeof(p175) == "Instance"

				if SilentAim then
					SilentAim = p175.Name == "UseItem" or (p175.Name == "UseItemFeedback" and true or p175.Name == "SnowballThrow")
				end
			end

			local v547

			if SilentAim then
				local v548 = t1.value62(t1.value21.SilentFOV, t1.value21.SilentVisibleOnly, t1.value21.SilentTargetPart)
				local v549

				if v548 then
					v549 = not t1.value25(v548)
				else
					v549 = v548
				end

				if v549 and math.random(1, 100) <= t1.value21.SilentHitChance then
					local Position = v548.Position

					if math.random(1, 100) <= t1.value21.SilentHeadChance then
						local isModel = v548:IsA("Model") and v548 and v548 or v548:FindFirstAncestorOfClass("Model")

						if isModel then
							isModel = isModel:FindFirstChild("Head") or isModel:FindFirstChild("HitboxHead")
						end

						if isModel then
							Position = isModel.Position
						end
					end

					local v550

					if #t10 >= 2 then
						local v551 = t10[2]

						v550 = typeof(v551) == "Vector3"
					else
						v550 = false
					end

					if v550 then
						t10[2] = Position
					else
						local v552

						if #t10 >= 1 then
							local v553 = t10[1]

							v552 = typeof(v553) == "Vector3"
						else
							v552 = false
						end

						if v552 then
							t10[1] = Position
						end
					end

					local Character = t1.value13.Character

					if Character then
						Character = t1.value13.Character:FindFirstChild("HumanoidRootPart")
					end

					if Character then
						t1.value76(t1.value13.Character.HumanoidRootPart.Position, Position)
					end

					if not setnamecallmethod then
						return t1.value18(p175, unpack(t10))
					end

					setnamecallmethod(v544)

					return t1.value18(p175, unpack(t10))
				else
					if v545 == "invokeserver" and typeof(p175) == "Instance" then
						v547 = p175.ClassName == "RemoteFunction"
					else
						v547 = false
					end

					if v547 then
						return p175.InvokeServer(p175, ...)
					end

					if not setnamecallmethod then
						return t1.value18(p175, ...)
					end

					setnamecallmethod(v544)

					return t1.value18(p175, ...)
				end
			else
				if v545 == "invokeserver" and typeof(p175) == "Instance" then
					v547 = p175.ClassName == "RemoteFunction"
				else
					v547 = false
				end

				if v547 then
					return p175.InvokeServer(p175, ...)
				end

				if not setnamecallmethod then
					return t1.value18(p175, ...)
				end

				setnamecallmethod(v544)

				return t1.value18(p175, ...)
			end
		end
	end))
end

pcall(function()
	local Controllers = t1.value1.LocalPlayer.PlayerScripts:FindFirstChild("Controllers")

	if not Controllers then
		return
	end

	local TimerController = Controllers:FindFirstChild("TimerController")

	if TimerController then
		local module = require(TimerController)
		local v558

		if module then
			local SetTimeRemaining = module.SetTimeRemaining

			v558 = type(SetTimeRemaining) == "function"
		else
			v558 = module
		end

		if v558 then
			local SetTimeRemaining = module.SetTimeRemaining

			function module.SetTimeRemaining(p176, p177, p178, ...)
				local v561

				if typeof(p178) == "number" then
					v561 = p177
					p177 = p178
				else
					if typeof(p177) ~= "number" then
						return
					end

					v561 = "Timer"
				end

				return SetTimeRemaining(p176, v561, p177, ...)
			end
		end
	end

	local FFlagController = Controllers:FindFirstChild("FFlagController")

	if not FFlagController then
		return
	end

	local module = require(FFlagController)
	local v564

	if module then
		local _Fetch = module._Fetch

		v564 = type(_Fetch) == "function"
	else
		v564 = module
	end

	if not v564 then
		return
	end

	function module._Fetch(p179, ...)
		local response = nil

		local function v567()
			response = t1.value6.Remotes.Misc.RequestFFlags:InvokeServer()
		end

		response = nil
		pcall(v567)

		local v568 = response

		if typeof(v568) ~= "table" then
			return
		end

		for k, v in pairs(response) do
			pcall(function()
				p179:SetFFlag(k, v)
			end)
		end
	end
end)
t1.value77 = {
	{ "Head", "UpperTorso" },
	{ "UpperTorso", "LowerTorso" },
	{ "UpperTorso", "LeftUpperArm" },
	{ "LeftUpperArm", "LeftLowerArm" },
	{ "LeftLowerArm", "LeftHand" },
	{ "UpperTorso", "RightUpperArm" },
	{ "RightUpperArm", "RightLowerArm" },
	{ "RightLowerArm", "RightHand" },
	{ "LowerTorso", "LeftUpperLeg" },
	{ "LeftUpperLeg", "LeftLowerLeg" },
	{ "LeftLowerLeg", "LeftFoot" },
	{ "LowerTorso", "RightUpperLeg" },
	{ "RightUpperLeg", "RightLowerLeg" },
	{ "RightLowerLeg", "RightFoot" }
}
t1.value78 = nil
t1.value79 = {
	{ "Head", "Torso" },
	{ "Torso", "Left Arm" },
	{ "Torso", "Right Arm" },
	{ "Torso", "Left Leg" },
	{ "Torso", "Right Leg" }
}

function t1.value80(p180, p181, p182, p183, p184)
	local v571 = p182 - p181
	local Magnitude = v571.Magnitude

	if Magnitude < 1 then
		p180.Visible = false

		return
	end

	p180.Size = UDim2.new(0, Magnitude, 0, p183 or 1.2)
	p180.Position = UDim2.new(0, (p181.X + p182.X) * 0.5, 0, (p181.Y + p182.Y) * 0.5)

	local Y = v571.Y
	local X = v571.X
	local v575 = math.atan2(Y, X)

	p180.Rotation = math.deg(v575)

	if not p184 then
		p180.Visible = true

		return
	end

	p180.BackgroundColor3 = p184
	p180.Visible = true
end

t1.value81 = nil
t1.value78 = {}

function t1.value82(p185)
	local Folder = Instance.new("Folder")

	Folder.Name = "ESP_" .. p185.Name
	Folder.Parent = t1.value26

	local value172 = t1.value17

	table.insert(value172, Folder)

	local Frame2 = Instance.new("Frame")

	Frame2.BackgroundTransparency = 1
	Frame2.BorderSizePixel = 0
	Frame2.Visible = false
	Frame2.ZIndex = 2
	Frame2.Parent = Folder

	local UIStroke = Instance.new("UIStroke")

	UIStroke.Color = t1.value22.AccentPink
	UIStroke.Thickness = 1.2
	UIStroke.Parent = Frame2

	local TextLabel2 = Instance.new("TextLabel")

	TextLabel2.Size = UDim2.new(0, 120, 0, 14)
	TextLabel2.BackgroundTransparency = 1
	TextLabel2.Font = t1.value23
	TextLabel2.Text = p185.DisplayName
	TextLabel2.TextColor3 = t1.value22.TextWhite
	TextLabel2.TextSize = 11.5
	TextLabel2.Visible = false
	TextLabel2.ZIndex = 3
	TextLabel2.Parent = Folder

	local TextLabel3 = Instance.new("TextLabel")

	TextLabel3.Size = UDim2.new(0, 60, 0, 14)
	TextLabel3.BackgroundTransparency = 1
	TextLabel3.Font = t1.value23
	TextLabel3.Text = "0m"
	TextLabel3.TextColor3 = t1.value22.AccentPinkLight
	TextLabel3.TextSize = 10.5
	TextLabel3.Visible = false
	TextLabel3.ZIndex = 3
	TextLabel3.Parent = Folder

	local Frame3 = Instance.new("Frame")

	Frame3.Size = UDim2.new(0, 2, 1, 0)
	Frame3.Position = UDim2.new(0, -6, 0, 0)
	Frame3.BackgroundColor3 = t1.value22.ControlBg
	Frame3.BorderSizePixel = 0
	Frame3.Visible = false
	Frame3.ZIndex = 3
	Frame3.Parent = Frame2

	local Frame4 = Instance.new("Frame")

	Frame4.Size = UDim2.new(1, 0, 1, 0)
	Frame4.Position = UDim2.new(0, 0, 1, 0)
	Frame4.AnchorPoint = Vector2.new(0, 1)
	Frame4.BackgroundColor3 = t1.value22.AccentPink
	Frame4.BorderSizePixel = 0
	Frame4.ZIndex = 4
	Frame4.Parent = Frame3

	local Frame5 = Instance.new("Frame")

	Frame5.Size = UDim2.new(0, 4, 0, 4)
	Frame5.AnchorPoint = Vector2.new(0.5, 0.5)
	Frame5.BackgroundColor3 = t1.value22.AccentPinkLight
	Frame5.BorderSizePixel = 0
	Frame5.Visible = false
	Frame5.ZIndex = 5
	Frame5.Parent = Folder
	Instance.new("UICorner", Frame5).CornerRadius = UDim.new(1, 0)

	local Highlight = Instance.new("Highlight")

	Highlight.Name = "MalaphasHighlight"
	Highlight.FillColor = t1.value22.AccentPink
	Highlight.FillTransparency = 0.6
	Highlight.OutlineColor = t1.value22.AccentPinkLight
	Highlight.OutlineTransparency = 0.1
	Highlight.Enabled = false

	local TextLabel4 = Instance.new("TextLabel")

	TextLabel4.Size = UDim2.new(0, 120, 0, 14)
	TextLabel4.BackgroundTransparency = 1
	TextLabel4.Font = t1.value23
	TextLabel4.Text = "Weapon"
	TextLabel4.TextColor3 = t1.value22.AccentPinkLight
	TextLabel4.TextSize = 10.5
	TextLabel4.Visible = false
	TextLabel4.ZIndex = 3
	TextLabel4.Parent = Folder

	local t11 = {}

	for _ = 1, #t1.value77 do
		local Frame6 = Instance.new("Frame")

		Frame6.BorderSizePixel = 0
		Frame6.BackgroundColor3 = t1.value22.AccentPinkLight
		Frame6.AnchorPoint = Vector2.new(0.5, 0.5)
		Frame6.Visible = false
		Frame6.ZIndex = 2
		Frame6.Parent = Folder
		table.insert(t11, Frame6)
	end

	local Frame6 = Instance.new("Frame")

	Frame6.BorderSizePixel = 0
	Frame6.BackgroundColor3 = t1.value22.AccentPinkLight
	Frame6.AnchorPoint = Vector2.new(0.5, 0.5)
	Frame6.Visible = false
	Frame6.ZIndex = 2
	Frame6.Parent = Folder
	t1.value78[p185] = {
		holder = Folder,
		box = Frame2,
		nameLbl = TextLabel2,
		distLbl = TextLabel3,
		weapLbl = TextLabel4,
		healthBg = Frame3,
		healthFill = Frame4,
		headDot = Frame5,
		highlight = Highlight,
		skeletonLines = t11,
		tracerLine = Frame6,
		isShown = false
	}
end
function t1.value83(p186)
	if not p186.isShown then
		return
	end

	p186.isShown = false
	p186.box.Visible = false
	p186.nameLbl.Visible = false
	p186.distLbl.Visible = false
	p186.headDot.Visible = false
	p186.healthBg.Visible = false

	if p186.weapLbl then
		p186.weapLbl.Visible = false
	end

	if p186.highlight then
		p186.highlight.Enabled = false
	end

	if p186.skeletonLines then
		for _, skeletonLine in ipairs(p186.skeletonLines) do
			skeletonLine.Visible = false
		end
	end

	if not p186.tracerLine then
		return
	end

	p186.tracerLine.Visible = false
end

t1.value81 = {}

function t1.value84(p187)
	if not p187 then
		return "Unarmed"
	end

	local now = tick()
	local v594 = t1.value81[p187]
	local v595

	if v594 then
		v595 = now - v594.time < 0.5
	else
		v595 = v594
	end

	if v595 then
		return v594.name
	end

	local ipairs_ = ipairs
	local v597, v598, v599 = ipairs_(p187:GetChildren())
	local s6 = "Fighter"

	while true do
		local v601

		v599, v601 = v597(v598, v599)

		if not v599 then
			break
		end

		ipairs_ = v601:IsA("Tool")

		if ipairs_ then
			s6 = v601.Name
			ipairs_ = s6

			break
		end
	end

	if s6 ~= "Fighter" then
		t1.value81[p187] = {
			name = s6,
			time = now
		}

		return s6
	end

	local RightHand = p187:FindFirstChild("RightHand") or p187:FindFirstChild("Right Arm")

	if not RightHand then
		t1.value81[p187] = {
			name = s6,
			time = now
		}

		return s6
	end

	local GetChildren = RightHand.GetChildren

	for _, v in ipairs(GetChildren(RightHand)) do
		local isWeld = v:IsA("Weld") or v:IsA("Motor6D")

		if isWeld then
			isWeld = v.Part1

			if isWeld then
				isWeld = v.Part1.Parent

				if isWeld then
					if v.Part1.Parent == p187 then
						isWeld = false
					else
						isWeld = v.Part1.Parent ~= t1.value2
					end
				end
			end
		end

		if isWeld then
			s6 = v.Part1.Parent.Name

			break
		end
	end

	t1.value81[p187] = {
		name = s6,
		time = now
	}

	return s6
end

for _, player in ipairs(t1.value1:GetPlayers()) do
	if player ~= t1.value13 then
		t1.value82(player)
	end
end

t1.value1.PlayerAdded:Connect(function(player)
	if player == t1.value13 then
		return
	end

	t1.value82(player)
end)
t1.value1.PlayerRemoving:Connect(function(player)
	if not t1.value78[player] then
		return
	end

	t1.value78[player].holder:Destroy()
	t1.value78[player] = nil
end)
t1.value85 = false
table.insert(t1.value16, t1.value3.InputBegan:Connect(function(input, gameProcessed)
	if input.KeyCode == t1.value21.MenuKey then
		t1.value43(not t1.value35.Visible)

		return
	end

	if gameProcessed then
		return
	end

	if input.UserInputType == t1.value21.AimbotKey and true or input.KeyCode == t1.value21.AimbotKey then
		t1.value85 = true

		return
	end

	if input.KeyCode ~= t1.value21.SilentKey then
		return
	end

	if t1.value21.SilentKeyMode == "Toggle" then
		t1.value21.SilentAim = not t1.value21.SilentAim
		t1.value33("MALAPHAS", "Silent Aim: " .. (t1.value21.SilentAim and "ON" or "OFF"), "INFO", 1.5)

		return
	end

	local _ = t1.value21.SilentKeyMode == "Hold"
end))
t1.value86 = 0
TextLabel = t1.value16
account = t1.value3.JumpRequest
table.insert(TextLabel, account:Connect(function()
	local value15 = t1.value15

	if value15 then
		value15 = not t1.value35.Visible
	end

	if not (value15 and (t1.value21.InfiniteJump and tick() - t1.value86 >= 0.25)) then
		return
	end

	local Character = t1.value13.Character

	if Character then
		Character = Character:FindFirstChildOfClass("Humanoid")
	end

	if not Character then
		return
	end

	Character:ChangeState(Enum.HumanoidStateType.Jumping)
end))
TextLabel = t1.value16
account = t1.value3.InputEnded
table.insert(TextLabel, account:Connect(function(p188)
	if p188.UserInputType == t1.value21.AimbotKey and true or p188.KeyCode == t1.value21.AimbotKey then
		t1.value85 = false

		return
	end

	if p188.KeyCode ~= t1.value21.SilentKey then
		return
	end

	local _ = t1.value21.SilentKeyMode == "Hold"
end))
task.spawn(function()
	local v613 = t1.value12:CreatePath({
		AgentRadius = 2,
		AgentHeight = 5,
		AgentCanJump = true,
		WaypointSpacing = 3.5
	})
	local raycastParams = RaycastParams.new()

	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.IgnoreWater = true

	while true do
		while true do
			if not t1.value15 then
				return
			end

			task.wait(0.28)

			local Character = t1.value13.Character
			local HumanoidRootPart

			if Character then
				HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
			else
				HumanoidRootPart = Character
			end

			local activeRoot = t1.value34.activeRoot
			local TargetVisualizerPath = t1.value21.TargetVisualizer and t1.value21.TargetVisualizerPath

			if TargetVisualizerPath then
				if HumanoidRootPart then
					TargetVisualizerPath = activeRoot
				else
					TargetVisualizerPath = HumanoidRootPart
				end
			end

			if TargetVisualizerPath then
				break
			end

			if not activeRoot then
				t1.value34.cachedWaypoints = {}
			end
		end

		local Position = v_u_792.Position
		local Position2 = v_u_793.Position
		local lastPathActPos = t1.value34.lastPathMyPos and t1.value34.lastPathActPos

		if lastPathActPos then
			lastPathActPos = #t1.value34.cachedWaypoints >= 2
		end

		if lastPathActPos then
			local v622

			if (Position - t1.value34.lastPathMyPos).Magnitude < 3.5 then
				v622 = (Position2 - t1.value34.lastPathActPos).Magnitude < 3.5
			else
				v622 = false
			end

			if v622 then
				continue
			end
		end

		t1.value34.lastPathMyPos = Position
		t1.value34.lastPathActPos = Position2

		local function v623()
			raycastParams.FilterDescendantsInstances = { v_u_791, t1.value34.visualizerFolder }

			local function v624()
				v613:ComputeAsync(Position, Position2)
			end

			local ok = pcall(v624)

			if ok then
				ok = v613.Status == Enum.PathStatus.Success
			end

			if ok then
				local waypoints = v613:GetWaypoints()
				local cachedWaypoints = {}

				for _, waypoint in ipairs(waypoints) do
					local hit = t1.value2:Raycast(waypoint.Position + Vector3.new(0, 3, 0), Vector3.new(0, -12, 0), raycastParams)

					if hit then
						hit = hit.Position.Y + 0.1
					end

					local v631 = hit or waypoint.Position.Y - 2.4

					table.insert(cachedWaypoints, {
						Position = Vector3.new(waypoint.Position.X, v631, waypoint.Position.Z),
						Action = waypoint.Action
					})
				end

				if #cachedWaypoints >= 2 then
					t1.value34.cachedWaypoints = cachedWaypoints

					return
				else
					return
				end
			end

			local value2 = t1.value2
			local Position3 = v_u_792.Position
			local Vector3_ = Vector3
			local v635 = value2.Raycast(value2, Position3 + Vector3_.new(0, 3, 0), Vector3.new(0, -8, 0), raycastParams)
			local hit = t1.value2:Raycast(v_u_793.Position + Vector3.new(0, 3, 0), Vector3.new(0, -8, 0), raycastParams)
			local v637 = v635 and v635.Position + Vector3.new(0, 0.1, 0) or v_u_792.Position - Vector3.new(0, 2.4, 0)

			if not hit then
				v812 = hit or v_u_793.Position - Vector3.new(0, 2.4, 0)
				t1.value34.cachedWaypoints = {
					{
						Position = v637,
						Action = Enum.PathWaypointAction.Custom
					},
					{
						Position = v812,
						Action = Enum.PathWaypointAction.Custom
					}
				}

				return
			end

			hit = hit.Position + Vector3.new(0, 0.1, 0)

			local v638 = hit or v_u_793.Position - Vector3.new(0, 2.4, 0)

			t1.value34.cachedWaypoints = {
				{
					Position = v637,
					Action = Enum.PathWaypointAction.Custom
				},
				{
					Position = v638,
					Action = Enum.PathWaypointAction.Custom
				}
			}
		end

		pcall(v623)

		continue
	end
end)
t1.value87 = nil
t1.value88 = nil
t1.value89 = 0
t1.value90 = tick()
t1.value91 = 60
t1.value92 = 0
table.insert(t1.value16, getgenv_.RenderStepped:Connect(function(dt)
	local v639 = not t1.value15

	if v639 then
		return
	end

	local FieldOfView, Character, vector3New

	if t1.value35.Visible then
		t1.value3.MouseBehavior = Enum.MouseBehavior.Default
		t1.value3.MouseIconEnabled = true

		if t1.value36 then
			v639 = t1.value14
			v639.CFrame = t1.value36
		else
			v639 = t1.value14.CFrame
		end

		if t1.value37 then
			t1.value14.FieldOfView = t1.value37
		else
			FieldOfView = t1.value14.FieldOfView
		end

		Character = t1.value13.Character

		if Character then
			Character = Character:FindFirstChild("HumanoidRootPart")
		end

		if Character then
			vector3New = Vector3.new
			v838 = Character.AssemblyLinearVelocity.Y
			Character.AssemblyLinearVelocity = vector3New(0, math.min(v838, 0), 0)
		end
	end

	t1.value89 = t1.value89 + 1

	local now = tick()

	if now - t1.value90 >= 0.25 then
		vector3New = math.floor
		Character = t1.value90
		t1.value91 = vector3New(t1.value89 / (now - Character) + 0.5)
		pcall(function()
			local value13 = t1.value13

			if value13 then
				value13 = t1.value13.GetNetworkPing
			end

			if value13 then
				local v645 = t1
				local v646 = t1.value13:GetNetworkPing() * 1000 + 0.5

				v645.value92 = math.floor(v646)

				return
			end

			local Stats = game:GetService("Stats")

			if Stats then
				Stats = Stats:FindFirstChild("Network")
			end

			if Stats then
				Stats = Stats:FindFirstChild("ServerStatsItem")
			end

			if Stats then
				Stats = Stats:FindFirstChild("Data Ping")
			end

			if not Stats then
				return
			end

			local math_ = math
			local v649 = Stats.GetValue(Stats)

			t1.value92 = math_.floor(v649 + 0.5)
		end)
		now = t1.value31

		if now then
			now = t1.value31.Parent
		end

		if now then
			now = t1.value31
			vector3New = t1.value91
			vector3New = tostring(vector3New)
			Character = t1.value92
			now.Text = "<b>M</b>  |  <font color=\"#d81e26\">malaphas</font>  |  " .. vector3New .. " fps  |  " .. tostring(Character) .. " ms"
		end

		now = t1.value63

		if now then
			now = t1.value63.Parent
		end

		if now then
			now = t1.value63
			vector3New = t1.value92
			vector3New = tostring(vector3New)
			Character = #t1.value1:GetPlayers()
			now.Text = vector3New .. " ms - " .. tostring(Character) .. " players"
		end
	end

	now = t1.value13.Character

	if now then
		vector3New = now:FindFirstChild("HumanoidRootPart")
	else
		vector3New = now
	end

	if now then
		Character = now:FindFirstChildOfClass("Humanoid")
	else
		Character = now
	end

	local CurrentCamera = t1.value2.CurrentCamera

	if t1.value21.ESP_FOV then
		t1.value67.Visible = true
		t1.value67.Size = UDim2.new(0, t1.value21.SilentFOV * 2, 0, t1.value21.SilentFOV * 2)
		v835 = t1.value3:GetMouseLocation()
		t1.value67.Position = UDim2.new(0, v835.X - t1.value21.SilentFOV, 0, v835.Y - t1.value21.SilentFOV)
	else
		t1.value67.Visible = false
	end

	local SpeedHack = t1.value21.SpeedHack

	if SpeedHack then
		if vector3New then
			if Character then
				SpeedHack = not t1.value35.Visible
			else
				SpeedHack = Character
			end
		else
			SpeedHack = vector3New
		end
	end

	if SpeedHack then
		SpeedHack = t1.value21.SpeedValue
		Character.WalkSpeed = tonumber(SpeedHack) or 32
		SpeedHack = Character.MoveDirection

		if SpeedHack.Magnitude > 0 then
			v828 = t1.value21.SpeedValue
			v828 = (tonumber(v828) or 32) - 16
			v828 = math.max(0, v828)

			if v828 > 0 then
				vector3New.CFrame = vector3New.CFrame + SpeedHack.Unit * (v828 * dt)
			end
		end
	end

	local FlyHack = t1.value21.FlyHack

	if FlyHack then
		if vector3New then
			FlyHack = Character and CurrentCamera
		else
			FlyHack = vector3New
		end
	end

	local value87

	if FlyHack then
		if not t1.value87 or t1.value87.Parent ~= vector3New then
			if t1.value87 then
				t1.value87:Destroy()
			end

			t1.value87 = Instance.new("BodyVelocity")
			t1.value87.Velocity = Vector3.zero
			t1.value87.MaxForce = Vector3.new(9000000000, 9000000000, 9000000000)
			t1.value87.Parent = vector3New
			FieldOfView = t1.value17
			value87 = t1.value87
			table.insert(FieldOfView, value87)
		end

		if not t1.value88 or t1.value88.Parent ~= vector3New then
			if t1.value88 then
				t1.value88:Destroy()
			end

			t1.value88 = Instance.new("BodyGyro")
			t1.value88.MaxTorque = Vector3.new(9000000000, 9000000000, 9000000000)
			t1.value88.Parent = vector3New
			FieldOfView = t1.value17
			value87 = t1.value88
			table.insert(FieldOfView, value87)
		end

		FlyHack = CurrentCamera.CFrame
		SpeedHack = Vector3.zero

		if t1.value3:IsKeyDown(Enum.KeyCode.W) then
			SpeedHack = SpeedHack + FlyHack.LookVector
		end

		if t1.value3:IsKeyDown(Enum.KeyCode.S) then
			SpeedHack = SpeedHack - FlyHack.LookVector
		end

		if t1.value3:IsKeyDown(Enum.KeyCode.A) then
			SpeedHack = SpeedHack - FlyHack.RightVector
		end

		if t1.value3:IsKeyDown(Enum.KeyCode.D) then
			SpeedHack = SpeedHack + FlyHack.RightVector
		end

		if t1.value3:IsKeyDown(Enum.KeyCode.Space) then
			SpeedHack = SpeedHack + Vector3.new(0, 1, 0)
		end

		if t1.value3:IsKeyDown(Enum.KeyCode.LeftShift) then
			SpeedHack = SpeedHack - Vector3.new(0, 1, 0)
		end

		t1.value88.CFrame = FlyHack
		FlyHack = t1.value87
		v830 = "Velocity"

		if SpeedHack.Magnitude > 0 then
			SpeedHack = SpeedHack.Unit * t1.value21.FlySpeed
		else
			SpeedHack = false
		end

		FlyHack[v830] = SpeedHack or Vector3.zero
	else
		if t1.value87 then
			t1.value87:Destroy()
		end

		if t1.value88 then
			t1.value88:Destroy()
		end
	end

	local Fullbright = t1.value21.Fullbright

	if Fullbright then
		Fullbright = tick() - (t1.value34.lastFullbrightCheck or 0) >= 1
	end

	if Fullbright then
		t1.value34.lastFullbrightCheck = tick()
		t1.value9.Brightness = 2
		t1.value9.ClockTime = 14
		t1.value9.GlobalShadows = false
		t1.value9.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
	end

	Fullbright = t1.value21.NoFog

	if Fullbright then
		Fullbright = tick() - (t1.value34.lastNoFogCheck or 0) >= 1
	end

	if Fullbright then
		t1.value34.lastNoFogCheck = tick()
		Fullbright = function()
			t1.value9.FogEnd = 100000

			local ipairs_ = ipairs
			local value9 = t1.value9

			for _, child in ipairs_(value9.GetChildren(value9)) do
				if child:IsA("Atmosphere") then
					child.Density = 0
				elseif child:IsA("PostEffect") and not child.Name:find("Teleporting") then
					child.Enabled = false
				end
			end
		end
		pcall(Fullbright)
	end

	Fullbright = t1.value21.CustomFOV

	if Fullbright then
		if CurrentCamera then
			Fullbright = t1.value21.AimbotScopeOnly

			if Fullbright then
				Fullbright = t1.value3:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
			end

			Fullbright = not Fullbright
		else
			Fullbright = CurrentCamera
		end
	end

	if Fullbright then
		Fullbright = t1.value21.FOVValue
		CurrentCamera.FieldOfView = tonumber(Fullbright) or 90
	end

	Fullbright = t1.value21.BunnyHop

	if Fullbright then
		if Character then
			if vector3New then
				Fullbright = not t1.value35.Visible
			else
				Fullbright = vector3New
			end
		else
			Fullbright = Character
		end
	end

	if Fullbright and (t1.value3:IsKeyDown(Enum.KeyCode.Space) and (Character.FloorMaterial ~= Enum.Material.Air and tick() - t1.value39 > 0.08)) then
		Character.Jump = true
	end

	if (t1.value21.ThirdPerson or t1.value21.Freecam) and CurrentCamera and now then
		Fullbright = now.GetDescendants

		for _, v in ipairs(Fullbright(now)) do
			if v:IsA("BasePart") then
				v.LocalTransparencyModifier = 0
			end
		end
	end

	Fullbright = t1.value21.ThirdPerson

	if Fullbright then
		if vector3New then
			if Character then
				Character = not t1.value21.Freecam
			end
		else
			Character = vector3New
		end
	else
		Character = Fullbright
	end

	if Character then
		Fullbright = (now:FindFirstChild("Head") or vector3New).Position + Vector3.new(0, 0.5, 0)
		FlyHack = t1.value21.ThirdPersonDist
		FlyHack = tonumber(FlyHack) or 12
		FlyHack = -CurrentCamera.CFrame.LookVector * FlyHack
		SpeedHack = RaycastParams.new()
		SpeedHack.FilterDescendantsInstances = { now, CurrentCamera }
		SpeedHack.FilterType = Enum.RaycastFilterType.Exclude
		Character = t1.value2
		SpeedHack = Character.Raycast(Character, Fullbright, FlyHack, SpeedHack)

		if SpeedHack then
			SpeedHack = SpeedHack.Position + SpeedHack.Normal * 0.4
		end

		FlyHack = SpeedHack or Fullbright + FlyHack
		CurrentCamera.CFrame = CFrame.lookAt(FlyHack, Fullbright + CurrentCamera.CFrame.LookVector * 100)
	end

	local color

	if t1.value21.Freecam and CurrentCamera then
		if not t1.value38.enabled then
			t1.value38.enabled = true
			FieldOfView, value87 = CurrentCamera.CFrame:ToOrientation()
			t1.value38.rotX = FieldOfView
			t1.value38.rotY = value87
			t1.value38.pos = CurrentCamera.CFrame.Position
		end

		if vector3New then
			vector3New.Anchored = true
			vector3New.AssemblyLinearVelocity = Vector3.zero
			vector3New.AssemblyAngularVelocity = Vector3.zero
		end

		if t1.value35.Visible then
			t1.value3.MouseBehavior = Enum.MouseBehavior.Default
		else
			t1.value3.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
			FieldOfView = t1.value3:GetMouseDelta()

			if FieldOfView.Magnitude > 0 then
				value87 = t1.value38
				v849 = t1.value38.rotY
				color = FieldOfView.X * 0.25
				value87.rotY = v849 - math.rad(color)
				value87 = t1.value38
				v849 = t1.value38.rotX
				FieldOfView = FieldOfView.Y * 0.25
				FieldOfView = v849 - math.rad(FieldOfView)
				value87.rotX = math.clamp(FieldOfView, -1.5533430342749532, 1.5533430342749532)
			end
		end

		Fullbright = CFrame.Angles(0, t1.value38.rotY, 0) * CFrame.Angles(t1.value38.rotX, 0, 0)
		FlyHack = Vector3.zero

		if t1.value3:IsKeyDown(Enum.KeyCode.W) then
			FlyHack = FlyHack + Fullbright.LookVector
		end

		if t1.value3:IsKeyDown(Enum.KeyCode.S) then
			FlyHack = FlyHack - Fullbright.LookVector
		end

		if t1.value3:IsKeyDown(Enum.KeyCode.A) then
			FlyHack = FlyHack - Fullbright.RightVector
		end

		if t1.value3:IsKeyDown(Enum.KeyCode.D) then
			FlyHack = FlyHack + Fullbright.RightVector
		end

		if t1.value3:IsKeyDown(Enum.KeyCode.Space) then
			FlyHack = FlyHack + Vector3.new(0, 1, 0)
		end

		if t1.value3:IsKeyDown(Enum.KeyCode.LeftShift) then
			FlyHack = FlyHack - Vector3.new(0, 1, 0)
		end

		if FlyHack.Magnitude > 0 then
			t1.value38.pos = t1.value38.pos + FlyHack.Unit * (t1.value21.FreecamSpeed or 40) * dt
		end

		CurrentCamera.CFrame = CFrame.new(t1.value38.pos) * Fullbright
	elseif t1.value38.enabled then
		t1.value38.enabled = false
		t1.value3.MouseBehavior = Enum.MouseBehavior.Default

		if vector3New then
			vector3New.Anchored = false
		end
	end

	if t1.value21.AntiAim and vector3New then
		if t1.value21.AntiAimMode == "Spin" then
			FieldOfView = vector3New.CFrame
			value87 = CFrame.Angles
			v849 = t1.value21.AntiAimSpeed
			v849 = math.min(v849, 35) * dt * 60
			vector3New.CFrame = FieldOfView * value87(0, math.rad(v849), 0)
		elseif t1.value21.AntiAimMode == "Jitter" then
			FieldOfView = vector3New.CFrame
			value87 = CFrame.Angles
			v849 = math.random(-45, 45)
			vector3New.CFrame = FieldOfView * value87(0, math.rad(v849), 0)
		elseif t1.value21.AntiAimMode == "Backwards" then
			vector3New.CFrame = CFrame.lookAt(vector3New.Position, vector3New.Position - CurrentCamera.CFrame.LookVector)
		end
	end

	Fullbright = t1.value21.Aimbot

	if Fullbright then
		Fullbright = t1.value21.AimbotKeyMode == "Always" and true or t1.value85

		if Fullbright then
			Fullbright = not t1.value35.Visible
		end
	end

	if Fullbright then
		Fullbright = t1.value3:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) or CurrentCamera.FieldOfView < 70

		if now then
			now = now:GetAttribute("Reloading")
		end

		Fullbright = not t1.value21.AimbotScopeOnly or Fullbright

		if Fullbright then
			Fullbright = not (t1.value21.AimbotDisableReloading and now)
		end

		if Fullbright then
			Fullbright = t1.value21.AimbotVisibleOnly

			if Fullbright then
				Fullbright = not t1.value21.TrackThroughWalls
			end

			Fullbright = t1.value62(t1.value21.AimbotFOV, Fullbright, t1.value21.AimbotPart)

			if Fullbright and CurrentCamera then
				Fullbright = Fullbright.Position

				if t1.value21.InstantCameraLock then
					CurrentCamera.CFrame = CFrame.lookAt(CurrentCamera.CFrame.Position, Fullbright)
				else
					FieldOfView, value87 = CurrentCamera:WorldToViewportPoint(Fullbright)

					if value87 then
						value87 = FieldOfView.Z > 0
					end

					if value87 then
						value87 = t1.value3:GetMouseLocation()
						v849 = FieldOfView.X - value87.X
						FieldOfView = FieldOfView.Y - value87.Y
						value87 = t1.value21.AimbotSmoothing
						value87 = tonumber(value87) or 0.28
						value87 = math.clamp(value87, 0.02, 1)

						if mousemoverel then
							mousemoverel(v849 * value87, FieldOfView * value87)
						else
							color = mouse_move

							if typeof(color) == "function" then
								mouse_move(v849 * value87, FieldOfView * value87)
							else
								FieldOfView = CurrentCamera.CFrame
								v849 = CFrame.lookAt(FieldOfView.Position, Fullbright)
								value87 = value87 * 45 * dt
								CurrentCamera.CFrame = FieldOfView:Lerp(v849, unpack_({ math.clamp(value87, 0.05, 1) }))
							end
						end
					else
						FieldOfView = CurrentCamera.CFrame
						CurrentCamera.CFrame = FieldOfView:Lerp(CFrame.lookAt(FieldOfView.Position, Fullbright), math.clamp(t1.value21.AimbotSmoothing * 45 * dt, 0.05, 1))
					end
				end
			end
		end
	end

	Fullbright = nil
	FlyHack = t1.value21.TargetVisualizer

	if not FlyHack then
		FlyHack = not v8()

		if FlyHack then
			FlyHack = t1.value41()
		end
	end

	if FlyHack then
		Fullbright = t1.value62(1000, false, "Head", "Distance")
	end

	if Fullbright then
		FlyHack = Fullbright.Parent
	else
		FlyHack = Fullbright
	end

	if FlyHack then
		Fullbright = Fullbright.Parent
		FlyHack = Fullbright:FindFirstChildOfClass("Humanoid")
		SpeedHack = Fullbright:FindFirstChild("HumanoidRootPart")

		if FlyHack then
			if FlyHack.Health > 0 then
				now = SpeedHack
			else
				now = false
			end
		else
			now = FlyHack
		end

		if now then
			t1.value34.activeChar = Fullbright
			t1.value34.activeHum = FlyHack
			t1.value34.activeRoot = SpeedHack
			t1.value34.activePlayer = t1.value1:GetPlayerFromCharacter(Fullbright)
		else
			t1.value34.activeChar = nil
			t1.value34.activeHum = nil
			t1.value34.activeRoot = nil
			t1.value34.activePlayer = nil
		end
	else
		t1.value34.activeChar = nil
		t1.value34.activeHum = nil
		t1.value34.activeRoot = nil
		t1.value34.activePlayer = nil
	end

	Fullbright = t1.value21.TargetVisualizer

	if Fullbright then
		Fullbright = t1.value21.TargetVisualizerHUD

		if Fullbright then
			Fullbright = t1.value34.activePlayer and t1.value34.activeHum

			if Fullbright then
				Fullbright = t1.value34.activeHum.Health > 0
			end
		end
	end

	if Fullbright then
		if t1.value34.hudTitle then
			Fullbright = t1.value34.hudTitle
			FlyHack = string.format
			SpeedHack = t1.value34.activeHum.Health
			SpeedHack = math.floor(SpeedHack)
			now = t1.value34.activeHum.MaxHealth
			Fullbright.Text = FlyHack("Target  -  %d/%d", SpeedHack, (math.floor(now)))
		end

		if t1.value34.lastTargetUserId ~= t1.value34.activePlayer.UserId then
			t1.value34.lastTargetUserId = t1.value34.activePlayer.UserId

			if t1.value34.hudAvatar then
				t1.value34.hudAvatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. t1.value34.activePlayer.UserId .. "&w=100&h=100"
			end

			if t1.value34.hudName then
				t1.value34.hudName.Text = t1.value34.activePlayer.DisplayName .. "  (@" .. t1.value34.activePlayer.Name .. ")"
			end
		end

		if t1.value34.hudHpFill then
			Fullbright = t1.value34.activeHum.Health
			FlyHack = t1.value34.activeHum.MaxHealth
			Fullbright = Fullbright / math.max(FlyHack, 1)
			Fullbright = math.clamp(Fullbright, 0, 1)
			t1.value34.hudHpFill.Size = UDim2.new(Fullbright, 0, 1, 0)
		end

		if t1.value34.hudFrame then
			t1.value34.hudFrame.Visible = true
		end
	elseif t1.value34.hudFrame then
		t1.value34.hudFrame.Visible = false
	end

	Fullbright = t1.value21.TargetVisualizer

	if Fullbright then
		Fullbright = t1.value21.TargetVisualizerPath

		if Fullbright then
			Fullbright = t1.value34.activeRoot

			if Fullbright then
				Fullbright = #t1.value34.cachedWaypoints >= 2
			end
		end
	end

	local RainbowGunSkin

	if Fullbright then
		Fullbright = t1.value34.cachedWaypoints
		FlyHack = #Fullbright - 1
		SpeedHack = #t1.value34.poolLines
		SpeedHack = math.min(FlyHack, SpeedHack)

		for i = 1, SpeedHack do
			v840 = Fullbright[i].Position
			v843 = Fullbright[i + 1].Position
			v842 = (v843 - v840).Magnitude
			v841 = t1.value34.poolLines[i]

			if v842 > 0.1 then
				v841.Size = Vector3.new(0.18, 0.06, v842)
				v841.CFrame = CFrame.lookAt((v840 + v843) * 0.5, v843)
				v841.Transparency = 0
			else
				v841.Transparency = 1
			end
		end

		for i = SpeedHack + 1, #t1.value34.poolLines do
			t1.value34.poolLines[i].Transparency = 1
		end

		local v665 = FlyHack
		local n8 = 0
		local n9 = 1
		local v668 = false

		SpeedHack = {}
		now = 0

		while true do
			n8 = n8 + n9
			vector3New = n8 <= FlyHack

			if (not v668 or FlyHack > n8) and (v668 or not vector3New) then
				break
			end

			FieldOfView = (Fullbright[n8 + 1].Position - Fullbright[n8].Position).Magnitude
			table.insert(SpeedHack, FieldOfView)
			now = now + FieldOfView
		end

		n8 = math.max
		n9 = t1.value21.VisualizerArrowSpacing
		n8 = n8(tonumber(n9) or 10, 5)
		n9 = math.max
		v668 = t1.value21.VisualizerArrowSpeed
		n9 = n9(tonumber(v668) or 14, 2)
		n9 = tick() * n9 % n8
		v668 = now / n8
		v668 = math.floor(v668) + 1
		FlyHack = #t1.value34.poolChevrons
		v668 = math.min(v668, 16, FlyHack)
		FlyHack = 1
		vector3New = FlyHack < 0
		Character = 1 - FlyHack
		RainbowGunSkin = v668

		local n10 = 1
		local n11 = 0

		color = 1.1

		while true do
			Character = Character + FlyHack
			v849 = not vector3New

			if v849 then
				v849 = Character <= v668
			end

			if (not vector3New or v668 > Character) and not v849 then
				break
			end

			v849 = (Character - 1) * n8 + n9

			if v849 <= now then
				color = v849 >= 0.5
			else
				color = false
			end

			if color then
				value87 = Character

				while true do
					if true then
						if n10 < v665 then
							FieldOfView = n11 + SpeedHack[n10] < v849
						else
							FieldOfView = false
						end
					end

					if not FieldOfView then
						break
					end

					n11 = n11 + SpeedHack[n10]
					n10 = n10 + 1
				end

				FieldOfView = SpeedHack[n10] or 1

				if FieldOfView > 0 then
					FieldOfView = (v849 - n11) / FieldOfView
				else
					FieldOfView = false
				end

				FieldOfView = Fullbright[n10].Position:Lerp(Fullbright[n10 + 1].Position, math.clamp(FieldOfView or 0, 0, 1))
				v849 = (Fullbright[n10 + 1].Position - Fullbright[n10].Position).Unit
				Character = t1.value34.poolChevrons[Character]
				FieldOfView = CFrame.lookAt(FieldOfView, FieldOfView + v849)
				Character.Left.CFrame = FieldOfView * CFrame.Angles(0, -2.443460952792061, 0) * CFrame.new(0, 0, color * 0.5)
				Character.Left.Size = Vector3.new(0.2, 0.08, color)
				Character.Left.Transparency = 0
				Character.Right.CFrame = FieldOfView * CFrame.Angles(0, 2.443460952792061, 0) * CFrame.new(0, 0, color * 0.5)
				Character.Right.Size = Vector3.new(0.2, 0.08, color)
				Character.Right.Transparency = 0
				Character = value87
			else
				t1.value34.poolChevrons[Character].Left.Transparency = 1
				t1.value34.poolChevrons[Character].Right.Transparency = 1
			end
		end

		for i = RainbowGunSkin + 1, #t1.value34.poolChevrons do
			t1.value34.poolChevrons[i].Left.Transparency = 1
			t1.value34.poolChevrons[i].Right.Transparency = 1
		end
	else
		FieldOfView, value87, v849 = ipairs(t1.value34.poolLines)

		while true do
			v849, color = FieldOfView(value87, v849)

			if not v849 then
				break
			end

			color.Transparency = 1
		end

		for _, poolChevron in ipairs(t1.value34.poolChevrons) do
			poolChevron.Left.Transparency = 1
			poolChevron.Right.Transparency = 1
		end
	end

	local AutomaticGuns = t1.value21.AutomaticGuns

	if AutomaticGuns then
		AutomaticGuns = t1.value3:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) and not t1.value35.Visible

		if AutomaticGuns then
			AutomaticGuns = t1.value41()
		end
	end

	if AutomaticGuns and tick() - t1.value40 >= 0.08 then
		t1.value58()
	end

	AutomaticGuns = t1.value2:FindFirstChild("ViewModels") or CurrentCamera

	if AutomaticGuns then
		color = t1.value21.RainbowGunSkin or (t1.value21.HideViewModel or (t1.value21.WeaponChams or (t1.value21.CustomViewModelFOV or (t1.value21.ViewModelXOffset ~= 0 or (t1.value21.ViewModelYOffset ~= 0 and true or t1.value21.ViewModelZOffset ~= 0)))))
	else
		color = AutomaticGuns
	end

	if color then
		AutomaticGuns = AutomaticGuns:FindFirstChild("FirstPerson") or AutomaticGuns
		color = tick() * 0.4 % 1
		color = Color3.fromHSV(color, 0.8, 1)

		for _, descendant in ipairs(AutomaticGuns.GetDescendants(AutomaticGuns)) do
			if descendant:IsA("BasePart") then
				if t1.value21.HideViewModel then
					descendant.Transparency = 1
				else
					RainbowGunSkin = t1.value21.RainbowGunSkin

					if RainbowGunSkin then
						RainbowGunSkin = descendant.Transparency < 1
					end

					if RainbowGunSkin then
						descendant.Color = color
					end

					RainbowGunSkin = t1.value21.WeaponChams

					if RainbowGunSkin then
						RainbowGunSkin = descendant.Transparency < 1
					end

					if RainbowGunSkin then
						descendant.Material = Enum.Material.Neon
						descendant.Color = t1.value22.AccentPink
					end
				end
			end
		end
	end

	pcall(function()
		if not t1.value21.ESP_Master then
			for _, v in pairs(t1.value78) do
				t1.value83(v)
			end

			return
		end

		local CFrame_ = t1.value14.CFrame
		local Position = CFrame_.Position
		local LookVector = CFrame_.LookVector
		local ESP_MaxDistance = t1.value21.ESP_MaxDistance
		local v683 = tonumber(ESP_MaxDistance) or 500
		local Character2 = t1.value13.Character

		if Character2 then
			Character2 = Character2:FindFirstChild("HumanoidRootPart")
		end

		local v685

		if Character2 then
			v685 = (Character2.Position - t1.value24).Magnitude < 450
		else
			v685 = false
		end

		if v685 then
			v683 = math.min(v683, 160)
		end

		local n12 = 4
		local n13 = 0
		local Character3 = t1.value13.Character

		if Character3 then
			Character3 = Character3:FindFirstChild("HumanoidRootPart")
		end

		local v689

		if Character3 then
			v689 = (Character3.Position - t1.value24).Magnitude < 450
		else
			v689 = false
		end

		local v690 = v689 and 2
		local Character4 = t1.value13.Character

		if Character4 then
			Character4 = Character4:FindFirstChild("HumanoidRootPart")
		end

		local v692

		if Character4 then
			v692 = (Character4.Position - t1.value24).Magnitude < 450
		else
			v692 = false
		end

		local v693 = LookVector
		local v694 = v690 or n12
		local v695 = v692 and 60 or 120

		for k, v in pairs(t1.value78) do
			local Character5 = k.Character
			local Humanoid

			if Character5 then
				Humanoid = Character5:FindFirstChildOfClass("Humanoid")
			else
				Humanoid = Character5
			end

			local HumanoidRootPart

			if Character5 then
				HumanoidRootPart = Character5:FindFirstChild("HumanoidRootPart")
			else
				HumanoidRootPart = Character5
			end

			local Head

			if Character5 then
				Head = Character5:FindFirstChild("Head") or (Character5:FindFirstChild("HitboxHead") or Character5:FindFirstChild("HitboxHeadSmall"))
			else
				Head = Character5
			end

			local v702 = v22(k)

			if v702 then
				if Character5 then
					if Humanoid then
						if HumanoidRootPart then
							if Head then
								v702 = Humanoid.Health > 0
							else
								v702 = Head
							end
						else
							v702 = HumanoidRootPart
						end
					else
						v702 = Humanoid
					end
				else
					v702 = Character5
				end
			end

			if v702 then
				local v703 = HumanoidRootPart.Position - Position
				local Magnitude = v703.Magnitude

				if v703:Dot(v693) <= 0 or v683 < Magnitude then
					t1.value83(v)
				else
					local v705 = Head.Position + Vector3.new(0, 0.8, 0)
					local v706 = HumanoidRootPart.Position - Vector3.new(0, 2.85, 0)
					local v707, v708 = t1.value14:WorldToViewportPoint(v705)
					local value14 = t1.value14
					local v710, v711 = value14.WorldToViewportPoint(value14, v706)
					local v712, v713 = t1.value14:WorldToViewportPoint(Head.Position)
					local v714 = t1.value14:WorldToViewportPoint(HumanoidRootPart.Position)
					local v715

					if v708 then
						if v711 then
							v715 = v707.Z > 0

							if v715 then
								v715 = v710.Z > 0
							end
						else
							v715 = v711
						end
					else
						v715 = v708
					end

					if v715 then
						v.isShown = true

						local v716 = v710.Y - v707.Y
						local v717 = math.abs(v716)
						local v718 = v717 * 0.65
						local Y = v707.Y
						local v720 = v714.X - v718 / 2

						if t1.value21.ESP_Boxes then
							v.box.Visible = true
							v.box.Size = UDim2.new(0, v718, 0, v717)
							v.box.Position = UDim2.new(0, v720, 0, Y)
						else
							v.box.Visible = false
						end

						if t1.value21.ESP_Names then
							v.nameLbl.Visible = true
							v.nameLbl.Position = UDim2.new(0, v714.X - 60, 0, Y - 16)
							v.nameLbl.Size = UDim2.new(0, 120, 0, 14)
						else
							v.nameLbl.Visible = false
						end

						if t1.value21.ESP_Distance then
							local v721 = Magnitude * 0.28
							local v722 = math.floor(v721)

							v.distLbl.Visible = true
							v.distLbl.Text = tostring(v722) .. "m"
							v.distLbl.Position = UDim2.new(0, v714.X - 30, 0, v710.Y + 2)
							v.distLbl.Size = UDim2.new(0, 60, 0, 14)
						else
							v.distLbl.Visible = false
						end

						local ESP_Weapon = t1.value21.ESP_Weapon

						if ESP_Weapon then
							ESP_Weapon = v.weapLbl
						end

						if ESP_Weapon then
							v.weapLbl.Visible = true
							v.weapLbl.Text = t1.value84(Character5)

							local weapLbl = v.weapLbl
							local s7 = "Position"
							local uDim2New = UDim2.new
							local n14 = 0
							local v728 = v714.X - 60
							local n15 = 0
							local ESP_Distance = t1.value21.ESP_Distance

							if ESP_Distance then
								ESP_Distance = v710.Y + 16
							end

							weapLbl[s7] = uDim2New(n14, v728, n15, ESP_Distance or v710.Y + 2)
						elseif v.weapLbl then
							v.weapLbl.Visible = false
						end

						if t1.value21.ESP_HealthBar then
							v.healthBg.Visible = true

							local v731 = Humanoid.Health / Humanoid.MaxHealth
							local v732 = math.clamp(v731, 0, 1)

							v.healthFill.Size = UDim2.new(1, 0, v732, 0)
						else
							v.healthBg.Visible = false
						end

						local ESP_HeadDot = t1.value21.ESP_HeadDot

						if ESP_HeadDot then
							if v713 then
								v713 = v712.Z > 0
							end
						else
							v713 = ESP_HeadDot
						end

						if v713 then
							v.headDot.Visible = true
							v.headDot.Position = UDim2.new(0, v712.X, 0, v712.Y)
						else
							v.headDot.Visible = false
						end

						if t1.value21.ESP_Chams then
							v.highlight.Enabled = true
							v.highlight.Adornee = Character5
						else
							v.highlight.Enabled = false
						end
					else
						t1.value83(v)
					end

					local ESP_Skeleton = t1.value21.ESP_Skeleton

					if ESP_Skeleton then
						local skeletonLines = v.skeletonLines

						if skeletonLines then
							local v736 = Magnitude <= v695

							if v736 then
								if v708 then
									if v711 then
										v708 = n13 < v694
									else
										v708 = v711
									end
								end
							else
								v708 = v736
							end
						else
							v708 = skeletonLines
						end
					else
						v708 = ESP_Skeleton
					end

					if v708 then
						n13 = n13 + 1

						local v737

						if Character5.FindFirstChild(Character5, "UpperTorso") == nil then
							v737 = false
						else
							v737 = t1.value77
						end

						local value79 = v737 or t1.value79

						for i, v2 in ipairs(value79) do
							local v741 = v.skeletonLines[i]
							local v742 = Character5:FindFirstChild(v2[1])
							local v743 = Character5:FindFirstChild(v2[2])
							local v744

							if v742 then
								v744 = v743 and v741
							else
								v744 = v742
							end

							if v744 then
								local v745, v746 = t1.value14:WorldToViewportPoint(v742.Position)
								local v747, v748 = t1.value14:WorldToViewportPoint(v743.Position)
								local v749 = v746 or v748

								if v749 then
									if v745.Z > 0 then
										v749 = v747.Z > 0
									else
										v749 = false
									end
								end

								if v749 then
									t1.value80(v741, Vector2.new(v745.X, v745.Y), Vector2.new(v747.X, v747.Y), 1.2, t1.value22.AccentPinkLight)
								else
									v741.Visible = false
								end
							elseif v741 then
								v741.Visible = false
							end
						end

						for i = #value79 + 1, #v.skeletonLines do
							if v.skeletonLines[i] then
								v.skeletonLines[i].Visible = false
							end
						end
					elseif v.skeletonLines then
						for _, skeletonLine in ipairs(v.skeletonLines) do
							skeletonLine.Visible = false
						end
					end

					local ESP_Tracers = t1.value21.ESP_Tracers

					if ESP_Tracers then
						local tracerLine = v.tracerLine

						if tracerLine then
							local v755 = Magnitude <= 350

							if v755 then
								if v710 then
									if v710.Z <= 0 then
										v711 = false
									end
								else
									v711 = v710
								end
							else
								v711 = v755
							end
						else
							v711 = tracerLine
						end
					else
						v711 = ESP_Tracers
					end

					if v711 then
						local ViewportSize = t1.value14.ViewportSize
						local vector2 = Vector2.new(ViewportSize.X * 0.5, ViewportSize.Y)
						local vector22 = Vector2.new(v714.X, v710.Y)

						t1.value80(v.tracerLine, vector2, vector22, 1.2, t1.value22.AccentPink)
					elseif v.tracerLine then
						v.tracerLine.Visible = false
					end
				end
			else
				t1.value83(v)
			end
		end
	end)
end))
table.insert(t1.value16, getgenv_.Stepped:Connect(function()
	if not t1.value15 then
		return
	end

	local Character = t1.value13.Character

	if not (t1.value21.Noclip and Character) then
		return
	end

	for _, descendant in ipairs(Character:GetDescendants()) do
		local isBasePart = descendant:IsA("BasePart")

		if isBasePart then
			isBasePart = descendant.CanCollide
		end

		if isBasePart then
			descendant.CanCollide = false
		end
	end
end))
task.spawn(function()
	t1.value28()

	local t12 = {}
	local t13 = {}
	local t14 = {}

	while t1.value15 do
		local function v766()
			local value6 = t1.value6
			local Remotes = value6:FindFirstChild("Remotes")
			local Duels

			if Remotes then
				Duels = Remotes:FindFirstChild("Duels")
			else
				Duels = Remotes
			end

			if Remotes then
				Remotes = Remotes:FindFirstChild("Matchmaking")
			end

			local AutoRespawn = t1.value21.AutoRespawn

			if AutoRespawn then
				if Duels then
					AutoRespawn = Duels:FindFirstChild("RespawnNow")
				else
					AutoRespawn = Duels
				end
			end

			if AutoRespawn then
				value6 = Duels.RespawnNow
				value6:FireServer()
			end

			local AutoQueue = t1.value21.AutoQueue

			if AutoQueue then
				if Remotes then
					AutoQueue = Remotes:FindFirstChild("JoinQueue")
				else
					AutoQueue = Remotes
				end
			end

			if AutoQueue then
				local QueueMode = t1.value21.QueueMode or "1v1"

				value6 = task.spawn
				value6(function()
					local function v773()
						Remotes.JoinQueue:InvokeServer(QueueMode)
					end

					pcall(v773)
				end)
			end

			if t1.value21.AutoVoteMaps or t1.value21.AutoBanWeapons then
				local Vote

				if Duels then
					Vote = Duels:FindFirstChild("Vote")
				else
					Vote = Duels
				end

				if Vote then
					if t1.value21.AutoVoteMaps then
						local match = string.split(t1.value21.MapPriority or "Arena", ",")[1]:match("^%s*(.-)%s*$")

						pcall(function()
							Duels.Vote:FireServer("Map", match or "Arena")
						end)
						pcall(function()
							Duels.Vote:FireServer(match or "Arena")
						end)
					end

					if t1.value21.AutoBanWeapons then
						local match = string.split(t1.value21.WeaponBanPriority or "Grenade Launcher", ",")[1]:match("^%s*(.-)%s*$")

						pcall(function()
							Duels.Vote:FireServer("Weapon", match or "Grenade Launcher")
						end)
						pcall(function()
							Duels.Vote:FireServer(match or "Grenade Launcher")
						end)
					end
				end

				local function v777()
					local Modules = t1.value13.PlayerScripts:FindFirstChild("Modules")

					if Modules then
						Modules = t1.value13.PlayerScripts.Modules:FindFirstChild("Pages")
					end

					if Modules then
						Modules = Modules:FindFirstChild("PickWeapons")
					end

					if not Modules then
						return
					end

					local module = require(Modules)
					local _is_open

					if module then
						_is_open = module._is_open
					else
						_is_open = module
					end

					if not _is_open then
						return
					end

					local AutoVoteMaps = t1.value21.AutoVoteMaps

					if AutoVoteMaps then
						AutoVoteMaps = module.MapFrame
					end

					if AutoVoteMaps then
						local ipairs_ = ipairs
						local MapFrame = module.MapFrame

						for _, descendant in ipairs_(MapFrame.GetDescendants(MapFrame)) do
							local isTextButton = descendant:IsA("TextButton") or descendant:IsA("ImageButton")

							if isTextButton then
								isTextButton = getconnections
							end

							if isTextButton then
								ipairs_ = ipairs

								for _, v in ipairs_(getconnections(descendant.MouseButton1Click) or {}) do
									ipairs_ = v:Fire()
								end
							end
						end
					end

					local AutoBanWeapons = t1.value21.AutoBanWeapons

					if AutoBanWeapons then
						AutoBanWeapons = module._ban_frames
					end

					if not AutoBanWeapons then
						return
					end

					for _, banFrame in pairs(module._ban_frames) do
						if typeof(banFrame) == "Instance" then
							local GetDescendants = banFrame.GetDescendants

							for _, v in ipairs(GetDescendants(banFrame)) do
								local isImageButton = not v:IsA("TextButton") and v:IsA("ImageButton")

								if isImageButton then
									isImageButton = getconnections
								end

								if isImageButton then
									for _, v2 in ipairs(getconnections(v.MouseButton1Click) or {}) do
										v2:Fire()
									end
								end
							end
						end
					end
				end

				value6 = pcall
				value6(v777)
			end

			local AutoLoadout = t1.value21.AutoLoadout

			if AutoLoadout then
				if Duels then
					AutoLoadout = Duels:FindFirstChild("PickWeaponsAheadOfTime")
				else
					AutoLoadout = Duels
				end
			end

			if AutoLoadout then
				value6 = Duels.PickWeaponsAheadOfTime
				value6:FireServer()
			end

			if t1.value21.HackerDetector then
				local SpeedThreshold = t1.value21.SpeedThreshold
				local v800 = tonumber(SpeedThreshold) or 180
				local v801 = tonumber(t1.value21.SpeedDuration) or 0.75
				local ipairs_ = ipairs
				local value1 = t1.value1

				for _, player in ipairs_(value1.GetPlayers(value1)) do
					local v806

					if player == t1.value13 then
						v806 = false
					else
						v806 = player.Character
					end

					if v806 then
						local HumanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")

						if HumanoidRootPart then
							local Magnitude = HumanoidRootPart.AssemblyLinearVelocity.Magnitude

							if v800 < Magnitude then
								if t12[player] then
									if v801 <= tick() - t12[player] and (not t13[player] or tick() - t13[player] > 12) then
										t13[player] = tick()

										if t1.value21.NotifyHackers then
											t1.value33("MALAPHAS", "Hacker Flag: " .. player.DisplayName .. " (" .. math.floor(Magnitude) .. " studs/s)", "WARN", 3.5)
										end

										local HackerAutoLoad = t1.value21.HackerAutoLoad

										if HackerAutoLoad then
											HackerAutoLoad = t1.value21.HackerProfile

											if HackerAutoLoad then
												HackerAutoLoad = t1.value21.HackerProfile ~= ""
											end
										end

										if HackerAutoLoad then
											local match = t1.value21.HackerProfile:match("^%s*(.-)%s*$")
											local value66 = t1.value66

											if value66 then
												value66 = t1.value66.current ~= match
											end

											if value66 and t1.value66.applyProfile(match, false) then
												t1.value33("MALAPHAS", "Hacker detected! Loaded profile: " .. match, "SUCCESS", 3.5)
											end
										end
									end
								else
									t12[player] = tick()
								end
							else
								t12[player] = nil
							end
						end
					end
				end
			end

			local BasePart, v813

			if not t1.value21.ModDetector then
				if not t1.value21.AutoPickup then
					return
				end

				v995 = t1.value13.Character

				if v995 then
					v995 = v995:FindFirstChild("HumanoidRootPart")
				end

				if not v995 then
					return
				end

				v996 = ipairs
				v997 = t1.value2

				for _, child in v996(v997.GetChildren(v997)) do
					if child.Name:find("Drop") or (child.Name:find("Tripmine") or child.Name:find("Ammo")) then
						BasePart = child.IsA(child, "BasePart") and child or child:FindFirstChildWhichIsA("BasePart")

						if BasePart then
							v813 = (BasePart.Position - v995.Position).Magnitude <= t1.value21.PickupRadius
						else
							v813 = BasePart
						end

						if v813 and firetouchinterest then
							firetouchinterest(v995, BasePart, false)
							firetouchinterest(v995, BasePart, true)
						end
					end
				end

				return
			end

			local MinGroupRank = t1.value21.MinGroupRank
			local v817 = tonumber(MinGroupRank) or 200
			local ipairs_ = ipairs
			local value1 = t1.value1

			for _, player in ipairs_(value1.GetPlayers(value1)) do
				local v822

				if player == t1.value13 then
					v822 = false
				else
					v822 = not t14[player]
				end

				if v822 then
					local v823 = false
					local attribute = player:GetAttribute("GroupRank")

					if not attribute then
						pcall(function()
							local v825 = player
							local CreatorId

							if game.CreatorId > 0 then
								CreatorId = game.CreatorId
							else
								CreatorId = false
							end

							attribute = v825:GetRankInGroup(CreatorId or 16124806)
						end)
					end

					if attribute then
						local v827 = v817 <= attribute
					end

					local v829 = v991 and true or v823
					local v831 = not v829

					if v831 then
						v831 = t1.value21.ModUsernames

						if v831 then
							v831 = t1.value21.ModUsernames ~= ""
						end
					end

					if v831 then
						for match in t1.value21.ModUsernames:gmatch("[^,%s]+") do
							if player.Name:lower() == match:lower() and true or player.DisplayName:lower() == match:lower() then
								v829 = true

								break
							end
						end
					end

					if v829 then
						t14[player] = true

						if t1.value21.NotifyMods then
							t1.value33("MALAPHAS", "STAFF / MOD DETECTED: " .. player.DisplayName .. " (Rank: " .. tostring(attribute or "Staff") .. ")", "ERROR", 5)
						end
					end
				end
			end

			if not t1.value21.AutoPickup then
				return
			end

			local Character = t1.value13.Character

			if Character then
				Character = Character:FindFirstChild("HumanoidRootPart")
			end

			if not Character then
				return
			end

			local ipairs_2 = ipairs
			local value2 = t1.value2

			for _, child in ipairs_2(value2.GetChildren(value2)) do
				if child.Name:find("Drop") or (child.Name:find("Tripmine") or child.Name:find("Ammo")) then
					BasePart = child.IsA(child, "BasePart") and child or child:FindFirstChildWhichIsA("BasePart")

					if BasePart then
						v813 = (BasePart.Position - Character.Position).Magnitude <= t1.value21.PickupRadius
					else
						v813 = BasePart
					end

					if v813 and firetouchinterest then
						firetouchinterest(Character, BasePart, false)
						firetouchinterest(Character, BasePart, true)
					end
				end
			end
		end

		pcall(v766)
		task.wait(1)
	end
end)
t1.value43(true)
t1.value33("MALAPHAS", "MALAPHAS loaded successfully.", "SUCCESS", 4)
