-- This file was generated at discord.gg/syncrypt

local unpack_ = unpack or table.unpack
local ok, value4 = pcall(function()
	local t2 = {
		value1 = getcustomasset or getsynasset
	}
	local queue_on_teleport_ = queue_on_teleport

	if not queue_on_teleport_ then
		queue_on_teleport_ = queueonteleport

		if not queue_on_teleport_ then
			queue_on_teleport_ = syn

			if type(queue_on_teleport_) == "table" then
				queue_on_teleport_ = syn.queue_on_teleport
			else
				queue_on_teleport_ = false
			end
		end
	end

	t2.value2 = queue_on_teleport_
	queue_on_teleport_ = setthreadidentity

	if not queue_on_teleport_ then
		queue_on_teleport_ = setidentity

		if not queue_on_teleport_ then
			queue_on_teleport_ = syn

			if type(queue_on_teleport_) == "table" then
				queue_on_teleport_ = syn.set_thread_identity
			else
				queue_on_teleport_ = false
			end
		end
	end

	t2.value3 = queue_on_teleport_
	queue_on_teleport_ = getthreadidentity

	if not queue_on_teleport_ then
		queue_on_teleport_ = getidentity

		if not queue_on_teleport_ then
			queue_on_teleport_ = syn

			if type(queue_on_teleport_) == "table" then
				queue_on_teleport_ = syn.get_thread_identity
			else
				queue_on_teleport_ = false
			end
		end
	end

	t2.value4 = nil
	t2.value4 = queue_on_teleport_

	function t2.value5(p1, ...)
		local v7 = nil
		local value4 = t2.value4
		local result

		if type(value4) == "function" then
			local ok

			ok, result = pcall(t2.value4)

			if not ok then
				result = v7
			end
		else
			result = v7
		end

		local value3 = t2.value3

		if type(value3) == "function" then
			pcall(t2.value3, 8)
		end

		local ok, result2 = pcall(p1, ...)
		local v14

		if result == nil then
			v14 = false
		else
			local value32 = t2.value3

			v14 = type(value32) == "function"
		end

		if not v14 then
			return ok, result2
		end

		pcall(t2.value3, result)

		return ok, result2
	end

	queue_on_teleport_ = getgenv
	t2.value6 = type(queue_on_teleport_) == "function" and getgenv() or _G
	t2.value6.CultCAAInitError = nil
	queue_on_teleport_ = t2.value6.CultCAA

	if queue_on_teleport_ then
		queue_on_teleport_ = t2.value6.CultCAA.Unload
		queue_on_teleport_ = type(queue_on_teleport_) == "function"
	end

	if queue_on_teleport_ then
		queue_on_teleport_, v15 = t2.value5(function()
			t2.value6.CultCAA:Unload()
		end)
		assert(queue_on_teleport_, v15)
	end

	local game_ = game

	t2.value7 = game_.GetService(game_, "Players")
	game_ = game:GetService("ReplicatedStorage")
	t2.value8 = game:GetService("RunService")
	t2.value9 = game:GetService("UserInputService")
	t2.value10 = game:GetService("Lighting")
	t2.value11 = game:GetService("HttpService")
	queue_on_teleport_ = game
	t2.value12 = queue_on_teleport_.GetService(queue_on_teleport_, "CollectionService")
	t2.value13 = game:GetService("PathfindingService")
	t2.value14 = game:GetService("TeleportService")
	t2.value15 = t2.value7.LocalPlayer
	queue_on_teleport_ = t2.value15
	assert(queue_on_teleport_, "cult requires a running Roblox client")
	queue_on_teleport_ = game.GameId == 10258991999
	assert(queue_on_teleport_, "cult: This version is for Command An Army")
	t2.value16 = game_:WaitForChild("Shared", 15)
	game_ = t2.value16
	assert(game_, "cult: Shared is missing")
	game_ = t2.value16
	t2.value17 = game_.WaitForChild(game_, "Remotes", 15)
	assert(t2.value17, "cult: Remotes are missing")
	t2.value18 = {
		Farm = false,
		AutoMatch = false,
		AutoFight = false,
		Aura = false,
		Lock = false,
		Supply = false,
		Retreat = false,
		Heal = false,
		Block = false,
		Orders = false,
		AutoSummon = false,
		AutoEquip = false,
		AutoAscend = false,
		AutoEvolve = false,
		Daily = false,
		Quests = false,
		AutoVolley = false,
		AutoCannon = false,
		AutoCatapult = false,
		PlayerESP = false,
		TroopESP = false,
		Allies = false,
		Speed = false,
		Fly = false,
		Noclip = false,
		InfiniteJump = false,
		BirdsEye = false,
		Fullbright = false,
		AntiAFK = true,
		Rejoin = false,
		Team = "Automatic",
		Priority = "Closest",
		TargetType = "All",
		Order = "Attack",
		Travel = "Pathfinding",
		Range = 7,
		SearchRange = 350,
		SpeedValue = 35,
		FlySpeed = 45,
		CameraHeight = 90,
		RetreatHP = 25,
		HealHP = 65,
		BlockRange = 9,
		SupplySlot = 1,
		SpawnSlot = 1,
		SummonCount = "1",
		KeepGems = 1000,
		RankedQueue = false,
		RankedRegion = "Auto",
		StaffDetector = false,
		Hitbox = false,
		HitboxSize = 8,
		PlayerStamina = false,
		HorseStamina = false,
		InfiniteRoll = false,
		AntiStun = false,
		SkipSummon = false,
		Stop4 = true,
		ProfileName = "Default",
		Profile = "Default",
		AutoRestore = true,
		VolleyRange = 180,
		CannonYaw = 0,
		CannonPitch = 10,
		Codes = ""
	}
	t2.value19 = {
		Alive = true,
		Config = t2.value18,
		Version = "0.2.3",
		Connections = {},
		Tasks = {},
		Deadlines = {},
		Log = {},
		Metrics = {
			attacks = 0,
			afkPulses = 0,
			movementDistance = 0,
			errors = 0
		},
		OriginalCollision = setmetatable({}, {
			__mode = "k"
		}),
		OriginalHumanoids = setmetatable({}, {
			__mode = "k"
		}),
		ESP = {},
		Pending = {},
		Session = t2.value11:GenerateGUID(false),
		NextAFK = os.clock() + 300,
		Font = "Roboto"
	}
	t2.value6.CultCAA = t2.value19
	t2.value20 = {
		bg = Color3.fromRGB(11, 10, 17),
		panel = Color3.fromRGB(20, 18, 29),
		line = Color3.fromRGB(45, 39, 59),
		text = Color3.fromRGB(242, 242, 245),
		muted = Color3.fromRGB(155, 148, 172),
		red = Color3.fromRGB(172, 115, 255),
		input = Color3.fromRGB(29, 25, 39)
	}
	t2.value21 = {
		regular = Font.fromEnum(Enum.Font.Roboto),
		bold = Font.fromEnum(Enum.Font.Roboto)
	}

	function t2.value22(p2)
		local Log = t2.value19.Log
		local v18 = os.date("%H:%M:%S") .. "  " .. tostring(p2)

		table.insert(Log, 1, v18)

		if #t2.value19.Log > 60 then
			table.remove(t2.value19.Log)
		end

		local function v19()
			local Status = t2.value19.Status

			if Status then
				Status = t2.value19.Status.Parent
			end

			if not Status then
				return
			end

			local v21 = p2

			t2.value19.Status.Text = tostring(v21)
		end

		pcall(v19)
	end

	local function v22(p3, p4)
		if not t2.value19.Alive or t2.value19.Pending[p3] then
			return
		end

		t2.value19.Pending[p3] = true

		local v23 = nil

		v23 = task.defer(function()
			local ok, result = xpcall(p4, debug.traceback)

			t2.value19.Pending[p3] = nil
			t2.value19.Tasks[v23] = nil

			local v26 = not ok

			if v26 then
				v26 = t2.value19.Alive
			end

			if not v26 then
				return
			end

			t2.value19.Metrics.errors = t2.value19.Metrics.errors + 1

			local v27 = p3

			t2.value22(tostring(v27) .. ": " .. tostring(result):sub(1, 150))
		end)
		t2.value19.Tasks[v23] = true

		return v23
	end

	game_ = function(p5, p6)
		local connection = p5:Connect(function(...)
			if not t2.value19.Alive then
				return
			end

			local v29, v30 = t2.value5(p6, ...)

			if v29 then
				return
			end

			t2.value19.Metrics.errors = t2.value19.Metrics.errors + 1
			t2.value22(tostring(v30):sub(1, 140))
		end)

		table.insert(t2.value19.Connections, connection)

		return connection
	end

	function t2.value23(p7)
		local v31 = t2.value17:FindFirstChild(p7)
		local v32 = "Missing remote: " .. p7

		assert(v31, v32)

		return v31
	end

	local function v33(p8, ...)
		if t2.value19.Alive then
			local v34 = t2.value23(p8)
			local isRemoteEvent = v34:IsA("RemoteEvent") or v34:IsA("UnreliableRemoteEvent")
			local v36 = p8 .. " is not an event"

			assert(isRemoteEvent, v36)
			v34:FireServer(...)

			return true
		else
			return false
		end
	end

	function t2.value24(p9, p10)
		if not t2.value19.Alive then
			return
		end

		local v37 = t2.value23(p9)
		local isRemoteFunction = v37:IsA("RemoteFunction")
		local v39 = p9 .. " is not a RemoteFunction"

		assert(isRemoteFunction, v39)

		local u40 = false
		local u41 = nil
		local u42 = nil
		local thread = task.spawn(function()
			local function v44()
				return v37:InvokeServer(p10)
			end

			local ok, result = pcall(v44)

			if ok then
				u41 = result
			else
				u42 = result
			end

			u40 = true
		end)

		t2.value19.Tasks[thread] = true

		local v47 = os.clock() + 10
		local v48 = u41
		local v49 = u42
		local v50 = u40

		while true do
			local v51 = t2.value19.Alive and not v50

			if v51 then
				v51 = os.clock() < v47
			end

			if not v51 then
				break
			end

			task.wait(0.05)
		end

		t2.value19.Tasks[thread] = nil

		if not v50 then
			pcall(task.cancel, thread)
			error(p9 .. ": response timeout")
		end

		if not v49 then
			return v48
		end

		error(v49)

		return v48
	end

	local function v52(p11, p12)
		local attribute = p11:GetAttribute(p12)

		if type(attribute) == "string" then
			local ok, result = pcall(t2.value11.JSONDecode, t2.value11, attribute)

			if ok then
				if type(result) == "table" then
					return result or {}
				end

				result = false
			else
				result = ok
			end

			return result or {}
		else
			return {}
		end
	end
	local function v56()
		local Character = t2.value15.Character
		local Humanoid

		if Character then
			Humanoid = Character:FindFirstChildOfClass("Humanoid")
		else
			Humanoid = Character
		end

		local HumanoidRootPart

		if Character then
			HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
		else
			HumanoidRootPart = Character
		end

		return Character, Humanoid, HumanoidRootPart
	end
	local function v60(p13)
		if not p13 then
			return
		end

		if p13:IsA("BasePart") then
			return p13
		end

		local isModel = p13:IsA("Model")

		if isModel then
		elseif isModel then
			return p13.PrimaryPart
		else
			return p13:FindFirstChild("HumanoidRootPart") or (p13:FindFirstChild("RootPart") or p13:FindFirstChildWhichIsA("BasePart", true))
		end

		isModel = p13.PrimaryPart

		if isModel then
			return p13.PrimaryPart
		else
			return p13:FindFirstChild("HumanoidRootPart") or (p13:FindFirstChild("RootPart") or p13:FindFirstChildWhichIsA("BasePart", true))
		end
	end
	local function v62(p14)
		if p14:GetAttribute("MotionMaxHealth") == nil then
			local Humanoid = p14:FindFirstChildOfClass("Humanoid")

			if Humanoid then
				return Humanoid.Health, Humanoid.MaxHealth
			else
				return p14:GetAttribute("Dead") == true and 0 or 1, 1
			end
		else
			return tonumber(p14:GetAttribute("MotionHealth")) or 0, tonumber(p14:GetAttribute("MotionMaxHealth")) or 1
		end
	end
	local function v64()
		local Troops = workspace:FindFirstChild("Troops")

		if Troops then
			for _, child in ipairs(Troops:GetChildren()) do
				local Name = child.Name
				local UserId = t2.value15.UserId
				local v70

				if Name == tostring(UserId) then
					v70 = child:GetAttribute("DetachedRetreat") ~= true
				else
					v70 = false
				end

				if v70 then
					return child
				end
			end
		end
	end
	local function v71(p15)
		if p15 then
			local GetChildren = p15.GetChildren
			local ipairs_ = ipairs

			for _, v in ipairs_(GetChildren(p15)) do
				local isModel = v:IsA("Model")

				if isModel then
					isModel = v:GetAttribute("ClientVisualProxy") ~= true

					if isModel then
						isModel = v60(v)

						if isModel then
							isModel = v62(v) > 0
						end
					end
				end

				if isModel then
					return v
				end
			end
		end
	end

	function t2.value25()
		local v77

		if t2.value15:GetAttribute("MatchState") == "Game" then
			v77 = t2.value15:GetAttribute("IsDead") ~= true
		else
			v77 = false
		end

		return v77
	end

	local function v78(p16)
		local v79 = p16

		while true do
			if true then
				local v80

				if p16 then
					v80 = p16 ~= t2.value15.PlayerGui
				else
					v80 = p16
				end
			end

			if not v91 then
				if not v79 then
					return v79
				end

				v79 = v79:IsDescendantOf(t2.value15.PlayerGui)

				return v79
			end

			local isGuiObject = p16:IsA("GuiObject")

			if isGuiObject then
				isGuiObject = not p16.Visible
			end

			if isGuiObject then
				return false
			end

			local isScreenGui = p16:IsA("ScreenGui")

			if isScreenGui then
				isScreenGui = not p16.Enabled
			end

			if isScreenGui then
				return false
			end

			p16 = p16.Parent
		end
	end
	local function v83(p17)
		if p17 and (p17:IsA("GuiButton") and v78(p17)) then
			local getconnections_ = getconnections
			local firesignal_

			if type(getconnections_) == "function" then
				local v86 = false

				for _, v in ipairs(getconnections(p17.Activated)) do
					local v89

					if v.Enabled == false then
						v89 = false
					else
						local Fire = v.Fire

						v89 = type(Fire) == "function"
					end

					if v89 then
						v:Fire()
						v86 = true
					end
				end

				if v86 then
					return true
				else
					firesignal_ = firesignal

					if type(firesignal_) == "function" then
						firesignal(p17.Activated)

						return true
					else
						return false
					end
				end
			else
				firesignal_ = firesignal

				if type(firesignal_) == "function" then
					firesignal(p17.Activated)

					return true
				else
					return false
				end
			end
		else
			return false
		end
	end
	local function v92(...)
		local value15 = t2.value15
		local v93 = value15.FindFirstChild(value15, "PlayerGui")

		for _, v in ipairs({ ... }) do
			if v93 then
				v93 = v93:FindFirstChild(v)
			end
		end

		return v93
	end
	local function v96()
		for k, v in pairs(t2.value19.OriginalCollision) do
			if k.Parent then
				pcall(function()
					k.CanCollide = v
				end)
			end

			t2.value19.OriginalCollision[k] = nil
		end
	end
	local function v99()
		for k, originalHumanoid in pairs(t2.value19.OriginalHumanoids) do
			if k.Parent then
				pcall(function()
					k.WalkSpeed = originalHumanoid.speed
					k.PlatformStand = originalHumanoid.stand
					k.AutoRotate = originalHumanoid.rotate
				end)
			end

			t2.value19.OriginalHumanoids[k] = nil
		end
	end
	local function v102()
		t2.value19.PathGeneration = (t2.value19.PathGeneration or 0) + 1
		t2.value19.Waypoints = nil
		t2.value19.WaypointIndex = nil
		t2.value19.PathGoal = nil
		t2.value19.NavigationGoal = nil
		t2.value19.MovingUntil = 0

		local Character = t2.value15.Character
		local Humanoid

		if Character then
			Humanoid = Character:FindFirstChildOfClass("Humanoid")
		else
			Humanoid = Character
		end

		if Character then
			Character = Character:FindFirstChild("HumanoidRootPart")
		end

		if not (Humanoid and Character) then
			return
		end

		Humanoid:MoveTo(Character.Position)
		Humanoid:Move(Vector3.zero, false)
	end

	function t2.value19.Set(p18, p19, p20)
		local assert_ = assert

		assert_(t2.value18[p19] ~= nil, "Unknown setting: " .. tostring(p19))

		local kind = type(p20)
		local v107 = t2.value18[p19]

		if kind ~= type(v107) then
			return
		end

		local v108 = type(p20) == "number"

		if v108 then
			v108 = p20 ~= p20 or math.abs(p20) == math.huge
		end

		if v108 then
			return
		end

		local Validation = p18.Validation

		if Validation then
			Validation = p18.Validation[p19]
		end

		local min

		if Validation then
			min = Validation.min
		else
			min = Validation
		end

		if min then
			local min2 = Validation.min
			local max = Validation.max
			local v113 = (math.clamp(p20, min2, max) - Validation.min) / Validation.step + 0.5

			assert_ = math.floor(v113) * Validation.step + Validation.min
			p20 = assert_
		end

		local options

		if Validation then
			options = Validation.options

			if options then
				options = p19 ~= "Profile"

				if options then
					if p19 == "RankedRegion" then
						options = false
					else
						options = not table.find(Validation.options, p20)
					end
				end
			end
		else
			options = Validation
		end

		if options then
			return
		end

		if p19 == "ProfileName" then
			p20 = p20:gsub("[%c]", ""):sub(1, 48)
		end

		if (p19 == "PlayerStamina" or (p19 == "HorseStamina" or (p19 == "InfiniteRoll" or p19 == "SkipSummon"))) and p20 then
			if p18.ResolveClients then
				pcall(p18.ResolveClients)
			end

			local v115 = p19 == "PlayerStamina" and true or (p19 == "HorseStamina" and "Stamina" or false) or (p19 == "InfiniteRoll" and "Roll" or false or "Summon")

			if not (p18.Clients and p18.Clients[v115]) then
				t2.value22(p19 .. ": client controller unavailable in this executor")

				return
			end
		end

		t2.value18[p19] = p20

		if not p18.RestoringProfile then
			p18.ProfileDirty = true
		end

		local v116 = p19 == "Hitbox" and not p20

		if v116 then
			v116 = p18.RestoreHitboxes
		end

		if v116 then
			p18.RestoreHitboxes()
		end

		if p19 == "Fly" then
			p18.FlyVertical = 0

			if p18.UI then
				local FlyPad = p18.UI.FlyPad
				local TouchLayout

				if p20 then
					TouchLayout = p18.TouchLayout
				else
					TouchLayout = p20
				end

				FlyPad.Visible = TouchLayout
			end
		end

		local v119 = p19 == "Speed"

		if v119 then
			if p20 then
				v119 = p18.Clients

				if v119 then
					v119 = p18.Clients.Stamina
				end
			else
				v119 = p20
			end
		end

		if v119 then
			p18.SpeedBase = p18.SpeedBase or p18.Clients.Stamina._baseWalkSpeed
			p18.Clients.Stamina._baseWalkSpeed = t2.value18.SpeedValue
		end

		local v120 = p19 == "Speed"

		if v120 then
			v120 = not p20

			if v120 then
				v120 = p18.SpeedBase

				if v120 then
					v120 = p18.Clients

					if v120 then
						v120 = p18.Clients.Stamina
					end
				end
			end
		end

		if v120 then
			p18.Clients.Stamina._baseWalkSpeed = p18.SpeedBase
			p18.SpeedBase = nil
		end

		local v121 = p19 == "SpeedValue"

		if v121 then
			v121 = t2.value18.Speed

			if v121 then
				v121 = p18.Clients

				if v121 then
					v121 = p18.Clients.Stamina
				end
			end
		end

		if v121 then
			p18.Clients.Stamina._baseWalkSpeed = p20
		end

		if p19 == "AntiAFK" then
			p18.NextAFK = os.clock() + 300
			p18.AFKEpisode = nil
		end

		local v122

		if p19 == "Noclip" then
			v122 = not p20
		else
			v122 = false
		end

		if v122 then
			v96()
		end

		local v123 = p19 == "Speed" and true or p19 == "Fly"

		if v123 then
			v123 = not t2.value18.Speed

			if v123 then
				v123 = not t2.value18.Fly
			end
		end

		if v123 then
			v99()
		end

		local v124

		if p19 == "BirdsEye" then
			v124 = not p20
		else
			v124 = false
		end

		if v124 then
			local CameraSave = t2.value19.CameraSave
			local Parent

			if CameraSave then
				Parent = CameraSave.camera.Parent
			else
				Parent = CameraSave
			end

			if Parent then
				CameraSave.camera.CameraType = CameraSave.type
				CameraSave.camera.CameraSubject = CameraSave.subject
				CameraSave.camera.CFrame = CameraSave.cframe
				CameraSave.camera.FieldOfView = CameraSave.fov
			end

			t2.value19.CameraSave = nil
		end

		local v127

		if p19 == "Fullbright" then
			v127 = not p20
		else
			v127 = false
		end

		if v127 and t2.value19.LightSave then
			for k, v in pairs(t2.value19.LightSave) do
				t2.value10[k] = v
			end

			t2.value19.LightSave = nil
		end

		local v130 = p19 == "Block"

		if v130 then
			v130 = not p20

			if v130 then
				v130 = p18.Blocking
			end
		end

		if v130 then
			v33("PlayerCombatRequest", "Block", false)
			p18.Blocking = false
		end

		local v131 = p19 == "AutoFight" or (p19 == "Farm" and true or p19 == "Supply")

		if v131 then
			v131 = not p20
		end

		if v131 then
			v102()
		end

		if not p18.RefreshControl then
			return
		end

		p18.RefreshControl(p19)
	end
	function t2.value19.Unload(p21)
		if not p21.Alive then
			return
		end

		if p21.FlushProfiles then
			pcall(p21.FlushProfiles)
		end

		p21.Alive = false

		if p21.CloseDropdown then
			p21.CloseDropdown()
		end

		for _, v in ipairs(p21.PageConnections or {}) do
			v:Disconnect()
		end

		local pairs_ = pairs
		local v135, v136, v137 = pairs_(p21.Tweens or {})

		while true do
			local v138

			v137, v138 = v135(v136, v137)

			if not v137 then
				break
			end

			pairs_ = pcall
			pairs_(function()
				v138:Cancel()
			end)
		end

		if p21.RestoreHitboxes then
			pairs_ = p21.RestoreHitboxes
			pairs_()
		end

		local SpeedBase = p21.SpeedBase

		if SpeedBase then
			SpeedBase = p21.Clients

			if SpeedBase then
				SpeedBase = p21.Clients.Stamina
			end
		end

		if SpeedBase then
			p21.Clients.Stamina._baseWalkSpeed = p21.SpeedBase
		end

		local function v140()
			local JoinPickerOwned = p21.JoinPickerOwned

			if JoinPickerOwned then
				JoinPickerOwned = p21.Clients

				if JoinPickerOwned then
					JoinPickerOwned = p21.Clients.PickTeam
				end
			end

			if JoinPickerOwned then
				p21.Clients.PickTeam:_close(true)
			end

			if p21.Blocking then
				t2.value23("PlayerCombatRequest"):FireServer("Block", false)
			end

			if p21.VolleyStarted then
				t2.value23("AimVolleyState"):FireServer(false)
			end

			if p21.CatapultStarted then
				t2.value16.Catapult.Remotes.TargetingState:FireServer(false)
			end

			if not p21.SupplyStarted then
				return
			end

			t2.value23("SupplyPointRequest"):FireServer("Cancel")
			t2.value23("SupplyPointRequest"):FireServer("Close")
		end

		pcall(v140)
		t2.value8:UnbindFromRenderStep("CultCAA_Render")

		local v142, v143, v144 = ipairs(p21.Connections)

		while true do
			local v145

			v144, v145 = v142(v143, v144)

			if not v144 then
				break
			end

			v145:Disconnect()
		end

		for k in pairs(p21.Tasks) do
			if k ~= coroutine.running() then
				pcall(task.cancel, k)
			end
		end

		v102()
		v96()
		v99()

		local CameraSave = t2.value19.CameraSave
		local Parent

		if CameraSave then
			Parent = CameraSave.camera.Parent
		else
			Parent = CameraSave
		end

		if Parent then
			CameraSave.camera.CameraType = CameraSave.type
			CameraSave.camera.CameraSubject = CameraSave.subject
			CameraSave.camera.CFrame = CameraSave.cframe
			CameraSave.camera.FieldOfView = CameraSave.fov
		end

		t2.value19.CameraSave = nil

		if not t2.value19.LightSave then
			for _, v in pairs(p21.ESP) do
				for _, v2 in ipairs(v) do
					v2:Destroy()
				end
			end

			if p21.Gui then
				p21.Gui:Destroy()
			end

			v171 = writefile

			if type(v171) == "function" then
				pcall(writefile, "cult-caa-teleport.json", t2.value11:JSONEncode({
					Active = false
				}))
			end

			if t2.value6.CultCAA ~= p21 then
				return
			end

			t2.value6.CultCAA = nil

			return
		end

		for k, v in pairs(t2.value19.LightSave) do
			t2.value10[k] = v
		end

		t2.value19.LightSave = nil

		for _, v in pairs(p21.ESP) do
			for _, v2 in ipairs(v) do
				v2:Destroy()
			end
		end

		if p21.Gui then
			p21.Gui:Destroy()
		end

		local writefile_ = writefile

		if type(writefile_) == "function" then
			pcall(writefile, "cult-caa-teleport.json", t2.value11:JSONEncode({
				Active = false
			}))
		end

		if t2.value6.CultCAA ~= p21 then
			return
		end

		t2.value6.CultCAA = nil
	end

	local parent

	queue_on_teleport_, parent = pcall(function()
		local value1 = t2.value1
		local v162

		if type(value1) == "function" then
			local writefile_ = writefile

			if type(writefile_) == "function" then
				local readfile_ = readfile

				v162 = type(readfile_) ~= "function"
			else
				v162 = true
			end
		else
			v162 = true
		end

		if v162 then
			return
		end

		local s1 = "cult-caa-fonts"
		local makefolder_ = makefolder

		if type(makefolder_) == "function" then
			pcall(makefolder, s1)
		end

		local t3 = {}

		for _, v in ipairs({
			{ "Regular", 400 },
			{ "SemiBold", 600 },
			{ "Bold", 700 }
		}) do
			local v170 = s1 .. "/Archivo-" .. v[1] .. ".ttf"
			local ok, result = pcall(readfile, v170)

			if not ok or #result < 1000 then
				local response = game:HttpGet("https://raw.githubusercontent.com/Omnibus-Type/Archivo/211127690e8ff106c36c935f7e5e697114cff103/fonts/ttf/Archivo-" .. v[1] .. ".ttf")
				local v174 = #response > 1000

				assert(v174, "Archivo download incomplete")
				writefile(v170, response)
			end

			table.insert(t3, {
				name = v[1],
				weight = v[2],
				style = "normal",
				assetId = t2.value1(v170)
			})
		end

		local v175 = s1 .. "/Archivo.json"

		writefile(v175, t2.value11:JSONEncode({
			name = "Archivo",
			faces = t3
		}))

		local v176 = t2.value1(v175)
		local font = Font.new(v176, Enum.FontWeight.Regular)
		local GetTextBoundsParams = Instance.new("GetTextBoundsParams")

		GetTextBoundsParams.Font = font
		GetTextBoundsParams.Size = 14
		GetTextBoundsParams.Width = 500
		GetTextBoundsParams.Text = "cult Command An Army"

		local ok, result = pcall(function()
			return game:GetService("TextService"):GetTextBoundsAsync(GetTextBoundsParams)
		end)

		GetTextBoundsParams:Destroy()

		local assert_ = assert

		if not ok then
			assert_(ok, "Archivo font validation failed")
			t2.value21.regular = font
			t2.value21.bold = Font.new(v176, Enum.FontWeight.Bold)
			t2.value19.Font = "Archivo"

			return
		end

		ok = result.X > 0
		assert_(ok, "Archivo font validation failed")
		t2.value21.regular = font
		t2.value21.bold = Font.new(v176, Enum.FontWeight.Bold)
		t2.value19.Font = "Archivo"
	end)

	if not t2.value19.Alive then
		return nil
	end

	if not queue_on_teleport_ then
		t2.value22("Font: " .. tostring(parent):sub(1, 90))
	end

	parent = game

	local t4 = {
		value1 = parent.GetService(parent, "TweenService")
	}

	function t4.value2(p22, p23, p24)
		local instance = Instance.new(p22)

		if not (p22 == "TextLabel" or (p22 == "TextButton" and true or p22 == "TextBox")) then
			for k, v in pairs(p23) do
				instance[k] = v
			end

			instance.Parent = p24

			return instance
		end

		instance.FontFace = t2.value21.regular

		for k, v in pairs(p23) do
			instance[k] = v
		end

		instance.Parent = p24

		return instance
	end

	local function v188(p25, p26)
		t4.value2("UICorner", {
			CornerRadius = UDim.new(0, p26 or 10)
		}, p25)
	end
	local function v189(p27, p28, p29, p30, p31)
		local value2 = t4.value2
		local text = p30 or t2.value20.text
		local v192 = p29 or 14

		if not p31 then
			return value2("TextLabel", {
				BackgroundTransparency = 1,
				Text = p28,
				TextColor3 = text,
				TextSize = v192,
				FontFace = p31 or t2.value21.regular,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextTruncate = Enum.TextTruncate.AtEnd
			}, p27)
		end

		p31 = t2.value21.bold

		return value2("TextLabel", {
			BackgroundTransparency = 1,
			Text = p28,
			TextColor3 = text,
			TextSize = v192,
			FontFace = p31 or t2.value21.regular,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd
		}, p27)
	end

	t2.value19.Tweens = setmetatable({}, {
		__mode = "k"
	})
	t4.value3 = t4.value2("ScreenGui", {
		Name = "cult_CommandAnArmy",
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		DisplayOrder = 900,
		IgnoreGuiInset = true
	}, nil)
	t2.value19.Gui = t4.value3
	parent = t2.value15
	parent = parent.WaitForChild(parent, "PlayerGui")
	t4.value3.Parent = parent
	t4.value4 = t4.value2("CanvasGroup", {
		Name = "Window",
		BackgroundColor3 = t2.value20.bg,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(960, 620),
		Active = true,
		GroupTransparency = 1
	}, t4.value3)
	parent = t4.value4
	t4.value2("UICorner", {
		CornerRadius = UDim.new(0, 10)
	}, parent)
	parent = t4.value4
	t4.value2("UIStroke", {
		Color = t2.value20.line,
		Thickness = 1,
		Transparency = 0.82
	}, parent)
	t4.value5 = t4.value2("UIScale", {
		Scale = 0.97
	}, t4.value4)
	t4.value6 = t4.value2("Frame", {
		Name = "Sidebar",
		BackgroundColor3 = Color3.fromRGB(13, 12, 20),
		BorderSizePixel = 0,
		Size = UDim2.new(0, 170, 1, 0)
	}, t4.value4)
	parent = t4.value6
	t4.value2("UICorner", {
		CornerRadius = UDim.new(0, 10)
	}, parent)
	parent = t4.value2("ImageButton", {
		Name = "Logo",
		Image = "rbxassetid://89393971868630",
		ScaleType = Enum.ScaleType.Fit,
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(20, 12),
		Size = UDim2.fromOffset(64, 54),
		AutoButtonColor = false
	}, t4.value6)
	t4.value2("Frame", {
		BackgroundColor3 = t2.value20.red,
		BackgroundTransparency = 0.88,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(18, 72),
		Size = UDim2.new(1, -36, 0, 1)
	}, t4.value6)
	t4.value7 = t4.value2("ScrollingFrame", {
		Name = "Navigation",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(12, 84),
		Size = UDim2.new(1, -24, 1, -96),
		ScrollBarThickness = 2,
		ScrollBarImageColor3 = t2.value20.red,
		CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y
	}, t4.value6)
	t4.value2("UIListLayout", {
		Padding = UDim.new(0, 2),
		SortOrder = Enum.SortOrder.LayoutOrder
	}, t4.value7)
	t4.value8 = t4.value2("ImageButton", {
		Name = "Open",
		Image = "rbxassetid://89393971868630",
		ScaleType = Enum.ScaleType.Fit,
		AutoButtonColor = false,
		BackgroundColor3 = t2.value20.panel,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(14, 90),
		Size = UDim2.fromOffset(56, 56),
		Visible = false
	}, t4.value3)
	queue_on_teleport_ = t4.value8
	t4.value2("UICorner", {
		CornerRadius = UDim.new(0, 16 or 10)
	}, queue_on_teleport_)
	queue_on_teleport_ = t4.value8
	t4.value2("UIStroke", {
		Color = t2.value20.line,
		Thickness = 1,
		Transparency = 0.82
	}, queue_on_teleport_)
	t4.value2("UIPadding", {
		PaddingTop = UDim.new(0, 8),
		PaddingBottom = UDim.new(0, 8),
		PaddingLeft = UDim.new(0, 8),
		PaddingRight = UDim.new(0, 8)
	}, t4.value8)
	t4.value9 = t4.value2("Frame", {
		Name = "Header",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(190, 16),
		Size = UDim2.new(1, -210, 0, 58),
		Active = true
	}, t4.value4)
	t4.value10 = v189(t4.value9, "Auto Farm", 21, t2.value20.text, true)
	t4.value10.Position = UDim2.fromOffset(0, 3)
	t4.value10.Size = UDim2.new(1, -145, 0, 30)
	queue_on_teleport_ = function(p32, p33)
		local TextButton = t4.value2("TextButton", {
			Text = p32,
			FontFace = t2.value21.bold,
			TextColor3 = t2.value20.muted,
			TextSize = 17,
			BackgroundTransparency = 1,
			BackgroundColor3 = t2.value20.input,
			BorderSizePixel = 0,
			AutoButtonColor = false,
			Position = UDim2.new(1, p33, 0, 6),
			Size = UDim2.fromOffset(42, 42)
		}, t4.value9)

		v188(TextButton, 5)

		return TextButton
	end

	local getgc_ = queue_on_teleport_("", -92)
	local value2 = queue_on_teleport_("", -44)

	t4.value11 = queue_on_teleport_("", -140)
	t4.value11.Name = "Pages"
	t4.value11.Visible = false
	t4.value2("Frame", {
		BackgroundColor3 = t2.value20.muted,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(14, 21),
		Size = UDim2.fromOffset(14, 2)
	}, getgc_)

	local v196, v197

	queue_on_teleport_, v196, v197 = ipairs({ 45, -45 })

	local layoutOrder = "rbxassetid://89393971868630"

	local function v199(p34, p35, p36)
		if not t2.value19.Tweens[p34] then
			v225 = t4.value1:Create(p34, TweenInfo.new(p36 or 0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), p35)
			t2.value19.Tweens[p34] = v225
			v225:Play()

			return v225
		end

		t2.value19.Tweens[p34]:Cancel()

		local tween = t4.value1:Create(p34, TweenInfo.new(p36 or 0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), p35)

		t2.value19.Tweens[p34] = tween
		tween:Play()

		return tween
	end

	while true do
		v197, v1080 = queue_on_teleport_(v196, v197)

		if not v197 then
			break
		end

		t4.value2("Frame", {
			BackgroundColor3 = t2.value20.muted,
			BorderSizePixel = 0,
			Rotation = v1080,
			Position = UDim2.fromOffset(14, 20),
			Size = UDim2.fromOffset(14, 2)
		}, value2)
	end

	for _, v in ipairs({ 15, 21, 27 }) do
		t4.value2("Frame", {
			BackgroundColor3 = t2.value20.muted,
			BorderSizePixel = 0,
			Position = UDim2.fromOffset(14, v),
			Size = UDim2.fromOffset(14, 2)
		}, t4.value11)
	end

	t4.value12 = t4.value2("ImageButton", {
		Name = "CompactLogo",
		Image = layoutOrder,
		ScaleType = Enum.ScaleType.Fit,
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(0, 6),
		Size = UDim2.fromOffset(42, 42),
		Visible = false
	}, t4.value9)
	t4.value13 = t4.value2("ScrollingFrame", {
		Name = "Content",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(190, 86),
		Size = UDim2.new(1, -210, 1, -124),
		ScrollBarThickness = 3,
		ScrollBarImageColor3 = t2.value20.red,
		CanvasSize = UDim2.new(),
		ScrollingDirection = Enum.ScrollingDirection.Y
	}, t4.value4)
	t4.value14 = v189(t4.value4, "", 10, t2.value20.muted)
	t4.value14.Visible = false
	t2.value19.Status = t4.value14
	t4.value14.Position = UDim2.new(0, 190, 1, -27)
	t4.value14.Size = UDim2.new(1, -210, 0, 18)
	t4.value15 = {}
	t4.value16 = {}
	t4.value17 = {}
	t4.value18 = {}
	t4.value19 = nil
	t4.value20 = {}
	t2.value19.PageConnections = t4.value18
	t2.value19.Validation = {}

	local function v203(p37, p38)
		return {
			kind = "toggle",
			key = p37,
			text = p38
		}
	end

	layoutOrder = function(p39, p40, p41, p42, p43)
		t2.value19.Validation[p39] = {
			min = p41,
			max = p42,
			step = p43 or 1
		}

		return {
			kind = "number",
			key = p39,
			text = p40,
			min = p41,
			max = p42,
			step = p43 or 1
		}
	end
	v197 = function(p44, p45, p46)
		t2.value19.Validation[p44] = {
			options = p46
		}

		return {
			kind = "select",
			key = p44,
			text = p45,
			options = p46
		}
	end
	v196 = function(p47, p48)
		return {
			kind = "action",
			key = p47,
			text = p48
		}
	end
	queue_on_teleport_ = function(p49, p50)
		return {
			kind = "text",
			key = p49,
			text = p50
		}
	end

	local function v204(p51, p52, p53, p54, p55, p56)
		t4.value15[p51] = {
			sub = p52,
			leftTitle = p53,
			left = p54,
			rightTitle = p55,
			right = p56
		}
	end

	v204("Auto Farm", "Round automation", "Automation", {
		v203("Farm", "AFK Auto Farm"),
		v203("AutoMatch", "Auto Match"),
		v203("AutoFight", "Auto Fight"),
		v203("Supply", "Auto Supply"),
		v203("Rejoin", "Rejoin After Match"),
		v203("AntiAFK", "Anti-AFK")
	}, "Preferences", {
		v197("Team", "Preferred Team", { "Automatic", "Attackers", "Defenders" }),
		layoutOrder("SpawnSlot", "Respawn Slot", 1, 5),
		layoutOrder("SearchRange", "Search Radius", 30, 600, 10),
		v196("afkNow", "Test AFK Movement")
	})
	v204("Auto Match", "Teams and respawning", "Match", {
		v203("AutoMatch", "Auto Join Matches"),
		v197("Team", "Preferred Team", { "Automatic", "Attackers", "Defenders" }),
		layoutOrder("SpawnSlot", "Respawn Slot", 1, 5),
		v196("join", "Join Match"),
		v196("respawn", "Respawn Troops")
	}, "Queue", {
		v203("RankedQueue", "Auto Ranked Queue"),
		v197("RankedRegion", "Ranked Region", { "Auto" }),
		v196("ranked", "Join Ranked Queue"),
		v196("rankedCancel", "Leave Ranked Queue"),
		v203("Rejoin", "Rejoin After Match")
	})

	local t5 = {
		v203("AutoFight", "Auto Fight"),
		v203("Aura", "Kill Aura"),
		v203("Lock", "Target Lock"),
		layoutOrder("Range", "Aura Radius", 1, 40),
		layoutOrder("SearchRange", "Search Radius", 30, 600, 10)
	}
	local Priority = v197("Priority", "Priority", {
		"Closest",
		"Lowest HP",
		"Players",
		"Troops",
		"Largest Army"
	})
	local Travel = v197("Travel", "Travel Mode", { "Pathfinding", "Direct" })

	v204("Auto Fight", "Combat automation", "Combat", t5, "Targeting", {
		Priority,
		v197("TargetType", "Target Type", { "All", "Players", "Troops" }),
		Travel,
		v203("Hitbox", "Hitbox Expander"),
		layoutOrder("HitboxSize", "Hitbox Size", 2, 20),
		v196("clearTarget", "Release Target")
	})
	Travel = v197("Priority", "Priority", {
		"Closest",
		"Lowest HP",
		"Players",
		"Troops",
		"Largest Army"
	})
	v204("Target Lock", "Focus and priority", "Targeting", {
		v203("Lock", "Target Lock"),
		Travel,
		v197("TargetType", "Target Type", { "All", "Players", "Troops" }),
		layoutOrder("SearchRange", "Search Radius", 30, 600, 10)
	}, "Actions", { v196("clearTarget", "Release Target") })
	v204("Survival", "Healing and retreat", "Survival", {
		v203("Retreat", "Auto Retreat"),
		v203("Heal", "Auto Heal"),
		v203("Block", "Auto Block"),
		layoutOrder("RetreatHP", "Retreat Below HP %", 5, 60),
		layoutOrder("HealHP", "Heal Below HP %", 10, 95),
		layoutOrder("BlockRange", "Block Radius", 2, 20)
	}, "Actions", { v196("heal", "Heal Now"), v196("retreat", "Retreat") })
	v204("Troop Orders", "Army commands", "Orders", {
		v203("Orders", "Auto Troop Orders"),
		v197("Order", "Order", {
			"Attack",
			"Follow",
			"Hold",
			"Rush",
			"Objective",
			"Supply"
		}),
		v196("order", "Send Order"),
		v196("follow", "Follow"),
		v196("attack", "Attack")
	}, "Formation", { v196("formation1", "Formation 1"), v196("formation2", "Formation 2"), v196("formation3", "Formation 3") })
	v204("Auto Supply", "Replace a wiped army", "Supply", {
		v203("Supply", "Auto Camp Resupply"),
		layoutOrder("SupplySlot", "Supply Slot", 1, 5),
		v197("Travel", "Travel Mode", { "Pathfinding", "Direct" }),
		v196("supply", "Resupply Now")
	}, "Travel", { v196("travelSupply", "Travel to Camp") })
	Travel = v203("AutoEquip", "Auto Equip Best")
	Priority = v203("AutoSummon", "Auto Summon")
	t5 = v203("Stop4", "Stop On 4 Star")
	v204("Army Manager", "Summoning and upgrades", "Army", {
		Travel,
		Priority,
		v197("SummonCount", "Summon Count", { "1", "10" }),
		layoutOrder("KeepGems", "Keep Gems", 0, 10000, 100),
		t5,
		v203("SkipSummon", "Skip Summon Animation"),
		v203("AutoAscend", "Auto Ascend"),
		v203("AutoEvolve", "Auto Evolve")
	}, "Actions", {
		v196("equip", "Equip Best"),
		v196("summon", "Summon"),
		v196("ascend", "Ascend One Duplicate"),
		v196("evolve", "Evolve One Unit"),
		v196("extras", "Manage Units")
	})
	v204("Rewards", "Claims and codes", "Rewards", {
		v203("Daily", "Auto Daily Rewards"),
		v203("Quests", "Auto Quest Rewards"),
		v196("daily", "Check Daily Reward"),
		v196("quests", "Claim Completed Quests")
	}, "Codes", { queue_on_teleport_("Codes", "Codes"), v196("codes", "Redeem Codes") })
	v204("Siege Tools", "Ranged support", "Siege", {
		v203("AutoVolley", "Auto Volley"),
		layoutOrder("VolleyRange", "Volley Radius", 20, 350, 10),
		v203("AutoCannon", "Auto Cannon"),
		layoutOrder("CannonYaw", "Cannon Yaw", -50, 50),
		layoutOrder("CannonPitch", "Cannon Pitch", -35, 35),
		v203("AutoCatapult", "Auto Catapult")
	}, "Actions", { v196("volley", "Volley at Target"), v196("cannon", "Aim and Fire Cannon"), v196("catapult", "Catapult at Target") })
	v204("Player ESP", "Enemy and ally markers", "Players", { v203("PlayerESP", "Enemy ESP"), v203("Allies", "Include Allies"), v203("StaffDetector", "Staff Detector") }, "Detection", { v196("staff", "Check Staff") })
	v204("Troop ESP", "Army markers", "Troops", { v203("TroopESP", "Troop ESP"), v203("Allies", "Include Allies") }, "", {})
	v204("Movement", "Movement controls", "Movement", {
		v203("Speed", "Set Walk Speed"),
		layoutOrder("SpeedValue", "Walk Speed", 16, 100),
		v203("Fly", "Fly"),
		layoutOrder("FlySpeed", "Fly Speed", 10, 100),
		v203("Noclip", "Noclip"),
		v203("InfiniteJump", "Infinite Jump"),
		v197("Travel", "Travel Mode", { "Pathfinding", "Direct" })
	}, "Combat Movement", {
		v203("PlayerStamina", "Unlimited Player Stamina"),
		v203("HorseStamina", "Unlimited Horse Stamina"),
		v203("InfiniteRoll", "Infinite Dodge Roll"),
		v203("AntiStun", "Anti Stun"),
		v196("roll", "Dodge Roll"),
		v196("objective", "Travel to Objective"),
		v196("stop", "Stop Moving")
	})
	v204("Camera", "Camera and lighting", "Visuals", {
		v203("BirdsEye", "Bird\'s-Eye Camera"),
		layoutOrder("CameraHeight", "Camera Height", 30, 180, 10),
		v203("Fullbright", "Fullbright"),
		v203("AntiAFK", "Anti-AFK")
	}, "Actions", { v196("afkNow", "Test AFK Movement") })
	v204("Settings", "Profiles", "Profiles", {
		queue_on_teleport_("ProfileName", "Profile Name"),
		v197("Profile", "Saved Profiles", { "Default" }),
		v196("save", "Save Profile"),
		v196("load", "Load Profile"),
		v196("deleteProfile", "Delete Profile"),
		v203("AutoRestore", "Restore on Inject")
	}, "Session", { v196("reset", "Disable All Features"), v196("unload", "Unload") })
	t4.value21 = nil

	local function closeDropdown()
		if not t2.value19.Dropdown then
			for _, v in ipairs(t2.value19.DropdownConnections or {}) do
				v:Disconnect()
			end

			t2.value19.DropdownConnections = {}

			return
		end

		t2.value19.Dropdown:Destroy()
		t2.value19.Dropdown = nil

		for _, v in ipairs(t2.value19.DropdownConnections or {}) do
			v:Disconnect()
		end

		t2.value19.DropdownConnections = {}
	end

	t2.value19.CloseDropdown = closeDropdown

	function t4.value22(p57, p58, p59, p60)
		closeDropdown()

		local Frame = t4.value2("Frame", {
			Name = "Dropdown",
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			ZIndex = 100
		}, t4.value3)

		t2.value19.Dropdown = Frame

		local TextButton = t4.value2("TextButton", {
			Text = "",
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			ZIndex = 100
		}, Frame)
		local LayoutViewport = t2.value19.LayoutViewport or workspace.CurrentCamera.ViewportSize
		local v216 = #p58 * 44 + 12
		local v217 = LayoutViewport.Y - 24
		local v218 = math.max(60, v217)
		local v219 = math.min(v216, v218)
		local v220 = p57.AbsolutePosition - Frame.AbsolutePosition
		local X = p57.AbsoluteSize.X
		local v222 = math.max(160, X)
		local v223 = LayoutViewport.X - 24
		local v224 = math.min(v222, v223)
		local X2 = v220.X
		local v226 = LayoutViewport.X - v224 - 12
		local v227 = math.max(12, v226)
		local v228 = math.clamp(X2, 12, v227)
		local v229 = v220.Y + p57.AbsoluteSize.Y + 6

		if v229 + v219 > LayoutViewport.Y - 12 then
			local v230 = v220.Y - v219 - 6

			v229 = math.max(12, v230)
		end

		local ScrollingFrame = t4.value2("ScrollingFrame", {
			Name = "Options",
			BackgroundColor3 = t2.value20.panel,
			BorderSizePixel = 0,
			Position = UDim2.fromOffset(v228, v229),
			Size = UDim2.fromOffset(v224, v219),
			ZIndex = 101,
			CanvasSize = UDim2.fromOffset(0, #p58 * 44 + 12),
			ScrollBarThickness = 3,
			ScrollBarImageColor3 = t2.value20.red
		}, Frame)

		t4.value2("UICorner", {
			CornerRadius = UDim.new(0, 12)
		}, ScrollingFrame)
		t4.value2("UIStroke", {
			Color = t2.value20.line,
			Thickness = 1,
			Transparency = 0.82
		}, ScrollingFrame)

		local Activated = TextButton.Activated
		local v233 = closeDropdown

		t2.value19.DropdownConnections[#t2.value19.DropdownConnections + 1] = Activated.Connect(Activated, function(...)
			if not t2.value19.Alive then
				return
			end

			local v234, v235 = t2.value5(v233, ...)

			if v234 then
				return
			end

			t2.value22(tostring(v235):sub(1, 140))
		end)

		for i, v in ipairs(p58) do
			local TextButton2 = t4.value2("TextButton", {
				Name = "Option",
				Text = tostring(v),
				TextXAlignment = Enum.TextXAlignment.Left,
				FontFace = t2.value21.regular,
				TextSize = 13,
				TextColor3 = v == p59 and t2.value20.red or t2.value20.text,
				AutoButtonColor = false,
				BackgroundColor3 = t2.value20.input,
				BackgroundTransparency = v == p59 and 0 or 1,
				BorderSizePixel = 0,
				Position = UDim2.fromOffset(6, 6 + (i - 1) * 44),
				Size = UDim2.new(1, -12, 0, 42),
				ZIndex = 102
			}, ScrollingFrame)

			t4.value2("UICorner", {
				CornerRadius = UDim.new(0, 8)
			}, TextButton2)
			t4.value2("UIPadding", {
				PaddingLeft = UDim.new(0, 12)
			}, TextButton2)

			local Activated2 = TextButton2.Activated

			local function v240()
				p60(v)
				closeDropdown()
			end

			t2.value19.DropdownConnections[#t2.value19.DropdownConnections + 1] = Activated2.Connect(Activated2, function(...)
				if not t2.value19.Alive then
					return
				end

				local v241, v242 = t2.value5(v240, ...)

				if v241 then
					return
				end

				t2.value22(tostring(v242):sub(1, 140))
			end)
		end

		ScrollingFrame.BackgroundTransparency = 0.25
		v199(ScrollingFrame, {
			BackgroundTransparency = 0
		}, 0.14)
	end

	t2.value19.OpenDropdown = t4.value22
	t4.value23 = {}

	function t4.value24(p61)
		local attribute = p61:GetAttribute("ControlKind")
		local TouchLayout = t2.value19.TouchLayout
		local v245 = (attribute == "number" or (attribute == "select" or attribute == "text")) and (TouchLayout and 62 or 54) or (TouchLayout and 44 or 34)
		local v246

		if attribute == "text" then
			v246 = p61.Name == "Codes"
		else
			v246 = false
		end

		local v247 = v246 and (TouchLayout and 82 or 74) or v245

		p61.Size = UDim2.new(1, 0, 0, v247)

		local Label = p61:FindFirstChild("Label")

		if Label then
			Label.Size = UDim2.new(1, attribute == "toggle" and -48 or (attribute == "number" and -58 or 0), 0, attribute == "toggle" and v247 and v247 or 20)
		end

		local Slider = p61:FindFirstChild("Slider")

		if Slider then
			Slider.Position = UDim2.fromOffset(0, 20)
			Slider.Size = UDim2.new(1, 0, 0, v247 - 20)
		end

		local Select = p61:FindFirstChild("Select")

		if Select then
			Select.Position = UDim2.fromOffset(0, 20)
			Select.Size = UDim2.new(1, 0, 0, v247 - 20)
		end

		local Surface = p61:FindFirstChild("Surface")

		if Surface then
			Surface.Position = UDim2.new(0.5, 0, 0, attribute == "select" and 20 + (v247 - 20) / 2 or v247 / 2)
		end

		local TextEntry = p61:FindFirstChild("TextEntry")

		if not TextEntry then
			return
		end

		TextEntry.Position = UDim2.fromOffset(0, 22)
		TextEntry.Size = UDim2.new(1, 0, 0, v247 - 24)
	end
	function t2.value19.UpdateDensity()
		local v253, v254, v255 = ipairs(t4.value23)

		while true do
			local v256

			v255, v256 = v253(v254, v255)

			if not v255 then
				break
			end

			if v256.Parent then
				t4.value24(v256)
			end
		end

		for _, v in pairs(t4.value16) do
			v.Size = UDim2.new(1, 0, 0, t2.value19.TouchLayout and 44 or 32)
		end

		if not t4.value19 then
			return
		end

		t4.value19(true)
	end
	function t4.value25(p62)
		local value22 = t4.value2
		local v260

		if p62 == "" then
			v260 = false
		else
			v260 = p62
		end

		local Frame = value22("Frame", {
			Name = v260 or "Panel",
			BackgroundColor3 = t2.value20.panel,
			BackgroundTransparency = 0.18,
			BorderSizePixel = 0,
			Size = UDim2.fromOffset(350, 300)
		}, t4.value13)

		t4.value2("UICorner", {
			CornerRadius = UDim.new(0, 8)
		}, Frame)

		local v262 = v189(Frame, p62, 13, t2.value20.text, true)

		v262.Size = UDim2.new(1, -28, 0, 28)
		v262.Position = UDim2.fromOffset(14, 6)
		t4.value2("Frame", {
			BackgroundColor3 = t2.value20.line,
			BackgroundTransparency = 0.55,
			BorderSizePixel = 0,
			Position = UDim2.fromOffset(14, 38),
			Size = UDim2.new(1, -28, 0, 1)
		}, Frame)

		local Frame2 = t4.value2("Frame", {
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(14, 46),
			Size = UDim2.new(1, -28, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, Frame)

		return Frame, Frame2, t4.value2("UIListLayout", {
			Padding = UDim.new(0, 4),
			SortOrder = Enum.SortOrder.LayoutOrder
		}, Frame2)
	end
	function t4.value26(p63, p64, p65)
		local v264 = p65 == "select"
		local Frame = t4.value2("Frame", {
			Name = "Surface",
			BackgroundColor3 = t2.value20.input,
			BackgroundTransparency = v264 and 0.5 or 1,
			BorderSizePixel = 0,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.new(1, 0, 0, 28)
		}, p63)

		t4.value2("UICorner", {
			CornerRadius = UDim.new(0, 5)
		}, Frame)

		local value22 = t4.value2
		local regular = t2.value21.regular
		local s2 = "TextColor3"
		local text

		if v264 then
			text = t2.value20.text
		else
			text = v264
		end

		local TextButton = value22("TextButton", {
			Text = p64,
			AutoButtonColor = false,
			FontFace = regular,
			TextSize = 12,
			[s2] = text or t2.value20.muted,
			TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 1)
		}, p63)

		t4.value2("UIPadding", {
			PaddingLeft = UDim.new(0, 8),
			PaddingRight = UDim.new(0, 24)
		}, TextButton)

		if not v264 then
			for _, v in ipairs({
				{ 45, 0 },
				{ -45, 4 }
			}) do
				t4.value2("Frame", {
					BackgroundColor3 = t2.value20.muted,
					BorderSizePixel = 0,
					Rotation = v[1],
					Position = UDim2.new(1, -14, 0.5, v[2] - 2),
					Size = UDim2.fromOffset(6, 1)
				}, TextButton)
			end
		end

		local MouseEnter = TextButton.MouseEnter

		local function v274()
			v199(Frame, {
				BackgroundTransparency = v264 and 0.25 or 0.65
			}, 0.2)
			v199(TextButton, {
				TextColor3 = t2.value20.text
			}, 0.2)
		end

		local v275 = nil

		local function v276(...)
			if not t2.value19.Alive then
				return
			end

			local v277, v278 = t2.value5(v275, ...)

			if v277 then
				return
			end

			t2.value19.Metrics.errors = t2.value19.Metrics.errors + 1
			t2.value22(tostring(v278):sub(1, 140))
		end

		local Connect = MouseEnter.Connect

		v275 = v274

		local v280 = Connect(MouseEnter, v276)
		local value18 = t4.value18

		table.insert(value18, v280)

		local MouseLeave = TextButton.MouseLeave

		local function v283()
			v199(Frame, {
				BackgroundTransparency = v264 and 0.5 or 1
			}, 0.25)

			local v284 = v199
			local v285 = TextButton
			local text2 = v264

			if not text2 then
				v284(v285, {
					TextColor3 = text2 or t2.value20.muted
				}, 0.25)

				return
			end

			text2 = t2.value20.text
			v284(v285, {
				TextColor3 = text2 or t2.value20.muted
			}, 0.25)
		end

		local v287 = nil

		local function v288(...)
			if not t2.value19.Alive then
				return
			end

			local v289, v290 = t2.value5(v287, ...)

			if v289 then
				return
			end

			t2.value19.Metrics.errors = t2.value19.Metrics.errors + 1
			t2.value22(tostring(v290):sub(1, 140))
		end

		local Connect2 = MouseLeave.Connect

		v287 = v283

		local v292 = Connect2(MouseLeave, v288)
		local value182 = t4.value18

		table.insert(value182, v292)

		return TextButton
	end
	function t4.value27(p66, p67, p68)
		local Frame = t4.value2("Frame", {
			Name = p67.key,
			BackgroundTransparency = 1,
			LayoutOrder = p68,
			Size = UDim2.new(1, 0, 0, 34)
		}, p66)

		Frame:SetAttribute("ControlKind", p67.kind)
		t4.value23[#t4.value23 + 1] = Frame

		local v295 = v189(Frame, p67.text, 12, t2.value20.text)

		v295.Name = "Label"

		if p67.kind == "toggle" then
			local TextButton = t4.value2("TextButton", {
				Name = "Toggle",
				Text = "",
				AutoButtonColor = false,
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1)
			}, Frame)
			local Frame2 = t4.value2("Frame", {
				Name = "Switch",
				BackgroundColor3 = t2.value20.input,
				BorderSizePixel = 0,
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, -2, 0.5, 0),
				Size = UDim2.fromOffset(30, 16)
			}, Frame)

			t4.value2("UICorner", {
				CornerRadius = UDim.new(0, 8)
			}, Frame2)

			local Frame3 = t4.value2("Frame", {
				Name = "Thumb",
				BorderSizePixel = 0,
				Size = UDim2.fromOffset(10, 10),
				AnchorPoint = Vector2.new(0, 0.5)
			}, Frame2)

			t4.value2("UICorner", {
				CornerRadius = UDim.new(0, 5)
			}, Frame3)
			t4.value17[p67.key] = function()
				local text = t2.value18[p67.key]
				local v300 = v199
				local v301 = Frame3
				local uDim2 = UDim2.new(0, text and 17 or 3, 0.5, 0)
				local color3

				if text then
					color3 = Color3.fromRGB(239, 229, 253)
				else
					color3 = text
				end

				v300(v301, {
					Position = uDim2,
					BackgroundColor3 = color3 or Color3.fromRGB(136, 130, 149)
				}, 0.24)

				local v304 = v199
				local v305 = Frame2
				local color32

				if text then
					color32 = Color3.fromRGB(125, 78, 184)
				else
					color32 = text
				end

				v304(v305, {
					BackgroundColor3 = color32 or Color3.fromRGB(41, 37, 50)
				}, 0.24)

				local v307 = v199
				local v308 = v295

				if not text then
					v307(v308, {
						TextColor3 = text or Color3.fromRGB(184, 178, 197)
					}, 0.24)

					return
				end

				text = t2.value20.text
				v307(v308, {
					TextColor3 = text or Color3.fromRGB(184, 178, 197)
				}, 0.24)
			end
			t4.value17[p67.key]()

			local Activated = TextButton.Activated

			local function v310()
				local value19 = t2.value19
				local key = p67.key
				local v313 = t2.value18[p67.key]

				value19.Set(value19, key, not v313)
			end

			local v314 = nil

			local function v315(...)
				if not t2.value19.Alive then
					return
				end

				local v316, v317 = t2.value5(v314, ...)

				if v316 then
					return
				end

				t2.value19.Metrics.errors = t2.value19.Metrics.errors + 1
				t2.value22(tostring(v317):sub(1, 140))
			end

			local Connect = Activated.Connect

			v314 = v310

			local v319 = Connect(Activated, v315)
			local value18 = t4.value18

			table.insert(value18, v319)
		elseif p67.kind == "number" then
			local v321 = v189
			local v322 = t2.value18[p67.key]
			local v323 = v321(Frame, tostring(v322), 12, t2.value20.red)

			v323.Name = "Value"
			v323.TextXAlignment = Enum.TextXAlignment.Right
			v323.Position = UDim2.new(1, -58, 0, 0)
			v323.Size = UDim2.fromOffset(58, 20)

			local TextButton = t4.value2("TextButton", {
				Name = "Slider",
				Text = "",
				AutoButtonColor = false,
				BackgroundTransparency = 1,
				BorderSizePixel = 0
			}, Frame)
			local Frame2 = t4.value2("Frame", {
				BackgroundColor3 = t2.value20.line,
				BorderSizePixel = 0,
				Position = UDim2.new(0, 4, 0.5, -1),
				Size = UDim2.new(1, -8, 0, 2)
			}, TextButton)

			t4.value2("UICorner", {
				CornerRadius = UDim.new(0, 2)
			}, Frame2)

			local Frame3 = t4.value2("Frame", {
				BackgroundColor3 = t2.value20.red,
				BorderSizePixel = 0,
				Size = UDim2.fromScale(0.5, 1)
			}, Frame2)

			t4.value2("UICorner", {
				CornerRadius = UDim.new(0, 2)
			}, Frame3)

			local Frame4 = t4.value2("Frame", {
				BackgroundColor3 = t2.value20.red,
				BorderSizePixel = 0,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromOffset(8, 8)
			}, Frame2)

			t4.value2("UICorner", {
				CornerRadius = UDim.new(0, 4)
			}, Frame4)
			t4.value17[p67.key] = function()
				local v328 = (t2.value18[p67.key] - p67.min) / (p67.max - p67.min)
				local v329 = math.clamp(v328, 0, 1)
				local v330 = v323
				local v331 = t2.value18[p67.key]

				v330.Text = tostring(v331)
				Frame3.Size = UDim2.fromScale(v329, 1)
				Frame4.Position = UDim2.fromScale(v329, 0.5)
			end
			t4.value17[p67.key]()

			local u332 = false

			local function v333(p69)
				local min = p67.min
				local clamp = math.clamp
				local v336 = p69 - Frame2.AbsolutePosition.X
				local X = Frame2.AbsoluteSize.X
				local v338 = min + clamp(v336 / math.max(X, 1), 0, 1) * (p67.max - p67.min)
				local value19 = t2.value19
				local key = p67.key
				local clamp2 = math.clamp
				local v342 = (v338 - p67.min) / p67.step + 0.5

				value19:Set(key, (clamp2(math.floor(v342) * p67.step + p67.min, p67.min, p67.max)))
			end

			local u343 = nil
			local InputBegan = TextButton.InputBegan

			local function v345(p70)
				if not (p70.UserInputType == Enum.UserInputType.MouseButton1 and true or p70.UserInputType == Enum.UserInputType.Touch) then
					return
				end

				u332 = true
				u343 = p70
				v333(p70.Position.X)
			end

			local v346 = nil

			local function v347(...)
				if not t2.value19.Alive then
					return
				end

				local v348, v349 = t2.value5(v346, ...)

				if v348 then
					return
				end

				t2.value19.Metrics.errors = t2.value19.Metrics.errors + 1
				t2.value22(tostring(v349):sub(1, 140))
			end

			local Connect = InputBegan.Connect

			v346 = v345

			local v351 = Connect(InputBegan, v347)
			local value18 = t4.value18

			table.insert(value18, v351)

			local InputChanged = t2.value9.InputChanged

			local function v354(p71)
				local v355 = u332

				if v355 then
					v355 = p71 == u343 and true or p71.UserInputType == Enum.UserInputType.MouseMovement
				end

				if not v355 then
					return
				end

				v333(p71.Position.X)
			end

			local v356 = nil

			local function v357(...)
				if not t2.value19.Alive then
					return
				end

				local v358, v359 = t2.value5(v356, ...)

				if v358 then
					return
				end

				t2.value19.Metrics.errors = t2.value19.Metrics.errors + 1
				t2.value22(tostring(v359):sub(1, 140))
			end

			local Connect2 = InputChanged.Connect

			v356 = v354

			local v361 = Connect2(InputChanged, v357)
			local value182 = t4.value18

			table.insert(value182, v361)

			local InputEnded = t2.value9.InputEnded

			local function v364(p72)
				local _ = p72 == u343 and true or p72.UserInputType == Enum.UserInputType.MouseButton1
			end

			local v366 = nil

			local function v367(...)
				if not t2.value19.Alive then
					return
				end

				local v368, v369 = t2.value5(v366, ...)

				if v368 then
					return
				end

				t2.value19.Metrics.errors = t2.value19.Metrics.errors + 1
				t2.value22(tostring(v369):sub(1, 140))
			end

			local Connect3 = InputEnded.Connect

			v366 = v364

			local v371 = Connect3(InputEnded, v367)
			local value183 = t4.value18

			table.insert(value183, v371)
		elseif p67.kind == "select" then
			local value26 = t4.value26
			local v374 = t2.value18[p67.key]
			local v375 = value26(Frame, tostring(v374), "select")

			v375.Name = "Select"

			local Frame2 = t4.value2("Frame", {
				BackgroundTransparency = 1,
				Position = UDim2.new(1, -14, 0.5, -3),
				Size = UDim2.fromOffset(10, 6)
			}, v375)

			t4.value2("Frame", {
				BackgroundColor3 = t2.value20.muted,
				BorderSizePixel = 0,
				Rotation = 45,
				Position = UDim2.fromOffset(0, 2),
				Size = UDim2.fromOffset(5, 1)
			}, Frame2)
			t4.value2("Frame", {
				BackgroundColor3 = t2.value20.muted,
				BorderSizePixel = 0,
				Rotation = -45,
				Position = UDim2.fromOffset(3, 2),
				Size = UDim2.fromOffset(5, 1)
			}, Frame2)
			t4.value17[p67.key] = function()
				local v377 = v375
				local v378 = t2.value18[p67.key]

				v377.Text = tostring(v378)
			end
			t4.value17[p67.key]()

			local Activated = v375.Activated

			local function v380()
				local ProfileNames

				if p67.key == "Profile" then
					ProfileNames = t2.value19.ProfileNames
				else
					ProfileNames = false
				end

				if not ProfileNames then
					local RankedRegions

					if p67.key == "RankedRegion" then
						RankedRegions = t2.value19.RankedRegions
					else
						RankedRegions = false
					end

					ProfileNames = RankedRegions or p67.options
				end

				t4.value22(v375, ProfileNames or p67.options, t2.value18[p67.key], function(p73)
					t2.value19:Set(p67.key, p73)
				end)
			end

			local v383 = nil

			local function v384(...)
				if not t2.value19.Alive then
					return
				end

				local v385, v386 = t2.value5(v383, ...)

				if v385 then
					return
				end

				t2.value19.Metrics.errors = t2.value19.Metrics.errors + 1
				t2.value22(tostring(v386):sub(1, 140))
			end

			local Connect = Activated.Connect

			v383 = v380

			local v388 = Connect(Activated, v384)
			local value18 = t4.value18

			table.insert(value18, v388)
		elseif p67.kind == "action" then
			v295:Destroy()

			local v390 = t4.value26(Frame, p67.text)

			v390.Name = "Action"

			local Activated = v390.Activated

			local function v392()
				if p67.key == "unload" then
					t2.value19:Unload()

					return
				end

				if not t4.value20[p67.key] then
					return
				end

				v22("action:" .. p67.key, t4.value20[p67.key])
			end

			local v393 = nil

			local function v394(...)
				if not t2.value19.Alive then
					return
				end

				local v395, v396 = t2.value5(v393, ...)

				if v395 then
					return
				end

				t2.value19.Metrics.errors = t2.value19.Metrics.errors + 1
				t2.value22(tostring(v396):sub(1, 140))
			end

			local Connect = Activated.Connect

			v393 = v392

			local v398 = Connect(Activated, v394)
			local value18 = t4.value18

			table.insert(value18, v398)
		else
			if p67.kind ~= "text" then
				t4.value24(Frame)

				return
			end

			local TextBox = t4.value2("TextBox", {
				Name = "TextEntry",
				Text = t2.value18[p67.key],
				PlaceholderText = p67.key == "Codes" and "CODE_1, CODE_2" or false or "My Profile",
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				ClearTextOnFocus = false,
				MultiLine = p67.key == "Codes",
				FontFace = t2.value21.regular,
				TextSize = 12,
				TextColor3 = t2.value20.text,
				BackgroundColor3 = t2.value20.input,
				BackgroundTransparency = 0.5,
				BorderSizePixel = 0
			}, Frame)

			t4.value2("UICorner", {
				CornerRadius = UDim.new(0, 5)
			}, TextBox)
			t4.value2("UIPadding", {
				PaddingLeft = UDim.new(0, 8),
				PaddingRight = UDim.new(0, 8)
			}, TextBox)
			t4.value17[p67.key] = function()
				TextBox.Text = t2.value18[p67.key]
			end

			local FocusLost = TextBox.FocusLost

			local function v402()
				t2.value19:Set(p67.key, TextBox.Text)
			end

			local v403 = nil

			local function v404(...)
				if not t2.value19.Alive then
					return
				end

				local v405, v406 = t2.value5(v403, ...)

				if v405 then
					return
				end

				t2.value19.Metrics.errors = t2.value19.Metrics.errors + 1
				t2.value22(tostring(v406):sub(1, 140))
			end

			local Connect = FocusLost.Connect

			v403 = v402

			local v408 = Connect(FocusLost, v404)
			local value18 = t4.value18

			table.insert(value18, v408)
		end

		t4.value24(Frame)
	end
	function t4.value28(p74)
		if not t4.value15[p74] then
			return
		end

		closeDropdown()
		t2.value19.Page = p74

		for _, v in ipairs(t4.value18) do
			v:Disconnect()
		end

		table.clear(t4.value18)
		table.clear(t4.value17)
		table.clear(t4.value23)

		local v412, v413, v414 = ipairs(t4.value13:GetDescendants())

		while true do
			local v415

			v414, v415 = v412(v413, v414)

			if not v414 then
				break
			end

			if t2.value19.Tweens[v415] then
				t2.value19.Tweens[v415]:Cancel()
				t2.value19.Tweens[v415] = nil
			end
		end

		for _, child in ipairs(t4.value13:GetChildren()) do
			child:Destroy()
		end

		local v418 = t4.value15[p74]

		t4.value10.Text = p74

		if t4.value19 then
			t4.value19(false, true)
		end

		local v419, v420, v421 = t4.value25(v418.leftTitle)
		local v422, v423, v424 = t4.value25(v418.rightTitle)
		local v425, v426, v427 = ipairs(v418.left)

		while true do
			local v428

			v427, v428 = v425(v426, v427)

			if not v427 then
				break
			end

			t4.value27(v420, v428, v427)
		end

		for i, v in ipairs(v418.right) do
			t4.value27(v423, v, i)
		end

		function t4.value21()
			if v419.Parent then
				local v431 = t4.value13.AbsoluteSize.X - 6
				local v432 = v421.AbsoluteContentSize.Y + 60
				local v433 = v424.AbsoluteContentSize.Y + 60

				if #v418.right == 0 then
					v422.Visible = false
					v419.Size = UDim2.fromOffset(v431 - 2, v432)
					v419.Position = UDim2.fromOffset(1, 1)
					t4.value13.CanvasSize = UDim2.fromOffset(0, v432 + 10)

					return
				elseif v431 >= 580 then
					v419.Size = UDim2.fromOffset((v431 - 14) / 2, v432)
					v422.Size = UDim2.fromOffset((v431 - 14) / 2, v433)
					v419.Position = UDim2.fromOffset(1, 1)
					v422.Position = UDim2.fromOffset((v431 - 14) / 2 + 15, 1)
					t4.value13.CanvasSize = UDim2.fromOffset(0, math.max(v432, v433) + 10)

					return
				else
					v419.Size = UDim2.fromOffset(v431 - 2, v432)
					v422.Size = UDim2.fromOffset(v431 - 2, v433)
					v419.Position = UDim2.fromOffset(1, 1)
					v422.Position = UDim2.fromOffset(1, v432 + 15)
					t4.value13.CanvasSize = UDim2.fromOffset(0, v432 + v433 + 24)

					return
				end
			end
		end

		local signal = v421:GetPropertyChangedSignal("AbsoluteContentSize")
		local value21 = t4.value21
		local v436 = nil

		local function v437(...)
			if not t2.value19.Alive then
				return
			end

			local v438, v439 = t2.value5(v436, ...)

			if v438 then
				return
			end

			t2.value19.Metrics.errors = t2.value19.Metrics.errors + 1
			t2.value22(tostring(v439):sub(1, 140))
		end

		local Connect = signal.Connect

		v436 = value21

		local v441 = Connect(signal, v437)
		local value18 = t4.value18

		table.insert(value18, v441)

		local signal2 = v424:GetPropertyChangedSignal("AbsoluteContentSize")
		local value212 = t4.value21
		local v445 = nil

		local function v446(...)
			if not t2.value19.Alive then
				return
			end

			local v447, v448 = t2.value5(v445, ...)

			if v447 then
				return
			end

			t2.value19.Metrics.errors = t2.value19.Metrics.errors + 1
			t2.value22(tostring(v448):sub(1, 140))
		end

		local Connect2 = signal2.Connect

		v445 = value212

		local v450 = Connect2(signal2, v446)
		local value182 = t4.value18

		table.insert(value182, v450)
		t4.value13.CanvasPosition = Vector2.zero
		t4.value21()
		t4.value10.TextTransparency = 0.65
		v199(t4.value10, {
			TextTransparency = 0
		}, 0.3)
	end

	t2.value19.ShowPage = t4.value28
	t2.value19.Pages = t4.value15

	function t2.value19.RefreshControl(p75)
		if not t4.value17[p75] then
			return
		end

		t4.value17[p75]()
	end

	t4.value29 = {
		{
			"Automation",
			"Auto Farm",
			"Auto Match",
			"Rewards"
		},
		{
			"Combat",
			"Auto Fight",
			"Target Lock",
			"Survival",
			"Siege Tools"
		},
		{
			"Army",
			"Troop Orders",
			"Auto Supply",
			"Army Manager"
		},
		{
			"Visuals",
			"Player ESP",
			"Troop ESP",
			"Camera"
		},
		{ "Other", "Movement", "Settings" }
	}
	t4.value30 = {}
	t4.value31 = t4.value2("Frame", {
		Name = "Selection",
		BackgroundColor3 = t2.value20.red,
		BorderSizePixel = 0,
		Size = UDim2.fromOffset(2, 18),
		Visible = false,
		ZIndex = 3
	}, t4.value6)
	Travel = t4.value31
	t4.value2("UICorner", {
		CornerRadius = UDim.new(0, 1)
	}, Travel)
	Travel = function(p76, p77)
		for k, v in pairs(t4.value16) do
			local v454 = k == t2.value19.Page
			local v455 = v199
			local s3 = "TextColor3"
			local text

			if v454 then
				text = t2.value20.text
			else
				text = v454
			end

			if not text then
				local color3 = t4.value30[k]

				if color3 then
					color3 = Color3.fromRGB(205, 199, 216)
				end

				text = color3 or t2.value20.muted
			end

			v455(v, {
				[s3] = text,
				BackgroundTransparency = v454 and 0.78 or (t4.value30[k] and 0.9 or 1)
			}, 0.28)
			v199(v:FindFirstChildOfClass("UIPadding"), {
				PaddingLeft = UDim.new(0, v454 and 14 or 10)
			}, 0.28)
		end

		local v459 = t4.value16[t2.value19.Page]

		if not v459 then
			t4.value31.Visible = false

			return
		end

		if p77 then
			local v460 = v459.AbsolutePosition.Y - t4.value7.AbsolutePosition.Y + t4.value7.CanvasPosition.Y
			local Y = t4.value7.CanvasPosition.Y

			if v460 - Y < 4 then
				Y = v460 - 4
			elseif v460 + v459.AbsoluteSize.Y - Y > t4.value7.AbsoluteSize.Y - 4 then
				Y = v460 + v459.AbsoluteSize.Y - t4.value7.AbsoluteSize.Y + 4
			end

			local v462 = t4.value7.AbsoluteCanvasSize.Y - t4.value7.AbsoluteSize.Y
			local v463 = math.max(0, v462)
			local v464 = math.clamp(Y, 0, v463)
			local v465 = v464 - t4.value7.CanvasPosition.Y

			if math.abs(v465) > 1 then
				v199(t4.value7, {
					CanvasPosition = Vector2.new(0, v464)
				}, 0.32)
			end
		end

		local v466 = v459.AbsolutePosition.Y + v459.AbsoluteSize.Y / 2
		local value31 = t4.value31
		local visible

		if t4.value7.AbsolutePosition.Y <= v466 then
			visible = v466 <= t4.value7.AbsolutePosition.Y + t4.value7.AbsoluteSize.Y
		else
			visible = false
		end

		value31.Visible = visible

		local uDim2 = UDim2.fromOffset(14, v466 - t4.value6.AbsolutePosition.Y - 9)

		if not p76 then
			v199(t4.value31, {
				Position = uDim2
			}, 0.32)

			return
		end

		if not t2.value19.Tweens[t4.value31] then
			t4.value31.Position = uDim2

			return
		end

		t2.value19.Tweens[t4.value31]:Cancel()
		t4.value31.Position = uDim2
	end
	t4.value19 = Travel
	v204 = 0

	for _, v in ipairs(t4.value29) do
		layoutOrder = v204 + 1
		v197 = v189(t4.value7, v[1]:upper(), 9, t2.value20.red, true)
		v197.Size = UDim2.new(1, 0, 0, 24)
		v197.LayoutOrder = layoutOrder

		for i = 2, #v do
			queue_on_teleport_ = v204 + 1

			local v473 = v[i]

			queue_on_teleport_ = t4.value2("TextButton", {
				Name = v473,
				Text = v473,
				TextXAlignment = Enum.TextXAlignment.Left,
				AutoButtonColor = false,
				FontFace = t2.value21.regular,
				TextSize = 12,
				TextColor3 = t2.value20.muted,
				BackgroundColor3 = Color3.fromRGB(36, 26, 53),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 32),
				LayoutOrder = queue_on_teleport_
			}, t4.value7)
			t4.value2("UICorner", {
				CornerRadius = UDim.new(0, 5)
			}, queue_on_teleport_)
			t4.value2("UIPadding", {
				PaddingLeft = UDim.new(0, 10)
			}, queue_on_teleport_)
			t4.value16[v473] = queue_on_teleport_

			local function v474()
				t4.value28(v473)
			end

			v548 = queue_on_teleport_.Activated:Connect(function(...)
				if not t2.value19.Alive then
					return
				end

				local v475, v476 = t2.value5(v474, ...)

				if v475 then
					return
				end

				t2.value19.Metrics.errors = t2.value19.Metrics.errors + 1
				t2.value22(tostring(v476):sub(1, 140))
			end)
			table.insert(t2.value19.Connections, v548)

			local function v477()
				t4.value30[v473] = true
				t4.value19()
			end

			v548 = queue_on_teleport_.MouseEnter:Connect(function(...)
				if not t2.value19.Alive then
					return
				end

				local v478, v479 = t2.value5(v477, ...)

				if v478 then
					return
				end

				t2.value19.Metrics.errors = t2.value19.Metrics.errors + 1
				t2.value22(tostring(v479):sub(1, 140))
			end)
			table.insert(t2.value19.Connections, v548)

			local function v480()
				t4.value30[v473] = nil
				t4.value19()
			end

			v548 = queue_on_teleport_.MouseLeave:Connect(function(...)
				if not t2.value19.Alive then
					return
				end

				local v481, v482 = t2.value5(v480, ...)

				if v481 then
					return
				end

				t2.value19.Metrics.errors = t2.value19.Metrics.errors + 1
				t2.value22(tostring(v482):sub(1, 140))
			end)
			table.insert(t2.value19.Connections, v548)
		end
	end

	local function v483()
		t4.value19(true)
	end

	local connection = t4.value7:GetPropertyChangedSignal("CanvasPosition"):Connect(function(...)
		if not t2.value19.Alive then
			return
		end

		local v485, v486 = t2.value5(v483, ...)

		if v485 then
			return
		end

		t2.value19.Metrics.errors = t2.value19.Metrics.errors + 1
		t2.value22(tostring(v486):sub(1, 140))
	end)

	table.insert(t2.value19.Connections, connection)

	local function v487()
		t4.value19(true)
		v22("navResize", function()
			task.wait(0.34)
			t4.value19(false, true)
		end)
	end

	connection = t4.value7:GetPropertyChangedSignal("AbsoluteSize"):Connect(function(...)
		if not t2.value19.Alive then
			return
		end

		local v488, v489 = t2.value5(v487, ...)

		if v488 then
			return
		end

		t2.value19.Metrics.errors = t2.value19.Metrics.errors + 1
		t2.value22(tostring(v489):sub(1, 140))
	end)
	table.insert(t2.value19.Connections, connection)
	t4.value32 = nil
	t4.value33 = nil
	t4.value32 = true
	t4.value33 = 0

	function t4.value34(p78)
		t4.value32 = p78
		t2.value19.Visible = p78
		t4.value33 = t4.value33 + 1

		local value33 = t4.value33

		closeDropdown()

		local value8 = t4.value8
		local visible = not p78

		if visible then
			visible = t2.value19.TouchLayout == true
		end

		value8.Visible = visible

		if p78 then
			t4.value4.Visible = true
			v199(t4.value4, {
				GroupTransparency = 0
			}, 0.3)
			v199(t4.value5, {
				Scale = 1
			}, 0.3)

			return
		end

		v199(t4.value4, {
			GroupTransparency = 1
		}, 0.22)
		v199(t4.value5, {
			Scale = 0.97
		}, 0.22)
		v22("visibility:" .. value33, function()
			task.wait(0.23)

			local Alive

			if value33 == t4.value33 then
				Alive = t2.value19.Alive
			else
				Alive = false
			end

			if not Alive then
				return
			end

			t4.value4.Visible = false
		end)
	end

	t2.value19.SetVisible = t4.value34

	local function v494()
		t4.value34(false)
	end

	connection = getgc_.Activated:Connect(function(...)
		if not t2.value19.Alive then
			return
		end

		local v495, v496 = t2.value5(v494, ...)

		if v495 then
			return
		end

		t2.value19.Metrics.errors = t2.value19.Metrics.errors + 1
		t2.value22(tostring(v496):sub(1, 140))
	end)
	table.insert(t2.value19.Connections, connection)

	local function v497()
		if not t2.value19.TouchLayout then
			return
		end

		t4.value34(false)
	end

	connection = parent.Activated:Connect(function(...)
		if not t2.value19.Alive then
			return
		end

		local v498, v499 = t2.value5(v497, ...)

		if v498 then
			return
		end

		t2.value19.Metrics.errors = t2.value19.Metrics.errors + 1
		t2.value22(tostring(v499):sub(1, 140))
	end)
	table.insert(t2.value19.Connections, connection)

	local function v500()
		t4.value34(false)
	end

	connection = t4.value12.Activated:Connect(function(...)
		if not t2.value19.Alive then
			return
		end

		local v501, v502 = t2.value5(v500, ...)

		if v501 then
			return
		end

		t2.value19.Metrics.errors = t2.value19.Metrics.errors + 1
		t2.value22(tostring(v502):sub(1, 140))
	end)
	table.insert(t2.value19.Connections, connection)

	local function v503()
		t4.value34(true)
	end

	connection = t4.value8.Activated:Connect(function(...)
		if not t2.value19.Alive then
			return
		end

		local v504, v505 = t2.value5(v503, ...)

		if v504 then
			return
		end

		t2.value19.Metrics.errors = t2.value19.Metrics.errors + 1
		t2.value22(tostring(v505):sub(1, 140))
	end)
	table.insert(t2.value19.Connections, connection)

	local function v506()
		t2.value19:Unload()
	end

	connection = value2.Activated:Connect(function(...)
		if not t2.value19.Alive then
			return
		end

		local v507, v508 = t2.value5(v506, ...)

		if v507 then
			return
		end

		t2.value19.Metrics.errors = t2.value19.Metrics.errors + 1
		t2.value22(tostring(v508):sub(1, 140))
	end)
	table.insert(t2.value19.Connections, connection)

	local function v509()
		local t6 = {}

		for _, v in ipairs(t4.value29) do
			for i = 2, #v do
				t6[#t6 + 1] = v[i]
			end
		end

		t4.value22(t4.value11, t6, t2.value19.Page, t4.value28)
	end

	connection = t4.value11.Activated:Connect(function(...)
		if not t2.value19.Alive then
			return
		end

		local v514, v515 = t2.value5(v509, ...)

		if v514 then
			return
		end

		t2.value19.Metrics.errors = t2.value19.Metrics.errors + 1
		t2.value22(tostring(v515):sub(1, 140))
	end)
	table.insert(t2.value19.Connections, connection)

	local function v516(p79, p80)
		if p79.KeyCode == Enum.KeyCode.Escape then
			closeDropdown()
		end

		local v517 = not p80

		if v517 then
			v517 = p79.KeyCode == Enum.KeyCode.RightShift
		end

		if not v517 then
			return
		end

		t4.value34(not t4.value32)
	end

	connection = t2.value9.InputBegan:Connect(function(...)
		if not t2.value19.Alive then
			return
		end

		local v518, v519 = t2.value5(v516, ...)

		if v518 then
			return
		end

		t2.value19.Metrics.errors = t2.value19.Metrics.errors + 1
		t2.value22(tostring(v519):sub(1, 140))
	end)
	table.insert(t2.value19.Connections, connection)
	t4.value35 = nil
	t4.value36 = nil
	t4.value37 = nil
	t4.value38 = nil

	function t4.value39(p81, p82)
		local LayoutViewport = t2.value19.LayoutViewport or workspace.CurrentCamera.ViewportSize
		local AbsoluteSize = t4.value4.AbsoluteSize
		local uDim2 = UDim2.fromOffset
		local v523 = AbsoluteSize.X / 2
		local v524 = AbsoluteSize.X / 2
		local v525 = LayoutViewport.X - AbsoluteSize.X / 2
		local v526 = math.max(v524, v525)

		return uDim2(math.clamp(p81, v523, v526), (math.clamp(p82, AbsoluteSize.Y / 2, (math.max(AbsoluteSize.Y / 2, LayoutViewport.Y - AbsoluteSize.Y / 2)))))
	end

	local function v527(p83)
		if not (p83.UserInputType == Enum.UserInputType.MouseButton1 and true or p83.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		t4.value35 = true
		t4.value36 = p83.Position
		t4.value37 = t4.value4.AbsolutePosition + t4.value4.AbsoluteSize / 2
		t4.value38 = p83
	end

	connection = t4.value9.InputBegan:Connect(function(...)
		if not t2.value19.Alive then
			return
		end

		local v528, v529 = t2.value5(v527, ...)

		if v528 then
			return
		end

		t2.value19.Metrics.errors = t2.value19.Metrics.errors + 1
		t2.value22(tostring(v529):sub(1, 140))
	end)
	table.insert(t2.value19.Connections, connection)

	local function v530(p84)
		local value35 = t4.value35

		if value35 then
			value35 = p84 == t4.value38 and true or p84.UserInputType == Enum.UserInputType.MouseMovement
		end

		if not value35 then
			return
		end

		local v532 = p84.Position - t4.value36

		t4.value4.Position = t4.value39(t4.value37.X + v532.X, t4.value37.Y + v532.Y)
		closeDropdown()
	end

	connection = t2.value9.InputChanged:Connect(function(...)
		if not t2.value19.Alive then
			return
		end

		local v533, v534 = t2.value5(v530, ...)

		if v533 then
			return
		end

		t2.value19.Metrics.errors = t2.value19.Metrics.errors + 1
		t2.value22(tostring(v534):sub(1, 140))
	end)
	table.insert(t2.value19.Connections, connection)

	local function v535(p85)
		local _ = p85 == t4.value38 and true or p85.UserInputType == Enum.UserInputType.MouseButton1
	end

	connection = t2.value9.InputEnded:Connect(function(...)
		if not t2.value19.Alive then
			return
		end

		local v537, v538 = t2.value5(v535, ...)

		if v537 then
			return
		end

		t2.value19.Metrics.errors = t2.value19.Metrics.errors + 1
		t2.value22(tostring(v538):sub(1, 140))
	end)
	table.insert(t2.value19.Connections, connection)
	t4.value40 = t4.value2("Frame", {
		Name = "FlyControls",
		BackgroundTransparency = 1,
		Position = UDim2.new(1, -124, 1, -170),
		Size = UDim2.fromOffset(112, 52),
		Visible = false
	}, t4.value3)

	for i, v in ipairs({
		{ "+", 1 },
		{ "-", -1 }
	}) do
		i = t4.value2("TextButton", {
			Text = v[1],
			TextSize = 23,
			FontFace = t2.value21.bold,
			TextColor3 = t2.value20.red,
			BackgroundColor3 = t2.value20.panel,
			BorderSizePixel = 0,
			Position = UDim2.fromOffset((i - 1) * 58, 0),
			Size = UDim2.fromOffset(52, 52)
		}, t4.value40)
		t4.value2("UICorner", {
			CornerRadius = UDim.new(0, 14)
		}, i)
		t4.value2("UIStroke", {
			Color = t2.value20.line,
			Thickness = 1,
			Transparency = 0.82
		}, i)

		local function v541(p86)
			if not (p86.UserInputType == Enum.UserInputType.Touch and true or p86.UserInputType == Enum.UserInputType.MouseButton1) then
				return
			end

			t2.value19.FlyVertical = v[2]
		end

		v204 = i.InputBegan:Connect(function(...)
			if not t2.value19.Alive then
				return
			end

			local v542, v543 = t2.value5(v541, ...)

			if v542 then
				return
			end

			t2.value19.Metrics.errors = t2.value19.Metrics.errors + 1
			t2.value22(tostring(v543):sub(1, 140))
		end)
		table.insert(t2.value19.Connections, v204)
		game_(i.InputEnded, function()
			t2.value19.FlyVertical = 0
		end)
	end

	t2.value19.UI = {
		Window = t4.value4,
		Logo = parent,
		Launcher = t4.value8,
		Body = t4.value13,
		Header = t4.value9,
		Sidebar = t4.value6,
		Menu = t4.value11,
		FlyPad = t4.value40
	}

	function t4.value41(p87, p88)
		local CurrentCamera = workspace.CurrentCamera

		if not CurrentCamera then
			return
		end

		if typeof(p87) ~= "Vector2" then
			p87 = false
		end

		local ViewportSize = p87 or CurrentCamera.ViewportSize

		if type(p88) ~= "boolean" then
			p88 = t2.value9.TouchEnabled

			if p88 then
				p88 = not t2.value9.KeyboardEnabled
			end
		end

		t2.value19.LayoutViewport = ViewportSize
		t2.value19.TouchLayout = p88

		local value19 = t2.value19
		local s4 = "Device"
		local v549

		if p88 then
			local X = ViewportSize.X
			local Y = ViewportSize.Y

			v549 = math.min(X, Y) >= 600 and "Tablet" or false or "Phone"
		else
			v549 = p88
		end

		value19[s4] = v549 or "Desktop"

		local min = math.min
		local v552 = ViewportSize.X - 24
		local v553 = min(p88 and 960 or 940, (math.max(260, v552)))
		local min2 = math.min
		local v555 = ViewportSize.Y - 52
		local v556 = min2(p88 and 620 or 480, (math.max(220, v555)))
		local visible = v553 < 600
		local v558 = visible and 0 or (p88 and (v553 < 900 and 144 or 170) or 156)

		t4.value4.Size = UDim2.fromOffset(v553, v556)
		t4.value4.Position = UDim2.fromOffset(ViewportSize.X / 2, ViewportSize.Y / 2)
		t4.value6.Visible = not visible
		t4.value6.Size = UDim2.new(0, v558, 1, 0)
		t4.value11.Visible = visible
		t4.value12.Visible = visible and p88
		t4.value10.TextSize = visible and 17 or 21

		local value10 = t4.value10
		local s5 = "Position"
		local uDim2 = UDim2.fromOffset
		local v562

		if visible then
			v562 = p88 and 48
		else
			v562 = visible
		end

		value10[s5] = uDim2(v562 or 0, 12)
		t4.value10.Size = UDim2.new(1, visible and -194 or -145, 0, 30)
		t4.value9.Position = UDim2.fromOffset(v558 + 16, 12)
		t4.value9.Size = UDim2.new(1, -v558 - 32, 0, 58)
		t4.value13.Position = UDim2.fromOffset(v558 + 16, 72)
		t4.value13.Size = UDim2.new(1, -v558 - 32, 1, -88)
		t4.value14.Position = UDim2.new(0, v558 + 16, 1, -25)
		t4.value14.Size = UDim2.new(1, -v558 - 32, 0, 18)

		local value8 = t4.value8
		local s6 = "Visible"
		local v565

		if p88 then
			v565 = not t4.value32
		else
			v565 = p88
		end

		value8[s6] = v565

		local value82 = t4.value8
		local uDim22 = UDim2.fromOffset
		local v568 = ViewportSize.Y - 80
		local v569 = math.max(12, v568)

		value82.Position = uDim22(12, (math.min(80, v569)))

		local value40 = t4.value40
		local s7 = "Visible"

		if p88 then
			p88 = t2.value18.Fly
		end

		value40[s7] = p88
		closeDropdown()

		if t2.value19.UpdateDensity then
			t2.value19.UpdateDensity()
		end

		if not t4.value21 then
			return
		end

		t4.value21()
	end

	t2.value19.Resize = t4.value41

	local function v572()
		if not t4.value21 then
			return
		end

		t4.value21()
	end

	connection = t4.value13:GetPropertyChangedSignal("AbsoluteSize"):Connect(function(...)
		if not t2.value19.Alive then
			return
		end

		local v573, v574 = t2.value5(v572, ...)

		if v573 then
			return
		end

		t2.value19.Metrics.errors = t2.value19.Metrics.errors + 1
		t2.value22(tostring(v574):sub(1, 140))
	end)
	table.insert(t2.value19.Connections, connection)
	game_(t4.value13:GetPropertyChangedSignal("CanvasPosition"), closeDropdown)
	t4.value42 = nil
	connection = function()
		if t4.value42 then
			t4.value42:Disconnect()
		end

		if not workspace.CurrentCamera then
			t4.value41()

			return
		end

		local signal = workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize")
		local value41 = t4.value41
		local connection2 = signal:Connect(function(...)
			if not t2.value19.Alive then
				return
			end

			local v578, v579 = t2.value5(value41, ...)

			if v578 then
				return
			end

			t2.value19.Metrics.errors = t2.value19.Metrics.errors + 1
			t2.value22(tostring(v579):sub(1, 140))
		end)

		table.insert(t2.value19.Connections, connection2)
		t4.value41()
	end
	t4.value34(true)
	Priority = workspace
	game_(Priority.GetPropertyChangedSignal(Priority, "CurrentCamera"), connection)
	t4.value43 = nil

	function t4.value43()
		local Character = t2.value15.Character
		local Humanoid

		if Character then
			Humanoid = Character:FindFirstChildOfClass("Humanoid")
		else
			Humanoid = Character
		end

		if Character then
			Character = Character:FindFirstChild("HumanoidRootPart")
		end

		if not (Character and t2.value15.Team) then
			return {}
		end

		local t7 = {}
		local ipairs_

		if t2.value18.TargetType == "Troops" then
			ipairs_ = t7
		else
			ipairs_ = ipairs

			local value7 = t2.value7

			for _, player in ipairs_(value7.GetPlayers(value7)) do
				local v587 = player ~= t2.value15

				if v587 then
					v587 = player.Team

					if v587 then
						v587 = player.Team ~= t2.value15.Team

						if v587 then
							v587 = player:GetAttribute("MatchState") == "Game"

							if v587 then
								v587 = player:GetAttribute("Invincible") ~= true
							end
						end
					end
				end

				if v587 then
					local Character2 = player.Character
					local v589 = v60(Character2)
					local v590, v591

					if Character2 then
						ipairs_ = v62
						v590, v591 = ipairs_(Character2)
					else
						v590 = nil
						ipairs_ = nil
						v591 = nil
					end

					local v592

					if v589 then
						if v590 then
							v592 = v590 > 0
						else
							v592 = v590
						end
					else
						v592 = v589
					end

					if v592 then
						ipairs_ = table.insert
						ipairs_(t7, {
							model = Character2,
							root = v589,
							hp = v590,
							max = v591,
							kind = "Players",
							name = player.DisplayName,
							count = player:GetAttribute("CurrentUnitAliveCount") or 0,
							distance = (Character.Position - v589.Position).Magnitude
						})
					end
				end
			end
		end

		if t2.value18.TargetType == "Players" then
			return t7
		end

		local Troops = workspace:FindFirstChild("Troops")

		if not Troops then
			return t7
		end

		for _, child in ipairs(Troops.GetChildren(Troops)) do
			local v596 = v71(child)
			local v597

			if v596 then
				v597 = v596:GetAttribute("Team") ~= t2.value15.Team.Name

				if v597 then
					v597 = v596:GetAttribute("Team") ~= nil
				end
			else
				v597 = v596
			end

			if v597 then
				local GetChildren = child.GetChildren

				for _, v in ipairs(GetChildren(child)) do
					local isModel = v:IsA("Model")

					if isModel then
						isModel = v:GetAttribute("TroopId")

						if isModel then
							isModel = v:GetAttribute("ClientVisualProxy") ~= true
						end
					end

					if isModel then
						local v602 = v60(v)
						local v603, v604 = v62(v)
						local v605

						if v602 then
							v605 = v603 > 0
						else
							v605 = v602
						end

						if v605 then
							table.insert(t7, {
								model = v,
								root = v602,
								hp = v603,
								max = v604,
								kind = "Troops",
								name = v:GetAttribute("TroopId"),
								count = tonumber(child:GetAttribute("TroopCount")) or 0,
								distance = (Character.Position - v602.Position).Magnitude
							})
						end
					end
				end
			end
		end

		return t7
	end
	function t4.value44()
		local v606 = t4.value43()
		local v607 = nil

		for _, v in ipairs(v606) do
			if v.distance <= t2.value18.SearchRange then
				local distance = v.distance

				if t2.value18.Priority == "Lowest HP" then
					local hp = v.hp
					local max = v.max or 1

					distance = hp / math.max(max, 1) * 1000 + v.distance * 0.05
				end

				if t2.value18.Priority == "Players" then
					distance = distance + (v.kind == "Players" and 0 or 10000)
				end

				if t2.value18.Priority == "Troops" then
					distance = distance + (v.kind == "Troops" and 0 or 10000)
				end

				if t2.value18.Priority == "Largest Army" then
					distance = -v.count * 100 + v.distance
				end

				v.score = distance

				local Target = t2.value18.Lock and t2.value19.Target

				if Target then
					Target = v.model == t2.value19.Target.model
				end

				if Target then
					t2.value19.Target = v

					return v
				end

				if not v607 or distance < v607.score then
					v607 = v
				end
			end
		end

		t2.value19.Target = v607

		return v607
	end
	function t4.value45(p89)
		local _, v615, v616 = v56()

		if not v615 or (not v616 or (v615.Health <= 0 and true or t2.value18.Fly)) then
			return
		end

		if (v616.Position - p89).Magnitude < 4 then
			v102()

			return
		end

		t2.value19.MovingUntil = os.clock() + 2

		if t2.value18.Travel == "Direct" then
			t2.value19.NavigationGoal = p89
			v615:MoveTo(p89)

			return
		end

		local PathGoal = t2.value19.PathGoal

		if PathGoal then
			PathGoal = (t2.value19.PathGoal - p89).Magnitude < 10

			if PathGoal then
				PathGoal = t2.value19.Waypoints

				if PathGoal then
					PathGoal = os.clock() < (t2.value19.PathExpires or 0)
				end
			end
		end

		if PathGoal then
			return
		end

		if t2.value19.Pending.path then
			return
		end

		t2.value19.PathGoal = p89
		t2.value19.PathExpires = os.clock() + 4
		t2.value19.PathGeneration = (t2.value19.PathGeneration or 0) + 1

		local PathGeneration = t2.value19.PathGeneration

		v22("path", function()
			local v619 = t2.value13:CreatePath({
				AgentRadius = 2,
				AgentHeight = 5,
				AgentCanJump = true,
				WaypointSpacing = 5
			})

			local function v620()
				v619:ComputeAsync(v616.Position, p89)
			end

			local ok = pcall(v620)

			if not t2.value19.Alive or PathGeneration ~= t2.value19.PathGeneration then
				return
			end

			if not ok then
				if ok then
					t2.value19.Waypoints = v619:GetWaypoints()
					t2.value19.WaypointIndex = 2
				else
					t2.value19.Waypoints = {
						{
							Position = p89,
							Action = Enum.PathWaypointAction.Walk
						}
					}
					t2.value19.WaypointIndex = 1
				end

				return
			end

			ok = v619.Status == Enum.PathStatus.Success

			if ok then
				t2.value19.Waypoints = v619:GetWaypoints()
				t2.value19.WaypointIndex = 2
			else
				t2.value19.Waypoints = {
					{
						Position = p89,
						Action = Enum.PathWaypointAction.Walk
					}
				}
				t2.value19.WaypointIndex = 1
			end
		end)
	end
	function t4.value46()
		local _, v623, v624 = v56()

		if not v623 or (not v624 or (not t2.value19.Waypoints or os.clock() > (t2.value19.MovingUntil or 0))) then
			return
		end

		local v625 = t2.value19.Waypoints[t2.value19.WaypointIndex]

		if not v625 then
			t2.value19.Waypoints = nil

			return
		end

		if (v624.Position - v625.Position).Magnitude < 4 then
			t2.value19.WaypointIndex = t2.value19.WaypointIndex + 1
			v625 = t2.value19.Waypoints[t2.value19.WaypointIndex]
		end

		if not v625 then
			return
		end

		t2.value19.NavigationGoal = v625.Position
		v623:MoveTo(v625.Position)

		if v625.Action ~= Enum.PathWaypointAction.Jump then
			return
		end

		v623.Jump = true
	end
	function t4.value47()
		if t2.value18.Team == "Automatic" then
			local Teams = game:GetService("Teams")
			local Attackers = Teams:FindFirstChild("Attackers")
			local Defenders = Teams:FindFirstChild("Defenders")

			if Attackers then
				if not Defenders then
					return Defenders or "Attackers"
				end

				local players = Attackers:GetPlayers()
				local GetPlayers = Defenders.GetPlayers

				Defenders = #players > #GetPlayers(Defenders) and "Defenders" or false
			else
				Defenders = Attackers
			end

			return Defenders or "Attackers"
		else
			return t2.value18.Team
		end
	end
	function t4.value48()
		if t2.value15:GetAttribute("MatchState") ~= "Lobby" then
			return
		end

		if workspace:GetAttribute("RoundState") == "Intermission" then
			v33("MapVoteTeleportRequest")
			t2.value22("Match: waiting for intermission")

			return
		end

		if workspace:GetAttribute("PickTeamAllowed") == false then
			t2.value22("Match: team selection closed")

			return
		end

		local Clients = t2.value19.Clients

		if Clients then
			Clients = t2.value19.Clients.PickTeam
		end

		local v632

		if Clients then
			local _open = Clients._open

			if type(_open) == "function" then
				local _select = Clients._select

				v632 = type(_select) == "function"
			else
				v632 = false
			end
		else
			v632 = Clients
		end

		if not v632 then
			v33("TeamPickerOpenRequest")
			task.wait(0.5)

			local Alive = t2.value19.Alive

			if Alive then
				Alive = t2.value15:GetAttribute("MatchState") == "Lobby"
			end

			if not Alive then
				return
			end

			v33("TeamRequest", t4.value47())
			task.wait(0.8)

			if not t2.value19.Alive then
				return
			end

			v33("LobbyCancelRequest", false)
			t2.value22("Team requested: " .. t4.value47())

			return
		end

		t2.value19.JoinPickerOwned = true
		Clients:_open(true)

		local v636 = os.clock() + 4
		local v637 = v636

		while true do
			local Alive = t2.value19.Alive

			if Alive then
				Alive = not Clients._picker.Enabled

				if Alive then
					if os.clock() < v637 then
						Alive = t2.value15:GetAttribute("MatchState") == "Lobby"
					else
						Alive = false
					end
				end
			end

			if not Alive then
				break
			end

			v636 = task.wait
			v636(0.1)
		end

		local Alive = t2.value19.Alive

		if Alive then
			Alive = Clients._picker.Enabled
		end

		if not Alive then
			v709 = t2.value19.Alive

			if v709 then
				v709 = not Clients._picker.Enabled

				if v709 then
					v709 = t2.value15:GetAttribute("MatchState") == "Lobby"
				end
			end

			if not v709 then
				t2.value19.JoinPickerOwned = false

				return
			end

			v33("TeamPickerOpenRequest")
			task.wait(0.4)

			if not t2.value19.Alive then
				t2.value19.JoinPickerOwned = false

				return
			end

			v33("TeamRequest", t4.value47())
			task.wait(0.5)

			if not t2.value19.Alive then
				t2.value19.JoinPickerOwned = false

				return
			end

			v33("LobbyCancelRequest", false)
			t2.value19.JoinPickerOwned = false

			return
		end

		local v640 = t4.value47() == "Attackers" and "Attacker" or "Defender"

		Clients._select(Clients, v640)
		task.wait(0.15)

		if t2.value19.Alive then
			Clients:_select(v640)
		end

		v636 = os.clock() + 5

		local v641 = v636

		while true do
			local Alive2 = t2.value19.Alive

			if Alive2 then
				Alive2 = Clients._picker.Enabled

				if Alive2 then
					Alive2 = os.clock() < v641
				end
			end

			if not Alive2 then
				break
			end

			task.wait(0.1)
		end

		t2.value22("Team requested: " .. t4.value47())

		local Alive2 = t2.value19.Alive

		if Alive2 then
			Alive2 = not Clients._picker.Enabled

			if Alive2 then
				Alive2 = t2.value15:GetAttribute("MatchState") == "Lobby"
			end
		end

		if not Alive2 then
			t2.value19.JoinPickerOwned = false

			return
		end

		v33("TeamPickerOpenRequest")
		task.wait(0.4)

		if not t2.value19.Alive then
			t2.value19.JoinPickerOwned = false

			return
		end

		v33("TeamRequest", t4.value47())
		task.wait(0.5)

		if not t2.value19.Alive then
			t2.value19.JoinPickerOwned = false

			return
		end

		v33("LobbyCancelRequest", false)
		t2.value19.JoinPickerOwned = false
	end
	function t4.value49()
		if t2.value15:GetAttribute("AwaitingRespawnUnit") == true then
			local value15 = t2.value15

			if (tonumber(value15:GetAttribute("DeathRetreatEndsAt")) or 0) > workspace:GetServerTimeNow() then
				return
			else
				local unitsInventory = v52(t2.value15, "UnitsInventory")
				local unitRespawnCooldowns = v52(t2.value15, "UnitRespawnCooldowns")
				local serverTimeNow = workspace:GetServerTimeNow()
				local t8 = {}

				for _, v in ipairs(unitsInventory.Loadout or {}) do
					local v651 = unitRespawnCooldowns[v.CopyId]
					local v652 = tonumber(v651)

					if not v652 then
						local v653 = unitRespawnCooldowns[v.TroopId]

						v652 = tonumber(v653) or 0
					end

					if v652 <= serverTimeNow then
						t8[#t8 + 1] = v.Slot
					end
				end

				local SpawnSlot = table.find(t8, t2.value18.SpawnSlot) and t2.value18.SpawnSlot or t8[1]

				if not SpawnSlot then
					return
				end

				v33("RespawnUnitRequest", SpawnSlot)
				t2.value22("Respawn requested: Slot " .. SpawnSlot)

				return
			end
		end
	end

	t4.value50 = nil

	function t4.value50()
		local _, _, v657 = v56()

		if v657 and t2.value15.Team then
			local v658 = t2.value15.Team.Name == "Attackers" and "Attacker" or false or "Defender"
			local ipairs_ = ipairs
			local value12 = t2.value12
			local v661 = nil
			local v662 = nil

			for _, v in ipairs_(value12.GetTagged(value12, "SupplyPoint")) do
				local Parent = v.Parent
				local v666 = v60(v)
				local ProximityPrompt = v:FindFirstChildWhichIsA("ProximityPrompt", true)
				local LocationMarker

				if Parent then
					LocationMarker = Parent:FindFirstChild("LocationMarker")
				else
					LocationMarker = Parent
				end

				local attribute

				if LocationMarker then
					attribute = LocationMarker:GetAttribute("OwnedBy")
				else
					attribute = LocationMarker
				end

				if not attribute then
					if Parent then
						attribute = Parent:GetAttribute("OwnedBy")
					else
						attribute = Parent
					end
				end

				local v670

				if LocationMarker then
					v670 = (tonumber(LocationMarker:GetAttribute("CapturePercent")) or 0) > 0
				else
					v670 = LocationMarker
				end

				if LocationMarker then
					LocationMarker = LocationMarker:GetAttribute("SupplyEnemyPresent")
				end

				if not LocationMarker then
					if Parent then
						LocationMarker = Parent:GetAttribute("SupplyEnemyPresent")
					else
						LocationMarker = Parent
					end
				end

				if v666 then
					local v671 = v:IsDescendantOf(workspace)

					if v671 then
						if Parent then
							if attribute == v658 then
								ProximityPrompt = true
							elseif attribute == nil then
								if ProximityPrompt then
									ProximityPrompt = ProximityPrompt.Enabled
								end
							else
								ProximityPrompt = false
							end

							if ProximityPrompt then
								ProximityPrompt = not v670

								if ProximityPrompt then
									ProximityPrompt = LocationMarker ~= true
								end
							end
						else
							ProximityPrompt = Parent
						end
					else
						ProximityPrompt = v671
					end
				else
					ProximityPrompt = v666
				end

				if ProximityPrompt then
					local Magnitude = (v657.Position - v666.Position).Magnitude

					if not v661 or Magnitude < v661 then
						v662 = v
						v661 = Magnitude
					end
				end
			end

			return v662, v661
		end
	end
	function t4.value51()
		if not t2.value25() then
			return false
		end

		local value15 = t2.value15

		if (tonumber(value15:GetAttribute("SupplyPointCooldownEndsAt")) or 0) > workspace:GetServerTimeNow() then
			return false
		end

		local MatchUI = v92("MatchUI", "SupplyPoint")
		local MatchUI2 = v92("MatchUI", "SpawnTroops")
		local Clients = t2.value19.Clients

		if Clients then
			Clients = t2.value19.Clients.Supply
		end

		if MatchUI2 then
			MatchUI2 = MatchUI2:FindFirstChild("SpawnProgress")
		end

		if Clients then
			Clients = Clients._spawningTroops
		end

		if Clients then
			MatchUI2 = Clients
		elseif MatchUI2 then
			MatchUI2 = MatchUI2.Visible
		end

		if MatchUI2 then
			v102()

			return true
		end

		if MatchUI then
			MatchUI = v78(MatchUI)
		end

		if MatchUI then
			v102()

			local s8 = "supplyBegin"
			local n1 = 8
			local now = os.clock()
			local v680

			if now < (t2.value19.Deadlines[s8] or 0) then
				v680 = false
			else
				t2.value19.Deadlines[s8] = now + n1
				v680 = true
			end

			if not v680 then
				return true
			end

			local unitsInventory = v52(t2.value15, "UnitsInventory")
			local unitRespawnCooldowns = v52(t2.value15, "UnitRespawnCooldowns")
			local t9 = {}

			for _, v in ipairs(unitsInventory.Loadout or {}) do
				local v686 = unitRespawnCooldowns[v.CopyId]

				if (tonumber(v686) or 0) <= workspace:GetServerTimeNow() then
					t9[#t9 + 1] = v.Slot
				end
			end

			local SupplySlot = table.find(t9, t2.value18.SupplySlot)

			if SupplySlot then
				SupplySlot = t2.value18.SupplySlot
			end

			local v688 = SupplySlot or t9[1]

			if not v688 then
				return true
			end

			v33("SupplyPointRequest", "Begin", v688)
			t2.value19.SupplyStarted = true
			t2.value22("Supply: Begin requested")

			return true
		else
			local v689, v690 = t4.value50()

			if not v689 then
				return false
			end

			local Character = t2.value15.Character
			local Humanoid

			if Character then
				Humanoid = Character:FindFirstChildOfClass("Humanoid")
			else
				Humanoid = Character
			end

			if Character then
				Character = Character:FindFirstChild("HumanoidRootPart")
			end

			local v693 = v60(v689)
			local ProximityPrompt = v689:FindFirstChildWhichIsA("ProximityPrompt", true)
			local v695

			if ProximityPrompt then
				local v696 = ProximityPrompt.MaxActivationDistance - 2

				v695 = math.max(4, v696)
			else
				v695 = ProximityPrompt
			end

			if v690 then
				v690 = (v695 or 8) < v690
			end

			if v690 then
				local s9 = "supplyFollow"
				local n2 = 3
				local now = os.clock()
				local v700

				if now < (t2.value19.Deadlines[s9] or 0) then
					v700 = false
				else
					t2.value19.Deadlines[s9] = now + n2
					v700 = true
				end

				if not v700 then
					t4.value45(v693.Position)

					return true
				end

				v33("TroopStateRequest", "Follow")
				t4.value45(v693.Position)

				return true
			else
				v102()

				local Enabled = ProximityPrompt and ProximityPrompt.Enabled

				if Enabled then
					local s10 = "supplyOpen"
					local n3 = 2
					local now = os.clock()

					if now < (t2.value19.Deadlines[s10] or 0) then
						Enabled = false
					else
						t2.value19.Deadlines[s10] = now + n3
						Enabled = true
					end
				end

				if not Enabled then
					return true
				end

				local fireproximityprompt_ = fireproximityprompt

				if type(fireproximityprompt_) == "function" then
					fireproximityprompt(ProximityPrompt)
				else
					ProximityPrompt:InputHoldBegin()
					task.wait(ProximityPrompt.HoldDuration + 0.1)

					if not t2.value19.Alive then
						return true
					end

					ProximityPrompt:InputHoldEnd()
				end

				return true
			end
		end
	end
	function t4.value52()
		local attribute = workspace:GetAttribute("CurrentObjective")
		local ActiveMap = workspace:FindFirstChild("ActiveMap")

		if attribute then
			if ActiveMap then
				ActiveMap = ActiveMap:FindFirstChild(attribute, true)
			end
		else
			ActiveMap = attribute
		end

		local Position = v60(ActiveMap)

		if not Position then
			return Position
		end

		Position = Position.Position

		return Position
	end

	local function order()
		if t2.value15:GetAttribute("CanCommandTroops") ~= true then
			return
		end

		if t2.value18.Order == "Rush" then
			local Target = t2.value19.Target or t4.value44()
			local v711 = v60((v71(v64())))

			if Target and v711 then
				local v712 = Target.root.Position - v711.Position
				local vector3 = Vector3.new(v712.X, 0, v712.Z)

				if vector3.Magnitude > 0.1 then
					v33("RushRequest", vector3.Unit, Target.root.Position)

					return
				else
					return
				end
			else
				return
			end
		end

		if t2.value18.Order == "Objective" and true or t2.value18.Order == "Supply" then
			local Position

			if t2.value18.Order == "Objective" then
				Position = t4.value52()
			else
				Position = v60((t4.value50()))

				if Position then
				elseif Position then
					v33("TroopStateRequest", "Follow")
					t4.value45(Position)

					return
				else
					return
				end

				Position = Position.Position
			end

			if Position then
				v33("TroopStateRequest", "Follow")
				t4.value45(Position)

				return
			else
				return
			end
		end

		v33("TroopStateRequest", t2.value18.Order)
	end

	function t4.value53()
		if t2.value15:GetAttribute("MatchState") ~= "Lobby" then
			return
		end

		local SummonCount = t2.value18.SummonCount
		local summonRequested = (tonumber(SummonCount) or 1) >= 6 and 10 or 1
		local GemCost, v718, value15

		if t2.value19.BannerState then
			v783 = t2.value19.BannerState.Banner

			if type(v783) == "table" then
				GemCost = v783.GemCost
				v718 = tonumber(GemCost)
			else
				v718 = false
			end

			if not v718 or (v783.Enabled ~= true and true or t2.value19.BannerState.Authoritative ~= true) then
				t2.value22("Summon: waiting for banner state")

				return
			end

			v784 = t2.value19.BannerState.Inventory

			if not v784 then
				if v784 then
					t2.value22("Summon: inventory full")
				else
					value15 = t2.value15

					if (tonumber(value15:GetAttribute("Gems")) or 0) - v718 * summonRequested < t2.value18.KeepGems then
						t2.value22("Summon: gem reserve reached")

						return
					else
						v33("BannerRequest", {
							Type = "Summon",
							BannerId = "Standard",
							RequestId = t2.value11:GenerateGUID(false),
							Count = summonRequested,
							SummonKey = t2.value11:GenerateGUID(false)
						})
						t2.value22("Summon requested: " .. summonRequested)

						return
					end
				end

				return
			end

			v785 = t2.value19.BannerState.Inventory.Available
			v784 = (tonumber(v785) or 0) < summonRequested

			if v784 then
				t2.value22("Summon: inventory full")
			else
				value15 = t2.value15

				if (tonumber(value15:GetAttribute("Gems")) or 0) - v718 * summonRequested < t2.value18.KeepGems then
					t2.value22("Summon: gem reserve reached")

					return
				else
					v33("BannerRequest", {
						Type = "Summon",
						BannerId = "Standard",
						RequestId = t2.value11:GenerateGUID(false),
						Count = summonRequested,
						SummonKey = t2.value11:GenerateGUID(false)
					})
					t2.value22("Summon requested: " .. summonRequested)

					return
				end
			end

			return
		end

		v33("BannerRequest", {
			Type = "GetState",
			RequestId = t2.value11:GenerateGUID(false)
		})

		local v720 = os.clock() + 4

		while true do
			local Alive = t2.value19.Alive

			if Alive then
				Alive = not t2.value19.BannerState

				if Alive then
					Alive = os.clock() < v720
				end
			end

			if not Alive then
				break
			end

			task.wait(0.1)
		end

		if not t2.value19.BannerState then
			t2.value22("Summon: waiting for banner state")

			return
		end

		local Banner = t2.value19.BannerState.Banner

		if type(Banner) == "table" then
			GemCost = Banner.GemCost
			v718 = tonumber(GemCost)
		else
			v718 = false
		end

		if not v718 or (Banner.Enabled ~= true and true or t2.value19.BannerState.Authoritative ~= true) then
			t2.value22("Summon: waiting for banner state")

			return
		end

		local Inventory = t2.value19.BannerState.Inventory

		if not Inventory then
			if Inventory then
				t2.value22("Summon: inventory full")
			else
				value15 = t2.value15

				if (tonumber(value15:GetAttribute("Gems")) or 0) - v718 * summonRequested < t2.value18.KeepGems then
					t2.value22("Summon: gem reserve reached")

					return
				else
					v33("BannerRequest", {
						Type = "Summon",
						BannerId = "Standard",
						RequestId = t2.value11:GenerateGUID(false),
						Count = summonRequested,
						SummonKey = t2.value11:GenerateGUID(false)
					})
					t2.value22("Summon requested: " .. summonRequested)

					return
				end
			end

			return
		end

		local Available = t2.value19.BannerState.Inventory.Available

		Inventory = (tonumber(Available) or 0) < summonRequested

		if Inventory then
			t2.value22("Summon: inventory full")
		else
			value15 = t2.value15

			if (tonumber(value15:GetAttribute("Gems")) or 0) - v718 * summonRequested < t2.value18.KeepGems then
				t2.value22("Summon: gem reserve reached")

				return
			else
				v33("BannerRequest", {
					Type = "Summon",
					BannerId = "Standard",
					RequestId = t2.value11:GenerateGUID(false),
					Count = summonRequested,
					SummonKey = t2.value11:GenerateGUID(false)
				})
				t2.value22("Summon requested: " .. summonRequested)

				return
			end
		end
	end
	function t4.value54()
		local unitsInventory = v52(t2.value15, "UnitsInventory")
		local t10 = {}

		for _, v in ipairs(unitsInventory.Loadout or {}) do
			t10[v.CopyId] = true
		end

		local Favorites = unitsInventory.Favorites or {}
		local v730, v731, v732 = ipairs(unitsInventory.Units or {})
		local t11 = {}

		while true do
			local v734

			v732, v734 = v730(v731, v732)

			if not v732 then
				break
			end

			local AscensionLevel = v734.AscensionLevel

			if (tonumber(AscensionLevel) or 0) < 3 then
				local TroopId = v734.TroopId
				local AscensionLevel2 = v734.AscensionLevel or 0
				local v738 = TroopId .. ":" .. tostring(AscensionLevel2)

				t11[v738] = t11[v738] or {}

				local v739 = t11[v738]

				table.insert(v739, v734)
			end
		end

		for _, v in pairs(t11) do
			if #v >= 2 then
				table.sort(v, function(p90, p91)
					local MasteryLevel = p90.MasteryLevel
					local v743 = tonumber(MasteryLevel) or 0
					local MasteryLevel2 = p91.MasteryLevel

					return (tonumber(MasteryLevel2) or 0) < v743
				end)

				local v745 = v[1]
				local v746 = nil

				for i = #v, 2, -1 do
					local v748 = not t10[v[i].CopyId]

					if v748 then
						v748 = Favorites[v[i].CopyId] ~= true
					end

					if v748 then
						v746 = v[i]

						break
					end
				end

				if v746 then
					v33("AscensionRequest", {
						RequestId = t2.value11:GenerateGUID(false),
						MainCopyId = v745.CopyId,
						DuplicateCopyId = v746.CopyId
					})
					t2.value22("Ascension requested: " .. v745.TroopId)

					return
				end
			end
		end

		t2.value22("Ascension: no eligible duplicate")
	end
	function t4.value55()
		local unitsInventory = v52(t2.value15, "UnitsInventory")

		for _, v in ipairs(unitsInventory.Units or {}) do
			local EvolutionPreview = v.EvolutionPreview
			local v753

			if type(EvolutionPreview) == "table" then
				local MasteryLevel = v.MasteryLevel

				v753 = (tonumber(MasteryLevel) or 0) >= 20
			else
				v753 = false
			end

			if v753 then
				v33("EvolutionRequest", {
					RequestId = t2.value11:GenerateGUID(false),
					CopyId = v.CopyId
				})
				t2.value22("Evolution requested: " .. v.TroopId)

				return
			end
		end

		t2.value22("Evolution: no unit with Mastery 20")
	end
	function t4.value56()
		local DailyRewardRequest = t2.value24("DailyRewardRequest", {
			Type = "GetState"
		})

		if not t2.value19.Alive then
			return
		end

		local State = type(DailyRewardRequest) == "table" and DailyRewardRequest.State

		if State then
			State = DailyRewardRequest.State.CanClaim == true
		end

		if not State then
			v817 = t2.value22
			v818 = type(DailyRewardRequest) == "table" and (DailyRewardRequest.Status or "no response") or "no response"
			v817("Daily: " .. tostring(v818))

			return
		end

		DailyRewardRequest = t2.value24("DailyRewardRequest", {
			Type = "Claim"
		})

		local value22 = t2.value22
		local Status = type(DailyRewardRequest) == "table" and (DailyRewardRequest.Status or "no response") or "no response"

		value22("Daily: " .. tostring(Status))
	end
	function t4.value57()
		local QuestRequest = t2.value24("QuestRequest", {
			Type = "GetState"
		})
		local n4 = 0
		local v761 = type(QuestRequest) == "table"

		if v761 then
			v761 = QuestRequest.State

			if v761 then
				v761 = QuestRequest.State.Periods
			end
		end

		if not v761 then
			t2.value22("Quests: " .. n4 .. " new rewards claimed")

			return
		end

		for k, period in pairs(QuestRequest.State.Periods) do
			for _, v in ipairs(period.Quests or {}) do
				if not t2.value19.Alive then
					return
				end

				local v766

				if v.Completed == true then
					v766 = v.Claimed ~= true
				else
					v766 = false
				end

				if v766 then
					local QuestRequest2 = t2.value24("QuestRequest", {
						Type = "Claim",
						Period = k,
						QuestId = v.Id
					})
					local v768

					if type(QuestRequest2) == "table" then
						v768 = QuestRequest2.Status == "Claimed"
					else
						v768 = false
					end

					if v768 then
						n4 = n4 + 1
					end

					task.wait(0.35)
				end
			end
		end

		t2.value22("Quests: " .. n4 .. " new rewards claimed")
	end
	function t4.value58()
		local Target = t2.value19.Target or t4.value44()
		local v770 = v64()
		local v771 = v71(v770)

		if not t2.value25() or (t2.value15:GetAttribute("CanCommandTroops") ~= true or (not v771 or (not Target or Target.distance > t2.value18.VolleyRange))) then
			return
		end

		if v771:GetAttribute("CombatType") ~= "Ranged" then
			t2.value22("Volley needs ranged troops")

			return
		end

		local v772 = nil
		local Modules = t2.value16.Modules
		local Troops = Modules:FindFirstChild("Troops")

		if Troops then
			Troops = Troops:FindFirstChild("AimFirePolicy")
		end

		if Troops then
			local pcall_ = pcall
			local ok

			ok, Modules = pcall_(require, Troops)

			if ok then
				v772 = Modules
			else
				Modules = pcall_
			end
		end

		local obj = setmetatable({}, {
			__mode = "k"
		})

		v33("AimVolleyState", true, Target.root.Position, 9)
		t2.value19.VolleyStarted = true

		local v778 = os.clock() + 9

		while true do
			local Alive = t2.value19.Alive

			if Alive then
				Alive = t2.value18.AutoVolley or t2.value19.Pending["action:volley"]

				if Alive then
					if os.clock() < v778 then
						Alive = Target.root.Parent
					else
						Alive = false
					end
				end
			end

			if not Alive then
				break
			end

			for _, child in ipairs(v770:GetChildren()) do
				local v782 = v60(child)
				local now = os.clock()
				local isModel = child:IsA("Model")

				if isModel then
					if v782 then
						isModel = child:GetAttribute("CombatType") == "Ranged"

						if isModel then
							if child:GetAttribute("ClientVisualProxy") == true then
								isModel = false
							else
								isModel = v62(child) > 0
							end
						end
					else
						isModel = v782
					end
				end

				if isModel then
					local Position = Target.root.Position
					local v786 = Position - v782.Position
					local v787 = v782.AssemblyLinearVelocity.Magnitude < 1
					local v788 = Vector3.new(v786.X, 0, v786.Z).Magnitude <= (tonumber(child:GetAttribute("Range")) or t2.value18.VolleyRange)
					local v789

					if v772 then
						local CanFire = v772.CanFire

						v789 = type(CanFire) == "function"
					else
						v789 = v772
					end

					if v789 then
						if v788 then
							v788 = v772:CanFire(child, v782, Position, v787)
						end
					end

					if v788 then
						local v791 = now - (obj[child] or 0)
						local v792 = tonumber(child:GetAttribute("AttackInterval")) or 2

						v788 = math.max(0.1, v792) <= v791
					end

					if v788 then
						obj[child] = now

						local v793 = (tonumber(child:GetAttribute("AimAttackTick")) or 0) + 1

						child:SetAttribute("AimAttackTick", v793)

						local v794 = tonumber(child:GetAttribute("AttackDelay")) or 0
						local v795 = math.max(0, v794)
						local v796 = nil

						local function v797()
							task.wait(v796)

							if t2.value19.Alive and (v782.Parent and Target.root.Parent) then
								local v798 = child
								local v799 = v782.Position + v782.CFrame.LookVector * 2 + Vector3.new(0, tonumber(v798:GetAttribute("ArrowOriginHeight")) or 2.5, 0)

								Position = Target.root.Position

								local Magnitude = Vector3.new(Position.X - v799.X, 0, Position.Z - v799.Z).Magnitude
								local v801 = child
								local v802 = tonumber(v801:GetAttribute("Range")) or Magnitude
								local v803 = math.max(1, v802)
								local n5, n6

								if child:GetAttribute("RangedTrajectory") == "Line" then
									n5 = 0.12
									n6 = 0.03
								else
									n5 = 0.5
									n6 = 0.12
								end

								local v806 = n5 - n6
								local v807 = Magnitude / v803
								local v808 = math.clamp(v807, 0, 1)
								local Lerp = v799.Lerp
								local v810 = Magnitude * (n6 + v806 * v808)

								v33("AimArrowFire", child, v793, v799, Lerp(v799, Position, 0.5) + Vector3.new(0, v810, 0), Position, Magnitude / 150)
							end
						end

						v796 = v795
						v22(child, v797)
					end
				end
			end

			task.wait(0.1)
		end

		if not t2.value19.Alive then
			return
		end

		v33("AimVolleyState", false)
		t2.value19.VolleyStarted = false
	end
	function t4.value59()
		if t2.value15:GetAttribute("InCannon") ~= true then
			t2.value22("Cannon: occupy a cannon first")

			return
		end

		v33("CannonAim", t2.value18.CannonYaw, t2.value18.CannonPitch)
		task.wait(0.35)

		if not t2.value19.Alive then
			return
		end

		v33("CannonFire")
		t2.value22("Cannon: fire requested")
	end
	function t4.value60()
		local Target = t2.value19.Target or t4.value44()
		local v812 = not t2.value25()

		if not v812 then
			v812 = not Target

			if not v812 then
				local value15 = t2.value15

				v812 = (tonumber(value15:GetAttribute("CatapultCount")) or 0) < 1
			end
		end

		if v812 then
			return
		end

		local value15 = t2.value15

		if (tonumber(value15:GetAttribute("CatapultCooldownEndsAt")) or 0) > workspace:GetServerTimeNow() then
			return
		end

		local raycastParams = RaycastParams.new()

		raycastParams.FilterType = Enum.RaycastFilterType.Exclude

		local Character = t2.value15.Character
		local workspace_ = workspace

		raycastParams.FilterDescendantsInstances = { Character, workspace_.FindFirstChild(workspace_, "Troops") }

		local workspace_2 = workspace
		local Position = Target.root.Position
		local Vector3_ = Vector3
		local v821 = workspace_2.Raycast(workspace_2, Position + Vector3_.new(0, 30, 0), Vector3.new(0, -100, 0), raycastParams)

		if not v821 then
			t2.value22("Catapult: no ground below target")

			return
		end

		local Remotes = t2.value16.Catapult.Remotes

		Remotes.TargetingState:FireServer(true)
		t2.value19.CatapultStarted = true
		task.wait(0.15)

		if not t2.value19.Alive then
			return
		end

		Remotes.RequestStrike:FireServer(t2.value11:GenerateGUID(false), v821.Position, v821.Normal)
		Remotes.TargetingState:FireServer(false)
		t2.value19.CatapultStarted = false
		t2.value22("Catapult: strike requested")
	end
	function t2.value19.PulseAFK(p92)
		local v823, v824, v825 = v56()

		if not v824 or (not v825 or (v824.Health <= 0 or (v824.Sit or t2.value15:GetAttribute("InCannon") == true))) then
			t2.value22("Anti-AFK: movement postponed while seated or respawning")

			return false
		end

		local RightVector = v825.CFrame.RightVector
		local Unit = Vector3.new(RightVector.X, 0, RightVector.Z).Unit
		local raycastParams = RaycastParams.new()

		raycastParams.FilterType = Enum.RaycastFilterType.Exclude
		raycastParams.FilterDescendantsInstances = { v823 }
		raycastParams.RespectCanCollide = true

		if not workspace:Raycast(v825.Position + Unit * 1.5, Vector3.new(0, -9, 0), raycastParams) or workspace:Raycast(v825.Position, Unit * 2, raycastParams) then
			Unit = -Unit
		end

		p92.AFKEpisode = {
			start = os.clock(),
			direction = Unit,
			origin = v825.Position,
			last = v825.Position,
			distance = 0,
			root = v825
		}
		p92.NextAFK = os.clock() + 300

		local VirtualUser = game:GetService("VirtualUser")

		pcall(function()
			VirtualUser:CaptureController()
			VirtualUser:ClickButton2(Vector2.new(1, 1), workspace.CurrentCamera.CFrame)
		end)
		t2.value22("Anti-AFK: brief movement started")

		return true
	end
	function t4.value61()
		local t12 = {}
		local Character = t2.value15.Character
		local Humanoid

		if Character then
			Humanoid = Character:FindFirstChildOfClass("Humanoid")
		else
			Humanoid = Character
		end

		if Character then
			Character = Character:FindFirstChild("HumanoidRootPart")
		end

		local function v833(p93, p94, p95, p96)
			local v834

			if p96 then
				v834 = not t2.value18.Allies
			else
				v834 = p96
			end

			if v834 then
				return
			end

			local v835 = v60(p94)

			if not v835 then
				return
			end

			t12[p93] = true

			local v836 = t2.value19.ESP[p93]
			local v837

			if not v836 or (v836[1].Adornee ~= p94 and true or v836[2].Adornee ~= v835) then
				if v836 then
					for _, v in ipairs(v836) do
						v:Destroy()
					end
				end

				local Highlight = t4.value2("Highlight", {
					Name = "cultESP",
					Adornee = p94,
					DepthMode = Enum.HighlightDepthMode.AlwaysOnTop,
					FillTransparency = 0.85,
					OutlineTransparency = 0.1
				}, t4.value3)
				local BillboardGui = t4.value2("BillboardGui", {
					Name = "cultESPLabel",
					Adornee = v835,
					AlwaysOnTop = true,
					Size = UDim2.fromOffset(210, 42),
					StudsOffset = Vector3.new(0, 4, 0)
				}, t4.value3)
				local v842 = v189(BillboardGui, p95, 11, t2.value20.text, true)

				v842.Size = UDim2.fromScale(1, 1)
				v842.TextXAlignment = Enum.TextXAlignment.Center
				v842.TextWrapped = true
				v842.TextStrokeTransparency = 0.4
				v836 = { Highlight, BillboardGui, v842 }
				t2.value19.ESP[p93] = v836
				v837 = v836
			else
				v837 = v836
			end

			local v843 = v836[1]
			local s11 = "FillColor"

			if not p96 then
				v843[s11] = p96 or t2.value20.red
				v836[1].OutlineColor = v836[1].FillColor
				v836[3].Text = p95

				return
			end

			p96 = t2.value20.muted
			v843[s11] = p96 or t2.value20.red
			v836[1].OutlineColor = v836[1].FillColor
			v836[3].Text = p95
		end

		local ipairs_

		if t2.value18.PlayerESP then
			ipairs_ = ipairs

			local value7 = t2.value7

			for _, player in ipairs_(value7.GetPlayers(value7)) do
				local v849 = player ~= t2.value15

				if v849 then
					v849 = player.Character

					if v849 then
						v849 = v60(player.Character)
					end
				end

				if v849 then
					ipairs_ = player.Character

					local Humanoid2 = ipairs_:FindFirstChildOfClass("Humanoid")
					local v851

					if Character then
						local Magnitude = (Character.Position - v60(player.Character).Position).Magnitude

						v851 = math.floor(Magnitude)
					else
						v851 = Character
					end

					local v853 = v851 or 0
					local Character2 = player.Character
					local DisplayName = player.DisplayName
					local Health = Humanoid2 and Humanoid2.Health or 0

					v833(player, Character2, DisplayName .. " | " .. v853 .. " studs\nHP " .. math.floor(Health), player.Team == t2.value15.Team)
				end
			end
		else
			ipairs_ = v833
		end

		if not t2.value18.TroopESP then
			for k, v in pairs(t2.value19.ESP) do
				if not t12[k] then
					for _, v2 in ipairs(v) do
						v2:Destroy()
					end

					t2.value19.ESP[k] = nil
				end
			end

			return
		end

		local Troops = workspace:FindFirstChild("Troops")

		if not Troops then
			for k, v in pairs(t2.value19.ESP) do
				if not t12[k] then
					for _, v2 in ipairs(v) do
						v2:Destroy()
					end

					t2.value19.ESP[k] = nil
				end
			end

			return
		end

		local GetChildren = Troops.GetChildren

		for _, v in ipairs(GetChildren(Troops)) do
			local v869 = v71(v)

			if v869 then
				local v870 = tostring(v:GetAttribute("TroopId") or (v869:GetAttribute("TroopId") or v.Name))
				local GetAttribute = v.GetAttribute
				local v872 = tostring(GetAttribute(v, "TroopCount") or #v:GetChildren())
				local attribute = v869:GetAttribute("Team") or ""
				local v874 = v870 .. " | " .. v872 .. " units\n" .. tostring(attribute)
				local Team = t2.value15.Team

				if Team then
					Team = v869:GetAttribute("Team") == t2.value15.Team.Name
				end

				v833(v, v869, v874, Team)
			end
		end

		for k, v in pairs(t2.value19.ESP) do
			if not t12[k] then
				for _, v2 in ipairs(v) do
					v2:Destroy()
				end

				t2.value19.ESP[k] = nil
			end
		end
	end
	function t4.value20.afkNow()
		t2.value19:PulseAFK()
	end

	t4.value20.join = t4.value48
	t4.value20.respawn = t4.value49
	t4.value20.supply = t4.value51
	t4.value20.order = order

	function t4.value20.follow()
		v33("TroopStateRequest", "Follow")
	end
	function t4.value20.attack()
		v33("TroopStateRequest", "Attack")
	end

	local function v880()
		local value22 = t2.value2

		if not value22 then
			value22 = queueonteleport

			if not value22 then
				value22 = syn

				if value22 then
					value22 = syn.queue_on_teleport
				end
			end
		end

		local v882 = type(value22) ~= "function"
		local v883

		if v882 then
			if v882 then
				return false
			elseif pcall(readfile, "cult-command-an-army.luau") then
				v883 = table.clone(t2.value18)
				v883.AutoSummon = false
				v883.AutoAscend = false
				v883.AutoEvolve = false
				v883.AutoCatapult = false
				writefile("cult-caa-teleport.json", t2.value11:JSONEncode({
					Active = true,
					Session = t2.value19.Session,
					Config = v883
				}))
				value22("pcall(function()task.wait(6);local h=game:GetService(\"HttpService\");local ok,s=pcall(function()return h:JSONDecode(readfile(\"cult-caa-teleport.json\"))end);if ok and type(s)==\"table\"and s.Active then local f=loadstring(readfile(\"cult-command-an-army.luau\"));if type(f)==\"function\"then local c=f();if c then for k,v in pairs(s.Config or {})do if c.Config[k]~=nil then c:Set(k,v)end end end end end end)")

				return true
			else
				return false
			end
		end

		local writefile_ = writefile

		if type(writefile_) == "function" then
			local readfile_ = readfile

			v882 = type(readfile_) ~= "function"
		else
			v882 = true
		end

		if v882 then
			return false
		elseif pcall(readfile, "cult-command-an-army.luau") then
			v883 = table.clone(t2.value18)
			v883.AutoSummon = false
			v883.AutoAscend = false
			v883.AutoEvolve = false
			v883.AutoCatapult = false
			writefile("cult-caa-teleport.json", t2.value11:JSONEncode({
				Active = true,
				Session = t2.value19.Session,
				Config = v883
			}))
			value22("pcall(function()task.wait(6);local h=game:GetService(\"HttpService\");local ok,s=pcall(function()return h:JSONDecode(readfile(\"cult-caa-teleport.json\"))end);if ok and type(s)==\"table\"and s.Active then local f=loadstring(readfile(\"cult-command-an-army.luau\"));if type(f)==\"function\"then local c=f();if c then for k,v in pairs(s.Config or {})do if c.Config[k]~=nil then c:Set(k,v)end end end end end end)")

			return true
		else
			return false
		end
	end

	for i = 1, 3 do
		t4.value20["formation" .. i] = function()
			v33("TroopStateRequest", "Formation" .. i)
		end
	end

	function t4.value20.heal()
		if t2.value15:GetAttribute("CanUseCombat") ~= true then
			return
		end

		v33("PlayerCombatRequest", "Heal")
	end
	function t4.value20.retreat()
		if t2.value15:GetAttribute("IsDead") == true then
			v33("DeathRetreatRequest")
		else
			v33("TroopStateRequest", "Follow")
			t2.value22("Retreat: Troops following")
		end
	end
	function t4.value20.equip()
		v33("UnitInventoryRequest", "EquipBest")
		t2.value22("Equip Best requested")
	end

	t4.value20.summon = t4.value53
	t4.value20.ascend = t4.value54
	t4.value20.evolve = t4.value55
	t4.value20.daily = t4.value56
	t4.value20.quests = t4.value57
	t4.value20.volley = t4.value58
	t4.value20.cannon = t4.value59
	t4.value20.catapult = t4.value60

	function t4.value20.clearTarget()
		t2.value19.Target = nil
		v102()
		t2.value22("Target Lock released")
	end
	function t4.value20.extras()
		if v83((v92("HUD", "LeftBar", "Units"))) then
			return
		end

		t2.value22("Extras: open the game Units menu to manage favorites and extras")
	end
	function t4.value20.codes()
		local Codes = t2.value18.Codes

		for match in Codes.gmatch(Codes, "[^,;\n]+") do
			local match2 = match:match("^%s*(.-)%s*$")
			local v890

			if match2 == "" then
				v890 = false
			else
				v890 = t2.value19.Alive
			end

			if v890 then
				local RedeemCode = t2.value24("RedeemCode", match2)
				local value22 = t2.value22
				local tostring_ = tostring
				local Status

				if type(RedeemCode) == "table" then
					Status = RedeemCode.Status
				else
					Status = false
				end

				value22(match2 .. ": " .. tostring_(Status or RedeemCode))
				task.wait(0.75)
			end
		end
	end
	function t4.value20.objective()
		local v895 = t4.value52()

		if v895 then
			t4.value45(v895)
			t2.value19.ManualGoal = v895
			t2.value22("Objective: travel started")
		else
			t2.value22("Objective: current objective missing")
		end
	end
	function t4.value20.travelSupply()
		local v896 = v60((t4.value50()))

		if not v896 then
			return
		end

		t4.value45(v896.Position)
		t2.value19.ManualGoal = v896.Position
	end
	function t4.value20.stop()
		t2.value19.ManualGoal = nil
		v102()
	end
	function t4.value20.reset()
		for k, v in pairs(t2.value18) do
			if type(v) == "boolean" then
				t2.value19:Set(k, false)
			end
		end

		t2.value22("all features disabled")
	end

	t2.value19.Clients = {}

	function t4.value62()
		local getgc_2 = getgc

		if type(getgc_2) == "function" then
			local ipairs_ = ipairs

			for _, v in ipairs_(getgc(true)) do
				if type(v) == "table" then
					local value = rawget(v, "_playerStamina")
					local v904 = type(value) == "number"

					if v904 then
						local value3 = rawget(v, "_horseStamina")

						if type(value3) == "number" then
							v904 = rawget(v, "_pendingSpends")
						else
							v904 = false
						end
					end

					if v904 then
						ipairs_ = t2.value19.Clients
						ipairs_.Stamina = v
					end

					local v906 = rawget(v, "_player") == t2.value15

					if v906 then
						local value3 = rawget(v, "_rollSequence")

						if type(value3) == "number" then
							local value4 = rawget(v, "_rollReadyAt")

							v906 = type(value4) == "number"
						else
							v906 = false
						end
					end

					if v906 then
						ipairs_ = t2.value19.Clients
						ipairs_.Roll = v
					end

					local v909 = rawget(v, "_player") == t2.value15

					if v909 then
						v909 = rawget(v, "_revealResults")

						if v909 then
							v909 = rawget(v, "_summoned")
						end
					end

					if v909 then
						ipairs_ = t2.value19.Clients
						ipairs_.Summon = v
					end

					local value3

					if rawget(v, "_remote") == t2.value17:FindFirstChild("RankedPartyRequest") then
						value3 = rawget(v, "_queueChanged")
					else
						value3 = false
					end

					if value3 then
						ipairs_ = t2.value19.Clients
						ipairs_.Ranked = v
					end

					local value4

					if rawget(v, "_teamRequest") == t2.value17:FindFirstChild("TeamRequest") then
						value4 = rawget(v, "_buttons")
					else
						value4 = false
					end

					if value4 then
						ipairs_ = t2.value19.Clients
						ipairs_.PickTeam = v
					end

					local value5 = rawget(v, "_player") == t2.value15 and rawget(v, "_tracks")

					if value5 then
						value5 = rawget(v, "_request") == t2.value17:FindFirstChild("PlayerCombatRequest")
					end

					if value5 then
						ipairs_ = t2.value19.Clients
						ipairs_.Combat = v
					end

					local value6

					if rawget(v, "_player") == t2.value15 then
						value6 = rawget(v, "_markersByModel")
					else
						value6 = false
					end

					if value6 then
						ipairs_ = t2.value19.Clients
						ipairs_.Supply = v
					end
				end
			end
		end
	end

	t2.value19.ResolveClients = t4.value62
	pcall(t4.value62)
	Priority = t2.value19
	t5 = "Capabilities"
	v204 = "Filesystem"
	v203 = readfile

	if type(v203) == "function" then
		v203 = writefile
		v203 = type(v203) == "function"
	else
		v203 = false
	end

	layoutOrder = "CustomFonts"
	v197 = t2.value1
	v197 = type(v197) == "function"
	v196 = "TeleportQueue"
	value2 = t2.value2
	value2 = type(value2) == "function"

	if not value2 then
		value2 = queueonteleport
		value2 = type(value2) == "function"

		if not value2 then
			value2 = syn

			if type(value2) == "table" then
				value2 = syn.queue_on_teleport
				value2 = type(value2) == "function"
			else
				value2 = false
			end
		end
	end

	getgc_ = getgc
	getgc_ = type(getgc_) == "function"
	parent = gethui
	parent = type(parent) == "function"
	game_ = fireproximityprompt
	Priority[t5] = {
		[v204] = v203,
		[layoutOrder] = v197,
		[v196] = value2,
		ClientState = getgc_,
		UIParent = parent,
		Prompt = type(game_) == "function"
	}
	t2.value19.OriginalHitboxes = setmetatable({}, {
		__mode = "k"
	})

	function t2.value19.RestoreHitboxes()
		for k, originalHitboxe in pairs(t2.value19.OriginalHitboxes) do
			if k.Parent then
				pcall(function()
					k.Size = originalHitboxe.Size
					k.Transparency = originalHitboxe.Transparency
					k.CanCollide = originalHitboxe.CanCollide
					k.Massless = originalHitboxe.Massless
				end)
			end

			t2.value19.OriginalHitboxes[k] = nil
		end
	end
	function t4.value63()
		local t13 = {}
		local Hitbox = t2.value18.Hitbox

		if Hitbox then
			Hitbox = t2.value25()
		end

		if not Hitbox then
			for k, originalHitboxe in pairs(t2.value19.OriginalHitboxes) do
				if not t13[k] then
					if k.Parent then
						k.Size = originalHitboxe.Size
						k.Transparency = originalHitboxe.Transparency
						k.CanCollide = originalHitboxe.CanCollide
						k.Massless = originalHitboxe.Massless
					end

					t2.value19.OriginalHitboxes[k] = nil
				end
			end

			return
		end

		for _, v in ipairs(t4.value43()) do
			local root = v.root
			local Parent = root.Parent

			if Parent then
				Parent = v.distance <= t2.value18.SearchRange
			end

			if Parent then
				t13[root] = true

				if not t2.value19.OriginalHitboxes[root] then
					t2.value19.OriginalHitboxes[root] = {
						Size = root.Size,
						Transparency = root.Transparency,
						CanCollide = root.CanCollide,
						Massless = root.Massless
					}
				end

				root.Size = Vector3.one * t2.value18.HitboxSize
				root.Transparency = 0.8
				root.CanCollide = false
				root.Massless = true
			end
		end

		for k, originalHitboxe in pairs(t2.value19.OriginalHitboxes) do
			if not t13[k] then
				if k.Parent then
					k.Size = originalHitboxe.Size
					k.Transparency = originalHitboxe.Transparency
					k.CanCollide = originalHitboxe.CanCollide
					k.Massless = originalHitboxe.Massless
				end

				t2.value19.OriginalHitboxes[k] = nil
			end
		end
	end
	function t4.value64()
		local Stamina = t2.value19.Clients.Stamina

		if Stamina then
			if t2.value18.PlayerStamina then
				Stamina._playerStamina = Stamina._playerMax
				Stamina._playerSprintCancelled = false
			end

			if t2.value18.HorseStamina then
				Stamina._horseStamina = Stamina._horseMax
				Stamina._horseSprintCancelled = false
			end
		end

		local Roll = t2.value19.Clients.Roll
		local InfiniteRoll

		if Roll then
			InfiniteRoll = t2.value18.InfiniteRoll
		else
			InfiniteRoll = Roll
		end

		if InfiniteRoll then
			Roll._rollReadyAt = 0
		end

		if t2.value18.AntiStun then
			local Character = t2.value15.Character
			local Humanoid

			if Character then
				Humanoid = Character:FindFirstChildOfClass("Humanoid")
			else
				Humanoid = Character
			end

			if Character then
				Character:FindFirstChild("HumanoidRootPart")
			end

			if t2.value15:GetAttribute("CombatState") == "Stunned" then
				if t2.value19.StunState == nil then
					t2.value19.StunState = "Stunned"
				end

				t2.value15:SetAttribute("CombatState", "Idle")

				if Humanoid then
					Humanoid.PlatformStand = false

					if not t2.value18.Speed then
						local value15 = t2.value15

						Humanoid.WalkSpeed = tonumber(value15:GetAttribute("WalkSpeed")) or Humanoid.WalkSpeed
					end
				end
			end

			local Combat = t2.value19.Clients.Combat
			local v933

			if Combat then
				local _stopTrack = Combat._stopTrack

				v933 = type(_stopTrack) == "function"
			else
				v933 = Combat
			end

			if v933 then
				Combat:_stopTrack("Stun", 0)
				Combat:_stopTrack("BlockBreak", 0)
			end
		end

		if not t2.value18.SkipSummon then
			return
		end

		local Summon = t2.value19.Clients.Summon
		local _started

		if Summon then
			_started = Summon._started
		else
			_started = Summon
		end

		if not _started then
			return
		end

		local _visualizerActive = Summon._visualizerActive

		if _visualizerActive then
			local _visualizerResolvedResults = Summon._visualizerResolvedResults

			_visualizerActive = type(_visualizerResolvedResults) == "table"
		end

		if _visualizerActive then
			local _visualizerResolvedResults = Summon._visualizerResolvedResults

			if type(Summon._cancelVisualizer) == "function" then
				Summon:_cancelVisualizer()
			end

			local _openReveal = Summon._openReveal

			if type(_openReveal) == "function" then
				Summon:_openReveal(_visualizerResolvedResults, true)
			end
		end

		local _revealOpen = Summon._revealOpen

		if _revealOpen then
			local _closeReveal = Summon._closeReveal

			_revealOpen = type(_closeReveal) == "function"
		end

		if not _revealOpen then
			return
		end

		Summon:_closeReveal()
	end

	t2.value19.ClientStateStep = t4.value64
	t2.value19.HitboxStep = t4.value63

	function t4.value20.roll()
		local Roll = t2.value19.Clients.Roll

		if not Roll then
			t4.value62()
			Roll = t2.value19.Clients.Roll
		end

		local v944

		if Roll then
			local _tryRoll = Roll._tryRoll

			v944 = type(_tryRoll) == "function"
		else
			v944 = Roll
		end

		if not v944 then
			t2.value22("Dodge Roll needs access to the game client controller")

			return
		end

		if not t2.value18.InfiniteRoll then
			return Roll._tryRoll(Roll)
		end

		Roll._rollReadyAt = 0

		return Roll._tryRoll(Roll)
	end

	Priority = t2.value16.Modules:FindFirstChild("RankedRegions")
	t2.value19.RankedRegions = { "Auto" }
	t2.value19.RankedRegionIds = {}

	if Priority then
		Priority, t5 = pcall(require, Priority)

		if Priority then
			Priority = type(t5) == "table"
		end

		if Priority then
			for _, v in ipairs(t5.Options or {}) do
				t2.value19.RankedRegions[#t2.value19.RankedRegions + 1] = v.Name or v.Id
				t2.value19.RankedRegionIds[v.Name or v.Id] = v.Id
			end
		end
	end

	function t4.value20.ranked()
		if t2.value15:GetAttribute("MatchState") ~= "Lobby" then
			t2.value22("Ranked Queue requires the lobby")

			return
		end

		if workspace:GetAttribute("RankedQueueEnabled") ~= true then
			t2.value22("Ranked Queue is closed")

			return
		end

		local Ranked = t2.value19.Clients.Ranked
		local v949

		if Ranked then
			v949 = Ranked
		else
			t4.value62()
			Ranked = t2.value19.Clients.Ranked
			v949 = Ranked
		end

		local v950 = not Ranked

		if not v950 then
			local _request = Ranked._request

			v950 = type(_request) ~= "function"
		end

		if v950 then
			t2.value22("Ranked controller unavailable")

			return
		end

		local Snapshot = Ranked:_request("Snapshot", nil, true)
		local value19 = t2.value19
		local s12 = "RankedState"
		local State

		if type(Snapshot) == "table" then
			State = Snapshot.State
		else
			State = false
		end

		value19[s12] = State or Ranked._state

		local _state = Ranked._state

		if _state then
			_state = Ranked._state.Matchmaking
		end

		if _state then
			t2.value22("Ranked matchmaking already active")

			return
		end

		local RankedState = t2.value19.RankedState

		if RankedState then
			RankedState = t2.value19.RankedState.Party
		end

		local v958 = t2.value18.RankedRegion ~= "Auto"

		if v958 then
			v958 = t2.value19.RankedRegionIds[t2.value18.RankedRegion] and RankedState
		end

		if v958 then
			Ranked:_request("SetRegion", {
				RegionId = t2.value19.RankedRegionIds[t2.value18.RankedRegion],
				PartyId = RankedState.PartyId
			}, true)
		end

		local FindMatch = Ranked:_request("FindMatch", nil, true)

		t2.value19.RankedResult = FindMatch

		local value22 = t2.value22
		local s13 = "Ranked: "
		local tostring_ = tostring
		local v963 = type(FindMatch) == "table"

		if not v963 then
			value22(s13 .. tostring_(v963 or FindMatch))

			return
		end

		v963 = FindMatch.Code or FindMatch.OK
		value22(s13 .. tostring_(v963 or FindMatch))
	end
	function t4.value20.rankedCancel()
		t2.value19:Set("RankedQueue", false)

		local Ranked = t2.value19.Clients.Ranked
		local v965

		if Ranked then
			local _request = Ranked._request

			v965 = type(_request) == "function"
		else
			v965 = Ranked
		end

		if not v965 then
			return
		end

		t2.value19.RankedResult = Ranked:_request("CancelFindMatch", nil, true)
		t2.value22("Ranked cancellation requested")
	end

	t2.value19.Staff = {}

	local function v967(p97)
		if not p97.Parent or p97 == t2.value15 then
			return
		end

		local v968 = nil
		local StaffDetector

		if game.CreatorType == Enum.CreatorType.User then
			if p97.UserId == game.CreatorId then
				v968 = "Experience Owner"
			end
		else
			if game.CreatorType ~= Enum.CreatorType.Group then
				t2.value19.Staff[p97.UserId] = v968 or false

				if v968 then
					StaffDetector = t2.value18.StaffDetector
				else
					StaffDetector = v968
				end

				if not StaffDetector then
					return
				end

				t2.value22("Staff indicator: " .. p97.DisplayName .. " | " .. v968)

				return
			end

			local ok, result = pcall(function()
				return p97:GetRoleInGroup(game.CreatorId)
			end)

			if ok then
				ok = type(result) == "string"
			end

			if not ok then
				t2.value19.Staff[p97.UserId] = v968 or false

				if v968 then
					StaffDetector = t2.value18.StaffDetector
				else
					StaffDetector = v968
				end

				if not StaffDetector then
					return
				end

				t2.value22("Staff indicator: " .. p97.DisplayName .. " | " .. v968)

				return
			end

			local v972 = result.lower(result)

			for _, v in ipairs({
				"owner",
				"admin",
				"moderator",
				"developer",
				"staff"
			}) do
				if v972:find(v, 1, true) then
					v968 = result

					break
				end
			end
		end

		t2.value19.Staff[p97.UserId] = v968 or false

		if v968 then
			StaffDetector = t2.value18.StaffDetector
		else
			StaffDetector = v968
		end

		if not StaffDetector then
			return
		end

		t2.value22("Staff indicator: " .. p97.DisplayName .. " | " .. v968)
	end

	function t4.value20.staff()
		local ipairs_ = ipairs
		local value7 = t2.value7

		for _, player in ipairs_(value7.GetPlayers(value7)) do
			if not t2.value19.Alive then
				return
			end

			v967(player)
		end

		t2.value22("Public staff roles checked")
	end

	local function v979(p98)
		if not t2.value18.StaffDetector then
			return
		end

		v22("staff:" .. p98.UserId, function()
			v967(p98)
		end)
	end

	Travel = t2.value7.PlayerAdded:Connect(function(...)
		if not t2.value19.Alive then
			return
		end

		local v980, v981 = t2.value5(v979, ...)

		if v980 then
			return
		end

		t2.value19.Metrics.errors = t2.value19.Metrics.errors + 1
		t2.value22(tostring(v981):sub(1, 140))
	end)
	table.insert(t2.value19.Connections, Travel)

	local function v982(p99)
		t2.value19.Staff[p99.UserId] = nil
	end

	Travel = t2.value7.PlayerRemoving:Connect(function(...)
		if not t2.value19.Alive then
			return
		end

		local v983, v984 = t2.value5(v982, ...)

		if v983 then
			return
		end

		t2.value19.Metrics.errors = t2.value19.Metrics.errors + 1
		t2.value22(tostring(v984):sub(1, 140))
	end)
	table.insert(t2.value19.Connections, Travel)

	function t2.value19.AdditionalTick()
		local RankedQueue = t2.value18.RankedQueue

		if RankedQueue then
			local s14 = "ranked"
			local n7 = 20
			local now = os.clock()

			if now < (t2.value19.Deadlines[s14] or 0) then
				RankedQueue = false
			else
				t2.value19.Deadlines[s14] = now + n7
				RankedQueue = true
			end
		end

		if RankedQueue then
			v22("ranked", t4.value20.ranked)
		end

		local StaffDetector = t2.value18.StaffDetector

		if StaffDetector then
			local s15 = "staff"
			local n8 = 60
			local now = os.clock()

			if now < (t2.value19.Deadlines[s15] or 0) then
				StaffDetector = false
			else
				t2.value19.Deadlines[s15] = now + n8
				StaffDetector = true
			end
		end

		if StaffDetector then
			v22("staff", t4.value20.staff)
		end

		local s16 = "clientState"
		local n9 = 0.15
		local now = os.clock()
		local v996

		if now < (t2.value19.Deadlines[s16] or 0) then
			v996 = false
		else
			t2.value19.Deadlines[s16] = now + n9
			v996 = true
		end

		if v996 then
			t4.value64()
		end

		local s17 = "hitboxes"
		local n10 = 0.5
		local now2 = os.clock()
		local v1000

		if now2 < (t2.value19.Deadlines[s17] or 0) then
			v1000 = false
		else
			t2.value19.Deadlines[s17] = now2 + n10
			v1000 = true
		end

		if v1000 then
			t4.value63()
		end

		if not t2.value19.ProfileTick then
			return
		end

		t2.value19.ProfileTick()
	end

	t2.value19.ProfileNames = { "Default" }
	t4.value65 = {
		Version = 1,
		Active = "Default",
		AutoRestore = true,
		Profiles = {}
	}
	t4.value66 = "cult-caa-profiles.json"

	function t4.value67(p100)
		local v1001 = tostring(p100 or "Default"):gsub("[%c]", ""):match("^%s*(.-)%s*$"):sub(1, 48)

		return (v1001 == "" or not v1001) and "Default" or v1001
	end
	function t4.value68()
		local profileNames = {}

		for k in pairs(t4.value65.Profiles) do
			profileNames[#profileNames + 1] = k
		end

		if #profileNames ~= 0 then
			table.sort(profileNames)
			t2.value19.ProfileNames = profileNames

			return
		end

		profileNames[1] = "Default"
		table.sort(profileNames)
		t2.value19.ProfileNames = profileNames
	end
	function t4.value69()
		local writefile_ = writefile

		if type(writefile_) == "function" then
			local writefile_2 = writefile
			local value11 = t2.value11
			local JSONEncode = value11.JSONEncode
			local value65 = t4.value65

			writefile_2(t4.value66, JSONEncode(value11, value65))
			t2.value19.ProfileDirty = false

			return true
		else
			return false
		end
	end
	function t4.value70()
		local v1009 = table.clone(t2.value18)

		v1009.ProfileName = nil
		v1009.Profile = nil

		return v1009
	end
	function t4.value71(p101)
		local v1010 = t4.value65.Profiles[p101]

		if type(v1010) == "table" then
			t2.value19.RestoringProfile = true

			local pairs_ = pairs

			for k, v in pairs_(v1010) do
				local v1014 = t2.value18[k] ~= nil

				if v1014 then
					if k == "ProfileName" then
						v1014 = false
					else
						v1014 = k ~= "Profile"
					end
				end

				if v1014 then
					pairs_ = t2.value19
					pairs_:Set(k, v)
				end
			end

			t2.value18.Profile = p101
			t2.value18.ProfileName = p101
			t4.value65.Active = p101
			t2.value19.RestoringProfile = false
			t4.value65.AutoRestore = t2.value18.AutoRestore

			if not t2.value19.RefreshControl then
				t2.value19.ProfileDirty = true
				t2.value22("Profile loaded: " .. p101)

				return true
			end

			t2.value19.RefreshControl("Profile")
			t2.value19.RefreshControl("ProfileName")
			t2.value19.ProfileDirty = true
			t2.value22("Profile loaded: " .. p101)

			return true
		else
			t2.value22("Profile not found")

			return false
		end
	end
	function t4.value20.save()
		local profileSaved = t4.value67(t2.value18.ProfileName)

		t2.value18.Profile = profileSaved
		t2.value18.ProfileName = profileSaved
		t4.value65.Active = profileSaved
		t4.value65.AutoRestore = t2.value18.AutoRestore
		t4.value65.Profiles[profileSaved] = t4.value70()
		t4.value65.LastConfig = t4.value70()
		t4.value68()

		if t4.value69() then
			t2.value22("Profile saved: " .. profileSaved)
		else
			t2.value22("Profile persistence needs writefile")
		end

		t2.value19.RefreshControl("Profile")
		t2.value19.RefreshControl("ProfileName")
	end
	function t4.value20.load()
		t4.value71(t2.value18.Profile)
	end
	function t4.value20.deleteProfile()
		t4.value65.Profiles[t2.value18.Profile] = nil
		t4.value68()
		t2.value18.Profile = t2.value19.ProfileNames[1]
		t2.value18.ProfileName = t2.value18.Profile
		t4.value65.Active = t2.value18.Profile
		t4.value69()
		t2.value19.RefreshControl("Profile")
		t2.value19.RefreshControl("ProfileName")
		t2.value22("Profile deleted")
	end
	function t2.value19.FlushProfiles()
		if not t2.value19.RestoringProfile then
			local v1016 = t4.value67(t2.value18.Profile)

			t4.value65.Active = v1016
			t4.value65.AutoRestore = t2.value18.AutoRestore
			t4.value65.LastConfig = t4.value70()
			t4.value68()
			pcall(t4.value69)
		end
	end
	function t2.value19.ProfileTick()
		local ProfileDirty = t2.value19.ProfileDirty

		if ProfileDirty then
			local s18 = "profileWrite"
			local n11 = 1
			local now = os.clock()

			if now < (t2.value19.Deadlines[s18] or 0) then
				ProfileDirty = false
			else
				t2.value19.Deadlines[s18] = now + n11
				ProfileDirty = true
			end
		end

		if not ProfileDirty then
			return
		end

		if t2.value18.AutoRestore then
			t2.value19.FlushProfiles()

			return
		end

		t4.value65.AutoRestore = false
		pcall(t4.value69)
	end

	Travel, Priority = pcall(function()
		return t2.value11:JSONDecode(unpack_({ readfile(t4.value66) }))
	end)

	if Travel then
		Travel = type(Priority) == "table"

		if Travel then
			Travel = Priority.Profiles
			Travel = type(Travel) == "table"
		end
	end

	if Travel then
		for k, profile in pairs(Priority.Profiles) do
			if type(k) == "string" then
				layoutOrder = type(profile) == "table"
			else
				layoutOrder = false
			end

			if layoutOrder then
				t4.value65.Profiles[t4.value67(k)] = profile
			end
		end

		t4.value65.Active = t4.value67(Priority.Active)
		t4.value65.AutoRestore = Priority.AutoRestore ~= false
		t2.value18.AutoRestore = t4.value65.AutoRestore
		t4.value68()

		if t2.value18.AutoRestore then
			if type(Priority.LastConfig) == "table" then
				t2.value19.RestoringProfile = true

				for k, v in pairs(Priority.LastConfig) do
					if t2.value18[k] ~= nil then
						t2.value19:Set(k, v)
					end
				end

				t2.value18.Profile = t4.value65.Active
				t2.value18.ProfileName = t4.value65.Active
				t2.value19.RestoringProfile = false
			else
				t4.value71(t4.value65.Active)
			end
		end
	end

	t2.value19.Actions = t4.value20

	function t2.value19.ProcessBanner(p102)
		if type(p102) ~= "table" then
			return
		end

		if p102.State then
			t2.value19.BannerState = p102.State
		end

		local v1025

		if p102.Success == true then
			local Results = p102.Results

			v1025 = type(Results) == "table"
		else
			v1025 = false
		end

		if not v1025 then
			return
		end

		t2.value19.LastSummonResults = p102.Results

		if not t2.value18.Stop4 then
			return
		end

		for _, result in ipairs(p102.Results) do
			local Stars = result.Stars
			local v1030 = tonumber(Stars)

			if not v1030 then
				local Rarity = result.Rarity

				v1030 = tonumber(Rarity) or 0
			end

			if v1030 >= 4 then
				t2.value19:Set("AutoSummon", false)

				local value22 = t2.value22
				local Stars2 = result.Stars

				value22("Auto Summon stopped: " .. tostring(Stars2) .. " star unit")

				return
			end
		end
	end

	for i, v in ipairs({
		"TeamSelectionResult",
		"AscensionResponse",
		"EvolutionResponse",
		"BannerResponse",
		"NotificationEvent"
	}) do
		i = t2.value17:FindFirstChild(v)

		if i then
			v204 = i:IsA("RemoteEvent")
		else
			v204 = i
		end

		if v204 then
			local function v1036(...)
				local v1037 = table.pack(...)
				local v1038, ok, result, v1041

				if v ~= "BannerResponse" then
					v1102 = {}

					for i2 = 1, v1037.n do
						v1038 = v1037[i2]

						if type(v1038) == "table" then
							ok, result = pcall(t2.value11.JSONEncode, t2.value11, v1038)
							v1041 = #v1102 + 1

							if ok then
								ok = result:sub(1, 200)
							end

							v1102[v1041] = ok or "table"
						else
							v1102[#v1102 + 1] = tostring(v1038)
						end
					end

					t2.value22(v .. ": " .. table.concat(v1102, " | "))

					return
				end

				for i2 = 1, v1037.n do
					local v1044 = v1037[i2]

					t2.value19.ProcessBanner(v1044)
				end

				local t14 = {}

				for i2 = 1, v1037.n do
					v1038 = v1037[i2]

					if type(v1038) == "table" then
						ok, result = pcall(t2.value11.JSONEncode, t2.value11, v1038)
						v1041 = #t14 + 1

						if ok then
							ok = result:sub(1, 200)
						end

						t14[v1041] = ok or "table"
					else
						t14[#t14 + 1] = tostring(v1038)
					end
				end

				t2.value22(v .. ": " .. table.concat(t14, " | "))
			end

			i = i.OnClientEvent:Connect(function(...)
				if not t2.value19.Alive then
					return
				end

				local v1047, v1048 = t2.value5(v1036, ...)

				if v1047 then
					return
				end

				t2.value19.Metrics.errors = t2.value19.Metrics.errors + 1
				t2.value22(tostring(v1048):sub(1, 140))
			end)
			table.insert(t2.value19.Connections, i)
		end
	end

	Travel = t2.value17:FindFirstChild("SupplyPointRequest")

	if Travel then
		local function v1049(p103, ...)
			t2.value19.LastSupplyEvent = {
				kind = p103,
				time = os.clock()
			}
			t2.value22("Supply: " .. tostring(p103))

			if not (p103 == "Completed" or (p103 == "Closed" and true or p103 == "Cancelled")) then
				return
			end

			t2.value19.SupplyStarted = false
		end

		Travel = Travel.OnClientEvent:Connect(function(...)
			if not t2.value19.Alive then
				return
			end

			local v1050, v1051 = t2.value5(v1049, ...)

			if v1050 then
				return
			end

			t2.value19.Metrics.errors = t2.value19.Metrics.errors + 1
			t2.value22(tostring(v1051):sub(1, 140))
		end)
		table.insert(t2.value19.Connections, Travel)
	end

	local function v1052()
		if not t2.value18.InfiniteJump then
			return
		end

		local Character = t2.value15.Character
		local Humanoid

		if Character then
			Humanoid = Character:FindFirstChildOfClass("Humanoid")
		else
			Humanoid = Character
		end

		if Character then
			Character:FindFirstChild("HumanoidRootPart")
		end

		if not Humanoid then
			return
		end

		Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end

	Travel = t2.value9.JumpRequest:Connect(function(...)
		if not t2.value19.Alive then
			return
		end

		local v1055, v1056 = t2.value5(v1052, ...)

		if v1055 then
			return
		end

		t2.value19.Metrics.errors = t2.value19.Metrics.errors + 1
		t2.value22(tostring(v1056):sub(1, 140))
	end)
	table.insert(t2.value19.Connections, Travel)

	local function v1057()
		if not t2.value18.AntiAFK then
			return
		end

		pcall(function()
			local VirtualUser = game:GetService("VirtualUser")

			VirtualUser:CaptureController()
			VirtualUser:ClickButton2(Vector2.new(1, 1), workspace.CurrentCamera.CFrame)
		end)
	end

	Travel = t2.value15.Idled:Connect(function(...)
		if not t2.value19.Alive then
			return
		end

		local v1059, v1060 = t2.value5(v1057, ...)

		if v1059 then
			return
		end

		t2.value19.Metrics.errors = t2.value19.Metrics.errors + 1
		t2.value22(tostring(v1060):sub(1, 140))
	end)
	table.insert(t2.value19.Connections, Travel)
	t4.value72 = t2.value15:GetAttribute("MatchState")

	local function v1061()
		local attribute = t2.value15:GetAttribute("MatchState")

		t2.value22("MatchState: " .. tostring(attribute))
		t2.value19.Target = nil
		t2.value19.ManualGoal = nil
		v102()

		local v1063 = t4.value72 == "Game"

		if v1063 then
			v1063 = attribute == "Lobby"

			if v1063 then
				v1063 = t2.value18.Rejoin and t2.value18.Farm or t2.value18.AutoMatch
			end
		end

		if not v1063 then
			return
		end

		v22("rejoin", function()
			task.wait(12)

			if t2.value19.Alive and t2.value18.Rejoin then
				if v880() then
					t2.value14:Teleport(game.PlaceId, t2.value15)

					return
				else
					t2.value22("Rejoin: queue/readfile missing; Auto Match continues locally")

					return
				end
			end
		end)
	end

	Travel = t2.value15:GetAttributeChangedSignal("MatchState"):Connect(function(...)
		if not t2.value19.Alive then
			return
		end

		local v1064, v1065 = t2.value5(v1061, ...)

		if v1064 then
			return
		end

		t2.value19.Metrics.errors = t2.value19.Metrics.errors + 1
		t2.value22(tostring(v1065):sub(1, 140))
	end)
	table.insert(t2.value19.Connections, Travel)

	local function v1066(p104, _, p105)
		if p104 ~= t2.value15 then
			return
		end

		t2.value22("Rejoin failed: " .. tostring(p105))
	end

	Travel = t2.value14.TeleportInitFailed:Connect(function(...)
		if not t2.value19.Alive then
			return
		end

		local v1067, v1068 = t2.value5(v1066, ...)

		if v1067 then
			return
		end

		t2.value19.Metrics.errors = t2.value19.Metrics.errors + 1
		t2.value22(tostring(v1068):sub(1, 140))
	end)
	table.insert(t2.value19.Connections, Travel)
	Travel = t2.value8
	Priority = Enum.RenderPriority.Last
	Travel.BindToRenderStep(Travel, "CultCAA_Render", Priority.Value + 1, function(p106)
		local ok, result = pcall(function()
			if not t2.value19.Alive then
				return
			end

			local Character = t2.value15.Character
			local Humanoid

			if Character then
				Humanoid = Character:FindFirstChildOfClass("Humanoid")
			else
				Humanoid = Character
			end

			local HumanoidRootPart

			if Character then
				HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
			else
				HumanoidRootPart = Character
			end

			local CurrentCamera = workspace.CurrentCamera

			if Humanoid and HumanoidRootPart then
				local OriginalHumanoids

				if t2.value18.Speed or t2.value18.Fly then
					if t2.value19.OriginalHumanoids[Humanoid] then
						OriginalHumanoids = CurrentCamera
					else
						OriginalHumanoids = t2.value19.OriginalHumanoids
						OriginalHumanoids[Humanoid] = {
							speed = Humanoid.WalkSpeed,
							stand = Humanoid.PlatformStand,
							rotate = Humanoid.AutoRotate
						}
					end

					if t2.value18.Speed then
						Humanoid.WalkSpeed = t2.value18.SpeedValue
						OriginalHumanoids = "WalkSpeed"
					elseif t2.value19.OriginalHumanoids[Humanoid] then
						Humanoid.WalkSpeed = t2.value19.OriginalHumanoids[Humanoid].speed
						OriginalHumanoids = "WalkSpeed"
					end
				else
					OriginalHumanoids = CurrentCamera
				end

				if t2.value18.Fly and CurrentCamera then
					Humanoid.PlatformStand = true
					Humanoid.AutoRotate = false

					local v1076 = CurrentCamera.CFrame:VectorToWorldSpace(Vector3.new(Humanoid.MoveDirection:Dot(CurrentCamera.CFrame.RightVector), 0, -Humanoid.MoveDirection:Dot(CurrentCamera.CFrame.LookVector)))

					OriginalHumanoids = t2.value9

					if OriginalHumanoids:IsKeyDown(Enum.KeyCode.W) then
						v1076 = v1076 + CurrentCamera.CFrame.LookVector
						OriginalHumanoids = v1076
					end

					if t2.value9:IsKeyDown(Enum.KeyCode.S) then
						v1076 = v1076 - CurrentCamera.CFrame.LookVector
					end

					if t2.value9:IsKeyDown(Enum.KeyCode.A) then
						v1076 = v1076 - CurrentCamera.CFrame.RightVector
					end

					if t2.value9:IsKeyDown(Enum.KeyCode.D) then
						v1076 = v1076 + CurrentCamera.CFrame.RightVector
					end

					local v1077 = v1076 + Vector3.yAxis * (t2.value19.FlyVertical or 0)

					if t2.value9:IsKeyDown(Enum.KeyCode.Space) then
						v1077 = v1077 + Vector3.yAxis
					end

					if t2.value9:IsKeyDown(Enum.KeyCode.Q) then
						v1077 = v1077 - Vector3.yAxis
					end

					if v1077.Magnitude > 1 then
						v1077 = v1077.Unit
					end

					HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero

					local v1078 = p106

					HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + v1077 * t2.value18.FlySpeed * math.min(v1078, 0.05)
				elseif t2.value19.OriginalHumanoids[Humanoid] then
					Humanoid.PlatformStand = t2.value19.OriginalHumanoids[Humanoid].stand
					Humanoid.AutoRotate = t2.value19.OriginalHumanoids[Humanoid].rotate
				end

				if t2.value18.Noclip then
					local GetDescendants = Character.GetDescendants

					for _, v in ipairs(GetDescendants(Character)) do
						if v:IsA("BasePart") then
							if t2.value19.OriginalCollision[v] == nil then
								t2.value19.OriginalCollision[v] = v.CanCollide
							end

							v.CanCollide = false
						end
					end
				end

				local AFKEpisode = t2.value19.AFKEpisode
				local v1083 = not AFKEpisode

				if v1083 then
					v1083 = not t2.value18.Fly

					if v1083 then
						v1083 = not Humanoid.Sit and t2.value19.NavigationGoal

						if v1083 then
							v1083 = os.clock() < (t2.value19.MovingUntil or 0)
						end
					end
				end

				if v1083 then
					local v1084 = t2.value19.NavigationGoal - HumanoidRootPart.Position
					local vector3 = Vector3.new(v1084.X, 0, v1084.Z)

					if vector3.Magnitude > 1 then
						Humanoid:Move(vector3.Unit, false)
					end
				end

				local v1086

				if AFKEpisode then
					v1086 = AFKEpisode.root == HumanoidRootPart
				else
					v1086 = AFKEpisode
				end

				if v1086 then
					AFKEpisode.distance = AFKEpisode.distance + (HumanoidRootPart.Position - AFKEpisode.last).Magnitude
					AFKEpisode.last = HumanoidRootPart.Position

					local v1087 = os.clock() - AFKEpisode.start

					if v1087 < 0.18 then
						Humanoid:Move(AFKEpisode.direction, false)
					elseif v1087 < 0.36 then
						Humanoid:Move(-AFKEpisode.direction, false)
					else
						Humanoid:Move(Vector3.zero, false)
						t2.value19.AFKEpisode = nil
						t2.value19.Metrics.afkPulses = t2.value19.Metrics.afkPulses + 1
						t2.value19.Metrics.movementDistance = t2.value19.Metrics.movementDistance + AFKEpisode.distance
						t2.value19.LastAFKDistance = AFKEpisode.distance
						t2.value22("Anti-AFK: " .. string.format("%.1f", AFKEpisode.distance) .. " studs | next movement in 300 s")
					end
				end

				if t2.value18.BirdsEye and CurrentCamera then
					if not t2.value19.CameraSave or t2.value19.CameraSave.camera ~= CurrentCamera then
						t2.value19.CameraSave = {
							camera = CurrentCamera,
							type = CurrentCamera.CameraType,
							subject = CurrentCamera.CameraSubject,
							cframe = CurrentCamera.CFrame,
							fov = CurrentCamera.FieldOfView
						}
					end

					CurrentCamera.CameraType = Enum.CameraType.Scriptable
					CurrentCamera.CFrame = CFrame.lookAt(HumanoidRootPart.Position + Vector3.new(0, t2.value18.CameraHeight, 0.01), HumanoidRootPart.Position, Vector3.new(0, 0, -1))
				end
			end

			if not t2.value18.Fullbright then
				return
			end

			if not t2.value19.LightSave then
				t2.value19.LightSave = {
					Brightness = t2.value10.Brightness,
					ClockTime = t2.value10.ClockTime,
					FogEnd = t2.value10.FogEnd,
					GlobalShadows = t2.value10.GlobalShadows,
					Ambient = t2.value10.Ambient,
					OutdoorAmbient = t2.value10.OutdoorAmbient
				}
			end

			t2.value10.Brightness = 2
			t2.value10.ClockTime = 14
			t2.value10.FogEnd = 100000
			t2.value10.GlobalShadows = false
			t2.value10.Ambient = Color3.new(1, 1, 1)
			t2.value10.OutdoorAmbient = Color3.new(1, 1, 1)
		end)
		local v1088 = not ok

		if v1088 then
			local s19 = "frameError"
			local n12 = 3
			local now = os.clock()

			if now < (t2.value19.Deadlines[s19] or 0) then
				v1088 = false
			else
				t2.value19.Deadlines[s19] = now + n12
				v1088 = true
			end
		end

		if not v1088 then
			return
		end

		t2.value19.Metrics.errors = t2.value19.Metrics.errors + 1
		t2.value22(tostring(result):sub(1, 140))
	end)
	v22("scheduler", function()
		while t2.value19.Alive do
			local function v1092()
				local now = os.clock()
				local value19 = v56
				local _, v1096, v1097 = value19()
				local AntiAFK = t2.value18.AntiAFK

				if AntiAFK then
					AntiAFK = t2.value19.NextAFK <= now
				end

				if AntiAFK and not t2.value19:PulseAFK() then
					value19 = t2.value19
					value19.NextAFK = now + 10
				end

				local AutoMatch = t2.value18.AutoMatch or t2.value18.Farm

				if AutoMatch then
					local s20 = "match"
					local n13 = 5
					local now2 = os.clock()

					if now2 < (t2.value19.Deadlines[s20] or 0) then
						AutoMatch = false
					else
						t2.value19.Deadlines[s20] = now2 + n13
						AutoMatch = true
					end
				end

				if AutoMatch then
					if t2.value15:GetAttribute("MatchState") == "Lobby" then
						value19 = v22
						value19("join", t4.value48)
					elseif t2.value15:GetAttribute("AwaitingRespawnUnit") == true then
						value19 = t4.value49
						value19()
					else
						local v1103

						if t2.value15:GetAttribute("IsDead") == true then
							v1103 = t2.value15:GetAttribute("DeathRetreatState") ~= "Retreated"
						else
							v1103 = false
						end

						if v1103 then
							value19 = v33
							value19("DeathRetreatRequest")
						end
					end
				end

				local Daily = t2.value18.Daily

				if Daily then
					local s21 = "daily"
					local n14 = 60
					local now2 = os.clock()

					if now2 < (t2.value19.Deadlines[s21] or 0) then
						Daily = false
					else
						t2.value19.Deadlines[s21] = now2 + n14
						Daily = true
					end
				end

				if Daily then
					value19 = v22
					value19("daily", t4.value56)
				end

				local Quests = t2.value18.Quests

				if Quests then
					local s22 = "quests"
					local n15 = 60
					local now2 = os.clock()

					if now2 < (t2.value19.Deadlines[s22] or 0) then
						Quests = false
					else
						t2.value19.Deadlines[s22] = now2 + n15
						Quests = true
					end
				end

				if Quests then
					value19 = v22
					value19("quests", t4.value57)
				end

				local AutoEquip = t2.value18.AutoEquip

				if AutoEquip then
					local s23 = "equip"
					local n16 = 15
					local now2 = os.clock()

					if now2 < (t2.value19.Deadlines[s23] or 0) then
						AutoEquip = false
					else
						t2.value19.Deadlines[s23] = now2 + n16
						AutoEquip = true
					end
				end

				if AutoEquip then
					value19 = t4.value20.equip
					value19()
				end

				local AutoSummon = t2.value18.AutoSummon

				if AutoSummon then
					local v1117 = t2.value18.SkipSummon and 2 or 12
					local s24 = "summon"
					local now2 = os.clock()

					if now2 < (t2.value19.Deadlines[s24] or 0) then
						AutoSummon = false
					else
						t2.value19.Deadlines[s24] = now2 + v1117
						AutoSummon = true
					end
				end

				if AutoSummon then
					value19 = v22
					value19("summon", t4.value53)
				end

				local AutoAscend = t2.value18.AutoAscend

				if AutoAscend then
					local s25 = "ascend"
					local n17 = 5
					local now2 = os.clock()

					if now2 < (t2.value19.Deadlines[s25] or 0) then
						AutoAscend = false
					else
						t2.value19.Deadlines[s25] = now2 + n17
						AutoAscend = true
					end
				end

				if AutoAscend then
					value19 = v22
					value19("ascend", t4.value54)
				end

				local AutoEvolve = t2.value18.AutoEvolve

				if AutoEvolve then
					local s26 = "evolve"
					local n18 = 5
					local now2 = os.clock()

					if now2 < (t2.value19.Deadlines[s26] or 0) then
						AutoEvolve = false
					else
						t2.value19.Deadlines[s26] = now2 + n18
						AutoEvolve = true
					end
				end

				if AutoEvolve then
					value19 = v22
					value19("evolve", t4.value55)
				end

				local v1128 = t2.value25()

				if v1128 then
					if v1096 then
						if v1097 then
							v1128 = v1096.Health > 0
						else
							v1128 = v1097
						end
					else
						v1128 = v1096
					end
				end

				if v1128 then
					local s27 = "targets"
					local n19 = 0.5
					local now2 = os.clock()
					local v1132

					if now2 < (t2.value19.Deadlines[s27] or 0) then
						v1132 = false
					else
						t2.value19.Deadlines[s27] = now2 + n19
						v1132 = true
					end

					if v1132 then
						v1132 = t2.value18.AutoFight or (t2.value18.Aura or (t2.value18.Lock or (t2.value18.Farm or (t2.value18.Orders or (t2.value18.Block or (t2.value18.Retreat or (t2.value18.AutoVolley or t2.value18.AutoCatapult)))))))
					end

					if v1132 then
						t4.value44()
					end

					local Target = t2.value19.Target
					local v1134

					if Target then
						v1134 = not Target.root.Parent or v62(Target.model) <= 0
					else
						v1134 = Target
					end

					local v1135

					if v1134 then
						t2.value19.Target = nil
						Target = nil
						v1135 = nil
					else
						v1135 = Target
					end

					local Health = v1096.Health
					local MaxHealth = v1096.MaxHealth
					local v1138 = Health / math.max(MaxHealth, 1) * 100
					local Retreat = t2.value18.Retreat

					if Retreat then
						Retreat = v1138 <= t2.value18.RetreatHP
					end

					if Retreat and v1135 then
						local s28 = "retreat"
						local n20 = 2
						local now3 = os.clock()
						local v1143

						if now3 < (t2.value19.Deadlines[s28] or 0) then
							v1143 = false
						else
							t2.value19.Deadlines[s28] = now3 + n20
							v1143 = true
						end

						if v1143 then
							v33("TroopStateRequest", "Follow")
						end

						local v1144 = v1097.Position - v1135.root.Position
						local vector3 = Vector3.new(v1144.X, 0, v1144.Z)

						if vector3.Magnitude > 0.1 then
							t4.value45(v1097.Position + vector3.Unit * 25)
						end
					else
						local Supply = t2.value18.Supply or t2.value18.Farm

						if Supply then
							local value15 = t2.value15

							Supply = (tonumber(value15:GetAttribute("CurrentUnitAliveCount")) or 0) <= 0 or (not v64() or t2.value19.SupplyStarted)
						end

						local v1148

						if Supply then
							local s29 = "supply"
							local n21 = 1
							local now3 = os.clock()

							if now3 < (t2.value19.Deadlines[s29] or 0) then
								v1148 = false
							else
								t2.value19.Deadlines[s29] = now3 + n21
								v1148 = true
							end
						else
							v1148 = Supply
						end

						if v1148 then
							v22("supply", t4.value51)
						end

						local AutoFight = t2.value18.AutoFight or t2.value18.Farm

						if AutoFight then
							if v1135 then
								AutoFight = not Supply
							else
								AutoFight = v1135
							end
						end

						if AutoFight then
							local Magnitude = (v1097.Position - v1135.root.Position).Magnitude
							local value15 = t2.value15
							local v1155 = (tonumber(value15:GetAttribute("Range")) or 7) - 1

							if math.max(2, v1155) < Magnitude then
								t4.value45(v1135.root.Position)
							else
								v102()
							end
						end
					end

					local Heal = t2.value18.Heal

					if Heal then
						Heal = v1138 <= t2.value18.HealHP

						if Heal then
							if t2.value15:GetAttribute("CanUseCombat") == true then
								local value15 = t2.value15

								if (tonumber(value15:GetAttribute("HealCooldownEndsAt")) or 0) <= workspace:GetServerTimeNow() then
									local s30 = "heal"
									local n22 = 1.5
									local now3 = os.clock()

									if now3 < (t2.value19.Deadlines[s30] or 0) then
										Heal = false
									else
										t2.value19.Deadlines[s30] = now3 + n22
										Heal = true
									end
								else
									Heal = false
								end
							else
								Heal = false
							end
						end
					end

					if Heal then
						v33("PlayerCombatRequest", "Heal")
					end

					local Block = t2.value18.Block

					if Block then
						if v1135 then
							if (v1097.Position - v1135.root.Position).Magnitude < t2.value18.BlockRange and v1138 < t2.value18.HealHP then
								local value15 = t2.value15

								Block = (tonumber(value15:GetAttribute("BlockDurability")) or 0) > 0
							else
								Block = false
							end
						else
							Block = v1135
						end
					end

					local v1163 = Block or false
					local v1164

					if v1163 == t2.value19.Blocking then
						v1164 = false
					else
						v1164 = t2.value15:GetAttribute("CanUseCombat") == true
					end

					if v1164 then
						v33("PlayerCombatRequest", "Block", v1163 == true)
						t2.value19.Blocking = v1163 == true
					end

					local Parent

					if v1135 then
						Parent = v1135.root.Parent

						if Parent then
							Parent = not t2.value19.Blocking

							if Parent then
								if t2.value15:GetAttribute("CanUseCombat") == true then
									Parent = not Retreat
								else
									Parent = false
								end
							end
						end
					else
						Parent = v1135
					end

					if Parent then
						local AutoFight = t2.value18.AutoFight or t2.value18.Farm

						if AutoFight then
							local value15 = t2.value15

							AutoFight = tonumber(value15:GetAttribute("Range")) or 7
						end

						local Range = AutoFight or t2.value18.Range
						local Aura = t2.value18.Aura or (t2.value18.AutoFight or t2.value18.Farm)

						if Aura then
							Aura = (v1097.Position - v1135.root.Position).Magnitude <= Range
						end

						if Aura then
							local Position = v1135.root.Position

							v1097.CFrame = CFrame.lookAt(v1097.Position, Vector3.new(Position.X, v1097.Position.Y, Position.Z))

							local value15 = t2.value15
							local v1172 = tonumber(value15:GetAttribute("AttackInterval")) or 0.5
							local v1173 = math.max(0.05, v1172)
							local s31 = "attack"
							local now3 = os.clock()
							local v1176

							if now3 < (t2.value19.Deadlines[s31] or 0) then
								v1176 = false
							else
								t2.value19.Deadlines[s31] = now3 + v1173
								v1176 = true
							end

							if v1176 then
								v33("PlayerCombatRequest", "Attack")
								t2.value19.Metrics.attacks = t2.value19.Metrics.attacks + 1
							end
						end
					end

					local Orders = t2.value18.Orders or t2.value18.Farm

					if Orders then
						local v1178 = t2.value18.Order == "Rush" and 10 or 3
						local s32 = "orders"
						local now3 = os.clock()

						if now3 < (t2.value19.Deadlines[s32] or 0) then
							Orders = false
						else
							t2.value19.Deadlines[s32] = now3 + v1178
							Orders = true
						end
					end

					if Orders then
						local Farm = t2.value18.Farm

						if Farm then
							Farm = not t2.value18.Orders
						end

						if Farm then
							v33("TroopStateRequest", "Attack")
						else
							order()
						end
					end

					local AutoVolley = t2.value18.AutoVolley

					if AutoVolley then
						local s33 = "volley"
						local n23 = 11
						local now3 = os.clock()

						if now3 < (t2.value19.Deadlines[s33] or 0) then
							AutoVolley = false
						else
							t2.value19.Deadlines[s33] = now3 + n23
							AutoVolley = true
						end
					end

					if AutoVolley then
						v22("volley", t4.value58)
					end

					local AutoCannon = t2.value18.AutoCannon

					if AutoCannon then
						local s34 = "cannon"
						local n24 = 5.5
						local now3 = os.clock()

						if now3 < (t2.value19.Deadlines[s34] or 0) then
							AutoCannon = false
						else
							t2.value19.Deadlines[s34] = now3 + n24
							AutoCannon = true
						end
					end

					if AutoCannon then
						v22("cannon", t4.value59)
					end

					local AutoCatapult = t2.value18.AutoCatapult

					if AutoCatapult then
						local s35 = "catapult"
						local n25 = 15
						local now3 = os.clock()

						if now3 < (t2.value19.Deadlines[s35] or 0) then
							AutoCatapult = false
						else
							t2.value19.Deadlines[s35] = now3 + n25
							AutoCatapult = true
						end
					end

					if AutoCatapult then
						v22("catapult", t4.value60)
					end
				end

				if t2.value19.ManualGoal then
					t4.value45(t2.value19.ManualGoal)

					if v1097 then
						local v1194 = v1097.Position - t2.value19.ManualGoal
						local v1195

						if Vector3.new(v1194.X, 0, v1194.Z).Magnitude < 5 then
							local Y = v1194.Y

							v1195 = math.abs(Y) < 20
						else
							v1195 = false
						end

						if v1195 then
							t2.value19.ManualGoal = nil
							v102()
						end
					end
				end

				t4.value46()

				local s36 = "esp"
				local n26 = 0.8
				local now2 = os.clock()
				local v1200

				if now2 < (t2.value19.Deadlines[s36] or 0) then
					v1200 = false
				else
					t2.value19.Deadlines[s36] = now2 + n26
					v1200 = true
				end

				if v1200 then
					t4.value61()
				end

				if not t2.value19.AdditionalTick then
					return
				end

				t2.value19.AdditionalTick()
			end

			local ok, result = pcall(v1092)
			local v1203 = not ok

			if v1203 then
				local s37 = "schedulerError"
				local n27 = 3
				local now = os.clock()

				if now < (t2.value19.Deadlines[s37] or 0) then
					v1203 = false
				else
					t2.value19.Deadlines[s37] = now + n27
					v1203 = true
				end
			end

			if v1203 then
				t2.value19.Metrics.errors = t2.value19.Metrics.errors + 1
				t2.value22(tostring(result):sub(1, 140))
			end

			task.wait(0.15)
		end
	end)
	connection()
	t4.value28("Auto Farm")
	t2.value22("Ready | " .. t2.value19.Font .. " | Anti-AFK every 300 seconds")

	return t2.value19
end)
local t1 = {
	value3 = ok,
	value4 = value4
}

if t1.value3 then
	return t1.value4
end

local getgenv_ = getgenv
local genv

if type(getgenv_) == "function" then
	genv = getgenv()
else
	genv = false
end

t1.value6 = genv

local value2 = t1.value2
local value6 = t1.value6

t1.value2 = value2
t1.value1 = value6

if not t1.value6 then
	t1.value1 = _G
end

local value1 = t1.value1
local CultCAA = value1.CultCAA

if CultCAA then
	local Unload = value1.CultCAA.Unload

	CultCAA = type(Unload) == "function"
end

t1.value1 = CultCAA

if not t1.value1 then
	t1.value1 = value1
	v1276 = t1.value4
	t1.value5 = tostring(v1276)
	t1.value1.CultCAAInitError = t1.value5

	return nil
end

function t1.value7()
	value1.CultCAA:Unload()
end

pcall(t1.value7)
t1.value1 = value1

local value42 = t1.value4

t1.value5 = tostring(value42)
t1.value1.CultCAAInitError = t1.value5

return nil
