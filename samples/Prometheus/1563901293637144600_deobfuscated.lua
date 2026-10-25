-- This file was generated at discord.gg/syncrypt

local unpack_ = unpack or table.unpack
local v4 = nil
local t2 = {
	value1 = game:GetService("Players"),
	value2 = game:GetService("RunService"),
	value3 = game:GetService("UserInputService"),
	value4 = game:GetService("VirtualInputManager"),
	value5 = game:GetService("TweenService"),
	value6 = game:GetService("ReplicatedStorage")
}

t2.value7 = t2.value1.LocalPlayer

local uDim2 = UDim2.new(0, 300, 0, 560)

t2.value8 = UDim2.new(0, 300, 0, 470)
t2.value9 = _G.__DeathBallAutoParry

local value9 = t2.value9

if type(value9) == "table" then
	value9, v544, v8 = ipairs(t2.value9.Connections or {})

	while true do
		local v7

		v8, v7 = value9(v544, v8)

		if not v8 then
			break
		end

		pcall(function()
			v7:Disconnect()
		end)
	end

	if t2.value9.Gui then
		pcall(function()
			t2.value9.Gui:Destroy()
		end)
	end

	if t2.value9.NotifGui then
		pcall(function()
			t2.value9.NotifGui:Destroy()
		end)
	end
end

t2.value10 = _G.__SentenalZKeySystem

local value10 = t2.value10

if type(value10) == "table" then
	for _, v in ipairs(t2.value10.Connections or {}) do
		pcall(function()
			v:Disconnect()
		end)
	end

	if t2.value10.Gui then
		pcall(function()
			t2.value10.Gui:Destroy()
		end)
	end

	_G.__SentenalZKeySystem = nil
end

t2.value11 = nil
t2.value11 = {}
pcall(function()
	t2.value11[#t2.value11 + 1] = gethui()
end)
t2.value11[#t2.value11 + 1] = game:GetService("CoreGui")

for _, v in ipairs(t2.value11) do
	for _, v2 in ipairs({ "DeathBallToggle", "SentenalZ_Loading", "SentenalZ_KeySystem" }) do
		local v15 = v:FindFirstChild(v2)

		if v15 then
			pcall(function()
				v15:Destroy()
			end)
		end
	end
end

_G.__DBGen = (_G.__DBGen or 0) + 1
t2.value12 = _G.__DBGen
t2.value13 = {}
_G.__DeathBallAutoParry = {
	Connections = t2.value13,
	Gui = nil,
	Gen = t2.value12
}
t2.value14 = {
	AutoParry = true,
	AutoParryKey = Enum.KeyCode.R,
	AutoSpam = false,
	AutoSpamKey = Enum.KeyCode.E,
	AutoSpamRate = 0.05,
	AIMovement = false,
	AIMovementKey = nil,
	FollowBall = false,
	JumpInterval = 3,
	AutoDash = false,
	AutoDashKey = nil,
	DashRate = 0.1,
	Fly = false,
	FlyKey = nil,
	FlySpeed = 60,
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
	InfiniteParry = true,
	Range = 0.05,
	DirectPoint = 15,
	PingCompensationMultiplier = 0.5,
	PerfectParryMultiplier = 1,
	UIHideKey = Enum.KeyCode.RightControl,
	DiscordURL = "http://discord.gg/Cj7t4Xvzpj"
}

function t2.value15(p1)
	if p1 then
		return p1.FindFirstChildWhichIsA(p1, "Humanoid")
	end
end

local function v16(p2)
	local now = os.clock()
	local v18 = nil

	local function v19()
		return (p2 or 0) <= os.clock() - v18
	end

	v18 = now

	return v19
end

t2.value16 = getrawmetatable or getmetatable
t2.value17 = setrawmetatable or setmetatable

function t2.value18(...)
	local t3 = { ... }
	local t4 = {}

	for _, v in pairs(t3) do
		if (type(v) == "table" and true or type(v) == "userdata") and not t4[v] then
			pcall(function()
				local v24 = t2.value16(v)

				if not v24 then
					return
				end

				t4[v] = v24
				t2.value17(v, {})
			end)
		end
	end

	return function()
		for _, v in pairs(t3) do
			if t4[v] then
				local function v27()
					local v28 = t4[v]

					t2.value17(v, v28)
				end

				pcall(v27)
				t4[v] = nil
			end
		end
	end
end
function t2.value19(p3, p4, p5, p6)
	local v29 = p3 - p4

	return (v29 - v29.Unit * (p6 or 0)) / p5.Magnitude
end
function t2.value20(p7, p8, p9, p10)
	local v30 = p7 - p8
	local v31 = v30 - v30.Unit * (p10 or 0)

	if not v31 then
		return v31 == v31 and v31 and v31 or 0
	end

	v31 = v31.Unit:Dot(p9.Unit)

	return v31 == v31 and v31 and v31 or 0
end
function t2.value21(p11)
	local pairs_ = pairs
	local n1 = 0
	local n2 = 0

	for _ in pairs_(p11) do
		n1 = n1 + 1
		pairs_ = n1
	end

	if p11.ETA then
		for _, value in pairs(p11.ETA.Values) do
			if value.Magnitude <= p11.ETA.Threshold then
				n2 = n2 + 1

				break
			end
		end
	end

	if not p11.Dot then
		v46 = n1 > 0

		if not v46 then
			return v46
		end

		v46 = n2 > 0

		if not v46 then
			return v46
		end

		v46 = n1 == n2

		return v46
	end

	for _, value in pairs(p11.Dot.Values) do
		if value <= p11.Dot.Threshold then
			n2 = n2 + 1

			break
		end
	end

	local v40 = n1 > 0

	if not v40 then
		return v40
	end

	v40 = n2 > 0

	if not v40 then
		return v40
	end

	v40 = n1 == n2

	return v40
end
function t2.value22()
	t2.value4:SendMouseButtonEvent(0, 0, 0, true, game, 0)
	t2.value4:SendMouseButtonEvent(0, 0, 0, false, game, 0)
end

t2.value23 = {
	Value = 0.05,
	At = 0
}

local function v41()
	local now = os.clock()

	if now - t2.value23.At < 0.25 then
		return t2.value23.Value
	end

	t2.value23.At = now

	local networkPing = nil

	pcall(function()
		networkPing = t2.value7:GetNetworkPing()
	end)

	if not (not networkPing or networkPing <= 0) then
		v49 = networkPing or 0.05
		t2.value23.Value = math.clamp(v49, 0, 1)

		return t2.value23.Value
	end

	pcall(function()
		networkPing = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() / 1000
	end)

	local v44 = networkPing or 0.05

	t2.value23.Value = math.clamp(v44, 0, 1)

	return t2.value23.Value
end

t2.value24 = _G.__DeathBallBalls

if not t2.value24 then
	t2.value24 = {}
	_G.__DeathBallBalls = t2.value24
end

t2.value25 = 0
t2.value26 = nil

function t2.value26(p12)
	local function v45(p13)
		if type(p13) == "table" then
			local Render = p13.Render

			if type(Render) == "function" then
				return p13
			else
				for _, v in pairs(p13) do
					local v50

					if type(v) == "table" then
						local Render2 = v.Render

						v50 = type(Render2) == "function"
					else
						v50 = false
					end

					if v50 then
						return v
					end
				end

				return
			end
		end
	end

	local ok, result = pcall(debug.getupvalues, p12)

	return ok and v45(result) or v45(p12)
end
function t2.value27()
	local pairs_ = pairs
	local t5 = {}

	pcall(function()
		local next_ = next
		local v56, key = getreg()

		while true do
			local v58

			key, v58 = next_(v56, key)

			if not key then
				break
			end

			if typeof(v58) == "table" then
				local next_2 = next
				local key2 = nil

				while true do
					local v61

					key2, v61 = next_2(v58, key2)

					if not key2 then
						break
					end

					local v62

					if typeof(v61) == "Instance" then
						v62 = not v61.Parent
					else
						v62 = false
					end

					if v62 then
						local v63 = t5

						table.insert(v63, v61)
					end
				end
			end
		end
	end)

	for _, v in pairs_(t5) do
		local isModuleScript = v:IsA("ModuleScript")

		if isModuleScript then
			isModuleScript = v.Name:match("lBall")
		end

		if isModuleScript then
			local ok, result = pcall(require, v)

			if ok then
				local v69 = t2.value26(result)
				local v70

				if v69 then
					local Render = v69.Render

					v70 = type(Render) == "function"
				else
					v70 = v69
				end

				if v70 then
					if not _G.__DeathBallBaseRender then
						_G.__DeathBallBaseRender = v69.Render
					end

					local __DeathBallBaseRender = _G.__DeathBallBaseRender

					local function render(p14)
						local v74 = t2.value24[p14]
						local v75

						if v74 then
							v75 = v74
						else
							v74 = {}
							t2.value24[p14] = v74

							if p14.Body then
								local function v76()
									p14.Body.Destroying:Connect(function()
										t2.value24[p14] = nil
									end)
								end

								pcall(v76)
								v75 = v74
							else
								v75 = v74
							end
						end

						v74.Object = p14.Body
						v74.TargetUserId = p14.TargetUserId

						local TargetUserId = p14.TargetUserId

						if TargetUserId then
							TargetUserId = t2.value1:GetPlayerByUserId(tonumber(p14.TargetUserId))
						end

						v74.Target = TargetUserId
						v74.isPhasingThrough = p14.isPhasingThrough
						v74.Velocity = p14.Velocity
						v74.Position = p14.Position

						local now = os.clock()
						local value25

						if t2.value25 > 0 then
							value25 = t2.value25
						else
							value25 = false
						end

						local v80 = now - (value25 or now)
						local Position = v74.Position - v74.LastPosition or v74.Position

						if v80 > 0 then
							v74.ObjectVelocity = Position / (v80 or 1)
							v74.LastPosition = v74.Position
							t2.value25 = now

							return __DeathBallBaseRender(p14)
						end

						v80 = false
						v74.ObjectVelocity = Position / (v80 or 1)
						v74.LastPosition = v74.Position
						t2.value25 = now

						return __DeathBallBaseRender(p14)
					end

					local v82 = t2.value18(v69)

					v69.Render = render
					v82()
					_G.__DeathBallHook = render

					return true
				end
			end
		end
	end

	return false
end

task.spawn(function()
	while _G.__DBGen == t2.value12 do
		pcall(t2.value27)
		task.wait(1)
	end
end)
t2.value28 = nil
t2.value29 = nil
t2.value29 = {
	Running = false
}

function t2.value30()
	t2.value29.Running = false

	if not t2.value28 then
		return
	end

	t2.value28.Visible = false
end
function t2.value31()
	if t2.value28 then
		t2.value28.Visible = true
	end

	if t2.value29.Running then
		return
	end

	t2.value29.Running = true
	task.spawn(function()
		while true do
			local Running = t2.value29.Running

			if Running then
				Running = _G.__DBGen == t2.value12
			end

			if not Running then
				t2.value29.Running = false

				return
			end

			t2.value22()
			task.wait(t2.value14.AutoSpamRate)
		end
	end)
end

t2.value32 = "DeathBallAIMovement"
t2.value33 = {
	Running = false,
	Direction = Vector3.zero,
	NextTurn = 0,
	NextJump = 0,
	AvoidUntil = 0,
	AvoidDirection = Vector3.zero
}
t2.value2:UnbindFromRenderStep(t2.value32)

local function v84(p15)
	local huge = math.huge
	local v86 = nil

	for _, v in pairs(t2.value24) do
		local Object = v.Object
		local v90 = typeof(Object) == "Instance"

		if v90 then
			v90 = Object:IsA("BasePart")

			if v90 then
				v90 = Object.Parent

				if v90 then
					v90 = Object.Transparency < 1
				end
			end
		end

		if v90 then
			local Position = v.Position

			if typeof(Position) ~= "Vector3" then
				Position = Object.Position
			end

			local Magnitude = (Position - p15.Position).Magnitude

			if Magnitude < huge then
				v86 = Position
				huge = Magnitude
			end
		end
	end

	return v86
end

function t2.value34()
	t2.value33.Running = false
	t2.value2:UnbindFromRenderStep(t2.value32)

	local v93 = t2.value15(t2.value7.Character)

	if not v93 then
		return
	end

	v93:Move(Vector3.zero, false)
end

t2.value35 = false

function t2.value36()
	if not (t2.value35 and t2.value14.AIMovement) then
		return
	end

	if t2.value33.Running then
		return
	end

	t2.value33.Running = true
	t2.value33.NextTurn = 0
	t2.value33.NextJump = os.clock() + t2.value14.JumpInterval
	t2.value33.AvoidUntil = 0
	t2.value2:UnbindFromRenderStep(t2.value32)

	local value2 = t2.value2
	local value32 = t2.value32
	local Character = Enum.RenderPriority.Character

	value2.BindToRenderStep(value2, value32, Character.Value + 1, function()
		if not t2.value33.Running or (not t2.value35 or (not t2.value14.AIMovement or _G.__DBGen ~= t2.value12)) then
			t2.value34()

			return
		end

		local v97 = t2.value15(t2.value7.Character)
		local RootPart

		if v97 then
			RootPart = v97.RootPart
		else
			RootPart = v97
		end

		if not v97 or (not RootPart or v97.Health <= 0) then
			return
		end

		local now = os.clock()
		local vector3 = Vector3.zero
		local vector3New

		if t2.value14.FollowBall then
			vector3New = v84

			local v102 = vector3New(RootPart)

			if v102 then
				local v103 = v102 - RootPart.Position

				vector3New = Vector3.new

				local v104 = vector3New(v103.X, 0, v103.Z)

				if v104.Magnitude > 5 then
					vector3 = v104.Unit
					vector3New = vector3
				end
			end
		else
			if t2.value33.NextTurn <= now then
				t2.value33.NextTurn = now + math.random(8, 16) / 10

				local v105 = math.random() * 3.141592653589793 * 2

				t2.value33.Direction = Vector3.new(math.cos(v105), 0, (math.sin(v105)))
			end

			local Direction = t2.value33.Direction

			vector3New = vector3
			vector3 = Direction
		end

		if vector3.Magnitude > 0 then
			local raycastParams = RaycastParams.new()

			raycastParams.FilterType = Enum.RaycastFilterType.Exclude
			raycastParams.FilterDescendantsInstances = { t2.value7.Character }
			raycastParams.RespectCanCollide = true

			local hit = workspace:Raycast(RootPart.Position, vector3 * 7, raycastParams)

			if hit then
				hit = hit.Instance.CanCollide
			end

			if hit then
				if t2.value14.FollowBall then
					if t2.value33.AvoidUntil <= now then
						local vector32 = Vector3.new(-vector3.Z, 0, vector3.X)
						local workspace_ = workspace
						local Position = RootPart.Position
						local v112 = workspace_.Raycast(workspace_, Position, vector32 * 7, raycastParams)
						local workspace_2 = workspace
						local Position2 = RootPart.Position
						local v115 = workspace_2.Raycast(workspace_2, Position2, -vector32 * 7, raycastParams)
						local value33 = t2.value33
						local s1 = "AvoidDirection"

						if v112 then
							v112 = not v115
						end

						if v112 then
							v112 = -vector32
						end

						value33[s1] = v112 or vector32
						t2.value33.AvoidUntil = now + 0.45
					end

					vector3 = t2.value33.AvoidDirection
				else
					t2.value33.Direction = -vector3
					vector3 = t2.value33.Direction
					t2.value33.NextTurn = now + 0.4
				end
			else
				t2.value33.AvoidUntil = 0
			end
		end

		v97:Move(vector3, false)

		local v118

		if t2.value14.JumpInterval > 0 then
			v118 = t2.value33.NextJump <= now
		else
			v118 = false
		end

		if not v118 then
			return
		end

		t2.value33.NextJump = now + t2.value14.JumpInterval

		if v97.FloorMaterial == Enum.Material.Air then
			return
		end

		v97.Jump = true
	end)
end

t2.value37 = workspace.CurrentCamera
t2.value38 = {
	Mode = "roam",
	Timer = 0,
	Target = nil,
	ChangeYaw = 0,
	ChangePitch = 0
}

function t2.value39()
	local AIMovement = t2.value14.AIMovement

	if not AIMovement then
		return AIMovement
	end

	AIMovement = t2.value14.CameraRotation

	if not AIMovement then
		return AIMovement
	end

	AIMovement = t2.value35 and t2.value14.CameraRoamTime > 0 and true or t2.value14.CameraLockTime > 0

	return AIMovement
end

t2.value40 = nil

function t2.value40()
	local ipairs_ = ipairs
	local t6 = {}

	for _, player in ipairs_(t2.value1:GetPlayers()) do
		local v124 = player ~= t2.value7

		if v124 then
			v124 = player.Character

			if v124 then
				v124 = player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChildWhichIsA("Humanoid")

				if v124 then
					v124 = player.Character:FindFirstChildWhichIsA("Humanoid").Health > 0
				end
			end
		end

		if v124 then
			ipairs_ = #t6 + 1
			t6[ipairs_] = player
		end
	end

	if #t6 == 0 then
		return nil
	else
		return t6[math.random(1, #t6)]
	end
end
function t2.value41()
	local CameraAggression = t2.value14.CameraAggression
	local v126 = math.clamp(CameraAggression, 0, 4)

	t2.value38.ChangeYaw = (math.random() * 2 - 1) * (v126 + 1)
	t2.value38.ChangePitch = (math.random() * 2 - 1) * 0.5 * (v126 * 0.75 + 1)
	t2.value38.Timer = t2.value14.CameraRoamTime
end
function t2.value42()
	t2.value38.Target = t2.value40()
	t2.value38.Timer = t2.value14.CameraLockTime
end

local value13 = t2.value13
local v128 = #t2.value13 + 1
local RenderStepped = t2.value2.RenderStepped

value13[v128] = RenderStepped.Connect(RenderStepped, function(p16)
	local value37 = 10984901

	if not t2.value39() then
		return
	end

	if not t2.value37 then
		value37 = workspace.CurrentCamera
		t2.value37 = value37

		if not t2.value37 then
			return
		end
	end

	local Character = t2.value7.Character

	if not (Character and Character:FindFirstChild("HumanoidRootPart")) then
		return
	end

	local CameraSpeed = t2.value14.CameraSpeed
	local v133 = math.clamp(CameraSpeed, 0.05, 10)

	t2.value38.Timer = t2.value38.Timer - p16

	if t2.value38.Timer <= 0 then
		if t2.value38.Mode == "roam" then
			if t2.value14.CameraLockTime > 0 then
				t2.value38.Mode = "lock"
				t2.value42()
			else
				t2.value41()
			end
		elseif t2.value14.CameraRoamTime > 0 then
			t2.value38.Mode = "roam"
			t2.value41()
		else
			t2.value42()
		end
	end

	if t2.value38.Mode == "roam" then
		t2.value37.CFrame = t2.value37.CFrame * CFrame.Angles(0, t2.value38.ChangeYaw * p16 * 0.6 * v133, 0) * CFrame.Angles(t2.value38.ChangePitch * p16 * 0.4 * v133, 0, 0)

		return
	end

	if t2.value38.Mode ~= "lock" then
		return
	end

	if not (t2.value38.Target and (t2.value38.Target.Character and t2.value38.Target.Character:FindFirstChild("HumanoidRootPart"))) then
		t2.value38.Target = t2.value40()

		if not t2.value38.Target then
			t2.value38.Mode = "roam"
			t2.value41()

			return
		end
	end

	local Position = t2.value38.Target.Character.HumanoidRootPart.Position
	local cFrame = CFrame.new(t2.value37.CFrame.Position, Position)

	t2.value37.CFrame = t2.value37.CFrame:Lerp(cFrame, math.min(p16 * 6 * v133, 1))
end)
t2.value43 = "DeathBallAutoReady"
t2.value44 = {
	0,
	-0.35,
	0.35,
	-0.75,
	0.75,
	-1.15,
	1.15
}
t2.value45 = 11
t2.value46 = {
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
value13 = { Vector3.new(536, 285, -798) }
t2.value47 = {
	Vector3.new(605, 285, -798),
	Vector3.new(590, 284, -768),
	Vector3.new(552, 284, -768),
	unpack_(value13)
}

function t2.value48()
	local raycastParams = RaycastParams.new()

	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.FilterDescendantsInstances = { t2.value7.Character }
	raycastParams.RespectCanCollide = true

	return raycastParams
end
function t2.value49(p17, p18)
	local v137 = math.cos(p18)
	local v138 = math.sin(p18)

	return Vector3.new(p17.X * v137 - p17.Z * v138, 0, p17.X * v138 + p17.Z * v137)
end
function t2.value50(p19, p20)
	local vector3 = Vector3.zero
	local ipairs_ = ipairs
	local value1 = t2.value1

	for _, player in ipairs_(value1.GetPlayers(value1)) do
		if player ~= t2.value7 then
			local Character = player.Character

			if Character then
				Character = Character:FindFirstChild("HumanoidRootPart")
			end

			if Character then
				local v145 = Character.Position - p19.Position
				local vector32 = Vector3.new(v145.X, 0, v145.Z)
				local Magnitude = vector32.Magnitude

				if Magnitude >= 0.1 and Magnitude <= 6 then
					local Unit = vector32.Unit

					if Unit:Dot(p20) >= 0.35 then
						vector3 = vector3 - Unit * ((1 - Magnitude / 6) * 0.6)
					end
				end
			end
		end
	end

	return vector3
end
function t2.value51()
	local v149 = math.clamp(t2.value14.AutoReadyEdge, 0, 0.45)
	local v150 = t2.value47[1]
	local v151 = t2.value47[2]
	local v152 = t2.value47[3]
	local v153 = t2.value47[4]
	local v154 = t2.value48()

	for _ = 1, 12 do
		local v156 = math.random()
		local math_ = math
		local v158 = v149 + v156 * (1 - 2 * v149)
		local v159 = v149 + math_.random() * (1 - 2 * v149)
		local Lerp = v153.Lerp
		local v161 = v150:Lerp(v151, v159):Lerp(Lerp(v153, v152, v159), v158)
		local hit = workspace:Raycast(v161 + Vector3.new(0, 25, 0), Vector3.new(0, -250, 0), v154)
		local CanCollide

		if hit then
			CanCollide = hit.Instance.CanCollide
		else
			CanCollide = hit
		end

		if CanCollide and not workspace:Raycast(hit.Position + Vector3.new(0, 2, 0), Vector3.new(0, 4, 0), v154) then
			return hit.Position
		end
	end

	local v164 = v150:Lerp(v152, 0.5)
	local workspace_ = workspace
	local v166 = v164 + Vector3.new(0, 25, 0)
	local Vector3_ = Vector3
	local Position = workspace_.Raycast(workspace_, v166, Vector3_.new(0, -250, 0), v154)

	if not Position then
		return Position or v164
	end

	Position = Position.Position

	return Position or v164
end
function t2.value52()
	t2.value46.Running = false
	t2.value46.Target = nil
	t2.value46.Steer = Vector3.zero
	t2.value46.LastPos = nil
	t2.value46.Parked = false
	t2.value46.ParkUntil = 0
	t2.value46.SlideDir = nil
	t2.value46.SlideHold = 0
	t2.value2:UnbindFromRenderStep(t2.value43)

	local v169 = t2.value15(t2.value7.Character)

	if not v169 then
		return
	end

	v169:Move(Vector3.zero, false)
end
function t2.value53()
	if t2.value46.Running or (t2.value35 or not t2.value14.AutoReady) then
		return
	end

	t2.value46.Running = true
	t2.value46.Target = nil
	t2.value46.Steer = Vector3.zero
	t2.value46.PickTime = 0
	t2.value46.NextPick = 0
	t2.value46.NextJump = 0
	t2.value46.StallAt = 0
	t2.value46.LastPos = nil
	t2.value46.Parked = false
	t2.value46.ParkUntil = 0
	t2.value46.SlideDir = nil
	t2.value46.SlideHold = 0
	t2.value2:UnbindFromRenderStep(t2.value43)
	t2.value2:BindToRenderStep(t2.value43, Enum.RenderPriority.Character.Value + 1, function(p21)
		if not t2.value46.Running or (not t2.value14.AutoReady or (t2.value35 or _G.__DBGen ~= t2.value12)) then
			t2.value52()

			return
		end

		local v170 = t2.value15(t2.value7.Character)
		local RootPart

		if v170 then
			RootPart = v170.RootPart
		else
			RootPart = v170
		end

		if not v170 or (not RootPart or v170.Health <= 0) then
			t2.value46.Target = nil
			t2.value46.Steer = Vector3.zero
			t2.value46.Parked = false

			return
		end

		local now = os.clock()

		if t2.value46.Parked then
			v170:Move(Vector3.zero, false)
			t2.value46.Steer = Vector3.zero

			if not (t2.value46.ParkUntil <= now) then
				return
			end

			t2.value46.Parked = false
			t2.value46.ParkUntil = 0
			t2.value46.NextPick = now
		end

		if not t2.value46.Target then
			if now < t2.value46.NextPick then
				v170:Move(Vector3.zero, false)

				return
			end

			t2.value46.Target = t2.value51()
			t2.value46.PickTime = now
			t2.value46.StallAt = now
			t2.value46.LastPos = RootPart.Position
			t2.value46.Steer = Vector3.zero
			t2.value46.SlideDir = nil
			t2.value46.SlideHold = 0
		end

		local v173 = t2.value46.Target - RootPart.Position
		local vector3 = Vector3.new(v173.X, 0, v173.Z)
		local Magnitude = vector3.Magnitude

		if Magnitude <= 3 then
			t2.value46.Target = nil
			t2.value46.Steer = Vector3.zero
			t2.value46.SlideDir = nil
			t2.value46.SlideHold = 0
			v170:Move(Vector3.zero, false)

			if t2.value14.AutoReadyIdle then
				t2.value46.Parked = true

				if t2.value14.AutoReadyDelay > 0 then
					t2.value46.ParkUntil = now + t2.value14.AutoReadyDelay

					return
				else
					t2.value46.ParkUntil = math.huge

					return
				end
			else
				t2.value46.Parked = false
				t2.value46.NextPick = now

				return
			end
		end

		if (RootPart.Position - t2.value46.LastPos or RootPart.Position).Magnitude > 0.5 then
			t2.value46.LastPos = RootPart.Position
			t2.value46.StallAt = now
		elseif now - t2.value46.StallAt > 2.5 then
			t2.value46.Target = nil
			t2.value46.NextPick = now
			t2.value46.Steer = Vector3.zero
			t2.value46.SlideDir = nil
			v170:Move(Vector3.zero, false)

			return
		end

		local v176 = t2.value48()
		local v177 = RootPart.Position + Vector3.new(0, 2, 0)
		local Unit = vector3.Unit
		local min = math.min
		local AutoReadyProbe = t2.value14.AutoReadyProbe
		local v181 = min(Magnitude, (math.max(AutoReadyProbe, 1)))
		local hit = workspace:Raycast(v177, Unit * v181, v176)
		local CanCollide

		if hit then
			CanCollide = hit.Instance.CanCollide
		else
			CanCollide = hit
		end

		local v184

		if CanCollide then
			local v185 = hit.Distance - 1

			v184 = math.max(v185, 0)
		else
			v184 = v181
		end

		local v186 = false
		local v187 = nil
		local Unit2

		if v184 < t2.value14.AutoReadyWallClear then
			v186 = true

			if not t2.value46.SlideDir or t2.value46.SlideHold <= now then
				local vector32 = Vector3.new(-Unit.Z, 0, Unit.X)
				local hit2 = workspace:Raycast(v177, vector32 * 5, v176)
				local hit3 = workspace:Raycast(v177, -vector32 * 5, v176)
				local n3 = 5
				local n4 = 5
				local CanCollide2

				if hit2 then
					CanCollide2 = hit2.Instance.CanCollide
				else
					CanCollide2 = hit2
				end

				if CanCollide2 then
					local v195 = hit2.Distance - 1

					n3 = math.max(v195, 0)
				end

				local CanCollide3

				if hit3 then
					CanCollide3 = hit3.Instance.CanCollide
				else
					CanCollide3 = hit3
				end

				if CanCollide3 then
					local v197 = hit3.Distance - 1

					n4 = math.max(v197, 0)
				end

				local value46 = t2.value46
				local s2 = "SlideDir"
				local v200

				if n4 <= n3 then
					v200 = vector32
				else
					v200 = false
				end

				value46[s2] = v200 or -vector32
				t2.value46.SlideHold = now + 0.5
			end

			local v201 = t2.value46.SlideDir * 0.85 + Unit * 0.15

			if v201.Magnitude > 0.001 then
				Unit2 = v201.Unit
			else
				Unit2 = t2.value46.SlideDir
			end

			t2.value46.StallAt = now
		else
			t2.value46.SlideDir = nil
			t2.value46.SlideHold = 0
			Unit2 = Unit
		end

		local v202 = nil

		if not v186 then
			local vector32 = Vector3.zero
			local v204 = Unit
			local n5 = -1
			local n6 = 0

			for i, v in ipairs(t2.value44) do
				local v209 = t2.value49(Unit, v)
				local hit2 = workspace:Raycast(v177, v209 * v181, v176)
				local CanCollide2

				if hit2 then
					CanCollide2 = hit2.Instance.CanCollide
				else
					CanCollide2 = hit2
				end

				local v212

				if CanCollide2 then
					local v213 = hit2.Distance - 1

					v212 = math.max(v213, 0)

					if i == 1 then
						v202 = hit2
					end

					local v214 = i == 1

					if v214 then
						if hit2.Normal.Y >= 0.6 then
							v214 = hit2.Distance <= 3.5
						else
							v214 = false
						end
					end

					if not v214 then
						hit2 = v187
					end
				else
					hit2 = v187
					v212 = v181
				end

				if n5 < v212 then
					v204 = v209
					n5 = v212
				end

				local v215 = v212 / v181 * math.cos(v)

				if v215 > 0 then
					n6 = n6 + v215
					vector32 = vector32 + v209 * v215
					v187 = hit2
				else
					v187 = hit2
				end
			end

			if n6 > 0.05 then
				v204 = vector32 / n6
			end

			local vector33 = Vector3.new(v204.X, 0, v204.Z)

			if vector33.Magnitude > 0.001 then
				vector33 = vector33.Unit
			end

			local v217 = vector33 + t2.value50(RootPart, Unit)

			if v217.Magnitude > 0.001 then
				Unit2 = v217.Unit
			else
				Unit2 = Unit
			end
		end

		if v187 then
			if t2.value46.NextJump <= now then
				v187 = v170.FloorMaterial ~= Enum.Material.Air
			else
				v187 = false
			end
		end

		if v187 then
			t2.value46.NextJump = now + 0.35
			v170.Jump = true
		end

		if v202 then
			if v202.Normal.Y >= 0.6 then
				v202 = v202.Distance <= 3.5
			else
				v202 = false
			end
		end

		if v202 then
			local v218

			if t2.value46.NextJump <= now then
				v218 = v170.FloorMaterial ~= Enum.Material.Air
			else
				v218 = false
			end

			if v218 then
				t2.value46.NextJump = now + 0.6
				v170.Jump = true
			end
		end

		local v219 = RootPart.Position + Unit * math.min(Magnitude, 4)
		local v220 = not workspace:Raycast(v219 + Vector3.new(0, 4, 0), Vector3.new(0, -12, 0), v176)

		if v220 then
			if t2.value46.NextJump <= now then
				v220 = v170.FloorMaterial ~= Enum.Material.Air
			else
				v220 = false
			end
		end

		local Unit3

		if not v220 then
			v233 = Vector3.new(Unit2.X, 0, Unit2.Z)

			if v233.Magnitude > 0.001 then
				Unit3 = v233.Unit
			else
				Unit3 = Vector3.zero
			end

			v234 = -t2.value45 * math.min(p21, 0.1)
			v235 = 1 - math.exp(v234)
			t2.value46.Steer = t2.value46.Steer:Lerp(Unit3, v235)

			if t2.value46.Steer.Magnitude > 0.001 then
				v170:Move(t2.value46.Steer.Unit, false)
			else
				v170:Move(Vector3.zero, false)
			end

			return
		end

		t2.value46.NextJump = now + 0.6
		v170.Jump = true

		local vector32 = Vector3.new(Unit2.X, 0, Unit2.Z)

		if vector32.Magnitude > 0.001 then
			Unit3 = vector32.Unit
		else
			Unit3 = Vector3.zero
		end

		local v223 = -t2.value45 * math.min(p21, 0.1)
		local v224 = 1 - math.exp(v223)

		t2.value46.Steer = t2.value46.Steer:Lerp(Unit3, v224)

		if t2.value46.Steer.Magnitude > 0.001 then
			v170:Move(t2.value46.Steer.Unit, false)
		else
			v170:Move(Vector3.zero, false)
		end
	end)
end

t2.value54 = nil
t2.value55 = nil

function t2.value56()
	local function v225()
		if t2.value54 then
			return t2.value54.IsInMatch()
		end

		t2.value54 = require(t2.value6:WaitForChild("Modules"):WaitForChild("AfterMatch"))

		return t2.value54.IsInMatch()
	end

	local t7 = { pcall(v225) }
	local v227 = t7[2]

	if not t7[1] then
		t2.value35 = false
		t2.value34()
		t2.value52()
		warn("[Death Ball] Could not read round state; AI movement stopped.")

		return
	end

	local value35 = t2.value35

	t2.value35 = v227 == true

	if t2.value35 then
		t2.value52()

		if t2.value14.AIMovement then
			t2.value36()
		end
	else
		t2.value34()

		if t2.value14.AutoReady then
			t2.value53()
		end
	end

	if value35 == t2.value35 then
		return
	end

	print("[Death Ball] Round active:", t2.value35)
end

task.spawn(function()
	local ok, result = pcall(function()
		return require(t2.value6:WaitForChild("Values"))
	end)

	if not (ok and (result and result.PLAYER_ACTIVE_STATE)) then
		warn("[Death Ball] PLAYER_ACTIVE_STATE unavailable; AI movement remains stopped.")

		return
	end

	local function v231()
		return t2.value55:Connect(function()
			t2.value56()
		end)
	end

	t2.value55 = result.PLAYER_ACTIVE_STATE
	t2.value56()

	local ok2, result2 = pcall(v231)

	if ok2 and result2 then
		t2.value13[#t2.value13 + 1] = result2
	else
		warn("[Death Ball] Could not connect to round-state changes.")
	end
end)
t2.value57 = false

function t2.value58(p22, p23, p24)
	if p22 then
		local Size = p22.Size
		local Vector3_ = Vector3
		local v236 = Size / 2
		local t8 = { Vector3_.new(0, 0, 0) }
		local t9 = {}

		for i = 1, #t8 do
			t9[i] = p23:PointToWorldSpace((Vector3.new(v236.X * t8[i].X, v236.Y * t8[i].Y, v236.Z * t8[i].Z)))
		end

		for k, v in pairs(t9) do
			if p24(k, v) then
				return
			end
		end
	end
end

t2.value13[#t2.value13 + 1] = t2.value2.PostSimulation:Connect(function(_)
	if not t2.value14.AutoParry then
		return
	end

	if t2.value57 then
		return
	end

	local n7 = 0.025
	local v243 = v41()
	local v244 = (v243 + 0.025) * t2.value14.PingCompensationMultiplier
	local v245 = t2.value15(t2.value7.Character)
	local RootPart

	if v245 then
		RootPart = v245.RootPart
	else
		RootPart = v245
	end

	if not RootPart then
		return
	end

	local RootPart2 = v245.RootPart
	local v248, v249, v250 = pairs(t2.value24)
	local huge = math.huge
	local v252 = nil

	while true do
		local v253

		v250, v253 = v248(v249, v250)

		if not v250 then
			break
		end

		local v254 = v253.Target == t2.value7

		if v254 then
			v254 = v253.Object

			if v254 then
				v254 = v253.Object.Parent

				if v254 then
					v254 = v253.Object.Transparency < 1

					if v254 then
						if v253.Velocity.Magnitude > 0 then
							v254 = v253.ObjectVelocity.Magnitude > 0
						else
							v254 = false
						end
					end
				end
			end
		end

		local Magnitude

		if v254 then
			Magnitude = (v253.Position - RootPart2.Position).Magnitude

			if Magnitude >= huge then
				v253 = v252
				Magnitude = huge
			end
		else
			v253 = v252
			Magnitude = huge
		end

		v252 = v253
		huge = Magnitude
	end

	if not v252 then
		return
	end

	local Position = RootPart2.Position
	local v257 = Position - RootPart2.AssemblyLinearVelocity * (v243 + n7)
	local Position2 = v252.Position
	local v259 = v252.Position + v252.ObjectVelocity * (v243 + n7)
	local AssemblyLinearVelocity = RootPart2.AssemblyLinearVelocity
	local v261 = AssemblyLinearVelocity.Magnitude > 1 and (t2.value20(Position2, Position, Vector3.new(AssemblyLinearVelocity.X, AssemblyLinearVelocity.Y, AssemblyLinearVelocity.Z)) or 0) or 0
	local v262

	if AssemblyLinearVelocity.Magnitude > 1 then
		v262 = t2.value20(v259, v257, Vector3.new(AssemblyLinearVelocity.X, AssemblyLinearVelocity.Y, AssemblyLinearVelocity.Z))
	else
		v262 = false
	end

	local v263 = v262 or 0
	local v264 = t2.value14.Range + v244
	local v265 = math.clamp(v261, -1, 1)
	local v266 = math.abs(v265)
	local PerfectParry = t2.value14.PerfectParry

	if PerfectParry then
		PerfectParry = t2.value14.PerfectParryMultiplier
	end

	local v268 = v264 + v266 * (1 - (PerfectParry or 0)) * v244
	local DirectPoint = t2.value14.DirectPoint
	local v270 = math.rad(DirectPoint)
	local v271 = 180 * v244
	local v272 = v270 + math.rad(v271)
	local v273 = math.clamp(v261, -1, 1)
	local v274 = math.acos(v273)
	local v275 = math.clamp(v261, -1, 1)
	local v276 = v272 + v274 * math.abs(v275) / 3.141592653589793

	local function v277(p25, p26, p27, p28)
		local value21 = t2.value21
		local t10 = {
			Threshold = v268,
			Values = { t2.value19(p25, p26, p27), t2.value19(p25, p26, p27, 2.5) }
		}
		local v280 = v276
		local v281 = t2.value20(p25, p26, p27)
		local v282 = math.acos(v281)
		local t11 = {}
		local v284 = t2.value20(p25, p26, p27, 2.5)

		__set_list(t11, 1, {v282, (math.acos(v284))})

		if value21({
			ETA = t10,
			Dot = {
				Threshold = v280,
				Values = t11
			}
		}) then
			return true
		end

		local v285 = t2.value19(p25, p26, p27).Magnitude <= 0.3 + v244
		local v286, v287, v288

		if v285 then
		elseif v285 then
			return true
		else
			v286 = p25 - p26
			v287 = 3 + 8 * v244

			if p28 > 0 then
				v288 = p28 * 3
			else
				v288 = false
			end

			return v287 + (v288 or (p28 < 0 and p28 * -3 or 0)) >= v286.Magnitude and true or false
		end

		local v289 = t2.value20(p25, p26, p27)

		v285 = math.acos(v289) <= 1.0471975511965976

		if v285 then
		elseif v285 then
			return true
		else
			v286 = p25 - p26
			v287 = 3 + 8 * v244

			if p28 > 0 then
				v288 = p28 * 3
			else
				v288 = false
			end

			return v287 + (v288 or (p28 < 0 and p28 * -3 or 0)) >= v286.Magnitude and true or false
		end

		local v290 = p25 - p26
		local v291 = 8 + 8 * v244
		local v292

		if p28 > 0 then
			v292 = p28 * 4
		else
			v292 = false
		end

		v285 = v291 + (v292 or (p28 < 0 and (p28 * -4 or 0) or 0)) >= v290.Magnitude

		if v285 then
			return true
		else
			v286 = p25 - p26
			v287 = 3 + 8 * v244

			if p28 > 0 then
				v288 = p28 * 3
			else
				v288 = false
			end

			return v287 + (v288 or (p28 < 0 and p28 * -3 or 0)) >= v286.Magnitude and true or false
		end
	end
	local function v293(p29, p30, _)
		local u294 = false

		t2.value58(v252.Object, CFrame.new(p30), function(_, p31)
			local raycastParams = RaycastParams.new()

			raycastParams.FilterDescendantsInstances = { v252.Object, t2.value7, t2.value7.Character }
			raycastParams.FilterType = Enum.RaycastFilterType.Exclude

			local pairs_ = pairs
			local value1 = t2.value1

			for _, player in pairs_(value1.GetPlayers(value1)) do
				if player.Character then
					raycastParams:AddToFilter(player.Character)
				end
			end

			local v300 = p31 - p29
			local workspace_ = workspace
			local hit = workspace_:Raycast(p29, v300, raycastParams)
			local v303 = v300.Magnitude <= 8

			if v303 then
				if not v303 then
					u294 = workspace_

					return true
				end

				return
			end

			v303 = v252.isPhasingThrough

			if v303 then
				if not v303 then
					u294 = workspace_

					return true
				end

				return
			end

			if hit then
				hit = hit.Instance.Transparency < 1 or (hit.Instance.CollisionGroup == "BallCollider" and true or hit.Instance.CollisionGroup == "NoCollide")
			end

			v303 = not hit

			if not v303 then
				u294 = workspace_

				return true
			end
		end)

		if u294 then
			return
		end

		t2.value22()

		if t2.value14.AutoSpamParry then
			task.spawn(function()
				task.wait()
				t2.value22()
				task.wait()
				t2.value22()
			end)
		end

		task.spawn(function()
			local now = os.clock()
			local v305 = nil
			local n8 = 0.1

			local function v307()
				return (n8 or 0) <= os.clock() - v305
			end

			v305 = now

			local now2 = os.clock()
			local v309 = nil
			local n9 = 1

			local function v311()
				return (n9 or 0) <= os.clock() - v309
			end

			v309 = now2

			while not v311() do
				local v312 = v307()

				if v312 then
					v312 = not v252.Object or (not v252.Object.Parent or v252.Target ~= t2.value7)
				end

				if v312 then
					return
				end

				task.wait()
			end
		end)
	end

	local v313 = v277(Position, Position2, v252.Velocity, v261)

	if v313 then
		v313 = v277(Position, Position2, v252.ObjectVelocity, v261)
	end

	if v313 then
		return v293(Position, Position2, v261)
	end

	local v314 = v277(v257, v259, v252.Velocity, v263)

	if not v314 then
		if v314 then
			return v293(v257, v259, v263)
		end

		return
	end

	v314 = v277(v257, v259, v252.ObjectVelocity, v263)

	if v314 then
		return v293(v257, v259, v263)
	end
end)
t2.value59 = {
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

function t2.value60(p32, p33)
	local instance = Instance.new(p32)

	for k, v in pairs(p33 or {}) do
		instance[k] = v
	end

	return instance
end
function t2.value61(p34, p35)
	return t2.value60("UICorner", {
		CornerRadius = UDim.new(0, p35),
		Parent = p34
	})
end
function t2.value62(p36, p37, p38)
	return t2.value60("UIStroke", {
		Color = p37 or t2.value59.Border,
		Thickness = p38 or 1,
		Parent = p36
	})
end

local function v318(p39, p40)
	local UIStroke = t2.value60("UIStroke", {
		Color = Color3.fromRGB(255, 255, 255),
		Thickness = p40 or 1.5,
		Transparency = 0.15,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = p39
	})
	local UIGradient = t2.value60("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, t2.value59.Accent),
			ColorSequenceKeypoint.new(0.35, Color3.fromRGB(150, 190, 255)),
			ColorSequenceKeypoint.new(0.55, t2.value59.Accent),
			ColorSequenceKeypoint.new(0.8, Color3.fromRGB(70, 110, 220)),
			ColorSequenceKeypoint.new(1, t2.value59.Accent)
		}),
		Rotation = 45,
		Parent = UIStroke
	})
	local connection = nil

	connection = t2.value2.RenderStepped:Connect(function(_)
		if UIStroke.Parent then
			UIGradient.Offset = Vector2.new(os.clock() * 0.18 % 1, 0)
		else
			connection:Disconnect()
		end
	end)

	return UIStroke, UIGradient, connection
end

t2.value63 = nil
t2.value64 = nil
t2.value65 = nil
value13 = game
t2.value66 = value13.GetService(value13, "GuiService")
t2.value67 = {
	RefWidth = 340,
	RefHeight = 600,
	Margin = 18,
	MinScale = 0.6,
	MaxScale = 1,
	TouchShrink = 0.96
}
t2.value68 = {}
t2.value69 = {
	Vp = Vector2.new(),
	Inset = -1,
	Touch = nil
}

function t2.value70()
	local CurrentCamera = workspace.CurrentCamera

	if not CurrentCamera then
		return CurrentCamera or Vector2.new(1920, 1080)
	end

	CurrentCamera = CurrentCamera.ViewportSize

	return CurrentCamera or Vector2.new(1920, 1080)
end
function t2.value71()
	local n10 = 0

	local function v324()
		local _, v326 = t2.value66:GetGuiInset()

		n10 = v326 and v326.Y or 0
	end

	pcall(v324)

	return n10
end
function t2.value72()
	local TouchEnabled = t2.value3.TouchEnabled

	if not TouchEnabled then
		return TouchEnabled
	end

	TouchEnabled = not t2.value3.KeyboardEnabled

	return TouchEnabled
end
function t2.value73(p41)
	local n11 = 6244884

	while true do
		local v329

		if p41 then
			v329 = not p41:IsA("ScreenGui")
		else
			v329 = p41
		end

		if v329 then
		elseif p41 then
			local UIScale = p41:FindFirstChildOfClass("UIScale")
			local Scale = UIScale and UIScale.Scale or 1

			return (not Scale or (Scale <= 0 or not Scale)) and 1 or Scale
		else
			return 1
		end

		p41 = p41.Parent
		n11 = p41
	end
end

t2.value74 = nil

function t2.value74(p42)
	local Gui = p42.Gui

	if not (Gui and Gui.Parent) then
		return
	end

	local v333 = t2.value70()
	local v334 = t2.value71()
	local v335 = v333.X - t2.value67.Margin * 2
	local v336 = math.max(v335, 1)
	local v337 = v333.Y - v334 - t2.value67.Margin * 2
	local v338 = math.max(v337, 1)
	local v339 = v336 / p42.RefWidth
	local v340 = v338 / p42.RefHeight
	local v341 = math.min(v339, v340)
	local value72 = t2.value72

	if value72() then
		v341 = v341 * t2.value67.TouchShrink
		value72 = v341
	end

	local MinScale = t2.value67.MinScale
	local MaxScale = t2.value67.MaxScale
	local scale = math.clamp(v341, MinScale, MaxScale)

	p42.ScaleObject.Scale = scale

	local FitHeight = p42.FitHeight

	if FitHeight then
		FitHeight = p42.FitHeight.Frame

		if FitHeight then
			FitHeight = p42.FitHeight.Frame.Parent
		end
	end

	if FitHeight then
		local BaseHeight = p42.FitHeight.BaseHeight
		local v348 = v338 / scale
		local v349 = math.min(BaseHeight, v348)

		p42.FitHeight.Frame.Size = UDim2.new(0, p42.FitHeight.BaseWidth, 0, v349)
	end

	local lastOffset = scale >= 0.999 and 0 or v334 / 2 / scale
	local v351 = lastOffset - (p42.LastOffset or 0)

	if v351 == 0 then
		p42.LastOffset = lastOffset

		return
	end

	for _, v in ipairs(p42.CenterFrames or {}) do
		local Parent

		if v then
			Parent = v.Parent
		else
			Parent = v
		end

		if Parent then
			v.Position = v.Position + UDim2.new(0, 0, 0, v351)
		end
	end

	p42.LastOffset = lastOffset
end
function t2.value75(p43, p44, p45, p46, p47)
	local t12 = {
		Gui = p43,
		RefWidth = p44 or t2.value67.RefWidth,
		RefHeight = p45 or t2.value67.RefHeight,
		CenterFrames = p46,
		FitHeight = p47,
		ScaleObject = t2.value60("UIScale", {
			Name = "ResponsiveScale",
			Parent = p43
		})
	}
	local value68 = t2.value68

	table.insert(value68, t12)
	t2.value74(t12)

	return t12
end

local function v357()
	local v358 = t2.value70()
	local v359 = t2.value71()
	local v360 = t2.value72()
	local v361 = v358 == t2.value69.Vp
	local value69, value692, value693, v365, Gui

	if not v361 then
		if not v361 then
			value69 = t2.value69
			value692 = t2.value69
			value693 = t2.value69
			value69.Vp = v358
			value692.Inset = v359
			value693.Touch = v360

			for i = #t2.value68, 1, -1 do
				v365 = t2.value68[i]
				Gui = v365.Gui

				if Gui then
					Gui = v365.Gui.Parent
				end

				if Gui then
					t2.value74(v365)
				else
					table.remove(t2.value68, i)
				end
			end
		end

		return
	end

	if v359 == t2.value69.Inset then
		v361 = v360 == t2.value69.Touch
	else
		v361 = false
	end

	if not v361 then
		value69 = t2.value69
		value692 = t2.value69
		value693 = t2.value69
		value69.Vp = v358
		value692.Inset = v359
		value693.Touch = v360

		for i = #t2.value68, 1, -1 do
			v365 = t2.value68[i]
			Gui = v365.Gui

			if Gui then
				Gui = v365.Gui.Parent
			end

			if Gui then
				t2.value74(v365)
			else
				table.remove(t2.value68, i)
			end
		end
	end
end

function t2.value76() end

value13 = t2.value13
v128 = #t2.value13 + 1
RenderStepped = t2.value2.RenderStepped:Connect(function()
	v357()
	t2.value76()
end)
t2.value77 = nil
value13[v128] = RenderStepped
t2.value78 = nil
t2.value79 = {}
t2.value77 = 72
t2.value78 = 10

function t2.value80(p48)
	return UDim2.new(1, -20, 1, -20 - (p48 - 1) * (t2.value77 + t2.value78))
end

local function v369()
	for i, v in ipairs(t2.value79) do
		if v.Parent then
			local value5 = t2.value5
			local TweenInfo_ = TweenInfo

			value5.Create(value5, v, TweenInfo_.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Position = t2.value80(i)
			}):Play()
		end
	end
end

t2.value81 = nil
t2.value81 = 2.6
t2.value82 = nil

function t2.value83(p49)
	local Frame = t2.value60("Frame", {
		Name = "Notif",
		Size = UDim2.new(0, 300, 0, t2.value77),
		Position = UDim2.new(1, -20, 1, -20),
		AnchorPoint = Vector2.new(1, 1),
		BackgroundColor3 = t2.value59.Section,
		BorderSizePixel = 0,
		Parent = t2.value63,
		ZIndex = 50
	})

	t2.value61(Frame, 10)
	t2.value62(Frame, t2.value59.Border, 1)

	local Frame2 = t2.value60("Frame", {
		Size = UDim2.new(0, 3, 1, -30),
		Position = UDim2.new(0, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundColor3 = t2.value59.Accent,
		BorderSizePixel = 0,
		Parent = Frame,
		ZIndex = 51
	})

	t2.value61(Frame2, 3)
	t2.value60("ImageLabel", {
		Size = UDim2.new(0, 26, 0, 26),
		Position = UDim2.new(0, 14, 0, 6),
		BackgroundTransparency = 1,
		Image = "rbxassetid://84154329190977",
		ScaleType = Enum.ScaleType.Fit,
		Parent = Frame,
		ZIndex = 51
	})
	t2.value60("TextLabel", {
		Size = UDim2.new(1, -54, 0, 18),
		Position = UDim2.new(0, 46, 0, 10),
		BackgroundTransparency = 1,
		Text = "SENTENAL Z",
		TextColor3 = t2.value59.Accent,
		Font = Enum.Font.GothamBold,
		TextSize = 16,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Frame,
		ZIndex = 51
	})
	t2.value60("TextLabel", {
		Size = UDim2.new(2, -60, 0, 18),
		Position = UDim2.new(0, 138, 0, 10),
		BackgroundTransparency = 1,
		Text = "   •   NOTIFICATION",
		TextColor3 = t2.value59.Muted,
		Font = Enum.Font.Gotham,
		TextSize = 10,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Frame,
		ZIndex = 51
	})
	t2.value60("TextLabel", {
		Size = UDim2.new(1, -28, 0, 24),
		Position = UDim2.new(0, 14, 0, 40),
		BackgroundTransparency = 1,
		Text = p49,
		TextColor3 = t2.value59.Text,
		Font = Enum.Font.GothamMedium,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		TextWrapped = true,
		Parent = Frame,
		ZIndex = 51
	})

	local Frame3 = t2.value60("Frame", {
		Size = UDim2.new(1, -20, 0, 2),
		Position = UDim2.new(0, 10, 1, -8),
		BackgroundColor3 = t2.value59.Border,
		BorderSizePixel = 0,
		Parent = Frame,
		ZIndex = 51
	})

	t2.value61(Frame3, 1)

	local Frame4 = t2.value60("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = t2.value59.Accent,
		BorderSizePixel = 0,
		Parent = Frame3,
		ZIndex = 52
	})

	t2.value61(Frame4, 1)

	local value79 = t2.value79

	table.insert(value79, 1, Frame)
	v369()

	local v379 = t2.value80(1)

	Frame.Position = UDim2.new(v379.X.Scale, v379.X.Offset, v379.Y.Scale, v379.Y.Offset + 60)
	Frame.BackgroundTransparency = 1
	t2.value5:Create(Frame, TweenInfo.new(0.32, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
		Position = v379,
		BackgroundTransparency = 0
	}):Play()

	local value5 = t2.value5
	local tweenInfo = TweenInfo.new(t2.value81, Enum.EasingStyle.Linear)
	local UDim2_ = UDim2

	value5.Create(value5, Frame4, tweenInfo, {
		Size = UDim2_.new(0, 0, 1, 0)
	}):Play()
	task.delay(t2.value81, function()
		local Parent = Frame

		if Parent then
			Parent = Frame.Parent
		end

		if not Parent then
			return
		end

		local Position = Frame.Position
		local value52 = t2.value5
		local v386 = Frame
		local tweenInfoNew = TweenInfo.new
		local Enum_ = Enum
		local v389 = value52.Create(value52, v386, tweenInfoNew(0.24, Enum_.EasingStyle.Quad, Enum.EasingDirection.In), {
			Position = UDim2.new(1, 40, Position.Y.Scale, Position.Y.Offset),
			BackgroundTransparency = 1
		})

		v389.Play(v389)

		local v390 = Frame

		for _, descendant in ipairs(v390.GetDescendants(v390)) do
			if descendant:IsA("TextLabel") then
				local value53 = t2.value5
				local tweenInfo2 = TweenInfo.new(0.24)

				value53.Create(value53, descendant, tweenInfo2, {
					TextTransparency = 1
				}):Play()
			elseif descendant:IsA("Frame") then
				local value53 = t2.value5
				local tweenInfo2 = TweenInfo.new(0.24)

				value53.Create(value53, descendant, tweenInfo2, {
					BackgroundTransparency = 1
				}):Play()
			elseif descendant:IsA("ImageLabel") then
				local value53 = t2.value5
				local tweenInfo2 = TweenInfo.new(0.24)

				value53.Create(value53, descendant, tweenInfo2, {
					ImageTransparency = 1
				}):Play()
			elseif descendant:IsA("UIStroke") then
				local value53 = t2.value5
				local tweenInfo2 = TweenInfo.new(0.24)

				value53.Create(value53, descendant, tweenInfo2, {
					Transparency = 1
				}):Play()
			end
		end

		v389.Completed:Wait()
		Frame:Destroy()

		local v401 = table.find(t2.value79, Frame)

		if not v401 then
			return
		end

		table.remove(t2.value79, v401)
		v369()
	end)
end

value13 = function()
	t2.value64.Visible = false

	local value82 = t2.value82

	if value82 then
		value82 = t2.value82.Parent
	end

	if value82 then
		return
	end

	local value7 = t2.value7
	local UserId = value7.UserId
	local DisplayName = value7.DisplayName
	local Name = value7.Name

	t2.value82 = t2.value60("Frame", {
		Name = "ProfileCard",
		Size = UDim2.new(1, 0, 0, 52),
		Position = UDim2.new(0, 0, 1, 0),
		AnchorPoint = Vector2.new(0, 1),
		BackgroundColor3 = t2.value59.Section,
		BorderSizePixel = 0,
		Parent = t2.value64,
		ZIndex = 40
	})
	t2.value61(t2.value82, 8)
	t2.value62(t2.value82, t2.value59.Border, 1)

	local Frame = t2.value60("Frame", {
		Size = UDim2.new(0, 3, 1, -25),
		Position = UDim2.new(0, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundColor3 = t2.value59.Accent,
		BorderSizePixel = 0,
		Parent = t2.value82,
		ZIndex = 51
	})

	t2.value61(Frame, 3)

	local Frame2 = t2.value60("Frame", {
		Size = UDim2.new(0, 44, 0, 44),
		Position = UDim2.new(0, 12, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundColor3 = t2.value59.Field,
		BorderSizePixel = 0,
		Parent = t2.value82,
		ZIndex = 51
	})

	t2.value61(Frame2, 22)
	t2.value62(Frame2, t2.value59.Accent, 1)

	local ImageLabel = t2.value60("ImageLabel", {
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

	t2.value61(ImageLabel, 22)
	t2.value60("TextLabel", {
		Name = "Username",
		Size = UDim2.new(1, -70, 0, 18),
		Position = UDim2.new(0, 64, 0, 12),
		BackgroundTransparency = 1,
		Text = "@" .. Name,
		TextColor3 = t2.value59.Text,
		Font = Enum.Font.GothamBold,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = t2.value82,
		ZIndex = 51
	})
	t2.value60("TextLabel", {
		Name = "DisplayName",
		Size = UDim2.new(1, -70, 0, 14),
		Position = UDim2.new(0, 64, 0, 30),
		BackgroundTransparency = 1,
		Text = DisplayName,
		TextColor3 = t2.value59.Muted,
		Font = Enum.Font.Gotham,
		TextSize = 11,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = t2.value82,
		ZIndex = 51
	})
	task.spawn(function()
		local function v410()
			return t2.value1:GetUserThumbnailAsync(UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
		end

		local ok, image = pcall(v410)

		if ok then
			ok = image and ImageLabel

			if ok then
				ok = ImageLabel.Parent
			end
		end

		if not ok then
			return
		end

		ImageLabel.Image = image
	end)
	task.spawn(function()
		local ok, image = pcall(function()
			return t2.value1:GetUserThumbnailAsync(UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
		end)

		if ok then
			if image then
				ok = ImageLabel

				if ok then
					ok = ImageLabel.Parent
				end
			else
				ok = image
			end
		end

		if not ok then
			return
		end

		ImageLabel.Image = image
	end)
end
t2.value84 = {
	SetAutoParryVisual = function() end,
	SetSpamVisual = function() end,
	SetAIMoveVisual = function() end,
	SetAutoReadyVisual = function() end,
	SetCameraVisual = function() end
}
t2.value85 = nil

function t2.value85(p50, p51)
	t2.value83(p50 .. (p51 and " turned ON" or p51 or " turned OFF"))
end
function t2.value86(p52)
	t2.value14.AutoParry = p52
	t2.value84.SetAutoParryVisual(p52)
	t2.value85("Auto Parry", p52)
end
function t2.value87(p53)
	t2.value14.AutoSpam = p53
	t2.value84.SetSpamVisual(p53)

	if p53 then
		t2.value31()
	else
		t2.value30()
	end

	t2.value85("Auto Spam", p53)
end
function t2.value88(p54)
	t2.value14.AIMovement = p54
	t2.value84.SetAIMoveVisual(p54)

	local value35

	if p54 then
		value35 = t2.value35
	else
		value35 = p54
	end

	if value35 then
		t2.value36()
	else
		t2.value34()
	end

	t2.value85("AI Movement", p54)
end
function t2.value89(p55)
	t2.value14.AutoReady = p55
	t2.value84.SetAutoReadyVisual(p55)

	local v416

	if p55 then
		v416 = not t2.value35
	else
		v416 = p55
	end

	if v416 then
		t2.value53()
	else
		t2.value52()
	end

	t2.value85("Auto Ready", p55)
end
function t2.value90(p56)
	t2.value14.CameraRotation = p56
	t2.value84.SetCameraVisual(p56)
	t2.value38.Mode = "roam"
	t2.value38.Timer = 0
	t2.value38.Target = nil
	t2.value85("Camera Rotation", p56)
end

t2.value91 = 0.7
t2.value92 = "BallDeflectCooldown"
t2.value93 = {
	{
		key = "DEFLECT_COOLDOWN_TIME",
		on = 0.7,
		off = 1.3
	},
	{
		key = "DEFLECTS_STARTED_WHILE_TARGET_THRESH",
		on = 0.7,
		off = 2
	}
}
v128 = getgc
RenderStepped = debug

if RenderStepped then
	RenderStepped = debug.getupvalues
end

t2.value94 = {
	getgc = v128,
	getupvalues = RenderStepped or getupvalues
}
v128 = getgenv and getgenv() or _G
v128.__IP4 = v128.__IP4 or {
	attrSaved = false,
	attrOriginal = nil,
	legacy = {}
}
t2.value95 = v128.__IP4

local function v417(p57)
	local v418 = nil
	local v419 = nil

	for _, v in ipairs(p57) do
		if type(v) == "table" then
			local ok, result = pcall(rawget, v, "BallDeflectCooldown")

			if ok then
				ok = type(result) == "table"
			end

			if ok then
				local ok2, result2 = pcall(rawget, result, "Get")

				if ok2 then
					ok2 = type(result2) == "function"
				end

				if ok2 and not v418 then
					v419 = result
					v418 = v
				end
			end
		end
	end

	return v418, v419
end

function t2.value96(p58)
	local ok, result = pcall(t2.value94.getupvalues, p58)

	if not ok or type(result) ~= "table" then
		return nil
	else
		local v428, v429, v430 = pairs(result)
		local t13 = {}

		while true do
			local v432

			v430, v432 = v428(v429, v430)

			if not v430 then
				break
			end

			if typeof(v432) == "Instance" then
				t13[#t13 + 1] = v432
			end
		end

		for _, v in ipairs(t13) do
			if v:IsA("Configuration") then
				return v
			end
		end

		if #t13 == 1 then
			return t13[1]
		else
			return nil
		end
	end
end
function t2.value97(p59)
	for _, v in ipairs(p59) do
		if type(v) == "table" then
			local ok, result = pcall(rawget, v, "DEFLECT_COOLDOWN_TIME")

			if ok then
				ok = type(result) == "number"
			end

			if ok then
				return v
			end
		end
	end
end

v128 = function(p60, p61)
	local u439 = nil
	local Position = nil
	local Position2 = nil

	local function v442(input)
		if not (input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		u439 = true
		Position = input.Position
		Position2 = p60.Position
		input.Changed:Connect(function()
			if input.UserInputState ~= Enum.UserInputState.End then
				return
			end

			u439 = false
		end)
	end

	(p61 or p60).InputBegan:Connect(v442)
	t2.value13[#t2.value13 + 1] = t2.value3.InputChanged:Connect(function(input)
		if not u439 then
			return
		end

		if not (input.UserInputType == Enum.UserInputType.MouseMovement and true or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		local v443 = input.Position - Position
		local v444 = t2.value73(p60)

		p60.Position = UDim2.new(Position2.X.Scale, Position2.X.Offset + v443.X / v444, Position2.Y.Scale, Position2.Y.Offset + v443.Y / v444)
	end)
end

function t2.value98(p62)
	local v445 = p62 and true or false
	local getgc_ = t2.value94.getgc
	local v447

	if type(getgc_) == "function" then
		local getupvalues_ = t2.value94.getupvalues

		v447 = type(getupvalues_) ~= "function"
	else
		v447 = true
	end

	if v447 then
		return {
			ok = false,
			effect = "APIs unavailable"
		}
	end

	local ok, result = pcall(t2.value94.getgc, true)

	if not ok or type(result) ~= "table" then
		return {
			ok = false,
			effect = "getgc failed"
		}
	end

	local v451, v452 = v417(result)

	if not (v451 and v452) then
		return {
			ok = false,
			effect = "RoundSettings not found"
		}
	end

	local v453 = t2.value96((rawget(v452, "Get")))

	if not v453 then
		return {
			ok = false,
			effect = "Configuration not found"
		}
	end

	local attribute = v453:GetAttribute(t2.value92)

	if not t2.value95.attrSaved then
		if attribute == t2.value91 then
			t2.value95.attrOriginal = nil
		else
			t2.value95.attrOriginal = attribute
		end

		t2.value95.attrSaved = true
	end

	local value91

	if v445 then
		value91 = t2.value91
	else
		value91 = v445
	end

	local attrOriginal = value91 or t2.value95.attrOriginal

	v453:SetAttribute(t2.value92, attrOriginal)

	local v457 = v453:GetAttribute(t2.value92) == attrOriginal
	local v458 = t2.value97(result)

	if not v458 then
		return {
			ok = v457,
			state = v445,
			effect = v457 and "applied" or v457 or "read mismatch"
		}
	end

	for _, v in ipairs(t2.value93) do
		local key = v.key
		local value = rawget(v458, key)

		if type(value) == "number" then
			if t2.value95.legacy[v.key] == nil then
				local legacy = t2.value95.legacy
				local key2 = v.key

				if value == v.on then
					value = false
				end

				legacy[key2] = value or v.off
			end

			local rawset_ = rawset
			local key2 = v.key
			local on

			if v445 then
				on = v.on
			else
				on = v445
			end

			rawset_(v458, key2, on or t2.value95.legacy[v.key])
		end
	end

	return {
		ok = v457,
		state = v445,
		effect = v457 and "applied" or v457 or "read mismatch"
	}
end

RenderStepped = function(p63, p64)
	local Frame = t2.value60("Frame", {
		Size = UDim2.new(1, 0, 0, 21),
		BackgroundTransparency = 1,
		Parent = p63
	})

	t2.value60("Frame", {
		Size = UDim2.new(1, 0, 0, 1),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundColor3 = t2.value59.Border,
		BorderSizePixel = 0,
		Parent = Frame
	})
	t2.value60("TextLabel", {
		Size = UDim2.new(1, 0, 0, 12),
		Position = UDim2.new(0, 0, 0, 9),
		BackgroundTransparency = 1,
		Text = string.upper(p64),
		TextColor3 = t2.value59.Muted,
		Font = Enum.Font.GothamBold,
		TextSize = 10,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Frame
	})

	return Frame
end
task.spawn(function()
	if t2.value14.InfiniteParry then
		for _ = 1, 20 do
			if not t2.value14.InfiniteParry then
				return
			end

			local v470 = t2.value98(true)

			if v470.ok then
				print("[Death Ball] Infinite Parry: " .. v470.effect)

				return
			end

			task.wait(1)
		end
	end
end)
t2.value99 = nil
value10 = function(p65, p66)
	local value60 = t2.value60
	local uDim22 = UDim2.new(0, 56, 0, 22)
	local Green

	if p65 then
		Green = t2.value59.Green
	else
		Green = p65
	end

	local TextButton = value60("TextButton", {
		Size = uDim22,
		BackgroundColor3 = Green or t2.value59.Off,
		Text = "",
		AutoButtonColor = false,
		BorderSizePixel = 0
	})

	t2.value61(TextButton, 11)

	local value602 = t2.value60
	local uDim23 = UDim2.new(0, 16, 0, 16)
	local vector2 = Vector2.new(0, 0.5)
	local uDim24

	if p65 then
		uDim24 = UDim2.new(1, -19, 0.5, 0)
	else
		uDim24 = p65
	end

	local Frame = value602("Frame", {
		Size = uDim23,
		AnchorPoint = vector2,
		Position = uDim24 or UDim2.new(0, 3, 0.5, 0),
		BackgroundColor3 = Color3.fromRGB(238, 240, 246),
		BorderSizePixel = 0,
		Parent = TextButton
	})

	t2.value61(Frame, 8)

	local u480 = p65

	local function v481()
		local value5 = t2.value5
		local v483 = TextButton
		local tweenInfo = TweenInfo.new(0.16)
		local Green2 = u480

		if not Green2 then
			value5:Create(v483, tweenInfo, {
				BackgroundColor3 = Green2 or t2.value59.Off
			}):Play()
			v534 = t2.value5
			v535 = Frame
			v536 = TweenInfo.new(0.16)
			v537 = u480 and UDim2.new(1, -19, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
			v534.Create(v534, v535, v536, {
				Position = v537
			}):Play()

			return
		end

		Green2 = t2.value59.Green
		value5:Create(v483, tweenInfo, {
			BackgroundColor3 = Green2 or t2.value59.Off
		}):Play()

		local value52 = t2.value5
		local v487 = Frame
		local tweenInfo2 = TweenInfo.new(0.16)
		local uDim25 = u480 and UDim2.new(1, -19, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)

		value52.Create(value52, v487, tweenInfo2, {
			Position = uDim25
		}):Play()
	end

	TextButton.MouseButton1Click:Connect(function()
		u480 = not u480
		v481()
		p66(u480)
	end)

	return TextButton, function(p67)
		u480 = p67
		v481()
	end
end

local function v490(p68, p69)
	local Frame = t2.value60("Frame", {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Parent = p68
	})

	t2.value60("UIListLayout", {
		Padding = UDim.new(0, 2),
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = Frame
	})

	local Frame2 = t2.value60("Frame", {
		Size = UDim2.new(1, 0, 0, 14),
		BackgroundTransparency = 1,
		Parent = Frame
	})

	t2.value60("Frame", {
		Size = UDim2.new(0, 3, 0, 12),
		Position = UDim2.new(0, 0, 0, 1),
		BackgroundColor3 = Color3.fromRGB(232, 92, 92),
		BorderSizePixel = 0,
		Parent = Frame2
	})
	t2.value60("TextLabel", {
		Size = UDim2.new(1, -10, 1, 0),
		Position = UDim2.new(0, 9, 0, 0),
		BackgroundTransparency = 1,
		Text = p69,
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

value9 = function(p70, p71)
	local Frame = t2.value60("Frame", {
		Size = UDim2.new(1, 0, 0, 26),
		BackgroundTransparency = 1,
		Parent = p70
	})

	t2.value60("UIPadding", {
		PaddingLeft = UDim.new(0, 4),
		PaddingRight = UDim.new(0, 4),
		Parent = Frame
	})
	t2.value60("TextLabel", {
		Size = UDim2.new(1, -120, 1, 0),
		BackgroundTransparency = 1,
		Text = p71,
		TextColor3 = t2.value59.Text,
		Font = Enum.Font.GothamMedium,
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Frame
	})

	return Frame
end

function t2.value100()
	if not t2.value99 then
		return
	end

	local value99 = t2.value99

	t2.value99 = nil
	value99.render()
end

local function v495(p72, p73, p74)
	local TextButton = t2.value60("TextButton", {
		Size = UDim2.new(0, 58, 0, 24),
		BackgroundColor3 = t2.value59.Field,
		TextColor3 = t2.value59.Text,
		Font = Enum.Font.GothamBold,
		TextSize = 12,
		Text = "",
		AutoButtonColor = false,
		BorderSizePixel = 0
	})

	t2.value61(TextButton, 6)

	local v497 = t2.value62(TextButton, t2.value59.Border, 1)

	local function v498()
		local v499 = p72()

		if v499 then
			TextButton.Text = v499.Name
			TextButton.TextColor3 = t2.value59.Text
		else
			TextButton.Text = "None"
			TextButton.TextColor3 = t2.value59.Muted
		end

		TextButton.BackgroundColor3 = t2.value59.Field
		v497.Color = t2.value59.Border
	end

	TextButton.MouseButton1Click:Connect(function()
		local value99 = t2.value99

		if not value99 then
			if value99 then
				t2.value100()
			else
				t2.value100()
				TextButton.Text = ""
				TextButton.BackgroundColor3 = t2.value59.FieldHi
				v497.Color = t2.value59.Accent
				t2.value99 = {
					box = TextButton,
					set = p73,
					render = v498,
					field = p74
				}
			end

			return
		end

		value99 = t2.value99.box == TextButton

		if value99 then
			t2.value100()
		else
			t2.value100()
			TextButton.Text = ""
			TextButton.BackgroundColor3 = t2.value59.FieldHi
			v497.Color = t2.value59.Accent
			t2.value99 = {
				box = TextButton,
				set = p73,
				render = v498,
				field = p74
			}
		end
	end)
	TextButton.MouseEnter:Connect(function()
		local value99 = t2.value99

		if value99 then
			value99 = t2.value99.box == TextButton
		end

		if value99 then
			return
		end

		TextButton.BackgroundColor3 = Color3.fromRGB(41, 41, 51)
	end)
	TextButton.MouseLeave:Connect(function()
		local value99 = t2.value99

		if value99 then
			value99 = t2.value99.box == TextButton
		end

		if value99 then
			return
		end

		TextButton.BackgroundColor3 = t2.value59.Field
	end)

	local v503 = p72()

	if v503 then
		TextButton.Text = v503.Name
		TextButton.TextColor3 = t2.value59.Text
	else
		TextButton.Text = "None"
		TextButton.TextColor3 = t2.value59.Muted
	end

	TextButton.BackgroundColor3 = t2.value59.Field
	v497.Color = t2.value59.Border

	return TextButton
end

t2.value101 = 38

local function v504(p75, p76)
	local Frame = t2.value60("Frame", {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = t2.value59.Section,
		BorderSizePixel = 0,
		Parent = p75
	})

	t2.value61(Frame, 8)
	t2.value62(Frame, t2.value59.Border, 1)
	t2.value60("UIListLayout", {
		Padding = UDim.new(0, 8),
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = Frame
	})
	t2.value60("UIPadding", {
		PaddingTop = UDim.new(0, 10),
		PaddingBottom = UDim.new(0, 12),
		PaddingLeft = UDim.new(0, 14),
		PaddingRight = UDim.new(0, 14),
		Parent = Frame
	})
	t2.value60("TextLabel", {
		Size = UDim2.new(1, 0, 0, 15),
		BackgroundTransparency = 1,
		Text = string.upper(p76),
		TextColor3 = t2.value59.Muted,
		Font = Enum.Font.GothamBold,
		TextSize = 10,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Frame
	})

	return Frame
end
local function value8(p77, p78, p79, p80, p81, p82, p83, p84)
	local Frame = t2.value60("Frame", {
		Size = UDim2.new(1, 0, 0, t2.value101),
		BackgroundTransparency = 1,
		Parent = p77
	})
	local TextLabel = t2.value60("TextLabel", {
		Size = UDim2.new(1, -70, 0, 14),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundTransparency = 1,
		Text = p78,
		TextColor3 = t2.value59.Text,
		Font = Enum.Font.GothamMedium,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = Frame
	})
	local TextLabel2 = t2.value60("TextLabel", {
		Size = UDim2.new(0, 64, 0, 14),
		Position = UDim2.new(1, 0, 0, 0),
		AnchorPoint = Vector2.new(1, 0),
		BackgroundTransparency = 1,
		Text = "",
		TextColor3 = t2.value59.Accent,
		Font = Enum.Font.GothamBold,
		TextSize = 11,
		TextXAlignment = Enum.TextXAlignment.Right,
		Parent = Frame
	})
	local Frame2 = t2.value60("Frame", {
		Size = UDim2.new(1, 0, 0, 18),
		Position = UDim2.new(0, 0, 0, 20),
		BackgroundTransparency = 1,
		Active = true,
		Parent = Frame
	})
	local Frame3 = t2.value60("Frame", {
		Size = UDim2.new(1, -12, 0, 6),
		Position = UDim2.new(0, 6, 0.5, -3),
		BackgroundColor3 = t2.value59.Field,
		BorderSizePixel = 0,
		Parent = Frame2
	})

	t2.value61(Frame3, 3)

	local Frame4 = t2.value60("Frame", {
		Size = UDim2.new(0, 0, 1, 0),
		BackgroundColor3 = t2.value59.Accent,
		BorderSizePixel = 0,
		Parent = Frame3
	})

	t2.value61(Frame4, 3)

	local Frame5 = t2.value60("Frame", {
		Size = UDim2.new(0, 12, 0, 12),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0, 0, 0.5, 0),
		BackgroundColor3 = Color3.fromRGB(240, 242, 248),
		BorderSizePixel = 0,
		Parent = Frame3
	})

	t2.value61(Frame5, 6)

	local function v514(p85)
		local v515 = (p85 - p79) / (p80 - p79)
		local v516 = math.clamp(v515, 0, 1)

		Frame4.Size = UDim2.new(v516, 0, 1, 0)
		Frame5.Position = UDim2.new(v516, 0, 0.5, 0)
		TextLabel2.Text = p83(p85)
	end

	local u517 = false

	local function v518(p86)
		local clamp = math.clamp
		local v520 = p86 - Frame3.AbsolutePosition.X
		local X = Frame3.AbsoluteSize.X
		local v522 = clamp(v520 / math.max(X, 1), 0, 1)
		local v523 = (p79 + (p80 - p79) * v522) / p81 + 0.5
		local v524 = math.floor(v523) * p81
		local v525 = p79
		local v526 = p80
		local v527 = math.clamp(v524, v525, v526)

		v514(v527)
		p84(v527)
	end

	t2.value13[#t2.value13 + 1] = Frame2.InputBegan:Connect(function(input)
		if not (input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		u517 = true
		v518(input.Position.X)
	end)
	t2.value13[#t2.value13 + 1] = t2.value3.InputChanged:Connect(function(input)
		if not u517 then
			return
		end

		if not (input.UserInputType == Enum.UserInputType.MouseMovement and true or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		v518(input.Position.X)
	end)
	t2.value13[#t2.value13 + 1] = t2.value3.InputEnded:Connect(function(input)
		local _ = input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch
	end)
	v514(p82)

	return v514, TextLabel
end

t2.value102 = t2.value60("ScreenGui", {
	Name = "DeathBallAutoParry",
	ResetOnSpawn = false,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	IgnoreGuiInset = true
})

local ok, value1 = pcall(function()
	return gethui()
end)
local t1 = {
	value3 = ok,
	value1 = value1
}

value1 = t2.value102
ok = t1.value3
ok = t1.value3

if ok then
	ok = t1.value1
end

t1.value2 = ok

if not ok then
	t1.value2 = game:GetService("CoreGui")
end

value1.Parent = t1.value2
_G.__DeathBallAutoParry.Gui = t2.value102
value1 = t2.value60
t1.value2 = Enum.ZIndexBehavior.Sibling
ok = {
	Name = "DeathBallNotifications",
	ResetOnSpawn = false,
	ZIndexBehavior = t1.value2,
	IgnoreGuiInset = true,
	DisplayOrder = 10
}

function t1.value2()
	return gethui()
end

t2.value63 = value1("ScreenGui", ok)
value1, ok = pcall(t1.value2)
t1.value1 = value1
t2.value63.Parent = t1.value1 and ok or game:GetService("CoreGui")
_G.__DeathBallAutoParry.NotifGui = t2.value63
value1 = t2.value60
t1.value2 = UDim2.new
t1.value4 = 0
t1.value3 = 0
t1.value1 = t1.value2(0.5, t1.value4, 0.5, t1.value3)
t1.value4 = Vector2.new(0.5, 0.5)
ok = t2.value59.Bg
t2.value64 = value1("Frame", {
	Name = "Main",
	Size = uDim2,
	Position = t1.value1,
	AnchorPoint = t1.value4,
	BackgroundColor3 = ok,
	BorderSizePixel = 0,
	ClipsDescendants = true,
	Parent = t2.value102
})
t2.value61(t2.value64, 10)
value1 = t2.value75
t1.value2 = t2.value102
ok = t2.value67.RefWidth

local value67 = t2.value67

t1.value3 = 7836592197185
t1.value4 = "Se\147\151\200\0292\15\161"
value67 = value67.RefHeight

local parent = { t2.value64 }

t1.value1 = t2.value64
t1.value4 = uDim2.X.Offset
t1.value3 = uDim2.Y.Offset
value1(t1.value2, ok, value67, parent, {
	Frame = t1.value1,
	BaseWidth = t1.value4,
	BaseHeight = t1.value3
})
t2.value75(t2.value63, 340, 320)
parent = select(3, v318(t2.value64, 1.5))
t2.value13[#t2.value13 + 1] = parent
parent = t2.value60
value67 = UDim.new(0, 10)
value1 = UDim.new(0, 10)
t1.value1 = UDim.new(0, 12)
t1.value3 = UDim.new(0, 12)
parent("UIPadding", {
	PaddingTop = value67,
	PaddingBottom = value1,
	PaddingLeft = t1.value1,
	PaddingRight = t1.value3,
	Parent = t2.value64
})
t2.value103 = t2.value60("Frame", {
	Name = "MainParticleHolder",
	Size = UDim2.new(1, 0, 1, 0),
	BackgroundTransparency = 1,
	ZIndex = 1,
	Parent = t2.value64
})
t2.value104 = {}
parent = 1
t1.value4 = 0
t1.value3 = parent < t1.value4
t1.value4 = 1 - parent
value67 = 20

while true do
	t1.value4 = t1.value4 + parent
	value1 = t1.value4 <= value67
	ok = not t1.value3
	t1.value1 = value1

	if ok then
		ok = t1.value1
	end

	t1.value1 = ok
	t1.value1 = t1.value3 and value67 <= t1.value4 and true or t1.value1

	if not t1.value1 then
		t1.value1 = t2.value2.RenderStepped

		function t1.value4(p87)
			if t2.value103 and t2.value103.Parent then
				local now = os.clock()

				for _, v in ipairs(t2.value104) do
					local Frame = v.Frame
					local Parent

					if Frame then
						Parent = Frame.Parent
					else
						Parent = Frame
					end

					if Parent then
						local v538 = Frame.Position.Y.Scale - v.Speed * p87 * 60

						if v538 < -0.05 then
							v.BaseX = math.random()
							Frame.Position = UDim2.new(v.BaseX, 0, 1.05, 0)
						else
							local v539 = now * 1.4 + v.Phase
							local v540 = math.sin(v539) * 0.006

							Frame.Position = UDim2.new(v.BaseX + v540, 0, v538, 0)
						end
					end
				end
			end
		end

		t2.value105 = t1.value1:Connect(t1.value4)
		t1.value2 = "wS\199"
		t1.value7 = 10030346392126
		t2.value13[#t2.value13 + 1] = t2.value105
		value13()
		t1.value1 = t2.value60
		t1.value3 = UDim2.new(0, 148, 0, 28)
		t1.value6 = UDim2
		t1.value7 = 12
		parent = t1.value6.new
		t1.value2 = 3528162887274
		t1.value6 = parent(0.5, 0, 0, t1.value7)
		t1.value4 = Vector2.new
		t1.value7 = 0
		parent = t1.value4(0.5, t1.value7)
		t1.value7 = Color3.fromRGB
		t1.value8 = 20
		t1.value2 = 20
		t1.value7 = t1.value7(t1.value2, t1.value8, 26)
		t2.value28 = t1.value1("Frame", {
			Name = "AutoSpamIndicator",
			Size = t1.value3,
			Position = t1.value6,
			AnchorPoint = parent,
			BackgroundColor3 = t1.value7,
			BorderSizePixel = 0,
			Visible = false,
			Active = true,
			Parent = t2.value102
		})
		t2.value61(t2.value28, 8)
		t2.value62(t2.value28, t2.value59.Green, 1)
		t1.value1 = t2.value60
		t1.value2 = 26400140308485
		t1.value5 = UDim2.new(0, 8, 0, 8)
		t1.value2 = 10040378511939
		parent = UDim2.new(0, 12, 0.5, -4)
		t1.value4 = t2.value59
		t1.value8 = 20285653001446
		t1.value2 = "g\0\223\26\178\2437{\236]e5\20E\197"
		t1.value6 = t1.value4.Green
		parent = {
			Size = t1.value5,
			Position = parent,
			BackgroundColor3 = t1.value6,
			BorderSizePixel = 0,
			Parent = t2.value28
		}
		t1.value2 = "\134\185\233"
		parent = t1.value1("Frame", parent)
		t2.value61(parent, 4)
		t1.value1 = t2.value60
		t1.value3 = UDim2.new(1, -32, 1, 0)
		parent = UDim2.new
		t1.value7 = 0
		t1.value6 = parent(0, 26, 0, t1.value7)
		t1.value2 = 30394020788041
		t1.value7 = "@ِ\233\234=eK&\173e\233\161\237\7f\228\132\232S4d"
		t1.value2 = t2.value59.Green
		parent = Enum.Font.GothamBold
		t1.value4 = Enum.TextXAlignment.Left
		t1.value1("TextLabel", {
			Size = t1.value3,
			Position = t1.value6,
			BackgroundTransparency = 1,
			Text = "AUTO SPAM · ON",
			TextColor3 = t1.value2,
			Font = parent,
			TextSize = 12,
			TextXAlignment = t1.value4,
			Parent = t2.value28
		})
		v128(t2.value28, t2.value28)
		t1.value1 = t2.value60
		t1.value7 = 15798497254588
		t1.value5 = UDim2.new
		t1.value7 = "\\U:\127\2\24"
		t1.value3 = t1.value5(1, 0, 0, 32)
		parent = {
			Size = t1.value3,
			BackgroundTransparency = 1,
			Active = true,
			Parent = t2.value64
		}
		t1.value8 = "\215\24\\"
		t1.value3 = t1.value1("Frame", parent)
		t1.value1 = t2.value60
		t1.value4 = UDim2
		t1.value2 = 38
		t1.value7 = 0
		t1.value6 = t1.value4.new
		t1.value8 = 27184985436530
		t1.value4 = t1.value6(0, 38, t1.value7, t1.value2)
		parent = UDim2.new
		t1.value2 = -4
		t1.value8 = 0.5
		t1.value7 = 0
		t1.value7 = parent(t1.value7, t1.value2, t1.value8, -18)
		parent = t2.value59.Accent
		value67 = Enum.ScaleType.Fit
		t2.value106 = t1.value1("ImageLabel", {
			Name = "LogoDotGlow",
			Size = t1.value4,
			Position = t1.value7,
			BackgroundTransparency = 1,
			Image = "rbxassetid://84154329190977",
			ImageColor3 = parent,
			ImageTransparency = 0.55,
			ScaleType = value67,
			ZIndex = 1,
			Parent = t1.value3
		})
		parent = t2.value60
		value67 = UDim2
		t1.value7 = 29
		t1.value2 = 0
		value67 = value67.new(0, t1.value7, t1.value2, 29)
		t1.value7 = UDim2.new
		t1.value8 = 0
		t1.value2 = 0
		t1.value7 = t1.value7(t1.value2, t1.value8, 0.5, -13)
		t1.value6 = Enum.ScaleType.Fit
		t2.value107 = parent("ImageLabel", {
			Name = "LogoDot",
			Size = value67,
			Position = t1.value7,
			BackgroundTransparency = 1,
			Image = "rbxassetid://84154329190977",
			ScaleType = t1.value6,
			ZIndex = 2,
			Parent = t1.value3
		})
		t1.value1 = t2.value2
		t1.value2 = 9414580506912
		parent = t1.value1.RenderStepped

		function t1.value5()
			if t2.value107 and t2.value107.Parent then
				local now = os.clock()
				local v542 = math.sin(now * 1.8) * 2

				t2.value107.Position = UDim2.new(0, 0, 0.5, -13 + v542)
				t2.value106.Position = UDim2.new(0, -4, 0.5, -18 + v542)

				local value106 = t2.value106
				local v545 = now * 1.8

				value106.ImageTransparency = 0.45 + math.sin(v545) * 0.15

				local v546 = now * 1.8
				local v547 = math.sin(v546) * 3 + 38

				t2.value106.Size = UDim2.new(0, v547, 0, v547)
			end
		end

		t1.value7 = "2\136\19\228"
		t2.value108 = parent:Connect(t1.value5)
		t2.value13[#t2.value13 + 1] = t2.value108
		parent = t2.value60
		t1.value4 = UDim2.new
		t1.value2 = 1
		t1.value7 = -90
		value67 = t1.value4(1, t1.value7, t1.value2, 0)
		t1.value8 = "K\140\164T\26Ş\215"
		t1.value7 = UDim2.new
		t1.value8 = 34
		t1.value2 = 0
		t1.value7 = t1.value7(t1.value2, t1.value8, 0, 0)
		t1.value6 = t2.value59.Text
		t1.value4 = Enum.Font.GothamBold
		t1.value8 = Enum.TextXAlignment.Left
		parent("TextLabel", {
			Size = value67,
			Position = t1.value7,
			BackgroundTransparency = 1,
			Text = "SENTENAL Z • DEATH BALL",
			TextColor3 = t1.value6,
			Font = t1.value4,
			TextSize = 13,
			TextXAlignment = t1.value8,
			Parent = t1.value3
		})
		t1.value7 = "]Ӄ*"
		parent = t2.value60
		t1.value2 = 31271845624034
		t1.value4 = UDim2.new
		t1.value2 = 1
		t1.value7 = 48
		t1.value8 = 0
		value67 = t1.value4(0, t1.value7, t1.value2, t1.value8)
		t1.value7 = UDim2
		t1.value8 = 0
		t1.value7 = t1.value7.new(1, t1.value8, 0, 0)
		t1.value8 = Vector2.new(1, 0)
		t1.value4 = t2.value59.Muted
		value1 = Enum.Font.GothamMedium
		t1.value1 = Enum.TextXAlignment.Right
		parent("TextLabel", {
			Size = value67,
			Position = t1.value7,
			AnchorPoint = t1.value8,
			BackgroundTransparency = 1,
			Text = "1.15v",
			TextColor3 = t1.value4,
			Font = value1,
			TextSize = 11,
			TextXAlignment = t1.value1,
			Parent = t1.value3
		})
		parent = t2.value60
		t1.value1 = UDim2
		t1.value1 = t1.value1.new(1, 0, 1, -102)
		t1.value3 = UDim2.new(0, 0, 0, 42)
		value67 = UDim2
		t1.value2 = 0
		t1.value7 = 0
		t1.value8 = 0
		value67 = value67.new(0, t1.value7, t1.value2, t1.value8)
		t1.value7 = Enum.AutomaticSize.Y
		t1.value2 = Enum.ScrollingDirection.Y
		t1.value6 = t2.value59.Field
		value1 = Enum.ScrollBarInset.ScrollBar
		t1.value8 = Enum.ElasticBehavior.Never
		parent = parent("ScrollingFrame", {
			Size = t1.value1,
			Position = t1.value3,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Active = true,
			CanvasSize = value67,
			AutomaticCanvasSize = t1.value7,
			ScrollingDirection = t1.value2,
			ScrollBarThickness = 6,
			ScrollBarImageColor3 = t1.value6,
			ScrollBarImageTransparency = 0,
			VerticalScrollBarInset = value1,
			ElasticBehavior = t1.value8,
			Parent = t2.value64
		})
		value67 = t2.value60
		t1.value7 = "B6\132"
		value1 = UDim.new(0, 9)
		t1.value3 = Enum.SortOrder.LayoutOrder
		value67("UIListLayout", {
			Padding = value1,
			SortOrder = t1.value3,
			Parent = parent
		})
		value67 = t2.value60
		value1 = UDim.new(0, 6)
		ok = UDim.new(0, 8)
		t1.value5 = UDim.new(0, 6)
		value13 = UDim.new(0, 6)
		value67("UIPadding", {
			PaddingTop = value1,
			PaddingBottom = ok,
			PaddingLeft = t1.value5,
			PaddingRight = value13,
			Parent = parent
		})
		t2.value109 = nil
		t2.value110 = nil
		value67 = v504(parent, "Main")
		v490(value67, "Auto Parry is unreliable on Xeno, Solara")
		t1.value2 = value9(value67, "Auto Parry")
		value1, ok = value10(t2.value14.AutoParry, function(p88)
			t2.value86(p88)
		end)
		t1.value1 = value1
		t1.value1.Position = UDim2.new(1, -66, 0.5, 0)
		t1.value1.AnchorPoint = Vector2.new(1, 0.5)
		t1.value1.Parent = t1.value2
		t1.value3 = v495(function()
			return t2.value14.AutoParryKey
		end, function(p89)
			t2.value14.AutoParryKey = p89
		end, "AutoParryKey")
		t1.value3.Position = UDim2.new(1, 0, 0.5, 0)
		t1.value3.AnchorPoint = Vector2.new(1, 0.5)
		t1.value3.Parent = t1.value2
		value1 = value9(value67, "Infinite Dash")
		value13, uDim2 = value10(t2.value14.AutoDash, function(p90)
			t2.value110(p90)
		end)
		t1.value5 = value13
		t1.value3 = uDim2
		t2.value111 = t1.value3
		t1.value6 = UDim2.new
		t1.value7 = 0.5
		t1.value4 = t1.value6(1, -66, t1.value7, 0)
		t1.value8 = "3x+"
		t1.value7 = 7887059390040
		t1.value5.Position = t1.value4
		t1.value5.AnchorPoint = Vector2.new(1, 0.5)
		t1.value7 = 18602166641110
		t1.value5.Parent = value1
		value13 = v495(function()
			return t2.value14.AutoDashKey
		end, function(p91)
			t2.value14.AutoDashKey = p91
		end, "AutoDashKey")
		t1.value4 = UDim2.new
		t1.value8 = 0
		t1.value7 = 0
		value13.Position = t1.value4(1, t1.value7, 0.5, t1.value8)
		uDim2 = Vector2
		t1.value2 = 31494395918665
		t1.value7 = 0.5
		value13.AnchorPoint = uDim2.new(1, t1.value7)
		value13.Parent = value1
		t1.value2 = "\243\20r\7P\152t\20o\140\176{\17"
		value67 = value9(value67, "Infinite Parry")
		value1 = value10(t2.value14.InfiniteParry, function(p92)
			t2.value14.InfiniteParry = p92

			local v548 = t2.value98(p92)

			t2.value85("Infinite Parry", p92)

			if v548.ok then
				return
			end

			local value83 = t2.value83
			local effect = v548.effect

			value83("Infinite Parry: " .. tostring(effect))
		end)
		t1.value4 = UDim2
		t1.value7 = 0.5
		t1.value6 = t1.value4.new
		t1.value2 = 0
		value1.Position = t1.value6(1, 0, t1.value7, t1.value2)
		t1.value6 = Vector2.new
		t1.value7 = 23842862426974
		t1.value8 = 6364366883731
		value1.AnchorPoint = t1.value6(1, 0.5)
		value1.Parent = value67
		value67 = v504(parent, "Auto Spam")
		t1.value6 = value9(value67, "Auto Spam")
		value1, value13 = value10(t2.value14.AutoSpam, function(p93)
			t2.value87(p93)
		end)
		t1.value4 = value1
		t1.value4.Position = UDim2.new(1, -66, 0.5, 0)
		t1.value7 = Vector2.new
		t1.value8 = 1
		t1.value4.AnchorPoint = t1.value7(t1.value8, 0.5)
		t1.value4.Parent = t1.value6

		function t1.value2(p94)
			t2.value14.AutoSpamKey = p94
		end

		t1.value7 = v495(function()
			return t2.value14.AutoSpamKey
		end, t1.value2, "AutoSpamKey")
		t1.value7.Position = UDim2.new(1, 0, 0.5, 0)
		t1.value7.AnchorPoint = Vector2.new(1, 0.5)
		t1.value7.Parent = t1.value6
		t1.value2 = "Spam Rate"
		t1.value1 = t2.value14
		t1.value8 = 0.02
		t1.value6 = t1.value1.AutoSpamRate

		function t1.value4(p95)
			t2.value14.AutoSpamRate = p95
		end

		value8(value67, t1.value2, t1.value8, 0.3, 0.01, t1.value6, function(p96)
			return string.format("%.2fs", p96)
		end, t1.value4)
		value67 = v504(parent, "AI Movement")
		value1 = value9(value67, "AI Movement")
		uDim2, v1322 = value10(t2.value14.AIMovement, function(p97)
			t2.value88(p97)
		end)
		t1.value1 = uDim2
		t1.value4 = v1322
		t1.value1.Position = UDim2.new(1, -66, 0.5, 0)
		t1.value1.AnchorPoint = Vector2.new(1, 0.5)
		t1.value1.Parent = value1

		function t1.value1(p98)
			t2.value14.AIMovementKey = p98
		end

		v1322 = v495(function()
			return t2.value14.AIMovementKey
		end, t1.value1, "AIMovementKey")
		v1322.Position = UDim2.new(1, 0, 0.5, 0)
		v1322.AnchorPoint = Vector2.new(1, 0.5)
		v1322.Parent = value1
		v1322 = value9(value67, "Follow Ball")
		t1.value1 = value10(t2.value14.FollowBall, function(p99)
			t2.value14.FollowBall = p99
			t2.value33.NextTurn = 0
			t2.value33.AvoidUntil = 0
			t2.value85("Follow Ball", p99)
			print("[Death Ball] Follow Ball:", p99 and "ON" or p99 or "OFF")
		end)
		t1.value1.Position = UDim2.new(1, 0, 0.5, 0)
		t1.value1.AnchorPoint = Vector2.new(1, 0.5)
		t1.value1.Parent = v1322
		RenderStepped(value67, "Camera Rotation")
		t1.value8 = value9(value67, "Camera Rotation")
		v1322, value1 = value10(t2.value14.CameraRotation, function(p100)
			t2.value90(p100)
		end)
		t1.value1 = v1322
		t1.value3 = value1
		t1.value1.Position = UDim2.new(1, -66, 0.5, 0)
		t1.value1.AnchorPoint = Vector2.new(1, 0.5)
		t1.value1.Parent = t1.value8
		t1.value1 = v495(function()
			return t2.value14.CameraRotationKey
		end, function(p101)
			t2.value14.CameraRotationKey = p101
		end, "CameraRotationKey")
		t1.value7 = UDim2.new
		t1.value2 = 0
		t1.value1.Position = t1.value7(1, 0, 0.5, t1.value2)
		t1.value1.AnchorPoint = Vector2.new(1, 0.5)
		t1.value1.Parent = t1.value8
		value8(value67, "Cam Roam", 0, 10, 0.5, t2.value14.CameraRoamTime, function(p102)
			return p102 <= 0 and "Off" or string.format("%.1fs", p102)
		end, function(p103)
			t2.value14.CameraRoamTime = p103
			t2.value38.Timer = 0

			local v550

			if p103 > 0 then
				v550 = t2.value38.Mode ~= "roam"
			else
				v550 = false
			end

			if not v550 then
				return
			end

			t2.value38.Mode = "roam"
			t2.value38.Target = nil
		end)
		t1.value7 = "Cam Lock"
		t1.value2 = t2.value14.CameraLockTime

		function t1.value6(p104)
			t2.value14.CameraLockTime = p104
			t2.value38.Timer = 0
		end

		value8(value67, t1.value7, 0, 10, 0.5, t1.value2, function(p105)
			local v551 = p105 <= 0

			return v551 and "Off" or v551 or string.format("%.1fs", p105)
		end, t1.value6)
		t1.value2 = 5870057491117
		t1.value9 = 27563910165027
		value8(value67, "Cam Speed", 0.2, 4, 0.1, t2.value14.CameraSpeed, function(p106)
			return string.format("%.2fx", p106)
		end, function(p107)
			t2.value14.CameraSpeed = p107
		end)
		t1.value7 = "Cam Aggression"
		t1.value2 = t2.value14.CameraAggression

		function t1.value6(p108)
			t2.value14.CameraAggression = p108

			if t2.value38.Mode ~= "roam" then
				return
			end

			t2.value41()
		end

		value8(value67, t1.value7, 0, 4, 0.1, t1.value2, function(p109)
			return string.format("%.2fx", p109)
		end, t1.value6)
		RenderStepped(value67, "Auto Ready · Lobby Only")
		t1.value5 = value9(value67, "Auto Ready")
		v1322, value1 = value10(t2.value14.AutoReady, function(p110)
			t2.value89(p110)
		end)
		t1.value2 = UDim2.new
		t1.value7 = 0
		t1.value9 = 18509132194218
		v1322.Position = t1.value2(1, -66, 0.5, t1.value7)
		v1322.AnchorPoint = Vector2.new(1, 0.5)

		function t1.value2(p111)
			t2.value14.AutoReadyKey = p111
		end

		v1322.Parent = t1.value5
		v1322 = v495(function()
			return t2.value14.AutoReadyKey
		end, t1.value2, "AutoReadyKey")
		v1322.Position = UDim2.new(1, 0, 0.5, 0)
		t1.value1 = 4453601511449
		t1.value2 = Vector2.new
		t1.value9 = 432812163273
		t1.value7 = 19597780247461
		v1322.AnchorPoint = t1.value2(1, 0.5)
		v1322.Parent = t1.value5
		t2.value112 = nil
		t1.value2 = value9(value67, "Idle Pause")
		t1.value6 = value10(t2.value14.AutoReadyIdle, function(p112)
			t2.value14.AutoReadyIdle = p112

			if t2.value112 then
				local value112 = t2.value112
				local s3 = "TextColor3"
				local Text

				if p112 then
					Text = t2.value59.Text
				else
					Text = p112
				end

				value112[s3] = Text or t2.value59.Muted
			end

			if p112 then
				t2.value85("Idle Pause", p112)
				print("[Death Ball] Idle Pause:", p112 and "ON" or p112 or "OFF")

				return
			end

			t2.value46.Parked = false
			t2.value46.ParkUntil = 0
			t2.value46.NextPick = 0
			t2.value85("Idle Pause", p112)
			print("[Death Ball] Idle Pause:", p112 and "ON" or p112 or "OFF")
		end)
		t1.value6.Position = UDim2.new(1, 0, 0.5, 0)
		t1.value6.AnchorPoint = Vector2.new(1, 0.5)
		t1.value7 = 2
		t1.value6.Parent = t1.value2
		t2.value112 = select(t1.value7, value8(value67, "Hold Time", 0, 10, 0.5, t2.value14.AutoReadyDelay, function(p113)
			return p113 <= 0 and "Forever" or string.format("%.1fs", p113)
		end, function(p114)
			t2.value14.AutoReadyDelay = p114

			local Parked = t2.value46.Parked

			if Parked then
				if t2.value46.ParkUntil == math.huge then
					Parked = p114 > 0
				else
					Parked = false
				end
			end

			if not Parked then
				return
			end

			t2.value46.ParkUntil = os.clock() + p114
		end))
		t2.value112.TextColor3 = t2.value14.AutoReadyIdle and t2.value59.Text or t2.value59.Muted
		t1.value6 = 25952394129205
		t1.value7 = 9415736660256
		t1.value9 = 0.45
		t1.value7 = "Edge Inset"
		t1.value5 = 0
		t1.value1 = 0.01
		t1.value8 = 28733930337348
		v1322 = t2.value14.AutoReadyEdge

		function t1.value8(p115)
			t2.value14.AutoReadyEdge = p115
		end

		value8(value67, t1.value7, t1.value5, t1.value9, t1.value1, v1322, function(p116)
			return string.format("%d%%", (math.floor(p116 * 100 + 0.5)))
		end, t1.value8)
		v1322 = v504(parent, "Humanizer")
		t1.value7 = "$-\228\193S\132\153\208n{"
		t1.value9 = 6577741745143
		t1.value2 = 32026981202497
		t1.value8 = t2.value14.JumpInterval

		function t1.value1(p117)
			t2.value14.JumpInterval = p117
		end
		function t1.value9(p118)
			return p118 <= 0 and "Off" or string.format("%.1fs", p118)
		end

		value8(v1322, "Jump Interval", 0, 10, 0.5, t1.value8, t1.value9, t1.value1)
		t1.value9 = 10449060320001
		t1.value8 = "#\227\212*\218\241"
		t1.value7 = "\212Bb\212\29\28\131\214\243!ފk"
		v1322 = v504(parent, "Extras")
		t1.value6 = value9(v1322, "Spam Parry")
		value67 = value10(t2.value14.AutoSpamParry, function(p119)
			t2.value14.AutoSpamParry = p119
			t2.value85("Spam Parry", p119)
		end)
		t1.value8 = UDim2
		t1.value2 = 19614635025325
		t1.value7 = 0
		t1.value1 = 0
		t1.value8 = t1.value8.new(1, t1.value1, 0.5, t1.value7)
		value67.Position = t1.value8
		t1.value9 = "Vector2"
		t1.value9 = 18220436611364
		t1.value2 = 5497792563712
		t1.value8 = Vector2
		t1.value1 = 0.5
		t1.value2 = "d?\219v;/\254\18\206a\147\30"
		t1.value5 = "u^6\238\2\\\213\22[\217}\229$J\31\175\149\"\224\238\216\205BA\237\153"
		t1.value5 = 20416129639715
		t1.value8 = t1.value8.new(1, t1.value1)
		value67.AnchorPoint = t1.value8
		t1.value1 = "!\134\163\228ٕ"
		t1.value7 = 6094921943830
		value67.Parent = t1.value6
		value67 = value9(v1322, "Perfect Parry")
		t1.value1 = value10(t2.value14.PerfectParry, function(p120)
			t2.value14.PerfectParry = p120
			t2.value85("Perfect Parry", p120)
		end)
		t1.value2 = "\237\149\27"
		t1.value6 = 10520364815138
		t1.value5 = "UDim2"
		t1.value9 = UDim2.new
		t1.value5 = 1
		t1.value2 = 0
		t1.value8 = 5243899922825
		t1.value1.Position = t1.value9(t1.value5, 0, 0.5, t1.value2)
		t1.value6 = 14343710988823
		t1.value7 = "\165\132\0306\169\209\29W\157\187?"
		t1.value2 = "ڞ\""
		t1.value9 = Vector2.new
		t1.value5 = 1
		t1.value7 = 0.5
		t1.value1.AnchorPoint = t1.value9(t1.value5, t1.value7)
		t1.value9 = value67
		t1.value1.Parent = t1.value9
		t1.value9 = "Ping Comp"
		t1.value1 = 0
		t1.value2 = t2.value14
		t1.value7 = 0.05
		t1.value5 = 2
		value67 = t1.value2.PingCompensationMultiplier

		function t1.value2(p121)
			t2.value14.PingCompensationMultiplier = p121
		end

		value8(v1322, t1.value9, t1.value1, t1.value5, t1.value7, value67, function(p122)
			return string.format("%.2fx", p122)
		end, t1.value2)
		t1.value1 = "game"
		t1.value8 = nil
		t1.value8 = game
		t1.value2 = "Ö~\15\203N\157ƻ\132\7\182u\240\241"
		t1.value6 = 3431126943293
		t1.value1 = "GetService"
		t1.value1 = t1.value8:GetService("ReplicatedFirst")

		function t1.value2(p123)
			local function v556(p124, p125, p126)
				for i = 1, #p123 do
					p124 = (p124 * p125 + p123:byte(i) * p126) % 2147483647
				end

				return p124
			end

			local v558 = v556(5381, 33, 1)
			local v559 = string.format("%08x", v558)
			local v560 = v559.sub(v559, -8)
			local v561 = v556(7919, 31, 7)
			local v562 = string.format("%08x", v561)
			local v563 = v562.sub(v562, -4)
			local v564 = v556(104729, 37, 3)
			local v565 = string.format("%08x", v564)
			local v566 = v565.sub(v565, -4)
			local v567 = v556(1299709, 41, 11)
			local v568 = string.format("%08x", v567)
			local v569 = v568.sub(v568, -4)
			local v570 = v556(15485863, 43, 5)
			local v571 = string.format("%08x", v570)
			local v572 = v571.sub(v571, -8)
			local v573 = v556(5381, 33, 1)
			local v574 = string.format("%08x", v573)

			return v560 .. "-" .. v563 .. "-" .. v566 .. "-" .. v569 .. "-" .. v572 .. v574.sub(v574, -4)
		end
		function t1.value5(...)
			print("[Death Ball] Swords:", ...)
		end
		function t1.value7(p127)
			local n12 = 0

			for _ in pairs(p127) do
				n12 = n12 + 1
			end

			return n12
		end

		t2.value113 = t1.value1
		t2.value114 = t1.value5
		t2.value115 = t1.value7
		t1.value7 = false
		t1.value6 = {}

		function t2.value116(p128)
			local getgc_ = getgc

			if type(getgc_) == "function" then
				for _, v in ipairs({ true, false }) do
					local ok2, result = pcall(getgc, v)

					if ok2 then
						ok2 = type(result) == "table"
					end

					if ok2 then
						for _, v2 in pairs(result) do
							p128(v2)
						end
					end
				end
			end
		end

		local function v584(p129, p130)
			local Core = t2.value113:FindFirstChild("Core")

			if not Core then
				local ok2, result = pcall(function()
					local value113 = t2.value113
					local v589 = p130

					return value113.WaitForChild(value113, "Core", v589 or 10)
				end)

				Core = ok2 and result and result or nil
			end

			if not Core then
				return nil
			end

			local v590 = Core:FindFirstChild(p129)

			if v590 then
				return v590
			end

			local ok2, result = pcall(function()
				local v593 = Core

				return v593.WaitForChild(v593, p129, p130 or 10)
			end)

			v590 = ok2 and result and result or nil

			return v590
		end

		t2.value117 = t1.value2
		t2.value118 = {}
		t2.value119 = t1.value6
		t2.value120 = 0
		t2.value121 = t1.value7
		t2.value122 = nil

		function t1.value1()
			if t2.value121 then
				return true
			end

			local TradablesUI = v584("TradablesUI", 10)

			if not TradablesUI then
				t2.value122 = "TradablesUI not found"

				return false
			end

			local ok2, result = pcall(require, TradablesUI)

			if not ok2 then
				t2.value122 = "require failed: " .. tostring(result)

				return false
			end

			local v597 = type(result) ~= "table"
			local v598, v599, v600, value118

			if v597 then
				if v597 then
					t2.value122 = "TradablesUI.Swords.BinData missing"

					return false
				else
					v598, v599, v600 = pairs(result.Swords.BinData)
					value118 = {}

					while true do
						v600 = v598(v599, v600)

						if not v600 then
							break
						end

						value118[v600] = true
					end

					t2.value120 = t2.value115(value118)

					if t2.value120 == 0 then
						t2.value122 = "BinData empty"

						return false
					else
						t2.value118 = value118
						t2.value119 = {}

						for k in pairs(t2.value118) do
							t2.value119[k] = t2.value117(k)
						end

						t2.value122 = "ok"
						t2.value114("sword names (BinData):", t2.value120)

						return true
					end
				end
			end

			local Swords = result.Swords

			if type(Swords) == "table" then
				local BinData = result.Swords.BinData

				v597 = type(BinData) ~= "table"
			else
				v597 = true
			end

			if v597 then
				t2.value122 = "TradablesUI.Swords.BinData missing"

				return false
			else
				v598, v599, v600 = pairs(result.Swords.BinData)
				value118 = {}

				while true do
					v600 = v598(v599, v600)

					if not v600 then
						break
					end

					value118[v600] = true
				end

				t2.value120 = t2.value115(value118)

				if t2.value120 == 0 then
					t2.value122 = "BinData empty"

					return false
				else
					t2.value118 = value118
					t2.value119 = {}

					for k in pairs(t2.value118) do
						t2.value119[k] = t2.value117(k)
					end

					t2.value122 = "ok"
					t2.value114("sword names (BinData):", t2.value120)

					return true
				end
			end
		end

		t2.value122 = "not loaded"
		t2.value123 = t1.value1

		function t2.value124(p131)
			if type(p131) ~= "table" then
				return 0, 0
			end

			local Swords = p131.Swords

			if type(Swords) ~= "table" then
				p131.Swords = {}
			end

			local DiscoveredItems = p131.DiscoveredItems

			if type(DiscoveredItems) ~= "table" then
				p131.DiscoveredItems = {}
			end

			local Swords2 = p131.DiscoveredItems.Swords
			local v609, v610, Type, v612

			if type(Swords2) == "table" then
				v727 = pairs
				v728, v729, v730 = v727(p131.Swords)
				v731 = 0

				while true do
					v730, v609 = v728(v729, v730)

					if not v730 then
						break
					end

					v610 = type(v609) == "table"

					if v610 then
						v610 = v609.Type

						if v610 then
							v610 = not t2.value118[v609.Type]
						end
					end

					if v610 then
						p131.Swords[v730] = nil
						v727 = v731 + 1
						v731 = v727
					end
				end

				v732 = {}

				for _, sword in pairs(p131.Swords) do
					if type(sword) == "table" then
						Type = sword.Type
					else
						Type = false
					end

					if Type then
						v732[sword.Type] = true
					end
				end

				v735, v736, v737 = pairs(t2.value118)
				v738 = 0

				while true do
					v737 = v735(v736, v737)

					if not v737 then
						break
					end

					if not v732[v737] then
						p131.Swords[t2.value119[v737]] = {
							CreatedAt = os.time(),
							Type = v737
						}
						v738 = v738 + 1
					end

					p131.DiscoveredItems.Swords[v737] = true
				end

				v739 = p131.MaxSwords

				if type(v739) == "number" then
					v612 = p131.MaxSwords < t2.value120
				else
					v612 = false
				end

				if not v612 then
					return v738, v731
				end

				p131.MaxSwords = t2.value120

				return v738, v731
			end

			p131.DiscoveredItems.Swords = {}

			local pairs_ = pairs
			local v616, v617, v618 = pairs_(p131.Swords)
			local n13 = 0

			while true do
				v618, v609 = v616(v617, v618)

				if not v618 then
					break
				end

				v610 = type(v609) == "table"

				if v610 then
					v610 = v609.Type

					if v610 then
						v610 = not t2.value118[v609.Type]
					end
				end

				if v610 then
					p131.Swords[v618] = nil
					pairs_ = n13 + 1
					n13 = pairs_
				end
			end

			local t14 = {}

			for _, sword in pairs(p131.Swords) do
				if type(sword) == "table" then
					Type = sword.Type
				else
					Type = false
				end

				if Type then
					t14[sword.Type] = true
				end
			end

			local v623, v624, v625 = pairs(t2.value118)
			local n14 = 0

			while true do
				v625 = v623(v624, v625)

				if not v625 then
					break
				end

				if not t14[v625] then
					p131.Swords[t2.value119[v625]] = {
						CreatedAt = os.time(),
						Type = v625
					}
					n14 = n14 + 1
				end

				p131.DiscoveredItems.Swords[v625] = true
			end

			local MaxSwords = p131.MaxSwords

			if type(MaxSwords) == "number" then
				v612 = p131.MaxSwords < t2.value120
			else
				v612 = false
			end

			if not v612 then
				return n14, n13
			end

			p131.MaxSwords = t2.value120

			return n14, n13
		end

		t2.value125 = nil
		t2.value126 = false

		function t2.value127(p132)
			local newcclosure_ = newcclosure

			if type(newcclosure_) == "function" then
				local ok2, result = pcall(newcclosure, p132)

				if ok2 and result then
					return result
				else
					return p132
				end
			else
				return p132
			end
		end

		t2.value128 = nil

		function t2.value128()
			local Remotes = t2.value6:FindFirstChild("Remotes")

			if not Remotes then
				return Remotes
			end

			Remotes = Remotes:FindFirstChild("GetInventory")

			return Remotes
		end
		function t2.value129()
			if t2.value126 then
				return true
			end

			t2.value125 = t2.value125 or t2.value128()

			if not t2.value125 then
				return false
			end

			local v632 = (getrawmetatable or getmetatable)(game)
			local v633 = not v632

			if not v633 then
				local __namecall = v632.__namecall

				v633 = type(__namecall) ~= "function"
			end

			if v633 then
				return false
			end

			local __namecall = v632.__namecall

			pcall(function()
				setreadonly(v632, false)
			end)

			local function v636(p133, ...)
				local getnamecallmethod_ = getnamecallmethod
				local v638 = type(getnamecallmethod_) == "function"
				local v639

				if v638 then
				elseif v638 then
					v639 = __namecall(p133, ...)
					pcall(t2.value124, v639)

					return v639
				else
					return __namecall(p133, ...)
				end

				if getnamecallmethod() == "InvokeServer" then
					v638 = p133 == t2.value125
				else
					v638 = false
				end

				if v638 then
					v639 = __namecall(p133, ...)
					pcall(t2.value124, v639)

					return v639
				else
					return __namecall(p133, ...)
				end
			end

			v632.__namecall = t2.value127(v636)
			pcall(function()
				setreadonly(v632, true)
			end)
			t2.value114("GetInventory hook installed")

			return true
		end
		function t2.value130()
			local Inventory = v584("Inventory", 10)

			if not Inventory then
				return
			end

			local ok2, result = pcall(require, Inventory)

			if not ok2 or type(result) ~= "table" then
				return
			end

			local v643 = nil

			for _, v in ipairs({
				"Connect",
				"RawConnect",
				"PartialConnect",
				"ConnectAndExecute",
				"PartialConnectAndExecute"
			}) do
				local v646 = result[v]

				if type(v646) == "function" then
					local ok3, result2 = pcall(debug.getupvalues, v646)

					if ok3 then
						ok3 = type(result2) == "table"
					end

					if ok3 then
						for _, v2 in pairs(result2) do
							if type(v2) == "table" then
								for k, v3 in pairs(v2) do
									if tostring(k) == "Bindable" then
										v643 = v3
									end
								end
							end
						end
					end
				end
			end

			local isBindableEvent

			if typeof(v643) == "Instance" then
				isBindableEvent = v643:IsA("BindableEvent")
			else
				isBindableEvent = false
			end

			if not isBindableEvent then
				return
			end

			pcall(function()
				v643:Fire()
			end)
		end
		function t1.value6()
			t2.value130()

			local Remotes = t2.value6:FindFirstChild("Remotes")

			if Remotes then
				Remotes = Remotes:FindFirstChild("InventoryChanged")
			end

			local v655

			if Remotes then
				local getconnections_ = getconnections

				v655 = type(getconnections_) == "function"
			else
				v655 = Remotes
			end

			if v655 then
				for _, v in ipairs(getconnections(Remotes.OnClientEvent)) do
					pcall(function()
						v.Function()
					end)
				end
			end

			local ViewInventory = t2.value6:FindFirstChild("ViewInventory")
			local isBindableEvent

			if typeof(ViewInventory) == "Instance" then
				isBindableEvent = ViewInventory:IsA("BindableEvent")
			else
				isBindableEvent = false
			end

			if not isBindableEvent then
				return
			end

			pcall(function()
				ViewInventory:Fire()
			end)
		end

		t2.value131 = t1.value6

		function t2.value132()
			local n15 = 0
			local n16 = 0
			local n17 = 0
			local n18 = 0
			local n19 = 0

			local function v666(p134)
				if type(p134) ~= "table" then
					return
				end

				local value = rawget(p134, "Swords")

				if value then
					value = rawget(p134, "EquippedSwords")
				end

				if not value then
					return
				end

				n18 = n18 + 1

				local v668 = t2.value115(p134)

				if n19 < v668 then
					n19 = v668
				end

				if not (v668 > 50) then
					return
				end

				n16 = n16 + 1

				local v669, v670 = t2.value124(p134)

				n17 = n17 + v669
				n15 = n15 + v670
			end

			t2.value116(v666)

			local v671

			if n16 == 0 then
				v671 = n18 > 0
			else
				v671 = false
			end

			if not v671 then
				return n16, n17, n15
			end

			t2.value114(("candidates:%d but none over 50 keys (largest %d)").format("candidates:%d but none over 50 keys (largest %d)", n18, n19))

			return n16, n17, n15
		end

		local function unlockAllSwords()
			if t2.value123() then
				t2.value129()

				local v673, v674, v675 = t2.value132()

				t2.value114(("scan -> tables:%d added:%d removed:%d").format("scan -> tables:%d added:%d removed:%d", v673, v674, v675))

				if v673 == 0 then
					return false, 0, "no inventory found"
				else
					t2.value131()

					return true, v674, v675
				end
			else
				t2.value114("list unavailable:", t2.value122)

				return false, 0, t2.value122
			end
		end

		if getgenv then
			getgenv().UnlockAllSwords = unlockAllSwords
		end

		v490(v1322, "Client only!")
		t1.value8 = game
		t1.value1 = t1.value8.GetService
		t1.value1 = t1.value1(t1.value8, "ReplicatedFirst")
		t1.value5 = v4
		t2.value133 = t1.value1
		value67 = getgenv

		if value67 then
			value67 = getgenv()
		end

		t1.value7 = value67
		t1.value1 = t1.value7

		if not t1.value7 then
			t1.value1 = _G
		end

		t1.value2 = t1.value1.__DeathBallDash
		t1.value7 = t1.value2

		if not t1.value2 then
			t1.value6 = {}
			t1.value7 = {
				Entries = t1.value6
			}
		end

		t1.value1.__DeathBallDash = t1.value7
		value67 = t1.value5
		t1.value7 = 20116824974487
		t1.value9 = 22969448540615
		t1.value6 = "{\242˾jT\1885L\149\155x\129\160\137"
		t1.value8 = 32289304083131
		t1.value5 = t1.value1.__DeathBallDash
		t2.value134 = t1.value5
		t1.value2 = false
		t1.value1 = "\130\164\236ٴ"
		t1.value5 = {
			Running = t1.value2,
			Conn = nil,
			Guard = nil,
			GuardEnd = 0
		}
		t1.value1 = 15238838623160
		t1.value9 = "*\5\6\228t\249\211\25\247It\217"
		t1.value8 = 9722973442479
		t2.value135 = t1.value5
		t1.value7 = 24220903746574
		t1.value2 = nil
		t1.value5 = nil
		t2.value136 = t1.value5
		t2.value137 = t1.value2
		t1.value1 = "\172_\\\147\5\211\8P\22BG"
		t1.value6 = "\132\210 \203\14W\191"
		t1.value8 = "9\169Ϡ\200Q\176"
		t1.value8 = 19642970710970
		t1.value1 = "Ԇ\194)\233\164S1\174j\204\14|4\236\222"
		t1.value7 = 29990858700429
		t2.value138 = {
			"DashCooldown",
			"DashStamina",
			"Stamina",
			"IsDashOnCooldown",
			"CanDash"
		}
		t1.value2 = { "DebounceDuration" }
		t2.value139 = t1.value2
		t1.value2 = { "CooldownDuration", "IsOnCooldown" }
		t2.value140 = t1.value2
		t2.value141 = {
			DashCooldown = 0,
			DashStamina = 0,
			IsDashOnCooldown = false,
			CanDash = true,
			CooldownDuration = 0,
			IsOnCooldown = false,
			DebounceDuration = 0
		}
		t1.value8 = "2\241\180\245S7P\"\239꜕"
		t1.value6 = 17283047645040
		t1.value2 = {
			DashCooldown = 0,
			DashStamina = 0,
			IsDashOnCooldown = false,
			CanDash = true
		}
		t2.value142 = t1.value2
		t2.value143 = nil

		function t1.value6()
			if t2.value137 then
				return t2.value137
			end

			local Core = t2.value133:FindFirstChild("Core")

			if Core then
				Core = Core:FindFirstChild("Inputs")
			end

			if Core then
				Core = Core:FindFirstChild("Dash")
			end

			if not Core then
				return nil
			end

			local ok2, value137 = pcall(require, Core)

			if ok2 then
				ok2 = type(value137) == "table"
			end

			if not ok2 then
				return t2.value137
			end

			t2.value137 = value137

			return t2.value137
		end
		function t2.value143(p135)
			local kind = type(p135)

			return kind == "number" and true or kind == "boolean"
		end
		function t2.value144(p136, p137)
			local t15 = {}

			for _, v in ipairs(p137) do
				local ok2, result = pcall(function()
					return p136[v]
				end)

				if ok2 then
					ok2 = t2.value143(result)
				end

				if ok2 then
					t15[#t15 + 1] = {
						Key = v,
						Value = result
					}
				end
			end

			return t15
		end
		function t1.value8(p138, p139)
			if not (p138 and p139) then
				return
			end

			for _, v in ipairs(p139) do
				local ok2, result = pcall(function()
					return p138[v.Key]
				end)

				if ok2 then
					local ok3

					if v.Key == "Stamina" then
						local result2

						ok3, result2 = pcall(function()
							return p138.MaxStamina
						end)

						if ok3 then
							ok3 = result2 ~= nil

							if ok3 then
								ok3 = result == result2
							end
						end
					elseif t2.value141[v.Key] == nil then
						ok3 = false
					else
						ok3 = result == t2.value141[v.Key]
					end

					if ok3 then
						pcall(function()
							p138[v.Key] = v.Value
						end)
					end
				end
			end
		end
		function t1.value7(p140, p141)
			if not (p140 and p141) then
				return
			end

			for _, v in ipairs(p141) do
				pcall(function()
					p140[v.Key] = v.Value
				end)
			end
		end

		t2.value145 = t1.value7
		t2.value146 = t1.value8

		function t2.value147(p142)
			for _, entry in ipairs(t2.value134.Entries) do
				if entry.Object == p142 then
					return entry
				end
			end

			return nil
		end

		local function v695(p143, p144)
			if not p143 then
				return nil
			end

			local v696 = t2.value147(p143)

			if not v696 then
				local t16 = {
					Object = p143,
					Snap = t2.value144(p143, p144)
				}

				t2.value134.Entries[#t2.value134.Entries + 1] = t16

				return t16
			end

			local v698, v699, v700 = ipairs(v696.Snap)
			local t17 = {}

			while true do
				local v702

				v700, v702 = v698(v699, v700)

				if not v700 then
					break
				end

				t17[v702.Key] = true
			end

			for _, v in ipairs(p144) do
				if not t17[v] then
					local ok2, result = pcall(function()
						return p143[v]
					end)

					if ok2 then
						ok2 = t2.value143(result)
					end

					if ok2 then
						v696.Snap[#v696.Snap + 1] = {
							Key = v,
							Value = result
						}
					end
				end
			end

			return v696
		end

		function t2.value148(p145)
			if not p145 then
				return
			end

			local function v707()
				local v708, v709, v710 = pairs(t2.value142)

				while true do
					local v711

					v710, v711 = v708(v709, v710)

					if not v710 then
						break
					end

					if t2.value143(p145[v710]) then
						p145[v710] = v711
					end
				end

				if not t2.value143(p145.Stamina) then
					return
				end

				p145.Stamina = p145.MaxStamina or (p145.Stamina or 1)
			end

			pcall(v707)
		end
		function t2.value149()
			if t2.value136 then
				local function v712()
					return t2.value136.RootPart
				end

				local ok2, result = pcall(v712)

				if ok2 then
					if typeof(result) == "Instance" then
						ok2 = result.Parent
					else
						ok2 = false
					end
				end

				if ok2 then
					return t2.value136
				end

				t2.value136 = nil
			else
			end

			local Classes = t2.value133:FindFirstChild("Classes")

			if Classes then
				Classes = Classes:FindFirstChild("MovementHandler")
			end

			if Classes then
				local ok2, value136 = pcall(require, Classes)

				if ok2 then
					ok2 = type(value136) == "table"
				end

				if ok2 then
					local ok3, result = pcall(function()
						return value136.RootPart
					end)

					if ok3 then
						ok3 = typeof(result) == "Instance"
					end

					if ok3 then
						t2.value136 = value136

						return t2.value136
					end
				end
			end

			local getgc_ = getgc

			if type(getgc_) ~= "function" then
				return nil
			end

			local ok2, result = pcall(getgc, true)

			if ok2 then
				ok2 = type(result) == "table"
			end

			if not ok2 then
				return nil
			end

			for _, v in pairs(result) do
				if type(v) == "table" then
					local ok3, result2 = pcall(function()
						return v.RootPart
					end)
					local ok4, result3 = pcall(function()
						return v.DashCooldown
					end)

					if ok3 then
						if ok4 then
							ok4 = typeof(result2) == "Instance"

							if ok4 then
								ok4 = result2.Parent

								if ok4 then
									ok4 = type(result3) == "number"
								end
							end
						end
					else
						ok4 = ok3
					end

					if ok4 then
						t2.value136 = v

						return t2.value136
					end
				end
			end

			return nil
		end

		t2.value150 = t1.value6

		function t2.value151()
			for _, entry in ipairs(t2.value134.Entries) do
				t2.value146(entry.Object, entry.Snap)
			end
		end

		local function v733()
			local v734 = t2.value149()

			if v734 then
				v695(v734, t2.value138)
				t2.value148(v734)
			end

			local v740 = t2.value150()

			if not v740 then
				return
			end

			v695(v740, t2.value139)

			local Button = nil

			local function v741()
				Button = v740.Button
			end

			pcall(v741)

			if Button then
				v695(Button, t2.value140)

				local function v742()
					if t2.value143(Button.CooldownDuration) then
						Button.CooldownDuration = 0
					end

					if not t2.value143(Button.IsOnCooldown) then
						return
					end

					Button.IsOnCooldown = false
				end

				pcall(v742)
			end

			local function v743()
				if not t2.value143(v740.DebounceDuration) then
					return
				end

				v740.DebounceDuration = 0
			end

			pcall(v743)
		end

		t2.value151()

		function t2.value109()
			t2.value135.Running = false

			if t2.value135.Conn then
				local function v744()
					t2.value135.Conn:Disconnect()
				end

				pcall(v744)
				t2.value135.Conn = nil
			end

			if t2.value135.Guard then
				pcall(function()
					t2.value135.Guard:Disconnect()
				end)
				t2.value135.Guard = nil
			end

			t2.value135.GuardEnd = os.clock() + 2
			t2.value135.Guard = t2.value2.Heartbeat:Connect(function()
				if t2.value135.Running then
					if not t2.value135.Guard then
						return
					end

					t2.value135.Guard:Disconnect()
					t2.value135.Guard = nil
				else
					t2.value151()

					if not (os.clock() >= t2.value135.GuardEnd) then
						return
					end

					for _, entry in ipairs(t2.value134.Entries) do
						t2.value145(entry.Object, entry.Snap)
					end

					if t2.value135.Guard then
						t2.value135.Guard:Disconnect()
						t2.value135.Guard = nil
					end

					print("[Death Ball] Dash limiter off — originals restored.")
				end
			end)
		end
		function t2.value152()
			if t2.value135.Running then
				return
			end

			t2.value135.Running = true

			if t2.value135.Guard then
				local function v745()
					t2.value135.Guard:Disconnect()
				end

				pcall(v745)
				t2.value135.Guard = nil
			end

			v733()
			t2.value135.Conn = t2.value2.Heartbeat:Connect(function()
				if not t2.value135.Running or (not t2.value14.AutoDash or _G.__DBGen ~= t2.value12) then
					t2.value109()
				else
					v733()
				end
			end)
		end
		function t2.value110(p146)
			t2.value14.AutoDash = p146

			if not t2.value111 then
				if p146 then
					t2.value152()
				else
					t2.value109()
				end

				t2.value85("Infinite Dash", p146)

				return
			end

			t2.value111(p146)

			if p146 then
				t2.value152()
			else
				t2.value109()
			end

			t2.value85("Infinite Dash", p146)
		end

		if getgenv then
			getgenv().DeathBallDashDump = function()
				local v746 = t2.value149()

				if not v746 then
					print("[Death Ball] No MovementHandler found")

					return
				end

				print("[Death Ball] --- live values ---")

				local v747, v748, v749 = ipairs({
					"DashCooldown",
					"DashStamina",
					"Stamina",
					"MaxStamina",
					"IsDashOnCooldown",
					"CanDash"
				})

				while true do
					local v750

					v749, v750 = v747(v748, v749)

					if not v749 then
						break
					end

					local ok2, result = pcall(function()
						return v746[v750]
					end)
					local print_ = print
					local v751 = tostring(ok2 and result)
					local t18 = { typeof(ok2 and result) }

					print_(("[Death Ball]   %s = %s  (%s)").format("[Death Ball]   %s = %s  (%s)", v750, v751, unpack_(t18)))
				end

				print("[Death Ball] --- remembered originals ---")

				for _, entry in ipairs(t2.value134.Entries) do
					for _, v in ipairs(entry.Snap) do
						local print_ = print
						local Key = v.Key
						local t19 = { tostring(v.Value) }

						print_(("[Death Ball]   %s = %s").format("[Death Ball]   %s = %s", Key, unpack_(t19)))
					end
				end
			end
			getgenv().DeathBallDashReset = function()
				t2.value14.AutoDash = false
				t2.value109()
				t2.value134.Entries = {}
				print("[Death Ball] Dash originals forgotten — toggle the limiter on then off.")
			end
		end

		t1.value9 = 21361221740251
		t1.value1 = "FLY_STEP_NAME"
		FLY_STEP_NAME = "DeathBallFly"
		t1.value1 = {
			Running = false,
			Velocity = nil,
			Gyro = nil
		}
		t2.value153 = nil

		function t1.value7()
			if t2.value153.Velocity then
				local function v759()
					t2.value153.Velocity:Destroy()
				end

				pcall(v759)
				t2.value153.Velocity = nil
			end

			if not t2.value153.Gyro then
				return
			end

			pcall(function()
				t2.value153.Gyro:Destroy()
			end)
			t2.value153.Gyro = nil
		end
		function t1.value2()
			if t2.value153.Running then
				return
			end

			local v760 = t2.value15(t2.value7.Character)
			local RootPart

			if v760 then
				RootPart = v760.RootPart
			else
				RootPart = v760
			end

			if not (v760 and RootPart) then
				return
			end

			t2.value153.Running = true
			t2.value153.Velocity = t2.value60("BodyVelocity", {
				Name = "DeathBallFlyVelocity",
				MaxForce = Vector3.new(100000, 100000, 100000),
				P = 1250,
				Velocity = Vector3.zero,
				Parent = RootPart
			})
			t2.value153.Gyro = t2.value60("BodyGyro", {
				Name = "DeathBallFlyGyro",
				MaxTorque = Vector3.new(100000, 100000, 100000),
				P = 1250,
				D = 50,
				CFrame = RootPart.CFrame,
				Parent = RootPart
			})
			pcall(function()
				v760:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
			end)
			t2.value2:UnbindFromRenderStep(FLY_STEP_NAME)

			local value2 = t2.value2
			local FLY_STEP_NAME_ = FLY_STEP_NAME
			local Value = Enum.RenderPriority.Character.Value

			value2.BindToRenderStep(value2, FLY_STEP_NAME_, Value + 1, function()
				if not t2.value153.Running or (not t2.value14.Fly or _G.__DBGen ~= t2.value12) then
					StopFly()

					return
				end

				local Character = t2.value7.Character
				local v766 = t2.value15(Character)
				local RootPart2

				if v766 then
					RootPart2 = v766.RootPart
				else
					RootPart2 = v766
				end

				if not v766 or (not RootPart2 or v766.Health <= 0) then
					return
				end

				if t2.value153.Velocity.Parent ~= RootPart2 then
					t2.value153.Velocity.Parent = RootPart2
				end

				if t2.value153.Gyro.Parent ~= RootPart2 then
					t2.value153.Gyro.Parent = RootPart2
				end

				local CurrentCamera = workspace.CurrentCamera
				local LookVector

				if CurrentCamera then
					LookVector = CurrentCamera.CFrame.LookVector
				else
					LookVector = CurrentCamera
				end

				local LookVector2 = LookVector or RootPart2.CFrame.LookVector
				local MoveDirection = v766.MoveDirection
				local vector3 = Vector3.zero

				if not (MoveDirection.Magnitude > 0.01) then
					t2.value153.Velocity.Velocity = vector3 * t2.value14.FlySpeed
					t2.value153.Gyro.CFrame = CFrame.new(RootPart2.Position, RootPart2.Position + LookVector2)

					return
				end

				local CFrame_ = CurrentCamera and CurrentCamera.CFrame or RootPart2.CFrame

				vector3 = CFrame_.LookVector * MoveDirection.Z + CFrame_.RightVector * MoveDirection.X

				if not (vector3.Magnitude > 0.001) then
					t2.value153.Velocity.Velocity = vector3 * t2.value14.FlySpeed
					t2.value153.Gyro.CFrame = CFrame.new(RootPart2.Position, RootPart2.Position + LookVector2)

					return
				end

				vector3 = vector3.Unit
				t2.value153.Velocity.Velocity = vector3 * t2.value14.FlySpeed
				t2.value153.Gyro.CFrame = CFrame.new(RootPart2.Position, RootPart2.Position + LookVector2)
			end)
		end

		t2.value153 = t1.value1
		t2.value154 = t1.value7

		function StopFly()
			t2.value153.Running = false

			local function v774()
				t2.value2:UnbindFromRenderStep(FLY_STEP_NAME)
			end

			pcall(v774)
			t2.value154()

			local v775 = t2.value15(t2.value7.Character)

			if not v775 then
				return
			end

			pcall(function()
				v775:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
			end)
		end

		t2.value155 = t1.value2

		function SetFly(p147)
			t2.value14.Fly = p147

			if p147 then
				t2.value155()
			else
				StopFly()
			end

			t2.value85("Fly", p147)
		end

		t1.value2 = t2.value60
		t1.value9 = UDim2.new
		t1.value7 = 0
		t1.value1 = t1.value9(1, t1.value7, 0, 14)
		value67 = 1
		value8 = t2.value72()
		value8 = value8 and "Tap the logo button to hide / show this UI" or value8
		t1.value8 = value8

		if not value8 then
			t1.value8 = "Toggle Right Control to hide UI"
		end

		value8 = t2.value59.Muted
		v504 = Enum.Font.Gotham
		v495 = Enum.TextXAlignment.Center
		t1.value2("TextLabel", {
			Size = t1.value1,
			BackgroundTransparency = value67,
			Text = t1.value8,
			TextColor3 = value8,
			Font = v504,
			TextSize = 10,
			TextXAlignment = v495,
			Parent = parent
		})
		t1.value2 = t2.value60
		parent = {
			Size = UDim2.new(1, 0, 0, 72),
			BackgroundTransparency = 1,
			Parent = parent
		}
		parent = t1.value2("Frame", parent)
		t1.value2 = t2.value60
		t1.value7 = UDim.new(0, 6)
		t1.value8 = Enum.SortOrder.LayoutOrder
		t1.value2("UIListLayout", {
			Padding = t1.value7,
			SortOrder = t1.value8,
			Parent = parent
		})

		function t1.value2(p148, p149, p150, p151, _)
			local TextButton = t2.value60("TextButton", {
				Size = UDim2.new(1, 0, 0, 34),
				BackgroundColor3 = p149,
				TextColor3 = t2.value59.Text,
				Font = Enum.Font.GothamBold,
				TextSize = 13,
				Text = p148,
				AutoButtonColor = false,
				BorderSizePixel = 0,
				ClipsDescendants = true,
				Parent = p151
			})

			t2.value61(TextButton, 8)

			local v777 = t2.value62(TextButton, t2.value59.Border, 1)
			local UIStroke = t2.value60("UIStroke", {
				Color = t2.value59.Accent,
				Thickness = 1,
				Transparency = 1,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Parent = TextButton
			})
			local Size = TextButton.Size

			TextButton.MouseEnter:Connect(function()
				local t20 = {
					BackgroundColor3 = p150
				}

				t2.value5:Create(TextButton, TweenInfo.new(0.15), t20):Play()

				local value5 = t2.value5
				local v782 = v777
				local tweenInfo = TweenInfo.new(0.15)
				local value59 = t2.value59

				value5.Create(value5, v782, tweenInfo, {
					Color = value59.Accent,
					Transparency = 0
				}):Play()
				t2.value5:Create(UIStroke, TweenInfo.new(0.2), {
					Transparency = 0.55,
					Thickness = 2
				}):Play()
			end)
			TextButton.MouseLeave:Connect(function()
				local t21 = {
					BackgroundColor3 = p149
				}

				t2.value5:Create(TextButton, TweenInfo.new(0.15), t21):Play()

				local value5 = t2.value5
				local v787 = v777
				local tweenInfo = TweenInfo.new(0.15)
				local value59 = t2.value59

				value5.Create(value5, v787, tweenInfo, {
					Color = value59.Border,
					Transparency = 0
				}):Play()
				t2.value5:Create(UIStroke, TweenInfo.new(0.2), {
					Transparency = 1,
					Thickness = 1
				}):Play()
			end)
			TextButton.MouseButton1Down:Connect(function()
				local value5 = t2.value5
				local v791 = TextButton
				local tweenInfo = TweenInfo.new(0.08)
				local v793 = Size
				local UDim2_ = UDim2

				value5.Create(value5, v791, tweenInfo, {
					Size = v793 - UDim2_.new(0, 4, 0, 2)
				}):Play()
			end)
			TextButton.MouseButton1Up:Connect(function()
				local t22 = {
					Size = Size
				}

				t2.value5:Create(TextButton, TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out), t22):Play()
			end)

			return TextButton
		end

		t1.value7 = t1.value2("Unlock All Swords", t2.value59.Field, Color3.fromRGB(48, 48, 60), v1322)
		t1.value5 = t2.value60
		t1.value8 = UDim2.new
		t1.value6 = 12
		v1322 = {
			Size = t1.value8(1, 0, 0, t1.value6),
			BackgroundTransparency = 1,
			Text = "",
			TextColor3 = t2.value59.Muted,
			Font = Enum.Font.GothamMedium,
			TextSize = 10,
			TextXAlignment = Enum.TextXAlignment.Left,
			Visible = false,
			Parent = v1322
		}
		t1.value9 = t1.value5("TextLabel", v1322)
		t2.value156 = t1.value9
		t2.value157 = false
		t1.value9 = t1.value7.MouseButton1Click

		function t1.value7()
			if t2.value157 then
				return
			end

			t2.value156.Visible = true
			t2.value156.Text = "Unlocking..."
			t2.value156.TextColor3 = t2.value59.Muted
			task.spawn(function()
				local v796 = false
				local v797 = false
				local n20 = 0
				local s4 = "not run"

				for _ = 1, 15 do
					if _G.__DBGen ~= t2.value12 then
						return
					end

					v796, v797, n20, s4 = pcall(unlockAllSwords)

					if v796 and v797 then
						if v796 and v797 then
							if n20 > 0 then
								t2.value156.Text = "Unlocked +" .. tostring(n20) .. " swords"
								t2.value83("All swords unlocked")
							else
								t2.value156.Text = "Already unlocked"
							end

							t2.value156.TextColor3 = t2.value59.Green
							print("[Death Ball] Unlock All Swords: +" .. tostring(n20))
						else
							t2.value156.Text = "Failed — " .. tostring(s4)
							t2.value156.TextColor3 = Color3.fromRGB(232, 92, 92)
							warn("[Death Ball] Unlock All Swords: " .. tostring(s4))
						end

						return
					end

					task.wait(1)
				end

				if v796 and v797 then
					if n20 > 0 then
						t2.value156.Text = "Unlocked +" .. tostring(n20) .. " swords"
						t2.value83("All swords unlocked")
					else
						t2.value156.Text = "Already unlocked"
					end

					t2.value156.TextColor3 = t2.value59.Green
					print("[Death Ball] Unlock All Swords: +" .. tostring(n20))
				else
					t2.value156.Text = "Failed — " .. tostring(s4)
					t2.value156.TextColor3 = Color3.fromRGB(232, 92, 92)
					warn("[Death Ball] Unlock All Swords: " .. tostring(s4))
				end
			end)
		end

		t1.value9:Connect(t1.value7)
		t1.value7 = t2.value59.Field
		t1.value8 = Color3.fromRGB
		t1.value9 = t1.value2("Join Discord", t1.value7, t1.value8(48, 48, 60))
		t1.value9.Parent = parent

		local function v801(p152)
			local setclipboard_ = setclipboard or (toclipboard or writeclipboard)

			return type(setclipboard_) == "function" and pcall(setclipboard_, p152) and true or pcall(function()
				game:GetService("StarterGui"):SetCore("SetClipboard", p152)
			end)
		end

		t1.value7 = t1.value9.MouseButton1Click
		t1.value7:Connect(function()
			local v803 = v801(t2.value14.DiscordURL)

			t2.value83(v803 and "Discord link copied to clipboard" or "Copy failed — link: " .. t2.value14.DiscordURL)
			print("[SENTENAL Z - DEATH BALL] Discord copy success:", v803)
		end)
		t1.value7 = t1.value2("Unload UI", t2.value59.Field, Color3.fromRGB(48, 48, 60))
		t1.value2 = nil
		t1.value6 = "\236\224b])\20B*vV[\152Kk\230\20Q"
		t1.value7.Parent = parent
		t1.value7.MouseButton1Click:Connect(function()
			t2.value34()
			t2.value52()
			t2.value30()
			t2.value109()
			StopFly()
			t2.value2:UnbindFromRenderStep(t2.value32)
			t2.value2:UnbindFromRenderStep(t2.value43)
			t2.value2:UnbindFromRenderStep(FLY_STEP_NAME)

			if t2.value105 then
				t2.value105:Disconnect()
			end

			if t2.value108 then
				t2.value108:Disconnect()
			end

			for _, v in ipairs(t2.value13) do
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

			if t2.value82 then
				local function v807()
					t2.value82:Destroy()
				end

				pcall(v807)
				t2.value82 = nil
			end

			local __DeathBallAutoParry2 = _G.__DeathBallAutoParry

			if __DeathBallAutoParry2 then
				__DeathBallAutoParry2 = _G.__DeathBallAutoParry.NotifGui
			end

			if __DeathBallAutoParry2 then
				pcall(function()
					_G.__DeathBallAutoParry.NotifGui:Destroy()
				end)
			end

			if not t2.value65 then
				_G.__DeathBallAutoParry = nil
				print("[SENTENAL Z - DEATH BALL] Unloaded.")

				return
			end

			local function v809()
				t2.value65:Destroy()
			end

			pcall(v809)
			t2.value65 = nil
			_G.__DeathBallAutoParry = nil
			print("[SENTENAL Z - DEATH BALL] Unloaded.")
		end)
		t2.value84.SetAutoParryVisual = ok
		t2.value84.SetSpamVisual = value13
		t2.value84.SetAIMoveVisual = t1.value4
		t1.value2 = t2.value84
		t1.value7 = value1
		t1.value1 = "\214\225\17,1\183#\154!Myx\250\242\146"
		t1.value2.SetAutoReadyVisual = t1.value7
		t2.value84.SetCameraVisual = t1.value3
		v128(t2.value64, TitleBar)
		t2.value158 = false

		function t1.value9()
			local ipairs_ = ipairs
			local value102 = t2.value102
			local v812, v813, v814 = ipairs_(value102.GetDescendants(value102))
			local t23 = {
				Objects = {},
				Positions = {}
			}

			while true do
				local v816

				v814, v816 = v812(v813, v814)

				if not v814 then
					break
				end

				local t24 = {}
				local isGuiObject = v816:IsA("GuiObject")

				if isGuiObject then
					t24.BackgroundTransparency = v816.BackgroundTransparency
					isGuiObject = "BackgroundTransparency"
				end

				if v816:IsA("TextLabel") or (v816:IsA("TextButton") or v816:IsA("TextBox")) then
					t24.TextTransparency = v816.TextTransparency
					t24.TextStrokeTransparency = v816.TextStrokeTransparency
				end

				if v816:IsA("ImageLabel") or v816:IsA("ImageButton") then
					t24.ImageTransparency = v816.ImageTransparency
				end

				if v816:IsA("ScrollingFrame") then
					t24.ScrollBarImageTransparency = v816.ScrollBarImageTransparency
				end

				if v816:IsA("UIStroke") then
					t24.Transparency = v816.Transparency
				end

				if next(t24) then
					t23.Objects[v816] = t24
				end
			end

			local ipairs_2 = ipairs
			local value1022 = t2.value102

			for _, child in ipairs_2(value1022.GetChildren(value1022)) do
				if child:IsA("GuiObject") then
					t23.Positions[child] = child.Position
				end
			end

			return t23
		end

		t2.value159 = false
		t2.value160 = nil
		t2.value161 = t1.value9

		function t1.value1(p153)
			if t2.value159 or t2.value158 == p153 then
			elseif p153 then
				t2.value160 = t2.value161()

				local v823 = nil

				for k, object in pairs(t2.value160.Objects) do
					if k.Parent then
						local v826, v827, v828 = pairs(object)
						local t25 = {}

						while true do
							v828 = v826(v827, v828)

							if not v828 then
								break
							end

							t25[v828] = 1
						end

						if t2.value160.Positions[k] then
							t25.Position = t2.value160.Positions[k] + UDim2.new(0, 0, 0, 40)
						end

						local tween = t2.value5:Create(k, TweenInfo.new(0.24, Enum.EasingStyle.Quad, Enum.EasingDirection.In), t25)

						if k == t2.value64 then
							v823 = tween
						end

						tween:Play()
					end
				end

				if not v823 then
					t2.value102.Enabled = false
					t2.value158 = true

					return
				end

				v823.Completed:Wait()
				t2.value102.Enabled = false
				t2.value158 = true

				return
			else
				t2.value102.Enabled = true

				local v831 = nil

				for k, v in pairs(t2.value160 and t2.value160.Objects or {}) do
					if k.Parent then
						local v834, v835, v836 = pairs(v)
						local t26 = {}
						local t27 = {}

						while true do
							local v839

							v836, v839 = v834(v835, v836)

							if not v836 then
								break
							end

							t26[v836] = 1
							t27[v836] = v839
						end

						if t2.value160.Positions[k] then
							local v840 = t2.value160.Positions[k]

							k.Position = v840 + UDim2.new(0, 0, 0, 40)
							t27.Position = v840
						end

						for k2, v2 in pairs(t26) do
							k[k2] = v2
						end

						local tween = t2.value5:Create(k, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), t27)

						if k == t2.value64 then
							v831 = tween
						end

						tween:Play()
					end
				end

				if not v831 then
					t2.value158 = false

					return
				end

				v831.Completed:Wait()
				t2.value158 = false

				return
			end
		end

		t2.value162 = t1.value1
		t1.value1 = t2.value60
		v1322 = {
			Name = "DeathBallToggle",
			ResetOnSpawn = false,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			IgnoreGuiInset = true,
			DisplayOrder = 9
		}
		t2.value65 = t1.value1("ScreenGui", v1322)
		v1322, parent = pcall(function()
			return gethui()
		end)
		t1.value1 = t2.value65
		v1322 = v1322 and parent and parent or game:GetService("CoreGui")
		t1.value1.Parent = v1322
		t2.value163 = 56
		t1.value1 = t2.value60
		v1322 = UDim2.new(0, 46, 0, 46)
		parent = UDim2.new(0, 12, 0, t2.value163)
		value67 = t2.value59.Section
		t2.value164 = t1.value1("TextButton", {
			Name = "ToggleBtn",
			Size = v1322,
			Position = parent,
			BackgroundColor3 = value67,
			BackgroundTransparency = 0.1,
			Text = "",
			AutoButtonColor = false,
			BorderSizePixel = 0,
			Parent = t2.value65
		})
		t2.value61(t2.value164, 23)
		t2.value165 = t2.value62(t2.value164, t2.value59.Border, 1)
		t2.value60("ImageLabel", {
			Size = UDim2.new(0, 26, 0, 26),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Image = "rbxassetid://84154329190977",
			ScaleType = Enum.ScaleType.Fit,
			Parent = t2.value164
		})
		t2.value166 = false
		t2.value167 = false
		t2.value168 = nil
		t2.value169 = nil

		function t2.value170()
			if t2.value166 then
				return
			end

			local AbsoluteSize = t2.value164.AbsoluteSize

			if AbsoluteSize.X <= 0 and true or AbsoluteSize.Y <= 0 then
				return
			end

			local v845 = t2.value70()
			local v846 = v845.X - AbsoluteSize.X
			local v847 = math.max(v846, 0)
			local v848 = v845.Y - AbsoluteSize.Y
			local v849 = math.max(v848, 0)
			local Offset = t2.value164.Position.X.Offset
			local v851 = math.clamp(Offset, 0, v847)
			local Offset2 = t2.value164.Position.Y.Offset
			local v853 = math.clamp(Offset2, 0, v849)

			if not (v851 ~= t2.value164.Position.X.Offset and true or v853 ~= t2.value164.Position.Y.Offset) then
				return
			end

			t2.value164.Position = UDim2.new(0, v851, 0, v853)
		end

		t2.value164.InputBegan:Connect(function(input)
			if not (input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch) then
				return
			end

			t2.value166 = true
			t2.value167 = false
			t2.value168 = input.Position
			t2.value169 = t2.value164.Position
			t2.value165.Color = t2.value59.Accent
			t2.value165.Transparency = 0
			input.Changed:Connect(function()
				if input.UserInputState ~= Enum.UserInputState.End then
					return
				end

				t2.value166 = false
				t2.value165.Color = t2.value59.Border
				t2.value165.Transparency = 0
			end)
		end)
		t2.value13[#t2.value13 + 1] = t2.value3.InputChanged:Connect(function(input)
			if not t2.value166 then
				return
			end

			if not (input.UserInputType == Enum.UserInputType.MouseMovement and true or input.UserInputType == Enum.UserInputType.Touch) then
				return
			end

			local v854 = input.Position - t2.value168

			if v854.Magnitude > 6 then
				t2.value167 = true
			end

			local AbsoluteSize = t2.value164.AbsoluteSize
			local v856 = t2.value70()
			local v857 = v856.X - AbsoluteSize.X
			local v858 = math.max(v857, 0)
			local v859 = v856.Y - AbsoluteSize.Y
			local v860 = math.max(v859, 0)
			local v861 = t2.value169.X.Offset + v854.X
			local v862 = math.clamp(v861, 0, v858)
			local v863 = t2.value169.Y.Offset + v854.Y
			local v864 = math.clamp(v863, 0, v860)

			t2.value164.Position = UDim2.new(0, v862, 0, v864)
		end)
		t2.value164.MouseButton1Click:Connect(function()
			if not t2.value167 then
				t2.value162(not t2.value158)
			end
		end)
		t2.value171 = -1

		function t2.value76()
			local v865 = t2.value71()
			local value163 = t2.value163
			local v867 = math.max(v865, value163)

			if v867 == t2.value171 then
				t2.value170()

				return
			end

			local value171 = t2.value171

			if value171 < 0 then
				t2.value164.Position = UDim2.new(0, 12, 0, v867)
			else
				local v869 = v867 - value171

				if v869 == 0 then
					t2.value170()

					return
				end

				t2.value164.Position = t2.value164.Position + UDim2.new(0, 0, 0, v869)
			end

			t2.value170()
		end

		t2.value76()
		t2.value172 = {
			Enabled = true,
			Key = "Sentenal_Key_7A51_U095_978R_3G10",
			API = nil,
			SaveKey = true,
			Remember = true
		}
		t2.value172.DiscordURL = t2.value14.DiscordURL
		t2.value172.Logo = "rbxassetid://84154329190977"
		t2.value172.Title = "SENTENAL Z"
		t2.value172.Subtitle = "DEATH BALL"
		t2.value172.Version = "1.15v"
		t2.value173 = "SentenalZ_DeathBall_Key.txt"
		t2.value174 = "SentenalZ_DeathBall_KeySig.txt"

		local function v870()
			local Version = t2.value172.Version or ""

			return tostring(Version) .. "|" .. tostring(t2.value172.Key or "")
		end

		function t2.value175(p154)
			if not t2.value172.SaveKey then
				return
			end

			local writefile_ = writefile or write_file

			if not writefile_ then
				return
			end

			pcall(writefile_, t2.value173, p154)

			local v873 = v870

			pcall(writefile_, t2.value174, v873())
		end
		function t2.value176()
			if not t2.value172.SaveKey then
				return
			end

			local readfile_ = readfile or read_file

			if not readfile_ then
				return
			end

			local ok2, result = pcall(readfile_, t2.value173)
			local ok3, result2 = pcall(readfile_, t2.value174)

			if not ok2 then
				return ok2 and result or nil, ok3 and result2 and result2 or nil
			end

			if result then
				ok2 = result ~= ""
			else
				ok2 = result
			end

			return ok2 and result or nil, ok3 and result2 and result2 or nil
		end
		function t2.value177(p155)
			if not t2.value172.Enabled then
				return true, "Key system disabled"
			end

			if not p155 or p155 == "" then
				return false, "Enter a key"
			end

			local Key = t2.value172.Key

			if Key then
				Key = p155 == t2.value172.Key
			end

			if Key then
				return true, "Key valid"
			end

			local API = t2.value172.API

			if API then
				API = t2.value172.API ~= ""
			end

			if not API then
				return false, "Invalid key"
			end

			local function v881()
				return game:HttpGet(t2.value172.API .. "?key=" .. p155)
			end

			local ok2, result = pcall(v881)

			if ok2 and result then
				local v884 = string.lower(result)

				if v884:find("valid") or (v884:find("true") or v884:find("success")) then
					return true, "Key valid"
				else
					return false, "Invalid key"
				end
			else
				return false, "Invalid key"
			end
		end
		function t2.value178(p156)
			local t28 = {
				value1 = p156
			}

			task.spawn(function()
				local ScreenGui = t2.value60("ScreenGui", {
					Name = "SentenalZ_Loading",
					ResetOnSpawn = false,
					ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
					IgnoreGuiInset = true,
					DisplayOrder = 100
				})
				local ok2, result = pcall(function()
					return gethui()
				end)

				ScreenGui.Parent = ok2 and result and result or game:GetService("CoreGui")

				local Frame = t2.value60("Frame", {
					Size = UDim2.new(0, 260, 0, 220),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = t2.value59.Bg,
					BorderSizePixel = 0,
					Parent = ScreenGui
				})

				t2.value61(Frame, 12)
				t2.value75(ScreenGui, 300, 260, { Frame })

				local _, _, v892 = v318(Frame, 1.5)
				local n21 = 72
				local Frame2 = t2.value60("Frame", {
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
					Parent = Frame
				})
				local Frame3 = t2.value60("Frame", {
					Size = UDim2.new(0, n21, 0, n21),
					Position = UDim2.new(0.5, 0, 0, 28),
					AnchorPoint = Vector2.new(0.5, 0),
					BackgroundTransparency = 1,
					Parent = Frame2
				})

				t2.value61(Frame3, n21 / 2)
				t2.value60("UIStroke", {
					Color = t2.value59.Field,
					Thickness = 4,
					Parent = Frame3
				})

				local Frame4 = t2.value60("Frame", {
					Size = UDim2.new(0, n21, 0, n21),
					Position = UDim2.new(0.5, 0, 0, 28),
					AnchorPoint = Vector2.new(0.5, 0),
					BackgroundTransparency = 1,
					Parent = Frame2
				})

				t2.value61(Frame4, n21 / 2)

				local UIStroke = t2.value60("UIStroke", {
					Color = t2.value59.Accent,
					Thickness = 4,
					LineJoinMode = Enum.LineJoinMode.Round,
					Parent = Frame4
				})

				t2.value60("UIGradient", {
					Rotation = 0,
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 0),
						NumberSequenceKeypoint.new(0.55, 0),
						NumberSequenceKeypoint.new(0.75, 1),
						NumberSequenceKeypoint.new(1, 1)
					}),
					Parent = UIStroke
				})

				local connection = t2.value2.RenderStepped:Connect(function(dt)
					local Parent = Frame4

					if Parent then
						Parent = Frame4.Parent
					end

					if not Parent then
						return
					end

					Frame4.Rotation = (Frame4.Rotation + dt * 260) % 360
				end)

				t2.value60("TextLabel", {
					Size = UDim2.new(1, 0, 0, 30),
					Position = UDim2.new(0, 0, 0, 116),
					BackgroundTransparency = 1,
					Text = "Loading Sentenal Z",
					TextColor3 = t2.value59.Text,
					Font = Enum.Font.GothamBold,
					TextSize = 22,
					Parent = Frame2
				})
				t2.value60("TextLabel", {
					Size = UDim2.new(1, 0, 0, 14),
					Position = UDim2.new(0, 0, 0, 146),
					BackgroundTransparency = 1,
					Text = t2.value172.Version .. "  ·  " .. t2.value172.Subtitle,
					TextColor3 = t2.value59.Muted,
					Font = Enum.Font.GothamMedium,
					TextSize = 11,
					Parent = Frame2
				})

				local Frame5 = t2.value60("Frame", {
					Size = UDim2.new(1, -50, 0, 6),
					Position = UDim2.new(0.5, 0, 0, 170),
					AnchorPoint = Vector2.new(0.5, 0),
					BackgroundColor3 = t2.value59.Field,
					BorderSizePixel = 0,
					Parent = Frame2
				})

				t2.value61(Frame5, 3)

				local Frame6 = t2.value60("Frame", {
					Size = UDim2.new(0, 0, 1, 0),
					BackgroundColor3 = t2.value59.Accent,
					BorderSizePixel = 0,
					Parent = Frame5
				})

				t2.value61(Frame6, 3)

				local TextLabel = t2.value60("TextLabel", {
					Size = UDim2.new(1, -50, 0, 14),
					Position = UDim2.new(0.5, 0, 0, 182),
					AnchorPoint = Vector2.new(0.5, 0),
					BackgroundTransparency = 1,
					Text = "0%",
					TextColor3 = t2.value59.Muted,
					Font = Enum.Font.GothamMedium,
					TextSize = 11,
					Parent = Frame2
				})
				local n22 = 1
				local v904 = math.random(5, 9)
				local v905 = n22 < 0
				local v906 = 1 - n22
				local v907 = v904

				local function v908(p157, p158)
					return p157 + math.random() * (p158 - p157)
				end

				local t29 = {}
				local n23 = 0

				while true do
					v906 = v906 + n22

					local v911 = not v905

					if v911 then
						v911 = v906 <= v904
					end

					if (not v905 or v904 > v906) and not v911 then
						local n24 = 0
						local n25 = 0
						local connection2 = t2.value2.RenderStepped:Connect(function(dt)
							if Frame6 and Frame6.Parent then
								local v915 = n24
								local v916 = n25 - n24
								local v917 = dt * 9

								n24 = v915 + v916 * math.min(v917, 1)
								Frame6.Size = UDim2.new(n24, 0, 1, 0)

								local v918 = TextLabel
								local format = string.format
								local v920 = n24 * 100 + 0.5

								v918.Text = format("%d%%", (math.floor(v920)))
							end
						end)
						local ipairs_ = ipairs

						for _, v in ipairs_(t29) do
							ipairs_ = v[1]
							n25 = ipairs_
							task.wait(v[2])

							if v[3] > 0 then
								task.wait(v[3])
							end
						end

						n25 = 1
						task.wait(0.35)

						local value5 = t2.value5
						local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
						local Position = Frame.Position
						local uDim22 = UDim2.new(0, 0, 0, 60)
						local v928 = value5.Create(value5, Frame, tweenInfo, {
							Position = Position + uDim22,
							BackgroundTransparency = 1
						})
						local GetDescendants = Frame.GetDescendants

						v928:Play()

						for _, v in ipairs(GetDescendants(Frame)) do
							if v:IsA("TextLabel") or (v:IsA("TextButton") or v:IsA("TextBox")) then
								t2.value5:Create(v, TweenInfo.new(0.3), {
									TextTransparency = 1
								}):Play()
							elseif v:IsA("ImageLabel") or v:IsA("ImageButton") then
								local value52 = t2.value5
								local tweenInfoNew = TweenInfo.new

								value52.Create(value52, v, tweenInfoNew(0.3), {
									ImageTransparency = 1
								}):Play()
							elseif v:IsA("Frame") then
								local value52 = t2.value5
								local tweenInfoNew = TweenInfo.new

								value52.Create(value52, v, tweenInfoNew(0.3), {
									BackgroundTransparency = 1
								}):Play()
							elseif v:IsA("UIStroke") then
								local value52 = t2.value5
								local tweenInfo2 = TweenInfo.new(0.3)

								value52.Create(value52, v, tweenInfo2, {
									Transparency = 1
								}):Play()
							end
						end

						v928.Completed:Wait()

						if connection then
							connection:Disconnect()
						end

						if connection2 then
							connection2:Disconnect()
						end

						if v892 then
							v892:Disconnect()
						end

						ScreenGui:Destroy()

						if not t28.value1 then
							return
						end

						t28.value1()

						return
					end

					local v938 = v906 == v907
					local v939 = nil
					local v940

					if v938 then
						v940 = 1 - n23
						v939 = v940
					elseif math.random() < 0.25 then
						v940 = v908(0.18, 0.32)
					else
						v940 = v908(0.06, 0.16)
					end

					local v941 = n23 + v940

					n23 = math.min(v941, v938 and 1 or 0.97)

					local v942 = not v938
					local v943 = v908(0.12, 0.3) + v940 * 0.6
					local n26 = 0

					if v942 then
						v942 = math.random() < 0.55
					end

					if v942 then
						local v945

						if math.random() < 0.25 then
							v945 = v908(0.45, 0.85)
						else
							v945 = false
						end

						n26 = v945 or v908(0.12, 0.35)
					end

					table.insert(t29, { n23, v943, n26 })
				end
			end)
		end

		t2.value179 = {
			{
				field = "AutoParryKey",
				label = "Auto Parry"
			},
			{
				field = "AutoSpamKey",
				label = "Auto Spam"
			},
			{
				field = "AIMovementKey",
				label = "AI Movement"
			},
			{
				field = "CameraRotationKey",
				label = "Camera Rotation"
			},
			{
				field = "AutoReadyKey",
				label = "Auto Ready"
			},
			{
				field = "AutoDashKey",
				label = "Infinite Dash"
			}
		}

		local function v946(p159, p160)
			local v947, v948, v949 = ipairs(t2.value179)

			while true do
				local v950

				v949, v950 = v947(v948, v949)

				if not v949 then
					break
				end

				local v951

				if v950.field == p160 then
					v951 = false
				else
					v951 = t2.value14[v950.field] == p159
				end

				if v951 then
					return v950.label
				end
			end

			return nil
		end

		t2.value180 = false
		t2.value13[#t2.value13 + 1] = t2.value3.InputBegan:Connect(function(input, gameProcessed)
			if not t2.value180 then
				return
			end

			local value99 = t2.value99

			if value99 then
				value99 = input.UserInputType == Enum.UserInputType.Keyboard
			end

			if value99 then
				local value992 = t2.value99
				local KeyCode = input.KeyCode
				local v955

				if KeyCode == Enum.KeyCode.Backspace or (KeyCode == Enum.KeyCode.Delete and true or KeyCode == Enum.KeyCode.Escape) then
					value992.set(nil)
				else
					if KeyCode == Enum.KeyCode.Unknown then
						value992.render()
						v1085 = print
						v1086 = "[Death Ball] Keybind set to: "

						if value992.box.Text == "" then
							v955 = false
						else
							v955 = value992.box.Text
						end

						v1085(v1086 .. (v955 or "None"))

						return
					end

					local v956 = v946(KeyCode, value992.field)

					if v956 then
						t2.value83(KeyCode.Name .. " is already registered to " .. v956)
					else
						value992.set(KeyCode)
					end
				end

				value992.render()

				local print_ = print
				local s5 = "[Death Ball] Keybind set to: "

				if value992.box.Text == "" then
					v955 = false
				else
					v955 = value992.box.Text
				end

				print_(s5 .. (v955 or "None"))

				return
			end

			if input.UserInputType ~= Enum.UserInputType.Keyboard then
				return
			end

			if input.KeyCode == t2.value14.UIHideKey then
				t2.value162(not t2.value158)

				return
			end

			if gameProcessed then
				gameProcessed = t2.value3:GetFocusedTextBox()
			end

			if gameProcessed then
				return
			end

			local AutoParryKey = t2.value14.AutoParryKey

			if AutoParryKey then
				AutoParryKey = input.KeyCode == t2.value14.AutoParryKey
			end

			if AutoParryKey then
				t2.value86(not t2.value14.AutoParry)
				print("[Death Ball] Auto Parry:", t2.value14.AutoParry and "ON" or "OFF")

				return
			end

			local AutoSpamKey = t2.value14.AutoSpamKey

			if AutoSpamKey then
				AutoSpamKey = input.KeyCode == t2.value14.AutoSpamKey
			end

			if AutoSpamKey then
				t2.value87(not t2.value14.AutoSpam)
				print("[Death Ball] Auto Spam:", t2.value14.AutoSpam and "ON" or "OFF")

				return
			end

			local AIMovementKey = t2.value14.AIMovementKey

			if AIMovementKey then
				AIMovementKey = input.KeyCode == t2.value14.AIMovementKey
			end

			if AIMovementKey then
				t2.value88(not t2.value14.AIMovement)
				print("[Death Ball] AI Movement:", t2.value14.AIMovement and "ON" or "OFF")

				return
			end

			local CameraRotationKey = t2.value14.CameraRotationKey

			if CameraRotationKey then
				CameraRotationKey = input.KeyCode == t2.value14.CameraRotationKey
			end

			if CameraRotationKey then
				t2.value90(not t2.value14.CameraRotation)
				print("[Death Ball] Camera Rotation:", t2.value14.CameraRotation and "ON" or "OFF")

				return
			end

			local AutoReadyKey = t2.value14.AutoReadyKey

			if AutoReadyKey then
				AutoReadyKey = input.KeyCode == t2.value14.AutoReadyKey
			end

			if AutoReadyKey then
				t2.value89(not t2.value14.AutoReady)
				print("[Death Ball] Auto Ready:", t2.value14.AutoReady and "ON" or "OFF")

				return
			end

			local AutoDashKey = t2.value14.AutoDashKey

			if AutoDashKey then
				AutoDashKey = input.KeyCode == t2.value14.AutoDashKey
			end

			if AutoDashKey then
				t2.value110(not t2.value14.AutoDash)
				print("[Death Ball] Infinite Dash:", t2.value14.AutoDash and "ON" or "OFF")

				return
			end

			local FlyKey = t2.value14.FlyKey

			if FlyKey then
				FlyKey = input.KeyCode == t2.value14.FlyKey
			end

			if not FlyKey then
				return
			end

			SetFly(not t2.value14.Fly)
			print("[Death Ball] Fly:", t2.value14.Fly and "ON" or "OFF")
		end);
		(function(p161)
			if not t2.value172.Enabled then
				if not p161 then
					return
				end

				p161()

				return
			end

			local Remember = t2.value172.Remember

			if Remember then
				Remember = t2.value172.SaveKey
			end

			if Remember then
				local v967, v968 = t2.value176()
				local v969

				if v967 then
					v969 = v967 ~= ""
				else
					v969 = v967
				end

				if v969 then
					local Version = t2.value172.Version or ""
					local v971 = v968 == tostring(Version) .. "|" .. tostring(t2.value172.Key or "")

					if t2.value177(v967) and v971 then
						print("[SENTENAL Z - DEATH BALL] Saved key detected — skipping key system.")

						local function v972()
							t2.value64.Visible = true

							if not p161 then
								return
							end

							p161()
						end

						t2.value178(v972)

						return
					end

					if not v971 then
						print("[SENTENAL Z - DEATH BALL] Key changed — key system forced.")
					end
				end
			end

			if _G.__SentenalZKeySystem then
				local __SentenalZKeySystem = _G.__SentenalZKeySystem
				local v974, v975, v976 = ipairs(__SentenalZKeySystem.Connections or {})

				while true do
					local v977

					v976, v977 = v974(v975, v976)

					if not v976 then
						break
					end

					pcall(function()
						v977:Disconnect()
					end)
				end

				if __SentenalZKeySystem.Gui then
					pcall(function()
						__SentenalZKeySystem.Gui:Destroy()
					end)
				end

				_G.__SentenalZKeySystem = nil
			end

			local t30 = {}

			_G.__SentenalZKeySystem = {
				Connections = t30,
				Gui = nil
			}

			local ScreenGui = t2.value60("ScreenGui", {
				Name = "SentenalZ_KeySystem",
				ResetOnSpawn = false,
				ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
				IgnoreGuiInset = true,
				DisplayOrder = 100
			})
			local ok2, result = pcall(function()
				return gethui()
			end)

			ScreenGui.Parent = ok2 and result and result or game:GetService("CoreGui")
			_G.__SentenalZKeySystem.Gui = ScreenGui
			t2.value60("Frame", {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 0.45,
				BorderSizePixel = 0,
				Parent = ScreenGui
			})

			local Frame = t2.value60("Frame", {
				Name = "ParticleHolder",
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				ZIndex = 1,
				Parent = ScreenGui
			})
			local n27 = 1
			local v984 = n27 < 0
			local v985 = 1 - n27
			local n28 = 26
			local t31 = {}

			while true do
				v985 = v985 + n27

				local v988 = not v984

				if v988 then
					v988 = v985 <= n28
				end

				if (not v984 or n28 > v985) and not v988 then
					local connection = t2.value2.RenderStepped:Connect(function(dt)
						if Frame and Frame.Parent then
							local now = os.clock()

							for _, v in ipairs(t31) do
								local Frame2 = v.Frame
								local Parent

								if Frame2 then
									Parent = Frame2.Parent
								else
									Parent = Frame2
								end

								if Parent then
									local v995 = Frame2.Position.Y.Scale - v.Speed * dt * 60

									if v995 < -0.05 then
										v.BaseX = math.random()
										Frame2.Position = UDim2.new(v.BaseX, 0, 1.05, 0)
									else
										local v996 = now * 1.4 + v.Phase
										local v997 = math.sin(v996) * 0.006

										Frame2.Position = UDim2.new(v.BaseX + v997, 0, v995, 0)
									end
								end
							end
						end
					end)

					t2.value13[#t2.value13 + 1] = connection

					local Frame2 = t2.value60("Frame", {
						Name = "Card",
						Size = t2.value8,
						Position = UDim2.new(0.5, 0, 0.5, 0),
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundColor3 = t2.value59.Bg,
						BorderSizePixel = 0,
						Active = true,
						Parent = ScreenGui
					})

					t2.value61(Frame2, 12)
					t2.value75(ScreenGui, 340, 520, { Frame2 })

					local _, _, v1001 = v318(Frame2, 1.5)

					t2.value13[#t2.value13 + 1] = v1001
					Frame2.Size = t2.value8 - UDim2.new(0, 40, 0, 40)
					Frame2.BackgroundTransparency = 1
					task.spawn(function()
						t2.value5:Create(Frame2, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
							Size = t2.value8,
							BackgroundTransparency = 0
						}):Play()
					end)

					local Frame3 = t2.value60("Frame", {
						Name = "DragBar",
						Size = UDim2.new(1, 0, 0, 34),
						Position = UDim2.new(0, 0, 0, 0),
						BackgroundTransparency = 1,
						Active = true,
						Parent = Frame2
					})
					local TextButton = t2.value60("TextButton", {
						Name = "CloseBtn",
						Size = UDim2.new(0, 26, 0, 26),
						Position = UDim2.new(1, -10, 0, 10),
						AnchorPoint = Vector2.new(1, 0),
						BackgroundColor3 = t2.value59.Field,
						BackgroundTransparency = 1,
						Text = "",
						AutoButtonColor = false,
						BorderSizePixel = 0,
						ZIndex = 5,
						Parent = Frame2
					})

					t2.value61(TextButton, 6)
					t2.value60("ImageLabel", {
						Name = "CloseIcon",
						Size = UDim2.new(0, 25, 0, 25),
						Position = UDim2.new(0.5, 0, 0.5, 0),
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundTransparency = 1,
						Image = "rbxassetid://6031091004",
						ImageColor3 = t2.value59.Muted,
						ScaleType = Enum.ScaleType.Fit,
						ZIndex = 6,
						Parent = TextButton
					})

					local u1004 = nil
					local Position = nil
					local Position2 = nil

					Frame3.InputBegan:Connect(function(input)
						if not (input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch) then
							return
						end

						u1004 = true
						Position = input.Position
						Position2 = Frame2.Position
						input.Changed:Connect(function()
							if input.UserInputState ~= Enum.UserInputState.End then
								return
							end

							u1004 = false
						end)
					end)
					t2.value13[#t2.value13 + 1] = t2.value3.InputChanged:Connect(function(input)
						if not u1004 then
							return
						end

						if not (input.UserInputType == Enum.UserInputType.MouseMovement and true or input.UserInputType == Enum.UserInputType.Touch) then
							return
						end

						local v1007 = input.Position - Position
						local v1008 = t2.value73(Frame2)

						Frame2.Position = UDim2.new(Position2.X.Scale, Position2.X.Offset + v1007.X / v1008, Position2.Y.Scale, Position2.Y.Offset + v1007.Y / v1008)
					end)

					local ImageLabel = t2.value60("ImageLabel", {
						Name = "LogoGlow",
						Size = UDim2.new(0, 96, 0, 96),
						Position = UDim2.new(0.5, 0, 0, 29),
						AnchorPoint = Vector2.new(0.5, 0),
						BackgroundTransparency = 1,
						Image = t2.value172.Logo,
						ImageColor3 = t2.value59.Accent,
						ImageTransparency = 0.55,
						ScaleType = Enum.ScaleType.Fit,
						ZIndex = 1,
						Parent = Frame2
					})
					local ImageLabel2 = t2.value60("ImageLabel", {
						Name = "Logo",
						Size = UDim2.new(0, 74, 0, 74),
						Position = UDim2.new(0.5, 0, 0, 40),
						AnchorPoint = Vector2.new(0.5, 0),
						BackgroundTransparency = 1,
						Image = t2.value172.Logo,
						ScaleType = Enum.ScaleType.Fit,
						ZIndex = 2,
						Parent = Frame2
					})
					local connection2 = t2.value2.RenderStepped:Connect(function()
						if ImageLabel2 and ImageLabel2.Parent then
							local now = os.clock()
							local v1013 = math.sin(now * 1.8) * 4

							ImageLabel2.Position = UDim2.new(0.5, 0, 0, 40 + v1013)
							ImageLabel.Position = UDim2.new(0.5, 0, 0, 29 + v1013)

							local v1014 = ImageLabel
							local v1015 = now * 1.8

							v1014.ImageTransparency = 0.45 + math.sin(v1015) * 0.15

							local v1016 = ImageLabel
							local uDim2New = UDim2.new
							local v1018 = now * 1.8
							local v1019 = math.sin(v1018) * 6 + 96
							local v1020 = now * 1.8

							v1016.Size = uDim2New(0, v1019, 0, math.sin(v1020) * 6 + 96)
						end
					end)

					t2.value13[#t2.value13 + 1] = connection2
					t2.value60("TextLabel", {
						Size = UDim2.new(1, 0, 0, 26),
						Position = UDim2.new(0, 0, 0, 122),
						BackgroundTransparency = 1,
						Text = t2.value172.Title .. " — " .. t2.value172.Subtitle,
						TextColor3 = t2.value59.Text,
						Font = Enum.Font.GothamBold,
						TextSize = 20,
						Parent = Frame2
					})
					t2.value60("TextLabel", {
						Size = UDim2.new(1, 0, 0, 16),
						Position = UDim2.new(0, 0, 0, 148),
						BackgroundTransparency = 1,
						Text = "KEY SYSTEM · " .. t2.value172.Version,
						TextColor3 = t2.value59.Muted,
						Font = Enum.Font.GothamMedium,
						TextSize = 11,
						Parent = Frame2
					})

					local Frame4 = t2.value60("Frame", {
						Size = UDim2.new(1, -24, 0, 40),
						Position = UDim2.new(0.5, 0, 0, 176),
						AnchorPoint = Vector2.new(0.5, 0),
						BackgroundColor3 = t2.value59.Field,
						BorderSizePixel = 0,
						Parent = Frame2
					})

					t2.value61(Frame4, 8)
					t2.value62(Frame4, t2.value59.Border, 1)

					local TextBox = t2.value60("TextBox", {
						Size = UDim2.new(1, -20, 1, 0),
						Position = UDim2.new(0, 10, 0, 0),
						BackgroundTransparency = 1,
						Text = "",
						PlaceholderText = "Get key from Discord...",
						PlaceholderColor3 = t2.value59.Muted,
						TextColor3 = t2.value59.Text,
						Font = Enum.Font.GothamMedium,
						TextSize = 13,
						TextXAlignment = Enum.TextXAlignment.Left,
						ClearTextOnFocus = false,
						Parent = Frame4
					})
					local TextLabel = t2.value60("TextLabel", {
						Size = UDim2.new(1, -60, 0, 16),
						Position = UDim2.new(0.5, 0, 0, 232),
						AnchorPoint = Vector2.new(0.5, 0),
						BackgroundTransparency = 1,
						Text = "",
						TextColor3 = t2.value59.Muted,
						Font = Enum.Font.GothamMedium,
						TextSize = 11,
						Parent = Frame2
					})

					local function v1024(p162, p163, p164, p165, p166)
						local color3 = p166 and Color3.fromRGB(120, 165, 255) or Color3.fromRGB(58, 58, 70)
						local TextButton2 = t2.value60("TextButton", {
							Size = UDim2.new(1, 0, 0, 34),
							BackgroundColor3 = p163,
							TextColor3 = Color3.fromRGB(255, 255, 255),
							Font = Enum.Font.GothamSemibold,
							TextSize = 13,
							Text = p162,
							AutoButtonColor = false,
							BorderSizePixel = 0,
							Parent = p165
						})

						t2.value61(TextButton2, 6)
						TextButton2:SetAttribute("BaseColor", p163)
						TextButton2:SetAttribute("BaseStroke", color3)

						local UIStroke = t2.value60("UIStroke", {
							Color = color3,
							Thickness = 1,
							Transparency = 0.35,
							ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
							Parent = TextButton2
						})
						local v1028 = nil

						local function v1029(p167, p168, p169, p170)
							t2.value5:Create(TextButton2, TweenInfo.new(0.12), {
								BackgroundColor3 = p167
							}):Play()

							local value5 = t2.value5
							local v1031 = v1028
							local tweenInfo = TweenInfo.new(0.12)

							value5.Create(value5, v1031, tweenInfo, {
								Color = p168,
								Transparency = p169
							}):Play()

							if not p170 then
								return
							end

							t2.value5:Create(TextButton2, TweenInfo.new(0.12), {
								TextColor3 = p170
							}):Play()
						end

						v1028 = UIStroke
						TextButton2.MouseEnter:Connect(function()
							local v1033 = v1029
							local v1034 = p164
							local color32 = p166

							if not color32 then
								v1033(v1034, color32 or Color3.fromRGB(78, 78, 92), 0.15)

								return
							end

							color32 = Color3.fromRGB(150, 190, 255)
							v1033(v1034, color32 or Color3.fromRGB(78, 78, 92), 0.15)
						end)
						TextButton2.MouseLeave:Connect(function()
							v1029(p163, color3, 0.35)
						end)
						TextButton2.MouseButton1Down:Connect(function()
							local v1036 = v1029
							local color32 = p166

							if not color32 then
								v1036(color32 or Color3.fromRGB(24, 24, 30), color3, 0.35)

								return
							end

							color32 = Color3.fromRGB(52, 92, 200)
							v1036(color32 or Color3.fromRGB(24, 24, 30), color3, 0.35)
						end)
						TextButton2.MouseButton1Up:Connect(function()
							local v1038 = v1029
							local v1039 = p164
							local color32 = p166

							if not color32 then
								v1038(v1039, color32 or Color3.fromRGB(78, 78, 92), 0.15)

								return
							end

							color32 = Color3.fromRGB(150, 190, 255)
							v1038(v1039, color32 or Color3.fromRGB(78, 78, 92), 0.15)
						end)

						return TextButton2
					end

					local Frame5 = t2.value60("Frame", {
						Size = UDim2.new(1, -24, 0, 78),
						Position = UDim2.new(0.5, 0, 0, 258),
						AnchorPoint = Vector2.new(0.5, 0),
						BackgroundTransparency = 1,
						Parent = Frame2
					})

					t2.value60("UIListLayout", {
						Padding = UDim.new(0, 10),
						SortOrder = Enum.SortOrder.LayoutOrder,
						Parent = Frame5
					})

					local submitKey = v1024("Submit Key", t2.value59.Accent, Color3.fromRGB(108, 158, 255), Frame5, true)
					local v1043 = v1024("Get Key · Discord", t2.value59.Accent, Color3.fromRGB(108, 158, 255), Frame5, true)

					submitKey.Size = UDim2.new(1, 0, 0, 34)
					v1043.Size = UDim2.new(1, 0, 0, 34)
					t2.value60("Frame", {
						Size = UDim2.new(1, -24, 0, 1),
						Position = UDim2.new(0.5, 0, 1, -68),
						AnchorPoint = Vector2.new(0.5, 0),
						BackgroundColor3 = t2.value59.Border,
						BorderSizePixel = 0,
						Parent = Frame2
					})

					local Frame6 = t2.value60("Frame", {
						Name = "StatusPills",
						Size = UDim2.new(1, -24, 0, 22),
						Position = UDim2.new(0.5, 0, 1, -60),
						AnchorPoint = Vector2.new(0.5, 0),
						BackgroundTransparency = 1,
						Parent = Frame2
					})

					t2.value60("UIListLayout", {
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						Padding = UDim.new(0, 6),
						SortOrder = Enum.SortOrder.LayoutOrder,
						Parent = Frame6
					})

					local function v1045(p171, p172, p173)
						local Frame7 = t2.value60("Frame", {
							Size = UDim2.new(0, 0, 0, 20),
							AutomaticSize = Enum.AutomaticSize.X,
							BackgroundColor3 = t2.value59.Field,
							BorderSizePixel = 0,
							Parent = Frame6
						})

						t2.value61(Frame7, 10)
						t2.value62(Frame7, t2.value59.Border, 1)
						t2.value60("UIPadding", {
							PaddingLeft = UDim.new(0, 9),
							PaddingRight = UDim.new(0, 9),
							Parent = Frame7
						})
						t2.value60("UIListLayout", {
							FillDirection = Enum.FillDirection.Horizontal,
							VerticalAlignment = Enum.VerticalAlignment.Center,
							Padding = UDim.new(0, 5),
							SortOrder = Enum.SortOrder.LayoutOrder,
							Parent = Frame7
						})

						if not p172 then
							t2.value60("TextLabel", {
								Size = UDim2.new(0, 0, 1, 0),
								AutomaticSize = Enum.AutomaticSize.X,
								BackgroundTransparency = 1,
								Text = p171,
								TextColor3 = p173 or t2.value59.Muted,
								Font = Enum.Font.GothamBold,
								TextSize = 10,
								LayoutOrder = 2,
								Parent = Frame7
							})

							return Frame7
						end

						local Frame8 = t2.value60("Frame", {
							Size = UDim2.new(0, 6, 0, 6),
							BackgroundColor3 = p172,
							BorderSizePixel = 0,
							LayoutOrder = 1,
							Parent = Frame7
						})

						t2.value61(Frame8, 3)
						t2.value60("TextLabel", {
							Size = UDim2.new(0, 0, 1, 0),
							AutomaticSize = Enum.AutomaticSize.X,
							BackgroundTransparency = 1,
							Text = p171,
							TextColor3 = p173 or t2.value59.Muted,
							Font = Enum.Font.GothamBold,
							TextSize = 10,
							LayoutOrder = 2,
							Parent = Frame7
						})

						return Frame7
					end

					v1045("ONLINE", t2.value59.Green, t2.value59.Green)
					v1045(t2.value172.Version, nil, t2.value59.Muted)
					v1045("DEATH BALL", nil, t2.value59.Accent)

					local Frame7 = t2.value60("Frame", {
						Name = "Credits",
						Size = UDim2.new(1, -24, 0, 26),
						Position = UDim2.new(0.5, 0, 1, -30),
						AnchorPoint = Vector2.new(0.5, 0),
						BackgroundTransparency = 1,
						Parent = Frame2
					})

					t2.value60("TextLabel", {
						Size = UDim2.new(1, 0, 0, 12),
						BackgroundTransparency = 1,
						Text = "Powered By Sentenal Z Exploit Team",
						TextColor3 = t2.value59.Text,
						Font = Enum.Font.GothamBold,
						TextSize = 11,
						Parent = Frame7
					})
					t2.value60("TextLabel", {
						Size = UDim2.new(1, 0, 0, 12),
						Position = UDim2.new(0, 0, 0, 13),
						BackgroundTransparency = 1,
						Text = "Credits to TanqRfake11  ·  Haruto_Kunshi1",
						TextColor3 = t2.value59.Muted,
						Font = Enum.Font.GothamMedium,
						TextSize = 10,
						Parent = Frame7
					})

					local function v1049()
						local v1050 = Frame2

						for _, descendant in ipairs(v1050.GetDescendants(v1050)) do
							if descendant:IsA("TextButton") then
								descendant.BackgroundColor3 = descendant:GetAttribute("BaseColor") or descendant.BackgroundColor3

								for _, child in ipairs(descendant.GetChildren(descendant)) do
									if child:IsA("UIStroke") then
										child.Transparency = 0.35
										child.Color = descendant:GetAttribute("BaseStroke") or child.Color
									end
								end
							end
						end
					end
					local function v1055()
						if connection2 then
							connection2:Disconnect()
							connection2 = nil
						else
						end

						v1049()

						local v1056 = Frame2

						for _, descendant in ipairs(v1056.GetDescendants(v1056)) do
							if descendant:IsA("TextLabel") or (descendant:IsA("TextButton") or descendant:IsA("TextBox")) then
								local value5 = t2.value5
								local tweenInfo = TweenInfo.new(0.22)

								value5.Create(value5, descendant, tweenInfo, {
									TextTransparency = 1,
									BackgroundTransparency = 1
								}):Play()
							elseif descendant:IsA("ImageLabel") or descendant:IsA("ImageButton") then
								local value5 = t2.value5
								local tweenInfo = TweenInfo.new(0.22)

								value5.Create(value5, descendant, tweenInfo, {
									ImageTransparency = 1,
									BackgroundTransparency = 1
								}):Play()
							elseif descendant:IsA("Frame") then
								local value5 = t2.value5
								local tweenInfo = TweenInfo.new(0.22)

								value5.Create(value5, descendant, tweenInfo, {
									BackgroundTransparency = 1
								}):Play()
							elseif descendant:IsA("UIStroke") then
								local value5 = t2.value5
								local tweenInfoNew = TweenInfo.new

								value5.Create(value5, descendant, tweenInfoNew(0.22), {
									Transparency = 1
								}):Play()
							end
						end

						task.wait(0.22)

						local value5 = t2.value5
						local v1068 = Frame2
						local tweenInfo = TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
						local uDim2New = UDim2.new

						value5.Create(value5, v1068, tweenInfo, {
							Size = uDim2New(0, 260, 0, 220)
						}):Play()
						task.wait(0.28)

						local Frame8 = t2.value60("Frame", {
							Name = "LoadHolder",
							Size = UDim2.new(1, 0, 1, 0),
							BackgroundTransparency = 1,
							Parent = Frame2
						})
						local Frame9 = t2.value60("Frame", {
							Name = "Track",
							Size = UDim2.new(0, 72, 0, 72),
							Position = UDim2.new(0.5, 0, 0, 28),
							AnchorPoint = Vector2.new(0.5, 0),
							BackgroundTransparency = 1,
							Parent = Frame8
						})

						t2.value61(Frame9, 36)
						t2.value60("UIStroke", {
							Color = t2.value59.Field,
							Thickness = 4,
							Parent = Frame9
						})

						local Frame10 = t2.value60("Frame", {
							Name = "Arc",
							Size = UDim2.new(0, 72, 0, 72),
							Position = UDim2.new(0.5, 0, 0, 28),
							AnchorPoint = Vector2.new(0.5, 0),
							BackgroundTransparency = 1,
							Parent = Frame8
						})

						t2.value61(Frame10, 36)

						local UIStroke = t2.value60("UIStroke", {
							Color = t2.value59.Accent,
							Thickness = 4,
							LineJoinMode = Enum.LineJoinMode.Round,
							Parent = Frame10
						})

						t2.value60("UIGradient", {
							Rotation = 0,
							Transparency = NumberSequence.new({
								NumberSequenceKeypoint.new(0, 0),
								NumberSequenceKeypoint.new(0.55, 0),
								NumberSequenceKeypoint.new(0.75, 1),
								NumberSequenceKeypoint.new(1, 1)
							}),
							Parent = UIStroke
						})

						local connection3 = t2.value2.RenderStepped:Connect(function(dt)
							local Parent = Frame10

							if Parent then
								Parent = Frame10.Parent
							end

							if not Parent then
								return
							end

							Frame10.Rotation = (Frame10.Rotation + dt * 260) % 360
						end)

						t2.value13[#t2.value13 + 1] = connection3
						t2.value60("TextLabel", {
							Size = UDim2.new(1, 0, 0, 30),
							Position = UDim2.new(0, 0, 0, 116),
							BackgroundTransparency = 1,
							Text = "Loading Sentenal Z",
							TextColor3 = t2.value59.Text,
							Font = Enum.Font.GothamBold,
							TextSize = 22,
							Parent = Frame8
						})
						t2.value60("TextLabel", {
							Size = UDim2.new(1, 0, 0, 14),
							Position = UDim2.new(0, 0, 0, 146),
							BackgroundTransparency = 1,
							Text = t2.value172.Version .. "  ·  " .. t2.value172.Subtitle,
							TextColor3 = t2.value59.Muted,
							Font = Enum.Font.GothamMedium,
							TextSize = 11,
							Parent = Frame8
						})

						local Frame11 = t2.value60("Frame", {
							Name = "ProgressTrack",
							Size = UDim2.new(1, -50, 0, 6),
							Position = UDim2.new(0.5, 0, 0, 170),
							AnchorPoint = Vector2.new(0.5, 0),
							BackgroundColor3 = t2.value59.Field,
							BorderSizePixel = 0,
							Parent = Frame8
						})

						t2.value61(Frame11, 3)

						local Frame12 = t2.value60("Frame", {
							Name = "ProgressFill",
							Size = UDim2.new(0, 0, 1, 0),
							BackgroundColor3 = t2.value59.Accent,
							BorderSizePixel = 0,
							Parent = Frame11
						})

						t2.value61(Frame12, 3)

						local TextLabel2 = t2.value60("TextLabel", {
							Size = UDim2.new(1, -50, 0, 14),
							Position = UDim2.new(0.5, 0, 0, 182),
							AnchorPoint = Vector2.new(0.5, 0),
							BackgroundTransparency = 1,
							Text = "0%",
							TextColor3 = t2.value59.Muted,
							Font = Enum.Font.GothamMedium,
							TextSize = 11,
							Parent = Frame8
						})
						local n29 = 1
						local v1081 = math.random(5, 9)
						local v1082 = n29 < 0
						local v1083 = 1 - n29
						local v1084 = v1081
						local n30 = 0

						local function v1087(p174, p175)
							return p174 + math.random() * (p175 - p174)
						end

						local t32 = {}

						while true do
							v1083 = v1083 + n29

							local v1088 = not v1082

							if v1088 then
								v1088 = v1083 <= v1081
							end

							if (not v1082 or v1081 > v1083) and not v1088 then
								local n31 = 0
								local n32 = 0
								local connection4 = t2.value2.RenderStepped:Connect(function(dt)
									if Frame12 and Frame12.Parent then
										local v1092 = n31
										local v1093 = n32 - n31
										local v1094 = dt * 9

										n31 = v1092 + v1093 * math.min(v1094, 1)
										Frame12.Size = UDim2.new(n31, 0, 1, 0)

										local v1095 = TextLabel2
										local format = string.format
										local v1097 = n31 * 100 + 0.5

										v1095.Text = format("%d%%", (math.floor(v1097)))
									end
								end)

								t2.value13[#t2.value13 + 1] = connection4

								for _, v in ipairs(t32) do
									n32 = v[1]
									task.wait(v[2])

									if v[3] > 0 then
										task.wait(v[3])
									end
								end

								n32 = 1
								task.wait(0.35)

								local value52 = t2.value5
								local v1101 = Frame2
								local tweenInfo2 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
								local Position3 = Frame2.Position
								local UDim2_ = UDim2
								local v1105 = value52.Create(value52, v1101, tweenInfo2, {
									Position = Position3 + UDim2_.new(0, 0, 0, 60),
									BackgroundTransparency = 1
								})

								v1105:Play()

								local v1106, v1107, v1108 = ipairs(Frame2:GetDescendants())

								while true do
									local v1109

									v1108, v1109 = v1106(v1107, v1108)

									if not v1108 then
										break
									end

									if v1109:IsA("TextLabel") or (v1109:IsA("TextButton") or v1109:IsA("TextBox")) then
										t2.value5:Create(v1109, TweenInfo.new(0.3), {
											TextTransparency = 1
										}):Play()
									elseif v1109:IsA("ImageLabel") or v1109:IsA("ImageButton") then
										local value53 = t2.value5
										local TweenInfo_ = TweenInfo

										value53.Create(value53, v1109, TweenInfo_.new(0.3), {
											ImageTransparency = 1
										}):Play()
									elseif v1109:IsA("Frame") then
										local value53 = t2.value5
										local TweenInfo_ = TweenInfo

										value53.Create(value53, v1109, TweenInfo_.new(0.3), {
											BackgroundTransparency = 1
										}):Play()
									elseif v1109:IsA("UIStroke") then
										local value53 = t2.value5
										local tweenInfo3 = TweenInfo.new(0.3)

										value53.Create(value53, v1109, tweenInfo3, {
											Transparency = 1
										}):Play()
									end
								end

								v1105.Completed:Wait()

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

								for _, v in ipairs(t30) do
									pcall(function()
										v:Disconnect()
									end)
								end

								_G.__SentenalZKeySystem = nil
								ScreenGui:Destroy()
								t2.value64.Visible = true

								if not p161 then
									return
								end

								p161()

								return
							end

							local v1118 = v1083 == v1084
							local v1119

							if v1118 then
								v1119 = 1 - n30
							elseif math.random() < 0.25 then
								v1119 = v1087(0.18, 0.32)
							else
								v1119 = v1087(0.06, 0.16)
							end

							local v1120 = n30 + v1119

							n30 = math.min(v1120, v1118 and 1 or 0.97)

							local v1121 = not v1118
							local v1122 = v1087(0.12, 0.3) + v1119 * 0.6
							local n33 = 0

							if v1121 then
								v1121 = math.random() < 0.55
							end

							if v1121 then
								local v1124

								if math.random() < 0.25 then
									v1124 = v1087(0.45, 0.85)
								else
									v1124 = false
								end

								n33 = v1124 or v1087(0.12, 0.35)
							end

							table.insert(t32, { n30, v1122, n33 })
						end
					end
					local function v1125()
						local Text = TextBox.Text

						TextLabel.Text = "Checking..."
						TextLabel.TextColor3 = t2.value59.Muted
						task.spawn(function()
							local v1127, v1128 = t2.value177(Text)

							if v1127 then
								TextLabel.Text = v1128
								TextLabel.TextColor3 = t2.value59.Green
								t2.value175(Text)
								task.wait(0.4)
								v1055()
							else
								TextLabel.Text = v1128
								TextLabel.TextColor3 = Color3.fromRGB(232, 92, 92)

								local value5 = t2.value5
								local v1130 = Frame4
								local tweenInfo = TweenInfo.new(0.08)
								local t33 = {
									BackgroundColor3 = Color3.fromRGB(60, 30, 34)
								}

								value5.Create(value5, v1130, tweenInfo, t33):Play()
								task.wait(0.25)

								local value52 = t2.value5
								local v1134 = Frame4
								local tweenInfo2 = TweenInfo.new(0.2)

								value52.Create(value52, v1134, tweenInfo2, {
									BackgroundColor3 = t2.value59.Field
								}):Play()
							end
						end)
					end

					submitKey.MouseButton1Click:Connect(v1125)
					TextBox.FocusLost:Connect(function(enterPressed)
						if not enterPressed then
							return
						end

						local Text = TextBox.Text

						TextLabel.Text = "Checking..."
						TextLabel.TextColor3 = t2.value59.Muted
						task.spawn(function()
							local v1137, v1138 = t2.value177(Text)

							if v1137 then
								TextLabel.Text = v1138
								TextLabel.TextColor3 = t2.value59.Green
								t2.value175(Text)
								task.wait(0.4)
								v1055()
							else
								TextLabel.Text = v1138
								TextLabel.TextColor3 = Color3.fromRGB(232, 92, 92)

								local value5 = t2.value5
								local v1140 = Frame4
								local tweenInfo = TweenInfo.new(0.08)
								local t34 = {
									BackgroundColor3 = Color3.fromRGB(60, 30, 34)
								}

								value5.Create(value5, v1140, tweenInfo, t34):Play()
								task.wait(0.25)

								local value52 = t2.value5
								local v1144 = Frame4
								local tweenInfo2 = TweenInfo.new(0.2)

								value52.Create(value52, v1144, tweenInfo2, {
									BackgroundColor3 = t2.value59.Field
								}):Play()
							end
						end)
					end)
					v1043.MouseButton1Click:Connect(function()
						v801(t2.value172.DiscordURL)
						TextLabel.Text = "Join Discord → find the key → paste above"
						TextLabel.TextColor3 = t2.value59.Accent
					end)

					local function v1146()
						if connection2 then
							connection2:Disconnect()
						else
						end

						v1049()

						local value5 = t2.value5
						local v1148 = Frame2
						local TweenInfo_ = TweenInfo
						local v1150 = value5.Create(value5, v1148, TweenInfo_.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
							Position = Frame2.Position + UDim2.new(0, 0, 0, 60),
							BackgroundTransparency = 1
						})

						v1150:Play()

						local v1151, v1152, v1153 = ipairs(Frame2:GetDescendants())

						while true do
							local v1154

							v1153, v1154 = v1151(v1152, v1153)

							if not v1153 then
								break
							end

							if v1154:IsA("TextLabel") or (v1154:IsA("TextButton") or v1154:IsA("TextBox")) then
								t2.value5:Create(v1154, TweenInfo.new(0.3), {
									TextTransparency = 1,
									BackgroundTransparency = 1
								}):Play()
							elseif v1154:IsA("ImageLabel") or v1154:IsA("ImageButton") then
								t2.value5:Create(v1154, TweenInfo.new(0.3), {
									ImageTransparency = 1,
									BackgroundTransparency = 1
								}):Play()
							elseif v1154:IsA("Frame") then
								t2.value5:Create(v1154, TweenInfo.new(0.3), {
									BackgroundTransparency = 1
								}):Play()
							elseif v1154:IsA("UIStroke") then
								local value52 = t2.value5
								local TweenInfo_2 = TweenInfo

								value52.Create(value52, v1154, TweenInfo_2.new(0.3), {
									Transparency = 1
								}):Play()
							end
						end

						v1150.Completed:Wait()
						pcall(t2.value34)
						pcall(t2.value52)
						pcall(t2.value30)
						pcall(t2.value109)
						pcall(StopFly)

						local function v1157()
							t2.value2:UnbindFromRenderStep(t2.value32)
						end

						pcall(v1157)

						local function v1158()
							t2.value2:UnbindFromRenderStep(t2.value43)
						end

						pcall(v1158)

						local function v1159()
							t2.value2:UnbindFromRenderStep(FLY_STEP_NAME)
						end

						pcall(v1159)

						if t2.value105 then
							pcall(function()
								t2.value105:Disconnect()
							end)
						end

						if t2.value108 then
							pcall(function()
								t2.value108:Disconnect()
							end)
						end

						for _, v in ipairs(t2.value13) do
							pcall(function()
								v:Disconnect()
							end)
						end

						_G.__DBGen = (_G.__DBGen or 0) + 1

						if connection then
							local function v1162()
								connection:Disconnect()
							end

							pcall(v1162)
							connection = nil
						end

						for _, v in ipairs(t30) do
							pcall(function()
								v:Disconnect()
							end)
						end

						_G.__SentenalZKeySystem = nil

						local __DeathBallAutoParry = _G.__DeathBallAutoParry

						if __DeathBallAutoParry then
							__DeathBallAutoParry = _G.__DeathBallAutoParry.Gui
						end

						if __DeathBallAutoParry then
							pcall(function()
								_G.__DeathBallAutoParry.Gui:Destroy()
							end)
						end

						if t2.value82 then
							pcall(function()
								t2.value82:Destroy()
							end)
							t2.value82 = nil
						end

						local __DeathBallAutoParry2 = _G.__DeathBallAutoParry

						if __DeathBallAutoParry2 then
							__DeathBallAutoParry2 = _G.__DeathBallAutoParry.NotifGui
						end

						if __DeathBallAutoParry2 then
							pcall(function()
								_G.__DeathBallAutoParry.NotifGui:Destroy()
							end)
						end

						if t2.value65 then
							local function v1167()
								t2.value65:Destroy()
							end

							pcall(v1167)
							t2.value65 = nil
						end

						local function v1168()
							ScreenGui:Destroy()
						end

						pcall(v1168)
						_G.__DeathBallAutoParry = nil
						print("[SENTENAL Z - DEATH BALL] Unloaded via key system close.")
					end

					TextButton.MouseButton1Click:Connect(v1146)

					return
				end

				local v1169 = math.random(2, 5)
				local Frame2 = t2.value60("Frame", {
					Name = "Particle" .. v985,
					Size = UDim2.new(0, v1169, 0, v1169),
					Position = UDim2.new(math.random(), 0, math.random(), 0),
					BackgroundColor3 = t2.value59.Accent,
					BackgroundTransparency = math.random(45, 80) / 100,
					BorderSizePixel = 0,
					ZIndex = 1,
					Parent = Frame
				})

				t2.value61(Frame2, v1169 / 2)
				t31[v985] = {
					Frame = Frame2,
					Speed = math.random(8, 26) / 1000,
					Drift = (math.random() - 0.5) * 0.0004,
					Phase = math.random() * 3.141592653589793 * 2,
					BaseX = Frame2.Position.X.Scale
				}
			end
		end)(function()
			if t2.value14.AutoSpam then
				t2.value31()
			end

			local print_ = print
			local AutoParryKey = t2.value14.AutoParryKey

			if AutoParryKey then
				AutoParryKey = t2.value14.AutoParryKey.Name
			end

			local v1173 = AutoParryKey or "-"
			local AutoSpamKey = t2.value14.AutoSpamKey

			if AutoSpamKey then
				AutoSpamKey = t2.value14.AutoSpamKey.Name
			end

			local v1175 = AutoSpamKey or "unbound"
			local AIMovementKey = t2.value14.AIMovementKey

			if AIMovementKey then
				AIMovementKey = t2.value14.AIMovementKey.Name
			end

			local v1177 = AIMovementKey or "unbound"
			local CameraRotationKey = t2.value14.CameraRotationKey

			if CameraRotationKey then
				CameraRotationKey = t2.value14.CameraRotationKey.Name
			end

			local v1179 = CameraRotationKey or "unbound"
			local AutoReadyKey = t2.value14.AutoReadyKey

			if not AutoReadyKey then
				print_("[SENTENAL Z - DEATH BALL] Loaded. Parry [" .. v1173 .. "] · Spam [" .. v1175 .. "] · AI [" .. v1177 .. "] · Cam [" .. v1179 .. "] · Ready [" .. (AutoReadyKey or "unbound") .. "]")

				return
			end

			AutoReadyKey = t2.value14.AutoReadyKey.Name
			print_("[SENTENAL Z - DEATH BALL] Loaded. Parry [" .. v1173 .. "] · Spam [" .. v1175 .. "] · AI [" .. v1177 .. "] · Cam [" .. v1179 .. "] · Ready [" .. (AutoReadyKey or "unbound") .. "]")
		end)

		return
	end

	local v1181 = math.random(2, 4)

	value1 = t2.value60
	t1.value6 = "MParticle" .. t1.value4
	t1.value7 = UDim2.new(0, v1181, 0, v1181)
	t1.value2 = UDim2.new(math.random(), 0, math.random(), 0)
	t1.value8 = t2.value59.Accent
	ok = math.random(55, 85) / 100
	t1.value1 = value1("Frame", {
		Name = t1.value6,
		Size = t1.value7,
		Position = t1.value2,
		BackgroundColor3 = t1.value8,
		BackgroundTransparency = ok,
		BorderSizePixel = 0,
		ZIndex = 1,
		Parent = t2.value103
	})
	t2.value61(t1.value1, v1181 / 2)
	v1181 = t2.value104
	t1.value6 = math.random(6, 20) / 1000
	value1 = math.random() * 3.141592653589793 * 2
	t1.value7 = t1.value1.Position.X.Scale
	t1.value5 = {
		Frame = t1.value1,
		Speed = t1.value6,
		Phase = value1,
		BaseX = t1.value7
	}
	v1181[t1.value4] = t1.value5
end
