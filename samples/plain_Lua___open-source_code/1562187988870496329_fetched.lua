loadstring(game:HttpGet("https://raw.githubusercontent.com/VoxlarWIP/p/refs/heads/main/PerplexWare_Keysystem.lua"))()

loadstring(game:HttpGet("https://pastefy.app/9jxnhnM3/raw"))()

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local tbl

tbl = {
	Players = game:GetService("Players"),
	UserInputService = game:GetService("UserInputService"),
	Lighting = game:GetService("Lighting"),
	RunService = game:GetService("RunService"),
	CoreGui = game:GetService("CoreGui"),
	ReplicatedStorage = game:GetService("ReplicatedStorage"),
	VirtualInputManager = game:GetService("VirtualInputManager"),
	VirtualUser = game:GetService("VirtualUser"),
	HttpService = game:GetService("HttpService"),
	Stats = game:GetService("Stats"),
	Workspace = game:GetService("Workspace"),
	TeleportService = game:GetService("TeleportService"),
	GuiService = game:GetService("GuiService"),
	RbxAnalytics = game:GetService("RbxAnalyticsService"),
	LocalPlayer = game:GetService("Players").LocalPlayer,
	Terrain = game:GetService("Workspace").Terrain,
	Camera = workspace.CurrentCamera,
}

local Debris
Debris = game:GetService("Debris")
local remotes
remotes = tbl.ReplicatedStorage:WaitForChild("Remotes", 10)
local repairEvent, skillCheckResultEvent
local generator = remotes and remotes:FindFirstChild("Generator")
repairEvent = generator and generator:FindFirstChild("RepairEvent")
skillCheckResultEvent = generator and generator:FindFirstChild("SkillCheckResultEvent")
local parry, flag, expired, userThumbnailAsync, tbl2, tbl3, tbl4, tbl5, tbl6, tbl7
local tbl8, tbl9, str, v, humanoidRootPart, humanoid, tbl10, lib, str2, verifyKeyAccess
local _playerCache
local sendNotif, tbl11, refreshPlayerList, initCharacter, getTeamRole, isPlayerKiller, isPlayerSurvivor, getLocalRootPart, getDistanceTo, getNearestKillerDist
local isKnockedOrHooked, isIncapacitated, canSafeParry, teleportToExit, setSkipCutscene, setAutoPallet

do
	local palletDropEvent = remotes and remotes:FindFirstChild("Pallet") and remotes.Pallet:FindFirstChild("PalletDropEvent")
	parry = remotes and remotes:FindFirstChild("Items") and remotes.Items:FindFirstChild("Parrying Dagger") and remotes.Items["Parrying Dagger"]:FindFirstChild("parry")
	flag = false
	expired = "Unknown"
	userThumbnailAsync = tbl.Players:GetUserThumbnailAsync(tbl.LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)

	tbl2 = {
		icon = "",
		name = "PerplexWare",
		version = "V2.5 (เห้ยๆอย่ามา skid ของกู)",
		dc = "https://dsc.gg/PerplexWarehub/",
		tt = "ไม่มี (None)",
	}

	tbl3 = {
		AUTO_AutoSurvivor = false,
		AUTO_Generator = false,
		AUTO_LeaveDist = 45,
		TP_Offset = 5,
		Pistol_CustomSound = false,
		Pistol_SelectedSound = "Sound 1",
		ESP_Master = false,
		ESP_Player = false,
		ESP_Killer = false,
		ESP_SCP = false,
		ESP_Name = false,
		ESP_NameG = false,
		ESP_Outline = false,
		ESP_ItemIcon = false,
		ESP_MaxDistance = 200,
		ESP_Generator = false,
		ESP_Pallet = false,
		ESP_Hook = false,
		ESP_Gate = false,
		ESP_Window = false,
		ESP_KillerWarn = false,
		Killer_SpamHit = false,
		Killer_SpamHitRadius = 15,
		Killer_SpamHitDelay = 100,
		Killer_HitEspCircle = true,
		Killer_BreakSpeed = 1,
		Killer_BypassCarry = false,
		Killer_WalkSpeedToggle = false,
		Killer_WalkSpeed = 16,
		Killer_AttackMode = "BasicAttack",
		Killer_3rdPerson = false,
		Killer_CameraMode = "Classic",
		Killer_InfAbyssal = false,
		Killer_InfLunge = false,
		Killer_InfLungeV2 = false,
		Anti_Blind = false,
		Show_Stun = false,
		Surv_Parry = false,
		Surv_ParryV2 = false,
		Surv_ParryCircle = true,
		Surv_ParryAggressive = false,
		Surv_ParrySafety = false,
		Surv_ParryRadius = 15,
		Surv_AutoParry = false,
		Surv_ParryMethod = "Legit",
		ESP_Chroma = false,
		ESP_HighestGen = false,
		ESP_InjuredColor = true,
		Surv_PingParry = false,
		Surv_ParryFace = 0.7,
		Ignored_Skills_List = {},
		Surv_GodMode = false,
		Surv_SelfHeal = false,
		Surv_AuraHeal = false,
		Surv_AutoCancelGene = false,
		Surv_DoubleGen = false,
		Surv_AutoSprint = false,
		Surv_Bandage = false,
		Surv_SoundDbd = false,
		Surv_AutoSkillCheck = false,
		Surv_SkillCheckMode = "Legit",
		Surv_SkillFrequency = 10,
		Surv_SkillSpeed = 1,
		Surv_PerfectSkill = true,
		Surv_NoSkill = false,
		Surv_Perks = false,
		Surv_SpeedBoost = 1.1,
		Surv_VaultSpeed = 1.3,
		Surv_SpeedAfterVault = false,
		Surv_FastVault = false,
		Surv_PerfectVault = false,
		Surv_AutoCrouch = false,
		Surv_NoFall = false,
		Surv_AutoFlee = false,
		Surv_FleeDistance = 30,
		Surv_AutoPallet = false,
		Surv_AutoPalletRadius = 10,
		Surv_AutoPalletSM = true,
		Surv_AutoPalletSF = false,
		Surv_CrouchV = false,
		Surv_Spdb = false,
		Surv_QuickRecoveryCD = 15,
		Surv_FlowstateCD = 20,
		Surv_Fov = false,
		Surv_FOV_Value = 70,
		Aimbot_Enabled = false,
		Aimbot_ShowFOV = true,
		Aimbot_Radius = 150,
		Aimbot_MaxDist = 300,
		Aimbot_Smoothness = 0.5,
		Aimbot_Predict = 0.01,
		Aim_Silent = false,
		Aim_Lock = false,
		Predict = false,
		SmartPredict = false,
		AIM_TargetPart = "Torso",
		Pistol_Target = "Killer",
		Pistol_PredictLead = 3.5,
		Pistol_AimOffset = -1,
		Pistol_BlockKnocked = true,
		Pistol_FOVMode = false,
		Pistol_ShowFOV = false,
		Pistol_FOV = 150,
		Pistol_ShowLaser = true,
		Flash_Silent = false,
		Flash_YOffset = 8,
		Aim_SilentVeil = false,
		Veil_ShowFOV = true,
		Veil_LeadMultiplier = 1.7,
		Veil_FOV = 150,
		Veil_ShowLaser = true,
		SPEAR_Auto = false,
		SPEAR_Speed = 165,
		SPEAR_Gravity = workspace.Gravity * 0.5,
		SPEAR_MaxDist = 200,
		Crosshair_Enabled = false,
		Crosshair_Type = "Cross",
		Crosshair_Color = Color3.new(0, 1, 0),
		Crosshair_Size = 4,
		Crosshair_OffsetX = 0,
		Crosshair_OffsetY = 0,
		Misc_Invisible = false,
		Misc_FakeName = false,
		Misc_FakeAttributes = false,
		Misc_CopyAvatar = false,
		Misc_Noclip = false,
		Misc_FlyToggle = false,
		Misc_FlySpeed = 10,
		Misc_HighJump = false,
		Misc_JumpPower = 50,
		Misc_InfJump = false,
		Misc_InfiniteZoom = false,
		Misc_Fullbright = false,
		Misc_Potato = false,
		Misc_SkipCutscene = false,
		Misc_SmoothCam = false,
		Misc_CamHeight = -1,
		Misc_CamStiffness = 9.5,
		Misc_SmoothHDR = false,
		Next_Map = true,
	}

	tbl4 = {}
	tbl4.Level = tbl.LocalPlayer:GetAttribute("Level") or 0
	tbl4.Gears = tbl.LocalPlayer:GetAttribute("Gears") or 0
	tbl4.Screws = tbl.LocalPlayer:GetAttribute("Screws") or 0

	tbl5 = {
		["122812055447896"] = "Veil lunge",
		["133963973694098"] = "Mayers Basic",
		["117042998468241"] = "Mayers lunge",
		["135002183282873"] = "cure lunge",
		["121216847022485"] = "cure Basic",
		["132817836308238"] = "Jeff Basic",
		["129784271201071"] = "Jeff lunge",
		["82666958311998"] = "Jeff Frenzy",
		["78432063483146"] = "Abyssal Basic",
		["118907603246885"] = "Abyssal lunge",
		["139369275981139"] = "Jason Basic",
		["110355011987939"] = "Jason lunge",
		["111920872708571"] = "Masked Basic",
		["105374834496520"] = "Masked lunge",
		["138720291317243"] = "Masked Tony",
		["106871536134254"] = "Masked Alex",
		["130593238885843"] = "Masked Cobra",
		["115244153053858"] = "Masked Cobra lunge",
		["74968262036854"] = "Hidden Basic",
		["113255068724446"] = "Hidden lunge",
		["98163597193511"] = "Hidden S1",
		["80411309607666"] = "Abyssal S1",
	}

	tbl6 = {
		Unloaded = false,
		OriginalSpeed = 16,
		isPredicting = false,
		CutsceneConn = nil,
		CharCutscene = nil,
		FleeThread = nil,
		RandomMode_IsNormal = false,
		AutoSprintThread = nil,
		OriginalLighting = nil,
		CurrentPing = 0,
		QuickRecoveryOnCD = false,
		FlowstateOnCD = false,
		HookF = false,
		Bandage = false,
		isAimLocking = false,
		currentTarget = nil,
		lockTimerThread = nil,
		lastNoclipChar = nil,
		lastUpdate = 0,
		ChromaHue = 0,
		KillerPosHistory = {},
		KillerVelocity = {},
		lastSpam = 0,
		spearSwitchCooldown = false,
		SpearModeConn = nil,
		StunConn = nil,
		CurrentTeleportGen = nil,
		CurrentTeleportPlayer = nil,
		CurrentTeleportHook = nil,
		CurrentTeleportGate = nil,
		KillerTarget = nil,
		SpamHit = nil,
		autoParry = nil,
		CrosshairUI = nil,
		WatermarkUI = nil,
		ItemESPs = {},
		FlyConnection = nil,
		FollowConnection = nil,
		InfiniteZoomConn = nil,
		ThirdPersonCamConn = nil,
		blockThread = nil,
		AutoPalletThread = nil,
		VaultBoostThread = nil,
		Pv2Con = nil,
		lungeV2Connection = nil,
		ParryCooldown = false,
		ParryCooldownTime = 50,
		RepairEngineRunning = false,
		VaultBoostActive = false,
		AutoFollow = false,
		isHoldingLunge = false,
		isAttackCd = false,
		isHolding = false,
		cachedNoclipParts = {},
		ActiveAnimations = {},
		SpooferConns = {},
		TeamConnections = {},
		DroppedPallets = {},
		TrackV2 = {},
		touchLunge = nil,
		currentTouch = nil,
		locked = nil,
	}

	tbl7 = {
		Colors = {
			SCP = Color3.fromRGB(150, 0, 255),
			Player = Color3.fromRGB(0, 255, 100),
			Killer = Color3.fromRGB(255, 0, 0),
			Generator = Color3.fromRGB(255, 255, 0),
			GeneratorDone = Color3.fromRGB(0, 255, 0),
			Pallet = Color3.fromRGB(255, 128, 0),
			Hook = Color3.fromRGB(255, 105, 180),
			Gate = Color3.fromRGB(255, 255, 255),
			Window = Color3.fromRGB(0, 150, 255),
			GeneratorDone = Color3.fromRGB(100, 255, 100),
			Injured = Color3.fromRGB(255, 180, 30),
		},
		Bones_R6 = {
			{ "Head", "Torso" },
			{ "Torso", "Left Arm" },
			{ "Torso", "Right Arm" },
			{ "Torso", "Left Leg" },
			{ "Torso", "Right Leg" },
		},
	}

	tbl8 = {
		isChargingSpear = false,
		isChargingPistol = false,
		isAimingFlash = false,
		currentTouchInput = nil,
		isAimbotHolding = false,
		lockedAimbotTarget = nil,
	}

	tbl9 = {
		Visibility = {},
		Generators = {},
		Pallets = {},
		Hooks = {},
		Gates = {},
		Windows = {},
		SCPs = {},
	}

	str = "Spectator"
	v = nil
	humanoidRootPart = nil
	humanoid = nil

	tbl10 = {
		WEB = "Built by https://perplexware.vercel.app",
		SCRIPT = "https://perplexware.vercel.app",
		keyFile = "VD_KeySave.txt",
		cache = "PerplexWareHub/Log/KeyCache.json",
		srvID = "0",
		plaS = "Huh?",
	}
	local function refreshMapData()
		local str3 = "Unknown"

		pcall(function()
			if gethwid then
				str3 = gethwid()
			else
				str3 = tbl.RbxAnalytics:GetClientId()
			end
		end)

		return str3
	end

	local v2 = refreshMapData()
	str2 = ""

	pcall(function()
		if isfile(tbl10.keyFile) then
			local v3 = readfile(tbl10.keyFile)

			if v3 then
				str2 = v3:match("^%s*(.-)%s*$") or v3
			end
		end
	end)

	local function toHex(arg)
		return (arg:gsub(".", function(arg2)
			return string.format("%02X", string.byte(arg2))
		end))
	end

	local function fromHex(arg)
		return (arg:gsub("..", function(arg2)
			return string.char(tonumber(arg2, 16))
		end))
	end

	local function setSmoothHDR(arg, arg2, arg3, arg4)
		local tbl12 = { key = arg, username = arg2, keyExpired = arg3, isVip = arg4, timestamp = os.time(), hwid = v2 }

		pcall(function()
			local json = tbl.HttpService:JSONEncode(tbl12)
			local v3 = toHex(json)
			writefile(tbl10.cache, v3)
		end)
	end

	local function blockWindowsPallets()
		if isfile(tbl10.cache) then
			local ok, result = pcall(function()
				local v3 = readfile(tbl10.cache)
				local v4 = fromHex(v3)
				return tbl.HttpService:JSONDecode(v4)
			end)

			if ok and result and type(result) == "table" then
				if result.hwid == v2 then
					return result
				end

				pcall(function()
					delfile(tbl10.cache)
				end)

				return nil
			end

			pcall(function()
				delfile(tbl10.cache)
			end)
		end

		return nil
	end

	verifyKeyAccess = function(arg)
		flag = true
		expired = "Trial"
		return true, "Trial for Free", expired
	end


	sendNotif = function(arg, arg2, arg3)
		pcall(function()
			if getgenv().VindUI then
				getgenv().VindUI:Notify({ Title = "PerplexWare", Text = tostring(arg), Type = "info", Duration = arg2 or 3 })
			end
		end)
	end

	tbl11 = {}
	_playerCache = {}

	refreshPlayerList = function()
		table.clear(tbl11)
		for _, player in ipairs(tbl.Players:GetPlayers()) do
			if player ~= tbl.LocalPlayer then table.insert(tbl11, player) end
		end
	end

	local function cacheCharacter(player, character)
		local cache = _playerCache[player]
		if not cache then return end
		if character then
			local h = character:FindFirstChildOfClass("Humanoid")
			cache.character = character
			cache.hrp = character:FindFirstChild("HumanoidRootPart")
			cache.humanoid = h
			cache.animator = h and h:FindFirstChildOfClass("Animator")
			if h then
				h.ChildAdded:Connect(function(child)
					if child:IsA("Animator") then
						local c2 = _playerCache[player]
						if c2 then c2.animator = child end
					end
				end)
			end
		else
			cache.character = nil
			cache.hrp = nil
			cache.humanoid = nil
			cache.animator = nil
		end
	end

	local function playerIsKiller(player)
		return player.Team ~= nil and player.Team.Name == "Killer"
	end

	local function onPlayerAdded(player)
		if player == tbl.LocalPlayer then return end
		_playerCache[player] = { isKiller = playerIsKiller(player) }
		table.insert(tbl11, player)
		player:GetPropertyChangedSignal("Team"):Connect(function()
			local c = _playerCache[player]
			if c then c.isKiller = playerIsKiller(player) end
		end)
		player.CharacterAdded:Connect(function(ch) cacheCharacter(player, ch) end)
		player.CharacterRemoving:Connect(function() cacheCharacter(player, nil) end)
		if player.Character then cacheCharacter(player, player.Character) end
	end

	local function onPlayerRemoving(player)
		_playerCache[player] = nil
		refreshPlayerList()
	end

	for _, player in ipairs(tbl.Players:GetPlayers()) do onPlayerAdded(player) end
	tbl.Players.PlayerAdded:Connect(onPlayerAdded)
	tbl.Players.PlayerRemoving:Connect(onPlayerRemoving)

	initCharacter = function(arg)
		v = arg
		humanoidRootPart = arg:WaitForChild("HumanoidRootPart", 3)
		humanoid = arg:WaitForChild("Humanoid", 3)

		if humanoid then
			tbl6.OriginalSpeed = humanoid.WalkSpeed
		end

		if tbl6.TeamLabel then
			pcall(function()
				tbl6.TeamLabel:Set("Team: " .. (tbl6.cachedRole or str or "Unknown"))
			end)
		end
	end

	getTeamRole = function()
		return str
	end

	isPlayerKiller = function(arg)
		return arg and arg.Team and arg.Team.Name == "Killer"
	end

	isPlayerSurvivor = function(arg)
		return arg and arg.Team and arg.Team.Name == "Survivors"
	end

	getLocalRootPart = function()
		return humanoidRootPart
	end

	getDistanceTo = function(arg)
		local selfHrp = humanoidRootPart
		if not selfHrp then return math.huge end
		return (arg - selfHrp.Position).Magnitude
	end

	getNearestKillerDist = function()
		local selfHrp = humanoidRootPart
		if not selfHrp then return math.huge end
		local selfPos = selfHrp.Position
		local minDist = math.huge
		for _, cache in pairs(_playerCache) do
			if cache.isKiller and cache.hrp and cache.hrp.Parent then
				local d = (cache.hrp.Position - selfPos).Magnitude
				if d < minDist then minDist = d end
			end
		end
		return minDist
	end

	isKnockedOrHooked = function(arg)
		if not arg then
			return false
		end
		return arg:GetAttribute("Knocked") == true or arg:GetAttribute("IsHooked") == true
	end

	isIncapacitated = function(arg)
		if not arg then
			return true
		end
		local playerFromCharacter = tbl.Players:GetPlayerFromCharacter(arg)
		if playerFromCharacter and playerFromCharacter:GetAttribute("IsDead") then
			return true
		end

		if arg:GetAttribute("IsCarried") or arg:GetAttribute("IsHooked") or arg:GetAttribute("Knocked") then
			return true
		end
		local checkInterractable = arg:FindFirstChild("CheckInterractable")

		if checkInterractable then
			for _, v3 in ipairs({
				"isVaulting",
				"isSliding",
				"isDroppingPallet",
				"isRepairing",
				"isHealing",
				"isUnhooking",
				"isExiting",
			}) do
				if checkInterractable:GetAttribute(v3) == true then
					return true
				end
			end
		end

		return false
	end

	canSafeParry = function(arg)
		if not tbl3.Surv_ParrySafety then
			return true
		end

		if not arg then
			return false
		end
		local checkInterractable = arg:FindFirstChild("CheckInterractable")

		if checkInterractable then
			if checkInterractable:GetAttribute("isVaulting") == true then
				return false
			end

			if checkInterractable:GetAttribute("isRepairing") == true then
				return false
			end

			if checkInterractable:GetAttribute("isUnhooking") == true then
				return false
			end

			if checkInterractable:GetAttribute("isHealing") == true then
				return false
			end

			if checkInterractable:GetAttribute("isSliding") == true then
				return false
			end
		end

		return true
	end

	teleportToExit = function()
		local v3 = getLocalRootPart()
		local map = tbl.Workspace:FindFirstChild("Map")
		if not v3 or not map then
			return false
		end
		local position = nil

		pcall(function()
			for _, descendant in ipairs(map:GetDescendants()) do
				local v4 = string.lower(descendant.Name)

				if v4 == "fininshline" or v4 == "finishline" or string.find(v4, "finish") then
					if descendant:IsA("BasePart") then
						position = descendant.Position
						break
					elseif descendant:IsA("Model") then
						local basePart = descendant:FindFirstChildWhichIsA("BasePart")
						if basePart then
							position = basePart.Position
							break
						end
					end
				end
			end

			if not position then
				if map:FindFirstChild("RooftopHitbox") or map:FindFirstChild("Rooftop") then
					position = Vector3.new(3098.16, 454.04, -4918.74)
				elseif map:FindFirstChild("HooksMeat") then
					position = Vector3.new(1546.12, 152.21, -796.72)
				elseif map:FindFirstChild("churchbell") then
					position = Vector3.new(760.98, -20.14, -78.48)
				else
					for _, descendant in ipairs(map:GetDescendants()) do
						if descendant:IsA("MeshPart") and descendant.Material == Enum.Material.Limestone then
							position = Vector3.new(-947.9, 152.12, -7579.52)
							break
						elseif descendant:IsA("MeshPart") and descendant.Material == Enum.Material.Leather then
							position = Vector3.new(1546.12, 152.21, -796.72)
							break
						end
					end
				end
			end
		end)

		if position then
			v3.CFrame = CFrame.new(position + Vector3.new(0, 3, 0))
			return true
		end
		return false
	end

	local function setupSkillCheckSync(character)
		if not character then
			return
		end

		task.spawn(function()
			local cutscene = character:WaitForChild("cutscene", 5)

			if cutscene and cutscene:IsA("LocalScript") then
				if tbl3.Misc_SkipCutscene then
					cutscene.Disabled = true
				end

				if tbl6.CutsceneConn then
					tbl6.CutsceneConn:Disconnect()
				end

				tbl6.CutsceneConn = cutscene:GetPropertyChangedSignal("Disabled"):Connect(function()
					if tbl3.Misc_SkipCutscene and not cutscene.Disabled then
						cutscene.Disabled = true
					end
				end)
			end
		end)
	end

	setSkipCutscene = function(miscSkipCutscene)
		tbl3.Misc_SkipCutscene = miscSkipCutscene
		local character = tbl.LocalPlayer.Character

		if miscSkipCutscene then
			if character then
				setupSkillCheckSync(character)
			end

			if tbl6.CharCutscene then
				tbl6.CharCutscene:Disconnect()
			end

			tbl6.CharCutscene = tbl.LocalPlayer.CharacterAdded:Connect(setupSkillCheckSync)
		else
			if tbl6.CutsceneConn then
				tbl6.CutsceneConn:Disconnect()
				tbl6.CutsceneConn = nil
			end

			if tbl6.CharCutscene then
				tbl6.CharCutscene:Disconnect()
				tbl6.CharCutscene = nil
			end

			if character then
				local cutscene = character:FindFirstChild("cutscene")

				if cutscene and cutscene:IsA("LocalScript") then
					cutscene.Disabled = false
				end
			end
		end
	end

	setAutoPallet = function(survAutoPallet)
		tbl3.Surv_AutoPallet = survAutoPallet

		if survAutoPallet then
			if tbl6.AutoPalletThread then
				task.cancel(tbl6.AutoPalletThread)
			end

			tbl6.AutoPalletThread = task.spawn(function()
				while tbl3.Surv_AutoPallet and not tbl6.Unloaded do
					task.wait(0.1)

					if palletDropEvent then
						local character = tbl.LocalPlayer.Character
						local v3 = getLocalRootPart()

						if v3 and character then
							local flag2 = character:GetAttribute("IsHooked") == true or character:GetAttribute("isHooked") == true
							local flag3 = character:GetAttribute("isCarried") == true or character:GetAttribute("IsCarried") == true or character:GetAttribute("Carried") == true
							local flag4 = (character:GetAttribute("Knocked") == true or character:GetAttribute("isKnocked") == true) and not flag3
							local flag5

							if flag2 or flag4 then
								flag5 = false
							else
								local survAutoPalletSM = flag3 and tbl3.Surv_AutoPalletSM
								flag5 = true

								if survAutoPalletSM then
									flag5 = false
								end
							end

							if flag5 then
								local tbl12 = {}

								for _, v4 in ipairs(tbl11) do
									if isPlayerKiller(v4) and v4.Character then
										local humanoidRootPart2 = v4.Character:FindFirstChild("HumanoidRootPart")

										if humanoidRootPart2 then
											table.insert(tbl12, { root = humanoidRootPart2, char = v4.Character })
										end
									end
								end

								if #tbl12 > 0 then
									for _, pallet in ipairs(tbl9.Pallets) do
										local model = pallet.model
										local trigger = pallet.trigger
										local palletPointSlide

										if trigger then
											palletPointSlide = trigger
										elseif model then
											palletPointSlide = model:FindFirstChild("PalletPointSlide", true) or model:FindFirstChild("PalletPoint", true)
										else
											palletPointSlide = model
										end

										if model and model.Parent and palletPointSlide and not tbl6.DroppedPallets[model] then
											local magnitude = (v3.Position - palletPointSlide.Position).Magnitude
											local flag6 = false

											for _, v4 in ipairs(tbl12) do
												local magnitude2 = (v4.root.Position - palletPointSlide.Position).Magnitude
												local flag7 = v4.char:GetAttribute("IsCarrying") == true or v4.char:GetAttribute("isCarrying") == true

												if flag3 then
													if magnitude <= tbl3.Surv_AutoPalletRadius or magnitude2 <= tbl3.Surv_AutoPalletRadius then
														flag6 = true
														break
													else
														flag6 = false
													end
												elseif flag7 and tbl3.Surv_AutoPalletSF then
													if not (magnitude2 <= 6.5) then
														flag6 = false
													else
														flag6 = true
														break
													end
												elseif magnitude <= tbl3.Surv_AutoPalletRadius and magnitude2 <= tbl3.Surv_AutoPalletRadius then
													flag6 = true
													break
												else
													flag6 = false
												end
											end

											if flag6 then
												pcall(function()
													palletDropEvent:FireServer(palletPointSlide)
												end)

												tbl6.DroppedPallets[model] = true
											end
										end
									end
								end
							end
						end
					end
				end
			end)
		else
			if tbl6.AutoPalletThread then
				task.cancel(tbl6.AutoPalletThread)
				tbl6.AutoPalletThread = nil
			end

			table.clear(tbl6.DroppedPallets)
		end
	end
end

local refreshMapData

do
	local flag2 = false
	local n = 0

	refreshMapData = function(arg)
		if flag2 then
			return
		end

		if not arg and os.clock() - n < 3 then
			return
		end
		flag2 = true
		n = os.clock()
		table.clear(tbl9.Generators)
		table.clear(tbl9.Windows)
		table.clear(tbl9.Pallets)
		table.clear(tbl9.Hooks)
		table.clear(tbl9.Gates)
		table.clear(tbl9.SCPs)
		table.clear(tbl6.DroppedPallets)
		local descendants = tbl.Workspace:GetDescendants()

		for i, descendant in ipairs(descendants) do
			if i % 300 == 0 then
				task.wait()
			end

			if descendant:IsA("Model") then
				local v2 = string.lower(descendant.Name)

				if v2 == "generator" then
					local basePart = descendant:FindFirstChildWhichIsA("BasePart")

					if basePart then
						table.insert(tbl9.Generators, { model = descendant, part = basePart })
					end
				elseif v2 == "hook" and descendant:FindFirstChild("HookPoint") then
					table.insert(tbl9.Hooks, descendant)
				elseif v2 == "gate" and descendant:FindFirstChild("ExitLever") then
					table.insert(tbl9.Gates, descendant)
				elseif v2 == "window" then
					table.insert(tbl9.Windows, descendant)
				elseif string.match(v2, "^scp") then
					table.insert(tbl9.SCPs, descendant)
				end
			elseif descendant:IsA("BasePart") and descendant.Name == "PrimaryPartPallet" then
				local parent = descendant.Parent

				if parent then
					local flag3 = false

					for _, pallet in ipairs(tbl9.Pallets) do
						if pallet.model == parent then
							flag3 = true
							break
						end
					end

					if not flag3 then
						table.insert(tbl9.Pallets, {
							model = parent,
							trigger = parent:FindFirstChild("PalletPointSlide", true) or parent:FindFirstChild("PalletPoint", true),
						})
					end
				end
			end
		end

		flag2 = false
	end
end

if tbl.CoreGui:FindFirstChild("WM") then
	tbl.CoreGui:FindFirstChild("WM"):Destroy()
end

tbl6.WatermarkUI = Instance.new("ScreenGui")
tbl6.WatermarkUI.Name = "WM"
tbl6.WatermarkUI.Parent = tbl.CoreGui
tbl6.WatermarkUI.IgnoreGuiInset = true
tbl6.WatermarkUI.Enabled = true
tbl6.WatermarkUI.ResetOnSpawn = false
local frame
frame = Instance.new("Frame")
frame.Name = "Bubble"
frame.Size = UDim2.new(0, 140, 0, 22)
frame.Position = UDim2.new(0.5, 0, 0.95, 0)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BackgroundTransparency = 0.28
frame.Active = true
frame.Parent = tbl6.WatermarkUI
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 11)
uiCorner.Parent = frame
local textLabel

do
	local uiStroke = Instance.new("UIStroke")
	uiStroke.Color = Color3.fromRGB(255, 255, 255)
	uiStroke.Thickness = 1
	uiStroke.Parent = frame
	uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	uiStroke.Transparency = 0.55
	local uiPadding = Instance.new("UIPadding")
	uiPadding.PaddingLeft = UDim.new(0, 8)
	uiPadding.PaddingRight = UDim.new(0, 8)
	uiPadding.Parent = frame
	textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.Font = Enum.Font.GothamSemibold
	textLabel.TextSize = 11
	textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	textLabel.TextTransparency = 0.05
	textLabel.Text = "PerplexWare | FPS: ... | Ping: ..."
	textLabel.Parent = frame
end

if getgenv().Tixo_SpectatorUI then
	getgenv().Tixo_SpectatorUI:Destroy()
end

local textLabel2, frame2

do
	local coreGui = pcall(function()
		return tbl.CoreGui.Name
	end) and tbl.CoreGui or tbl.Players.LocalPlayer:WaitForChild("PlayerGui")

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "SpcGui"
	screenGui.ResetOnSpawn = false
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.Enabled = true
	getgenv().Tixo_SpectatorUI = screenGui
	local frame3 = Instance.new("Frame")
	frame3.Name = "MainBox"
	frame3.AnchorPoint = Vector2.new(0.5, 1)
	frame3.Position = UDim2.new(0.5, 0, 0, -10)
	frame3.Size = UDim2.new(0, 50, 0, 18)
	frame3.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	frame3.BackgroundTransparency = 0.3
	frame3.BorderSizePixel = 0
	frame3.Parent = screenGui
	local uiGradient = Instance.new("UIGradient")
	local numberSequence = NumberSequence.new
	local tbl12 = {}
	local v2 = NumberSequenceKeypoint.new(0, 1)
	local v3 = NumberSequenceKeypoint.new(0.2, 0.3)
	local v4 = NumberSequenceKeypoint.new(0.8, 0.3)
	local new = NumberSequenceKeypoint.new
	tbl12[1] = v2
	tbl12[2] = v3
	tbl12[3] = v4

	do
		local values = table.pack(new(1, 1))
		table.move(values, 1, values.n, 4, tbl12)
	end

	uiGradient.Transparency = numberSequence(tbl12)
	uiGradient.Parent = frame3
	local uiCorner2 = Instance.new("UICorner")
	uiCorner2.CornerRadius = UDim.new(0, 11)
	uiCorner2.Parent = frame3
	local uiStrokeSpc = Instance.new("UIStroke")
	uiStrokeSpc.Color = Color3.fromRGB(255, 255, 255)
	uiStrokeSpc.Thickness = 1
	uiStrokeSpc.Transparency = 0.55
	uiStrokeSpc.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	uiStrokeSpc.Parent = frame3
	local uiListLayout = Instance.new("UIListLayout")
	uiListLayout.FillDirection = Enum.FillDirection.Horizontal
	uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	uiListLayout.Padding = UDim.new(0, 6)
	uiListLayout.Parent = frame3
	local imageLabel = Instance.new("ImageLabel")
	imageLabel.Name = "Icon"
	imageLabel.LayoutOrder = 1
	imageLabel.Size = UDim2.new(0, 14, 0, 14)
	imageLabel.BackgroundTransparency = 1
	imageLabel.Image = "rbxassetid://13321848320"
	imageLabel.ImageColor3 = Color3.fromRGB(255, 255, 255)
	imageLabel.Parent = frame3
	textLabel2 = Instance.new("TextLabel")
	textLabel2.Name = "Count"
	textLabel2.LayoutOrder = 2
	textLabel2.Size = UDim2.new(0, 0, 1, 0)
	textLabel2.AutomaticSize = Enum.AutomaticSize.X
	textLabel2.BackgroundTransparency = 1
	textLabel2.Font = Enum.Font.GothamMedium
	textLabel2.Text = "0"
	textLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
	textLabel2.TextSize = 12
	textLabel2.Parent = frame3
	screenGui.Parent = coreGui
	frame2 = Instance.new("Frame")
	frame2.Name = "NextKillerBox"
	frame2.AnchorPoint = Vector2.new(0.5, 0)
	frame2.Position = UDim2.new(0.5, 0, frame3.Position.Y.Scale, frame3.Position.Y.Offset + 20)
	frame2.Size = UDim2.new(0, 150, 0, 18)
	frame2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	frame2.BackgroundTransparency = 0.3
	frame2.BorderSizePixel = 0
	frame2.Parent = screenGui
end

do
	local uiGradient = Instance.new("UIGradient")
	local numberSequence = NumberSequence.new
	local tbl12 = {}
	local v2 = NumberSequenceKeypoint.new(0, 1)
	local v3 = NumberSequenceKeypoint.new(0.2, 0.3)
	local v4 = NumberSequenceKeypoint.new(0.8, 0.3)
	local new = NumberSequenceKeypoint.new
	tbl12[1] = v2
	tbl12[2] = v3
	tbl12[3] = v4

	do
		local values = table.pack(new(1, 1))
		table.move(values, 1, values.n, 4, tbl12)
	end

	uiGradient.Transparency = numberSequence(tbl12)
	uiGradient.Parent = frame2
end

local uiCorner2 = Instance.new("UICorner")
uiCorner2.CornerRadius = UDim.new(0, 11)
uiCorner2.Parent = frame2
do
	local uiStrokeNK = Instance.new("UIStroke")
	uiStrokeNK.Color = Color3.fromRGB(255, 255, 255)
	uiStrokeNK.Thickness = 1
	uiStrokeNK.Transparency = 0.55
	uiStrokeNK.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	uiStrokeNK.Parent = frame2
end
local textLabel3
textLabel3 = Instance.new("TextLabel")
textLabel3.Name = "KillerText"
textLabel3.Size = UDim2.new(1, 0, 1, 0)
textLabel3.BackgroundTransparency = 1
textLabel3.Font = Enum.Font.GothamMedium
textLabel3.Text = "Next Killer: ..."
textLabel3.TextColor3 = Color3.fromRGB(255, 255, 255)
textLabel3.TextSize = 12
textLabel3.Parent = frame2

if tbl.CoreGui:FindFirstChild("FovC") then
	tbl.CoreGui:FindFirstChild("FovC"):Destroy()
end

local frame3
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FovC"
screenGui.Parent = tbl.CoreGui
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
frame3 = Instance.new("Frame")
frame3.BackgroundTransparency = 1
frame3.AnchorPoint = Vector2.new(0.5, 0.5)
frame3.Position = UDim2.new(0.5, 0, 0.5, 0)
frame3.Visible = false
frame3.Parent = screenGui
local uiCorner3 = Instance.new("UICorner")
uiCorner3.CornerRadius = UDim.new(1, 0)
uiCorner3.Parent = frame3
local uiStroke
uiStroke = Instance.new("UIStroke")
uiStroke.Color = Color3.fromRGB(255, 255, 255)
uiStroke.Thickness = 0.75
uiStroke.Parent = frame3
local screenGui2
screenGui2 = Instance.new("ScreenGui")
screenGui2.Name = "TargetUI"
screenGui2.Parent = tbl.CoreGui
screenGui2.IgnoreGuiInset = true
screenGui2.Enabled = false
local frame4
frame4 = Instance.new("Frame")
frame4.Name = "TargetMainBox"
frame4.Size = UDim2.new(0, 100, 0, 25)
frame4.Position = UDim2.new(0.5, 0, 0.8, 0)
frame4.AnchorPoint = Vector2.new(0.5, 0.5)
frame4.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame4.BackgroundTransparency = 0.28
frame4.ZIndex = 100
frame4.Parent = screenGui2
local uiCorner4 = Instance.new("UICorner")
uiCorner4.CornerRadius = UDim.new(0, 11)
uiCorner4.Parent = frame4
local uiStroke2 = Instance.new("UIStroke")
uiStroke2.Color = Color3.fromRGB(255, 255, 255)
uiStroke2.Transparency = 0.45
uiStroke2.Thickness = 1
uiStroke2.Parent = frame4
local textLabel4
textLabel4 = Instance.new("TextLabel")
textLabel4.Size = UDim2.new(1, -40, 1, -15)
textLabel4.Position = UDim2.new(0, 10, 0, 5)
textLabel4.BackgroundTransparency = 1
textLabel4.Font = Enum.Font.GothamSemibold
textLabel4.TextSize = 12
textLabel4.TextColor3 = Color3.fromRGB(255, 255, 255)
textLabel4.Text = "Target: Killer"
textLabel4.TextXAlignment = Enum.TextXAlignment.Left
textLabel4.ZIndex = 101
textLabel4.Parent = frame4
local textButton
textButton = Instance.new("TextButton")
textButton.Size = UDim2.new(0, 20, 0, 20)
textButton.AnchorPoint = Vector2.new(0.5, 0.5)
textButton.Position = UDim2.new(0.85, 0, 0.5, 0)
textButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
textButton.Text = ">"
textButton.Font = Enum.Font.GothamBold
textButton.TextSize = 16
textButton.TextColor3 = Color3.fromRGB(0, 0, 0)
textButton.ZIndex = 102
textButton.Parent = frame4
local uiCorner5 = Instance.new("UICorner")
uiCorner5.CornerRadius = UDim.new(0, 6)
uiCorner5.Parent = textButton
local frame5
frame5 = Instance.new("Frame")
frame5.Size = UDim2.new(1, 0, 0, 15)
frame5.Position = UDim2.new(0, 0, 1, 5)
frame5.AnchorPoint = Vector2.new(0, 0.5)
frame5.BackgroundTransparency = 1
frame5.Active = true
frame5.ZIndex = 103
frame5.Parent = frame4

do
	local frame6 = Instance.new("Frame")
	frame6.Size = UDim2.new(0, 60, 0, 4)
	frame6.Position = UDim2.new(0.5, 0, 0.5, 0)
	frame6.AnchorPoint = Vector2.new(0.5, 0.5)
	frame6.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	frame6.ZIndex = 104
	frame6.Parent = frame5
	local uiCorner6 = Instance.new("UICorner")
	uiCorner6.CornerRadius = UDim.new(1, 0)
	uiCorner6.Parent = frame6
end

local flag2
flag2 = false
local v2
v2 = nil
local position
position = nil
local position2
position2 = nil
local updateWatermarkDrag

updateWatermarkDrag = function(arg)
	local n = arg.Position - position
	frame.Position = UDim2.new(position2.X.Scale, position2.X.Offset + n.X, position2.Y.Scale, position2.Y.Offset + n.Y)
end

local updateSpectatorCount

updateSpectatorCount = function()
	local n = 0

	for _, player in ipairs(tbl.Players:GetPlayers()) do
		if player.Team and player.Team.Name == "Spectator" then
			n = n + 1
		end
	end

	textLabel2.Text = tostring(n)
end

local setSmoothHDR, blockWindowsPallets, connection, connection2, setupSkillCheckSync, applySmoothCamera, activateNoCooldown, activateSlasherInvis, setupPistolSound, activateDashLock
local applyFakeName, removeFakeName, runAutoRepair, cancelAutoRepair, findBestGenerator, doAutoFlee, teleportToGenerator, setDoubleGen, hopToNewServer, clearESPByType
local clearAllESP, setupSpearStunTracking, applySkillSoundSwap, updateTeamRole

do
	local function renderSCPESP()
		if tbl.LocalPlayer.Team and tbl.LocalPlayer.Team.Name == "Spectator" then
			if not tbl6.isPredicting then
				tbl6.isPredicting = true
				frame2.Visible = true

				task.spawn(function()
					while tbl6.isPredicting and not tbl6.Unloaded do
						local n = -1
						local v3 = nil

						for _, player in ipairs(tbl.Players:GetPlayers()) do
							local attribute = player:GetAttribute("AllowKiller")
							local attribute2 = player:GetAttribute("KillerChance")

							if attribute == true and type(attribute2) == "number" then
								if attribute2 > n then
									n = attribute2
									v3 = player
								end
							end
						end

						if not v3 then
							local n2 = -1

							for _, player in ipairs(tbl.Players:GetPlayers()) do
								local attribute = player:GetAttribute("KillerChance")

								if type(attribute) == "number" then
									if n2 < attribute then
										n2 = attribute
										v3 = player
									end
								end
							end
						end

						if v3 then
							local selectedKiller = v3:FindFirstChild("SelectedKiller")
							textLabel3.Text = string.format("Killer: %s (%s)", v3.Name, selectedKiller and selectedKiller.Value or v3:GetAttribute("SelectedKiller") or "Unknown")
						else
							textLabel3.Text = "Killer: Tidak ada data"
						end

						task.wait(1)
					end
				end)
			end
		else
			tbl6.isPredicting = false
			frame2.Visible = false
		end
	end

	setSmoothHDR = function(arg)
		local Lighting = game:GetService("Lighting")
		local Workspace = game:GetService("Workspace")

		if arg then
			Lighting.GlobalShadows = true
			Lighting.ClockTime = 12
			Lighting.Brightness = 3.2
			Lighting.ExposureCompensation = 0.1
			Lighting.OutdoorAmbient = Color3.fromRGB(230, 230, 230)
			Lighting.Ambient = Color3.fromRGB(210, 210, 210)
			Lighting.ColorShift_Top = Color3.fromRGB(255, 255, 255)
			Lighting.ColorShift_Bottom = Color3.fromRGB(255, 255, 255)
			Lighting.EnvironmentDiffuseScale = 1
			Lighting.EnvironmentSpecularScale = 1
			Lighting.FogStart = 50
			Lighting.FogEnd = 500
			Lighting.FogColor = Color3.fromRGB(210, 210, 210)

			for _, child in ipairs(Lighting:GetChildren()) do
				if child:IsA("Atmosphere") or child:IsA("BloomEffect") or child:IsA("SunRaysEffect") then
					child:Destroy()
				end
			end

			local bloomEffect = Instance.new("BloomEffect")
			bloomEffect.Name = "Estetik_Bloom"
			bloomEffect.Intensity = 0.05
			bloomEffect.Size = 24
			bloomEffect.Threshold = 2
			bloomEffect.Parent = Lighting
			local sunRaysEffect = Instance.new("SunRaysEffect")
			sunRaysEffect.Name = "Estetik_SunRays"
			sunRaysEffect.Intensity = 0.04
			sunRaysEffect.Spread = 0.1
			sunRaysEffect.Parent = Lighting
			local atmosphere = Instance.new("Atmosphere")
			atmosphere.Name = "Estetik_Atmosphere"
			atmosphere.Density = 0.45
			atmosphere.Offset = 0.25
			atmosphere.Color = Color3.fromRGB(210, 210, 210)
			atmosphere.Decay = Color3.fromRGB(150, 150, 150)
			atmosphere.Glare = 0.2
			atmosphere.Haze = 2.5
			atmosphere.Parent = Lighting

			for _, descendant in ipairs(Workspace:GetDescendants()) do
				if descendant:IsA("BasePart") then
					descendant.Material = Enum.Material.SmoothPlastic
					descendant.Reflectance = 0
				end
			end

			local hdrColor = Lighting:FindFirstChild("HDR_Color") or Instance.new("ColorCorrectionEffect")
			hdrColor.Name = "HDR_Color"
			hdrColor.Saturation = 0.45
			hdrColor.Contrast = 0.15
			hdrColor.Brightness = 0.03
			hdrColor.TintColor = Color3.fromRGB(255, 255, 255)
			hdrColor.Parent = Lighting
		else
			if Lighting:FindFirstChild("HDR_Color") then
				Lighting.HDR_Color:Destroy()
			end

			if Lighting:FindFirstChild("Estetik_Bloom") then
				Lighting.Estetik_Bloom:Destroy()
			end

			if Lighting:FindFirstChild("Estetik_SunRays") then
				Lighting.Estetik_SunRays:Destroy()
			end

			if Lighting:FindFirstChild("Estetik_Atmosphere") then
				Lighting.Estetik_Atmosphere:Destroy()
			end

			Lighting.FogEnd = 100000
		end
	end

	blockWindowsPallets = function(arg)
		if not remotes then
			return
		end
		local window = remotes:FindFirstChild("Window")
		local pallet = remotes:FindFirstChild("Pallet")

		if window then
			for _, window2 in ipairs(tbl9.Windows) do
				if window2 and window2.Parent then
					if arg then
						local vaultTrigger = window2:FindFirstChild("VaultTrigger", true)

						if vaultTrigger then
							pcall(function()
								window:FindFirstChild("VaultEvent"):FireServer(vaultTrigger, true)
							end)
						end
					else
						local vaultPointInUse = window2:FindFirstChild("VaultPointInUse", true)

						if vaultPointInUse then
							pcall(function()
								window:FindFirstChild("VaultCompleteEvent"):FireServer(vaultPointInUse, false)
							end)
						end
					end
				end
			end
		end

		if pallet then
			for _, pallet2 in ipairs(tbl9.Pallets) do
				if pallet2 and pallet2.Parent then
					if arg then
						local palletPointSlide = pallet2:FindFirstChild("PalletPointSlide", true)

						if palletPointSlide then
							pcall(function()
								pallet:FindFirstChild("PalletSlideEvent"):FireServer(palletPointSlide, true)
							end)
						end
					else
						local palletPointSlideInUse = pallet2:FindFirstChild("PalletPointSlideInUse", true)

						if palletPointSlideInUse then
							pcall(function()
								pallet:FindFirstChild("PalletSlideCompleteEvent"):FireServer(palletPointSlideInUse)
							end)
						end
					end
				end
			end
		end
	end

	connection = nil
	connection2 = nil

	local function createBillboardESP()
		pcall(function()
			local playerGui = tbl.LocalPlayer:FindFirstChild("PlayerGui")

			for match in string.gmatch("Survivor-mob.Controls.action.check", "[^%.]+") do
				playerGui = playerGui and playerGui:FindFirstChild(match)
			end

			if playerGui and playerGui:IsA("GuiObject") and playerGui.Visible and playerGui.Parent and playerGui.Parent:IsA("GuiButton") then
				local parent = playerGui.Parent

				if type(firesignal) == "function" then
					pcall(function()
						firesignal(parent.MouseButton1Down)
						task.wait(0.01)
						firesignal(parent.MouseButton1Up)
					end)
				else
					local n = parent.AbsolutePosition + parent.AbsoluteSize / 2
					local guiInset = tbl.GuiService:GetGuiInset()
					local n2 = n.X + guiInset.X
					local n3 = n.Y + guiInset.Y
					tbl.VirtualInputManager:SendMouseButtonEvent(n2, n3, 0, true, game, 1)
					task.wait(0.02)
					tbl.VirtualInputManager:SendMouseButtonEvent(n2, n3, 0, false, game, 1)
				end
			else
				tbl.VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
				task.wait(0.012)
				tbl.VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
			end
		end)
	end

	setupSkillCheckSync = function()
		task.spawn(function()
			local skillCheckPromptGui = tbl.LocalPlayer:FindFirstChild("PlayerGui"):WaitForChild("SkillCheckPromptGui", 10)
			if not skillCheckPromptGui then
				return
			end
			local check = skillCheckPromptGui:WaitForChild("Check", 8)
			if not check then
				return
			end
			local line = check:WaitForChild("Line", 5)
			local goal = check:WaitForChild("Goal", 5)
			if not (line and goal) then
				return
			end

			if connection2 then
				connection2:Disconnect()
			end

			connection2 = check:GetPropertyChangedSignal("Visible"):Connect(function()
				local flag3 = not tbl3.Surv_AutoSkillCheck

				if not flag3 then
					flag3 = not (tbl.LocalPlayer.Team and tbl.LocalPlayer.Team.Name == "Survivors")
				end

				if flag3 then
					return
				end

				if not tbl3.Surv_PerfectSkill then
					if connection then
						connection:Disconnect()
						connection = nil
					end

					return
				end

				if check.Visible then
					if tbl3.Surv_InstanSkill or tbl3.Surv_SkillCheckMode == "Random" and not tbl6.RandomMode_IsNormal then
						line.Rotation = goal.Rotation % 360 + 85
					end

					local n = 0

					if connection then
						connection:Disconnect()
					end

					connection = line:GetPropertyChangedSignal("Rotation"):Connect(function()
						if not tbl3.Surv_PerfectSkill then
							connection:Disconnect()
							connection = nil
							return
						end

						local randomModeIsNormal = tbl3.Surv_SkillCheckMode == "Normal" or tbl3.Surv_SkillCheckMode == "Random" and tbl6.RandomMode_IsNormal
						local n2 = line.Rotation % 360
						local n3 = goal.Rotation % 360
						local n4 = (n3 + 105) % 360
						local n5 = (n3 + 115) % 360

						if randomModeIsNormal then
							n4 = (n3 + 116) % 360
							n5 = (n3 + 140) % 360
						end

						if n4 > n5 and (n2 >= n4 or n2 <= n5) or n2 >= n4 and n2 <= n5 then
							if tick() - n > 0.2 then
								createBillboardESP()
								n = tick()
							end
						end
					end)
				else
					tbl6.RandomMode_IsNormal = false

					if connection then
						connection:Disconnect()
						connection = nil
					end
				end
			end)
		end)
	end

	local thread = nil

	getgenv().CleanupNoCD = function()
		getgenv().NoCD_Active = false

		if thread then
			task.cancel(thread)
			thread = nil
		end
	end

	applySmoothCamera = function()
		if tbl6.cachedRole ~= "Survivor" then
			return
		end
		local character = tbl.LocalPlayer.Character
		if not character then
			return
		end
		local smoothCamera = character:WaitForChild("SmoothCamera", 3) or character:FindFirstChild("SmoothCamera")

		if smoothCamera and smoothCamera:IsA("LocalScript") then
			if tbl3.Misc_SmoothCam then
				smoothCamera:SetAttribute("CameraHeight", tbl3.Misc_CamHeight)
				smoothCamera:SetAttribute("CameraStiffness", tbl3.Misc_CamStiffness)
			else
				smoothCamera:SetAttribute("CameraHeight", -1)
				smoothCamera:SetAttribute("CameraStiffness", 9.5)
			end
		end
	end

	activateNoCooldown = function(arg)
		if not arg then
			if getgenv().CleanupNoCD then
				getgenv().CleanupNoCD()
			end

			return
		end

		if tbl6.cachedRole ~= "Killer" then
			if getgenv().Window then
				sendNotif("Akses Ditolak: Kamu bukan Killer!", 3)
			end

			task.defer(function()
				if Toggles.Killer_NoCDToggle then
					Toggles.Killer_NoCDToggle:SetValue(false)
				end
			end)

			return
		end

		local selectedKiller = tbl.LocalPlayer:FindFirstChild("SelectedKiller")
		local attribute = selectedKiller and selectedKiller.Value or tbl.LocalPlayer:GetAttribute("SelectedKiller")

		if attribute ~= "Hidden" and attribute ~= "Stalker" then
			if getgenv().Window then
				sendNotif("Fitur ini hanya untuk Stalker atau Hidden!", 3)
			end

			task.defer(function()
				if Toggles.Killer_NoCDToggle then
					Toggles.Killer_NoCDToggle:SetValue(false)
				end
			end)

			return
		end

		getgenv().NoCD_Active = true

		if thread then
			task.cancel(thread)
		end

		local tbl12 = {}

		pcall(function()
			for _, v3 in pairs(getgc(true)) do
				if type(v3) == "function" and islclosure(v3) and not isexecutorclosure(v3) then
					local v4 = getinfo(v3)

					if v4 and v4.source and string.find(v4.source, "Powers") then
						table.insert(tbl12, v3)
					end
				end
			end
		end)

		thread = task.spawn(function()
			while getgenv().NoCD_Active and not tbl6.Unloaded do
				task.wait(1)

				pcall(function()
					for _, v3 in ipairs(tbl12) do
						local v4 = getinfo(v3)
						local v5 = getupvalues(v3)

						if attribute == "Hidden" and (v4.name == "tryActivate" or v4.name == "playM2Animation") then
							for k, v6 in pairs(v5) do
								if type(v6) == "boolean" and v6 == true then
									setupvalue(v3, k, false)
								end
							end
						elseif attribute == "Stalker" then
							if v4.name == "updateUI" then
								for k, v6 in pairs(v5) do
									if type(v6) == "boolean" then
										setupvalue(v3, k, true)
									end
								end
							elseif v4.name == "" then
								local n = 0
								local n2 = 0
								local v6 = nil

								for k, v7 in pairs(v5) do
									n = n + 1

									if type(v7) == "boolean" then
										n2 = n2 + 1
										v6 = k
									end
								end

								if n == 1 and n2 == 1 then
									setupvalue(v3, v6, false)
								end
							end
						end
					end
				end)
			end
		end)
	end

	activateSlasherInvis = function(arg)
		if not arg then
			if getgenv().SlasherInvisLoop then
				task.cancel(getgenv().SlasherInvisLoop)
				getgenv().SlasherInvisLoop = nil
			end

			return
		end

		if getgenv().SlasherInvisLoop then
			task.cancel(getgenv().SlasherInvisLoop)
		end

		local tbl12 = {}

		pcall(function()
			for _, v3 in pairs(getgc(true)) do
				if type(v3) == "function" and islclosure(v3) and not isexecutorclosure(v3) then
					local v4 = getinfo(v3)

					if v4 and v4.source and string.find(v4.source, "Powers") then
						table.insert(tbl12, v3)
					end
				end
			end
		end)

		getgenv().SlasherInvisLoop = task.spawn(function()
			while task.wait(0.5) do
				pcall(function()
					local selectedKiller = tbl.LocalPlayer:FindFirstChild("SelectedKiller")
					selectedKiller = selectedKiller and selectedKiller.Value or tbl.LocalPlayer:GetAttribute("SelectedKiller")

					if tbl6.cachedRole == "Killer" and selectedKiller == "Slasher" then
						for _, v3 in ipairs(tbl12) do
							local v4 = getupvalues(v3)

							for k, v5 in pairs(v4) do
								if type(v5) == "boolean" and v5 == true then
									setupvalue(v3, k, false)
								end
							end
						end

						local character = tbl.LocalPlayer.Character

						if character then
							if character:GetAttribute("LakeMist") then
								character:SetAttribute("LakeMist", false)
							end

							if character:GetAttribute("Invisibility") then
								character:SetAttribute("Invisibility", false)
							end

							local checkInterractable = character:FindFirstChild("CheckInterractable")

							if checkInterractable and checkInterractable:GetAttribute("action") then
								checkInterractable:SetAttribute("action", false)
							end
						end
					end
				end)
			end
		end)
	end

	local tbl12 = {
		["Sound 1"] = "rbxassetid://125027580248269",
		["Sound 2"] = "rbxassetid://79440711397443",
		["Sound 3"] = "rbxassetid://102793319115878",
		["Sound 4"] = "rbxassetid://134840941464861",
	}

	local tbl13 = {}

	local function scanItemESPs(arg)
		if not arg or not arg:IsA("Sound") then
			return
		end

		if not arg:GetAttribute("OriginalSoundId") then
			arg:SetAttribute("OriginalSoundId", arg.SoundId)
		end

		local function renderAllESP()
			if tbl3.Pistol_CustomSound then
				local v3 = tbl12[tbl3.Pistol_SelectedSound]

				if v3 and arg.SoundId ~= v3 then
					arg.SoundId = v3
				end
			else
				local attribute = arg:GetAttribute("OriginalSoundId")

				if attribute and arg.SoundId ~= attribute then
					arg.SoundId = attribute
				end
			end
		end

		renderAllESP()

		if not tbl13[arg] then
			tbl13[arg] = arg:GetPropertyChangedSignal("SoundId"):Connect(renderAllESP)

			arg.Played:Connect(function()
				task.delay(1, function()
					if arg and arg.IsPlaying then
						arg:Stop()
					end
				end)
			end)
		end
	end

	setupPistolSound = function(arg)
		if not arg then
			return
		end

		local function renderAllESP()
			local twistOfFate = arg:FindFirstChild("Twist of Fate") or tbl.Workspace:FindFirstChild("Twist of Fate", true)

			if twistOfFate then
				for _, descendant in ipairs(twistOfFate:GetDescendants()) do
					if descendant:IsA("LocalScript") and descendant.Name:lower() == "gun" then
						local disabled = isKnockedOrHooked(arg)
						disabled = not tbl3.Pistol_BlockKnocked and disabled

						if descendant.Disabled ~= disabled then
							descendant.Disabled = disabled
						end
					end

					if descendant:IsA("Sound") and descendant.Name:lower() == "shoot" then
						scanItemESPs(descendant)
					end
				end
			end
		end

		task.spawn(function()
			if arg:WaitForChild("Twist of Fate", 5) then
				renderAllESP()
			end
		end)

		renderAllESP()

		for _, v3 in ipairs({ "Knocked", "isKnocked", "IsHooked", "isHooked", "IsCarried", "isCarried" }) do
			arg:GetAttributeChangedSignal(v3):Connect(renderAllESP)
		end
	end

	local n = 0

	local function renderAllESP()
		local character = tbl.LocalPlayer.Character
		character = character and character:FindFirstChild("HumanoidRootPart")
		if not character then
			return nil
		end
		local huge = math.huge
		local character2 = nil

		for _, player in ipairs(tbl.Players:GetPlayers()) do
			if player ~= tbl.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
				local humanoid2 = player.Character:FindFirstChild("Humanoid")

				if humanoid2 and humanoid2.Health > 0 and not isKnockedOrHooked(player.Character) then
					local magnitude = (character.Position - player.Character.HumanoidRootPart.Position).Magnitude

					if magnitude < huge then
						character2 = player.Character
						huge = magnitude
					end
				end
			end
		end

		return character2
	end

	local function hideSpearTrajectory()
		if tbl6.isAimLocking then
			return
		end

		if tick() - n < 0.2 then
			return
		end
		n = tick()

		if tbl6.cachedRole == "Killer" then
			tbl6.currentTarget = renderAllESP()

			if tbl6.currentTarget and tbl6.currentTarget:FindFirstChild("HumanoidRootPart") then
				tbl6.isAimLocking = true

				if tbl6.lockTimerThread then
					task.cancel(tbl6.lockTimerThread)
				end

				tbl6.lockTimerThread = task.delay(2, function()
					tbl6.isAimLocking = false
					tbl6.currentTarget = nil
					tbl6.lockTimerThread = nil
				end)
			end
		end
	end

	activateDashLock = function(arg)
		if not arg then
			if getgenv().DashRenderConn then
				getgenv().DashRenderConn:Disconnect()
				getgenv().DashRenderConn = nil
			end

			if getgenv().DashInputConn then
				getgenv().DashInputConn:Disconnect()
				getgenv().DashInputConn = nil
			end

			if getgenv().DashMobileLoop then
				task.cancel(getgenv().DashMobileLoop)
				getgenv().DashMobileLoop = nil
			end

			if getgenv().DashMobileBtnConn then
				getgenv().DashMobileBtnConn:Disconnect()
				getgenv().DashMobileBtnConn = nil
			end

			tbl6.isAimLocking = false
			tbl6.currentTarget = nil
			return
		end

		local renderStepped = tbl.RunService.RenderStepped

		getgenv().DashRenderConn = renderStepped:Connect(function()
			if tbl6.isAimLocking and tbl6.currentTarget and tbl6.currentTarget:FindFirstChild("HumanoidRootPart") then
				tbl.Camera.CFrame = tbl.Camera.CFrame:Lerp(CFrame.lookAt(tbl.Camera.CFrame.Position, tbl6.currentTarget.HumanoidRootPart.Position), 0.6)
			else
				tbl6.isAimLocking = false
			end
		end)

		local inputBegan = tbl.UserInputService.InputBegan

		getgenv().DashInputConn = inputBegan:Connect(function(arg2, arg3)
			if arg3 then
				return
			end

			if arg2.UserInputType == Enum.UserInputType.MouseButton2 then
				hideSpearTrajectory()
			end
		end)

		getgenv().DashMobileLoop = task.spawn(function()
			local v3 = nil
			local playerGui = tbl.LocalPlayer:WaitForChild("PlayerGui", 10)

			while task.wait(2) do
				pcall(function()
					if playerGui then
						local hiddenMob = playerGui:FindFirstChild("Hidden-mob")
						local move2 = hiddenMob and hiddenMob:FindFirstChild("Controls") and hiddenMob.Controls:FindFirstChild("move2")

						if move2 and move2 ~= v3 then
							if getgenv().DashMobileBtnConn then
								getgenv().DashMobileBtnConn:Disconnect()
							end

							v3 = move2
							local inputBegan2 = move2.InputBegan

							getgenv().DashMobileBtnConn = inputBegan2:Connect(function(arg2)
								if arg2.UserInputType == Enum.UserInputType.Touch or arg2.UserInputType == Enum.UserInputType.MouseButton1 then
									hideSpearTrajectory()
								end
							end)
						end
					end
				end)
			end
		end)
	end

	local function renderSpearTrajectory()
		if tbl6.Bandage then
			return
		end
		tbl6.Bandage = true

		task.spawn(function()
			pcall(function()
				local remotes2 = tbl.ReplicatedStorage:FindFirstChild("Remotes")
				remotes2 = remotes2 and remotes2:FindFirstChild("Items")
				remotes2 = remotes2 and remotes2:FindFirstChild("Bandage")
				remotes2 = remotes2 and remotes2:FindFirstChild("Fire")
				local character = tbl.LocalPlayer.Character

				if remotes2 and character then
					local bandage = character:FindFirstChild("Bandage") or tbl.LocalPlayer.Backpack:FindFirstChild("Bandage")

					if bandage then
						local rightArm = bandage:FindFirstChild("Right Arm")
						rightArm = rightArm and rightArm:FindFirstChild("Bandage") or bandage

						for i = 1, 400 do
							remotes2:FireServer(true, rightArm)
							remotes2:FireServer(false, rightArm)
						end
					end
				end
			end)

			task.wait(0.1)
			tbl6.Bandage = false
		end)
	end

	local function applyFullbright()
		if tbl6.HookF then
			return
		end

		if not getrawmetatable or not setreadonly then
			warn("[Anti-Fail]: Executor tidak support getrawmetatable atau setreadonly.")
			return
		end
		local v3 = getrawmetatable(game)
		setreadonly(v3, false)
		local namecall = v3.__namecall

		v3.__namecall = newcclosure(function(arg, ...)
			local v4 = table.pack(...)
			local v5 = getnamecallmethod()
			local tbl14 = { ... }

			if tbl3.Killer_BypassCarry and v5 == "GetAttribute" and not checkcaller() then
				if tbl14[1] == "IsCarrying" then
					return false
				end
			end

			if v5 == "FireServer" and not checkcaller() then
				if typeof(arg) == "Instance" then
					local name = arg.Name

					if tbl3.Surv_AutoCancelGene and name == "SkillCheckResultEvent" then
						if args[1] == "fail" then
							return nil
						end
					end

					if tbl3.Aim_SilentVeil and name == "Spearthrow" then
						return
					end

					if tbl3.Aim_Silent and name == "Fire" and arg.Parent and arg.Parent.Name == "Twist of Fate" then
						return nil
					end

					if tbl3.Surv_NoFall and name == "Fall" then
						return nil
					end

					if tbl3.Surv_Bandage and name == "Fire" and arg.Parent and arg.Parent.Name == "Bandage" then
						if tbl14[1] == true then
							renderSpearTrajectory()
							return nil
						end
					end

					if name == "VaultEvent" then
						local character = tbl.LocalPlayer.Character

						if tbl3.Surv_SpeedAfterVault and not tbl6.QuickRecoveryOnCD then
							tbl6.VaultBoostActive = true
							tbl6.QuickRecoveryOnCD = true

							if character then
								character:SetAttribute("speedboost", 1.4)
							end

							if tbl6.VaultBoostThread then
								task.cancel(tbl6.VaultBoostThread)
							end

							tbl6.VaultBoostThread = task.delay(3, function()
								tbl6.VaultBoostActive = false
								local character2 = tbl.LocalPlayer.Character

								if character2 then
									character2:SetAttribute("speedboost", tbl3.Surv_Perks and tbl3.Surv_Spdb and tbl3.Surv_SpeedBoost or 1)
								end

								task.wait(tbl3.Surv_QuickRecoveryCD)
								tbl6.QuickRecoveryOnCD = false
							end)
						end

						if tbl3.Surv_FastVault and not tbl6.FlowstateOnCD then
							task.delay(1, function()
								tbl6.FlowstateOnCD = true
							end)

							if tbl6.FlowstateCDThread then
								task.cancel(tbl6.FlowstateCDThread)
							end

							tbl6.FlowstateCDThread = task.spawn(function()
								task.wait(tbl3.Surv_FlowstateCD)
								tbl6.FlowstateOnCD = false
							end)
						end
					end

					if tbl3.Anti_Blind and tbl6.cachedRole == "Killer" and name == "GotBlinded" then
						return nil
					end
				end
			end

			return namecall(arg, table.unpack(v4, 1, v4.n))
		end)

		setreadonly(v3, true)
		tbl6.HookF = true
	end

	applyFullbright()

	applyFakeName = function()
		if not tbl3.Misc_FakeName then
			return
		end
		local playerGui = tbl.LocalPlayer:FindFirstChild("PlayerGui")
		if not playerGui then
			return
		end

		local function startFullbrightLoop(arg)
			pcall(function()
				if arg:IsA("TextLabel") or arg:IsA("TextButton") or arg:IsA("TextBox") then
					local function stopFullbrightLoop()
						if not tbl3.Misc_FakeName then
							return
						end
						local text = arg.Text

						if not arg:GetAttribute("OriginalText") then
							arg:SetAttribute("OriginalText", text)
						end

						local flag3 = false

						for _, player in ipairs(tbl.Players:GetPlayers()) do
							local name = player.Name
							local displayName = player.DisplayName
							local v3

							if name and name ~= "" and string.find(text, name) then
								v3 = string.gsub(text, name, tbl2.name)
								flag3 = true
							else
								v3 = text
							end

							if displayName and displayName ~= "" and string.find(v3, displayName) then
								text = string.gsub(v3, displayName, tbl2.name)
								flag3 = true
							else
								text = v3
							end
						end

						if flag3 and arg.Text ~= text then
							arg.Text = text
						end
					end

					stopFullbrightLoop()
					local connection3 = arg:GetPropertyChangedSignal("Text"):Connect(stopFullbrightLoop)
					table.insert(tbl6.SpooferConns, connection3)
				elseif arg:IsA("ImageLabel") or arg:IsA("ImageButton") then
					local function stopFullbrightLoop()
						if not tbl3.Misc_FakeName then
							return
						end
						local image = arg.Image
						local flag3 = false

						for _, player in ipairs(tbl.Players:GetPlayers()) do
							if string.find(image, tostring(player.UserId)) then
								if not arg:GetAttribute("OriginalImage") then
									arg:SetAttribute("OriginalImage", image)
								end

								flag3 = true
								break
							end
						end

						local image2 = "rbxassetid://" .. tbl2.icon

						if flag3 and arg.Image ~= image2 then
							arg.Image = image2
						end
					end

					stopFullbrightLoop()
					local connection3 = arg:GetPropertyChangedSignal("Image"):Connect(stopFullbrightLoop)
					table.insert(tbl6.SpooferConns, connection3)
				end
			end)
		end

		for _, descendant in ipairs(playerGui:GetDescendants()) do
			startFullbrightLoop(descendant)
		end

		local connection3 = playerGui.DescendantAdded:Connect(function(descendant)
			task.defer(function()
				startFullbrightLoop(descendant)
			end)
		end)

		table.insert(tbl6.SpooferConns, connection3)
	end

	removeFakeName = function()
		for _, spooferConn in ipairs(tbl6.SpooferConns) do
			if spooferConn.Connected then
				spooferConn:Disconnect()
			end
		end

		table.clear(tbl6.SpooferConns)
		local playerGui = tbl.LocalPlayer:FindFirstChild("PlayerGui")

		if playerGui then
			for _, descendant in ipairs(playerGui:GetDescendants()) do
				pcall(function()
					if descendant:IsA("TextLabel") or descendant:IsA("TextButton") or descendant:IsA("TextBox") then
						local attribute = descendant:GetAttribute("OriginalText")

						if attribute then
							descendant.Text = attribute
							descendant:SetAttribute("OriginalText", nil)
						end
					elseif descendant:IsA("ImageLabel") or descendant:IsA("ImageButton") then
						local attribute = descendant:GetAttribute("OriginalImage")

						if attribute then
							descendant.Image = attribute
							descendant:SetAttribute("OriginalImage", nil)
						end
					end
				end)
			end
		end
	end

	runAutoRepair = function()
		if tbl6.RepairEngineRunning then
			return
		end
		tbl6.RepairEngineRunning = true

		task.spawn(function()
			local tbl14 = {}
			local tbl15 = {}
			local n2 = 0

			while tbl3.AUTO_Generator and not tbl6.Unloaded do
				if tick() - n2 > 2 then
					tbl14 = {}

					for _, generator2 in ipairs(tbl9.Generators) do
						local attribute = generator2.model:GetAttribute("RepairProgress")
						local value

						if attribute then
							value = attribute
						else
							value = generator2.model:FindFirstChild("RepairProgress") and generator2.model.RepairProgress.Value
						end

						value = value or 0

						if value < 100 then
							for _, child in ipairs(generator2.model:GetChildren()) do
								if child.Name:match("GeneratorPoint") then
									table.insert(tbl14, { gen = generator2.model, pt = child })
								end
							end
						else
							for _, child in ipairs(generator2.model:GetChildren()) do
								if child.Name:match("GeneratorPoint") then
									tbl15[child] = nil
								end
							end
						end
					end

					n2 = tick()
				end

				if repairEvent and skillCheckResultEvent then
					local v3 = getLocalRootPart()

					for _, v4 in ipairs(tbl14) do
						if v3 and (v3.Position - v4.pt.Position).Magnitude <= 20 then
							if not tbl15[v4.pt] then
								pcall(repairEvent.FireServer, repairEvent, v4.pt, true)
								tbl15[v4.pt] = true
							end

							pcall(skillCheckResultEvent.FireServer, skillCheckResultEvent, tbl3.Surv_PerfectSkill and "success" or "neutral", 100, v4.gen, v4.pt)
						elseif tbl15[v4.pt] then
							pcall(repairEvent.FireServer, repairEvent, v4.pt, false)
							tbl15[v4.pt] = nil
						end
					end
				end

				task.wait(0.15)
			end

			if repairEvent then
				for k in pairs(tbl15) do
					pcall(repairEvent.FireServer, repairEvent, k, false)
				end
			end

			tbl6.RepairEngineRunning = false
		end)
	end

	cancelAutoRepair = function()
		tbl3.AUTO_Generator = false

		pcall(function()
			local remotes2 = tbl.ReplicatedStorage:FindFirstChild("Remotes")
			local generator2 = remotes2 and remotes2:FindFirstChild("Generator")
			local repairEvent2 = generator2 and generator2:FindFirstChild("RepairEvent")

			if repairEvent2 then
				for _, generator3 in ipairs(tbl9.Generators) do
					for _, child in ipairs(generator3.model:GetChildren()) do
						if child.Name:match("GeneratorPoint") then
							pcall(function()
								repairEvent2:FireServer(child, false)
							end)
						end
					end
				end
			end

			local character = tbl.LocalPlayer.Character
			if not character then
				return
			end

			for _, descendant in pairs(character:GetDescendants()) do
				if descendant:IsA("Weld") or descendant:IsA("WeldConstraint") or descendant:IsA("ManualWeld") then
					if descendant.Part0 and not descendant.Part0:IsDescendantOf(character) or descendant.Part1 and not descendant.Part1:IsDescendantOf(character) then
						descendant:Destroy()
					end
				end
			end

			local humanoid2 = character:FindFirstChildOfClass("Humanoid")
			local humanoidRootPart2 = character:FindFirstChild("HumanoidRootPart")

			if humanoid2 then
				humanoid2:ChangeState(Enum.HumanoidStateType.GettingUp)
				humanoid2.PlatformStand = false
				humanoid2.Sit = false
				humanoid2.WalkSpeed = tbl6.OriginalSpeed or 16
				local animator = humanoid2:FindFirstChildOfClass("Animator")

				if animator then
					for _, v3 in pairs(animator:GetPlayingAnimationTracks()) do
						v3:Stop()
					end
				end
			end

			if humanoidRootPart2 then
				humanoidRootPart2.Anchored = false
				humanoidRootPart2.CFrame = humanoidRootPart2.CFrame * CFrame.new(0, 0, 1.5)
			end
		end)
	end

	findBestGenerator = function()
		if not getLocalRootPart() then
			return nil
		end
		local huge = math.huge
		local v3 = nil

		for _, generator2 in ipairs(tbl9.Generators) do
			local attribute = generator2.model:GetAttribute("RepairProgress") or generator2.model:FindFirstChild("RepairProgress") and generator2.model.RepairProgress.Value or 0
			local attribute2 = generator2.model:GetAttribute("PlayersRepairingCount") or generator2.model:FindFirstChild("PlayersRepairingCount") and generator2.model.PlayersRepairingCount.Value or 0

			if attribute < 100 and attribute2 < 4 then
				local huge2 = math.huge

				for _, player in pairs(tbl.Players:GetPlayers()) do
					if player ~= tbl.LocalPlayer and isPlayerKiller(player) and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
						local magnitude = (player.Character.HumanoidRootPart.Position - generator2.part.Position).Magnitude

						if magnitude < huge2 then
							huge2 = magnitude
						end
					end
				end

				if tbl3.AUTO_LeaveDist + 15 < huge2 then
					local v4 = getDistanceTo(generator2.part.Position)

					if v4 < huge then
						huge = v4
						v3 = generator2
					end
				end
			end
		end

		return v3
	end

	doAutoFlee = function()
		local v3 = getLocalRootPart()
		if not v3 then
			return false
		end
		task.spawn(cancelAutoRepair)
		local huge = math.huge
		local humanoidRootPart2 = nil

		for _, player in pairs(tbl.Players:GetPlayers()) do
			if player ~= tbl.LocalPlayer and isPlayerKiller(player) and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
				local magnitude = (player.Character.HumanoidRootPart.Position - v3.Position).Magnitude

				if magnitude < huge then
					humanoidRootPart2 = player.Character.HumanoidRootPart
					huge = magnitude
				end
			end
		end

		if humanoidRootPart2 and huge <= tbl3.AUTO_LeaveDist then
			local unit = (v3.Position - humanoidRootPart2.Position).Unit

			if unit.Magnitude ~= unit.Magnitude then
				unit = Vector3.new(1, 0, 0)
			end

			v3.CFrame = CFrame.new(v3.Position + unit * (tbl3.AUTO_LeaveDist + 20) + Vector3.new(0, 3, 0))
			return true
		end

		return false
	end

	teleportToGenerator = function(arg)
		local v3 = getLocalRootPart()
		if not v3 or not arg then
			return false
		end
		local unit = (v3.Position - arg.part.Position).Unit

		if unit.Magnitude ~= unit.Magnitude then
			unit = Vector3.new(0, 0, 1)
		end

		v3.CFrame = CFrame.new(arg.part.Position + unit * tbl3.TP_Offset + Vector3.new(0, 3, 0), arg.part.Position)
		return true
	end

	local thread2 = nil

	setDoubleGen = function(survDoubleGen)
		tbl3.Surv_DoubleGen = survDoubleGen

		if survDoubleGen then
			if thread2 then
				task.cancel(thread2)
			end

			thread2 = task.spawn(function()
				local remotes2 = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
				local repairEvent2 = remotes2 and remotes2:FindFirstChild("Generator") and remotes2.Generator:FindFirstChild("RepairEvent")
				local tbl14 = {}
				local flag3 = false

				while tbl3.Surv_DoubleGen and not tbl6.Unloaded do
					task.wait(0.2)
					local character = tbl.LocalPlayer.Character

					if tbl6.cachedRole == "Survivor" and character then
						local checkInterractable = character:FindFirstChild("CheckInterractable")
						local flag4 = checkInterractable and checkInterractable:GetAttribute("isRepairing") == true or character:GetAttribute("isRepairing") == true

						if flag4 and not flag3 then
							tbl14 = {}
							task.wait(0.2)
							local humanoidRootPart2 = character:FindFirstChild("HumanoidRootPart")
							local v3 = humanoidRootPart2 and repairEvent2
							flag3 = true

							if v3 then
								local exitTo = nil

								for _, generator2 in ipairs(tbl9.Generators) do
									if (humanoidRootPart2.Position - generator2.part.Position).Magnitude <= 15 then
										exitTo = 1
										break
									end
								end

								if exitTo == 1 then
									for _, child in ipairs(t8.model:GetChildren()) do
										if string.match(child.Name, "GeneratorPoint") then
											if not (child:GetAttribute("IsRepairing") == true or child:GetAttribute("isRepairing") == true) then
												table.insert(tbl14, child)

												pcall(function()
													repairEvent2:FireServer(child, true)
												end)
											end
										end
									end
								end
							end
						elseif not flag4 and flag3 then
							if repairEvent2 then
								for _, v3 in ipairs(tbl14) do
									pcall(function()
										repairEvent2:FireServer(v3, false)
									end)
								end
							end

							tbl14 = {}
							flag3 = false
						end
					end
				end
			end)
		elseif thread2 then
			task.cancel(thread2)
			thread2 = nil
		end
	end

	hopToNewServer = function()
		local ok, result = pcall(function()
			return game:HttpGet("https://games.roblox.com/v1/games/" .. tostring(game.PlaceId) .. "/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true")
		end)

		if ok and result then
			local data = tbl.HttpService:JSONDecode(result)
			local tbl14 = {}

			if data and data.data then
				for _, v3 in ipairs(data.data) do
					if type(v3) == "table" and v3.id and v3.id ~= game.JobId then
						table.insert(tbl14, v3.id)
					end
				end
			end

			if #tbl14 > 0 then
				local v3 = tbl14[math.random(#tbl14)]
				game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, v3, tbl.LocalPlayer)
			elseif getgenv().Window then
				sendNotif("Gagal: Tidak ada server yang tersedia.", 3)
			end
		end
	end

	clearESPByType = function(arg)
		if arg == "Player" then
			for _, v3 in ipairs(tbl11) do
				if v3.Character then
					local peh = v3.Character:FindFirstChild("PEH")
					local peText = v3.Character:FindFirstChild("PE_Text")

					if peh then
						Debris:AddItem(peh, 0)
					end

					if peText then
						Debris:AddItem(peText, 0)
					end
				end
			end
		elseif arg == "Killer" then
			for _, v3 in ipairs(tbl11) do
				if v3.Character then
					local keh = v3.Character:FindFirstChild("KEH")
					local keText = v3.Character:FindFirstChild("KE_Text")

					if keh then
						Debris:AddItem(keh, 0)
					end

					if keText then
						Debris:AddItem(keText, 0)
					end
				end
			end
		elseif arg == "Generator" then
			for _, generator2 in pairs(tbl9.Generators) do
				if generator2.model and generator2.model.Parent then
					local geh = generator2.model:FindFirstChild("GEH")
					local geText = generator2.model:FindFirstChild("GE_Text")

					if geh then
						Debris:AddItem(geh, 0)
					end

					if geText then
						Debris:AddItem(geText, 0)
					end
				end
			end
		elseif arg == "Pallet" then
			for _, pallet in pairs(tbl9.Pallets) do
				if pallet and pallet.Parent then
					local palletEH = pallet:FindFirstChild("PalletEH")

					if palletEH then
						Debris:AddItem(palletEH, 0)
					end
				end
			end
		elseif arg == "Hook" then
			for _, hook in pairs(tbl9.Hooks) do
				if hook and hook.Parent then
					local hookEH = hook:FindFirstChild("HookEH")
					local hookEText = hook:FindFirstChild("HookE_Text")

					if hookEH then
						Debris:AddItem(hookEH, 0)
					end

					if hookEText then
						Debris:AddItem(hookEText, 0)
					end
				end
			end
		elseif arg == "Window" then
			for _, window in pairs(tbl9.Windows) do
				if window and window.Parent then
					local windowEH = window:FindFirstChild("WindowEH")

					if windowEH then
						Debris:AddItem(windowEH, 0)
					end
				end
			end
		elseif arg == "Item" then
			for _, itemESP in pairs(tbl6.ItemESPs) do
				if itemESP then
					Debris:AddItem(itemESP, 0)
				end
			end

			table.clear(tbl6.ItemESPs)
		elseif arg == "Gate" then
			for _, gate in pairs(tbl9.Gates) do
				if gate and gate.Parent then
					local gateEH = gate:FindFirstChild("GateEH")
					local gateEText = gate:FindFirstChild("GateE_Text")

					if gateEH then
						Debris:AddItem(gateEH, 0)
					end

					if gateEText then
						Debris:AddItem(gateEText, 0)
					end
				end
			end
		elseif arg == "SCP" then
			for _, scP in pairs(tbl9.SCPs) do
				if scP and scP.Parent then
					local scpeh = scP:FindFirstChild("SCPEH")

					if scpeh then
						Debris:AddItem(scpeh, 0)
					end
				end
			end
		end
	end

	clearAllESP = function()
		clearESPByType("Player")
		clearESPByType("Killer")
		clearESPByType("Generator")
		clearESPByType("Pallet")
		clearESPByType("Hook")
		clearESPByType("Item")
		clearESPByType("Gate")
		clearESPByType("SCP")
		clearESPByType("Window")
	end

	setupSpearStunTracking = function(arg)
		if not arg then
			return
		end

		if tbl6.SpearModeConn then
			tbl6.SpearModeConn:Disconnect()
			tbl6.SpearModeConn = nil
		end

		if tbl6.StunConn then
			tbl6.StunConn:Disconnect()
			tbl6.StunConn = nil
		end

		tbl6.SpearModeConn = arg:GetAttributeChangedSignal("spearmode"):Connect(function()
			local attribute = tbl.LocalPlayer:FindFirstChild("SelectedKiller") and tbl.LocalPlayer.SelectedKiller.Value or tbl.LocalPlayer:GetAttribute("SelectedKiller")

			if tbl6.cachedRole == "Killer" and attribute == "Veil" and arg:GetAttribute("spearmode") == true then
				tbl8.isChargingSpear = false
				tbl8.currentTouchInput = nil
				tbl6.spearSwitchCooldown = true

				task.delay(2, function()
					tbl6.spearSwitchCooldown = false
				end)
			else
				tbl6.spearSwitchCooldown = false
			end
		end)

		tbl6.StunConn = arg:GetAttributeChangedSignal("IsStunned"):Connect(function()
			if arg:GetAttribute("IsStunned") == true then
				tbl8.isChargingSpear = false
				tbl8.currentTouchInput = nil
			end
		end)
	end

	applySkillSoundSwap = function(arg)
		if not arg then
			return
		end
		local tbl14 = { Great = "rbxassetid://111033165135961", Sound = "rbxassetid://138997442392324" }
		local tbl15 = { "Skillcheck-gen", "Skillcheck-player" }

		task.spawn(function()
			for _, v3 in ipairs(tbl15) do
				local v4 = arg:WaitForChild(v3, 5)

				if v4 then
					for k, v5 in pairs(tbl14) do
						local v6 = v4:WaitForChild(k, 5)

						if v6 and v6:IsA("Sound") then
							if not v6:GetAttribute("OriginalSoundId") then
								v6:SetAttribute("OriginalSoundId", v6.SoundId)
							end

							if tbl3.Surv_SoundDbd then
								v6.SoundId = v5
							else
								local attribute = v6:GetAttribute("OriginalSoundId")

								if attribute then
									v6.SoundId = attribute
								end
							end
						end
					end
				end
			end
		end)
	end

	updateTeamRole = function()
		if not tbl.LocalPlayer.Team then
			str = "Unknown"
			return
		end
		local name = tbl.LocalPlayer.Team.Name

		if name == "Killer" then
			str = "Killer"
		elseif name == "Survivors" then
			str = "Survivor"
		else
			str = "Spectator"

			if getgenv().NoCD_Active then
				getgenv().NoCD_Active = false

				if getgenv().CleanupNoCD then
					pcall(getgenv().CleanupNoCD)
				end
			end
		end

		tbl6.VaultBoostActive = false
		tbl6.QuickRecoveryOnCD = false

		if tbl6.VaultBoostThread then
			task.cancel(tbl6.VaultBoostThread)
			tbl6.VaultBoostThread = nil
		end

		if tbl6.TeamLabel then
			pcall(function()
				tbl6.TeamLabel:Set("Team: " .. str)
			end)
		end

		if str == "Survivor" and tbl3.Misc_SmoothCam then
			pcall(applySmoothCamera)
		end

		if str == "Killer" then
			local survivorFlags = {
				"AUTO_AutoSurvivor", "Surv_AutoSprint", "Surv_SelfHeal", "Surv_AuraHeal",
				"Surv_AutoParry", "Surv_Parry", "Surv_ParryV2", "Surv_AutoCrouch", "Surv_Bandage",
				"Surv_CrouchV", "Surv_Perks", "Surv_Spdb", "Surv_PerfectVault",
				"Surv_FastVault", "Surv_SpeedAfterVault", "Surv_AutoFleeToggle",
				"Surv_AutoSkillCheck", "Surv_GodMode", "Surv_NoFall", "Surv_SoundDbd",
				"AntiBlockWindowToggle", "Surv_AutoPalletToggle", "Surv_DoubleGenToggle",
				"AUTO_Generator", "Surv_Fov",
			}
			for _, flag in ipairs(survivorFlags) do
				if tbl3[flag] then
					tbl3[flag] = false
					if getgenv().Toggles and getgenv().Toggles[flag] then
						pcall(function() getgenv().Toggles[flag]:SetValue(false) end)
					end
				end
			end
			if tbl3.Misc_SmoothCam then
				tbl3.Misc_SmoothCam = false
				pcall(applySmoothCamera)
			end
			tbl.Camera.FieldOfView = 70
			if tbl6.FleeThread then task.cancel(tbl6.FleeThread) tbl6.FleeThread = nil end
			if tbl6.AutoSprintThread then task.cancel(tbl6.AutoSprintThread) tbl6.AutoSprintThread = nil end
			if tbl6.blockThread then task.cancel(tbl6.blockThread) tbl6.blockThread = nil end
			task.spawn(cancelAutoRepair)
		end

		renderSCPESP()
		clearAllESP()

		if name == "Killer" or name == "Survivors" then
			if refreshPlayerList then
				refreshPlayerList()
			end

			task.delay(15, function()
				if tbl6.Unloaded then
					return
				end
				refreshMapData()
				applySmoothCamera()
				applySkillSoundSwap(tbl.LocalPlayer.Character)
				setupSpearStunTracking(tbl.LocalPlayer.Character)

				if tbl3.Misc_SmoothHDR then
					setSmoothHDR(true)
				end
			end)
		end
	end
end

local renderSCPESP

renderSCPESP = function()
	if not tbl3.ESP_Master then
		return
	end

	if tbl3.ESP_SCP then
		for _, scP in ipairs(tbl9.SCPs) do
			if scP and scP.Parent then
				local humanoid2 = scP:FindFirstChildOfClass("Humanoid")
				local humanoidRootPart2 = scP:FindFirstChild("HumanoidRootPart") or scP:FindFirstChild("Torso") or scP:FindFirstChild("Head") or scP.PrimaryPart

				if humanoid2 and humanoidRootPart2 and math.floor(humanoid2.WalkSpeed) > 0 and math.floor(humanoid2.WalkSpeed) ~= 16 then
					local scp = tbl7.Colors.SCP
					local scpeh = scP:FindFirstChild("SCPEH")

					if not scpeh then
						scpeh = Instance.new("Highlight")
						scpeh.Name = "SCPEH"
						scpeh.Parent = scP
					end

					scpeh.FillColor = scp
					scpeh.OutlineColor = scp
					scpeh.FillTransparency = tbl3.ESP_Outline and 1 or tbl3.Trans or 0.7
					scpeh.Enabled = true
					scpeh.OutlineTransparency = 0.5
				else
					local scpeh = scP:FindFirstChild("SCPEH")

					if scpeh then
						scpeh.Enabled = false
					end
				end
			end
		end
	else
		clearESPByType("SCP")
	end
end

local createBillboardESP, scanItemESPs

do
	local items = tbl.ReplicatedStorage:WaitForChild("Items", 5)

	local function renderAllESP(arg)
		return tostring(arg):match("%d+")
	end

	local function hideSpearTrajectory(arg)
		if not items then
			return nil
		end
		local v3 = items:FindFirstChild(arg)
		if not v3 then
			return nil
		end
		local texture = nil

		pcall(function()
			texture = v3.Texture or v3.Image
		end)

		if texture and texture ~= "" then
			local v4 = renderAllESP(texture)
			if v4 then
				return ("rbxthumb://type=Asset&id=%s&w=420&h=420"):format(v4)
			end
		end

		return nil
	end

	createBillboardESP = function(parent, name, arg)
		local billboardGui = parent:FindFirstChild(name)
		local lineScale = arg.lineScale or 1

		if not billboardGui then
			billboardGui = Instance.new("BillboardGui")
			billboardGui.Name = name
			billboardGui.Parent = parent

			if parent:IsA("Model") then
				billboardGui.Adornee = parent:FindFirstChild("Head") or parent:FindFirstChild("HumanoidRootPart") or parent.PrimaryPart
			else
				billboardGui.Adornee = parent
			end

			billboardGui.AlwaysOnTop = true
			billboardGui.Size = UDim2.new(0, 250, 0, 100)
			billboardGui.StudsOffset = Vector3.new(0, arg.offsetY or 0, 0)
			local frame6 = Instance.new("Frame")
			frame6.Name = "Wrapper"
			frame6.AutomaticSize = Enum.AutomaticSize.XY
			frame6.Size = UDim2.new(0, 0, 0, 0)
			frame6.Position = UDim2.new(0.5, 25 * lineScale, 0.5, -25 * lineScale)
			frame6.AnchorPoint = Vector2.new(0, 1)
			frame6.BackgroundTransparency = 1
			frame6.ZIndex = 2
			frame6.Parent = billboardGui
			local uiListLayout = Instance.new("UIListLayout")
			uiListLayout.FillDirection = Enum.FillDirection.Vertical
			uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
			uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			uiListLayout.Padding = UDim.new(0, 0)
			uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			uiListLayout.Parent = frame6
			local textLabel5 = Instance.new("TextLabel")
			textLabel5.Name = "StatusText"
			textLabel5.AutomaticSize = Enum.AutomaticSize.X
			textLabel5.Size = UDim2.new(0, 0, 0, 10)
			textLabel5.BackgroundTransparency = 1
			textLabel5.Font = Enum.Font.GothamBold
			textLabel5.TextSize = 10
			textLabel5.TextColor3 = Color3.fromRGB(255, 255, 255)
			textLabel5.TextXAlignment = Enum.TextXAlignment.Center
			textLabel5.TextYAlignment = Enum.TextYAlignment.Bottom
			textLabel5.ZIndex = 3
			textLabel5.LayoutOrder = 1
			textLabel5.Parent = frame6
			local frame7 = Instance.new("Frame")
			frame7.Name = "Box"
			frame7.AutomaticSize = Enum.AutomaticSize.X
			frame7.Size = UDim2.new(0, 0, 0, 16)
			frame7.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
			frame7.BackgroundTransparency = 0
			frame7.BorderSizePixel = 0
			frame7.ZIndex = 2
			frame7.LayoutOrder = 2
			frame7.Parent = frame6
			Instance.new("UICorner", frame7).CornerRadius = UDim.new(0, 3)
			local uiGradient = Instance.new("UIGradient")
			local numberSequence = NumberSequence.new
			local tbl12 = {}
			local v3 = NumberSequenceKeypoint.new(0, 1)
			local v4 = NumberSequenceKeypoint.new(0.15, 0.3)
			local v5 = NumberSequenceKeypoint.new(0.5, 0.3)
			local v6 = NumberSequenceKeypoint.new(0.85, 0.3)
			local new = NumberSequenceKeypoint.new
			tbl12[1] = v3
			tbl12[2] = v4
			tbl12[3] = v5
			tbl12[4] = v6

			do
				local values = table.pack(new(1, 1))
				table.move(values, 1, values.n, 5, tbl12)
			end

			uiGradient.Transparency = numberSequence(tbl12)
			uiGradient.Parent = frame7
			local uiPadding = Instance.new("UIPadding", frame7)
			uiPadding.PaddingLeft = UDim.new(0, 8)
			uiPadding.PaddingRight = UDim.new(0, 8)
			local uiListLayout2 = Instance.new("UIListLayout", frame7)
			uiListLayout2.FillDirection = Enum.FillDirection.Horizontal
			uiListLayout2.VerticalAlignment = Enum.VerticalAlignment.Center
			uiListLayout2.HorizontalAlignment = Enum.HorizontalAlignment.Center
			uiListLayout2.Padding = UDim.new(0, 4)
			uiListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
			local imageLabel = Instance.new("ImageLabel", frame7)
			imageLabel.Name = "Icon"
			imageLabel.Size = UDim2.new(0, 12, 0, 12)
			imageLabel.BackgroundTransparency = 1
			imageLabel.ZIndex = 3
			imageLabel.LayoutOrder = 1
			imageLabel.Visible = false
			local textLabel6 = Instance.new("TextLabel", frame7)
			textLabel6.Name = "Text"
			textLabel6.AutomaticSize = Enum.AutomaticSize.X
			textLabel6.Size = UDim2.new(0, 0, 1, 0)
			textLabel6.BackgroundTransparency = 1
			textLabel6.Font = Enum.Font.GothamMedium
			textLabel6.TextSize = 11
			textLabel6.ZIndex = 3
			textLabel6.LayoutOrder = 2
			textLabel6.RichText = true
			textLabel6.TextXAlignment = Enum.TextXAlignment.Center
			textLabel6.TextYAlignment = Enum.TextYAlignment.Center
			local frame8 = Instance.new("Frame")
			frame8.Name = "Line"
			frame8.Size = UDim2.new(0, 1, 0, 36 * lineScale)
			frame8.Position = UDim2.new(0.5, 12 * lineScale, 0.5, -12 * lineScale)
			frame8.AnchorPoint = Vector2.new(0.5, 0.5)
			frame8.Rotation = 45
			frame8.BorderSizePixel = 0
			frame8.ZIndex = 1
			frame8.Parent = billboardGui
			local uiGradient2 = Instance.new("UIGradient")
			uiGradient2.Rotation = 90
			local new2 = NumberSequenceKeypoint.new
			uiGradient2.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), new2(1, 1) })
			uiGradient2.Parent = frame8
		end

		if billboardGui:FindFirstChild("Wrapper") then
			billboardGui.Wrapper.Position = UDim2.new(0.5, 25 * lineScale, 0.5, -25 * lineScale)
		end

		if billboardGui:FindFirstChild("Line") then
			billboardGui.Line.Size = UDim2.new(0, 1, 0, 36 * lineScale)
			billboardGui.Line.Position = UDim2.new(0.5, 12 * lineScale, 0.5, -12 * lineScale)
			billboardGui.Line.BackgroundColor3 = arg.color
		end

		local str3 = string.format("#%02X%02X%02X", arg.color.R * 255, arg.color.G * 255, arg.color.B * 255)
		local flag3 = arg.hookCount and arg.hookCount ~= ""
		local str4 = ""

		if flag3 then
			str4 = string.format(" <font color='#FF4444'>[%s]</font>", arg.hookCount)
		end

		local box = billboardGui:FindFirstChild("Wrapper") and billboardGui.Wrapper:FindFirstChild("Box")

		if box then
			if arg.distance then
				box.Text.Text = string.format("<font color='#FFFFFF'>%s</font>%s <font color='%s'>[%dm]</font>", arg.name, str4, str3, arg.distance)
			elseif arg.subtext then
				box.Text.Text = string.format("<font color='#FFFFFF'>%s</font>%s <font color='%s'>%s</font>", arg.name, str4, str3, arg.subtext)
			else
				box.Text.Text = string.format("<font color='#FFFFFF'>%s</font>%s", arg.name, str4)
			end

			if arg.icon and arg.icon ~= "" then
				box.Icon.Image = arg.icon
				box.Icon.Visible = true
			else
				box.Icon.Visible = false
			end
		end

		local statusText = billboardGui:FindFirstChild("Wrapper") and billboardGui.Wrapper:FindFirstChild("StatusText")

		if statusText then
			if arg.status and arg.status ~= "" then
				statusText.Text = arg.status
				statusText.Visible = true

				if arg.status == "Hook" then
					statusText.TextColor3 = Color3.fromRGB(255, 50, 50)
				elseif arg.status == "Knock" then
					statusText.TextColor3 = Color3.fromRGB(255, 150, 50)
				elseif arg.status == "Injured" then
					statusText.TextColor3 = Color3.fromRGB(255, 255, 50)
				end
			else
				statusText.Visible = false
			end
		end
	end

	scanItemESPs = function()
		if not tbl3.ESP_Master then
			return
		end
		local v3 = getLocalRootPart()

		if tbl3.ESP_KillerWarn and v3 and tbl6.cachedRole == "Survivor" then
			local killerWarn = v3:FindFirstChild("KillerWarn")
			local huge = math.huge

			for _, player in ipairs(tbl.Players:GetPlayers()) do
				if player ~= tbl.LocalPlayer and isPlayerKiller(player) and player.Character then
					local humanoidRootPart2 = player.Character:FindFirstChild("HumanoidRootPart")

					if humanoidRootPart2 then
						local magnitude = (humanoidRootPart2.Position - v3.Position).Magnitude

						if magnitude < huge then
							huge = magnitude
						end
					end
				end
			end

			if huge <= 80 then
				if not killerWarn then
					killerWarn = Instance.new("BillboardGui")
					killerWarn.Name = "KillerWarn"
					killerWarn.Size = UDim2.new(0, 28, 0, 28)
					killerWarn.AlwaysOnTop = true
					killerWarn.StudsOffset = Vector3.new(0, 4, 0)
					killerWarn.Parent = v3
					local frame6 = Instance.new("Frame")
					frame6.Name = "WarnBox"
					frame6.Size = UDim2.new(0.65, 0, 0.65, 0)
					frame6.Position = UDim2.new(0.5, 0, 0.5, 0)
					frame6.AnchorPoint = Vector2.new(0.5, 0.5)
					frame6.BackgroundTransparency = 1
					frame6.Rotation = 45
					frame6.Parent = killerWarn
					local uiStroke3 = Instance.new("UIStroke")
					uiStroke3.Name = "WarnStroke"
					uiStroke3.Thickness = 1
					uiStroke3.Parent = frame6
					local textLabel5 = Instance.new("TextLabel")
					textLabel5.Name = "WarnText"
					textLabel5.Size = UDim2.new(0.8, 0, 0.8, 0)
					textLabel5.Position = UDim2.new(0.5, 0, 0.5, 0)
					textLabel5.AnchorPoint = Vector2.new(0.5, 0.5)
					textLabel5.BackgroundTransparency = 1
					textLabel5.TextScaled = true
					textLabel5.TextStrokeTransparency = 0.4
					textLabel5.Font = Enum.Font.GothamBlack
					textLabel5.Text = "!"
					textLabel5.ZIndex = 2
					textLabel5.Parent = killerWarn
				end

				local warnText = killerWarn:FindFirstChild("WarnText")
				local warnBox = killerWarn:FindFirstChild("WarnBox")
				warnBox = warnBox and warnBox:FindFirstChild("WarnStroke")

				if warnText and warnBox then
					if huge <= 40 then
						warnBox.Color = Color3.fromRGB(255, 20, 20)
						warnText.TextColor3 = Color3.fromRGB(255, 20, 20)
					else
						warnBox.Color = Color3.fromRGB(255, 220, 0)
						warnText.TextColor3 = Color3.fromRGB(255, 220, 0)
					end
				end
			elseif killerWarn then
				killerWarn:Destroy()
			end
		else
			local killerWarn = v3 and v3:FindFirstChild("KillerWarn")

			if killerWarn then
				killerWarn:Destroy()
			end
		end

		if tbl3.ESP_Player or tbl3.ESP_Killer then
			for _, player in pairs(tbl.Players:GetPlayers()) do
				if player ~= tbl.LocalPlayer and player.Character then
					local v4 = isPlayerKiller(player)
					local head = player.Character:FindFirstChild("Head") or player.Character:FindFirstChild("HumanoidRootPart")

					if head and (not v4 and tbl3.ESP_Player or v4 and tbl3.ESP_Killer) then
						local n = v3 and math.floor((head.Position - v3.Position).Magnitude) or 0
						local name = v4 and "KEH" or "PEH"
						local str3 = v4 and "KE_Text" or "PE_Text"
						local str4 = v4 and "PEH" or "KEH"
						local str5 = v4 and "PE_Text" or "KE_Text"

						if player.Character:FindFirstChild(str4) then
							player.Character[str4]:Destroy()
						end

						if player.Character:FindFirstChild(str5) then
							player.Character[str5]:Destroy()
						end

						if n <= tbl3.ESP_MaxDistance then
							local killer = v4 and tbl7.Colors.Killer or tbl7.Colors.Player
							local highlight = player.Character:FindFirstChild(name)

							if not highlight then
								highlight = Instance.new("Highlight")
								highlight.Name = name
								highlight.Parent = player.Character
							end

							highlight.FillColor = killer
							highlight.OutlineColor = killer
							highlight.FillTransparency = tbl3.ESP_Outline and 1 or tbl3.Trans or 0.7
							highlight.OutlineTransparency = 0.5

							if tbl3.ESP_Name then
								local v5 = nil
								local str6 = ""
								local str7 = ""

								if not v4 then
									v5 = nil

									if tbl3.ESP_ItemIcon then
										local attribute = player:GetAttribute("EquippedItem")
										local flag3 = attribute and attribute ~= ""
										v5 = nil

										if flag3 then
											v5 = hideSpearTrajectory(attribute)
										end
									end

									local character = player.Character
									local attribute = character:GetAttribute("IsHooked") or character:GetAttribute("isHooked") or character:GetAttribute("Hooked")
									local attribute2 = character:GetAttribute("Knocked") or character:GetAttribute("isKnocked")
									local humanoid2 = character:FindFirstChildOfClass("Humanoid")
									local flag3 = humanoid2 and humanoid2.Health <= 60 and humanoid2.Health > 0

									if attribute then
										str6 = "Hook"
									elseif attribute2 then
										str6 = "Knock"
									elseif flag3 then
										str6 = "Injured"
									end

									local attribute3 = character:GetAttribute("HookCount") or 0

									if attribute3 == 1 then
										str7 = "I"
									elseif attribute3 == 2 then
										str7 = "II"
									elseif attribute3 >= 3 then
										str7 = "III"
									end
								end

								local espColor
								if attribute then
									espColor = Color3.fromRGB(255, 50, 50)
								elseif attribute2 then
									espColor = Color3.fromRGB(255, 140, 0)
								elseif flag3 and tbl3.ESP_InjuredColor then
									local ratio = humanoid2 and (humanoid2.Health / (humanoid2.MaxHealth or 100)) or 1
									espColor = Color3.fromRGB(255, math.floor(180 * ratio), math.floor(20 * ratio))
								else
									espColor = killer
								end
								createBillboardESP(player.Character, str3, {
									name = player.Name,
									distance = n,
									color = espColor,
									icon = v5,
									status = str6,
									hookCount = str7,
									lineScale = v4 and 0.6 or 1,
								})
							else
								local v5 = player.Character:FindFirstChild(str3)

								if v5 then
									v5:Destroy()
								end
							end
						else
							local v5 = player.Character:FindFirstChild(name)
							local v6 = player.Character:FindFirstChild(str3)

							if v5 then
								v5:Destroy()
							end

							if v6 then
								v6:Destroy()
							end
						end
					end
				end
			end
		end
	end
end

local renderAllESP

renderAllESP = function()
	if not tbl3.ESP_Master then
		return
	end
	local v3 = getLocalRootPart()

	local function hideSpearTrajectory(arg)
		if not v3 then
			return 0
		end
		return math.floor((arg - v3.Position).Magnitude)
	end

	if tbl3.ESP_Generator then
		for k, generator2 in pairs(tbl9.Generators) do
			local model = generator2.model

			if model and model.Parent and generator2.part then
				local espMaxDistance = tbl3.ESP_MaxDistance

				if hideSpearTrajectory(generator2.part.Position) <= espMaxDistance then
					local n = math.floor(model:GetAttribute("RepairProgress") or 0)
					local attribute = model:GetAttribute("PlayersRepairingCount") or 0
					local generatorDone = n >= 100 and tbl7.Colors.GeneratorDone or tbl7.Colors.Generator
					local geh = model:FindFirstChild("GEH")

					if not geh then
						geh = Instance.new("Highlight")
						geh.Name = "GEH"
						geh.Parent = model
					end

					geh.FillColor = generatorDone
					geh.OutlineColor = generatorDone
					local n2 = tbl3.ESP_Outline and 1
					local trans

					if n2 then
						trans = n2
					else
						trans = tbl3.Trans or 0.7
					end

					geh.FillTransparency = trans
					geh.OutlineTransparency = 0.5

					if tbl3.ESP_NameG then
						createBillboardESP(model, "GE_Text", {
							name = "G " .. k,
							subtext = attribute > 0 and string.format("[%d%%] (%d plyr)", n, attribute) or string.format("[%d%%]", n),
							color = generatorDone,
							icon = nil,
							lineScale = 0.2,
						})
					else
						local geText = model:FindFirstChild("GE_Text")

						if geText then
							geText:Destroy()
						end
					end
				else
					if model:FindFirstChild("GEH") then
						model.GEH:Destroy()
					end

					if model:FindFirstChild("GE_Text") then
						model.GE_Text:Destroy()
					end
				end
			end
		end
	end

	if tbl3.ESP_Pallet then
		for _, pallet in pairs(tbl9.Pallets) do
			local model = pallet.model

			if model and model.Parent then
				local espMaxDistance = tbl3.ESP_MaxDistance

				if hideSpearTrajectory(model:GetPivot().Position) <= espMaxDistance then
					local palletEH = model:FindFirstChild("PalletEH")

					if not palletEH then
						palletEH = Instance.new("Highlight")
						palletEH.Name = "PalletEH"
						palletEH.Parent = model
					end

					local pallet2 = tbl7.Colors.Pallet
					palletEH.Adornee = model
					palletEH.FillColor = pallet2
					palletEH.OutlineColor = pallet2
					palletEH.FillTransparency = tbl3.ESP_Outline and 1 or tbl3.Trans or 0.7
					palletEH.OutlineTransparency = 0.5
				elseif model:FindFirstChild("PalletEH") then
					model.PalletEH:Destroy()
				end
			end
		end
	end

	if tbl3.ESP_Window then
		for _, window in ipairs(tbl9.Windows) do
			if window and window.Parent then
				local bottom = window:FindFirstChild("Bottom") or window:FindFirstChildWhichIsA("BasePart")

				if bottom then
					local espMaxDistance = tbl3.ESP_MaxDistance

					if hideSpearTrajectory(bottom.Position) <= espMaxDistance then
						local windowEH = window:FindFirstChild("WindowEH")

						if not windowEH then
							windowEH = Instance.new("BoxHandleAdornment")
							windowEH.Name = "WindowEH"
							windowEH.Parent = window
							windowEH.AlwaysOnTop = true
							windowEH.ZIndex = 5
						end

						windowEH.Adornee = bottom
						windowEH.Size = bottom.Size
						windowEH.Color3 = tbl7.Colors.Window
						windowEH.Transparency = tbl3.ESP_Outline and 0.8 or 0.4
					elseif window:FindFirstChild("WindowEH") then
						window.WindowEH:Destroy()
					end
				end
			end
		end
	end

	if tbl3.ESP_Hook then
		for _, hook in ipairs(tbl9.Hooks) do
			if hook and hook.Parent then
				local espMaxDistance = tbl3.ESP_MaxDistance

				if hideSpearTrajectory(hook:GetPivot().Position) <= espMaxDistance then
					local hookEH = hook:FindFirstChild("HookEH")

					if not hookEH then
						hookEH = Instance.new("Highlight")
						hookEH.Name = "HookEH"
						hookEH.Parent = hook
					end

					local hook2 = tbl7.Colors.Hook
					hookEH.FillColor = hook2
					hookEH.OutlineColor = hook2
					local n = tbl3.ESP_Outline and 1
					local trans

					if n then
						trans = n
					else
						trans = tbl3.Trans or 0.7
					end

					hookEH.FillTransparency = trans
					hookEH.OutlineTransparency = 0.5
				elseif hook:FindFirstChild("HookEH") then
					hook.HookEH:Destroy()
				end
			end
		end
	end

	if tbl3.ESP_Gate then
		for i, gate in ipairs(tbl9.Gates) do
			if gate and gate.Parent then
				local espMaxDistance = tbl3.ESP_MaxDistance

				if hideSpearTrajectory(gate:GetPivot().Position) <= espMaxDistance then
					if not gate:FindFirstChild("Main") then
						gate:FindFirstChildWhichIsA("BasePart")
					end

					local gateEH = gate:FindFirstChild("GateEH")

					if not gateEH then
						gateEH = Instance.new("Highlight")
						gateEH.Name = "GateEH"
						gateEH.Parent = gate
					end

					local gate2 = tbl7.Colors.Gate
					gateEH.Adornee = gate
					gateEH.FillColor = gate2
					gateEH.OutlineColor = gate2
					gateEH.FillTransparency = tbl3.ESP_Outline and 1 or 0.5
					gateEH.OutlineTransparency = 0
					local exitLever = gate:FindFirstChild("ExitLever")
					local n = 0

					if exitLever then
						local main = exitLever:FindFirstChild("Main")
						local n2 = 0

						if main then
							n = math.floor(main:GetAttribute("ActivationProgress") or 0)
						else
							n = n2
						end
					end

					createBillboardESP(gate, "GateE_Text", {
						name = "Gate " .. i,
						subtext = string.format("[%d%%]", n),
						color = gate2,
						icon = nil,
						lineScale = 0.2,
					})
				else
					if gate:FindFirstChild("GateEH") then
						gate.GateEH:Destroy()
					end

					if gate:FindFirstChild("GateE_Text") then
						gate.GateE_Text:Destroy()
					end
				end
			end
		end
	end
end

local part
part = Instance.new("Part")
part.Name = "PLaser"
part.Material = Enum.Material.Neon
part.Color = Color3.fromRGB(57, 255, 20)
part.CanCollide = false
part.Anchored = true
part.CastShadow = false
part.Size = Vector3.new(0.05, 0.05, 1.5)

pcall(function()
	local trajectory = tbl.Workspace.Terrain:FindFirstChild("Trajectory") or tbl.Workspace:FindFirstChild("Trajectory")

	if trajectory then
		trajectory:Destroy()
	end
end)

local highlight
highlight = Instance.new("Highlight")
highlight.Name = "VTarget"
highlight.FillColor = Color3.fromRGB(255, 0, 0)
highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
highlight.FillTransparency = 0.5
highlight.OutlineTransparency = 0
local hideSpearTrajectory, renderSpearTrajectory

do
	local circle = Drawing.new("Circle")
	circle.Filled = true
	circle.Radius = 6
	circle.Color = Color3.fromRGB(0, 220, 255)
	circle.Transparency = 0.9
	circle.Visible = false
	local n = 15
	local folder = Instance.new("Folder")
	folder.Name = "Trajectory"
	folder.Parent = tbl.Workspace.Terrain
	local tbl12 = {}
	local tbl13 = {}

	for i = 1, n + 1 do
		local attachment = Instance.new("Attachment")
		attachment.Name = "Att_" .. i
		attachment.Parent = folder
		table.insert(tbl12, attachment)
	end

	for i = 1, 15 do
		local beam = Instance.new("Beam")
		beam.Attachment0 = tbl12[i]
		beam.Attachment1 = tbl12[i + 1]
		beam.Width0 = 0.12
		beam.Width1 = 0.12
		beam.FaceCamera = true
		beam.Color = ColorSequence.new(Color3.fromRGB(0, 220, 255))
		beam.LightEmission = 1
		beam.LightInfluence = 0
		beam.Texture = "rbxassetid://4740112440"
		beam.TextureSpeed = 2
		beam.Enabled = false
		beam.Parent = folder
		table.insert(tbl13, beam)
	end

	hideSpearTrajectory = function()
		for _, v3 in ipairs(tbl13) do
			v3.Enabled = false
		end

		circle.Visible = false
	end

	renderSpearTrajectory = function(arg, arg2, arg3, arg4, arg5, arg6, arg7)
		local n2 = arg2 * arg3
		local n3 = math.max(tbl3.SPEAR_MaxDist or 500, 500)
		local position3 = arg6 and arg6.Position
		local magnitude = position3 and (position3 - arg).Magnitude or 100
		local n4 = magnitude / arg3 / n
		local vector = Vector3.new(0, -arg4, 0)
		local tbl14 = { arg }
		arg7 = arg7 or position3
		local huge = math.huge

		for i = 1, 15 do
			arg = arg + n2 * n4 + 0.5 * vector * n4 ^ 2
			table.insert(tbl14, arg)

			if arg7 then
				local magnitude2 = (arg - arg7).Magnitude

				if magnitude2 < huge then
					huge = magnitude2
				end
			end

			n2 = n2 + vector * n4
		end

		local flag3 = arg6 ~= nil and magnitude <= n3 and huge <= 6
		local colorSequence = ColorSequence.new(flag3 and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(255, 60, 60))

		for i = 1, #tbl14 do
			if tbl12[i] then
				tbl12[i].WorldPosition = tbl14[i]
			end
		end

		for i = 1, 15 do
			if i < #tbl14 and tbl3.Veil_ShowLaser then
				tbl13[i].Color = colorSequence
				tbl13[i].Enabled = true
			else
				tbl13[i].Enabled = false
			end
		end

		if arg6 then
			local v3, v4 = tbl.Camera:WorldToViewportPoint(arg6.Position)

			if v4 and v3.Z > 0 then
				circle.Position = Vector2.new(v3.X, v3.Y)
				circle.Visible = true

				if flag3 then
					circle.Color = Color3.fromRGB(0, 255, 120)
				else
					circle.Color = Color3.fromRGB(255, 60, 60)
				end
			else
				circle.Visible = false
			end
		else
			circle.Visible = false
		end
	end

	local tbl14 = {}

	local function applyFullbright()
		if not tbl3.Misc_Fullbright then
			return
		end

		if tbl.Lighting.Brightness ~= 1 then
			tbl.Lighting.Brightness = 1
		end

		if tbl.Lighting.FogEnd ~= 100000 then
			tbl.Lighting.FogEnd = 100000
		end

		if tbl.Lighting.GlobalShadows ~= false then
			tbl.Lighting.GlobalShadows = false
		end

		if tbl.Lighting.OutdoorAmbient ~= Color3.fromRGB(255, 255, 255) then
			tbl.Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
		end

		if tbl.Lighting.Ambient ~= Color3.fromRGB(255, 255, 255) then
			tbl.Lighting.Ambient = Color3.fromRGB(255, 255, 255)
		end

		local atmosphere = tbl.Lighting:FindFirstChildOfClass("Atmosphere")

		if atmosphere and atmosphere.Density ~= 0 then
			atmosphere.Density = 0
		end
	end

	local function startFullbrightLoop()
		for _, v3 in ipairs(tbl14) do
			if v3.Connected then
				v3:Disconnect()
			end
		end

		table.clear(tbl14)

		for _, v3 in ipairs({ "Brightness", "FogEnd", "GlobalShadows", "OutdoorAmbient", "Ambient" }) do
			local connection3 = tbl.Lighting:GetPropertyChangedSignal(v3):Connect(function()
				if tbl3.Misc_Fullbright then
					applyFullbright()
				end
			end)

			table.insert(tbl14, connection3)
		end

		local connection3 = tbl.Lighting.ChildAdded:Connect(function(child)
			if tbl3.Misc_Fullbright and child:IsA("Atmosphere") then
				child.Density = 0
			end
		end)

		table.insert(tbl14, connection3)
	end

	local function stopFullbrightLoop()
		for _, v3 in ipairs(tbl14) do
			if v3.Connected then
				v3:Disconnect()
			end
		end

		table.clear(tbl14)
	end

	local function findAimTarget(arg)
		local selfHrp = humanoidRootPart
		if not selfHrp then return nil end
		if arg == "Pistol" and tbl3.Pistol_BlockKnocked and isKnockedOrHooked(selfHrp.Parent) then
			return nil
		end

		local selfPos = selfHrp.Position
		local currentRole = tbl6.cachedRole

		local targetPartName
		if arg == "Aimbot" or arg == "Pistol" or arg == "Flash" then
			local ap = tbl3.AIM_TargetPart
			if ap == "Head" or ap == 1 then targetPartName = "Head"
			elseif ap == "Torso" or ap == 2 then targetPartName = "Torso"
			else targetPartName = "HumanoidRootPart" end
		else
			targetPartName = "HumanoidRootPart"
		end

		local wantKiller, wantSurvivor
		local maxDist = math.huge
		local useFOV, fovRadius, center

		if arg == "Aimbot" then
			if currentRole == "Survivor" then
				wantKiller = true
				maxDist = tbl3.Aimbot_MaxDist
			else
				wantSurvivor = true
				maxDist = 10
			end
			if tbl3.Aimbot_ShowFOV and currentRole ~= "Killer" then
				useFOV = true
				fovRadius = tbl3.Aimbot_Radius
				center = Vector2.new(tbl.Camera.ViewportSize.X / 2, tbl.Camera.ViewportSize.Y / 2)
			end
		elseif arg == "Pistol" then
			local pt = tbl3.Pistol_Target
			if pt == "Killer" then wantKiller = true
			elseif pt == "Survivor" then wantSurvivor = true end
			if tbl3.Pistol_FOVMode then
				useFOV = true
				fovRadius = tbl3.Pistol_FOV
				center = Vector2.new(tbl.Camera.ViewportSize.X / 2, tbl.Camera.ViewportSize.Y / 2)
			end
		elseif arg == "Survivor" then
			wantSurvivor = true
			maxDist = tbl3.SPEAR_MaxDist
			if tbl3.Veil_ShowFOV then
				useFOV = true
				fovRadius = tbl3.Veil_FOV
				center = Vector2.new(tbl.Camera.ViewportSize.X / 2, tbl.Camera.ViewportSize.Y / 2)
			end
		elseif arg == "Killer" or arg == "Flash" then
			wantKiller = true
		end

		local bestScore = math.huge
		local bestTarget = nil

		for _, cache in pairs(_playerCache) do
			if wantKiller and not cache.isKiller then continue end
			if wantSurvivor and cache.isKiller then continue end
			local ch = cache.character
			if not ch then continue end
			local h = cache.humanoid
			if not h or h.Health <= 0 or isKnockedOrHooked(ch) then continue end

			local torso
			if targetPartName == "HumanoidRootPart" then
				torso = cache.hrp
			else
				torso = ch:FindFirstChild(targetPartName) or ch:FindFirstChild("Torso") or cache.hrp
			end
			if not torso then continue end

			local dist = (torso.Position - selfPos).Magnitude
			if dist > maxDist then continue end

			local score
			if useFOV then
				local vp, vis = tbl.Camera:WorldToViewportPoint(torso.Position)
				if not vis then continue end
				local sd = (Vector2.new(vp.X, vp.Y) - center).Magnitude
				if sd > fovRadius then continue end
				score = sd
			else
				score = dist
			end

			if score < bestScore then
				bestScore = score
				bestTarget = torso
			end
		end

		if arg == "Pistol" and tbl3.Pistol_Target == "SCP" then
			if not center then
				center = Vector2.new(tbl.Camera.ViewportSize.X / 2, tbl.Camera.ViewportSize.Y / 2)
			end
			for _, scP in ipairs(tbl9.SCPs) do
				if scP and scP.Parent then
					local h = scP:FindFirstChildOfClass("Humanoid")
					local hrp3 = scP:FindFirstChild("HumanoidRootPart") or scP.PrimaryPart
					if h and hrp3 and math.floor(h.WalkSpeed) > 0 and math.floor(h.WalkSpeed) ~= 16 then
						local ap = tbl3.AIM_TargetPart
						local tgt = hrp3
						if (ap == "Head" or ap == 1) and scP:FindFirstChild("Head") then tgt = scP.Head
						elseif (ap == "Torso" or ap == 2) and scP:FindFirstChild("Torso") then tgt = scP.Torso end
						local score
						if tbl3.Pistol_FOVMode then
							local vp, vis = tbl.Camera:WorldToViewportPoint(tgt.Position)
							if not vis then continue end
							local sd = (Vector2.new(vp.X, vp.Y) - center).Magnitude
							if sd > tbl3.Pistol_FOV then continue end
							score = sd
						else
							score = (tgt.Position - selfPos).Magnitude
						end
						if score < bestScore then bestScore = score bestTarget = tgt end
					end
				end
			end
		end

		return bestTarget
	end

	local function showFOVCircle()
		pcall(function()
			local playerGui = tbl.LocalPlayer:FindFirstChild("PlayerGui")
			if not playerGui then
				return
			end
			local survivorMob = playerGui:FindFirstChild("Survivor-mob")
			local guiMob = survivorMob and survivorMob:FindFirstChild("Controls") and survivorMob.Controls:FindFirstChild("Gui-mob")

			if guiMob and guiMob:IsA("GuiObject") and guiMob.Visible then
				if type(firesignal) == "function" then
					pcall(function()
						firesignal(guiMob.MouseButton1Down)
						task.wait(0.01)
						firesignal(guiMob.MouseButton1Up)
					end)
				end
			else
				pcall(function()
					tbl.VirtualInputManager:SendMouseButtonEvent(0, 0, 1, true, game, 0)
					task.wait(0.01)
					tbl.VirtualInputManager:SendMouseButtonEvent(0, 0, 1, false, game, 0)
				end)
			end
		end)
	end

	local function fireParryInput()
		if tbl6.ParryCooldown then return end
		local delay = (tbl3.Surv_ParryDelay or 0) / 1000
		if delay > 0 then task.wait(delay) end
		if tbl6.ParryCooldown then return end
		pcall(function()
			if parry then parry:FireServer() end
			task.spawn(showFOVCircle)
		end)
	end

	local tbl15 = {}

	local function startAutoParryV1()
		table.clear(tbl15)
		for player, cache in pairs(_playerCache) do
			if cache.isKiller and cache.character then
				table.insert(tbl15, player)
			end
		end
	end

	tbl.Players.PlayerAdded:Connect(startAutoParryV1)
	tbl.Players.PlayerRemoving:Connect(startAutoParryV1)
	for _, player in ipairs(tbl.Players:GetPlayers()) do
		player:GetPropertyChangedSignal("Team"):Connect(startAutoParryV1)
	end

	local _pv2Frame = 0

	local function startAutoParryV2(arg)
		if arg then
			if tbl6.Pv2Con then return end
			tbl6.Pv2Con = tbl.RunService.Heartbeat:Connect(function()
				_pv2Frame = _pv2Frame + 1
				if _pv2Frame % 2 ~= 0 then return end
				if tbl6.ParryCooldown then return end
				local selfHrp = humanoidRootPart
				if not selfHrp or not selfHrp.Parent then return end
				local character = selfHrp.Parent
				if isKnockedOrHooked(character) or not canSafeParry(character) then return end
				local selfPos = selfHrp.Position
				local radius = (tbl3.Surv_ParryRadius or 15) + 5
				local parryRadius = tbl3.Surv_ParryRadius
				local parryFace = tbl3.Surv_ParryFace or 0.3
				for _, cache in pairs(_playerCache) do
					if not cache.isKiller then continue end
					local killerHrp = cache.hrp
					if not killerHrp or not killerHrp.Parent then continue end
					local anim = cache.animator
					if not anim then continue end
					local killerPos = killerHrp.Position
					local magnitude = (selfPos - killerPos).Magnitude
					if magnitude > radius then continue end
					local fd = Vector3.new(selfPos.X - killerPos.X, 0, selfPos.Z - killerPos.Z)
					if fd.Magnitude > 0 then
						local lv = killerHrp.CFrame.LookVector
						local ld = Vector3.new(lv.X, 0, lv.Z)
						if ld.Magnitude > 0.001 and ld.Unit:Dot(fd.Unit) < parryFace then continue end
					end
					local tracks = anim:GetPlayingAnimationTracks()
					for _, track in ipairs(tracks) do
						if not tbl6.TrackV2[track] then
							tbl6.TrackV2[track] = true
							local animId = (track.Animation and track.Animation.AnimationId or ""):match("%d+")
							local v4 = tbl5[animId]
							if v4 and not (tbl3.Ignored_Skills_List and tbl3.Ignored_Skills_List[v4]) and magnitude <= parryRadius then
								fireParryInput()
							end
						end
					end
				end
				if _pv2Frame % 12 == 0 then
					for k in pairs(tbl6.TrackV2) do
						if not k.IsPlaying then tbl6.TrackV2[k] = nil end
					end
				end
			end)
		else
			if tbl6.Pv2Con then
				tbl6.Pv2Con:Disconnect()
				tbl6.Pv2Con = nil
			end
			table.clear(tbl6.TrackV2)
		end
	end

	local function getKillerPredictedPos(killerHrp)
		if not tbl3.Surv_PingParry then
			return killerHrp.Position
		end
		local ping = 80
		pcall(function()
			local stats = game:GetService("Stats")
			ping = stats.Network.ServerStatsItem["Data Ping"]:GetValue()
		end)
		ping = math.clamp(ping, 10, 500) / 1000
		local vel = tbl6.KillerVelocity[killerHrp]
		if vel then
			return killerHrp.Position + vel * (ping * 0.5)
		end
		return killerHrp.Position
	end

	do
		task.spawn(function()
			while not tbl6.Unloaded do
				task.wait(0.1)
				if not tbl3.Surv_PingParry then continue end
				local now = tick()
				for _, cache in pairs(_playerCache) do
					if not cache.isKiller then continue end
					local khrp = cache.hrp
					if not khrp or not khrp.Parent then continue end
					local curPos = khrp.Position
					local prev = tbl6.KillerPosHistory[khrp]
					if prev then
						local dt = now - prev.t
						if dt > 0 then
							tbl6.KillerVelocity[khrp] = (curPos - prev.p) * (1 / dt)
						end
					end
					tbl6.KillerPosHistory[khrp] = { p = curPos, t = now }
				end
				for k in pairs(tbl6.KillerPosHistory) do
					if not k or not k.Parent then
						tbl6.KillerPosHistory[k] = nil
						tbl6.KillerVelocity[k] = nil
					end
				end
			end
		end)
	end

	local function findKillerMobGui()
		local playerGui = tbl.LocalPlayer:FindFirstChild("PlayerGui")
		if not playerGui then
			return nil
		end

		for _, child in pairs(playerGui:GetChildren()) do
			if string.sub(child.Name, -4) == "-mob" and child.Name ~= "Survivor-mob" then
				return child
			end
		end

		return nil
	end

	local function lerpCameraTarget(arg, arg2)
		if not arg then
			return
		end
		arg2 = arg2 or 0.2
		tbl.Camera.CFrame = tbl.Camera.CFrame:Lerp(CFrame.lookAt(tbl.Camera.CFrame.Position, arg.Position), arg2)
	end

	local function predictTarget(arg, arg2, arg3)
		local position3 = arg2.Position
		if not tbl3.Predict then
			return position3
		end
		local parent = arg2.Parent
		parent = parent and parent:FindFirstChildOfClass("Humanoid")
		local n2 = 0
		local vector = Vector3.zero

		if parent then
			vector = parent.MoveDirection * parent.WalkSpeed
			n2 = vector.Magnitude
		end

		if n2 < 0.1 then
			return position3
		end
		return position3 + vector * ((position3 - arg).Magnitude / arg3 * tbl3.Pistol_PredictLead + math.clamp(tbl6.CurrentPing, 0, 0.25))
	end

	local function firePistolAim()
		local Pistol = findAimTarget("Pistol")
		local character = tbl.LocalPlayer.Character
		if tbl3.Pistol_BlockKnocked and isIncapacitated(character) then
			return
		end

		if Pistol and character then
			local humanoidRootPart2 = character:FindFirstChild("HumanoidRootPart")
			character:FindFirstChild("Right Arm")

			if humanoidRootPart2 then
				local twistOfFate = character:FindFirstChild("Twist of Fate")

				if twistOfFate then
					local rightArm = twistOfFate:FindFirstChild("Right Arm")

					if rightArm then
						if rightArm:FindFirstChild("EmperorGun") then
							twistOfFate = rightArm:FindFirstChild("EmperorGun")
						elseif rightArm:FindFirstChild("gun") then
							twistOfFate = rightArm:FindFirstChild("gun")
						else
							twistOfFate = rightArm
						end
					end

					local position3 = humanoidRootPart2.Position
					local v3 = predictTarget(position3, Pistol, 160)

					if (v3 - position3).Magnitude < 4 then
						v3 = v3 - Pistol.CFrame.RightVector * -2
					end

					local unit = (v3 + Vector3.new(0, tbl3.Pistol_AimOffset, 0) - position3).Unit
					local remotes2 = tbl.ReplicatedStorage:FindFirstChild("Remotes")

					if remotes2 and remotes2:FindFirstChild("Items") and remotes2.Items:FindFirstChild("Twist of Fate") and remotes2.Items["Twist of Fate"]:FindFirstChild("Fire") then
						remotes2.Items["Twist of Fate"].Fire:FireServer(twistOfFate, unit)
					end
				end
			end
		end
	end

	local function startInfLungeLoop()
		if tbl6.isHoldingLunge then
			return
		end
		tbl6.isHoldingLunge = true

		task.spawn(function()
			while tbl6.isHoldingLunge and tbl3.Killer_InfLunge and tbl6.cachedRole == "Killer" do
				pcall(function()
					game:GetService("ReplicatedStorage").Remotes.Attacks.Lunge:FireServer()
				end)

				task.wait(0.05)
			end
		end)
	end

	local function setLungeboost(arg)
		if not arg then
			return
		end
		arg:SetAttribute("lungeboost", 999)

		if tbl6.lungeV2Connection then
			tbl6.lungeV2Connection:Disconnect()
		end

		tbl6.lungeV2Connection = arg:GetAttributeChangedSignal("lungeboost"):Connect(function()
			if tbl3.Killer_InfLungeV2 and arg:GetAttribute("lungeboost") ~= 999 then
				arg:SetAttribute("lungeboost", 999)
			end
		end)
	end

	tbl.LocalPlayer.CharacterAdded:Connect(function(character)
		if tbl3.Killer_InfLungeV2 then
			task.wait(0.5)
			setLungeboost(character)
		end
	end)

	local tbl16 = { "Killer", "Survivor", "SCP" }
	local n2 = 1

	local function cycleTargetType()
		n2 = n2 + 1

		if n2 > #tbl16 then
			n2 = 1
		end

		local target = tbl16[n2]
		tbl3.Pistol_Target = target
		textLabel4.Text = "Target: " .. target

		pcall(function()
			if Options and Options.Pistol_Target_Drop then
				Options.Pistol_Target_Drop:SetValue(target)
			end
		end)

		if getgenv().Library then
			sendNotif("Pistol Target: " .. target, 0.5)
		end
	end

	textButton.MouseButton1Click:Connect(cycleTargetType)

	local function updateCrosshair()
		if tbl6.CrosshairUI then
			tbl6.CrosshairUI:Destroy()
		end

		if not tbl3.Crosshair_Enabled then
			return
		end
		tbl6.CrosshairUI = Instance.new("ScreenGui", tbl.CoreGui)
		tbl6.CrosshairUI.Name = "Croshair"
		tbl6.CrosshairUI.IgnoreGuiInset = true
		local frame6 = Instance.new("Frame", tbl6.CrosshairUI)
		frame6.AnchorPoint = Vector2.new(0.5, 0.5)
		frame6.Position = UDim2.new(0.5, tbl3.Crosshair_OffsetX, 0.5, tbl3.Crosshair_OffsetY)
		frame6.Size = UDim2.new(0, 0, 0, 0)
		frame6.BackgroundTransparency = 1
		local crosshairSize = tbl3.Crosshair_Size
		local crosshairColor = tbl3.Crosshair_Color
		local thickness = math.max(1, math.floor(crosshairSize / 4))
		local n3 = crosshairSize * 2
		local n4 = math.max(2, math.floor(crosshairSize / 1.5))

		if tbl3.Crosshair_Type == "Dot" then
			local frame7 = Instance.new("Frame", frame6)
			frame7.AnchorPoint = Vector2.new(0.5, 0.5)
			frame7.Size = UDim2.new(0, crosshairSize, 0, crosshairSize)
			frame7.Position = UDim2.new(0.5, 0, 0.5, 0)
			frame7.BackgroundColor3 = crosshairColor
			Instance.new("UICorner", frame7).CornerRadius = UDim.new(1, 0)
		elseif tbl3.Crosshair_Type == "Cross" then
			local frame7 = Instance.new("Frame", frame6)
			frame7.AnchorPoint = Vector2.new(0.5, 1)
			frame7.Size = UDim2.new(0, thickness, 0, n3)
			frame7.Position = UDim2.new(0.5, 0, 0.5, -n4)
			frame7.BackgroundColor3 = crosshairColor
			local frame8 = Instance.new("Frame", frame6)
			frame8.AnchorPoint = Vector2.new(0.5, 0)
			frame8.Size = UDim2.new(0, thickness, 0, n3)
			frame8.Position = UDim2.new(0.5, 0, 0.5, n4)
			frame8.BackgroundColor3 = crosshairColor
			local frame9 = Instance.new("Frame", frame6)
			frame9.AnchorPoint = Vector2.new(1, 0.5)
			frame9.Size = UDim2.new(0, n3, 0, thickness)
			frame9.Position = UDim2.new(0.5, -n4, 0.5, 0)
			frame9.BackgroundColor3 = crosshairColor
			local frame10 = Instance.new("Frame", frame6)
			frame10.AnchorPoint = Vector2.new(0, 0.5)
			frame10.Size = UDim2.new(0, n3, 0, thickness)
			frame10.Position = UDim2.new(0.5, n4, 0.5, 0)
			frame10.BackgroundColor3 = crosshairColor
		elseif tbl3.Crosshair_Type == "Circle" then
			local frame7 = Instance.new("Frame", frame6)
			frame7.AnchorPoint = Vector2.new(0.5, 0.5)
			frame7.Size = UDim2.new(0, crosshairSize * 2.5, 0, crosshairSize * 2.5)
			frame7.Position = UDim2.new(0.5, 0, 0.5, 0)
			frame7.BackgroundTransparency = 1
			local uiStroke3 = Instance.new("UIStroke", frame7)
			uiStroke3.Color = crosshairColor
			uiStroke3.Thickness = thickness
			Instance.new("UICorner", frame7).CornerRadius = UDim.new(1, 0)
		end
	end

	getgenv().VindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Skinny-yz/VVind-UI/refs/heads/main/src.lua"))()
	getgenv().Library = getgenv().VindUI
	getgenv().Toggles = {}
	getgenv().Options = {}

	sendNotif = function(arg, arg2, arg3)
		pcall(function()
			if getgenv().VindUI then
				getgenv().VindUI:Notify({
					Title = "PerplexWare",
					Text = tostring(arg),
					Type = "info",
					Duration = arg2 or 3,
				})
			end
		end)
	end

	getgenv().Window = getgenv().VindUI:CreateWindow({
		Title = "PerplexWare",
		Subtitle = "By @rainlover.r",
		Icon = "Lucide:sparkles",
		Size = UDim2.fromOffset(660, 460),
		MinSize = Vector2.new(500, 360),
		Draggable = true,
		Resizable = true,
		UseBlur = true,
		DefaultTab = "Survivor",
		ToggleKeybind = Enum.KeyCode.RightControl,
	})

	local WindowRef = getgenv().Window
	local VindUI = getgenv().VindUI
	local toggles = getgenv().Toggles
	local options = getgenv().Options

	local function makeTogProxy(elem, defVal)
		local p = { Value = defVal or false }
		function p:SetValue(v)
			pcall(function() if elem then elem:Set(v) end end)
			p.Value = v
		end
		return p
	end

	local function makeOptProxy(elem, defVal)
		local p = { Value = defVal }
		function p:SetValue(v)
			pcall(function() if elem then elem:Set(v) end end)
			p.Value = v
		end
		function p:SetValues(vals)
			pcall(function()
				if elem then
					if elem.Refresh then elem:Refresh(vals)
					elseif elem.SetOptions then elem:SetOptions(vals) end
				end
			end)
		end
		return p
	end

	local function buildUITabs()
		local SurvTab = WindowRef:AddTab({ Name = "Survivor", Icon = "Lucide:shield-plus" })
		local KillTab = WindowRef:AddTab({ Name = "Killer", Icon = "Lucide:skull" })
		local TeleTab = WindowRef:AddTab({ Name = "Teleport", Icon = "Lucide:map-pin" })
		local EspTab  = WindowRef:AddTab({ Name = "ESP", Icon = "Lucide:eye" })
		local AimTab  = WindowRef:AddTab({ Name = "Aim", Icon = "Lucide:crosshair" })
		local MiscTab = WindowRef:AddTab({ Name = "Misc", Icon = "Lucide:sliders-horizontal" })
		local InfoTab = WindowRef:AddTab({ Name = "Info", Icon = "Lucide:badge-info" })

		local SurvAutoST  = SurvTab:AddSubTab({ Name = "Auto Bot", Icon = "Lucide:bot" })
		local SurvCombatST = SurvTab:AddSubTab({ Name = "Combat", Icon = "Lucide:sword" })
		local SurvSkillsST = SurvTab:AddSubTab({ Name = "Skills", Icon = "Lucide:zap" })

		SurvAutoST:AddSection("Generator", "Lucide:cpu")

		local _t2 = SurvAutoST:AddToggle({
			Text = "Gen + Escape",
			Description = "Auto-repairs generators then teleports to exit",
			Icon = "Lucide:bot",
			Default = false,
			Flag = "Auto_MasterSurvivor",
			Callback = function(v)
				toggles["Auto_MasterSurvivor"].Value = v
				if v and tbl6.cachedRole == "Killer" then
					sendNotif("Access Denied: Auto Gen is for Survivors only!", 4)
					tbl3.AUTO_AutoSurvivor = false
					task.defer(function() toggles["Auto_MasterSurvivor"]:SetValue(false) end)
					return
				end
				tbl3.AUTO_AutoSurvivor = v
				if not v then
					task.spawn(cancelAutoRepair)
				else
					task.spawn(function()
						while true do
							if tbl3.AUTO_AutoSurvivor and not tbl6.Unloaded then
								task.wait(2)
								if tbl3.AUTO_AutoSurvivor then
									if tbl6.cachedRole == "Survivor" then
										local n3 = #tbl9.Generators
										local n4 = 0
										for _, generator2 in ipairs(tbl9.Generators) do
											local prog = generator2.model:GetAttribute("RepairProgress") or generator2.model:FindFirstChild("RepairProgress") and generator2.model.RepairProgress.Value or 0
											if prog >= 100 then n4 = n4 + 1 end
										end
										if n3 >= 5 and n4 >= 5 then
											if tbl3.AUTO_Generator then task.spawn(cancelAutoRepair) end
											tbl3.AUTO_AutoSurvivor = false
											task.defer(function() toggles["Auto_MasterSurvivor"]:SetValue(false) end)
											if teleportToExit() then sendNotif("Teleported to exit!", 3) end
											continue
										else
											local v9 = getNearestKillerDist()
											local v10 = findBestGenerator()
											if v9 <= tbl3.AUTO_LeaveDist then
												if tbl3.AUTO_Generator then task.spawn(cancelAutoRepair) task.wait(0.5) end
												if tbl3.AUTO_AutoSurvivor then
													if v10 then teleportToGenerator(v10) tbl3.AUTO_Generator = true runAutoRepair()
													else doAutoFlee() end
													continue
												end
											elseif v10 then
												if getDistanceTo(v10.part.Position) > 20 then
													if tbl3.AUTO_Generator then task.spawn(cancelAutoRepair) task.wait(0.5) end
													if tbl3.AUTO_AutoSurvivor then teleportToGenerator(v10) tbl3.AUTO_Generator = true runAutoRepair() continue end
												else tbl3.AUTO_Generator = true runAutoRepair() continue end
											else continue end
										end
									else continue end
								end
							end
							break
						end
					end)
				end
			end,
		})
		toggles["Auto_MasterSurvivor"] = makeTogProxy(_t2, false)

		local _dg = SurvAutoST:AddToggle({
			Text = "Multi Generator",
			Description = "Repair generator at multiple points",
			Icon = "Lucide:cpu",
			Default = false,
			Flag = "Surv_DoubleGenToggle",
			Callback = function(v) toggles["Surv_DoubleGenToggle"].Value = v setDoubleGen(v) end,
		})
		toggles["Surv_DoubleGenToggle"] = makeTogProxy(_dg, false)

		SurvAutoST:AddSlider({
			Text = "Distance from Killer",
			Description = "Cancel gen if killer is within this range",
			Icon = "Lucide:ruler",
			Min = 20, Max = 100, Default = 45, Increment = 1,
			Flag = "Auto_LeaveDist",
			Callback = function(v) tbl3.AUTO_LeaveDist = v end,
		})

		SurvAutoST:AddButton({
			Text = "Cancel Gen",
			Description = "Stop auto generator task",
			Icon = "Lucide:circle-x",
			Callback = function()
				if toggles["Auto_MasterSurvivor"] then toggles["Auto_MasterSurvivor"]:SetValue(false) end
				task.spawn(cancelAutoRepair)
			end,
		})

		SurvAutoST:AddSection("Auto Feature", "Lucide:zap")

		SurvAutoST:AddButton({
			Text = "Auto Escape",
			Description = "Teleport to the nearest exit gate",
			Icon = "Lucide:door-open",
			Callback = function()
				if teleportToExit() then sendNotif("Teleported to exit!", 3)
				else sendNotif("No exit found!", 3) end
			end,
		})

		SurvAutoST:AddButton({
			Text = "Drop All Pallets",
			Description = "Instantly drop every pallet on the map",
			Icon = "Lucide:layers",
			Callback = function()
				task.spawn(function()
					local pde
					for i = 1, 5 do
						local r = tbl.ReplicatedStorage:FindFirstChild("Remotes")
						if r and r:FindFirstChild("Pallet") then
							pde = r.Pallet:FindFirstChild("PalletDropEvent")
							if pde then break end
						end
						task.wait(0.5)
					end
					if not pde then sendNotif("PalletDropEvent not found!", 3) return end
					local n3 = 0
					for _, p in ipairs(tbl9.Pallets) do
						local tr = p.trigger or (p.model and (p.model:FindFirstChild("PalletPointSlide", true) or p.model:FindFirstChild("PalletPoint", true))) or p.model
						if tr then pcall(function() pde:FireServer(tr) end) n3 = n3 + 1 end
					end
					sendNotif("Dropped " .. n3 .. " pallets.", 3)
				end)
			end,
		})

		local _ab = SurvAutoST:AddToggle({
			Text = "Anti Block Window",
			Description = "Auto-clears window thorns and blockers nearby",
			Icon = "Lucide:shield-off",
			Default = false,
			Flag = "AntiBlockWindowToggle",
			Callback = function(arg)
				toggles["AntiBlockWindowToggle"].Value = arg
				if not arg then if tbl6.blockThread then task.cancel(tbl6.blockThread) tbl6.blockThread = nil end return end
				tbl6.blockThread = task.spawn(function()
					local CS = game:GetService("CollectionService")
					while task.wait(1) do
						pcall(function()
							local ch = tbl.LocalPlayer.Character
							if not ch or not ch:FindFirstChild("HumanoidRootPart") then return end
							local hrp = ch.HumanoidRootPart
							for _, tag in ipairs({ "BlockedVault", "BlockedWindow", "Blocked", "EntityBlocker" }) do
								for _, v9 in ipairs(CS:GetTagged(tag)) do CS:RemoveTag(v9, tag) end
							end
							for _, p in ipairs(tbl.Workspace:GetPartBoundsInRadius(hrp.Position, 40)) do
								if p:GetAttribute("Blocked") ~= nil then p:SetAttribute("Blocked", false) end
								if p:GetAttribute("IsBlocked") ~= nil then p:SetAttribute("IsBlocked", false) end
								if p:GetAttribute("Spiked") ~= nil then p:SetAttribute("Spiked", false) end
								local n = p.Name:lower()
								if n:match("spike") or n:match("blocker") or n:match("entity") then
									if p.CanCollide then p.CanCollide = false end
									if p.Transparency ~= 1 then p.Transparency = 1 end
								end
							end
						end)
					end
				end)
			end,
		})
		toggles["AntiBlockWindowToggle"] = makeTogProxy(_ab, false)

		local _ap = SurvAutoST:AddToggle({
			Text = "Auto Drop Pallet",
			Description = "Automatically drops pallets on nearby killers",
			Icon = "Lucide:layers-2",
			Default = false,
			Flag = "Surv_AutoPalletToggle",
			Callback = function(v) toggles["Surv_AutoPalletToggle"].Value = v setAutoPallet(v) end,
		})
		toggles["Surv_AutoPalletToggle"] = makeTogProxy(_ap, false)

		SurvAutoST:AddSlider({
			Text = "Pallet Radius",
			Min = 5, Max = 20, Default = 10, Increment = 1,
			Flag = "Surv_AutoPalletRadius",
			Callback = function(v) tbl3.Surv_AutoPalletRadius = v end,
		})

		SurvAutoST:AddToggle({ Text = "Pallet Save Team", Default = false, Flag = "Surv_AutoPalletSF", Callback = function(v) tbl3.Surv_AutoPalletSF = v end })
		SurvAutoST:AddToggle({ Text = "Safe Mode (Pallet)", Default = true, Flag = "Surv_AutoPalletSM", Callback = function(v) tbl3.Surv_AutoPalletSM = v end })

		local _sh = SurvAutoST:AddToggle({
			Text = "Self Heal",
			Description = "Toggle self-healing progress",
			Icon = "Lucide:heart-pulse",
			Default = false,
			Flag = "Surv_SelfHeal",
			Callback = function(v) toggles["Surv_SelfHeal"].Value = v tbl3.Surv_SelfHeal = v end,
		})
		toggles["Surv_SelfHeal"] = makeTogProxy(_sh, false)

		SurvAutoST:AddToggle({ Text = "Auto Heal Team", Default = false, Flag = "Surv_AuraHeal", Callback = function(v) tbl3.Surv_AuraHeal = v end })

		SurvCombatST:AddSection("Auto Parry", "Lucide:shield")

		local function applyParryMethod(on)
			tbl3.Surv_AutoParry = on
			tbl3.Surv_Parry = on and tbl3.Surv_ParryMethod == "Legit"
			tbl3.Surv_ParryV2 = false
			startAutoParryV2(on and tbl3.Surv_ParryMethod == "Bold")
			if tbl6.ParryAnimBaseCon then
				tbl6.ParryAnimBaseCon:Disconnect()
				tbl6.ParryAnimBaseCon = nil
			end
			if on and tbl3.Surv_ParryMethod == "Anim Base" then
				tbl6.ParryAnimBaseCon = tbl.RunService.Heartbeat:Connect(function()
					if tbl6.ParryCooldown then return end
					local selfHrp = humanoidRootPart
					if not selfHrp or not selfHrp.Parent then return end
					local ch = selfHrp.Parent
					if isKnockedOrHooked(ch) or not canSafeParry(ch) then return end
					local selfPos = selfHrp.Position
					local radius = tbl3.Surv_ParryRadius or 15
					for _, cache in pairs(_playerCache) do
						if not cache.isKiller then continue end
						local khrp = cache.hrp
						if not khrp or not khrp.Parent then continue end
						if (selfPos - khrp.Position).Magnitude > radius then continue end
						local anim = cache.animator
						if not anim then continue end
						for _, track in ipairs(anim:GetPlayingAnimationTracks()) do
							local name = track.Animation and track.Name or ""
							if name:lower():match("basic") or name:lower():match("lunge") or name:lower():match("attack") or name:lower():match("swing") then
								if not tbl6.TrackV2[track] then
									tbl6.TrackV2[track] = true
									fireParryInput()
								end
							end
						end
					end
				end)
			end
		end

		local _ap = SurvCombatST:AddToggle({
			Text = "Auto Parry  [RISKY]",
			Description = "Auto-parries killer attacks",
			Icon = "Lucide:shield-check",
			Default = false,
			Flag = "Surv_AutoParry",
			Callback = function(v)
				toggles["Surv_AutoParry"].Value = v
				applyParryMethod(v)
			end,
		})
		toggles["Surv_AutoParry"] = makeTogProxy(_ap, false)
		toggles["Surv_Parry"] = toggles["Surv_AutoParry"]
		toggles["Surv_ParryV2"] = { Value = false, SetValue = function(self, v) self.Value = v end }

		SurvCombatST:AddDropdown({
			Text = "Parry Method",
			Description = "Legit = event-based  Bold = proximity  Anim Base = animation name",
			Options = { "Legit", "Bold", "Anim Base" },
			Default = "Legit",
			Flag = "Surv_ParryMethod",
			Callback = function(v)
				tbl3.Surv_ParryMethod = v
				if tbl3.Surv_AutoParry then applyParryMethod(true) end
			end,
		})

		SurvCombatST:AddToggle({
			Text = "Ping Compensation",
			Description = "Compensates killer position by your ping for earlier detection",
			Icon = "Lucide:signal",
			Default = false,
			Flag = "Surv_PingParry",
			Callback = function(v)
				tbl3.Surv_PingParry = v
			end,
		})

		SurvCombatST:AddSlider({
			Text = "Parry Delay",
			Description = "Delay before parry fires",
			Icon = "Lucide:timer",
			Min = 0,
			Max = 200,
			Default = 0,
			Increment = 1,
			Suffix = "ms",
			Flag = "Surv_ParryDelay",
			Callback = function(v) tbl3.Surv_ParryDelay = v end,
		})

		SurvCombatST:AddToggle({
			Text = "Fake Parry  (Keybind: R)",
			Description = "Loads fake parry script",
			Default = false,
			Callback = function(v)
				if v then pcall(function() loadstring(game:HttpGet("https://pastebin.com/raw/WNJGb9ct"))() end)
				elseif getgenv().VD_FakeParry_Cleanup then pcall(getgenv().VD_FakeParry_Cleanup) end
			end,
		})

		SurvCombatST:AddToggle({ Text = "Safety Parry", Default = false, Flag = "Surv_ParrySafety", Callback = function(v) tbl3.Surv_ParrySafety = v end })
		SurvCombatST:AddToggle({ Text = "Aggressive Parry", Default = false, Flag = "Surv_ParryAggressive", Callback = function(v) tbl3.Surv_ParryAggressive = v end })
		SurvCombatST:AddToggle({ Text = "ESP Range (Parry Circle)", Default = true, Flag = "Surv_ParryCircle", Callback = function(v) tbl3.Surv_ParryCircle = v end })

		SurvCombatST:AddSlider({ Text = "Parry Radius", Min = 5, Max = 25, Default = tbl3.Surv_ParryRadius, Increment = 1, Flag = "Surv_ParryRadius", Callback = function(v) tbl3.Surv_ParryRadius = v end })
		SurvCombatST:AddSlider({ Text = "Face Sensitivity", Min = -10, Max = 10, Default = 0, Increment = 1, Flag = "Surv_ParryFace", Callback = function(v) tbl3.Surv_ParryFace = v / 10 end })

		SurvCombatST:AddDropdown({
			Text = "Ignore Skills",
			Options = { "Hidden S1", "Abyssal S1", "Jeff Frenzy" },
			Flag = "Surv_IgnoreSkillsList",
			Callback = function(v) tbl3.Ignored_Skills_List = { v } end,
		})

		SurvCombatST:AddSection("Flee", "Lucide:footprints")

		SurvCombatST:AddToggle({
			Text = "Flee Killer",
			Description = "Auto-move away from killer when knocked",
			Icon = "Lucide:run",
			Default = false,
			Flag = "Surv_AutoFleeToggle",
			Callback = function(survAutoFlee)
				tbl3.Surv_AutoFlee = survAutoFlee
				if survAutoFlee then
					if tbl6.FleeThread then task.cancel(tbl6.FleeThread) end
					tbl6.FleeThread = task.spawn(function()
						while tbl3.Surv_AutoFlee and not tbl6.Unloaded do
							task.wait(0.1)
							if tbl6.cachedRole == "Survivor" then
								local ch = tbl.LocalPlayer.Character
								local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
								local h2 = ch and ch:FindFirstChildOfClass("Humanoid")
								if hrp and h2 and h2.Health > 0 and ch:GetAttribute("Knocked") == true and not ch:GetAttribute("IsHooked") then
									local dist = tbl3.Surv_FleeDistance
									local v9
									for _, player in ipairs(tbl.Players:GetPlayers()) do
										if player ~= tbl.LocalPlayer and isPlayerKiller(player) and player.Character then
											local hrp2 = player.Character:FindFirstChild("HumanoidRootPart")
											if hrp2 then
												local mag = (hrp.Position - hrp2.Position).Magnitude
												if mag < dist then dist = mag v9 = hrp2 end
											end
										end
									end
									if v9 then
										local dir = hrp.Position - v9.Position
										local unit = Vector3.new(dir.X, 0, dir.Z).Unit
										if unit.Magnitude == unit.Magnitude then
											local pos = v9.Position + unit * (tbl3.Surv_FleeDistance + 5)
											hrp.CFrame = CFrame.new(pos.X, hrp.Position.Y + 2, pos.Z)
										end
									end
								end
							end
						end
					end)
				elseif tbl6.FleeThread then task.cancel(tbl6.FleeThread) tbl6.FleeThread = nil end
			end,
		})

		SurvCombatST:AddSlider({ Text = "Flee Distance", Min = 10, Max = 100, Default = 30, Increment = 1, Flag = "Surv_FleeDistance", Callback = function(v) tbl3.Surv_FleeDistance = v end })

		local function syncSkillCheckSettings()
			local mode = tbl3.Surv_SkillCheckMode
			local on = tbl3.Surv_AutoSkillCheck
			tbl3.Surv_PerfectSkill = on and (mode == "Legit" or mode == "Instan" or mode == "Normal" or mode == "Random")
			tbl3.Surv_InstanSkill = on and mode == "Instan"
			tbl3.Surv_NoSkill = on and mode == "Skip"
			task.spawn(function()
				local ch = tbl.LocalPlayer.Character
				if not ch then return end
				local sg = ch:FindFirstChild("Skillcheck-gen")
				local sp = ch:FindFirstChild("Skillcheck-player")
				if sg then sg.Disabled = tbl3.Surv_NoSkill end
				if sp then sp.Disabled = tbl3.Surv_NoSkill end
			end)
		end

		SurvSkillsST:AddSection("Core Skills", "Lucide:star")

		SurvSkillsST:AddToggle({ Text = "God Mode", Description = "Prevents health from dropping", Default = false, Flag = "Surv_GodMode", Callback = function(v) tbl3.Surv_GodMode = v end })
		SurvSkillsST:AddToggle({ Text = "Sound DBD", Description = "Replaces skill check sound with DBD audio", Default = false, Flag = "Surv_SoundDbd", Callback = function(v) tbl3.Surv_SoundDbd = v local ch = tbl.LocalPlayer.Character if ch then applySkillSoundSwap(ch) end end })
		SurvSkillsST:AddToggle({
			Text = "Auto Sprint",
			Description = "Auto-sprints when moving  (Mobile)",
			Default = false,
			Flag = "Surv_AutoSprint",
			Callback = function(v)
				tbl3.Surv_AutoSprint = v
				if v then
					if tbl6.AutoSprintThread then task.cancel(tbl6.AutoSprintThread) end
					tbl6.AutoSprintThread = task.spawn(function()
						while tbl3.Surv_AutoSprint and not tbl6.Unloaded do
							task.wait(0.1)
							local ch = tbl.LocalPlayer.Character
							local h2 = ch and ch:FindFirstChildOfClass("Humanoid")
							if ch and h2 and h2.Health > 0 and not isKnockedOrHooked(ch) and not isIncapacitated(ch) and not (ch:GetAttribute("Crouching") == true) and h2.MoveDirection.Magnitude > 0 then
								local attr = ch:GetAttribute("Sprinting")
								if type(attr) ~= "boolean" then local sp = ch:FindFirstChild("Sprinting") attr = sp and sp:IsA("BoolValue") and sp.Value or false end
								if not attr then
									local sb = tbl.LocalPlayer:FindFirstChild("PlayerGui") and tbl.LocalPlayer.PlayerGui:FindFirstChild("Survivor-mob") and tbl.LocalPlayer.PlayerGui["Survivor-mob"]:FindFirstChild("Controls") and tbl.LocalPlayer.PlayerGui["Survivor-mob"].Controls:FindFirstChild("sprint")
									if sb and sb.Visible then
										if type(firesignal) == "function" then pcall(function() firesignal(sb.MouseButton1Click) end)
										elseif type(firesignal) == "table" then pcall(function() sb.MouseButton1Click:Fire() end) end
									end
								end
							end
						end
					end)
				elseif tbl6.AutoSprintThread then task.cancel(tbl6.AutoSprintThread) tbl6.AutoSprintThread = nil end
			end,
		})
		SurvSkillsST:AddToggle({
			Text = "Auto Skill Check",
			Default = false,
			Flag = "Surv_AutoSkillCheck",
			Callback = function(v) tbl3.Surv_AutoSkillCheck = v syncSkillCheckSettings() end,
		})
		SurvSkillsST:AddDropdown({
			Text = "Skill Check Mode",
			Options = { "Legit", "Instan", "Skip", "Normal", "Random" },
			Default = "Legit",
			Flag = "Surv_SkillCheckMode",
			Callback = function(v) tbl3.Surv_SkillCheckMode = v syncSkillCheckSettings() end,
		})
		SurvSkillsST:AddSlider({ Text = "Skill Check Speed", Min = 1, Max = 30, Default = 10, Increment = 1, Flag = "Surv_SkillSpeed", Callback = function(v) tbl3.Surv_SkillSpeed = v / 10 end })
		SurvSkillsST:AddToggle({ Text = "Anti Fail Gene", Default = false, Flag = "Surv_AntiFailGen", Callback = function(v) tbl3.Surv_AutoCancelGene = v end })
		SurvSkillsST:AddToggle({
			Text = "Instant Teleport  (Gate 0s)",
			Default = false,
			Flag = "Surv_InstantGate",
			Callback = function(survInstantGate)
				tbl3.Surv_InstantGate = survInstantGate
				task.spawn(function()
					local ok, result = pcall(function() return require(tbl.ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Items"):WaitForChild("GateClient")) end)
					if not ok or not result then if survInstantGate then sendNotif("Failed!", 3) end return end
					local tbl18 = {}
					if survInstantGate then
						if not tbl18._isLowHealth then tbl18._isLowHealth = result._isLowHealth end
						if not tbl18.StartGate then tbl18.StartGate = result.StartGate end
						result._isLowHealth = function() return false end
						result.StartGate = function(arg) arg.gateDuration = 0 return tbl18.StartGate(arg) end
					else
						if tbl18._isLowHealth then result._isLowHealth = tbl18._isLowHealth end
						if tbl18.StartGate then result.StartGate = tbl18.StartGate end
					end
				end)
			end,
		})
		SurvSkillsST:AddToggle({ Text = "Auto Crouch Dodge", Default = false, Flag = "Surv_AutoCrouch", Callback = function(v) tbl3.Surv_AutoCrouch = v end })
		SurvSkillsST:AddToggle({ Text = "Instant Bandage", Default = false, Flag = "Surv_Bandage", Callback = function(v) tbl3.Surv_Bandage = v end })
		SurvSkillsST:AddToggle({ Text = "Auto Crouch Veil", Default = false, Flag = "Surv_CrouchV", Callback = function(v) tbl3.Surv_CrouchV = v end })
		SurvSkillsST:AddToggle({ Text = "Anti Slow", Default = false, Flag = "Surv_NoFall", Callback = function(v) tbl3.Surv_NoFall = v end })

		SurvSkillsST:AddSection("Advanced Skills", "Lucide:layers")

		local _pk = SurvSkillsST:AddToggle({
			Text = "Perks Mod",
			Default = false,
			Flag = "Surv_Perks",
			Callback = function(v) toggles["Surv_Perks"].Value = v tbl3.Surv_Perks = v end,
		})
		toggles["Surv_Perks"] = makeTogProxy(_pk, false)

		SurvSkillsST:AddToggle({ Text = "Speed Boost", Default = false, Flag = "Surv_Spdb", Callback = function(v) tbl3.Surv_Spdb = v end })
		SurvSkillsST:AddSlider({ Text = "Speed Boost Value", Min = 10, Max = 20, Default = 11, Increment = 1, Flag = "Surv_SpeedBoost", Callback = function(v) tbl3.Surv_SpeedBoost = v / 10 end })
		SurvSkillsST:AddSlider({ Text = "Vault Speed", Min = 10, Max = 20, Default = 13, Increment = 1, Flag = "Surv_VaultSpeed", Callback = function(v) tbl3.Surv_VaultSpeed = v / 10 end })
		SurvSkillsST:AddToggle({ Text = "Perfect Vault", Default = false, Flag = "Surv_PerfectVault", Callback = function(v) tbl3.Surv_PerfectVault = v end })
		SurvSkillsST:AddToggle({ Text = "Flowstate", Default = false, Flag = "Surv_FastVault",
			Callback = function(v)
				tbl3.Surv_FastVault = v
				if not v then
					if tbl6.FlowstateCDThread then task.cancel(tbl6.FlowstateCDThread) tbl6.FlowstateCDThread = nil end
					tbl6.FlowstateOnCD = false
					local ch = tbl.LocalPlayer.Character
					if ch then ch:SetAttribute("Flowstate", false) end
				end
			end,
		})
		SurvSkillsST:AddSlider({ Text = "Flowstate Cooldown", Min = 5, Max = 60, Default = 20, Increment = 1, Suffix = "s", Flag = "Surv_FlowstateCD", Callback = function(v) tbl3.Surv_FlowstateCD = v end })
		SurvSkillsST:AddToggle({ Text = "Quick Recovery", Default = false, Flag = "Surv_SpeedAfterVault", Callback = function(v) tbl3.Surv_SpeedAfterVault = v end })
		SurvSkillsST:AddSlider({ Text = "Quick Recovery Cooldown", Min = 5, Max = 60, Default = 15, Increment = 1, Suffix = "s", Flag = "Surv_QuickRecovCD", Callback = function(v) tbl3.Surv_QuickRecoveryCD = v end })
		SurvSkillsST:AddToggle({ Text = "Custom FOV", Default = false, Flag = "Surv_Fov", Callback = function(v) tbl3.Surv_Fov = v if not v then tbl.Camera.FieldOfView = 70 end end })
		SurvSkillsST:AddSlider({ Text = "Field of View", Min = 70, Max = 120, Default = 70, Increment = 1, Flag = "Surv_FOV_Value", Callback = function(v) tbl3.Surv_FOV_Value = v end })

		local KillSettST = KillTab:AddSubTab({ Name = "Settings", Icon = "Lucide:settings" })
		local KillCamST  = KillTab:AddSubTab({ Name = "Camera", Icon = "Lucide:camera" })

		KillSettST:AddSection("Speed / Combat", "Lucide:gauge")

		local _kws = KillSettST:AddToggle({
			Text = "Walk Speed",
			Default = false,
			Flag = "Killer_WalkSpeedToggle",
			Callback = function(v)
				toggles["Killer_WalkSpeedToggle"].Value = v
				tbl3.Killer_WalkSpeedToggle = v
				if not v and tbl.LocalPlayer.Character and tbl.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
					tbl.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = tbl6.OriginalSpeed or 16
				end
			end,
		})
		toggles["Killer_WalkSpeedToggle"] = makeTogProxy(_kws, false)

		KillSettST:AddSlider({ Text = "Walk Speed Value", Min = 16, Max = 300, Default = 16, Increment = 1, Suffix = " ws", Flag = "Killer_WalkSpeed", Callback = function(v) tbl3.Killer_WalkSpeed = v end })
		KillSettST:AddDropdown({ Text = "Attack Mode", Options = { "BasicAttack", "Lunge" }, Default = "BasicAttack", Flag = "Killer_AttackMode", Callback = function(v) tbl3.Killer_AttackMode = v end })
		KillSettST:AddToggle({ Text = "One Hit  [RISKY]", Default = false, Flag = "Killer_SpamHit", Callback = function(v) tbl3.Killer_SpamHit = v end })
		KillSettST:AddSlider({ Text = "Hit Radius", Min = 5, Max = 15, Default = 8, Increment = 1, Flag = "Killer_HitRadius", Callback = function(v) tbl3.Killer_SpamHitRadius = v end })
		KillSettST:AddSlider({ Text = "Hit Delay", Min = 15, Max = 500, Default = 50, Increment = 1, Suffix = "ms", Flag = "Killer_HitDelay", Callback = function(v) tbl3.Killer_SpamHitDelay = v end })
		KillSettST:AddToggle({ Text = "Show Hit Range", Default = true, Flag = "Killer_HitEspCircle", Callback = function(v) tbl3.Killer_HitEspCircle = v end })
		KillSettST:AddToggle({ Text = "Auto Aim  (Hidden)", Default = false, Callback = function(v) activateDashLock(v) end })

		KillSettST:AddSection("Killer Skills", "Lucide:bolt")

		KillSettST:AddToggle({ Text = "Counter Parry  (V)", Default = false,
			Callback = function(v)
				if v then pcall(function() loadstring(game:HttpGet(tbl10.SCRIPT .. "/Misc/CParry"))() end)
				elseif getgenv().CParry then pcall(getgenv().CParry) end
			end,
		})

		local _il = KillSettST:AddToggle({
			Text = "Infinite Lunge",
			Default = false,
			Flag = "Killer_InfLunge",
			Callback = function(v) toggles["Killer_InfLunge"].Value = v tbl3.Killer_InfLunge = v if not v then tbl6.isHoldingLunge = false end end,
		})
		toggles["Killer_InfLunge"] = makeTogProxy(_il, false)

		local _il2 = KillSettST:AddToggle({
			Text = "Infinite Lunge V2",
			Default = false,
			Flag = "Killer_InfLungeV2",
			Callback = function(v)
				toggles["Killer_InfLungeV2"].Value = v tbl3.Killer_InfLungeV2 = v
				local ch = tbl.LocalPlayer.Character
				if v then if ch then setLungeboost(ch) end
				else
					if tbl6.lungeV2Connection then tbl6.lungeV2Connection:Disconnect() tbl6.lungeV2Connection = nil end
					if ch then ch:SetAttribute("lungeboost", 1) end
				end
			end,
		})
		toggles["Killer_InfLungeV2"] = makeTogProxy(_il2, false)

		KillSettST:AddToggle({ Text = "Anti Blind", Default = false, Flag = "Anti_Blind", Callback = function(v) tbl3.Anti_Blind = v end })
		KillSettST:AddToggle({ Text = "Infinite Corrupt Abyssal", Default = false, Flag = "Killer_InfAbyssal", Callback = function(v) tbl3.Killer_InfAbyssal = v end })
		KillSettST:AddToggle({ Text = "Block Windows / Pallets  [RISKY]", Default = false, Callback = function(v) blockWindowsPallets(v) end })
		KillSettST:AddToggle({ Text = "Bypass Carry Skill  [RISKY]", Default = false, Flag = "Killer_BypassCarry", Callback = function(v) tbl3.Killer_BypassCarry = v end })

		local _ncd = KillSettST:AddToggle({
			Text = "NO CD Stalker / Hidden  [RISKY]",
			Default = false,
			Flag = "Killer_NoCDToggle",
			Callback = function(v) toggles["Killer_NoCDToggle"].Value = v activateNoCooldown(v) end,
		})
		toggles["Killer_NoCDToggle"] = makeTogProxy(_ncd, false)

		local _si = KillSettST:AddToggle({
			Text = "Invisible Slasher",
			Default = false,
			Flag = "Slasher_InvisibleToggle",
			Callback = function(v) toggles["Slasher_InvisibleToggle"].Value = v activateSlasherInvis(v) end,
		})
		toggles["Slasher_InvisibleToggle"] = makeTogProxy(_si, false)

		KillSettST:AddSlider({ Text = "Break Speed", Min = 1, Max = 10, Default = 1, Increment = 1, Flag = "Killer_BreakSpeed", Callback = function(v) tbl3.Killer_BreakSpeed = v end })

		local tbl19 = {}

		local _3p = KillCamST:AddToggle({
			Text = "3rd Person Camera",
			Description = "Enables third-person view for Killer",
			Icon = "Lucide:camera",
			Default = false,
			Flag = "Killer_3rdPerson",
			Callback = function(killer3rdPerson)
				toggles["Killer_3rdPerson"].Value = killer3rdPerson
				tbl3.Killer_3rdPerson = killer3rdPerson
				if tbl6.ThirdPersonCamConn then tbl6.ThirdPersonCamConn:Disconnect() tbl6.ThirdPersonCamConn = nil end
				if killer3rdPerson then
					tbl19.CameraMode = tbl.LocalPlayer.CameraMode
					tbl19.MinZoom = tbl.LocalPlayer.CameraMinZoomDistance
					tbl19.MaxZoom = tbl.LocalPlayer.CameraMaxZoomDistance
					tbl19.DevComputer = tbl.LocalPlayer.DevComputerCameraMode
					tbl19.DevTouch = tbl.LocalPlayer.DevTouchCameraMode
					local function applyKillerCamera()
						if tbl6.cachedRole ~= "Killer" then return end
						local mode = tbl3.Killer_CameraMode or "Classic"
						if tbl.LocalPlayer.CameraMode ~= Enum.CameraMode.Classic then tbl.LocalPlayer.CameraMode = Enum.CameraMode.Classic end
						local maxZ = tbl3.Misc_InfiniteZoom and math.huge or 40
						if tbl.LocalPlayer.CameraMaxZoomDistance ~= maxZ then tbl.LocalPlayer.CameraMaxZoomDistance = maxZ end
						if tbl.LocalPlayer.CameraMinZoomDistance ~= 7 then tbl.LocalPlayer.CameraMinZoomDistance = 7 end
						tbl.LocalPlayer.DevComputerCameraMode = Enum.DevComputerCameraMovementMode[mode] or Enum.DevComputerCameraMovementMode.Classic
						tbl.LocalPlayer.DevTouchCameraMode = Enum.DevTouchCameraMovementMode[mode] or Enum.DevTouchCameraMovementMode.Classic
					end
					if tbl6.cachedRole == "Killer" then applyKillerCamera() else sendNotif("3rd Person only works as Killer!", 3) end
					tbl6.ThirdPersonCamConn = tbl.RunService.RenderStepped:Connect(function()
						if tbl6.cachedRole == "Killer" then applyKillerCamera() end
					end)
				elseif tbl19.CameraMode then
					tbl.LocalPlayer.CameraMode = tbl19.CameraMode
					tbl.LocalPlayer.CameraMinZoomDistance = tbl19.MinZoom
					tbl.LocalPlayer.CameraMaxZoomDistance = tbl3.Misc_InfiniteZoom and math.huge or tbl19.MaxZoom
					tbl.LocalPlayer.DevComputerCameraMode = tbl19.DevComputer
					tbl.LocalPlayer.DevTouchCameraMode = tbl19.DevTouch
				else
					tbl.LocalPlayer.CameraMode = Enum.CameraMode.Classic
					tbl.LocalPlayer.CameraMinZoomDistance = 7
					tbl.LocalPlayer.CameraMaxZoomDistance = tbl3.Misc_InfiniteZoom and math.huge or 128
					tbl.LocalPlayer.DevComputerCameraMode = Enum.DevComputerCameraMovementMode.UserChoice
					tbl.LocalPlayer.DevTouchCameraMode = Enum.DevTouchCameraMovementMode.UserChoice
				end
			end,
		})
		toggles["Killer_3rdPerson"] = makeTogProxy(_3p, false)

		KillCamST:AddDropdown({ Text = "3rd Person Mode", Options = { "Classic", "Follow" }, Default = "Classic", Flag = "Killer_CameraMode", Callback = function(v) tbl3.Killer_CameraMode = v end })

		KillCamST:AddSection("Skin", "Lucide:user")

		KillCamST:AddDropdown({
			Text = "Change Masked Skin",
			Description = "Only works as the Masked Killer",
			Options = { "Tony", "Rabbit", "Alex", "Brandon", "Cobra", "Richard", "Richter" },
			Flag = "Killer_MaskedSkin",
			Callback = function(arg)
				if tbl6.cachedRole ~= "Killer" then sendNotif("Access Denied: Not Killer!", 3) return end
				local sk = tbl.LocalPlayer:FindFirstChild("SelectedKiller")
				if (sk and sk.Value or tbl.LocalPlayer:GetAttribute("SelectedKiller")) ~= "Masked" then
					sendNotif("Access Denied: Killer is not Masked!", 3) return
				end
				pcall(function()
					game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Killers"):WaitForChild("Masked"):WaitForChild("Activatepower"):FireServer(arg)
					sendNotif("Mask changed to " .. arg, 2)
					task.spawn(function() task.wait(60) pcall(function() game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Killers"):WaitForChild("Masked"):WaitForChild("Deactivatepower"):FireServer() end) end)
				end)
			end,
		})

		TeleTab:AddSection("Refresh", "Lucide:refresh-cw")

		TeleTab:AddButton({
			Text = "Refresh Map Data",
			Description = "Rebuild generator, hook, gate and player lists",
			Icon = "Lucide:refresh-cw",
			Callback = function()
				refreshMapData()
				local tbl20 = {}
				for i, gen in ipairs(tbl9.Generators) do
					local prog = math.floor(gen.model:GetAttribute("RepairProgress") or gen.model:FindFirstChild("RepairProgress") and gen.model.RepairProgress.Value or 0)
					local pl = gen.model:GetAttribute("PlayersRepairingCount") or gen.model:FindFirstChild("PlayersRepairingCount") and gen.model.PlayersRepairingCount.Value or 0
					table.insert(tbl20, { index = i, progress = prog, players = pl })
				end
				table.sort(tbl20, function(a, b) return a.progress > b.progress end)
				local tbl21 = {}
				for _, v in ipairs(tbl20) do table.insert(tbl21, string.format("Generator %d | %d%% | %dP", v.index, v.progress, v.players)) end
				if #tbl21 == 0 then tbl21 = { "No Gen Found" } end
				options["Tele_GenDropdown"]:SetValues(tbl21)
				local tbl22 = {}
				for _, player in pairs(tbl.Players:GetPlayers()) do
					if player ~= tbl.LocalPlayer then
						local tag = player.Team and player.Team.Name == "Survivors" and "[Surv]" or player.Team and player.Team.Name == "Killer" and "[Killer]" or "[Spct]"
						table.insert(tbl22, tag .. " " .. player.Name)
					end
				end
				if #tbl22 == 0 then tbl22 = { "No Players Found" } end
				options["Tele_PlayerDropdown"]:SetValues(tbl22)
				local tbl23 = {} for i in ipairs(tbl9.Hooks) do table.insert(tbl23, "Hook " .. i) end
				if #tbl23 == 0 then tbl23 = { "No Hook Found" } end
				options["Tele_HookDropdown"]:SetValues(tbl23)
				local tbl24 = {} for i in ipairs(tbl9.Gates) do table.insert(tbl24, "Gate " .. i) end
				if #tbl24 == 0 then tbl24 = { "No Gate Found" } end
				options["Tele_GateDropdown"]:SetValues(tbl24)
				sendNotif("Map data refreshed!", 2)
			end,
		})

		TeleTab:AddSection("Generators", "Lucide:cpu")
		TeleTab:AddSlider({ Text = "TP Offset Distance", Min = 1, Max = 15, Default = 5, Increment = 1, Flag = "Tele_GenOffset", Callback = function(v) tbl3.TP_Offset = v end })

		local _gd = TeleTab:AddDropdown({ Text = "Select Generator", Options = { "Refresh First" }, Default = "Refresh First", Flag = "Tele_GenDropdown", Callback = function(v) options["Tele_GenDropdown"].Value = v tbl6.CurrentTeleportGen = v end })
		options["Tele_GenDropdown"] = makeOptProxy(_gd, "Refresh First")

		TeleTab:AddButton({ Text = "Teleport to Generator", Icon = "Lucide:map-pin",
			Callback = function()
				if tbl6.CurrentTeleportGen and string.match(tbl6.CurrentTeleportGen, "Generator %d+") then
					local gen = tbl9.Generators[tonumber(string.match(tbl6.CurrentTeleportGen, "Generator (%d+)"))]
					if gen then teleportToGenerator(gen) end
				end
			end,
		})

		TeleTab:AddSection("Players", "Lucide:users")

		local _pd = TeleTab:AddDropdown({ Text = "Select Player", Options = { "Refresh First" }, Default = "Refresh First", Flag = "Tele_PlayerDropdown", Callback = function(v) options["Tele_PlayerDropdown"].Value = v tbl6.CurrentTeleportPlayer = v end })
		options["Tele_PlayerDropdown"] = makeOptProxy(_pd, "Refresh First")

		TeleTab:AddButton({ Text = "Teleport to Player", Icon = "Lucide:user",
			Callback = function()
				if tbl6.CurrentTeleportPlayer and tbl6.CurrentTeleportPlayer ~= "No Players Found" then
					local player = tbl.Players:FindFirstChild(string.match(tbl6.CurrentTeleportPlayer, "%[%w+%]%s+(.+)") or tbl6.CurrentTeleportPlayer)
					if player and player.Character and tbl.LocalPlayer.Character then tbl.LocalPlayer.Character:PivotTo(player.Character:GetPivot()) end
				end
			end,
		})

		TeleTab:AddToggle({ Text = "Auto Follow", Default = false,
			Callback = function(v)
				tbl6.AutoFollow = v
				if tbl6.FollowConnection then tbl6.FollowConnection:Disconnect() tbl6.FollowConnection = nil end
				if v then
					if not tbl6.CurrentTeleportPlayer or tbl6.CurrentTeleportPlayer == "No Players Found" then return end
					local player = tbl.Players:FindFirstChild(string.match(tbl6.CurrentTeleportPlayer, "%[%w+%]%s+(.+)") or tbl6.CurrentTeleportPlayer)
					if player then
						tbl6.FollowConnection = tbl.RunService.Heartbeat:Connect(function()
							pcall(function()
								if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
								if not tbl.LocalPlayer.Character or not tbl.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
								tbl.LocalPlayer.Character:PivotTo(player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 1, 0))
							end)
						end)
					end
				end
			end,
		})

		TeleTab:AddSection("Hooks and Gates", "Lucide:anchor")

		local _hd = TeleTab:AddDropdown({ Text = "Select Hook", Options = { "Refresh First" }, Default = "Refresh First", Flag = "Tele_HookDropdown", Callback = function(v) options["Tele_HookDropdown"].Value = v tbl6.CurrentTeleportHook = v end })
		options["Tele_HookDropdown"] = makeOptProxy(_hd, "Refresh First")

		TeleTab:AddButton({ Text = "Teleport to Hook", Icon = "Lucide:anchor",
			Callback = function()
				if tbl6.CurrentTeleportHook and string.match(tbl6.CurrentTeleportHook, "Hook %d+") then
					local hook = tbl9.Hooks[tonumber(string.match(tbl6.CurrentTeleportHook, "%d+"))]
					if hook and tbl.LocalPlayer.Character then
						local pt = hook:FindFirstChild("HookPoint")
						tbl.LocalPlayer.Character:PivotTo(pt and pt:GetPivot() or hook:GetPivot())
					end
				end
			end,
		})

		local _gatd = TeleTab:AddDropdown({ Text = "Select Gate", Options = { "Refresh First" }, Default = "Refresh First", Flag = "Tele_GateDropdown", Callback = function(v) options["Tele_GateDropdown"].Value = v tbl6.CurrentTeleportGate = v end })
		options["Tele_GateDropdown"] = makeOptProxy(_gatd, "Refresh First")

		TeleTab:AddButton({ Text = "Teleport to Gate", Icon = "Lucide:log-out",
			Callback = function()
				if tbl6.CurrentTeleportGate and string.match(tbl6.CurrentTeleportGate, "Gate %d+") then
					local gate = tbl9.Gates[tonumber(string.match(tbl6.CurrentTeleportGate, "%d+"))]
					if gate and tbl.LocalPlayer.Character then tbl.LocalPlayer.Character:PivotTo(gate:GetPivot() * CFrame.new(0, 0, 8)) end
				end
			end,
		})

		local EspSettST  = EspTab:AddSubTab({ Name = "Settings", Icon = "Lucide:settings" })
		local EspTargST  = EspTab:AddSubTab({ Name = "Targets", Icon = "Lucide:target" })

		EspSettST:AddSection("ESP Options", "Lucide:eye")

		EspSettST:AddToggle({ Text = "Enable ESP", Description = "Highlights all entities on the map", Default = false, Flag = "ESP_Master", Callback = function(v) tbl3.ESP_Master = v if v then refreshMapData() else clearAllESP() end end })
		EspSettST:AddSlider({ Text = "ESP Distance", Min = 50, Max = 500, Default = 200, Increment = 10, Suffix = " studs", Flag = "ESP_MaxDist", Callback = function(v) tbl3.ESP_MaxDistance = v end })
		EspSettST:AddSlider({ Text = "ESP Transparency", Min = 0, Max = 10, Default = 7, Increment = 1, Flag = "ESP_Trans", Callback = function(v) tbl3.Trans = v / 10 if tbl3.ESP_Master then clearAllESP() refreshMapData() end end })
		EspSettST:AddToggle({ Text = "Name Player", Default = false, Flag = "ESP_Name", Callback = function(v) tbl3.ESP_Name = v if v then refreshMapData() else clearAllESP() end end })
		EspSettST:AddToggle({ Text = "Name Generator", Default = false, Flag = "ESP_NameG", Callback = function(v) tbl3.ESP_NameG = v if v then refreshMapData() else clearAllESP() end end })
		EspSettST:AddToggle({ Text = "Item ESP", Default = false, Flag = "ESP_ItemIcon", Callback = function(v) tbl3.ESP_ItemIcon = v if tbl3.ESP_Master and not v then clearESPByType("Item") end end })
		EspSettST:AddToggle({ Text = "Outline Mode", Default = false, Flag = "ESP_Outline", Callback = function(v) tbl3.ESP_Outline = v end })
		EspSettST:AddToggle({ Text = "Killer Warning", Default = false, Flag = "ESP_KillerWarn", Callback = function(v) tbl3.ESP_KillerWarn = v end })

		EspSettST:AddToggle({
			Text = "Rainbow ESP  (Chroma)",
			Description = "Cycles all ESP colors through the full color spectrum",
			Icon = "Lucide:sparkles",
			Default = false,
			Flag = "ESP_Chroma",
			Callback = function(v)
				tbl3.ESP_Chroma = v
				if not v then
					tbl6.ChromaHue = 0
					tbl7.Colors.Player = Color3.fromRGB(0, 255, 100)
					tbl7.Colors.Killer = Color3.fromRGB(255, 0, 100)
					tbl7.Colors.SCP = Color3.fromRGB(150, 0, 255)
					tbl7.Colors.Generator = Color3.fromRGB(255, 200, 0)
					tbl7.Colors.Pallet = Color3.fromRGB(0, 200, 255)
					tbl7.Colors.Window = Color3.fromRGB(0, 150, 255)
					tbl7.Colors.Hook = Color3.fromRGB(200, 100, 0)
					tbl7.Colors.Gate = Color3.fromRGB(255, 255, 255)
				end
			end,
		})

		EspSettST:AddToggle({
			Text = "Highest Generator Highlight",
			Description = "Highlights the generator with the most repair progress",
			Icon = "Lucide:cpu",
			Default = false,
			Flag = "ESP_HighestGen",
			Callback = function(v) tbl3.ESP_HighestGen = v end,
		})

		EspSettST:AddColorPicker({
			Text = "Highest Gen Color",
			Default = Color3.fromRGB(100, 255, 100),
			Flag = "ESP_HighestGenColor",
			Callback = function(c) tbl7.Colors.GeneratorDone = c end,
		})

		EspSettST:AddToggle({
			Text = "Injured Player Color",
			Description = "Highlights injured survivors in yellow-red based on HP",
			Icon = "Lucide:heart-pulse",
			Default = true,
			Flag = "ESP_InjuredColor",
			Callback = function(v) tbl3.ESP_InjuredColor = v end,
		})

		EspSettST:AddSection("Indicators", "Lucide:bell")

		EspSettST:AddToggle({ Text = "Show Next Map", Default = true, Flag = "Next_Map", Callback = function(v) tbl3.Next_Map = v end })
		EspSettST:AddToggle({ Text = "Killer Stun Indicator", Default = false, Flag = "Show_Stun", Callback = function(v) tbl3.Show_Stun = v end })
		EspSettST:AddToggle({ Text = "Show FPS and Spectators", Default = true, Flag = "Misc_OverlayInfo",
			Callback = function(v)
				if tbl6.WatermarkUI then tbl6.WatermarkUI.Enabled = v end
				if getgenv().Tixo_SpectatorUI then getgenv().Tixo_SpectatorUI.Enabled = v end
			end,
		})
		EspSettST:AddToggle({ Text = "Info Perk", Default = false,
			Callback = function(v)
				if v then
					if not getgenv().InfoPerkLoaded then pcall(function() loadstring(game:HttpGet(tbl10.SCRIPT .. "/Misc/perk-info"))() end)
					elseif getgenv().ToggleInfoPerk then getgenv().ToggleInfoPerk(true) end
				else
					if getgenv().InfoPerkCleanup then getgenv().InfoPerkCleanup() end
					getgenv().InfoPerkLoaded = false
				end
			end,
		})

		EspTargST:AddSection("Entities", "Lucide:users")

		EspTargST:AddToggle({ Text = "SCP / Zombie", Default = false, Flag = "ESP_SCP", Callback = function(v) tbl3.ESP_SCP = v if tbl3.ESP_Master then if not v then clearESPByType("SCP") else refreshMapData() end end end })
		EspTargST:AddColorPicker({ Text = "SCP Color", Default = tbl7.Colors.SCP, Callback = function(c) tbl7.Colors.SCP = c end })
		EspTargST:AddToggle({ Text = "Player", Default = false, Flag = "ESP_Player", Callback = function(v) tbl3.ESP_Player = v if tbl3.ESP_Master then if not v then clearESPByType("Player") else refreshMapData() end end end })
		EspTargST:AddColorPicker({ Text = "Player Color", Default = tbl7.Colors.Player, Callback = function(c) tbl7.Colors.Player = c end })
		EspTargST:AddToggle({ Text = "Killer", Default = false, Flag = "ESP_Killer", Callback = function(v) tbl3.ESP_Killer = v if tbl3.ESP_Master then if not v then clearESPByType("Killer") else refreshMapData() end end end })
		EspTargST:AddColorPicker({ Text = "Killer Color", Default = tbl7.Colors.Killer, Callback = function(c) tbl7.Colors.Killer = c end })
		EspTargST:AddToggle({ Text = "Generator", Default = false, Flag = "ESP_Generator", Callback = function(v) tbl3.ESP_Generator = v if tbl3.ESP_Master then if not v then clearESPByType("Generator") else refreshMapData() end end end })
		EspTargST:AddColorPicker({ Text = "Generator Color", Default = tbl7.Colors.Generator, Callback = function(c) tbl7.Colors.Generator = c end })

		EspTargST:AddSection("Objects", "Lucide:box")

		EspTargST:AddToggle({ Text = "Pallet", Default = false, Flag = "ESP_Pallet", Callback = function(v) tbl3.ESP_Pallet = v if tbl3.ESP_Master then if not v then clearESPByType("Pallet") else refreshMapData() end end end })
		EspTargST:AddColorPicker({ Text = "Pallet Color", Default = tbl7.Colors.Pallet, Callback = function(c) tbl7.Colors.Pallet = c end })
		EspTargST:AddToggle({ Text = "Window / Vault", Default = false, Flag = "ESP_Window", Callback = function(v) tbl3.ESP_Window = v if tbl3.ESP_Master then if not v then clearESPByType("Window") else refreshMapData() end end end })
		EspTargST:AddColorPicker({ Text = "Window Color", Default = tbl7.Colors.Window, Callback = function(c) tbl7.Colors.Window = c end })
		EspTargST:AddToggle({ Text = "Hook", Default = false, Flag = "ESP_Hook", Callback = function(v) tbl3.ESP_Hook = v if tbl3.ESP_Master then if not v then clearESPByType("Hook") else refreshMapData() end end end })
		EspTargST:AddColorPicker({ Text = "Hook Color", Default = tbl7.Colors.Hook, Callback = function(c) tbl7.Colors.Hook = c end })
		EspTargST:AddToggle({ Text = "Exit Gate", Default = false, Flag = "ESP_Gate", Callback = function(v) tbl3.ESP_Gate = v if tbl3.ESP_Master then if not v then clearESPByType("Gate") else refreshMapData() end end end })
		EspTargST:AddColorPicker({ Text = "Gate Color", Default = tbl7.Colors.Gate, Callback = function(c) tbl7.Colors.Gate = c end })

		local AimMainST = AimTab:AddSubTab({ Name = "Aimbot", Icon = "Lucide:crosshair" })
		local AimPistolST = AimTab:AddSubTab({ Name = "Pistol (TOF)", Icon = "Lucide:target" })
		local AimVeilST = AimTab:AddSubTab({ Name = "Veil / Crosshair", Icon = "Lucide:wind" })

		AimMainST:AddSection("Aimbot", "Lucide:crosshair")

		AimMainST:AddToggle({ Text = "Aimbot", Default = false, Flag = "Aimbot_Enabled", Callback = function(v) tbl3.Aimbot_Enabled = v end })
		AimMainST:AddToggle({ Text = "Show FOV Circle", Default = true, Flag = "Aimbot_ShowFOV", Callback = function(v) tbl3.Aimbot_ShowFOV = v end })
		AimMainST:AddSlider({ Text = "FOV Circle Radius", Min = 50, Max = 500, Default = 150, Increment = 10, Flag = "Aimbot_Radius", Callback = function(v) tbl3.Aimbot_Radius = v end })
		AimMainST:AddSlider({ Text = "Max Distance", Min = 50, Max = 1000, Default = 300, Increment = 10, Suffix = " studs", Flag = "Aimbot_MaxDist", Callback = function(v) tbl3.Aimbot_MaxDist = v end })
		AimMainST:AddSlider({ Text = "Smoothness", Min = 1, Max = 10, Default = 5, Increment = 1, Flag = "Aimbot_Smooth", Callback = function(v) tbl3.Aimbot_Smoothness = v / 10 end })
		AimMainST:AddTextbox({ Text = "Predict Offset", Placeholder = "e.g. 0.05", Default = "0", Flag = "Aimbot_Predict",
			Callback = function(v) local n = tonumber(v) if n then tbl3.Aimbot_Predict = n end end,
		})

		AimMainST:AddSection("Flash Aim", "Lucide:zap")

		AimMainST:AddToggle({ Text = "Aim Flash", Default = false, Flag = "Flash_Silent", Callback = function(v) tbl3.Flash_Silent = v end })
		AimMainST:AddSlider({ Text = "Aim Offset Y", Description = "0=Body  1.5=Head  8=Above Head", Min = 1, Max = 15, Default = 15, Increment = 1, Flag = "Flash_YOffset", Callback = function(v) tbl3.Flash_YOffset = v end })

		AimPistolST:AddSection("Sound", "Lucide:volume-2")

		AimPistolST:AddToggle({ Text = "Custom Sound TOF", Default = false, Flag = "Pistol_CustomSound",
			Callback = function(v) tbl3.Pistol_CustomSound = v if tbl.LocalPlayer.Character then setupPistolSound(tbl.LocalPlayer.Character) end end,
		})
		AimPistolST:AddDropdown({ Text = "Select Sound", Options = { "Sound 1", "Sound 2", "Sound 3", "Sound 4" }, Default = "Sound 1", Flag = "Pistol_SoundDropdown",
			Callback = function(v) tbl3.Pistol_SelectedSound = v if tbl3.Pistol_CustomSound and tbl.LocalPlayer.Character then setupPistolSound(tbl.LocalPlayer.Character) end end,
		})

		AimPistolST:AddSection("Aim", "Lucide:target")

		local _as = AimPistolST:AddToggle({
			Text = "Pistol Silent Aim  [RISKY]",
			Default = false,
			Flag = "Aim_Silent",
			Callback = function(v) toggles["Aim_Silent"].Value = v tbl3.Aim_Silent = v end,
		})
		toggles["Aim_Silent"] = makeTogProxy(_as, false)
		toggles["Aim_Pre"] = { Value = false, SetValue = function(self, v) self.Value = v end }

		AimPistolST:AddToggle({ Text = "Auto Predict", Default = false, Flag = "Aim_Pre", Callback = function(v) toggles["Aim_Pre"].Value = v tbl3.Predict = v end })
		AimPistolST:AddToggle({ Text = "Aim Lock", Default = false, Flag = "Aim_Lock", Callback = function(v) tbl3.Aim_Lock = v end })
		AimPistolST:AddToggle({ Text = "Block Aim on Knocked", Default = true, Flag = "Pistol_BlockKnocked", Callback = function(v) tbl3.Pistol_BlockKnocked = v end })
		AimPistolST:AddToggle({ Text = "Show Laser", Default = true, Flag = "Pistol_ShowLaser", Callback = function(v) tbl3.Pistol_ShowLaser = v if not v and part and part.Parent then part.Parent = nil end end })
		AimPistolST:AddDropdown({ Text = "Target Aim Part", Options = { "Head", "Torso", "Root" }, Default = "Torso", Flag = "AIM_TargetPart", Callback = function(v) tbl3.AIM_TargetPart = v end })
		AimPistolST:AddSlider({ Text = "Prediction", Min = 5, Max = 50, Default = 35, Increment = 1, Flag = "Pistol_PredictLead", Callback = function(v) tbl3.Pistol_PredictLead = v / 10 end })
		AimPistolST:AddSlider({ Text = "Aim Offset", Min = -2, Max = 0, Default = tbl3.Pistol_AimOffset, Increment = 1, Flag = "Pistol_AimOffset", Callback = function(v) tbl3.Pistol_AimOffset = v end })

		local _ptd = AimPistolST:AddDropdown({
			Text = "Pistol Target",
			Options = { "Killer", "Survivor", "SCP" },
			Default = "Killer",
			Flag = "Pistol_Target_Drop",
			Callback = function(v) options["Pistol_Target_Drop"].Value = v tbl3.Pistol_Target = v end,
		})
		options["Pistol_Target_Drop"] = makeOptProxy(_ptd, "Killer")

		AimPistolST:AddButton({ Text = "Cycle Target Type  (T)", Icon = "Lucide:repeat", Callback = function() cycleTargetType() end })
		AimPistolST:AddToggle({ Text = "Show Target UI  (Mobile)", Default = false, Callback = function(v) if screenGui2 then screenGui2.Enabled = v end end })
		AimPistolST:AddToggle({ Text = "Pistol FOV Mode", Default = false, Flag = "Pistol_FOVMode", Callback = function(v) tbl3.Pistol_FOVMode = v end })
		AimPistolST:AddToggle({ Text = "Show Pistol FOV", Default = false, Flag = "Pistol_ShowFOV", Callback = function(v) tbl3.Pistol_ShowFOV = v end })
		AimPistolST:AddSlider({ Text = "Pistol FOV Radius", Min = 50, Max = 300, Default = 120, Increment = 10, Flag = "Pistol_FOV", Callback = function(v) tbl3.Pistol_FOV = v end })

		do
			tbl.UserInputService.InputBegan:Connect(function(input, gp)
				if gp then return end
				if input.KeyCode == Enum.KeyCode.T then cycleTargetType() end
			end)
		end

		AimVeilST:AddSection("Veil  (Spear)", "Lucide:wind")

		local _sv = AimVeilST:AddToggle({
			Text = "Veil Silent Aim  [RISKY]",
			Default = false,
			Flag = "Aim_SilentVeil",
			Callback = function(v)
				if v then
					if tbl6.cachedRole ~= "Killer" then sendNotif("Access Denied: Not Killer!", 3) task.defer(function() toggles["Aim_SilentVeil"]:SetValue(false) end) return end
					local sk = tbl.LocalPlayer:FindFirstChild("SelectedKiller")
					if (sk and sk.Value or tbl.LocalPlayer:GetAttribute("SelectedKiller")) ~= "Veil" then
						sendNotif("Access Denied: Not Veil!", 3) task.defer(function() toggles["Aim_SilentVeil"]:SetValue(false) end) return
					end
				end
				toggles["Aim_SilentVeil"].Value = v
				tbl3.Aim_SilentVeil = v
			end,
		})
		toggles["Aim_SilentVeil"] = makeTogProxy(_sv, false)

		AimVeilST:AddToggle({ Text = "Smart Predict", Default = false, Flag = "SmartPredict_Toggle", Callback = function(v) tbl3.SmartPredict = v end })
		AimVeilST:AddSlider({ Text = "Smart Lead Multiplier", Min = 10, Max = 50, Default = 17, Increment = 1, Flag = "Veil_LeadMultiplier", Callback = function(v) tbl3.Veil_LeadMultiplier = v / 10 end })
		AimVeilST:AddToggle({ Text = "Show FOV", Default = true, Flag = "Veil_ShowFOV", Callback = function(v) tbl3.Veil_ShowFOV = v end })
		AimVeilST:AddToggle({ Text = "Snapline", Default = true, Flag = "Veil_ShowLaser", Callback = function(v) tbl3.Veil_ShowLaser = v end })
		AimVeilST:AddSlider({ Text = "FOV Radius", Min = 50, Max = 300, Default = 120, Increment = 10, Flag = "Veil_FOV", Callback = function(v) tbl3.Veil_FOV = v end })
		AimVeilST:AddSlider({ Text = "Distance", Min = 50, Max = 500, Default = 150, Increment = 10, Suffix = " studs", Flag = "Veil_Distance", Callback = function(v) tbl3.SPEAR_MaxDist = v end })
		AimVeilST:AddSlider({ Text = "Spear Speed", Min = 50, Max = 200, Default = 165, Increment = 5, Flag = "Veil_SpearSpeed", Callback = function(v) tbl3.SPEAR_Speed = v end })
		AimVeilST:AddSlider({ Text = "Spear Gravity", Min = 0, Max = 200, Default = 103, Increment = 1, Flag = "Veil_SpearGravity", Callback = function(v) tbl3.SPEAR_Gravity = v end })

		AimVeilST:AddSection("Crosshair", "Lucide:plus")

		AimVeilST:AddToggle({ Text = "Custom Crosshair", Default = false, Flag = "Crosshair_Enabled", Callback = function(v) tbl3.Crosshair_Enabled = v updateCrosshair() end })
		AimVeilST:AddDropdown({ Text = "Style", Options = { "Dot", "Cross", "Circle" }, Default = "Cross", Flag = "Crosshair_Type", Callback = function(v) tbl3.Crosshair_Type = v updateCrosshair() end })
		AimVeilST:AddSlider({ Text = "Size", Min = 2, Max = 30, Default = 4, Increment = 1, Flag = "Crosshair_Size", Callback = function(v) tbl3.Crosshair_Size = v updateCrosshair() end })
		AimVeilST:AddColorPicker({ Text = "Crosshair Color", Default = Color3.fromRGB(255, 255, 255), Flag = "Crosshair_Color", Callback = function(c) tbl3.Crosshair_Color = c updateCrosshair() end })

		local _cx = AimVeilST:AddTextbox({ Text = "Position X", Placeholder = "e.g. 0", Default = "0", Flag = "CrossX",
			Callback = function(v) local n = tonumber(v) if n then options["CrossX"].Value = v tbl3.Crosshair_OffsetX = n updateCrosshair() end end,
		})
		options["CrossX"] = makeOptProxy(_cx, "0")

		local _cy = AimVeilST:AddTextbox({ Text = "Position Y", Placeholder = "e.g. 0", Default = "0", Flag = "CrossY",
			Callback = function(v) local n = tonumber(v) if n then options["CrossY"].Value = v tbl3.Crosshair_OffsetY = n updateCrosshair() end end,
		})
		options["CrossY"] = makeOptProxy(_cy, "0")

		AimVeilST:AddButton({ Text = "Reset Position", Icon = "Lucide:rotate-ccw",
			Callback = function()
				tbl3.Crosshair_OffsetX = 0 tbl3.Crosshair_OffsetY = 0
				pcall(function() options["CrossX"]:SetValue("0") end)
				pcall(function() options["CrossY"]:SetValue("0") end)
				updateCrosshair()
			end,
		})

		local MiscVisualST = MiscTab:AddSubTab({ Name = "Visuals", Icon = "Lucide:monitor" })
		local MiscMoveST   = MiscTab:AddSubTab({ Name = "Movement", Icon = "Lucide:move" })
		local MiscToolsST  = MiscTab:AddSubTab({ Name = "Tools", Icon = "Lucide:wrench" })
		local MiscFlingUnloadST = MiscTab:AddSubTab({ Name = "Fling / Unload", Icon = "Lucide:zap" })

		MiscVisualST:AddSection("Camera", "Lucide:camera")

		MiscVisualST:AddToggle({ Text = "Camera DBD", Description = "Smoother DBD-style camera movement", Default = false, Flag = "Misc_SmoothCam",
			Callback = function(v) tbl3.Misc_SmoothCam = v applySmoothCamera() end,
		})
		MiscVisualST:AddSlider({ Text = "Camera Height", Min = -10, Max = 10, Default = -1, Increment = 1, Flag = "Misc_CamHeight", Callback = function(v) tbl3.Misc_CamHeight = v if tbl3.Misc_SmoothCam then applySmoothCamera() end end })
		MiscVisualST:AddSlider({ Text = "Camera Stiffness", Min = 1, Max = 30, Default = 9, Increment = 1, Flag = "Misc_CamStiffness", Callback = function(v) tbl3.Misc_CamStiffness = v if tbl3.Misc_SmoothCam then applySmoothCamera() end end })

		MiscVisualST:AddSection("Screen", "Lucide:monitor")

		MiscVisualST:AddToggle({ Text = "Custom Resolution", Default = false,
			Callback = function(v)
				if v then
					if not getgenv().resolusi then
						getgenv().resolusi = game:GetService("RunService").RenderStepped:Connect(function()
							tbl.Camera.CFrame = tbl.Camera.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, getgenv().Resolution.reso, 0, 0, 0, 1)
						end)
					end
				elseif getgenv().resolusi then getgenv().resolusi:Disconnect() getgenv().resolusi = nil end
			end,
		})
		getgenv().Resolution = { reso = 0.65 }
		MiscVisualST:AddSlider({ Text = "Resolution Scale", Min = 10, Max = 200, Default = 65, Increment = 1, Suffix = "%", Flag = "Res_Scale",
			Callback = function(v) getgenv().Resolution = getgenv().Resolution or {} getgenv().Resolution.reso = v / 100 end,
		})

		MiscVisualST:AddSection("Visual FX", "Lucide:sparkles")

		MiscVisualST:AddToggle({ Text = "Skip Cutscene", Default = false, Callback = function(v) setSkipCutscene(v) end })
		MiscVisualST:AddToggle({ Text = "Fullbright", Default = false, Flag = "Misc_Fullbright",
			Callback = function(v)
				tbl3.Misc_Fullbright = v
				if v then
					if not tbl6.OriginalLighting then
						local atm = tbl.Lighting:FindFirstChildOfClass("Atmosphere")
						tbl6.OriginalLighting = { Brightness = tbl.Lighting.Brightness, FogEnd = tbl.Lighting.FogEnd, GlobalShadows = tbl.Lighting.GlobalShadows, OutdoorAmbient = tbl.Lighting.OutdoorAmbient, Ambient = tbl.Lighting.Ambient, AtmosphereDensity = atm and atm.Density or 0.3 }
					end
					applyFullbright() startFullbrightLoop()
				else
					stopFullbrightLoop()
					if tbl6.OriginalLighting then
						tbl.Lighting.Brightness = tbl6.OriginalLighting.Brightness
						tbl.Lighting.FogEnd = tbl6.OriginalLighting.FogEnd
						tbl.Lighting.GlobalShadows = tbl6.OriginalLighting.GlobalShadows
						tbl.Lighting.OutdoorAmbient = tbl6.OriginalLighting.OutdoorAmbient
						tbl.Lighting.Ambient = tbl6.OriginalLighting.Ambient
						local atm = tbl.Lighting:FindFirstChildOfClass("Atmosphere")
						if atm and tbl6.OriginalLighting.AtmosphereDensity then atm.Density = tbl6.OriginalLighting.AtmosphereDensity end
					end
				end
			end,
		})
		MiscVisualST:AddSlider({ Text = "Fullbright Time", Min = 0, Max = 24, Default = 14, Increment = 1, Suffix = "h", Flag = "Fullbright_Time",
			Callback = function(v) if tbl3.Misc_Fullbright then tbl.Lighting.ClockTime = v end end,
		})
		MiscVisualST:AddToggle({ Text = "Smooth HDR", Default = false, Flag = "Misc_SmoothHDR", Callback = function(v) tbl3.Misc_SmoothHDR = v setSmoothHDR(v) end })

		MiscVisualST:AddSection("Graphics / FPS", "Lucide:gauge")

		local function applyFPSCap()
			if setfpscap then
				if toggles["Misc_FPSUnlockToggle"] and toggles["Misc_FPSUnlockToggle"].Value then
					local v = options["Misc_FPSDropdown"] and options["Misc_FPSDropdown"].Value
					setfpscap(v == "Max" and 9999 or tonumber(v) or 60)
				else setfpscap(60) end
			else sendNotif("setfpscap not supported!", 3) end
		end

		local _fpu = MiscVisualST:AddToggle({ Text = "Unlock FPS", Default = false, Flag = "Misc_FPSUnlock",
			Callback = function(v) toggles["Misc_FPSUnlockToggle"].Value = v applyFPSCap() end,
		})
		toggles["Misc_FPSUnlockToggle"] = makeTogProxy(_fpu, false)

		local _fpd = MiscVisualST:AddDropdown({ Text = "Target FPS", Options = { "60", "90", "120", "Max" }, Default = "120", Flag = "Misc_FPSDropdown",
			Callback = function(v) options["Misc_FPSDropdown"].Value = v if toggles["Misc_FPSUnlockToggle"] and toggles["Misc_FPSUnlockToggle"].Value then applyFPSCap() end end,
		})
		options["Misc_FPSDropdown"] = makeOptProxy(_fpd, "120")

		MiscMoveST:AddSection("Movement", "Lucide:footprints")

		MiscMoveST:AddToggle({ Text = "Noclip", Default = false, Flag = "Misc_Noclip", Callback = function(v) tbl3.Misc_Noclip = v end })
		MiscMoveST:AddToggle({ Text = "Fly Mode", Default = false, Flag = "Misc_FlyToggle",
			Callback = function(v)
				tbl3.Misc_FlyToggle = v
				local ch = tbl.LocalPlayer.Character
				local h2 = ch and ch:FindFirstChildOfClass("Humanoid")
				local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
				if not ch or not h2 or not hrp then return end
				if v then
					if ch:FindFirstChild("Animate") then ch.Animate.Disabled = true end
					for _, tr in pairs(h2:GetPlayingAnimationTracks()) do tr:Stop() end
					h2:ChangeState(Enum.HumanoidStateType.Swimming) h2.AutoRotate = false
					local bv = Instance.new("BodyVelocity", hrp) bv.Name = "FlyStable" bv.MaxForce = Vector3.new(1e6, 1e6, 1e6) bv.Velocity = Vector3.zero
					local bg = Instance.new("BodyGyro", hrp) bg.Name = "FlyGyro" bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9) bg.P = 90000 bg.CFrame = tbl.Camera.CFrame
					if tbl6.FlyConnection then tbl6.FlyConnection:Disconnect() end
					tbl6.FlyConnection = tbl.RunService.Heartbeat:Connect(function()
						if not ch or not hrp or not h2 then return end
						tbl.UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
						bg.CFrame = tbl.Camera.CFrame
						if h2.MoveDirection.Magnitude > 0 then
							local md = h2.MoveDirection
							local lv = tbl.Camera.CFrame.LookVector
							local y = tbl.UserInputService:IsKeyDown(Enum.KeyCode.W) and lv.Y or (tbl.UserInputService:IsKeyDown(Enum.KeyCode.S) and -lv.Y or 0)
							ch:TranslateBy(Vector3.new(md.X, y, md.Z) * (tbl3.Misc_FlySpeed / 10))
						end
					end)
				else
					if tbl6.FlyConnection then tbl6.FlyConnection:Disconnect() end
					if hrp:FindFirstChild("FlyStable") then hrp.FlyStable:Destroy() end
					if hrp:FindFirstChild("FlyGyro") then hrp.FlyGyro:Destroy() end
					if ch:FindFirstChild("Animate") then ch.Animate.Disabled = false end
					h2.AutoRotate = true h2:ChangeState(Enum.HumanoidStateType.Running)
					tbl.UserInputService.MouseBehavior = Enum.MouseBehavior.Default
				end
			end,
		})
		MiscMoveST:AddSlider({ Text = "Fly Speed", Min = 10, Max = 500, Default = 10, Increment = 10, Flag = "Misc_FlySpeed", Callback = function(v) tbl3.Misc_FlySpeed = v end })

		MiscMoveST:AddSection("Jump", "Lucide:arrow-up")

		MiscMoveST:AddToggle({ Text = "High Jump", Default = false, Flag = "Misc_HighJump",
			Callback = function(v) tbl3.Misc_HighJump = v if not v and tbl.LocalPlayer.Character then local h2 = tbl.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") if h2 then h2.UseJumpPower = false end end end,
		})
		MiscMoveST:AddSlider({ Text = "Jump Power", Min = 50, Max = 300, Default = 50, Increment = 10, Flag = "Misc_JumpPower", Callback = function(v) tbl3.Misc_JumpPower = v end })
		MiscMoveST:AddToggle({ Text = "Infinite Jump", Default = false, Flag = "Misc_InfJump", Callback = function(v) tbl3.Misc_InfJump = v end })
		MiscMoveST:AddToggle({ Text = "Infinite Zoom", Default = false, Flag = "Misc_InfiniteZoom",
			Callback = function(v)
				tbl3.Misc_InfiniteZoom = v
				if tbl6.InfiniteZoomConn then tbl6.InfiniteZoomConn:Disconnect() tbl6.InfiniteZoomConn = nil end
				if v then
					tbl.LocalPlayer.CameraMaxZoomDistance = math.huge
					tbl6.InfiniteZoomConn = tbl.LocalPlayer:GetPropertyChangedSignal("CameraMaxZoomDistance"):Connect(function()
						if tbl.LocalPlayer.CameraMaxZoomDistance ~= math.huge then tbl.LocalPlayer.CameraMaxZoomDistance = math.huge end
					end)
				else tbl.LocalPlayer.CameraMaxZoomDistance = tbl19.MaxZoom or 128 end
			end,
		})

		MiscToolsST:AddSection("Profile Spoofer", "Lucide:user-cog")

		MiscToolsST:AddToggle({ Text = "Fake Name", Default = false, Flag = "Misc_FakeName", Callback = function(v) tbl3.Misc_FakeName = v if v then applyFakeName() else removeFakeName() end end })
		MiscToolsST:AddToggle({ Text = "Fake Profile", Description = "Spoofs Level, Gears and Screws", Default = false, Flag = "Misc_FakeAttributes",
			Callback = function(v)
				tbl3.Misc_FakeAttributes = v
				if v then
					tbl.LocalPlayer:SetAttribute("Level", tonumber(options["Misc_LevelInput"].Value) or tbl4.Level)
					tbl.LocalPlayer:SetAttribute("Gears", tonumber(options["Misc_GearsInput"].Value) or tbl4.Gears)
					tbl.LocalPlayer:SetAttribute("Screws", tonumber(options["Misc_ScrewsInput"].Value) or tbl4.Screws)
				else
					tbl.LocalPlayer:SetAttribute("Level", tbl4.Level)
					tbl.LocalPlayer:SetAttribute("Gears", tbl4.Gears)
					tbl.LocalPlayer:SetAttribute("Screws", tbl4.Screws)
				end
			end,
		})

		local _li = MiscToolsST:AddTextbox({ Text = "Set Level", Placeholder = tostring(tbl4.Level), Default = tostring(tbl4.Level), Flag = "Misc_LevelInput",
			Callback = function(v) local n = tonumber(v) options["Misc_LevelInput"].Value = v if n and tbl3.Misc_FakeAttributes then tbl.LocalPlayer:SetAttribute("Level", n) end end,
		})
		options["Misc_LevelInput"] = makeOptProxy(_li, tostring(tbl4.Level))
		options["Misc_LevelInput"].Value = tostring(tbl4.Level)

		local _gi = MiscToolsST:AddTextbox({ Text = "Set Gears", Placeholder = tostring(tbl4.Gears), Default = tostring(tbl4.Gears), Flag = "Misc_GearsInput",
			Callback = function(v) local n = tonumber(v) options["Misc_GearsInput"].Value = v if n and tbl3.Misc_FakeAttributes then tbl.LocalPlayer:SetAttribute("Gears", n) end end,
		})
		options["Misc_GearsInput"] = makeOptProxy(_gi, tostring(tbl4.Gears))
		options["Misc_GearsInput"].Value = tostring(tbl4.Gears)

		local _sci = MiscToolsST:AddTextbox({ Text = "Set Screws", Placeholder = tostring(tbl4.Screws), Default = tostring(tbl4.Screws), Flag = "Misc_ScrewsInput",
			Callback = function(v) local n = tonumber(v) options["Misc_ScrewsInput"].Value = v if n and tbl3.Misc_FakeAttributes then tbl.LocalPlayer:SetAttribute("Screws", n) end end,
		})
		options["Misc_ScrewsInput"] = makeOptProxy(_sci, tostring(tbl4.Screws))
		options["Misc_ScrewsInput"].Value = tostring(tbl4.Screws)

		MiscToolsST:AddSection("GUI Tools", "Lucide:box")

		MiscToolsST:AddToggle({ Text = "Invisible GUI  (Q)", Default = false, Callback = function(v) if v then pcall(function() loadstring(game:HttpGet(tbl10.SCRIPT .. "/Misc/invis"))() end) elseif getgenv().RemoveInvisibleGui then pcall(getgenv().RemoveInvisibleGui) end end })
		MiscToolsST:AddToggle({ Text = "Sky Changer", Default = false, Callback = function(v) if v then pcall(function() loadstring(game:HttpGet(tbl10.SCRIPT .. "/Misc/SkyC"))() end) elseif getgenv().RemoveSkyChanger then pcall(getgenv().RemoveSkyChanger) end end })
		MiscToolsST:AddToggle({ Text = "Copy Avatar", Default = false, Callback = function(v) if v then pcall(function() loadstring(game:HttpGet(tbl10.SCRIPT .. "/Misc/copyava"))() end) elseif getgenv().RemoveCopyAvatar then pcall(getgenv().RemoveCopyAvatar) end end })
		MiscToolsST:AddToggle({ Text = "Moonwalk  (G)", Default = false, Callback = function(v) if v then pcall(function() loadstring(game:HttpGet(tbl10.SCRIPT .. "/Misc/MoonWalk"))() end) elseif getgenv().Moonwalk then pcall(getgenv().Moonwalk) end end })
		MiscToolsST:AddToggle({ Text = "Emote GUI", Default = false, Callback = function(v) if v then pcall(function() loadstring(game:HttpGet(tbl10.SCRIPT .. "/Misc/emote"))() end) elseif getgenv().StopEmoteGUI then pcall(getgenv().StopEmoteGUI) end end })
		MiscToolsST:AddToggle({ Text = "Super Fling  [RISKY]", Default = false, Callback = function(v) if v then pcall(function() loadstring(game:HttpGet(tbl10.SCRIPT .. "/Misc/fling"))() end) elseif getgenv().StopSuperRing then pcall(getgenv().StopSuperRing) end end })

		local connection3 = nil

		MiscFlingUnloadST:AddSection("Fling", "Lucide:send")

		local _af = MiscFlingUnloadST:AddToggle({ Text = "Fling", Default = false, Flag = "Misc_AuraFling",
			Callback = function(v)
				if v then
					if connection3 then connection3:Disconnect() end
					connection3 = tbl.RunService.PostSimulation:Connect(function()
						local ch = tbl.LocalPlayer.Character
						local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
						if not hrp then return end
						for _, player in ipairs(tbl.Players:GetPlayers()) do
							if player ~= tbl.LocalPlayer and player.Character then
								for _, child in ipairs(player.Character:GetChildren()) do if child:IsA("BasePart") then child.CanCollide = false end end
							end
						end
						local fval = options["Misc_FlingPower"].Value
						local vel = hrp.Velocity
						hrp.Velocity = Vector3.new(fval, fval, fval)
						for _, d in ipairs(ch:GetDescendants()) do if d:IsA("BasePart") then d.CanCollide = false end end
						tbl.RunService.RenderStepped:Wait()
						if hrp then hrp.Velocity = vel end
					end)
				elseif connection3 then connection3:Disconnect() connection3 = nil end
			end,
		})
		toggles["Misc_AuraFling"] = makeTogProxy(_af, false)

		MiscFlingUnloadST:AddSlider({ Text = "Fling Power", Min = 5000, Max = 100000, Default = 50000, Increment = 1000, Flag = "Misc_FlingPower",
			Callback = function(v) options["Misc_FlingPower"].Value = v end,
		})
		options["Misc_FlingPower"] = makeOptProxy(nil, 50000)
		options["Misc_FlingPower"].Value = 50000

		MiscFlingUnloadST:AddButton({ Text = "Tools Jerk", Icon = "Lucide:wrench", Callback = function()
			pcall(function() loadstring(game:HttpGet("https://pastefy.app/wa3v2Vgm/raw"))() sendNotif("Tools loaded!", 3) end)
		end })

		MiscFlingUnloadST:AddSection("Unload", "Lucide:power")

		MiscFlingUnloadST:AddButton({
			Text = "Destroy UI",
			Description = "Completely unloads the script",
			Icon = "Lucide:trash-2",
			Callback = function()
				tbl6.Unloaded = true
				pcall(function() VindUI:Unload() end)
				if folder then folder:Destroy() end
				if circle then circle.Visible = false circle:Remove() end
				if tbl6.CutsceneConn then tbl6.CutsceneConn:Disconnect() end
				if tbl6.CharCutscene then tbl6.CharCutscene:Disconnect() end
				if tbl6.FlyConnection then tbl6.FlyConnection:Disconnect() end
				if tbl6.FollowConnection then tbl6.FollowConnection:Disconnect() end
				if tbl6.Pv2Con then tbl6.Pv2Con:Disconnect() end
				if connection3 then connection3:Disconnect() end
				if connection then connection:Disconnect() end
				if connection2 then connection2:Disconnect() end
				if tbl6.FleeThread then task.cancel(tbl6.FleeThread) end
				if tbl6.VaultBoostThread then task.cancel(tbl6.VaultBoostThread) end
				activateDashLock(false)
				if getgenv().SlasherInvisLoop then task.cancel(getgenv().SlasherInvisLoop) getgenv().SlasherInvisLoop = nil end
				if getgenv().resolusi then getgenv().resolusi:Disconnect() getgenv().resolusi = nil end
				if getgenv().VD_FakeParry_Cleanup then pcall(getgenv().VD_FakeParry_Cleanup) end
				if getgenv().InfoPerkCleanup then pcall(getgenv().InfoPerkCleanup) end
				clearAllESP()
				if part then part:Destroy() end
				if highlight then highlight:Destroy() end
				for _, n in ipairs({ "WM", "FovC", "SpcGui", "TargetUI", "Croshair" }) do
					local gui = tbl.CoreGui:FindFirstChild(n) or (tbl.LocalPlayer:FindFirstChild("PlayerGui") and tbl.LocalPlayer.PlayerGui:FindFirstChild(n))
					if gui then gui:Destroy() end
				end
				if getgenv().Tixo_SpectatorUI then getgenv().Tixo_SpectatorUI:Destroy() end
				local ch = tbl.LocalPlayer.Character
				if ch then
					local h2 = ch:FindFirstChildOfClass("Humanoid")
					local hrp = ch:FindFirstChild("HumanoidRootPart")
					if h2 then
						h2.WalkSpeed = tbl6.OriginalSpeed or 16 h2.UseJumpPower = false h2.JumpPower = 50
						if ch:FindFirstChild("Animate") then ch.Animate.Disabled = false end
						h2:ChangeState(Enum.HumanoidStateType.Running)
					end
					if hrp then
						for _, n2 in ipairs({ "FlyStable", "FlyGyro", "SpamHitCircleESP", "AutoParryCircleESP", "KillerWarn" }) do
							if hrp:FindFirstChild(n2) then hrp[n2]:Destroy() end
						end
					end
					ch:SetAttribute("vaultspeed", 1) ch:SetAttribute("speedboost", 1)
				end
				tbl.Camera.FieldOfView = 70
				tbl.LocalPlayer.CameraMode = Enum.CameraMode.Classic
				tbl.LocalPlayer.CameraMinZoomDistance = 0.5
				tbl.LocalPlayer.CameraMaxZoomDistance = 128
				stopFullbrightLoop()
				if tbl6.OriginalLighting then
					tbl.Lighting.Brightness = tbl6.OriginalLighting.Brightness
					tbl.Lighting.FogEnd = tbl6.OriginalLighting.FogEnd
					tbl.Lighting.GlobalShadows = tbl6.OriginalLighting.GlobalShadows
					tbl.Lighting.OutdoorAmbient = tbl6.OriginalLighting.OutdoorAmbient
					tbl.Lighting.Ambient = tbl6.OriginalLighting.Ambient
					local atm = tbl.Lighting:FindFirstChildOfClass("Atmosphere")
					if atm and tbl6.OriginalLighting.AtmosphereDensity then atm.Density = tbl6.OriginalLighting.AtmosphereDensity end
				end
				removeFakeName()
				for _, fn in ipairs({ "CleanupNoCD", "RemoveCopyAvatar", "RemoveSkyChanger", "RemoveGlobalChat", "Moonwalk", "RemoveInvisibleGui" }) do
					if getgenv()[fn] then pcall(getgenv()[fn]) end
				end
				local ic = tbl.Workspace:FindFirstChild("invischair")
				if ic then pcall(function() ic:Destroy() end) end
				tbl.LocalPlayer:SetAttribute("Level", tbl4.Level)
				tbl.LocalPlayer:SetAttribute("Gears", tbl4.Gears)
				tbl.LocalPlayer:SetAttribute("Screws", tbl4.Screws)
				for k, v in pairs(tbl3) do if type(v) == "boolean" then tbl3[k] = false end end
			end,
		})

		local jobId = game.JobId == "" and "Singleplayer/Studio" or game.JobId

		InfoTab:AddCard({
			Title = tbl.LocalPlayer.Name,
			Description = "Status: " .. (flag and "VIP" or "FREE") .. "  |  Expired: " .. expired,
			UserId = tbl.LocalPlayer.UserId,
		})

		tbl6.TeamLabel = InfoTab:AddLabel("Team: " .. (tbl6.cachedRole or str or "Unknown"))

		InfoTab:AddSection("Server", "Lucide:server")

		InfoTab:AddButton({ Text = "Copy Server ID", Icon = "Lucide:copy", Callback = function() if setclipboard then setclipboard(jobId) sendNotif("Copied!", 3) end end })
		InfoTab:AddButton({ Text = "Rejoin Server", Icon = "Lucide:refresh-cw",
			Callback = function()
				local lp = tbl.Players.LocalPlayer
				if game.JobId ~= "" then tbl.TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, lp)
				else tbl.TeleportService:Teleport(game.PlaceId, lp) end
			end,
		})
		InfoTab:AddButton({ Text = "Server Hop", Icon = "Lucide:shuffle", Callback = function() sendNotif("Finding server...", 2) hopToNewServer() end })
		InfoTab:AddButton({ Text = "Copy Key", Icon = "Lucide:key",
			Callback = function()
				if str2 and str2 ~= "" then
					if setclipboard then setclipboard(str2) sendNotif("Key copied!", 3) else sendNotif("Copy not supported!", 3) end
				else sendNotif("No key saved!", 3) end
			end,
		})

		InfoTab:AddSection("Script Info", "Lucide:code")

		InfoTab:AddInfoGrid({
			Title = "PerplexWare",
			Color = Color3.fromRGB(255, 255, 255),
			Columns = 2,
			Items = {
				{ Label = "Developer", Value = "by @rainlover.r" },
				{ Label = "Version", Value = tbl2.version },
				{ Label = "Status", Value = "Active" },
				{ Label = "Game", Value = game.Name ~= "" and game.Name:sub(1, 14) or tostring(game.PlaceId) },
			},
		})

		InfoTab:AddSection("Social", "Lucide:message-circle")

		InfoTab:AddButton({ Text = "Join Discord", Icon = "Lucide:message-circle",
			Callback = function()
				if setclipboard then setclipboard(tbl2.dc) sendNotif("Discord link copied!", 2) end
			end,
		})

		task.spawn(function()
			local ok, result = pcall(function()
				return tbl.HttpService:JSONDecode(game:HttpGet("https://discord.com/api/v9/invites/YCMd7Nq8xf?with_counts=true"))
			end)
			if ok and result and result.approximate_member_count then
				InfoTab:AddLabel("Members: " .. result.approximate_member_count)
			else
				InfoTab:AddLabel("dsc.gg/PerplexWarehub")
			end
		end)

		InfoTab:AddSection("Config", "Lucide:settings")

		local CFOLDER = "PerplexWare_VDCONFIG"
		local configNameValue = "default"

		local function listConfigs()
			local configs = {}
			pcall(function()
				if listfiles then
					for _, path in ipairs(listfiles(CFOLDER)) do
						local name = path:match("([^/\\]+)%.json$")
						if name then table.insert(configs, name) end
					end
				end
			end)
			if #configs == 0 then table.insert(configs, "(none)") end
			return configs
		end

		local function buildConfigTable()
			local out = {}
			for k, val in pairs(tbl3) do
				local t = type(val)
				if t == "boolean" or t == "number" or t == "string" then
					out[k] = val
				end
			end
			out._chromaEnabled = tbl3.ESP_Chroma
			out._parryMethod = tbl3.Surv_ParryMethod
			out._pingParry = tbl3.Surv_PingParry
			out._espHighestGen = tbl3.ESP_HighestGen
			out._injuredColor = tbl3.ESP_InjuredColor
			return out
		end

		local function applyConfig(config)
			for k, val in pairs(config) do
				if tbl3[k] ~= nil then tbl3[k] = val end
			end
		end

		local configDropdown

		local configNameTB = InfoTab:AddTextbox({
			Text = "Config Name",
			Placeholder = "default",
			Default = "default",
			Icon = "Lucide:file-cog",
			Callback = function(v)
				if v and v ~= "" then configNameValue = v end
			end,
		})

		InfoTab:AddButton({ Text = "Refresh List", Icon = "Lucide:refresh-cw",
			Callback = function()
				if configDropdown then
					pcall(function() configDropdown:Refresh(listConfigs()) end)
					sendNotif("Config list refreshed", 2)
				end
			end,
		})

		configDropdown = InfoTab:AddDropdown({
			Text = "Select Config",
			Options = listConfigs(),
			Flag = "Config_Selected",
			Callback = function(v)
				if v ~= "(none)" then
					configNameValue = v
					pcall(function() configNameTB:Set(v) end)
				end
			end,
		})

		InfoTab:AddButton({ Text = "Save Config", Icon = "Lucide:save",
			Callback = function()
				pcall(function()
					if not writefile then sendNotif("writefile not supported", 3) return end
					local name = configNameValue ~= "" and configNameValue or "default"
					local path = CFOLDER .. "/" .. name .. ".json"
					writefile(path, tbl.HttpService:JSONEncode(buildConfigTable()))
					sendNotif("Saved: " .. name, 3)
					if configDropdown then pcall(function() configDropdown:Refresh(listConfigs()) end) end
				end)
			end,
		})

		InfoTab:AddButton({ Text = "Load Config", Icon = "Lucide:folder-open",
			Callback = function()
				pcall(function()
					if not readfile then sendNotif("readfile not supported", 3) return end
					local name = configNameValue ~= "" and configNameValue or "default"
					local path = CFOLDER .. "/" .. name .. ".json"
					local ok, data = pcall(readfile, path)
					if not ok then sendNotif("Config not found: " .. name, 3) return end
					applyConfig(tbl.HttpService:JSONDecode(data))
					sendNotif("Loaded: " .. name, 3)
				end)
			end,
		})

		InfoTab:AddButton({ Text = "Remove Config", Icon = "Lucide:trash-2",
			Callback = function()
				pcall(function()
					if not delfile then sendNotif("delfile not supported", 3) return end
					local name = configNameValue ~= "" and configNameValue or "default"
					local path = CFOLDER .. "/" .. name .. ".json"
					delfile(path)
					sendNotif("Removed: " .. name, 3)
					if configDropdown then pcall(function() configDropdown:Refresh(listConfigs()) end) end
				end)
			end,
		})

		InfoTab:AddToggle({
			Text = "Auto Load Config on Start",
			Description = "Loads a saved config automatically when the script runs",
			Icon = "Lucide:zap",
			Default = false,
			Flag = "Config_AutoLoad",
			Callback = function(v)
				if writefile then
					pcall(function()
						if v then
							writefile(CFOLDER .. "/autoload.txt", configNameValue)
						else
							if delfile then delfile(CFOLDER .. "/autoload.txt") end
						end
					end)
				end
			end,
		})

		InfoTab:AddButton({ Text = "Copy Config  (.json)", Icon = "Lucide:clipboard-copy",
			Description = "Copies all flags as JSON to clipboard",
			Callback = function()
				pcall(function()
					local config = buildConfigTable()
					local parts = {}
					for k, val in pairs(config) do
						local v
						if type(val) == "string" then v = '"' .. val .. '"'
						elseif type(val) == "boolean" then v = tostring(val)
						else v = tostring(val) end
						table.insert(parts, k .. " = " .. v)
					end
					table.sort(parts)
					local json = "{ " .. table.concat(parts, ", ") .. " }"
					if setclipboard then
						setclipboard(json)
						sendNotif("Config copied!", 3)
					else
						sendNotif("setclipboard not supported", 3)
					end
				end)
			end,
		})

		VindUI:Notify({ Title = "PerplexWare", Text = "Loaded  |  @rainlover.r", Type = "success", Duration = 4, Icon = "Lucide:sparkles" })
	end

	flag = true
	expired = "Trial"
	do
		pcall(function()
			if readfile and isfile then
				local autoPath = "PerplexWare_VDCONFIG/autoload.txt"
				if isfile(autoPath) then
					local cfgName = readfile(autoPath):match("^%s*(.-)%s*$")
					if cfgName and cfgName ~= "" then
						local cfgPath = "PerplexWare_VDCONFIG/" .. cfgName .. ".json"
						if isfile(cfgPath) then
							local data = tbl.HttpService:JSONDecode(readfile(cfgPath))
							for k, val in pairs(data) do
								if tbl3[k] ~= nil then tbl3[k] = val end
							end
							sendNotif("Auto-loaded config: " .. cfgName, 3)
						end
					end
				end
			end
		end)
	end
	buildUITabs()

	local function setupParryResultHandler()
		task.spawn(function()
			local remotes2 = game:GetService("ReplicatedStorage"):WaitForChild("Remotes", 5)
			remotes2 = remotes2 and remotes2:WaitForChild("Items", 5):WaitForChild("Parrying Dagger", 5)
			remotes2 = remotes2 and remotes2:WaitForChild("parryResult", 5)

			if remotes2 then
				remotes2.OnClientEvent:Connect(function(arg, arg2)
					local n4 = tonumber(arg2) or arg == true and 90 or 60
					tbl6.ParryCooldown = true

					if tbl6.ParryCooldownThread then
						task.cancel(tbl6.ParryCooldownThread)
					end

					tbl6.ParryCooldownThread = task.delay(n4, function()
						tbl6.ParryCooldown = false
					end)
				end)
			end
		end)
	end

	setupParryResultHandler()

	local function setupKingScourgeDetect()
		task.spawn(function()
			local remotes2 = game:GetService("ReplicatedStorage"):WaitForChild("Remotes", 10)
			remotes2 = remotes2 and remotes2:WaitForChild("KillerPerks", 5)
			remotes2 = remotes2 and remotes2:WaitForChild("kingscourge", 5)
			remotes2 = remotes2 and remotes2:WaitForChild("KingScourgeStart", 5)

			if remotes2 then
				remotes2.OnClientEvent:Connect(function()
					if tbl3.Surv_SkillCheckMode == "Random" then
						tbl6.RandomMode_IsNormal = true
					end
				end)
			end
		end)
	end

	setupKingScourgeDetect()
	local connection3 = nil

	local function setupAnimationHandler(arg)
		if not arg then
			return
		end

		if connection3 then
			connection3:Disconnect()
			connection3 = nil
		end

		task.spawn(function()
			setupPistolSound(arg)
			local humanoid2 = arg:FindFirstChildOfClass("Humanoid") or arg:WaitForChild("Humanoid", 2)
			if not humanoid2 then return end
			local animator = humanoid2:FindFirstChildOfClass("Animator") or humanoid2:WaitForChild("Animator", 2)
			if not animator then return end

			connection3 = animator.AnimationPlayed:Connect(function(arg2)
				local animationId = arg2.Animation and arg2.Animation.AnimationId
				if not animationId then
					return
				end

				if tbl3.Surv_SelfHeal and string.find(animationId, "95836365038528") then
					arg2:Stop(0)
				end
			end)
		end)
	end

	local function corruptAbysswalker()
		if tbl6.cachedRole ~= "Killer" then
			return
		end
		local selectedKiller = tbl.LocalPlayer:FindFirstChild("SelectedKiller")

		if string.find(string.lower(tostring(selectedKiller and selectedKiller.Value or tbl.LocalPlayer:GetAttribute("SelectedKiller"))), "abyss") then
			pcall(function()
				game:GetService("ReplicatedStorage").Remotes.Killers.Abysswalker.corrupt:FireServer()
			end)
		end
	end

	local function doCrouchInput(arg)
		pcall(function()
			local playerGui = tbl.LocalPlayer:FindFirstChild("PlayerGui")

			for match in string.gmatch("Survivor-mob.Controls.crouch.icon", "[^%.]+") do
				playerGui = playerGui and playerGui:FindFirstChild(match)
			end

			if playerGui and playerGui:IsA("GuiObject") and playerGui.Visible and playerGui.Parent and playerGui.Parent:IsA("GuiButton") then
				local parent = playerGui.Parent

				if tbl.UserInputService.TouchEnabled and type(firesignal) == "function" then
					firesignal(parent.MouseButton1Click)
					task.wait(arg)
					firesignal(parent.MouseButton1Click)
				else
					tbl.VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.LeftControl, false, game)
					task.wait(arg)
					tbl.VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.LeftControl, false, game)
				end
			else
				tbl.VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.LeftControl, false, game)
				task.wait(arg)
				tbl.VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.LeftControl, false, game)
			end
		end)
	end

	local function startAbyssalLoop()
		if tbl6.isHolding then
			return
		end
		tbl6.isHolding = true

		task.spawn(function()
			while tbl6.isHolding and tbl3.Killer_InfAbyssal and tbl6.cachedRole == "Killer" do
				corruptAbysswalker()
				task.wait(0.5)
			end
		end)
	end

	tbl.UserInputService.InputBegan:Connect(function(input, gameProcessed)
		local flag4 = input.UserInputType == Enum.UserInputType.Touch
		if gameProcessed and not flag4 then
			return
		end
		local character = tbl.LocalPlayer.Character
		character = character and character:GetAttribute("spearmode") == true

		if tbl3.Killer_InfAbyssal and input.KeyCode == Enum.KeyCode.Q then
			startAbyssalLoop()
		end

		if input.UserInputType == Enum.UserInputType.MouseButton2 then
			if tbl3.Aim_Silent then
				tbl8.isChargingPistol = true
				tbl6.locked = findAimTarget("Pistol")
			end

			if tbl3.Flash_Silent then
				tbl8.isAimingFlash = true
			end
		elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
			if tbl3.Aim_Silent and tbl8.isChargingPistol then
				firePistolAim()
			end

			character = tbl3.Aim_SilentVeil and character

			if character then
				tbl8.isChargingSpear = true
				tbl8.spearAimStartTime = tick()

				task.delay(7, function()
					local isChargingSpear = tbl8.isChargingSpear

					if isChargingSpear then
						local spearAimStartTime = tbl8.spearAimStartTime
						isChargingSpear = tick() - spearAimStartTime >= 6.9
					end

					if isChargingSpear then
						tbl8.isChargingSpear = false
						tbl8.currentTouchInput = nil
					end
				end)
			end

			if tbl6.cachedRole == "Killer" then
				if tbl3.Aimbot_Enabled then
					tbl8.lockedAimbotTarget = findAimTarget("Aimbot")

					if tbl8.lockedAimbotTarget then
						tbl8.isAimbotHolding = true
					end
				end

				if tbl3.Killer_InfLunge then
					startInfLungeLoop()
				end
			end
		elseif flag4 then
			if tbl3.Killer_InfAbyssal then
				local v4 = findKillerMobGui()
				local move2 = v4 and v4:FindFirstChild("Controls") and v4.Controls:FindFirstChild("move2")

				if move2 and move2.Visible then
					local position3 = input.Position
					local absolutePosition = move2.AbsolutePosition
					local absoluteSize = move2.AbsoluteSize

					if position3.X >= absolutePosition.X and position3.X <= absolutePosition.X + absoluteSize.X and position3.Y >= absolutePosition.Y and position3.Y <= absolutePosition.Y + absoluteSize.Y then
						startAbyssalLoop()
						tbl6.currentTouch = input
					end
				end
			end

			if tbl6.cachedRole == "Killer" then
				local v4 = findKillerMobGui()
				local attack = v4 and v4:FindFirstChild("Controls") and v4.Controls:FindFirstChild("attack")

				if attack and attack.Visible then
					local position3 = input.Position
					local absolutePosition = attack.AbsolutePosition
					local absoluteSize = attack.AbsoluteSize

					if position3.X >= absolutePosition.X and position3.X <= absolutePosition.X + absoluteSize.X and position3.Y >= absolutePosition.Y and position3.Y <= absolutePosition.Y + absoluteSize.Y then
						if tbl3.Aimbot_Enabled then
							tbl8.lockedAimbotTarget = findAimTarget("Aimbot")

							if tbl8.lockedAimbotTarget then
								tbl8.isAimbotHolding = true
							end
						end

						if tbl3.Killer_InfLunge then
							startInfLungeLoop()
							tbl6.touchLunge = input
						end
					end
				end
			end

			if tbl3.Aim_Silent or tbl3.Flash_Silent then
				local playerGui = tbl.LocalPlayer:FindFirstChild("PlayerGui")
				local guiMob = playerGui and playerGui:FindFirstChild("Survivor-mob") and playerGui["Survivor-mob"]:FindFirstChild("Controls") and playerGui["Survivor-mob"].Controls:FindFirstChild("Gui-mob")

				if guiMob and guiMob.Visible then
					local position3 = input.Position
					local absolutePosition = guiMob.AbsolutePosition
					local absoluteSize = guiMob.AbsoluteSize

					if position3.X >= absolutePosition.X and position3.X <= absolutePosition.X + absoluteSize.X and position3.Y >= absolutePosition.Y and position3.Y <= absolutePosition.Y + absoluteSize.Y then
						if tbl3.Aim_Silent then
							tbl8.isChargingPistol = true
							tbl8.currentTouchInput = input
							tbl6.locked = findAimTarget("Pistol")
						end

						if tbl3.Flash_Silent then
							tbl8.isAimingFlash = true
							tbl8.currentTouchInput = input
						end
					end
				end
			end

			if tbl3.Aim_SilentVeil and character and not tbl6.spearSwitchCooldown then
				local playerGui = tbl.LocalPlayer:FindFirstChild("PlayerGui")
				local attack = playerGui and playerGui:FindFirstChild("Slasher-mob") and playerGui["Slasher-mob"]:FindFirstChild("Controls") and playerGui["Slasher-mob"].Controls:FindFirstChild("attack")

				if attack and attack.Visible then
					local position3 = input.Position
					local absolutePosition = attack.AbsolutePosition
					local absoluteSize = attack.AbsoluteSize

					if position3.X >= absolutePosition.X and position3.X <= absolutePosition.X + absoluteSize.X and position3.Y >= absolutePosition.Y and position3.Y <= absolutePosition.Y + absoluteSize.Y then
						tbl8.isChargingSpear = true
						tbl8.currentTouchInput = input
						tbl8.spearAimStartTime = tick()

						task.delay(7, function()
							local isChargingSpear = tbl8.isChargingSpear

							if isChargingSpear then
								local spearAimStartTime = tbl8.spearAimStartTime
								isChargingSpear = tick() - spearAimStartTime >= 6.9
							end

							if isChargingSpear then
								tbl8.isChargingSpear = false
								tbl8.currentTouchInput = nil
							end
						end)
					end
				end
			end
		end
	end)

	tbl.UserInputService.InputEnded:Connect(function(input)
		local flag4 = input.UserInputType == Enum.UserInputType.Touch

		if input.KeyCode == Enum.KeyCode.Q then
			tbl6.isHolding = false
		end

		if input.UserInputType == Enum.UserInputType.MouseButton2 then
			if tbl8.isChargingPistol then
				tbl8.isChargingPistol = false
				tbl6.locked = nil
			end

			if tbl8.isAimingFlash then
				tbl8.isAimingFlash = false
			end
		end

		if input.UserInputType == Enum.UserInputType.MouseButton1 or flag4 then
			tbl8.isAimbotHolding = false
			tbl8.lockedAimbotTarget = nil

			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				tbl6.isHoldingLunge = false
			end
		end

		if flag4 and input == tbl6.touchLunge then
			tbl6.isHoldingLunge = false
			tbl6.touchLunge = nil
		end

		if flag4 and input == tbl6.currentTouch then
			tbl6.isHolding = false
			tbl6.currentTouch = nil
		end

		if tbl8.isChargingSpear and (input == tbl8.currentTouchInput or input.UserInputType == Enum.UserInputType.MouseButton1) then
			tbl8.isChargingSpear = false

			if tbl8.currentTouchInput == input then
				tbl8.currentTouchInput = nil
			end

			if tbl6.spearSwitchCooldown then
				return
			end

			if tick() - (tbl8.spearAimStartTime or tick()) >= 7 then
				return
			end

			if tbl6.isAttackCd then
				return
			end
			tbl6.isAttackCd = true

			task.delay(3, function()
				tbl6.isAttackCd = false
			end)

			local character = tbl.LocalPlayer.Character
			local humanoidRootPart2 = character and character:FindFirstChild("HumanoidRootPart")

			if character and (character:FindFirstChild("Head") or humanoidRootPart2) and humanoidRootPart2 then
				local flag5 = character:GetAttribute("special") == true
				local position3 = humanoidRootPart2.Position
				local spearSpeed = tbl3.SmartPredict and (flag5 and 165 or 142.5) or tbl3.SPEAR_Speed
				local Survivor = findAimTarget("Survivor")
				local unit

				if Survivor then
					local humanoidRootPart3 = Survivor:IsA("Model") and Survivor:FindFirstChild("HumanoidRootPart") or Survivor
					local position4 = humanoidRootPart3.Position
					local humanoid2 = Survivor.Parent and Survivor.Parent:FindFirstChildOfClass("Humanoid")
					local n4

					if humanoid2 and humanoid2.MoveDirection.Magnitude > 0 then
						n4 = humanoid2.MoveDirection * humanoid2.WalkSpeed
					else
						n4 = Vector3.zero

						if humanoidRootPart3:IsA("BasePart") then
							n4 = humanoidRootPart3.AssemblyLinearVelocity
						end
					end

					local vector = Vector3.new(n4.X, 0, n4.Z)
					local magnitude = (position4 - position3).Magnitude
					local n5 = magnitude / spearSpeed

					if tbl3.SmartPredict then
						unit = (position4 + vector * n5 * tbl3.Veil_LeadMultiplier + Vector3.new(0, 0.5 * tbl.Workspace.Gravity * 0.5 * n5 ^ 2 - 1.5, 0) - position3).Unit
					else
						unit = (position4 + vector * n5 * math.clamp(magnitude / 50, 0.1, 4) + Vector3.new(0, 0.5 * tbl3.SPEAR_Gravity * n5 ^ 2 * math.clamp(magnitude / 100, 1, 2.5), 0) - position3).Unit
					end
				else
					unit = tbl.Camera.CFrame.LookVector
				end

				pcall(function()
					tbl.ReplicatedStorage.Remotes.Killers.Veil.Spearthrow:FireServer(unit, spearSpeed, position3)
				end)
			end
		end

		if flag4 and input == tbl8.currentTouchInput then
			if tbl8.isChargingPistol then
				tbl8.isChargingPistol = false
				tbl8.currentTouchInput = nil
				local flag5 = false

				pcall(function()
					local playerGui = tbl.LocalPlayer:FindFirstChild("PlayerGui")
					local cancelaim = playerGui and playerGui:FindFirstChild("Survivor-mob") and playerGui["Survivor-mob"]:FindFirstChild("Controls") and playerGui["Survivor-mob"].Controls:FindFirstChild("Gui-mob") and playerGui["Survivor-mob"].Controls["Gui-mob"]:FindFirstChild("cancelaim")

					if cancelaim and cancelaim.Visible then
						local position3 = input.Position
						local absolutePosition = cancelaim.AbsolutePosition
						local absoluteSize = cancelaim.AbsoluteSize

						if position3.X >= absolutePosition.X and position3.X <= absolutePosition.X + absoluteSize.X and position3.Y >= absolutePosition.Y and position3.Y <= absolutePosition.Y + absoluteSize.Y then
							flag5 = true
						end
					end
				end)

				if not flag5 then
					firePistolAim()
				end

				tbl6.locked = nil
			end

			if tbl8.isAimingFlash then
				tbl8.isAimingFlash = false
				tbl8.currentTouchInput = nil
			end
		end
	end)

	local flag4 = false
	local position3 = nil
	local position4 = nil

	frame5.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			flag4 = true
			position3 = input.Position
			position4 = frame4.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					flag4 = false
				end
			end)
		end
	end)

	tbl.UserInputService.InputChanged:Connect(function(input)
		local flag5 = flag4

		if flag4 then
			flag5 = input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch
		end

		if flag5 then
			local n4 = input.Position - position3
			frame4.Position = UDim2.new(position4.X.Scale, position4.X.Offset + n4.X, position4.Y.Scale, position4.Y.Offset + n4.Y)
		end
	end)

	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			flag2 = true
			position = input.Position
			position2 = frame.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					flag2 = false
				end
			end)
		end
	end)

	frame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			v2 = input
		end
	end)

	tbl.UserInputService.InputChanged:Connect(function(input)
		if flag2 and input == v2 then
			updateWatermarkDrag(input)
		end
	end)

	local tbl18 = {}
	local trackKillerAnimations = nil

	trackKillerAnimations = function(arg)
		if not arg or tbl18[arg] then return end
		tbl18[arg] = true

		local humanoid2 = arg:FindFirstChildOfClass("Humanoid")
		if not humanoid2 then
			humanoid2 = arg:WaitForChild("Humanoid", 2)
			if not humanoid2 then tbl18[arg] = nil return end
		end

		local animator = humanoid2:FindFirstChildOfClass("Animator")
		if not animator then
			animator = humanoid2:WaitForChild("Animator", 2)
			if not animator then tbl18[arg] = nil return end
		end

		local conn4, conn5

		conn4 = humanoid2.ChildAdded:Connect(function(child)
			if child:IsA("Animator") then
				tbl18[arg] = nil
				if conn4 then conn4:Disconnect() conn4 = nil end
				if conn5 then conn5:Disconnect() conn5 = nil end
				trackKillerAnimations(arg)
			end
		end)

		conn5 = arg.AncestryChanged:Connect(function(_, parent)
			if not parent then
				tbl18[arg] = nil
				if conn4 then conn4:Disconnect() conn4 = nil end
				if conn5 then conn5:Disconnect() conn5 = nil end
				_pv2KillerCache[arg] = nil
			end
		end)

		animator.AnimationPlayed:Connect(function(arg2)
			local match = (arg2.Animation and arg2.Animation.AnimationId or ""):match("%d+")

			if (match == "86266790353635" or match == "93136435416899") and tbl3.Surv_CrouchV then
				local character = tbl.LocalPlayer.Character
				local selfHrp = character and character:FindFirstChild("HumanoidRootPart")
				local killerHrp = arg:FindFirstChild("HumanoidRootPart")
				if selfHrp and killerHrp and selfHrp.Parent and killerHrp.Parent then
					if (selfHrp.Position - killerHrp.Position).Magnitude <= 35 then
						local faceDir = Vector3.new(selfHrp.Position.X, 0, selfHrp.Position.Z) - Vector3.new(killerHrp.Position.X, 0, killerHrp.Position.Z)
						if faceDir.Magnitude > 0 then
							local lookDir = Vector3.new(killerHrp.CFrame.LookVector.X, 0, killerHrp.CFrame.LookVector.Z)
							if lookDir.Magnitude > 0.001 and lookDir.Unit:Dot(faceDir.Unit) >= 0.7 then
								doCrouchInput(0.3)
							end
						end
					end
				end
			end

			if match == "80411309607666" and tbl3.Surv_AutoCrouch then
				local character = tbl.LocalPlayer.Character
				if isKnockedOrHooked(character) or not canSafeParry(character) then return end
				local selfHrp = character and character:FindFirstChild("HumanoidRootPart")
				local killerHrp = arg:FindFirstChild("HumanoidRootPart")
				if selfHrp and killerHrp and selfHrp.Parent and killerHrp.Parent then
					if (selfHrp.Position - killerHrp.Position).Magnitude <= 35 then
						doCrouchInput(1.5)
					end
				end
				return
			end

			if not tbl3.Surv_AutoParry and not tbl3.Surv_Parry then return end
			if tbl6.ParryCooldown then return end

			local character = tbl.LocalPlayer.Character
			if not character or isKnockedOrHooked(character) or not canSafeParry(character) then return end

			local selfHrp = character:FindFirstChild("HumanoidRootPart")
			local killerHrp = arg:FindFirstChild("HumanoidRootPart")
			if not selfHrp or not killerHrp then return end

			local radius = tbl3.Surv_ParryRadius + (tbl3.Surv_ParryAggressive and 5 or 0)
			local predictedKillerPos = getKillerPredictedPos(killerHrp)
			local magnitude = (selfHrp.Position - predictedKillerPos).Magnitude
			if magnitude > radius then return end

			local faceDir = Vector3.new(selfHrp.Position.X, 0, selfHrp.Position.Z) - Vector3.new(predictedKillerPos.X, 0, predictedKillerPos.Z)
			if faceDir.Magnitude > 0 then
				local lookDir = Vector3.new(killerHrp.CFrame.LookVector.X, 0, killerHrp.CFrame.LookVector.Z)
				if lookDir.Magnitude > 0.001 and lookDir.Unit:Dot(faceDir.Unit) < (tbl3.Surv_ParryFace or 0.3) then
					return
				end
			end

			fireParryInput()
		end)
	end

	local function onKillerCharAdded(arg)
		if arg ~= tbl.LocalPlayer and isPlayerKiller(arg) and arg.Character then
			trackKillerAnimations(arg.Character)
		end
	end

	local function trackPlayerEvents(arg)
		if arg == tbl.LocalPlayer then
			return
		end

		arg.CharacterAdded:Connect(function()
			onKillerCharAdded(arg)
		end)

		arg:GetPropertyChangedSignal("Team"):Connect(function()
			onKillerCharAdded(arg)
		end)

		if arg.Character then
			onKillerCharAdded(arg)
		end
	end

	for _, player in ipairs(tbl.Players:GetPlayers()) do
		trackPlayerEvents(player)
		player:GetPropertyChangedSignal("Team"):Connect(updateSpectatorCount)
	end

	tbl.Players.PlayerAdded:Connect(function(player)
		updateSpectatorCount()
		player:GetPropertyChangedSignal("Team"):Connect(updateSpectatorCount)
		trackPlayerEvents(player)
	end)

	tbl.Players.PlayerRemoving:Connect(function()
		updateSpectatorCount()
	end)

	local _rsFrameCount = 0
	local _aimbotTarget = nil
	local _cachedParryRadius = -1
	local _cachedParryAggressive = nil
	local _cachedParryCooldown = nil
	local _cachedSpamRadius = -1
	local _cachedFovCircleRadius = -1
	local _cachedFovCircleColor = nil
	local _cachedFovCircleVisible = nil

	tbl.RunService.RenderStepped:Connect(function()
		_rsFrameCount = _rsFrameCount + 1

		local character = v
		local humanoidRootPart2 = humanoidRootPart
		local currentRole = tbl6.cachedRole

		if tbl3.Surv_Fov and currentRole == "Survivor" and tbl.Camera.FieldOfView ~= tbl3.Surv_FOV_Value then
			tbl.Camera.FieldOfView = tbl3.Surv_FOV_Value
		end

		if tbl8.isAimingFlash and tbl3.Flash_Silent then
			local Flash = findAimTarget("Flash")
			if Flash then
				local n4 = Flash.Position + Vector3.new(0, tbl3.Flash_YOffset, 0)
				local currentCamera = tbl.Workspace.CurrentCamera
				currentCamera.CFrame = currentCamera.CFrame:Lerp(CFrame.lookAt(currentCamera.CFrame.Position, n4), 0.5)
				if humanoidRootPart2 then
					humanoidRootPart2.CFrame = humanoidRootPart2.CFrame:Lerp(CFrame.lookAt(humanoidRootPart2.Position, Vector3.new(n4.X, humanoidRootPart2.Position.Y, n4.Z)), 0.5)
				end
			end
		end

		if tbl8.isChargingPistol and tbl3.Aim_Lock then
			if tbl6.locked and tbl6.locked.Parent and tbl6.locked.Parent:FindFirstChild("Humanoid") and tbl6.locked.Parent.Humanoid.Health > 0 then
				lerpCameraTarget(tbl6.locked)
			else
				tbl6.locked = findAimTarget("Pistol")
			end
		end

		if tbl3.Aimbot_Enabled and character then
			local aimbotSmoothness = tbl3.Aimbot_Smoothness
			if currentRole == "Survivor" then
				_aimbotTarget = findAimTarget("Aimbot")
				if _aimbotTarget and humanoidRootPart2 then
					local position5 = _aimbotTarget.Position
					local dist = getDistanceTo(position5)
					if dist < 100 then
						position5 = position5 + tbl.Camera.CFrame.RightVector * (100 - dist) * tbl3.Aimbot_Predict
					end
					tbl.Camera.CFrame = tbl.Camera.CFrame:Lerp(CFrame.new(tbl.Camera.CFrame.Position, position5), aimbotSmoothness)
					humanoidRootPart2.CFrame = humanoidRootPart2.CFrame:Lerp(CFrame.new(humanoidRootPart2.Position, Vector3.new(position5.X, humanoidRootPart2.Position.Y, position5.Z)), aimbotSmoothness)
				end
			elseif currentRole == "Killer" then
				if tbl8.isAimbotHolding then
					if tbl8.lockedAimbotTarget then
						local parent = tbl8.lockedAimbotTarget.Parent
						local h2 = parent and parent:FindFirstChild("Humanoid")
						if not h2 or h2.Health <= 0 or isKnockedOrHooked(parent) or (tbl8.lockedAimbotTarget.Position - humanoidRootPart2.Position).Magnitude > tbl3.Aimbot_MaxDist then
							tbl8.lockedAimbotTarget = findAimTarget("Aimbot")
						end
					else
						tbl8.lockedAimbotTarget = findAimTarget("Aimbot")
					end
					if tbl8.lockedAimbotTarget and humanoidRootPart2 then
						local position5 = tbl8.lockedAimbotTarget.Position
						tbl.Camera.CFrame = tbl.Camera.CFrame:Lerp(CFrame.new(tbl.Camera.CFrame.Position, position5), aimbotSmoothness)
						humanoidRootPart2.CFrame = humanoidRootPart2.CFrame:Lerp(CFrame.new(humanoidRootPart2.Position, Vector3.new(position5.X, humanoidRootPart2.Position.Y, position5.Z)), aimbotSmoothness)
					end
				else
					tbl8.lockedAimbotTarget = nil
					_aimbotTarget = nil
				end
			end
		else
			_aimbotTarget = nil
		end

		if _rsFrameCount % 2 == 0 then
			if tbl3.Killer_HitEspCircle and tbl3.Killer_SpamHit and humanoidRootPart2 then
				if not tbl6.SpamHit or tbl6.SpamHit.Parent ~= humanoidRootPart2 then
					if tbl6.SpamHit then tbl6.SpamHit:Destroy() end
					tbl6.SpamHit = Instance.new("CylinderHandleAdornment")
					tbl6.SpamHit.Name = "SpamHitCircleESP"
					tbl6.SpamHit.Height = 0.05
					tbl6.SpamHit.Color3 = Color3.fromRGB(255, 0, 0)
					tbl6.SpamHit.Transparency = 0.3
					tbl6.SpamHit.Adornee = humanoidRootPart2
					tbl6.SpamHit.Parent = humanoidRootPart2
					tbl6.SpamHit.ZIndex = 0
					tbl6.SpamHit.AlwaysOnTop = false
					_cachedSpamRadius = -1
				end
				local r = tbl3.Killer_SpamHitRadius
				if r ~= _cachedSpamRadius then
					tbl6.SpamHit.Radius = r
					tbl6.SpamHit.InnerRadius = math.max(0.1, r - 0.15)
					tbl6.SpamHit.CFrame = CFrame.new(0, -3, 0) * CFrame.Angles(1.5707963267948966, 0, 0)
					_cachedSpamRadius = r
				end
			elseif tbl6.SpamHit then
				tbl6.SpamHit:Destroy()
				tbl6.SpamHit = nil
				_cachedSpamRadius = -1
			end

			local survParry = tbl3.Surv_ParryCircle and (tbl3.Surv_AutoParry or tbl3.Surv_Parry or tbl3.Surv_ParryV2)
			if survParry and humanoidRootPart2 then
				if not tbl6.autoParry or tbl6.autoParry.Parent ~= humanoidRootPart2 then
					if tbl6.autoParry then tbl6.autoParry:Destroy() end
					tbl6.autoParry = Instance.new("CylinderHandleAdornment")
					tbl6.autoParry.Name = "AutoParryCircleESP"
					tbl6.autoParry.Height = 0.05
					tbl6.autoParry.Transparency = 0.3
					tbl6.autoParry.Adornee = humanoidRootPart2
					tbl6.autoParry.Parent = humanoidRootPart2
					tbl6.autoParry.ZIndex = 0
					tbl6.autoParry.AlwaysOnTop = false
					_cachedParryRadius = -1
					_cachedParryAggressive = nil
					_cachedParryCooldown = nil
				end
				local survParryRadius = tbl3.Surv_ParryRadius + (tbl3.Surv_ParryAggressive and 5 or 0)
				local parryCd = tbl6.ParryCooldown
				if survParryRadius ~= _cachedParryRadius then
					tbl6.autoParry.Radius = survParryRadius
					tbl6.autoParry.InnerRadius = math.max(0.1, survParryRadius - 0.15)
					tbl6.autoParry.CFrame = CFrame.new(0, -3, 0) * CFrame.Angles(1.5707963267948966, 0, 0)
					_cachedParryRadius = survParryRadius
				end
				if parryCd ~= _cachedParryCooldown or tbl3.Surv_ParryAggressive ~= _cachedParryAggressive then
					if parryCd then
						tbl6.autoParry.Color3 = Color3.fromRGB(255, 128, 0)
					elseif tbl3.Surv_ParryAggressive then
						tbl6.autoParry.Color3 = Color3.fromRGB(255, 0, 0)
					else
						tbl6.autoParry.Color3 = Color3.fromRGB(0, 255, 255)
					end
					_cachedParryCooldown = parryCd
					_cachedParryAggressive = tbl3.Surv_ParryAggressive
				end
			elseif tbl6.autoParry then
				tbl6.autoParry:Destroy()
				tbl6.autoParry = nil
				_cachedParryRadius = -1
			end

			local flag5 = character and character:GetAttribute("spearmode") == true
			local flag6 = character and character:GetAttribute("special") == true
			local vector2 = Vector2.new(tbl.Camera.ViewportSize.X / 2, tbl.Camera.ViewportSize.Y / 2)
			local color, aimbotRadius, visible

			if tbl3.Aimbot_Enabled and tbl3.Aimbot_ShowFOV then
				aimbotRadius = tbl3.Aimbot_Radius
				color = _aimbotTarget ~= nil and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 100)
				visible = true
			elseif tbl3.Aim_SilentVeil and tbl3.Veil_ShowFOV and flag5 then
				aimbotRadius = tbl3.Veil_FOV
				color = flag6 and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(150, 150, 150)
				visible = true
			elseif tbl3.Aim_Silent and tbl3.Pistol_ShowFOV and tbl3.Pistol_FOVMode then
				aimbotRadius = tbl3.Pistol_FOV
				color = Color3.fromRGB(255, 255, 255)
				visible = true
			else
				visible = false
				aimbotRadius = 0
			end

			if visible ~= _cachedFovCircleVisible or aimbotRadius ~= _cachedFovCircleRadius or color ~= _cachedFovCircleColor then
				frame3.Visible = visible
				if visible then
					frame3.Size = UDim2.new(0, aimbotRadius * 2, 0, aimbotRadius * 2)
					frame3.Position = UDim2.new(0, vector2.X, 0, vector2.Y)
					uiStroke.Color = color
				end
				_cachedFovCircleVisible = visible
				_cachedFovCircleRadius = aimbotRadius
				_cachedFovCircleColor = color
			end
		end

		if tbl8.isChargingPistol and tbl3.Aim_Silent then
			local Pistol = findAimTarget("Pistol")

			if Pistol then
				local leftArm = character:FindFirstChild("Left Arm") or character:FindFirstChild("LeftHand")
				leftArm = leftArm and leftArm.Position or character:GetPivot().Position
				local position5 = Pistol.Position
				local assemblyLinearVelocity = Pistol.AssemblyLinearVelocity
				local n4 = position5 + Vector3.new(assemblyLinearVelocity.X, 0, assemblyLinearVelocity.Z) * (position5 - leftArm).Magnitude / 400 + Vector3.new(0, tbl3.Pistol_AimOffset, 0)

				if tbl3.Pistol_ShowLaser then
					part.Parent = workspace
					local magnitude = (n4 - leftArm).Magnitude
					part.Size = Vector3.new(0.05, 0.05, magnitude)
					part.CFrame = CFrame.new(leftArm, n4) * CFrame.new(0, 0, -magnitude / 2)
				elseif part.Parent ~= nil then
					part.Parent = nil
				end
			elseif part.Parent ~= nil then
				part.Parent = nil
			end
		elseif part.Parent ~= nil then
			part.Parent = nil
		end

		if tbl8.isChargingSpear and tbl3.Aim_SilentVeil and flag5 and not tbl6.spearSwitchCooldown and not flag7 then
			local character2 = tbl.LocalPlayer.Character
			local rightArm = character2 and (character2:FindFirstChild("Right Arm") or character2:FindFirstChild("RightHand"))
			local humanoidRootPart3 = character2 and character2:FindFirstChild("HumanoidRootPart")
			rightArm = rightArm and rightArm.Position or humanoidRootPart3 and humanoidRootPart3.Position + Vector3.new(1.5, 0.5, 0)

			if rightArm and character2 then
				local flag8 = character2:GetAttribute("special") == true
				local smartPredict = tbl3.SmartPredict
				local n4

				if smartPredict then
					n4 = flag8 and 165 or 142.5
				else
					n4 = smartPredict
				end

				n4 = n4 or tbl3.SPEAR_Speed
				local spearGravity = tbl3.SmartPredict and tbl.Workspace.Gravity * 0.5 or tbl3.SPEAR_Gravity
				local Survivor = findAimTarget("Survivor")
				local n5, unit

				if Survivor then
					highlight.Parent = Survivor.Parent
					local humanoidRootPart4 = Survivor:IsA("Model") and Survivor:FindFirstChild("HumanoidRootPart") or Survivor
					local position5 = humanoidRootPart4.Position
					local humanoid2 = Survivor.Parent and Survivor.Parent:FindFirstChildOfClass("Humanoid")
					local n6

					if humanoid2 and humanoid2.MoveDirection.Magnitude > 0 then
						n6 = humanoid2.MoveDirection * humanoid2.WalkSpeed
					else
						n6 = Vector3.zero

						if humanoidRootPart4:IsA("BasePart") then
							n6 = humanoidRootPart4.AssemblyLinearVelocity
						end
					end

					local vector = Vector3.new(n6.X, 0, n6.Z)
					local magnitude = (position5 - rightArm).Magnitude
					local n7 = magnitude / n4

					if tbl3.SmartPredict then
						n5 = position5 + vector * n7 * tbl3.Veil_LeadMultiplier
						unit = (n5 + Vector3.new(0, 0.5 * spearGravity * n7 ^ 2 - 1.5, 0) - rightArm).Unit
					else
						n5 = position5 + vector * n7 * math.clamp(magnitude / 50, 0.1, 4)
						unit = (n5 + Vector3.new(0, 0.5 * spearGravity * n7 ^ 2 * math.clamp(magnitude / 100, 1, 2.5), 0) - rightArm).Unit
					end
				else
					highlight.Parent = nil
					unit = tbl.Camera.CFrame.LookVector
					n5 = nil
				end

				renderSpearTrajectory(rightArm, unit, n4, spearGravity, character2, Survivor, n5)
			else
				hideSpearTrajectory()
				highlight.Parent = nil
			end
		else
			hideSpearTrajectory()
			highlight.Parent = nil
		end
	end)

	tbl6.cachedRole = str or "Spectator"
	local _steppedFrame = 0

	tbl.RunService.Stepped:Connect(function()
		_steppedFrame = _steppedFrame + 1
		if _steppedFrame % 10 == 0 then
			tbl6.cachedRole = str
		end

		if not tbl3.Misc_Noclip then
			return
		end
		local character = tbl.LocalPlayer.Character
		if not character then
			return
		end

		if character ~= tbl6.lastNoclipChar then
			table.clear(tbl6.cachedNoclipParts)

			for _, descendant in ipairs(character:GetDescendants()) do
				if descendant:IsA("BasePart") then
					table.insert(tbl6.cachedNoclipParts, descendant)
				end
			end

			tbl6.lastNoclipChar = character
		end

		for _, cachedNoclipPart in ipairs(tbl6.cachedNoclipParts) do
			cachedNoclipPart.CanCollide = false
		end
	end)

	local atmosphere = tbl.Lighting:FindFirstChildOfClass("Atmosphere")
	local remotes2 = tbl.ReplicatedStorage:FindFirstChild("Remotes")
	local attacks = remotes2 and remotes2:FindFirstChild("Attacks")

	tbl.Lighting.ChildAdded:Connect(function(child)
		if child:IsA("Atmosphere") then
			atmosphere = child
		end
	end)

	local _hbFrameCount = 0
	local _spamAccum = 0
	local _tbl16 = {}

	local function rebuildSurvivorList()
		table.clear(_tbl16)
		for player, cache in pairs(_playerCache) do
			if not cache.isKiller then table.insert(_tbl16, player) end
		end
	end

	rebuildSurvivorList()

	task.spawn(function()
		while not tbl6.Unloaded do
			task.wait(0.04)
			if not tbl3.ESP_Chroma then continue end
			tbl6.ChromaHue = (tbl6.ChromaHue + 3) % 360
			local c = Color3.fromHSV(tbl6.ChromaHue / 360, 1, 1)
			tbl7.Colors.SCP = c
			tbl7.Colors.Player = c
			tbl7.Colors.Killer = c
			tbl7.Colors.Generator = c
			tbl7.Colors.Pallet = c
			tbl7.Colors.Window = c
			tbl7.Colors.Hook = c
			tbl7.Colors.Gate = c
		end
	end)

	tbl.RunService.Heartbeat:Connect(function(deltaTime)
		if tbl6.Unloaded then return end

		_hbFrameCount = _hbFrameCount + 1
		local character = v
		local humanoid2 = humanoid
		local selfHrp = humanoidRootPart
		local currentRole = tbl6.cachedRole

		if tbl3.Killer_SpamHit and selfHrp and currentRole == "Killer" then
			_spamAccum = _spamAccum + deltaTime
			local spamDelay = math.max(0.15, (tbl3.Killer_SpamHitDelay or 100) / 1000)
			if _spamAccum >= spamDelay then
				_spamAccum = 0
				local v5 = attacks and attacks:FindFirstChild(tbl3.Killer_AttackMode)
				if v5 then
					local selfPos = selfHrp.Position
					local hitRadius = tbl3.Killer_SpamHitRadius
					for _, player in ipairs(_tbl16) do
						local cache = _playerCache[player]
						if not cache then continue end
						local hrp2 = cache.hrp
						local h3 = cache.humanoid
						local ch2 = cache.character
						if hrp2 and hrp2.Parent and h3 and h3.Health > 0 and ch2
							and not (ch2:GetAttribute("isHooked") or ch2:GetAttribute("IsHooked") or ch2:GetAttribute("Hooked"))
							and (selfPos - hrp2.Position).Magnitude <= hitRadius then
							pcall(function() v5:FireServer() end)
							break
						end
					end
				end
			end
		else
			_spamAccum = 0
		end

		if humanoid2 and character then
			if tbl3.Killer_WalkSpeedToggle and currentRole == "Killer" and tbl3.Killer_WalkSpeed > humanoid2.WalkSpeed and humanoid2.MoveDirection.Magnitude > 0 then
				character:TranslateBy(humanoid2.MoveDirection * (tbl3.Killer_WalkSpeed - humanoid2.WalkSpeed) * deltaTime)
			end

			if tbl3.Misc_HighJump and currentRole ~= "Killer" then
				humanoid2.UseJumpPower = true
				humanoid2.JumpPower = tbl3.Misc_JumpPower
			end

			if tbl3.Surv_GodMode and currentRole == "Survivor" then
				local knocked = character:GetAttribute("Knocked") == true
				if knocked or isKnockedOrHooked(humanoid2) then
					humanoid2.Health = humanoid2.MaxHealth
					if knocked then character:SetAttribute("Knocked", false) end
				end
			end

			if _hbFrameCount % 3 == 0 then
				if tbl3.Killer_BreakSpeed and currentRole == "Killer" then
					if character:GetAttribute("breakspeed") ~= tbl3.Killer_BreakSpeed then
						character:SetAttribute("breakspeed", tbl3.Killer_BreakSpeed)
					end
				end

				if currentRole ~= "Killer" then
					if tbl3.Surv_Perks then
						local vs = tbl3.Surv_VaultSpeed
						if character:GetAttribute("vaultspeed") ~= vs then
							character:SetAttribute("vaultspeed", vs)
						end
						local ss = tbl3.Surv_SkillSpeed
						if character:GetAttribute("skillcheckspeed") ~= ss then
							character:SetAttribute("skillcheckspeed", ss)
						end
					end
					if tbl3.Surv_FastVault then
						local flowTarget = not tbl6.FlowstateOnCD
						if character:GetAttribute("Flowstate") ~= flowTarget then
							character:SetAttribute("Flowstate", flowTarget)
						end
					elseif character:GetAttribute("Flowstate") == true then
						character:SetAttribute("Flowstate", false)
					end
				end
			end
		end

		if tbl3.ESP_Master and _hbFrameCount % 60 == 0 then
			scanItemESPs()
			renderSCPESP()
			if tbl3.ESP_HighestGen and tbl9.Generators then
				local maxProg = -1
				local bestModel = nil
				for _, gen in ipairs(tbl9.Generators) do
					local prog = gen.model:GetAttribute("RepairProgress") or 0
					if prog > maxProg and prog < 100 then
						maxProg = prog
						bestModel = gen.model
					end
				end
				tbl6.HighestGenModel = bestModel
			end
		end
	end)

	local function setupSpeedConn(arg)
		if not arg then
			return
		end
		tbl6.VaultBoostActive = false
		tbl6.QuickRecoveryOnCD = false

		if tbl6.VaultBoostThread then
			task.cancel(tbl6.VaultBoostThread)
			tbl6.VaultBoostThread = nil
		end

		if tbl6.TeamLabel then
			pcall(function()
				tbl6.TeamLabel:Set("Team: " .. str)
			end)
		end

		if str == "Killer" then
			local survivorFlags = {
				"AUTO_AutoSurvivor", "Surv_AutoSprint", "Surv_SelfHeal", "Surv_AuraHeal",
				"Surv_AutoParry", "Surv_Parry", "Surv_ParryV2", "Surv_AutoCrouch", "Surv_Bandage",
				"Surv_CrouchV", "Surv_Perks", "Surv_Spdb", "Surv_PerfectVault",
				"Surv_FastVault", "Surv_SpeedAfterVault", "Surv_AutoFleeToggle",
				"Surv_AutoSkillCheck", "Surv_GodMode", "Surv_NoFall", "Surv_SoundDbd",
				"AntiBlockWindowToggle", "Surv_AutoPalletToggle", "Surv_DoubleGenToggle",
				"AUTO_Generator", "Surv_Fov",
			}
			for _, flag in ipairs(survivorFlags) do
				if tbl3[flag] then
					tbl3[flag] = false
					if getgenv().Toggles and getgenv().Toggles[flag] then
						pcall(function() getgenv().Toggles[flag]:SetValue(false) end)
					end
				end
			end
			if tbl3.Misc_SmoothCam then
				tbl3.Misc_SmoothCam = false
				pcall(applySmoothCamera)
			end
			tbl.Camera.FieldOfView = 70
			if tbl6.FleeThread then task.cancel(tbl6.FleeThread) tbl6.FleeThread = nil end
			if tbl6.AutoSprintThread then task.cancel(tbl6.AutoSprintThread) tbl6.AutoSprintThread = nil end
			if tbl6.blockThread then task.cancel(tbl6.blockThread) tbl6.blockThread = nil end
			task.spawn(cancelAutoRepair)
		end

		if tbl6.SpeedConn then
			tbl6.SpeedConn:Disconnect()
			tbl6.SpeedConn = nil
		end

		if tbl6.cachedRole == "Survivor" and tbl3.Surv_Perks and tbl3.Surv_Spdb then
			arg:SetAttribute("speedboost", tbl3.Surv_SpeedBoost)
		end

		tbl6.SpeedConn = arg:GetAttributeChangedSignal("speedboost"):Connect(function()
			if tbl6.Unloaded or tbl6.cachedRole == "Killer" then
				return
			end
			local attribute = arg:GetAttribute("speedboost") or 1
			local survSpeedBoost = tbl3.Surv_SpeedBoost or 1.1

			if tbl3.Surv_SpeedAfterVault and tbl6.VaultBoostActive then
				if attribute ~= 1.4 then
					arg:SetAttribute("speedboost", 1.4)
				end

				return
			end

			if tbl3.Surv_Perks and tbl3.Surv_Spdb then
				if attribute == 1 then
					arg:SetAttribute("speedboost", survSpeedBoost)
				elseif attribute < 1 and tbl3.Surv_NoFall then
					arg:SetAttribute("speedboost", survSpeedBoost)
				end
			end
		end)
	end

	tbl.UserInputService.JumpRequest:Connect(function()
		if tbl3.Misc_InfJump and tbl.LocalPlayer.Character then
			local humanoid2 = tbl.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

			if humanoid2 then
				humanoid2:ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end
	end)

	tbl.LocalPlayer.CharacterRemoving:Connect(function()
		v = nil
		humanoidRootPart = nil
		humanoid = nil
	end)

	tbl.LocalPlayer.CharacterAdded:Connect(function(character)
		initCharacter(character)
		setupSpeedConn(character)
		setupAnimationHandler(character)
		applySmoothCamera()
		setupSpearStunTracking(tbl.LocalPlayer.Character)

		if connection then
			connection:Disconnect()
		end

		if connection2 then
			connection2:Disconnect()
		end

		if not tbl3.Killer_3rdPerson then
			if isPlayerKiller(tbl.LocalPlayer) then
				tbl.LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
				tbl.LocalPlayer.CameraMinZoomDistance = 0.5
				tbl.LocalPlayer.CameraMaxZoomDistance = 0.5
			else
				tbl.LocalPlayer.CameraMode = Enum.CameraMode.Classic
				tbl.LocalPlayer.CameraMinZoomDistance = 7
				tbl.LocalPlayer.CameraMaxZoomDistance = 128
			end
		end

		setupSkillCheckSync()
	end)

	tbl.LocalPlayer:GetPropertyChangedSignal("Team"):Connect(function()
		updateTeamRole()
		local character = tbl.LocalPlayer.Character

		if character then
			setupSpeedConn(character)
			setupAnimationHandler(character)
		end
	end)

	if tbl.LocalPlayer.Character then
		initCharacter(tbl.LocalPlayer.Character)
		setupSpeedConn(tbl.LocalPlayer.Character)
		setupAnimationHandler(tbl.LocalPlayer.Character)
		setupSkillCheckSync()
		setupSpearStunTracking(tbl.LocalPlayer.Character)
		applySkillSoundSwap(tbl.LocalPlayer.Character)
	end

	refreshMapData()
	updateSpectatorCount()
	updateTeamRole()

	task.spawn(function()
		local n4 = 0

		local connection4 = tbl.RunService.RenderStepped:Connect(function()
			n4 = n4 + 1
		end)

		local remotes3 = tbl.ReplicatedStorage:WaitForChild("Remotes", 5)
		remotes3 = remotes3 and remotes3:FindFirstChild("Healing")
		local healEvent = remotes3 and remotes3:FindFirstChild("HealEvent")
		local tbl19 = {}
		local n5 = 0

		while not tbl6.Unloaded do
			task.wait(1)
			local v4 = n4
			n4 = 0
			local n6 = 0

			pcall(function()
				n6 = math.round(tbl.Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
			end)

			tbl6.CurrentPing = n6 / 1000

			if textLabel then
				textLabel.Text = string.format("PerplexWare | %d FPS | %dms", v4, n6)

				if n6 < 80 then
					textLabel.TextColor3 = Color3.fromRGB(85, 255, 127)
				elseif n6 < 150 then
					textLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
				else
					textLabel.TextColor3 = Color3.fromRGB(255, 85, 85)
				end
			end

			renderAllESP()
			local tbl20 = {}
			local character = tbl.LocalPlayer.Character
			local humanoidRootPart2 = character and character:FindFirstChild("HumanoidRootPart")
			local humanoid2 = character and character:FindFirstChildOfClass("Humanoid")

			if character and humanoidRootPart2 and humanoid2 then
				local flag5 = tbl3.Surv_SelfHeal and humanoid2.Health > 0 and humanoid2.Health < 99
				local flag6 = false

				if flag5 then
					pcall(function()
						if healEvent then
							healEvent:FireServer(humanoidRootPart2, true)
						end
					end)

					flag6 = true
				end

				if tbl3.Surv_AuraHeal then
					for _, player in pairs(tbl.Players:GetPlayers()) do
						if player ~= tbl.LocalPlayer and isPlayerSurvivor(player) and player.Character then
							local humanoidRootPart3 = player.Character:FindFirstChild("HumanoidRootPart")
							local humanoid3 = player.Character:FindFirstChildOfClass("Humanoid")

							if humanoidRootPart3 and humanoid3 and humanoid3.Health > 0 and humanoid3.Health < 99 then
								if (humanoidRootPart2.Position - humanoidRootPart3.Position).Magnitude <= (tbl3.Surv_AuraHealRadius or 15) then
									tbl20[player] = humanoidRootPart3
									flag6 = true
								end
							end
						end
					end
				end

				for k, v5 in pairs(tbl19) do
					if not tbl20[k] then
						pcall(function()
							if healEvent then
								healEvent:FireServer(v5, false)
							end
						end)

						tbl19[k] = nil
					end
				end

				local n7 = 0

				for k, v5 in pairs(tbl20) do
					tbl19[k] = v5
					n7 = n7 + 1

					pcall(function()
						if healEvent then
							healEvent:FireServer(v5, true)
						end
					end)
				end

				if n7 == 0 and n5 > 0 and not flag6 then
					if humanoid2 then
						local animator = humanoid2:FindFirstChildOfClass("Animator")

						if animator then
							for _, v5 in pairs(animator:GetPlayingAnimationTracks()) do
								v5:Stop()
							end

							n5 = n7
						else
							n5 = n7
						end
					else
						n5 = n7
					end
				else
					n5 = n7
				end
			end
		end

		connection4:Disconnect()
	end)

	task.spawn(function()
		local remotes3 = game:GetService("ReplicatedStorage"):WaitForChild("Remotes", 10)
		remotes3 = remotes3 and remotes3:FindFirstChild("Mapinfo", true)

		if remotes3 and remotes3:IsA("RemoteEvent") then
			remotes3.OnClientEvent:Connect(function(arg)
				if arg and tbl3.Next_Map then
					pcall(function()
						if getgenv().Window then
							sendNotif("Next Map: " .. tostring(arg), 10, 18595195017)
						end
					end)
				end
			end)
		end
	end)
end

task.spawn(function()
	while not tbl6.Unloaded do
		task.wait(1)

		for _, player in ipairs(tbl.Players:GetPlayers()) do
			local character = player.Character

			if player ~= tbl.LocalPlayer and isPlayerKiller(player) and character then
				if not character:GetAttribute("StunEventAdded") then
					character:SetAttribute("StunEventAdded", true)

					character:GetAttributeChangedSignal("IsStunned"):Connect(function()
						if not tbl3.Show_Stun or tbl6.Unloaded then
							return
						end
						local humanoidRootPart2 = character:FindFirstChild("HumanoidRootPart")

						if character:GetAttribute("IsStunned") then
							if humanoidRootPart2 and not character:FindFirstChild("StunIn") then
								local sound = Instance.new("Sound", humanoidRootPart2)
								sound.Name = "StunHitSound"
								sound.Volume = 5
								sound.SoundId = "rbxassetid://140209514807090"
								sound:Play()

								sound.Ended:Connect(function()
									sound:Destroy()
								end)

								createBillboardESP(character, "StunIn", { name = "stunned", color = Color3.fromRGB(255, 255, 0), offsetY = 5.5 })
							end
						else
							if character:FindFirstChild("StunIn") then
								character.StunIn:Destroy()
							end

							if humanoidRootPart2 and humanoidRootPart2:FindFirstChild("StunHitSound") then
								humanoidRootPart2.StunHitSound:Destroy()
							end
						end
					end)
				end
			end
		end
	end
end)

task.spawn(function()
	local ok, result = pcall(function()
		return require(tbl.ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Survivors"):WaitForChild("SurvivorAnimationsController"))
	end)

	if not ok or not result then
		return
	end
	local isFacingStraightEnough = result._isFacingStraightEnough

	result._isFacingStraightEnough = function(arg, arg2, arg3, arg4)
		if tbl3.Surv_PerfectVault then
			arg.characterspeed = 20
			return true, 0
		end
		return isFacingStraightEnough(arg, arg2, arg3, arg4)
	end

	local onVaultAnimation = result._onVaultAnimation

	result._onVaultAnimation = function(arg, arg2, arg3)
		if tbl3.Surv_PerfectVault then
			return onVaultAnimation(arg, arg2, true)
		end
		return onVaultAnimation(arg, arg2, arg3)
	end

	local onSkillCheckFail = result._onSkillCheckFail

	result._onSkillCheckFail = function(arg, arg2, arg3)
		local v3 = onSkillCheckFail(arg, arg2, arg3)

		if tbl3.Surv_NoFall then
			arg.cantupdatespeed = false

			if arg.humanoidRootPart then
				arg.humanoidRootPart.Anchored = false
			end
		end

		return v3
	end
end)
