-- This file was generated at discord.gg/syncrypt

local VerifySosiskomras = getgenv().VerifySosiskomras

if type(VerifySosiskomras) ~= "function" then
	return
end

local v3 = math.random(100000, 999999)
local v4 = game.GameId + 1
local v5 = bit32.bxor(v4, v3) * 3 + 52

if tostring(v5) ~= getgenv().VerifySosiskomras(v3) then
	return
end

local now = os.clock()

while not getgenv().SosiskomrasHub do
	if os.clock() - now > 10 then
		return
	end

	task.wait(0.1)
end

local SosiskomrasHub = getgenv().SosiskomrasHub

getgenv().SosiskomrasHub = nil

local _ = SosiskomrasHub.ScreenGui
local _ = SosiskomrasHub.mainFrame
local _ = SosiskomrasHub.sidebarHeaderText
local sidebarSubheaderText = SosiskomrasHub.sidebarSubheaderText
local AppImages = SosiskomrasHub.AppImages
local CreateSidebarButton = SosiskomrasHub.CreateSidebarButton
local CreateTab = SosiskomrasHub.CreateTab
local ShowTab = SosiskomrasHub.ShowTab
local t1 = {
	value1 = SosiskomrasHub.CreateSubTabs,
	value2 = SosiskomrasHub.CreateBlock
}
local EndBlock = SosiskomrasHub.EndBlock

t1.value3 = "saveMode"
t1.value4 = EndBlock

local _ = SosiskomrasHub.CreateButton

t1.value5 = SosiskomrasHub.CreateToggle
t1.value6 = SosiskomrasHub.CreateSlider
t1.value7 = SosiskomrasHub.CreateDropdown
t1.value8 = SosiskomrasHub.CreateColorPicker

local _ = SosiskomrasHub.CreateInput

t1.value9 = SosiskomrasHub.CreateWaypointSystem
t1.value10 = SosiskomrasHub.CreateSpectateSystem

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

t1.value12 = {}

local UserInputService = game:GetService("UserInputService")

t1.value13 = false

local game_ = game
local GetService = game_.GetService

t1.value14 = "autoSaveEnabled"
GetService(game_, "TweenService")
game:GetService("VirtualInputManager")

local game_2 = game

t1.value15 = "emergencyFly"
game_2:GetService("VirtualUser")

local RunService = game:GetService("RunService")
local game_3 = game
local GetService2 = game_3.GetService

t1.value17 = {}
GetService2(game_3, "Lighting")

local _ = workspace.CurrentCamera
local game_4 = game

t1.value18 = {}
t1.value19 = "currentTarget"
t1.value20 = game_4:GetService("ReplicatedStorage")
t1.value21 = "isSaving"
game:GetService("HttpService")
game:GetService("TeleportService")
sidebarSubheaderText.Text = "Bug Evolution"
CreateSidebarButton("Main", AppImages.Main)
CreateTab("Main")
ShowTab("Main")
t1.value23 = 0
t1.value22 = false
t1.value24 = {}

local t2 = {
	autoFarmEnabled = t1.value22,
	autoKillEnabled = false,
	autoSaveEnabled = t1.value13,
	isSaving = false,
	emergencyFly = false,
	emergencyTimer = t1.value23,
	saveMode = "Farm Heal",
	currentTarget = nil,
	currentTargetPart = nil,
	targetOffset = 4,
	farmSelection = {},
	ignoredPlayers = {},
	playerKillCooldowns = t1.value24,
	lastTarget = nil,
	lastTargetHp = 0,
	stuckCheckTime = 0,
	blacklistedTargets = t1.value17,
	breakablesCache = t1.value12,
	bugsCache = t1.value18,
	hasResetToSurface = false
}

t1.value11 = 8
t1.value23 = 1
t1.value13 = 8
t1.value25 = t1.value20:WaitForChild("Remotes", 8)
t1.value21 = 8
t1.value14 = "Breakables"

local Attack = t1.value25:WaitForChild("Attack", 8)
local Breakables = workspace:WaitForChild("Breakables", t1.value13)

t1.value13 = "Bugs"
t1.value14 = Breakables

local Bugs = workspace:WaitForChild("Bugs", t1.value21)

t1.value21 = "Map"
t1.value13 = Bugs

local Map = workspace:WaitForChild("Map", t1.value11)

t1.value11 = "Instance"
t1.value3 = 16
t1.value21 = Map

local Part = Instance.new("Part")

t1.value15 = "FarmPlatform"
Part.Name = "FarmPlatform"
t1.value26 = Vector3.new(16, t1.value23, t1.value3)
Part.Size = t1.value26
Part.Transparency = 1
t1.value15 = true
Part.Anchored = t1.value15
Part.CanCollide = true

local Part2 = Instance.new("Part")

Part2.Name = "SafeZonePlatform"
t1.value26 = Vector3.new
t1.value23 = 24
t1.value3 = 2
t1.value27 = t1.value26(t1.value23, t1.value3, 24)
Part2.Size = t1.value27
Part2.Transparency = 0.5
t1.value27 = Color3
t1.value3 = 255
t1.value23 = "fromRGB"
t1.value27 = t1.value27.fromRGB(0, t1.value3, 200)
Part2.Color = t1.value27
Part2.Anchored = true
Part2.CanCollide = true
t1.value3 = "RaycastParams"

local v37 = nil
local raycastParams = RaycastParams.new()

t1.value28 = Enum.RaycastFilterType.Include
raycastParams.FilterType = t1.value28
t1.value16 = t1.value21
t1.value19 = raycastParams

if t1.value21 then
	t1.value16 = { workspace.Terrain, t1.value21 }
end

t1.value28 = t1.value16

if not t1.value16 then
	t1.value28 = { workspace.Terrain }
end

t1.value19.FilterDescendantsInstances = t1.value28

function t1.value28(p1, p2)
	local hit = workspace:Raycast(Vector3.new(p1, 500, p2), Vector3.new(0, -1000, 0), raycastParams)

	if hit then
		return hit.Position + Vector3.new(0, 32, 0)
	else
		return Vector3.new(p1, 80, p2)
	end
end

local v40 = t1.value28(0, 0)

local function v41(p3, p4)
	local isModel

	if p3 then
		isModel = p3:IsA("Model")
	else
		isModel = p3
	end

	local attribute, v44

	if isModel then
		local extentsSize = p3:GetExtentsSize()

		if extentsSize.Y > 0 then
			return extentsSize.Y
		else
			attribute = p3 and p3:GetAttribute("Scale") or 1

			if p4 then
				v44 = p4.Size.Y > 0
			else
				v44 = p4
			end

			if v44 then
				return math.max(p4.Size.Y, attribute * 2)
			else
				return attribute * 2
			end
		end
	else
		attribute = p3 and p3:GetAttribute("Scale") or 1

		if p4 then
			v44 = p4.Size.Y > 0
		else
			v44 = p4
		end

		if v44 then
			return math.max(p4.Size.Y, attribute * 2)
		else
			return attribute * 2
		end
	end
end
local function v46(p5)
	if #t2.farmSelection == 0 then
		return false
	end

	if table.find(t2.farmSelection, "All") then
		return true
	end

	local attribute = p5:GetAttribute("BugId")
	local v48, pos

	if attribute then
	elseif attribute then
		return true
	else
		v48 = p5.GetAttribute(p5, "BreakId")

		for _, v in ipairs(t2.farmSelection) do
			if p5.Name:find(v) then
				return true
			end

			if v48 then
				pos = v48 == v or v:find(v48)
			else
				pos = v48
			end

			if pos then
				return true
			end
		end

		return false
	end

	attribute = table.find(t2.farmSelection, attribute)

	if attribute then
		return true
	else
		v48 = p5.GetAttribute(p5, "BreakId")

		for _, v in ipairs(t2.farmSelection) do
			if p5.Name:find(v) then
				return true
			end

			if v48 then
				pos = v48 == v or v:find(v48)
			else
				pos = v48
			end

			if pos then
				return true
			end
		end

		return false
	end
end
local function v54(p6)
	if not (p6 and p6.Parent) then
		return false
	end

	local playerFromCharacter, attribute, v57

	if not t2.blacklistedTargets[p6] then
		v55 = p6:FindFirstChildOfClass("Humanoid")

		if v55 then
			if v55.Health <= 0 then
				return false
			else
				playerFromCharacter = Players:GetPlayerFromCharacter(p6)

				if playerFromCharacter then
					if playerFromCharacter:GetAttribute("Alive") then
						if playerFromCharacter:GetAttribute("Shielded") or (p6:GetAttribute("Shielded") or p6:GetAttribute("Protected")) then
							return false
						else
							return true
						end
					else
						return false
					end
				else
					return true
				end
			end
		else
			attribute = p6:GetAttribute("HP")

			if attribute == nil then
				v57 = false
			else
				v57 = attribute <= 0
			end

			return not v57
		end
	end

	if os.clock() < t2.blacklistedTargets[p6] then
		return false
	end

	t2.blacklistedTargets[p6] = nil

	local Humanoid = p6:FindFirstChildOfClass("Humanoid")

	if Humanoid then
		if Humanoid.Health <= 0 then
			return false
		else
			playerFromCharacter = Players:GetPlayerFromCharacter(p6)

			if playerFromCharacter then
				if playerFromCharacter:GetAttribute("Alive") then
					if playerFromCharacter:GetAttribute("Shielded") or (p6:GetAttribute("Shielded") or p6:GetAttribute("Protected")) then
						return false
					else
						return true
					end
				else
					return false
				end
			else
				return true
			end
		end
	else
		attribute = p6:GetAttribute("HP")

		if attribute == nil then
			v57 = false
		else
			v57 = attribute <= 0
		end

		return not v57
	end
end

function t1.value29(p7)
	local isModel = p7:IsA("Model")

	if isModel then
		isModel = not p7:GetAttribute("SpiderEgg")
	end

	if not isModel then
		return
	end

	local attribute = p7:GetAttribute("HP")
	local PrimaryPart = (attribute == nil and true or attribute > 0) and (p7.PrimaryPart or (p7:FindFirstChild("Hitbox") or (p7:FindFirstChild("HumanoidRootPart") or p7:FindFirstChildWhichIsA("BasePart"))))

	if not PrimaryPart then
		return
	end

	t2.breakablesCache[p7] = PrimaryPart
end
function t1.value30(p8)
	if not p8:IsA("Model") then
		return
	end

	local FindFirstChild = p8.FindFirstChild
	local Humanoid = p8:FindFirstChildOfClass("Humanoid")
	local humanoidRootPart = FindFirstChild(p8, "HumanoidRootPart") or p8.PrimaryPart
	local v65

	if Humanoid then
		if Humanoid.Health > 0 then
			v65 = humanoidRootPart
		else
			v65 = false
		end
	else
		v65 = Humanoid
	end

	if not v65 then
		return
	end

	t2.bugsCache[p8] = {
		Root = humanoidRootPart,
		Humanoid = Humanoid
	}
end

t1.value31 = t1.value14.GetChildren

local function v66()
	local Character = LocalPlayer.Character

	if Character then
		Character = Character:FindFirstChild("HumanoidRootPart")
	end

	if not Character then
		return
	end

	Character.AssemblyLinearVelocity = Vector3.zero
	Character.CFrame = CFrame.new(v40)
	task.defer(function()
		local Character2 = LocalPlayer.Character

		if not Character2 then
			return
		end

		for _, descendant in ipairs(Character2:GetDescendants()) do
			if descendant:IsA("BasePart") then
				descendant.CanCollide = true
			end
		end
	end)
end
local function v71()
	if v37 then
		local v72 = v37:Get() or {}
		local v73 = Players
		local t3 = {}

		for _, player in ipairs(v73.GetPlayers(v73)) do
			if player ~= LocalPlayer then
				local Name = player.Name

				table.insert(t3, Name)
			end
		end

		table.sort(t3)
		v37:Clear()
		v37:Add(t3)
		v37:Set(v72, true)
	end
end
local function v78(p9)
	if p9 and p9.Parent then
		local Humanoid = p9:FindFirstChildOfClass("Humanoid")

		if Humanoid then
			return Humanoid.Health
		else
			local attribute = p9:GetAttribute("HP")

			return attribute == nil and 1 or attribute
		end
	else
		return 0
	end
end
local function v81()
	local Character = LocalPlayer.Character
	local Position, pairs_, huge, v86, Root, Parent, v89, v90, v91, Parent2, v93, Magnitude

	if Character then
	elseif Character then
		Position = Character.Position
		pairs_ = pairs
		huge = math.huge
		v86 = nil
		Root = nil

		for k, v in pairs_(t2.breakablesCache) do
			Parent = k.Parent

			if Parent then
				Parent = v.Parent
			end

			if Parent then
				pairs_ = k:GetAttribute("HP")
				v89 = pairs_ == nil and true or pairs_ > 0

				if v89 then
					v89 = v54(k)

					if v89 then
						v89 = v46(k)
					end
				end

				if v89 then
					pairs_ = (v.Position - Position).Magnitude

					if pairs_ < huge then
						Root = v
						v86 = k
						huge = pairs_
						pairs_ = v86
						v90 = v86
						v86 = pairs_
						v90 = pairs_
						pairs_ = v86
						v90 = huge
					end
				else
					if pairs_ == nil then
						v91 = false
					else
						v91 = pairs_ <= 0
					end

					if v91 then
						t2.breakablesCache[k] = nil
					end
				end
			else
				t2.breakablesCache[k] = nil
			end
		end

		for k, v in pairs(t2.bugsCache) do
			Parent2 = k.Parent

			if Parent2 then
				Parent2 = v.Root

				if Parent2 then
					Parent2 = v.Root.Parent

					if Parent2 then
						Parent2 = v.Humanoid

						if Parent2 then
							Parent2 = v.Humanoid.Parent

							if Parent2 then
								Parent2 = v.Humanoid.Health > 0
							end
						end
					end
				end
			end

			if Parent2 then
				v93 = v54(k)

				if v93 then
					v93 = v46(k)
				end

				if v93 then
					Magnitude = (v.Root.Position - Position).Magnitude

					if Magnitude < huge then
						Root = v.Root
						v86 = k
						huge = Magnitude
					end
				end
			else
				t2.bugsCache[k] = nil
			end
		end

		return v86, Root
	else
		return nil, nil
	end

	Character = Character:FindFirstChild("HumanoidRootPart")

	if Character then
		Position = Character.Position
		pairs_ = pairs
		huge = math.huge
		v86 = nil
		Root = nil

		for k, v in pairs_(t2.breakablesCache) do
			Parent = k.Parent

			if Parent then
				Parent = v.Parent
			end

			if Parent then
				pairs_ = k:GetAttribute("HP")
				v89 = pairs_ == nil and true or pairs_ > 0

				if v89 then
					v89 = v54(k)

					if v89 then
						v89 = v46(k)
					end
				end

				if v89 then
					pairs_ = (v.Position - Position).Magnitude

					if pairs_ < huge then
						Root = v
						v86 = k
						huge = pairs_
						pairs_ = v86
						v90 = v86
						v86 = pairs_
						v90 = pairs_
						pairs_ = v86
						v90 = huge
					end
				else
					if pairs_ == nil then
						v91 = false
					else
						v91 = pairs_ <= 0
					end

					if v91 then
						t2.breakablesCache[k] = nil
					end
				end
			else
				t2.breakablesCache[k] = nil
			end
		end

		for k, v in pairs(t2.bugsCache) do
			Parent2 = k.Parent

			if Parent2 then
				Parent2 = v.Root

				if Parent2 then
					Parent2 = v.Root.Parent

					if Parent2 then
						Parent2 = v.Humanoid

						if Parent2 then
							Parent2 = v.Humanoid.Parent

							if Parent2 then
								Parent2 = v.Humanoid.Health > 0
							end
						end
					end
				end
			end

			if Parent2 then
				v93 = v54(k)

				if v93 then
					v93 = v46(k)
				end

				if v93 then
					Magnitude = (v.Root.Position - Position).Magnitude

					if Magnitude < huge then
						Root = v.Root
						v86 = k
						huge = Magnitude
					end
				end
			else
				t2.bugsCache[k] = nil
			end
		end

		return v86, Root
	else
		return nil, nil
	end
end
local function v103(child)
	t2.bugsCache[child] = nil
end
local function v104()
	local Character = LocalPlayer.Character
	local Position, attribute, v108, huge, huge2, v111, v112, v113, v114, v115, Character2, Humanoid, GetAttribute, HumanoidRootPart, shielded, Magnitude

	if Character then
	elseif Character then
		Position = Character.Position
		attribute = LocalPlayer:GetAttribute("TeamId")
		v108 = Players
		huge = math.huge
		huge2 = math.huge
		v111 = nil
		v112 = nil
		v113 = nil
		v114 = nil

		for _, player in ipairs(v108.GetPlayers(v108)) do
			v115 = player ~= LocalPlayer

			if v115 then
				v115 = player.Character

				if v115 then
					v115 = player:GetAttribute("Alive")
				end
			end

			if v115 and not table.find(t2.ignoredPlayers, player.Name) and (not attribute or attribute ~= player.GetAttribute(player, "TeamId")) then
				Character2 = player.Character
				Humanoid = Character2:FindFirstChildOfClass("Humanoid")
				GetAttribute = player.GetAttribute
				HumanoidRootPart = Character2:FindFirstChild("HumanoidRootPart")
				shielded = GetAttribute(player, "Shielded") or (Character2:GetAttribute("Shielded") or Character2:GetAttribute("Protected"))

				if Humanoid then
					Humanoid = Humanoid.Health > 0

					if Humanoid then
						Humanoid = HumanoidRootPart and not shielded

						if Humanoid then
							Humanoid = v54(Character2)
						end
					end
				end

				if Humanoid then
					Magnitude = (HumanoidRootPart.Position - Position).Magnitude

					if not t2.playerKillCooldowns[player.UserId] or os.clock() > t2.playerKillCooldowns[player.UserId] then
						if Magnitude < huge2 then
							v112 = HumanoidRootPart
							v111 = Character2
							huge2 = Magnitude
						end
					elseif Magnitude < huge then
						v114 = HumanoidRootPart
						v113 = Character2
						huge = Magnitude
					end
				end
			end
		end

		if v111 then
			return v111, v112
		else
			return v113, v114
		end
	else
		return nil, nil
	end

	Character = Character:FindFirstChild("HumanoidRootPart")

	if Character then
		Position = Character.Position
		attribute = LocalPlayer:GetAttribute("TeamId")
		v108 = Players
		huge = math.huge
		huge2 = math.huge
		v111 = nil
		v112 = nil
		v113 = nil
		v114 = nil

		for _, player in ipairs(v108.GetPlayers(v108)) do
			v115 = player ~= LocalPlayer

			if v115 then
				v115 = player.Character

				if v115 then
					v115 = player:GetAttribute("Alive")
				end
			end

			if v115 and not table.find(t2.ignoredPlayers, player.Name) and (not attribute or attribute ~= player.GetAttribute(player, "TeamId")) then
				Character2 = player.Character
				Humanoid = Character2:FindFirstChildOfClass("Humanoid")
				GetAttribute = player.GetAttribute
				HumanoidRootPart = Character2:FindFirstChild("HumanoidRootPart")
				shielded = GetAttribute(player, "Shielded") or (Character2:GetAttribute("Shielded") or Character2:GetAttribute("Protected"))

				if Humanoid then
					Humanoid = Humanoid.Health > 0

					if Humanoid then
						Humanoid = HumanoidRootPart and not shielded

						if Humanoid then
							Humanoid = v54(Character2)
						end
					end
				end

				if Humanoid then
					Magnitude = (HumanoidRootPart.Position - Position).Magnitude

					if not t2.playerKillCooldowns[player.UserId] or os.clock() > t2.playerKillCooldowns[player.UserId] then
						if Magnitude < huge2 then
							v112 = HumanoidRootPart
							v111 = Character2
							huge2 = Magnitude
						end
					elseif Magnitude < huge then
						v114 = HumanoidRootPart
						v113 = Character2
						huge = Magnitude
					end
				end
			end
		end

		if v111 then
			return v111, v112
		else
			return v113, v114
		end
	else
		return nil, nil
	end
end
local function v126(p10, p11, p12)
	local Character = LocalPlayer.Character
	local attribute

	if Character then
		attribute = Character:GetAttribute("Scale")
	else
		attribute = Character
	end

	local v129 = attribute or 1
	local v130 = v41
	local HumanoidRootPart

	if Character then
		HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
	else
		HumanoidRootPart = Character
	end

	local v132 = v130(Character, HumanoidRootPart)
	local v133 = v41(p10, p11)

	if p12 then
		local v134 = v132 * 0.45
		local v135 = v133 * 0.45 + v134 + 1.2 * v129

		return math.clamp(v135, 3.5, 20)
	else
		local v136 = v132 * 0.4
		local math_ = math
		local v138 = v133 * 0.4 + v136 + 1 * v129

		return math_.clamp(v138, 2.8, 16)
	end
end
local function v139(child)
	t2.breakablesCache[child] = nil
end

for _, v in ipairs(t1.value31(t1.value14)) do
	t1.value29(v)
end

for _, child in ipairs(t1.value13.GetChildren(t1.value13)) do
	t1.value30(child)
end

local ChildAdded = t1.value14.ChildAdded
local Connect = ChildAdded.Connect

t1.value31 = "Select Target"
Connect(ChildAdded, t1.value29)
t1.value14.ChildRemoved:Connect(v139)
t1.value13.ChildAdded:Connect(t1.value30)
t1.value13.ChildRemoved:Connect(v103)
RunService.Stepped:Connect(function()
	local autoFarmEnabled = t2.autoFarmEnabled or t2.autoKillEnabled
	local emergencyFly = t2.emergencyFly

	if not emergencyFly then
		emergencyFly = t2.isSaving

		if emergencyFly then
			emergencyFly = t2.saveMode == "Platform Heal"
		end
	end

	if emergencyFly then
		autoFarmEnabled = false
	end

	local Character = autoFarmEnabled and LocalPlayer.Character

	if not Character then
		return
	end

	for _, descendant in ipairs(Character.GetDescendants(Character)) do
		local isBasePart = descendant:IsA("BasePart")

		if isBasePart then
			isBasePart = descendant ~= Part

			if isBasePart then
				isBasePart = descendant ~= Part2
			end
		end

		if isBasePart then
			descendant.CanCollide = false
		end
	end
end)
RunService.Heartbeat:Connect(function()
	local Character = LocalPlayer.Character
	local HumanoidRootPart

	if Character then
		HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
	else
		HumanoidRootPart = Character
	end

	local Humanoid

	if Character then
		Humanoid = Character:FindFirstChildOfClass("Humanoid")
	else
		Humanoid = Character
	end

	if not HumanoidRootPart or (not Humanoid or Humanoid.Health <= 0) then
		if not Part.Parent then
			t2.currentTarget = nil
			t2.currentTargetPart = nil

			return
		end

		Part.Parent = nil
		t2.currentTarget = nil
		t2.currentTargetPart = nil

		return
	end

	local isSaving = t2.isSaving

	if isSaving then
		isSaving = t2.saveMode == "Platform Heal"
	end

	if isSaving or t2.emergencyFly then
		if not Part.Parent then
			t2.currentTarget = nil
			t2.currentTargetPart = nil
			HumanoidRootPart.CFrame = CFrame.new(Part2.Position + Vector3.new(0, 3, 0))
			HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero

			return
		end

		Part.Parent = nil
		t2.currentTarget = nil
		t2.currentTargetPart = nil
		HumanoidRootPart.CFrame = CFrame.new(Part2.Position + Vector3.new(0, 3, 0))
		HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero

		return
	end

	local autoFarmEnabled = t2.autoFarmEnabled

	if not autoFarmEnabled then
		autoFarmEnabled = t2.isSaving

		if autoFarmEnabled then
			autoFarmEnabled = t2.saveMode == "Farm Heal"
		end
	end

	local autoKillEnabled = t2.autoKillEnabled

	if autoKillEnabled then
		autoKillEnabled = not t2.isSaving
	end

	if autoKillEnabled then
		if not (v54(t2.currentTarget) and t2.currentTarget:FindFirstChildOfClass("Humanoid")) then
			local currentTarget = t2.currentTarget

			if currentTarget then
				currentTarget = t2.currentTarget:FindFirstChildOfClass("Humanoid")
			end

			local playerFromCharacter = currentTarget and (t2.currentTarget:FindFirstChildOfClass("Humanoid").Health <= 0 and Players:GetPlayerFromCharacter(t2.currentTarget))

			if playerFromCharacter then
				t2.playerKillCooldowns[playerFromCharacter.UserId] = os.clock() + 20
			end

			local v160 = t2
			local v161 = t2
			local v162, v163 = v104()

			v160.currentTarget = v162
			v161.currentTargetPart = v163

			local currentTarget2 = t2.currentTarget

			if currentTarget2 then
				currentTarget2 = t2.currentTargetPart
			end

			if currentTarget2 then
				t2.targetOffset = v126(t2.currentTarget, t2.currentTargetPart, true)
				t2.lastTarget = t2.currentTarget
				t2.lastTargetHp = v78(t2.currentTarget)
				Character = t2
				Character.stuckCheckTime = os.clock()
			else
				t2.currentTarget = nil
				Character = t2
				Character.currentTargetPart = nil
			end
		end
	elseif autoFarmEnabled then
		if not v54(t2.currentTarget) then
			local v165 = t2
			local v166 = t2
			local v167, v168 = v81()

			v165.currentTarget = v167
			v166.currentTargetPart = v168

			local currentTarget = t2.currentTarget

			if currentTarget then
				currentTarget = t2.currentTargetPart
			end

			if currentTarget then
				t2.targetOffset = v126(t2.currentTarget, t2.currentTargetPart, false)
				t2.lastTarget = t2.currentTarget
				t2.lastTargetHp = v78(t2.currentTarget)
				Character = t2
				Character.stuckCheckTime = os.clock()
			else
				t2.currentTarget = nil
				Character = t2
				Character.currentTargetPart = nil
			end
		end
	else
		t2.currentTarget = nil
		Character = t2
		Character.currentTargetPart = nil

		if Part.Parent then
			Character = Part
			Character.Parent = nil
		end
	end

	local v170 = autoKillEnabled or autoFarmEnabled

	if v170 then
		v170 = not (t2.currentTarget and (t2.currentTargetPart and t2.currentTargetPart.Parent))
	end

	if v170 then
		if Part.Parent then
			Part.Parent = nil
		end

		t2.currentTarget = nil
		t2.currentTargetPart = nil

		if t2.hasResetToSurface then
			return
		end

		t2.hasResetToSurface = true
		v66()
	else
		t2.hasResetToSurface = false

		local currentTarget = t2.currentTarget

		if currentTarget then
			currentTarget = t2.currentTargetPart

			if currentTarget then
				currentTarget = t2.currentTargetPart.Parent
			end
		end

		if currentTarget then
			local v172 = t2.currentTargetPart.Position - Vector3.new(0, t2.targetOffset, 0)
			local _, v174 = t2.currentTargetPart.CFrame:ToOrientation()

			Part.Parent = workspace
			Part.CFrame = CFrame.new(v172 - Vector3.new(0, 2, 0))
			HumanoidRootPart.CFrame = CFrame.new(v172) * CFrame.Angles(0, v174, 0)
			HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero

			return
		end

		if not Part.Parent then
			return
		end

		Part.Parent = nil
	end
end)
task.spawn(function()
	while true do
		task.wait(0.12)

		local v176 = not t2.emergencyFly

		if v176 then
			v176 = not t2.isSaving or t2.saveMode == "Farm Heal"
		end

		if v176 then
			v176 = t2.currentTarget

			if v176 then
				v176 = v54(t2.currentTarget)
			end
		end

		if v176 then
			local v177 = v78(t2.currentTarget)

			if t2.lastTarget == t2.currentTarget then
				if v177 < t2.lastTargetHp then
					t2.lastTargetHp = v177
					t2.stuckCheckTime = os.clock()
				elseif os.clock() - t2.stuckCheckTime >= 2.5 then
					t2.blacklistedTargets[t2.currentTarget] = os.clock() + 10
					t2.currentTarget = nil
					t2.currentTargetPart = nil
				end
			else
				t2.lastTarget = t2.currentTarget
				t2.lastTargetHp = v177
				t2.stuckCheckTime = os.clock()
			end

			local currentTarget = t2.currentTarget

			if currentTarget then
				currentTarget = v54(t2.currentTarget)
			end

			if currentTarget then
				pcall(function()
					Attack:FireServer(t2.currentTarget)
				end)
			end
		end
	end
end)
task.spawn(function()
	local n1 = 1000

	while true do
		task.wait(0.15)

		local Health

		if t2.autoSaveEnabled then
			local Character = LocalPlayer.Character
			local HumanoidRootPart

			if Character then
				HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
			else
				HumanoidRootPart = Character
			end

			if Character then
				Character = Character:FindFirstChildOfClass("Humanoid")
			end

			local v183

			if HumanoidRootPart then
				if Character then
					v183 = Character.Health > 0
				else
					v183 = Character
				end
			else
				v183 = HumanoidRootPart
			end

			if v183 then
				Health = Character.Health

				local MaxHealth = Character.MaxHealth
				local MaxHealth2 = Character.MaxHealth
				local v186 = Health / MaxHealth
				local v187 = n1 - Health >= MaxHealth2 * 0.12
				local v188 = t2.saveMode == "Farm Heal"

				if v188 then
					v188 = t2.isSaving or v186 <= 0.3
				end

				if v188 then
					local v189 = not t2.emergencyFly

					if v189 then
						v189 = v186 <= 0.2 and true or v187
					end

					if v189 then
						t2.emergencyFly = true
						t2.isSaving = true

						if t2.currentTarget then
							t2.blacklistedTargets[t2.currentTarget] = os.clock() + 15
							t2.currentTarget = nil
							t2.currentTargetPart = nil
						end

						local v190 = HumanoidRootPart.Position + Vector3.new(0, 350, 0)

						Part2.CFrame = CFrame.new(v190 - Vector3.new(0, 2, 0))
						Part2.Parent = workspace
						HumanoidRootPart.CFrame = CFrame.new(v190)
						HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
						t2.emergencyTimer = os.clock() + 2
					end
				end

				local v191 = not t2.isSaving

				if v191 then
					v191 = v186 <= 0.3
				end

				if v191 then
					t2.isSaving = true
					t2.currentTarget = nil
					t2.currentTargetPart = nil

					if t2.saveMode == "Platform Heal" then
						local v192 = HumanoidRootPart.Position + Vector3.new(0, 350, 0)

						Part2.CFrame = CFrame.new(v192 - Vector3.new(0, 2, 0))
						Part2.Parent = workspace
						HumanoidRootPart.CFrame = CFrame.new(v192)
						HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
					elseif t2.saveMode == "Farm Heal" then
						Part2.Parent = nil
					end
				else
					local emergencyFly = t2.emergencyFly

					if emergencyFly then
						emergencyFly = os.clock() >= t2.emergencyTimer
					end

					if emergencyFly then
						local v194, v195 = v81()

						if v194 and v195 then
							t2.currentTarget = v194
							t2.currentTargetPart = v195
							t2.targetOffset = v126(v194, v195, false)
							t2.emergencyFly = false
							Part2.Parent = nil
						end
					else
						local isSaving = t2.isSaving

						if isSaving then
							isSaving = v186 >= 0.85
						end

						if isSaving then
							if Part2.Parent then
								Part2.Parent = nil
							end

							t2.isSaving = false
							t2.emergencyFly = false

							if t2.saveMode == "Platform Heal" then
								v66()
							end
						end
					end
				end
			elseif t2.isSaving or t2.emergencyFly then
				if Part2.Parent then
					Part2.Parent = nil
				end

				t2.isSaving = false
				t2.emergencyFly = false
				Health = n1
			else
				Health = n1
			end
		elseif t2.isSaving or t2.emergencyFly then
			if Part2.Parent then
				Part2.Parent = nil
			end

			t2.isSaving = false
			t2.emergencyFly = false
			Health = n1
		else
			Health = n1
		end

		n1 = Health
	end
end)
t1.value2("Auto Farm")
t1.value5("Enable", function(p13)
	t2.autoFarmEnabled = p13
	t2.currentTarget = nil
	t2.currentTargetPart = nil
	t2.hasResetToSurface = false

	if p13 then
		return
	end

	if Part.Parent then
		Part.Parent = nil
	end

	if t2.autoKillEnabled then
		return
	end

	v66()
end)
t1.value17 = {
	"All",
	"Ant",
	"Beetle",
	"Caterpillar",
	"Centipede",
	"Acorn",
	"Silk Cocoon",
	"Golden Cocoon",
	"Puffball",
	"Sugar Cube",
	"Egg Cluster",
	"Silk Stash"
}
t1.value7({
	Text = "Select Target",
	List = t1.value17,
	Default = { "All" },
	Multi = true,
	Callback = function(p14)
		t2.farmSelection = p14
		t2.currentTarget = nil
		t2.currentTargetPart = nil
	end
})
t1.value4()
t1.value2("Auto Kill Player")
t1.value5("Enable", function(p15)
	t2.autoKillEnabled = p15
	t2.currentTarget = nil
	t2.currentTargetPart = nil
	t2.hasResetToSurface = false

	if p15 then
		return
	end

	if Part.Parent then
		Part.Parent = nil
	end

	if t2.autoFarmEnabled then
		return
	end

	v66()
end)

local _ = t1.value7({
	Text = "Select Ignore Player",
	List = {},
	Default = {},
	Multi = true,
	Callback = function(p16)
		t2.ignoredPlayers = p16

		local currentTarget = t2.currentTarget

		if currentTarget then
			currentTarget = table.find(p16, t2.currentTarget.Name)
		end

		if not currentTarget then
			return
		end

		t2.currentTarget = nil
		t2.currentTargetPart = nil
	end
})

v71()
Players.PlayerAdded:Connect(v71)
Players.PlayerRemoving:Connect(v71)
t1.value4()
t1.value2("Auto Save")
t1.value5("Enable", function(p17)
	t2.autoSaveEnabled = p17

	local v199 = not p17

	if v199 then
		v199 = t2.isSaving or t2.emergencyFly
	end

	if not v199 then
		return
	end

	if Part2.Parent then
		Part2.Parent = nil
	end

	t2.isSaving = false
	t2.emergencyFly = false
	v66()
end)
t1.value12 = { "Platform Heal", "Farm Heal" }
t1.value7({
	Text = "Select Mode",
	List = t1.value12,
	Default = "Farm Heal",
	Callback = function(p18)
		t2.saveMode = p18
	end
})
t1.value4()
CreateSidebarButton("Movement", AppImages.Movement)
t1.value31 = "Movement"
CreateTab("Movement")
ShowTab("Movement")
t1.value31 = "Speed"
t1.value2("Speed")

local t4 = {
	SpeedHumanoid = nil,
	SpeedRootPart = nil,
	SpeedIsEnabled = false,
	SpeedValue = 16,
	SpeedStopCallback = nil
}

local function v201()
	local connection = RunService.Heartbeat:Connect(function()
		if not (t4.SpeedRootPart and t4.SpeedRootPart.Parent) then
			return
		end

		if not t4.SpeedIsEnabled then
			return
		end

		if not t4.SpeedHumanoid then
			return
		end

		local MoveDirection = t4.SpeedHumanoid.MoveDirection

		if MoveDirection.Magnitude > 0 then
			t4.SpeedRootPart.AssemblyLinearVelocity = Vector3.new(MoveDirection.X * t4.SpeedValue, t4.SpeedRootPart.AssemblyLinearVelocity.Y, MoveDirection.Z * t4.SpeedValue)

			return
		end

		t4.SpeedRootPart.AssemblyLinearVelocity = Vector3.new(0, t4.SpeedRootPart.AssemblyLinearVelocity.Y, 0)
	end)

	return function()
		connection:Disconnect()
	end
end
local function v204(p19)
	t4.SpeedHumanoid = p19:WaitForChild("Humanoid")
	t4.SpeedRootPart = p19.WaitForChild(p19, "HumanoidRootPart")

	if not t4.SpeedIsEnabled then
		return
	end

	if t4.SpeedStopCallback then
		t4.SpeedStopCallback()
	end

	t4.SpeedStopCallback = v201()
end

if LocalPlayer.Character then
	task.spawn(v204, LocalPlayer.Character)
end

t1.value17 = LocalPlayer.CharacterAdded

function t1.value12(p20)
	if t4.SpeedIsEnabled == p20 then
		return
	end

	t4.SpeedIsEnabled = p20

	if t4.SpeedStopCallback then
		t4.SpeedStopCallback()
		t4.SpeedStopCallback = nil
	end

	if not t4.SpeedIsEnabled then
		return
	end

	t4.SpeedStopCallback = v201()
end

t1.value17:Connect(v204)
t1.value5("Enable", t1.value12)

local t5 = {
	Text = "Speed",
	Min = 16,
	Max = 300,
	Default = t4.SpeedValue,
	Callback = function(p21)
		t4.SpeedValue = p21
	end
}

t1.value6(t5)
t1.value12 = nil
t1.value4()
t1.value2("Fly")

local Space = Enum.KeyCode.Space
local LeftShift = Enum.KeyCode.LeftShift

t1.value17 = {
	FlyCharacter = t1.value12,
	FlyRootPart = nil,
	FlyIsEnabled = false,
	FlySpeed = 16,
	FlyVerticalSpeed = 25,
	FlyStopCallback = nil,
	FlyUpKey = Space,
	FlyDownKey = LeftShift
}

local value17 = t1.value17

function t1.value12()
	local BodyVelocity = Instance.new("BodyVelocity")

	BodyVelocity.MaxForce = Vector3.new(400000, 400000, 400000)
	BodyVelocity.Velocity = Vector3.new(0, 0, 0)
	BodyVelocity.P = 1250
	BodyVelocity.Parent = value17.FlyRootPart

	local connection = nil

	local function v211()
		connection:Disconnect()
		BodyVelocity:Destroy()
	end

	connection = RunService.Heartbeat:Connect(function()
		if not (value17.FlyRootPart and value17.FlyRootPart.Parent) then
			BodyVelocity.Velocity = Vector3.zero

			return
		end

		if not value17.FlyIsEnabled then
			BodyVelocity.Velocity = Vector3.new(0, 0, 0)

			return
		end

		local vector3 = Vector3.new()

		if UserInputService:IsKeyDown(value17.FlyUpKey) then
			vector3 = vector3 + Vector3.new(0, value17.FlyVerticalSpeed, 0)
		end

		if UserInputService:IsKeyDown(value17.FlyDownKey) then
			vector3 = vector3 - Vector3.new(0, value17.FlyVerticalSpeed, 0)
		end

		local CurrentCamera = workspace.CurrentCamera
		local LookVector = CurrentCamera.CFrame.LookVector
		local RightVector = CurrentCamera.CFrame.RightVector
		local vector32 = Vector3.new(LookVector.X, 0, LookVector.Z)
		local vector33 = Vector3.new(RightVector.X, 0, RightVector.Z)
		local Unit = vector32.Magnitude > 0 and vector32.Unit or Vector3.zero
		local Unit2 = vector33.Magnitude > 0 and vector33.Unit or Vector3.zero

		if UserInputService:IsKeyDown(Enum.KeyCode.W) then
			vector3 = vector3 + Unit * value17.FlySpeed
		end

		if UserInputService:IsKeyDown(Enum.KeyCode.S) then
			vector3 = vector3 - Unit * value17.FlySpeed
		end

		if UserInputService:IsKeyDown(Enum.KeyCode.A) then
			vector3 = vector3 - Unit2 * value17.FlySpeed
		end

		if not UserInputService:IsKeyDown(Enum.KeyCode.D) then
			BodyVelocity.Velocity = vector3

			return
		end

		vector3 = vector3 + Unit2 * value17.FlySpeed
		BodyVelocity.Velocity = vector3
	end)

	return v211
end

local value12 = t1.value12

t1.value18 = LocalPlayer

function t1.value12(p22)
	value17.FlyCharacter = p22
	value17.FlyRootPart = p22:WaitForChild("HumanoidRootPart")

	if not value17.FlyIsEnabled then
		return
	end

	if value17.FlyStopCallback then
		value17.FlyStopCallback()
	end

	value17.FlyStopCallback = value12()
end

if t1.value18.Character then
	task.spawn(t1.value12, LocalPlayer.Character)
end

local CharacterAdded = LocalPlayer.CharacterAdded

t1.value18 = "Connect"
t1.value32 = { "Space/Shift", "Space/LeftControl", "Q/E" }
CharacterAdded:Connect(t1.value12)
t1.value5("Enable", function(p23)
	if value17.FlyIsEnabled == p23 then
		return
	end

	value17.FlyIsEnabled = p23

	if value17.FlyStopCallback then
		value17.FlyStopCallback()
		value17.FlyStopCallback = nil
	end

	if not value17.FlyIsEnabled then
		return
	end

	value17.FlyStopCallback = value12()
end)

function t1.value33(p24)
	if p24 == "Space/Shift" then
		value17.FlyUpKey = Enum.KeyCode.Space
		value17.FlyDownKey = Enum.KeyCode.LeftShift

		return
	end

	if p24 == "Space/LeftControl" then
		value17.FlyUpKey = Enum.KeyCode.Space
		value17.FlyDownKey = Enum.KeyCode.LeftControl

		return
	end

	if p24 ~= "Q/E" then
		return
	end

	value17.FlyUpKey = Enum.KeyCode.Q
	value17.FlyDownKey = Enum.KeyCode.E
end

t1.value7({
	Text = "Vertical Fly Keybind",
	List = t1.value32,
	Default = "Space/Shift",
	Callback = t1.value33
})
t1.value6({
	Text = "Fly Speed",
	Min = 16,
	Max = 300,
	Default = value17.FlySpeed,
	Decimals = 1,
	Callback = function(p25)
		value17.FlySpeed = p25
	end
})
t1.value33 = value17.FlyVerticalSpeed
t1.value34 = {}
t1.value6({
	Text = "Vertical Fly Speed",
	Min = 25,
	Max = 500,
	Default = t1.value33,
	Decimals = 1,
	Callback = function(p26)
		value17.FlyVerticalSpeed = p26
	end
})
t1.value4()
t1.value2()

local t6 = {
	NoclipCharacter = nil,
	NoclipIsEnabled = false,
	NoclipStopCallback = nil,
	NoclipParts = {},
	NoclipOriginalCanCollide = t1.value34,
	NoclipDescendantConnection = nil
}

local function v223()
	local connection = RunService.Stepped:Connect(function()
		if not (t6.NoclipCharacter and t6.NoclipCharacter.Parent) then
			return
		end

		if not t6.NoclipIsEnabled then
			return
		end

		for _, noclipPart in ipairs(t6.NoclipParts) do
			noclipPart.CanCollide = false
		end
	end)

	return function()
		connection:Disconnect()

		local NoclipCharacter = t6.NoclipCharacter

		if NoclipCharacter then
			NoclipCharacter = t6.NoclipCharacter.Parent
		end

		if not NoclipCharacter then
			return
		end

		for _, noclipPart in ipairs(t6.NoclipParts) do
			local Parent

			if noclipPart then
				Parent = noclipPart.Parent
			else
				Parent = noclipPart
			end

			if Parent then
				local v231 = t6.NoclipOriginalCanCollide[noclipPart]

				if v231 ~= nil then
					noclipPart.CanCollide = v231
				end
			end
		end
	end
end
local function v232()
	table.clear(t6.NoclipParts)

	if t6.NoclipCharacter then
		table.clear(t6.NoclipOriginalCanCollide)

		local ipairs_ = ipairs
		local NoclipCharacter = t6.NoclipCharacter

		for _, descendant in ipairs_(NoclipCharacter.GetDescendants(NoclipCharacter)) do
			if descendant:IsA("BasePart") then
				local NoclipParts = t6.NoclipParts

				table.insert(NoclipParts, descendant)
				t6.NoclipOriginalCanCollide[descendant] = descendant.CanCollide
			end
		end
	end
end
local function v238(character)
	t6.NoclipCharacter = character
	v232()

	if t6.NoclipDescendantConnection then
		t6.NoclipDescendantConnection:Disconnect()
	end

	if t6.NoclipRemovingConnection then
		t6.NoclipRemovingConnection:Disconnect()
	end

	local function v239(descendant)
		if not descendant:IsA("BasePart") then
			return
		end

		local NoclipParts = t6.NoclipParts

		table.insert(NoclipParts, descendant)
		t6.NoclipOriginalCanCollide[descendant] = descendant.CanCollide
	end

	t6.NoclipDescendantConnection = character.DescendantAdded:Connect(v239)

	local function v241(descendant)
		if not descendant:IsA("BasePart") then
			return
		end

		local v242 = table.find(t6.NoclipParts, descendant)

		if not v242 then
			t6.NoclipOriginalCanCollide[descendant] = nil

			return
		end

		table.remove(t6.NoclipParts, v242)
		t6.NoclipOriginalCanCollide[descendant] = nil
	end

	t6.NoclipRemovingConnection = character.DescendantRemoving:Connect(v241)

	if not t6.NoclipIsEnabled then
		return
	end

	if t6.NoclipStopCallback then
		t6.NoclipStopCallback()
	end

	t6.NoclipStopCallback = v223()
end

if LocalPlayer.Character then
	task.spawn(v238, LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(v238)
t1.value5("Noclip", function(p27)
	if t6.NoclipIsEnabled == p27 then
		return
	end

	t6.NoclipIsEnabled = p27

	if t6.NoclipStopCallback then
		t6.NoclipStopCallback()
		t6.NoclipStopCallback = nil
	end

	if not t6.NoclipIsEnabled then
		return
	end

	t6.NoclipStopCallback = v223()
end)
t1.value4()
CreateSidebarButton("Esp", AppImages.Esp)
CreateTab("Esp")
ShowTab("Esp")
t1.value2("Player ESP")

local t7 = {
	IsEnabled = false,
	IsChamsEnabled = false,
	IsNameEnabled = false,
	IsHPEnabled = false,
	IsDistanceEnabled = false,
	MaxDistance = 2000,
	ESPColor = Color3.fromRGB(0, 255, 195)
}

local function v244()
	local v245 = Players

	for _, player in ipairs(v245.GetPlayers(v245)) do
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

function t1.value35(p28)
	t7.MaxDistance = p28
end

local v251 = nil

local function v252()
	v244()

	if not t7.IsEnabled then
		return
	end

	local v253 = Players

	for _, player in ipairs(v253.GetPlayers(v253)) do
		if player ~= LocalPlayer then
			v251(player)
		end
	end
end

v251 = function(p29)
	local Character = p29.Character

	if not Character then
		return
	end

	local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
	local Humanoid = Character:FindFirstChild("Humanoid")

	if not (HumanoidRootPart and Humanoid) then
		return
	end

	if t7.IsNameEnabled or t7.IsHPEnabled then
		Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	else
		Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
	end

	local Highlight = Instance.new("Highlight")

	Highlight.Name = "PlayerESP_Highlight"
	Highlight.FillColor = t7.ESPColor
	Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
	Highlight.FillTransparency = t7.IsChamsEnabled and 0.5 or 1
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
	TextLabel.Visible = t7.IsHPEnabled
	TextLabel.LayoutOrder = 1
	TextLabel.Parent = BillboardGui

	local TextLabel2 = Instance.new("TextLabel")

	TextLabel2.Size = UDim2.new(1, 0, 0, 16)
	TextLabel2.BackgroundTransparency = 1
	TextLabel2.Text = p29.Name
	TextLabel2.TextColor3 = t7.ESPColor
	TextLabel2.TextStrokeTransparency = 0.2
	TextLabel2.Font = Enum.Font.SourceSansBold
	TextLabel2.TextSize = 14
	TextLabel2.Visible = t7.IsNameEnabled
	TextLabel2.LayoutOrder = 2
	TextLabel2.Parent = BillboardGui

	local TextLabel3 = Instance.new("TextLabel")

	TextLabel3.Size = UDim2.new(1, 0, 0, 16)
	TextLabel3.BackgroundTransparency = 1
	TextLabel3.TextColor3 = Color3.fromRGB(200, 200, 200)
	TextLabel3.TextStrokeTransparency = 0.2
	TextLabel3.Font = Enum.Font.SourceSansBold
	TextLabel3.TextSize = 14
	TextLabel3.Visible = t7.IsDistanceEnabled
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

			local Character2 = LocalPlayer.Character

			if Character2 then
				Character2 = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
			end

			if Character2 then
				Character2 = (Character2.Position - HumanoidRootPart.Position).Magnitude
			end

			local v267 = Character2 or 0

			if v267 <= t7.MaxDistance then
				Highlight.Enabled = true
				BillboardGui.Enabled = true

				if t7.IsHPEnabled then
					local Health = Humanoid.Health
					local hp = math.floor(Health)

					TextLabel.Text = "HP: " .. hp

					local v270 = hp / Humanoid.MaxHealth
					local v271 = TextLabel
					local color3

					if v270 > 0.6 then
						color3 = Color3.fromRGB(50, 255, 50)
					else
						color3 = false
					end

					if not color3 then
						local color32

						if v270 > 0.3 then
							color32 = Color3.fromRGB(255, 255, 50)
						else
							color32 = false
						end

						color3 = color32 or Color3.fromRGB(255, 50, 50)
					end

					v271.TextColor3 = color3
				end

				if t7.IsDistanceEnabled then
					TextLabel3.Text = math.floor(v267) .. "m"
				end
			else
				Highlight.Enabled = false
				BillboardGui.Enabled = false
			end

			task.wait(0.5)
		end
	end)
end
task.spawn(function()
	while true do
		repeat
			task.wait(1)
		until t7.IsEnabled

		v252()
	end
end)
t1.value5("ESP Enable", function(p30)
	t7.IsEnabled = p30
	v252()
end)
t1.value5("Show Chams", function(p31)
	t7.IsChamsEnabled = p31

	if not t7.IsEnabled then
		return
	end

	v252()
end)
t1.value5("Show Name", function(p32)
	t7.IsNameEnabled = p32

	if not t7.IsEnabled then
		return
	end

	v252()
end)
t1.value5("Show HP", function(p33)
	t7.IsHPEnabled = p33

	if not t7.IsEnabled then
		return
	end

	v252()
end)
t1.value5("Show Distance", function(p34)
	t7.IsDistanceEnabled = p34

	if not t7.IsEnabled then
		return
	end

	v252()
end)

local t8 = {
	Text = "ESP Color",
	Default = t7.ESPColor,
	Callback = function(p35)
		t7.ESPColor = p35

		if not t7.IsEnabled then
			return
		end

		v252()
	end
}

t1.value8(t8)
t1.value6({
	Text = "ESP Distance",
	Min = 50,
	Max = 2000,
	Default = 2000,
	Decimals = 1,
	Callback = t1.value35
})
t1.value4()
CreateSidebarButton("Teleport", AppImages.Teleport)
CreateTab("Teleport")
ShowTab("Teleport")

local v275 = t1.value1({ "Waypoints", "Spectate" }, "Waypoints")

v275:Set("Waypoints")
t1.value9()
v275:Set("Spectate")
t1.value10()
task.spawn(function()
	RunService.RenderStepped:Wait()
	task.wait(0.1)
	ShowTab("Main")
end)
