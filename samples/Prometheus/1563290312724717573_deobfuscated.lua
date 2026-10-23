-- This file was generated at discord.gg/syncrypt

local unpack_ = unpack or table.unpack
local t1 = {
	value2 = nil
}

t1.value2 = 22126428612671
t1.value2 = "game"
t1.value2 = "\190\18\191^\189(\173"
t1.value2 = game:GetService("Players")

local t2 = {
	value1 = t1.value2
}

t1.value2 = game:GetService("ReplicatedStorage")
t2.value2 = t1.value2
t1.value2 = game:GetService("RunService")
t2.value3 = t1.value2
t1.value2 = game:GetService("UserInputService")
t2.value4 = t1.value2
t1.value2 = game:GetService("VirtualUser")
t2.value5 = t1.value2
t1.value2 = game:GetService("HttpService")
t2.value6 = t1.value2
t1.value2 = t2.value1.LocalPlayer
t2.value7 = t1.value2
t1.value2 = t2.value7:WaitForChild("PlayerGui")
t2.value8 = t1.value2
t2.value9 = "MuscleLegends_FourHub_Save.json"
t2.value10 = {}

local isfile_ = isfile

if isfile_ then
	isfile_ = isfile(t2.value9)
end

t1.value2 = isfile_

if t1.value2 then
	isfile_, v9 = pcall(function()
		return t2.value6:JSONDecode(unpack_({ readfile(t2.value9) }))
	end)
	t1.value3 = isfile_
	t1.value4 = v9
	v9 = t1.value3

	if v9 then
		v9 = t1.value4
		v9 = type(v9) == "table"
	end

	t1.value2 = v9

	if t1.value2 then
		t2.value10 = t1.value4
	end
end

function t1.value2(p1, p2)
	t2.value10[p1] = p2

	if not writefile then
		return
	end

	pcall(function()
		writefile(t2.value9, t2.value6:JSONEncode(t2.value10))
	end)
end

local function value4(p3, p4)
	if t2.value10[p3] == nil then
		return p4
	else
		return t2.value10[p3]
	end
end

isfile_ = t1.value1
t2.value11 = t1.value2

local getgenv_ = getgenv

if getgenv_ then
	getgenv_ = getgenv()
end

t1.value4 = getgenv_
getgenv_ = t1.value1

local value42 = t1.value4

t1.value1 = getgenv_
t1.value2 = value42

if not t1.value4 then
	t1.value2 = _G
end

t1.value2.Young0xPersistentAntiAfk = t1.value2.Young0xPersistentAntiAfk or {}
t1.value1 = isfile_

if not (t1.value2.Young0xPersistentAntiAfk.connection and t1.value2.Young0xPersistentAntiAfk.connection.Connected) then
	t1.value2.Young0xPersistentAntiAfk.connection = t2.value7.Idled:Connect(function()
		pcall(function()
			t2.value5:CaptureController()

			local CurrentCamera = workspace.CurrentCamera

			if not CurrentCamera then
				v13 = CurrentCamera or CFrame.new()
				t2.value5:Button2Down(Vector2.new(0, 0), v13)
				task.wait(0.05)
				v14 = t2.value5
				v15 = Vector2
				v14.Button2Up(v14, v15.new(0, 0), v13)

				return
			end

			CurrentCamera = CurrentCamera.CFrame

			local cFrame = CurrentCamera or CFrame.new()

			t2.value5:Button2Down(Vector2.new(0, 0), cFrame)
			task.wait(0.05)

			local value5 = t2.value5
			local Vector2_ = Vector2

			value5.Button2Up(value5, Vector2_.new(0, 0), cFrame)
		end)
	end)
end

t1.value3 = {
	name = "Industrial Rock",
	exactName = "Industrial Rock",
	durability = 25000000
}
t1.value4 = {
	t1.value3,
	{
		name = "Ancient Rock",
		exactName = "Ancient Jungle Rock",
		durability = 10000000
	},
	{
		name = "Muscle King Rock",
		exactName = "Muscle King Mountain",
		durability = 5000000
	},
	{
		name = "Legend Rock",
		exactName = "Rock Of Legends",
		durability = 1000000
	},
	{
		name = "Inferno Rock",
		exactName = "Inferno Rock",
		durability = 800000
	},
	{
		name = "Eternal Rock",
		durability = 750000
	},
	{
		name = "Mythical Rock",
		durability = 400000
	},
	{
		name = "Frost Rock",
		exactName = "Frozen Rock",
		durability = 150000
	},
	{
		name = "Punching Rock",
		exactName = "Punching Rock",
		durability = 50000
	},
	{
		name = "Beach Rock",
		durability = 5000
	},
	{
		name = "Starter Rock",
		durability = 100
	},
	{
		name = "Tiny Rock",
		durability = 0
	}
}
value42 = { "Industrial Gym", Vector3.new(-5198, 57, 4942) }
getgenv_ = { "Jungle Gym", Vector3.new(-7894, 6, 2386) }
isfile_ = { "Muscle King", Vector3.new(-8799, 17, -5798) }

local t3 = { "Legends Gym", Vector3.new(4429, 991, -3880) }
local t4 = { "Eternal Gym", Vector3.new(-6768, 7, -1287) }
local t5 = { "Mythical Gym", Vector3.new(2255, 7, 1071) }
local value66 = { "Frost Gym", Vector3.new(-2650, 7, -393) }
local value1 = { "Tiny Gym", Vector3.new(50, 7, 1918) }
local value12 = { "Beach", Vector3.new(9, 7, 100) }
local brawl = { "Secret Area", Vector3.new(1947, 2, 6191) }

t1.value3 = { "Desert Brawl", Vector3.new(960, 17, -7398) }
t1.value2 = { "Lava Brawl", Vector3.new(4471, 119, -8836) }
t1.value2 = {
	Rocks = t1.value4,
	Teleports = {
		value42,
		getgenv_,
		isfile_,
		t3,
		t4,
		t5,
		value66,
		value1,
		value12,
		brawl,
		t1.value3,
		t1.value2
	}
}
t1.value4 = {
	tool = "TOUGH Bar",
	event = "toughBar"
}
t1.value3 = {
	tool = "ULTRA Shake",
	event = "ultraShake"
}
t2.value12 = {
	t1.value4,
	t1.value3,
	{
		tool = "Energy Shake",
		event = "energyShake"
	},
	{
		tool = "Protein Shake",
		event = "proteinShake"
	},
	{
		tool = "Energy Bar",
		event = "energyBar"
	},
	{
		tool = "Protein Bar",
		event = "proteinBar"
	}
}
t1.value3 = "autoSitups"
t1.value4 = {}
t1.value4 = {
	active = t1.value4,
	humanoid = nil,
	walkSpeed = nil
}
t2.value13 = {
	running = true,
	fastPunch = false,
	selectedRock = nil,
	autoWeight = false,
	autoHandstands = false,
	autoLift = false,
	[v2410] = false,
	mainAutoSize = false,
	mainAutoSpeed = false,
	mainSize = 2,
	mainSpeed = 125,
	infiniteJump = false,
	fastSpeed = false,
	spin = false,
	walkWater = false,
	autoUseTools = false,
	autoEatProtein = false,
	autoSpinWheel = false,
	autoClaimGifts = false,
	autoUseCodes = false,
	autoWinBrawl = false,
	selectedProteinItems = {},
	_autoRock = false,
	_autoBrawl = false,
	rebirth = {
		objective = 0,
		autoRebirth = false,
		infinite = false,
		king = false,
		lockPosition = false,
		lockCFrame = nil
	},
	exerciseMovement = t1.value4
}
t2.value14 = {}
t2.value15 = {}

function t2.value16(p5)
	if not t2.value14[p5] then
		return
	end

	pcall(task.cancel, t2.value14[p5])
	t2.value14[p5] = nil
end

workspace.DescendantAdded:Connect(function(descendant)
	local v19

	if descendant then
		v19 = string.match(string.lower(descendant.Name), "portal|ad|sponsor|advert")
	else
		v19 = descendant
	end

	if not v19 then
		return
	end

	task.defer(function()
		pcall(function()
			descendant:Destroy()
		end)
	end)
end)
brawl = ipairs
value12 = workspace
value1 = function(p6)
	t2.value15[#t2.value15 + 1] = p6

	return p6
end

for _, descendant in brawl(value12.GetDescendants(value12)) do
	if string.match(string.lower(descendant.Name), "portal|ad|sponsor|advert") then
		function t1.value3()
			descendant:Destroy()
		end

		pcall(t1.value3)
	end
end

local function v22()
	while t2.value13.running do
		pcall(function()
			local rebirthMenu = t2.value8:FindFirstChild("gameGui") and t2.value8.gameGui:FindFirstChild("rebirthMenu")

			if rebirthMenu then
				rebirthMenu = t2.value8.gameGui.rebirthMenu:FindFirstChild("confirmButton")
			end

			if not rebirthMenu then
				return
			end

			rebirthMenu.Visible = false
			rebirthMenu.Active = false
		end)
		task.wait(1)
	end
end

t2.value16("permanentPreventRebirth")

local s1 = "permanentPreventRebirth"

t2.value14.permanentPreventRebirth = task.spawn(function()
	pcall(v22)
	t2.value14[s1] = nil
end)
brawl = t2.value14.permanentPreventRebirth

function t2.value17()
	return t2.value7.Character
end
function t2.value18()
	local Humanoid = t2.value17()

	if not Humanoid then
		return Humanoid
	end

	Humanoid = Humanoid:FindFirstChildWhichIsA("Humanoid")

	return Humanoid
end
function t2.value19()
	local HumanoidRootPart = t2.value17()

	if not HumanoidRootPart then
		return HumanoidRootPart
	end

	HumanoidRootPart = HumanoidRootPart:FindFirstChild("HumanoidRootPart")

	return HumanoidRootPart
end

t2.value20 = nil

function t2.value20(p7)
	local v27 = t2.value17()
	local v28 = t2.value18()

	if not (v27 and v28) then
		return nil
	end

	local v29, v30, v31 = ipairs(p7)
	local t6 = {}

	while true do
		local v33

		v31, v33 = v29(v30, v31)

		if not v31 then
			break
		end

		t6[v33:lower()] = true
	end

	local ipairs_ = ipairs
	local value7 = t2.value7

	for _, v in ipairs_({ v27, value7.FindFirstChild(value7, "Backpack") }) do
		if v then
			for _, child in ipairs(v.GetChildren(v)) do
				local isTool = child:IsA("Tool")

				if isTool then
					isTool = t6[child.Name:lower()]
				end

				if isTool then
					if child.Parent == v27 then
						return child
					end

					v28:EquipTool(child)

					return child
				end
			end
		end
	end

	return nil
end
function t2.value21()
	return t2.value20({ "Punch" })
end

t2.value22 = nil

function t1.value3(p8)
	local v41 = t2.value21()

	if not v41 then
		return
	end

	local v42 = v41.FindFirstChild(v41, "attackTime")
	local isValueBase

	if v42 then
		isValueBase = v42:IsA("ValueBase")
	else
		isValueBase = v42
	end

	if isValueBase then
		pcall(function()
			v42.Value = 0
		end)
	end

	local muscleEvent = t2.value7:FindFirstChild("muscleEvent")

	if muscleEvent then
		pcall(function()
			muscleEvent:FireServer("punch", "rightHand")
			muscleEvent:FireServer("punch", "leftHand")
			muscleEvent:FireServer("punch")
		end)
	end

	local Handle = v41:FindFirstChild("Handle")
	local v46 = t2.value22()
	local v47

	if v46 then
		v47 = Handle and p8
	else
		v47 = v46
	end

	if not v47 then
		return
	end

	pcall(v46, p8, Handle, 0)
	pcall(v46, p8, Handle, 1)
end
function t2.value22()
	local _G_ = _G
	local value = rawget(_G_, "firetouchinterest")

	if not value then
		local firetouchinterest_ = firetouchinterest

		if typeof(firetouchinterest_) == "function" then
			value = firetouchinterest
		else
			value = false
		end
	end

	if type(value) == "function" then
		return value
	end

	local ok, result = pcall(function()
		local getgenv_2 = getgenv

		if not getgenv_2 then
			return getgenv_2
		end

		getgenv_2 = getgenv().firetouchinterest

		return getgenv_2
	end)

	if ok then
	elseif ok then
		return result
	else
		return nil
	end

	ok = type(result) == "function"

	if ok then
		return result
	else
		return nil
	end
end
function t1.value4()
	t2.value16("fastPunchEquip")
	t2.value16("fastPunchHit")
	t2.value16("fastPunchRock")

	local function v54()
		local Punch = t2.value17()

		if Punch then
			Punch = Punch:FindFirstChild("Punch")
		end

		if not Punch then
			return
		end

		local attackTime = Punch:FindFirstChild("attackTime")

		if attackTime then
			attackTime.Value = 0.3
		end

		local Backpack = t2.value7:FindFirstChild("Backpack")

		if not Backpack then
			return
		end

		Punch.Parent = Backpack
	end

	pcall(v54)
end

t2.value23 = t1.value3
t2.value24 = {}

function t1.value3()
	for k, v in pairs(t2.value24) do
		if v.fake then
			pcall(function()
				local fake = v.fake

				if fake then
					fake = v.fake.Parent
				end

				if not fake then
					return
				end

				v.fake:Destroy()
			end)
			v.fake = nil
		end

		if k then
			pcall(function()
				local parent = v.parent

				if parent then
					parent = k.Parent ~= v.parent
				end

				if parent then
					k.Parent = v.parent
				end

				local v62, v63, v64 = ipairs(k:GetDescendants())

				while true do
					local v65

					v64, v65 = v62(v63, v64)

					if not v64 then
						break
					end

					if v65:IsA("Weld") or v65:IsA("WeldConstraint") then
						local Name = v65.Name

						if tostring(Name):find("ML_", 1, true) then
							v65:Destroy()
						end
					end
				end

				if k:IsA("BasePart") then
					k.Anchored = true

					local function v67()
						k.AssemblyLinearVelocity = Vector3.zero
						k.AssemblyAngularVelocity = Vector3.zero
					end

					pcall(v67)
				end

				if v.rockCFrame then
					k.CFrame = v.rockCFrame
				end

				if v.size then
					k.Size = v.size
				end

				if v.transparency ~= nil then
					k.Transparency = v.transparency
				end

				if v.canCollide ~= nil then
					k.CanCollide = v.canCollide
				end

				if v.anchored ~= nil then
					k.Anchored = v.anchored
				end

				local TouchPart = k:FindFirstChild("TouchPart")
				local isBasePart

				if TouchPart then
					isBasePart = TouchPart:IsA("BasePart")
				else
					isBasePart = TouchPart
				end

				if not isBasePart then
					return
				end

				TouchPart.Anchored = true
				pcall(function()
					TouchPart.AssemblyLinearVelocity = Vector3.zero
					TouchPart.AssemblyAngularVelocity = Vector3.zero
				end)

				if v.touchCFrame then
					TouchPart.CFrame = v.touchCFrame
				end

				if v.touchSize then
					TouchPart.Size = v.touchSize
				end

				if v.touchCanCollide ~= nil then
					TouchPart.CanCollide = v.touchCanCollide
				end

				if v.touchTransparency == nil then
					return
				end

				TouchPart.Transparency = v.touchTransparency
			end)
		end
	end

	table.clear(t2.value24)
end
function t2.value25(p9)
	if p9 then
		if p9:IsA("GuiObject") or (p9:IsA("SurfaceGui") or p9:IsA("BillboardGui")) then
			return true
		elseif p9:IsA("ParticleEmitter") or (p9:IsA("Trail") or p9:IsA("Beam")) then
			return true
		else
			local v70 = p9.Name:lower()

			return (v70:find("gui", 1, true) or (v70:find("particle", 1, true) or v70:find("emitter", 1, true))) and true or false
		end
	else
		return false
	end
end
function t2.value26(p10)
	if not p10 then
		return
	end

	local GetDescendants = p10.GetDescendants
	local v72, v73, v74 = ipairs(GetDescendants(p10))

	while true do
		local v75

		v74, v75 = v72(v73, v74)

		if not v74 then
			break
		end

		if t2.value25(v75) then
			pcall(function()
				v75:Destroy()
			end)
		end
	end

	if not p10.Parent then
		return
	end

	local v76, v77, v78 = ipairs(p10.Parent:GetChildren())

	while true do
		local v79

		v78, v79 = v76(v77, v78)

		if not v78 then
			break
		end

		if t2.value25(v79) then
			pcall(function()
				v79:Destroy()
			end)
		end
	end

	local ipairs_ = ipairs
	local Parent = p10.Parent

	for _, descendant in ipairs_(Parent.GetDescendants(Parent)) do
		if t2.value25(descendant) then
			pcall(function()
				descendant:Destroy()
			end)
		end
	end
end

t2.value27 = nil

function t2.value27(p11)
	if not (p11 and p11:IsA("BasePart")) then
		return nil
	end

	local v84 = p11.Clone(p11)

	v84.Name = p11.Name .. "_FakeVisual"
	v84.Anchored = true
	v84.CanCollide = false
	v84.CanQuery = false
	v84.CanTouch = false
	v84.CFrame = p11.CFrame
	v84.Size = p11.Size
	v84.Transparency = p11.Transparency

	local GetDescendants = v84.GetDescendants

	for _, v in ipairs(GetDescendants(v84)) do
		if v:IsA("BaseScript") or (v:IsA("RemoteEvent") or (v:IsA("RemoteFunction") or v:IsA("BindableEvent"))) then
			pcall(function()
				v:Destroy()
			end)
		end
	end

	v84.Parent = p11.Parent or workspace

	return v84
end

t2.value28 = nil

function t2.value28(p12)
	if not p12 or t2.value24[p12] then
		return
	end

	local GetChildren = p12.GetChildren
	local v89, v90, v91 = ipairs(GetChildren(p12))
	local t7 = {}

	while true do
		local v93

		v91, v93 = v89(v90, v91)

		if not v91 then
			break
		end

		if t2.value25(v93) then
			t7[v93] = {
				parent = v93.Parent,
				name = v93.Name
			}
		end
	end

	if p12.Parent then
		local ipairs_ = ipairs
		local Parent = p12.Parent

		for _, child in ipairs_(Parent.GetChildren(Parent)) do
			if t2.value25(child) then
				t7[child] = {
					parent = child.Parent,
					name = child.Name
				}
			end
		end
	end

	local v98 = t2.value27(p12)
	local Transparency = p12.FindFirstChild(p12, "TouchPart")
	local value24 = t2.value24
	local s2 = "rockCFrame"
	local CFrame_ = p12.CFrame
	local s3 = "transparency"
	local Transparency2 = p12.Transparency
	local s4 = "size"
	local Size = p12.Size
	local s5 = "canCollide"
	local CanCollide = p12.CanCollide
	local s6 = "anchored"
	local Anchored = p12.Anchored
	local s7 = "touchCFrame"
	local CFrame_2

	if Transparency then
		CFrame_2 = Transparency.CFrame
	else
		CFrame_2 = Transparency
	end

	local v113 = CFrame_2 or nil
	local Size2

	if Transparency then
		Size2 = Transparency.Size
	else
		Size2 = Transparency
	end

	local v115 = Size2 or nil
	local CanCollide2

	if Transparency then
		CanCollide2 = Transparency.CanCollide
	else
		CanCollide2 = Transparency
	end

	local v117 = CanCollide2 or false

	if not Transparency then
		value24[p12] = {
			[s2] = CFrame_,
			[s3] = Transparency2,
			[s4] = Size,
			[s5] = CanCollide,
			[s6] = Anchored,
			[s7] = v113,
			touchSize = v115,
			touchCanCollide = v117,
			touchTransparency = Transparency or 0,
			parent = p12.Parent,
			children = t7,
			fake = v98
		}

		return
	end

	Transparency = Transparency.Transparency
	value24[p12] = {
		[s2] = CFrame_,
		[s3] = Transparency2,
		[s4] = Size,
		[s5] = CanCollide,
		[s6] = Anchored,
		[s7] = v113,
		touchSize = v115,
		touchCanCollide = v117,
		touchTransparency = Transparency or 0,
		parent = p12.Parent,
		children = t7,
		fake = v98
	}
end

t2.value29 = t1.value3

function t2.value30(p13)
	if not p13 then
		return
	end

	local machinesFolder = workspace:FindFirstChild("machinesFolder")

	if not machinesFolder then
		return
	end

	local v119 = nil

	if p13.exactName then
		local v120 = machinesFolder:FindFirstChild(p13.exactName)

		if v120 then
			local Rock = v120:FindFirstChild("Rock")
			local isBasePart

			if Rock then
				isBasePart = Rock:IsA("BasePart")
			else
				isBasePart = Rock
			end

			if isBasePart then
				if not t2.value24[Rock] then
					t2.value28(Rock)
				end

				t2.value26(Rock)
				v119 = v119 or Rock
			end

			local GetDescendants = v120.GetDescendants

			for _, v in ipairs(GetDescendants(v120)) do
				local isBasePart2

				if v.Name == "Rock" then
					isBasePart2 = v:IsA("BasePart")
				else
					isBasePart2 = false
				end

				if isBasePart2 then
					if not t2.value24[v] then
						t2.value28(v)
					end

					t2.value26(v)
					v119 = v119 or v
					pcall(function()
						v.Transparency = 1
						v.CanCollide = false

						local TouchPart = v:FindFirstChild("TouchPart")

						if not TouchPart then
							return
						end

						TouchPart.Transparency = 1
						TouchPart.CanCollide = false
					end)

					local v128 = t2.value24[v]
					local v129

					if v128 then
						v129 = not (v128.fake and v128.fake.Parent)
					else
						v129 = v128
					end

					if v129 then
						local v130 = t2.value27(v)

						if v130 then
							v130.CFrame = v128.rockCFrame
							v130.Size = v128.size
							v130.Transparency = v128.transparency
							v128.fake = v130
						end
					end
				end
			end
		end
	end

	for _, descendant in pairs(machinesFolder.GetDescendants(machinesFolder)) do
		local v133 = nil
		local exactName = p13.exactName

		if exactName then
			exactName = descendant.Name == p13.exactName
		end

		local Rock

		if exactName then
			local Rock2 = Rock:FindFirstChild("Rock")
			local v137 = not Rock2

			if v137 then
				v137 = Rock:IsA("BasePart")

				if v137 then
					v137 = Rock.Name == "Rock"
				end
			end

			if not v137 then
				Rock = Rock2
			end
		else
			local v138 = not p13.exactName

			if v138 then
				v138 = Rock.Name == "neededDurability"

				if v138 then
					v138 = Rock:IsA("ValueBase")

					if v138 then
						local Value = Rock.Value
						local v140 = tonumber(Value)
						local durability = p13.durability

						v138 = v140 == tonumber(durability)
					end
				end
			end

			if v138 then
				local Parent = Rock.Parent

				if Parent then
					Rock = Rock.Parent:FindFirstChild("Rock")
				else
					Rock = Parent
				end
			else
				Rock = v133
			end
		end

		if Rock then
			local isBasePart = Rock:IsA("BasePart")
		end

		if v150 then
			v119 = v119 or Rock

			if not t2.value24[Rock] then
				t2.value28(Rock)
			end

			t2.value26(Rock)
			pcall(function()
				Rock.Transparency = 1
				Rock.CanCollide = false

				local TouchPart = Rock:FindFirstChild("TouchPart")

				if not TouchPart then
					return
				end

				TouchPart.Transparency = 1
				TouchPart.CanCollide = false
			end)

			local v145 = t2.value24[Rock]

			if v145 and not v145.fake or not v145.fake.Parent then
				local v146 = t2.value27(Rock)

				if v146 then
					v146.CFrame = v145.rockCFrame
					v146.Size = v145.size
					v146.Transparency = v145.transparency
					v145.fake = v146
				end
			else
				local fake

				if v145 then
					fake = v145.fake
				else
					fake = v145
				end

				if fake then
					pcall(function()
						v145.fake.CFrame = v145.rockCFrame
						v145.fake.Size = v145.size
					end)
				end
			end
		end
	end

	return v119
end
function t1.value3()
	local selectedRock = t2.value13.selectedRock

	if not selectedRock then
		return
	end

	local RightHand = t2.value17()
	local LeftHand

	if RightHand then
		LeftHand = RightHand:FindFirstChild("LeftHand")
	else
		LeftHand = RightHand
	end

	if RightHand then
		RightHand = RightHand:FindFirstChild("RightHand")
	end

	if not (LeftHand and RightHand) then
		return
	end

	local v151 = t2.value30(selectedRock)

	if not v151 then
		return
	end

	pcall(function()
		v151.Transparency = 1
		v151.CanCollide = false
		v151.Size = Vector3.new(2, 1, 1)
		v151.CFrame = LeftHand.CFrame

		local TouchPart = v151:FindFirstChild("TouchPart")

		if not TouchPart then
			return
		end

		TouchPart.Transparency = 1
		TouchPart.CFrame = LeftHand.CFrame
	end)

	local v153 = t2.value22()

	if not v153 then
		t2.value21()

		return
	end

	pcall(v153, v151, RightHand, 0)
	pcall(v153, v151, RightHand, 1)
	pcall(v153, v151, LeftHand, 0)
	pcall(v153, v151, LeftHand, 1)
	t2.value21()
end

t2.value31 = t1.value3

function t2.value32()
	return t2.value13.running and t2.value13.fastPunch == true and true or t2.value13.selectedRock ~= nil
end

t2.value33 = t1.value4

local function v154()
	t2.value33()

	local function v155()
		while t2.value32() do
			if t2.value13.selectedRock then
				pcall(function()
					local v156 = t2.value21()
					local attackTime = v156 and v156:FindFirstChild("attackTime")

					if not attackTime then
						return
					end

					attackTime.Value = 0
				end)
			end

			task.wait(0.05)
		end
	end

	t2.value16("fastPunchEquip")

	local s8 = "fastPunchEquip"

	t2.value14.fastPunchEquip = task.spawn(function()
		pcall(v155)
		t2.value14[s8] = nil
	end)

	local _ = t2.value14.fastPunchEquip

	local function v160()
		while t2.value32() do
			pcall(function()
				local Punch = t2.value17()

				if Punch then
					Punch = t2.value17():FindFirstChild("Punch")
				end

				local attackTime = Punch and Punch:FindFirstChild("attackTime")

				if attackTime then
					attackTime.Value = 0
				end

				local muscleEvent = t2.value7:FindFirstChild("muscleEvent")

				if not muscleEvent then
					return
				end

				muscleEvent:FireServer("punch", "rightHand")
				muscleEvent:FireServer("punch", "leftHand")
			end)
			task.wait(0.01)
		end
	end

	t2.value16("fastPunchHit")

	local s9 = "fastPunchHit"

	t2.value14.fastPunchHit = task.spawn(function()
		pcall(v160)
		t2.value14[s9] = nil
	end)

	local _ = t2.value14.fastPunchHit

	local function v166()
		while t2.value32() do
			if t2.value13.selectedRock then
				pcall(t2.value31)

				local muscleEvent = t2.value7:FindFirstChild("muscleEvent")

				if muscleEvent then
					pcall(muscleEvent.FireServer, muscleEvent, "punch", "rightHand")
					pcall(muscleEvent.FireServer, muscleEvent, "punch", "leftHand")
				end
			end

			task.wait(0.4)
		end
	end

	t2.value16("fastPunchRock")

	local s10 = "fastPunchRock"

	t2.value14.fastPunchRock = task.spawn(function()
		pcall(v166)
		t2.value14[s10] = nil
	end)

	local _ = t2.value14.fastPunchRock
end

function t1.value3(p14)
	t2.value13.fastPunch = p14 == true

	if t2.value32() then
		v154()

		return
	end

	if t2.value13.fastPunch then
		t2.value33()

		return
	end

	t2.value29()
	t2.value33()
end
function t1.value4()
	local currentMap = t2.value7:FindFirstChild("currentMap")

	if currentMap then
		local Value = currentMap.Value or ""
		local v172 = tostring(Value):lower()

		return v172:find("brawl", 1, true) ~= nil and true or v172:find("ring", 1, true) ~= nil
	else
		return false
	end
end

t2.value34 = t1.value3
t2.value35 = t1.value4

function t1.value4()
	t2.value16("brawlWin")

	if not t2.value13.autoWinBrawl then
		return
	end

	local function v173()
		while true do
			local running = t2.value13.running

			if running then
				running = t2.value13.autoWinBrawl
			end

			if not running then
				return
			end

			pcall(function()
				if not t2.value35() then
					return
				end

				local currentMap = t2.value7:FindFirstChild("currentMap")
				local v176, HumanoidRootPart, Humanoid, currentMap2

				if not currentMap then
					v185 = t2.value19()
					v186 = t2.value18()

					if not (not v185 or (not v186 or v186.Health <= 0)) then
						for _, player in ipairs(t2.value1:GetPlayers()) do
							if not t2.value13.autoWinBrawl then
								return
							end

							if player == t2.value7 then
								v176 = false
							else
								v176 = player.Character
							end

							if v176 then
								HumanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
								Humanoid = player.Character:FindFirstChildWhichIsA("Humanoid")

								if HumanoidRootPart then
									if Humanoid then
										Humanoid = Humanoid.Health > 0
									end
								else
									Humanoid = HumanoidRootPart
								end

								if Humanoid then
									currentMap2 = player:FindFirstChild("currentMap")

									if currentMap2 then
										currentMap2 = currentMap2.Value
									end

									if currentMap2 == currentMap then
										v185.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
										v185.AssemblyLinearVelocity = Vector3.zero
										v185.AssemblyAngularVelocity = Vector3.zero
										t2.value23(HumanoidRootPart)
									end
								end
							end
						end
					end

					return
				end

				currentMap = currentMap.Value

				local v182 = t2.value19()
				local v183 = t2.value18()

				if not (not v182 or (not v183 or v183.Health <= 0)) then
					for _, player in ipairs(t2.value1:GetPlayers()) do
						if not t2.value13.autoWinBrawl then
							return
						end

						if player == t2.value7 then
							v176 = false
						else
							v176 = player.Character
						end

						if v176 then
							HumanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
							Humanoid = player.Character:FindFirstChildWhichIsA("Humanoid")

							if HumanoidRootPart then
								if Humanoid then
									Humanoid = Humanoid.Health > 0
								end
							else
								Humanoid = HumanoidRootPart
							end

							if Humanoid then
								currentMap2 = player:FindFirstChild("currentMap")

								if currentMap2 then
									currentMap2 = currentMap2.Value
								end

								if currentMap2 == currentMap then
									v182.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
									v182.AssemblyLinearVelocity = Vector3.zero
									v182.AssemblyAngularVelocity = Vector3.zero
									t2.value23(HumanoidRootPart)
								end
							end
						end
					end
				end
			end)
			task.wait(0.01)
		end
	end

	t2.value16("brawlWin")

	local s11 = "brawlWin"

	t2.value14.brawlWin = task.spawn(function()
		pcall(v173)
		t2.value14[s11] = nil
	end)

	local _ = t2.value14.brawlWin
end

t2.value36 = t1.value4

function t1.value4(p15, p16, p17, p18, p19, p20, p21)
	local workspace_ = workspace

	if not workspace_.FindFirstChild(workspace_, p15) then
		v198 = Instance.new("Part")
		v198.Name = p15
		v198.Size = Vector3.new(p19, p20, p21)
		v198.Position = Vector3.new(p16, p17, p18)
		v198.Anchored = true
		v198.CanCollide = false
		v198.Transparency = 1
		v198.Parent = workspace

		return v198
	end

	workspace[p15]:Destroy()

	local Part = Instance.new("Part")

	Part.Name = p15
	Part.Size = Vector3.new(p19, p20, p21)
	Part.Position = Vector3.new(p16, p17, p18)
	Part.Anchored = true
	Part.CanCollide = false
	Part.Transparency = 1
	Part.Parent = workspace

	return Part
end

t1.value3 = -8851
t1.value3 = t1.value4("BrawlArea1", 4465, 177, t1.value3, 552, 400, 548)
t2.value37 = t1.value3
t1.value3 = 175
t1.value3 = t1.value4("BrawlArea2", -1856.5, t1.value3, -6315, 499, 400, 496)
t2.value38 = t1.value3
t1.value3 = 978
t1.value3 = t1.value4("BrawlArea3", t1.value3, 177, -7433, 502, 400, 504)
t2.value39 = t1.value3
t1.value3 = t2.value13
brawl = t2.value13.brawl or {
	autoJoin = false,
	autoKill = false,
	autoReset = false,
	attackMode = "Punch"
}
value12 = t1.value1
t1.value4 = "r\22\236\249\1715g\141Y0\232"
t1.value1 = value12
t1.value3.brawl = brawl
t1.value4 = 28135031730989
t1.value4 = "6MtD\31"
t2.value40 = { "Punch", "Stomp", "Ground Slam" }
t2.value41 = {}
t1.value4 = 11418785977541
t2.value42 = {
	["Magma Ring"] = true,
	["Desert Ring"] = true,
	["Boxing Ring"] = true
}
t1.value3 = {
	k = 1000,
	m = 1000000,
	b = 1000000000,
	t = 1000000000000,
	q = 1000000000000000,
	qi = 1e18,
	sx = 1e21,
	sp = 1e24
}
t2.value43 = nil

function t1.value4(p22, p23)
	if not p23 then
		return
	end

	local v190 = t2.value42[p23]

	if not v190 then
		if v190 then
			t2.value41[p22] = true
		else
			t2.value41[p22] = nil
		end

		return
	end

	v190 = p22 ~= t2.value7

	if v190 then
		t2.value41[p22] = true
	else
		t2.value41[p22] = nil
	end
end

t2.value43 = t1.value3

function t2.value44(p24)
	if p24 and (p24:FindFirstChild("leaderstats") and p24.leaderstats:FindFirstChild("Strength")) then
		local lower = string.lower
		local gsub = string.gsub
		local gsub2 = string.gsub
		local Value = p24.leaderstats.Strength.Value
		local v195 = lower(gsub(gsub2(tostring(Value), ",", ""), " ", ""))
		local v196, v197 = string.match(v195, "^([%d%.]+)([a-z]*)$")

		return not v196 and 0 or (tonumber(v196) or 0) * (t2.value43[v197] or 1)
	else
		return 0
	end
end

t2.value45 = nil

function t1.value3(p25)
	if p25 == t2.value7 then
		return
	end

	local currentMap = p25:WaitForChild("currentMap", 10)

	if not currentMap then
		return
	end

	t2.value45(p25, currentMap.Value)
	currentMap:GetPropertyChangedSignal("Value"):Connect(function()
		t2.value45(p25, currentMap.Value)
	end)
end

t2.value45 = t1.value4
t2.value46 = t1.value3
t1.value3 = ipairs
brawl = t2.value1

local function v199(p26)
	local ipairs_ = ipairs
	local value38 = t2.value38
	local value39 = t2.value39

	for _, v in ipairs_({ t2.value37, value38, value39 }) do
		local v205 = v.CFrame:PointToObjectSpace(p26)
		local Size = v.Size
		local v207 = math.abs(v205.X) <= Size.X / 2

		if v207 then
			local Y = v205.Y

			if math.abs(Y) <= Size.Y / 2 then
				local Z = v205.Z

				v207 = math.abs(Z) <= Size.Z / 2
			else
				v207 = false
			end
		end

		if v207 then
			return true
		end
	end

	return false
end
local function v210(p27)
	t2.value29()
	t2.value13.selectedRock = p27

	if p27 then
		local function v211()
			t2.value31()
			t2.value21()
		end

		v154()
		pcall(v211)

		return
	end

	if t2.value13.fastPunch then
		return
	end

	t2.value33()
end

for _, player in t1.value3(brawl:GetPlayers()) do
	task.spawn(t2.value46, player)
end

t1.value3 = t2.value1.PlayerAdded

function t1.value4(p28)
	task.spawn(t2.value46, p28)
end

t1.value3:Connect(t1.value4)
t1.value3 = t2.value1.PlayerRemoving

function t1.value4(p29)
	t2.value41[p29] = nil
end

t1.value3:Connect(t1.value4)

function t2.value47(p30)
	local Character = t2.value7.Character
	local Backpack = t2.value7:FindFirstChild("Backpack")

	if not (Character and Backpack) then
		return
	end

	local v216 = Backpack:FindFirstChild(p30) or Character:FindFirstChild(p30)
	local Humanoid = Character:FindFirstChildOfClass("Humanoid")
	local v218

	if v216 then
		if Humanoid then
			v218 = not Character:FindFirstChild(p30)
		else
			v218 = Humanoid
		end
	else
		v218 = v216
	end

	if not v218 then
		return
	end

	Humanoid:EquipTool(v216)
end

local function v219()
	local muscleEvent = t2.value7:FindFirstChild("muscleEvent")

	if not muscleEvent then
		return
	end

	local attackMode = t2.value13.brawl.attackMode or "Punch"

	if attackMode == "Punch" then
		t2.value47("Punch")
		pcall(function()
			muscleEvent:FireServer("punch", "leftHand")
			muscleEvent:FireServer("punch", "rightHand")
		end)

		return
	end

	if attackMode == "Stomp" then
		t2.value47("Stomp")
		pcall(function()
			muscleEvent:FireServer("stomp")
		end)

		return
	end

	if attackMode ~= "Ground Slam" then
		return
	end

	t2.value47("Ground Slam")
	pcall(function()
		muscleEvent:FireServer("groundSlam")
	end)
end

task.spawn(function()
	while task.wait(0.5) and t2.value13.running do
		if t2.value13.brawl.autoJoin then
			local PlayerGui = t2.value7:FindFirstChild("PlayerGui")
			local gameGui

			if PlayerGui then
				gameGui = PlayerGui:FindFirstChild("gameGui")
			else
				gameGui = PlayerGui
			end

			if gameGui then
				local baseChoiceMenu = PlayerGui.gameGui:FindFirstChild("baseChoiceMenu")
				local brawlJoinLabel = PlayerGui.gameGui:FindFirstChild("brawlJoinLabel")

				if baseChoiceMenu then
					baseChoiceMenu = baseChoiceMenu.Visible
				end

				if baseChoiceMenu then
					brawlJoinLabel = baseChoiceMenu
				elseif brawlJoinLabel then
					brawlJoinLabel = brawlJoinLabel.Visible
				end

				if brawlJoinLabel then
					local function v226()
						t2.value2.rEvents.brawlEvent:FireServer("joinBrawl")
					end

					pcall(v226)
					task.wait(2)
				end
			end
		end
	end
end)
task.spawn(function()
	while task.wait(0.5) and t2.value13.running do
		if t2.value13.brawl.autoReset then
			local PlayerGui = t2.value7:FindFirstChild("PlayerGui")
			local gameGui

			if PlayerGui then
				gameGui = PlayerGui:FindFirstChild("gameGui")
			else
				gameGui = PlayerGui
			end

			if gameGui then
				local survivorBonusLabel = PlayerGui.gameGui:FindFirstChild("survivorBonusLabel")

				if survivorBonusLabel then
					survivorBonusLabel = survivorBonusLabel.Visible
				end

				if survivorBonusLabel then
					local Character = t2.value7.Character
					local Humanoid

					if Character then
						Humanoid = Character:FindFirstChild("Humanoid")

						if Humanoid then
							Humanoid = Character.Humanoid.Health > 0
						end
					else
						Humanoid = Character
					end

					if Humanoid then
						Character.Humanoid.Health = 0
						task.wait(5)
					end
				end
			end
		end
	end
end)
t1.value4 = task.spawn
t1.value4(function()
	while task.wait(0.01) and t2.value13.running do
		if t2.value13.brawl.autoKill then
			local PlayerGui = t2.value7:FindFirstChild("PlayerGui")
			local gameGui

			if PlayerGui then
				gameGui = PlayerGui:FindFirstChild("gameGui")
			else
				gameGui = PlayerGui
			end

			if gameGui then
				local participationRewardLabel = PlayerGui.gameGui:FindFirstChild("participationRewardLabel")

				if participationRewardLabel then
					participationRewardLabel = participationRewardLabel.Visible
				end

				if participationRewardLabel then
					local Character = t2.value7.Character

					if Character then
						Character = Character:FindFirstChild("HumanoidRootPart")
					end

					if Character then
						local pairs_ = pairs
						local v237, v238, v239 = pairs_(t2.value41)
						local t8 = {}

						while true do
							local v241

							v239, v241 = v237(v238, v239)

							if not v239 then
								break
							end

							local Character2 = v239.Character

							if Character2 then
								Character2 = v239.Character:FindFirstChild("HumanoidRootPart")

								if Character2 then
									Character2 = v239.Character:FindFirstChild("Humanoid")
								end
							end

							if Character2 then
								if v239.Character.Humanoid.Health > 0 then
									local HumanoidRootPart = v239.Character.HumanoidRootPart

									pairs_ = v199

									if pairs_(HumanoidRootPart.Position) then
										pairs_ = table.insert
										pairs_(t8, {
											target = v239,
											root = HumanoidRootPart,
											force = t2.value44(v239)
										})
									end
								else
									pairs_ = t2.value41
									pairs_[v239] = nil
								end
							end
						end

						if #t8 > 0 then
							table.sort(t8, function(p31, p32)
								return p31.force < p32.force
							end)

							local v244 = t8[1]

							if v244 then
								local Character2 = v244.target.Character

								if Character2 then
									Character2 = Character2:FindFirstChild("UpperTorso") or (Character2:FindFirstChild("Torso") or Character2:FindFirstChild("HumanoidRootPart"))
								end

								local CFrame_

								if Character2 then
									CFrame_ = Character2.CFrame
								else
									CFrame_ = Character2
								end

								local CFrame_2 = CFrame_ or v244.root.CFrame

								pcall(function()
									Character.Velocity = Vector3.new(0, 0, 0)
									Character.RotVelocity = Vector3.new(0, 0, 0)

									if not Character.AssemblyLinearVelocity then
										return
									end

									Character.AssemblyLinearVelocity = Vector3.zero
									Character.AssemblyAngularVelocity = Vector3.zero
								end)
								Character.CFrame = CFrame_2

								if (t2.value13.brawl.attackMode or "Punch") == "Punch" then
									t2.value47("Punch")

									local Character3 = t2.value7.Character

									if Character3 then
										Character3 = t2.value7.Character:FindFirstChild("Punch")
									end

									local attackTime = Character3 and Character3:FindFirstChild("attackTime")

									if attackTime then
										pcall(function()
											attackTime.Value = 0
										end)
									end

									local value7 = t2.value7
									local muscleEvent = value7:FindFirstChild("muscleEvent")

									if muscleEvent then
										value7 = pcall
										value7(function()
											muscleEvent:FireServer("punch", "rightHand")
											muscleEvent:FireServer("punch", "leftHand")
											muscleEvent:FireServer("punch")
										end)
									end

									local value22 = t2.value22

									if value22 then
										value22 = t2.value22()
									end

									local v253 = value22 or nil

									if Character3 then
										Character3 = Character3:FindFirstChild("Handle")
									end

									local v254

									if v253 then
										v254 = Character3 and Character2
									else
										v254 = v253
									end

									if v254 then
										pcall(v253, Character2, Character3, 0)
										pcall(v253, Character2, Character3, 1)
									end
								else
									v219()
								end
							end
						end
					end
				end
			end
		end
	end
end)

function t1.value3(p33, p34)
	local v255 = tonumber(p34)

	if not v255 then
		return false
	end

	local changeSpeedSizeRemote = t2.value2:FindFirstChild("changeSpeedSizeRemote", true)

	if not changeSpeedSizeRemote then
		return false
	end

	return pcall(function()
		if changeSpeedSizeRemote:IsA("RemoteFunction") then
			changeSpeedSizeRemote:InvokeServer(p33, v255)
		else
			changeSpeedSizeRemote:FireServer(p33, v255)
		end
	end)
end

t2.value48 = nil

function t2.value49(p35, p36, p37, p38)
	t2.value13[p35] = p36 == true

	local exerciseMovement = t2.value13.exerciseMovement

	exerciseMovement.active[p35] = t2.value13[p35] or nil

	local v258 = "rep_" .. p35

	if t2.value13[p35] then
		local function v259()
			while true do
				local running = t2.value13.running

				if running then
					running = next(exerciseMovement.active)
				end

				if not running then
					return
				end

				local v261 = t2.value18()
				local v262 = t2.value19()

				if v261 then
					if exerciseMovement.humanoid ~= v261 then
						exerciseMovement.humanoid = v261

						local v263 = exerciseMovement
						local WalkSpeed

						if v261.WalkSpeed > 0 then
							WalkSpeed = v261.WalkSpeed
						else
							WalkSpeed = false
						end

						v263.walkSpeed = WalkSpeed or 16
					end

					if v262 then
						v262.Anchored = false
					end

					v261.PlatformStand = false
					v261.Sit = false

					local walkSpeed = t2.value13.fastSpeed and 1000 or exerciseMovement.walkSpeed
					local v266

					if walkSpeed then
						v266 = v261.WalkSpeed < walkSpeed
					else
						v266 = walkSpeed
					end

					if v266 then
						v261.WalkSpeed = walkSpeed
					end
				end

				t2.value3.Heartbeat:Wait()
			end
		end

		t2.value16("exerciseMovement")

		local s12 = "exerciseMovement"

		t2.value14.exerciseMovement = task.spawn(function()
			pcall(v259)
			t2.value14[s12] = nil
		end)

		local _ = t2.value14.exerciseMovement

		local function v269()
			while true do
				local running = t2.value13.running

				if running then
					running = t2.value13[p35]
				end

				if not running then
					return
				end

				local function v271()
					local v272 = p37

					if v272 then
						v272 = #p37 > 0
					end

					if v272 then
						t2.value20(p37)
					end

					local muscleEvent = t2.value7:FindFirstChild("muscleEvent")

					if not muscleEvent then
						return
					end

					muscleEvent:FireServer("rep")
				end

				pcall(v271)
				task.wait(p38 or 0.15)
			end
		end

		t2.value16(v258)
		t2.value14[v258] = task.spawn(function()
			pcall(v269)
			t2.value14[v258] = nil
		end)

		local _ = t2.value14[v258]

		return
	end

	t2.value16(v258)

	local v275 = t2.value17()
	local Backpack = t2.value7:FindFirstChild("Backpack")
	local v277

	if v275 then
		v277 = Backpack and p37
	else
		v277 = v275
	end

	if v277 then
		for _, v in ipairs(p37) do
			local GetChildren = v275.GetChildren

			for _, v2 in ipairs(GetChildren(v275)) do
				local isTool = v2:IsA("Tool")

				if isTool then
					isTool = v2.Name:lower() == v:lower()
				end

				if isTool then
					pcall(function()
						v2.Parent = Backpack
					end)
				end
			end
		end
	end

	if next(exerciseMovement.active) ~= nil then
		return
	end

	t2.value16("exerciseMovement")

	local humanoid = exerciseMovement.humanoid

	if humanoid then
		humanoid = exerciseMovement.humanoid.Parent
	end

	if humanoid then
		local function v285()
			local v286 = not t2.value13.fastSpeed

			if v286 then
				v286 = exerciseMovement.walkSpeed
			end

			if not v286 then
				return
			end

			exerciseMovement.humanoid.WalkSpeed = exerciseMovement.walkSpeed
		end

		pcall(v285)
	end

	exerciseMovement.humanoid = nil
end
function t1.value4(p39)
	t2.value13.walkWater = p39 == true

	local v287, v288, v289 = ipairs(t2.value48)

	while true do
		local v290

		v289, v290 = v287(v288, v289)

		if not v289 then
			break
		end

		local Parent

		if v290 then
			Parent = v290.Parent
		else
			Parent = v290
		end

		if Parent then
			v290:Destroy()
		end
	end

	table.clear(t2.value48)

	if t2.value13.walkWater then
		local vector3 = Vector3.new(-3072, -9.5, -3072)

		for i = -4, 4 do
			local v294 = i

			for i2 = -4, 4 do
				local Part = Instance.new("Part")

				Part.Name = "WaterFloor"
				Part.Size = Vector3.new(2048, 1, 2048)
				Part.Position = vector3 + Vector3.new(v294 * 2048, 0, i2 * 2048)
				Part.Anchored = true
				Part.CanCollide = true
				Part.Transparency = 1
				Part.CastShadow = false
				Part.Parent = workspace
				t2.value48[#t2.value48 + 1] = Part
			end
		end
	end
end

t2.value48 = {}
t2.value50 = t1.value4

function t1.value4()
	pcall(function()
		local rEvents = t2.value2:FindFirstChild("rEvents")

		if rEvents then
			rEvents = t2.value2.rEvents:FindFirstChild("rebirthRemote")
		end

		if not rEvents then
			return
		end

		if rEvents:IsA("RemoteFunction") then
			rEvents:InvokeServer("rebirthRequest")

			return
		end

		rEvents:FireServer("rebirthRequest")
	end)

	local function v298()
		local rebirthEvent = t2.value2:FindFirstChild("rebirthEvent", true)

		if not rebirthEvent then
			return
		end

		rebirthEvent:FireServer()
	end

	pcall(v298)
end

t2.value51 = t1.value3
t2.value52 = t1.value4
t1.value4 = {}

function t1.value4.Start(p40, p41)
	p40:Stop()
	t2.value13._fastFarmMode = p41

	local function v300()
		while true do
			local running = t2.value13.running

			if running then
				running = t2.value13._fastFarmMode == p41
			end

			if not running then
				return
			end

			local function v302()
				if p41 == "rebirth" then
					t2.value52()

					return
				end

				local muscleEvent = p41 == "strength" and t2.value7:FindFirstChild("muscleEvent")

				if not muscleEvent then
					return
				end

				for _ = 1, 5 do
					muscleEvent:FireServer("rep")
				end
			end

			pcall(v302)
			task.wait(p41 == "rebirth" and 0.15 or 0.05)
		end
	end

	t2.value16("fastFarm")

	local s13 = "fastFarm"

	t2.value14.fastFarm = task.spawn(function()
		pcall(v300)
		t2.value14[s13] = nil
	end)

	local _ = t2.value14.fastFarm
end
function t1.value4.Stop(_)
	t2.value13._fastFarmMode = nil
	t2.value16("fastFarm")
end

t2.value53 = nil
t2.value54 = nil
t2.value55 = nil

function t1.value3()
	if t2.value53 then
		pcall(function()
			t2.value53:Destroy()
		end)
		t2.value53 = nil
	end

	local Parent = t2.value54 and t2.value54.Parent

	if Parent then
		Parent = t2.value55 ~= nil
	end

	if not Parent then
		t2.value54 = nil
		t2.value55 = nil

		return
	end

	pcall(function()
		t2.value54.AutoRotate = t2.value55
	end)
	t2.value54 = nil
	t2.value55 = nil
end

t2.value55 = nil
t2.value56 = t1.value3
t1.value4 = t2.value3.Heartbeat
t1.value3 = "Connect"
value1(t1.value4:Connect(function()
	if not t2.value13.running then
		return
	end

	local v308 = t2.value18()
	local value19 = t2.value19
	local v310 = value19()

	if t2.value13.fastSpeed and v308 then
		v308.WalkSpeed = 1000
		value19 = "WalkSpeed"
	end

	local spin = t2.value13.spin

	if spin then
		spin = v310 and v308
	end

	if spin then
		if not t2.value53 or t2.value53.Parent ~= v310 then
			t2.value56()

			local _ = v308.AutoRotate

			v308.AutoRotate = false
			t2.value53 = Instance.new("BodyAngularVelocity")
			t2.value53.Name = "Spin"
			t2.value53.AngularVelocity = Vector3.new(0, 7, 0)
			t2.value53.MaxTorque = Vector3.new(0, 9000000000, 0)
			t2.value53.P = 6000
			t2.value53.Parent = v310

			return
		else
			return
		end
	end

	if not t2.value53 then
		return
	end

	t2.value56()
end))
t1.value4 = t2.value4.JumpRequest
t1.value3 = t1.value4.Connect
value1(t1.value3(t1.value4, function()
	local infiniteJump = t2.value13.infiniteJump and t2.value18()

	if not infiniteJump then
		return
	end

	infiniteJump:ChangeState(Enum.HumanoidStateType.Jumping)
end))

function t1.value4()
	local rEvents = t2.value2:FindFirstChild("rEvents")

	if rEvents then
		rEvents = t2.value2.rEvents:FindFirstChild("freeGiftClaimRemote")
	end

	if not rEvents then
		return
	end

	for i = 1, 8 do
		if not t2.value13.autoClaimGifts then
			return
		end

		pcall(function()
			if rEvents:IsA("RemoteFunction") then
				rEvents:InvokeServer("claimGift", i)
			else
				rEvents:FireServer("claimGift", i)
			end
		end)
		task.wait(0.5)
	end
end

t2.value57 = t1.value4
t1.value4 = (t2.value10.UserEnabled == nil and true or t2.value10.UserEnabled) == true
t1.value3 = (t2.value10.UserAnon == nil and true or t2.value10.UserAnon) == true
brawl = loadstring(game:HttpGet("https://raw.githubusercontent.com/slowzzx4-8/Ui-library/refs/heads/main/Void%20Ui%20Library.lua"))()
t1.value4 = {
	Enabled = t1.value4,
	Anonymous = t1.value3
}
t1.value3 = brawl:CreateWindow({
	Name = "Muscle Legends",
	Icon = "dumbbell",
	SideBarWidth = 160,
	Theme = "Blue",
	Transparent = true,
	Author = "By FourHub",
	User = t1.value4,
	Folder = "MuscleLegendsScript"
})
t2.value58 = t1.value3
brawl = Instance.new("ScreenGui")
brawl.Name = "MuscleLegendsExtraFloatButton"
brawl.ResetOnSpawn = false
brawl.DisplayOrder = 1000
brawl.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
brawl.Parent = game:GetService("CoreGui")
t2.value59 = Instance.new("ImageButton")
t2.value59.Name = "ExtraFloatButton"
t2.value59.Size = UDim2.fromOffset(58, 58)
t2.value59.Position = UDim2.new(0, 34, 0.5, 0)
t2.value59.AnchorPoint = Vector2.new(0.5, 0.5)
t2.value59.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
t2.value59.BackgroundTransparency = 0.1
t2.value59.Image = "rbxassetid://123035506495251"
t2.value59.ScaleType = Enum.ScaleType.Crop
t2.value59.AutoButtonColor = true
t2.value59.Active = true
t2.value59.ZIndex = 250
t2.value59.Parent = brawl
brawl = Instance.new("UICorner")
brawl.CornerRadius = UDim.new(1, 0)
brawl.Parent = t2.value59
t1.value3 = Instance.new("UIStroke")
t1.value3.Thickness = 1.5
t1.value3.Color = Color3.fromRGB(255, 255, 255)
t1.value3.Parent = t2.value59
t2.value60 = false
t2.value61 = nil
t2.value62 = nil
t2.value63 = false
brawl = t2.value59.InputBegan
t1.value4 = brawl.Connect
t1.value4(brawl, function(p42)
	if not (p42.UserInputType == Enum.UserInputType.MouseButton1 and true or p42.UserInputType == Enum.UserInputType.Touch) then
		return
	end

	t2.value60 = true
	t2.value63 = false
	t2.value61 = p42.Position
	t2.value62 = t2.value59.Position
	p42.Changed:Connect(function()
		if p42.UserInputState ~= Enum.UserInputState.End then
			return
		end

		t2.value60 = false
	end)
end)
brawl = t2.value4.InputChanged
t1.value3 = nil
brawl:Connect(function(p43)
	if not t2.value60 then
		return
	end

	local v316

	if p43.UserInputType == Enum.UserInputType.MouseMovement then
		v316 = false
	else
		v316 = p43.UserInputType ~= Enum.UserInputType.Touch
	end

	if v316 then
		return
	end

	local v317 = p43.Position - t2.value61
	local X = v317.X
	local v319

	if math.abs(X) > 6 then
		v319 = true
	else
		local Y = v317.Y

		v319 = math.abs(Y) > 6
	end

	if not v319 then
		t2.value59.Position = UDim2.new(t2.value62.X.Scale, t2.value62.X.Offset + v317.X, t2.value62.Y.Scale, t2.value62.Y.Offset + v317.Y)

		return
	end

	t2.value63 = true
	t2.value59.Position = UDim2.new(t2.value62.X.Scale, t2.value62.X.Offset + v317.X, t2.value62.Y.Scale, t2.value62.Y.Offset + v317.Y)
end)
t2.value59.Activated:Connect(function()
	if t2.value63 then
		return
	end

	if t2.value58.IslandOpen then
		local function v321()
			t2.value58:Close()
		end

		pcall(v321)
	else
		local function v322()
			t2.value58:Open()
		end

		pcall(v322)
	end
end)
task.defer(function()
	if not t2.value4.TouchEnabled then
		return
	end

	local ipairs_ = ipairs
	local CoreGui = game:GetService("CoreGui")

	for _, descendant in ipairs_(CoreGui.GetDescendants(CoreGui)) do
		local isImageButton = descendant:IsA("ImageButton")

		if isImageButton then
			isImageButton = descendant.Name == "Minimize"
		end

		if isImageButton then
			local function v328(input)
				local IslandOpen

				if input.UserInputType == Enum.UserInputType.Touch then
					IslandOpen = t2.value58.IslandOpen
				else
					IslandOpen = false
				end

				if not IslandOpen then
					return
				end

				task.defer(function()
					pcall(function()
						t2.value58:Close()
					end)
				end)
			end

			descendant.InputEnded:Connect(v328)
		end
	end
end)
t1.value3 = t2.value58
t1.value4 = ColorSequence
brawl = t1.value3.EditOpenButton
t1.value4 = t1.value4.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(230, 230, 230)) })
value12 = UDim.new(0, 16)
value12 = {
	Title = "Muscle Legends",
	Icon = "rbxassetid://123035506495251",
	Color = t1.value4,
	Transparency = 0.1,
	StrokeThickness = 1.2,
	AutoRotation = false,
	Speed = 12,
	CornerRadius = value12
}
brawl(t1.value3, value12)
brawl = t2.value58:Tab({
	Title = "Home",
	Icon = "house",
	Border = true
})
value12 = t2.value58:Tab({
	Title = "Farm",
	Icon = "sprout",
	Border = true
})
value1 = t2.value58:Tab({
	Title = "Rebirth",
	Icon = "refresh-cw",
	Border = true
})
t1.value4 = t2.value58:Tab({
	Title = "Brawl",
	Icon = "swords",
	Border = true
})
value66 = t2.value58:Tab({
	Title = "Pets",
	Icon = "paw-print",
	Border = true
})
t5 = t2.value58:Tab({
	Title = "Rewards",
	Icon = "gift",
	Border = true
})
t4 = t2.value58:Tab({
	Title = "Teleport",
	Icon = "map-pin",
	Border = true
})
t3 = t2.value58:Tab({
	Title = "Misc",
	Icon = "settings",
	Border = true
})
t1.value3 = {
	Main = brawl,
	AutoFarm = value12,
	Rebirths = value1,
	Brawl = t1.value4,
	Pets = value66,
	Rewards = t5,
	Teleports = t4,
	Misc = t3
}
t1.value3.Main:TabSection({
	Title = "Size / Speed"
})
brawl = t1.value3.Main
value12 = brawl.Slider
t1.value4 = t2.value10.MainSize == nil and 2 or t2.value10.MainSize
value12(brawl, {
	Title = "Size",
	Value = {
		Min = 1,
		Max = 100,
		Default = t1.value4
	},
	Step = 0.1,
	Callback = function(p44)
		t2.value13.mainSize = p44
		t2.value11("MainSize", p44)

		if not t2.value13.mainAutoSize then
			return
		end

		t2.value51("changeSize", p44)
	end
})
brawl = t1.value3.Main

if t2.value10.MainAutoSize == nil then
	value12 = false
else
	value12 = t2.value10.MainAutoSize
end

value1 = brawl.Toggle

function t1.value4(p45)
	t2.value13.mainAutoSize = p45
	t2.value11("MainAutoSize", p45)
	t2.value16("mainAutoSize")

	if not p45 then
		return
	end

	local function v330()
		while true do
			local running = t2.value13.running

			if running then
				running = t2.value13.mainAutoSize
			end

			if not running then
				return
			end

			t2.value51("changeSize", t2.value13.mainSize)
			task.wait(0.35)
		end
	end

	t2.value16("mainAutoSize")

	local s14 = "mainAutoSize"

	t2.value14.mainAutoSize = task.spawn(function()
		pcall(v330)
		t2.value14[s14] = nil
	end)

	local _ = t2.value14.mainAutoSize
end

value1(brawl, {
	Title = "Auto Size",
	Default = value12,
	Callback = t1.value4
})
brawl = t1.value3.Main
t1.value4 = t2.value10.MainSpeed == nil and 125 or t2.value10.MainSpeed
brawl.Slider(brawl, {
	Title = "Speed",
	Value = {
		Min = 16,
		Max = 500,
		Default = t1.value4
	},
	Step = 1,
	Callback = function(p46)
		t2.value13.mainSpeed = p46
		t2.value11("MainSpeed", p46)

		if not t2.value13.mainAutoSpeed then
			return
		end

		t2.value51("changeSpeed", p46)
	end
})
brawl = t1.value3.Main

if t2.value10.MainAutoSpeed == nil then
	value12 = false
else
	value12 = t2.value10.MainAutoSpeed
end

value1 = brawl.Toggle

function t1.value4(p47)
	t2.value13.mainAutoSpeed = p47
	t2.value11("MainAutoSpeed", p47)
	t2.value16("mainAutoSpeed")

	if not p47 then
		return
	end

	local function v334()
		while true do
			local running = t2.value13.running

			if running then
				running = t2.value13.mainAutoSpeed
			end

			if not running then
				return
			end

			t2.value51("changeSpeed", t2.value13.mainSpeed)
			task.wait(0.35)
		end
	end

	t2.value16("mainAutoSpeed")

	local s15 = "mainAutoSpeed"

	t2.value14.mainAutoSpeed = task.spawn(function()
		pcall(v334)
		t2.value14[s15] = nil
	end)

	local _ = t2.value14.mainAutoSpeed
end

value1(brawl, {
	Title = "Auto Speed",
	Default = value12,
	Callback = t1.value4
})
brawl = t1.value3.Main

if t2.value10.WalkOnWater == nil then
	value12 = false
else
	value12 = t2.value10.WalkOnWater
end

value1 = brawl.Toggle

function t1.value4(p48)
	t2.value11("WalkOnWater", p48)
	t2.value50(p48)
end

value1(brawl, {
	Title = "Walk Water",
	Default = value12,
	Callback = t1.value4
})
brawl = t1.value3.Main

if t2.value10.InfiniteJump == nil then
	value12 = false
else
	value12 = t2.value10.InfiniteJump
end

value1 = brawl.Toggle

function t1.value4(p49)
	t2.value11("InfiniteJump", p49)
	t2.value13.infiniteJump = p49
end

value1(brawl, {
	Title = "Inf Jump",
	Default = value12,
	Callback = t1.value4
})
brawl = t1.value3.Main
value12 = "Default"

if t2.value10.SpinChar == nil then
	value1 = false
else
	value1 = t2.value10.SpinChar
end

value66 = brawl.Toggle

function t1.value4(p50)
	t2.value11("SpinChar", p50)
	t2.value13.spin = p50
end

value66(brawl, {
	Title = "Spin",
	[value12] = value1,
	Callback = t1.value4
})
t2.value64 = {}
value1 = {}

for _, rock in ipairs(t1.value2.Rocks) do
	t5 = #value1 + 1
	t1.value4 = rock.name
	value1[t5] = t1.value4
	t5 = t2.value64
	t1.value4 = rock.name
	t5[t1.value4] = rock
end

brawl = value1[1]

if t2.value10.SelectRock ~= nil then
	brawl = t2.value10.SelectRock
end

brawl = brawl or value1[1]
value12 = t1.value1
t1.value4 = "h\142P\16N\206Sr"
t1.value1 = value12
t2.value65 = brawl
brawl = t1.value3.AutoFarm
value12 = brawl.TabSection
t1.value4 = "\139\146X\176\27=n\188"
value12(brawl, {
	Title = "Rock"
})
brawl = t1.value3.AutoFarm
value12 = table.find(value1, t2.value65) and t2.value65 or value1[1]
t1.value1 = t1.value1
brawl.Dropdown(brawl, {
	Title = "Rock",
	Option = value1,
	Value = value12,
	Callback = function(p51)
		t2.value65 = p51
		t2.value11("SelectRock", p51)

		if not t2.value13._autoRock then
			return
		end

		v210(t2.value64[p51])
	end
})
brawl = t1.value3.AutoFarm
brawl.Toggle(brawl, {
	Title = "Auto Rock",
	Default = value4("AutoRock", false),
	Callback = function(p52)
		t2.value13._autoRock = p52
		t2.value11("AutoRock", p52)

		local v340 = v210

		if not p52 then
			v340(p52 or nil)

			return
		end

		p52 = t2.value64[t2.value65]
		v340(p52 or nil)
	end
})
brawl = t1.value3.AutoFarm
value12 = brawl.Toggle

if t2.value10.FastPunch == nil then
	value1 = false
else
	value1 = t2.value10.FastPunch
end

value12(brawl, {
	Title = "Fast Punch",
	Default = value1,
	Callback = function(p53)
		t2.value11("FastPunch", p53)
		t2.value34(p53)
	end
})
t1.value3.AutoFarm:TabSection({
	Title = "Exercise"
})
brawl = t1.value3.AutoFarm
value12 = "Title"

if t2.value10.AutoUseTools == nil then
	value1 = false
else
	value1 = t2.value10.AutoUseTools
end

brawl.Toggle(brawl, {
	[value12] = "Auto Tools",
	Default = value1,
	Callback = function(p54)
		t2.value13.autoUseTools = p54
		t2.value11("AutoUseTools", p54)
		t2.value16("autoUseTools")

		if not p54 then
			return
		end

		local function v341()
			while true do
				local running = t2.value13.running

				if running then
					running = t2.value13.autoUseTools
				end

				if not running then
					return
				end

				local function v343()
					local muscleEvent = t2.value7:FindFirstChild("muscleEvent")

					if not muscleEvent then
						return
					end

					for _ = 1, 3 do
						muscleEvent:FireServer("rep")
					end
				end

				pcall(v343)
				task.wait(0.18)
			end
		end

		t2.value16("autoUseTools")

		local s16 = "autoUseTools"

		t2.value14.autoUseTools = task.spawn(function()
			pcall(v341)
			t2.value14[s16] = nil
		end)

		local _ = t2.value14.autoUseTools
	end
})
t1.value4 = {
	"Auto Handstands",
	"autoHandstands",
	{ "Handstands", "Handstand" }
}

for i, v in ipairs({
	t1.value4,
	{
		"Auto Situps",
		"autoSitups",
		{ "Situps", "Situp" }
	},
	{
		"Auto Weight",
		"autoWeight",
		{ "Weight" }
	},
	{
		"Auto Lift",
		"autoLift",
		{ "Pushup", "Pushups" }
	}
}) do
	t1.value4 = t1.value3.AutoFarm
	i = v[1]
	value66 = v[2]

	if t2.value10[value66] == nil then
		value66 = false
	else
		value66 = t2.value10[value66]
	end

	t1.value4.Toggle(t1.value4, {
		Title = i,
		Default = value66,
		Callback = function(p55)
			local v350 = v[2]

			t2.value11(v350, p55)

			local v351 = v[2]
			local v352 = v[3]

			t2.value49(v351, p55, v352, 0.15)
		end
	})
end

t1.value3.Brawl:TabSection({
	Title = "Auto Brawl"
})
brawl = t1.value3.Brawl
value12 = t2.value40
value1 = value4("BrawlAttackMode", t2.value40[1])
value1 = table.find(t2.value40, value1) and value1 or t2.value40[1]
value66 = brawl.Dropdown

function t1.value4(p56)
	t2.value13.brawl.attackMode = p56
	t2.value11("BrawlAttackMode", p56)
end

value66(brawl, {
	Title = "Modo de Ataque",
	Option = value12,
	Value = value1,
	Callback = t1.value4
})
brawl = t1.value3.Brawl
value12 = brawl.Toggle

if t2.value10.BrawlAutoJoin == nil then
	value1 = false
else
	value1 = t2.value10.BrawlAutoJoin
end

value12(brawl, {
	Title = "Auto Join Brawl",
	Default = value1,
	Callback = function(p57)
		t2.value13.brawl.autoJoin = p57 == true
		t2.value11("BrawlAutoJoin", p57 == true)
	end
})
brawl = t1.value3.Brawl

if t2.value10.BrawlAutoKill == nil then
	value12 = false
else
	value12 = t2.value10.BrawlAutoKill
end

brawl.Toggle(brawl, {
	Title = "Auto Kill",
	Default = value12,
	Callback = function(p58)
		t2.value13.brawl.autoKill = p58 == true
		t2.value11("BrawlAutoKill", p58 == true)
	end
})
brawl = t1.value3.Brawl
value12 = brawl.Toggle

if t2.value10.BrawlAutoReset == nil then
	value1 = false
else
	value1 = t2.value10.BrawlAutoReset
end

value12(brawl, {
	Title = "Auto Reset Win",
	Default = value1,
	Callback = function(p59)
		t2.value13.brawl.autoReset = p59 == true
		t2.value11("BrawlAutoReset", p59 == true)
	end
})
brawl = t1.value3.Brawl
brawl.TabSection(brawl, {
	Title = "Legacy"
})
brawl = t1.value3.Brawl
brawl.Toggle(brawl, {
	Title = "Auto Win Brawl (Legacy TP)",
	Default = value4("AutoWinBrawl", false),
	Callback = function(p60)
		t2.value13.autoWinBrawl = p60 == true
		t2.value11("AutoWinBrawl", p60 == true)
		t2.value36()
	end
})
brawl = function(p61, p62, p63)
	if not p61 then
		return nil
	end

	local v353 = p61:FindFirstChild(p62)
	local n1 = 0

	while true do
		local v355 = not v353

		if v355 then
			v355 = n1 < (p63 or 8)
		end

		if not v355 then
			return v353
		end

		task.wait(0.15)
		n1 = n1 + 0.15
		v353 = p61:FindFirstChild(p62)
	end
end
value12 = brawl(t2.value2, "rEvents", 10)
value1 = t1.value1

if value12 then
	value66 = brawl(value12, "cPetShopRemote", 8)
else
	value66 = value12
end

t2.value66 = value66

if value12 then
	value66 = brawl(value12, "petEvolveEvent", 8)
else
	value66 = value12
end

t2.value67 = value66

if value12 then
	value66 = brawl(value12, "sellPetEvent", 8)
else
	value66 = value12
end

t2.value68 = value66

if value12 then
	value66 = brawl(value12, "evolvePowerUpEvent", 8)
else
	value66 = value12
end

t1.value1 = value1
t2.value69 = value66
value1 = t1.value1

if value12 then
	value12 = brawl(value12, "sellPowerUpEvent", 8)
end

t1.value1 = value1
t2.value70 = value12
value12 = brawl(t2.value2, "shared", 8)
value1 = t1.value1

if value12 then
	value12 = brawl(value12, "runtime", 8)
end

t1.value4 = value1

if value12 then
	value12 = brawl(value12, "cPetShopFolder", 8)
end

t2.value71 = value12

function t2.value72()
	return t2.value7:FindFirstChild("petsFolder")
end
function t2.value73()
	return t2.value7:FindFirstChild("powerUpsFolder")
end

t2.value74 = {
	"Basic",
	"Advanced",
	"Rare",
	"Epic",
	"Unique"
}
t1.value1 = 7903931911776
t1.value1 = 14677991103154
t1.value1 = {
	"Golden Viking",
	"Core Pup",
	"Volt Talon",
	"Lightning Strike Phantom",
	"Dark Legends Manticore",
	"Ultimate Supernova Pegasus",
	"Green Firecaster",
	"White Pheonix",
	"Red Firecaster",
	"Golden Pheonix",
	"Blue Firecaster",
	"Blue Pheonix"
}
brawl = {
	Basic = {
		"Silver Dog",
		"Orange Hedgehog",
		"Blue Birdie",
		"Red Kitty",
		"Blue Bunny"
	},
	Advanced = {
		"Dark Golem",
		"Green Butterfly",
		"Yellow Butterfly",
		"Dark Vampy"
	},
	Rare = {
		"Eternal Strike Leviathan",
		"Crimson Falcon",
		"Frostwave Legends Penguin",
		"Phantom Genesis Dragon",
		"White Pegasus",
		"Red Dragon",
		"Purple Falcon",
		"Purple Dragon",
		"Orange Pegasus"
	},
	Epic = t1.value1,
	Unique = {
		"Muscle Sensei",
		"Neon Guardian",
		"Reactor Beast",
		"Plasma Ravager",
		"Titan Reactor",
		"Apex Overlord",
		"Darkstar Hunter",
		"Aether Spirit Bunny",
		"Cybernetic Showdown Dragon",
		"Magic Butterfly",
		"Ultra Birdie",
		"Infernal Dragon"
	}
}
t1.value1 = "\213X;v\148"
t1.value1 = "f,\"\148\208\2256K"
t1.value1 = 10765977588629
t1.value1 = {
	"Frostwave Legends Penguin",
	"Phantom Genesis Dragon",
	"Dark Legends Manticore",
	"Ultimate Supernova Pegasus",
	"Aether Spirit Bunny",
	"Cybernetic Showdown Dragon"
}
t2.value75 = {
	["Blue Crystal"] = {
		"Orange Hedgehog",
		"Blue Birdie",
		"Red Kitty",
		"Blue Bunny",
		"Dark Vampy"
	},
	["Green Crystal"] = {
		"Silver Dog",
		"Dark Golem",
		"Green Butterfly",
		"Crimson Falcon"
	},
	["Frost Crystal"] = {
		"Yellow Butterfly",
		"Purple Dragon",
		"Orange Pegasus",
		"Blue Pheonix"
	},
	["Mythical Crystal"] = {
		"Red Dragon",
		"Purple Falcon",
		"Blue Firecaster",
		"Golden Pheonix"
	},
	["Inferno Crystal"] = {
		"Red Firecaster",
		"White Pegasus",
		"Golden Pheonix",
		"Infernal Dragon"
	},
	["Legends Crystal"] = {
		"Green Firecaster",
		"White Pheonix",
		"Magic Butterfly",
		"Ultra Birdie"
	},
	["Muscle Elite Crystal"] = t1.value1,
	["Galaxy Oracle Crystal"] = { "Eternal Strike Leviathan", "Lightning Strike Phantom", "Darkstar Hunter" },
	["Jungle Crystal"] = { "Golden Viking", "Muscle Sensei", "Neon Guardian" },
	["Industrial Crystal"] = {
		"Core Pup",
		"Volt Talon",
		"Reactor Beast",
		"Plasma Ravager",
		"Titan Reactor",
		"Apex Overlord"
	}
}
t2.value76 = {
	"Muscle King",
	"Entropic Blast",
	"Eternal Megastrike",
	"Dark Storm",
	"Inferno",
	"Dark Lightning",
	"Azure Tundra",
	"Grand SuperNova",
	"Ultra Inferno",
	"Basic",
	"Advanced",
	"Rare",
	"Epic"
}
value1 = {}
value66 = {
	"Blue Crystal",
	"Green Crystal",
	"Frost Crystal",
	"Mythical Crystal",
	"Inferno Crystal",
	"Legends Crystal",
	"Muscle Elite Crystal",
	"Galaxy Oracle Crystal",
	"Jungle Crystal",
	"Industrial Crystal"
}

for _, v in pairs(brawl) do
	for _, v2 in ipairs(v) do
		if not table.find(value1, v2) then
			table.insert(value1, v2)
		end
	end
end

t1.value1 = "m\218\213G"
t1.value1 = "table"
table.sort(value1)
t1.value1 = 3739108460237
t2.value77 = "Orange Hedgehog"
t2.value78 = "Muscle King"
t2.value79 = {}
t2.value80 = {}
t1.value1 = t2.value10.SelectedSellPets == nil and {} or t2.value10.SelectedSellPets
t2.value81 = t1.value1
t2.value82 = t2.value10.SelectedSellAuras == nil and {} or t2.value10.SelectedSellAuras
brawl = t2.value81

if type(brawl) ~= "table" then
	t2.value81 = {}
end

brawl = t2.value82

if type(brawl) ~= "table" then
	t2.value82 = {}
end

brawl = t2.value10.SellPetModes == nil and {
	Normal = true,
	Evolved = false
} or t2.value10.SellPetModes
t1.value1 = t2.value10.SellAuraModes == nil and {
	Normal = true,
	Evolved = false
} or t2.value10.SellAuraModes
t2.value83 = {
	Normal = brawl.Normal ~= false,
	Evolved = brawl.Evolved == true
}
t2.value84 = {
	Normal = t1.value1.Normal ~= false,
	Evolved = t1.value1.Evolved == true
}
t2.value85 = t2.value10.SellPetRarity == nil and "Basic" or t2.value10.SellPetRarity
t2.value86 = t2.value10.SellAuraRarity == nil and "Unique" or t2.value10.SellAuraRarity

if not table.find(t2.value74, t2.value85) then
	t2.value85 = "Basic"
end

t1.value1 = table.find(t2.value74, t2.value86)

if not t1.value1 then
	t2.value86 = "Unique"
end

local value77 = (t2.value10.UserEnabled == nil and true or t2.value10.UserEnabled) == true

t1.value1 = t2.value10.UserAnon == nil and true or t2.value10.UserAnon
t1.value1 = t1.value1 == true
value77 = _G
value12 = _G
t1.value1 = false
value77.AutoBuyPets = t1.value1
value12.AutoBuyAuras = false
value77 = _G

function t1.value1(p64)
	if not (p64 and t2.value70) then
		return false
	end

	local function v361()
		t2.value70:FireServer("sellPowerUp", p64)
	end

	local ok = pcall(v361) or false

	if p64.Parent then
		ok = pcall(function()
			t2.value70:FireServer(p64)
		end) or ok
	end

	if p64.Parent then
		local function v363()
			t2.value70:InvokeServer("sellPowerUp", p64)
		end

		ok = pcall(v363) or ok
	end

	if not p64.Parent then
		return ok
	end

	local function v364()
		t2.value70:FireServer("sellPowerUp", p64.Name)
	end

	ok = pcall(v364) or ok

	return ok
end

value12 = _G
value77.AutoEvolvePets = false
value12.AutoEvolveAuras = false
value77 = _G
value12 = _G
value77.AutoSellPets = false
value12.AutoSellAuras = false

local function v365(p65)
	if p65 and t2.value71 then
		local v366 = p65 .. " Aura"
		local v367 = tostring(p65)
		local t9 = { p65, v366, v367.gsub(v367, " Aura$", "") }

		for _, v in ipairs(t9) do
			local v371 = t2.value71:FindFirstChild(v)

			if v371 then
				return v371
			end
		end

		local v372 = tostring(p65):lower()
		local ipairs_ = ipairs
		local value71 = t2.value71

		for _, child in ipairs_(value71.GetChildren(value71)) do
			local v377 = child.Name:lower()

			if (v377 == v372 or v377 == v372 .. " aura") and true or v377:find(v372, 1, true) then
				return child
			end
		end

		return nil
	else
		return nil
	end
end
local function v378(p66)
	if p66 then
		local evolved = p66:FindFirstChild("evolved")

		if evolved then
			if evolved:IsA("BoolValue") then
				return evolved.Value == true
			elseif evolved:IsA("IntValue") or evolved:IsA("NumberValue") then
				return evolved.Value ~= 0
			elseif evolved:IsA("StringValue") then
				local v380

				if evolved.Value == "" then
					v380 = false
				else
					v380 = evolved.Value:lower() ~= "false"
				end

				return v380
			else
				return true
			end
		else
			return false
		end
	else
		return false
	end
end

function t2.value87(p67)
	if type(p67) == "string" then
		local v381 = p67:lower():gsub("%s*aura$", ""):gsub("^%s+", "")

		return v381.gsub(v381, "%s+$", "")
	else
		return ""
	end
end
function t2.value88(p68, p69)
	return t2.value87(p68) == t2.value87(p69)
end
function t2.value89(p70)
	local t10 = {}

	if type(p70) == "table" then
		for k, v in pairs(p70) do
			local v385

			if type(v) == "string" then
				v385 = v ~= ""
			else
				v385 = false
			end

			if v385 then
				table.insert(t10, v)
			else
				local v386

				if type(k) == "string" then
					v386 = v == true
				else
					v386 = false
				end

				if v386 then
					table.insert(t10, k)
				end
			end
		end

		return t10
	end

	local v387

	if type(p70) == "string" then
		v387 = p70 ~= ""
	else
		v387 = false
	end

	if not v387 then
		return t10
	end

	table.insert(t10, p70)

	return t10
end

local function v388(p71, p72)
	if not (p71 and p72) then
		return 0
	end

	local n2 = 0
	local v390 = nil

	local function v391()
		local v392 = p71

		for _, descendant in ipairs(v392.GetDescendants(v392)) do
			if t2.value87(descendant.Name) == v390 and not table.find(t2.value74, descendant.Name) then
				n2 = n2 + 1
			end
		end
	end

	v390 = t2.value87(p72)
	pcall(v391)

	return n2
end

function t2.value90(p73)
	local t11 = {
		Normal = false,
		Evolved = false
	}

	if type(p73) == "table" then
		for _, v in pairs(p73) do
			local v398 = nil
			local v399

			if type(v) == "string" then
				v399 = v
			else
				local v400

				if type(v399) == "string" then
					v400 = v == true
				else
					v400 = false
				end

				if not v400 then
					v399 = v398
				end
			end

			if v399 == "Normal" then
				t11.Normal = true
			end

			if v399 == "Evolved" then
				t11.Evolved = true
			end
		end
	elseif type(p73) == "string" then
		if p73 == "Normal" then
			t11.Normal = true
		end

		if p73 == "Evolved" then
			t11.Evolved = true
		end
	end

	local v401 = not t11.Normal

	if v401 then
		v401 = not t11.Evolved
	end

	if not v401 then
		return t11
	end

	t11.Normal = true

	return t11
end

local function v402(p74, p75, p76, p77)
	local t12 = {}
	local v404 = t2.value89(p75)

	if not p74 or #v404 == 0 then
		return t12
	end

	local function v405(p78)
		if not (p78 and p78.Parent) then
			return
		end

		if table.find(t2.value74, p78.Name) then
			return
		end

		for _, v in ipairs(v404) do
			if t2.value88(p78.Name, v) then
				local v408 = p76
				local v409

				if v378(p78) then
					v409 = v408.Evolved == true
				else
					v409 = v408.Normal == true
				end

				if not v409 then
					return
				end

				local v410 = t12

				table.insert(v410, p78)

				return
			end
		end
	end

	local _ = p76 or {
		Normal = true
	}
	local t13 = {}
	local v413

	if p77 then
		v413 = p77 ~= ""
	else
		v413 = p77
	end

	local v414 = v413 and p74:FindFirstChild(p77)

	if v414 then
		table.insert(t13, v414)
	end

	if #t13 == 0 then
		for _, v in ipairs(t2.value74) do
			local v417 = p74:FindFirstChild(v)

			if v417 then
				table.insert(t13, v417)
			end
		end

		table.insert(t13, p74)
	end

	local t14 = {}

	for _, v in ipairs(t13) do
		pcall(function()
			local v421 = v
			local v422, v423, v424 = ipairs(v421.GetChildren(v421))

			while true do
				local v425

				v424, v425 = v422(v423, v424)

				if not v424 then
					break
				end

				if not t14[v425] then
					t14[v425] = true
					v405(v425)
				end
			end

			for _, descendant in ipairs(v:GetDescendants()) do
				if not t14[descendant] then
					t14[descendant] = true
					v405(descendant)
				end
			end
		end)
	end

	return t12
end

function t2.value91(p79)
	if not (p79 and t2.value68) then
		return false
	end

	local ok = pcall(function()
		t2.value68:FireServer("sellPet", p79)
	end) or false

	if p79.Parent then
		local function v429()
			t2.value68:FireServer(p79)
		end

		ok = pcall(v429) or ok
	end

	if p79.Parent then
		local function v430()
			t2.value68:InvokeServer("sellPet", p79)
		end

		ok = pcall(v430) or ok
	end

	if not p79.Parent then
		return ok
	end

	ok = pcall(function()
		t2.value68:FireServer("sellPet", p79.Name)
	end) or ok

	return ok
end

t2.value92 = t1.value1
t1.value1 = t2.value13.brawl

if t2.value10.BrawlAutoJoin == nil then
	value77 = false
else
	value77 = t2.value10.BrawlAutoJoin
end

t1.value1.autoJoin = value77 == true
t1.value1 = t2.value13.brawl
value77 = value4("BrawlAutoKill", false)
t1.value1.autoKill = value77 == true
t1.value1 = t2.value13.brawl

if t2.value10.BrawlAutoReset == nil then
	value77 = false
else
	value77 = t2.value10.BrawlAutoReset
end

t1.value1.autoReset = value77 == true
t1.value1 = t2.value13.brawl
t1.value1.attackMode = t2.value10.BrawlAttackMode == nil and "Punch" or t2.value10.BrawlAttackMode
t1.value1 = t1.value3.Pets
t1.value1.TabSection(t1.value1, {
	Title = "Buy / Evolve Pet"
})
t1.value1 = nil
t2.value93 = t1.value1
t1.value1 = t1.value3.Pets
value77 = value66[1]

if t2.value10.SelectedPetCrystal ~= nil then
	value77 = t2.value10.SelectedPetCrystal
end

value77 = value77 or value66[1]
t1.value1.Dropdown(t1.value1, {
	Title = "Crystal",
	Option = value66,
	Value = value77,
	Callback = function(p80)
		t2.value11("SelectedPetCrystal", p80)

		local value93 = t2.value93

		if value93 then
			value93 = t2.value75[p80]
		end

		if not value93 then
			return
		end

		local function v432()
			t2.value93:Refresh(t2.value75[p80])
			t2.value77 = t2.value75[p80][1]
			t2.value11("SelectedPet", t2.value77)
			t2.value93:SetValue(t2.value77)
		end

		pcall(v432)
	end
})
value77 = t2.value75
value12 = value66[1]

if t2.value10.SelectedPetCrystal ~= nil then
	value12 = t2.value10.SelectedPetCrystal
end

t1.value1 = value77[value12 or value66[1]] or t2.value75["Blue Crystal"]
value77 = t1.value1[1]

if t2.value10.SelectedPet ~= nil then
	value77 = t2.value10.SelectedPet
end

value77 = value77 or t1.value1[1]

if not table.find(t1.value1, value77) then
	value77 = t1.value1[1]
end

t2.value77 = value77
value12 = t1.value3.Pets
t2.value93 = value12.Dropdown(value12, {
	Title = "Pet",
	Option = t1.value1,
	Value = value77,
	Callback = function(p81)
		t2.value77 = p81
		t2.value11("SelectedPet", p81)
	end
})
value77 = t1.value3.Pets
value77.Button(value77, {
	Title = "Buy Pet",
	Callback = function()
		local v433 = v365(t2.value77)
		local value662

		if v433 then
			value662 = t2.value66
		else
			value662 = v433
		end

		if not value662 then
			return
		end

		local function v435()
			t2.value66:InvokeServer(v433)
		end

		pcall(v435)
	end
})
value77 = t1.value3.Pets

if t2.value10.AutoBuyPets == nil then
	value12 = false
else
	value12 = t2.value10.AutoBuyPets
end

value12 = value12 == true
value77.Toggle(value77, {
	Title = "Auto Buy Pet",
	Default = value12,
	Callback = function(p82)
		_G.AutoBuyPets = p82 == true
		t2.value11("AutoBuyPets", p82 == true)

		if not _G.AutoBuyPets then
			return
		end

		task.spawn(function()
			while true do
				local AutoBuyPets = _G.AutoBuyPets

				if AutoBuyPets then
					AutoBuyPets = t2.value13.running
				end

				if not AutoBuyPets then
					return
				end

				local v437 = v365(t2.value77)
				local value662

				if v437 then
					value662 = t2.value66
				else
					value662 = v437
				end

				if value662 then
					local function v439()
						t2.value66:InvokeServer(v437)
					end

					pcall(v439)
				end

				task.wait(0.1)
			end
		end)
	end
})
value77 = t1.value3.Pets
value12 = t2.value10.SelectedEvolvePets == nil and {} or t2.value10.SelectedEvolvePets
t1.value1 = t1.value4
value77.Dropdown(value77, {
	Title = "Evolve Pets",
	Option = value1,
	Multi = true,
	Value = value12 or {},
	Callback = function(p83)
		t2.value79 = t2.value89(p83)
		t2.value11("SelectedEvolvePets", t2.value79)
	end
})
value77 = t1.value3.Pets
t1.value4 = 27901018174144
value12 = value4("AutoEvolvePets", false)
value77.Toggle(value77, {
	Title = "Auto Evolve Pets",
	Default = value12 == true,
	Callback = function(p84)
		_G.AutoEvolvePets = p84 == true
		t2.value11("AutoEvolvePets", p84 == true)

		if not _G.AutoEvolvePets then
			return
		end

		task.spawn(function()
			while true do
				local AutoEvolvePets = _G.AutoEvolvePets

				if AutoEvolvePets then
					AutoEvolvePets = t2.value13.running
				end

				if not AutoEvolvePets then
					return
				end

				local v441 = t2.value72()
				local ipairs_ = ipairs
				local value79 = t2.value79

				for _, v in ipairs_(t2.value89(value79)) do
					if v388(v441, v) >= 5 and t2.value67 then
						local function v446()
							t2.value67:FireServer("evolvePet", v)
						end

						pcall(v446)
					end
				end

				task.wait(0.5)
			end
		end)
	end
})
value77 = function(p85)
	local t15 = {}

	if p85.Normal then
		table.insert(t15, "Normal")
	end

	if not p85.Evolved then
		return #t15 == 0 and { "Normal" } or t15
	end

	table.insert(t15, "Evolved")

	return #t15 == 0 and { "Normal" } or t15
end
value12 = t1.value3.Pets
t1.value4 = "\241\169p\214\246"
value66 = {
	Title = "Sell Pet Mode",
	Option = { "Normal", "Evolved" },
	Multi = true,
	Value = value77(t2.value83),
	Callback = function(p86)
		t2.value83 = t2.value90(p86)
		t2.value11("SellPetModes", t2.value83)
	end
}
value12.Dropdown(value12, value66)
value12 = t1.value3.Pets
value66 = t2.value74
t5 = t1.value1
t1.value4 = t1.value1
t5 = table.find(t2.value74, t2.value85)

if t5 then
	t5 = t2.value85
end

t1.value1 = t1.value4
t5 = t5 or t2.value74[1]
value12.Dropdown(value12, {
	Title = "Sell Pet Rarity",
	Option = value66,
	Value = t5,
	Callback = function(p87)
		t2.value85 = p87
		t2.value11("SellPetRarity", p87)
	end
})
value12 = t1.value3.Pets
t1.value4 = 11185956885592
value66 = t2.value81
t5 = value12.Dropdown

function t1.value4(p88)
	t2.value81 = t2.value89(p88)
	t2.value11("SelectedSellPets", t2.value81)
end

t5(value12, {
	Title = "Pets to Sell",
	Option = value1,
	Multi = true,
	Value = value66,
	Callback = t1.value4
})
value12 = t1.value3.Pets
value12.Button(value12, {
	Title = "Sell Pet",
	Callback = function()
		local v448 = t2.value72()
		local v449 = t2.value89(t2.value81)

		if #v449 == 0 then
			return
		end

		local v450 = v402
		local value85 = t2.value85
		local v452 = v450(v448, v449, t2.value83, value85)

		if #v452 == 0 then
			v452 = v402(v448, v449, t2.value83, nil)
		end

		if not (#v452 >= 1) then
			return
		end

		t2.value91(v452[1])
	end
})
value12 = t1.value3.Pets

if t2.value10.AutoSellPets == nil then
	value1 = false
else
	value1 = t2.value10.AutoSellPets
end

value1 = value1 == true
value12.Toggle(value12, {
	Title = "Auto Sell Pets",
	Default = value1,
	Callback = function(p89)
		_G.AutoSellPets = p89 == true
		t2.value11("AutoSellPets", p89 == true)

		if not _G.AutoSellPets then
			return
		end

		task.spawn(function()
			while true do
				local AutoSellPets = _G.AutoSellPets

				if AutoSellPets then
					AutoSellPets = t2.value13.running
				end

				if not AutoSellPets then
					return
				end

				local v454 = t2.value72()
				local v455 = t2.value89(t2.value81)

				if #v455 > 0 then
					local v456 = v402
					local value85 = t2.value85
					local v458 = v456(v454, v455, t2.value83, value85)

					if #v458 == 0 then
						v458 = v402(v454, v455, t2.value83, nil)
					end

					if #v458 >= 1 then
						t2.value91(v458[1])
					end
				end

				task.wait(0.4)
			end
		end)
	end
})
t1.value3.Pets:TabSection({
	Title = "Buy / Evolve Aura"
})
value12 = t1.value3.Pets
value1 = t2.value76
value66 = t2.value76[1]

if t2.value10.SelectedAura ~= nil then
	value66 = t2.value10.SelectedAura
end

value66 = table.find(t2.value76, value66) and value66 and value66 or t2.value76[1]
value12.Dropdown(value12, {
	Title = "Aura",
	Option = value1,
	Value = value66,
	Callback = function(p90)
		t2.value78 = p90
		t2.value11("SelectedAura", p90)
	end
})
value12 = t1.value3.Pets
value12.Button(value12, {
	Title = "Buy Aura",
	Callback = function()
		local v459 = v365(t2.value78)
		local value662

		if v459 then
			value662 = t2.value66
		else
			value662 = v459
		end

		if not value662 then
			return
		end

		local function v461()
			t2.value66:InvokeServer(v459)
		end

		pcall(v461)
	end
})
value12 = t1.value3.Pets

if t2.value10.AutoBuyAuras == nil then
	value1 = false
else
	value1 = t2.value10.AutoBuyAuras
end

t1.value4 = "\203{\27M\247\161\215G"
value1 = value1 == true
value12.Toggle(value12, {
	Title = "Auto Buy Aura",
	Default = value1,
	Callback = function(p91)
		_G.AutoBuyAuras = p91 == true
		t2.value11("AutoBuyAuras", p91 == true)

		if not _G.AutoBuyAuras then
			return
		end

		task.spawn(function()
			while true do
				local AutoBuyAuras = _G.AutoBuyAuras

				if AutoBuyAuras then
					AutoBuyAuras = t2.value13.running
				end

				if not AutoBuyAuras then
					return
				end

				local v463 = v365(t2.value78)
				local value662

				if v463 then
					value662 = t2.value66
				else
					value662 = v463
				end

				if value662 then
					local function v465()
						t2.value66:InvokeServer(v463)
					end

					pcall(v465)
				end

				task.wait(0.15)
			end
		end)
	end
})
value12 = t1.value3.Pets
value1 = t2.value76
value66 = t2.value10.SelectedEvolveAuras == nil and {} or t2.value10.SelectedEvolveAuras
value12.Dropdown(value12, {
	Title = "Evolve Auras",
	Option = value1,
	Multi = true,
	Value = value66 or {},
	Callback = function(p92)
		t2.value80 = t2.value89(p92)
		t2.value11("SelectedEvolveAuras", t2.value80)
	end
})
value12 = t1.value3.Pets

if t2.value10.AutoEvolveAuras == nil then
	value1 = false
else
	value1 = t2.value10.AutoEvolveAuras
end

value1 = value1 == true
value12.Toggle(value12, {
	Title = "Auto Evolve Auras",
	Default = value1,
	Callback = function(p93)
		_G.AutoEvolveAuras = p93 == true
		t2.value11("AutoEvolveAuras", p93 == true)

		if not _G.AutoEvolveAuras then
			return
		end

		task.spawn(function()
			while true do
				local AutoEvolveAuras = _G.AutoEvolveAuras

				if AutoEvolveAuras then
					AutoEvolveAuras = t2.value13.running
				end

				if not AutoEvolveAuras then
					return
				end

				local v467 = t2.value73()
				local ipairs_ = ipairs
				local value80 = t2.value80

				for _, v in ipairs_(t2.value89(value80)) do
					if v388(v467, v) >= 5 and t2.value69 then
						pcall(function()
							t2.value69:FireServer("evolvePowerUp", v)
						end)
					end
				end

				task.wait(0.5)
			end
		end)
	end
})
value12 = t1.value3.Pets
value77 = {
	Title = "Sell Aura Mode",
	Option = { "Normal", "Evolved" },
	Multi = true,
	Value = value77(t2.value84),
	Callback = function(p94)
		t2.value84 = t2.value90(p94)
		t2.value11("SellAuraModes", t2.value84)
	end
}
value12.Dropdown(value12, value77)
value77 = t1.value3.Pets
value12 = t2.value74
value1 = table.find(t2.value74, t2.value86) and t2.value86 or t2.value74[1]
value77.Dropdown(value77, {
	Title = "Sell Aura Rarity",
	Option = value12,
	Value = value1,
	Callback = function(p95)
		t2.value86 = p95
		t2.value11("SellAuraRarity", p95)
	end
})
value77 = t1.value3.Pets
value77.Dropdown(value77, {
	Title = "Auras to Sell",
	Option = t2.value76,
	Multi = true,
	Value = t2.value82,
	Callback = function(p96)
		t2.value82 = t2.value89(p96)
		t2.value11("SelectedSellAuras", t2.value82)
	end
})
value77 = t1.value3.Pets
value77.Button(value77, {
	Title = "Sell Aura",
	Callback = function()
		local v472 = t2.value73()
		local v473 = t2.value89(t2.value82)

		if #v473 == 0 then
			return
		end

		local v474 = v402
		local value86 = t2.value86
		local v476 = v474(v472, v473, t2.value84, value86)

		if #v476 == 0 then
			v476 = v402(v472, v473, t2.value84, nil)
		end

		if not (#v476 >= 1) then
			return
		end

		t2.value92(v476[1])
	end
})
value77 = t1.value3.Pets

if t2.value10.AutoSellAuras == nil then
	value12 = false
else
	value12 = t2.value10.AutoSellAuras
end

value12 = value12 == true
value77.Toggle(value77, {
	Title = "Auto Sell Auras",
	Default = value12,
	Callback = function(p97)
		_G.AutoSellAuras = p97 == true
		t2.value11("AutoSellAuras", p97 == true)

		if not _G.AutoSellAuras then
			return
		end

		task.spawn(function()
			while true do
				local AutoSellAuras = _G.AutoSellAuras

				if AutoSellAuras then
					AutoSellAuras = t2.value13.running
				end

				if not AutoSellAuras then
					return
				end

				local v478 = t2.value73()
				local v479 = t2.value89(t2.value82)

				if #v479 > 0 then
					local v480 = v402
					local value86 = t2.value86
					local v482 = v480(v478, v479, t2.value84, value86)

					if #v482 == 0 then
						v482 = v402(v478, v479, t2.value84, nil)
					end

					if #v482 >= 1 then
						t2.value92(v482[1])
					end
				end

				task.wait(0.4)
			end
		end)
	end
})
value77 = t1.value3.Rebirths
value77.TabSection(value77, {
	Title = "Auto"
})
value77 = t1.value3.Rebirths
value12 = t2.value10.RebirthObjective == nil and "" or t2.value10.RebirthObjective
value12 = tostring(value12 or "")
value1 = t2.value10.RebirthObjective == nil and "" or t2.value10.RebirthObjective
t1.value4 = tostring(value1 or "")
value77.Input(value77, {
	Title = "Rebirth objective",
	Placeholder = "18980",
	Default = value12,
	Value = t1.value4,
	Callback = function(p98)
		local objective = tonumber(string.match(tostring(p98 or ""), "%d+"))

		t2.value13.rebirth.objective = objective or 0
		t2.value11("RebirthObjective", t2.value13.rebirth.objective)
	end
})
value77 = t1.value3.Rebirths
value77.Toggle(value77, {
	Title = "Auto Rebirth",
	Default = false,
	Callback = function(p99)
		t2.value13.rebirth.autoRebirth = p99

		if p99 then
			t2.value13.rebirth.infinite = false
		end

		t2.value16("smartAutoRebirthTask")

		if not p99 then
			return
		end

		local function v484()
			while true do
				local running = t2.value13.running

				if running then
					running = t2.value13.rebirth.autoRebirth
				end

				if not running then
					return
				end

				local function v486()
					local Value = t2.value7.leaderstats.Rebirths.Value
					local v488 = tonumber(Value) or 0
					local v489

					if t2.value13.rebirth.objective > 0 then
						v489 = t2.value13.rebirth.objective <= v488
					else
						v489 = false
					end

					if v489 then
						t2.value13.rebirth.autoRebirth = false
					else
						t2.value52()
					end
				end

				pcall(v486)
				task.wait(1.5)
			end
		end

		t2.value16("smartAutoRebirthTask")

		local s17 = "smartAutoRebirthTask"

		t2.value14.smartAutoRebirthTask = task.spawn(function()
			pcall(v484)
			t2.value14[s17] = nil
		end)

		local _ = t2.value14.smartAutoRebirthTask
	end
})
value77 = t1.value3.Rebirths
value77.Toggle(value77, {
	Title = "Infinite",
	Default = false,
	Callback = function(p100)
		t2.value13.rebirth.infinite = p100

		if p100 then
			t2.value13.rebirth.autoRebirth = false
		end

		t2.value16("rebirthLoop")

		if not p100 then
			return
		end

		local function v492()
			while true do
				local running = t2.value13.running

				if running then
					running = t2.value13.rebirth.infinite
				end

				if not running then
					return
				end

				t2.value52()
				task.wait(0.1)
			end
		end

		t2.value16("rebirthLoop")

		local s18 = "rebirthLoop"

		t2.value14.rebirthLoop = task.spawn(function()
			pcall(v492)
			t2.value14[s18] = nil
		end)

		local _ = t2.value14.rebirthLoop
	end
})
value77 = t1.value3.Rebirths
value77.TabSection(value77, {
	Title = "Extra"
})
value77 = t1.value3.Rebirths
value77.Toggle(value77, {
	Title = "Muscle King",
	Default = false,
	Callback = function(p101)
		t2.value13.rebirth.king = p101
		t2.value16("rebirthKing")

		if not p101 then
			return
		end

		local vector3 = Vector3.new(-8646, 13.25, -5738)

		local function v497()
			while true do
				local running = t2.value13.running

				if running then
					running = t2.value13.rebirth.king
				end

				if not running then
					return
				end

				local v499 = t2.value19()
				local v500

				if v499 then
					v500 = (v499.Position - vector3).Magnitude > 42
				else
					v500 = v499
				end

				if v500 then
					v499.CFrame = CFrame.new(vector3)
					v499.AssemblyLinearVelocity = Vector3.zero
					v499.AssemblyAngularVelocity = Vector3.zero
				end

				task.wait(0.2)
			end
		end

		t2.value16("rebirthKing")

		local s19 = "rebirthKing"

		t2.value14.rebirthKing = task.spawn(function()
			pcall(v497)
			t2.value14[s19] = nil
		end)

		local _ = t2.value14.rebirthKing
	end
})
t1.value3.Rebirths:Toggle({
	Title = "Lock Position",
	Default = false,
	Callback = function(p102)
		t2.value13.rebirth.lockPosition = p102

		local CFrame_ = t2.value19()
		local rebirth = t2.value13.rebirth

		if p102 then
			if CFrame_ then
				CFrame_ = CFrame_.CFrame
			end
		else
			CFrame_ = p102
		end

		rebirth.lockCFrame = CFrame_ or nil
		t2.value16("rebirthLock")

		if p102 then
			p102 = t2.value13.rebirth.lockCFrame
		end

		if not p102 then
			return
		end

		local function v505()
			while true do
				local running = t2.value13.running

				if running then
					running = t2.value13.rebirth.lockPosition
				end

				if not running then
					return
				end

				local v507 = t2.value19()
				local lockCFrame

				if v507 then
					lockCFrame = t2.value13.rebirth.lockCFrame
				else
					lockCFrame = v507
				end

				if lockCFrame then
					v507.CFrame = t2.value13.rebirth.lockCFrame
					v507.AssemblyLinearVelocity = Vector3.zero
					v507.AssemblyAngularVelocity = Vector3.zero
				end

				t2.value3.Heartbeat:Wait()
			end
		end

		t2.value16("rebirthLock")

		local s20 = "rebirthLock"

		t2.value14.rebirthLock = task.spawn(function()
			pcall(v505)
			t2.value14[s20] = nil
		end)

		local _ = t2.value14.rebirthLock
	end
})
value77 = t1.value3.Rewards
value77.TabSection(value77, {
	Title = "Rewards"
})
value77 = t1.value3.Rewards

if t2.value10.SpinWheel == nil then
	value12 = false
else
	value12 = t2.value10.SpinWheel
end

value77:Toggle({
	Title = "Spin Wheel",
	Default = value12,
	Callback = function(p103)
		t2.value13.autoSpinWheel = p103
		t2.value11("SpinWheel", p103)
		t2.value16("fortuneWheel")

		if not p103 then
			return
		end

		local function v511()
			while true do
				local running = t2.value13.running

				if running then
					running = t2.value13.autoSpinWheel
				end

				if not running then
					return
				end

				pcall(function()
					local fortuneWheelMenuGui = t2.value8:FindFirstChild("fortuneWheelMenuGui")

					if not fortuneWheelMenuGui then
						return
					end

					local spinAmountLabel = fortuneWheelMenuGui:FindFirstChild("spinAmountLabel", true)

					if not (spinAmountLabel and spinAmountLabel.Text) then
						return
					end

					local Text = spinAmountLabel.Text
					local v516 = tostring(Text)
					local huge

					if v516:lower():find("inf", 1, true) or v516:find("∞") then
						huge = math.huge
					else
						local match = string.match

						huge = tonumber(match(v516, "%d+")) or 0
					end

					if not (huge >= 1) then
						return
					end

					t2.value2.rEvents.openFortuneWheelRemote:InvokeServer("openFortuneWheel", t2.value2.shared.catalogs.fortuneWheelChances["Fortune Wheel"])
				end)
				task.wait(1.5)
			end
		end

		t2.value16("fortuneWheel")

		local s21 = "fortuneWheel"

		t2.value14.fortuneWheel = task.spawn(function()
			pcall(v511)
			t2.value14[s21] = nil
		end)

		local _ = t2.value14.fortuneWheel
	end
})
value77 = t1.value3.Rewards

if t2.value10.AutoClaimGifts == nil then
	value12 = false
else
	value12 = t2.value10.AutoClaimGifts
end

value77.Toggle(value77, {
	Title = "Auto Claim Gifts",
	Default = value12,
	Callback = function(p104)
		t2.value13.autoClaimGifts = p104 == true
		t2.value11("AutoClaimGifts", p104 == true)
		t2.value16("claimGifts")

		if not p104 then
			return
		end

		local function v521()
			while true do
				local running = t2.value13.running

				if running then
					running = t2.value13.autoClaimGifts
				end

				if not running then
					return
				end

				t2.value57()
				task.wait(2)
			end
		end

		t2.value16("claimGifts")

		local s22 = "claimGifts"

		t2.value14.claimGifts = task.spawn(function()
			pcall(v521)
			t2.value14[s22] = nil
		end)

		local _ = t2.value14.claimGifts
	end
})
t1.value3.Rewards:TabSection({
	Title = "Codes"
})
value77 = t1.value3.Rewards
value12 = "Default"

if t2.value10.AutoUseCodes == nil then
	value1 = false
else
	value1 = t2.value10.AutoUseCodes
end

value77.Toggle(value77, {
	Title = "Auto Use Codes",
	[value12] = value1 == true,
	Callback = function(p105)
		t2.value13.autoUseCodes = p105 == true
		t2.value11("AutoUseCodes", p105 == true)
		t2.value16("autoUseCodes")

		if not p105 then
			return
		end

		local function v525()
			local t16 = {
				"mightygems2500",
				"ultimate250",
				"spacegems50",
				"megalift50",
				"speedy50",
				"epicreward500",
				"MillionWarriors",
				"frostgems10",
				"Musclestorm50",
				"Skyagility50",
				"galaxycrystal50",
				"supermuscle100",
				"superpunch100",
				"launch250",
				"MLREVIVED",
				"INDUSTRIALGYM500",
				"BOSSSTRIKE",
				"BOSSGUARD"
			}
			local rEvents = t2.value2:FindFirstChild("rEvents")

			if rEvents then
				rEvents = t2.value2.rEvents:FindFirstChild("codeRemote")
			end

			if not rEvents then
				return
			end

			for _, v in ipairs(t16) do
				if not (t2.value13.running and t2.value13.autoUseCodes) then
					t2.value13.autoUseCodes = false

					return
				end

				pcall(function()
					rEvents:InvokeServer(v)
				end)
				task.wait(0.8)
			end

			t2.value13.autoUseCodes = false
		end

		t2.value16("autoUseCodes")

		local s23 = "autoUseCodes"

		t2.value14.autoUseCodes = task.spawn(function()
			pcall(v525)
			t2.value14[s23] = nil
		end)

		local _ = t2.value14.autoUseCodes
	end
})
t1.value3.Teleports:TabSection({
	Title = "Places"
})

for i, teleport in ipairs(t1.value2.Teleports) do
	i = t1.value3.Teleports
	value66 = teleport[1]

	function t1.value4()
		local v534 = t2.value19()

		if not v534 then
			return
		end

		v534.CFrame = CFrame.new(teleport[2])
	end

	i.Button(i, {
		Title = value66,
		Callback = t1.value4
	})
end

t1.value3.Misc:TabSection({
	Title = "Protein"
})
t2.value94 = {}

for _, v in ipairs(t2.value12) do
	t2.value94[#t2.value94 + 1] = v.tool
end

value77 = value4("SelectedProteinItems", { t2.value94[1] })

if type(value77) ~= "table" then
	if type(value77) == "string" then
		value12 = value77 ~= ""
	else
		value12 = false
	end

	value77 = value12 and { value77 } or { t2.value94[1] }
end

value77 = #value77 == 0 and { t2.value94[1] } or value77
value66 = {}

for _, v in ipairs(value77) do
	value66[v] = true
end

t2.value13.selectedProteinItems = value66
value12 = t1.value3.Misc
t1.value4 = t2.value94
value1 = value12.Dropdown

function t1.value2(p106)
	local selectedProteinItems = {}
	local t17 = {}

	if type(p106) == "table" then
		for _, v in ipairs(p106) do
			selectedProteinItems[v] = true
			table.insert(t17, v)
		end
	elseif type(p106) == "string" then
		selectedProteinItems[p106] = true
		table.insert(t17, p106)
	end

	local v543

	if #t17 == 0 then
		v543 = t2.value94[1]
	else
		v543 = false
	end

	if not v543 then
		t2.value13.selectedProteinItems = selectedProteinItems
		t2.value11("SelectedProteinItems", t17)

		return
	end

	selectedProteinItems[t2.value94[1]] = true
	t17 = { t2.value94[1] }
	t2.value13.selectedProteinItems = selectedProteinItems
	t2.value11("SelectedProteinItems", t17)
end

value1(value12, {
	Title = "Items",
	Option = t1.value4,
	Multi = true,
	Value = value77,
	Callback = t1.value2
})
value77 = t1.value3.Misc
t1.value4 = value4
value12 = value77.Toggle
value1 = t1.value4("AutoEatProtein", false)

function t1.value2(p107)
	t2.value13.autoEatProtein = p107
	t2.value11("AutoEatProtein", p107)
	t2.value16("autoEatProtein")

	if not p107 then
		return
	end

	local function v544()
		while true do
			local running = t2.value13.running

			if running then
				running = t2.value13.autoEatProtein
			end

			if not running then
				return
			end

			local function v546()
				local muscleEvent = t2.value7:FindFirstChild("muscleEvent")

				if muscleEvent then
					local selectedProteinItems = t2.value13.selectedProteinItems

					if type(selectedProteinItems) ~= "table" and true or next(selectedProteinItems) == nil then
						return
					else
						for _, v in ipairs(t2.value12) do
							if selectedProteinItems[v.tool] then
								local v551 = t2.value20({ v.tool })

								if v551 then
									muscleEvent:FireServer(v.event, v551)
								end
							end
						end

						return
					end
				end
			end

			pcall(v546)
			task.wait(0.28)
		end
	end

	t2.value16("autoEatProtein")

	local s24 = "autoEatProtein"

	t2.value14.autoEatProtein = task.spawn(function()
		pcall(v544)
		t2.value14[s24] = nil
	end)

	local _ = t2.value14.autoEatProtein
end

value12(value77, {
	Title = "Auto Eat",
	Default = value1,
	Callback = t1.value2
})
t1.value3.Misc:TabSection({
	Title = "Window"
})
value77 = t1.value3.Misc
value12 = t2.value10.UserEnabled == nil and true or t2.value10.UserEnabled

function t1.value2(p108)
	t2.value11("UserEnabled", p108 == true)

	local function v554()
		t2.value58:UserEnabled(p108)
	end

	pcall(v554)
end

value77.Toggle(value77, {
	Title = "User",
	Default = value12,
	Callback = t1.value2
})
value77 = t1.value3.Misc
value12 = t2.value10.UserAnon == nil and true or t2.value10.UserAnon
value1 = value77.Toggle

function t1.value2(p109)
	t2.value11("UserAnon", p109 == true)

	local function v555()
		t2.value58:Anonymous(p109)
	end

	pcall(v555)
end

value1(value77, {
	Title = "Anonymous",
	Default = value12,
	Callback = t1.value2
});
(function()
	local RebirthObjective = t2.value10.RebirthObjective == nil and 0 or t2.value10.RebirthObjective

	t2.value13.rebirth.objective = tonumber(RebirthObjective) or 0
	t2.value13.mainSize = t2.value10.MainSize == nil and 2 or t2.value10.MainSize
	t2.value13.mainSpeed = t2.value10.MainSpeed == nil and 125 or t2.value10.MainSpeed

	local v557

	if t2.value10.MainAutoSize == nil then
		v557 = false
	else
		v557 = t2.value10.MainAutoSize
	end

	if v557 then
		t2.value13.mainAutoSize = true

		local function v558()
			while true do
				local running = t2.value13.running

				if running then
					running = t2.value13.mainAutoSize
				end

				if not running then
					return
				end

				t2.value51("changeSize", t2.value13.mainSize)
				task.wait(0.35)
			end
		end

		t2.value16("mainAutoSize")

		local s25 = "mainAutoSize"

		t2.value14.mainAutoSize = task.spawn(function()
			pcall(v558)
			t2.value14[s25] = nil
		end)

		local _ = t2.value14.mainAutoSize
	end

	local v562

	if t2.value10.MainAutoSpeed == nil then
		v562 = false
	else
		v562 = t2.value10.MainAutoSpeed
	end

	if v562 then
		t2.value13.mainAutoSpeed = true

		local function v563()
			while true do
				local running = t2.value13.running

				if running then
					running = t2.value13.mainAutoSpeed
				end

				if not running then
					return
				end

				t2.value51("changeSpeed", t2.value13.mainSpeed)
				task.wait(0.35)
			end
		end

		t2.value16("mainAutoSpeed")

		local s26 = "mainAutoSpeed"

		t2.value14.mainAutoSpeed = task.spawn(function()
			pcall(v563)
			t2.value14[s26] = nil
		end)

		local _ = t2.value14.mainAutoSpeed
	end

	local v567

	if t2.value10.WalkOnWater == nil then
		v567 = false
	else
		v567 = t2.value10.WalkOnWater
	end

	if v567 then
		t2.value50(true)
	end

	local v568

	if t2.value10.InfiniteJump == nil then
		v568 = false
	else
		v568 = t2.value10.InfiniteJump
	end

	if v568 then
		t2.value13.infiniteJump = true
	end

	local v569

	if t2.value10.SpinChar == nil then
		v569 = false
	else
		v569 = t2.value10.SpinChar
	end

	if v569 then
		t2.value13.spin = true
	end

	local v570

	if t2.value10.AutoRock == nil then
		v570 = false
	else
		v570 = t2.value10.AutoRock
	end

	if v570 then
		t2.value13._autoRock = true
		v210(t2.value64[t2.value65])
	end

	local v571

	if t2.value10.FastPunch == nil then
		v571 = false
	else
		v571 = t2.value10.FastPunch
	end

	if v571 then
		t2.value34(true)
	end

	local v572

	if t2.value10.AutoJoinBrawl == nil then
		v572 = false
	else
		v572 = t2.value10.AutoJoinBrawl
	end

	if v572 then
		t2.value13._autoBrawl = true

		local function v573()
			while true do
				local running = t2.value13.running

				if running then
					running = t2.value13._autoBrawl
				end

				if not running then
					return
				end

				local function v575()
					local gameGui = t2.value8:FindFirstChild("gameGui")

					if gameGui then
						gameGui = t2.value8.gameGui:FindFirstChild("brawlJoinLabel")
					end

					if gameGui then
						gameGui = gameGui.Visible
					end

					if not gameGui then
						return
					end

					t2.value2.rEvents.brawlEvent:FireServer("joinBrawl")
					task.wait(3)
				end

				pcall(v575)
				task.wait(0.5)
			end
		end

		t2.value16("autoBrawlJoin")

		local s27 = "autoBrawlJoin"

		t2.value14.autoBrawlJoin = task.spawn(function()
			pcall(v573)
			t2.value14[s27] = nil
		end)

		local _ = t2.value14.autoBrawlJoin
	end

	local v579

	if t2.value10.AutoWinBrawl == nil then
		v579 = false
	else
		v579 = t2.value10.AutoWinBrawl
	end

	if v579 then
		t2.value13.autoWinBrawl = true
		t2.value36()
	end

	local v580

	if t2.value10.AutoUseTools == nil then
		v580 = false
	else
		v580 = t2.value10.AutoUseTools
	end

	if v580 then
		t2.value13.autoUseTools = true

		local function v581()
			while true do
				local running = t2.value13.running

				if running then
					running = t2.value13.autoUseTools
				end

				if not running then
					return
				end

				pcall(function()
					local muscleEvent = t2.value7:FindFirstChild("muscleEvent")

					if not muscleEvent then
						return
					end

					for _ = 1, 3 do
						muscleEvent:FireServer("rep")
					end
				end)
				task.wait(0.18)
			end
		end

		t2.value16("autoUseTools")

		local s28 = "autoUseTools"

		t2.value14.autoUseTools = task.spawn(function()
			pcall(v581)
			t2.value14[s28] = nil
		end)

		local _ = t2.value14.autoUseTools
	end

	local v587

	if t2.value10.autoHandstands == nil then
		v587 = false
	else
		v587 = t2.value10.autoHandstands
	end

	if v587 then
		t2.value49("autoHandstands", true, { "Handstands", "Handstand" }, 0.15)
	end

	local v588

	if t2.value10.autoSitups == nil then
		v588 = false
	else
		v588 = t2.value10.autoSitups
	end

	if v588 then
		t2.value49("autoSitups", true, { "Situps", "Situp" }, 0.15)
	end

	local v589

	if t2.value10.autoWeight == nil then
		v589 = false
	else
		v589 = t2.value10.autoWeight
	end

	if v589 then
		t2.value49("autoWeight", true, { "Weight" }, 0.15)
	end

	local v590

	if t2.value10.autoLift == nil then
		v590 = false
	else
		v590 = t2.value10.autoLift
	end

	if v590 then
		t2.value49("autoLift", true, { "Pushup", "Pushups" }, 0.15)
	end

	local v591

	if t2.value10.AutoEatProtein == nil then
		v591 = false
	else
		v591 = t2.value10.AutoEatProtein
	end

	if v591 then
		t2.value13.autoEatProtein = true

		local function v592()
			while true do
				local running = t2.value13.running

				if running then
					running = t2.value13.autoEatProtein
				end

				if not running then
					return
				end

				local function v594()
					local muscleEvent = t2.value7:FindFirstChild("muscleEvent")

					if muscleEvent then
						local selectedProteinItems = t2.value13.selectedProteinItems

						if type(selectedProteinItems) ~= "table" and true or next(selectedProteinItems) == nil then
							return
						else
							for _, v in ipairs(t2.value12) do
								if selectedProteinItems[v.tool] then
									local v599 = t2.value20({ v.tool })

									if v599 then
										muscleEvent:FireServer(v.event, v599)
									end
								end
							end

							return
						end
					end
				end

				pcall(v594)
				task.wait(0.28)
			end
		end

		t2.value16("autoEatProtein")

		local s29 = "autoEatProtein"

		t2.value14.autoEatProtein = task.spawn(function()
			pcall(v592)
			t2.value14[s29] = nil
		end)

		local _ = t2.value14.autoEatProtein
	end

	local v602

	if t2.value10.SpinWheel == nil then
		v602 = false
	else
		v602 = t2.value10.SpinWheel
	end

	if v602 then
		t2.value13.autoSpinWheel = true

		local function v603()
			while true do
				local running = t2.value13.running

				if running then
					running = t2.value13.autoSpinWheel
				end

				if not running then
					return
				end

				local function v605()
					local fortuneWheelMenuGui = t2.value8:FindFirstChild("fortuneWheelMenuGui")

					if not fortuneWheelMenuGui then
						return
					end

					local spinAmountLabel = fortuneWheelMenuGui:FindFirstChild("spinAmountLabel", true)

					if not (spinAmountLabel and spinAmountLabel.Text) then
						return
					end

					local Text = spinAmountLabel.Text
					local v609 = tostring(Text)
					local huge

					if v609:lower():find("inf", 1, true) or v609:find("∞") then
						huge = math.huge
					else
						local match = string.match

						huge = tonumber(match(v609, "%d+")) or 0
					end

					if not (huge >= 1) then
						return
					end

					t2.value2.rEvents.openFortuneWheelRemote:InvokeServer("openFortuneWheel", t2.value2.shared.catalogs.fortuneWheelChances["Fortune Wheel"])
				end

				pcall(v605)
				task.wait(1.5)
			end
		end

		t2.value16("fortuneWheel")

		local s30 = "fortuneWheel"

		t2.value14.fortuneWheel = task.spawn(function()
			pcall(v603)
			t2.value14[s30] = nil
		end)

		local _ = t2.value14.fortuneWheel
	end

	local v614

	if t2.value10.AutoClaimGifts == nil then
		v614 = false
	else
		v614 = t2.value10.AutoClaimGifts
	end

	if v614 then
		t2.value13.autoClaimGifts = true

		local function v615()
			while true do
				local running = t2.value13.running

				if running then
					running = t2.value13.autoClaimGifts
				end

				if not running then
					return
				end

				t2.value57()
				task.wait(2)
			end
		end

		t2.value16("claimGifts")

		local s31 = "claimGifts"

		t2.value14.claimGifts = task.spawn(function()
			pcall(v615)
			t2.value14[s31] = nil
		end)

		local _ = t2.value14.claimGifts
	end

	local v619

	if t2.value10.AutoBuyPets == nil then
		v619 = false
	else
		v619 = t2.value10.AutoBuyPets
	end

	if v619 then
		_G.AutoBuyPets = true
		task.spawn(function()
			while true do
				local AutoBuyPets = _G.AutoBuyPets

				if AutoBuyPets then
					AutoBuyPets = t2.value13.running
				end

				if not AutoBuyPets then
					return
				end

				local v621 = v365(t2.value77)
				local value662

				if v621 then
					value662 = t2.value66
				else
					value662 = v621
				end

				if value662 then
					local function v623()
						t2.value66:InvokeServer(v621)
					end

					pcall(v623)
				end

				task.wait(0.1)
			end
		end)
	end

	local v624

	if t2.value10.AutoBuyAuras == nil then
		v624 = false
	else
		v624 = t2.value10.AutoBuyAuras
	end

	if v624 then
		_G.AutoBuyAuras = true
		task.spawn(function()
			while true do
				local AutoBuyAuras = _G.AutoBuyAuras

				if AutoBuyAuras then
					AutoBuyAuras = t2.value13.running
				end

				if not AutoBuyAuras then
					return
				end

				local v626 = v365(t2.value78)
				local value662

				if v626 then
					value662 = t2.value66
				else
					value662 = v626
				end

				if value662 then
					pcall(function()
						t2.value66:InvokeServer(v626)
					end)
				end

				task.wait(0.15)
			end
		end)
	end

	local v628

	if t2.value10.AutoEvolvePets == nil then
		v628 = false
	else
		v628 = t2.value10.AutoEvolvePets
	end

	if v628 then
		_G.AutoEvolvePets = true
		task.spawn(function()
			while true do
				local AutoEvolvePets = _G.AutoEvolvePets

				if AutoEvolvePets then
					AutoEvolvePets = t2.value13.running
				end

				if not AutoEvolvePets then
					return
				end

				local v630 = t2.value72()
				local ipairs_ = ipairs
				local value79 = t2.value79

				for _, v in ipairs_(t2.value89(value79)) do
					local value67

					if v388(v630, v) >= 5 then
						value67 = t2.value67
					else
						value67 = false
					end

					if value67 then
						local function v636()
							t2.value67:FireServer("evolvePet", v)
						end

						pcall(v636)
					end
				end

				task.wait(0.5)
			end
		end)
	end

	local v637

	if t2.value10.AutoEvolveAuras == nil then
		v637 = false
	else
		v637 = t2.value10.AutoEvolveAuras
	end

	if v637 then
		_G.AutoEvolveAuras = true
		task.spawn(function()
			while true do
				local AutoEvolveAuras = _G.AutoEvolveAuras

				if AutoEvolveAuras then
					AutoEvolveAuras = t2.value13.running
				end

				if not AutoEvolveAuras then
					return
				end

				local v639 = t2.value73()
				local ipairs_ = ipairs
				local value80 = t2.value80

				for _, v in ipairs_(t2.value89(value80)) do
					local value69

					if v388(v639, v) >= 5 then
						value69 = t2.value69
					else
						value69 = false
					end

					if value69 then
						local function v645()
							t2.value69:FireServer("evolvePowerUp", v)
						end

						pcall(v645)
					end
				end

				task.wait(0.5)
			end
		end)
	end

	local v646

	if t2.value10.AutoSellPets == nil then
		v646 = false
	else
		v646 = t2.value10.AutoSellPets
	end

	if v646 then
		_G.AutoSellPets = true
		task.spawn(function()
			while true do
				local AutoSellPets = _G.AutoSellPets

				if AutoSellPets then
					AutoSellPets = t2.value13.running
				end

				if not AutoSellPets then
					return
				end

				local v648 = t2.value72()
				local v649 = t2.value89(t2.value81)

				if #v649 > 0 then
					local v650 = v402
					local value85 = t2.value85
					local v652 = v650(v648, v649, t2.value83, value85)

					if #v652 == 0 then
						v652 = v402(v648, v649, t2.value83, nil)
					end

					if #v652 >= 1 then
						t2.value91(v652[1])
					end
				end

				task.wait(0.4)
			end
		end)
	end

	local v653

	if t2.value10.AutoSellAuras == nil then
		v653 = false
	else
		v653 = t2.value10.AutoSellAuras
	end

	if v653 then
		_G.AutoSellAuras = true
		task.spawn(function()
			while true do
				local AutoSellAuras = _G.AutoSellAuras

				if AutoSellAuras then
					AutoSellAuras = t2.value13.running
				end

				if not AutoSellAuras then
					return
				end

				local v655 = t2.value73()
				local v656 = t2.value89(t2.value82)

				if #v656 > 0 then
					local v657 = v402
					local value86 = t2.value86
					local v659 = v657(v655, v656, t2.value84, value86)

					if #v659 == 0 then
						v659 = v402(v655, v656, t2.value84, nil)
					end

					if #v659 >= 1 then
						t2.value92(v659[1])
					end
				end

				task.wait(0.4)
			end
		end)
	end

	local v660

	if t2.value10.AutoUseCodes == nil then
		v660 = false
	else
		v660 = t2.value10.AutoUseCodes
	end

	if not v660 then
		return
	end

	t2.value13.autoUseCodes = true

	local function v661()
		local t18 = {
			"mightygems2500",
			"ultimate250",
			"spacegems50",
			"megalift50",
			"speedy50",
			"epicreward500",
			"MillionWarriors",
			"frostgems10",
			"Musclestorm50",
			"Skyagility50",
			"galaxycrystal50",
			"supermuscle100",
			"superpunch100",
			"launch250",
			"MLREVIVED",
			"INDUSTRIALGYM500",
			"BOSSSTRIKE",
			"BOSSGUARD"
		}
		local rEvents = t2.value2:FindFirstChild("rEvents")

		if rEvents then
			rEvents = t2.value2.rEvents:FindFirstChild("codeRemote")
		end

		if not rEvents then
			return
		end

		for _, v in ipairs(t18) do
			if not (t2.value13.running and t2.value13.autoUseCodes) then
				t2.value13.autoUseCodes = false
				t2.value11("AutoUseCodes", false)

				return
			end

			pcall(function()
				rEvents:InvokeServer(v)
			end)
			task.wait(0.8)
		end

		t2.value13.autoUseCodes = false
		t2.value11("AutoUseCodes", false)
	end

	t2.value16("autoUseCodes")

	local s32 = "autoUseCodes"

	t2.value14.autoUseCodes = task.spawn(function()
		pcall(v661)
		t2.value14[s32] = nil
	end)

	local _ = t2.value14.autoUseCodes
end)()
task.defer(function()
	local function v668()
		local Character = t2.value7.Character
		local Backpack = t2.value7:FindFirstChild("Backpack")
		local Punch = Character and Backpack and Character:FindFirstChild("Punch")

		if not Punch then
			return
		end

		Punch.Parent = Backpack
	end

	pcall(v668)
end)
task.wait(0.08)
pcall(function()
	t2.value58:SelectTab(1)
	t2.value58:Open()
end)
