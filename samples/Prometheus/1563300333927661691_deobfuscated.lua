-- This file was generated at discord.gg/syncrypt

local unpack_ = unpack or table.unpack
local t1 = {
	value1 = game:GetService("Players"),
	value2 = game:GetService("RunService"),
	value3 = game:GetService("UserInputService")
}
local game_ = game

t1.value4 = game_.GetService(game_, "VirtualInputManager")
t1.value5 = game:GetService("TweenService")
t1.value6 = game:GetService("ReplicatedStorage")
t1.value7 = t1.value1.LocalPlayer

local uDim2 = UDim2.new(0, 300, 0, 560)

t1.value8 = UDim2.new(0, 300, 0, 470)
t1.value9 = _G.__DeathBallAutoParry

local value9 = t1.value9

if type(value9) == "table" then
	local v6, v7, v8 = ipairs(t1.value9.Connections or {})

	while true do
		local v9

		v8, v9 = v6(v7, v8)

		if not v8 then
			break
		end

		pcall(function()
			v9:Disconnect()
		end)
	end

	if t1.value9.Gui then
		pcall(function()
			t1.value9.Gui:Destroy()
		end)
	end

	if t1.value9.NotifGui then
		pcall(function()
			t1.value9.NotifGui:Destroy()
		end)
	end
end

_G.__DBGen = (_G.__DBGen or 0) + 1
t1.value10 = _G.__DBGen
t1.value11 = {}
_G.__DeathBallAutoParry = {
	Connections = t1.value11,
	Gui = nil,
	Gen = t1.value10
}
t1.value12 = {
	AutoParry = true,
	AutoParryKey = Enum.KeyCode.R,
	AutoSpam = false,
	AutoSpamKey = Enum.KeyCode.E,
	AutoSpamRate = 0.05,
	AIMovement = false,
	AIMovementKey = nil,
	FollowBall = false,
	JumpInterval = 3,
	CameraRotation = true,
	CameraRotationKey = nil,
	CameraRoamTime = 3,
	CameraLockTime = 3,
	CameraSpeed = 1,
	CameraAggression = 1,
	AutoReady = false,
	AutoReadyKey = nil,
	AutoReadyIdle = true,
	AutoReadyDelay = 0,
	AutoReadyEdge = 0.1,
	AutoReadyProbe = 12,
	AutoReadyWallClear = 2.5,
	AutoSpamParry = true,
	PerfectParry = true,
	Range = 0.05,
	DirectPoint = 15,
	PingCompensationMultiplier = 0.5,
	PerfectParryMultiplier = 1,
	UIHideKey = Enum.KeyCode.RightControl,
	DiscordURL = "http://discord.gg/Cj7t4Xvzpj"
}

local function v10(p1)
	if p1 then
		return p1.FindFirstChildWhichIsA(p1, "Humanoid")
	end
end
local function v11(p2)
	local now = os.clock()

	return function()
		return (p2 or 0) <= os.clock() - now
	end
end

t1.value13 = getrawmetatable or getmetatable
t1.value14 = setrawmetatable or setmetatable

local function v13(...)
	local t2 = { ... }
	local t3 = {}

	for _, v in pairs(t2) do
		if (type(v) == "table" and true or type(v) == "userdata") and not t3[v] then
			pcall(function()
				local v18 = t1.value13(v)

				if not v18 then
					return
				end

				t3[v] = v18
				t1.value14(v, {})
			end)
		end
	end

	return function()
		for _, v in pairs(t2) do
			if t3[v] then
				pcall(function()
					local v21 = t3[v]

					t1.value14(v, v21)
				end)
				t3[v] = nil
			end
		end
	end
end

function t1.value15(p3, p4, p5, p6)
	local v22 = p3 - p4

	return (v22 - v22.Unit * (p6 or 0)) / p5.Magnitude
end
function t1.value16(p7)
	local pairs_ = pairs
	local n1 = 0
	local n2 = 0

	for _ in pairs_(p7) do
		n1 = n1 + 1
		pairs_ = n1
	end

	if p7.ETA then
		for _, value in pairs(p7.ETA.Values) do
			if value.Magnitude <= p7.ETA.Threshold then
				n2 = n2 + 1

				break
			end
		end
	end

	if not p7.Dot then
		v33 = n1 > 0

		if not v33 then
			return v33
		end

		if n2 > 0 then
			v33 = n1 == n2
		else
			v33 = false
		end

		return v33
	end

	for _, value in pairs(p7.Dot.Values) do
		if value <= p7.Dot.Threshold then
			n2 = n2 + 1

			break
		end
	end

	local v31 = n1 > 0

	if not v31 then
		return v31
	end

	if n2 > 0 then
		v31 = n1 == n2
	else
		v31 = false
	end

	return v31
end
function t1.value17()
	t1.value4:SendMouseButtonEvent(0, 0, 0, true, game, 0)
	t1.value4:SendMouseButtonEvent(0, 0, 0, false, game, 0)
end

t1.value18 = {
	Value = 0.05,
	At = 0
}

local function v32()
	local now = os.clock()

	if now - t1.value18.At < 0.25 then
		return t1.value18.Value
	end

	t1.value18.At = now

	local networkPing = nil

	local function v35()
		networkPing = t1.value7:GetNetworkPing()
	end

	pcall(v35)

	if not (not networkPing or networkPing <= 0) then
		v37 = networkPing or 0.05
		t1.value18.Value = math.clamp(v37, 0, 1)

		return t1.value18.Value
	end

	pcall(function()
		networkPing = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() / 1000
	end)

	local v36 = networkPing or 0.05

	t1.value18.Value = math.clamp(v36, 0, 1)

	return t1.value18.Value
end

t1.value19 = _G.__DeathBallBalls

if not t1.value19 then
	t1.value19 = {}
	_G.__DeathBallBalls = t1.value19
end

t1.value20 = 0

function t1.value21()
	local v38 = nil

	local function v39()
		local next_ = next
		local v40, key = getreg()

		while true do
			local v42

			key, v42 = next_(v40, key)

			if not key then
				break
			end

			if typeof(v42) == "table" then
				local next_2 = next
				local key2 = nil

				while true do
					local v45

					key2, v45 = next_2(v42, key2)

					if not key2 then
						break
					end

					local v46

					if typeof(v45) == "Instance" then
						v46 = not v45.Parent
					else
						v46 = false
					end

					if v46 then
						local v47 = v38

						table.insert(v47, v45)
					end
				end
			end
		end
	end

	v38 = {}
	pcall(v39)

	return v38
end

t1.value22 = nil

function t1.value22(p8)
	local function v48(p9)
		if type(p9) == "table" then
			local Render = p9.Render

			if type(Render) == "function" then
				return p9
			else
				for _, v in pairs(p9) do
					local v52

					if type(v) == "table" then
						local Render2 = v.Render

						v52 = type(Render2) == "function"
					else
						v52 = false
					end

					if v52 then
						return v
					end
				end

				return
			end
		end
	end

	local ok, result = pcall(debug.getupvalues, p8)

	return ok and v48(result) or v48(p8)
end
function t1.value23()
	for _, v in pairs(t1.value21()) do
		local isModuleScript = v:IsA("ModuleScript")

		if isModuleScript then
			isModuleScript = v.Name:match("lBall")
		end

		if isModuleScript then
			local ok, result = pcall(require, v)

			if ok then
				local v61 = t1.value22(result)
				local v62

				if v61 then
					local Render = v61.Render

					v62 = type(Render) == "function"
				else
					v62 = v61
				end

				if v62 then
					if not _G.__DeathBallBaseRender then
						_G.__DeathBallBaseRender = v61.Render
					end

					local __DeathBallBaseRender = _G.__DeathBallBaseRender

					local function render(p10)
						local v66 = t1.value19[p10]

						if not v66 then
							v66 = {}
							t1.value19[p10] = v66

							if p10.Body then
								local function v67()
									p10.Body.Destroying:Connect(function()
										t1.value19[p10] = nil
									end)
								end

								pcall(v67)
							end
						end

						v66.Object = p10.Body
						v66.TargetUserId = p10.TargetUserId

						local TargetUserId = p10.TargetUserId

						if TargetUserId then
							TargetUserId = t1.value1:GetPlayerByUserId(tonumber(p10.TargetUserId))
						end

						v66.Target = TargetUserId
						v66.isPhasingThrough = p10.isPhasingThrough
						v66.Velocity = p10.Velocity
						v66.Position = p10.Position

						local now = os.clock()
						local value20

						if t1.value20 > 0 then
							value20 = t1.value20
						else
							value20 = false
						end

						local v71 = now - (value20 or now)
						local Position = v66.Position - v66.LastPosition or v66.Position

						if v71 > 0 then
							v66.ObjectVelocity = Position / (v71 or 1)
							v66.LastPosition = v66.Position
							t1.value20 = now

							return __DeathBallBaseRender(p10)
						end

						v71 = false
						v66.ObjectVelocity = Position / (v71 or 1)
						v66.LastPosition = v66.Position
						t1.value20 = now

						return __DeathBallBaseRender(p10)
					end

					local v73 = v13(v61)

					v61.Render = render
					v73()
					_G.__DeathBallHook = render

					return true
				end
			end
		end
	end

	return false
end

task.spawn(function()
	while _G.__DBGen == t1.value10 do
		pcall(t1.value23)
		task.wait(1)
	end
end)
t1.value24 = nil
t1.value25 = nil
t1.value25 = {
	Running = false
}

function t1.value26()
	t1.value25.Running = false

	if not t1.value24 then
		return
	end

	t1.value24.Visible = false
end
function t1.value27()
	if t1.value24 then
		t1.value24.Visible = true
	end

	if t1.value25.Running then
		return
	end

	t1.value25.Running = true
	task.spawn(function()
		while true do
			local Running = t1.value25.Running

			if Running then
				Running = _G.__DBGen == t1.value10
			end

			if not Running then
				t1.value25.Running = false

				return
			end

			t1.value17()
			task.wait(t1.value12.AutoSpamRate)
		end
	end)
end

t1.value28 = "DeathBallAIMovement"
t1.value29 = {
	Running = false,
	Direction = Vector3.zero,
	NextTurn = 0,
	NextJump = 0,
	AvoidUntil = 0,
	AvoidDirection = Vector3.zero
}
t1.value30 = nil
t1.value2:UnbindFromRenderStep(t1.value28)

function t1.value31(p11)
	local huge = math.huge
	local v76 = nil

	for _, v in pairs(t1.value19) do
		local Object = v.Object
		local v80 = typeof(Object) == "Instance"

		if v80 then
			v80 = Object:IsA("BasePart") and Object.Parent

			if v80 then
				v80 = Object.Transparency < 1
			end
		end

		if v80 then
			local Position = v.Position

			if typeof(Position) ~= "Vector3" then
				Position = Object.Position
			end

			local Magnitude = (Position - p11.Position).Magnitude

			if Magnitude < huge then
				v76 = Position
				huge = Magnitude
			end
		end
	end

	return v76
end
function t1.value32()
	t1.value29.Running = false
	t1.value2:UnbindFromRenderStep(t1.value28)

	local Character = t1.value7.Character
	local v84

	if Character then
		v84 = Character.FindFirstChildWhichIsA(Character, "Humanoid")
	else
		v84 = nil
	end

	if not v84 then
		return
	end

	v84:Move(Vector3.zero, false)
end

t1.value30 = false

function t1.value33()
	if not (t1.value30 and t1.value12.AIMovement) then
		return
	end

	if t1.value29.Running then
		return
	end

	t1.value29.Running = true
	t1.value29.NextTurn = 0
	t1.value29.NextJump = os.clock() + t1.value12.JumpInterval
	t1.value29.AvoidUntil = 0
	t1.value2:UnbindFromRenderStep(t1.value28)

	local value2 = t1.value2
	local value28 = t1.value28
	local Character = Enum.RenderPriority.Character

	value2.BindToRenderStep(value2, value28, Character.Value + 1, function()
		if not t1.value29.Running or (not t1.value30 or (not t1.value12.AIMovement or _G.__DBGen ~= t1.value10)) then
			t1.value32()

			return
		end

		local v88 = v10(t1.value7.Character)
		local RootPart

		if v88 then
			RootPart = v88.RootPart
		else
			RootPart = v88
		end

		if not v88 or (not RootPart or v88.Health <= 0) then
			return
		end

		local now = os.clock()
		local vector3 = Vector3.zero
		local value31

		if t1.value12.FollowBall then
			value31 = t1.value31

			local v93 = value31(RootPart)

			if v93 then
				local v94 = v93 - RootPart.Position

				value31 = Vector3.new

				local v95 = value31(v94.X, 0, v94.Z)

				if v95.Magnitude > 5 then
					vector3 = v95.Unit
					value31 = vector3
				end
			end
		else
			if t1.value29.NextTurn <= now then
				t1.value29.NextTurn = now + math.random(8, 16) / 10

				local v96 = math.random() * 3.141592653589793 * 2

				t1.value29.Direction = Vector3.new(math.cos(v96), 0, (math.sin(v96)))
			end

			local Direction = t1.value29.Direction

			value31 = vector3
			vector3 = Direction
		end

		if vector3.Magnitude > 0 then
			local raycastParams = RaycastParams.new()

			raycastParams.FilterType = Enum.RaycastFilterType.Exclude
			raycastParams.FilterDescendantsInstances = { t1.value7.Character }
			raycastParams.RespectCanCollide = true

			local hit = workspace:Raycast(RootPart.Position, vector3 * 7, raycastParams)

			if hit then
				hit = hit.Instance.CanCollide
			end

			if hit then
				if t1.value12.FollowBall then
					if t1.value29.AvoidUntil <= now then
						local vector32 = Vector3.new(-vector3.Z, 0, vector3.X)
						local hit2 = workspace:Raycast(RootPart.Position, vector32 * 7, raycastParams)
						local hit3 = workspace:Raycast(RootPart.Position, -vector32 * 7, raycastParams)
						local value29 = t1.value29
						local s1 = "AvoidDirection"

						if hit2 then
							hit2 = not hit3
						end

						if hit2 then
							hit2 = -vector32
						end

						value29[s1] = hit2 or vector32
						t1.value29.AvoidUntil = now + 0.45
					end

					vector3 = t1.value29.AvoidDirection
				else
					t1.value29.Direction = -vector3
					vector3 = t1.value29.Direction
					t1.value29.NextTurn = now + 0.4
				end
			else
				t1.value29.AvoidUntil = 0
			end
		end

		v88:Move(vector3, false)

		local v105

		if t1.value12.JumpInterval > 0 then
			v105 = t1.value29.NextJump <= now
		else
			v105 = false
		end

		if not v105 then
			return
		end

		t1.value29.NextJump = now + t1.value12.JumpInterval

		if v88.FloorMaterial == Enum.Material.Air then
			return
		end

		v88.Jump = true
	end)
end

t1.value34 = workspace.CurrentCamera
t1.value35 = {
	Mode = "roam",
	Timer = 0,
	Target = nil,
	ChangeYaw = 0,
	ChangePitch = 0
}

function t1.value36()
	local AIMovement = t1.value12.AIMovement

	if not AIMovement then
		return AIMovement
	end

	AIMovement = t1.value12.CameraRotation

	if not AIMovement then
		return AIMovement
	end

	AIMovement = t1.value30 and t1.value12.CameraRoamTime > 0 and true or t1.value12.CameraLockTime > 0

	return AIMovement
end
function t1.value37()
	local ipairs_ = ipairs
	local t4 = {}

	for _, player in ipairs_(t1.value1:GetPlayers()) do
		local v111 = player ~= t1.value7

		if v111 then
			v111 = player.Character

			if v111 then
				v111 = player.Character:FindFirstChild("HumanoidRootPart")

				if v111 then
					v111 = player.Character:FindFirstChildWhichIsA("Humanoid")

					if v111 then
						v111 = player.Character:FindFirstChildWhichIsA("Humanoid").Health > 0
					end
				end
			end
		end

		if v111 then
			ipairs_ = #t4 + 1
			t4[ipairs_] = player
		end
	end

	if #t4 == 0 then
		return nil
	else
		return t4[math.random(1, #t4)]
	end
end
function t1.value38()
	local CameraAggression = t1.value12.CameraAggression
	local v113 = math.clamp(CameraAggression, 0, 4)

	t1.value35.ChangeYaw = (math.random() * 2 - 1) * (v113 + 1)
	t1.value35.ChangePitch = (math.random() * 2 - 1) * 0.5 * (v113 * 0.75 + 1)
	t1.value35.Timer = t1.value12.CameraRoamTime
end
function t1.value39()
	t1.value35.Target = t1.value37()
	t1.value35.Timer = t1.value12.CameraLockTime
end

t1.value11[#t1.value11 + 1] = t1.value2.RenderStepped:Connect(function(dt)
	if not t1.value36() then
		return
	end

	if not t1.value34 then
		t1.value34 = workspace.CurrentCamera

		if not t1.value34 then
			return
		end
	end

	local Character = t1.value7.Character

	if not (Character and Character:FindFirstChild("HumanoidRootPart")) then
		return
	end

	local CameraSpeed = t1.value12.CameraSpeed
	local v116 = math.clamp(CameraSpeed, 0.05, 10)

	t1.value35.Timer = t1.value35.Timer - dt

	if t1.value35.Timer <= 0 then
		if t1.value35.Mode == "roam" then
			if t1.value12.CameraLockTime > 0 then
				t1.value35.Mode = "lock"
				t1.value39()
			else
				t1.value38()
			end
		elseif t1.value12.CameraRoamTime > 0 then
			t1.value35.Mode = "roam"
			t1.value38()
		else
			t1.value39()
		end
	end

	if t1.value35.Mode == "roam" then
		t1.value34.CFrame = t1.value34.CFrame * CFrame.Angles(0, t1.value35.ChangeYaw * dt * 0.6 * v116, 0) * CFrame.Angles(t1.value35.ChangePitch * dt * 0.4 * v116, 0, 0)

		return
	end

	if t1.value35.Mode ~= "lock" then
		return
	end

	if not (t1.value35.Target and (t1.value35.Target.Character and t1.value35.Target.Character:FindFirstChild("HumanoidRootPart"))) then
		t1.value35.Target = t1.value37()

		if not t1.value35.Target then
			t1.value35.Mode = "roam"
			t1.value38()

			return
		end
	end

	local Position = t1.value35.Target.Character.HumanoidRootPart.Position
	local cFrame = CFrame.new(t1.value34.CFrame.Position, Position)

	t1.value34.CFrame = t1.value34.CFrame:Lerp(cFrame, math.min(dt * 6 * v116, 1))
end)
t1.value40 = "DeathBallAutoReady"
t1.value41 = {
	0,
	-0.35,
	0.35,
	-0.75,
	0.75,
	-1.15,
	1.15
}
t1.value42 = 11
t1.value43 = {
	Running = false,
	Target = nil,
	Steer = Vector3.zero,
	PickTime = 0,
	NextPick = 0,
	NextJump = 0,
	StallAt = 0,
	LastPos = nil,
	Parked = false,
	ParkUntil = 0,
	SlideDir = nil,
	SlideHold = 0
}

local vector3 = Vector3.new(605, 285, -798)
local vector32 = Vector3.new(590, 284, -768)
local vector33 = Vector3.new(552, 284, -768)
local t5 = { Vector3.new(536, 285, -798) }

t1.value44 = nil
t1.value45 = {
	vector3,
	vector32,
	vector33,
	unpack_(t5)
}

function t1.value46()
	local raycastParams = RaycastParams.new()

	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.FilterDescendantsInstances = { t1.value7.Character }
	raycastParams.RespectCanCollide = true

	return raycastParams
end
function t1.value47(p12, p13)
	local v124 = math.cos(p13)
	local v125 = math.sin(p13)

	return Vector3.new(p12.X * v124 - p12.Z * v125, 0, p12.X * v125 + p12.Z * v124)
end
function t1.value48(p14, p15)
	local vector34 = Vector3.zero
	local ipairs_ = ipairs
	local value1 = t1.value1

	for _, player in ipairs_(value1.GetPlayers(value1)) do
		if player ~= t1.value7 then
			local Character = player.Character

			if Character then
				Character = Character:FindFirstChild("HumanoidRootPart")
			end

			if Character then
				local v132 = Character.Position - p14.Position
				local vector35 = Vector3.new(v132.X, 0, v132.Z)
				local Magnitude = vector35.Magnitude

				if Magnitude >= 0.1 and Magnitude <= 6 then
					local Unit = vector35.Unit

					if Unit:Dot(p15) >= 0.35 then
						vector34 = vector34 - Unit * ((1 - Magnitude / 6) * 0.6)
					end
				end
			end
		end
	end

	return vector34
end
function t1.value49()
	local v136 = math.clamp(t1.value12.AutoReadyEdge, 0, 0.45)
	local v137 = t1.value45[1]
	local v138 = t1.value45[2]
	local v139 = t1.value45[3]
	local v140 = t1.value45[4]
	local v141 = t1.value46()

	for _ = 1, 12 do
		local v143 = math.random()
		local math_ = math
		local v145 = v136 + v143 * (1 - 2 * v136)
		local v146 = v136 + math_.random() * (1 - 2 * v136)
		local Lerp = v140.Lerp
		local v148 = v137.Lerp(v137, v138, v146)
		local v149 = v148.Lerp(v148, Lerp(v140, v139, v146), v145)
		local hit = workspace:Raycast(v149 + Vector3.new(0, 25, 0), Vector3.new(0, -250, 0), v141)
		local CanCollide

		if hit then
			CanCollide = hit.Instance.CanCollide
		else
			CanCollide = hit
		end

		if CanCollide and not workspace:Raycast(hit.Position + Vector3.new(0, 2, 0), Vector3.new(0, 4, 0), v141) then
			return hit.Position
		end
	end

	local v152 = v137:Lerp(v139, 0.5)
	local hit = workspace:Raycast(v152 + Vector3.new(0, 25, 0), Vector3.new(0, -250, 0), v141)

	if not hit then
		return hit or v152
	end

	hit = hit.Position

	return hit or v152
end
function t1.value50()
	t1.value43.Running = false
	t1.value43.Target = nil
	t1.value43.Steer = Vector3.zero
	t1.value43.LastPos = nil
	t1.value43.Parked = false
	t1.value43.ParkUntil = 0
	t1.value43.SlideDir = nil
	t1.value43.SlideHold = 0
	t1.value2:UnbindFromRenderStep(t1.value40)

	local Character = t1.value7.Character
	local v155

	if Character then
		v155 = Character.FindFirstChildWhichIsA(Character, "Humanoid")
	else
		v155 = nil
	end

	if not v155 then
		return
	end

	v155:Move(Vector3.zero, false)
end
function t1.value51()
	if t1.value43.Running or (t1.value30 or not t1.value12.AutoReady) then
		return
	end

	t1.value43.Running = true
	t1.value43.Target = nil
	t1.value43.Steer = Vector3.zero
	t1.value43.PickTime = 0
	t1.value43.NextPick = 0
	t1.value43.NextJump = 0
	t1.value43.StallAt = 0
	t1.value43.LastPos = nil
	t1.value43.Parked = false
	t1.value43.ParkUntil = 0
	t1.value43.SlideDir = nil
	t1.value43.SlideHold = 0
	t1.value2:UnbindFromRenderStep(t1.value40)

	local value2 = t1.value2
	local value40 = t1.value40
	local Character = Enum.RenderPriority.Character

	value2.BindToRenderStep(value2, value40, Character.Value + 1, function(p16)
		if not t1.value43.Running or (not t1.value12.AutoReady or (t1.value30 or _G.__DBGen ~= t1.value10)) then
			t1.value50()

			return
		end

		local v159 = v10(t1.value7.Character)
		local RootPart

		if v159 then
			RootPart = v159.RootPart
		else
			RootPart = v159
		end

		if not v159 or (not RootPart or v159.Health <= 0) then
			t1.value43.Target = nil
			t1.value43.Steer = Vector3.zero
			t1.value43.Parked = false

			return
		end

		local now = os.clock()

		if t1.value43.Parked then
			v159:Move(Vector3.zero, false)
			t1.value43.Steer = Vector3.zero

			if not (t1.value43.ParkUntil <= now) then
				return
			end

			t1.value43.Parked = false
			t1.value43.ParkUntil = 0
			t1.value43.NextPick = now
		end

		if not t1.value43.Target then
			if now < t1.value43.NextPick then
				v159:Move(Vector3.zero, false)

				return
			end

			t1.value43.Target = t1.value49()
			t1.value43.PickTime = now
			t1.value43.StallAt = now
			t1.value43.LastPos = RootPart.Position
			t1.value43.Steer = Vector3.zero
			t1.value43.SlideDir = nil
			t1.value43.SlideHold = 0
		end

		local v162 = t1.value43.Target - RootPart.Position
		local vector34 = Vector3.new(v162.X, 0, v162.Z)
		local Magnitude = vector34.Magnitude

		if Magnitude <= 3 then
			t1.value43.Target = nil
			t1.value43.Steer = Vector3.zero
			t1.value43.SlideDir = nil
			t1.value43.SlideHold = 0
			v159:Move(Vector3.zero, false)

			if t1.value12.AutoReadyIdle then
				t1.value43.Parked = true

				if t1.value12.AutoReadyDelay > 0 then
					t1.value43.ParkUntil = now + t1.value12.AutoReadyDelay

					return
				else
					t1.value43.ParkUntil = math.huge

					return
				end
			else
				t1.value43.Parked = false
				t1.value43.NextPick = now

				return
			end
		end

		if (RootPart.Position - t1.value43.LastPos or RootPart.Position).Magnitude > 0.5 then
			t1.value43.LastPos = RootPart.Position
			t1.value43.StallAt = now
		elseif now - t1.value43.StallAt > 2.5 then
			t1.value43.Target = nil
			t1.value43.NextPick = now
			t1.value43.Steer = Vector3.zero
			t1.value43.SlideDir = nil
			v159:Move(Vector3.zero, false)

			return
		end

		local v165 = t1.value46()
		local v166 = RootPart.Position + Vector3.new(0, 2, 0)
		local Unit = vector34.Unit
		local AutoReadyProbe = t1.value12.AutoReadyProbe
		local v169 = math.max(AutoReadyProbe, 1)
		local v170 = math.min(Magnitude, v169)
		local hit = workspace:Raycast(v166, Unit * v170, v165)
		local CanCollide

		if hit then
			CanCollide = hit.Instance.CanCollide
		else
			CanCollide = hit
		end

		local v173

		if CanCollide then
			local v174 = hit.Distance - 1

			v173 = math.max(v174, 0)
		else
			v173 = v170
		end

		local v175 = false
		local v176 = nil
		local Unit2

		if v173 < t1.value12.AutoReadyWallClear then
			v175 = true

			if not t1.value43.SlideDir or t1.value43.SlideHold <= now then
				local vector35 = Vector3.new(-Unit.Z, 0, Unit.X)
				local hit2 = workspace:Raycast(v166, vector35 * 5, v165)
				local hit3 = workspace:Raycast(v166, -vector35 * 5, v165)
				local n3 = 5
				local n4 = 5
				local CanCollide2

				if hit2 then
					CanCollide2 = hit2.Instance.CanCollide
				else
					CanCollide2 = hit2
				end

				if CanCollide2 then
					local v184 = hit2.Distance - 1

					n4 = math.max(v184, 0)
				end

				local CanCollide3

				if hit3 then
					CanCollide3 = hit3.Instance.CanCollide
				else
					CanCollide3 = hit3
				end

				if CanCollide3 then
					local v186 = hit3.Distance - 1

					n3 = math.max(v186, 0)
				end

				local value43 = t1.value43
				local s2 = "SlideDir"
				local v189

				if n3 <= n4 then
					v189 = vector35
				else
					v189 = false
				end

				value43[s2] = v189 or -vector35
				t1.value43.SlideHold = now + 0.5
			end

			local v190 = t1.value43.SlideDir * 0.85 + Unit * 0.15

			if v190.Magnitude > 0.001 then
				Unit2 = v190.Unit
			else
				Unit2 = t1.value43.SlideDir
			end

			t1.value43.StallAt = now
		else
			t1.value43.SlideDir = nil
			t1.value43.SlideHold = 0
			Unit2 = Unit
		end

		local v191 = nil

		if not v175 then
			local vector35 = Vector3.zero
			local v193 = Unit
			local n5 = -1
			local n6 = 0

			for i, v in ipairs(t1.value41) do
				local v198 = t1.value47(Unit, v)
				local hit2 = workspace:Raycast(v166, v198 * v170, v165)
				local CanCollide2

				if hit2 then
					CanCollide2 = hit2.Instance.CanCollide
				else
					CanCollide2 = hit2
				end

				local v201

				if CanCollide2 then
					local v202 = hit2.Distance - 1

					v201 = math.max(v202, 0)

					if i == 1 then
						v191 = hit2
					end

					local v203 = i == 1

					if v203 then
						if hit2.Normal.Y >= 0.6 then
							v203 = hit2.Distance <= 3.5
						else
							v203 = false
						end
					end

					if not v203 then
						hit2 = v176
					end
				else
					hit2 = v176
					v201 = v170
				end

				if n5 < v201 then
					v193 = v198
					n5 = v201
				end

				local v204 = v201 / v170 * math.cos(v)

				if v204 > 0 then
					vector35 = vector35 + v198 * v204
					n6 = n6 + v204
					v176 = hit2
				else
					v176 = hit2
				end
			end

			if n6 > 0.05 then
				v193 = vector35 / n6
			end

			local vector36 = Vector3.new(v193.X, 0, v193.Z)

			if vector36.Magnitude > 0.001 then
				vector36 = vector36.Unit
			end

			local v206 = vector36 + t1.value48(RootPart, Unit)

			if v206.Magnitude > 0.001 then
				Unit2 = v206.Unit
			else
				Unit2 = Unit
			end
		end

		if v176 then
			if t1.value43.NextJump <= now then
				v176 = v159.FloorMaterial ~= Enum.Material.Air
			else
				v176 = false
			end
		end

		if v176 then
			t1.value43.NextJump = now + 0.35
			v159.Jump = true
		end

		if v191 then
			if v191.Normal.Y >= 0.6 then
				v191 = v191.Distance <= 3.5
			else
				v191 = false
			end
		end

		if v191 then
			local v207

			if t1.value43.NextJump <= now then
				v207 = v159.FloorMaterial ~= Enum.Material.Air
			else
				v207 = false
			end

			if v207 then
				t1.value43.NextJump = now + 0.6
				v159.Jump = true
			end
		end

		local v208 = RootPart.Position + Unit * math.min(Magnitude, 4)
		local v209 = not workspace:Raycast(v208 + Vector3.new(0, 4, 0), Vector3.new(0, -12, 0), v165)

		if v209 then
			if t1.value43.NextJump <= now then
				v209 = v159.FloorMaterial ~= Enum.Material.Air
			else
				v209 = false
			end
		end

		local Unit3

		if not v209 then
			v218 = Vector3.new(Unit2.X, 0, Unit2.Z)

			if v218.Magnitude > 0.001 then
				Unit3 = v218.Unit
			else
				Unit3 = Vector3.zero
			end

			v219 = -t1.value42 * math.min(p16, 0.1)
			v220 = 1 - math.exp(v219)
			t1.value43.Steer = t1.value43.Steer:Lerp(Unit3, v220)

			if t1.value43.Steer.Magnitude > 0.001 then
				v159:Move(t1.value43.Steer.Unit, false)
			else
				v159:Move(Vector3.zero, false)
			end

			return
		end

		t1.value43.NextJump = now + 0.6
		v159.Jump = true

		local vector35 = Vector3.new(Unit2.X, 0, Unit2.Z)

		if vector35.Magnitude > 0.001 then
			Unit3 = vector35.Unit
		else
			Unit3 = Vector3.zero
		end

		local v212 = -t1.value42 * math.min(p16, 0.1)
		local v213 = 1 - math.exp(v212)

		t1.value43.Steer = t1.value43.Steer:Lerp(Unit3, v213)

		if t1.value43.Steer.Magnitude > 0.001 then
			v159:Move(t1.value43.Steer.Unit, false)
		else
			v159:Move(Vector3.zero, false)
		end
	end)
end

t1.value44 = nil
t1.value52 = nil

function t1.value53()
	local function v214()
		if t1.value44 then
			return t1.value44.IsInMatch()
		end

		t1.value44 = require(t1.value6:WaitForChild("Modules"):WaitForChild("AfterMatch"))

		return t1.value44.IsInMatch()
	end

	local ok, result = pcall(v214)

	if not ok then
		t1.value30 = false
		t1.value32()
		t1.value50()
		warn("[Death Ball] Could not read round state; AI movement stopped.")

		return
	end

	local value30 = t1.value30

	t1.value30 = result == true

	if t1.value30 then
		t1.value50()

		if t1.value12.AIMovement then
			t1.value33()
		end
	else
		t1.value32()

		if t1.value12.AutoReady then
			t1.value51()
		end
	end

	if value30 == t1.value30 then
		return
	end

	print("[Death Ball] Round active:", t1.value30)
end

task.spawn(function()
	local ok, result = pcall(function()
		return require(t1.value6:WaitForChild("Values"))
	end)

	if not (ok and (result and result.PLAYER_ACTIVE_STATE)) then
		warn("[Death Ball] PLAYER_ACTIVE_STATE unavailable; AI movement remains stopped.")

		return
	end

	t1.value52 = result.PLAYER_ACTIVE_STATE
	t1.value53()

	local function v221()
		local function v222()
			t1.value53()
		end

		return t1.value52:Connect(v222)
	end

	local ok2, result2 = pcall(v221)

	if ok2 and result2 then
		t1.value11[#t1.value11 + 1] = result2
	else
		warn("[Death Ball] Could not connect to round-state changes.")
	end
end)
t1.value54 = false

local function v224(p17, p18, p19)
	if p17 then
		local v225 = p17.Size / 2
		local t6 = { Vector3.new(0, 0, 0) }
		local t7 = {}

		for i = 1, #t6 do
			t7[i] = p18:PointToWorldSpace((Vector3.new(v225.X * t6[i].X, v225.Y * t6[i].Y, v225.Z * t6[i].Z)))
		end

		for k, v in pairs(t7) do
			if p19(k, v) then
				return
			end
		end
	end
end

t1.value11[#t1.value11 + 1] = t1.value2.PostSimulation:Connect(function(_)
	if not t1.value12.AutoParry then
		return
	end

	if t1.value54 then
		return
	end

	local n7 = 0.025
	local v232 = v32()
	local v233 = (v232 + 0.025) * t1.value12.PingCompensationMultiplier
	local Character = t1.value7.Character
	local v235

	if Character then
		v235 = Character.FindFirstChildWhichIsA(Character, "Humanoid")
	else
		v235 = nil
	end

	if v235 then
		local RootPart = v235.RootPart
	end

	if not v246 then
		return
	end

	local RootPart = v235.RootPart
	local v238, v239, v240 = pairs(t1.value19)
	local huge = math.huge
	local v242 = nil

	while true do
		local v243

		v240, v243 = v238(v239, v240)

		if not v240 then
			break
		end

		local v244 = v243.Target == t1.value7

		if v244 then
			v244 = v243.Object

			if v244 then
				v244 = v243.Object.Parent

				if v244 then
					v244 = v243.Object.Transparency < 1

					if v244 then
						if v243.Velocity.Magnitude > 0 then
							v244 = v243.ObjectVelocity.Magnitude > 0
						else
							v244 = false
						end
					end
				end
			end
		end

		local Magnitude

		if v244 then
			Magnitude = (v243.Position - RootPart.Position).Magnitude

			if Magnitude >= huge then
				v243 = v242
				Magnitude = huge
			end
		else
			v243 = v242
			Magnitude = huge
		end

		v242 = v243
		huge = Magnitude
	end

	if not v242 then
		return
	end

	local Position = RootPart.Position
	local v247 = Position - RootPart.AssemblyLinearVelocity * (v232 + n7)
	local Position2 = v242.Position
	local v249 = v242.Position + v242.ObjectVelocity * (v232 + n7)
	local AssemblyLinearVelocity = RootPart.AssemblyLinearVelocity
	local v251

	if AssemblyLinearVelocity.Magnitude > 1 then
		local vector34, v253 = Vector3.new(AssemblyLinearVelocity.X, AssemblyLinearVelocity.Y, AssemblyLinearVelocity.Z)
		local v254 = Position2 - Position
		local v255 = v254 - v254.Unit * (v253 or 0)

		if v255 then
			v255 = v255.Unit:Dot(vector34.Unit)
		end

		v251 = v255 == v255 and v255 and v255 or 0
	else
		v251 = false
	end

	local v256 = v251 or 0
	local v257

	if AssemblyLinearVelocity.Magnitude > 1 then
		local vector34, v259 = Vector3.new(AssemblyLinearVelocity.X, AssemblyLinearVelocity.Y, AssemblyLinearVelocity.Z)
		local v260 = v249 - v247
		local v261 = v260 - v260.Unit * (v259 or 0)

		if v261 then
			v261 = v261.Unit:Dot(vector34.Unit)
		end

		v257 = v261 == v261 and v261 and v261 or 0
	else
		v257 = false
	end

	local v262 = v257 or 0
	local v263 = t1.value12.Range + v233
	local v264 = math.clamp(v256, -1, 1)
	local v265 = math.abs(v264)
	local n8 = 1
	local PerfectParry = t1.value12.PerfectParry

	if PerfectParry then
		PerfectParry = t1.value12.PerfectParryMultiplier
	end

	local v268 = v263 + v265 * (n8 - (PerfectParry or 0)) * v233
	local DirectPoint = t1.value12.DirectPoint
	local v270 = math.rad(DirectPoint)
	local v271 = 180 * v233
	local v272 = v270 + math.rad(v271)
	local v273 = math.clamp(v256, -1, 1)
	local v274 = math.acos(v273)
	local v275 = math.clamp(v256, -1, 1)

	local function v276(p20, p21, _)
		local u277 = false

		v224(v242.Object, CFrame.new(p21), function(_, p22)
			local raycastParams = RaycastParams.new()

			raycastParams.FilterDescendantsInstances = { v242.Object, t1.value7, t1.value7.Character }
			raycastParams.FilterType = Enum.RaycastFilterType.Exclude

			local pairs_ = pairs
			local value1 = t1.value1

			for _, player in pairs_(value1.GetPlayers(value1)) do
				if player.Character then
					raycastParams:AddToFilter(player.Character)
				end
			end

			local v283 = p22 - p20
			local hit = workspace:Raycast(p20, v283, raycastParams)
			local v285 = v283.Magnitude <= 8

			if v285 then
				if not v285 then
					u277 = true

					return true
				end

				return
			end

			v285 = v242.isPhasingThrough

			if v285 then
				if not v285 then
					u277 = true

					return true
				end

				return
			end

			if hit then
				hit = hit.Instance.Transparency < 1 or (hit.Instance.CollisionGroup == "BallCollider" and true or hit.Instance.CollisionGroup == "NoCollide")
			end

			v285 = not hit

			if not v285 then
				u277 = true

				return true
			end
		end)

		if u277 then
			return
		end

		t1.value17()

		if t1.value12.AutoSpamParry then
			task.spawn(function()
				task.wait()
				t1.value17()
				task.wait()
				t1.value17()
			end)
		end

		task.spawn(function()
			local n9 = 0.1
			local now = os.clock()

			local function v288()
				return (n9 or 0) <= os.clock() - now
			end

			local wait = v11
			local v290 = wait(1)

			while not v290() do
				local v291 = v288()

				if v291 then
					v291 = not v242.Object or (not v242.Object.Parent or v242.Target ~= t1.value7)
				end

				if v291 then
					return
				end

				wait = task.wait
				wait()
			end
		end)
	end

	local v292 = v272 + v274 * math.abs(v275) / 3.141592653589793

	local function v293(p23, p24, p25, p26)
		local value16 = t1.value16
		local t8 = {
			Threshold = v268,
			Values = { t1.value15(p23, p24, p25), t1.value15(p23, p24, p25, 2.5) }
		}
		local v296 = v292
		local v297 = p23 - p24
		local v298 = v297 - v297.Unit * 0

		if v298 then
			v298 = v298.Unit:Dot(p25.Unit)
		end

		local v299 = v298 == v298 and v298 and v298 or 0
		local v300 = math.acos(v299)
		local t9 = {}
		local v302 = p23 - p24
		local v303 = v302 - v302.Unit * 2.5

		if v303 then
			v303 = v303.Unit:Dot(p25.Unit)
		end

		local v304 = v303 == v303 and v303 and v303 or 0

		__set_list(t9, 1, {v300, (math.acos(v304))})

		if value16({
			ETA = t8,
			Dot = {
				Threshold = v296,
				Values = t9
			}
		}) then
			return true
		end

		local v305 = t1.value15(p23, p24, p25).Magnitude <= 0.3 + v233

		if v305 then
			local v306 = p23 - p24
			local v307 = v306 - v306.Unit * 0

			if v307 then
				v307 = v307.Unit:Dot(p25.Unit)
			end

			local v308 = v307 == v307 and v307 and v307 or 0

			v305 = math.acos(v308) <= 1.0471975511965976

			if v305 then
				local v309 = p23 - p24
				local v310 = 8 + 8 * v233
				local v311

				if p26 > 0 then
					v311 = p26 * 4
				else
					v311 = false
				end

				v305 = v310 + (v311 or (p26 < 0 and (p26 * -4 or 0) or 0)) >= v309.Magnitude
			end
		end

		if v305 then
			return true
		end

		local v312 = p23 - p24
		local v313 = 3 + 8 * v233
		local v314 = p26 > 0

		if not v314 then
			return v313 + (v314 or (p26 < 0 and p26 * -3 or 0)) >= v312.Magnitude and true or false
		end

		v314 = p26 * 3

		return v313 + (v314 or (p26 < 0 and p26 * -3 or 0)) >= v312.Magnitude and true or false
	end

	local v315 = v293(Position, Position2, v242.Velocity, v256)

	if v315 then
		v315 = v293(Position, Position2, v242.ObjectVelocity, v256)
	end

	if v315 then
		return v276(Position, Position2, v256)
	end

	local v316 = v293(v247, v249, v242.Velocity, v262)

	if not v316 then
		if v316 then
			return v276(v247, v249, v262)
		end

		return
	end

	v316 = v293(v247, v249, v242.ObjectVelocity, v262)

	if v316 then
		return v276(v247, v249, v262)
	end
end)
t1.value55 = {
	Bg = Color3.fromRGB(17, 17, 21),
	Section = Color3.fromRGB(25, 25, 31),
	Field = Color3.fromRGB(34, 34, 42),
	FieldHi = Color3.fromRGB(29, 35, 54),
	Border = Color3.fromRGB(46, 46, 57),
	Accent = Color3.fromRGB(88, 138, 255),
	Green = Color3.fromRGB(58, 196, 122),
	Off = Color3.fromRGB(52, 52, 62),
	Text = Color3.fromRGB(232, 234, 240),
	Muted = Color3.fromRGB(132, 136, 148)
}
t1.value56 = nil

function t1.value56(p27, p28)
	local instance = Instance.new(p27)

	for k, v in pairs(p28 or {}) do
		instance[k] = v
	end

	return instance
end

t1.value57 = nil

function t1.value58(p29, p30)
	return t1.value56("UICorner", {
		CornerRadius = UDim.new(0, p30),
		Parent = p29
	})
end
function t1.value59(p31, p32, p33)
	return t1.value56("UIStroke", {
		Color = p32 or t1.value55.Border,
		Thickness = p33 or 1,
		Parent = p31
	})
end
function t1.value60(p34, p35)
	local UIStroke = t1.value56("UIStroke", {
		Color = Color3.fromRGB(255, 255, 255),
		Thickness = p35 or 1.5,
		Transparency = 0.15,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = p34
	})
	local UIGradient = t1.value56("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, t1.value55.Accent),
			ColorSequenceKeypoint.new(0.35, Color3.fromRGB(150, 190, 255)),
			ColorSequenceKeypoint.new(0.55, t1.value55.Accent),
			ColorSequenceKeypoint.new(0.8, Color3.fromRGB(70, 110, 220)),
			ColorSequenceKeypoint.new(1, t1.value55.Accent)
		}),
		Rotation = 45,
		Parent = UIStroke
	})
	local connection = nil

	connection = t1.value2.RenderStepped:Connect(function(_)
		if UIStroke.Parent then
			UIGradient.Offset = Vector2.new(os.clock() * 0.18 % 1, 0)
		else
			connection:Disconnect()
		end
	end)

	return UIStroke, UIGradient, connection
end

t1.value61 = nil
t1.value62 = nil
t1.value63 = nil
t1.value64 = {}
t1.value65 = 72
t1.value62 = 10
t1.value66 = nil

function t1.value66(p36)
	return UDim2.new(1, -20, 1, -20 - (p36 - 1) * (t1.value65 + t1.value62))
end

t1.value67 = nil

function t1.value67()
	for i, v in ipairs(t1.value64) do
		if v.Parent then
			local value5 = t1.value5
			local tweenInfoNew = TweenInfo.new
			local Quad = Enum.EasingStyle.Quad
			local Enum_ = Enum

			value5.Create(value5, v, tweenInfoNew(0.2, Quad, Enum_.EasingDirection.Out), {
				Position = t1.value66(i)
			}):Play()
		end
	end
end

t1.value57 = 2.6
t1.value68 = nil

function t1.value69(p37)
	local Frame = t1.value56("Frame", {
		Name = "Notif",
		Size = UDim2.new(0, 300, 0, t1.value65),
		Position = UDim2.new(1, -20, 1, -20),
		AnchorPoint = Vector2.new(1, 1),
		BackgroundColor3 = t1.value55.Section,
		BorderSizePixel = 0,
		Parent = t1.value61,
		ZIndex = 50
	})

	t1.value58(Frame, 10)
	t1.value59(Frame, t1.value55.Border, 1)

	local Frame2 = t1.value56("Frame", {
		Size = UDim2.new(0, 3, 1, -30),
		Position = UDim2.new(0, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundColor3 = t1.value55.Accent,
		BorderSizePixel = 0,
		Parent = Frame,
		ZIndex = 51
	})

	t1.value58(Frame2, 3)
	t1.value56("ImageLabel", {
		Size = UDim2.new(0, 26, 0, 26),
		Position = UDim2.new(0, 14, 0, 6),
		BackgroundTransparency = 1,
		Image = "rbxassetid://84154329190977",
		ScaleType = Enum.ScaleType.Fit,
		Parent = Frame,
		ZIndex = 51
	})
	t1.value56("TextLabel", {
		Size = UDim2.new(1, -54, 0, 18),
		Position = UDim2.new(0, 46, 0, 10),
		BackgroundTransparency = 1,
		Text = "SENTENAL Z",
		TextColor3 = t1.value55.Accent,
		Font = Enum.Font.GothamBold,
		TextSize = 16,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Frame,
		ZIndex = 51
	})
	t1.value56("TextLabel", {
		Size = UDim2.new(2, -60, 0, 18),
		Position = UDim2.new(0, 138, 0, 10),
		BackgroundTransparency = 1,
		Text = "   •   NOTIFICATION",
		TextColor3 = t1.value55.Muted,
		Font = Enum.Font.Gotham,
		TextSize = 10,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Frame,
		ZIndex = 51
	})
	t1.value56("TextLabel", {
		Size = UDim2.new(1, -28, 0, 24),
		Position = UDim2.new(0, 14, 0, 40),
		BackgroundTransparency = 1,
		Text = p37,
		TextColor3 = t1.value55.Text,
		Font = Enum.Font.GothamMedium,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		TextWrapped = true,
		Parent = Frame,
		ZIndex = 51
	})

	local Frame3 = t1.value56("Frame", {
		Size = UDim2.new(1, -20, 0, 2),
		Position = UDim2.new(0, 10, 1, -8),
		BackgroundColor3 = t1.value55.Border,
		BorderSizePixel = 0,
		Parent = Frame,
		ZIndex = 51
	})

	t1.value58(Frame3, 1)

	local Frame4 = t1.value56("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = t1.value55.Accent,
		BorderSizePixel = 0,
		Parent = Frame3,
		ZIndex = 52
	})

	t1.value58(Frame4, 1)

	local value64 = t1.value64

	table.insert(value64, 1, Frame)
	t1.value67()

	local v334 = t1.value66(1)

	Frame.Position = UDim2.new(v334.X.Scale, v334.X.Offset, v334.Y.Scale, v334.Y.Offset + 60)
	Frame.BackgroundTransparency = 1
	t1.value5:Create(Frame, TweenInfo.new(0.32, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
		Position = v334,
		BackgroundTransparency = 0
	}):Play()

	local value5 = t1.value5
	local tweenInfo = TweenInfo.new(t1.value57, Enum.EasingStyle.Linear)
	local t10 = {
		Size = UDim2.new(0, 0, 1, 0)
	}

	value5.Create(value5, Frame4, tweenInfo, t10):Play()

	local function v338()
		local Parent = Frame

		if Parent then
			Parent = Frame.Parent
		end

		if not Parent then
			return
		end

		local Position = Frame.Position
		local value52 = t1.value5
		local v342 = Frame
		local tweenInfo2 = TweenInfo.new(0.24, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		local UDim2_ = UDim2
		local v345 = value52.Create(value52, v342, tweenInfo2, {
			Position = UDim2_.new(1, 40, Position.Y.Scale, Position.Y.Offset),
			BackgroundTransparency = 1
		})

		v345.Play(v345)

		local v346 = Frame

		for _, descendant in ipairs(v346.GetDescendants(v346)) do
			if descendant:IsA("TextLabel") then
				local value53 = t1.value5
				local tweenInfo3 = TweenInfo.new(0.24)

				value53.Create(value53, descendant, tweenInfo3, {
					TextTransparency = 1
				}):Play()
			elseif descendant:IsA("Frame") then
				t1.value5:Create(descendant, TweenInfo.new(0.24), {
					BackgroundTransparency = 1
				}):Play()
			elseif descendant:IsA("ImageLabel") then
				local value53 = t1.value5
				local tweenInfo3 = TweenInfo.new(0.24)

				value53.Create(value53, descendant, tweenInfo3, {
					ImageTransparency = 1
				}):Play()
			elseif descendant:IsA("UIStroke") then
				local value53 = t1.value5
				local tweenInfoNew = TweenInfo.new

				value53.Create(value53, descendant, tweenInfoNew(0.24), {
					Transparency = 1
				}):Play()
			end
		end

		v345.Completed:Wait()
		Frame:Destroy()

		local v355 = table.find(t1.value64, Frame)

		if not v355 then
			return
		end

		table.remove(t1.value64, v355)
		t1.value67()
	end

	task.delay(t1.value57, v338)
end

t1.value70 = {
	SetAutoParryVisual = function() end,
	SetSpamVisual = function() end,
	SetAIMoveVisual = function() end,
	SetAutoReadyVisual = function() end,
	SetCameraVisual = function() end
}
t1.value71 = nil

function t1.value71(p38, p39)
	t1.value69(p38 .. (p39 and " turned ON" or p39) or " turned OFF")
end
function t1.value72(p40)
	t1.value12.AutoParry = p40
	t1.value70.SetAutoParryVisual(p40)
	t1.value71("Auto Parry", p40)
end
function t1.value73(p41)
	t1.value12.AutoSpam = p41
	t1.value70.SetSpamVisual(p41)

	if p41 then
		t1.value27()
	else
		t1.value26()
	end

	t1.value71("Auto Spam", p41)
end
function t1.value74(p42)
	t1.value12.AIMovement = p42
	t1.value70.SetAIMoveVisual(p42)

	local value30

	if p42 then
		value30 = t1.value30
	else
		value30 = p42
	end

	if value30 then
		t1.value33()
	else
		t1.value32()
	end

	t1.value71("AI Movement", p42)
end
function t1.value75(p43)
	t1.value12.AutoReady = p43
	t1.value70.SetAutoReadyVisual(p43)

	local v357

	if p43 then
		v357 = not t1.value30
	else
		v357 = p43
	end

	if v357 then
		t1.value51()
	else
		t1.value50()
	end

	t1.value71("Auto Ready", p43)
end
function t1.value76(p44)
	t1.value12.CameraRotation = p44
	t1.value70.SetCameraVisual(p44)
	t1.value35.Mode = "roam"
	t1.value35.Timer = 0
	t1.value35.Target = nil
	t1.value71("Camera Rotation", p44)
end

t1.value77 = nil

function t1.value78()
	if not t1.value77 then
		return
	end

	local value77 = t1.value77

	t1.value77 = nil
	value77.render()
end

t1.value79 = 38
t1.value80 = t1.value56("ScreenGui", {
	Name = "DeathBallAutoParry",
	ResetOnSpawn = false,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	IgnoreGuiInset = true
})

local ok, result = pcall(function()
	return gethui()
end)

t1.value80.Parent = ok and result or game:GetService("CoreGui")
_G.__DeathBallAutoParry.Gui = t1.value80
t1.value61 = t1.value56("ScreenGui", {
	Name = "DeathBallNotifications",
	ResetOnSpawn = false,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	IgnoreGuiInset = true,
	DisplayOrder = 10
})

local ok2, result2 = pcall(function()
	return gethui()
end)

t1.value61.Parent = ok2 and result2 or game:GetService("CoreGui")
_G.__DeathBallAutoParry.NotifGui = t1.value61
t1.value63 = t1.value56("Frame", {
	Name = "Main",
	Size = uDim2,
	Position = UDim2.new(0.5, 0, 0.5, 0),
	AnchorPoint = Vector2.new(0.5, 0.5),
	BackgroundColor3 = t1.value55.Bg,
	BorderSizePixel = 0,
	ClipsDescendants = true,
	Parent = t1.value80
})
t1.value58(t1.value63, 10)

local _, _, v365 = t1.value60(t1.value63, 1.5)

t1.value11[#t1.value11 + 1] = v365
t1.value56("UIPadding", {
	PaddingTop = UDim.new(0, 10),
	PaddingBottom = UDim.new(0, 10),
	PaddingLeft = UDim.new(0, 12),
	PaddingRight = UDim.new(0, 12),
	Parent = t1.value63
})

local n10 = 1

t1.value81 = t1.value56("Frame", {
	Name = "MainParticleHolder",
	Size = UDim2.new(1, 0, 1, 0),
	BackgroundTransparency = 1,
	ZIndex = 1,
	Parent = t1.value63
})
t1.value82 = {}

local v367 = n10 < 0
local v368 = 1 - n10
local n11 = 20

local function v370(p45, p46)
	local Frame = t1.value56("Frame", {
		Size = UDim2.new(1, 0, 0, 21),
		BackgroundTransparency = 1,
		Parent = p45
	})

	t1.value56("Frame", {
		Size = UDim2.new(1, 0, 0, 1),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundColor3 = t1.value55.Border,
		BorderSizePixel = 0,
		Parent = Frame
	})
	t1.value56("TextLabel", {
		Size = UDim2.new(1, 0, 0, 12),
		Position = UDim2.new(0, 0, 0, 9),
		BackgroundTransparency = 1,
		Text = string.upper(p46),
		TextColor3 = t1.value55.Muted,
		Font = Enum.Font.GothamBold,
		TextSize = 10,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Frame
	})

	return Frame
end
local function v372(p47, p48)
	local TextButton = t1.value56("TextButton", {
		Size = UDim2.new(0, 58, 0, 24),
		BackgroundColor3 = t1.value55.Field,
		TextColor3 = t1.value55.Text,
		Font = Enum.Font.GothamBold,
		TextSize = 12,
		Text = "",
		AutoButtonColor = false,
		BorderSizePixel = 0
	})

	t1.value58(TextButton, 6)

	local v374 = t1.value59(TextButton, t1.value55.Border, 1)

	local function v375()
		local v376 = p47()

		if v376 then
			TextButton.Text = v376.Name
			TextButton.TextColor3 = t1.value55.Text
		else
			TextButton.Text = "None"
			TextButton.TextColor3 = t1.value55.Muted
		end

		TextButton.BackgroundColor3 = t1.value55.Field
		v374.Color = t1.value55.Border
	end

	TextButton.MouseButton1Click:Connect(function()
		local value77 = t1.value77

		if not value77 then
			if value77 then
				t1.value78()
			else
				t1.value78()
				TextButton.Text = ""
				TextButton.BackgroundColor3 = t1.value55.FieldHi
				v374.Color = t1.value55.Accent
				t1.value77 = {
					box = TextButton,
					set = p48,
					render = v375
				}
			end

			return
		end

		value77 = t1.value77.box == TextButton

		if value77 then
			t1.value78()
		else
			t1.value78()
			TextButton.Text = ""
			TextButton.BackgroundColor3 = t1.value55.FieldHi
			v374.Color = t1.value55.Accent
			t1.value77 = {
				box = TextButton,
				set = p48,
				render = v375
			}
		end
	end)
	TextButton.MouseEnter:Connect(function()
		local value77 = t1.value77

		if value77 then
			value77 = t1.value77.box == TextButton
		end

		if value77 then
			return
		end

		TextButton.BackgroundColor3 = Color3.fromRGB(41, 41, 51)
	end)
	TextButton.MouseLeave:Connect(function()
		local value77 = t1.value77

		if value77 then
			value77 = t1.value77.box == TextButton
		end

		if value77 then
			return
		end

		TextButton.BackgroundColor3 = t1.value55.Field
	end)
	v375()

	return TextButton
end
local function v380(p49, p50)
	local Frame = t1.value56("Frame", {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Parent = p49
	})

	t1.value56("UIListLayout", {
		Padding = UDim.new(0, 2),
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = Frame
	})

	local Frame2 = t1.value56("Frame", {
		Size = UDim2.new(1, 0, 0, 14),
		BackgroundTransparency = 1,
		Parent = Frame
	})

	t1.value56("Frame", {
		Size = UDim2.new(0, 3, 0, 12),
		Position = UDim2.new(0, 0, 0, 1),
		BackgroundColor3 = Color3.fromRGB(232, 92, 92),
		BorderSizePixel = 0,
		Parent = Frame2
	})
	t1.value56("TextLabel", {
		Size = UDim2.new(1, -10, 1, 0),
		Position = UDim2.new(0, 9, 0, 0),
		BackgroundTransparency = 1,
		Text = p50,
		TextColor3 = Color3.fromRGB(232, 92, 92),
		Font = Enum.Font.GothamMedium,
		TextSize = 11,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		TextWrapped = true,
		Parent = Frame2
	})

	return Frame
end
local function v383(p51, p52)
	local value56 = t1.value56
	local uDim22 = UDim2.new(0, 56, 0, 22)
	local Green

	if p51 then
		Green = t1.value55.Green
	else
		Green = p51
	end

	local TextButton = value56("TextButton", {
		Size = uDim22,
		BackgroundColor3 = Green or t1.value55.Off,
		Text = "",
		AutoButtonColor = false,
		BorderSizePixel = 0
	})

	t1.value58(TextButton, 11)

	local value562 = t1.value56
	local uDim23 = UDim2.new(0, 16, 0, 16)
	local vector2 = Vector2.new(0, 0.5)
	local uDim24

	if p51 then
		uDim24 = UDim2.new(1, -19, 0.5, 0)
	else
		uDim24 = p51
	end

	local Frame = value562("Frame", {
		Size = uDim23,
		AnchorPoint = vector2,
		Position = uDim24 or UDim2.new(0, 3, 0.5, 0),
		BackgroundColor3 = Color3.fromRGB(238, 240, 246),
		BorderSizePixel = 0,
		Parent = TextButton
	})

	t1.value58(Frame, 8)

	local u393 = nil

	local function v394()
		local value5 = t1.value5
		local v396 = TextButton
		local tweenInfo = TweenInfo.new(0.16)
		local Green2 = u393

		if Green2 then
			Green2 = t1.value55.Green
		end

		value5:Create(v396, tweenInfo, {
			BackgroundColor3 = Green2 or t1.value55.Off
		}):Play()

		local value52 = t1.value5
		local v400 = Frame
		local tweenInfo2 = TweenInfo.new(0.16)
		local uDim25 = u393

		if not uDim25 then
			value52:Create(v400, tweenInfo2, {
				Position = uDim25 or UDim2.new(0, 3, 0.5, 0)
			}):Play()

			return
		end

		uDim25 = UDim2.new(1, -19, 0.5, 0)
		value52:Create(v400, tweenInfo2, {
			Position = uDim25 or UDim2.new(0, 3, 0.5, 0)
		}):Play()
	end

	u393 = p51
	TextButton.MouseButton1Click:Connect(function()
		u393 = not u393
		v394()
		p52(u393)
	end)

	return TextButton, function(p53)
		u393 = p53
		v394()
	end
end
local function v403(p54, p55, p56, p57, p58, p59, p60, p61)
	local Frame = t1.value56("Frame", {
		Size = UDim2.new(1, 0, 0, t1.value79),
		BackgroundTransparency = 1,
		Parent = p54
	})
	local TextLabel = t1.value56("TextLabel", {
		Size = UDim2.new(1, -70, 0, 14),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundTransparency = 1,
		Text = p55,
		TextColor3 = t1.value55.Text,
		Font = Enum.Font.GothamMedium,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Frame
	})
	local TextLabel2 = t1.value56("TextLabel", {
		Size = UDim2.new(0, 64, 0, 14),
		Position = UDim2.new(1, 0, 0, 0),
		AnchorPoint = Vector2.new(1, 0),
		BackgroundTransparency = 1,
		Text = "",
		TextColor3 = t1.value55.Accent,
		Font = Enum.Font.GothamBold,
		TextSize = 11,
		TextXAlignment = Enum.TextXAlignment.Right,
		Parent = Frame
	})
	local Frame2 = t1.value56("Frame", {
		Size = UDim2.new(1, 0, 0, 18),
		Position = UDim2.new(0, 0, 0, 20),
		BackgroundTransparency = 1,
		Active = true,
		Parent = Frame
	})
	local Frame3 = t1.value56("Frame", {
		Size = UDim2.new(1, -12, 0, 6),
		Position = UDim2.new(0, 6, 0.5, -3),
		BackgroundColor3 = t1.value55.Field,
		BorderSizePixel = 0,
		Parent = Frame2
	})

	t1.value58(Frame3, 3)

	local Frame4 = t1.value56("Frame", {
		Size = UDim2.new(0, 0, 1, 0),
		BackgroundColor3 = t1.value55.Accent,
		BorderSizePixel = 0,
		Parent = Frame3
	})

	t1.value58(Frame4, 3)

	local Frame5 = t1.value56("Frame", {
		Size = UDim2.new(0, 12, 0, 12),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0, 0, 0.5, 0),
		BackgroundColor3 = Color3.fromRGB(240, 242, 248),
		BorderSizePixel = 0,
		Parent = Frame3
	})

	t1.value58(Frame5, 6)

	local function v411(p62)
		local v412 = (p62 - p56) / (p57 - p56)
		local v413 = math.clamp(v412, 0, 1)

		Frame4.Size = UDim2.new(v413, 0, 1, 0)
		Frame5.Position = UDim2.new(v413, 0, 0.5, 0)
		TextLabel2.Text = p60(p62)
	end

	local u414 = false

	local function v415(p63)
		local clamp = math.clamp
		local v417 = p63 - Frame3.AbsolutePosition.X
		local X = Frame3.AbsoluteSize.X
		local v419 = clamp(v417 / math.max(X, 1), 0, 1)
		local v420 = (p56 + (p57 - p56) * v419) / p58 + 0.5
		local v421 = math.floor(v420) * p58
		local v422 = p56
		local v423 = p57
		local v424 = math.clamp(v421, v422, v423)

		v411(v424)
		p61(v424)
	end

	t1.value11[#t1.value11 + 1] = Frame2.InputBegan:Connect(function(input)
		if not (input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		u414 = true
		v415(input.Position.X)
	end)
	t1.value11[#t1.value11 + 1] = t1.value3.InputChanged:Connect(function(input)
		if not u414 then
			return
		end

		if not (input.UserInputType == Enum.UserInputType.MouseMovement and true or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		v415(input.Position.X)
	end)
	t1.value11[#t1.value11 + 1] = t1.value3.InputEnded:Connect(function(input)
		local _ = input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch
	end)
	v411(p59)

	return v411, TextLabel
end
local function v426()
	t1.value63.Visible = false

	local value68 = t1.value68

	if value68 then
		value68 = t1.value68.Parent
	end

	if value68 then
		return
	end

	local value7 = t1.value7
	local UserId = value7.UserId
	local DisplayName = value7.DisplayName
	local Name = value7.Name

	t1.value68 = t1.value56("Frame", {
		Name = "ProfileCard",
		Size = UDim2.new(1, 0, 0, 52),
		Position = UDim2.new(0, 0, 1, 0),
		AnchorPoint = Vector2.new(0, 1),
		BackgroundColor3 = t1.value55.Section,
		BorderSizePixel = 0,
		Parent = t1.value63,
		ZIndex = 40
	})
	t1.value58(t1.value68, 8)
	t1.value59(t1.value68, t1.value55.Border, 1)

	local Frame = t1.value56("Frame", {
		Size = UDim2.new(0, 3, 1, -25),
		Position = UDim2.new(0, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundColor3 = t1.value55.Accent,
		BorderSizePixel = 0,
		Parent = t1.value68,
		ZIndex = 51
	})

	t1.value58(Frame, 3)

	local Frame2 = t1.value56("Frame", {
		Size = UDim2.new(0, 44, 0, 44),
		Position = UDim2.new(0, 12, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundColor3 = t1.value55.Field,
		BorderSizePixel = 0,
		Parent = t1.value68,
		ZIndex = 51
	})

	t1.value58(Frame2, 22)
	t1.value59(Frame2, t1.value55.Accent, 1)

	local ImageLabel = t1.value56("ImageLabel", {
		Name = "Avatar",
		Size = UDim2.new(1, -4, 1, -4),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		Image = "",
		ScaleType = Enum.ScaleType.Crop,
		Parent = Frame2,
		ZIndex = 52
	})

	t1.value58(ImageLabel, 22)
	t1.value56("TextLabel", {
		Name = "Username",
		Size = UDim2.new(1, -70, 0, 18),
		Position = UDim2.new(0, 64, 0, 12),
		BackgroundTransparency = 1,
		Text = "@" .. Name,
		TextColor3 = t1.value55.Text,
		Font = Enum.Font.GothamBold,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = t1.value68,
		ZIndex = 51
	})
	t1.value56("TextLabel", {
		Name = "DisplayName",
		Size = UDim2.new(1, -70, 0, 14),
		Position = UDim2.new(0, 64, 0, 30),
		BackgroundTransparency = 1,
		Text = DisplayName,
		TextColor3 = t1.value55.Muted,
		Font = Enum.Font.Gotham,
		TextSize = 11,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = t1.value68,
		ZIndex = 51
	})
	task.spawn(function()
		local function v435()
			return t1.value1:GetUserThumbnailAsync(UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
		end

		local ok3, image = pcall(v435)

		if ok3 then
			if image then
				ok3 = ImageLabel

				if ok3 then
					ok3 = ImageLabel.Parent
				end
			else
				ok3 = image
			end
		end

		if not ok3 then
			return
		end

		ImageLabel.Image = image
	end)
	task.spawn(function()
		local function v438()
			return t1.value1:GetUserThumbnailAsync(UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
		end

		local ok3, image = pcall(v438)

		if ok3 then
			if image then
				ok3 = ImageLabel

				if ok3 then
					ok3 = ImageLabel.Parent
				end
			else
				ok3 = image
			end
		end

		if not ok3 then
			return
		end

		ImageLabel.Image = image
	end)
end
local function v441(p64, p65)
	local u442 = nil
	local Position = nil
	local Position2 = nil

	(p65 or p64).InputBegan:Connect(function(input)
		if not (input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		u442 = true
		Position = input.Position
		Position2 = p64.Position
		input.Changed:Connect(function()
			if input.UserInputState ~= Enum.UserInputState.End then
				return
			end

			u442 = false
		end)
	end)
	t1.value11[#t1.value11 + 1] = t1.value3.InputChanged:Connect(function(input)
		if not u442 then
			return
		end

		if not (input.UserInputType == Enum.UserInputType.MouseMovement and true or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		local v445 = input.Position - Position

		p64.Position = UDim2.new(Position2.X.Scale, Position2.X.Offset + v445.X, Position2.Y.Scale, Position2.Y.Offset + v445.Y)
	end)
end
local function v446(p66, p67)
	local Frame = t1.value56("Frame", {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = t1.value55.Section,
		BorderSizePixel = 0,
		Parent = p66
	})

	t1.value58(Frame, 8)
	t1.value59(Frame, t1.value55.Border, 1)
	t1.value56("UIListLayout", {
		Padding = UDim.new(0, 8),
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = Frame
	})
	t1.value56("UIPadding", {
		PaddingTop = UDim.new(0, 10),
		PaddingBottom = UDim.new(0, 12),
		PaddingLeft = UDim.new(0, 14),
		PaddingRight = UDim.new(0, 14),
		Parent = Frame
	})
	t1.value56("TextLabel", {
		Size = UDim2.new(1, 0, 0, 15),
		BackgroundTransparency = 1,
		Text = string.upper(p67),
		TextColor3 = t1.value55.Muted,
		Font = Enum.Font.GothamBold,
		TextSize = 10,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Frame
	})

	return Frame
end
local function v448(p68, p69)
	local Frame = t1.value56("Frame", {
		Size = UDim2.new(1, 0, 0, 26),
		BackgroundTransparency = 1,
		Parent = p68
	})

	t1.value56("UIPadding", {
		PaddingLeft = UDim.new(0, 4),
		PaddingRight = UDim.new(0, 4),
		Parent = Frame
	})
	t1.value56("TextLabel", {
		Size = UDim2.new(1, -120, 1, 0),
		BackgroundTransparency = 1,
		Text = p69,
		TextColor3 = t1.value55.Text,
		Font = Enum.Font.GothamMedium,
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Frame
	})

	return Frame
end

while true do
	v368 = v368 + n10

	local v450 = not v367

	if v450 then
		v450 = v368 <= n11
	end

	if (not v367 or n11 > v368) and not v450 then
		local RenderStepped = t1.value2.RenderStepped

		t1.value83 = RenderStepped.Connect(RenderStepped, function(p70)
			if t1.value81 and t1.value81.Parent then
				local now = os.clock()

				for _, v in ipairs(t1.value82) do
					local Frame = v.Frame
					local Parent

					if Frame then
						Parent = Frame.Parent
					else
						Parent = Frame
					end

					if Parent then
						local v457 = Frame.Position.Y.Scale - v.Speed * p70 * 60

						if v457 < -0.05 then
							v.BaseX = math.random()
							Frame.Position = UDim2.new(v.BaseX, 0, 1.05, 0)
						else
							local v458 = now * 1.4 + v.Phase
							local v459 = math.sin(v458) * 0.006

							Frame.Position = UDim2.new(v.BaseX + v459, 0, v457, 0)
						end
					end
				end
			end
		end)
		t1.value11[#t1.value11 + 1] = t1.value83
		v426()
		t1.value24 = t1.value56("Frame", {
			Name = "AutoSpamIndicator",
			Size = UDim2.new(0, 148, 0, 28),
			Position = UDim2.new(0.5, 0, 0, 12),
			AnchorPoint = Vector2.new(0.5, 0),
			BackgroundColor3 = Color3.fromRGB(20, 20, 26),
			BorderSizePixel = 0,
			Visible = false,
			Active = true,
			Parent = t1.value80
		})
		t1.value58(t1.value24, 8)
		t1.value59(t1.value24, t1.value55.Green, 1)

		local Frame = t1.value56("Frame", {
			Size = UDim2.new(0, 8, 0, 8),
			Position = UDim2.new(0, 12, 0.5, -4),
			BackgroundColor3 = t1.value55.Green,
			BorderSizePixel = 0,
			Parent = t1.value24
		})

		t1.value58(Frame, 4)
		t1.value56("TextLabel", {
			Size = UDim2.new(1, -32, 1, 0),
			Position = UDim2.new(0, 26, 0, 0),
			BackgroundTransparency = 1,
			Text = "AUTO SPAM · ON",
			TextColor3 = t1.value55.Green,
			Font = Enum.Font.GothamBold,
			TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = t1.value24
		})
		v441(t1.value24, t1.value24)

		local Frame2 = t1.value56("Frame", {
			Size = UDim2.new(1, 0, 0, 32),
			BackgroundTransparency = 1,
			Active = true,
			Parent = t1.value63
		})

		t1.value84 = t1.value56("ImageLabel", {
			Name = "LogoDotGlow",
			Size = UDim2.new(0, 38, 0, 38),
			Position = UDim2.new(0, -4, 0.5, -18),
			BackgroundTransparency = 1,
			Image = "rbxassetid://84154329190977",
			ImageColor3 = t1.value55.Accent,
			ImageTransparency = 0.55,
			ScaleType = Enum.ScaleType.Fit,
			ZIndex = 1,
			Parent = Frame2
		})
		t1.value85 = t1.value56("ImageLabel", {
			Name = "LogoDot",
			Size = UDim2.new(0, 29, 0, 29),
			Position = UDim2.new(0, 0, 0.5, -13),
			BackgroundTransparency = 1,
			Image = "rbxassetid://84154329190977",
			ScaleType = Enum.ScaleType.Fit,
			ZIndex = 2,
			Parent = Frame2
		})
		t1.value86 = t1.value2.RenderStepped:Connect(function()
			if t1.value85 and t1.value85.Parent then
				local now = os.clock()
				local v463 = now * 1.8
				local v464 = math.sin(v463) * 2

				t1.value85.Position = UDim2.new(0, 0, 0.5, -13 + v464)
				t1.value84.Position = UDim2.new(0, -4, 0.5, -18 + v464)

				local value84 = t1.value84
				local v466 = now * 1.8

				value84.ImageTransparency = 0.45 + math.sin(v466) * 0.15

				local v467 = now * 1.8
				local v468 = math.sin(v467) * 3 + 38

				t1.value84.Size = UDim2.new(0, v468, 0, v468)
			end
		end)
		t1.value11[#t1.value11 + 1] = t1.value86
		t1.value56("TextLabel", {
			Size = UDim2.new(1, -90, 1, 0),
			Position = UDim2.new(0, 34, 0, 0),
			BackgroundTransparency = 1,
			Text = "SENTENAL Z • DEATH BALL",
			TextColor3 = t1.value55.Text,
			Font = Enum.Font.GothamBold,
			TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = Frame2
		})
		t1.value56("TextLabel", {
			Size = UDim2.new(0, 48, 1, 0),
			Position = UDim2.new(1, 0, 0, 0),
			AnchorPoint = Vector2.new(1, 0),
			BackgroundTransparency = 1,
			Text = "1.14v",
			TextColor3 = t1.value55.Muted,
			Font = Enum.Font.GothamMedium,
			TextSize = 11,
			TextXAlignment = Enum.TextXAlignment.Right,
			Parent = Frame2
		})

		local ScrollingFrame = t1.value56("ScrollingFrame", {
			Size = UDim2.new(1, 0, 1, -102),
			Position = UDim2.new(0, 0, 0, 42),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Active = true,
			CanvasSize = UDim2.new(0, 0, 0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			ScrollingDirection = Enum.ScrollingDirection.Y,
			ScrollBarThickness = 6,
			ScrollBarImageColor3 = t1.value55.Field,
			ScrollBarImageTransparency = 0,
			VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar,
			ElasticBehavior = Enum.ElasticBehavior.Never,
			Parent = t1.value63
		})

		t1.value56("UIListLayout", {
			Padding = UDim.new(0, 9),
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = ScrollingFrame
		})
		t1.value56("UIPadding", {
			PaddingTop = UDim.new(0, 6),
			PaddingBottom = UDim.new(0, 8),
			PaddingLeft = UDim.new(0, 6),
			PaddingRight = UDim.new(0, 6),
			Parent = ScrollingFrame
		})

		local autoParry = v446(ScrollingFrame, "Auto Parry")

		v380(autoParry, "Auto Parry is unreliable on Xeno, Solara")

		local autoParry2 = v448(autoParry, "Auto Parry")
		local v472, v473 = v383(t1.value12.AutoParry, function(p71)
			t1.value72(p71)
		end)

		v472.Position = UDim2.new(1, -66, 0.5, 0)
		v472.AnchorPoint = Vector2.new(1, 0.5)
		v472.Parent = autoParry2

		local v474 = v372(function()
			return t1.value12.AutoParryKey
		end, function(p72)
			t1.value12.AutoParryKey = p72
		end)

		v474.Position = UDim2.new(1, 0, 0.5, 0)
		v474.AnchorPoint = Vector2.new(1, 0.5)
		v474.Parent = autoParry2

		local autoSpam = v446(ScrollingFrame, "Auto Spam")
		local autoSpam2 = v448(autoSpam, "Auto Spam")
		local v477, v478 = v383(t1.value12.AutoSpam, function(p73)
			t1.value73(p73)
		end)

		v477.Position = UDim2.new(1, -66, 0.5, 0)
		v477.AnchorPoint = Vector2.new(1, 0.5)
		v477.Parent = autoSpam2

		local v479 = v372(function()
			return t1.value12.AutoSpamKey
		end, function(p74)
			t1.value12.AutoSpamKey = p74
		end)

		v479.Position = UDim2.new(1, 0, 0.5, 0)
		v479.AnchorPoint = Vector2.new(1, 0.5)
		v479.Parent = autoSpam2
		v403(autoSpam, "Spam Rate", 0.02, 0.3, 0.01, t1.value12.AutoSpamRate, function(p75)
			return string.format("%.2fs", p75)
		end, function(p76)
			t1.value12.AutoSpamRate = p76
		end)

		local aiMovement = v446(ScrollingFrame, "AI Movement")
		local aiMovement2 = v448(aiMovement, "AI Movement")
		local v482, v483 = v383(t1.value12.AIMovement, function(p77)
			t1.value74(p77)
		end)

		v482.Position = UDim2.new(1, -66, 0.5, 0)
		v482.AnchorPoint = Vector2.new(1, 0.5)
		v482.Parent = aiMovement2

		local v484 = v372(function()
			return t1.value12.AIMovementKey
		end, function(p78)
			t1.value12.AIMovementKey = p78
		end)

		v484.Position = UDim2.new(1, 0, 0.5, 0)
		v484.AnchorPoint = Vector2.new(1, 0.5)
		v484.Parent = aiMovement2

		local followBall = v448(aiMovement, "Follow Ball")
		local v486 = v383(t1.value12.FollowBall, function(p79)
			t1.value12.FollowBall = p79
			t1.value29.NextTurn = 0
			t1.value29.AvoidUntil = 0
			t1.value71("Follow Ball", p79)
			print("[Death Ball] Follow Ball:", p79 and "ON" or p79 or "OFF")
		end)

		v486.Position = UDim2.new(1, 0, 0.5, 0)
		v486.AnchorPoint = Vector2.new(1, 0.5)
		v486.Parent = followBall
		v370(aiMovement, "Camera Rotation")

		local cameraRotation = v448(aiMovement, "Camera Rotation")
		local v488, v489 = v383(t1.value12.CameraRotation, function(p80)
			t1.value76(p80)
		end)

		v488.Position = UDim2.new(1, -66, 0.5, 0)
		v488.AnchorPoint = Vector2.new(1, 0.5)
		v488.Parent = cameraRotation

		local v490 = v372(function()
			return t1.value12.CameraRotationKey
		end, function(p81)
			t1.value12.CameraRotationKey = p81
		end)

		v490.Position = UDim2.new(1, 0, 0.5, 0)
		v490.AnchorPoint = Vector2.new(1, 0.5)
		v490.Parent = cameraRotation
		v403(aiMovement, "Cam Roam", 0, 10, 0.5, t1.value12.CameraRoamTime, function(p82)
			return p82 <= 0 and "Off" or string.format("%.1fs", p82)
		end, function(p83)
			t1.value12.CameraRoamTime = p83
			t1.value35.Timer = 0

			local v491

			if p83 > 0 then
				v491 = t1.value35.Mode ~= "roam"
			else
				v491 = false
			end

			if not v491 then
				return
			end

			t1.value35.Mode = "roam"
			t1.value35.Target = nil
		end)
		v403(aiMovement, "Cam Lock", 0, 10, 0.5, t1.value12.CameraLockTime, function(p84)
			return p84 <= 0 and "Off" or string.format("%.1fs", p84)
		end, function(p85)
			t1.value12.CameraLockTime = p85
			t1.value35.Timer = 0
		end)
		v403(aiMovement, "Cam Speed", 0.2, 4, 0.1, t1.value12.CameraSpeed, function(p86)
			return string.format("%.2fx", p86)
		end, function(p87)
			t1.value12.CameraSpeed = p87
		end)
		v403(aiMovement, "Cam Aggression", 0, 4, 0.1, t1.value12.CameraAggression, function(p88)
			return string.format("%.2fx", p88)
		end, function(p89)
			t1.value12.CameraAggression = p89

			if t1.value35.Mode ~= "roam" then
				return
			end

			t1.value38()
		end)
		v370(aiMovement, "Auto Ready · Lobby Only")

		local autoReady = v448(aiMovement, "Auto Ready")
		local v493, v494 = v383(t1.value12.AutoReady, function(p90)
			t1.value75(p90)
		end)

		v493.Position = UDim2.new(1, -66, 0.5, 0)
		v493.AnchorPoint = Vector2.new(1, 0.5)
		v493.Parent = autoReady

		local v495 = v372(function()
			return t1.value12.AutoReadyKey
		end, function(p91)
			t1.value12.AutoReadyKey = p91
		end)

		v495.Position = UDim2.new(1, 0, 0.5, 0)
		v495.AnchorPoint = Vector2.new(1, 0.5)
		v495.Parent = autoReady
		t1.value87 = nil

		local idlePause = v448(aiMovement, "Idle Pause")
		local v497 = v383(t1.value12.AutoReadyIdle, function(p92)
			t1.value12.AutoReadyIdle = p92

			if t1.value87 then
				local value87 = t1.value87
				local s3 = "TextColor3"
				local Text

				if p92 then
					Text = t1.value55.Text
				else
					Text = p92
				end

				value87[s3] = Text or t1.value55.Muted
			end

			if p92 then
				t1.value71("Idle Pause", p92)
				print("[Death Ball] Idle Pause:", p92 and "ON" or "OFF")

				return
			end

			t1.value43.Parked = false
			t1.value43.ParkUntil = 0
			t1.value43.NextPick = 0
			t1.value71("Idle Pause", p92)
			print("[Death Ball] Idle Pause:", p92 and "ON" or "OFF")
		end)

		v497.Position = UDim2.new(1, 0, 0.5, 0)
		v497.AnchorPoint = Vector2.new(1, 0.5)
		v497.Parent = idlePause
		t1.value87 = select(2, v403(aiMovement, "Hold Time", 0, 10, 0.5, t1.value12.AutoReadyDelay, function(p93)
			return p93 <= 0 and "Forever" or string.format("%.1fs", p93)
		end, function(p94)
			t1.value12.AutoReadyDelay = p94

			local Parked = t1.value43.Parked

			if Parked then
				if t1.value43.ParkUntil == math.huge then
					Parked = p94 > 0
				else
					Parked = false
				end
			end

			if not Parked then
				return
			end

			t1.value43.ParkUntil = os.clock() + p94
		end))

		local value87 = t1.value87
		local AutoReadyIdle = t1.value12.AutoReadyIdle

		if AutoReadyIdle then
			AutoReadyIdle = t1.value55.Text
		end

		value87.TextColor3 = AutoReadyIdle or t1.value55.Muted
		v403(aiMovement, "Edge Inset", 0, 0.45, 0.01, t1.value12.AutoReadyEdge, function(p95)
			return string.format("%d%%", (math.floor(p95 * 100 + 0.5)))
		end, function(p96)
			t1.value12.AutoReadyEdge = p96
		end)
		v403(v446(ScrollingFrame, "Humanizer"), "Jump Interval", 0, 10, 0.5, t1.value12.JumpInterval, function(p97)
			return p97 <= 0 and "Off" or string.format("%.1fs", p97)
		end, function(p98)
			t1.value12.JumpInterval = p98
		end)

		local extras = v446(ScrollingFrame, "Extras")
		local spamParry = v448(extras, "Spam Parry")
		local v506 = v383(t1.value12.AutoSpamParry, function(p99)
			t1.value12.AutoSpamParry = p99
			t1.value71("Spam Parry", p99)
		end)

		v506.Position = UDim2.new(1, 0, 0.5, 0)
		v506.AnchorPoint = Vector2.new(1, 0.5)
		v506.Parent = spamParry

		local perfectParry = v448(extras, "Perfect Parry")
		local v508 = v383(t1.value12.PerfectParry, function(p100)
			t1.value12.PerfectParry = p100
			t1.value71("Perfect Parry", p100)
		end)

		v508.Position = UDim2.new(1, 0, 0.5, 0)
		v508.AnchorPoint = Vector2.new(1, 0.5)
		v508.Parent = perfectParry
		v403(extras, "Ping Comp", 0, 2, 0.05, t1.value12.PingCompensationMultiplier, function(p101)
			return string.format("%.2fx", p101)
		end, function(p102)
			t1.value12.PingCompensationMultiplier = p102
		end)
		t1.value56("TextLabel", {
			Size = UDim2.new(1, 0, 0, 14),
			BackgroundTransparency = 1,
			Text = "Toggle Right Control to hides UI",
			TextColor3 = t1.value55.Muted,
			Font = Enum.Font.Gotham,
			TextSize = 10,
			TextXAlignment = Enum.TextXAlignment.Center,
			Parent = ScrollingFrame
		})

		local Frame3 = t1.value56("Frame", {
			Size = UDim2.new(1, 0, 0, 72),
			BackgroundTransparency = 1,
			Parent = ScrollingFrame
		})

		t1.value56("UIListLayout", {
			Padding = UDim.new(0, 6),
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = Frame3
		})

		local function v510(p103, p104, p105, p106, _)
			local TextButton = t1.value56("TextButton", {
				Size = UDim2.new(1, 0, 0, 34),
				BackgroundColor3 = p104,
				TextColor3 = t1.value55.Text,
				Font = Enum.Font.GothamBold,
				TextSize = 13,
				Text = p103,
				AutoButtonColor = false,
				BorderSizePixel = 0,
				ClipsDescendants = true,
				Parent = p106
			})

			t1.value58(TextButton, 8)

			local v512 = t1.value59(TextButton, t1.value55.Border, 1)
			local UIStroke = t1.value56("UIStroke", {
				Color = t1.value55.Accent,
				Thickness = 1,
				Transparency = 1,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Parent = TextButton
			})
			local Size = TextButton.Size

			TextButton.MouseEnter:Connect(function()
				local value5 = t1.value5
				local v516 = TextButton
				local TweenInfo_ = TweenInfo
				local t11 = {
					BackgroundColor3 = p105
				}

				value5.Create(value5, v516, TweenInfo_.new(0.15), t11):Play()

				local value52 = t1.value5
				local v520 = v512
				local tweenInfo = TweenInfo.new(0.15)

				value52.Create(value52, v520, tweenInfo, {
					Color = t1.value55.Accent,
					Transparency = 0
				}):Play()
				t1.value5:Create(UIStroke, TweenInfo.new(0.2), {
					Transparency = 0.55,
					Thickness = 2
				}):Play()
			end)
			TextButton.MouseLeave:Connect(function()
				local t12 = {
					BackgroundColor3 = p104
				}

				t1.value5:Create(TextButton, TweenInfo.new(0.15), t12):Play()
				t1.value5:Create(v512, TweenInfo.new(0.15), {
					Color = t1.value55.Border,
					Transparency = 0
				}):Play()

				local value5 = t1.value5
				local v524 = UIStroke
				local tweenInfo = TweenInfo.new(0.2)

				value5.Create(value5, v524, tweenInfo, {
					Transparency = 1,
					Thickness = 1
				}):Play()
			end)
			TextButton.MouseButton1Down:Connect(function()
				local value5 = t1.value5
				local v527 = TextButton
				local tweenInfo = TweenInfo.new(0.08)
				local v529 = Size
				local uDim2New = UDim2.new

				value5.Create(value5, v527, tweenInfo, {
					Size = v529 - uDim2New(0, 4, 0, 2)
				}):Play()
			end)
			TextButton.MouseButton1Up:Connect(function()
				local value5 = t1.value5
				local v532 = TextButton
				local tweenInfo = TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
				local t13 = {
					Size = Size
				}

				value5.Create(value5, v532, tweenInfo, t13):Play()
			end)

			return TextButton
		end

		local joinDiscord = v510("Join Discord", t1.value55.Field, Color3.fromRGB(48, 48, 60))

		joinDiscord.Parent = Frame3

		local function v536(p107)
			local setclipboard_ = setclipboard or (toclipboard or writeclipboard)

			return type(setclipboard_) == "function" and pcall(setclipboard_, p107) and true or pcall(function()
				game:GetService("StarterGui"):SetCore("SetClipboard", p107)
			end)
		end

		joinDiscord.MouseButton1Click:Connect(function()
			local v538 = v536(t1.value12.DiscordURL)

			t1.value69(v538 and "Discord link copied to clipboard" or v538 or "Copy failed — link: " .. t1.value12.DiscordURL)
			print("[SENTENAL Z - DEATH BALL] Discord copy success:", v538)
		end)

		local unloadUi = v510("Unload UI", t1.value55.Field, Color3.fromRGB(48, 48, 60))

		unloadUi.Parent = Frame3
		unloadUi.MouseButton1Click:Connect(function()
			t1.value32()
			t1.value50()
			t1.value26()
			t1.value2:UnbindFromRenderStep(t1.value28)
			t1.value2:UnbindFromRenderStep(t1.value40)

			if t1.value83 then
				t1.value83:Disconnect()
			end

			if t1.value86 then
				t1.value86:Disconnect()
			end

			for _, v in ipairs(t1.value11) do
				pcall(function()
					v:Disconnect()
				end)
			end

			_G.__DBGen = (_G.__DBGen or 0) + 1

			local __DeathBallAutoParry = _G.__DeathBallAutoParry

			if __DeathBallAutoParry then
				__DeathBallAutoParry = _G.__DeathBallAutoParry.Gui
			end

			if __DeathBallAutoParry then
				pcall(function()
					_G.__DeathBallAutoParry.Gui:Destroy()
				end)
			end

			if t1.value68 then
				local function v543()
					t1.value68:Destroy()
				end

				pcall(v543)
				t1.value68 = nil
			end

			local __DeathBallAutoParry2 = _G.__DeathBallAutoParry

			if __DeathBallAutoParry2 then
				__DeathBallAutoParry2 = _G.__DeathBallAutoParry.NotifGui
			end

			if not __DeathBallAutoParry2 then
				_G.__DeathBallAutoParry = nil
				print("[SENTENAL Z - DEATH BALL] Unloaded.")

				return
			end

			pcall(function()
				_G.__DeathBallAutoParry.NotifGui:Destroy()
			end)
			_G.__DeathBallAutoParry = nil
			print("[SENTENAL Z - DEATH BALL] Unloaded.")
		end)
		t1.value70.SetAutoParryVisual = v473
		t1.value70.SetSpamVisual = v478
		t1.value70.SetAIMoveVisual = v483
		t1.value70.SetAutoReadyVisual = v494
		t1.value70.SetCameraVisual = v489
		v441(t1.value63, Frame2)
		t1.value88 = false
		t1.value89 = false
		t1.value90 = nil

		function t1.value91()
			local ipairs_ = ipairs
			local value80 = t1.value80
			local v547, v548, v549 = ipairs_(value80.GetDescendants(value80))
			local t14 = {
				Objects = {},
				Positions = {}
			}

			while true do
				local v551

				v549, v551 = v547(v548, v549)

				if not v549 then
					break
				end

				local t15 = {}
				local isGuiObject = v551:IsA("GuiObject")

				if isGuiObject then
					t15.BackgroundTransparency = v551.BackgroundTransparency
					isGuiObject = "BackgroundTransparency"
				end

				if v551:IsA("TextLabel") or (v551:IsA("TextButton") or v551:IsA("TextBox")) then
					t15.TextTransparency = v551.TextTransparency
					t15.TextStrokeTransparency = v551.TextStrokeTransparency
				end

				if v551:IsA("ImageLabel") or v551:IsA("ImageButton") then
					t15.ImageTransparency = v551.ImageTransparency
				end

				if v551:IsA("ScrollingFrame") then
					t15.ScrollBarImageTransparency = v551.ScrollBarImageTransparency
				end

				if v551:IsA("UIStroke") then
					t15.Transparency = v551.Transparency
				end

				if next(t15) then
					t14.Objects[v551] = t15
				end
			end

			local ipairs_2 = ipairs
			local value802 = t1.value80

			for _, child in ipairs_2(value802.GetChildren(value802)) do
				if child:IsA("GuiObject") then
					t14.Positions[child] = child.Position
				end
			end

			return t14
		end
		function t1.value92(p108)
			if t1.value89 or t1.value88 == p108 then
				return
			end

			if p108 then
				t1.value90 = t1.value91()

				local v558 = nil

				for k, object in pairs(t1.value90.Objects) do
					if k.Parent then
						local v561, v562, v563 = pairs(object)
						local t16 = {}

						while true do
							v563 = v561(v562, v563)

							if not v563 then
								break
							end

							t16[v563] = 1
						end

						if t1.value90.Positions[k] then
							t16.Position = t1.value90.Positions[k] + UDim2.new(0, 0, 0, 40)
						end

						local tween = t1.value5:Create(k, TweenInfo.new(0.24, Enum.EasingStyle.Quad, Enum.EasingDirection.In), t16)

						if k == t1.value63 then
							v558 = tween
						end

						tween:Play()
					end
				end

				if not v558 then
					t1.value80.Enabled = false
					t1.value88 = true

					return
				end

				v558.Completed:Wait()
				t1.value80.Enabled = false
				t1.value88 = true

				return
			end

			t1.value80.Enabled = true

			local v566 = nil
			local pairs_ = pairs
			local value90 = t1.value90
			local v569, v570, v571, t17, t18, v574, v575, tween

			if not value90 then
				for k, v in pairs_(value90 or {}) do
					if k.Parent then
						v569, v570, v571 = pairs(v)
						t17 = {}
						t18 = {}

						while true do
							v571, v574 = v569(v570, v571)

							if not v571 then
								break
							end

							t17[v571] = 1
							t18[v571] = v574
						end

						if t1.value90.Positions[k] then
							v575 = t1.value90.Positions[k]
							k.Position = v575 + UDim2.new(0, 0, 0, 40)
							t18.Position = v575
						end

						for k2, v2 in pairs(t17) do
							k[k2] = v2
						end

						tween = t1.value5:Create(k, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), t18)

						if k == t1.value63 then
							v566 = tween
						end

						tween:Play()
					end
				end

				if not v566 then
					t1.value88 = false

					return
				end

				v566.Completed:Wait()
				t1.value88 = false

				return
			end

			value90 = t1.value90.Objects

			for k, v in pairs_(value90 or {}) do
				if k.Parent then
					v569, v570, v571 = pairs(v)
					t17 = {}
					t18 = {}

					while true do
						v571, v574 = v569(v570, v571)

						if not v571 then
							break
						end

						t17[v571] = 1
						t18[v571] = v574
					end

					if t1.value90.Positions[k] then
						v575 = t1.value90.Positions[k]
						k.Position = v575 + UDim2.new(0, 0, 0, 40)
						t18.Position = v575
					end

					for k2, v2 in pairs(t17) do
						k[k2] = v2
					end

					tween = t1.value5:Create(k, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), t18)

					if k == t1.value63 then
						v566 = tween
					end

					tween:Play()
				end
			end

			if not v566 then
				t1.value88 = false

				return
			end

			v566.Completed:Wait()
			t1.value88 = false
		end

		t1.value93 = {
			Enabled = true,
			Key = "1",
			API = nil,
			SaveKey = true,
			Remember = true
		}
		t1.value93.DiscordURL = t1.value12.DiscordURL
		t1.value93.Logo = "rbxassetid://84154329190977"
		t1.value93.Title = "SENTENAL Z"
		t1.value93.Subtitle = "DEATH BALL"
		t1.value93.Version = "1.14v"
		t1.value94 = "SentenalZ_DeathBall_Key.txt"

		function t1.value95()
			if not t1.value93.SaveKey then
				return
			end

			local readfile_ = readfile or read_file

			if not readfile_ then
				return
			end

			local ok3, result3 = pcall(readfile_, t1.value94)

			if not ok3 then
				if ok3 then
					return result3
				end

				return
			end

			if result3 then
				ok3 = result3 ~= ""
			else
				ok3 = result3
			end

			if ok3 then
				return result3
			end
		end
		function t1.value96(p109)
			if not t1.value93.Enabled then
				return true, "Key system disabled"
			end

			if not p109 or p109 == "" then
				return false, "Enter a key"
			end

			local Key = t1.value93.Key

			if Key then
				Key = p109 == t1.value93.Key
			end

			if Key then
				return true, "Key valid"
			end

			local API = t1.value93.API

			if API then
				API = t1.value93.API ~= ""
			end

			if not API then
				return false, "Invalid key"
			end

			local function v590()
				return game:HttpGet(t1.value93.API .. "?key=" .. p109)
			end

			local ok3, result3 = pcall(v590)

			if ok3 and result3 then
				local v593 = string.lower(result3)

				if v593:find("valid") or (v593:find("true") or v593:find("success")) then
					return true, "Key valid"
				else
					return false, "Invalid key"
				end
			else
				return false, "Invalid key"
			end
		end
		function t1.value97(p110)
			local t19 = {
				value1 = p110
			}

			task.spawn(function()
				local ScreenGui = t1.value56("ScreenGui", {
					Name = "SentenalZ_Loading",
					ResetOnSpawn = false,
					ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
					IgnoreGuiInset = true,
					DisplayOrder = 100
				})
				local ok3, result3 = pcall(function()
					return gethui()
				end)

				ScreenGui.Parent = ok3 and result3 or game:GetService("CoreGui")

				local Frame4 = t1.value56("Frame", {
					Size = UDim2.new(0, 260, 0, 220),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = t1.value55.Bg,
					BorderSizePixel = 0,
					Parent = ScreenGui
				})

				t1.value58(Frame4, 12)

				local _, _, v601 = t1.value60(Frame4, 1.5)
				local t20 = {
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					Parent = Frame4
				}
				local n12 = 72
				local Frame5 = t1.value56("Frame", t20)
				local Frame6 = t1.value56("Frame", {
					Size = UDim2.new(0, n12, 0, n12),
					Position = UDim2.new(0.5, 0, 0, 28),
					AnchorPoint = Vector2.new(0.5, 0),
					BackgroundTransparency = 1,
					Parent = Frame5
				})

				t1.value58(Frame6, n12 / 2)
				t1.value56("UIStroke", {
					Color = t1.value55.Field,
					Thickness = 4,
					Parent = Frame6
				})

				local Frame7 = t1.value56("Frame", {
					Size = UDim2.new(0, n12, 0, n12),
					Position = UDim2.new(0.5, 0, 0, 28),
					AnchorPoint = Vector2.new(0.5, 0),
					BackgroundTransparency = 1,
					Parent = Frame5
				})

				t1.value58(Frame7, n12 / 2)

				local UIStroke = t1.value56("UIStroke", {
					Color = t1.value55.Accent,
					Thickness = 4,
					LineJoinMode = Enum.LineJoinMode.Round,
					Parent = Frame7
				})

				t1.value56("UIGradient", {
					Rotation = 0,
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 0),
						NumberSequenceKeypoint.new(0.55, 0),
						NumberSequenceKeypoint.new(0.75, 1),
						NumberSequenceKeypoint.new(1, 1)
					}),
					Parent = UIStroke
				})

				local connection = t1.value2.RenderStepped:Connect(function(dt)
					local Parent = Frame7

					if Parent then
						Parent = Frame7.Parent
					end

					if not Parent then
						return
					end

					Frame7.Rotation = (Frame7.Rotation + dt * 260) % 360
				end)

				t1.value56("TextLabel", {
					Size = UDim2.new(1, 0, 0, 30),
					Position = UDim2.new(0, 0, 0, 116),
					BackgroundTransparency = 1,
					Text = "Loading Sentenal Z",
					TextColor3 = t1.value55.Text,
					Font = Enum.Font.GothamBold,
					TextSize = 22,
					Parent = Frame5
				})
				t1.value56("TextLabel", {
					Size = UDim2.new(1, 0, 0, 14),
					Position = UDim2.new(0, 0, 0, 146),
					BackgroundTransparency = 1,
					Text = t1.value93.Version .. "  ·  " .. t1.value93.Subtitle,
					TextColor3 = t1.value55.Muted,
					Font = Enum.Font.GothamMedium,
					TextSize = 11,
					Parent = Frame5
				})

				local Frame8 = t1.value56("Frame", {
					Size = UDim2.new(1, -50, 0, 6),
					Position = UDim2.new(0.5, 0, 0, 170),
					AnchorPoint = Vector2.new(0.5, 0),
					BackgroundColor3 = t1.value55.Field,
					BorderSizePixel = 0,
					Parent = Frame5
				})

				t1.value58(Frame8, 3)

				local Frame9 = t1.value56("Frame", {
					Size = UDim2.new(0, 0, 1, 0),
					BackgroundColor3 = t1.value55.Accent,
					BorderSizePixel = 0,
					Parent = Frame8
				})

				t1.value58(Frame9, 3)

				local TextLabel = t1.value56("TextLabel", {
					Size = UDim2.new(1, -50, 0, 14),
					Position = UDim2.new(0.5, 0, 0, 182),
					AnchorPoint = Vector2.new(0.5, 0),
					BackgroundTransparency = 1,
					Text = "0%",
					TextColor3 = t1.value55.Muted,
					Font = Enum.Font.GothamMedium,
					TextSize = 11,
					Parent = Frame5
				})
				local n13 = 0
				local connection2 = t1.value2.RenderStepped:Connect(function(dt)
					if Frame9 and Frame9.Parent then
						local v615 = n13 + dt

						n13 = math.min(v615, 1.8)

						local v616 = n13 / 1.8

						Frame9.Size = UDim2.new(v616, 0, 1, 0)

						local v617 = TextLabel
						local format = string.format
						local v619 = v616 * 100 + 0.5

						v617.Text = format("%d%%", (math.floor(v619)))
					end
				end)

				task.wait(1.95)

				local value5 = t1.value5
				local tweenInfoNew = TweenInfo.new
				local Quad = Enum.EasingStyle.Quad
				local Enum_ = Enum
				local v624 = value5.Create(value5, Frame4, tweenInfoNew(0.3, Quad, Enum_.EasingDirection.In), {
					Position = Frame4.Position + UDim2.new(0, 0, 0, 60),
					BackgroundTransparency = 1
				})

				v624.Play(v624)

				local ipairs_ = ipairs

				for _, descendant in ipairs_(Frame4:GetDescendants()) do
					if descendant:IsA("TextLabel") or (descendant:IsA("TextButton") or descendant:IsA("TextBox")) then
						local value52 = t1.value5
						local tweenInfo = TweenInfo.new(0.3)

						ipairs_ = value52.Create(value52, descendant, tweenInfo, {
							TextTransparency = 1
						}):Play()
					elseif descendant:IsA("ImageLabel") or descendant:IsA("ImageButton") then
						local value52 = t1.value5
						local tweenInfo = TweenInfo.new(0.3)

						ipairs_ = value52.Create(value52, descendant, tweenInfo, {
							ImageTransparency = 1
						}):Play()
					elseif descendant:IsA("Frame") then
						local value52 = t1.value5
						local tweenInfo = TweenInfo.new(0.3)

						ipairs_ = value52.Create(value52, descendant, tweenInfo, {
							BackgroundTransparency = 1
						}):Play()
					else
						ipairs_ = descendant:IsA("UIStroke")

						if ipairs_ then
							local value52 = t1.value5
							local tweenInfo = TweenInfo.new(0.3)

							ipairs_ = value52.Create(value52, descendant, tweenInfo, {
								Transparency = 1
							}):Play()
						end
					end
				end

				v624.Completed:Wait()

				if connection then
					connection:Disconnect()
				end

				if connection2 then
					connection2:Disconnect()
				end

				if v601 then
					v601:Disconnect()
				end

				ScreenGui:Destroy()

				if not t19.value1 then
					return
				end

				t19.value1()
			end)
		end

		t1.value98 = false

		local value11 = t1.value11
		local v637 = #t1.value11 + 1
		local InputBegan = t1.value3.InputBegan

		value11[v637] = InputBegan.Connect(InputBegan, function(p111, p112)
			if not t1.value98 then
				return
			end

			local value77 = t1.value77

			if value77 then
				value77 = p111.UserInputType == Enum.UserInputType.Keyboard
			end

			if value77 then
				local value772 = t1.value77
				local KeyCode = p111.KeyCode

				if KeyCode == Enum.KeyCode.Backspace or (KeyCode == Enum.KeyCode.Delete and true or KeyCode == Enum.KeyCode.Escape) then
					value772.set(nil)
				else
					if KeyCode == Enum.KeyCode.Unknown then
						value772.render()
						print("[Death Ball] Keybind set to: " .. (value772.box.Text ~= "") and value772.box.Text or "None")

						return
					end

					value772.set(KeyCode)
				end

				value772.render()
				print("[Death Ball] Keybind set to: " .. (value772.box.Text ~= "") and value772.box.Text or "None")

				return
			end

			if p111.UserInputType ~= Enum.UserInputType.Keyboard then
				return
			end

			if p111.KeyCode == t1.value12.UIHideKey then
				t1.value92(not t1.value88)

				return
			end

			if p112 then
				p112 = t1.value3:GetFocusedTextBox()
			end

			if p112 then
				return
			end

			local AutoParryKey = t1.value12.AutoParryKey

			if AutoParryKey then
				AutoParryKey = p111.KeyCode == t1.value12.AutoParryKey
			end

			if AutoParryKey then
				t1.value72(not t1.value12.AutoParry)
				print("[Death Ball] Auto Parry:", t1.value12.AutoParry and "ON" or "OFF")

				return
			end

			local AutoSpamKey = t1.value12.AutoSpamKey

			if AutoSpamKey then
				AutoSpamKey = p111.KeyCode == t1.value12.AutoSpamKey
			end

			if AutoSpamKey then
				t1.value73(not t1.value12.AutoSpam)
				print("[Death Ball] Auto Spam:", t1.value12.AutoSpam and "ON" or "OFF")

				return
			end

			local AIMovementKey = t1.value12.AIMovementKey

			if AIMovementKey then
				AIMovementKey = p111.KeyCode == t1.value12.AIMovementKey
			end

			if AIMovementKey then
				t1.value74(not t1.value12.AIMovement)
				print("[Death Ball] AI Movement:", t1.value12.AIMovement and "ON" or "OFF")

				return
			end

			local CameraRotationKey = t1.value12.CameraRotationKey

			if CameraRotationKey then
				CameraRotationKey = p111.KeyCode == t1.value12.CameraRotationKey
			end

			if CameraRotationKey then
				t1.value76(not t1.value12.CameraRotation)
				print("[Death Ball] Camera Rotation:", t1.value12.CameraRotation and "ON" or "OFF")

				return
			end

			local AutoReadyKey = t1.value12.AutoReadyKey

			if AutoReadyKey then
				AutoReadyKey = p111.KeyCode == t1.value12.AutoReadyKey
			end

			if not AutoReadyKey then
				return
			end

			t1.value75(not t1.value12.AutoReady)
			print("[Death Ball] Auto Ready:", t1.value12.AutoReady and "ON" or "OFF")
		end);
		(function(p113)
			if t1.value93.Enabled then
				local Remember = t1.value93.Remember

				if Remember then
					Remember = t1.value93.SaveKey
				end

				if Remember then
					local v648 = t1.value95()
					local v649

					if v648 then
						v649 = v648 ~= ""
					else
						v649 = v648
					end

					if v649 and t1.value96(v648) then
						print("[SENTENAL Z - DEATH BALL] Saved key detected — skipping key system.")

						local function v650()
							t1.value63.Visible = true

							if not p113 then
								return
							end

							p113()
						end

						t1.value97(v650)

						return
					end
				end

				if _G.__SentenalZKeySystem then
					local __SentenalZKeySystem = _G.__SentenalZKeySystem

					for _, v in ipairs(__SentenalZKeySystem.Connections or {}) do
						pcall(function()
							v:Disconnect()
						end)
					end

					if __SentenalZKeySystem.Gui then
						pcall(function()
							__SentenalZKeySystem.Gui:Destroy()
						end)
					end

					_G.__SentenalZKeySystem = nil
				end

				local t21 = {}

				_G.__SentenalZKeySystem = {
					Connections = t21,
					Gui = nil
				}

				local ScreenGui = t1.value56("ScreenGui", {
					Name = "SentenalZ_KeySystem",
					ResetOnSpawn = false,
					ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
					IgnoreGuiInset = true,
					DisplayOrder = 100
				})
				local ok3, result3 = pcall(function()
					return gethui()
				end)

				ScreenGui.Parent = ok3 and result3 or game:GetService("CoreGui")
				_G.__SentenalZKeySystem.Gui = ScreenGui
				t1.value56("Frame", {
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundColor3 = Color3.fromRGB(0, 0, 0),
					BackgroundTransparency = 0.45,
					BorderSizePixel = 0,
					Parent = ScreenGui
				})

				local Frame4 = t1.value56("Frame", {
					Name = "ParticleHolder",
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					ZIndex = 1,
					Parent = ScreenGui
				})
				local t22 = {}

				for i = 1, 26 do
					local v661 = math.random(2, 5)
					local Frame5 = t1.value56("Frame", {
						Name = "Particle" .. i,
						Size = UDim2.new(0, v661, 0, v661),
						Position = UDim2.new(math.random(), 0, math.random(), 0),
						BackgroundColor3 = t1.value55.Accent,
						BackgroundTransparency = math.random(45, 80) / 100,
						BorderSizePixel = 0,
						ZIndex = 1,
						Parent = Frame4
					})

					t1.value58(Frame5, v661 / 2)
					t22[i] = {
						Frame = Frame5,
						Speed = math.random(8, 26) / 1000,
						Drift = (math.random() - 0.5) * 0.0004,
						Phase = math.random() * 3.141592653589793 * 2,
						BaseX = Frame5.Position.X.Scale
					}
				end

				local connection = t1.value2.RenderStepped:Connect(function(dt)
					if Frame4 and Frame4.Parent then
						local now = os.clock()

						for _, v in ipairs(t22) do
							local Frame5 = v.Frame
							local Parent

							if Frame5 then
								Parent = Frame5.Parent
							else
								Parent = Frame5
							end

							if Parent then
								local v669 = Frame5.Position.Y.Scale - v.Speed * dt * 60

								if v669 < -0.05 then
									v.BaseX = math.random()
									Frame5.Position = UDim2.new(v.BaseX, 0, 1.05, 0)
								else
									local v670 = now * 1.4 + v.Phase
									local v671 = math.sin(v670) * 0.006

									Frame5.Position = UDim2.new(v.BaseX + v671, 0, v669, 0)
								end
							end
						end
					end
				end)

				t1.value11[#t1.value11 + 1] = connection

				local Frame5 = t1.value56("Frame", {
					Name = "Card",
					Size = t1.value8,
					Position = UDim2.new(0.5, 0, 0.5, 0),
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = t1.value55.Bg,
					BorderSizePixel = 0,
					Active = true,
					Parent = ScreenGui
				})

				t1.value58(Frame5, 12)

				local _, _, v675 = t1.value60(Frame5, 1.5)

				t1.value11[#t1.value11 + 1] = v675
				Frame5.Size = t1.value8 - UDim2.new(0, 40, 0, 40)
				Frame5.BackgroundTransparency = 1
				task.spawn(function()
					local value5 = t1.value5
					local v677 = Frame5
					local TweenInfo_ = TweenInfo

					value5.Create(value5, v677, TweenInfo_.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
						Size = t1.value8,
						BackgroundTransparency = 0
					}):Play()
				end)

				local Frame6 = t1.value56("Frame", {
					Name = "DragBar",
					Size = UDim2.new(1, 0, 0, 34),
					Position = UDim2.new(0, 0, 0, 0),
					BackgroundTransparency = 1,
					Active = true,
					Parent = Frame5
				})
				local TextButton = t1.value56("TextButton", {
					Name = "CloseBtn",
					Size = UDim2.new(0, 26, 0, 26),
					Position = UDim2.new(1, -10, 0, 10),
					AnchorPoint = Vector2.new(1, 0),
					BackgroundColor3 = t1.value55.Field,
					BackgroundTransparency = 1,
					Text = "",
					AutoButtonColor = false,
					BorderSizePixel = 0,
					ZIndex = 5,
					Parent = Frame5
				})

				t1.value58(TextButton, 6)
				t1.value56("ImageLabel", {
					Name = "CloseIcon",
					Size = UDim2.new(0, 25, 0, 25),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1,
					Image = "rbxassetid://6031091004",
					ImageColor3 = t1.value55.Muted,
					ScaleType = Enum.ScaleType.Fit,
					ZIndex = 6,
					Parent = TextButton
				})

				local u681 = nil
				local Position = nil
				local Position2 = nil

				local function v684(input)
					if not (input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch) then
						return
					end

					u681 = true
					Position = input.Position
					Position2 = Frame5.Position
					input.Changed:Connect(function()
						if input.UserInputState ~= Enum.UserInputState.End then
							return
						end

						u681 = false
					end)
				end

				Frame6.InputBegan:Connect(v684)
				t1.value11[#t1.value11 + 1] = t1.value3.InputChanged:Connect(function(input)
					if not u681 then
						return
					end

					if not (input.UserInputType == Enum.UserInputType.MouseMovement and true or input.UserInputType == Enum.UserInputType.Touch) then
						return
					end

					local v685 = input.Position - Position

					Frame5.Position = UDim2.new(Position2.X.Scale, Position2.X.Offset + v685.X, Position2.Y.Scale, Position2.Y.Offset + v685.Y)
				end)

				local ImageLabel = t1.value56("ImageLabel", {
					Name = "LogoGlow",
					Size = UDim2.new(0, 96, 0, 96),
					Position = UDim2.new(0.5, 0, 0, 29),
					AnchorPoint = Vector2.new(0.5, 0),
					BackgroundTransparency = 1,
					Image = t1.value93.Logo,
					ImageColor3 = t1.value55.Accent,
					ImageTransparency = 0.55,
					ScaleType = Enum.ScaleType.Fit,
					ZIndex = 1,
					Parent = Frame5
				})
				local ImageLabel2 = t1.value56("ImageLabel", {
					Name = "Logo",
					Size = UDim2.new(0, 74, 0, 74),
					Position = UDim2.new(0.5, 0, 0, 40),
					AnchorPoint = Vector2.new(0.5, 0),
					BackgroundTransparency = 1,
					Image = t1.value93.Logo,
					ScaleType = Enum.ScaleType.Fit,
					ZIndex = 2,
					Parent = Frame5
				})
				local connection2 = t1.value2.RenderStepped:Connect(function()
					if ImageLabel2 and ImageLabel2.Parent then
						local now = os.clock()
						local v690 = math.sin(now * 1.8) * 4

						ImageLabel2.Position = UDim2.new(0.5, 0, 0, 40 + v690)
						ImageLabel.Position = UDim2.new(0.5, 0, 0, 29 + v690)

						local v691 = ImageLabel
						local v692 = now * 1.8

						v691.ImageTransparency = 0.45 + math.sin(v692) * 0.15

						local v693 = ImageLabel
						local uDim2New = UDim2.new
						local v695 = now * 1.8
						local v696 = math.sin(v695) * 6 + 96
						local v697 = now * 1.8

						v693.Size = uDim2New(0, v696, 0, math.sin(v697) * 6 + 96)
					end
				end)

				t1.value11[#t1.value11 + 1] = connection2
				t1.value56("TextLabel", {
					Size = UDim2.new(1, 0, 0, 26),
					Position = UDim2.new(0, 0, 0, 122),
					BackgroundTransparency = 1,
					Text = t1.value93.Title .. " — " .. t1.value93.Subtitle,
					TextColor3 = t1.value55.Text,
					Font = Enum.Font.GothamBold,
					TextSize = 20,
					Parent = Frame5
				})
				t1.value56("TextLabel", {
					Size = UDim2.new(1, 0, 0, 16),
					Position = UDim2.new(0, 0, 0, 148),
					BackgroundTransparency = 1,
					Text = "KEY SYSTEM · " .. t1.value93.Version,
					TextColor3 = t1.value55.Muted,
					Font = Enum.Font.GothamMedium,
					TextSize = 11,
					Parent = Frame5
				})

				local Frame7 = t1.value56("Frame", {
					Size = UDim2.new(1, -24, 0, 40),
					Position = UDim2.new(0.5, 0, 0, 176),
					AnchorPoint = Vector2.new(0.5, 0),
					BackgroundColor3 = t1.value55.Field,
					BorderSizePixel = 0,
					Parent = Frame5
				})

				t1.value58(Frame7, 8)
				t1.value59(Frame7, t1.value55.Border, 1)

				local TextBox = t1.value56("TextBox", {
					Size = UDim2.new(1, -20, 1, 0),
					Position = UDim2.new(0, 10, 0, 0),
					BackgroundTransparency = 1,
					Text = "",
					PlaceholderText = "Get key from Discord...",
					PlaceholderColor3 = t1.value55.Muted,
					TextColor3 = t1.value55.Text,
					Font = Enum.Font.GothamMedium,
					TextSize = 13,
					TextXAlignment = Enum.TextXAlignment.Left,
					ClearTextOnFocus = false,
					Parent = Frame7
				})
				local TextLabel = t1.value56("TextLabel", {
					Size = UDim2.new(1, -60, 0, 16),
					Position = UDim2.new(0.5, 0, 0, 232),
					AnchorPoint = Vector2.new(0.5, 0),
					BackgroundTransparency = 1,
					Text = "",
					TextColor3 = t1.value55.Muted,
					Font = Enum.Font.GothamMedium,
					TextSize = 11,
					Parent = Frame5
				})

				local function v701(p114, p115, p116, p117, p118)
					local TextButton2 = t1.value56("TextButton", {
						Size = UDim2.new(1, 0, 0, 34),
						BackgroundColor3 = p115,
						TextColor3 = Color3.fromRGB(255, 255, 255),
						Font = Enum.Font.GothamBold,
						TextSize = 13,
						Text = p114,
						AutoButtonColor = false,
						BorderSizePixel = 0,
						ClipsDescendants = true,
						Parent = p117
					})

					t1.value58(TextButton2, 8)
					t1.value56("UIStroke", {
						Color = Color3.fromRGB(0, 0, 0),
						Thickness = 1,
						Transparency = p118 and 0.85 or 0.75,
						ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
						Parent = TextButton2
					})

					local value56 = t1.value56
					local colorSequence

					if p118 then
						colorSequence = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(108, 158, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(64, 108, 220)) })
					else
						colorSequence = p118
					end

					value56("UIGradient", {
						Rotation = 90,
						Color = colorSequence or ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(46, 46, 58)), ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 38)) }),
						Parent = TextButton2
					})

					local value59 = t1.value59
					local Accent

					if p118 then
						Accent = t1.value55.Accent
					else
						Accent = p118
					end

					local v707 = value59(TextButton2, Accent or t1.value55.Border, 1)
					local UIStroke = t1.value56("UIStroke", {
						Color = t1.value55.Accent,
						Thickness = 1,
						Transparency = 1,
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
						Parent = TextButton2
					})
					local Frame8 = t1.value56("Frame", {
						Size = UDim2.new(0, 40, 1, 0),
						Position = UDim2.new(0, -50, 0, 0),
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 0.85,
						BorderSizePixel = 0,
						ZIndex = 2,
						Parent = TextButton2
					})

					t1.value56("UIGradient", {
						Rotation = 90,
						Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0), NumberSequenceKeypoint.new(1, 1) }),
						Parent = Frame8
					})

					local Size = TextButton2.Size

					TextButton2.MouseEnter:Connect(function()
						local t23 = {
							BackgroundColor3 = p116
						}

						t1.value5:Create(TextButton2, TweenInfo.new(0.15), t23):Play()

						local value5 = t1.value5
						local v713 = v707
						local tweenInfoNew = TweenInfo.new

						value5.Create(value5, v713, tweenInfoNew(0.15), {
							Color = t1.value55.Accent,
							Transparency = 0
						}):Play()
						t1.value5:Create(UIStroke, TweenInfo.new(0.2), {
							Transparency = 0.55,
							Thickness = 2
						}):Play()
						Frame8.Position = UDim2.new(0, -50, 0, 0)

						local value52 = t1.value5
						local v716 = Frame8
						local tweenInfoNew2 = TweenInfo.new
						local Quad = Enum.EasingStyle.Quad
						local Enum_ = Enum

						value52.Create(value52, v716, tweenInfoNew2(0.5, Quad, Enum_.EasingDirection.Out), {
							Position = UDim2.new(1, 10, 0, 0)
						}):Play()
					end)
					TextButton2.MouseLeave:Connect(function()
						local t24 = {
							BackgroundColor3 = p115
						}

						t1.value5:Create(TextButton2, TweenInfo.new(0.15), t24):Play()

						local value5 = t1.value5
						local v722 = v707
						local tweenInfo = TweenInfo.new(0.15)
						local Accent2 = p118

						if not Accent2 then
							value5:Create(v722, tweenInfo, {
								Color = Accent2 or t1.value55.Border,
								Transparency = 0
							}):Play()
							t1.value5:Create(UIStroke, TweenInfo.new(0.2), {
								Transparency = 1,
								Thickness = 1
							}):Play()

							return
						end

						Accent2 = t1.value55.Accent
						value5:Create(v722, tweenInfo, {
							Color = Accent2 or t1.value55.Border,
							Transparency = 0
						}):Play()
						t1.value5:Create(UIStroke, TweenInfo.new(0.2), {
							Transparency = 1,
							Thickness = 1
						}):Play()
					end)
					TextButton2.MouseButton1Down:Connect(function()
						local value5 = t1.value5
						local v726 = TextButton2
						local tweenInfo = TweenInfo.new(0.08)
						local v728 = Size
						local uDim2New = UDim2.new

						value5.Create(value5, v726, tweenInfo, {
							Size = v728 - uDim2New(0, 4, 0, 2)
						}):Play()
					end)
					TextButton2.MouseButton1Up:Connect(function()
						local t25 = {
							Size = Size
						}

						t1.value5:Create(TextButton2, TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out), t25):Play()
					end)

					return TextButton2
				end

				local Frame8 = t1.value56("Frame", {
					Size = UDim2.new(1, -24, 0, 78),
					Position = UDim2.new(0.5, 0, 0, 258),
					AnchorPoint = Vector2.new(0.5, 0),
					BackgroundTransparency = 1,
					Parent = Frame5
				})

				t1.value56("UIListLayout", {
					Padding = UDim.new(0, 10),
					SortOrder = Enum.SortOrder.LayoutOrder,
					Parent = Frame8
				})

				local submitKey = v701("Submit Key", t1.value55.Accent, Color3.fromRGB(108, 158, 255), Frame8, true)
				local v733 = v701("Get Key · Discord", t1.value55.Accent, Color3.fromRGB(108, 158, 255), Frame8, true)

				submitKey.Size = UDim2.new(1, 0, 0, 34)
				v733.Size = UDim2.new(1, 0, 0, 34)
				t1.value56("Frame", {
					Size = UDim2.new(1, -24, 0, 1),
					Position = UDim2.new(0.5, 0, 1, -68),
					AnchorPoint = Vector2.new(0.5, 0),
					BackgroundColor3 = t1.value55.Border,
					BorderSizePixel = 0,
					Parent = Frame5
				})

				local Frame9 = t1.value56("Frame", {
					Name = "StatusPills",
					Size = UDim2.new(1, -24, 0, 22),
					Position = UDim2.new(0.5, 0, 1, -60),
					AnchorPoint = Vector2.new(0.5, 0),
					BackgroundTransparency = 1,
					Parent = Frame5
				})

				t1.value56("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					Padding = UDim.new(0, 6),
					SortOrder = Enum.SortOrder.LayoutOrder,
					Parent = Frame9
				})

				local function v735(p119, p120, p121)
					local Frame10 = t1.value56("Frame", {
						Size = UDim2.new(0, 0, 0, 20),
						AutomaticSize = Enum.AutomaticSize.X,
						BackgroundColor3 = t1.value55.Field,
						BorderSizePixel = 0,
						Parent = Frame9
					})

					t1.value58(Frame10, 10)
					t1.value59(Frame10, t1.value55.Border, 1)
					t1.value56("UIPadding", {
						PaddingLeft = UDim.new(0, 9),
						PaddingRight = UDim.new(0, 9),
						Parent = Frame10
					})
					t1.value56("UIListLayout", {
						FillDirection = Enum.FillDirection.Horizontal,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						Padding = UDim.new(0, 5),
						SortOrder = Enum.SortOrder.LayoutOrder,
						Parent = Frame10
					})

					if not p120 then
						t1.value56("TextLabel", {
							Size = UDim2.new(0, 0, 1, 0),
							AutomaticSize = Enum.AutomaticSize.X,
							BackgroundTransparency = 1,
							Text = p119,
							TextColor3 = p121 or t1.value55.Muted,
							Font = Enum.Font.GothamBold,
							TextSize = 10,
							LayoutOrder = 2,
							Parent = Frame10
						})

						return Frame10
					end

					local Frame11 = t1.value56("Frame", {
						Size = UDim2.new(0, 6, 0, 6),
						BackgroundColor3 = p120,
						BorderSizePixel = 0,
						LayoutOrder = 1,
						Parent = Frame10
					})

					t1.value58(Frame11, 3)
					t1.value56("TextLabel", {
						Size = UDim2.new(0, 0, 1, 0),
						AutomaticSize = Enum.AutomaticSize.X,
						BackgroundTransparency = 1,
						Text = p119,
						TextColor3 = p121 or t1.value55.Muted,
						Font = Enum.Font.GothamBold,
						TextSize = 10,
						LayoutOrder = 2,
						Parent = Frame10
					})

					return Frame10
				end

				v735("ONLINE", t1.value55.Green, t1.value55.Green)
				v735(t1.value93.Version, nil, t1.value55.Muted)
				v735("DEATH BALL", nil, t1.value55.Accent)

				local Frame10 = t1.value56("Frame", {
					Name = "Credits",
					Size = UDim2.new(1, -24, 0, 26),
					Position = UDim2.new(0.5, 0, 1, -30),
					AnchorPoint = Vector2.new(0.5, 0),
					BackgroundTransparency = 1,
					Parent = Frame5
				})

				t1.value56("TextLabel", {
					Size = UDim2.new(1, 0, 0, 12),
					BackgroundTransparency = 1,
					Text = "Powered By Sentenal Z Exploit Team",
					TextColor3 = t1.value55.Text,
					Font = Enum.Font.GothamBold,
					TextSize = 11,
					Parent = Frame10
				})
				t1.value56("TextLabel", {
					Size = UDim2.new(1, 0, 0, 12),
					Position = UDim2.new(0, 0, 0, 13),
					BackgroundTransparency = 1,
					Text = "Credits to TanqRfake11  ·  Haruto_Kunshi1",
					TextColor3 = t1.value55.Muted,
					Font = Enum.Font.GothamMedium,
					TextSize = 10,
					Parent = Frame10
				})

				local function v739()
					local ipairs_ = ipairs
					local v741 = Frame5

					for _, descendant in ipairs_(v741.GetDescendants(v741)) do
						if descendant:IsA("TextLabel") or (descendant:IsA("TextButton") or descendant:IsA("TextBox")) then
							local value5 = t1.value5
							local tweenInfoNew = TweenInfo.new

							ipairs_ = value5.Create(value5, descendant, tweenInfoNew(0.22), {
								TextTransparency = 1,
								BackgroundTransparency = 1
							}):Play()
						elseif descendant:IsA("ImageLabel") or descendant:IsA("ImageButton") then
							local value5 = t1.value5
							local tweenInfo = TweenInfo.new(0.22)

							ipairs_ = value5.Create(value5, descendant, tweenInfo, {
								ImageTransparency = 1,
								BackgroundTransparency = 1
							}):Play()
						elseif descendant:IsA("Frame") then
							local value5 = t1.value5
							local tweenInfo = TweenInfo.new(0.22)

							ipairs_ = value5.Create(value5, descendant, tweenInfo, {
								BackgroundTransparency = 1
							}):Play()
						else
							ipairs_ = descendant:IsA("UIStroke")

							if ipairs_ then
								local value5 = t1.value5
								local tweenInfo = TweenInfo.new(0.22)

								ipairs_ = value5.Create(value5, descendant, tweenInfo, {
									Transparency = 1
								}):Play()
							end
						end
					end

					task.wait(0.22)

					local value5 = t1.value5
					local v753 = Frame5
					local tweenInfoNew = TweenInfo.new
					local Quad = Enum.EasingStyle.Quad
					local Out = Enum.EasingDirection.Out

					value5.Create(value5, v753, tweenInfoNew(0.28, Quad, Out), {
						Size = UDim2.new(0, 260, 0, 220)
					}):Play()
					task.wait(0.28)

					local Frame11 = t1.value56("Frame", {
						Name = "LoadHolder",
						Size = UDim2.new(1, 0, 1, 0),
						BackgroundTransparency = 1,
						Parent = Frame5
					})
					local n14 = 72
					local Frame12 = t1.value56("Frame", {
						Name = "Track",
						Size = UDim2.new(0, n14, 0, n14),
						Position = UDim2.new(0.5, 0, 0, 28),
						AnchorPoint = Vector2.new(0.5, 0),
						BackgroundTransparency = 1,
						Parent = Frame11
					})

					t1.value58(Frame12, n14 / 2)
					t1.value56("UIStroke", {
						Color = t1.value55.Field,
						Thickness = 4,
						Parent = Frame12
					})

					local Frame13 = t1.value56("Frame", {
						Name = "Arc",
						Size = UDim2.new(0, n14, 0, n14),
						Position = UDim2.new(0.5, 0, 0, 28),
						AnchorPoint = Vector2.new(0.5, 0),
						BackgroundTransparency = 1,
						Parent = Frame11
					})

					t1.value58(Frame13, n14 / 2)

					local UIStroke = t1.value56("UIStroke", {
						Color = t1.value55.Accent,
						Thickness = 4,
						LineJoinMode = Enum.LineJoinMode.Round,
						Parent = Frame13
					})

					t1.value56("UIGradient", {
						Rotation = 0,
						Transparency = NumberSequence.new({
							NumberSequenceKeypoint.new(0, 0),
							NumberSequenceKeypoint.new(0.55, 0),
							NumberSequenceKeypoint.new(0.75, 1),
							NumberSequenceKeypoint.new(1, 1)
						}),
						Parent = UIStroke
					})

					local connection3 = t1.value2.RenderStepped:Connect(function(dt)
						local Parent = Frame13

						if Parent then
							Parent = Frame13.Parent
						end

						if not Parent then
							return
						end

						Frame13.Rotation = (Frame13.Rotation + dt * 260) % 360
					end)

					t1.value11[#t1.value11 + 1] = connection3
					t1.value56("TextLabel", {
						Size = UDim2.new(1, 0, 0, 30),
						Position = UDim2.new(0, 0, 0, 116),
						BackgroundTransparency = 1,
						Text = "Loading Sentenal Z",
						TextColor3 = t1.value55.Text,
						Font = Enum.Font.GothamBold,
						TextSize = 22,
						Parent = Frame11
					})
					t1.value56("TextLabel", {
						Size = UDim2.new(1, 0, 0, 14),
						Position = UDim2.new(0, 0, 0, 146),
						BackgroundTransparency = 1,
						Text = t1.value93.Version .. "  ·  " .. t1.value93.Subtitle,
						TextColor3 = t1.value55.Muted,
						Font = Enum.Font.GothamMedium,
						TextSize = 11,
						Parent = Frame11
					})

					local Frame14 = t1.value56("Frame", {
						Name = "ProgressTrack",
						Size = UDim2.new(1, -50, 0, 6),
						Position = UDim2.new(0.5, 0, 0, 170),
						AnchorPoint = Vector2.new(0.5, 0),
						BackgroundColor3 = t1.value55.Field,
						BorderSizePixel = 0,
						Parent = Frame11
					})

					t1.value58(Frame14, 3)

					local Frame15 = t1.value56("Frame", {
						Name = "ProgressFill",
						Size = UDim2.new(0, 0, 1, 0),
						BackgroundColor3 = t1.value55.Accent,
						BorderSizePixel = 0,
						Parent = Frame14
					})

					t1.value58(Frame15, 3)

					local TextLabel2 = t1.value56("TextLabel", {
						Size = UDim2.new(1, -50, 0, 14),
						Position = UDim2.new(0.5, 0, 0, 182),
						AnchorPoint = Vector2.new(0.5, 0),
						BackgroundTransparency = 1,
						Text = "0%",
						TextColor3 = t1.value55.Muted,
						Font = Enum.Font.GothamMedium,
						TextSize = 11,
						Parent = Frame11
					})
					local n15 = 0
					local connection4 = t1.value2.RenderStepped:Connect(function(dt)
						if Frame15 and Frame15.Parent then
							local v769 = n15 + dt

							n15 = math.min(v769, 1.8)

							local v770 = n15 / 1.8

							Frame15.Size = UDim2.new(v770, 0, 1, 0)

							local v771 = TextLabel2
							local format = string.format
							local v773 = v770 * 100 + 0.5

							v771.Text = format("%d%%", (math.floor(v773)))
						end
					end)

					t1.value11[#t1.value11 + 1] = connection4
					task.wait(1.95)

					local value52 = t1.value5
					local v775 = Frame5
					local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
					local v777 = value52.Create(value52, v775, tweenInfo, {
						Position = Frame5.Position + UDim2.new(0, 0, 0, 60),
						BackgroundTransparency = 1
					})

					v777.Play(v777)

					local v778, v779, v780 = ipairs(Frame5:GetDescendants())

					while true do
						local v781

						v780, v781 = v778(v779, v780)

						if not v780 then
							break
						end

						if v781:IsA("TextLabel") or (v781:IsA("TextButton") or v781:IsA("TextBox")) then
							t1.value5:Create(v781, TweenInfo.new(0.3), {
								TextTransparency = 1
							}):Play()
						elseif v781:IsA("ImageLabel") or v781:IsA("ImageButton") then
							local value53 = t1.value5
							local TweenInfo_ = TweenInfo

							value53.Create(value53, v781, TweenInfo_.new(0.3), {
								ImageTransparency = 1
							}):Play()
						elseif v781:IsA("Frame") then
							local value53 = t1.value5
							local tweenInfo2 = TweenInfo.new(0.3)

							value53.Create(value53, v781, tweenInfo2, {
								BackgroundTransparency = 1
							}):Play()
						elseif v781:IsA("UIStroke") then
							t1.value5:Create(v781, TweenInfo.new(0.3), {
								Transparency = 1
							}):Play()
						end
					end

					v777.Completed:Wait()

					if connection3 then
						connection3:Disconnect()
					end

					if connection4 then
						connection4:Disconnect()
					end

					if connection then
						connection:Disconnect()
					end

					if connection2 then
						connection2:Disconnect()
					end

					for _, v in ipairs(t21) do
						pcall(function()
							v:Disconnect()
						end)
					end

					_G.__SentenalZKeySystem = nil
					ScreenGui:Destroy()
					t1.value63.Visible = true

					if not p113 then
						return
					end

					p113()
				end
				local function v788()
					local Text = TextBox.Text

					TextLabel.Text = "Checking..."
					TextLabel.TextColor3 = t1.value55.Muted
					task.spawn(function()
						local v790, v791 = t1.value96(Text)

						if not v790 then
							TextLabel.Text = v791
							TextLabel.TextColor3 = Color3.fromRGB(232, 92, 92)

							local value5 = t1.value5
							local v793 = Frame7
							local tweenInfo = TweenInfo.new(0.08)
							local Color3_ = Color3

							value5.Create(value5, v793, tweenInfo, {
								BackgroundColor3 = Color3_.fromRGB(60, 30, 34)
							}):Play()
							task.wait(0.25)

							local value52 = t1.value5
							local v797 = Frame7
							local tweenInfoNew = TweenInfo.new

							value52.Create(value52, v797, tweenInfoNew(0.2), {
								BackgroundColor3 = t1.value55.Field
							}):Play()

							return
						end

						TextLabel.Text = v791
						TextLabel.TextColor3 = t1.value55.Green

						local v799 = Text
						local writefile_ = t1.value93.SaveKey and (writefile or write_file)

						if not writefile_ then
							task.wait(0.4)
							v739()

							return
						end

						pcall(writefile_, t1.value94, v799)
						task.wait(0.4)
						v739()
					end)
				end

				submitKey.MouseButton1Click:Connect(v788)
				TextBox.FocusLost:Connect(function(enterPressed)
					if not enterPressed then
						return
					end

					v788()
				end)

				local function v801()
					v536(t1.value93.DiscordURL)
					TextLabel.Text = "Join Discord → find the key → paste above"
					TextLabel.TextColor3 = t1.value55.Accent
				end

				v733.MouseButton1Click:Connect(v801)
				TextButton.MouseButton1Click:Connect(function()
					local value5 = t1.value5
					local v803 = Frame5
					local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
					local Position3 = Frame5.Position
					local uDim2New = UDim2.new
					local v807 = value5.Create(value5, v803, tweenInfo, {
						Position = Position3 + uDim2New(0, 0, 0, 60),
						BackgroundTransparency = 1
					})

					v807.Play(v807)

					local ipairs_ = ipairs
					local v809 = Frame5
					local v810, v811, v812 = ipairs_(v809.GetDescendants(v809))

					while true do
						local v813

						v812, v813 = v810(v811, v812)

						if not v812 then
							break
						end

						if v813:IsA("TextLabel") or (v813:IsA("TextButton") or v813:IsA("TextBox")) then
							ipairs_ = t1.value5:Create(v813, TweenInfo.new(0.3), {
								TextTransparency = 1,
								BackgroundTransparency = 1
							}):Play()
						elseif v813:IsA("ImageLabel") or v813:IsA("ImageButton") then
							ipairs_ = t1.value5:Create(v813, TweenInfo.new(0.3), {
								ImageTransparency = 1,
								BackgroundTransparency = 1
							}):Play()
						elseif v813:IsA("Frame") then
							ipairs_ = t1.value5:Create(v813, TweenInfo.new(0.3), {
								BackgroundTransparency = 1
							}):Play()
						else
							ipairs_ = v813:IsA("UIStroke")

							if ipairs_ then
								local value52 = t1.value5
								local tweenInfo2 = TweenInfo.new(0.3)

								ipairs_ = value52.Create(value52, v813, tweenInfo2, {
									Transparency = 1
								}):Play()
							end
						end
					end

					v807.Completed:Wait()

					for _, v in ipairs(t21) do
						pcall(function()
							v:Disconnect()
						end)
					end

					_G.__SentenalZKeySystem = nil
					ScreenGui:Destroy()
					t1.value63.Visible = true

					if not p113 then
						return
					end

					p113()
				end)

				return
			end

			if not p113 then
				return
			end

			p113()
		end)(function()
			if t1.value12.AutoSpam then
				t1.value27()
			end

			local print_ = print
			local Name = t1.value12.AutoParryKey and t1.value12.AutoParryKey.Name or "-"
			local AutoSpamKey = t1.value12.AutoSpamKey

			if AutoSpamKey then
				AutoSpamKey = t1.value12.AutoSpamKey.Name
			end

			local v821 = AutoSpamKey or "unbound"
			local Name2 = t1.value12.AIMovementKey and t1.value12.AIMovementKey.Name or "unbound"
			local CameraRotationKey = t1.value12.CameraRotationKey

			if CameraRotationKey then
				CameraRotationKey = t1.value12.CameraRotationKey.Name
			end

			local v824 = CameraRotationKey or "unbound"
			local AutoReadyKey = t1.value12.AutoReadyKey

			if not AutoReadyKey then
				print_("[SENTENAL Z - DEATH BALL] Loaded. Parry [" .. Name .. "] · Spam [" .. v821 .. "] · AI [" .. Name2 .. "] · Cam [" .. v824 .. "] · Ready [" .. (AutoReadyKey or "unbound") .. "]")

				return
			end

			AutoReadyKey = t1.value12.AutoReadyKey.Name
			print_("[SENTENAL Z - DEATH BALL] Loaded. Parry [" .. Name .. "] · Spam [" .. v821 .. "] · AI [" .. Name2 .. "] · Cam [" .. v824 .. "] · Ready [" .. (AutoReadyKey or "unbound") .. "]")
		end)

		return
	end

	local v826 = math.random(2, 4)
	local Frame = t1.value56("Frame", {
		Name = "MParticle" .. v368,
		Size = UDim2.new(0, v826, 0, v826),
		Position = UDim2.new(math.random(), 0, math.random(), 0),
		BackgroundColor3 = t1.value55.Accent,
		BackgroundTransparency = math.random(55, 85) / 100,
		BorderSizePixel = 0,
		ZIndex = 1,
		Parent = t1.value81
	})

	t1.value58(Frame, v826 / 2)
	t1.value82[v368] = {
		Frame = Frame,
		Speed = math.random(6, 20) / 1000,
		Phase = math.random() * 3.141592653589793 * 2,
		BaseX = Frame.Position.X.Scale
	}
end
