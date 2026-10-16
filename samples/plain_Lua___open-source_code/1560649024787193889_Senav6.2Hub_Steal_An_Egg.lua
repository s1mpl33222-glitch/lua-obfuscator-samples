local v, tbl, register
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ProximityPromptService = game:GetService("ProximityPromptService")
local localPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local Workspace = game:GetService("Workspace")

local function fn()
	return Workspace:FindFirstChild("World") or Workspace:FindFirstChild("__OBJECTS")
end

local genv = getgenv and getgenv() or _G

if type(genv.__SenaV4HubShutdown) == "function" then
	pcall(genv.__SenaV4HubShutdown)
end

local senaV4HubSession = {}
genv.__SenaV4HubSession = senaV4HubSession

local function fn2()
	return genv.__SenaV4HubSession == senaV4HubSession
end

do
	local tbl2 = {"hookfunction", "hookmetamethod", "getconnections", "getgc", "getrawmetatable", "firetouchinterest", "newcclosure", "getnamecallmethod", "checkcaller", "getcallingscript"}
	local iscclosure = genv.iscclosure or rawget(_G, "iscclosure")
	local isfunctionhooked = genv.isfunctionhooked or rawget(_G, "isfunctionhooked")
	local tbl3 = {}

	for i, v2 in ipairs(tbl2) do
		tbl3[v2] = genv[v2]
	end

	local function fn3(arg)
		if type(arg) ~= "function" then
			return false
		end

		if type(iscclosure) == "function" then
			local ok, result = pcall(iscclosure, arg)
			if ok and result == false then
				return true
			end
		end

		if type(isfunctionhooked) == "function" then
			local ok, result = pcall(isfunctionhooked, arg)
			if ok and result == true then
				return true
			end
		end

		return false
	end

	local function fn4()
		for i, v2 in ipairs(tbl2) do
			local v3 = genv[v2]

			if v3 ~= tbl3[v2] then
				return "api:" .. v2
			elseif fn3(v3) then
				return "api:" .. v2
			end
		end

		local getrawmetatable = tbl3.getrawmetatable

		if type(getrawmetatable) == "function" then
			local ok, result = pcall(getrawmetatable, game)

			if ok and type(result) == "table" then
				for i, v2 in ipairs({"__namecall", "__index", "__newindex"}) do
					if fn3(rawget(result, v2)) then
						return "mt:" .. v2
					end
				end
			end
		end

		local remoteEvent = Instance.new("RemoteEvent")
		local remoteFunction = Instance.new("RemoteFunction")
		local v2 = if fn3(remoteEvent.FireServer) then "remote:FireServer" else if fn3(remoteFunction.InvokeServer) then "remote:InvokeServer" else nil
		remoteEvent:Destroy()
		remoteFunction:Destroy()
		return v2
	end

	local function fn5(arg)
		if genv.__SenaV4TamperRejoining then
			return
		end
		genv.__SenaV4TamperRejoining = true
		warn("[Sena] tamper detected (" .. tostring(arg) .. ") - rejoining")

		pcall(function()
			TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, localPlayer)
		end)

		task.delay(5, function()
			pcall(function()
				TeleportService:Teleport(game.PlaceId, localPlayer)
			end)
		end)
	end

	local ok, result = pcall(fn4)

	if ok and result then
		fn5(result)
	end

	task.spawn(function()
		while fn2() do
			task.wait(3)
			local ok2, result2 = pcall(fn4)
			if ok2 and result2 then
				fn5(result2)
				break
			end
		end
	end)
end

genv.__SenaV4IdentityGetter = genv.getthreadidentity or genv.get_thread_identity or genv.getidentity or genv.getthreadcontext or genv.get_thread_context
genv.__SenaV4IdentitySetter = genv.setthreadidentity or genv.set_thread_identity or genv.setidentity or genv.setthreadcontext or genv.set_thread_context
local senaV4IdentitySetter = genv.__SenaV4IdentitySetter

if type(senaV4IdentitySetter) == "function" then
	pcall(senaV4IdentitySetter, 8)
	genv.__SenaV4UICapabilityIdentity = 8
end

if not rawget(_G, "setfpscap") and not rawget(_G, "set_fps_cap") then
	senaV4IdentitySetter = type(setfpscap) == "function"
end

genv.__SenaV4SetCapFps = function(arg)
	local n = tonumber(arg) or 240
	local n2 = math.clamp(math.floor(n), 1, 1000)
	local flag = rawget(_G, "setfpscap") or rawget(_G, "set_fps_cap") or type(setfpscap) == "function" and setfpscap
	if type(flag) == "function" then
		return pcall(flag, n2)
	end
	return false
end

if type(genv.__SenaV4TweenRuntimeCleanup) == "function" then
	pcall(genv.__SenaV4TweenRuntimeCleanup)
end

if type(genv.__SenaV4EggRuntimeCleanup) == "function" then
	pcall(genv.__SenaV4EggRuntimeCleanup)
end

if type(genv.__SenaV4AntiGuardCleanup) == "function" then
	pcall(genv.__SenaV4AntiGuardCleanup)
end

genv.__SenaV4TweenRuntimeGeneration = (genv.__SenaV4TweenRuntimeGeneration or 0) + 1
local tbl2 = {genv.__SenaV4TweenRuntimeGeneration, {KEY = "__SenaV4StealAnEggMovementSpoof", VERSION = 436, INTEGRITY_KEY = "__SenaV4StealAnEggIntegritySpoof", SIGNAL = "ClientCharacter: GetDebugSnapshot", HEADROOM = 1.35, CLAMP = 0.15, PADDING = 24, MULTIPLIER = 10, MIN_INPUT = 20, MAX_INPUT = 100, DEF_INPUT = 60, MIN_SPEED = 200, MAX_SPEED = 1000, DEF_SPEED = 600, FIELDS = {"LastObservedSample", "LastSample", "LastGoodSample", "LastGameplayTrustedSample", "LastValidatedSample", "LastValidatedGroundedSample", "LastConfirmedGroundSample", "CandidateGroundedSample"}}}
tbl2.n = 2
local v2
v, v2 = tbl2[1], tbl2[2]
local key = v2.KEY
local version = v2.VERSION
local integrityKey = v2.INTEGRITY_KEY
local signal = v2.SIGNAL
local headroom = v2.HEADROOM
local clamp = v2.CLAMP
local padding = v2.PADDING
local multiplier = v2.MULTIPLIER
local minInput = v2.MIN_INPUT
local maxInput = v2.MAX_INPUT
local defInput = v2.DEF_INPUT
local minSpeed = v2.MIN_SPEED
local maxSpeed = v2.MAX_SPEED
local defSpeed = v2.DEF_SPEED
local fields = v2.FIELDS
local n = 60

game:GetService("RunService").Heartbeat:Connect(function(deltaTime)
	if deltaTime and deltaTime > 0 then
		n = n * 0.9 + 1 / deltaTime * 0.1
	end
end)

local function fn3()
	return n
end

genv.__SenaV4NetPing = function()
	local n2 = 0

	pcall(function()
		n2 = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
	end)

	return tonumber(n2) or 0
end

local n2, n3, name, str, v3 = 8, 1, "__SenaV4HoverPad", "SenaV4RuntimeOwner"
local str2 = tostring(math.random(100000, 999999))
local connection, connection2
local tbl3, v4, fn4 = {}

local function fn5()
	for i, child in ipairs(Workspace:GetChildren()) do
		if child:IsA("BasePart") and (child.Name == name and child ~= v3) then
			pcall(child.Destroy, child)
		end
	end
end

local function fn6(arg)
	if v3 then
		if not v3.Parent then
			return false
		end
	else
		return false
	end

	local character = localPlayer.Character
	local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")

	if humanoidRootPart then
		if not humanoid then
			return false
		end
	else
		return false
	end

	local position = typeof(arg) == "Vector3" and arg or humanoidRootPart.Position
	local n4 = humanoid.RigType == Enum.HumanoidRigType.R15 and humanoidRootPart.Size.Y * 0.5 + math.max(humanoid.HipHeight, 0.5) or humanoidRootPart.Size.Y * 0.5 + 2
	v3.CFrame = CFrame.new(position.X, position.Y - n4 - n3 * 0.5 - 0.05, position.Z)
	return true
end

local function fn7()
	if (if v3 then not v3.Parent else not v3) or v3:GetAttribute(str) ~= str2 then
		fn5()

		if v3 and v3.Parent then
			pcall(v3.Destroy, v3)
		end

		local part = Instance.new("Part")
		part.Name = name
		part:SetAttribute(str, str2)
		part.Anchored = true
		part.CanCollide = true
		part.CanQuery = true
		part.CanTouch = false
		part.CastShadow = false
		part.Transparency = 1
		part.Material = Enum.Material.SmoothPlastic
		part.Size = Vector3.new(n2, n3, n2)
		v3 = part
		part.Parent = Workspace
	end

	fn6()

	if not connection then
		connection = RunService.PreSimulation:Connect(function()
			if not fn6() then
				fn7()
			end
		end)
	end

	if not connection2 then
		connection2 = RunService.PostSimulation:Connect(function()
			fn6()
		end)
	end
end

local function fn8()
	if connection then
		pcall(connection.Disconnect, connection)
		connection = nil
	end

	if connection2 then
		pcall(connection2.Disconnect, connection2)
		connection2 = nil
	end

	if v3 then
		pcall(v3.Destroy, v3)
		v3 = nil
	end

	fn5()
end

fn8()

local function fn9()
	v4 = nil
end

local function fn10(rootPart, cFrame)
	local tbl4 = {}

	if rootPart and typeof(cFrame) == "CFrame" then
		tbl4[1] = {}
		tbl4[1].Character = localPlayer.Character
		tbl4[1].RootPart = rootPart
		tbl4[1].CFrame = cFrame
		v4 = tbl4[1]
	end
end

local function fn11()
	local v5 = v4

	if type(v5) ~= "table" then
		return false
	elseif typeof(v5.CFrame) ~= "CFrame" then
		return false
	end

	if localPlayer.Character ~= v5.Character then
		v4 = nil
		return false
	else
		if v5.RootPart then
			if not v5.RootPart.Parent then
				v4 = nil
				return false
			end
		else
			v4 = nil
			return false
		end
	end

	fn7()
	v5.RootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
	v5.RootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
	fn6(v5.CFrame.Position)
	v5.RootPart.CFrame = v5.CFrame
	fn6(v5.CFrame.Position)
	return true
end

local function fn12()
	local character = localPlayer.Character
	local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

	for k, v5 in pairs(tbl3) do
		if type(v5) == "table" then
			v5.cancelled = true
		end
	end

	table.clear(tbl3)

	if humanoidRootPart then
		humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
		humanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
	end

	fn9()
	fn8()
end

genv.__SenaV4TweenRuntimeCleanup = function()
	for k, v5 in pairs(tbl3) do
		if type(v5) == "table" then
			v5.cancelled = true
		end
	end

	table.clear(tbl3)
	fn9()
	fn8()
end

local function fn13()
	return getgenv and getgenv() or _G
end

local function fn14()
	local v5 = fn13()
	local tbl4 = v5[key]

	if type(tbl4) ~= "table" or tbl4.Version ~= version then
		if type(tbl4) == "table" then
			tbl4.Enabled = false
		end

		tbl4 = {Version = version, Installed = false, Enabled = false, Mode = "StateBaseline", Humanoid = nil, RootPart = nil, WalkSpeed = defSpeed}
		v5[key] = tbl4
	end

	return tbl4
end

local function fn15(arg, arg2)
	local v5 = fn14()
	if not v5 then
		return false
	end
	local humanoid = arg and arg:FindFirstChildOfClass("Humanoid")
	local humanoidRootPart = arg and arg:FindFirstChild("HumanoidRootPart")
	v5.Humanoid = humanoid
	v5.RootPart = humanoidRootPart
	v5.WalkSpeed = math.clamp(tonumber(arg2) or defSpeed, minSpeed, maxSpeed * headroom)
	v5.Enabled = false
	return humanoid ~= nil and humanoidRootPart ~= nil
end

local function fn16()
	local v5 = fn13()[key]

	if type(v5) == "table" then
		v5.Enabled = false
		v5.Humanoid = nil
		v5.RootPart = nil
	end
end

local function fn17(arg, arg2, arg3)
	local v5

	if type(getcallbackvalue) == "function" and type(debug) == "table" and type(debug.getupvalue) == "function" then
		local signal2 = ReplicatedStorage:FindFirstChild("Packages") and ReplicatedStorage.Packages:FindFirstChild("Signal")

		if signal2 then
			local ok, result = pcall(require, signal2)

			if ok and type(result) == "table" and type(result.Invoked) == "function" then
				local ok2, result2 = pcall(result.Invoked, signal)

				if ok2 and result2 then
					local ok3, result3 = pcall(getcallbackvalue, result2, "OnInvoke")

					if ok3 and type(result3) == "function" then
						local ok4, result4 = pcall(debug.getinfo, result3)

						if ok4 then
							local function fn18(arg4, arg5, arg6)
								if v5 then
									return
								elseif type(arg4) ~= "table" then
									return
								elseif arg5 > 3 then
									return
								elseif arg6[arg4] then
									return
								end

								arg6[arg4] = true
								if rawget(arg4, "Player") == arg and (rawget(arg4, "Character") == arg.Character and (rawget(arg4, "Humanoid") == arg2 and (rawget(arg4, "RootPart") == arg3 and (type(rawget(arg4, "SampleHistory")) == "table" and type(rawget(arg4, "Evidence")) == "table")))) then
									v5 = arg4
									return
								end
								local n4 = 0

								for k, v6 in pairs(arg4) do
									n4 += 1
									if n4 > 128 then
										break
									end

									if type(v6) == "table" then
										fn18(v6, arg5 + 1, arg6)
									end
								end
							end

							for i = 1, result4.nups or 0, 1 do
								local ok5, result5 = pcall(debug.getupvalue, result3, i)

								if ok5 and type(result5) == "table" then
									fn18(result5, 0, {})
									if v5 then
										break
									end
								end
							end
						end
					end
				end
			end
		end
	end

	if not v5 and type(getgc) == "function" then
		local ok, result = pcall(getgc, true)

		if ok and type(result) == "table" then
			for i, v6 in ipairs(result) do
				if type(v6) == "table" and rawget(v6, "Player") == arg and rawget(v6, "Character") == arg.Character and rawget(v6, "Humanoid") == arg2 and rawget(v6, "RootPart") == arg3 and type(rawget(v6, "SampleHistory")) == "table" and type(rawget(v6, "Evidence")) == "table" then
					v5 = v6
					break
				end
			end
		end
	end

	return v5
end

local tbl4 = {busy = false, nextAt = 0, misses = 0, found = nil}

local function fn18(arg, arg2, arg3)
	local found = tbl4.found
	if type(found) == "table" and (rawget(found, "Player") == arg and (rawget(found, "Character") == arg.Character and (rawget(found, "Humanoid") == arg2 and rawget(found, "RootPart") == arg3))) then
		return found
	end

	if tbl4.busy then
		return nil
	elseif os.clock() < tbl4.nextAt then
		return nil
	end

	tbl4.busy = true

	task.spawn(function()
		task.wait()
		local ok, result = pcall(fn17, arg, arg2, arg3)
		local v5 = ok and result or nil
		tbl4.found = v5
		tbl4.misses = v5 and 0 or tbl4.misses + 1
		tbl4.nextAt = os.clock() + (v5 and 0.2 or (tbl4.misses >= 5 and 10 or 1))
		tbl4.busy = false
	end)

	return nil
end

local function fn19(arg, arg2, arg3)
	if type(arg) ~= "table" then
		return false
	end
	local value = rawget(arg, "RootPart")
	local cFrame = value and value.Parent and value.CFrame or nil
	local position = cFrame and cFrame.Position or nil
	local vector = typeof(arg3) == "Vector3" and arg3 or Vector3.new(0, 0, 0)

	local function fn20(arg4)
		if type(arg4) == "table" then
			rawset(arg4, "WalkSpeed", arg2)

			if cFrame then
				rawset(arg4, "CFrame", cFrame)
				rawset(arg4, "Position", position)
				rawset(arg4, "LinearVelocity", vector)
				rawset(arg4, "AngularVelocity", (Vector3.new(0, 0, 0)))
			end
		end
	end

	for i, field in ipairs(fields) do
		fn20(rawget(arg, field))
	end

	for k, v5 in pairs(rawget(arg, "SampleHistory") or {}) do
		fn20(v5)
	end

	for k, v5 in pairs(rawget(arg, "SafeGroundCheckpoints") or {}) do
		fn20(v5)
	end

	local value2 = rawget(arg, "Evidence")

	if type(value2) == "table" then
		value2.Speed = 0
		value2.Teleport = 0
		value2.Flight = 0
	end

	local value3 = rawget(arg, "ImpulseContext")

	if type(value3) == "table" then
		local maxHorizontalSpeed = math.max(tonumber(value3.MaxHorizontalSpeed) or 0, arg2)
		local n4 = math.max((tonumber(value3.ExpiresAt) or 0) - (tonumber(value3.StartedAt) or 0), clamp)
		value3.MaxHorizontalSpeed = maxHorizontalSpeed

		if position then
			value3.OriginPosition = position
		end

		value3.MaxHorizontalDistance = math.max(tonumber(value3.MaxHorizontalDistance) or 0, maxHorizontalSpeed * n4 + padding * 2)
		fn20(value3.PreMovementSafeSample)
	end

	if rawget(arg, "CorrectionContext") == nil then
		rawset(arg, "FirstSuspiciousAt", nil)

		if rawget(arg, "ThreatLevel") == "Observing" then
			rawset(arg, "ThreatLevel", "Trusted")
		end
	end

	return true
end

local function fn20()
	local v5 = fn13()
	local tbl5 = v5[integrityKey]

	if type(tbl5) ~= "table" then
		tbl5 = {}
		v5[integrityKey] = tbl5
	end

	return tbl5
end

local function fn21(arg, arg2, arg3)
	return type(arg) == "table" and rawget(arg, "Player") == localPlayer and rawget(arg, "Character") == localPlayer.Character and rawget(arg, "Humanoid") == arg2 and rawget(arg, "RootPart") == arg3
end

local function fn22(arg, arg2, arg3)
	return fn21(arg, arg2, arg3)
end

local function fn23(humanoid, rootPart, arg)
	local v5 = fn20()
	local state = v5.State

	if fn21(state, humanoid, rootPart) then
	else
		local now = os.clock()
		if now < (v5.NextSearchAt or 0) then
			return false
		end
		v5.NextSearchAt = now + 0.2
		state = fn18(localPlayer, humanoid, rootPart)
	end

	if not state then
		return false
	end

	if not fn22(state, humanoid, rootPart) then
		v5.Enabled = false
		v5.Humanoid = humanoid
		v5.RootPart = rootPart
		v5.State = state
		return false
	end

	v5.NextSearchAt = 0
	v5.Enabled = true
	v5.Humanoid = humanoid
	v5.RootPart = rootPart
	v5.State = state
	v5.WalkSpeed = math.clamp(arg * headroom, minSpeed, maxSpeed * headroom)
	v5.TravelVelocity = Vector3.new(0, 0, 0)
	fn19(state, v5.WalkSpeed, v5.TravelVelocity)
	return true
end

local function fn24(arg, arg2, arg3, travelVelocity)
	local v5 = fn13()[integrityKey]

	if type(v5) ~= "table" then
		return false
	elseif v5.Enabled then
		if v5.Humanoid ~= arg then
			return false
		elseif v5.RootPart ~= arg2 then
			return false
		elseif not fn22(v5.State, arg, arg2) then
			return false
		end
	else
		return false
	end

	v5.WalkSpeed = math.clamp(arg3 * headroom, minSpeed, maxSpeed * headroom)

	if typeof(travelVelocity) == "Vector3" then
		v5.TravelVelocity = travelVelocity
	elseif typeof(v5.TravelVelocity) ~= "Vector3" then
		v5.TravelVelocity = Vector3.new(0, 0, 0)
	end

	return fn19(v5.State, v5.WalkSpeed, v5.TravelVelocity)
end

local function fn25(arg)
	local v5 = fn13()[integrityKey]
	if type(v5) ~= "table" then
		return
	end

	if arg == nil or v5.Humanoid == arg then
		v5.Enabled = false
		v5.Humanoid = nil
		v5.RootPart = nil
		v5.State = nil
		v5.TravelVelocity = nil
		v5.NextSearchAt = 0
	end
end

local connection3

local function fn26()
	if connection3 then
		return
	end

	connection3 = RunService.PreSimulation:Connect(function()
		if genv.__SenaV4TweenRuntimeGeneration ~= v then
			local v5 = connection3
			connection3 = nil

			if v5 then
				pcall(v5.Disconnect, v5)
			end

			return
		end

		local character = localPlayer.Character
		local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")

		if character then
			if humanoidRootPart then
				if not humanoid then
					return
				end
			else
				return
			end
		else
			return
		end

		local v5 = fn4()
		fn15(character, v5 * headroom)

		if not fn24(humanoid, humanoidRootPart, v5) then
			fn23(humanoid, humanoidRootPart, v5)
		end

		fn11()
	end)
end

local function fn27()
	if connection3 then
		pcall(connection3.Disconnect, connection3)
		connection3 = nil
	end

	fn16()
	fn25()
end

genv.__SenaV4TweenRuntimeCleanup = function()
	fn12()
	fn27()
end

local function fn28()
	local character = localPlayer.Character
	local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart then
		return
	end
	local assemblyLinearVelocity = humanoidRootPart.AssemblyLinearVelocity
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local walkSpeed = humanoid and humanoid.WalkSpeed or 0
	local vector = Vector3.new(assemblyLinearVelocity.X, 0, assemblyLinearVelocity.Z)

	if vector.Magnitude > math.max(400, walkSpeed * 1.5) or math.abs(assemblyLinearVelocity.Y) > 400 then
		local n4 = math.max(100, walkSpeed)
		local v5 = if vector.Magnitude > n4 then vector.Unit * n4 else vector
		humanoidRootPart.AssemblyLinearVelocity = Vector3.new(v5.X, math.clamp(assemblyLinearVelocity.Y, -100, 100), v5.Z)
	end
end

RunService.Heartbeat:Connect(fn28)
local flag = false

pcall(function()
	local queueOnTeleport = queue_on_teleport or queueonteleport or syn and syn.queue_on_teleport

	if queueOnTeleport then
		pcall(queueOnTeleport, "")
	end
end)

pcall(function()
	game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Health, false)
end)

local connection4, connection5

local function fn29(arg)
	if not arg then
		return
	end
	local humanoid = arg:WaitForChild("Humanoid", 5) or arg:FindFirstChildOfClass("Humanoid")

	if not arg:WaitForChild("HumanoidRootPart", 5) then
		arg:FindFirstChild("HumanoidRootPart")
	end

	if not humanoid then
		return
	end
	local health = math.max(humanoid.MaxHealth, 100)
	local flag2 = false
	local n4 = 0

	local function fn30()
		if flag2 then
			return
		elseif not humanoid.Parent then
			return
		end

		local now = os.clock()
		if now - n4 < 0.1 and (humanoid.Health > 0 and humanoid:GetState() ~= Enum.HumanoidStateType.Dead) then
			return
		end
		n4, flag2 = now, true

		pcall(function()
			humanoid.BreakJointsOnDeath = false
			humanoid.RequiresNeck = false
			humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
			humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
			humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)

			if humanoid.Health <= 0 then
				humanoid.Health = health
			end

			if humanoid:GetState() == Enum.HumanoidStateType.Dead then
				humanoid:ChangeState(Enum.HumanoidStateType.Running)
			end
		end)

		flag2 = false
	end

	fn30()

	if connection4 then
		pcall(connection4.Disconnect, connection4)
	end

	if connection5 then
		pcall(connection5.Disconnect, connection5)
	end

	connection4 = humanoid.HealthChanged:Connect(function(health2)
		if health2 <= 0 then
			fn30()
		elseif health2 < health then
			fn30()
		end
	end)

	connection5 = RunService.Heartbeat:Connect(fn30)
end

task.spawn(function()
	fn29(localPlayer.Character or localPlayer.CharacterAdded:Wait())
end)

local function fn30(character)
	fn29(character)
end

localPlayer.CharacterAdded:Connect(fn30)
local senaV4Config = {AutoSteal = false, HelpFriend = false, LowSpeedBoost = false, StarAlert = true, ScrambleTradeInTrade = false, ScrambleTradeInReroll = false, ScrambleTradeInBanners = {}, ScrambleBossAuto = false, StealMode = "Instant", FlyAerial = false, FlyZigzag = false, StealHoldSeconds = 5, StealAreas = {"None"}, StealRarities = {"None"}, StealNamesFilter = {"None"}, StealMinValue = 0, StealMutations = {"None"}, StealMinWeight = 0, StealPriority = "Rarity", TaskOrder = {"auto_steal", "race", "star", "mech_boss", "butterfly", "auto_place", "use_scrambled", "auto_sell", "treadmill"}, AutoFavorite = false, FavMode = "Rarity", FavRarities = {"None"}, FavSpecies = {"None"}, AutoEquipBest = false, AutoClaimOffline = false, AutoBaseUpgrade = false, AutoClaimAlmanac = false, AutoFusePets = false, ScrambleAutoBuy = false, ScrambleBuyList = {}, ButterflyAutoNet = false, ButterflyAutoCatch = false, ButterflyEsp = false, ButterflyTiers = {}, ButterflyAutoTrade = false, ButterflyTradeRecipe = "All", ButterflyCatchMode = "Tween", ButterflyAutoCraft = false, WispAutoQuest = false, BanjoAuto = false, Noclip = false, BottingMode = false, AntiCutscene = false, FuseSelectedOnly = false, FuseRarities = {"None"}, FuseSpecies = {"None"}, EspDetails = {"Name", "Rarity", "Value"}, BackpackRateEsp = false, AntiAFK = true, AutoReconnect = true, AutoExecute = false, AutoPlace = false, PlaceRarities = {"None"}, AutoHatch = false, SellAll = false, AutoSell = false, SellNames = {"None"}, SellRarities = {"None"}, AutoSellEgg = false, SellEggRarities = {"None"}, WebhookEnabled = false, WebhookURL = "", WebhookDisconnect = false, TweenSpeedMultiplier = 60, AutoTreadmillIdle = false, AutoTreadmillUpgrade = false, AntiTreadmill = false, HopNoMatch = false, PrivateServerMax = "2", PrivateServerAuto = false, HopCooldown = 5, AutoIndex = false, AntiHitGuard = false, FlyForCapture = false, AutoStealCapture = false, InstantGrab = false, InfiniteJump = false, WalkSpeedMultiplier = 1, AntiGuardKnockback = true, GodMode = true, EggPredictUI = false, EggESP = false, StealPlayers = false, StealPlayerRarities = {"None"}, StealPlayerMinValue = 0, StealPlayerTarget = "Any Player", WebhookRarities = {"None"}, WebhookMinValue = 0}
local EggState = require(game:GetService("ReplicatedStorage").Client.EggState)
EggState.GetAreaEggSnapshot = EggState.ReadFieldEggs
EggState.GetAreaEggRecord = EggState.ReadFieldEgg
EggState.RequestAreaEggSnapshot = EggState.SyncFieldEggs
EggState.RequestCarryAreaEgg = EggState.CarryFieldEgg
EggState.RequestDropHeldAreaEgg = EggState.DropFieldEgg
EggState.AreaEggCarryStateChanged = EggState.CarryChanged
EggState.AreaEggClaimed = EggState.FieldClaimed
EggState.AreaEggUpdated = EggState.FieldShifted
EggState.AreaEggRemoved = EggState.FieldGone
EggState.GetOwnerRuntimeRecords = EggState.ReadOwnerEggs
EggState.RequestEquipTool = EggState.WearEggTool
EggState.RequestPlaceEgg = EggState.PlantEgg
EggState.RequestHatchEgg = EggState.BeginHatch
EggState.RequestCompleteHatchEgg = EggState.FinishHatch
EggState.RequestRuntimeSnapshot = EggState.SyncOwnedEggs
EggState.RuntimeOwnerUpdated = EggState.OwnerRefreshed
EggState.RuntimeOwnerCleared = EggState.OwnerCleared
local PlotState = require(game:GetService("ReplicatedStorage").Client.PlotState)
PlotState.GetMySlot = PlotState.ResolveLocalSlot
PlotState.GetPlotsFolder = PlotState.ResolveFolder
PlotState.IsWorldPositionWithinLocalPlotBounds = PlotState.ContainsLocalPoint
PlotState.GetPlotData = PlotState.ResolvePlot
local AreaEggResetWall = require(game:GetService("ReplicatedStorage").Client.AreaEggResetWall)
AreaEggResetWall.IsClosed = AreaEggResetWall.IsSealed

fn4 = function()
	if genv.__SenaV4AdminBoost == true then
		return 4000
	end
	return math.clamp(math.floor((tonumber(senaV4Config.TweenSpeedMultiplier) or v2.DEF_INPUT) + 0.5), v2.MIN_INPUT, v2.MAX_INPUT) * v2.MULTIPLIER
end

senaV4Config.applyStealValueInput = function(arg, arg2)
	local str3 = string.lower(tostring(arg2 or "")):gsub("[%s,]", "")
	if str3 == "" then
		arg.StealMinValue = 0
		return true
	end
	local v5, v6 = string.match(str3, "^([%d]+%.?[%d]*)([kmb]?)$")
	local num = tonumber(v5)
	if not num then
		return false
	end
	arg.StealMinValue = num * (if v6 == "k" then 1000 else if v6 == "m" then 1000000 else if v6 == "b" then 1000000000 else 1)
	return true
end

senaV4Config.getAreaEggValue = function(arg, arg2)
	if not arg._assetGenerationUtil then
		arg._assetGenerationUtil = require(game:GetService("ReplicatedStorage").Shared.Util.AssetEarnings)
	end

	return arg._assetGenerationUtil.MutationOnlyRatePerSecond({Category = arg2.AssetCategory, Scale = arg2.AssetScale or 1, Mutations = arg2.Mutations or {}, BaseMutation = arg2.BaseMutation, EyeColor = arg2.AssetEyeColor, ColorSeed = arg2.AssetColorSeed, ColorIndex = arg2.AssetColorIndex, Gender = arg2.Gender, Personality = arg2.Personality or "Normal", HasBeenFirstPlaced = arg2.HasBeenFirstPlaced == true})
end

local AreaEggCycle, AreaEggResetWall2

pcall(function()
	AreaEggCycle = require(ReplicatedStorage.Shared.Util.AreaEggCycle)
	AreaEggResetWall2 = require(ReplicatedStorage.Client.AreaEggResetWall)
end)

local function fn31()
	if AreaEggCycle and type(AreaEggCycle.IsNightPhase) == "function" then
		local ok, result = pcall(AreaEggCycle.IsNightPhase, workspace:GetServerTimeNow())
		if ok and result == true then
			return true
		end
	end

	if AreaEggResetWall2 then
		if type(AreaEggResetWall2.IsSealed) == "function" then
			local ok, result = pcall(AreaEggResetWall2.IsSealed)
			if ok and result == true then
				return true
			end
		end

		if type(AreaEggResetWall2.IsClosed) == "function" then
			local ok, result = pcall(AreaEggResetWall2.IsClosed)
			if ok and result == true then
				return true
			end
		end
	end

	return false
end

local senaV4TaskLadder = {}

do
	senaV4TaskLadder.DEFAULT = {"auto_steal", "race", "star", "mech_boss", "butterfly", "auto_place", "use_scrambled", "auto_sell", "treadmill"}
	senaV4TaskLadder.TITLES = {auto_steal = "Auto Steal", race = "Race Rally", star = "Shooting Star", mech_boss = "Mech Boss", butterfly = "Butterfly Bloom", auto_place = "Auto Place", use_scrambled = "Use Scrambled", auto_sell = "Auto Sell", treadmill = "Treadmill"}
	senaV4TaskLadder.PINNED = {treadmill = true}
	local tbl5 = {}

	senaV4TaskLadder.register = function(arg, arg2)
		tbl5[arg] = arg2
	end

	senaV4TaskLadder.sanitize = function(arg)
		local tbl6 = {}
		local tbl7 = {}

		local function fn32(arg2)
			local str3 = tostring(arg2)

			if senaV4TaskLadder.TITLES[str3] and (not tbl7[str3] and not senaV4TaskLadder.PINNED[str3]) then
				tbl7[str3] = true
				tbl6[#tbl6 + 1] = str3
			end
		end

		for i, v5 in ipairs(type(arg) == "table" and arg or {}) do
			fn32(v5)
		end

		for i, v5 in ipairs(senaV4TaskLadder.DEFAULT) do
			fn32(v5)
		end

		for i, v5 in ipairs(senaV4TaskLadder.DEFAULT) do
			if senaV4TaskLadder.PINNED[v5] and not tbl7[v5] then
				tbl7[v5] = true
				tbl6[#tbl6 + 1] = v5
			end
		end

		return tbl6
	end

	local v5, v6

	senaV4TaskLadder.order = function()
		local taskOrder = senaV4Config and senaV4Config.TaskOrder

		if taskOrder ~= v6 or not v5 then
			v6 = taskOrder
			v5 = senaV4TaskLadder.sanitize(taskOrder)
		end

		return v5
	end

	senaV4TaskLadder.rank = function(arg)
		for i, v7 in ipairs(senaV4TaskLadder.order()) do
			if v7 == arg then
				return i
			end
		end

		return 1 / 0
	end

	local function fn32(arg, arg2)
		local result = tbl5[arg]
		local v7 = result and result[arg2]
		if type(v7) ~= "function" then
			return nil
		end
		arg2, result = pcall(v7)
		if arg2 then
			return result
		end
		return nil
	end

	senaV4TaskLadder.wants = function(arg)
		return fn32(arg, "wants") == true
	end

	senaV4TaskLadder.active = function(arg)
		return fn32(arg, "active") == true
	end

	senaV4TaskLadder.enabled = function(arg)
		return fn32(arg, "enabled") == true
	end

	senaV4TaskLadder.bossFighting = function()
		if localPlayer:GetAttribute("InScrambleArena") == true then
			return true
		end

		if type(localPlayer:GetAttribute("RaceId")) == "string" then
			return true
		end
		local senaV4ScrambleBoss = genv.__SenaV4ScrambleBoss
		return senaV4ScrambleBoss ~= nil and not senaV4ScrambleBoss.destroyed and senaV4ScrambleBoss.enabled == true and senaV4ScrambleBoss:_inArena() == true
	end

	senaV4TaskLadder.stealCarrying = function()
		local senaV4EggRuntime = genv.__SenaV4EggRuntime

		if senaV4EggRuntime then
			if senaV4EggRuntime.destroyed then
				return false
			end
		else
			return false
		end

		if senaV4EggRuntime._instantReturnToken ~= nil then
			return true
		elseif senaV4EggRuntime._forestDropInProgress ~= nil then
			return true
		end

		local carry = senaV4EggRuntime.carry
		return carry ~= nil and carry.active == true and carry.uid ~= nil and carry.uid ~= senaV4EggRuntime.primerUid
	end

	local tbl6 = {}

	local function fn33(arg)
		if arg ~= "mech_boss" and senaV4TaskLadder.bossFighting() then
			return "mech_boss"
		end

		if arg ~= "auto_steal" and senaV4TaskLadder.stealCarrying() then
			return "auto_steal"
		end

		for i, v7 in ipairs(senaV4TaskLadder.order()) do
			if v7 == arg then
				return nil
			end

			if senaV4TaskLadder.wants(v7) then
				return v7
			end
		end

		return nil
	end

	senaV4TaskLadder.blocker = function(arg)
		local now = os.clock()
		local v7 = tbl6[arg]
		if v7 and now - v7.at < 0.1 then
			return v7.value
		end
		local v8 = fn33(arg)

		if v7 then
			v7.at = now
			v7.value = v8
		else
			tbl6[arg] = {at = now, value = v8}
		end

		return v8
	end

	senaV4TaskLadder.holder = function(arg)
		for i, v7 in ipairs(senaV4TaskLadder.order()) do
			if v7 ~= arg and (not senaV4TaskLadder.PINNED[v7] and senaV4TaskLadder.active(v7)) then
				return v7
			end
		end

		return nil
	end

	senaV4TaskLadder.yieldLabel = function(arg)
		local v7 = senaV4TaskLadder.blocker(arg)
		return v7 and "Yielding to " .. senaV4TaskLadder.TITLES[v7] or nil
	end

	senaV4TaskLadder.current = function()
		if senaV4TaskLadder.bossFighting() then
			return "mech_boss"
		end

		if senaV4TaskLadder.stealCarrying() then
			return "auto_steal"
		end

		for i, v7 in ipairs(senaV4TaskLadder.order()) do
			if senaV4TaskLadder.active(v7) then
				return v7
			end
		end

		return nil
	end

	senaV4TaskLadder.describe = function(arg)
		if not senaV4TaskLadder.enabled(arg) then
			return "Off", "off"
		end
		local v7 = fn32(arg, "status")
		local flag2 = type(v7) == "string" and v7 ~= "" and v7 or nil

		if senaV4TaskLadder.active(arg) then
			return flag2 or "Running", "run"
		elseif senaV4TaskLadder.current() == arg then
			return flag2 or "Running", "run"
		end

		local v8 = senaV4TaskLadder.blocker(arg)
		if v8 and senaV4TaskLadder.wants(arg) then
			return "Yielding to " .. senaV4TaskLadder.TITLES[v8], "wait"
		end
		return flag2 or "Idle", "off"
	end
end

genv.__SenaV4TaskLadder = senaV4TaskLadder

local function fn32()
	return senaV4TaskLadder.blocker("auto_sell") == nil
end

local function fn33(arg)
	if not arg or type(arg.GetValue) ~= "function" then
		return nil
	end

	local ok, result = pcall(function()
		return arg:GetValue()
	end)

	if not ok then
		return nil
	end

	if type(result) == "table" then
		local tbl5 = {}

		for k, v5 in pairs(result) do
			if type(k) == "number" then
				table.insert(tbl5, v5)
			elseif type(k) == "string" then
				if v5 == true then
					table.insert(tbl5, k)
				end
			end
		end

		return tbl5
	end

	if type(result) == "string" then
		return {result}
	end
	return nil
end

local function fn34(arg, arg2, arg3, arg4)
	if senaV4Config.SellAll then
		return true
	end

	if type(arg3) ~= "table" then
		return false
	elseif type(arg4) ~= "table" then
		return false
	end

	return (if #arg3 == 0 then false else if table.find(arg3, "None") then false else if table.find(arg3, "All") then true else table.find(arg3, arg) ~= nil) or (if #arg4 == 0 then false else if table.find(arg4, "None") then false else if table.find(arg4, "All") then true else table.find(arg4, arg2) ~= nil)
end

local function fn35(arg, arg2)
	if type(arg2) ~= "table" then
		return false
	end

	if #arg2 == 0 then
		return false
	elseif table.find(arg2, "None") then
		return false
	end

	if table.find(arg2, "All") then
		return true
	end
	return table.find(arg2, arg) ~= nil
end

local function fn36(arg)
	local humanoidRootPart = arg and arg:FindFirstChild("HumanoidRootPart")

	if humanoidRootPart then
		humanoidRootPart:SetAttribute("KillPartIgnore", true)
	end
end

local n4 = 0.15
local n5 = 0.4
local vector = Vector3.new(542.93, 71.5, -405.58)
local n6 = 5
local tbl5 = {CarryRetry = 0.25, CarryTimeout = 2, EarlyCarryDistance = 8, SafeStable = 0.35, ReturnValidation = 0.08, NextTarget = 0.05, SafeHandoff = 0.15}

local function fn37(arg)
	local tweenSpeedMultiplier = math.clamp(math.floor((tonumber(arg) or v2.DEF_INPUT) + 0.5), v2.MIN_INPUT, v2.MAX_INPUT)
	if math.abs((senaV4Config.TweenSpeedMultiplier or 0) - tweenSpeedMultiplier) <= 0.001 then
		return
	end
	senaV4Config.TweenSpeedMultiplier = tweenSpeedMultiplier
end

local n7 = 0.08
local tbl6 = {}

local function fn38(arg, cameraSubject, arg2, arg3, arg4, arg5, arg6)
	if arg then
		if not cameraSubject then
			return false
		elseif typeof(arg2) ~= "CFrame" then
			return false
		end
	else
		return false
	end

	if arg3 and arg3() then
		return false
	end
	local v5 = tbl6[arg]

	if v5 then
		v5.cancelled = true
		tbl6[arg] = nil
	end

	local parent = arg.Parent
	if not parent then
		return false
	end
	fn9()
	fn36(parent)
	fn26()
	local currentCamera = workspace.CurrentCamera

	if currentCamera and currentCamera.CameraSubject ~= cameraSubject then
		pcall(function()
			currentCamera.CameraSubject = cameraSubject
		end)
	end

	local autoRotate = cameraSubject.AutoRotate
	cameraSubject.AutoRotate = false
	local n8 = arg6 and math.max(arg.Position.Y, arg2.Position.Y + n6, vector.Y + n6) or nil
	local n9 = n8 and CFrame.new(arg2.Position.X, n8, arg2.Position.Z) * arg2.Rotation or arg2
	local n10 = math.clamp(fn4(), v2.MIN_SPEED, genv.__SenaV4AdminBoost == true and 3000 or v2.MAX_SPEED)
	fn15(parent, n10 * v2.HEADROOM)
	local tbl7 = {cancelled = false}
	tbl6[arg] = tbl7
	fn7()
	local str3 = n8 and (math.abs(arg.Position.Y - n8) > 0.35 and "takeoff" or "cruise") or nil
	local magnitude = (n9.Position - arg.Position).Magnitude
	local n11 = os.clock() + math.max(magnitude / n10, n7) * 3 + 8
	local v6, now
	local n12 = 0
	local flag2 = false
	local flag3 = false

	while not tbl7.cancelled do
		if arg3 and arg3() then
			break
		end

		if not arg.Parent then
			break
		end

		if os.clock() >= n11 then
			break
		end
		local result = RunService.Heartbeat:Wait()
		local n13 = math.max(math.min(result, n4), 0.004166666666666667)
		local n14 = math.clamp(fn4(), v2.MIN_SPEED, genv.__SenaV4AdminBoost == true and 3000 or v2.MAX_SPEED)
		fn15(parent, n14 * v2.HEADROOM)
		local v7 = fn13()[v2.INTEGRITY_KEY]
		local state = type(v7) == "table" and v7.State or nil

		if fn22(state, cameraSubject, arg) then
			local position = arg.Position
			local n15 = n9.Position - position
			local magnitude2 = n15.Magnitude
			local vector2 = Vector3.new(n15.X, 0, n15.Z)
			str3 = if n8 then if str3 == "takeoff" then if math.abs(position.Y - n8) <= 0.35 then "cruise" else str3 else str3 else str3
			local n16 = (n8 and str3 == "takeoff" and Vector3.new(position.X, n8, position.Z) or n9.Position) - position
			local magnitude3 = n16.Magnitude
			local magnitude4 = n8 and vector2.Magnitude or magnitude2
			n12 = if v6 then if magnitude4 > v6 + 2 then os.clock() + 0.5 else n12 else n12
			local n17 = (os.clock() < n12 and math.max(v2.MIN_SPEED, n14 * 0.45) or n14) * n13

			if arg5 then
				if flag2 then
				else
					if magnitude2 <= tbl5.EarlyCarryDistance then
						task.spawn(arg5)
						flag2 = true
					end
				end
			end

			local vector3 = Vector3.new(arg.CFrame.LookVector.X, 0, arg.CFrame.LookVector.Z)
			local unit = vector2.Magnitude > 0.001 and vector2.Unit or (vector3.Magnitude > 0.001 and vector3.Unit or Vector3.new(0, 0, -1))

			if (if n8 then str3 == "cruise" else not n8) and magnitude2 <= math.max(n17, 0.05) then
				now = if magnitude2 > 0.5 then nil else now
				fn6(n9.Position)
				arg.CFrame = CFrame.lookAt(n9.Position, n9.Position + unit)
				arg.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
				arg.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
				fn6(n9.Position)
				fn24(cameraSubject, arg, n14, (Vector3.new(0, 0, 0)))
				now = now or os.clock()

				if os.clock() - now >= n5 then
					v6 = magnitude4
					flag3 = true
					break
				end
			else
				now = nil

				if magnitude3 <= 0.001 then
					arg.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
					arg.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
					fn6(position)
					v6 = magnitude4
					continue
				end

				local n18 = math.min(n17, magnitude3)
				local n19 = position + n16.Unit * n18
				local n20 = (n19 - position) / n13
				fn6(n19)
				arg.CFrame = CFrame.lookAt(n19, n19 + unit)
				arg.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
				fn6(n19)

				if not fn24(cameraSubject, arg, n14, n20) then
					fn23(cameraSubject, arg, n14)
					fn24(cameraSubject, arg, n14, n20)
				end
			end

			v6 = magnitude4
		else
			v6 = nil
			now = nil
			arg.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
			arg.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
			fn6(arg.Position)

			if fn21(state, cameraSubject, arg) then
				fn19(state, n14 * v2.HEADROOM, (Vector3.new(0, 0, 0)))
			else
				fn23(cameraSubject, arg, n14)
			end
		end
	end

	if cameraSubject.Parent and autoRotate ~= nil then
		cameraSubject.AutoRotate = autoRotate
	end

	arg.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
	arg.AssemblyAngularVelocity = Vector3.new(0, 0, 0)

	if flag3 then
		if arg4 then
			fn10(arg, n9)
		else
			fn8()
		end
	else
		fn8()
	end

	return flag3 and not tbl7.cancelled
end

do
	local function fn39(arg, cFrame)
		if not arg or typeof(cFrame) ~= "CFrame" then
			return false
		end

		if not pcall(function()
			arg.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
			arg.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
			arg.CFrame = cFrame
			arg.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
			arg.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
		end) then
			return false
		end

		fn6(cFrame.Position)
		local parent = arg.Parent
		local humanoid = parent and parent:FindFirstChildOfClass("Humanoid")

		if humanoid then
			local n8 = math.clamp(fn4(), v2.MIN_SPEED, genv.__SenaV4AdminBoost == true and 3000 or v2.MAX_SPEED)
			fn15(parent, n8 * v2.HEADROOM)

			if not fn24(humanoid, arg, n8, (Vector3.new(0, 0, 0))) then
				fn23(humanoid, arg, n8)
				fn24(humanoid, arg, n8, (Vector3.new(0, 0, 0)))
			end
		end

		return true
	end

	getgenv().SenaV4Config = senaV4Config

	local function fn40(arg)
		if arg and arg.Name == "PlayerTrap" then
			pcall(function()
				arg:Destroy()
			end)
		end
	end

	local function fn41()
		local function fn42(arg)
			if not arg then
				return
			end

			for i, child in ipairs(arg:GetChildren()) do
				fn40(child)
			end

			local function fn43(child)
				fn40(child)
			end

			arg.ChildAdded:Connect(fn43)
		end

		local transient = workspace:FindFirstChild("Transient")

		if transient then
			fn42(transient)
		end

		local debris = workspace:FindFirstChild("__DEBRIS")

		if debris then
			fn42(debris)
		end

		local v5 = workspace

		local function fn43(child)
			if child.Name == "Transient" then
				fn42(child)
			elseif child.Name == "__DEBRIS" then
				fn42(child)
			elseif child.Name == "PlayerTrap" then
				fn40(child)
			elseif child.Name:lower():find("trap") then
				fn40(child)
			end
		end

		v5.ChildAdded:Connect(fn43)

		task.spawn(function()
			while fn2() do
				for i, v6 in ipairs({workspace:FindFirstChild("Transient"), workspace:FindFirstChild("__DEBRIS")}) do
					if v6 then
						for i2, child in ipairs(v6:GetChildren()) do
							fn40(child)
						end
					end
				end

				task.wait(1.5)
			end
		end)
	end

	task.spawn(fn41)
	local v5
	local flag2 = false
	local tbl7 = {HoldSeconds = 0.3, ConfirmStableSeconds = 0.3, ConfirmTimeout = 2.5, PollSeconds = 0.05, ArrivalSettle = 0.5, DecoyName = "__SenaV4TweenTreadmillDecoy"}

	local function fn42()
		local ok, result = pcall(function()
			return require(game:GetService("ReplicatedStorage").Shared.Remotes).Treadmill.AskRenderSnapshot:InvokeServer()
		end)

		if ok then
			if type(result) ~= "table" then
				return nil
			end
		else
			return nil
		end

		return table.find(result, localPlayer.UserId) ~= nil
	end

	local function fn43()
		local ok, result, result2 = pcall(function()
			return require(game:GetService("ReplicatedStorage").Shared.Remotes).Treadmill.AskDoff:InvokeServer()
		end)

		if not ok then
			return false, tostring(result)
		end

		if result ~= true then
			return false, tostring(result2)
		end
		return true
	end

	local function fn44()
		local ok, result = pcall(function()
			local PlotState2 = require(ReplicatedStorage.Client.PlotState)
			local flag3 = type(PlotState2.ResolveLocalSlot) == "function" and PlotState2.ResolveLocalSlot() or PlotState2.GetMySlot()
			local flag4 = type(PlotState2.ResolveFolder) == "function" and PlotState2.ResolveFolder() or PlotState2.GetPlotsFolder()
			local v6 = flag4 and flag3 and flag4:FindFirstChild(tostring(flag3))
			local treadmillBottom = v6 and v6:FindFirstChild("TreadmillBottom")

			if treadmillBottom then
				if not treadmillBottom:IsA("BasePart") then
					return nil
				end
			else
				return nil
			end

			local character = localPlayer.Character
			local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
			local humanoid = character and character:FindFirstChildOfClass("Humanoid")

			if humanoidRootPart then
				if not humanoid then
					return nil
				end
			else
				return nil
			end

			local n8 = humanoid.RigType == Enum.HumanoidRigType.R15 and humanoidRootPart.Size.Y * 0.5 + math.max(humanoid.HipHeight, 0.5) or humanoidRootPart.Size.Y * 0.5 + 2
			return treadmillBottom.CFrame * CFrame.new(0, treadmillBottom.Size.Y * 0.5 + n8 + 0.05, 0)
		end)

		return ok and result or nil
	end

	tbl7.destroyTrail = function(arg)
		if typeof(arg) == "Instance" and arg:IsA("Trail") then
			pcall(arg.Destroy, arg)
		end
	end

	tbl7.destroyStealPopup = function(arg)
		if senaV4TaskLadder.current() == "auto_steal" and typeof(arg) == "Instance" then
			if arg.Name == "SpeedGainPopup" then
				pcall(arg.Destroy, arg)
			elseif arg.Name == "PlusOne" then
				pcall(arg.Destroy, arg)
			end
		end
	end

	tbl7.purgeStealPopups = function()
		local playerGui = localPlayer:FindFirstChildOfClass("PlayerGui")
		if not playerGui then
			return
		end

		for i, descendant in ipairs(playerGui:GetDescendants()) do
			tbl7.destroyStealPopup(descendant)
		end
	end

	tbl7.guiConnection = localPlayer:WaitForChild("PlayerGui").DescendantAdded:Connect(function(descendant)
		tbl7.destroyStealPopup(descendant)
	end)

	tbl7.removeDecoy = function()
		if tbl7.cameraConnection then
			pcall(tbl7.cameraConnection.Disconnect, tbl7.cameraConnection)
			tbl7.cameraConnection = nil
		end

		if tbl7.characterConnection then
			pcall(tbl7.characterConnection.Disconnect, tbl7.characterConnection)
			tbl7.characterConnection = nil
		end

		for k, v6 in pairs(tbl7.transparency or {}) do
			if typeof(k) == "Instance" and k.Parent then
				pcall(function()
					k.LocalTransparencyModifier = v6
				end)
			end
		end

		tbl7.transparency = nil
		local character = localPlayer.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		local currentCamera = workspace.CurrentCamera

		if currentCamera then
			pcall(function()
				currentCamera.CameraSubject = humanoid or tbl7.cameraSubject
			end)
		end

		tbl7.cameraSubject = nil

		if tbl7.decoy then
			pcall(tbl7.decoy.Destroy, tbl7.decoy)
		end

		tbl7.decoy = nil
	end

	tbl7.spawnDecoy = function(arg)
		tbl7.removeDecoy()
		local character = localPlayer.Character
		if not character then
			return false
		end
		local archivable = character.Archivable
		character.Archivable = true
		local ok, decoy = pcall(character.Clone, character)
		character.Archivable = archivable

		if ok then
			if not decoy then
				return false
			elseif typeof(decoy) ~= "Instance" then
				return false
			end
		else
			return false
		end

		decoy.Name = tbl7.DecoyName

		for i, descendant in ipairs(decoy:GetDescendants()) do
			if descendant:IsA("Script") then
				pcall(descendant.Destroy, descendant)
			elseif descendant:IsA("LocalScript") then
				pcall(descendant.Destroy, descendant)
			elseif descendant:IsA("BillboardGui") then
				pcall(descendant.Destroy, descendant)
			elseif descendant:IsA("Sound") then
				pcall(descendant.Destroy, descendant)
			elseif descendant:IsA("Trail") then
				pcall(descendant.Destroy, descendant)
			elseif descendant:IsA("BasePart") then
				descendant.LocalTransparencyModifier = 0
				descendant.Anchored = true
				descendant.CanCollide = false
				descendant.CanQuery = false
				descendant.CanTouch = false
			end
		end

		local humanoid = decoy:FindFirstChildOfClass("Humanoid")
		if not humanoid then
			decoy:Destroy()
			return false
		end

		pcall(function()
			humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
			humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
		end)

		decoy.Parent = workspace
		decoy:PivotTo(arg)
		tbl7.decoy = decoy
		local transparency = setmetatable({}, {__mode = "k"})

		local function fn45(arg2)
			if arg2 then
				if arg2:IsA("BasePart") then
					if not arg2:IsDescendantOf(character) then
						return
					end
				else
					return
				end
			else
				return
			end

			if transparency[arg2] == nil then
				transparency[arg2] = arg2.LocalTransparencyModifier
			end

			arg2.LocalTransparencyModifier = 1
		end

		for i, descendant in ipairs(character:GetDescendants()) do
			fn45(descendant)
			tbl7.destroyTrail(descendant)
		end

		tbl7.transparency = transparency

		tbl7.characterConnection = character.DescendantAdded:Connect(function(descendant)
			if tbl7.decoy == decoy then
				pcall(fn45, descendant)
				tbl7.destroyTrail(descendant)
			end
		end)

		local currentCamera = workspace.CurrentCamera

		if currentCamera then
			tbl7.cameraSubject = currentCamera.CameraSubject
			currentCamera.CameraSubject = humanoid
		end

		tbl7.cameraConnection = RunService.RenderStepped:Connect(function()
			if tbl7.decoy ~= decoy then
				return
			elseif decoy.Parent then
				if not humanoid.Parent then
					return
				end
			else
				return
			end

			for k in pairs(transparency) do
				if k.Parent and k.LocalTransparencyModifier ~= 1 then
					k.LocalTransparencyModifier = 1
				end
			end

			local currentCamera2 = workspace.CurrentCamera

			if currentCamera2 and currentCamera2.CameraSubject ~= humanoid then
				currentCamera2.CameraSubject = humanoid
			end
		end)

		return true
	end

	tbl7.requestEquip = function()
		local ok, result, result2 = pcall(function()
			return require(ReplicatedStorage.Shared.Remotes).Treadmill.AskWearStill:InvokeServer()
		end)

		if if ok then result == false else not ok then
			return false, tostring(result2 or result)
		end
		return true
	end

	tbl7.prepare = function(arg, arg2)
		local character = localPlayer.Character
		local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")

		if humanoidRootPart then
			if humanoid then
				if typeof(arg) ~= "CFrame" then
					return false
				end
			else
				return false
			end
		else
			return false
		end

		local function fn45()
			return arg2 ~= nil and arg2()
		end

		local function fn46()
			local character2 = localPlayer.Character
			local humanoidRootPart2 = character2 and character2:FindFirstChild("HumanoidRootPart")

			if humanoidRootPart2 then
				fn39(humanoidRootPart2, arg)
				task.wait(0.1)
			end

			tbl7.removeDecoy()
		end

		flag2 = true
		tbl7.purgeStealPopups()
		fn9()
		fn8()
		if not tbl7.spawnDecoy(arg) then
			flag2 = false
			return false
		end
		local v6 = fn44()

		if (if v6 then fn45() else not v6) or not fn39(humanoidRootPart, v6) then
			fn43()
			fn46()
			flag2 = false
			return false
		end

		task.wait(tbl7.ArrivalSettle)

		if fn45() then
			fn43()
			fn46()
			flag2 = false
			return false
		end

		if not tbl7.requestEquip() then
			fn43()
			fn46()
			flag2 = false
			return false
		end

		character, humanoidRootPart = os.clock() + tbl7.ConfirmTimeout
		humanoid = false

		while true do
			local v7 = fn45()
			if not (if v7 then not v7 else os.clock() < character) then
				break
			end

			if fn42() == true then
				humanoidRootPart = humanoidRootPart or os.clock()
				if os.clock() - humanoidRootPart >= tbl7.ConfirmStableSeconds then
					humanoid = true
					break
				end
			else
				humanoidRootPart = nil
			end

			task.wait(tbl7.PollSeconds)
		end

		if if humanoid then fn45() else not humanoid then
			fn43()
			fn46()
			flag2 = false
			return false
		end

		character = os.clock() + tbl7.HoldSeconds

		while true do
			local v7 = fn45()
			if not (if v7 then not v7 else os.clock() < character) then
				break
			end
			task.wait(tbl7.PollSeconds)
		end

		local n8 = os.clock() + tbl7.ConfirmTimeout
		humanoidRootPart = false

		while true do
			local v7 = fn45()
			if not (if v7 then not v7 else os.clock() < n8) then
				break
			end
			fn43()
			task.wait(tbl7.PollSeconds)
			if fn42() == false then
				v5, humanoidRootPart = nil, true
				break
			end
		end

		fn46()
		flag2 = false
		return humanoidRootPart and not fn45()
	end

	tbl7.previousCleanup = genv.__SenaV4TweenRuntimeCleanup

	genv.__SenaV4TweenRuntimeCleanup = function()
		flag2 = false
		fn43()
		tbl7.removeDecoy()

		if tbl7.guiConnection then
			pcall(tbl7.guiConnection.Disconnect, tbl7.guiConnection)
			tbl7.guiConnection = nil
		end

		if type(tbl7.previousCleanup) == "function" then
			tbl7.previousCleanup()
		end
	end

	localPlayer.CharacterRemoving:Connect(function()
		flag2 = false
		tbl7.removeDecoy()
	end)
end

do
	if type(genv.__SenaV4CosmeticSuppressCleanup) == "function" then
		pcall(genv.__SenaV4CosmeticSuppressCleanup)
	end

	local tbl7 = {}

	local function fn39(child)
		if not child or child.Name ~= "DropHeldEgg" then
			return
		end

		if not child:IsA("ScreenGui") and not child:IsA("LayerCollector") then
			return
		end

		pcall(function()
			child.Enabled = false
		end)

		table.insert(tbl7, child:GetPropertyChangedSignal("Enabled"):Connect(function()
			if child.Enabled then
				pcall(function()
					child.Enabled = false
				end)
			end
		end))
	end

	local function fn40()
		local playerGui = localPlayer:FindFirstChildOfClass("PlayerGui")
		if not playerGui then
			return
		end

		for i, child in ipairs(playerGui:GetChildren()) do
			fn39(child)
		end

		table.insert(tbl7, playerGui.ChildAdded:Connect(fn39))
	end

	fn40()

	table.insert(tbl7, localPlayer.CharacterAdded:Connect(function()
		task.defer(fn40)
	end))

	pcall(function()
		local GuardPresentationComponent = require(ReplicatedStorage.Shared.Modules.GuardAreas.GuardPresentationComponent)

		if type(GuardPresentationComponent) == "table" then
			genv.__SenaV4GuardPresentOrig = genv.__SenaV4GuardPresentOrig or {PlayWake = GuardPresentationComponent.PlayWake, PlayHit = GuardPresentationComponent.PlayHit, PlayAfterWake = GuardPresentationComponent.PlayAfterWake, ScheduleAfterWake = GuardPresentationComponent.ScheduleAfterWake}

			local function playWake()
			end

			GuardPresentationComponent.PlayWake = playWake

			GuardPresentationComponent.PlayHit = function()
				return 0
			end

			GuardPresentationComponent.PlayAfterWake = playWake
			GuardPresentationComponent.ScheduleAfterWake = playWake
		end
	end)

	genv.__SenaV4CosmeticSuppressCleanup = function()
		for i, v5 in ipairs(tbl7) do
			pcall(function()
				v5:Disconnect()
			end)
		end

		table.clear(tbl7)
		local senaV4GuardPresentOrig = genv.__SenaV4GuardPresentOrig

		if type(senaV4GuardPresentOrig) == "table" then
			pcall(function()
				local GuardPresentationComponent = require(ReplicatedStorage.Shared.Modules.GuardAreas.GuardPresentationComponent)

				for k, v5 in pairs(senaV4GuardPresentOrig) do
					GuardPresentationComponent[k] = v5
				end
			end)
		end
	end
end

do
	if type(genv.__SenaV4StealDeclutterCleanup) == "function" then
		pcall(genv.__SenaV4StealDeclutterCleanup)
	end

	local tbl7 = {{name = "ProximityPrompts", restore = true}, {name = "AreaGui", restore = false}}
	local flag2 = false
	local tbl8 = {}

	local function fn39(arg)
		return arg and (arg:IsA("ScreenGui") or arg:IsA("LayerCollector"))
	end

	local function fn40(arg)
		if not arg:IsA("LayerCollector") then
			return
		end

		pcall(function()
			arg.Enabled = false
		end)

		table.insert(tbl8, arg:GetPropertyChangedSignal("Enabled"):Connect(function()
			if flag2 and arg.Enabled then
				pcall(function()
					arg.Enabled = false
				end)
			end
		end))
	end

	local function fn41(arg)
		if not fn39(arg) then
			return
		end

		pcall(function()
			arg.Enabled = false
		end)

		table.insert(tbl8, arg:GetPropertyChangedSignal("Enabled"):Connect(function()
			if flag2 and arg.Enabled then
				pcall(function()
					arg.Enabled = false
				end)
			end
		end))

		for i, child in ipairs(arg:GetChildren()) do
			fn40(child)
		end

		table.insert(tbl8, arg.ChildAdded:Connect(function(child)
			if flag2 then
				fn40(child)
			end
		end))
	end

	local function fn42(arg)
		local playerGui = localPlayer:FindFirstChildOfClass("PlayerGui")
		if not playerGui then
			return
		end

		for i, v5 in ipairs(tbl7) do
			local v6 = playerGui:FindFirstChild(v5.name)

			if v6 then
				arg(v6, v5)
			end
		end
	end

	local function fn43()
		local playerGui = localPlayer:FindFirstChildOfClass("PlayerGui")
		if not playerGui then
			return
		end

		fn42(function(arg)
			fn41(arg)
		end)

		table.insert(tbl8, playerGui.ChildAdded:Connect(function(child)
			if not flag2 then
				return
			end

			for i, v5 in ipairs(tbl7) do
				if child.Name == v5.name then
					fn41(child)
					break
				end
			end
		end))
	end

	local function fn44()
		for i, v5 in ipairs(tbl8) do
			pcall(function()
				v5:Disconnect()
			end)
		end

		table.clear(tbl8)

		fn42(function(arg, arg2)
			pcall(function()
				arg.Enabled = arg2.restore
			end)

			if arg2.restore then
				for i, child in ipairs(arg:GetChildren()) do
					if child:IsA("LayerCollector") then
						pcall(function()
							child.Enabled = true
						end)
					end
				end
			end
		end)
	end

	genv.__SenaV4SetStealDeclutter = function(arg)
		local flag3 = arg == true
		if flag3 == flag2 then
			return
		end
		flag2 = flag3

		if flag3 then
			fn43()
		else
			fn44()
		end
	end

	genv.__SenaV4StealDeclutterCleanup = function()
		flag2 = false
		fn44()
	end
end

if type(genv.__SenaV4DecomBoostCleanup) == "function" then
	pcall(genv.__SenaV4DecomBoostCleanup)
end

local tbl7 = {}
local flag2 = false

genv.__SenaV4DecomBoostCleanup = function()
	for i, v5 in ipairs(tbl7) do
		pcall(function()
			v5:Disconnect()
		end)
	end

	table.clear(tbl7)
	flag2 = false
end

local function fn39()
	local clientRenderedAssets = workspace:FindFirstChild("ClientRenderedAssets")
	if not clientRenderedAssets then
		return
	end

	for i, child in ipairs(clientRenderedAssets:GetChildren()) do
		pcall(function()
			child.Parent = nil
		end)
	end
end

local function fn40(arg)
	return string.sub(arg.Name, 1, #tostring(localPlayer.UserId) + 1) == tostring(localPlayer.UserId) .. "_"
end

local function fn41()
	for i, child in ipairs(workspace:GetChildren()) do
		if child.Name == "PlacedEggRenders" then
			for i2, child2 in ipairs(child:GetChildren()) do
				pcall(function()
					if not child2:FindFirstChildOfClass("ProximityPrompt") and not fn40(child2) then
						child2.Parent = nil
					end
				end)
			end
		end
	end
end

local function fn42()
	for i, v5 in ipairs({"Transient", "__DEBRIS"}) do
		local v6 = workspace:FindFirstChild(v5)

		if v6 then
			for i2, child in ipairs(v6:GetChildren()) do
				if child.Name == "PlayerTrap" or child.Name:lower():find("trap") then
					pcall(function()
						child:Destroy()
					end)
				end
			end
		end
	end
end

local function fn43(arg)
	if arg:FindFirstAncestor("SenaVisualBack") then
		return true
	elseif arg:FindFirstAncestor("SenaVisualRemote") then
		return true
	end

	local tool = arg:FindFirstAncestorWhichIsA("Tool")
	return tool ~= nil and tool:GetAttribute("SenaVisual") ~= nil
end

local senaV4DecomBoostUndo = {effects = {}, parts = {}, decals = {}, snapshot = nil}
local tbl8 = {PlusOne = true, SpeedGainPopup = true, SellPayout = true, SyncedIncomeCash = true}
local tbl9 = {PlayerPlotSign = true, CanUpgrade = true, AlertGui = true, OfflineMoneyClaimBillboard = true}

local function fn44(descendant)
	pcall(function()
		if fn43(descendant) then
			return
		end

		if tbl8[descendant.Name] then
			descendant:Destroy()
			return
		end

		if descendant:IsA("BillboardGui") and tbl9[descendant.Name] then
			if descendant.Enabled then
				senaV4DecomBoostUndo.effects[descendant] = true
			end

			descendant.Enabled = false
			return
		end

		if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") or descendant:IsA("Beam") or descendant:IsA("Sparkles") or descendant:IsA("Fire") or descendant:IsA("Smoke") or descendant:IsA("PostEffect") then
			if descendant.Enabled then
				senaV4DecomBoostUndo.effects[descendant] = true
			end

			descendant.Enabled = false
		end
	end)
end

local function fn45()
	if flag2 then
		return
	end
	flag2 = true
	table.insert(tbl7, game.DescendantAdded:Connect(fn44))

	table.insert(tbl7, workspace.ChildAdded:Connect(function(child)
		if child.Name == "ClientRenderedAssets" then
			fn39()

			table.insert(tbl7, child.ChildAdded:Connect(function(child2)
				pcall(function()
					child2.Parent = nil
				end)
			end))
		elseif child.Name == "PlacedEggRenders" then
			fn41()

			table.insert(tbl7, child.ChildAdded:Connect(function(child2)
				pcall(function()
					if not child2:FindFirstChildOfClass("ProximityPrompt") and not fn40(child2) then
						child2.Parent = nil
					end
				end)
			end))
		elseif child.Name == "__DEBRIS" or child.Name == "Transient" then
			table.insert(tbl7, child.ChildAdded:Connect(function(child2)
				if child2.Name == "PlayerTrap" or child2.Name:lower():find("trap") then
					pcall(function()
						child2:Destroy()
					end)
				end
			end))
		end
	end))

	local clientRenderedAssets = workspace:FindFirstChild("ClientRenderedAssets")

	if clientRenderedAssets then
		table.insert(tbl7, clientRenderedAssets.ChildAdded:Connect(function(child)
			pcall(function()
				child.Parent = nil
			end)
		end))
	end

	for i, child in ipairs(workspace:GetChildren()) do
		if child.Name == "PlacedEggRenders" then
			table.insert(tbl7, child.ChildAdded:Connect(function(child2)
				pcall(function()
					if not child2:FindFirstChildOfClass("ProximityPrompt") and not fn40(child2) then
						child2.Parent = nil
					end
				end)
			end))
		end
	end
end

local flag3 = false

local function fn46()
	if flag3 then
		return
	end
	flag3 = true
	local Lighting = game:GetService("Lighting")

	if not senaV4DecomBoostUndo.snapshot then
		local tbl10 = {}

		pcall(function()
			tbl10.quality = settings().Rendering.QualityLevel
			tbl10.throttle = settings().Physics.PhysicsEnvironmentalThrottle
			tbl10.technology = Lighting.Technology
			tbl10.shadows = Lighting.GlobalShadows
			tbl10.fogEnd = Lighting.FogEnd
			tbl10.brightness = Lighting.Brightness
			tbl10.ambient = Lighting.Ambient
			tbl10.outdoorAmbient = Lighting.OutdoorAmbient
		end)

		local terrain = workspace:FindFirstChildOfClass("Terrain")

		if terrain then
			pcall(function()
				tbl10.terrain = {WaterWaveSize = terrain.WaterWaveSize, WaterWaveSpeed = terrain.WaterWaveSpeed, WaterReflectance = terrain.WaterReflectance, WaterTransparency = terrain.WaterTransparency, Decoration = terrain.Decoration}
			end)

			pcall(function()
				local clouds = terrain:FindFirstChildOfClass("Clouds")

				if clouds then
					tbl10.cloudsEnabled = clouds.Enabled
				end
			end)
		end

		pcall(function()
			local preferences = ReplicatedStorage.Shared:FindFirstChild("Preferences")

			if preferences then
				local module = require(preferences)
				tbl10.prefs = {HideOtherPets = module.IsOn("HideOtherPets"), DisableVideos = module.IsOn("DisableVideos")}
			end
		end)

		if tbl10.quality == Enum.QualityLevel.Level01 then
			tbl10.quality = Enum.QualityLevel.Automatic
		end

		senaV4DecomBoostUndo.snapshot = genv.__SenaV4DecomSnapshot or tbl10
		genv.__SenaV4DecomSnapshot = senaV4DecomBoostUndo.snapshot
	end

	pcall(function()
		settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
		settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.Always
		Lighting.Technology = Enum.Technology.Compatibility
		Lighting.GlobalShadows = false
		Lighting.FogEnd = 9000000000
		Lighting.Brightness = 2
		Lighting.Ambient = Color3.new(1, 1, 1)
		Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
	end)

	local tbl10 = {workspace, Lighting}
	local now = os.clock()

	for i, v5 in ipairs(tbl10) do
		for i2, descendant in ipairs(v5:GetDescendants()) do
			if fn43(descendant) then
				continue
			elseif descendant:IsA("BasePart") then
				pcall(function()
					if not senaV4DecomBoostUndo.parts[descendant] then
						senaV4DecomBoostUndo.parts[descendant] = {descendant.Material, descendant.CastShadow, descendant:IsA("MeshPart") and descendant.RenderFidelity or nil}
					end

					descendant.Material = Enum.Material.SmoothPlastic
					descendant.CastShadow = false

					if descendant:IsA("MeshPart") then
						descendant.RenderFidelity = Enum.RenderFidelity.Performance
					end
				end)
			elseif descendant:IsA("Decal") or descendant:IsA("Texture") then
				pcall(function()
					if descendant.Texture ~= "" and not senaV4DecomBoostUndo.decals[descendant] then
						senaV4DecomBoostUndo.decals[descendant] = descendant.Texture
					end

					descendant.Texture = ""
				end)
			else
				fn44(descendant)
			end

			if os.clock() - now > 0.004 then
				task.wait()
				now = os.clock()
			end
		end
	end

	local terrain = workspace:FindFirstChildOfClass("Terrain")

	if terrain then
		pcall(function()
			terrain.WaterWaveSize = 0
			terrain.WaterWaveSpeed = 0
			terrain.WaterReflectance = 0
			terrain.WaterTransparency = 1
			terrain.Decoration = false
			local clouds = terrain:FindFirstChildOfClass("Clouds")

			if clouds then
				clouds.Enabled = false
			end
		end)
	end

	pcall(function()
		local shared = ReplicatedStorage.Shared
		local preferences = shared:FindFirstChild("Preferences")

		if preferences then
			local module = require(preferences)
			module.Set("HideOtherPets", true)
			module.Set("DisableVideos", true)
		else
			local SettingsCmds = require(shared.SettingsCmds)
			SettingsCmds.Write("HideOtherPets", true)
			SettingsCmds.Write("DisableVideos", true)
		end
	end)

	fn39()
	fn41()
	fn42()
	fn45()
	flag3 = false
end

senaV4DecomBoostUndo.revert = function()
	for i, v5 in ipairs(tbl7) do
		pcall(function()
			v5:Disconnect()
		end)
	end

	table.clear(tbl7)
	flag2 = false
	local snapshot = senaV4DecomBoostUndo.snapshot
	local Lighting = game:GetService("Lighting")

	if snapshot then
		pcall(function()
			settings().Rendering.QualityLevel = snapshot.quality or Enum.QualityLevel.Automatic
		end)

		pcall(function()
			settings().Physics.PhysicsEnvironmentalThrottle = snapshot.throttle
		end)

		pcall(function()
			Lighting.Technology = snapshot.technology
			Lighting.GlobalShadows = snapshot.shadows
			Lighting.FogEnd = snapshot.fogEnd
			Lighting.Brightness = snapshot.brightness
			Lighting.Ambient = snapshot.ambient
			Lighting.OutdoorAmbient = snapshot.outdoorAmbient
		end)

		local terrain = workspace:FindFirstChildOfClass("Terrain")

		if terrain and snapshot.terrain then
			for k, v5 in pairs(snapshot.terrain) do
				pcall(function()
					terrain[k] = v5
				end)
			end

			if snapshot.cloudsEnabled ~= nil then
				pcall(function()
					local clouds = terrain:FindFirstChildOfClass("Clouds")

					if clouds then
						clouds.Enabled = snapshot.cloudsEnabled
					end
				end)
			end
		end

		if snapshot.prefs then
			pcall(function()
				local Preferences = require(ReplicatedStorage.Shared.Preferences)

				for k, pref in pairs(snapshot.prefs) do
					Preferences.Set(k, pref)
				end
			end)
		end
	end

	local n8 = 0

	for k, part in pairs(senaV4DecomBoostUndo.parts) do
		if k.Parent then
			pcall(function()
				k.Material = part[1]
				k.CastShadow = part[2]

				if part[3] ~= nil and k:IsA("MeshPart") then
					k.RenderFidelity = part[3]
				end
			end)
		end

		n8 += 1

		if n8 % 400 == 0 then
			task.wait()
		end
	end

	for k, decal in pairs(senaV4DecomBoostUndo.decals) do
		if k.Parent then
			pcall(function()
				k.Texture = decal
			end)
		end
	end

	for k in pairs(senaV4DecomBoostUndo.effects) do
		if k.Parent then
			pcall(function()
				k.Enabled = true
			end)
		end
	end

	senaV4DecomBoostUndo.parts = {}
	senaV4DecomBoostUndo.decals = {}
	senaV4DecomBoostUndo.effects = {}
	senaV4DecomBoostUndo.snapshot = nil
end

genv.__SenaV4DecomBoostUndo = senaV4DecomBoostUndo
local flag4 = false

local function fn47(arg)
	if arg then
		if not arg:IsA("Model") then
			return
		end
	else
		return
	end

	local match = arg.Name:match("^(%d+)_")
	local num = match and tonumber(match)

	if num then
		if num == localPlayer.UserId then
			return
		end
	else
		return
	end

	for i, descendant in ipairs(arg:GetDescendants()) do
		if descendant:IsA("BasePart") then
			descendant.Transparency = 1
			descendant.CanCollide = false
		elseif descendant:IsA("Decal") then
			descendant.Transparency = 1
		elseif descendant:IsA("Texture") then
			descendant.Transparency = 1
		elseif descendant:IsA("ParticleEmitter") then
			descendant.Enabled = false
		elseif descendant:IsA("Trail") then
			descendant.Enabled = false
		elseif descendant:IsA("Beam") then
			descendant.Enabled = false
		elseif descendant:IsA("BillboardGui") then
			descendant.Enabled = false
		elseif descendant:IsA("SurfaceGui") then
			descendant.Enabled = false
		end
	end
end

local function fn48()
	if senaV4Config._fpsEggsReady then
		return true
	end
	local flag5 = false

	local ok, result = pcall(function()
		local v5 = require(game:GetService("ReplicatedStorage").Shared.Eggs.PlacedEggRenderer).GetRenderFolder()
		if not v5 then
			return
		end

		for i, v6 in ipairs((v5:GetChildren())) do
			fn47(v6)
		end

		local function fn49(child)
			task.defer(fn47, child)
		end

		v5.ChildAdded:Connect(fn49)
		flag5 = true
	end)

	if not ok then
		warn("[FPSBoost] Gagal hide egg pemain lain:", result)
		return false
	end
	return flag5
end

local function fn49(arg)
	if not arg then
		return
	end

	pcall(function()
		arg.Parent = nil
	end)
end

local function fn50()
	if senaV4Config._fpsPetsReady then
		return true
	end
	local isOn

	local ok, result = pcall(function()
		local shared = game:GetService("ReplicatedStorage").Shared
		local preferences = shared:FindFirstChild("Preferences")

		if preferences then
			local module = require(preferences)
			module.Set("HideOtherPets", true)
			isOn = module.IsOn
		else
			local SettingsCmds = require(shared.SettingsCmds)
			SettingsCmds.Write("HideOtherPets", true)
			isOn = SettingsCmds.Allows
		end
	end)

	local flag5 = false

	if ok and isOn then
		local ok2, result2 = pcall(isOn, "HideOtherPets")
		flag5 = ok2 and result2 == true
	end

	if if ok then not flag5 else not ok then
		warn("[FPSBoost] Gagal set HideOtherPets bawaan game:", result or "setting belum aktif")
		return false
	end
	local flag6 = false

	result, ok = pcall(function()
		local clientRenderedAssets = workspace:FindFirstChild("ClientRenderedAssets") or workspace:WaitForChild("ClientRenderedAssets", 10)
		if not clientRenderedAssets then
			return
		end

		for i, v5 in ipairs((clientRenderedAssets:GetChildren())) do
			fn49(v5)
		end

		local function fn51(child)
			task.defer(fn49, child)
		end

		clientRenderedAssets.ChildAdded:Connect(fn51)
		flag6 = true
	end)

	if not result then
		warn("[FPSBoost] Gagal hide pet (manual):", ok)
		return false
	end
	return flag6
end

local function fn51()
	if type(genv.__SenaV4SetCapFps) == "function" then
		pcall(genv.__SenaV4SetCapFps, 1000)
	end

	pcall(function()
		settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
	end)

	pcall(function()
		UserSettings():GetService("UserGameSettings").SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
	end)

	pcall(function()
		local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
		local v5 = require
		local lightingsController = ReplicatedStorage2.Client.LightingsController

		local function fn52(arg)
			local v6 = table.clone(arg)
			v6.Bloom = nil
			v6.ColorCorrection = nil
			v6.SunRays = nil
			v6.DepthOfField = nil
			v6.Blur = nil
			v6.Clouds = nil
			v6.Atmosphere = nil
			v6.ShadowSoftness = 1
			return v6
		end

		v5(lightingsController):SetModifier("FPSBoost", fn52, 100, 0)
	end)

	pcall(function()
		local Lighting = game:GetService("Lighting")
		Lighting.GlobalShadows = false
		Lighting.Technology = Enum.Technology.Compatibility
		Lighting.FogEnd = 9000000000
		Lighting.Brightness = 2
	end)

	pcall(function()
		local terrain = workspace:FindFirstChildOfClass("Terrain")

		if terrain then
			terrain.WaterWaveSize = 0
			terrain.WaterWaveSpeed = 0
			terrain.WaterReflectance = 0
			terrain.WaterTransparency = 1
			terrain.Decoration = false
		end
	end)

	pcall(function()
		local debris = workspace:FindFirstChild("__DEBRIS")

		if debris then
			for i, child in ipairs(debris:GetChildren()) do
				if child.Name == "PlayerTrap" then
					pcall(function()
						child:Destroy()
					end)
				end
			end
		end
	end)
end

local color = Color3.fromRGB(120, 120, 120)

local function fn52(arg)
	if arg then
		if not arg:IsA("BasePart") then
			return
		end
	else
		return
	end

	arg.Material = Enum.Material.SmoothPlastic
	arg.Color = color
	arg.CastShadow = false
end

local function fn53(arg)
	if arg:IsA("ParticleEmitter") then
		arg.Enabled = false
		arg.Rate = 0

		pcall(function()
			arg:Clear()
		end)
	elseif arg:IsA("Trail") then
		arg.Enabled = false
	elseif arg:IsA("Beam") then
		arg.Enabled = false
	elseif arg:IsA("Smoke") then
		arg.Enabled = false
	elseif arg:IsA("Fire") then
		arg.Enabled = false
	elseif arg:IsA("Sparkles") then
		arg.Enabled = false
	elseif arg:IsA("PostEffect") then
		arg.Enabled = false
	elseif arg:IsA("Light") then
		arg.Enabled = false
	elseif arg:IsA("Highlight") then
		arg.Enabled = false
	elseif arg:IsA("Clouds") then
		arg.Enabled = false
	elseif arg:IsA("Atmosphere") then
		arg.Density = 0
		arg.Haze = 0
		arg.Glare = 0
	elseif arg:IsA("Explosion") then
		pcall(function()
			arg.Visible = false
		end)
	end
end

local function fn54()
	if senaV4Config._fpsWorldReady then
		return true
	end
	local flag5 = false
	local tbl10 = {}

	local ok, result = pcall(function()
		local function fn55(arg)
			if fn43(arg) then
				return
			end
			fn52(arg)
			fn53(arg)
		end

		local tbl11 = {workspace, game:GetService("Lighting")}

		for i, v5 in ipairs(tbl11) do
			table.insert(tbl10, v5.DescendantAdded:Connect(function(descendant)
				task.defer(fn55, descendant)
			end))
		end

		local tbl12 = {}

		for i, v5 in ipairs(tbl11) do
			for i2, child in ipairs(v5:GetChildren()) do
				table.insert(tbl12, child)
			end
		end

		tbl11 = 0

		while #tbl12 > 0 do
			local v5 = table.remove(tbl12)
			fn55(v5)

			for i, child in ipairs(v5:GetChildren()) do
				table.insert(tbl12, child)
			end

			tbl11 += 1

			if tbl11 >= 250 and #tbl12 > 0 then
				RunService.Heartbeat:Wait()
				tbl11 = 0
			end
		end

		flag5 = true
	end)

	if not ok then
		for i, v5 in ipairs(tbl10) do
			v5:Disconnect()
		end

		warn("[FPSBoost] Gagal flatten material workspace:", result)
		return false
	end

	return flag5
end

local function fn55()
	if senaV4Config._fpsAreasReady then
		return true
	end
	local n8 = fn()
	local areas = n8 and n8:FindFirstChild("Areas")
	local guardAreas = areas and areas:FindFirstChild("GuardAreas")
	local build = n8 and n8:FindFirstChild("Build")

	if guardAreas then
		if not build then
			return false
		end
	else
		return false
	end

	for i, child in ipairs(guardAreas:GetChildren()) do
		local requiredSpeedSign = child:FindFirstChild("RequiredSpeedSign")

		if requiredSpeedSign then
			pcall(function()
				requiredSpeedSign:Destroy()
			end)
		end
	end

	local mainMap = build:FindFirstChild("MainMap")
	local bases = mainMap and mainMap:FindFirstChild("Bases")

	local function fn56(arg)
		if bases and arg:IsDescendantOf(bases) then
			return arg.Size.Y <= 5 and not string.find(string.upper(arg.Name), "WALL", 1, true)
		end
		local parent = arg

		while parent and parent ~= build do
			local v5 = string.upper(parent.Name)
			if string.find(v5, "BOTTOM", 1, true) then
				return true
			end
			parent = parent.Parent
		end

		return false
	end

	local tbl10 = {"ENCHANTED", "FUSEBIOME", "WISP", "BUTTERFLY", "MARKERS", "PORTAL", "TRIGGER"}

	local function fn57(arg)
		if arg:FindFirstChildOfClass("TouchTransmitter") then
			return true
		elseif arg:FindFirstChildWhichIsA("ProximityPrompt", true) then
			return true
		end

		local parent = arg

		while parent and parent ~= build do
			local v5 = string.upper(parent.Name)

			for i, v6 in ipairs(tbl10) do
				if string.find(v5, v6, 1, true) then
					return true
				end
			end

			parent = parent.Parent
		end

		return false
	end

	local function fn58(arg)
		if not arg:IsA("BasePart") then
			return
		end

		if fn57(arg) then
			return
		end

		if fn56(arg) then
			fn52(arg)
		else
			pcall(function()
				arg:Destroy()
			end)
		end
	end

	local function fn59(descendant)
		task.defer(fn58, descendant)
	end

	local connection6 = build.DescendantAdded:Connect(fn59)
	areas = 0
	n8 = 0

	for i, descendant in ipairs(build:GetDescendants()) do
		local flag5 = descendant.Parent ~= nil
		fn58(descendant)
		areas = if flag5 then if descendant.Parent == nil then areas + 1 else areas else areas
		n8 += 1

		if n8 >= 250 then
			RunService.Heartbeat:Wait()
			n8 = 0
		end
	end

	senaV4Config._fpsAreaListener = connection6
	senaV4Config._fpsAreaDeleted = areas
	senaV4Config._fpsAreasReady = true
	return true
end

local function fn56()
	if senaV4Config._fpsPlotsReady then
		return true
	end
	local flag5 = false

	local ok, result = pcall(function()
		local PlotState2 = require(game:GetService("ReplicatedStorage").Client.PlotState)
		if PlotState2.GetMySlot() == nil then
			warn("[FPSBoost] Slot plot kita belum ke-resolve, skip delete plot dulu (biar aman).")
			return
		end

		local function fn57(arg)
			local v5 = PlotState2.GetMySlot()
			return v5 ~= nil and arg.Name == tostring(v5)
		end

		local plots = PlotState2.GetPlotsFolder() or workspace:WaitForChild("Plots", 10)
		if not plots then
			warn("[FPSBoost] workspace.Plots gak ketemu sama sekali.")
			return
		end
		local n8 = 0

		for i, v5 in ipairs((plots:GetChildren())) do
			n8 = if fn57(v5) then n8 else if pcall(function()
				v5:Destroy()
			end) then n8 + 1 else n8
		end

		local function fn58(child)
			task.defer(function()
				if child.Parent and not fn57(child) then
					pcall(function()
						child:Destroy()
					end)
				end
			end)
		end

		plots.ChildAdded:Connect(fn58)
		flag5 = true
	end)

	if not ok then
		warn("[FPSBoost] Gagal delete plot pemain lain:", result)
		return false
	end
	return flag5
end

local function fn57()
	if senaV4Config._fpsTreadmillsReady then
		return true
	end
	local flag5 = false

	local ok, result = pcall(function()
		local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
		local PlotState2 = require(ReplicatedStorage2.Client.PlotState)
		local v5
		local modules = ReplicatedStorage2.Client:FindFirstChild("Modules") or ReplicatedStorage2.Client:WaitForChild("Modules", 10)
		local runtimeInstanceRegistry, v6 = modules and (modules:FindFirstChild("RuntimeInstanceRegistry") or modules:WaitForChild("RuntimeInstanceRegistry", 10))

		if runtimeInstanceRegistry then
			ReplicatedStorage2, modules = pcall(require, runtimeInstanceRegistry)
			v6 = if ReplicatedStorage2 then modules else v5
		else
			v6 = v5
		end

		local clientTreadmillRenders = workspace:FindFirstChild("__ClientTreadmillRenders") or workspace:WaitForChild("__ClientTreadmillRenders", 10)
		if not clientTreadmillRenders then
			return
		end

		local function fn58()
			local v7 = PlotState2.GetMySlot()
			if v7 == nil then
				return nil
			end
			local v8 = clientTreadmillRenders:FindFirstChild("TreadmillRender_" .. tostring(v7))
			if v8 then
				return v8
			end
			local peek = v6 and (v6.Peek or v6.Get)
			if not peek then
				return nil
			end
			local ok, result = pcall(peek, "TreadmillPlotRender", tostring(v7))
			if ok then
				return result
			end
			return nil
		end

		local function fn59(arg)
			local result = fn58()
			if result and arg == result then
				return true
			end

			local ok, result2 = pcall(function()
				return arg:GetPivot().Position
			end)

			if not ok then
				return true
			end
			ok, result = pcall(PlotState2.IsWorldPositionWithinLocalPlotBounds, result2)
			return ok and result
		end

		ReplicatedStorage2 = 0

		for i, v7 in ipairs((clientTreadmillRenders:GetChildren())) do
			ReplicatedStorage2 = if v7:IsA("Model") then if fn59(v7) then ReplicatedStorage2 else if pcall(function()
				v7:Destroy()
			end) then ReplicatedStorage2 + 1 else ReplicatedStorage2 else ReplicatedStorage2
		end

		local function fn60(child)
			task.defer(function()
				if child.Parent and (child:IsA("Model") and not fn59(child)) then
					pcall(function()
						child:Destroy()
					end)
				end
			end)
		end

		clientTreadmillRenders.ChildAdded:Connect(fn60)
		flag5 = true
	end)

	if not ok then
		warn("[FPSBoost] Gagal delete treadmill pemain lain:", result)
		return false
	end
	return flag5
end

local function fn58()
	if flag4 then
		return
	elseif senaV4Config._fpsBoostApplying then
		return
	end

	senaV4Config._fpsBoostApplying = true

	local ok, result = pcall(function()
		fn51()
		senaV4Config._fpsPlotsReady = fn56() == true
		senaV4Config._fpsTreadmillsReady = fn57() == true
		senaV4Config._fpsAreasReady = fn55() == true
		senaV4Config._fpsWorldReady = fn54() == true
		senaV4Config._fpsPetsReady = fn50() == true
		senaV4Config._fpsEggsReady = fn48() == true
		flag4 = senaV4Config._fpsEggsReady and senaV4Config._fpsPetsReady and senaV4Config._fpsWorldReady and senaV4Config._fpsPlotsReady and senaV4Config._fpsTreadmillsReady and senaV4Config._fpsAreasReady
	end)

	senaV4Config._fpsBoostApplying = nil

	if not ok then
		warn("[FPSBoost] Gagal menerapkan FPS Boost:", result)
	end
end

local function fn59(arg, arg2, arg3)
	local flag5 = true

	local function fn60()
		local filterDescendantsInstances = {arg3}
		local raycastParams = RaycastParams.new()
		raycastParams.FilterType = Enum.RaycastFilterType.Exclude
		local n8 = arg

		for i = 1, 8, 1 do
			raycastParams.FilterDescendantsInstances = filterDescendantsInstances
			local n9 = arg2 - n8
			if n9.Magnitude < 1 then
				break
			end
			local hit = workspace:Raycast(n8, n9, raycastParams)
			if not hit then
				break
			end

			if hit.Instance.CanCollide then
				flag5 = false
				break
			end
			table.insert(filterDescendantsInstances, hit.Instance)
			n8 = hit.Position + n9.Unit * 0.1
		end
	end

	pcall(fn60)
	return flag5
end

local tbl10 = {}

local v5 = (function()
	local index = {}
	index.__index = index
	local tbl11 = {auto_place = true, auto_fuse = true, equip_best = true}
	local tbl12 = {auto_steal = 100, auto_hatch = 80, auto_place = 70, auto_fuse = 50, equip_best = 40, rewards = 20}

	local function fn60(arg)
		local tbl13 = {}

		for k, v5 in pairs(arg) do
			tbl13[k] = v5
		end

		return tbl13
	end

	index.new = function()
		local obj = setmetatable({}, index)
		obj.destroyed = false
		obj.active = nil
		obj.background = nil
		obj.reservations = {}
		obj.listeners = {}
		obj.backgroundListeners = {}
		obj.serial = 0
		return obj
	end

	index._snapshot = function(arg)
		local active = arg.active
		return {busy = active ~= nil, operation = active and active.owner or nil, priority = active and active.priority or 0, reservedCount = active and #active.uids or 0, reservations = fn60(arg.reservations)}
	end

	index._emit = function(arg)
		local v5 = arg:_snapshot()

		for k in pairs(arg.listeners) do
			local ok, result = pcall(k, v5)

			if not ok then
				warn("[StealAnEgg] Coordinator listener failed:", result)
			end
		end
	end

	index._emitBackground = function(arg)
		local background = arg.background
		local tbl13 = {busy = background ~= nil, operation = background and background.owner or nil}

		for k in pairs(arg.backgroundListeners) do
			local ok, result = pcall(k, tbl13)

			if not ok then
				warn("[StealAnEgg] Background coordinator listener failed:", result)
			end
		end
	end

	index.subscribe = function(arg, arg2)
		arg.listeners[arg2] = true
		pcall(arg2, arg:_snapshot())

		return function()
			arg.listeners[arg2] = nil
		end
	end

	index.subscribeBackground = function(arg, arg2)
		arg.backgroundListeners[arg2] = true
		local v5 = pcall
		local tbl13 = {busy = arg.background ~= nil}
		tbl13.operation = arg.background and arg.background.owner or nil
		v5(arg2, tbl13)

		return function()
			arg.backgroundListeners[arg2] = nil
		end
	end

	index.getSnapshot = function(arg)
		return arg:_snapshot()
	end

	index.isBackgroundBusy = function(arg)
		return arg.background ~= nil
	end

	index.isReserved = function(arg, arg2, arg3)
		local v5 = arg.reservations[arg2]
		return v5 ~= nil and v5 ~= arg3
	end

	index.tryAcquire = function(arg, arg2, arg3, arg4)
		if arg.destroyed then
			return nil, "Coordinator destroyed"
		end

		if type(arg2) ~= "string" then
			return nil, "Invalid operation owner"
		elseif arg2 == "" then
			return nil, "Invalid operation owner"
		end

		if arg.active then
			return nil, "Busy: " .. arg.active.owner
		end

		if arg.background and tbl11[arg2] then
			return nil, "Busy: background " .. arg.background.owner
		end
		local tbl13 = {}
		local tbl14 = {}

		for i, v5 in ipairs(type(arg3) == "table" and arg3 or {}) do
			if type(v5) == "string" and (v5 ~= "" and not tbl14[v5]) then
				if arg:isReserved(v5, arg2) then
					return nil, "UID reserved by " .. tostring(arg.reservations[v5])
				end
				tbl14[v5] = true
				table.insert(tbl13, v5)
			end
		end

		arg.serial = arg.serial + 1
		local active = {id = arg.serial, lane = "foreground", owner = arg2, priority = tonumber(arg4) or tbl12[arg2] or 0, uids = tbl13, released = false}
		arg.active = active

		for i, v5 in ipairs(tbl13) do
			arg.reservations[v5] = arg2
		end

		arg:_emit()
		return active
	end

	index.tryAcquireBackground = function(arg, arg2, arg3)
		if arg.destroyed then
			return nil, "Coordinator destroyed"
		end

		if type(arg2) ~= "string" then
			return nil, "Invalid operation owner"
		elseif arg2 == "" then
			return nil, "Invalid operation owner"
		end

		if arg.background then
			return nil, "Background busy: " .. arg.background.owner
		end

		if arg.active and tbl11[arg.active.owner] then
			return nil, "Foreground tool busy: " .. arg.active.owner
		end
		local tbl13 = {}
		local tbl14 = {}

		for i, v5 in ipairs(type(arg3) == "table" and arg3 or {}) do
			if type(v5) == "string" and (v5 ~= "" and not tbl14[v5]) then
				if arg:isReserved(v5, arg2) then
					return nil, "UID reserved by " .. tostring(arg.reservations[v5])
				end
				tbl14[v5] = true
				table.insert(tbl13, v5)
			end
		end

		arg.serial = arg.serial + 1
		local background = {id = arg.serial, lane = "background", owner = arg2, priority = 0, uids = tbl13, released = false}
		arg.background = background

		for i, v5 in ipairs(tbl13) do
			arg.reservations[v5] = arg2
		end

		arg:_emitBackground()
		return background
	end

	index.release = function(arg, arg2)
		if type(arg2) ~= "table" then
			return false
		elseif arg2.released then
			return false
		end

		arg2.released = true

		for i, v5 in ipairs(arg2.uids or {}) do
			if arg.reservations[v5] == arg2.owner then
				arg.reservations[v5] = nil
			end
		end

		local flag5 = arg.active == arg2

		if flag5 then
			arg.active = nil
		elseif arg.background == arg2 then
			arg.background = nil
			arg:_emitBackground()
		end

		if flag5 then
			arg:_emit()
		end

		return true
	end

	index.destroy = function(arg)
		if arg.destroyed then
			return
		end
		arg.destroyed = true

		if arg.active then
			arg:release(arg.active)
		end

		if arg.background then
			arg:release(arg.background)
		end

		table.clear(arg.reservations)
		table.clear(arg.listeners)
		table.clear(arg.backgroundListeners)
	end

	return index
end)()

local v6 = (function()
	local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
	local Areas = require(ReplicatedStorage2.Data.Areas)
	local Assets = require(ReplicatedStorage2.Data.Assets)
	local Guards = require(ReplicatedStorage2.Data.Guards)
	local Mutations = require(ReplicatedStorage2.Shared.Modules.Mutations)
	local tbl11 = {}
	local tbl12 = {Common = 1, Uncommon = 2, Rare = 3, Epic = 4, Legendary = 5, Mythic = 6, Cosmic = 7, Secret = 8, Eternal = 9, Divine = 10}

	tbl11.rarityRank = function(arg)
		return tbl12[arg] or 0
	end

	local function fn60(arg)
		local tbl13 = {}
		local tbl14 = {}

		for i, v6 in ipairs(arg) do
			if type(v6) == "string" and (v6 ~= "" and not tbl13[v6]) then
				tbl13[v6] = true
				table.insert(tbl14, v6)
			end
		end

		table.sort(tbl14)
		return tbl14
	end

	tbl11.getRarities = function()
		local tbl13 = {}

		for k in pairs(Assets.ByRarity) do
			table.insert(tbl13, k)
		end

		table.sort(tbl13, function(arg, arg2)
			local n8 = tbl12[arg] or 99
			local n9 = tbl12[arg2] or 99
			if n8 ~= n9 then
				return n8 < n9
			end
			return tostring(arg) < tostring(arg2)
		end)

		return tbl13
	end

	tbl11.getNames = function()
		local tbl13 = {}

		for k, v6 in pairs(Assets.Directory) do
			table.insert(tbl13, v6.DisplayName or v6._id)
		end

		return fn60(tbl13)
	end

	tbl11.getAreas = function()
		local tbl13 = {}

		for k, v6 in pairs(Areas.Directory) do
			if type(k) == "string" and (type(v6) == "table" and type(v6.DropTable) == "table") then
				table.insert(tbl13, k)
			end
		end

		table.sort(tbl13, function(arg, arg2)
			local v6 = Guards.Directory[arg]
			local v7 = Guards.Directory[arg2]
			local walkSpeed = v6 and v6.WalkSpeed or 1 / 0
			local walkSpeed2 = v7 and v7.WalkSpeed or 1 / 0
			if walkSpeed ~= walkSpeed2 then
				return walkSpeed < walkSpeed2
			end
			return arg < arg2
		end)

		return tbl13
	end

	tbl11.getMutations = function()
		local tbl13 = {}
		local v6 = Mutations.Ids()

		for k in pairs(type(v6) == "table" and v6 or {}) do
			if type(k) == "string" and k ~= Mutations.NO_MUTATION then
				local ok, result = pcall(Mutations.LabelOf, k)
				table.insert(tbl13, ok and type(result) == "string" and result ~= "" and result or k)
			end
		end

		return fn60(tbl13)
	end

	tbl11.resolveMutationId = function(arg)
		if type(arg) ~= "string" then
			return nil
		end

		if Mutations.IdSet[arg] then
			return arg
		end

		for k in pairs(Mutations.Ids()) do
			if k ~= Mutations.NO_MUTATION and Mutations.LabelOf(k) == arg then
				return k
			end
		end

		return nil
	end

	tbl11.resolve = function(arg)
		local v6 = arg and Assets.Directory[arg.AssetCategory]
		local rarity = v6 and v6.Rarity
		local displayName = rarity and (rarity.DisplayName or rarity._id) or "Unknown"
		return {name = v6 and (v6.DisplayName or v6._id) or arg and arg.AssetCategory or "Unknown", category = arg and arg.AssetCategory or "Unknown", rarity = displayName, rarityRank = tbl12[displayName] or 0, rarityColor = rarity and rarity.Color or nil, icon = v6 and type(v6.Icon) == "string" and v6.Icon or nil}
	end

	return tbl11
end)()

local function fn60(arg)
	if not arg then
		return nil
	end

	for i, descendant in ipairs(arg:GetDescendants()) do
		if descendant:IsA("ModuleScript") and (descendant.Name == "Limits" and (descendant.Parent and (descendant.Parent:FindFirstChild("Surface") and descendant.Parent:FindFirstChild("Runtime")))) then
			return descendant
		end
	end

	return nil
end

local v7 = fn60(localPlayer:FindFirstChildOfClass("PlayerScripts")) or fn60(game:GetService("StarterPlayer"):FindFirstChild("StarterPlayerScripts"))

local v8 = (function()
	local Players2 = game:GetService("Players")
	local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
	local RunService2 = game:GetService("RunService")
	local localPlayer2 = Players2.LocalPlayer
	local EggState2 = require(ReplicatedStorage2.Client.EggState)
	local Remotes = require(ReplicatedStorage2.Shared.Remotes)
	local eggWorld = Remotes.EggWorld
	local AreaEggs = require(ReplicatedStorage2.Shared.Types.AreaEggs)
	local AreaEggSlotIdentity = require(ReplicatedStorage2.Shared.Util.AreaEggSlotIdentity)
	local AreaEggResetWall3 = require(ReplicatedStorage2.Client.AreaEggResetWall)
	local SpeedPowerProjection = require(ReplicatedStorage2.Client.SpeedPowerProjection)
	local TreadmillUtil = require(ReplicatedStorage2.Shared.Util.TreadmillUtil)
	local EggRecords = require(ReplicatedStorage2.Shared.Util.EggRecords)
	local AssetEarnings = require(ReplicatedStorage2.Shared.Util.AssetEarnings)
	local Save = require(ReplicatedStorage2.Shared.Save)
	local PlotState2 = require(ReplicatedStorage2.Client.PlotState)
	local n8 = 10
	local n9 = 20
	local n10 = 100
	local n11 = 60
	local n12 = 0.05
	local n13 = 200
	local n14 = 1000
	local n15 = 600
	local speed = 3000

	local function fn61()
		return genv.__SenaV4AdminBoost == true and speed or n14
	end

	local str3 = "__SenaV4StealAnEggMovementSpoof"
	local n16 = 436
	local str4 = "__SenaV4StealAnEggIntegritySpoof"
	local tbl11 = {Divine = true, Eternal = true}
	local str5 = "ClientCharacter: GetDebugSnapshot"
	local tbl12 = {"LastObservedSample", "LastSample", "LastGoodSample", "LastGameplayTrustedSample", "LastValidatedSample", "LastValidatedGroundedSample", "LastConfirmedGroundSample", "CandidateGroundedSample"}
	local n17 = 0.15
	local n18 = 8
	local n19 = 1
	local name2 = "__SenaV4HoverPad"
	local str6 = "SenaV4RuntimeOwner"
	local vector2 = Vector3.new(542.93, 71.5, -405.58)
	local n20 = 612
	local tbl13 = {-364.3, -367.21, -371.12, -375.65}
	CFrame.new(599.8, 113.5, -325)
	Vector3.new(599.8, 70, -325)
	local n21 = 3
	local n22 = 0.85
	local n23 = 2
	local n24 = 3000
	local cframe = CFrame.new(554.071, 70.276, -395.573, 0, 0, 1, 0, 1, 0, -1, 0, 0)
	local n25 = 14
	local n26 = 0.7
	local n27 = 3
	local n28 = 6
	local n29 = 0.45
	local n30 = 30
	local n31 = 18
	local n32 = 0.35
	local n33 = 2
	local n34 = 0.1
	local name3 = "__SenaV4TreadmillDecoy"
	local tbl14 = {Script = true, LocalScript = true, BillboardGui = true, Sound = true}
	local n35 = 0.25
	local n36 = 5
	local n37 = 2
	local n38 = 45
	local n39 = 10
	local n40 = 0.03
	local n41 = 0.65
	local n42 = 0.35
	local n43 = 0.08
	local n44 = 1.35
	local n45 = 0.15
	local n46 = 24
	local n47 = 2
	local n48 = 0.5
	local n49 = 0.45
	local n50 = 0.4
	local str7 = "PlayerTrap"
	local str8 = "Trap"
	local index = {}
	index.__index = index
	local Stats = game:GetService("Stats")

	local function fn62(arg, firstAreaSlotKey)
		local humanoidRootPart = localPlayer2.Character and localPlayer2.Character:FindFirstChild("HumanoidRootPart")

		if humanoidRootPart then
			pcall(function()
				humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
				humanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
			end)
		end

		local n51 = 0

		pcall(function()
			n51 = Stats.Network.ServerStats.Ping:GetValue()
		end)

		task.wait(math.max(0.3, n51 * 2.5 / 1000))
		local tbl15 = {Uid = arg}

		if firstAreaSlotKey ~= nil then
			tbl15.FirstAreaSlotKey = firstAreaSlotKey
		end

		firstAreaSlotKey, arg = eggWorld.AskFieldEggCarry:InvokeServer(tbl15)
		return firstAreaSlotKey == true, typeof(arg) == "string" and arg or nil
	end

	local function fn63(arg, arg2, arg3)
		local connection6 = arg:Connect(arg2)
		table.insert(arg3, connection6)
		return connection6
	end

	local function fn64(arg)
		for i, v8 in ipairs(arg) do
			pcall(v8.Disconnect, v8)
		end

		table.clear(arg)
	end

	local function fn65(arg, arg2)
		for i, v8 in ipairs(arg or {}) do
			if v8 == arg2 then
				return true
			end
		end

		return false
	end

	local fn66

	local function fn67(arg)
		local humanoidRootPart = arg and arg:FindFirstChild("HumanoidRootPart")

		if humanoidRootPart then
			humanoidRootPart:SetAttribute("KillPartIgnore", true)
		end
	end

	local function fn68(arg)
		if arg._healthPinner then
			pcall(arg._healthPinner.Disconnect, arg._healthPinner)
			arg._healthPinner = nil
		end

		if arg._healthChangedConnection then
			pcall(arg._healthChangedConnection.Disconnect, arg._healthChangedConnection)
			arg._healthChangedConnection = nil
		end
	end

	local function fn69(arg, arg2)
		fn68(arg)
		local humanoid = arg2 and arg2:FindFirstChildOfClass("Humanoid")
		local humanoidRootPart = arg2 and arg2:FindFirstChild("HumanoidRootPart")
		if not humanoid then
			return false
		end
		local health = math.max(humanoid.MaxHealth, 100)
		local flag5 = false
		local n51 = 0

		local function fn70()
			if flag5 then
				return
			elseif arg.destroyed then
				return
			elseif localPlayer2.Character ~= arg2 then
				return
			elseif not humanoid.Parent then
				return
			end

			local now = os.clock()
			if now - n51 < 0.1 and (humanoid.Health > 0 and humanoid:GetState() ~= Enum.HumanoidStateType.Dead) then
				return
			end
			n51, flag5 = now, true

			pcall(function()
				humanoid.BreakJointsOnDeath = false
				humanoid.RequiresNeck = false
				humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
				humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
				humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)

				if humanoid.Health <= 0 then
					humanoid.Health = health
				end

				if humanoid:GetState() == Enum.HumanoidStateType.Dead then
					humanoid:ChangeState(Enum.HumanoidStateType.Running)
				end

				if humanoidRootPart and (humanoidRootPart.Parent == arg2 and humanoidRootPart.Anchored) then
					humanoidRootPart.Anchored = false
				end
			end)

			flag5 = false
		end

		fn70()

		arg._healthChangedConnection = humanoid.HealthChanged:Connect(function(health2)
			if health2 <= 0 then
				fn70()
			elseif health2 < health then
				fn70()
			end
		end)

		arg._healthPinner = RunService2.Heartbeat:Connect(fn70)
		return true
	end

	local function fn70(arg)
		local humanoid = arg and arg:FindFirstChildOfClass("Humanoid")
		if not humanoid then
			return
		end

		pcall(function()
			if humanoid.Health <= 0 then
				humanoid.Health = math.max(humanoid.MaxHealth, 1)
			end

			humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
			humanoid.BreakJointsOnDeath = true
			humanoid.RequiresNeck = true
		end)
	end

	local function fn71()
		return getgenv and getgenv() or _G
	end

	local function fn72()
		if type(getconnections) ~= "function" then
			return false
		elseif type(debug) ~= "table" then
			return false
		elseif type(debug.info) ~= "function" then
			return false
		elseif type(debug.getupvalue) ~= "function" then
			return false
		end

		local ok, result = pcall(getconnections, localPlayer2.Idled)

		if ok then
			if type(result) ~= "table" then
				return false
			end
		else
			return false
		end

		local str9 = ".PlayerScripts.Game.AntiAFK"

		for i, v8 in ipairs(result) do
			local function_ = v8.Function

			if type(function_) == "function" and type(v8.Disable) == "function" then
				local ok2, result2 = pcall(debug.info, function_, "s")
				local ok3, result3 = pcall(debug.getupvalue, function_, 1)
				if ok2 and (type(result2) == "string" and (result2:sub(-27) == str9 and (ok3 and type(result3) == "number"))) then
					return (pcall(v8.Disable, v8))
				end
			end
		end

		return false
	end

	local function fn73()
		local v8 = fn71()
		local tbl15 = v8[str3]

		if type(tbl15) ~= "table" or tbl15.Version ~= n16 then
			if type(tbl15) == "table" then
				tbl15.Enabled = false
			end

			tbl15 = {Version = n16, Installed = false, Enabled = false, Mode = "StateBaseline", Humanoid = nil, RootPart = nil, WalkSpeed = n15}
			v8[str3] = tbl15
		end

		return tbl15
	end

	local function fn74(arg, arg2)
		local v8 = fn73()
		if not v8 then
			return false
		end
		local humanoid = arg and arg:FindFirstChildOfClass("Humanoid")
		local humanoidRootPart = arg and arg:FindFirstChild("HumanoidRootPart")
		v8.Humanoid = humanoid
		v8.RootPart = humanoidRootPart
		v8.WalkSpeed = math.clamp(tonumber(arg2) or n15, n13, n14 * n44)
		v8.Enabled = false
		return humanoid ~= nil and humanoidRootPart ~= nil
	end

	local function fn75()
		local v8 = fn71()[str3]

		if type(v8) == "table" then
			v8.Enabled = false
			v8.Humanoid = nil
			v8.RootPart = nil
		end
	end

	local function fn76(arg, arg2, arg3)
		local v8

		if type(getcallbackvalue) == "function" and type(debug) == "table" and type(debug.getupvalue) == "function" then
			local signal2 = ReplicatedStorage2:FindFirstChild("Packages") and ReplicatedStorage2.Packages:FindFirstChild("Signal")

			if signal2 then
				local ok, result = pcall(require, signal2)

				if ok and type(result) == "table" and type(result.Invoked) == "function" then
					local ok2, result2 = pcall(result.Invoked, str5)

					if ok2 and result2 then
						local ok3, result3 = pcall(getcallbackvalue, result2, "OnInvoke")

						if ok3 and type(result3) == "function" then
							local ok4, result4 = pcall(debug.getinfo, result3)

							if ok4 then
								local function fn77(arg4, arg5, arg6)
									if v8 then
										return
									elseif type(arg4) ~= "table" then
										return
									elseif arg5 > 3 then
										return
									elseif arg6[arg4] then
										return
									end

									arg6[arg4] = true
									if rawget(arg4, "Player") == arg and (rawget(arg4, "Character") == arg.Character and (rawget(arg4, "Humanoid") == arg2 and (rawget(arg4, "RootPart") == arg3 and (type(rawget(arg4, "SampleHistory")) == "table" and type(rawget(arg4, "Evidence")) == "table")))) then
										v8 = arg4
										return
									end
									local n51 = 0

									for k, v9 in pairs(arg4) do
										n51 += 1
										if n51 > 128 then
											break
										end

										if type(v9) == "table" then
											fn77(v9, arg5 + 1, arg6)
										end
									end
								end

								for i = 1, result4.nups or 0, 1 do
									local ok5, result5 = pcall(debug.getupvalue, result3, i)

									if ok5 and type(result5) == "table" then
										fn77(result5, 0, {})
										if v8 then
											break
										end
									end
								end
							end
						end
					end
				end
			end
		end

		if not v8 and type(getgc) == "function" then
			local ok, result = pcall(getgc, true)

			if ok and type(result) == "table" then
				for i, v9 in ipairs(result) do
					if type(v9) == "table" and rawget(v9, "Player") == arg and rawget(v9, "Character") == arg.Character and rawget(v9, "Humanoid") == arg2 and rawget(v9, "RootPart") == arg3 and type(rawget(v9, "SampleHistory")) == "table" and type(rawget(v9, "Evidence")) == "table" then
						v8 = v9
						break
					end
				end
			end
		end

		return v8
	end

	local tbl15 = {busy = false, nextAt = 0, misses = 0, found = nil}

	local function fn77(arg, arg2, arg3)
		local found = tbl15.found
		if type(found) == "table" and (rawget(found, "Player") == arg and (rawget(found, "Character") == arg.Character and (rawget(found, "Humanoid") == arg2 and rawget(found, "RootPart") == arg3))) then
			return found
		end

		if tbl15.busy then
			return nil
		elseif os.clock() < tbl15.nextAt then
			return nil
		end

		tbl15.busy = true

		task.spawn(function()
			task.wait()
			local ok, result = pcall(fn76, arg, arg2, arg3)
			local v8 = ok and result or nil
			tbl15.found = v8
			tbl15.misses = v8 and 0 or tbl15.misses + 1
			tbl15.nextAt = os.clock() + (v8 and 0.2 or (tbl15.misses >= 5 and 10 or 1))
			tbl15.busy = false
		end)

		return nil
	end

	local function fn78(arg, arg2, arg3)
		if type(arg) ~= "table" then
			return false
		end
		local value = rawget(arg, "RootPart")
		local cFrame = value and value.Parent and value.CFrame or nil
		local position = cFrame and cFrame.Position or nil
		local vector3 = typeof(arg3) == "Vector3" and arg3 or Vector3.new(0, 0, 0)

		local function fn79(arg4)
			if type(arg4) == "table" then
				rawset(arg4, "WalkSpeed", arg2)

				if cFrame then
					rawset(arg4, "CFrame", cFrame)
					rawset(arg4, "Position", position)
					rawset(arg4, "LinearVelocity", vector3)
					rawset(arg4, "AngularVelocity", (Vector3.new(0, 0, 0)))
				end
			end
		end

		for i, v8 in ipairs(tbl12) do
			fn79(rawget(arg, v8))
		end

		for k, v8 in pairs(rawget(arg, "SampleHistory") or {}) do
			fn79(v8)
		end

		for k, v8 in pairs(rawget(arg, "SafeGroundCheckpoints") or {}) do
			fn79(v8)
		end

		local value2 = rawget(arg, "Evidence")

		if type(value2) == "table" then
			value2.Speed = 0
			value2.Teleport = 0
			value2.Flight = 0
		end

		local value3 = rawget(arg, "ImpulseContext")

		if type(value3) == "table" then
			local maxHorizontalSpeed = math.max(tonumber(value3.MaxHorizontalSpeed) or 0, arg2)
			local n51 = math.max((tonumber(value3.ExpiresAt) or 0) - (tonumber(value3.StartedAt) or 0), n45)
			value3.MaxHorizontalSpeed = maxHorizontalSpeed

			if position then
				value3.OriginPosition = position
			end

			value3.MaxHorizontalDistance = math.max(tonumber(value3.MaxHorizontalDistance) or 0, maxHorizontalSpeed * n51 + n46 * 2)
			fn79(value3.PreMovementSafeSample)
		end

		if rawget(arg, "CorrectionContext") == nil then
			rawset(arg, "FirstSuspiciousAt", nil)

			if rawget(arg, "ThreatLevel") == "Observing" then
				rawset(arg, "ThreatLevel", "Trusted")
			end
		end

		return true
	end

	local function fn79()
		local v8 = fn71()
		local tbl16 = v8[str4]

		if type(tbl16) ~= "table" then
			tbl16 = {}
			v8[str4] = tbl16
		end

		return tbl16
	end

	local function fn80(arg, arg2, arg3)
		return type(arg) == "table" and rawget(arg, "Player") == localPlayer2 and rawget(arg, "Character") == localPlayer2.Character and rawget(arg, "Humanoid") == arg2 and rawget(arg, "RootPart") == arg3
	end

	local function fn81(arg, arg2, arg3)
		return fn80(arg, arg2, arg3)
	end

	local function fn82(humanoid, rootPart, arg)
		local v8 = fn79()
		local state = v8.State

		if fn80(state, humanoid, rootPart) then
		else
			local now = os.clock()
			if now < (v8.NextSearchAt or 0) then
				return false
			end
			v8.NextSearchAt = now + 0.2
			state = fn77(localPlayer2, humanoid, rootPart)
		end

		if not state then
			return false
		end

		if not fn81(state, humanoid, rootPart) then
			v8.Enabled = false
			v8.Humanoid = humanoid
			v8.RootPart = rootPart
			v8.State = state
			return false
		end

		v8.NextSearchAt = 0
		v8.Enabled = true
		v8.Humanoid = humanoid
		v8.RootPart = rootPart
		v8.State = state
		v8.WalkSpeed = math.clamp(arg * n44, n13, n14 * n44)
		v8.TravelVelocity = Vector3.new(0, 0, 0)
		fn78(state, v8.WalkSpeed, v8.TravelVelocity)
		return true
	end

	local function fn83(arg, arg2, arg3, travelVelocity)
		local v8 = fn71()[str4]

		if type(v8) ~= "table" then
			return false
		elseif v8.Enabled then
			if v8.Humanoid ~= arg then
				return false
			elseif v8.RootPart ~= arg2 then
				return false
			elseif not fn81(v8.State, arg, arg2) then
				return false
			end
		else
			return false
		end

		v8.WalkSpeed = math.clamp(arg3 * n44, n13, n14 * n44)

		if typeof(travelVelocity) == "Vector3" then
			v8.TravelVelocity = travelVelocity
		elseif typeof(v8.TravelVelocity) ~= "Vector3" then
			v8.TravelVelocity = Vector3.new(0, 0, 0)
		end

		return fn78(v8.State, v8.WalkSpeed, v8.TravelVelocity)
	end

	local function fn84(arg)
		local v8 = fn71()[str4]
		if type(v8) ~= "table" then
			return
		end

		if arg == nil or v8.Humanoid == arg then
			v8.Enabled = false
			v8.Humanoid = nil
			v8.RootPart = nil
			v8.State = nil
			v8.TravelVelocity = nil
			v8.NextSearchAt = 0
		end
	end

	local function fn85(arg, arg2)
		if #arg2 == 0 then
			return true
		end

		for i, v8 in ipairs(arg.Mutations or {}) do
			if fn65(arg2, v8) then
				return true
			end
		end

		return arg.BaseMutation ~= nil and fn65(arg2, arg.BaseMutation)
	end

	local function fn86()
		local v8 = TreadmillUtil.SpeedPowerToWalkSpeed(SpeedPowerProjection.ReadProjected())
		local character = localPlayer2.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		local walkSpeed = humanoid and humanoid.WalkSpeed or v8
		return math.clamp(math.min(v8, walkSpeed), n13, n14)
	end

	index.new = function(catalog, limitsModule, coordinator)
		local obj = setmetatable({}, index)
		obj.catalog = catalog
		obj.limitsModule = limitsModule
		obj.coordinator = coordinator
		obj.operationToken = nil
		obj.connections = {}
		obj.listeners = {}
		obj.records = {}
		obj.enabled = false
		obj.userStealEnabled = false
		obj.skippedEggs = {}
		obj.riftWants = {}
		obj.riftOnly = false
		obj.indexObjectiveEnabled = false
		obj.wispObjective = nil
		obj.manualObjectiveEnabled = false
		obj.manualQueue = {}
		obj.manualOrder = {}
		obj.indexCache = {at = 0, set = {}}
		obj.running = false
		obj.safeStarting = false
		obj.movementRetryPending = false
		obj.destroyed = false
		obj.resetBlocked = AreaEggResetWall3.IsSealed()
		obj.gateOpenAt = obj.resetBlocked and 1 / 0 or os.clock()
		obj.activeTween = nil
		obj.activeTarget = nil
		obj.claimPresentationNode = nil
		obj.claimPresentationOriginal = nil
		obj.claimPresentationSuppression = nil
		obj.carry = {active = false, uid = nil, generation = 0}
		obj.carryWorker = nil
		obj.tweenRecoveryUid = nil
		obj.planGeneration = 0
		obj.treadmillDecoy = nil
		obj.treadmillDecoyCamera = nil
		obj.treadmillDecoyCameraConnection = nil
		obj.treadmillDecoyCharacterConnection = nil
		obj.treadmillPopupConnection = nil
		obj.treadmillDecoyRealTransparency = nil
		obj.hoverPadOwnerId = string.format("%s:%0.6f", tostring(obj), os.clock())
		obj.instantPhase = nil
		obj.primerUid = nil
		obj.primerUids = {}
		obj.targetUid = nil
		obj.hitTimer = nil
		obj.guardHitBoostInstalled = false
		obj.stats = {status = obj.resetBlocked and "Reset wall closed" or "Ready", available = 0, matching = 0, lastTarget = "None", lastResult = "Idle"}
		obj.config = {stealMode = "Instant", flyAerial = false, flyZigzag = false, speed = n15, antiTrap = true, heaviestFirst = false, highestValueFirst = false, minWeightKg = 0, espEnabled = false, espRarity = true, espName = true, espKg = true, espMutation = true, espValue = true, espPlaced = false, espIcon = true, espMinRank = 0, espMinValue = 0, minValuePerSec = 0, rarityEnabled = false, rarities = {}, nameEnabled = false, names = {}, areaEnabled = false, areas = {}, mutationEnabled = false, mutations = {}}
		obj.gameAntiAfkDisabled = fn72()

		if localPlayer2.Character then
			fn67(localPlayer2.Character)
			local humanoid = localPlayer2.Character:FindFirstChildOfClass("Humanoid")

			if humanoid then
				pcall(function()
					humanoid.BreakJointsOnDeath = false
					humanoid.RequiresNeck = false
					humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
					humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
					humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
				end)
			end

			fn69(obj, localPlayer2.Character)
		end

		catalog, limitsModule = pcall(function()
			return require(ReplicatedStorage2.Shared.Util.EggRecords)
		end)

		obj.weightUtil = catalog and type(limitsModule.WeightKgForScale) == "function" and limitsModule or nil

		local function fn87(arg)
			if not arg then
				return
			end

			fn63(arg.DescendantAdded, function(arg2)
				if obj.config.antiTrap then
					obj:_purgeTrap(arg2)
				end
			end, obj.connections)
		end

		fn87(workspace:FindFirstChild("Transient"))
		fn87(workspace:FindFirstChild("__DEBRIS"))

		if obj.config.antiTrap then
			obj:_purgeTraps()
		end

		fn63(workspace.ChildAdded, function(arg)
			if arg.Name == "Transient" or arg.Name == "__DEBRIS" then
				fn87(arg)

				if obj.config.antiTrap then
					obj:_purgeTraps()
				end
			end
		end, obj.connections)

		obj:_replaceSnapshot(EggState2.ReadFieldEggs())

		fn63(EggState2.FieldRefreshed, function(arg)
			obj:_replaceSnapshot(arg)
		end, obj.connections)

		fn63(EggState2.FieldShifted, function(arg)
			obj.records[arg.Uid] = arg
			obj:_refreshCounts()

			if obj.enabled and not obj.destroyed and not obj.running and not obj.carry.active and (arg.State == AreaEggs.States.Slot or arg.State == AreaEggs.States.Dropped) and not obj._shiftWakePending then
				obj._shiftWakePending = true

				task.delay(0.25, function()
					obj._shiftWakePending = nil

					if not obj.destroyed and (obj.enabled and not obj.running) then
						obj:_schedule()
					end
				end)
			end
		end, obj.connections)

		fn63(EggState2.FieldGone, function(arg)
			obj.records[arg] = nil

			if obj.activeTarget and obj.activeTarget.Uid == arg then
				if obj.carry.active and obj.carry.uid == arg then
					obj:_refreshCounts()
					return
				end
				obj.carryAttemptToken = nil
				obj:_clearArrivalHold(arg)

				if obj.activeTween and obj.activeTween.Cancel then
					pcall(obj.activeTween.Cancel, obj.activeTween)
				end

				local activeTarget = obj.activeTarget

				task.delay(n41, function()
					if obj.destroyed then
						return
					elseif not obj.enabled then
						return
					end

					if obj.carry.active and obj.carry.uid == arg then
						return
					end

					if obj.activeTarget == activeTarget and activeTarget.Uid == arg then
						obj:_finish("Target removed \226\128\148 continuing")
					end
				end)
			end

			obj:_refreshCounts()
		end, obj.connections)

		fn63(EggState2.ResetCountdown, function()
			obj:_closeGate("Egg reset countdown")
		end, obj.connections)

		fn63(EggState2.ResetFade, function()
			obj:_closeGate("Egg reset teleport")
		end, obj.connections)

		fn63(AreaEggResetWall3.Changed, function(arg)
			if arg then
				obj:_closeGate("Reset wall closed")
			else
				obj.resetBlocked = false
				obj.gateOpenAt = os.clock()
				obj.safeStarting = false
				obj.running = false
				obj:_setStatus(obj.enabled and "Searching" or "Ready")
				obj:_schedule()
			end
		end, obj.connections)

		fn63(localPlayer2.CharacterRemoving, function()
			obj._recalling = nil
			obj:_cleanupInstantSteal()
			obj:_hideTreadmillDecoy()
			obj._forestDropInProgress = nil
			obj._instantReturnToken = nil
			obj.carry.generation += 1
			obj:_invalidateCarryWorker()
			obj.carry.active = false
			obj.carry.uid = nil
			obj.safeStarting = false
			obj.planGeneration = obj.planGeneration + 1
			obj:_cancelTween("Character resetting")
			obj:_stopMovementProtection()
		end, obj.connections)

		fn63(RunService2.Heartbeat, function()
			if obj.destroyed then
				return
			end
			local character = localPlayer2.Character
			local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
			if not humanoidRootPart then
				return
			end
			local assemblyLinearVelocity = humanoidRootPart.AssemblyLinearVelocity
			local humanoid = character:FindFirstChildOfClass("Humanoid")
			local walkSpeed = humanoid and humanoid.WalkSpeed or 0
			local vector3 = Vector3.new(assemblyLinearVelocity.X, 0, assemblyLinearVelocity.Z)

			if vector3.Magnitude > math.max(400, walkSpeed * 1.5) or math.abs(assemblyLinearVelocity.Y) > 400 then
				local n51 = math.max(100, walkSpeed)
				local v8 = if vector3.Magnitude > n51 then vector3.Unit * n51 else vector3
				humanoidRootPart.AssemblyLinearVelocity = Vector3.new(v8.X, math.clamp(assemblyLinearVelocity.Y, -100, 100), v8.Z)
			end
		end, obj.connections)

		fn63(localPlayer2.CharacterAdded, function(arg)
			obj:_hideTreadmillDecoy()
			fn67(arg)
			local humanoid = arg:FindFirstChildOfClass("Humanoid")

			if humanoid then
				pcall(function()
					humanoid.BreakJointsOnDeath = false
					humanoid.RequiresNeck = false
					humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
					humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
					humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
				end)
			end

			fn69(obj, arg)

			task.delay(0.25, function()
				if not obj.destroyed and obj.enabled then
					obj:_startMovementProtection()
				end
			end)

			task.delay(1, function()
				if not obj.destroyed and (obj.enabled and obj:_wallOpen()) then
					obj:_schedule()
				end
			end)
		end, obj.connections)

		obj:_installClaimPresentationFilter()

		fn63(EggState2.CarryChanged, function(arg)
			if arg.IsCarrying then
				if obj.running and (obj.activeTarget and arg.Uid == obj.activeTarget.Uid) then
					if obj.carry.active and obj.carry.uid == arg.Uid then
						return
					end

					if obj.instantPhase == "priming" and arg.Uid == obj.primerUid then
						obj.carry.active = true
						obj.carry.uid = arg.Uid
						obj:_clearArrivalHold(arg.Uid)
						obj:_enterBaitWait()
						return
					end

					obj.carry.generation += 1
					obj:_invalidateCarryWorker()
					obj:_clearArrivalHold(arg.Uid)
					obj.claimPresentationSuppression = {assetCategory = obj.activeTarget.AssetCategory, expiresAt = os.clock() + 8}
					obj.carry.active = true
					obj.carry.uid = arg.Uid
					obj.carryStartTime = os.clock()
					obj.carryStartPos = obj.activeTarget and obj.activeTarget.BottomCFrame and obj.activeTarget.BottomCFrame.Position or localPlayer2.Character and localPlayer2.Character:FindFirstChild("HumanoidRootPart") and localPlayer2.Character.HumanoidRootPart.Position

					if obj.tweenRecoveryUid == arg.Uid then
						obj.tweenRecoveryUid = nil
					end

					if obj.carryTimeouts then
						obj.carryTimeouts[arg.Uid] = nil
					end

					obj.stats.lastResult = "Carry confirmed"
					obj:_notify()
					obj.carryAttemptToken = nil

					if obj.activeTween and obj.activeTween.Cancel then
						pcall(obj.activeTween.Cancel, obj.activeTween)
					end

					task.defer(function()
						if not obj.destroyed and (obj.enabled and (obj.carry.uid == arg.Uid and obj:_hasConfirmedCarry(arg.Uid))) then
							if genv.__SenaV4GodMode then
								genv.__SenaV4GodMode:stopDefend()
							end

							obj:_returnToSafe()
						end
					end)
				end

				return
			end

			if obj.carry.uid ~= nil and (arg.Uid ~= nil and arg.Uid ~= obj.carry.uid) then
				return
			end
			local uid = arg.Uid or obj.carry.uid or obj.activeTarget and obj.activeTarget.Uid
			local active = obj.carry.active
			obj.carry.generation += 1
			local generation = obj.carry.generation
			obj:_invalidateCarryWorker()

			if obj.activeTween and obj.activeTween.Cancel then
				pcall(obj.activeTween.Cancel, obj.activeTween)
			end

			obj.carry.active = false
			obj.carry.uid = nil

			if genv.__SenaV4GodMode then
				genv.__SenaV4GodMode:startDefend(uid)
			end

			if obj._captureHoldUid ~= nil and uid == obj._captureHoldUid then
				return
			elseif obj._adminBusyUid ~= nil then
				if uid == obj._adminBusyUid then
					return
				end
			end

			if obj.instantPhase == "priming" then
				if arg.Uid == obj.primerUid then
					obj:_startPrimerTargetHunt()
					return
				elseif uid == obj.primerUid then
					obj:_startPrimerTargetHunt()
					return
				end
			end

			if obj._forestDropInProgress ~= nil and uid == obj._forestDropInProgress then
				return
			end

			if not active then
				return
			end

			if obj.running then
				if not obj.activeTarget then
					return
				end
			else
				return
			end

			local humanoidRootPart = localPlayer2.Character and localPlayer2.Character:FindFirstChild("HumanoidRootPart")

			if humanoidRootPart and obj:_isInSafeArea(humanoidRootPart) then
				obj:_reportStolen()
				obj:_finish("Safe return complete")
				return
			end

			task.delay(n40, function()
				if obj.destroyed then
					return
				elseif obj.enabled then
					if obj.carry.active then
						return
					elseif obj.carry.generation ~= generation then
						return
					end
				else
					return
				end

				local humanoidRootPart2 = localPlayer2.Character and localPlayer2.Character:FindFirstChild("HumanoidRootPart")

				if humanoidRootPart2 and obj:_isInSafeArea(humanoidRootPart2) then
					obj:_reportStolen()
					obj:_finish("Safe return complete")
					return
				end

				obj:_reStealDroppedEgg(uid)
			end)
		end, obj.connections)

		fn63(localPlayer2:GetAttributeChangedSignal("RagdollEndTime"), function()
			local attribute = localPlayer2:GetAttribute("RagdollEndTime") or 0

			if obj.instantPhase == "priming" and attribute > workspace:GetServerTimeNow() then
				obj:_startPrimerTargetHunt()
			end
		end, obj.connections)

		fn63(RunService2.Heartbeat, function()
			if obj.destroyed then
				return
			end
			local now = os.clock()
			if now - (obj._espLastTick or 0) < 0.4 then
				return
			end
			obj._espLastTick = now

			local ok, result = pcall(function()
				obj:_updateEsp()
			end)

			if not ok and now - (obj._espErrLast or 0) > 5 then
				obj._espErrLast = now
				warn("[SAE][esp] update error: " .. tostring(result))
			end
		end, obj.connections)

		local status = obj.stats.status
		obj.stats.status = status
		return obj
	end

	index._installClaimPresentationFilter = function(arg)
		return false
	end

	index._restoreClaimPresentationFilter = function(arg)
		local claimPresentationNode = arg.claimPresentationNode
		local claimPresentationOriginal = arg.claimPresentationOriginal

		if type(claimPresentationNode) == "table" and (type(claimPresentationOriginal) == "function" and rawget(claimPresentationNode, "_fn") == arg.claimPresentationWrapper) then
			claimPresentationNode._fn = claimPresentationOriginal
		end

		arg.claimPresentationNode = nil
		arg.claimPresentationOriginal = nil
		arg.claimPresentationWrapper = nil
		arg.claimPresentationSuppression = nil
	end

	index._setStatus = function(arg, status)
		if arg.stats.status == status then
			return
		end

		if type(status) == "string" and string.find(status, "not currently trusted", 1, true) then
			arg._untrustedSeen = true
		end

		arg.stats.status = status
		arg:_notify()
	end

	index._notify = function(arg)
		local v8 = arg:getSnapshot()

		for k in pairs(arg.listeners) do
			local ok, result = pcall(k, v8)

			if not ok then
				warn("[StealAnEgg] UI listener failed:", result)
			end
		end
	end

	index.onChanged = function(arg, arg2)
		arg.listeners[arg2] = true
		local ok, result = pcall(arg2, arg:getSnapshot())

		if not ok then
			warn("[StealAnEgg] UI listener failed:", result)
		end

		return function()
			arg.listeners[arg2] = nil
		end
	end

	index.getSnapshot = function(arg)
		return {status = arg.stats.status, available = arg.stats.available, matching = arg.stats.matching, lastTarget = arg.stats.lastTarget, lastResult = arg.stats.lastResult, wallClosed = arg.resetBlocked or AreaEggResetWall3.IsSealed() or os.clock() < arg.gateOpenAt, enabled = arg.enabled, running = arg.running}
	end

	index._replaceSnapshot = function(arg, arg2)
		table.clear(arg.records)

		for k, v8 in pairs(arg2 and (arg2.Records or arg2) or {}) do
			if type(v8) == "table" and type(v8.Uid) == "string" then
				arg.records[v8.Uid] = v8
			elseif type(k) == "string" then
				if type(v8) == "table" then
					arg.records[k] = v8
				end
			end
		end

		arg:_refreshCounts()
		arg:_schedule()
	end

	index._indexWants = function(arg)
		local now = os.clock()
		local indexCache = arg.indexCache
		if indexCache and now - (indexCache.at or 0) < 2 then
			return indexCache.set
		end
		local tbl16 = {}

		pcall(function()
			local areasDirectory = arg.areasDirectory

			if areasDirectory then
			else
				areasDirectory = require(ReplicatedStorage2.Data.Areas).Directory
				arg.areasDirectory = areasDirectory
			end

			local uid = (Save.Peek or Save.Get)()

			if areasDirectory then
				if not uid then
					return
				end
			else
				return
			end

			local index2 = uid.Index or {}
			local tbl17 = {}

			for k, v8 in pairs(uid.EggInventory or {}) do
				local assetCategory = type(v8) == "table" and (v8.AssetCategory or v8.Category)

				if assetCategory then
					tbl17[tostring(assetCategory)] = true
				end
			end

			uid = arg.carry and arg.carry.uid

			if uid then
				local v8 = arg.records[uid]

				if v8 and v8.AssetCategory then
					tbl17[tostring(v8.AssetCategory)] = true
				end
			end

			for k, v8 in pairs(areasDirectory) do
				if type(v8) == "table" and type(v8.DropTable) == "table" then
					for i, v9 in ipairs(v8.DropTable) do
						uid = v9[1]

						if uid then
							local str9 = tostring(uid)

							if not index2[str9] and not tbl17[str9] then
								tbl16[str9] = true
							end
						end
					end
				end
			end
		end)

		arg.indexCache = {at = now, set = tbl16}
		return tbl16
	end

	index._isIndexObjective = function(arg, arg2)
		if not arg.indexObjectiveEnabled then
			return false
		end

		if type(arg2) ~= "table" then
			return false
		end
		local assetCategory = arg2.AssetCategory

		if assetCategory then
			if assetCategory == "" then
				return false
			end
		else
			return false
		end

		return arg:_indexWants()[tostring(assetCategory)] == true
	end

	index.setIndexObjective = function(arg, arg2)
		local indexObjectiveEnabled = arg2 == true
		if arg.indexObjectiveEnabled == indexObjectiveEnabled then
			return
		end
		arg.indexObjectiveEnabled = indexObjectiveEnabled
		arg.indexCache = {at = 0, set = {}}
		arg:_reconcileRunningState()
	end

	index._isWispObjective = function(arg, arg2)
		local wispObjective = arg.wispObjective

		if type(wispObjective) ~= "table" then
			return false
		elseif type(arg2) ~= "table" then
			return false
		end

		if wispObjective.area and arg2.AreaId ~= wispObjective.area then
			return false
		end

		if wispObjective.rarity then
			local v8 = arg.catalog.resolve(arg2)

			if v8 then
				if v8.rarity ~= wispObjective.rarity then
					return false
				end
			else
				return false
			end
		end

		return true
	end

	index.setWispObjective = function(arg, arg2)
		local wispObjectiveKey = type(arg2) == "table" and (arg2.area or "") .. "|" .. (arg2.rarity or "") or nil
		if arg.wispObjectiveKey == wispObjectiveKey then
			return
		end
		arg.wispObjectiveKey = wispObjectiveKey
		arg.wispObjective = wispObjectiveKey and arg2 or nil
		arg:_reconcileRunningState()
	end

	index.indexMissingCount = function(arg)
		local n51 = 0

		for k in pairs(arg:_indexWants()) do
			n51 += 1
		end

		return n51
	end

	index._matchesNormalFilter = function(arg, arg2)
		local minWeightKg = arg.catalog.resolve(arg2)
		local config = arg.config

		if config.rarityEnabled then
			if #config.rarities == 0 then
				return false
			elseif not fn65(config.rarities, minWeightKg.rarity) then
				return false
			end
		end

		if config.nameEnabled then
			if #config.names == 0 then
				return false
			elseif not fn65(config.names, minWeightKg.name) then
				if not fn65(config.names, minWeightKg.category) then
					return false
				end
			end
		end

		if config.areaEnabled then
			if #config.areas == 0 then
				return false
			elseif not fn65(config.areas, arg2.AreaId) then
				return false
			end
		end

		if config.mutationEnabled and not fn85(arg2, config.mutations) then
			return false
		end
		minWeightKg = config.minWeightKg

		if minWeightKg and minWeightKg > 0 then
			local v8 = arg:_resolveWeightKg(arg2)

			if v8 then
				if v8 < config.minWeightKg then
					return false
				end
			else
				return false
			end
		end

		local minValuePerSec = config.minValuePerSec

		if minValuePerSec and minValuePerSec > 0 then
			local v8 = fn66(arg2)

			if v8 then
				if v8 < config.minValuePerSec then
					return false
				end
			else
				return false
			end
		end

		return true
	end

	index._matches = function(arg, arg2)
		if arg2.State ~= AreaEggs.States.Slot and arg2.State ~= AreaEggs.States.Dropped then
			return false
		end

		if arg.riftWants[arg2.AssetCategory] then
			return true
		end

		if arg.indexObjectiveEnabled and arg:_isIndexObjective(arg2) then
			return true
		end

		if arg.wispObjective and arg:_isWispObjective(arg2) then
			return true
		end

		if arg.userStealEnabled and (not arg.riftOnly and arg:_matchesNormalFilter(arg2)) then
			return true
		end
		return false
	end

	index.setScrambleWants = function(arg, arg2, arg3)
		local riftWants = {}

		for i, v8 in ipairs(type(arg2) == "table" and arg2 or {}) do
			if type(v8) == "string" and v8 ~= "" then
				riftWants[v8] = true
			end
		end

		local riftOnly = arg3 == true
		arg3 = riftOnly ~= arg.riftOnly

		for k in pairs(riftWants) do
			arg3 = if arg.riftWants[k] then arg3 else true
		end

		for k in pairs(arg.riftWants) do
			arg3 = if riftWants[k] then arg3 else true
		end

		if not arg3 then
			return
		end
		arg.riftWants = riftWants
		arg.riftOnly = riftOnly
		arg:_reconcileRunningState()
	end

	index._refreshCounts = function(arg)
		local available = 0
		local matching = 0

		for k, record in pairs(arg.records) do
			if record.State == AreaEggs.States.Slot then
				available, matching = available + 1, if arg:_matches(record) then matching + 1 else matching
			end
		end

		arg.stats.available = available
		arg.stats.matching = matching
		arg:_notify()
	end

	index.hasPriorityRareEgg = function(arg)
		local humanoidRootPart, v8, v9, v10 = localPlayer2.Character and localPlayer2.Character:FindFirstChild("HumanoidRootPart")

		for k, v11 in pairs(arg.records or {}) do
			if (v11.State == AreaEggs.States.Slot or v11.State == AreaEggs.States.Dropped) and v11.BottomCFrame then
				if arg:isSkippedEgg(v11.Uid) then
				else
					if arg:_matchesNormalFilter(v11) then
						local v12 = arg.catalog.resolve(v11)

						if tbl11[v12.rarity] then
							local magnitude = humanoidRootPart and (v11.BottomCFrame.Position - humanoidRootPart.Position).Magnitude or 0
							local rarityRank = v12.rarityRank or 0

							if v8 then
								if rarityRank > v9 then
									v8 = v11
									v9 = rarityRank
									v10 = magnitude
								else
									if rarityRank == v9 and magnitude < v10 then
										v8 = v11
										v9 = rarityRank
										v10 = magnitude
									end
								end
							else
								v8 = v11
								v9 = rarityRank
								v10 = magnitude
							end
						end
					end
				end
			end
		end

		return v8 ~= nil, v8
	end

	local str9 = "Event_CaptureTheEggUid"
	local n51 = 110

	index.isSkippedEgg = function(arg, arg2)
		if arg2 ~= nil and (arg2 == workspace:GetAttribute(str9) and not arg.captureObjectiveEnabled) then
			return true
		end
		local v8 = arg2 and arg.skippedEggs[arg2]
		if not v8 then
			return false
		end

		if os.clock() < v8 then
			return true
		end
		arg.skippedEggs[arg2] = nil
		return false
	end

	index._isCaptureEgg = function(arg, arg2)
		return arg2 ~= nil and arg2 == workspace:GetAttribute(str9)
	end

	index.setCaptureObjective = function(arg, arg2)
		local flag5 = arg2 == true
		if arg.captureObjectiveEnabled == flag5 then
			return
		end

		if flag5 then
			arg._modeBeforeCapture = {arg.config.stealMode, arg.config.flyAerial, arg.config.flyZigzag}
			arg:setStealMode("Instant", false, false)
			arg.captureObjectiveEnabled = true
		else
			arg.captureObjectiveEnabled = false
			local modeBeforeCapture = arg._modeBeforeCapture
			arg._modeBeforeCapture = nil

			if modeBeforeCapture then
				arg:setStealMode(modeBeforeCapture[1], modeBeforeCapture[2], modeBeforeCapture[3])
			end
		end

		arg:_reconcileRunningState()
	end

	index._captureHold = function(arg, captureHoldUid)
		if arg._captureHoldUid == captureHoldUid then
			return
		end
		arg._captureHoldUid = captureHoldUid

		local function fn87()
			local v8 = EggState2.ReadFieldEgg(captureHoldUid)
			return v8 ~= nil and v8.State == AreaEggs.States.Carried and v8.CarrierUserId == localPlayer2.UserId
		end

		local function fn88()
			local destroyed = arg.destroyed
			return (if destroyed then not destroyed else arg.enabled) and arg.captureObjectiveEnabled and fn87()
		end

		task.spawn(function()
			arg:_clearArrivalHold(captureHoldUid)
			arg:_hideTreadmillDecoy()

			pcall(function()
				arg:_stopHoverPad()
			end)

			arg.stats.lastResult = "Holding capture egg"
			arg:_setStatus("Holding capture egg")
			local character = localPlayer2.Character
			local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
			local cFrame = humanoidRootPart and CFrame.new(humanoidRootPart.Position.X, n51, humanoidRootPart.Position.Z) * humanoidRootPart.CFrame.Rotation

			if cFrame then
				arg:_glideRoot(cFrame, function()
					return not fn88()
				end)
			end

			while fn88() do
				local character2 = localPlayer2.Character
				local humanoidRootPart2 = character2 and character2:FindFirstChild("HumanoidRootPart")
				local humanoid = character2 and character2:FindFirstChildOfClass("Humanoid")

				if humanoidRootPart2 and humanoid and cFrame then
					pcall(function()
						humanoidRootPart2.CFrame = cFrame
						humanoidRootPart2.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
						humanoidRootPart2.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
					end)

					arg:_syncHoverPad(cFrame.Position)
					local n52 = math.clamp(arg.config.speed or n15, n13, fn61())

					pcall(function()
						fn74(character2, n52 * n44)
						fn83(humanoid, humanoidRootPart2, n52, (Vector3.new(0, 0, 0)))
					end)
				end

				task.wait(0.1)
			end

			pcall(function()
				arg:_stopHoverPad()
			end)

			if arg._captureHoldUid == captureHoldUid then
				arg._captureHoldUid = nil
			end

			if arg.destroyed then
				return
			elseif not arg.enabled then
				return
			end

			arg:_finish(arg.captureObjectiveEnabled and "Capture egg lost \226\128\148 re-grabbing" or "Capture stopped")
		end)
	end

	index._chooseTarget = function(arg)
		local humanoidRootPart = localPlayer2.Character and localPlayer2.Character:FindFirstChild("HumanoidRootPart")
		if not humanoidRootPart then
			return nil
		end

		if arg.captureObjectiveEnabled then
			local attribute = workspace:GetAttribute(str9)
			local v8 = attribute and (EggState2.ReadFieldEgg(attribute) or arg.records[attribute])

			if type(v8) == "table" and v8.BottomCFrame then
				if v8.State == AreaEggs.States.Slot then
					return v8
				elseif v8.State == AreaEggs.States.Dropped then
					return v8
				end
			end
		end

		if arg.manualObjectiveEnabled then
			local v8 = arg:_takeManualTarget()
			if v8 then
				return v8
			end
		end

		if arg.userStealEnabled and not arg.riftOnly then
			local v8, v9 = arg:hasPriorityRareEgg()
			if v8 and v9 then
				return v9
			end
		end

		local v8, v9, v10, v11, v12, v13

		for k, record in pairs(arg.records) do
			if (record.State == AreaEggs.States.Slot or record.State == AreaEggs.States.Dropped) and record.BottomCFrame then
				if arg:isSkippedEgg(record.Uid) then
				else
					local magnitude = (record.BottomCFrame.Position - humanoidRootPart.Position).Magnitude

					if arg.riftWants[record.AssetCategory] then
						if v8 then
							if magnitude < v9 then
								v8 = record
								v9 = magnitude
							end
						else
							v8 = record
							v9 = magnitude
						end
					else
						if arg.wispObjective and arg:_isWispObjective(record) then
							if v10 then
								if magnitude < v11 then
									v10 = record
									v11 = magnitude
								end
							else
								v10 = record
								v11 = magnitude
							end
						else
							if arg.indexObjectiveEnabled and arg:_isIndexObjective(record) then
								if v12 then
									if magnitude < v13 then
										v12 = record
										v13 = magnitude
									end
								else
									v12 = record
									v13 = magnitude
								end
							end
						end
					end
				end
			end
		end

		if v8 or v10 or v12 then
			return v8 or v10 or v12
		end

		if arg.userStealEnabled and not arg.riftOnly then
			local v14, v15, v16

			for k, record in pairs(arg.records) do
				if record.State == AreaEggs.States.Slot or record.State == AreaEggs.States.Dropped then
					local v17 = arg:isSkippedEgg(record.Uid)

					if if v17 then not v17 else arg:_matchesNormalFilter(record) then
						local magnitude = (record.BottomCFrame.Position - humanoidRootPart.Position).Magnitude
						local v18 = arg.catalog.resolve(record)
						local v19 = if arg.config.highestValueFirst then fn66(record) or -1 / 0 else if arg.config.heaviestFirst then arg:_resolveWeightKg(record) or -1 / 0 else v18.rarityRank or 0

						if v14 then
							if v19 > v15 then
								v14 = record
								v15 = v19
								v16 = magnitude
							else
								if v19 == v15 and magnitude < v16 then
									v14 = record
									v15 = v19
									v16 = magnitude
								end
							end
						else
							v14 = record
							v15 = v19
							v16 = magnitude
						end
					end
				end
			end

			if v14 then
				return v14
			end
		end

		return nil
	end

	index._takeManualTarget = function(arg)
		local tbl16 = {}
		local manualOrder = {}

		for i, v8 in ipairs(arg.manualOrder) do
			local v9 = arg.records[v8]

			if v9 then
				if v9.State == AreaEggs.States.Slot then
					manualOrder[#manualOrder + 1] = v8
					tbl16[v8] = true
				elseif v9.State == AreaEggs.States.Dropped then
					manualOrder[#manualOrder + 1] = v8
					tbl16[v8] = true
				end
			end
		end

		arg.manualOrder = manualOrder

		for k in pairs(arg.manualQueue) do
			if not tbl16[k] then
				arg.manualQueue[k] = nil
			end
		end

		if #manualOrder == 0 then
			if arg.manualObjectiveEnabled then
				arg.manualObjectiveEnabled = false

				task.defer(function()
					if not arg.destroyed then
						arg:_reconcileRunningState()
					end
				end)
			end

			return nil
		end

		return arg.records[manualOrder[1]]
	end

	index.queueManual = function(arg, arg2)
		if type(arg2) ~= "table" then
			return 0
		end

		for i, v8 in ipairs(arg2) do
			if v8 ~= nil and not arg.manualQueue[v8] then
				arg.manualQueue[v8] = true
				arg.manualOrder[#arg.manualOrder + 1] = v8
			end
		end

		local n52 = #arg.manualOrder

		if n52 > 0 then
			arg.manualObjectiveEnabled = true
		end

		arg:_reconcileRunningState()
		return n52
	end

	index.clearManual = function(arg)
		arg.manualQueue = {}
		arg.manualOrder = {}
		arg.manualObjectiveEnabled = false
		arg:_reconcileRunningState()
	end

	index.manualPending = function(arg)
		return #arg.manualOrder
	end

	index.setTreadmillManager = function(arg, treadmillManager)
		arg.treadmillManager = treadmillManager
	end

	index.getStealMode = function(arg)
		return arg.config.stealMode == "Fly" and "Fly" or "Instant"
	end

	index.setStealMode = function(arg, arg2, arg3, arg4)
		local stealMode = arg2 == "Fly" and "Fly" or "Instant"
		local flyAerial = stealMode == "Fly" and arg3 == true
		local flyZigzag = stealMode == "Fly" and arg4 == true and not flyAerial

		if arg.config.stealMode ~= stealMode or arg.config.flyAerial ~= flyAerial or arg.config.flyZigzag ~= flyZigzag then
			arg.config.stealMode = stealMode
			arg.config.flyAerial = flyAerial
			arg.config.flyZigzag = flyZigzag

			if arg.enabled then
				arg:_installGuardHitDistanceBoost()
				arg:_finish("Mode changed")
			end
		end

		return stealMode
	end

	local resolveHitDistance
	local n52 = 25

	index._installGuardHitDistanceBoost = function(arg)
		if arg.guardHitBoostInstalled then
			return
		end

		local function fn87()
			local GuardChasePolicy = require(ReplicatedStorage2.Shared.Modules.GuardAreas.GuardChasePolicy)

			if GuardChasePolicy and type(GuardChasePolicy.ResolveHitDistance) == "function" then
				resolveHitDistance = resolveHitDistance or GuardChasePolicy.ResolveHitDistance
				local v8 = arg

				GuardChasePolicy.ResolveHitDistance = function(arg2)
					if v8.enabled and v8.instantPhase == "priming" then
						return n52
					end

					if v8.enabled then
						return -1 / 0
					elseif v8._recalling then
						return -1 / 0
					end

					return resolveHitDistance and resolveHitDistance(arg2) or (arg2 or 10)
				end

				arg.guardHitBoostInstalled = true
			end
		end

		pcall(fn87)
	end

	index._removeGuardHitDistanceBoost = function(arg)
		if not arg.guardHitBoostInstalled then
			return
		end

		pcall(function()
			local GuardChasePolicy = require(ReplicatedStorage2.Shared.Modules.GuardAreas.GuardChasePolicy)

			if GuardChasePolicy and resolveHitDistance then
				GuardChasePolicy.ResolveHitDistance = resolveHitDistance
				arg.guardHitBoostInstalled = false
			end
		end)
	end

	index._setInstantAnchored = function(arg, anchored)
		pcall(function()
			local humanoidRootPart = localPlayer2.Character and localPlayer2.Character:FindFirstChild("HumanoidRootPart")

			if humanoidRootPart and humanoidRootPart.Anchored ~= anchored then
				humanoidRootPart.Anchored = anchored
			end
		end)
	end

	index._kbCancelTimer = function(arg)
		if arg.hitTimer then
			pcall(task.cancel, arg.hitTimer)
			arg.hitTimer = nil
		end
	end

	index._isPrimerEgg = function(arg, arg2)
		if arg2 == nil then
			return false
		end

		if arg2 == arg.primerUid then
			return true
		end
		local primerUids = arg.primerUids and arg.primerUids[arg2]
		if primerUids and primerUids > os.clock() then
			return true
		end

		if primerUids then
			arg.primerUids[arg2] = nil
		end

		return false
	end

	index._cleanupInstantSteal = function(arg)
		arg.instantPhase = nil
		arg.primerUid = nil
		arg.targetUid = nil
		arg._flyDeparting = false
		arg:_stopGuardStick()
		arg:_kbCancelTimer()
		arg:_setInstantAnchored(false)
		arg:_hideTreadmillDecoy()
	end

	index._choosePrimerEgg = function(arg, arg2)
		local guard = fn()
		local areas = guard and guard:FindFirstChild("Areas")
		local guardAreas = areas and areas:FindFirstChild("GuardAreas")
		local forest = guardAreas and guardAreas:FindFirstChild("Forest")
		guard = forest and forest:FindFirstChild("Guard")
		areas = guard and guard:FindFirstChild("HumanoidRootPart")
		local position, v8, v9 = areas and areas.Position

		for k, record in pairs(arg.records) do
			if record.State == AreaEggs.States.Slot and (record.AreaId == "Forest" and record.Uid ~= arg2) then
				if arg:_isCaptureEgg(record.Uid) then
				else
					local magnitude = position and (record.BottomCFrame.Position - position).Magnitude or (localPlayer2.Character and localPlayer2.Character:FindFirstChild("HumanoidRootPart") and (record.BottomCFrame.Position - localPlayer2.Character.HumanoidRootPart.Position).Magnitude or 1 / 0)
					local rarityRank = arg.catalog.resolve(record).rarityRank or 0
					local n53 = -magnitude - rarityRank * 100

					if v8 then
						if n53 > v9 then
							v8 = record
							v9 = n53
						end
					else
						v8 = record
						v9 = n53
					end
				end
			end
		end

		return v8
	end

	local n53 = 2.5
	local n54 = 0.05
	local n55 = 1.5
	local n56 = 18
	local n57 = 0.35

	index._stopGuardStick = function(arg)
		if arg.guardStickConnection then
			pcall(arg.guardStickConnection.Disconnect, arg.guardStickConnection)
			arg.guardStickConnection = nil
		end
	end

	index._startGuardStick = function(arg)
		arg:_stopGuardStick()

		local function fn87()
			local v8 = fn()
			local areas = v8 and v8:FindFirstChild("Areas")
			local guardAreas = areas and areas:FindFirstChild("GuardAreas")
			local forest = guardAreas and guardAreas:FindFirstChild("Forest")
			local guard = forest and forest:FindFirstChild("Guard")
			return guard and guard:FindFirstChild("HumanoidRootPart")
		end

		arg.guardStickConnection = RunService2.PreSimulation:Connect(function()
			if arg.destroyed then
				arg:_stopGuardStick()
				return
			elseif arg.enabled then
				if arg.instantPhase ~= "priming" then
					arg:_stopGuardStick()
					return
				end
			else
				arg:_stopGuardStick()
				return
			end

			local n58 = fn87()
			local character = localPlayer2.Character
			local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

			if n58 then
				if not humanoidRootPart then
					return
				end
			else
				return
			end

			local position = n58.Position
			local n59 = n58.CFrame.LookVector * n53
			n58 = Vector3.new(position.X + n59.X, humanoidRootPart.Position.Y, position.Z + n59.Z) - humanoidRootPart.Position
			local v8 = if n58.Magnitude > 40 then n58.Unit * 40 else n58
			local n60 = humanoidRootPart.Position + v8
			humanoidRootPart.CFrame = CFrame.lookAt(n60, Vector3.new(position.X, n60.Y, position.Z))
			humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
			humanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
			arg:_syncHoverPad(n60)
		end)
	end

	index._forestGuardModel = function(arg)
		local v8 = fn()
		local areas = v8 and v8:FindFirstChild("Areas")
		local guardAreas = areas and areas:FindFirstChild("GuardAreas")
		local forest = guardAreas and guardAreas:FindFirstChild("Forest")
		return forest and forest:FindFirstChild("Guard")
	end

	index._triggerGuardHit = function(arg)
		local v8 = arg:_forestGuardModel()
		local humanoidRootPart = v8 and v8:FindFirstChild("HumanoidRootPart")
		if not humanoidRootPart then
			return
		end
		local character = localPlayer2.Character
		local humanoidRootPart2 = character and character:FindFirstChild("HumanoidRootPart")
		if not humanoidRootPart2 then
			return
		end
		local position = humanoidRootPart.Position
		local n58 = humanoidRootPart.CFrame.LookVector * n53
		local vector3 = Vector3.new(position.X + n58.X, humanoidRootPart2.Position.Y, position.Z + n58.Z)
		arg.guardStrikeAnchor = vector3
		humanoidRootPart2.CFrame = CFrame.lookAt(vector3, Vector3.new(position.X, vector3.Y, position.Z))
		humanoidRootPart2.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
		local collider = v8:FindFirstChild("Collider") or humanoidRootPart

		if collider and firetouchinterest then
			pcall(function()
				firetouchinterest(humanoidRootPart2, collider, 0)
				firetouchinterest(humanoidRootPart2, collider, 1)
			end)
		end

		pcall(function()
			local forestStrike = Remotes.GuardPatrol and Remotes.GuardPatrol.ForestStrike

			if forestStrike then
				forestStrike:FireServer({EggUid = arg.primerUid, GuardCFrame = humanoidRootPart.CFrame})
			end
		end)
	end

	index._stopGuardStrike = function(arg)
		arg.guardStrikeGeneration = (arg.guardStrikeGeneration or 0) + 1
	end

	index._knockbackLanded = function(arg)
		local character = localPlayer2.Character
		local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")

		if humanoidRootPart then
			if not humanoid then
				return false
			end
		else
			return false
		end

		if humanoid.PlatformStand then
			return true
		elseif humanoid.Sit then
			return true
		end

		local state = humanoid:GetState()

		if state == Enum.HumanoidStateType.Ragdoll then
			return true
		elseif state == Enum.HumanoidStateType.FallingDown then
			return true
		elseif state == Enum.HumanoidStateType.PlatformStanding then
			return true
		end

		return humanoidRootPart.AssemblyLinearVelocity.Magnitude > n56
	end

	index._settleAfterKnockback = function(arg)
		local guardStrikeAnchor = arg.guardStrikeAnchor
		local n58 = os.clock() + n57

		while os.clock() < n58 and not arg.destroyed do
			local character = localPlayer2.Character
			local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
			if not humanoidRootPart then
				return
			end
			local humanoid = character:FindFirstChildOfClass("Humanoid")

			if humanoid then
				pcall(function()
					humanoid.PlatformStand = false
					humanoid.Sit = false
					humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
				end)
			end

			if guardStrikeAnchor then
				humanoidRootPart.CFrame = CFrame.new(guardStrikeAnchor)
			end

			humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
			humanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
			arg:_syncHoverPad(guardStrikeAnchor or humanoidRootPart.Position)
			RunService2.Heartbeat:Wait()
		end
	end

	index._startGuardStrike = function(arg)
		arg:_stopGuardStrike()
		local guardStrikeGeneration = arg.guardStrikeGeneration

		task.spawn(function()
			local n58 = os.clock() + n55

			while true do
				local destroyed = arg.destroyed
				if not ((if destroyed then not destroyed else arg.enabled) and arg.instantPhase == "priming" and arg.guardStrikeGeneration == guardStrikeGeneration and os.clock() < n58) then
					break
				end
				arg:_triggerGuardHit()
				local n59 = os.clock() + n54
				local flag5 = false

				while os.clock() < n59 do
					if arg:_knockbackLanded() then
						flag5 = true
						break
					end
					RunService2.Heartbeat:Wait()
				end

				if flag5 then
					break
				end
			end

			if arg.guardStrikeGeneration == guardStrikeGeneration then
				arg:_stopGuardStick()
				arg:_settleAfterKnockback()
			end
		end)
	end

	index._enterBaitWait = function(arg)
		arg:_setInstantAnchored(false)
		arg:_setStatus("Preparing steal")
		arg:_startGuardStick()
		arg:_startGuardStrike()
		if arg.hitTimer then
			return
		end

		arg.hitTimer = task.delay(n55 + 0.3, function()
			arg.hitTimer = nil

			if arg.destroyed then
				return
			elseif not arg.enabled then
				return
			end

			if arg.instantPhase ~= "priming" then
				return
			end
			arg:_stopGuardStick()
			arg:_stopGuardStrike()

			if arg.carry.active and arg:_isPrimerEgg(arg.carry.uid) then
				pcall(EggState2.DropFieldEgg, "PlayerRequest")
			end

			arg:_finish("Steal timed out \226\128\148 retrying")
		end)
	end

	local function fn87(arg, arg2)
		local str10 = tostring(arg or ""):lower()
		local n58 = 8
		local n59 = 3.5

		if str10:find("enchanted") then
			n58 = 18
			n59 = 12
		else
			if str10:find("light") then
				local n60 = 16
				local n61 = 10
				n58 = n60
				n59 = n61
			else
				if str10:find("dark") then
					local n60 = 16
					local n61 = 10
					n58 = n60
					n59 = n61
				else
					if str10:find("titan") then
						local n60 = 10
						local n61 = 8
						n58 = n60
						n59 = n61
					else
						if str10:find("cosmic") then
							local n60 = 10
							local n61 = 8
							n58 = n60
							n59 = n61
						else
							if str10:find("cherry") then
								local n60 = 10
								local n61 = 8
								n58 = n60
								n59 = n61
							end
						end
					end
				end
			end
		end

		return math.max(n59, n58 * ((11 - math.clamp(arg2, 1, 10)) / 6))
	end

	index._resolveSettleSeconds = function(arg, arg2)
		local n58 = math.clamp(tonumber(senaV4Config.StealHoldSeconds) or 5, 1, 10)
		local flag5 = arg.settleBonus and type(arg2) == "table" and arg.settleBonus[arg2.Uid]
		local seconds = flag5 and flag5.untilAt > os.clock() and flag5.seconds or 0
		local v8 = fn3()
		seconds = if v8 > 0 then if v8 < 12 then seconds + 2 else seconds else seconds
		local v9 = if genv.__SenaV4NetPing() > 300 then seconds + 1 else seconds
		return fn87(type(arg2) == "table" and arg2.AreaId, n58) + v9
	end

	index._startPrimerTargetHunt = function(arg)
		if arg.instantPhase ~= "priming" then
			return
		end
		arg:_stopGuardStick()
		arg:_stopGuardStrike()

		pcall(function()
			local character = localPlayer2.Character
			local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
			local humanoid = character and character:FindFirstChildOfClass("Humanoid")

			if humanoid then
				humanoid.PlatformStand = false
				humanoid.Sit = false
			end

			if humanoidRootPart then
				if arg.guardStrikeAnchor then
					humanoidRootPart.CFrame = CFrame.new(arg.guardStrikeAnchor)
				end

				humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
				humanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
			end
		end)

		arg:_kbCancelTimer()
		arg:_setInstantAnchored(false)
		arg.instantPhase = "hunting"
		arg:_clearArrivalHold()
		arg.carry.generation += 1
		arg:_invalidateCarryWorker()
		arg.carry.active = false
		arg.carry.uid = nil
		local targetUid = arg.targetUid
		arg.targetUid = nil
		if not targetUid then
			arg:_finish("No target egg")
			return
		end
		local v8 = EggState2.ReadFieldEgg(targetUid) or arg.records[targetUid]
		if not v8 or v8.State ~= AreaEggs.States.Slot and v8.State ~= AreaEggs.States.Dropped then
			arg:_finish("Target egg no longer available")
			return
		end
		local character = localPlayer2.Character
		local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")

		if humanoidRootPart then
			if not humanoid then
				arg:_finish("Character unavailable")
				return
			end
		else
			arg:_finish("Character unavailable")
			return
		end

		arg.activeTarget = v8
		local v9 = arg:_resolveEggDestination(v8, humanoidRootPart, humanoid)
		if not v9 then
			arg:_finish("Target destination unavailable")
			return
		end

		if arg.config.stealMode == "Fly" then
			local uid = v8.Uid

			local function fn88()
				return arg.destroyed or not arg.enabled or arg.instantPhase ~= "hunting" or not arg.activeTarget or arg.activeTarget.Uid ~= uid
			end

			if arg.config.flyAerial then
				arg:_setStatus("Heading to target egg")
				arg:_startFlyGrounding()
				local v10 = arg:_flyWalkTo(v9, fn88, 8, 110)
				arg:_stopFlyGrounding()

				if not v10 then
					if not fn88() then
						arg:_finish("Could not reach the egg \226\128\148 retrying")
					end

					return
				end
			elseif arg.config.flyZigzag then
				arg:_setStatus("Heading to target egg")

				if not arg:_walkToZigzag(v9, fn88) then
					if not fn88() then
						arg:_finish("Zig-zag walk to target failed")
					end

					return
				end
			else
				arg:_setStatus("Heading to target egg")

				if not arg:_walkTo(v9, fn88) then
					if not fn88() then
						arg:_finish("Walk to target failed")
					end

					return
				end
			end

			if fn88() then
				return
			end
			arg:_glideRoot(v9, fn88, arg:_legitWalkSpeed())
			if fn88() then
				return
			end
			arg:_setArrivalHold(v9, uid)
			arg:_setStatus("Securing target egg")
			arg:_requestCarry(v8, true)
			return
		end

		if arg.config.stealMode == "Instant" then
			local uid = v8.Uid

			local function fn88()
				return arg.destroyed or not arg.enabled or arg.instantPhase ~= "hunting" or not arg.activeTarget or arg.activeTarget.Uid ~= uid
			end

			local n58 = v9 + Vector3.new(0, n25, 0)
			arg:_setStatus("Heading to target egg")

			if not arg:_glideRoot(n58, fn88) then
				if not fn88() then
					arg:_finish("Could not reach the egg \226\128\148 retrying")
				end

				return
			end

			task.spawn(arg._hoverSettleCarry, arg, v8, v9, n58, fn88)
			return
		end

		arg:_setStatus("Heading to target egg")

		arg:_tweenRoot(v9, function()
			if arg.instantPhase == "hunting" and (arg.activeTarget and arg.activeTarget.Uid == v8.Uid) then
				arg:_requestCarry(v8, false)
			end
		end, nil, {holdAfterArrival = true, holdUid = v8.Uid, flightProfile = true, carryTarget = v8})
	end

	index._hoverSettleCarry = function(arg, arg2, arg3, cFrame, arg4)
		arg:_startHoverPad()
		local v8 = arg:_resolveSettleSeconds(arg2)
		local n58 = os.clock() + v8

		while os.clock() < n58 do
			if arg4() then
				return
			end
			arg:_setStatus(string.format("Securing target egg (%.1fs)", math.max(0, n58 - os.clock())))
			local character = localPlayer2.Character
			local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
			local humanoid = character and character:FindFirstChildOfClass("Humanoid")

			if humanoidRootPart and humanoid then
				pcall(function()
					humanoidRootPart.CFrame = cFrame
					humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
					humanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
				end)

				arg:_syncHoverPad(cFrame.Position)
				local n59 = math.clamp(arg.config.speed or n15, n13, fn61())

				pcall(function()
					fn74(character, n59 * n44)
					fn83(humanoid, humanoidRootPart, n59, (Vector3.new(0, 0, 0)))
				end)
			end

			task.wait(0.1)
		end

		if arg4() then
			return
		end
		arg:_glideRoot(arg3, arg4)
		if arg4() then
			return
		end
		arg:_setArrivalHold(arg3, arg2.Uid)
		arg:_setStatus("Securing target egg")
		arg:_requestCarry(arg2, true)
	end

	index._wallOpen = function(arg)
		if arg.resetBlocked then
			return false
		elseif AreaEggResetWall3.IsSealed() then
			return false
		elseif os.clock() < arg.gateOpenAt then
			return false
		end

		local v8 = fn()
		local areas = v8 and v8:FindFirstChild("Areas")
		local wallStartCollision = areas and areas:FindFirstChild("WallStartCollision")
		if wallStartCollision and (wallStartCollision:IsA("BasePart") and wallStartCollision.CanCollide) then
			return false
		end
		return true
	end

	index._closeGate = function(arg, arg2)
		arg.resetBlocked = true
		arg.gateOpenAt = 1 / 0
		arg.safeStarting = false

		if arg.activeTween then
			if not arg.activeTween.sharedTravel then
				arg:_cancelTween(arg2)
			end
		else
			arg:_cancelTween(arg2)
		end

		arg:_setStatus(arg2)
	end

	index._releaseOperation = function(arg)
		local operationToken = arg.operationToken
		arg.operationToken = nil

		if operationToken and arg.coordinator then
			arg.coordinator:release(operationToken)
		end
	end

	index._acquireOperation = function(arg)
		if arg.operationToken then
			return true
		elseif not arg.coordinator then
			return true
		end

		local autoSteal, v8 = arg.coordinator:tryAcquire("auto_steal", {})
		if not autoSteal then
			return false, v8
		end
		arg.operationToken = autoSteal
		return true
	end

	index._cancelTween = function(arg, lastResult, arg2)
		arg:_cleanupInstantSteal()
		arg.carryAttemptToken = nil
		arg:_clearArrivalHold()
		arg.safeStarting = false

		if arg.activeTween then
			pcall(arg.activeTween.Cancel, arg.activeTween)
			arg.activeTween = nil
		end

		if not arg.activeTween and not arg.arrivalHold then
			arg:_stopHoverPad()
		end

		if arg.running then
			arg.running = false
			arg.activeTarget = nil
			arg.stats.lastResult = lastResult
			arg:_notify()
		end

		if not arg2 then
			arg:_releaseOperation()
		end
	end

	index._groundYAt = function(arg, arg2, arg3, arg4)
		local character = arg4 or localPlayer2.Character
		local vector3 = Vector3.new(arg2, (character and character:FindFirstChild("HumanoidRootPart") and character.HumanoidRootPart.Position.Y or vector2.Y) + 60, arg3)
		local filterDescendantsInstances = {}

		if character then
			table.insert(filterDescendantsInstances, character)
		end

		if arg.hoverPad then
			table.insert(filterDescendantsInstances, arg.hoverPad)
		end

		if arg.treadmillDecoy then
			table.insert(filterDescendantsInstances, arg.treadmillDecoy)
		end

		for i, child in ipairs(workspace:GetChildren()) do
			if child.Name == name2 then
				table.insert(filterDescendantsInstances, child)
			elseif child.Name == name3 then
				table.insert(filterDescendantsInstances, child)
			end
		end

		for i = 1, 10, 1 do
			local raycastParams = RaycastParams.new()
			raycastParams.FilterType = Enum.RaycastFilterType.Exclude
			raycastParams.FilterDescendantsInstances = filterDescendantsInstances
			raycastParams.IgnoreWater = true
			local hit = workspace:Raycast(vector3, Vector3.new(0, -300, 0), raycastParams)
			if not hit then
				return nil
			end

			if hit.Instance.CanCollide then
				return hit.Position.Y
			end
			table.insert(filterDescendantsInstances, hit.Instance)
		end

		return nil
	end

	index._resolveSafeCFrame = function(arg, arg2)
		if not arg2 then
			return nil
		end
		local x = vector2.X
		local z = vector2.Z
		local y = vector2.Y
		local v8 = arg:_groundYAt(x, z, arg2.Parent)
		local v9 = if v8 then v8 + 3.2 else y
		return CFrame.new(x, v9, z) * arg2.CFrame.Rotation
	end

	index._groundSnap = function(arg)
		local character = localPlayer2.Character
		local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		if not humanoidRootPart or not humanoid then
			return false
		end
		local position = humanoidRootPart.Position
		local v8 = arg:_groundYAt(position.X, position.Z, character)
		if not v8 then
			return false
		end
		local n58 = v8 + arg:_feetOffset(humanoidRootPart, humanoid)

		if position.Y < n58 - 0.25 or position.Y > n58 + 8 then
			pcall(function()
				arg:_syncHoverPad(Vector3.new(position.X, n58, position.Z))
				humanoidRootPart.CFrame = CFrame.new(position.X, n58, position.Z) * humanoidRootPart.CFrame.Rotation
				humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
				humanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
			end)

			return true
		end

		return false
	end

	local function fn88(arg)
		if typeof(arg) == "Instance" and arg:IsA("Trail") then
			pcall(arg.Destroy, arg)
		end
	end

	local function fn89(arg)
		if typeof(arg) == "Instance" then
			if arg.Name == "SpeedGainPopup" then
				pcall(arg.Destroy, arg)
			elseif arg.Name == "PlusOne" then
				pcall(arg.Destroy, arg)
			end
		end
	end

	index._showTreadmillDecoy = function(arg)
		if arg.treadmillDecoy and arg.treadmillDecoy.Parent then
			return true
		end
		arg:_hideTreadmillDecoy()
		local character = localPlayer2.Character
		if not character then
			return false
		end
		local archivable = character.Archivable
		character.Archivable = true
		local ok, treadmillDecoy = pcall(character.Clone, character)
		character.Archivable = archivable

		if ok then
			if not treadmillDecoy then
				return false
			elseif typeof(treadmillDecoy) ~= "Instance" then
				return false
			end
		else
			return false
		end

		treadmillDecoy.Name = name3

		for i, descendant in ipairs(treadmillDecoy:GetDescendants()) do
			if tbl14[descendant.ClassName] then
				pcall(descendant.Destroy, descendant)
			elseif descendant:IsA("Trail") then
				pcall(descendant.Destroy, descendant)
			elseif descendant:IsA("BasePart") then
				descendant.LocalTransparencyModifier = 0
				descendant.Anchored = true
				descendant.CanCollide = false
				descendant.CanQuery = false
				descendant.CanTouch = false
			end
		end

		local humanoidRootPart = treadmillDecoy:FindFirstChild("HumanoidRootPart")
		local humanoid = treadmillDecoy:FindFirstChildOfClass("Humanoid")

		if humanoidRootPart then
			if not humanoid then
				treadmillDecoy:Destroy()
				return false
			end
		else
			treadmillDecoy:Destroy()
			return false
		end

		pcall(function()
			humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
			humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
		end)

		treadmillDecoy.Parent = workspace
		treadmillDecoy:PivotTo(CFrame.new(vector2))
		arg.treadmillDecoy = treadmillDecoy
		local playerGui = localPlayer2:FindFirstChildOfClass("PlayerGui")

		if playerGui then
			for i, descendant in ipairs(playerGui:GetDescendants()) do
				if descendant.Name == "SpeedGainPopup" then
					fn89(descendant)
				elseif descendant.Name == "PlusOne" then
					fn89(descendant)
				end
			end

			arg.treadmillPopupConnection = playerGui.DescendantAdded:Connect(function(descendant)
				if arg.treadmillDecoy == treadmillDecoy then
					fn89(descendant)
				end
			end)
		end

		local treadmillDecoyRealTransparency = setmetatable({}, {__mode = "k"})

		local function fn90(arg2)
			if arg2 then
				if arg2:IsA("BasePart") then
					if not arg2:IsDescendantOf(character) then
						return
					end
				else
					return
				end
			else
				return
			end

			if treadmillDecoyRealTransparency[arg2] == nil then
				treadmillDecoyRealTransparency[arg2] = arg2.LocalTransparencyModifier
			end

			arg2.LocalTransparencyModifier = 1
		end

		for i, descendant in ipairs(character:GetDescendants()) do
			fn90(descendant)
			fn88(descendant)
		end

		arg.treadmillDecoyRealTransparency = treadmillDecoyRealTransparency

		arg.treadmillDecoyCharacterConnection = character.DescendantAdded:Connect(function(descendant)
			if arg.treadmillDecoy == treadmillDecoy then
				pcall(fn90, descendant)
				fn88(descendant)
			end
		end)

		local currentCamera = workspace.CurrentCamera

		if currentCamera then
			arg.treadmillDecoyCamera = currentCamera.CameraSubject
			currentCamera.CameraSubject = humanoid
		end

		arg.treadmillDecoyCameraConnection = RunService2.RenderStepped:Connect(function()
			if arg.treadmillDecoy ~= treadmillDecoy then
				return
			elseif treadmillDecoy.Parent then
				if not humanoid.Parent then
					return
				end
			else
				return
			end

			for k in pairs(treadmillDecoyRealTransparency) do
				if k.Parent and k.LocalTransparencyModifier ~= 1 then
					k.LocalTransparencyModifier = 1
				end
			end

			local currentCamera2 = workspace.CurrentCamera

			if currentCamera2 and currentCamera2.CameraSubject ~= humanoid then
				currentCamera2.CameraSubject = humanoid
			end
		end)

		return true
	end

	index._hideTreadmillDecoy = function(arg, arg2)
		if arg._recalling and not arg2 then
			return
		end

		if arg.treadmillDecoyCameraConnection then
			pcall(arg.treadmillDecoyCameraConnection.Disconnect, arg.treadmillDecoyCameraConnection)
			arg.treadmillDecoyCameraConnection = nil
		end

		if arg.treadmillDecoyCharacterConnection then
			pcall(arg.treadmillDecoyCharacterConnection.Disconnect, arg.treadmillDecoyCharacterConnection)
			arg.treadmillDecoyCharacterConnection = nil
		end

		if arg.treadmillPopupConnection then
			pcall(arg.treadmillPopupConnection.Disconnect, arg.treadmillPopupConnection)
			arg.treadmillPopupConnection = nil
		end

		for k, v8 in pairs(arg.treadmillDecoyRealTransparency or {}) do
			if typeof(k) == "Instance" and k.Parent then
				pcall(function()
					k.LocalTransparencyModifier = v8
				end)
			end
		end

		arg.treadmillDecoyRealTransparency = nil
		local character = localPlayer2.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		local currentCamera = workspace.CurrentCamera

		if currentCamera then
			pcall(function()
				currentCamera.CameraSubject = humanoid or arg.treadmillDecoyCamera
			end)
		end

		arg.treadmillDecoyCamera = nil

		if arg.treadmillDecoy then
			pcall(arg.treadmillDecoy.Destroy, arg.treadmillDecoy)
		end

		arg.treadmillDecoy = nil
	end

	index._restoreTreadmillVisualAtSafe = function(arg)
		if not arg.treadmillDecoy then
			arg:_hideTreadmillDecoy()
			return true
		end
		local character = localPlayer2.Character
		local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		local v8 = arg:_resolveSafeCFrame(humanoidRootPart)

		if humanoidRootPart then
			if humanoid then
				if not v8 then
					arg:_hideTreadmillDecoy()
					return false
				end
			else
				arg:_hideTreadmillDecoy()
				return false
			end
		else
			arg:_hideTreadmillDecoy()
			return false
		end

		local n58, v9 = os.clock() + n33
		local n59 = 0

		while true do
			local destroyed = arg.destroyed
			if not (if destroyed then not destroyed else os.clock() < n58) then
				break
			end
			local now = os.clock()

			if arg:_isInSafeArea(humanoidRootPart) then
				v9 = v9 or now
				if now - v9 >= n32 then
					arg:_hideTreadmillDecoy()
					return true
				end
			else
				v9 = nil

				if now >= n59 then
					n59 = now + n34
					arg:_teleportRoot(humanoidRootPart, humanoid, v8)
				end
			end

			task.wait(0.03)
		end

		arg:_hideTreadmillDecoy()
		return false
	end

	index._prepareTreadmillLaunch = function(arg, arg2, arg3)
		local treadmillManager = arg.treadmillManager

		if treadmillManager then
			if type(treadmillManager.pulseForCarry) ~= "function" then
				return false, "Preparation unavailable"
			end
		else
			return false, "Preparation unavailable"
		end

		local uid = arg2 and arg2.Uid

		local function fn90()
			return uid and (EggState2.ReadFieldEgg(uid) or arg.records[uid]) or nil
		end

		local function fn91()
			local v8 = fn90()
			return arg.destroyed or not arg.enabled or arg.planGeneration ~= arg3 or not arg:_wallOpen() or type(v8) ~= "table" or not arg:_matches(v8)
		end

		local function fn92(arg4)
			local character = localPlayer2.Character
			return arg:_teleportRoot(character and character:FindFirstChild("HumanoidRootPart"), character and character:FindFirstChildOfClass("Humanoid"), arg4)
		end

		arg:_setStatus("Preparing carry")
		if not arg:_showTreadmillDecoy() then
			return false, "Safe-zone visual unavailable"
		end
		local v8, v9 = treadmillManager:pulseForCarry(fn92, fn91)
		if not v8 then
			arg:_restoreTreadmillVisualAtSafe()
			return false, v9
		end
		arg:_setStatus("Positioning at safe area")
		if not arg:_restoreTreadmillVisualAtSafe() then
			return false, "Safe teleport failed"
		end

		if fn91() then
			return false, "Target changed before travel"
		end
		return true, (fn90())
	end

	index._resolveEggDestination = function(arg, arg2, arg3, arg4)
		if type(arg2) ~= "table" then
			return nil
		elseif typeof(arg2.BottomCFrame) ~= "CFrame" then
			return nil
		end

		local character = localPlayer2.Character
		arg3, arg4 = arg3 or character and character:FindFirstChild("HumanoidRootPart"), arg4 or character and character:FindFirstChildOfClass("Humanoid")

		if arg3 then
			if not arg4 then
				return nil
			end
		else
			return nil
		end

		local n58 = arg:_feetOffset(arg3, arg4) + n17
		return CFrame.new(arg2.BottomCFrame.Position + Vector3.new(0, n58, 0))
	end

	local n58 = 110
	local n59 = 30
	local n60 = 900
	local n61 = 120
	local n62 = 18
	local n63 = -426
	local n64 = -308

	local function fn90()
		local ok, result = pcall(function()
			local v8 = fn()
			return v8 and v8:FindFirstChild("Areas") and v8.Areas:FindFirstChild("EggCarryBounds")
		end)

		if ok and result then
			local gameplay1 = result:FindFirstChild("Gameplay1")

			if gameplay1 and gameplay1:IsA("BasePart") then
				local n65 = gameplay1.Size.Z * 0.5 - n62
				if n65 > 5 then
					return gameplay1.Position.Z - n65, gameplay1.Position.Z + n65
				end
			end
		end

		return n63, n64
	end

	index._resolveRouteCruiseY = function(arg, arg2, arg3)
		if arg.config.stealMode ~= "Fly" then
			return nil
		end

		if arg2 then
			if typeof(arg3) ~= "CFrame" then
				return nil
			end
		else
			return nil
		end

		if arg3.Position.Y >= n58 - 6 then
			return nil
		end
		return n58
	end

	index._resolveElevatedDestination = function(arg, arg2, arg3)
		if arg2 then
			if typeof(arg3) ~= "CFrame" then
				return nil
			end
		else
			return nil
		end

		return arg3
	end

	index._teleportRoot = function(arg, arg2, arg3, cFrame)
		if not arg2 or not arg3 then
			return false
		elseif typeof(cFrame) ~= "CFrame" then
			return false
		end

		if not pcall(function()
			arg2.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
			arg2.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
			arg2.CFrame = cFrame
			arg2.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
			arg2.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
		end) then
			return false
		end

		local n65 = math.clamp(arg.config.speed or n15, n13, fn61())
		fn74(localPlayer2.Character, n65 * n44)

		if not fn83(arg3, arg2, n65, (Vector3.new(0, 0, 0))) then
			fn82(arg3, arg2, n65)
			fn83(arg3, arg2, n65, (Vector3.new(0, 0, 0)))
		end

		return true
	end

	index._legitWalkSpeed = function(arg)
		local walkSpeed

		pcall(function()
			local humanoid = localPlayer2.Character and localPlayer2.Character:FindFirstChildOfClass("Humanoid")
			walkSpeed = humanoid and humanoid.WalkSpeed
		end)

		if type(walkSpeed) == "number" and (walkSpeed >= 1 and walkSpeed <= 400) then
			arg._legitWsCache = walkSpeed
		end

		return arg._legitWsCache or type(walkSpeed) == "number" and math.clamp(walkSpeed, 1, 400) or 16
	end

	index._activeGlideSpeed = function(arg)
		if arg.config.stealMode == "Fly" and arg._flyDeparting then
			return arg:_legitWalkSpeed()
		end
		return n24
	end

	index._glideRoot = function(arg, cFrame, arg2, arg3)
		if typeof(cFrame) ~= "CFrame" then
			return false
		end
		local v8 = arg3 or arg:_activeGlideSpeed()
		local character = localPlayer2.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
		if not humanoidRootPart or not humanoid then
			return false
		end
		pcall(fn67, character)

		pcall(function()
			humanoid.AutoRotate = false
		end)

		arg:_startHoverPad()
		local position = cFrame.Position

		local function fn91(arg4, arg5, arg6)
			local n65 = math.clamp(arg.config.speed or n15, n13, fn61())

			pcall(function()
				fn74(arg4, n65 * n44)
				fn83(arg5, arg6, n65, (Vector3.new(0, 0, 0)))
			end)
		end

		local n65 = os.clock() + math.clamp((position - humanoidRootPart.Position).Magnitude / math.max(v8, 1) * 1.6 + 6, 15, 120)

		while os.clock() < n65 do
			if arg2 and arg2() then
				return false
			end

			if arg.destroyed then
				return false
			elseif not arg.enabled then
				if not arg._externalDeliver then
					return false
				end
			end

			local character2 = localPlayer2.Character
			humanoidRootPart = character2 and character2:FindFirstChild("HumanoidRootPart")
			humanoid = character2 and character2:FindFirstChildOfClass("Humanoid")
			if not humanoidRootPart or not humanoid then
				return false
			end
			local position2 = humanoidRootPart.Position
			local n66 = position - position2
			local magnitude = n66.Magnitude

			if magnitude <= 1 then
				pcall(function()
					humanoidRootPart.CFrame = cFrame
					humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
					humanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
				end)

				arg:_syncHoverPad(position)
				fn91(character2, humanoid, humanoidRootPart)
				return true
			end

			local result = RunService2.Heartbeat:Wait()
			local n67 = math.max(math.min(result, n45), 0.004166666666666667)
			local n68 = math.min(v8 * n67, magnitude)
			local n69 = position2 + n66.Unit * n68

			if n67 >= 0.03333333333333333 then
				local v9 = arg:_groundYAt(n69.X, n69.Z, character2)

				if v9 then
					local n70 = v9 + arg:_feetOffset(humanoidRootPart, humanoid)

					if n69.Y < n70 then
						n69 = Vector3.new(n69.X, n70, n69.Z)
					end
				end
			end

			pcall(function()
				humanoidRootPart.CFrame = CFrame.new(n69, n69 + n66.Unit)
				humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
				humanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
			end)

			arg:_syncHoverPad(n69)
			fn91(character2, humanoid, humanoidRootPart)
		end

		return false
	end

	index.HOP = {studs = 500, gap = 0.15, height = 40, safeWait = 0.8}
	index.RELAY_LAND_OK = 200
	index.RELAY_ROUNDS = 3
	index.EGG_FREE_SLOTS = 5

	index._relaySettle = function(arg)
		if not arg._relaySettle_s then
			local n65 = 0.05

			pcall(function()
				n65 = localPlayer2:GetNetworkPing() or 0.05
			end)

			arg._relaySettle_s = math.clamp(0.5 + n65 * 4, index.HOP.safeWait, 2)
			arg._relayGood = 0
		end

		return arg._relaySettle_s
	end

	index._noteRelayLanding = function(arg, arg2)
		local v8 = arg:_relaySettle()

		if arg2 > index.RELAY_LAND_OK then
			arg._relaySettle_s = math.min(v8 + 0.2, 2)
			arg._relayGood = 0
		else
			arg._relayGood = (arg._relayGood or 0) + 1

			if arg._relayGood >= 5 then
				arg._relayGood = 0
				arg._relaySettle_s = math.max(v8 - 0.05, index.HOP.safeWait)
			end
		end
	end

	index._hopRoot = function(arg, arg2, arg3)
		if typeof(arg2) ~= "CFrame" then
			return false
		end
		local hop = index.HOP
		local character = localPlayer2.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
		if not humanoidRootPart or not humanoid then
			return false
		end
		pcall(fn67, character)

		pcall(function()
			humanoid.AutoRotate = false
		end)

		arg:_startHoverPad()
		local position = arg2.Position
		local n65 = position.Y + hop.height

		local function fn91()
			if arg3 and arg3() then
				return false
			end

			if arg.destroyed then
				return false
			elseif not arg.enabled then
				if not arg._externalDeliver then
					return false
				end
			end

			character = localPlayer2.Character
			humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
			humanoid = character and character:FindFirstChildOfClass("Humanoid")
			return humanoidRootPart ~= nil and humanoid ~= nil and humanoid.Health > 0
		end

		local function fn92(cFrame)
			pcall(function()
				humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
				humanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
				humanoidRootPart.CFrame = cFrame
				humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
				humanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
			end)

			arg:_syncHoverPad(cFrame.Position)
			local n66 = math.clamp(arg.config.speed or n15, n13, fn61())

			pcall(function()
				fn74(character, n66 * n44)
				fn83(humanoid, humanoidRootPart, n66, (Vector3.new(0, 0, 0)))
			end)
		end

		local n66 = os.clock() + 20

		while os.clock() < n66 do
			if not fn91() then
				return false
			end
			local position2 = humanoidRootPart.Position
			local vector3 = Vector3.new(position.X - position2.X, 0, position.Z - position2.Z)
			if vector3.Magnitude <= hop.studs then
				fn92(arg2)
				return true
			end
			local n67 = Vector3.new(position2.X, n65, position2.Z) + vector3.Unit * hop.studs
			local cframe2 = CFrame.new(n67, n67 + vector3.Unit)
			fn92(cframe2)
			local n68 = os.clock() + hop.gap

			while os.clock() < n68 do
				RunService2.Heartbeat:Wait()
				if not fn91() then
					return false
				end
				fn92(cframe2)
			end
		end

		return false
	end

	local n65 = 420
	local n66 = 20
	local n67 = 0.5

	index._walkBrakeDecel = function(arg)
		if arg._brakeDecel then
			return arg._brakeDecel
		end
		local senaV4BrakeDecel = genv.__SenaV4BrakeDecel
		local humanoid = localPlayer2.Character and localPlayer2.Character:FindFirstChildOfClass("Humanoid")
		if type(senaV4BrakeDecel) == "table" and (humanoid and math.abs((senaV4BrakeDecel.ws or 0) - humanoid.WalkSpeed) < 15) then
			arg._brakeDecel = senaV4BrakeDecel.decel
			return senaV4BrakeDecel.decel
		end
		return n65
	end

	index._walkLeg = function(arg, arg2, arg3, arg4, arg5, arg6, arg7)
		local function fn91(arg8, arg9)
			if arg8 and arg9 then
				pcall(function()
					arg8:MoveTo(arg9.Position)
				end)
			end

			return false
		end

		local unit, v8, v9

		while os.clock() < arg6 do
			local character = localPlayer2.Character
			local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
			local humanoid = character and character:FindFirstChildOfClass("Humanoid")

			if humanoidRootPart then
				if not humanoid then
					return false
				end
			else
				return false
			end

			if arg3 and arg3() then
				return (fn91(humanoid, humanoidRootPart))
			end

			if arg.destroyed then
				return (fn91(humanoid, humanoidRootPart))
			elseif not arg.enabled then
				if not arg._externalDeliver then
					return (fn91(humanoid, humanoidRootPart))
				end
			end

			local position = humanoidRootPart.Position
			local vector3 = Vector3.new(arg2.X - position.X, 0, arg2.Z - position.Z)
			local magnitude = vector3.Magnitude
			local assemblyLinearVelocity = humanoidRootPart.AssemblyLinearVelocity
			local magnitude2 = Vector3.new(assemblyLinearVelocity.X, 0, assemblyLinearVelocity.Z).Magnitude

			if arg5 then
				if magnitude <= arg4 and magnitude2 <= n66 then
					pcall(function()
						humanoid:MoveTo(position)
					end)

					return true
				end
			else
				unit = unit or (magnitude > 0.001 and vector3.Unit or Vector3.new(0, 0, 0))

				if magnitude <= arg4 then
					return true
				elseif vector3:Dot(unit) <= 0 then
					return true
				end
			end

			local vector4
			local n68 = magnitude > 0.001 and math.max(assemblyLinearVelocity.X * vector3.X + assemblyLinearVelocity.Z * vector3.Z, 0) / magnitude or magnitude2

			if arg5 and magnitude <= n68 * n68 / (2 * arg:_walkBrakeDecel()) + n68 * 0.06 then
				vector4 = position
				local now = os.clock()

				if v8 and (now > v9 and magnitude2 > n66) then
					local n69 = (v8 - magnitude2) / (now - v9)

					if n69 > 20 and n69 < 5000 then
						arg._brakeDecel = arg:_walkBrakeDecel() * 0.8 + n69 * 0.93 * 0.2
						genv.__SenaV4BrakeDecel = {ws = humanoid.WalkSpeed, decel = arg._brakeDecel}
					end
				end

				v8 = magnitude2
				v9 = now
			else
				v8 = nil
				local n69 = math.max(humanoid.WalkSpeed * n67, 12)

				if arg5 and magnitude <= n69 then
					vector4 = Vector3.new(arg2.X, position.Y, arg2.Z)
				else
					vector4 = position + vector3.Unit * n69
				end
			end

			pcall(function()
				humanoid:MoveTo(vector4)
			end)

			if arg7 then
				arg7()
			end

			RunService2.Heartbeat:Wait()
		end

		local character = localPlayer2.Character
		return (fn91(character and character:FindFirstChildOfClass("Humanoid"), character and character:FindFirstChild("HumanoidRootPart")))
	end

	index._walkTo = function(arg, arg2, arg3, arg4)
		if typeof(arg2) ~= "CFrame" then
			return false
		end
		local n68 = arg4 or 8
		local character = localPlayer2.Character
		local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")

		if humanoidRootPart then
			if not humanoid then
				return false
			end
		else
			return false
		end

		pcall(function()
			humanoid.AutoRotate = true
		end)

		local position = arg2.Position
		local walkSpeed = humanoid.WalkSpeed
		local v8 = if walkSpeed then if walkSpeed < 1 then 16 else walkSpeed else 16
		local magnitude = Vector3.new(position.X - humanoidRootPart.Position.X, 0, position.Z - humanoidRootPart.Position.Z).Magnitude
		return arg:_walkLeg(position, arg3, n68, true, os.clock() + math.clamp(magnitude / v8 * 2 + 8, 12, 90))
	end

	index._walkToZigzag = function(arg, arg2, arg3, arg4)
		if typeof(arg2) ~= "CFrame" then
			return false
		end
		local n68 = arg4 or 8
		local n69 = 60
		local n70 = 38
		local n71 = 10
		local character = localPlayer2.Character
		local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")

		if humanoidRootPart then
			if not humanoid then
				return false
			end
		else
			return false
		end

		pcall(function()
			humanoid.AutoRotate = true
		end)

		local position = arg2.Position
		local walkSpeed = humanoid.WalkSpeed
		local v8 = if walkSpeed then if walkSpeed < 1 then 16 else walkSpeed else 16
		local magnitude = Vector3.new(position.X - humanoidRootPart.Position.X, 0, position.Z - humanoidRootPart.Position.Z).Magnitude
		local n72 = math.max(45, v8 * v8 / (2 * arg:_walkBrakeDecel()) * 1.25)
		local n73, v9, v10 = os.clock() + math.clamp(magnitude / v8 * 3 + 10, 14, 120)

		local ok, result, result2 = pcall(function()
			return fn90()
		end)

		if ok and (type(result) == "number" and type(result2) == "number") then
			local n74 = math.min(result, result2)
			local n75 = math.max(result, result2)
			v9 = n74
			v10 = n75
		end

		result2 = math.random() < 0.5 and -1 or 1

		while os.clock() < n73 do
			if arg3 and arg3() then
				return false
			end

			if arg.destroyed then
				return false
			elseif not arg.enabled then
				return false
			end

			local character2 = localPlayer2.Character
			humanoidRootPart, humanoid = character2 and character2:FindFirstChild("HumanoidRootPart"), character2 and character2:FindFirstChildOfClass("Humanoid")

			if humanoidRootPart then
				if not humanoid then
					return false
				end
			else
				return false
			end

			local position2 = humanoidRootPart.Position
			local vector3 = Vector3.new(position.X - position2.X, 0, position.Z - position2.Z)
			local magnitude2 = vector3.Magnitude
			if magnitude2 <= n72 then
				return arg:_walkLeg(position, arg3, n68, true, n73)
			end
			local unit = vector3.Unit
			local vector4 = Vector3.new(-unit.Z, 0, unit.X)
			local n74 = math.max(magnitude2 - n72 * 0.5, 4)
			local n75 = math.min(n69 + math.random() * 40, n74)
			local n76 = result2 * math.min(n70, n75 * 0.4) * (0.6 + math.random() * 0.4)
			result2 = -result2
			local n77 = position2 + unit * n75 + vector4 * n76
			n75 = n77.Z
			local v11 = if v9 then if v10 then math.clamp(n75, v9 + 2, v10 - 2) else n75 else n75
			if not arg:_walkLeg(Vector3.new(n77.X, position2.Y, v11), arg3, n71, false, n73) then
				return false
			end
		end

		return false
	end

	index._flyWalkTo = function(arg, arg2, arg3, arg4, arg5)
		if typeof(arg2) ~= "CFrame" then
			return false
		end
		local n68 = arg4 or 8
		local hoverPadHeightOverride = tonumber(arg5) or 110
		local character = localPlayer2.Character
		local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		if not humanoidRootPart or not humanoid then
			return false
		end

		pcall(function()
			humanoid.AutoRotate = true
		end)

		local function fn91()
			pcall(function()
				local humanoid2 = localPlayer2.Character and localPlayer2.Character:FindFirstChildOfClass("Humanoid")
				local animator = humanoid2 and humanoid2:FindFirstChildWhichIsA("Animator")

				if animator then
					for i, v8 in ipairs(animator:GetPlayingAnimationTracks()) do
						v8:Stop(0)
					end
				end
			end)
		end

		local function fn92(disabled)
			local character2 = localPlayer2.Character
			local animate = character2 and character2:FindFirstChild("Animate")

			if animate then
				pcall(function()
					animate.Disabled = disabled
				end)
			end
		end

		fn92(true)
		fn91()
		local position = arg2.Position
		arg.hoverPadHeightOverride = hoverPadHeightOverride
		arg:_startHoverPad()

		pcall(function()
			humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.Position.X, hoverPadHeightOverride, humanoidRootPart.Position.Z) * humanoidRootPart.CFrame.Rotation
			humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
			humanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
		end)

		arg:_syncHoverPad()
		local walkSpeed = humanoid.WalkSpeed
		local v8 = if walkSpeed then if walkSpeed < 1 then 16 else walkSpeed else 16
		local magnitude = Vector3.new(position.X - humanoidRootPart.Position.X, 0, position.Z - humanoidRootPart.Position.Z).Magnitude
		local v9 = arg:_walkLeg(position, arg3, n68, true, os.clock() + math.clamp(magnitude / v8 * 2 + 10, 12, 120), fn91)
		fn92(false)
		arg.hoverPadHeightOverride = nil
		if not v9 then
			return false
		end

		if arg3 and arg3() then
			return false
		end
		arg:_glideRoot(arg2, arg3, arg:_legitWalkSpeed())
		return not (arg3 and arg3())
	end

	index._isInSafeArea = function(arg, arg2)
		if not arg2 then
			return false
		end
		local n68 = arg2.Position - vector2
		return Vector2.new(n68.X, n68.Z).Magnitude <= n30 and math.abs(n68.Y) <= n31
	end

	index._isInField = function(arg, arg2)
		local v8 = fn()
		local areas = v8 and v8:FindFirstChild("Areas")
		local wallStartCollision = areas and areas:FindFirstChild("WallStartCollision")

		if wallStartCollision then
			if not wallStartCollision:IsA("BasePart") then
				return true
			end
		else
			return true
		end

		return arg2.Position.X >= wallStartCollision.Position.X + 3
	end

	index._needsSafeZoneHop = function(arg, arg2)
		if arg:_isInField(arg2) then
			return false, nil
		elseif arg:_isInSafeArea(arg2) then
			return false, nil
		end

		return true, arg:_resolveSafeCFrame(arg2)
	end

	index._invalidateCarryWorker = function(arg)
		arg.carryWorker = nil
	end

	index._claimCarryWorker = function(arg, arg2, arg3)
		local generation = arg.carry.generation
		local carryWorker = arg.carryWorker
		if carryWorker and carryWorker.generation == generation then
			return nil
		end
		local carryWorker2 = {kind = arg2, uid = arg3, generation = generation, token = {}}
		arg.carryWorker = carryWorker2
		return carryWorker2
	end

	index._isCarryWorkerCurrent = function(arg, arg2)
		return type(arg2) == "table" and arg.carryWorker == arg2 and arg.carry.generation == arg2.generation and not arg.destroyed and (arg.enabled or arg._externalDeliver)
	end

	index._releaseCarryWorker = function(arg, arg2)
		if arg.carryWorker == arg2 then
			arg.carryWorker = nil
		end
	end

	index.ownsCarryRecovery = function(arg, arg2)
		if arg.destroyed then
			return false
		elseif not arg.enabled then
			return false
		end

		if arg.carry.uid == arg2 then
			return true
		end
		return arg.running and arg.activeTarget ~= nil and (arg2 == nil or arg.activeTarget.Uid == arg2)
	end

	index.requestCarryRecovery = function(arg, arg2)
		if arg.destroyed then
			return false
		elseif arg.enabled then
			if type(arg2) ~= "string" then
				return false
			elseif arg2 == "" then
				return false
			end
		else
			return false
		end

		if arg:isSkippedEgg(arg2) then
			return true
		end

		if arg.tweenRecoveryUid == arg2 then
			arg:_scheduleMovementRetry()
			return true
		end

		if arg.carry.active and arg.carry.uid == arg2 then
			return true
		end
		local v8 = EggState2.ReadFieldEgg(arg2) or arg.records[arg2]

		if type(v8) ~= "table" then
			return false
		elseif v8.State ~= AreaEggs.States.Dropped then
			if v8.State ~= AreaEggs.States.Slot then
				return false
			end
		end

		local carryWorker = arg.carryWorker

		if carryWorker and carryWorker.kind == "re-steal" and carryWorker.uid == arg2 or arg.activeTween and arg.activeTarget and arg.activeTarget.Uid == arg2 then
			return true
		elseif arg.carryAttemptToken then
			if arg.activeTarget and arg.activeTarget.Uid == arg2 then
				return true
			end
		end

		arg.carry.generation += 1
		arg:_invalidateCarryWorker()
		arg.carryAttemptToken = nil
		arg.running = true
		arg.activeTarget = v8

		task.defer(function()
			if not arg.destroyed and (arg.enabled and not arg.carry.active) then
				arg:_reStealDroppedEgg(arg2)
			end
		end)

		return true
	end

	index._hasConfirmedCarry = function(arg, arg2)
		if not arg.carry.active then
			return false
		end

		if arg2 == nil then
			return true
		elseif arg.carry.uid == nil then
			return true
		end

		return arg.carry.uid == arg2
	end

	index._adoptCarryFromRecord = function(arg, uid)
		if arg.carry.active and arg.carry.uid == uid then
			return
		end

		if arg.carryTimeouts then
			arg.carryTimeouts[uid] = nil
		end

		if arg.instantPhase == "priming" and uid == arg.primerUid then
			arg.carry.active = true
			arg.carry.uid = uid
			return
		end

		arg.carry.generation += 1
		arg:_invalidateCarryWorker()
		arg:_clearArrivalHold(uid)
		local activeTarget = arg.activeTarget
		arg.claimPresentationSuppression = {assetCategory = activeTarget and activeTarget.AssetCategory, expiresAt = os.clock() + 8}
		arg.carry.active = true
		arg.carry.uid = uid
		arg.carryStartTime = os.clock()
		local humanoidRootPart = localPlayer2.Character and localPlayer2.Character:FindFirstChild("HumanoidRootPart")
		arg.carryStartPos = activeTarget and activeTarget.BottomCFrame and activeTarget.BottomCFrame.Position or humanoidRootPart and humanoidRootPart.Position

		if arg.tweenRecoveryUid == uid then
			arg.tweenRecoveryUid = nil
		end

		arg.stats.lastResult = "Carry confirmed"
		arg:_notify()
	end

	index._recordShowsCarried = function(arg, arg2)
		if type(arg2) ~= "string" then
			return false
		elseif arg2 == "" then
			return false
		end

		local v8 = EggState2.ReadFieldEgg(arg2) or arg.records[arg2]
		return type(v8) == "table" and v8.State == AreaEggs.States.Carried and v8.CarrierUserId == localPlayer2.UserId
	end

	index._recordShowsForeignCarry = function(arg, arg2)
		if type(arg2) ~= "string" then
			return false
		elseif arg2 == "" then
			return false
		end

		local v8 = EggState2.ReadFieldEgg(arg2) or arg.records[arg2]
		return type(v8) == "table" and v8.State == AreaEggs.States.Carried and v8.CarrierUserId ~= nil and v8.CarrierUserId ~= localPlayer2.UserId
	end

	index._resolveMovementSpeed = function(arg, arg2)
		if arg2.Parent then
			if arg2.Health <= 0 then
				return nil
			end
		else
			return nil
		end

		return math.clamp(arg.config.speed, n13, fn61())
	end

	index._isAreaSafe = function(arg, arg2)
		return true
	end

	index._feetOffset = function(arg, arg2, arg3)
		if arg3.RigType == Enum.HumanoidRigType.R15 then
			return arg2.Size.Y * 0.5 + math.max(arg3.HipHeight, 0.5)
		end
		return arg2.Size.Y * 0.5 + 2
	end

	index.setAntiTrap = function(arg, arg2)
		arg.config.antiTrap = arg2 == true

		if arg.config.antiTrap then
			arg:_purgeTraps()
		end
	end

	index._isForeignTrap = function(arg, arg2)
		if arg2.Name == str7 and arg2:IsA("BasePart") then
			local attribute = arg2:GetAttribute("Owner")
			return type(attribute) ~= "string" or attribute ~= localPlayer2.Name
		end
		return arg2:IsA("Model") and arg2.Name == str8 and arg2:FindFirstChild("Hitbox") ~= nil
	end

	index._purgeTrap = function(arg, arg2)
		if arg.config.antiTrap then
			if arg2 then
				if not arg2.Parent then
					return
				end
			else
				return
			end
		else
			return
		end

		if arg:_isForeignTrap(arg2) then
			pcall(arg2.Destroy, arg2)
		end
	end

	index._purgeTraps = function(arg)
		for i, v8 in ipairs({"Transient", "__DEBRIS"}) do
			local v9 = workspace:FindFirstChild(v8)

			if v9 then
				for i2, descendant in ipairs(v9:GetDescendants()) do
					arg:_purgeTrap(descendant)
				end
			end
		end
	end

	index._syncHoverPad = function(arg, arg2)
		local hoverPad = arg.hoverPad

		if hoverPad then
			if hoverPad.Parent then
				if hoverPad:GetAttribute(str6) ~= arg.hoverPadOwnerId then
					return false
				end
			else
				return false
			end
		else
			return false
		end

		local character = localPlayer2.Character
		local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")

		if humanoidRootPart then
			if not humanoid then
				return false
			end
		else
			return false
		end

		local position = typeof(arg2) == "Vector3" and arg2 or humanoidRootPart.Position
		local y = position.Y
		local v8 = if arg.hoverPadHeightOverride ~= nil then if typeof(arg2) ~= "Vector3" then arg.hoverPadHeightOverride else y else y
		local v9 = if arg.hoverPadHeightOverride ~= nil then math.max(n18, humanoid.WalkSpeed * 2 / 15) else n18

		if math.abs(hoverPad.Size.X - v9) > 0.5 then
			hoverPad.Size = Vector3.new(v9, n19, v9)
		end

		hoverPad.CFrame = CFrame.new(position.X, v8 - arg:_feetOffset(humanoidRootPart, humanoid) - n19 * 0.5 - 0.05, position.Z)
		return true
	end

	index._setArrivalHold = function(arg, arg2, arg3)
		if typeof(arg2) ~= "CFrame" then
			return
		end
		local character = localPlayer2.Character
		local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

		if character then
			if not humanoidRootPart then
				return
			end
		else
			return
		end

		arg.arrivalHold = {Character = character, RootPart = humanoidRootPart, CFrame = arg2, Uid = arg3}
	end

	index._clearArrivalHold = function(arg, arg2)
		local arrivalHold = arg.arrivalHold

		if arrivalHold then
			if arg2 == nil then
				arg.arrivalHold = nil
			elseif arrivalHold.Uid == nil then
				arg.arrivalHold = nil
			elseif arrivalHold.Uid == arg2 then
				arg.arrivalHold = nil
			end
		else
			arg.arrivalHold = nil
		end
	end

	index._enforceArrivalHold = function(arg)
		local arrivalHold = arg.arrivalHold

		if type(arrivalHold) ~= "table" then
			return false
		elseif typeof(arrivalHold.CFrame) ~= "CFrame" then
			return false
		end

		if localPlayer2.Character ~= arrivalHold.Character then
			arg.arrivalHold = nil
			return false
		elseif arrivalHold.RootPart then
			if not arrivalHold.RootPart.Parent then
				arg.arrivalHold = nil
				return false
			end
		else
			arg.arrivalHold = nil
			return false
		end

		arg:_startHoverPad()

		pcall(function()
			arrivalHold.RootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
			arrivalHold.RootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
			arg:_syncHoverPad(arrivalHold.CFrame.Position)
			arrivalHold.RootPart.CFrame = arrivalHold.CFrame
		end)

		arg:_syncHoverPad(arrivalHold.CFrame.Position)
		return true
	end

	index._purgeOrphanHoverPads = function(arg)
		for i, child in ipairs(workspace:GetChildren()) do
			if child.Name == name2 and child ~= arg.hoverPad then
				pcall(child.Destroy, child)
			end
		end
	end

	index._startHoverPad = function(arg)
		local hoverPad = arg.hoverPad

		if (if hoverPad then not hoverPad.Parent else not hoverPad) or hoverPad:GetAttribute(str6) ~= arg.hoverPadOwnerId then
			arg:_purgeOrphanHoverPads()

			if hoverPad and hoverPad.Parent then
				pcall(hoverPad.Destroy, hoverPad)
			end

			local part = Instance.new("Part")
			part.Name = name2
			part:SetAttribute(str6, arg.hoverPadOwnerId)
			part.Anchored = true
			part.CanCollide = true
			part.CanQuery = true
			part.CanTouch = false
			part.CastShadow = false
			part.Transparency = 1
			part.Material = Enum.Material.SmoothPlastic
			part.Size = Vector3.new(n18, n19, n18)
			arg.hoverPad = part
			part.Parent = workspace
		end

		arg:_syncHoverPad()

		if not arg.hoverPadConnection then
			arg.hoverPadConnection = RunService2.PreSimulation:Connect(function()
				if not arg:_syncHoverPad() then
					arg:_startHoverPad()
				end
			end)
		end

		if not arg.hoverPadPostConnection then
			arg.hoverPadPostConnection = RunService2.PostSimulation:Connect(function()
				if arg.activeTween then
					arg:_syncHoverPad()
				elseif arg.arrivalHold then
					arg:_syncHoverPad()
				end
			end)
		end
	end

	index._stopHoverPad = function(arg)
		arg.hoverPadHeightOverride = nil

		if arg.hoverPadConnection then
			pcall(arg.hoverPadConnection.Disconnect, arg.hoverPadConnection)
			arg.hoverPadConnection = nil
		end

		if arg.hoverPadPostConnection then
			pcall(arg.hoverPadPostConnection.Disconnect, arg.hoverPadPostConnection)
			arg.hoverPadPostConnection = nil
		end

		if arg.hoverPad then
			pcall(arg.hoverPad.Destroy, arg.hoverPad)
			arg.hoverPad = nil
		end

		arg:_purgeOrphanHoverPads()
	end

	index._startMovementProtection = function(arg)
		local character = localPlayer2.Character
		local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")

		if character then
			if humanoidRootPart then
				if not humanoid then
					return false
				end
			else
				return false
			end
		else
			return false
		end

		local n68 = math.clamp(arg.config.speed or n15, n13, fn61())
		arg.protectionCharacter = character
		arg.protectionHumanoid = humanoid
		arg.protectionRoot = humanoidRootPart
		fn74(character, n68 * n44)
		fn82(humanoid, humanoidRootPart, n68)

		if not arg.integritySpoofConnection then
			arg.integritySpoofConnection = RunService2.PreSimulation:Connect(function()
				local character2 = localPlayer2.Character
				local humanoidRootPart2 = character2 and character2:FindFirstChild("HumanoidRootPart")
				local humanoid2 = character2 and character2:FindFirstChildOfClass("Humanoid")

				if character2 then
					if humanoidRootPart2 then
						if not humanoid2 then
							return
						end
					else
						return
					end
				else
					return
				end

				local n69 = math.clamp(arg.config.speed or n15, n13, fn61())
				arg.protectionCharacter = character2
				arg.protectionHumanoid = humanoid2
				arg.protectionRoot = humanoidRootPart2
				fn74(character2, n69 * n44)

				if not fn83(humanoid2, humanoidRootPart2, n69) then
					fn82(humanoid2, humanoidRootPart2, n69)
				end

				arg:_enforceArrivalHold()
			end)
		end

		if not arg.arrivalHoldConnection then
			arg.arrivalHoldConnection = RunService2.Heartbeat:Connect(function()
				arg:_enforceArrivalHold()
			end)
		end

		return true
	end

	index._startFlyGrounding = function(arg)
		arg:_stopFlyGrounding()
		local v8 = fn79()

		arg._flyGroundConn = RunService2.PreSimulation:Connect(function()
			if arg.destroyed then
				return
			end
			local state = v8 and v8.State

			if type(state) ~= "table" then
				return
			elseif rawget(state, "CorrectionContext") ~= nil then
				return
			end

			rawset(state, "IsSupportedNow", true)
			rawset(state, "UnsupportedStartedAt", nil)

			if rawget(state, "MovementMode") ~= "Correcting" then
				rawset(state, "MovementMode", "Grounded")
			end

			local value = rawget(state, "Evidence")

			if type(value) == "table" then
				value.Flight = 0
				value.Teleport = 0
				value.Speed = 0
			end
		end)
	end

	index._stopFlyGrounding = function(arg)
		if arg._flyGroundConn then
			pcall(arg._flyGroundConn.Disconnect, arg._flyGroundConn)
			arg._flyGroundConn = nil
		end
	end

	index._stopMovementProtection = function(arg)
		arg:_stopFlyGrounding()

		if arg.integritySpoofConnection then
			pcall(arg.integritySpoofConnection.Disconnect, arg.integritySpoofConnection)
			arg.integritySpoofConnection = nil
		end

		if arg.arrivalHoldConnection then
			pcall(arg.arrivalHoldConnection.Disconnect, arg.arrivalHoldConnection)
			arg.arrivalHoldConnection = nil
		end

		arg:_clearArrivalHold()
		arg:_stopHoverPad()
		fn75()
		fn84(arg.protectionHumanoid)
		arg.protectionCharacter = nil
		arg.protectionHumanoid = nil
		arg.protectionRoot = nil
	end

	index.travelAndWait = function(arg, arg2, arg3)
		local tbl16 = arg3 or {}
		if arg.destroyed then
			return false
		end

		if arg.travelBusy and os.clock() < (arg.travelBusyUntil or 0) then
			return false
		end
		local flag5, ok = arg.activeTween and not arg.running

		if flag5 then
			local sharedTravel = arg.activeTween.sharedTravel
			ok = if sharedTravel then tbl16.preempt == true else not sharedTravel
		else
			ok = flag5
		end

		if ok then
			pcall(arg.activeTween.Cancel, arg.activeTween)
			flag5 = os.clock() + 0.5

			while arg.activeTween and os.clock() < flag5 do
				task.wait(0.05)
			end
		end

		if arg.activeTween then
			return false
		end
		local character = localPlayer2.Character
		local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
		if not humanoidRootPart then
			return false
		end
		arg.travelBusy = true
		arg.travelBusyUntil = os.clock() + 45

		ok, flag5 = pcall(function()
			local flag6
			local now = os.clock()
			local magnitude = (arg2.Position - humanoidRootPart.Position).Magnitude
			local n68 = now + magnitude / math.max(tonumber(tbl16.speed) or arg.config.speed or n15, n13) + 6
			arg.travelBusyUntil = n68 + 2
			local speed2 = tbl16.speed

			local tbl17 = {silent = true, sharedTravel = true, abort = function()
				return arg.destroyed or tbl16.abort ~= nil and tbl16.abort()
			end}

			tbl17.onDone = function(arg4)
				flag6 = arg4 == true
			end

			arg:_tweenRoot(arg2, nil, speed2, tbl17)
			speed2 = now

			while true do
				if not (flag6 == nil) then
					break
				end
				local now2 = os.clock()
				local humanoidRootPart2 = localPlayer2.Character and localPlayer2.Character:FindFirstChild("HumanoidRootPart")
				local magnitude2 = humanoidRootPart2 and (arg2.Position - humanoidRootPart2.Position).Magnitude or 1 / 0

				if magnitude2 < magnitude - 0.5 then
					magnitude = magnitude2
					speed2 = now2
				end

				if arg.destroyed or tbl16.abort ~= nil and tbl16.abort() or now2 - speed2 >= 1.5 or now2 >= n68 then
					if arg.activeTween and arg.activeTween.Cancel then
						pcall(arg.activeTween.Cancel)
					end

					flag6 = false
					break
				end

				task.wait(0.05)
			end

			return flag6
		end)

		arg.travelBusy = false

		if not ok then
			if arg.activeTween and (arg.activeTween.sharedTravel and arg.activeTween.Cancel) then
				pcall(arg.activeTween.Cancel)
			end

			return false
		end

		return flag5 == true
	end

	index._tweenRoot = function(arg, arg2, arg3, arg4, arg5)
		arg:_clearArrivalHold()
		local character = localPlayer2.Character
		local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		local tbl16 = arg5 or {}

		if not humanoidRootPart or not humanoid then
			arg.safeStarting = false

			if tbl16.silent then
				if tbl16.onDone then
					pcall(tbl16.onDone, false)
				end

				return
			end

			arg:_finish("Character unavailable")
			return
		end

		local v8 = arg4 or arg:_resolveMovementSpeed(humanoid)

		if not v8 then
			arg.safeStarting = false

			if tbl16.silent then
				if tbl16.onDone then
					pcall(tbl16.onDone, false)
				end

				return
			end

			arg:_finish("Movement unavailable")
			return
		end

		local n68 = math.clamp(v8, n13, fn61())
		arg:_startMovementProtection()
		pcall(fn67, character)
		local currentCamera = workspace.CurrentCamera

		if currentCamera and currentCamera.CameraSubject ~= humanoid then
			pcall(function()
				currentCamera.CameraSubject = humanoid
			end)
		end

		local autoRotate = humanoid.AutoRotate
		humanoid.AutoRotate = false
		local flag5 = tbl16.flightProfile == true and arg:_resolveRouteCruiseY(humanoidRootPart, arg2) or nil
		local activeTween = {sharedTravel = tbl16.sharedTravel == true, routeCruiseY = flag5, travelPhase = flag5 and "takeoff" or nil, zigzag = arg.config.stealMode == "Zig-Zag", zigT = 0, zigLast = 0}
		arg.activeTween = activeTween
		arg:_startHoverPad()
		local flag6, connection6, now, v9 = false
		local n69 = 0

		local function fn91(arg6)
			if flag6 then
				return
			end
			flag6, now = true, nil

			if humanoid.Parent ~= nil then
				humanoid.AutoRotate = autoRotate
			end

			if arg6 and tbl16.holdAfterArrival then
				arg:_setArrivalHold(arg2, tbl16.holdUid)
			end

			if tbl16.onDone then
				pcall(tbl16.onDone, arg6 == true)
			end

			if connection6 then
				connection6:Disconnect()
				connection6 = nil
			end

			if arg.activeTween == activeTween then
				arg.activeTween = nil
			end

			if not arg.arrivalHold then
				arg:_stopHoverPad()
			end

			if not arg.enabled then
				arg:_stopMovementProtection()
			end

			pcall(function()
				if localPlayer2.Character == character and humanoidRootPart.Parent then
					humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
				end
			end)

			if arg6 and (localPlayer2.Character == character and (humanoid.Parent ~= nil and arg3)) then
				arg3()
			end
		end

		activeTween.Cancel = function()
			fn91(false)
		end

		connection6 = RunService2.Heartbeat:Connect(function(deltaTime)
			if tbl16.abort and tbl16.abort() then
				fn91(false)
				return
			end

			if arg.destroyed then
				fn91(false)
				return
			elseif arg.activeTween ~= activeTween then
				fn91(false)
				return
			end

			if tbl16.carryTarget and os.clock() >= (activeTween.nextTargetCheck or 0) then
				activeTween.nextTargetCheck = os.clock() + 0.1
				local uid = tbl16.carryTarget.Uid
				local v10 = EggState2.ReadFieldEgg(uid)
				local state = v10 and v10.State

				if state ~= AreaEggs.States.Slot and (state ~= AreaEggs.States.Dropped and (state ~= "GuardCarried" and (not (v10 and v10.CarrierUserId == localPlayer2.UserId) and not arg:_hasConfirmedCarry(uid)))) then
					fn91(false)
					local senaV4PlayerSteal = genv.__SenaV4PlayerSteal
					arg:_finish(state == "Carried" and senaV4PlayerSteal ~= nil and senaV4PlayerSteal:intercept(uid) and "Target taken - chasing the carrier" or "Target taken by someone else")
					return
				end
			end

			pcall(function()
				local n70 = math.clamp(arg4 or arg.config.speed or n68, n13, fn61())
				fn74(character, n70 * n44)
				local v10 = fn71()[str4]
				local state = type(v10) == "table" and v10.State or nil

				if not fn81(state, humanoid, humanoidRootPart) then
					v9, now = nil, nil
					humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
					humanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
					arg:_syncHoverPad(humanoidRootPart.Position)

					if fn80(state, humanoid, humanoidRootPart) then
						fn78(state, n70 * n44, (Vector3.new(0, 0, 0)))
					else
						fn82(humanoid, humanoidRootPart, n70)
					end

					return
				end

				local position = humanoidRootPart.Position
				local n71 = arg2.Position - position
				local magnitude = n71.Magnitude
				local vector3 = Vector3.new(n71.X, 0, n71.Z)
				local magnitude2 = vector3.Magnitude
				local position2 = arg2.Position

				if activeTween.routeCruiseY then
					if activeTween.travelPhase == "takeoff" then
						if position.Y >= activeTween.routeCruiseY - 0.5 then
							activeTween.travelPhase = "cruise"
						else
							position2 = Vector3.new(position.X, activeTween.routeCruiseY, position.Z)
						end
					end

					if activeTween.travelPhase == "cruise" then
						if magnitude2 <= 4 then
							activeTween.travelPhase = "descend"
						else
							position2 = Vector3.new(arg2.Position.X, activeTween.routeCruiseY, arg2.Position.Z)
						end
					end

					position2 = if activeTween.travelPhase == "descend" then arg2.Position else position2
				end

				local n72 = position2 - position
				local magnitude3 = n72.Magnitude
				local routeCruiseY = activeTween.routeCruiseY and magnitude2 or magnitude
				local carryTarget

				if v9 and routeCruiseY > v9 + n47 then
					n69 = os.clock() + n48
				end

				v9 = routeCruiseY
				routeCruiseY = os.clock() < n69 and math.max(n13, n70 * n49) or n70

				if tbl16.carryTarget and not activeTween.__earlyCarrySpam and magnitude <= 30 then
					activeTween.__earlyCarrySpam = true
					carryTarget = tbl16.carryTarget
					local uid = carryTarget.Uid
					local v11 = AreaEggSlotIdentity.LooksLikeFirstAreaUid(uid) and AreaEggSlotIdentity.SlotKey(carryTarget.AreaId, carryTarget.NestId) or nil

					task.spawn(function()
						while true do
							local destroyed = arg.destroyed
							if not ((if destroyed then not destroyed else arg.enabled) and arg.activeTween == activeTween and not arg:_hasConfirmedCarry(uid)) then
								break
							end
							pcall(fn62, uid, v11)
							task.wait(0.08)
						end
					end)
				end

				local n73 = math.max(math.min(deltaTime, n45), 0.004166666666666667)
				local n74 = routeCruiseY * n73
				local vector4 = Vector3.new(humanoidRootPart.CFrame.LookVector.X, 0, humanoidRootPart.CFrame.LookVector.Z)
				local unit = vector3.Magnitude > 0.001 and vector3.Unit or (vector4.Magnitude > 0.001 and vector4.Unit or Vector3.new(0, 0, -1))
				local routeCruiseY2 = activeTween.routeCruiseY

				if (if routeCruiseY2 then activeTween.travelPhase == "descend" else not routeCruiseY2) and magnitude <= math.max(n74, 0.05) then
					if magnitude > 0.5 then
						now = nil
					end

					arg:_syncHoverPad(arg2.Position)
					humanoidRootPart.CFrame = CFrame.lookAt(arg2.Position, arg2.Position + unit)
					humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
					arg:_syncHoverPad(arg2.Position)
					fn83(humanoid, humanoidRootPart, n70, (Vector3.new(0, 0, 0)))
					now = now or os.clock()

					if os.clock() - now >= n50 then
						fn91(true)
					end

					return
				end

				now = nil

				if magnitude3 <= 0.001 then
					humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
					humanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
					arg:_syncHoverPad(position)
					return
				end

				if arg.hoverPad then
					if not arg.hoverPad.Parent then
						arg:_startHoverPad()
					end
				else
					arg:_startHoverPad()
				end

				local n75 = math.min(n74, magnitude3)
				vector3, routeCruiseY2, routeCruiseY = position + n72.Unit * n75, n73 >= 0.03333333333333333

				if routeCruiseY2 then
					local routeCruiseY3 = activeTween.routeCruiseY
					routeCruiseY = if routeCruiseY3 then activeTween.travelPhase ~= "cruise" else not routeCruiseY3
				else
					routeCruiseY = routeCruiseY2
				end

				if routeCruiseY then
					local v11 = arg:_groundYAt(vector3.X, vector3.Z, character)

					if v11 then
						local n76 = v11 + arg:_feetOffset(humanoidRootPart, humanoid)
						vector3 = if vector3.Y < n76 then Vector3.new(vector3.X, n76, vector3.Z) else vector3
					end
				end

				magnitude, n74 = activeTween.zigzag

				if magnitude then
					local routeCruiseY3 = activeTween.routeCruiseY
					n74 = if routeCruiseY3 then activeTween.travelPhase == "cruise" else not routeCruiseY3
				else
					n74 = magnitude
				end

				if n74 then
					local vector5 = Vector3.new(n72.X, 0, n72.Z)

					if vector5.Magnitude > 1 then
						if magnitude2 > 12 then
							local unit2 = vector5.Unit
							local vector6 = Vector3.new(-unit2.Z, 0, unit2.X)
							magnitude3 = math.min(n59, magnitude2 * 0.3)
							local v11 = if magnitude2 < n61 then magnitude3 * (magnitude2 / n61) else magnitude3
							activeTween.zigT = (activeTween.zigT or 0) + n75
							local zigLast = v11 * math.sin(activeTween.zigT / n60 * 3.141592653589793 * 2)
							local n76 = zigLast - (activeTween.zigLast or 0)
							activeTween.zigLast = zigLast
							local n77 = vector3 + vector6 * n76

							if not activeTween.zigLaneMin then
								activeTween.zigLaneMin, activeTween.zigLaneMax = fn90()
							end

							local n78 = math.clamp(n77.Z, activeTween.zigLaneMin, activeTween.zigLaneMax)
							vector3 = if n78 ~= n77.Z then Vector3.new(n77.X, n77.Y, n78) else n77
						else
							activeTween.zigLast = 0
						end
					else
						activeTween.zigLast = 0
					end
				end

				local n76 = (vector3 - position) / n73
				arg:_syncHoverPad(vector3)
				humanoidRootPart.CFrame = CFrame.lookAt(vector3, vector3 + unit)
				humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
				arg:_syncHoverPad(vector3)

				if not fn83(humanoid, humanoidRootPart, n70, n76) then
					fn82(humanoid, humanoidRootPart, n70)
					fn83(humanoid, humanoidRootPart, n70, n76)
				end
			end)
		end)
	end

	index._reStealDroppedEgg = function(arg, arg2)
		if type(arg2) ~= "string" then
			arg:_finish("Egg lost \226\128\148 retrying")
			return
		elseif arg2 == "" then
			arg:_finish("Egg lost \226\128\148 retrying")
			return
		end

		if arg:isSkippedEgg(arg2) then
			return
		end

		if arg.tweenRecoveryUid == arg2 then
			arg.running = false
			arg.activeTarget = nil
			arg:_releaseOperation()
			arg:_scheduleMovementRetry()
			return
		end

		local v8 = arg:_claimCarryWorker("re-steal", arg2)
		if not v8 then
			return
		end

		if genv.__SenaV4GodMode then
			genv.__SenaV4GodMode:startDefend(arg2)
		end

		local n68 = os.clock() + 5
		arg:_setStatus("Re-stealing dropped egg")
		local v9

		while arg:_isCarryWorkerCurrent(v8) and os.clock() < n68 do
			local v10 = EggState2.ReadFieldEgg(arg2) or arg.records[arg2]

			if v10 then
				if v10.State == AreaEggs.States.Dropped then
					v9 = v10
					break
				elseif v10.State == AreaEggs.States.Slot then
					v9 = v10
					break
				end
			end

			task.wait(0.03)
		end

		if not arg:_isCarryWorkerCurrent(v8) then
			return
		end

		if if v9 then not arg:_wallOpen() else not v9 then
			arg:_releaseCarryWorker(v8)
			arg:_finish("Egg lost \226\128\148 retrying")
			return
		end

		arg:_cancelTween("Re-stealing dropped egg", true)
		local character = localPlayer2.Character
		local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		n68 = arg:_resolveEggDestination(v9, humanoidRootPart, humanoid)
		local v10 = n68 and arg:_resolveElevatedDestination(humanoidRootPart, n68) or nil

		if not v10 then
			arg:_releaseCarryWorker(v8)
			arg:_finish("Character unavailable")
			return
		end

		arg.running = true
		arg.activeTarget = v9
		arg:_setStatus("Bringing egg home")

		if arg:_regrabBurst(v8, v9.Uid, 3.5) then
			return
		elseif not arg:_isCarryWorkerCurrent(v8) then
			return
		end

		arg:_setStatus("Re-stealing egg")

		if not arg:_teleportRoot(humanoidRootPart, humanoid, v10) then
			arg:_releaseCarryWorker(v8)
			arg:_finish("Re-steal failed \226\128\148 retrying")
			return
		end

		arg:_setArrivalHold(v10, v9.Uid)
		arg:_setStatus("Re-stealing egg")

		if arg:_isCarryWorkerCurrent(v8) then
			arg:_requestCarry(v9, true)
		end
	end

	index._regrabBurst = function(arg, arg2, arg3, arg4)
		local function fn91()
			local v8 = EggState2.ReadFieldEgg(arg3)
			return v8 ~= nil and v8.State == AreaEggs.States.Carried and v8.CarrierUserId == localPlayer2.UserId
		end

		local RagdollJoints

		pcall(function()
			RagdollJoints = require(ReplicatedStorage2.Shared.Modules.RagdollJoints)
		end)

		local flag5 = false
		local flag6 = false
		local n68 = os.clock() + arg4

		while os.clock() < n68 and not arg.destroyed and (arg.enabled or arg._externalDeliver) do
			if fn91() then
				return true
			end

			if not arg:_isCarryWorkerCurrent(arg2) then
				return (fn91())
			end
			local v8 = EggState2.ReadFieldEgg(arg3)

			if v8 then
				if v8.State ~= AreaEggs.States.Dropped and v8.State ~= AreaEggs.States.Slot then
					return false
				end
			else
				return false
			end

			local character = localPlayer2.Character
			local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
			local humanoid = character and character:FindFirstChildOfClass("Humanoid")

			if humanoidRootPart then
				if not humanoid then
					return false
				end
			else
				return false
			end

			pcall(function()
				if RagdollJoints and RagdollJoints.Release then
					RagdollJoints.Release(character)
				end

				humanoid.PlatformStand = false
				humanoid.Sit = false

				if humanoid:GetState() ~= Enum.HumanoidStateType.Running then
					humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
				end
			end)

			local v9 = arg:_resolveEggDestination(v8, humanoidRootPart, humanoid)

			if v9 then
				humanoidRootPart.CFrame = v9
				humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
				humanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
				arg:_syncHoverPad(v9.Position)
			end

			if not flag5 then
				flag5 = true

				task.spawn(function()
					pcall(function()
						eggWorld.AskFieldEggCarry:InvokeServer({Uid = arg3})
					end)

					flag5 = false
				end)
			end

			if not flag6 then
				flag6 = true

				task.spawn(function()
					pcall(EggState2.CarryFieldEgg, arg3)
					flag6 = false
				end)
			end

			pcall(function()
				local areaEggSlotsClient = workspace:FindFirstChild("AreaEggSlotsClient")
				local v10 = areaEggSlotsClient and areaEggSlotsClient:FindFirstChild(tostring(arg3))
				local carryAreaEgg = v10 and (v10:FindFirstChild("CarryAreaEgg", true) or v10:FindFirstChildWhichIsA("ProximityPrompt", true))

				if carryAreaEgg and (carryAreaEgg.Enabled and type(fireproximityprompt) == "function") then
					carryAreaEgg.HoldDuration = 0
					carryAreaEgg.RequiresLineOfSight = false
					fireproximityprompt(carryAreaEgg, 0)
				end
			end)

			task.wait(0.06)
		end

		return (fn91())
	end

	index._recoverCarryConfirmationTimeout = function(arg, arg2, arg3)
		if arg.destroyed then
			return false
		elseif arg.enabled then
			if arg.carryAttemptToken ~= arg2 then
				return false
			elseif arg:_hasConfirmedCarry(arg3) then
				return false
			end
		else
			return false
		end

		local character = localPlayer2.Character
		local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
		arg2 = humanoidRootPart and arg:_resolveSafeCFrame(humanoidRootPart)
		local v8 = arg2 and arg:_resolveElevatedDestination(humanoidRootPart, arg2) or nil
		arg.carryTimeouts = arg.carryTimeouts or {}
		local n68 = (arg.carryTimeouts[arg3] or 0) + 1
		local flag5 = n68 >= n37

		if flag5 then
			arg.carryTimeouts[arg3] = nil
			arg.skippedEggs[arg3] = os.clock() + n38
			arg.tweenRecoveryUid = nil
		else
			arg.carryTimeouts[arg3] = n68
			local v9 = arg:_isPrimerEgg(arg3)
			arg.tweenRecoveryUid = (if v9 then not v9 else arg3) or nil
		end

		local lastCarryReject = arg.stats.lastCarryReject

		if type(lastCarryReject) == "string" and lastCarryReject:lower():find("inventory is full", 1, true) then
			arg.eggFullCount = arg:_eggCount() or 1 / 0
		end

		local v9 = arg.records[arg3] or EggState2.ReadFieldEgg(arg3)
		local flag6 = arg.config.stealMode == "Instant" and (arg3 == arg.primerUid or type(v9) == "table" and v9.AreaId == "Forest")
		arg.carry.generation += 1
		arg:_invalidateCarryWorker()
		arg.carryAttemptToken = nil
		arg:_clearArrivalHold(arg3)

		if arg.activeTween and arg.activeTween.Cancel then
			pcall(arg.activeTween.Cancel, arg.activeTween)
		end

		arg.activeTween = nil
		arg.running = true
		arg.activeTarget = nil
		arg.stats.lastResult = "Carry confirmation timeout"

		if humanoidRootPart and v8 then
			pcall(function()
				humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
				humanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
			end)

			arg:_setStatus("Carry timeout - returning to safe area")

			pcall(arg._glideRoot, arg, v8, function()
				return arg.destroyed or not arg.enabled
			end)

			if flag5 then
				arg:_setStatus(lastCarryReject and "Carry refused (" .. lastCarryReject .. ") \226\128\148 skipping egg" or "Carry timed out twice \226\128\148 skipping egg")
			else
				arg:_setStatus("Carry timeout \226\128\148 retrying")
			end
		else
			arg:_setStatus("Carry timeout \226\128\148 safe area unavailable")
		end

		arg.running = false
		arg:_releaseOperation()

		if flag6 then
			arg.running = true
		end

		task.delay(0.35, function()
			if flag6 then
				if not arg.destroyed and arg.enabled then
					arg:_setStatus("Retrying steal")

					pcall(arg._treadmillReset, arg, function()
						return arg.destroyed or not arg.enabled
					end)
				end

				arg.running = false
			end

			if not arg.destroyed and (arg.enabled and arg.carryAttemptToken == nil) then
				arg:_schedule()
			end
		end)

		return true
	end

	index._requestCarry = function(arg, arg2, arg3)
		if not arg:_wallOpen() then
			arg:_finish("Wall closed before carry")
			return
		end
		local uid, carryAttemptToken, n68 = arg2.Uid, {}
		arg.stats.lastCarryReject = nil
		local n69 = arg.instantPhase == "priming" and uid == arg.primerUid and n36 or math.max(n36, arg:_resolveSettleSeconds(arg2) + 3)
		arg.carryAttemptToken = carryAttemptToken
		arg.stats.lastResult = "Carry requested"
		arg:_setStatus("Securing egg")
		arg2 = localPlayer2.Character
		local humanoid = arg2 and arg2:FindFirstChildOfClass("Humanoid")

		if humanoid then
			pcall(humanoid.UnequipTools, humanoid)
		end

		if arg.coordinator then
			local n70 = os.clock() + 0.35

			while arg.coordinator:isBackgroundBusy() and not arg.destroyed and arg.enabled and arg.carryAttemptToken == carryAttemptToken and os.clock() < n70 do
				task.wait(0.02)
			end

			if humanoid and humanoid.Parent then
				pcall(humanoid.UnequipTools, humanoid)
			end
		end

		task.spawn(function()
			while true do
				local destroyed = arg.destroyed
				if not ((if destroyed then not destroyed else arg.enabled) and arg.running and arg.carryAttemptToken == carryAttemptToken and arg.activeTarget and arg.activeTarget.Uid == uid) then
					break
				end

				if not arg:_hasConfirmedCarry(uid) and arg:_recordShowsCarried(uid) then
					arg:_adoptCarryFromRecord(uid)
				end

				if arg:_hasConfirmedCarry(uid) then
					if arg:_recordShowsCarried(uid) then
						arg:_clearArrivalHold(uid)
						arg.carryAttemptToken = nil

						if arg.activeTween then
							pcall(arg.activeTween.Cancel, arg.activeTween)
							arg.activeTween = nil
						end

						if arg.instantPhase == "priming" and uid == arg.primerUid then
							arg.carry.active = true
							arg.carry.uid = uid
							arg.stats.lastResult = "Preparing steal"
							arg:_enterBaitWait()
							return
						end

						arg.carry.active = true
						arg.carry.uid = uid
						arg.stats.lastResult = "Carry confirmed"
						arg:_setStatus("Carry confirmed")

						task.defer(function()
							if not arg.destroyed and (arg.enabled and arg:_hasConfirmedCarry(uid)) then
								arg:_returnToSafe()
							end
						end)

						return
					end

					arg:_setStatus("Confirming carry record")
					task.wait(n35)
					continue
				end

				if n68 and os.clock() >= n68 then
					arg:_recoverCarryConfirmationTimeout(carryAttemptToken, uid)
					return
				end

				if not arg:_wallOpen() then
					arg:_finish("Wall closed before carry")
					return
				end
				local v8 = EggState2.ReadFieldEgg(uid) or arg.records[uid]
				if not v8 then
					arg:_finish("Target unavailable")
					return
				end

				if v8.State == AreaEggs.States.Carried then
					if v8.CarrierUserId == localPlayer2.UserId then
						arg:_setStatus("Confirming carry state")
						task.wait(n35)
						continue
					end

					arg:_finish("Egg carried by another player")
					return
				end

				if v8.State ~= AreaEggs.States.Slot and v8.State ~= AreaEggs.States.Dropped then
					arg:_finish("Target changed")
					return
				end
				local character = localPlayer2.Character
				local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
				if not humanoidRootPart then
					arg:_finish("Character unavailable")
					return
				end
				local humanoid2 = character and character:FindFirstChildOfClass("Humanoid")
				if not humanoid2 then
					arg:_finish("Character unavailable")
					return
				end
				local v9 = arg:_resolveEggDestination(v8, humanoidRootPart, humanoid2)
				local v10 = v9 and arg:_resolveElevatedDestination(humanoidRootPart, v9) or nil
				if not v10 then
					arg:_finish("Character unavailable")
					return
				end
				local position = v10.Position

				if (humanoidRootPart.Position - position).Magnitude > n39 then
					if arg3 then
						arg:_setStatus("Re-stealing egg")
						if not arg:_teleportRoot(humanoidRootPart, humanoid2, v10) then
							arg:_finish("Re-steal failed \226\128\148 retrying")
							return
						end
						arg:_setArrivalHold(v10, uid)
						arg:_setStatus("Re-stealing egg")
					else
						arg:_setStatus("Re-approaching egg")
						local flag5 = false

						arg:_tweenRoot(v9, function()
							flag5 = true

							if arg.carryAttemptToken == carryAttemptToken and not arg:_hasConfirmedCarry(uid) then
								arg:_setStatus("Securing egg")
							end
						end, nil, {holdAfterArrival = true, holdUid = uid, flightProfile = true})

						while true do
							local destroyed2 = arg.destroyed
							if not ((if destroyed2 then not destroyed2 else arg.enabled) and arg.carryAttemptToken == carryAttemptToken and not arg:_hasConfirmedCarry(uid) and not flag5) then
								break
							end
							task.wait(n35)
						end

						continue
					end
				end

				local v11 = AreaEggSlotIdentity.LooksLikeFirstAreaUid(v8.Uid) and AreaEggSlotIdentity.SlotKey(v8.AreaId, v8.NestId) or nil
				humanoidRootPart, character, position = pcall(fn62, v8.Uid, v11)
				local v12 = if humanoidRootPart then if character == true then nil else position else tostring(character)

				if v12 then
					arg.stats.lastCarryReject = v12

					if v12 ~= arg._lastCarryRejectLogged then
						arg._lastCarryRejectLogged = v12
						warn("[Sena Steal] carry refused: " .. v12)
					end
				end

				n68 = n68 or os.clock() + n69
				arg.stats.lastResult = "Carry requested"
				arg:_setStatus(v12 and "Waiting for carry \194\183 " .. v12 or "Waiting for carry confirmation")
				task.wait(n35)
			end
		end)
	end

	index._burstHold = function(arg, cFrame, arg2)
		if typeof(cFrame) ~= "CFrame" then
			return false
		end
		local position = cFrame.Position

		local function fn91()
			local character = localPlayer2.Character
			return character and character:FindFirstChild("HumanoidRootPart")
		end

		local function fn92(arg3)
			arg3.CFrame = cFrame
			arg3.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
			arg3.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
		end

		local n68 = os.clock() + n26

		while os.clock() < n68 do
			if arg2 and arg2() then
				return false
			end
			local v8 = fn91()

			if v8 then
				if not v8.Parent then
					return false
				end
			else
				return false
			end

			pcall(fn92, v8)
			RunService2.Heartbeat:Wait()
		end

		local n69, now = os.clock() + n27

		while os.clock() < n69 do
			if arg2 and arg2() then
				return false
			end
			n68 = fn91()

			if n68 then
				if not n68.Parent then
					return false
				end
			else
				return false
			end

			if (n68.Position - position).Magnitude > n28 then
				now = nil
			else
				if now then
					if os.clock() - now >= n29 then
						return true
					end
				else
					now = os.clock()
				end
			end

			pcall(fn92, n68)
			RunService2.Heartbeat:Wait()
		end

		local v8 = fn91()
		return v8 ~= nil and (v8.Position - position).Magnitude <= n28
	end

	local tbl16 = {["Titan Temple"] = true, ["Light Dark"] = true, ["Enchanted Forest"] = true, ["Cherry Blossom"] = true, Cosmic = true, Prehistoric = true, ["Abyss Ocean"] = true, Volcano = true, Snow = true, Jungle = true, Desert = true, Lake = true}
	local n68 = 200
	local n69 = 5000

	index._usesPortalBoost = function(arg, arg2)
		return senaV4Config.LowSpeedBoost == true and arg.config.stealMode == "Instant" and type(arg2) == "table" and tbl16[arg2.AreaId] ~= nil and not (arg.portalBoostFailed and (arg.portalBoostFailed[arg2.Uid] or 0) > os.clock())
	end

	local function fn91(arg, arg2)
		local v8 = fn()
		local build = v8 and v8:FindFirstChild("Build")
		local v9 = build and build:FindFirstChild(arg)
		if not v9 then
			return nil
		end
		local basePart = arg2 and v9:FindFirstChild(arg2) or v9:FindFirstChildWhichIsA("BasePart", true)
		return basePart and basePart:IsA("BasePart") and basePart or nil
	end

	local function fn92()
		local attribute = localPlayer2:GetAttribute("RagdollEndTime")
		if type(attribute) ~= "number" then
			return 0
		end
		return math.max(attribute + 0.15 - workspace:GetServerTimeNow(), 0)
	end

	local function fn93(arg)
		local v8

		if type(arg) == "string" then
			local ok, result = pcall(function()
				return game:GetService("HttpService"):JSONDecode(arg)
			end)

			v8 = ok and result or nil
		else
			v8 = arg
		end

		if type(v8) ~= "table" then
			return nil
		end
		local arguments = v8.Arguments
		local vector3 = type(arguments) == "table" and type(arguments[3]) == "number" and Vector3.new(arguments[1], arguments[2], arguments[3]) or nil
		return v8.Action, vector3
	end

	index._watchRelocates = function(arg)
		if arg._relocateConn then
			return
		end
		local refresh = Remotes.RigSync and Remotes.RigSync.Refresh
		if not refresh then
			return
		end
		arg._relocateCount = 0

		arg._relocateConn = refresh.OnClientEvent:Connect(function(arg2)
			if fn93(arg2) == "Relocate" then
				arg._relocateCount = (arg._relocateCount or 0) + 1
				arg._relocateAt = os.clock()
			end
		end)
	end

	index._guardLagback = function(arg, arg2)
		local refresh = Remotes.RigSync and Remotes.RigSync.Refresh
		if not refresh then
			return
		end

		if not arg2 then
			for i, v8 in ipairs(arg._lagbackHooks or {}) do
				pcall(v8.forward.Disconnect, v8.forward)
				pcall(v8.connection.Enable, v8.connection)
			end

			arg._lagbackHooks = nil
			return
		end

		if arg._lagbackHooks then
			return
		elseif type(getconnections) ~= "function" then
			return
		end

		local lagbackHooks = {}
		arg._lagbackHooks = lagbackHooks
		local ok, result = pcall(getconnections, refresh.OnClientEvent)

		for i, v8 in ipairs(ok and type(result) == "table" and result or {}) do
			local function_ = v8.Function

			if type(function_) == "function" then
				i, arg = pcall(debug.info, function_, "s")

				if i and (tostring(arg):find("ContentCatalog", 1, true) and (type(v8.Disable) == "function" and pcall(v8.Disable, v8))) then
					local function fn94(arg3, ...)
						local v9, v10 = fn93(arg3)
						if v9 == "Relocate" and (v10 and v10.Y < n69) then
							return
						end
						function_(arg3, ...)
					end

					local connection6 = refresh.OnClientEvent:Connect(fn94)
					table.insert(lagbackHooks, {connection = v8, forward = connection6})
				end
			end
		end
	end

	index._crossPortal = function(arg, arg2, arg3, arg4)
		arg = localPlayer2.Character
		local humanoidRootPart = arg and arg:FindFirstChild("HumanoidRootPart")

		if not arg2 or not humanoidRootPart then
			return false
		elseif type(firetouchinterest) ~= "function" then
			return false
		end

		local position = humanoidRootPart.Position
		local n70 = os.clock() + (arg4 or 8)
		local n71 = n70 + 6
		local n72 = 0

		while os.clock() < n70 do
			if arg3 and arg3() then
				return false
			end
			local character = localPlayer2.Character
			humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
			if not humanoidRootPart then
				return false
			end

			if (humanoidRootPart.Position - position).Magnitude >= n68 then
				if position.Y > n69 ~= (humanoidRootPart.Position.Y > n69) then
					return true
				end
				position = humanoidRootPart.Position
			end

			local v8 = fn92()

			if v8 > 0 then
				n70 = math.min(math.max(n70, os.clock() + v8 + 1), n71)
			else
				if os.clock() - n72 >= 0.1 then
					n72 = os.clock()

					pcall(function()
						firetouchinterest(humanoidRootPart, arg2, 0)
						task.wait()
						firetouchinterest(humanoidRootPart, arg2, 1)
					end)
				end
			end

			task.wait(0.05)
		end

		return false
	end

	index._mutePortalFx = function(arg, arg2, arg3)
		local portalTransition = Remotes.FuseBiome and Remotes.FuseBiome.PortalTransition
		if not portalTransition then
			return
		end

		if arg2 then
			arg._portalFxMuteCount = (arg._portalFxMuteCount or 0) + 1

			if arg._portalFxMuted then
				return
			elseif type(getconnections) ~= "function" then
				return
			end

			arg._portalFxMuted = {}
			local ok, result = pcall(getconnections, portalTransition.OnClientEvent)

			for i, v8 in ipairs(ok and type(result) == "table" and result or {}) do
				local function_ = v8.Function

				if type(function_) == "function" then
					local ok2, result2 = pcall(debug.info, function_, "s")

					if ok2 and (tostring(result2):find("FuseBiomePortalController", 1, true) and (type(v8.Disable) == "function" and pcall(v8.Disable, v8))) then
						table.insert(arg._portalFxMuted, v8)
					end
				end
			end

			if #arg._portalFxMuted > 0 then
				arg._portalFxHandshake = portalTransition.OnClientEvent:Connect(function(arg4, arg5, arg6)
					if arg5 ~= nil and not arg6 then
						pcall(function()
							portalTransition:FireServer(arg5)
						end)
					end
				end)
			end

			arg:_filterPortalToasts(true)
		else
			arg._portalFxMuteCount = arg3 and 0 or math.max((arg._portalFxMuteCount or 0) - 1, 0)
			if arg._portalFxMuteCount > 0 then
				return
			end
			arg:_filterPortalToasts(false, arg3)

			for i, v8 in ipairs(arg._portalFxMuted or {}) do
				pcall(v8.Enable, v8)
			end

			arg._portalFxMuted = nil

			if arg._portalFxHandshake then
				pcall(arg._portalFxHandshake.Disconnect, arg._portalFxHandshake)
				arg._portalFxHandshake = nil
			end
		end
	end

	local tbl17 = {{"Toasts", "Line"}, {"Alerts", "Raise"}}

	index._filterPortalToasts = function(arg, arg2, arg3)
		if arg2 then
			arg._portalToastUntil = 1 / 0

			if arg._portalToastHooks then
				return
			elseif type(getconnections) ~= "function" then
				return
			end

			local portalToastHooks = {}
			arg._portalToastHooks = portalToastHooks

			for i, v8 in ipairs(tbl17) do
				local ok, result = pcall(function()
					return Remotes[v8[1]][v8[2]]
				end)

				local v9 = if ok then result else nil
				i, ok = false

				if v9 then
					i, ok = pcall(getconnections, v9.OnClientEvent)
				end

				for i2, v10 in ipairs(i and type(ok) == "table" and ok or {}) do
					local function_ = v10.Function

					if type(function_) == "function" and (type(v10.Disable) == "function" and pcall(v10.Disable, v10)) then
						local function fn94(arg4, ...)
							local body = type(arg4) == "table" and (arg4.Body or arg4.Text)
							if type(body) == "string" and (body:lower():find("portal", 1, true) and os.clock() < (arg._portalToastUntil or 0)) then
								return
							end
							function_(arg4, ...)
						end

						local connection6 = v9.OnClientEvent:Connect(fn94)
						table.insert(portalToastHooks, {connection = v10, forward = connection6})
					end
				end
			end

			return
		end

		local function fn94()
			local portalToastHooks = arg._portalToastHooks
			arg._portalToastHooks = nil

			for i, v8 in ipairs(portalToastHooks or {}) do
				pcall(v8.forward.Disconnect, v8.forward)
				pcall(v8.connection.Enable, v8.connection)
			end
		end

		if arg3 then
			fn94()
			return
		end
		local portalToastUntil = os.clock() + 2
		arg._portalToastUntil = portalToastUntil

		task.delay(2.1, function()
			if arg._portalToastUntil == portalToastUntil then
				local portalFxMuteCount = arg._portalFxMuteCount

				if portalFxMuteCount then
					if portalFxMuteCount == 0 then
						fn94()
					end
				else
					fn94()
				end
			end
		end)
	end

	index._portalBoostSteal = function(arg, arg2)
		arg:_mutePortalFx(true)
		arg._boostHopUid = arg2.Uid
		local ok, result = pcall(arg._portalBoostHop, arg, arg2)
		arg:_guardLagback(false)

		if arg._boostHopUid == arg2.Uid then
			arg._boostHopUid = nil
		end

		if arg._treeHopUid == arg2.Uid then
			arg._treeHopUid = nil
		end

		arg:_mutePortalFx(false)
		arg:_muteTreeFx(false)

		if not ok then
			warn("[Sena Steal] steal error: " .. tostring(result))

			if not arg.destroyed and arg.enabled then
				arg:_finish("Steal error \226\128\148 retrying")
			end
		end
	end

	index._muteTreeFx = function(arg, arg2)
		if type(getconnections) ~= "function" then
			return
		end

		if arg2 then
			arg._treeFxToken = (arg._treeFxToken or 0) + 1
			if arg._treeFxMuted then
				return
			end
			arg._treeFxMuted = {}
			local transition = Remotes.EnchantedTree and Remotes.EnchantedTree.Transition

			for i, v8 in ipairs({{transition and transition.OnClientEvent, "EnchantedTreeController"}, {localPlayer2:GetAttributeChangedSignal("InEnchantedTree"), "EnchantedTreeController"}}) do
				i, transition = false

				if v8[1] then
					i, transition = pcall(getconnections, v8[1])
				end

				for i2, v9 in ipairs(i and type(transition) == "table" and transition or {}) do
					local function_ = v9.Function

					if type(function_) == "function" then
						local ok, result = pcall(debug.info, function_, "s")

						if ok and (tostring(result):find(v8[2], 1, true) and (type(v9.Disable) == "function" and pcall(v9.Disable, v9))) then
							table.insert(arg._treeFxMuted, v9)
						end
					end
				end
			end
		else
			if not arg._treeFxMuted then
				return
			end
			local treeFxToken = arg._treeFxToken

			task.spawn(function()
				local n70 = os.clock() + 12

				while os.clock() < n70 and (localPlayer2:GetAttribute("InEnchantedTree") == true or arg._treePromptAt and os.clock() - arg._treePromptAt < 2.5) do
					task.wait(0.1)
				end

				task.wait(1.5)
				if arg._treeFxToken ~= treeFxToken then
					return
				end

				for i, v8 in ipairs(arg._treeFxMuted or {}) do
					pcall(v8.Enable, v8)
				end

				arg._treeFxMuted = nil
			end)
		end
	end

	index._isStealPrompt = function(arg, arg2)
		if typeof(arg2) ~= "Instance" then
			return false
		end

		if arg2.Name == "EnchantedTreePrompt" then
			return true
		end
		local areaEggSlotsClient = workspace:FindFirstChild("AreaEggSlotsClient")
		if areaEggSlotsClient and arg2:IsDescendantOf(areaEggSlotsClient) then
			return true
		end

		if arg2:FindFirstAncestor("FuseBiomeLanePortals") then
			return true
		elseif arg2:FindFirstAncestor("FuseBiomeZone") then
			return true
		end

		return false
	end

	index._installPromptFilter = function(arg)
		if arg._promptFilter then
			return
		elseif type(getconnections) ~= "function" then
			return
		end

		local promptFilter = {muted = {}, forwarders = {}}
		arg._promptFilter = promptFilter

		local function fn94()
			local destroyed = arg.destroyed
			return if destroyed then not destroyed else arg.enabled or arg._externalDeliver or arg._recalling or arg._treeFxMuted ~= nil
		end

		for i, v8 in ipairs({ProximityPromptService.PromptShown, ProximityPromptService.PromptHidden}) do
			local ok, result = pcall(getconnections, v8)

			for i2, v9 in ipairs(ok and type(result) == "table" and result or {}) do
				local function_ = v9.Function

				if type(function_) == "function" then
					i, i2 = pcall(debug.info, function_, "s")

					if i and (tostring(i2):find("ProximityPromptScriptController", 1, true) and (type(v9.Disable) == "function" and pcall(v9.Disable, v9))) then
						table.insert(promptFilter.muted, v9)

						table.insert(promptFilter.forwarders, v8:Connect(function(arg2, ...)
							if fn94() and arg:_isStealPrompt(arg2) then
								return
							end
							function_(arg2, ...)
						end))
					end
				end
			end
		end

		pcall(function()
			local machines = workspace:FindFirstChild("World") and workspace.World:FindFirstChild("Machines")
			local fuseMachine = machines and machines:FindFirstChild("FuseMachine")
			local proximityPrompt = fuseMachine and fuseMachine:FindFirstChildWhichIsA("ProximityPrompt", true)
			if not proximityPrompt then
				return
			end
			local ok, result = pcall(getconnections, proximityPrompt.Triggered)

			for i, v8 in ipairs(ok and type(result) == "table" and result or {}) do
				local function_ = v8.Function

				if type(function_) == "function" and (type(v8.Disable) == "function" and pcall(v8.Disable, v8)) then
					table.insert(promptFilter.muted, v8)

					table.insert(promptFilter.forwarders, proximityPrompt.Triggered:Connect(function(...)
						if fn94() then
							return
						end
						function_(...)
					end))
				end
			end
		end)
	end

	index._removePromptFilter = function(arg)
		local promptFilter = arg._promptFilter
		if not promptFilter then
			return
		end
		arg._promptFilter = nil

		for i, forwarder in ipairs(promptFilter.forwarders) do
			pcall(forwarder.Disconnect, forwarder)
		end

		for i, v8 in ipairs(promptFilter.muted) do
			pcall(v8.Enable, v8)
		end
	end

	index._leaveTreeHidden = function(arg, arg2)
		local enchantedTreeInterior = fn()
		local build = enchantedTreeInterior and enchantedTreeInterior:FindFirstChild("Build")
		enchantedTreeInterior = build and build:FindFirstChild("EnchantedTreeInterior")
		local markers = enchantedTreeInterior and enchantedTreeInterior:FindFirstChild("Markers")
		local exitTrigger = markers and markers:FindFirstChild("ExitTrigger")
		local n70 = os.clock() + 2.5

		while localPlayer2:GetAttribute("InEnchantedTree") ~= true and arg._treePromptAt and os.clock() - arg._treePromptAt < 2.5 and os.clock() < n70 do
			task.wait(0.05)
		end

		local n71 = os.clock() + 10

		while localPlayer2:GetAttribute("InEnchantedTree") == true and os.clock() < n71 do
			if arg2 and arg2() then
				break
			end
			local character = localPlayer2.Character
			local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

			if humanoidRootPart and exitTrigger then
				pcall(firetouchinterest, humanoidRootPart, exitTrigger, 0)
				task.wait()
				pcall(firetouchinterest, humanoidRootPart, exitTrigger, 1)
			end

			task.wait(0.2)
		end

		return localPlayer2:GetAttribute("InEnchantedTree") ~= true
	end

	index._usesTreeBoost = function(arg, arg2)
		return false
	end

	index._treeBoostHop = function(arg, arg2)
		local uid = arg2.Uid
		local v8 = fn()
		local build = v8 and v8:FindFirstChild("Build")
		local enchantedTreeInterior = build and build:FindFirstChild("EnchantedTreeInterior")
		local markers = enchantedTreeInterior and enchantedTreeInterior:FindFirstChild("Markers")
		local enterTrigger = markers and markers:FindFirstChild("EnterTrigger")
		local enchantedTreePrompt = enterTrigger and enterTrigger:FindFirstChild("EnchantedTreePrompt", true)
		local exitTrigger = markers and markers:FindFirstChild("ExitTrigger")

		local function fn94()
			return arg.destroyed or not arg.enabled or arg.instantPhase ~= "hunting" or not arg.activeTarget or arg.activeTarget.Uid ~= uid
		end

		local function fn95()
			local character = localPlayer2.Character
			return character and character:FindFirstChild("HumanoidRootPart"), character and character:FindFirstChildOfClass("Humanoid")
		end

		local function fn96()
			return localPlayer2:GetAttribute("InEnchantedTree") == true
		end

		local function fn97()
			local n70 = os.clock() + 8

			while fn96() and os.clock() < n70 do
				local v9 = fn95()

				if v9 and exitTrigger then
					pcall(firetouchinterest, v9, exitTrigger, 0)
					task.wait()
					pcall(firetouchinterest, v9, exitTrigger, 1)
				end

				task.wait(0.2)
			end

			return not fn96()
		end

		local function fn98(arg3)
			fn97()
			if fn94() then
				return
			end
			arg.treeBoostFailed = arg.treeBoostFailed or {}
			arg.treeBoostFailed[uid] = os.clock() + 60
			arg:_finish(arg3)
		end

		build, arg2 = fn95()

		if enchantedTreePrompt and exitTrigger then
			if build then
				if not arg2 then
					fn98("Steal unavailable \226\128\148 retrying")
					return
				end
			else
				fn98("Steal unavailable \226\128\148 retrying")
				return
			end
		else
			fn98("Steal unavailable \226\128\148 retrying")
			return
		end

		local parent = enchantedTreePrompt.Parent
		local worldPosition = parent and (parent:IsA("Attachment") and parent.WorldPosition or parent:IsA("BasePart") and parent.Position)
		if not worldPosition then
			fn98("Steal unavailable \226\128\148 retrying")
			return
		end
		parent = os.clock() + 4

		while fn92() > 0 and os.clock() < parent do
			if fn94() then
				return
			end
			task.wait(0.05)
		end

		arg:_clearArrivalHold(uid)
		arg:_stopHoverPad()
		arg:_setStatus("Heading to target egg")
		arg._treeHopUid = uid
		arg:_muteTreeFx(true)
		arg:_teleportRoot(build, arg2, CFrame.new(worldPosition + Vector3.new(0, 1, 4)))
		local n70 = (tonumber(enchantedTreePrompt.HoldDuration) or 0) + 0.05
		local n71 = os.clock() + 6

		while true do
			local v9 = fn96()
			if not (if v9 then not v9 else os.clock() < n71) then
				break
			end

			if fn94() then
				return
			end

			pcall(function()
				enchantedTreePrompt.Enabled = true
			end)

			arg._treePromptAt = os.clock()

			pcall(function()
				enchantedTreePrompt:InputHoldBegin()
				task.wait(n70)
				enchantedTreePrompt:InputHoldEnd()
			end)

			if type(fireproximityprompt) == "function" then
				pcall(fireproximityprompt, enchantedTreePrompt, n70)
			end

			task.wait(0.1)
		end

		if not fn96() then
			fn98("Could not reach the egg \226\128\148 retrying")
			return
		end
		arg:_setStatus("Securing target egg")
		task.wait(0.3)
		if not fn97() then
			fn98("Could not reach the egg \226\128\148 retrying")
			return
		end

		if fn94() then
			return
		end
		parent, arg2 = fn95()

		if parent then
			if not arg2 then
				fn98("Character unavailable")
				return
			end
		else
			fn98("Character unavailable")
			return
		end

		local v9 = EggState2.ReadFieldEgg(uid) or arg.records[uid]

		if v9 then
			if v9.State ~= AreaEggs.States.Slot and v9.State ~= AreaEggs.States.Dropped then
				arg:_finish("Target egg no longer available")
				return
			end
		else
			arg:_finish("Target egg no longer available")
			return
		end

		local v10 = arg:_resolveEggDestination(v9, parent, arg2)
		if not v10 then
			fn98("Target destination unavailable")
			return
		end
		arg:_walkTo(v10, fn94, 4)
		if fn94() then
			return
		end
		parent, arg2 = fn95()
		local flag5 = not parent

		if if parent then not arg2 else flag5 then
			fn98("Could not reach the egg \226\128\148 retrying")
			return
		elseif (parent.Position - v10.Position).Magnitude > 25 then
			fn98("Could not reach the egg \226\128\148 retrying")
			return
		end

		arg:_setArrivalHold(v10, uid)
		arg.boostedUid = uid
		arg.treeBoostedUid = uid

		task.spawn(function()
			pcall(function()
				eggWorld.AskFieldEggCarry:InvokeServer({Uid = uid})
			end)
		end)

		arg:_setStatus("Securing target egg")
		arg:_requestCarry(v9, true)
	end

	index._portalBoostHop = function(arg, arg2)
		local uid = arg2.Uid
		if arg:_usesTreeBoost(arg2) then
			return arg:_treeBoostHop(arg2)
		end
		local FuseBiomeLanePortals = fn91("FuseBiomeLanePortals")
		local FuseBiomeZone = fn91("FuseBiomeZone", "ExitPart")

		local function fn94()
			return arg.destroyed or not arg.enabled or arg.instantPhase ~= "hunting" or not arg.activeTarget or arg.activeTarget.Uid ~= uid
		end

		local function fn95()
			local character = localPlayer2.Character
			return character and character:FindFirstChild("HumanoidRootPart"), character and character:FindFirstChildOfClass("Humanoid")
		end

		local function fn96()
			local v8 = fn95()

			if v8 and v8.Position.Y > n69 then
				arg:_crossPortal(FuseBiomeZone, nil, 8)
			end
		end

		local function fn97(arg3)
			fn96()
			if fn94() then
				return
			end
			arg.portalBoostMisses = arg.portalBoostMisses or {}
			local n70 = (arg.portalBoostMisses[uid] or 0) + 1
			arg.portalBoostMisses[uid] = n70

			if n70 >= 2 then
				arg.portalBoostMisses[uid] = nil
				arg.portalBoostFailed = arg.portalBoostFailed or {}
				arg.portalBoostFailed[uid] = os.clock() + 60
			end

			arg:_finish(arg3)
		end

		local v8, v9 = fn95()

		if FuseBiomeLanePortals then
			if not FuseBiomeZone then
				fn97("Steal unavailable \226\128\148 retrying")
				return
			elseif v8 then
				if not v9 then
					fn97("Steal unavailable \226\128\148 retrying")
					return
				end
			else
				fn97("Steal unavailable \226\128\148 retrying")
				return
			end
		else
			fn97("Steal unavailable \226\128\148 retrying")
			return
		end

		local v10 = arg:_resolveEggDestination(arg2, v8, v9)
		if not v10 then
			fn97("Target destination unavailable")
			return
		end
		arg:_setStatus("Heading to target egg")
		arg:_guardLagback(true)
		RunService2.PreSimulation:Wait()
		v9.PlatformStand = true
		arg:_teleportRoot(v8, v9, v10)
		RunService2.PreSimulation:Wait()
		v9.PlatformStand = false
		local n70 = 0.1

		pcall(function()
			n70 = localPlayer2:GetNetworkPing() or 0.1
		end)

		task.wait(math.clamp(0.15 + n70 * 2.5, 0.3, 1))
		if fn94() then
			return
		end
		arg:_stopHoverPad()
		arg:_setStatus("Securing target egg")
		local v11 = arg:_crossPortal(FuseBiomeLanePortals, fn94, 6)
		arg:_guardLagback(false)
		if not v11 then
			fn97("Could not reach the egg \226\128\148 retrying")
			return
		end
		arg:_setStatus("Securing target egg")
		if not arg:_crossPortal(FuseBiomeZone, fn94, 8) then
			fn97("Could not reach the egg \226\128\148 retrying")
			return
		end

		if fn94() then
			return
		end
		v9, FuseBiomeLanePortals = fn95()

		if v9 then
			if not FuseBiomeLanePortals then
				fn97("Character unavailable")
				return
			end
		else
			fn97("Character unavailable")
			return
		end

		if (v9.Position - v10.Position).Magnitude > 25 then
			fn97("Could not reach the egg \226\128\148 retrying")
			return
		end
		local v12 = EggState2.ReadFieldEgg(uid) or arg.records[uid]

		if v12 then
			if v12.State ~= AreaEggs.States.Slot and v12.State ~= AreaEggs.States.Dropped then
				arg:_finish("Target egg no longer available")
				return
			end
		else
			arg:_finish("Target egg no longer available")
			return
		end

		local v13 = arg:_resolveEggDestination(v12, v9, FuseBiomeLanePortals) or v10
		arg:_teleportRoot(v9, FuseBiomeLanePortals, v13)
		arg:_setArrivalHold(v13, uid)
		arg.boostedUid = uid
		arg:_setStatus("Securing target egg")
		task.wait(0.35)
		if fn94() then
			return
		end

		task.spawn(function()
			pcall(function()
				eggWorld.AskFieldEggCarry:InvokeServer({Uid = uid})
			end)
		end)

		arg:_requestCarry(v12, true)
	end

	index._needsHiddenRecall = function(arg)
		if arg.destroyed then
			return false
		end
		local character = localPlayer2.Character
		local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
		if not humanoidRootPart then
			return false
		end

		if humanoidRootPart.Position.Y > n69 then
			return true
		end

		if localPlayer2:GetAttribute("InEnchantedTree") == true then
			return true
		end

		if arg._treePromptAt and os.clock() - arg._treePromptAt < 2.5 then
			return true
		end

		if arg._treeHopUid ~= nil then
			return true
		end
		return arg.treadmillDecoy ~= nil and arg.treadmillDecoy.Parent ~= nil and not arg:_isInSafeArea(humanoidRootPart)
	end

	index._finishBoostedEgg = function(arg, arg2)
		local v8 = EggState2.ReadFieldEgg(arg2) or arg.records[arg2]

		if v8 then
			if v8.State ~= AreaEggs.States.Slot and v8.State ~= AreaEggs.States.Dropped then
				return false
			end
		else
			return false
		end

		local character = localPlayer2.Character
		local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		local flag5 = humanoidRootPart and humanoid and arg:_resolveEggDestination(v8, humanoidRootPart, humanoid)

		if flag5 then
			if (humanoidRootPart.Position - flag5.Position).Magnitude > 25 then
				return false
			end
		else
			return false
		end

		arg:_setArrivalHold(flag5, arg2)
		arg:_setStatus("Finishing target egg")

		local function fn94()
			local v9 = EggState2.ReadFieldEgg(arg2)
			return v9 ~= nil and v9.State == AreaEggs.States.Carried and v9.CarrierUserId == localPlayer2.UserId
		end

		local n70 = os.clock() + 3
		flag5 = false

		while (if flag5 then not flag5 else os.clock() < n70) and not arg.destroyed and not arg.enabled do
			task.spawn(function()
				pcall(function()
					eggWorld.AskFieldEggCarry:InvokeServer({Uid = arg2})
				end)
			end)

			local n71 = os.clock() + 0.25

			while os.clock() < n71 do
				if fn94() then
					flag5 = true
					break
				end
				task.wait(0.03)
			end
		end

		arg:_clearArrivalHold(arg2)

		if flag5 then
			if arg.destroyed then
				return false
			elseif arg.enabled then
				return false
			end
		else
			return false
		end

		arg.boostedUid = nil
		if not arg:deliverCarriedEgg(arg2, v8) then
			return false
		end
		local n71 = os.clock() + 30

		while arg._instantReturnToken ~= nil and os.clock() < n71 and not arg.destroyed do
			task.wait(0.1)
		end

		arg.boostedUid = nil
		local v9 = EggState2.ReadFieldEgg(arg2)
		local flag6 = v9 == nil or v9.State == AreaEggs.States.Claimed or senaV4Config.HelpFriend and v9.State == AreaEggs.States.Dropped
		local character2 = localPlayer2.Character
		local humanoidRootPart2 = character2 and character2:FindFirstChild("HumanoidRootPart")
		return flag6 and humanoidRootPart2 ~= nil and arg:_isInSafeArea(humanoidRootPart2)
	end

	index._finishTreeEgg = function(arg, treeBoostedUid)
		local v8 = EggState2.ReadFieldEgg(treeBoostedUid) or arg.records[treeBoostedUid]

		if v8 then
			if v8.State ~= AreaEggs.States.Slot and v8.State ~= AreaEggs.States.Dropped then
				return false
			end
		else
			return false
		end

		local character = localPlayer2.Character
		local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		local v9 = humanoidRootPart and humanoid and arg:_resolveEggDestination(v8, humanoidRootPart, humanoid)

		if v9 then
			if (humanoidRootPart.Position - v9.Position).Magnitude > 400 then
				return false
			end
		else
			return false
		end

		arg:_setStatus("Finishing target egg")
		local externalDeliver = arg._externalDeliver
		arg._externalDeliver = true

		arg:_walkTo(v9, function()
			return arg.destroyed or arg.enabled
		end, 4)

		arg._externalDeliver = externalDeliver

		if arg.destroyed then
			return false
		elseif arg.enabled then
			return false
		end

		arg.treeBoostedUid = treeBoostedUid
		return arg:_finishBoostedEgg(treeBoostedUid)
	end

	index._recallHidden = function(arg)
		arg._recalling = true
		local boostHopUid = arg._boostHopUid
		local treeHopUid = arg._treeHopUid

		task.spawn(function()
			local function fn94()
				return arg.destroyed or arg.enabled
			end

			local ok, result = pcall(function()
				arg:_startMovementProtection()
				arg:_mutePortalFx(true)
				local flag5 = localPlayer2:GetAttribute("InEnchantedTree") == true or arg._treePromptAt ~= nil and os.clock() - arg._treePromptAt < 2.5

				if flag5 or treeHopUid then
					arg:_muteTreeFx(true)
					arg:_setStatus("Finishing target egg")
					local flag6 = arg:_leaveTreeHidden(fn94) and not fn94() and treeHopUid ~= nil and arg:_finishTreeEgg(treeHopUid)
					arg:_muteTreeFx(false)

					if flag6 then
						return
					elseif fn94() then
						return
					end
				end

				local character = localPlayer2.Character
				local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
				local flag6 = (if flag5 then not flag5 else humanoidRootPart ~= nil) and humanoidRootPart.Position.Y > n69

				if flag6 then
					arg:_setStatus("Returning to safe area")
					arg:_crossPortal(fn91("FuseBiomeZone", "ExitPart"), fn94, 8)
				end

				if fn94() then
					return
				end

				if flag6 and (boostHopUid and arg:_finishBoostedEgg(boostHopUid)) then
					return
				end
				local flag7 = false

				local function fn95()
					for i, v8 in ipairs(EggState2.ReadFieldEggs().Records or {}) do
						if v8.State == AreaEggs.States.Carried and v8.CarrierUserId == localPlayer2.UserId then
							flag7 = true
							break
						end
					end
				end

				pcall(fn95)

				if flag7 then
					pcall(EggState2.DropFieldEgg, "PlayerRequest")
					task.wait(0.3)
				end

				local character2 = localPlayer2.Character
				local humanoidRootPart2 = character2 and character2:FindFirstChild("HumanoidRootPart")

				if humanoidRootPart2 and (not arg:_isInSafeArea(humanoidRootPart2) and not fn94()) then
					arg:_setStatus("Returning to safe area")
					local v8 = arg:_resolveSafeCFrame(humanoidRootPart2)
					local externalDeliver = arg._externalDeliver
					arg._externalDeliver = true

					if v8 then
						arg:_glideRoot(v8, fn94)
					end

					arg._externalDeliver = externalDeliver

					if not fn94() then
						arg:_groundSnap()
					end
				end
			end)

			if not ok then
				warn("[Sena Steal] hidden recall error: " .. tostring(result))
			end

			arg:_mutePortalFx(false)
			arg._recalling = nil

			if not arg.destroyed and not arg.enabled then
				arg:_hideTreadmillDecoy()
				arg:_removeGuardHitDistanceBoost()
				arg:_stopMovementProtection()
				fn68(arg)
				arg:_setStatus("Idle")
			end
		end)
	end

	index._treadmillReset = function(arg, arg2)
		arg._treadmillResetting = true
		local ok, result = pcall(arg._treadmillResetInner, arg, arg2)
		arg._treadmillResetting = false
		return ok and result
	end

	index._treadmillResetInner = function(arg, arg2)
		local function fn94()
			return arg2 ~= nil and arg2()
		end

		local treadmill = Remotes and Remotes.Treadmill
		if not treadmill or fn94() then
			return false
		end

		local function fn95()
			local ok, result = pcall(function()
				return treadmill.AskRenderSnapshot:InvokeServer()
			end)

			if ok then
				if type(result) ~= "table" then
					return nil
				end
			else
				return nil
			end

			return table.find(result, localPlayer2.UserId) ~= nil
		end

		local flag5 = (function()
			local ok, result = pcall(function()
				local flag5 = type(PlotState2.ResolveLocalSlot) == "function" and PlotState2.ResolveLocalSlot() or PlotState2.GetMySlot()
				local flag6 = type(PlotState2.ResolveFolder) == "function" and PlotState2.ResolveFolder() or PlotState2.GetPlotsFolder()
				local v8 = flag6 and flag5 and flag6:FindFirstChild(tostring(flag5))
				local treadmillBottom = v8 and v8:FindFirstChild("TreadmillBottom")

				if treadmillBottom then
					if not treadmillBottom:IsA("BasePart") then
						return nil
					end
				else
					return nil
				end

				local character = localPlayer2.Character
				local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
				local humanoid = character and character:FindFirstChildOfClass("Humanoid")

				if humanoidRootPart then
					if not humanoid then
						return nil
					end
				else
					return nil
				end

				local n70 = humanoid.RigType == Enum.HumanoidRigType.R15 and humanoidRootPart.Size.Y * 0.5 + math.max(humanoid.HipHeight, 0.5) or humanoidRootPart.Size.Y * 0.5 + 2
				return treadmillBottom.CFrame * CFrame.new(0, treadmillBottom.Size.Y * 0.5 + n70 + 0.05, 0)
			end)

			return ok and result or nil
		end)()

		if flag5 then
			if fn94() then
				return false
			end
		else
			return false
		end

		arg:_glideRoot(flag5, function()
			return fn94()
		end)

		if fn94() then
			return false
		end
		arg = os.clock() + 0.7
		flag5 = false

		while true do
			local v8 = fn94()
			if not (if v8 then not v8 else os.clock() < arg) then
				break
			end

			pcall(function()
				treadmill.AskWearStill:InvokeServer()
			end)

			task.wait(0.08)
			if fn95() == true then
				flag5 = true
				break
			end
		end

		if flag5 then
			local n70 = os.clock() + 0.25

			while true do
				local v8 = fn94()
				if not (if v8 then not v8 else os.clock() < n70) then
					break
				end
				task.wait(0.05)
			end
		end

		local n70 = os.clock() + 0.7
		local flag6 = false

		while true do
			local v8 = fn94()
			if not (if v8 then not v8 else os.clock() < n70) then
				break
			end

			pcall(function()
				treadmill.AskDoff:InvokeServer()
			end)

			task.wait(0.08)
			if fn95() == false then
				flag6 = true
				break
			end
		end

		return flag5 and flag6
	end

	index._instantReturn = function(arg, forestDropInProgress)
		if arg._instantReturnToken ~= nil then
			return
		end
		local instantReturnToken = {}
		arg._instantReturnToken = instantReturnToken
		arg._flyDeparting = false

		if arg.config.stealMode == "Fly" then
			arg:_showTreadmillDecoy()
		end

		task.spawn(function()
			local function fn94()
				local destroyed = arg.destroyed
				return (if destroyed then not destroyed else arg.enabled or arg._externalDeliver) and arg._instantReturnToken == instantReturnToken
			end

			local function fn95()
				local character = localPlayer2.Character
				return character and character:FindFirstChild("HumanoidRootPart"), character and character:FindFirstChildOfClass("Humanoid")
			end

			local function fn96()
				return EggState2.ReadFieldEgg(forestDropInProgress)
			end

			local function fn97()
				local v8 = fn96()
				return v8 ~= nil and v8.State == AreaEggs.States.Carried and v8.CarrierUserId == localPlayer2.UserId
			end

			local function fn98()
				local v8 = fn96()
				if not v8 then
					return true
				end
				return v8.State == AreaEggs.States.Claimed
			end

			local function fn99()
				local v8 = fn95()
				return v8 and arg:_resolveSafeCFrame(v8) or nil
			end

			local function fn100(arg2)
				arg.settleBonus = arg.settleBonus or {}

				if arg2 then
					arg.settleBonus[forestDropInProgress] = nil
				elseif arg.config.stealMode == "Instant" then
					if arg.boostedUid ~= forestDropInProgress then
						local settleBonus = arg.settleBonus
						local tbl18 = {seconds = n23}
						tbl18.untilAt, settleBonus[forestDropInProgress] = os.clock() + 300, tbl18
					end
				end
			end

			local function fn101(arg2)
				if arg._instantReturnToken ~= instantReturnToken then
					return
				end
				fn100(arg2 == nil or arg2 == "Safe return complete")
				arg._instantReturnToken = nil
				arg._forestDropInProgress = nil
				local externalDeliver = arg._externalDeliver
				arg._externalDeliver = nil
				if arg.destroyed then
					return
				end

				if arg.enabled then
					arg:_reportStolen()
					arg:_finish(arg2 or "Safe return complete")
				elseif externalDeliver then
					arg:_reportStolen()
					arg.carry.active = false
					arg.carry.uid = nil
					arg.activeTarget = nil
					arg:_hideTreadmillDecoy()
				end
			end

			arg:_clearArrivalHold(forestDropInProgress)
			local treeRegrabMode = arg.treeBoostedUid == forestDropInProgress and (arg.treeRegrabMode or "walk") or "glide"

			local function fn102()
				local v8 = fn95()
				return v8 ~= nil and arg:_isInSafeArea(v8)
			end

			local function fn103(arg2, arg3, arg4)
				return arg:_walkTo(arg2, arg3, arg4 or 4)
			end

			local function fn104(arg2, arg3, arg4, arg5)
				local flag5 = treeRegrabMode == "walk" or arg5 == "egg" and (treeRegrabMode == "glideSafe" or treeRegrabMode == "skipSafe") or arg5 == "safe" and treeRegrabMode == "glideEgg"

				if flag5 and arg5 == "safe" then
					local function fn105()
						return arg3() or fn102()
					end

					return arg:_walkTo(arg2, fn105, arg4 or 4)
				end

				if flag5 then
					return arg:_walkTo(arg2, arg3, arg4 or 4)
				end
				return arg:_glideRoot(arg2, arg3)
			end

			local flag5 = arg.config.stealMode == "Fly" or arg.boostedUid == forestDropInProgress and not senaV4Config.HelpFriend
			local n70 = arg.boostedUid == forestDropInProgress and not senaV4Config.HelpFriend and 0.3 or flag5 and 0.15 or 0.4
			local n71 = flag5 and 0.45 or n22
			local v8 = fn97()

			if v8 then
			else
				arg:_setStatus("Confirming carry record")
				local n72 = os.clock() + 2.5

				while fn94() and os.clock() < n72 do
					v8 = fn97()
					if v8 then
						break
					end
					local v9 = fn96()
					if v9 and v9.State == AreaEggs.States.Claimed then
						break
					end
					RunService2.Heartbeat:Wait()
				end

				if not fn94() then
					return
				end
			end

			if v8 then
				arg._forestDropInProgress = forestDropInProgress

				for i = 1, index.RELAY_ROUNDS, 1 do
					arg._forestDropInProgress = forestDropInProgress
					arg:_setStatus("Bringing egg home")

					arg:_hopRoot(cframe, function()
						local v9 = fn94()
						return if v9 then not fn97() else not v9
					end)

					if not fn94() then
						return
					end
					flag5 = false

					for i2 = 1, n21, 1 do
						if fn94() then
							if not fn97() then
								break
							end
						else
							break
						end

						arg:_setStatus("Bringing egg home")

						arg:_hopRoot(cframe, function()
							local v9 = fn94()
							return if v9 then not fn97() else not v9
						end)

						if not fn94() then
							return
						end

						if fn97() then
							task.wait(math.max(n70, arg:_relaySettle()))
							if not fn94() then
								return
							end

							if fn97() then
								pcall(EggState2.DropFieldEgg, "PlayerRequest")
							end

							local n72 = os.clock() + n71

							while fn94() and fn97() and os.clock() < n72 do
								RunService2.Heartbeat:Wait()
							end
						end

						local v9 = fn96()
						local v10 = flag5
						if v9 and v9.State == AreaEggs.States.Dropped then
							flag5 = true
							break
						end

						if not fn97() then
							flag5 = v10
							break
						end
					end

					if not fn94() then
						return
					end

					if not flag5 then
						if arg._instantReturnToken == instantReturnToken then
							arg._instantReturnToken = nil
						end

						arg._forestDropInProgress = nil
						fn100(false)
						arg:_finish("Drop failed \226\128\148 retrying")
						return
					end

					if senaV4Config.HelpFriend then
						arg.skippedEggs[forestDropInProgress] = os.clock() + 1800
						arg._forestDropInProgress = nil
						arg.carry.active = false
						arg.carry.uid = nil
						arg.stats.lastResult = "Dropped for a friend"
						arg:_setStatus("Egg dropped for a friend, heading back")
						local v9 = fn99()

						if v9 then
							arg:_glideRoot(v9, function()
								return not fn94()
							end)
						end

						if not fn94() then
							return
						end
						local externalDeliver = arg._externalDeliver
						arg._instantReturnToken = nil
						arg._externalDeliver = nil

						if arg.enabled then
							arg:_finish("Dropped for a friend")
						elseif externalDeliver then
							arg.activeTarget = nil
							arg:_hideTreadmillDecoy()
						end

						return
					end

					local n72, position = os.clock() + 3

					while fn94() and os.clock() < n72 do
						local v9 = fn96()

						if v9 and v9.State == AreaEggs.States.Dropped then
							local bottomCFrame = v9.BottomCFrame or v9.BoundsCFrame
							position = bottomCFrame and bottomCFrame.Position
							if position then
								break
							end
						else
							if v9 and v9.State ~= AreaEggs.States.Carried then
								break
							end
						end

						task.wait(0.1)
					end

					if not fn94() then
						return
					end
					arg._forestDropInProgress = nil

					if position then
						arg:_noteRelayLanding((position - cframe.Position).Magnitude)
					end

					arg:_setStatus("Bringing egg home")
					local flag6 = treeRegrabMode ~= "skipSafe" and fn99()

					if flag6 then
						fn104(flag6, function()
							return not fn94()
						end, nil, "safe")
					end

					if not fn94() then
						return
					end
					local v9 = arg:_claimCarryWorker("instant-regrab", forestDropInProgress)
					local cframe2 = position and CFrame.new(position + Vector3.new(0, 3.2, 0)) or cframe

					local function fn105()
						fn104(cframe2, function()
							local v10 = fn94()
							return if v10 then fn97() else not v10
						end, 3, "egg")
					end

					n72 = false

					if v9 then
						arg:_setStatus("Bringing egg home")
						fn105()
						if not fn94() then
							return
						end
						n72 = arg:_regrabBurst(v9, forestDropInProgress, 0.5)
						if not fn94() then
							return
						end
						n72 = if fn97() then true else n72

						if n72 then
						else
							if fn97() then
							else
								if arg:_isCarryWorkerCurrent(v9) then
									arg:_setStatus("Bringing egg home")
									local v10 = fn99()

									if v10 then
										arg:_glideRoot(v10, function()
											return not fn94()
										end)
									end

									if not fn94() then
										return
									end
									arg:_setStatus("Bringing egg home")

									arg:_treadmillReset(function()
										return not fn94()
									end)

									if not fn94() then
										return
									end
									arg:_setStatus("Bringing egg home")
									v10 = fn99()

									if v10 then
										arg:_glideRoot(v10, function()
											return not fn94()
										end)
									end

									if not fn94() then
										return
									end

									if arg:_isCarryWorkerCurrent(v9) then
										arg:_setStatus("Bringing egg home")
										fn105()
										if not fn94() then
											return
										end
										local v11 = arg:_regrabBurst(v9, forestDropInProgress, 0.6)
										if not fn94() then
											return
										end
										n72 = v11
									end
								end
							end
						end
					end

					if not n72 and not fn97() then
						fn101(fn98() and "Safe return complete" or "Re-grab failed \226\128\148 retrying")
						return
					end

					if position ~= nil then
						if (position - cframe.Position).Magnitude > index.RELAY_LAND_OK then
							if fn97() then
								if i >= index.RELAY_ROUNDS then
									break
								end
							else
								break
							end
						else
							break
						end
					else
						break
					end

					arg:_setStatus("Bringing egg home")
				end
			end

			local n72 = 80

			local function fn105(arg2, arg3)
				local v9, v10 = fn95()
				if v9 and (v10 and (v9.Position - arg2.Position).Magnitude <= n72) then
					return arg:_teleportRoot(v9, v10, arg2)
				end
				return fn103(arg2, arg3)
			end

			if fn97() then
				arg:_setStatus("Bringing egg home")
				local v9 = fn99()

				if v9 then
					fn105(v9, function()
						local v10 = fn94()
						return if v10 then not fn97() else not v10
					end)
				end
			end

			arg:_setStatus("Waiting for deposit")
			local n73 = os.clock() + 8

			while fn94() and not fn98() and os.clock() < n73 do
				n70, fn99 = fn95()

				if n70 and (fn99 and not arg:_isInSafeArea(n70)) then
					local v9 = arg:_resolveSafeCFrame(n70)

					if v9 then
						fn105(v9, function()
							local v10 = fn94()
							return if v10 then fn98() else not v10
						end)
					end
				end

				task.wait(0.1)
			end

			fn101(fn98() and "Safe return complete" or "Bank not confirmed \226\128\148 retrying")
		end)
	end

	index.deliverCarriedEgg = function(arg, uid, activeTarget)
		if type(uid) ~= "string" then
			return false
		elseif uid == "" then
			return false
		elseif arg.destroyed then
			return false
		end

		if arg._instantReturnToken ~= nil then
			return false
		end
		arg._externalDeliver = true

		if type(activeTarget) == "table" then
			arg.activeTarget = activeTarget
		end

		arg.carry.active = true
		arg.carry.uid = uid
		arg.reportedUid = nil
		arg:_instantReturn(uid)

		if arg._instantReturnToken == nil then
			arg._externalDeliver = nil
			arg.carry.active = false
			arg.carry.uid = nil
			return false
		end

		task.spawn(function()
			local n70 = os.clock() + 30

			while arg._instantReturnToken ~= nil and os.clock() < n70 do
				task.wait(0.25)
			end

			if arg._externalDeliver then
				arg._externalDeliver = nil
				arg._instantReturnToken = nil
				arg.carry.active = false
				arg.carry.uid = nil
			end
		end)

		return true
	end

	index._adminSteal = function(arg, activeTarget)
		local uid = activeTarget.Uid
		arg._adminBusyUid = uid

		local function fn94()
			local v8 = EggState2.ReadFieldEgg(uid)
			return v8 ~= nil and v8.State == AreaEggs.States.Carried and v8.CarrierUserId == localPlayer2.UserId
		end

		local function fn95()
			local destroyed = arg.destroyed
			return (if destroyed then not destroyed else arg.enabled) and genv.__SenaV4AdminBoost == true and arg._adminBusyUid == uid
		end

		local ok, result = pcall(function()
			arg.instantPhase = nil
			arg.primerUid = nil
			arg.targetUid = nil
			arg.activeTarget = activeTarget
			arg.stats.lastResult = "Admin Abuse"
			arg:_setStatus("Heading to target egg")
			local n70 = os.clock() + 3
			local n71 = 0

			while fn95() and not fn94() do
				if os.clock() >= n70 then
					arg.skippedEggs[uid] = os.clock() + 10
					return arg:_finish("Carry refused \226\128\148 next egg")
				end
				local v8 = EggState2.ReadFieldEgg(uid)
				if if v8 then v8.State ~= AreaEggs.States.Slot and v8.State ~= AreaEggs.States.Dropped else not v8 then
					return arg:_finish("Target egg no longer available")
				end
				local character = localPlayer2.Character
				local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
				local humanoid = character and character:FindFirstChildOfClass("Humanoid")
				if if humanoidRootPart then not humanoid else not humanoidRootPart then
					return arg:_finish("Character unavailable")
				end
				local v9 = arg:_resolveEggDestination(v8, humanoidRootPart, humanoid)

				if v9 and (humanoidRootPart.Position - v9.Position).Magnitude > 4 then
					arg:_teleportRoot(humanoidRootPart, humanoid, v9)
				end

				if os.clock() >= n71 then
					n71 = os.clock() + 0.1
					arg:_setStatus("Securing egg")

					task.spawn(function()
						pcall(function()
							eggWorld.AskFieldEggCarry:InvokeServer({Uid = uid})
						end)
					end)
				end

				RunService2.Heartbeat:Wait()
			end

			if not fn95() then
				return
			end
			arg.carry.active = true
			arg.carry.uid = uid
			arg:_adminDeliver(uid)
		end)

		if arg._adminBusyUid == uid then
			arg._adminBusyUid = nil
		end

		if not ok then
			warn("[Sena Steal] admin steal error: " .. tostring(result))

			if not arg.destroyed and arg.enabled then
				arg:_finish("Steal error \226\128\148 retrying")
			end
		end
	end

	index._adminDeliver = function(arg, adminDeliverUid)
		if arg._adminDeliverUid == adminDeliverUid then
			return
		end
		arg._adminDeliverUid = adminDeliverUid
		arg._adminBusyUid = adminDeliverUid

		local function fn94()
			return EggState2.ReadFieldEgg(adminDeliverUid)
		end

		local function fn95()
			local v8 = fn94()
			return v8 ~= nil and v8.State == AreaEggs.States.Carried and v8.CarrierUserId == localPlayer2.UserId
		end

		local function fn96()
			local v8 = fn94()
			return v8 == nil or v8.State == AreaEggs.States.Claimed
		end

		arg:_clearArrivalHold(adminDeliverUid)
		arg:_setStatus("Bringing egg home")
		local n70 = os.clock() + 4

		while true do
			local destroyed = arg.destroyed
			if not ((if destroyed then not destroyed else arg.enabled) and not fn96() and fn95() and os.clock() < n70) then
				break
			end
			local character = localPlayer2.Character
			local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
			local humanoid = character and character:FindFirstChildOfClass("Humanoid")
			local v8 = humanoidRootPart and arg:_resolveSafeCFrame(humanoidRootPart)

			if v8 and (humanoid and (humanoidRootPart.Position - v8.Position).Magnitude > 4) then
				arg:_teleportRoot(humanoidRootPart, humanoid, v8)
				arg:_setStatus("Waiting for deposit")
			end

			RunService2.Heartbeat:Wait()
		end

		arg._adminDeliverUid = nil

		if arg._adminBusyUid == adminDeliverUid then
			arg._adminBusyUid = nil
		end

		if arg.destroyed then
			return
		elseif not arg.enabled then
			return
		end

		if fn96() then
			arg:_reportStolen()
			arg:_finish("Safe return complete")
		else
			arg:_finish(fn95() and "Bank not confirmed \226\128\148 retrying" or "Egg lost \226\128\148 retrying")
		end
	end

	index._returnToSafe = function(arg)
		local uid

		if arg:_isPrimerEgg(arg.carry.uid) then
			local uid2 = arg.carry.uid
			arg.stats.lastResult = "Steal not banked \226\128\148 retrying"
			arg.carry.active = false
			arg.carry.uid = nil
			arg.carry.generation += 1
			arg:_invalidateCarryWorker()
			arg.skippedEggs[uid2] = os.clock() + 30
			pcall(EggState2.DropFieldEgg, "PlayerRequest")

			if arg.instantPhase == "priming" then
				arg:_startPrimerTargetHunt()
			else
				task.delay(0.5, function()
					if not arg.destroyed and (arg.enabled and not arg.running) then
						arg:_schedule()
					end
				end)
			end

			arg:_notify()
			return
		end

		if arg.captureObjectiveEnabled and arg:_isCaptureEgg(arg.carry.uid) then
			arg:_captureHold(arg.carry.uid)
			return
		end

		if genv.__SenaV4AdminBoost == true then
			uid = arg.carry.uid or arg.activeTarget and arg.activeTarget.Uid

			if uid and arg._adminBusyUid ~= uid then
				task.spawn(arg._adminDeliver, arg, uid)
			end

			return
		end

		if arg.config.stealMode == "Instant" or arg.config.stealMode == "Fly" then
			uid = arg.carry.uid or arg.activeTarget and arg.activeTarget.Uid
			if uid then
				arg:_instantReturn(uid)
				return
			end
			arg:_finish("Carry lost \226\128\148 retrying")
			return
		end

		local uid2 = arg.carry.uid
		local v8 = arg:_claimCarryWorker("return", uid2)
		if not v8 then
			return
		end
		arg:_clearArrivalHold(uid2)

		if not arg:_wallOpen() then
			arg:_releaseCarryWorker(v8)
			arg:_finish("Reset interrupted carry")
			return
		end

		local character = localPlayer2.Character
		local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

		if not humanoidRootPart then
			arg:_releaseCarryWorker(v8)
			arg:_finish("Character unavailable")
			return
		end

		local v9 = arg:_hasConfirmedCarry(uid2)

		if if v9 then arg:_recordShowsForeignCarry(uid2) else not v9 then
			arg:_releaseCarryWorker(v8)
			arg:_finish("Carry not confirmed \226\128\148 retrying")
			return
		end

		if arg:_isInSafeArea(humanoidRootPart) then
			arg:_finalizeReturn(v8)
			return
		end

		if senaV4Config.HelpFriend then
			arg.handoffLane = (arg.handoffLane or 0) % #tbl13 + 1
			local n70 = CFrame.new(n20, vector2.Y, tbl13[arg.handoffLane]) * humanoidRootPart.CFrame.Rotation
			arg:_setStatus("Taking the egg to the friend drop")

			arg:_tweenRoot(n70, function()
				if arg:_isCarryWorkerCurrent(v8) then
					task.spawn(arg._handOffEgg, arg, v8, uid2, n70)
				end
			end, nil, {flightProfile = true})

			return
		end

		local v10 = arg:_resolveSafeCFrame(humanoidRootPart)

		if not v10 then
			arg:_releaseCarryWorker(v8)
			arg:_finish("Safe destination unavailable")
			return
		end

		arg:_setStatus("Returning to safe area")

		arg:_tweenRoot(v10, function()
			if arg:_isCarryWorkerCurrent(v8) then
				arg:_finalizeReturn(v8)
			end
		end, nil, {flightProfile = true})
	end

	index._handOffEgg = function(arg, arg2, arg3, cFrame)
		local function fn94()
			local humanoidRootPart = localPlayer2.Character and localPlayer2.Character:FindFirstChild("HumanoidRootPart")
			if not humanoidRootPart then
				return false
			end
			humanoidRootPart.CFrame = cFrame
			humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
			humanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
			return true
		end

		local function fn95()
			local v8 = EggState2.ReadFieldEgg(arg3)
			return v8 ~= nil and v8.State == AreaEggs.States.Carried and v8.CarrierUserId == localPlayer2.UserId
		end

		arg:_setStatus("Dropping the egg for a friend")
		local n70 = 0.1

		pcall(function()
			n70 = localPlayer2:GetNetworkPing() or 0.1
		end)

		local n71 = os.clock() + math.max(0.3, 0.2 + 2 * n70)

		while os.clock() < n71 do
			if not fn94() then
				break
			end
			RunService2.Heartbeat:Wait()
		end

		arg.skippedEggs[arg3] = os.clock() + 1800
		arg:_reportStolen()
		n71 = false

		for i = 1, 4, 1 do
			fn94()
			local v8 = n71
			if not fn95() then
				n71 = true
				break
			end
			pcall(EggState2.DropFieldEgg, "PlayerRequest")
			local n72 = os.clock() + 0.6
			n71 = v8

			repeat
				RunService2.Heartbeat:Wait()
				n71 = not fn95()
			until n71 or os.clock() >= n72

			if n71 then
				break
			end
		end

		if not n71 then
			arg.skippedEggs[arg3] = nil

			if arg:_isCarryWorkerCurrent(arg2) then
				arg:_releaseCarryWorker(arg2)
				arg:_finish("Friend drop failed \226\128\148 retrying")
			end

			return
		end

		local n72 = os.clock() + 1

		while arg.carry.active and os.clock() < n72 do
			RunService2.Heartbeat:Wait()
		end

		arg.carry.active = false
		arg.carry.uid = nil
		arg.stats.lastResult = "Dropped for a friend"
		local humanoidRootPart = localPlayer2.Character and localPlayer2.Character:FindFirstChild("HumanoidRootPart")
		local v8 = humanoidRootPart and arg:_resolveSafeCFrame(humanoidRootPart)
		if not v8 then
			arg:_finish("Dropped for a friend")
			return
		end
		arg:_setStatus("Egg dropped for a friend, heading back")

		arg:_tweenRoot(v8, nil, nil, {flightProfile = true, onDone = function()
			arg:_finish("Dropped for a friend")
		end})
	end

	index._reportStolen = function(arg)
		local activeTarget = arg.activeTarget

		if type(activeTarget) ~= "table" then
			return
		elseif not activeTarget.Uid then
			return
		end

		if arg.reportedUid == activeTarget.Uid then
			return
		end
		arg.reportedUid = activeTarget.Uid

		task.delay(1.5, function()
			if arg.destroyed then
				return
			end
			local v8

			pcall(function()
				v8 = EggState2.ReadFieldEgg(activeTarget.Uid)
			end)

			if type(v8) == "table" and (v8.State == AreaEggs.States.Slot or v8.State == AreaEggs.States.Dropped or v8.State == AreaEggs.States.Carried and v8.CarrierUserId ~= localPlayer2.UserId) then
				arg.reportedUid = nil
				arg.stats.deliveryFailed = (arg.stats.deliveryFailed or 0) + 1
				arg.stats.lastResult = "Delivery failed \226\128\148 retrying"
				arg:_notify()

				if arg.enabled and not arg.running then
					arg:_schedule()
				end

				return
			end

			arg.stats.delivered = (arg.stats.delivered or 0) + 1
			local senaV4Webhook = genv.__SenaV4Webhook
			if not senaV4Webhook then
				return
			end
			local ok, result = pcall(arg.catalog.resolve, activeTarget)
			pcall(senaV4Webhook.stolen, activeTarget, ok and result or nil, nil)
		end)
	end

	index._startWatchdog = function(arg)
		if arg.watchdogRunning then
			return
		end
		arg.watchdogRunning = true

		task.spawn(function()
			local v8 = nil
			local position = nil
			local now = nil
			local v9 = nil
			local v10 = nil
			local now2 = os.clock()

			while fn2() and not arg.destroyed and arg.userStealEnabled do
				task.wait(2)
				local humanoidRootPart = localPlayer2.Character and localPlayer2.Character:FindFirstChild("HumanoidRootPart")
				local str10 = tostring(arg.stats.status)

				if arg.enabled then
					if humanoidRootPart then
						if humanoidRootPart.Position.Y > n69 then
							if arg._boostHopUid == nil then
								if arg._recalling then
									arg._biomeStrandedSince = nil
								elseif arg._biomeStrandedSince and os.clock() - arg._biomeStrandedSince >= 2 then
									arg._biomeStrandedSince = nil
									arg.stats.watchdogResets = (arg.stats.watchdogResets or 0) + 1
									arg:_setStatus("Leaving the portal biome")
									arg:_mutePortalFx(true)
									pcall(arg._crossPortal, arg, fn91("FuseBiomeZone", "ExitPart"), nil, 8)
									arg:_mutePortalFx(false)

									if arg.running then
										arg:_finish("Left the portal biome")
									end
								else
									arg._biomeStrandedSince = arg._biomeStrandedSince or os.clock()
								end
							else
								arg._biomeStrandedSince = nil
							end
						else
							arg._biomeStrandedSince = nil
						end
					else
						arg._biomeStrandedSince = nil
					end
				else
					arg._biomeStrandedSince = nil
				end

				if arg.enabled and arg.running and not arg.carry.active and arg.carryAttemptToken == nil and arg._instantReturnToken == nil and not arg._captureHoldUid and humanoidRootPart and str10 == v8 and position and (humanoidRootPart.Position - position).Magnitude < 3 then
					if os.clock() - now > 12 then
						arg.stats.watchdogResets = (arg.stats.watchdogResets or 0) + 1

						pcall(function()
							arg:_invalidateCarryWorker()
						end)

						arg:_finish("Stuck - retrying")
						arg:_releaseOperation()
						v8 = nil
						position = nil
						now = nil
						v9 = nil
					end
				else
					v8 = str10
					position = humanoidRootPart and humanoidRootPart.Position
					now = os.clock()
				end

				if arg.enabled then
					str10, humanoidRootPart = nil

					if arg._captureHoldUid then
						local v11 = nil
						local v12 = nil
						v9 = v11
						v10 = v12
					else
						if arg.running then
							local v11 = nil
							local str11 = tostring(arg.activeTarget and arg.activeTarget.Uid) .. "|" .. tostring(arg.carry.active)

							if str11 ~= v9 then
								local now3 = os.clock()
								v9 = str11
								now2 = now3
							else
								if os.clock() - now2 > 60 then
									arg.stats.watchdogResets = (arg.stats.watchdogResets or 0) + 1
									local uid = arg.activeTarget and arg.activeTarget.Uid

									if uid and not arg.carry.active then
										arg.skippedEggs[uid] = os.clock() + n38

										if arg.tweenRecoveryUid == uid then
											arg.tweenRecoveryUid = nil
										end
									end

									pcall(function()
										arg:_invalidateCarryWorker()
									end)

									arg:_finish("Stuck \226\128\148 retrying")
									v9 = nil
								end
							end

							v10 = v11
						else
							local v11 = nil
							local ok, result = pcall(arg._chooseTarget, arg)

							if arg:_wallOpen() then
								if ok then
									if result ~= nil then
										local now3 = v10 or os.clock()

										if os.clock() - now3 > 6 then
											arg.stats.watchdogResets = (arg.stats.watchdogResets or 0) + 1
											arg:_releaseOperation()
											arg:_schedule()
											v10 = nil
										else
											v10 = now3
										end
									else
										v10 = nil
									end
								else
									v10 = nil
								end
							else
								v10 = nil
							end

							v9 = v11
						end
					end
				else
					local v11, v12
					v9 = v11
					v10 = v12
				end
			end

			arg.watchdogRunning = false
		end)
	end

	index._finalizeReturn = function(arg, arg2)
		if not arg:_isCarryWorkerCurrent(arg2) then
			return
		end

		if not arg.carry.active then
			arg:_releaseCarryWorker(arg2)
			arg:_reportStolen()
			arg:_finish("Safe return complete")
			return
		end

		arg:_setStatus("Validating safe arrival")
		local now = os.clock()
		local n70 = os.clock() + 6

		while arg:_isCarryWorkerCurrent(arg2) and arg.carry.active and os.clock() < n70 do
			local humanoidRootPart = localPlayer2.Character and localPlayer2.Character:FindFirstChild("HumanoidRootPart")

			if not humanoidRootPart then
				arg:_releaseCarryWorker(arg2)
				arg:_finish("Character unavailable")
				return
			end

			if not arg:_isInSafeArea(humanoidRootPart) then
				arg:_setStatus("Rollback detected \226\128\148 returning again")
				arg:_releaseCarryWorker(arg2)

				task.defer(function()
					if not arg.destroyed and (arg.enabled and arg.carry.active) then
						arg:_returnToSafe()
					end
				end)

				return
			end

			if os.clock() - now >= n42 then
				arg:_setStatus("Waiting for deposit")
			end

			task.wait(n43)
		end

		if not arg:_isCarryWorkerCurrent(arg2) then
			return
		end

		if not arg.carry.active then
			arg:_releaseCarryWorker(arg2)
			arg:_reportStolen()
			arg:_finish("Safe return complete")
			return
		end

		arg:_setStatus("Deposit pending \226\128\148 validating again")

		task.defer(function()
			if arg:_isCarryWorkerCurrent(arg2) and arg.carry.active then
				arg:_finalizeReturn(arg2)
			end
		end)
	end

	index._finish = function(arg, arg2)
		arg:_noteLowSpeedOutcome(arg2)
		arg:_hideTreadmillDecoy()
		arg._forestDropInProgress = nil
		arg._instantReturnToken = nil
		arg.boostedUid = nil
		arg:_invalidateCarryWorker()
		arg.planGeneration = arg.planGeneration + 1
		arg:_cancelTween(arg2, arg.enabled)
		arg:_setStatus(arg.enabled and "Searching" or "Idle")

		if arg.enabled then
			task.delay(n12, function()
				if arg.destroyed then
					arg:_releaseOperation()
					return
				elseif not arg.enabled then
					arg:_releaseOperation()
					return
				end

				arg:_schedule()
			end)
		end
	end

	index._scheduleMovementRetry = function(arg)
		if arg.movementRetryPending then
			return
		elseif arg.destroyed then
			return
		elseif not arg.enabled then
			return
		end

		arg.movementRetryPending = true

		task.delay(0.2, function()
			arg.movementRetryPending = false

			if not arg.destroyed and arg.enabled then
				arg:_schedule()
			end
		end)
	end

	index._eggCount = function(arg)
		local ok, result = pcall(function()
			local n70 = 0

			for k in pairs(require(ReplicatedStorage2.Shared.Save).Peek().EggInventory or {}) do
				n70 += 1
			end

			return n70
		end)

		return ok and result or nil
	end

	index._eggInventoryFull = function(arg)
		local eggFullCount = arg.eggFullCount
		if not eggFullCount then
			return false
		end
		local v8 = arg:_eggCount()
		if not v8 then
			return true
		end

		if v8 > eggFullCount then
			arg.eggFullCount = nil
			arg._eggFullHold = false
			return false
		end

		if v8 >= eggFullCount then
			arg._eggFullHold = true
			local senaV4IsAutoSellEggBusy = genv.__SenaV4IsAutoSellEggBusy and genv.__SenaV4IsAutoSellEggBusy()
			arg._eggFullAt = arg._eggFullAt or os.clock()

			if not senaV4IsAutoSellEggBusy and os.clock() - arg._eggFullAt > 60 then
				arg.eggFullCount = nil
				arg._eggFullHold = false
				arg._eggFullAt = nil
				return false
			end

			return true
		end

		arg._eggFullAt = nil

		if arg._eggFullHold then
			if genv.__SenaV4IsAutoSellEggBusy and (genv.__SenaV4IsAutoSellEggBusy() and v8 > eggFullCount - index.EGG_FREE_SLOTS) then
				return true
			end
			arg._eggFullHold = false
			arg.eggFullNotified = nil
		end

		return false
	end

	index._schedule = function(arg)
		if not arg.running then
			arg.safeStarting = false
		end

		if arg.destroyed then
			return
		elseif arg.enabled then
			if arg.running then
				return
			end
		else
			return
		end

		if not arg.carry.active and arg:_eggInventoryFull() then
			arg:_releaseOperation()
			arg:_setStatus("Egg inventory full - place, hatch or sell eggs")

			if not arg.eggFullNotified then
				arg.eggFullNotified = true

				pcall(function()
					game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Auto Steal", Text = "Egg inventory full. Place, hatch or sell eggs and it continues by itself.", Duration = 6})
				end)
			end

			task.delay(3, function()
				if not arg.destroyed and (arg.enabled and not arg.running) then
					arg:_schedule()
				end
			end)

			return
		end

		local character = localPlayer2.Character
		local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")

		if if humanoidRootPart then not humanoid else not humanoidRootPart then
			arg:_releaseOperation()
			arg:_setStatus("Character unavailable")
			return
		end

		arg:_startMovementProtection()

		if arg.carry.active and arg.carry.uid ~= nil then
			if arg.instantPhase == "priming" and arg.carry.uid == arg.primerUid then
				return
			end

			if arg:_isPrimerEgg(arg.carry.uid) then
				arg:_setStatus("Dropping primer egg")
				arg.skippedEggs[arg.carry.uid] = os.clock() + 30
				pcall(EggState2.DropFieldEgg, "PlayerRequest")

				task.delay(0.5, function()
					if not arg.destroyed and arg.enabled then
						arg:_schedule()
					end
				end)

				return
			end

			local v8 = arg.records[arg.carry.uid] or EggState2.ReadFieldEgg(arg.carry.uid)
			local captureObjectiveEnabled = type(v8) == "table" and (arg.riftWants[v8.AssetCategory] or arg.captureObjectiveEnabled and arg:_isCaptureEgg(v8.Uid) or arg.indexObjectiveEnabled and arg:_isIndexObjective(v8) or arg.wispObjective and arg:_isWispObjective(v8) or arg.userStealEnabled and not arg.riftOnly and arg:_matchesNormalFilter(v8))

			if type(v8) == "table" and not captureObjectiveEnabled then
				arg:_setStatus("Dropping unwanted egg")
				arg.skippedEggs[arg.carry.uid] = os.clock() + 30
				pcall(EggState2.DropFieldEgg, "PlayerRequest")

				task.delay(0.5, function()
					if not arg.destroyed and arg.enabled then
						arg:_schedule()
					end
				end)

				return
			end

			arg:_returnToSafe()
			return
		end

		if not arg:_wallOpen() then
			arg:_releaseOperation()
			arg:_setStatus("Waiting for reset wall")
			return
		end

		local senaV4PlayerSteal = genv.__SenaV4PlayerSteal
		local autoSteal = senaV4TaskLadder.blocker("auto_steal")
		local v8 = (if autoSteal then not autoSteal else senaV4TaskLadder.holder("auto_steal")) or nil

		if autoSteal or v8 or senaV4PlayerSteal and senaV4PlayerSteal.running then
			arg:_releaseOperation()
			arg:_setStatus(autoSteal and "Yielding to " .. senaV4TaskLadder.TITLES[autoSteal] or v8 and "Waiting for " .. senaV4TaskLadder.TITLES[v8] .. " to hand over" or "Yielding to Steal Players")
			if arg._yieldRetryPending then
				return
			end
			arg._yieldRetryPending = true

			task.delay((autoSteal or v8) and 1 or 0.5, function()
				arg._yieldRetryPending = nil

				if not arg.destroyed and arg.enabled then
					arg:_schedule()
				end
			end)

			return
		end

		character = arg.tweenRecoveryUid
		local v9 = character and (EggState2.ReadFieldEgg(character) or arg.records[character]) or nil

		if character and (type(v9) ~= "table" or v9.State ~= AreaEggs.States.Slot and v9.State ~= AreaEggs.States.Dropped) then
			arg.tweenRecoveryUid = nil
			v9 = nil
			character = nil
		end

		local v10

		if v9 then
			v10 = v9
		else
			v10 = arg:_chooseTarget()
		end

		if not v10 then
			if arg.stats.matching == 0 then
				if arg.stats.available > 0 then
					local minWeightKg = arg.config.minWeightKg

					if minWeightKg then
						if minWeightKg > 0 then
							arg:_setStatus(string.format("No eggs \226\137\165 %dKg", arg.config.minWeightKg))
						else
							arg:_setStatus("No matching eggs")
						end
					else
						arg:_setStatus("No matching eggs")
					end
				else
					arg:_setStatus("No matching eggs")
				end
			else
				arg:_setStatus("No matching eggs")
			end

			arg:_releaseOperation()

			if not arg.activeTween and (arg:_isInField(humanoidRootPart) and not arg:_isInSafeArea(humanoidRootPart)) then
				local v11 = arg:_resolveSafeCFrame(humanoidRootPart)

				if v11 then
					arg:_tweenRoot(v11, nil, nil, {silent = true, flightProfile = true, abort = function()
						local enabled = arg.enabled
						return if enabled then arg.running else not enabled
					end})
				end
			end

			return
		end

		if arg.treadmillManager and arg.treadmillManager:isEngaged() then
			arg.treadmillManager:_cancelIdle(true)
		end

		local planGeneration = arg.planGeneration
		senaV4PlayerSteal, autoSteal = arg:_acquireOperation()

		if not senaV4PlayerSteal then
			arg:_setStatus("Waiting \194\183 " .. tostring(autoSteal or "another operation"))

			task.delay(0.5, function()
				if not arg.destroyed and (arg.enabled and arg.planGeneration == planGeneration) then
					arg:_schedule()
				end
			end)

			return
		end

		arg.safeStarting = true
		arg.running = true
		arg.activeTarget = v10
		local v11 = arg.catalog.resolve(v10)
		arg.stats.lastTarget = string.format("%s \194\183 %s \194\183 %s", v11.rarity, v11.name, v10.AreaId)

		if character then
			arg.safeStarting = false
			arg.stats.lastResult = "Recovering with tween"
			local v12 = arg:_resolveEggDestination(v10, humanoidRootPart, humanoid)

			if not v12 then
				arg.tweenRecoveryUid = nil
				arg:_finish("Recovery destination unavailable")
				return
			end

			arg:_setStatus("Returning to egg")

			arg:_tweenRoot(v12, function()
				if arg.tweenRecoveryUid == v10.Uid then
					arg:_requestCarry(v10, false)
				end
			end, nil, {holdAfterArrival = true, holdUid = v10.Uid, flightProfile = true, carryTarget = v10})

			return
		end

		if not arg:_leftTreadmill(humanoidRootPart) then
			arg.running = false
			arg.safeStarting = false
			arg.activeTarget = nil
			arg:_releaseOperation()
			arg:_setStatus("Preparing steal")

			task.delay(0.3, function()
				if not arg.destroyed and (arg.enabled and arg.planGeneration == planGeneration) then
					arg:_schedule()
				end
			end)

			return
		end

		if genv.__SenaV4AdminBoost == true and not (arg.captureObjectiveEnabled and arg:_isCaptureEgg(v10.Uid)) then
			arg.safeStarting = false
			task.spawn(arg._adminSteal, arg, v10)
			return
		end

		autoSteal = humanoidRootPart.Position - vector2
		local magnitude = Vector2.new(autoSteal.X, autoSteal.Z).Magnitude
		character = if arg:_usesPortalBoost(v10) then true else false

		if arg.config.stealMode == "Fly" then
			local bottomCFrame = v10.BottomCFrame or v10.BoundsCFrame

			if bottomCFrame then
				local n70 = bottomCFrame.Position - humanoidRootPart.Position
				character = if Vector2.new(n70.X, n70.Z).Magnitude < magnitude then true else character
			end
		end

		if not character and (magnitude > 3 and os.clock() - (arg.lastSafeRepositionAt or 0) > 5) then
			local v12 = arg:_resolveSafeCFrame(humanoidRootPart)

			if v12 then
				arg.safeStarting = true
				arg.running = true
				arg.lastSafeRepositionAt = os.clock()
				arg:_setStatus("Repositioning to safe area")

				arg:_tweenRoot(v12, function()
					arg:_groundSnap()
					arg.safeStarting = false
					arg.running = false

					task.delay(0.15, function()
						if not arg.destroyed and (arg.enabled and arg.planGeneration == planGeneration) then
							arg:_schedule()
						end
					end)
				end, nil, {flightProfile = true})

				return
			end
		end

		arg.safeStarting = false

		if arg:_usesPortalBoost(v10) then
			arg.instantPhase = "hunting"
			arg.primerUid = nil
			arg.targetUid = nil
			arg.activeTarget = v10
			arg._flyDeparting = false
			arg:_installGuardHitDistanceBoost()
			arg:_startMovementProtection()
			arg:_showTreadmillDecoy()
			arg.stats.lastResult = "Low Speed Boost"
			task.spawn(arg._portalBoostSteal, arg, v10)
			return
		end

		if arg.config.stealMode == "Fly" then
			arg.instantPhase = "priming"
			arg.primerUid = nil
			arg.targetUid = v10.Uid
			arg.activeTarget = v10
			arg._flyDeparting = false
			arg.lowFpsPrime = false
			arg:_installGuardHitDistanceBoost()
			arg:_startMovementProtection()
			arg.stats.lastResult = "High Speed departing"
			arg:_startPrimerTargetHunt()
			return
		end

		local v12 = arg:_choosePrimerEgg(v10.Uid)

		if not v12 then
			arg.running = false
			arg.activeTarget = nil
			arg:_releaseOperation()
			arg:_setStatus("Preparing steal")

			task.delay(0.25, function()
				if not arg.destroyed and (arg.enabled and arg.planGeneration == planGeneration) then
					arg:_schedule()
				end
			end)

			return
		end

		arg.instantPhase = "priming"
		arg.primerUid = v12.Uid
		arg.primerUids[v12.Uid] = os.clock() + 120
		arg.skippedEggs[v12.Uid] = os.clock() + 30
		arg.targetUid = v10.Uid
		arg.activeTarget = v12
		arg._flyDeparting = arg.config.stealMode == "Fly"

		if arg.config.stealMode == "Instant" then
			arg:_showTreadmillDecoy()
		end

		arg:_installGuardHitDistanceBoost()
		arg.stats.lastResult = arg.config.stealMode .. " priming"
		arg.lowFpsPrime = fn3() < 30
		local v13 = arg:_resolveEggDestination(v12, humanoidRootPart, humanoid)
		if not v13 then
			arg:_finish("Steal unavailable \226\128\148 retrying")
			return
		end

		if arg.lowFpsPrime then
			arg:_setStatus("Preparing steal")

			arg:_tweenRoot(v13, function()
				if arg.instantPhase == "priming" and arg.primerUid == v12.Uid then
					arg:_requestCarry(v12, false)
				end
			end, nil, {holdAfterArrival = true, holdUid = v12.Uid, flightProfile = true, carryTarget = v12})

			return
		end

		if arg.config.stealMode == "Fly" then
			arg:_setStatus("Preparing steal")

			local function fn94()
				return arg.destroyed or not arg.enabled or arg.instantPhase ~= "priming" or arg.primerUid ~= v12.Uid
			end

			if not arg:_glideRoot(v13, fn94) then
				if arg.instantPhase == "priming" and arg.primerUid == v12.Uid then
					arg:_finish("Steal unavailable \226\128\148 retrying")
				end

				return
			end

			arg:_setArrivalHold(v13, v12.Uid)
			arg:_requestCarry(v12, true)
			return
		end

		arg:_setStatus("Preparing steal")
		if not arg:_teleportRoot(humanoidRootPart, humanoid, v13) then
			arg:_finish("Steal unavailable \226\128\148 retrying")
			return
		end
		arg:_setArrivalHold(v13, v12.Uid)
		arg:_requestCarry(v12, true)
	end

	index._leftTreadmill = function(arg, arg2)
		local treadmillManager = arg.treadmillManager
		if not treadmillManager or treadmillManager.destroyed then
			return true
		end

		if not (treadmillManager.activeTreadmill ~= nil) and (not (treadmillManager.treadmillEquipPending == true) and not (treadmillManager.travelingToTreadmill == true)) then
			if arg2 ~= nil then
				if not arg2.Anchored then
					arg.treadmillLeaveAt = nil
					return true
				end
			else
				arg.treadmillLeaveAt = nil
				return true
			end
		end

		local now = os.clock()
		arg.treadmillLeaveAt = arg.treadmillLeaveAt or now
		treadmillManager.idleGeneration = treadmillManager.idleGeneration + 1

		if not arg.treadmillDoffBusy and now - (arg.treadmillDoffAt or 0) > 0.6 then
			arg.treadmillDoffBusy = true
			arg.treadmillDoffAt = now

			task.spawn(function()
				pcall(treadmillManager._requestUnequip, treadmillManager)
				pcall(treadmillManager._syncActiveTreadmillSnapshot, treadmillManager)
				arg.treadmillDoffBusy = false
			end)
		end

		if arg2 and arg2.Anchored and now - arg.treadmillLeaveAt > 1 then
			pcall(function()
				arg2.Anchored = false
			end)
		end

		if now - arg.treadmillLeaveAt > 8 then
			arg.treadmillLeaveAt = nil
			return true
		end
		return false
	end

	index._reconcileRunningState = function(arg)
		local enabled = arg.userStealEnabled == true or next(arg.riftWants) ~= nil or arg.indexObjectiveEnabled == true or arg.wispObjective ~= nil or arg.manualObjectiveEnabled == true or arg.captureObjectiveEnabled == true

		if arg.enabled == enabled then
			if arg.enabled then
				arg:_refreshCounts()
				arg:_schedule()
			end

			return
		end

		arg.enabled = enabled

		if arg.enabled then
			if localPlayer2.Character then
				fn67(localPlayer2.Character)
				fn69(arg, localPlayer2.Character)
			end

			arg:_installGuardHitDistanceBoost()
			arg:_startMovementProtection()
			pcall(arg._installPromptFilter, arg)
			arg:_setStatus("Searching")
			arg:_schedule()
		else
			if arg._instantReturnToken ~= nil and (arg.carry.uid ~= nil and not arg._externalDeliver) then
				arg._externalDeliver = true
				arg.planGeneration = arg.planGeneration + 1
				arg.running = false
				arg:_setStatus("Finishing target egg")

				task.spawn(function()
					local n70 = os.clock() + 45

					while arg._instantReturnToken ~= nil and os.clock() < n70 and not arg.destroyed do
						task.wait(0.2)
					end

					if arg.destroyed then
						return
					elseif arg.enabled then
						return
					end

					arg._externalDeliver = nil
					arg._instantReturnToken = nil
					arg.carry.active = false
					arg.carry.uid = nil
					arg.activeTarget = nil
					arg:_cleanupInstantSteal()
					arg:_removeGuardHitDistanceBoost()
					arg:_restoreTreadmillVisualAtSafe()
					arg:_stopMovementProtection()
					fn68(arg)
					arg:_setStatus("Idle")
				end)

				arg:_refreshCounts()
				return
			end

			local v8 = arg:_needsHiddenRecall()

			if v8 then
				arg._recalling = true
			end

			arg.planGeneration = arg.planGeneration + 1
			arg.carry.generation += 1
			arg:_cleanupInstantSteal()

			if not v8 then
				arg:_removeGuardHitDistanceBoost()
			end

			arg:_invalidateCarryWorker()
			arg._forestDropInProgress = nil
			arg._instantReturnToken = nil
			arg.carry.active = false
			arg.carry.uid = nil
			arg.tweenRecoveryUid = nil
			arg.claimPresentationSuppression = nil
			arg.safeStarting = false
			arg.movementRetryPending = false
			arg:_cancelTween("Disabled")
			arg:_releaseOperation()

			if v8 then
				arg:_recallHidden()
			else
				arg:_restoreTreadmillVisualAtSafe()
				arg:_stopMovementProtection()
				fn68(arg)
			end

			arg.activeTarget = nil
			arg.running = false
			arg:_setStatus("Idle")
		end

		arg:_refreshCounts()
	end

	index.setEnabled = function(arg, arg2)
		arg.userStealEnabled = arg2 == true
		arg:_reconcileRunningState()

		if arg.userStealEnabled then
			arg:_startWatchdog()
		end

		arg:_reconcileScramblePortal()
	end

	local str10 = "ScrambleArenaPortal"

	index._neutralizeScramblePortal = function(arg, arg2)
		if typeof(arg2) ~= "Instance" then
			return
		elseif arg2.Name ~= str10 then
			return
		end

		arg.scramblePortalOriginals = arg.scramblePortalOriginals or {}

		for i, descendant in ipairs(arg2:GetDescendants()) do
			if descendant:IsA("BasePart") then
				if arg.scramblePortalOriginals[descendant] == nil then
					local attribute = descendant:GetAttribute("SenaV4PortalOrig")

					if type(attribute) == "string" then
						arg.scramblePortalOriginals[descendant] = {CanCollide = attribute:sub(1, 1) == "1", CanTouch = attribute:sub(2, 2) == "1"}
					else
						arg.scramblePortalOriginals[descendant] = {CanCollide = descendant.CanCollide, CanTouch = descendant.CanTouch}
						pcall(descendant.SetAttribute, descendant, "SenaV4PortalOrig", (descendant.CanCollide and "1" or "0") .. (descendant.CanTouch and "1" or "0"))
					end
				end

				pcall(function()
					descendant.CanCollide = false
					descendant.CanTouch = false
				end)
			end
		end
	end

	index._startScramblePortalBypass = function(arg)
		local v8 = workspace:FindFirstChild(str10)

		if v8 then
			arg:_neutralizeScramblePortal(v8)
		end

		if not arg.scramblePortalConn then
			arg.scramblePortalConn = workspace.ChildAdded:Connect(function(child)
				if arg.destroyed then
					return
				elseif arg.userStealEnabled then
					if arg._scramblePortalHold then
						return
					end
				else
					return
				end

				if child.Name ~= str10 then
					return
				end

				for i, v9 in ipairs({0, 0.15, 0.4, 0.8}) do
					task.delay(v9, function()
						if not arg.destroyed and (arg.userStealEnabled and (not arg._scramblePortalHold and child.Parent)) then
							arg:_neutralizeScramblePortal(child)
						end
					end)
				end
			end)
		end
	end

	index._stopScramblePortalBypass = function(arg)
		if arg.scramblePortalConn then
			pcall(arg.scramblePortalConn.Disconnect, arg.scramblePortalConn)
			arg.scramblePortalConn = nil
		end

		if arg.scramblePortalOriginals then
			for k, scramblePortalOriginal in pairs(arg.scramblePortalOriginals) do
				if typeof(k) == "Instance" and k.Parent then
					pcall(function()
						k.CanCollide = scramblePortalOriginal.CanCollide
						k.CanTouch = scramblePortalOriginal.CanTouch
						k:SetAttribute("SenaV4PortalOrig", nil)
					end)
				end
			end

			arg.scramblePortalOriginals = nil
		end
	end

	index._setScramblePortalHold = function(arg, arg2)
		local scramblePortalHold = arg2 == true
		if arg._scramblePortalHold == scramblePortalHold then
			return
		end
		arg._scramblePortalHold = scramblePortalHold
		arg:_reconcileScramblePortal()
	end

	index._reconcileScramblePortal = function(arg)
		if arg.userStealEnabled then
			if arg._scramblePortalHold then
				arg:_stopScramblePortalBypass()
			else
				arg:_startScramblePortalBypass()
			end
		else
			arg:_stopScramblePortalBypass()
		end
	end

	index._resolveWeightKg = function(arg, arg2)
		local weightUtil = arg.weightUtil

		if weightUtil then
			if arg2 then
				if arg2.AssetScale then
					if not arg2.AssetCategory then
						return nil
					end
				else
					return nil
				end
			else
				return nil
			end
		else
			return nil
		end

		local ok, result = pcall(weightUtil.WeightKgForScale, arg2.AssetCategory, arg2.AssetScale)
		if ok and type(result) == "number" then
			return result
		end
		return nil
	end

	index.setHeaviestFirst = function(arg, arg2)
		arg.config.heaviestFirst = arg2 == true

		if arg.config.heaviestFirst then
			arg.config.highestValueFirst = false
		end

		arg:_schedule()
	end

	index.setHighestValueFirst = function(arg, arg2)
		arg.config.highestValueFirst = arg2 == true

		if arg.config.highestValueFirst then
			arg.config.heaviestFirst = false
		end

		arg:_schedule()
	end

	local name4 = "__SenaV4EggEsp"
	local name5 = "__SenaV4EggHighlight"
	local tbl18 = {rarity = true, name = true, kg = true, mutation = true, value = true, placed = true, icon = true}

	fn66 = function(arg)
		if type(arg) ~= "table" then
			return nil
		end
		local category = arg.Category or arg.AssetCategory
		local num = tonumber(arg.Scale or arg.AssetScale)

		if type(category) ~= "string" then
			return nil
		elseif num then
			if num <= 0 then
				return nil
			end
		else
			return nil
		end

		local tbl19 = {Category = category, Scale = num, Mutations = type(arg.Mutations) == "table" and table.clone(arg.Mutations) or {}, BaseMutation = type(arg.BaseMutation) == "string" and arg.BaseMutation or nil}
		category, arg = pcall(AssetEarnings.MutationOnlyRatePerSecond, tbl19)
		return category and type(arg) == "number" and arg or nil
	end

	local v8

	local function fn94(arg)
		if type(v8) ~= "table" then
			local ok, result = pcall(require, ReplicatedStorage2.Packages.FormatNumber.Simple)

			if ok and type(result.FormatCompact) == "function" then
				v8 = result
			end
		end

		if v8 then
			local ok, result = pcall(v8.FormatCompact, arg, ".#")
			if ok and type(result) == "string" then
				return result
			end
		end

		local n70 = math.abs(arg)

		if n70 >= 1000000000000 then
			return string.format("%.2fT", arg / 1000000000000)
		elseif n70 >= 1000000000 then
			return string.format("%.2fB", arg / 1000000000)
		elseif n70 >= 1000000 then
			return string.format("%.1fM", arg / 1000000)
		elseif n70 >= 1000 then
			return string.format("%.1fK", arg / 1000)
		end

		return string.format("%d", math.floor(arg + 0.5))
	end

	local n70 = 2
	local n71 = 3.2
	local n72 = 1.25
	local n73 = 597
	local tbl19 = {["Carry not confirmed \226\128\148 retrying"] = true, ["Carry refused \226\128\148 next egg"] = true, ["Carry lost \226\128\148 retrying"] = true, ["Drop failed \226\128\148 retrying"] = true, ["Egg lost \226\128\148 retrying"] = true, ["Re-steal failed \226\128\148 retrying"] = true, ["Steal timed out \226\128\148 retrying"] = true}
	local n74 = 8
	local n75 = 600
	local tbl20 = {}

	local function fn95()
		if next(tbl20) then
			return tbl20
		end
		local v9 = fn()
		local areas = v9 and v9:FindFirstChild("Areas")
		local guardAreas = areas and areas:FindFirstChild("GuardAreas")

		for i, v10 in ipairs(guardAreas and guardAreas:GetChildren() or {}) do
			local closestExitPoint = v10:FindFirstChild("ClosestExitPoint")

			if closestExitPoint and closestExitPoint:IsA("BasePart") then
				tbl20[v10.Name] = closestExitPoint.Position.X
			end
		end

		return tbl20
	end

	index.settleNeed = function(arg, arg2, arg3)
		local v9 = fn95()[arg2]
		return n70 + math.max(0, (v9 or n73) - n73) / (n71 * math.max(arg3, 16))
	end

	index.recommendLowSpeedLevel = function(arg, arg2)
		local v9 = arg2 or fn86()
		local tbl21 = {}

		if arg.config.areaEnabled and #arg.config.areas > 0 then
			tbl21 = arg.config.areas
		else
			for k in pairs(fn95()) do
				tbl21[#tbl21 + 1] = k
			end
		end

		local n76, v10 = 10
		arg2 = 10

		for i, v11 in ipairs(tbl21) do
			if senaV4Config.LowSpeedBoost == true and tbl16[v11] ~= nil then
			else
				local v12 = arg:settleNeed(v11, v9)
				local n77 = 1

				for i2 = 10, 1, -1 do
					if fn87(v11, i2) >= v12 then
						n77 = i2
						break
					end
				end

				i = 1

				for i2 = 10, 1, -1 do
					if fn87(v11, i2) >= v12 * n72 then
						i = i2
						break
					end
				end

				if n77 < n76 then
					n76 = n77
					v10 = v11
				end

				arg2 = math.min(arg2, i)
			end
		end

		local lowSpeedFailCap = arg.lowSpeedFailCap

		if lowSpeedFailCap then
			n76 = math.min(n76, lowSpeedFailCap)
			arg2 = math.min(arg2, lowSpeedFailCap)
		end

		return math.min(arg2, n76), n76, v9, v10
	end

	index._noteLowSpeedOutcome = function(arg, arg2)
		local flag5 = arg._untrustedSeen == true
		arg._untrustedSeen = nil
		if arg.config.stealMode ~= "Instant" then
			return
		end

		if arg.boostedUid ~= nil then
			return
		elseif arg._boostHopUid ~= nil then
			return
		end

		local failed = tbl19[tostring(arg2)] == true or flag5
		if not failed and arg2 ~= "Safe return complete" then
			return
		end
		local n76 = math.clamp(tonumber(senaV4Config.StealHoldSeconds) or 5, 1, 10)
		arg.lowSpeedOutcomes = arg.lowSpeedOutcomes or {}
		flag5 = arg.lowSpeedOutcomes[n76] or {}
		arg.lowSpeedOutcomes[n76] = flag5
		local n77 = #flag5 + 1
		local tbl21 = {}
		tbl21.at, tbl21.failed, flag5[n77] = os.clock(), failed, tbl21

		while #flag5 > n74 do
			table.remove(flag5, 1)
		end

		tbl21 = 0
		n77 = 0

		for i, v9 in ipairs(flag5) do
			if os.clock() - v9.at <= n75 then
				tbl21, n77 = tbl21 + 1, if v9.failed then n77 + 1 else n77
			end
		end

		if n76 > 1 and (n77 >= 3 and n77 / tbl21 >= 0.4) then
			local lowSpeedFailCap = n76 - 1
			local lowSpeedFailCap2 = arg.lowSpeedFailCap

			if if lowSpeedFailCap2 then lowSpeedFailCap < arg.lowSpeedFailCap else not lowSpeedFailCap2 then
				arg.lowSpeedFailCap = lowSpeedFailCap
				arg.lowSpeedAdvice = {from = n76, to = lowSpeedFailCap, fails = n77, total = tbl21, fresh = true}
			end
		end
	end

	index.lowSpeedStatus = function(arg)
		local v9

		pcall(function()
			v9 = SpeedPowerProjection.ReadProjected()
		end)

		local v10, v11, v12 = arg:recommendLowSpeedLevel()
		local n76 = math.clamp(tonumber(senaV4Config.StealHoldSeconds) or 5, 1, 10)
		local lowSpeedAdvice = arg.lowSpeedAdvice
		local v13 = lowSpeedAdvice and (if n76 <= lowSpeedAdvice.to then nil else lowSpeedAdvice)
		return {speedText = type(v9) == "number" and fn94(v9) or "?", walkSpeed = math.floor((v12 or 0) + 0.5), safe = v10, fast = v11, level = n76, advice = v13}
	end

	index.setEggEsp = function(arg, arg2)
		arg.config.espEnabled = arg2 == true

		if not arg.config.espEnabled then
			pcall(function()
				arg:_clearEsp()
			end)
		end
	end

	index.setEspMinRank = function(arg, arg2)
		arg.config.espMinRank = math.max(tonumber(arg2) or 0, 0)
	end

	index.setEspMinValue = function(arg, arg2)
		arg.config.espMinValue = math.max(tonumber(arg2) or 0, 0)
	end

	index._espPasses = function(arg, arg2, arg3)
		local config = arg.config
		local espMinRank = config.espMinRank
		if espMinRank and (espMinRank > 0 and (tonumber(arg2 and arg2.rarityRank) or 0) < config.espMinRank) then
			return false
		end
		local espMinValue = config.espMinValue
		if espMinValue and (espMinValue > 0 and (tonumber(arg3) or 0) < config.espMinValue) then
			return false
		end
		return true
	end

	index.setEspOption = function(arg, arg2, arg3)
		if tbl18[arg2] then
			arg.config["esp" .. arg2:sub(1, 1):upper() .. arg2:sub(2)] = arg3 == true
		end
	end

	index._clearEsp = function(arg)
		local areaEggSlotsClient = workspace:FindFirstChild("AreaEggSlotsClient")
		if not areaEggSlotsClient then
			return
		end

		for i, child in ipairs(areaEggSlotsClient:GetChildren()) do
			local v9 = child:FindFirstChild(name4)

			if v9 then
				v9:Destroy()
			end

			local v10 = child:FindFirstChild(name5)

			if v10 then
				v10:Destroy()
			end
		end
	end

	index._updateEsp = function(arg)
		local areaEggSlotsClient = workspace:FindFirstChild("AreaEggSlotsClient")
		if not areaEggSlotsClient then
			return
		end
		local config = arg.config

		for i, child in ipairs(areaEggSlotsClient:GetChildren()) do
			local v9 = arg.records[child.Name]
			local flag5 = config.espEnabled and v9 ~= nil and (v9.State == AreaEggs.States.Slot or v9.State == AreaEggs.States.Dropped)
			local v10 = flag5 and (if arg:_espPasses(arg.catalog.resolve(v9), fn66(v9)) then flag5 else false)
			local hitbox = v10 and (child:FindFirstChild("Hitbox") or child:FindFirstChildWhichIsA("BasePart", true))
			local billboardGui = child:FindFirstChild(name4)
			local highlight = child:FindFirstChild(name5)

			if if v10 then not hitbox else not v10 then
				if billboardGui then
					billboardGui:Destroy()
				end

				if highlight then
					highlight:Destroy()
				end
			else
				if billboardGui then
					if billboardGui:FindFirstChild("Icon") then
					else
						billboardGui:Destroy()
						billboardGui = nil
					end
				end

				if billboardGui then
				else
					billboardGui = Instance.new("BillboardGui")
					billboardGui.Name = name4
					billboardGui.AlwaysOnTop = true
					billboardGui.Size = UDim2.fromOffset(220, 72)
					billboardGui.StudsOffset = Vector3.new(0, 4.4, 0)
					billboardGui.MaxDistance = 1000
					billboardGui.Adornee = hitbox
					local imageLabel = Instance.new("ImageLabel")
					imageLabel.Name = "Icon"
					imageLabel.AnchorPoint = Vector2.new(0.5, 1)
					imageLabel.Position = UDim2.fromScale(0.5, 0.42)
					imageLabel.Size = UDim2.fromOffset(30, 30)
					imageLabel.BackgroundTransparency = 1
					imageLabel.ScaleType = Enum.ScaleType.Fit
					imageLabel.Visible = false
					imageLabel.Parent = billboardGui
					local textLabel = Instance.new("TextLabel")
					textLabel.Name = "Text"
					textLabel.AnchorPoint = Vector2.new(0.5, 0)
					textLabel.Position = UDim2.fromScale(0.5, 0.45)
					textLabel.Size = UDim2.new(1, 0, 0.55, 0)
					textLabel.BackgroundTransparency = 1
					textLabel.Font = Enum.Font.GothamBold
					textLabel.TextSize = 13
					textLabel.TextStrokeTransparency = 0.35
					textLabel.TextXAlignment = Enum.TextXAlignment.Center
					textLabel.TextYAlignment = Enum.TextYAlignment.Top
					textLabel.Parent = billboardGui
					billboardGui.Parent = child
				end

				billboardGui.Adornee = hitbox
				local tbl21 = arg.catalog.resolve(v9)
				local icon = billboardGui:FindFirstChild("Icon")
				local icon2 = config.espIcon and type(tbl21.icon) == "string" and tbl21.icon ~= "" and tbl21.icon or nil
				icon.Image = icon2 or ""
				icon.Visible = icon2 ~= nil
				local rarityColor = typeof(tbl21.rarityColor) == "Color3" and tbl21.rarityColor or Color3.fromRGB(255, 255, 255)
				local tbl22 = {}

				if config.espRarity then
					tbl22[#tbl22 + 1] = string.upper(tbl21.rarity or "?")
				end

				if config.espName then
					tbl22[#tbl22 + 1] = tostring(tbl21.name)
				end

				if config.espKg then
					tbl21 = arg:_resolveWeightKg(v9)

					if tbl21 then
						tbl22[#tbl22 + 1] = string.format("%d Kg", math.floor(tbl21))
					end
				end

				if config.espMutation and type(v9.Mutations) == "table" and next(v9.Mutations) then
					tbl21 = {}

					for k, mutation in pairs(v9.Mutations) do
						tbl21[#tbl21 + 1] = tostring(mutation)
					end

					if #tbl21 > 0 then
						table.sort(tbl21)
						tbl22[#tbl22 + 1] = table.concat(tbl21, ", ")
					end
				end

				if config.espValue then
					tbl21 = fn66(v9)

					if tbl21 then
						tbl22[#tbl22 + 1] = "$" .. fn94(tbl21) .. "/s"
					end
				end

				local text = billboardGui:FindFirstChild("Text")
				text.Text = table.concat(tbl22, " | ")
				text.TextColor3 = rarityColor

				if highlight then
					if highlight:IsA("Highlight") then
					else
						highlight:Destroy()
						highlight = nil
					end
				end

				if highlight then
				else
					highlight = Instance.new("Highlight")
					highlight.Name = name5
					highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
					highlight.Parent = child
				end

				highlight.Adornee = child
				highlight.FillColor = rarityColor
				highlight.FillTransparency = 0.72
				highlight.OutlineColor = rarityColor
				highlight.OutlineTransparency = 0
			end
		end

		arg._placedEspAnchors = arg._placedEspAnchors or {}
		os.clock()

		if config.espPlaced then
			local v9 = (Save.Peek or Save.Get)()
			local eggInventory = type(v9) == "table" and v9.EggInventory or nil
			local centerPoint = PlotState2.ResolveLocalSlot()
			local senaV4PlacedEggAnchors = PlotState2.ResolveFolder()
			local v10 = senaV4PlacedEggAnchors and centerPoint and senaV4PlacedEggAnchors:FindFirstChild(tostring(centerPoint))
			centerPoint = v10 and v10:FindFirstChild("CenterPoint")
			local v11 = centerPoint and (if centerPoint:IsA("BasePart") then centerPoint else nil)
			local tbl21 = {}

			if type(eggInventory) == "table" and v11 then
				senaV4PlacedEggAnchors = workspace:FindFirstChild("SenaV4PlacedEggAnchors")

				if senaV4PlacedEggAnchors then
				else
					senaV4PlacedEggAnchors = Instance.new("Folder")
					senaV4PlacedEggAnchors.Name = "SenaV4PlacedEggAnchors"
					senaV4PlacedEggAnchors.Parent = workspace
				end

				for i, child in ipairs(senaV4PlacedEggAnchors:GetChildren()) do
					if child:IsA("Highlight") then
						child:Destroy()
					elseif child:IsA("BillboardGui") then
						child:Destroy()
					end
				end

				for k, v12 in pairs(eggInventory) do
					if type(k) == "string" and (type(v12) == "table" and type(v12.Placement) == "table") then
						tbl21[k] = true
						local localCFrame = v12.Placement.LocalCFrame

						if typeof(localCFrame) ~= "CFrame" then
							local ok, result = pcall(EggRecords.Decode, v12)
							local placement = ok and type(result) == "table" and result.Placement or nil
							localCFrame = type(placement) == "table" and placement.LocalCFrame or nil
						end

						if typeof(localCFrame) == "CFrame" then
							local ok, result = pcall(EggRecords.Decode, v12)
							local flag5 = ok and type(result) == "table" and result or v12
							result = tonumber(flag5.AssetScale) or 1
							local cFrame = v11.CFrame * localCFrame + Vector3.new(0, 3 + result * 2, 0)
							arg._placedEspAnchors[k] = arg._placedEspAnchors[k] or {}
							local v13 = arg._placedEspAnchors[k]

							if typeof(v13.anchor) ~= "Instance" then
								local part = Instance.new("Part")
								part.Name = "SenaV4PE_" .. k
								part.Size = Vector3.new(1.5, 1.5, 1.5)
								part.Transparency = 1
								part.Anchored = true
								part.CanCollide = false
								part.CanQuery = false
								part.CanTouch = false
								part.Parent = senaV4PlacedEggAnchors
								v13.anchor = part
							end

							v13.anchor.CFrame = cFrame
							local v14 = arg.catalog.resolve({AssetCategory = flag5.AssetCategory})
							local rarityColor = typeof(v14.rarityColor) == "Color3" and v14.rarityColor or Color3.fromRGB(255, 255, 255)
							local billboardGui = fn66({Category = flag5.AssetCategory, Mutations = type(flag5.Mutations) == "table" and flag5.Mutations or {}, Scale = result, BaseMutation = type(flag5.BaseMutation) == "string" and flag5.BaseMutation or nil})
							if not arg:_espPasses(v14, billboardGui) then
								tbl21[k] = nil
								continue
							end
							local tbl22 = {}

							if config.espRarity then
								tbl22[#tbl22 + 1] = string.upper(v14.rarity or "?")
							end

							if config.espName then
								tbl22[#tbl22 + 1] = tostring(v14.name)
							end

							if config.espKg then
								local ok2, result2 = pcall(EggRecords.WeightKgForScale, flag5.AssetCategory, result)

								if ok2 and type(result2) == "number" then
									tbl22[#tbl22 + 1] = string.format("%d Kg", math.floor(result2))
								end
							end

							if config.espValue and billboardGui then
								tbl22[#tbl22 + 1] = "$" .. fn94(billboardGui) .. "/s"
							end

							if type(v12.Placement.ReadyAt) == "number" then
								tbl22[#tbl22 + 1] = "READY"
							elseif type(flag5.Placement) == "table" then
								if flag5.Placement.ReadyAt ~= nil then
									tbl22[#tbl22 + 1] = "READY"
								end
							end

							billboardGui = v13.anchor:FindFirstChild(name4)

							if billboardGui then
							else
								billboardGui = Instance.new("BillboardGui")
								billboardGui.Name = name4
								billboardGui.AlwaysOnTop = true
								billboardGui.Size = UDim2.fromOffset(220, 72)
								billboardGui.StudsOffset = Vector3.new(0, 1.4, 0)
								billboardGui.MaxDistance = 1000
								local imageLabel = Instance.new("ImageLabel")
								imageLabel.Name = "Icon"
								imageLabel.AnchorPoint = Vector2.new(0.5, 1)
								imageLabel.Position = UDim2.fromScale(0.5, 0.42)
								imageLabel.Size = UDim2.fromOffset(34, 34)
								imageLabel.BackgroundTransparency = 1
								imageLabel.ScaleType = Enum.ScaleType.Fit
								imageLabel.Visible = false
								imageLabel.Parent = billboardGui
								local textLabel = Instance.new("TextLabel")
								textLabel.Name = "Text"
								textLabel.AnchorPoint = Vector2.new(0.5, 0)
								textLabel.Position = UDim2.fromScale(0.5, 0.45)
								textLabel.Size = UDim2.new(1, 0, 0.55, 0)
								textLabel.BackgroundTransparency = 1
								textLabel.Font = Enum.Font.GothamBold
								textLabel.TextSize = 13
								textLabel.TextStrokeTransparency = 0.35
								textLabel.TextXAlignment = Enum.TextXAlignment.Center
								textLabel.TextYAlignment = Enum.TextYAlignment.Top
								textLabel.Parent = billboardGui
								billboardGui.Parent = v13.anchor
							end

							local icon = billboardGui:FindFirstChild("Icon")

							if icon then
								local icon2 = config.espIcon and type(v14.icon) == "string" and v14.icon ~= "" and v14.icon or nil
								icon.Image = icon2 or ""
								icon.Visible = icon2 ~= nil
							end

							local text = billboardGui:FindFirstChild("Text")
							text.Text = table.concat(tbl22, " | ")
							text.TextColor3 = rarityColor
							local v15 = v13.anchor:FindFirstChild(name5)

							if v15 then
								v15:Destroy()
							end
						end
					end
				end
			end

			for k, placedEspAnchor in pairs(arg._placedEspAnchors) do
				if not tbl21[k] then
					if typeof(placedEspAnchor.anchor) == "Instance" then
						placedEspAnchor.anchor:Destroy()
					end

					if typeof(placedEspAnchor.highlight) == "Instance" then
						placedEspAnchor.highlight:Destroy()
					end

					arg._placedEspAnchors[k] = nil
				end
			end
		else
			for k, v9 in pairs(arg._placedEspAnchors or {}) do
				if typeof(v9.anchor) == "Instance" then
					v9.anchor:Destroy()
				end

				if typeof(v9.highlight) == "Instance" then
					v9.highlight:Destroy()
				end

				arg._placedEspAnchors[k] = nil
			end
		end
	end

	index.setMinWeightKg = function(arg, arg2)
		local n76 = tonumber(arg2) or 0
		arg.config.minWeightKg = math.max(n76, 0)
	end

	index.setMinValuePerSec = function(arg, arg2)
		local n76 = tonumber(arg2) or 0
		arg.config.minValuePerSec = math.max(n76, 0)
		arg:_refreshCounts()
		arg:_schedule()
	end

	index.setSpeed = function(arg, arg2)
		local n76 = math.clamp(math.floor((tonumber(arg2) or n11) + 0.5), n9, n10)
		arg.config.speed = n76 * n8

		if genv.__SenaV4AdminBoost == true then
			arg.config.speed = speed
		end

		if arg.enabled then
			arg:_startMovementProtection()
		elseif arg.activeTween then
			arg:_startMovementProtection()
		end

		return n76
	end

	index.getDefaultSpeed = function(arg)
		return n11
	end

	index.setFilterEnabled = function(arg, arg2, arg3)
		arg.config[arg2 .. "Enabled"] = arg3 == true
		arg:_refreshCounts()
		arg:_schedule()
	end

	index.setFilter = function(arg, arg2, arg3)
		local tbl21 = type(arg3) == "table" and table.clone(arg3) or {}

		if arg2 == "mutations" and type(arg.catalog.resolveMutationId) == "function" then
			local tbl22 = {}

			for i, v9 in ipairs(tbl21) do
				local v10 = arg.catalog.resolveMutationId(v9)

				if v10 then
					table.insert(tbl22, v10)
				end
			end

			tbl21 = tbl22
		end

		arg.config[arg2] = tbl21
		arg:_refreshCounts()
		arg:_schedule()
	end

	index.destroy = function(arg)
		if arg.destroyed then
			return
		end
		arg.destroyed = true
		arg.enabled = false
		arg:_mutePortalFx(false, true)
		pcall(arg._guardLagback, arg, false)
		pcall(arg._stopScramblePortalBypass, arg)
		pcall(arg._removePromptFilter, arg)

		if arg._relocateConn then
			pcall(arg._relocateConn.Disconnect, arg._relocateConn)
			arg._relocateConn = nil
		end

		arg._recalling = nil
		arg:_hideTreadmillDecoy()
		arg.planGeneration = arg.planGeneration + 1
		arg.carry.generation += 1
		arg:_invalidateCarryWorker()
		arg.carry.active = false
		arg.carry.uid = nil
		arg.tweenRecoveryUid = nil
		arg.safeStarting = false
		arg:_cancelTween("Destroyed")
		arg:_cleanupInstantSteal()
		arg:_removeGuardHitDistanceBoost()
		arg:_releaseOperation()
		arg:_stopMovementProtection()

		if arg._healthPinner then
			pcall(arg._healthPinner.Disconnect, arg._healthPinner)
			arg._healthPinner = nil
		end

		if arg._healthChangedConnection then
			pcall(arg._healthChangedConnection.Disconnect, arg._healthChangedConnection)
			arg._healthChangedConnection = nil
		end

		arg:_restoreClaimPresentationFilter()
		fn70(localPlayer2.Character)

		pcall(function()
			arg:_clearEsp()
		end)

		pcall(function()
			for k, v9 in pairs(arg._placedEspAnchors or {}) do
				if typeof(v9.anchor) == "Instance" then
					v9.anchor:Destroy()
				end
			end

			local senaV4PlacedEggAnchors = workspace:FindFirstChild("SenaV4PlacedEggAnchors")

			if senaV4PlacedEggAnchors then
				senaV4PlacedEggAnchors:Destroy()
			end
		end)

		fn64(arg.connections)
		table.clear(arg.listeners)
		table.clear(arg.records)
	end

	return index
end)()

local tbl11 = {k = 1000, m = 1000000, b = 1000000000, t = 1000000000000, q = 1000000000000000}

local function fn61(arg)
	local match, v9 = tostring(arg or ""):lower():gsub("%s+", ""):gsub("%$", ""):gsub("/s$", ""):match("^([%d%.]+)([kmbtq]?)$")
	local num = tonumber(match)
	if not num then
		return nil
	end
	return math.max(0, math.floor(num * (tbl11[v9] or 1) + 0.5))
end

local v9 = (function()
	local Players2 = game:GetService("Players")
	local RunService2 = game:GetService("RunService")
	local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
	local localPlayer2 = Players2.LocalPlayer
	local Remotes = require(ReplicatedStorage2.Shared.Remotes)
	local EggState2 = require(ReplicatedStorage2.Client.EggState)
	local Ragdoll = require(ReplicatedStorage2.Shared.Modules.Ragdoll)
	local RagdollJoints = require(ReplicatedStorage2.Shared.Modules.RagdollJoints)
	local eggWorld = Remotes.EggWorld
	local n8 = 340
	local n9 = 240
	local n10 = 0.05
	local n11 = 5
	local index = {}
	index.__index = index

	local function fn62(arg)
		if arg then
			pcall(arg.Disconnect, arg)
		end
	end

	index.new = function(eggRuntime)
		local obj = setmetatable({}, index)
		obj.eggRuntime = eggRuntime
		obj.enabled = true
		obj.destroyed = false
		obj.connections = {}
		obj.originalRagdoll = {}
		obj.originalHumanoidStates = setmetatable({}, {__mode = "k"})
		obj.stats = {blockedHits = 0, blockedDrops = 0, recarriedEggs = 0}
		obj.lastHeldEggUid = nil
		obj.lastHeldSlotKey = nil
		obj._installed = false
		obj._stickyToken = 0
		obj._nextBodyRecoveryAt = 0
		obj._nextJointSweepAt = 0
		obj._forestStrikeOldFire = nil
		return obj
	end

	index._liveBody = function(arg)
		local character = localPlayer2.Character
		return character, character and character:FindFirstChildOfClass("Humanoid"), character and character:FindFirstChild("HumanoidRootPart")
	end

	index._recoverBody = function(arg, arg2)
		if arg.enabled then
			if arg.destroyed then
				return
			end
		else
			return
		end

		local v9, v10, v11 = arg:_liveBody()

		if v9 then
			if not v10 then
				return
			elseif v11 then
			else
				return
			end
		else
			return
		end

		local now = os.clock()
		if not arg2 and now < arg._nextBodyRecoveryAt then
			return
		end
		arg._nextBodyRecoveryAt = now + 0.03

		if not arg.originalHumanoidStates[v10] then
			local originalHumanoidStates = arg.originalHumanoidStates
			local tbl12 = {}
			tbl12.Physics = v10:GetStateEnabled(Enum.HumanoidStateType.Physics)
			tbl12.FallingDown = v10:GetStateEnabled(Enum.HumanoidStateType.FallingDown)
			tbl12.Ragdoll = v10:GetStateEnabled(Enum.HumanoidStateType.Ragdoll)
			originalHumanoidStates[v10] = tbl12
		end

		local state = v10:GetState()
		local flag5 = state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.FallingDown or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.PlatformStanding or state == Enum.HumanoidStateType.Seated

		pcall(function()
			v10.BreakJointsOnDeath = false
			v10.RequiresNeck = false
			v10:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
			v10:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
			v10:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
			v10:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
			v10.PlatformStand = false
			v10.Sit = false
			local state2 = v10:GetState()

			if state2 == Enum.HumanoidStateType.Physics or state2 == Enum.HumanoidStateType.FallingDown or state2 == Enum.HumanoidStateType.Ragdoll or state2 == Enum.HumanoidStateType.PlatformStanding or state2 == Enum.HumanoidStateType.Seated then
				v10:ChangeState(Enum.HumanoidStateType.GettingUp)
				v10:ChangeState(Enum.HumanoidStateType.Running)
			end
		end)

		for i, descendant in ipairs(v9:GetDescendants()) do
			if descendant:IsA("Motor6D") then
				if not descendant.Enabled then
					descendant.Enabled = true
				end
			elseif descendant:IsA("BallSocketConstraint") or descendant:IsA("HingeConstraint") then
				if descendant.Name:find("Ragdoll", 1, true) then
					pcall(descendant.Destroy, descendant)
				elseif descendant:GetAttribute("RagdollConstraint") then
					pcall(descendant.Destroy, descendant)
				end
			end
		end

		local assemblyLinearVelocity = v11.AssemblyLinearVelocity

		if flag5 or Vector3.new(assemblyLinearVelocity.X, 0, assemblyLinearVelocity.Z).Magnitude > math.max(n8, (tonumber(v10.WalkSpeed) or 0) * 1.5) or math.abs(assemblyLinearVelocity.Y) > n9 then
			v11.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
			v11.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
			arg.stats.blockedHits = arg.stats.blockedHits + 1
		end
	end

	index._watchCharacter = function(arg, arg2)
		if not arg2 then
			return
		end

		local function fn63(descendant)
			if arg.enabled then
				if arg.destroyed then
					return
				end
			else
				return
			end

			if descendant:IsA("BallSocketConstraint") or descendant:IsA("HingeConstraint") then
				if descendant.Name:find("Ragdoll", 1, true) or descendant:GetAttribute("RagdollConstraint") then
					pcall(descendant.Destroy, descendant)
					arg:_recoverBody(true)
				end
			elseif descendant:IsA("Motor6D") then
				if not descendant.Enabled then
					descendant.Enabled = true
				end
			end
		end

		local connection6 = arg2.DescendantAdded:Connect(fn63)
		table.insert(arg.connections, connection6)
	end

	index._installRagdollHooks = function(arg)
		if arg._installed then
			return
		end
		arg._installed = true

		task.spawn(function()
			task.wait()
			local senaV4ForestGate = genv.__SenaV4ForestGate

			if type(senaV4ForestGate) == "table" and (senaV4ForestGate.comp and senaV4ForestGate.orig) then
				pcall(rawset, senaV4ForestGate.comp, "_attackHandler", senaV4ForestGate.orig)
				genv.__SenaV4ForestGate = nil
			end

			if type(getgc) ~= "function" then
				return
			end
			local ok, result = pcall(getgc, true)

			if ok then
				if type(result) ~= "table" then
					return
				end
			else
				return
			end

			for i, v9 in ipairs(result) do
				if i % 20000 == 0 then
					RunService2.Heartbeat:Wait()
				end

				if arg.destroyed then
					return
				end

				if type(v9) == "table" and rawget(v9, "_areaId") == "Forest" and type(rawget(v9, "_attackHandler")) == "function" then
					local value = rawget(v9, "_attackHandler")
					arg._forestGate = {comp = v9, orig = value}
					genv.__SenaV4ForestGate = arg._forestGate

					rawset(v9, "_attackHandler", function(...)
						if arg.enabled and (not arg.destroyed and (not (arg.eggRuntime and arg.eggRuntime.instantPhase == "priming") and not (genv.__SenaV4PlayerSteal and genv.__SenaV4PlayerSteal.running))) then
							arg.stats.blockedHits = arg.stats.blockedHits + 1
							arg:_recoverBody(true)

							if genv.__SenaV4GodMode then
								genv.__SenaV4GodMode:startDefend()
							end

							return
						end

						return value(...)
					end)

					break
				end
			end
		end)

		for i, v9 in ipairs({"ApplyClientRagdoll", "Ragdoll", "TimedRagdoll", "TimedRagdollAsync"}) do
			if type(Ragdoll[v9]) == "function" then
				arg.originalRagdoll[v9] = Ragdoll[v9]

				Ragdoll[v9] = function(...)
					if arg.enabled and not arg.destroyed then
						arg.stats.blockedHits = arg.stats.blockedHits + 1
						arg:_recoverBody(true)
						return
					end

					return arg.originalRagdoll[v9](...)
				end
			end
		end

		if type(Ragdoll.IsRagdolled) == "function" then
			arg.originalRagdoll.IsRagdolled = Ragdoll.IsRagdolled

			function Ragdoll.IsRagdolled(arg2)
				if arg.enabled and arg2 == localPlayer2.Character then
					return false
				end
				return arg.originalRagdoll.IsRagdolled(arg2)
			end
		end
	end

	index._restoreLocalState = function(arg)
		for k, originalHumanoidState in pairs(arg.originalHumanoidStates) do
			if k.Parent then
				pcall(function()
					k:SetStateEnabled(Enum.HumanoidStateType.Physics, originalHumanoidState.Physics)
					k:SetStateEnabled(Enum.HumanoidStateType.FallingDown, originalHumanoidState.FallingDown)
					k:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, originalHumanoidState.Ragdoll)
				end)
			end
		end

		arg.originalHumanoidStates = setmetatable({}, {__mode = "k"})
		pcall(RagdollJoints.Release, localPlayer2.Character)
	end

	index._slotKey = function(arg, arg2)
		if type(arg2) ~= "table" then
			return nil
		elseif type(arg2.AreaId) ~= "string" then
			return nil
		elseif type(arg2.NestId) ~= "string" then
			return nil
		end

		return string.format("%s:%s", arg2.AreaId, arg2.NestId)
	end

	index._requestCarry = function(arg, arg2, firstAreaSlotKey)
		local tbl12 = {Uid = arg2}

		if firstAreaSlotKey ~= nil then
			tbl12.FirstAreaSlotKey = firstAreaSlotKey
		end

		return eggWorld.AskFieldEggCarry:InvokeServer(tbl12)
	end

	index._startSticky = function(arg, lastHeldEggUid, lastHeldSlotKey)
		if type(lastHeldEggUid) ~= "string" then
			return
		elseif lastHeldEggUid == "" then
			return
		end

		arg._stickyToken = arg._stickyToken + 1
		local stickyToken = arg._stickyToken
		arg.stats.recarriedEggs = arg.stats.recarriedEggs + 1

		task.spawn(function()
			local n12 = os.clock() + n11

			while true do
				local destroyed = arg.destroyed
				if not ((if destroyed then not destroyed else arg.enabled) and stickyToken == arg._stickyToken and os.clock() < n12) then
					break
				end
				local v9 = EggState2.ReadFieldEgg(lastHeldEggUid)

				if v9 and (v9.State == "Carried" and v9.CarrierUserId == localPlayer2.UserId) then
					arg.lastHeldEggUid = lastHeldEggUid
					arg.lastHeldSlotKey = lastHeldSlotKey or arg:_slotKey(v9)
					return
				end

				if v9 and (v9.State == "Dropped" or v9.State == "Slot") then
					if arg.eggRuntime and arg.eggRuntime:requestCarryRecovery(lastHeldEggUid) then
						return
					end
					local v10, v11, v12 = arg:_liveBody()

					if v12 and (v9.BottomCFrame and (v12.Position - v9.BottomCFrame.Position).Magnitude <= 10) then
						pcall(arg._requestCarry, arg, lastHeldEggUid, lastHeldSlotKey or arg:_slotKey(v9))
					end
				end

				task.wait(n10)
			end
		end)
	end

	index._bindSignals = function(arg)
		table.insert(arg.connections, EggState2.CarryChanged:Connect(function(arg2)
			if not arg.enabled then
				return
			end

			if arg2.IsCarrying and type(arg2.Uid) == "string" then
				arg._stickyToken = arg._stickyToken + 1
				arg.lastHeldEggUid = arg2.Uid
				arg.lastHeldSlotKey = arg:_slotKey((EggState2.ReadFieldEgg(arg2.Uid)))
				return
			end

			local senaV4PlayerSteal = genv.__SenaV4PlayerSteal
			if senaV4PlayerSteal and senaV4PlayerSteal.running then
				return
			end
			local uid = arg2.Uid or arg.lastHeldEggUid
			local lastHeldSlotKey = arg.lastHeldSlotKey
			if arg.eggRuntime and arg.eggRuntime:isSkippedEgg(uid) then
				return
			end

			if uid then
				arg.stats.blockedDrops = arg.stats.blockedDrops + 1
				arg:_startSticky(uid, lastHeldSlotKey)

				if genv.__SenaV4GodMode then
					genv.__SenaV4GodMode:startDefend(uid)
				end
			end
		end))

		table.insert(arg.connections, localPlayer2.CharacterAdded:Connect(function(character)
			arg:_watchCharacter(character)

			task.defer(function()
				arg:_recoverBody(true)
			end)
		end))

		if localPlayer2.Character then
			arg:_watchCharacter(localPlayer2.Character)
		end

		table.insert(arg.connections, RunService2.Stepped:Connect(function()
			arg:_recoverBody()
		end))
	end

	index.setEnabled = function(arg, arg2)
		local enabled = arg2 == true
		if arg.enabled == enabled then
			return
		end
		arg.enabled = enabled

		if arg.enabled then
			arg:_recoverBody()
		else
			arg._stickyToken = arg._stickyToken + 1
			arg:_restoreLocalState()
		end
	end

	index.install = function(senaV4AntiGuard)
		if senaV4AntiGuard.destroyed then
			return false
		end
		getgenv().__SenaV4AntiGuard = senaV4AntiGuard
		senaV4AntiGuard:_installRagdollHooks()
		senaV4AntiGuard:_bindSignals()
		senaV4AntiGuard:_recoverBody()
		return true
	end

	index.destroy = function(arg)
		if arg.destroyed then
			return
		end
		arg.enabled = false
		arg:_restoreLocalState()
		arg.destroyed = true
		arg._stickyToken = arg._stickyToken + 1

		for i, connection6 in ipairs(arg.connections) do
			fn62(connection6)
		end

		table.clear(arg.connections)

		for k, v9 in pairs(arg.originalRagdoll) do
			if type(v9) == "function" then
				Ragdoll[k] = v9
			end
		end

		if arg._forestGate then
			pcall(rawset, arg._forestGate.comp, "_attackHandler", arg._forestGate.orig)

			if genv.__SenaV4ForestGate == arg._forestGate then
				genv.__SenaV4ForestGate = nil
			end

			arg._forestGate = nil
		end

		arg.eggRuntime = nil

		if getgenv().__SenaV4AntiGuard == arg then
			getgenv().__SenaV4AntiGuard = nil
		end
	end

	index.getStats = function(arg)
		return arg.stats
	end

	return index
end)()

local v10 = (function()
	local Players2 = game:GetService("Players")
	game:GetService("RunService")
	local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
	local localPlayer2 = Players2.LocalPlayer
	local index = {}
	index.__index = index

	index.new = function(eggRuntime)
		local obj = setmetatable({}, index)
		obj.eggRuntime = eggRuntime
		obj.enabled = senaV4Config.GodMode == nil and true or senaV4Config.GodMode == true
		obj.active = false
		obj.activeDroppedUid = nil
		obj.swingSequence = 0
		obj.lastSwingAt = 0
		obj.defendThread = nil
		obj.connections = {}
		obj.targetRange = 35
		obj:_bindSignals()
		return obj
	end

	index._isBat = function(arg, arg2)
		if arg2 then
			if not arg2:IsA("Tool") then
				return false
			end
		else
			return false
		end

		local senaV4IsBatTool = genv.__SenaV4IsBatTool
		if senaV4IsBatTool and senaV4IsBatTool(arg2) then
			return true
		end

		if not senaV4IsBatTool then
			if arg2:GetAttribute("IsBat") == true then
				return true
			elseif arg2:GetAttribute("GearName") == "Bat" then
				return true
			end
		end

		local attribute = arg2:GetAttribute("ItemType")
		if attribute ~= nil and attribute ~= "Gear" then
			return false
		end
		return string.find(string.lower(arg2.Name), "slap", 1, true) ~= nil
	end

	index._findBat = function(arg)
		local character = localPlayer2.Character
		local backpack = localPlayer2:FindFirstChildOfClass("Backpack")

		if character then
			for i, child in ipairs(character:GetChildren()) do
				if arg:_isBat(child) then
					return child, true
				end
			end
		end

		if backpack then
			for i, child in ipairs(backpack:GetChildren()) do
				if arg:_isBat(child) then
					return child, false
				end
			end
		end

		pcall(function()
			local networking = ReplicatedStorage2:FindFirstChild("Packages") and ReplicatedStorage2.Packages:FindFirstChild("Networking")
			local rfCodexAskWearFieldBat = networking and networking:FindFirstChild("RF/Codex/AskWearFieldBat")

			if rfCodexAskWearFieldBat then
				rfCodexAskWearFieldBat:InvokeServer()
			end
		end)

		return nil, false
	end

	index._equipBat = function(arg)
		local character = localPlayer2.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")

		if humanoid then
			if humanoid.Health <= 0 then
				return nil
			end
		else
			return nil
		end

		local v10, v11 = arg:_findBat()
		if not v10 then
			return nil
		end

		if v11 and v10.Parent == character then
			return v10
		end
		pcall(humanoid.EquipTool, humanoid, v10)
		local n8 = os.clock() + 0.35

		while os.clock() < n8 do
			if v10.Parent == character then
				return v10
			end
			task.wait(0.05)
		end

		return v10.Parent == character and v10 or nil
	end

	index._getNearbyEnemies = function(arg)
		local character = localPlayer2.Character
		local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
		if not humanoidRootPart then
			return {}
		end
		local tbl12 = {}

		for i, player in ipairs(Players2:GetPlayers()) do
			if player ~= localPlayer2 and player.Character then
				local humanoidRootPart2 = player.Character:FindFirstChild("HumanoidRootPart")
				local humanoid = player.Character:FindFirstChildOfClass("Humanoid")

				if humanoidRootPart2 and (humanoid and humanoid.Health > 0) then
					local magnitude = (humanoidRootPart2.Position - humanoidRootPart.Position).Magnitude

					if magnitude <= arg.targetRange then
						table.insert(tbl12, {player = player, root = humanoidRootPart2, humanoid = humanoid, distance = magnitude})
					end
				end
			end
		end

		table.sort(tbl12, function(arg2, arg3)
			return arg2.distance < arg3.distance
		end)

		return tbl12
	end

	index._swing = function(arg, arg2, arg3)
		if arg2 then
			if arg2.Parent ~= localPlayer2.Character then
				return false
			end
		else
			return false
		end

		local serverTimeNow = workspace:GetServerTimeNow()
		if serverTimeNow - arg.lastSwingAt < 0.22 then
			return false
		end
		arg.lastSwingAt = serverTimeNow
		pcall(arg2.Activate, arg2)
		local handle = arg2:FindFirstChild("Handle") or arg2:FindFirstChildWhichIsA("BasePart", true)

		if handle and arg3 and type(firetouchinterest) == "function" then
			pcall(function()
				firetouchinterest(handle, arg3, 0)
				task.wait(0.01)
				firetouchinterest(handle, arg3, 1)
			end)
		end

		pcall(function()
			local batSwing = require(ReplicatedStorage2.Shared.Remotes).BatSwing

			if batSwing and batSwing.Trigger then
				arg.swingSequence = arg.swingSequence + 1
				local str3 = string.format("%d:%d:%d", localPlayer2.UserId, arg.swingSequence, math.floor(serverTimeNow * 1000))
				batSwing.Trigger:FireServer(nil, str3)
			end
		end)

		return true
	end

	index.startDefend = function(arg, activeDroppedUid)
		if not arg.enabled then
			return
		end

		if arg.eggRuntime and arg.eggRuntime.instantPhase == "priming" then
			return
		end

		if activeDroppedUid and (arg.eggRuntime and arg.eggRuntime:isSkippedEgg(activeDroppedUid)) then
			return
		end
		local senaV4PlayerSteal = genv.__SenaV4PlayerSteal
		if senaV4PlayerSteal and senaV4PlayerSteal.running then
			return
		end
		arg.active = true
		arg.activeDroppedUid = activeDroppedUid or arg.activeDroppedUid
		if arg.defendThread then
			return
		end

		arg.defendThread = task.spawn(function()
			local flag5 = false

			while arg.active and arg.enabled do
				if arg.eggRuntime and (arg.eggRuntime.carry and arg.eggRuntime.carry.active) then
					break
				end
				local senaV4PlayerSteal2 = genv.__SenaV4PlayerSteal
				if senaV4PlayerSteal2 and senaV4PlayerSteal2.running then
					flag5 = true
					break
				end
				local v10 = arg:_getNearbyEnemies()

				if #v10 > 0 then
					local v11 = arg:_equipBat()

					if v11 then
						for i, v12 in ipairs(v10) do
							if v12.root and v12.root.Parent then
								arg:_swing(v11, v12.root)
							end
						end
					end
				end

				task.wait(0.1)
			end

			arg.active = false
			arg.defendThread = nil
			if flag5 then
				return
			end

			pcall(function()
				local character = localPlayer2.Character
				local humanoid = character and character:FindFirstChildOfClass("Humanoid")

				if humanoid then
					humanoid:UnequipTools()
				end
			end)
		end)
	end

	index.stopDefend = function(arg)
		arg.active = false
		arg.activeDroppedUid = nil
	end

	index.setEnabled = function(arg, arg2)
		arg.enabled = arg2 == true

		if not arg.enabled then
			arg:stopDefend()
		end
	end

	index._bindSignals = function(arg)
		pcall(function()
			local EggState2 = require(ReplicatedStorage2.Client.EggState)

			table.insert(arg.connections, EggState2.CarryChanged:Connect(function(arg2)
				if arg2.IsCarrying then
					arg:stopDefend()
				elseif arg.enabled then
					arg:startDefend(arg2.Uid)
				end
			end))
		end)

		pcall(function()
			local Remotes = require(ReplicatedStorage2.Shared.Remotes)
			local forestStrike = Remotes.GuardPatrol and Remotes.GuardPatrol.ForestStrike

			if forestStrike then
				table.insert(arg.connections, forestStrike.OnClientEvent:Connect(function()
					if arg.enabled then
						arg:startDefend()
					end
				end))
			end
		end)
	end

	index.destroy = function(arg)
		arg:stopDefend()

		for i, connection6 in ipairs(arg.connections) do
			pcall(connection6.Disconnect, connection6)
		end

		table.clear(arg.connections)
	end

	return index
end)()

local v11 = (function()
	local Players2 = game:GetService("Players")
	local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
	local localPlayer2 = Players2.LocalPlayer
	local Remotes = require(ReplicatedStorage2.Shared.Remotes)
	local PlotState2 = require(ReplicatedStorage2.Client.PlotState)
	local Hud = require(ReplicatedStorage2.Client.Hud)
	local Save = require(ReplicatedStorage2.Shared.Save)
	local Treadmills = require(ReplicatedStorage2.Data.Treadmills)
	local n8 = 8

	local function fn62()
		local treadmill = senaV4TaskLadder.blocker("treadmill")
		if treadmill then
			return "Yielding to " .. senaV4TaskLadder.TITLES[treadmill]
		end
		local treadmill2 = senaV4TaskLadder.holder("treadmill")
		if treadmill2 then
			return "Waiting for " .. senaV4TaskLadder.TITLES[treadmill2]
		end
		return nil
	end

	local function fn63()
		return fn62() ~= nil
	end

	local function fn64()
		return senaV4TaskLadder.blocker("treadmill") == "auto_steal"
	end

	local function fn65()
		return fn62() or "Yielding"
	end

	local n9 = 1
	local n10 = 0.15
	local n11 = 0.75
	local n12 = 0.35
	local n13 = 0.1
	local n14 = 1.5
	local n15 = 0.03
	local n16 = 0.2
	local n17 = 0.25
	local n18 = 0.35
	local n19 = 2.5
	local n20 = 3
	local index = {}
	index.__index = index

	index.new = function(coordinator, travel)
		local obj = setmetatable({}, index)
		obj.coordinator = coordinator
		obj.travel = travel
		obj.destroyed = false
		obj.listeners = {}
		obj.resources = {}
		obj.config = {disableDuringAutomation = true, idleFarm = false, autoUpgrade = false}
		obj.stats = {mode = "Idle", boost = "Waiting"}
		obj.busy = coordinator and coordinator:getSnapshot().busy == true or false
		obj.idleGeneration = 0
		obj.lastEquipAt = 0
		obj.activeTreadmill = nil
		obj.travelingToTreadmill = false
		obj.treadmillEquipPending = false
		obj.unequipGuardRunning = false
		obj.backgroundYieldRunning = false
		obj.lastBackgroundYieldAt = 0
		obj.carryPulseRunning = false
		obj.treadmillStateRevision = 0
		obj:_listenActiveTreadmill()

		task.spawn(function()
			pcall(function()
				obj:_syncActiveTreadmillSnapshot()
			end)
		end)

		obj:_listenCoordinator()
		obj:_listenSpeedGain()
		return obj
	end

	index._snapshot = function(arg)
		return {mode = arg.stats.mode, boost = arg.stats.boost, disableDuringAutomation = arg.config.disableDuringAutomation, idleFarm = arg.config.idleFarm}
	end

	index._emit = function(arg)
		local v11 = arg:_snapshot()

		for i, listener in ipairs(arg.listeners) do
			pcall(listener, v11)
		end
	end

	index._setStatus = function(arg, mode, boost)
		if mode ~= nil then
			arg.stats.mode = mode
		end

		if boost ~= nil then
			arg.stats.boost = boost
		end

		arg:_emit()
	end

	index.subscribe = function(arg, arg2)
		table.insert(arg.listeners, arg2)
		pcall(arg2, arg:_snapshot())

		return function()
			local v11 = table.find(arg.listeners, arg2)

			if v11 then
				table.remove(arg.listeners, v11)
			end
		end
	end

	index._requestUnequip = function(arg)
		local ok, result, result2 = pcall(function()
			return Remotes.Treadmill.AskDoff:InvokeServer()
		end)

		if not ok then
			return false, tostring(result)
		end

		if result == false then
			return false, tostring(result2 or "Server rejected")
		end
		return true
	end

	index._shouldBlockTreadmill = function(arg)
		if arg.destroyed then
			return false
		elseif arg.carryPulseRunning then
			return false
		end

		if arg.busy and arg.config.disableDuringAutomation then
			return true
		end
		local senaV4EggRuntime = genv.__SenaV4EggRuntime
		if senaV4EggRuntime and senaV4EggRuntime._treadmillResetting then
			return false
		end
		local ok, result = pcall(senaV4TaskLadder.holder, "treadmill")
		return ok and result ~= nil
	end

	index._startUnequipGuard = function(arg)
		if arg.unequipGuardRunning then
			return
		elseif arg:_shouldBlockTreadmill() then
			if arg.activeTreadmill == nil then
				return
			end
		else
			return
		end

		arg.unequipGuardRunning = true

		task.spawn(function()
			local n21 = n10

			while arg:_shouldBlockTreadmill() and arg.activeTreadmill ~= nil do
				local v11, v12 = arg:_requestUnequip()
				arg:_setStatus("Automation active", v11 and "Blocked" or "Release retry: " .. tostring(v12))
				task.wait(n21)
				n21 = math.min(n21 * 2, n11)
			end

			arg.unequipGuardRunning = false

			if arg:_shouldBlockTreadmill() and arg.activeTreadmill ~= nil then
				arg:_startUnequipGuard()
			end
		end)
	end

	index._cancelIdle = function(arg, arg2)
		arg.idleGeneration = arg.idleGeneration + 1

		if arg2 then
			arg:_requestUnequip()
		end
	end

	index.setDisableDuringAutomation = function(arg, arg2)
		arg.config.disableDuringAutomation = true

		if arg.busy and arg.config.disableDuringAutomation then
			arg:_cancelIdle(true)
			arg:_startUnequipGuard()
			arg:_setStatus("Automation active", "Blocked")
		elseif not arg.busy then
			if arg.config.idleFarm then
				arg:_startIdle()
			end
		end
	end

	index.setIdleFarm = function(arg, arg2)
		arg.config.idleFarm = arg2 == true

		if not arg.config.idleFarm then
			arg:_cancelIdle(true)
			arg:_setStatus(arg.busy and "Automation active" or "Idle", "Disabled")
			return
		end

		if not arg.busy then
			arg:_startIdle()
		end

		if arg.idleWatchdog then
			return
		end

		arg.idleWatchdog = task.spawn(function()
			while true do
				local destroyed = arg.destroyed
				if not (if destroyed then not destroyed else arg.config.idleFarm) then
					break
				end
				task.wait(2)

				if arg.idleRunning == nil and (not arg.busy and (arg.config.idleFarm and not arg.destroyed)) then
					arg:_startIdle()
				end
			end

			arg.idleWatchdog = nil
		end)
	end

	index._readUpgradeState = function(arg)
		local ok, result, result2, result3 = pcall(function()
			local v11 = (Save.Peek or Save.Get)()
			if not v11 then
				return nil
			end
			local n21 = tonumber(v11.TreadmillUpgradeLevel) or 0
			return n21, v11.Money, Treadmills.GetByUpgradeLevel(n21 + 1)
		end)

		if ok then
			if result == nil then
				return nil
			end
		else
			return nil
		end

		return result, result2, result3
	end

	index._raiseTier = function(arg)
		local v11, v12, v13 = arg:_readUpgradeState()
		if not v13 then
			return false, "Max tier"
		end

		if (tonumber(v12) or 0) < (tonumber(v13.Price) or 0) then
			return false, "Not enough money"
		end

		local ok, result, result2 = pcall(function()
			return Remotes.Treadmill.AskTierRaise:InvokeServer(v13._id)
		end)

		if not ok then
			return false, tostring(result)
		end

		if result ~= true then
			return false, tostring(result2 or "Server rejected")
		end
		return true, v13.DisplayName or v13._id
	end

	index.setAutoUpgrade = function(arg, arg2)
		arg.config.autoUpgrade = arg2 == true

		if arg.config.autoUpgrade then
			if arg.autoUpgradeRunning then
				return
			end
		else
			return
		end

		arg.autoUpgradeRunning = true

		task.spawn(function()
			while true do
				local destroyed = arg.destroyed
				if not (if destroyed then not destroyed else arg.config.autoUpgrade) then
					break
				end
				local v11, v12 = arg:_raiseTier()

				if v11 then
					arg:_setStatus(arg.busy and "Automation active" or "Idle", "Upgraded to " .. tostring(v12))
					task.wait(1)
				elseif v12 == "Max tier" then
					arg:_setStatus(arg.busy and "Automation active" or "Idle", "Treadmill maxed")
					task.wait(30)
				else
					task.wait(5)
				end
			end

			arg.autoUpgradeRunning = false
		end)
	end

	index._resolveStandCFrame = function(arg)
		local v11 = PlotState2.ResolveLocalSlot()
		local v12 = PlotState2.ResolveFolder()
		local v13 = v12 and v11 and v12:FindFirstChild(tostring(v11))
		local treadmillBottom = v13 and v13:FindFirstChild("TreadmillBottom")

		if treadmillBottom then
			if not treadmillBottom:IsA("BasePart") then
				return nil
			end
		else
			return nil
		end

		local character = localPlayer2.Character
		local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")

		if humanoidRootPart then
			if not humanoid then
				return nil
			end
		else
			return nil
		end

		local v14 = if humanoid.RigType == Enum.HumanoidRigType.R15 then humanoidRootPart.Size.Y * 0.5 + math.max(humanoid.HipHeight, 0.5) else humanoidRootPart.Size.Y * 0.5 + 2
		return treadmillBottom.CFrame * CFrame.new(0, treadmillBottom.Size.Y * 0.5 + v14 + 0.05, 0)
	end

	index.isEngaged = function(arg)
		return arg.activeTreadmill ~= nil or arg.travelingToTreadmill or arg.treadmillEquipPending or arg.carryPulseRunning
	end

	index._isTreadmillHudActive = function(arg)
		local ok, result = pcall(function()
			local Game = Hud.Frame("Game")
			local Treadmill = Hud.Frame("Treadmill")
			return Game.Visible == false and Treadmill.Visible == true
		end)

		return ok and result == true
	end

	index._isGameHudRestored = function(arg)
		local ok, result = pcall(function()
			local Game = Hud.Frame("Game")
			local Treadmill = Hud.Frame("Treadmill")
			return Game.Visible == true and Treadmill.Visible == false
		end)

		return ok and result == true
	end

	index.pulseForCarry = function(arg, arg2, arg3)
		if arg.destroyed then
			return false, "Preparation unavailable"
		elseif arg.carryPulseRunning then
			return false, "Preparation unavailable"
		elseif type(arg2) ~= "function" then
			return false, "Preparation unavailable"
		end

		arg:_cancelIdle(false)
		arg.carryPulseRunning = true

		local function fn66()
			return arg.destroyed or arg3 ~= nil and arg3()
		end

		local function fn67(arg4)
			local n21, n22, treadmillStateRevision, v11 = os.clock() + arg4, 0, arg.treadmillStateRevision

			while true do
				local destroyed = arg.destroyed
				if not (if destroyed then not destroyed else os.clock() < n21) then
					break
				end
				local now = os.clock()

				if now >= n22 then
					arg:_requestUnequip()
					n22 = now + n10
				end

				local v12 = arg:_syncActiveTreadmillSnapshot()
				local v13 = arg:_isGameHudRestored()

				if arg.treadmillStateRevision ~= treadmillStateRevision then
					treadmillStateRevision = arg.treadmillStateRevision
					v11 = nil
				end

				if v12 then
					v11 = nil
				else
					if arg.activeTreadmill == nil then
						if v13 then
							local v14 = v11 or now
							if now - v14 >= n18 then
								return true
							end
							v11 = v14
						else
							v11 = nil
						end
					else
						v11 = nil
					end
				end

				task.wait(n15)
			end

			return false
		end

		local function fn68(arg4, arg5)
			if not arg4 then
				fn67(n14 + n18)
			end

			arg.treadmillEquipPending = false
			arg.carryPulseRunning = false

			if arg4 then
				arg:_setStatus("Automation active", "Preparation complete")
			elseif not arg.destroyed then
				arg:_setStatus("Automation active", tostring(arg5 or "Preparation failed"))
			end

			if arg:_shouldBlockTreadmill() and arg.activeTreadmill ~= nil then
				arg:_startUnequipGuard()
			end

			return arg4, arg5
		end

		arg:_syncActiveTreadmillSnapshot()
		local str3
		local flag5 = false

		for i = 1, n20, 1 do
			if fn66() then
				local cancelled, v11 = fn68(false, "Cancelled")
				return cancelled, v11
			end
			local cancelled = arg:_resolveStandCFrame()

			if cancelled then
				arg:_setStatus("Preparing carry", i == 1 and "Positioning" or "Repositioning")
				local ok, result = pcall(arg2, cancelled)

				if ok then
					local v11

					if result == true then
						task.wait(n12)
						arg.treadmillEquipPending = true
						arg:_setStatus("Preparing carry", "Activating")
						local n21 = os.clock() + n19
						local n22 = 0
						local flag6 = flag5
						local n23 = 0
						v11 = str3

						while true do
							local v12 = fn66()
							if not (if v12 then not v12 else os.clock() < n21) then
								break
							end
							local now = os.clock()

							if now >= n22 then
								n22 = now + n17
								arg:_syncActiveTreadmillSnapshot()
							end

							if arg.activeTreadmill ~= nil and arg:_isTreadmillHudActive() then
								flag6 = true
								break
							end

							if arg.activeTreadmill == nil and now >= n23 then
								local n24, ok2, result2, result3 = now + n16, pcall(function()
									return Remotes.Treadmill.AskWearStill:InvokeServer()
								end)

								if if ok2 then result2 == false else not ok2 then
									local str4 = tostring(result3 or result2)
									arg:_setStatus("Preparing carry", "Activation retry")
									v11 = str4
								end

								n23 = n24
							end

							task.wait(n15)
						end

						str3 = v11
						flag5 = flag6
					else
						str3 = "Positioning failed"
					end
				else
					str3 = "Positioning failed"
				end
			else
				str3 = "Position unavailable"
			end

			if flag5 then
				break
			end

			if fn66() then
				cancelled, i = fn68(false, "Cancelled")
				return cancelled, i
			end
			arg:_setStatus("Preparing carry", "Resetting position")
			fn67(n14 + n18)
		end

		if not flag5 then
			local v11, v12 = fn68(false, "Activation not confirmed: " .. tostring(str3 or "Unknown"))
			return v11, v12
		end
		arg.treadmillEquipPending = false
		arg:_setStatus("Preparing carry", "Active")
		local n21 = os.clock() + n13

		while true do
			local v11 = fn66()
			if not (if v11 then not v11 else os.clock() < n21) then
				break
			end
			task.wait(n15)
		end

		if fn66() then
			local cancelled, v11 = fn68(false, "Cancelled")
			return cancelled, v11
		end
		arg:_setStatus("Preparing carry", "Releasing")
		if fn67(n14 + n18) then
			local v11, v12 = fn68(true)
			return v11, v12
		end
		local v11, v12 = fn68(false, fn66() and "Cancelled" or "Release not confirmed")
		return v11, v12
	end

	index.yieldForBackground = function(arg)
		if arg.destroyed then
			return
		end
		arg:_cancelIdle(false)
		if arg.backgroundYieldRunning then
			return
		end
		arg.backgroundYieldRunning = true

		task.spawn(function()
			local n21 = n10

			while not arg.destroyed do
				if arg.coordinator then
					if not arg.coordinator:isBackgroundBusy() then
						break
					end
				else
					break
				end

				arg.lastBackgroundYieldAt = os.clock()
				arg:_setStatus("Idle", "Yielding to background inventory")
				arg:_requestUnequip()
				task.wait(n21)
				if not arg:_syncActiveTreadmillSnapshot() then
					break
				end
				n21 = math.min(n21 * 2, n11)
			end

			arg.backgroundYieldRunning = false

			if not arg.destroyed and not arg:isEngaged() then
				arg:_setStatus("Idle", "Background inventory ready")
			end
		end)
	end

	index._startIdle = function(arg)
		if arg.destroyed then
			return
		elseif arg.busy then
			return
		elseif not arg.config.idleFarm then
			return
		end

		arg:_cancelIdle(false)
		local idleGeneration = arg.idleGeneration
		local now = os.clock()
		arg.idleRunning = idleGeneration

		task.spawn(function()
			local ok, result = xpcall(function()
				while true do
					local destroyed = arg.destroyed
					if not ((if destroyed then not destroyed else not arg.busy) and arg.config.idleFarm and idleGeneration == arg.idleGeneration) then
						break
					end

					if arg.coordinator and arg.coordinator:isBackgroundBusy() then
						now = os.clock()
						arg:_setStatus("Idle", "Waiting for background inventory")
						task.wait(0.25)
						continue
					end

					if fn64() then
						now = os.clock()
						arg:_setStatus("Idle", "Yielding to Auto Steal")
						task.wait(0.25)
						continue
					end

					if genv.__SenaV4IsAutoSellEggBusy and genv.__SenaV4IsAutoSellEggBusy() then
						now = os.clock()
						arg:_setStatus("Idle", "Waiting for Auto Sell Egg")
						task.wait(0.25)
						continue
					end

					if fn63() then
						now = os.clock()
						arg:_setStatus("Idle", fn65())
						task.wait(0.25)
						continue
					end

					local n21 = n9 - (os.clock() - now)

					if n21 > 0 then
						arg:_setStatus("Idle", string.format("Starting in %.0fs", math.ceil(n21)))
						task.wait(math.min(n21, 0.25))
						continue
					end

					local v11 = arg:_resolveStandCFrame()

					if not v11 then
						arg:_setStatus("Idle", "Position unavailable")
						task.wait(2)
						continue
					end

					arg.travelingToTreadmill = true
					arg:_setStatus("Moving", "Waiting")
					local flag5 = false
					local travel = arg.travel
					local character = localPlayer2.Character
					local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
					local humanoid = character and character:FindFirstChildOfClass("Humanoid")

					if travel and (humanoidRootPart and (humanoid and (type(travel._teleportRoot) == "function" and (type(travel._isInSafeArea) == "function" and (travel:_isInSafeArea(humanoidRootPart) and (humanoidRootPart.Position - v11.Position).Magnitude < 250))))) then
						local ok, result = pcall(travel._teleportRoot, travel, humanoidRootPart, humanoid, v11)
						flag5 = ok and result == true
					end

					local travel2 = flag5 or arg.travel and arg.travel:travelAndWait(v11, {abort = function()
						return arg.destroyed or arg.busy or not arg.config.idleFarm or idleGeneration ~= arg.idleGeneration or arg.coordinator and arg.coordinator:isBackgroundBusy() or genv.__SenaV4IsAutoSellEggBusy and genv.__SenaV4IsAutoSellEggBusy() or fn63()
					end})

					arg.travelingToTreadmill = false

					if not travel2 then
						if not arg.busy and arg.config.idleFarm then
							arg:_setStatus("Idle", "Travel failed")
							task.wait(1)
						end

						continue
					end

					if arg.busy or not arg.config.idleFarm or idleGeneration ~= arg.idleGeneration or arg.coordinator and arg.coordinator:isBackgroundBusy() then
						continue
					elseif genv.__SenaV4IsAutoSellEggBusy then
						if genv.__SenaV4IsAutoSellEggBusy() then
							continue
						elseif fn63() then
							continue
						end
					elseif fn63() then
						continue
					end

					task.wait(n12)

					if arg.busy or not arg.config.idleFarm or idleGeneration ~= arg.idleGeneration or arg.coordinator and arg.coordinator:isBackgroundBusy() then
						continue
					elseif genv.__SenaV4IsAutoSellEggBusy then
						if genv.__SenaV4IsAutoSellEggBusy() then
							continue
						elseif fn63() then
							continue
						end
					elseif fn63() then
						continue
					end

					arg.treadmillEquipPending = true

					character, destroyed, travel = pcall(function()
						return Remotes.Treadmill.AskWearStill:InvokeServer()
					end)

					if if character then destroyed == false else not character then
						arg.treadmillEquipPending = false
						arg:_setStatus("Preparing carry", "Activation failed: " .. tostring(travel or destroyed))
					else
						arg.lastEquipAt = os.clock()
						arg:_setStatus("Active", "Waiting for gain")

						task.delay(2, function()
							if not arg.destroyed and arg.activeTreadmill == nil then
								arg.treadmillEquipPending = false
							end
						end)
					end

					local n22 = os.clock() + n8

					while (arg.activeTreadmill ~= nil or os.clock() < n22) and not arg.destroyed and not arg.busy and arg.config.idleFarm and idleGeneration == arg.idleGeneration and not (arg.coordinator and arg.coordinator:isBackgroundBusy()) do
						if fn64() then
							arg:_cancelIdle(true)
							arg:_setStatus("Idle", "Yielding to Auto Steal")
							break
						end

						if genv.__SenaV4IsAutoSellEggBusy and genv.__SenaV4IsAutoSellEggBusy() then
							arg:_cancelIdle(true)
							arg:_setStatus("Idle", "Yielding to Auto Sell Egg")
							break
						end

						if fn63() then
							arg:_requestUnequip()
							arg:_setStatus("Idle", fn65())
							break
						end

						task.wait(0.25)
					end
				end
			end, debug.traceback)

			if not ok then
				warn("[SAE][treadmill] idle error:\n" .. tostring(result))
			end

			if arg.idleRunning == idleGeneration then
				arg.idleRunning = nil
			end
		end)
	end

	index._onCoordinator = function(arg, arg2)
		local busy = arg.busy
		arg.busy = arg2.busy == true

		if arg.busy then
			arg:_cancelIdle(arg.config.disableDuringAutomation)
			arg:_startUnequipGuard()
			arg:_setStatus("Automation active", arg.config.disableDuringAutomation and "Blocked" or "Unchanged")
		elseif busy or arg.config.idleFarm then
			if arg.config.idleFarm then
				arg:_startIdle()
			else
				arg:_setStatus("Idle", "Disabled")
			end
		end
	end

	index._listenCoordinator = function(arg)
		if not arg.coordinator then
			return
		end

		table.insert(arg.resources, arg.coordinator:subscribe(function(arg2)
			arg:_onCoordinator(arg2)
		end))

		table.insert(arg.resources, arg.coordinator:subscribeBackground(function(arg2)
			if arg2.busy then
				arg:_cancelIdle(false)
				arg:_setStatus("Idle", "Waiting for background inventory")
			elseif not arg.destroyed then
				if not arg.busy and arg.config.idleFarm then
					arg:_startIdle()
				end
			end
		end))
	end

	index._syncActiveTreadmillSnapshot = function(arg)
		local ok, result = pcall(function()
			return Remotes.Treadmill.AskRenderSnapshot:InvokeServer()
		end)

		if ok then
			if type(result) ~= "table" then
				return arg.activeTreadmill ~= nil
			end
		else
			return arg.activeTreadmill ~= nil
		end

		local flag5 = table.find(result, localPlayer2.UserId) ~= nil
		arg.activeTreadmill = flag5 and "snapshot" or nil

		if not flag5 then
			arg.treadmillEquipPending = false
		end

		return flag5
	end

	index._listenActiveTreadmill = function(arg)
		local function fn66(activeTreadmill)
			arg.treadmillStateRevision = arg.treadmillStateRevision + 1
			arg.activeTreadmill = activeTreadmill
			arg.treadmillEquipPending = false

			if activeTreadmill ~= nil and arg:_shouldBlockTreadmill() then
				arg:_startUnequipGuard()
			elseif activeTreadmill == nil and arg:_shouldBlockTreadmill() then
				arg:_setStatus("Automation active", "Blocked")
			elseif activeTreadmill == nil then
				arg:_setStatus("Idle", arg.config.idleFarm and "Released" or "Disabled")
			elseif not arg.busy then
				arg:_setStatus("Active", "Waiting for gain")
			end
		end

		local assignedBeltShifted, renderStateShifted

		pcall(function()
			assignedBeltShifted = Remotes.Treadmill.AssignedBeltShifted
		end)

		pcall(function()
			renderStateShifted = Remotes.Treadmill.RenderStateShifted
		end)

		if assignedBeltShifted then
			table.insert(arg.resources, assignedBeltShifted.OnClientEvent:Connect(function(arg2)
				fn66(arg2)
			end))

			return
		end

		if renderStateShifted then
			table.insert(arg.resources, renderStateShifted.OnClientEvent:Connect(function(arg2, arg3)
				if arg2 ~= localPlayer2.Name then
					return
				end
				fn66(arg3 and arg2 or nil)
			end))
		end
	end

	index._listenSpeedGain = function(arg)
		local speedGained = Remotes.Treadmill.SpeedGained

		if speedGained then
			table.insert(arg.resources, speedGained.OnClientEvent:Connect(function()
				arg.activeTreadmill = arg.activeTreadmill or true
				arg.treadmillEquipPending = false
				if arg:_shouldBlockTreadmill() then
					arg:_startUnequipGuard()
					return
				end
				arg:_setStatus("Active", "Gain ticking")
			end))
		end
	end

	index.destroy = function(arg)
		if arg.destroyed then
			return
		end
		arg.destroyed = true
		arg:_cancelIdle(true)

		for i, resource in ipairs(arg.resources) do
			pcall(function()
				if typeof(resource) == "RBXScriptConnection" then
					resource:Disconnect()
				elseif type(resource) == "function" then
					resource()
				elseif type(resource) == "table" then
					if type(resource.Disconnect) == "function" then
						resource:Disconnect()
					end
				end
			end)
		end

		table.clear(arg.resources)
		table.clear(arg.listeners)
	end

	index.Destroy = index.destroy
	return index
end)()

local v12 = v5.new()
local v13 = v8.new(v6, v7, v12)
genv.__SenaV4EggRuntime = v13
local v14 = v11.new(v12, v13)
genv.__SenaV4TreadmillManager = v14

senaV4TaskLadder.register("treadmill", {wants = function()
	return v14.config.idleFarm == true and not v14.destroyed
end, active = function()
	local destroyed = v14.destroyed
	return if destroyed then not destroyed else v14:isEngaged() == true
end, enabled = function()
	return v14.config.idleFarm == true
end, status = function()
	local stats = v14.stats or {}
	local str3 = tostring(stats.mode or "")
	local str4 = tostring(stats.boost or "")
	if str4 ~= "" and str4 ~= "Waiting" then
		return str3 .. "  \194\183  " .. str4
	end
	return str3
end})

v13:setTreadmillManager(v14)
v14:setDisableDuringAutomation(true)

if senaV4Config.AutoTreadmillIdle then
	v14:setIdleFarm(true)
end

if senaV4Config.AutoIndex then
	v13:setIndexObjective(true)
end

if senaV4Config.AutoTreadmillUpgrade then
	v14:setAutoUpgrade(true)
end

genv.__SenaV4Webhook = (function()
	local HttpService = game:GetService("HttpService")
	local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
	local localPlayer2 = game:GetService("Players").LocalPlayer
	local request_, tbl12, tbl13, flag5, tbl14, str3, flag6, AssetEarnings, EggRecords = http_request or request or http and http.request or syn and syn.request or fluxus and fluxus.request, {}, {}, false, {}, "96240498384290"

	pcall(function()
		AssetEarnings = require(ReplicatedStorage2.Shared.Util.AssetEarnings)
	end)

	pcall(function()
		EggRecords = require(ReplicatedStorage2.Shared.Util.EggRecords)
	end)

	local function fn62(arg)
		local match = tostring(arg or ""):match("%d+")
		if not match then
			return nil
		end
		arg = tbl14[match]

		if arg ~= nil then
			if arg == "" then
				return nil
			end
			return arg
		end

		local tbl15, v15 = {"512x512", "150x150"}

		for i, v16 in ipairs(tbl15) do
			local imageUrl

			pcall(function()
				local str4, body = "https://thumbnails.roblox.com/v1/assets?assetIds=" .. match .. "&size=" .. v16 .. "&format=Png&isCircular=false"

				if request_ then
					local v17 = request_({Url = str4, Method = "GET"})
					body = type(v17) == "table" and (v17.Body or v17.body) or nil
				else
					body = HttpService:GetAsync(str4)
				end

				if type(body) == "string" and body ~= "" then
					local data = HttpService:JSONDecode(body)
					local data2 = data and data.data and data.data[1]

					if data2 and (data2.state == "Completed" and (type(data2.imageUrl) == "string" and data2.imageUrl ~= "")) then
						imageUrl = data2.imageUrl
					end
				end
			end)

			if imageUrl then
				v15 = v15 or imageUrl
				local pos = imageUrl:find("/Png/", 1, true)
				local v17 = v15
				if pos then
					v15 = imageUrl
					break
				end
				v15 = v17
			end
		end

		tbl14[match] = v15 or ""
		return v15
	end

	local function fn63()
		if flag6 == nil then
			flag6 = fn62(str3) or false
		end

		return flag6 or nil
	end

	local png

	png = {cache = {}, crc = nil, size = 96, crc32 = function(arg)
		if not png.crc then
			png.crc = {}

			for i = 0, 255, 1 do
				local flag7 = i

				for i2 = 1, 8, 1 do
					flag7 = bit32.band(flag7, 1) == 1 and bit32.bxor(3988292384, bit32.rshift(flag7, 1)) or bit32.rshift(flag7, 1)
				end

				png.crc[i] = flag7
			end
		end

		local n8 = 4294967295

		for i = 1, #arg, 1 do
			n8 = bit32.bxor(png.crc[bit32.band(bit32.bxor(n8, arg:byte(i)), 255)], bit32.rshift(n8, 8))
		end

		return bit32.bxor(n8, 4294967295)
	end, chunk = function(arg, arg2)
		return string.pack(">I4", #arg2) .. arg .. arg2 .. string.pack(">I4", png.crc32(arg .. arg2))
	end, encode = function(arg, arg2, arg3)
		local n8 = 1
		local n9 = 0

		for i = 1, #arg3, 1 do
			n8 = (n8 + arg3:byte(i)) % 65521
			n9 = (n9 + n8) % 65521
		end

		local tbl15 = {"x\001"}
		local n10 = 1

		while n10 <= #arg3 do
			local str4 = arg3:sub(n10, n10 + 65534)
			n10 += #str4
			tbl15[#tbl15 + 1] = string.char(n10 > #arg3 and 1 or 0) .. string.pack("<I2<I2", #str4, bit32.bxor(#str4, 65535)) .. str4
		end

		tbl15[#tbl15 + 1] = string.pack(">I4", n9 * 65536 + n8)
		return "\137PNG\013\n\026\n" .. png.chunk("IHDR", string.pack(">I4>I4", arg, arg2) .. "\008\006\000\000\000") .. png.chunk("IDAT", table.concat(tbl15)) .. png.chunk("IEND", "")
	end, render = function(arg)
		local match = tostring(arg or ""):match("%d+")
		if not match then
			return nil
		end
		local v15 = png.cache[match]
		if v15 ~= nil then
			return v15 or nil
		end

		local ok, result = pcall(function()
			local v16 = game:GetService("AssetService"):CreateEditableImageAsync(Content.fromUri("rbxassetid://" .. match))
			local size = v16.Size
			local v17 = v16:ReadPixelsBuffer(Vector2.zero, size)
			local size2 = png.size
			local tbl15 = {}

			for i = 0, size2 - 1, 1 do
				local n8 = math.floor(i * size.Y / size2)
				local tbl16 = {"\000"}

				for i2 = 0, size2 - 1, 1 do
					local n9 = (n8 * size.X + math.floor(i2 * size.X / size2)) * 4
					tbl16[#tbl16 + 1] = string.char(buffer.readu8(v17, n9), buffer.readu8(v17, n9 + 1), buffer.readu8(v17, n9 + 2), buffer.readu8(v17, n9 + 3))
				end

				tbl15[#tbl15 + 1] = table.concat(tbl16)
			end

			v16:Destroy()
			return png.encode(size2, size2, table.concat(tbl15))
		end)

		local flag7 = ok and type(result) == "string" and result or false
		png.cache[match] = flag7
		return flag7 or nil
	end, post = function(arg, arg2, arg3)
		local str4 = "SenaHub" .. tostring(math.random(100000, 999999)) .. tostring(os.time())
		local str5 = table.concat({"--" .. str4, "Content-Disposition: form-data; name=\"payload_json\"", "Content-Type: application/json", "", HttpService:JSONEncode(arg2), "--" .. str4, "Content-Disposition: form-data; name=\"files[0]\"; filename=\"egg.png\"", "Content-Type: image/png", "", arg3, "--" .. str4 .. "--", ""}, "\013\n")
		local v15 = request_({Url = arg, Method = "POST", Headers = {["Content-Type"] = "multipart/form-data; boundary=" .. str4}, Body = str5})
		local n8 = type(v15) == "table" and tonumber(v15.StatusCode or v15.status) or 0
		return n8 >= 200 and n8 < 300
	end}

	tbl12.png = png

	local function fn64()
		if flag5 then
			return
		end
		flag5 = true

		task.spawn(function()
			while #tbl13 > 0 do
				local v15 = table.remove(tbl13, 1)

				pcall(function()
					if v15.thumbAsset then
						local v16 = v15.payload.embeds[1]
						local v17 = fn62(v15.thumbAsset)

						if v17 then
							v16.thumbnail = {url = v17}
						end
					end

					if v15.imageAsset and request_ then
						local v16 = png.render(v15.imageAsset)

						if v16 then
							local v17 = v15.payload.embeds[1]
							local thumbnail = v17.thumbnail
							v17.thumbnail = {url = "attachment://egg.png"}
							if png.post(v15.url, v15.payload, v16) then
								return
							end
							v17.thumbnail = thumbnail
						end
					end

					local json = HttpService:JSONEncode(v15.payload)

					if request_ then
						request_({Url = v15.url, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = json})
					else
						HttpService:PostAsync(v15.url, json, Enum.HttpContentType.ApplicationJson)
					end
				end)

				task.wait(0.6)
			end

			flag5 = false
		end)
	end

	local function fn65(arg)
		if typeof(arg) ~= "Color3" then
			return 5814783
		end
		return math.floor(arg.R * 255 + 0.5) * 65536 + math.floor(arg.G * 255 + 0.5) * 256 + math.floor(arg.B * 255 + 0.5)
	end

	local function compact(arg)
		local Simple

		pcall(function()
			Simple = require(ReplicatedStorage2.Packages.FormatNumber.Simple)
		end)

		if Simple and Simple.FormatCompact then
			local ok, result = pcall(Simple.FormatCompact, arg, ".#")
			if ok and result then
				return tostring(result)
			end
		end

		return string.format("%.1f", arg or 0)
	end

	tbl12.compact = compact

	tbl12.rateOf = function(arg)
		if AssetEarnings then
			if type(arg) ~= "table" then
				return 0
			end
		else
			return 0
		end

		local n8 = tonumber(arg.AssetScale) or 1
		local tbl15 = {Category = arg.AssetCategory, Scale = n8, AssetScale = n8, BaseMutation = arg.BaseMutation, Mutations = arg.Mutations or {}}

		for i, v15 in ipairs({"LiveRatePerSecond", "RatePerSecond", "CatalogRatePerSecond"}) do
			if type(AssetEarnings[v15]) == "function" then
				n8, i = pcall(AssetEarnings[v15], tbl15)
				if n8 and (type(i) == "number" and i > 0) then
					return i
				end
			end
		end

		return 0
	end

	tbl12.weightOf = function(arg)
		if EggRecords then
			if type(arg) ~= "table" then
				return 0
			end
		else
			return 0
		end

		local ok, result = pcall(EggRecords.WeightKgForScale, arg.AssetCategory, tonumber(arg.AssetScale) or 1)
		if ok and type(result) == "number" then
			return result
		end
		return 0
	end

	tbl12.sizeText = function(arg)
		local n8 = tonumber(arg and (arg.AssetScale or arg.Scale)) or 1
		if n8 >= 100 then
			return string.format("%.0fx", n8)
		end
		return string.format("%.2fx", n8)
	end

	tbl12.weightText = function(arg)
		local n8 = tonumber(arg) or 0
		if n8 >= 1000 then
			return compact(n8) .. " kg"
		end
		return string.format("%.1fkg", n8)
	end

	tbl12.rateText = function(arg)
		local n8 = tonumber(arg) or 0
		if n8 >= 1000 then
			return "$" .. compact(n8) .. "/s"
		end
		return string.format("$%d/s", math.floor(n8))
	end

	tbl12.passes = function(arg, arg2, arg3)
		local tbl15 = {}
		local flag7 = false

		for i, v15 in ipairs(senaV4Config.WebhookRarities or {}) do
			if v15 ~= "None" and v15 ~= "" then
				tbl15[v15] = true
				flag7 = true
			end
		end

		if flag7 and not tbl15[arg2.rarity] then
			return false
		end
		local n8 = tonumber(senaV4Config.WebhookMinValue) or 0
		if n8 > 0 and arg3 < n8 then
			return false
		end
		return true
	end

	local tbl15 = {"Image", "Icon", "Thumbnail", "ImageId", "IconId", "Texture", "Asset", "DisplayImage"}

	tbl12.eggAsset = function(arg)
		local directory

		pcall(function()
			directory = require(ReplicatedStorage2.Data.Assets).Directory
		end)

		local v15 = directory and directory[arg]
		if type(v15) ~= "table" then
			return nil
		end

		for i, v16 in ipairs({v15, v15.Egg, v15.Pet}) do
			if type(v16) == "table" then
				for i2, v17 in ipairs(tbl15) do
					local v18 = v16[v17]
					local match = (type(v18) == "string" or type(v18) == "number") and tostring(v18):match("%d+")
					if match and tonumber(match) > 0 then
						return match
					end
				end
			end
		end

		return nil
	end

	tbl12.stolen = function(arg, arg2, arg3)
		if senaV4Config.WebhookEnabled ~= true then
			return
		end
		local webhookURL = senaV4Config.WebhookURL

		if type(webhookURL) ~= "string" then
			return
		elseif webhookURL == "" then
			return
		end

		if type(arg) ~= "table" then
			return
		elseif not arg.AssetCategory then
			return
		end

		local tbl16 = arg2 or {name = arg.AssetCategory, rarity = "Unknown", rarityColor = nil}
		local v15 = tbl12.rateOf(arg)
		if not tbl12.passes(arg, tbl16, v15) then
			return
		end
		local tbl17 = {{name = "User", value = localPlayer2.Name, inline = true}, {name = "Rarity", value = tostring(tbl16.rarity), inline = true}, {name = "Size", value = tbl12.sizeText(arg), inline = true}, {name = "Weight", value = tbl12.weightText(tbl12.weightOf(arg)), inline = true}, {name = "Cash/s", value = tbl12.rateText(v15), inline = true}, {name = "Area", value = tostring(arg.AreaId or "?"), inline = true}}
		local mutations = arg.Mutations or {}

		if #mutations > 0 then
			local tbl18 = {}

			for i, mutation in ipairs(mutations) do
				tbl18[#tbl18 + 1] = tostring(mutation)
			end

			local n8 = #tbl17 + 1
			local tbl19 = {name = "Mutations"}
			tbl19.value, tbl19.inline, tbl17[n8] = table.concat(tbl18, ", "), false, tbl19
		end

		if arg3 and arg3 ~= "" then
			local n8 = #tbl17 + 1
			local tbl18 = {name = "Taken From"}
			tbl18.value, tbl18.inline, tbl17[n8] = tostring(arg3), false, tbl18
		end

		local v16 = fn63()
		local tbl18 = {title = "Egg Stolen", description = string.format("You've stolen a **%s** %s", tostring(tbl16.rarity), tostring(tbl16.name)), color = fn65(tbl16.rarityColor), timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"), author = {name = "Sena Hub", icon_url = v16}, footer = {text = "discord.gg/senahub", icon_url = v16}, fields = tbl17}

		if #tbl13 > 40 then
			table.remove(tbl13, 1)
		end

		table.insert(tbl13, {url = webhookURL, payload = {embeds = {tbl18}}, imageAsset = tbl12.eggIcon(arg.AssetCategory)})
		fn64()
	end

	tbl12.eggIcon = function(arg)
		local v15

		pcall(function()
			v15 = require(ReplicatedStorage2.Data.Assets).Directory[arg]
		end)

		local icon = type(v15) == "table" and type(v15.Egg) == "table" and v15.Egg.Icon
		return icon and tostring(icon):match("%d+") or tbl12.eggAsset(arg)
	end

	tbl12.test = function()
		local webhookURL = senaV4Config.WebhookURL

		if type(webhookURL) ~= "string" then
			return false
		elseif webhookURL == "" then
			return false
		end

		local v15 = fn63()
		local tbl16 = {title = "Webhook Test", description = string.format("Connection test for **%s**", localPlayer2.Name), color = 5814783, timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"), author = {name = "Sena Hub", icon_url = v15}, footer = {text = "discord.gg/senahub", icon_url = v15}, fields = {{name = "User", value = localPlayer2.Name, inline = true}, {name = "User ID", value = tostring(localPlayer2.UserId), inline = true}, {name = "Place ID", value = tostring(game.PlaceId), inline = true}, {name = "Status", value = "Connected", inline = true}}}
		local v16 = fn62(str3)

		if v16 then
			tbl16.thumbnail = {url = v16}
		end

		table.insert(tbl13, {url = webhookURL, payload = {embeds = {tbl16}}, imageAsset = tbl12.eggIcon("Dog")})
		fn64()
		return true
	end

	local now = os.clock()
	local v15

	local function fn66()
		local n8 = math.floor(os.clock() - now)
		local n9 = math.floor(n8 / 3600)
		local n10 = math.floor(n8 % 3600 / 60)
		if n9 > 0 then
			return string.format("%dh %dm", n9, n10)
		end
		return string.format("%dm %ds", n10, n8 % 60)
	end

	tbl12.disconnected = function(arg)
		if senaV4Config.WebhookDisconnect ~= true then
			return
		end
		local webhookURL = senaV4Config.WebhookURL

		if type(webhookURL) ~= "string" then
			return
		elseif webhookURL == "" then
			return
		end

		if type(arg) ~= "string" then
			return
		else
			if arg == "" then
				return
			else
				if arg == v15 then
					return
				end
			end
		end

		v15 = arg
		local v16 = fn63()
		local tbl16 = {title = "Account Disconnected", description = string.format("**%s** was disconnected from Steal an Egg.", localPlayer2.Name), color = 15548997, timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"), author = {name = "Sena Hub", icon_url = v16}, footer = {text = "discord.gg/senahub", icon_url = v16}}
		tbl16.fields = {{name = "User", value = localPlayer2.Name, inline = true}, {name = "User ID", value = tostring(localPlayer2.UserId), inline = true}, {name = "Session", value = fn66(), inline = true}, {name = "Reason", value = arg:sub(1, 1000), inline = false}, {name = "Server", value = "`" .. tostring(game.JobId ~= "" and game.JobId or "unknown") .. "`", inline = false}}
		local json = HttpService:JSONEncode({embeds = {tbl16}})

		task.spawn(function()
			pcall(function()
				if request_ then
					request_({Url = webhookURL, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = json})
				else
					HttpService:PostAsync(webhookURL, json, Enum.HttpContentType.ApplicationJson)
				end
			end)
		end)
	end

	pcall(function()
		local senaV4DisconnectConn = genv.__SenaV4DisconnectConn

		if typeof(senaV4DisconnectConn) == "RBXScriptConnection" then
			senaV4DisconnectConn:Disconnect()
		end

		genv.__SenaV4DisconnectConn = game:GetService("GuiService").ErrorMessageChanged:Connect(function(arg)
			pcall(tbl12.disconnected, arg)
		end)
	end)

	return tbl12
end)()

local walkSpeedMultiplier = (function()
	local Players2 = game:GetService("Players")
	local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
	local localPlayer2 = Players2.LocalPlayer
	local EggState2 = require(ReplicatedStorage2.Client.EggState)
	local AreaEggs = require(ReplicatedStorage2.Shared.Types.AreaEggs)
	local index = {}
	index.__index = index
	local n8 = 16
	local n9 = 8
	local n10 = 80
	local n11 = 552.2
	local n12 = 120
	local n13 = 1245
	local tbl12 = {1.1, 0.2, 0.7, 1.4, 0.45}
	local n14 = 60
	local n15 = 7

	index.new = function(eggRuntime, godMode, catalog)
		local obj = setmetatable({}, index)
		obj.eggRuntime = eggRuntime
		obj.godMode = godMode
		obj.catalog = catalog
		obj.enabled = false
		obj.running = false
		obj.status = "idle"
		obj.taken = 0
		obj.attempts = 0
		obj.history = {}
		obj.blacklist = {}
		obj.forced = false
		obj.listeners = {}
		obj.swingSeq = 0
		obj.leadIdx = 1
		obj.hitIdx = nil
		obj.missStreak = 0
		obj.lastCarrier = {}
		return obj
	end

	index.onChanged = function(arg, arg2)
		table.insert(arg.listeners, arg2)
	end

	index._notify = function(arg)
		for i, listener in ipairs(arg.listeners) do
			pcall(listener, arg)
		end
	end

	index._setStatus = function(arg, status)
		if arg.status == status then
			return
		end
		arg.status = status
		arg:_notify()
	end

	index._log = function(arg, arg2, arg3, arg4)
		table.insert(arg.history, 1, {at = os.time(), player = arg2 or "?", egg = arg3 or "?", outcome = arg4 or "?"})

		while #arg.history > 20 do
			table.remove(arg.history)
		end

		arg:_notify()
	end

	index.setEnabled = function(arg, arg2)
		arg.enabled = arg2 == true

		if arg.enabled then
			arg:_setStatus("looking for a carrier")
			arg:_start()
		else
			arg:_setStatus("idle")
		end
	end

	index._passes = function(arg, arg2)
		if type(arg2) ~= "table" then
			return false
		elseif not arg2.AssetCategory then
			return false
		end

		local v15 = arg.catalog.resolve(arg2)
		local tbl13 = {}
		local flag5 = false

		for i, v16 in ipairs(senaV4Config.StealPlayerRarities or {}) do
			if v16 ~= "None" and v16 ~= "" then
				tbl13[v16] = true
				flag5 = true
			end
		end

		if flag5 then
			if not tbl13[v15.rarity] then
				return false
			end
		else
			for i, v16 in ipairs(senaV4Config.StealRarities or {}) do
				if v16 ~= "None" and v16 ~= "" then
					tbl13[v16] = true
					flag5 = true
				end
			end

			if flag5 and not tbl13[v15.rarity] then
				return false
			end
		end

		local n16 = tonumber(senaV4Config.StealPlayerMinValue) or 0
		if n16 > 0 and (genv.__SenaV4Webhook and genv.__SenaV4Webhook.rateOf(arg2) or 0) < n16 then
			return false
		end
		return true
	end

	index.carriers = function(arg)
		local tbl13, ok, result = {}, pcall(function()
			return EggState2.ReadFieldEggs()
		end)

		if ok then
			if not result then
				return tbl13
			end
		else
			return tbl13
		end

		for i, v15 in ipairs(result.Records or {}) do
			if (v15.State == "Carried" or AreaEggs and AreaEggs.States and v15.State == AreaEggs.States.Carried) and not arg.blacklist[v15.Uid] then
				local v16

				pcall(function()
					v16 = EggState2.ReadFieldEgg(v15.Uid)
				end)

				v16 = v16 or v15
				local carrierUserId = v16.CarrierUserId

				if carrierUserId and carrierUserId ~= localPlayer2.UserId then
					local playerByUserId = Players2:GetPlayerByUserId(carrierUserId)
					local humanoidRootPart = playerByUserId and playerByUserId.Character and playerByUserId.Character:FindFirstChild("HumanoidRootPart")

					if playerByUserId and humanoidRootPart then
						table.insert(tbl13, {record = v16, player = playerByUserId, root = humanoidRootPart})
					end
				end
			end
		end

		return tbl13
	end

	index.clearHistory = function(arg)
		table.clear(arg.history)
		arg:_notify()
	end

	local function fn62(arg)
		if typeof(arg) ~= "Color3" then
			return "ffffff"
		end
		return string.format("%02x%02x%02x", math.floor(arg.R * 255 + 0.5), math.floor(arg.G * 255 + 0.5), math.floor(arg.B * 255 + 0.5))
	end

	index.listEntries = function(arg)
		local tbl13 = {}

		for i, v15 in ipairs(arg:carriers()) do
			tbl13[v15.player] = v15.record
		end

		local humanoidRootPart = localPlayer2.Character and localPlayer2.Character:FindFirstChild("HumanoidRootPart")
		local tbl14 = {}

		for i, player in ipairs(Players2:GetPlayers()) do
			if player ~= localPlayer2 then
				local humanoidRootPart2 = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
				local v15 = tbl13[player]
				local n16, v16, rarityRank, str3, str4 = humanoidRootPart2 and humanoidRootPart and math.floor((humanoidRootPart2.Position - humanoidRootPart.Position).Magnitude + 0.5) or nil, if v15 and v15.AreaId then tostring(v15.AreaId) else if humanoidRootPart2 then humanoidRootPart2.Position.X <= 552.2 and "Safe Zone" or "Field" else "Offline"

				if v15 then
					humanoidRootPart2, i = pcall(function()
						return arg.catalog.resolve(v15)
					end)

					local tbl15 = humanoidRootPart2 and i or {rarityRank = 0, name = tostring(v15.AssetCategory or "Egg"), rarity = "Unknown", rarityColor = Color3.fromRGB(245, 196, 81)}
					rarityRank = tbl15.rarityRank or 0
					str3 = string.format("<font color=\"#%s\">%s</font>  <font color=\"#A2A2AE\">[%s]</font>", fn62(tbl15.rarityColor), tostring(tbl15.name or "Egg"), tostring(tbl15.rarity or "Common"))
					str4 = string.format("Running in %s%s", v16, n16 and "  -  " .. n16 .. " studs" or "")
				else
					str3 = "No Egg Carried"
					str4 = string.format("Idle in %s%s", v16, n16 and "  -  " .. n16 .. " studs" or "")
				end

				tbl14[#tbl14 + 1] = {id = tostring(player.UserId), name = tostring(player.DisplayName or player.Name), sub = string.format("<font color=\"#4ADE80\">@%s</font>  <font color=\"#A2A2AE\">[%s]</font>", tostring(player.Name), v16), status = str3, statusSub = str4, button = "Steal", buttonColor = v15 and "accent" or "dim", player = player, carrying = v15 ~= nil, rank = rarityRank or -1, distance = n16 or 1000000000, onClick = function(arg2, arg3)
					local v17 = arg:strike(arg2.player)
					arg3(v17 and "Chasing" or "No Egg", v17 and "green" or "red")

					task.delay(1.6, function()
						pcall(arg3, "Steal", arg2.carrying and "accent" or "dim")
					end)
				end}
			end
		end

		table.sort(tbl14, function(arg2, arg3)
			if arg2.carrying ~= arg3.carrying then
				return arg2.carrying
			end

			if arg2.carrying and arg2.rank ~= arg3.rank then
				return arg2.rank > arg3.rank
			end
			return arg2.distance < arg3.distance
		end)

		return tbl14
	end

	index._pick = function(arg)
		local stealPlayerTarget, v15, v16 = senaV4Config.StealPlayerTarget

		for i, v17 in ipairs(arg:carriers()) do
			local flag5 = stealPlayerTarget == nil or stealPlayerTarget == "" or stealPlayerTarget == "Any Player" or v17.player.Name == stealPlayerTarget
			local flag6 = v17.root.Position.X > n11 + n12 and v17.player:GetAttribute("InBossArena") ~= true

			if flag5 and (flag6 and arg:_passes(v17.record)) then
				local rarityRank = arg.catalog.resolve(v17.record).rarityRank or 0

				if v15 then
					if rarityRank > v15 then
						v15 = rarityRank
						v16 = v17
					end
				else
					v15 = rarityRank
					v16 = v17
				end
			end
		end

		return v16
	end

	index.strike = function(arg, arg2)
		if arg2 then
			if arg2 == localPlayer2 then
				return false
			end
		else
			return false
		end

		for i, v15 in ipairs(arg:carriers()) do
			if v15.player == arg2 then
				arg.forced = true

				task.spawn(function()
					arg:_chase(v15)
				end)

				return true
			end
		end

		arg:_setStatus(arg2.Name .. " is not carrying an egg")
		return false
	end

	local function fn63()
		local character = localPlayer2.Character
		if not character then
			return
		end
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

		for i, descendant in ipairs(character:GetDescendants()) do
			if descendant:IsA("Motor6D") then
				if not descendant.Enabled then
					descendant.Enabled = true
				end
			elseif descendant:IsA("BallSocketConstraint") or descendant:IsA("HingeConstraint") then
				if descendant.Name:find("Ragdoll") or descendant:GetAttribute("RagdollConstraint") then
					pcall(function()
						descendant:Destroy()
					end)
				end
			elseif descendant:IsA("Attachment") and (descendant.Name:find("Ragdoll") or descendant:GetAttribute("RagdollAttachment")) then
				pcall(function()
					descendant:Destroy()
				end)
			end
		end

		if humanoid then
			humanoid.PlatformStand = false
			humanoid.Sit = false

			pcall(function()
				humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
				humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
				humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
				humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
				humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
				task.wait(0.02)
				humanoid:ChangeState(Enum.HumanoidStateType.Running)
			end)
		end

		if humanoidRootPart then
			humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
			humanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
		end
	end

	local function fn64()
		local guardAreas = fn()
		local areas = guardAreas and guardAreas:FindFirstChild("Areas")
		guardAreas = areas and areas:FindFirstChild("GuardAreas")
		local forest = guardAreas and guardAreas:FindFirstChild("Forest")

		if forest then
			local guard = forest:FindFirstChild("Guard")
			local humanoidRootPart = guard and (guard:FindFirstChild("HumanoidRootPart") or guard:FindFirstChild("Collider") or guard:IsA("Model") and guard.PrimaryPart)
			if guard and humanoidRootPart then
				return guard, humanoidRootPart
			end
			local forestGuardAuthored = forest:FindFirstChild("ForestGuardAuthored")
			local humanoidRootPart2 = forestGuardAuthored and (forestGuardAuthored:FindFirstChild("HumanoidRootPart") or forestGuardAuthored:IsA("Model") and forestGuardAuthored.PrimaryPart)
			if forestGuardAuthored and humanoidRootPart2 then
				return forestGuardAuthored, humanoidRootPart2
			end
		end

		local areaGuards = workspace:FindFirstChild("AreaGuards")

		if areaGuards then
			for i, child in ipairs(areaGuards:GetChildren()) do
				local humanoidRootPart = child:FindFirstChild("HumanoidRootPart")
				if humanoidRootPart and humanoidRootPart.Position.X < 850 then
					return child, humanoidRootPart
				end
			end
		end

		return nil, nil
	end

	local function fn65(arg)
		local v15

		pcall(function()
			v15 = EggState2.ReadFieldEggs()
		end)

		local records, v16 = v15 and v15.Records or {}

		for i, record in ipairs(records) do
			local flag5, v17 = (record.State == "Slot" or record.State == "Dropped") and record.Uid ~= arg

			if flag5 then
				local carrierUserId = record.CarrierUserId
				v17 = if carrierUserId then record.CarrierUserId == localPlayer2.UserId else not carrierUserId
			else
				v17 = flag5
			end

			if v17 then
				local position = record.BottomCFrame and record.BottomCFrame.Position or record.BoundsCFrame and record.BoundsCFrame.Position

				if record.AreaId == "Forest" or tostring(record.Uid):find("Forest", 1, true) or tostring(record.Uid):find("^FirstArea") or position and position.X < 680 then
					if record.State == "Slot" then
						v16 = record
						break
					elseif v16 then
					else
						v16 = record
					end
				end
			end
		end

		return v16
	end

	index._primeForest = function(arg, arg2)
		local eggRuntime = arg.eggRuntime
		local character = localPlayer2.Character
		local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")

		if humanoidRootPart then
			if humanoid then
				if not (humanoid.Health > 0) then
					return false
				end
			else
				return false
			end
		else
			return false
		end

		if eggRuntime and eggRuntime.carry and (eggRuntime.carry.active and eggRuntime.carry.uid) then
			pcall(function()
				eggRuntime:_returnToSafe()
			end)

			task.wait(0.08)
		end

		arg:_setStatus("Preparing steal")
		local v15 = fn65(arg2)
		if not v15 then
			arg:_setStatus("Steal unavailable \226\128\148 retrying")
			return false
		end
		local position = v15.BottomCFrame and v15.BottomCFrame.Position or v15.BoundsCFrame and v15.BoundsCFrame.Position or Vector3.new(596.6, 67.7, -325)
		local vector2 = Vector3.new(position.X, position.Y + 2.5, position.Z)
		local str3 = "Forest:" .. tostring(v15.NestId or "Slot_001")

		pcall(function()
			local AreaEggSlotIdentity = require(ReplicatedStorage2.Shared.Util.AreaEggSlotIdentity)

			if AreaEggSlotIdentity and (v15.AreaId and v15.NestId) then
				str3 = AreaEggSlotIdentity.SlotKey(v15.AreaId, v15.NestId)
			end
		end)

		arg:_setStatus("Preparing steal")
		humanoidRootPart.CFrame = CFrame.new(vector2)
		humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
		humanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
		RunService.Heartbeat:Wait()
		local now = os.clock()
		local flag5 = false
		arg2 = 0

		while if flag5 then true else os.clock() - now < 0.8 do
			humanoidRootPart = character:FindFirstChild("HumanoidRootPart") or humanoidRootPart

			if humanoidRootPart and humanoidRootPart.Position.Y < 65 then
				humanoidRootPart.CFrame = CFrame.new(vector2)
				humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
			end

			if os.clock() >= arg2 then
				arg2 = os.clock() + 0.1

				task.spawn(function()
					pcall(function()
						EggState2.CarryFieldEgg(v15.Uid, str3)
					end)
				end)

				task.spawn(function()
					pcall(function()
						local Remotes = require(ReplicatedStorage2.Shared.Remotes)

						if Remotes and (Remotes.EggWorld and Remotes.EggWorld.AskFieldEggCarry) then
							Remotes.EggWorld.AskFieldEggCarry:InvokeServer({Uid = v15.Uid, FirstAreaSlotKey = str3})
						end
					end)
				end)
			end

			local v16

			pcall(function()
				v16 = EggState2.ReadFieldEgg(v15.Uid)
			end)

			if v16 and v16.State == "Carried" and v16.CarrierUserId == localPlayer2.UserId then
				flag5 = true
				break
			end
			RunService.Heartbeat:Wait()
		end

		if not flag5 then
			arg:_setStatus("Steal unavailable \226\128\148 retrying")
			fn63()
			return false
		end

		arg:_setStatus("Preparing steal")
		local v16, v17 = fn64()

		if v16 then
			v16:FindFirstChild("Collider")
		end

		local position2 = v17 and v17.Position or Vector3.new(596.6, 69.4, -317.1)
		humanoidRootPart.CFrame = CFrame.new(position2.X, position2.Y + 0.8, position2.Z)
		humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
		humanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
		local flag6 = false
		local tbl13 = {}

		pcall(function()
			local reRigSyncRefresh = ReplicatedStorage2:FindFirstChild("Packages") and ReplicatedStorage2.Packages:FindFirstChild("Networking") and ReplicatedStorage2.Packages.Networking:FindFirstChild("RE/RigSync/Refresh")

			if reRigSyncRefresh then
				table.insert(tbl13, reRigSyncRefresh.OnClientEvent:Connect(function()
					flag6 = true
				end))
			end
		end)

		pcall(function()
			local Remotes = require(ReplicatedStorage2.Shared.Remotes)

			if Remotes and (Remotes.EggWorld and Remotes.EggWorld.OwnerDropped) then
				table.insert(tbl13, Remotes.EggWorld.OwnerDropped.OnClientEvent:Connect(function()
					flag6 = true
				end))
			end
		end)

		if humanoid then
			table.insert(tbl13, humanoid.StateChanged:Connect(function(old, new)
				if new == Enum.HumanoidStateType.Ragdoll then
					flag6 = true
				else
					if new == Enum.HumanoidStateType.FallingDown then
						flag6 = true
					else
						if new == Enum.HumanoidStateType.PlatformStanding then
							flag6 = true
						end
					end
				end
			end))

			table.insert(tbl13, humanoid:GetPropertyChangedSignal("PlatformStand"):Connect(function()
				if humanoid.PlatformStand then
					flag6 = true
				end
			end))
		end

		local function fn66()
			v16, v17 = fn64()
			local position3 = v17 and v17.Position or position2
			local humanoidRootPart2 = character:FindFirstChild("HumanoidRootPart")

			if humanoidRootPart2 then
				humanoidRootPart2.CFrame = CFrame.new(position3.X, position3.Y + 0.8, position3.Z)
				humanoidRootPart2.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
			end

			local collider = v16 and v16:FindFirstChild("Collider") or v17

			if collider and type(firetouchinterest) == "function" and humanoidRootPart2 then
				pcall(function()
					firetouchinterest(humanoidRootPart2, collider, 0)
					firetouchinterest(humanoidRootPart2, collider, 1)
				end)
			end

			pcall(function()
				local Remotes = require(ReplicatedStorage2.Shared.Remotes)

				if Remotes and (Remotes.GuardPatrol and Remotes.GuardPatrol.ForestStrike) then
					local forestStrike = Remotes.GuardPatrol.ForestStrike
					local tbl14 = {EggUid = v15.Uid}
					tbl14.GuardCFrame = v17 and v17.CFrame or CFrame.new(position3)
					forestStrike:FireServer(tbl14)
				end
			end)
		end

		arg:_setStatus("Preparing steal")
		fn66()
		vector2 = os.clock() + 0.75
		arg2 = os.clock() + 0.05

		while os.clock() < vector2 do
			if flag6 then
				break
			end
			local humanoid2 = localPlayer2.Character and localPlayer2.Character:FindFirstChildOfClass("Humanoid")
			if humanoid2 and (humanoid2.PlatformStand or humanoid2.Sit) then
				flag6 = true
				break
			end
			local humanoidRootPart2 = localPlayer2.Character and localPlayer2.Character:FindFirstChild("HumanoidRootPart")
			if humanoidRootPart2 and humanoidRootPart2.AssemblyLinearVelocity.Magnitude > 18 then
				flag6 = true
				break
			end

			if humanoidRootPart2 and humanoidRootPart2.Position.Y < 65 then
				humanoidRootPart2.CFrame = CFrame.new(position2.X, 70, position2.Z)
				humanoidRootPart2.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
			end

			if os.clock() >= arg2 then
				arg2 = os.clock() + 0.05
				fn66()
			end

			RunService.Heartbeat:Wait()
		end

		for i, v18 in ipairs(tbl13) do
			pcall(v18.Disconnect, v18)
		end

		if not flag6 then
			arg:_setStatus("Steal unavailable \226\128\148 retrying")
			fn63()
			return false, v15.Uid
		end

		arg:_setStatus("Preparing steal")
		fn63()
		local n16 = os.clock() + 0.35

		while os.clock() < n16 do
			local humanoid2 = localPlayer2.Character and localPlayer2.Character:FindFirstChildOfClass("Humanoid")
			local humanoidRootPart2 = localPlayer2.Character and localPlayer2.Character:FindFirstChild("HumanoidRootPart")

			if humanoid2 and (humanoidRootPart2 and (not humanoid2.PlatformStand and not humanoid2.Sit)) then
				local state = humanoid2:GetState()

				if state ~= Enum.HumanoidStateType.Ragdoll and (state ~= Enum.HumanoidStateType.FallingDown and state ~= Enum.HumanoidStateType.PlatformStanding) then
					humanoidRootPart2.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
					humanoidRootPart2.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
					break
				end
			end

			fn63()
			RunService.Heartbeat:Wait()
		end

		return true, v15.Uid
	end

	index._swingBatAt = function(arg, arg2, arg3)
		if arg3 then
			if arg3.Parent ~= localPlayer2.Character then
				return false
			end
		else
			return false
		end

		arg.swingSeq = arg.swingSeq + 1
		local str3 = string.format("%d:%d:%d", localPlayer2.UserId, arg.swingSeq, math.floor(workspace:GetServerTimeNow() * 1000))

		return pcall(function()
			require(ReplicatedStorage2.Shared.Remotes).BatSwing.Trigger:FireServer(arg2, str3)
		end)
	end

	index._dropUnwanted = function(arg)
		local v15

		local function fn66()
			for i, v16 in ipairs(EggState2.ReadFieldEggs().Records or {}) do
				if v16.State == "Carried" and v16.CarrierUserId == localPlayer2.UserId then
					v15 = EggState2.ReadFieldEgg(v16.Uid) or v16
					break
				end
			end
		end

		pcall(fn66)

		if v15 and not arg:_passes(v15) then
			pcall(EggState2.DropFieldEgg, "PlayerRequest")
			task.wait(0.3)
			return true
		end

		return false
	end

	index._returnSafe = function(arg)
		arg:_dropUnwanted()
		local eggRuntime = arg.eggRuntime
		local character = localPlayer2.Character
		local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")

		if eggRuntime then
			if humanoidRootPart then
				if humanoid then
					if eggRuntime:_isInSafeArea(humanoidRootPart) then
						return
					end
				else
					return
				end
			else
				return
			end
		else
			return
		end

		local v15 = eggRuntime:_resolveSafeCFrame(humanoidRootPart)
		if not v15 then
			return
		end
		arg:_setStatus("Returning to safe zone")

		fn38(humanoidRootPart, humanoid, v15, function()
			return humanoid.Health <= 0 or not humanoidRootPart.Parent
		end, false, nil, true)
	end

	index.intercept = function(arg, arg2)
		if arg.running then
			return false
		end
		local humanoidRootPart = localPlayer2.Character and localPlayer2.Character:FindFirstChild("HumanoidRootPart")
		if not humanoidRootPart then
			return false
		end

		for i, v15 in ipairs(arg:carriers()) do
			if v15.record.Uid == arg2 then
				if v15.root.Position.X <= n11 then
					return false
				elseif (v15.root.Position - humanoidRootPart.Position).Magnitude > n10 then
					return false
				elseif not arg:_passes(v15.record) then
					return false
				end

				arg.forced = true
				task.spawn(arg._chase, arg, v15, true)
				return arg.running
			end
		end

		return false
	end

	index._chase = function(arg, arg2, arg3)
		if arg.running then
			return
		end
		arg.running = true
		arg.attempts = arg.attempts + 1
		local record = arg2.record
		local uid = record.Uid
		local v15 = arg.catalog.resolve(record)
		local player = arg2.player
		arg2 = player.DisplayName or player.Name
		arg.cardTarget = {uid = uid, record = record, player = arg2}

		if arg.godMode then
			arg.godMode:stopDefend()
		end

		if not arg3 then
			arg:_returnSafe()
			arg:_setStatus(string.format("Preparing to steal from %s", arg2))
			local ok, result, result2 = pcall(arg._primeForest, arg, uid)
			local v16

			if ok then
				if result then
				elseif result2 then
					pcall(function()
						v16 = EggState2.ReadFieldEgg(result2)
					end)
				end
			end

			if v16 and v16.State == "Carried" and v16.CarrierUserId == localPlayer2.UserId then
				arg:_returnSafe()
				arg:_log(arg2, v15.name, "could not prepare")
				arg:_setStatus(arg.enabled and "looking for a carrier" or "idle")
				arg.running = false
				arg.forced = false
				return
			end
		end

		local godMode = arg.godMode and arg.godMode:_equipBat()
		local n16 = os.clock() + (arg3 and n9 or n8)
		local tbl13 = {}
		local vector2 = Vector3.new(0, 0, 0)
		local attribute = player:GetAttribute("RagdollEndTime") or false
		local n17 = 0.1

		pcall(function()
			n17 = math.clamp(localPlayer2:GetNetworkPing() or 0.1, 0.03, 0.6)
		end)

		local n18 = math.clamp(0.14 + n17, 0.14, 0.35)
		arg.leadIdx = arg.hitIdx or arg.leadIdx or 1
		arg.missStreak = 0
		local connection6

		local function fn66()
			connection6 = RunService.Stepped:Connect(function()
				local character = localPlayer2.Character

				if character then
					for i, descendant in ipairs(character:GetDescendants()) do
						if descendant:IsA("BasePart") then
							descendant.CanCollide = false
						end
					end
				end
			end)
		end

		pcall(fn66)
		arg:_setStatus(string.format("Chasing %s", arg2))
		fn66 = "could not catch them"
		local now, now2, now3
		local n19, v16 = 0
		local n20 = 0

		while os.clock() < n16 do
			local result = RunService.PreSimulation:Wait()
			local enabled = arg.enabled
			if if enabled then not enabled else not arg.forced then
				fn66 = "stopped"
				break
			end
			local v17

			pcall(function()
				v17 = EggState2.ReadFieldEgg(uid)
			end)

			enabled = v17 and v17.State
			if not v17 or enabled == "Slot" or enabled == "GuardCarried" then
				fn66 = "egg reset"
				break
			end

			if enabled == "Claimed" then
				fn66 = "they banked it"
				break
			end

			if enabled == "Carried" and v17.CarrierUserId == localPlayer2.UserId then
				fn66 = "taken"
				break
			end

			if enabled == "Dropped" then
				local now4 = os.clock()
				local flag5 = (player:GetAttribute("RagdollEndTime") or false) ~= attribute

				if now ~= nil and (now2 ~= nil and now4 - now2 <= 1 or now3 ~= nil and now4 - now3 <= 1.5 or flag5) then
					if now2 and now4 - now2 <= 1 then
						arg.hitIdx = arg.leadIdx
					end

					arg:_setStatus(string.format("Grabbing dropped egg from %s", arg2))
					fn66 = arg:_grab(v17, player, godMode) and "taken" or "someone else grabbed it"
				else
					fn66 = arg:_grabForeignDrop(v17, player, godMode) and "taken" or "someone else grabbed it"
				end

				break
			end

			local character = localPlayer2.Character
			local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
			local humanoid = character and character:FindFirstChildOfClass("Humanoid")
			if (if humanoidRootPart then not humanoid else not humanoidRootPart) or humanoid.Health <= 0 then
				fn66 = "character died"
				break
			end

			if v17.CarrierUserId ~= player.UserId then
				local playerByUserId = Players2:GetPlayerByUserId(v17.CarrierUserId or 0)
				if not playerByUserId then
					fn66 = "taken by another player"
					break
				end
				arg2 = playerByUserId.DisplayName or playerByUserId.Name
				attribute = playerByUserId:GetAttribute("RagdollEndTime") or false
				table.clear(tbl13)
				arg:_setStatus(string.format("Chasing %s", arg2))
				player = playerByUserId
				now = nil
				now2 = nil
			end

			local humanoidRootPart2 = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
			if not humanoidRootPart2 then
				fn66 = "lost sight of them"
				break
			end

			if humanoidRootPart2.Position.X <= n11 then
				fn66 = "banked"
				break
			end
			local now4 = os.clock()
			tbl13[#tbl13 + 1] = {t = now4, p = humanoidRootPart2.Position}

			while #tbl13 > 2 and now4 - tbl13[1].t > 0.4 do
				table.remove(tbl13, 1)
			end

			local assemblyLinearVelocity = humanoidRootPart2.AssemblyLinearVelocity
			vector2 = if Vector3.new(assemblyLinearVelocity.X, 0, assemblyLinearVelocity.Z).Magnitude > 8 then assemblyLinearVelocity else if #tbl13 >= 2 then if now4 - tbl13[1].t > 0.15 then (humanoidRootPart2.Position - tbl13[1].p) / (now4 - tbl13[1].t) else vector2 else vector2
			local vector3 = Vector3.new(vector2.X, 0, vector2.Z)
			local magnitude, unit = vector3.Magnitude

			if magnitude > 6 then
				unit = vector3.Unit
			else
				assemblyLinearVelocity = humanoidRootPart2.CFrame.LookVector
				assemblyLinearVelocity = Vector3.new(assemblyLinearVelocity.X, 0, assemblyLinearVelocity.Z)
				unit = assemblyLinearVelocity.Magnitude > 0.05 and assemblyLinearVelocity.Unit or Vector3.new(-1, 0, 0)
			end

			local n21 = math.clamp((tbl12[arg.leadIdx] or 1) * magnitude * n18, 3, n14)
			now4 = humanoidRootPart2.Position + unit * n21
			local v18 = if now4.X < n11 + 5 then Vector3.new(n11 + 5, now4.Y, now4.Z) else now4
			assemblyLinearVelocity = Vector3.new(humanoidRootPart2.Position.X, v18.Y, humanoidRootPart2.Position.Z)
			local v19 = if (assemblyLinearVelocity - v18).Magnitude < 0.5 then v18 - unit else assemblyLinearVelocity
			local cframe = CFrame.lookAt(v18, v19)
			local n22 = v18 - humanoidRootPart.Position
			now4 = n22.Magnitude
			local v20 = fn4()
			local n23 = v20 * math.min(result, 0.05)
			fn15(character, v20 * v2.HEADROOM)
			local n24

			if now4 > n23 then
				humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.Position + n22.Unit * n23) * cframe.Rotation
				humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
				n24 = n22.Unit * v20
			else
				humanoidRootPart.CFrame = cframe
				humanoidRootPart.AssemblyLinearVelocity = humanoidRootPart2.AssemblyLinearVelocity
				n24 = humanoidRootPart2.AssemblyLinearVelocity
			end

			humanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)

			if not fn24(humanoid, humanoidRootPart, v20, n24) then
				fn23(humanoid, humanoidRootPart, v20)
				fn24(humanoid, humanoidRootPart, v20, n24)
			end

			local n25 = magnitude * result * 1.5

			if now4 <= 5 + n25 then
				now = now or os.clock()
				arg:_setStatus(humanoidRootPart2.Position.X <= n13 and string.format("Attacking %s", arg2) or string.format("Chasing %s", arg2))
			else
				if now4 > 12 + n25 and now then
					arg:_setStatus(string.format("Chasing %s", arg2))
					now = nil
				end
			end

			local attribute2 = player:GetAttribute("RagdollEndTime") or false

			if attribute2 ~= attribute then
				now3 = os.clock()
				arg.hitIdx = arg.leadIdx
				arg.missStreak = 0
				attribute = attribute2
				now2 = nil
			end

			if (not godMode or godMode.Parent ~= character) and os.clock() >= n19 then
				local n26 = os.clock() + 0.5

				task.spawn(function()
					godMode = arg.godMode and arg.godMode:_equipBat() or godMode
				end)

				n19 = n26
			end

			local n26 = godMode and tonumber(godMode:GetAttribute("CooldownEndTime")) or 0

			if now2 and os.clock() - now2 > 0.9 then
				if n26 ~= v16 then
					arg.missStreak = arg.missStreak + 1

					if arg.missStreak >= 2 then
						arg.missStreak = 0
						arg.leadIdx = arg.leadIdx % #tbl12 + 1
						now = nil
					end
				end

				now2 = nil
			end

			if godMode and godMode.Parent == character and (now and (os.clock() - now >= n18 + 0.05 and (humanoidRootPart2.Position.X <= n13 and (godMode:GetAttribute("CooldownActive") ~= true and (workspace:GetServerTimeNow() >= n26 and os.clock() - n20 >= 0.35))))) then
				local now5 = os.clock()

				if now2 then
				else
					now2 = os.clock()
					v16 = n26
				end

				task.spawn(arg._swingBatAt, arg, player, godMode)
				n20 = now5
			end
		end

		if connection6 then
			pcall(function()
				connection6:Disconnect()
			end)
		end

		if fn66 == "taken" then
			arg.taken = arg.taken + 1
			arg:_deliver(uid, record)
		else
			arg.blacklist[uid] = os.clock() + 20
			arg:_returnSafe()
		end

		arg:_log(arg2, v15.name, fn66)
		arg:_setStatus(arg.enabled and "looking for a carrier" or "idle")
		arg.running = false
		arg.forced = false
	end

	index._grabForeignDrop = function(arg, arg2, arg3, arg4)
		local uid = arg2.Uid

		local function fn66()
			local v15

			pcall(function()
				v15 = EggState2.ReadFieldEgg(uid)
			end)

			return v15
		end

		local character = localPlayer2.Character
		local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		local position = arg2.BottomCFrame and arg2.BottomCFrame.Position or arg2.BoundsCFrame and arg2.BoundsCFrame.Position

		if humanoidRootPart and humanoid then
			if humanoid.Health > 0 then
				if not position then
					return false
				end
			else
				return false
			end
		else
			return false
		end

		if (humanoidRootPart.Position - position).Magnitude > 8 then
			arg:_setStatus("Moving to dropped egg")

			fn38(humanoidRootPart, humanoid, CFrame.new(position + Vector3.new(0, 3, 0)), function()
				local v15 = fn66()
				local enabled = arg.enabled
				return (if enabled then not enabled else not arg.forced) or humanoid.Health <= 0 or not humanoidRootPart.Parent or v15 == nil or v15.State ~= "Dropped"
			end)
		end

		local v15 = fn66()
		if v15 and v15.State == "Carried" then
			return v15.CarrierUserId == localPlayer2.UserId
		end

		if v15 then
			if v15.State ~= "Dropped" then
				return false
			end
		else
			return false
		end

		return arg:_grab(v15, arg3, arg4, false, n15)
	end

	index._deliver = function(arg, arg2, arg3)
		pcall(function()
			local humanoid = localPlayer2.Character and localPlayer2.Character:FindFirstChildOfClass("Humanoid")

			if humanoid then
				humanoid:UnequipTools()
			end
		end)

		local eggRuntime = arg.eggRuntime

		if eggRuntime and type(eggRuntime.deliverCarriedEgg) == "function" and eggRuntime:deliverCarriedEgg(arg2, arg3) == true then
			arg:_setStatus("Delivering stolen egg")
			local n16 = os.clock() + 30

			while eggRuntime._instantReturnToken ~= nil and os.clock() < n16 do
				task.wait(0.2)
			end

			return
		end

		local function fn66()
			local v15

			pcall(function()
				v15 = EggState2.ReadFieldEgg(arg2)
			end)

			return v15 == nil or v15.State == "Claimed"
		end

		arg:_setStatus("Carrying stolen egg home")
		local n16 = os.clock() + 8

		while true do
			local v15 = fn66()
			if not (if v15 then not v15 else os.clock() < n16) then
				break
			end
			local character = localPlayer2.Character
			local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

			if humanoidRootPart and (eggRuntime and not eggRuntime:_isInSafeArea(humanoidRootPart)) then
				arg:_returnSafe()
			end

			task.wait(0.1)
		end
	end

	index._snipe = function(arg, arg2, arg3)
		if arg.running then
			return
		end
		arg.running = true
		arg.attempts = arg.attempts + 1
		local uid = arg2.Uid
		local v15 = arg.catalog.resolve(arg2)
		local playerByUserId = Players2:GetPlayerByUserId(arg3 or 0)
		local displayName = playerByUserId and (playerByUserId.DisplayName or playerByUserId.Name) or "?"
		arg.cardTarget = {uid = uid, record = arg2, player = displayName}
		local position = arg2.BottomCFrame and arg2.BottomCFrame.Position or arg2.BoundsCFrame and arg2.BoundsCFrame.Position
		local str3 = "someone else grabbed it"

		local function fn66()
			local v16

			pcall(function()
				v16 = EggState2.ReadFieldEgg(uid)
			end)

			return v16 ~= nil and v16.State == "Dropped", v16
		end

		local character = localPlayer2.Character
		local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")

		if position and (humanoidRootPart and (humanoid and humanoid.Health > 0)) then
			if arg.godMode then
				arg.godMode:stopDefend()
			end

			arg:_setStatus(string.format("Sniping %s's dropped egg", displayName))

			fn38(humanoidRootPart, humanoid, CFrame.new(position + Vector3.new(0, 3, 0)), function()
				local enabled = arg.enabled
				return (if enabled then humanoid.Health <= 0 else not enabled) or not fn66()
			end)

			local v16, v17 = fn66()
			str3 = if v16 then if arg.enabled then arg:_grab(v17, nil, nil, true) and "taken" or str3 else str3 else str3
		end

		if str3 == "taken" then
			arg.taken = arg.taken + 1
			arg:_deliver(uid, arg2)
		else
			arg.blacklist[uid] = os.clock() + 20
			arg:_returnSafe()
		end

		arg:_log(displayName, v15.name, str3 == "taken" and "sniped drop" or str3)
		arg:_setStatus(arg.enabled and "looking for a carrier" or "idle")
		arg.running = false
	end

	index._watchDrops = function(arg)
		if arg.dropConns then
			return
		end

		local function fn66()
			if genv.ChloeX_Running == nil and genv.__SenaV4PlayerSteal ~= arg then
				for i, v15 in ipairs(arg.dropConns or {}) do
					pcall(function()
						v15:Disconnect()
					end)
				end

				return false
			end

			return true
		end

		pcall(function()
			for i, v15 in ipairs(EggState2.ReadFieldEggs().Records or {}) do
				if v15.State == "Carried" and v15.CarrierUserId then
					arg.lastCarrier[v15.Uid] = v15.CarrierUserId
				end
			end
		end)

		arg.dropConns = {}

		table.insert(arg.dropConns, EggState2.FieldShifted:Connect(function(arg2)
			if fn66() then
				if type(arg2) ~= "table" then
					return
				elseif not arg2.Uid then
					return
				end
			else
				return
			end

			if arg2.State == "Carried" then
				arg.lastCarrier[arg2.Uid] = arg2.CarrierUserId
				return
			end

			if arg2.State ~= "Dropped" then
				arg.lastCarrier[arg2.Uid] = nil
				return
			end
			local v15 = arg.lastCarrier[arg2.Uid]

			if v15 then
				if v15 == localPlayer2.UserId then
					return
				end
			else
				return
			end

			if arg.enabled then
				if arg.running then
					return
				elseif arg.blacklist[arg2.Uid] then
					return
				end
			else
				return
			end

			local eggRuntime = arg.eggRuntime
			local senaV4ButterflyRuntime = genv.__SenaV4ButterflyRuntime

			if eggRuntime then
				if eggRuntime.running then
					return
				elseif eggRuntime.carry then
					if eggRuntime.carry.active then
						return
					end
				end
			end

			if senaV4ButterflyRuntime ~= nil and senaV4ButterflyRuntime.active == true then
				return
			end
			local position = arg2.BottomCFrame and arg2.BottomCFrame.Position

			if position then
				if position.X <= n11 then
					return
				end
			else
				return
			end

			if localPlayer2:GetAttribute("InBossArena") == true then
				return
			end

			if not arg:_passes(arg2) then
				return
			end
			task.spawn(arg._snipe, arg, arg2, v15)
		end))

		table.insert(arg.dropConns, EggState2.FieldGone:Connect(function(arg2)
			if fn66() then
				arg.lastCarrier[arg2] = nil
			end
		end))
	end

	index._grab = function(arg, arg2, arg3, arg4, arg5, arg6)
		local eggRuntime = arg.eggRuntime
		local uid, RagdollJoints = arg2.Uid

		pcall(function()
			RagdollJoints = require(ReplicatedStorage2.Shared.Modules.RagdollJoints)
		end)

		local function fn66()
			local v15

			pcall(function()
				v15 = EggState2.ReadFieldEgg(uid)
			end)

			return v15
		end

		local function fn67(arg7, arg8)
			pcall(function()
				if RagdollJoints and RagdollJoints.Release then
					RagdollJoints.Release(arg7)
				end

				arg8.PlatformStand = false
				arg8.Sit = false

				if arg8:GetState() ~= Enum.HumanoidStateType.Running then
					arg8:ChangeState(Enum.HumanoidStateType.GettingUp)
				end
			end)
		end

		local function fn68(arg7, arg8, arg9)
			local cframe = eggRuntime and eggRuntime:_resolveEggDestination(arg7, arg8, arg9)

			if cframe then
			else
				local position = arg7.BottomCFrame and arg7.BottomCFrame.Position or arg7.BoundsCFrame and arg7.BoundsCFrame.Position
				cframe = position and CFrame.new(position.X, position.Y + 2.5, position.Z)
			end

			return cframe
		end

		local function fn69(arg7, arg8, arg9, cFrame)
			arg8.CFrame = cFrame
			arg8.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
			arg8.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
			local n16 = math.clamp(fn4(), v2.MIN_SPEED, v2.MAX_SPEED)
			fn15(arg7, n16 * v2.HEADROOM)

			if not fn24(arg9, arg8, n16, (Vector3.new(0, 0, 0))) then
				fn23(arg9, arg8, n16)
			end
		end

		local function fn70()
			if arg3 then
				if not arg4 then
					return
				end
			else
				return
			end

			local character = localPlayer2.Character

			if character then
				if arg4.Parent ~= character then
					return
				end
			else
				return
			end

			if workspace:GetServerTimeNow() >= (tonumber(arg4:GetAttribute("CooldownEndTime")) or 0) and arg4:GetAttribute("CooldownActive") ~= true then
				task.spawn(arg._swingBatAt, arg, arg3, arg4)
			end
		end

		local n16 = 2.5

		pcall(function()
			n16 = math.clamp(eggRuntime:_resolveSettleSeconds(arg2), 1.5, 4)
		end)

		if arg6 then
			n16 = math.max(n16, arg6)
		end

		local n17, v15 = arg5 and 0 or os.clock() + n16

		while os.clock() < n17 do
			local v16 = fn66()
			local state = v16 and v16.State

			if state == "Carried" then
				if v16.CarrierUserId ~= localPlayer2.UserId then
					return false
				end
				return true
			end

			if state ~= "Dropped" and state ~= "Slot" then
				return false
			end
			local character = localPlayer2.Character
			local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
			local humanoid = character and character:FindFirstChildOfClass("Humanoid")

			if humanoidRootPart then
				if humanoid then
					if humanoid.Health <= 0 then
						return false
					end
				else
					return false
				end
			else
				return false
			end

			fn67(character, humanoid)
			v15 = fn68(v16, humanoidRootPart, humanoid) or v15

			if v15 then
				fn69(character, humanoidRootPart, humanoid, v15)
			end

			fn70()
			arg:_setStatus(string.format("Securing dropped egg (%ds)", math.ceil(n17 - os.clock())))
			RunService.Heartbeat:Wait()
		end

		local flag5 = false
		local flag6 = false
		local n18 = os.clock() + 3.5

		while os.clock() < n18 do
			local v16 = fn66()
			local state = v16 and v16.State

			if state == "Carried" then
				if v16.CarrierUserId ~= localPlayer2.UserId then
					return false
				end

				if genv.__SenaV4Webhook then
					local ok, result = pcall(arg.catalog.resolve, v16)
					pcall(genv.__SenaV4Webhook.stolen, v16, ok and result or nil, "player carry")
				end

				return true
			end

			if state ~= "Dropped" and state ~= "Slot" then
				return false
			end
			local character = localPlayer2.Character
			local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
			local humanoid = character and character:FindFirstChildOfClass("Humanoid")

			if humanoidRootPart then
				if humanoid then
					if humanoid.Health <= 0 then
						return false
					end
				else
					return false
				end
			else
				return false
			end

			fn67(character, humanoid)
			local v17 = fn68(v16, humanoidRootPart, humanoid) or v15

			if v17 then
				fn69(character, humanoidRootPart, humanoid, v17)
			end

			fn70()

			if not flag5 then
				flag5 = true

				task.spawn(function()
					pcall(function()
						require(ReplicatedStorage2.Shared.Remotes).EggWorld.AskFieldEggCarry:InvokeServer({Uid = uid})
					end)

					flag5 = false
				end)
			end

			if not flag6 then
				flag6 = true

				task.spawn(function()
					pcall(function()
						EggState2.CarryFieldEgg(uid)
					end)

					flag6 = false
				end)
			end

			pcall(function()
				local areaEggSlotsClient = workspace:FindFirstChild("AreaEggSlotsClient")
				local v18 = areaEggSlotsClient and areaEggSlotsClient:FindFirstChild(tostring(uid))
				local carryAreaEgg = v18 and (v18:FindFirstChild("CarryAreaEgg", true) or v18:FindFirstChildWhichIsA("ProximityPrompt", true))

				if carryAreaEgg and (carryAreaEgg.Enabled and type(fireproximityprompt) == "function") then
					carryAreaEgg.HoldDuration = 0
					carryAreaEgg.RequiresLineOfSight = false
					fireproximityprompt(carryAreaEgg, 0)
				end
			end)

			task.wait(0.06)
		end

		return false
	end

	index._start = function(arg)
		arg:_watchDrops()
		if arg.loop then
			return
		end

		arg.loop = task.spawn(function()
			while true do
				task.wait(0.4)
				if genv.ChloeX_Running == nil and genv.__SenaV4PlayerSteal ~= arg then
					break
				end

				for k, v15 in pairs(arg.blacklist) do
					if os.clock() > v15 then
						arg.blacklist[k] = nil
					end
				end

				local eggRuntime = arg.eggRuntime
				local senaV4ButterflyRuntime = genv.__SenaV4ButterflyRuntime
				local running = eggRuntime and (eggRuntime.running or eggRuntime.carry and eggRuntime.carry.active)
				local flag5 = senaV4ButterflyRuntime ~= nil and senaV4ButterflyRuntime.active == true
				local v15 = if arg.enabled then if arg.running then nil else if running then nil else arg:_pick() else nil
				arg.wantsTarget = v15 ~= nil

				if v15 and not flag5 then
					arg:_chase(v15)
				end
			end

			arg.loop = nil
		end)
	end

	return index
end)()

local v15 = v9.new(v13)
v15:install()
v15:setEnabled(senaV4Config.AntiGuardKnockback == true)
genv.__SenaV4AntiGuard = v15
local v16 = v10.new(v13)
v16:setEnabled(senaV4Config.GodMode == nil and true or senaV4Config.GodMode == true)
genv.__SenaV4GodMode = v16
local v17 = walkSpeedMultiplier.new(v13, v16, v6)

local v18 = (function()
	local Players2 = game:GetService("Players")
	local RunService2 = game:GetService("RunService")
	local UserInputService = game:GetService("UserInputService")
	local localPlayer2 = Players2.LocalPlayer
	local n8 = 110
	local holdDuration = 0.1
	local str3 = "CarryAreaEgg"
	local n9 = 55
	local n10 = 0.08
	local n11 = 0.28
	local index = {}
	index.__index = index

	index.new = function()
		local obj = setmetatable({}, index)
		obj.flyEnabled = false
		obj.flyConnection = nil
		obj.flyMover = nil
		obj.grabEnabled = false
		obj.grabConnection = nil
		obj.grabOriginals = setmetatable({}, {__mode = "k"})
		obj.jumpEnabled = false
		obj.jumpConnections = {}
		obj.lastJumpAt = 0
		obj.speedMultiplier = 1
		obj.speedModules = nil
		obj.speedConnection = nil
		return obj
	end

	index._root = function(arg)
		local character = localPlayer2.Character
		return character and character:FindFirstChild("HumanoidRootPart")
	end

	index._humanoid = function(arg)
		local character = localPlayer2.Character
		return character and character:FindFirstChildOfClass("Humanoid")
	end

	index._ensureMover = function(arg, parent)
		if arg.flyMover and arg.flyMover.Parent == parent then
			return
		end

		if arg.flyMover then
			pcall(function()
				arg.flyMover:Destroy()
			end)
		end

		local bodyVelocity = Instance.new("BodyVelocity")
		bodyVelocity.Name = "SenaFlyCaptureHover"
		bodyVelocity.MaxForce = Vector3.new(0, 9000000000, 0)
		bodyVelocity.Velocity = Vector3.new(0, 0, 0)
		bodyVelocity.Parent = parent
		arg.flyMover = bodyVelocity
	end

	local function fn62()
		local senaV4TreadmillManager = genv.__SenaV4TreadmillManager
		return senaV4TreadmillManager ~= nil and not senaV4TreadmillManager.destroyed and senaV4TreadmillManager.config ~= nil and senaV4TreadmillManager.config.idleFarm == true
	end

	local tbl12 = {at = 0, value = false}

	local function fn63()
		local now = os.clock()
		if now - tbl12.at < 0.25 then
			return tbl12.value
		end
		tbl12.at = now
		local value = false

		local function fn64()
			local EggState2 = require(game:GetService("ReplicatedStorage").Client.EggState)
			local getAreaEggSnapshot = EggState2.GetAreaEggSnapshot and EggState2.GetAreaEggSnapshot()
			local v18 = if if getAreaEggSnapshot then not getAreaEggSnapshot.Records else not getAreaEggSnapshot then if EggState2.ReadFieldEggs then EggState2.ReadFieldEggs() else getAreaEggSnapshot else getAreaEggSnapshot

			for i, v19 in ipairs(v18 and v18.Records or {}) do
				if v19.State == "Carried" and v19.CarrierUserId == localPlayer2.UserId then
					value = true
					break
				end
			end
		end

		pcall(fn64)
		tbl12.value = value
		return value
	end

	index._dropMover = function(arg, arg2)
		if arg.flyMover then
			pcall(function()
				arg.flyMover:Destroy()
			end)

			arg.flyMover = nil
		end

		local senaFlyCaptureHover = arg2 and arg2:FindFirstChild("SenaFlyCaptureHover")

		if senaFlyCaptureHover then
			pcall(function()
				senaFlyCaptureHover:Destroy()
			end)
		end
	end

	index.setFlyForCapture = function(arg, arg2)
		arg.flyEnabled = arg2 == true

		if not arg.flyEnabled then
			if arg.flyConnection then
				pcall(function()
					arg.flyConnection:Disconnect()
				end)

				arg.flyConnection = nil
			end

			if arg.flyMover then
				pcall(function()
					arg.flyMover:Destroy()
				end)

				arg.flyMover = nil
			end

			local v18 = arg:_root()

			if v18 then
				local senaFlyCaptureHover = v18:FindFirstChild("SenaFlyCaptureHover")

				if senaFlyCaptureHover then
					pcall(function()
						senaFlyCaptureHover:Destroy()
					end)
				end

				if arg.flyAnchored then
					pcall(function()
						v18.Anchored = false
					end)
				end
			end

			arg.flyAnchored = false
			return
		end

		if arg.flyConnection then
			return
		end
		arg.flyAnchored = false

		arg.flyConnection = RunService2.PreSimulation:Connect(function()
			if not arg.flyEnabled then
				return
			end
			local v18 = arg:_root()
			if not v18 then
				return
			end
			local v19 = fn63()
			local running = (if v19 then fn62() else not v19) or next(tbl6) ~= nil or v13 and (v13.running or v13.activeTween)

			if running then
			else
				local senaV4PlayerSteal = genv.__SenaV4PlayerSteal
				running = if senaV4PlayerSteal then if senaV4PlayerSteal.running then true else running else running
			end

			if running then
				if arg.flyAnchored then
					pcall(function()
						v18.Anchored = false
					end)

					arg.flyAnchored = false
				end

				return
			end

			if v18.Position.Y < n8 - 1 then
				if arg.flyAnchored then
					pcall(function()
						v18.Anchored = false
					end)

					arg.flyAnchored = false
				end

				local n12 = v18.Position.Y + math.min(n8 - v18.Position.Y, 4)
				v18.CFrame = CFrame.new(v18.Position.X, n12, v18.Position.Z) * v18.CFrame.Rotation
				v18.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
				v18.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
			elseif v18.Anchored then
				arg.flyAnchored = true
			else
				pcall(function()
					v18.Anchored = true
				end)

				arg.flyAnchored = true
			end
		end)
	end

	index._isGrabPrompt = function(arg, arg2)
		return arg2:IsA("ProximityPrompt") and arg2.Name == str3
	end

	index._applyGrab = function(arg, arg2)
		if not arg:_isGrabPrompt(arg2) then
			return
		end

		if arg.grabOriginals[arg2] == nil then
			arg.grabOriginals[arg2] = arg2.HoldDuration
		end

		if arg2.HoldDuration > holdDuration then
			arg2.HoldDuration = holdDuration
		end
	end

	index._restoreGrab = function(arg)
		local n12 = workspace:GetAttribute("FastEggPickupTime") and 0.25 or 1.2

		for k, grabOriginal in pairs(arg.grabOriginals) do
			pcall(function()
				if k.Parent then
					k.HoldDuration = tonumber(grabOriginal) and grabOriginal > holdDuration and grabOriginal or n12
				end
			end)
		end

		arg.grabOriginals = setmetatable({}, {__mode = "k"})
	end

	index._fireGrab = function(arg, arg2)
		if arg:_isGrabPrompt(arg2) then
			if not arg2.Enabled then
				return
			end
		else
			return
		end

		local grabFiring, grabFiring2 = arg.grabFiring

		if grabFiring then
			grabFiring2 = grabFiring
		else
			grabFiring2 = setmetatable({}, {__mode = "k"})
		end

		arg.grabFiring = grabFiring2
		if arg.grabFiring[arg2] then
			return
		end
		local parent = arg2.Parent
		local v18 = arg:_root()

		if v18 then
			if parent then
				if not parent:IsA("BasePart") then
					return
				end
			else
				return
			end
		else
			return
		end

		local n12 = tonumber(arg2.MaxActivationDistance) or 10
		if (parent.Position - v18.Position).Magnitude > n12 + 1 then
			return
		end
		arg.grabFiring[arg2] = true

		task.spawn(function()
			pcall(function()
				local n13 = math.max(holdDuration, tonumber(arg2.HoldDuration) or holdDuration)
				arg2:InputHoldBegin()
				task.wait(n13 + 0.05)
				arg2:InputHoldEnd()
			end)

			task.wait(0.4)

			if arg.grabFiring then
				arg.grabFiring[arg2] = nil
			end
		end)
	end

	index.setInstantGrab = function(arg, arg2)
		arg.grabEnabled = arg2 == true

		if arg.grabEnabled then
			for i, descendant in ipairs(workspace:GetDescendants()) do
				arg:_applyGrab(descendant)
			end

			if not arg.grabConnection then
				arg.grabConnection = workspace.DescendantAdded:Connect(function(descendant)
					if arg.grabEnabled and arg:_isGrabPrompt(descendant) then
						task.defer(function()
							arg:_applyGrab(descendant)
						end)
					end
				end)
			end
		else
			if arg.grabConnection then
				pcall(function()
					arg.grabConnection:Disconnect()
				end)

				arg.grabConnection = nil
			end

			arg.grabFireLoop = nil
			arg:_restoreGrab()
		end
	end

	index.triggerJump = function(arg)
		if not arg.jumpEnabled then
			return
		end
		local now = os.clock()
		if now - arg.lastJumpAt < n10 then
			return
		end
		local v18 = arg:_humanoid()
		local v19 = arg:_root()

		if not v18 or not v19 then
			return
		elseif v18.Health <= 0 then
			return
		end

		arg.lastJumpAt = now

		pcall(function()
			v18:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
			v18:ChangeState(Enum.HumanoidStateType.Jumping)
			v18.Jump = true
		end)

		local jumpPower = n9

		if v18.UseJumpPower and v18.JumpPower > 0 then
			jumpPower = v18.JumpPower
		else
			if v18.JumpHeight and v18.JumpHeight > 0 then
				jumpPower = math.sqrt(2 * workspace.Gravity * v18.JumpHeight)
			end
		end

		local v20

		if jumpPower < n9 then
			v20 = n9
		else
			v20 = jumpPower
		end

		pcall(function()
			local assemblyLinearVelocity = v19.AssemblyLinearVelocity
			v19.AssemblyLinearVelocity = Vector3.new(assemblyLinearVelocity.X, v20, assemblyLinearVelocity.Z)
		end)
	end

	index.setInfiniteJump = function(arg, arg2)
		arg.jumpEnabled = arg2 == true
		if #arg.jumpConnections > 0 then
			return
		end

		pcall(function()
			table.insert(arg.jumpConnections, UserInputService.InputBegan:Connect(function(input)
				if not arg.jumpEnabled then
					return
				end

				if UserInputService:GetFocusedTextBox() then
					return
				end

				if input.KeyCode == Enum.KeyCode.Space then
					arg:triggerJump()
				elseif input.KeyCode == Enum.KeyCode.ButtonA then
					arg:triggerJump()
				end
			end))

			table.insert(arg.jumpConnections, UserInputService.JumpRequest:Connect(function()
				if not arg.jumpEnabled then
					return
				end

				if UserInputService:GetFocusedTextBox() then
					return
				end
				arg:triggerJump()
			end))
		end)

		task.spawn(function()
			while true do
				RunService2.Heartbeat:Wait()

				if arg.jumpEnabled and not UserInputService:GetFocusedTextBox() then
					local flag5 = false

					pcall(function()
						if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
							flag5 = true
						else
							if UserInputService:IsGamepadButtonDown(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonA) then
								flag5 = true
							end
						end
					end)

					if flag5 and os.clock() - arg.lastJumpAt >= n11 then
						arg:triggerJump()
					end
				end
			end
		end)
	end

	index._gameWalkSpeed = function(arg)
		local speedModules, speedModules2 = arg.speedModules

		if speedModules then
			speedModules2 = speedModules
		else
			speedModules2 = {}

			pcall(function()
				speedModules2.TreadmillUtil = require(ReplicatedStorage.Shared.Util.TreadmillUtil)
			end)

			pcall(function()
				speedModules2.Projection = require(ReplicatedStorage.Client.SpeedPowerProjection)
			end)

			pcall(function()
				speedModules2.Save = require(ReplicatedStorage.Shared.Save)
			end)

			arg.speedModules = speedModules2
		end

		if speedModules2.TreadmillUtil then
			if not speedModules2.TreadmillUtil.SpeedPowerToWalkSpeed then
				return nil
			end
		else
			return nil
		end

		local speedPower

		if speedModules2.Projection then
			pcall(function()
				speedPower = speedModules2.Projection.ReadProjected()
			end)
		end

		if type(speedPower) ~= "number" and speedModules2.Save then
			pcall(function()
				speedPower = (speedModules2.Save.Peek or speedModules2.Save.Get)().SpeedPower
			end)
		end

		if type(speedPower) ~= "number" then
			return nil
		end
		local ok, result = pcall(speedModules2.TreadmillUtil.SpeedPowerToWalkSpeed, speedPower)
		return ok and tonumber(result) or nil
	end

	index.setSpeedMultiplier = function(arg, arg2)
		arg.speedMultiplier = math.clamp(tonumber(arg2) or 1, 1, 2.1)
		arg:_applySpeedMultiplier()
		if arg.speedConnection then
			return
		end

		arg.speedConnection = RunService2.Heartbeat:Connect(function()
			if arg.speedMultiplier <= 1.001 then
				return
			end
			arg:_applySpeedMultiplier()
		end)
	end

	index._applySpeedMultiplier = function(arg)
		local senaV4TreadmillManager = genv.__SenaV4TreadmillManager
		if senaV4TreadmillManager and senaV4TreadmillManager.activeTreadmill ~= nil then
			return
		end
		local v18 = arg:_humanoid()
		if not v18 then
			return
		end
		local v19 = arg:_gameWalkSpeed()

		if v19 then
			if v19 <= 0 then
				return
			end
		else
			return
		end

		local walkSpeed = v19 * arg.speedMultiplier

		if math.abs(v18.WalkSpeed - walkSpeed) > 0.05 then
			pcall(function()
				v18.WalkSpeed = walkSpeed
			end)
		end
	end

	index.destroy = function(arg)
		arg:setFlyForCapture(false)
		arg:setInstantGrab(false)
		arg.jumpEnabled = false

		for i, jumpConnection in ipairs(arg.jumpConnections) do
			pcall(function()
				jumpConnection:Disconnect()
			end)
		end

		arg.jumpConnections = {}

		if arg.speedConnection then
			pcall(function()
				arg.speedConnection:Disconnect()
			end)

			arg.speedConnection = nil
		end
	end

	return index
end)().new()

genv.__SenaV4MovementExtras = v18

if senaV4Config.FlyForCapture then
	v18:setFlyForCapture(true)
end

if senaV4Config.InstantGrab then
	v18:setInstantGrab(true)
end

if senaV4Config.InfiniteJump then
	v18:setInfiniteJump(true)
end

walkSpeedMultiplier = senaV4Config.WalkSpeedMultiplier

if walkSpeedMultiplier and walkSpeedMultiplier > 1 then
	v18:setSpeedMultiplier(senaV4Config.WalkSpeedMultiplier)
end

v10 = (function()
	local Players2 = game:GetService("Players")
	local RunService2 = game:GetService("RunService")
	local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
	local localPlayer2 = Players2.LocalPlayer
	local cframe = CFrame.new(542.93, 71.5, -405.58)
	local n8 = 0.9
	local n9 = 1.6
	local n10 = 0.2
	local index = {}
	index.__index = index

	index.new = function()
		local obj = setmetatable({}, index)
		obj.enabled = false
		obj.running = false
		obj.destroyed = false
		obj.connection = nil
		obj.wasHolding = false
		obj.lastResult = "Idle"
		return obj
	end

	index._character = function(arg)
		return localPlayer2.Character
	end

	index._root = function(arg)
		local v19 = arg:_character()
		return v19 and v19:FindFirstChild("HumanoidRootPart")
	end

	index._carriedUid = function(arg)
		local uid

		local function fn62()
			local EggState2 = require(ReplicatedStorage2.Client.EggState)
			local v19 = if EggState2.GetAreaEggSnapshot then EggState2.GetAreaEggSnapshot() else nil
			local v20 = if if v19 then not v19.Records else not v19 then if EggState2.ReadFieldEggs then EggState2.ReadFieldEggs() else v19 else v19

			if v20 then
				if not v20.Records then
					return
				end
			else
				return
			end

			local userId = localPlayer2.UserId

			for i, record in ipairs(v20.Records) do
				if record.State == "Carried" and record.CarrierUserId == userId then
					uid = record.Uid
					return
				end
			end
		end

		pcall(fn62)
		return uid
	end

	index._record = function(arg, arg2)
		local readFieldEgg

		pcall(function()
			local EggState2 = require(ReplicatedStorage2.Client.EggState)
			readFieldEgg = EggState2.ReadFieldEgg and EggState2.ReadFieldEgg(arg2)
		end)

		return readFieldEgg
	end

	index._guardFor = function(arg, arg2)
		local guard

		pcall(function()
			local v19 = arg:_record(arg2)
			local v20 = fn()
			local areas = v20 and v20:FindFirstChild("Areas")
			local guardAreas = areas and areas:FindFirstChild("GuardAreas")
			local areaId = guardAreas and v19 and v19.AreaId and guardAreas:FindFirstChild(v19.AreaId)
			guard = areaId and areaId:FindFirstChild("Guard")
		end)

		return guard
	end

	index._skips = function(arg, arg2)
		local senaV4EggRuntime = genv.__SenaV4EggRuntime

		if senaV4EggRuntime then
			if senaV4EggRuntime.instantPhase == "priming" then
				return true
			end

			if senaV4EggRuntime.enabled then
				return true
			elseif senaV4EggRuntime.running then
				return true
			end
		end

		local senaV4PlayerSteal = genv.__SenaV4PlayerSteal
		if senaV4PlayerSteal and senaV4PlayerSteal.running then
			return true
		end

		if not arg2 then
			return false
		end
		local v19 = arg:_record(arg2)
		return v19 ~= nil and tostring(v19.AreaId) == "Forest"
	end

	index._freeze = function(arg, arg2)
		local v19 = arg:_character()
		local humanoid = v19 and v19:FindFirstChildOfClass("Humanoid")
		local currentCamera = workspace.CurrentCamera
		local cFrame = currentCamera and currentCamera.CFrame
		local cameraType, clone = currentCamera and currentCamera.CameraType

		local function fn62()
			v19.Archivable = true
			clone = v19:Clone()

			if arg2 then
				pcall(function()
					clone:PivotTo(arg2)
				end)
			end

			clone.Name = "SenaAntiHitGhost"

			for i, descendant in ipairs(clone:GetDescendants()) do
				if descendant:IsA("LuaSourceContainer") then
					descendant:Destroy()
				elseif descendant:IsA("Sound") then
					descendant:Destroy()
				elseif descendant:IsA("BasePart") then
					descendant.CanCollide = false
					descendant.Anchored = true
				end
			end

			clone.Parent = workspace

			for i, descendant in ipairs(v19:GetDescendants()) do
				if descendant:IsA("BasePart") and descendant.Name ~= "HumanoidRootPart" then
					descendant.LocalTransparencyModifier = 1
				end

				if descendant:IsA("Trail") then
					descendant.Enabled = false
				end
			end

			if currentCamera then
				currentCamera.CameraType = Enum.CameraType.Scriptable
				currentCamera.CFrame = cFrame
			end
		end

		pcall(fn62)
		local tbl12 = {}

		pcall(function()
			for i, descendant in ipairs(v19:GetDescendants()) do
				if descendant:IsA("BasePart") and descendant.Name ~= "HumanoidRootPart" then
					tbl12[#tbl12 + 1] = descendant
				end
			end
		end)

		local function fn63(arg3)
			local function fn64()
				if clone then
					clone:Destroy()
				end

				for i, descendant in ipairs(v19:GetDescendants()) do
					if descendant:IsA("BasePart") then
						descendant.LocalTransparencyModifier = 0
					end

					if descendant:IsA("Trail") then
						descendant.Enabled = true
					end
				end

				if currentCamera then
					currentCamera.CameraType = cameraType ~= Enum.CameraType.Scriptable and cameraType or Enum.CameraType.Custom

					if humanoid then
						currentCamera.CameraSubject = humanoid
					end

					if arg3 then
						currentCamera.CFrame = cFrame
					end
				end
			end

			pcall(fn64)
		end

		return fn63, function()
			if currentCamera then
				currentCamera.CameraType = Enum.CameraType.Scriptable
				currentCamera.CFrame = cFrame
			end

			for i, v20 in ipairs(tbl12) do
				if v20.Parent then
					v20.LocalTransparencyModifier = 1
				end
			end
		end
	end

	index.shield = function(arg, arg2)
		if arg.enabled then
			if arg.running then
				return false
			end
		else
			return false
		end

		if arg:_skips(arg2) then
			return false
		end
		local v19 = arg:_root()
		if not v19 then
			return false
		end
		arg.running = true
		local cFrame = v19.CFrame
		local v20 = arg:_guardFor(arg2)

		local function fn62()
			local v21 = arg:_root()
			if not v21 then
				return false
			end
			v21.CFrame = cframe
			v21.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
			v21.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
			return true
		end

		fn62()
		local v21, v22 = arg:_freeze(cFrame)
		local n11 = 1
		local flag5 = false

		pcall(function()
			local now = os.clock()
			local flag6 = false

			while os.clock() - now < n8 or flag6 and os.clock() - now < n9 and v20 and (v20:GetAttribute("GuardState") == "Waking" or v20:GetAttribute("GuardState") == "Chasing") do
				if not fn62() then
					break
				end
				v22()
				n11 += 1
				local attribute = v20 and v20:GetAttribute("GuardState")

				if attribute == "Waking" then
					flag6 = true
				else
					if attribute == "Chasing" then
						flag6 = true
					else
						if flag6 and (attribute == "Sleeping" and os.clock() - now > n10) then
							flag5 = true
							break
						end
					end
				end

				RunService2.Heartbeat:Wait()
			end
		end)

		v21(true)
		arg.lastResult = (flag5 and "Guard slept" or "Held") .. " (" .. n11 .. " writes)"
		arg.running = false
		return true
	end

	index._check = function(arg, arg2)
		if not arg.enabled then
			arg.wasHolding = false
			return
		end
		local v19, uid

		if type(arg2) == "table" and arg2.IsCarrying and arg2.Uid then
			uid = arg2.Uid
		else
			uid = arg:_carriedUid()
		end

		local wasHolding = uid ~= nil

		if wasHolding and (not arg.wasHolding and (not arg.running and not arg:_skips(uid))) then
			task.spawn(function()
				pcall(function()
					arg:shield(uid)
				end)
			end)
		end

		arg.wasHolding = wasHolding
	end

	index.setEnabled = function(arg, arg2)
		arg.enabled = arg2 == true

		if arg.enabled then
			arg.wasHolding = arg:_carriedUid() ~= nil
		end

		if not arg.watcher then
			arg.watcher = true

			task.spawn(function()
				while not arg.destroyed do
					if arg.enabled then
						if arg.running then
							task.wait(0.5)
						else
							pcall(function()
								arg:_check()
							end)

							task.wait(0.15)
						end
					else
						task.wait(0.5)
					end
				end
			end)
		end

		if arg.connection then
			return
		end

		pcall(function()
			local EggState2 = require(ReplicatedStorage2.Client.EggState)

			if EggState2 and EggState2.CarryChanged then
				arg.connection = EggState2.CarryChanged:Connect(function(arg3)
					task.defer(function()
						arg:_check(arg3)
					end)
				end)
			end
		end)
	end

	index.destroy = function(arg)
		arg.destroyed = true
		arg.enabled = false

		if arg.connection then
			pcall(function()
				arg.connection:Disconnect()
			end)

			arg.connection = nil
		end
	end

	return index
end)().new()

genv.__SenaV4AntiHitGuard = v10

if senaV4Config.AntiHitGuard then
	v10:setEnabled(true)
end

genv.__SenaV4PlayerSteal = v17

do
	local tbl12 = {at = 0, value = false}

	genv.__SenaV4StealWantsCharacter = function()
		local senaV4PlayerSteal = genv.__SenaV4PlayerSteal

		if senaV4PlayerSteal then
			if senaV4PlayerSteal.running then
				return true
			elseif senaV4PlayerSteal.wantsTarget then
				return true
			end
		end

		local senaV4EggRuntime = genv.__SenaV4EggRuntime

		if senaV4EggRuntime and senaV4EggRuntime.enabled then
			if senaV4EggRuntime.destroyed then
				return false
			end
		else
			return false
		end

		local flag5 = senaV4EggRuntime.activeTween and not senaV4EggRuntime.activeTween.sharedTravel

		if senaV4EggRuntime.running then
			return true
		elseif flag5 then
			return true
		elseif senaV4EggRuntime.carry then
			if senaV4EggRuntime.carry.active then
				return true
			end
		end

		if type(senaV4EggRuntime._eggInventoryFull) == "function" and senaV4EggRuntime:_eggInventoryFull() then
			return false
		end
		local now = os.clock()
		if now - tbl12.at < 0.5 then
			return tbl12.value
		end
		tbl12.at = now

		local ok, result = pcall(function()
			return senaV4EggRuntime:_wallOpen() and senaV4EggRuntime:_chooseTarget() or nil
		end)

		tbl12.value = ok and result ~= nil
		return tbl12.value
	end

	register = senaV4TaskLadder.register
	tbl = {}
	tbl.wants = genv.__SenaV4StealWantsCharacter

	tbl.active = function()
		local senaV4PlayerSteal = genv.__SenaV4PlayerSteal
		if senaV4PlayerSteal and senaV4PlayerSteal.running then
			return true
		end
		local senaV4EggRuntime = genv.__SenaV4EggRuntime

		if senaV4EggRuntime then
			if senaV4EggRuntime.destroyed then
				return false
			end
		else
			return false
		end

		local flag5 = senaV4EggRuntime.activeTween and not senaV4EggRuntime.activeTween.sharedTravel
		return senaV4EggRuntime.running == true or flag5 == true or senaV4EggRuntime.carry ~= nil and senaV4EggRuntime.carry.active == true
	end

	tbl.enabled = function()
		local senaV4PlayerSteal = genv.__SenaV4PlayerSteal
		local senaV4EggRuntime = genv.__SenaV4EggRuntime
		return senaV4EggRuntime ~= nil and senaV4EggRuntime.enabled == true or senaV4PlayerSteal ~= nil and senaV4PlayerSteal.enabled == true
	end

	tbl.status = function()
		local senaV4PlayerSteal = genv.__SenaV4PlayerSteal
		if senaV4PlayerSteal and senaV4PlayerSteal.running then
			return tostring(senaV4PlayerSteal.status or "Stealing from a player")
		end
		local senaV4EggRuntime = genv.__SenaV4EggRuntime
		return senaV4EggRuntime and senaV4EggRuntime.stats and tostring(senaV4EggRuntime.stats.status or "") or ""
	end

	register("auto_steal", tbl)
end

v13:setStealMode(senaV4Config.StealMode == "Semi Teleport" and "Instant" or senaV4Config.StealMode)
v13:setSpeed(senaV4Config.TweenSpeedMultiplier or 60)

if senaV4Config.StealMinValue and senaV4Config.StealMinValue > 0 then
	v13:setMinValuePerSec(senaV4Config.StealMinValue)
end

if senaV4Config.StealAreas and not table.find(senaV4Config.StealAreas, "None") and #senaV4Config.StealAreas > 0 then
	local tbl12 = {}

	for i, stealArea in ipairs(senaV4Config.StealAreas) do
		if stealArea ~= "None" then
			table.insert(tbl12, stealArea)
		end
	end

	v13:setFilter("areas", tbl12)
	v13:setFilterEnabled("area", #tbl12 > 0)
end

if senaV4Config.StealRarities and not table.find(senaV4Config.StealRarities, "None") and #senaV4Config.StealRarities > 0 then
	local tbl12 = {}

	for i, stealRarity in ipairs(senaV4Config.StealRarities) do
		if stealRarity ~= "None" then
			table.insert(tbl12, stealRarity)
		end
	end

	v13:setFilter("rarities", tbl12)
	v13:setFilterEnabled("rarity", #tbl12 > 0)
end

if senaV4Config.StealNamesFilter and not table.find(senaV4Config.StealNamesFilter, "None") and #senaV4Config.StealNamesFilter > 0 then
	local tbl12 = {}

	for i, v19 in ipairs(senaV4Config.StealNamesFilter) do
		if v19 ~= "None" then
			table.insert(tbl12, v19)
		end
	end

	v13:setFilter("names", tbl12)
	v13:setFilterEnabled("name", #tbl12 > 0)
end

genv.__SenaV4EggRuntimeCleanup = function()
	if v13 then
		pcall(v13.destroy, v13)
	end

	if v14 then
		pcall(v14.destroy, v14)
	end

	if genv.__SenaV4EggRuntime == v13 then
		genv.__SenaV4EggRuntime = nil
	end

	if genv.__SenaV4TreadmillManager == v14 then
		genv.__SenaV4TreadmillManager = nil
	end
end

genv.__SenaV4AntiGuardCleanup = function()
	if v15 then
		pcall(v15.destroy, v15)
	end

	if v16 then
		pcall(v16.destroy, v16)
	end

	if genv.__SenaV4AntiGuard == v15 then
		genv.__SenaV4AntiGuard = nil
	end

	if genv.__SenaV4GodMode == v16 then
		genv.__SenaV4GodMode = nil
	end
end

do
	local str3 = "__FyyStealAnEggStartupProtectionLiteV2"
	local n8 = 60
	local senaV4StartupProtection = {}

	local function fn62()
		return getgenv and getgenv() or _G
	end

	local function fn63()
		if type(getconnections) == "function" then
			return getconnections
		end

		if type(get_signal_cons) == "function" then
			return get_signal_cons
		end
		return nil
	end

	local function fn64(arg)
		local localPlayer2 = Players.LocalPlayer
		if not localPlayer2 then
			arg.antiAfkStatus = "LocalPlayer unavailable"
			return false
		end
		local lastDisabledIdleConnections = fn63()
		if not lastDisabledIdleConnections then
			arg.antiAfkStatus = "Native Idled connection API unavailable"
			return false
		end
		local ok, result = pcall(lastDisabledIdleConnections, localPlayer2.Idled)

		if ok then
			if type(result) ~= "table" then
				arg.antiAfkStatus = "Idled scan unavailable"
				return false
			end
		else
			arg.antiAfkStatus = "Idled scan unavailable"
			return false
		end

		lastDisabledIdleConnections = 0

		for i, v19 in ipairs(result) do
			lastDisabledIdleConnections = if type(v19) == "table" or type(v19) == "userdata" then if type(v19.Disable) == "function" then if pcall(v19.Disable, v19) then lastDisabledIdleConnections + 1 else lastDisabledIdleConnections else if type(v19.Disconnect) == "function" then if pcall(v19.Disconnect, v19) then lastDisabledIdleConnections + 1 else lastDisabledIdleConnections else lastDisabledIdleConnections else lastDisabledIdleConnections
		end

		arg.scanRuns = arg.scanRuns + 1
		arg.lastScanAt = os.clock()
		arg.lastDisabledIdleConnections = lastDisabledIdleConnections
		arg.disabledIdleConnections = arg.disabledIdleConnections + lastDisabledIdleConnections
		arg.antiAfkStatus = lastDisabledIdleConnections > 0 and "Anti-AFK disabled " .. tostring(lastDisabledIdleConnections) .. " Idled connection(s)" or "Anti-AFK active; Idled connections clear"
		return true
	end

	senaV4StartupProtection.install = function()
		local v19 = fn62()
		local value = rawget(v19, str3)

		if type(value) == "table" and value.installed then
			value.installRuns = value.installRuns + 1
			fn64(value)
			value.status = value.antiAfkStatus
			return value
		end

		local tbl12 = {installRuns = 1, scanRuns = 0, disabledIdleConnections = 0, lastDisabledIdleConnections = 0, lastScanAt = 0, installed = false, mode = "native-idled-disabler", integrityPatcherInstalled = false, networkFilterInstalled = false, namecallHookInstalled = false}
		v19[str3] = tbl12
		local localPlayer2 = Players.LocalPlayer

		if not localPlayer2 then
			tbl12.antiAfkInstalled = false
			tbl12.antiAfkStatus = "LocalPlayer unavailable"
			tbl12.status = tbl12.antiAfkStatus
			tbl12.installed = true
			return tbl12
		end

		tbl12.antiAfkInstalled = fn64(tbl12)

		tbl12.idledConnection = localPlayer2.Idled:Connect(function()
			fn64(tbl12)
		end)

		tbl12.characterConnection = localPlayer2.CharacterAdded:Connect(function()
			task.delay(1, function()
				if tbl12.installed then
					fn64(tbl12)
				end
			end)
		end)

		tbl12.installed = true
		tbl12.status = tbl12.antiAfkStatus

		task.spawn(function()
			while tbl12.installed and v19[str3] == tbl12 do
				task.wait(n8)

				if tbl12.installed and v19[str3] == tbl12 then
					fn64(tbl12)
					tbl12.status = tbl12.antiAfkStatus
				end
			end
		end)

		return tbl12
	end

	senaV4StartupProtection.uninstall = function()
		local value = rawget(fn62(), str3)

		if type(value) == "table" then
			value.installed = false

			if value.idledConnection and typeof(value.idledConnection.Disconnect) == "function" then
				pcall(value.idledConnection.Disconnect, value.idledConnection)
				value.idledConnection = nil
			end

			if value.characterConnection and typeof(value.characterConnection.Disconnect) == "function" then
				pcall(value.characterConnection.Disconnect, value.characterConnection)
				value.characterConnection = nil
			end
		end
	end;

	(function()
		local genv2 = getgenv and getgenv() or _G
		genv2.__SenaV4AntiAfkGeneration = (genv2.__SenaV4AntiAfkGeneration or 0) + 1
		genv2.__SenaV4AntiAfkEnabled = senaV4Config.AntiAFK
		genv2.__SenaV4StartupProtection = senaV4StartupProtection

		genv2.__SenaV4SetAntiAfkEnabled = function(arg)
			genv2.__SenaV4AntiAfkEnabled = arg == true

			if arg then
				senaV4StartupProtection.install()
			else
				senaV4StartupProtection.uninstall()
			end
		end

		if senaV4Config.AntiAFK then
			genv2.__SenaV4SetAntiAfkEnabled(true)
		end
	end)()
end

local v19 = senaV4Config
local tbl12 = {}
tbl12.TeleportService = TeleportService or game:GetService("TeleportService")
tbl12.LP = localPlayer or Players.LocalPlayer
tbl12.Players = Players
local v20 = tbl12

local function fn62()
	local str3 = "if game:GetAttribute(\"SenaBootQueued\") then return end\ngame:SetAttribute(\"SenaBootQueued\", true)\nrepeat task.wait(0.5) until game:IsLoaded()\ntask.wait(1.5)\nif getgenv then getgenv().SNE_AutoExecute = true end\nloadstring(game:HttpGet(\"https://senahub.xyz/raw/senav6\"))()\n"

	pcall(function()
		if writefile then
			pcall(function()
				writefile("autoexec/Sena_StealAnEgg.lua", str3)
			end)

			pcall(function()
				writefile("autoexecute/Sena_StealAnEgg.lua", str3)
			end)
		end
	end)

	local queueOnTeleport = queue_on_teleport or syn and syn.queue_on_teleport or fluxus and fluxus.queue_on_teleport

	if queueOnTeleport then
		pcall(function()
			queueOnTeleport(str3)
		end)
	end
end

local function fn63()
	pcall(function()
		if delfile then
			pcall(function()
				delfile("autoexec/Sena_StealAnEgg.lua")
			end)

			pcall(function()
				delfile("autoexecute/Sena_StealAnEgg.lua")
			end)
		elseif writefile then
			pcall(function()
				writefile("autoexec/Sena_StealAnEgg.lua", "")
			end)

			pcall(function()
				writefile("autoexecute/Sena_StealAnEgg.lua", "")
			end)
		end
	end)
end

local flag5 = false

local function fn64()
	if flag5 then
		return
	end
	flag5 = true

	if v19.autoExecute then
		pcall(fn62)
	elseif getgenv then
		if getgenv().SNE_AutoExecute then
			pcall(fn62)
		end
	end

	task.wait(3)
	local teleportService = v20.TeleportService or game:GetService("TeleportService")
	local placeId = game.PlaceId
	local jobId = game.JobId

	while true do
		pcall(function()
			if jobId and #jobId > 0 then
				teleportService:TeleportToPlaceInstance(placeId, jobId, v20.LP)
			else
				teleportService:Teleport(placeId, v20.LP)
			end
		end)

		task.wait(6)
	end
end

pcall(function()
	local function fn65(arg)
		if v19.autoReconnect and (arg and #arg > 0) then
			fn64()
		end
	end

	game:GetService("GuiService").ErrorMessageChanged:Connect(fn65)
end)

pcall(function()
	local lp = v20.LP or localPlayer or Players.LocalPlayer

	if lp and lp.OnTeleport then
		local function fn65()
			if v19.autoExecute then
				pcall(fn62)
			elseif getgenv then
				if getgenv().SNE_AutoExecute then
					pcall(fn62)
				end
			end
		end

		lp.OnTeleport:Connect(fn65)
	end
end)

task.spawn(function()
	while true do
		task.wait(2)

		if v19.autoReconnect then
			pcall(function()
				local robloxPromptGui = game:GetService("CoreGui"):FindFirstChild("RobloxPromptGui")
				local promptOverlay = robloxPromptGui and robloxPromptGui:FindFirstChild("promptOverlay")
				local errorPrompt = promptOverlay and promptOverlay:FindFirstChild("ErrorPrompt")

				if errorPrompt and errorPrompt.Visible then
					fn64()
				end
			end)
		end
	end
end)

genv.__SenaV4PetBarn = (function()
	local Remotes = require(ReplicatedStorage.Shared.Remotes)

	local tbl13 = {equipBest = function()
		pcall(function()
			Remotes.Haul.WearBest:InvokeServer()
		end)
	end, claimOffline = function()
		local ok, result = pcall(function()
			return Remotes.AwayEarnings.FetchSummary:InvokeServer()
		end)

		if ok and type(result) == "table" then
			local claimableAmount = result.ClaimableAmount

			if claimableAmount and claimableAmount > 0 then
				pcall(function()
					Remotes.AwayEarnings.AskCollect:InvokeServer({Kind = "Claim"})
				end)
			end
		end
	end, favoriteSelected = function()
		local v21 = (require(ReplicatedStorage.Shared.Save).Peek or require(ReplicatedStorage.Shared.Save).Get)()

		if v21 then
			if type(v21.Inventory) ~= "table" then
				return 0
			end
		else
			return 0
		end

		local AssetItems = require(ReplicatedStorage.Shared.Util.AssetItems)
		local directory = require(ReplicatedStorage.Data.Assets).Directory
		local v22 = pairs
		local inventory = v21.Inventory
		local n8 = 0

		for k, v23 in v22(inventory) do
			local v24

			if AssetItems and type(AssetItems.Decode) == "function" then
				pcall(function()
					v24 = AssetItems.Decode(v23)
				end)
			end

			v24 = v24 or v23

			if type(v24) == "table" then
				if v24.IsFavorite then
				else
					if v24.Category then
						local v25 = directory[v24.Category]
						local displayName = v25 and v25.Rarity and (v25.Rarity.DisplayName or v25.Rarity._id)
						local flag6 = false

						if senaV4Config.FavMode == "Species" then
							local favSpecies = senaV4Config.FavSpecies or {}
							flag6 = if table.find(favSpecies, "All") then true else if table.find(favSpecies, v24.Category) then true else if v25 then if table.find(favSpecies, v25.DisplayName) then true else flag6 else flag6
						else
							local favRarities = senaV4Config.FavRarities or {}
							flag6 = if table.find(favRarities, "All") then true else if displayName then if table.find(favRarities, displayName) then true else flag6 else flag6
						end

						if flag6 then
							pcall(function()
								Remotes.PetSatchel.WriteFavourite:FireServer(k, true)
							end)

							local n9 = n8 + 1

							if n9 % 10 == 0 then
								task.wait(0.05)
							end

							n8 = n9
						end
					end
				end
			end
		end

		return n8
	end, unfavoriteAll = function()
		local v21 = (require(ReplicatedStorage.Shared.Save).Peek or require(ReplicatedStorage.Shared.Save).Get)()

		if v21 then
			if type(v21.Inventory) ~= "table" then
				return 0
			end
		else
			return 0
		end

		local n8 = 0

		for k, v22 in pairs(v21.Inventory) do
			if type(v22) == "table" and v22.IsFavorite then
				pcall(function()
					Remotes.PetSatchel.WriteFavourite:FireServer(k, false)
				end)

				local n9 = n8 + 1

				if n9 % 10 == 0 then
					task.wait(0.05)
				end

				n8 = n9
			end
		end

		return n8
	end}

	local function fn65(arg, arg2, arg3)
		local v21 = (require(ReplicatedStorage.Shared.Save).Peek or require(ReplicatedStorage.Shared.Save).Get)()

		if v21 then
			if type(v21.Inventory) ~= "table" then
				return nil
			end
		else
			return nil
		end

		local AssetItems = require(ReplicatedStorage.Shared.Util.AssetItems)
		local directory = require(ReplicatedStorage.Data.Assets).Directory
		local tbl14 = {}

		for i, v22 in ipairs(v21.EquippedAssets or {}) do
			tbl14[v22] = true
		end

		local tbl15 = {}

		for k, v22 in pairs(v21.Inventory) do
			if not tbl14[k] then
				local v23

				if AssetItems and type(AssetItems.Decode) == "function" then
					pcall(function()
						v23 = AssetItems.Decode(v22)
					end)
				end

				v23 = v23 or v22

				if type(v23) == "table" and (not v23.InFuse and (not v23.IsFavorite and v23.Category)) then
					local v24 = directory[v23.Category]
					local displayName = v24 and v24.Rarity and (v24.Rarity.DisplayName or v24.Rarity._id)
					local v25 = if arg3 then if #arg3 > 0 then if table.find(arg3, "All") then true else displayName and table.find(arg3, displayName) ~= nil else true else true
					local v26 = if arg then if arg2 then if #arg2 > 0 then if table.find(arg2, "All") then true else table.find(arg2, v23.Category) ~= nil or v24 and table.find(arg2, v24.DisplayName) ~= nil else true else true else true

					if v25 and v26 then
						tbl15[v23.Category] = tbl15[v23.Category] or {}
						table.insert(tbl15[v23.Category], {uid = k, d = v23})
					end
				end
			end
		end

		for k, v22 in pairs(tbl15) do
			if #v22 >= 3 then
				return {v22[1].uid, v22[2].uid, v22[3].uid}
			end
		end

		return nil
	end

	tbl13.fuseOnePair = function()
		local v21 = (require(ReplicatedStorage.Shared.Save).Peek or require(ReplicatedStorage.Shared.Save).Get)()
		if not v21 then
			return false
		end

		if v21.FusionLocked then
			return false, "Fusion locked"
		end
		local v22 = fn65(senaV4Config.FuseSelectedOnly, senaV4Config.FuseSpecies, senaV4Config.FuseRarities)
		if not v22 then
			return false, "No eligible group of 3"
		end

		pcall(function()
			Remotes.Fusery.ConfirmBriefing:InvokeServer()
		end)

		for i, v23 in ipairs(v22) do
			local ok, result = pcall(function()
				return Remotes.Fusery.LoadPet:InvokeServer(v23)
			end)

			if ok then
				if not result then
					return false, "Failed to load pet"
				end
			else
				return false, "Failed to load pet"
			end

			task.wait(0.02)
		end

		local ok, result = pcall(function()
			return Remotes.Fusery.BeginFuse:InvokeServer()
		end)

		if ok then
			if not result then
				return false, "Failed to begin fuse"
			end
		else
			return false, "Failed to begin fuse"
		end

		task.wait(0.06)

		pcall(function()
			Remotes.Fusery.FinishReveal:InvokeServer()
		end)

		return true
	end

	task.spawn(function()
		local n8 = 0

		while fn2() do
			local now = os.clock()

			if senaV4Config.AutoEquipBest and now - n8 > 6 then
				pcall(tbl13.equipBest)
				n8 = now
			end

			if senaV4Config.AutoClaimOffline then
				pcall(tbl13.claimOffline)
			end

			if senaV4Config.AutoFavorite then
				pcall(tbl13.favoriteSelected)
			end

			if senaV4Config.AutoFusePets then
				pcall(tbl13.fuseOnePair)
			end

			task.wait(2.5)
		end
	end)

	return tbl13
end)()

genv.__SenaV4Upgrades = (function()
	local Remotes = require(ReplicatedStorage.Shared.Remotes)

	local tbl13 = {upgradeBase = function()
		local result = (require(ReplicatedStorage.Shared.Save).Peek or require(ReplicatedStorage.Shared.Save).Get)()
		if not result then
			return false
		end
		local n8 = tonumber(result.BaseUpgradeLevel or 0) or 0
		local Bases = require(ReplicatedStorage.Data.Bases)
		local bases = Bases and Bases.BASES and Bases.BASES[n8 + 1]
		if not bases then
			return false, "Max level"
		end

		if (tonumber(result.Money or 0) or 0) < (bases.Cost or 0) then
			return false, "Not enough money"
		end

		n8, result = pcall(function()
			return Remotes.Homestead.AskBaseTierRaise:InvokeServer()
		end)

		return n8 and result == true, result
	end, claimAlmanac = function()
		local ok, result = pcall(function()
			return Remotes.Codex.AskRedeemAll:InvokeServer()
		end)

		return ok, result
	end}

	task.spawn(function()
		while fn2() do
			if senaV4Config.AutoBaseUpgrade then
				pcall(tbl13.upgradeBase)
			end

			if senaV4Config.AutoClaimAlmanac then
				pcall(tbl13.claimAlmanac)
			end

			task.wait(3)
		end
	end)

	return tbl13
end)()

genv.__SenaV4Roaming = (function()
	local tbl13

	tbl13 = {noclipConn = nil, setNoclip = function(arg)
		senaV4Config.Noclip = arg == true

		if tbl13.noclipConn then
			pcall(function()
				tbl13.noclipConn:Disconnect()
			end)

			tbl13.noclipConn = nil
		end

		if not senaV4Config.Noclip then
			local character = localPlayer.Character

			if character then
				for i, descendant in ipairs(character:GetDescendants()) do
					if descendant:IsA("BasePart") and descendant:GetAttribute("SenaNoclip") then
						descendant.CanCollide = true
						descendant:SetAttribute("SenaNoclip", nil)
					end
				end
			end

			return
		end

		tbl13.noclipConn = RunService.Stepped:Connect(function()
			if not senaV4Config.Noclip then
				return
			end
			local character = localPlayer.Character
			if not character then
				return
			end

			for i, descendant in ipairs(character:GetDescendants()) do
				if descendant:IsA("BasePart") and descendant.CanCollide then
					descendant:SetAttribute("SenaNoclip", true)
					descendant.CanCollide = false
				end
			end
		end)
	end, waypointList = function()
		local tbl14 = {"Respawn Point"}
		local v21 = fn()
		local machines = v21 and v21:FindFirstChild("Machines")

		if machines and machines:FindFirstChild("FuseMachine") then
			table.insert(tbl14, "Fuse Machine")
		end

		local areas = v21 and v21:FindFirstChild("Areas")
		local guardAreas = areas and areas:FindFirstChild("GuardAreas")

		if guardAreas then
			for i, child in ipairs(guardAreas:GetChildren()) do
				table.insert(tbl14, child.Name)
			end
		end

		return tbl14
	end, teleportWaypoint = function(arg)
		local character = localPlayer.Character
		local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
		if not humanoidRootPart then
			return false
		end
		local position
		local v21 = fn()

		if arg == "Respawn Point" then
			pcall(function()
				local PlotState2 = require(ReplicatedStorage.Client.PlotState)
				local resolvePlot = PlotState2.ResolvePlot and PlotState2.ResolvePlot()

				if resolvePlot and resolvePlot.RespawnPointCFrame then
					position = resolvePlot.RespawnPointCFrame.Position
				elseif resolvePlot then
					if resolvePlot.Model and resolvePlot.Model:FindFirstChild("Spawn") then
						position = resolvePlot.Model.Spawn.Position
					end
				end
			end)
		else
			local flag6, position2 = arg == "Fuse Machine"

			if flag6 then
				character = v21 and v21:FindFirstChild("Machines")
				local fuseMachine = character and character:FindFirstChild("FuseMachine")
				local machine = fuseMachine and (fuseMachine:FindFirstChild("Machine") or fuseMachine.PrimaryPart)

				if machine then
					position2 = machine.Position
				else
					position2 = position
				end
			else
				local areas = v21 and v21:FindFirstChild("Areas")
				local guardAreas = areas and areas:FindFirstChild("GuardAreas")
				areas = guardAreas and guardAreas:FindFirstChild(arg)
				local guard = areas and areas:FindFirstChild("Guard")

				if guard then
					if guard:IsA("BasePart") then
						position2 = guard.Position
					else
						position2 = position
					end
				else
					position2 = position
				end
			end

			position = position2
		end

		if not position then
			return false
		end
		humanoidRootPart.CFrame = CFrame.new(position + Vector3.new(0, 4, 0))
		humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
		return true
	end, setBottingMode = function(arg)
		senaV4Config.BottingMode = arg == true
		local senaV4BottingOverlay = genv.__SenaV4BottingOverlay

		if senaV4BottingOverlay and senaV4BottingOverlay.Parent then
			pcall(function()
				senaV4BottingOverlay:Destroy()
			end)
		end

		genv.__SenaV4BottingOverlay = nil

		if not senaV4Config.BottingMode then
			pcall(function()
				RunService:Set3dRenderingEnabled(true)
			end)

			return
		end

		pcall(function()
			RunService:Set3dRenderingEnabled(false)
		end)

		local CoreGui

		pcall(function()
			CoreGui = game:GetService("CoreGui")
		end)

		CoreGui = CoreGui or localPlayer:FindFirstChildOfClass("PlayerGui")
		if not CoreGui then
			return
		end
		local screenGui = Instance.new("ScreenGui")
		screenGui.Name = "SenaBottingOverlay"
		screenGui.ResetOnSpawn = false
		screenGui.IgnoreGuiInset = true
		screenGui.DisplayOrder = -1
		screenGui.Parent = CoreGui
		local frame = Instance.new("Frame")
		frame.Name = "Blackscreen"
		frame.Size = UDim2.new(1, 0, 1, 0)
		frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		frame.BorderSizePixel = 0
		frame.Active = false
		frame.Parent = screenGui
		genv.__SenaV4BottingOverlay = screenGui
	end}

	task.spawn(function()
		while fn2() do
			if senaV4Config.AntiCutscene then
				pcall(function()
					local playerGui = localPlayer:FindFirstChild("PlayerGui")

					if playerGui then
						for i, child in ipairs(playerGui:GetChildren()) do
							if child:IsA("ScreenGui") then
								if string.find(string.lower(child.Name), "cutscene") then
									if child.Enabled then
										child.Enabled = false
									end
								elseif child.Name == "Intro" then
									if child.Enabled then
										child.Enabled = false
									end
								end
							end
						end
					end
				end)
			end

			task.wait(0.2)
		end
	end)

	return tbl13
end)()

genv.__SenaV4ScrambleRuntime = (function()
	local tbl13 = {snapAt = 0, snap = nil, status = "Idle", lastBuy = 0, active = false, wantsCharacter = false}

	local function fn65()
		return require(ReplicatedStorage.Shared.Remotes).Scramble
	end

	tbl13.snapshot = function(arg)
		local now = os.clock()
		if not arg and (tbl13.snap and now - tbl13.snapAt < 1.5) then
			return tbl13.snap
		end

		local ok, snap = pcall(function()
			return fn65().Request:InvokeServer("Snapshot")
		end)

		if ok and (type(snap) == "table" and snap.State) then
			tbl13.snap = snap
			tbl13.snapAt = now
		end

		return tbl13.snap
	end

	tbl13.live = function()
		local v21 = tbl13.snapshot()
		if not v21 then
			return false
		end
		return v21.Ready == true and v21.Enabled == true and v21.WorldReady == true and workspace:GetServerTimeNow() < (v21.EventEndsAt or 0)
	end

	tbl13.samples = function()
		local v21 = tbl13.snapshot()
		return v21 and v21.State and v21.State.Samples or 0
	end

	tbl13.buyTick = function()
		local scrambleBuyList = senaV4Config.ScrambleBuyList

		if scrambleBuyList then
			if #scrambleBuyList == 0 then
				return
			end
		else
			return
		end

		if os.clock() - tbl13.lastBuy < 2 then
			return
		end
		local v21 = tbl13.snapshot(true)

		if v21 and v21.State then
			if not v21.Shop then
				return
			end
		else
			return
		end

		local samples = v21.State.Samples or 0

		for k, v22 in pairs(v21.Shop) do
			if not senaV4Config.ScrambleAutoBuy then
				return
			end
			local str3 = tostring(v22.Label)
			local flag6 = false

			for i, v23 in ipairs(scrambleBuyList) do
				if tostring(v23) == str3 then
					flag6 = true
					break
				end
			end

			if flag6 and (v22.Price or 0) <= samples then
				local v23 = (v21.State.ShopPurchases or {})[v22.Id]
				local count = v23 and v23.Period == v21.ShopPeriod and (v23.Count or 0) or 0
				local purchaseLimit = v22.PurchaseLimit

				if if purchaseLimit then count + (v22.Quantity or 1) <= v22.PurchaseLimit else not purchaseLimit then
					tbl13.lastBuy = os.clock()

					pcall(function()
						local request_ = fn65().Request
						local id = v22.Id
						local tbl14 = {Quote = v22.Quote}
						tbl14.Sequence = v21.State.ShopSequence
						request_:InvokeServer("Shop", id, tbl14)
					end)

					tbl13.status = "Bought " .. str3
					tbl13.snapshot(true)
					return
				end
			end
		end
	end

	task.spawn(function()
		while fn2() do
			if senaV4Config.ScrambleAutoBuy and not pcall(function()
				if not tbl13.live() then
					tbl13.status = "Event not active"
					return
				end
				tbl13.buyTick()
			end) then
				tbl13.status = "Idle"
			end

			task.wait(1)
		end
	end)

	return tbl13
end)()

do
	local senaV4RaceRuntime = {status = "Idle", lastResult = "No race yet", active = false, dist = nil, speed = 0, stuns = 0, corrections = 0, mount = nil, path = nil, leftFor = nil, lastJoinTry = 0, lastClaim = 0, lastBuy = 0, startedAt = nil, JOIN_LATE_SECONDS = 10, FIELD_SETTLE_SECONDS = 10, DODGE_STUDS = 10, CATCHUP_SPEED = 200, FINISH_RELEASE_STUDS = 150, RIDE_SPEED = 140, INPUT_PULSE_SECONDS = 1.5, RELEASE_AT_FINISH = false, LEGIT = true, LEAD_START = 200, LEAD_RETAKE = 100, BOOST_MAX_SECONDS = 18}

	local function fn65(...)
		local tbl13 = {...}
		local v21 = ReplicatedStorage

		for i, v22 in ipairs(tbl13) do
			v21 = v21 and v21:FindFirstChild(v22)
		end

		if not v21 then
			return nil
		end
		local ok, result = pcall(require, v21)
		return ok and result or nil
	end

	local function fn66()
		if senaV4RaceRuntime.m then
			return senaV4RaceRuntime.m
		end
		local m = {Remotes = fn65("Shared", "Remotes"), Save = fn65("Shared", "Save"), RR = fn65("Data", "RaceRally"), MR = fn65("Data", "MountRace"), Path = fn65("Shared", "Modules", "RaceTrackPath"), Flags = fn65("Shared", "Flags", "MountRaceFlags"), Elig = fn65("Shared", "Util", "RaceRallyEligibility"), Power = fn65("Data", "RacePowerUps")}

		if m.Remotes then
			if m.Save then
				if m.RR then
					if not m.MR then
						return nil
					end
				else
					return nil
				end
			else
				return nil
			end
		else
			return nil
		end

		senaV4RaceRuntime.m = m
		return m
	end

	local function fn67(arg, arg2, arg3)
		return localPlayer:GetAttribute(arg.MR.PlayerAttributes and arg.MR.PlayerAttributes[arg2] or arg3)
	end

	local function fn68(arg)
		local ok, result = pcall(arg.Save.Peek)
		return ok and type(result) == "table" and result or nil
	end

	senaV4RaceRuntime.inRace = function()
		local v21 = fn66()
		return v21 ~= nil and type(fn67(v21, "RaceId", "RaceId")) == "string"
	end

	senaV4RaceRuntime.joinLeft = function()
		local v21 = fn66()
		if not v21 then
			return 0
		end
		local attribute = Workspace:GetAttribute(v21.RR.Attributes.JoinEndsAt)
		if type(attribute) ~= "number" then
			return 0
		end
		return math.max(0, attribute - Workspace:GetServerTimeNow())
	end

	senaV4RaceRuntime.fieldSettling = function()
		local senaV4EggRuntime = genv.__SenaV4EggRuntime

		if senaV4EggRuntime then
			if senaV4EggRuntime.destroyed then
				return nil
			end
		else
			return nil
		end

		if senaV4EggRuntime.resetBlocked then
			return 1 / 0
		end
		local n8 = os.clock() - (tonumber(senaV4EggRuntime.gateOpenAt) or 0)
		return n8 < senaV4RaceRuntime.FIELD_SETTLE_SECONDS and senaV4RaceRuntime.FIELD_SETTLE_SECONDS - n8 or nil
	end

	senaV4RaceRuntime.roundId = function()
		local ok, result = pcall(function()
			return fn65("Shared", "Util", "RaceRallySchedule").Window(Workspace:GetServerTimeNow())
		end)

		return ok and result or nil
	end

	senaV4RaceRuntime.racedThisRound = function()
		local v21 = senaV4RaceRuntime.roundId()
		return v21 ~= nil and senaV4RaceRuntime.racedRound == v21
	end

	senaV4RaceRuntime.wantsJoin = function()
		local v21 = senaV4RaceRuntime.joinLeft()
		if v21 <= 0 then
			return false
		end

		if senaV4RaceRuntime.racedThisRound() then
			return false
		end

		if v21 > senaV4RaceRuntime.JOIN_LATE_SECONDS and senaV4RaceRuntime.fieldSettling() then
			return false
		end
		local v22 = fn66()
		if not v22 or type(fn67(v22, "FinishPlace", "RaceFinishPlace")) == "number" then
			return false
		end

		if senaV4RaceRuntime.eligibleAt and os.clock() - senaV4RaceRuntime.eligibleAt < 10 then
			return senaV4RaceRuntime.eligible
		end
		local v23 = fn68(v22)

		local ok, result = pcall(function()
			return v22.Elig == nil or v22.Elig.IsEligible(tonumber(v23 and v23.SpeedPower) or 0)
		end)

		senaV4RaceRuntime.eligible, senaV4RaceRuntime.eligibleAt = ok and result == true, os.clock()
		return senaV4RaceRuntime.eligible
	end

	senaV4RaceRuntime.join = function(arg)
		if os.clock() - senaV4RaceRuntime.lastJoinTry < 2 then
			return
		end
		local senaV4TreadmillManager = genv.__SenaV4TreadmillManager

		local ok, result = pcall(function()
			return senaV4TreadmillManager and not senaV4TreadmillManager.destroyed and senaV4TreadmillManager:isEngaged() == true
		end)

		if ok and result then
			senaV4RaceRuntime.status = "Leaving treadmill for the race"
			return
		end
		senaV4RaceRuntime.lastJoinTry = os.clock()
		local v21 = fn68(arg)

		if arg.Elig and v21 then
			local ok2, result2 = pcall(arg.Elig.IsEligible, tonumber(v21.SpeedPower) or 0)
			if ok2 and result2 ~= true then
				senaV4RaceRuntime.status = "Not eligible yet (need more speed)"
				return
			end
		end

		local world = Workspace:FindFirstChild("World")
		local raceRallyPortal = world and world:FindFirstChild("RaceRallyPortal")
		local character = localPlayer.Character
		local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		if not raceRallyPortal or not humanoidRootPart then
			return
		end

		local function fn69()
			for i, descendant in ipairs(raceRallyPortal:GetDescendants()) do
				if descendant:IsA("BasePart") and descendant.CanTouch then
					pcall(firetouchinterest, humanoidRootPart, descendant, 0)
					task.wait()
					pcall(firetouchinterest, humanoidRootPart, descendant, 1)
				end
			end

			local proximityPrompt = raceRallyPortal:FindFirstChildWhichIsA("ProximityPrompt", true)

			if proximityPrompt and (type(fireproximityprompt) == "function" and (humanoidRootPart.Position - proximityPrompt.Parent:GetPivot().Position).Magnitude < 20) then
				pcall(fireproximityprompt, proximityPrompt)
			end
		end

		ok = Workspace:GetAttribute(arg.RR.Attributes.JoinEndsAt)
		senaV4RaceRuntime.joinTries = (senaV4RaceRuntime.joinWindow == ok and senaV4RaceRuntime.joinTries or 0) + 1
		senaV4RaceRuntime.joinWindow = ok

		if senaV4RaceRuntime.joinTries > 2 and humanoid then
			local hitbox = raceRallyPortal:FindFirstChild("Hitbox")

			arg, ok = pcall(function()
				return hitbox:IsA("BasePart") and hitbox.Position or hitbox:GetPivot().Position
			end)

			if arg and (ok and (humanoidRootPart.Position - ok).Magnitude > 12) then
				senaV4RaceRuntime.status = "Going to the race portal"

				local function fn70()
					local v22 = fn2()
					return (if v22 then not senaV4Config.RaceAuto else not v22) or senaV4RaceRuntime.inRace() or senaV4RaceRuntime.joinLeft() <= 0
				end

				pcall(fn38, humanoidRootPart, humanoid, CFrame.new(ok + Vector3.new(0, 3, 0)), fn70, false, nil, false)
				if senaV4RaceRuntime.inRace() then
					return
				end
			end
		end

		fn69()
		senaV4RaceRuntime.status = "Joining race"
	end

	senaV4RaceRuntime.findControls = function()
		if senaV4RaceRuntime.controls then
			return senaV4RaceRuntime.controls
		end

		if os.clock() - (senaV4RaceRuntime.lastControlsSearch or 0) < 1 then
			return nil
		end
		senaV4RaceRuntime.lastControlsSearch = os.clock()

		if type(getgc) ~= "function" then
			return nil
		elseif type(debug) ~= "table" then
			return nil
		elseif type(debug.getupvalue) ~= "function" then
			return nil
		end

		return pcall(function()
			for i, v21 in ipairs(getgc(false)) do
				if type(v21) == "function" then
					local ok, result = pcall(debug.info, v21, "s")

					if ok and result and result:find("MountController") then
						local ok2, result2 = pcall(debug.info, v21, "n")

						if ok2 and result2 == "Step" then
							for i2 = 1, 6, 1 do
								local ok3, controls_ = pcall(debug.getupvalue, v21, i2)
								if ok3 and (type(controls_) == "table" and (rawget(controls_, "activeController") ~= nil and controls_.GetMoveVector ~= nil)) then
									senaV4RaceRuntime.controls = controls_
									return
								end
							end
						end
					end
				end
			end
		end) and senaV4RaceRuntime.controls or nil
	end

	senaV4RaceRuntime.releaseControls = function()
		local controls_ = senaV4RaceRuntime.controls

		if controls_ and rawget(controls_, "GetMoveVector") == senaV4RaceRuntime.finishMove then
			controls_.GetMoveVector = nil
		end

		local value = controls_ and rawget(controls_, "activeController")

		if type(value) == "table" and value.moveVector == senaV4RaceRuntime.finishInput then
			value.moveVector = Vector3.new(0, 0, 0)
		end

		senaV4RaceRuntime.finishMove = nil
		senaV4RaceRuntime.finishInput = nil
	end

	senaV4RaceRuntime.rivalGap = function(arg)
		local path = senaV4RaceRuntime.path

		if arg then
			if not path then
				return nil
			end
		else
			return nil
		end

		local length = path.Length
		local now = os.clock()
		local rivals = senaV4RaceRuntime.rivals

		if if rivals then now - (senaV4RaceRuntime.rivalsAt or 0) > 2.5 else not rivals then
			local rivals2 = {}
			local character = localPlayer.Character

			pcall(function()
				for i, descendant in ipairs(Workspace:GetDescendants()) do
					if descendant:IsA("Model") and (descendant ~= character and descendant:FindFirstChildOfClass("Humanoid")) then
						local humanoidRootPart = descendant:FindFirstChild("HumanoidRootPart") or descendant.PrimaryPart

						if humanoidRootPart and humanoidRootPart:IsA("BasePart") then
							local ok, result, result2 = pcall(path.Project, path, humanoidRootPart.Position, 0, length, length)

							if ok and (type(result) == "number" and (type(result2) == "number" and result2 < 30)) then
								rivals2[#rivals2 + 1] = humanoidRootPart
							end
						end
					end
				end
			end)

			senaV4RaceRuntime.rivals = rivals2
			senaV4RaceRuntime.rivalsAt = now
		end

		now, rivals = false

		for i, rival in ipairs(senaV4RaceRuntime.rivals) do
			if rival.Parent then
				local ok, result = pcall(path.Project, path, rival.Position, arg, 150, 150)

				if ok and type(result) == "number" then
					local n8 = (result % length - arg + length / 2) % length - length / 2

					if n8 > 5 then
						now = true
					else
						if n8 < 0 then
							local n9 = -n8
							rivals = if rivals then if n9 < rivals then n9 else rivals else n9
						end
					end
				end
			end
		end

		if now then
			return 0
		end
		return rivals
	end

	senaV4RaceRuntime.decideSpeed = function()
		local n8 = tonumber(localPlayer:GetAttribute("RacePlace")) or 1
		local v21 = senaV4RaceRuntime.rivalGap(senaV4RaceRuntime.legitProg)
		local now = os.clock()

		if senaV4RaceRuntime.boosting then
			senaV4RaceRuntime.boostStartedAt = senaV4RaceRuntime.boostStartedAt or now

			if n8 == 1 and v21 ~= nil and v21 >= (senaV4RaceRuntime.leadTarget or senaV4RaceRuntime.LEAD_START) or now - senaV4RaceRuntime.boostStartedAt > senaV4RaceRuntime.BOOST_MAX_SECONDS then
				senaV4RaceRuntime.boosting = false
				senaV4RaceRuntime.leadDone = true
				senaV4RaceRuntime.leadTarget = senaV4RaceRuntime.LEAD_RETAKE
				senaV4RaceRuntime.boostStartedAt = nil
			end
		elseif n8 > 1 then
			senaV4RaceRuntime.boosting = true
			senaV4RaceRuntime.boostStartedAt = now
		end

		return senaV4RaceRuntime.boosting and senaV4RaceRuntime.CATCHUP_SPEED or senaV4RaceRuntime.RIDE_SPEED
	end

	senaV4RaceRuntime.legitStep = function(arg)
		local v21 = senaV4RaceRuntime.findControls()
		local path = senaV4RaceRuntime.path
		local character = localPlayer.Character
		local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

		if v21 then
			if path then
				if not humanoidRootPart then
					return
				end
			else
				return
			end
		else
			return
		end

		if arg and arg.Touch ~= true then
			arg.Touch = true
		end

		local v22 = senaV4RaceRuntime.decideSpeed()

		if senaV4RaceRuntime.flagsSet ~= v22 then
			senaV4RaceRuntime.flagsSet = v22

			pcall(function()
				local MountRaceFlags = require(ReplicatedStorage.Shared.Flags.MountRaceFlags)

				for k, v23 in pairs({TopSpeed = v22, AccelSeconds = 0.3, AirFallSeconds = 9999, WallSpeedKeep = 0.95, BrakeSeconds = 3}) do
					local v24 = MountRaceFlags[k]

					if type(v24) == "table" and rawget(v24, "Value") ~= nil then
						v24.Value = v23
					end
				end
			end)
		end

		local position = humanoidRootPart.Position
		local now = os.clock()
		local legitProg = senaV4RaceRuntime.legitProg

		if if legitProg then now - (senaV4RaceRuntime.legitFull or 0) > 0.5 else not legitProg then
			local ok, result = pcall(path.Project, path, position, 0, path.Length, path.Length)

			if ok and type(result) == "number" then
				senaV4RaceRuntime.legitProg = result % path.Length
			end

			senaV4RaceRuntime.legitFull = now
		else
			local ok, result = pcall(path.Project, path, position, senaV4RaceRuntime.legitProg, 40, 120)

			if ok and type(result) == "number" then
				senaV4RaceRuntime.legitProg = result % path.Length
			end
		end

		local legitProg2 = senaV4RaceRuntime.legitProg
		if not legitProg2 then
			return
		end
		local raceMount = character:FindFirstChild("RaceMount")
		local hitbox = raceMount and raceMount:FindFirstChild("Hitbox") or humanoidRootPart
		local lookVector = hitbox.CFrame.LookVector
		local upVector = hitbox.CFrame.UpVector
		local magnitude = humanoidRootPart.AssemblyLinearVelocity.Magnitude
		local length = path.Length
		local v23 = path:FrameAt((legitProg2 + math.clamp(magnitude * 0.35, 25, 60)) % length)
		humanoidRootPart = false
		raceMount = 0

		for i, v24 in ipairs(senaV4RaceRuntime.hazards()) do
			local ok, result = pcall(path.Project, path, v24.pos, legitProg2, 10, 110)

			if ok and type(result) == "number" then
				local n8 = (result % length - legitProg2) % length

				if n8 > 5 and n8 < 110 then
					local n9 = path:FrameAt(result % length)
					local v25 = (v24.pos - n9.Position):Dot(n9.RightVector)
					local v26 = (position - n9.Position):Dot(n9.RightVector)
					local n10 = v24.radius + 9

					if math.abs(v25 - v26) < n10 then
						n9 = v25 + (v26 >= v25 and n10 or -n10)
						local n11 = math.clamp(n9, -22, 22)
						raceMount = if humanoidRootPart then if math.abs(n11 - v26) > math.abs(raceMount) then n11 else raceMount else n11
						humanoidRootPart = true
					end
				end
			end
		end

		local n8 = v23.Position + v23.RightVector * raceMount - position
		local n9 = lookVector - upVector * lookVector:Dot(upVector)
		local n10 = n8 - upVector * n8:Dot(upVector)
		lookVector = 0
		raceMount = -1

		if n9.Magnitude > 0.01 and n10.Magnitude > 0.01 then
			local unit = n9.Unit
			local unit2 = n10.Unit
			local v24 = math.atan2(unit:Cross(unit2):Dot(upVector), unit:Dot(unit2))
			lookVector = if humanoidRootPart then math.clamp(-v24 * 2.2, -1, 1) else if math.abs(v24) > 0.4363323129985824 then math.clamp(-v24 * 1.2, -1, 1) else lookVector

			if math.abs(v24) > 1.7453292519943295 then
				lookVector = v24 > 0 and -1 or 1
				raceMount = magnitude > 40 and -0.3 or -1
			end
		end

		senaV4RaceRuntime.legitSteer = (senaV4RaceRuntime.legitSteer or 0) + (lookVector - (senaV4RaceRuntime.legitSteer or 0)) * 0.35
		local legitSteer = senaV4RaceRuntime.legitSteer
		senaV4RaceRuntime.finishInput = Vector3.new(legitSteer, 0, raceMount)

		if rawget(v21, "GetMoveVector") ~= senaV4RaceRuntime.finishMove then
			function senaV4RaceRuntime.finishMove()
				return senaV4RaceRuntime.finishInput or Vector3.new(0, 0, -1)
			end

			v21.GetMoveVector = senaV4RaceRuntime.finishMove
		end

		local value = rawget(v21, "activeController")

		if type(value) == "table" then
			value.moveVector = senaV4RaceRuntime.finishInput
		end

		if arg and type(arg.Jump) == "function" then
			for i, v24 in ipairs(senaV4RaceRuntime.jumpProgs or {}) do
				if (v24 - legitProg2) % length <= 10 and (magnitude > 40 and (senaV4RaceRuntime.jumpedAt[v24] or 0) < now - 3) then
					senaV4RaceRuntime.jumpedAt[v24] = now
					pcall(arg.Jump, arg)
				end
			end
		end

		senaV4RaceRuntime.status = string.format("Racing (legit)  \194\183  Lap %s  \194\183  Place %s", tostring(localPlayer:GetAttribute("RaceLap") or "?"), tostring(localPlayer:GetAttribute("RacePlace") or "?"))
	end

	senaV4RaceRuntime.findJumps = function()
		senaV4RaceRuntime.jumpProgs = {}
		senaV4RaceRuntime.jumpedAt = {}
		local path = senaV4RaceRuntime.path
		local raceTrack = Workspace:FindFirstChild("RaceTrack")

		if path then
			if not raceTrack then
				return
			end
		else
			return
		end

		for i, descendant in ipairs(raceTrack:GetDescendants()) do
			if descendant:IsA("Model") and descendant.Name == "Jump" then
				local ok, result, result2 = pcall(function()
					return descendant:GetBoundingBox()
				end)

				if ok and result and result2 then
					local n8, tbl13, v21 = path:Project(result.Position, 0, path.Length, path.Length) % path.Length, {-0.5, 0.5}

					for i2, v22 in ipairs(tbl13) do
						for i3, v23 in ipairs({-0.5, 0.5}) do
							for i4, v24 in ipairs({-0.5, 0.5}) do
								i4 = result:PointToWorldSpace(Vector3.new(result2.X * v22, result2.Y * v23, result2.Z * v24))
								i3, v24 = pcall(path.Project, path, i4, n8, 250, 250)

								if i3 and type(v24) == "number" then
									local n9 = v24 % path.Length
									local n10 = (n8 - n9) % path.Length
									v21 = if n10 < 400 then if v21 then if n10 > (n8 - v21) % path.Length then n9 else v21 else n9 else v21
								end
							end
						end
					end

					senaV4RaceRuntime.jumpProgs[#senaV4RaceRuntime.jumpProgs + 1] = ((v21 or n8) - 8) % path.Length
				end
			end
		end
	end

	senaV4RaceRuntime.findMount = function()
		local mount = senaV4RaceRuntime.mount
		if mount and (typeof(mount.Drive) == "Instance" and mount.Drive.Parent) then
			return mount
		end
		senaV4RaceRuntime.mount = nil
		if os.clock() - (senaV4RaceRuntime.lastMountSearch or 0) < 0.5 then
			return nil
		end
		senaV4RaceRuntime.lastMountSearch = os.clock()
		mount = nil

		if type(filtergc) == "function" then
			local ok, result = pcall(filtergc, "table", {Keys = {"Holds", "Drive", "Align", "Push", "Heading", "TravelDirection"}}, false)
			mount = if ok then if type(result) == "table" then result else mount else mount
		end

		if mount then
		else
			if type(getgc) == "function" then
				local ok, result = pcall(getgc, true)

				if ok and type(result) == "table" then
					local tbl13 = {}

					for i, v21 in ipairs(result) do
						if type(v21) == "table" and (rawget(v21, "Holds") ~= nil and (rawget(v21, "Drive") ~= nil and rawget(v21, "Align") ~= nil)) then
							tbl13[#tbl13 + 1] = v21
						end
					end

					mount = tbl13
				end
			end
		end

		if type(mount) ~= "table" then
			senaV4RaceRuntime.status = "Your executor can't ride the race (no filtergc/getgc)"
			return nil
		end

		for i, v21 in ipairs(mount) do
			if typeof(v21.Drive) == "Instance" and v21.Drive.Parent then
				senaV4RaceRuntime.mount = v21
				break
			end
		end

		return senaV4RaceRuntime.mount
	end

	senaV4RaceRuntime.hazards = function()
		local now = os.clock()
		if senaV4RaceRuntime.hazardCache and now - senaV4RaceRuntime.hazardAt < 0.2 then
			return senaV4RaceRuntime.hazardCache
		end
		local hazardCache = {}
		local racePowerUpFX = Workspace:FindFirstChild("RacePowerUpFX")

		for i, v21 in ipairs(racePowerUpFX and racePowerUpFX:GetChildren() or {}) do
			local ok, result = pcall(function()
				return v21:IsA("Model") and v21:GetPivot().Position or v21.Position
			end)

			if ok and typeof(result) == "Vector3" then
				hazardCache[#hazardCache + 1] = {pos = result, radius = 8}
			end
		end

		racePowerUpFX = Workspace:FindFirstChild("RaceTrack")
		local creatures = racePowerUpFX and racePowerUpFX:FindFirstChild("Map") and racePowerUpFX.Map:FindFirstChild("Creatures")

		for i, v21 in ipairs(creatures and creatures:GetChildren() or {}) do
			if v21:IsA("Model") and v21.Name:find("Arm") then
				local ok, result, result2 = pcall(function()
					return v21:GetBoundingBox()
				end)

				if ok and result then
					local n8 = #hazardCache + 1
					local tbl13 = {pos = result.Position}
					tbl13.radius, hazardCache[n8] = math.min(math.max(result2.X, result2.Z) / 2, 20), tbl13
				end
			end
		end

		senaV4RaceRuntime.hazardCache = hazardCache
		senaV4RaceRuntime.hazardAt = now
		return hazardCache
	end

	senaV4RaceRuntime.step = function(arg, arg2)
		local v21 = fn66()
		local root = arg.Rig and arg.Rig.Root

		if v21 then
			if senaV4RaceRuntime.path then
				if not root then
					return
				end
			else
				return
			end
		else
			return
		end

		if arg:IsHeld() then
			senaV4RaceRuntime.dist = nil
			return
		end
		local path = senaV4RaceRuntime.path
		local topSpeed = v21.Flags and v21.Flags.TopSpeed and v21.Flags.TopSpeed:Get() or 135

		if not senaV4RaceRuntime.dist then
			local ok, result = pcall(path.Project, path, root.Position, 0, path.Length, path.Length)
			senaV4RaceRuntime.dist = ok and type(result) == "number" and result or 0
			senaV4RaceRuntime.speed = math.max(tonumber(arg.Speed) or 0, topSpeed * 0.5)
		end

		if (path:FrameAt(senaV4RaceRuntime.dist).Position - root.Position).Magnitude > 45 then
			local ok, dist = pcall(path.Project, path, root.Position, senaV4RaceRuntime.dist, 80, 220)

			if ok and type(dist) == "number" then
				senaV4RaceRuntime.dist = dist
			end
		end

		local scale = senaV4RaceRuntime.scale or 1
		senaV4RaceRuntime.speed = senaV4RaceRuntime.speed + (topSpeed * scale - senaV4RaceRuntime.speed) * math.min(1, arg2 * 1.5)
		senaV4RaceRuntime.dist = senaV4RaceRuntime.dist + senaV4RaceRuntime.speed * arg2
		local v22 = path:FrameAt(senaV4RaceRuntime.dist)
		local v23 = path:FrameAt(senaV4RaceRuntime.dist + 20)
		local upVector = v22.UpVector
		local rightVector = v22.RightVector
		local v24 = if rightVector.Magnitude < 0.001 then v22.LookVector:Cross(upVector) else rightVector
		local n8, v25 = path:FrameAt(senaV4RaceRuntime.dist + math.clamp(senaV4RaceRuntime.speed * 0.6, 60, 200)).Position + upVector * 2.5

		for i, v26 in ipairs(senaV4RaceRuntime.hazards()) do
			path = v26.pos - n8
			local n9 = math.abs(path:Dot((v23.Position - v22.Position).Unit))
			local v27 = path:Dot(v24)
			v25 = if n9 < v26.radius + 30 then if math.abs(v27) < v26.radius + 10 then if v25 then if math.abs(v27) < math.abs(v25) then v27 else v25 else v27 else v25 else v25
		end

		local v26 = if v25 then v25 > 0 and -senaV4RaceRuntime.DODGE_STUDS or senaV4RaceRuntime.DODGE_STUDS else 0
		senaV4RaceRuntime.lateral = (senaV4RaceRuntime.lateral or 0) + (v26 - (senaV4RaceRuntime.lateral or 0)) * math.min(1, arg2 * 3)
		local n9 = 2.5
		local character = localPlayer.Character
		local raceMount = character and character:FindFirstChild("RaceMount")
		local hitbox = raceMount and raceMount:FindFirstChild("Hitbox") or arg.Rig and arg.Rig.Mount and arg.Rig.Mount:FindFirstChild("Hitbox")

		local function fn69(arg3)
			if not senaV4RaceRuntime.roadParams then
				local raceTrack = Workspace:FindFirstChild("RaceTrack")
				local raycastParams = RaycastParams.new()
				raycastParams.FilterType = Enum.RaycastFilterType.Include
				raycastParams.FilterDescendantsInstances = {raceTrack and raceTrack:FindFirstChild("Track")}
				senaV4RaceRuntime.roadParams = raycastParams
			end

			local hit = Workspace:Raycast(arg3 + upVector * 60, -upVector * 120, senaV4RaceRuntime.roadParams)
			return hit and hit.Position or nil
		end

		local v27 = fn69(v22.Position + v24 * senaV4RaceRuntime.lateral)
		local n10 = hitbox and (hitbox.Position - root.Position):Dot(upVector) or 0
		local n11 = (hitbox and hitbox.Size.Y / 2 or 2) + 0.3 - n10
		local n12 = v27 and v27 + upVector * n11 or v22.Position + upVector * n9 + v24 * senaV4RaceRuntime.lateral
		local v28 = fn69(v23.Position + v24 * senaV4RaceRuntime.lateral)
		local n13 = (v28 and v28 + upVector * n11 or v23.Position + upVector * n9 + v24 * senaV4RaceRuntime.lateral) - n12
		local unit = n13.Magnitude > 0.001 and n13.Unit or v22.LookVector
		root.AssemblyLinearVelocity = unit * senaV4RaceRuntime.speed + (n12 - root.Position) * 9
		root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
		arg.Drive.Enabled = false
		arg.Push.Force = Vector3.new(0, 1, 0) * root.AssemblyMass * Workspace.Gravity
		arg.Align.CFrame = CFrame.lookAt(Vector3.new(0, 0, 0), unit, upVector)
		root.CFrame = CFrame.new(root.Position) * arg.Align.CFrame
		arg.Up = upVector
		arg.Heading = unit
		arg.TravelDirection = unit
		arg.Speed = senaV4RaceRuntime.speed
		arg.Grounded = v27 ~= nil
		arg.AirSeconds = 0
		arg.Launched = v27 == nil
	end

	senaV4RaceRuntime.override = function(arg, arg2)
		if not pcall(senaV4RaceRuntime.step, arg, arg2) then
			arg.Override = nil
			senaV4RaceRuntime.dist = nil
		end
	end

	senaV4RaceRuntime.drive = function(arg)
		if senaV4RaceRuntime.active then
			return
		end
		senaV4RaceRuntime.active = true
		senaV4RaceRuntime.dist = nil
		senaV4RaceRuntime.mount = nil
		senaV4RaceRuntime.stuns = 0
		senaV4RaceRuntime.corrections = 0
		senaV4RaceRuntime.scale = 1
		senaV4RaceRuntime.startedAt = os.clock()

		pcall(function()
			local physics = settings().Physics

			if physics.PhysicsEnvironmentalThrottle == Enum.EnviromentalPhysicsThrottle.Always then
				senaV4RaceRuntime.pausedThrottle = physics.PhysicsEnvironmentalThrottle
				physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.DefaultAuto
			end
		end)

		local tbl13 = {}
		senaV4RaceRuntime.finishing = false
		senaV4RaceRuntime.released = false
		senaV4RaceRuntime.legitProg = nil
		senaV4RaceRuntime.jumpProgs = nil
		senaV4RaceRuntime.controls = nil
		senaV4RaceRuntime.boosting, senaV4RaceRuntime.leadTarget = true, senaV4RaceRuntime.LEAD_START
		senaV4RaceRuntime.leadDone = false
		senaV4RaceRuntime.rivals = nil
		senaV4RaceRuntime.rivalsAt = 0
		senaV4RaceRuntime.boostStartedAt = nil

		local function fn69()
			for k in pairs(tbl13) do
				if k.Parent then
					pcall(function()
						k.CanCollide = true
					end)
				end
			end

			tbl13 = {}
		end

		local connection6 = game:GetService("RunService").Stepped:Connect(function()
			if senaV4RaceRuntime.released then
				return
			elseif senaV4RaceRuntime.LEGIT then
				return
			end

			local character = localPlayer.Character
			if not character then
				return
			end

			for i, descendant in ipairs(character:GetDescendants()) do
				if descendant:IsA("BasePart") and descendant.CanCollide then
					tbl13[descendant] = true
					descendant.CanCollide = false
				end
			end
		end)

		local v21 = Workspace:FindFirstChild(arg.RR.Track or "RaceTrack")

		if arg.Path and (v21 and v21:FindFirstChild("AttachmentTrack")) then
			local ok, result = pcall(arg.Path.new, v21.AttachmentTrack)
			senaV4RaceRuntime.path = ok and result or nil
		end

		task.spawn(function()
			while fn2() and senaV4Config.RaceAuto and senaV4RaceRuntime.inRace() and type(fn67(arg, "FinishPlace", "RaceFinishPlace")) ~= "number" do
				pcall(function()
					local physics = settings().Physics

					if physics.PhysicsEnvironmentalThrottle == Enum.EnviromentalPhysicsThrottle.Always then
						senaV4RaceRuntime.pausedThrottle = senaV4RaceRuntime.pausedThrottle or physics.PhysicsEnvironmentalThrottle
						physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.DefaultAuto
					end
				end)

				local v22 = senaV4RaceRuntime.findMount()

				if senaV4RaceRuntime.LEGIT then
					if not senaV4RaceRuntime.jumpProgs then
						senaV4RaceRuntime.findJumps()
					end

					pcall(senaV4RaceRuntime.legitStep, v22)
					task.wait()
					continue
				end

				if v22 and not senaV4RaceRuntime.finishing then
					local n8 = tonumber(v21 and v21:GetAttribute("RaceLaps")) or 3
					local num = tonumber(fn67(arg, "Lap", "RaceLap"))
					local finishLine = v21 and v21:FindFirstChild("FinishLine")
					local humanoidRootPart = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
					local n9 = senaV4RaceRuntime.path and senaV4RaceRuntime.dist and senaV4RaceRuntime.path.Length - senaV4RaceRuntime.dist % senaV4RaceRuntime.path.Length or 1 / 0

					if num and (num >= n8 and (finishLine and (finishLine:IsA("BasePart") and (humanoidRootPart and n9 < senaV4RaceRuntime.FINISH_RELEASE_STUDS)))) then
						senaV4RaceRuntime.finishing = true

						if senaV4RaceRuntime.RELEASE_AT_FINISH then
							if v22.Override == senaV4RaceRuntime.override then
								v22.Override = nil
							end

							pcall(function()
								v22.Drive.Enabled = true
							end)

							senaV4RaceRuntime.released = true
							fn69()
						end
					end
				end

				local now = os.clock()

				if not senaV4RaceRuntime.nextPulse then
					senaV4RaceRuntime.nextPulse = now + 5
				end

				if now >= senaV4RaceRuntime.nextPulse then
					senaV4RaceRuntime.pulseUntil = now + senaV4RaceRuntime.INPUT_PULSE_SECONDS
					senaV4RaceRuntime.nextPulse = now + 15 + math.random() * 8
				end

				local flag6 = now < (senaV4RaceRuntime.pulseUntil or 0)

				if senaV4RaceRuntime.finishing then
				elseif flag6 then
				elseif senaV4RaceRuntime.finishMove then
					senaV4RaceRuntime.releaseControls()
				end

				if senaV4RaceRuntime.finishing or flag6 then
					local finishLine = v21 and v21:FindFirstChild("FinishLine")
					local humanoidRootPart = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
					local v23 = senaV4RaceRuntime.findControls()

					if v23 and humanoidRootPart and (finishLine or senaV4RaceRuntime.path) then
						local hitbox = localPlayer.Character:FindFirstChild("RaceMount") and localPlayer.Character.RaceMount:FindFirstChild("Hitbox") or humanoidRootPart
						local lookVector = hitbox.CFrame.LookVector
						local upVector = hitbox.CFrame.UpVector
						local n8 = (senaV4RaceRuntime.finishing and finishLine and finishLine.Position or senaV4RaceRuntime.path and senaV4RaceRuntime.dist and senaV4RaceRuntime.path:FrameAt((senaV4RaceRuntime.dist + 40) % senaV4RaceRuntime.path.Length).Position or humanoidRootPart.Position + lookVector * 40) - humanoidRootPart.Position
						local n9 = lookVector - upVector * lookVector:Dot(upVector)
						local n10 = n8 - upVector * n8:Dot(upVector)
						local n11 = 0

						if n9.Magnitude > 0.01 and n10.Magnitude > 0.01 then
							local unit = n9.Unit
							local unit2 = n10.Unit
							n11 = math.clamp(-math.atan2(unit:Cross(unit2):Dot(upVector), unit:Dot(unit2)) * 2.5, -1, 1)
						end

						senaV4RaceRuntime.finishInput = Vector3.new(n11, 0, -1)

						if rawget(v23, "GetMoveVector") ~= senaV4RaceRuntime.finishMove then
							function senaV4RaceRuntime.finishMove()
								return senaV4RaceRuntime.finishInput or Vector3.new(0, 0, -1)
							end

							v23.GetMoveVector = senaV4RaceRuntime.finishMove
						end
					end

					if senaV4RaceRuntime.finishing and (finishLine and (humanoidRootPart and os.clock() - (senaV4RaceRuntime.lastLineTouch or 0) > 0.25)) then
						senaV4RaceRuntime.lastLineTouch = os.clock()
						pcall(firetouchinterest, humanoidRootPart, finishLine, 0)
						task.wait()
						pcall(firetouchinterest, humanoidRootPart, finishLine, 1)
					end
				end

				if v22 and senaV4RaceRuntime.path and not senaV4RaceRuntime.released then
					tonumber(fn67(arg, "Place", "RacePlace"))
					local topSpeed = arg.Flags and arg.Flags.TopSpeed and arg.Flags.TopSpeed:Get() or 135
					local scale = senaV4RaceRuntime.RIDE_SPEED / topSpeed

					if senaV4RaceRuntime.scale ~= scale and senaV4RaceRuntime.corrections == 0 then
						senaV4RaceRuntime.scale = scale
					end

					local override = v22.Override

					if override ~= nil and override ~= senaV4RaceRuntime.override then
						v22.Override = nil
						senaV4RaceRuntime.dist = nil
						senaV4RaceRuntime.stuns = senaV4RaceRuntime.stuns + 1
					elseif override == nil then
						if not v22:IsHeld() then
							v22.Override = senaV4RaceRuntime.override
						end
					end

					senaV4RaceRuntime.status = string.format("Racing x%.2f  \194\183  Lap %s  \194\183  Place %s", senaV4RaceRuntime.scale, tostring(fn67(arg, "Lap", "RaceLap") or "?"), tostring(fn67(arg, "Place", "RacePlace") or "?"))
				end

				task.wait()
			end

			connection6:Disconnect()
			senaV4RaceRuntime.releaseControls()
			senaV4RaceRuntime.finishing = false
			senaV4RaceRuntime.released = false

			for k in pairs(tbl13) do
				if k.Parent then
					pcall(function()
						k.CanCollide = true
					end)
				end
			end

			if senaV4RaceRuntime.pausedThrottle then
				local pausedThrottle = senaV4RaceRuntime.pausedThrottle
				senaV4RaceRuntime.pausedThrottle = nil

				pcall(function()
					settings().Physics.PhysicsEnvironmentalThrottle = pausedThrottle
				end)
			end

			local mount = senaV4RaceRuntime.mount

			if mount and mount.Override == senaV4RaceRuntime.override then
				mount.Override = nil
			end

			local finishPlace = fn67(arg, "FinishPlace", "RaceFinishPlace")
			local finishTime = fn67(arg, "FinishTime", "RaceFinishTime")

			if type(finishPlace) == "number" then
				senaV4RaceRuntime.lastResult = string.format("Place #%d in %s", finishPlace, type(finishTime) == "number" and string.format("%d:%02d", math.floor(finishTime / 60), math.floor(finishTime % 60)) or "?")
			end

			senaV4RaceRuntime.active = false
			senaV4RaceRuntime.mount = nil
			senaV4RaceRuntime.path = nil
			senaV4RaceRuntime.dist = nil
		end)

		task.spawn(function()
			local attributes = arg.Power and arg.Power.Attributes or {}

			while fn2() and senaV4RaceRuntime.active do
				pcall(function()
					local serverTimeNow = Workspace:GetServerTimeNow()
					local attribute = localPlayer:GetAttribute(attributes.Item or "RaceItem")
					local attribute2 = localPlayer:GetAttribute(attributes.RollEndsAt or "RaceRollEndsAt")
					local attribute3 = localPlayer:GetAttribute(attributes.Effect or "RaceEffect")
					local attribute4 = localPlayer:GetAttribute(attributes.EffectEndsAt or "RaceEffectEndsAt")
					local flag6 = type(attribute2) == "number" and serverTimeNow < attribute2
					local flag7 = type(attribute3) == "string" and type(attribute4) == "number" and serverTimeNow < attribute4
					local humanoidRootPart = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")

					if type(attribute) == "string" then
						if flag6 then
						elseif flag7 then
						elseif humanoidRootPart then
							arg.Remotes.MountRace.PowerUp:FireServer("Use", humanoidRootPart.Position, humanoidRootPart.CFrame.LookVector)
							senaV4RaceRuntime.powerUps = (senaV4RaceRuntime.powerUps or 0) + 1
							task.wait(1)
						end
					end
				end)

				task.wait(0.4)
			end
		end)
	end

	senaV4RaceRuntime.claim = function(arg)
		if os.clock() - senaV4RaceRuntime.lastClaim < 10 then
			return
		end
		senaV4RaceRuntime.lastClaim = os.clock()
		local n8 = fn68(arg)
		local raceRally = n8 and n8.RaceRally
		if type(raceRally) ~= "table" then
			return
		end
		local milestones, n9, ok, result = type(raceRally.Milestones) == "table" and raceRally.Milestones or {}, tonumber(raceRally.Wins) or 0, pcall(arg.RR.OrderedMilestones)

		for i, v21 in ipairs(ok and result or {}) do
			local num = v21.Config and tonumber(v21.Config.Wins)

			if milestones[v21.Id] then
			elseif num then
				if n9 >= num then
					pcall(function()
						arg.Remotes.RaceRally.AskClaimMilestone:InvokeServer(v21.Id)
					end)
				end
			end
		end

		if arg.RR.RepeatId and (arg.RR.Repeat and n9 >= (tonumber(arg.RR.Repeat.After) or 1 / 0)) then
			pcall(function()
				arg.Remotes.RaceRally.AskClaimMilestone:InvokeServer(arg.RR.RepeatId)
			end)
		end

		local v21
		local v22 = pairs
		local racers = type(raceRally.Racers) == "table" and raceRally.Racers or {}
		n8 = -1

		for k in v22(racers) do
			local racers2 = arg.RR.Racers and arg.RR.Racers[k]
			local n10 = racers2 and tonumber(racers2.Order) or 0

			if n10 > n8 then
				v21 = k
				n8 = n10
			end
		end

		if v21 and raceRally.EquippedRacer ~= v21 then
			pcall(function()
				arg.Remotes.RaceRally.AskEquipRacer:InvokeServer(v21)
			end)
		end
	end

	senaV4RaceRuntime.buy = function(arg)
		local raceBuyList = senaV4Config.RaceBuyList

		if type(raceBuyList) ~= "table" then
			return
		elseif #raceBuyList == 0 then
			return
		end

		if os.clock() - senaV4RaceRuntime.lastBuy < 2 then
			return
		end
		local v21 = fn68(arg)
		local raceRally = v21 and v21.RaceRally
		if type(raceRally) ~= "table" then
			return
		end
		local ok, result = pcall(arg.RR.OrderedOffers)

		for i, v22 in ipairs(ok and result or {}) do
			local num = v22.Config and tonumber(v22.Config.Price)

			if table.find(raceBuyList, v22.Id) and (num and num <= (tonumber(raceRally.Tokens) or 0)) then
				local n8, ok2, result2 = tonumber(v22.Config.Limit) or 0, pcall(arg.RR.PurchasedCount, raceRally, v22.Id)

				if n8 == 0 or not ok2 or (tonumber(result2) or 0) < n8 then
					senaV4RaceRuntime.lastBuy = os.clock()

					pcall(function()
						arg.Remotes.RaceRally.AskBuy:InvokeServer(v22.Id)
					end)

					return
				end
			end
		end
	end

	task.spawn(function()
		local remotes = fn66() and senaV4RaceRuntime.m.Remotes
		local raise = remotes and remotes.Alerts and remotes.Alerts.Raise

		if raise then
			local connection6

			local function fn69(arg)
				if not fn2() then
					connection6:Disconnect()
					return
				end

				if (type(arg) == "table" and tostring(arg.Text or arg.Body or "") or tostring(arg)):lower():find("already raced", 1, true) then
					senaV4RaceRuntime.racedRound = senaV4RaceRuntime.roundId() or senaV4RaceRuntime.racedRound
				end
			end

			connection6 = raise.OnClientEvent:Connect(fn69)
		end

		local correctionBegan = remotes and remotes.RigSync and remotes.RigSync.CorrectionBegan

		if correctionBegan then
			local connection6

			local function fn69()
				if not fn2() then
					connection6:Disconnect()
					return
				end

				if senaV4RaceRuntime.active then
					senaV4RaceRuntime.corrections = senaV4RaceRuntime.corrections + 1
					senaV4RaceRuntime.scale = math.max(1, (senaV4RaceRuntime.scale or 3) - 0.15)
					senaV4RaceRuntime.dist = nil
				end
			end

			connection6 = correctionBegan.OnClientEvent:Connect(fn69)
		end

		while fn2() do
			pcall(function()
				local v21 = fn66()
				if not v21 then
					senaV4RaceRuntime.status = "Race data not loaded"
					return
				end

				if senaV4Config.RaceAuto then
					if type((fn67(v21, "RaceId", "RaceId"))) == "string" then
						senaV4RaceRuntime.racedRound = senaV4RaceRuntime.roundId() or senaV4RaceRuntime.racedRound
						local finishPlace = fn67(v21, "FinishPlace", "RaceFinishPlace")

						if type(finishPlace) == "number" then
							if senaV4RaceRuntime.leftFor ~= finishPlace and not senaV4RaceRuntime.active then
								senaV4RaceRuntime.leftFor = finishPlace
								task.wait(2)
								v21.Remotes.MountRace.AskLeave:FireServer()
								senaV4RaceRuntime.status = "Finished, back to base"
							end
						else
							senaV4RaceRuntime.leftFor = nil
							senaV4RaceRuntime.drive(v21)
						end
					elseif senaV4RaceRuntime.joinLeft() > 0 and senaV4RaceRuntime.racedThisRound() then
						senaV4RaceRuntime.status = "Already raced this round, waiting for the next one"
					elseif senaV4RaceRuntime.joinLeft() > 0 then
						local race = senaV4TaskLadder.blocker("race")
						local flag6 = senaV4RaceRuntime.joinLeft() > senaV4RaceRuntime.JOIN_LATE_SECONDS and senaV4RaceRuntime.fieldSettling() or nil

						if flag6 then
							senaV4RaceRuntime.status = flag6 == 1 / 0 and "Race open, waiting for the field to reopen" or string.format("Race open, checking new eggs (%ds)", math.ceil(flag6))
						elseif race then
							senaV4RaceRuntime.status = "Yielding to " .. tostring(senaV4TaskLadder.TITLES[race] or race)
						else
							senaV4RaceRuntime.join(v21)
						end
					else
						senaV4RaceRuntime.status = "Waiting for the next race"
					end
				end

				if senaV4Config.RaceClaim then
					senaV4RaceRuntime.claim(v21)
				end

				if senaV4Config.RaceBuy then
					senaV4RaceRuntime.buy(v21)
				end
			end)

			task.wait(1)
		end
	end)

	genv.__SenaV4RaceRuntime = senaV4RaceRuntime

	senaV4TaskLadder.register("race", {wants = function()
		return senaV4Config.RaceAuto == true and (senaV4RaceRuntime.inRace() or senaV4RaceRuntime.wantsJoin())
	end, active = function()
		return senaV4RaceRuntime.active == true or senaV4RaceRuntime.inRace()
	end, enabled = function()
		return senaV4Config.RaceAuto == true
	end, status = function()
		return tostring(senaV4RaceRuntime.status)
	end})
end

do
	local senaV4StarRuntime = {status = "No star right now", lastResult = "No star caught yet", session = nil, busy = false, caught = 0}

	local function fn65()
		local ok, result = pcall(require, ReplicatedStorage.Shared.Remotes)
		return ok and result and result.ShootingStar or nil
	end

	local function fn66()
		return Workspace:GetServerTimeNow()
	end

	senaV4StarRuntime.position = function(arg)
		local leg = arg.Leg

		if type(leg) == "table" and (typeof(leg.From) == "Vector3" and typeof(leg.To) == "Vector3") then
			local n8 = (tonumber(leg.ArriveAt) or 0) - (tonumber(leg.StartAt) or 0)
			local n9 = n8 > 0 and math.clamp((fn66() - leg.StartAt) / n8, 0, 1) or 1
			return leg.From:Lerp(leg.To, n9)
		end

		local landing = arg.Payload.Landing
		return typeof(landing) == "CFrame" and landing.Position or landing
	end

	senaV4StarRuntime.alert = function(arg)
		if not senaV4Config.StarAlert then
			return
		end
		local n8 = math.max(0, math.floor((tonumber(arg.Payload.ExpiresAt) or 0) - fn66()))

		pcall(function()
			game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Shooting Star", Text = string.format("A star is falling! It stays for %d:%02d.", n8 // 60, n8 % 60), Duration = 8})
		end)
	end

	senaV4StarRuntime.begin = function(arg)
		if type(arg) ~= "table" then
			return
		elseif type(arg.Id) ~= "string" then
			return
		end

		if (tonumber(arg.ExpiresAt) or 0) <= fn66() then
			return
		end
		senaV4StarRuntime.session = {Payload = arg, Leg = arg.Leg, Id = arg.Id}
		senaV4StarRuntime.status = "Star falling"
		senaV4StarRuntime.alert(senaV4StarRuntime.session)
	end

	senaV4StarRuntime.finish = function(arg, lastResult)
		if senaV4StarRuntime.session and senaV4StarRuntime.session.Id == arg then
			senaV4StarRuntime.session = nil
			senaV4StarRuntime.busy = false
			senaV4StarRuntime.lastResult = lastResult
			senaV4StarRuntime.status = "No star right now"
		end
	end

	senaV4StarRuntime.catch = function(arg)
		local v21 = fn65()
		local character = localPlayer.Character
		local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")

		if not v21 or not humanoidRootPart then
			return
		elseif not humanoid then
			return
		end

		local function fn67()
			local v22 = fn2()
			return (if v22 then not senaV4Config.StarAutoCatch else not v22) or senaV4StarRuntime.session ~= arg or senaV4TaskLadder.blocker("star") ~= nil
		end

		local function fn68(arg2)
			local v22 = senaV4StarRuntime.position(arg)
			return v22 and (Vector3.new(v22.X, humanoidRootPart.Position.Y, v22.Z) - humanoidRootPart.Position).Magnitude <= arg2
		end

		local function fn69(arg2)
			local v22 = senaV4StarRuntime.position(arg)
			if not v22 then
				return false
			end

			if fn68(arg2) then
				return true
			end

			fn38(humanoidRootPart, humanoid, CFrame.new(v22 + Vector3.new(0, 3, 0)), function()
				local senaV4EggRuntime = genv.__SenaV4EggRuntime
				return fn67() or senaV4EggRuntime ~= nil and senaV4EggRuntime.resetBlocked == true
			end, false, nil, true)

			return fn68(arg2)
		end

		senaV4StarRuntime.status = "Going to the star"
		character = 0

		while true do
			local senaV4EggRuntime = fn67()
			if not (if senaV4EggRuntime then not senaV4EggRuntime else character < 25) then
				break
			end
			senaV4EggRuntime = genv.__SenaV4EggRuntime

			if senaV4EggRuntime and senaV4EggRuntime.resetBlocked then
				senaV4StarRuntime.status = "Waiting for the field to reopen"
				task.wait(0.5)
				continue
			end

			character += 1

			if fn69(8) then
				senaV4StarRuntime.status = "Catching the star"
				v21.Hold:FireServer(arg.Id, true)
				local n8 = (tonumber(arg.Payload.HoldSeconds) or 1.6) + 0.15
				local now = os.clock()
				local flag6 = false

				while os.clock() - now < n8 and not fn67() do
					local senaV4EggRuntime2 = genv.__SenaV4EggRuntime
					if senaV4EggRuntime2 and senaV4EggRuntime2.resetBlocked then
						flag6 = true
						break
					end
					local v22 = fn68(14)
					if if v22 then not v22 else not fn69(8) then
						flag6 = true
						break
					end
					task.wait(0.05)
				end

				if fn67() then
					return
				end

				if not flag6 then
					v21.Catch:FireServer(arg.Id)
					local n9 = os.clock() + 2

					while senaV4StarRuntime.session == arg and os.clock() < n9 do
						task.wait(0.1)
					end

					if senaV4StarRuntime.session ~= arg then
						return
					end
				end

				pcall(function()
					v21.Hold:FireServer(arg.Id, false)
				end)
			end

			task.wait(0.2)
		end
	end

	local v21 = fn65()

	if v21 then
		local tbl13 = {}

		local function fn67(arg, arg2)
			if arg then
				table.insert(tbl13, arg.OnClientEvent:Connect(function(...)
					if not fn2() then
						for i, v22 in ipairs(tbl13) do
							pcall(v22.Disconnect, v22)
						end

						return
					end

					pcall(arg2, ...)
				end))
			end
		end

		fn67(v21.Fall, senaV4StarRuntime.begin)

		fn67(v21.Wander, function(arg, leg)
			if senaV4StarRuntime.session and (senaV4StarRuntime.session.Id == arg and type(leg) == "table") then
				senaV4StarRuntime.session.Leg = leg
			end
		end)

		fn67(v21.Slipped, function(arg)
			if senaV4StarRuntime.session and senaV4StarRuntime.session.Id == arg then
				senaV4StarRuntime.status = "Star slipped away, trying again"
			end
		end)

		fn67(v21.Claimed, function(arg, arg2)
			if senaV4StarRuntime.session and senaV4StarRuntime.session.Id == arg then
				senaV4StarRuntime.caught = senaV4StarRuntime.caught + 1
				senaV4StarRuntime.finish(arg, string.format("Caught a star (+%s)", tostring(arg2 or 1)))
			end
		end)

		fn67(v21.Expired, function(arg)
			senaV4StarRuntime.finish(arg, "Star went home before it was caught")
		end)

		task.spawn(function()
			local ok, result = pcall(function()
				return v21.AskState:InvokeServer()
			end)

			if ok and (type(result) == "table" and senaV4StarRuntime.session == nil) then
				senaV4StarRuntime.begin(result)
			end
		end)
	end

	task.spawn(function()
		while fn2() do
			local session = senaV4StarRuntime.session

			if session and (tonumber(session.Payload.ExpiresAt) or 0) <= fn66() then
				senaV4StarRuntime.finish(session.Id, "Star went home before it was caught")
			elseif session and senaV4Config.StarAutoCatch and not senaV4StarRuntime.busy and fn66() >= (tonumber(session.Payload.LandAt) or 0) then
				local star = senaV4TaskLadder.blocker("star")

				if star then
					senaV4StarRuntime.status = "Yielding to " .. tostring(senaV4TaskLadder.TITLES[star] or star)
				else
					senaV4StarRuntime.busy = true
					pcall(senaV4StarRuntime.catch, session)
					senaV4StarRuntime.busy = false

					if senaV4StarRuntime.session == session then
						senaV4StarRuntime.status = "Star still out, retrying"
					end
				end
			elseif session then
				if fn66() < (tonumber(session.Payload.LandAt) or 0) then
					senaV4StarRuntime.status = string.format("Star lands in %ds", math.ceil((tonumber(session.Payload.LandAt) or 0) - fn66()))
				end
			end

			task.wait(0.5)
		end
	end)

	genv.__SenaV4StarRuntime = senaV4StarRuntime

	senaV4TaskLadder.register("star", {wants = function()
		local session = senaV4StarRuntime.session
		return senaV4Config.StarAutoCatch == true and session ~= nil and fn66() >= (tonumber(session.Payload.LandAt) or 0)
	end, active = function()
		return senaV4StarRuntime.busy == true
	end, enabled = function()
		return senaV4Config.StarAutoCatch == true
	end, status = function()
		return tostring(senaV4StarRuntime.status)
	end})
end

do
	local senaV4ButterflyRuntime = {status = "Idle", active = false, wantsCharacter = false, lastSwing = 0, retryAt = {}, cards = {}, snap = {}}
	local tbl13 = {"Green", "Blue", "Purple", "Golden"}
	local tbl14 = {Green = 1, Blue = 2, Purple = 3, Golden = 4}
	local n8 = 5
	local n9 = 6

	local function fn65(arg, ...)
		local tbl15 = {...}
		local v21 = arg

		for i, v22 in ipairs(tbl15) do
			if not v21 then
				return nil
			end
			v21 = v21:FindFirstChild(v22)
		end

		return v21
	end

	local v21

	local function fn66()
		local tbl15 = {}
		if v21 then
			return v21
		end

		local function fn67(arg)
			if not arg then
				return nil
			end
			local ok, result = pcall(require, arg)
			return ok and result or nil
		end

		tbl15[1] = {}
		tbl15[1].Remotes = fn67(fn65(ReplicatedStorage, "Shared", "Remotes"))
		tbl15[1].Save = fn67(fn65(ReplicatedStorage, "Shared", "Save"))
		tbl15[1].Catalog = fn67(fn65(ReplicatedStorage, "Shared", "Modules", "ButterflyCatalog"))
		tbl15[1].Flags = fn67(fn65(ReplicatedStorage, "Shared", "Flags", "ButterflyFlags"))
		tbl15[1].Quests = fn67(fn65(ReplicatedStorage, "Data", "WispQuests"))
		tbl15[1].Progress = fn67(fn65(ReplicatedStorage, "Shared", "Modules", "WispProgression"))
		tbl15[1].Swarm = fn67(fn65(ReplicatedStorage, "Controllers", "Game", "AdminAbuseClientController", "Events", "ButterflyBloom", "Swarm"))
		local v22 = tbl15[1]

		if v22.Remotes then
			if v22.Save then
				if not v22.Catalog then
					return nil
				end
			else
				return nil
			end
		else
			return nil
		end

		v21 = v22
		return v22
	end

	local function fn67(arg, arg2)
		local ok = fn66()
		local flags = ok and ok.Flags and ok.Flags[arg]
		if not flags then
			return arg2
		end

		ok, arg = pcall(function()
			return flags:Get()
		end)

		if ok then
			if arg == nil then
				return arg2
			end
		else
			return arg2
		end

		return arg
	end

	local function fn68(arg, arg2, ...)
		local v22 = fn66()
		local v23 = v22 and v22.Remotes[arg] and v22.Remotes[arg][arg2]
		if not v23 then
			return false, arg .. "." .. arg2 .. " missing"
		end
		local v24 = table.pack(pcall(v23.InvokeServer, v23, ...))
		if not v24[1] then
			return false, tostring(v24[2])
		end
		return v24[2] == true, type(v24[3]) == "string" and v24[3] or nil, v24[2]
	end

	local function fn69(arg)
		return (senaV4ButterflyRuntime.retryAt[arg] or 0) <= os.clock()
	end

	local function fn70(arg)
		senaV4ButterflyRuntime.retryAt[arg] = os.clock() + n8
	end

	local function fn71()
		local character = localPlayer.Character
		return character and character:FindFirstChild("HumanoidRootPart") or nil
	end

	senaV4ButterflyRuntime.bloomLeft = function()
		local v22 = fn66()
		local attribute = workspace:GetAttribute(v22 and v22.Catalog.EndsAtAttribute or "ButterflyBloomEndsAt")
		if typeof(attribute) ~= "number" then
			return 0
		end
		return math.max(0, attribute - workspace:GetServerTimeNow())
	end

	senaV4ButterflyRuntime.nextBloom = function()
		local n10 = tonumber(fn67("IntervalSeconds", 1800)) or 1800
		local n11 = tonumber(fn67("OffsetSeconds", 900)) or 900
		local n12 = tonumber(fn67("DurationSeconds", 300)) or 300
		if n10 <= 0 then
			return nil
		end
		local serverTimeNow = workspace:GetServerTimeNow()
		local v22 = fn66()
		local attribute = workspace:GetAttribute(v22 and v22.Catalog.EndsAtAttribute or "ButterflyBloomEndsAt")
		local n13 = typeof(attribute) == "number" and attribute - n12 or math.floor((serverTimeNow - n11) / n10) * n10 + n11
		local n14 = 0

		while n13 <= serverTimeNow and n14 < 64 do
			n13, n14 = n13 + n10, n14 + 1
		end

		return n13 > serverTimeNow and n13 - serverTimeNow or nil
	end

	local function fn72(arg)
		if not arg then
			return nil
		end

		for i, child in ipairs(arg:GetChildren()) do
			if child:IsA("Tool") and child:GetAttribute("ButterflyNet") == true then
				return child
			end
		end

		return nil
	end

	local v22

	senaV4ButterflyRuntime.tiers = function()
		if v22 then
			return v22
		end
		local v23 = fn66()
		if not v23 then
			return nil
		end
		local tbl15 = {}

		for i, v24 in ipairs(tbl13) do
			local tiers = v23.Catalog.Tiers and v23.Catalog.Tiers[v24]
			tbl15[v24] = {name = (tiers and tostring(tiers.DisplayName) or v24):gsub("%s*Butterfly$", ""), color = tiers and typeof(tiers.Color) == "Color3" and tiers.Color or Color3.new(1, 1, 1), icon = tiers and tiers.Icon and tostring(tiers.Icon) or nil, rarity = tiers and tiers.Rarity and tostring(tiers.Rarity) or nil, trade = i < 4 and (tonumber(fn67(("%sTo%sCost"):format(v24, tbl13[i + 1]), 0)) or 0) or 0, essence = tonumber(fn67("Essence" .. v24, 0)) or 0}
		end

		v22 = tbl15
		return tbl15
	end

	senaV4ButterflyRuntime.snapshot = function()
		local v23 = fn66()
		local snap = senaV4ButterflyRuntime.snap
		if not v23 then
			return snap
		end
		snap.left = senaV4ButterflyRuntime.bloomLeft()
		snap.active = snap.left > 0
		snap.enabled = fn67("Enabled", true) ~= false
		local active = snap.active
		snap.nextIn = (if active then not active else senaV4ButterflyRuntime.nextBloom()) or nil
		local ok, result = pcall(v23.Save.Peek)
		local v24 = ok and result or nil
		local butterflies = v24 and v24.Butterflies
		snap.net = type(butterflies) == "table" and butterflies.NetClaimed == true
		snap.holding = fn72(localPlayer.Character) ~= nil
		snap.inBag = fn72(localPlayer:FindFirstChildOfClass("Backpack")) ~= nil
		snap.counts = snap.counts or {}

		for i, v25 in ipairs(tbl13) do
			snap.counts[v25] = type(butterflies) == "table" and butterflies.Counts and tonumber(butterflies.Counts[v25]) or 0
		end

		snap.essence = type(butterflies) == "table" and tonumber(butterflies.Essence) or 0
		snap.caught = type(butterflies) == "table" and tonumber(butterflies.TotalCaught) or 0
		snap.treeUnlocked = localPlayer:GetAttribute("EnchantedTreeUnlocked") == true
		local wispCompanion = v24 and v24.WispCompanion
		snap.accepted = type(wispCompanion) == "table" and wispCompanion.Accepted == true
		snap.unlocked = type(wispCompanion) == "table" and wispCompanion.Unlocked == true
		snap.returning = type(wispCompanion) == "table" and wispCompanion.Returning == true
		snap.stage = type(wispCompanion) == "table" and tonumber(wispCompanion.Stage) or 1
		snap.stages = v23.Quests and tonumber(v23.Quests.StageCount) or 4
		local v25 = (v23.Quests and v23.Quests.List or {})[snap.stage]
		snap.questId = v25 and tostring(v25.Id) or nil
		snap.quest = v25 and tostring(v25.Title) or "-"
		snap.target = v25 and tonumber(v25.Target) or 0
		snap.progress = v25 and type(wispCompanion) == "table" and wispCompanion.Progress and tonumber(wispCompanion.Progress[v25.Id]) or 0
		snap.claimable = false
		snap.readyReturn = false

		if v23.Progress and type(wispCompanion) == "table" then
			local ok2, result2 = pcall(v23.Progress.HasClaimable, wispCompanion)
			snap.claimable = ok2 and result2 == true
			result2, ok2 = pcall(v23.Progress.IsReady, wispCompanion)
			snap.readyReturn = result2 and ok2 == true
		end

		snap.speed = v24 and tonumber(v24.SpeedPower) or 0
		local banjoCricket = v24 and v24.BanjoCricket
		snap.banjoSolved = type(banjoCricket) == "table" and banjoCricket.Solved == true
		snap.banjoClaimed = type(banjoCricket) == "table" and banjoCricket.Claimed == true
		snap.need = v23.Quests and tonumber(v23.Quests.RequiredSpeedPower) or 0
		return snap
	end

	senaV4ButterflyRuntime.smartNext = function(arg)
		local v23 = senaV4ButterflyRuntime.tiers()

		if v23 then
			if not arg then
				return nil
			end
		else
			return nil
		end

		for i = 3, 1, -1 do
			local v24 = tbl13[i]
			local v25 = tbl13[i + 1]
			local trade = v23[v24].trade
			if trade > 0 and ((arg[v25] or 0) < v23[v25].essence and (arg[v24] or 0) - v23[v24].essence >= trade) then
				return v24
			end
		end

		return nil
	end

	senaV4ButterflyRuntime.canTrade = function()
		local snap = senaV4ButterflyRuntime.snap
		local v23 = senaV4ButterflyRuntime.tiers()

		if v23 then
			if not snap.counts then
				return false
			end
		else
			return false
		end

		local butterflyTradeRecipe = senaV4Config.ButterflyTradeRecipe
		if butterflyTradeRecipe == "Smart" then
			return senaV4ButterflyRuntime.smartNext(snap.counts) ~= nil
		end

		for i = 1, 3, 1 do
			local v24 = tbl13[i]
			if (butterflyTradeRecipe == nil or butterflyTradeRecipe == "All" or butterflyTradeRecipe == v24) and (v23[v24].trade > 0 and (snap.counts[v24] or 0) >= v23[v24].trade) then
				return true
			end
		end

		return false
	end

	senaV4ButterflyRuntime.canCraft = function()
		local snap = senaV4ButterflyRuntime.snap
		local v23 = senaV4ButterflyRuntime.tiers()

		if v23 then
			if not snap.counts then
				return false
			end
		else
			return false
		end

		for i, v24 in ipairs(tbl13) do
			if v23[v24].essence > 0 and (snap.counts[v24] or 0) < v23[v24].essence then
				return false, v24
			end
		end

		return true
	end

	local function fn73()
		local butterflyTiers = senaV4Config.ButterflyTiers

		if type(butterflyTiers) ~= "table" then
			return nil
		elseif #butterflyTiers == 0 then
			return nil
		end

		local tbl15 = {}

		for i, butterflyTier in ipairs(butterflyTiers) do
			tbl15[tostring(butterflyTier)] = true
		end

		return tbl15
	end

	local function fn74()
		local butterflyBloomSwarm = workspace:FindFirstChild("ButterflyBloomSwarm")
		if not butterflyBloomSwarm then
			return {}
		end
		local tbl15 = {}

		for i, child in ipairs(butterflyBloomSwarm:GetChildren()) do
			if tbl14[child.Name] and child:IsA("Model") then
				local position = child.PrimaryPart and child.PrimaryPart.Position or child:GetPivot().Position
				tbl15[#tbl15 + 1] = {pos = position, tier = child.Name}
			end
		end

		return tbl15
	end

	local function fn75()
		local character = localPlayer.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		local v23 = fn72(localPlayer:FindFirstChildOfClass("Backpack"))
		if not (humanoid and v23) then
			return false
		end

		pcall(function()
			humanoid:EquipTool(v23)
		end)

		return fn72(character) ~= nil
	end

	local tbl15 = {part = nil, y = 0}

	local function fn76()
		if tbl15.part then
			pcall(function()
				tbl15.part:Destroy()
			end)
		end

		tbl15.part = nil
	end

	local function fn77()
		local v23 = fn71()
		if not v23 then
			return
		end

		if not (tbl15.part and tbl15.part.Parent) then
			local part = Instance.new("Part")
			part.Name = "SenaBloomPad"
			part.Anchored = true
			part.CanCollide = true
			part.CanTouch = false
			part.CastShadow = false
			part.Transparency = 1
			part.Size = Vector3.new(24, 1, 24)
			tbl15.y = v23.Position.Y - 3.5
			part.CFrame = CFrame.new(v23.Position.X, tbl15.y, v23.Position.Z)
			part.Parent = workspace
			tbl15.part = part
		end

		local raycastParams = RaycastParams.new()
		raycastParams.FilterType = Enum.RaycastFilterType.Exclude
		raycastParams.FilterDescendantsInstances = {localPlayer.Character, tbl15.part}
		local hit = workspace:Raycast(v23.Position + Vector3.new(0, 4, 0), Vector3.new(0, -80, 0), raycastParams)
		if not hit then
			return
		end
		tbl15.y = tbl15.y + math.clamp(hit.Position.Y - 0.5 + n9 - tbl15.y, -2, 2)
		tbl15.part.CFrame = CFrame.new(v23.Position.X, tbl15.y, v23.Position.Z)
	end

	local function fn78(arg, arg2)
		local character = localPlayer.Character
		local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")

		if humanoidRootPart then
			if not humanoid then
				return false
			end
		else
			return false
		end

		fn76()
		local n10 = os.clock() + (arg2 or 30)

		local function fn79()
			if fn2() then
				if os.clock() > n10 then
					return true
				end
			else
				return true
			end

			return senaV4TaskLadder.blocker("butterfly") ~= nil
		end

		if v13 and (humanoidRootPart.Position.Y < 16000 and (arg.Y < 16000 and (humanoidRootPart.Position - arg).Magnitude > 600)) then
			if v13:_isInSafeArea(humanoidRootPart) then
			else
				local v23 = v13:_resolveSafeCFrame(humanoidRootPart)

				if v23 and (v23.Position - arg).Magnitude > 40 then
					local status = senaV4ButterflyRuntime.status
					senaV4ButterflyRuntime.status = "Heading to the safe zone first"
					pcall(fn38, humanoidRootPart, humanoid, v23, fn79)
					senaV4ButterflyRuntime.status = status
					local v24 = fn71()

					if v24 then
						if fn79() then
							return false
						elseif not v13:_isInSafeArea(v24) then
							return false
						end
					else
						return false
					end

					humanoidRootPart = v24
				end
			end
		end

		pcall(fn38, humanoidRootPart, humanoid, CFrame.new(arg) * humanoidRootPart.CFrame.Rotation, fn79)
		local v23 = fn71()
		return v23 ~= nil and (v23.Position - arg).Magnitude <= 12
	end

	local function fn79()
		if localPlayer:GetAttribute("InEnchantedTree") == true then
			return true
		end
		local v23 = fn71()
		return v23 ~= nil and v23.Position.Y > 16000
	end

	local function fn80(arg)
		if arg and arg:IsA("ProximityPrompt") then
			if not arg.Enabled then
				return false
			end
		else
			return false
		end

		local n10 = tonumber(arg.HoldDuration) or 0

		pcall(function()
			arg:InputHoldBegin()
			task.wait(n10 > 0 and n10 + 0.15 or 0.05)
			arg:InputHoldEnd()
		end)

		if typeof(fireproximityprompt) == "function" then
			pcall(fireproximityprompt, arg, n10 > 0 and n10 + 0.15 or 0)
		end

		return true
	end

	local enchantedTreePrompt

	local function fn81()
		if fn79() then
			return nil
		end

		if localPlayer:GetAttribute("EnchantedTreeUnlocked") ~= true then
			return "Enchanted Tree is locked (finish the Wisp Event)"
		end

		if not (enchantedTreePrompt and enchantedTreePrompt.Parent) then
			local world = fn65(workspace, "World", "Build", "EnchantedTreeInterior", "Markers", "EnterTrigger")
			enchantedTreePrompt = world and world:FindFirstChild("EnchantedTreePrompt", true) or nil
		end

		local parent = enchantedTreePrompt and enchantedTreePrompt.Parent
		local worldPosition = parent and (parent:IsA("Attachment") and parent.WorldPosition or parent:IsA("BasePart") and parent.Position)
		if not worldPosition then
			return "tree entrance not found"
		end

		if fn31() then
			return "night - the forest is sealed"
		end
		senaV4ButterflyRuntime.status = "Flying to the Enchanted Tree"
		if not fn78(worldPosition + Vector3.new(0, 3, 0), 60) then
			return "could not reach the tree entrance"
		end
		senaV4ButterflyRuntime.status = "Entering the tree"
		fn80(enchantedTreePrompt)
		local n10 = os.clock() + 8

		while os.clock() < n10 and not fn79() do
			task.wait(0.05)
		end

		if fn79() then
			return nil
		end
		return "entering the tree failed"
	end

	local function fn82()
		if not fn79() then
			return true
		end
		local world = fn65(workspace, "World", "Build", "EnchantedTreeInterior", "Markers", "ExitTrigger")

		if world then
			if not (typeof(firetouchinterest) == "function") then
				return false
			end
		else
			return false
		end

		senaV4ButterflyRuntime.status = "Leaving the tree"
		local n10 = os.clock() + 6

		while os.clock() < n10 and fn79() do
			local v23 = fn71()

			if v23 then
				pcall(firetouchinterest, v23, world, 0)
				pcall(firetouchinterest, v23, world, 1)
			end

			task.wait(0.3)
		end

		return not fn79()
	end

	local function fn83(arg)
		local world = fn65(workspace, "World", "Machines", "ButterflyStation", arg, "Anchor")
		return world and world:IsA("BasePart") and world.Position or nil, world
	end

	local function fn84(arg)
		local v23 = fn83(arg)
		if not v23 then
			return false, arg .. " not found"
		end
		local v24 = fn71()
		if v24 and (v24.Position - v23).Magnitude <= 10 then
			return true
		end
		local v25 = fn81()
		if v25 then
			return false, v25
		end
		senaV4ButterflyRuntime.status = "Walking to the " .. arg
		if not fn78(v23 + Vector3.new(0, 3, 0), 15) then
			return false, "could not reach the " .. arg
		end
		return true
	end

	local function fn85()
		local world = fn65(workspace, "World", "Areas", "ButterflyBloom", "Bounds")
		return world and world:IsA("BasePart") and world or nil
	end

	local function fn86()
		local v23 = fn85()
		local v24 = fn71()

		if v23 then
			if v24 then
				if fn79() then
					return false
				end
			else
				return false
			end
		else
			return false
		end

		local v25 = v23.CFrame:PointToObjectSpace(v24.Position)
		return math.abs(v25.X) <= v23.Size.X / 2 + 20 and math.abs(v25.Z) <= v23.Size.Z / 2 + 20
	end

	local function fn87()
		local v23 = fn85()
		return v23 and v23.Position + Vector3.new(0, 4, 0) or nil
	end

	local function fn88()
		local senaV4TreadmillManager = genv.__SenaV4TreadmillManager

		if senaV4TreadmillManager then
			if not (senaV4TreadmillManager.activeTreadmill ~= nil) then
				return
			end
		else
			return
		end

		senaV4ButterflyRuntime.status = "Leaving the treadmill"
		local n10 = os.clock() + 5

		while senaV4TreadmillManager.activeTreadmill ~= nil and os.clock() < n10 do
			senaV4TreadmillManager:_requestUnequip()
			task.wait(0.3)
		end

		local v23 = fn71()

		if v23 and v23.Anchored then
			pcall(function()
				v23.Anchored = false
			end)
		end
	end

	local function fn89()
		local senaV4TreadmillManager = genv.__SenaV4TreadmillManager

		if senaV4TreadmillManager and not senaV4TreadmillManager.destroyed then
			if not senaV4TreadmillManager.config.idleFarm then
				return false
			end
		else
			return false
		end

		if not senaV4TreadmillManager.busy and not senaV4TreadmillManager.idleRunning then
			task.defer(function()
				senaV4TreadmillManager:_startIdle()
			end)
		end

		return true
	end

	local function fn90()
		fn76()

		if fn79() then
			fn82()
		end

		if fn89() then
			return
		end
		local v23 = fn71()

		if v23 then
			if v13 then
				if v13:_isInSafeArea(v23) then
					return
				end
			else
				return
			end
		else
			return
		end

		local v24 = v13:_resolveSafeCFrame(v23)

		if v24 then
			senaV4ButterflyRuntime.status = "Back to the safe zone"
			fn78(v24.Position, 60)
		end
	end

	senaV4ButterflyRuntime.claimNet = function()
		local NetStand, v23 = fn84("NetStand")
		if not NetStand then
			return false, v23
		end
		senaV4ButterflyRuntime.status = "Claiming the net"
		NetStand, v23 = fn83("NetStand")
		local proximityPrompt = v23 and v23:FindFirstChildWhichIsA("ProximityPrompt", true)

		if proximityPrompt and proximityPrompt.Enabled then
			fn80(proximityPrompt)
			local n10 = os.clock() + 2

			while os.clock() < n10 do
				if senaV4ButterflyRuntime.snapshot().net then
					return true
				end
				task.wait(0.1)
			end
		end

		proximityPrompt, v23 = fn68("Butterflies", "AskClaimNet")
		return proximityPrompt, v23
	end

	senaV4ButterflyRuntime.tradeUp = function()
		senaV4ButterflyRuntime.snapshot()
		if not senaV4ButterflyRuntime.canTrade() then
			return false, "nothing to trade up"
		end
		local ButterflyMachine, v23 = fn84("ButterflyMachine")
		if not ButterflyMachine then
			return false, v23
		end
		local v24, butterflyTradeRecipe, n10, v25 = senaV4ButterflyRuntime.tiers(), senaV4Config.ButterflyTradeRecipe, 0

		if butterflyTradeRecipe == "Smart" then
			local v26 = table.clone(senaV4ButterflyRuntime.snap.counts)
			v25 = n10

			while v25 < 50 do
				local v27 = senaV4ButterflyRuntime.smartNext(v26)
				if not v27 then
					break
				end
				senaV4ButterflyRuntime.status = "Trading up " .. v24[v27].name .. " for the essence"
				local Butterflies, v28 = fn68("Butterflies", "AskTradeUp", v27)

				if not Butterflies then
					if v25 == 0 then
						return false, v28 or "the machine refused"
					end
					break
				end

				v25 += 1
				v26[v27] = (v26[v27] or 0) - v24[v27].trade
				local v29 = tbl13[tbl14[v27] + 1]
				v26[v29] = (v26[v29] or 0) + 1
				task.wait(0.12)
			end

			return true, v25
		end

		v25 = n10

		for i = 3, 1, -1 do
			local v26 = tbl13[i]

			if butterflyTradeRecipe == nil or butterflyTradeRecipe == "All" or butterflyTradeRecipe == v26 then
				n10 = senaV4ButterflyRuntime.snap.counts[v26] or 0
				local trade = v24[v26].trade

				while trade > 0 and n10 >= trade do
					senaV4ButterflyRuntime.status = "Trading up " .. v24[v26].name
					local Butterflies, v27 = fn68("Butterflies", "AskTradeUp", v26)

					if not Butterflies then
						if v25 == 0 then
							return false, v27 or "the machine refused"
						end
						break
					end

					v25 += 1
					n10 -= trade
					task.wait(0.12)
				end
			end
		end

		return true, v25
	end

	senaV4ButterflyRuntime.craft = function()
		senaV4ButterflyRuntime.snapshot()
		local v23, MutationShrine = senaV4ButterflyRuntime.canCraft()
		if not v23 then
			local v24 = senaV4ButterflyRuntime.tiers()
			return false, "need more " .. tostring(v24 and v24[MutationShrine] and v24[MutationShrine].name or MutationShrine)
		end
		MutationShrine, v23 = fn84("MutationShrine")
		if not MutationShrine then
			return false, v23
		end
		MutationShrine = 0

		while MutationShrine < 10 and senaV4ButterflyRuntime.canCraft() do
			senaV4ButterflyRuntime.status = "Crafting Enchanted Essence"
			local Butterflies, v24 = fn68("Butterflies", "AskCraftEssence")

			if not Butterflies then
				if MutationShrine == 0 then
					return false, v24 or "the shrine refused"
				end
				return true, MutationShrine
			end

			MutationShrine += 1
			task.wait(0.2)
			senaV4ButterflyRuntime.snapshot()
		end

		return true, MutationShrine
	end

	senaV4ButterflyRuntime.acceptWisp = function()
		local world = fn65(workspace, "World", "Build", "EnchantedForestZone", "WispSpawn")

		if world then
			if not world:IsA("BasePart") then
				return false, "Baby Wisp spot not found"
			end
		else
			return false, "Baby Wisp spot not found"
		end

		if fn31() then
			return false, "night - the forest is sealed"
		end
		senaV4ButterflyRuntime.status = "Flying to the Baby Wisp"
		if not fn78(world.Position + Vector3.new(0, 3, 6), 60) then
			return false, "could not reach the Baby Wisp"
		end
		task.wait(0.3)
		local WispCompanion, v23 = fn68("WispCompanion", "Request", "Accept")

		if WispCompanion then
			pcall(fn68, "WispCompanion", "Request", "Open")
		end

		return WispCompanion, v23
	end

	senaV4ButterflyRuntime.forestCategories = function()
		if senaV4ButterflyRuntime.forestCats then
			return senaV4ButterflyRuntime.forestCats
		end
		local forestCats = {}

		pcall(function()
			local enchantedForest = require(ReplicatedStorage.Data.Areas).Directory["Enchanted Forest"]

			for i, v23 in ipairs(enchantedForest and enchantedForest.DropTable or {}) do
				if type(v23) == "table" and type(v23[1]) == "string" then
					forestCats[v23[1]] = true
				end
			end
		end)

		if next(forestCats) then
			senaV4ButterflyRuntime.forestCats = forestCats
		end

		return forestCats
	end

	senaV4ButterflyRuntime.forestStock = function()
		local v23 = fn66()

		local ok, result = pcall(function()
			return v23.Save.Peek()
		end)

		local v24 = ok and result or nil
		local v25 = senaV4ButterflyRuntime.forestCategories()
		local tbl16 = {eggs = 0, pets = 0, group = nil, best = 0}
		if not v24 then
			return tbl16
		end

		for k, v26 in pairs(v24.EggInventory or {}) do
			if type(v26) == "table" and (v25[v26.AssetCategory] and v26.Placement == nil) then
				tbl16.eggs = tbl16.eggs + 1
			end
		end

		local ok2, result2 = pcall(require, ReplicatedStorage.Shared.Util.AssetItems)
		local tbl17 = {}

		for i, v26 in ipairs(v24.EquippedAssets or {}) do
			tbl17[v26] = true
		end

		local tbl18 = {}

		for k, v26 in pairs(v24.Inventory or {}) do
			local v27

			if ok2 then
				if result2 then
					if type(result2.Decode) == "function" then
						local ok3, result3 = pcall(result2.Decode, v26)
						v27 = if ok3 then if type(result3) == "table" then result3 else v26 else v26
					else
						v27 = v26
					end
				else
					v27 = v26
				end
			else
				v27 = v26
			end

			if type(v27) == "table" and v25[v27.Category] then
				tbl16.pets = tbl16.pets + 1

				if not tbl17[k] and (not v27.InFuse and not v27.IsFavorite) then
					local tbl19 = tbl18[v27.Category] or {}
					tbl18[v27.Category] = tbl19
					tbl19[#tbl19 + 1] = k

					if #tbl19 > tbl16.best then
						tbl16.best = #tbl19
					end

					if #tbl19 >= 3 and not tbl16.group then
						tbl16.group = {tbl19[1], tbl19[2], tbl19[3]}
					end
				end
			end
		end

		return tbl16
	end

	senaV4ButterflyRuntime.fuseForest = function(arg)
		local ok = fn66()
		local ok2, result = pcall(ok.Save.Peek)
		if ok2 and (result and result.FusionLocked) then
			return false, "the Fusery is busy"
		end
		local fusery = ok.Remotes and ok.Remotes.Fusery
		if not fusery then
			return false, "Fusery missing"
		end

		pcall(function()
			fusery.ConfirmBriefing:InvokeServer()
		end)

		for i, v23 in ipairs(arg) do
			result, ok2 = pcall(function()
				return fusery.LoadPet:InvokeServer(v23)
			end)

			if result then
				if not ok2 then
					return false, "could not load a pet into the Fusery"
				end
			else
				return false, "could not load a pet into the Fusery"
			end

			task.wait(0.02)
		end

		ok, arg = pcall(function()
			return fusery.BeginFuse:InvokeServer()
		end)

		if ok then
			if not arg then
				return false, "could not start the fuse"
			end
		else
			return false, "could not start the fuse"
		end

		task.wait(0.06)

		pcall(function()
			fusery.FinishReveal:InvokeServer()
		end)

		return true
	end

	senaV4ButterflyRuntime.questDrive = function(arg)
		local senaV4EggRuntime, tbl16, questNote = genv.__SenaV4EggRuntime
		local flag6 = senaV4Config.WispAutoQuest and arg.accepted and not arg.unlocked and not arg.claimable and not arg.readyReturn and (arg.progress or 0) < (arg.target or 0)

		if senaV4Config.WispAutoQuest and not arg.accepted and not arg.unlocked and (arg.speed or 0) < (arg.need or 0) then
			questNote = ("Wisp needs %gB SpeedPower"):format(math.floor((arg.need or 0) / 100000000) / 10)
		else
			if flag6 and arg.questId == "forest_eggs" then
				tbl16 = {area = "Enchanted Forest"}
				questNote = ("Hunting Enchanted Forest eggs  \194\183  %d / %d"):format(arg.progress or 0, arg.target or 0)
			else
				if flag6 and arg.questId == "eternal_egg" then
					tbl16 = {rarity = "Eternal"}
					questNote = "Hunting any Eternal egg"
				else
					if flag6 and arg.questId == "forest_fusion" then
						local v23 = senaV4ButterflyRuntime.forestStock()
						local str3

						if v23.group then
							local str4 = "Fusing 3 Enchanted Forest pets"

							if fn69("fuse") then
								local v24, v25 = senaV4ButterflyRuntime.fuseForest(v23.group)
								questNote = v24 and "Fused an Enchanted Forest animal" or "Fuse: " .. tostring(v25)
								fn70("fuse")
							else
								questNote = str4
							end
						else
							tbl16, str3 = if v23.eggs < 3 then {area = "Enchanted Forest"} else tbl16, ("Need 3 of one Enchanted Forest pet (best %d)%s"):format(v23.best, senaV4Config.AutoPlace and senaV4Config.AutoHatch and "" or "  \194\183  turn on Auto Place + Auto Hatch")
							questNote = str3
						end
					end
				end
			end
		end

		if senaV4EggRuntime and senaV4EggRuntime.setWispObjective then
			senaV4EggRuntime:setWispObjective(tbl16)
		end

		senaV4ButterflyRuntime.questNote = questNote
	end

	senaV4ButterflyRuntime.promptPoint = function(arg)
		local parent = arg and arg.Parent
		if not parent then
			return nil
		end

		if parent:IsA("Attachment") then
			return parent.WorldPosition
		end

		if parent:IsA("BasePart") then
			return parent.Position
		end

		if parent:IsA("Model") then
			return parent:GetPivot().Position
		end
		return nil
	end

	senaV4ButterflyRuntime.banjoPrompt = function(arg)
		local world = fn65(workspace, "World", "Build", "EnchantedTreeInterior", "Banjo Secret Room")
		if not world then
			return nil
		end

		for i, descendant in ipairs(world:GetDescendants()) do
			if descendant:IsA("ProximityPrompt") then
				local model = descendant:FindFirstAncestorWhichIsA("Model")

				if descendant.Name == arg then
					return descendant
				elseif model then
					if model.Name == arg then
						return descendant
					end
				end
			end
		end

		return nil
	end

	senaV4ButterflyRuntime.firePrompt = function(arg)
		local v23 = senaV4ButterflyRuntime.promptPoint(arg)
		if not v23 then
			return false
		end
		local v24 = fn71()

		if v24 and (v24.Position - v23).Magnitude > math.max((tonumber(arg.MaxActivationDistance) or 10) - 2, 4) then
			fn78(v23 + Vector3.new(0, 2, 3), 20)
		end

		local enabled = arg.Enabled
		arg.Enabled = true
		fn80(arg)

		if not enabled then
			pcall(function()
				arg.Enabled = false
			end)
		end

		return true
	end

	senaV4ButterflyRuntime.solveBanjo = function()
		local v23 = fn66()
		local banjoCricket = v23.Remotes and v23.Remotes.BanjoCricket

		if banjoCricket then
			if banjoCricket.Effect then
				if not banjoCricket.Aim then
					return false, "Banjo remotes missing"
				end
			else
				return false, "Banjo remotes missing"
			end
		else
			return false, "Banjo remotes missing"
		end

		local BanjoCricketTalk = senaV4ButterflyRuntime.banjoPrompt("BanjoCricketTalk") or senaV4ButterflyRuntime.banjoPrompt("BanjoCricket")
		if not BanjoCricketTalk then
			return false, "Banjo Cricket not found"
		end
		local n10 = 0.45
		local n11 = 0.2

		pcall(function()
			local timing = require(ReplicatedStorage.Data.BanjoCricket).Timing
			n10 = tonumber(timing.Note) or n10
			n11 = tonumber(timing.NoteGap) or n11
		end)

		local tbl16 = {notes = nil, cleared = 0, solved = false}
		local effect = banjoCricket.Effect

		local function fn91(arg)
			if type(arg) ~= "table" then
				return
			end

			if arg.Kind == "Playback" and type(arg.Notes) == "table" then
				tbl16.notes = arg.Notes
			elseif arg.Kind == "StageComplete" then
				tbl16.cleared = tonumber(arg.Cleared) or tbl16.cleared + 1
			elseif arg.Kind == "Solved" then
				tbl16.solved = true
			elseif arg.Kind == "Wrong" then
				tbl16.cleared = 0
			elseif arg.Kind == "Reset" then
				tbl16.cleared = 0
			end
		end

		local connection6 = effect.OnClientEvent:Connect(fn91)
		senaV4ButterflyRuntime.status = "Talking to the Banjo Cricket"
		senaV4ButterflyRuntime.firePrompt(BanjoCricketTalk)
		local n12 = os.clock() + 150
		effect = os.clock()

		while fn2() and senaV4Config.BanjoAuto and os.clock() < n12 and not tbl16.solved do
			if senaV4ButterflyRuntime.manual then
				break
			elseif senaV4TaskLadder.blocker("butterfly") ~= nil then
				break
			end

			if senaV4ButterflyRuntime.snapshot().banjoSolved then
				tbl16.solved = true
				break
			end
			local notes = tbl16.notes

			if notes then
				tbl16.notes = nil
				senaV4ButterflyRuntime.status = ("Banjo Cricket  \194\183  stage %d  \194\183  %d notes"):format(tbl16.cleared + 1, #notes)
				task.wait(#notes * (n10 + n11) + 0.3)

				for i, note in ipairs(notes) do
					if tbl16.notes then
						break
					end

					if not senaV4ButterflyRuntime.hitMushroom(note, banjoCricket) then
						tbl16.err = "equip a bat first (the mushrooms only take bat hits)"
						break
					end
				end

				if tbl16.err then
					break
				end
				effect = os.clock()
			else
				if os.clock() - effect > 8 then
					senaV4ButterflyRuntime.firePrompt(BanjoCricketTalk)
					effect = os.clock()
				end
			end

			task.wait(0.1)
		end

		connection6:Disconnect()
		return tbl16.solved, tbl16.solved and nil or (tbl16.err or "the cricket stopped playing")
	end

	senaV4ButterflyRuntime.hitMushroom = function(arg, arg2)
		local v23 = fn71()
		local character = localPlayer.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")

		if v23 then
			if not humanoid then
				return false
			end
		else
			return false
		end

		local vector2, n10, v24 = Vector3.new(0, 0, 0), 0

		for i, v25 in ipairs(game:GetService("CollectionService"):GetTagged("BanjoCricketMushroom")) do
			local attribute = v25:IsA("Model") and v25:IsDescendantOf(workspace) and v25:GetAttribute("MushroomIndex")
			character = typeof(attribute) == "number" and (v25:FindFirstChild("Hitbox") or v25.PrimaryPart)

			if character and character:IsA("BasePart") then
				vector2, n10, v24 = vector2 + character.Position, n10 + 1, if attribute == arg then character else v24
			end
		end

		if not v24 then
			return false
		end
		local senaV4GodMode = genv.__SenaV4GodMode
		local v25 = senaV4GodMode and senaV4GodMode:_equipBat()
		if not v25 then
			return false
		end
		character = (vector2 / n10 - v24.Position) * Vector3.new(1, 0, 1)
		local v26 = if character.Magnitude < 0.5 then Vector3.new(0, 0, 1) else character
		local n11 = v24.Position + v26.Unit * 7
		local vector3 = Vector3.new(n11.X, v23.Position.Y, n11.Z)
		local vector4 = Vector3.new(v24.Position.X, vector3.Y, v24.Position.Z)

		if (v23.Position - vector3).Magnitude > 3 then
			pcall(fn38, v23, humanoid, CFrame.lookAt(vector3, vector4), function()
				return not fn2()
			end)

			v23 = fn71()
			if not v23 then
				return false
			end
		end

		v23.CFrame = CFrame.lookAt(v23.Position, Vector3.new(vector4.X, v23.Position.Y, vector4.Z))
		task.wait(0.08)
		pcall(arg2.Aim.FireServer, arg2.Aim, arg)
		local n12 = os.clock() + 1.5

		while os.clock() < n12 do
			local attribute = v25:GetAttribute("CooldownEndTime")
			if not (v25:GetAttribute("CooldownActive") == true and typeof(attribute) == "number" and workspace:GetServerTimeNow() < attribute) and os.clock() - (senaV4ButterflyRuntime.lastMushroomHit or 0) >= 0.75 then
				break
			end
			task.wait(0.05)
		end

		senaV4ButterflyRuntime.lastMushroomHit = os.clock()

		pcall(function()
			v25:Activate()
		end)

		task.wait(0.15)
		return true
	end

	senaV4ButterflyRuntime.claimBanjo = function()
		local Jitterbug = senaV4ButterflyRuntime.banjoPrompt("Jitterbug")

		if Jitterbug then
			senaV4ButterflyRuntime.status = "Talking to Jitterbug"
			senaV4ButterflyRuntime.firePrompt(Jitterbug)
			task.wait(0.6)
		end

		local BanjoCricket, v23 = fn68("BanjoCricket", "AskClaim")
		task.wait(0.4)
		return BanjoCricket or senaV4ButterflyRuntime.snapshot().banjoClaimed, v23
	end

	senaV4ButterflyRuntime.runBanjo = function()
		local v23 = senaV4ButterflyRuntime.snapshot()
		if v23.banjoClaimed then
			return true
		end

		if not fn79() then
			local v24 = fn81()
			if v24 then
				return false, v24
			end
		end

		if not v23.banjoSolved then
			local v24, v25 = senaV4ButterflyRuntime.solveBanjo()
			if not v24 then
				return false, v25
			end
			task.wait(senaV4ButterflyRuntime.bridgeSeconds or 3.5)
		end

		return senaV4ButterflyRuntime.claimBanjo()
	end

	senaV4ButterflyRuntime.returnWisp = function()
		local v23 = senaV4ButterflyRuntime.snapshot()
		if v23.unlocked then
			return true
		end

		if not v23.returning then
			if not v23.readyReturn then
				return false, "finish every Wisp quest first"
			end
			local WispCompanion, v24 = fn68("WispCompanion", "Request", "BeginReturn")
			if not WispCompanion then
				return false, v24 or "the wisp is not ready"
			end
		end

		local world = fn65(workspace, "World", "Build", "EnchantedForestZone", "Zone13Props", "EnchantedTree", "WispAnchor", "WispTreePrompt")

		if world and world:IsA("ProximityPrompt") then
			local parent = world.Parent
			local worldPosition = parent and (parent:IsA("Attachment") and parent.WorldPosition or parent:IsA("BasePart") and parent.Position)

			if worldPosition then
				senaV4ButterflyRuntime.status = "Taking the wisp home"

				if fn78(worldPosition + Vector3.new(0, 3, 4), 60) then
					local n10 = os.clock() + 2

					while os.clock() < n10 and not world.Enabled do
						task.wait(0.1)
					end

					fn80(world)
					local n11 = os.clock() + 3

					while os.clock() < n11 and not senaV4ButterflyRuntime.snapshot().unlocked do
						task.wait(0.1)
					end

					if senaV4ButterflyRuntime.snap.unlocked then
						return true
					end
				end
			end
		end

		if not (enchantedTreePrompt and enchantedTreePrompt.Parent) then
			local world2 = fn65(workspace, "World", "Build", "EnchantedTreeInterior", "Markers", "EnterTrigger")
			enchantedTreePrompt = world2 and world2:FindFirstChild("EnchantedTreePrompt", true) or nil
		end

		local parent = enchantedTreePrompt and enchantedTreePrompt.Parent
		local worldPosition = parent and (parent:IsA("Attachment") and parent.WorldPosition or parent:IsA("BasePart") and parent.Position)
		if not worldPosition then
			return false, "tree entrance not found"
		end
		senaV4ButterflyRuntime.status = "Taking the wisp home"
		if not fn78(worldPosition + Vector3.new(0, 3, 0), 60) then
			return false, "could not reach the tree entrance"
		end
		fn80(enchantedTreePrompt)
		local n10 = os.clock() + 3

		while os.clock() < n10 and not senaV4ButterflyRuntime.snapshot().unlocked do
			task.wait(0.1)
		end

		if senaV4ButterflyRuntime.snap.unlocked then
			return true
		end
		local WispCompanion, v24 = fn68("WispCompanion", "Request", "Return")
		task.wait(0.5)
		return WispCompanion or senaV4ButterflyRuntime.snapshot().unlocked, v24
	end

	senaV4ButterflyRuntime.tierOptions = function()
		local v23 = senaV4ButterflyRuntime.tiers()
		local tbl16 = {}

		for i = #tbl13, 1, -1 do
			local v24 = tbl13[i]
			tbl16[#tbl16 + 1] = v23 and v23[v24].name or v24
		end

		return tbl16
	end

	senaV4ButterflyRuntime.tierFromLabel = function(arg)
		local v23 = senaV4ButterflyRuntime.tiers()

		for i, v24 in ipairs(tbl13) do
			if arg == v24 then
				return v24
			elseif v23 then
				if v23[v24].name == arg then
					return v24
				end
			end
		end

		return nil
	end

	senaV4ButterflyRuntime.setTiers = function(arg)
		local butterflyTiers = {}

		for i, v23 in ipairs(type(arg) == "table" and arg or {}) do
			local v24 = senaV4ButterflyRuntime.tierFromLabel(tostring(v23))

			if v24 then
				butterflyTiers[#butterflyTiers + 1] = v24
			end
		end

		senaV4Config.ButterflyTiers = butterflyTiers
	end

	local tbl16 = {"All Recipes", "For Essence (shortfall only)", "Emerald to Sapphire", "Sapphire to Amethyst", "Amethyst to Radiant"}
	local tbl17 = {["For Essence (shortfall only)"] = "Smart", ["Emerald to Sapphire"] = "Green", ["Sapphire to Amethyst"] = "Blue", ["Amethyst to Radiant"] = "Purple"}

	senaV4ButterflyRuntime.recipeOptions = function()
		return tbl16
	end

	senaV4ButterflyRuntime.setRecipe = function(arg)
		senaV4Config.ButterflyTradeRecipe = tbl17[tostring(arg)] or "All"
	end

	local tbl18 = {"Tween to Butterfly", "Stand", "Zigzag", "Circle"}
	local tbl19 = {["Tween to Butterfly"] = "Tween", Stand = "Stand", Zigzag = "Zigzag", Circle = "Circle"}

	senaV4ButterflyRuntime.modeOptions = function()
		return tbl18
	end

	senaV4ButterflyRuntime.setMode = function(arg)
		senaV4Config.ButterflyCatchMode = tbl19[tostring(arg)] or "Tween"
	end

	local folder

	local function fn91()
		for k, card in pairs(senaV4ButterflyRuntime.cards) do
			pcall(function()
				card.part:Destroy()
			end)

			senaV4ButterflyRuntime.cards[k] = nil
		end

		if folder then
			pcall(function()
				folder:Destroy()
			end)

			folder = nil
		end
	end

	local function fn92()
		local currentCamera = workspace.CurrentCamera
		if not currentCamera then
			return
		end

		if not (folder and folder.Parent) then
			folder = Instance.new("Folder")
			folder.Name = "SenaBloomEsp"
			folder.Parent = currentCamera
		end

		local tbl20 = senaV4ButterflyRuntime.tiers() or {}
		local v23 = fn71()
		local tbl21 = {}

		for i, v24 in ipairs(fn74()) do
			local str3 = ("%d_%d_%d"):format(v24.pos.X, v24.pos.Y, v24.pos.Z)
			tbl21[str3] = true
			currentCamera = senaV4ButterflyRuntime.cards[str3]

			if currentCamera and currentCamera.part.Parent then
			else
				local part = Instance.new("Part")
				part.Size = Vector3.new(0.2, 0.2, 0.2)
				part.Anchored = true
				part.CanCollide = false
				part.CanQuery = false
				part.CanTouch = false
				part.Transparency = 1
				part.Parent = folder
				local billboardGui = Instance.new("BillboardGui")
				billboardGui.Adornee = part
				billboardGui.Size = UDim2.fromOffset(120, 20)
				billboardGui.StudsOffsetWorldSpace = Vector3.new(0, 1.6, 0)
				billboardGui.AlwaysOnTop = true
				billboardGui.MaxDistance = 260
				billboardGui.Parent = part
				local textLabel = Instance.new("TextLabel")
				textLabel.Size = UDim2.fromScale(1, 1)
				textLabel.BackgroundTransparency = 1
				textLabel.Font = Enum.Font.GothamBold
				textLabel.TextSize = 13
				textLabel.TextStrokeTransparency = 0.35
				textLabel.Parent = billboardGui
				currentCamera = {part = part, label = textLabel}
				senaV4ButterflyRuntime.cards[str3] = currentCamera
			end

			currentCamera.part.CFrame = CFrame.new(v24.pos)
			local v25 = tbl20[v24.tier]
			currentCamera.label.TextColor3 = v25 and v25.color or Color3.new(1, 1, 1)
			currentCamera.label.Text = v23 and ("%s  %dm"):format(v25 and v25.name or v24.tier, math.floor((v24.pos - v23.Position).Magnitude)) or (v25 and v25.name or v24.tier)
		end

		for k, card in pairs(senaV4ButterflyRuntime.cards) do
			if not tbl21[k] then
				pcall(function()
					card.part:Destroy()
				end)

				senaV4ButterflyRuntime.cards[k] = nil
			end
		end
	end

	local tbl20 = {target = nil, since = 0, swinging = false}
	tbl20.skip = setmetatable({}, {__mode = "k"})

	tbl20.pos = function(arg)
		if not (arg and arg.Parent) then
			return nil
		end

		local ok, result = pcall(function()
			return arg.PrimaryPart and arg.PrimaryPart.Position or arg:GetPivot().Position
		end)

		return ok and result or nil
	end

	tbl20.pick = function(arg)
		local butterflyBloomSwarm = workspace:FindFirstChild("ButterflyBloomSwarm")
		if not butterflyBloomSwarm then
			return nil
		end
		local v23 = fn73()
		local now = os.clock()
		local v24, v25

		for i, child in ipairs(butterflyBloomSwarm:GetChildren()) do
			if child:IsA("Model") and tbl14[child.Name] and (if v23 then v23[child.Name] else not v23) and (tbl20.skip[child] or 0) <= now then
				local v26 = tbl20.pos(child)

				if v26 then
					local n10 = (tbl14[child.Name] == 4 and 1000000 or 0) - (v26 - arg).Magnitude

					if v24 then
						if n10 > v24 then
							v24 = n10
							v25 = child
						end
					else
						v24 = n10
						v25 = child
					end
				end
			end
		end

		return v25
	end

	tbl20.gain = function()
		local ok, result = pcall(fn66().Save.Peek)
		local num = ok and result and result.Butterflies and tonumber(result.Butterflies.TotalCaught)
		return num and senaV4ButterflyRuntime.bloomBase and math.max(0, num - senaV4ButterflyRuntime.bloomBase) or 0
	end

	tbl20.swing = function(arg, arg2)
		if tbl20.swinging then
			return
		end
		local n10 = tonumber(fn67("SwingCooldownSeconds", 0.45)) or 0.45
		if os.clock() - senaV4ButterflyRuntime.lastSwing < n10 then
			return
		end
		local v23 = fn66()

		if v23 then
			if v23.Swarm then
				if not v23.Swarm.Nearest then
					return
				end
			else
				return
			end
		else
			return
		end

		local ok, result = pcall(v23.Swarm.Nearest, arg2, Vector3.new(0, 0, -1), 4)
		local flight = ok and result and result.Flight
		if not (flight and flight.Id) then
			return
		end

		if flight.Tier ~= nil and tostring(flight.Tier) ~= arg.Name then
			return
		end
		senaV4ButterflyRuntime.lastSwing = os.clock()
		tbl20.swinging = true

		task.spawn(function()
			local Butterflies, v24, v25 = fn68("Butterflies", "AskSwing", flight.Id)
			tbl20.swinging = false

			if v25 ~= "Caught" and v25 ~= "Gone" then
				tbl20.skip[arg] = os.clock() + 1.5
			end

			if tbl20.target == arg then
				tbl20.target = nil
			end

			local v26 = senaV4ButterflyRuntime.tiers()
			local name2 = v26 and v26[arg.Name] and v26[arg.Name].name or arg.Name
			senaV4ButterflyRuntime.status = ("%s %s  \194\183  +%d this Bloom"):format(v25 == "Caught" and "Caught" or "Chasing", name2, tbl20.gain())
		end)
	end

	tbl20.prepare = function()
		local character = localPlayer.Character
		local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")

		if humanoidRootPart then
			if not humanoid then
				return nil
			end
		else
			return nil
		end

		fn76()
		fn36(character)
		fn26()
		fn7()
		local autoRotate = humanoid.AutoRotate
		humanoid.AutoRotate = false
		return character, humanoidRootPart, humanoid, autoRotate
	end

	tbl20.release = function(arg, arg2, autoRotate)
		tbl20.target = nil

		if arg2.Parent and autoRotate ~= nil then
			arg2.AutoRotate = autoRotate
		end

		arg.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
		arg.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
		fn8()
	end

	tbl20.keepGoing = function(arg, arg2, arg3)
		if fn2() then
			if senaV4Config.ButterflyAutoCatch then
				if senaV4ButterflyRuntime.bloomLeft() > 0 then
					if arg.Parent then
						if not (arg2.Health > 0) then
							return false
						end
					else
						return false
					end
				else
					return false
				end
			else
				return false
			end
		else
			return false
		end

		if (senaV4Config.ButterflyCatchMode or "Tween") ~= arg3 then
			return false
		end
		return not (senaV4ButterflyRuntime.manual or fn79() or fn31() or senaV4TaskLadder.blocker("butterfly") ~= nil)
	end

	tbl20.moveStep = function(arg, arg2, arg3, arg4, arg5, arg6, arg7)
		fn15(arg, arg6 * v2.HEADROOM)
		local v23 = fn13()[v2.INTEGRITY_KEY]
		local state = type(v23) == "table" and v23.State or nil

		if not fn22(state, arg2, arg3) then
			arg3.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
			arg3.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
			fn6(arg3.Position)

			if fn21(state, arg2, arg3) then
				fn19(state, arg6 * v2.HEADROOM, (Vector3.new(0, 0, 0)))
			else
				fn23(arg2, arg3, arg6)
			end

			return nil
		end

		local position = arg3.Position
		local n10 = arg4 - position
		local n11 = arg6 * arg7
		local n12 = n10.Magnitude <= n11 and arg4 or position + n10.Unit * n11
		local n13 = (arg5 or arg4) - n12
		arg4 = Vector3.new(n13.X, 0, n13.Z)
		local v24 = if arg4.Magnitude <= 0.001 then Vector3.new(n10.X, 0, n10.Z) else arg4
		local unit = v24.Magnitude > 0.001 and v24.Unit or arg3.CFrame.LookVector
		local n14 = (n12 - position) / arg7
		fn6(n12)
		arg3.CFrame = CFrame.lookAt(n12, n12 + unit)
		arg3.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
		arg3.AssemblyAngularVelocity = Vector3.new(0, 0, 0)

		if not fn24(arg2, arg3, arg6, n14) then
			fn23(arg2, arg3, arg6)
			fn24(arg2, arg3, arg6, n14)
		end

		return n12
	end

	tbl20.nearest = function(arg, arg2)
		local butterflyBloomSwarm = workspace:FindFirstChild("ButterflyBloomSwarm")
		if not butterflyBloomSwarm then
			return nil
		end
		local v23, now, v24, v25, v26 = fn73(), os.clock(), arg2

		for i, child in ipairs(butterflyBloomSwarm:GetChildren()) do
			if child:IsA("Model") and tbl14[child.Name] and (if v23 then v23[child.Name] else not v23) and (tbl20.skip[child] or 0) <= now then
				local v27 = tbl20.pos(child)
				local magnitude = v27 and (v27 - arg).Magnitude

				if magnitude and magnitude <= v24 then
					v24 = magnitude
					v25 = child
					v26 = v27
				end
			end
		end

		return v25, v26
	end

	tbl20.cluster = function(arg)
		local butterflyBloomSwarm = workspace:FindFirstChild("ButterflyBloomSwarm")
		local tbl21 = {}

		for i, v23 in ipairs(butterflyBloomSwarm and butterflyBloomSwarm:GetChildren() or {}) do
			if v23:IsA("Model") and tbl14[v23.Name] then
				local v24 = tbl20.pos(v23)

				if v24 then
					tbl21[#tbl21 + 1] = v24
				end
			end
		end

		if #tbl21 == 0 then
			return nil, 0, 0
		end
		butterflyBloomSwarm = 0

		for i, v23 in ipairs(tbl21) do
			butterflyBloomSwarm = if arg then if (v23 - arg).Magnitude <= 24 then butterflyBloomSwarm + 1 else butterflyBloomSwarm else butterflyBloomSwarm
		end

		local v23, v24

		for i, v25 in ipairs(tbl21) do
			local vector2 = Vector3.new(0, 0, 0)
			local n10 = 0

			for i2, v26 in ipairs(tbl21) do
				if (v25 - v26).Magnitude <= 24 then
					vector2, n10 = vector2 + v26, n10 + 1
				end
			end

			local n11 = vector2 / n10
			local n12 = n10 * 100 - (arg and (n11 - arg).Magnitude or 0)

			if v23 then
				if n12 > v23 then
					v23 = n12
					v24 = n11
				end
			else
				v23 = n12
				v24 = n11
			end
		end

		return v24, #tbl21, butterflyBloomSwarm
	end

	tbl20.route = function(arg, arg2, arg3)
		if arg == "Circle" then
			local n10 = 24
			local n11 = arg3 * 2.0833333333333335
			return arg2 + Vector3.new(math.cos(n11) * n10, 0, math.sin(n11) * n10)
		end

		local v23 = fn85()

		if arg ~= "Zigzag" then
			return arg2
		elseif v23 then
		else
			return arg2
		end

		local n10 = math.max(v23.Size.X / 2 - 12, 20)
		local n11 = math.clamp(v23.Size.Z / 2 - 12, 8, 30)
		local n12 = 8
		local v24 = math.sqrt((2 * n10 / n12) ^ 2 + (2 * n11) ^ 2)
		local n13 = arg3 * 80 / v24 % 16
		local n14 = math.floor(n13)
		local n15 = n13 - n14
		local n16 = n14 <= n12 and n14 or 16 - n14
		local n17 = n14 + 1 <= n12 and n14 + 1 or 16 - (n14 + 1)
		local n18 = -n10 + n16 * (2 * n10 / n12)
		local n19 = n14 % 2 == 0 and -n11 or n11
		local n20 = -n10 + n17 * (2 * n10 / n12)
		local n21 = (n14 + 1) % 2 == 0 and -n11 or n11
		local v25 = v23.CFrame:VectorToWorldSpace(Vector3.new(n18 + (n20 - n18) * n15, 0, n19 + (n21 - n19) * n15))
		return Vector3.new(v23.Position.X + v25.X, arg2.Y, v23.Position.Z + v25.Z)
	end

	tbl20.patrol = function(arg)
		local v23, v24, v25, v26 = tbl20.prepare()
		if not v23 then
			return false
		end
		local n10, v27, now, n11, v28, v29 = tonumber(fn67("NetReach", 14)) or 14, ({Stand = "Standing in the swarm", Zigzag = "Zigzag patrol", Circle = "Circling the swarm"})[arg] or arg, os.clock(), 0
		local flag6 = false
		local n12 = 0

		while tbl20.keepGoing(v24, v25, arg) do
			local n13 = math.max(math.min(RunService.Heartbeat:Wait(), n4), 0.004166666666666667)
			local now2 = os.clock()

			if now2 >= n11 then
				local v30, v31, v32 = tbl20.cluster(v28)
				n11 = now2 + 1.5

				if v31 == 0 then
					v29 = v29 or now2
				else
					v28, v29 = if arg == "Stand" then if v28 then if v32 < 3 then v30 else v28 else v30 else v28 and v28:Lerp(v30, 0.5) or v30, nil
				end
			end

			if v29 and now2 - v29 > 2 then
				break
			end

			if v28 then
				flag6 = true
				local v30 = tbl20.route(arg, v28, now2 - now)
				local n14 = (v30 - v24.Position).Magnitude > 40 and 1 / 0 or (arg == "Stand" and 60 or (arg == "Circle" and 70 or 110))
				local n15, v31, v32 = math.clamp(math.min(fn4(), n14), v2.MIN_SPEED, v2.MAX_SPEED), tbl20.nearest(v24.Position, n10 + 6)
				local v33 = tbl20.moveStep(v23, v25, v24, v30, v32, n15, n13)

				if v33 and (v31 and (v32 - v33).Magnitude <= n10 - 1.5) then
					tbl20.swing(v31, v32)
				end

				if now2 >= n12 then
					if tbl20.swinging then
					else
						local n16 = now2 + 1
						senaV4ButterflyRuntime.status = ("%s  \194\183  +%d this Bloom"):format(v27, tbl20.gain())
						n12 = n16
					end
				end
			else
				v24.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
				v24.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
				fn6(v24.Position)
			end
		end

		tbl20.release(v24, v25, v26)
		return flag6
	end

	tbl20.run = function()
		local v23, v24, v25, v26 = tbl20.prepare()
		if not v23 then
			return false
		end
		local n10 = tonumber(fn67("NetReach", 14)) or 14
		local n11 = math.min(n10 - 3, (tonumber(fn67("DodgeRadius", 9)) or 9) + 1)
		local now
		local flag6 = false

		while tbl20.keepGoing(v24, v25, "Tween") do
			local n12 = math.max(math.min(RunService.Heartbeat:Wait(), n4), 0.004166666666666667)
			local target = tbl20.target
			local v27 = tbl20.pos(target)

			if if v27 then os.clock() - tbl20.since > 3 else not v27 then
				if v27 then
					tbl20.skip[target] = os.clock() + 2
				end

				target = tbl20.pick(v24.Position)
				tbl20.target, tbl20.since = target, os.clock()
				v27 = tbl20.pos(target)

				if target then
					local v28 = senaV4ButterflyRuntime.tiers()
					senaV4ButterflyRuntime.status = ("Chasing %s  \194\183  +%d this Bloom"):format(v28 and v28[target.Name] and v28[target.Name].name or target.Name, tbl20.gain())
				end
			end

			if v27 then
				now = nil
				flag6 = true
				local n13 = math.clamp(fn4(), v2.MIN_SPEED, v2.MAX_SPEED)
				local n14 = v24.Position - v27
				local n15 = n14.Magnitude > 0.001 and v27 + n14.Unit * n11 or v27 + Vector3.new(n11, 0, 0)
				local v28 = tbl20.moveStep(v23, v25, v24, n15, v27, n13, n12)

				if v28 and (v27 - v28).Magnitude <= n10 - 1.5 then
					tbl20.swing(target, v27)
				end
			else
				now = now or os.clock()
				if os.clock() - now > 2 then
					break
				end
				v24.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
				v24.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
				fn6(v24.Position)
			end
		end

		tbl20.release(v24, v25, v26)
		return flag6
	end

	local function fn93(arg)
		if fn79() then
			fn82()
			return
		end

		if not fn86() then
			fn76()
			if fn31() then
				senaV4ButterflyRuntime.status = "Night - waiting to fly to the forest"
				return
			end

			if not fn69("area") then
				return
			end
			local v23 = fn87()

			if not v23 then
				senaV4ButterflyRuntime.status = "Butterfly Bloom zone not found"
				fn70("area")
				return
			end

			senaV4ButterflyRuntime.status = "Flying to the Butterfly Bloom"

			if not fn78(v23, 60) then
				fn70("area")
				senaV4ButterflyRuntime.status = "Could not reach the Enchanted Forest"
			end

			return
		end

		local senaV4TreadmillManager = genv.__SenaV4TreadmillManager

		if senaV4TreadmillManager and senaV4TreadmillManager.activeTreadmill ~= nil then
			fn88()
		end

		if not arg.holding and not fn75() then
			senaV4ButterflyRuntime.status = "Butterfly Net is not in your backpack"
			return
		end
		local butterflyCatchMode = senaV4Config.ButterflyCatchMode or "Tween"

		if not (if butterflyCatchMode == "Tween" then tbl20.run() else tbl20.patrol(butterflyCatchMode)) then
			fn77()
			senaV4ButterflyRuntime.status = ("Waiting for butterflies  \194\183  +%d this Bloom"):format(tbl20.gain())
		end
	end

	local function fn94(arg)
		if not arg.net then
			return arg.treeUnlocked and "No Butterfly Net yet" or "Enchanted Tree locked - finish the Wisp Event"
		end

		if arg.active then
			return "Bloom is live"
		end

		if arg.nextIn then
			return ("Next Bloom in %dm %02ds"):format(math.floor(arg.nextIn / 60), math.floor(arg.nextIn % 60))
		end
		return "Idle"
	end

	local function fn95()
		if senaV4ButterflyRuntime.manual then
			return
		end
		local v23 = senaV4ButterflyRuntime.snapshot()

		if v23.active then
			senaV4ButterflyRuntime.bloomBase = senaV4ButterflyRuntime.bloomBase or v23.caught
		else
			senaV4ButterflyRuntime.bloomBase = nil
		end

		if senaV4Config.ButterflyEsp and v23.active then
			fn92()
		else
			if next(senaV4ButterflyRuntime.cards) then
				fn91()
			else
				if folder then
					fn91()
				end
			end
		end

		pcall(senaV4ButterflyRuntime.questDrive, v23)

		if senaV4Config.WispAutoQuest and (v23.claimable and (v23.questId and fn69("quest"))) then
			local WispCompanion, v24 = fn68("WispCompanion", "Request", "Claim", v23.questId)
			senaV4ButterflyRuntime.status = WispCompanion and "Wisp quest claimed: " .. v23.quest or "Wisp claim: " .. tostring(v24 or "refused")

			if not WispCompanion then
				fn70("quest")
			end
		end

		local str3 = nil

		if senaV4Config.WispAutoQuest and not v23.accepted and not v23.unlocked and (v23.need or 0) > 0 and (v23.speed or 0) >= v23.need and fn69("accept") then
			str3 = "accept"
		else
			if senaV4Config.WispAutoQuest and not v23.unlocked and (v23.returning or v23.readyReturn) and fn69("wisp") then
				str3 = "wisp"
			else
				if senaV4Config.ButterflyAutoNet and not v23.net and v23.treeUnlocked and fn69("net") then
					str3 = "net"
				else
					if senaV4Config.BanjoAuto and v23.treeUnlocked and not v23.banjoClaimed and not v23.active and fn69("banjo") then
						str3 = "banjo"
					else
						if senaV4Config.ButterflyAutoCatch and v23.active and v23.net and not (v13 and v13.enabled and os.clock() - (tonumber(v13.gateOpenAt) or 0) < 3) then
							str3 = "catch"
						else
							local active = v23.active
							str3 = if (if active then not active else senaV4Config.ButterflyAutoTrade) and v23.net and senaV4ButterflyRuntime.canTrade() and fn69("trade") then "trade" else if v23.active then str3 else if senaV4Config.ButterflyAutoCraft then if v23.net then if senaV4ButterflyRuntime.canCraft() then if fn69("craft") then "craft" else str3 else str3 else str3 else str3
						end
					end
				end
			end
		end

		senaV4ButterflyRuntime.wantsCharacter = str3 ~= nil
		local butterfly = str3 and senaV4TaskLadder.blocker("butterfly") or nil
		local butterfly2 = str3 and not butterfly and senaV4TaskLadder.holder("butterfly") or nil
		local active = senaV4ButterflyRuntime.active
		senaV4ButterflyRuntime.active = str3 ~= nil and butterfly == nil and butterfly2 == nil

		if str3 and not senaV4ButterflyRuntime.active then
			fn76()

			if butterfly and fn79() then
				senaV4ButterflyRuntime.status = "Leaving the tree for " .. senaV4TaskLadder.TITLES[butterfly]
				fn82()
			end

			senaV4ButterflyRuntime.status = butterfly and "Yielding to " .. senaV4TaskLadder.TITLES[butterfly] or "Waiting for " .. senaV4TaskLadder.TITLES[butterfly2] .. " to hand over"
			return
		end

		if not str3 then
			if active then
				fn90()
			end

			fn76()
			senaV4ButterflyRuntime.status = fn94(v23)
			return
		end

		if not active then
			fn88()
		end

		if str3 == "accept" then
			butterfly, active = senaV4ButterflyRuntime.acceptWisp()
			senaV4ButterflyRuntime.status = butterfly and "Wisp accepted - quests started" or "Wisp: " .. tostring(active or "refused")

			if not butterfly then
				fn70("accept")
			end
		elseif str3 == "wisp" then
			local v24, v25 = senaV4ButterflyRuntime.returnWisp()
			senaV4ButterflyRuntime.status = v24 and "Wisp returned - Enchanted Tree unlocked" or "Wisp: " .. tostring(v25 or "refused")

			if not v24 then
				fn70("wisp")
			end
		elseif str3 == "banjo" then
			local v24, v25 = senaV4ButterflyRuntime.runBanjo()
			senaV4ButterflyRuntime.status = v24 and "Banjo Cricket secret claimed" or "Banjo: " .. tostring(v25 or "refused")

			if not v24 then
				fn70("banjo")
			end

			if fn79() then
				fn82()
			end
		elseif str3 == "net" then
			local v24, v25 = senaV4ButterflyRuntime.claimNet()
			senaV4ButterflyRuntime.status = v24 and "Butterfly Net claimed" or "Net: " .. tostring(v25 or "refused")

			if not v24 then
				fn70("net")
			end
		elseif str3 == "catch" then
			fn93(v23)
		elseif str3 == "trade" then
			local v24, v25 = senaV4ButterflyRuntime.tradeUp()
			senaV4ButterflyRuntime.status = v24 and ("Traded up %d time(s)"):format(tonumber(v25) or 0) or "Trade: " .. tostring(v25)
			fn70("trade")
		elseif str3 == "craft" then
			local v24, v25 = senaV4ButterflyRuntime.craft()
			senaV4ButterflyRuntime.status = v24 and ("Crafted %d Enchanted Essence"):format(tonumber(v25) or 0) or "Craft: " .. tostring(v25)
			fn70("craft")
		end
	end

	task.spawn(function()
		while fn2() do
			local ok, result = pcall(fn95)

			if not ok then
				senaV4ButterflyRuntime.active = false
				senaV4ButterflyRuntime.wantsCharacter = false
				fn76()
				senaV4ButterflyRuntime.status = "Error: " .. tostring(result)
				task.wait(1)
			end

			task.wait(0.2)
		end

		fn76()
		fn91()
	end)

	senaV4TaskLadder.register("butterfly", {wants = function()
		return senaV4ButterflyRuntime.wantsCharacter == true
	end, active = function()
		return senaV4ButterflyRuntime.active == true
	end, enabled = function()
		return senaV4Config.ButterflyAutoCatch == true or senaV4Config.ButterflyAutoNet == true or senaV4Config.WispAutoQuest == true or senaV4Config.BanjoAuto == true or senaV4Config.ButterflyAutoTrade == true or senaV4Config.ButterflyAutoCraft == true
	end, status = function()
		return tostring(senaV4ButterflyRuntime.status or "")
	end})

	genv.__SenaV4ButterflyRuntime = senaV4ButterflyRuntime
end

do
	local Players2 = game:GetService("Players")
	local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
	local localPlayer2 = Players2.LocalPlayer
	local str3 = "SENAVIS_"
	local senaV4VisualSAE = {held = {}}

	local function fn65()
		local ok, result = pcall(require, ReplicatedStorage2.Shared.Save)
		return ok and result or nil
	end

	local function fn66()
		local ok, result = pcall(require, ReplicatedStorage2.Data.Assets)
		if not ok then
			return nil
		end
		return result.Directory or result
	end

	local function fn67(arg)
		return str3 .. arg .. "_" .. tostring(math.floor(os.clock() * 1000)) .. "_" .. tostring(math.random(1, 1000000))
	end

	senaV4VisualSAE.categories = function(arg)
		local v21 = fn66()
		local tbl13 = {}
		if not v21 then
			return tbl13
		end

		for k, v22 in pairs(v21) do
			if type(k) == "string" and type(v22) == "table" then
				if arg == "Pet" then
					tbl13[#tbl13 + 1] = k
				elseif v22.Egg ~= nil then
					tbl13[#tbl13 + 1] = k
				end
			end
		end

		table.sort(tbl13)
		return tbl13
	end

	senaV4VisualSAE.spawnEgg = function(arg, arg2)
		local v21 = fn65()
		local v22 = fn66()

		if v21 and v22 then
			if not v22[arg] then
				return nil
			end
		else
			return nil
		end

		local v23 = fn67("E")

		pcall(function()
			v21.Amend("EggInventory", function(arg3)
				arg3[v23] = {AssetCategory = arg, AssetScale = tonumber(arg2) or 50, AssetColorIndex = 1, AssetColorSeed = math.random(1, 2000000000), AssetEyeColor = "ffffff", HasParasite = false, Mutations = {}}
			end)
		end)

		return v23
	end

	senaV4VisualSAE.spawnPet = function(arg, arg2)
		local v21 = fn65()
		local v22 = fn66()

		if v21 and v22 then
			if not v22[arg] then
				return nil
			end
		else
			return nil
		end

		local v23 = fn67("P")

		pcall(function()
			v21.Amend("Inventory", function(arg3)
				arg3[v23] = {Category = arg, Scale = tonumber(arg2) or 50, ColorIndex = 1, ColorSeed = math.random(1, 2000000000), EyeColor = "ffffff", Gender = "Male", Personality = "Normal", InFuse = false, HasBeenFirstPlaced = false, Mutations = {}}
			end)
		end)

		return v23
	end

	local function fn68(arg)
		local assets = ReplicatedStorage2:FindFirstChild("Assets")
		assets = assets and assets:FindFirstChild("Models")
		local eggs = assets and assets:FindFirstChild("Eggs")
		return eggs and eggs:FindFirstChild(arg)
	end

	local function fn69(arg)
		local assetModels = ReplicatedStorage2:FindFirstChild("AssetModels")
		return assetModels and assetModels:FindFirstChild(arg)
	end

	senaV4VisualSAE.hold = function(arg, arg2, arg3)
		local character = localPlayer2.Character
		if not character then
			return false
		end
		local v21 = arg2 and fn68(arg) or fn69(arg)
		if not v21 then
			return false
		end

		local ok, result = pcall(function()
			return v21:Clone()
		end)

		if ok then
			if not (result and result:IsA("Model")) then
				return false
			end
		else
			return false
		end

		local primaryPart = result.PrimaryPart or result:FindFirstChildWhichIsA("BasePart")

		if not primaryPart then
			pcall(function()
				result:Destroy()
			end)

			return false
		end

		pcall(function()
			if not result.PrimaryPart then
				result.PrimaryPart = primaryPart
			end
		end)

		local n8 = math.clamp(1 + (tonumber(arg3) or 50) / 70, 1, 2.4) * (0.85 + math.random() * 0.4)

		pcall(function()
			if result.ScaleTo then
				result:ScaleTo(n8)
			end
		end)

		local vector2 = Vector3.new(3, 3, 3)

		pcall(function()
			vector2 = result:GetExtentsSize()
		end)

		local tool = Instance.new("Tool")
		tool.Name = str3 .. arg
		tool.RequiresHandle = true
		tool.CanBeDropped = false
		local v22 = fn66()
		arg3 = v22 and v22[arg]
		local icon = arg3 and (arg2 and arg3.Egg and arg3.Egg.Icon or arg3.Icon)

		if type(icon) == "string" then
			pcall(function()
				tool.TextureId = icon
			end)
		end

		primaryPart.Name = "Handle"

		for i, descendant in ipairs(result:GetDescendants()) do
			if descendant:IsA("BasePart") then
				descendant.Massless = true
				descendant.CanCollide = false
				descendant.Anchored = false

				if descendant ~= primaryPart then
					local weldConstraint = Instance.new("WeldConstraint")
					weldConstraint.Part0 = primaryPart
					weldConstraint.Part1 = descendant
					weldConstraint.Parent = primaryPart
				end
			end
		end

		for i, child in ipairs(result:GetChildren()) do
			child.Parent = tool
		end

		primaryPart.Parent = tool

		pcall(function()
			result:Destroy()
		end)

		pcall(function()
			local n9 = math.max(vector2.X, vector2.Z)
			tool.Grip = CFrame.new(0, -(vector2.Y * 0.55), n9 * 0.5 + 0.5)
		end)

		tool.Parent = localPlayer2:FindFirstChild("Backpack") or character
		local humanoid = character:FindFirstChildOfClass("Humanoid")

		if humanoid then
			pcall(function()
				humanoid:EquipTool(tool)
			end)
		end

		senaV4VisualSAE.held[#senaV4VisualSAE.held + 1] = tool
		return true
	end

	senaV4VisualSAE.spawn = function(arg, arg2, arg3, arg4)
		if arg2 then
			if arg2 == "None" then
				return
			end
		else
			return
		end

		local n8 = tonumber(arg3) or 50

		if arg4 then
			pcall(senaV4VisualSAE.hold, arg2, arg ~= "Pet", n8)
		elseif arg == "Pet" then
			local n9 = math.clamp(1 + n8 / 25, 1.2, 5) * (0.85 + math.random() * 0.4)
			senaV4VisualSAE.spawnPet(arg2, n9)
		else
			senaV4VisualSAE.spawnEgg(arg2, n8 * (0.85 + math.random() * 0.5))
		end
	end

	senaV4VisualSAE.clear = function()
		local v21 = fn65()

		if v21 then
			pcall(function()
				v21.Amend("EggInventory", function(arg)
					for k in pairs(arg) do
						if type(k) == "string" and k:sub(1, #str3) == str3 then
							arg[k] = nil
						end
					end
				end)
			end)

			pcall(function()
				v21.Amend("Inventory", function(arg)
					for k in pairs(arg) do
						if type(k) == "string" and k:sub(1, #str3) == str3 then
							arg[k] = nil
						end
					end
				end)
			end)

			pcall(function()
				v21.Amend("EquippedAssets", function(arg)
					for i = #arg, 1, -1 do
						local v22 = arg[i]

						if type(v22) == "string" and v22:sub(1, #str3) == str3 then
							table.remove(arg, i)
						end
					end
				end)
			end)
		end

		for i, v22 in ipairs(senaV4VisualSAE.held) do
			pcall(function()
				v22:Destroy()
			end)
		end

		senaV4VisualSAE.held = {}

		for i, v22 in ipairs({localPlayer2.Character, localPlayer2:FindFirstChild("Backpack")}) do
			if v22 then
				for i2, child in ipairs(v22:GetChildren()) do
					if child:IsA("Tool") and child.Name:sub(1, #str3) == str3 then
						pcall(function()
							child:Destroy()
						end)
					end
				end
			end
		end
	end

	genv.__SenaV4VisualSAE = senaV4VisualSAE
end

do
	local cameraMaxZoomDistance = (tonumber(game:GetService("StarterPlayer").CameraMaxZoomDistance) or 128) * 1.95

	local function fn65()
		if localPlayer.CameraMaxZoomDistance < cameraMaxZoomDistance then
			localPlayer.CameraMaxZoomDistance = cameraMaxZoomDistance
		end
	end

	pcall(fn65)

	local function fn66()
		if fn2() then
			pcall(fn65)
		end
	end

	localPlayer:GetPropertyChangedSignal("CameraMaxZoomDistance"):Connect(fn66)
end

genv.__SenaV4Visual = (function()
	local HttpService = game:GetService("HttpService")
	local tbl13 = {base = "https://senahub.xyz/api/visual/", manifest = nil, status = "Idle", spawned = {}, backs = {}, backRod = nil, remote = {}}
	local str3 = "SenaVisual/cache"
	local unit = Vector3.new(0.3, 0.75, 0.6).Unit
	local tbl14 = {RightShoulder = CFrame.Angles(0.6981317007977318, 0, 0.17453292519943295), RightElbow = CFrame.Angles(1.7453292519943295, 0, 0), RightWrist = CFrame.new(), LeftShoulder = CFrame.new(), LeftElbow = CFrame.new(), LeftWrist = CFrame.new()}
	local n8 = 0.8
	local v21 = CFrame.new(0.5, 1.3, 1, -0.7071, -0.7071, 0, -0.7071, 0.7071, 0, 0, 0, -1):Inverse()

	local function fn65(arg)
		local str4 = ""

		for match in string.gmatch(arg, "[^/]+") do
			str4 = str4 == "" and match or str4 .. "/" .. match

			if not isfolder(str4) then
				makefolder(str4)
			end
		end
	end

	local function fn66(arg)
		local ok, result = pcall(function()
			return game:HttpGet(arg, true)
		end)

		if ok and (type(result) == "string" and result ~= "") then
			return result
		end
		return nil
	end

	tbl13.loadManifest = function()
		if tbl13.manifest then
			return tbl13.manifest
		end
		fn65(str3)
		local v22 = fn66(tbl13.base .. "manifest.json")
		local v23

		if v22 then
			pcall(writefile, str3 .. "/manifest.json", v22)
			v23 = v22
		else
			if isfile(str3 .. "/manifest.json") then
				v22 = readfile(str3 .. "/manifest.json")
			end

			v23 = v22
		end

		local ok, manifest = pcall(function()
			return HttpService:JSONDecode(v23)
		end)

		if ok and type(manifest) == "table" then
			tbl13.manifest = manifest
		end

		return tbl13.manifest
	end

	tbl13.names = function(arg)
		local tbl15 = {}
		local v22 = tbl13.loadManifest()

		for i, v23 in ipairs(v22 and v22[arg] or {}) do
			i = v23.name
			local v24 = if v23.tier then v23.name .. " [" .. v23.tier .. "]" else i
			table.insert(tbl15, v24)
		end

		return tbl15
	end

	local function fn67(arg, arg2)
		local v22 = tbl13.loadManifest()

		for i, v23 in ipairs(v22 and v22[arg] or {}) do
			if v23.name == arg2 then
				return v23
			elseif v23.name .. " [" .. tostring(v23.tier) .. "]" == arg2 then
				return v23
			end
		end

		return nil
	end

	local function fn68(arg, arg2)
		local str4 = str3 .. "/" .. arg
		fn65(str4)
		local str5 = str4 .. "/" .. arg2.file

		if not isfile(str5) then
			tbl13.status = "Downloading " .. arg2.name .. "..."
			local v22 = fn66(tbl13.base .. arg .. "/" .. arg2.file)
			if not v22 then
				return nil, "Download failed"
			end
			writefile(str5, v22)
		end

		arg, str4 = pcall(function()
			return game:GetObjects(getcustomasset(str5))
		end)

		if (if arg then type(str4) ~= "table" else not arg) or not str4[1] then
			pcall(delfile, str5)
			return nil, "Could not load model"
		end
		return str4[1]
	end

	tbl13.rodScale = 1
	tbl13.fishWeight = 0

	local function fn69(arg, arg2, arg3)
		local tbl15 = {}

		for i, descendant in ipairs(arg:GetDescendants()) do
			if descendant:IsA("JointInstance") then
				descendant:Destroy()
			elseif descendant:IsA("WeldConstraint") then
				descendant:Destroy()
			elseif descendant:IsA("BasePart") then
				table.insert(tbl15, descendant)
			elseif descendant:IsA("Script") then
				descendant:Destroy()
			elseif descendant:IsA("LocalScript") then
				descendant:Destroy()
			end
		end

		if #tbl15 == 0 then
			return nil
		end
		local handle = arg:FindFirstChild("Handle", true)
		local v22 = if handle then if handle:IsA("BasePart") then handle else tbl15[1] else tbl15[1]

		if arg2 or arg3 and arg3 ~= 1 then
			local boundingBox, v23 = arg:GetBoundingBox()
			local n9 = arg3 or arg2 / math.max(v23.X, v23.Y, v23.Z, 0.01)
			local v24 = if arg2 then boundingBox else v22.CFrame

			for i, v25 in ipairs(tbl15) do
				local v26 = v24:ToObjectSpace(v25.CFrame)
				v25.Size = v25.Size * n9
				v25.CFrame = v24 * (CFrame.new(v26.Position * n9) * v26.Rotation)
			end

			for i, descendant in ipairs(arg:GetDescendants()) do
				if descendant:IsA("Attachment") and not descendant.Parent:IsA("Bone") then
					descendant.Position = descendant.Position * n9
				end
			end
		end

		for i, v23 in ipairs(tbl15) do
			v23.Anchored = false
			v23.CanCollide = false
			v23.CanQuery = false
			v23.CanTouch = false
			v23.Massless = true

			if v23 ~= v22 then
				local weld = Instance.new("Weld")
				weld.Part0 = v22
				weld.Part1 = v23
				weld.C0 = v22.CFrame:ToObjectSpace(v23.CFrame)
				weld.Parent = v22
			end
		end

		v22.Name = "Handle"
		return v22, tbl15
	end

	local function fn70(arg, arg2)
		local vector2 = Vector3.new(0, 0, 0)
		local vector3 = Vector3.new(0, 0, 0)

		for i, v22 in ipairs(arg2) do
			if v22 ~= arg and v22.Transparency < 0.95 then
				local n9 = v22.Size / 2
				local tbl15 = {-1, 1}
				local v23 = vector2
				local v24 = vector3

				for i2, v25 in ipairs(tbl15) do
					for i3, v26 in ipairs({-1, 1}) do
						for i4, v27 in ipairs({-1, 1}) do
							local v28 = arg.CFrame:PointToObjectSpace(v22.CFrame:PointToWorldSpace(Vector3.new(n9.X * v25, n9.Y * v26, n9.Z * v27)))
							v23, v24 = v23:Min(v28), v24:Max(v28)
						end
					end
				end

				vector2 = v23
				vector3 = v24
			end
		end

		local n9 = vector3 - vector2
		local v22 = if n9.X >= n9.Y and n9.X >= n9.Z then Vector3.new(vector3.X >= -vector2.X and 1 or -1, 0, 0) else if n9.Y >= n9.Z then Vector3.new(0, vector3.Y >= -vector2.Y and 1 or -1, 0) else Vector3.new(0, 0, vector3.Z >= -vector2.Z and 1 or -1)
		local vector4 = Vector3.new(1, 0, 0)
		local v23 = if math.abs(v22.X) > 0.5 then n9.Z >= n9.Y and Vector3.new(0, 0, 1) or Vector3.new(0, 1, 0) else if math.abs(v22.Z) > 0.5 then n9.X >= n9.Y and Vector3.new(1, 0, 0) or Vector3.new(0, 1, 0) else vector4
		local n10 = -math.min(vector2:Dot(v22), vector3:Dot(v22))
		return CFrame.fromMatrix(Vector3.new(0, 0, 0), v23, v22), math.max(0, n10 - 0.6)
	end

	tbl13.updateBack = function()
		local backpack = localPlayer:FindFirstChild("Backpack")

		for k, back in pairs(tbl13.backs) do
			back(k == tbl13.backRod and backpack ~= nil and k.Parent == backpack)
		end

		task.defer(tbl13.refreshQuality)
	end

	tbl13.refreshQuality = function()
		local flag6 = false
		local character = localPlayer.Character

		if character then
			for i, child in ipairs(character:GetChildren()) do
				if child:IsA("Tool") and child:GetAttribute("SenaVisual") or child.Name == "SenaVisualBack" then
					flag6 = true
					break
				end
			end
		end

		if next(tbl13.remote) ~= nil then
			flag6 = true
		end

		pcall(function()
			if flag6 then
				settings().Rendering.QualityLevel = Enum.QualityLevel.Level10
			elseif senaV4Config.StartupBoost then
				settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
			end
		end)
	end

	local function fn71(arg, arg2, arg3)
		local n9 = Vector3.new(1, 1, 1) * 1000000000
		local n10 = -Vector3.new(1, 1, 1) * 1000000000

		for i, v22 in ipairs(arg3) do
			local n11 = v22.Size / 2

			for i2, v23 in ipairs({-1, 1}) do
				for i3, v24 in ipairs({-1, 1}) do
					for i4, v25 in ipairs({-1, 1}) do
						local v26 = v22.CFrame:PointToWorldSpace(Vector3.new(n11.X * v23, n11.Y * v24, n11.Z * v25))
						n9, n10 = n9:Min(v26), n10:Max(v26)
					end
				end
			end
		end

		local n11 = n10 - n9
		local tbl15 = {}
		local n12 = 0
		local vector2 = Vector3.new(0, 0, 0)

		for i, v22 in ipairs(arg3) do
			if v22.Transparency < 0.95 then
				local n13 = math.max(v22.Size.X * v22.Size.Y * v22.Size.Z, 0.0001)
				local n14 = v22.Size / 2
				local tbl16 = {-1, 1}
				local n15 = 1 / 0

				for i2, v23 in ipairs(tbl16) do
					for i3, v24 in ipairs({-1, 1}) do
						for i4, v25 in ipairs({-1, 1}) do
							n15 = math.min(n15, v22.CFrame:PointToWorldSpace(Vector3.new(n14.X * v23, n14.Y * v24, n14.Z * v25)).Y)
						end
					end
				end

				table.insert(tbl15, {y = n15, vol = n13})
				n12, vector2 = n12 + n13, vector2 + v22.Position * n13
			end
		end

		local n13 = (n9 + n10) / 2 - Vector3.new(0, n11.Y / 2, 0)

		if n12 > 0 then
			table.sort(tbl15, function(arg4, arg5)
				return arg4.y < arg5.y
			end)

			local n14 = 0
			local y = tbl15[1].y

			for i, v22 in ipairs(tbl15) do
				n14 += v22.vol
				y = v22.y
				if n14 >= n12 * 0.1 then
					break
				end
			end

			local n15 = vector2 / n12
			n13 = Vector3.new(n15.X, y, n15.Z)
		end

		local function fn72(arg4)
			for i, v22 in ipairs(arg3) do
				if v22.Transparency < 0.95 then
					local v23 = v22.CFrame:PointToObjectSpace(arg4)
					local n14 = v22.Size / 2 + Vector3.new(0.6, 0.6, 0.6)
					if math.abs(v23.X) <= n14.X and (math.abs(v23.Y) <= n14.Y and math.abs(v23.Z) <= n14.Z) then
						return true
					end
				end
			end

			return false
		end

		n11 = 0

		while n11 < 150 do
			local n14 = n13 - Vector3.new(0, 1.6 + n11, 0)
			if not fn72(n14) and not fn72(n14 - Vector3.new(0, 1.8, 0)) then
				break
			end
			n11 += 1
		end

		local function fn73(arg4)
			local vector3 = Vector3.new(arg4.X, 0, arg4.Z)
			return vector3.Magnitude > 0.05 and vector3.Unit or nil
		end

		tbl15 = nil

		for i, v22 in ipairs(arg3) do
			if string.find(string.lower(v22.Name), "eye", 1, true) then
				tbl15 = fn73(v22.Position - n13)
				break
			end
		end

		if tbl15 then
		else
			for i, descendant in ipairs(arg:GetDescendants()) do
				local v22 = string.lower(descendant.Name)

				if descendant:IsA("Attachment") and (v22:find("head") or v22:find("eye") or v22:find("jaw") or v22:find("mouth")) then
					tbl15 = fn73(descendant.WorldPosition - n13)
					if tbl15 then
						break
					end
				end
			end
		end

		local vector3 = tbl15 or fn73(arg2.CFrame.LookVector) or Vector3.new(0, 0, 1)
		return {lift = n11, rootRel = CFrame.new(n13):ToObjectSpace(arg2.CFrame), turn = CFrame.lookAt(Vector3.new(0, 0, 0), vector3):Inverse()}
	end

	local function fn72(arg, arg2, arg3, arg4)
		local v22, v23 = fn68(arg, arg2)
		if not v22 then
			return nil, v23
		end
		local v24, v25

		if arg == "fish" then
			local num = tonumber(arg2.minKg)
			local num2 = tonumber(arg2.bigMaxKg) or tonumber(arg2.maxKg)
			local v26 = if num then if num > 0 then if num2 then math.max(1, (num + (num2 - num) * (arg3 or 0)) / num) else 1 else 1 else 1
			local num3 = tonumber(arg2.nativeLen)
			v24, v25 = fn69(v22, nil, if num3 then if num3 > 50 then v26 * 0.8 else v26 else v26)
		else
			v24, v25 = fn69(v22, nil, arg4 or 1)
		end

		if not v24 then
			v22:Destroy()
			return nil, "Empty model"
		end
		v24.Parent = v22
		local tbl15 = {model = v22, handle = v24, kind = arg}

		if arg == "fish" then
			tbl15.overhead = fn71(v22, v24, v25)
			v24.Name = "FishRoot"
		else
			tbl15.rodAxis, tbl15.gripShift = fn70(v24, v25)
			v24.Name = "RodRoot"
		end

		return tbl15
	end

	local function fn73(arg)
		local clone = arg.model:Clone()
		clone.Name = "SenaVisualBack"

		for i, descendant in ipairs(clone:GetDescendants()) do
			if descendant:IsA("BasePart") then
				descendant.Size = descendant.Size * n8
			elseif descendant:IsA("Weld") then
				descendant.C0 = CFrame.new(descendant.C0.Position * n8) * descendant.C0.Rotation
			elseif descendant:IsA("Attachment") then
				if not descendant.Parent:IsA("Bone") then
					descendant.Position = descendant.Position * n8
				end
			end
		end

		return clone, clone:FindFirstChild("RodRoot", true)
	end

	local function createWeld(parent, arg, part1, arg2)
		local upperTorso = parent and (parent:FindFirstChild("UpperTorso") or parent:FindFirstChild("Torso"))

		if upperTorso then
			if not part1 then
				return nil
			end
		else
			return nil
		end

		arg.Parent = parent
		local weld = Instance.new("Weld")
		weld.Part0 = upperTorso
		weld.Part1 = part1
		weld.C0 = v21 * CFrame.new(0, arg2.gripShift * n8, 0) * arg2.rodAxis:Inverse()
		weld.Parent = part1
		return weld
	end

	local function fn74(arg, part1, arg2)
		local rightHand = arg and arg:FindFirstChild("RightHand")
		local upperTorso = arg and arg:FindFirstChild("UpperTorso")
		if not (rightHand and upperTorso) then
			return function()
			end
		end
		local tbl15 = {}

		for k, v22 in pairs(tbl14) do
			local v23 = arg:FindFirstChild(k, true)

			if v23 and v23:IsA("Motor6D") then
				tbl15[v23] = v22
			end
		end

		local flag6, weld = true

		local function fn75()
			for k, v22 in pairs(tbl15) do
				k.Transform = v22
			end
		end

		local connection6 = RunService.PreSimulation:Connect(fn75)

		task.spawn(function()
			RunService.PostSimulation:Wait()
			RunService.PostSimulation:Wait()

			if flag6 then
				if not part1.Parent then
					return
				end
			else
				return
			end

			local n9 = upperTorso.CFrame:PointToObjectSpace(rightHand.Position) + Vector3.new(0, 0, -0.1)
			local unit2 = (Vector3.new(1, 0, 0) - unit * Vector3.new(1, 0, 0):Dot(unit)).Unit
			weld = Instance.new("Weld")
			weld.Part0 = upperTorso
			weld.Part1 = part1
			weld.C0 = CFrame.fromMatrix(n9, unit2, unit) * CFrame.new(0, arg2.gripShift, 0) * arg2.rodAxis:Inverse()
			weld.Parent = part1
		end)

		local function fn76()
			flag6 = false
			connection6:Disconnect()

			if weld then
				weld:Destroy()
			end
		end

		return fn76
	end

	local function fn75(arg, part1, arg2)
		local head = arg and arg:FindFirstChild("Head")
		if not head then
			return function()
			end
		end
		local overhead = arg2.overhead
		local weld = Instance.new("Weld")
		weld.Part0 = head
		weld.Part1 = part1
		weld.C0 = CFrame.new(0, head.Size.Y / 2 + 1 + overhead.lift, 0) * overhead.turn * overhead.rootRel
		weld.Parent = part1
		local cframe = CFrame.Angles(3.141592653589793, 0, 0)
		local rightShoulder = arg:FindFirstChild("RightShoulder", true)
		local leftShoulder = arg:FindFirstChild("LeftShoulder", true)
		local rightElbow = arg:FindFirstChild("RightElbow", true)
		local leftElbow = arg:FindFirstChild("LeftElbow", true)

		local function fn76()
			if rightShoulder then
				rightShoulder.Transform = cframe * CFrame.Angles(0, 0, -0.20943951023931956)
			end

			if leftShoulder then
				leftShoulder.Transform = cframe * CFrame.Angles(0, 0, 0.20943951023931956)
			end

			if rightElbow then
				rightElbow.Transform = CFrame.new()
			end

			if leftElbow then
				leftElbow.Transform = CFrame.new()
			end
		end

		local connection6 = RunService.PreSimulation:Connect(fn76)

		return function()
			connection6:Disconnect()
			weld:Destroy()
		end
	end

	local function createTool(arg, arg2)
		local v22, v23 = fn72(arg, arg2, tbl13.fishWeight, tbl13.rodScale)
		if not v22 then
			return nil, v23
		end
		local model = v22.model
		local handle = v22.handle
		local tool = Instance.new("Tool")
		tool.Name = arg2.name
		tool.CanBeDropped = false
		tool.RequiresHandle = false
		tool:SetAttribute("SenaVisual", arg)

		if arg == "fish" then
			tool:SetAttribute("ItemType", "Phone")
			tool.ToolTip = tostring(arg2.tier or "Fish")
		else
			tool.ToolTip = "Rod"
		end

		if arg2.icon then
			tool.TextureId = arg2.icon
		end

		local v24, v25, v26, v27

		if arg == "rods" then
			v26, v27 = fn73(v22)
		else
			v26, v27 = v24, v25
		end

		for i, child in ipairs(model:GetChildren()) do
			child.Parent = tool
		end

		model:Destroy()

		local function fn76()
			task.defer(tbl13.refreshQuality)
		end

		tool.Equipped:Connect(fn76)

		local function fn77()
			task.defer(tbl13.refreshQuality)
		end

		tool.Unequipped:Connect(fn77)
		local v28

		if arg == "rods" then
			local v29

			tbl13.backs[tool] = function(arg3)
				local character = localPlayer.Character

				if arg3 then
					if character then
						if v26.Parent ~= character then
							if v29 then
								v29:Destroy()
							end

							v29 = createWeld(character, v26, v27, v22)
						end
					else
						v26.Parent = nil
					end
				else
					v26.Parent = nil
				end
			end

			local function fn78()
				tbl13.backs[tool] = nil
				v26:Destroy()
			end

			tool.Destroying:Connect(fn78)

			tool.Equipped:Connect(function()
				tbl13.backRod = tool
				tbl13.updateBack()

				if v28 then
					v28()
				end

				v28 = fn74(tool.Parent, handle, v22)
			end)

			tool.Unequipped:Connect(function()
				if v28 then
					v28()
					v28 = nil
				end

				tbl13.backRod = tool
				task.defer(tbl13.updateBack)
			end)
		else
			tool.Equipped:Connect(function()
				if v28 then
					v28()
				end

				v28 = fn75(tool.Parent, handle, v22)
			end)

			tool.Unequipped:Connect(function()
				if v28 then
					v28()
					v28 = nil
				end
			end)
		end

		return tool
	end

	tbl13.spawn = function(arg, arg2)
		local v22 = fn67(arg, arg2)
		if not v22 then
			tbl13.status = "Pick an item first"
			return false
		end
		local backpack = localPlayer:FindFirstChild("Backpack")
		if not backpack then
			tbl13.status = "Backpack not ready"
			return false
		end
		local v23 = backpack:FindFirstChild(v22.name)
		if v23 and v23:GetAttribute("SenaVisual") then
			tbl13.status = v22.name .. " is already in your backpack"
			return true
		end
		tbl13.status = "Loading " .. v22.name .. "..."
		local v24, v25 = createTool(arg, v22)
		if not v24 then
			tbl13.status = v22.name .. ": " .. tostring(v25)
			return false
		end
		v24.Parent = backpack

		if arg == "rods" then
			tbl13.backRod = v24
			tbl13.updateBack()
		end

		tbl13.spawned[arg .. "|" .. v22.name] = {kind = arg, label = v22.name}
		tbl13.status = v22.name .. " added to your backpack"
		return true
	end

	tbl13.respawn = function(arg)
		local tbl15 = {}

		for k, v22 in pairs(tbl13.spawned) do
			if v22.kind == arg then
				tbl15[k] = v22
			end
		end

		for k, v22 in pairs(tbl15) do
			for i, v23 in ipairs({localPlayer:FindFirstChild("Backpack"), localPlayer.Character}) do
				local v24 = v23 and v23:FindFirstChild(v22.label)

				if v24 and (v24:IsA("Tool") and v24:GetAttribute("SenaVisual")) then
					v24:Destroy()
				end
			end

			tbl13.spawn(v22.kind, v22.label)
		end
	end

	tbl13.clear = function()
		tbl13.spawned = {}

		for i, v22 in ipairs({localPlayer:FindFirstChild("Backpack"), localPlayer.Character}) do
			if v22 then
				for i2, child in ipairs(v22:GetChildren()) do
					if child:IsA("Tool") and child:GetAttribute("SenaVisual") then
						child:Destroy()
					end
				end
			end
		end

		tbl13.status = "Removed all visual items"
		task.defer(tbl13.refreshQuality)
	end

	local function fn76(arg)
		local v22 = tbl13.remote[arg]
		if not v22 then
			return
		end
		tbl13.remote[arg] = nil

		for i, v23 in ipairs(v22.cleanup) do
			pcall(v23)
		end
	end

	local function fn77(arg)
		local v22, v23, v24 = string.match(arg or "", "^(%a+)|([^|]+)|?(.*)$")
		return v22, v23, tonumber(v24)
	end

	local function fn78(arg, arg2, arg3)
		local playerByUserId = Players:GetPlayerByUserId(tonumber(arg) or 0)
		local character = playerByUserId and playerByUserId.Character
		if not character then
			fn76(arg)
			return
		end
		local str4 = arg2 .. "#" .. arg3
		local v22 = tbl13.remote[arg]
		if v22 and (v22.key == str4 and v22.char == character) then
			return
		end
		fn76(arg)
		local tbl15 = {key = str4, char = character, cleanup = {}}
		tbl13.remote[arg] = tbl15
		local v23, v24, v25 = fn77(arg2)
		local flag6 = (v23 == "rods" or v23 == "fish") and fn67(v23, v24) or nil

		if flag6 then
			local v26 = fn72(v23, flag6, v23 == "fish" and (v25 or 0) or 0, v23 == "rods" and (v25 or 1) or 1)

			if v26 and tbl13.remote[arg] == tbl15 and character.Parent then
				v26.model.Name = "SenaVisualRemote"
				v26.model.Parent = character
				table.insert(tbl15.cleanup, (v23 == "rods" and fn74 or fn75)(character, v26.handle, v26))

				table.insert(tbl15.cleanup, function()
					v26.model:Destroy()
				end)
			elseif v26 then
				v26.model:Destroy()
			end
		end

		v25, str4 = fn77(arg3)
		local rods = v25 == "rods" and fn67("rods", str4) or nil

		if rods and tbl13.remote[arg] == tbl15 then
			local rods2 = fn72("rods", rods, 0, 1)

			if rods2 and tbl13.remote[arg] == tbl15 and character.Parent then
				local v26, v27 = fn73(rods2)
				rods2.model:Destroy()
				createWeld(character, v26, v27, rods2)

				table.insert(tbl15.cleanup, function()
					v26:Destroy()
				end)
			elseif rods2 then
				rods2.model:Destroy()
			end
		end

		task.defer(tbl13.refreshQuality)
	end

	task.spawn(function()
		while fn2() do
			local n9 = 6

			local function fn79()
				if #Players:GetPlayers() <= 1 then
					for k in pairs(tbl13.remote) do
						fn76(k)
					end

					return
				end

				local senaBackend = genv.SenaBackend or {}
				local api = senaBackend.Api or "https://senahub.xyz/api"
				local str4 = ""
				local str5 = ""
				local character = localPlayer.Character

				if character then
					for i, child in ipairs(character:GetChildren()) do
						local attribute = child:IsA("Tool") and child:GetAttribute("SenaVisual")
						if attribute then
							str4 = attribute .. "|" .. child.Name .. "|" .. tostring(attribute == "fish" and tbl13.fishWeight or tbl13.rodScale)
							break
						end
					end

					str5 = if character:FindFirstChild("SenaVisualBack") then if tbl13.backRod then "rods|" .. tbl13.backRod.Name else str5 else str5
				end

				local data = HttpService:JSONDecode(game:HttpGet(string.format("%s/vstate?key=%s&job=%s&uid=%d&held=%s&back=%s", api, HttpService:UrlEncode(senaBackend.Key or "sena_20VvixjHsd1OPPwgHYJAstpM"), HttpService:UrlEncode(game.JobId), localPlayer.UserId, HttpService:UrlEncode(str4), HttpService:UrlEncode(str5)), true))

				if type(data) ~= "table" then
					return
				elseif data.ok ~= true then
					return
				end

				n9 = tonumber(data.poll) or 4
				local tbl15 = {}

				for k, v22 in pairs(data.players or {}) do
					local str6 = tostring(k)
					tbl15[str6] = true
					fn78(str6, tostring(v22.held or ""), tostring(v22.back or ""))
				end

				for k in pairs(tbl13.remote) do
					if not tbl15[k] then
						fn76(k)
					end
				end
			end

			pcall(fn79)
			task.wait(n9)
		end

		for k in pairs(tbl13.remote) do
			fn76(k)
		end
	end)

	local function fn79()
		if not fn2() then
			return
		end
		task.wait(1.5)

		for k, v22 in pairs(tbl13.spawned) do
			pcall(tbl13.spawn, v22.kind, v22.label)
		end
	end

	localPlayer.CharacterAdded:Connect(fn79)
	return tbl13
end)()

local tbl13 = {}

do
	local HttpService = game:GetService("HttpService")
	tbl13.hopFailed = false
	tbl13.lastHopAt = 0

	pcall(function()
		local function fn65(arg)
			if arg == localPlayer then
				tbl13.hopFailed = true
			end
		end

		TeleportService.TeleportInitFailed:Connect(fn65)
	end)

	tbl13.collectServers = function(arg)
		local tbl14 = {}
		local str3 = ""

		for i = 1, 3, 1 do
			local ok, result = pcall(function()
				local str4 = ("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100&excludeFullGames=true"):format(game.PlaceId)
				return HttpService:JSONDecode(game:HttpGet(if str3 ~= "" then str4 .. "&cursor=" .. str3 else str4))
			end)

			if ok then
				if type(result) ~= "table" then
					break
				end
			else
				break
			end

			for i2, v21 in ipairs(result.data or {}) do
				if tostring(v21.id) ~= game.JobId and (v21.playing and (v21.maxPlayers and (v21.playing < v21.maxPlayers and (if arg then v21.playing <= arg else not arg)))) then
					tbl14[#tbl14 + 1] = {id = tostring(v21.id), playing = v21.playing}
				end
			end

			str3 = result.nextPageCursor or ""
			if str3 == "" then
				break
			end
		end

		table.sort(tbl14, function(arg2, arg3)
			return arg2.playing < arg3.playing
		end)

		return tbl14
	end

	tbl13.hopToList = function(arg)
		if type(arg) ~= "table" then
			return false
		elseif #arg == 0 then
			return false
		end

		for i, v21 in ipairs(arg) do
			tbl13.hopFailed = false

			if pcall(function()
				TeleportService:TeleportToPlaceInstance(game.PlaceId, v21.id, localPlayer)
			end) then
				local now = os.clock()

				while true do
					local hopFailed = tbl13.hopFailed
					if not (if hopFailed then not hopFailed else os.clock() - now < 6) then
						break
					end
					task.wait(0.25)
				end

				if not tbl13.hopFailed then
					return true
				end
			end

			task.wait(0.3)
		end

		return false
	end

	tbl13.hopEmptiest = function()
		return tbl13.hopToList(tbl13.collectServers(nil))
	end

	tbl13.privateStatus = "Pick a max player count, then Hop Server Now."

	tbl13.privateMax = function()
		return math.max(1, math.floor(tonumber(tostring(senaV4Config.PrivateServerMax or "2"):match("%d+")) or 2))
	end

	tbl13.findPrivateTargets = function()
		local v21 = tbl13.privateMax()
		local v22 = tbl13.collectServers(nil)
		if #v22 == 0 then
			return nil
		end
		local tbl14 = {}

		for i, v23 in ipairs(v22) do
			if v23.playing + 1 <= v21 then
				tbl14[#tbl14 + 1] = v23
			end
		end

		if #tbl14 == 0 then
			local playing = v22[1].playing

			for i, v23 in ipairs(v22) do
				if v23.playing == playing then
					tbl14[#tbl14 + 1] = v23
				end
			end
		end

		local tbl15 = {}

		while #tbl14 > 0 and #tbl15 < 5 do
			tbl15[#tbl15 + 1] = table.remove(tbl14, math.random(1, #tbl14))
		end

		return tbl15
	end

	tbl13.hopPrivateOnce = function()
		local v21 = tbl13.privateMax()
		local n8 = #Players:GetPlayers()
		if n8 <= v21 then
			tbl13.privateStatus = "This server is good (" .. n8 .. " player(s), max " .. v21 .. ")."
			return false
		end

		if tbl13.hubBusy() then
			tbl13.privateStatus = "Waiting until you finish stealing..."
			return false
		end
		tbl13.privateStatus = "Searching for a quieter server..."
		local v22 = tbl13.findPrivateTargets()

		if v22 then
			if #v22 == 0 then
				tbl13.privateStatus = "Could not load the server list. Try again."
				return false
			end
		else
			tbl13.privateStatus = "Could not load the server list. Try again."
			return false
		end

		tbl13.privateStatus = "Teleporting..."
		tbl13.lastHopAt = os.clock()
		if tbl13.hopToList(v22) then
			return true
		end
		tbl13.privateStatus = "Teleport failed. Trying again soon."
		return false
	end

	tbl13.startPrivateAutoHop = function()
		if tbl13.privateAutoRunning then
			return
		end
		tbl13.privateAutoRunning = true

		task.spawn(function()
			while fn2() and senaV4Config.PrivateServerAuto do
				local v21 = tbl13.privateMax()

				if #Players:GetPlayers() <= v21 then
					tbl13.privateStatus = "Good server found. Waiting..."
					task.wait(3)
				else
					tbl13.hopPrivateOnce()
					task.wait(5)
				end
			end

			tbl13.privateAutoRunning = false

			if not senaV4Config.PrivateServerAuto then
				tbl13.privateStatus = "Auto hop stopped."
			end
		end)
	end

	tbl13.hubBusy = function()
		if senaV4Config.IsPlacing then
			return true
		end
		local senaV4EggRuntime = genv.__SenaV4EggRuntime

		if senaV4EggRuntime then
			if senaV4EggRuntime.running then
				return true
			elseif senaV4EggRuntime.travelBusy then
				return true
			elseif senaV4EggRuntime.carry then
				if senaV4EggRuntime.carry.active then
					return true
				end
			end
		end

		local senaV4PlayerSteal = genv.__SenaV4PlayerSteal
		if senaV4PlayerSteal and senaV4PlayerSteal.running then
			return true
		end
		return false
	end

	tbl13.startHopLoop = function()
		if tbl13.hopLoopRunning then
			return
		end
		tbl13.hopLoopRunning = true

		task.spawn(function()
			while fn2() do
				task.wait(2)

				if senaV4Config.HopNoMatch and not tbl13.hubBusy() then
					local n8 = tonumber(senaV4Config.HopCooldown) or 5

					if os.clock() - tbl13.lastHopAt > n8 then
						local senaV4EggRuntime = genv.__SenaV4EggRuntime
						local matching = senaV4EggRuntime and senaV4EggRuntime.stats and senaV4EggRuntime.stats.matching or 0

						if senaV4Config.AutoSteal and (matching <= 0 and not fn31()) then
							tbl13.lastHopAt = os.clock()
							tbl13.hopEmptiest()
						end
					end
				end
			end

			tbl13.hopLoopRunning = false
		end)
	end

	tbl13.startAntiTreadmillLoop = function()
		if tbl13.antiTreadmillRunning then
			return
		end
		tbl13.antiTreadmillRunning = true

		task.spawn(function()
			while fn2() do
				if senaV4Config.AntiTreadmill then
					local senaV4TreadmillManager = genv.__SenaV4TreadmillManager

					pcall(function()
						if senaV4TreadmillManager and senaV4TreadmillManager.activeTreadmill ~= nil then
							senaV4TreadmillManager:_cancelIdle(true)
							senaV4TreadmillManager:_requestUnequip()
						end
					end)

					local character = localPlayer.Character
					local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

					if humanoidRootPart and humanoidRootPart.Anchored then
						pcall(function()
							humanoidRootPart.Anchored = false
						end)
					end
				end

				task.wait(0.3)
			end

			tbl13.antiTreadmillRunning = false
		end)
	end

	tbl13.setBackpackRates = function(arg)
		senaV4Config.BackpackRateEsp = arg == true
		if tbl13.backpackRatesRunning then
			return
		end
		tbl13.backpackRatesRunning = true

		task.spawn(function()
			local EggRecords, Save

			pcall(function()
				EggRecords = require(ReplicatedStorage.Shared.Util.EggRecords)
				Save = require(ReplicatedStorage.Shared.Save)
			end)

			while fn2() do
				local scrollingFrame

				pcall(function()
					scrollingFrame = localPlayer.PlayerGui.BackpackGui.Backpack.Main.Inventory.ScrollingFrame
				end)

				local senaV4Webhook = genv.__SenaV4Webhook
				local senaDiscord = scrollingFrame and scrollingFrame.Parent:FindFirstChild("SenaDiscord")

				if scrollingFrame and senaV4Config.BackpackRateEsp and not senaDiscord then
					local textLabel = Instance.new("TextLabel")
					textLabel.Name = "SenaDiscord"
					textLabel.BackgroundTransparency = 1
					textLabel.Position = UDim2.new(0.34, 0, 0.017, 0)
					textLabel.Size = UDim2.new(0.3, 0, 0.09, 0)
					textLabel.Font = Enum.Font.GothamBlack
					textLabel.Text = "discord.gg/senahub"
					textLabel.TextScaled = true
					textLabel.TextXAlignment = Enum.TextXAlignment.Left
					textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
					textLabel.TextStrokeTransparency = 0
					textLabel.ZIndex = 40
					textLabel.Parent = scrollingFrame.Parent
				elseif senaDiscord then
					if not senaV4Config.BackpackRateEsp then
						senaDiscord:Destroy()
					end
				end

				if scrollingFrame then
					local tbl14 = {}

					if senaV4Config.BackpackRateEsp and EggRecords and Save and senaV4Webhook then
						local ok = (Save.Peek or Save.Get)()

						for k, v21 in pairs(ok and ok.EggInventory or {}) do
							ok, k = pcall(EggRecords.DisplayNameWithWeight, v21)

							if ok and type(k) == "string" then
								tbl14[k] = tbl14[k] or {}
								table.insert(tbl14[k], v21)
							end
						end
					end

					local tbl15 = {}

					for i, child in ipairs(scrollingFrame:GetChildren()) do
						local toolName = child:IsA("GuiButton") and child:FindFirstChild("ToolName")

						if toolName then
							local text = toolName.Text
							local n8 = (tbl15[text] or 0) + 1
							local v21 = tbl14[text] and tbl14[text][n8]
							local senaRate = child:FindFirstChild("SenaRate")

							if v21 then
								tbl15[text] = n8

								if senaRate then
								else
									senaRate = Instance.new("TextLabel")
									senaRate.Name = "SenaRate"
									senaRate.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
									senaRate.BackgroundTransparency = 0.35
									senaRate.BorderSizePixel = 0
									senaRate.Position = UDim2.new(0.04, 0, 0, 3)
									senaRate.Size = UDim2.new(0.92, 0, 0.24, 0)
									senaRate.Font = Enum.Font.GothamBlack
									senaRate.TextScaled = true
									senaRate.TextColor3 = Color3.fromRGB(73, 211, 31)
									senaRate.TextStrokeTransparency = 0
									senaRate.ZIndex = 40
									local uiCorner = Instance.new("UICorner")
									uiCorner.CornerRadius = UDim.new(0, 6)
									uiCorner.Parent = senaRate
									local uiTextSizeConstraint = Instance.new("UITextSizeConstraint")
									uiTextSizeConstraint.MaxTextSize = 20
									uiTextSizeConstraint.Parent = senaRate
									senaRate.Parent = child
								end

								senaRate.Text = senaV4Webhook.compact(senaV4Webhook.rateOf(v21)) .. "/s"
							elseif senaRate then
								senaRate:Destroy()
							end
						end
					end
				end

				if not senaV4Config.BackpackRateEsp then
					break
				end
				task.wait(1)
			end

			tbl13.backpackRatesRunning = false
		end)
	end
end;

(function()
	local senaV4ScrambleTradeIn, directory, AssetItems, AssetEarnings, Save = {status = "Disabled", banner = "Unknown", rotation = 0, pity = 0, pityMax = 100, free = 0, trades = 0, demands = "-", stock = "-", ready = 0, total = 3, missing = "None", cache = nil, cacheAt = 0, lastReroll = 0}

	pcall(function()
		directory = require(ReplicatedStorage.Data.Assets).Directory
	end)

	pcall(function()
		AssetItems = require(ReplicatedStorage.Shared.Util.AssetItems)
	end)

	pcall(function()
		AssetEarnings = require(ReplicatedStorage.Shared.Util.AssetEarnings)
	end)

	pcall(function()
		Save = require(ReplicatedStorage.Shared.Save)
	end)

	local function fn65()
		local ok, result = pcall(function()
			return require(ReplicatedStorage.Shared.Remotes).ScrambleTradeIn
		end)

		return ok and result or nil
	end

	local function fn66()
		return senaV4Config.ScrambleTradeInTrade or senaV4Config.ScrambleTradeInReroll
	end

	local function fn67(arg)
		return ((tostring(arg or ""):lower():match("^%s*(.-)%s*$") or ""):gsub("%s*egg$", ""))
	end

	local function matches(arg, arg2)
		if type(arg) ~= "string" then
			return false
		elseif type(arg2) ~= "string" then
			return false
		end

		if arg == arg2 then
			return true
		end
		local v21 = fn67(arg)
		local v22 = fn67(arg2)
		return v21 ~= "" and v21 == v22
	end

	senaV4ScrambleTradeIn.matches = matches

	local function fn68(arg)
		local v21 = directory and directory[arg]
		local displayName = type(v21) == "table" and v21.DisplayName
		return type(displayName) == "string" and displayName ~= "" and displayName or tostring(arg)
	end

	local function fn69(arg, arg2)
		local tbl14 = {}

		for i, v21 in ipairs(arg) do
			tbl14[i] = fn68(v21)
		end

		return table.concat(tbl14, arg2)
	end

	senaV4ScrambleTradeIn.state = function(arg)
		local now = os.clock()
		if not arg and (senaV4ScrambleTradeIn.cache and now - senaV4ScrambleTradeIn.cacheAt < 12) then
			return senaV4ScrambleTradeIn.cache
		end
		local v21 = fn65()
		if not (v21 and v21.AskState) then
			return senaV4ScrambleTradeIn.cache
		end

		local ok, cache = pcall(function()
			return v21.AskState:InvokeServer()
		end)

		if ok and type(cache) == "table" then
			senaV4ScrambleTradeIn.cache = cache
			senaV4ScrambleTradeIn.cacheAt = now
		end

		return senaV4ScrambleTradeIn.cache
	end

	local function fn70(arg)
		local scrambleTradeInBanners = senaV4Config.ScrambleTradeInBanners

		if type(scrambleTradeInBanners) ~= "table" then
			return true
		elseif #scrambleTradeInBanners == 0 then
			return true
		end

		if arg then
			if not arg.BannerId then
				return true
			end
		else
			return true
		end

		local v21 = fn67(arg.BannerId)
		local v22 = fn67(arg.BannerDisplayName)

		for i, scrambleTradeInBanner in ipairs(scrambleTradeInBanners) do
			local v23 = fn67(scrambleTradeInBanner)

			if v23 == v21 then
				return true
			elseif v22 ~= "" then
				if v23 == v22 then
					return true
				end
			end
		end

		return false
	end

	local function fn71(arg)
		return arg and type(arg.Requirements) == "table" and arg.Requirements or {}
	end

	local function fn72()
		local v21

		if Save then
			pcall(function()
				v21 = (Save.Peek or Save.Get)()
			end)
		end

		return v21
	end

	local function fn73(arg)
		local tbl14 = {}
		if not arg then
			return tbl14
		end

		for k, v21 in pairs(arg.EggInventory or {}) do
			if type(v21) == "table" and (v21.AssetCategory and (v21.Placement == nil and not v21.IsFavorite)) then
				tbl14[#tbl14 + 1] = {uid = k, category = v21.AssetCategory}
			end
		end

		return tbl14
	end

	local function selectEggs(arg, arg2)
		local v21 = fn73(arg2)
		local tbl14 = {}
		local tbl15 = {}
		local tbl16 = {}

		for i, v22 in ipairs(arg) do
			arg2 = nil

			for i2, v23 in ipairs(v21) do
				if not tbl14[v23.uid] and matches(v23.category, v22) then
					arg2 = v23
					break
				end
			end

			if arg2 then
				tbl14[arg2.uid] = true
				tbl15[i] = arg2
			else
				tbl16[#tbl16 + 1] = v22
			end
		end

		return tbl15, tbl16, v21
	end

	senaV4ScrambleTradeIn.selectEggs = selectEggs

	local function fn74(arg, arg2, arg3)
		local tbl14 = {}
		local tbl15 = {}

		for i, v21 in ipairs(arg) do
			if not tbl14[v21] then
				tbl15[#tbl15 + 1] = v21
			end

			tbl14[v21] = (tbl14[v21] or 0) + 1
		end

		local tbl16 = {}

		for i, v21 in ipairs(tbl15) do
			i = 0

			for i2, v22 in ipairs(arg3) do
				i = if matches(v22.category, v21) then i + 1 else i
			end

			tbl16[#tbl16 + 1] = string.format("%s %d/%d", fn68(v21), math.min(i, tbl14[v21]), tbl14[v21])
		end

		return table.concat(tbl16, "  ")
	end

	local function teleport()
		local humanoidRootPart = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
		if not humanoidRootPart then
			return false
		end
		local v21 = fn()
		local machines = v21 and v21:FindFirstChild("Machines")
		local riftMachine = machines and machines:FindFirstChild("RiftMachine")
		local machine = riftMachine and riftMachine:FindFirstChild("Machine")
		humanoidRootPart.CFrame = machine and machine:IsA("BasePart") and machine.CFrame * CFrame.new(0, machine.Size.Y * 0.5 + 3, 4) or CFrame.new(533.4, 72, -330)
		humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
		return true
	end

	senaV4ScrambleTradeIn.teleport = teleport

	senaV4ScrambleTradeIn.openUI = function()
		return (pcall(function()
			require(ReplicatedStorage.Client.Tabs).Activate("DrScrambleTradeIn")
		end))
	end

	local function fn75(arg, arg2)
		local v21 = fn65()
		if not (v21 and v21.AskTradeIn) then
			return false, "Trade remote unavailable"
		end
		local tbl14 = {}

		for i = 1, #arg, 1 do
			local v22 = arg2[i]
			if not v22 then
				return false, "Requirements incomplete"
			end
			tbl14[#tbl14 + 1] = v22.uid
		end

		senaV4ScrambleTradeIn.status = "Placing eggs into Dr Scramble's Lab"

		arg2, arg = pcall(function()
			return v21.AskTradeIn:InvokeServer(tbl14)
		end)

		if (if arg2 then arg == false else not arg2) and teleport() then
			task.wait(0.3)

			arg2, arg = pcall(function()
				return v21.AskTradeIn:InvokeServer(tbl14)
			end)
		end

		if if arg2 then arg == false else not arg2 then
			return false, tostring(arg or "Trade rejected")
		end

		pcall(function()
			if v21.AskFinishReveal then
				v21.AskFinishReveal:InvokeServer()
			end
		end)

		senaV4ScrambleTradeIn.trades = senaV4ScrambleTradeIn.trades + 1
		senaV4ScrambleTradeIn.state(true)
		return true
	end

	senaV4ScrambleTradeIn.tradeOnce = function()
		local v21 = fn71(senaV4ScrambleTradeIn.state(true))
		if #v21 < 3 then
			return false, "Cannot read the recipe"
		end
		local v22, v23 = selectEggs(v21, fn72())
		if #v23 > 0 then
			return false, "Missing: " .. fn69(v23, ", ")
		end
		return fn75(v21, v22)
	end

	senaV4ScrambleTradeIn.reroll = function()
		local v21 = senaV4ScrambleTradeIn.state(false)
		local num = tonumber(v21 and v21.FreeRefreshesRemaining)

		if num then
			if num <= 0 then
				return false, "No free rerolls left"
			end
		else
			return false, "No free rerolls left"
		end

		local v22 = fn65()
		if not (v22 and v22.AskRefresh) then
			return false, "Refresh remote unavailable"
		end

		if not pcall(function()
			return v22.AskRefresh:InvokeServer()
		end) then
			return false, "Reroll failed"
		end
		senaV4ScrambleTradeIn.state(true)
		return true
	end

	local function fn76(arg)
		local senaV4EggRuntime = genv.__SenaV4EggRuntime

		if senaV4EggRuntime and type(senaV4EggRuntime.setScrambleWants) == "function" then
			pcall(senaV4EggRuntime.setScrambleWants, senaV4EggRuntime, arg or {}, false)
		end
	end

	local function clearSteal()
		fn76({})
	end

	senaV4ScrambleTradeIn.clearSteal = clearSteal

	senaV4ScrambleTradeIn.tick = function()
		local v21 = senaV4ScrambleTradeIn.state(true)

		if not v21 then
			senaV4ScrambleTradeIn.status = "Trade-In state unavailable"
			clearSteal()
			return
		end

		if v21.Unlocked == false then
			senaV4ScrambleTradeIn.status = "Dr Scramble Trade-In is locked"
			clearSteal()
			return
		end

		senaV4ScrambleTradeIn.banner = tostring(v21.BannerDisplayName or v21.BannerId or "Unknown")
		senaV4ScrambleTradeIn.rotation = math.max(0, math.floor(tonumber(v21.SecondsUntilRotation) or 0))
		senaV4ScrambleTradeIn.pity = tonumber(v21.PityCount) or 0
		senaV4ScrambleTradeIn.pityMax = tonumber(v21.PityThreshold) or 100
		senaV4ScrambleTradeIn.free = tonumber(v21.FreeRefreshesRemaining) or 0

		if v21.PendingReward then
			senaV4ScrambleTradeIn.status = "Finishing reward"
			local v22 = fn65()

			pcall(function()
				if v22 and v22.AskFinishReveal then
					v22.AskFinishReveal:InvokeServer()
				end
			end)

			senaV4ScrambleTradeIn.cache = nil
			return
		end

		if not fn70(v21) then
			senaV4ScrambleTradeIn.status = "Waiting for banner (now: " .. senaV4ScrambleTradeIn.banner .. ")"
			senaV4ScrambleTradeIn.demands = "-"
			senaV4ScrambleTradeIn.stock = "-"
			senaV4ScrambleTradeIn.ready = 0
			senaV4ScrambleTradeIn.missing = "None"
			clearSteal()
			return
		end

		local v22 = fn71(v21)
		local recipeSig = tostring(v21.BannerId or "?") .. "|" .. table.concat(v22, ",")

		if recipeSig ~= senaV4ScrambleTradeIn.recipeSig then
			senaV4ScrambleTradeIn.recipeSig = recipeSig
			clearSteal()
		end

		senaV4ScrambleTradeIn.total = #v22
		senaV4ScrambleTradeIn.demands = #v22 > 0 and fn69(v22, " / ") or "-"

		if #v22 < 3 then
			senaV4ScrambleTradeIn.status = "Waiting for requirements"
			clearSteal()
			return
		end

		local v23 = fn72()
		local v24, v25, v26 = selectEggs(v22, v23)
		senaV4ScrambleTradeIn.stock = fn74(v22, v23, v26)
		senaV4ScrambleTradeIn.ready = #v22 - #v25
		senaV4ScrambleTradeIn.missing = #v25 > 0 and fn69(v25, ", ") or "None"

		if #v25 == 0 then
			clearSteal()

			if senaV4Config.ScrambleTradeInTrade then
				senaV4ScrambleTradeIn.status = "Requirements complete, placing + trading"
				recipeSig, v26 = fn75(v22, v24)
				senaV4ScrambleTradeIn.status = recipeSig and "Trade complete" or "Trade: " .. tostring(v26)
			else
				senaV4ScrambleTradeIn.status = "Ready to trade (Auto Trade-In is off)"
			end

			return
		end

		if senaV4Config.ScrambleTradeInTrade then
			fn76(v25)
		else
			clearSteal()
		end

		if senaV4Config.ScrambleTradeInReroll and (senaV4ScrambleTradeIn.free > 0 and os.clock() - senaV4ScrambleTradeIn.lastReroll > 3) then
			senaV4ScrambleTradeIn.lastReroll = os.clock()
			senaV4ScrambleTradeIn.status = "Rerolling the recipe"
			senaV4ScrambleTradeIn.reroll()
			return
		end

		senaV4ScrambleTradeIn.status = "Stealing required eggs: " .. senaV4ScrambleTradeIn.missing
	end

	task.spawn(function()
		while fn2() do
			if fn66() then
				local ok, result = pcall(senaV4ScrambleTradeIn.tick)

				if not ok then
					senaV4ScrambleTradeIn.status = "Trade-In error: " .. tostring(result)
				end
			else
				if senaV4ScrambleTradeIn.status ~= "Disabled" then
					senaV4ScrambleTradeIn.status = "Disabled"
				end

				clearSteal()
			end

			task.wait(10)
		end
	end)

	genv.__SenaV4ScrambleTradeIn = senaV4ScrambleTradeIn
end)();

(function()
	local Players2 = game:GetService("Players")
	local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
	local Workspace2 = game:GetService("Workspace")
	local localPlayer2 = Players2.LocalPlayer
	local Remotes = require(ReplicatedStorage2.Shared.Remotes)
	local Save = require(ReplicatedStorage2.Shared.Save)
	local ScrambleBossFlags = require(ReplicatedStorage2.Shared.Flags.ScrambleBossFlags)
	local scrambleBoss = Remotes.ScrambleBoss
	local index = {}
	index.__index = index
	local str3 = "auto_scramble_boss"
	local str4 = "ScrambleArena"
	local str5 = "ScrambleArenaPortal"
	local n8 = 0.05
	local n9 = 0.5
	local n10 = 1
	local n11 = 7
	local n12 = 250
	local n13 = 250
	local n14 = 225
	local n15 = 0.75
	local n16 = 13
	local n17 = 1.5
	local n18 = 1.5
	local n19 = 0.75
	local n20 = 0.08
	local n21 = 0.25
	local n22 = 18
	local n23 = 5
	local n24 = 10
	local n25 = 5
	local n26 = 3.25

	local function fn65(arg, arg2)
		if type(arg) ~= "table" then
			return arg2
		end

		if type(arg.Get) == "function" then
			local ok, result = pcall(arg.Get, arg)
			if ok and result ~= nil then
				return result
			end
		end

		local value = rawget(arg, "Value")
		if value ~= nil then
			return value
		end
		return arg2
	end

	local function fn66(arg)
		return Vector3.new(arg.X, 0, arg.Z)
	end

	local v21 = (function()
		local v21

		local function fn67()
			if v21 then
				return v21
			end
			local tbl14 = {}

			pcall(function()
				for i, child in ipairs(ReplicatedStorage2.Data.Gears.Configs:GetChildren()) do
					local ok, result = pcall(require, child)

					if ok and type(result) == "table" and type(result.BatControllerData) == "table" then
						for i2, v22 in ipairs({child.Name, result._id, result.DisplayName, result.ToolModel}) do
							if type(v22) == "string" then
								tbl14[v22:lower()] = true
							end
						end
					end
				end
			end)

			if next(tbl14) then
				v21 = tbl14
			end

			return tbl14
		end

		return function(arg)
			if arg then
				if not arg:IsA("Tool") then
					return false
				end
			else
				return false
			end

			if arg:GetAttribute("IsBat") == true then
				return true
			end
			local attribute = arg:GetAttribute("ItemType")
			if attribute ~= nil and attribute ~= "Gear" then
				return false
			end
			local v22 = fn67()
			local str6 = tostring(arg:GetAttribute("GearName") or ""):lower()
			local str7 = tostring(arg.Name or ""):gsub("%s*%[.-%]%s*$", ""):lower()

			if v22[str6] then
				return true
			elseif v22[str7] then
				return true
			end

			return attribute == "Gear" and (str6:find("bat", 1, true) ~= nil or str7:find("bat", 1, true) ~= nil)
		end
	end)()

	genv.__SenaV4IsBatTool = v21

	local function fn67(arg, arg2)
		if arg then
			if not arg:IsA("BasePart") then
				return 1 / 0
			end
		else
			return 1 / 0
		end

		local v22 = arg.CFrame:PointToObjectSpace(arg2)
		local n27 = arg.Size * 0.5
		local vector2 = Vector3.new(math.clamp(v22.X, -n27.X, n27.X), math.clamp(v22.Y, -n27.Y, n27.Y), math.clamp(v22.Z, -n27.Z, n27.Z))
		return (arg.CFrame:PointToWorldSpace(vector2) - arg2).Magnitude
	end

	local function fn68(arg)
		if not arg then
			return nil
		end
		local hitbox = arg:FindFirstChild("Hitbox", true)
		if hitbox and hitbox:IsA("BasePart") then
			return hitbox
		end

		for i, descendant in ipairs(arg:GetDescendants()) do
			if descendant:IsA("TouchTransmitter") and (descendant.Parent and descendant.Parent:IsA("BasePart")) then
				return descendant.Parent
			end
		end

		if arg:IsA("BasePart") then
			return arg
		end
		return arg:FindFirstChildWhichIsA("BasePart", true)
	end

	local function fn69()
		local get, tbl14 = type(Save) == "table" and (Save.Get or Save.Peek) or nil

		if get then
			local ok, result = pcall(get)
			tbl14 = if ok then if type(result) ~= "table" then {} else result else {}
		else
			tbl14 = {}
		end

		local scramble = type(tbl14.Scramble) == "table" and tbl14.Scramble or {}
		local str6 = tostring(fn65(ScrambleBossFlags.SamplesWalletId, "DrScrambleBoss"))
		local wallets = type(scramble.Wallets) == "table" and scramble.Wallets or {}
		local scrambleFinalHits = type(tbl14.ScrambleFinalHits) == "table" and tbl14.ScrambleFinalHits or {}
		return {mastery = math.max(tonumber(scramble.Mastery) or 0, 0), samples = math.max(tonumber(wallets[str6]) or 0, 0), walletId = str6, finalHits = math.max(tonumber(scrambleFinalHits.Total) or 0, 0), mecha = tbl14.MechaScramblerObtained == true}
	end

	index.new = function(coordinator, eggRuntime)
		local obj = setmetatable({}, index)
		obj.coordinator = coordinator
		obj.eggRuntime = eggRuntime
		obj.enabled = false
		obj.destroyed = false
		obj.worker = nil
		obj.operationToken = nil
		obj.listeners = {}
		obj.connections = {}
		obj.status = "Off"
		obj.rewardLabel = "--"
		obj.finalHitLabel = "--"
		obj.activeArena = nil
		obj.rewardBaseline = nil
		obj.cachedReward = fn69()
		obj.nextRewardPollAt = 0
		obj.defeatedAt = nil
		obj.rewardAcknowledged = false
		obj.exitRequested = false
		obj.lastPhase = ""
		obj.lastSwingAt = 0
		obj.swingSequence = 0
		obj.lastBatRequestAt = 0
		obj.lastEnterAttemptAt = 0
		obj.lastPortalTouchAt = 0
		obj.lastExitTouchAt = 0
		obj.lastGrabEscapeAt = 0
		obj.safePreflightReady = false
		obj.glideTravelActive = false
		obj.glideHoldActive = false
		obj.lastSnapshotSignature = nil

		table.insert(obj.connections, localPlayer2.CharacterAdded:Connect(function()
			obj:_restoreCharacterControl()

			if obj.enabled then
				obj:_setStatus("Respawned - rejoining boss")
			end
		end))

		obj:_ensureWorker()
		return obj
	end

	index._arena = function(arg)
		local v22 = Workspace2:FindFirstChild(str4)
		return v22 and v22:IsA("Model") and v22 or nil
	end

	index._portal = function(arg)
		return Workspace2:FindFirstChild(str5)
	end

	index._inArena = function(arg)
		if localPlayer2:GetAttribute("InScrambleArena") == true then
			return true
		end
		local v22 = arg:_arena()
		local attribute = v22 and v22:GetAttribute("Center")
		local humanoidRootPart = localPlayer2.Character and localPlayer2.Character:FindFirstChild("HumanoidRootPart")

		if humanoidRootPart then
			if not (typeof(attribute) == "Vector3") then
				return false
			end
		else
			return false
		end

		return (humanoidRootPart.Position - attribute).Magnitude < (tonumber(v22:GetAttribute("Radius")) or 450) + 80
	end

	index._isResetWallOpen = function(arg)
		local eggRuntime = arg.eggRuntime

		if eggRuntime and type(eggRuntime._wallOpen) == "function" then
			local ok, result = pcall(eggRuntime._wallOpen, eggRuntime)
			if ok then
				return result == true
			end
		end

		return true
	end

	index._eventPresent = function(arg)
		local v22 = arg:_arena()
		local str6 = v22 and tostring(v22:GetAttribute("Phase") or "") or ""
		local v23 = arg:_inArena()
		local flag6 = arg:_portal() ~= nil

		if v22 and str6 == "Defeated" then
			if v23 then
			elseif flag6 then
			else
				return false
			end
		end

		return v23 or flag6 or v22 ~= nil and str6 ~= "Defeated" or Workspace2:GetAttribute("Event_ScrambleBoss") == true
	end

	index.isFightPending = function(arg)
		local destroyed = arg.destroyed
		return (if destroyed then not destroyed else arg.enabled) and arg:_eventPresent()
	end

	index._countdown = function(arg)
		local serverTimeNow = Workspace2:GetServerTimeNow()
		local n27 = arg:_arena()
		local n28 = n27 and tonumber(n27:GetAttribute("SpawnsAt")) or 0
		if n27 and (tostring(n27:GetAttribute("Phase") or "") == "Waiting" and n28 > serverTimeNow) then
			return "Starts in", math.max(0, n28 - serverTimeNow)
		end

		if arg:_portal() then
			return "Portal", 0
		end

		if arg:_inArena() then
			return "Fight", 0
		elseif n27 then
			return "Fight", 0
		end

		local n29 = math.max(tonumber(fn65(ScrambleBossFlags.ScheduleIntervalSeconds, 1800)) or 1800, 1)
		n27 = math.ceil(serverTimeNow / n29) * n29
		local v22 = if n27 <= serverTimeNow + 0.01 then n27 + n29 else n27
		return "Starts in", math.max(0, v22 - serverTimeNow)
	end

	index._refreshReward = function(arg, arg2)
		if arg2 ~= true and os.clock() < arg.nextRewardPollAt then
			return arg.cachedReward
		end
		arg.nextRewardPollAt = os.clock() + n21
		arg.cachedReward = fn69()
		return arg.cachedReward
	end

	index._snapshot = function(arg)
		local v22 = arg:_arena()
		local str6, v23, v24 = v22 and tostring(v22:GetAttribute("Phase") or "Waiting") or "Waiting", arg:_countdown()
		local v25 = arg:_refreshReward(false)
		local mech = v22 and v22:FindFirstChild("Mech")
		return {enabled = arg.enabled, pending = arg:isFightPending(), eventActive = Workspace2:GetAttribute("Event_ScrambleBoss") == true or v22 ~= nil, portalOpen = arg:_portal() ~= nil, inArena = arg:_inArena(), phase = str6, status = arg.status, countdownLabel = v23, countdownSeconds = v24, health = v22 and math.max(tonumber(v22:GetAttribute("Health")) or 0, 0) or 0, maxHealth = v22 and math.max(tonumber(v22:GetAttribute("MaxHealth")) or 0, 0) or 0, overheated = mech and mech:GetAttribute("Overheated") == true or false, coreHealth = v22 and math.max(tonumber(v22:GetAttribute("CoreHealth")) or 0, 0) or 0, coreMax = v22 and math.max(tonumber(v22:GetAttribute("CoreMax")) or 0, 0) or 0, coreStage = v22 and math.max(tonumber(v22:GetAttribute("CoreStage")) or 0, 0) or 0, humanHits = v22 and math.max(tonumber(v22:GetAttribute("HumanHits")) or 0, 0) or 0, humanNeeded = v22 and math.max(tonumber(v22:GetAttribute("HumanNeeded")) or tonumber(fn65(ScrambleBossFlags.HumanHits, 3)) or 3, 1) or tonumber(fn65(ScrambleBossFlags.HumanHits, 3)) or 3, mastery = v25.mastery, samples = v25.samples, reward = arg.rewardLabel, finalHit = arg.finalHitLabel}
	end

	index._emit = function(arg, arg2)
		if next(arg.listeners) == nil then
			return
		end
		local v22 = arg:_snapshot()
		local lastSnapshotSignature = table.concat({tostring(v22.enabled), tostring(v22.pending), tostring(v22.eventActive), tostring(v22.portalOpen), tostring(v22.inArena), tostring(v22.phase), tostring(v22.status), tostring(math.floor(v22.countdownSeconds)), tostring(v22.health), tostring(v22.maxHealth), tostring(v22.overheated), tostring(v22.coreHealth), tostring(v22.coreMax), tostring(v22.coreStage), tostring(v22.humanHits), tostring(v22.humanNeeded), tostring(v22.mastery), tostring(v22.samples), tostring(v22.reward), tostring(v22.finalHit)}, "\000")
		if arg2 ~= true and lastSnapshotSignature == arg.lastSnapshotSignature then
			return
		end
		arg.lastSnapshotSignature = lastSnapshotSignature

		for k in pairs(arg.listeners) do
			pcall(k, v22)
		end
	end

	index.subscribe = function(arg, arg2)
		if type(arg2) ~= "function" then
			return function()
			end
		end
		arg.listeners[arg2] = true
		arg.lastSnapshotSignature = nil
		pcall(arg2, arg:_snapshot())

		return function()
			arg.listeners[arg2] = nil
		end
	end

	index.onChanged = index.subscribe

	index._setStatus = function(arg, arg2)
		local status = tostring(arg2 or "Idle")
		if arg.status == status then
			return
		end
		arg.status = status
		arg:_emit(true)
	end

	index._releaseOperation = function(arg)
		local operationToken = arg.operationToken
		arg.operationToken = nil

		if operationToken and arg.coordinator then
			arg.coordinator:release(operationToken)
		end
	end

	index._acquireOperation = function(arg)
		if arg.operationToken and not arg.operationToken.released then
			return true
		end

		if not arg.coordinator then
			return true
		end
		local v22, v23 = arg.coordinator:tryAcquire(str3, {})

		if v22 then
		else
			if tostring(v23) == "Busy: auto_steal" then
				local eggRuntime = arg.eggRuntime

				if eggRuntime ~= nil then
					if eggRuntime.running then
					else
						if eggRuntime.carry and eggRuntime.carry.active then
						else
							if eggRuntime._instantReturnToken == nil then
								if eggRuntime.safeStarting then
								else
									if eggRuntime.activeTween and not eggRuntime.activeTween.sharedTravel then
									else
										if type(eggRuntime._releaseOperation) == "function" then
											pcall(eggRuntime._releaseOperation, eggRuntime)
											v22, v23 = arg.coordinator:tryAcquire(str3, {})
										end
									end
								end
							end
						end
					end
				end
			end
		end

		if not v22 then
			arg:_setStatus("Waiting - " .. tostring(v23 or "another operation"))
			return false
		end
		arg.operationToken = v22
		return true
	end

	index._character = function(arg)
		local character = localPlayer2.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

		if character then
			if humanoid then
				if humanoidRootPart then
					if humanoid.Health <= 0 then
						return nil, nil, nil
					end
				else
					return nil, nil, nil
				end
			else
				return nil, nil, nil
			end
		else
			return nil, nil, nil
		end

		return character, humanoid, humanoidRootPart
	end

	index._stopMovement = function(arg, arg2)
		if not arg.glideTravelActive and (not arg.glideHoldActive and not arg:_inArena()) then
			arg.glideTravelActive = false
			arg.glideHoldActive = false
			return
		end

		local humanoidRootPart = arg2 or localPlayer2.Character and localPlayer2.Character:FindFirstChild("HumanoidRootPart")

		if humanoidRootPart then
			pcall(function()
				humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
				humanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
			end)
		end

		local eggRuntime = arg.eggRuntime

		if eggRuntime and type(eggRuntime._stopHoverPad) == "function" then
			eggRuntime:_stopHoverPad()
		end

		arg.glideTravelActive = false
		arg.glideHoldActive = false
	end

	index._restoreCharacterControl = function(arg)
		arg.safePreflightReady = false
		arg:_stopMovement()
	end

	index._glideTo = function(arg, arg2, arg3, arg4, arg5, arg6)
		if typeof(arg2) ~= "CFrame" then
			return false, nil, nil
		end
		local v22, v23, v24 = arg:_character()

		if v23 then
			if not v24 then
				return false, v23, v24
			end
		else
			return false, v23, v24
		end

		local n27 = math.max(tonumber(arg4) or 3, 0)
		local eggRuntime = arg.eggRuntime

		if (v24.Position - arg2.Position).Magnitude <= n27 then
			if arg6 == true then
				if eggRuntime then
					if type(eggRuntime._startHoverPad) == "function" then
						eggRuntime:_startHoverPad()
						arg.glideHoldActive = true
					else
						arg:_stopMovement(v24)
					end
				else
					arg:_stopMovement(v24)
				end
			else
				arg:_stopMovement(v24)
			end

			return true, v23, v24
		end

		if eggRuntime then
			if type(eggRuntime.travelAndWait) ~= "function" then
				return false, v23, v24
			end
		else
			return false, v23, v24
		end

		arg.glideTravelActive = true
		local position = v24.Position

		local v25 = eggRuntime:travelAndWait(arg2, {speed = arg3, preempt = true, arrivalHoldSeconds = 0, keepHoverPad = arg6 == true, abort = function()
			local humanoidRootPart = localPlayer2.Character and localPlayer2.Character:FindFirstChild("HumanoidRootPart")

			if humanoidRootPart then
				local flag6 = (humanoidRootPart.Position - position).Magnitude > 150
				position = humanoidRootPart.Position
				if flag6 then
					return true
				end
			end

			return arg.destroyed or not arg.enabled or localPlayer2:GetAttribute("ScrambleGrabbed") == true or arg5 ~= nil and arg5()
		end})

		arg.glideTravelActive = false
		v24, arg4, eggRuntime = arg:_character()
		local flag6 = eggRuntime and (eggRuntime.Position - arg2.Position).Magnitude <= n27
		local flag7 = v25 == true and flag6 == true

		if arg6 == true and flag7 then
			arg.glideHoldActive = true
		elseif arg6 == true then
			arg.glideHoldActive = true
			arg:_stopMovement(eggRuntime)
		end

		return flag7, arg4, eggRuntime
	end

	index._approachPart = function(arg, arg2, arg3, arg4, arg5, arg6)
		if not (arg3 and arg3:IsA("BasePart")) then
			return false, nil, nil
		end
		local v22, position, v23 = arg:_character()

		if position then
			if not v23 then
				return false, position, v23
			end
		else
			return false, position, v23
		end

		position = arg3.Position
		local v24 = if arg5 then if arg5 > 0 then position + fn66(arg3.AssemblyLinearVelocity) * arg5 else position else position
		arg5 = fn66(v23.Position - v24)
		arg5 = if arg5.Magnitude < 0.1 then fn66(-arg3.CFrame.LookVector) else arg5
		local v25 = if arg5.Magnitude < 0.1 then Vector3.new(1, 0, 0) else arg5
		local n27 = tonumber(arg2:GetAttribute("FloorY")) or v23.Position.Y - n26
		local n28 = Vector3.new(v24.X, n27 + n26 + (tonumber(arg6) or 0), v24.Z) + v25.Unit * arg4
		local str6 = tostring(arg2:GetAttribute("Phase") or "")

		arg:_glideTo(CFrame.lookAt(n28, Vector3.new(v24.X, n28.Y, v24.Z)), n13, 2.5, function()
			local v26 = arg:_inArena()
			return (if v26 then arg:_arena() ~= arg2 else not v26) or not arg3.Parent or tostring(arg2:GetAttribute("Phase") or "") ~= str6
		end, true)

		n28, arg6, arg5 = arg:_character()
		return arg5 ~= nil and fn67(arg3, arg5.Position) <= n16, arg6, arg5
	end

	index._findBat = function(arg)
		local character = localPlayer2.Character
		local backpack = localPlayer2:FindFirstChildOfClass("Backpack")

		if character then
			for i, child in ipairs(character:GetChildren()) do
				if v21(child) then
					return child, true
				end
			end
		end

		if backpack then
			for i, child in ipairs(backpack:GetChildren()) do
				if v21(child) then
					return child, false
				end
			end
		end

		return nil, false
	end

	index._equipBat = function(arg)
		local v22, v23 = arg:_character()

		if v22 then
			if not v23 then
				return nil
			end
		else
			return nil
		end

		local v24, v25 = arg:_findBat()

		if not v24 then
			local now = os.clock()

			if now - arg.lastBatRequestAt >= n17 then
				arg.lastBatRequestAt = now

				pcall(function()
					if Remotes.Codex and Remotes.Codex.AskWearFieldBat then
						Remotes.Codex.AskWearFieldBat:InvokeServer()
					end
				end)
			end

			return nil
		end

		if v25 and v24.Parent == v22 then
			return v24
		end
		pcall(v23.EquipTool, v23, v24)
		return v24.Parent == v22 and v24 or nil
	end

	index._faceTarget = function(arg, arg2, arg3)
		if not arg2 or not arg3 then
			return false
		end
		local vector2 = Vector3.new(arg3.Position.X, arg2.Position.Y, arg3.Position.Z)
		if (vector2 - arg2.Position).Magnitude <= 0.05 then
			return false
		end

		return (pcall(function()
			arg2.CFrame = CFrame.lookAt(arg2.Position, vector2)
			arg2.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
		end))
	end

	index._swing = function(arg, arg2)
		local v22, v23, v24 = arg:_character()

		if v24 then
			if not arg2 then
				return false
			elseif fn67(arg2, v24.Position) > n16 then
				return false
			end
		else
			return false
		end

		arg:_faceTarget(v24, arg2)
		local serverTimeNow = Workspace2:GetServerTimeNow()
		if serverTimeNow - arg.lastSwingAt < n15 then
			return false
		end
		local v25 = arg:_equipBat()
		if not v25 then
			arg:_setStatus("Waiting for Bat")
			return false
		end
		arg.lastSwingAt = serverTimeNow
		pcall(v25.Activate, v25)
		local handle = v25:FindFirstChild("Handle") or v25:FindFirstChildWhichIsA("BasePart", true)

		if handle and type(firetouchinterest) == "function" then
			pcall(function()
				firetouchinterest(handle, arg2, 0)
				task.wait(0.02)
				firetouchinterest(handle, arg2, 1)
			end)
		end

		arg.swingSequence = (arg.swingSequence or 0) + 1

		pcall(function()
			if Remotes.BatSwing and Remotes.BatSwing.Trigger then
				Remotes.BatSwing.Trigger:FireServer(nil, string.format("%d:%d:%d", localPlayer2.UserId, arg.swingSequence, math.floor(serverTimeNow * 1000)))
			end
		end)

		return true
	end

	index._touch = function(arg, arg2, arg3)
		if not arg2 or not arg3 then
			return false
		elseif type(firetouchinterest) ~= "function" then
			return false
		end

		return (pcall(function()
			firetouchinterest(arg2, arg3, 0)
			task.wait(0.03)
			firetouchinterest(arg2, arg3, 1)
		end))
	end

	index._preparePortalEntry = function(arg)
		if arg.safePreflightReady then
			return true
		elseif arg:_inArena() then
			return true
		end

		local v22, v23, v24 = arg:_character()
		local eggRuntime = arg.eggRuntime
		if (if v24 then not eggRuntime else not v24) or type(eggRuntime._isInSafeArea) ~= "function" or type(eggRuntime._resolveSafeCFrame) ~= "function" then
			arg:_setStatus("Waiting for Safe Zone route")
			return false
		end

		if eggRuntime:_isInSafeArea(v24) then
			arg.safePreflightReady = true
			return true
		end
		local v25 = eggRuntime:_resolveSafeCFrame(v24)
		if not v25 then
			return false
		end
		arg:_setStatus("Gliding to Safe Zone before boss")

		local v26, v27, v28 = arg:_glideTo(v25, n12, 8, function()
			return arg:_inArena() or not arg:_eventPresent()
		end)

		arg.safePreflightReady = v26 and v28 ~= nil and eggRuntime:_isInSafeArea(v28)
		return arg.safePreflightReady
	end

	index._tryEnterArena = function(arg, arg2)
		if not arg:_isResetWallOpen() then
			arg:_setStatus("Boss portal ready - waiting reset wall")
			return
		end
		local v22 = arg:_portal()
		local v23 = fn68(v22)
		local flag6 = false

		if v23 then
			local n27 = v23.Position + Vector3.new(0, math.min(v23.Size.Y * 0.25, 3), 0)
			local cframe = CFrame.lookAt(n27, v23.Position)
			arg:_setStatus("Gliding to boss portal")

			local v24, v25, v26 = arg:_glideTo(cframe, n12, 4, function()
				return arg:_inArena() or not arg:_isResetWallOpen() or not v23.Parent or arg:_portal() ~= v22
			end)

			if v24 then
				arg:_setStatus("Entering boss portal")
			end

			local flag7 = os.clock() < (arg.enterCooldownUntil or 0) or arg:_inArena()

			if if flag7 then not flag7 else v24 or (arg.portalMisses or 0) > 0 then
				arg.portalMisses = (arg.portalMisses or 0) + 1

				if arg.portalMisses > 3 then
					flag6 = true
				else
					arg.lastPortalTouchAt = os.clock()
					arg.enterCooldownUntil = os.clock() + 3.5
					local value = v26 or select(3, arg:_character())

					if value and arg:_isResetWallOpen() then
						pcall(function()
							if not v23.CanTouch then
								v23.CanTouch = true
							end
						end)

						arg:_touch(value, v23)
					end
				end
			end
		else
			flag6 = arg2 ~= nil
			arg:_setStatus(arg2 and "Joining active boss" or "Waiting for boss portal")
		end

		if flag6 and (arg:_isResetWallOpen() and (not arg:_inArena() and (os.clock() - arg.lastEnterAttemptAt >= n18 and os.clock() >= (arg.enterCooldownUntil or 0)))) then
			arg.lastEnterAttemptAt = os.clock()
			arg.enterCooldownUntil = os.clock() + 3.5

			local ok, result = pcall(function()
				if scrambleBoss and scrambleBoss.EnterArena then
					return scrambleBoss.EnterArena:InvokeServer()
				end
			end)

			if ok and result == true then
				arg.portalMisses = 0
			else
				local portalMisses = arg.portalMisses

				if portalMisses and portalMisses > 3 then
					arg.portalMisses = 1
				end
			end
		end
	end

	index._beginArena = function(arg, activeArena)
		if arg.activeArena == activeArena then
			return
		end
		arg.activeArena = activeArena
		arg.portalMisses = 0
		arg.rewardBaseline = arg:_refreshReward(true)
		arg.defeatedAt = nil
		arg.rewardAcknowledged = false
		arg.exitRequested = false
		arg.rewardLabel = "Pending"
		arg.finalHitLabel = "No"
		arg.lastPhase = ""
	end

	index._fightMech = function(arg, arg2)
		local mech = arg2:FindFirstChild("Mech")
		local hitbox = mech and mech:FindFirstChild("Hitbox")

		if hitbox then
			if not hitbox:IsA("BasePart") then
				arg:_setStatus("Waiting for Mech hitbox")
				return
			end
		else
			arg:_setStatus("Waiting for Mech hitbox")
			return
		end

		local n27 = tonumber(arg2:GetAttribute("GrabVictim")) or 0
		local grabRescue = mech:FindFirstChild("GrabRescue")

		if n27 ~= 0 and (n27 ~= localPlayer2.UserId and (grabRescue and grabRescue:IsA("BasePart"))) then
			local n28 = math.max(tonumber(arg2:GetAttribute("GrabFree")) or 0, 0)
			local n29 = math.max(tonumber(arg2:GetAttribute("GrabNeeded")) or 1, 1)
			arg:_setStatus(string.format("Rescuing grabbed player - %d/%d", n28, n29))

			if arg:_approachPart(arg2, grabRescue, n25, 0, 0) then
				arg:_swing(grabRescue)
			end

			return
		end

		local n28 = math.max(tonumber(arg2:GetAttribute("Health")) or 0, 0)
		local n29 = math.max(tonumber(arg2:GetAttribute("MaxHealth")) or 0, 0)
		local flag6 = mech:GetAttribute("Overheated") == true
		arg:_setStatus(string.format("Mech %d/%d%s", math.floor(n28 + 0.5), math.floor(n29 + 0.5), flag6 and " - OVERHEAT" or ""))

		if arg:_approachPart(arg2, hitbox, n22, 0.08, n23) and n28 > 0 then
			arg:_swing(hitbox)
		end
	end

	index._fightBall = function(arg, arg2)
		local ball = arg2:FindFirstChild("Ball")

		if ball then
			if not ball:IsA("Model") then
				arg:_setStatus("Waiting for Scramble Core")
				return
			end
		else
			arg:_setStatus("Waiting for Scramble Core")
			return
		end

		local n27 = math.max(tonumber(arg2:GetAttribute("CoreStage")) or 0, 0)

		if arg2:GetAttribute("BallStunned") == true and ball:GetAttribute("Stunned") == true then
			local primaryPart = ball.PrimaryPart

			if primaryPart then
				if not primaryPart:IsA("BasePart") then
					arg:_setStatus("Waiting for Core PrimaryPart")
					return
				end
			else
				arg:_setStatus("Waiting for Core PrimaryPart")
				return
			end

			local n28 = math.max(tonumber(arg2:GetAttribute("CoreHealth")) or 0, 0)
			local n29 = math.max(tonumber(arg2:GetAttribute("CoreMax")) or 0, 0)
			arg:_setStatus(string.format("Core %d/%d - stage %d/3", math.floor(n28 + 0.5), math.floor(n29 + 0.5), n27))

			if arg:_approachPart(arg2, primaryPart, n24, 0, 0) and n28 > 0 then
				arg:_swing(primaryPart)
			end

			return
		end

		local n28 = tonumber(arg2:GetAttribute("BallTarget")) or 0
		local str6 = tostring(arg2:GetAttribute("BallCoil") or "")

		if n28 ~= localPlayer2.UserId then
			arg:_stopMovement()
			arg:_setStatus(string.format("Ball stage %d/3 - waiting target", n27))
			return
		end

		local coils = arg2:FindFirstChild("Coils")
		local v22 = coils and coils:FindFirstChild(str6)
		local attribute = v22 and v22:GetAttribute("Home")
		if typeof(attribute) ~= "Vector3" then
			arg:_setStatus("Targeted by Ball - waiting coil")
			return
		end
		v22 = fn66(attribute - ball:GetBoundingBox().Position)
		local v23 = if v22.Magnitude < 1 then Vector3.new(1, 0, 0) else v22
		local v24, v25, v26 = arg:_character()
		local y = tonumber(arg2:GetAttribute("FloorY")) or v26 and v26.Position.Y - n26 or attribute.Y
		local n29 = Vector3.new(attribute.X, y + n26, attribute.Z) + v23.Unit * 40
		arg:_setStatus(string.format("Baiting Ball into %s - stage %d/3", str6, n27))

		arg:_glideTo(CFrame.lookAt(n29, Vector3.new(attribute.X, n29.Y, attribute.Z)), n14, 4, function()
			local v27 = arg:_inArena()
			return (if v27 then arg:_arena() ~= arg2 else not v27) or tostring(arg2:GetAttribute("Phase") or "") ~= "Ball" or tonumber(arg2:GetAttribute("BallTarget")) ~= localPlayer2.UserId
		end, true)
	end

	index._findHuman = function(arg, arg2)
		for i, v22 in ipairs({"ScrambleHuman", "Human", "DrScramble", "Scramble", "Pilot"}) do
			local v23 = arg2:FindFirstChild(v22)

			if v23 and v23:IsA("Model") then
				if v23.PrimaryPart then
					return v23
				elseif v23:FindFirstChildWhichIsA("BasePart") then
					return v23
				end
			end
		end

		for i, child in ipairs(arg2:GetChildren()) do
			if child:IsA("Model") and (child.Name ~= "Mech" and (child:FindFirstChildOfClass("Humanoid") and not Players2:GetPlayerFromCharacter(child))) then
				return child
			end
		end

		for i, descendant in ipairs(arg2:GetDescendants()) do
			if descendant:IsA("Model") and (descendant.Name ~= "Mech" and (descendant:FindFirstChildOfClass("Humanoid") and not Players2:GetPlayerFromCharacter(descendant))) then
				return descendant
			end
		end

		return nil
	end

	index._stickTo = function(arg, arg2, arg3)
		local v22, v23, v24 = arg:_character()

		if v24 and arg2 then
			if not arg2:IsA("BasePart") then
				return
			end
		else
			return
		end

		local position = arg2.Position
		arg = fn66(v24.Position - position)
		local v25 = if arg.Magnitude < 0.1 then fn66(-arg2.CFrame.LookVector) else arg
		local n27 = position + (if v25.Magnitude < 0.1 then Vector3.new(1, 0, 0) else v25).Unit * (tonumber(arg3) or 3)

		pcall(function()
			v24.CFrame = CFrame.lookAt(n27, Vector3.new(position.X, n27.Y, position.Z))
			v24.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
			v24.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
		end)
	end

	index._fightHuman = function(arg, arg2)
		local n27 = math.max(tonumber(arg2:GetAttribute("HumanHits")) or 0, 0)
		local n28 = math.max(tonumber(arg2:GetAttribute("HumanNeeded")) or tonumber(fn65(ScrambleBossFlags.HumanHits, 3)) or 3, 1)

		if n27 >= n28 then
			arg:_stopMovement()
			arg:_setStatus(string.format("Dr Scramble down - %d/%d", n27, n28))
			return
		end

		local v22 = arg:_findHuman(arg2)
		if not v22 then
			arg:_setStatus("Final phase - waiting for Dr Scramble")
			return
		end
		local humanoid = v22:FindFirstChildOfClass("Humanoid")

		if humanoid and humanoid.Health <= 0 then
			arg:_stopMovement()
			arg:_setStatus(string.format("Dr Scramble down - %d/%d", n27, n28))
			return
		end

		local primaryPart = v22.PrimaryPart or v22:FindFirstChild("HumanoidRootPart") or v22:FindFirstChildWhichIsA("BasePart")
		if not primaryPart then
			arg:_setStatus("Waiting for Human part")
			return
		end

		if v22:GetAttribute("Immune") == true then
			arg:_stopMovement()
			arg:_setStatus(string.format("Final Human immune - %d/%d", n27, n28))
			return
		end

		arg:_setStatus(string.format("Hitting Dr Scramble - %d/%d", n27, n28))
		arg:_stickTo(primaryPart, 3)
		arg:_swing(primaryPart)
	end

	index._updateReward = function(arg)
		local v22 = arg:_refreshReward(true)
		local rewardBaseline = arg.rewardBaseline
		if not rewardBaseline then
			arg.rewardBaseline = v22
			return false
		end
		local n27 = math.max(v22.mastery - rewardBaseline.mastery, 0)
		local n28 = math.max(v22.samples - rewardBaseline.samples, 0)
		local n29 = math.max(v22.finalHits - rewardBaseline.finalHits, 0)
		local mecha = rewardBaseline.mecha
		local v23 = if mecha then not mecha else v22.mecha

		if n29 > 0 then
			arg.finalHitLabel = "Yes"
		end

		if n27 > 0 then
			arg.rewardAcknowledged = true
			local tbl14 = {"+" .. tostring(n27) .. " Mastery"}

			if n28 > 0 then
				tbl14[#tbl14 + 1] = "+" .. tostring(n28) .. " Samples"
			end

			if v23 then
				tbl14[#tbl14 + 1] = "Mecha Egg"
			end

			arg.rewardLabel = table.concat(tbl14, " - ")
		elseif v23 then
			arg.rewardAcknowledged = true
			arg.rewardLabel = "Mecha Scrambler Egg"
		else
			arg.rewardLabel = "Pending"
		end

		return arg.rewardAcknowledged
	end

	index._leaveArena = function(arg, arg2)
		local v22 = fn68((arg2:FindFirstChild("LeaveTeleport")))
		if not v22 then
			arg:_setStatus("Defeated - waiting arena exit")
			return
		end
		arg:_setStatus("Reward confirmed - gliding to exit")

		local v23, v24, v25 = arg:_glideTo(v22.CFrame, n12, 3.5, function()
			local v23 = arg:_inArena()
			return if v23 then arg:_arena() ~= arg2 else not v23
		end)

		if v23 then
			arg:_setStatus("Leaving boss arena")
		end

		if v23 and (v25 and os.clock() - arg.lastExitTouchAt >= n19) then
			arg.lastExitTouchAt = os.clock()
			arg.exitRequested = true
			arg:_touch(v25, v22)
		end
	end

	index._fightDefeated = function(arg, arg2)
		arg.defeatedAt = arg.defeatedAt or os.clock()
		arg:_stopMovement()
		arg:_setStatus(arg:_updateReward() and "Defeated - " .. arg.rewardLabel or "Defeated - server returning you")
	end

	index._stepFight = function(arg, arg2)
		arg:_beginArena(arg2)
		local lastPhase = tostring(arg2:GetAttribute("Phase") or "Waiting")
		arg.lastPhase = lastPhase

		if localPlayer2:GetAttribute("ScrambleGrabbed") == true then
			local now = os.clock()

			if now - arg.lastGrabEscapeAt >= n20 then
				arg.lastGrabEscapeAt = now

				pcall(function()
					if scrambleBoss and scrambleBoss.HazardHit then
						scrambleBoss.HazardHit:FireServer(-2)
					end
				end)
			end

			arg:_setStatus("Grabbed - breaking free")
			return
		end

		if lastPhase == "Waiting" then
			local n27 = math.max(0, (tonumber(arg2:GetAttribute("SpawnsAt")) or 0) - Workspace2:GetServerTimeNow())
			arg:_setStatus(n27 > 0 and string.format("Boss starts in %ds", math.ceil(n27)) or "Waiting for challengers")
		elseif lastPhase == "Mech" then
			arg:_fightMech(arg2)
		elseif lastPhase == "Ejecting" then
			arg:_stopMovement()
			arg:_setStatus("Mech defeated - ejecting")
		elseif lastPhase == "Ball" then
			arg:_fightBall(arg2)
		elseif lastPhase == "Human" then
			arg:_fightHuman(arg2)
		elseif lastPhase == "Final" then
			arg:_fightHuman(arg2)
		elseif lastPhase == "Defeated" then
			arg:_fightDefeated(arg2)
		else
			arg:_setStatus("Waiting for phase - " .. lastPhase)
		end
	end

	index._resetCycle = function(arg)
		arg.activeArena = nil
		arg.rewardBaseline = nil
		arg.defeatedAt = nil
		arg.rewardAcknowledged = false
		arg.exitRequested = false
		arg.lastPhase = ""
		arg.safePreflightReady = false
		arg.noMatchSince = nil
	end

	index.wantsCharacter = function(arg)
		if arg.destroyed then
			return false
		elseif not arg.enabled then
			return false
		end

		if arg:_inArena() then
			return true
		end

		if not arg:_isResetWallOpen() then
			return false
		end

		if arg:_portal() ~= nil then
			return true
		end
		local v22 = arg:_arena()
		local str6 = v22 and tostring(v22:GetAttribute("Phase") or "") or ""
		return v22 ~= nil and str6 ~= "" and str6 ~= "Defeated"
	end

	index._holdPortal = function(arg, arg2)
		if arg.eggRuntime and type(arg.eggRuntime._setScramblePortalHold) == "function" then
			arg.eggRuntime:_setScramblePortalHold(arg2 == true)
		end
	end

	index._step = function(arg)
		if not arg:_eventPresent() then
			arg:_restoreCharacterControl()
			arg:_releaseOperation()
			arg.noMatchSince = nil
			arg:_holdPortal(false)

			if arg.activeArena then
				arg:_resetCycle()
			end

			arg:_setStatus("Waiting for boss portal")
			return n9
		end

		if not arg:_inArena() then
			if not arg:wantsCharacter() then
				arg.noMatchSince = nil
				arg:_restoreCharacterControl()
				arg:_releaseOperation()
				arg:_holdPortal(false)
				arg:_setStatus(arg:_isResetWallOpen() and "Waiting for boss portal" or "Boss portal ready - waiting reset wall")
				return n9
			end

			local mechBoss = senaV4TaskLadder.blocker("mech_boss")

			if mechBoss then
				arg.noMatchSince = nil
				arg:_holdPortal(false)
				arg:_releaseOperation()
				arg:_restoreCharacterControl()
				arg:_setStatus("Yielding to " .. senaV4TaskLadder.TITLES[mechBoss])
				return n9
			end

			if senaV4Config.AutoSteal and senaV4TaskLadder.rank("auto_steal") < senaV4TaskLadder.rank("mech_boss") then
				arg.noMatchSince = arg.noMatchSince or os.clock()
				local n27 = os.clock() - arg.noMatchSince

				if n27 < n11 then
					arg:_holdPortal(false)
					arg:_releaseOperation()
					arg:_restoreCharacterControl()
					arg:_setStatus(string.format("Checking matched egg %ds", math.ceil(n11 - n27)))
					return n9
				end
			end
		end

		if not arg:_acquireOperation() then
			arg:_holdPortal(false)
			return n9
		end
		local v22, v23 = arg:_character()

		if not v23 then
			arg:_restoreCharacterControl()
			arg:_holdPortal(false)
			arg:_setStatus("Respawning - re-entry pending")
			return n9
		end

		local v24 = arg:_arena()

		if not arg:_inArena() then
			arg:_holdPortal(true)
			if not arg:_preparePortalEntry() then
				return n8
			end

			if not arg:_isResetWallOpen() then
				arg:_stopMovement()
				arg:_setStatus("Boss portal ready - waiting reset wall")
				return n9
			end

			arg:_tryEnterArena(v24)
			return n8
		end

		arg:_holdPortal(true)
		if not v24 then
			arg:_setStatus("Inside boss - waiting arena replication")
			return n8
		end
		arg:_stepFight(v24)
		return n8
	end

	index._ensureWorker = function(arg)
		if arg.worker then
			return
		end

		arg.worker = task.spawn(function()
			while true do
				local destroyed = arg.destroyed
				if not (if destroyed then not destroyed else fn2()) then
					break
				end
				destroyed = nil

				if arg.enabled then
					local ok, result = xpcall(function()
						return arg:_step()
					end, debug.traceback)

					if ok then
						destroyed = result
					else
						warn("[StealAnEgg] ScrambleBoss worker failed:\n" .. tostring(result))
						arg:_restoreCharacterControl()
						arg:_releaseOperation()
						arg.status = "Runtime error - retrying"
						destroyed = n9
					end
				else
					destroyed = n10
				end

				arg:_emit(false)
				task.wait(destroyed)
			end

			arg.worker = nil
		end)
	end

	index.setEnabled = function(arg, arg2)
		local enabled = arg2 == true
		if arg.enabled == enabled then
			return
		end
		arg.enabled = enabled

		if enabled then
			arg:_setStatus(arg:_eventPresent() and "Boss detected" or "Waiting for boss portal")
			arg:_ensureWorker()
		else
			arg:_restoreCharacterControl()
			arg:_releaseOperation()
			arg:_resetCycle()
			arg.status = "Off"
			arg:_holdPortal(false)
		end

		arg:_emit(true)
	end

	index.destroy = function(arg)
		if arg.destroyed then
			return
		end
		arg.destroyed = true
		arg.enabled = false
		arg:_restoreCharacterControl()
		arg:_releaseOperation()

		for i, connection6 in ipairs(arg.connections) do
			pcall(connection6.Disconnect, connection6)
		end

		table.clear(arg.connections)
		table.clear(arg.listeners)

		if arg.worker then
			pcall(task.cancel, arg.worker)
			arg.worker = nil
		end
	end

	pcall(function()
		local senaV4ScrambleBoss = genv.__SenaV4ScrambleBoss

		if senaV4ScrambleBoss and type(senaV4ScrambleBoss.destroy) == "function" and senaV4ScrambleBoss ~= nil and getmetatable(senaV4ScrambleBoss) == index then
			senaV4ScrambleBoss:destroy()
		elseif type(senaV4ScrambleBoss) == "table" then
			if type(senaV4ScrambleBoss.destroy) == "function" then
				senaV4ScrambleBoss:destroy()
			end
		end
	end)

	genv.__SenaV4ScrambleBoss = index.new(v12, v13)

	senaV4TaskLadder.register("mech_boss", {wants = function()
		local senaV4ScrambleBoss = genv.__SenaV4ScrambleBoss
		return senaV4ScrambleBoss ~= nil and senaV4ScrambleBoss:wantsCharacter()
	end, active = function()
		local senaV4ScrambleBoss = genv.__SenaV4ScrambleBoss

		if senaV4ScrambleBoss then
			if senaV4ScrambleBoss.destroyed then
				return false
			end
		else
			return false
		end

		local operationToken = senaV4ScrambleBoss.operationToken
		return senaV4ScrambleBoss:_inArena() or operationToken ~= nil and not operationToken.released
	end, enabled = function()
		local senaV4ScrambleBoss = genv.__SenaV4ScrambleBoss
		return senaV4ScrambleBoss ~= nil and senaV4ScrambleBoss.enabled == true
	end, status = function()
		local senaV4ScrambleBoss = genv.__SenaV4ScrambleBoss
		return senaV4ScrambleBoss and tostring(senaV4ScrambleBoss.status or "") or ""
	end})

	task.spawn(function()
		while fn2() do
			local senaV4ScrambleBoss = genv.__SenaV4ScrambleBoss
			local flag6 = senaV4Config.ScrambleBossAuto == true or senaV4ScrambleBoss ~= nil and senaV4ScrambleBoss.enabled == true

			if senaV4Config.AutoSteal and not flag6 and localPlayer2:GetAttribute("InScrambleArena") == true then
				local v22 = Workspace2:FindFirstChild(str4)
				local leaveTeleport = v22 and v22:FindFirstChild("LeaveTeleport")
				local v23 = leaveTeleport and fn68(leaveTeleport)
				local character = localPlayer2.Character
				local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

				if v23 and humanoidRootPart then
					pcall(function()
						humanoidRootPart.CFrame = CFrame.new(v23.Position + Vector3.new(0, 3, 0))
						humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)

						if type(firetouchinterest) == "function" then
							firetouchinterest(humanoidRootPart, v23, 0)
							task.wait(0.03)
							firetouchinterest(humanoidRootPart, v23, 1)
						end
					end)
				end

				task.wait(0.5)
			end

			task.wait(0.25)
		end
	end)
end)()

local senaPanels = {}

local function fn65()
	local function fn66(arg, arg2)
		local ok, result = pcall(function()
			return Enum.Font[arg]
		end)

		return ok and result or arg2
	end

	local BuilderSansBold = fn66("BuilderSansBold", Enum.Font.GothamBold)
	local BuilderSansMedium = fn66("BuilderSansMedium", Enum.Font.GothamMedium)
	game:GetService("UserInputService")
	local Assets = require(ReplicatedStorage.Data.Assets)
	local EggState2 = require(ReplicatedStorage.Client.EggState)
	local Save = require(ReplicatedStorage.Shared.Save)
	local tbl14 = {strokeCol = Color3.fromRGB(36, 36, 42), accent = Color3.fromRGB(26, 147, 250), accentA = Color3.fromRGB(19, 96, 250), accentB = Color3.fromRGB(33, 198, 250), surface = Color3.fromRGB(22, 22, 27), surfaceHi = Color3.fromRGB(28, 28, 34), text = Color3.fromRGB(235, 236, 245), btnText = Color3.fromRGB(186, 184, 198), muted = Color3.fromRGB(156, 154, 170), shadow = Color3.fromRGB(4, 4, 8), obsTop = Color3.fromRGB(18, 18, 24), obsMid = Color3.fromRGB(12, 12, 16), obsLow = Color3.fromRGB(10, 14, 26), btnBg = Color3.fromRGB(30, 30, 36), btnHover = Color3.fromRGB(44, 44, 52), inputBg = Color3.fromRGB(14, 14, 18), switchOff = Color3.fromRGB(42, 42, 48), good = Color3.fromRGB(163, 230, 53)}
	local v21 = tbl14
	local image = "rbxassetid://96240498384290"
	local text = "discord.gg/senahub"

	local function fn67()
		pcall(function()
			if type(setthreadidentity) == "function" then
				setthreadidentity(8)
			elseif genv then
				if type(genv.__SenaV4IdentitySetter) == "function" then
					genv.__SenaV4IdentitySetter(8)
				end
			end
		end)
	end

	local function fn68()
		local playerGui = localPlayer and localPlayer:FindFirstChild("PlayerGui")
		if playerGui then
			return playerGui
		end

		local ok, result = pcall(function()
			return game:GetService("CoreGui")
		end)

		if ok and result then
			return result
		end
		return game:GetService("CoreGui")
	end

	local function fn69(arg)
		local n8 = tonumber(arg) or 0

		if n8 >= 1000000000000 then
			return string.format("%.2fT", n8 / 1000000000000)
		elseif n8 >= 1000000000 then
			return string.format("%.2fB", n8 / 1000000000)
		elseif n8 >= 1000000 then
			return string.format("%.2fM", n8 / 1000000)
		elseif n8 >= 1000 then
			return string.format("%.2fK", n8 / 1000)
		else
			return string.format("%d", n8)
		end
	end

	local function fn70(arg)
		return fn69(arg)
	end

	local function fn71(arg)
		local directory = Assets.Directory and Assets.Directory[arg]
		if directory and directory.Rarity then
			local displayName = directory.Rarity.DisplayName or directory.Rarity._id or "?"
			return v6.rarityRank(displayName), displayName, directory.Rarity.Color
		end
		return 0, "?", nil
	end

	local function fn72(arg)
		local directory = Assets.Directory and Assets.Directory[arg]
		if type(directory) ~= "table" then
			return nil
		end

		local function fn73(arg2)
			if type(arg2) == "string" and arg2 ~= "" then
				if arg2:find("rbxassetid") then
					return arg2
				elseif arg2:find("rbxthumb") then
					return arg2
				end

				if arg2:match("^%d+$") then
					return "rbxassetid://" .. arg2
				end
			elseif type(arg2) == "number" then
				if arg2 > 0 then
					return "rbxassetid://" .. tostring(arg2)
				end
			end

			return nil
		end

		local tbl15 = {"Image", "Icon", "Thumbnail", "ImageId", "IconId", "Texture", "Asset", "DisplayImage"}

		for i, v22 in ipairs(tbl15) do
			local v23 = fn73(directory[v22])
			if v23 then
				return v23
			end
		end

		if type(directory.Egg) == "table" then
			for i, v22 in ipairs(tbl15) do
				local v23 = fn73(directory.Egg[v22])
				if v23 then
					return v23
				end
			end
		end

		return nil
	end

	local tbl15 = {}
	local tbl16 = {}

	for k, v22 in pairs(Assets.Directory or {}) do
		if type(v22) == "table" and v22.Rarity then
			local displayName = v22.Rarity.DisplayName or v22.Rarity._id or "?"
			local v23 = v6.rarityRank(displayName)
			tbl16[displayName] = v23
			table.insert(tbl15, {cat = k, rnum = v23, rname = displayName})
		end
	end

	table.sort(tbl15, function(arg, arg2)
		if arg.rnum == arg2.rnum then
			return arg.cat < arg2.cat
		end
		return arg.rnum > arg2.rnum
	end)

	local function fn73()
		local tbl17 = {}
		local tbl18 = {}

		for i, v22 in ipairs(tbl15) do
			if not tbl17[v22.rname] then
				tbl17[v22.rname] = true
				table.insert(tbl18, {v22.rname, v22.rnum})
			end
		end

		table.sort(tbl18, function(arg, arg2)
			return arg[2] > arg2[2]
		end)

		local tbl19 = {"Any"}

		for i, v22 in ipairs(tbl18) do
			table.insert(tbl19, v22[1])
		end

		return tbl19
	end

	local function fn74()
		local tbl17 = {}

		for i, v22 in ipairs(fn73()) do
			if v22 ~= "Any" then
				table.insert(tbl17, v22)
			end
		end

		return tbl17
	end

	local function fn75(arg)
		local n8 = 0

		pcall(function()
			n8 = senaV4Config:getAreaEggValue(arg) or 0
		end)

		if n8 > 0 then
			return n8
		end

		pcall(function()
			local AssetEarnings = require(ReplicatedStorage.Shared.Util.AssetEarnings)

			if AssetEarnings and type(AssetEarnings.LiveRatePerSecond) == "function" then
				n8 = AssetEarnings.LiveRatePerSecond(arg) or 0
			end
		end)

		return n8 or 0
	end

	local function fn76(arg)
		local n8 = 0

		pcall(function()
			local EggRecords = require(ReplicatedStorage.Shared.Util.EggRecords)
			local assetCategory = arg.AssetCategory or arg.Category
			local assetScale = arg.AssetScale or arg.Scale or 1
			n8 = EggRecords.WeightKgForScale(assetCategory, assetScale)
		end)

		return n8 or 0
	end

	local function fn77()
		local n8 = 0
		local n9 = 0

		local function fn78()
			for k, v22 in pairs(EggState2.ReadOwnerEggs(localPlayer.UserId) or {}) do
				if v22.Placement ~= nil then
					n8 += 1
				else
					n9 += 1
				end
			end
		end

		pcall(fn78)
		return n8, math.max(0, 50 - n8), n9
	end

	local tbl17 = {}

	do
		local TweenService = game:GetService("TweenService")
		tbl17.type = {title = {BuilderSansBold, 14}, body = {BuilderSansBold, 12}, meta = {BuilderSansMedium, 11}, label = {BuilderSansBold, 10}, value = {BuilderSansBold, 16}}
		tbl17.fast = TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

		tbl17.text = function(parent, arg)
			local body = tbl17.type[arg.style or "body"] or tbl17.type.body
			local textLabel = Instance.new("TextLabel")
			textLabel.BackgroundTransparency = 1
			textLabel.Font = body[1]
			textLabel.TextSize = arg.textsize or body[2]
			textLabel.TextColor3 = arg.color or v21.text
			textLabel.TextXAlignment = arg.align or Enum.TextXAlignment.Left
			textLabel.TextYAlignment = arg.valign or Enum.TextYAlignment.Center
			textLabel.RichText = arg.rich == true
			local str3 = tostring(arg.text or "")
			textLabel.Text = arg.style == "label" and string.upper(str3) or str3

			if arg.wrap then
				textLabel.TextWrapped = true
				textLabel.AutomaticSize = Enum.AutomaticSize.Y
			else
				textLabel.TextTruncate = Enum.TextTruncate.AtEnd
			end

			textLabel.Size = arg.size or UDim2.new(1, 0, 0, body[2] + 4)

			if arg.pos then
				textLabel.Position = arg.pos
			end

			if arg.anchor then
				textLabel.AnchorPoint = arg.anchor
			end

			if arg.name then
				textLabel.Name = arg.name
			end

			if arg.order then
				textLabel.LayoutOrder = arg.order
			end

			textLabel.Parent = parent
			return textLabel
		end

		local tbl18 = {}
		local flag6 = false

		local function fn78(arg, arg2)
			local chloeX = genv.ChloeX
			if type(chloeX) == "table" and type(chloeX.ApplyIcon) == "function" then
				return (pcall(chloeX.ApplyIcon, arg, arg2, 48))
			end
			local senaLucideIcons = genv.SenaLucideIcons
			local n48px = type(senaLucideIcons) == "table" and (senaLucideIcons["48px"] or senaLucideIcons["256px"]) or nil
			local v22 = n48px and n48px[arg2]

			if type(v22) == "table" and (v22[2] and v22[3]) then
				arg.Image = "rbxassetid://" .. tostring(v22[1])
				arg.ImageRectSize = Vector2.new(v22[2][1], v22[2][2])
				arg.ImageRectOffset = Vector2.new(v22[3][1], v22[3][2])
				return true
			end

			return false
		end

		tbl17.icon = function(arg, arg2)
			if fn78(arg, arg2) then
				return
			end
			tbl18[#tbl18 + 1] = {arg, arg2}
			if flag6 then
				return
			end
			flag6 = true

			task.spawn(function()
				local now = os.clock()

				while true do
					if not (#tbl18 > 0 and os.clock() - now < 30) then
						break
					end
					task.wait(0.5)
					fn67()
					local tbl19 = {}

					for i, v22 in ipairs(tbl18) do
						if v22[1].Parent and not fn78(v22[1], v22[2]) then
							tbl19[#tbl19 + 1] = v22
						end
					end

					tbl18 = tbl19
				end

				flag6 = false
			end)
		end

		tbl17.image = function(parent, arg, arg2, imageColor3)
			local imageLabel = Instance.new("ImageLabel")
			imageLabel.BackgroundTransparency = 1
			imageLabel.ImageColor3 = imageColor3 or v21.muted
			imageLabel.Size = UDim2.fromOffset(arg2, arg2)
			imageLabel.Parent = parent
			tbl17.icon(imageLabel, arg)
			return imageLabel
		end

		local tbl19 = {primary = {bg = v21.accent, hover = v21.accentB, text = Color3.fromRGB(255, 255, 255), alpha = 0.1}, ghost = {bg = v21.btnBg, hover = v21.btnHover, text = v21.btnText, alpha = 0.15}, danger = {bg = Color3.fromRGB(70, 30, 34), hover = Color3.fromRGB(92, 38, 42), text = Color3.fromRGB(248, 113, 113), alpha = 0.1}}

		tbl17.button = function(parent, arg)
			local ghost = tbl19[arg.kind or "ghost"] or tbl19.ghost
			local textButton = Instance.new("TextButton")
			textButton.AutoButtonColor = false
			textButton.AutomaticSize = Enum.AutomaticSize.X
			textButton.BackgroundColor3 = ghost.bg
			textButton.BackgroundTransparency = ghost.alpha
			textButton.BorderSizePixel = 0
			textButton.LayoutOrder = arg.order or 0
			textButton.Size = UDim2.fromOffset(arg.minw or 0, arg.h or 26)
			textButton.Text = ""
			Instance.new("UICorner", textButton).CornerRadius = UDim.new(0, 6)
			local uiPadding = Instance.new("UIPadding", textButton)
			uiPadding.PaddingLeft = UDim.new(0, arg.icon and 8 or 10)
			uiPadding.PaddingRight = UDim.new(0, 10)
			local uiListLayout = Instance.new("UIListLayout", textButton)
			uiListLayout.FillDirection = Enum.FillDirection.Horizontal
			uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			uiListLayout.Padding = UDim.new(0, 5)
			uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
			local v22
			local icon, v23 = arg.icon

			if icon then
				local v24 = tbl17.image(textButton, arg.icon, 13, ghost.text)
				v24.LayoutOrder = 0
				v23 = v24
			else
				v23 = v22
			end

			local textLabel = Instance.new("TextLabel")
			textLabel.AutomaticSize = Enum.AutomaticSize.X
			textLabel.BackgroundTransparency = 1
			textLabel.Font = BuilderSansBold
			textLabel.LayoutOrder = 1
			textLabel.Size = UDim2.new(0, 0, 1, 0)
			textLabel.Text = tostring(arg.text or "")
			textLabel.TextColor3 = ghost.text
			textLabel.TextSize = 12
			textLabel.Parent = textButton
			local uiScale = Instance.new("UIScale", textButton)
			local tbl20 = {inst = textButton, label = textLabel, icon = v23, active = false, enabled = true}

			local function fn79()
				local primary = tbl20.active and tbl19.primary or ghost
				textButton.BackgroundColor3 = primary.bg
				textButton.BackgroundTransparency = tbl20.enabled and primary.alpha or 0.6
				textLabel.TextColor3 = primary.text
				textLabel.TextTransparency = tbl20.enabled and 0 or 0.5

				if v23 then
					v23.ImageColor3 = primary.text
				end
			end

			textButton.MouseEnter:Connect(function()
				if tbl20.enabled and not tbl20.active then
					local fast = tbl17.fast
					local tbl21 = {}
					tbl21.BackgroundColor3 = ghost.hover
					TweenService:Create(textButton, fast, tbl21):Play()
				end
			end)

			textButton.MouseLeave:Connect(function()
				if not tbl20.active then
					local fast = tbl17.fast
					local tbl21 = {}
					tbl21.BackgroundColor3 = ghost.bg
					TweenService:Create(textButton, fast, tbl21):Play()
				end
			end)

			local function fn80()
				if not tbl20.enabled then
					return
				end
				TweenService:Create(uiScale, tbl17.fast, {Scale = 0.96}):Play()
			end

			textButton.MouseButton1Down:Connect(fn80)

			local function fn81()
				TweenService:Create(uiScale, tbl17.fast, {Scale = 1}):Play()
			end

			textButton.MouseButton1Up:Connect(fn81)

			local function fn82()
				if tbl20.enabled and arg.onClick then
					fn67()
					local ok, result = pcall(arg.onClick, tbl20)

					if not ok then
						warn("[Sena panels] button error:", result)
					end
				end
			end

			textButton.MouseButton1Click:Connect(fn82)

			tbl20.setText = function(arg2)
				textLabel.Text = tostring(arg2)
			end

			tbl20.setActive = function(arg2)
				tbl20.active = arg2 == true
				fn79()
			end

			tbl20.setEnabled = function(arg2)
				tbl20.enabled = arg2 ~= false
				textButton.Active = tbl20.enabled
				fn79()
			end

			tbl20.setKind = function(arg2)
				ghost = tbl19[arg2] or tbl19.ghost
				fn79()
			end

			textButton.Parent = parent
			return tbl20
		end

		tbl17.segmented = function(parent, arg)
			local scrollingFrame = Instance.new("ScrollingFrame")
			scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.X
			scrollingFrame.BackgroundTransparency = 1
			scrollingFrame.BorderSizePixel = 0
			scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
			scrollingFrame.ScrollBarThickness = 0
			scrollingFrame.ScrollingDirection = Enum.ScrollingDirection.X
			scrollingFrame.Size = arg.size or UDim2.new(1, 0, 0, (arg.h or 24) + 4)

			if arg.pos then
				scrollingFrame.Position = arg.pos
			end

			if arg.order then
				scrollingFrame.LayoutOrder = arg.order
			end

			local uiListLayout = Instance.new("UIListLayout", scrollingFrame)
			uiListLayout.FillDirection = Enum.FillDirection.Horizontal
			uiListLayout.Padding = UDim.new(0, 6)
			uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
			local tbl20

			tbl20 = {inst = scrollingFrame, value = arg.value, buttons = {}, set = function(value, arg2)
				tbl20.value = value

				for k, button in pairs(tbl20.buttons) do
					button.setActive(k == value)
				end

				if arg2 and arg.onChange then
					arg.onChange(value)
				end
			end}

			for i, v22 in ipairs(arg.options or {}) do
				local v23 = v22[1]
				local v24 = v22[2]

				tbl20.buttons[v23] = tbl17.button(scrollingFrame, {text = v24, h = arg.h or 24, order = i, onClick = function()
					tbl20.set(v23, true)
				end})
			end

			tbl20.set(arg.value, false)
			scrollingFrame.Parent = parent
			return tbl20
		end

		tbl17.list = function(arg)
			local tbl20 = {}

			return {setData = function(arg2)
				fn67()

				for i, v22 in ipairs(arg2) do
					local v23 = tbl20[i]

					if v23 then
					else
						v23 = arg.build(i)
						tbl20[i] = v23
					end

					v23.frame.LayoutOrder = i
					v23.frame.Visible = true
					arg.bind(v23, v22, i)
				end

				for i = #arg2 + 1, #tbl20, 1 do
					tbl20[i].frame.Visible = false
				end
			end}
		end

		tbl17.stat = function(parent, arg)
			local frame = Instance.new("Frame")
			frame.BackgroundColor3 = v21.surface
			frame.BackgroundTransparency = 0.1
			frame.BorderSizePixel = 0
			frame.LayoutOrder = arg.order or 0
			frame.Size = arg.size or UDim2.new(0.5, -4, 0, 62)
			Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
			local uiStroke = Instance.new("UIStroke", frame)
			uiStroke.Color = v21.strokeCol
			uiStroke.Transparency = 0.6
			tbl17.image(frame, arg.icon or "circle-dot", 12, v21.muted).Position = UDim2.fromOffset(10, 10)
			local v22 = tbl17.text(frame, {text = arg.label, style = "label", color = v21.muted, pos = UDim2.fromOffset(27, 7), size = UDim2.new(1, -36, 0, 16)})
			local v23 = tbl17.text(frame, {text = "--", style = "value", pos = UDim2.fromOffset(10, 23), size = UDim2.new(1, -20, 0, 20)})
			local v24 = tbl17.text(frame, {text = "", style = "meta", color = v21.muted, pos = UDim2.fromOffset(10, 43), size = UDim2.new(1, -20, 0, 14)})
			v24.RichText = true
			frame.Parent = parent

			return {inst = frame, label = v22, value = v23, meta = v24, set = function(arg2, arg3, textColor3)
				local text2 = tostring(arg2)

				if v23.Text ~= text2 then
					v23.Text = text2
				end

				local text3 = tostring(arg3 or "")

				if v24.Text ~= text3 then
					v24.Text = text3
				end

				v24.TextColor3 = textColor3 or v21.muted
			end}
		end

		tbl17.card = function(parent, arg)
			local frame = Instance.new("Frame")
			frame.AutomaticSize = Enum.AutomaticSize.Y
			frame.BackgroundColor3 = v21.surface
			frame.BackgroundTransparency = 0.1
			frame.BorderSizePixel = 0
			frame.LayoutOrder = arg.order or 0
			frame.Size = UDim2.new(1, 0, 0, 0)
			Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
			local uiStroke = Instance.new("UIStroke", frame)
			uiStroke.Color = v21.strokeCol
			uiStroke.Transparency = 0.6
			local uiPadding = Instance.new("UIPadding", frame)
			uiPadding.PaddingBottom = UDim.new(0, 10)
			uiPadding.PaddingLeft = UDim.new(0, 10)
			uiPadding.PaddingRight = UDim.new(0, 10)
			uiPadding.PaddingTop = UDim.new(0, 8)
			local uiListLayout = Instance.new("UIListLayout", frame)
			uiListLayout.Padding = UDim.new(0, 5)
			uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			local frame2 = Instance.new("Frame")
			frame2.BackgroundTransparency = 1
			frame2.LayoutOrder = 0
			frame2.Size = UDim2.new(1, 0, 0, 16)
			frame2.Parent = frame

			if arg.icon then
				tbl17.image(frame2, arg.icon, 12, v21.accent).Position = UDim2.fromOffset(0, 2)
			end

			tbl17.text(frame2, {text = arg.title, style = "label", color = v21.muted, pos = UDim2.fromOffset(arg.icon and 17 or 0, 0), size = UDim2.new(1, -20, 1, 0)})
			frame.Parent = parent
			return frame
		end

		local tbl20 = {}

		tbl17.later = function(arg, arg2)
			if tbl20[arg] then
				return
			end
			tbl20[arg] = true

			task.defer(function()
				tbl20[arg] = nil
				fn67()
				local ok, result = pcall(arg2)

				if not ok then
					warn("[Sena panels] repaint error:", result)
				end
			end)
		end

		tbl17.assetrow = function(parent, arg, arg2)
			local frame = Instance.new("Frame")
			frame.BackgroundColor3 = v21.surface
			frame.BackgroundTransparency = 0.12
			frame.BorderSizePixel = 0
			frame.Size = UDim2.new(1, -6, 0, 40)
			Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
			local uiStroke = Instance.new("UIStroke", frame)
			uiStroke.Color = v21.strokeCol
			uiStroke.Transparency = 0.72
			local frame2 = Instance.new("Frame")
			frame2.BorderSizePixel = 0
			frame2.Position = UDim2.fromOffset(0, 6)
			frame2.Size = UDim2.new(0, 3, 1, -12)
			frame2.Parent = frame
			Instance.new("UICorner", frame2).CornerRadius = UDim.new(1, 0)
			local imageLabel = Instance.new("ImageLabel")
			imageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			imageLabel.BackgroundTransparency = 0.94
			imageLabel.BorderSizePixel = 0
			imageLabel.Position = UDim2.fromOffset(10, 7)
			imageLabel.ScaleType = Enum.ScaleType.Fit
			imageLabel.Size = UDim2.fromOffset(26, 26)
			imageLabel.Parent = frame
			Instance.new("UICorner", imageLabel).CornerRadius = UDim.new(0, 6)
			local frame3 = Instance.new("Frame")
			frame3.AnchorPoint = Vector2.new(0.5, 0.5)
			frame3.BorderSizePixel = 0
			frame3.Position = UDim2.fromScale(0.5, 0.5)
			frame3.Size = UDim2.fromOffset(9, 9)
			frame3.Parent = imageLabel
			Instance.new("UICorner", frame3).CornerRadius = UDim.new(1, 0)
			local v22 = tbl17.text(frame, {style = "body", pos = UDim2.fromOffset(44, 5), size = UDim2.new(1, -(44 + arg + 14), 0, 16)})
			local v23 = tbl17.text(frame, {style = "meta", pos = UDim2.fromOffset(44, 21), size = UDim2.new(1, -(44 + arg + 14), 0, 14)})
			local frame4 = Instance.new("Frame")
			frame4.AnchorPoint = Vector2.new(1, 0.5)
			frame4.BackgroundTransparency = 1
			frame4.Position = UDim2.new(1, -8, 0.5, 0)
			frame4.Size = UDim2.new(0, arg, 1, -8)
			frame4.Parent = frame
			frame.Parent = parent
			local tbl21 = {frame = frame, bar = frame2, icon = imageLabel, dot = frame3, name = v22, sub = v23, right = frame4}

			if arg2 then
				arg2(tbl21)
			end

			return tbl21
		end

		tbl17.bindasset = function(arg, image2, backgroundColor3, arg2, arg3)
			arg.bar.BackgroundColor3 = backgroundColor3 or v21.accent
			arg.icon.Image = image2 or ""
			arg.dot.Visible = image2 == nil
			arg.dot.BackgroundColor3 = backgroundColor3 or v21.accent
			arg.name.Text = tostring(arg2 or "")
			arg.sub.Text = tostring(arg3 or "")
			arg.sub.TextColor3 = backgroundColor3 or v21.muted
		end

		tbl17.scroller = function(parent, position, size)
			local scrollingFrame = Instance.new("ScrollingFrame")
			scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
			scrollingFrame.BackgroundTransparency = 1
			scrollingFrame.BorderSizePixel = 0
			scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
			scrollingFrame.Position = position
			scrollingFrame.ScrollBarImageColor3 = v21.accent
			scrollingFrame.ScrollBarThickness = 3
			scrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
			scrollingFrame.Size = size
			scrollingFrame.Parent = parent
			local uiListLayout = Instance.new("UIListLayout", scrollingFrame)
			uiListLayout.Padding = UDim.new(0, 4)
			uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			return scrollingFrame
		end

		tbl17.empty = function(arg, arg2)
			local v22 = tbl17.text(arg, {text = arg2, style = "meta", color = v21.muted, align = Enum.TextXAlignment.Center, size = UDim2.new(1, -6, 0, 40)})
			v22.LayoutOrder = -1
			v22.Visible = false
			return v22
		end
	end

	local tbl18 = {}
	local tbl19 = {}

	local function fn78(arg)
		local assetCategory = arg and (arg.AssetCategory or arg.Category)
		if not assetCategory then
			return
		end
		local uid = arg.Uid

		if uid ~= nil then
			if tbl19[uid] then
				return
			end
			tbl19[uid] = true
		end

		uid = tbl18[assetCategory]

		if uid then
		else
			local v22, v23, v24 = fn71(assetCategory)
			uid = {name = assetCategory, rarity = v23, rnum = v22, color = v24, count = 0, last = 0, image = fn72(assetCategory)}
			tbl18[assetCategory] = uid
		end

		uid.count = uid.count + 1
		uid.last = os.clock()
	end

	local windows = {}

	local function fn79(arg)
		local v22 = windows[arg]
		return v22 ~= nil and v22.gui ~= nil and v22.gui.Parent ~= nil and v22.gui.Enabled or false
	end

	local fn80, fn81, fn82, fn83
	local tbl20 = {list = nil, headLbl = nil, countLbl = nil, statusBtn = nil, sel = nil, rows = {}, picked = {}, chips = {}, sortBtns = {}, modeBtns = {}}
	local tbl21 = {history = {}, reportedUids = {}, knownFieldUids = {}, lastAlert = nil, lastReportTime = 0, lastSync = 0, onlineCount = 1, category = "targets", filter = "All"}

	local function fn84(arg)
		fn67()

		if arg == "logs" then
			if fn80 then
				fn80()
			end
		elseif arg == "eggs" then
			if fn81 then
				fn81()
			end
		elseif arg == "inventory" then
			if fn82 then
				fn82()
			end
		elseif arg == "checker" then
			if tbl20 and tbl20.refresh then
				tbl20.refresh()
			end
		elseif arg == "eggdata" then
			if tbl21 and tbl21.refresh then
				tbl21.refresh()
			end
		elseif arg == "stats" then
			if fn83 then
				fn83()
			end
		end
	end

	local tbl22 = {sort = "rarity", list = nil, total = nil, empty = nil}

	fn80 = function()
		fn67()
		if not tbl22.list then
			return
		end
		local tbl23 = {}
		local v22 = tbl18
		local n8 = 0

		for k, v23 in pairs(v22) do
			table.insert(tbl23, v23)
			n8 += v23.count
		end

		if tbl22.sort == "count" then
			table.sort(tbl23, function(arg, arg2)
				if arg.count == arg2.count then
					return (arg.rnum or 0) > (arg2.rnum or 0)
				end
				return arg.count > arg2.count
			end)
		elseif tbl22.sort == "name" then
			table.sort(tbl23, function(arg, arg2)
				return tostring(arg.name) < tostring(arg2.name)
			end)
		else
			table.sort(tbl23, function(arg, arg2)
				if arg.rnum == arg2.rnum then
					return arg.count > arg2.count
				end
				return (arg.rnum or 0) > (arg2.rnum or 0)
			end)
		end

		tbl22.list.setData(tbl23)
		tbl22.empty.Visible = #tbl23 == 0
		tbl22.total.Text = string.format("%d egg%s seen", n8, n8 == 1 and "" or "s")
	end

	local function fn85(arg)
		tbl22.total = tbl17.text(arg, {style = "meta", color = v21.muted, align = Enum.TextXAlignment.Right, anchor = Vector2.new(1, 0), pos = UDim2.new(1, -14, 0, 6), size = UDim2.fromOffset(140, 20)})

		local v22 = tbl17.segmented(arg, {options = {{"rarity", "Rarity"}, {"count", "Amount"}, {"name", "Name"}}, value = tbl22.sort, pos = UDim2.fromOffset(14, 2), size = UDim2.new(1, -170, 0, 28), onChange = function(sort)
			tbl22.sort = sort
			fn80()
		end})

		local v23 = tbl17.button(arg, {text = "Clear", icon = "trash-2", onClick = function()
			tbl18, tbl19 = {}, {}
			fn80()
		end})

		v23.inst.AnchorPoint = Vector2.new(1, 0)
		v23.inst.Position = UDim2.new(1, -14, 0, 30)
		tbl17.text(arg, {text = "Egg", style = "label", color = v21.muted, pos = UDim2.fromOffset(16, 40), size = UDim2.fromOffset(120, 14)})
		local v24 = tbl17.scroller(arg, UDim2.fromOffset(14, 60), UDim2.new(1, -28, 1, -68))
		tbl22.empty = tbl17.empty(v24, "No eggs seen yet. Eggs that spawn on the field show up here.")

		tbl22.list = tbl17.list({build = function()
			return tbl17.assetrow(v24, 70, function(arg2)
				arg2.count = tbl17.text(arg2.right, {style = "value", textsize = 14, color = v21.accent, align = Enum.TextXAlignment.Right, size = UDim2.fromScale(1, 1)})
			end)
		end, bind = function(arg2, arg3)
			tbl17.bindasset(arg2, arg3.image, arg3.color, arg3.name, arg3.rarity)
			arg2.count.Text = "x" .. tostring(arg3.count)
		end})

		v22.set(tbl22.sort, false)
		fn80()
	end

	local tbl23 = {filter = "All", list = nil, total = nil, status = nil, empty = nil}
	local tbl24 = {}

	fn81 = function()
		fn67()
		if not tbl23.list then
			return
		end

		local ok, result = pcall(function()
			return EggState2.ReadOwnerEggs(localPlayer.UserId)
		end)

		if if ok then type(result) ~= "table" else not ok then
			tbl23.list.setData({})
			tbl23.total.Text = "0 waiting"
			return
		end

		local tbl25 = {}
		local n8 = 0

		for k, v22 in pairs(result) do
			if v22.Placement == nil and tostring(k):sub(1, 8) ~= "SENAVIS_" then
				local v23, v24, v25 = fn71(v22.AssetCategory)

				if tbl23.filter == "All" or v24 == tbl23.filter then
					local flag6 = tbl24[k] ~= false
					n8 = if flag6 then n8 + 1 else n8
					local directory = Assets.Directory and Assets.Directory[v22.AssetCategory]
					table.insert(tbl25, {uid = k, name = directory and directory.DisplayName or v22.AssetCategory or tostring(k):sub(1, 8), rarity = v24, rnum = v23, color = v25, image = fn72(v22.AssetCategory), enabled = flag6})
				end
			end
		end

		table.sort(tbl25, function(arg, arg2)
			if arg.rnum == arg2.rnum then
				return arg.name < arg2.name
			end
			return (arg.rnum or 0) > (arg2.rnum or 0)
		end)

		tbl23.list.setData(tbl25)
		tbl23.empty.Visible = #tbl25 == 0
		tbl23.total.Text = string.format("%d waiting  \194\183  %d on", #tbl25, n8)
		result, ok, tbl25 = fn77()

		if ok <= 0 then
			tbl23.status.Text = string.format("Plot full: %d/50 placed, %d waiting", result, tbl25)
			tbl23.status.TextColor3 = Color3.fromRGB(245, 196, 81)
		else
			tbl23.status.Text = string.format("Plot %d/50  \194\183  room for %d more  \194\183  %d waiting", result, ok, tbl25)
			tbl23.status.TextColor3 = v21.muted
		end
	end

	local function fn86(parent)
		local tbl25 = {{"All", "All"}}

		for i, v22 in ipairs(fn74()) do
			tbl25[#tbl25 + 1] = {v22, v22}
		end

		tbl17.segmented(parent, {options = tbl25, value = tbl23.filter, pos = UDim2.fromOffset(14, 2), size = UDim2.new(1, -28, 0, 28), onChange = function(filter)
			tbl23.filter = filter
			fn81()
		end})

		tbl17.text(parent, {text = "Egg", style = "label", color = v21.muted, pos = UDim2.fromOffset(16, 38), size = UDim2.fromOffset(120, 14)})
		tbl17.text(parent, {text = "Place", style = "label", color = v21.muted, align = Enum.TextXAlignment.Right, anchor = Vector2.new(1, 0), pos = UDim2.new(1, -18, 0, 38), size = UDim2.fromOffset(60, 14)})
		local v22 = tbl17.scroller(parent, UDim2.fromOffset(14, 56), UDim2.new(1, -28, 1, -124))
		tbl23.empty = tbl17.empty(v22, "No eggs waiting to be placed.")

		tbl23.list = tbl17.list({build = function()
			return tbl17.assetrow(v22, 64, function(arg)
				arg.toggle = tbl17.button(arg.right, {text = "ON", h = 24, minw = 52, onClick = function()
					local uid = arg.uid
					if uid == nil then
						return
					end

					if tbl24[uid] == false then
						tbl24[uid] = nil
					else
						tbl24[uid] = false
					end

					fn81()
				end})

				arg.toggle.inst.AnchorPoint = Vector2.new(1, 0.5)
				arg.toggle.inst.Position = UDim2.new(1, 0, 0.5, 0)
			end)
		end, bind = function(arg, arg2)
			arg.uid = arg2.uid
			tbl17.bindasset(arg, arg2.image, arg2.color, arg2.name, arg2.rarity)
			arg.toggle.setText(arg2.enabled and "ON" or "OFF")
			arg.toggle.setActive(arg2.enabled)
		end})

		local frame = Instance.new("Frame")
		frame.BackgroundTransparency = 1
		frame.Position = UDim2.new(0, 14, 1, -62)
		frame.Size = UDim2.new(1, -28, 0, 28)
		frame.Parent = parent
		local uiListLayout = Instance.new("UIListLayout", frame)
		uiListLayout.FillDirection = Enum.FillDirection.Horizontal
		uiListLayout.Padding = UDim.new(0, 6)
		uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center

		tbl17.button(frame, {text = "Toggle all", order = 1, h = 28, icon = "list", onClick = function()
			local ok, result = pcall(function()
				return EggState2.ReadOwnerEggs(localPlayer.UserId)
			end)

			if ok then
				if type(result) ~= "table" then
					return
				end
			else
				return
			end

			ok = false

			for k, v23 in pairs(result) do
				if v23.Placement == nil and tbl24[k] == false then
					ok = true
					break
				end
			end

			for k, v23 in pairs(result) do
				if v23.Placement == nil then
					if ok then
						tbl24[k] = nil
					else
						tbl24[k] = false
					end
				end
			end

			fn81()
		end})

		tbl17.button(frame, {text = "Start placing", kind = "primary", order = 2, h = 28, icon = "play", onClick = function()
			if type(applyAutoPlace) == "function" then
				applyAutoPlace(true)
			elseif type(tbl10) == "table" then
				if type(tbl10.AutoPlaceLoop) == "function" then
					senaV4Config.AutoPlace = true
					task.spawn(tbl10.AutoPlaceLoop)
				end
			end
		end})

		tbl23.total = tbl17.text(frame, {style = "meta", color = v21.muted, align = Enum.TextXAlignment.Right, order = 3, size = UDim2.new(1, -250, 1, 0)})
		tbl23.total.LayoutOrder = 3
		tbl23.status = tbl17.text(parent, {style = "meta", color = v21.muted, pos = UDim2.new(0, 16, 1, -28), size = UDim2.new(1, -32, 0, 18)})
		fn81()
	end

	local tbl25 = {view = "backpack", sort = "moneys", asc = false, list = nil, total = nil, empty = nil, sortbar = nil}

	local function collectPets(arg)
		local tbl26 = (Save.Peek or Save.Get)() or {}
		local tbl27 = {}
		local n8 = 0

		local function fn87(arg2, arg3)
			if tostring(arg2):sub(1, 8) == "SENAVIS_" then
				return
			end
			local assetCategory = arg3.AssetCategory or arg3.Category
			local directory, v22, v23, v24 = Assets.Directory and Assets.Directory[assetCategory], fn71(assetCategory)
			local v25 = fn75({AssetCategory = assetCategory, AssetScale = arg3.Scale or arg3.AssetScale or 1, Category = assetCategory, Scale = arg3.Scale or arg3.AssetScale or 1, Mutations = arg3.Mutations or {}})
			local v26 = fn76(arg3)
			n8 += v25
			table.insert(tbl27, {name = directory and directory.DisplayName or tostring(assetCategory), icon = fn72(assetCategory), kg = v26, kgS = string.format("%.1f kg", v26), moneys = v25, rnum = v22, rarity = v23, color = v24})
		end

		if arg == "inplot" then
			for i, v22 in ipairs(tbl26.EquippedAssets or {}) do
				local inventory = tbl26.Inventory and tbl26.Inventory[v22]

				if inventory then
					fn87(v22, inventory)
				end
			end
		else
			for k, v22 in pairs(tbl26.Inventory or {}) do
				if type(v22) == "table" then
					if v22.AssetCategory then
						fn87(k, v22)
					elseif v22.Category then
						fn87(k, v22)
					end
				end
			end
		end

		return tbl27, n8
	end

	senaPanels.collectPets = collectPets
	local tbl26 = {moneys = "Money/s", kg = "Kg", rarity = "Rarity", name = "Name"}

	local function fn87()
		if not tbl25.sortbar then
			return
		end

		for k, button in pairs(tbl25.sortbar.buttons) do
			local v22 = tbl26[k]
			local v23 = if k == tbl25.sort then v22 .. (tbl25.asc and "  \226\134\145" or "  \226\134\147") else v22
			button.setText(v23)
		end
	end

	fn82 = function()
		fn67()
		if not tbl25.list then
			return
		end
		local v22, v23 = collectPets(tbl25.view)
		local sort = tbl25.sort == "rarity" and "rnum" or tbl25.sort

		table.sort(v22, function(arg, arg2)
			if arg[sort] == arg2[sort] then
				return arg.name < arg2.name
			end

			if tbl25.asc then
				return (arg[sort] or 0) < (arg2[sort] or 0)
			end
			return (arg[sort] or 0) > (arg2[sort] or 0)
		end)

		tbl25.list.setData(v22)
		tbl25.empty.Visible = #v22 == 0

		if tbl25.view == "inplot" then
			tbl25.total.Text = string.format("%d placed  \194\183  %s/s", #v22, fn70(v23))
		else
			tbl25.total.Text = string.format("%d pet%s", #v22, #v22 == 1 and "" or "s")
		end
	end

	local function fn88(arg)
		tbl25.total = tbl17.text(arg, {style = "meta", color = v21.muted, align = Enum.TextXAlignment.Right, anchor = Vector2.new(1, 0), pos = UDim2.new(1, -14, 0, 6), size = UDim2.fromOffset(170, 20)})

		tbl17.segmented(arg, {options = {{"backpack", "Backpack"}, {"inplot", "Base"}}, value = tbl25.view, pos = UDim2.fromOffset(14, 2), size = UDim2.new(1, -200, 0, 28), onChange = function(view)
			tbl25.view = view
			fn82()
		end})

		tbl25.sortbar = tbl17.segmented(arg, {options = {{"moneys", "Money/s"}, {"kg", "Kg"}, {"rarity", "Rarity"}, {"name", "Name"}}, value = tbl25.sort, pos = UDim2.fromOffset(14, 34), size = UDim2.new(1, -28, 0, 28), onChange = function(sort)
			if tbl25.sort == sort then
				tbl25.asc = not tbl25.asc
			else
				tbl25.sort = sort
				tbl25.asc = false
			end

			fn87()
			fn82()
		end})

		tbl17.text(arg, {text = "Pet", style = "label", color = v21.muted, pos = UDim2.fromOffset(16, 68), size = UDim2.fromOffset(120, 14)})
		tbl17.text(arg, {text = "Money/s  \194\183  Kg", style = "label", color = v21.muted, align = Enum.TextXAlignment.Right, anchor = Vector2.new(1, 0), pos = UDim2.new(1, -18, 0, 68), size = UDim2.fromOffset(140, 14)})
		local v22 = tbl17.scroller(arg, UDim2.fromOffset(14, 86), UDim2.new(1, -28, 1, -94))
		tbl25.empty = tbl17.empty(v22, "No pets here yet.")

		tbl25.list = tbl17.list({build = function()
			return tbl17.assetrow(v22, 96, function(arg2)
				arg2.money = tbl17.text(arg2.right, {style = "body", align = Enum.TextXAlignment.Right, pos = UDim2.fromOffset(0, 1), size = UDim2.new(1, 0, 0, 16)})
				arg2.money.Font = BuilderSansBold
				arg2.kg = tbl17.text(arg2.right, {style = "meta", color = v21.muted, align = Enum.TextXAlignment.Right, pos = UDim2.fromOffset(0, 17), size = UDim2.new(1, 0, 0, 14)})
			end)
		end, bind = function(arg2, arg3)
			tbl17.bindasset(arg2, arg3.icon, arg3.color, arg3.name, arg3.rarity)
			arg2.money.Text = fn70(arg3.moneys) .. "/s"
			arg2.money.TextColor3 = arg3.moneys > 0 and v21.text or v21.muted
			arg2.kg.Text = arg3.kgS
		end})

		fn87()
		fn82()
	end

	local tbl27 = {}
	local now = os.clock()
	local tbl28
	local tbl29 = {}

	local function fn89()
		local senaV4Webhook = genv.__SenaV4Webhook

		if type(senaV4Webhook) == "table" and type(senaV4Webhook.stolen) == "function" and not rawget(senaV4Webhook, "__senaStatsWrapped") then
			local stolen = senaV4Webhook.stolen
			rawset(senaV4Webhook, "__senaStatsWrapped", true)

			senaV4Webhook.stolen = function(arg, arg2, arg3)
				pcall(function()
					local uid = type(arg) == "table" and arg.Uid or nil

					if uid ~= nil then
						if tbl29[uid] then
							return
						end
						tbl29[uid] = true
					end

					local n8 = type(senaV4Webhook.rateOf) == "function" and tonumber(senaV4Webhook.rateOf(arg)) or 0

					if if tbl28 then n8 > tbl28.rate else not tbl28 then
						tbl28 = {name = tostring(type(arg2) == "table" and arg2.name or type(arg) == "table" and arg.AssetCategory or "Egg"), rate = n8 or 0}
					end
				end)

				return stolen(arg, arg2, arg3)
			end
		end
	end

	pcall(fn89)

	local function fn90(arg)
		local n8 = math.max(0, math.floor(arg))
		return string.format("%02d:%02d:%02d", math.floor(n8 / 3600), math.floor(n8 % 3600 / 60), n8 % 60)
	end

	fn83 = function()
		fn67()
		if not tbl27.tiles then
			return
		end
		local tbl30 = (Save.Peek or Save.Get)() or {}
		local senaV4TaskLadder2 = genv.__SenaV4TaskLadder
		local n8 = senaV4TaskLadder2 and senaV4TaskLadder2.current() or nil

		if n8 then
			local v22 = senaV4TaskLadder2.describe(n8)
			tbl27.nowTask.Text = senaV4TaskLadder2.TITLES[n8] or tostring(n8)
			tbl27.nowStatus.Text = tostring(v22 or "")
			tbl27.nowDot.BackgroundColor3 = v21.good
		else
			tbl27.nowTask.Text = "Idle"
			tbl27.nowStatus.Text = "Nothing is using the character"
			tbl27.nowDot.BackgroundColor3 = v21.muted
		end

		local n9 = 0

		pcall(function()
			n9 = math.floor((localPlayer:GetNetworkPing() or 0) * 2000 + 0.5)
		end)

		tbl27.nowMeta.Text = string.format("%s  \194\183  %d ms  \194\183  %d fps", fn90(os.clock() - now), n9, math.floor((tonumber(fn3()) or 0) + 0.5))
		senaV4TaskLadder2, n8 = collectPets("inplot")
		local n10 = tonumber(tbl30.Money) or 0
		tbl27.tiles.money.set(fn70(n10), "+" .. fn70(n8 * 3600) .. " per hour", v21.good)
		tbl27.tiles.income.set(fn70(n8) .. "/s", #senaV4TaskLadder2 .. " pet" .. (#senaV4TaskLadder2 == 1 and "" or "s") .. " placed")
		local num
		local str3 = ""

		pcall(function()
			local senaV4MovementExtras = genv.__SenaV4MovementExtras

			if senaV4MovementExtras then
				num = tonumber(senaV4MovementExtras:_gameWalkSpeed())
			end
		end)

		pcall(function()
			local senaV4TreadmillManager = genv.__SenaV4TreadmillManager

			if senaV4TreadmillManager then
				local v22, v23, v24 = senaV4TreadmillManager:_readUpgradeState()

				if v24 then
					str3 = "Next: " .. tostring(v24.DisplayName or v24._id or "tier") .. "  " .. fn70(tonumber(v24.Price) or 0)
				elseif v22 then
					str3 = "Treadmill maxed"
				end
			end
		end)

		tbl27.tiles.speed.set(num and string.format("%.0f", num) or "--", str3)
		local senaV4EggRuntime = genv.__SenaV4EggRuntime
		local senaV4PlayerSteal = genv.__SenaV4PlayerSteal
		n8 = (senaV4EggRuntime and senaV4EggRuntime.stats and tonumber(senaV4EggRuntime.stats.delivered) or 0) + (senaV4PlayerSteal and tonumber(senaV4PlayerSteal.taken) or 0)
		tbl27.tiles.stolen.set(tostring(n8), tbl28 and "Best: " .. tbl28.name .. "  " .. fn70(tbl28.rate) .. "/s" or "No steal yet this session")
		n10 = 0

		for k in pairs(tbl30.Inventory or {}) do
			n10 = if tostring(k):sub(1, 8) ~= "SENAVIS_" then n10 + 1 else n10
		end

		local v22, v23, v24 = fn77()
		tbl27.tiles.collection.set(n10 .. " pets", string.format("Eggs %d/50 placed  \194\183  %d waiting", v22, v24))
		local flag6 = false

		pcall(function()
			flag6 = senaV4EggRuntime ~= nil and senaV4EggRuntime:getSnapshot().wallClosed == true
		end)

		tbl27.tiles.world.set(flag6 and "Night" or "Day", #Players:GetPlayers() .. " players in this server", flag6 and Color3.fromRGB(245, 196, 81) or v21.muted)
		local senaV4ScrambleBoss, v25 = genv.__SenaV4ScrambleBoss

		pcall(function()
			v25 = senaV4ScrambleBoss and senaV4ScrambleBoss:_snapshot()
		end)

		local eventActive = v25 ~= nil and (v25.eventActive or v25.portalOpen or v25.inArena)
		tbl27.scramble.Visible = eventActive == true

		if eventActive then
			if v25.inArena then
				tbl27.scrambleLine1.Text = string.format("Fighting  \194\183  %s  \194\183  HP %d / %d", tostring(v25.phase), v25.health or 0, v25.maxHealth or 0)
			else
				if v25.portalOpen then
					tbl27.scrambleLine1.Text = "Boss portal is open"
				else
					tbl27.scrambleLine1.Text = "Boss portal " .. tostring(v25.countdownLabel or "soon")
				end
			end

			tbl27.scrambleLine2.Text = string.format("Mastery %s  \194\183  Samples %s  \194\183  Last reward: %s", tostring(v25.mastery or 0), tostring(v25.samples or 0), tostring(v25.reward or "--"))
		end

		table.sort(senaV4TaskLadder2, function(arg, arg2)
			return (arg.moneys or 0) > (arg2.moneys or 0)
		end)

		local tbl31 = {}

		for i = 1, math.min(5, #senaV4TaskLadder2), 1 do
			tbl31[i] = senaV4TaskLadder2[i]
		end

		tbl27.top.setData(tbl31)
		tbl27.topEmpty.Visible = #tbl31 == 0
	end

	local function fn91(parent)
		local scrollingFrame = Instance.new("ScrollingFrame")
		scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
		scrollingFrame.BackgroundTransparency = 1
		scrollingFrame.BorderSizePixel = 0
		scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
		scrollingFrame.Position = UDim2.fromOffset(14, 0)
		scrollingFrame.ScrollBarImageColor3 = v21.accent
		scrollingFrame.ScrollBarThickness = 3
		scrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
		scrollingFrame.Size = UDim2.new(1, -28, 1, -4)
		scrollingFrame.Parent = parent
		local uiListLayout = Instance.new("UIListLayout", scrollingFrame)
		uiListLayout.Padding = UDim.new(0, 8)
		uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		local frame = Instance.new("Frame")
		frame.BackgroundColor3 = v21.surface
		frame.BackgroundTransparency = 0.1
		frame.BorderSizePixel = 0
		frame.LayoutOrder = 1
		frame.Size = UDim2.new(1, -6, 0, 50)
		frame.Parent = scrollingFrame
		Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
		local uiStroke = Instance.new("UIStroke", frame)
		uiStroke.Color = v21.accent
		uiStroke.Transparency = 0.6
		local frame2 = Instance.new("Frame")
		frame2.BorderSizePixel = 0
		frame2.Position = UDim2.fromOffset(12, 13)
		frame2.Size = UDim2.fromOffset(8, 8)
		frame2.Parent = frame
		Instance.new("UICorner", frame2).CornerRadius = UDim.new(1, 0)
		tbl27.nowDot = frame2
		tbl27.nowTask = tbl17.text(frame, {text = "Idle", style = "body", pos = UDim2.fromOffset(26, 6), size = UDim2.new(0.55, -26, 0, 18)})
		tbl27.nowTask.Font = BuilderSansBold
		tbl27.nowStatus = tbl17.text(frame, {text = "", style = "meta", color = v21.muted, pos = UDim2.fromOffset(12, 27), size = UDim2.new(1, -24, 0, 16)})
		tbl27.nowMeta = tbl17.text(frame, {text = "", style = "meta", color = v21.muted, align = Enum.TextXAlignment.Right, anchor = Vector2.new(1, 0), pos = UDim2.new(1, -12, 0, 7), size = UDim2.new(0.45, 0, 0, 16)})
		local frame3 = Instance.new("Frame")
		frame3.AutomaticSize = Enum.AutomaticSize.Y
		frame3.BackgroundTransparency = 1
		frame3.LayoutOrder = 2
		frame3.Size = UDim2.new(1, -6, 0, 0)
		frame3.Parent = scrollingFrame
		local uiGridLayout = Instance.new("UIGridLayout", frame3)
		uiGridLayout.CellPadding = UDim2.fromOffset(8, 8)
		uiGridLayout.CellSize = UDim2.new(0.5, -4, 0, 62)
		uiGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
		tbl27.tiles = {money = tbl17.stat(frame3, {label = "Money", icon = "wallet", order = 1}), income = tbl17.stat(frame3, {label = "Income", icon = "trending-up", order = 2}), speed = tbl17.stat(frame3, {label = "Speed", icon = "gauge", order = 3}), stolen = tbl17.stat(frame3, {label = "Stolen", icon = "hand", order = 4}), collection = tbl17.stat(frame3, {label = "Collection", icon = "package", order = 5}), world = tbl17.stat(frame3, {label = "World", icon = "globe", order = 6})}
		tbl27.scramble = tbl17.card(scrollingFrame, {title = "Dr Scramble", icon = "swords", order = 3})
		tbl27.scramble.Size = UDim2.new(1, -6, 0, 0)
		tbl27.scramble.Visible = false
		tbl27.scrambleLine1 = tbl17.text(tbl27.scramble, {text = "", style = "body", order = 1})
		tbl27.scrambleLine2 = tbl17.text(tbl27.scramble, {text = "", style = "meta", color = v21.muted, order = 2})
		local v22 = tbl17.card(scrollingFrame, {title = "Top earners on your plot", icon = "trending-up", order = 4})
		v22.Size = UDim2.new(1, -6, 0, 0)
		local frame4 = Instance.new("Frame")
		frame4.AutomaticSize = Enum.AutomaticSize.Y
		frame4.BackgroundTransparency = 1
		frame4.LayoutOrder = 1
		frame4.Size = UDim2.new(1, 0, 0, 0)
		frame4.Parent = v22
		local uiListLayout2 = Instance.new("UIListLayout", frame4)
		uiListLayout2.Padding = UDim.new(0, 4)
		uiListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
		tbl27.topEmpty = tbl17.empty(frame4, "Place pets on your plot to see them here.")

		tbl27.top = tbl17.list({build = function()
			return tbl17.assetrow(frame4, 96, function(arg)
				arg.frame.Size = UDim2.new(1, 0, 0, 40)
				arg.money = tbl17.text(arg.right, {style = "body", align = Enum.TextXAlignment.Right, pos = UDim2.fromOffset(0, 1), size = UDim2.new(1, 0, 0, 16)})
				arg.money.Font = BuilderSansBold
				arg.kg = tbl17.text(arg.right, {style = "meta", color = v21.muted, align = Enum.TextXAlignment.Right, pos = UDim2.fromOffset(0, 17), size = UDim2.new(1, 0, 0, 14)})
			end)
		end, bind = function(arg, arg2)
			tbl17.bindasset(arg, arg2.icon, arg2.color, arg2.name, arg2.rarity)
			arg.money.Text = fn70(arg2.moneys) .. "/s"
			arg.kg.Text = arg2.kgS
		end})

		fn83()

		task.spawn(function()
			while fn2() and scrollingFrame.Parent do
				task.wait(1)

				if fn79("stats") then
					tbl17.later("stats", fn83)
				end
			end
		end)
	end

	tbl20.sort = "value"
	tbl20.rarity = "All"
	tbl20.picked = {}
	tbl20.chips = {}
	tbl20.sortBtns = {}
	tbl20.modeBtns = {}
	tbl20.rows = {}

	tbl20.fmtKg = function(arg)
		local n8 = tonumber(arg) or 0
		local str3 = n8 >= 100 and string.format("%.1f", n8) or string.format("%.2f", n8)
		local match, v22 = str3:match("^(%d+)(%.%d+)$")
		return (match or str3):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "") .. (v22 or "") .. " kg"
	end

	tbl20.scan = function()
		local v22

		pcall(function()
			v22 = EggState2.ReadFieldEggs()
		end)

		local tbl30 = {}

		for i, v23 in ipairs(v22 and v22.Records or {}) do
			if v23.State ~= "Claimed" and (v23.State ~= "Carried" and (not v23.CarrierUserId and (v23.BottomCFrame and not tostring(v23.Uid):find("FirstAreaEgg")))) then
				local assetCategory = v23.AssetCategory
				local directory, v24, v25, v26 = assetCategory and Assets.Directory and Assets.Directory[assetCategory], fn71(assetCategory)
				local v27 = fn75({AssetCategory = assetCategory, Category = assetCategory, AssetScale = v23.AssetScale or v23.Scale or 1, Scale = v23.AssetScale or v23.Scale or 1, Mutations = v23.Mutations or {}})
				local v28 = fn76(v23)
				tbl30[#tbl30 + 1] = {rec = v23, uid = v23.Uid, name = directory and directory.DisplayName or tostring(assetCategory or "Egg"), rarity = v25, rnum = v24, color = v26, area = tostring(v23.AreaId or "?"), rate = v27, kg = v28, scale = tonumber(v23.AssetScale or v23.Scale) or 1, icon = fn72(assetCategory)}
			end
		end

		if tbl20.rarity ~= "All" then
			local tbl31 = {}

			for i, v23 in ipairs(tbl30) do
				if v23.rarity == tbl20.rarity then
					tbl31[#tbl31 + 1] = v23
				end
			end

			tbl30 = tbl31
		end

		table.sort(tbl30, function(arg, arg2)
			if tbl20.sort == "weight" then
				if (arg.kg or 0) ~= (arg2.kg or 0) then
					return (arg.kg or 0) > (arg2.kg or 0)
				end
				return (arg.rate or 0) > (arg2.rate or 0)
			end

			if tbl20.sort == "rarity" then
				if arg.rnum ~= arg2.rnum then
					return (arg.rnum or 0) > (arg2.rnum or 0)
				end
				return (arg.rate or 0) > (arg2.rate or 0)
			end

			if arg.rate ~= arg2.rate then
				return (arg.rate or 0) > (arg2.rate or 0)
			end
			return (arg.rnum or 0) > (arg2.rnum or 0)
		end)

		return tbl30
	end

	local tbl30 = {{"Instant Steal (Recommended)", "Instant"}, {"High Speed User Normal", "High"}, {"High Speed User (Fly)", "High Fly"}, {"Zig-Zag High Speed User", "Zig-Zag"}}

	local function fn92()
		local flag6 = type(senaPanels.getStealMode) == "function" and senaPanels.getStealMode() or nil
		return type(flag6) == "string" and flag6 or "Instant Steal (Recommended)"
	end

	function senaPanels.syncStealMode()
		if tbl20.modeSeg then
			tbl20.modeSeg.set(fn92(), false)
		end
	end

	tbl20.paintChips = function()
		if tbl20.raritySeg then
			tbl20.raritySeg.set(tbl20.rarity, false)
		end

		if tbl20.sortSeg then
			tbl20.sortSeg.set(tbl20.sort, false)
		end

		if tbl20.modeSeg then
			tbl20.modeSeg.set(fn92(), false)
		end
	end

	tbl20.paintRows = function()
		local n8 = 0

		for i, row in ipairs(tbl20.rows) do
			if row.frame.Visible and row.uid ~= nil then
				local visible = tbl20.picked[tostring(row.uid)] == true
				n8 = if visible then n8 + 1 else n8
				row.frame.BackgroundTransparency = visible and 0.02 or 0.12
				row.stroke.Transparency = visible and 0.1 or 0.72
				row.stroke.Color = visible and v21.accent or v21.strokeCol
				row.tick.BackgroundTransparency = visible and 0.1 or 0.86
				row.check.Visible = visible
			end
		end

		if tbl20.statusBtn and not tbl20.running then
			tbl20.statusBtn.setText(n8 > 0 and "Steal selected (" .. n8 .. ")" or "Steal selected")
			tbl20.statusBtn.setEnabled(true)
		end

		if tbl20.headLbl then
			tbl20.headLbl.Text = n8 > 0 and n8 .. " picked" or "Tap eggs to pick them"
		end
	end

	tbl20.refresh = function()
		fn67()
		if not tbl20.view then
			return
		end
		local v22 = tbl20.scan()
		local tbl31 = {}

		for i, v23 in ipairs(v22) do
			tbl31[tostring(v23.uid)] = true
		end

		for k in pairs(tbl20.picked) do
			if not tbl31[k] then
				tbl20.picked[k] = nil
			end
		end

		tbl20.view.setData(v22)
		tbl20.emptyLbl.Visible = #v22 == 0

		if tbl20.countLbl then
			tbl20.countLbl.Text = #v22 .. " egg" .. (#v22 == 1 and "" or "s")
		end

		pcall(tbl20.paintChips)
		pcall(tbl20.paintRows)
	end

	tbl20.build = function(parent)
		local frame = Instance.new("Frame")
		frame.BackgroundTransparency = 1
		frame.BorderSizePixel = 0
		frame.Size = UDim2.fromScale(1, 1)
		frame.Parent = parent
		tbl20.headLbl = tbl17.text(frame, {text = "Tap eggs to pick them", style = "meta", color = v21.muted, pos = UDim2.fromOffset(14, 2), size = UDim2.new(1, -135, 0, 18)})
		tbl20.countLbl = tbl17.text(frame, {text = "0 eggs", style = "meta", color = v21.muted, align = Enum.TextXAlignment.Right, anchor = Vector2.new(1, 0), pos = UDim2.new(1, -16, 0, 2), size = UDim2.fromOffset(110, 18)})
		local tbl31 = {{"All", "All"}}
		local tbl32 = {}

		for i, v22 in ipairs(fn74()) do
			tbl31[#tbl31 + 1] = {v22, v22}

			for i2, v23 in ipairs(tbl15) do
				if v23.rname == v22 then
					parent, i2, i = fn71(v23.cat)
					tbl32[v22] = i
					break
				end
			end
		end

		tbl20.raritySeg = tbl17.segmented(frame, {options = tbl31, value = tbl20.rarity, pos = UDim2.fromOffset(14, 22), size = UDim2.new(1, -28, 0, 30), onChange = function(rarity)
			tbl20.rarity = rarity
			tbl20.refresh()
		end})

		for k, button in pairs(tbl20.raritySeg.buttons) do
			local v22 = tbl32[k]

			if v22 then
				local setActive = button.setActive

				button.setActive = function(arg)
					setActive(arg)

					if not arg then
						button.label.TextColor3 = v22
					end
				end
			end
		end

		tbl20.raritySeg.set(tbl20.rarity, false)
		local frame2 = Instance.new("Frame")
		frame2.BackgroundTransparency = 1
		frame2.Position = UDim2.fromOffset(14, 56)
		frame2.Size = UDim2.new(1, -28, 0, 28)
		frame2.Parent = frame

		tbl20.sortSeg = tbl17.segmented(frame2, {options = {{"value", "Best value"}, {"weight", "Best weight"}, {"rarity", "Rarity"}}, value = tbl20.sort, size = UDim2.new(1, -90, 1, 0), onChange = function(sort)
			tbl20.sort = sort
			tbl20.refresh()
		end})

		local v22 = tbl17.button(frame2, {text = "Clear", icon = "x", onClick = function()
			tbl20.picked = {}
			tbl20.paintRows()
		end})

		v22.inst.AnchorPoint = Vector2.new(1, 0.5)
		v22.inst.Position = UDim2.new(1, 0, 0.5, 0)
		tbl17.text(frame, {text = "Move", style = "label", color = v21.muted, pos = UDim2.fromOffset(16, 92), size = UDim2.fromOffset(44, 20)})

		tbl20.modeSeg = tbl17.segmented(frame, {options = tbl30, value = fn92(), pos = UDim2.fromOffset(58, 88), size = UDim2.new(1, -72, 0, 28), onChange = function(arg)
			if type(senaPanels.setStealMode) == "function" then
				senaPanels.setStealMode(arg)
			end
		end})

		local v23 = tbl17.scroller(frame, UDim2.fromOffset(14, 124), UDim2.new(1, -28, 1, -184))
		tbl20.emptyLbl = tbl17.empty(v23, "No eggs on the field right now.")
		tbl20.rows = {}

		tbl20.view = tbl17.list({build = function()
			local v24 = tbl17.assetrow(v23, 96, function(arg)
				arg.frame.Size = UDim2.new(1, -6, 0, 54)
				local frame3 = Instance.new("Frame")
				frame3.BackgroundColor3 = v21.accent
				frame3.BackgroundTransparency = 0.86
				frame3.BorderSizePixel = 0
				frame3.Position = UDim2.fromOffset(10, 16)
				frame3.Size = UDim2.fromOffset(22, 22)
				frame3.Parent = arg.frame
				Instance.new("UICorner", frame3).CornerRadius = UDim.new(0, 6)
				local uiStroke = Instance.new("UIStroke", frame3)
				uiStroke.Color = v21.accent
				uiStroke.Transparency = 0.5
				local v24 = tbl17.image(frame3, "check", 14, Color3.fromRGB(255, 255, 255))
				v24.AnchorPoint = Vector2.new(0.5, 0.5)
				v24.Position = UDim2.fromScale(0.5, 0.5)
				v24.Visible = false
				arg.tick = frame3
				arg.check = v24
				arg.stroke = arg.frame:FindFirstChildOfClass("UIStroke")
				arg.icon.Position = UDim2.fromOffset(40, 9)
				arg.icon.Size = UDim2.fromOffset(36, 36)
				arg.name.Position = UDim2.fromOffset(84, 6)
				arg.name.Size = UDim2.new(1, -194, 0, 19)
				arg.name.TextSize = 15
				arg.sub.Position = UDim2.fromOffset(84, 27)
				arg.sub.Size = UDim2.new(1, -194, 0, 20)
				arg.sub.TextSize = 13
				arg.sub.RichText = true
				arg.rate = tbl17.text(arg.right, {style = "body", color = Color3.fromRGB(126, 224, 151), align = Enum.TextXAlignment.Right, size = UDim2.fromScale(1, 1)})
				arg.rate.Font = BuilderSansBold
				arg.rate.TextSize = 15
				local textButton = Instance.new("TextButton")
				textButton.AutoButtonColor = false
				textButton.BackgroundTransparency = 1
				textButton.Size = UDim2.fromScale(1, 1)
				textButton.Text = ""
				textButton.ZIndex = 3
				textButton.Parent = arg.frame

				local function fn93()
					if arg.uid == nil then
						return
					end
					local str3 = tostring(arg.uid)
					local picked = tbl20.picked
					local v25 = tbl20.picked[str3]
					picked[str3] = if v25 then nil else not v25
					tbl20.paintRows()
				end

				textButton.MouseButton1Click:Connect(fn93)
			end)

			tbl20.rows[#tbl20.rows + 1] = v24
			return v24
		end, bind = function(arg, arg2)
			arg.uid = arg2.uid
			tbl17.bindasset(arg, arg2.icon, arg2.color, arg2.name, string.format("%s  \194\183  %s%s  \194\183  <b>x%.2f</b>", tostring(arg2.rarity or "?"), tostring(arg2.area), arg2.kg and "  \194\183  <b>" .. tbl20.fmtKg(arg2.kg) .. "</b>" or "", arg2.scale or 1))
			arg.name.TextSize = 15
			arg.sub.TextSize = 13
			arg.rate.Text = fn69(arg2.rate) .. "/s"
		end})

		local frame3 = Instance.new("Frame")
		frame3.BackgroundTransparency = 1
		frame3.Position = UDim2.new(0, 14, 1, -52)
		frame3.Size = UDim2.new(1, -28, 0, 34)
		frame3.Parent = frame

		tbl17.button(frame3, {text = "Refresh", icon = "refresh-cw", h = 34, onClick = function()
			pcall(function()
				EggState2.SyncFieldEggs()
			end)

			tbl20.refresh()
		end}).inst.Position = UDim2.fromOffset(0, 0)

		tbl20.statusBtn = tbl17.button(frame3, {text = "Steal selected", kind = "primary", icon = "hand", h = 34, onClick = function()
			if tbl20.running then
				return
			end
			local tbl33 = {}

			for k, v24 in pairs(tbl20.picked) do
				table.insert(tbl33, k)
			end

			if #tbl33 == 0 then
				tbl20.statusBtn.setText("Pick an egg first")

				task.delay(1.5, function()
					if tbl20.statusBtn and not tbl20.running then
						tbl20.paintRows()
					end
				end)

				return
			end

			local senaV4EggRuntime = genv.__SenaV4EggRuntime

			if senaV4EggRuntime and type(senaV4EggRuntime.queueManual) == "function" then
				local v24 = senaV4EggRuntime:queueManual(tbl33)
				tbl20.picked = {}
				tbl20.statusBtn.setText("Queued " .. tostring(v24))

				task.delay(1.5, function()
					if tbl20.statusBtn and not tbl20.running then
						tbl20.paintRows()
					end
				end)

				tbl20.refresh()
			else
				tbl20.statusBtn.setText("Runtime not ready")

				task.delay(1.5, function()
					if tbl20.statusBtn and not tbl20.running then
						tbl20.paintRows()
					end
				end)
			end
		end})

		tbl20.statusBtn.inst.AutomaticSize = Enum.AutomaticSize.None
		tbl20.statusBtn.inst.AnchorPoint = Vector2.new(1, 0)
		tbl20.statusBtn.inst.Position = UDim2.fromScale(1, 0)
		tbl20.statusBtn.inst.Size = UDim2.new(1, -116, 1, 0)
		tbl20.statusBtn.label.TextTruncate = Enum.TextTruncate.AtEnd
		tbl20.paintChips()
		tbl20.refresh()
	end

	local function fn93(arg)
		if arg then
			if type(arg) ~= "string" then
				return "unknown"
			end
		else
			return "unknown"
		end

		local str3 = arg:lower()

		if str3:find("kong") then
			return "gorillaking"
		elseif str3:find("gorilla") then
			return "gorillaking"
		end

		if str3:find("phoenix") then
			return "phoenix"
		end

		if str3:find("lunar") then
			return "lunardragon"
		elseif str3:find("dragon.-lunar") then
			return "lunardragon"
		end

		if str3:find("mosa") then
			return "mosasaurus"
		end

		if str3:find("tiger") then
			return "onitiger"
		elseif str3:find("oni") then
			return "onitiger"
		end

		if str3:find("kitsune") then
			return "kitsune"
		end

		if str3:find("unicorn") then
			return "unicorn"
		end

		if str3:find("godzilla") then
			return "godzilla"
		end

		if str3:find("pegasus") then
			return "pegasus"
		end

		if str3:find("archangel") then
			return "archangel"
		end

		if str3:find("ice.-dragon") then
			return "icedragon"
		end

		if str3:find("lava.-dragon") then
			return "lavadragon"
		elseif str3:find("dragon") then
			return "lavadragon"
		end

		if str3:find("cosmic.-dragon") then
			return "cosmicdragon"
		elseif str3:find("ember") then
			return "cosmicdragon"
		end

		if str3:find("trex") then
			return "trex"
		elseif str3:find("tyranno") then
			return "trex"
		elseif str3:find("t%-rex") then
			return "trex"
		end

		if str3:find("gargoyle") then
			return "gargoyle"
		end

		if str3:find("cerberus") then
			return "cerberus"
		end

		if str3:find("yeti") then
			return "yeti"
		end

		if str3:find("dreadscale") then
			return "dreadscale"
		end

		if str3:find("el.-maja") then
			return "elmaja"
		end
		return (str3:gsub("eternal", ""):gsub("ascended", ""):gsub("vermilion", ""):gsub("divine", ""):gsub("secret", ""):gsub("egg", ""):gsub("[^%a%d]", ""))
	end

	local function fn94(arg)
		if arg then
			if arg <= 0 then
				return 0
			end
		else
			return 0
		end

		return math.floor((arg + 150) / 300) * 300
	end

	local function fn95(arg, arg2)
		if arg then
			if arg <= 0 then
				return "--:--"
			end
		else
			return "--:--"
		end

		local now2 = os.time()
		local v22 = os.date("*t", now2)
		local v23 = os.date("*t", arg)
		local v24 = if v23.year == v22.year and v23.yday == v22.yday then "Today" else if v23.year == v22.year and v23.yday == v22.yday - 1 then "Yesterday" else if v23.year == v22.year and v23.yday == v22.yday + 1 then "Tomorrow" else string.format("%02d/%02d", v23.month, v23.day)

		if arg2 then
			return string.format("%s %02d:%02d:%02d", v24, v23.hour, v23.min, v23.sec)
		else
			return string.format("%s %02d:%02d", v24, v23.hour, v23.min)
		end
	end

	local function fn96(arg)
		if arg then
			if arg <= 0 then
				return ""
			end
		else
			return ""
		end

		local n8 = os.time() - arg

		if n8 < 0 then
			local n9 = -n8
			if n9 < 60 then
				return "in <1m"
			end

			if n9 < 3600 then
				return string.format("in %dm", math.floor(n9 / 60))
			end
			return string.format("in %.1fh", n9 / 3600)
		end

		if n8 < 60 then
			return "Just now"
		end

		if n8 < 3600 then
			return string.format("%dm ago", math.floor(n8 / 60))
		end

		if n8 < 86400 then
			return string.format("%.1fh ago", n8 / 3600)
		end
		return string.format("%.1fd ago", n8 / 86400)
	end

	local function fn97(arg, arg2)
		arg, arg2 = fn94(arg), fn94(arg2)
		local now2 = os.time()
		local v22 = os.date("*t", now2)
		local v23 = os.date("*t", arg)
		local v24 = os.date("*t", arg2)

		local function fn98(arg3)
			if arg3.year == v22.year and arg3.yday == v22.yday then
				return "Today"
			elseif arg3.year == v22.year and arg3.yday == v22.yday + 1 then
				return "Tomorrow"
			elseif arg3.year == v22.year and arg3.yday == v22.yday - 1 then
				return "Yesterday"
			else
				return string.format("%02d/%02d", arg3.month, arg3.day)
			end
		end

		local v25 = fn98(v23)
		local v26 = fn98(v24)

		if v25 == v26 then
			return string.format("%s %02d:%02d - %02d:%02d", v25, v23.hour, v23.min, v24.hour, v24.min)
		else
			return string.format("%s %02d:%02d - %s %02d:%02d", v25, v23.hour, v23.min, v26, v24.hour, v24.min)
		end
	end

	local tbl31 = {Mosasaurus = "rbxassetid://124293259998827", ["Oni Tiger"] = "rbxassetid://109908891899435", ["Eternal Lunar Dragon"] = "rbxassetid://93762296316916", ["Lunar Dragon"] = "rbxassetid://93762296316916", ["King Kong"] = "rbxassetid://135650224014044", ["Gorilla King"] = "rbxassetid://135650224014044", ["Ice Dragon"] = "rbxassetid://101397684798718", Phoenix = "rbxassetid://118067990008425", ["Ascended Vermilion Phoenix"] = "rbxassetid://118067990008425", Dragon = "rbxassetid://78935088838538", ["Lava Dragon"] = "rbxassetid://78935088838538", ["Dragon (Lava)"] = "rbxassetid://78935088838538", Pegasus = "rbxassetid://112830316982322", ["El Maja"] = "rbxassetid://77518688092604", Kitsune = "rbxassetid://107842067813602", Unicorn = "rbxassetid://70463817382627", Godzilla = "rbxassetid://102979882140882", ArchAngel = "rbxassetid://113289118499426", ["Cosmic Dragon"] = "rbxassetid://107923370723949", TRex = "rbxassetid://124293259998827", Gargoyle = "rbxassetid://137949993315884", ["King Snake"] = "rbxassetid://77518688092604"}
	local tbl32 = {}

	local function fn98(arg)
		if not arg then
			return ""
		end

		if tbl31[arg] then
			return tbl31[arg]
		end

		if tbl32[arg] ~= nil then
			return tbl32[arg]
		end
		tbl32[arg] = fn72(arg) or ""
		return tbl32[arg]
	end

	local function fn99(arg)
		local request_ = syn and syn.request or http and http.request or request or http_request

		if request_ then
			local v22
			if pcall(function()
				v22 = request_(arg)
			end) and v22 then
				return v22
			end
		end

		if arg.Method == "GET" and game and game.HttpGet then
			local response
			if pcall(function()
				response = game:HttpGet(arg.Url, true)
			end) and response then
				return {StatusCode = 200, Body = response}
			end
		end

		return nil
	end

	local tbl33 = {{id = "eternal_fast", title = "Eternal", cycleLabel = "45 - 90m", rarity = "Eternal", windowMin = 45, windowMax = 90, priority = 1, color = Color3.fromRGB(255, 215, 0), candidates = {{name = "Mosasaurus", area = "Prehistoric", chance = "10.85%", icon = "rbxassetid://124293259998827"}, {name = "Oni Tiger", area = "Cherry Blossom", chance = "10.85%", icon = "rbxassetid://109908891899435"}, {name = "Lunar Dragon", area = "Cosmic", chance = "10.85%", icon = "rbxassetid://93762296316916"}, {name = "Gorilla King", area = "Titan Temple", chance = "10.85%", icon = "rbxassetid://135650224014044"}, {name = "Ice Dragon", area = "Snow", chance = "10.85%", icon = "rbxassetid://101397684798718"}, {name = "Phoenix", area = "Volcano", chance = "10.85%", icon = "rbxassetid://118067990008425"}}}, {id = "divine_fast", title = "Divine", cycleLabel = "1.5 - 3h", rarity = "Divine", windowMinH = 1.5, windowMaxH = 3, priority = 2, color = Color3.fromRGB(255, 255, 255), candidates = {{name = "Kitsune", area = "Cherry Blossom", chance = "20%", icon = "rbxassetid://107842067813602"}, {name = "ArchAngel", area = "Heaven", chance = "20%", icon = "rbxassetid://113289118499426"}, {name = "Godzilla", area = "Prehistoric", chance = "20%", icon = "rbxassetid://102979882140882"}, {name = "Pegasus", area = "Fantasy", chance = "20%", icon = "rbxassetid://112830316982322"}, {name = "Unicorn", area = "Magical Forest", chance = "20%", icon = "rbxassetid://70463817382627"}}}}

	local function fn100(lastEternal)
		if lastEternal then
			if not lastEternal.name then
				return false
			end
		else
			return false
		end

		local now2 = tonumber(lastEternal.ts) or os.time()
		lastEternal.ts = now2
		local str3 = (lastEternal.rarity or ""):lower()
		if str3 ~= "eternal" and str3 ~= "divine" then
			return false
		end
		local v22 = fn93(lastEternal.name)

		for i, v23 in ipairs(tbl21.history) do
			if v23.uid and (lastEternal.uid and v23.uid == lastEternal.uid) then
				return false
			end

			if fn93(v23.name) == v22 and math.abs((v23.ts or 0) - now2) < 600 then
				return false
			end
		end

		table.insert(tbl21.history, lastEternal)

		table.sort(tbl21.history, function(arg, arg2)
			return (arg.ts or 0) > (arg2.ts or 0)
		end)

		if str3 == "eternal" then
			if tbl21.lastEternal then
				if now2 >= (tbl21.lastEternal.ts or 0) then
					tbl21.lastEternal = lastEternal
				end
			else
				tbl21.lastEternal = lastEternal
			end
		elseif str3 == "divine" then
			if tbl21.lastDivine then
				if now2 >= (tbl21.lastDivine.ts or 0) then
					tbl21.lastDivine = lastEternal
				end
			else
				tbl21.lastDivine = lastEternal
			end
		end

		return true
	end

	tbl21.getLatestSpawn = function(arg, arg2)
		for i, v22 in ipairs(tbl21.history) do
			if if arg then v22.rarity and v22.rarity:lower() == arg:lower() else not arg then
				if arg2 and #arg2 > 0 then
					local v23 = fn93(v22.name)

					for i2, v24 in ipairs(arg2) do
						if fn93(v24.name) == v23 then
							return v22
						end
					end
				else
					return v22
				end
			end
		end

		return nil
	end

	for i, v22 in ipairs({{uid = "afad935fc39f4ad0a28d83d74dad60f8", name = "Ice Dragon", area = "Snow", rarity = "Eternal", ts = 1789738200, reporter = "Server Alert"}, {uid = "aac1107e3c3a428c93ecc8d5c4c03296", name = "Mosasaurus", area = "Prehistoric", rarity = "Eternal", ts = 1789735200, reporter = "Server Alert"}, {uid = "2f08670c03054614b5c088092e0eab9e", name = "Eternal Lunar Dragon", area = "Cosmic", rarity = "Eternal", ts = 1789733400, reporter = "Server Alert"}, {uid = "d2c1c02c35224ca78eddeda7128643a6", name = "Skeleton Horse", area = "Light Dark", rarity = "Eternal", ts = 1789731600, reporter = "Server Alert"}, {uid = "a9f84b4645bd4d23a2a8887923febe6e", name = "Gorilla King", area = "Titan Temple", rarity = "Eternal", ts = 1789729800, reporter = "Server Alert"}, {uid = "seed_divine_1", name = "Kitsune", area = "Cherry Blossom", rarity = "Divine", ts = 1789678800, reporter = "Server Alert"}}) do
		fn100(v22)
	end

	local function fn101(arg)
		if arg then
			if type(arg) ~= "string" then
				return nil
			end
		else
			return nil
		end

		if not arg:find("spawned in") then
			return nil
		end
		local str3 = arg:gsub("<[^>]+>", ""):gsub("[%c]", "")
		local match, match2, v22 = str3:match("A%s+(%a+)%s+(.-)%s+Egg%s+spawned%s+in%s+([^!]+)")

		if match and match2 and v22 then
		else
			match2, match, v22 = str3:match("([%w%s]+)%s*%((%a+)%)%s+has%s+spawned%s+in%s+([^!]+)")
		end

		if match and (match2 and v22) then
			local str4 = v22:gsub("%s+$", ""):gsub("^%s+", "")
			local str5 = match2:gsub("%s+$", ""):gsub("^%s+", "")
			return match:gsub("%s+$", ""):gsub("^%s+", ""), str5, str4
		end

		return nil
	end

	local function fn102(arg)
		local v22, v23, v24 = fn101(arg)

		if v22 then
			if v23 then
				if not v24 then
					return
				end
			else
				return
			end
		else
			return
		end

		local now2 = os.time()
		local v25 = fn93(v23)
		local n8 = math.floor(now2 / 300)
		local str3 = string.format("alert_%s_%s_%d", v25, v24:lower(), n8)
		if tbl21.reportedUids[str3] then
			return
		end
		tbl21.reportedUids[str3] = now2
		tbl21.lastAlert = {pet = v23, area = v24, rarity = v22, ts = now2, norm = v25}

		if fn100({uid = str3, name = v23, area = v24, rarity = v22, ts = now2, reporter = "Server Alert"}) then
			pcall(tbl21.paint)
		end
	end

	tbl21.reportSpawn = function(arg, arg2, arg3, arg4, arg5)
		if arg then
			if tbl21.reportedUids[arg] then
				return
			end
		else
			return
		end

		local now2 = os.time()
		local num = tonumber(arg5) or now2
		if now2 - tbl21.lastReportTime < 3 then
			return
		end
		tbl21.reportedUids[arg] = num
		tbl21.lastReportTime = now2
		local name2 = localPlayer and localPlayer.Name or "Player"

		if fn100({uid = tostring(arg), name = arg2, area = arg3, rarity = arg4, ts = num, reporter = name2}) then
			pcall(tbl21.paint)
		end
	end

	tbl21.syncBackend = function()
		local now2 = os.time()
		if now2 - tbl21.lastSync < 10 then
			return
		end
		tbl21.lastSync = now2

		task.spawn(function()
			local senaBackend = getgenv and getgenv().SenaBackend or {}
			local api = senaBackend.Api or "https://senahub.xyz/api"
			local str3 = senaBackend.Key or ""
			local str4 = localPlayer and tostring(localPlayer.UserId) or "0"
			local v22 = fn99({Url = api .. "/egg/latest?key=" .. tostring(str3) .. "&uid=" .. tostring(str4) .. "&t=" .. tostring(now2), Method = "GET"})

			if v22 and (v22.StatusCode == 200 or v22.Status == 200) and v22.Body then
				local HttpService = game:GetService("HttpService")

				api, str4 = pcall(function()
					return HttpService:JSONDecode(v22.Body)
				end)

				if api and type(str4) == "table" and str4.ok then
					if str4.last_eternal and (type(str4.last_eternal) == "table" and str4.last_eternal.name) then
						fn100(str4.last_eternal)
					end

					if str4.last_divine and (type(str4.last_divine) == "table" and str4.last_divine.name) then
						fn100(str4.last_divine)
					end

					if type(str4.recent_spawns) == "table" then
						for i, recentSpawn in ipairs(str4.recent_spawns) do
							fn100(recentSpawn)
						end
					end

					pcall(tbl21.paint)
				end
			end
		end)
	end

	tbl21.scanField = function()
		local v22

		pcall(function()
			v22 = EggState2.ReadFieldEggs()
		end)

		if not v22 or not v22.Records then
			return
		end
		local now2 = os.time()

		if not tbl21._fieldInitialized then
			tbl21._fieldInitialized = true

			for i, record in ipairs(v22.Records) do
				if record.Uid then
					tbl21.knownFieldUids[record.Uid] = true
				end
			end

			return
		end

		for i, record in ipairs(v22.Records) do
			if record.Uid and not tbl21.knownFieldUids[record.Uid] then
				tbl21.knownFieldUids[record.Uid] = true

				if record.State ~= "Claimed" and record.BottomCFrame then
					local assetCategory = record.AssetCategory
					local v23, v24 = fn71(assetCategory)

					if v24 == "Divine" or v24 == "Eternal" then
						local str3 = assetCategory == "King Kong" and "Gorilla King" or (assetCategory == "Ascended Vermilion Phoenix" and "Phoenix" or assetCategory)
						local v25 = if tbl21.lastAlert then if now2 - (tbl21.lastAlert.ts or 0) <= 60 then if fn93(tbl21.lastAlert.pet) == fn93(str3) then if tbl21.lastAlert.area:lower() == (record.AreaId or ""):lower() then tbl21.lastAlert.ts else now2 else now2 else now2 else now2
						tbl21.reportSpawn(record.Uid, str3, record.AreaId or "Field", v24, v25)
					end
				end
			end
		end
	end

	tbl21.paint = function()
		fn67()

		if tbl21.list then
			if not tbl21.list.Parent then
				return
			end
		else
			return
		end

		for i, child in ipairs(tbl21.list:GetChildren()) do
			if child:IsA("Frame") then
				child:Destroy()
			end
		end

		local now2 = os.time()
		local eternal = tbl21.getLatestSpawn("eternal")
		local divine = tbl21.getLatestSpawn("divine")
		local ts = eternal and eternal.ts or 1789738200
		local ts2 = divine and divine.ts or 1789678800

		if tbl21.catSeg then
			tbl21.catSeg.set(tbl21.category, false)
		end

		if tbl21.chipSeg then
			tbl21.chipSeg.set(tbl21.filter, false)
		end

		if tbl21.noticeBox then
			tbl21.noticeBox.Visible = tbl21.category == "targets"
		end

		if tbl21.summaryBox then
			tbl21.summaryBox.Visible = tbl21.category == "history"

			if tbl21.summaryText and tbl21.category == "history" then
				local name2 = eternal and eternal.name or "Phoenix"
				local area = eternal and eternal.area or "Volcano"
				local ts3 = eternal and eternal.ts or ts
				local v22 = fn95(ts3, true)
				local v23 = fn96(ts3)
				local name3 = divine and divine.name or "Kitsune"
				local area2 = divine and divine.area or "Cherry Blossom"
				local ts4 = divine and divine.ts or ts2
				local v24 = fn95(ts4, true)
				local v25 = fn96(ts4)
				tbl21.summaryText.Text = string.format("<b>LAST ETERNAL:</b> <font color='#ffd700'><b>%s</b></font> (%s) - %s <font color='#8899aa'>(%s)</font>\n<b>LAST DIVINE:</b> <font color='#ffffff'><b>%s</b></font> (%s) - %s <font color='#8899aa'>(%s)</font>", name2, area, v22, v23, name3, area2, v24, v25)
			end
		end

		if tbl21.refreshBtn then
			tbl21.refreshBtn.setText(tbl21.category == "targets" and "Refresh targets" or "Refresh history")
		end

		if tbl21.category == "targets" then
			local n8 = 0

			for i, v22 in ipairs(tbl33) do
				if tbl21.filter == "All" or tbl21.filter == v22.rarity then
					n8 += 1
					local v23 = tbl21.getLatestSpawn(v22.rarity, v22.candidates) or eternal
					local v24 = if v22.rarity == "Divine" then tbl21.getLatestSpawn("divine") or divine else v23
					local ts3 = v24 and v24.ts or (v22.rarity == "Divine" and ts2 or ts)
					local parent = v22.windowMinH and v22.windowMinH * 3600 or (v22.windowMin or 45) * 60
					local backgroundColor3 = v22.windowMaxH and v22.windowMaxH * 3600 or (v22.windowMax or 90) * 60
					local n9 = backgroundColor3 - parent
					local n10 = ts3 + parent
					local n11 = ts3 + backgroundColor3

					if v22.rarity == "Eternal" and now2 - n11 > parent * 0.75 then
						backgroundColor3 = n11
						ts3 = n10

						while true do
							if not (now2 - backgroundColor3 > parent * 0.75) then
								break
							end
							ts3 = backgroundColor3 + parent
							backgroundColor3 = ts3 + n9
						end

						n10 = ts3
						n11 = backgroundColor3
					end

					n10, n11 = fn94(n10), fn94(n11)
					ts3 = "UPCOMING"
					backgroundColor3 = Color3.fromRGB(100, 200, 255)

					if now2 > n11 then
						local v25 = math.ceil((now2 - n11) / 60)
						ts3 = v25 >= 60 and string.format("OVERDUE +%.1fh", v25 / 60) or string.format("OVERDUE +%dm", v25)
						backgroundColor3 = Color3.fromRGB(255, 0, 128)
					else
						if now2 >= n10 and now2 <= n11 then
							ts3 = "IN WINDOW"
							backgroundColor3 = Color3.fromRGB(0, 255, 136)
						else
							n9 = math.ceil((n10 - now2) / 60)

							if n9 > 0 and n9 < 60 then
								ts3 = string.format("IN %dm", n9)
								backgroundColor3 = Color3.fromRGB(80, 210, 255)
							else
								if n9 >= 60 then
									ts3 = string.format("IN %.1fh", n9 / 60)
									backgroundColor3 = Color3.fromRGB(80, 210, 255)
								end
							end
						end
					end

					parent = Instance.new("Frame")
					parent.Size = UDim2.new(1, -6, 0, 136)
					parent.BackgroundColor3 = v21.surface
					parent.BackgroundTransparency = 0.15
					parent.BorderSizePixel = 0
					parent.LayoutOrder = i
					parent.Parent = tbl21.list
					Instance.new("UICorner", parent).CornerRadius = UDim.new(0, 8)
					local uiStroke = Instance.new("UIStroke", parent)
					uiStroke.Color = v22.color or v21.accent
					uiStroke.Thickness = 1
					uiStroke.Transparency = 0.78
					local frame = Instance.new("Frame")
					frame.Size = UDim2.new(0, 4, 1, -12)
					frame.Position = UDim2.fromOffset(0, 6)
					frame.BorderSizePixel = 0
					frame.BackgroundColor3 = v22.color or v21.accent
					frame.Parent = parent
					Instance.new("UICorner", frame).CornerRadius = UDim.new(1, 0)
					local textLabel = Instance.new("TextLabel")
					textLabel.BackgroundTransparency = 1
					textLabel.Position = UDim2.fromOffset(12, 6)
					textLabel.Size = UDim2.new(1, -120, 0, 16)
					textLabel.Font = BuilderSansBold
					textLabel.TextSize = 13
					textLabel.TextTruncate = Enum.TextTruncate.AtEnd
					textLabel.TextXAlignment = Enum.TextXAlignment.Left
					textLabel.TextColor3 = v22.color or Color3.fromRGB(255, 255, 255)
					textLabel.Text = string.format("%s Window (%s)", v22.title, v22.cycleLabel)
					textLabel.Parent = parent
					local textLabel2 = Instance.new("TextLabel")
					textLabel2.Position = UDim2.new(1, -12, 0, 6)
					textLabel2.AnchorPoint = Vector2.new(1, 0)
					textLabel2.AutomaticSize = Enum.AutomaticSize.X
					textLabel2.Size = UDim2.fromOffset(0, 18)
					textLabel2.BackgroundColor3 = backgroundColor3
					textLabel2.BackgroundTransparency = 0.2
					textLabel2.Font = BuilderSansBold
					textLabel2.TextSize = 10
					textLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
					textLabel2.Text = ts3
					textLabel2.Parent = parent
					Instance.new("UICorner", textLabel2).CornerRadius = UDim.new(0, 4)
					local uiPadding = Instance.new("UIPadding", textLabel2)
					uiPadding.PaddingLeft = UDim.new(0, 8)
					uiPadding.PaddingRight = UDim.new(0, 8)
					local textLabel3 = Instance.new("TextLabel")
					textLabel3.BackgroundTransparency = 1
					textLabel3.Position = UDim2.fromOffset(12, 24)
					textLabel3.Size = UDim2.new(1, -24, 0, 14)
					textLabel3.Font = BuilderSansMedium
					textLabel3.TextSize = 11
					textLabel3.TextXAlignment = Enum.TextXAlignment.Left
					textLabel3.TextColor3 = Color3.fromRGB(150, 180, 220)
					textLabel3.Text = string.format("Window: %s", fn97(n10, n11))
					textLabel3.Parent = parent
					local scrollingFrame = Instance.new("ScrollingFrame")
					scrollingFrame.Position = UDim2.fromOffset(12, 42)
					scrollingFrame.Size = UDim2.new(1, -24, 0, 86)
					scrollingFrame.BackgroundTransparency = 1
					scrollingFrame.BorderSizePixel = 0
					scrollingFrame.ScrollBarThickness = 2
					scrollingFrame.ScrollBarImageColor3 = v22.color or v21.accent
					scrollingFrame.ScrollingDirection = Enum.ScrollingDirection.X
					scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
					scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.X
					scrollingFrame.Parent = parent
					n9 = Instance.new("UIListLayout", scrollingFrame)
					n9.FillDirection = Enum.FillDirection.Horizontal
					n9.Padding = UDim.new(0, 6)

					for i2, candidate in ipairs(v22.candidates) do
						local frame2 = Instance.new("Frame")
						frame2.Size = UDim2.fromOffset(72, 80)
						frame2.BackgroundColor3 = Color3.fromRGB(22, 26, 36)
						frame2.BackgroundTransparency = 0.3
						frame2.BorderSizePixel = 0
						frame2.Parent = scrollingFrame
						Instance.new("UICorner", frame2).CornerRadius = UDim.new(0, 6)
						local uiStroke2 = Instance.new("UIStroke", frame2)
						uiStroke2.Color = v22.color or v21.strokeCol
						uiStroke2.Thickness = 1
						uiStroke2.Transparency = 0.75
						local imageLabel = Instance.new("ImageLabel")
						imageLabel.Position = UDim2.fromOffset(22, 5)
						imageLabel.Size = UDim2.fromOffset(28, 28)
						imageLabel.BackgroundColor3 = Color3.fromRGB(30, 34, 46)
						imageLabel.BackgroundTransparency = 0.4
						imageLabel.BorderSizePixel = 0
						imageLabel.ScaleType = Enum.ScaleType.Fit
						imageLabel.Image = candidate.icon or fn98(candidate.name)
						imageLabel.Parent = frame2
						Instance.new("UICorner", imageLabel).CornerRadius = UDim.new(0, 4)
						local textLabel4 = Instance.new("TextLabel")
						textLabel4.Position = UDim2.new(0, 3, 0, 36)
						textLabel4.Size = UDim2.new(1, -6, 0, 13)
						textLabel4.BackgroundTransparency = 1
						textLabel4.Font = BuilderSansBold
						textLabel4.TextSize = 10
						textLabel4.TextTruncate = Enum.TextTruncate.AtEnd
						textLabel4.TextColor3 = Color3.fromRGB(230, 235, 245)
						textLabel4.TextXAlignment = Enum.TextXAlignment.Center
						textLabel4.Text = candidate.name
						textLabel4.Parent = frame2
						local textLabel5 = Instance.new("TextLabel")
						textLabel5.Position = UDim2.new(0, 3, 0, 50)
						textLabel5.Size = UDim2.new(1, -6, 0, 12)
						textLabel5.BackgroundTransparency = 1
						textLabel5.Font = BuilderSansMedium
						textLabel5.TextSize = 9
						textLabel5.TextTruncate = Enum.TextTruncate.AtEnd
						textLabel5.TextColor3 = v21.muted
						textLabel5.TextXAlignment = Enum.TextXAlignment.Center
						textLabel5.Text = candidate.area
						textLabel5.Parent = frame2
						local textLabel6 = Instance.new("TextLabel")
						textLabel6.Position = UDim2.new(0, 3, 0, 63)
						textLabel6.Size = UDim2.new(1, -6, 0, 13)
						textLabel6.BackgroundTransparency = 1
						textLabel6.Font = BuilderSansBold
						textLabel6.TextSize = 10
						textLabel6.TextColor3 = Color3.fromRGB(255, 185, 0)
						textLabel6.TextXAlignment = Enum.TextXAlignment.Center
						textLabel6.Text = candidate.chance
						textLabel6.Parent = frame2
					end
				end
			end

			tbl21.list.CanvasSize = UDim2.new(0, 0, 0, n8 * 142 + 10)
		else
			local tbl34 = {}

			for i, v22 in ipairs(tbl21.history) do
				if tbl21.filter == "All" or tbl21.filter == v22.rarity then
					local v23, v24, v25 = fn71(v22.name)
					table.insert(tbl34, {name = v22.name, area = v22.area, rarity = v22.rarity, subText1 = string.format("[%s] - %s", (v22.rarity or "Eternal"):upper(), v22.area or "Field"), subText2 = string.format("Source: %s", v22.reporter or "Server Alert"), rateText = fn95(v22.ts, false), badge = fn96(v22.ts), badgeColor = Color3.fromRGB(0, 255, 136), color = v25 or (v22.rarity == "Divine" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(255, 215, 0)), icon = fn98(v22.name), order = 10000000000 - (v22.ts or 0)})
				end
			end

			for i, v22 in ipairs(tbl34) do
				local frame = Instance.new("Frame")
				frame.Size = UDim2.new(1, -6, 0, 54)
				frame.BackgroundColor3 = v21.surface
				frame.BackgroundTransparency = 0.15
				frame.BorderSizePixel = 0
				frame.LayoutOrder = i
				frame.Parent = tbl21.list
				Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
				local uiStroke = Instance.new("UIStroke", frame)
				uiStroke.Color = v22.color or v21.accent
				uiStroke.Thickness = 1
				uiStroke.Transparency = 0.78
				local frame2 = Instance.new("Frame")
				frame2.Size = UDim2.new(0, 4, 1, -12)
				frame2.Position = UDim2.fromOffset(0, 6)
				frame2.BorderSizePixel = 0
				frame2.BackgroundColor3 = v22.color or v21.accent
				frame2.Parent = frame
				Instance.new("UICorner", frame2).CornerRadius = UDim.new(1, 0)
				local imageLabel = Instance.new("ImageLabel")
				imageLabel.Position = UDim2.fromOffset(10, 8)
				imageLabel.Size = UDim2.fromOffset(38, 38)
				imageLabel.BackgroundColor3 = Color3.fromRGB(25, 28, 38)
				imageLabel.BackgroundTransparency = 0.4
				imageLabel.BorderSizePixel = 0
				imageLabel.ScaleType = Enum.ScaleType.Fit
				imageLabel.Image = v22.icon or ""
				imageLabel.Parent = frame
				Instance.new("UICorner", imageLabel).CornerRadius = UDim.new(0, 6)
				local textLabel = Instance.new("TextLabel")
				textLabel.BackgroundTransparency = 1
				textLabel.Position = UDim2.fromOffset(56, 6)
				textLabel.Size = UDim2.new(1, -165, 0, 16)
				textLabel.Font = BuilderSansBold
				textLabel.TextSize = 12
				textLabel.TextXAlignment = Enum.TextXAlignment.Left
				textLabel.TextTruncate = Enum.TextTruncate.AtEnd
				textLabel.TextColor3 = v21.text
				textLabel.Text = v22.name
				textLabel.Parent = frame
				local textLabel2 = Instance.new("TextLabel")
				textLabel2.BackgroundTransparency = 1
				textLabel2.Position = UDim2.fromOffset(56, 22)
				textLabel2.Size = UDim2.new(1, -165, 0, 14)
				textLabel2.Font = BuilderSansMedium
				textLabel2.TextSize = 11
				textLabel2.TextXAlignment = Enum.TextXAlignment.Left
				textLabel2.TextTruncate = Enum.TextTruncate.AtEnd
				textLabel2.TextColor3 = v21.muted
				textLabel2.Text = v22.subText1
				textLabel2.Parent = frame
				local textLabel3 = Instance.new("TextLabel")
				textLabel3.BackgroundTransparency = 1
				textLabel3.Position = UDim2.fromOffset(56, 36)
				textLabel3.Size = UDim2.new(1, -165, 0, 13)
				textLabel3.Font = BuilderSansMedium
				textLabel3.TextSize = 10
				textLabel3.TextXAlignment = Enum.TextXAlignment.Left
				textLabel3.TextTruncate = Enum.TextTruncate.AtEnd
				textLabel3.TextColor3 = Color3.fromRGB(150, 180, 220)
				textLabel3.Text = v22.subText2
				textLabel3.Parent = frame
				local frame3 = Instance.new("Frame")
				frame3.BackgroundTransparency = 1
				frame3.AnchorPoint = Vector2.new(1, 0.5)
				frame3.Position = UDim2.new(1, -8, 0.5, 0)
				frame3.Size = UDim2.fromOffset(105, 38)
				frame3.Parent = frame
				local textLabel4 = Instance.new("TextLabel")
				textLabel4.BackgroundTransparency = 1
				textLabel4.Size = UDim2.new(1, 0, 0, 18)
				textLabel4.Font = BuilderSansBold
				textLabel4.TextSize = 11
				textLabel4.TextXAlignment = Enum.TextXAlignment.Right
				textLabel4.TextTruncate = Enum.TextTruncate.AtEnd
				textLabel4.TextColor3 = v22.badgeColor
				textLabel4.Text = string.format("[%s]", v22.badge)
				textLabel4.Parent = frame3
				local textLabel5 = Instance.new("TextLabel")
				textLabel5.BackgroundTransparency = 1
				textLabel5.Position = UDim2.new(0, 0, 0, 18)
				textLabel5.Size = UDim2.new(1, 0, 0, 16)
				textLabel5.Font = BuilderSansMedium
				textLabel5.TextSize = 11
				textLabel5.TextXAlignment = Enum.TextXAlignment.Right
				textLabel5.TextTruncate = Enum.TextTruncate.AtEnd
				textLabel5.TextColor3 = Color3.fromRGB(170, 185, 210)
				textLabel5.Text = v22.rateText
				textLabel5.Parent = frame3
			end

			tbl21.list.CanvasSize = UDim2.new(0, 0, 0, #tbl34 * 58 + 10)
		end
	end

	tbl21.build = function(parent)
		local frame = Instance.new("Frame")
		frame.Size = UDim2.fromScale(1, 1)
		frame.BackgroundTransparency = 1
		frame.BorderSizePixel = 0
		frame.Parent = parent
		tbl21.headLbl = tbl17.text(frame, {text = "Global Egg Data & History", style = "body", color = v21.accent, pos = UDim2.fromOffset(14, 2), size = UDim2.new(1, -28, 0, 18)})
		tbl21.headLbl.Font = BuilderSansBold

		tbl21.catSeg = tbl17.segmented(frame, {options = {{"targets", "Egg Data (targets)"}, {"history", "Egg History"}}, value = tbl21.category, h = 28, pos = UDim2.fromOffset(14, 22), size = UDim2.new(1, -28, 0, 32), onChange = function(category)
			tbl21.category = category
			tbl21.filter = "All"
			tbl21.paint()
		end})

		local frame2 = Instance.new("Frame")
		frame2.Position = UDim2.fromOffset(14, 58)
		frame2.Size = UDim2.new(1, -28, 0, 44)
		frame2.BackgroundColor3 = Color3.fromRGB(16, 20, 32)
		frame2.BorderSizePixel = 0
		frame2.Parent = frame
		Instance.new("UICorner", frame2).CornerRadius = UDim.new(0, 6)
		local uiStroke = Instance.new("UIStroke", frame2)
		uiStroke.Color = Color3.fromRGB(50, 80, 130)
		uiStroke.Thickness = 1
		tbl21.noticeBox = frame2
		local textLabel = Instance.new("TextLabel")
		textLabel.Position = UDim2.new(0, 8, 0, 4)
		textLabel.Size = UDim2.new(1, -16, 1, -8)
		textLabel.BackgroundTransparency = 1
		textLabel.Font = BuilderSansMedium
		textLabel.TextSize = 11
		textLabel.TextColor3 = Color3.fromRGB(180, 205, 235)
		textLabel.TextXAlignment = Enum.TextXAlignment.Left
		textLabel.TextWrapped = true
		textLabel.RichText = true
		textLabel.Text = "<b>Note:</b> These are estimated spawn targets based on cycle timing, not 100% guaranteed predictions."
		textLabel.Parent = frame2
		tbl21.noticeText = textLabel
		local frame3 = Instance.new("Frame")
		frame3.Position = UDim2.fromOffset(14, 58)
		frame3.Size = UDim2.new(1, -28, 0, 44)
		frame3.BackgroundColor3 = Color3.fromRGB(22, 18, 28)
		frame3.BorderSizePixel = 0
		frame3.Visible = false
		frame3.Parent = frame
		Instance.new("UICorner", frame3).CornerRadius = UDim.new(0, 6)
		local uiStroke2 = Instance.new("UIStroke", frame3)
		uiStroke2.Color = Color3.fromRGB(130, 80, 40)
		uiStroke2.Thickness = 1
		tbl21.summaryBox = frame3
		local textLabel2 = Instance.new("TextLabel")
		textLabel2.Position = UDim2.new(0, 8, 0, 4)
		textLabel2.Size = UDim2.new(1, -16, 1, -8)
		textLabel2.BackgroundTransparency = 1
		textLabel2.Font = BuilderSansMedium
		textLabel2.TextSize = 11
		textLabel2.TextColor3 = Color3.fromRGB(240, 220, 200)
		textLabel2.TextXAlignment = Enum.TextXAlignment.Left
		textLabel2.TextWrapped = true
		textLabel2.RichText = true
		textLabel2.Text = ""
		textLabel2.Parent = frame3
		tbl21.summaryText = textLabel2

		tbl21.chipSeg = tbl17.segmented(frame, {options = {{"All", "All"}, {"Eternal", "Eternal"}, {"Divine", "Divine"}}, value = tbl21.filter, pos = UDim2.fromOffset(14, 106), size = UDim2.new(1, -28, 0, 28), onChange = function(filter)
			tbl21.filter = filter
			tbl21.paint()
		end})

		tbl21.chips = tbl21.chipSeg.buttons
		local scrollingFrame = Instance.new("ScrollingFrame")
		scrollingFrame.Position = UDim2.fromOffset(14, 136)
		scrollingFrame.Size = UDim2.new(1, -28, 1, -180)
		scrollingFrame.BackgroundTransparency = 1
		scrollingFrame.BorderSizePixel = 0
		scrollingFrame.ScrollBarThickness = 4
		scrollingFrame.ScrollBarImageColor3 = v21.accent
		scrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
		scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
		scrollingFrame.Parent = frame
		local uiListLayout = Instance.new("UIListLayout", scrollingFrame)
		uiListLayout.Padding = UDim.new(0, 6)
		uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		tbl21.list = scrollingFrame
		local frame4 = Instance.new("Frame")
		frame4.Position = UDim2.new(0, 14, 1, -40)
		frame4.Size = UDim2.new(1, -28, 0, 32)
		frame4.BackgroundTransparency = 1
		frame4.Parent = frame

		tbl21.refreshBtn = tbl17.button(frame4, {text = "Refresh targets", icon = "refresh-cw", h = 32, onClick = function()
			tbl21.scanField()
			tbl21.syncBackend()
			tbl21.paint()
		end})

		tbl21.statusLbl = tbl17.text(frame4, {text = "\226\151\143 Online synced", style = "meta", color = Color3.fromRGB(0, 255, 136), align = Enum.TextXAlignment.Right, anchor = Vector2.new(1, 0), pos = UDim2.fromScale(1, 0), size = UDim2.new(0.5, -4, 1, 0)})

		if not tbl21.bound then
			tbl21.bound = true

			pcall(function()
				local experienceChat = game:GetService("CoreGui"):FindFirstChild("ExperienceChat")

				if experienceChat then
					for i, descendant in ipairs(experienceChat:GetDescendants()) do
						if descendant:IsA("TextLabel") and descendant.Text:find("spawned in") then
							local v22, v23, v24 = fn101(descendant.Text)

							if v22 and (v23 and v24) then
								local v25 = fn93(v23)
								local str3 = string.format("init_%s_%s", v25, v24:lower())

								if not tbl21.reportedUids[str3] then
									tbl21.reportedUids[str3] = os.time()
									fn100({uid = str3, name = v23, area = v24, rarity = v22, ts = os.time() - 120, reporter = "Server Alert"})
								end
							end
						end
					end

					local function fn103(descendant)
						if descendant:IsA("TextLabel") and descendant.Text:find("spawned in") then
							task.wait(0.05)
							fn102(descendant.Text)
						end
					end

					experienceChat.DescendantAdded:Connect(fn103)
				end
			end)

			pcall(function()
				local function fn103(arg)
					if arg and (arg.Text and arg.Text:find("spawned in")) then
						fn102(arg.Text)
					end
				end

				game:GetService("TextChatService").MessageReceived:Connect(fn103)
			end)
		end

		tbl21.scanField()
		tbl21.syncBackend()
		tbl21.paint()
	end

	tbl21.refresh = function()
		tbl21.scanField()
		tbl21.syncBackend()
		tbl21.paint()
	end

	local tbl34 = {"logs", "eggs", "inventory", "checker", "eggdata", "stats"}

	local tbl35 = {logs = {name = "Egg Logs", w = 420, h = 500, build = function(arg)
		return fn85(arg)
	end}, eggs = {name = "Egg Board", w = 420, h = 500, build = function(arg)
		return fn86(arg)
	end}, inventory = {name = "Inventory & Base", w = 440, h = 510, build = function(arg)
		return fn88(arg)
	end}, checker = {name = "Egg Checker", w = 420, h = 500, build = function(arg)
		return tbl20.build(arg)
	end}, stats = {name = "Farm Stats", w = 440, h = 560, build = function(arg)
		return fn91(arg)
	end}, eggdata = {name = "Egg Data & History", w = 380, h = 570, build = function(arg)
		return tbl21.build(arg)
	end}}

	local function fn103(arg)
		fn67()
		local v22 = tbl35[arg]
		if not v22 then
			return
		end
		local v23 = windows[arg]

		if v23 and v23.conns then
			for i, conn in ipairs(v23.conns) do
				pcall(function()
					conn:Disconnect()
				end)
			end
		end

		local name2 = "__SNE_Panel_" .. arg

		for i, v24 in ipairs({game:GetService("CoreGui"), ((function()
			local ok, result = pcall(function()
				return localPlayer:FindFirstChild("PlayerGui")
			end)

			return ok and result or nil
		end)())}) do
			if v24 then
				pcall(function()
					for i2, descendant in ipairs(v24:GetDescendants()) do
						if descendant.Name == name2 and descendant:IsA("ScreenGui") then
							pcall(function()
								descendant:Destroy()
							end)
						end
					end
				end)
			end
		end

		local tbl36 = {}
		local TweenService = game:GetService("TweenService")
		local v24 = fn68()
		local screenGui = Instance.new("ScreenGui")
		screenGui.Name = name2
		screenGui.ResetOnSpawn = false
		screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		screenGui.DisplayOrder = 99999
		screenGui.Parent = v24
		local n8 = 0

		for i, v25 in ipairs(tbl34) do
			if v25 == arg then
				n8 = i - 1
			end
		end

		local frame = Instance.new("Frame")
		frame.AnchorPoint = Vector2.new(0.5, 0.5)
		frame.Size = UDim2.fromOffset(v22.w, v22.h)
		frame.BackgroundTransparency = 1
		frame.Active = true
		frame.Parent = screenGui
		local uiScale = Instance.new("UIScale")
		uiScale.Name = "WindowScale"
		uiScale.Scale = 1
		uiScale.Parent = frame
		local frame2 = Instance.new("Frame")
		frame2.BackgroundTransparency = 1
		frame2.Size = UDim2.fromScale(1, 1)
		frame2.Parent = frame
		local uiScale2 = Instance.new("UIScale")
		uiScale2.Name = "Pop"
		uiScale2.Parent = frame2
		local UserInputService = game:GetService("UserInputService")

		local function fn104(arg2)
			local currentCamera = workspace.CurrentCamera
			local viewportSize = currentCamera and currentCamera.ViewportSize or Vector2.new(1024, 768)

			if viewportSize.X <= 0 then
				return
			elseif viewportSize.Y <= 0 then
				return
			end

			local flag6 = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled or viewportSize.Y < 550
			local n9 = viewportSize.X * (flag6 and 0.86 or 0.94)
			local n10 = viewportSize.Y * (flag6 and 0.88 or 0.92)
			local n11 = math.min(1, n9 / v22.w, n10 / v22.h)
			local v25 = if flag6 then if n11 > 0.82 then 0.82 else n11 else n11
			uiScale.Scale = math.clamp(v25, 0.6, 1)
			local scale = uiScale.Scale
			local n12 = v22.w * scale
			local n13 = v22.h * scale

			if arg2 then
				if flag6 then
					frame.Position = UDim2.fromOffset(viewportSize.X - math.floor(n12 / 2) - 14, math.floor(viewportSize.Y / 2))
				else
					frame.Position = UDim2.fromOffset(math.floor(viewportSize.X / 2 + n8 * 24), math.floor(viewportSize.Y / 2 + n8 * 20))
				end
			end

			local n14 = n12 / 2
			local n15 = n13 / 2
			local n16 = math.min(n14 + 8, viewportSize.X / 2)
			local n17 = math.max(viewportSize.X - n14 - 8, viewportSize.X / 2)
			local n18 = math.min(n15 + 8, viewportSize.Y / 2)
			local n19 = math.max(viewportSize.Y - n15 - 8, viewportSize.Y / 2)
			local n20 = frame.Position.X.Scale * viewportSize.X + frame.Position.X.Offset
			local n21 = frame.Position.Y.Scale * viewportSize.Y + frame.Position.Y.Offset
			frame.Position = UDim2.fromOffset(math.floor(math.clamp(n20, n16, n17)), math.floor(math.clamp(n21, n18, n19)))
		end

		local imageLabel = Instance.new("ImageLabel")
		imageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
		imageLabel.BackgroundTransparency = 1
		imageLabel.Image = "rbxassetid://6015897843"
		imageLabel.ImageColor3 = tbl14.shadow
		imageLabel.ImageTransparency = 0.52
		imageLabel.Position = UDim2.fromScale(0.5, 0.5)
		imageLabel.ScaleType = Enum.ScaleType.Slice
		imageLabel.Size = UDim2.new(1, 40, 1, 40)
		imageLabel.SliceCenter = Rect.new(49, 49, 450, 450)
		imageLabel.ZIndex = 0
		imageLabel.Parent = frame2
		local frame3 = Instance.new("Frame")
		frame3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		frame3.BorderSizePixel = 0
		frame3.Size = UDim2.fromScale(1, 1)
		frame3.ZIndex = 1
		frame3.Parent = frame2
		Instance.new("UICorner", frame3).CornerRadius = UDim.new(0, 10)
		local uiGradient = Instance.new("UIGradient", frame3)
		uiGradient.Rotation = 16
		uiGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, tbl14.obsTop), ColorSequenceKeypoint.new(0.52, tbl14.obsMid), ColorSequenceKeypoint.new(1, tbl14.obsLow)})
		local uiStroke = Instance.new("UIStroke", frame3)
		uiStroke.Color = tbl14.strokeCol
		uiStroke.Thickness = 1
		uiStroke.Transparency = 0.72
		local imageLabel2 = Instance.new("ImageLabel")
		imageLabel2.AnchorPoint = Vector2.new(0, 0.5)
		imageLabel2.BackgroundTransparency = 1
		imageLabel2.Image = image
		imageLabel2.Position = UDim2.fromOffset(12, 22)
		imageLabel2.ScaleType = Enum.ScaleType.Fit
		imageLabel2.Size = UDim2.fromOffset(20, 20)
		imageLabel2.Parent = frame3
		local frame4 = Instance.new("Frame")
		frame4.BackgroundTransparency = 1
		frame4.Position = UDim2.fromOffset(40, 10)
		frame4.Size = UDim2.new(1, -86, 0, 24)
		frame4.Parent = frame3
		local uiListLayout = Instance.new("UIListLayout", frame4)
		uiListLayout.FillDirection = Enum.FillDirection.Horizontal
		uiListLayout.Padding = UDim.new(0, 8)
		uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
		local v25 = tbl17.text(frame4, {text = "Sena", style = "title", order = 1, size = UDim2.new(0, 0, 1, 0)})
		v25.AutomaticSize = Enum.AutomaticSize.X
		v25.TextTruncate = Enum.TextTruncate.None
		local frame5 = Instance.new("Frame")
		frame5.AutomaticSize = Enum.AutomaticSize.X
		frame5.BackgroundColor3 = tbl14.accent
		frame5.BackgroundTransparency = 0.82
		frame5.BorderSizePixel = 0
		frame5.LayoutOrder = 2
		frame5.Size = UDim2.fromOffset(0, 22)
		frame5.Parent = frame4
		Instance.new("UICorner", frame5).CornerRadius = UDim.new(0, 6)
		local uiStroke2 = Instance.new("UIStroke", frame5)
		uiStroke2.Color = tbl14.accent
		uiStroke2.Thickness = 1
		uiStroke2.Transparency = 0.45
		local uiPadding = Instance.new("UIPadding", frame5)
		uiPadding.PaddingLeft = UDim.new(0, 10)
		uiPadding.PaddingRight = UDim.new(0, 10)
		local v26 = tbl17.text(frame5, {text = v22.name, style = "body", size = UDim2.new(0, 0, 1, 0)})
		v26.AutomaticSize = Enum.AutomaticSize.X
		v26.TextTruncate = Enum.TextTruncate.None
		v26.Font = BuilderSansBold
		local textButton = Instance.new("TextButton")
		textButton.AutoButtonColor = false
		textButton.BackgroundColor3 = tbl14.btnBg
		textButton.BackgroundTransparency = 0.15
		textButton.Position = UDim2.new(1, -38, 0, 9)
		textButton.Size = UDim2.fromOffset(28, 28)
		textButton.Text = ""
		textButton.ZIndex = 5
		textButton.Parent = frame3
		Instance.new("UICorner", textButton).CornerRadius = UDim.new(0, 6)
		local uiStroke3 = Instance.new("UIStroke", textButton)
		uiStroke3.Color = tbl14.strokeCol
		uiStroke3.Thickness = 1
		uiStroke3.Transparency = 0.6
		local v27 = tbl17.image(textButton, "x", 14, tbl14.btnText)
		v27.AnchorPoint = Vector2.new(0.5, 0.5)
		v27.Position = UDim2.fromScale(0.5, 0.5)
		v27.ZIndex = 6

		local function fn105()
			v27.ImageColor3 = Color3.fromRGB(248, 113, 113)
		end

		textButton.MouseEnter:Connect(fn105)

		local function fn106()
			v27.ImageColor3 = tbl14.btnText
		end

		textButton.MouseLeave:Connect(fn106)
		local textButton2 = Instance.new("TextButton")
		textButton2.AnchorPoint = Vector2.new(0.5, 0.5)
		textButton2.AutoButtonColor = false
		textButton2.AutomaticSize = Enum.AutomaticSize.X
		textButton2.BackgroundColor3 = tbl14.btnBg
		textButton2.BackgroundTransparency = 0.15
		textButton2.Position = UDim2.new(0.5, 0, 1, -24)
		textButton2.Size = UDim2.fromOffset(0, 24)
		textButton2.Text = ""
		textButton2.Parent = frame3
		Instance.new("UICorner", textButton2).CornerRadius = UDim.new(1, 0)
		local uiStroke4 = Instance.new("UIStroke", textButton2)
		uiStroke4.Color = tbl14.strokeCol
		uiStroke4.Thickness = 1
		uiStroke4.Transparency = 0.6
		local uiPadding2 = Instance.new("UIPadding", textButton2)
		uiPadding2.PaddingLeft = UDim.new(0, 10)
		uiPadding2.PaddingRight = UDim.new(0, 12)
		local uiListLayout2 = Instance.new("UIListLayout", textButton2)
		uiListLayout2.FillDirection = Enum.FillDirection.Horizontal
		uiListLayout2.Padding = UDim.new(0, 6)
		uiListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
		uiListLayout2.VerticalAlignment = Enum.VerticalAlignment.Center
		tbl17.image(textButton2, "message-circle", 12, tbl14.accentB).LayoutOrder = 0
		local v28 = tbl17.text(textButton2, {text = text, style = "meta", order = 1, size = UDim2.new(0, 0, 1, 0)})
		v28.AutomaticSize = Enum.AutomaticSize.X
		v28.TextTruncate = Enum.TextTruncate.None
		v28.Font = BuilderSansBold

		local function fn107()
			pcall(function()
				setclipboard("https://" .. text)
			end)

			v28.Text = "Copied"

			task.delay(1.2, function()
				if v28.Parent then
					v28.Text = text
				end
			end)
		end

		textButton2.MouseButton1Click:Connect(fn107)
		local frame6 = Instance.new("Frame")
		frame6.BackgroundTransparency = 1
		frame6.BorderSizePixel = 0
		frame6.Position = UDim2.fromOffset(0, 46)
		frame6.Size = UDim2.new(1, 0, 1, -86)
		frame6.Parent = frame3
		local flag6, position, position2 = false

		local function fn108(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				flag6 = true
				position = input.Position
				position2 = frame.Position
			end
		end

		frame4.InputBegan:Connect(fn108)

		local function fn109(input)
			local scale = uiScale and uiScale.Scale or 1

			if input.Position.Y - frame.AbsolutePosition.Y <= 44 * scale then
				fn108(input)
			end
		end

		frame3.InputBegan:Connect(fn109)

		tbl36[#tbl36 + 1] = UserInputService.InputChanged:Connect(function(input)
			if flag6 and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
				local n9 = input.Position - position
				frame.Position = UDim2.new(position2.X.Scale, position2.X.Offset + n9.X, position2.Y.Scale, position2.Y.Offset + n9.Y)
			end
		end)

		tbl36[#tbl36 + 1] = UserInputService.InputEnded:Connect(function(input)
			if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and flag6 then
				flag6 = false
				pcall(fn104, false)
			end
		end)

		fn104(true)
		local currentCamera = workspace.CurrentCamera

		if currentCamera then
			tbl36[#tbl36 + 1] = currentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
				if screenGui and (screenGui.Parent and screenGui.Enabled) then
					pcall(fn104, false)
				end
			end)
		end

		local n9 = 0

		local function fn110()
			n9 += 1
			screenGui.Enabled = true
			uiScale2.Scale = 0.94
			imageLabel.ImageTransparency = 1
			TweenService:Create(uiScale2, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = 1}):Play()
			TweenService:Create(imageLabel, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {ImageTransparency = 0.52}):Play()
		end

		local function fn111()
			n9 += 1
			local v29 = n9
			TweenService:Create(uiScale2, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Scale = 0.94}):Play()
			TweenService:Create(imageLabel, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {ImageTransparency = 1}):Play()

			task.delay(0.12, function()
				if n9 == v29 then
					fn67()
					screenGui.Enabled = false
				end
			end)
		end

		local function fn112()
			fn67()
			fn111()
		end

		textButton.MouseButton1Click:Connect(fn112)
		windows[arg] = {gui = screenGui, page = frame6, holder = frame, fitScale = fn104, conns = tbl36, open = fn110, close = fn111}

		pcall(function()
			v22.build(frame6)
		end)

		pcall(function()
			fn84(arg)
		end)

		fn110()
	end

	local function fn104(arg)
		fn67()
		local str3 = arg or "logs"
		local v22 = windows[str3]

		if v22 and (v22.gui and v22.gui.Parent) then
			if v22.open then
				v22.open()
			else
				v22.gui.Enabled = true
			end

			if v22.fitScale then
				pcall(v22.fitScale, false)
			end

			pcall(function()
				fn84(str3)
			end)

			return
		end

		fn103(str3)
	end

	local function fn105()
		for i, v22 in ipairs(tbl34) do
			fn104(v22)
		end
	end

	local function fn106()
		for k, window in pairs(windows) do
			if window and (window.gui and window.gui.Enabled) then
				if window.close then
					window.close()
				else
					window.gui.Enabled = false
				end
			end
		end
	end

	task.spawn(function()
		while fn2() do
			pcall(function()
				local v22 = EggState2.ReadFieldEggs()

				if v22 and v22.Records then
					for i, record in ipairs(v22.Records) do
						fn78(record)
					end
				end
			end)

			pcall(function()
				if tbl21 and type(tbl21.scanField) == "function" then
					tbl21.scanField()
				end
			end)

			for i, v22 in ipairs({"logs", "eggs", "inventory", "checker", "eggdata"}) do
				if fn79(v22) then
					pcall(fn84, v22)
				end
			end

			task.wait(2)
		end
	end);

	(function()
		local TweenService = game:GetService("TweenService")
		local GuiService = game:GetService("GuiService")
		local UserInputService = game:GetService("UserInputService")
		local n8 = 380
		local n9 = 108
		local n10 = 12
		local n11 = 48
		local n12 = 12
		local vector2 = Vector3.new(542.93, 71.5, -405.58)
		local color2 = Color3.fromRGB(110, 231, 140)
		local color3 = Color3.fromRGB(248, 113, 113)
		local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local senaV4StealCardToken = {}
		genv.__SenaV4StealCardToken = senaV4StealCardToken
		local tbl36 = {{"carried by another", "Another player took it"}, {"taken by another", "Another player took it"}, {"someone else grabbed", "Another player took it"}, {"no longer available", "The egg is gone"}, {"target unavailable", "The egg is gone"}, {"target changed", "The egg is gone"}, {"reset countdown", "Eggs are resetting"}, {"egg reset", "The egg reset"}, {"wall closed", "Night started"}, {"character unavailable", "You were knocked out"}, {"character died", "You were knocked out"}, {"they banked", "They banked it first"}, {"could not catch", "Could not catch them"}, {"lost sight", "Could not catch them"}, {"bank not confirmed", "Deposit not confirmed"}, {"delivery failed", "Deposit not confirmed"}, {"not banked", "Deposit not confirmed"}, {"carry", "Could not pick it up"}, {"stopped", "Stopped"}, {"mode changed", "Stopped"}}

		local function fn107(arg)
			local v22 = string.lower(tostring(arg or ""))

			for i, v23 in ipairs(tbl36) do
				if v22:find(v23[1], 1, true) then
					return v23[2]
				end
			end

			return "Steal interrupted \226\128\148 retrying"
		end

		local tbl37 = {"retrying", "could not reach", "destination unavailable", "steal unavailable", "target destination", "no target", "steal error", "preparing", "searching", "target changed", "next egg"}

		local function fn108(arg)
			local v22 = string.lower(tostring(arg or ""))

			if v22 == "" then
				return true
			elseif v22 == "nil" then
				return true
			end

			for i, v23 in ipairs(tbl37) do
				if v22:find(v23, 1, true) then
					return true
				end
			end

			return false
		end

		local tbl38 = {head = {"Heading", "navigation", tbl14.accentB}, secure = {"Securing", "hand", tbl14.accentB}, home = {"Bringing home", "home", tbl14.accentB}, done = {"Stolen", "circle-check", color2}, friend = {"Dropped", "gift", color2}, fail = {"Failed", "circle-x", color3}, retry = {"Retrying", "navigation", tbl14.accentB}}
		local tbl39 = {}

		local function fn109()
			local ok, result = pcall(function()
				return gethui and gethui()
			end)

			if ok and (typeof(result) == "Instance" and not result:IsA("LayerCollector")) then
				return result
			end

			result, ok = pcall(function()
				return game:GetService("CoreGui")
			end)

			return result and ok or fn68()
		end

		local function fn110(parent, cornerRadius)
			local uiCorner = Instance.new("UICorner")
			uiCorner.CornerRadius = cornerRadius or UDim.new(0, 10)
			uiCorner.Parent = parent
		end

		local function fn111()
			if tbl39.gui and tbl39.gui.Parent then
				return true
			end
			fn67()
			local v22 = fn109()

			pcall(function()
				local senaStealCard = v22:FindFirstChild("SenaStealCard")

				if senaStealCard then
					senaStealCard:Destroy()
				end
			end)

			local screenGui = Instance.new("ScreenGui")
			screenGui.Name = "SenaStealCard"
			screenGui.ResetOnSpawn = false
			screenGui.IgnoreGuiInset = true
			screenGui.DisplayOrder = -1
			screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			local frame = Instance.new("Frame")
			frame.Name = "Card"
			frame.AnchorPoint = Vector2.new(0.5, 0)
			frame.Position = UDim2.new(0.5, 0, 0, -n9 - 24)
			frame.Size = UDim2.fromOffset(n8, n9)
			frame.BackgroundColor3 = tbl14.surface
			frame.BorderSizePixel = 0
			frame.Visible = false
			frame.Parent = screenGui
			fn110(frame)
			local uiStroke = Instance.new("UIStroke")
			uiStroke.Color = tbl14.strokeCol
			uiStroke.Thickness = 1
			uiStroke.Parent = frame
			local uiGradient = Instance.new("UIGradient")
			uiGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, tbl14.obsTop), ColorSequenceKeypoint.new(0.55, tbl14.obsMid), ColorSequenceKeypoint.new(1, tbl14.obsLow)})
			uiGradient.Rotation = 16
			uiGradient.Parent = frame
			local n13 = -(n10 * 2 + n11 + 12)
			tbl39.head = tbl17.text(frame, {style = "label", text = "Stealing", color = tbl14.muted, pos = UDim2.fromOffset(n10, 10), size = UDim2.new(1, -(n10 * 2 + 124), 0, 14)})
			local frame2 = Instance.new("Frame")
			frame2.Name = "Chip"
			frame2.AnchorPoint = Vector2.new(1, 0)
			frame2.Position = UDim2.new(1, -n10, 0, 8)
			frame2.Size = UDim2.fromOffset(0, 18)
			frame2.AutomaticSize = Enum.AutomaticSize.X
			frame2.BackgroundColor3 = tbl14.btnBg
			frame2.BorderSizePixel = 0
			frame2.Parent = frame
			fn110(frame2, UDim.new(1, 0))
			local uiPadding = Instance.new("UIPadding")
			uiPadding.PaddingLeft = UDim.new(0, 7)
			uiPadding.PaddingRight = UDim.new(0, 8)
			uiPadding.Parent = frame2
			local uiListLayout = Instance.new("UIListLayout")
			uiListLayout.FillDirection = Enum.FillDirection.Horizontal
			uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
			uiListLayout.Padding = UDim.new(0, 4)
			uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			uiListLayout.Parent = frame2
			tbl39.chipIcon = Instance.new("ImageLabel")
			tbl39.chipIcon.BackgroundTransparency = 1
			tbl39.chipIcon.Size = UDim2.fromOffset(12, 12)
			tbl39.chipIcon.LayoutOrder = 1
			tbl39.chipIcon.Parent = frame2
			tbl39.chipText = tbl17.text(frame2, {style = "label", text = "", order = 2, size = UDim2.fromOffset(0, 14)})
			tbl39.chipText.AutomaticSize = Enum.AutomaticSize.X
			tbl39.chipText.TextTruncate = Enum.TextTruncate.None
			local frame3 = Instance.new("Frame")
			frame3.Position = UDim2.fromOffset(n10, 32)
			frame3.Size = UDim2.fromOffset(n11, n11)
			frame3.BackgroundColor3 = tbl14.surfaceHi
			frame3.BorderSizePixel = 0
			frame3.Parent = frame
			fn110(frame3, UDim.new(0, 8))
			tbl39.img = Instance.new("ImageLabel")
			tbl39.img.BackgroundTransparency = 1
			tbl39.img.Position = UDim2.fromOffset(4, 4)
			tbl39.img.Size = UDim2.new(1, -8, 1, -8)
			tbl39.img.ScaleType = Enum.ScaleType.Fit
			tbl39.img.Parent = frame3
			tbl39.title = tbl17.text(frame, {style = "title", pos = UDim2.fromOffset(n10 + n11 + 12, 31), size = UDim2.new(1, n13, 0, 18)})
			tbl39.rarity = tbl17.text(frame, {style = "body", pos = UDim2.fromOffset(n10 + n11 + 12, 50), size = UDim2.new(1, n13, 0, 16)})
			tbl39.stats = tbl17.text(frame, {style = "meta", color = tbl14.muted, pos = UDim2.fromOffset(n10 + n11 + 12, 66), size = UDim2.new(1, n13, 0, 15)})
			tbl39.barBack = Instance.new("Frame")
			tbl39.barBack.Position = UDim2.fromOffset(n10, 91)
			tbl39.barBack.Size = UDim2.new(1, -(n10 * 2 + 84), 0, 6)
			tbl39.barBack.BackgroundColor3 = tbl14.btnBg
			tbl39.barBack.BorderSizePixel = 0
			tbl39.barBack.Parent = frame
			fn110(tbl39.barBack, UDim.new(1, 0))
			tbl39.barFill = Instance.new("Frame")
			tbl39.barFill.Size = UDim2.fromScale(0, 1)
			tbl39.barFill.BackgroundColor3 = tbl14.accent
			tbl39.barFill.BorderSizePixel = 0
			tbl39.barFill.Parent = tbl39.barBack
			fn110(tbl39.barFill, UDim.new(1, 0))
			tbl39.eta = tbl17.text(frame, {style = "meta", color = tbl14.muted, align = Enum.TextXAlignment.Right, anchor = Vector2.new(1, 0), pos = UDim2.new(1, -n10, 0, 86), size = UDim2.fromOffset(80, 16)})
			tbl39.reason = tbl17.text(frame, {style = "body", color = color3, pos = UDim2.fromOffset(n10, 86), size = UDim2.new(1, -n10 * 2, 0, 16)})
			tbl39.reason.Visible = false
			tbl39.scale = Instance.new("UIScale")
			tbl39.scale.Parent = frame
			screenGui.Parent = v22
			tbl39.gui = screenGui
			tbl39.card = frame
			return true
		end

		local function fn112()
			local n13 = 0

			pcall(function()
				n13 = GuiService:GetGuiInset().Y
			end)

			local tbl40 = {}

			pcall(function()
				if gethui then
					tbl40[#tbl40 + 1] = gethui()
				end
			end)

			pcall(function()
				tbl40[#tbl40 + 1] = game:GetService("CoreGui")
			end)

			local n14 = 0

			for i, v22 in ipairs(tbl40) do
				for i2, v23 in ipairs({{"AnnounceGui", "Holder"}, {"NotifyGui", "AnnounceLayout"}}) do
					i2 = v22:FindFirstChild(v23[1])
					local enabled = i2 and not (i2 and i2.Parent and i2.Parent:IsA("LayerCollector")) and i2:IsA("LayerCollector") and i2.Enabled and i2:FindFirstChild(v23[2])

					if enabled then
						for i3, child in ipairs(enabled:GetChildren()) do
							if child:IsA("GuiObject") and child.Visible then
								local n15 = child.AbsolutePosition.Y + child.AbsoluteSize.Y + n13
								n14 = if n15 > n14 then n15 else n14
							end
						end
					end
				end
			end

			return n14, n13
		end

		local function fn113(arg, arg2, arg3)
			if arg[arg2] ~= arg3 then
				arg[arg2] = arg3
			end
		end

		local function fn114()
			local currentCamera = workspace.CurrentCamera
			local viewportSize = currentCamera and currentCamera.ViewportSize
			return viewportSize and viewportSize.X > 0 and viewportSize.Y > 0 and viewportSize or Vector2.new(1280, 720)
		end

		local function fn115()
			local v22 = fn114()
			local flag6 = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled or v22.Y < 550
			local n13 = math.min(1, (v22.X - 32) / n8)
			if flag6 then
				return math.clamp(math.min(n13, 0.6, v22.Y * 0.15 / n9), 0.5, 1)
			end
			return math.clamp(n13, 0.62, 1)
		end

		local tween, v22
		local flag6, n13 = false
		local tbl40 = {}

		local function fn116(arg)
			if n13 == arg then
				return
			end
			n13 = arg
			local card = tbl39.card
			local tbl41 = {}
			tbl41.Position = UDim2.new(0.5, 0, 0, arg)
			TweenService:Create(card, tweenInfo, tbl41):Play()
		end

		local function fn117(arg)
			if arg == flag6 then
				return
			end
			flag6 = arg

			if arg then
				n13 = nil
				tbl39.card.Position = UDim2.new(0.5, 0, 0, -n9 - 24)
				tbl39.card.Visible = true
				local v23 = fn115()
				tbl39.scale.Scale = v23 * 0.94
				tween = TweenService:Create(tbl39.scale, tweenInfo, {Scale = v23})
				tween:Play()
			else
				n13 = -n9 - 24
				local tween2 = TweenService:Create(tbl39.card, tweenInfo, {Position = UDim2.new(0.5, 0, 0, n13)})

				tween2.Completed:Connect(function()
					if not flag6 then
						tbl39.card.Visible = false
					end
				end)

				tween2:Play()
			end
		end

		local function fn118(chipKind)
			local head = tbl38[chipKind] or tbl38.head
			if tbl39.chipKind == chipKind then
				return
			end
			tbl39.chipKind = chipKind
			tbl39.chipText.Text = string.upper(head[1])
			tbl39.chipText.TextColor3 = head[3]
			tbl39.chipIcon.ImageColor3 = head[3]
			tbl17.icon(tbl39.chipIcon, head[2])
		end

		local function fn119(arg)
			local bottomCFrame = arg and (arg.BottomCFrame or arg.BoundsCFrame)
			return bottomCFrame and bottomCFrame.Position
		end

		local function fn120(arg, arg2)
			local n14 = arg - arg2
			return Vector3.new(n14.X, 0, n14.Z).Magnitude
		end

		local function fn121(arg, arg2)
			local v23 = string.lower(tostring(arg or ""))

			if arg2 then
				return "home"
			elseif v23:find("bringing", 1, true) then
				return "home"
			elseif v23:find("deposit", 1, true) then
				return "home"
			elseif v23:find("delivering", 1, true) then
				return "home"
			elseif v23:find("carrying", 1, true) then
				return "home"
			elseif v23:find("validating", 1, true) then
				return "home"
			end

			if v23:find("securing", 1, true) then
				return "secure"
			elseif v23:find("waiting for carry", 1, true) then
				return "secure"
			elseif v23:find("re-steal", 1, true) then
				return "secure"
			elseif v23:find("re-approach", 1, true) then
				return "secure"
			elseif v23:find("confirm", 1, true) then
				return "secure"
			elseif v23:find("grabbing", 1, true) then
				return "secure"
			elseif v23:find("attacking", 1, true) then
				return "secure"
			end

			return "head"
		end

		local n14 = 4.2
		local n15 = 0.7

		local function fn122(arg, arg2, arg3)
			local humanoidRootPart = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
			local v23 = fn119(arg.record)
			if not humanoidRootPart then
				return nil
			end

			if arg.boost then
				if arg2 == "home" then
					return fn120(humanoidRootPart.Position, vector2) / arg.back + n15
				end

				if not v23 then
					return nil
				end
				return math.max(n14 - (os.clock() - arg.startedAt), 0) + fn120(v23, vector2) / arg.back + n15
			end

			if arg2 == "home" then
				return fn120(humanoidRootPart.Position, vector2) / arg.back + 2.5
			end

			if arg.kind ~= "auto" then
				return nil
			elseif v23 then
			else
				return nil
			end

			local hold = arg.hold
			local v24 = if arg2 == "secure" then tonumber(string.match(tostring(arg3 or ""), "%(([%d%.]+)s%)")) or math.max(hold - (os.clock() - (arg.phaseAt or os.clock())), 0.5) else hold
			return (arg2 == "head" and not arg.boost and fn120(humanoidRootPart.Position, v23) / arg.out or 0) + v24 + fn120(v23, vector2) / arg.back + 4.5
		end

		local function fn123(arg, arg2, arg3, arg4, arg5)
			local v23

			pcall(function()
				v23 = v6.resolve(arg3)
			end)

			local assetCategory = arg3.AssetCategory
			local v24, v25, v26 = fn71(assetCategory)
			local tbl41 = {kind = arg, uid = arg2, record = arg3, player = arg5, startedAt = os.clock(), progress = 0, area = tostring(arg3.AreaId or "?"), out = 400, back = 5000, hold = 1}

			if arg4 then
				tbl41.delivered = tonumber(arg4.stats and arg4.stats.delivered) or 0
				tbl41.mode = arg4.config and arg4.config.stealMode or "Fly"

				pcall(function()
					tbl41.boost = arg4:_usesPortalBoost(arg3) == true
				end)

				pcall(function()
					tbl41.walk = arg4:_legitWalkSpeed()
				end)

				if tbl41.mode == "Fly" then
					tbl41.out = tonumber(tbl41.walk) or 16
					tbl41.hold = 1
				else
					tbl41.out = 5000
					tbl41.hold = tbl41.boost and 0 or (tonumber(arg4:_resolveSettleSeconds(arg3)) or 8)
				end
			end

			tbl41.key = tostring(tbl41.mode) .. "|" .. tbl41.area .. (tbl41.boost and "|b" or "")
			fn111()
			tbl41.headBase = arg5 and string.upper("Stealing from " .. tostring(arg5)) or "STEALING"
			fn113(tbl39.head, "Text", tbl41.headBase)
			fn113(tbl39.head, "TextColor3", tbl14.muted)
			fn113(tbl39.title, "Text", v23 and tostring(v23.name) or tostring(assetCategory or "Egg"))
			fn113(tbl39.rarity, "Text", tostring(v25 or "?"))
			fn113(tbl39.rarity, "TextColor3", v26 and v26:Lerp(Color3.new(1, 1, 1), 0.35) or tbl14.text)
			local tbl42 = {}
			local v27 = fn76(arg3)

			if v27 and v27 > 0 then
				tbl42[#tbl42 + 1] = v27 >= 1000 and fn70(v27) .. " kg" or string.format("%.1f kg", v27)
			end

			local v28 = fn75(arg3)

			if v28 and v28 > 0 then
				tbl42[#tbl42 + 1] = "$" .. fn70(v28) .. "/s"
			end

			local tbl43 = {}

			for i, v29 in ipairs(type(arg3.Mutations) == "table" and arg3.Mutations or {}) do
				if #tbl43 < 2 then
					tbl43[#tbl43 + 1] = tostring(v29)
				end
			end

			if #tbl43 > 0 then
				tbl42[#tbl42 + 1] = table.concat(tbl43, ", ")
			end

			fn113(tbl39.stats, "Text", table.concat(tbl42, "  \194\183  "))
			local v29 = fn72(assetCategory)

			if not v29 then
				pcall(function()
					v29 = fn98(assetCategory)
				end)
			end

			fn113(tbl39.img, "Image", v29 or "")
			tbl41.color = v26 or tbl14.accent
			fn113(tbl39.barFill, "BackgroundColor3", tbl41.color)
			tbl39.barFill.Size = UDim2.fromScale(0, 1)
			tbl39.barBack.Visible, tbl39.eta.Visible, tbl39.reason.Visible = true, true, false
			tbl39.chipKind = nil
			fn118("head")
			v22 = tbl41
			fn117(true)
		end

		local function fn124(result, arg)
			local v23 = v22

			if v23 then
				if v23.endedAt then
					return
				end
			else
				return
			end

			v23.endedAt = os.clock()
			v23.result = result
			fn118(result)

			if result == "fail" then
				tbl39.barBack.Visible, tbl39.eta.Visible, tbl39.reason.Visible = false, false, true
				fn113(tbl39.reason, "TextColor3", color3)
				fn113(tbl39.reason, "Text", arg or "Steal interrupted \226\128\148 retrying")
			elseif result == "retry" then
				tbl39.barBack.Visible, tbl39.eta.Visible, tbl39.reason.Visible = false, false, true
				fn113(tbl39.reason, "TextColor3", tbl14.muted)
				fn113(tbl39.reason, "Text", arg or "Retrying\226\128\166")
			else
				fn113(tbl39.barFill, "BackgroundColor3", color2)
				local barFill = tbl39.barFill
				local tbl41 = {}
				tbl41.Size = UDim2.fromScale(1, 1)
				TweenService:Create(barFill, tweenInfo, tbl41):Play()
				fn113(tbl39.eta, "Text", result == "friend" and "Handed off" or "Banked")

				if result == "done" and v23.kind == "auto" then
					local n16 = v23.endedAt - v23.startedAt
					tbl40[v23.key] = tbl40[v23.key] and tbl40[v23.key] * 0.6 + n16 * 0.4 or n16
				end
			end
		end

		local tbl41 = {rt = nil, unsub = nil, result = nil, at = 0}

		local function fn125(rt)
			if tbl41.rt == rt then
				return
			end

			if tbl41.unsub then
				pcall(tbl41.unsub)
			end

			tbl41.rt = rt
			tbl41.unsub = nil

			if rt then
				if type(rt.onChanged) ~= "function" then
					return
				end
			else
				return
			end

			local running

			local ok, unsub = pcall(rt.onChanged, rt, function(arg)
				if type(arg) ~= "table" then
					return
				end

				if running and not arg.running then
					tbl41.result, tbl41.at = arg.lastResult, os.clock()
				end

				running = arg.running
			end)

			if ok and type(unsub) == "function" then
				tbl41.unsub = unsub
			end
		end

		local function fn126(arg)
			if arg then
				if arg.destroyed then
					return nil
				elseif arg._externalDeliver then
					return nil
				end
			else
				return nil
			end

			local primerUid = arg.primerUid
			local targetUid = arg.targetUid
			targetUid = targetUid or (if arg.activeTarget then if arg.activeTarget.Uid ~= primerUid then arg.activeTarget.Uid else targetUid else targetUid)
			local v23 = targetUid or (if arg.carry then if arg.carry.active then if arg.carry.uid ~= primerUid then arg.carry.uid else targetUid else targetUid else targetUid)
			if v23 == primerUid then
				return nil
			end
			return v23
		end

		local function fn127(arg)
			local lastResult = tbl41.at >= v22.startedAt and tbl41.result or arg and arg.stats and arg.stats.lastResult
			local v23 = string.lower(tostring(lastResult or ""))
			if arg and (tonumber(arg.stats.delivered) or 0) > (v22.delivered or 0) then
				return "done"
			end

			if v23:find("dropped for a friend", 1, true) then
				return "friend"
			end

			if v23:find("safe return complete", 1, true) then
				return "done"
			end

			if v22.sawCarry then
				local v24

				pcall(function()
					v24 = EggState2.ReadFieldEgg(v22.uid)
				end)

				if v24 == nil then
					return "done"
				else
					if v24.State == "Claimed" then
						return "done"
					end
				end
			end

			if arg and (not arg.enabled and not arg._recalling) then
				return "fail", "Stopped"
			end

			if fn108(lastResult) then
				return "retry"
			end
			return "fail", fn107(lastResult)
		end

		local now2

		local function fn128()
			local senaV4EggRuntime = genv.__SenaV4EggRuntime
			local senaV4PlayerSteal = genv.__SenaV4PlayerSteal
			fn125(senaV4EggRuntime)
			local str3, status
			local flag7, player, v23, v24 = false

			if senaV4PlayerSteal and senaV4PlayerSteal.running and type(senaV4PlayerSteal.cardTarget) == "table" then
				local uid = senaV4PlayerSteal.cardTarget.uid
				status = senaV4PlayerSteal.status
				player = senaV4PlayerSteal.cardTarget.player
				flag7 = senaV4EggRuntime ~= nil and senaV4EggRuntime._externalDeliver == true
				str3, v24 = "ps", uid
			else
				local v25 = fn126(senaV4EggRuntime)

				if v25 then
					status = senaV4EggRuntime.stats and senaV4EggRuntime.stats.status
					flag7 = senaV4EggRuntime.carry and senaV4EggRuntime.carry.active and senaV4EggRuntime.carry.uid == v25
					str3 = "auto"
				end

				v24 = v25
			end

			if v22 and not v22.endedAt and (v24 ~= v22.uid or str3 ~= v22.kind) then
				now2 = now2 or os.clock()

				if v24 ~= nil or os.clock() - now2 >= 0.4 then
					if v22.kind == "ps" then
						local history = senaV4PlayerSteal and senaV4PlayerSteal.history and senaV4PlayerSteal.history[1]
						local str4 = history and tostring(history.outcome) or ""

						if str4 == "taken" then
							fn124("done")
						elseif str4 == "sniped drop" then
							fn124("done")
						else
							fn124("fail", fn107(str4))
						end
					else
						fn124(fn127(senaV4EggRuntime))
					end
				end
			else
				now2 = nil
			end

			if v22 and v22.endedAt then
				local n16 = os.clock() - v22.endedAt

				if v24 and n16 >= 1.5 then
					v22 = nil
				else
					if not v24 and n16 >= (v22.result == "fail" and 4 or 3) then
						v22 = nil
						fn117(false)
					end
				end
			end

			local str4

			if v24 and not v22 then
				local v25
				local flag8, record = str3 == "ps"

				if flag8 then
					record = senaV4PlayerSteal.cardTarget.record
				else
					record = v25
				end

				pcall(function()
					record = record or EggState2.ReadFieldEgg(v24)
				end)

				record = record or senaV4EggRuntime and senaV4EggRuntime.records and senaV4EggRuntime.records[v24]

				if type(record) == "table" then
					fn123(str3, v24, record, senaV4EggRuntime, player)
				end
			end

			if v22 then
				if not flag6 then
					return
				end
			else
				return
			end

			senaV4EggRuntime, senaV4PlayerSteal = fn112()
			local v25 = fn115()

			if not (tween and tween.PlaybackState == Enum.PlaybackState.Playing) then
				fn113(tbl39.scale, "Scale", v25)
			end

			fn113(tbl39.card, "Size", UDim2.fromOffset(math.floor(math.min(n8, (fn114().X - 32) / v25)), n9))
			fn116(math.floor(math.max(senaV4PlayerSteal + n12, senaV4EggRuntime + n12)))
			if v22.endedAt then
				return
			end

			if os.clock() >= (v22.netAt or 0) then
				v22.netAt = os.clock() + 1
				local v26 = fn3()
				local v27 = genv.__SenaV4NetPing()
				str4 = v26 > 0 and v26 < 20 and "LOW FPS" or nil
				str4 = if v27 > 250 then str4 and str4 .. " + HIGH PING" or "HIGH PING" else str4
				fn113(tbl39.head, "Text", str4 and str4 .. "  \194\183  MAY TAKE LONGER" or v22.headBase)
				fn113(tbl39.head, "TextColor3", str4 and Color3.fromRGB(245, 196, 81) or tbl14.muted)
			end

			if flag7 then
				v22.sawCarry = true
			end

			v25 = fn121(status, flag7)

			if v25 ~= v22.phase then
				local v26 = v22
				str4 = v22
				local now3 = os.clock()
				v26.phase = v25
				str4.phaseAt = now3
			end

			fn118(v25)
			local n16 = os.clock() - v22.startedAt
			senaV4PlayerSteal = fn122(v22, v25, status)
			local v26 = tbl40[v22.key]

			if v26 then
				local n17 = v26 - n16
				senaV4PlayerSteal = senaV4PlayerSteal and (senaV4PlayerSteal + n17) / 2 or n17
			end

			if senaV4PlayerSteal then
				v22.progress = math.max(v22.progress, math.min(n16 / math.max(n16 + math.max(senaV4PlayerSteal, 0), 0.1), 0.96))
				fn113(tbl39.eta, "Text", senaV4PlayerSteal >= 1 and string.format("~%ds left", math.ceil(senaV4PlayerSteal)) or "Almost done")
			else
				v22.progress = math.max(v22.progress, math.min(n16 / (n16 + 12), 0.6))
				fn113(tbl39.eta, "Text", string.format("%ds", math.floor(n16)))
			end

			fn113(tbl39.barFill, "Size", UDim2.fromScale(v22.progress, 1))
		end

		task.spawn(function()
			while genv.__SenaV4StealCardToken == senaV4StealCardToken do
				task.wait(0.1)
				fn67()
				local ok, result = pcall(fn128)

				if not ok and not tbl39.warned then
					tbl39.warned = true
					warn("[Sena] steal card: " .. tostring(result))
				end
			end

			if tbl39.gui then
				pcall(function()
					tbl39.gui:Destroy()
				end)
			end

			if tbl41.unsub then
				pcall(tbl41.unsub)
			end
		end)
	end)()

	senaPanels.windows = windows

	function senaPanels.openLogs()
		fn104("logs")
	end

	function senaPanels.openBoard()
		fn104("eggs")
	end

	function senaPanels.openInventory()
		fn104("inventory")
	end

	function senaPanels.openChecker()
		fn104("checker")
	end

	function senaPanels.openAnalyst()
		fn104("eggdata")
	end

	function senaPanels.openStats()
		fn104("stats")
	end

	function senaPanels.openAll()
		fn105()
	end

	function senaPanels.closeAll()
		fn106()
	end

	function senaPanels.isPlaceEnabled(arg)
		return tbl24[arg] ~= false
	end

	pcall(function()
		getgenv().SenaPanels = senaPanels
	end)
end

fn65()

do
	local HttpService = game:GetService("HttpService")
	local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
	local hopHunt = {file = "SenaHub/SaeHopHunt.json", state = nil, status = "Checking this server...", watch = {}, gone = {}, revealed = nil, gui = nil, busy = false, prompting = false}
	tbl13.hopHunt = hopHunt
	hopHunt.bootCode = "if game:GetAttribute(\"SenaBootQueued\") then return end\ngame:SetAttribute(\"SenaBootQueued\", true)\nrepeat task.wait(0.5) until game:IsLoaded()\ntask.wait(1.5)\nloadstring(game:HttpGet(\"https://senahub.xyz/raw/senav6\"))()\n"

	hopHunt.elevate = function()
		local senaV4IdentitySetter2 = genv.__SenaV4IdentitySetter

		if type(senaV4IdentitySetter2) == "function" then
			pcall(senaV4IdentitySetter2, genv.__SenaV4UICapabilityIdentity or 8)
		end
	end

	hopHunt.period = function()
		local ok, result = pcall(function()
			return require(ReplicatedStorage2.Shared.Util.AreaEggCycle).PeriodIndexAt(workspace:GetServerTimeNow())
		end)

		return ok and result or math.floor(os.time() / 300)
	end

	hopHunt.load = function()
		local data

		pcall(function()
			if isfile and isfile(hopHunt.file) then
				data = HttpService:JSONDecode(readfile(hopHunt.file))
			end
		end)

		if type(data) ~= "table" then
			data = {}
		end

		data.limit = tonumber(data.limit) or 10
		data.hops = tonumber(data.hops) or 0
		data.sinceAsk = tonumber(data.sinceAsk) or 0
		data.visited = type(data.visited) == "table" and data.visited or {}

		if type(data.targets) ~= "table" then
			data.targets = {Divine = true}
		else
			if not data.targets.Divine and (not data.targets.Eternal and not data.targets.Secret) then
				data.targets = {Divine = true}
			end
		end

		if data.period ~= hopHunt.period() then
			data.visited = {}
			data.period = hopHunt.period()
		end

		hopHunt.state = data
		return data
	end

	hopHunt.save = function()
		pcall(function()
			if makefolder and (isfolder and not isfolder("SenaHub")) then
				makefolder("SenaHub")
			end

			if writefile then
				writefile(hopHunt.file, HttpService:JSONEncode(hopHunt.state))
			end
		end)
	end

	hopHunt.targets = function()
		local tbl14 = {}
		local tbl15 = {}
		local targets = hopHunt.state and hopHunt.state.targets or {}

		for i, v21 in ipairs({"Divine", "Eternal", "Secret"}) do
			if targets[v21] then
				tbl15[v21] = true
				tbl14[#tbl14 + 1] = v21
			end
		end

		if #tbl14 == 0 then
			tbl14 = {"Divine"}
			tbl15 = {Divine = true}
		end

		return tbl14, tbl15
	end

	hopHunt.playerName = function(arg)
		if arg == localPlayer.UserId then
			return "you"
		end
		local playerByUserId = Players:GetPlayerByUserId(arg or 0)
		return playerByUserId and (playerByUserId.DisplayName or playerByUserId.Name) or "another player"
	end

	hopHunt.notify = function(arg)
		pcall(function()
			game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Rare Egg Hop", Text = arg, Duration = 6})
		end)
	end

	hopHunt.scan = function()
		local v21, v22 = hopHunt.targets()
		local str3 = table.concat(v21, "/")
		local EggState2 = require(ReplicatedStorage2.Client.EggState)

		local ok, result = pcall(function()
			return EggState2.ReadFieldEggs()
		end)

		local v23, v24
		local tbl14 = {}

		if ok and type(result) == "table" then
			local v25 = ipairs
			local records = result.Records or {}
			local tbl15 = v24
			local tbl16 = v23

			for k, record in v25(records) do
				local ok2, result2 = pcall(v6.resolve, record)

				if ok2 and result2 and v22[result2.rarity] then
					local v26 = record

					pcall(function()
						v26 = EggState2.ReadFieldEgg(record.Uid) or record
					end)

					tbl14[record.Uid] = true
					local label = tostring(result2.rarity) .. " " .. tostring(result2.name or "Egg")
					local tbl17 = hopHunt.watch[record.Uid] or {}
					tbl17.label = label
					tbl17.rarity = result2.rarity

					if v26.State == "Carried" then
						if v26.CarrierUserId then
							tbl17.carrier = v26.CarrierUserId
							tbl15 = tbl15 or {label = label, by = v26.CarrierUserId}
						else
							tbl16 = tbl16 or {label = label}
						end
					else
						tbl16 = tbl16 or {label = label}
					end

					hopHunt.watch[record.Uid] = tbl17
				end
			end

			v23 = tbl16
			v24 = tbl15
		end

		for k, v25 in pairs(hopHunt.watch) do
			if not tbl14[k] then
				if v25.carrier then
					hopHunt.gone[#hopHunt.gone + 1] = {label = v25.label, by = v25.carrier, rarity = v25.rarity}
				end

				hopHunt.watch[k] = nil
			end
		end

		result = nil

		for i = #hopHunt.gone, 1, -1 do
			if v22[hopHunt.gone[i].rarity] then
				result = hopHunt.gone[i]
				break
			end
		end

		if v23 then
			return "field", v23.label .. " is still in the field!"
		elseif v24 then
			return "carried", v24.label .. " is being carried by " .. hopHunt.playerName(v24.by)
		elseif result then
			return "collected", result.label .. " was collected by " .. hopHunt.playerName(result.by)
		elseif hopHunt.revealed == true then
			return "collected", "This round's " .. str3 .. " was already collected"
		end

		return "none", "No " .. str3 .. " in this server right now"
	end

	hopHunt.hop = function()
		if hopHunt.busy then
			return
		end
		hopHunt.busy = true
		local state = hopHunt.state
		state.visited[game.JobId] = true
		state.active = true
		state.hops = state.hops + 1
		state.sinceAsk = state.sinceAsk + 1
		state.period = hopHunt.period()
		hopHunt.save()
		hopHunt.status = "Hopping... (" .. state.sinceAsk .. " / " .. state.limit .. ")"

		pcall(function()
			local queueOnTeleport = queue_on_teleport or queueonteleport or syn and syn.queue_on_teleport

			if queueOnTeleport then
				queueOnTeleport(hopHunt.bootCode)
			end
		end)

		local hopWindow = tbl13.hopWindow

		if hopWindow then
			pcall(function()
				hopWindow:SaveConfig("HopSession")
			end)
		end

		local tbl14 = {}

		for i, v21 in ipairs(tbl13.collectServers(nil) or {}) do
			if not state.visited[v21.id] then
				tbl14[#tbl14 + 1] = v21
			end
		end

		if not tbl13.hopToList(tbl14) then
			state.hops = math.max(0, state.hops - 1)
			state.sinceAsk = math.max(0, state.sinceAsk - 1)
			hopHunt.save()
			hopHunt.status = "No fresh server found, retrying shortly"
			hopHunt.statusUntil = os.clock() + 8
			hopHunt.nextTry = os.clock() + 8
		end

		hopHunt.busy = false
	end

	hopHunt.stop = function(arg)
		if hopHunt.state then
			hopHunt.state.active = false
			hopHunt.state.hops = 0
			hopHunt.state.sinceAsk = 0
			hopHunt.save()
		end

		hopHunt.prompting = false
		hopHunt.status = "Hopping stopped"

		if arg and hopHunt.state then
			hopHunt.state.watch = false
			hopHunt.save()
		end

		if arg and hopHunt.gui then
			hopHunt.elevate()

			pcall(function()
				hopHunt.gui:Destroy()
			end)

			hopHunt.gui = nil
		end
	end

	hopHunt.open = function()
		hopHunt.elevate()
		if hopHunt.gui and hopHunt.gui.Parent then
			return
		end
		local state = hopHunt.state or hopHunt.load()
		local TweenService = game:GetService("TweenService")
		local screenGui = Instance.new("ScreenGui")
		screenGui.Name = "SenaHopHunt"
		screenGui.ResetOnSpawn = false
		screenGui.DisplayOrder = 9999
		screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

		local function fn66(arg, arg2, parent)
			local instance = Instance.new(arg)

			for k, v21 in pairs(arg2) do
				instance[k] = v21
			end

			instance.Parent = parent
			return instance
		end

		local function fn67(arg, arg2)
			fn66("UICorner", {CornerRadius = UDim.new(0, arg2)}, arg)
		end

		local function fn68(arg, arg2, arg3)
			fn66("UIStroke", {Color = arg2, Thickness = 1, Transparency = arg3 or 0, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, arg)
		end

		local function fn69(arg, arg2)
			TweenService:Create(arg, TweenInfo.new(0.18, Enum.EasingStyle.Quad), arg2):Play()
		end

		local color2 = Color3.fromRGB(13, 13, 16)
		local color3 = Color3.fromRGB(19, 19, 23)
		local color4 = Color3.fromRGB(27, 27, 32)
		local color5 = Color3.fromRGB(46, 46, 54)
		local color6 = Color3.fromRGB(42, 42, 50)
		local color7 = Color3.fromRGB(238, 238, 243)
		local color8 = Color3.fromRGB(162, 162, 174)
		local color9 = Color3.fromRGB(116, 116, 128)
		local color10 = Color3.fromRGB(232, 232, 238)
		local color11 = Color3.fromRGB(14, 14, 17)
		local color12 = Color3.fromRGB(74, 222, 128)
		local color13 = Color3.fromRGB(245, 190, 80)
		local color14 = Color3.fromRGB(235, 90, 90)
		local Frame = fn66("Frame", {Size = UDim2.new(0, 320, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Position = UDim2.new(0.5, -160, 0, 80), BackgroundColor3 = color2, BorderSizePixel = 0, Active = true, Draggable = true}, screenGui)
		fn67(Frame, 12)
		fn68(Frame, color6)
		fn66("UIPadding", {PaddingTop = UDim.new(0, 14), PaddingBottom = UDim.new(0, 14), PaddingLeft = UDim.new(0, 14), PaddingRight = UDim.new(0, 14)}, Frame)
		fn66("UIListLayout", {Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder}, Frame)
		local n8 = 0

		local function fn70(arg, arg2)
			n8 += 1
			local Frame2 = fn66("Frame", {LayoutOrder = n8, Size = UDim2.new(1, 0, 0, arg), BackgroundTransparency = 1, BorderSizePixel = 0}, Frame)

			for k, v21 in pairs(arg2 or {}) do
				Frame2[k] = v21
			end

			return Frame2
		end

		local function fn71(arg, arg2)
			local TextLabel = fn66("TextLabel", {BackgroundTransparency = 1, Font = Enum.Font.BuilderSansMedium, TextSize = 12, TextColor3 = color7, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Center, TextWrapped = true}, arg)

			for k, v21 in pairs(arg2) do
				TextLabel[k] = v21
			end

			return TextLabel
		end

		color2 = fn70(34)
		fn67(fn66("ImageLabel", {Size = UDim2.new(0, 34, 0, 34), BackgroundColor3 = color4, BorderSizePixel = 0, Image = "rbxassetid://96240498384290", ScaleType = Enum.ScaleType.Fit}, color2), 9)
		fn71(color2, {Position = UDim2.new(0, 44, 0, 0), Size = UDim2.new(1, -80, 0, 18), Text = "Rare Egg Hop", Font = Enum.Font.BuilderSansBold, TextSize = 14})
		fn71(color2, {Position = UDim2.new(0, 44, 0, 18), Size = UDim2.new(1, -80, 0, 16), Text = "Find Divine, Eternal and Secret across servers", TextSize = 11, TextColor3 = color8, Font = Enum.Font.BuilderSans})
		local TextButton = fn66("TextButton", {AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 2), Size = UDim2.new(0, 28, 0, 28), BackgroundColor3 = color3, BorderSizePixel = 0, Text = "X", Font = Enum.Font.BuilderSansBold, TextSize = 12, TextColor3 = color8, AutoButtonColor = false}, color2)
		fn67(TextButton, 8)

		local function fn72()
			fn69(TextButton, {BackgroundColor3 = color14, TextColor3 = Color3.new(1, 1, 1)})
		end

		TextButton.MouseEnter:Connect(fn72)

		local function fn73()
			fn69(TextButton, {BackgroundColor3 = color3, TextColor3 = color8})
		end

		TextButton.MouseLeave:Connect(fn73)
		local v21 = fn70(64, {BackgroundTransparency = 0, BackgroundColor3 = color3})
		fn67(v21, 10)
		local UIStroke = fn66("UIStroke", {Color = color6, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, v21)
		local Frame2 = fn66("Frame", {Position = UDim2.new(0, 12, 0, 15), Size = UDim2.new(0, 8, 0, 8), BackgroundColor3 = color9, BorderSizePixel = 0}, v21)
		fn67(Frame2, 4)
		local v22 = fn71(v21, {Position = UDim2.new(0, 28, 0, 8), Size = UDim2.new(1, -40, 0, 22), Text = "Checking", Font = Enum.Font.BuilderSansBold, TextSize = 13})
		local v23 = fn71(v21, {Position = UDim2.new(0, 12, 0, 30), Size = UDim2.new(1, -24, 0, 28), Text = "", TextSize = 11, TextColor3 = color8, Font = Enum.Font.BuilderSans, TextYAlignment = Enum.TextYAlignment.Top})
		local v24 = fn70(30)
		local v25 = fn71(v24, {Size = UDim2.new(0.5, 0, 0, 16), Text = "Hops 0 / 10", TextSize = 11, TextColor3 = color8})
		local v26 = fn71(v24, {Position = UDim2.new(0.5, 0, 0, 0), Size = UDim2.new(0.5, 0, 0, 16), Text = "", TextSize = 11, TextColor3 = color9, TextXAlignment = Enum.TextXAlignment.Right})
		local Frame3 = fn66("Frame", {Position = UDim2.new(0, 0, 0, 22), Size = UDim2.new(1, 0, 0, 6), BackgroundColor3 = color5, BorderSizePixel = 0}, v24)
		fn67(Frame3, 3)
		local Frame4 = fn66("Frame", {Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = color10, BorderSizePixel = 0}, Frame3)
		fn67(Frame4, 3)

		local function fn74(arg)
			local v27 = fn70(arg, {BackgroundTransparency = 0, BackgroundColor3 = color3})
			fn67(v27, 10)
			return v27
		end

		local v27 = fn74(40)
		fn71(v27, {Position = UDim2.new(0, 12, 0, 0), Size = UDim2.new(0, 70, 1, 0), Text = "Hunt for"})
		local tbl14 = {}

		local function fn75()
			for k, v28 in pairs(tbl14) do
				local flag6 = state.targets[k] == true
				fn69(v28, {BackgroundColor3 = flag6 and color10 or color4, TextColor3 = flag6 and color11 or color8})
			end
		end

		local tbl15 = {"Divine", "Eternal", "Secret"}

		for i, v28 in ipairs(tbl15) do
			color2 = fn66("TextButton", {AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10 - (#tbl15 - i) * 64, 0.5, 0), Size = UDim2.new(0, 60, 0, 26), BackgroundColor3 = color4, BorderSizePixel = 0, Text = v28, Font = Enum.Font.BuilderSansBold, TextSize = 12, TextColor3 = color8, AutoButtonColor = false}, v27)
			fn67(color2, 7)
			tbl14[v28] = color2

			local function fn76()
				local n9 = 0

				for i2, v29 in ipairs(tbl15) do
					n9 = if state.targets[v29] then n9 + 1 else n9
				end

				if state.targets[v28] and n9 <= 1 then
					return
				end
				local targets = state.targets
				local v29 = state.targets[v28]
				targets[v28] = if v29 then nil else not v29
				hopHunt.watch = {}
				hopHunt.save()
				fn75()
			end

			color2.MouseButton1Click:Connect(fn76)
		end

		fn75()
		local v28 = fn74(40)
		fn71(v28, {Position = UDim2.new(0, 12, 0, 0), Size = UDim2.new(0, 120, 1, 0), Text = "Ask after"})

		local function fn76(arg, arg2)
			local TextButton2 = fn66("TextButton", {AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, arg2, 0.5, 0), Size = UDim2.new(0, 26, 0, 26), BackgroundColor3 = color4, BorderSizePixel = 0, Text = arg, Font = Enum.Font.BuilderSansBold, TextSize = 14, TextColor3 = color7, AutoButtonColor = true}, v28)
			fn67(TextButton2, 7)
			return TextButton2
		end

		local v29 = fn76("+", -12)
		local TextBox = fn66("TextBox", {AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -42, 0.5, 0), Size = UDim2.new(0, 64, 0, 26), BackgroundColor3 = color4, BorderSizePixel = 0, Text = tostring(state.limit), PlaceholderText = "10", Font = Enum.Font.BuilderSansBold, TextSize = 12, TextColor3 = color7, ClearTextOnFocus = false}, v28)
		fn67(TextBox, 7)
		local v30 = fn76("-", -110)
		fn71(v28, {AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -140, 0.5, 0), Size = UDim2.new(0, 34, 0, 26), Text = "hops", TextSize = 11, TextColor3 = color9, TextXAlignment = Enum.TextXAlignment.Right})

		local function fn77(arg)
			state.limit = math.clamp(math.floor(tonumber(arg) or state.limit), 1, 100)
			TextBox.Text = tostring(state.limit)
			hopHunt.save()
		end

		local function fn78()
			fn77(TextBox.Text)
		end

		TextBox.FocusLost:Connect(fn78)

		local function fn79()
			fn77(state.limit + 1)
		end

		v29.MouseButton1Click:Connect(fn79)

		local function fn80()
			fn77(state.limit - 1)
		end

		v30.MouseButton1Click:Connect(fn80)

		local function fn81(arg, arg2, arg3, arg4)
			local v31 = fn74(62)
			fn71(v31, {Position = UDim2.new(0, 12, 0, 8), Size = UDim2.new(1, -76, 0, 18), Text = arg, Font = Enum.Font.BuilderSansBold})
			fn71(v31, {Position = UDim2.new(0, 12, 0, 27), Size = UDim2.new(1, -76, 0, 28), Text = arg2, TextSize = 10, TextColor3 = color8, Font = Enum.Font.BuilderSans, TextYAlignment = Enum.TextYAlignment.Top})
			local TextButton2 = fn66("TextButton", {AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -12, 0.5, 0), Size = UDim2.new(0, 36, 0, 19), BackgroundColor3 = color5, BorderSizePixel = 0, Text = "", AutoButtonColor = false}, v31)
			fn67(TextButton2, 10)
			local Frame5 = fn66("Frame", {Size = UDim2.new(0, 13, 0, 13), Position = UDim2.new(0, 3, 0.5, -6), BackgroundColor3 = color8, BorderSizePixel = 0}, TextButton2)
			fn67(Frame5, 7)
			local v32

			local function fn82()
				local flag6 = arg3() == true
				if flag6 == v32 then
					return
				end
				v32 = flag6
				fn69(TextButton2, {BackgroundColor3 = flag6 and color10 or color5})
				fn69(Frame5, {Position = flag6 and UDim2.new(1, -16, 0.5, -6) or UDim2.new(0, 3, 0.5, -6), BackgroundColor3 = flag6 and color11 or color8})
			end

			local function fn83()
				arg4(not arg3())
				fn82()
			end

			TextButton2.MouseButton1Click:Connect(fn83)
			fn82()
			return fn82
		end

		local autoHop = fn81("Auto Hop", "Hops until a target is found, and again after each collect.", function()
			return state.active
		end, function(arg)
			state.active = arg == true
			hopHunt.prompting = false

			if arg then
				state.sinceAsk = 0
			end

			hopHunt.save()
		end)

		local startAfterCollect = fn81("Start After Collect", "Waits in this server, then starts Auto Hop once the target is banked.", function()
			return state.watch
		end, function(arg)
			state.watch = arg == true
			hopHunt.save()
		end)

		local v31 = fn70(36)
		local TextButton2 = fn66("TextButton", {Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = color4, BorderSizePixel = 0, Text = "Hop Now", Font = Enum.Font.BuilderSansBold, TextSize = 13, TextColor3 = color7, AutoButtonColor = false}, v31)
		fn67(TextButton2, 8)
		fn68(TextButton2, color6)

		local function fn82()
			fn69(TextButton2, {BackgroundColor3 = color10, TextColor3 = color11})
		end

		TextButton2.MouseEnter:Connect(fn82)

		local function fn83()
			fn69(TextButton2, {BackgroundColor3 = color4, TextColor3 = color7})
		end

		TextButton2.MouseLeave:Connect(fn83)

		local function fn84()
			if hopHunt.busy then
				return
			end
			hopHunt.prompting = false
			hopHunt.nextTry = 0
			task.spawn(hopHunt.hop)
		end

		TextButton2.MouseButton1Click:Connect(fn84)
		local v32 = fn70(92, {BackgroundTransparency = 0, BackgroundColor3 = color3, Visible = false})
		fn67(v32, 10)
		fn68(v32, color10, 0.4)
		local v33 = fn71(v32, {Position = UDim2.new(0, 12, 0, 8), Size = UDim2.new(1, -24, 0, 18), Text = "", Font = Enum.Font.BuilderSansBold})
		local Frame5 = fn66("Frame", {Position = UDim2.new(0, 12, 0, 32), Size = UDim2.new(1, -24, 0, 4), BackgroundColor3 = color4, BorderSizePixel = 0}, v32)
		fn67(Frame5, 2)
		local Frame6 = fn66("Frame", {Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = color10, BorderSizePixel = 0}, Frame5)
		fn67(Frame6, 2)

		local function fn85(arg, arg2, arg3, arg4)
			local TextButton3 = fn66("TextButton", {Position = UDim2.new(arg2, arg2 == 0 and 12 or 4, 0, 46), Size = UDim2.new(0.5, -16, 0, 34), BackgroundColor3 = arg3, BorderSizePixel = 0, Text = arg, Font = Enum.Font.BuilderSansBold, TextSize = 13, TextColor3 = arg4, AutoButtonColor = true}, v32)
			fn67(TextButton3, 8)
			return TextButton3
		end

		local Continue = fn85("Continue", 0, color10, color11)
		local Stop = fn85("Stop", 0.5, color4, color7)
		local n9

		Continue.MouseButton1Click:Connect(function()
			hopHunt.prompting = false
			n9 = nil
			state.sinceAsk = 0
			state.active = true
			hopHunt.save()
		end)

		Stop.MouseButton1Click:Connect(function()
			hopHunt.prompting = false
			n9 = nil
			state.active = false
			hopHunt.save()
		end)

		local function fn86()
			hopHunt.stop(true)
		end

		TextButton.MouseButton1Click:Connect(fn86)

		local ok = pcall(function()
			screenGui.Parent = game:GetService("CoreGui")
		end)

		if if ok then screenGui.Parent == nil else not ok then
			screenGui.Parent = localPlayer:FindFirstChildOfClass("PlayerGui")
		end

		hopHunt.gui = screenGui
		local UIScale = fn66("UIScale", {Scale = 1}, Frame)

		local function fn87()
			local currentCamera = workspace.CurrentCamera
			if not currentCamera then
				return
			end
			local viewportSize = currentCamera.ViewportSize
			local n10 = Frame.AbsoluteSize.Y / math.max(UIScale.Scale, 0.01)
			local n11 = math.min(1, (viewportSize.X - 24) / 320, (viewportSize.Y - 60) / math.max(n10, 1))
			UIScale.Scale = math.clamp(n11, 0.5, 1)

			if viewportSize.X < 700 then
				Frame.Position = UDim2.new(0.5, -160 * UIScale.Scale, 0, 36)
			end
		end

		task.defer(fn87)

		local function fn88()
			task.defer(fn87)
		end

		Frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(fn88)

		pcall(function()
			workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fn87)
		end)

		local tbl16 = {field = {"Target in the field", color12}, carried = {"Being carried", color13}, collected = {"Collected", color8}, none = {"Not in this server", color9}, hopping = {"Hopping", Color3.fromRGB(120, 170, 255)}, asking = {"Keep hopping?", color13}}
		local now = os.clock()
		local flag6 = false
		local flag7 = false

		task.spawn(function()
			while screenGui.Parent do
				hopHunt.elevate()
				local ok2, result, result2 = pcall(hopHunt.scan)
				hopHunt.elevate()

				if ok2 then
				else
					result = "none"
					result2 = "Reading this server..."
				end

				if result == "field" then
					flag6 = true
				else
					if result == "carried" then
						flag6 = true
					end
				end

				local flag8 = os.clock() - now > 6
				local flag9 = senaV4Config.IsStealing == true or senaV4Config.IsPlacing == true

				if not hopHunt.busy then
					if hopHunt.prompting then
					elseif flag8 then
						if not flag9 and os.clock() >= (hopHunt.nextTry or 0) then
							local flag10 = false

							if state.active and (result == "none" or result == "collected") then
								flag10 = true
							else
								if state.active then
								else
									if state.watch and (flag6 and result == "collected") then
										state.active = true
										hopHunt.save()
										flag10 = true
									end
								end
							end

							if flag10 then
								if state.sinceAsk >= state.limit then
									hopHunt.prompting = true
									n9 = os.clock() + 10
								else
									task.spawn(hopHunt.hop)
								end
							end
						end
					end
				end

				if result == "field" and (state.active and not flag7) then
					flag7 = true
					hopHunt.notify(result2)
				end

				flag9, flag8 = hopHunt.busy

				if flag9 then
					result2 = hopHunt.status
					flag8 = "hopping"
				else
					if hopHunt.prompting then
						flag8 = "asking"
						local n10 = math.max(0, n9 - os.clock())
						v33.Text = string.format("%d hops done. Keep hopping? (%ds)", state.limit, math.ceil(n10))
						Frame6.Size = UDim2.new(n10 / 10, 0, 1, 0)
						result2 = "Nothing more to grab here. Continue to hop " .. state.limit .. " more times."

						if n10 <= 0 then
							hopHunt.prompting = false
							state.active = false
							hopHunt.save()
							if not state.watch then
								hopHunt.stop(true)
								break
							end
						end
					else
						result2, flag8 = if hopHunt.status ~= "" then if hopHunt.statusUntil then if os.clock() < hopHunt.statusUntil then hopHunt.status else result2 else result2 else result2, result
					end
				end

				v32.Visible = hopHunt.prompting
				local none = tbl16[flag8] or tbl16.none
				v22.Text = none[1]
				Frame2.BackgroundColor3 = none[2]
				UIStroke.Color = flag8 == "field" and color12 or color6
				v23.Text = tostring(result2 or "")
				autoHop()
				startAfterCollect()
				ok2 = 0

				for k in pairs(state.visited) do
					ok2 += 1
				end

				v25.Text = string.format("Hops %d / %d", state.sinceAsk, state.limit)
				v26.Text = ok2 > 0 and ok2 .. " servers skipped" or ""
				Frame4.Size = UDim2.new(math.clamp(state.sinceAsk / math.max(1, state.limit), 0, 1), 0, 1, 0)
				task.wait(0.5)
			end
		end)
	end

	pcall(function()
		local EggState2 = require(ReplicatedStorage2.Client.EggState)

		if EggState2.RarityRevealed then
			local function fn66(arg)
				hopHunt.revealed = nil
				hopHunt.gone = {}
				hopHunt.watch = {}
				local v21, v22 = hopHunt.targets()

				for k, v23 in pairs(type(arg) == "table" and type(arg.RareSpawns) == "table" and arg.RareSpawns or {}) do
					if v22[tostring(type(v23) == "table" and (v23.Rarity or v23.rarity) or v23)] then
						hopHunt.revealed = true
					end
				end

				if hopHunt.state and hopHunt.state.period ~= hopHunt.period() then
					hopHunt.state.visited = {}
					hopHunt.state.period = hopHunt.period()
					hopHunt.save()
				end
			end

			EggState2.RarityRevealed:Connect(fn66)
		end
	end)

	hopHunt.load()
end

local function fn66()
	local senaLibUrl = genv.SenaLibUrl or "https://senahub.xyz/raw/libsenuy2"

	pcall(function()
		local chloeXInstance = genv.ChloeX_Instance

		if type(chloeXInstance) == "table" and type(chloeXInstance.DestroyGui) == "function" then
			chloeXInstance:DestroyGui()
		end
	end)

	genv.ChloeX_Running = nil
	genv.ChloeX_ReopenPrompt = nil
	genv.ChloeX_Instance = nil
	local senaLibOverride, flag6 = genv.SenaLibOverride

	if type(senaLibOverride) ~= "table" then
		local ok, result = pcall(function()
			return loadstring(game:HttpGet(senaLibUrl))()
		end)

		flag6 = ok and type(result) == "table" and result or nil
	else
		flag6 = senaLibOverride
	end

	if not flag6 then
		warn("[Sena] UI library failed to load")
		return
	end

	pcall(function()
		local HttpService = game:GetService("HttpService")
		local str3 = "SenaHUB/sena_tier.json"

		local function fn67()
			local ok, result = pcall(flag6.GetSavedKey, flag6)
			return ok and type(result) == "string" and result ~= "" and result or nil
		end

		local function fn68(arg, arg2)
			pcall(function()
				if makefolder and (isfolder and not isfolder("SenaHUB")) then
					makefolder("SenaHUB")
				end

				writefile(str3, HttpService:JSONEncode({key = arg, at = os.time(), expires = tonumber(arg2 and arg2.expires) or 0, tier = arg2 and (arg2.is_trial == true or arg2.tier == "trial") and "trial" or "donator"}))
			end)
		end

		local function fn69()
			local ok, result = pcall(function()
				return isfile and isfile(str3) and HttpService:JSONDecode(readfile(str3)) or nil
			end)

			return ok and type(result) == "table" and result or nil
		end

		flag6:SetDonator(false)
		local v21 = fn67()
		local v22 = fn69()

		if v21 and v22 and v22.key == v21 and os.time() - (tonumber(v22.at) or 0) < 43200 and ((tonumber(v22.expires) or 0) == 0 or tonumber(v22.expires) > os.time()) then
			if v22.tier == "trial" then
				flag6:SetDonator(false, true)
			else
				flag6:SetDonator(true)
			end
		end

		if v21 then
			task.spawn(function()
				local v23, v24 = flag6:CheckDonatorKey()

				if v23 and type(v24) == "table" and v24.ok == true and v24.valid == true then
					fn68(v21, v24)
				elseif v24 ~= "network_error" then
					pcall(function()
						if delfile and isfile(str3) then
							delfile(str3)
						end
					end)
				end
			end)
		end

		if type(flag6.DonatorListeners) == "table" then
			table.insert(flag6.DonatorListeners, function()
				local donatorInfo = flag6.DonatorInfo
				local v23 = fn67()

				if flag6:IsDonator() and (v23 and (type(donatorInfo) == "table" and donatorInfo.ok == true)) then
					fn68(v23, donatorInfo)
				end
			end)
		end
	end)

	local function fn67(arg)
		local tbl14 = {}

		for i, v21 in ipairs(type(arg) == "table" and arg or {}) do
			if v21 ~= "None" and v21 ~= "" then
				tbl14[#tbl14 + 1] = v21
			end
		end

		return tbl14
	end

	local function fn68()
		local tbl14 = {}

		pcall(function()
			for i, v21 in ipairs(v6.getRarities()) do
				tbl14[#tbl14 + 1] = v21
			end
		end)

		if #tbl14 == 0 then
			tbl14 = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Cosmic", "Secret", "Eternal", "Divine"}
		end

		return tbl14
	end

	local function fn69(arg)
		local tbl14 = {"All"}

		for i, v21 in ipairs(arg) do
			if v21 ~= "All" then
				tbl14[#tbl14 + 1] = v21
			end
		end

		return tbl14
	end

	local tbl14 = {}

	pcall(function()
		for i, v21 in ipairs(v6.getMutations()) do
			tbl14[#tbl14 + 1] = v21
		end
	end)

	if #tbl14 == 0 then
		tbl14 = {"Golden", "Rainbow", "Shocked", "Frozen", "Burnt", "Boss"}
	end

	local tbl15 = {"None"}

	local ok = pcall(function()
		local directory, ok, result = require(game:GetService("ReplicatedStorage").Data.Areas).Directory, pcall(function()
			return require(game:GetService("ReplicatedStorage").Data.Assets)
		end)

		if ok and result and result.Directory then
			local directory2 = result.Directory
			local tbl16 = {}

			for k, v21 in pairs(directory) do
				if type(v21) == "table" and type(v21.DropTable) == "table" then
					for i, v22 in ipairs(v21.DropTable) do
						local v23 = v22[1]

						if type(v23) == "string" and not tbl16[v23] then
							tbl16[v23] = true
							local v24 = directory2[v23]
							tbl15[#tbl15 + 1] = v24 and v24.DisplayName or v23
						end
					end
				end
			end
		end
	end)

	if if ok then #tbl15 <= 1 else not ok then
		tbl15 = {"None"}
	end

	table.sort(tbl15, function(arg, arg2)
		if arg == "None" then
			return true
		end

		if arg2 == "None" then
			return false
		end
		return arg < arg2
	end)

	local tbl16 = {"None"}

	do
		local tbl17 = {"Lake", "Jungle", "Desert", "Snow", "Volcano", "Abyss Ocean", "Prehistoric", "Cosmic", "Cherry Blossom", "Titan Temple"}
		local tbl18 = {}

		local ok2 = pcall(function()
			for k, v21 in pairs(require(game:GetService("ReplicatedStorage").Data.Areas).Directory) do
				if type(v21) == "table" and type(v21.DropTable) == "table" then
					tbl18[k] = true
				end
			end
		end)

		if if ok2 then next(tbl18) == nil else not ok2 then
			for i, v21 in ipairs(tbl17) do
				tbl18[v21] = true
			end
		end

		local tbl19 = {None = true, Forest = true, ["Titan Temple"] = true}

		for i, v21 in ipairs(tbl17) do
			if v21 ~= "Titan Temple" and tbl18[v21] then
				table.insert(tbl16, v21)
				tbl19[v21] = true
			end
		end

		local tbl20 = {}

		for k in pairs(tbl18) do
			if not tbl19[k] then
				table.insert(tbl20, k)
			end
		end

		table.sort(tbl20)

		for i, v21 in ipairs(tbl20) do
			table.insert(tbl16, v21)
		end

		if tbl18["Titan Temple"] then
			table.insert(tbl16, "Titan Temple")
		end
	end

	local str3 = ""

	local function fn70(arg, arg2)
		local assetCategory = arg.AssetCategory
		local v21 = assetCategory and arg2.Directory[assetCategory]
		local str4 = "Unknown"

		if v21 and v21.Rarity then
			local rarity = v21.Rarity
			str4 = rarity.DisplayName or rarity._id or rarity.Name or "Unknown"
		end

		return str4, v21
	end

	local function fn71(arg)
		local placeRarities = senaV4Config.PlaceRarities or {}

		if #placeRarities == 0 then
			return true
		elseif table.find(placeRarities, "None") then
			return true
		elseif table.find(placeRarities, "All") then
			return true
		end

		return table.find(placeRarities, arg) ~= nil
	end

	local function fn72(arg)
		return not (type(senaPanels.isPlaceEnabled) == "function" and senaPanels.isPlaceEnabled(arg) == false)
	end

	local tbl17 = {at = 0, value = false}

	local function fn73()
		if not senaV4Config.AutoPlace then
			return false
		end

		if senaV4Config.IsPlacing then
			return true
		end
		local now = os.clock()
		if now - tbl17.at < 1 then
			return tbl17.value
		end
		tbl17.at = now
		local value = false

		local function fn74()
			local EggState2 = require(game:GetService("ReplicatedStorage").Client.EggState)
			local Assets = require(game:GetService("ReplicatedStorage").Data.Assets)
			local v21 = EggState2.GetOwnerRuntimeRecords(localPlayer.UserId)
			if type(v21) ~= "table" then
				return
			end
			local n8 = 0
			local n9 = 0

			for k, v22 in pairs(v21) do
				if v22.Placement ~= nil then
					n8 = n8 + 1
				else
					n9 = if fn72(k) then if fn71((fn70(v22, Assets))) then n9 + 1 else n9 else n9
				end
			end

			value = n9 > 0 and n8 < 30
		end

		pcall(fn74)
		tbl17.value = value
		return value
	end

	function tbl10.AutoPlaceLoop()
		if senaV4Config.IsAutoPlaceWorkerRunning then
			return
		end
		senaV4Config.IsAutoPlaceWorkerRunning = true

		while senaV4Config.AutoPlace and fn2() do
			task.wait(1.5)

			local ok2, result = pcall(function()
				local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
				game:GetService("HttpService")
				local EggState2 = require(ReplicatedStorage2.Client.EggState)
				local Assets = require(ReplicatedStorage2.Data.Assets)
				ReplicatedStorage2 = nil
				local plots = workspace:FindFirstChild("Plots")

				if plots then
					for i, child in ipairs(plots:GetChildren()) do
						local plotSign = child:FindFirstChild("PlotSign")

						if plotSign then
							local playerPlotSign = plotSign:FindFirstChild("PlayerPlotSign")

							if playerPlotSign and (playerPlotSign:FindFirstChild("Frame") and playerPlotSign.Frame:FindFirstChild("PlayerName")) then
								local text = playerPlotSign.Frame.PlayerName.Text
								local v21 = string.gsub(text, "<[^>]+>", "")

								if string.find(string.lower(v21), string.lower(localPlayer.Name)) then
									ReplicatedStorage2 = child
									break
								elseif string.find(string.lower(v21), string.lower(localPlayer.DisplayName)) then
									ReplicatedStorage2 = child
									break
								end
							end
						end
					end
				end

				if not ReplicatedStorage2 then
					str3 = "Looking for your plot"
					return
				end
				local toUpdate = ReplicatedStorage2:FindFirstChild("ToUpdate")
				local petArea = toUpdate and toUpdate:FindFirstChild("PetArea")
				local centerPoint = ReplicatedStorage2:FindFirstChild("CenterPoint") or petArea
				if not petArea then
					return
				end
				local tbl18 = {}
				local flag7 = EggState2.GetOwnerRuntimeRecords(localPlayer.UserId)
				local n8 = 0

				if type(flag7) == "table" then
					for k, v21 in pairs(flag7) do
						if v21.Placement ~= nil then
							n8 += 1
						else
							local v22, v23 = fn70(v21, Assets)
							local v24 = fn72(k) and fn71(v22)
							local num = tonumber(v21.Kg) or tonumber(v21.Weight) or tonumber(v21.kg)
							local n9 = num or (if v23 then tonumber(v23.Kg) or tonumber(v23.Weight) or tonumber(v23.kg) else num) or 0

							if v24 then
								table.insert(tbl18, {Uid = k, Rarity = v22, Kg = n9})
							end
						end
					end
				end

				table.sort(tbl18, function(arg, arg2)
					return arg.Kg > arg2.Kg
				end)

				local character = localPlayer.Character

				if character then
					character:FindFirstChild("HumanoidRootPart")
				end

				if character then
					character:FindFirstChildOfClass("Humanoid")
				end

				if #tbl18 == 0 or n8 >= 30 then
					str3 = #tbl18 == 0 and "No eggs to place" or "Plot full (30 placed)"
					return
				end

				local function fn74()
					return senaV4TaskLadder.blocker("auto_place") ~= nil
				end

				if fn74() then
					str3 = senaV4TaskLadder.yieldLabel("auto_place") or ""
					return
				end
				Assets = senaV4TaskLadder.holder("auto_place")
				if Assets then
					str3 = "Waiting for " .. senaV4TaskLadder.TITLES[Assets] .. " to hand over"
					return
				end
				senaV4Config.IsPlacing = true
				str3 = string.format("Placing %d egg%s", #tbl18, #tbl18 == 1 and "" or "s")
				local senaV4TreadmillManager = genv.__SenaV4TreadmillManager

				if senaV4TreadmillManager and senaV4TreadmillManager.activeTreadmill ~= nil then
					Assets = os.clock() + 5

					while senaV4TreadmillManager.activeTreadmill ~= nil and os.clock() < Assets and not fn74() do
						pcall(function()
							senaV4TreadmillManager:_requestUnequip()
						end)

						task.wait(0.3)
					end
				end

				local character2 = localPlayer.Character
				local humanoidRootPart = character2 and character2:FindFirstChild("HumanoidRootPart")
				local humanoid = character2 and character2:FindFirstChildOfClass("Humanoid")

				if humanoidRootPart and humanoidRootPart.Anchored then
					pcall(function()
						humanoidRootPart.Anchored = false
					end)
				end

				if humanoid then
					pcall(function()
						humanoid:UnequipTools()
					end)
				end

				local v21 = if humanoidRootPart then humanoidRootPart.CFrame else nil

				local function fn75()
					local autoPlace = senaV4Config.AutoPlace
					return if autoPlace then fn74() else not autoPlace
				end

				if humanoidRootPart and petArea then
					local n9 = petArea.CFrame * CFrame.new(0, 3, 0)

					if not fn59(humanoidRootPart.Position + Vector3.new(0, 2, 0), n9.Position + Vector3.new(0, 2, 0), character2) then
						fn38(humanoidRootPart, humanoid, CFrame.new(518.66, 70.57, -364.73) * CFrame.Angles(3.141592653589793, -1.5676547341413067, 3.141592653589793), fn75)
						if fn75() then
							return
						end
					end

					fn38(humanoidRootPart, humanoid, n9, fn75)
					if fn75() then
						return
					end
					n9 = 0

					while n9 < 0.5 and not fn75() do
						task.wait(0.05)
						n9 += 0.05
					end

					if fn75() then
						return
					end
				end

				local tbl19 = {}

				for k, v22 in pairs(flag7) do
					if v22.Placement then
						local v23 = if typeof(v22.Placement) == "CFrame" then v22.Placement.Position else if typeof(v22.Placement) == "Vector3" then v22.Placement else if v22.Placement.Position then v22.Placement.Position else nil

						if v23 then
							table.insert(tbl19, v23)
						end
					end
				end

				flag7 = false
				local n9 = 0

				for i, v22 in ipairs(tbl18) do
					if senaV4Config.AutoPlace then
						if flag7 then
							break
						end
					else
						break
					end

					local v23 = flag7
					if n8 >= 30 then
						flag7 = true
						break
					end

					if fn75() then
						return
					end
					local uid = v22.Uid
					local v24 = EggState2.GetOwnerRuntimeRecords(localPlayer.UserId)[uid]

					if EggState2.RequestEquipTool(uid) then
						if fn75() then
							return
						end
						task.wait(0.15)
						local flag8 = false
						flag7 = v23

						while n9 < 30 and not flag8 do
							local v25

							if petArea and centerPoint then
								local v26 = n9
								local v27 = v25

								while v26 < 30 do
									local n10 = 10
									local n11 = petArea.Size.X - 6
									local n12 = petArea.Size.Z - 6
									local n13 = n11 / n10
									local n14 = math.floor(v26 / n10)
									local n15 = v26 % n10
									local n16 = -(n11 / 2) + n13 / 2
									local n17 = -(n12 / 2) + 3
									local n18 = n16 + n15 * n13
									local n19 = n17 + n14 * 6
									local n20 = petArea.CFrame * Vector3.new(n18, 0, n19)
									local v28 = centerPoint.CFrame:PointToObjectSpace(n20)
									local cframe = CFrame.new(v28.X, -0.5, v28.Z)
									n14 = false

									for i2, v29 in ipairs(tbl19) do
										if (v29 - cframe.Position).Magnitude < 1 then
											n14 = true
											break
										end
									end

									if not n14 then
										v27 = cframe
										break
									end
									v26 += 1
								end

								v25 = v27
								n9 = v26
							end

							if not v25 then
								flag7 = true
								break
							end

							if fn75() then
								return
							end
							local v26, v27 = EggState2.RequestPlaceEgg(uid, v25)

							if v26 then
								table.insert(tbl19, v25.Position)
								n8 += 1
								task.wait(0.15)
								flag8 = true
							else
								local str4 = v27 and string.lower(tostring(v27)) or ""

								if string.find(str4, "full") or string.find(str4, "limit") or string.find(str4, "capacity") or string.find(str4, "maximum") then
									if senaV4Config.AutoPlace then
										senaV4Config.AutoPlace = false
									end

									flag7 = true
									break
								end

								table.insert(tbl19, v25.Position)
								n9 += 1
								task.wait(0.1)
							end
						end
					else
						flag7 = v23
					end
				end

				if v21 and (humanoidRootPart and not fn75()) then
					if not fn59(humanoidRootPart.Position + Vector3.new(0, 2, 0), v21.Position + Vector3.new(0, 2, 0), character2) then
						fn38(humanoidRootPart, humanoid, CFrame.new(518.66, 70.57, -364.73) * CFrame.Angles(3.141592653589793, -1.5676547341413067, 3.141592653589793), fn75)
					end

					if fn75() then
						return
					end
					fn38(humanoidRootPart, humanoid, v21, fn75)
					task.wait(0.2)
				end
			end)

			if senaV4Config.IsPlacing then
				str3 = ""
			end

			senaV4Config.IsPlacing = false

			if not ok2 then
				str3 = "Error, retrying"
				warn("Auto Place Error: " .. tostring(result))
			end
		end

		senaV4Config.IsAutoPlaceWorkerRunning = false
	end

	senaV4TaskLadder.register("auto_place", {wants = fn73, active = function()
		return senaV4Config.IsPlacing == true
	end, enabled = function()
		return senaV4Config.AutoPlace == true
	end, status = function()
		return str3
	end})

	function tbl10.AutoHatchLoop()
		if senaV4Config.IsAutoHatchWorkerRunning then
			return
		end
		senaV4Config.IsAutoHatchWorkerRunning = true

		task.spawn(function()
			local tbl18 = {}

			while senaV4Config.AutoHatch and fn2() do
				task.wait(1.5)

				pcall(function()
					local EggState2 = require(game:GetService("ReplicatedStorage").Client.EggState)
					local v21 = EggState2.GetOwnerRuntimeRecords(localPlayer.UserId)
					if not v21 then
						return
					end
					local tbl19 = {}

					for k, v22 in pairs(v21) do
						if v22.Placement ~= nil then
							table.insert(tbl19, k)
						end
					end

					local now = os.time()

					for i, v22 in ipairs(tbl19) do
						if not senaV4Config.AutoHatch then
							break
						end

						if tbl18[v22] and now < tbl18[v22] then
							continue
						end
						local v23 = v21[v22]
						local flag7 = false

						if type(EggState2.IsReadyToHatch) == "function" then
							local ok2, result = pcall(EggState2.IsReadyToHatch, v22)
							flag7 = ok2 and result == true
						end

						if flag7 or v23.Ready == true or not tbl18[v22] then
							if EggState2.RequestHatchEgg(v22) then
								EggState2.RequestCompleteHatchEgg(v22)
								tbl18[v22] = nil
								task.wait(0.1)
							else
								tbl18[v22] = now + 10
							end
						end
					end
				end)
			end

			senaV4Config.IsAutoHatchWorkerRunning = false
		end)
	end

	local flag7 = false
	local tbl18 = {wants = false, busy = false, status = ""}

	local function fn74()
		local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
		local EggState2 = require(ReplicatedStorage2.Client.EggState)
		local Remotes = require(ReplicatedStorage2.Shared.Remotes)
		local directory

		pcall(function()
			local Assets = require(ReplicatedStorage2.Data.Assets)
			directory = Assets.Directory or Assets
		end)

		local function fn75(arg)
			local category = arg.Category or arg.AssetCategory
			local v21 = directory and category and directory[category]
			return v21 and v21.DisplayName or category
		end

		local function fn76(arg)
			local category = arg.Category or arg.AssetCategory
			local v21 = directory and category and directory[category]
			local rarity = v21 and v21.Rarity
			return rarity and (rarity.DisplayName or rarity._id) or nil
		end

		local function fn77()
			return senaV4TaskLadder.blocker("use_scrambled") ~= nil
		end

		local str4 = ({Fractured = "Boss", Enchanted = "Enchanted"})[senaV4Config.MutationChoice] or "Scrambled"

		local function fn78(arg)
			local tbl19 = {AssetCategory = arg.AssetCategory or arg.Category, AssetScale = arg.AssetScale or arg.Scale or 1, Mutations = arg.Mutations or {}, BaseMutation = arg.BaseMutation, AssetEyeColor = arg.AssetEyeColor, AssetColorSeed = arg.AssetColorSeed, AssetColorIndex = arg.AssetColorIndex, Gender = arg.Gender, Personality = arg.Personality, HasBeenFirstPlaced = arg.HasBeenFirstPlaced}

			local ok2, result = pcall(function()
				return senaV4Config:getAreaEggValue(tbl19)
			end)

			return ok2 and tonumber(result) or 0
		end

		local function fn79()
			for i, v21 in ipairs({localPlayer.Character, localPlayer:FindFirstChildOfClass("Backpack")}) do
				if v21 then
					for i2, child in ipairs(v21:GetChildren()) do
						if child:IsA("Tool") and (child:GetAttribute("ItemType") == "MutationConsumable" and child:GetAttribute("MutationId") == str4) then
							return child
						end
					end
				end
			end

			return nil
		end

		local function fn80(arg)
			local mutations = arg and arg.Mutations
			if mutations == nil then
				return false
			end

			if type(mutations) == "table" then
				for i, mutation in ipairs(mutations) do
					if mutation == str4 then
						return true
					end
				end

				for k, mutation in pairs(mutations) do
					if k == str4 then
						return true
					elseif mutation == str4 then
						return true
					end
				end

				return false
			end

			return tostring(mutations):find(str4) ~= nil
		end

		local mutationSpecies = senaV4Config.MutationSpecies
		local flag8 = type(mutationSpecies) == "table" and #mutationSpecies > 0
		local mutationRarities = senaV4Config.MutationRarities
		local flag9 = type(mutationRarities) == "table" and #mutationRarities > 0
		local n8 = tonumber(senaV4Config.MutationMinRate) or 0

		local function fn81(arg)
			if type(arg) ~= "table" then
				return false
			elseif arg.Placement == nil then
				return false
			elseif fn80(arg) then
				return false
			end

			if n8 > 0 then
				local rateOf = tbl10.rateOf
				if (rateOf and rateOf({Category = arg.Category or arg.AssetCategory, Scale = arg.Scale or arg.AssetScale or 1, Mutations = arg.Mutations or {}}) or 0) < n8 then
					return false
				end
			end

			local category = arg.Category or arg.AssetCategory
			local v21 = fn75(arg)

			if flag8 then
				local flag10 = false

				for i, mutationSpecy in ipairs(mutationSpecies) do
					if mutationSpecy == v21 or mutationSpecy == category then
						flag10 = true
						break
					end
				end

				if not flag10 then
					return false
				end
			end

			if flag9 then
				local v22 = fn76(arg)

				for i, mutationRarity in ipairs(mutationRarities) do
					if mutationRarity == v22 then
						return true
					end
				end

				return false
			end

			return true
		end

		local v21 = fn79()
		local v22 = EggState2.GetOwnerRuntimeRecords(localPlayer.UserId)
		local wants = false

		if v21 and type(v22) == "table" then
			for k, v23 in pairs(v22) do
				if fn81(v23) then
					wants = true
					break
				end
			end
		end

		tbl18.wants = wants

		if not v21 then
			tbl18.status = "No " .. tostring(senaV4Config.MutationChoice or "Scrambled") .. " item in your bag"

			if not flag7 then
				warn("[AutoMutation] no " .. tostring(senaV4Config.MutationChoice or "Scrambled") .. " consumable in the inventory, round skipped.")
				flag7 = true
			end

			return
		end

		flag7 = false
		if not wants then
			tbl18.status = "No placed egg to mutate"
			return
		end

		if fn77() then
			tbl18.status = senaV4TaskLadder.yieldLabel("use_scrambled") or ""
			return
		end
		local useScrambled = senaV4TaskLadder.holder("use_scrambled")
		if useScrambled then
			tbl18.status = "Waiting for " .. senaV4TaskLadder.TITLES[useScrambled] .. " to hand over"
			return
		end
		local character = localPlayer.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		if not humanoid then
			return
		end
		tbl18.busy = true
		tbl18.status = "Applying " .. tostring(senaV4Config.MutationChoice or "Scrambled")

		if not character:FindFirstChild(v21.Name) then
			pcall(function()
				humanoid:EquipTool(v21)
			end)

			task.wait(0.15)
		end

		local tbl19 = {}

		for k, v23 in pairs(v22) do
			if fn81(v23) then
				tbl19[#tbl19 + 1] = {uid = k, rec = v23, value = fn78(v23)}
			end
		end

		table.sort(tbl19, function(arg, arg2)
			return arg.value > arg2.value
		end)

		for i, v23 in ipairs(tbl19) do
			local uid = v23.uid
			local rec = v23.rec
			if fn77() then
				break
			end

			if fn81(rec) then
				local placedEggRenders = workspace:FindFirstChild("PlacedEggRenders")
				local v24 = placedEggRenders and placedEggRenders:FindFirstChild(tostring(localPlayer.UserId) .. "_" .. uid)
				local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

				if v24 and humanoidRootPart then
					local position = v24:GetPivot().Position

					if (position - humanoidRootPart.Position).Magnitude > 30 then
						tbl18.status = "Walking to " .. tostring((fn75(rec)))
						local vector2 = Vector3.new(humanoidRootPart.Position.X - position.X, 0, humanoidRootPart.Position.Z - position.Z)
						local n9 = position + (vector2.Magnitude > 0.1 and vector2.Unit or Vector3.new(1, 0, 0)) * 10 + Vector3.new(0, 3, 0)
						pcall(fn38, humanoidRootPart, humanoid, CFrame.new(n9), fn77)
						tbl18.status = "Applying " .. tostring(senaV4Config.MutationChoice or "Scrambled")
					end
				end

				local v25 = fn79()
				if not v25 then
					break
				end

				if not character:FindFirstChild(v25.Name) then
					pcall(function()
						humanoid:EquipTool(v25)
					end)

					task.wait(0.1)
				end

				local n9 = 0
				local flag10 = false

				repeat
					if fn77() then
						break
					end

					if fn79() == nil then
						break
					end

					local ok2, result = pcall(function()
						return Remotes.BossMastery.AskUseMutationConsumable:InvokeServer(uid)
					end)

					n9 += 1

					if ok2 and type(result) == "table" then
						flag10 = if result.Mutated == true then true else flag10
						if result.Success ~= true then
							break
						end
					else
						break
					end

					task.wait(0.25)
				until flag10 or not senaV4Config.MutationRetry or n9 >= 40
			end
		end

		tbl18.busy = false
		tbl18.status = ""
	end

	function tbl10.mutationSweep()
		local ok2, result = pcall(fn74)
		tbl18.busy = false

		if not ok2 then
			error(result, 0)
		end
	end

	senaV4TaskLadder.register("use_scrambled", {wants = function()
		return senaV4Config.AutoMutation == true and tbl18.wants == true
	end, active = function()
		return tbl18.busy == true
	end, enabled = function()
		return senaV4Config.AutoMutation == true
	end, status = function()
		return tbl18.status
	end})

	function tbl10.AutoMutationLoop()
		if senaV4Config.IsAutoMutationWorkerRunning then
			return
		end
		senaV4Config.IsAutoMutationWorkerRunning = true

		task.spawn(function()
			while senaV4Config.AutoMutation and fn2() do
				task.wait(1)
				pcall(tbl10.mutationSweep)
			end

			senaV4Config.IsAutoMutationWorkerRunning = false
		end)
	end

	function tbl10.RingEventLoop()
		if senaV4Config.IsRingEventRunning then
			return
		end
		senaV4Config.IsRingEventRunning = true

		task.spawn(function()
			local cframe = CFrame.new(542.93, 71.5, -405.58)
			local cframe2 = CFrame.new(602, 70.78, -372)
			local cframe3 = CFrame.new(5573, 70.77, -363)

			local function fn75()
				local autoRingEvent = senaV4Config.AutoRingEvent
				return if autoRingEvent then not fn2() else not autoRingEvent
			end

			local function fn76(arg)
				if fn75() then
					return false
				end
				local character = localPlayer.Character
				local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
				local humanoid = character and character:FindFirstChildOfClass("Humanoid")
				if if humanoidRootPart then not humanoid else not humanoidRootPart then
					task.wait(0.3)
					return not fn75()
				end
				fn38(humanoidRootPart, humanoid, arg, fn75, false, nil, true)
				return not fn75()
			end

			while not fn75() do
				if not fn76(cframe) then
					break
				end

				if not fn76(cframe2) then
					break
				end

				if not fn76(cframe3) then
					break
				end

				if not fn76(cframe2) then
					break
				end
			end

			senaV4Config.IsRingEventRunning = false
		end)
	end

	local v21, v22, v23, AssetEarnings

	local function rateOf(arg)
		if AssetEarnings == nil then
			pcall(function()
				AssetEarnings = require(game:GetService("ReplicatedStorage").Shared.Util.AssetEarnings)
			end)
		end

		local ok2
		if not AssetEarnings then
			return 0
		end
		local v24 = ipairs
		local result

		for k, v25 in v24({AssetEarnings.LiveRatePerSecond, AssetEarnings.RatePerSecond, AssetEarnings.CatalogRatePerSecond}) do
			if type(v25) == "function" then
				ok2, result = pcall(v25, arg)
				if ok2 and (type(result) == "number" and result > 0) then
					return result
				end
			end
		end

		return 0
	end

	tbl10.rateOf = rateOf

	local function fn75(arg)
		local str4 = string.lower(tostring(arg or "")):gsub("[%s,]", "")
		if str4 == "" then
			return 0
		end
		local v24, v25 = string.match(str4, "^([%d]+%.?[%d]*)([kmb]?)$")
		local num = tonumber(v24)
		if not num then
			return 0
		end
		return num * (if v25 == "k" then 1000 else if v25 == "m" then 1000000 else if v25 == "b" then 1000000000 else 1)
	end

	local flag8 = false
	local tbl19 = {petPending = false, petBusy = false, status = ""}

	function tbl10.startAutoSellLoop()
		if flag8 then
			return
		end
		flag8 = true

		task.spawn(function()
			local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
			local Assets = require(ReplicatedStorage2.Data.Assets)
			local Save = require(ReplicatedStorage2.Shared.Save)
			local AssetRoster = require(ReplicatedStorage2.Client.AssetRoster)
			local Remotes = require(ReplicatedStorage2.Shared.Remotes)
			local localPlayer2 = game:GetService("Players").LocalPlayer

			local function fn76()
				local ok2, result = pcall(function()
					return AssetRoster.ReadOwnerPen(localPlayer2.UserId)
				end)

				if ok2 then
					if type(result) ~= "table" then
						return nil
					end
				else
					return nil
				end

				local tbl20 = {}

				for k, v24 in pairs(result) do
					if type(k) == "string" then
						tbl20[k] = true
					end

					if type(v24) == "table" and v24.UID then
						tbl20[v24.UID] = true
					end
				end

				return tbl20
			end

			local function fn77(arg, arg2)
				if not senaV4Config.AutoSell then
					return false, "toggle Auto Sell Pet udah OFF", "global"
				end

				if not fn32() then
					return false, "Auto Steal lagi megang kendali", "global"
				end
				local v24 = fn33(v21)
				local v25 = fn33(v22)

				if v24 then
					if not v25 then
						return false, "filter dropdown gak bisa dibaca", "global"
					end
				else
					return false, "filter dropdown gak bisa dibaca", "global"
				end

				if type(arg2) ~= "table" then
					return false, "status pet dipajang gak bisa diverifikasi", "global"
				end

				if arg2[arg.uid] then
					return false, "pet ini dipajang di plot", "pet"
				end

				if not fn34(arg.petName, arg.rarity, v24, v25) then
					return false, "pet ini udah gak match filter yang sekarang", "pet"
				end
				local v26 = (Save.Peek or Save.Get)()
				local inventory = v26 and v26.Inventory and v26.Inventory[arg.uid]
				if inventory == nil then
					return false, "pet ini udah gak ada di inventory", "pet"
				end
				local sellPetMaxRate = senaV4Config.SellPetMaxRate or 0
				if sellPetMaxRate > 0 and rateOf({Category = inventory.Category or inventory.AssetCategory, Scale = inventory.Scale or inventory.AssetScale or 1, Mutations = inventory.Mutations or {}}) > sellPetMaxRate then
					return false, "money/s pet ini di atas batas value", "pet"
				end

				if inventory.IsFavorite == true then
					return false, "pet ini di-favorite", "pet"
				end

				if inventory.InFuse == true then
					return false, "pet ini sedang di-fuse", "pet"
				end

				if table.find(v26.EquippedAssets or {}, arg.uid) ~= nil then
					return false, "pet ini sedang dipasang", "pet"
				end
				return true
			end

			while senaV4Config.AutoSell and fn2() do
				local ok2, result = pcall(function()
					if not fn32() then
						tbl19.status = senaV4TaskLadder.yieldLabel("auto_sell") or ""
						return
					end
					local v24 = fn33(v21)
					local v25 = fn33(v22)

					if v24 then
						if not v25 then
							warn("[AutoSell] Filter dropdown gak bisa dibaca - ronde ini di-SKIP, gak ada yang dijual. Kalau ini terus-terusan, matiin Auto Sell Pet dan lapor.")
							return
						end
					else
						warn("[AutoSell] Filter dropdown gak bisa dibaca - ronde ini di-SKIP, gak ada yang dijual. Kalau ini terus-terusan, matiin Auto Sell Pet dan lapor.")
						return
					end

					local v26 = (Save.Peek or Save.Get)()
					local inventory = v26 and v26.Inventory or {}
					local v27 = fn76()
					if not v27 then
						warn("[AutoSell] Status pet yang dipajang gak bisa diverifikasi - ronde ini di-SKIP, gak ada yang dijual.")
						return
					end
					local tbl20 = {}
					local n8 = 0

					if type(inventory) == "table" then
						for k, v28 in pairs(inventory) do
							n8 += 1

							if n8 % 250 == 0 then
								RunService.Heartbeat:Wait()
								if not senaV4Config.AutoSell then
									return
								end
							end

							if type(v28) == "table" then
								local flag9 = v27[k] == true
								local flag10 = v28.IsFavorite == true or v28["Jadikan Favorit"] == true or v28.Favorite == true
								local flag11 = table.find(v26.EquippedAssets or {}, k) ~= nil
								local flag12 = v28.InFuse == true
								local category = v28.Category or v28.id or v28.AssetCategory or v28.ItemId
								local v29 = category and Assets.Directory[category]
								local displayName = v29 and (v29.DisplayName or v29._id or v29.Name) or "Unknown"
								local rarity = v29 and v29.Rarity
								local displayName2 = rarity and (rarity.DisplayName or rarity._id or rarity.Name) or "Unknown"
								local v30 = fn34(displayName, displayName2, v24, v25)
								local sellPetMaxRate = senaV4Config.SellPetMaxRate or 0
								local v31 = if sellPetMaxRate > 0 then rateOf({Category = category, Scale = v28.Scale or v28.AssetScale or 1, Mutations = v28.Mutations or {}}) <= sellPetMaxRate else true

								if v30 and v31 then
									if flag10 then
									elseif flag9 then
									elseif flag11 then
									elseif flag12 then
									else
										table.insert(tbl20, {uid = k, petName = displayName, rarity = displayName2})
									end
								end
							end
						end
					end

					tbl19.petPending = #tbl20 > 0

					if #tbl20 > 0 then
						tbl19.petBusy = true
						tbl19.status = string.format("Selling %d pet%s", #tbl20, #tbl20 == 1 and "" or "s")

						for i, v28 in ipairs(tbl20) do
							v24, inventory, v27 = fn77(v28, (fn76()))

							if not v24 then
								warn("[AutoSell] Gak jual " .. tostring(v28.petName) .. " - " .. tostring(inventory))
								if v27 == "global" then
									break
								end
								continue
							end

							if not fn32() then
								break
							end
							local character = localPlayer2.Character
							local humanoid, v29, tbl21, v30 = character and character:FindFirstChildOfClass("Humanoid"), ipairs, {localPlayer2.Backpack, character}

							for k, v31 in v29(tbl21) do
								if v31 then
									for i2, child in ipairs(v31:GetChildren()) do
										if child:IsA("Tool") and child:GetAttribute("UID") == v28.uid then
											v30 = child
											break
										end
									end
								end

								if v30 then
									break
								end
							end

							if v30 then
								if not humanoid then
									continue
								end
							else
								continue
							end

							humanoid:EquipTool(v30)
							task.wait(0.2)
							if not fn32() then
								break
							end
							v29, tbl21, i = fn77(v28, (fn76()))

							if not v29 then
								warn("[AutoSell] Batal di detik terakhir, gak jual " .. tostring(v28.petName) .. " - " .. tostring(tbl21))
								if i == "global" then
									break
								end
								continue
							end

							Remotes.PetSatchel.SellPet:FireServer({v28.uid})
							task.wait(0.05)
						end
					end
				end)

				tbl19.petBusy = false

				if tbl19.status:find("^Selling") then
					tbl19.status = ""
				end

				if not ok2 then
					warn("Auto Sell Error:", result)
				end

				task.wait(1.5)
			end

			flag8 = false
		end)
	end

	local flag9 = false
	local flag10 = false

	local function fn76()
		if not senaV4Config.AutoSellEgg then
			return false
		end
		local v24 = fn33(v23)

		if v24 then
			if #v24 == 0 then
				return false
			elseif table.find(v24, "None") then
				return false
			end
		else
			return false
		end

		local ReplicatedStorage2 = game:GetService("ReplicatedStorage")

		local ok2, result = pcall(function()
			return require(ReplicatedStorage2.Shared.Save)
		end)

		if ok2 then
			if not result then
				return false
			end
		else
			return false
		end

		local v25 = (result.Peek or result.Get)()
		local eggInventory = v25 and v25.EggInventory
		if type(eggInventory) ~= "table" then
			return false
		end

		local ok3, result2 = pcall(function()
			return require(ReplicatedStorage2.Data.Assets)
		end)

		local directory = ok3 and result2 and result2.Directory
		if not directory then
			return false
		end

		for k, v26 in pairs(eggInventory) do
			local flag11 = type(v26) == "table" and directory[v26.AssetCategory]
			local displayName = flag11 and flag11.Rarity and (flag11.Rarity.DisplayName or flag11.Rarity._id)
			local sellEggMaxRate = senaV4Config.SellEggMaxRate or 0
			local v27 = if sellEggMaxRate > 0 then if type(v26) == "table" then rateOf({Category = v26.AssetCategory, Scale = v26.AssetScale or 1, Mutations = v26.Mutations or {}}) <= sellEggMaxRate else true else true
			if v26.Placement == nil and (v27 and fn35(displayName or "Unknown", v24)) then
				return true
			end
		end

		return false
	end

	genv.__SenaV4IsAutoSellEggBusy = function()
		return flag10 or fn76()
	end

	local tbl20 = {at = 0, value = false}

	local function fn77()
		local now = os.clock()
		if now - tbl20.at < 1 then
			return tbl20.value
		end
		tbl20.at = now
		local ok2, result = pcall(fn76)
		tbl20.value = ok2 and result == true
		return tbl20.value
	end

	senaV4TaskLadder.register("auto_sell", {wants = function()
		return senaV4Config.AutoSell == true and tbl19.petPending == true or senaV4Config.AutoSellEgg == true and fn77()
	end, active = function()
		return tbl19.petBusy == true or flag10 == true
	end, enabled = function()
		return senaV4Config.AutoSell == true or senaV4Config.AutoSellEgg == true
	end, status = function()
		if flag10 then
			return "Selling eggs"
		end
		return tbl19.status
	end})

	function tbl10.startAutoSellEggLoop()
		if flag9 then
			return
		end
		flag9 = true

		task.spawn(function()
			local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
			local directory = require(ReplicatedStorage2.Data.Assets).Directory
			local EggState2 = require(ReplicatedStorage2.Client.EggState)
			local Remotes = require(ReplicatedStorage2.Shared.Remotes)
			local Save = require(ReplicatedStorage2.Shared.Save)

			while senaV4Config.AutoSellEgg and fn2() do
				local v24 = fn33(v23)
				local v25 = (Save.Peek or Save.Get)()
				local eggInventory = v25 and v25.EggInventory

				if v24 and type(eggInventory) == "table" and fn32() then
					for k, v26 in pairs(eggInventory) do
						if senaV4Config.AutoSellEgg then
							if not fn32() then
								break
							end
						else
							break
						end

						local flag11 = type(v26) == "table" and directory[v26.AssetCategory]
						local displayName = flag11 and flag11.Rarity and (flag11.Rarity.DisplayName or flag11.Rarity._id)
						local sellEggMaxRate = senaV4Config.SellEggMaxRate or 0
						local v27 = if sellEggMaxRate > 0 then if type(v26) == "table" then rateOf({Category = v26.AssetCategory, Scale = v26.AssetScale or 1, Mutations = v26.Mutations or {}}) <= sellEggMaxRate else true else true

						if v26.Placement == nil and (v27 and fn35(displayName or "Unknown", v24)) then
							if not fn32() then
								break
							end
							flag10 = true

							if genv.__SenaV4TreadmillManager and genv.__SenaV4TreadmillManager.activeTreadmill ~= nil then
								genv.__SenaV4TreadmillManager:_cancelIdle(true)
								task.wait(0.25)
							end

							if EggState2.WearEggTool(k) then
								task.wait(0.2)
								if not fn32() then
									break
								end
								v26 = (Save.Peek or Save.Get)()
								local eggInventory2 = v26 and v26.EggInventory and v26.EggInventory[k]

								if eggInventory2 and eggInventory2.Placement == nil then
									Remotes.PetSatchel.SellPet:FireServer({k})
									task.wait(0.25)
								end
							end
						end
					end
				end

				flag10 = false
				task.wait(0.5)
			end

			flag10, flag9 = false, false
		end)
	end

	local tbl21 = {"None", "All"}

	pcall(function()
		local tbl22 = {}

		for k, v24 in pairs(require(game:GetService("ReplicatedStorage").Data.Assets).Directory) do
			if type(v24) == "table" and (v24.DisplayName or v24._id or v24.Name) then
				local displayName = v24.DisplayName or v24._id or v24.Name

				if not tbl22[displayName] then
					tbl22[displayName] = true
					table.insert(tbl21, displayName)
				end
			end
		end

		table.sort(tbl21, function(arg, arg2)
			if arg == "None" then
				return true
			end

			if arg2 == "None" then
				return false
			end

			if arg == "All" then
				return true
			end

			if arg2 == "All" then
				return false
			end
			return arg < arg2
		end)
	end)

	local v24 = fn67(tbl15)
	local v25 = fn67(tbl16)
	local v26 = fn68()
	fn73 = fn69((fn67(tbl21)))

	local function fn78(arg)
		senaV4Config.AutoSteal = arg == true

		if v13 then
			v13:setEnabled(senaV4Config.AutoSteal)
		end

		if type(genv.__SenaV4SetStealDeclutter) == "function" then
			pcall(genv.__SenaV4SetStealDeclutter, senaV4Config.AutoSteal)
		end
	end

	local function fn79(arg)
		senaV4Config.StealHoldSeconds = math.clamp(math.floor((tonumber(arg) or 5) + 0.5), 1, 10)
	end

	local function fn80(arg)
		senaV4Config.GodMode = arg == true

		if v16 then
			v16:setEnabled(senaV4Config.GodMode)
		end
	end

	local function fn81()
		return genv.__SenaV4TreadmillManager
	end

	local function fn82(arg)
		senaV4Config.AutoTreadmillIdle = arg == true
		local v27 = fn81()

		if v27 then
			v27:setIdleFarm(senaV4Config.AutoTreadmillIdle and not senaV4Config.AntiTreadmill)
		end
	end

	local function fn83(arg)
		senaV4Config.AntiTreadmill = arg == true
		local v27 = fn81()

		if senaV4Config.AntiTreadmill then
			if v27 then
				v27:setIdleFarm(false)
			end

			tbl13.startAntiTreadmillLoop()
		elseif v27 then
			v27:setIdleFarm(senaV4Config.AutoTreadmillIdle)
		end
	end

	local function fn84(arg)
		senaV4Config.HopNoMatch = arg == true

		if senaV4Config.HopNoMatch then
			tbl13.startHopLoop()
		end
	end

	local function fn85(arg)
		senaV4Config.PrivateServerMax = tostring((if type(arg) == "table" then arg[1] else arg) or "2")
	end

	local function fn86(arg)
		senaV4Config.PrivateServerAuto = arg == true

		if senaV4Config.PrivateServerAuto then
			tbl13.startPrivateAutoHop()
		end
	end

	local function fn87(arg)
		senaV4Config.HopCooldown = math.max(1, math.floor(tonumber(arg) or 5))
	end

	local function fn88(arg)
		senaV4Config.AutoTreadmillUpgrade = arg == true
		local v27 = fn81()

		if v27 then
			v27:setAutoUpgrade(senaV4Config.AutoTreadmillUpgrade)
		end
	end

	local function fn89(arg)
		local str4 = type(arg) == "string" and arg or ""
		local str5 = str4:lower()
		local flag11 = str5:find("zig") ~= nil
		local stealMode = (str4:find("Fly") or str4:find("High") or flag11) and "Fly" or "Instant"
		local flyAerial = stealMode == "Fly" and not flag11 and (str4:find("%(Fly%)") ~= nil or str5:find("aerial") ~= nil)
		local flyZigzag = flag11 and stealMode == "Fly"
		senaV4Config.StealMode = stealMode
		senaV4Config.FlyAerial = flyAerial
		senaV4Config.FlyZigzag = flyZigzag

		if v13 and v13.captureObjectiveEnabled then
			v13._modeBeforeCapture = {stealMode, flyAerial, flyZigzag}
		elseif v13 then
			v13:setStealMode(stealMode, flyAerial, flyZigzag)
		end
	end

	local function fn90(arg)
		local n8 = math.clamp(math.floor((tonumber(arg) or 600) + 0.5), 500, 1000)
		local n9 = math.floor(n8 / 10 + 0.5)
		fn37(n9)

		if v13 then
			v13:setSpeed(n9)
		end
	end

	local function fn91(arg, arg2, arg3)
		local v27 = fn67(arg3)

		if arg == "names" then
			senaV4Config.StealNamesFilter = v27
		elseif arg == "areas" then
			senaV4Config.StealAreas = v27
		elseif arg == "rarities" then
			senaV4Config.StealRarities = v27
		end

		if v13 then
			v13:setFilter(arg, v27)
			v13:setFilterEnabled(arg2, #v27 > 0)
		end
	end

	local function fn92(arg)
		senaV4Config:applyStealValueInput(arg)

		if v13 then
			v13:setMinValuePerSec(senaV4Config.StealMinValue or 0)
		end
	end

	local function fn93(arg)
		local v27 = fn67(arg)
		senaV4Config.StealMutations = v27

		if v13 then
			v13:setFilter("mutations", v27)
			v13:setFilterEnabled("mutation", #v27 > 0)
		end
	end

	local function fn94(arg)
		local stealMinWeight = tonumber((tostring(arg or ""):gsub("[^%d%.]", ""))) or 0
		senaV4Config.StealMinWeight = stealMinWeight

		if v13 then
			v13:setMinWeightKg(stealMinWeight)
		end
	end

	local function fn95(arg)
		senaV4Config.StealPriority = tostring(arg or "Rarity")

		if v13 then
			v13:setHighestValueFirst(senaV4Config.StealPriority == "Highest Value")
			v13:setHeaviestFirst(senaV4Config.StealPriority == "Heaviest")
		end
	end

	local function fn96(arg)
		senaV4Config.EggESP = arg == true

		if v13 then
			v13:setEggEsp(senaV4Config.EggESP)
		end
	end

	local function fn97(arg)
		local v27 = fn67(arg)
		senaV4Config.EspDetails = v27
		if not v13 then
			return
		end
		local tbl22 = {}

		for i, v28 in ipairs(v27) do
			tbl22[v28] = true
		end

		v13:setEspOption("name", tbl22.Name == true)
		v13:setEspOption("rarity", tbl22.Rarity == true)
		v13:setEspOption("value", tbl22.Value == true)
		v13:setEspOption("kg", tbl22.Weight == true)
		v13:setEspOption("mutation", tbl22.Mutation == true)
		v13:setEspOption("placed", tbl22["Placed Eggs"] == true)
		v13:setEspOption("icon", tbl22.Icon == true)
	end

	function tbl10.applyEspMinRarity(arg)
		local flag11 = type(arg) == "table" and arg[1] or arg
		senaV4Config.EspMinRarity = type(flag11) == "string" and flag11 ~= "Any" and flag11 or nil

		if v13 then
			v13:setEspMinRank(senaV4Config.EspMinRarity and v6.rarityRank(senaV4Config.EspMinRarity) or 0)
		end
	end

	function tbl10.applyEspMinValue(arg)
		senaV4Config.EspMinValue = fn61(arg) or 0

		if v13 then
			v13:setEspMinValue(senaV4Config.EspMinValue)
		end
	end

	local function fn98(arg)
		senaV4Config.ScrambleTradeInBanners = fn67(arg)
	end

	local function fn99(arg)
		tbl13.setBackpackRates(arg == true)
	end

	local function fn100(arg)
		senaV4Config.AntiGuardKnockback = arg == true
		local senaV4AntiGuard = genv.__SenaV4AntiGuard

		if senaV4AntiGuard and type(senaV4AntiGuard.setEnabled) == "function" then
			pcall(senaV4AntiGuard.setEnabled, senaV4AntiGuard, senaV4Config.AntiGuardKnockback)
		end
	end

	local function fn101(arg)
		senaV4Config.AutoFavorite = arg == true
	end

	local function fn102(arg)
		senaV4Config.FavMode = arg == "Species" and "Species" or "Rarity"
	end

	local function fn103(arg)
		senaV4Config.FavRarities = fn67(arg)
	end

	local function fn104(arg)
		senaV4Config.FavSpecies = fn67(arg)
	end

	local function fn105(arg)
		senaV4Config.AutoEquipBest = arg == true
	end

	local function fn106(arg)
		senaV4Config.AutoClaimOffline = arg == true
	end

	local function fn107(arg)
		senaV4Config.AutoBaseUpgrade = arg == true
	end

	local function fn108(arg)
		senaV4Config.AutoClaimAlmanac = arg == true
	end

	local function fn109(arg)
		senaV4Config.AutoFusePets = arg == true
	end

	local function fn110(arg)
		senaV4Config.FuseSelectedOnly = arg == "Selected Species"
	end

	local function fn111(arg)
		senaV4Config.FuseRarities = fn67(arg)
	end

	local function fn112(arg)
		senaV4Config.FuseSpecies = fn67(arg)
	end

	local function fn113(arg)
		local senaV4Roaming = genv.__SenaV4Roaming

		if senaV4Roaming and type(senaV4Roaming.setNoclip) == "function" then
			pcall(senaV4Roaming.setNoclip, arg == true)
		end
	end

	local function fn114(arg)
		local senaV4Roaming = genv.__SenaV4Roaming

		if senaV4Roaming and type(senaV4Roaming.setBottingMode) == "function" then
			pcall(senaV4Roaming.setBottingMode, arg == true)
		end
	end

	local function fn115(arg)
		senaV4Config.AntiCutscene = arg == true
	end

	local function runOnce(arg, arg2, arg3)
		local v27 = senaV4Config[arg]
		senaV4Config[arg] = true
		task.spawn(arg2)

		task.delay(2.4, function()
			local n8 = os.clock() + 30

			while senaV4Config.IsPlacing and os.clock() < n8 do
				task.wait(0.25)
			end

			senaV4Config[arg] = v27

			if arg3 then
				pcall(arg3)
			end
		end)
	end

	tbl10.runOnce = runOnce

	local function fn116(arg)
		senaV4Config.ScrambleAutoBuy = arg == true
	end

	local function fn117(arg)
		senaV4Config.ScrambleBuyList = fn67(arg)
	end

	local function fn118(arg)
		senaV4Config.AutoPlace = arg == true

		if senaV4Config.AutoPlace then
			task.spawn(tbl10.AutoPlaceLoop)
		end
	end

	local function fn119(arg)
		senaV4Config.AutoHatch = arg == true

		if senaV4Config.AutoHatch then
			task.spawn(tbl10.AutoHatchLoop)
		end
	end

	local function fn120(arg)
		senaV4Config.AutoMutation = arg == true

		if senaV4Config.AutoMutation then
			task.spawn(tbl10.AutoMutationLoop)
		end
	end

	local function fn121(arg)
		senaV4Config.AutoRingEvent = arg == true

		if senaV4Config.AutoRingEvent then
			tbl10.RingEventLoop()
		end
	end

	local function fn122(arg)
		senaV4Config.MutationChoice = (arg == "Fractured" or arg == "Enchanted") and arg or "Scrambled"
	end

	local function fn123(arg)
		senaV4Config.MutationSpecies = fn67(arg)
	end

	local function fn124(arg)
		senaV4Config.MutationRarities = fn67(arg)
	end

	local function fn125(arg)
		senaV4Config.MutationMinRate = fn75(arg)
	end

	local function fn126(arg)
		senaV4Config.MutationRetry = arg == true
	end

	local function fn127(arg)
		senaV4Config.AutoSell = arg == true

		if senaV4Config.AutoSell then
			tbl10.startAutoSellLoop()
		end
	end

	local function fn128(arg)
		senaV4Config.AutoSellEgg = arg == true

		if senaV4Config.AutoSellEgg then
			tbl10.startAutoSellEggLoop()
		end
	end

	local function fn129(arg)
		senaV4Config.SellPetMaxRate = fn75(arg)
	end

	local function fn130(arg)
		senaV4Config.SellEggMaxRate = fn75(arg)
	end

	local flag11 = false

	local function fn131(arg)
		local flag12 = senaV4Config.StartupBoost == true
		senaV4Config.StartupBoost = arg == true

		if not senaV4Config.StartupBoost then
			flag11 = false

			if flag12 or senaV4DecomBoostUndo.snapshot then
				task.spawn(senaV4DecomBoostUndo.revert)
			end

			return
		end

		if senaV4Config.StartupBoost and not flag11 then
			flag11 = true

			task.spawn(function()
				task.wait(1.5)

				if fn2() and senaV4Config.StartupBoost then
					fn46()
				end

				task.wait(4)

				if fn2() and senaV4Config.StartupBoost then
					fn46()
				end
			end)
		end
	end

	local function fn132(arg)
		if arg == true then
			task.spawn(fn58)
		end
	end

	local function fn133(arg)
		local senaV4SetCapFps = genv.__SenaV4SetCapFps

		if type(senaV4SetCapFps) == "function" then
			senaV4SetCapFps(arg == true and 1000 or 60)
		end
	end

	local function fn134()
		return genv.__SenaV4MovementExtras
	end

	local function fn135(arg)
		senaV4Config.FlyForCapture = arg == true
		local v27 = fn134()

		if v27 then
			v27:setFlyForCapture(senaV4Config.FlyForCapture)
		end
	end

	local function fn136(arg)
		senaV4Config.InstantGrab = arg == true
		local v27 = fn134()

		if v27 then
			v27:setInstantGrab(senaV4Config.InstantGrab)
		end
	end

	local function fn137(arg)
		genv.__SenaV4AdminBoost = arg == true

		if v13 then
			v13:setSpeed(senaV4Config.TweenSpeedMultiplier or 60)
		end

		genv.__SenaV4AdminBoostSpeedGen = (genv.__SenaV4AdminBoostSpeedGen or 0) + 1
		local senaV4AdminBoostSpeedGen = genv.__SenaV4AdminBoostSpeedGen

		if arg == true then
			task.spawn(function()
				local RunService2 = game:GetService("RunService")
				local walkSpeed
				local v27

				while genv.__SenaV4AdminBoostSpeedGen == senaV4AdminBoostSpeedGen and fn2() do
					local character = localPlayer.Character
					local humanoid = character and character:FindFirstChildOfClass("Humanoid")

					if humanoid then
						local walkSpeed2 = humanoid.WalkSpeed

						if walkSpeed == nil or v27 == nil or math.abs(walkSpeed2 - v27) > 0.5 then
							walkSpeed = walkSpeed2 > 900 and walkSpeed2 / 10 or walkSpeed2
						end

						if walkSpeed and walkSpeed > 0 then
							local walkSpeed3 = walkSpeed * 10
							humanoid.WalkSpeed = walkSpeed3
							v27 = walkSpeed3
						end
					else
						walkSpeed = nil
						v27 = nil
					end

					RunService2.Heartbeat:Wait()
				end

				local character = localPlayer.Character
				local humanoid = character and character:FindFirstChildOfClass("Humanoid")

				if humanoid and walkSpeed and (v27 and math.abs(humanoid.WalkSpeed - v27) <= 0.5) then
					pcall(function()
						humanoid.WalkSpeed = walkSpeed
					end)
				end
			end)
		end
	end

	local function fn138(arg)
		senaV4Config.AutoStealCapture = arg == true

		if v13 then
			v13:setCaptureObjective(senaV4Config.AutoStealCapture)
		end
	end

	local function fn139(arg)
		senaV4Config.InfiniteJump = arg == true
		local v27 = fn134()

		if v27 then
			v27:setInfiniteJump(senaV4Config.InfiniteJump)
		end
	end

	local function fn140(arg)
		senaV4Config.AntiHitGuard = arg == true
		local senaV4AntiHitGuard = genv.__SenaV4AntiHitGuard

		if senaV4AntiHitGuard then
			senaV4AntiHitGuard:setEnabled(senaV4Config.AntiHitGuard)
		end
	end

	local function fn141(arg)
		senaV4Config.AntiAFK = arg == true
		genv.__SenaV4AntiAfkEnabled = senaV4Config.AntiAFK

		if type(genv.__SenaV4SetAntiAfkEnabled) == "function" then
			genv.__SenaV4SetAntiAfkEnabled(senaV4Config.AntiAFK)
		end
	end

	local function fn142(arg)
		senaV4Config.AutoReconnect = arg == true
		v19.autoReconnect = senaV4Config.AutoReconnect

		if getgenv then
			getgenv().SNE_AutoReconnect = senaV4Config.AutoReconnect
		end
	end

	local function fn143(arg)
		senaV4Config.AutoExecute = arg == true
		v19.autoExecute = senaV4Config.AutoExecute

		if getgenv then
			getgenv().SNE_AutoExecute = senaV4Config.AutoExecute
		end

		if arg then
			pcall(fn62)
		else
			pcall(fn63)
		end
	end

	local v27 = (function()
		local senaV4IdentitySetter2 = genv.__SenaV4IdentitySetter or type(setthreadidentity) == "function" and setthreadidentity or type(set_thread_identity) == "function" and set_thread_identity or type(setidentity) == "function" and setidentity or type(syn) == "table" and type(syn.set_thread_identity) == "function" and syn.set_thread_identity
		local senaV4UICapabilityIdentity = genv.__SenaV4UICapabilityIdentity or 8

		return function()
			if type(senaV4IdentitySetter2) == "function" then
				pcall(senaV4IdentitySetter2, senaV4UICapabilityIdentity)
			end
		end
	end)()

	local flag12 = true

	local function fn144(arg)
		return function(arg2)
			if type(v27) == "function" then
				v27()
			end

			if flag12 then
				return
			end

			if type(arg) == "function" then
				arg(arg2)
			end
		end
	end

	local senaV4PlayerSteal = genv.__SenaV4PlayerSteal

	local function fn145(arg)
		senaV4Config.StealPlayers = arg == true

		if senaV4PlayerSteal then
			senaV4PlayerSteal:setEnabled(senaV4Config.StealPlayers)
		end

		if senaV4Config.StealPlayers and not senaV4Config.GodMode then
			fn80(true)

			if controls.godMode then
				pcall(function()
					controls.godMode:Set(true)
				end)
			end
		end
	end

	local function fn146(arg)
		senaV4Config.StealPlayerRarities = fn67(arg)
	end

	local function fn147(arg)
		local str4 = string.lower(tostring(arg or "")):gsub("[%s,]", "")
		if str4 == "" then
			return 0
		end
		local v28, v29 = string.match(str4, "^([%d]+%.?[%d]*)([kmb]?)$")
		local num = tonumber(v28)
		if not num then
			return 0
		end

		if v29 == "k" then
			return num * 1000
		end

		if v29 == "m" then
			return num * 1000000
		end

		if v29 == "b" then
			return num * 1000000000
		end
		return num
	end

	local function fn148(arg)
		senaV4Config.StealPlayerMinValue = fn147(arg)
	end

	local function fn149(arg)
		senaV4Config.AutoIndex = arg == true

		if v13 then
			v13:setIndexObjective(senaV4Config.AutoIndex)
		end
	end

	local function fn150(arg)
		senaV4Config.WebhookEnabled = arg == true
	end

	local function fn151(arg)
		senaV4Config.WebhookURL = type(arg) == "string" and arg:gsub("^%s+", ""):gsub("%s+$", "") or ""
	end

	local function fn152(arg)
		senaV4Config.WebhookRarities = fn67(arg)
	end

	local function fn153(arg)
		senaV4Config.WebhookMinValue = fn147(arg)
	end

	local tbl22 = {"Set", "SetValue", "LoadValue", "ResetValue", "SetContent", "SetTitle", "SetOptions", "Update", "Refresh", "Lock", "Unlock", "SetVisible", "SetStatus", "GetValue", "SetSubTitle", "SetBadge"}

	local function fn154(arg)
		if type(arg) ~= "table" then
			return arg
		end

		if rawget(arg, "__senaElevated") then
			return arg
		end

		for i, v28 in ipairs(tbl22) do
			local value = rawget(arg, v28)

			if type(value) == "function" then
				rawset(arg, v28, function(...)
					v27()
					return value(...)
				end)
			end
		end

		rawset(arg, "__senaElevated", true)
		return arg
	end

	local tbl23 = {"AddToggle", "AddSlider", "AddDropdown", "AddInput", "AddButton", "AddParagraph", "AddKeybind", "AddColorPicker", "AddActionList", "AddPriorityList", "AddLiveChat", "AddSupportCard", "AddSubSection", "AddSection", "AddTab", "AddForum"}

	local function fn155(arg)
		if type(arg) ~= "table" then
			return arg
		end
		fn154(arg)
		if rawget(arg, "__senaFactoryGuarded") then
			return arg
		end

		for i, v28 in ipairs(tbl23) do
			local value = rawget(arg, v28)

			if type(value) == "function" then
				rawset(arg, v28, function(...)
					v27()
					local v29 = table.pack(value(...))

					if v29.n > 0 then
						v29[1] = fn155(v29[1])
					end

					return table.unpack(v29, 1, v29.n)
				end)
			end
		end

		rawset(arg, "__senaFactoryGuarded", true)
		return arg
	end

	v27()
	local flag13 = type(flag6.ApplyIcon) == "function"
	local v28 = flag6:Window({Title = "Sena 6.2 |", Footer = "Steal An Egg", Folder = "SenaSAEv4", Version = 1, Color = Color3.fromRGB(232, 232, 238), Image = "https://senahub.xyz/api/visual/sena_bg.jpg", KeyGate = false})
	fn155(v28)
	local tbl24 = {}
	local tbl25 = {"Respawn Point"}
	local senaV4Roaming = genv.__SenaV4Roaming

	if senaV4Roaming and type(senaV4Roaming.waypointList) == "function" then
		local ok2, result = pcall(senaV4Roaming.waypointList)
		tbl25 = if ok2 then if type(result) == "table" then if #result > 0 then result else tbl25 else tbl25 else tbl25
	end

	local v29 = tbl25[1]
	local tbl26 = {}

	do
		local senaV4ScrambleRuntime = genv.__SenaV4ScrambleRuntime

		if senaV4ScrambleRuntime and type(senaV4ScrambleRuntime.snapshot) == "function" then
			pcall(function()
				local v30 = senaV4ScrambleRuntime.snapshot()

				if v30 and type(v30.Shop) == "table" then
					for k, v31 in pairs(v30.Shop) do
						if v31 and v31.Label then
							tbl26[#tbl26 + 1] = tostring(v31.Label)
						end
					end
				end
			end)
		end
	end

	tbl24.iconCache = {}

	tbl24.gameIcon = function(arg, ...)
		local tbl27 = {...}
		local str4 = arg .. "/" .. table.concat(tbl27, "/")
		local v30 = tbl24.iconCache[str4]
		if v30 ~= nil then
			return v30 or nil
		end

		local ok2, result = pcall(function()
			local module = require(ReplicatedStorage:FindFirstChild("Data") and ReplicatedStorage.Data:FindFirstChild(arg) or ReplicatedStorage:FindFirstChild(arg, true))

			for i, v31 in ipairs(tbl27) do
				module = module[v31]
			end

			return module
		end)

		local pos = ok2 and type(result) == "string" and result:find("rbxassetid://") and result or false
		tbl24.iconCache[str4] = pos
		return pos or nil
	end

	tbl24.section = function(arg, arg2, arg3)
		return arg:AddSection({Title = arg2, Icon = arg3})
	end

	if v28.SetHeaderChips then
		task.spawn(function()
			local Save

			pcall(function()
				Save = require(ReplicatedStorage.Shared.Save)
			end)

			local dataPing

			pcall(function()
				dataPing = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]
			end)

			local now = os.clock()
			local Assets = tbl24.gameIcon("Assets", "Directory", "Dog", "Egg", "Icon")
			local Currency = tbl24.gameIcon("Currency", "Directory", "BossTokens", "Icon")
			local Currency2 = tbl24.gameIcon("Currency", "Directory", "SakuraCrystals", "Icon")

			local function fn156(arg)
				local n8 = tonumber(arg) or 0

				for i, v30 in ipairs({{1000000000000000, "Qa"}, {1000000000000, "T"}, {1000000000, "B"}, {1000000, "M"}, {1000, "K"}}) do
					if n8 >= v30[1] then
						return ("%.2f%s"):format(n8 / v30[1], v30[2]):gsub("%.?0+([A-Za-z])", "%1")
					end
				end

				return tostring(math.floor(n8))
			end

			while fn2() do
				pcall(function()
					local value = Save and select(2, pcall(Save.Peek))
					local tbl27 = type(value) == "table" and value or {}
					local n8 = dataPing and math.floor(dataPing:GetValue() + 0.5) or 0
					local n9 = math.floor(os.clock() - now)
					local senaV4EggRuntime = genv.__SenaV4EggRuntime
					local senaV4PlayerSteal2 = genv.__SenaV4PlayerSteal
					local tbl28 = {{Icon = "clock", Text = ("%d:%02d:%02d"):format(n9 // 3600, n9 % 3600 // 60, n9 % 60)}, {Icon = Assets, Text = fn156((senaV4EggRuntime and senaV4EggRuntime.stats and tonumber(senaV4EggRuntime.stats.delivered) or 0) + (senaV4PlayerSteal2 and tonumber(senaV4PlayerSteal2.taken) or 0)) .. " stolen"}, {Icon = Currency, Text = fn156(tbl27.BossTokens)}}
					local num = tonumber(tbl27.SakuraCrystals)

					if num and num > 0 then
						senaV4EggRuntime = #tbl28 + 1
						n9 = {Icon = Currency2}
						n9.Text, tbl28[senaV4EggRuntime] = fn156(tbl27.SakuraCrystals), n9
					end

					local n10 = #tbl28 + 1
					local tbl29 = {Icon = "wifi", Text = n8 .. " ms"}
					tbl29.IconColor, tbl28[n10] = n8 < 150 and Color3.fromRGB(74, 222, 128) or (n8 < 300 and Color3.fromRGB(245, 196, 81) or Color3.fromRGB(248, 113, 113)), tbl29
					v28:SetHeaderChips(tbl28)
				end)

				task.wait(1.5)
			end
		end)
	end

	v28:AddTab({Name = "Donate", Icon = "donator", LayoutOrder = -1, StartActive = false, Gate = false}):AddSection("Support Sena", true):AddSupportCard({})
	local v30 = v28:AddTab({Name = "Home", Icon = "home", LayoutOrder = 1})
	local v31 = v28:AddTab({Name = "Windows", Icon = "app-window", LayoutOrder = 2})
	local v32 = v28:AddTab({Name = "Steal", Icon = "hand", LayoutOrder = 3})
	local v33 = v28:AddTab({Name = "Eggs & Plot", Icon = "egg", LayoutOrder = 4})
	local v34 = v28:AddTab({Name = "Pets", Icon = "sparkles", LayoutOrder = 5})
	local v35 = v28:AddTab({Name = "Events", Icon = "flame", LayoutOrder = 6})
	local v36 = v28:AddTab({Name = "Farm", Icon = "activity", LayoutOrder = 7})
	local v37 = v28:AddTab({Name = "Server", Icon = "server", LayoutOrder = 8})
	tbl24.privateTab = v37
	local v38 = v28:AddTab({Name = "Settings", Icon = "settings", LayoutOrder = 9})
	tbl24.autoStealCapture = tbl24.section(v35, "Capture The Egg", tbl24.gameIcon("CaptureTheEgg", "BroadcastIconImage")):AddToggle({Title = "Auto Steal Capture", Content = "For the Capture The Egg event. Steals the event egg the Low Speed User way, then holds it high up so your time keeps going. Re-steals it if you lose it.", Default = false, Callback = fn144(fn138)})
	local v39 = tbl24.section(v35, "Movement", tbl24.gameIcon("Gears", "Directory", "GravityDisruptor", "Icon"))
	tbl24.adminBoost = v39:AddToggle({Title = "Admin Abuse Boost", Content = "Only works during Admin Abuse: Auto Steal goes straight to each egg and straight home, at full speed. Do not use it when there is no Admin Abuse.", Default = false, Callback = fn144(fn137)})
	tbl24.flyForCapture = v39:AddToggle({Title = "Fly For Capture", Content = "For the Capture The Egg event. After you pick up an egg, you fly up and stay still in the air so nobody can take it.", Default = false, Callback = fn144(fn135)})
	tbl24.instantGrab = v39:AddToggle({Title = "Instant Grab", Content = "Picking up an egg only needs a quick tap instead of a long hold.", Default = false, Callback = fn144(fn136)})
	tbl24.infiniteJump = v39:AddToggle({Title = "Infinite Jump", Content = "Jump again in mid-air, as often as you like.", Default = false, Callback = fn144(fn139)})
	tbl24.noclip = v39:AddToggle({Title = "Noclip", Content = "Walk through walls and doors.", Default = false, Callback = fn144(fn113)})
	tbl24.autoRingEvent = tbl24.section(v35, "Ring Event", tbl24.gameIcon("FallenPowerUp", "Kinds", "x2Rings", "Icon")):AddToggle({Title = "Auto Ring Event", Content = "Starts at the safe zone, then glides Forest -> Angels & Demons -> back to Forest on a loop. Turn off Auto Steal while using this.", Default = false, Callback = fn144(fn121)})
	local v40 = tbl24.section(v32, "Auto Steal", tbl24.gameIcon("Assets", "Directory", "Dog", "Egg", "Icon"))
	tbl24.autoSteal = v40:AddToggle({Title = "Auto Steal", Content = "Steals eggs that match your filters and brings them home.", Default = false, Callback = fn144(fn78)})

	v40:AddButton({Title = "Open Hop UI", Content = "Opens the Rare Egg Hop panel. Pick Divine, Eternal or Secret, and it hops to fresh servers until one is still in the field.", Callback = fn144(function()
		local hopHunt = tbl13.hopHunt

		if hopHunt then
			task.spawn(function()
				pcall(hopHunt.open)
			end)
		end
	end)})

	tbl24.helpFriend = v40:AddToggle({Title = "Help Friend", Content = "Instead of banking a stolen egg, drops it just before the safe zone line so a friend can pick it up.", Default = false, Callback = fn144(function(arg)
		senaV4Config.HelpFriend = arg == true
	end)})

	tbl24.godMode = v40:AddToggle({Title = "Aura Bat", Content = "", Default = false, Callback = fn144(fn80)})

	tbl24.stealMode = v40:AddDropdown({Title = "Steal Mode", Content = "If you have good speed better use High Speed User, but if you are newbie, use Instant Steal", Options = {"Instant Steal (Recommended)", "High Speed User Normal", "High Speed User (Fly)", "Zig-Zag High Speed User"}, MaxVisible = 4, Default = "Instant Steal (Recommended)", Multi = false, Callback = fn144(function(arg)
		fn89(arg)

		if type(senaPanels.syncStealMode) == "function" then
			senaPanels.syncStealMode()
		end
	end)})

	function senaPanels.getStealMode()
		local value = tbl24.stealMode and tbl24.stealMode.Value
		return if type(value) == "table" then value[1] else value
	end

	function senaPanels.setStealMode(arg)
		if tbl24.stealMode then
			tbl24.stealMode:Set(arg)
		end
	end

	local v41 = v40:AddParagraph({Title = "Speed Advice", Content = "Reading your speed..."})

	task.spawn(function()
		while fn2() do
			if v13 and type(v13.lowSpeedStatus) == "function" then
				pcall(function()
					local v42 = v13:lowSpeedStatus()
					local str4 = v42.safe == v42.fast and tostring(v42.fast) or v42.safe .. "\226\128\147" .. v42.fast
					local str5 = ("Current Speed: %s (WS %d)\nRecommended Instant Steal Multiplier: %s  \194\183  yours: %d"):format(v42.speedText, v42.walkSpeed, str4, v42.level)
					local advice = v42.advice

					if advice then
						str5 ..= ("\nSteals keep failing (%d of the last %d) - lower it to %d."):format(advice.fails, advice.total, advice.to)

						if advice.fresh then
							advice.fresh = false
							flag6:Notify({Title = "Low Speed User", Content = ("Steals keep failing at %d - lower the Low Speed Multiplier to %d."):format(advice.from, advice.to), Duration = 6})
						end
					else
						str5 = if v42.level > v42.fast then str5 .. "\nAbove the recommendation - lower it if steals start failing." else str5
					end

					v41:SetContent(str5)
				end)
			end

			task.wait(2)
		end
	end)

	tbl24.stealHold = v40:AddSlider({Title = "Instant Steal Multiplier", Content = "For Instant Steal mode. Higher = faster grab (shorter hold), lower = safer (longer). Raise it if your account speed is high; lower it if your speed is low.", Min = 1, Max = 10, Default = 5, Increment = 1, Callback = fn144(fn79)})

	tbl24.lowSpeedBoost = v40:AddToggle({Title = "Boost For Instant Steal", Content = "Faster steals for Instant Steal on every area except Forest (about 6 s per egg). Keep it on when you use Instant Steal.", Default = true, Locked2 = false, Callback = fn144(function(arg)
		senaV4Config.LowSpeedBoost = arg == true
	end)})

	local v42 = tbl24.section(v32, "Egg Filter", tbl24.gameIcon("Assets", "Directory", "Unicorn", "Egg", "Icon"))
	v42:AddSubSection("Egg")

	tbl24.names = v42:AddDropdown({Title = "Filter By Egg Name", Content = "Only steal these eggs. Leave empty for any egg.", Options = v24, Multi = true, Default = {}, Callback = fn144(function(arg)
		fn91("names", "name", arg)
	end)})

	tbl24.rarities = v42:AddDropdown({Title = "Filter By Rarity", Content = "Only steal these rarities. Leave empty for any rarity.", Options = v26, Multi = true, Default = {}, Callback = fn144(function(arg)
		fn91("rarities", "rarity", arg)
	end)})

	v42:AddSubSection("Area & Value")

	tbl24.areas = v42:AddDropdown({Title = "Select Area", Content = "Only steal from these areas. Leave empty for every area.", Options = v25, Multi = true, Default = {}, Callback = fn144(function(arg)
		fn91("areas", "area", arg)
	end)})

	tbl24.value = v42:AddInput({Title = "Steal By Value", Content = "Minimum money per second. Supports k, m and b.", Placeholder = "e.g. 500k, 2m, 1b", Default = "", Callback = fn144(fn92)})
	tbl24.mutations = v42:AddDropdown({Title = "Filter By Mutation", Content = "Only steal eggs carrying one of these mutations. Leave empty for any egg.", Options = tbl14, Multi = true, Default = {}, Callback = fn144(fn93)})
	tbl24.weight = v42:AddInput({Title = "Steal By Weight", Content = "Minimum egg weight in kilograms. 0 accepts any weight.", Placeholder = "e.g. 12000", Default = "", Callback = fn144(fn94)})
	tbl24.priority = v42:AddDropdown({Title = "Steal Priority", Content = "Which egg to go for first when more than one passes the filters.", Options = {"Rarity", "Highest Value", "Heaviest"}, Default = "Rarity", Callback = fn144(fn95)})
	tbl24.autoIndex = v42:AddToggle({Title = "Auto Index", Content = "Also steal eggs whose pet is still missing from your Pet Index, in any area, on top of the filters above. An egg you already hold counts as covered until it hatches.", Default = false, Callback = fn144(fn149)})
	local v43 = tbl24.section(v32, "Egg ESP", tbl24.gameIcon("Assets", "Directory", "Kitsune", "Egg", "Icon"))
	tbl24.eggEsp = v43:AddToggle({Title = "Egg ESP", Content = "Draws a label over every egg on the field so you can read it from across the map.", Default = false, Callback = fn144(fn96)})
	tbl24.espDetails = v43:AddDropdown({Title = "ESP Details", Content = "What each label shows. Placed Eggs also labels the eggs on your plot, Icon adds the animal picture to those labels.", Options = {"Name", "Rarity", "Value", "Weight", "Mutation", "Placed Eggs", "Icon"}, Multi = true, Default = {"Name", "Rarity", "Value", "Icon"}, Callback = fn144(fn97)})

	tbl24.espMinRarity = v43:AddDropdown({Title = "ESP Min Rarity", Content = "Only label eggs of this rarity or rarer. Any labels every egg.", Options = (function()
		local tbl27 = {"Any"}

		for i, v44 in ipairs(v26) do
			tbl27[#tbl27 + 1] = v44
		end

		return tbl27
	end)(), Multi = false, Default = "Any", Callback = fn144(tbl10.applyEspMinRarity)})

	tbl24.espMinValue = v43:AddInput({Title = "ESP Min Value", Content = "Only label eggs making at least this much per second. Supports k, m and b.", Placeholder = "e.g. 500k, 2m, 1b", Default = "", Callback = fn144(tbl10.applyEspMinValue)})
	tbl24.backpackRates = v43:AddToggle({Title = "Backpack Value/s", Content = "Shows how much money per second each egg in your backpack makes, right on its slot.", Default = false, Callback = fn144(fn99)})
	local v44 = tbl24.section(v32, "Steal Webhook", "bell")
	tbl24.webhookEnabled = v44:AddToggle({Title = "Steal Webhook", Content = "Posts a Discord embed the moment a stolen egg is banked, with its rarity, size, weight and cash per second.", Default = false, Callback = fn144(fn150)})
	tbl24.webhookUrl = v44:AddInput({Title = "Webhook URL", Content = "Paste the Discord webhook URL for the channel you want.", Placeholder = "https://discord.com/api/webhooks/...", Default = "", Callback = fn144(fn151)})

	tbl24.webhookDisconnect = v44:AddToggle({Title = "Disconnect Alert", Content = "Posts to the same webhook when this account gets disconnected or kicked, with the reason.", Default = false, Callback = fn144(function(arg)
		senaV4Config.WebhookDisconnect = arg == true
	end)})

	v44:AddSubSection("Filter")
	tbl24.webhookRarities = v44:AddDropdown({Title = "Notify Rarities", Content = "Only post these rarities. Empty = every egg you steal.", Options = v26, Multi = true, Default = {}, Callback = fn144(fn152)})
	tbl24.webhookValue = v44:AddInput({Title = "Notify Minimum Value", Content = "Only post eggs worth at least this per second. Supports k, m and b.", Placeholder = "e.g. 500k, 2m, 1b", Default = "", Callback = fn144(fn153)})

	v44:AddButton({Title = "Test Webhook", Content = "Sends one test embed so you can confirm the URL works.", Callback = fn144(function()
		local senaV4Webhook = genv.__SenaV4Webhook
		local value = tbl24.webhookUrl and tbl24.webhookUrl.Value

		if type(value) == "string" and value ~= "" then
			fn151(value)
		end

		if if senaV4Webhook then not senaV4Webhook.test() else not senaV4Webhook then
			flag6:Notify({Title = "Steal Webhook", Content = "Enter a webhook URL first", Duration = 3})
			return
		end
		flag6:Notify({Title = "Steal Webhook", Content = "Test embed sent", Duration = 3})
	end)})

	fn68 = v30:AddSection("Task Order")
	local tbl27 = {auto_steal = "hand", race = "flag", star = "star", mech_boss = "swords", butterfly = "flower", auto_place = "egg", use_scrambled = "flask-conical", auto_sell = "coins", treadmill = "activity"}
	local tbl28 = {}

	for i, v45 in ipairs(senaV4TaskLadder.DEFAULT) do
		local n8 = #tbl28 + 1
		local tbl29 = {Id = v45, Title = senaV4TaskLadder.TITLES[v45], Icon = tbl27[v45], Pinned = senaV4TaskLadder.PINNED[v45] == true}
		tbl29.Sub, tbl28[n8] = senaV4TaskLadder.PINNED[v45] and "Runs when every other task is idle" or nil, tbl29
	end

	local function fn156(arg)
		senaV4Config.TaskOrder = senaV4TaskLadder.sanitize(arg)
	end

	if type(fn68.AddPriorityList) == "function" then
		tbl24.taskOrder = fn68:AddPriorityList({Title = "Task Order", Content = "Higher rows get the character first. An egg you are carrying is always delivered first, and a boss fight that has started is never left.", Flag = "TaskOrder", Items = tbl28, Default = senaV4TaskLadder.DEFAULT, EmptyText = "Turn on Auto Steal, Auto Place or another feature to order it here.", Callback = fn144(fn156)})
	else
		fn68:AddParagraph({Title = "Task Order", Content = "Update the Sena library to reorder tasks. Using the default order: Auto Steal, Race Rally, Shooting Star, Mech Boss, Farm Drones, Auto Place, Use Scrambled, Auto Sell, Treadmill."})
	end

	v25 = tbl24.section(v33, "Egg Automation", tbl24.gameIcon("Assets", "Directory", "Dragon", "Egg", "Icon"))
	v25:AddSubSection("Place")
	tbl24.autoPlace = v25:AddToggle({Title = "Auto Place Egg", Content = "Places eggs from your inventory on your plot.", Default = false, Callback = fn144(fn118)})

	tbl24.placeRarity = v25:AddDropdown({Title = "Place Egg Rarity", Content = "Only place these rarities. Leave empty for all.", Options = v26, Multi = true, Default = {}, Callback = fn144(function(arg)
		senaV4Config.PlaceRarities = fn67(arg)
	end)})

	v25:AddSubSection("Hatch")
	tbl24.autoHatch = v25:AddToggle({Title = "Auto Hatch Egg", Content = "Hatches your placed eggs when they are ready.", Default = false, Callback = fn144(fn119)})
	v25:AddSubSection("Mutate")
	tbl24.mutationChoice = v25:AddDropdown({Title = "Select Mutation", Content = "Which mutation to apply to your placed eggs. Enchanted uses the Enchanted Essence from the Butterfly Bloom shrine.", Options = {"Scrambled", "Fractured", "Enchanted"}, Multi = false, Default = "Scrambled", Callback = fn144(fn122)})
	tbl24.mutationSpecies = v25:AddDropdown({Title = "Mutate Egg Name", Content = "Only mutate these eggs by name. Leave empty for every placed egg.", Options = v24, Multi = true, Default = {}, Callback = fn144(fn123)})
	tbl24.mutationRarity = v25:AddDropdown({Title = "Mutate Egg Rarity", Content = "Only mutate placed eggs of these rarities. Leave empty for every rarity.", Options = v26, Multi = true, Default = {}, Callback = fn144(fn124)})
	tbl24.mutationMinValue = v25:AddInput({Flag = "mutationMinValue", Title = "Mutate Min Value (money/s)", Content = "Only mutate placed eggs whose money per second is this or higher. Blank = no value limit. Supports k, m, b.", Placeholder = "e.g. 100k, 2m", Default = "", Callback = fn144(fn125)})
	tbl24.mutationRetry = v25:AddToggle({Title = "Retry Until Mutated", Content = "Keep applying to one egg until it mutates or charges run out (10% per use).", Default = true, Callback = fn144(fn126)})
	tbl24.autoMutation = v25:AddToggle({Title = "Auto Apply Mutation", Content = "Equips the selected mutation consumable and applies it to your placed eggs.", Default = false, Callback = fn144(fn120)})

	v25:AddButton({Title = "Apply Mutation Now", Content = "Run one mutation pass over your placed eggs right now.", Callback = fn144(function()
		task.spawn(function()
			pcall(tbl10.mutationSweep)
		end)
	end)})

	do
		fn68 = v33:AddSection({Title = "Placed Eggs", AlwaysOpen = true, Icon = tbl24.gameIcon("Assets", "Directory", "Dragon", "Egg", "Icon")})
		local addActionList = fn68.AddActionList and fn68:AddActionList({Title = "Your placed eggs", EmptyText = "No eggs placed on your plot.", VisibleRows = 6, ButtonWidth = 64})

		if addActionList then
			local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
			local senaV4IdentitySetter2 = genv.__SenaV4IdentitySetter
			local senaV4UICapabilityIdentity, Mutations, PlacedEggGrowthPresentationPolicy = genv.__SenaV4UICapabilityIdentity or 8

			pcall(function()
				Mutations = require(ReplicatedStorage2.Shared.Modules.Mutations)
			end)

			pcall(function()
				PlacedEggGrowthPresentationPolicy = require(ReplicatedStorage2.Shared.Eggs.PlacedEggGrowthPresentationPolicy)
			end)

			local function fn157(arg)
				if typeof(arg) ~= "Color3" then
					return "E8E8EE"
				end
				return string.format("%02X%02X%02X", math.floor(arg.R * 255 + 0.5), math.floor(arg.G * 255 + 0.5), math.floor(arg.B * 255 + 0.5))
			end

			local tbl29 = {Scrambled = true, Boss = true, Enchanted = true}

			local function fn158(arg)
				if arg == "Scrambled" then
					return "Scrambled"
				end

				local ok2, result = pcall(function()
					return Mutations.LabelOf(arg)
				end)

				return ok2 and type(result) == "string" and result ~= "" and result or tostring(arg)
			end

			local function fn159(arg)
				local n8 = math.max(0, math.floor(arg))
				local n9 = math.floor(n8 / 3600)
				local n10 = math.floor(n8 % 3600 / 60)
				local n11 = n8 % 60
				if n9 > 0 then
					return string.format("%dh %02dm", n9, n10)
				end
				return string.format("%dm %02ds", n10, n11)
			end

			local function fn160(arg)
				local placedEggRenders = workspace:FindFirstChild("PlacedEggRenders")
				return placedEggRenders and placedEggRenders:FindFirstChild(tostring(localPlayer.UserId) .. "_" .. tostring(arg))
			end

			local function fn161(arg)
				local v45 = fn160(arg)
				if not v45 then
					return false
				end
				local highlight = Instance.new("Highlight")
				highlight.FillColor = Color3.fromRGB(232, 232, 238)
				highlight.FillTransparency = 0.55
				highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
				highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
				highlight.Parent = v45

				task.delay(5, function()
					pcall(function()
						highlight:Destroy()
					end)
				end)

				return true
			end

			local function fn162()
				local tbl30, ok2, result = {}, pcall(function()
					return require(ReplicatedStorage2.Client.EggState).ReadOwnerEggs(localPlayer.UserId)
				end)

				if ok2 then
					if type(result) ~= "table" then
						return tbl30
					end
				else
					return tbl30
				end

				local serverTimeNow = workspace:GetServerTimeNow()

				for k, v45 in pairs(result) do
					if type(v45) == "table" and v45.Placement then
						local v46 = v6.resolve(v45)
						local baseMutation = v45.BaseMutation
						local tbl31 = {}
						local tbl32 = {}
						local tbl33 = {}

						for k2, v47 in pairs(type(v45.Mutations) == "table" and v45.Mutations or {}) do
							if not tbl33[v47] then
								tbl33[v47] = true

								if v47 ~= baseMutation or tbl29[v47] then
									tbl31[#tbl31 + 1] = fn158(v47)
								else
									tbl32[#tbl32 + 1] = fn158(v47)
								end
							end
						end

						if baseMutation and (tbl29[baseMutation] and not tbl33[baseMutation]) then
							tbl31[#tbl31 + 1] = fn158(baseMutation)
						end

						tbl33 = 0

						if PlacedEggGrowthPresentationPolicy then
							local ok3, result2 = pcall(PlacedEggGrowthPresentationPolicy.GetRemainingGrowthSeconds, v45, serverTimeNow)
							tbl33 = ok3 and tonumber(result2) or 0
						end

						local str4 = tbl33 > 0 and "Hatches in " .. fn159(tbl33) or "<font color=\"#4ADE80\">Ready to hatch</font>"
						local placedAt = v45.Placement.PlacedAt and os.date("%d %b %H:%M", math.floor(v45.Placement.PlacedAt)) or "?"
						local str5 = #tbl31 > 0 and "<font color=\"#4ADE80\">Mutated: " .. table.concat(tbl31, ", ") .. "</font>" or "<font color=\"#74747F\">Not mutated</font>"
						local v47 = if #tbl32 > 0 then str5 .. "  <font color=\"#A2A2AE\">[" .. table.concat(tbl32, ", ") .. "]</font>" else str5

						tbl30[#tbl30 + 1] = {id = tostring(k), name = string.format("<font color=\"#%s\">%s</font>", fn157(v46.rarityColor), tostring(v46.name)), sub = string.format("<font color=\"#%s\">%s</font>", fn157(v46.rarityColor), tostring(v46.rarity)), status = v47, statusSub = str4 .. "  -  Placed " .. placedAt, button = "Find", buttonColor = "accent", rank = v46.rarityRank or 0, mutated = #tbl31 > 0, onClick = function(arg, arg2)
							local v48 = fn161(k)
							arg2(v48 and "Found" or "Far", v48 and "green" or "red")

							task.delay(1.6, function()
								pcall(arg2, "Find", "accent")
							end)
						end}
					end
				end

				table.sort(tbl30, function(arg, arg2)
					if arg.rank ~= arg2.rank then
						return arg.rank > arg2.rank
					end

					if arg.mutated ~= arg2.mutated then
						return not arg.mutated
					end
					return arg.id < arg2.id
				end)

				return tbl30
			end

			local v45
			local n8, connection6 = 0

			connection6 = game:GetService("RunService").Heartbeat:Connect(function()
				if not addActionList:Alive() then
					connection6:Disconnect()
					return
				end
				local now = os.clock()
				if v45 and now - v45 < 5 then
					return
				end

				if now - n8 < 1 then
					return
				end
				n8 = now
				local v46 = now
				v45 = v46

				task.spawn(function()
					local ok2, result = pcall(function()
						if senaV4IdentitySetter2 then
							pcall(senaV4IdentitySetter2, senaV4UICapabilityIdentity)
						end

						local v47 = fn162()

						if senaV4IdentitySetter2 then
							pcall(senaV4IdentitySetter2, senaV4UICapabilityIdentity)
						end

						if addActionList:Alive() then
							addActionList:Update(v47)
						end
					end)

					if not ok2 then
						warn("[Sena] Placed eggs list error:", result)
					end

					if v45 == v46 then
						v45 = nil
					end
				end)
			end)
		end
	end

	local v45 = tbl24.section(v34, "Pet Selling", tbl24.gameIcon("Currency", "Directory", "Money", "Icon"))
	tbl24.autoSell = v45:AddToggle({Title = "Auto Sell Pet", Content = "Sells pets that match a filter below. Favorite, placed and equipped pets are kept.", Default = false, Callback = fn144(fn127)})
	v45:AddSubSection("Filter")

	v21 = v45:AddDropdown({Title = "Pet Name Filter", Content = "Pets to sell by name. Pick All for every name.", Options = fn73, Multi = true, Default = {}, Callback = fn144(function(arg)
		senaV4Config.SellNames = fn67(arg)
	end)})

	v22 = v45:AddDropdown({Title = "Pet Rarity Filter", Content = "Pets to sell by rarity. Pick All for every rarity.", Options = fn69(v26), Multi = true, Default = {}, Callback = fn144(function(arg)
		senaV4Config.SellRarities = fn67(arg)
	end)})

	tbl24.sellPetValue = v45:AddInput({Flag = "sellPetValue", Title = "Sell By Value (max money/s)", Content = "Only sell pets whose money per second is this or lower. Blank = no value limit. Supports k, m, b.", Placeholder = "e.g. 100k, 2m", Default = "", Callback = fn144(fn129)})
	local v46 = tbl24.section(v33, "Egg Selling", tbl24.gameIcon("Currency", "Directory", "Money", "Icon"))
	tbl24.autoSellEgg = v46:AddToggle({Title = "Auto Sell Egg", Content = "Sells unplaced eggs of the rarities below.", Default = false, Callback = fn144(fn128)})

	v23 = v46:AddDropdown({Title = "Egg Rarity Filter", Content = "Egg rarities to sell. Pick All for every rarity.", Options = fn69(v26), Multi = true, Default = {}, Callback = fn144(function(arg)
		senaV4Config.SellEggRarities = fn67(arg)
	end)})

	tbl24.sellEggValue = v46:AddInput({Flag = "sellEggValue", Title = "Sell By Value (max money/s)", Content = "Only sell eggs whose money per second is this or lower. Blank = no value limit. Supports k, m, b.", Placeholder = "e.g. 100k, 2m", Default = "", Callback = fn144(fn130)})
	fn68 = tbl24.section(v34, "Pet Favorite", tbl24.gameIcon("Assets", "Directory", "Unicorn", "Icon"))
	tbl24.autoFavorite = fn68:AddToggle({Title = "Auto Favorite", Content = "Marks every pet that matches the rule below as a favorite, so Auto Sell and Auto Fuse leave it alone.", Default = false, Callback = fn144(fn101)})
	tbl24.favoriteRule = fn68:AddDropdown({Title = "Favorite Rule", Content = "Match pets by rarity or by species.", Options = {"Rarity", "Species"}, Default = "Rarity", Callback = fn144(fn102)})
	fn68:AddSubSection("Only when Rule = Rarity")
	tbl24.favoriteRarities = fn68:AddDropdown({Title = "Rarities to Keep", Content = "Pets of these rarities get favorited.", Options = v26, Multi = true, Default = {}, Callback = fn144(fn103)})
	fn68:AddSubSection("Only when Rule = Species")
	tbl24.favoriteSpecies = fn68:AddDropdown({Title = "Species to Keep", Content = "Pets of these species get favorited.", Options = v24, Multi = true, Default = {}, Callback = fn144(fn104)})

	tbl24.unfavoriteAll = fn68:AddButton({Title = "Unfavorite Everything", Content = "Clears the favorite flag on every pet you own.", Callback = fn144(function()
		local senaV4PetBarn = genv.__SenaV4PetBarn
		flag6:Notify({Title = "Pet Favorite", Content = (if senaV4PetBarn then if type(senaV4PetBarn.unfavoriteAll) == "function" then senaV4PetBarn.unfavoriteAll() or 0 else 0 else 0) .. " pets unfavorited", Duration = 3})
	end)})

	local v47 = tbl24.section(v34, "Pet Fusion", tbl24.gameIcon("FallenPowerUp", "Kinds", "Fusion", "Icon"))
	tbl24.autoFuse = v47:AddToggle({Title = "Auto Fuse", Content = "Feeds three matching pets into the Fusion machine over and over. Favorited and equipped pets are never used.", Default = false, Callback = fn144(fn109)})
	tbl24.fuseRule = v47:AddDropdown({Title = "Fusion Rule", Content = "Fuse anything that passes the rarity filter, or only the species you pick below.", Options = {"Any Species", "Selected Species"}, Default = "Any Species", Callback = fn144(fn110)})
	tbl24.fuseRarities = v47:AddDropdown({Title = "Rarities to Fuse", Content = "Only fuse pets of these rarities. Leave empty for any rarity.", Options = v26, Multi = true, Default = {}, Callback = fn144(fn111)})
	v47:AddSubSection("Only when Rule = Selected Species")
	tbl24.fuseSpecies = v47:AddDropdown({Title = "Species to Fuse", Content = "Only these species go into the machine.", Options = v24, Multi = true, Default = {}, Callback = fn144(fn112)})
	local v48 = tbl24.section(v33, "Equip & Collect", tbl24.gameIcon("Assets", "Directory", "Dog", "Icon"))
	tbl24.autoEquipBest = v48:AddToggle({Title = "Auto Equip Best", Content = "Keeps your strongest pets equipped as better ones hatch.", Default = false, Callback = fn144(fn105)})
	tbl24.autoClaimOffline = v48:AddToggle({Title = "Collect Offline Income", Content = "Claims the money your base earned while you were away, as soon as there is any.", Default = false, Callback = fn144(fn106)})
	tbl24.autoBaseUpgrade = v48:AddToggle({Title = "Auto Upgrade Base", Content = "Buys the next base tier the moment you can afford it.", Default = false, Callback = fn144(fn107)})
	tbl24.autoClaimAlmanac = v48:AddToggle({Title = "Auto Claim Almanac", Content = "Redeems every Pet Index reward that is ready. This is the reward claim, not the steal objective.", Default = false, Callback = fn144(fn108)})

	tbl24.upgradeBaseOnce = v48:AddButton({Title = "Upgrade Base Now", Content = "Buys one base tier right away.", Callback = fn144(function()
		local senaV4Upgrades = genv.__SenaV4Upgrades
		local flag14 = false
		local str4 = "Upgrades not ready"

		if senaV4Upgrades and type(senaV4Upgrades.upgradeBase) == "function" then
			flag14, str4 = senaV4Upgrades.upgradeBase()
		end

		flag6:Notify({Title = "Base", Content = flag14 and "Base upgraded" or tostring(str4 or "Could not upgrade"), Duration = 3})
	end)})

	do
		local senaV4ButterflyRuntime = genv.__SenaV4ButterflyRuntime
		v25 = tbl24.section(v35, "Wisp Event", tbl24.gameIcon("WispQuests", "List", 1, "Icon"))
		local v49 = v25:AddParagraph({Title = "Wisp Companion", Content = "Reading your wisp progress..."})

		tbl24.wispAutoQuest = v25:AddToggle({Title = "Auto Wisp Quest", Content = "Meets the Baby Wisp, hunts the quest eggs (Enchanted Forest eggs, an Eternal), fuses an Enchanted Forest animal, claims every reward and flies the wisp home to unlock the Enchanted Tree. Needs 50B SpeedPower.", Default = false, Callback = fn144(function(arg)
			senaV4Config.WispAutoQuest = arg == true
		end)})

		tbl24.banjoAuto = v25:AddToggle({Title = "Auto Banjo Cricket", Content = "Goes into the Enchanted Tree, plays the Banjo Cricket's mushroom song back for all 5 stages, then claims the secret from Jitterbug. Needs the tree unlocked.", Default = false, Callback = fn144(function(arg)
			senaV4Config.BanjoAuto = arg == true
		end)})

		local v50 = tbl24.section(v35, "Butterfly Bloom", tbl24.gameIcon("ButterflyCatalog", "Icons", "Net"))
		local v51 = v50:AddParagraph({Title = "Bloom Status", Content = "Reading the Bloom schedule..."})
		local addIconGrid, v52 = v50.AddIconGrid and v50:AddIconGrid({Title = "Butterflies Caught", Note = "", Columns = 4})
		local tbl29 = {}

		tbl24.bloomAutoNet = v50:AddToggle({Title = "Auto Claim Net", Content = "Goes into the Enchanted Tree and claims your free Butterfly Net once.", Default = false, Callback = fn144(function(arg)
			senaV4Config.ButterflyAutoNet = arg == true
		end)})

		tbl24.bloomAutoCatch = v50:AddToggle({Title = "Auto Catch", Content = "During every Bloom (every 30 min, 5 min long) flies to the Enchanted Forest, equips the net and catches with the Catch Mode below.", Default = false, Callback = fn144(function(arg)
			senaV4Config.ButterflyAutoCatch = arg == true
		end)})

		fn68 = senaV4ButterflyRuntime and senaV4ButterflyRuntime.modeOptions() or {"Tween to Butterfly"}

		tbl24.bloomMode = v50:AddDropdown({Title = "Catch Mode", Content = "Tween to Butterfly chases one butterfly at a time. Stand waits in the thickest part of the swarm, Zigzag sweeps back and forth across the forest, Circle loops around the swarm.", Options = fn68, Multi = false, Default = fn68[1], Callback = fn144(function(arg)
			if senaV4ButterflyRuntime then
				senaV4ButterflyRuntime.setMode(arg)
			end
		end)})

		tbl24.bloomTiers = v50:AddDropdown({Title = "Catch Tiers", Content = "Only swing at these butterflies. Leave empty to catch every tier.", Options = senaV4ButterflyRuntime and senaV4ButterflyRuntime.tierOptions() or {"Radiant", "Amethyst", "Sapphire", "Emerald"}, Multi = true, Default = {}, Callback = fn144(function(arg)
			if senaV4ButterflyRuntime then
				senaV4ButterflyRuntime.setTiers(fn67(arg))
			end
		end)})

		tbl24.bloomEsp = v50:AddToggle({Title = "Butterfly ESP", Content = "Shows every butterfly's tier and distance while a Bloom is live.", Default = false, Callback = fn144(function(arg)
			senaV4Config.ButterflyEsp = arg == true
		end)})

		v50:AddSubSection("Trade & Craft")

		tbl24.bloomAutoTrade = v50:AddToggle({Title = "Auto Trade Up", Content = "After each Bloom, trades your butterflies up at the machine inside the Enchanted Tree.", Default = false, Callback = fn144(function(arg)
			senaV4Config.ButterflyAutoTrade = arg == true
		end)})

		fn73 = senaV4ButterflyRuntime and senaV4ButterflyRuntime.recipeOptions() or {"All Recipes"}

		tbl24.bloomRecipe = v50:AddDropdown({Title = "Trade Recipe", Content = "Which trade Auto Trade Up runs. For Essence only trades up what the essence recipe is still short of.", Options = fn73, Multi = false, Default = fn73[1], Callback = fn144(function(arg)
			if senaV4ButterflyRuntime then
				senaV4ButterflyRuntime.setRecipe(arg)
			end
		end)})

		tbl24.bloomAutoCraft = v50:AddToggle({Title = "Auto Craft Essence", Content = "After each Bloom, crafts Enchanted Essence at the shrine once you hold the full recipe.", Default = false, Callback = fn144(function(arg)
			senaV4Config.ButterflyAutoCraft = arg == true
		end)})

		local function fn157(arg, arg2, arg3, arg4)
			v50:AddButton({Title = arg, Content = arg2, Callback = fn144(function()
				if not senaV4ButterflyRuntime then
					return
				end

				task.spawn(function()
					senaV4ButterflyRuntime.manual = true
					local ok2, result, result2 = pcall(arg3)
					senaV4ButterflyRuntime.manual = false

					if ok2 then
					else
						result, result2 = false, result
					end

					flag6:Notify({Title = "Butterfly Bloom", Content = result and arg4(result2) or tostring(result2 or "Could not do that"), Duration = 4})
				end)
			end)})
		end

		fn157("Claim Net Now", "Claims the Butterfly Net right now.", function()
			return senaV4ButterflyRuntime.claimNet()
		end, function()
			return "Butterfly Net claimed"
		end)

		fn157("Trade Up Now", "Runs the trade recipe once, even with Auto Trade Up off.", function()
			return senaV4ButterflyRuntime.tradeUp()
		end, function(arg)
			return ("Traded up %d time(s)"):format(tonumber(arg) or 0)
		end)

		fn157("Craft Essence Now", "Crafts Enchanted Essence right now if you hold the full recipe.", function()
			return senaV4ButterflyRuntime.craft()
		end, function(arg)
			return ("Crafted %d Enchanted Essence"):format(tonumber(arg) or 0)
		end)

		local function fn158(arg)
			local n8 = tonumber(arg) or 0
			if n8 >= 1000000000000 then
				return ("%.2fT"):format(n8 / 1000000000000)
			end

			if n8 >= 1000000000 then
				return ("%.2fB"):format(n8 / 1000000000)
			end

			if n8 >= 1000000 then
				return ("%.2fM"):format(n8 / 1000000)
			end

			if n8 >= 1000 then
				return ("%.1fK"):format(n8 / 1000)
			end
			return tostring(math.floor(n8))
		end

		task.spawn(function()
			while fn2() do
				if senaV4ButterflyRuntime then
					local function fn159()
						local snap = senaV4ButterflyRuntime.snap
						local tbl30 = senaV4ButterflyRuntime.tiers() or {}

						if snap.unlocked then
							v49:SetContent("Complete - the Enchanted Tree is unlocked.")
						elseif snap.accepted then
							v49:SetContent(("Stage %d / %d  \194\183  %s  (%d / %d)%s"):format(snap.stage or 1, snap.stages or 4, tostring(snap.quest), snap.progress or 0, snap.target or 0, snap.readyReturn and "\nAll quests done - return the wisp to unlock the tree." or (snap.claimable and "\nReady to claim." or (senaV4ButterflyRuntime.questNote and "\n" .. senaV4ButterflyRuntime.questNote or ""))))
						elseif (snap.speed or 0) < (snap.need or 0) then
							v49:SetContent(("Not eligible yet: SpeedPower %s of %s."):format(fn158(snap.speed), fn158(snap.need)))
						else
							v49:SetContent(("Eligible (SpeedPower %s). The Baby Wisp waits in the Enchanted Forest."):format(fn158(snap.speed)))
						end

						local str4

						if snap.active then
							local n8 = math.floor(snap.left or 0)
							str4 = ("LIVE - ends in %dm %02ds"):format(math.floor(n8 / 60), n8 % 60)
						else
							if snap.enabled == false then
								str4 = "Disabled on this server"
							else
								if snap.nextIn then
									local n8 = math.floor(snap.nextIn)
									str4 = ("Next in %dm %02ds"):format(math.floor(n8 / 60), n8 % 60)
								else
									str4 = "Not running"
								end
							end
						end

						local tbl31 = {}

						for i, v53 in ipairs({"Golden", "Purple", "Blue", "Green"}) do
							tbl31[#tbl31 + 1] = ("%s %d"):format(tbl30[v53] and tbl30[v53].name or v53, snap.counts and snap.counts[v53] or 0)
						end

						if addIconGrid then
							local tbl32 = {}

							for i, v53 in ipairs({"Green", "Blue", "Purple", "Golden"}) do
								local counts = snap.counts and snap.counts[v53] or 0

								if v52 and counts > (v52[v53] or 0) then
									tbl29[v53] = (tbl29[v53] or 0) + counts - v52[v53]
								end

								local tbl33 = tbl30[v53] or {}
								local n8 = tbl29[v53] or 0
								tbl32[#tbl32 + 1] = {Name = tbl33.name or v53, Icon = tbl33.icon, Color = tbl33.color, Value = fn158(counts), Sub = n8 > 0 and ("+%d session"):format(n8) or (tbl33.rarity or ""), SubColor = n8 > 0 and Color3.fromRGB(74, 222, 128) or nil}
							end

							v52 = table.clone(snap.counts or {})
							addIconGrid:SetItems(tbl32)
							addIconGrid:SetNote(("Total %s  \194\183  Essence %d"):format(fn158(snap.caught), snap.essence or 0))
							tbl31 = {}
						end

						v51:SetContent((("%s\n%s  \194\183  Essence %d  \194\183  Caught %d\n%s\n%s"):format(str4, snap.net and (snap.holding and "Net equipped" or "Net owned") or "No Butterfly Net", snap.essence or 0, snap.caught or 0, table.concat(tbl31, "  \194\183  "), tostring(senaV4ButterflyRuntime.status or "Idle")):gsub("\n\n", "\n")))
					end

					pcall(fn159)
				end

				task.wait(1)
			end
		end)
	end

	local v49 = tbl24.section(v35, "Race Rally", tbl24.gameIcon("FallenPowerUp", "Kinds", "x2Rings", "Icon"))
	v49:AddParagraph({Title = "About This Event", Content = "Race Rally opens every 30 minutes for 60 seconds. Auto Race joins from anywhere, rides the track for you and brings you back to base after the finish."})

	tbl24.raceAuto = v49:AddToggle({Title = "Auto Race", Content = "Joins every race, rides the track, uses power-ups and returns to base. Auto Steal pauses while you race.", Default = false, Callback = fn144(function(arg)
		senaV4Config.RaceAuto = arg == true
	end)})

	tbl24.raceClaim = v49:AddToggle({Title = "Auto Claim & Equip Best Racer", Content = "Claims every win milestone you reached and equips the best racer you own.", Default = false, Callback = fn144(function(arg)
		senaV4Config.RaceClaim = arg == true
	end)})

	tbl24.raceBuy = v49:AddToggle({Flag = "RaceAutoBuyShop", Title = "Auto Buy Shop", Content = "Spends race tokens on the items you pick below.", Default = false, Callback = fn144(function(arg)
		senaV4Config.RaceBuy = arg == true
	end)})

	tbl24.raceBuyList = v49:AddDropdown({Flag = "RaceShopBuyList", Title = "Shop Buy List", Content = "Which race shop items Auto Buy should purchase.", Options = {"CashBooster", "SpeedBoost", "TreadmillBoost", "MutationToken", "RacingBat"}, Multi = true, Default = {}, Callback = fn144(function(arg)
		senaV4Config.RaceBuyList = fn67(arg)
	end)})

	local v50 = v49:AddParagraph({Title = "Race Status", Content = "Waiting for the next race."})

	task.spawn(function()
		while fn2() do
			local senaV4RaceRuntime = genv.__SenaV4RaceRuntime

			if senaV4RaceRuntime then
				pcall(function()
					local v51 = senaV4RaceRuntime.joinLeft()
					local str4 = v51 > 0 and string.format("  \194\183  Join open %ds", math.floor(v51)) or ""
					v50:SetContent(tostring(senaV4RaceRuntime.status) .. str4 .. "\nLast: " .. tostring(senaV4RaceRuntime.lastResult))
				end)
			end

			task.wait(1)
		end
	end)

	local v51 = tbl24.section(v35, "Shooting Star", "rbxassetid://92160802930122")
	v51:AddParagraph({Title = "About This Event", Content = "Sometimes a little star falls near you and runs around for a few minutes. Hold next to it to catch it."})

	tbl24.starAlert = v51:AddToggle({Title = "Star Alert", Content = "Shows a notification the moment a star starts falling.", Default = true, Callback = fn144(function(arg)
		senaV4Config.StarAlert = arg == true
	end)})

	tbl24.starAutoCatch = v51:AddToggle({Title = "Auto Catch Star", Content = "Goes to the star when it lands and catches it. Other tasks pause until it is caught.", Default = false, Callback = fn144(function(arg)
		senaV4Config.StarAutoCatch = arg == true
	end)})

	local v52 = v51:AddParagraph({Title = "Star Status", Content = "No star right now."})

	task.spawn(function()
		while fn2() do
			local senaV4StarRuntime = genv.__SenaV4StarRuntime

			if senaV4StarRuntime then
				pcall(function()
					v52:SetContent(tostring(senaV4StarRuntime.status) .. "\nLast: " .. tostring(senaV4StarRuntime.lastResult))
				end)
			end

			task.wait(1)
		end
	end)

	local v53 = tbl24.section(v35, "Dr Scramble Event", tbl24.gameIcon("Gears", "Directory", "The Scrambler", "Icon"))
	v53:AddParagraph({Title = "About This Event", Content = "Dr Scramble only runs during the live event. The shop, trade-in and boss fight are still up; the rest of the time these toggles sit idle."})
	tbl24.scrambleBuy = v53:AddToggle({Flag = "ScrambleAutoBuyShop", Title = "Auto Buy Shop", Content = "Spends samples on the shop items you pick below, as soon as you can afford them.", Default = false, Callback = fn144(fn116)})
	tbl24.scrambleBuyList = v53:AddDropdown({Flag = "ScrambleShopBuyList", Title = "Shop Buy List", Content = "Which shop items Auto Buy should purchase. This list fills in once the event shop is open.", Options = tbl26, Multi = true, Default = {}, Callback = fn144(fn117)})
	local v54 = v53:AddParagraph({Title = "Scramble Telemetry", Content = "Waiting for the event to start."})

	task.spawn(function()
		while fn2() do
			local senaV4ScrambleRuntime = genv.__SenaV4ScrambleRuntime

			if senaV4ScrambleRuntime and type(senaV4ScrambleRuntime.samples) == "function" then
				local ok2, result = pcall(senaV4ScrambleRuntime.samples)

				if ok2 then
					pcall(function()
						v54:SetContent(string.format("Samples %d  \194\183  %s", result or 0, senaV4ScrambleRuntime.status or "Idle"))
					end)
				end
			end

			task.wait(2)
		end
	end)

	v53:AddSubSection("Trade-In (Experimental Pets)")

	tbl24.scrambleTradeInTrade = v53:AddToggle({Title = "Auto Trade-In", Content = "Auto-completes the recipe: uses the required eggs you already have, and auto-adds any you're missing to the Auto Steal hunt (works even with Auto Steal off) so they get stolen off the field, then combines once all three are ready. Favorited / placed eggs are never spent.", Default = false, Callback = fn144(function(arg)
		senaV4Config.ScrambleTradeInTrade = arg == true
	end)})

	tbl24.scrambleTradeInReroll = v53:AddToggle({Title = "Auto Free Reroll", Content = "When pets are missing and a free reroll is left, rerolls the recipe instead of waiting.", Default = false, Callback = fn144(function(arg)
		senaV4Config.ScrambleTradeInReroll = arg == true
	end)})

	tbl24.scrambleTradeInBanners = v53:AddDropdown({Title = "Target Banners", Content = "Only work the trade-in while one of these banners is up. Leave empty to accept any banner.", Options = {"Biohazard Pets", "Experimental Pets", "Unstable DNA"}, Multi = true, Default = {}, Callback = fn144(fn98)})

	v53:AddButton({Title = "Trade-In Once", Content = "Runs one sacrifice right now, even with Auto Trade-In off.", Callback = fn144(function()
		local senaV4ScrambleTradeIn = genv.__SenaV4ScrambleTradeIn
		local flag14 = false
		local str4 = "Trade-In not ready"

		if senaV4ScrambleTradeIn then
			flag14, str4 = senaV4ScrambleTradeIn.tradeOnce()
		end

		flag6:Notify({Title = "Dr Scramble", Content = flag14 and "Sacrifice complete" or tostring(str4), Duration = 4})
	end)})

	v53:AddButton({Title = "Use Free Reroll", Content = "Spends one of today's free rerolls on a new recipe.", Callback = fn144(function()
		local senaV4ScrambleTradeIn = genv.__SenaV4ScrambleTradeIn
		local flag14 = false
		local str4 = "Trade-In not ready"

		if senaV4ScrambleTradeIn then
			flag14, str4 = senaV4ScrambleTradeIn.reroll()
		end

		flag6:Notify({Title = "Dr Scramble", Content = flag14 and "Recipe rerolled" or tostring(str4), Duration = 4})
	end)})

	v53:AddButton({Title = "Open Trade-In UI", Content = "Opens Dr Scramble's Lab window so you can pick pets by hand.", Callback = fn144(function()
		if not pcall(function()
			require(ReplicatedStorage.Client.Tabs).Activate("DrScrambleTradeIn")
		end) then
			flag6:Notify({Title = "Dr Scramble", Content = "Could not open the trade-in window", Duration = 3})
		end
	end)})

	local v55 = v53:AddParagraph({Title = "Trade-In Status", Content = "Turn a trade-in toggle on to start reading the recipe."})

	task.spawn(function()
		while fn2() do
			local senaV4ScrambleTradeIn = genv.__SenaV4ScrambleTradeIn

			if senaV4ScrambleTradeIn then
				pcall(function()
					v55:SetContent(string.format("%s  \194\183  %s\nRotates in %02d:%02d  \194\183  Pity %d/%d  \194\183  Free rerolls %d  \194\183  Traded %d\nRecipe (%d/%d): %s\nHeld: %s\nMissing: %s", senaV4ScrambleTradeIn.banner, senaV4ScrambleTradeIn.status, math.floor(senaV4ScrambleTradeIn.rotation / 60), senaV4ScrambleTradeIn.rotation % 60, senaV4ScrambleTradeIn.pity, senaV4ScrambleTradeIn.pityMax, senaV4ScrambleTradeIn.free, senaV4ScrambleTradeIn.trades, senaV4ScrambleTradeIn.ready, senaV4ScrambleTradeIn.total, senaV4ScrambleTradeIn.demands, senaV4ScrambleTradeIn.stock, senaV4ScrambleTradeIn.missing))
				end)
			end

			task.wait(1)
		end
	end)

	v53:AddSubSection("Boss Fight")

	tbl24.scrambleBossAuto = v53:AddToggle({Title = "Auto Boss", Content = "When Dr Scramble's boss is live, walks into the arena portal, joins the fight, hits the nearest target with your bat and breaks free from grabs. The clear reward lands automatically. While Auto Steal is on and this is off, an accidental touch on the arena portal is bounced back out so your steal is never hijacked.", Default = false, Callback = fn144(function(arg)
		senaV4Config.ScrambleBossAuto = arg == true
		local senaV4ScrambleBoss = genv.__SenaV4ScrambleBoss

		if senaV4ScrambleBoss and type(senaV4ScrambleBoss.setEnabled) == "function" then
			pcall(senaV4ScrambleBoss.setEnabled, senaV4ScrambleBoss, arg == true)
		end

		if v13 and type(v13._reconcileScramblePortal) == "function" then
			pcall(v13._reconcileScramblePortal, v13)
		end
	end)})

	local v56 = v53:AddParagraph({Title = "Boss Status", Content = "Turn Auto Boss on. It sits idle until the boss event goes live."})

	task.spawn(function()
		while fn2() do
			local senaV4ScrambleBoss = genv.__SenaV4ScrambleBoss

			if senaV4ScrambleBoss then
				pcall(function()
					local flag14 = type(senaV4ScrambleBoss._snapshot) == "function" and senaV4ScrambleBoss:_snapshot() or nil

					if type(flag14) == "table" then
						v56:SetContent(string.format("%s\nPhase %s  \194\183  HP %d/%d%s\nSamples %d  \194\183  Reward %s", tostring(flag14.status), tostring(flag14.phase), math.floor((flag14.health or 0) + 0.5), math.floor((flag14.maxHealth or 0) + 0.5), flag14.overheated and "  \194\183  OVERHEAT" or "", flag14.samples or 0, tostring(flag14.reward)))
					else
						v56:SetContent(tostring(senaV4ScrambleBoss.status or "Idle"))
					end
				end)
			end

			task.wait(1)
		end
	end)

	local v57 = tbl24.section(v36, "Treadmill", tbl24.gameIcon("Treadmills", "Directory", "Treadmill", "Icon"))
	tbl24.autoTreadmill = v57:AddToggle({Title = "Auto Treadmill", Content = "Walks to your treadmill and farms speed whenever nothing else is running.", Default = false, Callback = fn144(fn82)})
	tbl24.treadmillUpgrade = v57:AddToggle({Title = "Auto Upgrade Treadmill", Content = "Buys the next treadmill tier with cash as soon as you can afford it.", Default = false, Callback = fn144(fn88)})
	local Performance = v38:AddSection("Performance")
	tbl24.startupBoost = Performance:AddToggle({Title = "Startup Boost", Content = "Lowers graphics when the script starts. Turn it off to get the graphics back; hidden pets and eggs return after a rejoin.", Default = false, Callback = fn144(fn131)})
	tbl24.boostFps = Performance:AddToggle({Title = "Boost FPS", Content = "Removes extra map details and other players' plots for more FPS.", Default = false, Callback = fn144(fn132)})
	tbl24.uncapFps = Performance:AddToggle({Title = "Uncap FPS", Content = "Raises the FPS cap to 1000.", Default = true, Callback = fn144(fn133)})
	local Guard = v38:AddSection("Guard")
	tbl24.antiGuardKnockback = Guard:AddToggle({Title = "Anti Guard Knockback", Content = "Cancels the knockback the Forest guard puts on you, so a hit never throws you off the lane.", Default = true, Callback = fn144(fn100)})
	tbl24.antiHitGuard = Guard:AddToggle({Title = "Anti Hit Guard", Content = "For eggs you pick up by hand. Pins you in the safe zone behind a look-alike clone until the guard goes back to sleep. Auto Steal has its own guard handling and always wins.", Default = false, Callback = fn144(fn140)})
	local Windows = v31:AddSection("Windows", true)

	Windows:AddButton({Title = "Egg Logs", Content = "Live feed of every egg that spawns on the server.", Callback = fn144(function()
		senaPanels.openLogs()
	end)})

	Windows:AddButton({Title = "Egg Board", Content = "Sortable list of the eggs currently up for grabs.", Callback = fn144(function()
		senaPanels.openBoard()
	end)})

	Windows:AddButton({Title = "Inventory & Base", Content = "Your pets, eggs and plot status in one window.", Callback = fn144(function()
		senaPanels.openInventory()
	end)})

	Windows:AddButton({Title = "Egg Checker", Content = "Pick eggs off the field by hand, then send them all to the steal queue.", Callback = fn144(function()
		senaPanels.openChecker()
	end)})

	Windows:AddButton({Title = "Egg Data & History", Content = "Drop-table values per area, plus what has actually spawned this session.", Callback = fn144(function()
		senaPanels.openAnalyst()
	end)})

	Windows:AddButton({Title = "Farm Stats", Content = "What is running now, money and income, steals, your plot and the Dr Scramble event at a glance.", Icon = "trending-up", Callback = fn144(function()
		senaPanels.openStats()
	end)})

	Windows:AddButton({Title = "Open All Windows", SubTitle = "Close All Windows", Content = "Opens every window at once, or hides them again.", Callback = fn144(function()
		senaPanels.openAll()
	end), SubCallback = fn144(function()
		senaPanels.closeAll()
	end)})

	tbl24.antiTreadmill = tbl24.section(v36, "Blocker", tbl24.gameIcon("Gears", "Directory", "Trap", "Icon")):AddToggle({Title = "Anti Treadmill", Content = "Never stay on a treadmill: any mount is dropped right away, and Auto Treadmill is held off while this is on.", Default = false, Callback = fn144(fn83)})
	local v58 = v37:AddSection("Server Hop")
	tbl24.hopNoMatch = v58:AddToggle({Title = "Hop When Nothing Matches", Content = "Hop to the emptiest server when no egg matches your filters.", Default = false, Callback = fn144(fn84)})
	v58:AddSubSection("Limits")
	tbl24.hopCooldown = v58:AddSlider({Title = "Hop Cooldown", Content = "Seconds between auto hops and wait after rejoining.", Min = 1, Max = 60, Default = 5, Increment = 1, Callback = fn144(fn87)})
	local v59 = tbl24.privateTab:AddSection("Find Private Server", true)
	local v60 = v59:AddParagraph({Title = "Current Server", Content = "Checking..."})
	tbl24.privateServerMax = v59:AddDropdown({Title = "Max Players", Content = "The most players you want in your server, you included. 2 (you + 1) is the easiest to find.", Options = {"1", "2", "3", "4", "5"}, Default = "2", Multi = false, Callback = fn144(fn85)})

	v59:AddButton({Title = "Hop Server Now", Content = "Moves you to a quieter server right away.", Callback = fn144(function()
		task.spawn(function()
			tbl13.hopPrivateOnce()
		end)
	end)})

	tbl24.privateServerAuto = v59:AddToggle({Title = "Auto Hop", Content = "Keeps moving you to quieter servers until the player count is at or under your max.", Default = false, Callback = fn144(fn86)})

	task.spawn(function()
		local v61

		while fn2() do
			local str4 = "Now: " .. #Players:GetPlayers() .. " player(s)  \194\183  Max: " .. tbl13.privateMax() .. "\n" .. tostring(tbl13.privateStatus or "")

			if str4 ~= v61 then
				pcall(function()
					v60:SetContent(str4)
				end)

				v61 = str4
			end

			task.wait(1)
		end
	end)

	local v61 = tbl24.section(v36, "Roaming", tbl24.gameIcon("Trails", "Directory", "PurpleTrail", "Icon"))

	tbl24.waypoint = v61:AddDropdown({Title = "Waypoint", Content = "Pick a place, then hit Teleport below.", Options = tbl25, Default = tbl25[1], Callback = fn144(function(arg)
		v29 = arg
	end)})

	v61:AddButton({Title = "Teleport To Waypoint", Content = "Moves you straight to the waypoint you picked.", Callback = fn144(function()
		local senaV4Roaming2 = genv.__SenaV4Roaming
		flag6:Notify({Title = "Waypoint", Content = (if senaV4Roaming2 then if type(senaV4Roaming2.teleportWaypoint) == "function" then senaV4Roaming2.teleportWaypoint(v29) == true else false else false) and "Moved to " .. tostring(v29) or "That waypoint is not in this server", Duration = 3})
	end)})

	local v62 = v30:AddSection("Run Once")

	v62:AddButton({Title = "Place Everything Now", Content = "Runs one pass of Auto Place, even while the toggle is off.", Callback = fn144(function()
		runOnce("AutoPlace", tbl10.AutoPlaceLoop)
	end)})

	v62:AddButton({Title = "Hatch Everything Ready", Content = "Runs one pass of Auto Hatch, even while the toggle is off.", Callback = fn144(function()
		runOnce("AutoHatch", tbl10.AutoHatchLoop)
	end)})

	v62:AddButton({Title = "Sell Pets Now", Content = "Runs one pass of Auto Sell Pet using the filters above.", Callback = fn144(function()
		runOnce("AutoSell", tbl10.startAutoSellLoop)
	end)})

	v62:AddButton({Title = "Sell Eggs Now", Content = "Runs one pass of Auto Sell Egg using the filters above.", Callback = fn144(function()
		runOnce("AutoSellEgg", tbl10.startAutoSellEggLoop)
	end)})

	local Session = v38:AddSection("Session")
	tbl24.bottingMode = Session:AddToggle({Title = "Botting Mode", Content = "Turns off 3D rendering and covers the screen in black. Everything keeps running, your GPU does not.", Default = false, Callback = fn144(fn114)})
	tbl24.antiCutscene = Session:AddToggle({Title = "Anti Cutscene", Content = "Closes event cutscenes and the intro as soon as the game opens them, so nothing locks your camera.", Default = false, Callback = fn144(fn115)})

	Session:AddButton({Title = "Rejoin This Server", Content = "Teleports you back into the exact server you are in now.", Callback = fn144(function()
		pcall(function()
			game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, localPlayer)
		end)
	end)})

	Session:AddButton({Title = "Stop & Unload", Content = "Turns every loop off and closes the hub. Run the script again to bring it back.", Callback = fn144(function()
		for i, v63 in ipairs({"AutoSteal", "AutoPlace", "AutoHatch", "AutoSell", "AutoSellEgg", "StealPlayers", "AutoFavorite", "AutoFusePets", "AutoEquipBest", "AutoClaimOffline", "AutoBaseUpgrade", "AutoClaimAlmanac", "Noclip", "BottingMode", "AntiCutscene"}) do
			senaV4Config[v63] = false
		end

		fn113(false)
		fn114(false)

		if v13 then
			pcall(v13.setEnabled, v13, false)
		end

		local senaV4HubShutdown = genv.__SenaV4HubShutdown

		if type(senaV4HubShutdown) == "function" then
			task.delay(0.2, function()
				pcall(senaV4HubShutdown)
			end)
		end
	end)})

	local Player = v38:AddSection("Player")
	tbl24.antiAfk = Player:AddToggle({Title = "Anti AFK", Content = "Blocks the game's idle kick while the script runs.", Default = true, Callback = fn144(fn141)})
	tbl24.autoReconnect = Player:AddToggle({Title = "Auto Reconnect", Content = "Automatically reconnects you back to the server upon kick or disconnect.", Default = true, Callback = fn144(fn142)})
	tbl24.autoExecute = Player:AddToggle({Title = "Auto Execute (Rejoin)", Content = "Prepares the bootstrapper so the script runs automatically after teleport or reconnect.", Default = false, Callback = fn144(fn143)})
	local v63 = tbl24.section(v32, "Steal From Players", tbl24.gameIcon("Gears", "Directory", "Bat", "Icon"))
	tbl24.stealPlayers = v63:AddToggle({Title = "Auto Steal From Players", Content = "Chases anyone carrying an egg in the field, bats them until the egg drops, grabs it and banks it. A carrier is only chased when the egg clears the filters below.", Default = false, Callback = fn144(fn145)})
	tbl24.stealPlayerRarities = v63:AddDropdown({Title = "Rarity Filter", Content = "Only chase eggs of these rarities. Empty = uses the Auto Steal rarity filter.", Options = v26, Multi = true, Default = {}, Callback = fn144(fn146)})
	tbl24.stealPlayerValue = v63:AddInput({Title = "Minimum Value", Content = "Skip carriers holding less than this per second. Supports k, m and b.", Placeholder = "e.g. 500k, 2m, 1b", Default = "", Callback = fn144(fn148)})
	local v64 = v32:AddSection({Title = "Steal From Specific Player", AlwaysOpen = true, Icon = tbl24.gameIcon("Gears", "Directory", "Katana", "Icon")})
	fn69 = v32:AddSection({Title = "Steal History", AlwaysOpen = true, Icon = tbl24.gameIcon("Gears", "Directory", "Flyswatter", "Icon")})
	local v65, v66, v67, v68

	if v64.AddActionList then
		v67, v68 = v64:AddActionList({Title = "Players in this server", EmptyText = "Nobody else is in this server.", VisibleRows = 6, ButtonWidth = 76}), fn69:AddActionList({Title = "History of stolen eggs from players", EmptyText = "No player steals yet.", VisibleRows = 5, ButtonWidth = 72})
	else
		v64:AddParagraph({Title = "Update required", Content = "This Sena UI build has no player list yet. Rejoin to pull the latest version."})
		v67, v68 = v65, v66
	end

	fn69:AddButton({Title = "Clear History", Content = "Wipe the list above.", Callback = fn144(function()
		if senaV4PlayerSteal then
			senaV4PlayerSteal:clearHistory()
		end
	end)})

	if senaV4PlayerSteal and v67 then
		local senaV4IdentitySetter2 = genv.__SenaV4IdentitySetter
		local senaV4UICapabilityIdentity = genv.__SenaV4UICapabilityIdentity or 8

		local function fn157(arg)
			if senaV4IdentitySetter2 then
				pcall(senaV4IdentitySetter2, senaV4UICapabilityIdentity)
			end

			if v68 then
				if not v68:Alive() then
					return
				end
			else
				return
			end

			local tbl29 = {}

			for i, v69 in ipairs(arg.history) do
				tbl29[i] = {id = tostring(i), name = v69.player, sub = string.format("<font color=\"#A2A2AE\">%s</font>", os.date("!%H:%M:%S", v69.at)), status = v69.egg, statusSub = v69.outcome, button = false}
			end

			v68:Update(tbl29)
		end

		senaV4PlayerSteal:onChanged(fn157)
		fn157(senaV4PlayerSteal)
		local v69
		local n8, connection6 = 0

		connection6 = game:GetService("RunService").Heartbeat:Connect(function()
			if genv.__SenaV4PlayerSteal ~= senaV4PlayerSteal then
				connection6:Disconnect()
				return
			elseif not v67:Alive() then
				connection6:Disconnect()
				return
			end

			local now = os.clock()
			if v69 and now - v69 < 5 then
				return
			end

			if now - n8 < 1 then
				return
			end
			n8 = now
			local v70 = now
			v69 = v70

			task.spawn(function()
				local ok2, result = pcall(function()
					if senaV4IdentitySetter2 then
						pcall(senaV4IdentitySetter2, senaV4UICapabilityIdentity)
					end

					local v71 = senaV4PlayerSteal:listEntries()

					if senaV4IdentitySetter2 then
						pcall(senaV4IdentitySetter2, senaV4UICapabilityIdentity)
					end

					if v67:Alive() then
						v67:Update(v71)
					end
				end)

				if not ok2 then
					warn("[Sena Steal] Player list update loop error:", result)
				end

				if v69 == v70 then
					v69 = nil
				end
			end)
		end)
	end

	local v69 = v28:AddTab({Name = "Live Chat", Icon = "chat", LayoutOrder = 11});
	(flag13 and v69:AddSection({Title = "Global Chat", Header = false}) or v69:AddSection("Global Chat", true)):AddLiveChat({Title = "Live Chat", Fill = true, Height = 300})

	if type(v28.AddForum) == "function" then
		v28:AddForum({Name = "Forum", Icon = "forum", Section = "Config Forum", LayoutOrder = 12})
	end

	do
		local senaV4Visual = genv.__SenaV4Visual
		local v70, tbl29, v71 = v28:AddTab({Name = "Visual", Icon = "eye", LayoutOrder = 10}), {rods = nil, fish = nil}

		local function fn157()
			if v71 and senaV4Visual then
				pcall(function()
					v71:SetContent(senaV4Visual.status)
				end)
			end
		end

		local function fn158(arg)
			if not senaV4Visual then
				return
			end

			task.spawn(function()
				senaV4Visual.spawn(arg, tbl29[arg])
				fn157()
				flag6:Notify({Title = "Visual", Content = senaV4Visual.status, Duration = 3})
			end)

			task.delay(0.1, fn157)
		end

		local v72 = v70:AddSection("Fish It")
		v72:AddSubSection("Rods")

		local v73 = v72:AddDropdown({Title = "Select Rod", Content = "Rods and skins from Fish It. Loading list...", Options = {}, Multi = false, Default = nil, Callback = fn144(function(rods)
			tbl29.rods = rods
		end)})

		v72:AddButton({Title = "Spawn Rod", Content = "Downloads the rod and puts it in your backpack. Equip it like a bat. Only you can see it.", Callback = fn144(function()
			fn158("rods")
		end)})

		v72:AddSlider({Title = "Rod Size", Content = "1 = the size it has in Fish It. Spawned rods update right away.", Min = 0.5, Max = 2, Default = 1, Increment = 0.1, Callback = fn144(function(rodScale)
			if senaV4Visual then
				if senaV4Visual.rodScale == rodScale then
					return
				end
			else
				return
			end

			senaV4Visual.rodScale = rodScale
			task.spawn(senaV4Visual.respawn, "rods")
		end)})

		v72:AddSubSection("Fish")

		local v74 = v72:AddDropdown({Title = "Select Fish", Content = "Secret and Forgotten fish from Fish It. Loading list...", Options = {}, Multi = false, Default = nil, Callback = fn144(function(fish)
			tbl29.fish = fish
		end)})

		v72:AddButton({Title = "Spawn Fish", Content = "Downloads the fish and puts it in your backpack under Pets. Only you can see it.", Callback = fn144(function()
			fn158("fish")
		end)})

		v72:AddSlider({Title = "Fish Weight", Content = "0% = lightest catch, 100% = heaviest Big catch. Size follows Fish It: weight / min weight.", Min = 0, Max = 100, Default = 0, Increment = 5, Callback = fn144(function(arg)
			local fishWeight = (tonumber(arg) or 0) / 100

			if senaV4Visual then
				if senaV4Visual.fishWeight == fishWeight then
					return
				end
			else
				return
			end

			senaV4Visual.fishWeight = fishWeight
			task.spawn(senaV4Visual.respawn, "fish")
		end)})

		v72:AddSubSection("Manage")
		v71 = v72:AddParagraph({Title = "Status", Content = "Idle"})

		v72:AddButton({Title = "Remove All Visual Items", Content = "Takes every spawned rod and fish out of your backpack.", Callback = fn144(function()
			if senaV4Visual then
				senaV4Visual.clear()
			end

			fn157()
		end)})

		task.spawn(function()
			if not senaV4Visual then
				return
			end
			local rods = senaV4Visual.names("rods")
			local fish = senaV4Visual.names("fish")

			pcall(function()
				v73:Refresh(rods)
			end)

			pcall(function()
				v74:Refresh(fish)
			end)

			senaV4Visual.status = #rods > 0 and string.format("%d rods and %d fish available", #rods, #fish) or "Could not load the item list. Try again later."
			fn157()
		end)

		local v75 = v70:AddSection("Steal an Egg")
		local str4 = "Egg"
		local n8 = 50
		local Egg = genv.__SenaV4VisualSAE and genv.__SenaV4VisualSAE.categories("Egg") or {}
		local v76 = Egg[1]

		v75:AddDropdown({Title = "Type", Content = "Egg shows in the Eggs tab, Pet under Pets. Both are fake and local-only.", Options = {"Egg", "Pet"}, Multi = false, Default = "Egg", Callback = fn144(function(arg)
			str4 = arg or "Egg"
		end)})

		v75:AddDropdown({Title = "Select Egg / Pet", Content = "Which egg or pet to spawn.", Options = Egg, Multi = false, Default = Egg[1], MaxVisible = 8, Callback = fn144(function(arg)
			v76 = arg
		end)})

		v75:AddSlider({Title = "Size / Flex", Content = "Bigger = heavier Kg & higher value (Kg = base weight x scale^3) AND a bigger egg in your hand. 50 hits the billions.", Min = 1, Max = 100, Default = 50, Increment = 1, Callback = fn144(function(arg)
			n8 = tonumber(arg) or 50
		end)})

		v75:AddButton({Title = "Hold in Hand", Content = "Spawns a model of it in your hand. Press again for more. (In-hand only - use the other button to also add it to All Items.)", Callback = fn144(function()
			local senaV4VisualSAE = genv.__SenaV4VisualSAE

			if senaV4VisualSAE then
				senaV4VisualSAE.spawn(str4, v76, n8, true)
			end
		end)})

		v75:AddButton({Title = "Add to Backpack (Kg)", Content = "Drops it in All Items (eggs) or Pets with a huge Kg for the inventory flex. Press again for more.", Callback = fn144(function()
			local senaV4VisualSAE = genv.__SenaV4VisualSAE

			if senaV4VisualSAE then
				senaV4VisualSAE.spawn(str4, v76, n8, false)
			end
		end)})

		v75:AddButton({Title = "Remove Egg / Pet Visuals", Content = "Takes every spawned fake egg/pet and held model out.", Callback = fn144(function()
			local senaV4VisualSAE = genv.__SenaV4VisualSAE

			if senaV4VisualSAE then
				senaV4VisualSAE.clear()
			end
		end)})
	end

	local function fn157(arg, arg2)
		v27()

		if type(arg) == "table" and arg.Value ~= nil then
			pcall(arg2, arg.Value)
		end
	end

	flag12 = false
	fn157(tbl24.speed, fn90)
	fn157(tbl24.stealMode, fn89)
	fn157(tbl24.antiTreadmill, fn83)
	fn157(tbl24.autoTreadmill, fn82)
	fn157(tbl24.treadmillUpgrade, fn88)
	fn157(tbl24.hopCooldown, fn87)
	fn157(tbl24.hopNoMatch, fn84)
	fn157(tbl24.privateServerMax, fn85)
	fn157(tbl24.privateServerAuto, fn86)

	fn157(tbl24.names, function(arg)
		fn91("names", "name", arg)
	end)

	fn157(tbl24.areas, function(arg)
		fn91("areas", "area", arg)
	end)

	fn157(tbl24.rarities, function(arg)
		fn91("rarities", "rarity", arg)
	end)

	fn157(tbl24.value, fn92)
	fn157(tbl24.autoIndex, fn149)
	fn157(tbl24.scrambleBuy, fn116)
	fn157(tbl24.scrambleBuyList, fn117)

	fn157(tbl24.wispAutoQuest, function(arg)
		senaV4Config.WispAutoQuest = arg == true
	end)

	fn157(tbl24.banjoAuto, function(arg)
		senaV4Config.BanjoAuto = arg == true
	end)

	fn157(tbl24.bloomAutoNet, function(arg)
		senaV4Config.ButterflyAutoNet = arg == true
	end)

	fn157(tbl24.bloomAutoCatch, function(arg)
		senaV4Config.ButterflyAutoCatch = arg == true
	end)

	fn157(tbl24.bloomEsp, function(arg)
		senaV4Config.ButterflyEsp = arg == true
	end)

	fn157(tbl24.bloomAutoTrade, function(arg)
		senaV4Config.ButterflyAutoTrade = arg == true
	end)

	fn157(tbl24.bloomAutoCraft, function(arg)
		senaV4Config.ButterflyAutoCraft = arg == true
	end)

	fn157(tbl24.bloomTiers, function(arg)
		local senaV4ButterflyRuntime = genv.__SenaV4ButterflyRuntime

		if senaV4ButterflyRuntime then
			senaV4ButterflyRuntime.setTiers(fn67(arg))
		end
	end)

	fn157(tbl24.bloomRecipe, function(arg)
		local senaV4ButterflyRuntime = genv.__SenaV4ButterflyRuntime

		if senaV4ButterflyRuntime then
			senaV4ButterflyRuntime.setRecipe(arg)
		end
	end)

	fn157(tbl24.bloomMode, function(arg)
		local senaV4ButterflyRuntime = genv.__SenaV4ButterflyRuntime

		if senaV4ButterflyRuntime then
			senaV4ButterflyRuntime.setMode(arg)
		end
	end)

	fn157(tbl24.noclip, fn113)
	fn157(tbl24.bottingMode, fn114)
	fn157(tbl24.antiCutscene, fn115)

	fn157(tbl24.waypoint, function(arg)
		v29 = arg
	end)

	fn157(tbl24.autoFavorite, fn101)
	fn157(tbl24.favoriteRule, fn102)
	fn157(tbl24.favoriteRarities, fn103)
	fn157(tbl24.favoriteSpecies, fn104)
	fn157(tbl24.autoFuse, fn109)
	fn157(tbl24.fuseRule, fn110)
	fn157(tbl24.fuseRarities, fn111)
	fn157(tbl24.fuseSpecies, fn112)
	fn157(tbl24.autoEquipBest, fn105)
	fn157(tbl24.autoClaimOffline, fn106)
	fn157(tbl24.autoBaseUpgrade, fn107)
	fn157(tbl24.autoClaimAlmanac, fn108)
	fn157(tbl24.mutations, fn93)
	fn157(tbl24.weight, fn94)
	fn157(tbl24.priority, fn95)
	fn157(tbl24.eggEsp, fn96)
	fn157(tbl24.espDetails, fn97)
	fn157(tbl24.espMinRarity, tbl10.applyEspMinRarity)
	fn157(tbl24.espMinValue, tbl10.applyEspMinValue)
	fn157(tbl24.backpackRates, fn99)
	fn157(tbl24.antiGuardKnockback, fn100)

	fn157(tbl24.placeRarity, function(arg)
		senaV4Config.PlaceRarities = fn67(arg)
	end)

	fn157(v21, function(arg)
		senaV4Config.SellNames = fn67(arg)
	end)

	fn157(v22, function(arg)
		senaV4Config.SellRarities = fn67(arg)
	end)

	fn157(v23, function(arg)
		senaV4Config.SellEggRarities = fn67(arg)
	end)

	fn157(tbl24.sellPetValue, fn129)
	fn157(tbl24.sellEggValue, fn130)
	fn157(tbl24.godMode, fn80)
	fn157(tbl24.antiAfk, fn141)
	fn157(tbl24.autoReconnect, fn142)
	fn157(tbl24.autoExecute, fn143)
	fn157(tbl24.antiHitGuard, fn140)
	fn157(tbl24.flyForCapture, fn135)
	fn157(tbl24.autoStealCapture, fn138)
	fn157(tbl24.instantGrab, fn136)
	fn157(tbl24.infiniteJump, fn139)
	fn157(tbl24.uncapFps, fn133)
	fn157(tbl24.startupBoost, fn131)
	fn157(tbl24.autoPlace, fn118)
	fn157(tbl24.autoHatch, fn119)
	fn157(tbl24.mutationChoice, fn122)
	fn157(tbl24.mutationSpecies, fn123)
	fn157(tbl24.mutationRarity, fn124)
	fn157(tbl24.mutationMinValue, fn125)
	fn157(tbl24.mutationRetry, fn126)
	fn157(tbl24.autoMutation, fn120)
	fn157(tbl24.taskOrder, fn156)
	fn157(tbl24.stealHold, fn79)

	fn157(tbl24.raceClaim, function(arg)
		senaV4Config.RaceClaim = arg == true
	end)

	fn157(tbl24.raceBuyList, function(arg)
		senaV4Config.RaceBuyList = fn67(arg)
	end)

	fn157(tbl24.raceBuy, function(arg)
		senaV4Config.RaceBuy = arg == true
	end)

	fn157(tbl24.raceAuto, function(arg)
		senaV4Config.RaceAuto = arg == true
	end)

	fn157(tbl24.starAlert, function(arg)
		senaV4Config.StarAlert = arg == true
	end)

	fn157(tbl24.starAutoCatch, function(arg)
		senaV4Config.StarAutoCatch = arg == true
	end)

	fn157(tbl24.scrambleTradeInBanners, fn98)

	fn157(tbl24.scrambleTradeInReroll, function(arg)
		senaV4Config.ScrambleTradeInReroll = arg == true
	end)

	fn157(tbl24.scrambleTradeInTrade, function(arg)
		senaV4Config.ScrambleTradeInTrade = arg == true
	end)

	fn157(tbl24.scrambleBossAuto, function(arg)
		senaV4Config.ScrambleBossAuto = arg == true
		local senaV4ScrambleBoss = genv.__SenaV4ScrambleBoss

		if senaV4ScrambleBoss and type(senaV4ScrambleBoss.setEnabled) == "function" then
			pcall(senaV4ScrambleBoss.setEnabled, senaV4ScrambleBoss, arg == true)
		end
	end)

	if tbl24.taskOrder and type(tbl24.taskOrder.SetStatus) == "function" then
		local taskOrder = tbl24.taskOrder

		task.spawn(function()
			while fn2() do
				for i, v70 in ipairs(senaV4TaskLadder.DEFAULT) do
					local v71 = senaV4TaskLadder.enabled(v70)

					if type(taskOrder.SetVisible) == "function" then
						pcall(taskOrder.SetVisible, taskOrder, v70, v71)
					end

					if v71 then
						local v72, v73 = senaV4TaskLadder.describe(v70)
						pcall(taskOrder.SetStatus, taskOrder, v70, v72, v73)
					end
				end

				task.wait(0.5)
			end
		end)
	end

	fn157(tbl24.autoRingEvent, fn121)
	fn157(tbl24.autoSell, fn127)
	fn157(tbl24.autoSellEgg, fn128)
	fn157(tbl24.stealPlayerRarities, fn146)
	fn157(tbl24.stealPlayerValue, fn148)
	fn157(tbl24.webhookUrl, fn151)
	fn157(tbl24.webhookRarities, fn152)
	fn157(tbl24.webhookValue, fn153)
	fn157(tbl24.webhookEnabled, fn150)

	fn157(tbl24.webhookDisconnect, function(arg)
		senaV4Config.WebhookDisconnect = arg == true
	end)

	fn157(tbl24.helpFriend, function(arg)
		senaV4Config.HelpFriend = arg == true
	end)

	fn157(tbl24.lowSpeedBoost, function(arg)
		senaV4Config.LowSpeedBoost = arg == true
	end)

	fn157(tbl24.autoSteal, fn78)
	fn157(tbl24.stealPlayers, fn145)
	tbl13.hopWindow = v28

	do
		local hopHunt = tbl13.hopHunt

		if hopHunt and hopHunt.state and (hopHunt.state.active or hopHunt.state.watch) then
			pcall(function()
				v28:LoadConfig("HopSession")
			end)

			task.delay(2, function()
				pcall(hopHunt.open)
			end)
		end
	end

	genv.__SenaV4HubShutdown = function()
		if senaV4PlayerSteal then
			pcall(senaV4PlayerSteal.setEnabled, senaV4PlayerSteal, false)
		end

		for i, v70 in ipairs({"AutoSteal", "AutoPlace", "AutoHatch", "AutoMutation", "AutoRingEvent", "AutoSell", "AutoSellEgg", "StealPlayers", "ScrambleBossAuto", "RaceAuto", "RaceClaim", "RaceBuy", "StarAutoCatch", "ButterflyAutoCatch", "ButterflyAutoNet", "ButterflyAutoTrade", "ButterflyAutoCraft"}) do
			senaV4Config[v70] = false
		end

		if v13 then
			pcall(v13.setEnabled, v13, false)
		end

		local senaV4ScrambleBoss = genv.__SenaV4ScrambleBoss

		if senaV4ScrambleBoss and type(senaV4ScrambleBoss.setEnabled) == "function" then
			pcall(senaV4ScrambleBoss.setEnabled, senaV4ScrambleBoss, false)
		end

		local value = v28 and rawget(v28, "Gui") or nil
		local tbl29 = {game:GetService("CoreGui")}

		pcall(function()
			if gethui then
				table.insert(tbl29, gethui())
			end
		end)

		for i, v70 in ipairs(tbl29) do
			for i2, child in ipairs(v70:GetChildren()) do
				if child == value or child:IsA("ScreenGui") and (child.Name == "Chloeex" or child.Name == "ToggleUIButton") then
					pcall(child.Destroy, child)
				end
			end
		end
	end

	flag = true
end

fn66()
