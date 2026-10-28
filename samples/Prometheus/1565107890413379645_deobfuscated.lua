-- This file was generated at discord.gg/syncrypt

local VerifySosiskomras = getgenv().VerifySosiskomras

if type(VerifySosiskomras) ~= "function" then
	return
end

local v3 = math.random(100000, 999999)
local v4 = game.GameId + 2
local v5 = bit32.bxor(v4, v3) * 3 + 52
local t1 = {
	value4 = tostring(v5),
	value2 = getgenv().VerifySosiskomras(v3)
}

if t1.value2 ~= t1.value4 then
	return
end

t1.value2 = os.clock()

while true do
	t1.value6 = getgenv()

	if t1.value6.SosiskomrasHub then
		break
	end

	t1.value6 = os.clock()

	if t1.value6 - t1.value2 > 10 then
		return
	end

	task.wait(0.1)
end

local SosiskomrasHub = getgenv().SosiskomrasHub

t1.value1 = "getgenv"
t1.value3 = SosiskomrasHub
t1.value1 = getgenv()
t1.value1.SosiskomrasHub = nil
t1.value6 = t1.value3.ScreenGui
t1.value1 = "mainFrame"

local mainFrame = t1.value3.mainFrame

t1.value1 = "sidebarHeaderText"
t1.value9 = mainFrame
t1.value5 = t1.value3.sidebarHeaderText

local value5 = t1.value5

t1.value1 = "sidebarSubheaderText"
t1.value8 = value5
t1.value7 = t1.value3.sidebarSubheaderText
t1.value1 = "AppImages"
t1.value10 = t1.value3.AppImages
t1.value1 = "CreateSidebarButton"
t1.value11 = t1.value3.CreateSidebarButton
t1.value1 = "CreateTab"

local CreateTab = t1.value3.CreateTab

t1.value1 = "ShowTab"
t1.value12 = CreateTab

local ShowTab = t1.value3.ShowTab

t1.value13 = t1.value3.CreateSubTabs
t1.value14 = "HttpService"
t1.value1 = "CreateBlock"
t1.value15 = t1.value3.CreateBlock
t1.value1 = "EndBlock"

local EndBlock = t1.value3.EndBlock

t1.value1 = "CreateButton"
t1.value16 = EndBlock
t1.value5 = t1.value3.CreateButton

local CreateToggle = t1.value3.CreateToggle

t1.value1 = "CreateSlider"
t1.value17 = CreateToggle
t1.value18 = t1.value3.CreateSlider
t1.value1 = "CreateDropdown"
t1.value19 = t1.value3.CreateDropdown
t1.value1 = "CreateColorPicker"

local CreateColorPicker = t1.value3.CreateColorPicker

t1.value1 = "CreateInput"
t1.value20 = false
t1.value21 = CreateColorPicker
t1.value5 = t1.value3.CreateInput
t1.value5 = t1.value3.CreateWaypointSystem
t1.value5 = t1.value3.CreateSpectateSystem

local value52 = t1.value5

t1.value22 = {}
t1.value23 = value52
t1.value1 = "game"
t1.value1 = game:GetService("Players")

local value1 = t1.value1

t1.value5 = value1.LocalPlayer

local value53 = t1.value5

t1.value1 = game:GetService("UserInputService")

local value12 = t1.value1

t1.value24 = "Main"
t1.value1 = "game"
game:GetService("TweenService")
t1.value1 = game:GetService("VirtualInputManager")

local value13 = t1.value1

game:GetService("VirtualUser")
t1.value1 = game:GetService("RunService")

local value14 = t1.value1

t1.value1 = game:GetService("Lighting")

local value15 = t1.value1

t1.value5 = workspace.CurrentCamera

local value54 = t1.value5

t1.value1 = game:GetService("ReplicatedStorage")

local value16 = t1.value1

t1.value14 = game:GetService("HttpService")
game:GetService("TeleportService")
t1.value1 = "They can hear"
t1.value5 = "Text"
t1.value7.Text = "They can hear"
t1.value11("Main", t1.value10.Main)
t1.value24 = "noFallDamage"
t1.value1 = "Main"
t1.value25 = "Main"
t1.value12("Main")
ShowTab("Main")
t1.value27 = value53.Character
t1.value28 = value53

local WaitForChild = t1.value28.WaitForChild

t1.value25 = false
t1.value29 = WaitForChild
t1.value29 = t1.value29(t1.value28, "PlayerGui", 8)
t1.value5 = {
	infStamina = t1.value25,
	noFallDamage = t1.value20,
	autoBelt = false,
	noRecoil = false,
	noSpread = false,
	rapidFire = false,
	noFog = false,
	autoHijack = false,
	aimEnabled = false,
	drawFov = true,
	aimTargetPart = "Head",
	aimMode = "Smooth",
	aimFov = 150,
	aimDistance = 400,
	aimSmoothness = 0.22,
	aimPrediction = 0.12,
	aimTarget = nil,
	ignoredPlayers = t1.value22,
	hijackFiredCycle = false,
	hijackLastRot = 0,
	cachedCharacter = t1.value27,
	cachedHumanoid = nil,
	cachedRootPart = nil,
	cachedPlayerGui = t1.value29
}
t1.value20 = "Balanced"
t1.value1 = "Smooth"

local value55 = t1.value5
local t2 = {
	Smooth = 0.22,
	Balanced = 0.35,
	Fast = 0.48,
	Hard = 0.62
}

t1.value20 = value53:WaitForChild("PlayerScripts", 8)

local value20 = t1.value20

if value20 then
	value20 = t1.value20:WaitForChild("Client", 8)
end

t1.value1 = value20

local value17 = t1.value1

t1.value31 = "Shared"
t1.value30 = value17
t1.value31 = value16:WaitForChild("Shared", 8)

local value31 = t1.value31

if value31 then
	value31 = t1.value31:WaitForChild("Guns", 8)
end

t1.value32 = value31
t1.value5 = value16
t1.value1 = t1.value5.WaitForChild
t1.value33 = "Remotes"
t1.value1 = t1.value1(t1.value5, "Remotes", 8)
t1.value33 = t1.value1

local value33 = t1.value33

if value33 then
	value33 = t1.value33:WaitForChild("Vehicle", 8)
end

t1.value1 = value33

local value18 = t1.value1
local module = nil

if t1.value30 then
	t1.value5 = t1.value30.WaitForChild
	t1.value34 = 8
	t1.value1 = "Guns"
	t1.value5 = t1.value5(t1.value30, "Guns", t1.value34)

	local value56 = t1.value5

	if value56 then
		function t1.value35()
			module = require(value56)
		end

		pcall(t1.value35)
	end
end

t1.value5 = nil

local value56 = nil

if t1.value30 then
	t1.value1 = "Controls"
	t1.value35 = 8
	t1.value5 = "WaitForChild"
	t1.value5 = t1.value30:WaitForChild("Controls", t1.value35)
	t1.value35 = t1.value5

	local value35 = t1.value35

	if value35 then
		value35 = t1.value35:IsA("ModuleScript")
	end

	t1.value1 = value35

	if t1.value1 then
		t1.value5 = pcall

		local v35, v36 = t1.value5(require, t1.value35)

		t1.value1 = v35
		t1.value36 = v36

		if t1.value1 then
			t1.value5 = t1.value36
			value56 = t1.value5
		end
	end
end

local value19 = nil

if t1.value30 then
	t1.value1 = "WaitForChild"
	t1.value36 = "WorldFX"
	t1.value36 = t1.value30:WaitForChild("WorldFX", 8)

	local value36 = t1.value36

	if value36 then
		value36 = t1.value36:IsA("ModuleScript")
	end

	t1.value1 = value36

	if t1.value1 then
		local ok, value110 = pcall(require, t1.value36)

		t1.value37 = ok
		t1.value1 = value110

		if t1.value37 then
			value19 = t1.value1
		end
	end
end

local value57 = t1.value5
local value32 = t1.value32
local value58 = t1.value5

t1.value38 = value57
t1.value1 = value32
t1.value37 = value58

if t1.value32 then
	t1.value1 = require(t1.value32)
end

local value110 = t1.value1
local value38 = t1.value38

t1.value36 = value110
t1.value5 = value38

if not t1.value1 then
	t1.value39 = {}
	t1.value36 = {
		Defs = t1.value39
	}
end

local value37 = t1.value37

t1.value39 = "pairs"
t1.value5 = value37
t1.value37 = t1.value36.Defs

local value372 = t1.value37

t1.value37 = pairs

local t3 = {}

for k, v in t1.value37(value372) do
	local recoil = v.recoil
	local side = v.side
	local climb = v.climb
	local spread = v.spread

	t1.value40 = v.delay
	t1.value41 = v.auto
	t1.value42 = {
		recoil = recoil,
		side = side,
		climb = climb,
		spread = spread,
		delay = t1.value40,
		auto = t1.value41
	}
	t3[k] = t1.value42
end

t1.value37 = value15.FogEnd

local value373 = t1.value37

t1.value37 = value15.FogStart

local function v56(p1)
	value55.rapidFire = p1

	for k, v in pairs(value372) do
		local v59 = not v.melee

		if v59 then
			v59 = not v.gadget
		end

		if v59 then
			local v60 = t3[k]

			if v60 then
				v.delay = p1 and 0.05 or v60.delay
				v.auto = p1 and true or v60.auto
			end
		end
	end
end

local value374 = t1.value37
local Circle = nil

pcall(function()
	Circle = Drawing.new("Circle")
	Circle.Thickness = 1.5
	Circle.NumSides = 64
	Circle.Radius = value55.aimFov
	Circle.Filled = false
	Circle.Visible = false
	Circle.Color = Color3.fromRGB(255, 255, 255)
	Circle.Transparency = 0.8
end)

local raycastParams = RaycastParams.new()

t1.value42 = Enum.RaycastFilterType.Exclude
raycastParams.FilterType = t1.value42

function t1.value44()
	local v64 = value1
	local t4 = {}

	for _, player in ipairs(v64.GetPlayers(v64)) do
		if player ~= value53 then
			local Name = player.Name

			table.insert(t4, Name)
		end
	end

	return t4
end
function t1.value45(p2)
	if not p2 or p2 == value53 then
		return false
	elseif table.find(value55.ignoredPlayers, p2.Name) then
		return false
	else
		local Character = p2.Character

		if not Character or Character:GetAttribute("Downed") == true then
			return false
		else
			local v70 = Character.FindFirstChildOfClass(Character, "Humanoid")

			return v70 and v70.Health > 0 and true or false
		end
	end
end

raycastParams.IgnoreWater = true

function t1.value42()
	task.spawn(function()
		if not value12.TouchEnabled then
			value13:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
			task.wait(0.03)
			value13:SendKeyEvent(false, Enum.KeyCode.Space, false, game)

			return
		end

		local CurrentCamera = workspace.CurrentCamera

		if not CurrentCamera then
			v73 = CurrentCamera or Vector2.new(0, 0)
			value13:SendTouchEvent(0, 0, v73.X, v73.Y)
			task.wait(0.03)
			value13:SendTouchEvent(0, 2, v73.X, v73.Y)

			return
		end

		CurrentCamera = workspace.CurrentCamera.ViewportSize / 2

		local vector2 = CurrentCamera or Vector2.new(0, 0)

		value13:SendTouchEvent(0, 0, vector2.X, vector2.Y)
		task.wait(0.03)
		value13:SendTouchEvent(0, 2, vector2.X, vector2.Y)
	end)
end
function t1.value43(p3)
	value55.noFog = p3

	if p3 then
		return
	end

	value15.FogEnd = value373
	value15.FogStart = value374

	local setClearing = value19

	if setClearing then
		setClearing = value19.setClearing
	end

	if setClearing then
		pcall(value19.setClearing, 0)
	end

	local v74 = value15

	for _, child in ipairs(v74.GetChildren(v74)) do
		if child:IsA("Atmosphere") then
			child.Density = 0.35
			child.Haze = 0.5
		elseif child:IsA("DepthOfFieldEffect") or child:IsA("BlurEffect") then
			child.Enabled = true
		end
	end

	local CurrentCamera = workspace.CurrentCamera

	if CurrentCamera then
		for _, child in ipairs(CurrentCamera.GetChildren(CurrentCamera)) do
			if child:IsA("DepthOfFieldEffect") or child:IsA("BlurEffect") then
				child.Enabled = true
			end
		end
	end

	local Terrain = workspace:FindFirstChildOfClass("Terrain")
	local Clouds = Terrain and Terrain:FindFirstChildOfClass("Clouds")

	if not Clouds then
		return
	end

	Clouds.Cover = 0.6
	Clouds.Density = 0.7
end
function t1.value46(p4)
	value55.noSpread = p4

	for k, v in pairs(value372) do
		local v84 = t3[k]

		if v84 then
			v.spread = p4 and { 0, 0 } or v84.spread
		end
	end
end

local value42 = t1.value42

function t1.value42(p5)
	value55.cachedCharacter = p5

	if p5 then
		value55.cachedHumanoid = p5:WaitForChild("Humanoid", 8)
		value55.cachedRootPart = p5:WaitForChild("HumanoidRootPart", 8)
	else
		value55.cachedHumanoid = nil
		value55.cachedRootPart = nil
	end

	if value55.cachedPlayerGui and value55.cachedPlayerGui.Parent then
		return
	end

	value55.cachedPlayerGui = value53:WaitForChild("PlayerGui", 8)
end

local function v86(p6)
	value55.noRecoil = p6

	for k, v in pairs(value372) do
		local v89 = t3[k]

		if v89 then
			v.recoil = p6 and 0 or v89.recoil
			v.side = p6 and 0 or v89.side
			v.climb = p6 and 0 or v89.climb
		end
	end
end
local function v90()
	if not module then
		local cachedCharacter = value55.cachedCharacter
		local v92

		if cachedCharacter == nil then
			v92 = false
		else
			v92 = cachedCharacter:FindFirstChild("HeldGun") ~= nil
		end

		return v92
	end

	if module.heldKind then
		return module.heldKind() == "gun"
	end

	local v93 = module.heldId()

	if not v93 then
		return false
	end

	local v94 = value372[v93]
	local v95 = v94 ~= nil

	if not v95 then
		return v95
	end

	v95 = not v94.melee

	if not v95 then
		return v95
	end

	v95 = not v94.sledge

	if not v95 then
		return v95
	end

	v95 = not v94.gadget

	return v95
end

local value43 = t1.value43
local value46 = t1.value46

function t1.value40(p7, p8, p9)
	local Needle = p7:FindFirstChild("Needle")
	local v99 = not Needle
	local v100 = p7.FindFirstChild(p7, "Zone")

	if v99 or not v100 then
		return
	end

	local v101 = (Needle.Rotation % 360 + 360) % 360
	local v102 = value55[p8]
	local v103 = v101 < v102 - 30

	if not v103 then
		if v102 > 300 then
			v103 = v101 < 40
		else
			v103 = false
		end
	end

	local math_, GetChildren, huge, v107, isGuiObject, v109, v110, v111, v112

	if not v103 then
		value55[p8] = v101

		if not value55[p9] then
			math_ = math
			GetChildren = v100.GetChildren
			huge = math_.huge
			v107 = -math.huge

			for _, v in ipairs(GetChildren(v100)) do
				isGuiObject = v:IsA("GuiObject")

				if isGuiObject then
					isGuiObject = v.Rotation ~= 0
				end

				if isGuiObject then
					v109 = (v.Rotation % 360 + 360) % 360

					if v109 < huge then
						huge = v109
					end

					if v107 < v109 then
						v107 = v109
					end
				end
			end

			if huge < math.huge then
				v110 = v107 > -math.huge
			else
				v110 = false
			end

			if not v110 then
				return
			end

			v111 = (huge + v107) / 2

			if huge <= v101 then
				v112 = v101 <= v107
			else
				v112 = false
			end

			if not (v112 and v111 - 8 <= v101) then
				return
			end

			value55[p9] = true
			value42()
		end

		return
	end

	value55[p9] = false
	value55[p8] = v101

	if not value55[p9] then
		math_ = math
		GetChildren = v100.GetChildren
		huge = math_.huge
		v107 = -math.huge

		for _, v in ipairs(GetChildren(v100)) do
			isGuiObject = v:IsA("GuiObject")

			if isGuiObject then
				isGuiObject = v.Rotation ~= 0
			end

			if isGuiObject then
				v109 = (v.Rotation % 360 + 360) % 360

				if v109 < huge then
					huge = v109
				end

				if v107 < v109 then
					v107 = v109
				end
			end
		end

		if huge < math.huge then
			v110 = v107 > -math.huge
		else
			v110 = false
		end

		if not v110 then
			return
		end

		v111 = (huge + v107) / 2

		if huge <= v101 then
			v112 = v101 <= v107
		else
			v112 = false
		end

		if not (v112 and v111 - 8 <= v101) then
			return
		end

		value55[p9] = true
		value42()
	end
end

local function v117(p10, p11)
	raycastParams.FilterDescendantsInstances = { value54, value55.cachedCharacter }

	local v118 = p10.Position - p11
	local hit = workspace:Raycast(p11, v118, raycastParams)

	return not hit or hit.Instance:IsDescendantOf(p10.Parent)
end

local value45 = t1.value45

local function v121()
	local v122 = value54.ViewportSize / 2
	local Position = value54.CFrame.Position
	local cachedRootPart = value55.cachedRootPart
	local Character, HumanoidRootPart, Magnitude, v128, v129, v130, v131

	if not cachedRootPart then
		v139 = value55.aimTargetPart == "Torso" and "HumanoidRootPart" or "Head"
		v140 = value1
		v141 = cachedRootPart or Position
		v142 = math.huge
		v143 = nil

		for _, player in ipairs(v140.GetPlayers(v140)) do
			if value45(player) then
				Character = player.Character
				HumanoidRootPart = Character:FindFirstChild(v139) or (Character:FindFirstChild("HumanoidRootPart") or Character:FindFirstChild("Head"))

				if HumanoidRootPart then
					Magnitude = (HumanoidRootPart.Position - v141).Magnitude

					if Magnitude <= value55.aimDistance then
						v128 = Magnitude < v142
					else
						v128 = false
					end

					if v128 then
						v129, v130 = value54:WorldToViewportPoint(HumanoidRootPart.Position)

						if v130 then
							v130 = v129.Z > 0
						end

						if v130 then
							if (Vector2.new(v129.X, v129.Y) - v122).Magnitude <= value55.aimFov then
								v131 = v117(HumanoidRootPart, Position)
							else
								v131 = false
							end

							if v131 then
								v143 = HumanoidRootPart
								v142 = Magnitude
							end
						end
					end
				end
			end
		end

		return v143
	end

	cachedRootPart = value55.cachedRootPart.Position

	local v134 = value55.aimTargetPart == "Torso" and "HumanoidRootPart" or "Head"
	local v135 = value1
	local v136 = cachedRootPart or Position
	local huge = math.huge
	local v138 = nil

	for _, player in ipairs(v135.GetPlayers(v135)) do
		if value45(player) then
			Character = player.Character
			HumanoidRootPart = Character:FindFirstChild(v134) or (Character:FindFirstChild("HumanoidRootPart") or Character:FindFirstChild("Head"))

			if HumanoidRootPart then
				Magnitude = (HumanoidRootPart.Position - v136).Magnitude

				if Magnitude <= value55.aimDistance then
					v128 = Magnitude < huge
				else
					v128 = false
				end

				if v128 then
					v129, v130 = value54:WorldToViewportPoint(HumanoidRootPart.Position)

					if v130 then
						v130 = v129.Z > 0
					end

					if v130 then
						if (Vector2.new(v129.X, v129.Y) - v122).Magnitude <= value55.aimFov then
							v131 = v117(HumanoidRootPart, Position)
						else
							v131 = false
						end

						if v131 then
							v138 = HumanoidRootPart
							huge = Magnitude
						end
					end
				end
			end
		end
	end

	return v138
end

local value40 = t1.value40
local value44 = t1.value44

if value53.Character then
	t1.value42(value53.Character)
end

value53.CharacterAdded:Connect(t1.value42)
value14.Heartbeat:Connect(function()
	if not value55.noFallDamage then
		return
	end

	local cachedRootPart = value55.cachedRootPart
	local cachedHumanoid = value55.cachedHumanoid

	if not cachedRootPart or (not cachedHumanoid or cachedHumanoid.Health <= 0) then
		return
	end

	local AssemblyLinearVelocity = cachedRootPart.AssemblyLinearVelocity

	if not (AssemblyLinearVelocity.Y < -30) then
		return
	end

	cachedRootPart.AssemblyLinearVelocity = Vector3.new(AssemblyLinearVelocity.X, -26, AssemblyLinearVelocity.Z)
end)
t1.value44 = value14.RenderStepped

function t1.value47()
	if value55.noFog then
		value15.FogEnd = 1000000
		value15.FogStart = 0

		local setClearing = value19

		if setClearing then
			setClearing = value19.setClearing
		end

		if setClearing then
			pcall(value19.setClearing, 1)
		end

		local v147 = value15

		for _, child in ipairs(v147.GetChildren(v147)) do
			if child:IsA("Atmosphere") then
				child.Density = 0
				child.Haze = 0
				child.Glare = 0
			elseif child:IsA("DepthOfFieldEffect") or child:IsA("BlurEffect") then
				child.Enabled = false
			end
		end

		local CurrentCamera = workspace.CurrentCamera

		if CurrentCamera then
			local GetChildren = CurrentCamera.GetChildren

			for _, v in ipairs(GetChildren(CurrentCamera)) do
				if v:IsA("DepthOfFieldEffect") or v:IsA("BlurEffect") then
					v.Enabled = false
				end
			end
		end

		local Terrain = workspace:FindFirstChildOfClass("Terrain")
		local Clouds = Terrain and Terrain:FindFirstChildOfClass("Clouds")

		if Clouds then
			Clouds.Cover = 0
			Clouds.Density = 0
		end
	end

	local autoHijack = value55.autoHijack

	if autoHijack then
		autoHijack = value55.cachedPlayerGui
	end

	if not autoHijack then
		return
	end

	local HotwireGui = value55.cachedPlayerGui:FindFirstChild("HotwireGui")

	if not (HotwireGui and HotwireGui.Enabled) then
		value55.hijackFiredCycle = false
		value55.hijackLastRot = 0

		return
	end

	local Holder = HotwireGui:FindFirstChild("Holder")

	if not (Holder and Holder.Visible) then
		value55.hijackFiredCycle = false
		value55.hijackLastRot = 0

		return
	end

	local Dial = Holder:FindFirstChild("Dial")

	if not (Dial and Dial.Visible) then
		value55.hijackFiredCycle = false
		value55.hijackLastRot = 0

		return
	end

	value40(Dial, "hijackLastRot", "hijackFiredCycle")
end

t1.value44:Connect(t1.value47)
t1.value44 = "DirectAim_" .. t1.value14:GenerateGUID(false)
t1.value41 = value14
t1.value49 = Enum.RenderPriority
t1.value47 = t1.value41.BindToRenderStep
t1.value22 = t1.value49.Camera.Value + 1

function t1.value50(p12)
	local v160 = v90()

	if Circle then
		local v161 = value54.ViewportSize / 2

		Circle.Position = Vector2.new(v161.X, v161.Y)
		Circle.Radius = value55.aimFov

		local v162 = Circle
		local aimEnabled = value55.aimEnabled

		if aimEnabled then
			aimEnabled = value55.drawFov and v160
		end

		v162.Visible = aimEnabled

		local v164 = Circle
		local aimTarget = value55.aimTarget

		if aimTarget then
			aimTarget = Color3.fromRGB(255, 0, 0)
		end

		v164.Color = aimTarget or Color3.fromRGB(255, 255, 255)
	end

	if not (value55.aimEnabled and v160) then
		value55.aimTarget = nil

		return
	end

	local v166 = v121()

	value55.aimTarget = v166

	if not v166 then
		return
	end

	local vector3 = Vector3.zero

	local function v168()
		vector3 = v166.AssemblyLinearVelocity
	end

	pcall(v168)

	local v169 = v166.Position + vector3 * value55.aimPrediction
	local cFrame = CFrame.lookAt(value54.CFrame.Position, v169)
	local v171 = 1 - (1 - value55.aimSmoothness) ^ (math.clamp(p12, 0, 0.1) * 60)

	value54.CFrame = value54.CFrame:Lerp(cFrame, v171)
end

t1.value47(t1.value41, t1.value44, t1.value22, t1.value50)
t1.value50 = "Aimbot"
t1.value22 = "task"
task.spawn(function()
	while true do
		task.wait(0.1)

		local cachedCharacter = value55.cachedCharacter
		local cachedHumanoid = value55.cachedHumanoid
		local v174

		if value55.infStamina then
			if value56 then
				value56.stamina = 100
			end

			if cachedCharacter then
				cachedCharacter:SetAttribute("Stamina", 100)
			end

			v174 = value53
			v174:SetAttribute("Stamina", 100)
		else
			v174 = cachedHumanoid
		end

		local autoBelt = value55.autoBelt

		if autoBelt then
			if cachedHumanoid then
				autoBelt = cachedHumanoid.SeatPart

				if autoBelt then
					autoBelt = value18
				end
			else
				autoBelt = cachedHumanoid
			end
		end

		if autoBelt then
			local SeatPart = cachedHumanoid.SeatPart

			if SeatPart:IsA("Seat") or SeatPart:IsA("VehicleSeat") then
				local v177 = SeatPart.FindFirstAncestorOfClass(SeatPart, "Model")

				if cachedCharacter then
					cachedCharacter = cachedCharacter:GetAttribute("Belted") ~= true
				end

				if cachedCharacter then
					value18:FireServer("belt", v177)
				end
			end
		end
	end
end)
t1.value41 = t1.value13({ "General", "Aimbot" }, "General")
t1.value47 = t1.value41.Set
t1.value22 = "General"
t1.value47(t1.value41, "General")

function t1.value50(p13)
	value55.infStamina = p13
end

t1.value15("Player")
t1.value17("Infinite Stamina", t1.value50)
t1.value17("No Fall Damage", function(p14)
	value55.noFallDamage = p14
end)
t1.value17("No Fog", function(p15)
	value43(p15)
end)
t1.value16()
t1.value15("Weapon")
t1.value17("No Recoil", function(p16)
	v86(p16)
end)
t1.value17("No Spread", function(p17)
	value46(p17)
end)
t1.value17("Rapid Fire", function(p18)
	v56(p18)
end)
t1.value16()
t1.value15("Vehicle")
t1.value17("Auto Seatbelt", function(p19)
	value55.autoBelt = p19
end)
t1.value17("Auto Hijack", function(p20)
	value55.autoHijack = p20

	if p20 then
		return
	end

	value55.hijackFiredCycle = false
	value55.hijackLastRot = 0
end)
t1.value16()
t1.value47 = t1.value41.Set
t1.value48 = { "Head", "Torso" }
t1.value47(t1.value41, "Aimbot")
t1.value15("Aimbot")
t1.value17("Enable", function(p21)
	value55.aimEnabled = p21

	if p21 then
		return
	end

	value55.aimTarget = nil
end)
t1.value17("Hide FOV", function(p22)
	value55.drawFov = not p22
end)
t1.value27 = value55.aimTargetPart

function t1.value51(p23)
	value55.aimTargetPart = p23
end

t1.value22 = {
	Text = "Select Target",
	List = t1.value48,
	Default = t1.value27,
	Callback = t1.value51
}
t1.value50 = "Text"
t1.value49 = "List"
t1.value48 = {
	"Smooth",
	"Balanced",
	"Fast",
	"Hard"
}
t1.value19(t1.value22)
t1.value27 = value55.aimMode

function t1.value51(p24)
	value55.aimMode = p24
	value55.aimSmoothness = t2[p24] or 0.22
end

t1.value22 = {
	Text = "Select Mode",
	List = t1.value48,
	Default = t1.value27,
	Callback = t1.value51
}

function t1.value51(p25)
	value55.ignoredPlayers = p25 or {}
end

t1.value19(t1.value22)
t1.value52 = value44()
t1.value47 = t1.value19({
	Text = "Select Ignore Player",
	List = t1.value52,
	Multi = true,
	Callback = t1.value51
})

local value47 = t1.value47

function t1.value47()
	local ignoredPlayers = value55.ignoredPlayers

	value47:Clear()
	value47:Add(value44())
	value47:Set(ignoredPlayers, true)
end

value1.PlayerAdded:Connect(t1.value47)
value1.PlayerRemoving:Connect(t1.value47)
t1.value54 = value55.aimFov

function t1.value28(p26)
	value55.aimFov = p26
end

t1.value18({
	Text = "FOV Radius",
	Min = 50,
	Max = 350,
	Default = t1.value54,
	Callback = t1.value28
})
t1.value54 = value55.aimDistance

function t1.value28(p27)
	value55.aimDistance = p27
end

t1.value18({
	Text = "Max Distance",
	Min = 50,
	Max = 1000,
	Default = t1.value54,
	Callback = t1.value28
})
t1.value16()
t1.value11("Movement", t1.value10.Movement)
t1.value12("Movement")
ShowTab("Movement")
t1.value15("Speed")
t1.value50 = {
	SpeedHumanoid = nil,
	SpeedRootPart = nil,
	SpeedIsEnabled = false,
	SpeedValue = 16,
	SpeedStopCallback = nil,
	SpeedLastRagdoll = 0
}

local value50 = t1.value50

function t1.value49()
	local connection = nil

	local function v182()
		connection:Disconnect()
	end

	connection = value14.Heartbeat:Connect(function()
		if not (value50.SpeedRootPart and value50.SpeedRootPart.Parent) then
			return
		end

		if not value50.SpeedIsEnabled then
			return
		end

		if not value50.SpeedHumanoid or value50.SpeedHumanoid.Health <= 0 then
			return
		end

		if value50.SpeedHumanoid.Sit or value50.SpeedHumanoid.SeatPart then
			return
		end

		local Parent = value50.SpeedRootPart.Parent
		local SpeedHumanoid = value50.SpeedHumanoid
		local state = SpeedHumanoid:GetState()
		local v186

		if Parent then
			v186 = Parent:FindFirstChild("RagdollSocket", true) ~= nil
		else
			v186 = Parent
		end

		if Parent then
			Parent = Parent:GetAttribute("Ragdoll") ~= nil and true or Parent:GetAttribute("Downed") == true
		end

		if Parent or (SpeedHumanoid.PlatformStand or (state == Enum.HumanoidStateType.PlatformStanding or (state == Enum.HumanoidStateType.GettingUp or (state == Enum.HumanoidStateType.FallingDown or (state == Enum.HumanoidStateType.Ragdoll and true or v186))))) then
			value50.SpeedLastRagdoll = os.clock()
			value50.SpeedRootPart.AssemblyLinearVelocity = Vector3.new(0, value50.SpeedRootPart.AssemblyLinearVelocity.Y, 0)

			return
		end

		if os.clock() - value50.SpeedLastRagdoll < 1.2 then
			value50.SpeedRootPart.AssemblyLinearVelocity = Vector3.new(0, value50.SpeedRootPart.AssemblyLinearVelocity.Y, 0)

			return
		end

		local MoveDirection = SpeedHumanoid.MoveDirection

		if MoveDirection.Magnitude > 0.1 then
			value50.SpeedRootPart.AssemblyLinearVelocity = Vector3.new(MoveDirection.X * value50.SpeedValue, value50.SpeedRootPart.AssemblyLinearVelocity.Y, MoveDirection.Z * value50.SpeedValue)

			return
		end

		value50.SpeedRootPart.AssemblyLinearVelocity = Vector3.new(0, value50.SpeedRootPart.AssemblyLinearVelocity.Y, 0)
	end)

	return v182
end

local value49 = t1.value49

function t1.value49(p28)
	value50.SpeedHumanoid = p28:WaitForChild("Humanoid")
	value50.SpeedRootPart = p28:WaitForChild("HumanoidRootPart")

	if not value50.SpeedIsEnabled then
		return
	end

	if value50.SpeedStopCallback then
		value50.SpeedStopCallback()
	end

	value50.SpeedStopCallback = value49()
end

if value53.Character then
	task.spawn(t1.value49, value53.Character)
end

value53.CharacterAdded:Connect(t1.value49)
t1.value17("Enable", function(p29)
	if value50.SpeedIsEnabled == p29 then
		return
	end

	value50.SpeedIsEnabled = p29

	if value50.SpeedStopCallback then
		value50.SpeedStopCallback()
		value50.SpeedStopCallback = nil
	end

	if not value50.SpeedIsEnabled then
		return
	end

	value50.SpeedStopCallback = value49()
end)
t1.value29 = value50.SpeedValue

function t1.value55(p30)
	value50.SpeedValue = p30
end

t1.value18({
	Text = "Speed",
	Min = 16,
	Max = 28,
	Default = t1.value29,
	Callback = t1.value55
})
t1.value16()
t1.value15()
t1.value48 = {
	InfJumpCharacter = nil,
	InfJumpHumanoid = nil,
	InfJumpIsEnabled = false,
	InfJumpStopCallback = nil
}

local value48 = t1.value48

function t1.value27(p31)
	value48.InfJumpCharacter = p31
	value48.InfJumpHumanoid = p31.WaitForChild(p31, "Humanoid")

	if not value48.InfJumpIsEnabled then
		return
	end

	if value48.InfJumpStopCallback then
		value48.InfJumpStopCallback()
	end

	local v190 = value48
	local connection = value12.JumpRequest:Connect(function()
		if not (value48.InfJumpCharacter and value48.InfJumpCharacter.Parent) then
			return
		end

		local InfJumpIsEnabled = value48.InfJumpIsEnabled

		if InfJumpIsEnabled then
			InfJumpIsEnabled = value48.InfJumpHumanoid
		end

		if not InfJumpIsEnabled then
			return
		end

		value48.InfJumpHumanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end)

	function v190.InfJumpStopCallback()
		connection:Disconnect()
	end
end

if value53.Character then
	task.spawn(t1.value27, value53.Character)
end

t1.value26 = value53.CharacterAdded

function t1.value56(p32)
	if value48.InfJumpIsEnabled == p32 then
		return
	end

	value48.InfJumpIsEnabled = p32

	if value48.InfJumpStopCallback then
		value48.InfJumpStopCallback()
		value48.InfJumpStopCallback = nil
	end

	if not value48.InfJumpIsEnabled then
		return
	end

	local v193 = value48
	local connection = value12.JumpRequest:Connect(function()
		if not (value48.InfJumpCharacter and value48.InfJumpCharacter.Parent) then
			return
		end

		local InfJumpIsEnabled = value48.InfJumpIsEnabled

		if InfJumpIsEnabled then
			InfJumpIsEnabled = value48.InfJumpHumanoid
		end

		if not InfJumpIsEnabled then
			return
		end

		value48.InfJumpHumanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end)

	function v193.InfJumpStopCallback()
		connection:Disconnect()
	end
end

t1.value26:Connect(t1.value27)
t1.value17("Infinite Jump", t1.value56)
t1.value16()
t1.value11("Esp", t1.value10.Esp)
t1.value12("Esp")
ShowTab("Esp")
t1.value15("Player ESP")
t1.value26 = {
	IsEnabled = false,
	IsChamsEnabled = false,
	IsNameEnabled = false,
	IsHPEnabled = false,
	IsDistanceEnabled = false,
	MaxDistance = 2000,
	ESPColor = Color3.fromRGB(0, 255, 195)
}

local value26 = nil

function t1.value56()
	local v197 = value1

	for _, player in ipairs(v197.GetPlayers(v197)) do
		if player.Character then
			local PlayerESP_Highlight = player.Character:FindFirstChild("PlayerESP_Highlight")

			if PlayerESP_Highlight then
				PlayerESP_Highlight:Destroy()
			end

			local HumanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")

			if HumanoidRootPart then
				local PlayerESP_Billboard = HumanoidRootPart:FindFirstChild("PlayerESP_Billboard")

				if PlayerESP_Billboard then
					PlayerESP_Billboard:Destroy()
				end
			end
		end
	end
end
function t1.value54(p33)
	local Character = p33.Character

	if not Character then
		return
	end

	local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
	local Humanoid = Character:FindFirstChild("Humanoid")

	if not (HumanoidRootPart and Humanoid) then
		return
	end

	if value26.IsNameEnabled or value26.IsHPEnabled then
		Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	else
		Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
	end

	local Highlight = Instance.new("Highlight")

	Highlight.Name = "PlayerESP_Highlight"
	Highlight.FillColor = value26.ESPColor
	Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
	Highlight.FillTransparency = value26.IsChamsEnabled and 0.5 or 1
	Highlight.Parent = Character

	local BillboardGui = Instance.new("BillboardGui")

	BillboardGui.Name = "PlayerESP_Billboard"
	BillboardGui.Size = UDim2.new(0, 200, 0, 60)
	BillboardGui.StudsOffset = Vector3.new(0, 6, 0)
	BillboardGui.AlwaysOnTop = true

	local UIListLayout = Instance.new("UIListLayout")

	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
	UIListLayout.Parent = BillboardGui

	local TextLabel = Instance.new("TextLabel")

	TextLabel.Size = UDim2.new(1, 0, 0, 16)
	TextLabel.BackgroundTransparency = 1
	TextLabel.TextStrokeTransparency = 0.2
	TextLabel.Font = Enum.Font.SourceSansBold
	TextLabel.TextSize = 14
	TextLabel.Visible = value26.IsHPEnabled
	TextLabel.LayoutOrder = 1
	TextLabel.Parent = BillboardGui

	local TextLabel2 = Instance.new("TextLabel")

	TextLabel2.Size = UDim2.new(1, 0, 0, 16)
	TextLabel2.BackgroundTransparency = 1
	TextLabel2.Text = p33.Name
	TextLabel2.TextColor3 = value26.ESPColor
	TextLabel2.TextStrokeTransparency = 0.2
	TextLabel2.Font = Enum.Font.SourceSansBold
	TextLabel2.TextSize = 14
	TextLabel2.Visible = value26.IsNameEnabled
	TextLabel2.LayoutOrder = 2
	TextLabel2.Parent = BillboardGui

	local TextLabel3 = Instance.new("TextLabel")

	TextLabel3.Size = UDim2.new(1, 0, 0, 16)
	TextLabel3.BackgroundTransparency = 1
	TextLabel3.TextColor3 = Color3.fromRGB(200, 200, 200)
	TextLabel3.TextStrokeTransparency = 0.2
	TextLabel3.Font = Enum.Font.SourceSansBold
	TextLabel3.TextSize = 14
	TextLabel3.Visible = value26.IsDistanceEnabled
	TextLabel3.LayoutOrder = 3
	TextLabel3.Parent = BillboardGui
	BillboardGui.Parent = HumanoidRootPart
	task.spawn(function()
		while true do
			local Parent = BillboardGui

			if Parent then
				Parent = BillboardGui.Parent

				if Parent then
					Parent = Character

					if Parent then
						Parent = Character.Parent
					end
				end
			end

			if not Parent then
				return
			end

			local Character2 = value53.Character

			if Character2 then
				Character2 = value53.Character:FindFirstChild("HumanoidRootPart")
			end

			if Character2 then
				Character2 = (Character2.Position - HumanoidRootPart.Position).Magnitude
			end

			local v214 = Character2 or 0

			if v214 <= value26.MaxDistance then
				Highlight.Enabled = true
				BillboardGui.Enabled = true

				if value26.IsHPEnabled then
					local Health = Humanoid.Health
					local hp = math.floor(Health)

					TextLabel.Text = "HP: " .. hp

					local v217 = hp / Humanoid.MaxHealth
					local v218 = TextLabel
					local color3

					if v217 > 0.6 then
						color3 = Color3.fromRGB(50, 255, 50)
					else
						color3 = false
					end

					if not color3 then
						local color32

						if v217 > 0.3 then
							color32 = Color3.fromRGB(255, 255, 50)
						else
							color32 = false
						end

						color3 = color32 or Color3.fromRGB(255, 50, 50)
					end

					v218.TextColor3 = color3
				end

				if value26.IsDistanceEnabled then
					TextLabel3.Text = math.floor(v214) .. "m"
				end
			else
				Highlight.Enabled = false
				BillboardGui.Enabled = false
			end

			task.wait(0.5)
		end
	end)
end

value26 = t1.value26

local value562 = t1.value56

function t1.value58(p34)
	value26.MaxDistance = p34
end

local value542 = t1.value54

local function v223()
	value562()

	if not value26.IsEnabled then
		return
	end

	local v224 = value1

	for _, player in ipairs(v224.GetPlayers(v224)) do
		if player ~= value53 then
			value542(player)
		end
	end
end

task.spawn(function()
	while true do
		repeat
			task.wait(1)
		until value26.IsEnabled

		v223()
	end
end)
t1.value17("ESP Enable", function(p35)
	value26.IsEnabled = p35
	v223()
end)
t1.value17("Show Chams", function(p36)
	value26.IsChamsEnabled = p36

	if not value26.IsEnabled then
		return
	end

	v223()
end)
t1.value17("Show Name", function(p37)
	value26.IsNameEnabled = p37

	if not value26.IsEnabled then
		return
	end

	v223()
end)
t1.value17("Show HP", function(p38)
	value26.IsHPEnabled = p38

	if not value26.IsEnabled then
		return
	end

	v223()
end)
t1.value17("Show Distance", function(p39)
	value26.IsDistanceEnabled = p39

	if not value26.IsEnabled then
		return
	end

	v223()
end)
t1.value60 = value26.ESPColor

function t1.value61(p40)
	value26.ESPColor = p40

	if not value26.IsEnabled then
		return
	end

	v223()
end

t1.value21({
	Text = "ESP Color",
	Default = t1.value60,
	Callback = t1.value61
})
t1.value18({
	Text = "ESP Distance",
	Min = 50,
	Max = 2000,
	Default = 2000,
	Decimals = 1,
	Callback = t1.value58
})
t1.value16()
t1.value15("Exit ESP")
t1.value61 = Color3.fromRGB(0, 255, 195)

local t5 = {
	IsEnabled = false,
	MaxDistance = 2000,
	ESPColor = t1.value61
}

function t1.value55(p41, p42)
	local raycastParams2 = RaycastParams.new()

	raycastParams2.FilterType = Enum.RaycastFilterType.Include

	local filterDescendantsInstances = { workspace.Terrain }
	local Town = workspace:FindFirstChild("Town")

	if Town then
		table.insert(filterDescendantsInstances, Town)
	end

	raycastParams2.FilterDescendantsInstances = filterDescendantsInstances

	local workspace_ = workspace
	local vector3 = Vector3.new(p41, 800, p42)
	local Vector3_ = Vector3
	local v234 = workspace_.Raycast(workspace_, vector3, Vector3_.new(0, -1600, 0), raycastParams2)
	local Position

	if v234 then
		Position = v234.Position
	else
		Position = v234
	end

	if Position then
		return v234.Position.Y
	end

	local raycastParams3 = RaycastParams.new()

	raycastParams3.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams3.RespectCanCollide = true

	local Position2

	if not value53.Character then
		v271 = workspace:Raycast(Vector3.new(p41, 800, p42), Vector3.new(0, -1600, 0), raycastParams3)

		if v271 then
			Position2 = v271.Position
		else
			Position2 = v271
		end

		if Position2 then
			return v271.Position.Y
		else
			return nil
		end
	end

	raycastParams3.FilterDescendantsInstances = { value53.Character }

	local hit = workspace:Raycast(Vector3.new(p41, 800, p42), Vector3.new(0, -1600, 0), raycastParams3)

	if hit then
		Position2 = hit.Position
	else
		Position2 = hit
	end

	if Position2 then
		return hit.Position.Y
	else
		return nil
	end
end

t1.value53 = {}

function t1.value62(p43)
	t5.MaxDistance = p43
end

local value532 = t1.value53
local Folder = nil

function t1.value59()
	local Parent = Folder

	if Parent then
		Parent = Folder.Parent
	end

	if not Parent then
		return
	end

	Folder:Destroy()
	Folder = nil
end

local value552 = t1.value55

function t1.value60()
	if #value532 > 0 then
		return value532
	end

	local Shared = value16:FindFirstChild("Shared")

	if Shared then
		Shared = Shared:FindFirstChild("MapData")
	end

	if not Shared then
		return value532
	end

	local ok, result = pcall(require, Shared)

	if ok then
		if result then
			local exits = result.exits

			ok = type(exits) == "table"
		else
			ok = result
		end
	end

	if not ok then
		return value532
	end

	for _, exit in ipairs(result.exits) do
		local v249 = exit[1]
		local v250 = exit[2]
		local v251 = exit[3] or "EXIT"
		local v252 = tostring(v251):upper()
		local v253 = value552(v249, v250) or 45
		local v254 = value532
		local t6 = {
			Name = v252,
			X = v249,
			Z = v250,
			Position = Vector3.new(v249, v253 + 6, v250)
		}

		table.insert(v254, t6)
	end

	return value532
end

local value60 = t1.value60

function t1.value61(p44)
	if not (Folder and Folder.Parent) then
		Folder = Instance.new("Folder")
		Folder.Name = "ExitESP_Container"
		Folder.Parent = workspace.Terrain
	end

	local Part = Instance.new("Part")

	Part.Name = "ExitESP_Anchor"
	Part.Size = Vector3.new(1, 1, 1)
	Part.Position = p44.Position
	Part.Anchored = true
	Part.CanCollide = false
	Part.CanQuery = false
	Part.CanTouch = false
	Part.Transparency = 1
	Part.Parent = Folder

	local BillboardGui = Instance.new("BillboardGui")

	BillboardGui.Name = "ExitESP_Billboard"
	BillboardGui.Size = UDim2.new(0, 200, 0, 60)
	BillboardGui.StudsOffset = Vector3.new(0, 4, 0)
	BillboardGui.AlwaysOnTop = true

	local UIListLayout = Instance.new("UIListLayout")

	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
	UIListLayout.Parent = BillboardGui

	local TextLabel = Instance.new("TextLabel")

	TextLabel.Size = UDim2.new(1, 0, 0, 16)
	TextLabel.BackgroundTransparency = 1
	TextLabel.Text = p44.Name
	TextLabel.TextColor3 = t5.ESPColor
	TextLabel.TextStrokeTransparency = 0.2
	TextLabel.Font = Enum.Font.SourceSansBold
	TextLabel.TextSize = 14
	TextLabel.LayoutOrder = 1
	TextLabel.Parent = BillboardGui

	local TextLabel2 = Instance.new("TextLabel")

	TextLabel2.Size = UDim2.new(1, 0, 0, 16)
	TextLabel2.BackgroundTransparency = 1
	TextLabel2.TextColor3 = Color3.fromRGB(200, 200, 200)
	TextLabel2.TextStrokeTransparency = 0.2
	TextLabel2.Font = Enum.Font.SourceSansBold
	TextLabel2.TextSize = 14
	TextLabel2.LayoutOrder = 2
	TextLabel2.Parent = BillboardGui
	BillboardGui.Parent = Part
	task.spawn(function()
		local n1 = 0
		local v263 = n1

		while true do
			local Parent = BillboardGui

			if Parent then
				Parent = BillboardGui.Parent

				if Parent then
					Parent = Part

					if Parent then
						Parent = Part.Parent
					end
				end
			end

			if not Parent then
				return
			end

			n1 = os.clock

			local v265 = n1()
			local Character = value53.Character

			if Character then
				Character = value53.Character:FindFirstChild("HumanoidRootPart")
			end

			local Magnitude = Character and (Character.Position - Part.Position).Magnitude or 0

			if v265 - v263 >= 1 then
				local v268 = value552(p44.X, p44.Z)
				local v269

				if v268 then
					local v270 = v268 + 6 - Part.Position.Y

					v269 = math.abs(v270) > 1
				else
					v269 = v268
				end

				if v269 then
					Part.Position = Vector3.new(p44.X, v268 + 6, p44.Z)
				end
			else
				v265 = v263
			end

			if Magnitude <= t5.MaxDistance then
				BillboardGui.Enabled = true
				TextLabel2.Text = math.floor(Magnitude) .. "m"
			else
				BillboardGui.Enabled = false
			end

			task.wait(0.25)
			v263 = v265
		end
	end)
end

local value59 = t1.value59
local value61 = t1.value61

local function v273()
	value59()

	if not t5.IsEnabled then
		return
	end

	local v274 = value60()

	for _, v in ipairs(v274) do
		value61(v)
	end
end

t1.value63 = value53.CharacterAdded

function t1.value57()
	if not t5.IsEnabled then
		return
	end

	task.wait(1)
	v273()
end

t1.value63:Connect(t1.value57)
t1.value17("ESP Enable", function(p45)
	t5.IsEnabled = p45
	v273()
end)
t1.value58 = t5.ESPColor

function t1.value64(p46)
	t5.ESPColor = p46

	if not Folder then
		return
	end

	local v277 = Folder

	for _, child in ipairs(v277.GetChildren(v277)) do
		local TextLabel = child.FindFirstChild(child, "ExitESP_Billboard")

		if TextLabel then
			TextLabel = TextLabel:FindFirstChildOfClass("TextLabel")
		end

		if TextLabel then
			TextLabel.TextColor3 = p46
		end
	end
end

t1.value21({
	Text = "ESP Color",
	Default = t1.value58,
	Callback = t1.value64
})
t1.value18({
	Text = "ESP Distance",
	Min = 50,
	Max = 2000,
	Default = 2000,
	Decimals = 1,
	Callback = t1.value62
})
t1.value16()
t1.value11("Teleport", t1.value10.Teleport)
t1.value12("Teleport")
ShowTab("Teleport")
t1.value23()
task.spawn(function()
	value14.RenderStepped:Wait()
	task.wait(0.1)
	ShowTab("Main")
end)
