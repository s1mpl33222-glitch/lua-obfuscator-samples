local persistentEnvironment = getgenv()
local previousSession = _G.__MangoHubBloxFruitsSession or persistentEnvironment.__MangoHubBloxFruitsSession

if previousSession and previousSession.cleanup then
	pcall(previousSession.cleanup)
end

local nativeTask = task
local session = {
	active = true,
	threads = {},
	connections = {},
	window = nil
}

persistentEnvironment.__MangoHubBloxFruitsSession = session
_G.__MangoHubBloxFruitsSession = session

local task = setmetatable({}, { __index = nativeTask })

local function trackThread(thread)
	table.insert(session.threads, thread)
	return thread
end

function task.spawn(callback, ...)
	local arguments = table.pack(...)
	return trackThread(nativeTask.spawn(function()
		if session.active then
			callback(table.unpack(arguments, 1, arguments.n))
		end
	end))
end

function task.defer(callback, ...)
	local arguments = table.pack(...)
	return trackThread(nativeTask.defer(function()
		if session.active then
			callback(table.unpack(arguments, 1, arguments.n))
		end
	end))
end

function task.delay(duration, callback, ...)
	local arguments = table.pack(...)
	return trackThread(nativeTask.delay(duration, function()
		if session.active then
			callback(table.unpack(arguments, 1, arguments.n))
		end
	end))
end

local function spawn(callback, ...)
	return task.spawn(callback, ...)
end

local function connectScoped(signal, callback)
	local connection = signal:Connect(function(...)
		if session.active then
			callback(...)
		end
	end)
	table.insert(session.connections, connection)
	return connection
end

local startupState = {
	initializing = true,
	registrationComplete = false,
	callbackQueue = {}
}

local function restorePlayerMovement()
	local player = game:GetService("Players").LocalPlayer
	local character = player and player.Character

	if not character then
		return
	end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local rootPart = character:FindFirstChild("HumanoidRootPart")

	if humanoid then
		humanoid.PlatformStand = false
		humanoid.AutoRotate = true
	end

	if rootPart then
		local bodyClip = rootPart:FindFirstChild("BodyClip")
		if bodyClip then
			bodyClip:Destroy()
		end
	end

	for _, bodyPart in ipairs(character:GetDescendants()) do
		if bodyPart:IsA("BasePart") then
			bodyPart.Massless = false
		end
	end
end

function session.cleanup()
	if not session.active then
		return
	end

	session.active = false

	for _, connection in ipairs(session.connections) do
		pcall(function()
			connection:Disconnect()
		end)
	end
	table.clear(session.connections)

	for _, thread in ipairs(session.threads) do
		pcall(nativeTask.cancel, thread)
	end
	table.clear(session.threads)

	if session.window and session.window.Destroy then
		pcall(function()
			session.window:Destroy()
		end)
	end

	restorePlayerMovement()
end

restorePlayerMovement()

local function geniter(f, s, c)
	if type(f) ~= "function" then
		local mt = getmetatable(f)

		if type(mt) == "table" and mt.__iter then
			f, s, c = mt.__iter(f)
		elseif type(f) == "table" then
			f, s, c = next, f, nil
		end
	end

	return function()
		local r = table.pack(f(s, c))

		if r[1] == nil then
			return false
		end

		c = r[1]

		return true, table.unpack(r, 1, r.n)
	end
end

ply = game.Players
plr = ply.LocalPlayer
Root = plr.Character.HumanoidRootPart
replicated = game:GetService("ReplicatedStorage")
Lv = game.Players.LocalPlayer.Data.Level.Value
TeleportService = game:GetService("TeleportService")
TW = game:GetService("TweenService")
Lighting = game:GetService("Lighting")
Enemies = workspace.Enemies
vim1 = game:GetService("VirtualInputManager")
vim2 = game:GetService("VirtualUser")
TeamSelf = plr.Team
RunSer = game:GetService("RunService")
Stats = game:GetService("Stats")
Energy = plr.Character.Energy.Value
BringConnections = {}
BossList = {}
MaterialList = {}
NPCList = {}
shouldTween = false
getgenv().OnFarm = false
getgenv().AutoMaterial = false
NextIs = false
senth = false
senth2 = false
SoulGuitar = false
KenTest = true
debug = false
Brazier1 = false
Brazier2 = false
Brazier3 = false
Sec = 0.1
ClickState = 0
Num_self = 25

do
	local Loading

	repeat
		Loading = plr.PlayerGui:WaitForChild("Main"):WaitForChild("Loading") and game:IsLoaded()
		wait()
	until Loading
end

World1 = game.PlaceId == 2753915549 or game.PlaceId == 85211729168715
World2 = game.PlaceId == 4442272183 or game.PlaceId == 79091703265657
World3 = game.PlaceId == 7449423635 or game.PlaceId == 100117331123089

do
	Marines = function()
		replicated.Remotes.CommF_:InvokeServer("SetTeam", "Marines")
	end
end

do
	Pirates = function()
		replicated.Remotes.CommF_:InvokeServer("SetTeam", "Pirates")
	end
end

if World1 then
	BossList = {
		"The Gorilla King",
		"Bobby",
		"The Saw",
		"Yeti",
		"Mob Leader",
		"Vice Admiral",
		"Saber Expert",
		"Warden",
		"Chief Warden",
		"Swan",
		"Magma Admiral",
		"Fishman Lord",
		"Wysper",
		"Thunder God",
		"Cyborg",
		"Ice Admiral",
		"Greybeard"
	}
elseif World2 then
	BossList = {
		"Diamond",
		"Jeremy",
		"Orbitus",
		"Don Swan",
		"Smoke Admiral",
		"Awakened Ice Admiral",
		"Tide Keeper",
		"Darkbeard",
		"Cursed Captain",
		"Order"
	}
elseif World3 then
	BossList = {
		"Stone",
		"Hydra Leader",
		"Kilo Admiral",
		"Captain Elephant",
		"Beautiful Pirate",
		"Cake Queen",
		"Dough King",
		"Longma",
		"Soul Reaper",
		"rip_indra True Form",
		"Tyrant of the Skies"
	}
end

if World1 then
	MaterialList = {
		"Leather + Scrap Metal",
		"Angel Wings",
		"Magma Ore",
		"Fish Tail"
	}
elseif World2 then
	MaterialList = {
		"Leather + Scrap Metal",
		"Radioactive Material",
		"Ectoplasm",
		"Mystic Droplet",
		"Magma Ore",
		"Vampire Fang"
	}
elseif World3 then
	MaterialList = {
		"Scrap Metal",
		"Demonic Wisp",
		"Conjured Cocoa",
		"Dragon Scale",
		"Gunpowder",
		"Fish Tail",
		"Mini Tusk"
	}
end

local piratesEntries = {
	"Snow Lurker",
	"Arctic Warrior",
	"Hidden Key",
	"Awakened Ice Admiral"
}
local piratesEntriesState = {
	"Part",
	"SpawnLocation",
	"Terrain",
	"WedgePart",
	"MeshPart"
}
local piratesEntriesData = {
	"Swan Pirate",
	"Jeremy"
}
local locationDataNext = {
	"Fajita",
	"Jeremy",
	"Diamond"
}
local locationDataPrimary = { "Cookie Crafter" }
local locationDataNearby = { "Reborn Skeleton" }
local locationDataVisible = {
	["Pirate Millionaire"] = CFrame.new(-712.8272705078125, 98.577049255371094, 5711.9541015625),
	["Pistol Billionaire"] = CFrame.new(-723.43316650390625, 147.42906188964844, 5931.9931640625),
	["Dragon Crew Warrior"] = CFrame.new(7021.50439453125, 55.762702941894531, -730.12908935546875),
	["Dragon Crew Archer"] = CFrame.new(6625, 378, 244),
	["Female Islander"] = CFrame.new(4692.7939453125, 797.9766845703125, 858.8480224609375),
	["Venomous Assailant"] = CFrame.new(4902, 670, 39),
	["Marine Commodore"] = CFrame.new(2401, 123, -7589),
	["Marine Rear Admiral"] = CFrame.new(3588, 229, -7085),
	["Fishman Raider"] = CFrame.new(-10941, 332, -8760),
	["Fishman Captain"] = CFrame.new(-11035, 332, -9087),
	["Forest Pirate"] = CFrame.new(-13446, 413, -7760),
	["Mythological Pirate"] = CFrame.new(-13510, 584, -6987),
	["Jungle Pirate"] = CFrame.new(-11778, 426, -10592),
	["Musketeer Pirate"] = CFrame.new(-13282, 496, -9565),
	["Reborn Skeleton"] = CFrame.new(-8764, 142, 5963),
	["Living Zombie"] = CFrame.new(-10227, 421, 6161),
	["Demonic Soul"] = CFrame.new(-9579, 6, 6194),
	["Posessed Mummy"] = CFrame.new(-9579, 6, 6194),
	["Peanut Scout"] = CFrame.new(-1993, 187, -10103),
	["Peanut President"] = CFrame.new(-2215, 159, -10474),
	["Ice Cream Chef"] = CFrame.new(-877, 118, -11032),
	["Ice Cream Commander"] = CFrame.new(-877, 118, -11032),
	["Cookie Crafter"] = CFrame.new(-2021, 38, -12028),
	["Cake Guard"] = CFrame.new(-2024, 38, -12026),
	["Baking Staff"] = CFrame.new(-1932, 38, -12848),
	["Head Baker"] = CFrame.new(-1932, 38, -12848),
	["Cocoa Warrior"] = CFrame.new(95, 73, -12309),
	["Chocolate Bar Battler"] = CFrame.new(647, 42, -12401),
	["Sweet Thief"] = CFrame.new(116, 36, -12478),
	["Candy Rebel"] = CFrame.new(47, 61, -12889),
	Ghost = CFrame.new(5251, 5, 1111)
}
local locationDataAvailable = {
	RFJobsRemoteFunction = replicated.Modules.Net["RF/JobsRemoteFunction"],
	RFCraft = replicated:WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/Craft")
}

EquipWeapon = function(isEnabled)
	if not isEnabled then
		return
	end

	if plr.Backpack:FindFirstChild(isEnabled) then
		plr.Character.Humanoid:EquipTool(plr.Backpack:FindFirstChild(isEnabled))
	end
end
weaponSc = function(weaponscInput)
	for _, child in pairs(plr.Backpack:GetChildren()) do
		if child:IsA("Tool") and child.ToolTip == weaponscInput then
			EquipWeapon(child.Name)
		end
	end
end

local playerCollectionLatest = {}

playerCollectionLatest.__index = playerCollectionLatest

do
	playerCollectionLatest.Alive = function(isEnabledPending)
		if not isEnabledPending then
			return
		end

		local Humanoid = isEnabledPending:FindFirstChild("Humanoid")

		return Humanoid and Humanoid.Health > 0
	end
end

playerCollectionLatest.Pos = function(posInput, posInputState)
	return (Root.Position - mode.Position).Magnitude <= posInputState
end
playerCollectionLatest.Dist = function(distInputState, distInput)
	return (Root.Position - distInputState:FindFirstChild("HumanoidRootPart").Position).Magnitude <= distInput
end
playerCollectionLatest.DistH = function(disthInput, disthInputState)
	return (Root.Position - disthInput:FindFirstChild("HumanoidRootPart").Position).Magnitude > disthInputState
end

do
	playerCollectionLatest.Kill = function(isEnabledCurrent, targetEnemy)
		if isEnabledCurrent and targetEnemy then
			if not isEnabledCurrent:GetAttribute("Locked") then
				isEnabledCurrent:SetAttribute("Locked", isEnabledCurrent.HumanoidRootPart.CFrame)
			end

			PosMon = isEnabledCurrent:GetAttribute("Locked").Position
			BringEnemy()
			EquipWeapon(_G.SelectWeapon)

			local Tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")

			if (Tool and Tool:FindFirstChild("ToolTip") and Tool.ToolTip or "") == "Blox Fruit" then
				_tp(isEnabledCurrent.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0) * CFrame.Angles(0, math.rad(90), 0))
			else
				_tp(isEnabledCurrent.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0) * CFrame.Angles(0, math.rad(180), 0))
			end

			if RandomCFrame then
				wait(0.5)
				_tp(isEnabledCurrent.HumanoidRootPart.CFrame * CFrame.new(0, 30, 25))
				wait(0.5)
				_tp(isEnabledCurrent.HumanoidRootPart.CFrame * CFrame.new(25, 30, 0))
				wait(0.5)
				_tp(isEnabledCurrent.HumanoidRootPart.CFrame * CFrame.new(-25, 30, 0))
				wait(0.5)
				_tp(isEnabledCurrent.HumanoidRootPart.CFrame * CFrame.new(0, 30, 25))
				wait(0.5)
				_tp(isEnabledCurrent.HumanoidRootPart.CFrame * CFrame.new(-25, 30, 0))
			end
		end
	end
end

playerCollectionLatest.Kill2 = function(isEnabledCached, targetEnemyResponse)
	if isEnabledCached and targetEnemyResponse then
		if not isEnabledCached:GetAttribute("Locked") then
			isEnabledCached:SetAttribute("Locked", isEnabledCached.HumanoidRootPart.CFrame)
		end

		PosMon = isEnabledCached:GetAttribute("Locked").Position
		BringEnemy()
		EquipWeapon(_G.SelectWeapon)

		local Tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
		local ToolTip = Tool and Tool:FindFirstChild("ToolTip") and Tool.ToolTip

		if (ToolTip or "") == "Blox Fruit" then
			_tp(isEnabledCached.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0) * CFrame.Angles(0, math.rad(90), 0))
		else
			_tp(isEnabledCached.HumanoidRootPart.CFrame * CFrame.new(0, 10, 8) * CFrame.Angles(0, math.rad(180), 0))
		end

		if RandomCFrame then
			wait(0.1)
			_tp(isEnabledCached.HumanoidRootPart.CFrame * CFrame.new(0, 30, 25))
			wait(0.1)
			_tp(isEnabledCached.HumanoidRootPart.CFrame * CFrame.new(25, 30, 0))
			wait(0.1)
			_tp(isEnabledCached.HumanoidRootPart.CFrame * CFrame.new(-25, 30, 0))
			wait(0.1)
			_tp(isEnabledCached.HumanoidRootPart.CFrame * CFrame.new(0, 30, 25))
			wait(0.1)
			_tp(isEnabledCached.HumanoidRootPart.CFrame * CFrame.new(-25, 30, 0))
		end
	end
end

do
	playerCollectionLatest.KillSea = function(isEnabledTarget, targetEnemyState)
		if isEnabledTarget and targetEnemyState then
			if not isEnabledTarget:GetAttribute("Locked") then
				isEnabledTarget:SetAttribute("Locked", isEnabledTarget.HumanoidRootPart.CFrame)
			end

			PosMon = isEnabledTarget:GetAttribute("Locked").Position
			BringEnemy()
			EquipWeapon(_G.SelectWeapon)

			local Tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")

			if (Tool and Tool:FindFirstChild("ToolTip") and Tool.ToolTip or "") == "Blox Fruit" then
				_tp(isEnabledTarget.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0) * CFrame.Angles(0, math.rad(90), 0))
			else
				notween(isEnabledTarget.HumanoidRootPart.CFrame * CFrame.new(0, 50, 8))
				wait(0.85)
				notween(isEnabledTarget.HumanoidRootPart.CFrame * CFrame.new(0, 400, 0))
				wait(1)
			end
		end
	end
end

do
	playerCollectionLatest.Sword = function(isEnabledPrevious, swordInput)
		if isEnabledPrevious then
			if swordInput then
				if not isEnabledPrevious:GetAttribute("Locked") then
					isEnabledPrevious:SetAttribute("Locked", isEnabledPrevious.HumanoidRootPart.CFrame)
				end

				PosMon = isEnabledPrevious:GetAttribute("Locked").Position
				BringEnemy()
				weaponSc("Sword")
				_tp(isEnabledPrevious.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))

				if RandomCFrame then
					wait(0.1)
					_tp(isEnabledPrevious.HumanoidRootPart.CFrame * CFrame.new(0, 30, 25))
					wait(0.1)
					_tp(isEnabledPrevious.HumanoidRootPart.CFrame * CFrame.new(25, 30, 0))
					wait(0.1)
					_tp(isEnabledPrevious.HumanoidRootPart.CFrame * CFrame.new(-25, 30, 0))
					wait(0.1)
					_tp(isEnabledPrevious.HumanoidRootPart.CFrame * CFrame.new(0, 30, 25))
					wait(0.1)
					_tp(isEnabledPrevious.HumanoidRootPart.CFrame * CFrame.new(-25, 30, 0))
				end
			end
		end
	end
end

playerCollectionLatest.Mas = function(isEnabledNext, masInput)
	if isEnabledNext and masInput then
		if not isEnabledNext:GetAttribute("Locked") then
			isEnabledNext:SetAttribute("Locked", isEnabledNext.HumanoidRootPart.CFrame)
		end

		PosMon = isEnabledNext:GetAttribute("Locked").Position
		BringEnemy()

		if isEnabledNext.Humanoid.Health <= HealthM then
			_tp(isEnabledNext.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0))

			local SelectedMasterySkills = _G.SelectedMasterySkills

			if type(SelectedMasterySkills) ~= "table" then
				SelectedMasterySkills = {
					"Z",
					"X",
					"C",
					"V",
					"F"
				}
			end

			for k, SelectedMasterySkill in pairs(SelectedMasterySkills) do
				if type(k) == "number" then
					Useskills("Blox Fruit", SelectedMasterySkill)
				elseif type(k) == "string" and SelectedMasterySkill == true then
					Useskills("Blox Fruit", k)
				end
			end
		else
			weaponSc("Melee")
			_tp(isEnabledNext.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
		end
	end
end

do
	playerCollectionLatest.Masgun = function(isEnabledPrimary, masgunInput)
		if isEnabledPrimary and masgunInput then
			if not isEnabledPrimary:GetAttribute("Locked") then
				isEnabledPrimary:SetAttribute("Locked", isEnabledPrimary.HumanoidRootPart.CFrame)
			end

			PosMon = isEnabledPrimary:GetAttribute("Locked").Position
			BringEnemy()

			if isEnabledPrimary.Humanoid.Health <= HealthM then
				_tp(isEnabledPrimary.HumanoidRootPart.CFrame * CFrame.new(0, 35, 8))

				local SelectedMasterySkills = _G.SelectedMasterySkills

				if type(SelectedMasterySkills) ~= "table" then
					SelectedMasterySkills = {
						"Z",
						"X",
						"C",
						"V",
						"F"
					}
				end

				for k, SelectedMasterySkill in pairs(SelectedMasterySkills) do
					if type(k) == "number" then
						Useskills("Gun", SelectedMasterySkill)
					elseif type(k) == "string" and SelectedMasterySkill == true then
						Useskills("Gun", k)
					end
				end
			else
				weaponSc("Melee")
				_tp(isEnabledPrimary.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
			end
		end
	end
end

statsSetings = function(statssetingsInput, statssetingsInputState)
	if statssetingsInput == "Melee" then
		if plr.Data.Points.Value ~= 0 then
			replicated.Remotes.CommF_:InvokeServer("AddPoint", "Melee", statssetingsInputState)
		end
	elseif statssetingsInput == "Defense" then
		if plr.Data.Points.Value ~= 0 then
			replicated.Remotes.CommF_:InvokeServer("AddPoint", "Defense", statssetingsInputState)
		end
	elseif statssetingsInput == "Sword" then
		if plr.Data.Points.Value ~= 0 then
			replicated.Remotes.CommF_:InvokeServer("AddPoint", "Sword", statssetingsInputState)
		end
	elseif statssetingsInput == "Gun" then
		if plr.Data.Points.Value ~= 0 then
			replicated.Remotes.CommF_:InvokeServer("AddPoint", "Gun", statssetingsInputState)
		end
	elseif statssetingsInput == "Devil" and plr.Data.Points.Value ~= 0 then
		replicated.Remotes.CommF_:InvokeServer("AddPoint", "Demon Fruit", statssetingsInputState)
	end
end
BringEnemy = function(isEnabledSecondary)
	if not _B then
		return
	end

	if not isEnabledSecondary then
		local HumanoidRootPart = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")

		if not HumanoidRootPart then
			return
		end

		local huge = math.huge

		for _, child in ipairs(workspace.Enemies:GetChildren()) do
			local Humanoid = child:FindFirstChildOfClass("Humanoid")
			local HumanoidRootPart2 = child:FindFirstChild("HumanoidRootPart")

			if Humanoid and HumanoidRootPart2 and Humanoid.Health > 0 then
				local Magnitude = (HumanoidRootPart2.Position - HumanoidRootPart.Position).Magnitude

				if Magnitude < huge then
					huge = Magnitude
					isEnabledSecondary = child
				end
			end
		end

		if not isEnabledSecondary then
			return
		end
	end

	local isBringenemyReady = false

	local function resultmatchedResult(valueArgumentActive)
		local Humanoid = valueArgumentActive:FindFirstChildOfClass("Humanoid")
		local HumanoidRootPart = valueArgumentActive:FindFirstChild("HumanoidRootPart")

		return Humanoid and HumanoidRootPart and Humanoid.Health > 0, HumanoidRootPart, Humanoid
	end
	local function resultcreatedResult(isEnabledTemporary)
		if isnetworkowner then
			return isnetworkowner(isEnabledTemporary)
		end

		return isEnabledTemporary.ReceiveAge == 0 and not isEnabledTemporary.Anchored and isEnabledTemporary.Velocity.Magnitude > 0
	end

	pcall(function()
		if sethiddenproperty then
			sethiddenproperty(plr, "SimulationRadius", math.huge)
		end

		local Position = isEnabledSecondary.HumanoidRootPart.Position

		for _, child in ipairs(workspace.Enemies:GetChildren()) do
			if child ~= isEnabledSecondary then
				local resultcreatedMovementData, resultcreatedMovementDataState, resultcreatedMovementDataData = resultmatchedResult(child)

				if resultcreatedMovementData and child.Name == isEnabledSecondary.Name then
					local Magnitude = (resultcreatedMovementDataState.Position - Position).Magnitude

					if Magnitude <= 3000 then
						if not resultcreatedMovementDataState:FindFirstChild("BodyVelocity") then
							local BodyVelocity = Instance.new("BodyVelocity")

							BodyVelocity.Name = "BodyVelocity"
							BodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
							BodyVelocity.Velocity = Vector3.zero
							BodyVelocity.Parent = resultcreatedMovementDataState
						end

						if Magnitude <= 10 then
							isBringenemyReady = true
						end

						if not isBringenemyReady and resultcreatedResult(resultcreatedMovementDataState) then
							resultcreatedMovementDataState.CFrame = CFrame.new(Position)
						end

						resultcreatedMovementDataState.CanCollide = false
						resultcreatedMovementDataData.WalkSpeed = 0
						resultcreatedMovementDataData.JumpPower = 0
					end
				end
			end
		end

		if isEnabledSecondary and isEnabledSecondary:FindFirstChild("HumanoidRootPart") then
			isEnabledSecondary.HumanoidRootPart.CanCollide = false
			isEnabledSecondary.Humanoid.WalkSpeed = 0
			isEnabledSecondary.Humanoid.JumpPower = 0
		end
	end)
end

do
	local function playervalueaiPlayerDataState(valueArgumentTarget, valueArgumentPrevious)
		local LocalPlayer = game.Players.LocalPlayer
		local Name
		local childInstancesE, childInstancesF, childInstancesG = pairs(LocalPlayer.Character:GetChildren())
		local playervalueaiPlayerDataData = geniter(childInstancesE, childInstancesF, childInstancesG)

		while true do
			local playervalueaiCallResults = table.pack(playervalueaiPlayerDataData())

			if not playervalueaiCallResults[1] then
				break
			end

			local playervalueaiPlayerDataEntry = playervalueaiCallResults[3]

			if playervalueaiPlayerDataEntry:IsA("Tool") and playervalueaiPlayerDataEntry.ToolTip == valueArgumentTarget then
				Name = playervalueaiPlayerDataEntry.Name

				break
			end
		end

		if not Name then
			local childInstancesH, childInstancesI, childInstancesJ = pairs(LocalPlayer.Backpack:GetChildren())

			for _, playervalueaiPlayerData in childInstancesH, childInstancesI, childInstancesJ do
				if playervalueaiPlayerData:IsA("Tool") then
					if playervalueaiPlayerData.ToolTip == valueArgumentTarget then
						Name = playervalueaiPlayerData.Name

						break
					end
				end
			end
		end

		if Name then
			if LocalPlayer.PlayerGui:FindFirstChild("Main") then
				if LocalPlayer.PlayerGui.Main:FindFirstChild("Skills") then
					local locatedInstanceEntry = LocalPlayer.PlayerGui.Main.Skills:FindFirstChild(Name)

					if locatedInstanceEntry then
						local locatedInstanceItem = locatedInstanceEntry:FindFirstChild(valueArgumentPrevious)

						if not locatedInstanceItem then
							return false
						end

						local Title = locatedInstanceItem:FindFirstChild("Title")

						if Title and Title:IsA("TextLabel") and Title.TextColor3.R < 0.5 then
							return false
						end

						local Cooldown = locatedInstanceItem:FindFirstChild("Cooldown")

						if Cooldown and (Cooldown.Size.X.Scale > 0 or Cooldown.AbsoluteSize.X > 0) then
							return false
						end

						return true
					end
				end
			end
		end

		return true
	end

	Useskills = function(targetEnemyEntry, targetEnemyPayload)
		if targetEnemyEntry == "Melee" then
			weaponSc("Melee")

			if not playervalueaiPlayerDataState(targetEnemyEntry, targetEnemyPayload) then
				return
			end

			if targetEnemyPayload == "Z" then
				vim1:SendKeyEvent(true, "Z", false, game)
				vim1:SendKeyEvent(false, "Z", false, game)
			elseif targetEnemyPayload == "X" then
				vim1:SendKeyEvent(true, "X", false, game)
				vim1:SendKeyEvent(false, "X", false, game)
			elseif targetEnemyPayload == "C" then
				vim1:SendKeyEvent(true, "C", false, game)
				vim1:SendKeyEvent(false, "C", false, game)
			elseif targetEnemyPayload == "V" then
				vim1:SendKeyEvent(true, "V", false, game)
				vim1:SendKeyEvent(false, "V", false, game)
			elseif targetEnemyPayload == "F" then
				vim1:SendKeyEvent(true, "F", false, game)
				vim1:SendKeyEvent(false, "F", false, game)
			elseif targetEnemyPayload == "Y" then
				vim1:SendKeyEvent(true, "Y", false, game)
				vim1:SendKeyEvent(false, "Y", false, game)
			end
		elseif targetEnemyEntry == "Sword" then
			weaponSc("Sword")

			if not playervalueaiPlayerDataState(targetEnemyEntry, targetEnemyPayload) then
				return
			end

			if targetEnemyPayload == "Z" then
				vim1:SendKeyEvent(true, "Z", false, game)
				vim1:SendKeyEvent(false, "Z", false, game)
			elseif targetEnemyPayload == "X" then
				vim1:SendKeyEvent(true, "X", false, game)
				vim1:SendKeyEvent(false, "X", false, game)
			elseif targetEnemyPayload == "C" then
				vim1:SendKeyEvent(true, "C", false, game)
				vim1:SendKeyEvent(false, "C", false, game)
			elseif targetEnemyPayload == "V" then
				vim1:SendKeyEvent(true, "V", false, game)
				vim1:SendKeyEvent(false, "V", false, game)
			elseif targetEnemyPayload == "F" then
				vim1:SendKeyEvent(true, "F", false, game)
				vim1:SendKeyEvent(false, "F", false, game)
			elseif targetEnemyPayload == "Y" then
				vim1:SendKeyEvent(true, "Y", false, game)
				vim1:SendKeyEvent(false, "Y", false, game)
			end
		elseif targetEnemyEntry == "Blox Fruit" then
			weaponSc("Blox Fruit")

			if not playervalueaiPlayerDataState(targetEnemyEntry, targetEnemyPayload) then
				return
			end

			if targetEnemyPayload == "Z" then
				vim1:SendKeyEvent(true, "Z", false, game)
				vim1:SendKeyEvent(false, "Z", false, game)
			elseif targetEnemyPayload == "X" then
				vim1:SendKeyEvent(true, "X", false, game)
				vim1:SendKeyEvent(false, "X", false, game)
			elseif targetEnemyPayload == "C" then
				vim1:SendKeyEvent(true, "C", false, game)
				vim1:SendKeyEvent(false, "C", false, game)
			elseif targetEnemyPayload == "V" then
				vim1:SendKeyEvent(true, "V", false, game)
				vim1:SendKeyEvent(false, "V", false, game)
			elseif targetEnemyPayload == "F" then
				vim1:SendKeyEvent(true, "F", false, game)
				vim1:SendKeyEvent(false, "F", false, game)
			elseif targetEnemyPayload == "Y" then
				vim1:SendKeyEvent(true, "Y", false, game)
				vim1:SendKeyEvent(false, "Y", false, game)
			end
		elseif targetEnemyEntry == "Gun" then
			weaponSc("Gun")

			if not playervalueaiPlayerDataState(targetEnemyEntry, targetEnemyPayload) then
				return
			end

			if targetEnemyPayload == "Z" then
				vim1:SendKeyEvent(true, "Z", false, game)
				vim1:SendKeyEvent(false, "Z", false, game)
			elseif targetEnemyPayload == "X" then
				vim1:SendKeyEvent(true, "X", false, game)
				vim1:SendKeyEvent(false, "X", false, game)
			elseif targetEnemyPayload == "C" then
				vim1:SendKeyEvent(true, "C", false, game)
				vim1:SendKeyEvent(false, "C", false, game)
			elseif targetEnemyPayload == "V" then
				vim1:SendKeyEvent(true, "V", false, game)
				vim1:SendKeyEvent(false, "V", false, game)
			elseif targetEnemyPayload == "F" then
				vim1:SendKeyEvent(true, "F", false, game)
				vim1:SendKeyEvent(false, "F", false, game)
			elseif targetEnemyPayload == "Y" then
				vim1:SendKeyEvent(true, "Y", false, game)
				vim1:SendKeyEvent(false, "Y", false, game)
			end
		end

		if targetEnemyEntry == "nil" and targetEnemyPayload == "Y" then
			vim1:SendKeyEvent(true, "Y", false, game)
			vim1:SendKeyEvent(false, "Y", false, game)
		end
	end
end

do
	local useskillsResult = getrawmetatable(game)
	local __namecall = useskillsResult.__namecall

	setreadonly(useskillsResult, false)
	useskillsResult.__namecall = newcclosure(function(...)
		local useskillsPlayerData = getnamecallmethod()
		local playerCollection = { ... }

		if tostring(useskillsPlayerData) == "FireServer" and tostring(playerCollection[1]) == "RemoteEvent" and tostring(playerCollection[2]) ~= "true" and tostring(playerCollection[2]) ~= "false" then
			if _G.FarmMastery_G and not SoulGuitar or _G.FarmMastery_Dev or _G.FarmBlazeEM or _G.Prehis_Skills or _G.SeaBeast1 or _G.FishBoat or _G.PGB or _G.Leviathan1 or _G.Complete_Trials or _G.AimMethod and ABmethod == "Aim Player" or _G.AimMethod and ABmethod == "Nearest Aim" then
				playerCollection[2] = MousePos

				return __namecall(unpack(playerCollection))
			end
		end

		return __namecall(...)
	end)
end

GetConnectionEnemies = function(getconnectionenemiesInput)
	for _, child in pairs(replicated:GetChildren()) do
		if child:IsA("Model") then
			if (typeof(getconnectionenemiesInput) == "table" and table.find(getconnectionenemiesInput, child.Name) or child.Name == getconnectionenemiesInput) and child:FindFirstChild("Humanoid") and child.Humanoid.Health > 0 then
				return child
			end
		end
	end

	local children, childInstancesN = game.Workspace.Enemies:GetChildren()

	for _, playervalueaiPlayerData in next, children, childInstancesN do
		if playervalueaiPlayerData:IsA("Model") then
			if (typeof(getconnectionenemiesInput) == "table" and table.find(getconnectionenemiesInput, playervalueaiPlayerData.Name) or playervalueaiPlayerData.Name == getconnectionenemiesInput) and playervalueaiPlayerData:FindFirstChild("Humanoid") and playervalueaiPlayerData.Humanoid.Health > 0 then
				return playervalueaiPlayerData
			end
		end
	end
end
LowCpu = function()
	local Terrain = game.Workspace.Terrain

	Terrain.WaterWaveSize = 0
	Terrain.WaterWaveSpeed = 0
	Terrain.WaterReflectance = 0
	Terrain.WaterTransparency = 0
	game.Lighting.GlobalShadows = false
	game.Lighting.FogEnd = 9e9
	game.Lighting.Brightness = 0
	settings().Rendering.QualityLevel = "Level01"

	for _, descendant in pairs(game:GetDescendants()) do
		if not (descendant:IsA("Part") or descendant:IsA("Union") or descendant:IsA("CornerWedgePart")) then
			if not descendant:IsA("TrussPart") then
				if not descendant:IsA("Decal") then
					if not descendant:IsA("Texture") then
						if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") then
							descendant.Lifetime = NumberRange.new(0)
						elseif descendant:IsA("Explosion") then
							descendant.BlastPressure = 1
							descendant.BlastRadius = 1
						elseif descendant:IsA("Fire") or descendant:IsA("SpotLight") or descendant:IsA("Smoke") or descendant:IsA("Sparkles") then
							descendant.Enabled = false
						elseif descendant:IsA("MeshPart") then
							descendant.Material = "Plastic"
							descendant.Reflectance = 0
							descendant.TextureID = 10385902758728956
						end

						continue
					end
				end

				descendant.Transparency = 1

				continue
			end
		end

		descendant.Material = "Plastic"
		descendant.Reflectance = 0
	end

	for _, child in pairs(game.Lighting:GetChildren()) do
		if child:IsA("BlurEffect") or child:IsA("SunRaysEffect") or child:IsA("ColorCorrectionEffect") or child:IsA("BloomEffect") or child:IsA("DepthOfFieldEffect") then
			child.Enabled = false
		end
	end
end
CheckF = function()
	if not (GetBP("Dragon-Dragon") or GetBP("Gas-Gas")) then
		if not (GetBP("Yeti-Yeti") or GetBP("Kitsune-Kitsune") or not not GetBP("T-Rex-T-Rex")) then
			return
		end
	end

	return true
end
CheckBoat = function()
	local childInstancesO, childInstancesP, childInstancesQ = pairs(workspace.Boats:GetChildren())
	local checkboatResult = geniter(childInstancesO, childInstancesP, childInstancesQ)
	local checkboatCallResultsState = table.pack(checkboatResult())

	if checkboatCallResultsState[1] then
		local checkboatResultState = checkboatCallResultsState[3]

		while tostring(checkboatResultState.Owner.Value) ~= tostring(plr.Name) do
			local checkboatCallResults = table.pack(checkboatResult())

			if not checkboatCallResults[1] then
				return false
			end

			checkboatResultState = checkboatCallResults[3]
		end

		return checkboatResultState
	end

	return false
end
CheckEnemiesBoat = function()
	for _, child in pairs(workspace.Enemies:GetChildren()) do
		if child.Name == "FishBoat" then
			if child:FindFirstChild("Health").Value > 0 then
				return true
			end
		end
	end

	return false
end
CheckPirateGrandBrigade = function()
	for _, child in pairs(workspace.Enemies:GetChildren()) do
		if (child.Name == "PirateGrandBrigade" or child.Name == "PirateBrigade") and child:FindFirstChild("Health").Value > 0 then
			return true
		end
	end

	return false
end
CheckShark = function()
	for _, child in pairs(workspace.Enemies:GetChildren()) do
		if child.Name == "Shark" and playerCollectionLatest.Alive(child) then
			return true
		end
	end

	return false
end

do
	CheckTerrorShark = function()
		for _, child in pairs(workspace.Enemies:GetChildren()) do
			if child.Name == "Terrorshark" and playerCollectionLatest.Alive(child) then
				return true
			end
		end

		return false
	end
end

do
	CheckPiranha = function()
		for _, child in pairs(workspace.Enemies:GetChildren()) do
			if child.Name == "Piranha" then
				if playerCollectionLatest.Alive(child) then
					return true
				end
			end
		end

		return false
	end
end

CheckFishCrew = function()
	for _, child in pairs(workspace.Enemies:GetChildren()) do
		if child.Name ~= "Fish Crew Member" then
			if child.Name ~= "Haunted Crew Member" then
				continue
			end
		end

		if playerCollectionLatest.Alive(child) then
			return true
		end
	end

	return false
end

do
	CheckHauntedCrew = function()
		for _, child in pairs(workspace.Enemies:GetChildren()) do
			if child.Name == "Haunted Crew Member" and playerCollectionLatest.Alive(child) then
				return true
			end
		end

		return false
	end
end

do
	CheckSeaBeast = function()
		if workspace.SeaBeasts:FindFirstChild("SeaBeast1") then
			return true
		end

		return false
	end
end

do
	CheckLeviathan = function()
		if workspace.SeaBeasts:FindFirstChild("Leviathan") then
			return true
		end

		return false
	end
end

do
	UpdStFruit = function()
		local children, childInstancesCurrent = plr.Backpack:GetChildren()

		for _, playervalueaiPlayerData in next, children, childInstancesCurrent do
			StoreFruit = playervalueaiPlayerData:FindFirstChild("EatRemote", true)

			if StoreFruit then
				replicated.Remotes.CommF_:InvokeServer("StoreFruit", StoreFruit.Parent:GetAttribute("OriginalName"), plr.Backpack:FindFirstChild(playervalueaiPlayerData.Name))
			end
		end
	end
end

collectFruits = function(collectfruitsInput)
	if collectfruitsInput then
		local Character = plr.Character

		for _, child in pairs(workspace:GetChildren()) do
			if string.find(child.Name, "Fruit") then
				child.Handle.CFrame = Character.HumanoidRootPart.CFrame
			end
		end
	end
end
Getmoon = function()
	if World1 then
		return Lighting.FantasySky.MoonTextureId
	end

	if World2 then
		return Lighting.FantasySky.MoonTextureId
	end

	if World3 then
		return Lighting.Sky.MoonTextureId
	end
end
DropFruits = function()
	local children, childInstancesCached = plr.Backpack:GetChildren()

	for _, playervalueaiPlayerData in next, children, childInstancesCached do
		if string.find(playervalueaiPlayerData.Name, "Fruit") then
			EquipWeapon(playervalueaiPlayerData.Name)
			wait(0.1)

			if plr.PlayerGui.Main.Dialogue.Visible == true then
				plr.PlayerGui.Main.Dialogue.Visible = false
			end

			EquipWeapon(playervalueaiPlayerData.Name)
			plr.Character:FindFirstChild(playervalueaiPlayerData.Name).EatRemote:InvokeServer("Drop")
		end
	end

	for _, child in pairs(plr.Character:GetChildren()) do
		if string.find(child.Name, "Fruit") then
			EquipWeapon(child.Name)
			wait(0.1)

			if plr.PlayerGui.Main.Dialogue.Visible == true then
				plr.PlayerGui.Main.Dialogue.Visible = false
			end

			EquipWeapon(child.Name)
			plr.Character:FindFirstChild(child.Name).EatRemote:InvokeServer("Drop")
		end
	end
end

do
	GetBP = function(getbpInput)
		return plr.Backpack:FindFirstChild(getbpInput) or plr.Character:FindFirstChild(getbpInput)
	end
end

do
	GetIn = function(getinInput)
		for _, playervalueaiPlayerData in pairs(replicated.Remotes.CommF_:InvokeServer("getInventory")) do
			if type(playervalueaiPlayerData) == "table" then
				if playervalueaiPlayerData.Name == getinInput then
					return true
				end

				if plr.Character:FindFirstChild(getinInput) then
					return true
				end

				if plr.Backpack:FindFirstChild(getinInput) then
					return true
				end
			end
		end

		return false
	end
end

GetM = function(getmInput)
	for _, playervalueaiPlayerData in pairs(replicated.Remotes.CommF_:InvokeServer("getInventory")) do
		if type(playervalueaiPlayerData) == "table" and playervalueaiPlayerData.Type == "Material" and playervalueaiPlayerData.Name == getmInput then
			return playervalueaiPlayerData.Count
		end
	end

	return 0
end
GetWP = function(getwpInput)
	local response = replicated.Remotes.CommF_:InvokeServer("getInventory")

	if type(response) ~= "table" then
		return false
	end

	for _, playervalueaiPlayerData in pairs(response) do
		if type(playervalueaiPlayerData) == "table" and playervalueaiPlayerData.Type == "Sword" then
			if playervalueaiPlayerData.Name == getwpInput then
				return true
			end

			if plr.Character then
				if plr.Character:FindFirstChild(getwpInput) then
					return true
				end
			end

			if not plr.Backpack then
				continue
			end

			if plr.Backpack:FindFirstChild(getwpInput) then
				return true
			end
		end
	end

	return false
end
getInfinity_Ability = function(getinfinityAbilityInputState, getinfinityAbilityInput)
	if not Root then
		return
	end

	if getinfinityAbilityInputState == "Soru" and getinfinityAbilityInput then
		local next_ = next
		local getinfinityAbilityPlayerDataEntry, getinfinityAbilityPlayerDataData = getgc()

		for _, playervalueaiPlayerData in next_, getinfinityAbilityPlayerDataEntry, getinfinityAbilityPlayerDataData do
			if plr.Character.Soru then
				if typeof(playervalueaiPlayerData) == "function" and getfenv(playervalueaiPlayerData).script == plr.Character.Soru then
					local next_2 = next
					local getinfinityAbilityPlayerData, getinfinityAbilityPlayerDataState = getupvalues(playervalueaiPlayerData)

					for _, getinfinityAbilityPlayerDataItem in next_2, getinfinityAbilityPlayerData, getinfinityAbilityPlayerDataState do
						if typeof(getinfinityAbilityPlayerDataItem) == "table" then
							repeat
								wait(Sec)
								getinfinityAbilityPlayerDataItem.LastUse = 0
							until plr.Character.Humanoid.Health <= 0
						end
					end
				end
			end
		end
	elseif getinfinityAbilityInputState == "Energy" and getinfinityAbilityInput then
		connectScoped(plr.Character.Energy.Changed, function()
			if getinfinityAbilityInput then
				plr.Character.Energy.Value = Energy
			end
		end)
	elseif getinfinityAbilityInputState == "Observation" and getinfinityAbilityInput then
		plr.VisionRadius.Value = math.huge
	end
end
Hop = function()
	pcall(function()
		for i = math.random(1, math.random(40, 75)), 100 do
			for k, playervalueaiPlayerData in next, replicated.__ServerBrowser:InvokeServer(i), nil do
				if tonumber(playervalueaiPlayerData.Count) < 12 then
					TeleportService:TeleportToPlaceInstance(game.PlaceId, k)
				end
			end
		end
	end)
end

local Part = Instance.new("Part", workspace)

Part.Size = Vector3.new(1, 1, 1)
Part.Name = "Rip_Indra"
Part.Anchored = true
Part.CanCollide = false
Part.CanTouch = false
Part.Transparency = 1

do
	local PartName = workspace:FindFirstChild(Part.Name)

	if PartName and PartName ~= Part then
		PartName:Destroy()
	end
end

do
	task.spawn(function()
		while task.wait() do
			if Part and Part.Parent == workspace then
				if shouldTween then
					getgenv().OnFarm = true
				else
					getgenv().OnFarm = false
				end
			else
				getgenv().OnFarm = false
			end
		end
	end)
end

do
	task.spawn(function()
		local LocalPlayer = game.Players.LocalPlayer

		while true do
			task.wait()

			if not LocalPlayer.Character then
				continue
			end

			if LocalPlayer.Character.PrimaryPart then
				break
			end
		end

		Part.CFrame = LocalPlayer.Character.PrimaryPart.CFrame

		while task.wait() do
			pcall(function()
				if getgenv().OnFarm then
					if not _G.WasOnFarm then
						_G.WasOnFarm = true
					end

					if Part and Part.Parent == workspace then
						local PrimaryPart = LocalPlayer.Character and LocalPlayer.Character.PrimaryPart

						if PrimaryPart and (PrimaryPart.Position - Part.Position).Magnitude <= 200 then
							PrimaryPart.CFrame = CFrame.new(Part.Position)
						else
							Part.CFrame = PrimaryPart.CFrame
						end
					end

					local Character = LocalPlayer.Character

					if Character then
						for _, child in pairs(Character:GetChildren()) do
							if child:IsA("BasePart") then
								child.CanCollide = false
							end
						end
					end
				elseif _G.WasOnFarm then
					_G.WasOnFarm = false

					local Character = LocalPlayer.Character

					if Character then
						for _, child in pairs(Character:GetChildren()) do
							if child:IsA("BasePart") then
								child.CanCollide = true
							end
						end
					end
				end
			end)
		end
	end)
end

local ReplicatedStorage = game:GetService("ReplicatedStorage")

game:GetService("TweenService")
game:GetService("RunService")

do
	local LocalPlayer = game:GetService("Players").LocalPlayer

	sea1 = game.PlaceId == 2753915549 or game.PlaceId == 85211729168715
	sea2 = game.PlaceId == 4442272183 or game.PlaceId == 79091703265657
	sea3 = game.PlaceId == 7449423635 or game.PlaceId == 100117331123089

	local locationData = {
		["Tween Speed"] = 200,
		["Bypass Teleport"] = false,
		["Up Y"] = false,
		["Up Y When Low Health"] = false,
		["Same Y"] = false
	}
	local cFrame = CFrame.new(10641.0918, -1953.92981, 9825.07031, -0.652825892, -9.2805891e-08, -0.757508039, -2.73638356e-08, 1, -9.89323823e-08, 0.757508039, -4.38572947e-08, -0.652825892)
	local cFrame2 = CFrame.new(-16271.126, 25.5847301, 1371.98755, 0.999396622, -5.78875188e-08, -0.0347310975, 5.52972779e-08, 1, -8.7544322e-08, 0.034731105, 8.28877091e-08, 0.999396741)

	Convert_CFrame = function(isEnabledNearby)
		if not isEnabledNearby then
			return
		end

		if typeof(isEnabledNearby) == "Vector3" then
			return CFrame.new(isEnabledNearby)
		end

		if typeof(isEnabledNearby) == "CFrame" then
			return isEnabledNearby
		end

		if typeof(isEnabledNearby) == "Model" then
			return isEnabledNearby:GetPivot()
		end

		if isEnabledNearby.CFrame then
			return isEnabledNearby.CFrame
		end

		return nil
	end
	GetDistance = function(getdistanceInput, getdistanceInputState, getdistanceInputData)
		if getdistanceInput == nil then
			return 9e9
		end

		local Character = LocalPlayer.Character

		if not Character then
			return 9e9
		end

		local Humanoid = Character:FindFirstChild("Humanoid")

		if not Humanoid or Humanoid.Health <= 0 then
			return 9e9
		end

		if getdistanceInputState == nil then
			getdistanceInputState = Character:FindFirstChild("HumanoidRootPart")

			if not getdistanceInputState then
				return 9e9
			end
		end

		local getdistancePlayerData = Convert_CFrame(getdistanceInput)
		local getdistancePlayerDataState = Convert_CFrame(getdistanceInputState)

		if getdistanceInputData then
			return (Vector3.new(getdistancePlayerData.X, 0, getdistancePlayerData.Z) - Vector3.new(getdistancePlayerDataState.X, 0, getdistancePlayerDataState.Z)).Magnitude
		end

		return (getdistancePlayerData.Position - getdistancePlayerDataState.Position).Magnitude
	end
	InArea = function(inareaInput)
		local _WorldOrigin = workspace:FindFirstChild("_WorldOrigin")

		if not _WorldOrigin then
			return {
				Name = ""
			}
		end

		local inareaMovementData = Convert_CFrame(inareaInput)
		local children, childInstancesLatest = _WorldOrigin.Locations:GetChildren()

		for _, playervalueaiPlayerData in next, children, childInstancesLatest do
			if playervalueaiPlayerData:FindFirstChild("Mesh") and (inareaMovementData.Position - playervalueaiPlayerData.Position).Magnitude <= playervalueaiPlayerData.Mesh.Scale.X then
				return playervalueaiPlayerData
			end
		end

		return {
			Name = ""
		}
	end
	GetSpawnPoint = function(getspawnpointInput)
		local Pirates_ = workspace:FindFirstChild("_WorldOrigin") and workspace._WorldOrigin:FindFirstChild("PlayerSpawns") and workspace._WorldOrigin.PlayerSpawns:FindFirstChild("Pirates")

		if not Pirates_ then
			return
		end

		local children, childInstancesNearby = Pirates_:GetChildren()

		for _, playervalueaiPlayerData in next, children, childInstancesNearby do
			if playervalueaiPlayerData:FindFirstChild("Part") and (playervalueaiPlayerData.Part.Position - getspawnpointInput.Position).Magnitude <= 2500 then
				return playervalueaiPlayerData
			end
		end
	end
	CheckLegendaryItems = function()
		local function playervalueqPlayerData(valueArgumentStored)
			local children, childInstancesVisible = LocalPlayer.Backpack:GetChildren()

			for _, playervalueaiPlayerData in next, children, childInstancesVisible do
				if playervalueaiPlayerData:IsA("Tool") then
					if playervalueaiPlayerData.Name == valueArgumentStored then
						return playervalueaiPlayerData
					end

					if string.find(playervalueaiPlayerData.Name, valueArgumentStored) then
						return playervalueaiPlayerData
					end
				end
			end

			local children2, childInstancesAvailable = LocalPlayer.Character:GetChildren()

			for _, playervalueaiPlayerData in next, children2, childInstancesAvailable do
				if playervalueaiPlayerData:IsA("Tool") and (playervalueaiPlayerData.Name == valueArgumentStored or string.find(playervalueaiPlayerData.Name, valueArgumentStored)) then
					return playervalueaiPlayerData
				end
			end
		end

		if playervalueqPlayerData("God's Chalice") or playervalueqPlayerData("Fist of Darkness") or playervalueqPlayerData("Sweet Chalice") or playervalueqPlayerData("Hallow Essence") or playervalueqPlayerData("Flower1") then
			return true
		end

		return false
	end
	WaitForHumanoid = function()
		local Character = LocalPlayer.Character

		if not Character then
			return nil
		end

		local Humanoid = Character:FindFirstChild("Humanoid")

		if Humanoid then
			return Humanoid
		end

		local waitforhumanoidPlayerData = tick() + 5
		local Humanoid2

		while true do
			if not (tick() < waitforhumanoidPlayerData) then
				return nil
			end

			Humanoid2 = Character:FindFirstChild("Humanoid")

			if Humanoid2 then
				break
			end

			task.wait(0.1)
		end

		return Humanoid2
	end
	checkinventory = function(checkinventoryInput)
		if checkinventoryInput then
			for _, playervalueaiPlayerData in pairs(ReplicatedStorage.Remotes.CommF_:InvokeServer("getInventory")) do
				if playervalueaiPlayerData.Name == checkinventoryInput then
					return true
				end
			end
		end

		return false
	end
	getdis = function(getdisInput, getdisInputState)
		local CFrame_ = getdisInputState or LocalPlayer.Character.HumanoidRootPart.CFrame

		return (CFrame.new(getdisInput.X, CFrame_.Y, getdisInput.Z).Position - CFrame.new(CFrame_.X, CFrame_.Y, CFrame_.Z).Position).Magnitude
	end
	CanBypassTeleport = function(destination)
		local Name = InArea(destination).Name

		if Name == "" then
			return false
		end

		if locationData["Bypass Teleport"] and not Name:find("Dimension") then
			if not (Name:find("Submerged") or Name == "Sealed Cavern") then
				if not Name:lower():find("under") and not CheckLegendaryItems() then
					if LocalPlayer.Data and LocalPlayer.Data.LastSpawnPoint and LocalPlayer.Data.LastSpawnPoint.Value == "SubmergedIsland" then
						return false
					end

					if GetDistance(destination.Position) <= 3500 then
						return false
					end

					return true
				end
			end
		end

		return false
	end
	GetBypassCFrame = function(destinationState)
		local huge = math.huge
		local getbypasscframePlayerData
		local children = workspace._WorldOrigin.PlayerSpawns.Pirates:GetChildren()
		local HumanoidRootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

		if not HumanoidRootPart then
			return nil
		end

		for _, playervalueaiPlayerData in next, children, nil do
			if playervalueaiPlayerData:FindFirstChild("Part") and (destinationState.Position - HumanoidRootPart.Position).Magnitude >= 3000 and GetSpawnPoint(playervalueaiPlayerData.Part) ~= GetSpawnPoint(HumanoidRootPart) and (playervalueaiPlayerData.Part.Position - HumanoidRootPart.Position).Magnitude <= 10000 and (playervalueaiPlayerData.Part.Position - destinationState.Position).Magnitude <= huge then
				huge = (playervalueaiPlayerData.Part.Position - destinationState.Position).Magnitude
				getbypasscframePlayerData = playervalueaiPlayerData
			end
		end

		return getbypasscframePlayerData
	end
	BypassTP = function(bypasstpInput)
		local Character = LocalPlayer.Character

		if not Character then
			return
		end

		local humanoid = WaitForHumanoid()

		if not humanoid or humanoid.Health <= 0 then
			return
		end

		if CanBypassTeleport(bypasstpInput) and GetBypassCFrame(bypasstpInput) then
			local bypasstpPlayerData = GetBypassCFrame(bypasstpInput)

			if bypasstpPlayerData and bypasstpPlayerData:FindFirstChild("Part") then
				Character.LastSpawnPoint.Disabled = true
				ReplicatedStorage.Remotes.CommF_:InvokeServer("SetLastSpawnPoint", bypasstpPlayerData.Name)
				ReplicatedStorage.Remotes.CommF_:InvokeServer("SetSpawnPoint")
				Character:PivotTo(bypasstpPlayerData.Part.CFrame)
				humanoid:ChangeState(15)

				while true do
					task.wait()

					if not LocalPlayer.Character then
						continue
					end

					if WaitForHumanoid() and WaitForHumanoid().Health > 0 then
						break
					end
				end
			end
		end
	end
	totopofgreattree = function()
		if getdis(CFrame.new(28310.0234, 14895.1123, 109.456741)) > 1500 then
			ReplicatedStorage.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(28310.0234, 14895.1123, 109.456741))
			wait(0.3)
		end

		local cFrame3 = CFrame.new(28607.5352, 14896.5449, 106.011726)

		_tp(cFrame3)

		repeat
			wait()
		until getdis(cFrame3) <= 5

		wait(0.5)

		for i = 1, 4 do
			ReplicatedStorage.Remotes.CommF_:InvokeServer("RaceV4Progress", "TeleportBack")
		end
	end
	requestentrance = function(questTarget)
		local Position = questTarget

		if typeof(questTarget) == "CFrame" then
			Position = questTarget.Position
		end

		local questData

		if sea1 then
			questData = {
				Sky3 = Vector3.new(-7894, 5547, -380),
				Sky3Exit = Vector3.new(-4607, 874, -1667),
				UnderWater = Vector3.new(61163, 11, 1819),
				["Underwater City"] = Vector3.new(61165.19140625, 0.18704631924629211, 1897.379150390625),
				["Pirate Village"] = Vector3.new(-1242.4625244140625, 4.7870597839355469, 3901.282958984375),
				UnderwaterExit = Vector3.new(4050, -1, -1814)
			}
		elseif sea2 then
			questData = {
				["Swan Mansion"] = Vector3.new(-390, 332, 673),
				["Swan Room"] = Vector3.new(2285, 15, 905),
				["Cursed Ship"] = Vector3.new(923, 126, 32852),
				["Zombie Island"] = Vector3.new(-6509, 83, -133)
			}
		else
			questData = {
				["Hydra Island"] = Vector3.new(5657.88623046875, 1013.0790405273438, -335.4996337890625),
				Mansion = Vector3.new(-12462, 375, -7552),
				Castle = Vector3.new(-5036, 315, -3179),
				["Temple of Time"] = Vector3.new(28286, 14897, 103),
				["Greate Tree"] = Vector3.new(3024.1709, 2280.69434, -7325.12793)
			}

			if not checkinventory("Valkyrie Helm") then
				return
			end
		end

		local requestentranceMovementData
		local huge = math.huge

		for _, playervalueaiPlayerData in pairs(questData) do
			local Magnitude = typeof(playervalueaiPlayerData) == "Vector3" and (playervalueaiPlayerData - Position).Magnitude or (playervalueaiPlayerData.Position - Position).Magnitude

			if Magnitude < huge then
				huge = Magnitude
				requestentranceMovementData = playervalueaiPlayerData
			end
		end

		if requestentranceMovementData and huge and huge < getdis(questTarget) then
			pcall(function()
				if _G.TweenCache then
					_G.TweenCache:Cancel()
				end
			end)

			local ok = not (typeof(requestentranceMovementData) == "Vector3" and requestentranceMovementData.X == 3024.1709 and requestentranceMovementData.Y == 2280.69434 and requestentranceMovementData.Z == -7325.12793)

			if not ok then
				ok = not (ReplicatedStorage.Remotes.CommF_:InvokeServer("RaceV4Progress", "Check") >= 2)
			end

			if ok then
				if huge < getdis(questTarget) then
					ReplicatedStorage.Remotes.CommF_:InvokeServer("requestEntrance", typeof(requestentranceMovementData) == "Vector3" and requestentranceMovementData or requestentranceMovementData.Position)
					wait(1)
				end
			else
				totopofgreattree()
				wait(1)
			end
		end
	end
	_tp = function(tpInput)
		local cFrame3

		if typeof(tpInput) == "Vector3" then
			cFrame3 = CFrame.new(tpInput)
		elseif typeof(tpInput) == "CFrame" then
			cFrame3 = tpInput
		else
			cFrame3 = tpInput and tpInput.CFrame
		end

		if not cFrame3 then
			return
		end

		if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then
			return
		end

		local HumanoidRootPart = plr.Character.HumanoidRootPart

		getgenv().OnFarm = false
		pcall(function()
			if CanBypassTeleport(cFrame3) then
				BypassTP(cFrame3)
				task.wait(0.5)
			end
		end)
		pcall(function()
			requestentrance(tpInput)
		end)

		if sea3 then
			if getdis(cFrame3.Position, cFrame.Position) < 2000 then
				local HumanoidRootPart2 = plr.Character.HumanoidRootPart

				if math.abs(cFrame.Position.Y - HumanoidRootPart2.CFrame.Y) > 1000 then
					repeat
						task.wait()
						old_tp(cFrame2)

						if getdis(cFrame2) < 10 then
							local Net = ReplicatedStorage.Modules.Net

							Net["RF/SubmarineWorkerSpeak"]:InvokeServer("AskKilledTikiBoss")
							task.wait(0.5)
							Net["RF/SubmarineWorkerSpeak"]:InvokeServer("TravelToSubmergedIsland")
						end
					until getdis(cFrame3.Position) < 2000

					task.wait(0.6)
					pcall(function()
						if HumanoidRootPart2:FindFirstChild("BodyClip") then
							HumanoidRootPart2.BodyClip:Destroy()
						end
					end)
				end
			end
		end

		local Magnitude = (cFrame3.Position - HumanoidRootPart.Position).Magnitude
		local tweenInfo = TweenInfo.new(Magnitude / (Magnitude <= 15 and (getgenv().TweenSpeedNear or 180) or getgenv().TweenSpeedFar or 150), Enum.EasingStyle.Linear)
		local tween = game:GetService("TweenService"):Create(Part, tweenInfo, {
			CFrame = CFrame.new(cFrame3.Position)
		})

		if plr.Character.Humanoid.Sit == true then
			Part.CFrame = CFrame.new(Part.Position.X, cFrame3.Y, Part.Position.Z)
		end

		tween:Play()
		task.spawn(function()
			while tween.PlaybackState == Enum.PlaybackState.Playing do
				if shouldTween then
					task.wait(0.1)
				else
					tween:Cancel()

					break
				end
			end

			getgenv().OnFarm = true
		end)

		return tween
	end
end

old_tp = function(oldTpInput)
	if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
		plr.Character.HumanoidRootPart.CFrame = oldTpInput
	end
end
TeleportToTarget = function(destinationData)
	local teleporttotargetPlayerData = _tp(destinationData)

	if teleporttotargetPlayerData then
		teleporttotargetPlayerData.Completed:Wait()
	end

	task.wait(0.1)
end
notween = function(destinationEntry)
	plr.Character.HumanoidRootPart.CFrame = destinationEntry
end

do
	BTP = function(btpInput)
		local LocalPlayer = game.Players.LocalPlayer
		local HumanoidRootPart = LocalPlayer.Character.HumanoidRootPart
		local Humanoid = LocalPlayer.Character.Humanoid
		local Main = LocalPlayer.PlayerGui.Main
		local Position = HumanoidRootPart.Position

		repeat
			Humanoid.Health = 0
			HumanoidRootPart.CFrame = btpInput
			Main.Quest.Visible = false

			if (HumanoidRootPart.Position - Position).Magnitude > 1 then
				Position = HumanoidRootPart.Position
				HumanoidRootPart.CFrame = btpInput
			end

			task.wait(0.5)
		until (btpInput.Position - HumanoidRootPart.Position).Magnitude <= 2000
	end
end

do
	spawn(function()
		while task.wait() do
			pcall(function()
				if not startupState.initializing and (_G.Auto_StartRaid or _G.SailBoat_Hydra or _G.WardenBoss or _G.AutoFactory or _G.HighestMirage or _G.HCM or _G.PGB or _G.Leviathan1 or _G.UPGDrago or _G.Complete_Trials or _G.TpDrago_Prehis or _G.BuyDrago or _G.AutoFireFlowers or _G.DT_Uzoth or _G.AutoBerry or _G.Prefully or _G.Prehis_Find or _G.Prehis_Skills or _G.Prehis_DB or _G.Prehis_DE or _G.FarmBlazeEM or _G.Dojoo or _G.CollectPresent or _G.AutoLawKak or _G.TpLab or _G.AutoPhoenixF or _G.AutoFarmChest or _G.AutoHytHallow or _G.LongsWord or _G.BlackSpikey or _G.AutoHolyTorch or _G.TrainDrago or _G.AutoSaber or _G.FarmMastery_Dev or _G.CitizenQuest or _G.AutoEctoplasm or _G.KeysRen or _G.Auto_Rainbow_Haki or _G.obsFarm or _G.AutoBigmom or _G.Doughv2 or _G.AuraBoss or _G.Raiding or _G.Auto_Cavender or _G.TpPly or _G.Bartilo_Quest or _G.Level or _G.FarmEliteHunt or _G.AutoZou or _G.AutoFarm_Bone or getgenv().AutoMaterial or _G.CraftVM or _G.FrozenTP or _G.TPDoor or _G.AcientOne or _G.AutoFarmNear or _G.AutoRaidCastle or _G.DarkBladev3 or _G.AutoFarmRaid or _G.Auto_Cake_Prince or _G.Addealer or _G.TPNpc or _G.TwinHook or _G.FindMirage or _G.FarmChestM or _G.Shark or _G.TerrorShark or _G.Piranha or _G.MobCrew or _G.SeaBeast1 or _G.FishBoat or _G.AutoPole or _G.AutoPoleV2 or _G.Auto_SuperHuman or _G.AutoDeathStep or _G.Auto_SharkMan_Karate or _G.Auto_Electric_Claw or _G.AutoDragonTalon or _G.Auto_Def_DarkCoat or _G.Auto_God_Human or _G.Auto_Tushita or _G.AutoMatSoul or _G.AutoKenVTWO or _G.AutoSerpentBow or _G.AutoFMon or _G.Auto_Soul_Guitar or _G.TPGEAR or _G.AutoSaw or _G.AutoTridentW2 or _G.AutoEvoRace or _G.AutoGetQuestBounty or _G.MarinesCoat or _G.TravelDres or _G.Defeating or _G.DummyMan or _G.Auto_Yama or _G.Auto_SwanGG or _G.SwanCoat or _G.AutoEcBoss or _G.Auto_Mink or _G.Auto_Human or _G.Auto_Skypiea or _G.Auto_Fish or _G.CDK_TS or _G.CDK_YM or _G.CDK or _G.AutoFarmGodChalice or _G.AutoFistDarkness or _G.AutoMiror or _G.Teleport or _G.AutoKilo or _G.AutoGetUsoap or _G.Praying or _G.TryLucky or _G.AutoColShad or _G.AutoUnHaki or _G.Auto_DonAcces or _G.AutoRipIngay or _G.DragoV3 or _G.DragoV1 or _G.SailBoats or NextIs or _G.FarmGodChalice or _G.IceBossRen or senth or senth2 or _G.Lvthan or _G.beasthunter or _G.DangerLV or _G.Relic123 or _G.tweenKitsune or _G.Collect_Ember or _G.AutofindKitIs or _G.snaguine or _G.TwFruits or _G.tweenKitShrine or _G.Tp_LgS or _G.Tp_MasterA or _G.tweenShrine or _G.FarmMastery_G or _G.FarmMastery_S or _G.FarmBoss or _G.AutoFarmAllBoss or _G.AutoFishSlap or _G.FarmTyrant or _G.FarmPhaBinh or _G.AutoSpawnCP or _G.AutoBerryH or _G.AutoChestBP or _G.FarmEliteHop or _G.AutoHop_Dough or _G.AutoDoughKing or _G.AutoAttackDoughKing or _G.StartEvent or _G.AutoMysticIsland or _G.AutoPlayerHunter or _G.SafeMode or _G.AutoKillMob or _G.AutoStartPrehistoric or _G.AutoUnHaki or _G.AutoAttackRipIndra or _G.AutoFarmIsland or _G.AutoFarmDungeon or _G.AutoFarmCandy or _G.AutoTP_Gift or _G.AutoTPGift or _G.AutoTPAndCollect or _G.MasterAutoLevel or _G.MasterAutoCandy or _G.TPFloor1 or _G.TPFloor2 or _G.TPFloor3 or _G.TPFloor4 or _G.AutoMagnetToken) then
					shouldTween = true

					if not plr.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
						local BodyVelocity = Instance.new("BodyVelocity")

						BodyVelocity.Name = "BodyClip"
						BodyVelocity.Parent = plr.Character.HumanoidRootPart
						BodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
						BodyVelocity.Velocity = Vector3.new(0, 0, 0)
					end

					if not plr.Character:FindFirstChild("highlight") then
						local Highlight = Instance.new("Highlight")

						Highlight.Name = "highlight"
						Highlight.Enabled = true
						Highlight.FillColor = Color3.fromRGB(0, 255, 254)
						Highlight.OutlineColor = Color3.fromRGB(0, 255, 254)
						Highlight.FillTransparency = 0.5
						Highlight.OutlineTransparency = 0.2
						Highlight.Parent = plr.Character
					end

					for _, descendant in pairs(plr.Character:GetDescendants()) do
						if descendant:IsA("BasePart") then
							descendant.CanCollide = false
						end
					end
				else
					shouldTween = false

					if plr.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
						plr.Character.HumanoidRootPart:FindFirstChild("BodyClip"):Destroy()
					end

					if plr.Character:FindFirstChild("highlight") then
						plr.Character:FindFirstChild("highlight"):Destroy()
					end
				end
			end)
		end
	end)
end

QuestB = function()
	if World1 then
		if _G.FindBoss == "The Gorilla King" then
			bMon = "The Gorilla King"
			Qname = "JungleQuest"
			Qdata = 3
			PosQBoss = CFrame.new(-1601.6553955078, 36.85213470459, 153.38809204102)
			PosB = CFrame.new(-1088.75977, 8.13463783, -488.559906, -0.707134247, 0, 0.707079291, 0, 1, 0, -0.707079291, 0, -0.707134247)
		elseif _G.FindBoss == "Bobby" then
			bMon = "Bobby"
			Qname = "BuggyQuest1"
			Qdata = 3
			PosQBoss = CFrame.new(-1140.1761474609, 4.752049446106, 3827.4057617188)
			PosB = CFrame.new(-1087.3760986328, 46.949409484863, 4040.1462402344)
		elseif _G.FindBoss == "The Saw" then
			bMon = "The Saw"
			PosB = CFrame.new(-784.89715576172, 72.427383422852, 1603.5822753906)
		elseif _G.FindBoss == "Yeti" then
			bMon = "Yeti"
			Qname = "SnowQuest"
			Qdata = 3
			PosQBoss = CFrame.new(1386.8073730469, 87.272789001465, -1298.3576660156)
			PosB = CFrame.new(1218.7956542969, 138.01184082031, -1488.0262451172)
		elseif _G.FindBoss == "Mob Leader" then
			bMon = "Mob Leader"
			PosB = CFrame.new(-2844.7307128906, 7.4180502891541, 5356.6723632813)
		elseif _G.FindBoss == "Vice Admiral" then
			bMon = "Vice Admiral"
			Qname = "MarineQuest2"
			Qdata = 2
			PosQBoss = CFrame.new(-5036.2465820313, 28.677835464478, 4324.56640625)
			PosB = CFrame.new(-5006.5454101563, 88.032081604004, 4353.162109375)
		elseif _G.FindBoss == "Saber Expert" then
			bMon = "Saber Expert"
			PosB = CFrame.new(-1458.89502, 29.8870335, -50.633564)
		elseif _G.FindBoss == "Warden" then
			bMon = "Warden"
			Qname = "ImpelQuest"
			Qdata = 1
			PosB = CFrame.new(5278.04932, 2.15167475, 944.101929, 0.220546961, -4.49946401e-06, 0.975376427, -1.95412576e-05, 1, 9.03162072e-06, -0.975376427, -2.10519756e-05, 0.220546961)
			PosQBoss = CFrame.new(5191.86133, 2.84020686, 686.438721, -0.731384635, 0, 0.681965172, 0, 1, 0, -0.681965172, 0, -0.731384635)
		elseif _G.FindBoss == "Chief Warden" then
			bMon = "Chief Warden"
			Qname = "ImpelQuest"
			Qdata = 2
			PosB = CFrame.new(5206.92578, 0.997753382, 814.976746, 0.342041343, -0.00062915677, 0.939684749, 0.00191645394, 0.999998152, -2.80422337e-05, -0.939682961, 0.00181045406, 0.342041939)
			PosQBoss = CFrame.new(5191.86133, 2.84020686, 686.438721, -0.731384635, 0, 0.681965172, 0, 1, 0, -0.681965172, 0, -0.731384635)
		elseif _G.FindBoss == "Swan" then
			bMon = "Swan"
			Qname = "ImpelQuest"
			Qdata = 3
			PosB = CFrame.new(5325.09619, 7.03906584, 719.570679, -0.309060812, 0, 0.951042235, 0, 1, 0, -0.951042235, 0, -0.309060812)
			PosQBoss = CFrame.new(5191.86133, 2.84020686, 686.438721, -0.731384635, 0, 0.681965172, 0, 1, 0, -0.681965172, 0, -0.731384635)
		elseif _G.FindBoss == "Magma Admiral" then
			bMon = "Magma Admiral"
			Qname = "MagmaQuest"
			Qdata = 3
			PosQBoss = CFrame.new(-5314.6220703125, 12.262420654297, 8517.279296875)
			PosB = CFrame.new(-5765.8969726563, 82.92064666748, 8718.3046875)
		elseif _G.FindBoss == "Fishman Lord" then
			bMon = "Fishman Lord"
			Qname = "FishmanQuest"
			Qdata = 3
			PosQBoss = CFrame.new(61122.65234375, 18.497442245483, 1569.3997802734)
			PosB = CFrame.new(61260.15234375, 30.950881958008, 1193.4329833984)
		elseif _G.FindBoss == "Wysper" then
			bMon = "Wysper"
			Qname = "SkyExp1Quest"
			Qdata = 3
			PosQBoss = CFrame.new(-7861.947265625, 5545.517578125, -379.85974121094)
			PosB = CFrame.new(-7866.1333007813, 5576.4311523438, -546.74816894531)
		elseif _G.FindBoss == "Thunder God" then
			bMon = "Thunder God"
			Qname = "SkyExp2Quest"
			Qdata = 3
			PosQBoss = CFrame.new(-7903.3828125, 5635.9897460938, -1410.923828125)
			PosB = CFrame.new(-7994.984375, 5761.025390625, -2088.6479492188)
		elseif _G.FindBoss == "Cyborg" then
			bMon = "Cyborg"
			Qname = "FountainQuest"
			Qdata = 3
			PosQBoss = CFrame.new(5258.2788085938, 38.526931762695, 4050.044921875)
			PosB = CFrame.new(6094.0249023438, 73.770050048828, 3825.7348632813)
		elseif _G.FindBoss == "Ice Admiral" then
			bMon = "Ice Admiral"
			Qdata = nil
			PosQBoss = CFrame.new(1266.08948, 26.1757946, -1399.57678, -0.573599219, 0, -0.81913656, 0, 1, 0, 0.81913656, 0, -0.573599219)
			PosB = CFrame.new(1266.08948, 26.1757946, -1399.57678, -0.573599219, 0, -0.81913656, 0, 1, 0, 0.81913656, 0, -0.573599219)
		elseif _G.FindBoss == "Greybeard" then
			bMon = "Greybeard"
			Qdata = nil
			PosQBoss = CFrame.new(-5081.3452148438, 85.221641540527, 4257.3588867188)
			PosB = CFrame.new(-5081.3452148438, 85.221641540527, 4257.3588867188)
		end
	end

	if World2 then
		if _G.FindBoss == "Diamond" then
			bMon = "Diamond"
			Qname = "Area1Quest"
			Qdata = 3
			PosQBoss = CFrame.new(-427.5666809082, 73.313781738281, 1835.4208984375)
			PosB = CFrame.new(-1576.7166748047, 198.59265136719, 13.724286079407)
		elseif _G.FindBoss == "Jeremy" then
			bMon = "Jeremy"
			Qname = "Area2Quest"
			Qdata = 3
			PosQBoss = CFrame.new(636.79943847656, 73.413787841797, 918.00415039063)
			PosB = CFrame.new(2006.9261474609, 448.95666503906, 853.98284912109)
		elseif _G.FindBoss == "Orbitus" then
			bMon = "Orbitus"
			Qname = "MarineQuest3"
			Qdata = 3
			PosQBoss = CFrame.new(-2441.986328125, 73.359344482422, -3217.5324707031)
			PosB = CFrame.new(-2172.7399902344, 103.32216644287, -4015.025390625)
		elseif _G.FindBoss == "Don Swan" then
			bMon = "Don Swan"
			PosB = CFrame.new(2286.2004394531, 15.177839279175, 863.8388671875)
		elseif _G.FindBoss == "Smoke Admiral" then
			bMon = "Smoke Admiral"
			Qname = "IceSideQuest"
			Qdata = 3
			PosQBoss = CFrame.new(-5429.0473632813, 15.977565765381, -5297.9614257813)
			PosB = CFrame.new(-5275.1987304688, 20.757257461548, -5260.6669921875)
		elseif _G.FindBoss == "Awakened Ice Admiral" then
			bMon = "Awakened Ice Admiral"
			Qname = "FrostQuest"
			Qdata = 3
			PosQBoss = CFrame.new(5668.9780273438, 28.519989013672, -6483.3520507813)
			PosB = CFrame.new(6403.5439453125, 340.29766845703, -6894.5595703125)
		elseif _G.FindBoss == "Tide Keeper" then
			bMon = "Tide Keeper"
			Qname = "ForgottenQuest"
			Qdata = 3
			PosQBoss = CFrame.new(-3053.9814453125, 237.18954467773, -10145.0390625)
			PosB = CFrame.new(-3795.6423339844, 105.88877105713, -11421.307617188)
		elseif _G.FindBoss == "Darkbeard" then
			bMon = "Darkbeard"
			Qdata = nil
			PosQBoss = CFrame.new(3677.08203125, 62.751937866211, -3144.8332519531)
			PosB = CFrame.new(3677.08203125, 62.751937866211, -3144.8332519531)
		elseif _G.FindBoss == "Cursed Captaim" then
			bMon = "Cursed Captain"
			Qdata = nil
			PosQBoss = CFrame.new(916.928589, 181.092773, 33422)
			PosB = CFrame.new(916.928589, 181.092773, 33422)
		elseif _G.FindBoss == "Order" then
			bMon = "Order"
			Qdata = nil
			PosQBoss = CFrame.new(-6217.2021484375, 28.047645568848, -5053.1357421875)
			PosB = CFrame.new(-6217.2021484375, 28.047645568848, -5053.1357421875)
		end
	end

	if World3 then
		if _G.FindBoss == "Stone" then
			bMon = "Stone"
			Qname = "PiratePortQuest"
			Qdata = 3
			PosQBoss = CFrame.new(-289.76705932617, 43.819011688232, 5579.9384765625)
			PosB = CFrame.new(-1027.6512451172, 92.404174804688, 6578.8530273438)
		elseif _G.FindBoss == "Hydra Leader" then
			bMon = "Hydra Leader"
			Qname = "VenomCrewQuest"
			Qdata = 3
			PosQBoss = CFrame.new(5211.021484375, 1004.35778859375, 758.18475341796875)
			PosB = CFrame.new(5821.89794921875, 1019.0950927734375, -73.719230651855469)
		elseif _G.FindBoss == "Kilo Admiral" then
			bMon = "Kilo Admiral"
			Qname = "MarineTreeIsland"
			Qdata = 3
			PosQBoss = CFrame.new(2179.3010253906, 28.731239318848, -6739.9741210938)
			PosB = CFrame.new(2764.2233886719, 432.46154785156, -7144.4580078125)
		elseif _G.FindBoss == "Captain Elephant" then
			bMon = "Captain Elephant"
			Qname = "DeepForestIsland"
			Qdata = 3
			PosQBoss = CFrame.new(-13232.682617188, 332.40396118164, -7626.01171875)
			PosB = CFrame.new(-13376.7578125, 433.28689575195, -8071.392578125)
		elseif _G.FindBoss == "Beautiful Pirate" then
			bMon = "Beautiful Pirate"
			Qname = "DeepForestIsland2"
			Qdata = 3
			PosQBoss = CFrame.new(-12682.096679688, 390.88653564453, -9902.1240234375)
			PosB = CFrame.new(5283.609375, 22.56223487854, -110.78285217285)
		elseif _G.FindBoss == "Cake Queen" then
			bMon = "Cake Queen"
			Qname = "IceCreamIslandQuest"
			Qdata = 3
			PosQBoss = CFrame.new(-819.376709, 64.9259796, -10967.2832, -0.766061664, 0, 0.642767608, 0, 1, 0, -0.642767608, 0, -0.766061664)
			PosB = CFrame.new(-678.648804, 381.353943, -11114.2012, -0.908641815, 0.00149294338, 0.41757378, 0.00837114919, 0.999857843, 0.0146408929, -0.417492568, 0.0167988986, -0.90852499)
		elseif _G.FindBoss == "Longma" then
			bMon = "Longma"
			Qdata = nil
			PosQBoss = CFrame.new(-10238.875976563, 389.7912902832, -9549.7939453125)
			PosB = CFrame.new(-10238.875976563, 389.7912902832, -9549.7939453125)
		elseif _G.FindBoss == "Soul Reaper" then
			bMon = "Soul Reaper"
			Qdata = nil
			PosQBoss = CFrame.new(-9524.7890625, 315.80429077148, 6655.7192382813)
			PosB = CFrame.new(-9524.7890625, 315.80429077148, 6655.7192382813)
		end
	end
end
QuestBeta = function()
	QuestB()

	return {
		[0] = _G.FindBoss,
		bMon,
		Qdata,
		Qname,
		PosB,
		PosQBoss
	}
end

do
	local Quests = require(game:GetService("ReplicatedStorage"):WaitForChild("Quests"))
	local GuideModule = require(game:GetService("ReplicatedStorage"):WaitForChild("GuideModule"))
	local questDataCurrent = {
		"MarineQuest",
		"BartiloQuest",
		"CitizenQuest",
		"Trainees"
	}

	CheckSea = function(checkseaInput)
		if (game.PlaceId == 2753915549 or game.PlaceId == 85211729168715) and checkseaInput == 1 then
			return true
		end

		if (game.PlaceId == 4442272183 or game.PlaceId == 79091703265657) and checkseaInput == 2 then
			return true
		end

		if (game.PlaceId == 7449423635 or game.PlaceId == 100117331123089) and checkseaInput == 3 then
			return true
		end

		return false
	end
	GetQuestPointFromNPC = function(questTargetState)
		for _, child in pairs(workspace.NPCs:GetChildren()) do
			if child.Name == questTargetState and child:FindFirstChild("HumanoidRootPart") then
				return child.HumanoidRootPart.CFrame
			end
		end

		for _, child in pairs(replicated.NPCs:GetChildren()) do
			if child.Name == questTargetState and child:FindFirstChild("HumanoidRootPart") then
				return child.HumanoidRootPart.CFrame
			end
		end

		return nil
	end
	GetQuests = function()
		local Value = plr.Data.Level.Value
		local n1 = 0
		local questDataCached = {}

		if Value >= 700 and CheckSea(1) then
			questDataCached.Mob = "Galley Captain"
			questDataCached.NameQuest = "FountainQuest"
			questDataCached.ID = 2
			questDataCached.LevelReq = 700
		elseif Value >= 1500 and CheckSea(2) then
			questDataCached.Mob = "Water Fighter"
			questDataCached.NameQuest = "ForgottenQuest"
			questDataCached.ID = 2
			questDataCached.LevelReq = 1450
		else
			for k, Quest in pairs(Quests) do
				for k2, playervalueaiPlayerData in pairs(Quest) do
					local LevelReq = playervalueaiPlayerData.LevelReq

					for k3 in pairs(playervalueaiPlayerData.Task) do
						if LevelReq <= Value and n1 <= LevelReq and playervalueaiPlayerData.Task[k3] > 1 then
							if not table.find(questDataCurrent, k) then
								n1 = LevelReq
								questDataCached.Mob = k3
								questDataCached.NameQuest = k
								questDataCached.ID = k2
								questDataCached.LevelReq = LevelReq
							end
						end
					end
				end
			end
		end

		return questDataCached
	end
	GetQuestPoint = function()
		if GuideModule and GuideModule.Data then
			if GuideModule.Data.LastClosestNPC then
				return GetQuestPointFromNPC(GuideModule.Data.LastClosestNPC)
			end
		end

		return nil
	end
end

MaterialMon = function()
	local LocalPlayer = game.Players.LocalPlayer
	local HumanoidRootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

	if not HumanoidRootPart then
		return
	end

	shouldRequestEntrance = function(questTargetData, questTargetEntry)
		if questTargetEntry <= (HumanoidRootPart.Position - questTargetData).Magnitude then
			replicated.Remotes.CommF_:InvokeServer("requestEntrance", questTargetData)
		end
	end

	if World1 then
		if SelectMaterial == "Angel Wings" then
			MMon = {
				"Shanda",
				"Royal Squad",
				"Royal Soldier",
				"Wysper",
				"Thunder God"
			}
			MPos = CFrame.new(-4698, 845, -1912)
			SP = "Default"
			shouldRequestEntrance(Vector3.new(-4607.82275, 872.54248, -1667.55688), 10000)
		elseif SelectMaterial == "Leather + Scrap Metal" then
			MMon = {
				"Brute",
				"Pirate"
			}
			MPos = CFrame.new(-1145, 15, 4350)
			SP = "Default"
		elseif SelectMaterial == "Magma Ore" then
			MMon = {
				"Military Soldier",
				"Military Spy",
				"Magma Admiral"
			}
			MPos = CFrame.new(-5815, 84, 8820)
			SP = "Default"
		elseif SelectMaterial == "Fish Tail" then
			MMon = {
				"Fishman Warrior",
				"Fishman Commando",
				"Fishman Lord"
			}
			MPos = CFrame.new(61123, 19, 1569)
			SP = "Default"
			shouldRequestEntrance(Vector3.new(61163.8515625, 5.3423423767089844, 1819.7841796875), 17000)
		end
	elseif World2 then
		if SelectMaterial == "Leather + Scrap Metal" then
			MMon = { "Marine Captain" }
			MPos = CFrame.new(-2010.5059814453125, 73.00115966796875, -3326.620849609375)
			SP = "Default"
		elseif SelectMaterial == "Magma Ore" then
			MMon = {
				"Magma Ninja",
				"Lava Pirate"
			}
			MPos = CFrame.new(-5428, 78, -5959)
			SP = "Default"
		elseif SelectMaterial == "Ectoplasm" then
			MMon = {
				"Ship Deckhand",
				"Ship Engineer",
				"Ship Steward",
				"Ship Officer"
			}
			MPos = CFrame.new(911.35827636719, 125.95812988281, 33159.5390625)
			SP = "Default"
			shouldRequestEntrance(Vector3.new(61163.8515625, 5.3423423767089844, 1819.7841796875), 18000)
		elseif SelectMaterial == "Mystic Droplet" then
			MMon = { "Water Fighter" }
			MPos = CFrame.new(-3385, 239, -10542)
			SP = "Default"
		elseif SelectMaterial == "Radioactive Material" then
			MMon = { "Factory Staff" }
			MPos = CFrame.new(295, 73, -56)
			SP = "Default"
		elseif SelectMaterial == "Vampire Fang" then
			MMon = { "Vampire" }
			MPos = CFrame.new(-6033, 7, -1317)
			SP = "Default"
		end
	elseif World3 then
		if SelectMaterial == "Scrap Metal" then
			MMon = {
				"Jungle Pirate",
				"Forest Pirate"
			}
			MPos = CFrame.new(-11975.78515625, 331.77340698242188, -10620.0302734375)
			SP = "Default"
		elseif SelectMaterial == "Fish Tail" then
			MMon = {
				"Fishman Raider",
				"Fishman Captain"
			}
			MPos = CFrame.new(-10993, 332, -8940)
			SP = "Default"
		elseif SelectMaterial == "Conjured Cocoa" then
			MMon = {
				"Chocolate Bar Battler",
				"Cocoa Warrior"
			}
			MPos = CFrame.new(620.63446044921875, 78.936447143554688, -12581.369140625)
			SP = "Default"
		elseif SelectMaterial == "Dragon Scale" then
			MMon = {
				"Dragon Crew Archer",
				"Dragon Crew Warrior"
			}
			MPos = CFrame.new(6594, 383, 139)
			SP = "Default"
		elseif SelectMaterial == "Gunpowder" then
			MMon = { "Pistol Billionaire" }
			MPos = CFrame.new(-84.855690002441406, 85.620613098144531, 6132.0087890625)
			SP = "Default"
		elseif SelectMaterial == "Mini Tusk" then
			MMon = { "Mythological Pirate" }
			MPos = CFrame.new(-13545, 470, -6917)
			SP = "Default"
		elseif SelectMaterial == "Demonic Wisp" then
			MMon = { "Demonic Soul" }
			MPos = CFrame.new(-9495.6806640625, 453.58624267578125, 5977.3486328125)
			SP = "Default"
		end
	end
end

do
	QuestNeta = function()
		local questnetaQuestData = GetQuests()

		return {
			questnetaQuestData.Mob,
			questnetaQuestData.ID,
			questnetaQuestData.NameQuest,
			questnetaQuestData.LevelReq,
			questnetaQuestData.Mob,
			(GetQuestPoint())
		}
	end
end

-- WindUI compatibility layer. It keeps the original control declarations readable
-- while routing every tab, section and widget through WindUI.
local function staggerFeatureCallback(callback)
	if not callback then
		return nil
	end

	return function(...)
		local arguments = table.pack(...)

		if startupState.initializing then
			table.insert(startupState.callbackQueue, {
				callback = callback,
				arguments = arguments
			})
			return
		end

		task.spawn(function()
			local succeeded, callbackError = pcall(callback, table.unpack(arguments, 1, arguments.n))
			if not succeeded then
				warn("Mango Hub callback failed: " .. tostring(callbackError))
			end
		end)
	end
end

task.spawn(function()
	task.wait(0.75)

	while not startupState.registrationComplete or #startupState.callbackQueue > 0 do
		local queuedCallback = table.remove(startupState.callbackQueue, 1)

		if queuedCallback then
			local succeeded, callbackError = pcall(
				queuedCallback.callback,
				table.unpack(queuedCallback.arguments, 1, queuedCallback.arguments.n)
			)
			if not succeeded then
				warn("Mango Hub startup callback failed: " .. tostring(callbackError))
			end
			task.wait(0.075)
		else
			task.wait(0.05)
		end
	end

	restorePlayerMovement()
	startupState.initializing = false
end)

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local hubWindow = WindUI:CreateWindow({
	Title = "Mango Hub",
	Author = "Blox Fruits",
	Icon = "leaf",
	Folder = "MangoHub",
	Size = UDim2.fromOffset(650, 500),
	MinSize = Vector2.new(560, 350),
	Theme = "Dark",
	Transparent = true,
	Resizable = true,
	SideBarWidth = 190,
	HideSearchBar = false,
	ScrollBarEnabled = true
})
session.window = hubWindow

local function wrapTextElement(element)
	return {
		SetText = function(_, text)
			element:SetDesc(tostring(text))
		end,
		Destroy = function()
			element:Destroy()
		end
	}
end

local function wrapContainer(container)
	local wrapper = {}

	function wrapper:AddLeftGroupbox(title)
		return wrapContainer(container:Section({
			Title = title,
			Opened = true
		}))
	end

	function wrapper:AddLabel(text)
		local paragraph = container:Paragraph({
			Title = "",
			Desc = tostring(text or "")
		})
		return wrapTextElement(paragraph)
	end

	function wrapper:AddToggle(flag, options)
		return container:Toggle({
			Title = options.Text or flag,
			Value = options.Default == true,
			Flag = flag,
			Callback = staggerFeatureCallback(options.Callback)
		})
	end

	function wrapper:AddSlider(options)
		return container:Slider({
			Title = options.Text or "Slider",
			Value = {
				Min = options.Min or 0,
				Max = options.Max or 100,
				Default = options.Default or options.Min or 0
			},
			Step = options.Rounding == 0 and 1 or 10 ^ -(options.Rounding or 0),
			Callback = staggerFeatureCallback(options.Callback)
		})
	end

	function wrapper:AddDropdown(flag, options)
		return container:Dropdown({
			Title = options.Text or flag,
			Values = options.Values or {},
			Value = options.Default,
			Multi = options.Multi == true,
			AllowNone = options.AllowNull == true,
			Flag = flag,
			Callback = staggerFeatureCallback(options.Callback)
		})
	end

	function wrapper:AddButton(options)
		return container:Button({
			Title = options.Text or "Button",
			Callback = staggerFeatureCallback(options.Func or options.Callback)
		})
	end

	function wrapper:AddInput(flag, options)
		return container:Input({
			Title = options.Text or flag,
			Value = options.Default or "",
			Placeholder = options.Placeholder or "",
			Flag = flag,
			Callback = staggerFeatureCallback(options.Callback)
		})
	end

	return wrapper
end

local function createTab(title, icon)
	return wrapContainer(hubWindow:Tab({
		Title = title,
		Icon = icon
	}))
end

local tabs = {
	Info = createTab("Info And Status", "info"),
	Main = createTab("Farming", "sprout"),
	Settings = createTab("Setting", "settings"),
	Fish = createTab("Fishing", "fish"),
	Quests = createTab("Quest And Item", "scroll-text"),
	SeaEvent = createTab("Sea Event", "waves"),
	Race = createTab("Mirage And Race", "moon"),
	Prehistoric = createTab("Volcano Event", "mountain"),
	Esp = createTab("Stats And Esp", "eye"),
	Raids = createTab("Fruit And Raid", "cherry"),
	Combat = createTab("Local Player", "user"),
	Travel = createTab("Teleport", "map-pin"),
	Shop = createTab("Shopping", "shopping-cart"),
	Misc = createTab("Miscellaneous", "boxes")
}

do
	local timeZoneStatusLabel = tabs.Info:AddLeftGroupbox("Time Zone"):AddLabel("")

	UpdateOS = function()
		local dateParts = os.date("*t")
		local currentHour = dateParts.hour % 24
		local meridiem = currentHour < 12 and "AM" or "PM"
		local formattedTime = string.format("%02i:%02i:%02i %s", (currentHour - 1) % 12 + 1, dateParts.min, dateParts.sec, meridiem)
		local formattedDate = string.format("%02d/%02d/%04d", dateParts.day, dateParts.month, dateParts.year)
		local LocalizationService = game:GetService("LocalizationService")
		local LocalPlayer = game:GetService("Players").LocalPlayer
		local countryRegionCode

		if getgenv().countryRegionCode then
			countryRegionCode = getgenv().countryRegionCode
		else
			local ok

			ok, countryRegionCode = pcall(function()
				return LocalizationService:GetCountryRegionForPlayerAsync(LocalPlayer)
			end)

			if ok then
				getgenv().countryRegionCode = countryRegionCode
			else
				getgenv().countryRegionCode = "Unknown"
			end
		end

		timeZoneStatusLabel:SetText(formattedDate .. " - " .. formattedTime .. " [ " .. countryRegionCode .. " ]")
	end
end

spawn(function()
	while true do
		UpdateOS()
		wait(1)
	end
end)

do
	local gameTimeStatusLabel = tabs.Info:AddLeftGroupbox("Game Time"):AddLabel("")

	UpdateGameTime = function()
		local elapsedGameSeconds = math.floor(workspace.DistributedGameTime + 0.5)

		gameTimeStatusLabel:SetText(math.floor(elapsedGameSeconds / 3600) % 24 .. " Hour (h) " .. math.floor(elapsedGameSeconds / 60) % 60 .. " Minute (m) " .. elapsedGameSeconds % 60 .. " Second (s)")
	end
end

spawn(function()
	while true do
		UpdateGameTime()
		wait(1)
	end
end)

do
	local mirageIslandStatusLabel = tabs.Info:AddLeftGroupbox("Mirage Island"):AddLabel("Status: ")
	local previousStatus = ""

	spawn(function()
		pcall(function()
			while true do
				wait(1)

				local status = game.Workspace._WorldOrigin.Locations:FindFirstChild("Mirage Island") ~= nil and "✅" or "❌"

				if status ~= previousStatus then
					mirageIslandStatusLabel:SetText("Status: " .. status)
					previousStatus = status
				end
			end
		end)
	end)
end

do
	local kitsuneIslandStatusLabel = tabs.Info:AddLeftGroupbox("Kitsune Island"):AddLabel("Status: ")
	local previousStatusCandidate = ""

	spawn(function()
		while task.wait(1) do
			local status = game:GetService("Workspace").Map:FindFirstChild("KitsuneIsland") and "✅" or "❌"

			if status ~= previousStatusCandidate then
				kitsuneIslandStatusLabel:SetText("Status: " .. status)
				previousStatusCandidate = status
			end
		end
	end)
end

do
	local prehistoricIslandStatusLabel = tabs.Info:AddLeftGroupbox("Prehistoric Island"):AddLabel("Status: ")
	local previousStatusReference = ""

	task.spawn(function()
		while task.wait(1) do
			local status = game.Workspace._WorldOrigin.Locations:FindFirstChild("Prehistoric Island") and "✅" or "❌"

			if status ~= previousStatusReference then
				prehistoricIslandStatusLabel:SetText("Status: " .. status)
				previousStatusReference = status
			end
		end
	end)
end

do
	local frozenDimensionStatusLabel = tabs.Info:AddLeftGroupbox("Frozen Dimension"):AddLabel("Status: ")
	local previousStatusResponse = ""

	spawn(function()
		while wait(1) do
			local status = game.Workspace._WorldOrigin.Locations:FindFirstChild("Frozen Dimension") and "✅" or "❌"

			if status ~= previousStatusResponse then
				frozenDimensionStatusLabel:SetText("Status: " .. status)
				previousStatusResponse = status
			end
		end
	end)
end

do
	local cakePrinceStatusStatusLabel = tabs.Info:AddLeftGroupbox("Cake Prince Status"):AddLabel("")

	spawn(function()
		while wait(1) do
			local response = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CakePrinceSpawner")
			local previousStatusPayload = "Cake Prince: ✅"

			if string.len(response) >= 86 then
				previousStatusPayload = "Killed: " .. string.sub(response, 39, 41)
			end

			cakePrinceStatusStatusLabel:SetText(previousStatusPayload)
		end
	end)
end

do
	local ripIndraStatusLabel = tabs.Info:AddLeftGroupbox("Rip Indra"):AddLabel("Status: ")
	local previousStatusRecord = ""

	spawn(function()
		while wait(1) do
			local RipIndraTrueForm = game:GetService("ReplicatedStorage"):FindFirstChild("rip_indra True Form")

			RipIndraTrueForm = (RipIndraTrueForm or game:GetService("Workspace").Enemies:FindFirstChild("rip_indra")) and "✅"
			RipIndraTrueForm = RipIndraTrueForm or "❌"

			if RipIndraTrueForm ~= previousStatusRecord then
				ripIndraStatusLabel:SetText("Status: " .. RipIndraTrueForm)
				previousStatusRecord = RipIndraTrueForm
			end
		end
	end)
end

do
	local doughKingStatusLabel = tabs.Info:AddLeftGroupbox("Dough King"):AddLabel("Status: ")
	local previousStatusDetails = ""

	spawn(function()
		while wait(1) do
			local status = (game:GetService("ReplicatedStorage"):FindFirstChild("Dough King") or game:GetService("Workspace").Enemies:FindFirstChild("Dough King")) and "✅" or "❌"

			if status ~= previousStatusDetails then
				doughKingStatusLabel:SetText("Status: " .. status)
				previousStatusDetails = status
			end
		end
	end)
end

do
	local fullMoonStatusLabel = tabs.Info:AddLeftGroupbox("Full Moon"):AddLabel("")

	task.spawn(function()
		while task.wait(1) do
			local MoonTextureId = game:GetService("Lighting").Sky.MoonTextureId
			local previousStatusSnapshot = "Moon: 0/5"

			if MoonTextureId == "http://www.roblox.com/asset/?id=9709149431" then
				previousStatusSnapshot = "Moon: 5/5 (Full Moon) ✅"
			elseif MoonTextureId == "http://www.roblox.com/asset/?id=9709149052" then
				previousStatusSnapshot = "Moon: 4/5"
			elseif MoonTextureId == "http://www.roblox.com/asset/?id=9709143733" then
				previousStatusSnapshot = "Moon: 3/5"
			elseif MoonTextureId == "http://www.roblox.com/asset/?id=9709150401" then
				previousStatusSnapshot = "Moon: 2/5"
			elseif MoonTextureId == "http://www.roblox.com/asset/?id=9709149680" then
				previousStatusSnapshot = "Moon: 1/5"
			end

			fullMoonStatusLabel:SetText(previousStatusSnapshot)
		end
	end)
end

do
	local legendarySwordStatusLabel = tabs.Info:AddLeftGroupbox("Legendary Sword"):AddLabel("Status: ")

	spawn(function()
		while wait(1) do
			local previousStatusContext = "Not Found"

			if game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("LegendarySwordDealer", "1") then
				previousStatusContext = "Shisui ✅"
			elseif game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("LegendarySwordDealer", "2") then
				previousStatusContext = "Wando ✅"
			elseif game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("LegendarySwordDealer", "3") then
				previousStatusContext = "Saddi ✅"
			end

			legendarySwordStatusLabel:SetText(previousStatusContext)
		end
	end)
end

local boneStatusLabel = tabs.Info:AddLeftGroupbox("Bone"):AddLabel("")

GRP_Main_Select_Weapon = tabs.Main:AddLeftGroupbox("Select Weapon")
WeaponDropdown = GRP_Main_Select_Weapon:AddDropdown("Select_Weapon", {
	Text = "Select Weapon",
	Values = {
		"Melee",
		"Sword",
		"Blox Fruit",
		"Gun"
	},
	Default = "Melee",
	Callback = function(selectedWeaponType)
		_G.ChooseWP = selectedWeaponType
	end
})

do
	spawn(function()
		while task.wait(0.5) do
			pcall(function()
				if _G.ChooseWP == "Melee" then
					for _, child in pairs(plr.Backpack:GetChildren()) do
						if child.ToolTip == "Melee" then
							_G.SelectWeapon = child.Name
						end
					end
				elseif _G.ChooseWP == "Sword" then
					for _, child in pairs(plr.Backpack:GetChildren()) do
						if child.ToolTip == "Sword" then
							_G.SelectWeapon = child.Name
						end
					end
				elseif _G.ChooseWP == "Gun" then
					for _, child in pairs(plr.Backpack:GetChildren()) do
						if child.ToolTip == "Gun" then
							_G.SelectWeapon = child.Name
						end
					end
				elseif _G.ChooseWP == "Blox Fruit" then
					for _, child in pairs(plr.Backpack:GetChildren()) do
						if child.ToolTip == "Blox Fruit" then
							_G.SelectWeapon = child.Name
						end
					end
				end
			end)
		end
	end)
end

GRP_Main_Farming = tabs.Main:AddLeftGroupbox("Farming")
FarmLevel = GRP_Main_Farming:AddToggle("Auto_Farm_Level", {
	Text = "Auto Farm Level",
	Default = false,
	Callback = function(isAutoFarmLevelEnabled)
		_G.Level = isAutoFarmLevelEnabled

		if not isAutoFarmLevelEnabled then
			alreadyTeleported = false
			teleporting = false
		end
	end
})

do
	local isCallbackReadyPayload = false
	local isCallbackReadyItem = false

	_G.CheckQuestVisible = function(questTargetItem)
		local LocalPlayer = questTargetItem or game.Players.LocalPlayer
		local Quest = LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
		local TrackedQuestFrame = LocalPlayer.PlayerGui:FindFirstChild("TrackedQuestFrame")

		if Quest and Quest.Visible then
			local questTitleText = ""

			pcall(function()
				questTitleText = Quest.Container.QuestTitle.Title.Text
			end)

			return true, questTitleText
		end

		if TrackedQuestFrame then
			if TrackedQuestFrame.Enabled then
				local questTitleTextState = ""

				pcall(function()
					questTitleTextState = TrackedQuestFrame.Frame.header.textLabel.Text
				end)

				if questTitleTextState == "" then
					pcall(function()
						questTitleTextState = TrackedQuestFrame.Frame.header.textLabel.textLabel.Text
					end)
				end

				return true, questTitleTextState
			end
		end

		return false, ""
	end

	local function questvaluesecondaryQuestData()
		if not plr.Character then
			return false
		end

		local HumanoidRootPart = plr.Character:FindFirstChild("HumanoidRootPart")

		if not HumanoidRootPart then
			return false
		end

		if HumanoidRootPart.Position.Y < -1000 then
			return true
		end

		local vector3 = Vector3.new(10533.28, 0, 9940.48)

		return (Vector3.new(HumanoidRootPart.Position.X, 0, HumanoidRootPart.Position.Z) - vector3).Magnitude < 4500
	end
	local function playervalueyPlayerData(...)
		local Main = game.Players.LocalPlayer.PlayerGui:FindFirstChild("Main")

		if not Main then
			return nil
		end

		local playervalueyPlayerDataState = Main

		for _, playervalueaiPlayerData in ipairs({ ... }) do
			if playervalueyPlayerDataState then
				playervalueyPlayerDataState = playervalueyPlayerDataState:FindFirstChild(playervalueaiPlayerData)

				continue
			end

			return nil
		end

		return playervalueyPlayerDataState
	end
	local function questvaluetemporaryQuestDataState(...)
		if select("#", ...) == 1 and select(1, ...) == "Quest" then
			local TrackedQuestFrame = game.Players.LocalPlayer.PlayerGui:FindFirstChild("TrackedQuestFrame")

			if TrackedQuestFrame then
				local Frame = TrackedQuestFrame:FindFirstChild("Frame")

				if Frame then
					return TrackedQuestFrame.Enabled and Frame.Visible
				end
			end
		end

		local questvaluetemporaryQuestData = playervalueyPlayerData(...)

		return questvaluetemporaryQuestData ~= nil and questvaluetemporaryQuestData.Visible == true
	end
	local function questvaluelatestQuestData()
		local TrackedQuestFrame = game.Players.LocalPlayer.PlayerGui:FindFirstChild("TrackedQuestFrame")

		if TrackedQuestFrame then
			local Frame = TrackedQuestFrame:FindFirstChild("Frame")

			if Frame and Frame.Visible then
				local header = Frame:FindFirstChild("header")
				local textLabel = header and header:FindFirstChild("textLabel")

				if textLabel and textLabel:IsA("TextLabel") then
					return tostring(textLabel.Text)
				end
			end
		end

		local Quest = playervalueyPlayerData("Quest", "Container", "QuestTitle", "Title")

		if Quest then
			return tostring(Quest.Text)
		end

		return ""
	end
	local function questvaluenearbyQuestData(isEnabledVisible)
		if not isEnabledVisible then
			return false
		end

		if not questvaluetemporaryQuestDataState("Quest") then
			return false
		end

		local questvaluenearbyQuestDataState = questvaluelatestQuestData()

		if questvaluenearbyQuestDataState == "" then
			return false
		end

		return string.find(string.lower(questvaluenearbyQuestDataState), string.lower(isEnabledVisible), 1, true) ~= nil
	end
	local function questvalueavailableQuestData(valueArgumentComputed, valueArgumentUpdated, valueArgumentExpected)
		if questvaluenearbyQuestData(valueArgumentExpected) then
			return true
		end

		local CommF_ = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes") and game:GetService("ReplicatedStorage").Remotes:FindFirstChild("CommF_")

		if not CommF_ then
			return false
		end

		local function questvaluerequestedQuestDataData()
			return CommF_:InvokeServer("StartQuest", valueArgumentComputed, valueArgumentUpdated)
		end

		local ok = pcall(questvaluerequestedQuestDataData)

		if not ok then
			return false
		end

		local questvaluerequestedQuestDataEntry = os.clock() + 3

		repeat
			if questvaluenearbyQuestData(valueArgumentExpected) then
				return true
			end

			task.wait(0.25)
		until questvaluerequestedQuestDataEntry <= os.clock()

		return questvaluenearbyQuestData(valueArgumentExpected)
	end

	task.spawn(function()
		while task.wait(Sec) do
			if _G.Level then
				local exitTo

				repeat
					pcall(function()
						local Character = plr.Character or plr.CharacterAdded:Wait()
						local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

						if not HumanoidRootPart then
							return
						end

						local Value = plr.Data.Level.Value
						local questvaluerequestedQuestDataItem = questvaluesecondaryQuestData()

						questvaluetemporaryQuestDataState("Quest")
						questvaluelatestQuestData()

						if World3 and Value >= 2600 and not (questvaluerequestedQuestDataItem or isCallbackReadyItem or isCallbackReadyPayload) then
							isCallbackReadyItem = true

							local cFrame = CFrame.new(-16269.7041, 25.2288494, 1373.65955)
							local n2 = 0

							while true do
								task.wait(Sec)
								_tp(cFrame)
								n2 += 1

								if _G.Level then
									if (HumanoidRootPart.Position - cFrame.Position).Magnitude <= 8 or n2 > 20 then
										break
									end
								else
									break
								end
							end

							if not _G.Level then
								isCallbackReadyItem = false

								return
							end

							task.wait(1)
							pcall(function()
								game:GetService("ReplicatedStorage").Modules.Net:FindFirstChild("RF/SubmarineWorkerSpeak"):InvokeServer(unpack({ "TravelToSubmergedIsland" }))
							end)

							local now = tick()

							while true do
								task.wait(0.5)

								local questvaluerequestedMovementDataState = questvaluesecondaryQuestData()
								local targetPositionCached = (HumanoidRootPart.Position - cFrame.Position).Magnitude > 50

								if questvaluerequestedMovementDataState then
									break
								elseif targetPositionCached or not _G.Level or tick() - now > 15 then
									break
								end
							end

							task.wait(2)
							isCallbackReadyPayload = true
							isCallbackReadyItem = false
						elseif questvaluerequestedQuestDataItem or Value < 2600 or not World3 then
							isCallbackReadyPayload = true
							isCallbackReadyItem = false

							local questvaluerequestedQuestData = QuestNeta()

							if not questvaluerequestedQuestData or not questvaluerequestedQuestData[1] then
								task.wait(1)

								return
							end

							local Quest = questvaluetemporaryQuestDataState("Quest")

							if Quest then
								Quest = questvaluenearbyQuestData(questvaluerequestedQuestData[5] or questvaluerequestedQuestData[1])
							end

							if questvaluetemporaryQuestDataState("Quest") and not Quest then
								replicated.Remotes.CommF_:InvokeServer("AbandonQuest")
								task.wait(0.2)

								return
							end

							if not Quest then
								local questvaluerequestedQuestDataCandidate = questvaluerequestedQuestData[6]

								if questvaluerequestedQuestDataCandidate then
									_tp(questvaluerequestedQuestDataCandidate)
									task.wait(2)

									if (HumanoidRootPart.Position - questvaluerequestedQuestDataCandidate.Position).Magnitude <= 10 then
										questvalueavailableQuestData(questvaluerequestedQuestData[3], questvaluerequestedQuestData[2], questvaluerequestedQuestData[5] or questvaluerequestedQuestData[1])
									end
								else
									questvalueavailableQuestData(questvaluerequestedQuestData[3], questvaluerequestedQuestData[2], questvaluerequestedQuestData[5] or questvaluerequestedQuestData[1])
								end

								return
							end

							local questvaluerequestedMovementData = questvaluerequestedQuestData[1]
							local isQuestvaluerequestedReady = false
							local childInstancesRequested, childInstancesResolved, childInstancesStored = pairs(workspace.Enemies:GetChildren())
							local questvaluerequestedResultState = geniter(childInstancesRequested, childInstancesResolved, childInstancesStored)
							local exitTo
							local questvaluerequestedResult

							while true do
								local questvaluerequestedCallResultsState = table.pack(questvaluerequestedResultState())

								if not questvaluerequestedCallResultsState[1] then
									break
								end

								questvaluerequestedResult = questvaluerequestedCallResultsState[3]

								if string.find(questvaluerequestedResult.Name, questvaluerequestedMovementData) and playerCollectionLatest.Alive(questvaluerequestedResult) then
									exitTo = 1

									break
								end
							end

							if exitTo == 1 then
								isQuestvaluerequestedReady = true

								while true do
									task.wait(Sec)
									_tp(questvaluerequestedResult.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0))
									playerCollectionLatest.Kill(questvaluerequestedResult, _G.Level)

									if questvaluetemporaryQuestDataState("Quest") then
										if not _G.Level or not questvaluerequestedResult.Parent or questvaluerequestedResult.Humanoid.Health <= 0 then
											break
										end
									else
										break
									end
								end
							end

							if not isQuestvaluerequestedReady then
								local childInstancesComputed, childInstancesUpdated, childInstancesExpected = pairs(replicated:GetChildren())
								local questvaluerequestedQuestDataState = geniter(childInstancesComputed, childInstancesUpdated, childInstancesExpected)

								while true do
									local questvaluerequestedCallResults = table.pack(questvaluerequestedQuestDataState())

									if not questvaluerequestedCallResults[1] then
										break
									end

									local scriptMovementData = questvaluerequestedCallResults[3]

									if string.find(scriptMovementData.Name, questvaluerequestedMovementData) then
										if playerCollectionLatest.Alive(scriptMovementData) then
											isQuestvaluerequestedReady = true
											_tp(scriptMovementData.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0))

											break
										end
									end
								end
							end

							if not isQuestvaluerequestedReady then
								local childInstancesMatched, childInstancesTracked, childInstancesCreated = pairs(workspace._WorldOrigin.EnemySpawns:GetChildren())

								for _, playervalueaiPlayerData in childInstancesMatched, childInstancesTracked, childInstancesCreated do
									if string.find(playervalueaiPlayerData.Name, questvaluerequestedMovementData) then
										_tp(playervalueaiPlayerData.CFrame * CFrame.new(0, 20, 0))

										break
									end
								end
							end
						end
					end)
					exitTo = nil

					while task.wait(Sec) do
						if _G.Level then
							exitTo = 1

							break
						end

						isCallbackReadyItem = false
						isCallbackReadyPayload = false
					end
				until exitTo ~= 1

				return
			end

			isCallbackReadyItem = false
			isCallbackReadyPayload = false
		end
	end)
end

ClosetMons = GRP_Main_Farming:AddToggle("Auto_Farm_Nearest", {
	Text = "Auto Farm Nearest",
	Default = false,
	Callback = function(isAutoFarmNearestEnabled)
		_G.AutoFarmNear = isAutoFarmNearestEnabled
	end
})
spawn(function()
	if wait() then
		repeat
			pcall(function()
				if _G.AutoFarmNear then
					for _, child in pairs(workspace.Enemies:GetChildren()) do
						if (child:FindFirstChild("Humanoid") or child:FindFirstChild("HumanoidRootPart")) and child.Humanoid.Health > 0 then
							while true do
								wait()
								playerCollectionLatest.Kill(child, _G.AutoFarmNear)

								if _G.AutoFarmNear then
									if not child.Parent or child.Humanoid.Health <= 0 then
										break
									end
								else
									break
								end
							end
						end
					end
				end
			end)
		until not wait()
	end
end)
FactoryRaids = GRP_Main_Farming:AddToggle("Auto_Factory_Raid", {
	Text = "Auto Factory Raid",
	Default = false,
	Callback = function(isAutoFactoryRaidEnabled)
		_G.AutoFactory = isAutoFactoryRaidEnabled
	end
})
spawn(function()
	while wait(Sec) do
		pcall(function()
			if _G.AutoFactory then
				local Core = GetConnectionEnemies("Core")

				if Core then
					while true do
						wait()
						EquipWeapon(_G.SelectWeapon)
						_tp(CFrame.new(448.46756, 199.356781, -441.389252))

						if Core.Humanoid.Health <= 0 then
							break
						elseif _G.AutoFactory == false then
							break
						end
					end
				else
					_tp(CFrame.new(448.46756, 199.356781, -441.389252))
				end
			end
		end)
	end
end)

do
	CastleRaids = GRP_Main_Farming:AddToggle("Auto_Pirate_Raid", {
		Text = "Auto Pirate Raid",
		Default = false,
		Callback = function(isAutoPirateRaidEnabled)
			_G.AutoRaidCastle = isAutoPirateRaidEnabled
		end
	})
end

do
	spawn(function()
		while wait(Sec) do
			if _G.AutoRaidCastle then
				pcall(function()
					local cFrame = CFrame.new(-5496.17432, 313.768921, -2841.53027, 0.924894512, 7.37058015e-09, 0.380223751, 3.5881019e-08, 1, -1.06665446e-07, -0.380223751, 1.12297109e-07, 0.924894512)

					if (CFrame.new(-5539.3115234375, 313.800537109375, -2972.372314453125).Position - Root.Position).Magnitude <= 500 then
						for _, child in pairs(workspace.Enemies:GetChildren()) do
							if child:FindFirstChild("HumanoidRootPart") and child:FindFirstChild("Humanoid") and child.Humanoid.Health > 0 and child.Name and (child.HumanoidRootPart.Position - Root.Position).Magnitude <= 2000 then
								while true do
									wait()
									playerCollectionLatest.Kill(child, _G.AutoRaidCastle)

									if _G.AutoRaidCastle and child.Parent and not (child.Humanoid.Health <= 0) then
										if not workspace.Enemies:FindFirstChild(child.Name) then
											break
										end
									else
										break
									end
								end
							end
						end
					else
						local callbackEntriesData = {
							"Galley Pirate",
							"Galley Captain",
							"Raider",
							"Mercenary",
							"Vampire",
							"Zombie",
							"Snow Trooper",
							"Winter Warrior",
							"Lab Subordinate",
							"Horned Warrior",
							"Magma Ninja",
							"Lava Pirate",
							"Ship Deckhand",
							"Ship Engineer",
							"Ship Steward",
							"Ship Officer",
							"Arctic Warrior",
							"Snow Lurker",
							"Sea Soldier",
							"Water Fighter"
						}

						for i = 1, #callbackEntriesData do
							if replicated:FindFirstChild(callbackEntriesData[i]) then
								for _, child in pairs(replicated:GetChildren()) do
									if table.find(callbackEntriesData, child.Name) then
										_tp(cFrame)
									end
								end
							end
						end
					end
				end)
			end
		end
	end)
end

Ecto = GRP_Main_Farming:AddToggle("Auto_Farm_Ectoplasm", {
	Text = "Auto Farm Ectoplasm",
	Default = false,
	Callback = function(isAutoFarmEctoplasmEnabled)
		_G.AutoEctoplasm = isAutoFarmEctoplasmEnabled
	end
})
spawn(function()
	while wait(Sec) do
		pcall(function()
			if _G.AutoEctoplasm then
				local callbackResultOutput = GetConnectionEnemies({
					"Ship Deckhand",
					"Ship Engineer",
					"Ship Steward",
					"Ship Officer",
					"Arctic Warrior"
				})

				if playerCollectionLatest.Alive(callbackResultOutput) then
					while true do
						wait()
						playerCollectionLatest.Kill(callbackResultOutput, _G.AutoEctoplasm)

						if _G.AutoEctoplasm then
							if not callbackResultOutput.Parent or callbackResultOutput.Humanoid.Health <= 0 then
								break
							end
						else
							break
						end
					end
				else
					replicated.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
				end
			end
		end)
	end
end)
GRP_Main_Chest = tabs.Main:AddLeftGroupbox("Chest")

do
	ChestTW = GRP_Main_Chest:AddToggle("Auto_Farm_Chest", {
		Text = "Auto Farm Chest",
		Default = false,
		Callback = function(isAutoFarmChestEnabled)
			_G.AutoFarmChest = isAutoFarmChestEnabled
		end
	})
end

spawn(function()
	while wait(Sec) do
		if _G.AutoFarmChest then
			pcall(function()
				local CollectionService = game:GetService("CollectionService")
				local LocalPlayer = game:GetService("Players").LocalPlayer
				local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

				if not Character then
					return
				end

				local Position = Character:GetPivot().Position
				local tagged = CollectionService:GetTagged("_ChestTagged")
				local huge = math.huge
				local callbackPlayerData

				for i = 1, #tagged do
					local callbackPlayerDataState = tagged[i]
					local Magnitude = (callbackPlayerDataState:GetPivot().Position - Position).Magnitude

					if (not SelectedIsland or callbackPlayerDataState:IsDescendantOf(SelectedIsland)) and not callbackPlayerDataState:GetAttribute("IsDisabled") and Magnitude < huge then
						huge = Magnitude
						callbackPlayerData = callbackPlayerDataState
					end
				end

				if callbackPlayerData then
					_tp(callbackPlayerData:GetPivot())
				end
			end)
		end
	end
end)

do
	ChestBP = GRP_Main_Chest:AddToggle("Auto_Chest_Bypass", {
		Text = "Auto Chest Bypass",
		Default = false,
		Callback = function(isAutoChestBypassEnabled)
			_G.AutoChestBP = isAutoChestBypassEnabled

			if isAutoChestBypassEnabled then
				local LocalPlayer = game:GetService("Players").LocalPlayer
				local isCallbackReadyCandidate = false
				local playerCollectionCurrent = {}
				local isCallbackReadyReference = true

				local function playervalueacPlayerData()
					if not LocalPlayer.Character then
						LocalPlayer.CharacterAdded:Wait()
					end

					LocalPlayer.Character:WaitForChild("HumanoidRootPart")

					return LocalPlayer.Character
				end
				local function playervalueadPlayerData()
					if isCallbackReadyReference then
						isCallbackReadyReference = false

						for _, descendant in pairs(game:GetDescendants()) do
							if descendant.Name:find("Chest") and descendant.ClassName == "Part" then
								table.insert(playerCollectionCurrent, descendant)
							end
						end
					end

					local playervalueadEntries = {}

					for _, playervalueaiPlayerData in pairs(playerCollectionCurrent) do
						if playervalueaiPlayerData:FindFirstChild("TouchInterest") then
							table.insert(playervalueadEntries, playervalueaiPlayerData)
						end
					end

					local LowerTorso = playervalueacPlayerData().LowerTorso

					table.sort(playervalueadEntries, function(valueArgumentMatched, valueArgumentTracked)
						return (LowerTorso.Position - valueArgumentMatched.Position).Magnitude < (LowerTorso.Position - valueArgumentTracked.Position).Magnitude
					end)

					return playervalueadEntries
				end
				local function playervalueaePlayerData()
					if isCallbackReadyCandidate then
						return
					end

					isCallbackReadyCandidate = true
					task.spawn(function()
						while _G.AutoChestBP do
							if not LocalPlayer.Character or not LocalPlayer.Character.Parent then
								break
							end

							local playervalueaePlayerDataState = playervalueadPlayerData()

							if #playervalueaePlayerDataState > 0 then
								playervalueacPlayerData().HumanoidRootPart.CFrame = playervalueaePlayerDataState[1].CFrame
							end

							task.wait(0.1)
						end

						isCallbackReadyCandidate = false
					end)
				end

				connectScoped(LocalPlayer.CharacterAdded, function()
					playervalueacPlayerData()
					task.wait(0.5)

					if _G.AutoChestBP then
						playervalueaePlayerData()
					end
				end)
				playervalueaePlayerData()
			end
		end
	})
end

do
	StopI = GRP_Main_Chest:AddToggle("Stop_Items", {
		Text = "Stop Items",
		Default = true,
		Callback = function(isStopItemsEnabled)
			_G.StopWhenChalice = isStopItemsEnabled
		end
	})
end

do
	spawn(function()
		while wait(0.2) do
			if _G.StopWhenChalice and (_G.AutoFarmChest or _G.AutoChestBP) then
				local exitTo

				repeat
					pcall(function()
						if GetBP("God's Chalice") or GetBP("Sweet Chalice") then
							_G.AutoFarmChest = false
							_G.AutoChestBP = false
						elseif GetBP("Fist of Darkness") then
							_G.AutoFarmChest = false
							_G.AutoChestBP = false

							return
						end
					end)
					exitTo = nil

					while wait(0.2) do
						if _G.StopWhenChalice and (_G.AutoFarmChest or _G.AutoChestBP) then
							exitTo = 1

							break
						end
					end
				until exitTo ~= 1

				return
			end
		end
	end)
end

GRP_Main_Collect_Berry = tabs.Main:AddLeftGroupbox("Collect Berry")
Berry = GRP_Main_Collect_Berry:AddToggle("Auto_Farm_Berry", {
	Text = "Auto Farm Berry",
	Default = false,
	Callback = function(isAutoFarmBerryEnabled)
		_G.AutoBerry = isAutoFarmBerryEnabled
	end
})
spawn(function()
	while wait(Sec) do
		if _G.AutoBerry then
			local CollectionService = game:GetService("CollectionService")
			local LocalPlayer = game:GetService("Players").LocalPlayer
			local tagged = CollectionService:GetTagged("BerryBush")
			local n3 = 1
			local callbackPlayerDataEntry = #tagged

			if true then
				if n3 <= callbackPlayerDataEntry then
					-- (could not be recovered)
				end

				continue
			end

			if n3 >= callbackPlayerDataEntry then
				-- (could not be recovered)
			end
		end
	end
end)
BerryH = GRP_Main_Collect_Berry:AddToggle("Auto_Farm_Berry_+_Hop", {
	Text = "Auto Farm Berry + Hop",
	Default = false,
	Callback = function(isAutoFarmBerryHopEnabled)
		_G.AutoBerryH = isAutoFarmBerryHopEnabled
	end
})

do
	spawn(function()
		while wait(Sec) do
			if _G.AutoBerryH then
				local CollectionService = game:GetService("CollectionService")
				local LocalPlayer = game:GetService("Players").LocalPlayer
				local tagged = CollectionService:GetTagged("BerryBush")

				if #tagged == 0 then
					local TeleportService_ = game:GetService("TeleportService")
					local playerCollectionCached = {}
					local ok = pcall(function()
						playerCollectionCached = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/playervalueaiPlayerData/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
					end)

					if ok then
						if playerCollectionCached.data then
							for _, playervalueaiPlayerData in pairs(playerCollectionCached.data) do
								if playervalueaiPlayerData.playing < playervalueaiPlayerData.maxPlayers and playervalueaiPlayerData.id ~= game.JobId then
									TeleportService_:TeleportToPlaceInstance(game.PlaceId, playervalueaiPlayerData.id, LocalPlayer)

									break
								end
							end
						end
					end
				else
					for i = 1, #tagged do
						local callbackPlayerDataItem = tagged[i]

						for _, playervalueaiPlayerData in pairs(callbackPlayerDataItem:GetAttributes()) do
							if not BerryArray or table.find(BerryArray, playervalueaiPlayerData) then
								_tp(callbackPlayerDataItem.Parent:GetPivot())

								for i2 = 1, #tagged do
									for _, child in pairs(tagged[i2]:GetChildren()) do
										if not BerryArray or table.find(BerryArray, child.Name) then
											_tp(child.WorldPivot)
											fireproximityprompt(child.ProximityPrompt, math.huge)
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end)
end

GRP_Main_Farm_Mob = tabs.Main:AddLeftGroupbox("Farm Mob")

do
	if World1 then
		GRP_Main_Farm_Mob:AddDropdown("Select_Mob", {
			Text = "Select Mob",
			Values = {
				"Bandit",
				"Monkey",
				"Gorilla",
				"Pirate",
				"Brute",
				"Desert Bandit",
				"Desert Officer",
				"Snow Bandit",
				"Snowman",
				"Chief Petty Officer",
				"Sky Bandit",
				"Dark Master",
				"Toga Warrior",
				"Gladiator",
				"Military Soldier",
				"Military Spy",
				"Fishman Warrior",
				"Fishman Commando",
				"God's Guard",
				"Shanda",
				"Royal Squad",
				"Royal Soldier",
				"Galley Pirate",
				"Galley Captain"
			},
			Default = 1,
			Callback = function(isSelectmobEnabled)
				getgenv().SelectMob = isSelectmobEnabled
			end
		})
	end
end

if World2 then
	GRP_Main_Farm_Mob:AddDropdown("Select_Mob", {
		Text = "Select Mob",
		Values = {
			"Raider",
			"Mercenary",
			"Swan Pirate",
			"Factory Staff",
			"Marine Lieutenant",
			"Marine Captain",
			"Zombie",
			"Vampire",
			"Snow Trooper",
			"Winter Warrior",
			"Lab Subordinate",
			"Horned Warrior",
			"Magma Ninja",
			"Lava Pirate",
			"Ship Deckhand",
			"Ship Engineer",
			"Ship Steward",
			"Ship Officer",
			"Arctic Warrior",
			"Snow Lurker",
			"Sea Soldier",
			"Water Fighter"
		},
		Default = 1,
		Callback = function(isSelectmobEnabledState)
			getgenv().SelectMob = isSelectmobEnabledState
		end
	})
end

do
	if World3 then
		GRP_Main_Farm_Mob:AddDropdown("Select_Mob", {
			Text = "Select Mob",
			Values = {
				"Pirate Millionaire",
				"Dragon Crew Warrior",
				"Dragon Crew Archer",
				"Female Islander",
				"Giant Islander",
				"Marine Commodore",
				"Marine Rear Admiral",
				"Fishman Raider",
				"Fishman Captain",
				"Forest Pirate",
				"Mythological Pirate",
				"Jungle Pirate",
				"Musketeer Pirate",
				"Reborn Skeleton",
				"Living Zombie",
				"Demonic Soul",
				"Posessed Mummy",
				"Peanut Scout",
				"Peanut President",
				"Ice Cream Chef",
				"Ice Cream Commander",
				"Cookie Crafter",
				"Cake Guard",
				"Baking Staff",
				"Head Baker",
				"Cocoa Warrior",
				"Chocolate Bar Battler",
				"Sweet Thief",
				"Candy Rebel",
				"Candy Pirate",
				"Snow Demon",
				"Isle Outlaw",
				"Island Boy",
				"Sun-kissed Warrior",
				"Isle Champion"
			},
			Default = 1,
			Callback = function(isAutoKillMobEnabled)
				getgenv().SelectMob = isAutoKillMobEnabled
			end
		})
	end
end

GRP_Main_Farm_Mob:AddToggle("Auto_Kill_Mob", {
	Text = "Auto Kill Mob",
	Default = false,
	Callback = function(isAutoKillMobEnabledCurrent)
		_G.AutoKillMob = isAutoKillMobEnabledCurrent
	end
})

do
	spawn(function()
		while wait() do
			if _G.AutoKillMob then
				pcall(function()
					if game:GetService("Workspace").Enemies:FindFirstChild(getgenv().SelectMob) then
						for _, child in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
							if child.Name == getgenv().SelectMob and child:FindFirstChild("Humanoid") and child:FindFirstChild("HumanoidRootPart") and child.Humanoid.Health > 0 then
								while true do
									game:GetService("RunService").Heartbeat:Wait()
									playerCollectionLatest.Kill(child, _G.AutoKillMob)

									if _G.AutoKillMob then
										if not child.Parent or child.Humanoid.Health <= 0 then
											break
										end
									else
										break
									end
								end
							end
						end
					end
				end)
			end
		end
	end)
end

GRP_Main_Farm_All_Island = tabs.Main:AddLeftGroupbox("Farm All Island")

do
	local locationDataCurrent = {
		Pirates = {
			CFrame = CFrame.new(-2709.67944, 24.5206585, 2104.24585, -0.744724929, -3.97967455e-08, -0.667371571, 4.32403588e-08, 1, -1.07884304e-07, 0.667371571, -1.09201515e-07, -0.744724929),
			Mobs = { "Bandit" }
		},
		Marine = {
			CFrame = CFrame.new(-2709.67944, 24.5206585, 2104.24585, -0.744724929, -3.97967455e-08, -0.667371571, 4.32403588e-08, 1, -1.07884304e-07, 0.667371571, -1.09201515e-07, -0.744724929),
			Mobs = { "Trainee" }
		},
		Jungle = {
			CFrame = CFrame.new(-1600, 36, 150),
			Mobs = {
				"Monkey",
				"Gorilla"
			}
		},
		["Pirate Village"] = {
			CFrame = CFrame.new(-1100, 4, 3850),
			Mobs = {
				"Pirate",
				"Brute"
			}
		},
		Desert = {
			CFrame = CFrame.new(1090, 7, 4370),
			Mobs = {
				"Desert Bandit",
				"Desert Officer"
			}
		},
		["Frozen Village"] = {
			CFrame = CFrame.new(1200, 28, -1500),
			Mobs = {
				"Snow Bandit",
				"Snowman"
			}
		},
		["Marine Fortress"] = {
			CFrame = CFrame.new(-4500, 20, 4250),
			Mobs = { "Chief Petty Officer" }
		},
		["Skylands Lower"] = {
			CFrame = CFrame.new(-5000, 700, -2500),
			Mobs = {
				"Sky Bandit",
				"Dark Master"
			}
		},
		Prison = {
			CFrame = CFrame.new(4875, 6, 735),
			Mobs = {
				"Prisoner",
				"Dangerous Prisoner"
			}
		},
		Colosseum = {
			CFrame = CFrame.new(-1500, 60, -290),
			Mobs = {
				"Toga Warrior",
				"Gladiator"
			}
		},
		["Magma Village"] = {
			CFrame = CFrame.new(-5200, 8, 8400),
			Mobs = {
				"Military Soldier",
				"Military Spy"
			}
		},
		["Underwater City"] = {
			CFrame = CFrame.new(61160, 5, 1819),
			Mobs = {
				"Fishman Warrior",
				"Fishman Commando"
			}
		},
		["Skylands Upper"] = {
			CFrame = CFrame.new(-7880, 5545, -380),
			Mobs = {
				"Shanda",
				"Royal Squad",
				"Royal Soldier"
			}
		}
	}
	local locationDataCached = {
		["Kingdom of Rose"] = {
			CFrame = CFrame.new(-321, 73, 297),
			Mobs = {
				"Raider",
				"Mercenary",
				"Swan Pirate",
				"Factory Staff"
			}
		},
		["Green Zone"] = {
			CFrame = CFrame.new(-2447, 73, -3211),
			Mobs = {
				"Marine Lieutenant",
				"Marine Captain"
			}
		},
		["Graveyard Island"] = {
			CFrame = CFrame.new(-9515, 142, 5536),
			Mobs = {
				"Zombie",
				"Vampire"
			}
		},
		["Snow Mountain"] = {
			CFrame = CFrame.new(561, 401, -5306),
			Mobs = {
				"Snow Trooper",
				"Winter Warrior"
			}
		},
		["Hot and Cold (Cold)"] = {
			CFrame = CFrame.new(-6026, 15, -5062),
			Mobs = {
				"Lab Subordinate",
				"Horned Warrior"
			}
		},
		["Hot and Cold (Hot)"] = {
			CFrame = CFrame.new(-5478, 15, -5240),
			Mobs = {
				"Magma Ninja",
				"Lava Pirate"
			}
		},
		["Cursed Ship"] = {
			CFrame = CFrame.new(902, 126, 33071),
			Mobs = {
				"Ship Deckhand",
				"Ship Engineer",
				"Ship Steward",
				"Ship Officer"
			}
		},
		["Ice Castle"] = {
			CFrame = CFrame.new(6137, 294, -6747),
			Mobs = {
				"Arctic Warrior",
				"Snow Lurker"
			}
		},
		["Forgotten Island"] = {
			CFrame = CFrame.new(-3043, 238, -10191),
			Mobs = {
				"Sea Soldier",
				"Water Fighter"
			}
		}
	}
	local locationDataSelected = {
		["Port Town"] = {
			CFrame = CFrame.new(-290, 44, 5450),
			Mobs = {
				"Pirate Millionaire",
				"Pistol Billionaire"
			}
		},
		["Hydra Island"] = {
			CFrame = CFrame.new(5228, 604, 345),
			Mobs = {
				"Dragon Crew Warrior",
				"Dragon Crew Archer",
				"Female Islander",
				"Giant Islander",
				"Training Dummy"
			}
		},
		["Great Tree"] = {
			CFrame = CFrame.new(2682, 1682, -7190),
			Mobs = {
				"Marine Commodore",
				"Marine Rear Admiral"
			}
		},
		["Floating Turtle"] = {
			CFrame = CFrame.new(-12000, 331, -8500),
			Mobs = {
				"Forest Pirate",
				"Mythological Pirate",
				"Jungle Pirate",
				"Musketeer Pirate",
				"Fishman Raider",
				"Fishman Captain"
			}
		},
		["Haunted Castle"] = {
			CFrame = CFrame.new(-9515, 142, 5536),
			Mobs = {
				"Reborn Skeleton",
				"Living Zombie",
				"Demonic Soul",
				"Posessed Mummy"
			}
		},
		["Sea of Treats"] = {
			CFrame = CFrame.new(-1145, 13, -14450),
			Mobs = {
				"Peanut Scout",
				"Peanut President",
				"Ice Cream Commander",
				"Cookie Crafter",
				"Cake Guard",
				"Baking Staff",
				"Head Baker",
				"Cocoa Warrior",
				"Chocolate Bar Battler",
				"Sweet Thief",
				"Candy Rebel"
			}
		},
		["Tiki Outpost"] = {
			CFrame = CFrame.new(-16200, 90, -17300),
			Mobs = {
				"Isle Outlaw",
				"Island Boy",
				"Sun-kissed Warrior",
				"Isle Champion"
			}
		},
		["Submerged Island"] = {
			CFrame = CFrame.new(-3200, -10, -10000),
			Mobs = {
				"Reef Bandit",
				"Coral Pirate",
				"Sea Chanter",
				"Ocean Prophet",
				"High Disciple",
				"Grand Devotee"
			}
		}
	}

	if World1 then
		GRP_Main_Farm_All_Island:AddDropdown("Select_Island", {
			Text = "Select Island",
			Values = {
				"Pirates",
				"Marine",
				"Jungle",
				"Pirate Village",
				"Desert",
				"Frozen Village",
				"Marine Fortress",
				"Skylands Lower",
				"Prison",
				"Colosseum",
				"Magma Village",
				"Underwater City",
				"Skylands Upper"
			},
			Default = 1,
			Callback = function(selectedSelectIsland)
				_G.SelectIsland = selectedSelectIsland
			end
		})
	end

	if World2 then
		GRP_Main_Farm_All_Island:AddDropdown("Select_Island", {
			Text = "Select Island",
			Values = {
				"Kingdom of Rose",
				"Green Zone",
				"Graveyard Island",
				"Snow Mountain",
				"Hot and Cold (Cold)",
				"Hot and Cold (Hot)",
				"Cursed Ship",
				"Ice Castle",
				"Forgotten Island"
			},
			Default = 1,
			Callback = function(selectedSelectIslandCurrent)
				_G.SelectIsland = selectedSelectIslandCurrent
			end
		})
	end

	if World3 then
		GRP_Main_Farm_All_Island:AddDropdown("Select_Island", {
			Text = "Select Island",
			Values = {
				"Port Town",
				"Hydra Island",
				"Great Tree",
				"Floating Turtle",
				"Haunted Castle",
				"Sea of Treats",
				"Tiki Outpost",
				"Submerged Island"
			},
			Default = 1,
			Callback = function(selectedSelectisland)
				_G.SelectIsland = selectedSelectisland
			end
		})
	end

	local callbackResultSelection

	if World1 then
		callbackResultSelection = locationDataCurrent
	elseif World2 then
		callbackResultSelection = locationDataCached
	elseif World3 then
		callbackResultSelection = locationDataSelected
	end

	GRP_Main_Farm_All_Island:AddToggle("Auto_Farm_All_Island", {
		Text = "Auto Farm All Island",
		Default = false,
		Callback = function(isAutoFarmAllIslandEnabled)
			_G.AutoFarmIsland = isAutoFarmAllIslandEnabled
		end
	})
	task.spawn(function()
		while task.wait(0.2) do
			if _G.AutoFarmIsland and _G.SelectIsland and callbackResultSelection then
				local callbackEnemyData = callbackResultSelection[_G.SelectIsland]

				if callbackEnemyData then
					local CFrame_ = callbackEnemyData.CFrame
					local locationDataActive = {}

					for _, mob in ipairs(callbackEnemyData.Mobs) do
						locationDataActive[mob] = true
					end

					local isCallbackReady = false

					for _, child in pairs(workspace.Enemies:GetChildren()) do
						if locationDataActive[child.Name] then
							if child:FindFirstChild("Humanoid") then
								if child:FindFirstChild("HumanoidRootPart") and child.Humanoid.Health > 0 then
									isCallbackReady = true

									while true do
										task.wait()
										_tp(child.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0))
										playerCollectionLatest.Kill(child, true)

										if not _G.AutoFarmIsland then
											break
										end

										if child.Parent then
											if not (child.Humanoid.Health <= 0) then
												continue
											end
										end

										break
									end
								end
							end
						end
					end

					if not isCallbackReady then
						_tp(CFrame_)
					end
				end
			end
		end
	end)
end

GRP_Main_Farm_Elite_Hunter = tabs.Main:AddLeftGroupbox("Farm Elite Hunter")

do
	local eliteProgressStatusLabel = GRP_Main_Farm_Elite_Hunter:AddLabel("Elite Progress : 0")

	spawn(function()
		while wait(Sec) do
			pcall(function()
				eliteProgressStatusLabel:SetText("Elite Progress : " .. replicated.Remotes.CommF_:InvokeServer("EliteHunter", "Progress"))
			end)
		end
	end)
end

do
	local statusNotFoundStatusLabel = GRP_Main_Farm_Elite_Hunter:AddLabel("Status: Not Found")

	spawn(function()
		local previousStatusState = ""

		while wait(1) do
			local replicatedstorageService = (game:GetService("ReplicatedStorage"):FindFirstChild("Diablo") or game:GetService("ReplicatedStorage"):FindFirstChild("Deandre") or game:GetService("ReplicatedStorage"):FindFirstChild("Urban") or game:GetService("Workspace").Enemies:FindFirstChild("Diablo") or game:GetService("Workspace").Enemies:FindFirstChild("Deandre") or game:GetService("Workspace").Enemies:FindFirstChild("Urban")) and "✅" or "❌"
			local response = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EliteHunter", "Progress")

			if replicatedstorageService ~= previousStatusState then
				statusNotFoundStatusLabel:SetText("Status: " .. replicatedstorageService .. " | Killed: " .. tostring(response or 0))
				previousStatusState = replicatedstorageService
			end
		end
	end)
end

do
	EliteQ = GRP_Main_Farm_Elite_Hunter:AddToggle("Auto_Farm_Elite", {
		Text = "Auto Farm Elite",
		Default = false,
		Callback = function(isAutoFarmEliteEnabled)
			_G.FarmEliteHunt = isAutoFarmEliteEnabled
		end
	})
end

do
	spawn(function()
		while wait(1) do
			pcall(function()
				if _G.FarmEliteHunt then
					local Quest = plr.PlayerGui.Main.Quest
					local Text = Quest.Container.QuestTitle.Title.Text

					if Quest.Visible then
						local callbackQuestDataDetails
						local callbackQuestDataCallbackState, callbackQuestDataEntry, callbackQuestDataSource = pairs({
							"Diablo",
							"Urban",
							"Deandre"
						})
						local callbackQuestDataSelection = geniter(callbackQuestDataCallbackState, callbackQuestDataEntry, callbackQuestDataSource)

						while true do
							local callbackCallResultsState = table.pack(callbackQuestDataSelection())

							if not callbackCallResultsState[1] then
								break
							end

							local callbackResultOption = callbackCallResultsState[3]

							if string.find(Text, callbackResultOption) then
								callbackQuestDataDetails = callbackResultOption

								break
							end
						end

						if callbackQuestDataDetails then
							local callbackResultRecord
							local childInstancesReturned, childInstancesProcessed, childInstancesFiltered = pairs(replicated:GetChildren())
							local callbackResultTarget = geniter(childInstancesReturned, childInstancesProcessed, childInstancesFiltered)

							while true do
								local callbackCallResults = table.pack(callbackResultTarget())

								if not callbackCallResults[1] then
									break
								end

								local callbackResultContext = callbackCallResults[3]

								if callbackResultContext.Name == callbackQuestDataDetails and callbackResultContext:FindFirstChild("HumanoidRootPart") then
									callbackResultRecord = callbackResultContext

									break
								end
							end

							local childInstancesValidated, childInstancesPrepared, childInstancesAssigned = pairs(Enemies:GetChildren())

							for _, playervalueaiPlayerData in childInstancesValidated, childInstancesPrepared, childInstancesAssigned do
								if playervalueaiPlayerData.Name == callbackQuestDataDetails and playerCollectionLatest.Alive(playervalueaiPlayerData) then
									callbackResultRecord = playervalueaiPlayerData

									break
								end
							end

							if callbackResultRecord and callbackResultRecord:FindFirstChild("HumanoidRootPart") then
								_tp(callbackResultRecord.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))

								while true do
									wait()
									playerCollectionLatest.Kill(callbackResultRecord, _G.FarmEliteHunt)

									if _G.FarmEliteHunt then
										if not callbackResultRecord.Parent or callbackResultRecord.Humanoid.Health <= 0 or not Quest.Visible then
											break
										end
									else
										break
									end
								end
							else
								wait(5)
							end
						else
							replicated.Remotes.CommF_:InvokeServer("AbandonQuest")
						end
					else
						local response = replicated.Remotes.CommF_:InvokeServer("EliteHunter")

						if response == nil or string.find(response, "Cooldown") then
							wait(10)

							return
						end

						task.wait(1)
					end
				end
			end)
		end
	end)
end

do
	EliteH = GRP_Main_Farm_Elite_Hunter:AddToggle("Auto_Farm_Elite_+_Hop", {
		Text = "Auto Farm Elite + Hop",
		Default = false,
		Callback = function(isAutoFarmEliteHopEnabled)
			_G.FarmEliteH = isAutoFarmEliteHopEnabled
		end
	})
end

do
	local function resultassignedResultData()
		local HttpService = game:GetService("HttpService")
		local TeleportService_ = game:GetService("TeleportService")
		local questTitleTextData = ""
		local isResultassignedReady = false

		repeat
			local ok, resultassignedResult = pcall(function()
				return game:HttpGet("https://games.roblox.com/playervalueaiPlayerData/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100&cursor=" .. questTitleTextData)
			end)

			if ok and resultassignedResult then
				local data = HttpService:JSONDecode(resultassignedResult)

				if data.data then
					for _, playervalueaiPlayerData in pairs(data.data) do
						if playervalueaiPlayerData.playing < playervalueaiPlayerData.maxPlayers and playervalueaiPlayerData.id ~= game.JobId then
							isResultassignedReady = true
							TeleportService_:TeleportToPlaceInstance(game.PlaceId, playervalueaiPlayerData.id)

							break
						end
					end

					questTitleTextData = data.nextPageCursor or ""
				end
			end
		until not questTitleTextData or isResultassignedReady
	end

	spawn(function()
		if task.wait(1) then
			repeat
				pcall(function()
					if _G.FarmEliteH then
						local Quest = plr.PlayerGui.Main.Quest
						local Text = Quest.Container.QuestTitle.Title.Text

						if Quest.Visible then
							local resultassignedQuestDataData
							local resultassignedQuestDataItem, resultassignedQuestDataEntry, resultassignedQuestData = pairs({
								"Diablo",
								"Urban",
								"Deandre"
							})
							local resultassignedQuestDataState = geniter(resultassignedQuestDataItem, resultassignedQuestDataEntry, resultassignedQuestData)

							while true do
								local resultassignedCallResultsState = table.pack(resultassignedQuestDataState())

								if not resultassignedCallResultsState[1] then
									break
								end

								local resultassignedResultCandidate = resultassignedCallResultsState[3]

								if string.find(Text, resultassignedResultCandidate) then
									resultassignedQuestDataData = resultassignedResultCandidate

									break
								end
							end

							if resultassignedQuestDataData then
								local resultassignedResultState
								local childInstancesDetected, childInstancesCollected, childInstancesA = pairs(replicated:GetChildren())
								local resultassignedResultEntry = geniter(childInstancesDetected, childInstancesCollected, childInstancesA)

								while true do
									local resultassignedCallResults = table.pack(resultassignedResultEntry())

									if not resultassignedCallResults[1] then
										break
									end

									local resultassignedResultItem = resultassignedCallResults[3]

									if resultassignedResultItem.Name == resultassignedQuestDataData and resultassignedResultItem:FindFirstChild("HumanoidRootPart") then
										resultassignedResultState = resultassignedResultItem

										break
									end
								end

								local childInstancesB, childInstancesC, childInstancesD = pairs(workspace.Enemies:GetChildren())

								for _, playervalueaiPlayerData in childInstancesB, childInstancesC, childInstancesD do
									if playervalueaiPlayerData.Name == resultassignedQuestDataData and playerCollectionLatest.Alive(playervalueaiPlayerData) then
										resultassignedResultState = playervalueaiPlayerData

										break
									end
								end

								if resultassignedResultState and resultassignedResultState:FindFirstChild("HumanoidRootPart") then
									_tp(resultassignedResultState.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))

									while true do
										wait()
										playerCollectionLatest.Kill(resultassignedResultState, _G.FarmEliteH)

										if _G.FarmEliteH then
											if not resultassignedResultState.Parent or resultassignedResultState.Humanoid.Health <= 0 or not Quest.Visible then
												break
											end
										else
											break
										end
									end
								else
									task.wait(5)
									resultassignedResultData()
								end
							else
								replicated.Remotes.CommF_:InvokeServer("AbandonQuest")
								task.wait(1)
								resultassignedResultData()
							end
						else
							local response = replicated.Remotes.CommF_:InvokeServer("EliteHunter")

							if response == nil or string.find(response, "Cooldown") then
								resultassignedResultData()

								return
							end

							task.wait(1)
						end
					end
				end)
			until not task.wait(1)
		end
	end)
end

GRP_Main_Farm_Rip_Indra = tabs.Main:AddLeftGroupbox("Farm Rip Indra")
GRP_Main_Farm_Rip_Indra:AddToggle("Auto_Attack_Rip_Indra", {
	Text = "Auto Attack Rip Indra",
	Default = false,
	Callback = function(isAutoAttackRipIndraEnabled)
		_G.AutoRipIngay = isAutoAttackRipIndraEnabled
	end
})

do
	spawn(function()
		while wait(Sec) do
			pcall(function()
				if _G.AutoRipIngay then
					local ripIndra = GetConnectionEnemies("rip_indra")

					if GetWP("Dark Dagger") and (GetIn("Valkyrie") or not ripIndra) then
						replicated.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(-5097.93164, 316.447021, -3142.66602, -0.405007899, -4.31682743e-08, 0.914313197, -1.90943332e-08, 1, 3.8755779e-08, -0.914313197, -1.76180437e-09, -0.405007899))
						wait(0.1)
						_tp(CFrame.new(-5344.822265625, 423.98541259766, -2725.0930175781))
					else
						while true do
							wait()
							playerCollectionLatest.Kill(ripIndra, _G.AutoRipIngay)

							if _G.AutoRipIngay then
								if not ripIndra.Parent or ripIndra.Humanoid.Health <= 0 then
									break
								end
							else
								break
							end
						end
					end
				end
			end)
		end
	end)
end

GRP_Main_Farm_Rip_Indra:AddToggle("Auto_Unlocked_Haki", {
	Text = "Auto Unlocked Haki",
	Default = false,
	Callback = function(isAutoUnlockedHakiEnabled)
		_G.AutoUnHaki = isAutoUnlockedHakiEnabled
	end
})

do
	AuraSkin = function(isAutoUnlockedHakiEnabledCurrent)
		replicated:WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/FruitCustomizerRF"):InvokeServer(unpack({ {
			StorageName = isAutoUnlockedHakiEnabledCurrent,
			Type = "AuraSkin",
			Context = "Equip"
		} }))
	end
end

VaildColor = function(vaildcolorInput)
	if vaildcolorInput and vaildcolorInput.BrickColor then
		return tostring(vaildcolorInput.BrickColor) == "Lime green"
	end
end
HakiCalculate = function(hakicalculateInput)
	local hakicalculateEntries = {
		["Really red"] = "Pure Red",
		Oyster = "Snow White",
		["Hot pink"] = "Winter Sky"
	}

	if hakicalculateInput and hakicalculateInput.BrickColor then
		return hakicalculateEntries[tostring(hakicalculateInput.BrickColor)]
	end
end
spawn(function()
	while wait(Sec) do
		if _G.AutoUnHaki then
			pcall(function()
				local Summoner = workspace.Map["Boat Castle"]:FindFirstChild("Summoner")

				if Summoner and Summoner:FindFirstChild("Circle") then
					local locatedCircle, locatedCircleData, locatedCircleState = pairs(Summoner:FindFirstChild("Circle"):GetChildren())
					local hakicalculateResult = geniter(locatedCircle, locatedCircleData, locatedCircleState)
					local exitTo
					local hakicalculateResultState, Part2

					while true do
						local hakicalculateCallResults = table.pack(hakicalculateResult())

						if not hakicalculateCallResults[1] then
							break
						end

						hakicalculateResultState = hakicalculateCallResults[3]

						if hakicalculateResultState.Name == "Part" then
							Part2 = hakicalculateResultState:FindFirstChild("Part")

							if VaildColor(Part2) == false then
								exitTo = 1

								break
							end
						end
					end

					if exitTo == 1 then
						local exitTo2

						repeat
							AuraSkin(HakiCalculate(hakicalculateResultState))

							while true do
								wait()
								_tp(hakicalculateResultState.CFrame)

								if VaildColor(Part2) == true then
									break
								elseif not _G.AutoUnHaki then
									break
								end
							end

							exitTo2 = nil

							while true do
								local hakicalculateCallResultsState = table.pack(hakicalculateResult())

								if not hakicalculateCallResultsState[1] then
									break
								end

								hakicalculateResultState = hakicalculateCallResultsState[3]

								if hakicalculateResultState.Name == "Part" then
									Part2 = hakicalculateResultState:FindFirstChild("Part")

									if VaildColor(Part2) == false then
										exitTo2 = 1

										break
									end
								end
							end
						until exitTo2 ~= 1
					end
				end
			end)
		end
	end
end)
GRP_Main_Farming_Cake = tabs.Main:AddLeftGroupbox("Farming Cake")

do
	local grpMainFarmingCakeData = GRP_Main_Farming_Cake:AddLabel("")

	spawn(function()
		while wait(0.2) do
			pcall(function()
				local serverResponseCurrent = string.match(replicated.Remotes.CommF_:InvokeServer("CakePrinceSpawner"), "%d+")

				if serverResponseCurrent then
					grpMainFarmingCakeData:SetText("Killed : " .. (500 - tonumber(serverResponseCurrent) or 0))
				end
			end)
		end
	end)
end

Cake = GRP_Main_Farming_Cake:AddToggle("Auto_Farm_Cake_Prince", {
	Text = "Auto Farm Cake Prince",
	Default = false,
	Callback = function(isAutoFarmCakePrinceEnabled)
		_G.Auto_Cake_Prince = isAutoFarmCakePrinceEnabled
	end
})

do
	spawn(function()
		while task.wait() do
			if _G.Auto_Cake_Prince and not _G.AutoRaidCastle then
				local exitTo

				repeat
					pcall(function()
						local LocalPlayer = game.Players.LocalPlayer
						local HumanoidRootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
						local CakeLoaf = workspace.Map:FindFirstChild("CakeLoaf")
						local BigMirror = CakeLoaf and CakeLoaf:FindFirstChild("BigMirror")

						if not HumanoidRootPart then
							return
						end

						if _G.AcceptQuestC and not _G.CheckQuestVisible(LocalPlayer) then
							local cFrame = CFrame.new(-1927.92, 37.8, -12842.54)

							_tp(cFrame)

							while (cFrame.Position - HumanoidRootPart.Position).Magnitude > 50 do
								task.wait(0.2)
							end

							local callbackCalculatedValue = math.random(1, 4)
							local questDataSelected = {
								{
									"StartQuest",
									"CakeQuest2",
									2
								},
								{
									"StartQuest",
									"CakeQuest2",
									1
								},
								{
									"StartQuest",
									"CakeQuest1",
									1
								},
								{
									"StartQuest",
									"CakeQuest1",
									2
								}
							}

							pcall(function()
								game.ReplicatedStorage.Remotes.CommF_:InvokeServer(unpack(questDataSelected[callbackCalculatedValue]))
							end)
						end

						if not CakeLoaf then
							_tp(CFrame.new(-2077, 252, -12373))
							task.wait(2)

							return
						end

						if BigMirror and (BigMirror.Other.Transparency == 0 or workspace.Enemies:FindFirstChild("Cake Prince")) then
							local callbackMovementDataState = GetConnectionEnemies("Cake Prince")

							if callbackMovementDataState then
								while true do
									task.wait()
									playerCollectionLatest.Kill2(callbackMovementDataState, _G.Auto_Cake_Prince)

									if _G.Auto_Cake_Prince then
										if not callbackMovementDataState.Parent or callbackMovementDataState.Humanoid.Health <= 0 then
											break
										end
									else
										break
									end
								end
							else
								_tp(CFrame.new(-2151.82, 149.32, -12404.91))
							end
						else
							local callbackMovementDataOutput = GetConnectionEnemies({
								"Cookie Crafter",
								"Cake Guard",
								"Baking Staff",
								"Head Baker"
							})

							if callbackMovementDataOutput then
								while true do
									task.wait()
									playerCollectionLatest.Kill(callbackMovementDataOutput, _G.Auto_Cake_Prince)

									if _G.Auto_Cake_Prince then
										if not callbackMovementDataOutput.Parent or callbackMovementDataOutput.Humanoid.Health <= 0 or BigMirror and BigMirror.Other.Transparency == 0 then
											break
										end
									else
										break
									end
								end
							else
								_tp(CFrame.new(-2077, 252, -12373))
							end
						end
					end)
					exitTo = nil

					while task.wait() do
						if _G.Auto_Cake_Prince and not _G.AutoRaidCastle then
							exitTo = 1

							break
						end
					end
				until exitTo ~= 1

				return
			end
		end
	end)
end

do
	CakeQ = GRP_Main_Farming_Cake:AddToggle("Accept_Quests", {
		Text = "Accept Quests",
		Default = false,
		Callback = function(isAutoSummonCakePrinceEnabled)
			_G.AcceptQuestBoss = isAutoSummonCakePrinceEnabled
		end
	})
end

do
	CakeSM = GRP_Main_Farming_Cake:AddToggle("Auto_Summon_Cake_Prince", {
		Text = "Auto Summon Cake Prince",
		Default = false,
		Callback = function(isAutoSummonCakePrinceEnabledCurrent)
			_G.AutoSpawnCP = isAutoSummonCakePrinceEnabledCurrent
		end
	})
end

spawn(function()
	while task.wait(2) do
		if _G.AutoSpawnCP then
			pcall(function()
				local CommF_ = game.ReplicatedStorage.Remotes.CommF_
				local BigMirror = workspace.Map.CakeLoaf:FindFirstChild("BigMirror")

				if not BigMirror then
					return
				end

				if workspace.Enemies:FindFirstChild("Cake Prince") then
					return
				end

				if BigMirror.Other.Transparency == 0 then
					return
				end

				CommF_:InvokeServer("CakePrinceSpawner", true)
			end)
		end
	end
end)
GRP_Main_Farming_Cake:AddToggle("Auto_Dough_King_[Fully]", {
	Text = "Auto Dough King [Fully]",
	Default = false,
	Callback = function(isAutoDoughKingFullyEnabled)
		_G.AutoDoughKing = isAutoDoughKingFullyEnabled
	end
})

do
	spawn(function()
		while wait() do
			if _G.AutoDoughKing then
				local exitTo

				repeat
					pcall(function()
						if workspace.Map.CakeLoaf:FindFirstChild("RedDoor") then
							if workspace.Map.CakeLoaf:FindFirstChild("RedDoor") then
								if GetBP("Red Key") then
									while true do
										task.wait()
										_tp(CFrame.new(-2681.97998, 64.3921585, -12853.7363, 0.149007782, -1.87902192e-08, 0.98883605, 3.60619588e-08, 1, 1.35681812e-08, -0.98883605, 3.36376011e-08, 0.149007782))

										if getgenv().AutoDoughKing then
											if (plr.Character.HumanoidRootPart.CFrame - CFrame.new(-2681.97998, 64.3921585, -12853.7363, 0.149007782, -1.87902192e-08, 0.98883605, 3.60619588e-08, 1, 1.35681812e-08, -0.98883605, 3.36376011e-08, 0.149007782)).Magnitude <= 5 then
												break
											end
										else
											break
										end
									end

									EquipWeapon("Red Key")
								end
							elseif GetConnectionEnemies("Dough King") then
								local callbackPlayerDataCandidate = GetConnectionEnemies("Dough King")

								if callbackPlayerDataCandidate then
									while true do
										task.wait()
										playerCollectionLatest.Kill(callbackPlayerDataCandidate, _G.AutoDoughKing)

										if _G.AutoDoughKing then
											if not callbackPlayerDataCandidate.Parent or callbackPlayerDataCandidate.Humanoid.Health <= 0 then
												break
											end
										else
											break
										end
									end
								else
									_tp(CFrame.new(-1943.676513671875, 251.50956726074219, -12337.880859375))
								end
							end
						elseif GetBP("Red Key") then
							replicated.Remotes.CommF_:InvokeServer("CakeScientist", "Check")
							replicated.Remotes.CommF_:InvokeServer("RaidsNpc", "Check")
						end

						if GetBP("Sweet Chalice") then
							replicated.Remotes.CommF_:InvokeServer("CakePrinceSpawner", true)
							_G.AutoAttackDoughKing = true
						else
							_G.AutoAttackDoughKing = false
						end

						if GetBP("God's Chalice") and GetM("Conjured Cocoa") >= 10 then
							replicated.Remotes.CommF_:InvokeServer("SweetChaliceNpc")
						end

						local ok = not plr.Backpack:FindFirstChild("God's Chalice")

						if not ok then
							ok = not not plr.Character:FindFirstChild("God's Chalice")
						end

						if ok then
							_G.FarmEliteHunt = true
						else
							_G.FarmEliteHunt = false
						end

						if GetM("Conjured Cocoa") <= 10 then
							local callbackPlayerDataReference = GetConnectionEnemies({
								"Cocoa Warrior",
								"Chocolate Bar Battler"
							})

							if callbackPlayerDataReference then
								while true do
									task.wait()
									playerCollectionLatest.Kill(callbackPlayerDataReference, _G.AutoDoughKing)

									if _G.AutoDoughKing == false then
										break
									elseif not callbackPlayerDataReference.Parent or callbackPlayerDataReference.Humanoid.Health <= 0 then
										break
									end
								end
							else
								_tp(CFrame.new(402.71890258789062, 81.060501098632812, -12259.54296875))
							end
						end
					end)
					exitTo = nil

					while wait() do
						if _G.AutoDoughKing then
							exitTo = 1

							break
						end
					end
				until exitTo ~= 1

				return
			end
		end
	end)
end

GRP_Main_Farming_Cake:AddToggle("Auto_Farm_Dough_King", {
	Text = "Auto Farm Dough King",
	Default = false,
	Callback = function(isAutoFarmDoughKingEnabled)
		_G.AutoAttackDoughKing = isAutoFarmDoughKingEnabled
	end
})
spawn(function()
	while wait() do
		if _G.AutoAttackDoughKing then
			local exitTo

			repeat
				pcall(function()
					local callbackResultPayload = GetConnectionEnemies("Dough King")

					if callbackResultPayload then
						while true do
							task.wait()
							playerCollectionLatest.Kill(callbackResultPayload, _G.AutoAttackDoughKing)

							if _G.AutoAttackDoughKing then
								if not callbackResultPayload.Parent or callbackResultPayload.Humanoid.Health <= 0 then
									break
								end
							else
								break
							end
						end
					else
						_tp(CFrame.new(-1943.6765, 251.5095, -12337.8809))
					end
				end)
				exitTo = nil

				while wait() do
					if _G.AutoAttackDoughKing then
						exitTo = 1

						break
					end
				end
			until exitTo ~= 1

			return
		end
	end
end)

do
	GRP_Main_Farming_Cake:AddToggle("Auto_Farm_Dough_King_+_Hop", {
		Text = "Auto Farm Dough King + Hop",
		Default = false,
		Callback = function(isAutoFarmDoughKingHopEnabled)
			_G.AutoHop_Dough = isAutoFarmDoughKingHopEnabled
		end
	})
end

do
	local function playervaluealPlayerData()
		pcall(function()
			local HttpService = game:GetService("HttpService")
			local playerCollectionSelected = {}
			local response = game:HttpGet("https://games.roblox.com/playervalueaiPlayerData/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")

			for _, playervalueaiPlayerData in pairs(HttpService:JSONDecode(response).data) do
				if playervalueaiPlayerData.playing < playervalueaiPlayerData.maxPlayers then
					table.insert(playerCollectionSelected, playervalueaiPlayerData.id)
				end
			end

			if #playerCollectionSelected > 0 then
				game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, playerCollectionSelected[math.random(1, #playerCollectionSelected)], game.Players.LocalPlayer)
			end
		end)
	end

	spawn(function()
		while task.wait() do
			if _G.AutoHop_Dough then
				local exitTo

				repeat
					pcall(function()
						local playervaluealPlayerDataState = GetConnectionEnemies("Dough King")

						if playervaluealPlayerDataState then
							while true do
								task.wait()
								playerCollectionLatest.Kill(playervaluealPlayerDataState, _G.AutoHop_Dough)

								if _G.AutoHop_Dough then
									if not playervaluealPlayerDataState.Parent or playervaluealPlayerDataState.Humanoid.Health <= 0 then
										break
									end
								else
									break
								end
							end
						else
							_tp(CFrame.new(-1943.6765, 251.5095, -12337.8809))
							task.wait(2)

							if not GetConnectionEnemies("Dough King") and _G.AutoHop_Dough then
								playervaluealPlayerData()
							end
						end
					end)
					exitTo = nil

					while task.wait() do
						if _G.AutoHop_Dough then
							exitTo = 1

							break
						end
					end
				until exitTo ~= 1

				return
			end
		end
	end)
end

GRP_Main_Farming_Bone = tabs.Main:AddLeftGroupbox("Farming Bone")

do
	local grpMainFarmingBoneData = GRP_Main_Farming_Bone:AddLabel("")

	spawn(function()
		while wait(1) do
			local response = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Bones", "Check") or 0

			grpMainFarmingBoneData:SetText("You Have: " .. tostring(response) .. " Bones")
			boneStatusLabel:SetText("You Have: " .. tostring(response) .. " Bones")
		end
	end)
end

do
	GRP_Main_Farming_Bone:AddToggle("Auto_Farm_Bone", {
		Text = "Auto Farm Bone",
		Default = false,
		Callback = function(isAutoFarmBoneEnabled)
			_G.AutoFarm_Bone = isAutoFarmBoneEnabled
		end
	})
end

do
	spawn(function()
		local LocalPlayer = game.Players.LocalPlayer
		local playerCollectionActive = {
			"Reborn Skeleton",
			"Living Zombie",
			"Demonic Soul",
			"Possessed Mummy"
		}

		while wait(0.5) do
			if _G.AutoFarm_Bone then
				local exitTo

				repeat
					pcall(function()
						local Character = LocalPlayer.Character
						local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

						if not HumanoidRootPart then
							return
						end

						if LocalPlayer.PlayerGui:FindFirstChild("Main") then
							LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
						end

						local callbackQuestDataData = GetConnectionEnemies(playerCollectionActive)

						if _G.AcceptQuestB then
							if not _G.CheckQuestVisible(LocalPlayer) then
								local cFrame = CFrame.new(-9516.99316, 172.01718, 6078.46533)

								_tp(cFrame)

								while true do
									wait(2)

									if _G.AutoFarm_Bone then
										if (cFrame.Position - HumanoidRootPart.Position).Magnitude <= 50 then
											break
										end
									else
										break
									end
								end

								if not _G.AutoFarm_Bone then
									return
								end

								local questDataActive = {
									{
										"StartQuest",
										"HauntedQuest2",
										2
									},
									{
										"StartQuest",
										"HauntedQuest2",
										1
									},
									{
										"StartQuest",
										"HauntedQuest1",
										1
									},
									{
										"StartQuest",
										"HauntedQuest1",
										2
									}
								}

								game.ReplicatedStorage.Remotes.CommF_:InvokeServer(unpack(questDataActive[math.random(1, #questDataActive)]))
							end
						end

						if callbackQuestDataData then
							while true do
								wait()
								playerCollectionLatest.Kill(callbackQuestDataData, true)

								if _G.AutoFarm_Bone then
									if not callbackQuestDataData.Parent or callbackQuestDataData.Humanoid.Health <= 0 then
										break
									end
								else
									break
								end
							end
						else
							_tp(CFrame.new(-9495.6806640625, 453.58624267578125, 5977.3486328125))
						end
					end)
					exitTo = nil

					while wait(0.5) do
						if _G.AutoFarm_Bone then
							exitTo = 1

							break
						end
					end
				until exitTo ~= 1

				return
			end
		end
	end)
end

do
	BoneQ = GRP_Main_Farming_Bone:AddToggle("Accept_Quests", {
		Text = "Accept Quests",
		Default = false,
		Callback = function(isAutoSoulReaperEnabled)
			_G.AcceptQuestBoss = isAutoSoulReaperEnabled
		end
	})
end

GRP_Main_Farming_Bone:AddToggle("Auto_Soul_Reaper", {
	Text = "Auto Soul Reaper",
	Default = false,
	Callback = function(isAutoSoulReaperEnabledCurrent)
		_G.AutoHytHallow = isAutoSoulReaperEnabledCurrent
	end
})
spawn(function()
	while wait(Sec) do
		if _G.AutoHytHallow then
			pcall(function()
				local callbackResultDetails = GetConnectionEnemies("Soul Reaper")

				if callbackResultDetails then
					while true do
						task.wait()
						playerCollectionLatest.Kill(callbackResultDetails, _G.AutoHytHallow)

						if callbackResultDetails.Humanoid.Health <= 0 then
							break
						elseif _G.AutoHytHallow == false then
							break
						end
					end
				elseif GetBP("Hallow Essence") then
					while true do
						wait(0.1)
						_tp(CFrame.new(-8932.322265625, 146.83154296875, 6062.55078125))

						if _G.AutoHytHallow == false then
							break
						elseif plr.Character.HumanoidRootPart.CFrame == CFrame.new(-8932.322265625, 146.83154296875, 6062.55078125) then
							break
						end
					end

					EquipWeapon("Hallow Essence")
				else
					while true do
						task.wait(0.1)
						replicated.Remotes.CommF_:InvokeServer("Bones", "Buy", 1, 1)

						if _G.AutoHytHallow == false then
							break
						elseif GetBP("Hallow Essence") then
							break
						end
					end
				end
			end)
		end
	end
end)
RanBone = GRP_Main_Farming_Bone:AddToggle("Auto_Random_Bones", {
	Text = "Auto Random Bones",
	Default = false,
	Callback = function(isAutoRandomBonesEnabled)
		_G.Auto_Random_Bone = isAutoRandomBonesEnabled
	end
})
spawn(function()
	if wait(Sec) then
		repeat
			pcall(function()
				if _G.Auto_Random_Bone then
					repeat
						task.wait()
						replicated.Remotes.CommF_:InvokeServer("Bones", "Buy", 1, 1)
					until not _G.Auto_Random_Bone
				end
			end)
		until not wait(Sec)
	end
end)

do
	Lucky = GRP_Main_Farming_Bone:AddToggle("Auto_Try_Luck_Gravestone", {
		Text = "Auto Try Luck Gravestone",
		Default = false,
		Callback = function(isAutoTryLuckGravestoneEnabled)
			_G.TryLucky = isAutoTryLuckGravestoneEnabled
		end
	})
end

do
	spawn(function()
		while wait(Sec) do
			if _G.TryLucky then
				local cFrame = CFrame.new(-8761.3154296875, 164.85829162598, 6161.1567382813)

				if plr.Character.HumanoidRootPart.CFrame ~= cFrame then
					_tp(CFrame.new(-8761.3154296875, 164.85829162598, 6161.1567382813))
				elseif plr.Character.HumanoidRootPart.CFrame == cFrame then
					replicated.Remotes.CommF_:InvokeServer("gravestoneEvent", 1)
				end
			end
		end
	end)
end

do
	Pray = GRP_Main_Farming_Bone:AddToggle("Auto_Pray_Gravestone", {
		Text = "Auto Pray Gravestone",
		Default = false,
		Callback = function(isAutoPrayGravestoneEnabled)
			_G.Praying = isAutoPrayGravestoneEnabled
		end
	})
end

do
	spawn(function()
		while wait(Sec) do
			if _G.Praying then
				local cFrame = CFrame.new(-8761.3154296875, 164.85829162598, 6161.1567382813)

				if plr.Character.HumanoidRootPart.CFrame ~= cFrame then
					local exitTo

					repeat
						_tp(CFrame.new(-8761.3154296875, 164.85829162598, 6161.1567382813))
						exitTo = nil

						while wait(Sec) do
							if _G.Praying then
								local cFrame2 = CFrame.new(-8761.3154296875, 164.85829162598, 6161.1567382813)

								if plr.Character.HumanoidRootPart.CFrame ~= cFrame2 then
									exitTo = 1

									break
								elseif plr.Character.HumanoidRootPart.CFrame == cFrame2 then
									replicated.Remotes.CommF_:InvokeServer("gravestoneEvent", 2)
								end
							end
						end
					until exitTo ~= 1

					return
				elseif plr.Character.HumanoidRootPart.CFrame == cFrame then
					replicated.Remotes.CommF_:InvokeServer("gravestoneEvent", 2)
				end
			end
		end
	end)
end

GRP_Main_Tyrant_of_the_Skies = tabs.Main:AddLeftGroupbox("Tyrant of the Skies")

do
	local tyrantOfTheSkiesStatusLabel = GRP_Main_Tyrant_of_the_Skies:AddLabel("Tyrant of the Skies: ")

	spawn(function()
		pcall(function()
			while wait(1) do
				if workspace.Enemies:FindFirstChild("Tyrant of the Skies") then
					tyrantOfTheSkiesStatusLabel:SetText("Tyrant of the Skies: ✅")
				else
					tyrantOfTheSkiesStatusLabel:SetText("Tyrant of the Skies: ❌")
				end
			end
		end)
	end)
end

do
	local eyesStatusLabel = GRP_Main_Tyrant_of_the_Skies:AddLabel("Eyes: 0/4")

	Check_Eye = function()
		local MapFolder = workspace:FindFirstChild("Map")
		local Outpost = MapFolder and MapFolder:FindFirstChild("TikiOutpost")
		local IslandModel = Outpost and Outpost:FindFirstChild("IslandModel")
		local n4 = 0

		if not IslandModel then
			return 0, false
		end

		local Chunks = IslandModel:FindFirstChild("IslandChunks")
		local ChunkE = Chunks and Chunks:FindFirstChild("E")
		local Eyes = {
			IslandModel:FindFirstChild("Eye1"),
			IslandModel:FindFirstChild("Eye2"),
			ChunkE and ChunkE:FindFirstChild("Eye3"),
			ChunkE and ChunkE:FindFirstChild("Eye4")
		}

		for i = 1, 4 do
			local playervalueaiPlayerData = Eyes[i]

			if playervalueaiPlayerData and playervalueaiPlayerData.Transparency ~= 1 then
				n4 += 1
			end
		end

		return n4, n4 == 4
	end
	task.spawn(function()
		local isCheckeyeReady = false

		while task.wait(1) do
			local checkEyeResult, checkEyeResultState = Check_Eye()

			eyesStatusLabel:SetText("Eyes: " .. checkEyeResult .. "/4")

			if checkEyeResultState and not isCheckeyeReady then
				isCheckeyeReady = true
			elseif not checkEyeResultState then
				isCheckeyeReady = false
			end
		end
	end)
end

do
	FarmTyrant = GRP_Main_Tyrant_of_the_Skies:AddToggle("Auto_Farm_Boss_TOTS", {
		Text = "Auto Farm Boss TOTS",
		Default = false,
		Callback = function(isAutoFarmBossTotsEnabled)
			_G.FarmTyrant = isAutoFarmBossTotsEnabled
		end
	})
end

do
	spawn(function()
		while wait(Sec) do
			if _G.FarmTyrant then
				pcall(function()
					if not plr.Character then
						return
					end

					local HumanoidRootPart = plr.Character:FindFirstChild("HumanoidRootPart")

					if not HumanoidRootPart then
						return
					end

					local vector3 = Vector3.new(-16268.287, 152.616, 1390.773)

					if (HumanoidRootPart.Position - vector3).Magnitude > 5 then
						_tp(CFrame.new(vector3))

						while true do
							wait()

							if _G.FarmTyrant then
								if plr.Character then
									if not plr.Character:FindFirstChild("HumanoidRootPart") or not ((plr.Character.HumanoidRootPart.Position - vector3).Magnitude <= 5) then
										continue
									end
								else
									continue
								end

								break
							end

							break
						end
					end

					local TyrantOfTheSkies = workspace.Enemies:FindFirstChild("Tyrant of the Skies")

					if TyrantOfTheSkies and TyrantOfTheSkies:FindFirstChild("Humanoid") and TyrantOfTheSkies.Humanoid.Health > 0 then
						while _G.FarmTyrant do
							if playerCollectionLatest and playerCollectionLatest.Kill then
								playerCollectionLatest.Kill(TyrantOfTheSkies, _G.FarmTyrant)
							end

							wait()

							if not _G.FarmTyrant or not TyrantOfTheSkies.Parent or TyrantOfTheSkies.Humanoid.Health <= 0 then
								break
							end
						end

						return
					end

					for _, playervalueaiPlayerData in ipairs({
						"Serpent Hunter",
						"Skull Slayer",
						"Isle Champion",
						"Sun-kissed Warrior"
					}) do
						if not _G.FarmTyrant then
							break
						end

						for _, child in pairs(workspace.Enemies:GetChildren()) do
							if not _G.FarmTyrant then
								break
							end

							if child and child.Name == playervalueaiPlayerData and child:FindFirstChild("HumanoidRootPart") and child:FindFirstChild("Humanoid") and child.Humanoid.Health > 0 then
								if (HumanoidRootPart.Position - child.HumanoidRootPart.Position).Magnitude > 5000 then
									_tp(child.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))

									local now = tick()

									repeat
										wait()
										HumanoidRootPart = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
									until not _G.FarmTyrant or not HumanoidRootPart or (HumanoidRootPart.Position - child.HumanoidRootPart.Position).Magnitude <= 6 or tick() - now > 8
								end

								while _G.FarmTyrant do
									if playerCollectionLatest and playerCollectionLatest.Kill then
										playerCollectionLatest.Kill(child, _G.FarmTyrant)
									end

									wait()

									if not _G.FarmTyrant or not child.Parent or child.Humanoid.Health <= 0 then
										break
									end
								end
							end
						end
					end
				end)
			end
		end
	end)
end

FarmPhaBinh = GRP_Main_Tyrant_of_the_Skies:AddToggle("Auto_Summon_Boss", {
	Text = "Auto Summon Boss",
	Default = false,
	Callback = function(isAutoSummonBossEnabled)
		_G.FarmPhaBinh = isAutoSummonBossEnabled
	end
})

do
	local function enemyvalueselectedEnemy(isAutoSummonBossEnabledCurrent)
		local VirtualInputManager = game:GetService("VirtualInputManager")

		VirtualInputManager:SendKeyEvent(true, isAutoSummonBossEnabledCurrent, true, game)
		wait(0.05)
		VirtualInputManager:SendKeyEvent(false, isAutoSummonBossEnabledCurrent, true, game)
	end
	local function playervalueapPlayerData(valueArgument)
		if not plr.Character or not plr.Character:FindFirstChild("Humanoid") or not (plr.Character.Humanoid.Health > 0) then
			return
		end

		for _, child in pairs(plr.Backpack:GetChildren()) do
			if child:IsA("Tool") and child.ToolTip == valueArgument then
				child.Parent = plr.Character
				wait(0.12)

				for _, playervalueaiPlayerData in ipairs({
					"Z",
					"X",
					"C",
					"V",
					"F"
				}) do
					if not _G.FarmPhaBinh then
						break
					end

					pcall(function()
						enemyvalueselectedEnemy(playervalueaiPlayerData)
					end)
					wait(0.12)
				end

				child.Parent = plr.Backpack

				return
			end
		end
	end

	local locationDataTarget = {
		CFrame.new(-16332.5263671875, 158.07200622558594, 1440.324951171875),
		CFrame.new(-16288.609375, 158.16700744628906, 1470.3680419921875),
		CFrame.new(-16245.412109375, 158.43699645996094, 1463.365966796875),
		CFrame.new(-16212.46875, 158.16700744628906, 1466.343994140625),
		CFrame.new(-16211.9462890625, 158.07200622558594, 1322.39794921875),
		CFrame.new(-16260.921875, 154.92100524902344, 1323.615966796875),
		CFrame.new(-16297.0595703125, 159.322998046875, 1317.2239990234375),
		CFrame.new(-16335.0966796875, 159.33399963378906, 1324.885986328125)
	}

	spawn(function()
		while wait(Sec) do
			if _G.FarmPhaBinh then
				pcall(function()
					if plr and plr.Character then
						if plr.Character:FindFirstChild("HumanoidRootPart") then
							if plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
								for _, playervalueaiPlayerData in ipairs(locationDataTarget) do
									if not _G.FarmPhaBinh then
										break
									end

									_tp(playervalueaiPlayerData)

									local isPlayervalueapReady = false
									local now = tick()

									while true do
										if tick() - now < 12 and _G.FarmPhaBinh then
											local HumanoidRootPart = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")

											if not HumanoidRootPart then
												break
											end

											if not ((HumanoidRootPart.Position - playervalueaiPlayerData.Position).Magnitude <= 3) then
												wait(0.1)

												continue
											end

											isPlayervalueapReady = true

											break
										end

										break
									end

									if _G.FarmPhaBinh and isPlayervalueapReady then
										playervalueapPlayerData("Melee")
										playervalueapPlayerData("Sword")
										playervalueapPlayerData("Gun")
									end
								end

								return
							end
						end
					end
				end)
			end
		end
	end)
end

GRP_Main_Farm_Material = tabs.Main:AddLeftGroupbox("Farm Material")

do
	Test = GRP_Main_Farm_Material:AddDropdown("Choose_Material", {
		Text = "Choose Material",
		Values = MaterialList,
		Default = 1,
		Callback = function(isAutoFarmMaterialsEnabled)
			getgenv().SelectMaterial = isAutoFarmMaterialsEnabled
		end
	})
end

Toggle = GRP_Main_Farm_Material:AddToggle("Auto_Farm_Materials", {
	Text = "Auto Farm Materials",
	Default = false,
	Callback = function(isAutoFarmMaterialsEnabledCurrent)
		getgenv().AutoMaterial = isAutoFarmMaterialsEnabledCurrent
	end
})
spawn(function()
	local function resultkResult(isAutoFarmMaterialsEnabledCached, isAutoFarmMaterialsEnabledSelected)
		if isAutoFarmMaterialsEnabledCached:FindFirstChild("Humanoid") and isAutoFarmMaterialsEnabledCached:FindFirstChild("HumanoidRootPart") and isAutoFarmMaterialsEnabledCached.Humanoid.Health > 0 then
			if isAutoFarmMaterialsEnabledCached.Name == isAutoFarmMaterialsEnabledSelected then
				while true do
					wait()
					playerCollectionLatest.Kill(isAutoFarmMaterialsEnabledCached, getgenv().AutoMaterial)

					if getgenv().AutoMaterial then
						if not isAutoFarmMaterialsEnabledCached.Parent or isAutoFarmMaterialsEnabledCached.Humanoid.Health <= 0 then
							break
						end
					else
						break
					end
				end
			end
		end
	end
	local function enemyvalueactiveEnemy()
		for _, child in pairs(game:GetService("Workspace")._WorldOrigin.EnemySpawns:GetChildren()) do
			for _, playervalueaiPlayerData in ipairs(MMon) do
				if string.find(child.Name, playervalueaiPlayerData) and (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - child.Position).Magnitude >= 10 then
					_tp(child.CFrame * Pos)
				end
			end
		end
	end

	while wait() do
		if getgenv().AutoMaterial then
			pcall(function()
				if getgenv().SelectMaterial then
					MaterialMon(getgenv().SelectMaterial)
					_tp(MPos)
				end

				for _, playervalueaiPlayerData in ipairs(MMon) do
					for _, child in pairs(workspace.Enemies:GetChildren()) do
						resultkResult(child, playervalueaiPlayerData)
					end
				end

				enemyvalueactiveEnemy()
			end)
		end
	end
end)
GRP_Main_Farm_Boss = tabs.Main:AddLeftGroupbox("Farm Boss")
BossDropdown = GRP_Main_Farm_Boss:AddDropdown("Select_Boss", {
	Text = "Select Boss",
	Values = BossList,
	Default = 1,
	Callback = function(isAutoFarmBossEnabled)
		_G.FindBoss = isAutoFarmBossEnabled
	end
})
FarmBoss = GRP_Main_Farm_Boss:AddToggle("Auto_Farm_Boss", {
	Text = "Auto Farm Boss",
	Default = false,
	Callback = function(isAutoFarmBossEnabledCurrent)
		_G.FarmBoss = isAutoFarmBossEnabledCurrent
		spawn(function()
			while wait(Sec) do
				if _G.FarmBoss then
					local exitTo

					repeat
						pcall(function()
							local callbackQuestData = QuestBeta()[2] ~= nil

							callbackQuestData = callbackQuestData and QuestBeta()[3] ~= nil

							local Text = plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text

							if _G.AcceptQuestBoss and callbackQuestData then
								if not string.find(Text, QuestBeta()[0]) then
									replicated.Remotes.CommF_:InvokeServer("AbandonQuest")
								end

								if plr.PlayerGui.Main.Quest.Visible == false then
									_tp(QuestBeta()[5])

									if (Root.Position - QuestBeta()[5].Position).Magnitude <= 5 then
										replicated.Remotes.CommF_:InvokeServer("StartQuest", QuestBeta()[3], QuestBeta()[2])
									end
								elseif plr.PlayerGui.Main.Quest.Visible == true then
									if workspace.Enemies:FindFirstChild(QuestBeta()[1]) then
										for _, child in pairs(workspace.Enemies:GetChildren()) do
											if playerCollectionLatest.Alive(child) and child.Name == QuestBeta()[1] then
												if string.find(Text, QuestBeta()[0]) then
													while true do
														wait()
														playerCollectionLatest.Kill(child, _G.FarmBoss)

														if _G.FarmBoss then
															if child.Humanoid.Health <= 0 or not child.Parent or plr.PlayerGui.Main.Quest.Visible == false then
																break
															end
														else
															break
														end
													end
												else
													replicated.Remotes.CommF_:InvokeServer("AbandonQuest")
												end
											end
										end
									else
										_tp(QuestBeta()[4])

										if replicated:FindFirstChild(QuestBeta()[1]) then
											_tp(replicated:FindFirstChild(QuestBeta()[1]).HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
										end
									end
								end
							elseif workspace.Enemies:FindFirstChild(QuestBeta()[1]) then
								for _, child in pairs(workspace.Enemies:GetChildren()) do
									if playerCollectionLatest.Alive(child) and child.Name == QuestBeta()[1] then
										while true do
											wait()
											playerCollectionLatest.Kill(child, _G.FarmBoss)

											if _G.FarmBoss then
												if child.Humanoid.Health <= 0 or not child.Parent then
													break
												end
											else
												break
											end
										end
									end
								end
							else
								_tp(QuestBeta()[4])

								if replicated:FindFirstChild(QuestBeta()[1]) then
									_tp(replicated:FindFirstChild(QuestBeta()[1]).HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
								end
							end
						end)
						exitTo = nil

						while wait(Sec) do
							if _G.FarmBoss then
								exitTo = 1

								break
							end
						end
					until exitTo ~= 1

					return
				end
			end
		end)
	end
})
BossQ = GRP_Main_Farm_Boss:AddToggle("Accept_Quests", {
	Text = "Accept Quests",
	Default = true,
	Callback = function(isAutoFarmAllBossEnabled)
		_G.AcceptQuestBoss = isAutoFarmAllBossEnabled
	end
})
FarmAllBoss = GRP_Main_Farm_Boss:AddToggle("Auto_Farm_All_Boss", {
	Text = "Auto Farm All Boss",
	Default = false,
	Callback = function(isAutoFarmAllBossEnabledCurrent)
		_G.AutoFarmAllBoss = isAutoFarmAllBossEnabledCurrent
	end
})
task.spawn(function()
	while task.wait(0.3) do
		if _G.AutoFarmAllBoss then
			pcall(function()
				local LocalPlayer = game.Players.LocalPlayer

				if LocalPlayer.Character then
					if LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
						local HumanoidRootPart = LocalPlayer.Character.HumanoidRootPart
						local callbackEnemyItem
						local huge = math.huge

						for _, child in pairs(workspace.Enemies:GetChildren()) do
							if child:FindFirstChild("HumanoidRootPart") and child:FindFirstChild("Humanoid") and child.Humanoid.Health > 0 and table.find(BossList, child.Name) then
								local Magnitude = (HumanoidRootPart.Position - child.HumanoidRootPart.Position).Magnitude

								if Magnitude < huge then
									callbackEnemyItem = child
									huge = Magnitude
								end
							end
						end

						if callbackEnemyItem and callbackEnemyItem:FindFirstChild("HumanoidRootPart") then
							local HumanoidRootPart2 = callbackEnemyItem.HumanoidRootPart
							local Humanoid = callbackEnemyItem.Humanoid

							while true do
								task.wait(0.1)

								if _G.AutoFarmAllBoss then
									local targetCFrame = HumanoidRootPart2.CFrame * CFrame.new(0, 5, 0)

									if (HumanoidRootPart.Position - targetCFrame.Position).Magnitude > 100 then
										LocalPlayer.Character:PivotTo(targetCFrame)
									else
										_tp(targetCFrame)
									end

									if playerCollectionLatest and typeof(playerCollectionLatest.Kill) == "function" then
										playerCollectionLatest.Kill(callbackEnemyItem, true)
									end

									if not callbackEnemyItem.Parent or Humanoid.Health <= 0 or not _G.AutoFarmAllBoss then
										break
									end
								else
									break
								end
							end
						end

						return
					end
				end
			end)
		end
	end
end)
_G.MasteryHealthPct = 70
_G.SelectedMasterySkills = {
	Z = true,
	X = true,
	C = true,
	V = true,
	F = true
}

do
	local masterySection = tabs.Main:AddLeftGroupbox("Farming Mastery")
	local selectedMasteryIsland = "Cake"

	masterySection:AddDropdown("Choose_Island", {
		Text = "Choose Island",
		Values = {
			"Cake",
			"Bone"
		},
		Default = 1,
		Callback = function(selectedIsland)
			selectedMasteryIsland = selectedIsland
		end
	})
	masterySection:AddSlider({
		Text = "NPC Health % Switch to Weapon",
		Min = 10,
		Max = 95,
		Default = 70,
		Rounding = 1,
		Callback = function(healthThresholdPercent)
			_G.MasteryHealthPct = healthThresholdPercent
		end
	})
	masterySection:AddDropdown("Select_Skills", {
		Text = "Select Skills to Use",
		Values = {
			"Z",
			"X",
			"C",
			"V",
			"F",
			"Y"
		},
		Multi = true,
		Default = {
			Z = true,
			X = true,
			C = true,
			V = true,
			F = true
		},
		Callback = function(selectedSkills, isSkillSelected)
			if type(selectedSkills) == "table" then
				_G.SelectedMasterySkills = selectedSkills
			elseif type(selectedSkills) == "string" then
				if type(_G.SelectedMasterySkills) ~= "table" then
					_G.SelectedMasterySkills = {}
				end

				_G.SelectedMasterySkills[selectedSkills] = isSkillSelected and true or nil
			end
		end
	})
	masterySection:AddToggle("Auto_Mastery_Fruits", {
		Text = "Auto Mastery Fruits",
		Default = false,
		Callback = function(isAutoMasteryFruitsEnabled)
			_G.FarmMastery_Dev = isAutoMasteryFruitsEnabled
		end
	})
	spawn(function()
		connectScoped(RunSer.RenderStepped, function()
			pcall(function()
				if _G.FarmMastery_Dev or _G.FarmMastery_G or _G.FarmMastery_S then
					for _, child in pairs(plr.PlayerGui.Notifications:GetChildren()) do
						if child.Name == "NotificationTemplate" and string.find(child.Text, "Skill locked!") then
							child:Destroy()
						end
					end
				end
			end)
		end)
	end)
	spawn(function()
		while wait(Sec) do
			if _G.FarmMastery_Dev then
				pcall(function()
					if selectedMasteryIsland == "Cake" then
						local callbackMovementDataCandidate = GetConnectionEnemies(locationDataPrimary)

						if callbackMovementDataCandidate then
							while true do
								wait()
								HealthM = callbackMovementDataCandidate.Humanoid.MaxHealth * (_G.MasteryHealthPct / 100)
								MousePos = callbackMovementDataCandidate.HumanoidRootPart.Position
								playerCollectionLatest.Mas(callbackMovementDataCandidate, _G.FarmMastery_Dev)

								if _G.FarmMastery_Dev == false then
									break
								elseif callbackMovementDataCandidate.Humanoid.Health <= 0 or not callbackMovementDataCandidate.Parent then
									break
								end
							end
						else
							_tp(CFrame.new(-1943.676513671875, 251.50956726074219, -12337.880859375))
						end
					else
						if selectedMasteryIsland ~= "Bone" then
							return
						end

						local callbackMovementDataOption = GetConnectionEnemies(locationDataNearby)

						if callbackMovementDataOption then
							while true do
								wait()
								HealthM = callbackMovementDataOption.Humanoid.MaxHealth * (_G.MasteryHealthPct / 100)
								MousePos = callbackMovementDataOption.HumanoidRootPart.Position
								playerCollectionLatest.Mas(callbackMovementDataOption, _G.FarmMastery_Dev)

								if _G.FarmMastery_Dev == false or callbackMovementDataOption.Humanoid.Health <= 0 then
									break
								elseif not callbackMovementDataOption.Parent then
									break
								end
							end

							return
						end

						_tp(CFrame.new(-9495.6806640625, 453.58624267578125, 5977.3486328125))
					end
				end)
			end
		end
	end)
	masterySection:AddToggle("Auto_Mastery_Gun", {
		Text = "Auto Mastery Gun",
		Default = false,
		Callback = function(isAutoMasteryGunEnabled)
			_G.FarmMastery_G = isAutoMasteryGunEnabled
		end
	})
	spawn(function()
		while wait(Sec) do
			if _G.FarmMastery_G then
				pcall(function()
					if selectedMasteryIsland == "Cake" then
						local callbackWeapon = GetConnectionEnemies(locationDataPrimary)

						if callbackWeapon then
							HealthM = callbackWeapon.Humanoid.MaxHealth * _G.MasteryHealthPct / 100

							repeat
								wait()
								MousePos = callbackWeapon.HumanoidRootPart.Position
								playerCollectionLatest.Masgun(callbackWeapon, _G.FarmMastery_G)

								local REShootGunEvent = replicated:FindFirstChild("Modules"):FindFirstChild("Net"):FindFirstChild("RE/ShootGunEvent")

								if plr.Character:FindFirstChildOfClass("Tool").ToolTip ~= "Gun" then
									return
								end

								local Character, Character2

								if plr.Character:FindFirstChildOfClass("Tool") then
									if plr.Character:FindFirstChildOfClass("Tool").Name == "Skull Guitar" then
										SoulGuitar = true
										plr.Character:FindFirstChildOfClass("Tool").RemoteEvent:FireServer("TAP", MousePos)

										if _G.FarmMastery_G then
											vim1:SendMouseButtonEvent(0, 0, 0, true, game, 1)
											wait(0.05)
											vim1:SendMouseButtonEvent(0, 0, 0, false, game, 1)
											wait(0.05)
										end
									else
										Character = plr.Character

										if Character:FindFirstChildOfClass("Tool") then
											Character2 = plr.Character

											if Character2:FindFirstChildOfClass("Tool").Name ~= "Skull Guitar" then
												SoulGuitar = false
												REShootGunEvent:FireServer(MousePos, { callbackWeapon.HumanoidRootPart })

												if _G.FarmMastery_G then
													vim1:SendMouseButtonEvent(0, 0, 0, true, game, 1)
													wait(0.05)
													vim1:SendMouseButtonEvent(0, 0, 0, false, game, 1)
													wait(0.05)
												end
											end
										end
									end
								else
									Character = plr.Character

									if Character:FindFirstChildOfClass("Tool") then
										Character2 = plr.Character

										if Character2:FindFirstChildOfClass("Tool").Name ~= "Skull Guitar" then
											SoulGuitar = false
											REShootGunEvent:FireServer(MousePos, { callbackWeapon.HumanoidRootPart })

											if _G.FarmMastery_G then
												vim1:SendMouseButtonEvent(0, 0, 0, true, game, 1)
												wait(0.05)
												vim1:SendMouseButtonEvent(0, 0, 0, false, game, 1)
												wait(0.05)
											end
										end
									end

									if _G.FarmMastery_G == false or callbackWeapon.Humanoid.Health <= 0 or not callbackWeapon.Parent then
										break
									end
								end
							until _G.FarmMastery_G == false or callbackWeapon.Humanoid.Health <= 0 or not callbackWeapon.Parent

							SoulGuitar = false
						else
							_tp(CFrame.new(-1943.676513671875, 251.50956726074219, -12337.880859375))
						end
					elseif selectedMasteryIsland == "Bone" then
						local callbackWeaponEntry = GetConnectionEnemies(locationDataNearby)

						if callbackWeaponEntry then
							HealthM = callbackWeaponEntry.Humanoid.MaxHealth * _G.MasteryHealthPct / 100

							repeat
								wait()
								MousePos = callbackWeaponEntry.HumanoidRootPart.Position
								playerCollectionLatest.Masgun(callbackWeaponEntry, _G.FarmMastery_G)

								local REShootGunEvent = replicated:FindFirstChild("Modules"):FindFirstChild("Net"):FindFirstChild("RE/ShootGunEvent")

								if plr.Character:FindFirstChildOfClass("Tool").ToolTip ~= "Gun" then
									return
								end

								local Character, Character2

								if plr.Character:FindFirstChildOfClass("Tool") then
									if plr.Character:FindFirstChildOfClass("Tool").Name == "Skull Guitar" then
										SoulGuitar = true
										plr.Character:FindFirstChildOfClass("Tool").RemoteEvent:FireServer("TAP", MousePos)

										if _G.FarmMastery_G then
											vim1:SendMouseButtonEvent(0, 0, 0, true, game, 1)
											wait(0.05)
											vim1:SendMouseButtonEvent(0, 0, 0, false, game, 1)
											wait(0.05)
										end
									else
										Character = plr.Character

										if Character:FindFirstChildOfClass("Tool") then
											Character2 = plr.Character

											if Character2:FindFirstChildOfClass("Tool").Name ~= "Skull Guitar" then
												SoulGuitar = false
												REShootGunEvent:FireServer(MousePos, { callbackWeaponEntry.HumanoidRootPart })

												if _G.FarmMastery_G then
													vim1:SendMouseButtonEvent(0, 0, 0, true, game, 1)
													wait(0.05)
													vim1:SendMouseButtonEvent(0, 0, 0, false, game, 1)
													wait(0.05)
												end
											end
										end
									end
								else
									Character = plr.Character

									if Character:FindFirstChildOfClass("Tool") then
										Character2 = plr.Character

										if Character2:FindFirstChildOfClass("Tool").Name ~= "Skull Guitar" then
											SoulGuitar = false
											REShootGunEvent:FireServer(MousePos, { callbackWeaponEntry.HumanoidRootPart })

											if _G.FarmMastery_G then
												vim1:SendMouseButtonEvent(0, 0, 0, true, game, 1)
												wait(0.05)
												vim1:SendMouseButtonEvent(0, 0, 0, false, game, 1)
												wait(0.05)
											end
										end
									end

									if _G.FarmMastery_G == false or callbackWeaponEntry.Humanoid.Health <= 0 or not callbackWeaponEntry.Parent then
										break
									end
								end
							until _G.FarmMastery_G == false or callbackWeaponEntry.Humanoid.Health <= 0 or not callbackWeaponEntry.Parent

							SoulGuitar = false
						else
							_tp(CFrame.new(-9495.6806640625, 453.58624267578125, 5977.3486328125))
						end
					end
				end)
			end
		end
	end)
	masterySection:AddToggle("Auto_Mastery_All_Sword", {
		Text = "Auto Mastery All Sword",
		Default = false,
		Callback = function(isAutoMasteryAllSwordEnabled)
			_G.FarmMastery_S = isAutoMasteryAllSwordEnabled
		end
	})
	spawn(function()
		while wait(Sec) do
			pcall(function()
				if not _G.FarmMastery_S then
					return
				end

				if selectedMasteryIsland == "Cake" then
					local next_ = next
					local response, serverResponseCached = replicated.Remotes.CommF_:InvokeServer("getInventory")
					local exitTo
					local callbackWeaponData

					for _, playervalueaiPlayerData in next_, response, serverResponseCached do
						if type(playervalueaiPlayerData) == "table" and playervalueaiPlayerData.Type == "Sword" then
							callbackWeaponData = playervalueaiPlayerData
							exitTo = 1

							break
						end
					end

					if exitTo == 1 then
						SwordName = callbackWeaponData.Name

						if tonumber(callbackWeaponData.Mastery) >= 1 or tonumber(callbackWeaponData.Mastery) <= 599 then
							local callbackWeaponItem = GetConnectionEnemies(locationDataPrimary)

							if not GetBP(SwordName) then
								replicated.Remotes.CommF_:InvokeServer("LoadItem", SwordName)

								return
							end

							if callbackWeaponItem then
								while true do
									wait()
									playerCollectionLatest.Sword(callbackWeaponItem, _G.FarmMastery_S)

									if _G.FarmMastery_S == false then
										break
									elseif not callbackWeaponItem.Parent or callbackWeaponItem.Humanoid.Health <= 0 then
										break
									end
								end
							else
								_tp(CFrame.new(-1943.676513671875, 251.50956726074219, -12337.880859375))
							end

							return
						elseif tonumber(callbackWeaponData.Mastery) >= 600 then
							if GetBP(SwordName) then
								return nil
							end

							replicated.Remotes.CommF_:InvokeServer("LoadItem", SwordName)
						end
					end
				else
					if selectedMasteryIsland ~= "Bone" then
						return
					end

					local next_ = next
					local response, serverResponseSelected = replicated.Remotes.CommF_:InvokeServer("getInventory")
					local exitTo2
					local callbackWeaponState

					for _, playervalueaiPlayerData in next_, response, serverResponseSelected do
						if type(playervalueaiPlayerData) == "table" and playervalueaiPlayerData.Type == "Sword" then
							callbackWeaponState = playervalueaiPlayerData
							exitTo2 = 1

							break
						end
					end

					if exitTo2 == 1 then
						SwordName = callbackWeaponState.Name

						if tonumber(callbackWeaponState.Mastery) >= 1 or tonumber(callbackWeaponState.Mastery) <= 599 then
							local callbackWeaponCandidate = GetConnectionEnemies(locationDataNearby)

							if not GetBP(SwordName) then
								replicated.Remotes.CommF_:InvokeServer("LoadItem", SwordName)

								return
							end

							if callbackWeaponCandidate then
								while true do
									wait()
									playerCollectionLatest.Sword(callbackWeaponCandidate, _G.FarmMastery_S)

									if _G.FarmMastery_S == false then
										break
									elseif not callbackWeaponCandidate.Parent or callbackWeaponCandidate.Humanoid.Health <= 0 then
										break
									end
								end

								return
							end

							_tp(CFrame.new(-9495.6806640625, 453.58624267578125, 5977.3486328125))

							return
						end

						if tonumber(callbackWeaponState.Mastery) >= 600 then
							if GetBP(SwordName) then
								return nil
							end

							replicated.Remotes.CommF_:InvokeServer("LoadItem", SwordName)
						end
					end
				end
			end)
		end
	end)
end

do
	local MagnetEvent26 = require(game.ReplicatedStorage.EventConfig.MagnetEvent26)

	local function weaponvaluepreviousWeapon()
		local serverTimeNow = workspace:GetServerTimeNow()
		local _Value = MagnetEvent26.START_AT._Value

		return MagnetEvent26.ENABLED and serverTimeNow >= _Value and serverTimeNow < MagnetEvent26.NO_MORE_GAMEPLAY_AT._Value
	end
end

GRP_Main_Update_30_Magnet_Token = tabs.Main:AddLeftGroupbox("Update 30 / Magnet Token")

do
	local loadingStatusLabelCurrent = GRP_Main_Update_30_Magnet_Token:AddLabel("Loading...")
	local Idle = GRP_Main_Update_30_Magnet_Token:AddLabel("Idle")

	local function resultmResult(valueArgumentCurrent)
		Idle:SetText(valueArgumentCurrent)
	end

	task.spawn(function()
		while task.wait(1) do
			pcall(function()
				local now = os.time()
				local datePartsCurrent = os.date("*t", now)
				local min = datePartsCurrent.min
				local sec = datePartsCurrent.sec
				local resultmEnemy = min >= 0 and min < 10
				local isResultmReady = false

				for _, child in pairs(workspace.Enemies:GetChildren()) do
					if child:IsA("Model") and (child:GetAttribute("MagnetEnemy") == true or string.find(string.lower(child.Name), "magnetized")) then
						isResultmReady = true

						break
					end
				end

				local previousStatusData = "🔴"
				local resultmEnemyState

				if isResultmReady then
					local previousStatusEntry = "🟢"
					local resultmEnemyData = (10 - min) * 60 - sec

					if resultmEnemyData < 0 then
						resultmEnemyData = 0
					end

					resultmEnemyState = string.format("%s ACTIVE - Time Left: %02d:%02d (✅ Enemies Found)", previousStatusEntry, math.floor(resultmEnemyData / 60), resultmEnemyData % 60)
				elseif resultmEnemy then
					local previousStatusItem = "🟢"
					local resultmResultState = (10 - min) * 60 - sec

					if resultmResultState < 0 then
						resultmResultState = 0
					end

					resultmEnemyState = string.format("%s ACTIVE - Time Left: %02d:%02d", previousStatusItem, math.floor(resultmResultState / 60), resultmResultState % 60)
				else
					local resultmResultData = (60 - min) * 60 - sec

					if resultmResultData <= 0 then
						resultmResultData = 0
					end

					resultmEnemyState = string.format("%s INACTIVE - Next Event: %02d:%02d", previousStatusData, math.floor(resultmResultData / 60), resultmResultData % 60)
				end

				loadingStatusLabelCurrent:SetText(resultmEnemyState)
			end)
		end
	end)
	_G.MagnetEventSpawnIndex = _G.MagnetEventSpawnIndex or 1

	local resultmEntries = {
		sky = true,
		skyarea2 = true,
		uppersky = true,
		["upper sky"] = true,
		["underwater city"] = true,
		["fishman island"] = true,
		sewers = true,
		["sewer gangs"] = true
	}
	local locationDataPrevious = {}

	local function movementvaluetrackedMovementData(isEnabledSelected)
		if not isEnabledSelected then
			return
		end

		if isEnabledSelected:IsA("BasePart") then
			return isEnabledSelected.Position
		end

		local ok, resultassignedResult = pcall(function()
			return isEnabledSelected:GetPivot()
		end)
		local Position = ok and typeof(resultassignedResult) == "CFrame" and resultassignedResult.Position or nil

		return Position
	end
	local function movementvaluecreatedMovementData(valueArgumentCached)
		local Locations = workspace:FindFirstChild("_WorldOrigin") and workspace._WorldOrigin:FindFirstChild("Locations")

		if not Locations then
			return "unknown"
		end

		local Name
		local movementvaluecreatedMovementDataState

		for _, child in ipairs(Locations:GetChildren()) do
			if child:IsA("BasePart") then
				local Magnitude = (child.Position - valueArgumentCached).Magnitude

				if not Name or Magnitude < movementvaluecreatedMovementDataState then
					Name = child.Name
					movementvaluecreatedMovementDataState = Magnitude
				end
			end
		end

		return Name and string.lower(Name) or "unknown"
	end
	local function enemyvaluetemporaryEnemyState(instance, valueArgumentSelected)
		local textValueCached = string.lower(tostring(valueArgumentSelected or ""))
		local textValueSelected = string.lower(tostring(instance.Name or ""))
		local textValueActive = string.lower(tostring(instance:GetAttribute("DisplayName") or ""))
		local enemyvaluetemporaryEnemy = textValueSelected .. " " .. textValueActive

		if resultmEntries[textValueCached] or textValueCached:find("fishman", 1, true) or textValueCached:find("underwater", 1, true) or textValueCached:find("sewer", 1, true) or enemyvaluetemporaryEnemy:find("boss", 1, true) then
			return true
		end

		return locationDataPrevious[textValueSelected] or locationDataPrevious[textValueActive]
	end
	local function enemyvaluelatestEnemy()
		local enemyvaluelatestEntries = {}
		local enemyvaluelatestEntriesState = {}
		local _WorldOrigin = workspace:FindFirstChild("_WorldOrigin")
		local EnemySpawns = _WorldOrigin and _WorldOrigin:FindFirstChild("EnemySpawns")

		if not EnemySpawns then
			return enemyvaluelatestEntries
		end

		for _, child in ipairs(EnemySpawns:GetChildren()) do
			local enemyvaluelatestEnemyState = movementvaluetrackedMovementData(child)

			if enemyvaluelatestEnemyState then
				local enemyvaluelatestEnemyData = movementvaluecreatedMovementData(enemyvaluelatestEnemyState)
				local textValueTarget = tostring(child:GetAttribute("DisplayName") or child.Name or "")

				if textValueTarget ~= "" and not enemyvaluetemporaryEnemyState(child, enemyvaluelatestEnemyData) then
					enemyvaluelatestEntriesState[enemyvaluelatestEnemyData] = enemyvaluelatestEntriesState[enemyvaluelatestEnemyData] or {}
					enemyvaluelatestEntriesState[enemyvaluelatestEnemyData][textValueTarget] = enemyvaluelatestEntriesState[enemyvaluelatestEnemyData][textValueTarget] or {}
					enemyvaluelatestEntriesState[enemyvaluelatestEnemyData][textValueTarget][#enemyvaluelatestEntriesState[enemyvaluelatestEnemyData][textValueTarget] + 1] = enemyvaluelatestEnemyState
				end
			end
		end

		local enemyvaluelatestEntriesData = {}

		for k in pairs(enemyvaluelatestEntriesState) do
			enemyvaluelatestEntriesData[#enemyvaluelatestEntriesData + 1] = k
		end

		table.sort(enemyvaluelatestEntriesData)

		for _, playervalueaiPlayerData in ipairs(enemyvaluelatestEntriesData) do
			local enemyvaluelatestResult = enemyvaluelatestEntriesState[playervalueaiPlayerData]
			local enemyvaluelatestEntriesEntry = {}
			local enemyvaluelatestMovementDataResponse, enemyvaluelatestMovementDataCandidate, enemyvaluelatestMovementDataPayload = pairs(enemyvaluelatestResult)

			for k in enemyvaluelatestMovementDataResponse, enemyvaluelatestMovementDataCandidate, enemyvaluelatestMovementDataPayload do
				enemyvaluelatestEntriesEntry[#enemyvaluelatestEntriesEntry + 1] = k
			end

			table.sort(enemyvaluelatestEntriesEntry)

			local Position
			local Locations = _WorldOrigin and _WorldOrigin:FindFirstChild("Locations")

			if Locations then
				local childInstancesK, childInstancesL, childInstancesM = ipairs(Locations:GetChildren())
				local enemyvaluelatestMovementDataReference = geniter(childInstancesK, childInstancesL, childInstancesM)

				while true do
					local enemyvaluelatestCallResults = table.pack(enemyvaluelatestMovementDataReference())

					if not enemyvaluelatestCallResults[1] then
						break
					end

					local enemyvaluelatestMovementDataState = enemyvaluelatestCallResults[3]

					if enemyvaluelatestMovementDataState:IsA("BasePart") and string.lower(enemyvaluelatestMovementDataState.Name) == playervalueaiPlayerData then
						Position = enemyvaluelatestMovementDataState.Position

						break
					end
				end
			end

			local enemyvaluelatestMovementDataItem, enemyvaluelatestMovementDataEntry, enemyvaluelatestMovementData = ipairs(enemyvaluelatestEntriesEntry)

			for _, getinfinityAbilityPlayerDataItem in enemyvaluelatestMovementDataItem, enemyvaluelatestMovementDataEntry, enemyvaluelatestMovementData do
				local enemyvaluelatestMovementDataData = enemyvaluelatestResult[getinfinityAbilityPlayerDataItem][1]

				if #enemyvaluelatestEntriesEntry > 1 then
					enemyvaluelatestEntries[#enemyvaluelatestEntries + 1] = {
						Island = playervalueaiPlayerData,
						Name = getinfinityAbilityPlayerDataItem,
						CFrame = CFrame.new(enemyvaluelatestMovementDataData + Vector3.new(0, 40, 0))
					}
				else
					local vector3 = Vector3.new(1, 0, 0)

					if Position then
						local vector32 = Vector3.new(enemyvaluelatestMovementDataData.X - Position.X, 0, enemyvaluelatestMovementDataData.Z - Position.Z)

						if vector32.Magnitude > 0.01 then
							vector3 = vector32.Unit
						end
					end

					enemyvaluelatestEntries[#enemyvaluelatestEntries + 1] = {
						Island = playervalueaiPlayerData,
						Name = getinfinityAbilityPlayerDataItem,
						CFrame = CFrame.new(enemyvaluelatestMovementDataData + vector3 * 60 + Vector3.new(0, 40, 0))
					}
					enemyvaluelatestEntries[#enemyvaluelatestEntries + 1] = {
						Island = playervalueaiPlayerData,
						Name = getinfinityAbilityPlayerDataItem,
						CFrame = CFrame.new(enemyvaluelatestMovementDataData - vector3 * 60 + Vector3.new(0, 40, 0))
					}
				end
			end
		end

		return enemyvaluelatestEntries
	end
	local function playervalueasPlayerData()
		local Enemies_ = workspace:FindFirstChild("Enemies")

		if not Enemies_ then
			return
		end

		local Character = game.Players.LocalPlayer.Character
		local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
		local playervalueasEnemy
		local playervalueasEnemyState

		for _, child in ipairs(Enemies_:GetChildren()) do
			if child:IsA("Model") and (child:GetAttribute("MagnetEnemy") == true or string.find(string.lower(child.Name), "magnetized")) and child:FindFirstChild("Humanoid") and child.Humanoid.Health > 0 and child:FindFirstChild("HumanoidRootPart") then
				local Magnitude = HumanoidRootPart and (child.HumanoidRootPart.Position - HumanoidRootPart.Position).Magnitude or 0

				if not playervalueasEnemy or Magnitude < playervalueasEnemyState then
					playervalueasEnemy = child
					playervalueasEnemyState = Magnitude
				end
			end
		end

		return playervalueasEnemy
	end
	local function enemyvalueresolvedEnemy(isEnabledActive)
		if not isEnabledActive or typeof(isEnabledActive.CFrame) ~= "CFrame" then
			return false
		end

		local LocalPlayer = game.Players.LocalPlayer
		local Character = LocalPlayer.Character
		local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

		if not HumanoidRootPart then
			return false
		end

		resultmResult("Patrolling - " .. tostring(isEnabledActive.Island))
		pcall(function()
			_tp(isEnabledActive.CFrame)
		end)

		local now = tick()
		local exitTo
		local enemyvalueresolvedMovementData

		while true do
			if not _G.AutoMagnetToken then
				exitTo = 1

				break
			end

			enemyvalueresolvedMovementData = playervalueasPlayerData()

			if enemyvalueresolvedMovementData then
				exitTo = 2

				break
			end

			local Character2 = LocalPlayer.Character
			local HumanoidRootPart2 = Character2 and Character2:FindFirstChild("HumanoidRootPart")

			if HumanoidRootPart2 then
				if not ((isEnabledActive.CFrame.Position - HumanoidRootPart2.Position).Magnitude <= 15) and not (tick() - now > 10) then
					task.wait(0.1)

					continue
				end

				exitTo = 1

				break
			end

			break
		end

		if exitTo ~= 1 then
			if exitTo == 2 then
				return enemyvalueresolvedMovementData
			end

			return false
		end

		if not _G.AutoMagnetToken then
			return false
		end

		resultmResult("Searching - " .. tostring(isEnabledActive.Island))

		local now2 = tick()

		while _G.AutoMagnetToken and tick() - now2 < 1 do
			local enemyvalueresolvedResult = playervalueasPlayerData()

			if enemyvalueresolvedResult then
				return enemyvalueresolvedResult
			end

			task.wait(0.05)
		end

		local enemyvalueresolvedResultState = playervalueasPlayerData() or false

		return enemyvalueresolvedResultState
	end

	GRP_Main_Update_30_Magnet_Token:AddToggle("Auto_Farm_Magnet_Token", {
		Text = "Auto Farm Magnet Token",
		Default = false,
		Callback = function(isAutoFarmMagnetTokenEnabled)
			_G.AutoMagnetToken = isAutoFarmMagnetTokenEnabled
			resultmResult(isAutoFarmMagnetTokenEnabled and "Starting..." or "Idle")

			if not isAutoFarmMagnetTokenEnabled then
				_G.MagnetEventSpawnIndex = 1
			end
		end
	})
	task.spawn(function()
		local magnetEventSpawnRoute = {}
		local magnetEventSpawnIndex = 1
		local isCallbackReadyDetails = true

		while task.wait() do
			if _G.AutoMagnetToken then
				if isCallbackReadyDetails or #magnetEventSpawnRoute == 0 then
					magnetEventSpawnRoute = enemyvaluelatestEnemy()

					if #magnetEventSpawnRoute == 0 then
						task.wait(5)

						continue
					end

					magnetEventSpawnIndex = _G.MagnetEventSpawnIndex or 1

					if magnetEventSpawnIndex > #magnetEventSpawnRoute then
						magnetEventSpawnIndex = 1
					end

					isCallbackReadyDetails = false
					_G.MagnetEventSpawnRoute = magnetEventSpawnRoute
				end

				local callbackResultInput = magnetEventSpawnRoute[magnetEventSpawnIndex]

				if not callbackResultInput then
					magnetEventSpawnIndex = 1
					callbackResultInput = magnetEventSpawnRoute[magnetEventSpawnIndex]
				end

				local callbackResultSource = enemyvalueresolvedEnemy(callbackResultInput)

				if callbackResultSource then
					resultmResult("Farming - " .. tostring(callbackResultSource.Name))

					while true do
						task.wait(0.1)

						if callbackResultSource.Parent and callbackResultSource:FindFirstChild("HumanoidRootPart") then
							_tp(callbackResultSource.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
							playerCollectionLatest.Kill(callbackResultSource, _G.AutoMagnetToken)

							if not _G.AutoMagnetToken or callbackResultSource.Humanoid.Health <= 0 or not callbackResultSource.Parent then
								break
							end
						else
							break
						end
					end

					magnetEventSpawnIndex += 1

					if magnetEventSpawnIndex > #magnetEventSpawnRoute then
						magnetEventSpawnIndex = 1
					end

					_G.MagnetEventSpawnIndex = magnetEventSpawnIndex
				else
					magnetEventSpawnIndex += 1

					if magnetEventSpawnIndex > #magnetEventSpawnRoute then
						magnetEventSpawnIndex = 1
					end

					_G.MagnetEventSpawnIndex = magnetEventSpawnIndex
					task.wait(0.2)
				end
			else
				resultmResult("Idle")
				_G.MagnetEventSpawnIndex = magnetEventSpawnIndex
				task.wait(1)
			end
		end
	end)
end

GRP_Settings_Settings_Configure = tabs.Settings:AddLeftGroupbox("Settings / Configure")

do
	Initialize = GRP_Settings_Settings_Configure:AddToggle("Fast_Attack", {
		Text = "Fast Attack",
		Default = true,
		Callback = function(isBringMobsEnabled)
			_G.Seriality = isBringMobsEnabled
		end
	})
end

do
	Bringmob = GRP_Settings_Settings_Configure:AddToggle("Bring_Mobs", {
		Text = "Bring Mobs",
		Default = true,
		Callback = function(isAutoHopServerWithTimeEnabled)
			_B = isAutoHopServerWithTimeEnabled
		end
	})
end

do
	GRP_Settings_Settings_Configure:AddToggle("Auto_Hop_Server_with_time", {
		Text = "Auto Hop Server with time",
		Default = false,
		Callback = function(isAutoHopServerWithTimeEnabledCurrent)
			_G.AutoHopServer = isAutoHopServerWithTimeEnabledCurrent

			if not isAutoHopServerWithTimeEnabledCurrent then
				_G.HopTimer = nil
			end
		end
	})
end

do
	Spawn(function()
		while Wait(1) do
			if _G.AutoHopServer then
				pcall(function()
					if not _G.HopTimer then
						_G.HopTimer = tick()
					end

					if _G.HopDelay <= tick() - _G.HopTimer then
						_G.HopTimer = tick()

						if syn and syn.queue_on_teleport then
							syn.queue_on_teleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/bloxfruitsnokey/Redz/refs/heads/main/Chest'))()")
						end

						game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
					end
				end)
			end
		end
	end)
end

do
	GRP_Settings_Settings_Configure:AddSlider({
		Text = "Hop Delay (Minutes)",
		Min = 5,
		Max = 120,
		Default = 30,
		Rounding = 0,
		Callback = function(isAutoSetSpawnPointEnabled)
			_G.HopDelay = isAutoSetSpawnPointEnabled * 60
		end
	})
end

do
	GRP_Settings_Settings_Configure:AddToggle("Auto_Set_Spawn_Point", {
		Text = "Auto Set Spawn Point",
		Default = false,
		Callback = function(isAutoSetSpawnPointEnabledCurrent)
			getgenv().Set = isAutoSetSpawnPointEnabledCurrent

			if isAutoSetSpawnPointEnabledCurrent then
				pcall(function()
					game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
				end)
			end
		end
	})
end

BusuAura = GRP_Settings_Settings_Configure:AddToggle("Auto_Turn_on_Buso", {
	Text = "Auto Turn on Buso",
	Default = true,
	Callback = function(isAutoTurnOnBusoEnabled)
		Boud = isAutoTurnOnBusoEnabled
	end
})

do
	spawn(function()
		while wait(Sec) do
			pcall(function()
				if Boud then
					local playerCollectionTarget = {
						"HasBuso",
						"Buso"
					}

					if not plr.Character:FindFirstChild(playerCollectionTarget[1]) then
						replicated.Remotes.CommF_:InvokeServer(playerCollectionTarget[2])
					end
				end
			end)
		end
	end)
end

do
	GRP_Settings_Settings_Configure:AddToggle("Auto_Haki_Observation", {
		Text = "Auto Haki Observation",
		Default = false,
		Callback = function(isAutoHakiObservationEnabled)
			getgenv().Observation = isAutoHakiObservationEnabled
		end
	})
end

spawn(function()
	while wait() do
		if getgenv().Observation then
			pcall(function()
				game:GetService("ReplicatedStorage").Remotes.CommE:FireServer("Ken", true)
			end)
		end
	end
end)
RaceV3Aura = GRP_Settings_Settings_Configure:AddToggle("AutoTurnonRaceV3", {
	Text = "Auto Turn on Race V3",
	Default = false,
	Callback = function(isAutoTurnOnRaceVEnabled)
		_G.RaceClickAutov3 = isAutoTurnOnRaceVEnabled
	end
})

do
	spawn(function()
		while wait(0.2) do
			pcall(function()
				if _G.RaceClickAutov3 then
					repeat
						replicated.Remotes.CommE:FireServer("ActivateAbility")
						wait(30)
					until not _G.RaceClickAutov3
				end
			end)
		end
	end)
end

do
	RaceV4Aura = GRP_Settings_Settings_Configure:AddToggle("Auto_Turn_on_Race_V4", {
		Text = "Auto Turn on Race V4",
		Default = false,
		Callback = function(isAutoTurnOnRaceVEnabledCurrent)
			_G.RaceClickAutov4 = isAutoTurnOnRaceVEnabledCurrent
		end
	})
end

spawn(function()
	while wait(0.2) do
		pcall(function()
			if _G.RaceClickAutov4 then
				if plr.Character:FindFirstChild("RaceEnergy") then
					if plr.Character:FindFirstChild("RaceEnergy").Value == 1 then
						Useskills("nil", "Y")
					end
				end
			end
		end)
	end
end)
RandomAround = GRP_Settings_Settings_Configure:AddToggle("Auto_Turn_on_Spin__xyz", {
	Text = "Auto Turn on Spin  xyz",
	Default = false,
	Callback = function(isSafeModeEnabled)
		RandomCFrame = isSafeModeEnabled
	end
})
SafeModes = GRP_Settings_Settings_Configure:AddToggle("Safe_Mode", {
	Text = "Safe Mode",
	Default = false,
	Callback = function(isSafeModeEnabledCurrent)
		_G.Safemode = isSafeModeEnabledCurrent
	end
})
spawn(function()
	while task.wait(Sec) do
		pcall(function()
			if _G.Safemode then
				if plr.Character.Humanoid.Health / plr.Character.Humanoid.MaxHealth * 100 < Num_self then
					shouldTween = true
					_tp(Root.CFrame * CFrame.new(0, 500, 0))
				else
					shouldTween = false
				end
			end
		end)
	end
end)

do
	DisableHitVFX = GRP_Settings_Settings_Configure:AddToggle("Remove_Hit_VFX", {
		Text = "Remove Hit VFX",
		Default = false,
		Callback = function(isRemoveHitVfxEnabled)
			_G.DestroyHit = isRemoveHitVfxEnabled
		end
	})
end

do
	local callbackEntriesCandidate = {
		"SlashHit",
		"CurvedRing",
		"SwordSlash",
		"SlashTail"
	}

	task.spawn(function()
		while task.wait(Sec) do
			if _G.DestroyHit then
				pcall(function()
					for _, child in pairs(workspace._WorldOrigin:GetChildren()) do
						if table.find(callbackEntriesCandidate, child.Name) then
							child:Destroy()
						end
					end
				end)
			end
		end
	end)
end

RmvVFX = GRP_Settings_Settings_Configure:AddToggle("Remove_Death_&_Respawned_VFX", {
	Text = "Remove Death & Respawned VFX",
	Default = false,
	Callback = function(isRemoveDeathRespawnedVfxEnabled)
		RDeath = isRemoveDeathRespawnedVfxEnabled
	end
})

do
	spawn(function()
		while wait(Sec) do
			pcall(function()
				if RDeath then
					if replicated.Effect.Container:FindFirstChild("Death") then
						replicated.Effect.Container.Death:Destroy()
					end

					if replicated.Effect.Container:FindFirstChild("Respawn") then
						replicated.Effect.Container.Respawn:Destroy()
					end
				end
			end)
		end
	end)
end

DisblesNotify = GRP_Settings_Settings_Configure:AddToggle("Disable_Notify", {
	Text = "Disable Notify",
	Default = false,
	Callback = function(isDisableNotifyEnabled)
		RemoveDamage = isDisableNotifyEnabled
	end
})
spawn(function()
	if wait(Sec) then
		repeat
			pcall(function()
				if RemoveDamage then
					replicated.Assets.GUI.DamageCounter.Enabled = false
					plr.PlayerGui.Notifications.Enabled = false
				else
					replicated.Assets.GUI.DamageCounter.Enabled = true
					plr.PlayerGui.Notifications.Enabled = true
				end
			end)
		until not wait(Sec)
	end
end)
GRP_Settings_Settings_Configure:AddToggle("Anti_AFK", {
	Text = "Anti AFK",
	Default = true,
	Callback = function(isAntiAfkEnabled)
		if isAntiAfkEnabled then
			local VirtualUser = game:GetService("VirtualUser")

			repeat
				wait()
			until game:IsLoaded()

			connectScoped(game:GetService("Players").LocalPlayer.Idled, function()
				VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
				wait(1)
				VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
			end)
		end
	end
})

do
	GRP_Settings_Settings_Configure:AddToggle("Auto_Anti_-_Admin_Join_Server", {
		Text = "Auto Anti - Admin Join Server",
		Default = true,
		Callback = function(isAutoAntiAdminJoinServerEnabled)
			getgenv().HopServerAdmin = isAutoAntiAdminJoinServerEnabled
		end
	})
end

spawn(function()
	while wait() do
		pcall(function()
			if getgenv().HopServerAdmin then
				for _, player in pairs(game.Players:GetPlayers()) do
					if table.find({
						"red_game43",
						"rip_indra",
						"Axiore",
						"Polkster",
						"wenlocktoad",
						"Daigrock",
						"toilamvidamme",
						"oofficialnoobie",
						"Uzoth",
						"Azarth",
						"arlthmetic",
						"Death_King",
						"Lunoven",
						"TheGreateAced",
						"rip_fud",
						"drip_mama",
						"layandikit12",
						"Hingoi"
					}, player.Name) then
						Hop()
					end
				end
			end
		end)
	end
end)

do
	GRP_Settings_Settings_Configure:AddToggle("No_Clip", {
		Text = "No Clip",
		Default = false,
		Callback = function(isNoClipEnabled)
			getgenv().NoClip = isNoClipEnabled
		end
	})
end

do
	spawn(function()
		pcall(function()
			connectScoped(game:GetService("RunService").Stepped, function()
				if getgenv().NoClip then
					for _, descendant in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
						if descendant:IsA("BasePart") or descendant:IsA("Part") then
							descendant.CanCollide = false
						end
					end
				end
			end)
		end)
	end)
end

GRP_Esp_Stats_Upgrade = tabs.Esp:AddLeftGroupbox("Stats Upgrade")
StatusSelect = GRP_Esp_Stats_Upgrade:AddSlider({
	Text = "Stats Value",
	Min = 0,
	Max = 1000,
	Default = 10,
	Rounding = 0,
	Callback = function(isAutoMeleeEnabled)
		pSats = isAutoMeleeEnabled
	end
})
StatsUpg = GRP_Esp_Stats_Upgrade:AddToggle("Auto_Melee", {
	Text = "Auto Melee",
	Default = false,
	Callback = function(isAutoMeleeEnabledCurrent)
		_G.Auto_Melee = isAutoMeleeEnabledCurrent
	end
})
spawn(function()
	while wait(Sec) do
		pcall(function()
			if _G.Auto_Melee then
				statsSetings("Melee", pSats)
			end
		end)
	end
end)
StatsUpg = GRP_Esp_Stats_Upgrade:AddToggle("Auto_Swords", {
	Text = "Auto Swords",
	Default = false,
	Callback = function(isAutoSwordsEnabled)
		_G.Auto_Sword = isAutoSwordsEnabled
	end
})
spawn(function()
	while wait(Sec) do
		pcall(function()
			if _G.Auto_Sword then
				statsSetings("Sword", pSats)
			end
		end)
	end
end)

do
	StatsUpg = GRP_Esp_Stats_Upgrade:AddToggle("Auto_Gun", {
		Text = "Auto Gun",
		Default = false,
		Callback = function(isAutoGunEnabled)
			_G.Auto_Gun = isAutoGunEnabled
		end
	})
end

do
	spawn(function()
		while wait(Sec) do
			pcall(function()
				if _G.Auto_Gun then
					statsSetings("Gun", pSats)
				end
			end)
		end
	end)
end

do
	StatsUpg = GRP_Esp_Stats_Upgrade:AddToggle("Auto_Blox_Fruit", {
		Text = "Auto Blox Fruit",
		Default = false,
		Callback = function(isAutoBloxFruitEnabled)
			_G.Auto_DevilFruit = isAutoBloxFruitEnabled
		end
	})
end

spawn(function()
	while wait(Sec) do
		pcall(function()
			if _G.Auto_DevilFruit then
				statsSetings("Devil", pSats)
			end
		end)
	end
end)

do
	StatsUpg = GRP_Esp_Stats_Upgrade:AddToggle("Auto_Defense", {
		Text = "Auto Defense",
		Default = false,
		Callback = function(isAutoDefenseEnabled)
			_G.Auto_Defense = isAutoDefenseEnabled
		end
	})
end

spawn(function()
	while wait(Sec) do
		pcall(function()
			if _G.Auto_Defense then
				statsSetings("Defense", pSats)
			end
		end)
	end
end)
GRP_Fish_Fishing = tabs.Fish:AddLeftGroupbox("Fishing")
GRP_Fish_Fishing:AddDropdown("Select_Fishing_Rod", {
	Text = "Select Fishing Rod",
	Values = {
		"Fishing Rod",
		"Gold Rod",
		"Shark Rod",
		"Shell Rod",
		"Treasure Rod"
	},
	Default = "Fishing Rod",
	Callback = function(selectedSelectBait)
		_G.SelectedRod = selectedSelectBait
	end
})
BaitDropdown = GRP_Fish_Fishing:AddDropdown("Select_Bait", {
	Text = "Select Bait",
	Values = {
		"Basic Bait",
		"Kelp Bait",
		"Good Bait",
		"Abyssal Bait",
		"Frozen Bait",
		"Epic Bait",
		"Carnivore Bait"
	},
	Default = "Basic Bait",
	Callback = function(selectedSelectBaitCurrent)
		_G.SelectedBait = selectedSelectBaitCurrent

		if _G.AutoBuyBait then
			pcall(function()
				locationDataAvailable.RFCraft:InvokeServer("Craft", _G.SelectedBait, {})
			end)
		end
	end
})
BuyBaitToggle = GRP_Fish_Fishing:AddToggle("Auto_Buy_Bait", {
	Text = "Auto Buy Bait",
	Default = false,
	Callback = function(isAutoBuyBaitEnabled)
		_G.AutoBuyBait = isAutoBuyBaitEnabled

		if isAutoBuyBaitEnabled then
			pcall(function()
				locationDataAvailable.RFCraft:InvokeServer("Craft", _G.SelectedBait, {})
			end)
		end
	end
})
task.spawn(function()
	while task.wait(2) do
		if _G.AutoBuyBait and _G.SelectedBait then
			local exitTo

			repeat
				pcall(function()
					locationDataAvailable.RFCraft:InvokeServer("Craft", _G.SelectedBait, {})
				end)
				exitTo = nil

				while task.wait(2) do
					if _G.AutoBuyBait and _G.SelectedBait then
						exitTo = 1

						break
					end
				end
			until exitTo ~= 1

			return
		end
	end
end)
FishingToggle = GRP_Fish_Fishing:AddToggle("Auto_Fishing", {
	Text = "Auto Fishing",
	Default = false,
	Callback = function(isAutoFishingEnabled)
		_G.AutoFishing = isAutoFishingEnabled
	end
})

local Players = game:GetService("Players")

do
	local LocalPlayer = Players.LocalPlayer
	local Workspace = game:GetService("Workspace")
	local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
	local FishReplicated = ReplicatedStorage2:WaitForChild("FishReplicated")
	local FishingRequest = FishReplicated:WaitForChild("FishingRequest")
	local Config = require(FishReplicated.FishingClient.Config)
	local GetWaterHeightAtLocation = require(ReplicatedStorage2.Util.GetWaterHeightAtLocation)
	local MaxLaunchDistance = Config.Rod.MaxLaunchDistance

	task.spawn(function()
		while task.wait(0.5) do
			if _G.AutoFishing then
				local exitTo

				repeat
					pcall(function()
						local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
						local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

						if not HumanoidRootPart then
							return
						end

						local Tool = Character:FindFirstChildOfClass("Tool")

						if _G.SelectedRod and (not Tool or Tool.Name ~= _G.SelectedRod) then
							local _GSelectedRod = LocalPlayer.Backpack:FindFirstChild(_G.SelectedRod)

							if _GSelectedRod then
								Character.Humanoid:EquipTool(_GSelectedRod)
								Tool = _GSelectedRod
							end
						end

						if Tool then
							local targetPositionSelected = GetWaterHeightAtLocation(HumanoidRootPart.Position)
							local _, targetCFrameCurrent = Workspace:FindPartOnRayWithIgnoreList(Ray.new(Character.Head.Position, HumanoidRootPart.CFrame.LookVector * MaxLaunchDistance), {
								Character,
								Workspace.Characters,
								Workspace.Enemies
							})
							local vector3 = targetCFrameCurrent and Vector3.new(targetCFrameCurrent.X, math.max(targetCFrameCurrent.Y, targetPositionSelected), targetCFrameCurrent.Z)
							local attribute = Tool:GetAttribute("State")
							local attribute2 = Tool:GetAttribute("ServerState")

							if vector3 and (attribute == "ReeledIn" or attribute2 == "ReeledIn") then
								FishingRequest:InvokeServer("StartCasting")
								task.wait()
								FishingRequest:InvokeServer("CastLineAtLocation", vector3, 100, true)
							elseif attribute2 == "Biting" then
								FishingRequest:InvokeServer("Catching", true)
								task.wait(0.1)
								FishingRequest:InvokeServer("Catch", 1)
							end
						end
					end)
					exitTo = nil

					while task.wait(0.5) do
						if _G.AutoFishing then
							exitTo = 1

							break
						end
					end
				until exitTo ~= 1

				return
			end
		end
	end)
end

do
	FishingQ = GRP_Fish_Fishing:AddToggle("Auto_Quest_Fishing", {
		Text = "Auto Quest Fishing",
		Default = false,
		Callback = function(isAutoQuestFishingEnabled)
			_G.AutoFishingQuest = isAutoQuestFishingEnabled
		end
	})
end

do
	local LocalPlayer = game:GetService("Players").LocalPlayer
	local RFJobsRemoteFunction = game:GetService("ReplicatedStorage").Modules.Net:WaitForChild("RF/JobsRemoteFunction")

	local function questvaluebQuestData()
		local Quest = LocalPlayer.PlayerGui:FindFirstChild("Quest") or LocalPlayer.PlayerGui:FindFirstChild("QuestGui")

		if Quest and Quest:FindFirstChild("Container") then
			if Quest.Container:FindFirstChild("QuestTitle") then
				return true
			end
		end

		return false
	end

	task.spawn(function()
		while task.wait(1) do
			if _G.AutoFishingQuest then
				local exitTo

				repeat
					pcall(function()
						if not questvaluebQuestData() then
							RFJobsRemoteFunction:InvokeServer("FishingNPC", "Angler", "AskQuest")
						end
					end)
					exitTo = nil

					while task.wait(1) do
						if _G.AutoFishingQuest then
							exitTo = 1

							break
						end
					end
				until exitTo ~= 1

				return
			end
		end
	end)
end

QuestToggle = GRP_Fish_Fishing:AddToggle("Auto_Complete_Quest", {
	Text = "Auto Complete Quest",
	Default = false,
	Callback = function(isAutoCompleteQuestEnabled)
		_G.AutoQuestComplete = isAutoCompleteQuestEnabled

		if isAutoCompleteQuestEnabled then
			pcall(function()
				locationDataAvailable.RFJobsRemoteFunction:InvokeServer("FishingNPC", "FinishQuest")
			end)
		end
	end
})

do
	task.spawn(function()
		while task.wait(5) do
			if _G.AutoQuestComplete then
				pcall(function()
					locationDataAvailable.RFJobsRemoteFunction:InvokeServer("FishingNPC", "FinishQuest")
				end)
			end
		end
	end)
end

SellFishToggle = GRP_Fish_Fishing:AddToggle("Auto_Sell_Fish", {
	Text = "Auto Sell Fish",
	Default = false,
	Callback = function(isAutoSellFishEnabled)
		_G.AutoSellFish = isAutoSellFishEnabled

		if isAutoSellFishEnabled then
			pcall(function()
				locationDataAvailable.RFJobsRemoteFunction:InvokeServer("FishingNPC", "SellFish")
			end)
		end
	end
})

do
	task.spawn(function()
		while task.wait(5) do
			if _G.AutoSellFish then
				pcall(function()
					locationDataAvailable.RFJobsRemoteFunction:InvokeServer("FishingNPC", "SellFish")
				end)
			end
		end
	end)
end

SpamSkillZ = GRP_Fish_Fishing:AddToggle("Auto_Spam_Skill_Z", {
	Text = "Auto Spam Skill Z",
	Default = false,
	Callback = function(isAutoSpamSkillZEnabled)
		_G.AutoSkillZ = isAutoSpamSkillZEnabled
	end
})

do
	local RFJobToolAbilities = game:GetService("ReplicatedStorage").Modules.Net:WaitForChild("RF/JobToolAbilities")

	task.spawn(function()
		while task.wait(0.5) do
			if _G.AutoSkillZ then
				pcall(function()
					RFJobToolAbilities:InvokeServer("Z", true)
				end)
			end
		end
	end)
end

GRP_Quests_Auto_Quest_Sea_2 = tabs.Quests:AddLeftGroupbox("Auto Quest Sea 2")

do
	TravelDress = GRP_Quests_Auto_Quest_Sea_2:AddToggle("Auto_Quest_Sea_2", {
		Text = "Auto Quest Sea 2",
		Default = false,
		Callback = function(isAutoQuestSeaEnabled)
			_G.TravelDres = isAutoQuestSeaEnabled
		end
	})
end

spawn(function()
	while wait(Sec) do
		pcall(function()
			if _G.TravelDres then
				if plr.Data.Level.Value >= 700 then
					if workspace.Map.Ice.Door.CanCollide == true and workspace.Map.Ice.Door.Transparency == 0 then
						replicated.Remotes.CommF_:InvokeServer("DressrosaQuestProgress", "Detective")
						EquipWeapon("Key")

						while true do
							wait()
							_tp(CFrame.new(1347.7124, 37.3751602, -1325.6488))

							if _G.TravelDres then
								if Root.Position == CFrame.new(1347.7124, 37.3751602, -1325.6488).Position then
									break
								end
							else
								break
							end
						end
					else
						if workspace.Map.Ice.Door.CanCollide ~= false then
							replicated.Remotes.CommF_:InvokeServer("TravelDressrosa")

							return
						end

						if workspace.Map.Ice.Door.Transparency == 1 then
							if Enemies:FindFirstChild("Ice Admiral") then
								for _, child in pairs(Enemies:GetChildren()) do
									if child.Name == "Ice Admiral" and playerCollectionLatest.Alive(child) then
										while true do
											task.wait()
											playerCollectionLatest.Kill(child, _G.TravelDres)

											if _G.TravelDres == false then
												break
											elseif child.Humanoid.Health <= 0 then
												break
											end
										end

										replicated.Remotes.CommF_:InvokeServer("TravelDressrosa")
									end
								end
							else
								_tp(CFrame.new(1347.7124, 37.3751602, -1325.6488))
							end
						else
							replicated.Remotes.CommF_:InvokeServer("TravelDressrosa")
						end
					end
				end
			end
		end)
	end
end)
Zou = GRP_Quests_Auto_Quest_Sea_2:AddToggle("Auto_Quest_Sea_3", {
	Text = "Auto Quest Sea 3",
	Default = false,
	Callback = function(isAutoQuestSeaEnabledCurrent)
		_G.AutoZou = isAutoQuestSeaEnabledCurrent
	end
})
spawn(function()
	while wait(Sec) do
		pcall(function()
			if _G.AutoZou and plr.Data.Level.Value >= 1500 then
				if replicated.Remotes.CommF_:InvokeServer("BartiloQuestProgress", "Bartilo") == 3 then
					if replicated.Remotes.CommF_:InvokeServer("GetUnlockables").FlamingoAccess ~= nil then
						replicated.Remotes.CommF_:InvokeServer("F_", "TravelZou")

						if replicated.Remotes.CommF_:InvokeServer("ZQuestProgress", "Check") == 0 then
							local ripIndra = GetConnectionEnemies("rip_indra")

							if ripIndra then
								while true do
									wait()
									playerCollectionLatest.Kill(ripIndra, _G.AutoZou)

									if _G.AutoZou then
										if not ripIndra.Parent or ripIndra.Humanoid.Health <= 0 then
											break
										end
									else
										break
									end
								end

								Check = 2

								repeat
									wait()
									replicated.Remotes.CommF_:InvokeServer("F_", "TravelZou")
								until Check == 1
							else
								replicated.Remotes.CommF_:InvokeServer("F_", "ZQuestProgress", "Check")
								wait(0.1)
								replicated.Remotes.CommF_:InvokeServer("F_", "ZQuestProgress", "Begin")
							end
						elseif replicated.Remotes.CommF_:InvokeServer("ZQuestProgress", "Check") == 1 then
							replicated.Remotes.CommF_:InvokeServer("F_", "TravelZou")
						else
							local callbackQuestDataState = GetConnectionEnemies("Don Swan")

							if callbackQuestDataState then
								while true do
									wait()
									playerCollectionLatest.Kill(callbackQuestDataState, _G.AutoZou)

									if _G.AutoZou then
										if not callbackQuestDataState.Parent or callbackQuestDataState.Humanoid.Health <= 0 then
											break
										end
									else
										break
									end
								end
							else
								while true do
									wait()
									_tp(CFrame.new(2288.802, 15.1870775, 863.034607))

									if _G.AutoZou then
										if Root.Position == CFrame.new(2288.802, 15.1870775, 863.034607).Position then
											break
										end
									else
										break
									end
								end

								if Root.CFrame == CFrame.new(2288.802, 15.1870775, 863.034607) then
									notween(CFrame.new(2288.802, 15.1870775, 863.034607))
								end
							end
						end
					elseif replicated.Remotes.CommF_:InvokeServer("GetUnlockables").FlamingoAccess == nil then
						TabelDevilFruitStore = {}
						TabelDevilFruitOpen = {}

						for _, playervalueaiPlayerData in pairs(replicated.Remotes.CommF_:InvokeServer("getInventoryFruits")) do
							for k, getinfinityAbilityPlayerDataItem in pairs(playervalueaiPlayerData) do
								if k == "Name" then
									table.insert(TabelDevilFruitStore, getinfinityAbilityPlayerDataItem)
								end
							end
						end

						local next_ = next
						local response, serverResponseActive = game.ReplicatedStorage:WaitForChild("Remotes").CommF_:InvokeServer("GetFruits")

						for _, playervalueaiPlayerData in next_, response, serverResponseActive do
							if playervalueaiPlayerData.Price >= 1000000 then
								table.insert(TabelDevilFruitOpen, playervalueaiPlayerData.Name)
							end
						end

						for _, playervalueaiPlayerData in pairs(TabelDevilFruitOpen) do
							for _, getinfinityAbilityPlayerDataItem in pairs(TabelDevilFruitStore) do
								if playervalueaiPlayerData == getinfinityAbilityPlayerDataItem then
									if replicated.Remotes.CommF_:InvokeServer("GetUnlockables").FlamingoAccess == nil then
										if plr.Backpack:FindFirstChild(getinfinityAbilityPlayerDataItem) then
											replicated.Remotes.CommF_:InvokeServer("F_", "TalkTrevor", "1")
											replicated.Remotes.CommF_:InvokeServer("F_", "TalkTrevor", "2")
											replicated.Remotes.CommF_:InvokeServer("F_", "TalkTrevor", "3")
										else
											replicated.Remotes.CommF_:InvokeServer("F_", "LoadFruit", getinfinityAbilityPlayerDataItem)
										end
									end
								end
							end
						end

						replicated.Remotes.CommF_:InvokeServer("F_", "TalkTrevor", "1")
						replicated.Remotes.CommF_:InvokeServer("F_", "TalkTrevor", "2")
						replicated.Remotes.CommF_:InvokeServer("F_", "TalkTrevor", "3")
					end
				elseif replicated.Remotes.CommF_:InvokeServer("BartiloQuestProgress", "Bartilo") == 0 then
					if string.find(plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Swan Pirates") and string.find(plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "50") and plr.PlayerGui.Main.Quest.Visible == true then
						local callbackQuestDataItem = GetConnectionEnemies("Swan Pirate")

						if callbackQuestDataItem then
							pcall(function()
								while true do
									wait()
									playerCollectionLatest.Kill(callbackQuestDataItem, _G.AutoZou)

									if callbackQuestDataItem.Parent then
										if callbackQuestDataItem.Humanoid.Health <= 0 or _G.AutoZou == false or plr.PlayerGui.Main.Quest.Visible == false then
											break
										end
									else
										break
									end
								end
							end)
						else
							_tp(CFrame.new(1057.92761, 137.614319, 1242.08069))
						end
					else
						_tp(CFrame.new(-456.28952, 73.0200958, 299.895966))
					end
				elseif replicated.Remotes.CommF_:InvokeServer("BartiloQuestProgress", "Bartilo") == 1 then
					local Jeremy = GetConnectionEnemies("Jeremy")

					if Jeremy then
						while true do
							wait()
							playerCollectionLatest.Kill(Jeremy, _G.AutoZou)

							if Jeremy.Parent then
								if Jeremy.Humanoid.Health <= 0 or _G.AutoZou == false then
									break
								end
							else
								break
							end
						end
					else
						_tp(CFrame.new(2099.88159, 448.931, 648.997375))
					end
				elseif replicated.Remotes.CommF_:InvokeServer("BartiloQuestProgress", "Bartilo") == 2 then
					while true do
						wait()
						_tp(CFrame.new(-1836, 11, 1714))

						if _G.AutoZou then
							if Root.Position == CFrame.new(-1836, 11, 1714).Position then
								break
							end
						else
							break
						end
					end

					if Root.CFrame == CFrame.new(-1836, 11, 1714) then
						notween(CFrame.new(-1836, 11, 1714))
					end

					notween(CFrame.new(-1850.49329, 13.1789551, 1750.89685))
					wait(0.1)
					notween(CFrame.new(-1858.87305, 19.3777466, 1712.01807))
					wait(0.1)
					notween(CFrame.new(-1803.94324, 16.5789185, 1750.89685))
					wait(0.1)
					notween(CFrame.new(-1858.55835, 16.8604317, 1724.79541))
					wait(0.1)
					notween(CFrame.new(-1869.54224, 15.987854, 1681.00659))
					wait(0.1)
					notween(CFrame.new(-1800.0979, 16.4978027, 1684.52368))
					wait(0.1)
					notween(CFrame.new(-1819.26343, 14.795166, 1717.90625))
					wait(0.1)
					notween(CFrame.new(-1813.51843, 14.8604736, 1724.79541))
				end
			end
		end)
	end
end)
GRP_Quests_Tushita_Yama = tabs.Quests:AddLeftGroupbox("Tushita + Yama")
Q = GRP_Quests_Tushita_Yama:AddToggle("Auto_Tushita_Sword", {
	Text = "Auto Tushita Sword",
	Default = false,
	Callback = function(isAutoTushitaSwordEnabled)
		_G.Auto_Tushita = isAutoTushitaSwordEnabled
	end
})

do
	spawn(function()
		while wait(Sec) do
			pcall(function()
				if _G.Auto_Tushita then
					if workspace.Map.Turtle:FindFirstChild("TushitaGate") then
						if GetBP("Holy Torch") then
							EquipWeapon("Holy Torch")
							task.wait(1)

							while true do
								task.wait()
								_tp(CFrame.new(-10752, 417, -9366))

								if _G.Auto_Tushita then
									if (CFrame.new(-10752, 417, -9366).Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10 then
										break
									end
								else
									break
								end
							end

							wait(0.7)

							while true do
								task.wait()
								_tp(CFrame.new(-11672, 334, -9474))

								if _G.Auto_Tushita then
									if (CFrame.new(-11672, 334, -9474).Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10 then
										break
									end
								else
									break
								end
							end

							wait(0.7)

							while true do
								task.wait()
								_tp(CFrame.new(-12132, 521, -10655))

								if _G.Auto_Tushita then
									if (CFrame.new(-12132, 521, -10655).Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10 then
										break
									end
								else
									break
								end
							end

							wait(0.7)

							while true do
								task.wait()
								_tp(CFrame.new(-13336, 486, -6985))

								if _G.Auto_Tushita then
									if (CFrame.new(-13336, 486, -6985).Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10 then
										break
									end
								else
									break
								end
							end

							wait(0.7)

							while true do
								task.wait()
								_tp(CFrame.new(-13489, 332, -7925))

								if _G.Auto_Tushita then
									if (CFrame.new(-13489, 332, -7925).Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10 then
										break
									end
								else
									break
								end
							end
						else
							_tp(CFrame.new(5148.03613, 162.352493, 910.548218))
							wait(0.7)
						end
					else
						local Longma = GetConnectionEnemies("Longma")

						if Longma then
							while true do
								task.wait()
								playerCollectionLatest.Kill(Longma, _G.Auto_Tushita)

								if Longma.Humanoid.Health <= 0 then
									break
								elseif not _G.Auto_Tushita or not Longma.Parent then
									break
								end
							end
						elseif replicated:FindFirstChild("Longma") then
							_tp(replicated:FindFirstChild("Longma").HumanoidRootPart.CFrame * CFrame.new(0, 40, 0))
						end
					end
				end
			end)
		end
	end)
end

do
	Q = GRP_Quests_Tushita_Yama:AddToggle("Auto_Yama_Sword", {
		Text = "Auto Yama Sword",
		Default = false,
		Callback = function(isAutoYamaSwordEnabled)
			_G.Auto_Yama = isAutoYamaSwordEnabled
		end
	})
end

do
	spawn(function()
		while wait(Sec) do
			pcall(function()
				if _G.Auto_Yama then
					if replicated.Remotes.CommF_:InvokeServer("EliteHunter", "Progress") < 30 then
						_G.FarmEliteHunt = true
					elseif replicated.Remotes.CommF_:InvokeServer("EliteHunter", "Progress") > 30 then
						_G.FarmEliteHunt = false

						if (workspace.Map.Waterfall.SealedKatana.Handle.Position - plr.Character.HumanoidRootPart.Position).Magnitude >= 20 then
							_tp(workspace.Map.Waterfall.SealedKatana.Handle.CFrame)

							local Ghost = GetConnectionEnemies("Ghost")

							if Ghost then
								while true do
									wait()
									playerCollectionLatest.Kill(Ghost, _G.Auto_Yama)

									if Ghost.Humanoid.Health <= 0 then
										break
									elseif not Ghost.Parent or not _G.Auto_Yama then
										break
									end
								end

								fireclickdetector(workspace.Map.Waterfall.SealedKatana.Handle.ClickDetector)
							end
						end
					end
				end
			end)
		end
	end)
end

GRP_Quests_Skull_Guitars_Misc = tabs.Quests:AddLeftGroupbox("Skull Guitars / Misc")

do
	local grpQuestsSkullGuitarsMiscData = GRP_Quests_Skull_Guitars_Misc:AddLabel("")

	spawn(function()
		while wait(0.2) do
			pcall(function()
				if Quest1 == true then
					grpQuestsSkullGuitarsMiscData:SetText("Quest Number : Quest1")
				elseif Quest2 == true then
					grpQuestsSkullGuitarsMiscData:SetText("Quest Number : Quest2")
				elseif Quest3 == true then
					grpQuestsSkullGuitarsMiscData:SetText("Quest Number : Quest3")
				elseif Quest4 == true then
					grpQuestsSkullGuitarsMiscData:SetText("Quest Number : Quest4")
				elseif GetWP("Skull Guitar") then
					grpQuestsSkullGuitarsMiscData:SetText("Quest Number : Collect!!")
				else
					grpQuestsSkullGuitarsMiscData:SetText("Quest Number : No Quest!!")
				end
			end)
		end
	end)
end

do
	GRP_Quests_Skull_Guitars_Misc:AddToggle("Auto_Skull_Guitar", {
		Text = "Auto Skull Guitar",
		Default = false,
		Callback = function(isAutoSkullGuitarEnabled)
			_G.Auto_Soul_Guitar = isAutoSkullGuitarEnabled
		end
	})
end

do
	task.spawn(function()
		while wait() do
			if _G.Auto_Soul_Guitar then
				pcall(function()
					local callbackMovementDataEntry = GetConnectionEnemies("Living Zombie")

					if callbackMovementDataEntry then
						callbackMovementDataEntry.HumanoidRootPart.CFrame = CFrame.new(-10138.3974609375, 138.6524658203125, 5902.89208984375)
						callbackMovementDataEntry.Head.CanCollide = false
						callbackMovementDataEntry.Humanoid.Sit = false
						callbackMovementDataEntry.HumanoidRootPart.CanCollide = false
						callbackMovementDataEntry.Humanoid.JumpPower = 0
						callbackMovementDataEntry.Humanoid.WalkSpeed = 0

						if callbackMovementDataEntry.Humanoid:FindFirstChild("Animator") then
							callbackMovementDataEntry.Humanoid:FindFirstChild("Animator"):Destroy()
						end
					end
				end)
			end
		end
	end)
end

do
	getT = function(gettInput)
		local Rotation

		if gettInput == 1 then
			Rotation = workspace.Map["Haunted Castle"].Tablet.Segment1.Line.Rotation
		elseif gettInput == 3 then
			Rotation = workspace.Map["Haunted Castle"].Tablet.Segment3.Line.Rotation
		elseif gettInput == 4 then
			Rotation = workspace.Map["Haunted Castle"].Tablet.Segment4.Line.Rotation
		elseif gettInput == 7 then
			Rotation = workspace.Map["Haunted Castle"].Tablet.Segment7.Line.Rotation
		elseif gettInput == 10 then
			Rotation = workspace.Map["Haunted Castle"].Tablet.Segment10.Line.Rotation
		end

		if Rotation then
			return Rotation.Z
		end
	end
end

do
	getRT = function(getrtInput)
		local Rotation

		for _, child in pairs(workspace.Map["Haunted Castle"].Trophies.Quest:GetChildren()) do
			if getrtInput == 1 and child.Name == "Trophy1" and child:FindFirstChild("Handle") then
				Rotation = child.Handle.Rotation
			elseif getrtInput == 2 and child.Name == "Trophy2" and child:FindFirstChild("Handle") then
				Rotation = child.Handle.Rotation
			elseif getrtInput == 3 and child.Name == "Trophy3" and child:FindFirstChild("Handle") then
				Rotation = child.Handle.Rotation
			elseif getrtInput == 4 and child.Name == "Trophy4" and child:FindFirstChild("Handle") then
				Rotation = child.Handle.Rotation
			elseif getrtInput == 5 and child.Name == "Trophy5" and child:FindFirstChild("Handle") then
				Rotation = child.Handle.Rotation
			end

			if Rotation then
				return Rotation.Z
			end
		end
	end
end

do
	GetFirePlacard = function(getfireplacardInput, getfireplacardInputState)
		if tostring(workspace.Map["Haunted Castle"]["Placard" .. getfireplacardInput][getfireplacardInputState].Indicator.BrickColor) ~= "Pearl" then
			fireclickdetector(workspace.Map["Haunted Castle"]["Placard" .. getfireplacardInput][getfireplacardInputState].ClickDetector)
		end
	end
end

do
	spawn(function()
		repeat
			task.wait()
		until _G.Auto_Soul_Guitar

		while wait(Sec) do
			pcall(function()
				if _G.Auto_Soul_Guitar and World3 then
					replicated.Remotes.CommF_:InvokeServer("gravestoneEvent", 2)
					replicated.Remotes.CommF_:InvokeServer("gravestoneEvent", 2, true)

					if replicated.Remotes.CommF_:InvokeServer("GuitarPuzzleProgress", "Check") == nil then
						_tp(CFrame.new(-8655.0166015625, 141.31669616699219, 6160.0224609375))
						replicated.Remotes.CommF_:InvokeServer("gravestoneEvent", 2)
						replicated.Remotes.CommF_:InvokeServer("gravestoneEvent", 2, true)
					elseif replicated.Remotes.CommF_:InvokeServer("GuitarPuzzleProgress", "Check").Swamp == false then
						Quest1 = true
						Quest2 = false
						Quest3 = false
						Quest4 = false

						local getfireplacardQuestData = GetConnectionEnemies("Living Zombie")

						if getfireplacardQuestData then
							while true do
								task.wait()
								playerCollectionLatest.Kill(getfireplacardQuestData, _G.Auto_Soul_Guitar)

								if _G.Auto_Soul_Guitar then
									if getfireplacardQuestData.Humanoid.Health <= 0 or not getfireplacardQuestData.Parent or workspace.Map["Haunted Castle"].SwampWater.Color ~= Color3.fromRGB(117, 0, 0) then
										break
									end
								else
									break
								end
							end
						else
							_tp(CFrame.new(-10170.7275390625, 138.6524658203125, 5934.26513671875))
						end
					elseif replicated.Remotes.CommF_:InvokeServer("GuitarPuzzleProgress", "Check").Gravestones == false then
						Quest1 = false
						Quest2 = true
						Quest3 = false
						Quest4 = false
						GetFirePlacard("7", "Left")
						GetFirePlacard("6", "Left")
						GetFirePlacard("5", "Left")
						GetFirePlacard("4", "Right")
						GetFirePlacard("3", "Left")
						GetFirePlacard("2", "Right")
						GetFirePlacard("1", "Right")
					elseif replicated.Remotes.CommF_:InvokeServer("GuitarPuzzleProgress", "Check").Ghost == false then
						replicated.Remotes.CommF_:InvokeServer("GuitarPuzzleProgress", "Ghost")
						replicated.Remotes.CommF_:InvokeServer("GuitarPuzzleProgress", "Ghost", true)
					elseif replicated.Remotes.CommF_:InvokeServer("GuitarPuzzleProgress", "Check").Trophies == false then
						Quest1 = false
						Quest2 = false
						Quest3 = true
						Quest4 = false
						_tp(CFrame.new(-9532.8232421875, 6.4716677665710449, 6078.068359375))

						local getfireplacardQuestDataState, getfireplacardQuestDataData

						repeat
							wait()
							getfireplacardQuestDataData = getRT(1)
							getfireplacardQuestDataState = getT(1)

							if getfireplacardQuestDataData and getfireplacardQuestDataState then
								fireclickdetector(workspace.Map["Haunted Castle"].Tablet.Segment1:FindFirstChild("ClickDetector"))
							end
						until getfireplacardQuestDataData == getfireplacardQuestDataState

						local getfireplacardResultItem, getfireplacardResultCandidate

						repeat
							wait()
							getfireplacardResultCandidate = getRT(2)
							getfireplacardResultItem = getT(3)

							if getfireplacardResultCandidate and getfireplacardResultItem then
								fireclickdetector(workspace.Map["Haunted Castle"].Tablet.Segment3:FindFirstChild("ClickDetector"))
							end
						until getfireplacardResultCandidate == getfireplacardResultItem

						local getfireplacardResultReference, getfireplacardResultResponse

						repeat
							wait()
							getfireplacardResultResponse = getRT(3)
							getfireplacardResultReference = getT(4)

							if getfireplacardResultResponse and getfireplacardResultReference then
								fireclickdetector(workspace.Map["Haunted Castle"].Tablet.Segment4:FindFirstChild("ClickDetector"))
							end
						until getfireplacardResultResponse == getfireplacardResultReference

						local getfireplacardResult, getfireplacardResultState

						repeat
							wait()
							getfireplacardResultState = getRT(4)
							getfireplacardResult = getT(7)

							if getfireplacardResultState and getfireplacardResult then
								fireclickdetector(workspace.Map["Haunted Castle"].Tablet.Segment7:FindFirstChild("ClickDetector"))
							end
						until getfireplacardResultState == getfireplacardResult

						local getfireplacardResultData, getfireplacardResultEntry

						repeat
							wait()
							getfireplacardResultEntry = getRT(5)
							getfireplacardResultData = getT(10)

							if getfireplacardResultEntry and getfireplacardResultData then
								fireclickdetector(workspace.Map["Haunted Castle"].Tablet.Segment10:FindFirstChild("ClickDetector"))
							end
						until getfireplacardResultEntry == getfireplacardResultData

						while true do
							wait()
							fireclickdetector(workspace.Map["Haunted Castle"].Tablet.Segment2:FindFirstChild("ClickDetector"))
							fireclickdetector(workspace.Map["Haunted Castle"].Tablet.Segment5:FindFirstChild("ClickDetector"))
							fireclickdetector(workspace.Map["Haunted Castle"].Tablet.Segment6:FindFirstChild("ClickDetector"))
							fireclickdetector(workspace.Map["Haunted Castle"].Tablet.Segment8:FindFirstChild("ClickDetector"))
							fireclickdetector(workspace.Map["Haunted Castle"].Tablet.Segment9:FindFirstChild("ClickDetector"))

							if workspace.Map["Haunted Castle"].Tablet.Segment2.Line.Rotation.Z == 0 then
								break
							elseif workspace.Map["Haunted Castle"].Tablet.Segment5.Line.Rotation.Z == 0 or workspace.Map["Haunted Castle"].Tablet.Segment6.Line.Rotation.Z == 0 or workspace.Map["Haunted Castle"].Tablet.Segment8.Line.Rotation.Z == 0 or workspace.Map["Haunted Castle"].Tablet.Segment9.Line.Rotation.Z == 0 then
								break
							end
						end
					elseif replicated.Remotes.CommF_:InvokeServer("GuitarPuzzleProgress", "Check").Pipes == false then
						Quest1 = false
						Quest2 = false
						Quest3 = false
						Quest4 = true
						_tp(workspace.Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part3.CFrame)
						fireclickdetector(workspace.Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part3.ClickDetector)
						_tp(workspace.Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part4.CFrame)
						fireclickdetector(workspace.Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part4.ClickDetector)
						fireclickdetector(workspace.Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part4.ClickDetector)
						fireclickdetector(workspace.Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part4.ClickDetector)
						_tp(workspace.Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part6.CFrame)
						fireclickdetector(workspace.Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part6.ClickDetector)
						fireclickdetector(workspace.Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part6.ClickDetector)
						_tp(workspace.Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part8.CFrame)
						fireclickdetector(workspace.Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part8.ClickDetector)
						_tp(workspace.Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part10.CFrame)
						fireclickdetector(workspace.Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part10.ClickDetector)
						fireclickdetector(workspace.Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part10.ClickDetector)
						fireclickdetector(workspace.Map["Haunted Castle"]["Lab Puzzle"].ColorFloor.Model.Part10.ClickDetector)
					end
				end
			end)
		end
	end)
end

do
	GRP_Quests_Skull_Guitars_Misc:AddToggle("Auto_Farm_Material_Skull_Guitar", {
		Text = "Auto Farm Material Skull Guitar",
		Default = false,
		Callback = function(isAutoFarmMaterialSkullGuitarEnabled)
			_G.AutoMatSoul = isAutoFarmMaterialSkullGuitarEnabled
		end
	})
end

spawn(function()
	while wait(Sec) do
		pcall(function()
			if _G.AutoMatSoul and GetWP("Skull Guitar") == false then
				if GetM("Bones") >= 500 and GetM("Ectoplasm") >= 250 and GetM("Dark Fragment") >= 1 then
					replicated.Remotes.CommF_:InvokeServer("soulGuitarBuy", true)
				elseif not (GetM("Ectoplasm") <= 250) then
					if GetM("Dark Fragment") < 1 then
						if _G.AutoMatSoul and World2 then
							local Darkbeard = GetConnectionEnemies("Darkbeard")

							if Darkbeard then
								while true do
									task.wait()
									playerCollectionLatest.Kill(Darkbeard, _G.AutoMatSoul)

									if _G.AutoMatSoul then
										break
									elseif Darkbeard.Humanoid.Health <= 0 then
										break
									end
								end
							else
								_tp(CFrame.new(3798.4575195313, 13.826690673828, -3399.806640625))
							end
						else
							replicated.Remotes.CommF_:InvokeServer("TravelDressrosa")
						end

						if not GetConnectionEnemies("Darkbeard") then
							Hop()
						end
					elseif GetM("Bones") <= 500 then
						if _G.AutoMatSoul and World3 then
							local callbackMovementDataItem = GetConnectionEnemies({
								"Reborn Skeleton",
								"Living Zombie",
								"Demonic Soul",
								"Posessed Mummy"
							})

							if callbackMovementDataItem then
								while true do
									task.wait()
									playerCollectionLatest.Kill(callbackMovementDataItem, _G.AutoMatSoul)

									if _G.AutoMatSoul then
										if callbackMovementDataItem.Humanoid.Health <= 0 or not callbackMovementDataItem.Parent or callbackMovementDataItem.Humanoid.Health <= 0 then
											break
										end
									else
										break
									end
								end
							else
								_tp(CFrame.new(-9504.8564453125, 172.14292907714844, 6057.259765625))
							end
						else
							replicated.Remotes.CommF_:InvokeServer("TravelZou")
						end
					end
				elseif _G.AutoMatSoul and World2 then
					local callbackMovementDataReference = GetConnectionEnemies({
						"Ship Deckhand",
						"Ship Engineer",
						"Ship Steward",
						"Ship Officer",
						"Arctic Warrior"
					})

					if callbackMovementDataReference then
						while true do
							task.wait()
							playerCollectionLatest.Kill(callbackMovementDataReference, _G.AutoMatSoul)

							if _G.AutoMatSoul then
								if not callbackMovementDataReference.Parent or callbackMovementDataReference.Humanoid.Health <= 0 then
									break
								end
							else
								break
							end
						end
					else
						replicated.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
					end
				else
					replicated.Remotes.CommF_:InvokeServer("TravelDressrosa")
				end
			end
		end)
	end
end)
GRP_Quests_Cursed_Dual_Katana = tabs.Quests:AddLeftGroupbox("Cursed Dual Katana")

do
	local questNumbersStatusLabel = GRP_Quests_Cursed_Dual_Katana:AddLabel("Quest Numbers :")

	spawn(function()
		while wait(0.2) do
			if QuestYama_1 == true then
				questNumbersStatusLabel:SetText("Quest Numbers : yama quest 1")
			elseif QuestYama_2 == true then
				questNumbersStatusLabel:SetText("Quest Numbers : yama quest 2")
			elseif QuestYama_3 == true then
				questNumbersStatusLabel:SetText("Quest Numbers : yama quest 3")
			elseif QuestTushita_1 == true then
				questNumbersStatusLabel:SetText("Quest Numbers : tushita quest 1")
			elseif QuestTushita_2 == true then
				questNumbersStatusLabel:SetText("Quest Numbers : tushita quest 2")
			elseif GetWP("Cursed Dual Katana") then
				questNumbersStatusLabel:SetText("Quest Numbers : CDK done!!")
			end
		end
	end)
end

do
	Q = GRP_Quests_Cursed_Dual_Katana:AddToggle("Auto_Get_CDK_[_Last_Quest_]", {
		Text = "Auto Get CDK [ Last Quest ]",
		Default = false,
		Callback = function(isAutoGetCdkLastQuestEnabled)
			_G.CDK = isAutoGetCdkLastQuestEnabled
		end
	})
end

do
	spawn(function()
		if wait(Sec) then
			repeat
				pcall(function()
					if _G.CDK then
						replicated.Remotes.CommF_:InvokeServer("CDKQuest", "Progress", "Good")
						replicated.Remotes.CommF_:InvokeServer("CDKQuest", "Progress", "Evil")
						replicated.Remotes.CommF_:InvokeServer("CDKQuest", "StartTrial", "Boss")

						local callbackQuestDataCandidate = GetConnectionEnemies("Cursed Skeleton Boss")

						if callbackQuestDataCandidate then
							repeat
								wait()

								if plr.Character:FindFirstChild("Yama") then
									EquipWeapon("Yama")
								else
									if plr.Backpack:FindFirstChild("Yama") then
										EquipWeapon("Yama")
										_tp(callbackQuestDataCandidate.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0))

										if not _G.CDK or not callbackQuestDataCandidate.Parent or callbackQuestDataCandidate.Humanoid.Health <= 0 then
											break
										end
									end

									if plr.Character:FindFirstChild("Tushita") then
										EquipWeapon("Tushita")
									elseif plr.Backpack:FindFirstChild("Tushita") then
										EquipWeapon("Tushita")
										_tp(callbackQuestDataCandidate.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0))

										if not _G.CDK or not callbackQuestDataCandidate.Parent or callbackQuestDataCandidate.Humanoid.Health <= 0 then
											break
										end
									end
								end

								_tp(callbackQuestDataCandidate.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0))
							until not _G.CDK or not callbackQuestDataCandidate.Parent or callbackQuestDataCandidate.Humanoid.Health <= 0
						else
							_tp(CFrame.new(-12318.193359375, 601.95184326171875, -6538.662109375))
							wait(0.5)
							_tp(workspace.Map.Turtle.Cursed.BossDoor.CFrame)
						end
					end
				end)
			until not wait(Sec)
		end
	end)
end

Q = GRP_Quests_Cursed_Dual_Katana:AddToggle("Auto_Yama_CDK", {
	Text = "Auto Yama CDK",
	Default = false,
	Callback = function(isAutoYamaCdkEnabled)
		_G.CDK_YM = isAutoYamaCdkEnabled
	end
})

do
	spawn(function()
		while wait() do
			pcall(function()
				if _G.CDK_YM then
					if tostring(replicated.Remotes.CommF_:InvokeServer("CDKQuest", "OpenDoor")) ~= "opened" then
						replicated.Remotes.CommF_:InvokeServer("CDKQuest", "OpenDoor")
						replicated.Remotes.CommF_:InvokeServer("CDKQuest", "OpenDoor", true)
					elseif replicated.Remotes.CommF_:InvokeServer("CDKQuest", "Progress").Finished == nil then
						replicated.Remotes.CommF_:InvokeServer("CDKQuest", "StartTrial", "Evil")
						replicated.Remotes.CommF_:InvokeServer("CDKQuest", "StartTrial", "Evil")
					elseif replicated.Remotes.CommF_:InvokeServer("CDKQuest", "Progress").Finished == false then
						if tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest", "Progress").Evil) == -3 then
							QuestYama_1 = true
							QuestYama_2 = false
							QuestYama_3 = false

							repeat
								task.wait()

								if workspace.Enemies:FindFirstChild("Forest Pirate") then
									if GetConnectionEnemies("Forest Pirate") then
										_tp(workspace.Enemies:FindFirstChild("Forest Pirate").HumanoidRootPart.CFrame)
									end
								else
									_tp(CFrame.new(-13223.521484375, 428.19381713867188, -7766.06787109375))
								end
							until not (tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest", "Progress").Evil) ~= 1 and _G.CDK_YM)
						elseif tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest", "Progress").Evil) == -4 then
							QuestYama_1 = false
							QuestYama_2 = true
							QuestYama_3 = false

							for _, child in pairs(game:GetService("Players").LocalPlayer.QuestHaze:GetChildren()) do
								for k, playervalueaiPlayerData in pairs(locationDataVisible) do
									if string.find(k, child.Name) and child.Value > 0 then
										if (playervalueaiPlayerData.Position - Root.Position).Magnitude <= 1000 then
											if workspace.Enemies:FindFirstChild(k) then
												for _, child2 in pairs(workspace.Enemies:GetChildren()) do
													if child2:FindFirstChild("HumanoidRootPart") and child2:FindFirstChild("Humanoid") and child2:FindFirstChild("Humanoid").Health > 0 and child2:FindFirstChild("HazeESP") then
														while true do
															wait()
															playerCollectionLatest.Kill(child2, _G.CDK_YM)

															if _G.CDK_YM then
																if tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest", "Progress").Evil) == 2 or not child2:FindFirstChild("HazeESP") or child2.Humanoid.Health <= 0 then
																	break
																end
															else
																break
															end
														end
													end
												end

												continue
											end
										end

										_tp(playervalueaiPlayerData)
									end
								end
							end
						elseif tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest", "Progress").Evil) == -5 then
							QuestYama_1 = false
							QuestYama_2 = false
							QuestYama_3 = true

							if workspace.Map:FindFirstChild("HellDimension") and (Root.Position - workspace.Map.HellDimension.Spawn.Position).Magnitude <= 1000 then
								for k in pairs(workspace.Map.HellDimension.Exit:GetChildren()) do
									if tonumber(k) == 2 then
										while true do
											task.wait()
											Root.CFrame = workspace.Map.HellDimension.Exit.CFrame

											if _G.CDK_YM then
												if tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest", "Progress").Evil) == 3 then
													break
												end
											else
												break
											end
										end
									end
								end

								EquipWeapon(_G.SelectWeapon)

								if tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest", "Progress").Evil) ~= 3 then
									while true do
										task.wait()

										repeat
											task.wait()
											_tp(workspace.Map.HellDimension.Torch1.Particles.CFrame)

											for _, descendant in pairs(workspace.Map.HellDimension:GetDescendants()) do
												if descendant:IsA("ProximityPrompt") then
													fireproximityprompt(descendant)
												end
											end
										until (workspace.Map.HellDimension.Torch1.Particles.Position - Root.Position).Magnitude < 5

										wait(2)
										_G.T1Yama = true

										if _G.CDK_YM and not _G.T1Yama then
											if tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest", "Progress").Evil) ~= 3 then
												continue
											end
										end

										break
									end

									while true do
										task.wait()

										repeat
											task.wait()
											_tp(workspace.Map.HellDimension.Torch2.Particles.CFrame)

											for _, descendant in pairs(workspace.Map.HellDimension:GetDescendants()) do
												if descendant:IsA("ProximityPrompt") then
													fireproximityprompt(descendant)
												end
											end
										until (workspace.Map.HellDimension.Torch2.Particles.Position - Root.Position).Magnitude < 5

										wait(2)
										_G.T2Yama = true

										if not (_G.T2Yama or _G.CDK_YM == false) then
											if tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest", "Progress").Evil) ~= 3 then
												continue
											end
										end

										break
									end

									while true do
										wait()

										repeat
											task.wait()
											_tp(workspace.Map.HellDimension.Torch3.Particles.CFrame)

											for _, descendant in pairs(workspace.Map.HellDimension:GetDescendants()) do
												if descendant:IsA("ProximityPrompt") then
													fireproximityprompt(descendant)
												end
											end
										until (workspace.Map.HellDimension.Torch3.Particles.Position - Root.Position).Magnitude < 5

										wait(2)
										_G.T3Yama = true

										if not (_G.T3Yama or _G.CDK_YM == false) then
											if tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest", "Progress").Evil) ~= 3 then
												continue
											end
										end

										break
									end
								end

								for _, child in pairs(workspace.Enemies:GetChildren()) do
									if (child:FindFirstChild("HumanoidRootPart").Position - workspace.Map.HellDimension.Spawn.Position).Magnitude <= 300 then
										if child:FindFirstChild("HumanoidRootPart") and child:FindFirstChild("Humanoid") and child:FindFirstChild("Humanoid").Health > 0 then
											while true do
												task.wait()
												playerCollectionLatest.Kill(child, _G.CDK_YM)

												if _G.CDK_YM and not (child.Humanoid.Health <= 0) and child.Parent then
													if tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest", "Progress").Evil) == 3 then
														break
													end
												else
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
			end)
		end
	end)
end

do
	spawn(function()
		while wait() do
			pcall(function()
				if _G.CDK_YM then
					if tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest", "Progress").Evil) == -5 then
						if not workspace.Map:FindFirstChild("HellDimension") or (Root.Position - workspace.Map.HellDimension.Spawn.Position).Magnitude > 1000 then
							local scriptQuestData = GetConnectionEnemies("Soul Reaper")

							if scriptQuestData then
								while true do
									task.wait()
									_tp(scriptQuestData.HumanoidRootPart.CFrame)

									if not (scriptQuestData.Humanoid.Health <= 0) and _G.CDK_YM and scriptQuestData.Parent then
										if tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest", "Progress").Evil) ~= 3 then
											if not workspace.Map:FindFirstChild("HellDimension") or not ((Root.Position - workspace.Map.HellDimension.Spawn.Position).Magnitude <= 1000) then
												continue
											end
										end

										break
									end

									break
								end
							elseif plr.Backpack:FindFirstChild("Hallow Essence") then
								repeat
									_tp(CFrame.new(-8932.322265625, 146.83154296875, 6062.55078125))
									task.wait()
								until (CFrame.new(-8932.322265625, 146.83154296875, 6062.55078125).Position - Root.Position).Magnitude <= 8

								EquipWeapon("Hallow Essence")
							else
								if plr.Character:FindFirstChild("Hallow Essence") then
									repeat
										_tp(CFrame.new(-8932.322265625, 146.83154296875, 6062.55078125))
										task.wait()
									until (CFrame.new(-8932.322265625, 146.83154296875, 6062.55078125).Position - Root.Position).Magnitude <= 8

									EquipWeapon("Hallow Essence")

									return
								end

								local ok4 = not replicated:FindFirstChild("Soul Reaper")

								if not ok4 then
									ok4 = not (replicated:FindFirstChild("Soul Reaper").Humanoid.Health > 0)
								end

								if ok4 then
									if not (replicated.Remotes.CommF_:InvokeServer("Bones", "Check") < 50) then
										replicated.Remotes.CommF_:InvokeServer("Bones", "Buy", 1, 1)

										return
									end

									if workspace.Enemies:FindFirstChild("Soul Reaper") then
										replicated.Remotes.CommF_:InvokeServer("Bones", "Buy", 1, 1)
									else
										if replicated:FindFirstChild("Soul Reaper") then
											replicated.Remotes.CommF_:InvokeServer("Bones", "Buy", 1, 1)

											return
										end

										if workspace.Map:FindFirstChild("HellDimension") then
											replicated.Remotes.CommF_:InvokeServer("Bones", "Buy", 1, 1)

											return
										end

										local ok = workspace.Enemies:FindFirstChild("Reborn Skeleton")

										if not ok then
											ok = workspace.Enemies:FindFirstChild("Living Zombie")
										end

										local ok2 = ok

										if not ok2 then
											ok2 = workspace.Enemies:FindFirstChild("Domenic Soul")
										end

										local ok3 = ok2

										if not ok3 then
											ok3 = not not workspace.Enemies:FindFirstChild("Posessed Mummy")
										end

										if ok3 then
											for _, child in pairs(workspace.Enemies:GetChildren()) do
												if (child.Name == "Reborn Skeleton" or child.Name == "Living Zombie" or child.Name == "Demonic Soul" or child.Name == "Posessed Mummy") and child:FindFirstChild("HumanoidRootPart") and child:FindFirstChild("Humanoid") and child:FindFirstChild("Humanoid").Health > 0 then
													while true do
														task.wait()
														playerCollectionLatest.Kill(child, _G.CDK_YM)

														if _G.CDK_YM then
															if child.Humanoid.Health <= 0 or not child.Parent then
																break
															end
														else
															break
														end
													end
												end
											end
										else
											_tp(CFrame.new(-9515.2255859375, 164.0062255859375, 5785.38330078125))
										end
									end
								else
									_tp(replicated:FindFirstChild("Soul Reaper").HumanoidRootPart.CFrame)
								end
							end
						end
					end
				end
			end)
		end
	end)
end

Q = GRP_Quests_Cursed_Dual_Katana:AddToggle("Auto_Tushita_CDK", {
	Text = "Auto Tushita CDK",
	Default = false,
	Callback = function(isAutoTushitaCdkEnabled)
		_G.CDK_TS = isAutoTushitaCdkEnabled
	end
})
spawn(function()
	while wait() do
		pcall(function()
			if _G.CDK_TS then
				if tostring(replicated.Remotes.CommF_:InvokeServer("CDKQuest", "OpenDoor")) ~= "opened" then
					wait(0.7)
					replicated.Remotes.CommF_:InvokeServer("CDKQuest", "OpenDoor")
					wait(0.3)
					replicated.Remotes.CommF_:InvokeServer("CDKQuest", "OpenDoor", true)
				elseif replicated.Remotes.CommF_:InvokeServer("CDKQuest", "Progress").Finished == nil then
					replicated.Remotes.CommF_:InvokeServer("CDKQuest", "StartTrial", "Good")
				elseif replicated.Remotes.CommF_:InvokeServer("CDKQuest", "Progress").Finished == false then
					if tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest", "Progress").Good) == -3 then
						QuestTushita_1 = true
						QuestTushita_2 = false
						QuestTushita_3 = false

						while true do
							wait()
							_tp(CFrame.new(-4602.5107421875, 16.446542739868164, -2880.998046875))

							if not ((CFrame.new(-4602.5107421875, 16.446542739868164, -2880.998046875).Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 3) and _G.CDK_TS then
								if tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest", "Progress").Good) == 1 then
									break
								end
							else
								break
							end
						end

						if (CFrame.new(-4602.5107421875, 16.446542739868164, -2880.998046875).Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 10 then
							wait(0.7)
							replicated.Remotes.CommF_:InvokeServer("CDKQuest", "BoatQuest", workspace.NPCs:FindFirstChild("Luxury Boat Dealer"), "Check")
							wait(0.5)
							replicated.Remotes.CommF_:InvokeServer("CDKQuest", "BoatQuest", workspace.NPCs:FindFirstChild("Luxury Boat Dealer"))
						end

						wait(1)

						while true do
							wait()
							_tp(CFrame.new(4001.185302734375, 10.089399337768555, -2654.86328125))

							if not ((CFrame.new(4001.185302734375, 10.089399337768555, -2654.86328125).Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 3) and _G.CDK_TS then
								if tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest", "Progress").Good) == 1 then
									break
								end
							else
								break
							end
						end

						if (CFrame.new(4001.185302734375, 10.089399337768555, -2654.86328125).Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 10 then
							wait(0.7)
							replicated.Remotes.CommF_:InvokeServer("CDKQuest", "BoatQuest", workspace.NPCs:FindFirstChild("Luxury Boat Dealer"), "Check")
							wait(0.5)
							replicated.Remotes.CommF_:InvokeServer("CDKQuest", "BoatQuest", workspace.NPCs:FindFirstChild("Luxury Boat Dealer"))
						end

						wait(1)

						while true do
							wait()
							_tp(CFrame.new(-9530.763671875, 7.245208740234375, -8375.5087890625))

							if not ((CFrame.new(-9530.763671875, 7.245208740234375, -8375.5087890625).Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 3) and _G.CDK_TS then
								if tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest", "Progress").Good) == 1 then
									break
								end
							else
								break
							end
						end

						if (CFrame.new(-9530.763671875, 7.245208740234375, -8375.5087890625).Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 10 then
							wait(0.7)
							replicated.Remotes.CommF_:InvokeServer("CDKQuest", "BoatQuest", workspace.NPCs:FindFirstChild("Luxury Boat Dealer"), "Check")
							wait(0.5)
							replicated.Remotes.CommF_:InvokeServer("CDKQuest", "BoatQuest", workspace.NPCs:FindFirstChild("Luxury Boat Dealer"))
						end

						wait(1)
					elseif tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest", "Progress").Good) == -4 then
						QuestTushita_1 = false
						QuestTushita_2 = true
						QuestTushita_3 = false

						while true do
							wait()
							_G.AutoRaidCastle = true

							if _G.CDK_TS then
								if tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest", "Progress").Good) == 2 then
									break
								end
							else
								break
							end
						end

						_G.AutoRaidCastle = false
					elseif tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest", "Progress").Good) == -5 then
						QuestTushita_1 = false
						QuestTushita_2 = false
						QuestTushita_3 = true

						if workspace.Enemies:FindFirstChild("Cake Queen") then
							for _, child in pairs(workspace.Enemies:GetChildren()) do
								if child.Name == "Cake Queen" and child:FindFirstChild("Humanoid") and child:FindFirstChild("HumanoidRootPart") and child.Humanoid.Health > 0 then
									while true do
										wait()
										playerCollectionLatest.Kill(child, _G.CDK_TS)

										if _G.CDK_TS and child.Parent and not (child.Humanoid.Health <= 0) then
											if tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest", "Progress").Good) == 3 then
												break
											end
										else
											break
										end
									end
								end
							end
						else
							local ok = not replicated:FindFirstChild("Cake Queen")

							if not ok then
								ok = not (replicated:FindFirstChild("Cake Queen").Humanoid.Health > 0)
							end

							if ok then
								if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - workspace.Map.HeavenlyDimension.Spawn.Position).Magnitude <= 1000 then
									for k in pairs(workspace.Map.HeavenlyDimension.Exit:GetChildren()) do
										Ex = k
									end

									if Ex == 2 then
										while true do
											wait()
											game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.Map.HeavenlyDimension.Exit.CFrame

											if _G.CDK_TS then
												if tonumber(replicated.Remotes.CommF_:InvokeServer("CDKQuest", "Progress").Good) == 3 then
													break
												end
											else
												break
											end
										end
									end

									repeat
										wait()

										repeat
											wait()
											_tp(CFrame.new(-22529.6171875, 5275.77392578125, 3873.5712890625))

											for _, descendant in pairs(workspace.Map.HeavenlyDimension:GetDescendants()) do
												if descendant:IsA("ProximityPrompt") then
													fireproximityprompt(descendant)
												end
											end
										until (CFrame.new(-22529.6171875, 5275.77392578125, 3873.5712890625).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 5

										wait(2)
										_G.DoneT1 = true
									until not _G.CDK_TS or _G.DoneT1

									repeat
										wait()

										repeat
											wait()
											_tp(CFrame.new(-22637.291015625, 5281.365234375, 3749.28857421875))

											for _, descendant in pairs(workspace.Map.HeavenlyDimension:GetDescendants()) do
												if descendant:IsA("ProximityPrompt") then
													fireproximityprompt(descendant)
												end
											end
										until (CFrame.new(-22637.291015625, 5281.365234375, 3749.28857421875).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 5

										wait(2)
										_G.DoneT2 = true
									until _G.DoneT2 or _G.CDK_TS == false

									repeat
										wait()

										repeat
											task.wait()
											_tp(CFrame.new(-22791.14453125, 5277.16552734375, 3764.570068359375))

											for _, descendant in pairs(workspace.Map.HeavenlyDimension:GetDescendants()) do
												if descendant:IsA("ProximityPrompt") then
													fireproximityprompt(descendant)
												end
											end
										until (CFrame.new(-22791.14453125, 5277.16552734375, 3764.570068359375).Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 5

										wait(2)
										_G.DoneT3 = true
									until _G.DoneT3 or _G.CDK_TS == false

									for _, child in pairs(workspace.Enemies:GetChildren()) do
										if (child:FindFirstChild("HumanoidRootPart").Position - CFrame.new(-22695.7012, 5270.93652, 3814.42847, 0.11794927, 3.32185834e-08, 0.99301964, -8.73070718e-08, 1, -2.30819008e-08, -0.99301964, -8.3975138e-08, 0.11794927).Position).Magnitude <= 300 and child:FindFirstChild("HumanoidRootPart") and child:FindFirstChild("Humanoid") and child:FindFirstChild("Humanoid").Health > 0 then
											while true do
												wait()
												playerCollectionLatest.Kill(child, _G.CDK_TS)

												if _G.CDK_TS then
													if child.Humanoid.Health <= 0 or not child.Parent then
														break
													end
												else
													break
												end
											end
										end
									end
								end
							else
								_tp(replicated:FindFirstChild("Cake Queen").HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
							end
						end
					end
				end
			end
		end)
	end
end)
GRP_Quests_True_Triple_Katana_Sword = tabs.Quests:AddLeftGroupbox("True Triple Katana Sword")

do
	GRP_Quests_True_Triple_Katana_Sword:AddButton({
		Text = "Buy Legendary Sword",
		Func = function()
			for i = 1, 3 do
				replicated.Remotes.CommF_:InvokeServer("LegendarySwordDealer", tostring(i))
				task.wait(0.3)
			end
		end
	})
end

do
	GRP_Quests_True_Triple_Katana_Sword:AddButton({
		Text = "Buy True Triple Katana Sword",
		Func = function()
			replicated.Remotes.CommF_:InvokeServer("MysteriousMan", "2")
		end
	})
end

do
	Q = GRP_Quests_True_Triple_Katana_Sword:AddToggle("Tween_to_Legendary_Sword_Dealer", {
		Text = "Tween to Legendary Sword Dealer",
		Default = false,
		Callback = function(isTweenToLegendarySwordDealerEnabled)
			_G.Tp_LgS = isTweenToLegendarySwordDealerEnabled
		end
	})
end

spawn(function()
	while wait(Sec) do
		if _G.Tp_LgS then
			pcall(function()
				for _, child in pairs(replicated.NPCs:GetChildren()) do
					if child.Name == "Legendary Sword Dealer " then
						_tp(child.HumanoidRootPart.CFrame)
					end
				end
			end)
		end
	end
end)
GRP_Quests_Pole_God_Enal_s = tabs.Quests:AddLeftGroupbox("Pole / God Enal's")
Q = GRP_Quests_Pole_God_Enal_s:AddToggle("Auto_Pole_V1", {
	Text = "Auto Pole V1",
	Default = false,
	Callback = function(isAutoPoleVEnabled)
		_G.AutoPole = isAutoPoleVEnabled
	end
})
spawn(function()
	while wait(Sec) do
		if _G.AutoPole then
			pcall(function()
				local callbackQuestDataReference = GetConnectionEnemies("Thunder God")

				if callbackQuestDataReference then
					while true do
						task.wait()
						playerCollectionLatest.Kill(callbackQuestDataReference, _G.AutoPole)

						if _G.AutoPole then
							if not callbackQuestDataReference.Parent or callbackQuestDataReference.Humanoid.Health <= 0 then
								break
							end
						else
							break
						end
					end
				else
					_tp(CFrame.new(-7994.984375, 5761.025390625, -2088.6479492188))
				end
			end)
		end
	end
end)
Q = GRP_Quests_Pole_God_Enal_s:AddToggle("Auto_Pole_V2_[Beta]", {
	Text = "Auto Pole V2 [Beta]",
	Default = false,
	Callback = function(isAutoPoleVBetaEnabled)
		_G.AutoPoleV2 = isAutoPoleVBetaEnabled
	end
})

do
	spawn(function()
		while wait(Sec) do
			pcall(function()
				if _G.AutoPoleV2 then
					if not GetBP("Pole (1st Form)") then
						replicated.Remotes.CommF_:InvokeServer("LoadItem", "Pole (1st Form)")
					end

					if not GetBP("Pole (2nd Form)") then
						replicated.Remotes.CommF_:InvokeServer("LoadItem", "Pole (2nd Form)")
					end

					if GetBP("Pole (1st Form)") and GetBP("Pole (1st Form)").Level.Value <= 179 then
						_G.Level = true
					elseif GetBP("Pole (1st Form)") and GetBP("Pole (1st Form)").Level.Value >= 180 then
						_G.Level = false
					end

					if not GetBP("Rumble Fruit") then
						return
					end

					local ok2 = not GetBP("Rumble Fruit").AwakenedMoves:FindFirstChild("Z")

					if not ok2 then
						ok2 = not GetBP("Rumble Fruit").AwakenedMoves:FindFirstChild("X")
					end

					local ok3 = ok2

					if not ok3 then
						ok3 = not GetBP("Rumble Fruit").AwakenedMoves:FindFirstChild("C")
					end

					local ok4 = ok3

					if not ok4 then
						ok4 = not GetBP("Rumble Fruit").AwakenedMoves:FindFirstChild("V")
					end

					local ok5 = ok4

					if not ok5 then
						ok5 = not GetBP("Rumble Fruit").AwakenedMoves:FindFirstChild("F")
					end

					if ok5 then
						local ok = replicated.Remotes.CommF_:InvokeServer("Awakener", "Check") == nil

						if not ok then
							ok = replicated.Remotes.CommF_:InvokeServer("Awakener", "Check") == 0
						end

						if ok then
							_G.SelectChip = "Rumble"

							local response = replicated.Remotes.CommF_:InvokeServer("RaidsNpc", "Select", _G.SelectChip)

							if response then
								response:Stop()
							end

							_G.Raiding = true
							_G.Auto_Awakener = true
						end
					else
						_G.SelectChip = nil
						_G.Raiding = false
						_G.Auto_Awakener = false

						if plr.Data.Fragments.Value >= 5000 then
							replicated.Remotes.CommF_:InvokeServer("Thunder God", "Talk")
							wait(Sec)
							replicated.Remotes.CommF_:InvokeServer("Thunder God", "Sure")
						end
					end
				end
			end)
		end
	end)
end

GRP_Quests_Pole_God_Enal_s:AddToggle("Auto_Saw_Sword", {
	Text = "Auto Saw Sword",
	Default = false,
	Callback = function(isAutoSawSwordEnabled)
		_G.AutoSaw = isAutoSawSwordEnabled
	end
})
spawn(function()
	while wait(0.2) do
		pcall(function()
			if _G.AutoSaw then
				local callbackQuestDataResponse = GetConnectionEnemies("The Saw")

				if callbackQuestDataResponse then
					while true do
						task.wait()
						playerCollectionLatest.Kill(callbackQuestDataResponse, _G.AutoSaw)

						if _G.AutoSaw == false then
							break
						elseif callbackQuestDataResponse.Humanoid.Health <= 0 then
							break
						end
					end
				else
					_tp(CFrame.new(-784.89715576172, 72.427383422852, 1603.5822753906))
				end
			end
		end)
	end
end)

do
	Q = GRP_Quests_Pole_God_Enal_s:AddToggle("Auto_Saber_Sword", {
		Text = "Auto Saber Sword",
		Default = false,
		Callback = function(isAutoSaberSwordEnabled)
			_G.AutoSaber = isAutoSaberSwordEnabled
		end
	})
end

spawn(function()
	while wait(0.2) do
		pcall(function()
			if _G.AutoSaber and plr.Data.Level.Value >= 200 then
				if not plr.Backpack:FindFirstChild("Saber") then
					if not plr.Character:FindFirstChild("Saber") then
						if workspace.Map.Jungle.Final.Part.Transparency ~= 0 then
							local ok2 = workspace.Enemies:FindFirstChild("Saber Expert")

							if not ok2 then
								ok2 = not not replicated:FindFirstChild("Saber Expert")
							end

							if ok2 then
								for _, child in pairs(workspace.Enemies:GetChildren()) do
									if child.Name == "Saber Expert" and playerCollectionLatest.Alive(child) then
										while true do
											task.wait()
											playerCollectionLatest.Kill(child, _G.AutoSaber)

											if child.Humanoid.Health <= 0 then
												break
											elseif _G.AutoSaber == false then
												break
											end
										end

										if child.Humanoid.Health <= 0 then
											replicated.Remotes.CommF_:InvokeServer("ProQuestProgress", "PlaceRelic")
										end
									end
								end
							else
								_tp(CFrame.new(-1401.85046, 29.9773273, 8.81916237, 0.85820812, 8.76083845e-08, 0.513301849, -8.55007443e-08, 1, -2.77243419e-08, -0.513301849, -2.00944328e-08, 0.85820812))
							end
						elseif workspace.Map.Jungle.QuestPlates.Door.Transparency == 0 then
							if (CFrame.new(-1612.55884, 36.9774132, 148.719543, 0.37091279, 3.0717151e-09, -0.928667724, 3.97099491e-08, 1, 1.91679348e-08, 0.928667724, -4.39869794e-08, 0.37091279).Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 100 then
								_tp(plr.Character.HumanoidRootPart.CFrame)
								wait(0.5)
								plr.Character.HumanoidRootPart.CFrame = workspace.Map.Jungle.QuestPlates.Plate1.Button.CFrame
								wait(0.5)
								plr.Character.HumanoidRootPart.CFrame = workspace.Map.Jungle.QuestPlates.Plate2.Button.CFrame
								wait(0.5)
								plr.Character.HumanoidRootPart.CFrame = workspace.Map.Jungle.QuestPlates.Plate3.Button.CFrame
								wait(0.5)
								plr.Character.HumanoidRootPart.CFrame = workspace.Map.Jungle.QuestPlates.Plate4.Button.CFrame
								wait(0.5)
								plr.Character.HumanoidRootPart.CFrame = workspace.Map.Jungle.QuestPlates.Plate5.Button.CFrame
								wait(0.5)
							else
								_tp(CFrame.new(-1612.55884, 36.9774132, 148.719543, 0.37091279, 3.0717151e-09, -0.928667724, 3.97099491e-08, 1, 1.91679348e-08, 0.928667724, -4.39869794e-08, 0.37091279))
							end
						elseif workspace.Map.Desert.Burn.Part.Transparency == 0 then
							if plr.Backpack:FindFirstChild("Torch") then
								EquipWeapon("Torch")
								firetouchinterest(plr.Character.Torch.Handle, workspace.Map.Desert.Burn.Fire, 0)
								firetouchinterest(plr.Character.Torch.Handle, workspace.Map.Desert.Burn.Fire, 1)
								_tp(CFrame.new(1114.61475, 5.04679728, 4350.22803, -0.648466587, -1.28799094e-09, 0.761243105, -5.70652914e-10, 1, 1.20584542e-09, -0.761243105, 3.47544882e-10, -0.648466587))
							else
								if plr.Character:FindFirstChild("Torch") then
									EquipWeapon("Torch")
									firetouchinterest(plr.Character.Torch.Handle, workspace.Map.Desert.Burn.Fire, 0)
									firetouchinterest(plr.Character.Torch.Handle, workspace.Map.Desert.Burn.Fire, 1)
									_tp(CFrame.new(1114.61475, 5.04679728, 4350.22803, -0.648466587, -1.28799094e-09, 0.761243105, -5.70652914e-10, 1, 1.20584542e-09, -0.761243105, 3.47544882e-10, -0.648466587))

									return
								end

								_tp(CFrame.new(-1610.00757, 11.5049858, 164.001587, 0.984807551, -0.167722285, -0.0449818149, 0.17364943, 0.951244235, 0.254912198, 3.42372805e-05, -0.258850515, 0.965917408))
							end
						elseif replicated.Remotes.CommF_:InvokeServer("ProQuestProgress", "SickMan") ~= 0 then
							replicated.Remotes.CommF_:InvokeServer("ProQuestProgress", "GetCup")
							wait(0.5)
							EquipWeapon("Cup")
							wait(0.5)
							replicated.Remotes.CommF_:InvokeServer("ProQuestProgress", "FillCup", plr.Character.Cup)
							wait(Sec)
							replicated.Remotes.CommF_:InvokeServer("ProQuestProgress", "SickMan")
						elseif replicated.Remotes.CommF_:InvokeServer("ProQuestProgress", "RichSon") == nil then
							replicated.Remotes.CommF_:InvokeServer("ProQuestProgress", "RichSon")
						elseif replicated.Remotes.CommF_:InvokeServer("ProQuestProgress", "RichSon") == 0 then
							local ok = workspace.Enemies:FindFirstChild("Mob Leader")

							if not ok then
								ok = not not replicated:FindFirstChild("Mob Leader")
							end

							if ok then
								_tp(CFrame.new(-2967.59521, -4.91089821, 5328.70703, 0.342208564, -0.0227849055, 0.939347804, 0.0251603816, 0.999569714, 0.0150796166, -0.939287126, 0.0184739735, 0.342634559))

								for _, child in pairs(workspace.Enemies:GetChildren()) do
									if child.Name == "Mob Leader" and playerCollectionLatest.Alive(child) then
										while true do
											task.wait()
											playerCollectionLatest.Kill(child, _G.AutoSaber)

											if child.Humanoid.Health <= 0 then
												break
											elseif _G.AutoSaber == false then
												break
											end
										end
									end
								end
							end
						elseif replicated.Remotes.CommF_:InvokeServer("ProQuestProgress", "RichSon") == 1 then
							replicated.Remotes.CommF_:InvokeServer("ProQuestProgress", "RichSon")
							EquipWeapon("Relic")
							_tp(CFrame.new(-1404.91504, 29.9773273, 3.80598116, 0.876514494, 5.66906877e-09, 0.481375456, 2.53851997e-08, 1, -5.79995607e-08, -0.481375456, 6.30572643e-08, 0.876514494))
						end
					end
				end
			end
		end)
	end
end)
Q = GRP_Quests_Pole_God_Enal_s:AddToggle("Auto_Cybrog", {
	Text = "Auto Cybrog",
	Default = false,
	Callback = function(isAutoCybrogEnabled)
		_G.AutoColShad = isAutoCybrogEnabled
	end
})

do
	spawn(function()
		while wait(0.2) do
			if _G.AutoColShad then
				pcall(function()
					local Cyborg = GetConnectionEnemies("Cyborg")

					if Cyborg then
						while true do
							task.wait()
							playerCollectionLatest.Kill(Cyborg, _G.AutoColShad)

							if _G.AutoColShad == false then
								break
							elseif not Cyborg.Parent or Cyborg.Humanoid.Health <= 0 then
								break
							end
						end
					else
						_tp(CFrame.new(6094.0249023438, 73.770050048828, 3825.7348632813))
					end
				end)
			end
		end
	end)
end

do
	Q = GRP_Quests_Pole_God_Enal_s:AddToggle("Auto_Usoap's_Hat", {
		Text = "Auto Usoap's Hat",
		Default = false,
		Callback = function(isAutoUsoapSHatEnabled)
			_G.AutoGetUsoap = isAutoUsoapSHatEnabled
		end
	})
end

do
	spawn(function()
		while task.wait(Sec) do
			pcall(function()
				if _G.AutoGetUsoap then
					for _, child in pairs(workspace.Characters:GetChildren()) do
						if child.Name ~= plr.Name and child.Humanoid.Health > 0 and child:FindFirstChild("HumanoidRootPart") and child.Parent and (Root.Position - child.HumanoidRootPart.Position).Magnitude <= 230 then
							while true do
								task.wait()
								EquipWeapon(_G.SelectWeapon)
								_tp(child.HumanoidRootPart.CFrame * CFrame.new(1, 1, 2))

								if _G.AutoGetUsoap == false then
									break
								elseif child.Humanoid.Health <= 0 or not child.Parent or not child:FindFirstChild("HumanoidRootPart") or not child:FindFirstChild("Humanoid") then
									break
								end
							end
						end
					end
				end
			end)
		end
	end)
end

Q = GRP_Quests_Pole_God_Enal_s:AddToggle("Auto_Bisento_V2", {
	Text = "Auto Bisento V2",
	Default = false,
	Callback = function(isAutoBisentoVEnabled)
		_G.Greybeard = isAutoBisentoVEnabled
	end
})

do
	spawn(function()
		while wait(Sec) do
			if _G.Greybeard then
				pcall(function()
					if GetWP("Bisento") then
						if GetWP("Bisento") then
							replicated.Remotes.CommF_:InvokeServer("LoadItem", "Bisento")

							local Greybeard = GetConnectionEnemies("Greybeard")

							if Greybeard then
								while true do
									wait()
									playerCollectionLatest.Kill(Greybeard, _G.Greybeard)

									if _G.Greybeard == false then
										break
									elseif not Greybeard.Parent or Greybeard.Humanoid.Health <= 0 then
										break
									end
								end
							else
								_tp(CFrame.new(-5023.38330078125, 28.652032852172852, 4332.3818359375))
							end
						end
					else
						replicated.Remotes.CommF_:InvokeServer("BuyItem", "Bisento")
					end
				end)
			end
		end
	end)
end

Q = GRP_Quests_Pole_God_Enal_s:AddToggle("Auto_Warden_Sword", {
	Text = "Auto Warden Sword",
	Default = false,
	Callback = function(isAutoWardenSwordEnabled)
		_G.WardenBoss = isAutoWardenSwordEnabled
	end
})

do
	spawn(function()
		while wait(0.1) do
			if _G.WardenBoss then
				pcall(function()
					local callbackEnemyEntry = GetConnectionEnemies("Chief Warden")

					if callbackEnemyEntry then
						while true do
							wait()
							playerCollectionLatest.Kill(callbackEnemyEntry, _G.WardenBoss)

							if _G.WardenBoss == false then
								break
							elseif not callbackEnemyEntry.Parent or callbackEnemyEntry.Humanoid.Health <= 0 then
								break
							end
						end
					else
						_tp(CFrame.new(5206.92578, 0.997753382, 814.976746, 0.342041343, -0.00062915677, 0.939684749, 0.00191645394, 0.999998152, -2.80422337e-05, -0.939682961, 0.00181045406, 0.342041939))
					end
				end)
			end
		end
	end)
end

do
	Q = GRP_Quests_Pole_God_Enal_s:AddToggle("Auto_Marine_Coat", {
		Text = "Auto Marine Coat",
		Default = false,
		Callback = function(isAutoMarineCoatEnabled)
			_G.MarinesCoat = isAutoMarineCoatEnabled
		end
	})
end

do
	spawn(function()
		while wait(0.1) do
			if _G.MarinesCoat then
				pcall(function()
					local callbackResult = GetConnectionEnemies("Vice Admiral")

					if callbackResult then
						while true do
							wait()
							playerCollectionLatest.Kill(callbackResult, _G.MarinesCoat)

							if _G.MarinesCoat == false then
								break
							elseif not callbackResult.Parent or callbackResult.Humanoid.Health <= 0 then
								break
							end
						end
					else
						_tp(CFrame.new(-5006.5454101563, 88.032081604004, 4353.162109375))
					end
				end)
			end
		end
	end)
end

Q = GRP_Quests_Pole_God_Enal_s:AddToggle("Auto_Swan_Coat", {
	Text = "Auto Swan Coat",
	Default = false,
	Callback = function(isAutoSwanCoatEnabled)
		_G.SwanCoat = isAutoSwanCoatEnabled
	end
})

do
	spawn(function()
		while wait(0.1) do
			if _G.SwanCoat then
				pcall(function()
					local Swan = GetConnectionEnemies("Swan")

					if Swan then
						while true do
							wait()
							playerCollectionLatest.Kill(Swan, _G.SwanCoat)

							if _G.SwanCoat == false then
								break
							elseif not Swan.Parent or Swan.Humanoid.Health <= 0 then
								break
							end
						end
					else
						_tp(CFrame.new(5325.09619, 7.03906584, 719.570679, -0.309060812, 0, 0.951042235, 0, 1, 0, -0.951042235, 0, -0.309060812))
					end
				end)
			end
		end
	end)
end

GRP_Quests_Rengoku_Sword = tabs.Quests:AddLeftGroupbox("Rengoku Sword")
Q = GRP_Quests_Rengoku_Sword:AddToggle("Auto_Rengoku_Sword", {
	Text = "Auto Rengoku Sword",
	Default = false,
	Callback = function(isAutoRengokuSwordEnabled)
		_G.IceBossRen = isAutoRengokuSwordEnabled
	end
})

do
	spawn(function()
		pcall(function()
			while wait(0.1) do
				if _G.IceBossRen then
					local callbackEnemyState = GetConnectionEnemies("Awakened Ice Admiral")

					if callbackEnemyState then
						while true do
							task.wait()
							playerCollectionLatest.Kill(callbackEnemyState, _G.IceBossRen)

							if _G.IceBossRen == false then
								break
							elseif not callbackEnemyState.Parent or callbackEnemyState.Humanoid.Health <= 0 then
								break
							end
						end
					else
						_tp(CFrame.new(5668.9780273438, 28.519989013672, -6483.3520507813))
					end
				end
			end
		end)
	end)
end

do
	Q = GRP_Quests_Rengoku_Sword:AddToggle("Auto_Key_Rengoku", {
		Text = "Auto Key Rengoku",
		Default = false,
		Callback = function(isAutoKeyRengokuEnabled)
			_G.KeysRen = isAutoKeyRengokuEnabled
		end
	})
end

spawn(function()
	while wait(0.1) do
		pcall(function()
			if _G.KeysRen then
				if plr.Backpack:FindFirstChild(piratesEntries[3]) then
					EquipWeapon(piratesEntries[3])
					wait(0.1)
					_tp(CFrame.new(6571.1201171875, 299.23028564453, -6967.841796875))
				else
					if plr.Character:FindFirstChild(piratesEntries[3]) then
						EquipWeapon(piratesEntries[3])
						wait(0.1)
						_tp(CFrame.new(6571.1201171875, 299.23028564453, -6967.841796875))

						return
					end

					local callbackPlayerDataResponse = GetConnectionEnemies(piratesEntries)

					if callbackPlayerDataResponse then
						while true do
							task.wait()
							playerCollectionLatest.Kill(callbackPlayerDataResponse, _G.KeysRen)

							if plr.Backpack:FindFirstChild(piratesEntries[3]) then
								break
							elseif _G.KeysRen == false or not callbackPlayerDataResponse.Parent or callbackPlayerDataResponse.Humanoid.Health <= 0 then
								break
							end
						end
					else
						_tp(CFrame.new(5439.716796875, 84.420944213867, -6715.1635742188))
					end
				end
			end
		end)
	end
end)

do
	Q = GRP_Quests_Rengoku_Sword:AddToggle("Auto_Dragon_Trident", {
		Text = "Auto Dragon Trident",
		Default = false,
		Callback = function(isAutoDragonTridentEnabled)
			_G.AutoTridentW2 = isAutoDragonTridentEnabled
		end
	})
end

spawn(function()
	while wait(0.1) do
		pcall(function()
			if _G.AutoTridentW2 then
				local callbackResultState = GetConnectionEnemies("Tide Keeper")

				if callbackResultState then
					while true do
						task.wait()
						playerCollectionLatest.Kill(callbackResultState, _G.AutoTridentW2)

						if _G.AutoTridentW2 == false then
							break
						elseif not callbackResultState.Parent or callbackResultState.Humanoid.Health <= 0 then
							break
						end
					end
				else
					_tp(CFrame.new(-3795.6423339844, 105.88877105713, -11421.307617188))
				end
			end
		end)
	end
end)
Q = GRP_Quests_Rengoku_Sword:AddToggle("Auto_Long_Sword", {
	Text = "Auto Long Sword",
	Default = false,
	Callback = function(isAutoLongSwordEnabled)
		_G.LongsWord = isAutoLongSwordEnabled
	end
})
spawn(function()
	while wait(0.1) do
		pcall(function()
			if _G.LongsWord then
				local Diamond = GetConnectionEnemies("Diamond")

				if Diamond then
					while true do
						task.wait()
						playerCollectionLatest.Kill(Diamond, _G.LongsWord)

						if _G.LongsWord == false then
							break
						elseif not Diamond.Parent or Diamond.Humanoid.Health <= 0 then
							break
						end
					end
				else
					_tp(CFrame.new(-1576.7166748047, 198.59265136719, 13.724286079407))
				end
			end
		end)
	end
end)
Q = GRP_Quests_Rengoku_Sword:AddToggle("Auto_Black_Spikey", {
	Text = "Auto Black Spikey",
	Default = false,
	Callback = function(isAutoBlackSpikeyEnabled)
		_G.BlackSpikey = isAutoBlackSpikeyEnabled
	end
})
spawn(function()
	while wait(0.1) do
		if _G.BlackSpikey then
			pcall(function()
				local Jeremy = GetConnectionEnemies("Jeremy")

				if Jeremy then
					while true do
						wait()
						playerCollectionLatest.Kill(Jeremy, _G.BlackSpikey)

						if _G.BlackSpikey == false then
							break
						elseif not Jeremy.Parent or Jeremy.Humanoid.Health <= 0 then
							break
						end
					end
				else
					_tp(CFrame.new(2006.9261474609, 448.95666503906, 853.98284912109))
				end
			end)
		end
	end
end)

do
	Q = GRP_Quests_Rengoku_Sword:AddToggle("Auto_Dark_Blade_V3", {
		Text = "Auto Dark Blade V3",
		Default = false,
		Callback = function(isAutoDarkBladeVEnabled)
			_G.DarkBladev3 = isAutoDarkBladeVEnabled
		end
	})
end

spawn(function()
	while wait(Sec) do
		pcall(function()
			if _G.DarkBladev3 and World2 then
				if not GetBP("Dark Blade") then
					replicated.Remotes.CommF_:InvokeServer("LoadItem", "Dark Blade")
				end

				if not (GetBP("Fist of Darkness") > 1) then
					_G.AutoFarmChest = true
				elseif not workspace.Enemies:FindFirstChild("Darkbeard") then
					_tp(CFrame.new(3677.08203125, 62.751937866211, -3144.8332519531))
				elseif GetConnectionEnemies("Darkbeard") then
					if GetBP("Fist of Darkness") >= 1 then
						while true do
							wait()
							_tp(CFrame.new(-5719.36376953125, 48.505905151367188, -782.9759521484375))

							if _G.DarkBladev3 then
								if Root.Position == CFrame.new(-5719.36376953125, 48.505905151367188, -782.9759521484375).Position then
									break
								end
							else
								break
							end
						end

						fireclickdetector(workspace.Map.GraveIsland.Mountain.Rocks.Button.ClickDetector)
					end
				end
			end
		end)
	end
end)
Q = GRP_Quests_Rengoku_Sword:AddToggle("Auto_Midnight_Blade", {
	Text = "Auto Midnight Blade",
	Default = false,
	Callback = function(isAutoMidnightBladeEnabled)
		_G.AutoEcBoss = isAutoMidnightBladeEnabled
	end
})
spawn(function()
	while wait(Sec) do
		pcall(function()
			if _G.AutoEcBoss then
				if GetM("Ectoplasm") >= 99 then
					replicated.Remotes.CommF_:InvokeServer("Ectoplasm", "Buy", 3)
				elseif GetM("Ectoplasm") <= 99 then
					local callbackEnemyCandidate = GetConnectionEnemies("Cursed Captain")

					if callbackEnemyCandidate then
						while true do
							wait()
							playerCollectionLatest.Kill(callbackEnemyCandidate, _G.AutoEcBoss)

							if _G.AutoEcBoss then
								if not callbackEnemyCandidate.Parent or callbackEnemyCandidate.Humanoid.Health <= 0 then
									break
								end
							else
								break
							end
						end
					else
						replicated.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
						wait(0.5)
						_tp(CFrame.new(916.928589, 181.092773, 33422))
					end
				end
			end
		end)
	end
end)
Q = GRP_Quests_Rengoku_Sword:AddToggle("Auto_Darkbeard", {
	Text = "Auto Darkbeard",
	Default = false,
	Callback = function(isAutoDarkbeardEnabled)
		_G.Auto_Def_DarkCoat = isAutoDarkbeardEnabled
	end
})

do
	spawn(function()
		while wait(0.1) do
			if _G.Auto_Def_DarkCoat then
				pcall(function()
					local ok = not GetBP("Fist of Darkness")

					if not ok then
						ok = workspace.Enemies:FindFirstChild("Darkbeard")
					end

					if not ok then
						_tp(CFrame.new(3677.08203125, 62.751937866211, -3144.8332519531))
					elseif GetConnectionEnemies("Darkbeard") then
						local Darkbeard = GetConnectionEnemies("Darkbeard")

						if Darkbeard then
							while true do
								wait()
								playerCollectionLatest.Kill(Darkbeard, _G.Auto_Def_DarkCoat)

								if _G.Auto_Def_DarkCoat == false then
									break
								elseif not Darkbeard.Parent or Darkbeard.Humanoid.Helath <= 0 then
									break
								end
							end
						end
					elseif not (GetBP("Fist of Darkness") or GetConnectionEnemies("Darkbeard")) then
						while true do
							wait(0.1)
							_G.AutoFarmChest = true

							if _G.Auto_Def_DarkCoat then
								if GetBP("Fist of Darkness") or GetConnectionEnemies("Darkbeard") then
									break
								end
							else
								break
							end
						end

						_G.AutoFarmChest = false
					end
				end)
			end
		end
	end)
end

do
	Q = GRP_Quests_Rengoku_Sword:AddToggle("Auto_Unlocked_DonSwan", {
		Text = "Auto Unlocked DonSwan",
		Default = false,
		Callback = function(isAutoUnlockedDonswanEnabled)
			_G.Auto_DonAcces = isAutoUnlockedDonswanEnabled
		end
	})
end

spawn(function()
	while wait(0.1) do
		if _G.Auto_DonAcces then
			pcall(function()
				if replicated.Remotes.CommF_:InvokeServer("GetUnlockables").FlamingoAccess == nil and plr.Data.Level.Value >= 1500 then
					FruitPrice = {}
					FruitStore = {}

					local next_ = next
					local response, serverResponseTarget = replicated:WaitForChild("Remotes").CommF_:InvokeServer("GetFruits")

					for _, playervalueaiPlayerData in next_, response, serverResponseTarget do
						if playervalueaiPlayerData.Price >= 1000000 then
							table.insert(FruitPrice, playervalueaiPlayerData.Name)
						end
					end

					for _, playervalueaiPlayerData in pairs(replicated.Remotes.CommF_:InvokeServer("getInventoryFruits")) do
						for k, getinfinityAbilityPlayerDataItem in pairs(playervalueaiPlayerData) do
							if k == "Name" then
								table.insert(FruitStore, getinfinityAbilityPlayerDataItem)
							end
						end

						replicated.Remotes.CommF_:InvokeServer("Cousin", "Buy")

						for _, getinfinityAbilityPlayerDataItem in pairs(FruitPrice) do
							for _, callbackFruit in pairs(FruitStore) do
								if getinfinityAbilityPlayerDataItem == callbackFruit then
									if replicated.Remotes.CommF_:InvokeServer("GetUnlockables").FlamingoAccess == nil then
										_G.StoreF = false

										if plr.Backpack:FindFirstChild(FruitStore) then
											replicated.Remotes.CommF_:InvokeServer("TalkTrevor", "1")
											replicated.Remotes.CommF_:InvokeServer("TalkTrevor", "2")
											replicated.Remotes.CommF_:InvokeServer("TalkTrevor", "3")
										else
											replicated.Remotes.CommF_:InvokeServer("LoadFruit", tostring(getinfinityAbilityPlayerDataItem))
										end
									end
								end
							end
						end

						if replicated.Remotes.CommF_:InvokeServer("GetUnlockables").FlamingoAccess ~= nil then
							_G.StoreF = true
							_G.Auto_DonAcces = false
						end
					end
				end
			end)
		end
	end
end)

do
	Q = GRP_Quests_Rengoku_Sword:AddToggle("Auto_Swan_Glasses", {
		Text = "Auto Swan Glasses",
		Default = false,
		Callback = function(isAutoSwanGlassesEnabled)
			_G.Auto_SwanGG = isAutoSwanGlassesEnabled
		end
	})
end

do
	spawn(function()
		while wait(0.2) do
			if _G.Auto_SwanGG then
				pcall(function()
					local callbackResultData = GetConnectionEnemies("Don Swan")

					if callbackResultData then
						while true do
							wait()
							playerCollectionLatest.Kill(callbackResultData, _G.Auto_SwanGG)

							if _G.Auto_SwanGG == false then
								break
							elseif not callbackResultData.Parent or callbackResultData.Humanoid.Health <= 0 then
								break
							end
						end
					else
						_tp(CFrame.new(2286.2004394531, 15.177839279175, 863.8388671875))
					end
				end)
			end
		end
	end)
end

GRP_Quests_Cavender_Twin_Hooks_Bigmom = tabs.Quests:AddLeftGroupbox("Cavender + Twin Hooks + Bigmom")

do
	Q = GRP_Quests_Cavender_Twin_Hooks_Bigmom:AddToggle("Auto_Bigmom", {
		Text = "Auto Bigmom",
		Default = false,
		Callback = function(isAutoBigmomEnabled)
			_G.AutoBigmom = isAutoBigmomEnabled
		end
	})
end

do
	spawn(function()
		while wait(Sec) do
			if _G.AutoBigmom then
				pcall(function()
					local callbackResultEntry = GetConnectionEnemies("Cake Queen")

					if callbackResultEntry then
						while true do
							task.wait()
							playerCollectionLatest.Kill(callbackResultEntry, _G.AutoBigmom)

							if _G.AutoBigmom then
								if not callbackResultEntry.Parent or callbackResultEntry.Humanoid.Health <= 0 then
									break
								end
							else
								break
							end
						end
					else
						_tp(CFrame.new(-709.31329345703125, 381.6005859375, -11011.396484375))
					end
				end)
			end
		end
	end)
end

do
	Q = GRP_Quests_Cavender_Twin_Hooks_Bigmom:AddToggle("Auto_Canvendish_Sword", {
		Text = "Auto Canvendish Sword",
		Default = false,
		Callback = function(isAutoCanvendishSwordEnabled)
			_G.Auto_Cavender = isAutoCanvendishSwordEnabled
			ender = v
		end
	})
end

spawn(function()
	while wait(Sec) do
		pcall(function()
			if _G.Auto_Cavender then
				local callbackResultItem = GetConnectionEnemies("Beautiful Pirate")

				if callbackResultItem then
					while true do
						wait()
						playerCollectionLatest.Kill(callbackResultItem, _G.Auto_Cavender)

						if _G.Auto_Cavender then
							if callbackResultItem.Humanoid.Health <= 0 then
								break
							end
						else
							break
						end
					end
				else
					_tp(CFrame.new(5283.609375, 22.56223487854, -110.78285217285))
				end
			end
		end)
	end
end)

do
	Q = GRP_Quests_Cavender_Twin_Hooks_Bigmom:AddToggle("Auto_Twin_Hooks", {
		Text = "Auto Twin Hooks",
		Default = false,
		Callback = function(isAutoTwinHooksEnabled)
			_G.TwinHook = isAutoTwinHooksEnabled
		end
	})
end

do
	spawn(function()
		while wait(Sec) do
			pcall(function()
				if _G.TwinHook then
					local callbackResultCandidate = GetConnectionEnemies("Captain Elephant")

					if callbackResultCandidate then
						while true do
							wait()
							playerCollectionLatest.Kill(callbackResultCandidate, _G.TwinHook)

							if _G.TwinHook then
								if callbackResultCandidate.Humanoid.Health <= 0 then
									break
								end
							else
								break
							end
						end
					else
						replicated.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(-12471.169921875, 374.94024658203, -7551.677734375))
						wait(0.2)
						_tp(CFrame.new(-13376.7578125, 433.28689575195, -8071.392578125))
					end
				end
			end)
		end
	end)
end

Q = GRP_Quests_Cavender_Twin_Hooks_Bigmom:AddToggle("Auto_Serpent_Bow", {
	Text = "Auto Serpent Bow",
	Default = false,
	Callback = function(isAutoSerpentBowEnabled)
		_G.AutoSerpentBow = isAutoSerpentBowEnabled
	end
})
spawn(function()
	while wait(Sec) do
		if _G.AutoSerpentBow then
			local callbackQuestDataPayload = GetConnectionEnemies("Hydra Leader")

			if callbackQuestDataPayload then
				while true do
					wait()
					playerCollectionLatest.Kill(callbackQuestDataPayload, _G.AutoSerpentBow)

					if _G.AutoSerpentBow then
						if not callbackQuestDataPayload.Parent or callbackQuestDataPayload.Humanoid.Health <= 0 then
							break
						end
					else
						break
					end
				end
			else
				_tp(CFrame.new(5821.89794921875, 1019.0950927734375, -73.719230651855469))
			end
		end
	end
end)

do
	Q = GRP_Quests_Cavender_Twin_Hooks_Bigmom:AddToggle("Auto_Lei_Accessory", {
		Text = "Auto Lei Accessory",
		Default = false,
		Callback = function(isAutoLeiAccessoryEnabled)
			_G.AutoKilo = isAutoLeiAccessoryEnabled
		end
	})
end

spawn(function()
	while wait(0.2) do
		if _G.AutoKilo then
			pcall(function()
				local callbackResultReference = GetConnectionEnemies("Kilo Admiral")

				if callbackResultReference then
					while true do
						task.wait()
						playerCollectionLatest.Kill(callbackResultReference, _G.AutoKilo)

						if _G.AutoKilo then
							if not callbackResultReference.Parent or callbackResultReference.Humanoid.Health <= 0 then
								break
							end
						else
							break
						end
					end
				else
					_tp(CFrame.new(2764.2233886719, 432.46154785156, -7144.4580078125))
				end
			end)
		end
	end
end)
GRP_Quests_Buso_Aura_Colours = tabs.Quests:AddLeftGroupbox("Buso/Aura Colours")
Q = GRP_Quests_Buso_Aura_Colours:AddToggle("Auto_Teleport_Barista_Cousin", {
	Text = "Auto Teleport Barista Cousin",
	Default = false,
	Callback = function(isAutoTeleportBaristaCousinEnabled)
		_G.Tp_MasterA = isAutoTeleportBaristaCousinEnabled
	end
})

do
	spawn(function()
		while wait() do
			if _G.Tp_MasterA then
				pcall(function()
					for _, child in pairs(replicated.NPCs:GetChildren()) do
						if child.Name == "Barista Cousin" then
							_tp(child.HumanoidRootPart.CFrame)
						end
					end
				end)
			end
		end
	end)
end

do
	GRP_Quests_Buso_Aura_Colours:AddButton({
		Text = "Buy Buso Colors",
		Func = function()
			replicated.Remotes.CommF_:InvokeServer("ColorsDealer", "2")
		end
	})
end

Q = GRP_Quests_Buso_Aura_Colours:AddToggle("Auto_Rainbow_Colors", {
	Text = "Auto Rainbow Colors",
	Default = false,
	Callback = function(isAutoRainbowColorsEnabled)
		_G.Auto_Rainbow_Haki = isAutoRainbowColorsEnabled
	end
})
spawn(function()
	pcall(function()
		while wait(Sec) do
			if _G.Auto_Rainbow_Haki then
				if plr.PlayerGui.Main.Quest.Visible == false then
					if _G.GetQFast then
						if plr.PlayerGui.Main.Quest.Visible == false then
							replicated.Remotes.CommF_:InvokeServer("HornedMan", "Bet")
						end
					else
						Rainbow1 = CFrame.new(-11892.0703125, 930.57672119141, -8760.1591796875)

						if plr.Character.HumanoidRootPart.CFrame ~= Rainbow1 then
							_tp(Rainbow1)
						elseif plr.Character.HumanoidRootPart.CFrame == Rainbow1 then
							wait(1)
							replicated.Remotes.CommF_:InvokeServer("HornedMan", "Bet")
						end
					end
				elseif plr.PlayerGui.Main.Quest.Visible == true and string.find(plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Stone") then
					local Stone = GetConnectionEnemies("Stone")

					if Stone then
						while true do
							wait()
							playerCollectionLatest.Kill(Stone, _G.Auto_Rainbow_Haki)

							if _G.Auto_Rainbow_Haki == false then
								break
							elseif Stone.Humanoid.Health <= 0 or not Stone.Parent or plr.PlayerGui.Main.Quest.Visible == false then
								break
							end
						end
					else
						_tp(CFrame.new(-1086.11621, 38.8425903, 6768.71436, 0.0231462717, -0.592676699, 0.805107772, 2.03251839e-05, 0.805323839, 0.592835128, -0.999732077, -0.0137055516, 0.0186523199))
					end
				elseif plr.PlayerGui.Main.Quest.Visible == true and string.find(plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Hydra Leader") then
					local callbackQuestDataRecord = GetConnectionEnemies("Hydra Leader")

					if callbackQuestDataRecord then
						while true do
							task.wait()
							playerCollectionLatest.Kill(callbackQuestDataRecord, _G.Auto_Rainbow_Haki)

							if _G.Auto_Rainbow_Haki == false then
								break
							elseif callbackQuestDataRecord.Humanoid.Health <= 0 or not callbackQuestDataRecord.Parent or plr.PlayerGui.Main.Quest.Visible == false then
								break
							end
						end
					else
						replicated.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(5643.45263671875, 1013.0858154296875, -340.51025390625))

						local vector3 = Vector3.new(5643.45263671875, 1013.0858154296875, -340.51025390625)
						local cFrame = CFrame.new(5821.89794921875, 1019.0950927734375, -73.719230651855469)

						if plr.Character.HumanoidRootPart.CFrame.Position == vector3 then
							_tp(cFrame)
						end
					end
				elseif plr.PlayerGui.Main.Quest.Visible == true and string.find(plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Kilo Admiral") then
					local callbackQuestDataSnapshot = GetConnectionEnemies("Kilo Admiral")

					if callbackQuestDataSnapshot then
						while true do
							task.wait()
							playerCollectionLatest.Kill(callbackQuestDataSnapshot, _G.Auto_Rainbow_Haki)

							if _G.Auto_Rainbow_Haki == false then
								break
							elseif callbackQuestDataSnapshot.Humanoid.Health <= 0 or not callbackQuestDataSnapshot.Parent or plr.PlayerGui.Main.Quest.Visible == false then
								break
							end
						end
					else
						_tp(CFrame.new(2877.61743, 423.558685, -7207.31006, -0.989591599, -0, -0.143904909, -0, 1.00000012, -0, 0.143904924, 0, -0.989591479))
					end
				elseif plr.PlayerGui.Main.Quest.Visible == true and string.find(plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Captain Elephant") then
					local callbackQuestDataContext = GetConnectionEnemies("Captain Elephant")

					if callbackQuestDataContext then
						while true do
							task.wait()
							playerCollectionLatest.Kill(callbackQuestDataContext, _G.Auto_Rainbow_Haki)

							if _G.Auto_Rainbow_Haki == false then
								break
							elseif callbackQuestDataContext.Humanoid.Health <= 0 or not callbackQuestDataContext.Parent or plr.PlayerGui.Main.Quest.Visible == false then
								break
							end
						end
					else
						local vector3 = Vector3.new(-12471.169921875, 374.94024658203, -7551.677734375)
						local cFrame = CFrame.new(-13376.7578125, 433.28689575195, -8071.392578125)

						if plr.Character.HumanoidRootPart.CFrame.Position ~= vector3 then
							replicated.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(-12471.169921875, 374.94024658203, -7551.677734375))
						elseif plr.Character.HumanoidRootPart.CFrame.Position == vector3 then
							_tp(cFrame)
						end
					end
				elseif plr.PlayerGui.Main.Quest.Visible == true and string.find(plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Beautiful Pirate") then
					local callbackQuestDataOption = GetConnectionEnemies("Captain Elephant")

					if callbackQuestDataOption then
						while true do
							task.wait()
							playerCollectionLatest.Kill(callbackQuestDataOption, _G.Auto_Rainbow_Haki)

							if _G.Auto_Rainbow_Haki == false then
								break
							elseif callbackQuestDataOption.Humanoid.Health <= 0 or not callbackQuestDataOption.Parent or plr.PlayerGui.Main.Quest.Visible == false then
								break
							end
						end
					else
						replicated.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(5314.54638671875, 22.562219619750977, -127.06755065917969))
					end
				end
			end
		end
	end)
end)

do
	Q = GRP_Quests_Buso_Aura_Colours:AddToggle("Accept_Rainbow_Quest_Faster", {
		Text = "Accept Rainbow Quest Faster",
		Default = false,
		Callback = function(isAcceptRainbowQuestFasterEnabled)
			_G.GetQFast = isAcceptRainbowQuestFasterEnabled
		end
	})
end

GRP_Quests_Instinct_Observation = tabs.Quests:AddLeftGroupbox("Instinct / Observation")

do
	Q = GRP_Quests_Instinct_Observation:AddToggle("Auto_Farm_Observation", {
		Text = "Auto Farm Observation",
		Default = false,
		Callback = function(isAutoFarmObservationEnabled)
			_G.obsFarm = isAutoFarmObservationEnabled
		end
	})
end

spawn(function()
	while wait(0.2) do
		pcall(function()
			if _G.obsFarm then
				replicated.Remotes.CommE:FireServer("Ken", true)

				if plr:GetAttribute("KenDodgesLeft") == 0 then
					KenTest = false
				elseif plr:GetAttribute("KenDodgesLeft") > 0 then
					replicated.Remotes.CommE:FireServer("Ken", true)
					KenTest = true
				end
			end
		end)
	end
end)

do
	spawn(function()
		while wait(0.2) do
			pcall(function()
				if _G.obsFarm then
					if World1 then
						if workspace.Enemies:FindFirstChild("Galley Captain") then
							if KenTest then
								while true do
									wait()
									plr.Character.HumanoidRootPart.CFrame = workspace.Enemies:FindFirstChild("Galley Captain").HumanoidRootPart.CFrame * CFrame.new(3, 0, 0)

									if _G.obsFarm == false then
										break
									elseif KenTest == false then
										break
									end
								end
							else
								while true do
									wait()
									plr.Character.HumanoidRootPart.CFrame = workspace.Enemies:FindFirstChild("Galley Captain").HumanoidRootPart.CFrame * CFrame.new(0, 50, 0)

									if _G.obsFarm == false then
										break
									elseif KenTest then
										break
									end
								end
							end
						else
							_tp(CFrame.new(5533.29785, 88.1079102, 4852.3916))
						end
					elseif World2 then
						if workspace.Enemies:FindFirstChild("Lava Pirate") then
							if KenTest then
								while true do
									wait()
									plr.Character.HumanoidRootPart.CFrame = workspace.Enemies:FindFirstChild("Lava Pirate").HumanoidRootPart.CFrame * CFrame.new(3, 0, 0)

									if _G.obsFarm == false then
										break
									elseif KenTest == false then
										break
									end
								end
							else
								while true do
									wait()
									plr.Character.HumanoidRootPart.CFrame = workspace.Enemies:FindFirstChild("Lava Pirate").HumanoidRootPart.CFrame * CFrame.new(0, 50, 0)

									if _G.obsFarm == false then
										break
									elseif KenTest then
										break
									end
								end
							end
						else
							_tp(CFrame.new(-5478.39209, 15.9775667, -5246.9126))
						end
					elseif World3 then
						if workspace.Enemies:FindFirstChild("Venomous Assailant") then
							if KenTest then
								while true do
									wait()
									_tp(workspace.Enemies:FindFirstChild("Venomous Assailant").HumanoidRootPart.CFrame * CFrame.new(3, 0, 0))

									if _G.obsFarm == false then
										break
									elseif KenTest == false then
										break
									end
								end
							else
								while true do
									wait()
									_tp(workspace.Enemies:FindFirstChild("Venomous Assailant").HumanoidRootPart.CFrame * CFrame.new(0, 50, 0))

									if _G.obsFarm == false then
										break
									elseif KenTest then
										break
									end
								end
							end
						else
							_tp(CFrame.new(4530.3540039063, 656.75695800781, -131.60952758789))
						end
					end
				end
			end)
		end
	end)
end

Q = GRP_Quests_Instinct_Observation:AddToggle("Auto_Observation_V2", {
	Text = "Auto Observation V2",
	Default = false,
	Callback = function(isAutoObservationVEnabled)
		_G.AutoKenVTWO = isAutoObservationVEnabled
	end
})

do
	spawn(function()
		while wait(Sec) do
			if _G.AutoKenVTWO then
				pcall(function()
					local cFrame = CFrame.new(-12444.78515625, 332.40396118164, -7673.1806640625)
					local cFrame2 = CFrame.new(-10920.125, 624.20275878906, -10266.995117188)
					local cFrame3 = CFrame.new(-13277.568359375, 370.34185791016, -7821.1572265625)
					local cFrame4 = CFrame.new(-13493.12890625, 318.89553833008, -8373.7919921875)

					if plr.PlayerGui.Main.Quest.Visible == true and string.find(plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Defeat 50 Forest Pirates") then
						local callbackQuestDataOutput = GetConnectionEnemies("Forest Pirate")

						if callbackQuestDataOutput then
							while true do
								wait()
								playerCollectionLatest.Kill(callbackQuestDataOutput, _G.AutoKenVTWO)

								if _G.AutoKenVTWO then
									if callbackQuestDataOutput.Humanoid.Health <= 0 or plr.PlayerGui.Main.Quest.Visible == false then
										break
									end
								else
									break
								end
							end
						else
							_tp(cFrame3)
						end
					elseif plr.PlayerGui.Main.Quest.Visible == true then
						local callbackQuestDataInput = GetConnectionEnemies("Captain Elephant")

						if callbackQuestDataInput then
							while true do
								wait()
								playerCollectionLatest.Kill(callbackQuestDataInput, _G.AutoKenVTWO)

								if _G.AutoKenVTWO then
									if callbackQuestDataInput.Humanoid.Health <= 0 or plr.PlayerGui.Main.Quest.Visible == false then
										break
									end
								else
									break
								end
							end
						else
							_tp(cFrame4)
						end
					elseif plr.PlayerGui.Main.Quest.Visible == false then
						replicated.Remotes.CommF_:InvokeServer("CitizenQuestProgress", "Citizen")
						wait(0.1)
						replicated.Remotes.CommF_:InvokeServer("StartQuest", "CitizenQuest", 1)
					end

					if replicated.Remotes.CommF_:InvokeServer("CitizenQuestProgress", "Citizen") == 2 then
						_tp(CFrame.new(-12513.51953125, 340.11373901367188, -9873.048828125))
					end

					local ok5 = not plr.Backpack:FindFirstChild("Fruit Bowl")

					if not ok5 then
						ok5 = not plr.Character:FindFirstChild("Fruit Bowl")
					end

					if ok5 then
						if not GetBP("Fruit Bowl") then
							if not GetBP("Apple") then
								replicated.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(-12471.169921875, 374.94024658203, -7551.677734375))

								for _, descendant in pairs(workspace:GetDescendants()) do
									if descendant.Name == "Apple" then
										descendant.Handle.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new(0, 1, 10)
										wait()
										firetouchinterest(plr.Character.HumanoidRootPart, descendant.Handle, 0)
										wait()
									end
								end
							elseif GetBP("Banana") then
								if not GetBP("Pineapple") then
									_tp(CFrame.new(-712.8272705078125, 98.577049255371094, 5711.9541015625))

									for _, descendant in pairs(workspace:GetDescendants()) do
										if descendant.Name == "Pineapple" then
											descendant.Handle.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new(0, 1, 10)
											wait()
											firetouchinterest(plr.Character.HumanoidRootPart, descendant.Handle, 0)
											wait()
										end
									end
								end
							else
								_tp(CFrame.new(2286.0078125, 73.133918762207031, -7159.80908203125))

								for _, descendant in pairs(workspace:GetDescendants()) do
									if descendant.Name == "Banana" then
										descendant.Handle.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new(0, 1, 10)
										wait()
										firetouchinterest(plr.Character.HumanoidRootPart, descendant.Handle, 0)
										wait()
									end
								end
							end
						end

						local ok2 = not plr.Backpack:FindFirstChild("Banana")

						if not ok2 then
							ok2 = not plr.Backpack:FindFirstChild("Apple")
						end

						local ok3 = ok2

						if not ok3 then
							ok3 = not plr.Backpack:FindFirstChild("Pineapple")
						end

						local ok

						if not ok3 then
							repeat
								wait()
								_tp(cFrame)
								ok = _G.AutoKenVTWO

								if not ok then
									ok = plr.Character.HumanoidRootPart.CFrame == cFrame

									if ok then
										break
									end
								end
							until ok
							-- (could not be recovered)
						end

						if plr:FindFirstChild("Banana") then
							if plr:FindFirstChild("Apple") then
								if plr:FindFirstChild("Pineapple") then
									repeat
										wait()
										_tp(cFrame)
										ok = _G.AutoKenVTWO or plr.Character.HumanoidRootPart.CFrame == cFrame
									until ok

									replicated.Remotes.CommF_:InvokeServer("CitizenQuestProgress", "Citizen")
								end
							end
						end

						local ok4 = plr.Backpack:FindFirstChild("Fruit Bowl")

						if not ok4 then
							ok4 = not not plr.Character:FindFirstChild("Fruit Bowl")
						end

						if ok4 then
							if plr.Character.HumanoidRootPart.CFrame ~= cFrame2 then
								_tp(cFrame2)
							elseif plr.Character.HumanoidRootPart.CFrame == cFrame2 then
								replicated.Remotes.CommF_:InvokeServer("KenTalk2", "Start")
								wait(0.1)
								replicated.Remotes.CommF_:InvokeServer("KenTalk2", "Buy")
							end
						end
					end
				end)
			end
		end
	end)
end

Bartilo = GRP_Quests_Instinct_Observation:AddToggle("Auto_Done_Bartilo_Quest", {
	Text = "Auto Done Bartilo Quest",
	Default = false,
	Callback = function(isAutoDoneBartiloQuestEnabled)
		_G.Bartilo_Quest = isAutoDoneBartiloQuestEnabled
	end
})

do
	spawn(function()
		while wait(0.1) do
			pcall(function()
				if _G.Bartilo_Quest and Lv >= 850 then
					local Quest = plr.PlayerGui.Main.Quest

					if replicated.Remotes.CommF_:InvokeServer("BartiloQuestProgress", "Bartilo") == 0 then
						_G.Level = false

						if Quest.Visible == true then
							if GetConnectionEnemies("Swan Pirate") then
								local callbackQuestDataTarget = GetConnectionEnemies(piratesEntriesData)

								if callbackQuestDataTarget then
									repeat
										task.wait()

										if string.find(plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Swan Pirate") then
											playerCollectionLatest.Kill(callbackQuestDataTarget, _G.Bartilo_Quest)
										else
											replicated.Remotes.CommF_:InvokeServer("AbandonQuest")
										end
									until _G.Bartilo_Quest == false or not callbackQuestDataTarget.Parent or callbackQuestDataTarget.Humanoid.Health <= 0 or Quest.Visible == false or not callbackQuestDataTarget:FindFirstChild("HumanoidRootPart")
								end
							else
								_tp(CFrame.nee(970.369446, 142.653198, 1217.3667, 0.162079468, -4.85452638e-08, -0.986777723, 1.03357589e-08, 1, -4.74980872e-08, 0.986777723, -2.50063148e-09, 0.162079468))
							end
						else
							while true do
								wait()
								_tp(CFrame.new(-461.533203, 72.3478546, 300.311096, 0.050853312, -0, -0.998706102, 0, 1, -0, 0.998706102, 0, 0.050853312))

								if (CFrame.new(-461.533203, 72.3478546, 300.311096, 0.050853312, -0, -0.998706102, 0, 1, -0, 0.998706102, 0, 0.050853312).Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 20 then
									break
								elseif _G.Bartilo_Quest == false then
									break
								end
							end

							if (CFrame.new(-461.533203, 72.3478546, 300.311096, 0.050853312, -0, -0.998706102, 0, 1, -0, 0.998706102, 0, 0.050853312).Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 1 then
								replicated.Remotes.CommF_:InvokeServer("StartQuest", "BartiloQuest", 1)
							end
						end
					elseif replicated.Remotes.CommF_:InvokeServer("BartiloQuestProgress", "Bartilo") == 1 then
						_G.Level = false

						local Jeremy = GetConnectionEnemies("Jeremy")

						if Jeremy then
							while true do
								task.wait()
								playerCollectionLatest.Kill(Jeremy, _G.Bartilo_Quest)

								if _G.Bartilo_Quest == false then
									break
								elseif not Jeremy.Parent or Jeremy.Humanoid.Health <= 0 or Quest.Visible == false or not Jeremy:FindFirstChild("HumanoidRootPart") then
									break
								end
							end
						else
							_tp(CFrame.new(2158.97412, 449.056244, 705.411682, -0.754199564, -4.17389057e-09, -0.656645238, -4.47752875e-08, 1, 4.50709301e-08, 0.656645238, 6.3393955e-08, -0.754199564))
						end
					elseif replicated.Remotes.CommF_:InvokeServer("BartiloQuestProgress", "Bartilo") == 2 then
						while true do
							wait()
							_tp(CFrame.new(-1830.83972, 10.5578213, 1680.60229, 0.979988456, -2.02152783e-08, -0.199054286, 2.20792113e-08, 1, 7.1442483e-09, 0.199054286, -1.13962431e-08, 0.979988456))

							if (CFrame.new(-1830.83972, 10.5578213, 1680.60229, 0.979988456, -2.02152783e-08, -0.199054286, 2.20792113e-08, 1, 7.1442483e-09, 0.199054286, -1.13962431e-08, 0.979988456).Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 1 then
								break
							elseif _G.Bartilo_Quest == false then
								break
							end
						end

						wait(0.5)
						plr.Character.HumanoidRootPart.CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate1.CFrame
						wait(0.5)
						plr.Character.HumanoidRootPart.CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate2.CFrame
						wait(0.5)
						plr.Character.HumanoidRootPart.CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate3.CFrame
						wait(0.5)
						plr.Character.HumanoidRootPart.CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate4.CFrame
						wait(0.5)
						plr.Character.HumanoidRootPart.CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate5.CFrame
						wait(0.5)
						plr.Character.HumanoidRootPart.CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate6.CFrame
						wait(0.5)
						plr.Character.HumanoidRootPart.CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate7.CFrame
						wait(0.5)
						plr.Character.HumanoidRootPart.CFrame = workspace.Map.Dressrosa.BartiloPlates.Plate8.CFrame
						wait(2.5)
					end
				end
			end)
		end
	end)
end

CitizenQ = GRP_Quests_Instinct_Observation:AddToggle("Auto_Done_Citizen_Quest", {
	Text = "Auto Done Citizen Quest",
	Default = false,
	Callback = function(isAutoDoneCitizenQuestEnabled)
		_G.CitizenQuest = isAutoDoneCitizenQuestEnabled
	end
})
spawn(function()
	while wait(Sec) do
		pcall(function()
			if _G.CitizenQuest then
				local ok2 = not (Lv >= 1800)

				if not ok2 then
					ok2 = replicated.Remotes.CommF_:InvokeServer("CitizenQuestProgress").KilledBandits ~= false
				end

				if ok2 then
					local ok = not (Lv >= 1800)

					if not ok then
						ok = replicated.Remotes.CommF_:InvokeServer("CitizenQuestProgress").KilledBoss ~= false
					end

					if not ok then
						local callbackQuestDataValue = GetConnectionEnemies("Captain Elephant")

						if plr.PlayerGui.Main.Quest.Visible and string.find(plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Captain Elephant") and plr.PlayerGui.Main.Quest.Visible == true then
							if callbackQuestDataValue then
								while true do
									task.wait()
									playerCollectionLatest.Kill(callbackQuestDataValue, _G.CitizenQuest)

									if _G.CitizenQuest == false then
										break
									elseif callbackQuestDataValue.Humanoid.Health <= 0 or not callbackQuestDataValue.Parent or plr.PlayerGui.Main.Quest.Visible == false then
										break
									end
								end
							else
								_tp(CFrame.new(-13374.889648438, 421.27752685547, -8225.208984375))
							end
						else
							_tp(CFrame.new(-12443.8671875, 332.40396118164, -7675.4892578125))

							if (CFrame.new(-12443.8671875, 332.40396118164, -7675.4892578125).Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 4 then
								wait(1.5)
								replicated.Remotes.CommF_:InvokeServer("CitizenQuestProgress", "Citizen")
							end
						end
					elseif Lv >= 1800 then
						if replicated.Remotes.CommF_:InvokeServer("CitizenQuestProgress", "Citizen") == 2 then
							_tp(CFrame.new(-12512.138671875, 340.39279174805, -9872.8203125))
						end
					end
				elseif string.find(plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Forest Pirate") and string.find(plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "50") and plr.PlayerGui.Main.Quest.Visible == true then
					local callbackQuestDataCallbackData = GetConnectionEnemies("Forest Pirate")

					if callbackQuestDataCallbackData then
						while true do
							task.wait()
							playerCollectionLatest.Kill(callbackQuestDataCallbackData, _G.CitizenQuest)

							if _G.CitizenQuest == false then
								break
							elseif not callbackQuestDataCallbackData.Parent or callbackQuestDataCallbackData.Humanoid.Health <= 0 or plr.PlayerGui.Main.Quest.Visible == false then
								break
							end
						end
					else
						_tp(CFrame.new(-13206.452148438, 425.89199829102, -7964.5537109375))
					end
				else
					_tp(CFrame.new(-12443.8671875, 332.40396118164, -7675.4892578125))

					if (Vector3.new(-12443.8671875, 332.40396118164, -7675.4892578125) - plr.Character.HumanoidRootPart.Position).Magnitude <= 30 then
						wait(1.5)
						replicated.Remotes.CommF_:InvokeServer("StartQuest", "CitizenQuest", 1)
					end
				end
			end
		end)
	end
end)
Q = GRP_Quests_Instinct_Observation:AddToggle("Auto_Training_Dummy", {
	Text = "Auto Training Dummy",
	Default = false,
	Callback = function(isAutoTrainingDummyEnabled)
		_G.DummyMan = isAutoTrainingDummyEnabled
	end
})

do
	spawn(function()
		while wait(Sec) do
			if _G.DummyMan then
				pcall(function()
					if plr.PlayerGui.Main.Quest.Visible == false then
						replicated:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer(unpack({ "ArenaTrainer" }))
					else
						local callbackQuestDataCallbackEntry = GetConnectionEnemies("Training Dummy")

						if callbackQuestDataCallbackEntry then
							while true do
								wait()
								playerCollectionLatest.Kill(callbackQuestDataCallbackEntry, _G.DummyMan)

								if _G.DummyMan then
									if not callbackQuestDataCallbackEntry.Parent or callbackQuestDataCallbackEntry.Humanoid.Health <= 0 then
										break
									end
								else
									break
								end
							end
						else
							_tp(CFrame.new(3688.005126953125, 12.746943473815918, 170.20953369140625))
						end
					end
				end)
			end
		end
	end)
end

GRP_Quests_Fighting_Melee_Styles = tabs.Quests:AddLeftGroupbox("Fighting Melee Styles")
SuperHuman = GRP_Quests_Fighting_Melee_Styles:AddToggle("Auto_Superhuman", {
	Text = "Auto Superhuman",
	Default = false,
	Callback = function(isAutoSuperhumanEnabled)
		_G.Auto_SuperHuman = isAutoSuperhumanEnabled
	end
})

do
	spawn(function()
		while wait(Sec) do
			pcall(function()
				if _G.Auto_SuperHuman then
					local Value = plr.Data.Beli.Value
					local Value2 = plr.Data.Fragments.Value

					if plr:FindFirstChild("WeaponAssetCache") and not GetBP("Superhuman") then
						if GetBP("Black Leg") then
							if GetBP("Black Leg") and GetBP("Black Leg").Level.Value < 299 then
								_G.Level = true
							elseif GetBP("Black Leg") and GetBP("Black Leg").Level.Value >= 300 then
								_G.Level = false
							end
						elseif Value >= 150000 then
							replicated.Remotes.CommF_:InvokeServer("BuyBlackLeg")
						end

						if GetBP("Electro") then
							if GetBP("Electro") and GetBP("Electro").Level.Value < 299 then
								_G.Level = true
							elseif GetBP("Electro") and GetBP("Electro").Level.Value >= 300 then
								_G.Level = false
							end
						elseif Value >= 500000 then
							replicated.Remotes.CommF_:InvokeServer("BuyElectro")
						end

						if GetBP("Fishman Karate") then
							if GetBP("Fishman Karate") and GetBP("Fishman Karate").Level.Value < 299 then
								_G.Level = true
							elseif GetBP("Fishman Karate") and GetBP("Fishman Karate").Level.Value >= 300 then
								_G.Level = false
							end
						elseif Value >= 750000 then
							replicated.Remotes.CommF_:InvokeServer("BuyFishmanKarate")
						end

						if GetBP("Dragon Claw") then
							if GetBP("Dragon Claw") and GetBP("Dragon Claw").Level.Value < 299 then
								_G.Level = true
							elseif GetBP("Dragon Claw") then
								if GetBP("Dragon Claw").Level.Value >= 300 then
									_G.Level = false
								end
							end
						elseif Value2 >= 1500 then
							replicated.Remotes.CommF_:InvokeServer("BlackbeardReward", "DragonClaw", "2")
						end

						replicated.Remotes.CommF_:InvokeServer("BuySuperhuman")
					end
				end
			end)
		end
	end)
end

do
	DeathStep = GRP_Quests_Fighting_Melee_Styles:AddToggle("Auto_DeathStep", {
		Text = "Auto DeathStep",
		Default = false,
		Callback = function(isAutoDeathstepEnabled)
			_G.AutoDeathStep = isAutoDeathstepEnabled
		end
	})
end

do
	spawn(function()
		while wait(Sec) do
			if _G.AutoDeathStep then
				pcall(function()
					if plr:FindFirstChild("WeaponAssetCache") and not GetBP("Death Step") then
						if not GetBP("Black Leg") then
							replicated.Remotes.CommF_:InvokeServer("BuyBlackLeg")
						end

						if GetBP("Black Leg") and GetBP("Black Leg").Level.Value >= 400 then
							replicated.Remotes.CommF_:InvokeServer("BuyDeathStep")
							_G.Level = false
						elseif GetBP("Black Leg") and GetBP("Black Leg").Level.Value < 399 then
							_G.Level = true
						end

						if (GetBP("Black Leg") or GetBP("Black Leg").Level.Value >= 400) and workspace.Map.IceCastle.Hall.LibraryDoor.PhoeyuDoor.Transparency == 0 then
							if GetBP("Library Key") then
								while true do
									wait()
									_tp(CFrame.new(6371.2001953125, 296.63433837890625, -6841.18115234375))

									if _G.AutoDeathStep then
										if Root.Position == CFrame.new(6371.2001953125, 296.63433837890625, -6841.18115234375).Position then
											break
										end
									else
										break
									end
								end

								if Root.CFrame == CFrame.new(6371.2001953125, 296.63433837890625, -6841.18115234375) then
									replicated.Remotes.CommF_:InvokeServer("BuyDeathStep")
								end
							elseif not GetBP("Library Key") then
								local callbackMovementDataResponse = GetConnectionEnemies("Awakened Ice Admiral")

								if callbackMovementDataResponse then
									while true do
										wait()
										playerCollectionLatest.Kill(callbackMovementDataResponse, _G.AutoDeathStep)

										if callbackMovementDataResponse.Parent then
											if callbackMovementDataResponse.Humanoid.Health <= 0 or _G.AutoDeathStep == false or GetBP("Library Key") or GetBP("Death Step") then
												break
											end
										else
											break
										end
									end
								else
									_tp(CFrame.new(5668.9780273438, 28.519989013672, -6483.3520507813))
								end
							end
						end
					end
				end)
			end
		end
	end)
end

SharkManV2 = GRP_Quests_Fighting_Melee_Styles:AddToggle("Auto_Sharkman_Karate", {
	Text = "Auto Sharkman Karate",
	Default = false,
	Callback = function(isAutoSharkmanKarateEnabled)
		_G.Auto_SharkMan_Karate = isAutoSharkmanKarateEnabled
	end
})
spawn(function()
	while wait(Sec) do
		if _G.Auto_SharkMan_Karate then
			pcall(function()
				if plr:FindFirstChild("WeaponAssetCache") and not GetBP("Sharkman Karate") then
					if not GetBP("Fishman Karate") then
						replicated.Remotes.CommF_:InvokeServer("BuyFishmanKarate")
					end

					if GetBP("Fishman Karate") and GetBP("Fishman Karate").Level.Value >= 400 then
						replicated.Remotes.CommF_:InvokeServer("BuySharkmanKarate")
						_G.Level = false
					elseif GetBP("Fishman Karate") and GetBP("Fishman Karate").Level.Value < 399 then
						_G.Level = true
					end

					if GetBP("Fishman Karate") or GetBP("Fishman Karate").Level.Value >= 400 then
						if GetBP("Water Key") then
							if string.find(replicated.Remotes.CommF_:InvokeServer("BuySharkmanKarate"), "keys") and GetBP("Water Key") then
								while true do
									wait()
									_tp(CFrame.new(-2604.6958, 239.432526, -10315.1982, 0.0425701365, 0, -0.999093413, 0, 1, 0, 0.999093413, 0, 0.0425701365))

									if _G.Auto_SharkMan_Karate then
										if Root.Position == CFrame.new(-2604.6958, 239.432526, -10315.1982, 0.0425701365, 0, -0.999093413, 0, 1, 0, 0.999093413, 0, 0.0425701365).Position then
											break
										end
									else
										break
									end
								end

								replicated.Remotes.CommF_:InvokeServer("BuySharkmanKarate")
							end
						elseif not GetBP("Water Key") then
							local callbackMovementDataPayload = GetConnectionEnemies("Tide Keeper")

							if callbackMovementDataPayload then
								while true do
									wait()
									playerCollectionLatest.Kill(callbackMovementDataPayload, _G.Auto_SharkMan_Karate)

									if callbackMovementDataPayload.Parent then
										if callbackMovementDataPayload.Humanoid.Health <= 0 or _G.Auto_SharkMan_Karate == false or GetBP("Water Key") or GetBP("Sharkman Karate") then
											break
										end
									else
										break
									end
								end
							else
								_tp(CFrame.new(-3053.9814453125, 237.18954467773, -10145.0390625))
							end
						end
					end
				end
			end)
		end
	end
end)
ElectricClaw = GRP_Quests_Fighting_Melee_Styles:AddToggle("Auto_ElectricClaw", {
	Text = "Auto ElectricClaw",
	Default = false,
	Callback = function(isAutoElectricclawEnabled)
		_G.Auto_Electric_Claw = isAutoElectricclawEnabled
	end
})

do
	spawn(function()
		while wait(Sec) do
			if _G.Auto_Electric_Claw then
				pcall(function()
					if plr:FindFirstChild("WeaponAssetCache") then
						if not GetBP("Electro") then
							replicated.Remotes.CommF_:InvokeServer("BuyElectro")
						end

						if GetBP("Electro") and GetBP("Electro").Level.Value >= 400 then
							if replicated.Remotes.CommF_:InvokeServer("BuyElectricClaw", "Start") == nil then
								notween(CFrame.new(-12548, 337, -7481))
							end

							replicated.Remotes.CommF_:InvokeServer("BuyElectricClaw")
						elseif GetBP("Electro") and GetBP("Electro").Level.Value < 400 then
							while true do
								_G.AutoFarm_Bone = true
								wait()

								if _G.Auto_Electric_Claw then
									if GetBP("Electric Claw") then
										break
									end
								else
									break
								end
							end

							_G.AutoFarm_Bone = false
						end
					end
				end)
			end
		end
	end)
end

DragonTalon = GRP_Quests_Fighting_Melee_Styles:AddToggle("Auto_DragonTalon", {
	Text = "Auto DragonTalon",
	Default = false,
	Callback = function(isAutoDragontalonEnabled)
		_G.AutoDragonTalon = isAutoDragontalonEnabled
	end
})

do
	spawn(function()
		while wait(Sec) do
			if _G.AutoDragonTalon then
				pcall(function()
					if plr:FindFirstChild("WeaponAssetCache") then
						if not GetBP("Dragon Claw") then
							replicated.Remotes.CommF_:InvokeServer("BlackbeardReward", "DragonClaw", "2")
						end

						if GetBP("Dragon Claw") and GetBP("Dragon Claw").Level.Value >= 400 then
							replicated.Remotes.CommF_:InvokeServer("Bones", "Buy", 1, 1)
							replicated.Remotes.CommF_:InvokeServer("BuyDragonTalon")
						elseif GetBP("Dragon Claw") and GetBP("Dragon Claw").Level.Value < 400 then
							while true do
								_G.AutoFarm_Bone = true
								wait()

								if _G.AutoDragonTalon then
									if GetBP("Dragon Talon") then
										break
									end
								else
									break
								end
							end

							_G.AutoFarm_Bone = false
						end
					end
				end)
			end
		end
	end)
end

do
	Godhuman = GRP_Quests_Fighting_Melee_Styles:AddToggle("Auto_Godhuman", {
		Text = "Auto Godhuman",
		Default = false,
		Callback = function(isAutoGodhumanEnabled)
			_G.Auto_God_Human = isAutoGodhumanEnabled
		end
	})
end

spawn(function()
	while wait() do
		pcall(function()
			if _G.Auto_God_Human then
				if replicated.Remotes.CommF_:InvokeServer("BuyGodhuman", true) ~= "Bring me 20 Fish Tails, 20 Magma Ore, 10 Dragon Scales and 10 Mystic Droplets." then
					if replicated.Remotes.CommF_:InvokeServer("BuyGodhuman", true) == 3 then
						return nil
					end

					replicated.Remotes.CommF_:InvokeServer("BuyGodhuman")
				elseif GetM("Dragon Scale") ~= false and not (GetM("Dragon Scale") < 10) then
					if GetM("Fish Tail") ~= false and not (GetM("Fish Tail") < 20) then
						if GetM("Mystic Droplet") ~= false and not (GetM("Mystic Droplet") < 10) then
							if GetM("Magma Ore") == false or GetM("Magma Ore") < 20 then
								if World2 then
									Lv = 1175
									_G.Level = true
								else
									replicated.Remotes.CommF_:InvokeServer("TravelDressrosa")
								end
							end
						elseif World2 then
							Lv = 1425
							_G.Level = true
						else
							replicated.Remotes.CommF_:InvokeServer("TravelDressrosa")
						end
					elseif World3 then
						Lv = 1775
						_G.Level = true
					else
						replicated.Remotes.CommF_:InvokeServer("TravelZou")
					end
				elseif World3 then
					Lv = 1575
					_G.Level = true
				else
					replicated.Remotes.CommF_:InvokeServer("TravelZou")
				end
			end
		end)
	end
end)

do
	SanguineArt = GRP_Quests_Fighting_Melee_Styles:AddToggle("Auto_SanguineArt", {
		Text = "Auto SanguineArt",
		Default = false,
		Callback = function(isAutoSanguineartEnabled)
			_G.Snaguine = isAutoSanguineartEnabled
		end
	})
end

do
	spawn(function()
		while wait(Sec) do
			if _G.Snaguine then
				pcall(function()
					if not GetBP("Sanguine Art") then
						replicated.Remotes.CommF_:InvokeServer("Sanguine Art")
					end

					if GetBP("Sanguine Art") then
						replicated.Remotes.CommF_:InvokeServer("BuySanguineArt")
					else
						if GetM("Leviathan Heart") >= 1 then
							print("Completed!!")
						elseif World3 then
							_G.DangerSc = "Lv Infinite"
							_G.SailBoats = true
						else
							_G.SailBoats = false
						end

						if GetM("Vampire Fang") <= 19 then
							if World2 then
								local Vampire = GetConnectionEnemies("Vampire")

								if Vampire then
									while true do
										task.wait()
										playerCollectionLatest.Kill(Vampire, _G.Snaguine)

										if _G.Snaguine then
											if Vampire.Humanoid.Health <= 0 or not Vampire.Parent then
												break
											end
										else
											break
										end
									end
								else
									_tp(CFrame.new(-6041.29248046875, 6.4027109146118164, -1304.63330078125))
								end
							else
								replicated.Remotes.CommF_:InvokeServer("TravelDressrosa")
							end
						end

						if GetM("Vampire Fang") >= 20 and GetM("Demonic Wisp") <= 19 then
							if World3 then
								local callbackMovementDataRecord = GetConnectionEnemies("Demonic Soul")

								if callbackMovementDataRecord then
									while true do
										task.wait()
										playerCollectionLatest.Kill(callbackMovementDataRecord, _G.Snaguine)

										if _G.Snaguine then
											if callbackMovementDataRecord.Humanoid.Health <= 0 or not callbackMovementDataRecord.Parent then
												break
											end
										else
											break
										end
									end
								else
									_tp(CFrame.new(-9495.6806640625, 453.58624267578125, 5977.3486328125))
								end
							else
								replicated.Remotes.CommF_:InvokeServer("TravelZou")
							end
						end

						if GetM("Vampire Fang") >= 20 and GetM("Demonic Wisp") >= 20 and GetM("Dark Fragment") <= 1 then
							if World2 then
								if GetConnectionEnemies("Darkbeard") then
									while true do
										task.wait()
										playerCollectionLatest.Kill(black, _G.Snaguine)

										if _G.Snaguine then
											break
										elseif black.Humanoid.Health <= 0 or not black.Parent then
											break
										end
									end
								else
									_tp(CFrame.new(3798.4575195313, 13.826690673828, -3399.806640625))
								end
							else
								replicated.Remotes.CommF_:InvokeServer("TravelDressrosa")
							end
						end
					end
				end)
			end
		end
	end)
end

GRP_Race_Mystic_Island_Full_Moon = tabs.Race:AddLeftGroupbox("Mystic Island / Full Moon")

do
	local grpRaceMysticIslandFullMoonDataState = GRP_Race_Mystic_Island_Full_Moon:AddLabel("")
	local grpRaceMysticIslandFullMoonData = GRP_Race_Mystic_Island_Full_Moon:AddLabel("")

	spawn(function()
		while wait(0.2) do
			if not workspace.Map:FindFirstChild("MysticIsland") then
				if not workspace._WorldOrigin.Locations:FindFirstChild("Mirage Island") then
					grpRaceMysticIslandFullMoonData:SetText("Mirage Island : False")

					continue
				end
			end

			grpRaceMysticIslandFullMoonData:SetText("Mirage Island : True")
		end
	end)
	spawn(function()
		while wait(0.2) do
			pcall(function()
				local grpRaceMysticIslandFullMoonResult = Getmoon()

				if grpRaceMysticIslandFullMoonResult == "http://www.roblox.com/asset/?id=9709135895" then
					grpRaceMysticIslandFullMoonDataState:SetText("Moon : 0 / 8")
				elseif grpRaceMysticIslandFullMoonResult == "http://www.roblox.com/asset/?id=9709139597" then
					grpRaceMysticIslandFullMoonDataState:SetText("Moon : 1 / 8")
				elseif grpRaceMysticIslandFullMoonResult == "http://www.roblox.com/asset/?id=9709143733" then
					grpRaceMysticIslandFullMoonDataState:SetText("Moon : 2 / 8")
				elseif grpRaceMysticIslandFullMoonResult == "http://www.roblox.com/asset/?id=9709149052" then
					grpRaceMysticIslandFullMoonDataState:SetText("Moon : 3 / 8 [ Next Night ]")
				elseif grpRaceMysticIslandFullMoonResult == "http://www.roblox.com/asset/?id=9709149431" then
					grpRaceMysticIslandFullMoonDataState:SetText("Moon : 4 / 8 [ Full Moon ]")
				elseif grpRaceMysticIslandFullMoonResult == "http://www.roblox.com/asset/?id=9709149680" then
					grpRaceMysticIslandFullMoonDataState:SetText("Moon : 5 / 8 [ Last Night ]")
				elseif grpRaceMysticIslandFullMoonResult == "http://www.roblox.com/asset/?id=9709150086" then
					grpRaceMysticIslandFullMoonDataState:SetText("Moon : 6 / 8")
				elseif grpRaceMysticIslandFullMoonResult == "http://www.roblox.com/asset/?id=9709150401" then
					grpRaceMysticIslandFullMoonDataState:SetText("Moon : 7 / 8")
				end
			end)
		end
	end)
end

GRP_Race_Mystic_Island_Full_Moon:AddToggle("Auto_Find_Mirage_Island", {
	Text = "Auto Find Mirage Island",
	Default = false,
	Callback = function(isAutoFindMirageIslandEnabled)
		_G.FindMirage = isAutoFindMirageIslandEnabled
	end
})
spawn(function()
	while wait() do
		if _G.FindMirage then
			pcall(function()
				if workspace._WorldOrigin.Locations:FindFirstChild("Mirage Island", true) then
					_tp(workspace.Map:FindFirstChild("MysticIsland").Center.CFrame * CFrame.new(0, 300, 0))
				else
					local callbackPlayerDataPayload = CheckBoat()

					if callbackPlayerDataPayload then
						if plr.Character.Humanoid.Sit == false then
							_tp(callbackPlayerDataPayload.VehicleSeat.CFrame * CFrame.new(0, 1, 0))
						else
							while true do
								wait()

								local cFrame = CFrame.new(-10000000, 31, 37016.25)

								if CheckEnemiesBoat() or CheckTerrorShark() or CheckPirateGrandBrigade() then
									_tp(CFrame.new(-10000000, 150, 37016.25))
								else
									_tp(CFrame.new(-10000000, 31, 37016.25))
								end

								if _G.FindMirage and not ((cFrame.Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10) then
									if not (workspace._WorldOrigin.Locations:FindFirstChild("Mirage Island") or plr.Character.Humanoid.Sit == false) then
										continue
									end
								end

								break
							end

							plr.Character.Humanoid.Sit = false
						end
					else
						local cFrame = CFrame.new(-16927.451, 9.086, 433.864)

						TeleportToTarget(cFrame)

						if (cFrame.Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10 then
							replicated.Remotes.CommF_:InvokeServer("BuyBoat", _G.SelectedBoat)
						end
					end
				end
			end)
		end
	end
end)
GRP_Race_Mystic_Island_Full_Moon:AddToggle("Esp_Mirage_Island", {
	Text = "Esp Mirage Island",
	Default = false,
	Callback = function(isEspMirageIslandEnabled)
		MirageIslandESP = isEspMirageIslandEnabled

		if MirageIslandESP then
			task.spawn(function()
				while MirageIslandESP do
					UpdateIslandMirageESP()
					task.wait(1)
				end
			end)
		else
			UpdateIslandMirageESP()
		end
	end
})

do
	GRP_Race_Mystic_Island_Full_Moon:AddToggle("Auto_Tween_To_Mirage_Island", {
		Text = "Auto Tween To Mirage Island",
		Default = false,
		Callback = function(isAutoTweenToMirageIslandEnabled)
			_G.AutoMysticIsland = isAutoTweenToMirageIslandEnabled
		end
	})
end

spawn(function()
	while task.wait(0.1) do
		pcall(function()
			if _G.AutoMysticIsland then
				for _, child in pairs(game:GetService("Workspace")._WorldOrigin.Locations:GetChildren()) do
					if child.Name == "Mirage Island" then
						topos(child.CFrame * CFrame.new(0, 333, 0))
					end
				end
			end
		end)
	end
end)
GRP_Race_Mystic_Island_Full_Moon:AddToggle("Auto_Tween_To_Highest_Point", {
	Text = "Auto Tween To Highest Point",
	Default = false,
	Callback = function(isAutoTweenToHighestPointEnabled)
		_G.HighestMirage = isAutoTweenToHighestPointEnabled
	end
})
spawn(function()
	while wait(Sec) do
		if _G.HighestMirage then
			pcall(function()
				if workspace._WorldOrigin.Locations:FindFirstChild("Mirage Island", true) then
					_tp(workspace.Map:FindFirstChild("MysticIsland").Center.CFrame * CFrame.new(0, 400, 0))
				end
			end)
		end
	end
end)
GRP_Race_Mystic_Island_Full_Moon:AddToggle("Auto_Collect_Gear", {
	Text = "Auto Collect Gear",
	Default = false,
	Callback = function(isAutoCollectGearEnabled)
		_G.TPGEAR = isAutoCollectGearEnabled
	end
})
spawn(function()
	pcall(function()
		while wait(0.1) do
			if _G.TPGEAR then
				local pairs_ = pairs
				local MysticIsland = workspace.Map:FindFirstChild("MysticIsland")

				for _, child in pairs_(MysticIsland:GetChildren()) do
					if child.Name == "Part" and child.ClassName == "MeshPart" then
						_tp(child.CFrame)
					end
				end
			end
		end
	end)
end)

do
	GRP_Race_Mystic_Island_Full_Moon:AddToggle("Change_Transparency_can_see", {
		Text = "Change Transparency can see",
		Default = false,
		Callback = function(isChangeTransparencyCanSeeEnabled)
			_G.can = isChangeTransparencyCanSeeEnabled
		end
	})
end

spawn(function()
	pcall(function()
		while wait(Sec) do
			if _G.can then
				local pairs_ = pairs
				local MysticIsland = workspace.Map:FindFirstChild("MysticIsland")

				for _, child in pairs_(MysticIsland:GetChildren()) do
					if child.Name == "Part" then
						if child.ClassName == "MeshPart" then
							child.Transparency = 0
						else
							child.Transparency = 1
						end
					end
				end
			end
		end
	end)
end)

do
	GRP_Race_Mystic_Island_Full_Moon:AddToggle("Auto_Tween_Advanced_Fruit_Dealer", {
		Text = "Auto Tween Advanced Fruit Dealer",
		Default = false,
		Callback = function(isAutoTweenAdvancedFruitDealerEnabled)
			_G.Addealer = isAutoTweenAdvancedFruitDealerEnabled
		end
	})
end

do
	spawn(function()
		while wait() do
			if _G.Addealer then
				pcall(function()
					for _, child in pairs(replicated.NPCs:GetChildren()) do
						if child.Name == "Advanced Fruit Dealer" then
							_tp(child.HumanoidRootPart.CFrame)
						end
					end
				end)
			end
		end
	end)
end

do
	GRP_Race_Mystic_Island_Full_Moon:AddToggle("Auto_Collect_Mirage_Chest", {
		Text = "Auto Collect Mirage Chest",
		Default = false,
		Callback = function(isAutoCollectMirageChestEnabled)
			_G.FarmChestM = isAutoCollectMirageChestEnabled
		end
	})
end

do
	spawn(function()
		while wait(0.2) do
			if _G.FarmChestM then
				pcall(function()
					local ok2 = workspace.Map:FindFirstChild("MysticIsland").Chests:FindFirstChild("DiamondChest")

					if not ok2 then
						ok2 = not not workspace.Map:FindFirstChild("MysticIsland").Chests:FindFirstChild("FragChest")
					end

					if ok2 then
						local CollectionService = game:GetService("CollectionService")
						local LocalPlayer = game:GetService("Players").LocalPlayer
						local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

						if not Character then
							return
						end

						local Position = Character:GetPivot().Position
						local tagged = CollectionService:GetTagged("_ChestTagged")
						local huge = math.huge
						local callbackPlayerDataRecord
						local n5 = 1
						local callbackPlayerDataDetails = #tagged
						local callbackPlayerDataSnapshot, exitTo, callbackPlayerDataContext, callbackPlayerDataOption, Magnitude

						if true then
							if n5 <= callbackPlayerDataDetails then
								repeat
									callbackPlayerDataContext = n5
									exitTo = nil

									while true do
										callbackPlayerDataOption = tagged[callbackPlayerDataContext]
										Magnitude = (callbackPlayerDataOption:GetPivot().Position - Position).Magnitude

										if (not SelectedIsland or callbackPlayerDataOption:IsDescendantOf(SelectedIsland)) and not callbackPlayerDataOption:GetAttribute("IsDisabled") and Magnitude < huge then
											huge = Magnitude
											callbackPlayerDataRecord = callbackPlayerDataOption
										end

										callbackPlayerDataSnapshot += nil

										if not (nil <= 0) then
											exitTo = 1

											break
										elseif callbackPlayerDataSnapshot >= nil then
											callbackPlayerDataContext = n5

											continue
										end

										break
									end
								until exitTo ~= 1 or not (callbackPlayerDataSnapshot <= nil)

								if callbackPlayerDataRecord then
									_tp(callbackPlayerDataRecord:GetPivot())
								end
							end
						else
							if not (n5 >= callbackPlayerDataDetails) then
								return
							end

							local exitTo2

							while true do
								callbackPlayerDataContext = n5
								callbackPlayerDataOption = tagged[callbackPlayerDataContext]
								Magnitude = (callbackPlayerDataOption:GetPivot().Position - Position).Magnitude

								if (not SelectedIsland or callbackPlayerDataOption:IsDescendantOf(SelectedIsland)) and not callbackPlayerDataOption:GetAttribute("IsDisabled") and Magnitude < huge then
									huge = Magnitude
									callbackPlayerDataRecord = callbackPlayerDataOption
								end

								callbackPlayerDataSnapshot += nil

								if not (nil <= 0) then
									exitTo2 = 1

									break
								elseif callbackPlayerDataSnapshot >= nil then
									continue
								end

								break
							end

							if exitTo2 == 1 and callbackPlayerDataSnapshot <= nil then
								repeat
									callbackPlayerDataContext = n5
									exitTo = nil

									while true do
										callbackPlayerDataOption = tagged[callbackPlayerDataContext]
										Magnitude = (callbackPlayerDataOption:GetPivot().Position - Position).Magnitude

										if (not SelectedIsland or callbackPlayerDataOption:IsDescendantOf(SelectedIsland)) and not callbackPlayerDataOption:GetAttribute("IsDisabled") and Magnitude < huge then
											huge = Magnitude
											callbackPlayerDataRecord = callbackPlayerDataOption
										end

										callbackPlayerDataSnapshot += nil

										if not (nil <= 0) then
											exitTo = 1

											break
										elseif callbackPlayerDataSnapshot >= nil then
											callbackPlayerDataContext = n5

											continue
										end

										break
									end
								until exitTo ~= 1 or not (callbackPlayerDataSnapshot <= nil)

								if callbackPlayerDataRecord then
									_tp(callbackPlayerDataRecord:GetPivot())
								end
							elseif callbackPlayerDataRecord then
								_tp(callbackPlayerDataRecord:GetPivot())
							end
						end
					end
				end)
			end
		end
	end)
end

GRP_Race_Mystic_Island_Full_Moon:AddButton({
	Text = "Talk With Stone",
	Func = function()
		local CommF_ = replicated:WaitForChild("Remotes"):WaitForChild("CommF_")

		CommF_:InvokeServer("RaceV4Progress", "Begin")
		CommF_:InvokeServer("RaceV4Progress", "Check")
		CommF_:InvokeServer("RaceV4Progress", "Teleport")
	end
})
GRP_Race_Mystic_Island_Full_Moon:AddToggle("Auto_Look_At_Moon", {
	Text = "Auto Look At Moon",
	Default = false,
	Callback = function(isAutoLookAtMoonEnabled)
		_G.Auto_Mink = isAutoLookAtMoonEnabled
	end
})
MoveCamtoMoon = function()
	workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, Lighting:GetMoonDirection() + workspace.CurrentCamera.CFrame.Position)
	plr.Character.HumanoidRootPart.CFrame = CFrame.new(plr.Character.HumanoidRootPart.Position, Lighting:GetMoonDirection() + plr.Character.HumanoidRootPart.CFrame.Position)
end

do
	task.spawn(function()
		while task.wait() do
			if LookM then
				MoveCamtoMoon()
				wait(0.1)
				replicated.Remotes.CommE:FireServer("ActivateAbility")
			end
		end
	end)
end

do
	GRP_Race_Mystic_Island_Full_Moon:AddToggle("Look_Moon_+_Auto_V3", {
		Text = "Look Moon + Auto V3",
		Default = false,
		Callback = function(isLookMoonAutoVEnabled)
			LookMV3 = isLookMoonAutoVEnabled
		end
	})
end

MoveCamtoMoon = function()
	local moonDirection = Lighting:GetMoonDirection()

	workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, workspace.CurrentCamera.CFrame.Position + moonDirection)
	plr.Character.HumanoidRootPart.CFrame = CFrame.new(plr.Character.HumanoidRootPart.Position, plr.Character.HumanoidRootPart.Position + moonDirection)
end
task.spawn(function()
	while task.wait(0.1) do
		if LookMV3 then
			MoveCamtoMoon()
			replicated.Remotes.CommE:FireServer("ActivateAbility")
			UIS:SendKeyEvent(true, "T", true, game)
			wait(0.5)
			UIS:SendKeyEvent(false, "T", true, game)
		end
	end
end)
GRP_Race_Upgrade_Races_V2_And_V3 = tabs.Race:AddLeftGroupbox("Upgrade Races V2 And V3")

do
	RaceMink = GRP_Race_Upgrade_Races_V2_And_V3:AddToggle("Auto_Upgrade_Mink", {
		Text = "Auto Upgrade Mink",
		Default = false,
		Callback = function(isAutoUpgradeMinkEnabled)
			_G.Auto_Mink = isAutoUpgradeMinkEnabled
		end
	})
end

do
	spawn(function()
		while wait(Sec) do
			pcall(function()
				if _G.Auto_Mink then
					if replicated.Remotes.CommF_:InvokeServer("Alchemist", "1") ~= 2 then
						if replicated.Remotes.CommF_:InvokeServer("Alchemist", "1") == 0 then
							replicated.Remotes.CommF_:InvokeServer("Alchemist", "2")
						elseif replicated.Remotes.CommF_:InvokeServer("Alchemist", "1") == 1 then
							local ok2 = plr.Backpack:FindFirstChild("Flower 1")

							if not ok2 then
								ok2 = plr.Character:FindFirstChild("Flower 1")
							end

							if ok2 then
								local ok = plr.Backpack:FindFirstChild("Flower 2")

								if not ok then
									ok = plr.Character:FindFirstChild("Flower 2")
								end

								if not ok then
									_tp(workspace.Flower2.CFrame)
								elseif not plr.Backpack:FindFirstChild("Flower 3") then
									if not plr.Character:FindFirstChild("Flower 3") then
										local callbackPlayerDataSelection = GetConnectionEnemies("Swan Pirate")

										if callbackPlayerDataSelection then
											while true do
												wait()
												playerCollectionLatest.Kill(callbackPlayerDataSelection, _G.Auto_Mink)

												if GetBP("Flower 3") then
													break
												elseif not callbackPlayerDataSelection.Parent or callbackPlayerDataSelection.Humanoid.Health <= 0 or _G.Auto_Mink == false then
													break
												end
											end
										else
											_tp(CFrame.new(980.0985107421875, 121.331298828125, 1287.2093505859375))
										end
									end
								end
							else
								_tp(workspace.Flower1.CFrame)
							end
						elseif replicated.Remotes.CommF_:InvokeServer("Alchemist", "1") == 2 then
							replicated.Remotes.CommF_:InvokeServer("Alchemist", "3")
						end
					elseif replicated.Remotes.CommF_:InvokeServer("Wenlocktoad", "1") == 0 then
						replicated.Remotes.CommF_:InvokeServer("Wenlocktoad", "2")
					elseif replicated.Remotes.CommF_:InvokeServer("Wenlocktoad", "1") == 1 then
						_G.AutoFarmChest = true
					else
						_G.AutoFarmChest = false
					end
				end
			end)
		end
	end)
end

RaceHuman = GRP_Race_Upgrade_Races_V2_And_V3:AddToggle("Auto_Upgrade_Human", {
	Text = "Auto Upgrade Human",
	Default = false,
	Callback = function(isAutoUpgradeHumanEnabled)
		_G.Auto_Human = isAutoUpgradeHumanEnabled
	end
})
spawn(function()
	while wait(Sec) do
		pcall(function()
			if _G.Auto_Human then
				if replicated.Remotes.CommF_:InvokeServer("Alchemist", "1") ~= -2 then
					if replicated.Remotes.CommF_:InvokeServer("Alchemist", "1") == 0 then
						replicated.Remotes.CommF_:InvokeServer("Alchemist", "2")
					elseif replicated.Remotes.CommF_:InvokeServer("Alchemist", "1") == 1 then
						local ok2 = plr.Backpack:FindFirstChild("Flower 1")

						if not ok2 then
							ok2 = plr.Character:FindFirstChild("Flower 1")
						end

						if ok2 then
							local ok = plr.Backpack:FindFirstChild("Flower 2")

							if not ok then
								ok = plr.Character:FindFirstChild("Flower 2")
							end

							if not ok then
								_tp(workspace.Flower2.CFrame)
							elseif not plr.Backpack:FindFirstChild("Flower 3") then
								if not plr.Character:FindFirstChild("Flower 3") then
									local callbackPlayerDataOutput = GetConnectionEnemies("Swan Pirate")

									if callbackPlayerDataOutput then
										while true do
											wait()
											playerCollectionLatest.Kill(callbackPlayerDataOutput, _G.Auto_Human)

											if plr.Backpack:FindFirstChild("Flower 3") then
												break
											elseif not callbackPlayerDataOutput.Parent or callbackPlayerDataOutput.Humanoid.Health <= 0 or _G.Auto_Human == false then
												break
											end
										end
									else
										_tp(CFrame.new(980.0985107421875, 121.331298828125, 1287.2093505859375))
									end
								end
							end
						else
							_tp(workspace.Flower1.CFrame)
						end
					elseif replicated.Remotes.CommF_:InvokeServer("Alchemist", "1") == 2 then
						replicated.Remotes.CommF_:InvokeServer("Alchemist", "3")
					end
				elseif replicated.Remotes.CommF_:InvokeServer("Wenlocktoad", "1") == 0 then
					replicated.Remotes.CommF_:InvokeServer("Wenlocktoad", "2")
				elseif replicated.Remotes.CommF_:InvokeServer("Wenlocktoad", "1") == 1 then
					local callbackMovementDataDetails = GetConnectionEnemies(locationDataNext[1])
					local callbackMovementDataSnapshot

					if callbackMovementDataDetails then
						while true do
							wait()
							playerCollectionLatest.Kill(callbackMovementDataDetails, _G.Auto_Human)

							if callbackMovementDataDetails.Humanoid.Health <= 0 then
								break
							elseif not callbackMovementDataDetails.Parent or not _G.Auto_Human then
								break
							end
						end

						callbackMovementDataSnapshot = GetConnectionEnemies(locationDataNext[2])

						if callbackMovementDataSnapshot then
							while true do
								wait()
								playerCollectionLatest.Kill(callbackMovementDataSnapshot, _G.Auto_Human)

								if callbackMovementDataSnapshot.Humanoid.Health <= 0 then
									break
								elseif not callbackMovementDataSnapshot.Parent or not _G.Auto_Human then
									break
								end
							end
						else
							_tp(CFrame.new(2006.9261474609, 448.95666503906, 853.98284912109))
						end
					else
						_tp(CFrame.new(-2172.7399902344, 103.32216644287, -4015.025390625))
						callbackMovementDataSnapshot = GetConnectionEnemies(locationDataNext[2])

						if callbackMovementDataSnapshot then
							while true do
								wait()
								playerCollectionLatest.Kill(callbackMovementDataSnapshot, _G.Auto_Human)

								if callbackMovementDataSnapshot.Humanoid.Health <= 0 then
									break
								elseif not callbackMovementDataSnapshot.Parent or not _G.Auto_Human then
									break
								end
							end
						else
							_tp(CFrame.new(2006.9261474609, 448.95666503906, 853.98284912109))
						end
					end

					local callbackMovementDataContext = GetConnectionEnemies(locationDataNext[3])

					if callbackMovementDataContext then
						while true do
							wait()
							playerCollectionLatest.Kill(callbackMovementDataContext, _G.Auto_Human)

							if callbackMovementDataContext.Humanoid.Health <= 0 then
								break
							elseif not callbackMovementDataContext.Parent or not _G.Auto_Human then
								break
							end
						end
					else
						_tp(CFrame.new(-1576.7166748047, 198.59265136719, 13.724286079407))
					end
				end
			end
		end)
	end
end)
RaceSky = GRP_Race_Upgrade_Races_V2_And_V3:AddToggle("Auto_Upgrade_Angel", {
	Text = "Auto Upgrade Angel",
	Default = false,
	Callback = function(isAutoUpgradeAngelEnabled)
		_G.Auto_Skypiea = isAutoUpgradeAngelEnabled
	end
})
spawn(function()
	while wait(Sec) do
		pcall(function()
			if _G.Auto_Skypiea then
				if replicated.Remotes.CommF_:InvokeServer("Alchemist", "1") ~= -2 then
					if replicated.Remotes.CommF_:InvokeServer("Alchemist", "1") == 0 then
						replicated.Remotes.CommF_:InvokeServer("Alchemist", "2")
					elseif replicated.Remotes.CommF_:InvokeServer("Alchemist", "1") == 1 then
						local ok2 = plr.Backpack:FindFirstChild("Flower 1")

						if not ok2 then
							ok2 = plr.Character:FindFirstChild("Flower 1")
						end

						if ok2 then
							local ok = plr.Backpack:FindFirstChild("Flower 2")

							if not ok then
								ok = plr.Character:FindFirstChild("Flower 2")
							end

							if not ok then
								_tp(workspace.Flower2.CFrame)
							elseif not plr.Backpack:FindFirstChild("Flower 3") then
								if not plr.Character:FindFirstChild("Flower 3") then
									local callbackPlayerDataInput = GetConnectionEnemies("Swan Pirate")

									if callbackPlayerDataInput then
										while true do
											wait()
											playerCollectionLatest.Kill(callbackPlayerDataInput, _G.Auto_Skypiea)

											if plr.Backpack:FindFirstChild("Flower 3") then
												break
											elseif not callbackPlayerDataInput.Parent or callbackPlayerDataInput.Humanoid.Health <= 0 or _G.Auto_Skypiea == false then
												break
											end
										end
									else
										_tp(CFrame.new(980.0985107421875, 121.331298828125, 1287.2093505859375))
									end
								end
							end
						else
							_tp(workspace.Flower1.CFrame)
						end
					elseif replicated.Remotes.CommF_:InvokeServer("Alchemist", "1") == 2 then
						replicated.Remotes.CommF_:InvokeServer("Alchemist", "3")
					end
				elseif replicated.Remotes.CommF_:InvokeServer("Wenlocktoad", "1") == 0 then
					replicated.Remotes.CommF_:InvokeServer("Wenlocktoad", "2")
				elseif replicated.Remotes.CommF_:InvokeServer("Wenlocktoad", "1") == 1 then
					for _, child in pairs(game.Players:GetChildren()) do
						if child.Name ~= plr.Name and tostring(child.Data.Race.Value) == "Skypiea" then
							while true do
								task.wait()
								_tp(child.HumanoidRootPart.CFrame * CFrame.new(0, 8, 0) * CFrame.Angles(math.rad(-45), 0, 0))

								if child.Humanoid.Health <= 0 then
									break
								elseif _G.Auto_Skypiea == false then
									break
								end
							end
						end
					end
				end
			end
		end)
	end
end)

do
	RaceFish = GRP_Race_Upgrade_Races_V2_And_V3:AddToggle("Auto_Upgrade_FishMan", {
		Text = "Auto Upgrade FishMan",
		Default = false,
		Callback = function(isAutoUpgradeFishmanEnabled)
			_G.Auto_Fish = isAutoUpgradeFishmanEnabled
		end
	})
end

spawn(function()
	while wait(Sec) do
		pcall(function()
			if _G.Auto_Fish then
				if replicated.Remotes.CommF_:InvokeServer("Alchemist", "1") ~= -2 then
					if replicated.Remotes.CommF_:InvokeServer("Alchemist", "1") == 0 then
						replicated.Remotes.CommF_:InvokeServer("Alchemist", "2")
					elseif replicated.Remotes.CommF_:InvokeServer("Alchemist", "1") == 1 then
						local ok2 = plr.Backpack:FindFirstChild("Flower 1")

						if not ok2 then
							ok2 = plr.Character:FindFirstChild("Flower 1")
						end

						if ok2 then
							local ok = plr.Backpack:FindFirstChild("Flower 2")

							if not ok then
								ok = plr.Character:FindFirstChild("Flower 2")
							end

							if not ok then
								_tp(workspace.Flower2.CFrame)
							elseif not plr.Backpack:FindFirstChild("Flower 3") then
								if not plr.Character:FindFirstChild("Flower 3") then
									local callbackPlayerDataSource = GetConnectionEnemies("Swan Pirate")

									if callbackPlayerDataSource then
										while true do
											wait()
											playerCollectionLatest.Kill(callbackPlayerDataSource, _G.Auto_Fish)

											if plr.Backpack:FindFirstChild("Flower 3") then
												break
											elseif not callbackPlayerDataSource.Parent or callbackPlayerDataSource.Humanoid.Health <= 0 or _G.Auto_Fish == false then
												break
											end
										end
									else
										_tp(CFrame.new(980.0985107421875, 121.331298828125, 1287.2093505859375))
									end
								end
							end
						else
							_tp(workspace.Flower1.CFrame)
						end
					elseif replicated.Remotes.CommF_:InvokeServer("Alchemist", "1") == 2 then
						replicated.Remotes.CommF_:InvokeServer("Alchemist", "3")
					end
				elseif replicated.Remotes.CommF_:InvokeServer("Wenlocktoad", "1") == 0 then
					replicated.Remotes.CommF_:InvokeServer("Wenlocktoad", "2")
				elseif replicated.Remotes.CommF_:InvokeServer("Wenlocktoad", "1") == 1 then
					warn("Sea Beast Soon")
				end
			end
		end)
	end
end)
GRP_Race_Trials_Quest_V4 = tabs.Race:AddLeftGroupbox("Trials Quest V4")

do
	local grpRaceTrialsQuestVData = GRP_Race_Trials_Quest_V4:AddLabel("")

	spawn(function()
		pcall(function()
			while wait(0.2) do
				grpRaceTrialsQuestVData:SetText("Tiers - V4 : " .. " " .. plr.Data.Race.C.Value)
			end
		end)
	end)
end

do
	PullLv = GRP_Race_Trials_Quest_V4:AddToggle("Auto_Pull_Lever", {
		Text = "Auto Pull Lever",
		Default = false,
		Callback = function(isAutoPullLeverEnabled)
			_G.Lver = isAutoPullLeverEnabled
		end
	})
end

spawn(function()
	while wait(Sec) do
		if _G.Lver then
			pcall(function()
				for _, descendant in pairs(workspace.Map["Temple of Time"]:GetDescendants()) do
					if descendant.Name == "ProximityPrompt" then
						fireproximityprompt(descendant, math.huge)
					end
				end
			end)
		end
	end
end)

do
	Train = GRP_Race_Trials_Quest_V4:AddToggle("Auto_Train_V4", {
		Text = "Auto Train V4",
		Default = false,
		Callback = function(isAutoTrainVEnabled)
			_G.AcientOne = isAutoTrainVEnabled
		end
	})
end

do
	spawn(function()
		while wait(Sec) do
			pcall(function()
				if _G.AcientOne then
					local callbackEntriesEntry = {
						"Reborn Skeleton",
						"Living Zombie",
						"Demonic Soul",
						"Posessed Mummy"
					}
					local callbackPlayerDataTarget = #callbackEntriesEntry
					local n6 = 1
					local callbackPlayerDataValue = callbackPlayerDataTarget + 0
					local callbackPlayerDataCallbackState = 1 - n6
					local exitTo

					for i = 1, callbackPlayerDataTarget do
						if plr.Character:FindFirstChild("RaceEnergy").Value ~= 1 then
							if plr.Character:FindFirstChild("RaceTransformed").Value == false then
								local callbackPlayerDataCallbackData = GetConnectionEnemies(callbackEntriesEntry)

								if not callbackPlayerDataCallbackData then
									_tp(CFrame.new(-9495.6806640625, 453.58624267578125, 5977.3486328125))

									continue
								end

								while true do
									wait()
									playerCollectionLatest.Kill(callbackPlayerDataCallbackData, _G.AcientOne)

									if _G.AcientOne == false then
										break
									elseif callbackPlayerDataCallbackData.Humanoid.Health <= 0 or not callbackPlayerDataCallbackData.Parent then
										break
									end
								end
							end

							continue
						end

						repeat
							vim1:SendKeyEvent(true, "Y", true, game)
							replicated.Remotes.CommF_:InvokeServer("UpgradeRace", "Buy")
							vim1:SendKeyEvent(false, "Y", true, game)
							_tp(CFrame.new(-8987.041015625, 215.862060546875, 5886.71044921875))
							exitTo = nil

							local exitTo2
							local Character, Character2, callbackPlayerDataCallbackItem

							while true do
								callbackPlayerDataCallbackState += n6

								if not (n6 <= 0) then
									exitTo2 = 1

									break
								end

								if not (callbackPlayerDataCallbackState >= callbackPlayerDataValue) then
									break
								end

								Character = plr.Character

								if Character:FindFirstChild("RaceEnergy").Value == 1 then
									exitTo2 = 2

									break
								end

								Character2 = plr.Character

								if Character2:FindFirstChild("RaceTransformed").Value ~= false then
									continue
								end

								callbackPlayerDataCallbackItem = GetConnectionEnemies(callbackEntriesEntry)

								if not callbackPlayerDataCallbackItem then
									exitTo2 = 3

									break
								end

								while true do
									wait()
									playerCollectionLatest.Kill(callbackPlayerDataCallbackItem, _G.AcientOne)

									if _G.AcientOne == false then
										break
									elseif callbackPlayerDataCallbackItem.Humanoid.Health <= 0 or not callbackPlayerDataCallbackItem.Parent then
										break
									end
								end
							end

							if exitTo2 == 1 then
								if callbackPlayerDataCallbackState <= callbackPlayerDataValue then
									while true do
										Character = plr.Character

										if Character:FindFirstChild("RaceEnergy").Value == 1 then
											exitTo = 1

											break
										end

										Character2 = plr.Character

										if Character2:FindFirstChild("RaceTransformed").Value == false then
											callbackPlayerDataCallbackItem = GetConnectionEnemies(callbackEntriesEntry)

											if not callbackPlayerDataCallbackItem then
												exitTo = 2

												break
											end

											local exitTo3

											while true do
												wait()
												playerCollectionLatest.Kill(callbackPlayerDataCallbackItem, _G.AcientOne)

												if _G.AcientOne == false then
													break
												elseif callbackPlayerDataCallbackItem.Humanoid.Health <= 0 or not callbackPlayerDataCallbackItem.Parent then
													exitTo3 = 1

													break
												end
											end

											if exitTo3 == 1 then
												local exitTo4

												while true do
													callbackPlayerDataCallbackState += n6

													if not (n6 <= 0) then
														exitTo4 = 1

														break
													end

													if not (callbackPlayerDataCallbackState >= callbackPlayerDataValue) then
														break
													end

													Character = plr.Character

													if Character:FindFirstChild("RaceEnergy").Value == 1 then
														exitTo4 = 2

														break
													end

													Character2 = plr.Character

													if Character2:FindFirstChild("RaceTransformed").Value ~= false then
														continue
													end

													callbackPlayerDataCallbackItem = GetConnectionEnemies(callbackEntriesEntry)

													if not callbackPlayerDataCallbackItem then
														exitTo4 = 3

														break
													end

													while true do
														wait()
														playerCollectionLatest.Kill(callbackPlayerDataCallbackItem, _G.AcientOne)

														if _G.AcientOne == false then
															break
														elseif callbackPlayerDataCallbackItem.Humanoid.Health <= 0 or not callbackPlayerDataCallbackItem.Parent then
															break
														end
													end
												end

												if exitTo4 == 1 then
													if callbackPlayerDataCallbackState <= callbackPlayerDataValue then
														continue
													end
												else
													if exitTo4 == 2 then
														exitTo = 1
													elseif exitTo4 == 3 then
														exitTo = 2
													end

													break
												end
											else
												local exitTo5

												while true do
													callbackPlayerDataCallbackState += n6

													if not (n6 <= 0) then
														exitTo5 = 1

														break
													end

													if not (callbackPlayerDataCallbackState >= callbackPlayerDataValue) then
														break
													end

													Character = plr.Character

													if Character:FindFirstChild("RaceEnergy").Value == 1 then
														exitTo5 = 2

														break
													end

													Character2 = plr.Character

													if Character2:FindFirstChild("RaceTransformed").Value ~= false then
														continue
													end

													callbackPlayerDataCallbackItem = GetConnectionEnemies(callbackEntriesEntry)

													if not callbackPlayerDataCallbackItem then
														exitTo5 = 3

														break
													end

													while true do
														wait()
														playerCollectionLatest.Kill(callbackPlayerDataCallbackItem, _G.AcientOne)

														if _G.AcientOne == false then
															break
														elseif callbackPlayerDataCallbackItem.Humanoid.Health <= 0 or not callbackPlayerDataCallbackItem.Parent then
															break
														end
													end
												end

												if exitTo5 == 1 then
													if callbackPlayerDataCallbackState <= callbackPlayerDataValue then
														continue
													end
												else
													if exitTo5 == 2 then
														exitTo = 1
													elseif exitTo5 == 3 then
														exitTo = 2
													end

													break
												end
											end
										else
											local exitTo6

											while true do
												callbackPlayerDataCallbackState += n6

												if not (n6 <= 0) then
													exitTo6 = 1

													break
												end

												if not (callbackPlayerDataCallbackState >= callbackPlayerDataValue) then
													break
												end

												Character = plr.Character

												if Character:FindFirstChild("RaceEnergy").Value == 1 then
													exitTo6 = 2

													break
												end

												Character2 = plr.Character

												if Character2:FindFirstChild("RaceTransformed").Value ~= false then
													continue
												end

												callbackPlayerDataCallbackItem = GetConnectionEnemies(callbackEntriesEntry)

												if not callbackPlayerDataCallbackItem then
													exitTo6 = 3

													break
												end

												while true do
													wait()
													playerCollectionLatest.Kill(callbackPlayerDataCallbackItem, _G.AcientOne)

													if _G.AcientOne == false then
														break
													elseif callbackPlayerDataCallbackItem.Humanoid.Health <= 0 or not callbackPlayerDataCallbackItem.Parent then
														break
													end
												end
											end

											if exitTo6 == 1 then
												if callbackPlayerDataCallbackState <= callbackPlayerDataValue then
													continue
												end
											else
												if exitTo6 == 2 then
													exitTo = 1
												elseif exitTo6 == 3 then
													exitTo = 2
												end

												break
											end
										end

										break
									end
								end
							elseif exitTo2 == 2 then
								exitTo = 1
							elseif exitTo2 == 3 then
								exitTo = 2
							end
						until exitTo ~= 1

						if exitTo == 2 then
							_tp(CFrame.new(-9495.6806640625, 453.58624267578125, 5977.3486328125))

							continue
						end

						break
					end
				end
			end)
		end
	end)
end

do
	GRP_Race_Trials_Quest_V4:AddButton({
		Text = "Teleport to Temple of Time",
		Func = function()
			if plr.Character then
				if plr.Character:FindFirstChild("HumanoidRootPart") then
					local cFrame = CFrame.new(-7754.033203125, 2998.953857421875, -404.75357055664062)

					_tp(cFrame)
				end
			end
		end
	})
end

GRP_Race_Trials_Quest_V4:AddButton({
	Text = "Teleport to Ancient One",
	Func = function()
		if plr.Character then
			if plr.Character:FindFirstChild("HumanoidRootPart") then
				local cFrame = CFrame.new(-5071.541015625, 314.5412902832, -3151.1098632812)

				_tp(cFrame)
			end
		end
	end
})

do
	GRP_Race_Trials_Quest_V4:AddButton({
		Text = "Teleport to Ancient Clock",
		Func = function()
			if plr.Character then
				if plr.Character:FindFirstChild("HumanoidRootPart") then
					local cFrame = CFrame.new(-12471.169921875, 374.94024658203, -7551.677734375)

					_tp(cFrame)
				end
			end
		end
	})
end

do
	Doors = GRP_Race_Trials_Quest_V4:AddToggle("Auto_Teleport_to_Race_Doors", {
		Text = "Auto Teleport to Race Doors",
		Default = false,
		Callback = function(isAutoTeleportToRaceDoorsEnabled)
			_G.TPDoor = isAutoTeleportToRaceDoorsEnabled
		end
	})
end

do
	spawn(function()
		while wait(Sec) do
			pcall(function()
				if _G.TPDoor then
					if tostring(plr.Data.Race.Value) == "Mink" then
						_tp(CFrame.new(29020.66015625, 14889.4267578125, -379.26828002929688))
					elseif tostring(plr.Data.Race.Value) == "Fishman" then
						_tp(CFrame.new(28224.056640625, 14889.4267578125, -210.58720397949219))
					elseif tostring(plr.Data.Race.Value) == "Cyborg" then
						_tp(CFrame.new(28492.4140625, 14894.4267578125, -422.11001586914062))
					elseif tostring(plr.Data.Race.Value) == "Skypiea" then
						_tp(CFrame.new(28967.408203125, 14918.0751953125, 234.31198120117188))
					elseif tostring(plr.Data.Race.Value) == "Ghoul" then
						_tp(CFrame.new(28672.720703125, 14889.1279296875, 454.59616088867188))
					elseif tostring(plr.Data.Race.Value) == "Human" then
						_tp(CFrame.new(29237.294921875, 14889.4267578125, -206.94955444335938))
					end
				end
			end)
		end
	end)
end

Trials = GRP_Race_Trials_Quest_V4:AddToggle("Auto_Complete_Trial_Race", {
	Text = "Auto Complete Trial Race",
	Default = false,
	Callback = function(isAutoCompleteTrialRaceEnabled)
		_G.Complete_Trials = isAutoCompleteTrialRaceEnabled
	end
})
GetSeaBeastTrial = function()
	if not workspace.Map:FindFirstChild("FishmanTrial") then
		return nil
	end

	if workspace._WorldOrigin.Locations:FindFirstChild("Trial of Water") then
		FishmanTrial = workspace._WorldOrigin.Locations:FindFirstChild("Trial of Water")
	end

	if FishmanTrial then
		local next_ = next
		local children, childInstances = workspace.SeaBeasts:GetChildren()

		for _, playervalueaiPlayerData in next_, children, childInstances do
			if playervalueaiPlayerData:FindFirstChild("HumanoidRootPart") and (playervalueaiPlayerData.HumanoidRootPart.Position - FishmanTrial.Position).Magnitude <= 1500 and playervalueaiPlayerData.Health.Value > 0 then
				return playervalueaiPlayerData
			end
		end
	end
end
spawn(function()
	while wait(Sec) do
		pcall(function()
			if _G.Complete_Trials and tostring(plr.Data.Race.Value) == "Mink" then
				notween(workspace.Map.MinkTrial.Ceiling.CFrame * CFrame.new(0, -20, 0))
			end
		end)
	end
end)

do
	spawn(function()
		while wait(Sec) do
			pcall(function()
				if _G.Complete_Trials and tostring(plr.Data.Race.Value) == "Fishman" and GetSeaBeastTrial() then
					while true do
						task.wait()
						spawn(function()
							_tp(CFrame.new(GetSeaBeastTrial().HumanoidRootPart.Position.X, game:GetService("Workspace").Map["WaterBase-Plane"].Position.Y + 300, GetSeaBeastTrial().HumanoidRootPart.Position.Z))
						end)
						MousePos = GetSeaBeastTrial().HumanoidRootPart.Position
						Useskills("Melee", "Z")
						Useskills("Melee", "X")
						Useskills("Melee", "C")
						wait(0.1)
						Useskills("Sword", "Z")
						Useskills("Sword", "X")
						wait(0.1)
						Useskills("Blox Fruit", "Z")
						Useskills("Blox Fruit", "X")
						Useskills("Blox Fruit", "C")
						wait(0.1)
						Useskills("Gun", "Z")
						Useskills("Gun", "X")

						if _G.Complete_Trials == false then
							break
						elseif not GetSeaBeastTrial() then
							break
						end
					end
				end
			end)
		end
	end)
end

spawn(function()
	while wait(Sec) do
		pcall(function()
			if _G.Complete_Trials and tostring(plr.Data.Race.Value) == "Cyborg" then
				_tp(workspace.Map.CyborgTrial.Floor.CFrame * CFrame.new(0, 500, 0))
			end
		end)
	end
end)

do
	spawn(function()
		while wait(Sec) do
			pcall(function()
				if _G.Complete_Trials and tostring(plr.Data.Race.Value) == "Skypiea" then
					notween(workspace.Map.SkyTrial.Model.FinishPart.CFrame)
				end
			end)
		end
	end)
end

spawn(function()
	while wait(0.1) do
		pcall(function()
			if _G.Complete_Trials and (tostring(plr.Data.Race.Value) == "Human" or tostring(plr.Data.Race.Value) == "Ghoul") then
				local getseabeasttrialMovementData = GetConnectionEnemies({
					"Ancient Vampire",
					"Ancient Zombie"
				})

				if getseabeasttrialMovementData then
					while true do
						wait()
						playerCollectionLatest.Kill(getseabeasttrialMovementData, _G.Complete_Trials)

						if _G.Complete_Trials == false then
							break
						elseif not getseabeasttrialMovementData.Parent or getseabeasttrialMovementData.Humanoid.Health <= 0 then
							break
						end
					end
				end
			end
		end)
	end
end)

do
	AutoKill = GRP_Race_Trials_Quest_V4:AddToggle("Auto_Kill_Player_After_Trial", {
		Text = "Auto Kill Player After Trial",
		Default = false,
		Callback = function(isAutoKillPlayerAfterTrialEnabled)
			_G.Defeating = isAutoKillPlayerAfterTrialEnabled
		end
	})
end

do
	spawn(function()
		while task.wait(Sec) do
			pcall(function()
				if _G.Defeating then
					for _, child in pairs(workspace.Characters:GetChildren()) do
						if child.Name ~= plr.Name and child.Humanoid.Health > 0 and child:FindFirstChild("HumanoidRootPart") and child.Parent and (Root.Position - child.HumanoidRootPart.Position).Magnitude <= 250 then
							while true do
								task.wait()
								EquipWeapon(_G.SelectWeapon)
								_tp(child.HumanoidRootPart.CFrame * CFrame.new(0, 0, 15))
								sethiddenproperty(plr, "SimulationRadius", math.huge)

								if _G.Defeating == false then
									break
								elseif child.Humanoid.Health <= 0 or not child.Parent or not child:FindFirstChild("HumanoidRootPart") or not child:FindFirstChild("Humanoid") then
									break
								end
							end
						end
					end
				end
			end)
		end
	end)
end

GRP_Prehistoric_Dojo_Quest = tabs.Prehistoric:AddLeftGroupbox("Dojo Quest")

do
	GRP_Prehistoric_Dojo_Quest:AddButton({
		Text = "Dojo Quest",
		Func = function()
			replicated.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(5661.5322265625, 1013.0907592773438, -334.96499633789062))
			_tp(CFrame.new(5814.42724609375, 1208.3267822265625, 884.57855224609375))
		end
	})
end

do
	DojoQ = GRP_Prehistoric_Dojo_Quest:AddToggle("Auto_Dojo_Trainer", {
		Text = "Auto Dojo Trainer",
		Default = false,
		Callback = function()
		end
	})
end

do
	printBeltName = function(isAutoDojoTrainerEnabled)
		if type(isAutoDojoTrainerEnabled) == "table" and isAutoDojoTrainerEnabled.Quest.BeltName then
			return isAutoDojoTrainerEnabled.Quest.BeltName
		end
	end
end

spawn(function()
	while wait(Sec) do
		if _G.Dojoo then
			pcall(function()
				local response = replicated.Modules.Net:FindFirstChild("RF/InteractDragonQuest"):InvokeServer(unpack({ {
					NPC = "Dojo Trainer",
					Command = "RequestQuest"
				} }))
				local printbeltnameQuestData = printBeltName(response)

				if debug == false and not (response or printbeltnameQuestData) then
					_tp(CFrame.new(5865.0234375, 1208.3154296875, 871.15185546875))
					debug = true
				elseif debug == true and (CFrame.new(5865.0234375, 1208.3154296875, 871.15185546875).Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 50 then
					if printbeltnameQuestData == "White" then
						local printbeltnameQuestDataState = GetConnectionEnemies("Skull Slayer")

						if printbeltnameQuestDataState then
							while true do
								task.wait()
								playerCollectionLatest.Kill(printbeltnameQuestDataState, _G.Dojoo)

								if response then
									if not _G.Dojoo or not playerCollectionLatest.Alive(printbeltnameQuestDataState) then
										break
									end
								else
									break
								end
							end
						else
							_tp(CFrame.new(-16759.58984375, 71.283767700195312, 1595.3399658203125))
						end
					elseif printbeltnameQuestData == "Yellow" then
						while true do
							task.wait()
							_G.SeaBeast1 = true
							_G.TerrorShark = true
							_G.Shark = true
							_G.Piranha = true
							_G.MobCrew = true
							_G.FishBoat = true
							_G.SailBoats = true

							if _G.Dojoo then
								if not response then
									break
								end
							else
								break
							end
						end

						_G.SeaBeast1 = false
						_G.TerrorShark = false
						_G.Shark = false
						_G.Piranha = false
						_G.MobCrew = false
						_G.FishBoat = false
						_G.SailBoats = false
					elseif printbeltnameQuestData == "Green" then
						while true do
							task.wait()
							_G.SailBoats = true

							if _G.Dojoo then
								if not response then
									break
								end
							else
								break
							end
						end

						_G.SailBoats = false
					elseif printbeltnameQuestData == "Purple" then
						while true do
							task.wait()
							_G.FarmEliteHunt = true

							if _G.Dojoo then
								if not response then
									break
								end
							else
								break
							end
						end

						_G.FarmEliteHunt = false
					elseif printbeltnameQuestData == "Red" then
						while true do
							task.wait()
							_G.SailBoats = true
							_G.FishBoat = true

							if _G.Dojoo then
								if not response then
									break
								end
							else
								break
							end
						end

						_G.SailBoats = false
						_G.FishBoat = false
					elseif printbeltnameQuestData == "Black" then
						repeat
							task.wait()

							local ActivationPrompt

							if workspace.Map:FindFirstChild("PrehistoricIsland") then
								_G.Prehis_Find = true
								ActivationPrompt = workspace.Map.PrehistoricIsland.Core.ActivationPrompt

								if ActivationPrompt:FindFirstChild("ProximityPrompt", true) then
									_G.Prehis_Skills = false
									_G.Prehis_Find = true
								else
									_G.Prehis_Skills = true
									_G.Prehis_Find = false
								end
							elseif workspace._WorldOrigin.Locations:FindFirstChild("Prehistoric Island") then
								_G.Prehis_Find = true
								ActivationPrompt = workspace.Map.PrehistoricIsland.Core.ActivationPrompt

								if ActivationPrompt:FindFirstChild("ProximityPrompt", true) then
									_G.Prehis_Skills = false
									_G.Prehis_Find = true
								else
									_G.Prehis_Skills = true
									_G.Prehis_Find = false
								end

								if not _G.Dojoo or not response then
									break
								end
							else
								_G.Prehis_Find = true
								_G.Prehis_Skills = false
							end
						until not _G.Dojoo or not response

						_G.Prehis_Find = false
						_G.Prehis_Skills = false
					elseif printbeltnameQuestData == "Orange" or printbeltnameQuestData == "Blue" then
						return nil
					end
				end

				if not response then
					debug = false
					replicated.Modules.Net:FindFirstChild("RF/InteractDragonQuest"):InvokeServer(unpack({ {
						NPC = "Dojo Trainer",
						Command = "ClaimQuest"
					} }))
				end
			end)
		end
	end
end)

do
	BlazeEM = GRP_Prehistoric_Dojo_Quest:AddToggle("Auto_Dragon_Hunter", {
		Text = "Auto Dragon Hunter",
		Default = false,
		Callback = function(isAutoDragonHunterEnabled)
			_G.FarmBlazeEM = isAutoDragonHunterEnabled
		end
	})
end

do
	checkQuesta = function()
		local questDataTarget = { {
			Context = "Check"
		} }
		local response

		pcall(function()
			game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/DragonHunter"):InvokeServer(unpack({ {
				Context = "RequestQuest"
			} }))
		end)

		local _ = pcall(function()
			response = game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/DragonHunter"):InvokeServer(unpack(questDataTarget))
		end)
		local isCheckquestaReady = false
		local checkquestaQuestDataState
		local checkquestaQuestData
		local n7

		if response and response.Text then
			isCheckquestaReady = true

			local Text = response.Text

			if string.find(tostring(Text), "Defeat") then
				n7 = 1

				local textValue = string.sub(tostring(Text), 8, 9)

				checkquestaQuestDataState = tonumber(textValue)

				for _, playervalueaiPlayerData in pairs({
					"Hydra Enforcer",
					"Venomous Assailant"
				}) do
					if string.find(Text, playervalueaiPlayerData) then
						checkquestaQuestData = playervalueaiPlayerData

						break
					end
				end
			elseif string.find(tostring(Text), "Destroy") then
				checkquestaQuestDataState = 10
				n7 = 2
				checkquestaQuestData = nil
			end
		end

		return isCheckquestaReady, checkquestaQuestData, checkquestaQuestDataState, n7
	end
end

BackTODoJo = function()
	for _, child in pairs(game:GetService("Players").LocalPlayer.PlayerGui.Notifications:GetChildren()) do
		if child.Name == "NotificationTemplate" and string.find(child.Text, "Head back to the Dojo to complete more tasks") then
			return true
		end
	end

	return false
end
DragonMobClear = function(targetEnemyData, targetEnemyCandidate, targetEnemyReference)
	if workspace.Enemies:FindFirstChild(targetEnemyCandidate) then
		for _, child in pairs(workspace.Enemies:GetChildren()) do
			if child.Name == targetEnemyCandidate and playerCollectionLatest.Alive(child) and targetEnemyData then
				playerCollectionLatest.Kill(child, targetEnemyData)
			end
		end
	else
		_tp(targetEnemyReference)
	end
end

do
	spawn(function()
		while wait() do
			if _G.FarmBlazeEM then
				pcall(function()
					local dragonmobclearQuestDataData, dragonmobclearQuestDataState, _, dragonmobclearQuestData = checkQuesta()

					if dragonmobclearQuestDataData ~= true or BackTODoJo() then
						_tp(CFrame.new(5813, 1208, 884))
						DragonMobClear(false, nil, nil)
					elseif dragonmobclearQuestData == 1 then
						if dragonmobclearQuestDataState == "Hydra Enforcer" or dragonmobclearQuestDataState == "Venomous Assailant" then
							while true do
								wait()
								DragonMobClear(true, dragonmobclearQuestDataState, CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))

								if _G.FarmBlazeEM then
									if BackTODoJo() then
										break
									end
								else
									break
								end
							end
						end
					elseif dragonmobclearQuestData == 2 then
						if workspace.Map.Waterfall.IslandModel:FindFirstChild("Meshes/bambootree", true) then
							repeat
								wait()
								spawn(function()
									_tp(workspace.Map.Waterfall.IslandModel:FindFirstChild("Meshes/bambootree", true).CFrame * CFrame.new(4, 0, 0))
								end)

								if (workspace.Map.Waterfall.IslandModel:FindFirstChild("Meshes/bambootree", true).Position - Root.Position).Magnitude <= 200 then
									MousePos = workspace.Map.Waterfall.IslandModel:FindFirstChild("Meshes/bambootree", true).Position
									Useskills("Melee", "Z")
									Useskills("Melee", "X")
									Useskills("Melee", "C")
									wait(0.5)
									Useskills("Sword", "Z")
									Useskills("Sword", "X")
									wait(0.5)
									Useskills("Blox Fruit", "Z")
									Useskills("Blox Fruit", "X")
									Useskills("Blox Fruit", "C")
									wait(0.5)
									Useskills("Gun", "Z")
									Useskills("Gun", "X")
								end
							until not _G.FarmBlazeEM or BackTODoJo()
						end
					end
				end)
			end
		end
	end)
end

spawn(function()
	while wait(0.1) do
		if _G.FarmBlazeEM then
			pcall(function()
				if workspace.EmberTemplate:FindFirstChild("Part") then
					game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.EmberTemplate.Part.CFrame
				end
			end)
		end
	end
end)
GRP_Prehistoric_Drago_Trial = tabs.Prehistoric:AddLeftGroupbox("Drago Trial")

do
	GetQuestDracoLevel = function()
		return replicated.Modules.Net:FindFirstChild("RF/InteractDragonQuest"):InvokeServer(unpack({ {
			NPC = "Dragon Wizard",
			Command = "Upgrade"
		} }))
	end
end

Toggle = GRP_Prehistoric_Drago_Trial:AddToggle("Tween_To_Upgrade_Droco_Trial", {
	Text = "Tween To Upgrade Droco Trial",
	Default = false,
	Callback = function(isTweenToUpgradeDrocoTrialEnabled)
		_G.UPGDrago = isTweenToUpgradeDrocoTrialEnabled
	end
})

do
	spawn(function()
		while wait(Sec) do
			pcall(function()
				if _G.UPGDrago then
					if GetQuestDracoLevel() == false then
						return nil
					end

					if GetQuestDracoLevel() == true then
						if (CFrame.new(5814.42724609375, 1208.3267822265625, 884.57855224609375).Position - Root.Position).Magnitude >= 300 then
							_tp(CFrame.new(5814.42724609375, 1208.3267822265625, 884.57855224609375))
						else
							_tp(CFrame.new(5814.42724609375, 1208.3267822265625, 884.57855224609375))
							replicated.Modules.Net:FindFirstChild("RF/InteractDragonQuest"):InvokeServer(unpack({ {
								NPC = "Dragon Wizard",
								Command = "Upgrade"
							} }))
						end
					end
				end
			end)
		end
	end)
end

do
	Toggle = GRP_Prehistoric_Drago_Trial:AddToggle("Auto_Drago_(V1)", {
		Text = "Auto Drago (V1)",
		Default = false,
		Callback = function(isAutoDragoVEnabled)
			_G.DragoV1 = isAutoDragoVEnabled
		end
	})
end

do
	spawn(function()
		while wait(Sec) do
			pcall(function()
				if _G.DragoV1 and GetM("Dragon Egg") <= 0 then
					while true do
						wait()
						_G.Prehis_Find = true
						_G.Prehis_Skills = true
						_G.Prehis_DE = true

						if _G.DragoV1 then
							if GetM("Dragon Egg") >= 1 then
								break
							end
						else
							break
						end
					end

					_G.Prehis_Find = false
					_G.Prehis_Skills = false
					_G.Prehis_DE = false
				end
			end)
		end
	end)
end

do
	fireflower = GRP_Prehistoric_Drago_Trial:AddToggle("Auto_Drago_(V2)", {
		Text = "Auto Drago (V2)",
		Default = false,
		Callback = function(isAutoDragoVEnabledCurrent)
			_G.AutoFireFlowers = isAutoDragoVEnabledCurrent
		end
	})
end

do
	spawn(function()
		while wait(Sec) do
			if _G.AutoFireFlowers then
				local FireFlowers = workspace:FindFirstChild("FireFlowers")
				local resultassignedResult = GetConnectionEnemies("Forest Pirate")

				if resultassignedResult then
					while true do
						wait()
						playerCollectionLatest.Kill(resultassignedResult, _G.AutoFireFlowers)

						if _G.AutoFireFlowers then
							if not resultassignedResult.Parent or resultassignedResult.Humanoid.Health <= 0 or FireFlowers then
								break
							end
						else
							break
						end
					end
				else
					_tp(CFrame.new(-13206.452148438, 425.89199829102, -7964.5537109375))
				end

				if FireFlowers then
					for _, child in pairs(FireFlowers:GetChildren()) do
						if child:IsA("Model") and child.PrimaryPart then
							local Position = child.PrimaryPart.Position

							if (Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 100 then
								vim1:SendKeyEvent(true, "E", true, game)
								wait(1.5)
								vim1:SendKeyEvent(false, "E", true, game)
							else
								_tp(CFrame.new(Position))
							end
						end
					end
				end
			end
		end
	end)
end

Toggle = GRP_Prehistoric_Drago_Trial:AddToggle("Auto_Drago_(V3)", {
	Text = "Auto Drago (V3)",
	Default = false,
	Callback = function(isAutoDragoVEnabledCached)
		_G.DragoV3 = isAutoDragoVEnabledCached
	end
})

do
	spawn(function()
		while wait(Sec) do
			pcall(function()
				if _G.DragoV3 then
					repeat
						wait()
						_G.DangerSc = "Lv Infinite"
						_G.SailBoats = true
						_G.TerrorShark = true
					until not _G.DragoV3

					_G.DangerSc = "Lv 1"
					_G.SailBoats = false
					_G.TerrorShark = false
				end
			end)
		end
	end)
end

do
	Toggle = GRP_Prehistoric_Drago_Trial:AddToggle("Auto_Relic_Drago_Trial_[Beta]", {
		Text = "Auto Relic Drago Trial [Beta]",
		Default = false,
		Callback = function(isAutoRelicDragoTrialBetaEnabled)
			_G.Relic123 = isAutoRelicDragoTrialBetaEnabled
		end
	})
end

do
	spawn(function()
		while wait(Sec) do
			if _G.Relic123 then
				pcall(function()
					if workspace.Map:FindFirstChild("DracoTrial") then
						replicated.Remotes.DracoTrial:InvokeServer()
						wait(0.5)

						while true do
							wait()
							_tp(CFrame.new(-39934.9765625, 10685.359375, 22999.34375))

							if _G.Relic123 then
								if Root.Position == CFrame.new(-39934.9765625, 10685.359375, 22999.34375).Position then
									break
								end
							else
								break
							end
						end

						while true do
							wait()
							_tp(CFrame.new(-40511.25390625, 9376.4013671875, 23458.37890625))

							if _G.Relic123 then
								if Root.Position == CFrame.new(-40511.25390625, 9376.4013671875, 23458.37890625).Position then
									break
								end
							else
								break
							end
						end

						wait(2.5)

						while true do
							wait()
							_tp(CFrame.new(-39914.65625, 10685.384765625, 23000.177734375))

							if _G.Relic123 then
								if Root.Position == CFrame.new(-39914.65625, 10685.384765625, 23000.177734375).Position then
									break
								end
							else
								break
							end
						end

						while true do
							wait()
							_tp(CFrame.new(-40045.83203125, 9376.3984375, 22791.287109375))

							if _G.Relic123 then
								if Root.Position == CFrame.new(-40045.83203125, 9376.3984375, 22791.287109375).Position then
									break
								end
							else
								break
							end
						end

						wait(2.5)

						while true do
							wait()
							_tp(CFrame.new(-39908.5, 10685.4052734375, 22990.04296875))

							if _G.Relic123 then
								if Root.Position == CFrame.new(-39908.5, 10685.4052734375, 22990.04296875).Position then
									break
								end
							else
								break
							end
						end

						while true do
							wait()
							_tp(CFrame.new(-39609.5, 9376.400390625, 23472.94335975))

							if _G.Relic123 then
								if Root.Position == CFrame.new(-39609.5, 9376.400390625, 23472.94335975).Position then
									break
								end
							else
								break
							end
						end
					else
						local TrialTeleport = workspace.Map.PrehistoricIsland:FindFirstChild("TrialTeleport")

						if TrialTeleport then
							if TrialTeleport:IsA("Part") then
								_tp(CFrame.new(TrialTeleport.Position))
							end
						end
					end
				end)
			end
		end
	end)
end

Toggle = GRP_Prehistoric_Drago_Trial:AddToggle("Auto_Train_Drago_v4", {
	Text = "Auto Train Drago callbackMovementData",
	Default = false,
	Callback = function(isAutoTrainDragoValueEnabled)
		_G.TrainDrago = isAutoTrainDragoValueEnabled
	end
})

do
	spawn(function()
		while wait(Sec) do
			pcall(function()
				if _G.TrainDrago then
					local callbackEntriesItem = {
						"Venomous Assailant",
						"Hydra Enforcer"
					}
					local callbackPlayerDataCallbackEntry = #callbackEntriesItem
					local n8 = 1
					local callbackPlayerDataCallbackPayload = callbackPlayerDataCallbackEntry + 0
					local callbackPlayerDataData = 1 - n8
					local exitTo

					for i = 1, callbackPlayerDataCallbackEntry do
						if plr.Character:FindFirstChild("RaceEnergy").Value == 1 then
							exitTo = 1

							break
						end

						if plr.Character:FindFirstChild("RaceTransformed").Value == false then
							local callbackPlayerDataCallbackRecord = GetConnectionEnemies(callbackEntriesItem)

							if not callbackPlayerDataCallbackRecord then
								exitTo = 2

								break
							end

							while true do
								wait()
								playerCollectionLatest.Kill(callbackPlayerDataCallbackRecord, _G.TrainDrago)

								if _G.TrainDrago == false then
									break
								elseif callbackPlayerDataCallbackRecord.Humanoid.Health <= 0 or not callbackPlayerDataCallbackRecord.Parent then
									break
								end
							end
						end
					end

					local exitTo2, exitTo5, Character, Character2, callbackPlayerDataCallbackReference, exitTo6, exitTo7, exitTo8, exitTo9, exitTo10, exitTo19

					if exitTo == 1 then
						vim1:SendKeyEvent(true, "Y", true, game)
						replicated.Remotes.CommF_:InvokeServer("UpgradeRace", "Buy", 2)
						vim1:SendKeyEvent(false, "Y", true, game)
						_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
						exitTo2 = nil
						exitTo5 = nil

						while true do
							callbackPlayerDataData += n8

							if not (n8 <= 0) then
								exitTo5 = 1

								break
							end

							if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
								break
							end

							Character = plr.Character

							if Character:FindFirstChild("RaceEnergy").Value == 1 then
								exitTo5 = 2

								break
							end

							Character2 = plr.Character

							if Character2:FindFirstChild("RaceTransformed").Value == false then
								callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

								if callbackPlayerDataCallbackReference then
									while true do
										wait()
										playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

										if _G.TrainDrago == false then
											break
										elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
											break
										end
									end
								else
									_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
								end
							end
						end

						if exitTo5 == 1 then
							if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
								local exitTo18

								while true do
									Character = plr.Character

									if Character:FindFirstChild("RaceEnergy").Value == 1 then
										exitTo18 = 1

										break
									end

									Character2 = plr.Character

									if Character2:FindFirstChild("RaceTransformed").Value == false then
										callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

										if callbackPlayerDataCallbackReference then
											exitTo6 = nil

											while true do
												wait()
												playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

												if _G.TrainDrago == false then
													break
												elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
													exitTo6 = 1

													break
												end
											end

											if exitTo6 == 1 then
												exitTo7 = nil

												while true do
													callbackPlayerDataData += n8

													if not (n8 <= 0) then
														exitTo7 = 1

														break
													end

													if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
														break
													end

													Character = plr.Character

													if Character:FindFirstChild("RaceEnergy").Value == 1 then
														exitTo7 = 2

														break
													end

													Character2 = plr.Character

													if Character2:FindFirstChild("RaceTransformed").Value == false then
														callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

														if callbackPlayerDataCallbackReference then
															while true do
																wait()
																playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																if _G.TrainDrago == false then
																	break
																elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																	break
																end
															end
														else
															_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
														end
													end
												end

												if exitTo7 == 1 then
													if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
														continue
													end

													exitTo18 = 8

													break
												end

												exitTo18 = 7

												break
											end

											exitTo8 = nil

											while true do
												callbackPlayerDataData += n8

												if not (n8 <= 0) then
													exitTo8 = 1

													break
												end

												if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
													break
												end

												Character = plr.Character

												if Character:FindFirstChild("RaceEnergy").Value == 1 then
													exitTo8 = 2

													break
												end

												Character2 = plr.Character

												if Character2:FindFirstChild("RaceTransformed").Value == false then
													callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

													if callbackPlayerDataCallbackReference then
														while true do
															wait()
															playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

															if _G.TrainDrago == false then
																break
															elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																break
															end
														end
													else
														_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
													end
												end
											end

											if exitTo8 == 1 then
												if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
													continue
												end

												exitTo18 = 6

												break
											end

											exitTo18 = 5

											break
										end

										_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
										exitTo9 = nil

										while true do
											callbackPlayerDataData += n8

											if not (n8 <= 0) then
												exitTo9 = 1

												break
											end

											if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
												break
											end

											Character = plr.Character

											if Character:FindFirstChild("RaceEnergy").Value == 1 then
												exitTo9 = 2

												break
											end

											Character2 = plr.Character

											if Character2:FindFirstChild("RaceTransformed").Value == false then
												callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

												if callbackPlayerDataCallbackReference then
													while true do
														wait()
														playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

														if _G.TrainDrago == false then
															break
														elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
															break
														end
													end
												else
													_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
												end
											end
										end

										if exitTo9 == 1 then
											if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
												continue
											end

											exitTo18 = 4

											break
										end

										exitTo18 = 3

										break
									end

									exitTo10 = nil

									while true do
										callbackPlayerDataData += n8

										if not (n8 <= 0) then
											exitTo10 = 1

											break
										end

										if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
											break
										end

										Character = plr.Character

										if Character:FindFirstChild("RaceEnergy").Value == 1 then
											exitTo10 = 2

											break
										end

										Character2 = plr.Character

										if Character2:FindFirstChild("RaceTransformed").Value == false then
											callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

											if callbackPlayerDataCallbackReference then
												while true do
													wait()
													playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

													if _G.TrainDrago == false then
														break
													elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
														break
													end
												end
											else
												_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
											end
										end
									end

									if exitTo10 == 1 then
										if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
											continue
										end

										exitTo18 = 2

										break
									end

									break
								end

								if exitTo18 == 1 then
									exitTo2 = 1

									if exitTo2 == 1 then
										while true do
											vim1:SendKeyEvent(true, "Y", true, game)
											replicated.Remotes.CommF_:InvokeServer("UpgradeRace", "Buy", 2)
											vim1:SendKeyEvent(false, "Y", true, game)
											_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
											exitTo2 = nil
											exitTo5 = nil

											while true do
												callbackPlayerDataData += n8

												if not (n8 <= 0) then
													exitTo5 = 1

													break
												end

												if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
													break
												end

												Character = plr.Character

												if Character:FindFirstChild("RaceEnergy").Value == 1 then
													exitTo5 = 2

													break
												end

												Character2 = plr.Character

												if Character2:FindFirstChild("RaceTransformed").Value == false then
													callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

													if callbackPlayerDataCallbackReference then
														while true do
															wait()
															playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

															if _G.TrainDrago == false then
																break
															elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																break
															end
														end
													else
														_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
													end
												end
											end

											if exitTo5 == 1 then
												if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
													exitTo19 = nil

													while true do
														Character = plr.Character

														if Character:FindFirstChild("RaceEnergy").Value == 1 then
															exitTo19 = 1

															break
														end

														Character2 = plr.Character

														if Character2:FindFirstChild("RaceTransformed").Value == false then
															callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

															if callbackPlayerDataCallbackReference then
																exitTo6 = nil

																while true do
																	wait()
																	playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																	if _G.TrainDrago == false then
																		break
																	elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																		exitTo6 = 1

																		break
																	end
																end

																if exitTo6 == 1 then
																	exitTo7 = nil

																	while true do
																		callbackPlayerDataData += n8

																		if not (n8 <= 0) then
																			exitTo7 = 1

																			break
																		end

																		if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																			break
																		end

																		Character = plr.Character

																		if Character:FindFirstChild("RaceEnergy").Value == 1 then
																			exitTo7 = 2

																			break
																		end

																		Character2 = plr.Character

																		if Character2:FindFirstChild("RaceTransformed").Value == false then
																			callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																			if callbackPlayerDataCallbackReference then
																				while true do
																					wait()
																					playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																					if _G.TrainDrago == false then
																						break
																					elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																						break
																					end
																				end
																			else
																				_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																			end
																		end
																	end

																	if exitTo7 == 1 then
																		if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																			continue
																		end

																		exitTo19 = 8

																		break
																	end

																	exitTo19 = 7

																	break
																end

																exitTo8 = nil

																while true do
																	callbackPlayerDataData += n8

																	if not (n8 <= 0) then
																		exitTo8 = 1

																		break
																	end

																	if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																		break
																	end

																	Character = plr.Character

																	if Character:FindFirstChild("RaceEnergy").Value == 1 then
																		exitTo8 = 2

																		break
																	end

																	Character2 = plr.Character

																	if Character2:FindFirstChild("RaceTransformed").Value == false then
																		callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																		if callbackPlayerDataCallbackReference then
																			while true do
																				wait()
																				playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																				if _G.TrainDrago == false then
																					break
																				elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																					break
																				end
																			end
																		else
																			_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																		end
																	end
																end

																if exitTo8 == 1 then
																	if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																		continue
																	end

																	exitTo19 = 6

																	break
																end

																exitTo19 = 5

																break
															end

															_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
															exitTo9 = nil

															while true do
																callbackPlayerDataData += n8

																if not (n8 <= 0) then
																	exitTo9 = 1

																	break
																end

																if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																	break
																end

																Character = plr.Character

																if Character:FindFirstChild("RaceEnergy").Value == 1 then
																	exitTo9 = 2

																	break
																end

																Character2 = plr.Character

																if Character2:FindFirstChild("RaceTransformed").Value == false then
																	callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																	if callbackPlayerDataCallbackReference then
																		while true do
																			wait()
																			playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																			if _G.TrainDrago == false then
																				break
																			elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																				break
																			end
																		end
																	else
																		_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																	end
																end
															end

															if exitTo9 == 1 then
																if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																	continue
																end

																exitTo19 = 4

																break
															end

															exitTo19 = 3

															break
														end

														exitTo10 = nil

														while true do
															callbackPlayerDataData += n8

															if not (n8 <= 0) then
																exitTo10 = 1

																break
															end

															if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																break
															end

															Character = plr.Character

															if Character:FindFirstChild("RaceEnergy").Value == 1 then
																exitTo10 = 2

																break
															end

															Character2 = plr.Character

															if Character2:FindFirstChild("RaceTransformed").Value == false then
																callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																if callbackPlayerDataCallbackReference then
																	while true do
																		wait()
																		playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																		if _G.TrainDrago == false then
																			break
																		elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																			break
																		end
																	end
																else
																	_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																end
															end
														end

														if exitTo10 == 1 then
															if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																continue
															end

															exitTo19 = 2

															break
														end

														break
													end

													if exitTo19 == 1 then
														exitTo2 = 1

														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 2 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 3 then
														if exitTo9 == 2 then
															exitTo2 = 1

															if exitTo2 == 1 then
																continue
															end
														elseif exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 4 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 5 then
														if exitTo8 == 2 then
															exitTo2 = 1

															if exitTo2 == 1 then
																continue
															end
														elseif exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 6 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 7 then
														if exitTo7 == 2 then
															exitTo2 = 1

															if exitTo2 == 1 then
																continue
															end
														elseif exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 8 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo10 == 2 then
														exitTo2 = 1

														if exitTo2 == 1 then
															continue
														end
													elseif exitTo2 == 1 then
														continue
													end
												elseif exitTo2 == 1 then
													continue
												end
											elseif exitTo5 == 2 then
												exitTo2 = 1

												if exitTo2 == 1 then
													continue
												end
											elseif exitTo2 == 1 then
												continue
											end

											break
										end
									end
								elseif exitTo18 == 2 then
									if exitTo2 == 1 then
										while true do
											vim1:SendKeyEvent(true, "Y", true, game)
											replicated.Remotes.CommF_:InvokeServer("UpgradeRace", "Buy", 2)
											vim1:SendKeyEvent(false, "Y", true, game)
											_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
											exitTo2 = nil
											exitTo5 = nil

											while true do
												callbackPlayerDataData += n8

												if not (n8 <= 0) then
													exitTo5 = 1

													break
												end

												if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
													break
												end

												Character = plr.Character

												if Character:FindFirstChild("RaceEnergy").Value == 1 then
													exitTo5 = 2

													break
												end

												Character2 = plr.Character

												if Character2:FindFirstChild("RaceTransformed").Value == false then
													callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

													if callbackPlayerDataCallbackReference then
														while true do
															wait()
															playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

															if _G.TrainDrago == false then
																break
															elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																break
															end
														end
													else
														_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
													end
												end
											end

											if exitTo5 == 1 then
												if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
													exitTo19 = nil

													while true do
														Character = plr.Character

														if Character:FindFirstChild("RaceEnergy").Value == 1 then
															exitTo19 = 1

															break
														end

														Character2 = plr.Character

														if Character2:FindFirstChild("RaceTransformed").Value == false then
															callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

															if callbackPlayerDataCallbackReference then
																exitTo6 = nil

																while true do
																	wait()
																	playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																	if _G.TrainDrago == false then
																		break
																	elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																		exitTo6 = 1

																		break
																	end
																end

																if exitTo6 == 1 then
																	exitTo7 = nil

																	while true do
																		callbackPlayerDataData += n8

																		if not (n8 <= 0) then
																			exitTo7 = 1

																			break
																		end

																		if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																			break
																		end

																		Character = plr.Character

																		if Character:FindFirstChild("RaceEnergy").Value == 1 then
																			exitTo7 = 2

																			break
																		end

																		Character2 = plr.Character

																		if Character2:FindFirstChild("RaceTransformed").Value == false then
																			callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																			if callbackPlayerDataCallbackReference then
																				while true do
																					wait()
																					playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																					if _G.TrainDrago == false then
																						break
																					elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																						break
																					end
																				end
																			else
																				_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																			end
																		end
																	end

																	if exitTo7 == 1 then
																		if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																			continue
																		end

																		exitTo19 = 8

																		break
																	end

																	exitTo19 = 7

																	break
																end

																exitTo8 = nil

																while true do
																	callbackPlayerDataData += n8

																	if not (n8 <= 0) then
																		exitTo8 = 1

																		break
																	end

																	if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																		break
																	end

																	Character = plr.Character

																	if Character:FindFirstChild("RaceEnergy").Value == 1 then
																		exitTo8 = 2

																		break
																	end

																	Character2 = plr.Character

																	if Character2:FindFirstChild("RaceTransformed").Value == false then
																		callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																		if callbackPlayerDataCallbackReference then
																			while true do
																				wait()
																				playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																				if _G.TrainDrago == false then
																					break
																				elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																					break
																				end
																			end
																		else
																			_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																		end
																	end
																end

																if exitTo8 == 1 then
																	if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																		continue
																	end

																	exitTo19 = 6

																	break
																end

																exitTo19 = 5

																break
															end

															_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
															exitTo9 = nil

															while true do
																callbackPlayerDataData += n8

																if not (n8 <= 0) then
																	exitTo9 = 1

																	break
																end

																if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																	break
																end

																Character = plr.Character

																if Character:FindFirstChild("RaceEnergy").Value == 1 then
																	exitTo9 = 2

																	break
																end

																Character2 = plr.Character

																if Character2:FindFirstChild("RaceTransformed").Value == false then
																	callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																	if callbackPlayerDataCallbackReference then
																		while true do
																			wait()
																			playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																			if _G.TrainDrago == false then
																				break
																			elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																				break
																			end
																		end
																	else
																		_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																	end
																end
															end

															if exitTo9 == 1 then
																if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																	continue
																end

																exitTo19 = 4

																break
															end

															exitTo19 = 3

															break
														end

														exitTo10 = nil

														while true do
															callbackPlayerDataData += n8

															if not (n8 <= 0) then
																exitTo10 = 1

																break
															end

															if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																break
															end

															Character = plr.Character

															if Character:FindFirstChild("RaceEnergy").Value == 1 then
																exitTo10 = 2

																break
															end

															Character2 = plr.Character

															if Character2:FindFirstChild("RaceTransformed").Value == false then
																callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																if callbackPlayerDataCallbackReference then
																	while true do
																		wait()
																		playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																		if _G.TrainDrago == false then
																			break
																		elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																			break
																		end
																	end
																else
																	_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																end
															end
														end

														if exitTo10 == 1 then
															if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																continue
															end

															exitTo19 = 2

															break
														end

														break
													end

													if exitTo19 == 1 then
														exitTo2 = 1

														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 2 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 3 then
														if exitTo9 == 2 then
															exitTo2 = 1

															if exitTo2 == 1 then
																continue
															end
														elseif exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 4 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 5 then
														if exitTo8 == 2 then
															exitTo2 = 1

															if exitTo2 == 1 then
																continue
															end
														elseif exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 6 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 7 then
														if exitTo7 == 2 then
															exitTo2 = 1

															if exitTo2 == 1 then
																continue
															end
														elseif exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 8 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo10 == 2 then
														exitTo2 = 1

														if exitTo2 == 1 then
															continue
														end
													elseif exitTo2 == 1 then
														continue
													end
												elseif exitTo2 == 1 then
													continue
												end
											elseif exitTo5 == 2 then
												exitTo2 = 1

												if exitTo2 == 1 then
													continue
												end
											elseif exitTo2 == 1 then
												continue
											end

											break
										end
									end
								elseif exitTo18 == 3 then
									if exitTo9 == 2 then
										exitTo2 = 1

										if exitTo2 == 1 then
											while true do
												vim1:SendKeyEvent(true, "Y", true, game)
												replicated.Remotes.CommF_:InvokeServer("UpgradeRace", "Buy", 2)
												vim1:SendKeyEvent(false, "Y", true, game)
												_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
												exitTo2 = nil
												exitTo5 = nil

												while true do
													callbackPlayerDataData += n8

													if not (n8 <= 0) then
														exitTo5 = 1

														break
													end

													if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
														break
													end

													Character = plr.Character

													if Character:FindFirstChild("RaceEnergy").Value == 1 then
														exitTo5 = 2

														break
													end

													Character2 = plr.Character

													if Character2:FindFirstChild("RaceTransformed").Value == false then
														callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

														if callbackPlayerDataCallbackReference then
															while true do
																wait()
																playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																if _G.TrainDrago == false then
																	break
																elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																	break
																end
															end
														else
															_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
														end
													end
												end

												if exitTo5 == 1 then
													if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
														exitTo19 = nil

														while true do
															Character = plr.Character

															if Character:FindFirstChild("RaceEnergy").Value == 1 then
																exitTo19 = 1

																break
															end

															Character2 = plr.Character

															if Character2:FindFirstChild("RaceTransformed").Value == false then
																callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																if callbackPlayerDataCallbackReference then
																	exitTo6 = nil

																	while true do
																		wait()
																		playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																		if _G.TrainDrago == false then
																			break
																		elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																			exitTo6 = 1

																			break
																		end
																	end

																	if exitTo6 == 1 then
																		exitTo7 = nil

																		while true do
																			callbackPlayerDataData += n8

																			if not (n8 <= 0) then
																				exitTo7 = 1

																				break
																			end

																			if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																				break
																			end

																			Character = plr.Character

																			if Character:FindFirstChild("RaceEnergy").Value == 1 then
																				exitTo7 = 2

																				break
																			end

																			Character2 = plr.Character

																			if Character2:FindFirstChild("RaceTransformed").Value == false then
																				callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																				if callbackPlayerDataCallbackReference then
																					while true do
																						wait()
																						playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																						if _G.TrainDrago == false then
																							break
																						elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																							break
																						end
																					end
																				else
																					_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																				end
																			end
																		end

																		if exitTo7 == 1 then
																			if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																				continue
																			end

																			exitTo19 = 8

																			break
																		end

																		exitTo19 = 7

																		break
																	end

																	exitTo8 = nil

																	while true do
																		callbackPlayerDataData += n8

																		if not (n8 <= 0) then
																			exitTo8 = 1

																			break
																		end

																		if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																			break
																		end

																		Character = plr.Character

																		if Character:FindFirstChild("RaceEnergy").Value == 1 then
																			exitTo8 = 2

																			break
																		end

																		Character2 = plr.Character

																		if Character2:FindFirstChild("RaceTransformed").Value == false then
																			callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																			if callbackPlayerDataCallbackReference then
																				while true do
																					wait()
																					playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																					if _G.TrainDrago == false then
																						break
																					elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																						break
																					end
																				end
																			else
																				_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																			end
																		end
																	end

																	if exitTo8 == 1 then
																		if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																			continue
																		end

																		exitTo19 = 6

																		break
																	end

																	exitTo19 = 5

																	break
																end

																_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																exitTo9 = nil

																while true do
																	callbackPlayerDataData += n8

																	if not (n8 <= 0) then
																		exitTo9 = 1

																		break
																	end

																	if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																		break
																	end

																	Character = plr.Character

																	if Character:FindFirstChild("RaceEnergy").Value == 1 then
																		exitTo9 = 2

																		break
																	end

																	Character2 = plr.Character

																	if Character2:FindFirstChild("RaceTransformed").Value == false then
																		callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																		if callbackPlayerDataCallbackReference then
																			while true do
																				wait()
																				playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																				if _G.TrainDrago == false then
																					break
																				elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																					break
																				end
																			end
																		else
																			_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																		end
																	end
																end

																if exitTo9 == 1 then
																	if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																		continue
																	end

																	exitTo19 = 4

																	break
																end

																exitTo19 = 3

																break
															end

															exitTo10 = nil

															while true do
																callbackPlayerDataData += n8

																if not (n8 <= 0) then
																	exitTo10 = 1

																	break
																end

																if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																	break
																end

																Character = plr.Character

																if Character:FindFirstChild("RaceEnergy").Value == 1 then
																	exitTo10 = 2

																	break
																end

																Character2 = plr.Character

																if Character2:FindFirstChild("RaceTransformed").Value == false then
																	callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																	if callbackPlayerDataCallbackReference then
																		while true do
																			wait()
																			playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																			if _G.TrainDrago == false then
																				break
																			elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																				break
																			end
																		end
																	else
																		_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																	end
																end
															end

															if exitTo10 == 1 then
																if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																	continue
																end

																exitTo19 = 2

																break
															end

															break
														end

														if exitTo19 == 1 then
															exitTo2 = 1

															if exitTo2 == 1 then
																continue
															end
														elseif exitTo19 == 2 then
															if exitTo2 == 1 then
																continue
															end
														elseif exitTo19 == 3 then
															if exitTo9 == 2 then
																exitTo2 = 1

																if exitTo2 == 1 then
																	continue
																end
															elseif exitTo2 == 1 then
																continue
															end
														elseif exitTo19 == 4 then
															if exitTo2 == 1 then
																continue
															end
														elseif exitTo19 == 5 then
															if exitTo8 == 2 then
																exitTo2 = 1

																if exitTo2 == 1 then
																	continue
																end
															elseif exitTo2 == 1 then
																continue
															end
														elseif exitTo19 == 6 then
															if exitTo2 == 1 then
																continue
															end
														elseif exitTo19 == 7 then
															if exitTo7 == 2 then
																exitTo2 = 1

																if exitTo2 == 1 then
																	continue
																end
															elseif exitTo2 == 1 then
																continue
															end
														elseif exitTo19 == 8 then
															if exitTo2 == 1 then
																continue
															end
														elseif exitTo10 == 2 then
															exitTo2 = 1

															if exitTo2 == 1 then
																continue
															end
														elseif exitTo2 == 1 then
															continue
														end
													elseif exitTo2 == 1 then
														continue
													end
												elseif exitTo5 == 2 then
													exitTo2 = 1

													if exitTo2 == 1 then
														continue
													end
												elseif exitTo2 == 1 then
													continue
												end

												break
											end
										end
									elseif exitTo2 == 1 then
										while true do
											vim1:SendKeyEvent(true, "Y", true, game)
											replicated.Remotes.CommF_:InvokeServer("UpgradeRace", "Buy", 2)
											vim1:SendKeyEvent(false, "Y", true, game)
											_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
											exitTo2 = nil
											exitTo5 = nil

											while true do
												callbackPlayerDataData += n8

												if not (n8 <= 0) then
													exitTo5 = 1

													break
												end

												if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
													break
												end

												Character = plr.Character

												if Character:FindFirstChild("RaceEnergy").Value == 1 then
													exitTo5 = 2

													break
												end

												Character2 = plr.Character

												if Character2:FindFirstChild("RaceTransformed").Value == false then
													callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

													if callbackPlayerDataCallbackReference then
														while true do
															wait()
															playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

															if _G.TrainDrago == false then
																break
															elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																break
															end
														end
													else
														_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
													end
												end
											end

											if exitTo5 == 1 then
												if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
													exitTo19 = nil

													while true do
														Character = plr.Character

														if Character:FindFirstChild("RaceEnergy").Value == 1 then
															exitTo19 = 1

															break
														end

														Character2 = plr.Character

														if Character2:FindFirstChild("RaceTransformed").Value == false then
															callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

															if callbackPlayerDataCallbackReference then
																exitTo6 = nil

																while true do
																	wait()
																	playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																	if _G.TrainDrago == false then
																		break
																	elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																		exitTo6 = 1

																		break
																	end
																end

																if exitTo6 == 1 then
																	exitTo7 = nil

																	while true do
																		callbackPlayerDataData += n8

																		if not (n8 <= 0) then
																			exitTo7 = 1

																			break
																		end

																		if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																			break
																		end

																		Character = plr.Character

																		if Character:FindFirstChild("RaceEnergy").Value == 1 then
																			exitTo7 = 2

																			break
																		end

																		Character2 = plr.Character

																		if Character2:FindFirstChild("RaceTransformed").Value == false then
																			callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																			if callbackPlayerDataCallbackReference then
																				while true do
																					wait()
																					playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																					if _G.TrainDrago == false then
																						break
																					elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																						break
																					end
																				end
																			else
																				_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																			end
																		end
																	end

																	if exitTo7 == 1 then
																		if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																			continue
																		end

																		exitTo19 = 8

																		break
																	end

																	exitTo19 = 7

																	break
																end

																exitTo8 = nil

																while true do
																	callbackPlayerDataData += n8

																	if not (n8 <= 0) then
																		exitTo8 = 1

																		break
																	end

																	if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																		break
																	end

																	Character = plr.Character

																	if Character:FindFirstChild("RaceEnergy").Value == 1 then
																		exitTo8 = 2

																		break
																	end

																	Character2 = plr.Character

																	if Character2:FindFirstChild("RaceTransformed").Value == false then
																		callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																		if callbackPlayerDataCallbackReference then
																			while true do
																				wait()
																				playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																				if _G.TrainDrago == false then
																					break
																				elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																					break
																				end
																			end
																		else
																			_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																		end
																	end
																end

																if exitTo8 == 1 then
																	if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																		continue
																	end

																	exitTo19 = 6

																	break
																end

																exitTo19 = 5

																break
															end

															_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
															exitTo9 = nil

															while true do
																callbackPlayerDataData += n8

																if not (n8 <= 0) then
																	exitTo9 = 1

																	break
																end

																if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																	break
																end

																Character = plr.Character

																if Character:FindFirstChild("RaceEnergy").Value == 1 then
																	exitTo9 = 2

																	break
																end

																Character2 = plr.Character

																if Character2:FindFirstChild("RaceTransformed").Value == false then
																	callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																	if callbackPlayerDataCallbackReference then
																		while true do
																			wait()
																			playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																			if _G.TrainDrago == false then
																				break
																			elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																				break
																			end
																		end
																	else
																		_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																	end
																end
															end

															if exitTo9 == 1 then
																if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																	continue
																end

																exitTo19 = 4

																break
															end

															exitTo19 = 3

															break
														end

														exitTo10 = nil

														while true do
															callbackPlayerDataData += n8

															if not (n8 <= 0) then
																exitTo10 = 1

																break
															end

															if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																break
															end

															Character = plr.Character

															if Character:FindFirstChild("RaceEnergy").Value == 1 then
																exitTo10 = 2

																break
															end

															Character2 = plr.Character

															if Character2:FindFirstChild("RaceTransformed").Value == false then
																callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																if callbackPlayerDataCallbackReference then
																	while true do
																		wait()
																		playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																		if _G.TrainDrago == false then
																			break
																		elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																			break
																		end
																	end
																else
																	_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																end
															end
														end

														if exitTo10 == 1 then
															if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																continue
															end

															exitTo19 = 2

															break
														end

														break
													end

													if exitTo19 == 1 then
														exitTo2 = 1

														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 2 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 3 then
														if exitTo9 == 2 then
															exitTo2 = 1

															if exitTo2 == 1 then
																continue
															end
														elseif exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 4 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 5 then
														if exitTo8 == 2 then
															exitTo2 = 1

															if exitTo2 == 1 then
																continue
															end
														elseif exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 6 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 7 then
														if exitTo7 == 2 then
															exitTo2 = 1

															if exitTo2 == 1 then
																continue
															end
														elseif exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 8 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo10 == 2 then
														exitTo2 = 1

														if exitTo2 == 1 then
															continue
														end
													elseif exitTo2 == 1 then
														continue
													end
												elseif exitTo2 == 1 then
													continue
												end
											elseif exitTo5 == 2 then
												exitTo2 = 1

												if exitTo2 == 1 then
													continue
												end
											elseif exitTo2 == 1 then
												continue
											end

											break
										end
									end
								elseif exitTo18 == 4 then
									if exitTo2 == 1 then
										while true do
											vim1:SendKeyEvent(true, "Y", true, game)
											replicated.Remotes.CommF_:InvokeServer("UpgradeRace", "Buy", 2)
											vim1:SendKeyEvent(false, "Y", true, game)
											_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
											exitTo2 = nil
											exitTo5 = nil

											while true do
												callbackPlayerDataData += n8

												if not (n8 <= 0) then
													exitTo5 = 1

													break
												end

												if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
													break
												end

												Character = plr.Character

												if Character:FindFirstChild("RaceEnergy").Value == 1 then
													exitTo5 = 2

													break
												end

												Character2 = plr.Character

												if Character2:FindFirstChild("RaceTransformed").Value == false then
													callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

													if callbackPlayerDataCallbackReference then
														while true do
															wait()
															playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

															if _G.TrainDrago == false then
																break
															elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																break
															end
														end
													else
														_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
													end
												end
											end

											if exitTo5 == 1 then
												if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
													exitTo19 = nil

													while true do
														Character = plr.Character

														if Character:FindFirstChild("RaceEnergy").Value == 1 then
															exitTo19 = 1

															break
														end

														Character2 = plr.Character

														if Character2:FindFirstChild("RaceTransformed").Value == false then
															callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

															if callbackPlayerDataCallbackReference then
																exitTo6 = nil

																while true do
																	wait()
																	playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																	if _G.TrainDrago == false then
																		break
																	elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																		exitTo6 = 1

																		break
																	end
																end

																if exitTo6 == 1 then
																	exitTo7 = nil

																	while true do
																		callbackPlayerDataData += n8

																		if not (n8 <= 0) then
																			exitTo7 = 1

																			break
																		end

																		if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																			break
																		end

																		Character = plr.Character

																		if Character:FindFirstChild("RaceEnergy").Value == 1 then
																			exitTo7 = 2

																			break
																		end

																		Character2 = plr.Character

																		if Character2:FindFirstChild("RaceTransformed").Value == false then
																			callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																			if callbackPlayerDataCallbackReference then
																				while true do
																					wait()
																					playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																					if _G.TrainDrago == false then
																						break
																					elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																						break
																					end
																				end
																			else
																				_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																			end
																		end
																	end

																	if exitTo7 == 1 then
																		if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																			continue
																		end

																		exitTo19 = 8

																		break
																	end

																	exitTo19 = 7

																	break
																end

																exitTo8 = nil

																while true do
																	callbackPlayerDataData += n8

																	if not (n8 <= 0) then
																		exitTo8 = 1

																		break
																	end

																	if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																		break
																	end

																	Character = plr.Character

																	if Character:FindFirstChild("RaceEnergy").Value == 1 then
																		exitTo8 = 2

																		break
																	end

																	Character2 = plr.Character

																	if Character2:FindFirstChild("RaceTransformed").Value == false then
																		callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																		if callbackPlayerDataCallbackReference then
																			while true do
																				wait()
																				playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																				if _G.TrainDrago == false then
																					break
																				elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																					break
																				end
																			end
																		else
																			_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																		end
																	end
																end

																if exitTo8 == 1 then
																	if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																		continue
																	end

																	exitTo19 = 6

																	break
																end

																exitTo19 = 5

																break
															end

															_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
															exitTo9 = nil

															while true do
																callbackPlayerDataData += n8

																if not (n8 <= 0) then
																	exitTo9 = 1

																	break
																end

																if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																	break
																end

																Character = plr.Character

																if Character:FindFirstChild("RaceEnergy").Value == 1 then
																	exitTo9 = 2

																	break
																end

																Character2 = plr.Character

																if Character2:FindFirstChild("RaceTransformed").Value == false then
																	callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																	if callbackPlayerDataCallbackReference then
																		while true do
																			wait()
																			playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																			if _G.TrainDrago == false then
																				break
																			elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																				break
																			end
																		end
																	else
																		_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																	end
																end
															end

															if exitTo9 == 1 then
																if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																	continue
																end

																exitTo19 = 4

																break
															end

															exitTo19 = 3

															break
														end

														exitTo10 = nil

														while true do
															callbackPlayerDataData += n8

															if not (n8 <= 0) then
																exitTo10 = 1

																break
															end

															if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																break
															end

															Character = plr.Character

															if Character:FindFirstChild("RaceEnergy").Value == 1 then
																exitTo10 = 2

																break
															end

															Character2 = plr.Character

															if Character2:FindFirstChild("RaceTransformed").Value == false then
																callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																if callbackPlayerDataCallbackReference then
																	while true do
																		wait()
																		playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																		if _G.TrainDrago == false then
																			break
																		elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																			break
																		end
																	end
																else
																	_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																end
															end
														end

														if exitTo10 == 1 then
															if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																continue
															end

															exitTo19 = 2

															break
														end

														break
													end

													if exitTo19 == 1 then
														exitTo2 = 1

														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 2 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 3 then
														if exitTo9 == 2 then
															exitTo2 = 1

															if exitTo2 == 1 then
																continue
															end
														elseif exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 4 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 5 then
														if exitTo8 == 2 then
															exitTo2 = 1

															if exitTo2 == 1 then
																continue
															end
														elseif exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 6 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 7 then
														if exitTo7 == 2 then
															exitTo2 = 1

															if exitTo2 == 1 then
																continue
															end
														elseif exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 8 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo10 == 2 then
														exitTo2 = 1

														if exitTo2 == 1 then
															continue
														end
													elseif exitTo2 == 1 then
														continue
													end
												elseif exitTo2 == 1 then
													continue
												end
											elseif exitTo5 == 2 then
												exitTo2 = 1

												if exitTo2 == 1 then
													continue
												end
											elseif exitTo2 == 1 then
												continue
											end

											break
										end
									end
								elseif exitTo18 == 5 then
									if exitTo8 == 2 then
										exitTo2 = 1

										if exitTo2 == 1 then
											while true do
												vim1:SendKeyEvent(true, "Y", true, game)
												replicated.Remotes.CommF_:InvokeServer("UpgradeRace", "Buy", 2)
												vim1:SendKeyEvent(false, "Y", true, game)
												_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
												exitTo2 = nil
												exitTo5 = nil

												while true do
													callbackPlayerDataData += n8

													if not (n8 <= 0) then
														exitTo5 = 1

														break
													end

													if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
														break
													end

													Character = plr.Character

													if Character:FindFirstChild("RaceEnergy").Value == 1 then
														exitTo5 = 2

														break
													end

													Character2 = plr.Character

													if Character2:FindFirstChild("RaceTransformed").Value == false then
														callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

														if callbackPlayerDataCallbackReference then
															while true do
																wait()
																playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																if _G.TrainDrago == false then
																	break
																elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																	break
																end
															end
														else
															_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
														end
													end
												end

												if exitTo5 == 1 then
													if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
														exitTo19 = nil

														while true do
															Character = plr.Character

															if Character:FindFirstChild("RaceEnergy").Value == 1 then
																exitTo19 = 1

																break
															end

															Character2 = plr.Character

															if Character2:FindFirstChild("RaceTransformed").Value == false then
																callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																if callbackPlayerDataCallbackReference then
																	exitTo6 = nil

																	while true do
																		wait()
																		playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																		if _G.TrainDrago == false then
																			break
																		elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																			exitTo6 = 1

																			break
																		end
																	end

																	if exitTo6 == 1 then
																		exitTo7 = nil

																		while true do
																			callbackPlayerDataData += n8

																			if not (n8 <= 0) then
																				exitTo7 = 1

																				break
																			end

																			if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																				break
																			end

																			Character = plr.Character

																			if Character:FindFirstChild("RaceEnergy").Value == 1 then
																				exitTo7 = 2

																				break
																			end

																			Character2 = plr.Character

																			if Character2:FindFirstChild("RaceTransformed").Value == false then
																				callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																				if callbackPlayerDataCallbackReference then
																					while true do
																						wait()
																						playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																						if _G.TrainDrago == false then
																							break
																						elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																							break
																						end
																					end
																				else
																					_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																				end
																			end
																		end

																		if exitTo7 == 1 then
																			if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																				continue
																			end

																			exitTo19 = 8

																			break
																		end

																		exitTo19 = 7

																		break
																	end

																	exitTo8 = nil

																	while true do
																		callbackPlayerDataData += n8

																		if not (n8 <= 0) then
																			exitTo8 = 1

																			break
																		end

																		if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																			break
																		end

																		Character = plr.Character

																		if Character:FindFirstChild("RaceEnergy").Value == 1 then
																			exitTo8 = 2

																			break
																		end

																		Character2 = plr.Character

																		if Character2:FindFirstChild("RaceTransformed").Value == false then
																			callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																			if callbackPlayerDataCallbackReference then
																				while true do
																					wait()
																					playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																					if _G.TrainDrago == false then
																						break
																					elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																						break
																					end
																				end
																			else
																				_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																			end
																		end
																	end

																	if exitTo8 == 1 then
																		if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																			continue
																		end

																		exitTo19 = 6

																		break
																	end

																	exitTo19 = 5

																	break
																end

																_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																exitTo9 = nil

																while true do
																	callbackPlayerDataData += n8

																	if not (n8 <= 0) then
																		exitTo9 = 1

																		break
																	end

																	if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																		break
																	end

																	Character = plr.Character

																	if Character:FindFirstChild("RaceEnergy").Value == 1 then
																		exitTo9 = 2

																		break
																	end

																	Character2 = plr.Character

																	if Character2:FindFirstChild("RaceTransformed").Value == false then
																		callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																		if callbackPlayerDataCallbackReference then
																			while true do
																				wait()
																				playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																				if _G.TrainDrago == false then
																					break
																				elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																					break
																				end
																			end
																		else
																			_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																		end
																	end
																end

																if exitTo9 == 1 then
																	if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																		continue
																	end

																	exitTo19 = 4

																	break
																end

																exitTo19 = 3

																break
															end

															exitTo10 = nil

															while true do
																callbackPlayerDataData += n8

																if not (n8 <= 0) then
																	exitTo10 = 1

																	break
																end

																if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																	break
																end

																Character = plr.Character

																if Character:FindFirstChild("RaceEnergy").Value == 1 then
																	exitTo10 = 2

																	break
																end

																Character2 = plr.Character

																if Character2:FindFirstChild("RaceTransformed").Value == false then
																	callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																	if callbackPlayerDataCallbackReference then
																		while true do
																			wait()
																			playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																			if _G.TrainDrago == false then
																				break
																			elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																				break
																			end
																		end
																	else
																		_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																	end
																end
															end

															if exitTo10 == 1 then
																if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																	continue
																end

																exitTo19 = 2

																break
															end

															break
														end

														if exitTo19 == 1 then
															exitTo2 = 1

															if exitTo2 == 1 then
																continue
															end
														elseif exitTo19 == 2 then
															if exitTo2 == 1 then
																continue
															end
														elseif exitTo19 == 3 then
															if exitTo9 == 2 then
																exitTo2 = 1

																if exitTo2 == 1 then
																	continue
																end
															elseif exitTo2 == 1 then
																continue
															end
														elseif exitTo19 == 4 then
															if exitTo2 == 1 then
																continue
															end
														elseif exitTo19 == 5 then
															if exitTo8 == 2 then
																exitTo2 = 1

																if exitTo2 == 1 then
																	continue
																end
															elseif exitTo2 == 1 then
																continue
															end
														elseif exitTo19 == 6 then
															if exitTo2 == 1 then
																continue
															end
														elseif exitTo19 == 7 then
															if exitTo7 == 2 then
																exitTo2 = 1

																if exitTo2 == 1 then
																	continue
																end
															elseif exitTo2 == 1 then
																continue
															end
														elseif exitTo19 == 8 then
															if exitTo2 == 1 then
																continue
															end
														elseif exitTo10 == 2 then
															exitTo2 = 1

															if exitTo2 == 1 then
																continue
															end
														elseif exitTo2 == 1 then
															continue
														end
													elseif exitTo2 == 1 then
														continue
													end
												elseif exitTo5 == 2 then
													exitTo2 = 1

													if exitTo2 == 1 then
														continue
													end
												elseif exitTo2 == 1 then
													continue
												end

												break
											end
										end
									elseif exitTo2 == 1 then
										while true do
											vim1:SendKeyEvent(true, "Y", true, game)
											replicated.Remotes.CommF_:InvokeServer("UpgradeRace", "Buy", 2)
											vim1:SendKeyEvent(false, "Y", true, game)
											_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
											exitTo2 = nil
											exitTo5 = nil

											while true do
												callbackPlayerDataData += n8

												if not (n8 <= 0) then
													exitTo5 = 1

													break
												end

												if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
													break
												end

												Character = plr.Character

												if Character:FindFirstChild("RaceEnergy").Value == 1 then
													exitTo5 = 2

													break
												end

												Character2 = plr.Character

												if Character2:FindFirstChild("RaceTransformed").Value == false then
													callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

													if callbackPlayerDataCallbackReference then
														while true do
															wait()
															playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

															if _G.TrainDrago == false then
																break
															elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																break
															end
														end
													else
														_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
													end
												end
											end

											if exitTo5 == 1 then
												if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
													exitTo19 = nil

													while true do
														Character = plr.Character

														if Character:FindFirstChild("RaceEnergy").Value == 1 then
															exitTo19 = 1

															break
														end

														Character2 = plr.Character

														if Character2:FindFirstChild("RaceTransformed").Value == false then
															callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

															if callbackPlayerDataCallbackReference then
																exitTo6 = nil

																while true do
																	wait()
																	playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																	if _G.TrainDrago == false then
																		break
																	elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																		exitTo6 = 1

																		break
																	end
																end

																if exitTo6 == 1 then
																	exitTo7 = nil

																	while true do
																		callbackPlayerDataData += n8

																		if not (n8 <= 0) then
																			exitTo7 = 1

																			break
																		end

																		if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																			break
																		end

																		Character = plr.Character

																		if Character:FindFirstChild("RaceEnergy").Value == 1 then
																			exitTo7 = 2

																			break
																		end

																		Character2 = plr.Character

																		if Character2:FindFirstChild("RaceTransformed").Value == false then
																			callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																			if callbackPlayerDataCallbackReference then
																				while true do
																					wait()
																					playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																					if _G.TrainDrago == false then
																						break
																					elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																						break
																					end
																				end
																			else
																				_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																			end
																		end
																	end

																	if exitTo7 == 1 then
																		if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																			continue
																		end

																		exitTo19 = 8

																		break
																	end

																	exitTo19 = 7

																	break
																end

																exitTo8 = nil

																while true do
																	callbackPlayerDataData += n8

																	if not (n8 <= 0) then
																		exitTo8 = 1

																		break
																	end

																	if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																		break
																	end

																	Character = plr.Character

																	if Character:FindFirstChild("RaceEnergy").Value == 1 then
																		exitTo8 = 2

																		break
																	end

																	Character2 = plr.Character

																	if Character2:FindFirstChild("RaceTransformed").Value == false then
																		callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																		if callbackPlayerDataCallbackReference then
																			while true do
																				wait()
																				playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																				if _G.TrainDrago == false then
																					break
																				elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																					break
																				end
																			end
																		else
																			_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																		end
																	end
																end

																if exitTo8 == 1 then
																	if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																		continue
																	end

																	exitTo19 = 6

																	break
																end

																exitTo19 = 5

																break
															end

															_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
															exitTo9 = nil

															while true do
																callbackPlayerDataData += n8

																if not (n8 <= 0) then
																	exitTo9 = 1

																	break
																end

																if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																	break
																end

																Character = plr.Character

																if Character:FindFirstChild("RaceEnergy").Value == 1 then
																	exitTo9 = 2

																	break
																end

																Character2 = plr.Character

																if Character2:FindFirstChild("RaceTransformed").Value == false then
																	callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																	if callbackPlayerDataCallbackReference then
																		while true do
																			wait()
																			playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																			if _G.TrainDrago == false then
																				break
																			elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																				break
																			end
																		end
																	else
																		_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																	end
																end
															end

															if exitTo9 == 1 then
																if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																	continue
																end

																exitTo19 = 4

																break
															end

															exitTo19 = 3

															break
														end

														exitTo10 = nil

														while true do
															callbackPlayerDataData += n8

															if not (n8 <= 0) then
																exitTo10 = 1

																break
															end

															if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																break
															end

															Character = plr.Character

															if Character:FindFirstChild("RaceEnergy").Value == 1 then
																exitTo10 = 2

																break
															end

															Character2 = plr.Character

															if Character2:FindFirstChild("RaceTransformed").Value == false then
																callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																if callbackPlayerDataCallbackReference then
																	while true do
																		wait()
																		playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																		if _G.TrainDrago == false then
																			break
																		elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																			break
																		end
																	end
																else
																	_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																end
															end
														end

														if exitTo10 == 1 then
															if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																continue
															end

															exitTo19 = 2

															break
														end

														break
													end

													if exitTo19 == 1 then
														exitTo2 = 1

														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 2 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 3 then
														if exitTo9 == 2 then
															exitTo2 = 1

															if exitTo2 == 1 then
																continue
															end
														elseif exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 4 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 5 then
														if exitTo8 == 2 then
															exitTo2 = 1

															if exitTo2 == 1 then
																continue
															end
														elseif exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 6 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 7 then
														if exitTo7 == 2 then
															exitTo2 = 1

															if exitTo2 == 1 then
																continue
															end
														elseif exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 8 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo10 == 2 then
														exitTo2 = 1

														if exitTo2 == 1 then
															continue
														end
													elseif exitTo2 == 1 then
														continue
													end
												elseif exitTo2 == 1 then
													continue
												end
											elseif exitTo5 == 2 then
												exitTo2 = 1

												if exitTo2 == 1 then
													continue
												end
											elseif exitTo2 == 1 then
												continue
											end

											break
										end
									end
								elseif exitTo18 == 6 then
									if exitTo2 == 1 then
										while true do
											vim1:SendKeyEvent(true, "Y", true, game)
											replicated.Remotes.CommF_:InvokeServer("UpgradeRace", "Buy", 2)
											vim1:SendKeyEvent(false, "Y", true, game)
											_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
											exitTo2 = nil
											exitTo5 = nil

											while true do
												callbackPlayerDataData += n8

												if not (n8 <= 0) then
													exitTo5 = 1

													break
												end

												if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
													break
												end

												Character = plr.Character

												if Character:FindFirstChild("RaceEnergy").Value == 1 then
													exitTo5 = 2

													break
												end

												Character2 = plr.Character

												if Character2:FindFirstChild("RaceTransformed").Value == false then
													callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

													if callbackPlayerDataCallbackReference then
														while true do
															wait()
															playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

															if _G.TrainDrago == false then
																break
															elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																break
															end
														end
													else
														_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
													end
												end
											end

											if exitTo5 == 1 then
												if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
													exitTo19 = nil

													while true do
														Character = plr.Character

														if Character:FindFirstChild("RaceEnergy").Value == 1 then
															exitTo19 = 1

															break
														end

														Character2 = plr.Character

														if Character2:FindFirstChild("RaceTransformed").Value == false then
															callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

															if callbackPlayerDataCallbackReference then
																exitTo6 = nil

																while true do
																	wait()
																	playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																	if _G.TrainDrago == false then
																		break
																	elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																		exitTo6 = 1

																		break
																	end
																end

																if exitTo6 == 1 then
																	exitTo7 = nil

																	while true do
																		callbackPlayerDataData += n8

																		if not (n8 <= 0) then
																			exitTo7 = 1

																			break
																		end

																		if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																			break
																		end

																		Character = plr.Character

																		if Character:FindFirstChild("RaceEnergy").Value == 1 then
																			exitTo7 = 2

																			break
																		end

																		Character2 = plr.Character

																		if Character2:FindFirstChild("RaceTransformed").Value == false then
																			callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																			if callbackPlayerDataCallbackReference then
																				while true do
																					wait()
																					playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																					if _G.TrainDrago == false then
																						break
																					elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																						break
																					end
																				end
																			else
																				_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																			end
																		end
																	end

																	if exitTo7 == 1 then
																		if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																			continue
																		end

																		exitTo19 = 8

																		break
																	end

																	exitTo19 = 7

																	break
																end

																exitTo8 = nil

																while true do
																	callbackPlayerDataData += n8

																	if not (n8 <= 0) then
																		exitTo8 = 1

																		break
																	end

																	if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																		break
																	end

																	Character = plr.Character

																	if Character:FindFirstChild("RaceEnergy").Value == 1 then
																		exitTo8 = 2

																		break
																	end

																	Character2 = plr.Character

																	if Character2:FindFirstChild("RaceTransformed").Value == false then
																		callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																		if callbackPlayerDataCallbackReference then
																			while true do
																				wait()
																				playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																				if _G.TrainDrago == false then
																					break
																				elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																					break
																				end
																			end
																		else
																			_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																		end
																	end
																end

																if exitTo8 == 1 then
																	if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																		continue
																	end

																	exitTo19 = 6

																	break
																end

																exitTo19 = 5

																break
															end

															_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
															exitTo9 = nil

															while true do
																callbackPlayerDataData += n8

																if not (n8 <= 0) then
																	exitTo9 = 1

																	break
																end

																if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																	break
																end

																Character = plr.Character

																if Character:FindFirstChild("RaceEnergy").Value == 1 then
																	exitTo9 = 2

																	break
																end

																Character2 = plr.Character

																if Character2:FindFirstChild("RaceTransformed").Value == false then
																	callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																	if callbackPlayerDataCallbackReference then
																		while true do
																			wait()
																			playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																			if _G.TrainDrago == false then
																				break
																			elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																				break
																			end
																		end
																	else
																		_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																	end
																end
															end

															if exitTo9 == 1 then
																if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																	continue
																end

																exitTo19 = 4

																break
															end

															exitTo19 = 3

															break
														end

														exitTo10 = nil

														while true do
															callbackPlayerDataData += n8

															if not (n8 <= 0) then
																exitTo10 = 1

																break
															end

															if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																break
															end

															Character = plr.Character

															if Character:FindFirstChild("RaceEnergy").Value == 1 then
																exitTo10 = 2

																break
															end

															Character2 = plr.Character

															if Character2:FindFirstChild("RaceTransformed").Value == false then
																callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																if callbackPlayerDataCallbackReference then
																	while true do
																		wait()
																		playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																		if _G.TrainDrago == false then
																			break
																		elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																			break
																		end
																	end
																else
																	_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																end
															end
														end

														if exitTo10 == 1 then
															if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																continue
															end

															exitTo19 = 2

															break
														end

														break
													end

													if exitTo19 == 1 then
														exitTo2 = 1

														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 2 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 3 then
														if exitTo9 == 2 then
															exitTo2 = 1

															if exitTo2 == 1 then
																continue
															end
														elseif exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 4 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 5 then
														if exitTo8 == 2 then
															exitTo2 = 1

															if exitTo2 == 1 then
																continue
															end
														elseif exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 6 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 7 then
														if exitTo7 == 2 then
															exitTo2 = 1

															if exitTo2 == 1 then
																continue
															end
														elseif exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 8 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo10 == 2 then
														exitTo2 = 1

														if exitTo2 == 1 then
															continue
														end
													elseif exitTo2 == 1 then
														continue
													end
												elseif exitTo2 == 1 then
													continue
												end
											elseif exitTo5 == 2 then
												exitTo2 = 1

												if exitTo2 == 1 then
													continue
												end
											elseif exitTo2 == 1 then
												continue
											end

											break
										end
									end
								elseif exitTo18 == 7 then
									if exitTo7 == 2 then
										exitTo2 = 1

										if exitTo2 == 1 then
											while true do
												vim1:SendKeyEvent(true, "Y", true, game)
												replicated.Remotes.CommF_:InvokeServer("UpgradeRace", "Buy", 2)
												vim1:SendKeyEvent(false, "Y", true, game)
												_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
												exitTo2 = nil
												exitTo5 = nil

												while true do
													callbackPlayerDataData += n8

													if not (n8 <= 0) then
														exitTo5 = 1

														break
													end

													if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
														break
													end

													Character = plr.Character

													if Character:FindFirstChild("RaceEnergy").Value == 1 then
														exitTo5 = 2

														break
													end

													Character2 = plr.Character

													if Character2:FindFirstChild("RaceTransformed").Value == false then
														callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

														if callbackPlayerDataCallbackReference then
															while true do
																wait()
																playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																if _G.TrainDrago == false then
																	break
																elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																	break
																end
															end
														else
															_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
														end
													end
												end

												if exitTo5 == 1 then
													if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
														exitTo19 = nil

														while true do
															Character = plr.Character

															if Character:FindFirstChild("RaceEnergy").Value == 1 then
																exitTo19 = 1

																break
															end

															Character2 = plr.Character

															if Character2:FindFirstChild("RaceTransformed").Value == false then
																callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																if callbackPlayerDataCallbackReference then
																	exitTo6 = nil

																	while true do
																		wait()
																		playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																		if _G.TrainDrago == false then
																			break
																		elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																			exitTo6 = 1

																			break
																		end
																	end

																	if exitTo6 == 1 then
																		exitTo7 = nil

																		while true do
																			callbackPlayerDataData += n8

																			if not (n8 <= 0) then
																				exitTo7 = 1

																				break
																			end

																			if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																				break
																			end

																			Character = plr.Character

																			if Character:FindFirstChild("RaceEnergy").Value == 1 then
																				exitTo7 = 2

																				break
																			end

																			Character2 = plr.Character

																			if Character2:FindFirstChild("RaceTransformed").Value == false then
																				callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																				if callbackPlayerDataCallbackReference then
																					while true do
																						wait()
																						playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																						if _G.TrainDrago == false then
																							break
																						elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																							break
																						end
																					end
																				else
																					_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																				end
																			end
																		end

																		if exitTo7 == 1 then
																			if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																				continue
																			end

																			exitTo19 = 8

																			break
																		end

																		exitTo19 = 7

																		break
																	end

																	exitTo8 = nil

																	while true do
																		callbackPlayerDataData += n8

																		if not (n8 <= 0) then
																			exitTo8 = 1

																			break
																		end

																		if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																			break
																		end

																		Character = plr.Character

																		if Character:FindFirstChild("RaceEnergy").Value == 1 then
																			exitTo8 = 2

																			break
																		end

																		Character2 = plr.Character

																		if Character2:FindFirstChild("RaceTransformed").Value == false then
																			callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																			if callbackPlayerDataCallbackReference then
																				while true do
																					wait()
																					playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																					if _G.TrainDrago == false then
																						break
																					elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																						break
																					end
																				end
																			else
																				_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																			end
																		end
																	end

																	if exitTo8 == 1 then
																		if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																			continue
																		end

																		exitTo19 = 6

																		break
																	end

																	exitTo19 = 5

																	break
																end

																_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																exitTo9 = nil

																while true do
																	callbackPlayerDataData += n8

																	if not (n8 <= 0) then
																		exitTo9 = 1

																		break
																	end

																	if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																		break
																	end

																	Character = plr.Character

																	if Character:FindFirstChild("RaceEnergy").Value == 1 then
																		exitTo9 = 2

																		break
																	end

																	Character2 = plr.Character

																	if Character2:FindFirstChild("RaceTransformed").Value == false then
																		callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																		if callbackPlayerDataCallbackReference then
																			while true do
																				wait()
																				playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																				if _G.TrainDrago == false then
																					break
																				elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																					break
																				end
																			end
																		else
																			_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																		end
																	end
																end

																if exitTo9 == 1 then
																	if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																		continue
																	end

																	exitTo19 = 4

																	break
																end

																exitTo19 = 3

																break
															end

															exitTo10 = nil

															while true do
																callbackPlayerDataData += n8

																if not (n8 <= 0) then
																	exitTo10 = 1

																	break
																end

																if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																	break
																end

																Character = plr.Character

																if Character:FindFirstChild("RaceEnergy").Value == 1 then
																	exitTo10 = 2

																	break
																end

																Character2 = plr.Character

																if Character2:FindFirstChild("RaceTransformed").Value == false then
																	callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																	if callbackPlayerDataCallbackReference then
																		while true do
																			wait()
																			playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																			if _G.TrainDrago == false then
																				break
																			elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																				break
																			end
																		end
																	else
																		_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																	end
																end
															end

															if exitTo10 == 1 then
																if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																	continue
																end

																exitTo19 = 2

																break
															end

															break
														end

														if exitTo19 == 1 then
															exitTo2 = 1

															if exitTo2 == 1 then
																continue
															end
														elseif exitTo19 == 2 then
															if exitTo2 == 1 then
																continue
															end
														elseif exitTo19 == 3 then
															if exitTo9 == 2 then
																exitTo2 = 1

																if exitTo2 == 1 then
																	continue
																end
															elseif exitTo2 == 1 then
																continue
															end
														elseif exitTo19 == 4 then
															if exitTo2 == 1 then
																continue
															end
														elseif exitTo19 == 5 then
															if exitTo8 == 2 then
																exitTo2 = 1

																if exitTo2 == 1 then
																	continue
																end
															elseif exitTo2 == 1 then
																continue
															end
														elseif exitTo19 == 6 then
															if exitTo2 == 1 then
																continue
															end
														elseif exitTo19 == 7 then
															if exitTo7 == 2 then
																exitTo2 = 1

																if exitTo2 == 1 then
																	continue
																end
															elseif exitTo2 == 1 then
																continue
															end
														elseif exitTo19 == 8 then
															if exitTo2 == 1 then
																continue
															end
														elseif exitTo10 == 2 then
															exitTo2 = 1

															if exitTo2 == 1 then
																continue
															end
														elseif exitTo2 == 1 then
															continue
														end
													elseif exitTo2 == 1 then
														continue
													end
												elseif exitTo5 == 2 then
													exitTo2 = 1

													if exitTo2 == 1 then
														continue
													end
												elseif exitTo2 == 1 then
													continue
												end

												break
											end
										end
									elseif exitTo2 == 1 then
										while true do
											vim1:SendKeyEvent(true, "Y", true, game)
											replicated.Remotes.CommF_:InvokeServer("UpgradeRace", "Buy", 2)
											vim1:SendKeyEvent(false, "Y", true, game)
											_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
											exitTo2 = nil
											exitTo5 = nil

											while true do
												callbackPlayerDataData += n8

												if not (n8 <= 0) then
													exitTo5 = 1

													break
												end

												if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
													break
												end

												Character = plr.Character

												if Character:FindFirstChild("RaceEnergy").Value == 1 then
													exitTo5 = 2

													break
												end

												Character2 = plr.Character

												if Character2:FindFirstChild("RaceTransformed").Value == false then
													callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

													if callbackPlayerDataCallbackReference then
														while true do
															wait()
															playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

															if _G.TrainDrago == false then
																break
															elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																break
															end
														end
													else
														_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
													end
												end
											end

											if exitTo5 == 1 then
												if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
													exitTo19 = nil

													while true do
														Character = plr.Character

														if Character:FindFirstChild("RaceEnergy").Value == 1 then
															exitTo19 = 1

															break
														end

														Character2 = plr.Character

														if Character2:FindFirstChild("RaceTransformed").Value == false then
															callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

															if callbackPlayerDataCallbackReference then
																exitTo6 = nil

																while true do
																	wait()
																	playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																	if _G.TrainDrago == false then
																		break
																	elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																		exitTo6 = 1

																		break
																	end
																end

																if exitTo6 == 1 then
																	exitTo7 = nil

																	while true do
																		callbackPlayerDataData += n8

																		if not (n8 <= 0) then
																			exitTo7 = 1

																			break
																		end

																		if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																			break
																		end

																		Character = plr.Character

																		if Character:FindFirstChild("RaceEnergy").Value == 1 then
																			exitTo7 = 2

																			break
																		end

																		Character2 = plr.Character

																		if Character2:FindFirstChild("RaceTransformed").Value == false then
																			callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																			if callbackPlayerDataCallbackReference then
																				while true do
																					wait()
																					playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																					if _G.TrainDrago == false then
																						break
																					elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																						break
																					end
																				end
																			else
																				_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																			end
																		end
																	end

																	if exitTo7 == 1 then
																		if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																			continue
																		end

																		exitTo19 = 8

																		break
																	end

																	exitTo19 = 7

																	break
																end

																exitTo8 = nil

																while true do
																	callbackPlayerDataData += n8

																	if not (n8 <= 0) then
																		exitTo8 = 1

																		break
																	end

																	if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																		break
																	end

																	Character = plr.Character

																	if Character:FindFirstChild("RaceEnergy").Value == 1 then
																		exitTo8 = 2

																		break
																	end

																	Character2 = plr.Character

																	if Character2:FindFirstChild("RaceTransformed").Value == false then
																		callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																		if callbackPlayerDataCallbackReference then
																			while true do
																				wait()
																				playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																				if _G.TrainDrago == false then
																					break
																				elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																					break
																				end
																			end
																		else
																			_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																		end
																	end
																end

																if exitTo8 == 1 then
																	if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																		continue
																	end

																	exitTo19 = 6

																	break
																end

																exitTo19 = 5

																break
															end

															_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
															exitTo9 = nil

															while true do
																callbackPlayerDataData += n8

																if not (n8 <= 0) then
																	exitTo9 = 1

																	break
																end

																if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																	break
																end

																Character = plr.Character

																if Character:FindFirstChild("RaceEnergy").Value == 1 then
																	exitTo9 = 2

																	break
																end

																Character2 = plr.Character

																if Character2:FindFirstChild("RaceTransformed").Value == false then
																	callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																	if callbackPlayerDataCallbackReference then
																		while true do
																			wait()
																			playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																			if _G.TrainDrago == false then
																				break
																			elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																				break
																			end
																		end
																	else
																		_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																	end
																end
															end

															if exitTo9 == 1 then
																if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																	continue
																end

																exitTo19 = 4

																break
															end

															exitTo19 = 3

															break
														end

														exitTo10 = nil

														while true do
															callbackPlayerDataData += n8

															if not (n8 <= 0) then
																exitTo10 = 1

																break
															end

															if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																break
															end

															Character = plr.Character

															if Character:FindFirstChild("RaceEnergy").Value == 1 then
																exitTo10 = 2

																break
															end

															Character2 = plr.Character

															if Character2:FindFirstChild("RaceTransformed").Value == false then
																callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																if callbackPlayerDataCallbackReference then
																	while true do
																		wait()
																		playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																		if _G.TrainDrago == false then
																			break
																		elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																			break
																		end
																	end
																else
																	_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																end
															end
														end

														if exitTo10 == 1 then
															if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																continue
															end

															exitTo19 = 2

															break
														end

														break
													end

													if exitTo19 == 1 then
														exitTo2 = 1

														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 2 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 3 then
														if exitTo9 == 2 then
															exitTo2 = 1

															if exitTo2 == 1 then
																continue
															end
														elseif exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 4 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 5 then
														if exitTo8 == 2 then
															exitTo2 = 1

															if exitTo2 == 1 then
																continue
															end
														elseif exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 6 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 7 then
														if exitTo7 == 2 then
															exitTo2 = 1

															if exitTo2 == 1 then
																continue
															end
														elseif exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 8 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo10 == 2 then
														exitTo2 = 1

														if exitTo2 == 1 then
															continue
														end
													elseif exitTo2 == 1 then
														continue
													end
												elseif exitTo2 == 1 then
													continue
												end
											elseif exitTo5 == 2 then
												exitTo2 = 1

												if exitTo2 == 1 then
													continue
												end
											elseif exitTo2 == 1 then
												continue
											end

											break
										end
									end
								elseif exitTo18 == 8 then
									if exitTo2 == 1 then
										while true do
											vim1:SendKeyEvent(true, "Y", true, game)
											replicated.Remotes.CommF_:InvokeServer("UpgradeRace", "Buy", 2)
											vim1:SendKeyEvent(false, "Y", true, game)
											_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
											exitTo2 = nil
											exitTo5 = nil

											while true do
												callbackPlayerDataData += n8

												if not (n8 <= 0) then
													exitTo5 = 1

													break
												end

												if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
													break
												end

												Character = plr.Character

												if Character:FindFirstChild("RaceEnergy").Value == 1 then
													exitTo5 = 2

													break
												end

												Character2 = plr.Character

												if Character2:FindFirstChild("RaceTransformed").Value == false then
													callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

													if callbackPlayerDataCallbackReference then
														while true do
															wait()
															playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

															if _G.TrainDrago == false then
																break
															elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																break
															end
														end
													else
														_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
													end
												end
											end

											if exitTo5 == 1 then
												if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
													exitTo19 = nil

													while true do
														Character = plr.Character

														if Character:FindFirstChild("RaceEnergy").Value == 1 then
															exitTo19 = 1

															break
														end

														Character2 = plr.Character

														if Character2:FindFirstChild("RaceTransformed").Value == false then
															callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

															if callbackPlayerDataCallbackReference then
																exitTo6 = nil

																while true do
																	wait()
																	playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																	if _G.TrainDrago == false then
																		break
																	elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																		exitTo6 = 1

																		break
																	end
																end

																if exitTo6 == 1 then
																	exitTo7 = nil

																	while true do
																		callbackPlayerDataData += n8

																		if not (n8 <= 0) then
																			exitTo7 = 1

																			break
																		end

																		if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																			break
																		end

																		Character = plr.Character

																		if Character:FindFirstChild("RaceEnergy").Value == 1 then
																			exitTo7 = 2

																			break
																		end

																		Character2 = plr.Character

																		if Character2:FindFirstChild("RaceTransformed").Value == false then
																			callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																			if callbackPlayerDataCallbackReference then
																				while true do
																					wait()
																					playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																					if _G.TrainDrago == false then
																						break
																					elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																						break
																					end
																				end
																			else
																				_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																			end
																		end
																	end

																	if exitTo7 == 1 then
																		if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																			continue
																		end

																		exitTo19 = 8

																		break
																	end

																	exitTo19 = 7

																	break
																end

																exitTo8 = nil

																while true do
																	callbackPlayerDataData += n8

																	if not (n8 <= 0) then
																		exitTo8 = 1

																		break
																	end

																	if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																		break
																	end

																	Character = plr.Character

																	if Character:FindFirstChild("RaceEnergy").Value == 1 then
																		exitTo8 = 2

																		break
																	end

																	Character2 = plr.Character

																	if Character2:FindFirstChild("RaceTransformed").Value == false then
																		callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																		if callbackPlayerDataCallbackReference then
																			while true do
																				wait()
																				playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																				if _G.TrainDrago == false then
																					break
																				elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																					break
																				end
																			end
																		else
																			_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																		end
																	end
																end

																if exitTo8 == 1 then
																	if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																		continue
																	end

																	exitTo19 = 6

																	break
																end

																exitTo19 = 5

																break
															end

															_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
															exitTo9 = nil

															while true do
																callbackPlayerDataData += n8

																if not (n8 <= 0) then
																	exitTo9 = 1

																	break
																end

																if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																	break
																end

																Character = plr.Character

																if Character:FindFirstChild("RaceEnergy").Value == 1 then
																	exitTo9 = 2

																	break
																end

																Character2 = plr.Character

																if Character2:FindFirstChild("RaceTransformed").Value == false then
																	callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																	if callbackPlayerDataCallbackReference then
																		while true do
																			wait()
																			playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																			if _G.TrainDrago == false then
																				break
																			elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																				break
																			end
																		end
																	else
																		_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																	end
																end
															end

															if exitTo9 == 1 then
																if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																	continue
																end

																exitTo19 = 4

																break
															end

															exitTo19 = 3

															break
														end

														exitTo10 = nil

														while true do
															callbackPlayerDataData += n8

															if not (n8 <= 0) then
																exitTo10 = 1

																break
															end

															if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																break
															end

															Character = plr.Character

															if Character:FindFirstChild("RaceEnergy").Value == 1 then
																exitTo10 = 2

																break
															end

															Character2 = plr.Character

															if Character2:FindFirstChild("RaceTransformed").Value == false then
																callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																if callbackPlayerDataCallbackReference then
																	while true do
																		wait()
																		playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																		if _G.TrainDrago == false then
																			break
																		elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																			break
																		end
																	end
																else
																	_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																end
															end
														end

														if exitTo10 == 1 then
															if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																continue
															end

															exitTo19 = 2

															break
														end

														break
													end

													if exitTo19 == 1 then
														exitTo2 = 1

														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 2 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 3 then
														if exitTo9 == 2 then
															exitTo2 = 1

															if exitTo2 == 1 then
																continue
															end
														elseif exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 4 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 5 then
														if exitTo8 == 2 then
															exitTo2 = 1

															if exitTo2 == 1 then
																continue
															end
														elseif exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 6 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 7 then
														if exitTo7 == 2 then
															exitTo2 = 1

															if exitTo2 == 1 then
																continue
															end
														elseif exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 8 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo10 == 2 then
														exitTo2 = 1

														if exitTo2 == 1 then
															continue
														end
													elseif exitTo2 == 1 then
														continue
													end
												elseif exitTo2 == 1 then
													continue
												end
											elseif exitTo5 == 2 then
												exitTo2 = 1

												if exitTo2 == 1 then
													continue
												end
											elseif exitTo2 == 1 then
												continue
											end

											break
										end
									end
								elseif exitTo10 == 2 then
									exitTo2 = 1

									if exitTo2 == 1 then
										while true do
											vim1:SendKeyEvent(true, "Y", true, game)
											replicated.Remotes.CommF_:InvokeServer("UpgradeRace", "Buy", 2)
											vim1:SendKeyEvent(false, "Y", true, game)
											_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
											exitTo2 = nil
											exitTo5 = nil

											while true do
												callbackPlayerDataData += n8

												if not (n8 <= 0) then
													exitTo5 = 1

													break
												end

												if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
													break
												end

												Character = plr.Character

												if Character:FindFirstChild("RaceEnergy").Value == 1 then
													exitTo5 = 2

													break
												end

												Character2 = plr.Character

												if Character2:FindFirstChild("RaceTransformed").Value == false then
													callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

													if callbackPlayerDataCallbackReference then
														while true do
															wait()
															playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

															if _G.TrainDrago == false then
																break
															elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																break
															end
														end
													else
														_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
													end
												end
											end

											if exitTo5 == 1 then
												if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
													exitTo19 = nil

													while true do
														Character = plr.Character

														if Character:FindFirstChild("RaceEnergy").Value == 1 then
															exitTo19 = 1

															break
														end

														Character2 = plr.Character

														if Character2:FindFirstChild("RaceTransformed").Value == false then
															callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

															if callbackPlayerDataCallbackReference then
																exitTo6 = nil

																while true do
																	wait()
																	playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																	if _G.TrainDrago == false then
																		break
																	elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																		exitTo6 = 1

																		break
																	end
																end

																if exitTo6 == 1 then
																	exitTo7 = nil

																	while true do
																		callbackPlayerDataData += n8

																		if not (n8 <= 0) then
																			exitTo7 = 1

																			break
																		end

																		if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																			break
																		end

																		Character = plr.Character

																		if Character:FindFirstChild("RaceEnergy").Value == 1 then
																			exitTo7 = 2

																			break
																		end

																		Character2 = plr.Character

																		if Character2:FindFirstChild("RaceTransformed").Value == false then
																			callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																			if callbackPlayerDataCallbackReference then
																				while true do
																					wait()
																					playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																					if _G.TrainDrago == false then
																						break
																					elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																						break
																					end
																				end
																			else
																				_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																			end
																		end
																	end

																	if exitTo7 == 1 then
																		if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																			continue
																		end

																		exitTo19 = 8

																		break
																	end

																	exitTo19 = 7

																	break
																end

																exitTo8 = nil

																while true do
																	callbackPlayerDataData += n8

																	if not (n8 <= 0) then
																		exitTo8 = 1

																		break
																	end

																	if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																		break
																	end

																	Character = plr.Character

																	if Character:FindFirstChild("RaceEnergy").Value == 1 then
																		exitTo8 = 2

																		break
																	end

																	Character2 = plr.Character

																	if Character2:FindFirstChild("RaceTransformed").Value == false then
																		callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																		if callbackPlayerDataCallbackReference then
																			while true do
																				wait()
																				playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																				if _G.TrainDrago == false then
																					break
																				elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																					break
																				end
																			end
																		else
																			_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																		end
																	end
																end

																if exitTo8 == 1 then
																	if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																		continue
																	end

																	exitTo19 = 6

																	break
																end

																exitTo19 = 5

																break
															end

															_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
															exitTo9 = nil

															while true do
																callbackPlayerDataData += n8

																if not (n8 <= 0) then
																	exitTo9 = 1

																	break
																end

																if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																	break
																end

																Character = plr.Character

																if Character:FindFirstChild("RaceEnergy").Value == 1 then
																	exitTo9 = 2

																	break
																end

																Character2 = plr.Character

																if Character2:FindFirstChild("RaceTransformed").Value == false then
																	callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																	if callbackPlayerDataCallbackReference then
																		while true do
																			wait()
																			playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																			if _G.TrainDrago == false then
																				break
																			elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																				break
																			end
																		end
																	else
																		_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																	end
																end
															end

															if exitTo9 == 1 then
																if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																	continue
																end

																exitTo19 = 4

																break
															end

															exitTo19 = 3

															break
														end

														exitTo10 = nil

														while true do
															callbackPlayerDataData += n8

															if not (n8 <= 0) then
																exitTo10 = 1

																break
															end

															if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																break
															end

															Character = plr.Character

															if Character:FindFirstChild("RaceEnergy").Value == 1 then
																exitTo10 = 2

																break
															end

															Character2 = plr.Character

															if Character2:FindFirstChild("RaceTransformed").Value == false then
																callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																if callbackPlayerDataCallbackReference then
																	while true do
																		wait()
																		playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																		if _G.TrainDrago == false then
																			break
																		elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																			break
																		end
																	end
																else
																	_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																end
															end
														end

														if exitTo10 == 1 then
															if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																continue
															end

															exitTo19 = 2

															break
														end

														break
													end

													if exitTo19 == 1 then
														exitTo2 = 1

														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 2 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 3 then
														if exitTo9 == 2 then
															exitTo2 = 1

															if exitTo2 == 1 then
																continue
															end
														elseif exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 4 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 5 then
														if exitTo8 == 2 then
															exitTo2 = 1

															if exitTo2 == 1 then
																continue
															end
														elseif exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 6 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 7 then
														if exitTo7 == 2 then
															exitTo2 = 1

															if exitTo2 == 1 then
																continue
															end
														elseif exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 8 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo10 == 2 then
														exitTo2 = 1

														if exitTo2 == 1 then
															continue
														end
													elseif exitTo2 == 1 then
														continue
													end
												elseif exitTo2 == 1 then
													continue
												end
											elseif exitTo5 == 2 then
												exitTo2 = 1

												if exitTo2 == 1 then
													continue
												end
											elseif exitTo2 == 1 then
												continue
											end

											break
										end
									end
								elseif exitTo2 == 1 then
									while true do
										vim1:SendKeyEvent(true, "Y", true, game)
										replicated.Remotes.CommF_:InvokeServer("UpgradeRace", "Buy", 2)
										vim1:SendKeyEvent(false, "Y", true, game)
										_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
										exitTo2 = nil
										exitTo5 = nil

										while true do
											callbackPlayerDataData += n8

											if not (n8 <= 0) then
												exitTo5 = 1

												break
											end

											if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
												break
											end

											Character = plr.Character

											if Character:FindFirstChild("RaceEnergy").Value == 1 then
												exitTo5 = 2

												break
											end

											Character2 = plr.Character

											if Character2:FindFirstChild("RaceTransformed").Value == false then
												callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

												if callbackPlayerDataCallbackReference then
													while true do
														wait()
														playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

														if _G.TrainDrago == false then
															break
														elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
															break
														end
													end
												else
													_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
												end
											end
										end

										if exitTo5 == 1 then
											if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
												exitTo19 = nil

												while true do
													Character = plr.Character

													if Character:FindFirstChild("RaceEnergy").Value == 1 then
														exitTo19 = 1

														break
													end

													Character2 = plr.Character

													if Character2:FindFirstChild("RaceTransformed").Value == false then
														callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

														if callbackPlayerDataCallbackReference then
															exitTo6 = nil

															while true do
																wait()
																playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																if _G.TrainDrago == false then
																	break
																elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																	exitTo6 = 1

																	break
																end
															end

															if exitTo6 == 1 then
																exitTo7 = nil

																while true do
																	callbackPlayerDataData += n8

																	if not (n8 <= 0) then
																		exitTo7 = 1

																		break
																	end

																	if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																		break
																	end

																	Character = plr.Character

																	if Character:FindFirstChild("RaceEnergy").Value == 1 then
																		exitTo7 = 2

																		break
																	end

																	Character2 = plr.Character

																	if Character2:FindFirstChild("RaceTransformed").Value == false then
																		callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																		if callbackPlayerDataCallbackReference then
																			while true do
																				wait()
																				playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																				if _G.TrainDrago == false then
																					break
																				elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																					break
																				end
																			end
																		else
																			_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																		end
																	end
																end

																if exitTo7 == 1 then
																	if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																		continue
																	end

																	exitTo19 = 8

																	break
																end

																exitTo19 = 7

																break
															end

															exitTo8 = nil

															while true do
																callbackPlayerDataData += n8

																if not (n8 <= 0) then
																	exitTo8 = 1

																	break
																end

																if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																	break
																end

																Character = plr.Character

																if Character:FindFirstChild("RaceEnergy").Value == 1 then
																	exitTo8 = 2

																	break
																end

																Character2 = plr.Character

																if Character2:FindFirstChild("RaceTransformed").Value == false then
																	callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																	if callbackPlayerDataCallbackReference then
																		while true do
																			wait()
																			playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																			if _G.TrainDrago == false then
																				break
																			elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																				break
																			end
																		end
																	else
																		_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																	end
																end
															end

															if exitTo8 == 1 then
																if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																	continue
																end

																exitTo19 = 6

																break
															end

															exitTo19 = 5

															break
														end

														_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
														exitTo9 = nil

														while true do
															callbackPlayerDataData += n8

															if not (n8 <= 0) then
																exitTo9 = 1

																break
															end

															if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																break
															end

															Character = plr.Character

															if Character:FindFirstChild("RaceEnergy").Value == 1 then
																exitTo9 = 2

																break
															end

															Character2 = plr.Character

															if Character2:FindFirstChild("RaceTransformed").Value == false then
																callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																if callbackPlayerDataCallbackReference then
																	while true do
																		wait()
																		playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																		if _G.TrainDrago == false then
																			break
																		elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																			break
																		end
																	end
																else
																	_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																end
															end
														end

														if exitTo9 == 1 then
															if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																continue
															end

															exitTo19 = 4

															break
														end

														exitTo19 = 3

														break
													end

													exitTo10 = nil

													while true do
														callbackPlayerDataData += n8

														if not (n8 <= 0) then
															exitTo10 = 1

															break
														end

														if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
															break
														end

														Character = plr.Character

														if Character:FindFirstChild("RaceEnergy").Value == 1 then
															exitTo10 = 2

															break
														end

														Character2 = plr.Character

														if Character2:FindFirstChild("RaceTransformed").Value == false then
															callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

															if callbackPlayerDataCallbackReference then
																while true do
																	wait()
																	playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																	if _G.TrainDrago == false then
																		break
																	elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																		break
																	end
																end
															else
																_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
															end
														end
													end

													if exitTo10 == 1 then
														if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
															continue
														end

														exitTo19 = 2

														break
													end

													break
												end

												if exitTo19 == 1 then
													exitTo2 = 1

													if exitTo2 == 1 then
														continue
													end
												elseif exitTo19 == 2 then
													if exitTo2 == 1 then
														continue
													end
												elseif exitTo19 == 3 then
													if exitTo9 == 2 then
														exitTo2 = 1

														if exitTo2 == 1 then
															continue
														end
													elseif exitTo2 == 1 then
														continue
													end
												elseif exitTo19 == 4 then
													if exitTo2 == 1 then
														continue
													end
												elseif exitTo19 == 5 then
													if exitTo8 == 2 then
														exitTo2 = 1

														if exitTo2 == 1 then
															continue
														end
													elseif exitTo2 == 1 then
														continue
													end
												elseif exitTo19 == 6 then
													if exitTo2 == 1 then
														continue
													end
												elseif exitTo19 == 7 then
													if exitTo7 == 2 then
														exitTo2 = 1

														if exitTo2 == 1 then
															continue
														end
													elseif exitTo2 == 1 then
														continue
													end
												elseif exitTo19 == 8 then
													if exitTo2 == 1 then
														continue
													end
												elseif exitTo10 == 2 then
													exitTo2 = 1

													if exitTo2 == 1 then
														continue
													end
												elseif exitTo2 == 1 then
													continue
												end
											elseif exitTo2 == 1 then
												continue
											end
										elseif exitTo5 == 2 then
											exitTo2 = 1

											if exitTo2 == 1 then
												continue
											end
										elseif exitTo2 == 1 then
											continue
										end

										break
									end
								end
							elseif exitTo2 == 1 then
								while true do
									vim1:SendKeyEvent(true, "Y", true, game)
									replicated.Remotes.CommF_:InvokeServer("UpgradeRace", "Buy", 2)
									vim1:SendKeyEvent(false, "Y", true, game)
									_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
									exitTo2 = nil
									exitTo5 = nil

									while true do
										callbackPlayerDataData += n8

										if not (n8 <= 0) then
											exitTo5 = 1

											break
										end

										if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
											break
										end

										Character = plr.Character

										if Character:FindFirstChild("RaceEnergy").Value == 1 then
											exitTo5 = 2

											break
										end

										Character2 = plr.Character

										if Character2:FindFirstChild("RaceTransformed").Value == false then
											callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

											if callbackPlayerDataCallbackReference then
												while true do
													wait()
													playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

													if _G.TrainDrago == false then
														break
													elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
														break
													end
												end
											else
												_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
											end
										end
									end

									if exitTo5 == 1 then
										if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
											exitTo19 = nil

											while true do
												Character = plr.Character

												if Character:FindFirstChild("RaceEnergy").Value == 1 then
													exitTo19 = 1

													break
												end

												Character2 = plr.Character

												if Character2:FindFirstChild("RaceTransformed").Value == false then
													callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

													if callbackPlayerDataCallbackReference then
														exitTo6 = nil

														while true do
															wait()
															playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

															if _G.TrainDrago == false then
																break
															elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																exitTo6 = 1

																break
															end
														end

														if exitTo6 == 1 then
															exitTo7 = nil

															while true do
																callbackPlayerDataData += n8

																if not (n8 <= 0) then
																	exitTo7 = 1

																	break
																end

																if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																	break
																end

																Character = plr.Character

																if Character:FindFirstChild("RaceEnergy").Value == 1 then
																	exitTo7 = 2

																	break
																end

																Character2 = plr.Character

																if Character2:FindFirstChild("RaceTransformed").Value == false then
																	callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																	if callbackPlayerDataCallbackReference then
																		while true do
																			wait()
																			playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																			if _G.TrainDrago == false then
																				break
																			elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																				break
																			end
																		end
																	else
																		_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																	end
																end
															end

															if exitTo7 == 1 then
																if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																	continue
																end

																exitTo19 = 8

																break
															end

															exitTo19 = 7

															break
														end

														exitTo8 = nil

														while true do
															callbackPlayerDataData += n8

															if not (n8 <= 0) then
																exitTo8 = 1

																break
															end

															if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																break
															end

															Character = plr.Character

															if Character:FindFirstChild("RaceEnergy").Value == 1 then
																exitTo8 = 2

																break
															end

															Character2 = plr.Character

															if Character2:FindFirstChild("RaceTransformed").Value == false then
																callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																if callbackPlayerDataCallbackReference then
																	while true do
																		wait()
																		playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																		if _G.TrainDrago == false then
																			break
																		elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																			break
																		end
																	end
																else
																	_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																end
															end
														end

														if exitTo8 == 1 then
															if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																continue
															end

															exitTo19 = 6

															break
														end

														exitTo19 = 5

														break
													end

													_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
													exitTo9 = nil

													while true do
														callbackPlayerDataData += n8

														if not (n8 <= 0) then
															exitTo9 = 1

															break
														end

														if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
															break
														end

														Character = plr.Character

														if Character:FindFirstChild("RaceEnergy").Value == 1 then
															exitTo9 = 2

															break
														end

														Character2 = plr.Character

														if Character2:FindFirstChild("RaceTransformed").Value == false then
															callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

															if callbackPlayerDataCallbackReference then
																while true do
																	wait()
																	playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																	if _G.TrainDrago == false then
																		break
																	elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																		break
																	end
																end
															else
																_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
															end
														end
													end

													if exitTo9 == 1 then
														if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
															continue
														end

														exitTo19 = 4

														break
													end

													exitTo19 = 3

													break
												end

												exitTo10 = nil

												while true do
													callbackPlayerDataData += n8

													if not (n8 <= 0) then
														exitTo10 = 1

														break
													end

													if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
														break
													end

													Character = plr.Character

													if Character:FindFirstChild("RaceEnergy").Value == 1 then
														exitTo10 = 2

														break
													end

													Character2 = plr.Character

													if Character2:FindFirstChild("RaceTransformed").Value == false then
														callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

														if callbackPlayerDataCallbackReference then
															while true do
																wait()
																playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																if _G.TrainDrago == false then
																	break
																elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																	break
																end
															end
														else
															_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
														end
													end
												end

												if exitTo10 == 1 then
													if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
														continue
													end

													exitTo19 = 2

													break
												end

												break
											end

											if exitTo19 == 1 then
												exitTo2 = 1

												if exitTo2 == 1 then
													continue
												end
											elseif exitTo19 == 2 then
												if exitTo2 == 1 then
													continue
												end
											elseif exitTo19 == 3 then
												if exitTo9 == 2 then
													exitTo2 = 1

													if exitTo2 == 1 then
														continue
													end
												elseif exitTo2 == 1 then
													continue
												end
											elseif exitTo19 == 4 then
												if exitTo2 == 1 then
													continue
												end
											elseif exitTo19 == 5 then
												if exitTo8 == 2 then
													exitTo2 = 1

													if exitTo2 == 1 then
														continue
													end
												elseif exitTo2 == 1 then
													continue
												end
											elseif exitTo19 == 6 then
												if exitTo2 == 1 then
													continue
												end
											elseif exitTo19 == 7 then
												if exitTo7 == 2 then
													exitTo2 = 1

													if exitTo2 == 1 then
														continue
													end
												elseif exitTo2 == 1 then
													continue
												end
											elseif exitTo19 == 8 then
												if exitTo2 == 1 then
													continue
												end
											elseif exitTo10 == 2 then
												exitTo2 = 1

												if exitTo2 == 1 then
													continue
												end
											elseif exitTo2 == 1 then
												continue
											end
										elseif exitTo2 == 1 then
											continue
										end
									elseif exitTo5 == 2 then
										exitTo2 = 1

										if exitTo2 == 1 then
											continue
										end
									elseif exitTo2 == 1 then
										continue
									end

									break
								end
							end
						elseif exitTo5 == 2 then
							exitTo2 = 1

							if exitTo2 == 1 then
								while true do
									vim1:SendKeyEvent(true, "Y", true, game)
									replicated.Remotes.CommF_:InvokeServer("UpgradeRace", "Buy", 2)
									vim1:SendKeyEvent(false, "Y", true, game)
									_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
									exitTo2 = nil
									exitTo5 = nil

									while true do
										callbackPlayerDataData += n8

										if not (n8 <= 0) then
											exitTo5 = 1

											break
										end

										if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
											break
										end

										Character = plr.Character

										if Character:FindFirstChild("RaceEnergy").Value == 1 then
											exitTo5 = 2

											break
										end

										Character2 = plr.Character

										if Character2:FindFirstChild("RaceTransformed").Value == false then
											callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

											if callbackPlayerDataCallbackReference then
												while true do
													wait()
													playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

													if _G.TrainDrago == false then
														break
													elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
														break
													end
												end
											else
												_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
											end
										end
									end

									if exitTo5 == 1 then
										if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
											exitTo19 = nil

											while true do
												Character = plr.Character

												if Character:FindFirstChild("RaceEnergy").Value == 1 then
													exitTo19 = 1

													break
												end

												Character2 = plr.Character

												if Character2:FindFirstChild("RaceTransformed").Value == false then
													callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

													if callbackPlayerDataCallbackReference then
														exitTo6 = nil

														while true do
															wait()
															playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

															if _G.TrainDrago == false then
																break
															elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																exitTo6 = 1

																break
															end
														end

														if exitTo6 == 1 then
															exitTo7 = nil

															while true do
																callbackPlayerDataData += n8

																if not (n8 <= 0) then
																	exitTo7 = 1

																	break
																end

																if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																	break
																end

																Character = plr.Character

																if Character:FindFirstChild("RaceEnergy").Value == 1 then
																	exitTo7 = 2

																	break
																end

																Character2 = plr.Character

																if Character2:FindFirstChild("RaceTransformed").Value == false then
																	callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																	if callbackPlayerDataCallbackReference then
																		while true do
																			wait()
																			playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																			if _G.TrainDrago == false then
																				break
																			elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																				break
																			end
																		end
																	else
																		_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																	end
																end
															end

															if exitTo7 == 1 then
																if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																	continue
																end

																exitTo19 = 8

																break
															end

															exitTo19 = 7

															break
														end

														exitTo8 = nil

														while true do
															callbackPlayerDataData += n8

															if not (n8 <= 0) then
																exitTo8 = 1

																break
															end

															if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																break
															end

															Character = plr.Character

															if Character:FindFirstChild("RaceEnergy").Value == 1 then
																exitTo8 = 2

																break
															end

															Character2 = plr.Character

															if Character2:FindFirstChild("RaceTransformed").Value == false then
																callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																if callbackPlayerDataCallbackReference then
																	while true do
																		wait()
																		playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																		if _G.TrainDrago == false then
																			break
																		elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																			break
																		end
																	end
																else
																	_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																end
															end
														end

														if exitTo8 == 1 then
															if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																continue
															end

															exitTo19 = 6

															break
														end

														exitTo19 = 5

														break
													end

													_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
													exitTo9 = nil

													while true do
														callbackPlayerDataData += n8

														if not (n8 <= 0) then
															exitTo9 = 1

															break
														end

														if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
															break
														end

														Character = plr.Character

														if Character:FindFirstChild("RaceEnergy").Value == 1 then
															exitTo9 = 2

															break
														end

														Character2 = plr.Character

														if Character2:FindFirstChild("RaceTransformed").Value == false then
															callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

															if callbackPlayerDataCallbackReference then
																while true do
																	wait()
																	playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																	if _G.TrainDrago == false then
																		break
																	elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																		break
																	end
																end
															else
																_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
															end
														end
													end

													if exitTo9 == 1 then
														if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
															continue
														end

														exitTo19 = 4

														break
													end

													exitTo19 = 3

													break
												end

												exitTo10 = nil

												while true do
													callbackPlayerDataData += n8

													if not (n8 <= 0) then
														exitTo10 = 1

														break
													end

													if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
														break
													end

													Character = plr.Character

													if Character:FindFirstChild("RaceEnergy").Value == 1 then
														exitTo10 = 2

														break
													end

													Character2 = plr.Character

													if Character2:FindFirstChild("RaceTransformed").Value == false then
														callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

														if callbackPlayerDataCallbackReference then
															while true do
																wait()
																playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																if _G.TrainDrago == false then
																	break
																elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																	break
																end
															end
														else
															_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
														end
													end
												end

												if exitTo10 == 1 then
													if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
														continue
													end

													exitTo19 = 2

													break
												end

												break
											end

											if exitTo19 == 1 then
												exitTo2 = 1

												if exitTo2 == 1 then
													continue
												end
											elseif exitTo19 == 2 then
												if exitTo2 == 1 then
													continue
												end
											elseif exitTo19 == 3 then
												if exitTo9 == 2 then
													exitTo2 = 1

													if exitTo2 == 1 then
														continue
													end
												elseif exitTo2 == 1 then
													continue
												end
											elseif exitTo19 == 4 then
												if exitTo2 == 1 then
													continue
												end
											elseif exitTo19 == 5 then
												if exitTo8 == 2 then
													exitTo2 = 1

													if exitTo2 == 1 then
														continue
													end
												elseif exitTo2 == 1 then
													continue
												end
											elseif exitTo19 == 6 then
												if exitTo2 == 1 then
													continue
												end
											elseif exitTo19 == 7 then
												if exitTo7 == 2 then
													exitTo2 = 1

													if exitTo2 == 1 then
														continue
													end
												elseif exitTo2 == 1 then
													continue
												end
											elseif exitTo19 == 8 then
												if exitTo2 == 1 then
													continue
												end
											elseif exitTo10 == 2 then
												exitTo2 = 1

												if exitTo2 == 1 then
													continue
												end
											elseif exitTo2 == 1 then
												continue
											end
										elseif exitTo2 == 1 then
											continue
										end
									elseif exitTo5 == 2 then
										exitTo2 = 1

										if exitTo2 == 1 then
											continue
										end
									elseif exitTo2 == 1 then
										continue
									end

									break
								end
							end
						elseif exitTo2 == 1 then
							while true do
								vim1:SendKeyEvent(true, "Y", true, game)
								replicated.Remotes.CommF_:InvokeServer("UpgradeRace", "Buy", 2)
								vim1:SendKeyEvent(false, "Y", true, game)
								_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
								exitTo2 = nil
								exitTo5 = nil

								while true do
									callbackPlayerDataData += n8

									if not (n8 <= 0) then
										exitTo5 = 1

										break
									end

									if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
										break
									end

									Character = plr.Character

									if Character:FindFirstChild("RaceEnergy").Value == 1 then
										exitTo5 = 2

										break
									end

									Character2 = plr.Character

									if Character2:FindFirstChild("RaceTransformed").Value == false then
										callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

										if callbackPlayerDataCallbackReference then
											while true do
												wait()
												playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

												if _G.TrainDrago == false then
													break
												elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
													break
												end
											end
										else
											_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
										end
									end
								end

								if exitTo5 == 1 then
									if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
										exitTo19 = nil

										while true do
											Character = plr.Character

											if Character:FindFirstChild("RaceEnergy").Value == 1 then
												exitTo19 = 1

												break
											end

											Character2 = plr.Character

											if Character2:FindFirstChild("RaceTransformed").Value == false then
												callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

												if callbackPlayerDataCallbackReference then
													exitTo6 = nil

													while true do
														wait()
														playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

														if _G.TrainDrago == false then
															break
														elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
															exitTo6 = 1

															break
														end
													end

													if exitTo6 == 1 then
														exitTo7 = nil

														while true do
															callbackPlayerDataData += n8

															if not (n8 <= 0) then
																exitTo7 = 1

																break
															end

															if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																break
															end

															Character = plr.Character

															if Character:FindFirstChild("RaceEnergy").Value == 1 then
																exitTo7 = 2

																break
															end

															Character2 = plr.Character

															if Character2:FindFirstChild("RaceTransformed").Value == false then
																callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																if callbackPlayerDataCallbackReference then
																	while true do
																		wait()
																		playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																		if _G.TrainDrago == false then
																			break
																		elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																			break
																		end
																	end
																else
																	_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																end
															end
														end

														if exitTo7 == 1 then
															if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																continue
															end

															exitTo19 = 8

															break
														end

														exitTo19 = 7

														break
													end

													exitTo8 = nil

													while true do
														callbackPlayerDataData += n8

														if not (n8 <= 0) then
															exitTo8 = 1

															break
														end

														if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
															break
														end

														Character = plr.Character

														if Character:FindFirstChild("RaceEnergy").Value == 1 then
															exitTo8 = 2

															break
														end

														Character2 = plr.Character

														if Character2:FindFirstChild("RaceTransformed").Value == false then
															callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

															if callbackPlayerDataCallbackReference then
																while true do
																	wait()
																	playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																	if _G.TrainDrago == false then
																		break
																	elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																		break
																	end
																end
															else
																_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
															end
														end
													end

													if exitTo8 == 1 then
														if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
															continue
														end

														exitTo19 = 6

														break
													end

													exitTo19 = 5

													break
												end

												_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
												exitTo9 = nil

												while true do
													callbackPlayerDataData += n8

													if not (n8 <= 0) then
														exitTo9 = 1

														break
													end

													if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
														break
													end

													Character = plr.Character

													if Character:FindFirstChild("RaceEnergy").Value == 1 then
														exitTo9 = 2

														break
													end

													Character2 = plr.Character

													if Character2:FindFirstChild("RaceTransformed").Value == false then
														callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

														if callbackPlayerDataCallbackReference then
															while true do
																wait()
																playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																if _G.TrainDrago == false then
																	break
																elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																	break
																end
															end
														else
															_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
														end
													end
												end

												if exitTo9 == 1 then
													if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
														continue
													end

													exitTo19 = 4

													break
												end

												exitTo19 = 3

												break
											end

											exitTo10 = nil

											while true do
												callbackPlayerDataData += n8

												if not (n8 <= 0) then
													exitTo10 = 1

													break
												end

												if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
													break
												end

												Character = plr.Character

												if Character:FindFirstChild("RaceEnergy").Value == 1 then
													exitTo10 = 2

													break
												end

												Character2 = plr.Character

												if Character2:FindFirstChild("RaceTransformed").Value == false then
													callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

													if callbackPlayerDataCallbackReference then
														while true do
															wait()
															playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

															if _G.TrainDrago == false then
																break
															elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																break
															end
														end
													else
														_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
													end
												end
											end

											if exitTo10 == 1 then
												if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
													continue
												end

												exitTo19 = 2

												break
											end

											break
										end

										if exitTo19 == 1 then
											exitTo2 = 1

											if exitTo2 == 1 then
												continue
											end
										elseif exitTo19 == 2 then
											if exitTo2 == 1 then
												continue
											end
										elseif exitTo19 == 3 then
											if exitTo9 == 2 then
												exitTo2 = 1

												if exitTo2 == 1 then
													continue
												end
											elseif exitTo2 == 1 then
												continue
											end
										elseif exitTo19 == 4 then
											if exitTo2 == 1 then
												continue
											end
										elseif exitTo19 == 5 then
											if exitTo8 == 2 then
												exitTo2 = 1

												if exitTo2 == 1 then
													continue
												end
											elseif exitTo2 == 1 then
												continue
											end
										elseif exitTo19 == 6 then
											if exitTo2 == 1 then
												continue
											end
										elseif exitTo19 == 7 then
											if exitTo7 == 2 then
												exitTo2 = 1

												if exitTo2 == 1 then
													continue
												end
											elseif exitTo2 == 1 then
												continue
											end
										elseif exitTo19 == 8 then
											if exitTo2 == 1 then
												continue
											end
										elseif exitTo10 == 2 then
											exitTo2 = 1

											if exitTo2 == 1 then
												continue
											end
										elseif exitTo2 == 1 then
											continue
										end
									elseif exitTo2 == 1 then
										continue
									end
								elseif exitTo5 == 2 then
									exitTo2 = 1

									if exitTo2 == 1 then
										continue
									end
								elseif exitTo2 == 1 then
									continue
								end

								break
							end
						end
					elseif exitTo == 2 then
						local exitTo4

						while true do
							_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))

							local exitTo3
							local exitTo11

							while true do
								callbackPlayerDataData += n8

								if not (n8 <= 0) then
									exitTo11 = 1

									break
								end

								if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
									break
								end

								Character = plr.Character

								if Character:FindFirstChild("RaceEnergy").Value == 1 then
									exitTo11 = 2

									break
								end

								Character2 = plr.Character

								if Character2:FindFirstChild("RaceTransformed").Value ~= false then
									continue
								end

								callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

								if not callbackPlayerDataCallbackReference then
									exitTo11 = 3

									break
								end

								while true do
									wait()
									playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

									if _G.TrainDrago == false then
										break
									elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
										break
									end
								end
							end

							if exitTo11 == 1 then
								if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
									while true do
										Character = plr.Character

										if Character:FindFirstChild("RaceEnergy").Value == 1 then
											exitTo3 = 1

											break
										end

										Character2 = plr.Character

										if Character2:FindFirstChild("RaceTransformed").Value == false then
											callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

											if not callbackPlayerDataCallbackReference then
												exitTo3 = 2

												break
											end

											local exitTo12

											while true do
												wait()
												playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

												if _G.TrainDrago == false then
													break
												elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
													exitTo12 = 1

													break
												end
											end

											if exitTo12 == 1 then
												local exitTo13

												while true do
													callbackPlayerDataData += n8

													if not (n8 <= 0) then
														exitTo13 = 1

														break
													end

													if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
														break
													end

													Character = plr.Character

													if Character:FindFirstChild("RaceEnergy").Value == 1 then
														exitTo13 = 2

														break
													end

													Character2 = plr.Character

													if Character2:FindFirstChild("RaceTransformed").Value ~= false then
														continue
													end

													callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

													if not callbackPlayerDataCallbackReference then
														exitTo13 = 3

														break
													end

													while true do
														wait()
														playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

														if _G.TrainDrago == false then
															break
														elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
															break
														end
													end
												end

												if exitTo13 == 1 then
													if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
														continue
													end
												else
													if exitTo13 == 2 then
														exitTo3 = 1
													elseif exitTo13 == 3 then
														exitTo3 = 2
													end

													break
												end
											else
												local exitTo14

												while true do
													callbackPlayerDataData += n8

													if not (n8 <= 0) then
														exitTo14 = 1

														break
													end

													if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
														break
													end

													Character = plr.Character

													if Character:FindFirstChild("RaceEnergy").Value == 1 then
														exitTo14 = 2

														break
													end

													Character2 = plr.Character

													if Character2:FindFirstChild("RaceTransformed").Value ~= false then
														continue
													end

													callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

													if not callbackPlayerDataCallbackReference then
														exitTo14 = 3

														break
													end

													while true do
														wait()
														playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

														if _G.TrainDrago == false then
															break
														elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
															break
														end
													end
												end

												if exitTo14 == 1 then
													if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
														continue
													end
												else
													if exitTo14 == 2 then
														exitTo3 = 1
													elseif exitTo14 == 3 then
														exitTo3 = 2
													end

													break
												end
											end
										else
											local exitTo15

											while true do
												callbackPlayerDataData += n8

												if not (n8 <= 0) then
													exitTo15 = 1

													break
												end

												if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
													break
												end

												Character = plr.Character

												if Character:FindFirstChild("RaceEnergy").Value == 1 then
													exitTo15 = 2

													break
												end

												Character2 = plr.Character

												if Character2:FindFirstChild("RaceTransformed").Value ~= false then
													continue
												end

												callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

												if not callbackPlayerDataCallbackReference then
													exitTo15 = 3

													break
												end

												while true do
													wait()
													playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

													if _G.TrainDrago == false then
														break
													elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
														break
													end
												end
											end

											if exitTo15 == 1 then
												if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
													continue
												end
											else
												if exitTo15 == 2 then
													exitTo3 = 1
												elseif exitTo15 == 3 then
													exitTo3 = 2
												end

												break
											end
										end

										break
									end
								end
							elseif exitTo11 == 2 then
								exitTo3 = 1
							elseif exitTo11 == 3 then
								exitTo3 = 2
							end

							if exitTo3 == 1 then
								exitTo4 = 1

								break
							elseif exitTo3 == 2 then
								continue
							end

							break
						end

						if exitTo4 == 1 then
							local exitTo17

							while true do
								vim1:SendKeyEvent(true, "Y", true, game)
								replicated.Remotes.CommF_:InvokeServer("UpgradeRace", "Buy", 2)
								vim1:SendKeyEvent(false, "Y", true, game)
								_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
								exitTo2 = nil

								local exitTo16

								while true do
									callbackPlayerDataData += n8

									if not (n8 <= 0) then
										exitTo16 = 1

										break
									end

									if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
										break
									end

									Character = plr.Character

									if Character:FindFirstChild("RaceEnergy").Value == 1 then
										exitTo16 = 2

										break
									end

									Character2 = plr.Character

									if Character2:FindFirstChild("RaceTransformed").Value == false then
										callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

										if callbackPlayerDataCallbackReference then
											while true do
												wait()
												playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

												if _G.TrainDrago == false then
													break
												elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
													break
												end
											end
										else
											_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
										end
									end
								end

								if exitTo16 ~= 1 then
									if exitTo16 == 2 then
										exitTo2 = 1
									end

									if exitTo2 ~= 1 then
										break
									end
								elseif callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
									exitTo17 = 1

									break
								elseif exitTo2 == 1 then
									continue
								end

								break
							end

							if exitTo17 == 1 then
								local exitTo20

								while true do
									Character = plr.Character

									if Character:FindFirstChild("RaceEnergy").Value == 1 then
										exitTo20 = 1

										break
									end

									Character2 = plr.Character

									if Character2:FindFirstChild("RaceTransformed").Value == false then
										callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

										if callbackPlayerDataCallbackReference then
											exitTo6 = nil

											while true do
												wait()
												playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

												if _G.TrainDrago == false then
													break
												elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
													exitTo6 = 1

													break
												end
											end

											if exitTo6 == 1 then
												exitTo7 = nil

												while true do
													callbackPlayerDataData += n8

													if not (n8 <= 0) then
														exitTo7 = 1

														break
													end

													if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
														break
													end

													Character = plr.Character

													if Character:FindFirstChild("RaceEnergy").Value == 1 then
														exitTo7 = 2

														break
													end

													Character2 = plr.Character

													if Character2:FindFirstChild("RaceTransformed").Value == false then
														callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

														if callbackPlayerDataCallbackReference then
															while true do
																wait()
																playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																if _G.TrainDrago == false then
																	break
																elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																	break
																end
															end
														else
															_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
														end
													end
												end

												if exitTo7 == 1 then
													if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
														continue
													end

													exitTo20 = 8

													break
												end

												exitTo20 = 7

												break
											end

											exitTo8 = nil

											while true do
												callbackPlayerDataData += n8

												if not (n8 <= 0) then
													exitTo8 = 1

													break
												end

												if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
													break
												end

												Character = plr.Character

												if Character:FindFirstChild("RaceEnergy").Value == 1 then
													exitTo8 = 2

													break
												end

												Character2 = plr.Character

												if Character2:FindFirstChild("RaceTransformed").Value == false then
													callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

													if callbackPlayerDataCallbackReference then
														while true do
															wait()
															playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

															if _G.TrainDrago == false then
																break
															elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																break
															end
														end
													else
														_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
													end
												end
											end

											if exitTo8 == 1 then
												if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
													continue
												end

												exitTo20 = 6

												break
											end

											exitTo20 = 5

											break
										end

										_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
										exitTo9 = nil

										while true do
											callbackPlayerDataData += n8

											if not (n8 <= 0) then
												exitTo9 = 1

												break
											end

											if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
												break
											end

											Character = plr.Character

											if Character:FindFirstChild("RaceEnergy").Value == 1 then
												exitTo9 = 2

												break
											end

											Character2 = plr.Character

											if Character2:FindFirstChild("RaceTransformed").Value == false then
												callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

												if callbackPlayerDataCallbackReference then
													while true do
														wait()
														playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

														if _G.TrainDrago == false then
															break
														elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
															break
														end
													end
												else
													_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
												end
											end
										end

										if exitTo9 == 1 then
											if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
												continue
											end

											exitTo20 = 4

											break
										end

										exitTo20 = 3

										break
									end

									exitTo10 = nil

									while true do
										callbackPlayerDataData += n8

										if not (n8 <= 0) then
											exitTo10 = 1

											break
										end

										if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
											break
										end

										Character = plr.Character

										if Character:FindFirstChild("RaceEnergy").Value == 1 then
											exitTo10 = 2

											break
										end

										Character2 = plr.Character

										if Character2:FindFirstChild("RaceTransformed").Value == false then
											callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

											if callbackPlayerDataCallbackReference then
												while true do
													wait()
													playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

													if _G.TrainDrago == false then
														break
													elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
														break
													end
												end
											else
												_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
											end
										end
									end

									if exitTo10 == 1 then
										if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
											continue
										end

										exitTo20 = 2

										break
									end

									break
								end

								if exitTo20 == 1 then
									exitTo2 = 1

									if exitTo2 == 1 then
										while true do
											vim1:SendKeyEvent(true, "Y", true, game)
											replicated.Remotes.CommF_:InvokeServer("UpgradeRace", "Buy", 2)
											vim1:SendKeyEvent(false, "Y", true, game)
											_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
											exitTo2 = nil
											exitTo5 = nil

											while true do
												callbackPlayerDataData += n8

												if not (n8 <= 0) then
													exitTo5 = 1

													break
												end

												if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
													break
												end

												Character = plr.Character

												if Character:FindFirstChild("RaceEnergy").Value == 1 then
													exitTo5 = 2

													break
												end

												Character2 = plr.Character

												if Character2:FindFirstChild("RaceTransformed").Value == false then
													callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

													if callbackPlayerDataCallbackReference then
														while true do
															wait()
															playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

															if _G.TrainDrago == false then
																break
															elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																break
															end
														end
													else
														_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
													end
												end
											end

											if exitTo5 == 1 then
												if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
													exitTo19 = nil

													while true do
														Character = plr.Character

														if Character:FindFirstChild("RaceEnergy").Value == 1 then
															exitTo19 = 1

															break
														end

														Character2 = plr.Character

														if Character2:FindFirstChild("RaceTransformed").Value == false then
															callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

															if callbackPlayerDataCallbackReference then
																exitTo6 = nil

																while true do
																	wait()
																	playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																	if _G.TrainDrago == false then
																		break
																	elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																		exitTo6 = 1

																		break
																	end
																end

																if exitTo6 == 1 then
																	exitTo7 = nil

																	while true do
																		callbackPlayerDataData += n8

																		if not (n8 <= 0) then
																			exitTo7 = 1

																			break
																		end

																		if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																			break
																		end

																		Character = plr.Character

																		if Character:FindFirstChild("RaceEnergy").Value == 1 then
																			exitTo7 = 2

																			break
																		end

																		Character2 = plr.Character

																		if Character2:FindFirstChild("RaceTransformed").Value == false then
																			callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																			if callbackPlayerDataCallbackReference then
																				while true do
																					wait()
																					playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																					if _G.TrainDrago == false then
																						break
																					elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																						break
																					end
																				end
																			else
																				_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																			end
																		end
																	end

																	if exitTo7 == 1 then
																		if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																			continue
																		end

																		exitTo19 = 8

																		break
																	end

																	exitTo19 = 7

																	break
																end

																exitTo8 = nil

																while true do
																	callbackPlayerDataData += n8

																	if not (n8 <= 0) then
																		exitTo8 = 1

																		break
																	end

																	if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																		break
																	end

																	Character = plr.Character

																	if Character:FindFirstChild("RaceEnergy").Value == 1 then
																		exitTo8 = 2

																		break
																	end

																	Character2 = plr.Character

																	if Character2:FindFirstChild("RaceTransformed").Value == false then
																		callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																		if callbackPlayerDataCallbackReference then
																			while true do
																				wait()
																				playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																				if _G.TrainDrago == false then
																					break
																				elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																					break
																				end
																			end
																		else
																			_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																		end
																	end
																end

																if exitTo8 == 1 then
																	if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																		continue
																	end

																	exitTo19 = 6

																	break
																end

																exitTo19 = 5

																break
															end

															_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
															exitTo9 = nil

															while true do
																callbackPlayerDataData += n8

																if not (n8 <= 0) then
																	exitTo9 = 1

																	break
																end

																if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																	break
																end

																Character = plr.Character

																if Character:FindFirstChild("RaceEnergy").Value == 1 then
																	exitTo9 = 2

																	break
																end

																Character2 = plr.Character

																if Character2:FindFirstChild("RaceTransformed").Value == false then
																	callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																	if callbackPlayerDataCallbackReference then
																		while true do
																			wait()
																			playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																			if _G.TrainDrago == false then
																				break
																			elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																				break
																			end
																		end
																	else
																		_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																	end
																end
															end

															if exitTo9 == 1 then
																if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																	continue
																end

																exitTo19 = 4

																break
															end

															exitTo19 = 3

															break
														end

														exitTo10 = nil

														while true do
															callbackPlayerDataData += n8

															if not (n8 <= 0) then
																exitTo10 = 1

																break
															end

															if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																break
															end

															Character = plr.Character

															if Character:FindFirstChild("RaceEnergy").Value == 1 then
																exitTo10 = 2

																break
															end

															Character2 = plr.Character

															if Character2:FindFirstChild("RaceTransformed").Value == false then
																callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																if callbackPlayerDataCallbackReference then
																	while true do
																		wait()
																		playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																		if _G.TrainDrago == false then
																			break
																		elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																			break
																		end
																	end
																else
																	_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																end
															end
														end

														if exitTo10 == 1 then
															if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																continue
															end

															exitTo19 = 2

															break
														end

														break
													end

													if exitTo19 == 1 then
														exitTo2 = 1

														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 2 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 3 then
														if exitTo9 == 2 then
															exitTo2 = 1

															if exitTo2 == 1 then
																continue
															end
														elseif exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 4 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 5 then
														if exitTo8 == 2 then
															exitTo2 = 1

															if exitTo2 == 1 then
																continue
															end
														elseif exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 6 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 7 then
														if exitTo7 == 2 then
															exitTo2 = 1

															if exitTo2 == 1 then
																continue
															end
														elseif exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 8 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo10 == 2 then
														exitTo2 = 1

														if exitTo2 == 1 then
															continue
														end
													elseif exitTo2 == 1 then
														continue
													end
												elseif exitTo2 == 1 then
													continue
												end
											elseif exitTo5 == 2 then
												exitTo2 = 1

												if exitTo2 == 1 then
													continue
												end
											elseif exitTo2 == 1 then
												continue
											end

											break
										end
									end
								elseif exitTo20 == 2 then
									if exitTo2 == 1 then
										while true do
											vim1:SendKeyEvent(true, "Y", true, game)
											replicated.Remotes.CommF_:InvokeServer("UpgradeRace", "Buy", 2)
											vim1:SendKeyEvent(false, "Y", true, game)
											_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
											exitTo2 = nil
											exitTo5 = nil

											while true do
												callbackPlayerDataData += n8

												if not (n8 <= 0) then
													exitTo5 = 1

													break
												end

												if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
													break
												end

												Character = plr.Character

												if Character:FindFirstChild("RaceEnergy").Value == 1 then
													exitTo5 = 2

													break
												end

												Character2 = plr.Character

												if Character2:FindFirstChild("RaceTransformed").Value == false then
													callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

													if callbackPlayerDataCallbackReference then
														while true do
															wait()
															playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

															if _G.TrainDrago == false then
																break
															elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																break
															end
														end
													else
														_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
													end
												end
											end

											if exitTo5 == 1 then
												if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
													exitTo19 = nil

													while true do
														Character = plr.Character

														if Character:FindFirstChild("RaceEnergy").Value == 1 then
															exitTo19 = 1

															break
														end

														Character2 = plr.Character

														if Character2:FindFirstChild("RaceTransformed").Value == false then
															callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

															if callbackPlayerDataCallbackReference then
																exitTo6 = nil

																while true do
																	wait()
																	playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																	if _G.TrainDrago == false then
																		break
																	elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																		exitTo6 = 1

																		break
																	end
																end

																if exitTo6 == 1 then
																	exitTo7 = nil

																	while true do
																		callbackPlayerDataData += n8

																		if not (n8 <= 0) then
																			exitTo7 = 1

																			break
																		end

																		if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																			break
																		end

																		Character = plr.Character

																		if Character:FindFirstChild("RaceEnergy").Value == 1 then
																			exitTo7 = 2

																			break
																		end

																		Character2 = plr.Character

																		if Character2:FindFirstChild("RaceTransformed").Value == false then
																			callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																			if callbackPlayerDataCallbackReference then
																				while true do
																					wait()
																					playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																					if _G.TrainDrago == false then
																						break
																					elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																						break
																					end
																				end
																			else
																				_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																			end
																		end
																	end

																	if exitTo7 == 1 then
																		if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																			continue
																		end

																		exitTo19 = 8

																		break
																	end

																	exitTo19 = 7

																	break
																end

																exitTo8 = nil

																while true do
																	callbackPlayerDataData += n8

																	if not (n8 <= 0) then
																		exitTo8 = 1

																		break
																	end

																	if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																		break
																	end

																	Character = plr.Character

																	if Character:FindFirstChild("RaceEnergy").Value == 1 then
																		exitTo8 = 2

																		break
																	end

																	Character2 = plr.Character

																	if Character2:FindFirstChild("RaceTransformed").Value == false then
																		callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																		if callbackPlayerDataCallbackReference then
																			while true do
																				wait()
																				playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																				if _G.TrainDrago == false then
																					break
																				elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																					break
																				end
																			end
																		else
																			_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																		end
																	end
																end

																if exitTo8 == 1 then
																	if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																		continue
																	end

																	exitTo19 = 6

																	break
																end

																exitTo19 = 5

																break
															end

															_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
															exitTo9 = nil

															while true do
																callbackPlayerDataData += n8

																if not (n8 <= 0) then
																	exitTo9 = 1

																	break
																end

																if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																	break
																end

																Character = plr.Character

																if Character:FindFirstChild("RaceEnergy").Value == 1 then
																	exitTo9 = 2

																	break
																end

																Character2 = plr.Character

																if Character2:FindFirstChild("RaceTransformed").Value == false then
																	callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																	if callbackPlayerDataCallbackReference then
																		while true do
																			wait()
																			playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																			if _G.TrainDrago == false then
																				break
																			elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																				break
																			end
																		end
																	else
																		_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																	end
																end
															end

															if exitTo9 == 1 then
																if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																	continue
																end

																exitTo19 = 4

																break
															end

															exitTo19 = 3

															break
														end

														exitTo10 = nil

														while true do
															callbackPlayerDataData += n8

															if not (n8 <= 0) then
																exitTo10 = 1

																break
															end

															if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																break
															end

															Character = plr.Character

															if Character:FindFirstChild("RaceEnergy").Value == 1 then
																exitTo10 = 2

																break
															end

															Character2 = plr.Character

															if Character2:FindFirstChild("RaceTransformed").Value == false then
																callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																if callbackPlayerDataCallbackReference then
																	while true do
																		wait()
																		playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																		if _G.TrainDrago == false then
																			break
																		elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																			break
																		end
																	end
																else
																	_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																end
															end
														end

														if exitTo10 == 1 then
															if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																continue
															end

															exitTo19 = 2

															break
														end

														break
													end

													if exitTo19 == 1 then
														exitTo2 = 1

														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 2 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 3 then
														if exitTo9 == 2 then
															exitTo2 = 1

															if exitTo2 == 1 then
																continue
															end
														elseif exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 4 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 5 then
														if exitTo8 == 2 then
															exitTo2 = 1

															if exitTo2 == 1 then
																continue
															end
														elseif exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 6 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 7 then
														if exitTo7 == 2 then
															exitTo2 = 1

															if exitTo2 == 1 then
																continue
															end
														elseif exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 8 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo10 == 2 then
														exitTo2 = 1

														if exitTo2 == 1 then
															continue
														end
													elseif exitTo2 == 1 then
														continue
													end
												elseif exitTo2 == 1 then
													continue
												end
											elseif exitTo5 == 2 then
												exitTo2 = 1

												if exitTo2 == 1 then
													continue
												end
											elseif exitTo2 == 1 then
												continue
											end

											break
										end
									end
								elseif exitTo20 == 3 then
									if exitTo9 == 2 then
										exitTo2 = 1

										if exitTo2 == 1 then
											while true do
												vim1:SendKeyEvent(true, "Y", true, game)
												replicated.Remotes.CommF_:InvokeServer("UpgradeRace", "Buy", 2)
												vim1:SendKeyEvent(false, "Y", true, game)
												_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
												exitTo2 = nil
												exitTo5 = nil

												while true do
													callbackPlayerDataData += n8

													if not (n8 <= 0) then
														exitTo5 = 1

														break
													end

													if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
														break
													end

													Character = plr.Character

													if Character:FindFirstChild("RaceEnergy").Value == 1 then
														exitTo5 = 2

														break
													end

													Character2 = plr.Character

													if Character2:FindFirstChild("RaceTransformed").Value == false then
														callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

														if callbackPlayerDataCallbackReference then
															while true do
																wait()
																playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																if _G.TrainDrago == false then
																	break
																elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																	break
																end
															end
														else
															_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
														end
													end
												end

												if exitTo5 == 1 then
													if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
														exitTo19 = nil

														while true do
															Character = plr.Character

															if Character:FindFirstChild("RaceEnergy").Value == 1 then
																exitTo19 = 1

																break
															end

															Character2 = plr.Character

															if Character2:FindFirstChild("RaceTransformed").Value == false then
																callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																if callbackPlayerDataCallbackReference then
																	exitTo6 = nil

																	while true do
																		wait()
																		playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																		if _G.TrainDrago == false then
																			break
																		elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																			exitTo6 = 1

																			break
																		end
																	end

																	if exitTo6 == 1 then
																		exitTo7 = nil

																		while true do
																			callbackPlayerDataData += n8

																			if not (n8 <= 0) then
																				exitTo7 = 1

																				break
																			end

																			if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																				break
																			end

																			Character = plr.Character

																			if Character:FindFirstChild("RaceEnergy").Value == 1 then
																				exitTo7 = 2

																				break
																			end

																			Character2 = plr.Character

																			if Character2:FindFirstChild("RaceTransformed").Value == false then
																				callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																				if callbackPlayerDataCallbackReference then
																					while true do
																						wait()
																						playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																						if _G.TrainDrago == false then
																							break
																						elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																							break
																						end
																					end
																				else
																					_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																				end
																			end
																		end

																		if exitTo7 == 1 then
																			if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																				continue
																			end

																			exitTo19 = 8

																			break
																		end

																		exitTo19 = 7

																		break
																	end

																	exitTo8 = nil

																	while true do
																		callbackPlayerDataData += n8

																		if not (n8 <= 0) then
																			exitTo8 = 1

																			break
																		end

																		if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																			break
																		end

																		Character = plr.Character

																		if Character:FindFirstChild("RaceEnergy").Value == 1 then
																			exitTo8 = 2

																			break
																		end

																		Character2 = plr.Character

																		if Character2:FindFirstChild("RaceTransformed").Value == false then
																			callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																			if callbackPlayerDataCallbackReference then
																				while true do
																					wait()
																					playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																					if _G.TrainDrago == false then
																						break
																					elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																						break
																					end
																				end
																			else
																				_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																			end
																		end
																	end

																	if exitTo8 == 1 then
																		if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																			continue
																		end

																		exitTo19 = 6

																		break
																	end

																	exitTo19 = 5

																	break
																end

																_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																exitTo9 = nil

																while true do
																	callbackPlayerDataData += n8

																	if not (n8 <= 0) then
																		exitTo9 = 1

																		break
																	end

																	if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																		break
																	end

																	Character = plr.Character

																	if Character:FindFirstChild("RaceEnergy").Value == 1 then
																		exitTo9 = 2

																		break
																	end

																	Character2 = plr.Character

																	if Character2:FindFirstChild("RaceTransformed").Value == false then
																		callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																		if callbackPlayerDataCallbackReference then
																			while true do
																				wait()
																				playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																				if _G.TrainDrago == false then
																					break
																				elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																					break
																				end
																			end
																		else
																			_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																		end
																	end
																end

																if exitTo9 == 1 then
																	if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																		continue
																	end

																	exitTo19 = 4

																	break
																end

																exitTo19 = 3

																break
															end

															exitTo10 = nil

															while true do
																callbackPlayerDataData += n8

																if not (n8 <= 0) then
																	exitTo10 = 1

																	break
																end

																if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																	break
																end

																Character = plr.Character

																if Character:FindFirstChild("RaceEnergy").Value == 1 then
																	exitTo10 = 2

																	break
																end

																Character2 = plr.Character

																if Character2:FindFirstChild("RaceTransformed").Value == false then
																	callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																	if callbackPlayerDataCallbackReference then
																		while true do
																			wait()
																			playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																			if _G.TrainDrago == false then
																				break
																			elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																				break
																			end
																		end
																	else
																		_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																	end
																end
															end

															if exitTo10 == 1 then
																if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																	continue
																end

																exitTo19 = 2

																break
															end

															break
														end

														if exitTo19 == 1 then
															exitTo2 = 1

															if exitTo2 == 1 then
																continue
															end
														elseif exitTo19 == 2 then
															if exitTo2 == 1 then
																continue
															end
														elseif exitTo19 == 3 then
															if exitTo9 == 2 then
																exitTo2 = 1

																if exitTo2 == 1 then
																	continue
																end
															elseif exitTo2 == 1 then
																continue
															end
														elseif exitTo19 == 4 then
															if exitTo2 == 1 then
																continue
															end
														elseif exitTo19 == 5 then
															if exitTo8 == 2 then
																exitTo2 = 1

																if exitTo2 == 1 then
																	continue
																end
															elseif exitTo2 == 1 then
																continue
															end
														elseif exitTo19 == 6 then
															if exitTo2 == 1 then
																continue
															end
														elseif exitTo19 == 7 then
															if exitTo7 == 2 then
																exitTo2 = 1

																if exitTo2 == 1 then
																	continue
																end
															elseif exitTo2 == 1 then
																continue
															end
														elseif exitTo19 == 8 then
															if exitTo2 == 1 then
																continue
															end
														elseif exitTo10 == 2 then
															exitTo2 = 1

															if exitTo2 == 1 then
																continue
															end
														elseif exitTo2 == 1 then
															continue
														end
													elseif exitTo2 == 1 then
														continue
													end
												elseif exitTo5 == 2 then
													exitTo2 = 1

													if exitTo2 == 1 then
														continue
													end
												elseif exitTo2 == 1 then
													continue
												end

												break
											end
										end
									elseif exitTo2 == 1 then
										while true do
											vim1:SendKeyEvent(true, "Y", true, game)
											replicated.Remotes.CommF_:InvokeServer("UpgradeRace", "Buy", 2)
											vim1:SendKeyEvent(false, "Y", true, game)
											_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
											exitTo2 = nil
											exitTo5 = nil

											while true do
												callbackPlayerDataData += n8

												if not (n8 <= 0) then
													exitTo5 = 1

													break
												end

												if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
													break
												end

												Character = plr.Character

												if Character:FindFirstChild("RaceEnergy").Value == 1 then
													exitTo5 = 2

													break
												end

												Character2 = plr.Character

												if Character2:FindFirstChild("RaceTransformed").Value == false then
													callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

													if callbackPlayerDataCallbackReference then
														while true do
															wait()
															playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

															if _G.TrainDrago == false then
																break
															elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																break
															end
														end
													else
														_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
													end
												end
											end

											if exitTo5 == 1 then
												if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
													exitTo19 = nil

													while true do
														Character = plr.Character

														if Character:FindFirstChild("RaceEnergy").Value == 1 then
															exitTo19 = 1

															break
														end

														Character2 = plr.Character

														if Character2:FindFirstChild("RaceTransformed").Value == false then
															callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

															if callbackPlayerDataCallbackReference then
																exitTo6 = nil

																while true do
																	wait()
																	playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																	if _G.TrainDrago == false then
																		break
																	elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																		exitTo6 = 1

																		break
																	end
																end

																if exitTo6 == 1 then
																	exitTo7 = nil

																	while true do
																		callbackPlayerDataData += n8

																		if not (n8 <= 0) then
																			exitTo7 = 1

																			break
																		end

																		if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																			break
																		end

																		Character = plr.Character

																		if Character:FindFirstChild("RaceEnergy").Value == 1 then
																			exitTo7 = 2

																			break
																		end

																		Character2 = plr.Character

																		if Character2:FindFirstChild("RaceTransformed").Value == false then
																			callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																			if callbackPlayerDataCallbackReference then
																				while true do
																					wait()
																					playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																					if _G.TrainDrago == false then
																						break
																					elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																						break
																					end
																				end
																			else
																				_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																			end
																		end
																	end

																	if exitTo7 == 1 then
																		if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																			continue
																		end

																		exitTo19 = 8

																		break
																	end

																	exitTo19 = 7

																	break
																end

																exitTo8 = nil

																while true do
																	callbackPlayerDataData += n8

																	if not (n8 <= 0) then
																		exitTo8 = 1

																		break
																	end

																	if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																		break
																	end

																	Character = plr.Character

																	if Character:FindFirstChild("RaceEnergy").Value == 1 then
																		exitTo8 = 2

																		break
																	end

																	Character2 = plr.Character

																	if Character2:FindFirstChild("RaceTransformed").Value == false then
																		callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																		if callbackPlayerDataCallbackReference then
																			while true do
																				wait()
																				playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																				if _G.TrainDrago == false then
																					break
																				elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																					break
																				end
																			end
																		else
																			_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																		end
																	end
																end

																if exitTo8 == 1 then
																	if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																		continue
																	end

																	exitTo19 = 6

																	break
																end

																exitTo19 = 5

																break
															end

															_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
															exitTo9 = nil

															while true do
																callbackPlayerDataData += n8

																if not (n8 <= 0) then
																	exitTo9 = 1

																	break
																end

																if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																	break
																end

																Character = plr.Character

																if Character:FindFirstChild("RaceEnergy").Value == 1 then
																	exitTo9 = 2

																	break
																end

																Character2 = plr.Character

																if Character2:FindFirstChild("RaceTransformed").Value == false then
																	callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																	if callbackPlayerDataCallbackReference then
																		while true do
																			wait()
																			playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																			if _G.TrainDrago == false then
																				break
																			elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																				break
																			end
																		end
																	else
																		_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																	end
																end
															end

															if exitTo9 == 1 then
																if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																	continue
																end

																exitTo19 = 4

																break
															end

															exitTo19 = 3

															break
														end

														exitTo10 = nil

														while true do
															callbackPlayerDataData += n8

															if not (n8 <= 0) then
																exitTo10 = 1

																break
															end

															if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																break
															end

															Character = plr.Character

															if Character:FindFirstChild("RaceEnergy").Value == 1 then
																exitTo10 = 2

																break
															end

															Character2 = plr.Character

															if Character2:FindFirstChild("RaceTransformed").Value == false then
																callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																if callbackPlayerDataCallbackReference then
																	while true do
																		wait()
																		playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																		if _G.TrainDrago == false then
																			break
																		elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																			break
																		end
																	end
																else
																	_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																end
															end
														end

														if exitTo10 == 1 then
															if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																continue
															end

															exitTo19 = 2

															break
														end

														break
													end

													if exitTo19 == 1 then
														exitTo2 = 1

														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 2 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 3 then
														if exitTo9 == 2 then
															exitTo2 = 1

															if exitTo2 == 1 then
																continue
															end
														elseif exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 4 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 5 then
														if exitTo8 == 2 then
															exitTo2 = 1

															if exitTo2 == 1 then
																continue
															end
														elseif exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 6 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 7 then
														if exitTo7 == 2 then
															exitTo2 = 1

															if exitTo2 == 1 then
																continue
															end
														elseif exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 8 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo10 == 2 then
														exitTo2 = 1

														if exitTo2 == 1 then
															continue
														end
													elseif exitTo2 == 1 then
														continue
													end
												elseif exitTo2 == 1 then
													continue
												end
											elseif exitTo5 == 2 then
												exitTo2 = 1

												if exitTo2 == 1 then
													continue
												end
											elseif exitTo2 == 1 then
												continue
											end

											break
										end
									end
								elseif exitTo20 == 4 then
									if exitTo2 == 1 then
										while true do
											vim1:SendKeyEvent(true, "Y", true, game)
											replicated.Remotes.CommF_:InvokeServer("UpgradeRace", "Buy", 2)
											vim1:SendKeyEvent(false, "Y", true, game)
											_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
											exitTo2 = nil
											exitTo5 = nil

											while true do
												callbackPlayerDataData += n8

												if not (n8 <= 0) then
													exitTo5 = 1

													break
												end

												if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
													break
												end

												Character = plr.Character

												if Character:FindFirstChild("RaceEnergy").Value == 1 then
													exitTo5 = 2

													break
												end

												Character2 = plr.Character

												if Character2:FindFirstChild("RaceTransformed").Value == false then
													callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

													if callbackPlayerDataCallbackReference then
														while true do
															wait()
															playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

															if _G.TrainDrago == false then
																break
															elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																break
															end
														end
													else
														_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
													end
												end
											end

											if exitTo5 == 1 then
												if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
													exitTo19 = nil

													while true do
														Character = plr.Character

														if Character:FindFirstChild("RaceEnergy").Value == 1 then
															exitTo19 = 1

															break
														end

														Character2 = plr.Character

														if Character2:FindFirstChild("RaceTransformed").Value == false then
															callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

															if callbackPlayerDataCallbackReference then
																exitTo6 = nil

																while true do
																	wait()
																	playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																	if _G.TrainDrago == false then
																		break
																	elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																		exitTo6 = 1

																		break
																	end
																end

																if exitTo6 == 1 then
																	exitTo7 = nil

																	while true do
																		callbackPlayerDataData += n8

																		if not (n8 <= 0) then
																			exitTo7 = 1

																			break
																		end

																		if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																			break
																		end

																		Character = plr.Character

																		if Character:FindFirstChild("RaceEnergy").Value == 1 then
																			exitTo7 = 2

																			break
																		end

																		Character2 = plr.Character

																		if Character2:FindFirstChild("RaceTransformed").Value == false then
																			callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																			if callbackPlayerDataCallbackReference then
																				while true do
																					wait()
																					playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																					if _G.TrainDrago == false then
																						break
																					elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																						break
																					end
																				end
																			else
																				_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																			end
																		end
																	end

																	if exitTo7 == 1 then
																		if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																			continue
																		end

																		exitTo19 = 8

																		break
																	end

																	exitTo19 = 7

																	break
																end

																exitTo8 = nil

																while true do
																	callbackPlayerDataData += n8

																	if not (n8 <= 0) then
																		exitTo8 = 1

																		break
																	end

																	if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																		break
																	end

																	Character = plr.Character

																	if Character:FindFirstChild("RaceEnergy").Value == 1 then
																		exitTo8 = 2

																		break
																	end

																	Character2 = plr.Character

																	if Character2:FindFirstChild("RaceTransformed").Value == false then
																		callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																		if callbackPlayerDataCallbackReference then
																			while true do
																				wait()
																				playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																				if _G.TrainDrago == false then
																					break
																				elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																					break
																				end
																			end
																		else
																			_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																		end
																	end
																end

																if exitTo8 == 1 then
																	if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																		continue
																	end

																	exitTo19 = 6

																	break
																end

																exitTo19 = 5

																break
															end

															_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
															exitTo9 = nil

															while true do
																callbackPlayerDataData += n8

																if not (n8 <= 0) then
																	exitTo9 = 1

																	break
																end

																if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																	break
																end

																Character = plr.Character

																if Character:FindFirstChild("RaceEnergy").Value == 1 then
																	exitTo9 = 2

																	break
																end

																Character2 = plr.Character

																if Character2:FindFirstChild("RaceTransformed").Value == false then
																	callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																	if callbackPlayerDataCallbackReference then
																		while true do
																			wait()
																			playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																			if _G.TrainDrago == false then
																				break
																			elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																				break
																			end
																		end
																	else
																		_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																	end
																end
															end

															if exitTo9 == 1 then
																if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																	continue
																end

																exitTo19 = 4

																break
															end

															exitTo19 = 3

															break
														end

														exitTo10 = nil

														while true do
															callbackPlayerDataData += n8

															if not (n8 <= 0) then
																exitTo10 = 1

																break
															end

															if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																break
															end

															Character = plr.Character

															if Character:FindFirstChild("RaceEnergy").Value == 1 then
																exitTo10 = 2

																break
															end

															Character2 = plr.Character

															if Character2:FindFirstChild("RaceTransformed").Value == false then
																callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																if callbackPlayerDataCallbackReference then
																	while true do
																		wait()
																		playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																		if _G.TrainDrago == false then
																			break
																		elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																			break
																		end
																	end
																else
																	_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																end
															end
														end

														if exitTo10 == 1 then
															if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																continue
															end

															exitTo19 = 2

															break
														end

														break
													end

													if exitTo19 == 1 then
														exitTo2 = 1

														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 2 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 3 then
														if exitTo9 == 2 then
															exitTo2 = 1

															if exitTo2 == 1 then
																continue
															end
														elseif exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 4 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 5 then
														if exitTo8 == 2 then
															exitTo2 = 1

															if exitTo2 == 1 then
																continue
															end
														elseif exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 6 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 7 then
														if exitTo7 == 2 then
															exitTo2 = 1

															if exitTo2 == 1 then
																continue
															end
														elseif exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 8 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo10 == 2 then
														exitTo2 = 1

														if exitTo2 == 1 then
															continue
														end
													elseif exitTo2 == 1 then
														continue
													end
												elseif exitTo2 == 1 then
													continue
												end
											elseif exitTo5 == 2 then
												exitTo2 = 1

												if exitTo2 == 1 then
													continue
												end
											elseif exitTo2 == 1 then
												continue
											end

											break
										end
									end
								elseif exitTo20 == 5 then
									if exitTo8 == 2 then
										exitTo2 = 1

										if exitTo2 == 1 then
											while true do
												vim1:SendKeyEvent(true, "Y", true, game)
												replicated.Remotes.CommF_:InvokeServer("UpgradeRace", "Buy", 2)
												vim1:SendKeyEvent(false, "Y", true, game)
												_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
												exitTo2 = nil
												exitTo5 = nil

												while true do
													callbackPlayerDataData += n8

													if not (n8 <= 0) then
														exitTo5 = 1

														break
													end

													if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
														break
													end

													Character = plr.Character

													if Character:FindFirstChild("RaceEnergy").Value == 1 then
														exitTo5 = 2

														break
													end

													Character2 = plr.Character

													if Character2:FindFirstChild("RaceTransformed").Value == false then
														callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

														if callbackPlayerDataCallbackReference then
															while true do
																wait()
																playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																if _G.TrainDrago == false then
																	break
																elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																	break
																end
															end
														else
															_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
														end
													end
												end

												if exitTo5 == 1 then
													if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
														exitTo19 = nil

														while true do
															Character = plr.Character

															if Character:FindFirstChild("RaceEnergy").Value == 1 then
																exitTo19 = 1

																break
															end

															Character2 = plr.Character

															if Character2:FindFirstChild("RaceTransformed").Value == false then
																callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																if callbackPlayerDataCallbackReference then
																	exitTo6 = nil

																	while true do
																		wait()
																		playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																		if _G.TrainDrago == false then
																			break
																		elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																			exitTo6 = 1

																			break
																		end
																	end

																	if exitTo6 == 1 then
																		exitTo7 = nil

																		while true do
																			callbackPlayerDataData += n8

																			if not (n8 <= 0) then
																				exitTo7 = 1

																				break
																			end

																			if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																				break
																			end

																			Character = plr.Character

																			if Character:FindFirstChild("RaceEnergy").Value == 1 then
																				exitTo7 = 2

																				break
																			end

																			Character2 = plr.Character

																			if Character2:FindFirstChild("RaceTransformed").Value == false then
																				callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																				if callbackPlayerDataCallbackReference then
																					while true do
																						wait()
																						playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																						if _G.TrainDrago == false then
																							break
																						elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																							break
																						end
																					end
																				else
																					_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																				end
																			end
																		end

																		if exitTo7 == 1 then
																			if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																				continue
																			end

																			exitTo19 = 8

																			break
																		end

																		exitTo19 = 7

																		break
																	end

																	exitTo8 = nil

																	while true do
																		callbackPlayerDataData += n8

																		if not (n8 <= 0) then
																			exitTo8 = 1

																			break
																		end

																		if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																			break
																		end

																		Character = plr.Character

																		if Character:FindFirstChild("RaceEnergy").Value == 1 then
																			exitTo8 = 2

																			break
																		end

																		Character2 = plr.Character

																		if Character2:FindFirstChild("RaceTransformed").Value == false then
																			callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																			if callbackPlayerDataCallbackReference then
																				while true do
																					wait()
																					playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																					if _G.TrainDrago == false then
																						break
																					elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																						break
																					end
																				end
																			else
																				_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																			end
																		end
																	end

																	if exitTo8 == 1 then
																		if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																			continue
																		end

																		exitTo19 = 6

																		break
																	end

																	exitTo19 = 5

																	break
																end

																_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																exitTo9 = nil

																while true do
																	callbackPlayerDataData += n8

																	if not (n8 <= 0) then
																		exitTo9 = 1

																		break
																	end

																	if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																		break
																	end

																	Character = plr.Character

																	if Character:FindFirstChild("RaceEnergy").Value == 1 then
																		exitTo9 = 2

																		break
																	end

																	Character2 = plr.Character

																	if Character2:FindFirstChild("RaceTransformed").Value == false then
																		callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																		if callbackPlayerDataCallbackReference then
																			while true do
																				wait()
																				playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																				if _G.TrainDrago == false then
																					break
																				elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																					break
																				end
																			end
																		else
																			_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																		end
																	end
																end

																if exitTo9 == 1 then
																	if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																		continue
																	end

																	exitTo19 = 4

																	break
																end

																exitTo19 = 3

																break
															end

															exitTo10 = nil

															while true do
																callbackPlayerDataData += n8

																if not (n8 <= 0) then
																	exitTo10 = 1

																	break
																end

																if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																	break
																end

																Character = plr.Character

																if Character:FindFirstChild("RaceEnergy").Value == 1 then
																	exitTo10 = 2

																	break
																end

																Character2 = plr.Character

																if Character2:FindFirstChild("RaceTransformed").Value == false then
																	callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																	if callbackPlayerDataCallbackReference then
																		while true do
																			wait()
																			playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																			if _G.TrainDrago == false then
																				break
																			elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																				break
																			end
																		end
																	else
																		_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																	end
																end
															end

															if exitTo10 == 1 then
																if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																	continue
																end

																exitTo19 = 2

																break
															end

															break
														end

														if exitTo19 == 1 then
															exitTo2 = 1

															if exitTo2 == 1 then
																continue
															end
														elseif exitTo19 == 2 then
															if exitTo2 == 1 then
																continue
															end
														elseif exitTo19 == 3 then
															if exitTo9 == 2 then
																exitTo2 = 1

																if exitTo2 == 1 then
																	continue
																end
															elseif exitTo2 == 1 then
																continue
															end
														elseif exitTo19 == 4 then
															if exitTo2 == 1 then
																continue
															end
														elseif exitTo19 == 5 then
															if exitTo8 == 2 then
																exitTo2 = 1

																if exitTo2 == 1 then
																	continue
																end
															elseif exitTo2 == 1 then
																continue
															end
														elseif exitTo19 == 6 then
															if exitTo2 == 1 then
																continue
															end
														elseif exitTo19 == 7 then
															if exitTo7 == 2 then
																exitTo2 = 1

																if exitTo2 == 1 then
																	continue
																end
															elseif exitTo2 == 1 then
																continue
															end
														elseif exitTo19 == 8 then
															if exitTo2 == 1 then
																continue
															end
														elseif exitTo10 == 2 then
															exitTo2 = 1

															if exitTo2 == 1 then
																continue
															end
														elseif exitTo2 == 1 then
															continue
														end
													elseif exitTo2 == 1 then
														continue
													end
												elseif exitTo5 == 2 then
													exitTo2 = 1

													if exitTo2 == 1 then
														continue
													end
												elseif exitTo2 == 1 then
													continue
												end

												break
											end
										end
									elseif exitTo2 == 1 then
										while true do
											vim1:SendKeyEvent(true, "Y", true, game)
											replicated.Remotes.CommF_:InvokeServer("UpgradeRace", "Buy", 2)
											vim1:SendKeyEvent(false, "Y", true, game)
											_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
											exitTo2 = nil
											exitTo5 = nil

											while true do
												callbackPlayerDataData += n8

												if not (n8 <= 0) then
													exitTo5 = 1

													break
												end

												if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
													break
												end

												Character = plr.Character

												if Character:FindFirstChild("RaceEnergy").Value == 1 then
													exitTo5 = 2

													break
												end

												Character2 = plr.Character

												if Character2:FindFirstChild("RaceTransformed").Value == false then
													callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

													if callbackPlayerDataCallbackReference then
														while true do
															wait()
															playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

															if _G.TrainDrago == false then
																break
															elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																break
															end
														end
													else
														_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
													end
												end
											end

											if exitTo5 == 1 then
												if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
													exitTo19 = nil

													while true do
														Character = plr.Character

														if Character:FindFirstChild("RaceEnergy").Value == 1 then
															exitTo19 = 1

															break
														end

														Character2 = plr.Character

														if Character2:FindFirstChild("RaceTransformed").Value == false then
															callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

															if callbackPlayerDataCallbackReference then
																exitTo6 = nil

																while true do
																	wait()
																	playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																	if _G.TrainDrago == false then
																		break
																	elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																		exitTo6 = 1

																		break
																	end
																end

																if exitTo6 == 1 then
																	exitTo7 = nil

																	while true do
																		callbackPlayerDataData += n8

																		if not (n8 <= 0) then
																			exitTo7 = 1

																			break
																		end

																		if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																			break
																		end

																		Character = plr.Character

																		if Character:FindFirstChild("RaceEnergy").Value == 1 then
																			exitTo7 = 2

																			break
																		end

																		Character2 = plr.Character

																		if Character2:FindFirstChild("RaceTransformed").Value == false then
																			callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																			if callbackPlayerDataCallbackReference then
																				while true do
																					wait()
																					playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																					if _G.TrainDrago == false then
																						break
																					elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																						break
																					end
																				end
																			else
																				_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																			end
																		end
																	end

																	if exitTo7 == 1 then
																		if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																			continue
																		end

																		exitTo19 = 8

																		break
																	end

																	exitTo19 = 7

																	break
																end

																exitTo8 = nil

																while true do
																	callbackPlayerDataData += n8

																	if not (n8 <= 0) then
																		exitTo8 = 1

																		break
																	end

																	if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																		break
																	end

																	Character = plr.Character

																	if Character:FindFirstChild("RaceEnergy").Value == 1 then
																		exitTo8 = 2

																		break
																	end

																	Character2 = plr.Character

																	if Character2:FindFirstChild("RaceTransformed").Value == false then
																		callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																		if callbackPlayerDataCallbackReference then
																			while true do
																				wait()
																				playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																				if _G.TrainDrago == false then
																					break
																				elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																					break
																				end
																			end
																		else
																			_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																		end
																	end
																end

																if exitTo8 == 1 then
																	if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																		continue
																	end

																	exitTo19 = 6

																	break
																end

																exitTo19 = 5

																break
															end

															_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
															exitTo9 = nil

															while true do
																callbackPlayerDataData += n8

																if not (n8 <= 0) then
																	exitTo9 = 1

																	break
																end

																if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																	break
																end

																Character = plr.Character

																if Character:FindFirstChild("RaceEnergy").Value == 1 then
																	exitTo9 = 2

																	break
																end

																Character2 = plr.Character

																if Character2:FindFirstChild("RaceTransformed").Value == false then
																	callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																	if callbackPlayerDataCallbackReference then
																		while true do
																			wait()
																			playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																			if _G.TrainDrago == false then
																				break
																			elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																				break
																			end
																		end
																	else
																		_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																	end
																end
															end

															if exitTo9 == 1 then
																if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																	continue
																end

																exitTo19 = 4

																break
															end

															exitTo19 = 3

															break
														end

														exitTo10 = nil

														while true do
															callbackPlayerDataData += n8

															if not (n8 <= 0) then
																exitTo10 = 1

																break
															end

															if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																break
															end

															Character = plr.Character

															if Character:FindFirstChild("RaceEnergy").Value == 1 then
																exitTo10 = 2

																break
															end

															Character2 = plr.Character

															if Character2:FindFirstChild("RaceTransformed").Value == false then
																callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																if callbackPlayerDataCallbackReference then
																	while true do
																		wait()
																		playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																		if _G.TrainDrago == false then
																			break
																		elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																			break
																		end
																	end
																else
																	_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																end
															end
														end

														if exitTo10 == 1 then
															if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																continue
															end

															exitTo19 = 2

															break
														end

														break
													end

													if exitTo19 == 1 then
														exitTo2 = 1

														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 2 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 3 then
														if exitTo9 == 2 then
															exitTo2 = 1

															if exitTo2 == 1 then
																continue
															end
														elseif exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 4 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 5 then
														if exitTo8 == 2 then
															exitTo2 = 1

															if exitTo2 == 1 then
																continue
															end
														elseif exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 6 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 7 then
														if exitTo7 == 2 then
															exitTo2 = 1

															if exitTo2 == 1 then
																continue
															end
														elseif exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 8 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo10 == 2 then
														exitTo2 = 1

														if exitTo2 == 1 then
															continue
														end
													elseif exitTo2 == 1 then
														continue
													end
												elseif exitTo2 == 1 then
													continue
												end
											elseif exitTo5 == 2 then
												exitTo2 = 1

												if exitTo2 == 1 then
													continue
												end
											elseif exitTo2 == 1 then
												continue
											end

											break
										end
									end
								elseif exitTo20 == 6 then
									if exitTo2 == 1 then
										while true do
											vim1:SendKeyEvent(true, "Y", true, game)
											replicated.Remotes.CommF_:InvokeServer("UpgradeRace", "Buy", 2)
											vim1:SendKeyEvent(false, "Y", true, game)
											_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
											exitTo2 = nil
											exitTo5 = nil

											while true do
												callbackPlayerDataData += n8

												if not (n8 <= 0) then
													exitTo5 = 1

													break
												end

												if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
													break
												end

												Character = plr.Character

												if Character:FindFirstChild("RaceEnergy").Value == 1 then
													exitTo5 = 2

													break
												end

												Character2 = plr.Character

												if Character2:FindFirstChild("RaceTransformed").Value == false then
													callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

													if callbackPlayerDataCallbackReference then
														while true do
															wait()
															playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

															if _G.TrainDrago == false then
																break
															elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																break
															end
														end
													else
														_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
													end
												end
											end

											if exitTo5 == 1 then
												if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
													exitTo19 = nil

													while true do
														Character = plr.Character

														if Character:FindFirstChild("RaceEnergy").Value == 1 then
															exitTo19 = 1

															break
														end

														Character2 = plr.Character

														if Character2:FindFirstChild("RaceTransformed").Value == false then
															callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

															if callbackPlayerDataCallbackReference then
																exitTo6 = nil

																while true do
																	wait()
																	playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																	if _G.TrainDrago == false then
																		break
																	elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																		exitTo6 = 1

																		break
																	end
																end

																if exitTo6 == 1 then
																	exitTo7 = nil

																	while true do
																		callbackPlayerDataData += n8

																		if not (n8 <= 0) then
																			exitTo7 = 1

																			break
																		end

																		if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																			break
																		end

																		Character = plr.Character

																		if Character:FindFirstChild("RaceEnergy").Value == 1 then
																			exitTo7 = 2

																			break
																		end

																		Character2 = plr.Character

																		if Character2:FindFirstChild("RaceTransformed").Value == false then
																			callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																			if callbackPlayerDataCallbackReference then
																				while true do
																					wait()
																					playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																					if _G.TrainDrago == false then
																						break
																					elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																						break
																					end
																				end
																			else
																				_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																			end
																		end
																	end

																	if exitTo7 == 1 then
																		if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																			continue
																		end

																		exitTo19 = 8

																		break
																	end

																	exitTo19 = 7

																	break
																end

																exitTo8 = nil

																while true do
																	callbackPlayerDataData += n8

																	if not (n8 <= 0) then
																		exitTo8 = 1

																		break
																	end

																	if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																		break
																	end

																	Character = plr.Character

																	if Character:FindFirstChild("RaceEnergy").Value == 1 then
																		exitTo8 = 2

																		break
																	end

																	Character2 = plr.Character

																	if Character2:FindFirstChild("RaceTransformed").Value == false then
																		callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																		if callbackPlayerDataCallbackReference then
																			while true do
																				wait()
																				playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																				if _G.TrainDrago == false then
																					break
																				elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																					break
																				end
																			end
																		else
																			_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																		end
																	end
																end

																if exitTo8 == 1 then
																	if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																		continue
																	end

																	exitTo19 = 6

																	break
																end

																exitTo19 = 5

																break
															end

															_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
															exitTo9 = nil

															while true do
																callbackPlayerDataData += n8

																if not (n8 <= 0) then
																	exitTo9 = 1

																	break
																end

																if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																	break
																end

																Character = plr.Character

																if Character:FindFirstChild("RaceEnergy").Value == 1 then
																	exitTo9 = 2

																	break
																end

																Character2 = plr.Character

																if Character2:FindFirstChild("RaceTransformed").Value == false then
																	callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																	if callbackPlayerDataCallbackReference then
																		while true do
																			wait()
																			playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																			if _G.TrainDrago == false then
																				break
																			elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																				break
																			end
																		end
																	else
																		_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																	end
																end
															end

															if exitTo9 == 1 then
																if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																	continue
																end

																exitTo19 = 4

																break
															end

															exitTo19 = 3

															break
														end

														exitTo10 = nil

														while true do
															callbackPlayerDataData += n8

															if not (n8 <= 0) then
																exitTo10 = 1

																break
															end

															if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																break
															end

															Character = plr.Character

															if Character:FindFirstChild("RaceEnergy").Value == 1 then
																exitTo10 = 2

																break
															end

															Character2 = plr.Character

															if Character2:FindFirstChild("RaceTransformed").Value == false then
																callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																if callbackPlayerDataCallbackReference then
																	while true do
																		wait()
																		playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																		if _G.TrainDrago == false then
																			break
																		elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																			break
																		end
																	end
																else
																	_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																end
															end
														end

														if exitTo10 == 1 then
															if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																continue
															end

															exitTo19 = 2

															break
														end

														break
													end

													if exitTo19 == 1 then
														exitTo2 = 1

														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 2 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 3 then
														if exitTo9 == 2 then
															exitTo2 = 1

															if exitTo2 == 1 then
																continue
															end
														elseif exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 4 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 5 then
														if exitTo8 == 2 then
															exitTo2 = 1

															if exitTo2 == 1 then
																continue
															end
														elseif exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 6 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 7 then
														if exitTo7 == 2 then
															exitTo2 = 1

															if exitTo2 == 1 then
																continue
															end
														elseif exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 8 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo10 == 2 then
														exitTo2 = 1

														if exitTo2 == 1 then
															continue
														end
													elseif exitTo2 == 1 then
														continue
													end
												elseif exitTo2 == 1 then
													continue
												end
											elseif exitTo5 == 2 then
												exitTo2 = 1

												if exitTo2 == 1 then
													continue
												end
											elseif exitTo2 == 1 then
												continue
											end

											break
										end
									end
								elseif exitTo20 == 7 then
									if exitTo7 == 2 then
										exitTo2 = 1

										if exitTo2 == 1 then
											while true do
												vim1:SendKeyEvent(true, "Y", true, game)
												replicated.Remotes.CommF_:InvokeServer("UpgradeRace", "Buy", 2)
												vim1:SendKeyEvent(false, "Y", true, game)
												_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
												exitTo2 = nil
												exitTo5 = nil

												while true do
													callbackPlayerDataData += n8

													if not (n8 <= 0) then
														exitTo5 = 1

														break
													end

													if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
														break
													end

													Character = plr.Character

													if Character:FindFirstChild("RaceEnergy").Value == 1 then
														exitTo5 = 2

														break
													end

													Character2 = plr.Character

													if Character2:FindFirstChild("RaceTransformed").Value == false then
														callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

														if callbackPlayerDataCallbackReference then
															while true do
																wait()
																playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																if _G.TrainDrago == false then
																	break
																elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																	break
																end
															end
														else
															_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
														end
													end
												end

												if exitTo5 == 1 then
													if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
														exitTo19 = nil

														while true do
															Character = plr.Character

															if Character:FindFirstChild("RaceEnergy").Value == 1 then
																exitTo19 = 1

																break
															end

															Character2 = plr.Character

															if Character2:FindFirstChild("RaceTransformed").Value == false then
																callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																if callbackPlayerDataCallbackReference then
																	exitTo6 = nil

																	while true do
																		wait()
																		playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																		if _G.TrainDrago == false then
																			break
																		elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																			exitTo6 = 1

																			break
																		end
																	end

																	if exitTo6 == 1 then
																		exitTo7 = nil

																		while true do
																			callbackPlayerDataData += n8

																			if not (n8 <= 0) then
																				exitTo7 = 1

																				break
																			end

																			if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																				break
																			end

																			Character = plr.Character

																			if Character:FindFirstChild("RaceEnergy").Value == 1 then
																				exitTo7 = 2

																				break
																			end

																			Character2 = plr.Character

																			if Character2:FindFirstChild("RaceTransformed").Value == false then
																				callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																				if callbackPlayerDataCallbackReference then
																					while true do
																						wait()
																						playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																						if _G.TrainDrago == false then
																							break
																						elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																							break
																						end
																					end
																				else
																					_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																				end
																			end
																		end

																		if exitTo7 == 1 then
																			if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																				continue
																			end

																			exitTo19 = 8

																			break
																		end

																		exitTo19 = 7

																		break
																	end

																	exitTo8 = nil

																	while true do
																		callbackPlayerDataData += n8

																		if not (n8 <= 0) then
																			exitTo8 = 1

																			break
																		end

																		if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																			break
																		end

																		Character = plr.Character

																		if Character:FindFirstChild("RaceEnergy").Value == 1 then
																			exitTo8 = 2

																			break
																		end

																		Character2 = plr.Character

																		if Character2:FindFirstChild("RaceTransformed").Value == false then
																			callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																			if callbackPlayerDataCallbackReference then
																				while true do
																					wait()
																					playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																					if _G.TrainDrago == false then
																						break
																					elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																						break
																					end
																				end
																			else
																				_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																			end
																		end
																	end

																	if exitTo8 == 1 then
																		if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																			continue
																		end

																		exitTo19 = 6

																		break
																	end

																	exitTo19 = 5

																	break
																end

																_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																exitTo9 = nil

																while true do
																	callbackPlayerDataData += n8

																	if not (n8 <= 0) then
																		exitTo9 = 1

																		break
																	end

																	if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																		break
																	end

																	Character = plr.Character

																	if Character:FindFirstChild("RaceEnergy").Value == 1 then
																		exitTo9 = 2

																		break
																	end

																	Character2 = plr.Character

																	if Character2:FindFirstChild("RaceTransformed").Value == false then
																		callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																		if callbackPlayerDataCallbackReference then
																			while true do
																				wait()
																				playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																				if _G.TrainDrago == false then
																					break
																				elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																					break
																				end
																			end
																		else
																			_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																		end
																	end
																end

																if exitTo9 == 1 then
																	if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																		continue
																	end

																	exitTo19 = 4

																	break
																end

																exitTo19 = 3

																break
															end

															exitTo10 = nil

															while true do
																callbackPlayerDataData += n8

																if not (n8 <= 0) then
																	exitTo10 = 1

																	break
																end

																if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																	break
																end

																Character = plr.Character

																if Character:FindFirstChild("RaceEnergy").Value == 1 then
																	exitTo10 = 2

																	break
																end

																Character2 = plr.Character

																if Character2:FindFirstChild("RaceTransformed").Value == false then
																	callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																	if callbackPlayerDataCallbackReference then
																		while true do
																			wait()
																			playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																			if _G.TrainDrago == false then
																				break
																			elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																				break
																			end
																		end
																	else
																		_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																	end
																end
															end

															if exitTo10 == 1 then
																if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																	continue
																end

																exitTo19 = 2

																break
															end

															break
														end

														if exitTo19 == 1 then
															exitTo2 = 1

															if exitTo2 == 1 then
																continue
															end
														elseif exitTo19 == 2 then
															if exitTo2 == 1 then
																continue
															end
														elseif exitTo19 == 3 then
															if exitTo9 == 2 then
																exitTo2 = 1

																if exitTo2 == 1 then
																	continue
																end
															elseif exitTo2 == 1 then
																continue
															end
														elseif exitTo19 == 4 then
															if exitTo2 == 1 then
																continue
															end
														elseif exitTo19 == 5 then
															if exitTo8 == 2 then
																exitTo2 = 1

																if exitTo2 == 1 then
																	continue
																end
															elseif exitTo2 == 1 then
																continue
															end
														elseif exitTo19 == 6 then
															if exitTo2 == 1 then
																continue
															end
														elseif exitTo19 == 7 then
															if exitTo7 == 2 then
																exitTo2 = 1

																if exitTo2 == 1 then
																	continue
																end
															elseif exitTo2 == 1 then
																continue
															end
														elseif exitTo19 == 8 then
															if exitTo2 == 1 then
																continue
															end
														elseif exitTo10 == 2 then
															exitTo2 = 1

															if exitTo2 == 1 then
																continue
															end
														elseif exitTo2 == 1 then
															continue
														end
													elseif exitTo2 == 1 then
														continue
													end
												elseif exitTo5 == 2 then
													exitTo2 = 1

													if exitTo2 == 1 then
														continue
													end
												elseif exitTo2 == 1 then
													continue
												end

												break
											end
										end
									elseif exitTo2 == 1 then
										while true do
											vim1:SendKeyEvent(true, "Y", true, game)
											replicated.Remotes.CommF_:InvokeServer("UpgradeRace", "Buy", 2)
											vim1:SendKeyEvent(false, "Y", true, game)
											_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
											exitTo2 = nil
											exitTo5 = nil

											while true do
												callbackPlayerDataData += n8

												if not (n8 <= 0) then
													exitTo5 = 1

													break
												end

												if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
													break
												end

												Character = plr.Character

												if Character:FindFirstChild("RaceEnergy").Value == 1 then
													exitTo5 = 2

													break
												end

												Character2 = plr.Character

												if Character2:FindFirstChild("RaceTransformed").Value == false then
													callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

													if callbackPlayerDataCallbackReference then
														while true do
															wait()
															playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

															if _G.TrainDrago == false then
																break
															elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																break
															end
														end
													else
														_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
													end
												end
											end

											if exitTo5 == 1 then
												if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
													exitTo19 = nil

													while true do
														Character = plr.Character

														if Character:FindFirstChild("RaceEnergy").Value == 1 then
															exitTo19 = 1

															break
														end

														Character2 = plr.Character

														if Character2:FindFirstChild("RaceTransformed").Value == false then
															callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

															if callbackPlayerDataCallbackReference then
																exitTo6 = nil

																while true do
																	wait()
																	playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																	if _G.TrainDrago == false then
																		break
																	elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																		exitTo6 = 1

																		break
																	end
																end

																if exitTo6 == 1 then
																	exitTo7 = nil

																	while true do
																		callbackPlayerDataData += n8

																		if not (n8 <= 0) then
																			exitTo7 = 1

																			break
																		end

																		if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																			break
																		end

																		Character = plr.Character

																		if Character:FindFirstChild("RaceEnergy").Value == 1 then
																			exitTo7 = 2

																			break
																		end

																		Character2 = plr.Character

																		if Character2:FindFirstChild("RaceTransformed").Value == false then
																			callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																			if callbackPlayerDataCallbackReference then
																				while true do
																					wait()
																					playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																					if _G.TrainDrago == false then
																						break
																					elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																						break
																					end
																				end
																			else
																				_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																			end
																		end
																	end

																	if exitTo7 == 1 then
																		if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																			continue
																		end

																		exitTo19 = 8

																		break
																	end

																	exitTo19 = 7

																	break
																end

																exitTo8 = nil

																while true do
																	callbackPlayerDataData += n8

																	if not (n8 <= 0) then
																		exitTo8 = 1

																		break
																	end

																	if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																		break
																	end

																	Character = plr.Character

																	if Character:FindFirstChild("RaceEnergy").Value == 1 then
																		exitTo8 = 2

																		break
																	end

																	Character2 = plr.Character

																	if Character2:FindFirstChild("RaceTransformed").Value == false then
																		callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																		if callbackPlayerDataCallbackReference then
																			while true do
																				wait()
																				playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																				if _G.TrainDrago == false then
																					break
																				elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																					break
																				end
																			end
																		else
																			_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																		end
																	end
																end

																if exitTo8 == 1 then
																	if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																		continue
																	end

																	exitTo19 = 6

																	break
																end

																exitTo19 = 5

																break
															end

															_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
															exitTo9 = nil

															while true do
																callbackPlayerDataData += n8

																if not (n8 <= 0) then
																	exitTo9 = 1

																	break
																end

																if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																	break
																end

																Character = plr.Character

																if Character:FindFirstChild("RaceEnergy").Value == 1 then
																	exitTo9 = 2

																	break
																end

																Character2 = plr.Character

																if Character2:FindFirstChild("RaceTransformed").Value == false then
																	callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																	if callbackPlayerDataCallbackReference then
																		while true do
																			wait()
																			playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																			if _G.TrainDrago == false then
																				break
																			elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																				break
																			end
																		end
																	else
																		_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																	end
																end
															end

															if exitTo9 == 1 then
																if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																	continue
																end

																exitTo19 = 4

																break
															end

															exitTo19 = 3

															break
														end

														exitTo10 = nil

														while true do
															callbackPlayerDataData += n8

															if not (n8 <= 0) then
																exitTo10 = 1

																break
															end

															if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																break
															end

															Character = plr.Character

															if Character:FindFirstChild("RaceEnergy").Value == 1 then
																exitTo10 = 2

																break
															end

															Character2 = plr.Character

															if Character2:FindFirstChild("RaceTransformed").Value == false then
																callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																if callbackPlayerDataCallbackReference then
																	while true do
																		wait()
																		playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																		if _G.TrainDrago == false then
																			break
																		elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																			break
																		end
																	end
																else
																	_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																end
															end
														end

														if exitTo10 == 1 then
															if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																continue
															end

															exitTo19 = 2

															break
														end

														break
													end

													if exitTo19 == 1 then
														exitTo2 = 1

														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 2 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 3 then
														if exitTo9 == 2 then
															exitTo2 = 1

															if exitTo2 == 1 then
																continue
															end
														elseif exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 4 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 5 then
														if exitTo8 == 2 then
															exitTo2 = 1

															if exitTo2 == 1 then
																continue
															end
														elseif exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 6 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 7 then
														if exitTo7 == 2 then
															exitTo2 = 1

															if exitTo2 == 1 then
																continue
															end
														elseif exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 8 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo10 == 2 then
														exitTo2 = 1

														if exitTo2 == 1 then
															continue
														end
													elseif exitTo2 == 1 then
														continue
													end
												elseif exitTo2 == 1 then
													continue
												end
											elseif exitTo5 == 2 then
												exitTo2 = 1

												if exitTo2 == 1 then
													continue
												end
											elseif exitTo2 == 1 then
												continue
											end

											break
										end
									end
								elseif exitTo20 == 8 then
									if exitTo2 == 1 then
										while true do
											vim1:SendKeyEvent(true, "Y", true, game)
											replicated.Remotes.CommF_:InvokeServer("UpgradeRace", "Buy", 2)
											vim1:SendKeyEvent(false, "Y", true, game)
											_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
											exitTo2 = nil
											exitTo5 = nil

											while true do
												callbackPlayerDataData += n8

												if not (n8 <= 0) then
													exitTo5 = 1

													break
												end

												if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
													break
												end

												Character = plr.Character

												if Character:FindFirstChild("RaceEnergy").Value == 1 then
													exitTo5 = 2

													break
												end

												Character2 = plr.Character

												if Character2:FindFirstChild("RaceTransformed").Value == false then
													callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

													if callbackPlayerDataCallbackReference then
														while true do
															wait()
															playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

															if _G.TrainDrago == false then
																break
															elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																break
															end
														end
													else
														_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
													end
												end
											end

											if exitTo5 == 1 then
												if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
													exitTo19 = nil

													while true do
														Character = plr.Character

														if Character:FindFirstChild("RaceEnergy").Value == 1 then
															exitTo19 = 1

															break
														end

														Character2 = plr.Character

														if Character2:FindFirstChild("RaceTransformed").Value == false then
															callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

															if callbackPlayerDataCallbackReference then
																exitTo6 = nil

																while true do
																	wait()
																	playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																	if _G.TrainDrago == false then
																		break
																	elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																		exitTo6 = 1

																		break
																	end
																end

																if exitTo6 == 1 then
																	exitTo7 = nil

																	while true do
																		callbackPlayerDataData += n8

																		if not (n8 <= 0) then
																			exitTo7 = 1

																			break
																		end

																		if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																			break
																		end

																		Character = plr.Character

																		if Character:FindFirstChild("RaceEnergy").Value == 1 then
																			exitTo7 = 2

																			break
																		end

																		Character2 = plr.Character

																		if Character2:FindFirstChild("RaceTransformed").Value == false then
																			callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																			if callbackPlayerDataCallbackReference then
																				while true do
																					wait()
																					playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																					if _G.TrainDrago == false then
																						break
																					elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																						break
																					end
																				end
																			else
																				_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																			end
																		end
																	end

																	if exitTo7 == 1 then
																		if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																			continue
																		end

																		exitTo19 = 8

																		break
																	end

																	exitTo19 = 7

																	break
																end

																exitTo8 = nil

																while true do
																	callbackPlayerDataData += n8

																	if not (n8 <= 0) then
																		exitTo8 = 1

																		break
																	end

																	if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																		break
																	end

																	Character = plr.Character

																	if Character:FindFirstChild("RaceEnergy").Value == 1 then
																		exitTo8 = 2

																		break
																	end

																	Character2 = plr.Character

																	if Character2:FindFirstChild("RaceTransformed").Value == false then
																		callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																		if callbackPlayerDataCallbackReference then
																			while true do
																				wait()
																				playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																				if _G.TrainDrago == false then
																					break
																				elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																					break
																				end
																			end
																		else
																			_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																		end
																	end
																end

																if exitTo8 == 1 then
																	if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																		continue
																	end

																	exitTo19 = 6

																	break
																end

																exitTo19 = 5

																break
															end

															_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
															exitTo9 = nil

															while true do
																callbackPlayerDataData += n8

																if not (n8 <= 0) then
																	exitTo9 = 1

																	break
																end

																if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																	break
																end

																Character = plr.Character

																if Character:FindFirstChild("RaceEnergy").Value == 1 then
																	exitTo9 = 2

																	break
																end

																Character2 = plr.Character

																if Character2:FindFirstChild("RaceTransformed").Value == false then
																	callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																	if callbackPlayerDataCallbackReference then
																		while true do
																			wait()
																			playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																			if _G.TrainDrago == false then
																				break
																			elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																				break
																			end
																		end
																	else
																		_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																	end
																end
															end

															if exitTo9 == 1 then
																if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																	continue
																end

																exitTo19 = 4

																break
															end

															exitTo19 = 3

															break
														end

														exitTo10 = nil

														while true do
															callbackPlayerDataData += n8

															if not (n8 <= 0) then
																exitTo10 = 1

																break
															end

															if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																break
															end

															Character = plr.Character

															if Character:FindFirstChild("RaceEnergy").Value == 1 then
																exitTo10 = 2

																break
															end

															Character2 = plr.Character

															if Character2:FindFirstChild("RaceTransformed").Value == false then
																callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																if callbackPlayerDataCallbackReference then
																	while true do
																		wait()
																		playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																		if _G.TrainDrago == false then
																			break
																		elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																			break
																		end
																	end
																else
																	_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																end
															end
														end

														if exitTo10 == 1 then
															if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																continue
															end

															exitTo19 = 2

															break
														end

														break
													end

													if exitTo19 == 1 then
														exitTo2 = 1

														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 2 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 3 then
														if exitTo9 == 2 then
															exitTo2 = 1

															if exitTo2 == 1 then
																continue
															end
														elseif exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 4 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 5 then
														if exitTo8 == 2 then
															exitTo2 = 1

															if exitTo2 == 1 then
																continue
															end
														elseif exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 6 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 7 then
														if exitTo7 == 2 then
															exitTo2 = 1

															if exitTo2 == 1 then
																continue
															end
														elseif exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 8 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo10 == 2 then
														exitTo2 = 1

														if exitTo2 == 1 then
															continue
														end
													elseif exitTo2 == 1 then
														continue
													end
												elseif exitTo2 == 1 then
													continue
												end
											elseif exitTo5 == 2 then
												exitTo2 = 1

												if exitTo2 == 1 then
													continue
												end
											elseif exitTo2 == 1 then
												continue
											end

											break
										end
									end
								elseif exitTo10 == 2 then
									exitTo2 = 1

									if exitTo2 == 1 then
										while true do
											vim1:SendKeyEvent(true, "Y", true, game)
											replicated.Remotes.CommF_:InvokeServer("UpgradeRace", "Buy", 2)
											vim1:SendKeyEvent(false, "Y", true, game)
											_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
											exitTo2 = nil
											exitTo5 = nil

											while true do
												callbackPlayerDataData += n8

												if not (n8 <= 0) then
													exitTo5 = 1

													break
												end

												if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
													break
												end

												Character = plr.Character

												if Character:FindFirstChild("RaceEnergy").Value == 1 then
													exitTo5 = 2

													break
												end

												Character2 = plr.Character

												if Character2:FindFirstChild("RaceTransformed").Value == false then
													callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

													if callbackPlayerDataCallbackReference then
														while true do
															wait()
															playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

															if _G.TrainDrago == false then
																break
															elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																break
															end
														end
													else
														_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
													end
												end
											end

											if exitTo5 == 1 then
												if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
													exitTo19 = nil

													while true do
														Character = plr.Character

														if Character:FindFirstChild("RaceEnergy").Value == 1 then
															exitTo19 = 1

															break
														end

														Character2 = plr.Character

														if Character2:FindFirstChild("RaceTransformed").Value == false then
															callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

															if callbackPlayerDataCallbackReference then
																exitTo6 = nil

																while true do
																	wait()
																	playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																	if _G.TrainDrago == false then
																		break
																	elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																		exitTo6 = 1

																		break
																	end
																end

																if exitTo6 == 1 then
																	exitTo7 = nil

																	while true do
																		callbackPlayerDataData += n8

																		if not (n8 <= 0) then
																			exitTo7 = 1

																			break
																		end

																		if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																			break
																		end

																		Character = plr.Character

																		if Character:FindFirstChild("RaceEnergy").Value == 1 then
																			exitTo7 = 2

																			break
																		end

																		Character2 = plr.Character

																		if Character2:FindFirstChild("RaceTransformed").Value == false then
																			callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																			if callbackPlayerDataCallbackReference then
																				while true do
																					wait()
																					playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																					if _G.TrainDrago == false then
																						break
																					elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																						break
																					end
																				end
																			else
																				_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																			end
																		end
																	end

																	if exitTo7 == 1 then
																		if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																			continue
																		end

																		exitTo19 = 8

																		break
																	end

																	exitTo19 = 7

																	break
																end

																exitTo8 = nil

																while true do
																	callbackPlayerDataData += n8

																	if not (n8 <= 0) then
																		exitTo8 = 1

																		break
																	end

																	if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																		break
																	end

																	Character = plr.Character

																	if Character:FindFirstChild("RaceEnergy").Value == 1 then
																		exitTo8 = 2

																		break
																	end

																	Character2 = plr.Character

																	if Character2:FindFirstChild("RaceTransformed").Value == false then
																		callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																		if callbackPlayerDataCallbackReference then
																			while true do
																				wait()
																				playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																				if _G.TrainDrago == false then
																					break
																				elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																					break
																				end
																			end
																		else
																			_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																		end
																	end
																end

																if exitTo8 == 1 then
																	if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																		continue
																	end

																	exitTo19 = 6

																	break
																end

																exitTo19 = 5

																break
															end

															_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
															exitTo9 = nil

															while true do
																callbackPlayerDataData += n8

																if not (n8 <= 0) then
																	exitTo9 = 1

																	break
																end

																if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																	break
																end

																Character = plr.Character

																if Character:FindFirstChild("RaceEnergy").Value == 1 then
																	exitTo9 = 2

																	break
																end

																Character2 = plr.Character

																if Character2:FindFirstChild("RaceTransformed").Value == false then
																	callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																	if callbackPlayerDataCallbackReference then
																		while true do
																			wait()
																			playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																			if _G.TrainDrago == false then
																				break
																			elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																				break
																			end
																		end
																	else
																		_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																	end
																end
															end

															if exitTo9 == 1 then
																if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																	continue
																end

																exitTo19 = 4

																break
															end

															exitTo19 = 3

															break
														end

														exitTo10 = nil

														while true do
															callbackPlayerDataData += n8

															if not (n8 <= 0) then
																exitTo10 = 1

																break
															end

															if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																break
															end

															Character = plr.Character

															if Character:FindFirstChild("RaceEnergy").Value == 1 then
																exitTo10 = 2

																break
															end

															Character2 = plr.Character

															if Character2:FindFirstChild("RaceTransformed").Value == false then
																callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																if callbackPlayerDataCallbackReference then
																	while true do
																		wait()
																		playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																		if _G.TrainDrago == false then
																			break
																		elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																			break
																		end
																	end
																else
																	_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																end
															end
														end

														if exitTo10 == 1 then
															if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																continue
															end

															exitTo19 = 2

															break
														end

														break
													end

													if exitTo19 == 1 then
														exitTo2 = 1

														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 2 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 3 then
														if exitTo9 == 2 then
															exitTo2 = 1

															if exitTo2 == 1 then
																continue
															end
														elseif exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 4 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 5 then
														if exitTo8 == 2 then
															exitTo2 = 1

															if exitTo2 == 1 then
																continue
															end
														elseif exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 6 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 7 then
														if exitTo7 == 2 then
															exitTo2 = 1

															if exitTo2 == 1 then
																continue
															end
														elseif exitTo2 == 1 then
															continue
														end
													elseif exitTo19 == 8 then
														if exitTo2 == 1 then
															continue
														end
													elseif exitTo10 == 2 then
														exitTo2 = 1

														if exitTo2 == 1 then
															continue
														end
													elseif exitTo2 == 1 then
														continue
													end
												elseif exitTo2 == 1 then
													continue
												end
											elseif exitTo5 == 2 then
												exitTo2 = 1

												if exitTo2 == 1 then
													continue
												end
											elseif exitTo2 == 1 then
												continue
											end

											break
										end
									end
								elseif exitTo2 == 1 then
									while true do
										vim1:SendKeyEvent(true, "Y", true, game)
										replicated.Remotes.CommF_:InvokeServer("UpgradeRace", "Buy", 2)
										vim1:SendKeyEvent(false, "Y", true, game)
										_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
										exitTo2 = nil
										exitTo5 = nil

										while true do
											callbackPlayerDataData += n8

											if not (n8 <= 0) then
												exitTo5 = 1

												break
											end

											if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
												break
											end

											Character = plr.Character

											if Character:FindFirstChild("RaceEnergy").Value == 1 then
												exitTo5 = 2

												break
											end

											Character2 = plr.Character

											if Character2:FindFirstChild("RaceTransformed").Value == false then
												callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

												if callbackPlayerDataCallbackReference then
													while true do
														wait()
														playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

														if _G.TrainDrago == false then
															break
														elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
															break
														end
													end
												else
													_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
												end
											end
										end

										if exitTo5 == 1 then
											if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
												exitTo19 = nil

												while true do
													Character = plr.Character

													if Character:FindFirstChild("RaceEnergy").Value == 1 then
														exitTo19 = 1

														break
													end

													Character2 = plr.Character

													if Character2:FindFirstChild("RaceTransformed").Value == false then
														callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

														if callbackPlayerDataCallbackReference then
															exitTo6 = nil

															while true do
																wait()
																playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																if _G.TrainDrago == false then
																	break
																elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																	exitTo6 = 1

																	break
																end
															end

															if exitTo6 == 1 then
																exitTo7 = nil

																while true do
																	callbackPlayerDataData += n8

																	if not (n8 <= 0) then
																		exitTo7 = 1

																		break
																	end

																	if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																		break
																	end

																	Character = plr.Character

																	if Character:FindFirstChild("RaceEnergy").Value == 1 then
																		exitTo7 = 2

																		break
																	end

																	Character2 = plr.Character

																	if Character2:FindFirstChild("RaceTransformed").Value == false then
																		callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																		if callbackPlayerDataCallbackReference then
																			while true do
																				wait()
																				playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																				if _G.TrainDrago == false then
																					break
																				elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																					break
																				end
																			end
																		else
																			_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																		end
																	end
																end

																if exitTo7 == 1 then
																	if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																		continue
																	end

																	exitTo19 = 8

																	break
																end

																exitTo19 = 7

																break
															end

															exitTo8 = nil

															while true do
																callbackPlayerDataData += n8

																if not (n8 <= 0) then
																	exitTo8 = 1

																	break
																end

																if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																	break
																end

																Character = plr.Character

																if Character:FindFirstChild("RaceEnergy").Value == 1 then
																	exitTo8 = 2

																	break
																end

																Character2 = plr.Character

																if Character2:FindFirstChild("RaceTransformed").Value == false then
																	callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																	if callbackPlayerDataCallbackReference then
																		while true do
																			wait()
																			playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																			if _G.TrainDrago == false then
																				break
																			elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																				break
																			end
																		end
																	else
																		_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																	end
																end
															end

															if exitTo8 == 1 then
																if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																	continue
																end

																exitTo19 = 6

																break
															end

															exitTo19 = 5

															break
														end

														_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
														exitTo9 = nil

														while true do
															callbackPlayerDataData += n8

															if not (n8 <= 0) then
																exitTo9 = 1

																break
															end

															if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
																break
															end

															Character = plr.Character

															if Character:FindFirstChild("RaceEnergy").Value == 1 then
																exitTo9 = 2

																break
															end

															Character2 = plr.Character

															if Character2:FindFirstChild("RaceTransformed").Value == false then
																callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

																if callbackPlayerDataCallbackReference then
																	while true do
																		wait()
																		playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																		if _G.TrainDrago == false then
																			break
																		elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																			break
																		end
																	end
																else
																	_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
																end
															end
														end

														if exitTo9 == 1 then
															if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
																continue
															end

															exitTo19 = 4

															break
														end

														exitTo19 = 3

														break
													end

													exitTo10 = nil

													while true do
														callbackPlayerDataData += n8

														if not (n8 <= 0) then
															exitTo10 = 1

															break
														end

														if not (callbackPlayerDataData >= callbackPlayerDataCallbackPayload) then
															break
														end

														Character = plr.Character

														if Character:FindFirstChild("RaceEnergy").Value == 1 then
															exitTo10 = 2

															break
														end

														Character2 = plr.Character

														if Character2:FindFirstChild("RaceTransformed").Value == false then
															callbackPlayerDataCallbackReference = GetConnectionEnemies(callbackEntriesItem)

															if callbackPlayerDataCallbackReference then
																while true do
																	wait()
																	playerCollectionLatest.Kill(callbackPlayerDataCallbackReference, _G.TrainDrago)

																	if _G.TrainDrago == false then
																		break
																	elseif callbackPlayerDataCallbackReference.Humanoid.Health <= 0 or not callbackPlayerDataCallbackReference.Parent then
																		break
																	end
																end
															else
																_tp(CFrame.new(4620.61572265625, 1002.2954711914062, 399.08688354492188))
															end
														end
													end

													if exitTo10 == 1 then
														if callbackPlayerDataData <= callbackPlayerDataCallbackPayload then
															continue
														end

														exitTo19 = 2

														break
													end

													break
												end

												if exitTo19 == 1 then
													exitTo2 = 1

													if exitTo2 == 1 then
														continue
													end
												elseif exitTo19 == 2 then
													if exitTo2 == 1 then
														continue
													end
												elseif exitTo19 == 3 then
													if exitTo9 == 2 then
														exitTo2 = 1

														if exitTo2 == 1 then
															continue
														end
													elseif exitTo2 == 1 then
														continue
													end
												elseif exitTo19 == 4 then
													if exitTo2 == 1 then
														continue
													end
												elseif exitTo19 == 5 then
													if exitTo8 == 2 then
														exitTo2 = 1

														if exitTo2 == 1 then
															continue
														end
													elseif exitTo2 == 1 then
														continue
													end
												elseif exitTo19 == 6 then
													if exitTo2 == 1 then
														continue
													end
												elseif exitTo19 == 7 then
													if exitTo7 == 2 then
														exitTo2 = 1

														if exitTo2 == 1 then
															continue
														end
													elseif exitTo2 == 1 then
														continue
													end
												elseif exitTo19 == 8 then
													if exitTo2 == 1 then
														continue
													end
												elseif exitTo10 == 2 then
													exitTo2 = 1

													if exitTo2 == 1 then
														continue
													end
												elseif exitTo2 == 1 then
													continue
												end
											elseif exitTo2 == 1 then
												continue
											end
										elseif exitTo5 == 2 then
											exitTo2 = 1

											if exitTo2 == 1 then
												continue
											end
										elseif exitTo2 == 1 then
											continue
										end

										break
									end
								end
							end
						end
					end
				end
			end)
		end
	end)
end

dragoTpVolcano = GRP_Prehistoric_Drago_Trial:AddToggle("Tween_to_Drago_Trials", {
	Text = "Tween to Drago Trials",
	Default = false,
	Callback = function(isTweenToDragoTrialsEnabled)
		_G.TpDrago_Prehis = isTweenToDragoTrialsEnabled
	end
})
spawn(function()
	while wait(Sec) do
		if _G.TpDrago_Prehis then
			local TrialTeleport = workspace.Map.PrehistoricIsland:FindFirstChild("TrialTeleport")

			if TrialTeleport and TrialTeleport:IsA("Part") then
				local exitTo

				repeat
					_tp(CFrame.new(TrialTeleport.Position))
					exitTo = nil

					while wait(Sec) do
						if _G.TpDrago_Prehis then
							TrialTeleport = workspace.Map.PrehistoricIsland:FindFirstChild("TrialTeleport")

							if TrialTeleport and TrialTeleport:IsA("Part") then
								exitTo = 1

								break
							end
						end
					end
				until exitTo ~= 1

				return
			end
		end
	end
end)

do
	bdrago = GRP_Prehistoric_Drago_Trial:AddToggle("Swap_Drago_Race", {
		Text = "Swap Drago Race",
		Default = false,
		Callback = function(isSwapDragoRaceEnabled)
			_G.BuyDrago = isSwapDragoRaceEnabled
		end
	})
end

do
	spawn(function()
		while wait(Sec) do
			if _G.BuyDrago then
				pcall(function()
					if (CFrame.new(5814.42724609375, 1208.3267822265625, 884.57855224609375).Position - Root.Position).Magnitude >= 300 then
						_tp(CFrame.new(5814.42724609375, 1208.3267822265625, 884.57855224609375))
					else
						_tp(CFrame.new(5814.42724609375, 1208.3267822265625, 884.57855224609375))
						replicated.Modules.Net:FindFirstChild("RF/InteractDragonQuest"):InvokeServer(unpack({ {
							NPC = "Dragon Wizard",
							Command = "DragonRace"
						} }))
					end
				end)
			end
		end
	end)
end

do
	UpTalon = GRP_Prehistoric_Drago_Trial:AddToggle("Upgrade_Dragon_Talon_With_Uzoth", {
		Text = "Upgrade Dragon Talon With Uzoth",
		Default = false,
		Callback = function(isUpgradeDragonTalonWithUzothEnabled)
			_G.DT_Uzoth = isUpgradeDragonTalonWithUzothEnabled
		end
	})
end

do
	spawn(function()
		while wait(Sec) do
			if _G.DT_Uzoth then
				local cFrame = CFrame.new(5661.89014, 1211.31909, 864.836731, 0.811413169, -1.36805838e-08, -0.584473014, 4.75227395e-08, 1, 4.25682458e-08, 0.584473014, -6.23161966e-08, 0.811413169)

				_tp(cFrame)

				if (cFrame.Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 25 then
					replicated.Modules.Net["RF/InteractDragonQuest"]:InvokeServer({
						NPC = "Uzoth",
						Command = "Upgrade"
					})
				end
			end
		end
	end)
end

GRP_Prehistoric_Volcanic_Crafting = tabs.Prehistoric:AddLeftGroupbox("Volcanic Crafting")
GRP_Prehistoric_Volcanic_Crafting:AddButton({
	Text = "Craft Dragonheart",
	Func = function()
		replicated.Remotes.CommF_:InvokeServer("CraftItem", "Craft", "Dragonheart")
	end
})

do
	GRP_Prehistoric_Volcanic_Crafting:AddButton({
		Text = "Craft Dragonstorm",
		Func = function()
			replicated.Remotes.CommF_:InvokeServer("CraftItem", "Craft", "Dragonstorm")
		end
	})
end

GRP_Prehistoric_Volcanic_Crafting:AddButton({
	Text = "Craft Dino Hood",
	Func = function()
		replicated.Remotes.CommF_:InvokeServer("CraftItem", "Craft", "DinoHood")
	end
})

do
	GRP_Prehistoric_Volcanic_Crafting:AddButton({
		Text = "Craft T-Rex Skull",
		Func = function()
			replicated.Remotes.CommF_:InvokeServer("CraftItem", "Craft", "TRexSkull")
		end
	})
end

GRP_Prehistoric_Prehistoric_Island = tabs.Prehistoric:AddLeftGroupbox("Prehistoric Island")

do
	local grpPrehistoricPrehistoricIslandData = GRP_Prehistoric_Prehistoric_Island:AddLabel("")

	spawn(function()
		while wait(0.2) do
			if not workspace.Map:FindFirstChild("PrehistoricIsland") then
				if not workspace._WorldOrigin.Locations:FindFirstChild("Prehistoric Island") then
					grpPrehistoricPrehistoricIslandData:SetText("Prehistoric Island : False")

					continue
				end
			end

			grpPrehistoricPrehistoricIslandData:SetText("Prehistoric Island : True")
		end
	end)
end

do
	GRP_Prehistoric_Prehistoric_Island:AddButton({
		Text = "Craft Volcanic Magnet",
		Func = function()
			replicated.Modules.Net["RF/Craft"]:InvokeServer("PossibleHardcode", "Volcanic Magnet")
		end
	})
end

do
	GRP_Prehistoric_Prehistoric_Island:AddToggle("Craft_Volcanic_Magnet", {
		Text = "Craft Volcanic Magnet",
		Default = false,
		Callback = function(isCraftVolcanicMagnetEnabled)
			_G.Prehis_Find = isCraftVolcanicMagnetEnabled
		end
	})
end

do
	task.spawn(function()
		local rfCraft = game:GetService("ReplicatedStorage").Modules.Net["RF/Craft"]

		while task.wait(0.3) do
			if getgenv().AutoCraftVolcanic then
				pcall(function()
					rfCraft:InvokeServer("PossibleHardcode", "Volcanic Magnet")
				end)
				getgenv().AutoCraftVolcanic = false
			end
		end
	end)
end

GRP_Prehistoric_Prehistoric_Island:AddToggle("Auto_Find_Prehistoric_Island", {
	Text = "Auto Find Prehistoric Island",
	Default = false,
	Callback = function(isAutoFindPrehistoricIslandEnabled)
		_G.Prehis_Find = isAutoFindPrehistoricIslandEnabled
	end
})

do
	local isCallbackActive

	spawn(function()
		while wait(Sec) do
			pcall(function()
				if _G.Prehis_Find then
					local Character = plr.Character

					if not Character then
						return
					end

					local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
					local Humanoid = Character:FindFirstChild("Humanoid")

					if not HumanoidRootPart or not Humanoid or Humanoid.Health <= 0 then
						return
					end

					local PrehistoricIsland = workspace._WorldOrigin.Locations:FindFirstChild("Prehistoric Island", true)

					if PrehistoricIsland then
						local HeadTeleport = PrehistoricIsland:FindFirstChild("HeadTeleport", true) or PrehistoricIsland:FindFirstChild("Teleport_Head", true) or PrehistoricIsland:FindFirstChild("Head", true)

						if HeadTeleport then
							local CFrame_ = HeadTeleport.CFrame
							local targetPosition = CFrame_.Position - CFrame_.LookVector * 40 + Vector3.new(0, 20, 0)

							if (targetPosition - HumanoidRootPart.Position).Magnitude > 30 then
								_tp(CFrame.new(targetPosition))
							end
						else
							local Position = PrehistoricIsland.CFrame.Position

							_tp(CFrame.new(Position - (Position - HumanoidRootPart.Position).Unit * 250 + Vector3.new(0, 60, 0)))
						end
					else
						local callbackMovementDataData = CheckBoat()

						if not callbackMovementDataData then
							local cFrame = CFrame.new(-16927.451, 9.086, 433.864)

							TeleportToTarget(cFrame)

							if (cFrame.Position - HumanoidRootPart.Position).Magnitude <= 10 then
								replicated.Remotes.CommF_:InvokeServer("BuyBoat", _G.SelectedBoat or "Guardian")
							end

							return
						end

						if Humanoid.Sit == false then
							_tp(callbackMovementDataData.VehicleSeat.CFrame * CFrame.new(0, 1, 0))

							return
						end

						local cFrame = CFrame.new(-10000000, 31, 37016.25)

						isCallbackActive = cFrame

						if CheckEnemiesBoat() or CheckTerrorShark() or CheckPirateGrandBrigade() then
							_tp(CFrame.new(-10000000, 150, 37016.25))
						else
							_tp(cFrame)
						end
					end
				end
			end)
		end
	end)
end

do
	GRP_Prehistoric_Prehistoric_Island:AddToggle("Auto_Start_Prehistoric_Event", {
		Text = "Auto Start Prehistoric Event",
		Default = false,
		Callback = function(isAutoStartPrehistoricEventEnabled)
			_G.AutoStartPrehistoric = isAutoStartPrehistoricEventEnabled
		end
	})
end

do
	spawn(function()
		while wait() do
			if _G.AutoStartPrehistoric then
				pcall(function()
					if workspace._WorldOrigin.Locations:FindFirstChild("Prehistoric Island", true) then
						if workspace.Map:FindFirstChild("PrehistoricIsland", true) then
							local ActivationPrompt = workspace.Map.PrehistoricIsland.Core:FindFirstChild("ActivationPrompt", true)

							if ActivationPrompt and ActivationPrompt:FindFirstChild("ProximityPrompt") then
								if plr:DistanceFromCharacter(ActivationPrompt.CFrame.Position) <= 150 then
									fireproximityprompt(ActivationPrompt.ProximityPrompt, math.huge)
									vim1:SendKeyEvent(true, "E", true, game)
									wait(1.5)
									vim1:SendKeyEvent(false, "E", true, game)
								end

								_tp(ActivationPrompt.CFrame)
							end
						end
					end
				end)
			end
		end
	end)
end

do
	GRP_Prehistoric_Prehistoric_Island:AddToggle("Auto_Patch_Prehistoric_Event", {
		Text = "Auto Patch Prehistoric Event",
		Default = false,
		Callback = function(isAutoPatchPrehistoricEventEnabled)
			_G.Prehis_Skills = isAutoPatchPrehistoricEventEnabled
		end
	})
end

spawn(function()
	while wait(0.3) do
		if _G.Prehis_Skills then
			pcall(function()
				local PrehistoricIsland = workspace.Map:FindFirstChild("PrehistoricIsland")

				if not PrehistoricIsland then
					return
				end

				for _, descendant in pairs(PrehistoricIsland:GetDescendants()) do
					if descendant:IsA("BasePart") or descendant:IsA("MeshPart") then
						if descendant.Name:lower():find("lava") then
							descendant:Destroy()
						end
					end
				end

				local Core = PrehistoricIsland:FindFirstChild("Core")

				if Core then
					local InteriorLava = Core:FindFirstChild("InteriorLava")

					if InteriorLava then
						InteriorLava:Destroy()
					end
				end

				local TrialTeleport = PrehistoricIsland:FindFirstChild("TrialTeleport")

				for _, descendant in pairs(PrehistoricIsland:GetDescendants()) do
					if descendant.Name == "TouchInterest" and (not TrialTeleport or not descendant:IsDescendantOf(TrialTeleport)) then
						descendant.Parent:Destroy()
					end
				end
			end)
		end
	end
end)
spawn(function()
	while wait(Sec) do
		if _G.Prehis_Skills then
			pcall(function()
				local callbackResultResponse = GetConnectionEnemies("Lava Golem")

				if callbackResultResponse and callbackResultResponse:FindFirstChild("Humanoid") then
					while true do
						wait(0.1)
						playerCollectionLatest.Kill(callbackResultResponse, true)
						callbackResultResponse.Humanoid:ChangeState(15)

						if _G.Prehis_Skills then
							if not callbackResultResponse.Parent or callbackResultResponse.Humanoid.Health <= 0 then
								break
							end
						else
							break
						end
					end
				end
			end)
		end
	end
end)

do
	spawn(function()
		while wait(Sec) do
			if _G.Prehis_Skills then
				pcall(function()
					local PrehistoricIsland = workspace.Map:FindFirstChild("PrehistoricIsland")

					if not PrehistoricIsland then
						return
					end

					local Core = PrehistoricIsland:FindFirstChild("Core")

					if not Core then
						return
					end

					local VolcanoRocks = Core:FindFirstChild("VolcanoRocks")

					if not VolcanoRocks then
						return
					end

					for _, child in pairs(VolcanoRocks:GetChildren()) do
						local VFXLayer = child:FindFirstChild("VFXLayer")
						local At0 = VFXLayer and VFXLayer:FindFirstChild("At0")
						local Glow = At0 and At0:FindFirstChild("Glow")

						if Glow and Glow.Enabled then
							repeat
								wait(0.1)
								_tp(VFXLayer.CFrame)

								if plr:DistanceFromCharacter(VFXLayer.CFrame.Position) <= 150 then
									MousePos = VFXLayer.CFrame.Position
									Useskills("Melee", "Z")
									wait(0.4)
									Useskills("Melee", "X")
									wait(0.4)
									Useskills("Melee", "C")
									wait(0.4)
									Useskills("Blox Fruit", "Z")
									wait(0.4)
									Useskills("Blox Fruit", "X")
									wait(0.4)
									Useskills("Blox Fruit", "C")
								end
							until not _G.Prehis_Skills or not Glow.Enabled
						end
					end
				end)
			end
		end
	end)
end

Kaura = GRP_Prehistoric_Prehistoric_Island:AddToggle("Kill_Aura", {
	Text = "Kill Aura",
	Default = false,
	Callback = function(isKillAuraEnabled)
		_G.KillAuraFull = isKillAuraEnabled
	end
})
spawn(function()
	while task.wait(2) do
		if _G.KillAuraFull then
			local exitTo

			repeat
				pcall(function()
					local LocalPlayer = game.Players.LocalPlayer
					local Character = LocalPlayer.Character
					local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

					if not HumanoidRootPart then
						return
					end

					sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)

					for _, child in pairs(workspace.Enemies:GetChildren()) do
						if child:FindFirstChild("Humanoid") and child:FindFirstChild("HumanoidRootPart") and (child.HumanoidRootPart.Position - HumanoidRootPart.Position).Magnitude <= 500 and child.Humanoid.Health > 0 then
							child.Humanoid.Health = 0
							child.HumanoidRootPart.CanCollide = false
							child:BreakJoints()
						end
					end
				end)
				exitTo = nil

				while task.wait(2) do
					if _G.KillAuraFull then
						exitTo = 1

						break
					end
				end
			until exitTo ~= 1

			return
		end
	end
end)
Vocan = GRP_Prehistoric_Prehistoric_Island:AddToggle("Auto_Collect_Dino_Bones", {
	Text = "Auto Collect Dino Bones",
	Default = false,
	Callback = function(isAutoCollectDinoBonesEnabled)
		_G.Prehis_DB = isAutoCollectDinoBonesEnabled
	end
})
spawn(function()
	while wait(Sec) do
		pcall(function()
			if _G.Prehis_DB then
				if workspace:FindFirstChild("DinoBone") then
					for _, child in pairs(workspace:GetChildren()) do
						if child.Name == "DinoBone" then
							_tp(child.CFrame)
						end
					end
				end
			end
		end)
	end
end)

do
	Vocan = GRP_Prehistoric_Prehistoric_Island:AddToggle("Auto_Collect_Dragon_Eggs", {
		Text = "Auto Collect Dragon Eggs",
		Default = false,
		Callback = function(isAutoCollectDragonEggsEnabled)
			_G.Prehis_DE = isAutoCollectDragonEggsEnabled
		end
	})
end

spawn(function()
	while wait(Sec) do
		pcall(function()
			if _G.Prehis_DE then
				if workspace.Map.PrehistoricIsland.Core.SpawnedDragonEggs:FindFirstChild("DragonEgg") then
					_tp(workspace.Map.PrehistoricIsland.Core.SpawnedDragonEggs:FindFirstChild("DragonEgg").Molten.CFrame)
					fireproximityprompt(workspace.Map.PrehistoricIsland.Core.SpawnedDragonEggs.DragonEgg.Molten.ProximityPrompt, 30)
				end
			end
		end)
	end
end)

do
	Toggle = GRP_Prehistoric_Prehistoric_Island:AddToggle("Auto_Reset_When_Complete_Volcano", {
		Text = "Auto Reset When Complete Volcano",
		Default = false,
		Callback = function(isAutoResetWhenCompleteVolcanoEnabled)
			_G.ResetPH = isAutoResetWhenCompleteVolcanoEnabled
		end
	})
end

spawn(function()
	if wait(Sec) then
		repeat
			pcall(function()
				if _G.ResetPH then
					local TrialTeleport = workspace.Map.PrehistoricIsland:FindFirstChild("TrialTeleport")

					if TrialTeleport and TrialTeleport:FindFirstChild("TouchInterest") then
						plr.Character.Humanoid.Health = 0
					elseif workspace:FindFirstChild("DinoBone") then
						for _, child in pairs(workspace:GetChildren()) do
							if child.Name == "DinoBone" then
								_tp(child.CFrame)
							end
						end
					end
				end
			end)
		until not wait(Sec)
	end
end)
GRP_SeaEvent_Sea_Event_Setting_Sail = tabs.SeaEvent:AddLeftGroupbox("Sea Event / Setting Sail")
getgenv().SetSpeedBoat = 300
spawn(function()
	connectScoped(game:GetService("RunService").RenderStepped, function()
		if getgenv().SpeedBoat then
			local LocalPlayer = game:GetService("Players").LocalPlayer

			if LocalPlayer.Character then
				if LocalPlayer.Character:FindFirstChild("Humanoid") and LocalPlayer.Character.Humanoid.Sit then
					for _, child in pairs(game:GetService("Workspace").Boats:GetChildren()) do
						local VehicleSeat = child:FindFirstChildWhichIsA("VehicleSeat")

						if VehicleSeat then
							VehicleSeat.MaxSpeed = getgenv().SetSpeedBoat
						end
					end
				end
			end
		end
	end)
end)
GRP_SeaEvent_Sea_Event_Setting_Sail:AddButton({
	Text = "Remove Lighting Effect",
	Func = function()
		pcall(function()
			game.Lighting.BaseAtmosphere:Destroy()
		end)
	end
})

do
	GRP_SeaEvent_Sea_Event_Setting_Sail:AddToggle("Ship_Speed_Modifier", {
		Text = "Ship Speed Modifier",
		Default = false,
		Callback = function(isShipSpeedEnabled)
			getgenv().SpeedBoat = isShipSpeedEnabled
		end
	})
end

GRP_SeaEvent_Sea_Event_Setting_Sail:AddSlider({
	Text = "Ship Speed",
	Min = 0,
	Max = 1000,
	Default = 300,
	Rounding = 0,
	Callback = function(isAutoPressWEnabled)
		getgenv().SetSpeedBoat = isAutoPressWEnabled
	end
})

do
	GRP_SeaEvent_Sea_Event_Setting_Sail:AddToggle("Auto_Press_W", {
		Text = "Auto Press W",
		Default = false,
		Callback = function(isAutoPressWEnabledCurrent)
			getgenv().AutoPressW = isAutoPressWEnabledCurrent
		end
	})
end

do
	spawn(function()
		while wait() do
			pcall(function()
				if getgenv().AutoPressW then
					if game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Sit == true then
						game:GetService("VirtualInputManager"):SendKeyEvent(true, "W", true, game)
						task.wait(0.1)
						game:GetService("VirtualInputManager"):SendKeyEvent(false, "W", true, game)
					end
				end
			end)
		end
	end)
end

do
	GRP_SeaEvent_Sea_Event_Setting_Sail:AddToggle("No_Clip_Ship", {
		Text = "No Clip Ship",
		Default = false,
		Callback = function(isNoClipShipEnabled)
			getgenv().NoClipShip = isNoClipShipEnabled
		end
	})
end

do
	spawn(function()
		while wait() do
			pcall(function()
				for _, child in pairs(game:GetService("Workspace").Boats:GetChildren()) do
					for _, descendant in pairs(child:GetDescendants()) do
						if descendant:IsA("BasePart") then
							if getgenv().NoClipShip or getgenv().FindPrehistoric then
								descendant.CanCollide = false
							else
								descendant.CanCollide = true
							end
						end
					end
				end
			end)
		end
	end)
end

GRP_SeaEvent_Crafting_Items = tabs.SeaEvent:AddLeftGroupbox("Crafting Items")

do
	GRP_SeaEvent_Crafting_Items:AddButton({
		Text = "Craft SharkTooth",
		Func = function()
			replicated.Remotes.CommF_:InvokeServer("CraftItem", "Craft", "SharkTooth")
		end
	})
end

GRP_SeaEvent_Crafting_Items:AddButton({
	Text = "Craft TerrorJaw",
	Func = function()
		replicated.Remotes.CommF_:InvokeServer("CraftItem", "Craft", "TerrorJaw")
	end
})

do
	GRP_SeaEvent_Crafting_Items:AddButton({
		Text = "Craft SharkAnchor",
		Func = function()
			replicated.Remotes.CommF_:InvokeServer("CraftItem", "Craft", "SharkAnchor")
		end
	})
end

GRP_SeaEvent_Crafting_Items:AddButton({
	Text = "Craft LeviathanCrown",
	Func = function()
		replicated.Remotes.CommF_:InvokeServer("CraftItem", "Craft", "LeviathanCrown")
	end
})
GRP_SeaEvent_Crafting_Items:AddButton({
	Text = "Craft LeviathanShield",
	Func = function()
		replicated.Remotes.CommF_:InvokeServer("CraftItem", "Craft", "LeviathanShield")
	end
})

do
	GRP_SeaEvent_Crafting_Items:AddButton({
		Text = "Craft LeviathanBoat",
		Func = function()
			replicated.Remotes.CommF_:InvokeServer("CraftItem", "Craft", "LeviathanBoat")
		end
	})
end

GRP_SeaEvent_Crafting_Items:AddButton({
	Text = "Craft LegendaryScroll",
	Func = function()
		replicated.Remotes.CommF_:InvokeServer("CraftItem", "Craft", "LegendaryScroll")
	end
})

do
	GRP_SeaEvent_Crafting_Items:AddButton({
		Text = "Craft MythicalScroll",
		Func = function()
			replicated.Remotes.CommF_:InvokeServer("CraftItem", "Craft", "MythicalScroll")
		end
	})
end

GRP_SeaEvent_Choose_Sea_Event = tabs.SeaEvent:AddLeftGroupbox("Choose Sea Event")

do
	Q = GRP_SeaEvent_Choose_Sea_Event:AddDropdown("Select_Boats", {
		Text = "Select Boats",
		Values = {
			"Guardian",
			"PirateGrandBrigade",
			"MarineGrandBrigade",
			"PirateBrigade",
			"MarineBrigade",
			"PirateSloop",
			"MarineSloop",
			"Beast Hunter"
		},
		Default = 1,
		Callback = function(isSelectboatsEnabled)
			_G.SelectedBoat = isSelectboatsEnabled
		end
	})
end

GRP_SeaEvent_Choose_Sea_Event:AddButton({
	Text = "Buy Boats",
	Func = function()
		replicated.Remotes.CommF_:InvokeServer("BuyBoat", _G.SelectedBoat)
	end
})
Q = GRP_SeaEvent_Choose_Sea_Event:AddDropdown("Select_Sea_Level", {
	Text = "Select Sea Level",
	Values = {
		"Lv 1",
		"Lv 2",
		"Lv 3",
		"Lv 4",
		"Lv 5",
		"Lv 6",
		"Lv Infinite"
	},
	Default = 1,
	Callback = function(isAutoSailBoatEnabled)
		_G.DangerSc = isAutoSailBoatEnabled
	end
})
Q = GRP_SeaEvent_Choose_Sea_Event:AddToggle("Auto_Sail_Boat", {
	Text = "Auto Sail Boat",
	Default = false,
	Callback = function(isAutoSailBoatEnabledCurrent)
		_G.SailBoats = isAutoSailBoatEnabledCurrent
	end
})

do
	spawn(function()
		while wait() do
			if _G.SailBoats then
				pcall(function()
					local callbackEnemy = CheckBoat()

					if callbackEnemy then
						if (not CheckShark() or not _G.Shark) and (not CheckTerrorShark() or not _G.TerrorShark) and (not CheckFishCrew() or not _G.MobCrew) then
							if (not CheckPiranha() or not _G.Piranha) and (not CheckEnemiesBoat() or not _G.FishBoat) and (not CheckSeaBeast() or not _G.SeaBeast1) and (not _G.PGB or not CheckPirateGrandBrigade()) and (not _G.HCM or not CheckHauntedCrew()) and (not _G.Leviathan1 or not CheckLeviathan()) then
								if plr.Character.Humanoid.Sit == false then
									_tp(callbackEnemy.VehicleSeat.CFrame * CFrame.new(0, 1, 0))
								else
									if _G.DangerSc == "Lv 1" then
										CFrameSelectedZone = CFrame.new(-21998.375, 30.0006084, -682.309143)
									elseif _G.DangerSc == "Lv 2" then
										CFrameSelectedZone = CFrame.new(-26779.5215, 30.0005474, -822.858032)
									elseif _G.DangerSc == "Lv 3" then
										CFrameSelectedZone = CFrame.new(-31171.957, 30.0001011, -2256.93774)
									elseif _G.DangerSc == "Lv 4" then
										CFrameSelectedZone = CFrame.new(-34054.6875, 30.2187767, -2560.12012)
									elseif _G.DangerSc == "Lv 5" then
										CFrameSelectedZone = CFrame.new(-38887.5547, 30.0004578, -2162.99023)
									elseif _G.DangerSc == "Lv 6" then
										CFrameSelectedZone = CFrame.new(-44541.7617, 30.0003204, -1244.8584)
									elseif _G.DangerSc == "Lv Infinite" then
										CFrameSelectedZone = CFrame.new(-10000000, 31, 37016.25)
									end

									while true do
										wait()

										if (_G.FishBoat or not CheckEnemiesBoat()) and (_G.PGB or not CheckPirateGrandBrigade()) and (_G.TerrorShark or not CheckTerrorShark()) then
											_tp(CFrameSelectedZone)
										else
											_tp(CFrameSelectedZone * CFrame.new(0, 150, 0))
										end

										if _G.SailBoats ~= false and (not CheckShark() or not _G.Shark) and (not CheckTerrorShark() or not _G.TerrorShark) and (not CheckFishCrew() or not _G.MobCrew) and (not CheckPiranha() or not _G.Piranha) and (not CheckSeaBeast() or not _G.SeaBeast1) and (not CheckEnemiesBoat() or not _G.FishBoat) and (not _G.Leviathan1 or not CheckLeviathan()) and (not _G.HCM or not CheckHauntedCrew()) and (not _G.PGB or not CheckPirateGrandBrigade()) then
											if plr.Character:WaitForChild("Humanoid").Sit ~= false then
												continue
											end
										end

										break
									end

									plr.Character.Humanoid.Sit = false
								end
							end
						end
					elseif (not CheckShark() or not _G.Shark) and (not CheckTerrorShark() or not _G.TerrorShark) and (not CheckFishCrew() or not _G.MobCrew) and (not CheckPiranha() or not _G.Piranha) and (not CheckEnemiesBoat() or not _G.FishBoat) and (not CheckSeaBeast() or not _G.SeaBeast1) and (not _G.PGB or not CheckPirateGrandBrigade()) and (not _G.HCM or not CheckHauntedCrew()) and (not _G.Leviathan1 or not CheckLeviathan()) then
						local cFrame = CFrame.new(-16927.451, 9.086, 433.864)

						TeleportToTarget(cFrame)

						if (cFrame.Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10 then
							replicated.Remotes.CommF_:InvokeServer("BuyBoat", _G.SelectedBoat)
						end
					end
				end)
			end
		end
	end)
end

spawn(function()
	while wait(Sec) do
		pcall(function()
			for _, child in pairs(workspace.Boats:GetChildren()) do
				for _, descendant in pairs(child:GetDescendants()) do
					if descendant:IsA("BasePart") then
						if _G.SailBoats or _G.Prehis_Find or _G.FindMirage or _G.SailBoat_Hydra or _G.AutofindKitIs then
							descendant.CanCollide = false
						else
							descendant.CanCollide = true
						end
					end
				end
			end
		end)
	end
end)
GRP_SeaEvent_Entity_Sea_Event = tabs.SeaEvent:AddLeftGroupbox("Entity Sea Event")
GRP_SeaEvent_Entity_Sea_Event:AddToggle("Auto_Shark", {
	Text = "Auto Shark",
	Default = false,
	Callback = function(isAutoPiranhaEnabled)
		_G.Shark = isAutoPiranhaEnabled
	end
})
GRP_SeaEvent_Entity_Sea_Event:AddToggle("Auto_Piranha", {
	Text = "Auto Piranha",
	Default = false,
	Callback = function(isAutoTerrorSharkEnabled)
		_G.Piranha = isAutoTerrorSharkEnabled
	end
})
GRP_SeaEvent_Entity_Sea_Event:AddToggle("Auto_Terror_Shark", {
	Text = "Auto Terror Shark",
	Default = false,
	Callback = function(isAutoFishCrewMemberEnabled)
		_G.TerrorShark = isAutoFishCrewMemberEnabled
	end
})
GRP_SeaEvent_Entity_Sea_Event:AddToggle("Auto_Fish_Crew_Member", {
	Text = "Auto Fish Crew Member",
	Default = false,
	Callback = function(isAutoHauntedCrewMemberEnabled)
		_G.MobCrew = isAutoHauntedCrewMemberEnabled
	end
})

do
	GRP_SeaEvent_Entity_Sea_Event:AddToggle("Auto_Haunted_Crew_Member", {
		Text = "Auto Haunted Crew Member",
		Default = false,
		Callback = function(isAutoAttackPirategrandbrigadeEnabled)
			_G.HCM = isAutoAttackPirategrandbrigadeEnabled
		end
	})
end

do
	GRP_SeaEvent_Entity_Sea_Event:AddToggle("Auto_Attack_PirateGrandBrigade", {
		Text = "Auto Attack PirateGrandBrigade",
		Default = false,
		Callback = function(isAutoAttackFishBoatEnabled)
			_G.PGB = isAutoAttackFishBoatEnabled
		end
	})
end

GRP_SeaEvent_Entity_Sea_Event:AddToggle("Auto_Attack_Fish_Boat", {
	Text = "Auto Attack Fish Boat",
	Default = false,
	Callback = function(isAutoAttackSeaBeastEnabled)
		_G.FishBoat = isAutoAttackSeaBeastEnabled
	end
})

do
	GRP_SeaEvent_Entity_Sea_Event:AddToggle("Auto_Attack_Sea_Beast", {
		Text = "Auto Attack Sea Beast",
		Default = false,
		Callback = function(isAutoAttackSeaBeastEnabledCurrent)
			_G.SeaBeast1 = isAutoAttackSeaBeastEnabledCurrent
		end
	})
end

spawn(function()
	while wait() do
		pcall(function()
			if _G.Shark then
				local callbackEntriesRecord = { "Shark" }

				if CheckShark() then
					for _, child in pairs(workspace.Enemies:GetChildren()) do
						if table.find(callbackEntriesRecord, child.Name) and playerCollectionLatest.Alive(child) then
							while true do
								task.wait()
								playerCollectionLatest.Kill(child, _G.Shark)

								if _G.Shark == false then
									break
								elseif not child.Parent or child.Humanoid.Health <= 0 then
									break
								end
							end
						end
					end
				end
			end

			if _G.TerrorShark then
				local callbackEntries = { "Terrorshark" }

				if CheckTerrorShark() then
					for _, child in pairs(workspace.Enemies:GetChildren()) do
						if table.find(callbackEntries, child.Name) and playerCollectionLatest.Alive(child) then
							while true do
								task.wait()
								playerCollectionLatest.KillSea(child, _G.TerrorShark)

								if _G.TerrorShark == false then
									break
								elseif not child.Parent or child.Humanoid.Health <= 0 then
									break
								end
							end
						end
					end
				end
			end

			if _G.Piranha then
				local callbackEntriesReference = { "Piranha" }

				if CheckPiranha() then
					for _, child in pairs(workspace.Enemies:GetChildren()) do
						if table.find(callbackEntriesReference, child.Name) and playerCollectionLatest.Alive(child) then
							while true do
								task.wait()
								playerCollectionLatest.Kill(child, _G.Piranha)

								if _G.Piranha == false then
									break
								elseif not child.Parent or child.Humanoid.Health <= 0 then
									break
								end
							end
						end
					end
				end
			end

			if _G.MobCrew then
				local callbackEntriesResponse = { "Fish Crew Member" }

				if CheckFishCrew() then
					for _, child in pairs(workspace.Enemies:GetChildren()) do
						if table.find(callbackEntriesResponse, child.Name) and playerCollectionLatest.Alive(child) then
							while true do
								task.wait()
								playerCollectionLatest.Kill(child, _G.MobCrew)

								if _G.MobCrew == false then
									break
								elseif not child.Parent or child.Humanoid.Health <= 0 then
									break
								end
							end
						end
					end
				end
			end

			if _G.HCM then
				local callbackEntriesPayload = { "Haunted Crew Member" }

				if CheckHauntedCrew() then
					for _, child in pairs(workspace.Enemies:GetChildren()) do
						if table.find(callbackEntriesPayload, child.Name) and playerCollectionLatest.Alive(child) then
							while true do
								task.wait()
								playerCollectionLatest.Kill(child, _G.HCM)

								if _G.HCM == false then
									break
								elseif not child.Parent or child.Humanoid.Health <= 0 then
									break
								end
							end
						end
					end
				end
			end

			if _G.SeaBeast1 then
				if workspace.SeaBeasts:FindFirstChild("SeaBeast1") then
					for _, child in pairs(workspace.SeaBeasts:GetChildren()) do
						if child:FindFirstChild("HumanoidRootPart") and child:FindFirstChild("Health") and child.Health.Value > 0 then
							repeat
								task.wait()
								spawn(function()
									_tp(CFrame.new(child.HumanoidRootPart.Position.X, game:GetService("Workspace").Map["WaterBase-Plane"].Position.Y + 200, child.HumanoidRootPart.Position.Z))
								end)

								if plr:DistanceFromCharacter(child.HumanoidRootPart.CFrame.Position) <= 500 then
									AitSeaSkill_Custom = child.HumanoidRootPart.CFrame
									MousePos = AitSeaSkill_Custom.Position

									if CheckF() then
										weaponSc("Blox Fruit")
										Useskills("Blox Fruit", "Z")
										Useskills("Blox Fruit", "X")
										Useskills("Blox Fruit", "C")
									else
										Useskills("Melee", "Z")
										Useskills("Melee", "X")
										Useskills("Melee", "C")
										wait(0.1)
										Useskills("Sword", "Z")
										Useskills("Sword", "X")
										wait(0.1)
										Useskills("Blox Fruit", "Z")
										Useskills("Blox Fruit", "X")
										Useskills("Blox Fruit", "C")
										wait(0.1)
										Useskills("Gun", "Z")
										Useskills("Gun", "X")
									end
								end
							until _G.SeaBeast1 == false or not child:FindFirstChild("HumanoidRootPart") or not child.Parent or child.Health.Value <= 0
						end
					end
				end
			end

			if _G.Leviathan1 then
				if workspace.SeaBeasts:FindFirstChild("Leviathan") then
					for _, child in pairs(workspace.SeaBeasts:GetChildren()) do
						if child:FindFirstChild("HumanoidRootPart") and child:FindFirstChild("Leviathan Segment") and child:FindFirstChild("Health") and child.Health.Value > 0 then
							repeat
								task.wait()
								spawn(function()
									_tp(CFrame.new(child.HumanoidRootPart.Position.X, game:GetService("Workspace").Map["WaterBase-Plane"].Position.Y + 200, child.HumanoidRootPart.Position.Z))
								end)

								if plr:DistanceFromCharacter(child.HumanoidRootPart.CFrame.Position) <= 500 then
									MousePos = child:FindFirstChild("Leviathan Segment").Position

									if CheckF() then
										weaponSc("Blox Fruit")
										Useskills("Blox Fruit", "Z")
										Useskills("Blox Fruit", "X")
										Useskills("Blox Fruit", "C")
									else
										Useskills("Melee", "Z")
										Useskills("Melee", "X")
										Useskills("Melee", "C")
										wait(0.1)
										Useskills("Sword", "Z")
										Useskills("Sword", "X")
										wait(0.1)
										Useskills("Blox Fruit", "Z")
										Useskills("Blox Fruit", "X")
										Useskills("Blox Fruit", "C")
										wait(0.1)
										Useskills("Gun", "Z")
										Useskills("Gun", "X")
									end
								end
							until _G.Leviathan1 == false or not child:FindFirstChild("HumanoidRootPart") or not child.Parent or child.Health.Value <= 0
						end
					end
				end
			end

			if _G.FishBoat and CheckEnemiesBoat() then
				for _, child in pairs(workspace.Enemies:GetChildren()) do
					if child:FindFirstChild("Health") and child.Health.Value > 0 and child:FindFirstChild("VehicleSeat") then
						repeat
							task.wait()
							spawn(function()
								if child.Name == "FishBoat" then
									_tp(child.Engine.CFrame * CFrame.new(0, -50, -25))
								end
							end)

							if plr:DistanceFromCharacter(child.Engine.CFrame.Position) <= 150 then
								AitSeaSkill_Custom = child.Engine.CFrame
								MousePos = AitSeaSkill_Custom.Position

								if CheckF() then
									weaponSc("Blox Fruit")
									Useskills("Blox Fruit", "Z")
									Useskills("Blox Fruit", "X")
									Useskills("Blox Fruit", "C")
								else
									Useskills("Melee", "Z")
									Useskills("Melee", "X")
									Useskills("Melee", "C")
									wait(0.1)
									Useskills("Sword", "Z")
									Useskills("Sword", "X")
									wait(0.1)
									Useskills("Blox Fruit", "Z")
									Useskills("Blox Fruit", "X")
									Useskills("Blox Fruit", "C")
									wait(0.1)
									Useskills("Gun", "Z")
									Useskills("Gun", "X")
								end
							end
						until _G.FishBoat == false or not child:FindFirstChild("VehicleSeat") or child.Health.Value <= 0
					end
				end
			end

			if _G.PGB and CheckPirateGrandBrigade() then
				for _, child in pairs(workspace.Enemies:GetChildren()) do
					if child:FindFirstChild("Health") and child.Health.Value > 0 and child:FindFirstChild("VehicleSeat") then
						repeat
							task.wait()
							spawn(function()
								if child.Name == "PirateBrigade" then
									_tp(child.Engine.CFrame * CFrame.new(0, -30, -10))
								elseif child.Name == "PirateGrandBrigade" then
									_tp(child.Engine.CFrame * CFrame.new(0, -50, -50))
								end
							end)

							if plr:DistanceFromCharacter(child.Engine.CFrame.Position) <= 150 then
								AitSeaSkill_Custom = child.Engine.CFrame
								MousePos = AitSeaSkill_Custom.Position

								if CheckF() then
									weaponSc("Blox Fruit")
									Useskills("Blox Fruit", "Z")
									Useskills("Blox Fruit", "X")
									Useskills("Blox Fruit", "C")
								else
									Useskills("Melee", "Z")
									Useskills("Melee", "X")
									Useskills("Melee", "C")
									wait(0.1)
									Useskills("Sword", "Z")
									Useskills("Sword", "X")
									wait(0.1)
									Useskills("Blox Fruit", "Z")
									Useskills("Blox Fruit", "X")
									Useskills("Blox Fruit", "C")
									wait(0.1)
									Useskills("Gun", "Z")
									Useskills("Gun", "X")
								end
							end
						until _G.PGB == false or not child:FindFirstChild("VehicleSeat") or child.Health.Value <= 0
					end
				end
			end
		end)
	end
end)
GRP_SeaEvent_Kitsune_Island_Event = tabs.SeaEvent:AddLeftGroupbox("Kitsune Island / Event")

do
	local grpSeaeventKitsuneIslandEventData = GRP_SeaEvent_Kitsune_Island_Event:AddLabel("")

	spawn(function()
		while wait(0.2) do
			if not workspace.Map:FindFirstChild("KitsuneIsland") then
				if not workspace._WorldOrigin.Locations:FindFirstChild("Kitsune Island") then
					grpSeaeventKitsuneIslandEventData:SetText("Kitsune Island : False")

					continue
				end
			end

			grpSeaeventKitsuneIslandEventData:SetText("Kitsune Island : True")
		end
	end)
end

GRP_SeaEvent_Kitsune_Island_Event:AddToggle("Auto_Find_Kitsune_Island", {
	Text = "Auto Find Kitsune Island",
	Default = false,
	Callback = function(isAutoFindKitsuneIslandEnabled)
		_G.AutofindKitIs = isAutoFindKitsuneIslandEnabled
	end
})
spawn(function()
	while wait() do
		if _G.AutofindKitIs then
			pcall(function()
				if workspace._WorldOrigin.Locations:FindFirstChild("Kitsune Island", true) then
					_tp(workspace._WorldOrigin.Locations:FindFirstChild("Kitsune Island").CFrame * CFrame.new(0, 500, 0))
				else
					local callbackPlayerDataCallbackCandidate = CheckBoat()

					if callbackPlayerDataCallbackCandidate then
						if plr.Character.Humanoid.Sit == false then
							_tp(callbackPlayerDataCallbackCandidate.VehicleSeat.CFrame * CFrame.new(0, 1, 0))
						else
							local cFrame = CFrame.new(-10000000, 31, 37016.25)

							while true do
								wait()

								if CheckEnemiesBoat() or CheckTerrorShark() or CheckPirateGrandBrigade() then
									_tp(CFrame.new(-10000000, 150, 37016.25))
								else
									_tp(CFrame.new(-10000000, 31, 37016.25))
								end

								if _G.AutofindKitIs and not ((cFrame.Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10) then
									if not (workspace._WorldOrigin.Locations:FindFirstChild("Kitsune Island") or plr.Character.Humanoid.Sit == false) then
										continue
									end
								end

								break
							end

							plr.Character.Humanoid.Sit = false
						end
					else
						local cFrame = CFrame.new(-16927.451, 9.086, 433.864)

						TeleportToTarget(cFrame)

						if (cFrame.Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10 then
							replicated.Remotes.CommF_:InvokeServer("BuyBoat", _G.SelectedBoat)
						end
					end
				end
			end)
		end
	end
end)

do
	GRP_SeaEvent_Kitsune_Island_Event:AddToggle("Auto_Teleport_to_Shrine_Actived", {
		Text = "Auto Teleport to Shrine Actived",
		Default = false,
		Callback = function(isAutoTeleportToShrineActivedEnabled)
			_G.tweenShrine = isAutoTeleportToShrineActivedEnabled
		end
	})
end

do
	spawn(function()
		while wait(0.1) do
			if _G.tweenShrine then
				pcall(function()
					local KitsuneIsland = workspace.Map:FindFirstChild("KitsuneIsland") or game.Workspace._WorldOrigin.Locations:FindFirstChild("Kitsune Island")
					local ShrineActive = KitsuneIsland:FindFirstChild("ShrineActive")

					if ShrineActive then
						local next_ = next
						local descendants, descendantInstances = ShrineActive:GetDescendants()

						for _, playervalueaiPlayerData in next_, descendants, descendantInstances do
							if playervalueaiPlayerData:IsA("BasePart") then
								if playervalueaiPlayerData.Name:find("NeonShrinePart") then
									replicated.Modules.Net:FindFirstChild("RE/TouchKitsuneStatue"):FireServer()

									while true do
										wait()
										_tp(playervalueaiPlayerData.CFrame * CFrame.new(0, 2, 0))

										if _G.tweenShrine == false then
											break
										elseif not KitsuneIsland then
											break
										end
									end
								end
							end
						end
					else
						_tp(workspace._WorldOrigin.Locations:FindFirstChild("Kitsune Island").CFrame * CFrame.new(0, 500, 0))
					end
				end)
			end
		end
	end)
end

do
	GRP_SeaEvent_Kitsune_Island_Event:AddToggle("Auto_Collect_Azure_Ember", {
		Text = "Auto Collect Azure Ember",
		Default = false,
		Callback = function(isAutoCollectAzureEmberEnabled)
			_G.Collect_Ember = isAutoCollectAzureEmberEnabled
		end
	})
end

spawn(function()
	while wait(0.1) do
		if _G.Collect_Ember then
			pcall(function()
				if workspace:WaitForChild("AttachedAzureEmber") then
					notween(workspace:WaitForChild("EmberTemplate"):FindFirstChild("Part").CFrame)
				else
					if workspace:WaitForChild("EmberTemplate") then
						notween(workspace:WaitForChild("EmberTemplate"):FindFirstChild("Part").CFrame)

						return
					end

					_tp(workspace._WorldOrigin.Locations:FindFirstChild("Kitsune Island").CFrame * CFrame.new(0, 500, 0))
					replicated.Modules.Net["RF/KitsuneStatuePray"]:InvokeServer()
				end
			end)
		end
	end
end)

do
	GRP_SeaEvent_Kitsune_Island_Event:AddToggle("Auto_Trade_Azure_Ember", {
		Text = "Auto Trade Azure Ember",
		Default = false,
		Callback = function(isAutoTradeAzureEmberEnabled)
			_G.Trade_Ember = isAutoTradeAzureEmberEnabled
		end
	})
end

do
	spawn(function()
		while wait(0.1) do
			if _G.Trade_Ember then
				pcall(function()
					if workspace._WorldOrigin.Locations:FindFirstChild("Kitsune Island", true) then
						replicated.Modules.Net:FindFirstChild("RF/KitsuneStatuePray"):InvokeServer()
					end
				end)
			end
		end
	end)
end

GRP_SeaEvent_Kitsune_Island_Event:AddButton({
	Text = "Trade Items Azure",
	Func = function()
		if replicated.Modules and replicated.Modules.Net then
			local RFKitsuneStatuePray = replicated.Modules.Net:FindFirstChild("RF/KitsuneStatuePray")

			if RFKitsuneStatuePray then
				RFKitsuneStatuePray:InvokeServer()
			end
		end
	end
})

do
	GRP_SeaEvent_Kitsune_Island_Event:AddButton({
		Text = "Talk with kitsune statue",
		Func = function()
			if replicated.Modules and replicated.Modules.Net then
				local RETouchKitsuneStatue = replicated.Modules.Net:FindFirstChild("RE/TouchKitsuneStatue")

				if RETouchKitsuneStatue then
					RETouchKitsuneStatue:FireServer()
				end
			end
		end
	})
end

GRP_SeaEvent_Frozen_Dimension_Event = tabs.SeaEvent:AddLeftGroupbox("Frozen Dimension Event")

do
	local grpSeaeventFrozenDimensionEventData = GRP_SeaEvent_Frozen_Dimension_Event:AddLabel("")

	spawn(function()
		pcall(function()
			while wait(0.2) do
				if workspace._WorldOrigin.Locations:FindFirstChild("Frozen Dimension") then
					grpSeaeventFrozenDimensionEventData:SetText("Frozen Dimension : True")
				else
					grpSeaeventFrozenDimensionEventData:SetText("Frozen Dimension : False")
				end
			end
		end)
	end)
end

do
	local grpSeaeventFrozenDimensionEventDataState = GRP_SeaEvent_Frozen_Dimension_Event:AddLabel("")

	spawn(function()
		while wait(0.2) do
			pcall(function()
				local serverResponse = string.match(replicated.Remotes.CommF_:InvokeServer("InfoLeviathan", "1"), "%d+")

				if serverResponse then
					grpSeaeventFrozenDimensionEventDataState:SetText("Spy Leviathan : " .. tostring(serverResponse))

					if tonumber(serverResponse) == 5 then
						grpSeaeventFrozenDimensionEventDataState:SetText("Spy Leviathan : Already Done!!")
					end
				end
			end)
		end
	end)
end

GRP_SeaEvent_Frozen_Dimension_Event:AddButton({
	Text = "Buy Spy",
	Func = function()
		replicated.Remotes.CommF_:InvokeServer("InfoLeviathan", "2")
	end
})
GRP_SeaEvent_Frozen_Dimension_Event:AddToggle("Auto_Teleport_Frozen_Dimension", {
	Text = "Auto Teleport Frozen Dimension",
	Default = false,
	Callback = function(isAutoTeleportFrozenDimensionEnabled)
		_G.FrozenTP = isAutoTeleportFrozenDimensionEnabled
	end
})
spawn(function()
	while wait(0.1) do
		if _G.FrozenTP then
			pcall(function()
				if workspace.Map:FindFirstChild("LeviathanGate") then
					_tp(workspace.Map.LeviathanGate.CFrame)
					replicated:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("OpenLeviathanGate")
				end
			end)
		end
	end
end)

do
	GRP_SeaEvent_Frozen_Dimension_Event:AddToggle("Auto_Drive_To_Hydra_Island", {
		Text = "Auto Drive To Hydra Island",
		Default = false,
		Callback = function(isAutoDriveToHydraIslandEnabled)
			_G.SailBoat_Hydra = isAutoDriveToHydraIslandEnabled
		end
	})
end

spawn(function()
	while wait() do
		if _G.SailBoat_Hydra then
			pcall(function()
				local callbackPlayerDataCallbackResponse = CheckBoat()

				if callbackPlayerDataCallbackResponse then
					if plr.Character.Humanoid.Sit == false then
						_tp(callbackPlayerDataCallbackResponse.VehicleSeat.CFrame * CFrame.new(0, 1, 0))
					else
						while true do
							wait()

							if CheckEnemiesBoat() or CheckPirateGrandBrigade() or CheckTerrorShark() then
								_tp(CFrame.new(5433, 150, 290))
							else
								_tp(CFrame.new(5433, 35, 290))
							end

							if _G.SailBoat_Hydra ~= false then
								if plr.Character:WaitForChild("Humanoid").Sit ~= false then
									continue
								end
							end

							break
						end

						plr.Character.Humanoid.Sit = false
					end
				else
					local cFrame = CFrame.new(-16927.451, 9.086, 433.864)

					TeleportToTarget(cFrame)

					if (cFrame.Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10 then
						replicated.Remotes.CommF_:InvokeServer("BuyBoat", _G.SelectedBoat)
					end
				end
			end)
		end
	end
end)

do
	GRP_SeaEvent_Frozen_Dimension_Event:AddToggle("Auto_Attack_Leviathan", {
		Text = "Auto Attack Leviathan",
		Default = false,
		Callback = function(isAutoAttackLeviathanEnabled)
			_G.Leviathan1 = isAutoAttackLeviathanEnabled
		end
	})
end

GRP_Esp_Esp = tabs.Esp:AddLeftGroupbox("Esp")

do
	isnil = function(isAutoAttackLeviathanEnabledCurrent)
		return isAutoAttackLeviathanEnabledCurrent == nil
	end
end

local function playervaluesecondaryPlayerData(valueArgumentNext)
	return math.floor(tonumber(valueArgumentNext) + 0.5)
end

Number = math.random(1, 1000000)

local LocalPlayer = game:GetService("Players").LocalPlayer
local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
local Team = LocalPlayer.Team

EspPly = function()
	local children, childInstancesSelected = game.Players:GetChildren()

	for _, playervalueaiPlayerData in next, children, childInstancesSelected do
		pcall(function()
			if not isnil(playervalueaiPlayerData.Character) then
				if PlayerEsp then
					local ok = isnil(playervalueaiPlayerData.Character.Head)

					if not ok then
						ok = playervalueaiPlayerData.Character.Head:FindFirstChild("NameEsp" .. Number)
					end

					if ok then
						if playervalueaiPlayerData.Character.Head:FindFirstChild("NameEsp" .. Number) then
							playervalueaiPlayerData.Character.Head["NameEsp" .. Number].TextLabel.Text = playervalueaiPlayerData.Name .. " | " .. playervaluesecondaryPlayerData((LocalPlayer.Character.Head.Position - playervalueaiPlayerData.Character.Head.Position).Magnitude / 3) .. " M\nHealth : " .. playervaluesecondaryPlayerData(playervalueaiPlayerData.Character.Humanoid.Health * 100 / playervalueaiPlayerData.Character.Humanoid.MaxHealth) .. "%"
						end
					else
						local BillboardGui = Instance.new("BillboardGui", playervalueaiPlayerData.Character.Head)

						BillboardGui.Name = "NameEsp" .. Number
						BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
						BillboardGui.Size = UDim2.new(1, 200, 1, 30)
						BillboardGui.Adornee = playervalueaiPlayerData.Character.Head
						BillboardGui.AlwaysOnTop = true

						local TextLabel = Instance.new("TextLabel", BillboardGui)

						TextLabel.Font = Enum.Font.Code
						TextLabel.FontSize = "Size14"
						TextLabel.TextWrapped = true
						TextLabel.Text = playervalueaiPlayerData.Name .. " \n" .. playervaluesecondaryPlayerData((LocalPlayer.Character.Head.Position - playervalueaiPlayerData.Character.Head.Position).Magnitude / 3) .. " M"
						TextLabel.Size = UDim2.new(1, 0, 1, 0)
						TextLabel.TextYAlignment = "Top"
						TextLabel.BackgroundTransparency = 1
						TextLabel.TextStrokeTransparency = 0.5

						if playervalueaiPlayerData.Team == Team then
							TextLabel.TextColor3 = Color3.new(0, 0, 254)
						else
							TextLabel.TextColor3 = Color3.new(255, 0, 0)
						end
					end
				elseif playervalueaiPlayerData.Character.Head:FindFirstChild("NameEsp" .. Number) then
					playervalueaiPlayerData.Character.Head:FindFirstChild("NameEsp" .. Number):Destroy()
				end
			end
		end)
	end
end
LocationEsp = function()
	local children, childInstancesActive = workspace._WorldOrigin.Locations:GetChildren()

	for _, playervalueaiPlayerData in next, children, childInstancesActive do
		pcall(function()
			if IslandESP then
				if playervalueaiPlayerData.Name ~= "Sea" then
					if playervalueaiPlayerData:FindFirstChild("NameEsp") then
						playervalueaiPlayerData.NameEsp.TextLabel.Text = playervalueaiPlayerData.Name .. "   \n" .. playervaluesecondaryPlayerData((LocalPlayer.Character.Head.Position - playervalueaiPlayerData.Position).Magnitude / 3) .. " M"
					else
						local BillboardGui = Instance.new("BillboardGui", playervalueaiPlayerData)

						BillboardGui.Name = "NameEsp"
						BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
						BillboardGui.Size = UDim2.new(1, 200, 1, 30)
						BillboardGui.Adornee = playervalueaiPlayerData
						BillboardGui.AlwaysOnTop = true

						local TextLabel = Instance.new("TextLabel", BillboardGui)

						TextLabel.Font = Enum.Font.Code
						TextLabel.FontSize = "Size14"
						TextLabel.TextWrapped = true
						TextLabel.Size = UDim2.new(1, 0, 1, 0)
						TextLabel.TextYAlignment = "Top"
						TextLabel.BackgroundTransparency = 1
						TextLabel.TextStrokeTransparency = 0.5
						TextLabel.TextColor3 = Color3.fromRGB(98, 252, 252)
						TextLabel.Text = playervalueaiPlayerData.Name .. "   \n" .. playervaluesecondaryPlayerData((LocalPlayer.Character.Head.Position - playervalueaiPlayerData.Position).Magnitude / 3) .. " M"
					end
				end
			elseif playervalueaiPlayerData:FindFirstChild("NameEsp") then
				playervalueaiPlayerData:FindFirstChild("NameEsp"):Destroy()
			end
		end)
	end
end
DevEsp = function()
	local children, childInstancesTarget = workspace:GetChildren()

	for _, playervalueaiPlayerData in next, children, childInstancesTarget do
		pcall(function()
			if DevilFruitESP then
				if string.find(playervalueaiPlayerData.Name, "Fruit") then
					if playervalueaiPlayerData.Handle:FindFirstChild("NameEsp" .. Number) then
						playervalueaiPlayerData.Handle["NameEsp" .. Number].TextLabel.Text = "[" .. playervalueaiPlayerData.Name .. "]" .. "   \n" .. playervaluesecondaryPlayerData((LocalPlayer.Character.Head.Position - playervalueaiPlayerData.Handle.Position).Magnitude / 3) .. " M"
					else
						local BillboardGui = Instance.new("BillboardGui", playervalueaiPlayerData.Handle)

						BillboardGui.Name = "NameEsp" .. Number
						BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
						BillboardGui.Size = UDim2.new(1, 200, 1, 30)
						BillboardGui.Adornee = playervalueaiPlayerData.Handle
						BillboardGui.AlwaysOnTop = true

						local TextLabel = Instance.new("TextLabel", BillboardGui)

						TextLabel.Font = Enum.Font.Code
						TextLabel.FontSize = "Size14"
						TextLabel.TextWrapped = true
						TextLabel.Size = UDim2.new(1, 0, 1, 0)
						TextLabel.TextYAlignment = "Top"
						TextLabel.BackgroundTransparency = 1
						TextLabel.TextStrokeTransparency = 0.5
						TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
						TextLabel.Text = playervalueaiPlayerData.Name .. " \n" .. playervaluesecondaryPlayerData((LocalPlayer.Character.Head.Position - playervalueaiPlayerData.Handle.Position).Magnitude / 3) .. " M"
					end
				end
			elseif playervalueaiPlayerData:FindFirstChild("Handle") then
				if playervalueaiPlayerData.Handle:FindFirstChild("NameEsp" .. Number) then
					playervalueaiPlayerData.Handle:FindFirstChild("NameEsp" .. Number):Destroy()
				end
			end
		end)
	end
end
flowerEsp = function()
	for _, child in pairs(workspace:GetChildren()) do
		pcall(function()
			if child.Name == "Flower2" or child.Name == "Flower1" then
				if FlowerESP then
					if child:FindFirstChild("NameEsp" .. Number) then
						child["NameEsp" .. Number].TextLabel.Text = child.Name .. "   \n" .. playervaluesecondaryPlayerData((LocalPlayer.Character.Head.Position - child.Position).Magnitude / 3) .. " M"
					else
						local BillboardGui = Instance.new("BillboardGui", child)

						BillboardGui.Name = "NameEsp" .. Number
						BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
						BillboardGui.Size = UDim2.new(1, 200, 1, 30)
						BillboardGui.Adornee = child
						BillboardGui.AlwaysOnTop = true

						local TextLabel = Instance.new("TextLabel", BillboardGui)

						TextLabel.Font = Enum.Font.Code
						TextLabel.FontSize = "Size14"
						TextLabel.TextWrapped = true
						TextLabel.Size = UDim2.new(1, 0, 1, 0)
						TextLabel.TextYAlignment = "Top"
						TextLabel.BackgroundTransparency = 1
						TextLabel.TextStrokeTransparency = 0.5
						TextLabel.TextColor3 = Color3.fromRGB(88, 214, 252)

						if child.Name == "Flower1" then
							TextLabel.Text = "Blue Flower" .. " \n" .. playervaluesecondaryPlayerData((LocalPlayer.Character.Head.Position - child.Position).Magnitude / 3) .. " M"
						elseif child.Name == "Flower2" then
							TextLabel.Text = "Red Flower" .. " \n" .. playervaluesecondaryPlayerData((LocalPlayer.Character.Head.Position - child.Position).Magnitude / 3) .. " M"
						end
					end
				elseif child:FindFirstChild("NameEsp" .. Number) then
					child:FindFirstChild("NameEsp" .. Number):Destroy()
				end
			end
		end)
	end
end
EventIslandEsp = function()
	for _, child in pairs(workspace._WorldOrigin.Locations:GetChildren()) do
		pcall(function()
			if EspEventIsland then
				if child.Name == "Mirage Island" or child.Name == "Prehistoric Island" or child.Name == "Kitsune Island" then
					if child:FindFirstChild("NameEsp") then
						child.NameEsp.TextLabel.Text = child.Name .. "   \n" .. playervaluesecondaryPlayerData((LocalPlayer.Character.Head.Position - child.Position).Magnitude / 3) .. " M"
					else
						local BillboardGui = Instance.new("BillboardGui", child)

						BillboardGui.Name = "NameEsp"
						BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
						BillboardGui.Size = UDim2.new(1, 200, 1, 30)
						BillboardGui.Adornee = child
						BillboardGui.AlwaysOnTop = true

						local TextLabel = Instance.new("TextLabel", BillboardGui)

						TextLabel.Font = "Code"
						TextLabel.FontSize = "Size14"
						TextLabel.TextWrapped = true
						TextLabel.Size = UDim2.new(1, 0, 1, 0)
						TextLabel.TextYAlignment = "Top"
						TextLabel.BackgroundTransparency = 1
						TextLabel.TextStrokeTransparency = 0.5
						TextLabel.TextColor3 = Color3.fromRGB(80, 245, 245)
						TextLabel.Text = child.Name .. "   \n" .. playervaluesecondaryPlayerData((LocalPlayer.Character.Head.Position - child.Position).Magnitude / 3) .. " M"
					end
				end
			elseif child:FindFirstChild("NameEsp") then
				child:FindFirstChild("NameEsp"):Destroy()
			end
		end)
	end
end
gearEsp = function()
	local MysticIsland = workspace.Map:FindFirstChild("MysticIsland")

	for _, descendant in pairs(MysticIsland:GetDescendants()) do
		pcall(function()
			if ESPGear then
				if descendant.Name == "Part" and descendant.Material == Enum.Material.Neon then
					if descendant:FindFirstChild("NameEsp") then
						descendant.NameEsp.TextLabel.Text = "Gear" .. "   \n" .. playervaluesecondaryPlayerData((LocalPlayer.Character.Head.Position - descendant.Position).Magnitude / 3) .. " M"
					else
						local BillboardGui = Instance.new("BillboardGui", descendant)

						BillboardGui.Name = "NameEsp"
						BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
						BillboardGui.Size = UDim2.new(1, 200, 1, 30)
						BillboardGui.Adornee = descendant
						BillboardGui.AlwaysOnTop = true

						local TextLabel = Instance.new("TextLabel", BillboardGui)

						TextLabel.Font = "Code"
						TextLabel.FontSize = "Size14"
						TextLabel.TextWrapped = true
						TextLabel.Size = UDim2.new(1, 0, 1, 0)
						TextLabel.TextYAlignment = "Top"
						TextLabel.BackgroundTransparency = 1
						TextLabel.TextStrokeTransparency = 0.5
						TextLabel.TextColor3 = Color3.fromRGB(80, 245, 245)
						TextLabel.Text = "Gear" .. "   \n" .. playervaluesecondaryPlayerData((LocalPlayer.Character.Head.Position - descendant.Position).Magnitude / 3) .. " M"
					end
				end
			elseif descendant:FindFirstChild("NameEsp") then
				descendant:FindFirstChild("NameEsp"):Destroy()
			end
		end)
	end
end
AdvanFruitEsp = function()
	if advanEsp then
		for _, child in pairs(ReplicatedStorage2.NPCs:GetChildren()) do
			if child.Name == "Advanced Fruit Dealer" then
				if not workspace:FindFirstChild("Adv") then
					Adv = Instance.new("Part")
					Adv.Name = "Adv"
					Adv.Transparency = 1
					Adv.Size = Vector3.new(1, 1, 1)
					Adv.Anchored = true
					Adv.CanCollide = false
					Adv.Parent = workspace
					Adv.CFrame = child.HumanoidRootPart.CFrame
				elseif workspace:FindFirstChild("Adv") then
					if Adv:FindFirstChild("NameEsp") then
						Adv.NameEsp.TextLabel.Text = child.Name .. "   \n" .. playervaluesecondaryPlayerData((LocalPlayer.Character.Head.Position - child.HumanoidRootPart.Position).Magnitude / 3) .. " M"
					else
						local BillboardGui = Instance.new("BillboardGui", Adv)

						BillboardGui.Name = "NameEsp"
						BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
						BillboardGui.Size = UDim2.new(1, 200, 1, 30)
						BillboardGui.Adornee = Adv
						BillboardGui.AlwaysOnTop = true

						local TextLabel = Instance.new("TextLabel", BillboardGui)

						TextLabel.Font = "Code"
						TextLabel.FontSize = "Size14"
						TextLabel.TextWrapped = true
						TextLabel.Size = UDim2.new(1, 0, 1, 0)
						TextLabel.TextYAlignment = "Top"
						TextLabel.BackgroundTransparency = 1
						TextLabel.TextStrokeTransparency = 0.5
						TextLabel.TextColor3 = Color3.fromRGB(80, 245, 245)
						TextLabel.Text = child.Name .. "   \n" .. playervaluesecondaryPlayerData((LocalPlayer.Character.Head.Position - child.HumanoidRootPart.Position).Magnitude / 3) .. " M"
					end
				end
			end
		end
	elseif workspace:FindFirstChild("Adv") then
		workspace:FindFirstChild("Adv"):Destroy()
	end
end
HakiClorEsp = function()
	if ColorEsp then
		for _, child in pairs(ReplicatedStorage2.NPCs:GetChildren()) do
			if child.Name == "Barista Cousin" then
				if not workspace:FindFirstChild("Gay") then
					Gay = Instance.new("Part")
					Gay.Name = "Gay"
					Gay.Transparency = 1
					Gay.Size = Vector3.new(1, 1, 1)
					Gay.Anchored = true
					Gay.CanCollide = false
					Gay.Parent = workspace
					Gay.CFrame = child.HumanoidRootPart.CFrame
				elseif workspace:FindFirstChild("Gay") then
					if Gay:FindFirstChild("NameEsp") then
						Gay.NameEsp.TextLabel.Text = child.Name .. "   \n" .. playervaluesecondaryPlayerData((LocalPlayer.Character.Head.Position - child.HumanoidRootPart.Position).Magnitude / 3) .. " M"
					else
						local BillboardGui = Instance.new("BillboardGui", Gay)

						BillboardGui.Name = "NameEsp"
						BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
						BillboardGui.Size = UDim2.new(1, 200, 1, 30)
						BillboardGui.Adornee = Gay
						BillboardGui.AlwaysOnTop = true

						local TextLabel = Instance.new("TextLabel", BillboardGui)

						TextLabel.Font = "Code"
						TextLabel.FontSize = "Size14"
						TextLabel.TextWrapped = true
						TextLabel.Size = UDim2.new(1, 0, 1, 0)
						TextLabel.TextYAlignment = "Top"
						TextLabel.BackgroundTransparency = 1
						TextLabel.TextStrokeTransparency = 0.5
						TextLabel.TextColor3 = Color3.fromRGB(80, 245, 245)
						TextLabel.Text = child.Name .. "   \n" .. playervaluesecondaryPlayerData((LocalPlayer.Character.Head.Position - child.HumanoidRootPart.Position).Magnitude / 3) .. " M"
					end
				end
			end
		end
	elseif workspace:FindFirstChild("Gay") then
		workspace:FindFirstChild("Gay"):Destroy()
	end
end
LegenSword = function()
	if LegenS then
		for _, child in pairs(ReplicatedStorage2.NPCs:GetChildren()) do
			if child.Name == "Legendary Sword Dealer" then
				if not workspace:FindFirstChild("Lgd") then
					Lgd = Instance.new("Part")
					Lgd.Name = "Lgd"
					Lgd.Transparency = 1
					Lgd.Size = Vector3.new(1, 1, 1)
					Lgd.Anchored = true
					Lgd.CanCollide = false
					Lgd.Parent = workspace
					Lgd.CFrame = child.HumanoidRootPart.CFrame
				elseif workspace:FindFirstChild("Lgd") then
					if Lgd:FindFirstChild("NameEsp") then
						Lgd.NameEsp.TextLabel.Text = child.Name .. "   \n" .. playervaluesecondaryPlayerData((LocalPlayer.Character.Head.Position - child.HumanoidRootPart.Position).Magnitude / 3) .. " M"
					else
						local BillboardGui = Instance.new("BillboardGui", Lgd)

						BillboardGui.Name = "NameEsp"
						BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
						BillboardGui.Size = UDim2.new(1, 200, 1, 30)
						BillboardGui.Adornee = Lgd
						BillboardGui.AlwaysOnTop = true

						local TextLabel = Instance.new("TextLabel", BillboardGui)

						TextLabel.Font = "Code"
						TextLabel.FontSize = "Size14"
						TextLabel.TextWrapped = true
						TextLabel.Size = UDim2.new(1, 0, 1, 0)
						TextLabel.TextYAlignment = "Top"
						TextLabel.BackgroundTransparency = 1
						TextLabel.TextStrokeTransparency = 0.5
						TextLabel.TextColor3 = Color3.fromRGB(80, 245, 245)
						TextLabel.Text = child.Name .. "   \n" .. playervaluesecondaryPlayerData((LocalPlayer.Character.Head.Position - child.HumanoidRootPart.Position).Magnitude / 3) .. " M"
					end
				end
			end
		end
	elseif workspace:FindFirstChild("Lgd") then
		workspace:FindFirstChild("Lgd"):Destroy()
	end
end

do
	ChestEsp = function()
		if ChestESP then
			local tagged = game:GetService("CollectionService"):GetTagged("_ChestTagged")

			for _, playervalueaiPlayerData in ipairs(tagged) do
				pcall(function()
					local Magnitude = (playervalueaiPlayerData:GetPivot().Position - LocalPlayer.Character.Head.Position).Magnitude

					playervalueaiPlayerData:GetFullName():gsub("[^%w_]", "_")

					local ChestEspAttachment = playervalueaiPlayerData:FindFirstChild("ChestEspAttachment")

					if not ChestEspAttachment then
						local Attachment = Instance.new("Attachment")

						Attachment.Name = "ChestEspAttachment"
						Attachment.Parent = playervalueaiPlayerData
						Attachment.Position = Vector3.new(0, 3, 0)

						local BillboardGui = Instance.new("BillboardGui")

						BillboardGui.Name = "NameEsp"
						BillboardGui.Size = UDim2.new(0, 200, 0, 30)
						BillboardGui.Adornee = Attachment
						BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
						BillboardGui.AlwaysOnTop = true
						BillboardGui.Parent = Attachment

						local TextLabel = Instance.new("TextLabel")

						TextLabel.Font = Enum.Font.Code
						TextLabel.TextSize = 14
						TextLabel.TextWrapped = true
						TextLabel.Size = UDim2.new(1, 0, 1, 0)
						TextLabel.TextYAlignment = Enum.TextYAlignment.Top
						TextLabel.BackgroundTransparency = 1
						TextLabel.TextStrokeTransparency = 0.5
						TextLabel.TextColor3 = Color3.fromRGB(80, 245, 245)
						TextLabel.Parent = BillboardGui
					end

					local NameEsp = ChestEspAttachment and ChestEspAttachment:FindFirstChild("NameEsp")

					if NameEsp then
						local chestespCalculatedValue = math.floor(Magnitude / 3)

						NameEsp.TextLabel.Text = string.format("[%s] %d M", playervalueaiPlayerData.Name:gsub("Label", ""), chestespCalculatedValue)
					end
				end)
			end
		else
			for _, playervalueaiPlayerData in ipairs(game:GetService("CollectionService"):GetTagged("_ChestTagged")) do
				local ChestEspAttachment = playervalueaiPlayerData:FindFirstChild("ChestEspAttachment")

				if ChestEspAttachment then
					ChestEspAttachment:Destroy()
				end
			end
		end
	end
end

berriesEsp = function()
	if BerryEsp then
		local tagged = game:GetService("CollectionService"):GetTagged("BerryBush")

		for _, playervalueaiPlayerData in ipairs(tagged) do
			pcall(function()
				local Position = playervalueaiPlayerData.Parent:GetPivot().Position

				for _, getinfinityAbilityPlayerDataItem in pairs(playervalueaiPlayerData:GetAttributes()) do
					if getinfinityAbilityPlayerDataItem then
						local name = "BerryEspPart_" .. getinfinityAbilityPlayerDataItem .. "_" .. tostring(Position)
						local Part2 = workspace:FindFirstChild(name)

						if not Part2 then
							Part2 = Instance.new("Part")
							Part2.Name = name
							Part2.Transparency = 1
							Part2.Size = Vector3.new(1, 1, 1)
							Part2.Anchored = true
							Part2.CanCollide = false
							Part2.Parent = workspace
							Part2.CFrame = CFrame.new(Position)
						end

						if not Part2:FindFirstChild("NameEsp") then
							local BillboardGui = Instance.new("BillboardGui", Part2)

							BillboardGui.Name = "NameEsp"
							BillboardGui.ExtentsOffset = Vector3.new(0, 1, 0)
							BillboardGui.Size = UDim2.new(0, 200, 0, 30)
							BillboardGui.Adornee = Part2
							BillboardGui.AlwaysOnTop = true

							local TextLabel = Instance.new("TextLabel", BillboardGui)

							TextLabel.Font = Enum.Font.Code
							TextLabel.TextSize = 14
							TextLabel.TextWrapped = true
							TextLabel.Size = UDim2.new(1, 0, 1, 0)
							TextLabel.TextYAlignment = Enum.TextYAlignment.Top
							TextLabel.BackgroundTransparency = 1
							TextLabel.TextStrokeTransparency = 0.5
							TextLabel.TextColor3 = Color3.fromRGB(80, 245, 245)
						end

						local NameEsp = Part2:FindFirstChild("NameEsp")
						local targetPositionCurrent = (LocalPlayer.Character.Head.Position - Position).Magnitude / 3

						if NameEsp then
							NameEsp.TextLabel.Text = "[" .. getinfinityAbilityPlayerDataItem .. "]" .. " " .. math.round(targetPositionCurrent) .. " M"
						end
					end
				end
			end)
		end
	else
		for _, child in ipairs(workspace:GetChildren()) do
			if child:IsA("Part") then
				if child.Name:match("BerryEspPart_.*") then
					child:Destroy()
				end
			end
		end
	end
end

do
	GRP_Esp_Esp:AddToggle("Esp_Berry", {
		Text = "Esp Berry",
		Default = false,
		Callback = function(isEspBerryEnabled)
			BerryEsp = isEspBerryEnabled

			if isEspBerryEnabled then
				task.spawn(function()
					while BerryEsp do
						berriesEsp()
						task.wait()
					end
				end)
			else
				for _, child in ipairs(workspace:GetChildren()) do
					if child:IsA("Part") then
						if child.Name:match("BerryEspPart_.*") then
							child:Destroy()
						end
					end
				end
			end
		end
	})
end

GRP_Esp_Esp:AddToggle("Esp_Player", {
	Text = "Esp Player",
	Default = false,
	Callback = function(isEspPlayerEnabled)
		PlayerEsp = isEspPlayerEnabled

		if isEspPlayerEnabled then
			task.spawn(function()
				while PlayerEsp do
					EspPly()
					task.wait()
				end
			end)
		else
			local next_ = next
			local children, childInstancesPrevious = game.Players:GetChildren()

			for _, playervalueaiPlayerData in next_, children, childInstancesPrevious do
				pcall(function()
					if not (isnil(playervalueaiPlayerData.Character) or isnil(playervalueaiPlayerData.Character.Head)) then
						if playervalueaiPlayerData.Character.Head:FindFirstChild("NameEsp" .. Number) then
							playervalueaiPlayerData.Character.Head:FindFirstChild("NameEsp" .. Number):Destroy()
						end
					end
				end)
			end
		end
	end
})
GRP_Esp_Esp:AddToggle("Esp_Chest", {
	Text = "Esp Chest",
	Default = false,
	Callback = function(isEspChestEnabled)
		ChestESP = isEspChestEnabled

		if isEspChestEnabled then
			task.spawn(function()
				while ChestESP do
					ChestEsp()
					task.wait()
				end
			end)
		else
			for _, playervalueaiPlayerData in ipairs(game:GetService("CollectionService"):GetTagged("_ChestTagged")) do
				local ChestEspAttachment = playervalueaiPlayerData:FindFirstChild("ChestEspAttachment")

				if ChestEspAttachment then
					ChestEspAttachment:Destroy()
				end
			end
		end
	end
})
GRP_Esp_Esp:AddToggle("Esp_Fruit", {
	Text = "Esp Fruit",
	Default = false,
	Callback = function(isEspFruitEnabled)
		DevilFruitESP = isEspFruitEnabled

		if isEspFruitEnabled then
			task.spawn(function()
				while DevilFruitESP do
					DevEsp()
					task.wait()
				end
			end)
		else
			local next_ = next
			local children, childInstancesNext = workspace:GetChildren()

			for _, playervalueaiPlayerData in next_, children, childInstancesNext do
				pcall(function()
					if playervalueaiPlayerData:FindFirstChild("Handle") then
						if playervalueaiPlayerData.Handle:FindFirstChild("NameEsp" .. Number) then
							playervalueaiPlayerData.Handle:FindFirstChild("NameEsp" .. Number):Destroy()
						end
					end
				end)
			end
		end
	end
})
GRP_Esp_Esp:AddToggle("Esp_Island", {
	Text = "Esp Island",
	Default = false,
	Callback = function(isEspIslandEnabled)
		IslandESP = isEspIslandEnabled

		if isEspIslandEnabled then
			task.spawn(function()
				while IslandESP do
					LocationEsp()
					task.wait()
				end
			end)
		else
			local next_ = next
			local children, childInstancesPrimary = workspace._WorldOrigin.Locations:GetChildren()

			for _, playervalueaiPlayerData in next_, children, childInstancesPrimary do
				pcall(function()
					if playervalueaiPlayerData:FindFirstChild("NameEsp") then
						playervalueaiPlayerData:FindFirstChild("NameEsp"):Destroy()
					end
				end)
			end
		end
	end
})

do
	GRP_Esp_Esp:AddToggle("Esp_Flower", {
		Text = "Esp Flower",
		Default = false,
		Callback = function(isEspFlowerEnabled)
			FlowerESP = isEspFlowerEnabled

			if isEspFlowerEnabled then
				task.spawn(function()
					while FlowerESP do
						flowerEsp()
						task.wait()
					end
				end)
			else
				for _, child in pairs(workspace:GetChildren()) do
					pcall(function()
						if (child.Name == "Flower2" or child.Name == "Flower1") and child:FindFirstChild("NameEsp" .. Number) then
							child:FindFirstChild("NameEsp" .. Number):Destroy()
						end
					end)
				end
			end
		end
	})
end

do
	GRP_Esp_Esp:AddToggle("Esp_Legendary_Sword", {
		Text = "Esp Legendary Sword",
		Default = false,
		Callback = function(isEspLegendarySwordEnabled)
			LegenS = isEspLegendarySwordEnabled

			if isEspLegendarySwordEnabled then
				task.spawn(function()
					while LegenS do
						LegenSword()
						task.wait()
					end
				end)
			elseif workspace:FindFirstChild("Lgd") then
				workspace:FindFirstChild("Lgd"):Destroy()
			end
		end
	})
end

do
	GRP_Esp_Esp:AddToggle("Esp_Haki_Color", {
		Text = "Esp Haki Color",
		Default = false,
		Callback = function(isEspHakiColorEnabled)
			ColorEsp = isEspHakiColorEnabled

			if isEspHakiColorEnabled then
				task.spawn(function()
					while ColorEsp do
						HakiClorEsp()
						task.wait()
					end
				end)
			elseif workspace:FindFirstChild("Gay") then
				workspace:FindFirstChild("Gay"):Destroy()
			end
		end
	})
end

GRP_Esp_Esp:AddToggle("Esp_Gear", {
	Text = "Esp Gear",
	Default = false,
	Callback = function(isEspGearEnabled)
		ESPGear = isEspGearEnabled

		if isEspGearEnabled then
			task.spawn(function()
				while ESPGear do
					gearEsp()
					task.wait()
				end
			end)
		else
			local pairs_ = pairs
			local MysticIsland = workspace.Map:FindFirstChild("MysticIsland")

			for _, descendant in pairs_(MysticIsland:GetDescendants()) do
				pcall(function()
					if descendant:FindFirstChild("NameEsp") then
						descendant:FindFirstChild("NameEsp"):Destroy()
					end
				end)
			end
		end
	end
})

do
	GRP_Esp_Esp:AddToggle("Esp_SeaEvent_Island", {
		Text = "Esp SeaEvent Island",
		Default = false,
		Callback = function(isEspSeaeventIslandEnabled)
			EspEventIsland = isEspSeaeventIslandEnabled

			if isEspSeaeventIslandEnabled then
				task.spawn(function()
					while EspEventIsland do
						EventIslandEsp()
						task.wait()
					end
				end)
			else
				for _, child in pairs(workspace._WorldOrigin.Locations:GetChildren()) do
					pcall(function()
						if child:FindFirstChild("NameEsp") then
							child:FindFirstChild("NameEsp"):Destroy()
						end
					end)
				end
			end
		end
	})
end

do
	GRP_Esp_Esp:AddToggle("Esp_Advanced_Dealer", {
		Text = "Esp Advanced Dealer",
		Default = false,
		Callback = function(isEspAdvancedDealerEnabled)
			advanEsp = isEspAdvancedDealerEnabled

			if isEspAdvancedDealerEnabled then
				task.spawn(function()
					while advanEsp do
						AdvanFruitEsp()
						task.wait()
					end
				end)
			elseif workspace:FindFirstChild("Adv") then
				workspace:FindFirstChild("Adv"):Destroy()
			end
		end
	})
end

GRP_Raids_Fruits_Options = tabs.Raids:AddLeftGroupbox("Fruits Options")

do
	local function fruitvalueFruit(valueArgumentPrimary)
		local textValueCurrent = tostring(valueArgumentPrimary)
		local fruitvalueFruitState

		repeat
			textValueCurrent, fruitvalueFruitState = textValueCurrent:gsub("^(-?%d+)(%d%d%d)", "%1,%2")
		until fruitvalueFruitState == 0

		return textValueCurrent
	end
	local function fruitvaluecachedFruitState()
		local fruitvaluecachedText = "Advance Fruit Stock\n"
		local ok, resultassignedResult = pcall(function()
			return game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("GetFruits", true)
		end)

		if ok and resultassignedResult then
			local isFruitvaluecachedReady = false

			for _, playervalueaiPlayerData in pairs(resultassignedResult) do
				if playervalueaiPlayerData.OnSale then
					isFruitvaluecachedReady = true
					fruitvaluecachedText ..= playervalueaiPlayerData.Name .. " - $" .. fruitvalueFruit(playervalueaiPlayerData.Price) .. "\n"
				end
			end

			if not isFruitvaluecachedReady then
				fruitvaluecachedText ..= "- No fruit.\n"
			end
		else
			fruitvaluecachedText ..= "- Error while retrieving data.\n"
		end

		local fruitvaluecachedFruit = fruitvaluecachedText .. "\nNormal Fruit Stock\n"
		local ok2, result2 = pcall(function()
			return game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("GetFruits")
		end)

		if ok2 and result2 then
			local isFruitvaluecachedReadyState = false

			for _, playervalueaiPlayerData in pairs(result2) do
				if playervalueaiPlayerData.OnSale then
					isFruitvaluecachedReadyState = true
					fruitvaluecachedFruit ..= playervalueaiPlayerData.Name .. " - $" .. fruitvalueFruit(playervalueaiPlayerData.Price) .. "\n"
				end
			end

			if not isFruitvaluecachedReadyState then
				fruitvaluecachedFruit ..= "- No fruit.\n"
			end
		else
			fruitvaluecachedFruit ..= "- Error while retrieving data.\n"
		end

		return fruitvaluecachedFruit
	end

	local loadingStatusLabel = GRP_Raids_Fruits_Options:AddLabel("Loading...")

	task.spawn(function()
		while task.wait(60) do
			pcall(function()
				loadingStatusLabel:SetText(fruitvaluecachedFruitState())
			end)
		end
	end)
	pcall(function()
		loadingStatusLabel:SetText(fruitvaluecachedFruitState())
	end)
end

do
	RandomFF = GRP_Raids_Fruits_Options:AddToggle("Auto_Random_Fruit", {
		Text = "Auto Random Fruit",
		Default = false,
		Callback = function(isAutoRandomFruitEnabled)
			_G.Random_Auto = isAutoRandomFruitEnabled
		end
	})
end

spawn(function()
	while wait(Sec) do
		pcall(function()
			if _G.Random_Auto then
				ReplicatedStorage2.Remotes.CommF_:InvokeServer("Cousin", "Buy")
			end
		end)
	end
end)

do
	DropF = GRP_Raids_Fruits_Options:AddToggle("Auto_Drop_Fruit", {
		Text = "Auto Drop Fruit",
		Default = false,
		Callback = function(isAutoDropFruitEnabled)
			_G.DropFruit = isAutoDropFruitEnabled
		end
	})
end

do
	spawn(function()
		while wait(Sec) do
			if _G.DropFruit then
				pcall(function()
					DropFruits()
				end)
			end
		end
	end)
end

StoredF = GRP_Raids_Fruits_Options:AddToggle("Auto_Store_Fruit", {
	Text = "Auto Store Fruit",
	Default = false,
	Callback = function(isAutoStoreFruitEnabled)
		_G.StoreF = isAutoStoreFruitEnabled
	end
})

do
	spawn(function()
		while wait(Sec) do
			if _G.StoreF then
				pcall(function()
					UpdStFruit()
				end)
			end
		end
	end)
end

TwF = GRP_Raids_Fruits_Options:AddToggle("Auto_Tween_to_Fruit", {
	Text = "Auto Tween to Fruit",
	Default = false,
	Callback = function(isAutoTweenToFruitEnabled)
		_G.TwFruits = isAutoTweenToFruitEnabled
	end
})

do
	spawn(function()
		while wait(Sec) do
			if _G.TwFruits then
				pcall(function()
					for _, child in pairs(workspace:GetChildren()) do
						if string.find(child.Name, "Fruit") then
							_tp(child.Handle.CFrame)
						end
					end
				end)
			end
		end
	end)
end

do
	BringF = GRP_Raids_Fruits_Options:AddToggle("Auto_Collect_Fruit", {
		Text = "Auto Collect Fruit",
		Default = false,
		Callback = function(isAutoCollectFruitEnabled)
			_G.InstanceF = isAutoCollectFruitEnabled
		end
	})
end

spawn(function()
	while wait(Sec) do
		if _G.InstanceF then
			pcall(function()
				collectFruits(_G.InstanceF)
			end)
		end
	end
end)

do
	GRP_Raids_Fruits_Options:AddDropdown("Select_Fruit_Shop", {
		Text = "Select Fruit Shop",
		Values = {
			"Rocket-Rocket",
			"Spin-Spin",
			"Blade-Blade",
			"Spring-Spring",
			"Bomb-Bomb",
			"Smoke-Smoke",
			"Spike-Spike",
			"Flame-Flame",
			"Ice-Ice",
			"Sand-Sand",
			"Dark-Dark",
			"Eagle-Eagle",
			"Diamond-Diamond",
			"Light-Light",
			"Rubber-Rubber",
			"Ghost-Ghost",
			"Magma-Magma",
			"Quake-Quake",
			"Buddha-Buddha",
			"Love-Love",
			"Creation-Creation",
			"Spider-Spider",
			"Sound-Sound",
			"Phoenix-Phoenix",
			"Portal-Portal",
			"Lightning-Lightning",
			"Pain-Pain",
			"Blizzard-Blizzard",
			"Gravity-Gravity",
			"T-Rex-T-Rex",
			"Mammoth-Mammoth",
			"Dough-Dough",
			"Shadow-Shadow",
			"Venom-Venom",
			"Gas-Gas",
			"Control-Control",
			"Spirit-Spirit",
			"Leopard-Leopard",
			"Yeti-Yeti",
			"Kitsune-Kitsune",
			"Dragon-Dragon"
		},
		Default = 1,
		Callback = function(isAutoBuyFruitShopEnabled)
			getgenv().SelectFruit = isAutoBuyFruitShopEnabled
		end
	})
end

GRP_Raids_Fruits_Options:AddToggle("Auto_Buy_Fruit_Shop", {
	Text = "Auto Buy Fruit Shop",
	Default = false,
	Callback = function(isAutoBuyFruitShopEnabledCurrent)
		getgenv().AutoBuyFruitSniper = isAutoBuyFruitShopEnabledCurrent
	end
})

do
	spawn(function()
		pcall(function()
			while wait() do
				if getgenv().AutoBuyFruitSniper then
					game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("GetFruits")
					game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("PurchaseRawFruit", getgenv().SelectFruit)
				end
			end
		end)
	end)
end

GRP_Raids_Dungeon_Event_Raiding = tabs.Raids:AddLeftGroupbox("Dungeon Event / Raiding")

do
	Q = GRP_Raids_Dungeon_Event_Raiding:AddDropdown("Select_Chip", {
		Text = "Select Chip",
		Values = {
			"Flame",
			"Ice",
			"Quake",
			"Light",
			"Dark",
			"String",
			"Rumble",
			"Magma",
			"Human: Buddha",
			"Sand",
			"Bird: Phoenix",
			"Dough"
		},
		Default = 1,
		Callback = function(isAutoSelectDungeonChipEnabled)
			_G.SelectChip = isAutoSelectDungeonChipEnabled
		end
	})
end

Q = GRP_Raids_Dungeon_Event_Raiding:AddToggle("Auto_Select_Dungeon_Chip", {
	Text = "Auto Select Dungeon Chip",
	Default = false,
	Callback = function(isGetFruitInInventoryBelowMEnabled)
		_G.AutoSelectDungeon = isGetFruitInInventoryBelowMEnabled
	end
})
GRP_Raids_Dungeon_Event_Raiding:AddToggle("Get_Fruit_In_Inventory_Below_1M", {
	Text = "Get Fruit In Inventory Below 1M",
	Default = false,
	Callback = function(isGetFruitInInventoryBelowMEnabledCurrent)
		getgenv().AutoGetFruit = isGetFruitInInventoryBelowMEnabledCurrent
	end
})

do
	spawn(function()
		while wait() do
			pcall(function()
				if getgenv().AutoGetFruit then
					for _, playervalueaiPlayerData in ipairs({
						"Rocket-Rocket",
						"Spin-Spin",
						"Chop-Chop",
						"Spring-Spring",
						"Bomb-Bomb",
						"Smoke-Smoke",
						"Spike-Spike",
						"Flame-Flame",
						"Falcon-Falcon",
						"Ice-Ice",
						"Sand-Sand",
						"Dark-Dark",
						"Ghost-Ghost",
						"Diamond-Diamond",
						"Light-Light",
						"Rubber-Rubber",
						"Barrier-Barrier"
					}) do
						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({
							"LoadFruit",
							playervalueaiPlayerData
						}))
					end
				end
			end)
		end
	end)
end

GRP_Raids_Dungeon_Event_Raiding:AddButton({
	Text = "Buy Dungeon Chips [Beli]",
	Func = function()
	end
})
GRP_Raids_Dungeon_Event_Raiding:AddButton({
	Text = "Buy Dungeon Chips [Devil Fruit]",
	Func = function()
	end
})

do
	AutoChipBeli = GRP_Raids_Dungeon_Event_Raiding:AddToggle("Auto_Buy_Chip_[Beli]", {
		Text = "Auto Buy Chip [Beli]",
		Default = false,
		Callback = function()
		end
	})
end

do
	task.spawn(function()
		while task.wait(1) do
			if _G.AutoChipBeli then
				pcall(function()
					if not GetBP("Special Microchip") then
						ReplicatedStorage2.Remotes.CommF_:InvokeServer("RaidsNpc", "Select", _G.SelectChip)
					end
				end)
			end
		end
	end)
end

AutoChipFruit = GRP_Raids_Dungeon_Event_Raiding:AddToggle("Auto_Buy_Chip_[Devil_Fruit]", {
	Text = "Auto Buy Chip [Devil Fruit]",
	Default = false,
	Callback = function(isAutoBuyChipDevilFruitEnabled)
		_G.AutoChipFruit = isAutoBuyChipDevilFruitEnabled
	end
})
task.spawn(function()
	while task.wait(1) do
		if _G.AutoChipFruit then
			pcall(function()
				if not GetBP("Special Microchip") then
					local response = ReplicatedStorage2.Remotes.CommF_:InvokeServer("GetFruits")
					local Name

					for _, playervalueaiPlayerData in pairs(response) do
						if playervalueaiPlayerData.Price <= 490000 then
							Name = playervalueaiPlayerData.Name

							break
						end
					end

					if Name then
						ReplicatedStorage2.Remotes.CommF_:InvokeServer("LoadFruit", tostring(Name))
						ReplicatedStorage2.Remotes.CommF_:InvokeServer("RaidsNpc", "Select", _G.SelectChip)
					end
				end
			end)
		end
	end
end)

do
	StartR = GRP_Raids_Dungeon_Event_Raiding:AddToggle("Auto_Start_Raid", {
		Text = "Auto Start Raid",
		Default = false,
		Callback = function(isAutoStartRaidEnabled)
			_G.Auto_StartRaid = isAutoStartRaidEnabled
		end
	})
end

do
	task.spawn(function()
		while task.wait(Sec) do
			if _G.Auto_StartRaid and LocalPlayer.PlayerGui.Main.TopHUDList.RaidTimer.Visible == false then
				if GetBP("Special Microchip") then
					if World2 then
						_tp(CFrame.new(-6438.73535, 250.645355, -4501.50684))
						fireclickdetector(workspace.Map.CircleIsland.RaidSummon2.Button.Main.ClickDetector)
					elseif World3 then
						_tp(CFrame.new(-5046, 314, -2960))
						task.wait(1.5)
						pcall(function()
							local Main = workspace.Map["Boat Castle"].RaidSummon2.Button.Main

							if Main and Main:FindFirstChild("ClickDetector") then
								fireclickdetector(Main.ClickDetector)
							end
						end)
					end
				end
			end
		end
	end)
end

Raiding = GRP_Raids_Dungeon_Event_Raiding:AddToggle("Auto_Raid_+_Next_Island", {
	Text = "Auto Raid + Next Island",
	Default = false,
	Callback = function(isAutoRaidNextIslandEnabled)
		_G.Raiding = isAutoRaidNextIslandEnabled
	end
})
spawn(function()
	local Locations = workspace._WorldOrigin.Locations
	local callbackEntriesState = {
		"Island 1",
		"Island 2",
		"Island 3",
		"Island 4",
		"Island 5"
	}
	local callbackPlayerDataCallbackDetails

	while task.wait(0.3) do
		if _G.Raiding and LocalPlayer.PlayerGui.Main.TopHUDList.RaidTimer.Visible then
			local Character = LocalPlayer.Character

			if Character then
				local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
				local Humanoid = Character:FindFirstChildOfClass("Humanoid")

				if HumanoidRootPart and Humanoid and not (Humanoid.Health <= 0) and not (Humanoid.Sit or Humanoid.PlatformStand or not not HumanoidRootPart.Anchored) then
					local n9 = 999999

					for _, playervalueaiPlayerData in ipairs(callbackEntriesState) do
						local locatedInstance = Locations:FindFirstChild(playervalueaiPlayerData)

						if locatedInstance then
							local Magnitude = (HumanoidRootPart.Position - locatedInstance.Position).Magnitude

							if Magnitude < n9 then
								n9 = Magnitude
								callbackPlayerDataCallbackDetails = playervalueaiPlayerData
							end
						end
					end

					if callbackPlayerDataCallbackDetails then
						local locatedInstanceData = Locations:FindFirstChild(callbackPlayerDataCallbackDetails)

						if locatedInstanceData then
							local isCallbackReadyRecord = false

							for _, child in ipairs(workspace.Enemies:GetChildren()) do
								local Humanoid2 = child:FindFirstChild("Humanoid")
								local HumanoidRootPart2 = child:FindFirstChild("HumanoidRootPart")

								if Humanoid2 and HumanoidRootPart2 and Humanoid2.Health > 0 and (HumanoidRootPart2.Position - locatedInstanceData.Position).Magnitude < 450 then
									isCallbackReadyRecord = true

									while true do
										task.wait()
										playerCollectionLatest.Kill(child, _G.Raiding)

										if _G.Raiding then
											if not child.Parent or Humanoid2.Health <= 0 then
												break
											end
										else
											break
										end
									end
								end
							end

							if not isCallbackReadyRecord then
								local callbackMatchIndex = table.find(callbackEntriesState, callbackPlayerDataCallbackDetails)

								if callbackMatchIndex and callbackEntriesState[callbackMatchIndex + 1] then
									local locatedInstanceState = Locations:FindFirstChild(callbackEntriesState[callbackMatchIndex + 1])

									if locatedInstanceState then
										_tp(locatedInstanceState.CFrame * CFrame.new(0, 45, 120))
									end

									callbackPlayerDataCallbackDetails = callbackEntriesState[callbackMatchIndex + 1]
									task.wait(1)
								end
							end
						end
					end
				end
			end
		end
	end
end)
GRP_Raids_Dungeon_Event_Raiding:AddToggle("Auto_Awakening", {
	Text = "Auto Awakening",
	Default = false,
	Callback = function(isAutoAwakeningEnabled)
		_G.Auto_Awakener = isAutoAwakeningEnabled
	end
})
spawn(function()
	while wait(Sec) do
		pcall(function()
			if _G.Auto_Awakener then
				ReplicatedStorage2.Remotes.CommF_:InvokeServer("Awakener", "Check")
				ReplicatedStorage2.Remotes.CommF_:InvokeServer("Awakener", "Awaken")
			end
		end)
	end
end)
GRP_Raids_Dungeon_Event_Raiding:AddToggle("Auto_Teleport_To_Lab", {
	Text = "Auto Teleport To Lab",
	Default = false,
	Callback = function(isAutoTeleportToLabEnabled)
		_G.TpLab = isAutoTeleportToLabEnabled

		while _G.TpLab do
			wait()

			if _G.TpLab then
				if World2 and _G.TpLab then
					_tp(CFrame.new(-6438.73535, 250.645355, -4501.50684))
				elseif World3 and _G.TpLab then
					_tp(CFrame.lookAt(Vector3.new(-5046, 314, -2960), Vector3.new(-5055, 314, -2957)))
				end
			end
		end
	end
})
GRP_Raids_Items_Law_Order_Sword = tabs.Raids:AddLeftGroupbox("Items Law/Order Sword")
GRP_Raids_Items_Law_Order_Sword:AddButton({
	Text = "Buy Microchip Law",
	Func = function()
	end
})

do
	GRP_Raids_Items_Law_Order_Sword:AddButton({
		Text = "Start Law Raids",
		Func = function()
		end
	})
end

GRP_Raids_Items_Law_Order_Sword:AddToggle("Auto_Buy_Microchip_Law", {
	Text = "Auto Buy Microchip Law",
	Default = false,
	Callback = function(isAutoBuyMicrochipLawEnabled)
		_G.AutoLawKak = isAutoBuyMicrochipLawEnabled
	end
})

do
	spawn(function()
		while task.wait(1) do
			if getgenv().AutoBuyMicrochipLaw then
				pcall(function()
					game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward", "Microchip", "2")
				end)
			end
		end
	end)
end

GRP_Raids_Items_Law_Order_Sword:AddToggle("Auto_Start_Law_Raids", {
	Text = "Auto Start Law Raids",
	Default = false,
	Callback = function(isAutoStartLawRaidsEnabled)
		getgenv().AutoStartLawRaids = isAutoStartLawRaidsEnabled
	end
})

do
	spawn(function()
		while task.wait(1) do
			if getgenv().AutoStartLawRaids then
				pcall(function()
					fireclickdetector(workspace.Map.CircleIsland.RaidSummon.Button.Main.ClickDetector)
				end)
			end
		end
	end)
end

GRP_Raids_Items_Law_Order_Sword:AddToggle("Auto_Kill_Law", {
	Text = "Auto Kill Law",
	Default = false,
	Callback = function(isAutoKillLawEnabled)
		_G.AutoLawKak = isAutoKillLawEnabled
	end
})

do
	spawn(function()
		while wait(Sec) do
			if _G.AutoLawKak then
				pcall(function()
					local Order = GetConnectionEnemies("Order")

					if Order then
						while true do
							task.wait()
							playerCollectionLatest.Kill(Order, _G.AutoLawKak)

							if _G.AutoLawKak == false then
								break
							elseif not Order.Parent or Order.Humanoid.Health <= 0 then
								break
							end
						end
					else
						_tp(CFrame.new(-6217.2021484375, 28.047645568848, -5053.1357421875))
					end
				end)
			end
		end
	end)
end

GRP_Raids_Raids_Dungeons = tabs.Raids:AddLeftGroupbox("Raids Dungeons")

local LocalPlayer2 = game.Players.LocalPlayer

do
	local function playervalueavailablePlayerData()
		local Character = LocalPlayer2.Character

		return Character and Character:FindFirstChild("HumanoidRootPart")
	end

	GRP_Raids_Raids_Dungeons:AddToggle("Auto_Farm_Dungeon", {
		Text = "Auto Farm Dungeon",
		Default = false,
		Callback = function(isAutoFarmDungeonEnabled)
			_G.AutoFarmDungeon = isAutoFarmDungeonEnabled
		end
	})
	spawn(function()
		while task.wait(0.15) do
			if _G.AutoFarmDungeon then
				pcall(function()
					local Character = game.Players.LocalPlayer.Character
					local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
					local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

					if not HumanoidRootPart or not Humanoid or Humanoid.Health <= 0 then
						return
					end

					for _, child in pairs(workspace.Enemies:GetChildren()) do
						if not _G.AutoFarmDungeon then
							break
						end

						local Humanoid2 = child:FindFirstChild("Humanoid")
						local HumanoidRootPart2 = child:FindFirstChild("HumanoidRootPart")

						if Humanoid2 and HumanoidRootPart2 and Humanoid2.Health > 0 and (HumanoidRootPart2.Position - HumanoidRootPart.Position).Magnitude <= 5000 then
							while true do
								task.wait()
								playerCollectionLatest.Kill(child, true)

								if _G.AutoFarmDungeon then
									if not child.Parent or Humanoid2.Health <= 0 then
										break
									end
								else
									break
								end
							end
						end
					end
				end)
			end
		end
	end)
	GRP_Raids_Raids_Dungeons:AddToggle("TP_Exit_(1)", {
		Text = "TP Exit (1)",
		Default = false,
		Callback = function(isTpExitEnabled)
			_G.TPFloor1 = isTpExitEnabled
		end
	})

	local isCallbackReadyEntry = false

	local function resultcachedResult()
		local resultcachedResultState = playervalueavailablePlayerData()

		if not resultcachedResultState then
			return
		end

		for _, child in pairs(workspace.Map.Dungeon:GetChildren()) do
			local ExitTeleporter = child:FindFirstChild("ExitTeleporter")

			if ExitTeleporter and ExitTeleporter:FindFirstChild("Root") and (resultcachedResultState.Position - ExitTeleporter.Root.Position).Magnitude < 200 then
				return ExitTeleporter.Root
			end
		end
	end

	task.spawn(function()
		while task.wait(0.3) do
			if _G.TPFloor1 then
				if not isCallbackReadyEntry then
					local resultcachedMovementData = resultcachedResult()

					if resultcachedMovementData then
						local cFrame = resultcachedMovementData.CFrame * CFrame.new(0, 3, 0)

						playervalueavailablePlayerData().CFrame = cFrame
						isCallbackReadyEntry = true
					end
				end
			else
				isCallbackReadyEntry = false
			end
		end
	end)
	GRP_Raids_Raids_Dungeons:AddToggle("TP_Exit_(2)", {
		Text = "TP Exit (2)",
		Default = false,
		Callback = function(isTpExitEnabledCurrent)
			_G.TPFloor2 = isTpExitEnabledCurrent
		end
	})

	local isCallbackReadyData = false

	task.spawn(function()
		while task.wait(0.3) do
			if _G.TPFloor2 then
				if not isCallbackReadyData then
					local callbackMovementDataSelection = playervalueavailablePlayerData()

					if callbackMovementDataSelection then
						for _, child in pairs(workspace.Map.Dungeon:GetChildren()) do
							local EntranceTeleporter = child:FindFirstChild("EntranceTeleporter")
							local ExitTeleporter = child:FindFirstChild("ExitTeleporter")

							if EntranceTeleporter and ExitTeleporter and EntranceTeleporter:FindFirstChild("Root") and ExitTeleporter:FindFirstChild("Root") and (callbackMovementDataSelection.Position - EntranceTeleporter.Root.Position).Magnitude < 100 then
								callbackMovementDataSelection.CFrame = ExitTeleporter.Root.CFrame * CFrame.new(0, 3, 0)
								isCallbackReadyData = true

								break
							end
						end
					end
				end
			else
				isCallbackReadyData = false
			end
		end
	end)
	GRP_Raids_Raids_Dungeons:AddToggle("TP_Exit_(3)", {
		Text = "TP Exit (3)",
		Default = false,
		Callback = function(isTpExitEnabledCached)
			_G.TPFloor3 = isTpExitEnabledCached
		end
	})

	local isCallbackReadyResponse = false

	local function resultactiveResult()
		local resultactiveResultState

		for _, child in pairs(workspace.Map.Dungeon:GetChildren()) do
			local numericValue = tonumber(child.Name)

			if numericValue and (not resultactiveResultState or tonumber(resultactiveResultState.Name) < numericValue) then
				resultactiveResultState = child
			end
		end

		return resultactiveResultState
	end

	task.spawn(function()
		while task.wait(0.3) do
			if _G.TPFloor3 then
				if not isCallbackReadyResponse then
					local resultactiveMovementData = resultactiveResult()

					if resultactiveMovementData and resultactiveMovementData:FindFirstChild("ExitTeleporter") then
						if resultactiveMovementData.ExitTeleporter:FindFirstChild("Root") then
							playervalueavailablePlayerData().CFrame = resultactiveMovementData.ExitTeleporter.Root.CFrame * CFrame.new(0, 3, 0)
							isCallbackReadyResponse = true
						end
					end
				end
			else
				isCallbackReadyResponse = false
			end
		end
	end)
	GRP_Raids_Raids_Dungeons:AddToggle("TP_Exit_(4)", {
		Text = "TP Exit (4)",
		Default = false,
		Callback = function(isTpExitEnabledSelected)
			_G.TPFloor4 = isTpExitEnabledSelected
		end
	})

	local isCallbackReadyState = false

	local function resultpreviousResultState()
		local resultpreviousResult = playervalueavailablePlayerData()

		if not resultpreviousResult then
			return
		end

		local Root_
		local huge = math.huge

		for _, child in pairs(workspace.Map.Dungeon:GetChildren()) do
			local ExitTeleporter = child:FindFirstChild("ExitTeleporter")

			if ExitTeleporter and ExitTeleporter:FindFirstChild("Root") then
				local Magnitude = (resultpreviousResult.Position - ExitTeleporter.Root.Position).Magnitude

				if Magnitude < huge then
					huge = Magnitude
					Root_ = ExitTeleporter.Root
				end
			end
		end

		return Root_
	end

	task.spawn(function()
		while task.wait(0.3) do
			if _G.TPFloor4 then
				if not isCallbackReadyState then
					local resultpreviousMovementData = resultpreviousResultState()

					if resultpreviousMovementData then
						playervalueavailablePlayerData().CFrame = resultpreviousMovementData.CFrame * CFrame.new(0, 3, 0)
						isCallbackReadyState = true
					end
				end
			else
				isCallbackReadyState = false
			end
		end
	end)
end

GRP_Combat_Combat_AimBot = tabs.Combat:AddLeftGroupbox("Combat / AimBot")

do
	local grpCombatCombatAimbotData = GRP_Combat_Combat_AimBot:AddLabel("")

	spawn(function()
		while wait(Sec) do
			pcall(function()
				local playersService = #game:GetService("Players"):GetPlayers()

				if playersService == 12 then
					grpCombatCombatAimbotData:SetText("All Players : " .. playersService .. " / 12 [Max]")
				else
					grpCombatCombatAimbotData:SetText("All Players : " .. playersService .. " / 12")
				end
			end)
		end
	end)
end

do
	local grpCombatCombatAimbotDataState = GRP_Combat_Combat_AimBot:AddLabel("")

	Checking_AimStatus = function()
		if _G.AimCam then
			return "Aimbot Camera"
		end

		if _G.AimbotGun then
			return "Aimbot Guns"
		end

		return ""
	end
	spawn(function()
		while wait(0.2) do
			pcall(function()
				if _G.AimMethod then
					if _G.AimCam or _G.AimbotGun then
						grpCombatCombatAimbotDataState:SetText("Aimbot - " .. Checking_AimStatus() .. " : True")
					else
						grpCombatCombatAimbotDataState:SetText("Aimbot - Skills : True")
					end
				else
					grpCombatCombatAimbotDataState:SetText("Aimbot - Skills : False")
				end
			end)
		end
	end)
end

do
	local playerCollectionPrevious = {}
	local Players2 = game:GetService("Players")

	for _, child in pairs(Players2:GetChildren()) do
		table.insert(playerCollectionPrevious, child.Name)
	end

	GRP_Combat_Combat_AimBot:AddDropdown("Select_Players", {
		Text = "Select Players",
		Values = playerCollectionPrevious,
		Default = 1,
		Callback = function(isTeleportToSelectPlayersEnabled)
			_G.PlayersList = isTeleportToSelectPlayersEnabled
		end
	})
end

GRP_Combat_Combat_AimBot:AddToggle("Teleport_To_Select_Players", {
	Text = "Teleport To Select Players",
	Default = false,
	Callback = function(isTeleportToSelectPlayersEnabledCurrent)
		_G.TpPly = isTeleportToSelectPlayersEnabledCurrent
		spawn(function()
			pcall(function()
				while _G.TpPly do
					wait()
					_tp(game:GetService("Players")[_G.PlayersList].Character.HumanoidRootPart.CFrame)
				end
			end)
		end)
	end
})
GRP_Combat_Combat_AimBot:AddToggle("Spectate_Select_Players", {
	Text = "Spectate Select Players",
	Default = false,
	Callback = function(isSpectateSelectPlayersEnabled)
		SpectatePlys = isSpectateSelectPlayersEnabled
		spawn(function()
			repeat
				task.wait(0.1)

				if _G.PlayersList then
					if game:GetService("Players"):FindFirstChild(_G.PlayersList) then
						workspace.Camera.CameraSubject = game:GetService("Players"):FindFirstChild(_G.PlayersList).Character.Humanoid
					end
				end
			until not SpectatePlys

			workspace.Camera.CameraSubject = LocalPlayer2.Character.Humanoid
		end)
	end
})

do
	GRP_Combat_Combat_AimBot:AddDropdown("Select_Aim_Method", {
		Text = "Select Aim Method",
		Values = {
			"Aim Player",
			"Nearest Aim"
		},
		Default = 1,
		Callback = function(isAimbotMethodSkillsEnabled)
			ABmethod = isAimbotMethodSkillsEnabled
		end
	})
end

GRP_Combat_Combat_AimBot:AddToggle("Aimbot_Method_Skills", {
	Text = "Aimbot Method Skills",
	Default = false,
	Callback = function(isAimbotMethodSkillsEnabledCurrent)
		_G.AimMethod = isAimbotMethodSkillsEnabledCurrent
	end
})
spawn(function()
	while wait() do
		pcall(function()
			if _G.AimMethod and ABmethod == "Aim Player" then
				local locatedInstanceCandidate = Players:FindFirstChild(getgenv().PlayersList)

				if locatedInstanceCandidate and locatedInstanceCandidate.Character then
					if locatedInstanceCandidate.Character:FindFirstChild("HumanoidRootPart") and locatedInstanceCandidate.Team ~= LocalPlayer2.Team then
						MousePos = locatedInstanceCandidate.Character.HumanoidRootPart.Position
					end
				end
			end
		end)
	end
end)

do
	spawn(function()
		while wait() do
			pcall(function()
				if _G.AimMethod and ABmethod == "Nearest Aim" then
					local huge = math.huge

					for _, player in pairs(Players:GetPlayers()) do
						if player ~= LocalPlayer2 and player.Team ~= LocalPlayer2.Team and player.Character then
							if player.Character:FindFirstChild("HumanoidRootPart") then
								local Magnitude = (player.Character.HumanoidRootPart.Position - LocalPlayer2.Character.HumanoidRootPart.Position).Magnitude

								if Magnitude < huge then
									huge = Magnitude
									MousePos = player.Character.HumanoidRootPart.Position
								end
							end
						end
					end
				end
			end)
		end
	end)
end

do
	GRP_Combat_Combat_AimBot:AddToggle("Aimbot_Camera_Closet_Players", {
		Text = "Aimbot Camera Closet Players",
		Default = false,
		Callback = function(isAimbotCameraClosetPlayersEnabled)
			_G.AimCam = isAimbotCameraClosetPlayersEnabled
		end
	})
end

task.spawn(function()
	while task.wait(Sec) do
		pcall(function()
			if _G.AimCam then
				local CurrentCamera = workspace.CurrentCamera

				closestplayer = function()
					local huge = math.huge
					local closestplayerPlayerData
					local players, closestplayerPlayerDataState = ply:GetPlayers()

					for _, playervalueaiPlayerData in next, players, closestplayerPlayerDataState do
						if playervalueaiPlayerData ~= LocalPlayer2 and playervalueaiPlayerData.Character then
							if playervalueaiPlayerData.Character:FindFirstChild("Head") and _G.AimCam and playervalueaiPlayerData.Character.Humanoid.Health > 0 then
								local Magnitude = (playervalueaiPlayerData.Character.Head.Position - LocalPlayer2.Character.Head.Position).Magnitude

								if Magnitude < huge then
									huge = Magnitude
									closestplayerPlayerData = playervalueaiPlayerData
								end
							end
						end
					end

					return closestplayerPlayerData
				end

				while true do
					task.wait()
					CurrentCamera.CFrame = CFrame.new(CurrentCamera.CFrame.Position, closestplayer().Character.HumanoidRootPart.Position)

					if _G.AimCam == false then
						break
					elseif dist < Mag then
						break
					end
				end
			end
		end)
	end
end)
GRP_Combat_Quests_Players = tabs.Combat:AddLeftGroupbox("Quests Players")

do
	GRP_Combat_Quests_Players:AddButton({
		Text = "Get player quests",
		Func = function()
		end
	})
end

do
	GRP_Combat_Quests_Players:AddToggle("Auto_Get_PlayerQuest", {
		Text = "Auto Get PlayerQuest",
		Default = false,
		Callback = function(isAutoGetPlayerquestEnabled)
			_G.AutoReceivePlayerQuest = isAutoGetPlayerquestEnabled
		end
	})
end

spawn(function()
	while task.wait(1) do
		if _G.AutoReceivePlayerQuest then
			local exitTo

			repeat
				pcall(function()
					game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("PlayerHunter")
				end)
				exitTo = nil

				while task.wait(1) do
					if _G.AutoReceivePlayerQuest then
						exitTo = 1

						break
					end
				end
			until exitTo ~= 1

			return
		end
	end
end)

do
	GRP_Combat_Quests_Players:AddToggle("Auto_Kill_Player_Quest", {
		Text = "Auto Kill Player Quest",
		Default = false,
		Callback = function(isAutoKillPlayerQuestEnabled)
			_G.AutoPlayerHunter = isAutoKillPlayerQuestEnabled
		end
	})
end

spawn(function()
	while task.wait() do
		if _G.AutoPlayerHunter then
			if game.Players.LocalPlayer.PlayerGui.Main.Quest.Visible == false then
				task.wait(0.5)
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("PlayerHunter")
			else
				for _, child in pairs(game:GetService("Workspace").Characters:GetChildren()) do
					if string.find(game.Players.LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, child.Name) then
						repeat
							task.wait()

							if AutoHaki then
								AutoHaki()
							end

							if EquipWeapon then
								EquipWeapon(_G.SelectWeapon)
							end

							Useskill = true
							_tp(child.HumanoidRootPart.CFrame * CFrame.new(1, 7, 3))
							child.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
							game:GetService("VirtualUser"):CaptureController()
							game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
						until _G.AutoPlayerHunter == false or child.Humanoid.Health <= 0

						Useskill = false
						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
					end
				end
			end
		end
	end
end)

do
	GRP_Combat_Quests_Players:AddToggle("Auto_Enable_PvP", {
		Text = "Auto Enable PvP",
		Default = false,
		Callback = function(isAutoEnablePvpEnabled)
			_G.AutoPvP = isAutoEnablePvpEnabled
		end
	})
end

spawn(function()
	while task.wait(0.5) do
		if _G.AutoPvP then
			local PlayerGui = game.Players.LocalPlayer.PlayerGui

			if PlayerGui and PlayerGui.Main then
				if PlayerGui.Main:FindFirstChild("PvpDisabled") and PlayerGui.Main.PvpDisabled.Visible then
					pcall(function()
						game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EnablePvp")
					end)
				end
			end
		end
	end
end)

do
	GRP_Combat_Quests_Players:AddToggle("Auto_Safe_Mode", {
		Text = "Auto Safe Mode",
		Default = false,
		Callback = function(isAutoSafeModeEnabled)
			_G.SafeMode = isAutoSafeModeEnabled
		end
	})
end

spawn(function()
	while task.wait(0.1) do
		if _G.SafeMode then
			local Character = game.Players.LocalPlayer.Character

			if Character then
				local exitTo2

				repeat
					local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

					exitTo2 = nil

					while true do
						if HumanoidRootPart then
							_tp(HumanoidRootPart.CFrame * CFrame.new(0, 1000, 0))
						end

						local exitTo

						while task.wait(0.1) do
							if _G.SafeMode then
								exitTo = 1

								break
							end
						end

						if exitTo ~= 1 then
							break
						end

						Character = game.Players.LocalPlayer.Character
						HumanoidRootPart = Character

						if HumanoidRootPart then
							exitTo2 = 1

							break
						end
					end
				until exitTo2 ~= 1

				return
			end
		end
	end
end)
GRP_Combat_LocalPlayer_Settings = tabs.Combat:AddLeftGroupbox("LocalPlayer Settings")

do
	local Players2 = game:GetService("Players")

	game:GetService("UserInputService")

	local RunService = game:GetService("RunService")
	local LocalPlayer3 = Players2.LocalPlayer
	local activeConnection = false
	local n10 = 50
	local connection
	local playerCollectionNext = {
		f = 0,
		b = 0,
		l = 0,
		r = 0
	}
	local BodyGyro
	local BodyVelocity

	local function playervaluestoredPlayerData()
		local function playervaluecomputedPlayerData()
			local Character = LocalPlayer3.Character

			if not Character then
				return
			end

			local Humanoid = Character:FindFirstChildOfClass("Humanoid")

			if not Humanoid then
				return
			end

			local MoveDirection = Humanoid.MoveDirection

			playerCollectionNext.f = 0
			playerCollectionNext.b = 0
			playerCollectionNext.l = 0
			playerCollectionNext.r = 0

			if MoveDirection.Z < -0.1 then
				playerCollectionNext.f = 1
			elseif MoveDirection.Z > 0.1 then
				playerCollectionNext.b = 1
			end

			if MoveDirection.X < -0.1 then
				playerCollectionNext.l = 1
			elseif MoveDirection.X > 0.1 then
				playerCollectionNext.r = 1
			end
		end

		local connection2

		connection2 = connectScoped(RunService.Heartbeat, function()
			if activeConnection then
				playervaluecomputedPlayerData()
			elseif connection2 then
				connection2:Disconnect()
			end
		end)
	end
	local function playervalueupdatedPlayerData(valueArgumentSecondary)
		activeConnection = valueArgumentSecondary

		if activeConnection then
			if not LocalPlayer3.Character then
				return
			end

			local Humanoid = LocalPlayer3.Character:FindFirstChildOfClass("Humanoid")
			local Torso

			if LocalPlayer3.Character:FindFirstChild("Torso") then
				Torso = LocalPlayer3.Character.Torso
			else
				Torso = LocalPlayer3.Character.UpperTorso
			end

			if not Humanoid or not Torso then
				return
			end

			for _, descendant in ipairs(LocalPlayer3.Character:GetDescendants()) do
				if descendant:IsA("BasePart") then
					descendant.CanCollide = false
					descendant.Massless = true
				end
			end

			connectScoped(LocalPlayer3.Character.DescendantAdded, function(descendant)
				if activeConnection and descendant:IsA("BasePart") then
					descendant.CanCollide = false
					descendant.Massless = true
				end
			end)
			BodyGyro = Instance.new("BodyGyro", Torso)
			BodyGyro.P = 90000
			BodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
			BodyGyro.cframe = Torso.CFrame
			BodyVelocity = Instance.new("BodyVelocity", Torso)
			BodyVelocity.velocity = Vector3.new(0, 0, 0)
			BodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)
			Humanoid.PlatformStand = true
			playervaluestoredPlayerData()
			connection = connectScoped(RunService.Heartbeat, function()
				if not activeConnection or not LocalPlayer3.Character then
					return
				end

				for _, descendant in ipairs(LocalPlayer3.Character:GetDescendants()) do
					if descendant:IsA("BasePart") and descendant.CanCollide then
						descendant.CanCollide = false
					end
				end

				if playerCollectionNext.l + playerCollectionNext.r == 0 and playerCollectionNext.f + playerCollectionNext.b == 0 then
					BodyVelocity.velocity = Vector3.new(0, 0, 0)
				else
					BodyVelocity.velocity = (workspace.CurrentCamera.CoordinateFrame.lookVector * (playerCollectionNext.f + playerCollectionNext.b) + (workspace.CurrentCamera.CoordinateFrame * CFrame.new(playerCollectionNext.l + playerCollectionNext.r, (playerCollectionNext.f + playerCollectionNext.b) * 0.2, 0).p - workspace.CurrentCamera.CoordinateFrame.p)) * n10
				end

				BodyGyro.cframe = workspace.CurrentCamera.CoordinateFrame
			end)
		else
			if connection then
				connection:Disconnect()
				connection = nil
			end

			if LocalPlayer3.Character then
				local Humanoid = LocalPlayer3.Character:FindFirstChildOfClass("Humanoid")

				if Humanoid then
					Humanoid.PlatformStand = false
				end

				for _, descendant in ipairs(LocalPlayer3.Character:GetDescendants()) do
					if descendant:IsA("BasePart") then
						descendant.CanCollide = true
						descendant.Massless = false
					end
				end

				if BodyGyro then
					BodyGyro:Destroy()
				end

				if BodyVelocity then
					BodyVelocity:Destroy()
				end
			end

			playerCollectionNext = {
				f = 0,
				b = 0,
				l = 0,
				r = 0
			}
		end
	end
	local function playervalueexpectedPlayerData(isEnableFlyEnabled)
		n10 = isEnableFlyEnabled
	end

	GRP_Combat_LocalPlayer_Settings:AddToggle("Enable_Fly", {
		Text = "Enable Fly",
		Default = false,
		Callback = function(isSpeedFlyModeEnabled)
			playervalueupdatedPlayerData(isSpeedFlyModeEnabled)
		end
	})
	GRP_Combat_LocalPlayer_Settings:AddSlider({
		Text = "Speed Fly Mode",
		Min = 10,
		Max = 200,
		Default = 50,
		Rounding = 0,
		Callback = function(isDashNoCooldownEnabled)
			playervalueexpectedPlayerData(isDashNoCooldownEnabled)
		end
	})
end

GRP_Combat_LocalPlayer_Settings:AddToggle("Dash_No_Cooldown", {
	Text = "Dash No Cooldown",
	Default = false,
	Callback = function(isDashNoCooldownEnabledCurrent)
		getgenv().DodgeNoCD = isDashNoCooldownEnabledCurrent
	end
})

do
	local function playervaluematchedPlayerDataState()
		local Dodge = game.Players.LocalPlayer.Character:WaitForChild("Dodge")
		local playervaluematchedPlayerDataItem, playervaluematchedPlayerData = getgc()

		for _, playervalueaiPlayerData in next, playervaluematchedPlayerDataItem, playervaluematchedPlayerData do
			if typeof(playervalueaiPlayerData) == "function" and getfenv(playervalueaiPlayerData).script == Dodge then
				local next_ = next
				local playervaluematchedPlayerDataEntry, playervaluematchedPlayerDataData = getupvalues(playervalueaiPlayerData)

				for k, getinfinityAbilityPlayerDataItem in next_, playervaluematchedPlayerDataEntry, playervaluematchedPlayerDataData do
					if tostring(getinfinityAbilityPlayerDataItem) == "0.4" then
						setupvalue(playervalueaiPlayerData, k, 0)
					end
				end
			end
		end
	end
end

do
	GRP_Combat_LocalPlayer_Settings:AddToggle("Instance_Mink_V3_[_INF_]", {
		Text = "Instance Mink V3 [ INF ]",
		Default = false,
		Callback = function(isInstanceMinkVInfEnabled)
			InfAblities = isInstanceMinkVInfEnabled
		end
	})
end

spawn(function()
	while wait(0.2) do
		pcall(function()
			if InfAblities then
				if not LocalPlayer2.Character.HumanoidRootPart:FindFirstChild("Agility") then
					local clone = ReplicatedStorage2.FX.Agility:Clone()

					clone.Name = "Agility"
					clone.Parent = LocalPlayer2.Character.HumanoidRootPart
				end
			else
				LocalPlayer2.Character.HumanoidRootPart.Agility:Destroy()
			end
		end)
	end
end)

do
	GRP_Combat_LocalPlayer_Settings:AddToggle("Instance_Energy_[_INF_]", {
		Text = "Instance Energy [ INF ]",
		Default = false,
		Callback = function(isInstanceEnergyInfEnabled)
			infEnergy = isInstanceEnergyInfEnabled

			if isInstanceEnergyInfEnabled then
				getInfinity_Ability("Energy", infEnergy)
			end
		end
	})
end

GRP_Combat_LocalPlayer_Settings:AddToggle("Instance_Soru_[_INF_]", {
	Text = "Instance Soru [ INF ]",
	Default = false,
	Callback = function(isInstanceSoruInfEnabled)
		_G.InfSoru = isInstanceSoruInfEnabled

		if isInstanceSoruInfEnabled then
			getInfinity_Ability("Soru", _G.InfSoru)
		end
	end
})

do
	GRP_Combat_LocalPlayer_Settings:AddToggle("Instance_Observation_Range_[_INF_]", {
		Text = "Instance Observation Range [ INF ]",
		Default = false,
		Callback = function(isInstanceObservationRangeInfEnabled)
			_G.InfiniteObRange = isInstanceObservationRangeInfEnabled

			if isInstanceObservationRangeInfEnabled then
				getInfinity_Ability("Observation", _G.InfiniteObRange)
			end
		end
	})
end

GRP_Combat_LocalPlayer_Settings:AddToggle("Ignore_Same_Teams", {
	Text = "Ignore Same Teams",
	Default = false,
	Callback = function(isAcceptAlliesEnabled)
		_G.NoAimTeam = isAcceptAlliesEnabled
	end
})

do
	GRP_Combat_LocalPlayer_Settings:AddToggle("Accept_Allies", {
		Text = "Accept Allies",
		Default = false,
		Callback = function(isAcceptAlliesEnabledCurrent)
			_G.AcceptAlly = isAcceptAlliesEnabledCurrent
		end
	})
end

spawn(function()
	while wait(Sec) do
		if _G.AcceptAlly then
			pcall(function()
				for _, child in pairs(ply:GetChildren()) do
					if child.Name ~= LocalPlayer2.Name and child:FindFirstChild("Humanoid") and child:FindFirstChild("HumanoidRootPart") then
						ReplicatedStorage2:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("AcceptAlly", child.Name)
					end
				end
			end)
		end
	end
end)
GRP_Travel_Travel_Worlds = tabs.Travel:AddLeftGroupbox("Travel - Worlds")

do
	GRP_Travel_Travel_Worlds:AddButton({
		Text = "Travel East Blue (World 1)",
		Func = function()
		end
	})
end

do
	GRP_Travel_Travel_Worlds:AddButton({
		Text = "Travel Dressrosa (World 2)",
		Func = function()
		end
	})
end

do
	GRP_Travel_Travel_Worlds:AddButton({
		Text = "Travel Zou (World 3)",
		Func = function()
		end
	})
end

GRP_Travel_Travel_Island = tabs.Travel:AddLeftGroupbox("Travel - Island")
Location = {}

for _, child in pairs(workspace._WorldOrigin.Locations:GetChildren()) do
	table.insert(Location, child.Name)
end

do
	Travelllll = GRP_Travel_Travel_Island:AddDropdown("Select_Travelling", {
		Text = "Select Travelling",
		Values = Location,
		Default = 1,
		Callback = function(isAutoTravelEnabled)
			_G.Island = isAutoTravelEnabled
		end
	})
end

do
	GoIsland = GRP_Travel_Travel_Island:AddToggle("Auto_Travel", {
		Text = "Auto Travel",
		Default = false,
		Callback = function(isAutoTravelEnabledCurrent)
			_G.Teleport = isAutoTravelEnabledCurrent

			if isAutoTravelEnabledCurrent then
				for _, child in pairs(workspace._WorldOrigin.Locations:GetChildren()) do
					if child.Name == _G.Island then
						while true do
							wait()
							_tp(child.CFrame * CFrame.new(0, 30, 0))

							if _G.Teleport then
								if Root.CFrame == child.CFrame then
									break
								end
							else
								break
							end
						end
					end
				end
			end
		end
	})
end

GRP_Travel_Travel_Portal = tabs.Travel:AddLeftGroupbox("Travel - Portal")

if World1 then
	Location_Portal = {
		"Sky",
		"UnderWater"
	}
elseif World2 then
	Location_Portal = {
		"SwanRoom",
		"Cursed Ship"
	}
elseif World3 then
	Location_Portal = {
		"Castle On The Sea",
		"Mansion Cafe",
		"Hydra Teleport",
		"Canvendish Room",
		"Temple of Time"
	}
end

PortalTP = GRP_Travel_Travel_Portal:AddDropdown("Select_Portal", {
	Text = "Select Portal",
	Values = Location_Portal,
	Default = 1,
	Callback = function(selectedRequestentrance)
		_G.Island_PT = selectedRequestentrance
	end
})

do
	GRP_Travel_Travel_Portal:AddButton({
		Text = "requestEntrance",
		Func = function()
		end
	})
end

GRP_Travel_Travel_NPCs = tabs.Travel:AddLeftGroupbox("Travel - NPCs")

for _, child in pairs(ReplicatedStorage2.NPCs:GetChildren()) do
	table.insert(NPCList, child.Name)
end

do
	NPCsPos = GRP_Travel_Travel_NPCs:AddDropdown("Select_NPCs", {
		Text = "Select NPCs",
		Values = NPCList,
		Default = 1,
		Callback = function(isAutoTweenToNpcEnabled)
			_G.TPNpc = isAutoTweenToNpcEnabled
		end
	})
end

do
	GoNPCs = GRP_Travel_Travel_NPCs:AddToggle("Auto_Tween_to_NPC", {
		Text = "Auto Tween to NPC",
		Default = false,
		Callback = function(isAutoTweenToNpcEnabledCurrent)
			_G.TPNpc = isAutoTweenToNpcEnabledCurrent
		end
	})
end

spawn(function()
	while wait(Sec) do
		if _G.TPNpc then
			pcall(function()
				for _, child in pairs(ReplicatedStorage2.NPCs:GetChildren()) do
					if child.Name == NPClist then
						_tp(child.HumanoidRootPart.CFrame)
					end
				end
			end)
		end
	end
end)
GRP_Shop_Shop_Options = tabs.Shop:AddLeftGroupbox("Shop Options")
GRP_Shop_Shop_Options:AddButton({
	Text = "Buy Buso",
	Func = function()
		ReplicatedStorage2.Remotes.CommF_:InvokeServer("BuyHaki", "Buso")
	end
})

do
	GRP_Shop_Shop_Options:AddButton({
		Text = "Buy Geppo",
		Func = function()
			ReplicatedStorage2.Remotes.CommF_:InvokeServer("BuyHaki", "Geppo")
		end
	})
end

GRP_Shop_Shop_Options:AddButton({
	Text = "Buy Soru",
	Func = function()
		ReplicatedStorage2.Remotes.CommF_:InvokeServer("BuyHaki", "Soru")
	end
})
GRP_Shop_Shop_Options:AddButton({
	Text = "Buy Ken",
	Func = function()
		ReplicatedStorage2.Remotes.CommF_:InvokeServer("KenTalk", "Buy")
	end
})
GRP_Shop_Fighting_Style = tabs.Shop:AddLeftGroupbox("Fighting - Style")

do
	GRP_Shop_Fighting_Style:AddButton({
		Text = "Buy Black Leg",
		Func = function()
			ReplicatedStorage2.Remotes.CommF_:InvokeServer("BuyBlackLeg")
		end
	})
end

GRP_Shop_Fighting_Style:AddButton({
	Text = "Buy Electro",
	Func = function()
		ReplicatedStorage2.Remotes.CommF_:InvokeServer("BuyElectro")
	end
})
GRP_Shop_Fighting_Style:AddButton({
	Text = "Buy Fishman Karate",
	Func = function()
		ReplicatedStorage2.Remotes.CommF_:InvokeServer("BuyFishmanKarate")
	end
})

do
	GRP_Shop_Fighting_Style:AddButton({
		Text = "Buy DragonClaw",
		Func = function()
			ReplicatedStorage2.Remotes.CommF_:InvokeServer("BlackbeardReward", "DragonClaw", "2")
		end
	})
end

do
	GRP_Shop_Fighting_Style:AddButton({
		Text = "Buy Superhuman",
		Func = function()
			ReplicatedStorage2.Remotes.CommF_:InvokeServer("BuySuperhuman")
		end
	})
end

GRP_Shop_Fighting_Style:AddButton({
	Text = "Buy Death Step",
	Func = function()
		ReplicatedStorage2.Remotes.CommF_:InvokeServer("BuyDeathStep")
	end
})

do
	GRP_Shop_Fighting_Style:AddButton({
		Text = "Buy Sharkman Karate",
		Func = function()
			ReplicatedStorage2.Remotes.CommF_:InvokeServer("BuySharkmanKarate")
		end
	})
end

do
	GRP_Shop_Fighting_Style:AddButton({
		Text = "Buy ElectricClaw",
		Func = function()
			ReplicatedStorage2.Remotes.CommF_:InvokeServer("BuyElectricClaw")
		end
	})
end

GRP_Shop_Fighting_Style:AddButton({
	Text = "Buy DragonTalon",
	Func = function()
		ReplicatedStorage2.Remotes.CommF_:InvokeServer("BuyDragonTalon")
	end
})
GRP_Shop_Fighting_Style:AddButton({
	Text = "Buy Godhuman",
	Func = function()
		ReplicatedStorage2.Remotes.CommF_:InvokeServer("BuyGodhuman")
	end
})
GRP_Shop_Fighting_Style:AddButton({
	Text = "Buy SanguineArt",
	Func = function()
		ReplicatedStorage2.Remotes.CommF_:InvokeServer("BuySanguineArt")
	end
})
GRP_Shop_Accessory = tabs.Shop:AddLeftGroupbox("Accessory")

do
	GRP_Shop_Accessory:AddButton({
		Text = "Buy Tomoe Ring",
		Func = function()
			ReplicatedStorage2.Remotes.CommF_:InvokeServer("BuyItem", "Tomoe Ring")
		end
	})
end

GRP_Shop_Accessory:AddButton({
	Text = "Buy Black Cape",
	Func = function()
		ReplicatedStorage2.Remotes.CommF_:InvokeServer("BuyItem", "Black Cape")
	end
})

do
	GRP_Shop_Accessory:AddButton({
		Text = "Buy Swordsman Hat",
		Func = function()
			ReplicatedStorage2.Remotes.CommF_:InvokeServer("BuyItem", "Swordsman Hat")
		end
	})
end

GRP_Shop_Accessory:AddButton({
	Text = "Buy Bizarre Rifle",
	Func = function()
		ReplicatedStorage2.Remotes.CommF_:InvokeServer("Ectoplasm", "Buy", 1)
	end
})

do
	GRP_Shop_Accessory:AddButton({
		Text = "Buy Ghoul Mask",
		Func = function()
			ReplicatedStorage2.Remotes.CommF_:InvokeServer("Ectoplasm", "Buy", 2)
		end
	})
end

GRP_Shop_Weapon_World1 = tabs.Shop:AddLeftGroupbox("Weapon World1")

do
	GRP_Shop_Weapon_World1:AddButton({
		Text = "Buy Cutlass",
		Func = function()
			ReplicatedStorage2.Remotes.CommF_:InvokeServer("BuyItem", "Cutlass")
		end
	})
end

GRP_Shop_Weapon_World1:AddButton({
	Text = "Buy Katana",
	Func = function()
		ReplicatedStorage2.Remotes.CommF_:InvokeServer("BuyItem", "Katana")
	end
})

do
	GRP_Shop_Weapon_World1:AddButton({
		Text = "Buy Iron Mace",
		Func = function()
			ReplicatedStorage2.Remotes.CommF_:InvokeServer("BuyItem", "Iron Mace")
		end
	})
end

do
	GRP_Shop_Weapon_World1:AddButton({
		Text = "Buy Duel Katana",
		Func = function()
			ReplicatedStorage2.Remotes.CommF_:InvokeServer("BuyItem", "Duel Katana")
		end
	})
end

do
	GRP_Shop_Weapon_World1:AddButton({
		Text = "Buy Triple Katana",
		Func = function()
			ReplicatedStorage2.Remotes.CommF_:InvokeServer("BuyItem", "Triple Katana")
		end
	})
end

GRP_Shop_Weapon_World1:AddButton({
	Text = "Buy Pipe",
	Func = function()
		ReplicatedStorage2.Remotes.CommF_:InvokeServer("BuyItem", "Pipe")
	end
})

do
	GRP_Shop_Weapon_World1:AddButton({
		Text = "Buy Dual-Headed Blade",
		Func = function()
			ReplicatedStorage2.Remotes.CommF_:InvokeServer("BuyItem", "Dual-Headed Blade")
		end
	})
end

do
	GRP_Shop_Weapon_World1:AddButton({
		Text = "Buy Bisento",
		Func = function()
			ReplicatedStorage2.Remotes.CommF_:InvokeServer("BuyItem", "Bisento")
		end
	})
end

GRP_Shop_Weapon_World1:AddButton({
	Text = "Buy Soul Cane",
	Func = function()
		ReplicatedStorage2.Remotes.CommF_:InvokeServer("BuyItem", "Soul Cane")
	end
})

do
	GRP_Shop_Weapon_World1:AddButton({
		Text = "Buy Slingshot",
		Func = function()
			ReplicatedStorage2.Remotes.CommF_:InvokeServer("BuyItem", "Slingshot")
		end
	})
end

do
	GRP_Shop_Weapon_World1:AddButton({
		Text = "Buy Musket",
		Func = function()
			ReplicatedStorage2.Remotes.CommF_:InvokeServer("BuyItem", "Musket")
		end
	})
end

GRP_Shop_Weapon_World1:AddButton({
	Text = "Buy Dual Flintlock",
	Func = function()
		ReplicatedStorage2.Remotes.CommF_:InvokeServer("BuyItem", "Dual Flintlock")
	end
})

do
	GRP_Shop_Weapon_World1:AddButton({
		Text = "Buy Flintlock",
		Func = function()
			ReplicatedStorage2.Remotes.CommF_:InvokeServer("BuyItem", "Flintlock")
		end
	})
end

do
	GRP_Shop_Weapon_World1:AddButton({
		Text = "Buy Refined Flintlock",
		Func = function()
			ReplicatedStorage2.Remotes.CommF_:InvokeServer("BuyItem", "Refined Flintlock")
		end
	})
end

GRP_Shop_Weapon_World1:AddButton({
	Text = "Buy Cannon",
	Func = function()
		ReplicatedStorage2.Remotes.CommF_:InvokeServer("BuyItem", "Cannon")
	end
})
GRP_Shop_Weapon_World1:AddButton({
	Text = "Buy Kabucha",
	Func = function()
		ReplicatedStorage2.Remotes.CommF_:InvokeServer("BlackbeardReward", "Slingshot", "2")
	end
})
GRP_Shop_Fragments_shop = tabs.Shop:AddLeftGroupbox("Fragments shop")
GRP_Shop_Fragments_shop:AddButton({
	Text = "Buy Refund Stats",
	Func = function()
		ReplicatedStorage2.Remotes.CommF_:InvokeServer("BlackbeardReward", "Refund", "2")
	end
})

do
	GRP_Shop_Fragments_shop:AddButton({
		Text = "Buy Reroll Race",
		Func = function()
			ReplicatedStorage2.Remotes.CommF_:InvokeServer("BlackbeardReward", "Reroll", "2")
		end
	})
end

GRP_Shop_Fragments_shop:AddButton({
	Text = "Buy Ghoul Race",
	Func = function()
		ReplicatedStorage2.Remotes.CommF_:InvokeServer("Ectoplasm", " Change", 4)
	end
})
GRP_Shop_Fragments_shop:AddButton({
	Text = "Buy Cyborg Race (2.5k)",
	Func = function()
		ReplicatedStorage2.Remotes.CommF_:InvokeServer("CyborgTrainer", " Buy")
	end
})
GRP_Shop_Fragments_shop:AddButton({
	Text = "Buy Draco Race",
	Func = function()
		task.spawn(function()
			_tp(CFrame.new(5814.42724609375, 1208.3267822265625, 884.57855224609375))

			local vector3 = Vector3.new(5814.42724609375, 1208.3267822265625, 884.57855224609375)

			while true do
				task.wait()

				if not LocalPlayer2.Character then
					continue
				end

				if LocalPlayer2.Character.HumanoidRootPart and (LocalPlayer2.Character.HumanoidRootPart.Position - vector3).Magnitude < 1 then
					break
				end
			end

			ReplicatedStorage2.Modules.Net:FindFirstChild("RF/InteractDragonQuest"):InvokeServer(unpack({ {
				NPC = "Dragon Wizard",
				Command = "DragonRace"
			} }))
		end)
	end
})
GRP_Misc_Server_Function = tabs.Misc:AddLeftGroupbox("Server - Function")
GRP_Misc_Server_Function:AddButton({
	Text = "Redeem All Codes",
	Func = function()
		local questDataPrevious = {
			"LIGHTNINGABUSE",
			"1LOSTADMIN",
			"ADMINFIGHT",
			"GIFTING_HOURS",
			"NOMOREHACK",
			"BANEXPLOIT",
			"WildDares",
			"BossBuild",
			"GetPranked",
			"EARN_FRUITS",
			"SUB2GAMERROBOT_RESET1",
			"KITT_RESET",
			"Bignews",
			"CHANDLER",
			"Fudd10",
			"fudd10_v2",
			"Sub2UncleKizaru",
			"FIGHT4FRUIT",
			"kittgaming",
			"TRIPLEABUSE",
			"Sub2CaptainMaui",
			"Sub2Fer999",
			"Enyu_is_Pro",
			"Magicbus",
			"JCWK",
			"Starcodeheo",
			"Bluxxy",
			"SUB2GAMERROBOT_EXP1",
			"Sub2NoobMaster123",
			"Sub2Daigrock",
			"Axiore",
			"TantaiGaming",
			"StrawHatMaine",
			"Sub2OfficialNoobie",
			"TheGreatAce",
			"JULYUPDATE_RESET",
			"ADMINHACKED",
			"SEATROLLING",
			"24NOADMIN",
			"ADMIN_TROLL",
			"NEWTROLL",
			"SECRET_ADMIN",
			"staffbattle",
			"NOEXPLOIT",
			"NOOB2ADMIN",
			"CODESLIDE",
			"fruitconcepts",
			"krazydares"
		}
		local Redeem = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):FindFirstChild("Redeem")

		if not Redeem then
			return
		end

		for _, playervalueaiPlayerData in ipairs(questDataPrevious) do
			task.wait(0)
			pcall(function()
				if Redeem.InvokeServer then
					Redeem:InvokeServer(playervalueaiPlayerData)
				else
					Redeem:FireServer(playervalueaiPlayerData)
				end
			end)
		end
	end
})
GRP_Misc_Server_Function:AddButton({
	Text = "Rejoin Server",
	Func = function()
		game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
	end
})
GRP_Misc_Server_Function:AddButton({
	Text = "Hop Server",
	Func = function()
		task.spawn(function()
			local HttpService = game:GetService("HttpService")
			local TeleportService_ = game:GetService("TeleportService")
			local Players2 = game:GetService("Players")
			local ok, resultassignedResult = pcall(function()
				local response = game:HttpGet("https://games.roblox.com/playervalueaiPlayerData/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")

				return HttpService:JSONDecode(response).data
			end)

			if ok and resultassignedResult then
				local id

				for _, playervalueaiPlayerData in pairs(resultassignedResult) do
					if playervalueaiPlayerData.playing < playervalueaiPlayerData.maxPlayers then
						id = playervalueaiPlayerData.id
					end
				end

				if id then
					pcall(function()
						TeleportService_:TeleportToPlaceInstance(game.PlaceId, id, Players2.LocalPlayer)
					end)
				end
			end
		end)
	end
})
GRP_Misc_Server_Function:AddButton({
	Text = "Hop to Lowest Players",
	Func = function()
		local HttpService = game:GetService("HttpService")
		local TeleportService_ = game:GetService("TeleportService")
		local funcPlayerData = "https://games.roblox.com/playervalueaiPlayerData/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"

		local function playervaluevalidatedPlayerDataState(valueArgumentTemporary)
			local response = game:HttpGet(funcPlayerData .. (valueArgumentTemporary and "&cursor=" .. valueArgumentTemporary or ""))

			return HttpService:JSONDecode(response)
		end

		local nextPageCursor
		local playervaluevalidatedResult

		repeat
			local playervaluevalidatedPlayerData = playervaluevalidatedPlayerDataState(nextPageCursor)

			playervaluevalidatedResult = playervaluevalidatedPlayerData.data[1]
			nextPageCursor = playervaluevalidatedPlayerData.nextPageCursor
		until playervaluevalidatedResult

		TeleportService_:TeleportToPlaceInstance(game.PlaceId, playervaluevalidatedResult.id, LocalPlayer2)
	end
})

local ReplicatedStorage3 = game:GetService("ReplicatedStorage")

GRP_Misc_Server_Function:AddButton({
	Text = "Hop to Lowest Pings Server",
	Func = function()
		local HttpService = game:GetService("HttpService")
		local TeleportService_ = game:GetService("TeleportService")
		local Stats_ = game:GetService("Stats")

		local function resultsecondaryResult(valueArgumentPending, valueArgumentLatest)
			local resultsecondaryData = string.format("https://games.roblox.com/playervalueaiPlayerData/games/%d/servers/Public?limit=%d", valueArgumentPending, valueArgumentLatest)
			local ok, resultassignedResult = pcall(function()
				return HttpService:JSONDecode(game:HttpGet(resultsecondaryData))
			end)

			if ok and resultassignedResult and resultassignedResult.data then
				return resultassignedResult.data
			end

			return nil
		end

		local resultsecondaryResultState = resultsecondaryResult(game.PlaceId, 100)

		if not resultsecondaryResultState then
			return
		end

		local resultsecondaryPlayerData = resultsecondaryResultState[1]

		for _, playervalueaiPlayerData in pairs(resultsecondaryResultState) do
			if playervalueaiPlayerData.ping < resultsecondaryPlayerData.ping and playervalueaiPlayerData.playing < playervalueaiPlayerData.maxPlayers then
				resultsecondaryPlayerData = playervalueaiPlayerData
			end
		end

		if tonumber(Stats_.Network.ServerStatsItem["Data Ping"]:GetValueString():match("(%d+)")) >= 100 then
			TeleportService_:TeleportToPlaceInstance(game.PlaceId, resultsecondaryPlayerData.id)
		end
	end
})

do
	GRP_Misc_Server_Function:AddInput("Input_Job_Id", {
		Text = "Input Job Id",
		Default = "",
		Placeholder = "Job ID",
		Callback = function(teleportJobIdInput)
			_G.Rechat = teleportJobIdInput
		end
	})
end

GRP_Misc_Server_Function:AddButton({
	Text = "Teleport [Job ID]",
	Func = function()
		if _G.Rechat and _G.Rechat ~= "" then
			game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, _G.Rechat, LocalPlayer2)
		end
	end
})

do
	GRP_Misc_Server_Function:AddButton({
		Text = "Copy JobID",
		Func = function()
			setclipboard(tostring(game.JobId))
		end
	})
end

GRP_Misc_Player_Gui_Others = tabs.Misc:AddLeftGroupbox("Player Gui / Others")
GRP_Misc_Player_Gui_Others:AddButton({
	Text = "Open Awakenings Expert",
	Func = function()
		LocalPlayer2.PlayerGui.Main.AwakeningToggler.Visible = true
	end
})
GRP_Misc_Player_Gui_Others:AddButton({
	Text = "Open Title Selection",
	Func = function()
		ReplicatedStorage3.Remotes.CommF_:InvokeServer("getTitles", true)
		LocalPlayer2.PlayerGui.Main.Titles.Visible = true
	end
})
DisbleChat = GRP_Misc_Player_Gui_Others:AddToggle("Disable_Chat_GUI", {
	Text = "Disable Chat GUI",
	Default = false,
	Callback = function(isDisableChatGuiEnabled)
		_G.Rechat = isDisableChatGuiEnabled

		if _G.Rechat == true then
			game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
		elseif _G.Rechat == false then
			game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)
		end
	end
})

do
	DisbleLeaderB = GRP_Misc_Player_Gui_Others:AddToggle("Disable_Leader_Board_GUI", {
		Text = "Disable Leader Board GUI",
		Default = false,
		Callback = function(isDisableLeaderBoardGuiEnabled)
			ReLeader = isDisableLeaderBoardGuiEnabled

			if ReLeader == true then
				game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
			elseif ReLeader == false then
				game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, true)
			end
		end
	})
end

GRP_Misc_Player_Gui_Others:AddButton({
	Text = "Set Pirate Team",
	Func = function()
		ReplicatedStorage3.Remotes.CommF_:InvokeServer("SetTeam", "Pirates")
	end
})

do
	GRP_Misc_Player_Gui_Others:AddButton({
		Text = "Set Marine Team",
		Func = function()
			ReplicatedStorage3.Remotes.CommF_:InvokeServer("SetTeam", "Marines")
		end
	})
end

UnPortal = GRP_Misc_Player_Gui_Others:AddToggle("Unlock_All_Portals", {
	Text = "Unlock All Portals",
	Default = false,
	Callback = function(isUnlockAllPortalsEnabled)
		_G.PortalUnLock = isUnlockAllPortalsEnabled
	end
})
spawn(function()
	while wait(Sec) do
		pcall(function()
			if _G.PortalUnLock then
				if playerCollectionLatest.Pos(CstlePos_Miti, 8) then
					ReplicatedStorage3.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(-12471.169921875, 374.94024658203, -7551.677734375))
				elseif playerCollectionLatest.Pos(Man3Pos_Miti, 8) then
					ReplicatedStorage3.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(-5072.08984375, 314.5412902832, -3151.1098632812))
				elseif playerCollectionLatest.Pos(HydraPos_Miti, 8) then
					ReplicatedStorage3.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(5748.7587890625, 610.44982910156, -267.81704711914))
				elseif playerCollectionLatest.Pos(HydratoCastle, 8) then
					ReplicatedStorage3.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(-5072.08984375, 314.5412902832, -3151.1098632812))
				end
			end
		end)
	end
end)
GRP_Misc_Graphics_Haki_Stats = tabs.Misc:AddLeftGroupbox("Graphics / Haki Stats")
HakiSt = {
	"State 0",
	"State 1",
	"State 2",
	"State 3",
	"State 4",
	"State 5"
}
HakiStat = GRP_Misc_Graphics_Haki_Stats:AddDropdown("Select_Haki_States", {
	Text = "Select Haki States",
	Values = HakiSt,
	Default = 1,
	Callback = function(selectedChangebusostage)
		_G.SelectStateHaki = selectedChangebusostage
	end
})

do
	GRP_Misc_Graphics_Haki_Stats:AddButton({
		Text = "ChangeBusoStage",
		Func = function()
			if _G.SelectStateHaki == "State 0" then
				ReplicatedStorage3.Remotes.CommF_:InvokeServer("ChangeBusoStage", 0)
			elseif _G.SelectStateHaki == "State 1" then
				ReplicatedStorage3.Remotes.CommF_:InvokeServer("ChangeBusoStage", 1)
			elseif _G.SelectStateHaki == "State 2" then
				ReplicatedStorage3.Remotes.CommF_:InvokeServer("ChangeBusoStage", 2)
			elseif _G.SelectStateHaki == "State 3" then
				ReplicatedStorage3.Remotes.CommF_:InvokeServer("ChangeBusoStage", 3)
			elseif _G.SelectStateHaki == "State 4" then
				ReplicatedStorage3.Remotes.CommF_:InvokeServer("ChangeBusoStage", 4)
			elseif _G.SelectStateHaki == "State 5" then
				ReplicatedStorage3.Remotes.CommF_:InvokeServer("ChangeBusoStage", 5)
			end
		end
	})
end

do
	rtxM = GRP_Misc_Graphics_Haki_Stats:AddToggle("Turn_on_RTX_Mode", {
		Text = "Turn on RTX Mode",
		Default = false,
		Callback = function(isTurnOnRtxModeEnabled)
			_G.RTXMode = isTurnOnRtxModeEnabled

			for _, child in pairs(game.Lighting:GetChildren()) do
				if child.Name == "RTXColorCorrection" or child.Name == "RTXTint" then
					child:Destroy()
				end
			end

			if _G.RTXMode then
				local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect", game.Lighting)

				ColorCorrectionEffect.Name = "RTXColorCorrection"

				local ColorCorrectionEffect2 = Instance.new("ColorCorrectionEffect", game.Lighting)

				ColorCorrectionEffect2.Name = "RTXTint"
				OldAmbient = game.Lighting.Ambient
				OldBrightness = game.Lighting.Brightness
				OldColorShift_Top = game.Lighting.ColorShift_Top
				OldBrightnessc = ColorCorrectionEffect.Brightness
				OldContrastc = ColorCorrectionEffect.Contrast
				OldTintColorc = ColorCorrectionEffect.TintColor
				OldTintColore = ColorCorrectionEffect2.TintColor
				ColorCorrectionEffect.Brightness = 0.176
				ColorCorrectionEffect.Contrast = 0.39
				ColorCorrectionEffect.TintColor = Color3.fromRGB(217, 145, 57)
				ColorCorrectionEffect2.TintColor = Color3.fromRGB(217, 145, 57)
				game.Lighting.FogEnd = 999
				spawn(function()
					while _G.RTXMode do
						wait()
						game.Lighting.Ambient = Color3.fromRGB(33, 33, 33)
						game.Lighting.Brightness = 0.3

						if not _G.RTXMode then
							break
						end

						if LocalPlayer2.Character then
							if LocalPlayer2.Character:FindFirstChild("HumanoidRootPart") then
								if not LocalPlayer2.Character.HumanoidRootPart:FindFirstChild("RTXPointLight") then
									local PointLight = Instance.new("PointLight")

									PointLight.Name = "RTXPointLight"
									PointLight.Parent = LocalPlayer2.Character.HumanoidRootPart
									PointLight.Range = 15
									PointLight.Color = Color3.fromRGB(217, 145, 57)
								end
							end
						end
					end
				end)
			else
				pcall(function()
					if OldAmbient then
						game.Lighting.Ambient = OldAmbient
					end

					if OldBrightness then
						game.Lighting.Brightness = OldBrightness
					end

					if OldColorShift_Top then
						game.Lighting.ColorShift_Top = OldColorShift_Top
					end

					game.Lighting.FogEnd = 2500
				end)

				for _, child in pairs(game.Lighting:GetChildren()) do
					if child.Name == "RTXColorCorrection" or child.Name == "RTXTint" then
						child:Destroy()
					end
				end

				if LocalPlayer2.Character then
					if LocalPlayer2.Character:FindFirstChild("HumanoidRootPart") then
						local RTXPointLight = LocalPlayer2.Character.HumanoidRootPart:FindFirstChild("RTXPointLight")

						if RTXPointLight then
							RTXPointLight:Destroy()
						end
					end
				end
			end
		end
	})
end

GRP_Misc_Graphics_Haki_Stats:AddButton({
	Text = "Turn on Fast Mode",
	Func = function()
		local descendants, descendantInstancesCurrent = workspace:GetDescendants()

		for _, playervalueaiPlayerData in next, descendants, descendantInstancesCurrent do
			if table.find(piratesEntriesState, playervalueaiPlayerData.ClassName) then
				playervalueaiPlayerData.Material = "Plastic"
			end
		end
	end
})
GRP_Misc_Graphics_Haki_Stats:AddButton({
	Text = "Turn on Low CPU",
	Func = function()
		LowCpu()
	end
})

do
	GRP_Misc_Graphics_Haki_Stats:AddButton({
		Text = "Turn on increase Boats",
		Func = function()
			for _, child in pairs(workspace.Boats:GetChildren()) do
				if tostring(child.Owner.Value) == tostring(LocalPlayer2.Name) then
					for _, descendant in pairs(child:GetDescendants()) do
						if descendant:IsA("VehicleSeat") then
							descendant.MaxSpeed = 350
							descendant.Torque = 0.2
							descendant.TurnSpeed = 5
							descendant.HeadsUpDisplay = true
						end
					end
				end
			end
		end
	})
end

GRP_Misc_Graphics_Haki_Stats:AddButton({
	Text = "Remove Sky Fog",
	Func = function()
		for _, child in pairs(game.Lighting:GetChildren()) do
			if child.Name == "Sky" or child.Name == "LightingLayers" or child.Name == "SeaTerrorCC" or child.Name == "FantasySky" then
				child:Destroy()
			end
		end
	end
})
GRP_Misc_Configure_God = tabs.Misc:AddLeftGroupbox("Configure - God")
GRP_Misc_Configure_God:AddButton({
	Text = "Rain Fruits (Client)",
	Func = function()
		if ReplicatedStorage3:FindFirstChild("Assets") then
			if ReplicatedStorage3.Assets:FindFirstChild("Models") then
				local children = ReplicatedStorage3.Assets.Models:GetChildren()

				for _, child in pairs(children) do
					if child:IsA("Model") and child.Name ~= "IceSpikes4" then
						local clone = child:Clone()

						clone.Parent = workspace

						if clone:FindFirstChild("Float") then
							clone.Float:Destroy()
						end

						clone:SetPrimaryPartCFrame(CFrame.new(LocalPlayer2.Character.HumanoidRootPart.Position + Vector3.new(math.random(-50, 50), 100, math.random(-50, 50))))
					end
				end
			end
		end
	end
})
briggt1 = GRP_Misc_Configure_God:AddToggle("Turn_on_Full_Bright", {
	Text = "Turn on Full Bright",
	Default = false,
	Callback = function(isSelectTimeEnabled)
		_G.SelectDN = isSelectTimeEnabled
	end
})
DayN = GRP_Misc_Configure_God:AddDropdown("Select_Time", {
	Text = "Select Time",
	Values = {
		"Day",
		"Night"
	},
	Default = 1,
	Callback = function(isTurnOnTimeEnabled)
		_G.SelectDN = isTurnOnTimeEnabled
	end
})
dayornight = GRP_Misc_Configure_God:AddToggle("Turn_on_Time", {
	Text = "Turn on Time",
	Default = false,
	Callback = function(isTurnOnTimeEnabledCurrent)
		_G.daylightN = isTurnOnTimeEnabledCurrent
	end
})

do
	task.spawn(function()
		while task.wait() do
			if _G.daylightN then
				if _G.SelectDN == "Day" then
					Lighting.ClockTime = 12
				elseif _G.SelectDN == "Night" then
					Lighting.ClockTime = 0
				end
			end
		end
	end)
end

walkWater = GRP_Misc_Configure_God:AddToggle("Turn_on_Walk_on_Water", {
	Text = "Turn on Walk on Water",
	Default = true,
	Callback = function(isTurnOnWalkOnWaterEnabled)
		_G.WalkWater_Part = isTurnOnWalkOnWaterEnabled

		if _G.WalkWater_Part then
			game:GetService("Workspace").Map["WaterBase-Plane"].Size = Vector3.new(1000, 112, 1000)
		else
			game:GetService("Workspace").Map["WaterBase-Plane"].Size = Vector3.new(1000, 80, 1000)
		end
	end
})

do
	iceWalk = GRP_Misc_Configure_God:AddToggle("Turn_on_Ice_Walk", {
		Text = "Turn on Ice Walk",
		Default = false,
		Callback = function(isTurnOnIceWalkEnabled)
			_G.WalkWater = isTurnOnIceWalkEnabled
		end
	})
end

do
	spawn(function()
		while task.wait() do
			if _G.WalkWater then
				pcall(function()
					if LocalPlayer2.Character then
						if LocalPlayer2.Character:FindFirstChild("LeftFoot") then
							local clone = ReplicatedStorage3.Assets.Models.IceSpikes4:Clone()

							clone.Parent = workspace
							clone.Size = Vector3.new(3 + math.random(10, 12), 1.7, 3 + math.random(10, 12))
							clone.Color = Color3.fromRGB(128, 187, 219)
							clone.CFrame = CFrame.new(LocalPlayer2.Character.Head.Position.X, -3.8, LocalPlayer2.Character.Head.Position.Z) * CFrame.Angles((math.random() - 0.5) * 0.06, math.random() * 7, (math.random() - 0.5) * 0.07)

							local locationDataSecondary = {
								Size = Vector3.new(0, 0.3, 0)
							}
							local tween = TW:Create(clone, TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), locationDataSecondary)

							connectScoped(tween.Completed, function()
								clone:Destroy()
							end)
							tween:Play()
						end
					end
				end)
			end
		end
	end)
end

do
	local LocalPlayer3 = game.Players.LocalPlayer

	local function playervaluedetectedPlayerData(isEnabledLatest)
		if not isEnabledLatest then
			return false
		end

		local Humanoid = isEnabledLatest:FindFirstChild("Humanoid")

		return Humanoid and Humanoid.Health > 0
	end
	local function playervaluecollectedPlayerData(valueArgumentNearby, valueArgumentVisible)
		local children = game:GetService("Workspace").Enemies:GetChildren()
		local players = game:GetService("Players"):GetPlayers()
		local locationDataTemporary = {}
		local Position = valueArgumentNearby:GetPivot().Position

		for _, child in ipairs(children) do
			local HumanoidRootPart = child:FindFirstChild("HumanoidRootPart")

			if HumanoidRootPart and playervaluedetectedPlayerData(child) and (HumanoidRootPart.Position - Position).Magnitude <= valueArgumentVisible then
				table.insert(locationDataTemporary, child)
			end
		end

		for _, player in ipairs(players) do
			if player ~= LocalPlayer3 and player.Character then
				local HumanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")

				if HumanoidRootPart and playervaluedetectedPlayerData(player.Character) and (HumanoidRootPart.Position - Position).Magnitude <= valueArgumentVisible then
					table.insert(locationDataTemporary, player.Character)
				end
			end
		end

		return locationDataTemporary
	end

	AttackNoCoolDown = function()
		local LocalPlayer4 = game:GetService("Players").LocalPlayer
		local Character = LocalPlayer4.Character

		if not Character then
			return
		end

		local attacknocooldownPlayerData
		local childInstancesSecondary, childInstancesTemporary, childInstancesPending = ipairs(Character:GetChildren())
		local attacknocooldownPlayerDataState = geniter(childInstancesSecondary, childInstancesTemporary, childInstancesPending)

		while true do
			local attacknocooldownCallResults = table.pack(attacknocooldownPlayerDataState())

			if not attacknocooldownCallResults[1] then
				break
			end

			local attacknocooldownPlayerDataData = attacknocooldownCallResults[3]

			if attacknocooldownPlayerDataData:IsA("Tool") then
				attacknocooldownPlayerData = attacknocooldownPlayerDataData

				break
			end
		end

		if not attacknocooldownPlayerData then
			return
		end

		local attacknocooldownPlayerDataEntry = playervaluecollectedPlayerData(Character, 60)

		if #attacknocooldownPlayerDataEntry == 0 then
			return
		end

		local ReplicatedStorage4 = game:GetService("ReplicatedStorage")
		local Modules = ReplicatedStorage4:FindFirstChild("Modules")

		if not Modules then
			return
		end

		local RERegisterAttack = ReplicatedStorage4:WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RE/RegisterAttack")
		local RERegisterHit = ReplicatedStorage4:WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RE/RegisterHit")

		if not RERegisterAttack or not RERegisterHit then
			return
		end

		local attacknocooldownEntriesState = {}
		local attacknocooldownResultData
		local attacknocooldownResult, attacknocooldownResultState, attacknocooldownResultEntry = ipairs(attacknocooldownPlayerDataEntry)

		for _, playervalueaiPlayerData in attacknocooldownResult, attacknocooldownResultState, attacknocooldownResultEntry do
			if not playervalueaiPlayerData:GetAttribute("IsBoat") then
				local attacknocooldownEntries = {
					"RightLowerArm",
					"RightUpperArm",
					"LeftLowerArm",
					"LeftUpperArm",
					"RightHand",
					"LeftHand"
				}
				local PrimaryPart = playervalueaiPlayerData:FindFirstChild(attacknocooldownEntries[math.random(#attacknocooldownEntries)]) or playervalueaiPlayerData.PrimaryPart

				if PrimaryPart then
					table.insert(attacknocooldownEntriesState, {
						playervalueaiPlayerData,
						PrimaryPart
					})
					attacknocooldownResultData = PrimaryPart
				end
			end
		end

		if not attacknocooldownResultData then
			return
		end

		RERegisterAttack:FireServer(0)

		local PlayerScripts = LocalPlayer4:FindFirstChild("PlayerScripts")

		if not PlayerScripts then
			return
		end

		local LocalScript = PlayerScripts:FindFirstChildOfClass("LocalScript")

		while not LocalScript do
			PlayerScripts.ChildAdded:Wait()
			LocalScript = PlayerScripts:FindFirstChildOfClass("LocalScript")
		end

		local SendHitsToServer

		if getsenv then
			local ok, resultassignedResult = pcall(getsenv, LocalScript)

			if ok and resultassignedResult then
				SendHitsToServer = resultassignedResult._G.SendHitsToServer
			end
		end

		local ok, resultassignedResult = pcall(function()
			return require(Modules.Flags).COMBAT_REMOTE_THREAD or false
		end)

		if ok and resultassignedResult and SendHitsToServer then
			SendHitsToServer(attacknocooldownResultData, attacknocooldownEntriesState)
		elseif ok and not resultassignedResult then
			RERegisterHit:FireServer(attacknocooldownResultData, attacknocooldownEntriesState)
		end
	end
end

CameraShakerR = require(game.ReplicatedStorage.Util.CameraShaker)
CameraShakerR:Stop()

do
	get_Monster = function()
		for _, child in pairs(workspace.Enemies:GetChildren()) do
			local UpperTorso = child:FindFirstChild("UpperTorso") or child:FindFirstChild("Head")

			if child:FindFirstChild("HumanoidRootPart", true) and UpperTorso and (child.Head.Position - LocalPlayer2.Character.HumanoidRootPart.Position).Magnitude <= 50 then
				return true, UpperTorso.Position
			end
		end

		for _, child in pairs(workspace.SeaBeasts:GetChildren()) do
			if child:FindFirstChild("HumanoidRootPart") and child:FindFirstChild("Health") and child.Health.Value > 0 then
				return true, child.HumanoidRootPart.Position
			end
		end

		for _, child in pairs(workspace.Enemies:GetChildren()) do
			if child:FindFirstChild("Health") and child.Health.Value > 0 and child:FindFirstChild("VehicleSeat") then
				return true, child.Engine.Position
			end
		end
	end
end

do
	Actived = function()
		local Tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
		local activedPlayerData, activedPlayerDataState = getconnections(Tool.Activated)

		for _, playervalueaiPlayerData in next, activedPlayerData, activedPlayerDataState do
			if typeof(playervalueaiPlayerData.Function) == "function" then
				getupvalues(playervalueaiPlayerData.Function)
			end
		end
	end
end

do
	task.spawn(function()
		connectScoped(RunSer.Heartbeat, function()
			pcall(function()
				if not _G.Seriality then
					return
				end

				AttackNoCoolDown()

				local Tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
				local ToolTip = Tool.ToolTip
				local activedPlayerDataData = get_Monster()

				if ToolTip == "Blox Fruit" and activedPlayerDataData then
					local LeftClickRemote = Tool:FindFirstChild("LeftClickRemote")

					if LeftClickRemote then
						Actived()
						LeftClickRemote:FireServer(Vector3.new(0.01, -500, 0.01), 1, true)
						LeftClickRemote:FireServer(false)
					end
				end
			end)
		end)
	end)
end

local Players2 = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage4 = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LocalPlayer3 = Players2.LocalPlayer

if not LocalPlayer3.Character then
	LocalPlayer3.CharacterAdded:Wait()
end

local function playervaluejPlayerData(valueArgumentAvailable, valueArgumentRequested)
	local _, resultassignedResult = pcall(function()
		return valueArgumentAvailable:WaitForChild(valueArgumentRequested)
	end)

	return resultassignedResult
end

local enemies = playervaluejPlayerData(Workspace, "Enemies")
local characters = playervaluejPlayerData(Workspace, "Characters")
local modules = playervaluejPlayerData(ReplicatedStorage4, "Modules")
local net = playervaluejPlayerData(modules, "Net")
local playerCollectionPrimary = {
	Rate = 2e-09,
	Enabled = true,
	IsAlive = function(targetEnemyItem)
		local Humanoid = targetEnemyItem:FindFirstChild("Humanoid")

		if Humanoid and Humanoid.Health > 0 then
			return true
		end

		return false
	end,
	GetNearbyTargets = function(getnearbytargetsInputState, getnearbytargetsInput)
		local Position = getnearbytargetsInputState:GetPivot().Position
		local locationDataPending = {}
		local children = getnearbytargetsInput:GetChildren()

		for i = 1, #children do
			local getnearbytargetsMovementData = children[i]
			local Humanoid = getnearbytargetsMovementData:FindFirstChild("Humanoid")
			local HumanoidRootPart = getnearbytargetsMovementData:FindFirstChild("HumanoidRootPart")

			if Humanoid and HumanoidRootPart and Humanoid.Health > 0 and (HumanoidRootPart.Position - Position).Magnitude <= 60 then
				table.insert(locationDataPending, getnearbytargetsMovementData)
			end
		end

		return locationDataPending
	end
}

local function getTargetParts(gettargetpartsArgument)
	local locationDataLatest = {}

	for i = 1, #gettargetpartsArgument do
		local gettargetpartsResult = gettargetpartsArgument[i]
		local Head = gettargetpartsResult:FindFirstChild("Head") or gettargetpartsResult.PrimaryPart

		if Head then
			table.insert(locationDataLatest, {
				gettargetpartsResult,
				Head
			})
		end
	end

	return locationDataLatest
end

playerCollectionPrimary.GetTargetParts = getTargetParts
playerCollectionPrimary.GetAllTargets = function(getalltargetsInput)
	local getalltargetsPlayerData = playerCollectionPrimary.GetNearbyTargets(getalltargetsInput, enemies)
	local getalltargetsPlayerDataState = playerCollectionPrimary.GetNearbyTargets(getalltargetsInput, characters)
	local playerCollectionTemporary = {}

	for i = 1, #getalltargetsPlayerData do
		table.insert(playerCollectionTemporary, getalltargetsPlayerData[i])
	end

	for i = 1, #getalltargetsPlayerDataState do
		table.insert(playerCollectionTemporary, getalltargetsPlayerDataState[i])
	end

	return playerCollectionTemporary
end
playerCollectionPrimary.ExecuteFastAttack = function()
	local Character = LocalPlayer3.Character

	if not Character then
		return
	end

	if not Character:FindFirstChildOfClass("Tool") then
		return
	end

	local executefastattackPlayerData = playerCollectionPrimary.GetAllTargets(Character)

	if #executefastattackPlayerData < 1 then
		return
	end

	local executefastattackPlayerDataState = playerCollectionPrimary.GetTargetParts(executefastattackPlayerData)

	if #executefastattackPlayerDataState < 1 then
		return
	end

	local reRegisterHit = net["RE/RegisterHit"]

	net["RE/RegisterAttack"]:FireServer(playerCollectionPrimary.Rate)
	reRegisterHit:FireServer(executefastattackPlayerDataState[1][2], executefastattackPlayerDataState)
end

local cachedTarget
local attribute

local function resultrequestedResult()
	for _, playervalueaiPlayerData in ipairs({
		ReplicatedStorage4.Util,
		ReplicatedStorage4.Common,
		ReplicatedStorage4.Remotes,
		ReplicatedStorage4.Assets,
		ReplicatedStorage4.FX
	}) do
		local children = playervalueaiPlayerData:GetChildren()

		for _, child in ipairs(children) do
			if child:IsA("RemoteEvent") and child:GetAttribute("Id") then
				cachedTarget = child
				attribute = child:GetAttribute("Id")
			end
		end

		connectScoped(playervalueaiPlayerData.ChildAdded, function(child)
			if child:IsA("RemoteEvent") and child:GetAttribute("Id") then
				cachedTarget = child
				attribute = child:GetAttribute("Id")
			end
		end)
	end
end

resultrequestedResult()

local playerCollectionSecondary = {
	Execute = function()
		local Character = LocalPlayer3.Character

		if not Character then
			return
		end

		local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

		if not HumanoidRootPart then
			return
		end

		local playerCollectionPending = {}

		local function playervalueoPlayerData(valueArgumentResolved)
			local children = valueArgumentResolved:GetChildren()

			for i = 1, #children do
				local playervalueoPlayerDataState = children[i]
				local Humanoid = playervalueoPlayerDataState:FindFirstChild("Humanoid")
				local HumanoidRootPart2 = playervalueoPlayerDataState:FindFirstChild("HumanoidRootPart")

				if Humanoid and HumanoidRootPart2 and Humanoid.Health > 0 and playervalueoPlayerDataState ~= Character and (HumanoidRootPart2.Position - HumanoidRootPart.Position).Magnitude <= 60 then
					local children2 = playervalueoPlayerDataState:GetChildren()

					for _, playervalueaiPlayerData in ipairs(children2) do
						if playervalueaiPlayerData:IsA("BasePart") then
							table.insert(playerCollectionPending, {
								playervalueoPlayerDataState,
								playervalueaiPlayerData
							})
						end
					end
				end
			end
		end

		playervalueoPlayerData(enemies)
		playervalueoPlayerData(characters)

		local Tool = Character:FindFirstChildOfClass("Tool")

		if #playerCollectionPending > 0 and Tool and (Tool:GetAttribute("WeaponType") == "Melee" or Tool:GetAttribute("WeaponType") == "Sword") then
			local response = modules.Net.seed:InvokeServer()
			local reRegisterHit = net["RE/RegisterHit"]

			net["RE/RegisterAttack"]:FireServer()

			local Head = playerCollectionPending[1][1]:FindFirstChild("Head")

			if not Head then
				return
			end

			reRegisterHit:FireServer(Head, playerCollectionPending, {})

			if cachedTarget then
				local playervalueoCalculatedValue = math.floor(Workspace:GetServerTimeNow() / 10 % 10) + 1
				local RegisterHit = string.gsub("RE/RegisterHit", ".", function(targetPlayer)
					return string.char(bit32.bxor(string.byte(targetPlayer), playervalueoCalculatedValue))
				end)
				local playervalueoResult = bit32.bxor(attribute + 909090, response * 2)

				cloneref(cachedTarget):FireServer(RegisterHit, playervalueoResult, Head, playerCollectionPending)
			end
		end
	end
}

local function resultstoredResult()
	require(ReplicatedStorage4.Util.CameraShaker):Stop()
end

do
	local function resultcomputedResult()
		task.spawn(function()
			while task.wait(playerCollectionPrimary.Rate) do
				playerCollectionPrimary.ExecuteFastAttack()
			end
		end)
		connectScoped(RunService.Heartbeat, function()
			pcall(playerCollectionSecondary.Execute)
		end)
	end

	resultcomputedResult()
end

-- All controls are registered. Their initial callbacks are now drained one by
-- one by the startup worker before movement automation is allowed to run.
startupState.registrationComplete = true
